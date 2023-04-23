onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mem_system_perfbench/clk
add wave -noupdate /mem_system_perfbench/rst
add wave -noupdate -radix decimal /mem_system_perfbench/n_requests
add wave -noupdate -radix decimal /mem_system_perfbench/n_replies
add wave -noupdate -radix decimal /mem_system_perfbench/n_cache_hits
add wave -noupdate -radix decimal /mem_system_perfbench/req_cycle
add wave -noupdate -radix decimal /mem_system_perfbench/DUT/clkgen/cycle_count
add wave -noupdate /mem_system_perfbench/DUT/clkgen/err
add wave -noupdate -divider Top-Level
add wave -noupdate /mem_system_perfbench/Addr
add wave -noupdate /mem_system_perfbench/DataIn
add wave -noupdate /mem_system_perfbench/Rd
add wave -noupdate /mem_system_perfbench/Wr
add wave -noupdate /mem_system_perfbench/CacheHit
add wave -noupdate /mem_system_perfbench/Done
add wave -noupdate /mem_system_perfbench/Stall
add wave -noupdate /mem_system_perfbench/DataOut_ref
add wave -noupdate /mem_system_perfbench/DataOut
add wave -noupdate -divider FSM
add wave -noupdate /mem_system_perfbench/DUT/m0/state
add wave -noupdate /mem_system_perfbench/DUT/m0/nxt_state
add wave -noupdate -divider {cache 0}
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/enable
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/comp
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/write
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/tag_in
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/index
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/offset
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/valid_in
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/hit
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/data_in
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/dirty
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/valid
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/tag_out
add wave -noupdate -divider {cache 1}
add wave -noupdate /mem_system_perfbench/DUT/m0/c0/data_out
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/enable
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/tag_in
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/index
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/offset
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/data_in
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/comp
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/write
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/valid_in
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/tag_out
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/data_out
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/hit
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/dirty
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/valid
add wave -noupdate /mem_system_perfbench/DUT/m0/c1/err
add wave -noupdate -divider memory
add wave -noupdate /mem_system_perfbench/DUT/m0/mem/addr
add wave -noupdate /mem_system_perfbench/DUT/m0/mem/wr
add wave -noupdate /mem_system_perfbench/DUT/m0/mem/rd
add wave -noupdate /mem_system_perfbench/DUT/m0/mem/data_in
add wave -noupdate /mem_system_perfbench/DUT/m0/mem/data_out
add wave -noupdate /mem_system_perfbench/DUT/m0/mem/stall
add wave -noupdate /mem_system_perfbench/DUT/m0/mem/en
add wave -noupdate -divider way
add wave -noupdate /mem_system_perfbench/DUT/m0/victimway_q
add wave -noupdate /mem_system_perfbench/DUT/m0/way_ff_q
add wave -noupdate /mem_system_perfbench/DUT/m0/way_ff_d
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3540 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 255
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {4291 ns}
