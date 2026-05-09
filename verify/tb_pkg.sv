`timescale 1ns/10ps 
import uvm_pkg::*;
`include "uvm_macros.svh"

package tb_pkg;
    typedef enum logic [2:0] {
        CMD_IDLE        = 3'd0,
        CMD_READ_ID     = 3'd1,
        CMD_READ_STATUS = 3'd2,
        CMD_READ_DATA   = 3'd3,
        CMD_WRITE_DATA  = 3'd4
    } cmd_t;
endpackage