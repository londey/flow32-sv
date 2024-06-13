

module Top 
 #(
)(
    input wire CLK,
    input wire ICE_PB,
    output reg LED_R,
    output reg LED_G,
    output reg LED_B
);

    localparam N = 24;

    reg [N-1:0] counter;
    reg [1:0] led;

    
 
    always_ff @(posedge CLK) begin
        if (!ICE_PB) begin
            led <= 0;
            counter <= 1;
        end else if (counter == 0) begin
            led <= led + 1;
            counter <= counter + 1;
        end else begin
            counter <= counter + 1;
        end

        counter <= counter + 1;
    end

    assign LED_R = !(led == 2'b00);
    assign LED_G = !(led == 2'b01);
    assign LED_B = !(led == 2'b10);

endmodule
