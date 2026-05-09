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
    m_env - i2c_env::type_id::create("m_env", this);
endfunction

virtual task main_phase(uvm_phase phase);
    seq = i2c_base_seq::type_id::create("seq");

    phase.raise_objection(this);
    `uvm_info("TEST", "Sequence starting", UVM_LOW)
    seq.start(m_env.m_seqr);
    phase.drop_objection(this);
endtask

endclass