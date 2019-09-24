# arty_e310
# Charles Lucas
# charles@lucas.net

-----------------------------
External Documentation:
-----------------------------

  Arty Board Documentation:
    https://www.xilinx.com/products/boards-and-kits/arty.html#documentation

  SiFive Freedom E310 Arty FPGA Dev Kit Getting Started Guide (Only discusses Linux toolflow, not Windows)
    https://sifive.cdn.prismic.io/sifive/ed96de35-065f-474c-a432-9f6a364af9c8_sifive-e310-arty-gettingstarted-v1.0.6.pdf
  
  Digikey - Digilent Arty A7 with Xilinx Artix-7 Implementing SiFive FE310 RISC-V
    https://www.digikey.com/eewiki/display/LOGIC/Digilent+Arty+A7+with+Xilinx+Artix-7+Implementing+SiFive+FE310+RISC-V
  
  Embedded Security - Open Source Risc-V on the Xilinx Artix-7 35T Arty – Parts 1 and 2
    https://nm-projects.de/2017/06/open-source-risc-v-on-the-xilinx-artix-7-35t-arty/
    https://nm-projects.de/2017/06/open-source-risc-v-on-the-xilinx-artix-7-35t-arty-part-2/

  SiFive Freedom E300 Platform Reference Manual
    https://static.dev.sifive.com/SiFive-E300-platform-reference-manual-v1.0.1.pdf


-----------------------------
Project Documentation
-----------------------------
doc/Vivado_Setup.txt             - Set up the Vivado RTL compilation/debug and FPGA programming environment.
doc/RISCV_Setup.txt              - Set up the toolflow for compiling software for the RISC-V processor.
doc/FPGA_Programming.txt         - Program the Arty FPGA with either the pre-built example binary or a custom binary.
doc/RISCV_FPGA_Image.txt         - Set up the required tools and compile the complete FPGA image with a RISC-V processor.
doc/RISCV_Software_Loading.txt   - Set up the required tools, compile and load the RISC-V Linux OS and applications.
doc/Olimex_Debug.txt             - Use the Olimex debugger to analyze software running on the RISC-V processor.
doc/RISCV_Programming.txt        - Documentation about software development for the RISC-V processor.
doc/Technical_Reference.txt      - References and whitepapers regarding RTL and validation technical issues.
