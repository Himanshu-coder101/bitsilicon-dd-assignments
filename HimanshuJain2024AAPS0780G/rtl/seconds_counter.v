module seconds_counter (
    input  wire clk,
    input  wire rst_n,
    input  wire enable,

    output reg  [5:0] seconds,
    output reg  rollover
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            seconds  <= 6'd0;
            rollover <= 1'b0;
        end
        else begin
            rollover <= 1'b0;

            if (enable) begin

                if (seconds == 6'd59) begin
                    seconds  <= 6'd0;
                    rollover <= 1'b1;
                end
                else begin
                    seconds <= seconds + 1'b1;
                end

            end
        end
    end

endmodule
