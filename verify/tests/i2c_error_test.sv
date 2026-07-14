class i2c_error_test extends i2c_test;
    `uvm_component_utils(i2c_error_test)

    function new (string name = "i2c_error_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task main_phase(uvm_phase phase);
        i2c_error_seq err_seq;
        err_seq = i2c_error_seq::type_id::create("err_seq");

        phase.phase_done.set_drain_time(this, 50000ns);
        phase.raise_objection(this);
        
        `uvm_info("TEST", "Starting Error Injection Direct Test", UVM_LOW)
        err_seq.start(m_env.m_seqr);
        
        phase.drop_objection(this);
    endtask
endclass