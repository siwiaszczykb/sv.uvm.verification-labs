class i2c_base_seq extends uvm_sequence#(i2c_seq_item);

`uvm_object_utils(i2c_base_seq)

function new (string name = "i2c_base_seq");
    super.new(name);
endfunction

virtual task body();
        i2c_seq_item req; // Deklaracja tylko tutaj
        logic [16:0] current_addr;
        logic [7:0]  current_data;

        req = i2c_seq_item::type_id::create("req");
        start_item(req);
        if (!req.randomize() with { cmd == CMD_READ_ID; addr == 17'h0; w_data == 8'h00; }) 
            `uvm_error(get_full_name(), "Randomization failed!") // Zmieniono ID
        finish_item(req);
        req = i2c_seq_item::type_id::create("req");
        start_item(req);
        if (!req.randomize() with { cmd == CMD_READ_STATUS; w_data == 8'h00; }) 
            `uvm_error("SEQ", "Randomization failed!")
        finish_item(req);
        for(int i = 0; i < 5; i++) begin
            current_addr = $urandom_range(0, 17'h1FFFF);
            current_data = $urandom_range(0, 8'hFF);

            req = i2c_seq_item::type_id::create("req_write");
            start_item(req);
            if (!req.randomize() with { cmd == CMD_WRITE_DATA; addr == current_addr; w_data == current_data; }) 
                `uvm_error("SEQ", "Randomization failed!")
            finish_item(req);
            #5500000;
            req = i2c_seq_item::type_id::create("req_read");
            start_item(req);
            if (!req.randomize() with { cmd == CMD_READ_DATA; addr == current_addr; w_data == 8'h00; }) 
                `uvm_error("SEQ", "Randomization failed!")
            finish_item(req);

            #5000;
        end
        
        `uvm_info("SEQ", "sequence end", UVM_LOW)
    endtask

endclass