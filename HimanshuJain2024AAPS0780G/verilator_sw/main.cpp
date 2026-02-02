#include "Vstopwatch_top.h"
#include "verilated.h"

#include <iostream>
#include <iomanip>

// Global time for Verilator
vluint64_t main_time = 0;

// Required by Verilator
double sc_time_stamp() {
    return main_time;
}

int main(int argc, char** argv) {

    Verilated::commandArgs(argc, argv);

    // Create DUT
    Vstopwatch_top* dut = new Vstopwatch_top;

    // ----------------------------
    // Initialize signals
    // ----------------------------

    dut->clk   = 0;
    dut->rst_n = 0;
    dut->start = 0;
    dut->stop  = 0;
    dut->reset = 0;

    // ----------------------------
    // Reset sequence
    // ----------------------------

    for (int i = 0; i < 5; i++) {
        dut->clk = !dut->clk;
        dut->eval();
        main_time++;
    }

    dut->rst_n = 1;

    std::cout << "Reset done\n";

    // ----------------------------
    // Start stopwatch
    // ----------------------------

    dut->start = 1;

    dut->clk = 0; dut->eval(); main_time++;
    dut->clk = 1; dut->eval(); main_time++;

    dut->start = 0;

    std::cout << "Started\n";

    // ----------------------------
    // Run for some time
    // ----------------------------

    for (int i = 0; i < 20; i++) {

        // One clock cycle
        dut->clk = 0; dut->eval(); main_time++;
        dut->clk = 1; dut->eval(); main_time++;

        // Read outputs
        int min = dut->minutes;
        int sec = dut->seconds;

        std::cout
            << "Time = "
            << std::setw(2) << std::setfill('0') << min
            << ":"
            << std::setw(2) << std::setfill('0') << sec
            << std::endl;
    }

    // ----------------------------
    // Pause
    // ----------------------------

    dut->stop = 1;

    dut->clk = 0; dut->eval(); main_time++;
    dut->clk = 1; dut->eval(); main_time++;

    dut->stop = 0;

    std::cout << "Paused\n";

    // Wait while paused
    for (int i = 0; i < 10; i++) {
        dut->clk = 0; dut->eval(); main_time++;
        dut->clk = 1; dut->eval(); main_time++;
    }

    // ----------------------------
    // Resume
    // ----------------------------

    dut->start = 1;

    dut->clk = 0; dut->eval(); main_time++;
    dut->clk = 1; dut->eval(); main_time++;

    dut->start = 0;

    std::cout << "Resumed\n";

    // Run again
    for (int i = 0; i < 20; i++) {

        dut->clk = 0; dut->eval(); main_time++;
        dut->clk = 1; dut->eval(); main_time++;

        int min = dut->minutes;
        int sec = dut->seconds;

        std::cout
            << "Time = "
            << std::setw(2) << std::setfill('0') << min
            << ":"
            << std::setw(2) << std::setfill('0') << sec
            << std::endl;
    }

    // ----------------------------
    // Reset again
    // ----------------------------

    dut->reset = 1;

    dut->clk = 0; dut->eval(); main_time++;
    dut->clk = 1; dut->eval(); main_time++;

    dut->reset = 0;

    std::cout << "Reset again\n";

    // Check cleared
    dut->clk = 0; dut->eval(); main_time++;
    dut->clk = 1; dut->eval(); main_time++;

    std::cout
        << "Final Time = "
        << std::setw(2) << std::setfill('0') << (int)dut->minutes
        << ":"
        << std::setw(2) << std::setfill('0') << (int)dut->seconds
        << std::endl;

    // ----------------------------
    // Cleanup
    // ----------------------------

    delete dut;

    std::cout << "Simulation finished\n";

    return 0;
}
