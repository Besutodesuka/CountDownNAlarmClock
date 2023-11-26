`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2023 11:07:24 AM
// Design Name: 
// Module Name: timezone_selector
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


module timezone_selector(
    input [5:0] Vhours,
    input [11:0] timeV,
    input addOsub,
    output reg [5:0] value
    );
    always @* begin
        case (timeV)
        12'b000000000000: value=0;
        12'b100000000000: value=1;
        12'b010000000000: value=2;
        12'b001000000000: value=3;
        12'b000100000000: value=4;
        12'b000010000000: value=5;
        12'b000001000000: value=6;
        12'b000000100000: value=7;
        12'b000000010000: value=8;
        12'b000000001000: value=9;
        12'b000000000100: value=10;
        12'b000000000010: value=11;
        12'b000000000001: value=12;
        default: value = 0;       
        endcase
        if(addOsub) begin 
        if (Vhours + value > 23) value <= Vhours + value - 24;//add logic of cycle the time 
        else value <= Vhours + value;
        end
        else begin if (Vhours - value > 23)value <= Vhours - value - 40 ;
        else value <= Vhours - value;
        end
    end
endmodule
