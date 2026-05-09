import tb_pkg::*;

class i2c_seq_item extends uvm_sequence_item;

rand bit [16:0]     addr;
rand cmd_t          cmd;
rand bit [7:0]      w_data;

bit      [23:0]     r_data;
bit                 r_data_valid;
bit                 ready;

`uvm_object_utils_begin(i2c_seq_item)
    `uvm_field_enum(cmd_t, cmd, UVM_ALL_ON)
    `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_field_int(w_data,UVM_ALL_ON)
    `uvm_field_int(r_data,UVM_ALL_ON)
`uvm_object_utils_end

function new(string name = "i2c_seq_item");
    super.new(name);
endfunction

constraint notidle { cmd != CMD_IDLE; };

endclass
