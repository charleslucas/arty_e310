// =================================
// Top-Level Testbench for EDA Playground v3 (testbench.sv)
// Copyright 2019
// Charles Lucas
// charles@lucas.net
// =================================
// Simulator:  Synopsys VCS 2014.10
// Compile and Run Options:
//   -timescale=1ns/1ns -sverilog +vcsd
//   +UVM_VERBOSITY=UVM_HIGH +access+r
// =================================
// Simulator:  Aldec Riviera Pro 2014.06
// Compile and Run Options:
//   -timescale 1ns/1ns -sv2k9
//   +UVM_VERBOSITY=UVM_HIGH +access+r
// =================================

import uvm_pkg::*;  // Needed for Aldec, but not for VCS
`include "uvm_macros.svh"
`include "design_if.sv"
`include "parallel_lfsr_if.sv"
`include "lfsr_agent.sv"

//----------------
// environment env
//----------------
class env extends uvm_env;

    virtual design_if m_if;
    virtual parallel_lfsr_if l_if;
  
    parallel_lfsr_agent lfsr_agent;
    parallel_lfsr_scoreboard lfsr_scoreboard;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
      
        lfsr_agent = parallel_lfsr_agent::type_id::create("lfsr_agent", this);
        lfsr_scoreboard = parallel_lfsr_scoreboard::type_id::create("lfsr_scoreboard", this);
    endfunction
  
    function void connect_phase(uvm_phase phase);
        `uvm_info("LABEL", "Started connect phase.", UVM_HIGH);

        // Get the interface from the resource database.
        assert(uvm_resource_db#(virtual design_if)::read_by_name(
                get_full_name(), "design_if", m_if));
        assert(uvm_resource_db#(virtual parallel_lfsr_if)::read_by_name(
                get_full_name(), "parallel_lfsr_if", l_if));
      
        // Connect the monitor output fifo to the scoreboard input fifo
        lfsr_agent.monitor.item_collected_port.connect(lfsr_scoreboard.item_collected_export);
      
        `uvm_info("LABEL", "Finished connect phase.", UVM_HIGH);
    endfunction: connect_phase

    task button_press (int button);
        m_if.cb.btn[button] <= 1'b1;

        repeat(4) @(m_if.cb);  // Button push lasts multiple clocks
        m_if.cb.btn[button] <= 1'b0;
    endtask
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("LABEL", "Started run phase.", UVM_HIGH);
        begin
            int loop_count = 0;

            // Time 0 values
            m_if.cb.btn <= 2'b00;
            m_if.cb.sw  <= 4'h0;

            // Wait a clock for reset_n to be driven
            @(m_if.cb);

                // Wait for reset_n to be deasserted
            while (m_if.reset_n !== 1'b1) begin
                @(m_if.cb);
            end
            `uvm_info("LABEL", "Reset deasserted.", UVM_HIGH);

            // Loop and fill up FIFO0 with data from LFSR0
            for (int i=0; i < 16; i = i + 1) begin 
                // Wait a few clocks and then push the button for FIFO0 to grab in input from LFSR0
                repeat(10) @(m_if.cb);
                button_press(0);
            end
            
            // Wait a few clocks for visibility in the waveform
            repeat(30) @(m_if.cb);

            // Try a couple more pushes to LFSR0, but these should be ignored since the FIFO is full
            for (int i=0; i < 2; i = i + 1) begin 
                // Wait a few clocks and then push the button for FIFO0 to grab in input from LFSR0
                repeat(10) @(m_if.cb);
                button_press(0);
            end
            
            // Wait a few clocks for visibility in the waveform
            repeat(30) @(m_if.cb);

            // Pop some data from LFSR0 - should see on LED[3:0] - should result in FIFO0 being empty
            for (int i=0; i < 16; i = i + 1) begin 
                // Wait a few clocks and then push the button for FIFO0 to grab in input from LFSR0
                repeat(10) @(m_if.cb);
                button_press(1);
            end

            // Wait a few clocks for visibility in the waveform
            repeat(30) @(m_if.cb);

            // Try a couple more pops from LFSR0 - should be ignored as FIFO0 is empty
            for (int i=0; i < 2; i = i + 1) begin 
                // Wait a few clocks and then push the button for FIFO0 to grab in input from LFSR0
                repeat(10) @(m_if.cb);
                button_press(1);
            end

            // Wait for the fifo to fill up or our timeout limit to be reached
            //while (m_if.cb.led2_r !== 1'b1 && loop_count < 100) begin

            // Run a little longer before exitting
            while (loop_count < 40) begin
                @(m_if.cb);
                loop_count = loop_count + 1;
            end
        
            `uvm_info("FINISHED", $sformatf("full = %0b, loop_count = %0d",
                    m_if.cb.led2_r, loop_count), UVM_LOW);
        end
        `uvm_info("LABEL", "Finished run phase.", UVM_HIGH);
        phase.drop_objection(this);
    endtask: run_phase
  
endclass

// =================================
// Test Island
// =================================
module ti #() ();
  
    env environment;
  
    bit clk;
    bit reset_n;
  
    //---------------------------------------
    // Interface Instance
    //   Top-Level parameter settings
    //---------------------------------------
    design_if #(
            .LFSR_WIDTH                 (8)
            , .LFSR_SEED                  (1)           // Only bit 0 is high by default
            , .LFSR_OUTPUT_BITS_PER_CLOCK (4)

            , .FIFO_WIDTH                 (4)
            , .FIFO_DEPTH                 (32)          // Must be a power of two
        ) intf (
            .clk                        (clk)
            , .reset_n                    (reset_n)
        );
  
    parallel_lfsr_if lfsr_intf (
            . clk                       (clk)
            , .reset_n                    (reset_n)
        );

    // Test Signal Drivers
    initial begin
        clk <= 1'b0;
        reset_n <= 1'b0;    // Assert reset_n from time 0
      
        #1000;
        reset_n <= 1'b1;    // De-assert reset_n
    end
  
    // Generate system clock
    initial begin
        forever begin
            #50 clk = ~clk;
        end
    end
  
    //---------------------------------------
    //passing the interface handle to lower hierarchy using set method 
    //and enabling the wave dump
    //---------------------------------------
    initial begin
        environment = new("env");

        // Publish the interface to the resource database.
        //uvm_resource_db#(virtual design_if)::set("env", "design_if", dut.design_if0);
        uvm_config_db#(virtual design_if)::set(uvm_root::get(),"*","design_if",intf);
        uvm_config_db#(virtual parallel_lfsr_if)::set(uvm_root::get(),"*","lfsr_vif",lfsr_intf);

        // Dump waves
        $dumpvars(0);
        $dumpfile("dump.vcd");
        $dumpvars;
    end
  
    //---------------------------------------
    //calling test
    //---------------------------------------
    initial begin 
        run_test();
    end
  
    //---------------------------------------
    //DUT instance
    //---------------------------------------
    xc7a35t_top #() DUT (
            // Connect the interface to the DUT RTL Signals
            .CLK100MHZ                  (intf.clk)
            , .RESET_N                    (intf.reset_n)
      
            , .btn                        (intf.btn)
            , .sw                         (intf.sw)
            , .led                        (intf.led)

            , .led0_b                     (intf.led0_b)
            , .led0_r                     (intf.led0_r)
            , .led1_b                     (intf.led1_b)
            , .led1_g                     (intf.led1_g)
            , .led1_r                     (intf.led1_r)
            , .led2_b                     (intf.led2_b)
            , .led2_r                     (intf.led2_r)
            , .led3_r                     (intf.led3_r)
            , .led3_b                     (intf.led3_b)
            , .led3_g                     (intf.led3_g)
        );
  
    //---------------------------------------
    //dot-path signals to monitor internal signals
    //---------------------------------------
    assign lfsr_intf.ready = DUT.lfsr0_output_valid;
    assign lfsr_intf.data  = DUT.lfsr0_out;
  
endmodule
