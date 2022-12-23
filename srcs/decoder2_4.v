`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2022 04:34:44 PM
// Design Name: 
// Module Name: decoder2_4
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


module decoder2_4(
    sct_i,
    en_o
    );
    input [1:0] sct_i;
    output [3:0] en_o;
    wire [3:0] y_int;
    
    assign y_int = (sct_i == 2'b00)? 4'b1000:
                   (sct_i == 2'b01)? 4'b0100:
                   (sct_i == 2'b10)? 4'b0010:
                   4'b0001;
    assign en_o = y_int;
    
endmodule
