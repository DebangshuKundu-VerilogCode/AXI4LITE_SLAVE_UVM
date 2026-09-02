class write_seq extends uvm_sequence#(trans);
	`uvm_object_utils(write_seq)
trans req;
function new(string name="write_seq");
	super.new(name);
endfunction
task body();
	repeat(10) begin
	req=trans::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {
					AWVALID==1'b1;
					WVALID==1'b1;
					BREADY==1'b1;
					AWADDR[1:0]==2'b00;
					AWADDR inside {
									[32'h00000000:32'h00000024],
									[32'h00000034:32'h00000038],
									32'h0000003C
					};
					WSTRB!=4'b0000;
	});
	finish_item(req);
	end
endtask
endclass

class read_seq extends uvm_sequence#(trans);
	`uvm_object_utils(read_seq)
trans req;
function new(string name="read_seq");
	super.new(name);
endfunction
task body();
	repeat(10) begin
	req=trans::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {
					ARVALID==1'b1;
					RREADY==1'b1;
					ARADDR[1:0]==2'b00;
					ARADDR inside {
									[32'h00000000:32'h00000024],
									[32'h00000028:32'h00000030],
									32'h0000003C};
								});
	finish_item(req);
	end
	endtask
	endclass

