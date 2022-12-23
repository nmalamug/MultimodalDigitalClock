`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2022 02:44:22 PM
// Design Name: 
// Module Name: clk_1hz
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


module clk_1hz(
    clk,
    reset,
    clk_1hz
    );
    input reset, clk;
    output reg clk_1hz;
    integer s_count = 0;
    always@(posedge clk or negedge reset)begin
        if(!reset)begin
            clk_1hz <= 0;
            s_count <= 0;
        end else begin
            s_count = s_count + 1;
            if(s_count >= 50000000)begin //50000000
                s_count = 0;
                clk_1hz <= ~clk_1hz;
            end
        end
    end
endmodule
