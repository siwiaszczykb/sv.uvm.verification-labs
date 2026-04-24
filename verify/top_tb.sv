`timescale 1ns/10ps 

module top_tb (
    output logic clk, 
    output logic rstn,
    output logic valid,
    output logic [2:0] cmd,
    output logic [16:0] addr,
    output logic [7:0] w_data,
    input  logic ready,
    input  logic r_data_valid,
    input  logic [23:0] r_data
);

localparam CMD_READ_ID     = 3'd1;
localparam CMD_READ_STATUS = 3'd2;
localparam CMD_READ_DATA   = 3'd3;
localparam CMD_WRITE_DATA  = 3'd4;

initial clk = 0;
always #5 clk = ~clk; //100Mhz clk

task execute_i2c(
    input logic [2:0]  t_cmd,
    input logic [16:0] t_addr,
    input logic [7:0]  t_wdata,
    input string       op_name
);
    begin
        $display("[%0t] Now doing: %s", $time, op_name);
        cmd = t_cmd;
        addr = t_addr;
        w_data = t_wdata;
        valid = 1;

        @(posedge clk);
        while (ready == 1'b1) @(posedge clk);
        valid = 0; 

        while (ready == 1'b0) @(posedge clk);

        $display("[%0t] End of %s. Data received: %h", $time, op_name, r_data);
    end
endtask


initial begin
    $display("SIM start");

    rstn = 0;
    valid = 0;
    cmd = 0;
    addr = 0;
    w_data = 0;

    $display("Reset asserted, waiting 200 ns");
    #200;
    rstn = 1;
    $display("Reset deasserted, waiting for controller to be ready...");

    #1000;

    execute_i2c(CMD_READ_ID, 17'h00000, 8'h00, "READ ID");
                            sequence_step <= 4;

                            state_reg <= RX_BYTE; 

                            bit_cnt <= 0;
    #5000;

    execute_i2c(CMD_READ_STATUS, 17'h00000, 8'h00, "READ STATUS");

    #5000;

    execute_i2c(CMD_WRITE_DATA, 17'h01234, 8'hA5, "WRITE DATA (0xA5 to 0x1234 addr)");

    $display("Waiting 5ms for the data to be physically written", $time);
    #5500000; 

    execute_i2c(CMD_READ_DATA, 17'h01234, 8'h00, "READ DATA (0xA5 expected)");

    #5000;
    $display("All tests finished");
    $finish;
end

endmodule