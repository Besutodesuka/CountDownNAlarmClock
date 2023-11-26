`timescale 1ns / 1ps

module bcd7seg(
    input clk_100MHz,
    input reset,
    input [3:0] DigitSelected,
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
        reg [25:0] timer;
        reg elapsed_half, blink;
        // 100000Hz refresh rate
        reg [3:0] mirage_vis;
        initial elapsed_half = 0;
        initial blink = 0;
        always @(posedge clk_100MHz or posedge reset) begin
            if(reset) begin
                anode_select <= 0;
                anode_timer <= 0; 
            end
            else begin
                if(anode_timer == 100000) begin
                    anode_timer <= 0;
                    anode_select <=  anode_select + 1;
                end
                else
                    anode_timer <=  anode_timer + 1;
                if(timer == 49_999_999) begin
                    timer <= 0;
                    elapsed_half = ~elapsed_half;
                    end
                else timer <=  timer + 1;
            end
        end
        // speed mirage

        
        always @(anode_select) begin
            case(anode_select) 
                2'b00 : begin
                     mirage_vis <= 4'b0111;
                     show_number = a;
                 end
                2'b01 : begin
                     mirage_vis = 4'b1011;
                     show_number = b;
                 end
                2'b10 : begin
                    mirage_vis = 4'b1101;
                    show_number = c;
                end
                2'b11 : begin
                    mirage_vis = 4'b1110;
                    show_number = d;
                end
            endcase
//             1110 + 1100 = 1010, 1101 + 1100 = 1001, 1011+1100 == 0111 1111+1100 == 1000
//             check last 2 blink 1110 and 1100, 1101 and 1100
            if (((DigitSelected[0] == mirage_vis[0]) && (~mirage_vis[0])) || 
            ((DigitSelected[1] == mirage_vis[1]) && ~mirage_vis[1])
            ) blink = 1;
            // check first two digit 0011
            else if (((DigitSelected[2] == mirage_vis[2]) && ~mirage_vis[2]) || 
            ((DigitSelected[3] == mirage_vis[3]) && ~mirage_vis[3])
            ) blink = 1;
            else if (((DigitSelected[2] == mirage_vis[2]) && ~mirage_vis[2]) || 
            ((DigitSelected[3] == mirage_vis[3]) && ~mirage_vis[3]) || 
            ((DigitSelected[0] == mirage_vis[0]) && (~mirage_vis[0])) || 
            ((DigitSelected[1] == mirage_vis[1]) && ~mirage_vis[1])
            ) blink = 1;
            else blink = 0;
            if (elapsed_half && blink) an <= 4'b1111;
            else an<=mirage_vis;
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