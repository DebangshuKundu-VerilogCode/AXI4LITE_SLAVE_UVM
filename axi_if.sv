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
        input RVALID;
        input BVALID;
        input ARREADY;
        input WREADY;
        input AWREADY;
        input ARESETn;
        input BRESP;
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
        input AWREADY;
        input WREADY;
        input ARREADY;
        input RVALID;
        input BVALID;
        input ARESETn;
        input BRESP;
        input RRESP;
endclocking
clocking out_mon_cb@(posedge ACLK);
        default input #1 output #1;
        input ARESETn;
        input AWADDR;
        input WDATA;
        input ARADDR;
        input AWVALID;
        input WVALID;
        input ARVALID;
        input WSTRB;
        input BREADY;
        input RREADY;
        input AWPROT;
        input ARPROT;
        input AWREADY;
        input WREADY;
        input BRESP;
        input BVALID;
        input ARREADY;
        input RDATA;
        input RRESP;
        input RVALID;
endclocking

property reset;
@(posedge ACLK) !(ARESETn) |-> RDATA==32'b0 && !RVALID && !BVALID;
endproperty
assert property(reset)
else
$error("Reset error");

property bvalid;
@(posedge ACLK) BVALID && !BREADY |=> BVALID;
endproperty
assert property(bvalid)
else
$error("BVALID error");

property bresp;
@(posedge ACLK) BVALID |=> !($isunknown(BRESP));
endproperty
assert property(bresp)
else
$error("BRESP error");

property rvalid;
@(posedge ACLK) RVALID && !RREADY |=> RVALID;
endproperty
assert property(rvalid)
else
$error("RVALID error");

property awaddr ;
@(posedge ACLK) AWVALID |=> !($isunknown(AWADDR));
endproperty
assert property(awaddr)
else
$error("AWADDR error");

property wdata;
@(posedge ACLK) WVALID |=> !($isunknown(WDATA)) && !($isunknown(WSTRB));
endproperty
assert property(wdata)
else
$error("WDATA error");

property rdata;
@(posedge ACLK) RVALID |=> !($isunknown(RDATA));
endproperty
assert property(rdata)
else
$error("RDATA error");

property rresp;
@(posedge ACLK) RVALID |=> !($isunknown(RRESP));
endproperty
assert property(rresp)
else
$error("RRESP error");

modport INP_DRV(clocking inp_drv_cb);
modport INP_MON(clocking inp_mon_cb);
modport OUT_MON(clocking out_mon_cb);
endinterface
