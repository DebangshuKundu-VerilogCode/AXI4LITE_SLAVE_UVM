class input_agent extends uvm_agent;
	`uvm_component_utils(input_agent)
	 sequencer seq_h;
	 input_driver drv_h;
	 input_monitor inp_mon_h;
	 axi_config m;
	 function new(string name="input_agent",uvm_component parent);
	 	super.new(name,parent);
	 endfunction
	 function void build_phase(uvm_phase phase);
	 	super.build_phase(phase);
	 if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m)
					 `uvm_fatal(get_type_name(),"input agent getting failed")
	 inp_mon_h=input_monitor::type_id::create("inp_mon_h",this);
	 if(m.input_agent_is_active==UVM_ACTIVE)
					 begin
					 seq_h=sequencer::type_id::create("seq_h",this);
					 drv_h=input_driver::type_id::create("drv_h",this);
					 end
		endfunction
		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			if(m.input_agent_is_active==UVM_ACTIVE)
							begin
							drv_h.seq_item_port.connect(seq_h.seq_item_export);
							end
		endfunction
endclass
