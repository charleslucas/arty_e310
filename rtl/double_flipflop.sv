// =================================
// Double Flip-Flop
// Copyright 2019
// Charles Lucas
// charles@lucas.net

// Double-Flop a signal after it's crossed a clock domain
// =================================

module double_flipflop #(
        parameter ACTIVE_EDGE = 0    // 0 = active high (trigger on negedge) , 1 = active low (trigger on posedge), 2 = trigger on either edge
        ) (
        input clk
        , input reset_n
        , input logic in
        , output logic out
        );
        
    logic signal1_ff;
    logic signal2_ff;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            signal1_ff <= 1'b0;
            signal2_ff <= 1'b0;
        end
        else begin
            signal1_ff <= in;
            signal2_ff <= signal1_ff;
        end
    end

    always_comb out = signal2_ff;  // Output the double-flopped signal
    
endmodule
