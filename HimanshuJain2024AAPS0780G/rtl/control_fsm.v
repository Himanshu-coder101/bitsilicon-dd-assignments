module control_fsm (
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    input  wire stop,
    input  wire reset,

    output reg  enable,
    output reg  [1:0] status
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RUNNING = 2'b01;
    localparam PAUSED  = 2'b10;

    reg [1:0] state, next_state;

    // ----------------------------
    // State Register
    // ----------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // ----------------------------
    // Next State Logic
    // ----------------------------

    always @(*) begin

        next_state = state;

        case (state)

            IDLE: begin
                if (start)
                    next_state = RUNNING;
            end

            RUNNING: begin
                if (stop)
                    next_state = PAUSED;
                else if (reset)
                    next_state = IDLE;
            end

            PAUSED: begin
                if (start)
                    next_state = RUNNING;
                else if (reset)
                    next_state = IDLE;
            end

            default: next_state = IDLE;

        endcase
    end

    // ----------------------------
    // Output Logic
    // ----------------------------

    always @(*) begin

        status = state;

        case (state)

            RUNNING: enable = 1'b1;
            default: enable = 1'b0;

        endcase
    end

endmodule