class input_driver extends uvm_driver#(trans);
	`uvm_component_utils(input_driver)
axi_config m;
virtual axi_if.INP_DRV vif;
trans req;
function new(string name="input_driver",uvm_component parent);
	super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m))
						`uvm_fatal(get_type_name(),"Input driver getting failed")
endfunction
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=m.vif;
endfunction
task run_phase(uvm_phase phase);
	@(vif.inp_drv_cb);
  forever 
		begin
		seq_item_port.get_next_item(req);
		drive(req);
		seq_item_port.item_done();
		end
endtask
task drive(trans t);
	begin
	`uvm_info("INPUT_DRIVER",$sformatf("Input driver\n%s",data2duv.sprint()),UVM_NONE)
	 @(vif.inp_drv_cb);
	 if(t.AWVALID || t.WVALID) begin
					 if(t.AWVALID) begin
									 vif.inp_drv_cb.AWADDR<=t.AWADDR;
									 vif.inp_drv_cb.AWVALID<=t.AWVALID;
									 vif.inp_drv_cb.AWPROT<=t.AWPROT;
									 end
					if(t.WVALID) begin
									 vif.inp_drv_cb.WDATA<=t.WDATA;
									 vif.inp_drv_cb.WSTRB<=t.WSTRB;
									 vif.inp_drv_cb.WVALID<=t.WVALID;
									 end
				  if(t.BREADY && vif.inp_drv_cb.BVALID) begin
									 vif.inp_drv_cb.BREADY<=t.BREADY;
									 end
					end
	 if(t.ARVALID) begin
					vif.inp_drv_cb.ARADDR<=t.ARADDR;
					vif.inp_drv_cb.ARVALID<=t.ARVALID;
					vif.inp_drv_cb.ARPROT<=t.ARPROT;

					while(!(t.RREADY && vif.inp_drv_cb.RVALID)) begin
									@(vif.inp_drv_cb);
									end
					vif.inp_drv_cb.RREADY<=t.RREADY;
					end
endtask
endclass
	end
end
