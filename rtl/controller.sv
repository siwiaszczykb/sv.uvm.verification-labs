`timescale 1ns/10ps
import tb_pkg::*;

module controller (
    input               clk,
    input               rst,
    input               valid,
    input cmd_t   cmd,
    input logic [16:0]  addr,
    input logic [7:0]   w_data,
    output logic        a1, a2,
    output logic        wp,
    output logic        scl,
    inout               sda,
    output logic        ready,
    output logic        r_data_valid,
    output logic [23:0] r_data
);

localparam CTRL_DUMMY_EEPROM = 8'b1010000_0; // Dummy write for readid

typedef enum logic [3:0] {
    IDLE,
    GEN_START,
    TX_BYTE,
    WAIT_ACK,
    REP_START_PREP, 
    RX_BYTE,
    SEND_ACK,
    GEN_STOP,
    DONE
} state_t;

state_t state_reg;

logic [2:0]  cmd_reg;
logic [16:0] addr_reg;
logic [7:0]  w_data_reg;

logic [3:0] sequence_step;
logic [2:0] bit_cnt;
logic [7:0] shift_reg;
logic [23:0] rx_buffer;

logic sda_out;
logic sda_en;
logic scl_reg;
logic sda_in;

assign sda_in = sda;
assign sda = (sda_en && !sda_out) ? 1'b0 : 1'bz; 
assign scl = scl_reg;

assign a1 = 1'b0;
assign a2 = 1'b0;
assign wp = 1'b0;

logic [7:0] clk_div;
logic i2c_tick;

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        clk_div <= 0;
        i2c_tick <= 0;
    end else begin
        if (clk_div == 8'd99) begin 
            clk_div <= 0;
            i2c_tick <= 1'b1;
        end else begin
            clk_div <= clk_div + 1;
            i2c_tick <= 1'b0;
        end
    end
end

logic [1:0] scl_phase; 

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        state_reg <= IDLE;
        scl_reg <= 1'b1;
        sda_out <= 1'b1;
        sda_en  <= 1'b1;
        ready   <= 1'b1;
        r_data_valid <= 1'b0;
        r_data <= '0;
        sequence_step <= '0;
        scl_phase <= '0;
        cmd_reg <= '0;
        addr_reg <= '0;
        w_data_reg <= '0;
    end 
    else if (i2c_tick) begin
        case (state_reg)
            IDLE: begin
                scl_reg <= 1'b1;
                sda_out <= 1'b1;
                sda_en  <= 1'b1;
                r_data_valid <= 1'b0;
                scl_phase <= '0;
                
                if (valid) begin
                    ready <= 1'b0;
                    cmd_reg <= cmd;
                    addr_reg <= addr;
                    w_data_reg <= w_data;
                    sequence_step <= 0;
                    rx_buffer <= 24'h0;
                    state_reg <= GEN_START;
                end else begin
                    ready <= 1'b1;
                end
            end

            GEN_START: begin
                if (scl_phase == 0) begin
                    sda_en <= 1'b1; 
                    sda_out <= 1'b0;
                    scl_phase <= 1;
                end else if (scl_phase == 1) begin
                    scl_reg <= 1'b0; 
                    scl_phase <= 0;
                    state_reg <= TX_BYTE;
                    bit_cnt <= 0;
                    
                    if (sequence_step == 0) begin
                        if (cmd_reg == CMD_READ_ID)
                            shift_reg <= 8'b1111100_0;
                        else if (cmd_reg == CMD_READ_STATUS)
                            shift_reg <= {4'b1011, 2'b00, addr_reg[16], 1'b0}; 
                        else 
                            shift_reg <= {4'b1010, 2'b00, addr_reg[16], 1'b0}; 
                    end 
                    else if (sequence_step == 3) begin
                        if (cmd_reg == CMD_READ_ID)
                            shift_reg <= 8'b1111100_1;
                        else if (cmd_reg == CMD_READ_STATUS)
                            shift_reg <= {4'b1011, 2'b00, addr_reg[16], 1'b1}; 
                        else 
                            shift_reg <= {4'b1010, 2'b00, addr_reg[16], 1'b1}; 
                    end
                end
            end

            TX_BYTE: begin
                if (scl_phase == 0) begin
                    sda_en <= 1'b1;
                    sda_out <= shift_reg[7]; 
                    scl_phase <= 1;
                end else if (scl_phase == 1) begin
                    scl_reg <= 1'b1;
                    scl_phase <= 2;
                end else if (scl_phase == 2) begin
                    scl_phase <= 3;  
                end else if (scl_phase == 3) begin
                    scl_reg <= 1'b0;
                    scl_phase <= 0;
                    shift_reg <= {shift_reg[6:0], 1'b0};
                    
                    if (bit_cnt == 7) begin
                        state_reg <= WAIT_ACK;
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                    end
                end
            end

            WAIT_ACK: begin
                if (scl_phase == 0) begin
                    sda_en <= 1'b0; 
                    scl_phase <= 1;
                end else if (scl_phase == 1) begin
                    scl_reg <= 1'b1;
                    scl_phase <= 2;
                end else if (scl_phase == 2) begin
                    scl_phase <= 3;
                end else if (scl_phase == 3) begin
                    scl_reg <= 1'b0;
                    scl_phase <= 0;

                    if (cmd_reg == CMD_READ_ID) begin
                        if (sequence_step == 0) begin
                            sequence_step <= 1;
                            state_reg <= TX_BYTE; 
                            bit_cnt <= 0;
                            shift_reg <= CTRL_DUMMY_EEPROM; 
                        end else if (sequence_step == 1) begin
                            sequence_step <= 3; 
                            state_reg <= REP_START_PREP; 
                        end else if (sequence_step == 3) begin
                            sequence_step <= 4;
                            state_reg <= RX_BYTE; 
                            bit_cnt <= 0;
                        end
                    end 
                    else if (cmd_reg == CMD_WRITE_DATA) begin
                        if (sequence_step == 0) begin
                            shift_reg <= addr_reg[15:8];
                            sequence_step <= 1;
                            state_reg <= TX_BYTE; bit_cnt <= 0;
                        end else if (sequence_step == 1) begin
                            shift_reg <= addr_reg[7:0];
                            sequence_step <= 2;
                            state_reg <= TX_BYTE; bit_cnt <= 0;
                        end else if (sequence_step == 2) begin
                            shift_reg <= w_data_reg;
                            sequence_step <= 3;
                            state_reg <= TX_BYTE; bit_cnt <= 0;
                        end else if (sequence_step == 3) begin
                            state_reg <= GEN_STOP;
                        end
                    end 
                    else if (cmd_reg == CMD_READ_DATA || cmd_reg == CMD_READ_STATUS) begin
                        if (sequence_step == 0) begin
                            shift_reg <= addr_reg[15:8];
                            sequence_step <= 1;
                            state_reg <= TX_BYTE; bit_cnt <= 0;
                        end else if (sequence_step == 1) begin
                            shift_reg <= addr_reg[7:0];
                            sequence_step <= 2;
                            state_reg <= TX_BYTE; bit_cnt <= 0;
                        end else if (sequence_step == 2) begin
                            sequence_step <= 3;
                            state_reg <= REP_START_PREP;
                        end else if (sequence_step == 3) begin
                            sequence_step <= 4;
                            state_reg <= RX_BYTE; bit_cnt <= 0;
                        end
                    end
                end
            end

            REP_START_PREP: begin
                if (scl_phase == 0) begin
                    sda_en <= 1'b1;
                    sda_out <= 1'b1; 
                    scl_phase <= 1;
                end else if (scl_phase == 1) begin
                    scl_reg <= 1'b1; 
                    scl_phase <= 2;
                end else if (scl_phase == 2) begin
                    scl_phase <= 3;  
                end else if (scl_phase == 3) begin
                    state_reg <= GEN_START; 
                    scl_phase <= 0;
                end
            end

            RX_BYTE: begin
                if (scl_phase == 0) begin
                    sda_en <= 1'b0; 
                    scl_phase <= 1;
                end else if (scl_phase == 1) begin
                    scl_reg <= 1'b1;
                    scl_phase <= 2;
                end else if (scl_phase == 2) begin
                    shift_reg <= {shift_reg[6:0], sda_in};
                    scl_phase <= 3;
                end else if (scl_phase == 3) begin
                    scl_reg <= 1'b0;
                    scl_phase <= 0;
                    
                    if (bit_cnt == 7) begin
                        state_reg <= SEND_ACK;
                        rx_buffer <= {rx_buffer[15:0], shift_reg}; 
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                    end
                end
            end

            SEND_ACK: begin
                if (scl_phase == 0) begin
                    sda_en <= 1'b1;
                    
                    if (cmd_reg == CMD_READ_ID && sequence_step < 6) 
                        sda_out <= 1'b0; 
                    else 
                        sda_out <= 1'b1; 
                        
                    scl_phase <= 1;
                end else if (scl_phase == 1) begin
                    scl_reg <= 1'b1;
                    scl_phase <= 2;
                end else if (scl_phase == 2) begin
                    scl_phase <= 3;
                end else if (scl_phase == 3) begin
                    scl_reg <= 1'b0;
                    scl_phase <= 0;
                    
                    if (cmd_reg == CMD_READ_ID && sequence_step < 6) begin
                        sequence_step <= sequence_step + 1;
                        state_reg <= RX_BYTE; bit_cnt <= 0; 
                    end else begin
                        state_reg <= GEN_STOP; 
                    end
                end
            end

            GEN_STOP: begin
                if (scl_phase == 0) begin
                    sda_en <= 1'b1; 
                    sda_out <= 1'b0;
                    scl_phase <= 1;
                end else if (scl_phase == 1) begin
                    scl_reg <= 1'b1;
                    scl_phase <= 2;
                end else if (scl_phase == 2) begin
                    sda_out <= 1'b1; // Fizyczne przejście 0 -> 1 = STOP
                    scl_phase <= 3;
                end else if (scl_phase == 3) begin
                    state_reg <= DONE;
                end
            end

            DONE: begin
                r_data <= rx_buffer;
                r_data_valid <= 1'b1;
                state_reg <= IDLE;
            end
        endcase
    end
end

endmodule