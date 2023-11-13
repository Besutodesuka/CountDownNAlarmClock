`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2023 03:16:30 PM
// Design Name: 
// Module Name: 1secHzgen
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

module oneHz_generator(
    input clk_100MHz,       // 100MHz BASYS 3
    output clk_1Hz
    );
    
    reg [25:0] counter_reg;
    reg clk_out_reg;
    initial clk_out_reg = 0;
    initial counter_reg = 0;
    
    always @(posedge clk_100MHz) begin
        if(counter_reg == 49_999_999) begin
            counter_reg <= 0;
            clk_out_reg <= ~clk_out_reg;
        end
        else
            counter_reg <= counter_reg + 1;
    end
    assign clk_1Hz = clk_out_reg;
endmodule
