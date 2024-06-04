// Russell Merrick - http://www.nandland.com
//
// Creates a Single Port RAM. (Random Access Memory)
// Single port RAM has one port, so can only access one memory location at a time.
// Dual port RAM can read and write to different memory locations at the same time.
//
// WIDTH sets the width of the Memory created.
// DEPTH sets the depth of the Memory created.
// Likely tools will infer Block RAM if WIDTH/DEPTH is large enough.
// If small, tools will infer register-based memory.

module Ram1Port #(parameter WIDTH = 16, parameter DEPTH = 256) (
  input                     i_clk,
  // Shared address for writes and reads
  input [$clog2(DEPTH)-1:0] i_addr,
  // Write Interface
  input                     i_wr_dv,
  input [WIDTH-1:0]         i_wr_data,
  // Read Interface
  input                     i_rd_en,
  output reg                o_rd_dv,
  output reg [WIDTH-1:0]    o_rd_data
  );
  
  reg [WIDTH-1:0] r_mem [DEPTH-1:0];

  always @(posedge i_clk)
  begin
    // Handle writes to memory
    if (i_wr_dv)
    begin
      r_mem[i_addr] <= i_wr_data;
    end

    // Handle reads from memory
    o_rd_data <= r_mem[i_addr];
    o_rd_dv   <= i_rd_en; // Generate DV pulse
  end

endmodule
