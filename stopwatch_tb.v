`timescale 1ns / 1ps

module Stopwatch_tb;
    reg clk, start_stop, reset;
    wire [6:0] digit1, digit2;

    initial begin
    $dumpfile("stopwatch.vcd"); // Name of the VCD file
    $dumpvars(0, Stopwatch_tb); // Dump all signals in Stopwatch_tb
    end

    // Instantiate the Stopwatch module
    Stopwatch uut (
        .clk(clk),
        .start_stop(start_stop),
        .reset(reset),
        .digit1(digit1),
        .digit2(digit2)
    );

    initial begin
        clk = 0;
        forever #500 clk = ~clk;
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
        repeat(10) @(posedge clk); // Simulate running for some time

        // Pause the stopwatch
        start_stop = 0;
        repeat (5) @(posedge clk); // Wait 5 cycles

        // Resume the stopwatch
        start_stop = 1;
        repeat (10) @(posedge clk); // Wait 10 cycles


        // Reset stopwatch
        reset = 1;
        repeat (2) @(posedge clk);

        reset = 0;
        #1000;
        repeat (5) @(posedge clk);

        $finish;
    end

    // Monitor changes
    initial begin
        forever begin
            #2000
            $monitor("Time: %d", $time);
            $display("start/stop: %b \t reset: %b", start_stop, reset);
            print_seven_segment(digit2);
            print_seven_segment(digit1);
            $display("----------------------");
        end
    end

    

task print_seven_segment;
    input [6:0] sevseg;
    begin
        case (sevseg)
            7'b0111111: $display(" _ \n| |\n|_|"); // 0
            7'b0000110: $display("   \n  |\n  |"); // 1
            7'b1011011: $display(" _ \n _|\n|_ "); // 2
            7'b1001111: $display(" _ \n _|\n _|"); // 3
            7'b1100110: $display("   \n|_|\n  |"); // 4
            7'b1101101: $display(" _ \n|_ \n _|"); // 5
            7'b1111101: $display(" _ \n|_ \n|_|"); // 6
            7'b0000111: $display(" _ \n  |\n  |"); // 7
            7'b1111111: $display(" _ \n|_|\n|_|"); // 8
            7'b1101111: $display(" _ \n|_|\n _|"); // 9
            default:    $display("   \n   \n   "); // Blank
        endcase
    end
endtask

endmodule
