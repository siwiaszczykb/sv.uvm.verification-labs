module dut (
    input   clk, 
    input   rstn
);

logic a1_net, a2_net, wp_net;
logic sda_net, scl_net;
logic clk_net, reset_net;

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
    .a1(a1_net),
    .a2(a2_net),
    .wp(wp_net),
    .sda(sda_net),
    .scl(scl_net)
);

endmodule
