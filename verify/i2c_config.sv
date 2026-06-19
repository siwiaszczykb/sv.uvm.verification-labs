class i2c_config extends uvm_object;

    bit scoreboard_enable = 0;
    bit coverage_enable = 0;

    `uvm_object_utils_begin(i2c_config)
        `uvm_field_int(scoreboard_enable, UVM_ALL_ON)
        `uvm_field_int(coverage_enable, UVM_ALL_ON)
    `uvm_object_utils_end

function new(string name = "i2c_config");
    super.new(name);
endfunction

endclass