import tb_pkg::*;

class i2c_polling_seq extends uvm_sequence#(i2c_seq_item);
    `uvm_object_utils(i2c_polling_seq)

    function new(string name = "i2c_polling_seq");
        super.new(name);
    endfunction

    virtual task body();
        i2c_seq_item req;
        i2c_config cfg;
        logic [16:0] test_addr = 17'h03000;
        logic [7:0]  test_data = 8'hAA;

        if(!uvm_config_db#(i2c_config)::get(get_sequencer(), "", "cfg", cfg))
            `uvm_fatal("SEQ", "config not loaded")

        req = i2c_seq_item::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {
            cmd == CMD_WRITE_DATA;
            data_len == SINGLE;
            addr == test_addr;
            w_data == test_data;
        }) `uvm_fatal("SEQ", "randomization failed")
        finish_item(req);

        `uvm_info("SEQ", "write sent, polling in progress", UVM_LOW)
        cfg.scoreboard_enable = 0;

        do begin
            #500000; 
            
            req = i2c_seq_item::type_id::create("req");
            
            start_item(req);
            if(!req.randomize() with {
                cmd == CMD_READ_DATA;
                data_len == SINGLE;
                addr == test_addr;
            }) `uvm_fatal("SEQ", "randomization failed")
            finish_item(req);
            
            `uvm_info("SEQ", $sformatf("polling... received: %h", req.r_data[7:0]), UVM_HIGH)
        end while (req.r_data[7:0] !== test_data);

        cfg.scoreboard_enable = 1;
        req = i2c_seq_item::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {
            cmd == CMD_READ_DATA;
            data_len == SINGLE;
            addr == test_addr;
        }) `uvm_fatal("SEQ", "randomization failed")
        finish_item(req);
    endtask
endclass