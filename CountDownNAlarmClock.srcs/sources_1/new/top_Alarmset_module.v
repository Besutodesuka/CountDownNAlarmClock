`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2023 09:32:17 PM
// Design Name: 
// Module Name: top_Alarmset_module
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


module top_Alarmset_module(
    input clk_100MHz,       // from Basys 3
    input reset_db,            // sw1 Basys 3
    input dec_db,         // btnD Basys 3
    input inc_db,          // btnU Basys 3
    input mode,
    input [11:0] sw,
    input timeSw,
    input [3:0] selectdigit,
    output [3:0] ah,bh,am,bm
//    output reg settted
    );
//    initial settted = 0;
//    if (selectdigit )
    wire w_1Hz;                                 // 1Hz signal
    wire w_inc_mins, w_inc_hrs,w_inc_mins_1HZ;                 // mod to mod
    wire inc_mins_or, inc_hrs_or, dec_hrs, dec_mins;               // from OR gates
    wire insig,desig;                                  // 0 = view, 1 = set
    wire [5:0] sec_ctr;
    wire [6:0] v_hours_tz, minutes_out, hours_out;
    
     minutes min(
    .clk(clk_100MHz),
     .inc_minutes(inc_mins_or),
     .dec_minutes(dec_mins), 
     .reset(reset_db),
     .inc_hours(w_inc_hrs),
    .min(minutes_out));

    hours hr(clk_100MHz,
     inc_hrs_or,
      dec_hrs,
       reset_db,
        hours_out);
    
    negedge_detect neg_U(clk_100MHz, inc_db, insig);
    negedge_detect neg_D(clk_100MHz, dec_db, desig);
    
    
    assign dec_hrs = (desig && mode) && (selectdigit == 4'b0011);  // decrease hour by button 
    assign dec_mins = (desig && mode) && (selectdigit == 4'b1100); // decrease minute by button
    // should be run all time
    assign inc_hrs_or = w_inc_hrs | ((insig && mode) && (selectdigit == 4'b0011));  // increase hour by button or carry from minute counter
    assign inc_mins_or = ((insig && mode) && (selectdigit == 4'b1100)); // increase minute by button or carry from seconds counter
    
    timezone_selector tz(hours_out, sw, timeSw, v_hours_tz);
    
    bin2bcd hrs(v_hours_tz, ah, bh);
    bin2bcd mins(minutes_out, am, bm);
endmodule
