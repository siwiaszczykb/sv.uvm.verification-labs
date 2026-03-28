module top_tb (
    output logic clk, 
    output logic rstn
);

initial clk = 0;
always #5 clk = ~clk;

initial begin
    $display("SIM start");
    rstn = 0;
    $display("Reset asserted, waiting 20 units");
    #20;
    rstn = 1;
    $display("Reset deasserted, waiting 100 units and finishing");
    #100;
    $finish;
end

endmodule