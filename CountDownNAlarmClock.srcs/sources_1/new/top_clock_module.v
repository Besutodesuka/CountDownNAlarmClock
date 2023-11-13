`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2023 04:07:10 PM
// Design Name: 
// Module Name: top_clock_module
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

module top_clock_module(
    input clk_100MHz,
    input reset, //reset
    input btnC,  //mode setter
    input btnU, //inc_hours
    input btnD, //inc_mins
    output led0,led1,
    output [0:6] seg,
    output [3:0] AN
    );
    
    wire [5:0] v_hours;
    wire [5:0] v_minutes;
    wire [3:0] hrs_tens, mins_tens;
    wire [3:0] hrs_ones, mins_ones;
    
    // Binary Clock
    top_bin_clock bin(clk_100MHz, reset, btnC, btnD, btnU,
                       v_hours, led0, v_minutes, led1);
    
//    assign hours_pad = {2'b00, v_hours};     // Pad hours vector with zeros to size for bin2bcd ('00'+'0100')
    // encode 10 base value from Binary clock
    bin2bcd hrs(v_hours, hrs_tens, hrs_ones);
    bin2bcd mins(v_minutes, mins_tens, mins_ones);
    
    // set 7 seg [hrs_tens, hrs_ones, mins_tens, mins_ones]
    bcd7seg seg7(clk_100MHz, reset, hrs_tens, hrs_ones, mins_tens, 
                      mins_ones, seg, AN);
//    assign test = blink;
endmodule
