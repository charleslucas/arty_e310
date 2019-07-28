// =================================
// Design Top-Level
// Copyright 2019
// Charles Lucas
// charles@lucas.net
// =================================

module top #();
	
localparam LFSR_WIDTH                 = 8;
localparam LFSR_SEED                  = 1;
localparam LFSR_OUTPUT_BITS_PER_CLOCK = 1;

localparam FIFO_WIDTH                 = 8;
localparam FIFO_DEPTH                 = 8;

logic                  lfsr0_enable;

logic [LFSR_WIDTH-1:0] lfsr0_out;
logic [FIFO_WIDTH-1:0] fifo0_data_in;

logic [FIFO_WIDTH-1:0] fifo0_data_out;
logic                  fifo0_data_out_valid;

logic fifo0_full;
logic fifo0_empty;

galois_lfsr #(
          .LFSR_WIDTH                 (LFSR_WIDTH)
		, .LFSR_SEED                  (LFSR_SEED)  // Only bit 0 is high by default
		, .LFSR_OUTPUT_BITS_PER_CLOCK (LFSR_OUTPUT_BITS_PER_CLOCK)
		//, LFSR_POLYNOMIAL            ()          // Currently have a fixed polynomial
) galois_lfsr_0 (
		  .clk        (clk)
		, .reset_n    (reset_n)

		// Inputs
		, .enable     (enable)

		// Outputs
		, .lfsr_out   (lfsr_out)
		, .lfsr_valid (lfsr_valid)
);

always_comb fifo0_data_in = {7'b0000000, lfsr_out};
		
fifo #(
          .FIFO_WIDTH (FIFO_WIDTH)
		, .FIFO_DEPTH (FIFO_DEPTH)  // Must be a power of two
) fifo_0 (
		, .clk            (clk)
		, .reset_n        (reset_n)

		, .push           (push)
		, .data_in        (fifo0_data_in)

		, .pop            (pop)
		, .data_out       (fifo0_data_out)
		, .data_out_valid (fifo0_data_out_valid)

		, full           (fifo0_full)
		, empty          (fifo0_empty)
);

endmodule
				