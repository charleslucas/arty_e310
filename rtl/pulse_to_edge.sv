// =================================
// Pulse-to-Edge Converter
// Copyright 2019
// Charles Lucas
// charles@lucas.net

// To cross a clock domain, convert a 1-clock pulse to an edge transition
// =================================

module pulse_to_edge #(
        parameter bit ACTIVE_LOW = 0  // Is our input pulse active-high or active-low?
        ) (
          input clk
        , input reset_n
        , input logic  pulse
        , output logic signal
        );
        
    logic pulse_detected;
    logic signal_ff;
    
    always_comb begin
        pulse_detected = (pulse == ~ACTIVE_LOW);  // Detect the input pulse
    end
    
    // Come out of reset at 0, then switch polarity only when a pulse is detected
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            signal_ff <= 1'b0;
        end
        else begin
            if (pulse_detected) begin
                signal_ff <= ~signal;
            end
            else begin
                signal_ff <= signal;
            end
        end
    end

    always_comb signal = signal_ff;
    
endmodule
