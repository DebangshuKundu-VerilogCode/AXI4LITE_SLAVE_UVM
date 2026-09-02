class axi_config extends uvm_object;
	`uvm_object_utils(axi_config)
	uvm_active_passive_enum inp_agent_is_active;
	uvm_active_passive_enum out_agent_is_active;
	virtual axi_if vif;
	function new(string name="axi_config");
		super.new(name);
	endfunction
endclass
