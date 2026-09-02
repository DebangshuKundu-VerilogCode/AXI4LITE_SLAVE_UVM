class output_monitor extends uvm_monitor;
        `uvm_component_utils(output_monitor)
        uvm_analysis_port#(trans) out_monitor_port;
        virtual axi_if.OUT_MON vif;
        axi_config m;
        function new(string name="output_monitor",uvm_component parent);
                super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
        if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m)
                                        `uvm_fatal(get_type_name(),"output monitor failed")
        out_monitor_port=new("out_monitor_port",this);
        endfunction
        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                vif=m.vif;
        endfunction
        task run_phase(uvm_phase phase);
        forever
                begin
                        collect_data();
                end
        endtask
        virtual task collect_data();
        trans rd_data;
        begin
        repeat@(vif.out_mon_cb);
        begin
        rd_data.AWREADY=vif.out_mon_cb.AWREADY;
        rd_data.WREADY=vif.out_mon_cb.WREADY;
        rd_data.BRESP=vif.out_mon_cb.BRESP;
        rd_data.BVALID=vif.out_mon_cb.BVALID;
        rd_data.ARREADY=vif.out_mon_cb.ARREADY;
        rd_data.RDATA=vif.out_mon_cb.RDATA;
        rd_data.RRESP=vif.out_mon_cb.RRESP;
        rd_data.RVALID=vif.out_mon_cb.RVALID;
        end
        out_monitor_port.write(rd_data);
        `uvm_info("OUTPUT_MONITOR",$sformatf("OUTPUT MONITOR\n%s",rd_data.sprint()),UVM_NONE)
        end
        endtask
        endclass
