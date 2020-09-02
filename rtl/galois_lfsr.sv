// =================================
// Galois LFSR
// Copyright 2020
// Charles Lucas
// charles@lucas.net
// =================================

module galois_lfsr #(
          parameter LFSR_WIDTH                 = 16  // Number of bits in the shift register
        , parameter LFSR_SEED                  = 1   // Only bit 0 is high by default
        , parameter LFSR_OUTPUT_BITS_PER_CLOCK = 1
        //        , parameter LFSR_POLYNOMIAL            // Currently have a fixed polynomial
        ) (
          input  logic                                  clk
        , input  logic                                  reset_n

        , input  logic                                  enable
        , output logic [LFSR_OUTPUT_BITS_PER_CLOCK-1:0] lfsr_out
        , output logic                                  lfsr_valid
        );
  
    logic                  initialize;
    logic [LFSR_WIDTH-1:0] lfsr;
    logic [LFSR_WIDTH-1:0] lfsr_next;
  
    generate
        if (LFSR_OUTPUT_BITS_PER_CLOCK == 1) begin : g_lfsr_bits_per_clock_select_1
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^16 + x^5 + x^4 + x^3 + 1

                    lfsr_next[0]  =            lfsr[15];
                    lfsr_next[1]  =            lfsr[0];
                    lfsr_next[2]  = lfsr[15] ^ lfsr[1];
                    lfsr_next[3]  = lfsr[15] ^ lfsr[2];
                    lfsr_next[4]  = lfsr[15] ^ lfsr[3];
                    lfsr_next[5]  =            lfsr[4];
                    lfsr_next[6]  =            lfsr[5];
                    lfsr_next[7]  =            lfsr[6];
                    lfsr_next[8]  =            lfsr[7];
                    lfsr_next[9]  =            lfsr[8];
                    lfsr_next[10] =            lfsr[9];
                    lfsr_next[11] =            lfsr[10];
                    lfsr_next[12] =            lfsr[11];
                    lfsr_next[13] =            lfsr[12];
                    lfsr_next[14] =            lfsr[13];
                    lfsr_next[15] =            lfsr[14];
                 end
                 else begin : g_lfsr_unspecified_bits_per_clock_1
                     lfsr_next = lfsr;
                 end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 2) begin : g_lfsr_bits_per_clock_select_2
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^16 + x^5 + x^4 + x^3 + 1

                    lfsr_next[0]  =                       lfsr[14];
                    lfsr_next[1]  =                       lfsr[15];
                    lfsr_next[2]  =            lfsr[14] ^ lfsr[0];
                    lfsr_next[3]  = lfsr[15] ^ lfsr[14] ^ lfsr[1];
                    lfsr_next[4]  = lfsr[15] ^ lfsr[14] ^ lfsr[2];
                    lfsr_next[5]  = lfsr[15]            ^ lfsr[3];
                    lfsr_next[6]  =                       lfsr[4];
                    lfsr_next[7]  =                       lfsr[5];
                    lfsr_next[8]  =                       lfsr[6];
                    lfsr_next[9]  =                       lfsr[7];
                    lfsr_next[10] =                       lfsr[8];
                    lfsr_next[11] =                       lfsr[9];
                    lfsr_next[12] =                       lfsr[10];
                    lfsr_next[13] =                       lfsr[11];
                    lfsr_next[14] =                       lfsr[12];
                    lfsr_next[15] =                       lfsr[13];
                end
                else begin : g_lfsr_unspecified_bits_per_clock_2
                    lfsr_next = lfsr;
                end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 3) begin : g_lfsr_bits_per_clock_select_3
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^16 + x^5 + x^4 + x^3 + 1

                    lfsr_next[0]  =                                  lfsr[13];
                    lfsr_next[1]  =                                  lfsr[14];
                    lfsr_next[2]  =                       lfsr[13] ^ lfsr[15];
                    lfsr_next[3]  =            lfsr[14] ^ lfsr[13] ^ lfsr[0];
                    lfsr_next[4]  = lfsr[15] ^ lfsr[14] ^ lfsr[13] ^ lfsr[1];
                    lfsr_next[5]  = lfsr[15] ^ lfsr[14]            ^ lfsr[2];
                    lfsr_next[6]  = lfsr[15]                       ^ lfsr[3];
                    lfsr_next[7]  =                                  lfsr[4];
                    lfsr_next[8]  =                                  lfsr[5];
                    lfsr_next[9]  =                                  lfsr[6];
                    lfsr_next[10] =                                  lfsr[7];
                    lfsr_next[11] =                                  lfsr[8];
                    lfsr_next[12] =                                  lfsr[9];
                    lfsr_next[13] =                                  lfsr[10];
                    lfsr_next[14] =                                  lfsr[11];
                    lfsr_next[15] =                                  lfsr[12];
                end
                else begin : g_lfsr_unspecified_bits_per_clock_3
                    lfsr_next = lfsr;
                end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 4) begin : g_lfsr_bits_per_clock_select_4
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^16 + x^5 + x^4 + x^3 + 1

                    lfsr_next[0]  =                                             lfsr[12];
                    lfsr_next[1]  =                                             lfsr[13];
                    lfsr_next[2]  =                                  lfsr[12] ^ lfsr[14];
                    lfsr_next[3]  =                       lfsr[13] ^ lfsr[12] ^ lfsr[15];
                    lfsr_next[4]  =            lfsr[14] ^ lfsr[13] ^ lfsr[12] ^ lfsr[0];
                    lfsr_next[5]  = lfsr[15] ^ lfsr[14] ^ lfsr[13]            ^ lfsr[1];
                    lfsr_next[6]  = lfsr[15] ^ lfsr[14]                       ^ lfsr[2];
                    lfsr_next[7]  = lfsr[15]                                  ^ lfsr[3];
                    lfsr_next[8]  =                                             lfsr[4];
                    lfsr_next[9]  =                                             lfsr[5];
                    lfsr_next[10] =                                             lfsr[6];
                    lfsr_next[11] =                                             lfsr[7];
                    lfsr_next[12] =                                             lfsr[8];
                    lfsr_next[13] =                                             lfsr[9];
                    lfsr_next[14] =                                             lfsr[10];
                    lfsr_next[15] =                                             lfsr[11];
                end
                else begin : g_lfsr_unspecified_bits_per_clock_4
                    lfsr_next = lfsr;
                end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 5) begin : g_lfsr_bits_per_clock_select_5
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^16 + x^5 + x^4 + x^3 + 1

                    lfsr_next[0]  = lfsr[15]                                             ^ lfsr[11];
                    lfsr_next[1]  =                                                        lfsr[12];
                    lfsr_next[2]  =                                             lfsr[12] ^ lfsr[13];
                    lfsr_next[3]  =                                  lfsr[12] ^ lfsr[12] ^ lfsr[14];
                    lfsr_next[4]  =                       lfsr[13] ^ lfsr[12] ^ lfsr[12] ^ lfsr[15];
                    lfsr_next[5]  =            lfsr[14] ^ lfsr[13] ^ lfsr[12]            ^ lfsr[0];
                    lfsr_next[6]  = lfsr[15] ^ lfsr[14] ^ lfsr[13]                       ^ lfsr[1];
                    lfsr_next[7]  = lfsr[15] ^ lfsr[14]                                  ^ lfsr[2];
                    lfsr_next[8]  =                                                        lfsr[3];
                    lfsr_next[9]  =                                                        lfsr[4];
                    lfsr_next[10] =                                                        lfsr[5];
                    lfsr_next[11] =                                                        lfsr[6];
                    lfsr_next[12] =                                                        lfsr[7];
                    lfsr_next[13] =                                                        lfsr[8];
                    lfsr_next[14] =                                                        lfsr[9];
                    lfsr_next[15] =                                                        lfsr[10];
                end
                else begin : g_lfsr_unspecified_bits_per_clock_5
                    lfsr_next = lfsr;
                end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 6) begin : g_lfsr_bits_per_clock_select_6
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^16 + x^5 + x^4 + x^3 + 1

                    lfsr_next[0]  = lfsr[15] ^ lfsr[14]                                             ^ lfsr[10];
                    lfsr_next[1]  = lfsr[15]                                                        ^ lfsr[11];
                    lfsr_next[2]  =                                                        lfsr[10] ^ lfsr[12];
                    lfsr_next[3]  =                                             lfsr[11] ^ lfsr[10] ^ lfsr[13];
                    lfsr_next[4]  =                                  lfsr[12] ^ lfsr[11] ^ lfsr[10] ^ lfsr[14];
                    lfsr_next[5]  =                       lfsr[13] ^ lfsr[12] ^ lfsr[11]            ^ lfsr[15];
                    lfsr_next[6]  =            lfsr[14] ^ lfsr[13] ^ lfsr[12]                       ^ lfsr[0];
                    lfsr_next[7]  = lfsr[15] ^ lfsr[14] ^ lfsr[13]                                  ^ lfsr[1];
                    lfsr_next[8]  =                                                                   lfsr[2];
                    lfsr_next[9]  =                                                                   lfsr[3];
                    lfsr_next[10] =                                                                   lfsr[4];
                    lfsr_next[11] =                                                                   lfsr[5];
                    lfsr_next[12] =                                                                   lfsr[6];
                    lfsr_next[13] =                                                                   lfsr[7];
                    lfsr_next[14] =                                                                   lfsr[8];
                    lfsr_next[15] =                                                                   lfsr[9];
                end
                else begin : g_lfsr_unspecified_bits_per_clock_6
                    lfsr_next = lfsr;
                end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 7) begin : g_lfsr_bits_per_clock_select_7
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^16 + x^5 + x^4 + x^3 + 1

                    lfsr_next[0]  = lfsr[15] ^ lfsr[14] ^ lfsr[13]                                            ^ lfsr[9];
                    lfsr_next[1]  = lfsr[15] ^ lfsr[14]                                                       ^ lfsr[10];
                    lfsr_next[2]  = lfsr[15]                                                        ^ lfsr[9] ^ lfsr[11];
                    lfsr_next[3]  =                                                        lfsr[10] ^ lfsr[9] ^ lfsr[12];
                    lfsr_next[4]  =                                             lfsr[11] ^ lfsr[10] ^ lfsr[9] ^ lfsr[13];
                    lfsr_next[5]  =                                  lfsr[12] ^ lfsr[11] ^ lfsr[10]           ^ lfsr[14];
                    lfsr_next[6]  =                       lfsr[13] ^ lfsr[12] ^ lfsr[11]                      ^ lfsr[15];
                    lfsr_next[7]  =            lfsr[14] ^ lfsr[13] ^ lfsr[12]                                 ^ lfsr[0];
                    lfsr_next[8]  =                                                                             lfsr[1];
                    lfsr_next[9]  =                                                                             lfsr[2];
                    lfsr_next[10] =                                                                             lfsr[3];
                    lfsr_next[11] =                                                                             lfsr[4];
                    lfsr_next[12] =                                                                             lfsr[5];
                    lfsr_next[13] =                                                                             lfsr[6];
                    lfsr_next[14] =                                                                             lfsr[7];
                    lfsr_next[15] =                                                                             lfsr[8];
                end
                else begin : g_lfsr_unspecified_bits_per_clock_7
                    lfsr_next = lfsr;
                end
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 8) begin : g_lfsr_bits_per_clock_select_8
            always_comb begin
                if (enable) begin : g_lfsr_enable
                    // Polynomial x^16 + x^5 + x^4 + x^3 + 1

                    lfsr_next[0]  =            lfsr[14] ^ lfsr[13] ^ lfsr[12]                                           ^ lfsr[8];
                    lfsr_next[1]  = lfsr[15] ^ lfsr[14] ^ lfsr[13]                                                      ^ lfsr[9];
                    lfsr_next[2]  = lfsr[15] ^ lfsr[14]                                                       ^ lfsr[8] ^ lfsr[10];
                    lfsr_next[3]  = lfsr[15]                                                        ^ lfsr[9] ^ lfsr[8] ^ lfsr[11];
                    lfsr_next[4]  =                                                        lfsr[10] ^ lfsr[9] ^ lfsr[8] ^ lfsr[12];
                    lfsr_next[5]  =                                             lfsr[11] ^ lfsr[10] ^ lfsr[9]           ^ lfsr[13];
                    lfsr_next[6]  =                                  lfsr[12] ^ lfsr[11] ^ lfsr[10]                     ^ lfsr[14];
                    lfsr_next[7]  =                       lfsr[13] ^ lfsr[12] ^ lfsr[11]                                ^ lfsr[15];
                    lfsr_next[8]  =                                                                                       lfsr[0];
                    lfsr_next[9]  =                                                                                       lfsr[1];
                    lfsr_next[10] =                                                                                       lfsr[2];
                    lfsr_next[11] =                                                                                       lfsr[3];
                    lfsr_next[12] =                                                                                       lfsr[4];
                    lfsr_next[13] =                                                                                       lfsr[5];
                    lfsr_next[14] =                                                                                       lfsr[6];
                    lfsr_next[15] =                                                                                       lfsr[7];
                end
                else begin : g_lfsr_unspecified_bits_per_clock_8
                    lfsr_next = lfsr;
                end
            end
        end
        else begin : g_lfsr_bits_per_clock_select_invalid
            // TODO - Add assertion - we should never hit this case
            always_comb lfsr_next = lfsr;
        end
    endgenerate
  
    generate
        if (LFSR_WIDTH == 1) begin : g_lfsr_one_bit
            always_comb lfsr_out = lfsr[LFSR_WIDTH-1];
        end
        else begin : g_lfsr_multiple_bits
            always_comb lfsr_out[LFSR_OUTPUT_BITS_PER_CLOCK-1:0] = lfsr[LFSR_WIDTH-1:LFSR_WIDTH-LFSR_OUTPUT_BITS_PER_CLOCK];
        end
    endgenerate
  
    always_comb lfsr_valid = ~initialize && enable;  // Eventually we may need to initialize for multiple clocks
  
    always @ (posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            initialize  <= 1'b1;  // Initialize for one clock after reset is deasserted
            lfsr        <= LFSR_SEED;
        end
        else begin
            initialize  <= 1'b0;
            lfsr        <= lfsr_next;
        end
    end

endmodule
