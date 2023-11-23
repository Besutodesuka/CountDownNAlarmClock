`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2023 08:55:06 PM
// Design Name: 
// Module Name: top_stopwatch_module
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


module top_stopwatch_module(
    input clk_100MHz,
    input w_1Hz,
    input modeT_sig, // for pause and start
    input reset_db, // for reset time
    input btnU_db, // change  mode MM:SS : 0 -> HH:MM : 1
    output reg [3:0] a,b,c,d,
    output led1,
    output led_hhmmss
    );
//    wire pause_sig, change_digit_sig;
    wire [3:0] ah,bh,am,bm,as,bs;
    wire [5:0] v_minutes, v_hours, v_seconds;
//    wire w_1Hz;                                // 1Hz signal
    wire w_inc_mins, w_inc_hrs,w_inc_mins_1HZ;                 // mod to mod
    wire inc_mins_or, inc_hrs_or, dec_hrs, dec_mins;               // from OR gates
    wire insig,desig;                                  // 0 = view, 1 = set

//    negedge_detect neg_pause_stop(clk_100MHz, btnD_db, pause_sig);
//    negedge_detect neg_change_digit(clk_100MHz, btnU_db, change_digit_sig);
    
//    Digit_Selector editdigit_stop(clk_100MHz,modeT_sig,
//    change_digit_sig,change_digit_sig,
//    selectdigit);
//    wire stop_mode_pause;
//    tff modetog_sto(clk_100MHz, modeT_sig, reset_dp, stop_mode_pause);
    
    seconds sec(
    .clk_1Hz(w_1Hz),
     .reset(reset_db),
      .increase({~modeT_sig,1'b1}) ,
       .inc_minutes(w_inc_mins),
       .sec_ctr(v_seconds)
    );
    minutes min(clk_100MHz, inc_mins_or, 0 , reset_db, w_inc_hrs, v_minutes);
    hours hr(clk_100MHz, inc_hrs_or, 0 , reset_db, v_hours);
    
    posedge_detect pos_sec_count(clk_100MHz, w_inc_mins, w_inc_mins_1HZ);
    assign inc_hrs_or = w_inc_hrs | (insig && modeT_sig);  // increase hour by button or carry from minute counter
    assign inc_mins_or = w_inc_mins_1HZ | (insig && modeT_sig); // increase minute by button or carry from seconds counter
    
    bin2bcd HourStop(v_hours, ah, bh);
    bin2bcd MinuteStop(v_minutes, am, bm);
    bin2bcd SecondStop(v_seconds, as, bs);
    
    always@(posedge clk_100MHz)begin
        case(btnU_db)
        1'b0: begin
            a = am;
            b = bm;
            c = as;
            d = bs;
        end
        1'b1: begin
            a = ah;
            b = bh;
            c = am;
            d = bm;
        end
        endcase
    end
    assign led1 = modeT_sig;
    assign led_hhmmss = btnU_db;

endmodule
