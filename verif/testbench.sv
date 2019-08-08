// =================================
// Top-Level Testbench for EDA Playground (testbench.sv)
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

//----------------
// environment env
//----------------
class env extends uvm_env;

    virtual design_if m_if;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction
  
    function void connect_phase(uvm_phase phase);
        `uvm_info("LABEL", "Started connect phase.", UVM_HIGH);
        // Get the interface from the resource database.
        assert(uvm_resource_db#(virtual design_if)::read_by_name(
                get_full_name(), "design_if", m_if));
        `uvm_info("LABEL", "Finished connect phase.", UVM_HIGH);
    endfunction: connect_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("LABEL", "Started run phase.", UVM_HIGH);
        begin
            int loop_count = 0;

            // Time 0 values
            m_if.cb.enable <= 1'b0;
            m_if.cb.pop    <= 1'b0;  // Not popping for now

            // Wait a clock for reset_n to be driven
            @(m_if.cb);

                // Wait for reset_n to be deasserted
            while (m_if.reset_n !== 1'b1) begin
                @(m_if.cb);
            end
            `uvm_info("LABEL", "Reset deasserted.", UVM_HIGH);
      
            // Wait a few clocks and then enable lfsr pattern generation
            repeat(10) @(m_if.cb);
            m_if.cb.enable <= 1'b1;

            // Wait for the fifo to fill up or our timeout limit to be reached
            while (m_if.cb.full !== 1'b1 && loop_count < 100) begin
                @(m_if.cb);
                loop_count = loop_count + 1;
            end
        
            `uvm_info("FINISHED", $sformatf("full = %0b, loop_count = %0d",
                    m_if.cb.full, loop_count), UVM_LOW);
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
            , .LFSR_OUTPUT_BITS_PER_CLOCK (2)

            , .FIFO_WIDTH                 (8)
            , .FIFO_DEPTH                 (32)          // Must be a power of two
        ) intf (
              .clk                        (clk)
            , .reset_n                    (reset_n)
        );

    // Reset and Clock Drivers
    initial begin
        clk = 1'b0;
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
    //passing the interface handle to lower heirarchy using set method 
    //and enabling the wave dump
    //---------------------------------------
    initial begin
        environment = new("env");

        // Publish the interface to the resource database.
        //uvm_resource_db#(virtual design_if)::set("env", "design_if", dut.design_if0);
        uvm_config_db#(virtual design_if)::set(uvm_root::get(),"*","design_if",intf);

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
    top #(
              .LFSR_WIDTH                 (intf.LFSR_WIDTH)
            , .LFSR_SEED                  (intf.LFSR_SEED)  // Only bit 0 is high by default
            , .LFSR_OUTPUT_BITS_PER_CLOCK (intf.LFSR_OUTPUT_BITS_PER_CLOCK)

            , .FIFO_WIDTH                 (intf.FIFO_WIDTH)
            , .FIFO_DEPTH                 (intf.FIFO_DEPTH)  // Must be a power of two
        ) DUT (
            // Connect the interface to the DUT RTL Signals
              .clk                        (intf.clk)
            , .reset_n                    (intf.reset_n)

            , .lfsr0_enable               (intf.enable)
    
            , .fifo0_pop                  (intf.pop)
            , .fifo0_data_out             (intf.data_out)
            , .fifo0_data_out_valid  (intf.data_out_valid)

            , .fifo0_full                 (intf.full)
            , .fifo0_empty                (intf.empty)
        );
  
endmodule
