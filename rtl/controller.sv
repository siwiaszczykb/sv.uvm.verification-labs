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
    output logic [7:0]  r_data
);

typedef enum logic [3:0] {
    IDLE,
    START,
    CTRL_BYTE,
    ADDR_HI,
    ADDR_LO,
    DATA,
    STOP
} state_t;

state_t state_reg;

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
            state_reg <= IDLE;
    end else begin
        case(state_reg)
            IDLE: begin

            end
            START: begin

            end
            CTRL_BYTE: begin

            end
            ADDR_HI: begin

            end
            ADDR_LO: begin

            end
            DATA: begin

            end
            STOP: begin

            end
        endcase
    end
end

endmodule