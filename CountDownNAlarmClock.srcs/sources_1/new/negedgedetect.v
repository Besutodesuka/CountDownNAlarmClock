`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2023 10:05:38 PM
// Design Name: 
// Module Name: negedgedetect
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


module negedge_detect(
input clk,
input sig,
output reg pulse
    );
    reg sig_prev;
    always@(posedge clk) begin
    if (sig == 0 && sig_prev == 1) pulse <= 1;
    else pulse <= 0;
    sig_prev <= sig;
    end
endmodule
