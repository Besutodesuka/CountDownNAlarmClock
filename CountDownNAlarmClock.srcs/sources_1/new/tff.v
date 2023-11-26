`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2023 12:12:09 AM
// Design Name: 
// Module Name: tff
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


module tff(
input clk_100MHz,
input t,
input reset,
input activate,
output reg q
);
initial q = 0;
always @ (posedge clk_100MHz) begin
    if(activate) begin
        if(reset) q = 0;
        else q <= (t) ? ~q : q;  
//    else q <= q;  
        end
    end 
endmodule
