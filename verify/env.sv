class i2c_env extends uvm_env;

`uvm_component_utils(i2c_env)

i2c_sequencer m_seqr;
i2c_driver m_drv;
i2c_monitor m_mon;

function new (string name = "i2c_env", uvm_component parent = null);
    super.new (name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_drv = i2c_driver::type_id::create("m_drv", this);
    m_seqr = i2c_sequencer::type_id::create("m_seqr", this); 
    m_mon = i2c_monitor::type_id::create("m_mon", this); 
endfunction

virtual function void connect_phase(uvm_phase phase);
    m_drv.seq_item_port.connect(m_seqr.seq_item_export);
endfunction

endclass