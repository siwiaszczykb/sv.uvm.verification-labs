class i2c_driver extends uvm_driver#(i2c_seq_item);
    `uvm_component_utils(i2c_driver)

    virtual i2c_if vif;

    function new(string name = "i2c_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual i2c_if)::get(this, "", "vif", vif))
            `uvm_fatal(get_full_name(), "Not set at top level"); 
    endfunction

    task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        phase.raise_objection(this); 
        
        vif.valid <= 1'b0;
        vif.cmd <= CMD_IDLE;
        vif.addr <= 17'h0;
        vif.w_data <= 8'h0;
        
        wait(vif.rstn == 1'b1);
        #1000;
        
        phase.drop_objection(this);
    endtask

    task main_phase(uvm_phase phase);
        super.main_phase(phase);
        
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info(get_full_name(), $sformatf("Transaction received: cmd=%s, addr=%h", req.cmd.name(), req.addr), UVM_HIGH)

            vif.cmd <= req.cmd;
            vif.addr <= req.addr;
            vif.w_data <= req.w_data;
            vif.valid <= 1'b1;

            @(posedge vif.clk);
            while (vif.ready == 1'b1) @(posedge vif.clk);
            vif.valid <= 1'b0;

            while (vif.ready == 1'b0) @(posedge vif.clk);

            req.r_data = vif.r_data;
            vif.cmd <= CMD_IDLE;
            vif.addr <= 17'h0;
            vif.w_data <= 8'h0;

            `uvm_info(get_full_name(), $sformatf("Cmd finished, read value: %h", req.r_data), UVM_HIGH) 
            seq_item_port.item_done();
        end
    endtask

endclass