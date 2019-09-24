class parallel_lfsr_seq_item extends uvm_sequence_item;

    // LFSR data captured on one clock
    bit [3:0] lfsr_data;  // TODO:  Parameterize this to match RTL LFSR width
    bit       ready;
  
    // Utility Macro
    `uvm_object_utils_begin(parallel_lfsr_seq_item)
    `uvm_field_int(lfsr_data, UVM_ALL_ON)
    `uvm_field_int(ready, UVM_ALL_ON)
    `uvm_object_utils_end
  
    // Constructor
    function new (string name = "parallel_lfsr_seq_item");
        super.new(name);
    endfunction
  
endclass : parallel_lfsr_seq_item



class parallel_lfsr_monitor extends uvm_monitor;
  
    virtual parallel_lfsr_if vif;
  
    uvm_analysis_port #(parallel_lfsr_seq_item) item_collected_port;
  
    // Buffer to hold sampled data
    parallel_lfsr_seq_item trans_collected;
  
    `uvm_component_utils(parallel_lfsr_monitor)
  
    // new - constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
        trans_collected=new();
        item_collected_port = new("item_collected_port", this);
    endfunction : new

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual parallel_lfsr_if)::get(this, "", "lfsr_vif", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ", get_full_name(), ".lfsr_vif"});
    endfunction: build_phase
  
    // Run Phase
    virtual task run_phase(uvm_phase phase);
        forever begin
            // Sampling Logic
            @(posedge vif.clk);
            wait (vif.ready);
            trans_collected.lfsr_data = vif.data;
            item_collected_port.write(trans_collected); // Write collected data to output fifo
        end
    endtask:run_phase

endclass : parallel_lfsr_monitor

class parallel_lfsr_agent extends uvm_agent;
  
    `uvm_component_utils(parallel_lfsr_agent)
  
    // Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
  
    parallel_lfsr_monitor monitor;
  
    // Build Phase
    function void build_phase (uvm_phase phase);
        monitor = parallel_lfsr_monitor::type_id::create("monitor", this);
    endfunction : build_phase
  
endclass : parallel_lfsr_agent

class parallel_lfsr_scoreboard extends uvm_scoreboard;
  
    `uvm_component_utils(parallel_lfsr_scoreboard)
    uvm_analysis_imp#(parallel_lfsr_seq_item, parallel_lfsr_scoreboard) item_collected_export;
  
    // Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_collected_export = new("item_collected_export", this);
    endfunction : build_phase
  
    // Write
    virtual function void write(parallel_lfsr_seq_item data);
        $display("SCB:: LFSR Data Received");
        data.print();
    endfunction : write
  
    // Run Phase
    virtual task run_phase(uvm_phase phase);
        // Comparison Logic
    endtask : run_phase
  
endclass : parallel_lfsr_scoreboard
