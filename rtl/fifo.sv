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

        , output logic                  ack          // Pulses high 1 clock when input data is latched
        , output logic [FIFO_WIDTH-1:0] data_out

        , output logic                  full
        , output logic                  empty
        );
  
    localparam PTR_WIDTH = $clog2(FIFO_DEPTH) + 1;  // One extra bit for full/empty tracking
  
    logic [PTR_WIDTH-1:0] push_ptr_next ;
    logic [PTR_WIDTH-1:0] push_ptr      ;

    logic [PTR_WIDTH-1:0] pop_ptr_next  ;
    logic [PTR_WIDTH-1:0] pop_ptr       ;
  
    logic                  ack_next;
    logic [FIFO_WIDTH-1:0] fifo_data_next;
    logic [FIFO_WIDTH-1:0] fifo_data [FIFO_DEPTH-1:0];
  
    always_comb empty = (push_ptr[PTR_WIDTH-1:0] == pop_ptr[PTR_WIDTH-1:0]);  // All bits match
    always_comb full  = (push_ptr[PTR_WIDTH-2:0] == pop_ptr[PTR_WIDTH-2:0]) && (push_ptr[PTR_WIDTH-1] != pop_ptr[PTR_WIDTH-1]);  // Lower bits match, high bit is opposite
  
    always_comb ack_next       = (push && !full);
    always_comb push_ptr_next  = (push && !full) ? push_ptr + 1 : push_ptr;
    always_comb fifo_data_next = (push && !full) ? data_in      : fifo_data[push_ptr];

    always_comb pop_ptr_next   = (pop && !empty) ? pop_ptr  + 1 : pop_ptr;
    always_comb data_out       = fifo_data[pop_ptr];
  
    always @ (posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            ack      <= 1'b0;
            push_ptr <=  'b0;
            pop_ptr  <=  'b0;
            fifo_data[push_ptr] <= 'b0;
        end
        else begin
            ack      <= ack_next;
            push_ptr <= push_ptr_next;
            pop_ptr  <= pop_ptr_next;
            fifo_data[push_ptr] <= fifo_data_next;
        end
    end

endmodule
