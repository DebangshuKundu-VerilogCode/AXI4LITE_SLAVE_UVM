class test extends uvm_test;
	`uvm_component_utils(test)
env env_h;
axi_config m;
function new(string name="test",uvm_component parent);
	super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
m=axi_config::type_id::create("m");
if(!uvm_config_db#(virtual axi_if)::get(this,"","axi_if",m))
				`uvm_fatal(get_type_name,"can't get the interface")
m.input_agent_is_active=UVM_ACTIVE;
m.output_agent_is_active=UVM_PASSIVE;
uvm_config_db#(axi_config)::set(this,"*","axi_config",m);
env_h=env::type_id::create("env_h",this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction

function void start_of_simulation_phase(uvm_phase phase);
	super.start_of_simulation_phase(phase);
	`uvm_info(get_type_name(),"simulation started",UVM_LOW)
endfunction

task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	`uvm_info(get_type_name(),"base test running",UVM_LOW)
	phase.drop_objection(this);
endtask
endclass

class test_regr extends test;
	`uvm_component_utils(test_regr)
	 write_seq ws;
	 read_seq rs;
	 function new(string name="test_regr",uvm_component parent=null);
	 	super.new(name,parent);
	 endfunction

	 task run_phase(uvm_phase phase);
	 	phase.raise_objection(this);
		ws=write_seq::type_id::create("ws");
		`uvm_info("TEST","Starting write only",UVM_LOW)
		ws.start(env_h.inp_agt_h.seqr_h);
		rs=read_seq::type_id::create("rs");
		`uvm_info("TEST","Starting read only",UVM_LOW)
		rs.start(env_h.inp_agt_h.seqr_h);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this,200);
		endtask
	endclass
