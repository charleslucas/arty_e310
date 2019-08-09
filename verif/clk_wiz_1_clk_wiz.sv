// =================================
// Behavioral Model for 1/2 speed clock (Input 100Mhz, output 50Mhz)
// Copyright 2019
// Charles Lucas
// charles@lucas.net
// =================================

`timescale 1ps/1ps

module clk_wiz_1_clk_wiz 

        (// Clock in ports
        // Clock out ports
        output logic  clk_out1,
        // Status and control signals
        input  logic  resetn,
        output logic  locked,
        input  logic  clk_in1
        );

    assign locked = 1'b1;

    always @ (posedge clk_in1 or negedge resetn) begin
        if (~resetn) begin
            clk_out1 <= 1'b0;
        end
        else begin
            clk_out1 <= ~clk_out1;
        end
    end
    
endmodule