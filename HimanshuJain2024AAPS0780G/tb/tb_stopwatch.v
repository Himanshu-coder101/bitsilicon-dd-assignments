`timescale 1ns/1ps

module tb_stopwatch;

    // Inputs
    reg clk;
    reg rst_n;
    reg start;
    reg stop;
    reg reset;

    // Outputs
    wire [7:0] minutes;
    wire [5:0] seconds;
    wire [1:0] status;

    // Instantiate DUT (Device Under Test)
    stopwatch_top dut (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (start),
        .stop    (stop),
        .reset   (reset),
        .minutes (minutes),
        .seconds (seconds),
        .status  (status)
    );

    // ============================
    // Clock Generator (10ns period)
    // ============================

    always #5 clk = ~clk;

    // ============================
    // Test Sequence
    // ============================

    initial begin

        // Dump for GTKWave
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_stopwatch);

        // Initial values
        clk   = 0;
        rst_n = 0;
        start = 0;
        stop  = 0;
        reset = 0;

        // Hold reset
        #20;
        rst_n = 1;

        // ============================
        // Start Stopwatch
        // ============================

        #10;
        start = 1;
        #10;
        start = 0;

        // Let it run (10 seconds)
        #200;

        // ============================
        // Pause
        // ============================

        stop = 1;
        #10;
        stop = 0;

        // Stay paused
        #100;

        // ============================
        // Resume
        // ============================

        start = 1;
        #10;
        start = 0;

        // Run again
        #200;

        // ============================
        // Reset
        // ============================

        reset = 1;
        #10;
        reset = 0;
        // Start again after reset
        #20;
        start = 1;
        #10;
        start = 0;

        // Wait
        #500000;

        // Finish simulation
        $finish;

    end

    // ============================
    // Monitor Output (Console)
    // ============================

    always @(posedge clk) begin

        $display("Time = %0t | %02d:%02d | State = %b",
                 $time,
                 minutes,
                 seconds,
                 status);

    end

endmodule
