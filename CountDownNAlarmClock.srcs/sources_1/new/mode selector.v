`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2023 04:20:24 PM
// Design Name: 
// Module Name: mode_selector
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

// state
//  00 -> clock
//  01 -> Alarm set 
//  10 -> stopwatch
//  11 -> 
module mode_selector(
    input clk_main,
    input mode, // sw V16
    input bl, br,
    output reg [1:0] selected
    );
    
    parameter CLOCK  = 2'b00, ALARM = 2'b01, STOPWATCH = 2'b10, COUNTDOWN = 2'b11;
    reg [1:0] state ,next_state;
    initial state = CLOCK;
    initial next_state = CLOCK;
    
    always@(posedge clk_main) begin
//    if (reset) state <= CLOCK;
//    else 
    state <= next_state;
    end
    
    always@(state,mode,bl,br)begin
        // operate when mode is on
        case(state)
           CLOCK: begin
           if(mode && (~bl && br))next_state=ALARM;
           else if (mode && (bl && ~br))next_state=COUNTDOWN;
           else next_state=CLOCK;
           end
           ALARM: begin
           if(mode && (~bl && br))next_state=STOPWATCH;
           else if (mode && (bl && ~br))next_state=CLOCK;
           else next_state=ALARM;
           end
           STOPWATCH: begin
           if(mode && (~bl && br))next_state=COUNTDOWN;
           else if (mode && (bl && ~br))next_state=ALARM;
           else next_state=STOPWATCH;
           end
           COUNTDOWN: begin
           if(mode && (~bl && br))next_state=CLOCK;
           else if (mode && (bl && ~br))next_state=STOPWATCH;
           else next_state=COUNTDOWN;
           end
        endcase
     end
     
    always@(state) begin 
        selected = state;
    end
endmodule
// fix FSM state
