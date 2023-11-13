`timescale 1ns / 1ps

module bcd7seg(
    input clk_100MHz,
    input reset,
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    output reg [0:6] seg,
    output reg [3:0] an
    );
    
    // Parameters for segment values
    parameter NULL  = 7'b1111111;  // Turn off all segments
    parameter ZERO  = 7'b0000001;  // 0
    parameter ONE   = 7'b1001111;  // 1
    parameter TWO   = 7'b0010010;  // 2 
    parameter THREE = 7'b0000110;  // 3
    parameter FOUR  = 7'b1001100;  // 4
    parameter FIVE  = 7'b0100100;  // 5
    parameter SIX   = 7'b0100000;  // 6
    parameter SEVEN = 7'b0001111;  // 7
    parameter EIGHT = 7'b0000000;  // 8
    parameter NINE  = 7'b0000100;  // 9
    
    
    // To select each anode in turn
        reg [1:0] anode_select;
        reg [3:0] show_number; 
        reg [16:0] anode_timer;
        // 100000Hz refresh rate
        always @(posedge clk_100MHz or posedge reset) begin
            if(reset) begin
                anode_select <= 0;
                anode_timer <= 0; 
            end
            else
                if(anode_timer == 100000) begin
                    anode_timer <= 0;
                    anode_select <=  anode_select + 1;
                end
                else
                    anode_timer <=  anode_timer + 1;
        end
        // speed mirage
        always @(anode_select) begin
            case(anode_select) 
                2'b00 : begin
                     an = 4'b0111;
                     show_number = a;
                 end
                2'b01 : begin
                     an = 4'b1011;
                     show_number = b;
                 end
                2'b10 : begin
                    an = 4'b1101;
                    show_number = c;
                end
                2'b11 : begin
                    an = 4'b1110;
                    show_number = d;
                end
            endcase
        end
    
    // To drive the segments
    always @*
        case(show_number)
            4'b0000 : seg = ZERO;
            4'b0001 : seg = ONE;
            4'b0010 : seg = TWO;
            4'b0011 : seg = THREE;
            4'b0100 : seg = FOUR;
            4'b0101 : seg = FIVE;
            4'b0110 : seg = SIX;
            4'b0111 : seg = SEVEN;
            4'b1000 : seg = EIGHT;
            4'b1001 : seg = NINE;
        endcase

endmodule