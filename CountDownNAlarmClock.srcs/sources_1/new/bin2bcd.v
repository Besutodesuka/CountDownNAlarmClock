`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2023 04:03:13 PM
// Design Name: 
// Module Name: bin2bcd
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
// transfer 10base to 2 base
module bin2bcd(
    input [6:0] bin_in,
    output reg [3:0] tens,      // max value 1001 (0-9)
    output reg [3:0] ones       // max value 1001 (0-9)
    );
    
    always @* begin
        tens <= bin_in / 10;
        ones <= bin_in % 10;
    end
    
endmodule
