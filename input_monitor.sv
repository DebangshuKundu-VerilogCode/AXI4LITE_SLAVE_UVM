class input_monitor extends uvm_monitor;
    `uvm_component_utils(input_monitor)
    uvm_analysis_port#(trans) inp_monitor_port;
    virtual axi_if.INP_MON vif;
    axi_config m;
                trans drv2mon;
    function new(string name="input_monitor",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m))
            `uvm_fatal(get_type_name(),"input monitor failed")
        inp_monitor_port=new("inp_monitor_port",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif=m.vif;
    endfunction
task run_phase(uvm_phase phase);
forever begin
drv2mon=trans::type_id::create("drv2mon");
`uvm_info("Input monitor check","Before collect input monitor",UVM_NONE)
`uvm_info("Input monitor check",
    $sformatf("ARVALID=%0d ARREADY=%0d | AWVALID=%0d AWREADY=%0d | WVALID=%0d WREADY=%0d",
        vif.inp_mon_cb.ARVALID,
        vif.inp_mon_cb.ARREADY,
        vif.inp_mon_cb.AWVALID,
        vif.inp_mon_cb.AWREADY,
        vif.inp_mon_cb.WVALID,
        vif.inp_mon_cb.WREADY),
    UVM_NONE)
collect_input_monitor();
`uvm_info("Input monitor check","After collect input monitor",UVM_NONE)

inp_monitor_port.write(drv2mon);
@(vif.inp_mon_cb);
`uvm_info("Input monitor",$sformatf("Input Monitor\n%s",drv2mon.sprint()),UVM_NONE)
end
endtask
virtual task collect_input_monitor();
forever
 begin
@(vif.inp_mon_cb);
`uvm_info("Input monitor check",
    $sformatf("ARVALID=%0d ARREADY=%0d | AWVALID=%0d AWREADY=%0d | WVALID=%0d WREADY=%0d",
        vif.inp_mon_cb.ARVALID,
        vif.inp_mon_cb.ARREADY,
        vif.inp_mon_cb.AWVALID,
        vif.inp_mon_cb.AWREADY,
        vif.inp_mon_cb.WVALID,
        vif.inp_mon_cb.WREADY),
    UVM_NONE)
$display("%0t MONITOR: AWVALID+%0d AWREADY=%0d",$time,vif.inp_mon_cb.AWVALID,vif.inp_mon_cb.AWREADY);
if ((vif.inp_mon_cb.AWVALID && vif.inp_mon_cb.AWREADY) && !(vif.inp_mon_cb.WVALID && vif.inp_mon_cb.WREADY)) begin
drv2mon.AWADDR=vif.inp_mon_cb.AWADDR;
drv2mon.AWPROT=vif.inp_mon_cb.AWPROT;
drv2mon.w_r=1;
`uvm_info("MON_WAIT","Waiting for data handshake",UVM_NONE)
wait(vif.inp_mon_cb.WVALID && vif.inp_mon_cb.WREADY);
`uvm_info("MON_WAIT","donw with data handshake",UVM_NONE)
drv2mon.WDATA=vif.inp_mon_cb.WDATA;
drv2mon.WSTRB=vif.inp_mon_cb.WSTRB;
drv2mon.ARESETn=vif.inp_mon_cb.ARESETn;
`uvm_info("MON_DEBUG","Returning from AW branch",UVM_NONE)
return;
end

else if(!(vif.inp_mon_cb.AWVALID && vif.inp_mon_cb.AWREADY) && (vif.inp_mon_cb.WVALID && vif.inp_mon_cb.WREADY)) begin
drv2mon.WDATA=vif.inp_mon_cb.WDATA;
drv2mon.WSTRB=vif.inp_mon_cb.WSTRB;
drv2mon.w_r=1;
`uvm_info("MON_WAIT","Waiting for addr handshake",UVM_NONE)
wait(vif.inp_mon_cb.AWVALID && vif.inp_mon_cb.AWREADY);
`uvm_info("MON_WAIT","donw with addr handshake",UVM_NONE)
drv2mon.AWADDR=vif.inp_mon_cb.AWADDR;
drv2mon.AWPROT=vif.inp_mon_cb.AWPROT;
drv2mon.ARESETn=vif.inp_mon_cb.ARESETn;
`uvm_info("MON_DEBUG","Returning from W branch",UVM_NONE)

return;
end

else if((vif.inp_mon_cb.AWVALID && vif.inp_mon_cb.AWREADY) && (vif.inp_mon_cb.WVALID && vif.inp_mon_cb.WREADY)) begin
drv2mon.WDATA=vif.inp_mon_cb.WDATA;
drv2mon.WSTRB=vif.inp_mon_cb.WSTRB;
drv2mon.w_r=1;
drv2mon.AWADDR=vif.inp_mon_cb.AWADDR;
drv2mon.AWPROT=vif.inp_mon_cb.AWPROT;
drv2mon.ARESETn=vif.inp_mon_cb.ARESETn;
`uvm_info("MON_DEBUG","Returning from AW and W branch",UVM_NONE)
return;
end

else if(vif.inp_mon_cb.ARVALID && vif.inp_mon_cb.ARREADY) begin
 `uvm_info("INPUT_MON_DEBUG",
              "Reading handshake got",
              UVM_NONE)

drv2mon.ARADDR=vif.inp_mon_cb.ARADDR;
drv2mon.ARPROT=vif.inp_mon_cb.ARPROT;
drv2mon.w_r=0;
drv2mon.ARESETn=vif.inp_mon_cb.ARESETn;
return;
end
end
endtask
endclass
