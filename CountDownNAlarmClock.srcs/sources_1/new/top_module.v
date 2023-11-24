`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 11/12/2023 03:08:55 PM
//// Design Name: 
//// Module Name: top_module
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


module top_module(
    input clk_100MHz,
    input swV16, //sys mode
    input reset, //reset
    input btnL, //inc_hours
    input btnR,
    input btnC,  //mode setter
    input btnU, //inc_hours
    input btnD, //inc_mins
    input [11:0] sw,
    input timeSw,
    output led0,led1, // led0 => 1 Hz sig, led1 -> mode
    output led_hhmmss,led_pause,// hhmm:1,mmss:0
    output [1:0] sysmode,
    output [0:6] seg,
    output [3:0] AN
    );
    parameter CLOCK  = 2'b00, ALARM = 2'b01, STOPWATCH = 2'b10, COUNTDOWN = 2'b11;
    reg [3:0] hrs_tens, hrs_ones, mins_tens, mins_ones;
    
    wire [3:0] a_clock,b_clock,c_clock,d_clock,selected_clock;
    wire [3:0] a_alarm,b_alarm,c_alarm,d_alarm,selected_alarm;
    wire [3:0] a_stop,b_stop,c_stop,d_stop,selected_stop;
    wire [3:0] a_count,b_count,c_count,d_count,selected_count;
    
    reg [3:0] vis_selected;
    wire [3:0] selectdigit;
     
    wire dcl_db,dcr_db, l_neg, r_neg;
    wire stop_mode_pause, clock_mode;
    wire stop_mode_digit;
    reg reset_mode;
    wire [1:0] mode_selected;
    
    //top input
    btn_ripple bL(clk_100MHz, btnL, dcl_db);
    btn_ripple bR(clk_100MHz, btnR, dcr_db);
    btn_ripple bU(clk_100MHz, btnU, inc_db);
    btn_ripple bD(clk_100MHz, btnD, dec_db);
    btn_ripple bC(clk_100MHz, btnC, setting_db);
    btn_ripple bReset(clk_100MHz, reset, reset_db);
    
    negedge_detect neg_U(clk_100MHz, dcl_db, l_neg);
    negedge_detect neg_D(clk_100MHz, dcr_db, r_neg);
//    negedge_detect neg_C(clk_100MHz, setting_db, c_neg);
    // mode selector
    mode_selector sys_mode(
    clk_100MHz, swV16, l_neg, r_neg,
    mode_selected
    );
// some how c button not working
    tff modetog_clk(clk_100MHz, setting_db ,reset_db,(mode_selected == CLOCK),clock_mode);
    // pause and continue
    // problem cant use ttf at the same time 
    tff modetog_sto(clk_100MHz, setting_db ,reset_db, (mode_selected == STOPWATCH), stop_mode_pause);

    // change digit MM:SS -> HH:MM
    tff modetog_sto_res(clk_100MHz, inc_db ,reset_db, (mode_selected == STOPWATCH),stop_mode_digit);
    
    Digit_Selector editdigit(clk_100MHz,clock_mode && reset_mode,l_neg,r_neg,selectdigit);
    // structire top module of each feature
    top_clock_module CLOCK_Mode(clk_100MHz, 
    setting_db, inc_db, dec_db,
    sw, timeSw, clock_mode && reset_mode, selectdigit , led0, led1,// selected_clock,
     a_clock,b_clock,c_clock,d_clock);
     
    top_stopwatch_module STOP_Mode(clk_100MHz,led0, stop_mode_pause, reset_db,
    stop_mode_digit, a_stop,b_stop,c_stop,d_stop, led_pause, led_hhmmss
    );
    
    assign sysmode = mode_selected;
    always@(posedge clk_100MHz) begin
    // set all tog mode 0 when swV16 == 1
    if(swV16) reset_mode = 0;
    else reset_mode = 1;
    case(mode_selected)
    2'b00: begin // normal clock
        vis_selected<=selectdigit;//select_clock
        hrs_tens <= a_clock;
        hrs_ones <= b_clock;
        mins_tens <= c_clock;
        mins_ones <= d_clock;
    end
    2'b01: begin // alarm setter
        vis_selected<=4'b1111;
        hrs_tens <= 4'b1001;
        hrs_ones <= 4'b0000;
        mins_tens <= 4'b0000;
        mins_ones <= 4'b1001;
    end
    2'b10: begin // stop watch
        vis_selected<=selectdigit;
        hrs_tens <= a_stop;
        hrs_ones <= b_stop;
        mins_tens <= c_stop;
        mins_ones <= d_stop;
    end
    2'b11: begin // COunt down
        vis_selected<=4'b1111;
        hrs_tens <= 4'b1001;
        hrs_ones <= 4'b0000;
        mins_tens <= 4'b0000;
        mins_ones <= 4'b1001;
    end
    endcase
    end
    
    // set 7 seg [hrs_tens, hrs_ones, mins_tens, mins_ones]
    bcd7seg seg7(clk_100MHz, reset, vis_selected, hrs_tens, hrs_ones, mins_tens, 
                      mins_ones, seg, AN);
endmodule
