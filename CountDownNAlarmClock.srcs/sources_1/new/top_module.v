//`timescale 1ns / 1ps
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
    output led0,led1,
    output [1:0] sysmode,
    output [0:6] seg,
    output [3:0] AN
    );
    parameter CLOCK  = 2'b00, ALARM = 2'b01, STOPWATCH = 2'b10, COUNTDOWN = 2'b11;
    reg [3:0] hrs_tens, hrs_ones, mins_tens, mins_ones;
    wire [3:0] a_clock,b_clock,c_clock,d_clock,selected_clock;
    reg [3:0] vis_selected;
     
    wire dcl_db,dcr_db, clock_mode, l_neg, r_neg;
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
    
    // mode selector
    mode_selector sys_mode(
    clk_100MHz, swV16, reset_db, l_neg, r_neg,
    mode_selected
    );
    // btn c mode
    tff modetog_clk(clk_100MHz, setting_db, mode_selected, CLOCK ,clock_mode);
    
    // structire top module of each feature
    top_clock_module CLOCK_Mode(clk_100MHz, 
    reset_db,  dcl_db, dcr_db, setting_db, inc_db, dec_db,
    sw, timeSw, clock_mode && reset_mode, led0, led1, selected_clock,
     a_clock,b_clock,c_clock,d_clock);
    
    assign sysmode = mode_selected;
    always@(posedge clk_100MHz) begin
    // set all tog mode 0 when swV16 == 1
    if(swV16) reset_mode = 0;
    else reset_mode = 1;
    case(mode_selected)
    2'b00: begin // normal clock
        vis_selected<=selected_clock;
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
        vis_selected<=4'b1111;
        hrs_tens <= 4'b1001;
        hrs_ones <= 4'b0000;
        mins_tens <= 4'b0000;
        mins_ones <= 4'b1001;
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
