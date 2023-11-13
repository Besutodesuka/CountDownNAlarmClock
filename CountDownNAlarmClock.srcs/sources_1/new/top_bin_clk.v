`timescale 1ns / 1ps

module top_bin_clock(
    input clk_100MHz,       // from Basys 3
    input reset,            // sw1 Basys 3
    input setting,          // btnC Basys 3
    input inc_mins,         // btnD Basys 3
    input inc_hrs,          // btnU Basys 3
    output [5:0] hours,     // Internal
    output sig_1Hz,         // Internal
    output [5:0] minutes,   // Internal
    output led
    );
    
    wire w_1Hz;                                 // 1Hz signal
    wire inc_hrs_db, reset_db, inc_mins_db;     // ripple button signals
    wire w_inc_mins, w_inc_hrs;                 // mod to mod
    wire inc_mins_or, inc_hrs_or;               // from OR gates
    wire mode;                                  // 0 = view, 1 = set
    // ripple the input
    btn_ripple bU(clk_100MHz, inc_hrs, inc_hrs_db);
    btn_ripple bReset(clk_100MHz, reset, reset_db);
    btn_ripple bD(clk_100MHz, inc_mins, inc_mins_db);
    btn_ripple bC(clk_100MHz, setting, setting_db); // comment if this not work
    
    tff modetog(clk_100MHz, setting_db ,mode);
    //clock for increament counter
    oneHz_generator seconds_gear(clk_100MHz, w_1Hz); //divide signal
    
    // this signal will continuously increasing by one second
    seconds sec(w_1Hz, reset_db, w_inc_mins);
    minutes min(inc_mins_or, reset_db, w_inc_hrs, minutes);
    hours hr(inc_hrs_or, reset_db, hours);
    
    assign inc_hrs_or = w_inc_hrs | (inc_hrs_db && mode);  // increase hour by button or carry from minute counter
    assign inc_mins_or = w_inc_mins | (inc_mins_db && mode); // increase minute by button or carry from seconds counter
    assign sig_1Hz = w_1Hz; // pass out 1 Hz signal 
    assign led = mode;
endmodule