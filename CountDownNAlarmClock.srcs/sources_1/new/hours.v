`timescale 1ns / 1ps

module hours(
    input clk,
    input inc_hours,        // From minutes
    input dec_hours,
    input reset,
    output [5:0] hours
    );
    
    reg [5:0] hrs_ctr;
    initial hrs_ctr = 0;

    always @(posedge clk) begin
            if(reset || (hrs_ctr > 23)) hrs_ctr <= 0;
            else if((hrs_ctr >= 0) && dec_hours) hrs_ctr <= hrs_ctr - 1;
            else if ((hrs_ctr <= 23) && inc_hours)hrs_ctr <= hrs_ctr + 1;
    end
    assign hours = hrs_ctr;
    //seem like inc from 
    
//    always @(posedge reset, negedge inc_hours,negedge dec_hours) begin
//            if(reset || (hrs_ctr == 59)) hrs_ctr <= 0;
//            else if((hrs_ctr > 0) && dec_hours) hrs_ctr <= hrs_ctr - 1;
//            else hrs_ctr <= hrs_ctr + 1;
//    end
//    assign hours = hrs_ctr;
endmodule