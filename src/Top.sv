

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
        START_BIT,
        DATA_BITS,
        STOP_BIT
    } uart_state_e;

    uart_state_e uart_tx_state;


    reg [log2(CYCLES_PER_UART_CLOCK):0] uart_tx_counter;

    reg [9:0] uart_tx_bits;
    reg [3:0] uart_tx_bit_counter;
    reg [0:0] uart_tx_state;

    reg [24:0] uart_interval_counter;

    wire output;
    assign LED_R = output;
    assign UART_TX = output;

    always_ff @(posedge CLK) begin
        if (ICE_PB == 1b0)
            uart_tx_data <= 8'b1_0110_0001_1; // "a"
            uart_tx_counter <= 0;
            uart_tx_bit_counter <= 4'b0000;
            uart_interval_counter <= 0;
            uart_tx_state <= 0;
        else begin

            uart_interval_counter <= uart_interval_counter + 1;

            if (uart_interval_counter == 0) begin
                uart_tx_data <= 8'h61;
                uart_tx_counter <= 0;
                uart_tx_bit_counter <= 4'b0000;
                uart_tx_state <= 0;
            end else begin
                uart_tx_data <= 8'h61;
                uart_tx_counter <= 0;
                uart_tx_bit_counter <= 4'b0000;
                uart_tx_state <= 0;
            end
            if (uart_tx_counter == CYCLES_PER_UART_CLOCK) begin
                uart_tx_counter <= 0;
                uart_tx_state <= uart_tx_state + 1;
            end else begin
                uart_tx_counter <= uart_tx_counter + 1;
            end

            if (uart_tx_counter == 0) begin
                UART_TX <= 1'b0;
                uart_tx_counter <= uart_tx_counter + 1;
            end else if (uart_tx_counter == CYCLES_PER_UART_CLOCK - 1) begin
                UART_TX <= 1'b1;
                uart_tx_counter <= 0;
                uart_tx_data <= uart_tx_data << 1;
            end else begin
                UART_TX <= uart_tx_data[0];
                uart_tx_counter <= uart_tx_counter + 1;
            end
        end
    end


endmodule
