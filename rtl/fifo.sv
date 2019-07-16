// Code your design here
module fifo #(
    parameter FIFO_WIDTH = 8
  , parameter FIFO_DEPTH = 16  // Must be a power of two
) (
    input  logic clk
  , input  logic reset_n

  , input  logic push
  , input  logic data_in[FIFO_WIDTH-1:0]

  , input  logic pop
  , output logic data_out[FIFO_WIDTH-1:0]
  , output logic data_out_valid

  , output logic full
  , output logic empty
);
  
  localparam PTR_WIDTH = $clog2(FIFO_WIDTH) + 1;
  
  logic [PTR_WIDTH-1:0] push_ptr      ;
  logic [PTR_WIDTH-1:0] push_ptr_next ;
  logic [PTR_WIDTH-1:0] pop_ptr       ;
  logic [PTR_WIDTH-1:0] pop_ptr_next  ;
  
  logic fifo_data[FIFO_DEPTH-1:0][FIFO_WIDTH-1:0];
  logic fifo_data_next[FIFO_WIDTH-1:0];
  
  always_comb empty = (push_ptr == pop_ptr);
  always_comb full  = (push_ptr == pop_ptr - 1);
  
  always_comb data_out_valid = (pop && !empty);
  always_comb data_out       = fifo_data[pop_ptr];
  always_comb push_ptr_next  = (push && !full) ? push_ptr + 1 : push_ptr;
  always_comb pop_ptr_next   = (pop && !empty) ? pop_ptr  + 1 : pop_ptr;
  always_comb fifo_data_next = (push && !full) ? data_in      : fifo_data[push_ptr];
  
  always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      push_ptr <= 'b0;
      pop_ptr  <= 'b0;
    end
    else begin
      push_ptr <= push_ptr_next;
      pop_ptr  <= pop_ptr_next;
      fifo_data[push_ptr] <= fifo_data_next;
    end
  end

endmodule;
