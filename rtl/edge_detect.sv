// =================================
// Edge Detector
// Copyright 2019
// Charles Lucas
// charles@lucas.net

// Return a pulse upon the de-assertion of the input signal
// =================================

module edge_detect #(
        parameter bit ACTIVE_LOW = 0
        ) (
          input clk
        , input reset_n
        , input logic signal
        , output logic pulse
        );
        
    logic signal_ff;
    
    always_comb begin
        pulse = (signal == ACTIVE_LOW && signal_ff == !ACTIVE_LOW);  // Detect the edge when the signal is de-asserted
    end
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            signal_ff = 1'b0;
        end
        else begin
            signal_ff <= signal;
        end
    end
        
endmodule
