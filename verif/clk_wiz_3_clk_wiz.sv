// =================================
// Behavioral Model for 2x speed clock (Input 100Mhz, output 202Mhz)
// Copyright 2019
// Charles Lucas
// charles@lucas.net
// =================================

`timescale 1ps/1ps

module clk_wiz_3_clk_wiz 
        (
          input  logic  clk_in1
        , input  logic  resetn

        , output logic  clk_out1
        , output logic  locked
        );
    
    logic clk_out1_next;

    assign clk_out1_next = ~clk_out1;
    assign locked = 1'b1;  // Behavioral, we are always locked

    always @ (posedge clk_in1 or negedge resetn) begin
        if (~resetn) begin
            clk_out1 <= 1'b0;
        end
        else begin
                  clk_out1 <= 1'b1;
            #25.5 clk_out1 <= 1'b0;
            #25.5 clk_out1 <= 1'b1;
            #25.5 clk_out1 <= 1'b0;
        end
    end
    
endmodule