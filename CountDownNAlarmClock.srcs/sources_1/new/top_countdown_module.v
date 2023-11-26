`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2023 09:55:05 AM
// Design Name: 
// Module Name: top_countdown_module
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
// z is output = 0, c = for editing ,s finish setting
// idle 0000 no blink   z = 1, c = 0, s = 0
//-> 0000 setting       z = 1, c = 1, s = 0 (btn c) -> mode signal 00 10 01
//-> XXXX setting       z = 0, c = 1, s = 0 (btn lrud)
//-> XXXX counting down z = 0, c = 0, s = 1 
//-> XXXX alarm         z = 1, c = 0, s = 1 (btn c)

module top_countdown_module(
    input clk_100MHz,
    input clk_1Hz,       // from Basys 3
    input reset_db,
//    input setting_db,          // btnC Basys 3
    input dec_db,         // btnD Basys 3
    input inc_db,          // btnU Basys 3
    input mode, // btn c signal when mode is selected
    input [3:0] selectdigit,
    output [3:0] am, bm, as, bs     // Internal
    ,output led_set
    ,output [1:0] curr_state
    ,output alarm
    );
    
    wire w_1Hz, w_1Hz_sig;                                 // 1Hz signal
    wire w_dec_mins, w_dec_mins_1HZ;                 // mod to mod
    wire w_inc_mins, w_inc_mins_1HZ;
    wire inc_mins_or, dec_mins;               // from OR gates
    wire insig,desig,modesig;                                  // 0 = view, 1 = set
    wire [5:0] sec_out;
    wire [6:0] minutes_out;
    wire z;
    reg c,s;
    parameter SET = 2'b10, DOWN = 2'b01, PAUSE = 2'b11, IDLE = 2'b00;
    
    //    reg j,k;
    //    jkff mode_set_q(clk_100MHz, j, k, s, sb);
    initial c = 0;
    initial s = 0;
    
    assign curr_state = {c,s};
    assign z = (minutes_out == 0 && sec_out == 0);
    assign alarm = (z & {c,s} == DOWN);

    oneHz_generator seconds_gear(clk_100MHz, w_1Hz);
    posedge_detect pos_1hz(clk_100MHz, w_1Hz, w_1Hz_sig);
    // still init 0059
    always@(posedge clk_100MHz) begin
        if (modesig) begin
        case({c,s})
        IDLE: {c,s} <= SET;
        SET: {c,s} <= DOWN;
        DOWN: begin 
        if(~z){c,s} <= PAUSE;
        else if (alarm) {c,s} <= IDLE;
        end
        PAUSE: if(~z){c,s} <= DOWN;
        endcase
        end
        if(reset_db){c,s} <= IDLE;
    end
    //in and de second not work properly // checj sync mode digit selector with this mode
    seconds_CD sec(
    .clk_100MHz(clk_100MHz),
//    .clk_1Hz(clk_1Hz),
    .reset(reset_db),
    .increase(inc_sec_or), //{~mode | ~(inc_sec_or ^ dec_secs), inc_sec_or & ~dec_secs}
    .decrease((dec_secs | ({c,s} == DOWN && w_1Hz_sig) && ({c,s} != PAUSE) && ~z)),
//    .current_min(minutes_out != 0),
    .inc_minutes(w_inc_mins),
    .dec_minutes(w_dec_mins),
    .sec_ctr(sec_out)
    );
    
    minutes_CD min(
    .clk(clk_100MHz),
     .inc_minutes(inc_mins_or),
     .dec_minutes(dec_mins), 
     .reset(reset_db), 
      .min(minutes_out)
    );
    
    negedge_detect neg_U(clk_100MHz, inc_db, insig);
    negedge_detect neg_D(clk_100MHz, dec_db, desig);
    negedge_detect neg_M(clk_100MHz, mode, modesig);
    // de clock
    posedge_detect pos_sec_count(clk_100MHz, w_dec_mins, w_dec_mins_1HZ);
    posedge_detect pos_sec_in_count(clk_100MHz, w_inc_mins, w_inc_mins_1HZ);
    
    
    
    assign dec_mins = w_dec_mins_1HZ | ((desig && ({c,s} == SET)) && (selectdigit == 4'b0011));  // decrease hour by button 
    assign dec_secs = (desig && ({c,s} == SET)) && (selectdigit == 4'b1100); // decrease minute by button
    // should be run all time
    assign inc_mins_or = w_inc_mins_1HZ | ((insig && ({c,s} == SET)) && (selectdigit == 4'b0011));  // increase hour by button or carry from minute counter
    assign inc_sec_or = (insig && ({c,s} == SET)) && (selectdigit == 4'b1100); // increase minute by button or carry from seconds counter
    
    bin2bcd MinuteStop(minutes_out, am, bm);
    bin2bcd SecondStop(sec_out, as, bs);
    assign led_set = mode;
endmodule
