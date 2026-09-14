class trans extends uvm_sequence_item;
  rand logic[`ADDR_WIDTH-1:0]AWADDR;
        bit[2:0] AWPROT;
  rand logic AWVALID;
        bit ARESETn;
  logic AWREADY;

  rand logic[`DATA_WIDTH-1:0]WDATA;
  rand logic[(`DATA_WIDTH/8)-1:0]WSTRB;
  rand logic WVALID;
  logic WREADY;

  logic[1:0]BRESP;
  logic BVALID;
  rand logic BREADY;

  rand logic[`ADDR_WIDTH-1:0]ARADDR;
        bit[2:0] ARPROT;
  rand logic ARVALID;
  logic ARREADY;

  logic[`DATA_WIDTH-1:0]RDATA;
  logic[1:0]RRESP;
  logic RVALID;
  rand logic RREADY;

        rand bit w_r;
        rand bit[1:0] order;
        bit a;
  constraint awaddr{AWADDR dist{[0:63]:/100, [64:(2**(`ADDR_WIDTH)-1)]:/100};}
        constraint araddr{ARADDR dist{[0:63]:/100, [64:(2**(`ADDR_WIDTH)-1)]:/100};}



 `uvm_object_utils_begin(trans)

  `uvm_field_int(w_r,UVM_ALL_ON)
        `uvm_field_int(order,UVM_ALL_ON)
  `uvm_field_int(AWADDR,UVM_ALL_ON)
  `uvm_field_int(AWVALID,UVM_ALL_ON)
  `uvm_field_int(AWREADY,UVM_ALL_ON)

  `uvm_field_int(WDATA,UVM_ALL_ON)
  `uvm_field_int(WSTRB,UVM_ALL_ON)
  `uvm_field_int(WVALID,UVM_ALL_ON)
  `uvm_field_int(WREADY,UVM_ALL_ON)

  `uvm_field_int(BRESP,UVM_ALL_ON)
  `uvm_field_int(BVALID,UVM_ALL_ON)
  `uvm_field_int(BREADY,UVM_ALL_ON)

  `uvm_field_int(ARADDR,UVM_ALL_ON)
  `uvm_field_int(ARVALID,UVM_ALL_ON)
  `uvm_field_int(ARREADY,UVM_ALL_ON)

  `uvm_field_int(RDATA,UVM_ALL_ON)
  `uvm_field_int(RRESP,UVM_ALL_ON)
  `uvm_field_int(RVALID,UVM_ALL_ON)
  `uvm_field_int(RREADY,UVM_ALL_ON)

  `uvm_field_int(AWPROT,UVM_ALL_ON)
  `uvm_field_int(ARPROT,UVM_ALL_ON)
  `uvm_field_int(ARESETn,UVM_ALL_ON)

  `uvm_object_utils_end


  function new(string name="trans");
    super.new(name);
  endfunction

endclass
