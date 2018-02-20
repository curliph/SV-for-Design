// minimum logic state machine 
module cpu_if_control_fsm (
    input  logic clk, 
    input  logic reset, 
    input  logic read, 
    input  logic write, 
    input  logic access_complete,
    output logic access_ready
);

enum int unsigned { IDLE=0, ACTIVE=1 } state = IDLE;

// state-machine defenition
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        access_ready <= 1'b1;
    end else begin
        case (state)
            IDLE: begin
                if (write|read) begin
                    state <= ACTIVE;
                    access_ready <= 1'b0;
                end else begin
                    state <= IDLE;
                    access_ready <= 1'b1;
                end
            end
            ACTIVE: begin
                if (access_complete) begin
                    state <= IDLE;
                    access_ready <= 1'b1;
                end else begin
                    state <= ACTIVE;
                    access_ready <= 1'b0;
                end
            end
            default: begin
                state <= IDLE;
                $display ("Reach undefined state");
            end
        endcase
    end
end

endmodule
