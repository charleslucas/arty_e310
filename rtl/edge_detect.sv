// =================================
// Edge Detector
// Copyright 2019
// Charles Lucas
// charles@lucas.net

// Return a pulse upon the de-assertion of the input signal
// =================================

module edge_detect #(
          parameter ACTIVE_EDGE = 0    // 0 = active high (trigger on negedge) , 1 = active low (trigger on posedge), 2 = trigger on either edge
        ) (
          input clk
        , input reset_n
        , input logic signal
        , output logic pulse
        );
        
    logic signal_ff;  // Flop the incoming signal for edge detection
    logic pulse_next; // 1-clock pulse output
    
    generate
        if (ACTIVE_EDGE == 0) begin: g_edge_detect_high      // Active High
           always_comb pulse_next = (signal == 1'b0 && signal_ff == 1'b1);  // Detect the edge when the signal is de-asserted
        end
        else if (ACTIVE_EDGE == 1) begin : g_edge_detect_low // Active Low
           always_comb pulse_next = (signal == 1'b1 && signal_ff == 1'b0);  // Detect the edge when the signal is de-asserted
        end
        else if (ACTIVE_EDGE == 2) begin : g_edge_detect_either // Either Edge
           always_comb pulse_next = (signal != signal_ff);  // Detect either edge
        end
        else begin
           always_comb pulse_next = 1'b0;  // ERROR
            // TODO:  Add assertion, we should never end up here
        end
    endgenerate
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            signal_ff <= 1'b0;
            pulse     <= 1'b0;
        end
        else begin
            signal_ff <= signal;
            pulse     <= pulse_next;
        end
    end
        
endmodule
