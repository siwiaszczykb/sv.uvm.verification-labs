`timescale 1ns/10ps 
`include "uvm_macros.svh" 

package tb_pkg;
    import uvm_pkg::*;    

    typedef enum logic [2:0] {
        CMD_IDLE        = 3'd0,
        CMD_READ_ID     = 3'd1,
        CMD_READ_STATUS = 3'd2,
        CMD_READ_DATA   = 3'd3,
        CMD_WRITE_DATA  = 3'd4
    } cmd_t;

    const int ID = 24'h00D0D0;
    const int default_mem_val = 8'hFF;

    `include "verify/seq/sequence_item.sv"
    `include "verify/i2c_config.sv"
    `include "verify/seq/i2c_base_seq.sv"
    `include "verify/seq/i2c_sequencer.sv"
    `include "verify/i2c_driver.sv"
    `include "verify/i2c_monitor.sv"
    `include "verify/i2c_scoreboard.sv"
    `include "verify/i2c_coverage.sv"
    `include "verify/i2c_env.sv"
    `include "verify/tests/i2c_test.sv"

endpackage