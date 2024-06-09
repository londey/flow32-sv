
// Note: Comment out this line when building in iCEcube2:
//`include "Sync_To_Count.v"


module Top 
 #(//parameter SUB_PIXEL_WIDTH = 3,
)(
    input wire clock
    input wire i_reset
    input UART_RX,
    output UART_TX
);
    // assign UART_TX = UART_RX;
  // wire w_VSync;
  // wire w_HSync;
  
  
  // // Patterns have 16 indexes (0 to 15) and can be g_Video_Width bits wide
  // wire [SUB_PIXEL_WIDTH-1:0] Pattern_Red[0:15];
  // wire [SUB_PIXEL_WIDTH-1:0] Pattern_Grn[0:15];
  // wire [SUB_PIXEL_WIDTH-1:0] Pattern_Blu[0:15];
  
  // // Make these unsigned counters (always positive)
  // wire [9:0] w_Col_Count;
  // wire [9:0] w_Row_Count;

  // wire [6:0] w_Bar_Width;
  // wire [2:0] w_Bar_Select;
  
  // Sync_To_Count #(.TOTAL_COLS(TOTAL_COLS),
  //                 .TOTAL_ROWS(TOTAL_ROWS))
  
  // UUT (.i_Clk      (i_Clk),
  //      .i_HSync    (i_HSync),
  //      .i_VSync    (i_VSync),
  //      .o_HSync    (w_HSync),
  //      .o_VSync    (w_VSync),
  //      .o_Col_Count(w_Col_Count),
  //      .o_Row_Count(w_Row_Count)
  //     );
	  
  
  // // Register syncs to align with output data.
  // always_ff @(posedge i_Clk)
  // begin
  //   o_vsync <= w_vsync;
  //   o_hsync <= w_hsync;
  // end
  

endmodule
