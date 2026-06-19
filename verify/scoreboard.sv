class i2c_scoreboard extends uvm_scoreboard;

  `uvm_component_utils (i2c_scoreboard)
  uvm_analysis_imp#(i2c_seq_item, i2c_scoreboard) item_collected_export;
  i2c_config cfg;
  logic [7:0] memory [logic[16:0]];
  logic [23:0] current_status;

  int errors = 0;
  int comparisons = 0;

  function new(string name = "i2c_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);

    if(!uvm_config_db#(i2c_config)::get(this, "", "cfg", cfg))
      `uvm_fatal(get_full_name(), "Failed to get config")
  endfunction

    virtual function void write(i2c_seq_item item);
        if (cfg != null && cfg.scoreboard_enable == 0) return; 
        case (item.cmd)
            CMD_READ_ID:     check_read_id(item);
            CMD_READ_STATUS: store_status(item);
            CMD_WRITE_DATA:  store_data(item);
            CMD_READ_DATA:   check_read_data(item);
        endcase
    endfunction

  virtual function void check_read_id(i2c_seq_item item);
    if(item.r_data !== 24'h00D0D0) begin
      `uvm_error(get_full_name(), $sformatf("Read ID mismatch, expected: 00d0d0, received: %h", item.r_data))
       errors++;
    end else begin
      `uvm_info(get_full_name(), "Read ID correct", UVM_HIGH)
    end
    comparisons++;
  endfunction

  virtual function void store_status(i2c_seq_item item);
        current_status = item.r_data;
        `uvm_info(get_full_name(), $sformatf("Status stored: %h", current_status), UVM_HIGH)
    endfunction

  virtual function void store_data(i2c_seq_item item);
        memory[item.addr] = item.w_data;
        `uvm_info(get_full_name(), $sformatf("Data stored at addr %h: %h", item.addr, item.w_data), UVM_HIGH)
    endfunction

  virtual function void check_read_data(i2c_seq_item item);
      logic [7:0] expected_data;
        
      if(memory.exists(item.addr)) begin
          expected_data = memory[item.addr];
      end else begin
          expected_data = 8'hFF;
      end

      if(item.r_data[7:0] !== expected_data) begin
          `uvm_error(get_full_name(), $sformatf("READ DATA mismatch at addr %h! Expected: %h, Got: %h", item.addr, expected_data, item.r_data[7:0]))
          errors++;
      end else begin
          `uvm_info(get_full_name(), $sformatf("READ DATA match at addr %h!", item.addr), UVM_HIGH)
      end
      comparisons++;
  endfunction

  function void check_phase(uvm_phase phase);
      super.check_phase(phase);
      if(cfg != null && cfg.scoreboard_enable == 1) begin
          if(errors > 0)
              `uvm_error(get_full_name(), $sformatf("Scoreboard finished with %0d errors in %0d comparisons.", errors, comparisons))
          else
              `uvm_info(get_full_name(), $sformatf("Scoreboard finished successfully. %0d comparisons passed.", comparisons), UVM_LOW)
      end
  endfunction

endclass