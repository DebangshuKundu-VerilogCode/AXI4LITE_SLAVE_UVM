class input_monitor extends uvm_monitor;
        `uvm_component_utils(input_monitor)
        uvm_analysis_port#(trans) inp_monitor_port;
        virtual axi_if.INP_MON vif;
        axi_config m;
        function new(string name="input_monitor",uvm_component parent);
                super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
        if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m)
                                        `uvm_fatal(get_type_name(),"input monitor failed")
        inp_monitor_port=new("inp_monitor_port",this);
        endfunction
        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                vif=m.vif;
        endfunction
        task run_phase(uvm_phase phase);
                forever
                        begin
                                collect_input_monitor();
                        end
        endtask
        virtual task collect_input_monitor();
                trans drv2mon;
                begin
                        repeat@(vif.inp_mon_cb);
                        drv2mon=trans::type_id::create("drv2mon");
                        drv2mon.AWADDR=vif.inp_mon_cb.AWADDR;
                        drv2mon.AWPROT=vif.inp_mon_cb.AWPROT;
                        drv2mon.AWVALID=vif.inp_mon_cb.AWVALID;
                        drv2mon.WDATA=vif.inp_mon_cb.WDATA;
                        drv2mon.WSTRB=vif.inp_mon_cb.WSTRB;
                        drv2mon.WVALID=vif.inp_mon_cb.WVALID;
                        drv2mon.BREADY=vif.inp_mon_cb.BREADY;
                        drv2mon.ARADDR=vif.inp_mon_cb.ARADDR;
                        drv2mon.ARPROT=vif.inp_mon_cb.ARPROT;
                        drv2mon.ARVALID=vif.inp_mon_cb.ARVALID;
                        drv2mon.RREADY=vif.inp_mon_cb.RREADY;
                  inp_monitor_port.write(drv2mon);
                        `uvm_info("INPUT_MONITOR",$sformatf("Input MONITOR\n%s",drv2mon.sprint()),UVM_NONE)
                        end
                endtask
        endclass
