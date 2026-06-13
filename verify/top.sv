`timescale 1ns/10ps

import uvm_pkg::*;
`include "uvm_macros.svh"
import tb_pkg::*;

module top ();

logic clk, rstn;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rstn = 0;
    #200;
    rstn =1;
end

i2c_if vif (
    .clk(clk),
    .rstn(rstn)
);

dut dut1 (
    .clk(clk),
    .rstn(rstn),
    .valid(vif.valid),
    .cmd(vif.cmd),
    .addr(vif.addr),
    .w_data(vif.w_data),
    .ready(vif.ready),
    .r_data_valid(vif.r_data_valid),
    .r_data(vif.r_data)
);

initial begin
    uvm_config_db#(virtual i2c_if)::set(null, "*", "vif", vif);
    run_test();
end

endmodule