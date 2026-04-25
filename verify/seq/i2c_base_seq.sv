import tb_pkg::*;

class i2c_base_seq extends uvm_sequence#(i2c_seq_item);

`uvm_object_utils(i2c_base_seq)

function new (string name = "i2c_base_seq");
    super.new(name);
endfunction

i2c_seq_item req;

virtual task body();
for(int i = 0; i < 5; i++) begin
    req = i2c_seq_item::type_id::create("req");
    start_item(req);
    finish_item(req);
end
endtask

endclass