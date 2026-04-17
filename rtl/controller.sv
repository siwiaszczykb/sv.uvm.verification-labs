module controller (
    input               clk,
    input               rst,
    input               valid,
    input logic [2:0]   cmd,
    input logic [16:0]  addr,
    input logic [7:0]   w_data,
    output              a1, a2,
    output              wp,
    output              scl,
    inout               sda,
    output              ready,
    output              r_data_valid,
    output logic [23:0]  r_data
);

typedef enum logic [4:0] {
    IDLE,
    START,
    CTRL_BYTE,
    ACK_WAIT,
    ADDR_HI,
    ADDR_LO,
    DATA,
    STOP
} state_t;

state_t state_reg;

logic [7:0]  clk_counter;   
logic [7:0]  shift_reg; 
logic        sda_out;   
logic        sda_en;    
logic        scl_reg;   

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
            state_reg <= IDLE;
    end else begin
        case(state_reg)
            IDLE: begin
                if(!valid) begin
                    state_reg <= IDLE;
                end
                else begin
                    if(cmd == READ_ID) begin
                        shift_reg <= 7'b1111100;
                        state_reg <= START;
                    end
                end
            end
            START: begin
                sda_out <= 1;
                scl_reg <= 1;
                sda_out <= 0;
                scl_reg <= 0;
                state_reg <= CTRL_BYTE;
            end
            CTRL_BYTE: begin
                if(bit_cnt != 8) begin
                    bit_cnt <= bit_cnt + 1;
                    sda_out <= shift_reg;
                    scl_reg <= 0;
                    scl_reg <= 1;
                    scl_reg <= 0;
                end
                else begin
                    bit_cnt <= 0;
                    state_reg <= ACK_WAIT;
                end
            end
            ACK_WAIT: begin
                sda_en <= 0;
                scl_reg <= 1;
            end
            DATA: begin

            end
            STOP: begin

            end
        endcase
    end
end

assign sda = (sda_en && !sda_out) ? 1'b0 : 1'bz;
assign scl = scl_reg;

endmodule