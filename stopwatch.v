module Stopwatch(clk, start_stop, reset, digit1, digit2);
    input wire clk, start_stop, reset;
    output wire [6:0] digit1, digit2;
    
    //TODO: Using Structural Level Modeling, connect all the modules to create the stopwatch.
endmodule

// Counter Module
module Counter(q, reset, count);
    input wire q, reset;
    output reg [6:0] count;

    //TODO: Using any type of modeling, define the logic for a counter that can count up to 99.

endmodule

// Convert binary to two-digit BCD
module BinaryToBCD(counter, digit1, digit2);
    input wire [6:0] counter;
    output reg [3:0] digit1, digit2;

    //TODO: Using Structural Level Modeling, model the logic for this module. Feel free to define submodules as needed

endmodule


// Convert BCD to Seven Segment Display
module SevenSegDisplay(bcd, sevseg);
    input wire [3:0] bcd;
    output reg [6:0] sevseg;

    //QUESTION: What kind of modelling is this?

    always @(*) begin
        case (bcd)
            4'b0000: sevseg = 7'b0111111; // 0
            4'b0001: sevseg = 7'b0000110; // 1
            4'b0010: sevseg = 7'b1011011; // 2
            4'b0011: sevseg = 7'b1001111; // 3
            4'b0100: sevseg = 7'b1100110; // 4
            4'b0101: sevseg = 7'b1101101; // 5
            4'b0110: sevseg = 7'b1111101; // 6
            4'b0111: sevseg = 7'b0000111; // 7
            4'b1000: sevseg = 7'b1111111; // 8
            4'b1001: sevseg = 7'b1101111; // 9
            default: sevseg = 7'b0000000; // Off
        endcase
    end
endmodule

// JK Flipflop 
module JKFlipFlop(j, k, clk, q);
    input wire j, k, clk;
    output reg q;

    //TODO: Using Behavioral Modelling, Model the behavior of a JK Flipflop
endmodule