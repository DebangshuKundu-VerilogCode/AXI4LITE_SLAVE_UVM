class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)
uvm_tlm_analysis_fifo#(trans) inp_mon_fifo;
uvm_tlm_analysis_fifo#(trans) out_mon_fifo;
trans inp_mon;
trans out_mon;
logic [31:0] ref_mem [bit [15:0]];
logic [1:0]exp_bresp, exp_rresp;
logic [31:0]exp_data;
int pass, fail;
function new(string name="scoreboard",uvm_component parent);
super.new(name,parent);
inp_mon_fifo=new("inp_mon_fifo",this);
out_mon_fifo=new("out_mon_fifo",this);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
inp_mon=trans::type_id::create("inp_mon");
out_mon=trans::type_id::create("out_mon");
pass=0;
fail=0;
endfunction

task reset_ref_model();
begin
for(int i=0;i<16;i++) begin
ref_mem[i]=32'h0;

end
exp_bresp=0;
exp_rresp=0;
exp_data=0;
//pass=0;
//fail=0;
end
endtask

task run_phase(uvm_phase phase);
reset_ref_model();
forever begin
`uvm_info("SB Check","Waiting for input",UVM_NONE)
inp_mon_fifo.get(inp_mon);
`uvm_info("SB Check","Got input",UVM_NONE)
out_mon_fifo.get(out_mon);
`uvm_info("SB Check","Output received",UVM_NONE)
ref_model(inp_mon);
`uvm_info("SB Check","Ref model done",UVM_NONE)
compare_output();
`uvm_info("SB Check","Comparisone done",UVM_NONE)
end
endtask

virtual task ref_model(trans t);
if(!t.ARESETn) begin
reset_ref_model();
return;
end

if(t.w_r) begin
if(t.AWADDR[1:0]!=2'b00) exp_bresp=2'b10;
else if((t.AWADDR>=32'h00 && t.AWADDR<=32'h24) || (t.AWADDR>=32'h34 && t.AWADDR <=32'h38) || t.AWADDR==32'h3C) begin
exp_bresp=2'b00;
ref_mem[t.AWADDR[5:2]]=t.WDATA;
end
else if(t.AWADDR>=32'h28 && t.AWADDR<=32'h30) exp_bresp=2'b10;
else exp_bresp=2'b11;
end

else begin
if(t.ARADDR[1:0]!=2'b00) exp_rresp=2'b10;
else if(t.ARADDR>=32'h34 && t.ARADDR <=32'h38) exp_rresp=2'b10;
else if((t.ARADDR>=32'h00 && t.ARADDR<=32'h24) || (t.ARADDR>=32'h28 && t.ARADDR <=32'h30) || t.ARADDR==32'h3C) begin
exp_rresp=2'b00;
exp_data=ref_mem[t.ARADDR[5:2]];
end
else exp_rresp=2'b11;
end
endtask

virtual task compare_output();

if(inp_mon.w_r) begin
if(out_mon.BRESP==exp_bresp) begin
pass++;
`uvm_info(get_type_name,$sformatf("write response correct exp=%b act=%b",exp_bresp, out_mon.BRESP), UVM_NONE);
end
else begin
fail++;
`uvm_error(get_type_name,$sformatf("write response error exp=%b act=%b",exp_bresp, out_mon.BRESP));
end
end
else begin
if(out_mon.RRESP== exp_rresp && out_mon.RDATA == exp_data) begin
pass++;
`uvm_info(get_type_name,$sformatf("read response and data correct exp=%b act=%b exp_data=%d act=%d",exp_rresp, out_mon.RRESP, exp_data, out_mon.RDATA), UVM_NONE);
end
else if( out_mon.RRESP!= exp_rresp && out_mon.RDATA == exp_data) begin
fail++;
`uvm_error(get_type_name,$sformatf("read response error exp=%b act=%b exp_data=%d act=%d",exp_rresp, out_mon.RRESP, exp_data, out_mon.RDATA));
end
else if( out_mon.RRESP== exp_rresp && out_mon.RDATA != exp_data) begin
fail++;
`uvm_error(get_type_name,$sformatf("read data error exp=%b act=%b exp_data=%d act=%d",exp_rresp, out_mon.RRESP, exp_data, out_mon.RDATA));
end
else begin
fail++;
`uvm_error(get_type_name,$sformatf("read response and data error exp=%b act=%b exp_data=%d act=%d",exp_rresp, out_mon.RRESP, exp_data, out_mon.RDATA));
end
end
endtask

function void report_phase(uvm_phase phase);
super.report_phase(phase);
`uvm_info(get_type_name(),$sformatf("\n Passed Tests: %0d\n Failed Tests: %0d\n",pass,fail),UVM_NONE);
endfunction
endclass
