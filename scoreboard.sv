class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)
   uvm_tlm_analysis_fifo#(trans)inp_mon_fifo;
	 uvm_tlm_analysis_fifo#(trans)out_mon_fifo;

	 trans inp_mon_tx;
	 trans out_mon_tx;

	 logic[`DATA_WIDTH-1:0]mem[`MEM_DEPTH];
	 bit w_addr=1'b0;
	 bit w_data=1'b0;
	 bit[`ADDR_WIDTH-1:0]temp_addr;
	 bit[`DATA_WIDTH-1:0]temp_data;
	 bit[(`DATA_WIDTH/8)-1:0]temp_strb;

	 function new(string name="scoreboard",uvm_component parent);
	 	super.new(name,parent);
		inp_mon_fifo=new("inp_mon_fifo",this);
		out_mon_fifo=new("out_mon_fifo",this);
	 endfunction

   task run_phase(uvm_phase phase);
	 	forever 
			begin
				inp_mon_fifo.get(inp_mon_tx);
				out_mon_fifo.get(out_mon_tx);

				ref_model(inp_mon_tx);
				`uvm_info("reference_model",$sformatf("reference_model:\n%s",inp_mon_tx.sprint()),UVM_NONE);
        
         check_data();
				//validate_output();
			end
		endtask

		/*virtual task validate_output();
			
			if(inp_mon_tx.compare(out_mon_tx))
							begin
							`uvm_info(get_type_name(),$sformatf("DATA MATCH SUCCESSFUL"),UVM_NONE)
							end
			else
							begin
							`uvm_info(get_type_name(),$sformatf("DATA MISMATCH"),UVM_NONE)
							`uvm_info(get_type_name(),$sformatf("Expected Packet\n%s",inp_mon_tx.sprint()),UVM_NONE)
							`uvm_info(get_type_name(),$sformatf("DUT Packet\n%s",out_mon_tx.sprint()),UVM_NONE)
							end
		endtask*/




    virtual task ref_model(trans t);
			if(!t.ARESETn)
							begin
							foreach(mem[i])
								mem[i]={`DATA_WIDTH{1'b0}};
							t.AWREADY=1'b0;
							t.WREADY=1'b0;
							t.BVALID=1'b0;

							t.ARREADY=1'b0;
							t.RVALID=1'b0;
              
							w_addr=1'b0;
							w_data=1'b0;
							temp_addr={`ADDR_WIDTH{1'b0}};
							temp_data={`DATA_WIDTH{1'b0}};
							temp_strb={(`DATA_WIDTH/8){1'b0}};

							end
			else
							begin
							if(t.AWVALID || t.WVALID)
											begin
											if(t.AWVALID && (!w_addr))
															begin
															temp_addr=t.AWADDR;
															t.AWREADY=1'b1;
															w_addr=1'b1;
															end
											if(t.WVALID && (!w_data))
															begin
															temp_data=t.WDATA;
															temp_strb=t.WSTRB;
															t.WREADY=1'b1;
															w_data=1'b1;
															end
											if(w_addr && w_data)
															begin
															if(temp_addr[7:0] inside {[8'h28:8'h30]})
																			t.BRESP=2'b11;
															else if((temp_addr[1:0]!=2'b00) || (!(temp_addr[7:0] inside {[8'h00:8'h3f]})))
																			t.BRESP=2'b10;
															else
																			begin
																			t.BRESP=2'b00;
																			if(temp_strb[0])
																							mem[temp_addr[5:2]][7:0]=temp_data[7:0];
																			if(temp_strb[1])
																							mem[temp_addr[5:2]][15:8]=temp_data[15:8];
																			if(temp_strb[2])
																							mem[temp_addr[5:2]][23:16]=temp_data[23:16];
																			if(temp_strb[3])
																							mem[temp_addr[5:2]][31:24]=temp_data[31:24];
																			end
																			t.BVALID=1'b1;
																			w_addr=1'b0;
																			w_data=1'b0;
																			temp_addr={`ADDR_WIDTH{1'b0}};
																			temp_data={`DATA_WIDTH{1'b0}};
																			temp_strb={(`DATA_WIDTH/8){1'b0}};
																			end
															end
										 if(t.ARVALID)
														 begin
														 t.ARREADY=1'b1;
														 if(t.ARADDR[7:0] inside {[8'h34:8'h38]})
																		 t.RRESP=2'b11;
														else if((t.ARADDR[1:0]!=2'b00) || (!(t.ARADDR[7:0] inside {[8'h00:8'h3f]})))
																		t.RRESP=2'b10;
														else
																		begin
																		t.RRESP=2'b00;
																		t.RDATA=mem[t.ARADDR[5:2]];
																		end
														t.RVALID=1'b1;
														end
										 else
														 begin
														 t.AWREADY=1'b0;
														 t.WREADY=1'b0;
														 t.BVALID=1'b0;

														 t.ARREADY=1'b0;
														 t.RVALID=1'b0;
														 end
														end
													endtask
	virtual task check_Data(trans tin,trans tout);
    
    //check write_addr
    if(tin.AWVALID)begin
      
      if(tin.AWREADY == tout.AWREADY)
        $display("\n AWREADY IS  MATCHING");
      else
        $display("\n AWREADY IS NOT MATCHING");
      
    end
    
    //check write_data
    if(tin.WVALID)begin
      
      if(tin.WREADY == tout.WREADY)
        $display("\n WREADY IS  MATCHING");
      else
        $display("\n WREADY IS NOT MATCHING");
      
    end
    
    //check write_response
    if(tin.BREADY)begin
      
      if(tin.BRESP == tout.BRESP)
        $display("\n BRESP IS  MATCHING");
      else
        $display("\n BRESP IS NOT MATCHING");
      
      if(tin.BVALID == tout.BVALID)
        $display("\n BVALID IS  MATCHING");
      else
        $display("\n BVALID IS NOT MATCHING");
      
    end
    
    //check read_addr
    if(tin.ARVALID)begin
      
      if(tin.ARREADY == tout.ARREADY)
        $display("\n ARREADY IS  MATCHING");
      else
        $display("\n ARREADY IS NOT MATCHING");
      
    end
    
    //check read_response
    if(tin.RREADY)begin
      
      if(tin.RDATA == tout.RDATA)
        $display("\n RDATA IS  MATCHING");
      else
        $display("\n RDATA IS NOT MATCHING");
      
      if(tin.RRESP == tout.RRESP)
        $display("\n RRESP IS  MATCHING");
      else
        $display("\n RRESP IS NOT MATCHING");
      
      if(tin.RVALID == tout.RVALID)
        $display("\n RVALID IS  MATCHING");
      else
        $display("\n RVALID IS NOT MATCHING");
      
    end
    
    
  endtask
endclass

