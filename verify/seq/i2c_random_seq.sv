import tb_pkg::*;

class i2c_random_seq extends uvm_sequence#(i2c_seq_item);
    `uvm_object_utils(i2c_random_seq)

    function new(string name = "i2c_random_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        i2c_seq_item req;

        req = i2c_seq_item::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {cmd == CMD_WRITE_DATA;})
            `uvm_fatal("SEQ", "randomization failed")
        finish_item(req);
        #5500000;

        req = i2c_seq_item::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {cmd == CMD_READ_DATA;})
            `uvm_fatal("SEQ", "randomization failed")
        finish_item(req);
        #5000;        

        for(int i = 0; i<20; i++) begin
            req = i2c_seq_item::type_id::create("req");
            start_item(req);

            if(!req.randomize()) 
                `uvm_fatal("SEQ", "randomization failed")

            `uvm_info("SEQ", $sformatf("randomly selected: CMD=%s, BURST=%s", req.cmd.name(), req.data_len.name()), UVM_HIGH)  

            finish_item(req);

            if(req.cmd == CMD_WRITE_DATA) #5500000;
            else #5000;
        end
    endtask
endclass