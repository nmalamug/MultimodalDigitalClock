`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2022 02:22:29 PM
// Design Name: 
// Module Name: mux4_1
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


module mux4_1(
    clk24,
    clk12,
    stw,
    tmr,
    ct_i,
    t_o
    );
    input [23:0] clk24, clk12, stw, tmr;
    input [1:0] ct_i;
    output [23:0] t_o;
    
    assign t_o = (ct_i == 2'b00)?clk24:
                 (ct_i == 2'b01)?clk12:
                 (ct_i == 2'b10)?stw:
                 tmr;
endmodule
