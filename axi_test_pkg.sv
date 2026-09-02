
package axi_test_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "trans.sv"
	`include "axi_config.sv"          // unchanged, confirmed clean
	`include "input_driver.sv"        // FIXED: cin, reset defaults
	`include "input_monitor.sv"       // FIXED: cin, handle-reuse
	`include "sequencer.sv"     // unchanged, confirmed clean
	`include "input_agent.sv"         // unchanged, confirmed clean
	`include "output_monitor.sv"      // FIXED: ==, handle-reuse
	`include "output_agent.sv"        // FIXED: monitor creation gating
	`include "scoreboard.sv"// NEW-must come after trans.sv, before env.sv
	`include "env.sv"
	`include "sequence.sv"
	`include "test.sv"
endpackage
