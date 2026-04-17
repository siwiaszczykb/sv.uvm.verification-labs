module top_tb (
    output logic clk, 
    output logic rstn,
    // Sygnały wysyłane do DUT
    output logic valid,
    output logic [2:0] cmd,
    output logic [16:0] addr,
    output logic [7:0] w_data,
    // Sygnały odbierane z DUT
    input  logic ready,
    input  logic r_data_valid,
    input  logic [23:0] r_data
);

initial clk = 0;
always #5 clk = ~clk;

initial begin
    $display("SIM start");

    rstn = 0;
    valid = 0;
    cmd = 0;
    addr = 0;
    w_data = 0;

    $display("Reset asserted, waiting 20 units");
    #20;
    rstn = 1;
    $display("Reset deasserted, waiting for controller to be ready...");

    #100;

    $display("Rozpoczynam komendę READ_ID...");
    cmd = 3'd1; 
    valid = 1;

    @(posedge clk);
    while (ready == 1'b1) @(posedge clk);

    valid = 0; 
    
    $display("Transakcja I2C w toku. Czekam na odpowiedz...");

    while (r_data_valid == 1'b0) begin
        @(posedge clk);
    end

    $display("SUKCES! Odczytano ID: %h", r_data);

    #1000;
    $finish;
end

endmodule