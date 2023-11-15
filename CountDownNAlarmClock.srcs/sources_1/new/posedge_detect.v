`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2023 09:47:05 AM
// Design Name: 
// Module Name: posedge_detect
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


module posedge_detect(
input clk,
input sig,
output reg pulse
    );
    reg sig_prev;
    always@(posedge clk) begin
    if (sig == 1 && sig_prev == 0) pulse <= 1;
    else pulse <= 0;
    sig_prev <= sig;
    end
endmodule
