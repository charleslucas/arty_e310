# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param chipscope.maxJobs 2
set_param xicom.use_bs_reader 1
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
set_param project.vivado.isBlockSynthRun true
set_msg_config -msgmgr_mode ooc_run
create_project -in_memory -part xc7a35ticsg324-1L

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.cache/wt [current_project]
set_property parent.project_path C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_ip -quiet c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3.xci
set_property used_in_implementation false [get_files -all c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_board.xdc]
set_property used_in_implementation false [get_files -all c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3.xdc]
set_property used_in_implementation false [get_files -all c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1

set cached_ip [config_ip_cache -export -no_bom  -dir C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.runs/clk_wiz_3_synth_1 -new_name clk_wiz_3 -ip [get_ips clk_wiz_3]]

if { $cached_ip eq {} } {
close [open __synthesis_is_running__ w]

synth_design -top clk_wiz_3 -part xc7a35ticsg324-1L -mode out_of_context

#---------------------------------------------------------
# Generate Checkpoint/Stub/Simulation Files For IP Cache
#---------------------------------------------------------
# disable binary constraint mode for IPCache checkpoints
set_param constraints.enableBinaryConstraints false

catch {
 write_checkpoint -force -noxdef -rename_prefix clk_wiz_3_ clk_wiz_3.dcp

 set ipCachedFiles {}
 write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ clk_wiz_3_stub.v
 lappend ipCachedFiles clk_wiz_3_stub.v

 write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ clk_wiz_3_stub.vhdl
 lappend ipCachedFiles clk_wiz_3_stub.vhdl

 write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ clk_wiz_3_sim_netlist.v
 lappend ipCachedFiles clk_wiz_3_sim_netlist.v

 write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ clk_wiz_3_sim_netlist.vhdl
 lappend ipCachedFiles clk_wiz_3_sim_netlist.vhdl
set TIME_taken [expr [clock seconds] - $TIME_start]

 config_ip_cache -add -dcp clk_wiz_3.dcp -move_files $ipCachedFiles -use_project_ipc  -synth_runtime $TIME_taken  -ip [get_ips clk_wiz_3]
}

rename_ref -prefix_all clk_wiz_3_

# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef clk_wiz_3.dcp
create_report "clk_wiz_3_synth_1_synth_report_utilization_0" "report_utilization -file clk_wiz_3_utilization_synth.rpt -pb clk_wiz_3_utilization_synth.pb"

if { [catch {
  file copy -force C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.runs/clk_wiz_3_synth_1/clk_wiz_3.dcp c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  write_verilog -force -mode synth_stub c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode synth_stub c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_verilog -force -mode funcsim c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode funcsim c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}


} else {


if { [catch {
  file copy -force C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.runs/clk_wiz_3_synth_1/clk_wiz_3.dcp c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  file rename -force C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.runs/clk_wiz_3_synth_1/clk_wiz_3_stub.v c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  file rename -force C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.runs/clk_wiz_3_synth_1/clk_wiz_3_stub.vhdl c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  file rename -force C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.runs/clk_wiz_3_synth_1/clk_wiz_3_sim_netlist.v c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  file rename -force C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.runs/clk_wiz_3_synth_1/clk_wiz_3_sim_netlist.vhdl c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

}; # end if cached_ip 

if {[file isdir C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.ip_user_files/ip/clk_wiz_3]} {
  catch { 
    file copy -force c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_stub.v C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.ip_user_files/ip/clk_wiz_3
  }
}

if {[file isdir C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.ip_user_files/ip/clk_wiz_3]} {
  catch { 
    file copy -force c:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_stub.vhdl C:/cygwin64/home/cdlucas/devel/github/arty_e310/arty_e310/arty_e310.ip_user_files/ip/clk_wiz_3
  }
}
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
