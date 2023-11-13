`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2023 03:43:46 PM
// Design Name: 
// Module Name: btn_ripple
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


module btn_ripple(
    input clk_100MHz,
    input btn_in,
    output btn_out
    );
    
    reg temp1, temp2, temp3;
    
    always @(posedge clk_100MHz) begin
        temp1 <= btn_in;
        temp2 <= temp1;
        temp3 <= temp2;
    end
    
    assign btn_out = temp3;
    
endmodule
