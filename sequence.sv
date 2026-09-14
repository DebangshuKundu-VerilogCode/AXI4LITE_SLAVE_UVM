class write extends uvm_sequence #(trans);
`uvm_object_utils(write)
trans req;
function new(string name="write");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {AWADDR==32'b0; WDATA==32'hFFFF;WSTRB==4'b1111;w_r==1;order==2'd3;});
finish_item(req);
end
endtask
endclass

class read extends uvm_sequence #(trans);
`uvm_object_utils(read)
trans req;
function new(string name="read");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {ARADDR==32'b0;w_r==0;});
finish_item(req);
end
endtask
endclass

class seq_3 extends uvm_sequence #(trans);
`uvm_object_utils(seq_3)
trans req;
function new(string name="seq_3");
super.new(name);
endfunction
task body();
`uvm_info("SEQ","Before start item",UVM_NONE)

req=trans::type_id::create("req");
 begin

start_item(req);
`uvm_info("SEQ","After start item",UVM_NONE)

assert(req.randomize() with {AWADDR==32'b1; WDATA==32'h5;WSTRB==4'b1111;w_r==1;order==2'd0;} );
`uvm_info("SEQ","After randomize",UVM_NONE)

finish_item(req);
`uvm_info("SEQ","After finish item",UVM_NONE)

end
endtask
endclass

class seq_4 extends uvm_sequence #(trans);
`uvm_object_utils(seq_4)
trans req;
function new(string name="seq_4");
super.new(name);
endfunction
task body();
`uvm_info("SEQ","Before start item",UVM_NONE)

req=trans::type_id::create("req");
 begin

start_item(req);
`uvm_info("SEQ","After start item",UVM_NONE)

assert(req.randomize() with {AWADDR==32'd4;WDATA==32'h5;WSTRB==4'b1111;w_r==1;order==2'd1;} );
`uvm_info("SEQ","After randomize",UVM_NONE)

finish_item(req);
`uvm_info("SEQ","After finish item",UVM_NONE)

end
endtask
endclass

class seq_5 extends uvm_sequence #(trans);
`uvm_object_utils(seq_5)
trans req;
function new(string name="seq_5");
super.new(name);
endfunction
task body();
`uvm_info("SEQ","Before start item",UVM_NONE)

req=trans::type_id::create("req");
begin

start_item(req);
`uvm_info("SEQ","After start item",UVM_NONE)

assert(req.randomize() with {ARADDR==32'd4;w_r==0;} );
`uvm_info("SEQ","After randomize",UVM_NONE)

finish_item(req);
`uvm_info("SEQ","After finish item",UVM_NONE)

end
endtask
endclass

class seq_6 extends uvm_sequence #(trans);
`uvm_object_utils(seq_6)
trans req;
function new(string name="seq_6");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h32; WDATA==32'hFFFF;WSTRB==4'b0011;w_r==1;order==2'd3;});
finish_item(req);
end
endtask
endclass

class seq_7 extends uvm_sequence #(trans);
`uvm_object_utils(seq_7)
trans req;
function new(string name="seq_7");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h34; WDATA==32'hFFFF;WSTRB==4'b1000;w_r==1;order==2'd3;});
finish_item(req);
end
endtask
endclass

class seq_8 extends uvm_sequence #(trans);
`uvm_object_utils(seq_8)
trans req;
function new(string name="seq_8");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {ARADDR==32'h28;w_r==0;});
finish_item(req);
end
endtask
endclass


class seq_9 extends uvm_sequence #(trans);
`uvm_object_utils(seq_9)
trans req;
function new(string name="seq_9");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {ARADDR==32'h26;w_r==0;});
finish_item(req);
end
endtask
endclass

class seq_10 extends uvm_sequence #(trans);
`uvm_object_utils(seq_10)
trans req;
function new(string name="seq_10");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h25; WDATA==32'hFFFF;WSTRB==4'b0000;w_r==1;order==2'd3;});
finish_item(req);
end
endtask
endclass

class seq_11 extends uvm_sequence #(trans);
`uvm_object_utils(seq_11)
trans req;
function new(string name="seq_11");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h25; WDATA==32'hFFFF;WSTRB==4'b1111;w_r==1;order==2'd3;});
finish_item(req);
end
endtask
endclass

class seq_12 extends uvm_sequence #(trans);
`uvm_object_utils(seq_12)
trans req;
function new(string name="seq_12");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h25; WDATA==32'hFFFF;WSTRB==4'b1000;w_r==1;order==2'd3;});
finish_item(req);
end
endtask
endclass

class seq_13 extends uvm_sequence #(trans);
`uvm_object_utils(seq_13)
trans req;
function new(string name="seq_13");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h34; WDATA==32'hFFFF;WSTRB==4'b0000;w_r==1;order==2'd3;});
finish_item(req);
end
endtask
endclass

class seq_14 extends uvm_sequence #(trans);
`uvm_object_utils(seq_14)
trans req;
function new(string name="seq_14");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h34; WDATA==32'hFFFF;WSTRB==4'b1111;w_r==1;order==2'd3;});
finish_item(req);
end
endtask
endclass

class seq_15 extends uvm_sequence #(trans);
`uvm_object_utils(seq_15)
trans req;
function new(string name="seq_15");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h34; WDATA==32'hFFFF;WSTRB==4'b0011;w_r==1;order==2'd3;});
finish_item(req);
end
endtask
endclass

class seq_16 extends uvm_sequence #(trans);
`uvm_object_utils(seq_16)
trans req;
function new(string name="seq_16");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h24; WDATA==32'hFFFF;WSTRB==4'b0011;w_r==1;order==2'd3;});
finish_item(req);
end
endtask
endclass

class seq_17 extends uvm_sequence #(trans);
`uvm_object_utils(seq_17)
trans req;
function new(string name="seq_17");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h24; WDATA==32'hFFFF;WSTRB==4'b0001;w_r==1;order==2'd3;});
finish_item(req);
end
endtask
endclass

class seq_18 extends uvm_sequence #(trans);
`uvm_object_utils(seq_18)
trans req;
function new(string name="seq_18");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
repeat(20) begin
start_item(req);
assert(req.randomize() with {w_r==1;});
finish_item(req);
end
endtask
endclass

class seq_19 extends uvm_sequence #(trans);
`uvm_object_utils(seq_19)
trans req;
function new(string name="seq_19");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
repeat(20) begin
start_item(req);
assert(req.randomize() with {w_r==0;});
finish_item(req);
end
endtask
endclass

class seq_20 extends uvm_sequence #(trans);
`uvm_object_utils(seq_20)
trans req;
function new(string name="seq_20");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
repeat(1) begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h24;WDATA==32'h5;WSTRB==4'b1111;w_r==1;order==2'd1;});
finish_item(req);
end
endtask
endclass

class seq_21 extends uvm_sequence #(trans);
`uvm_object_utils(seq_21)
trans req;
function new(string name="seq_21");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
repeat(1) begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h28;WDATA==32'h5;WSTRB==4'b1111;w_r==1;order==2'd3;});
finish_item(req);
end
endtask
endclass



class seq_22 extends uvm_sequence #(trans);
`uvm_object_utils(seq_22)
trans req;
function new(string name="seq_22");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
repeat(1) begin
start_item(req);
assert(req.randomize() with {a==1;AWADDR==32'h30;WDATA==32'h5;WSTRB==4'b1111;w_r==1;order==2'd2;});
finish_item(req);
end
endtask
endclass

class seq_23 extends uvm_sequence #(trans);
`uvm_object_utils(seq_23)
trans req;
function new(string name="seq_23");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
repeat(1) begin
start_item(req);
assert(req.randomize() with {a==1;AWADDR==32'h34;WDATA==32'h5;WSTRB==4'b1111;w_r==1;order==2'd2;});
finish_item(req);
end
endtask
endclass

class seq_24 extends uvm_sequence #(trans);
`uvm_object_utils(seq_24)
trans req;
function new(string name="seq_24");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
repeat(1) begin
start_item(req);
assert(req.randomize() with {ARADDR==32'h38; w_r==0;});
finish_item(req);
end
endtask
endclass

class seq_25 extends uvm_sequence #(trans);
`uvm_object_utils(seq_25)
trans req;
function new(string name="seq_25");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
repeat(1) begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h4;WDATA==32'hFFFFFFFF;WSTRB==4'b1111;order==2'd3; w_r==1;});
finish_item(req);
end
endtask
endclass

class seq_26 extends uvm_sequence #(trans);
`uvm_object_utils(seq_26)
trans req;
function new(string name="seq_26");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
repeat(1) begin
start_item(req);
assert(req.randomize() with {ARADDR==32'h4; w_r==0;});
finish_item(req);
end
endtask
endclass

class seq_27 extends uvm_sequence #(trans);
`uvm_object_utils(seq_27)
trans req;
function new(string name="seq_27");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
repeat(1) begin
start_item(req);
assert(req.randomize() with {AWADDR==32'h4;WDATA==32'h00000000;WSTRB==4'b1111;order==2'd3; w_r==1;});
finish_item(req);
end
endtask
endclass

class seq_28 extends uvm_sequence #(trans);
`uvm_object_utils(seq_28)
trans req;
function new(string name="seq_28");
super.new(name);
endfunction
task body();
req=trans::type_id::create("req");
repeat(1) begin
start_item(req);
assert(req.randomize() with {ARADDR==32'h4; w_r==0;});
finish_item(req);
end
endtask
endclass
