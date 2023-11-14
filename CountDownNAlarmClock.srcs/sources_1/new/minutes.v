`timescale 1ns / 1ps

module minutes(
    input clk,
    input inc_minutes,      // From seconds
    input dec_minutes,
    input reset,
    output inc_hours,       // To hours
    output [5:0] min   // For LEDs
    );
    
    reg [5:0] min_ctr = 0;
    
    always @(posedge clk) begin
            if(reset || (min_ctr == 59)) min_ctr <= 0;
            else if((min_ctr >= 0) && dec_minutes) min_ctr <= min_ctr - 1;
            else if ((min_ctr <= 59) && inc_minutes)min_ctr <= min_ctr + 1;
    end
    assign min = min_ctr;
    assign inc_hours = (min_ctr == 59) ? 1 : 0;
endmodule