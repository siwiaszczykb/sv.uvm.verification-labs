`timescale 1ns/10ps

module dut (
    input  logic        clk, 
    input  logic        rstn,

    input  logic        valid,
    input  logic [2:0]  cmd,
    input  logic [16:0] addr,
    input  logic [7:0]  w_data,
    output logic        ready,
    output logic        r_data_valid,
    output logic [23:0] r_data
);

logic a1_net, a2_net, wp_net;
wire sda_net;
pullup(sda_net);
logic scl_net;
logic reset_net;

assign reset_net = ~rstn; 

M24CSM01 spimem_model (
    .A1(a1_net), 
    .A2(a2_net), 
    .WP(wp_net), 
    .SDA(sda_net), 
    .SCL(scl_net), 
    .RESET(reset_net)
);

controller memorycontroller (
    .clk(clk),
    .rst(rstn),
    .valid(valid),
    .cmd(cmd),
    .addr(addr),
    .w_data(w_data),
    .a1(a1_net),
    .a2(a2_net),
    .wp(wp_net),
    .sda(sda_net),
    .scl(scl_net),
    .ready(ready),
    .r_data_valid(r_data_valid),
    .r_data(r_data)
);

endmodule