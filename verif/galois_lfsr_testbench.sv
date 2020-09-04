// =================================
// Test Island
// =================================
module ti #(
    parameter LFSR_WIDTH                 = 8
  , parameter LFSR_OUTPUT_BITS_PER_CLOCK = 6
) ();
  
    logic clk;
    logic reset_n;
    logic enable;
    logic init;
  
    logic [LFSR_OUTPUT_BITS_PER_CLOCK-1:0] lfsr_out;
    logic lfsr_valid;

    logic [LFSR_WIDTH-1:0] lfsr_state;
    logic [LFSR_WIDTH-1:0] lfsr_state_buffer;
    logic [LFSR_WIDTH-1:0] lfsr_state_buffer_next;
    logic [7:0]            lfsr_out_buffer;
    logic [7:0]            lfsr_out_buffer_next;

    int fd;  // file descriptor
      
    // Test Signal Drivers
    initial begin
        fd = $fopen ("./lfsrout.txt", "w");
        if (fd)  $display("File was opened successfully : %0d", fd);
        else     $display("File was NOT opened successfully : %0d", fd);

        clk     <= 1'b0;
        reset_n <= 1'b0;    // Assert reset_n from time 0
        init    <= 1'b0;
        enable  <= 1'b0;
      
        #1000;
        @(posedge clk);
        $display("Reset De-asserted");
        reset_n <= 1'b1;    // De-assert reset_n
      
        #1000;
        @(posedge clk);
        $display("LFSR Enabled");
        enable <= 1'b1;
      
        #100000;
        @(posedge clk);
        $fclose(fd);
        $finish;
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
        // Dump waves
        $dumpvars(0);
        $dumpfile("dump.vcd");
        $dumpvars;
    end
  
    //---------------------------------------
    //calling test
    //---------------------------------------
    //initial begin 
    //    run_test();
    //end
  
  	always_comb begin
      if (lfsr_valid) begin
        lfsr_out_buffer_next   = (lfsr_out_buffer << LFSR_OUTPUT_BITS_PER_CLOCK) | lfsr_out;
        lfsr_state_buffer_next = lfsr_state;
      end
      else begin
        lfsr_out_buffer_next   = lfsr_out_buffer;
        lfsr_state_buffer_next = lfsr_state_buffer;
      end
    end
  
    always @ (posedge clk or negedge reset_n) begin
        if (!reset_n) begin
          lfsr_out_buffer   <= '0;
          lfsr_state_buffer <= '0;
        end
        else begin
          lfsr_out_buffer   <= lfsr_out_buffer_next;
          lfsr_state_buffer <= lfsr_state_buffer_next;
        end
        
        if (lfsr_valid) begin
          if (fd)     $display(    "out/state : %8b  %8b",   lfsr_out_buffer, lfsr_state_buffer);
          if (fd)      $fwrite(fd, "out/state : %8b  %8b\n", lfsr_out_buffer, lfsr_state_buffer);
        end
    end
  
    //---------------------------------------
    //DUT instance
    //---------------------------------------
    galois_lfsr #(
        .LFSR_WIDTH                 (LFSR_WIDTH)
      , .LFSR_OUTPUT_BITS_PER_CLOCK (LFSR_OUTPUT_BITS_PER_CLOCK)
    ) DUT (
      // Connect the interface to the DUT RTL Signals
        .clk                        (clk)
      , .reset_n                    (reset_n)
      
      , .init                       (init)
      , .enable                     (enable)
      , .out                        (lfsr_out)
      , .valid                      (lfsr_valid)
      , .state                      (lfsr_state)
    );
  
endmodule
