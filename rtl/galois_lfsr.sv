// =================================
// Galois LFSR
// Copyright 2019
// Charles Lucas
// charles@lucas.net
// =================================

module galois_lfsr #(
		  parameter LFSR_WIDTH                 = 8
		, parameter LFSR_SEED                  = 1  // Only bit 0 is high by default
		, parameter LFSR_OUTPUT_BITS_PER_CLOCK = 1
		//		, parameter LFSR_POLYNOMIAL            // Currently have a fixed polynomial
		) (
		input  logic                                  clk
		, input  logic                                  reset_n

		, input  logic                                  enable
		, output logic [LFSR_OUTPUT_BITS_PER_CLOCK-1:0] lfsr_out
		, output logic                                  lfsr_valid
		);
  
	logic [LFSR_WIDTH-1:0] lfsr;
	logic [LFSR_WIDTH-1:0] lfsr_next;
	logic lfsr_valid_next;
  
	always_comb begin
		if (enable) begin
			// Polynomial x^8 + x^4 + x^3 + x^2 + 1
			lfsr_next[0] =           lfsr[7];
			lfsr_next[1] =           lfsr[0];
			lfsr_next[2] = lfsr[7] ^ lfsr[1];
			lfsr_next[3] = lfsr[7] ^ lfsr[2];
			lfsr_next[4] = lfsr[7] ^ lfsr[3];
			lfsr_next[5] =           lfsr[4];
			lfsr_next[6] =           lfsr[5];
			lfsr_next[7] =           lfsr[6];
		end
		else begin
			lfsr_next = lfsr;
		end
	end
  
	generate
		if (LFSR_WIDTH == 1) begin : g_lfsr_one_bit
			always_comb lfsr_out = lfsr[LFSR_WIDTH-1];
		end
		else begin : g_lfsr_multiple_bits
			always_comb lfsr_out[LFSR_OUTPUT_BITS_PER_CLOCK-1:0] = lfsr[LFSR_WIDTH-1:LFSR_WIDTH-LFSR_OUTPUT_BITS_PER_CLOCK];
		end
	endgenerate
  
	always_comb lfsr_valid_next = enable;
  
	always @ (posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			lfsr        <= LFSR_SEED;
			lfsr_valid  <= 1'b0;
		end
		else begin
			lfsr        <= lfsr_next;
			lfsr_valid  <= lfsr_valid_next;
		end
	end

endmodule
