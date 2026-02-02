module stopwatch_top (
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    input  wire stop,
    input  wire reset,

    output wire [7:0] minutes,
    output wire [5:0] seconds,
    output wire [1:0] status
);

    // Internal wires
    wire enable;
    wire sec_rollover;

    // Control FSM
    control_fsm fsm (
        .clk    (clk),
        .rst_n  (rst_n),
        .start  (start),
        .stop   (stop),
        .reset  (reset),
        .enable (enable),
        .status (status)
    );

    // Seconds Counter
    seconds_counter sec (
        .clk      (clk),
        .rst_n    (rst_n),
        .enable   (enable),
        .seconds  (seconds),
        .rollover (sec_rollover)   // <<< IMPORTANT
    );

    // Minutes Counter
    minutes_counter min (
        .clk      (clk),
        .rst_n    (rst_n),
        .enable   (enable),
        .rollover (sec_rollover),  // <<< IMPORTANT
        .minutes  (minutes)
    );

endmodule