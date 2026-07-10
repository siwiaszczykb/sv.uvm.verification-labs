import tb_pkg::*;

class i2c_seq_item extends uvm_sequence_item;

rand bit [16:0]     addr;
rand cmd_t          cmd;
rand bit [127:0]      w_data;
rand data_len_t     data_len;

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

constraint c_cmd_dist {
    soft cmd dist {
        CMD_WRITE_DATA := 50,
        CMD_READ_DATA := 50
    };
}

constraint data_dist {
    data_len dist {
        SHORT  := 40,
        MEDIUM := 30,
        LONG   := 20,
        SINGLE := 5,
        MAX    := 5
    };
}

constraint c_w_data_mask {
    (data_len == SINGLE) -> w_data[127:8]  == 0;
    (data_len == SHORT)  -> w_data[127:16] == 0;
    (data_len == MEDIUM) -> w_data[127:32] == 0;
    (data_len == LONG)   -> w_data[127:64] == 0;
}

endclass
