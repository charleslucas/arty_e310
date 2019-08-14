// =================================
// TI Interface for xc7a35t_top
// Copyright 2019
// Charles Lucas
// charles@lucas.net
// =================================

// The default values in this interface drive the top-level parameters
// in the design, unless overridden in the TI
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

    logic [1:0]                   btn;
    logic [3:0]                   sw;

    logic [3:0]                   led;
  
    logic                         led0_b;
    logic                         led0_r;
    logic                         led1_b;
    logic                         led1_g;
    logic                         led1_r;
    logic                         led2_b;
    logic                         led2_r;
    logic                         led3_r;
    logic                         led3_b;
    logic                         led3_g;
  

    clocking cb @(posedge clk);
        //output reset_n;

        output                        btn;
        output                        sw;

        input                         led;
  
        input                         led0_b;
        input                         led0_r;
        input                         led1_b;
        input                         led1_g;
        input                         led1_r;
        input                         led2_b;
        input                         led2_r;
        input                         led3_r;
        input                         led3_b;
        input                         led3_g;
    endclocking

endinterface
