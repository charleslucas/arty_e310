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
        //        , parameter LFSR_POLYNOMIAL            // Currently have a fixed polynomial
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
    logic [LFSR_OUTPUT_BITS_PER_CLOCK-1:0] lfsr_out_next;
  
    generate
        if (LFSR_OUTPUT_BITS_PER_CLOCK == 1) begin : g_lfsr_bits_per_clock_select
            always_comb begin
                if (enable) begin : g_lfsr_enable
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
                 else begin : g_lfsr_unspecified_bits_per_clock
                     lfsr_next = lfsr;
                 end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 2) begin : g_lfsr_bits_per_clock_select
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^4 + x^3 + x^2 + 1
                    lfsr_next[0] =                     lfsr[6];
                    lfsr_next[1] =                     lfsr[7];
                    lfsr_next[2] =           lfsr[6] ^ lfsr[0];
                    lfsr_next[3] = lfsr[7] ^ lfsr[6] ^ lfsr[1];
                    lfsr_next[4] = lfsr[7] ^ lfsr[6] ^ lfsr[2];
                    lfsr_next[5] = lfsr[7]           ^ lfsr[3];
                    lfsr_next[6] =                     lfsr[4];
                    lfsr_next[7] =                     lfsr[5];
                end
                else begin : g_lfsr_unspecified_bits_per_clock
                    lfsr_next = lfsr;
                end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 3) begin : g_lfsr_bits_per_clock_select
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^4 + x^3 + x^2 + 1
                    lfsr_next[0] =                               lfsr[5];
                    lfsr_next[1] =                               lfsr[6];
                    lfsr_next[2] =                     lfsr[5] ^ lfsr[7];
                    lfsr_next[3] =           lfsr[6] ^ lfsr[5] ^ lfsr[0];
                    lfsr_next[4] = lfsr[7] ^ lfsr[6] ^ lfsr[5] ^ lfsr[1];
                    lfsr_next[5] = lfsr[7] ^ lfsr[6]           ^ lfsr[2];
                    lfsr_next[6] = lfsr[7]                     ^ lfsr[3];
                    lfsr_next[7] =                               lfsr[4];
                end
                else begin : g_lfsr_unspecified_bits_per_clock
                    lfsr_next = lfsr;
                end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 4) begin : g_lfsr_bits_per_clock_select
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^4 + x^3 + x^2 + 1
                    lfsr_next[0] =                                         lfsr[4];
                    lfsr_next[1] =                                         lfsr[5];
                    lfsr_next[2] =                               lfsr[4] ^ lfsr[6];
                    lfsr_next[3] =                     lfsr[5] ^ lfsr[4] ^ lfsr[7];
                    lfsr_next[4] =           lfsr[6] ^ lfsr[5] ^ lfsr[4] ^ lfsr[0];
                    lfsr_next[5] = lfsr[7] ^ lfsr[6] ^ lfsr[5]           ^ lfsr[1];
                    lfsr_next[6] = lfsr[7] ^ lfsr[6]                     ^ lfsr[2];
                    lfsr_next[7] = lfsr[7]                               ^ lfsr[3];
                end
                else begin : g_lfsr_unspecified_bits_per_clock
                    lfsr_next = lfsr;
                end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 5) begin : g_lfsr_bits_per_clock_select
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^4 + x^3 + x^2 + 1
                    lfsr_next[0] = lfsr[7]                                         ^ lfsr[3];
                    lfsr_next[1] =                                                   lfsr[4];
                    lfsr_next[2] =                                         lfsr[3] ^ lfsr[5];
                    lfsr_next[3] =                               lfsr[4] ^ lfsr[3] ^ lfsr[6];
                    lfsr_next[4] =                     lfsr[5] ^ lfsr[4] ^ lfsr[3] ^ lfsr[7];
                    lfsr_next[5] =           lfsr[6] ^ lfsr[5] ^ lfsr[4]           ^ lfsr[0];
                    lfsr_next[6] = lfsr[7] ^ lfsr[6] ^ lfsr[5]                     ^ lfsr[1];
                    lfsr_next[7] = lfsr[7] ^ lfsr[6]                               ^ lfsr[2];
                end
                else begin : g_lfsr_unspecified_bits_per_clock
                    lfsr_next = lfsr;
                end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 6) begin : g_lfsr_bits_per_clock_select
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^4 + x^3 + x^2 + 1
                    lfsr_next[0] = lfsr[7] ^ lfsr[6]                                         ^ lfsr[2];
                    lfsr_next[1] = lfsr[7]                                                   ^ lfsr[3];
                    lfsr_next[2] =                                                             lfsr[4];
                    lfsr_next[3] =                                         lfsr[3]           ^ lfsr[5];
                    lfsr_next[4] =                               lfsr[4] ^ lfsr[3]           ^ lfsr[6];
                    lfsr_next[5] =                     lfsr[5] ^ lfsr[4] ^ lfsr[3]           ^ lfsr[7];
                    lfsr_next[6] =           lfsr[6] ^ lfsr[5] ^ lfsr[4]                     ^ lfsr[0];
                    lfsr_next[7] = lfsr[7] ^ lfsr[6] ^ lfsr[5]                               ^ lfsr[1];
                end
                else begin : g_lfsr_unspecified_bits_per_clock
                    lfsr_next = lfsr;
                end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 7) begin : g_lfsr_bits_per_clock_select
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^4 + x^3 + x^2 + 1
                    lfsr_next[0] = lfsr[7] ^ lfsr[6] ^ lfsr[5]                                         ^ lfsr[1];
                    lfsr_next[1] = lfsr[7] ^ lfsr[6]                                                   ^ lfsr[2];
                    lfsr_next[2] = lfsr[7]                                                   ^ lfsr[1] ^ lfsr[3];
                    lfsr_next[3] =                                                   lfsr[2] ^ lfsr[1] ^ lfsr[4];
                    lfsr_next[4] =                                         lfsr[3] ^ lfsr[2] ^ lfsr[1] ^ lfsr[5];
                    lfsr_next[5] =                               lfsr[4] ^ lfsr[3] ^ lfsr[2]           ^ lfsr[6];
                    lfsr_next[6] =                     lfsr[5] ^ lfsr[4] ^ lfsr[3]                     ^ lfsr[7];
                    lfsr_next[7] =           lfsr[6] ^ lfsr[5] ^ lfsr[4]                               ^ lfsr[0];
                end
                else begin : g_lfsr_unspecified_bits_per_clock
                    lfsr_next = lfsr;
                end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 8) begin : g_lfsr_bits_per_clock_select
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^4 + x^3 + x^2 + 1
                    lfsr_next[0] =           lfsr[6] ^ lfsr[5] ^ lfsr[4]                                         ^ lfsr[0];
                    lfsr_next[1] = lfsr[7] ^ lfsr[6] ^ lfsr[5]                                                   ^ lfsr[1];
                    lfsr_next[2] = lfsr[7] ^ lfsr[6]                                                   ^ lfsr[0] ^ lfsr[2];
                    lfsr_next[3] = lfsr[7]                                                   ^ lfsr[1] ^ lfsr[0] ^ lfsr[3];
                    lfsr_next[4] =                                                   lfsr[2] ^ lfsr[1] ^ lfsr[0] ^ lfsr[4];
                    lfsr_next[5] =                                         lfsr[3] ^ lfsr[2] ^ lfsr[1]           ^ lfsr[5];
                    lfsr_next[6] =                               lfsr[4] ^ lfsr[3] ^ lfsr[2]                     ^ lfsr[6];
                    lfsr_next[7] =                     lfsr[5] ^ lfsr[4] ^ lfsr[3]                               ^ lfsr[7];
                end
                else begin : g_lfsr_unspecified_bits_per_clock
                    lfsr_next = lfsr;
                end
            end
        end
        else begin
            // TODO - Add assertion - we should never hit this case
            always_comb lfsr_next = lfsr;
        end
    endgenerate
  
    generate
        if (LFSR_WIDTH == 1) begin : g_lfsr_one_bit
            always_comb lfsr_out_next = lfsr[LFSR_WIDTH-1];
        end
        else begin : g_lfsr_multiple_bits
            always_comb lfsr_out_next[LFSR_OUTPUT_BITS_PER_CLOCK-1:0] = lfsr[LFSR_WIDTH-1:LFSR_WIDTH-LFSR_OUTPUT_BITS_PER_CLOCK];
        end
    endgenerate
  
    always_comb lfsr_valid_next = enable;
  
    always @ (posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            lfsr        <= LFSR_SEED;
            lfsr_valid  <= 1'b0;
            lfsr_out    <= 1'b0;
        end
        else begin
            lfsr        <= lfsr_next;
            lfsr_valid  <= lfsr_valid_next;
            lfsr_out    <= lfsr_out_next;  // Flop the output data so it lines up with lfsr_valid
        end
    end

endmodule
