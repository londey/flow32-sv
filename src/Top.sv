

module Top 
 #(
    CLK_FREQ = 48_000_000,
    UART_CLK_FREQ = 115_200, 
)(
    input CLK,
    input ICE_PB,
    input UART_RX,
    output LED_R,
    output UART_TX
);
    localparam CYCLES_PER_UART_CLOCK = CLK_FREQ / UART_CLK_FREQ;
    localparam SLEEP_CYCLES = CLK_FREQ;

    typedef enum {
        IDLE = 0,
        UART_START_BIT,
        DATA_BITS,
        UART_STOP_BIT
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

    // assign LED_R = UART_TX;

    always_ff @(posedge CLK) begin
        if (ICE_PB == 0) begin
            uart_tx_data <= 8'b0110_0001; // "a"
            uart_tx_clock_counter <= 0;
            uart_sleep_interval_counter <= 0;
            uart_tx_state <= uart_state_e::IDLE;
        end else begin

            case (uart_tx_state)
            
                uart_state_e::IDLE: begin
                    UART_TX <= !1'b0;
                    uart_tx_clock_counter <= 0;
                    uart_tx_data_bit_index <= 0;

                    if (uart_sleep_interval_counter == SLEEP_CYCLES) begin
                        uart_sleep_interval_counter <= 0;
                        uart_tx_state <= uart_state_e::UART_START_BIT;
                    end else begin
                        uart_sleep_interval_counter <= uart_sleep_interval_counter + 1;
                        uart_tx_state <= uart_state_e::IDLE;
                    end
                end

                uart_state_e::UART_START_BIT: begin
                    UART_TX <= !1'b0;
                    uart_sleep_interval_counter <= 0;
                    uart_tx_data_bit_index <= 0;

                    if (uart_tx_clock_counter == CYCLES_PER_UART_CLOCK) begin
                        uart_tx_clock_counter <= 0;
                        uart_tx_state <= uart_state_e::DATA_BITS;
                    end else begin
                        uart_tx_clock_counter <= uart_tx_clock_counter + 1;
                        uart_tx_state <= uart_state_e::UART_START_BIT;
                    end
                end

                uart_state_e::DATA_BITS: begin
                    uart_sleep_interval_counter <= 0;
                    UART_TX <= !uart_tx_data[uart_tx_data_bit_index];

                    if (uart_tx_clock_counter == CYCLES_PER_UART_CLOCK) begin
                        uart_tx_clock_counter <= 0;
                        if (uart_tx_data_bit_index == 7) begin
                            uart_tx_data_bit_index <= 0;
                            uart_tx_state <= uart_state_e::UART_STOP_BIT;
                        end else begin
                            uart_tx_data_bit_index <= uart_tx_data_bit_index + 1;
                            uart_tx_state <= uart_state_e::DATA_BITS;
                        end
                    end else begin
                        uart_tx_clock_counter <= uart_tx_clock_counter + 1;
                    end
                end

                uart_state_e::UART_STOP_BIT: begin
                    UART_TX <= !1'b0;
                    uart_sleep_interval_counter <= 0;
                    uart_tx_data_bit_index <= 0;

                    if (uart_tx_clock_counter == CYCLES_PER_UART_CLOCK) begin
                        uart_tx_clock_counter <= 0;
                        uart_tx_state <= uart_state_e::IDLE;
                    end else begin
                        uart_tx_clock_counter <= uart_tx_clock_counter + 1;
                        uart_tx_state <= uart_state_e::UART_STOP_BIT;
                    end
                end

            endcase
        end
    end


endmodule
