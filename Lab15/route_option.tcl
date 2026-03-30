###############################################################################################################

# Add Encounter routing option commands in this file

# Use thse options before placement to make sure placement doesn't create a gap of one unit tile.
set_db place_detail_filler_gap_min_gap 0.2
set_db place_detail_filler_gap_effort medium
set_db place_detail_dpt_flow true
set_db place_detail_color_aware_legal true
set_db add_fillers_no_single_site_gap true

# Prevent router modifying M1 pins shapes, syntax change with 20.10 Bug fix B-290696
  set_db route_with_via_in_pin "1:1"
  set_db route_with_via_only_for_stdcell_pin "1:1"
  set_db design_bottom_routing_layer 2

# weight multi cut use high and spend more time optimizing dcut use.
  set_db route_detail_use_multi_cut_via_effort high
# minimizes via count during the route
  set_db route_concurrent_minimize_via_count_effort high

# allows route of tie off nets to internal cell pin shapes rather than routing to special net structure.
  set_db route_allow_power_ground_pin true
  set_db route_with_timing_driven true
  set_db route_with_si_driven true

# Settings recommend from Cadence 
  set_db route_check_rule true
  set_db route_detail_auto_stop false

# Enable auto via flow from 14.2
  set_db route_exp_use_auto_via true

# set_db route_via_weight "V*0_30_Vx 30"
# set_db route_via_weight "V*30_0_Vx 30"
# set_db route_via_weight "V*0_35_Vx 65"
# set_db route_via_weight "V*35_0_Vx 65"
# set_db route_via_weight "V*0_50_Vx 100"
# set_db route_via_weight "V*50_0_Vx 100"
# set_db route_via_weight "J*0_50*Jy 150"
# set_db route_via_weight "J*50_0*Jy 150"
# set_db route_via_weight "*BAR* 200"
# set_db route_via_weight "A*BAR*MAR* -1"

##############################################################################################################
