import tb_pkg::*;

interface i2c_if(input logic clk, input logic rstn);
    logic        valid;
    cmd_t        cmd;
    logic [16:0] addr;
    logic [7:0]  w_data;
    
    logic        ready;
    logic        r_data_valid;
    logic [23:0] r_data;
endinterface