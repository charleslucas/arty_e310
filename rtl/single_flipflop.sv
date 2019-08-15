// =================================
// Single Flip-Flop
// Copyright 2019
// Charles Lucas
// charles@lucas.net

// Double-Flop a signal after it's crossed a clock domain
// =================================

module single_flipflop #(
        parameter ACTIVE_EDGE = 0    // 0 = active high (trigger on negedge) , 1 = active low (trigger on posedge), 2 = trigger on either edge
        ) (
        input clk
        , input reset_n
        , input logic in
        , output logic out
        );
        
    logic signal1_ff;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            signal1_ff <= 1'b0;
        end
        else begin
            signal1_ff <= in;
        end
    end

    always_comb out = signal1_ff;  // Output the single-flopped signal
    
endmodule
