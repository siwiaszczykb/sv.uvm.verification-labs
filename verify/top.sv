module top (
);

logic clk, rstn;

dut dut1 (
    .clk(clk),
    .rstn(rstn)
);

top_tb testbench (
    .clk(clk),
    .rstn(rstn)
);

endmodule
