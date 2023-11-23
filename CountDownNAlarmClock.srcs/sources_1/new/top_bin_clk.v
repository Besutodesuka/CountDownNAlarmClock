`timescale 1ns / 1ps

 module top_bin_clock(
    input clk_100MHz,       // from Basys 3
    input reset_db,            // sw1 Basys 3
    // signal from button
    input setting_db,          // btnC Basys 3
    input dec_db,         // btnD Basys 3
    input inc_db,          // btnU Basys 3
    input dcl_db,         // btnL Basys 3
    input dcr_db,          // btnR Basys 3
    input mode,
    output [5:0] hours_out,     // Internal
    output sig_1Hz,         // Internal
    output [5:0] minutes_out,   // Internal
    output led,
    output [3:0] selectdigit
    );
    
    wire w_1Hz;                                 // 1Hz signal
    wire w_inc_mins, w_inc_hrs,w_inc_mins_1HZ;                 // mod to mod
    wire inc_mins_or, inc_hrs_or, dec_hrs, dec_mins;               // from OR gates
    wire insig,desig;                                  // 0 = view, 1 = set

    // available only when sysmode == 00
//    tff modetog(clk_100MHz, setting_db && (sysmode == 2'b00),mode);
    Digit_Selector editdigit(clk_100MHz,mode,dcl_db,dcr_db,selectdigit);
    oneHz_generator seconds_gear(clk_100MHz, w_1Hz); //divide signal
    
    // this signal will continuously increasing by one second
    // module minute increment wierdly
    seconds sec(w_1Hz, reset_db, 2'b01, w_inc_mins);
    minutes min(clk_100MHz, inc_mins_or, dec_mins, reset_db, w_inc_hrs, minutes_out);
    hours hr(clk_100MHz, inc_hrs_or, dec_hrs, reset_db, hours_out);
    
    negedge_detect neg_U(clk_100MHz, inc_db, insig);
    negedge_detect neg_D(clk_100MHz, dec_db, desig);
    
    posedge_detect pos_sec_count(clk_100MHz, w_inc_mins, w_inc_mins_1HZ);
    
    assign dec_hrs = (desig && mode) && (selectdigit == 4'b0011);  // decrease hour by button 
    assign dec_mins = (desig && mode) && (selectdigit == 4'b1100); // decrease minute by button
    // should be run all time
    assign inc_hrs_or = w_inc_hrs | ((insig && mode) && (selectdigit == 4'b0011));  // increase hour by button or carry from minute counter
    assign inc_mins_or = w_inc_mins_1HZ | ((insig && mode) && (selectdigit == 4'b1100)); // increase minute by button or carry from seconds counter
    assign sig_1Hz = w_1Hz; // pass out 1 Hz signal 
    assign led = mode;
endmodule