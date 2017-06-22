module cpu_if_control_fsm (
    input  logic clk, 
    input  logic reset, 
    input  logic read, 
    input  logic write, 
    input  logic access_complete,
    output logic ready,
    output logic read_busy,
    output logic write_busy
);

enum int unsigned { IDLE=0, RD_ACTIVE=1, WR_ACTIVE=2 } state = IDLE;

// ready logic
always_ff @(posedge clk) begin
    if (reset) begin
        ready <= 1'b1;
    end else if (state == IDLE) begin
        ready <= 1'b1;
    end else begin
        ready <= 1'b0;
    end
end

// busy when read logic
always_ff @(posedge clk) begin
    if (reset) begin
        read_busy <= 1'b0;
    end else if (state == RD_ACTIVE) begin
        read_busy <= 1'b1;
    end else begin
        read_busy <= 1'b0;
    end
end

// busy when write logic
always_ff @(posedge clk) begin
    if (reset) begin
        write_busy <= 1'b0;
    end else if (state == WR_ACTIVE) begin
        write_busy <= 1'b1;
    end else begin
        write_busy <= 1'b0;
    end
end

// state-machine defenition
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (write) begin
                    state <= WR_ACTIVE;
                end else if (read) begin
                    state <= RD_ACTIVE;
                end else begin
                    state <= IDLE;
                end
            end
            WR_ACTIVE: begin
                if (access_complete) begin
                    state <= IDLE;
                end else begin
                    state <= WR_ACTIVE;
                end
            end
            RD_ACTIVE: begin
                if (access_complete) begin
                    state <= IDLE;
                end else begin
                    state <= RD_ACTIVE;
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
