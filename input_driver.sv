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
            if(req.w_r) begin
                case(req.order)
                3'd0: begin                                   // AW first, then W
                    `uvm_info("driver","before w_addr handshake",UVM_NONE)
                    write_address(req);
                    `uvm_info("driver","after w_addr handshake",UVM_NONE)
                    write_data(req);
                    `uvm_info("driver","after w_data handshake",UVM_NONE)
                end

                3'd1: begin                                   // W first, then AW
                    write_data(req);
                    write_address(req);
                end

                3'd2: begin                                   // alternate between the two orders
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

                3'd3: begin                                   // AW and W in parallel, valids held one extra cycle
                    fork
                        write_address(req,1);
                        write_data(req,1);
                    join
                end

                3'd4: begin                                   // write and read at the same time
                    `uvm_info("driver","Simultaneous write and read",UVM_NONE)
                    while(!(vif.inp_drv_cb.AWREADY && vif.inp_drv_cb.WREADY && vif.inp_drv_cb.ARREADY)) begin
                        $display("%0t Waiting for READY:AWREADY=%0d WREADY=%0d ARREADY=%0d",$time,
                                 vif.inp_drv_cb.AWREADY,vif.inp_drv_cb.WREADY,vif.inp_drv_cb.ARREADY);
                        @(vif.inp_drv_cb);
                    end
                    vif.inp_drv_cb.AWADDR<=req.AWADDR;
                    vif.inp_drv_cb.AWPROT<=req.AWPROT;
                    vif.inp_drv_cb.WDATA<=req.WDATA;
                    vif.inp_drv_cb.WSTRB<=req.WSTRB;
                    vif.inp_drv_cb.ARADDR<=req.ARADDR;
                    vif.inp_drv_cb.ARPROT<=req.ARPROT;
                    vif.inp_drv_cb.AWVALID<=1;
                    vif.inp_drv_cb.WVALID<=1;
                    vif.inp_drv_cb.ARVALID<=1;
                    @(vif.inp_drv_cb);
                    `uvm_info("driver","all high",UVM_NONE)
                    @(vif.inp_drv_cb);
                    if(vif.inp_drv_cb.AWREADY && vif.inp_drv_cb.WREADY && vif.inp_drv_cb.ARREADY) begin
                        `uvm_info("driver","All handshake occured",UVM_NONE)
                    end
                    else begin
                        `uvm_error("driver","Simultaneous handshake failed")
                    end
                    vif.inp_drv_cb.AWVALID<=0;
                    vif.inp_drv_cb.WVALID<=0;
                    vif.inp_drv_cb.ARVALID<=0;
                    fork
                        begin
                            `uvm_info("driver","Waiting for BVALID",UVM_NONE)
                            wait(vif.inp_drv_cb.BVALID);
                            `uvm_info("driver","BVALID detected",UVM_NONE)
                            vif.inp_drv_cb.BREADY<=1;
                            `uvm_info("driver",$sformatf("AFTER BREADY: BVALID=%0d",vif.inp_drv_cb.BVALID),UVM_NONE)
                            repeat(2) @(vif.inp_drv_cb);
                            vif.inp_drv_cb.BREADY<=0;
                            `uvm_info("driver","B response handshake completed",UVM_NONE)
                        end
                        begin
                            `uvm_info("driver","Waiting for RVALID",UVM_NONE)
                            wait(vif.inp_drv_cb.RVALID);
                            `uvm_info("driver","RVALID detected",UVM_NONE)
                            vif.inp_drv_cb.RREADY<=1;
                            @(vif.inp_drv_cb);
                            vif.inp_drv_cb.RREADY<=0;
                            `uvm_info("driver","R response handshake completed",UVM_NONE)
                        end
                    join
                    `uvm_info("driver","Simultaneous write/read completed",UVM_NONE)
                end
                endcase

                // mode 4 already handled its own B and R responses
                if(req.order!=3'd4) begin
                    `uvm_info("driver","before response arrives",UVM_NONE)
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
            end

            else begin
                `uvm_info("driver","Read transaction received ",UVM_NONE);
                drive_read(req);
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

    task write_address(trans data2duv, bit hold=0);
    begin
        @(vif.inp_drv_cb);
        vif.inp_drv_cb.AWADDR<=data2duv.AWADDR;
        vif.inp_drv_cb.AWPROT<=data2duv.AWPROT;
        $display("%0t Driver: AWVALID<=1",$time);
        vif.inp_drv_cb.AWVALID<=1;
        @(vif.inp_drv_cb)
        while(!vif.inp_drv_cb.AWREADY) @vif.inp_drv_cb;
        if(hold) @(vif.inp_drv_cb);
        $display("[%0t] Driver:AWREADY seen, AWVALID<=0",$time);
        vif.inp_drv_cb.AWVALID<=0;
    end
    endtask

    task write_data(trans data2duv, bit hold=0);
    begin
        @(vif.inp_drv_cb);
        vif.inp_drv_cb.WDATA<=data2duv.WDATA;
        vif.inp_drv_cb.WSTRB<=data2duv.WSTRB;
        vif.inp_drv_cb.WVALID<=1;
        @(vif.inp_drv_cb)
        while(!vif.inp_drv_cb.WREADY) @(vif.inp_drv_cb);
        if(hold) @(vif.inp_drv_cb);
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
