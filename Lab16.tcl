##############################################################################
# Lab 16: Detail Routing Refinement & Post-Route Optimization
##############################################################################

# 1. Khởi tạo thư mục và nạp Database
set rpt "Lab16.Detail_Route_reports"
set out "Lab16.Detail_Route_outputs"
set PREFIX "Lab16.Route_Final"

foreach dir [list $rpt $out] {
    if {![file exists $dir]} { 
        file mkdir $dir 
        puts "INFO: Creating directory $dir"
    }
}

# ĐÚNG ĐƯỜNG DẪN: Nạp file đã lưu thành công từ bước Lab 15
read_db ~/practice/Lab15.Route_outputs/Lab15.Route.global_final.dat

# Sử dụng các chế độ ràng buộc hiện có
set_interactive_constraint_modes [get_db current_design .constraint_modes]


##############################################################################
# 2. Thiết lập Chế độ Thiết kế (SỬA LỖI TẦNG KIM LOẠI 1 VS 2)
##############################################################################
set_db design_process_node 45
set_db design_top_routing_layer 11
set_db design_bottom_routing_layer 5 ;# BẮT BUỘC LÀ 1 để tránh lỗi NRDB-955
source route_option.tcl
##############################################################################
# 3. Cấu hình Placement / Optimization / Routing
##############################################################################
set_db opt_max_density 0.8
set_db opt_setup_target_slack 0.2
set_db opt_hold_target_slack 0.05

set_db timing_analysis_type ocv
set_db timing_analysis_cppr both

set_db timing_enable_simultaneous_setup_hold_mode false

# Thiết lập Derate (Đưa về mức thực tế để máy dễ chạy)
set_timing_derate -max -early 0.95 -late 1.05
set_timing_derate -min -early 1.00 -late 1.10


# Khai báo tên con Diode Antenna (Nam hãy check lại tên ANTENNA_X1 hay ANTENNA nhé)
set_db route_antenna_cell_name ANTENNA 
set_db route_detail_fix_antenna true
set_db route_antenna_diode_insertion true

puts "INFO: Running route_eco to fix DRC and Antenna violations..."
route_eco -fix_drc


puts "INFO: Running Final Post-Route Optimization..."
opt_design -post_route -setup -hold -report_dir ${rpt}/${PREFIX}_post_opt

check_drc -out_file $rpt/${PREFIX}.final_drc.rpt
check_antenna -out_file $rpt/${PREFIX}.final_antenna.rpt
check_connectivity -type all -report $rpt/${PREFIX}.final_connectivity.rpt

time_design -post_route -report_dir $rpt/${PREFIX}_final_timing

write_db $out/${PREFIX}_final_complete.dat
puts "INFO: Lab 16 Detail Routing complete. Chip is ready!"

