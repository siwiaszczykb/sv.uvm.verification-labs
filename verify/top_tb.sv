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
        `uvm_info("I2C_TASK", $sformatf("Now doing: %s", op_name), UVM_LOW);

        cmd = t_cmd;
        addr = t_addr;
        w_data = t_wdata;
        valid = 1;

        @(posedge clk);
        while (ready == 1'b1) @(posedge clk);
        valid = 0;
        
        while (ready == 1'b0) @(posedge clk);

        `uvm_info("I2C_TASK", $sformatf("End of %s. Data received: %h", op_name, r_data), UVM_LOW);
        
        if (check_enable) begin
            if (r_data !== expected_data) begin
                `uvm_error("I2C_TASK", $sformatf("End of %s. Data received: %h", op_name, expected_data, r_data));
            end else begin
                `uvm_info("I2C_TASK", $sformatf("%s successfully. Received valid data: %h", op_name, r_data), UVM_LOW);
            end
        end
    end
endtask


initial begin
    `uvm_info("TB_TOP", "Hello, world! SIM start.", UVM_MEDIUM);
    
    rstn = 0;
    valid = 0;
    cmd = CMD_IDLE;
    addr = 0;
    w_data = 0;

    `uvm_info("TB_TOP", "Reset asserted, waiting 200 ns", UVM_LOW);
    #200;
    rstn = 1;
    `uvm_info("TB_TOP", "Reset deasserted, waiting for controller to be ready", UVM_LOW);

    #1000;

    execute_i2c(CMD_READ_ID, 17'h00000, 8'h00, "READ ID", 1, 24'h00D0D0); 
    
    #5000;

    execute_i2c(CMD_READ_STATUS, 17'h00400, 8'h00, "READ STATUS", 1, 24'h0000FF);

    #5000;
    
    execute_i2c(CMD_WRITE_DATA, 17'h01234, 8'hA5, "WRITE DATA (0xA5 to 0x1234 addr)", 0, 24'h0);
    
    `uvm_info("TB_TOP", "Waiting 5ms for the data to be physically written", UVM_LOW);
    #5500000; 

    execute_i2c(CMD_READ_DATA, 17'h01234, 8'h00, "READ DATA (0xA5 expected)", 1, 24'h0000A5);
    
    #5000;
    begin
        logic [16:0] rand_addr;
        logic [7:0]  rand_data;

        for (int i = 0; i < 10; i++) begin
            rand_addr = $urandom_range(0, 17'h1FFFF);
            rand_data = $urandom_range(0, 8'hFF);

            `uvm_info("TB_TOP", $sformatf("Randomized test %0d (addr: %h, data: %h)", i+1, rand_addr, rand_data), UVM_LOW);

            execute_i2c(CMD_WRITE_DATA, rand_addr, rand_data, "WRITE RANDOM", 0, 24'h0);
            
            #5500000; //hardcoded 5ms magic wait time

            execute_i2c(CMD_READ_DATA, rand_addr, 8'h00, "READ RANDOM", 1, {16'h0000, rand_data});
            
            #5000;
        end
    end

    `uvm_info("TB_TOP", "All tests finished", UVM_MEDIUM);
    $finish;
end

endmodule