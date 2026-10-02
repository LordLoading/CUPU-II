# Creates the Vivado project for the Basys 3 build:
#   vivado -mode batch -source create_project.tcl
# then open fpga/basys3/vivado/cupu_basys3.xpr. The project points at the sources in the
# repository (src/project.vhdl is the same file the chip is built from), it does not copy them.
# An optional argument puts the project somewhere else: -tclargs <directory>

set here [file normalize [file dirname [info script]]]
set root [file normalize "$here/../.."]
set dir  [expr {$argc > 0 ? [lindex $argv 0] : "$here/vivado"}]

create_project cupu_basys3 $dir -part xc7a35tcpg236-1 -force
set_property target_language VHDL [current_project]

set srcs [list \
  "$root/src/project.vhdl" \
  "$here/prog_pkg.vhdl" \
  "$here/spi_mem.vhdl" \
  "$here/basys3_clk.vhdl" \
  "$here/basys3_top.vhdl"]
add_files -norecurse -fileset sources_1 $srcs
set_property file_type {VHDL 2008} [get_files $srcs]
set_property top basys3_top [get_filesets sources_1]

add_files -norecurse -fileset constrs_1 "$here/basys3.xdc"

add_files -norecurse -fileset sim_1 "$here/tb_basys3.vhdl"
set_property file_type {VHDL 2008} [get_files "$here/tb_basys3.vhdl"]
set_property top tb_basys3 [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
puts "Project created: $dir/cupu_basys3.xpr"
