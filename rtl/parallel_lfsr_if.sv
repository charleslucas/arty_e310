// =================================
// TI Interface for parallel lfsr
// Copyright 2019
// Charles Lucas
// charles@lucas.net
// =================================

interface parallel_lfsr_if (
        input  logic                clk
        , input  logic                reset_n
        );

    logic                         ready;
    logic [3:0]                   data;

    clocking cb @(posedge clk);
        output                        ready;
        output                        data;
    endclocking

endinterface : parallel_lfsr_if
