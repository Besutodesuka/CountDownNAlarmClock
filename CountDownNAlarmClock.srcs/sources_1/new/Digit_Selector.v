`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2023 11:11:37 PM
// Design Name: 
// Module Name: Digit_Selector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// state  lr   state_next
//  0     10    1
//  0     01    1
//  1     10    0
//  1     01    0
// exclusive or to t = (bl^br)
// 00 -> 1100
// 01 -> 0011
// 10 -> 1111 normal blink
module Digit_Selector(
        input clk,
        input mode, // 0 is not operate
        input bl,
        input br,
        output reg [3:0] Selected
    );
    parameter IDLE  = 2'b10, GL = 2'b01, GR = 2'b00 ;
    reg [1:0] state ,next_state;
    initial state = IDLE;
    initial next_state = IDLE;
    
    wire open_sig, close_sig;
    posedge_detect open(clk, mode, open_sig);
//    negedge_detect close(clk, mode, close_sig);
    
    always@(posedge clk) begin
    if (open_sig) state <= IDLE;
//    else if (open_sig) state <= GR;
    else state <= next_state;
    end
    
    always@(state,mode,bl,br)begin
        // operate when mode is on
        case(state)
           IDLE: begin
               next_state= (mode) ? GR : IDLE;
//               else next_state=IDLE;
           end
           GR: begin
               if(~mode) next_state=IDLE;
               else if (mode && (bl && ~br)) next_state=GL;
               else next_state=GR;
           end
           GL: begin
               if(~mode) next_state=IDLE;
               else if(mode && (~bl && br)) next_state=GR;
               else next_state = GL;
           end
        endcase
        end
    
    always@(state) begin
    case(state)
           IDLE: Selected<=4'b1111;
           GL: Selected<=4'b0011;
           GR: Selected<=4'b1100;
        endcase
    end
endmodule
