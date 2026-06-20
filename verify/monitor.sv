class i2c_monitor extends uvm_monitor;

    `uvm_component_utils(i2c_monitor)

    virtual i2c_if vif;
    
    uvm_analysis_port #(i2c_seq_item) analysis_port; 

    function new (string name = "i2c_monitor", uvm_component parent = null);
        super.new (name, parent);
    endfunction   

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db#(virtual i2c_if)::get(this, "", "vif", vif))
            `uvm_fatal(get_full_name(), "Not set at top level");
            
        analysis_port = new("analysis_port", this);
    endfunction

    task main_phase(uvm_phase phase);
        i2c_seq_item item;
        
        forever begin
            @(posedge vif.clk); 
            
            if (vif.valid == 1'b1 && vif.ready == 1'b1) begin
                
                item = i2c_seq_item::type_id::create("item");
                
                item.cmd = vif.cmd;
                item.addr = vif.addr;
                item.w_data = vif.w_data;

                while (vif.ready == 1'b1) @(posedge vif.clk);
                while (vif.ready == 1'b0) @(posedge vif.clk);

                item.r_data = vif.r_data;
                item.r_data_valid = vif.r_data_valid; 

                analysis_port.write(item); 
            end
        end
    endtask

endclass