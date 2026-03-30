set rpt "Lab15.Route_reports"
set out "Lab15.Route_outputs"

foreach dir [list $rpt $out] {
  if {![file exists $dir]} {
    file mkdir $dir
    puts "INFO: Creating directory $dir"
  }
}
read_db /home/NAMDH66/practice/Lab14.Cts.part2.template/Lab14.Cts_outputs/Lab14_final.dat
set PREFIX "Lab15.Route_Global"

## setDesignMode
set_db design_process_node 45

set_interactive_constraint_modes [all_constraint_modes -active]

### Sanity check
check_place
#check_design
#check_timing -verbose > $rpt/${PREFIX}.check_timing.pre_route.rpt

#check_footprint > $rpt/${PREFIX}.check_footprint.pre_route.rpt
#report_constraint_modes > $rpt/${PREFIX}.constraint_modes.rpt
time_design -post_cts -report_dir $rpt/${PREFIX}_postcts_timing


## setRouteMode
#source -echo -verbose ./script/route_settings.tcl

set_db design_top_routing_layer 11
set_db design_bottom_routing_layer 2

set_db route_with_timing_driven true
set_db route_with_si_driven true
set_db route_concurrent_minimize_via_count_effort medium
set_db route_reserve_space_for_multi_cut true

set net_list {}
foreach net $net_list {
 puts "set_dont_touch for net: $net"
 set_dont_touch [get_nets $net]
}

## skip_routing nets
# set_route_attributes -nets  <skip nets>  -skip_routing true
 
## Route
route_design -global_detail

## Swap multcut VIa
#set_db route_with_timing_driven  false
#set_db route_detail_post_route_swap_via multiCut
#route_design -via_opt
#reset_db route_detail_post_route_swap_via

## Post-route sanity check
check_timing -verbose > $rpt/${PREFIX}.check_timing.post_route.rpt
check_footprint       > $rpt/${PREFIX}.check_footprint.post_route.rpt
time_design -post_route -report_dir $rpt/${PREFIX}_postroute_timing

write_db $out/${PREFIX}.dat
puts "INFO: Lab 15 Global Routing complete."

#exit
