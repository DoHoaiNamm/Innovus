##############################################################################
# Lab 14: CTS Routing Rules and Post-CTS Optimization
##############################################################################

# 1. Setup Directories and Restore Lab 13 Database
set rpt "Lab14.Cts_reports"
set out "Lab14.Cts_outputs"

foreach dir [list $rpt $out] {
  if {![file exists $dir]} {
    file mkdir $dir
    puts "INFO: Creating directory $dir"
  }
}
read_db /home/NAMDH66/practice/Lab13.Cts.part1/Lab13.Cts_outputs/Lab13_ater_move.dat
set PREFIX "Lab14.Cts.postcts"

set_interactive_constraint_modes {default_emulate_constraint_mode}

create_clock -name clk -period 1.70 -waveform {0.0 0.850} [get_ports clk_pin]

set_interactive_constraint_modes {}
opt_design -post_cts -incremental
time_design -post_cts
report_timing -max_slack 0 -max_path 1 > worst.rpt

# Generate Clock Tree Summary
report_clock_trees -out_file $rpt/${PREFIX}_cts_summary.rpt
#
# Check design rule violations (DRVs)
report_constraint -all_violators > $rpt/${PREFIX}_cts_drvs.rpt
#
# Detailed skew analysis for skew groups
report_skew_groups -out_file $rpt/${PREFIX}_cts_skew.rpt
#
# Report path exceptions for review
report_path_exceptions > $rpt/${PREFIX}_cts_exceptions_check.rpt
#
# Setup timing check (Slow corner / Worst RC)
time_design -post_cts -report_dir $rpt/${PREFIX}_post_cts_setup_timing
#
# Hold timing check (Fast corner / Best RC)
time_design -post_cts -hold -report_dir $rpt/${PREFIX}_post_cts_hold_timing

# 8. Save Final Result
write_db $out/${PREFIX}.dat
puts "INFO: Lab 14 CTS Routing and Post-Opt complete."

#exit
