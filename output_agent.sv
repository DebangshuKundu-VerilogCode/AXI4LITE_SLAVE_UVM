class output_agent extends uvm_agent;
	`uvm_component_utils(output_agent)
	output_monitor out_mon;
	axi_config m;
function new(string name="output_agent",uvm_component parent);
	super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m))
				`uvm_fatal(get_type_name(),"output agent failed")
out_mon=output_monitor::type_id::create("out_mon",this);
endfunction
endclass
