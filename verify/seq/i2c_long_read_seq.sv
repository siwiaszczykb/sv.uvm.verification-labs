import tb_pkg::*;

class i2c_long_read_seq extends uvm_sequence#(i2c_seq_item);

    `uvm_object_utils(i2c_long_read_seq)

    function new(string name = "i2c_long_read_seq");
        super.new(name);
    endfunction

    virtual task body();
        i2c_seq_item req;
        logic [16:0] base_addr = 17'h01000;

        req = i2c_seq_item::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {
            cmd == CMD_WRITE_DATA;
            data_len == MAX;
            addr == base_addr;
        }) `uvm_fatal("SEQ", "randomization failed")
        finish_item(req);

        #5500000;

        for(int i = 0; i < 16; i++) begin
            req = i2c_seq_item::type_id::create("req");
            start_item(req);
            if(!req.randomize() with {
                cmd == CMD_READ_DATA;
                data_len == SINGLE;
                addr == base_addr + i;
            }) `uvm_fatal("SEQ", "randomization failed")
            finish_item(req);
            #5000;
        end
    endtask

endclass
