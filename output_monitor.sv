class output_monitor extends uvm_monitor;
    `uvm_component_utils(output_monitor)
    uvm_analysis_port#(trans) out_monitor_port;
    virtual axi_if.OUT_MON vif;
    axi_config m;
    trans rd_data;

    function new(string name="output_monitor",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m))
            `uvm_fatal(get_type_name(),"output monitor failed")
        out_monitor_port=new("out_monitor_port",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif=m.vif;
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            rd_data=trans::type_id::create("rd_data");
            @(vif.out_mon_cb);
            `uvm_info("OUT_DEBUG",
                $sformatf("ARV=%0b ARR=%0b RV=%0b RR=%0b BV=%0b BR=%0b",
                    vif.out_mon_cb.ARVALID, vif.out_mon_cb.ARREADY,
                    vif.out_mon_cb.RVALID,  vif.out_mon_cb.RREADY,
                    vif.out_mon_cb.BVALID,  vif.out_mon_cb.BREADY),
                UVM_NONE)
            `uvm_info("Output_monitor_check","Before collect_data",UVM_NONE)
            collect_data();
            `uvm_info("Output_monitor_check","After collect_data",UVM_NONE)
            out_monitor_port.write(rd_data);
            `uvm_info("OUTPUT_MONITOR",$sformatf("OUTPUT MONITOR\n %s",rd_data.sprint()),UVM_NONE)
        end
    endtask

    virtual task collect_data();
        forever begin
            @(vif.out_mon_cb);

            // AW, W and AR all handshake together -> collect both B and R responses
            if ((vif.out_mon_cb.AWVALID && vif.out_mon_cb.AWREADY) &&
                (vif.out_mon_cb.WVALID  && vif.out_mon_cb.WREADY)  &&
                (vif.out_mon_cb.ARREADY && vif.out_mon_cb.ARVALID)) begin
                fork
                    begin
                        wait(vif.out_mon_cb.BVALID);
                        rd_data.BRESP=vif.out_mon_cb.BRESP;
                    end
                    begin
                        wait(vif.out_mon_cb.RVALID);
                        rd_data.RRESP=vif.out_mon_cb.RRESP;
                        rd_data.RDATA=vif.out_mon_cb.RDATA;
                    end
                join
                rd_data.ARESETn=vif.out_mon_cb.ARESETn;
                return;
            end

            // AW handshake, no W yet
            else if ((vif.out_mon_cb.AWVALID && vif.out_mon_cb.AWREADY) && !(vif.out_mon_cb.WVALID && vif.out_mon_cb.WREADY)) begin
                wait(vif.out_mon_cb.BVALID);
                rd_data.BRESP=vif.out_mon_cb.BRESP;
                rd_data.ARESETn=vif.out_mon_cb.ARESETn;
                return;
            end

            // W handshake, no AW yet
            else if(!(vif.out_mon_cb.AWVALID && vif.out_mon_cb.AWREADY) && (vif.out_mon_cb.WVALID && vif.out_mon_cb.WREADY)) begin
                rd_data.WDATA=vif.out_mon_cb.WDATA;
                wait(vif.out_mon_cb.BVALID);
                rd_data.BRESP=vif.out_mon_cb.BRESP;
                rd_data.ARESETn=vif.out_mon_cb.ARESETn;
                return;
            end

            // AW and W handshake together (no read)
            else if((vif.out_mon_cb.AWVALID && vif.out_mon_cb.AWREADY) && (vif.out_mon_cb.WVALID && vif.out_mon_cb.WREADY)) begin
                wait(vif.out_mon_cb.BVALID);
                rd_data.BRESP=vif.out_mon_cb.BRESP;
                rd_data.ARESETn=vif.out_mon_cb.ARESETn;
                return;
            end

            // read only
            else if(vif.out_mon_cb.ARVALID && vif.out_mon_cb.ARREADY) begin
                wait(vif.out_mon_cb.RVALID);
                rd_data.RRESP=vif.out_mon_cb.RRESP;
                rd_data.RDATA=vif.out_mon_cb.RDATA;
                rd_data.ARESETn=vif.out_mon_cb.ARESETn;
                return;
            end
        end
    endtask
endclass
