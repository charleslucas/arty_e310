// =================================
// Design Top-Level for Xilinx XC7A35T FPGA
// Copyright 2019
// Charles Lucas
// charles@lucas.net
// =================================

module xc7a35t_top (
         input CLK100MHZ
       , input RESET_N
       , input [1:0] btn
       , input [3:0] sw

       , output [3:0] led
       , output led0_b  // Clock locked
       , output led0_r  // LFSR0 Output Valid

       , output led1_b  // FIFO0 Output Valid
       , output led1_g  // FIFO0 Push
       , output led1_r  // FIFO0 Pop

       , output led2_b  // Test LEDs (connected to switches)
       , output led2_r  // Test LEDs (connected to switches)

       , output led3_r  // Test LEDs (connected to switches)
       , output led3_g  // Test LEDs (connected to switches)
       , output led3_b  // Test LEDs (connected to switches)
    );


localparam LFSR_WIDTH                 = 8;
localparam LFSR_SEED                  = 1;
localparam LFSR_OUTPUT_BITS_PER_CLOCK = 4;

localparam FIFO_WIDTH                 = 4;  // This should match LFSR_OUTPUT_BITS_PER_CLOCK, if not adjust assignment below
localparam FIFO_DEPTH                 = 16;

logic                                  clk_out1;
logic                                  clk0_locked;
logic                                  reset_n;

logic                                  btn0_pulse;  // Push into FIFO/Enable LFSR for one clock
logic                                  btn1_pulse;  // Pop from FIFO

logic                                  lfsr0_enable;

logic [LFSR_OUTPUT_BITS_PER_CLOCK-1:0] lfsr0_out;
logic                                  lfsr0_output_valid;

logic [FIFO_WIDTH-1:0]                 fifo0_data_in;

logic [FIFO_WIDTH-1:0]                 fifo0_data_out;
logic                                  fifo0_data_out_valid;

logic fifo0_full;
logic fifo0_empty;

// Tri-Color LED Assignments
assign led    = fifo0_data_out;
assign led0_r = lfsr0_output_valid;
assign led1_r = btn[1];
assign led1_b = fifo0_data_out_valid;
assign led1_g = btn[0];
assign led2_r = fifo0_full;
assign led2_b = fifo0_empty;
assign led3_r = sw[0] || sw[1];
assign led3_b = sw[0] || sw[2];    // Assign test LED outputs to switches
assign led3_g = sw[0] || sw[3];

// Instantiate 50Mhz Clk with active-low reset input
clk_wiz_1_clk_wiz inst
    (
        // Clock out ports  
        .clk_out1(clk_out1),
        // Status and control signals               
        .resetn(RESET_N), 
        .locked(led0_b),
        // Clock in ports
        .clk_in1(CLK100MHZ)
    );

// Create an edge detect pulse when button 0 is de-asserted
edge_detect btn0_edge_detect
    (
          .clk (clk_out1)
        , .reset_n(RESET_N)
        , .signal(btn[0])
        , .pulse(btn0_pulse) 
    );

// Create an edge detect pulse when button 0 is de-asserted
edge_detect btn1_edge_detect
    (
          .clk (clk_out1)
        , .reset_n(RESET_N)
        , .signal(btn[1])
        , .pulse(btn1_pulse) 
    );

assign lfsr0_enable = btn0_pulse & ~fifo0_full;

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
        , .enable     (lfsr0_enable)

        // Outputs
        , .lfsr_out   (lfsr0_out)
        , .lfsr_valid (lfsr0_output_valid)
);


always_comb fifo0_data_in = lfsr0_out;  // Adjust this if FIFO_WIDTH does not equal LFSR_OUTPUT_BITS_PER_CLOCK
       

// FIFO - 4 bits wide, store the output from the Galois LFSR
fifo #(
          .FIFO_WIDTH (FIFO_WIDTH)
        , .FIFO_DEPTH (FIFO_DEPTH)  // Must be a power of two
) fifo_0 (
          .clk            (clk_out1)
        , .reset_n        (RESET_N)

        , .push           (lfsr0_output_valid)
        , .data_in        (fifo0_data_in)

        , .pop            (btn1_pulse)
        , .data_out       (fifo0_data_out)
        , .data_out_valid ()

        , .empty          (fifo0_empty)
        , .full           (fifo0_full)
);

endmodule
                