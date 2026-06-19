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

    `include "verify/seq/sequence_item.sv"
    `include "verify/i2c_config.sv"
    `include "verify/seq/i2c_base_seq.sv"
    `include "verify/seq/sequencer.sv"
    `include "verify/driver.sv"
    `include "verify/monitor.sv"
    `include "verify/env.sv"
    `include "verify/tests/test.sv"

endpackage