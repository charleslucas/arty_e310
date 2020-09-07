// =================================
// Galois 8-bit Predictive LFSR
// Copyright 2020
// Charles Lucas
// charles@lucas.net
//
// Will generate up to 8 bits per clock
// =================================

module galois_lfsr #(
          parameter LFSR_WIDTH                 = 8   // Number of bits in the shift register
        , parameter LFSR_SEED                  = 1   // Only bit 0 is high by default
        , parameter LFSR_OUTPUT_BITS_PER_CLOCK = 1
        //, parameter LFSR_POLYNOMIAL                  // Currently have a fixed polynomial
        ) (
          input  logic                                  clk
        , input  logic                                  reset_n

        , input  logic                                  init
        , input  logic                                  enable
        , output logic [LFSR_OUTPUT_BITS_PER_CLOCK-1:0] out
        , output logic                                  valid
        , output logic [LFSR_WIDTH-1:0]                 state  // Temporary output for debug
        );
  
    logic                                  initialize;
    logic                                  initialize_next;
    logic [LFSR_WIDTH-1:0]                 state;
    logic [LFSR_WIDTH-1:0]                 state_next;
    logic [LFSR_OUTPUT_BITS_PER_CLOCK-1:0] out_next;
    logic                                  valid_next;
  
    initial begin
        bpc_g0:  assert (LFSR_OUTPUT_BITS_PER_CLOCK  > 0);  // Zero bits-per-clock is an invalid case
        bpc_le8: assert (LFSR_OUTPUT_BITS_PER_CLOCK <= 8);  // Eight bits-per-clock is our current maximum
    end

    generate
        if (LFSR_OUTPUT_BITS_PER_CLOCK == 1) begin : g_lfsr_bits_per_clock_select_1
            always_comb begin
                if (initialize) begin
                    state_next = LFSR_SEED;
                end
                else if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^5 + x^4 + x^3 + 1
                    state_next[0]  =            state[7] ;
                    state_next[1]  = state[0]            ;
                    state_next[2]  = state[1] ^ state[7] ;
                    state_next[3]  = state[2] ^ state[7] ;
                    state_next[4]  = state[3] ^ state[7] ;
                    state_next[5]  = state[4]            ;
                    state_next[6]  = state[5]            ;
                    state_next[7]  = state[6]            ;
                 end
                 else begin : g_lfsr_unspecified_bits_per_clock_1
                     state_next = state;
                 end
            end

            always_comb begin
                out_next = state[7];
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 2) begin : g_lfsr_bits_per_clock_select_2
            always_comb begin
                if (initialize) begin
                    state_next = LFSR_SEED;
                end
                else if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^5 + x^4 + x^3 + 1
                    state_next[0]  =                       state[6] ;
                    state_next[1]  =            state[7]            ;
                    state_next[2]  = state[0]            ^ state[6] ;
                    state_next[3]  = state[1] ^ state[7] ^ state[6] ;
                    state_next[4]  = state[2] ^ state[7] ^ state[6] ;
                    state_next[5]  = state[3] ^ state[7]            ;
                    state_next[6]  = state[4]                       ;
                    state_next[7]  = state[5]                       ;
                end
                else begin : g_lfsr_unspecified_bits_per_clock_2
                    state_next = state;
                end
            end

            always_comb begin
                out_next[0] = state[6];
                out_next[1] = state[7];
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 3) begin : g_lfsr_bits_per_clock_select_3
            always_comb begin
                if (initialize) begin
                    state_next = LFSR_SEED;
                end
                else if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^5 + x^4 + x^3 + 1
                    state_next[0]  =                                  state[5] ;
                    state_next[1]  =                       state[6]            ;
                    state_next[2]  =            state[7]            ^ state[5] ;
                    state_next[3]  = state[0]            ^ state[6] ^ state[5] ;
                    state_next[4]  = state[1] ^ state[7] ^ state[6] ^ state[5] ;
                    state_next[5]  = state[2] ^ state[7] ^ state[6]            ;
                    state_next[6]  = state[3] ^ state[7]                       ;
                    state_next[7]  = state[4]                                  ;
                end
                else begin : g_lfsr_unspecified_bits_per_clock_3
                    state_next = state;
                end
            end

            always_comb begin
                out_next[0] = state[5];
                out_next[1] = state[6];
                out_next[2] = state[7];
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 4) begin : g_lfsr_bits_per_clock_select_4
            always_comb begin
                if (initialize) begin
                    state_next = LFSR_SEED;
                end
                else if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^5 + x^4 + x^3 + 1
                    state_next[0]  =                                             state[4] ;
                    state_next[1]  =                                  state[5]            ;
                    state_next[2]  =                       state[6]            ^ state[4] ;
                    state_next[3]  =            state[7]            ^ state[5] ^ state[4] ;
                    state_next[4]  = state[0]            ^ state[6] ^ state[5] ^ state[4] ;
                    state_next[5]  = state[1] ^ state[7] ^ state[6] ^ state[5]            ;
                    state_next[6]  = state[2] ^ state[7] ^ state[6]                       ;
                    state_next[7]  = state[3] ^ state[7]                                  ;
                end
                else begin : g_lfsr_unspecified_bits_per_clock_4
                    state_next = state;
                end
            end

            always_comb begin
                out_next[0] = state[4];
                out_next[1] = state[5];
                out_next[2] = state[6];
                out_next[3] = state[7];
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 5) begin : g_lfsr_bits_per_clock_select_5
            always_comb begin
                if (initialize) begin
                    state_next = LFSR_SEED;
                end
                else if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^5 + x^4 + x^3 + 1
                    state_next[0]  =                                                        (state[3] ^ state[7]) ;
                    state_next[1]  =                                             state[4]                         ;
                    state_next[2]  =                                  state[5]            ^ (state[3] ^ state[7]) ;
                    state_next[3]  =                       state[6]            ^ state[4] ^ (state[3] ^ state[7]) ;
                    state_next[4]  =            state[7]            ^ state[5] ^ state[4] ^ (state[3] ^ state[7]) ;
                    state_next[5]  = state[0]            ^ state[6] ^ state[5] ^ state[4]                         ;
                    state_next[6]  = state[1] ^ state[7] ^ state[6] ^ state[5]                                    ;
                    state_next[7]  = state[2] ^ state[7] ^ state[6]                                               ;
                end
                else begin : g_lfsr_unspecified_bits_per_clock_5
                    state_next = state;
                end
            end

            always_comb begin
                out_next[0] = state[3] ^ state[7];
                out_next[1] = state[4];
                out_next[2] = state[5];
                out_next[3] = state[6];
                out_next[4] = state[7];
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 6) begin : g_lfsr_bits_per_clock_select_6
            always_comb begin
                if (initialize) begin
                    state_next = LFSR_SEED;
                end
                else if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^5 + x^4 + x^3 + 1
                    state_next[0]  =                                                                                (state[2] ^ state[7] ^ state[6]) ;
                    state_next[1]  =                                                        (state[3] ^ state[7])                                    ;
                    state_next[2]  =                                             state[4]                         ^ (state[2] ^ state[7] ^ state[6]) ;
                    state_next[3]  =                                  state[5]            ^ (state[3] ^ state[7]) ^ (state[2] ^ state[7] ^ state[6]) ;
                    state_next[4]  =                       state[6]            ^ state[4] ^ (state[3] ^ state[7]) ^ (state[2] ^ state[7] ^ state[6]) ;
                    state_next[5]  =            state[7]            ^ state[5] ^ state[4] ^ (state[3] ^ state[7])                                    ;
                    state_next[6]  = state[0]            ^ state[6] ^ state[5] ^ state[4]                                                            ;
                    state_next[7]  = state[1] ^ state[7] ^ state[6] ^ state[5]                                                                       ;
                end
                else begin : g_lfsr_unspecified_bits_per_clock_6
                    state_next = state;
                end
            end

            always_comb begin
                out_next[0] = state[2] ^ state[7] ^ state[6];
                out_next[1] = state[3] ^ state[7];
                out_next[2] = state[4];
                out_next[3] = state[5];
                out_next[4] = state[6];
                out_next[5] = state[7];
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 7) begin : g_lfsr_bits_per_clock_select_7
            always_comb begin
                if (initialize) begin
                    state_next = LFSR_SEED;
                end
                else if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^5 + x^4 + x^3 + 1
                    state_next[0]  =                                                                                                                   (state[1] ^ state[7] ^ state[6] ^ state[5]) ;
                    state_next[1]  =                                                                                (state[2] ^ state[7] ^ state[6])                                               ;
                    state_next[2]  =                                                        (state[3] ^ state[7])                                    ^ (state[1] ^ state[7] ^ state[6] ^ state[5]) ;
                    state_next[3]  =                                             state[4]                         ^ (state[2] ^ state[7] ^ state[6]) ^ (state[1] ^ state[7] ^ state[6] ^ state[5]) ;
                    state_next[4]  =                                  state[5]            ^ (state[3] ^ state[7]) ^ (state[2] ^ state[7] ^ state[6]) ^ (state[1] ^ state[7] ^ state[6] ^ state[5]) ;
                    state_next[5]  =                       state[6]            ^ state[4] ^ (state[3] ^ state[7]) ^ (state[2] ^ state[7] ^ state[6])                                               ;
                    state_next[6]  =            state[7]            ^ state[5] ^ state[4] ^ (state[3] ^ state[7])                                                                                  ;
                    state_next[7]  = state[0]            ^ state[6] ^ state[5] ^ state[4]                                                                                                          ;
                end
                else begin : g_lfsr_unspecified_bits_per_clock_7
                    state_next = state;
                end
            end

            always_comb begin
                out_next[0] = state[1] ^ state[7] ^ state[6] ^ state[5];
                out_next[1] = state[2] ^ state[7] ^ state[6];
                out_next[2] = state[3] ^ state[7];
                out_next[3] = state[4];
                out_next[4] = state[5];
                out_next[5] = state[6];
                out_next[6] = state[7];
            end
        end
        else if (LFSR_OUTPUT_BITS_PER_CLOCK == 8) begin : g_lfsr_bits_per_clock_select_8
            always_comb begin
                if (initialize) begin
                    state_next = LFSR_SEED;
                end
                else if (enable) begin : g_lfsr_enable
                    // Polynomial x^8 + x^5 + x^4 + x^3 + 1
                    state_next[0]  =                                                                                                                                                                (state[0] ^ state[6] ^ state[5] ^ state[4]) ;
                    state_next[1]  =                                                                                                                  (state[1] ^ state[7] ^ state[6] ^ state[5])                                               ;
                    state_next[2]  =                                                                               (state[2] ^ state[7] ^ state[6])                                               ^ (state[0] ^ state[6] ^ state[5] ^ state[4]) ;
                    state_next[3]  =                                                       (state[3] ^ state[7])                                    ^ (state[1] ^ state[7] ^ state[6] ^ state[5]) ^ (state[0] ^ state[6] ^ state[5] ^ state[4]) ;
                    state_next[4]  =                                            state[4]                         ^ (state[2] ^ state[7] ^ state[6]) ^ (state[1] ^ state[7] ^ state[6] ^ state[5]) ^ (state[0] ^ state[6] ^ state[5] ^ state[4]) ;
                    state_next[5]  =                                 state[5]            ^ (state[3] ^ state[7]) ^ (state[2] ^ state[7] ^ state[6]) ^ (state[1] ^ state[7] ^ state[6] ^ state[5])                                               ;
                    state_next[6]  =                      state[6]            ^ state[4] ^ (state[3] ^ state[7]) ^ (state[2] ^ state[7] ^ state[6])                                                                                             ;
                    state_next[7]  =           state[7]            ^ state[5] ^ state[4] ^ (state[3] ^ state[7])                                                                                                                                ;
                end
                else begin : g_lfsr_unspecified_bits_per_clock_8
                    state_next = state;
                end
            end

            always_comb begin
                out_next[0] = state[0]            ^ state[6] ^ state[5] ^ state[4];
                out_next[1] = state[1] ^ state[7] ^ state[6] ^ state[5];
                out_next[2] = state[2] ^ state[7] ^ state[6];
                out_next[3] = state[3] ^ state[7];
                out_next[4] = state[4];
                out_next[5] = state[5];
                out_next[6] = state[6];
                out_next[7] = state[7];
            end
        end
    endgenerate
  
    always_comb initialize_next = init;     // Reload the seed if the user sets init
    always_comb valid_next      = enable;
  
    always @ (posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            initialize  <= 1'b1;          // Initialize for one clock after reset is deasserted
            state       <= LFSR_SEED;
            valid       <= 1'b0;
            out         <= 'b0;
        end
        else begin
            initialize  <= initialize_next;
            state       <= state_next;
            valid       <= valid_next;
            out         <= out_next;
        end
    end

endmodule
