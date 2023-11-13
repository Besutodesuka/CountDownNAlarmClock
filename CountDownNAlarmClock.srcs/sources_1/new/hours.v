`timescale 1ns / 1ps

module hours(
    input inc_hours,        // From minutes
    input reset,
    output [5:0] hours
    );
    
    reg [5:0] hrs_ctr;
    initial hrs_ctr = 0;
    
    always @(negedge inc_hours or posedge reset) begin
        if(reset)
            hrs_ctr <= 0;
        else
            if(hrs_ctr == 23)
                hrs_ctr <= 0;
            else
                hrs_ctr <= hrs_ctr + 1;
    end
    
    assign hours = hrs_ctr;
    
endmodule