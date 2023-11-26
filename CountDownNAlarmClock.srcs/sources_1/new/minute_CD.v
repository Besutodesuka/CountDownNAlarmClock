`timescale 1ns / 1ps

module minutes_CD(
    input clk,
    input inc_minutes,      // From seconds
    input dec_minutes,
    input reset,
    output [6:0] min   // For LEDs
    );
    reg [6:0] min_ctr= 0;
    
    always @(posedge clk) begin
            if(reset || (min_ctr >= 99)) min_ctr <= 0;
            else if((min_ctr >= 0) && dec_minutes) min_ctr <= min_ctr - 1;
            else if ((min_ctr <= 99) && inc_minutes)min_ctr <= min_ctr + 1;
           
    end
    assign min = min_ctr;
endmodule