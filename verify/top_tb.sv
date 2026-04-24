`timescale 1ns/10ps 
import tb_pkg::*;

module top_tb (
    output logic         clk, 
    output logic         rstn,
    output logic         valid,
    output cmd_t         cmd,
    output logic [16:0]  addr,
    output logic [7:0]   w_data,
    input  logic         ready,
    input  logic         r_data_valid,
    input  logic [23:0]  r_data
);

initial clk = 0;
always #5 clk = ~clk; // 100MHz clk

task execute_i2c(
    input cmd_t         t_cmd,
    input logic [16:0]  t_addr,
    input logic [7:0]   t_wdata,
    input string        op_name,
    input logic         check_enable,
    input logic [23:0]  expected_data
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
        
        if (check_enable) begin
            if (r_data !== expected_data) begin
                $error("[%0t] Error in %s! Expected: %h, Received: %h", $time, op_name, expected_data, r_data);
            end else begin
                $display("[%0t] Successfully %s! Valid data received: %h", $time, op_name, r_data);
            end
        end
    end
endtask


initial begin
    $display("SIM start");
    
    rstn = 0;
    valid = 0;
    cmd = CMD_IDLE;
    addr = 0;
    w_data = 0;

    $display("Reset asserted, waiting 200 ns");
    #200;
    rstn = 1;
    $display("Reset deasserted, waiting for controller to be ready...");

    #1000;

    execute_i2c(CMD_READ_ID, 17'h00000, 8'h00, "READ ID", 1, 24'h00D0D0); 
    
    #5000;

    execute_i2c(CMD_READ_STATUS, 17'h00000, 8'h00, "READ STATUS", 1, 24'h0000FF);

    #5000;
    
    execute_i2c(CMD_WRITE_DATA, 17'h01234, 8'hA5, "WRITE DATA (0xA5 to 0x1234 addr)", 0, 24'h0);
    
    $display("Waiting 5ms for the data to be physically written", $time);
    #5500000; 

    execute_i2c(CMD_READ_DATA, 17'h01234, 8'h00, "READ DATA (0xA5 expected)", 1, 24'h0000A5);
    
    #5000;
    $display("All tests finished");
    $finish;
end

endmodule