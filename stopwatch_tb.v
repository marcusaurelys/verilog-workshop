`timescale 1ns / 1ps

module Stopwatch_tb;
    reg clk, start_stop, reset;
    wire [6:0] digit1, digit2;

    // Instantiate the Stopwatch module
    Stopwatch uut (
        .clk(clk),
        .start_stop(start_stop),
        .reset(reset),
        .digit1(digit1),
        .digit2(digit2)
    );

    always begin
        clk = 0;
        forever #1000 clk = ~clk;
    end

    initial begin
        // Initialize signals
        clk = 0;
        start_stop = 1;
        reset = 1;
        #1000;

        // Release reset and start counting
        reset = 0;
        start_stop = 1;
        #5000; // Simulate running for some time

        // Pause the stopwatch
        start_stop = 0;
        #1000;

        // Resume the stopwatch
        start_stop = 1;
        #1000;

        // Reset stopwatch
        reset = 1;
        #1000;
        reset = 0;

        // Stop simulation
        #1000;
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time: %d | start_stop: %b | reset: %b | Count: %b %b",
                 $time, start_stop, reset, digit2, digit1);
    end
endmodule