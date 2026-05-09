import tb_pkg::*;

class i2c_test extends uvm_test;

`uvm_component_utils(i2c_test);

i2c_env m_env;
i2c_base_seq seq;

function new (string name = "i2c_test", uvm_component parent = null);
    super.new (name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_env = i2c_env::type_id::create("m_env", this);
    uvm_top.set_timeout(60_000_000ns, 1); 
endfunction

virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("TOPOLOGY", "Printing UVM Topology:", UVM_LOW)
    uvm_top.print_topology(); 
endfunction

virtual task main_phase(uvm_phase phase);
    seq = i2c_base_seq::type_id::create("seq");
    phase.phase_done.set_drain_time(this, 50000ns);
    phase.raise_objection(this);
    `uvm_info("TEST", "Sequence starting", UVM_LOW)
    seq.start(m_env.m_seqr);
    phase.drop_objection(this);
endtask

endclass