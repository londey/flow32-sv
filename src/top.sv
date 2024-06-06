// This module is designed for 640x480 with a 25 MHz input clock.
// All test patterns are being generated all the time.  This makes use of one
// of the benefits of FPGAs, they are highly parallelizable.  Many different
// things can all be happening at the same time.  In this case, there are several
// test patterns that are being generated simulatenously.  The actual choice of
// which test pattern gets displayed is done via the i_Pattern signal, which is
// an input to a case statement.

// Available Patterns:
// Pattern 0: Disables the Test Pattern Generator
// Pattern 1: All Red
// Pattern 2: All Green
// Pattern 3: All Blue
// Pattern 4: Checkerboard white/black
// Pattern 5: Color Bars
// Pattern 6: White Box with Border (2 pixels)

// Note: Comment out this line when building in iCEcube2:
//`include "Sync_To_Count.v"


module Top 
 #(parameter SUB_PIXEL_WIDTH = 3,
   parameter TOTAL_COLS = 800,
   parameter TOTAL_ROWS = 525,
   parameter ACTIVE_COLS = 640,
   parameter ACTIVE_ROWS = 480)
  (input wire clock
);
  
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
