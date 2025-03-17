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
        else if (q)
            count <= (count == 99) ? 0 : count + 1;
    end
endmodule

// Convert binary to two-digit BCD
module BinaryToBCD(counter, digit1, digit2);
    input wire [6:0] counter;
    output wire [3:0] digit1, digit2;

    wire [3:0] C1_out;
    BCDAdjust C1({2'b00, counter[6:5]}, C1_out);

    wire [3:0] C2_out;
    BCDAdjust C2({C1_out[2:0], counter[4]}, C2_out);

    wire [3:0] C3_out;
    BCDAdjust C3({C2_out[2:0], counter[3]}, C3_out);

    wire [3:0] C4_out;
    BCDAdjust C4({C3_out[2:0], counter[2]}, C4_out);

    wire [3:0] C5_out;
    BCDAdjust C5({C4_out[2:0], counter[1]}, C5_out);

    wire [3:0] C6_out;
    BCDAdjust C6({1'b0, C1_out[3], C2_out[3], C3_out[3]}, C6_out);

    wire [3:0] C7_out;
    BCDAdjust C7({C6_out[2:0], C4_out[3]}, C7_out);

    assign digit1 = {C5_out[2:0], counter[0]};
    assign digit2 = {C7_out[2:0], C5_out[3]};

endmodule

module BCDAdjust(in, out);
    input wire [3:0] in;
    output wire [3:0] out;

    assign out = (in > 4) ? (in + 3) : in; 

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

// JK Flipflop 
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