// =================================
// Design Top-Level for Xilinx XC7A35T FPGA
// Copyright 2019
// Charles Lucas
// charles@lucas.net
// =================================

module xc7a35t_top (
         input CLK100MHZ
       , input RESET_N
       , input btn
       , input sw
       , output [3:0] led
       , output led0_g
       , output led1_b
    );


localparam LFSR_WIDTH                 = 8;
localparam LFSR_SEED                  = 1;
localparam LFSR_OUTPUT_BITS_PER_CLOCK = 4;

localparam FIFO_WIDTH                 = 4;  // This should match LFSR_OUTPUT_BITS_PER_CLOCK, if not adjust assignment below
localparam FIFO_DEPTH                 = 16;

logic                                  lfsr0_enable;

logic [LFSR_OUTPUT_BITS_PER_CLOCK-1:0] lfsr0_out;
logic [FIFO_WIDTH-1:0]                 fifo0_data_in;

logic [FIFO_WIDTH-1:0]                 fifo0_data_out;
logic                                  fifo0_data_out_valid;

logic fifo0_full;
logic fifo0_empty;

logic clk0_locked;
logic reset_n;


// Instantiate 50Mhz Clk with active-low reset input
clk_wiz_1_clk_wiz inst
    (
        // Clock out ports  
        .clk_out1(clk_out1),
        // Status and control signals               
        .resetn(RESET_N), 
        .locked(led0_g),
        // Clock in ports
        .clk_in1(CLK100MHZ)
    );


// Parallel Galois LFSR, outputs 4 pseudo-random bits per clock
galois_lfsr #(
          .LFSR_WIDTH                 (LFSR_WIDTH)
        , .LFSR_SEED                  (LFSR_SEED)  // Only bit 0 is high by default
        , .LFSR_OUTPUT_BITS_PER_CLOCK (LFSR_OUTPUT_BITS_PER_CLOCK)
        //, LFSR_POLYNOMIAL            ()          // Currently have a fixed polynomial
) galois_lfsr_0 (
          .clk        (clk_out1)
        , .reset_n    (RESET_N)

        // Inputs
        , .enable     (sw)

        // Outputs
        , .lfsr_out   (lfsr0_out)
        , .lfsr_valid (lfsr_valid)
);


always_comb fifo0_data_in = lfsr0_out;  // Adjust this if FIFO_WIDTH does not equal LFSR_OUTPUT_BITS_PER_CLOCK
       

// FIFO - 4 bits wide, store the output from the Galois LFSR
fifo #(
          .FIFO_WIDTH (FIFO_WIDTH)
        , .FIFO_DEPTH (FIFO_DEPTH)  // Must be a power of two
) fifo_0 (
          .clk            (clk_out1)
        , .reset_n        (RESET_N)

        , .push           (push)
        , .data_in        (fifo0_data_in)

        , .pop            (btn)
        , .data_out       (led)
        , .data_out_valid (led1_b)

        , .full           (fifo0_full)
        , .empty          (fifo0_empty)
);

endmodule
                