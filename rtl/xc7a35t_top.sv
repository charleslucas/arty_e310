// =================================
// Design Top-Level for Xilinx XC7A35T FPGA
// Copyright 2019
// Charles Lucas
// charles@lucas.net
// =================================

// Uncomment when simulating on EDA Playground
//`define EDA_PLAYGROUND

`ifdef EDA_PLAYGROUND
  `include "fifo.sv"
  `include "galois_lfsr.sv"
  `include "single_flipflop.sv"
  `include "double_flipflop.sv"
  `include "pulse_to_edge.sv"
  `include "edge_detect.sv"
  `include "clk_wiz_1_clk_wiz.sv"
  `include "clk_wiz_3_clk_wiz.sv"
`endif


module xc7a35t_top (
         input        CLK100MHZ
       , input        RESET_N    // TODO:  Synchronize the resets for each clock domain

       , input  [1:0] btn
       , input  [3:0] sw

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

logic                                  clk0_50;
logic                                  clk0_locked;

logic                                  clk1_200;
logic                                  clk1_locked;

logic                                  btn0_pulse;  // Push into FIFO/Enable LFSR for one clock
logic                                  btn1_pulse;  // Pop from FIFO

logic                                  lfsr0_enable;

logic [LFSR_OUTPUT_BITS_PER_CLOCK-1:0] lfsr0_out;
logic                                  lfsr0_output_valid;
logic                                  lfsr0_output_valid_sff;  // Single-flopped on the source domain
logic                                  lfsr0_output_valid_dff;  // Double-flopped on the destination domain

logic                                  fifo0_push;    // Take one input from the LFSR per button push
logic [FIFO_WIDTH-1:0]                 fifo0_data_in;

logic                                  fifo0_ack;
logic [FIFO_WIDTH-1:0]                 fifo0_data_out;
logic                                  fifo0_data_out_valid;

logic fifo0_full;
logic fifo0_empty;

logic fifo0_ack_edge;
logic fifo0_ack_pulse;

// Tri-Color LED Assignments
assign led    = (fifo0_empty) ? 'b0 : fifo0_data_out;  // If the FIFO is empty, blank the LEDs
assign led0_r = lfsr0_output_valid;
assign led0_b = clk0_locked;
assign led1_r = btn[1];
assign led1_b = fifo0_data_out_valid;
assign led1_g = btn[0];
assign led2_r = fifo0_full;
assign led2_b = fifo0_empty;
assign led3_r = sw[0] || sw[1];
assign led3_b = sw[0] || sw[2];    // Assign test LED outputs to switches
assign led3_g = sw[0] || sw[3];

// Instantiate 50Mhz Clk with active-low reset input
clk_wiz_1_clk_wiz clk_50_inst
    (
        // Clock out ports  
        .clk_out1(clk0_50),
        // Status and control signals               
        .resetn(RESET_N), 
        .locked(clk0_locked),
        // Clock in ports
        .clk_in1(CLK100MHZ)
    );

// Instantiate 202Mhz Clk with active-low reset input
clk_wiz_3_clk_wiz clk_200_inst
    (
        // Clock out ports  
        .clk_out1(clk1_200),
        // Status and control signals               
        .resetn(RESET_N), 
        .locked(clk1_locked),
        // Clock in ports
        .clk_in1(CLK100MHZ)
    );

// Create an edge detect pulse when button 0 is de-asserted
edge_detect btn0_edge_detect
    (
          .clk (clk1_200)
        , .reset_n(RESET_N)
        , .signal(btn[0])
        , .pulse(btn0_pulse) 
    );

// Create an edge detect pulse when button 0 is de-asserted
edge_detect btn1_edge_detect
    (
          .clk (clk1_200)
        , .reset_n(RESET_N)
        , .signal(btn[1])
        , .pulse(btn1_pulse) 
    );

assign lfsr0_enable = fifo0_ack_pulse;  // Clock-crossed signal from 200Mhz to 50Mhz

// Parallel Galois LFSR, outputs 4 pseudo-random bits per clock
galois_lfsr #(
          .LFSR_WIDTH                 (LFSR_WIDTH)
        , .LFSR_SEED                  (LFSR_SEED)  // Only bit 0 is high by default
        , .LFSR_OUTPUT_BITS_PER_CLOCK (LFSR_OUTPUT_BITS_PER_CLOCK)
        //, LFSR_POLYNOMIAL            ()          // Currently have a fixed polynomial
) galois_lfsr_0 (
          .clk        (clk0_50)
        , .reset_n    (RESET_N)

        // Inputs
        , .enable     (lfsr0_enable)

        // Outputs
        , .lfsr_out   (lfsr0_out)
        , .lfsr_valid (lfsr0_output_valid)
);

// Create an edge detect pulse when button 0 is de-asserted
single_flipflop lfsr0_output_valid_sff_gen
    (
        .clk (clk0_50)
        , .reset_n(RESET_N)
        , .in(lfsr0_output_valid)
        , .out(lfsr0_output_valid_sff) 
    );

// Create an edge detect pulse when button 0 is de-asserted
double_flipflop lfsr0_output_valid_dff_gen
    (
        .clk (clk1_200)
        , .reset_n(RESET_N)
        , .in(lfsr0_output_valid_sff)
        , .out(lfsr0_output_valid_dff) 
    );


always_comb fifo0_push = btn0_pulse && lfsr0_output_valid_dff;   // Take one input from the LFSR per button push
always_comb fifo0_data_in = lfsr0_out;                           // Adjust this if FIFO_WIDTH does not equal LFSR_OUTPUT_BITS_PER_CLOCK
always_comb fifo0_data_out_valid = ~fifo0_empty;

// FIFO - 4 bits wide, store the output from the Galois LFSR
fifo #(
          .FIFO_WIDTH (FIFO_WIDTH)
        , .FIFO_DEPTH (FIFO_DEPTH)  // Must be a power of two
) fifo_0 (
          .clk            (clk1_200)
        , .reset_n        (RESET_N)

        , .push           (fifo0_push)
        , .data_in        (fifo0_data_in)

        , .pop            (btn1_pulse)
        
        , .ack            (fifo0_ack)
        , .data_out       (fifo0_data_out)

        , .empty          (fifo0_empty)
        , .full           (fifo0_full)
);

// Create an edge detect pulse when button 0 is de-asserted
pulse_to_edge fifo0_ack_edge_convert
    (
          .clk (clk1_200)
        , .reset_n(RESET_N)
        , .pulse(fifo0_ack) 
        , .signal(fifo0_ack_edge)
    );

// Create an edge detect pulse when button 0 is de-asserted
edge_detect #(
        .ACTIVE_EDGE (2)  // Detect either edge transition
    )
    fifo0_ack_edge_detect
    (
          .clk (clk0_50)
        , .reset_n(RESET_N)
        , .signal(fifo0_ack_edge)
        , .pulse(fifo0_ack_pulse) 
    );


endmodule
