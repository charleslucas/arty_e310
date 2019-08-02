// =================================
// General-Purpose FIFO
// Copyright 2019
// Charles Lucas
// charles@lucas.net
// =================================

module fifo #(
        parameter FIFO_WIDTH = 8
        , parameter FIFO_DEPTH = 2  // Must be a power of two
        ) (
        input  logic                  clk
        , input  logic                  reset_n

        , input  logic                  push
        , input  logic [FIFO_WIDTH-1:0] data_in

        , input  logic                  pop
        , output logic [FIFO_WIDTH-1:0] data_out
        , output logic                  data_out_valid

        , output logic                  full
        , output logic                  empty
        );
  
    localparam PTR_WIDTH = $clog2(FIFO_DEPTH);
  
    logic [PTR_WIDTH-1:0] push_ptr_next ;
    logic [PTR_WIDTH-1:0] push_ptr      ;
    logic [PTR_WIDTH-1:0] push_ptr_plus_one;

    logic [PTR_WIDTH-1:0] pop_ptr_next  ;
    logic [PTR_WIDTH-1:0] pop_ptr       ;
  
    logic [FIFO_WIDTH-1:0] fifo_data [FIFO_DEPTH-1:0];
    logic [FIFO_WIDTH-1:0] fifo_data_next;
  
    always_comb empty = (push_ptr          == pop_ptr);

    always_comb push_ptr_plus_one = push_ptr + 1;
    always_comb full  = (push_ptr_plus_one == pop_ptr);
  
    always_comb push_ptr_next  = (push && !full) ? push_ptr + 1 : push_ptr;
    always_comb pop_ptr_next   = (pop && !empty) ? pop_ptr  + 1 : pop_ptr;
    always_comb data_out_valid = ~empty;
    always_comb data_out       = fifo_data[pop_ptr];
    always_comb fifo_data_next = (push && !full) ? data_in      : fifo_data[push_ptr];
  
    always @ (posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            push_ptr <= 'b0;
            pop_ptr  <= 'b0;
        end
        else begin
            push_ptr <= push_ptr_next;
            pop_ptr  <= pop_ptr_next;
        end
        fifo_data[push_ptr] <= fifo_data_next;
    end

endmodule
