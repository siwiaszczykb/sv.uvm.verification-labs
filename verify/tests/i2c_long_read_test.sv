import tb_pkg::*;

class i2c_long_read_test extends i2c_test;
    `uvm_component_utils(i2c_long_read_test)

    function new(string name = "i2c_long_read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task main_phase(uvm_phase phase);
        i2c_long_read_seq lr_seq;
        lr_seq = i2c_long_read_seq::type_id::create("lr_seq");
        phase.phase_done.set_drain_time(this, 50000ns);
        phase.raise_objection(this);
        lr_seq.start(m_env.m_seqr);
        phase.drop_objection(this);
    endtask
endclass
