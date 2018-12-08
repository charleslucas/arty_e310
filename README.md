# arty_e310

Documentation:
-----------------------------

  Arty Board Documentation:
  https://www.xilinx.com/products/boards-and-kits/arty.html#documentation

  SiFive Freedom E310 Arty FPGA Dev Kit Getting Started Guide
  https://sifive.cdn.prismic.io/sifive/ed96de35-065f-474c-a432-9f6a364af9c8_sifive-e310-arty-gettingstarted-v1.0.6.pdf
  
  SiFive Freedom E300 Platform Reference Manual
  https://static.dev.sifive.com/SiFive-E300-platform-reference-manual-v1.0.1.pdf


Software Setup:
-----------------------------

Platform:  Windows 10

Editor:  Eclipse with the SVEditor plugin

Install Ubuntu on a virtual machine.
  Only a minimal install is necessary, but give yourself at least 120G HD and 3GB of RAM.
  If you have only 2GB of RAM the "make <board> mcs" step will fail with this message:  /opt/Xilinx/Vivado/2018.2/bin/loader: line 194: 11809 Killed $RDI_PROG

Install git, make, java, gcc, dtc, python:
  sudo apt install git
  sudo apt install make
  sudo apt install default-jdk
  sudo apt install gcc
  sudo apt install device-tree-compiler
  sudo apt install python
  
Download and install latest version of Vivado HL Design Edition (12.5G Download!):
  https://www.xilinx.com/support/download.html
  http://xilinx.com/getlicense
  
Make sure to install the proper board files in Vivado:
  https://reference.digilentinc.com/reference/software/vivado/board-files

Install the drivers to talk to the Arty board over USB/FTDI.
  Instructions in the Arty Getting Started Guide - seach for "drivers"
  (Instructions say that ttyUSB* should be under the plugdev group, but on my VM they were under the dialout group instead, so I added myself to that group)
  
  Instructions how to install Xilinx cable drivers:
  https://www.xilinx.com/support/answers/59128.html
  cd /opt/Xilinx/Vivado/2018.2/data/xicom/cable_drivers/lin64/install_script/install_drivers
  
  Connect USB Device:
    In Virtual Machine, connect Host Machine's USB Device "Digilent USB Device" to the virtual machine.

   To verify USB Device is connected (Host Machine):
     Download the Windows version of the "Agent2" utility, and see if it will connect to the XC7A35T FPGA
     (If not, some debug forum discussion here:
       https://forum.digilentinc.com/topic/4877-cannot-talk-to-arty-board-with-vivado-172/
       https://forum.digilentinc.com/topic/8977-vivado-not-finding-arty-target/
     )

   To verify USB Device is connected (Virtual Machine):
    Run 'lsusb', should see a device "Future Technology Devices International, Ltd FT2232C Dual USB-UART/FIFO IC"
    Run 'ls -al /dev/ttyUSB1' (If you have multiple USB devices, may be ttyUSB3,5,7, etc.  Maybe have to detach USB device and see which one disappears.
    Run Vivado -> Hardware Manager -> Open Target -> AutoConnect - should see Xilinx_tcf/Digilent/<ID Number>    
    
On Virtual Machine - Install SiFive RISC-V Toolchain w' OpenOCD
  https://www.sifive.com/boards
  in .aliases, add:
    export RISCV="<install dir>"
  in .profile, add:

Clone and Build Freedom-E SDK
  sudo apt-get install autoconf automake libmpc-dev libmpfr-dev libgmp-dev gawk bison flex texinfo libtool libusb-1.0-0-dev make g++ pkg-config libexpat1-dev zlib1g-dev
  git clone --recursive https://github.com/sifive/freedom-e-sdk.git
  cd freedom-e-sdk
  make tools



Creating the RTL:
-----------------------------

Clone SiFive Freedom E310 github repository (Using Cygwin bash shell):
  cd ~/cygwin
  git clone http://github.com/sifive/freedom
  cd freedom
  #Run this command to update subrepositories used by freedom
  git submodule update --init --recursive
  
 Build the RTL and MCS (make sure you do these in order):
  The Makefile corresponding to the Freedom E300 Arty FPGA Dev Kit is Makefile.e300artydevkit and it consists of two main targets:

  #verilog: to compile the Chisel source files and generate the Verilog files.  (You must have the RISC-V toolchain installed to do this)
  make -f Makefile.e300artydevkit verilog
  
  #mcs: to create a Configuration Memory File (.mcs) that can be programmed onto an Arty FPGA board.  (You must have the RISC-V toolchain installed to do this)
  make -f Makefile.e300artydevkit mcs
  
  (output files under builds/e300artydevkit/obj)



Loading the FPGA Image:
-----------------------------

  Run Vivado -> Hardware Manager -> Open Target -> AutoConnect - should see Xilinx_tcf/Digilent/<ID Number>    
  Right-click on xc7a35t_0, select ”Add Configuration Memory Device”
  Seach for "n25q128-3.3v" - it will show up as an alias of mt25ql28)
    
