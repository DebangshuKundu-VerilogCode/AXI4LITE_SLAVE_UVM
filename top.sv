`include "defines.svh"
`include "axi_if.sv"
`include "axi4_lite_slave.sv"
`include "axi_test_pkg.sv"

module top();
  import uvm_pkg::*;
        import axi_test_pkg::*;
        bit ACLK;
        bit ARESETn;
        axi_if DUV_IF(ACLK,ARESETn);

        axi4_lite_slave DUV(.ACLK(ACLK),
                       .ARESETn(ARESETn),
                       .AWADDR(DUV_IF.AWADDR),
                       .AWPROT(DUV_IF.AWPROT),
                       .AWVALID(DUV_IF.AWVALID),
                       .AWREADY(DUV_IF.AWREADY),
                       .WDATA(DUV_IF.WDATA),
                       .WSTRB(DUV_IF.WSTRB),
                       .WVALID(DUV_IF.WVALID),
                       .WREADY(DUV_IF.WREADY),
                       .BRESP(DUV_IF.BRESP),
                       .BVALID(DUV_IF.BVALID),
                       .BREADY(DUV_IF.BREADY),
                       .ARADDR(DUV_IF.ARADDR),
                       .ARPROT(DUV_IF.ARPROT),
                       .ARVALID(DUV_IF.ARVALID),
                       .ARREADY(DUV_IF.ARREADY),
                       .RDATA(DUV_IF.RDATA),
                       .RRESP(DUV_IF.RRESP),
                       .RVALID(DUV_IF.RVALID),
                       .RREADY(DUV_IF.RREADY));
initial begin
     uvm_config_db#(virtual axi_if)::set(null,"*","axi_if",DUV_IF);
     $dumpfile("waves.fsdb");
     $dumpvars;
     run_test("test_regr");
   end
initial begin
                 ARESETn=1;
     #1 ARESETn=0;
     repeat(5)@(posedge ACLK);
     #1 ARESETn=1;
   end
initial begin
     ACLK=1'b0;
     forever
       #5 ACLK=~ACLK;
   end

endmodule
