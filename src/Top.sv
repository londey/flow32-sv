

module Top 
 #(
)(
    input wire CLK,
    input wire ICE_PB,
    output reg LED_R,
    output reg LED_G,
    output reg LED_B,
    output wire UART_TX,
    input wire UART_RX
);

    always_ff @(posedge CLK) begin

    end

    assign LED_R = UART_RX;
    assign LED_G = !UART_RX;
    assign LED_B = ICE_PB;

    assign UART_TX = UART_RX;

endmodule
