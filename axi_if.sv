`include "defines.svh"
interface axi_if(input logic ACLK,input logic ARESETn);
logic [`ADDR_WIDTH-1:0] AWADDR;
logic [2:0] AWPROT;
logic AWVALID;
logic AWREADY;
logic [`DATA_WIDTH-1:0] WDATA;
logic [(`DATA_WIDTH/8)-1:0] WSTRB;
logic WVALID;
logic WREADY;
logic [1:0] BRESP;
logic BVALID;
logic BREADY;
logic [`ADDR_WIDTH-1:0] ARADDR;
logic [2:0] ARPROT;
logic ARVALID;
logic ARREADY;
logic [`DATA_WIDTH-1:0] RDATA;
logic [1:0] RRESP;
logic RVALID;
logic RREADY;

bit[2:0]w_state;
bit r_state;
clocking inp_drv_cb@(posedge ACLK);
	default input #1 output #1;
	output AWADDR;
	output AWPROT;
	output AWVALID;
	output WDATA;
	output WSTRB;
	output WVALID;
	output BREADY;
	output ARADDR;
	output ARPROT;
	output ARVALID;
	output RREADY;
endclocking
clocking inp_mon_cb@(posedge ACLK);
	default input #1 output #1;
	input AWADDR;
  input AWPROT;
  input AWVALID;
  input WDATA;
  input WSTRB;
  input WVALID;
  input BREADY;
  input ARADDR;
  input ARPROT;
  input ARVALID;
  input RREADY;
	//input AWREADY;
	//input WREADY;
	//input ARREADY;
endclocking
clocking out_mon_cb@(posedge ACLK);
	default input #1 output #1;
	input AWREADY;
	input WREADY;
	input BRESP;
	input BVALID;
	input ARREADY;
	input RDATA;
	input RRESP;
	input RVALID;
endclocking
modport INP_DRV(clocking inp_drv_cb);
modport INP_MON(clocking inp_mon_cb);
modport OUT_MON(clocking out_mon_cb);

widle_wboth:assert property(
@(posedge ACLK)
(w_state==w_idle && ARESETn)|=>(w_state==w_both)
)
else
				`uvm_error("assertion_fail","w_idle to w_both")

wboth_wresp:assert property(
@(posedge ACLK)
(AWVALID && WVALID)|=>(w_state==w_resp)
)
else
				`uvm_error("assertion_fail","w_both to w_resp")
wboth_waddr:assert property(
@(posedge ACLK)
(AWVALID && !WVALID)|=>(w_state==w_addr)
)
else
				`uvm_error("assertion fail","w_both->w_addr")
wboth_wdata:assert property(
@(posedge ACLK)
(!AWVALID && WVALID)|=>(w_state==w_data)
)
else
				`uvm_error("assertion fail","wboth to wdata")

waddr_wresp:assert property(
     @(posedge ACLK)
     WVALID |=> (w_state==w_resp)
    )
    else
      `uvm_error("assertion_fail","w_addr->w_resp");


wdata_wresp:assert property(
     @(posedge ACLK)
     AWVALID |=> (w_state==w_resp)
    )
    else
      `uvm_error("assertion_fail","w_data->w_resp");

wresp_widle:assert property(
     @(posedge ACLK)
     (state==w_resp && BREADY) |=> (w_state==w_idle)
    )
    else
      `uvm_error("assertion_fail","w_resp->w_idle");

ridle_rdata:assert property(
     @(posedge ACLK)
     (state==r_idle && PRESETn) |=> (r_state==r_data)
    )
    else
      `uvm_error("assertion_fail","r_idle->r_data");

rdata_ridle:assert property(
     @(posedge ACLK)
     (state==r_data && RREADY) |=> (r_state==r_idle)
    )
    else
      `uvm_error("assertion_fail","r_data->r_idle");
endinterface
