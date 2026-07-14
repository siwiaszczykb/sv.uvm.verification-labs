import tb_pkg::*;

class i2c_error_seq extends uvm_sequence#(i2c_seq_item);
    `uvm_object_utils(i2c_error_seq)

    function new(string name = "i2c_error_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        i2c_seq_item req;
        logic [16:0] test_addr = 17'h02137;

        req = i2c_seq_item::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {
            cmd == CMD_WRITE_DATA; 
            data_len == SINGLE;
            addr == test_addr;
        }) `uvm_fatal("SEQ", "randomization failed")
        finish_item(req);
        
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