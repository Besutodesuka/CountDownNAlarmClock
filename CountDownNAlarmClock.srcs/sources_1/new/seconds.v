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
    output inc_minutes  // To minutes
    );
    
    reg [5:0] sec_ctr = 0;
    
    always @(posedge clk_1Hz or posedge reset) begin
        if(reset)
            sec_ctr <= 0;
        else
            if(sec_ctr >= 59) 
                sec_ctr <= 0;
            else
                sec_ctr <= sec_ctr + 1;
    end
    
    assign inc_minutes = (sec_ctr == 59) ? 1 : 0;
   
endmodule
