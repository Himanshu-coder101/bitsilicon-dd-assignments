module minutes_counter (
    input  wire clk,
    input  wire rst_n,
    input  wire enable,
    input  wire rollover,   // from seconds

    output reg [7:0] minutes
);

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            minutes <= 8'd0;
        end
        else begin

            if (enable && rollover) begin

                if (minutes == 8'd99)
                    minutes <= 8'd0;
                else
                    minutes <= minutes + 1'b1;

            end

        end

    end

endmodule
