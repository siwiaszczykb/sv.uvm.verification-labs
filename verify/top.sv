`timescale 1ns/10ps
import tb_pkg::*;

module top ();

logic clk, rstn;
logic valid;
cmd_t cmd;
logic [16:0] addr;
logic [7:0] w_data;
logic ready;
logic r_data_valid;
logic [23:0] r_data;

dut dut1 (
    .clk(clk),
    .rstn(rstn),
    .valid(valid),
    .cmd(cmd),
    .addr(addr),
    .w_data(w_data),
    .ready(ready),
    .r_data_valid(r_data_valid),
    .r_data(r_data)
);

top_tb testbench (
    .clk(clk),
    .rstn(rstn),
    .valid(valid),
    .cmd(cmd),
    .addr(addr),
    .w_data(w_data),
    .ready(ready),
    .r_data_valid(r_data_valid),
    .r_data(r_data)
);

endmodule