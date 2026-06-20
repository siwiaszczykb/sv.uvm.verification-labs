class i2c_coverage extends uvm_subscriber #(i2c_seq_item);
    `uvm_component_utils(i2c_coverage)

    cmd_t current_cmd;
    logic [16:0] current_addr;

    i2c_config cfg;

    covergroup i2c_cg;
        option.per_instance = 1;
        
        cp_cmd: coverpoint current_cmd {
            bins read_cmds  = {CMD_READ_ID, CMD_READ_STATUS, CMD_READ_DATA};
            bins write_cmds = {CMD_WRITE_DATA};
            bins idle       = {CMD_IDLE};
        }
        
        cp_addr: coverpoint current_addr {
            bins low_addr  = {[17'h00000 : 17'h0FFFF]};
            bins high_addr = {[17'h10000 : 17'h1FFFF]};
        }
        
        cross_cmd_addr: cross cp_cmd, cp_addr;
    endgroup

    function new(string name = "i2c_coverage", uvm_component parent = null);
        super.new(name, parent);
        i2c_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(i2c_config)::get(this, "", "cfg", cfg))
            `uvm_fatal(get_full_name(), "Failed to get config object")
    endfunction

    virtual function void write(i2c_seq_item t);
        if (cfg != null && cfg.coverage_enable == 0) return;

        current_cmd = t.cmd;
        current_addr = t.addr;
        
        i2c_cg.sample();
        
        `uvm_info(get_full_name(), $sformatf("Coverage sampled for cmd: %s, addr: %h", current_cmd.name(), current_addr), UVM_HIGH)
    endfunction

endclass