`timescale 1ns/1ps

module Stopwatch(clk, start_stop, reset, digit1, digit2);
    input wire clk, start_stop, reset;
    output wire [6:0] digit1, digit2;
    
    // JK Flip-Flop logic for clock control
    wire j, k, q;
    assign j = start_stop & ~reset;
    assign k = start_stop | reset;
    JKFlipFlop JK(j, k, clk, q);

    // Counter logic
    wire [6:0] count;
    Counter c(q, reset, count);

    // Binary to BCD conversion
    wire [3:0] bcd1, bcd2;
    BinaryToBCD converter(count, bcd1, bcd2);

    // BCD to Seven Segment Display conversion
    SevenSegDisplay sg1(bcd1, digit1);
    SevenSegDisplay sg2(bcd2, digit2);
endmodule

// Counter Module
module Counter(q, reset, count);
    input wire q, reset;
    output reg [6:0] count;

    always @(posedge q or posedge reset) begin
        if (reset)
            count <= 7'b0000000;
        else 
            count <= count + 1;
    end
endmodule

// Convert binary to two-digit BCD
module BinaryToBCD(counter, digit1, digit2);
    input wire [6:0] counter;
    output reg [3:0] digit1, digit2;

    always @(*) begin
        digit1 = counter % 10; // Ones place
        digit2 = counter / 10; // Tens place
    end
endmodule

// Convert BCD to Seven Segment Display
module SevenSegDisplay(bcd, sevseg);
    input wire [3:0] bcd;
    output reg [6:0] sevseg;

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

// JK Flipflop with Reset
module JKFlipFlop(j, k, clk, q);
    input wire j, k, clk;
    output reg q;

    always @(posedge clk) begin
        if(j & ~k)
            q <= 1;
        else if (k & ~j)
            q <= 0;
        else if (j & k)
            q <= ~q;
    end
endmodule