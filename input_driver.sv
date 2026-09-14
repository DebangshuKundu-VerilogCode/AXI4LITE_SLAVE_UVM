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
                vif.inp_drv_cb.AWVALID<=0;
                vif.inp_drv_cb.WVALID<=0;
                vif.inp_drv_cb.ARVALID<=0;
                vif.inp_drv_cb.RREADY<=0;
                vif.inp_drv_cb.BREADY<=0;

                forever begin
                        `uvm_info("driver","before sequence",UVM_NONE)
                        seq_item_port.get_next_item(req);
                        `uvm_info("driver","after sequence",UVM_NONE)
                        if(req.w_r)begin
                                case(req.w_r)
                                2'd0: begin
                                        `uvm_info("driver","before w_addr handshake",UVM_NONE)
                                        write_address(req);
                                        `uvm_info("driver","after w_addre handshake",UVM_NONE)
                                        write_data(req);
                                        `uvm_info("driver","after w_data handshake",UVM_NONE)
                                end

                                2'd1: begin
                                        write_data(req);
                                        write_address(req);
                                end
                                2'd2: begin
                                        if(req.a==0) begin
                                                write_data(req);
                                                @(vif.inp_drv_cb);
                                                write_address(req);
                                                req.a=1;
                                end
                                        else begin
                                                write_address(req);
                                                @(vif.inp_drv_cb);
                                                write_data(req);
                                                req.a=0;
                                        end

                                end
                                2'd3: begin
                                        fork
                                                write_address(req);
                                                write_data(req);
                                        join
                                end
                                endcase
                                `uvm_info("driver","before response arrives",UVM_NONE)
                                //vif.drv_cb.BREADY<=1;
                                wait(vif.inp_drv_cb.BVALID);
                                `uvm_info("driver","BVALID got",UVM_NONE)

                                @(vif.inp_drv_cb);
                                `uvm_info("driver","BREADY asserting",UVM_NONE)

                                vif.inp_drv_cb.BREADY<=1;
                                @(vif.inp_drv_cb);
                                `uvm_info("driver","BREADY handshake done",UVM_NONE)

                                vif.inp_drv_cb.BREADY<=0;
                                `uvm_info("driver","response received",UVM_NONE)
                        end

                        else begin
                                `uvm_info("driver","Read transaction received ",UVM_NONE);
                                drive_read(req);
                                //vif.drv_cb.RREADY<=1;
                                forever begin
                                        @(vif.inp_drv_cb);

                                        if(vif.inp_drv_cb.RVALID) break;
                                end
                                vif.inp_drv_cb.RREADY<=1;
                                @(vif.inp_drv_cb);
                                vif.inp_drv_cb.RREADY<=0;
                        end
                        `uvm_info("INPUT_DRIVER",$sformatf("Input Driver\n%s",req.sprint()),UVM_NONE);
                        seq_item_port.item_done();
                end
        endtask
        task write_address(trans data2duv);
        begin
                @(vif.inp_drv_cb);
                vif.inp_drv_cb.AWADDR<=data2duv.AWADDR;
                vif.inp_drv_cb.AWPROT<=data2duv.AWPROT;
                $display("%0t Driver: AWVALID<=1",$time);
                vif.inp_drv_cb.AWVALID<=1;
                @(vif.inp_drv_cb)
                while(!vif.inp_drv_cb.AWREADY) @vif.inp_drv_cb;
                $display("[%0t] Driver:AWREADY seen, AWVALID<=0",$time);
                vif.inp_drv_cb.AWVALID<=0;
        end
        endtask

        task write_data(trans data2duv);
        begin
                @(vif.inp_drv_cb);
                vif.inp_drv_cb.WDATA<=data2duv.WDATA;
                vif.inp_drv_cb.WSTRB<=data2duv.WSTRB;
                vif.inp_drv_cb.WVALID<=1;
                @(vif.inp_drv_cb)
                while(!vif.inp_drv_cb.WREADY) @(vif.inp_drv_cb);
                vif.inp_drv_cb.WVALID<=0;
        end
        endtask

        task drive_read(trans data2duv);
        begin
                @(vif.inp_drv_cb);
                vif.inp_drv_cb.ARADDR<=data2duv.ARADDR;
                vif.inp_drv_cb.ARPROT<=data2duv.ARPROT;
                vif.inp_drv_cb.ARVALID<=1;
                begin
                        @(vif.inp_drv_cb);
                        while(!vif.inp_drv_cb.ARREADY) @(vif.inp_drv_cb);
                end
                vif.inp_drv_cb.ARVALID<=0;
        end
        endtask
endclass
