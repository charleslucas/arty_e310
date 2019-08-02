// =================================
// Design Top-Level for EDA Playground (design.sv)
// Copyright 2019
// Charles Lucas
// charles@lucas.net
// =================================

`include "fifo.sv"
`include "galois_lfsr.sv"

module top #(
        parameter LFSR_WIDTH                 = 8
        , parameter LFSR_SEED                  = 1
        , parameter LFSR_OUTPUT_BITS_PER_CLOCK = 1

        , parameter FIFO_WIDTH                 = 8
        , parameter FIFO_DEPTH                 = 8
        ) (
        input  logic                  clk
        , input  logic                  reset_n
  
        , input  logic                  lfsr0_enable

        , input  logic                  fifo0_pop
        , output logic [FIFO_WIDTH-1:0] fifo0_data_out
        , output logic                  fifo0_data_out_valid

        , output logic                  fifo0_full
        , output logic                  fifo0_empty
        );
    
    logic [LFSR_OUTPUT_BITS_PER_CLOCK-1:0] lfsr0_out;
    logic                                  lfsr0_valid;

    logic                  fifo0_push;
    logic [FIFO_WIDTH-1:0] fifo0_data_in;

    galois_lfsr #(
            .LFSR_WIDTH                 (LFSR_WIDTH)
            , .LFSR_SEED                  (LFSR_SEED)  // Only bit 0 is high by default
            , .LFSR_OUTPUT_BITS_PER_CLOCK (LFSR_OUTPUT_BITS_PER_CLOCK)
            //, LFSR_POLYNOMIAL            ()          // Currently have a fixed polynomial
        ) galois_lfsr_0 (
            .clk        (clk)
            , .reset_n    (reset_n)

            // Inputs
            , .enable     (lfsr0_enable)

            // Outputs
            , .lfsr_out   (lfsr0_out)
            , .lfsr_valid (lfsr0_valid)
        );

    always_comb fifo0_push = lfsr0_valid;
    always_comb fifo0_data_in = {7'b0000000, lfsr0_out};
        
    fifo #(
            .FIFO_WIDTH (FIFO_WIDTH)
            , .FIFO_DEPTH (FIFO_DEPTH)  // Must be a power of two
        ) fifo_0 (
            .clk            (clk)
            , .reset_n        (reset_n)

            , .push           (fifo0_push)
            , .data_in        (fifo0_data_in)

            , .pop            (fifo0_pop)
            , .data_out       (fifo0_data_out)
            , .data_out_valid (fifo0_data_out_valid)

            , .full           (fifo0_full)
            , .empty          (fifo0_empty)
        );

endmodule


interface design_if #(
        parameter LFSR_WIDTH = 8
        , parameter LFSR_SEED  = 1
        , parameter LFSR_OUTPUT_BITS_PER_CLOCK = 1

        , parameter FIFO_WIDTH = 8
        , parameter FIFO_DEPTH = 32
        ) (
        input  logic                clk
        , input  logic                reset_n
        );

    logic                       enable;

    logic                       pop;
    logic      [FIFO_WIDTH-1:0] data_out;
    logic                       data_out_valid;

    logic                       full;
    logic                       empty;

    clocking cb @(posedge clk);
        //output reset_n;

        output enable;

        output pop;
        input data_out;
        input data_out_valid;

        input full;
        input empty;
    endclocking

endinterface

//---------------
// Interface bind (Bind the RTL side of the interface)
//---------------
//bind top design_if design_if0(
//    .clk            (clk)
//  , .reset_n        (reset_n)
//  , .enable         (lfsr0_enable)
//  , .pop            (fifo0_pop)
//  , .data_out       (fifo0_data_out)
//  , .data_out_valid (fifo0_data_out_valid)
//  , .full           (fifo0_full)
//  , .empty          (fifo0_empty)
//);
