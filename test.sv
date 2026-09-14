class test extends uvm_test;
        `uvm_component_utils(test)
env env_h;
axi_config m;
function new(string name="test",uvm_component parent);
        super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
        super.build_phase(phase);
m=axi_config::type_id::create("m");
if(!uvm_config_db#(virtual axi_if)::get(this,"","axi_if",m.vif))
                                `uvm_fatal(get_type_name,"can't get the interface")
m.inp_agent_is_active=UVM_ACTIVE;
m.out_agent_is_active=UVM_PASSIVE;
uvm_config_db#(axi_config)::set(this,"*","axi_config",m);
env_h=env::type_id::create("env_h",this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
endfunction

function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info(get_type_name(),"simulation started",UVM_LOW)
endfunction

task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name(),"base test running",UVM_LOW)
        phase.drop_objection(this);
endtask
endclass

class test_regr extends test;
        `uvm_component_utils(test_regr)
         write ws;
         read rs;
        seq_3 s3;
seq_4 s4;
seq_5 s5;
seq_6 s6;
seq_7 s7;
seq_8 s8;
seq_9 s9;
seq_10 s10;
seq_11 s11;
seq_12 s12;
seq_13 s13;
seq_14 s14;
seq_15 s15;
seq_16 s16;
seq_17 s17;
seq_18 s18;
seq_19 s19;
seq_20 s20;
seq_21 s21;
seq_22 s22;
seq_23 s23;
seq_24 s24;
seq_25 s25;
seq_26 s26;
seq_27 s27;
seq_28 s28;
         function new(string name="test_regr",uvm_component parent=null);
                super.new(name,parent);
         endfunction

         task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                ws=write::type_id::create("ws");
                `uvm_info("TEST","Starting write only",UVM_LOW)
                ws.start(env_h.inp_agt_h.seq_h);
                rs=read::type_id::create("rs");
                `uvm_info("TEST","Starting read only",UVM_LOW)
                rs.start(env_h.inp_agt_h.seq_h);
    s3=seq_3::type_id::create("s3");
    `uvm_info("TEST","Starting read only",UVM_LOW)
    s3.start(env_h.inp_agt_h.seq_h);
    s4=seq_4::type_id::create("s4");
`uvm_info("TEST","Starting test 4",UVM_LOW)
s4.start(env_h.inp_agt_h.seq_h);

s5=seq_5::type_id::create("s5");
`uvm_info("TEST","Starting test 5",UVM_LOW)
s5.start(env_h.inp_agt_h.seq_h);

s6=seq_6::type_id::create("s6");
`uvm_info("TEST","Starting test 6",UVM_LOW)
s6.start(env_h.inp_agt_h.seq_h);

s7=seq_7::type_id::create("s7");
`uvm_info("TEST","Starting test 7",UVM_LOW)
s7.start(env_h.inp_agt_h.seq_h);

s8=seq_8::type_id::create("s8");
`uvm_info("TEST","Starting test 8",UVM_LOW)
s8.start(env_h.inp_agt_h.seq_h);

s9=seq_9::type_id::create("s9");
`uvm_info("TEST","Starting test 9",UVM_LOW)
s9.start(env_h.inp_agt_h.seq_h);

s10=seq_10::type_id::create("s10");
`uvm_info("TEST","Starting test 10",UVM_LOW)
s10.start(env_h.inp_agt_h.seq_h);

s11=seq_11::type_id::create("s11");
`uvm_info("TEST","Starting test 11",UVM_LOW)
s11.start(env_h.inp_agt_h.seq_h);

s12=seq_12::type_id::create("s12");
`uvm_info("TEST","Starting test 12",UVM_LOW)
s12.start(env_h.inp_agt_h.seq_h);

s13=seq_13::type_id::create("s13");
`uvm_info("TEST","Starting test 13",UVM_LOW)
s13.start(env_h.inp_agt_h.seq_h);

s14=seq_14::type_id::create("s14");
`uvm_info("TEST","Starting test 14",UVM_LOW)
s14.start(env_h.inp_agt_h.seq_h);

s15=seq_15::type_id::create("s15");
`uvm_info("TEST","Starting test 15",UVM_LOW)
s15.start(env_h.inp_agt_h.seq_h);

s16=seq_16::type_id::create("s16");
`uvm_info("TEST","Starting test 16",UVM_LOW)
s16.start(env_h.inp_agt_h.seq_h);

s17=seq_17::type_id::create("s17");
`uvm_info("TEST","Starting test 17",UVM_LOW)
s17.start(env_h.inp_agt_h.seq_h);

s18=seq_18::type_id::create("s18");
`uvm_info("TEST","Starting test 18",UVM_LOW)
s18.start(env_h.inp_agt_h.seq_h);

s19=seq_19::type_id::create("s19");
`uvm_info("TEST","Starting test 19",UVM_LOW)
s19.start(env_h.inp_agt_h.seq_h);

s20=seq_20::type_id::create("s20");
`uvm_info("TEST","Starting test 20",UVM_LOW)
s20.start(env_h.inp_agt_h.seq_h);

s21=seq_21::type_id::create("s21");
`uvm_info("TEST","Starting test 21",UVM_LOW)
s21.start(env_h.inp_agt_h.seq_h);

s22=seq_22::type_id::create("s22");
`uvm_info("TEST","Starting test 22",UVM_LOW)
s22.start(env_h.inp_agt_h.seq_h);

s23=seq_23::type_id::create("s23");
`uvm_info("TEST","Starting test 23",UVM_LOW)
s23.start(env_h.inp_agt_h.seq_h);

s24=seq_24::type_id::create("s24");
`uvm_info("TEST","Starting test 24",UVM_LOW)
s24.start(env_h.inp_agt_h.seq_h);

s25=seq_25::type_id::create("s25");
`uvm_info("TEST","Starting test 25",UVM_LOW)
s25.start(env_h.inp_agt_h.seq_h);

s26=seq_26::type_id::create("s26");
`uvm_info("TEST","Starting test 26",UVM_LOW)
s26.start(env_h.inp_agt_h.seq_h);

s27=seq_27::type_id::create("s27");
`uvm_info("TEST","Starting test 27",UVM_LOW)
s27.start(env_h.inp_agt_h.seq_h);

s28=seq_28::type_id::create("s28");
`uvm_info("TEST","Starting test 28",UVM_LOW)
s28.start(env_h.inp_agt_h.seq_h);
                phase.drop_objection(this);
                phase.phase_done.set_drain_time(this,200);
                endtask
        endclass
