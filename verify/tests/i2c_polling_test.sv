import tb_pkg::*;

class i2c_polling_test extends i2c_test;
    `uvm_component_utils(i2c_polling_test)

    function new(string name = "i2c_polling_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task main_phase(uvm_phase phase);
        i2c_polling_seq poll_seq;
        poll_seq = i2c_polling_seq::type_id::create("poll_seq");

        phase.phase_done.set_drain_time(this, 50000ns);
        phase.raise_objection(this);
        poll_seq.start(m_env.m_seqr);
        
        phase.drop_objection(this);
    endtask
endclass
