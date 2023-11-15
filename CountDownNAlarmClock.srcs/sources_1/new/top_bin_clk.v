`timescale 1ns / 1ps

 module top_bin_clock(
    input clk_100MHz,       // from Basys 3
    input reset,            // sw1 Basys 3
    input setting,          // btnC Basys 3
    input dec,         // btnD Basys 3
    input inc,          // btnU Basys 3
    input dcl,         // btnL Basys 3
    input dcr,          // btnR Basys 3
    output [5:0] hours,     // Internal
    output sig_1Hz,         // Internal
    output [5:0] minutes,   // Internal
    output led,
    output [3:0] selectdigit
    );
    
    wire w_1Hz;                                 // 1Hz signal
    wire inc_hrs_db, reset_db, inc_mins_db;     // ripple button signals
    wire w_inc_mins, w_inc_hrs,w_inc_mins_1HZ;                 // mod to mod
    wire inc_mins_or, inc_hrs_or, dec_hrs, dec_mins;               // from OR gates
    wire mode, insig,desig;                                  // 0 = view, 1 = set

    // ripple the input
    btn_ripple bU(clk_100MHz, inc, inc_db);
    btn_ripple bReset(clk_100MHz, reset, reset_db);
    btn_ripple bD(clk_100MHz, dec, dec_db);
    btn_ripple bC(clk_100MHz, setting, setting_db); // comment if this not work
    btn_ripple bL(clk_100MHz, dcl, dcl_db);
    btn_ripple bR(clk_100MHz, dcr, dcr_db);
    
    tff modetog(clk_100MHz, setting_db ,mode);
    Digit_Selector editdigit(clk_100MHz,mode,dcl_db,dcr_db,selectdigit);
    oneHz_generator seconds_gear(clk_100MHz, w_1Hz); //divide signal
    
    // this signal will continuously increasing by one second
    // module minute increment wierdly
    seconds sec(w_1Hz, reset_db, w_inc_mins);
    minutes min(clk_100MHz, inc_mins_or, dec_mins, reset_db, w_inc_hrs, minutes);
    hours hr(clk_100MHz, inc_hrs_or, dec_hrs, reset_db, hours);
    
    negedge_detect neg_U(clk_100MHz, inc_db, insig);
    negedge_detect neg_D(clk_100MHz, dec_db, desig);
    
    posedge_detect pos_sec_count(clk_100MHz, w_inc_mins, w_inc_mins_1HZ);
    
    assign dec_hrs = (desig && mode) && (selectdigit == 4'b0011);  // decrease hour by button 
    assign dec_mins = (desig && mode) && (selectdigit == 4'b1100); // decrease minute by button
    
    assign inc_hrs_or = w_inc_hrs | ((insig && mode) && (selectdigit == 4'b0011));  // increase hour by button or carry from minute counter
    assign inc_mins_or = w_inc_mins_1HZ | ((insig && mode) && (selectdigit == 4'b1100)); // increase minute by button or carry from seconds counter
    //seem like w_inc_hrs increment fuck up
    // animation not turn of after change mode (not go back to state idle)
    assign sig_1Hz = w_1Hz; // pass out 1 Hz signal 
    assign led = mode;
endmodule