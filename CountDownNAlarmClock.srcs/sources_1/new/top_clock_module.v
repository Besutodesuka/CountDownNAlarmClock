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
    input btnL, //inc_hours
    input btnR,
    input btnC,  //mode setter
    input btnU, //inc_hours
    input btnD, //inc_mins
    input [11:0] sw,
    input timeSw,
    input mode,
    input [3:0] selected,
    output led0,led1 // led0 => sig 1 hz
//    ,output [6:0] seg, output [3:0] AN
    ,output [3:0] hrs_tens, hrs_ones, mins_tens, mins_ones
    );
    wire [5:0] v_minutes, v_hours, v_hours_tz;
//    wire [3:0] selected;
    // Binary Clock
    top_bin_clock bin(clk_100MHz, btnC, btnD, btnU, btnL, btnR, mode,selected,
                       v_hours, led0, v_minutes, led1); // check v hour
    // add time zone selector here 
    // input :v_hours, sw list
    // output:v_hours
    timezone_selector tz(v_hours, sw, timeSw, v_hours_tz);
    // assign hours_pad = {2'b00, v_hours};     // Pad hours vector with zeros to size for bin2bcd ('00'+'0100')
    // encode 10 base value from Binary clock
    bin2bcd hrs(v_hours_tz, hrs_tens, hrs_ones);
    bin2bcd mins(v_minutes, mins_tens, mins_ones);
    
//    // set 7 seg [hrs_tens, hrs_ones, mins_tens, mins_ones]
//    bcd7seg seg7(clk_100MHz, reset, selected, hrs_tens, hrs_ones, mins_tens, 
//                      mins_ones, seg, AN);
endmodule
