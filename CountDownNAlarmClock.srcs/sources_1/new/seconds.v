`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2023 03:21:31 PM
// Design Name: 
// Module Name: seconds
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


module seconds(
    input clk_1Hz,      // From oneHz_generator
    input reset,
    input [1:0] increase, // 0 => dec, 1 => inc
    output inc_minutes,
    output reg [5:0] sec_ctr  // To minutes
    );
    
    initial sec_ctr = 0;
    
    always @(posedge clk_1Hz or posedge reset) begin
        if(reset)
            sec_ctr <= 0;
        else
        // 01 = incremnt
        // 00 = decrement
        // 1X = hold
            if(sec_ctr >= 59) sec_ctr <= 0;
            else if(increase == 2'b01)
                sec_ctr <= sec_ctr + 1;
            else if (increase == 2'b00) sec_ctr <= sec_ctr - 1;
            else sec_ctr <= sec_ctr;
    end
    
    assign inc_minutes = (sec_ctr == 59) ? 1 : 0;
   
endmodule
