`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2023 03:10:05 PM
// Design Name: 
// Module Name: second_CD
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


module seconds_CD(
    input clk_100MHz,
//    input clk_1Hz,      // From oneHz_generator
    input reset,
    input increase,
    input decrease,
//    input [6:0] current_min,    
    output inc_minutes,
    output dec_minutes,
    output reg [5:0] sec_ctr  // To minutes
    );
    
    initial sec_ctr = 0;
    
    always @(posedge clk_100MHz) begin
        if(reset)
            sec_ctr <= 0;
        else 
            if(sec_ctr >= 59 & increase) sec_ctr <= 0;
            else if(sec_ctr <= 0 & decrease) sec_ctr <= 59;//if(decrease) sec_ctr <= 0; else
            else if(increase) sec_ctr <= sec_ctr + 1;
            else if (decrease) sec_ctr <= sec_ctr - 1;
            else sec_ctr <= sec_ctr;
    end
    
    assign dec_minutes = (sec_ctr == 0 && decrease);
    assign inc_minutes = (sec_ctr == 59 && increase);
    
endmodule
