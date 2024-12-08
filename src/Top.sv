



module Top 
 #(
    CLK_FREQ = 48_000_000,
    UART_CLK_FREQ = 115_200
)(
    input CLK,
    input ICE_PB,
    input UART_RX,
    output LED_R,
    output LED_G,
    output LED_B,
    output UART_TX
);
    localparam CYCLES_PER_UART_CLOCK = CLK_FREQ / UART_CLK_FREQ;
    localparam SLEEP_CYCLES = CLK_FREQ;

    reg [23:0] blue_blink_counter;

    always_ff @(posedge CLK) begin
        blue_blink_counter <= blue_blink_counter + 1;
    end

    assign LED_B = blue_blink_counter[23] && blue_blink_counter[22];
    assign LED_G = !LED_B;

    typedef enum {
        UART_STATE_IDLE = 2'h0,
        UART_STATE_START_BIT = 2'h1,
        UART_STATE_DATA_BITS = 2'h2,
        UART_STATE_STOP_BIT = 2'h3
    } uart_state_e;

    uart_state_e uart_tx_state;

    /// Counter for the number of cycles since the last UART clock
    reg [$clog2(CYCLES_PER_UART_CLOCK):0] uart_tx_clock_counter;

    /// 8-bit data to be transmitted
    reg [7:0] uart_tx_data;

    /// 3-bit counter for the current data bit being transmitted
    reg [2:0] uart_tx_data_bit_index;

    /// A counter for the number of CLK cycles till the next UART transmission starts
    reg [24:0] uart_sleep_interval_counter;



    always_ff @(posedge CLK) begin
        if (ICE_PB == 0) begin
            uart_tx_data <= 8'b0110_0001; // "a"
            uart_tx_clock_counter <= 0;
            uart_sleep_interval_counter <= 0;
            uart_tx_state <= UART_STATE_IDLE;
        end else begin

            case (uart_tx_state)
            
                UART_STATE_IDLE: begin
                    UART_TX <= !1'b0;
                    uart_tx_clock_counter <= 0;
                    uart_tx_data_bit_index <= 0;

                    if (uart_sleep_interval_counter == SLEEP_CYCLES) begin
                        uart_sleep_interval_counter <= 0;
                        uart_tx_state <= UART_STATE_START_BIT;
                    end else begin
                        uart_sleep_interval_counter <= uart_sleep_interval_counter + 1;
                        uart_tx_state <= UART_STATE_IDLE;
                    end
                end

                UART_STATE_START_BIT: begin
                    UART_TX <= !1'b0;
                    uart_sleep_interval_counter <= 0;
                    uart_tx_data_bit_index <= 0;

                    if (uart_tx_clock_counter == CYCLES_PER_UART_CLOCK) begin
                        uart_tx_clock_counter <= 0;
                        uart_tx_state <= UART_STATE_DATA_BITS;
                    end else begin
                        
                        uart_tx_clock_counter <= uart_tx_clock_counter + 1;
                        uart_tx_state <= UART_STATE_START_BIT;
                    end
                end

                UART_STATE_DATA_BITS: begin
                    uart_sleep_interval_counter <= 0;
                    UART_TX <= !uart_tx_data[uart_tx_data_bit_index];

                    if (uart_tx_clock_counter == CYCLES_PER_UART_CLOCK) begin
                        uart_tx_clock_counter <= 0;
                        if (uart_tx_data_bit_index == 7) begin
                            uart_tx_data_bit_index <= 0;
                            uart_tx_state <= UART_STATE_STOP_BIT;
                        end else begin
                            uart_tx_data_bit_index <= uart_tx_data_bit_index + 1;
                            uart_tx_state <= UART_STATE_DATA_BITS;
                        end
                    end else begin
                        uart_tx_clock_counter <= uart_tx_clock_counter + 1;
                    end
                end

                UART_STATE_STOP_BIT: begin
                    UART_TX <= !1'b0;
                    uart_sleep_interval_counter <= 0;
                    uart_tx_data_bit_index <= 0;

                    if (uart_tx_clock_counter == CYCLES_PER_UART_CLOCK) begin
                        uart_tx_clock_counter <= 0;
                        uart_tx_state <= UART_STATE_IDLE;
                    end else begin
                        uart_tx_clock_counter <= uart_tx_clock_counter + 1;
                        uart_tx_state <= UART_STATE_STOP_BIT;
                    end
                end

                default: begin
                    uart_tx_state <= UART_STATE_IDLE;
                end

            endcase
        end
    end


endmodule
