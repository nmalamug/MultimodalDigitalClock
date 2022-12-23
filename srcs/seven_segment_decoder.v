`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2022 03:24:08 PM
// Design Name: 
// Module Name: seven_segment_decoder
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


module seven_segment_decoder(
    input [3:0] num_i,
    input resetn_i,
    output reg [6:0] seven_o
    );
    always@(*)begin
        if(!resetn_i)
            seven_o = 7'b0000000;
        else begin
            case(num_i)
                4'b0000: seven_o = 7'b1000000;//0
                4'b0001: seven_o = 7'b1111001;//1
                4'b0010: seven_o = 7'b0100100;//2
                4'b0011: seven_o = 7'b0110000;//3
                4'b0100: seven_o = 7'b0011001;//4
                4'b0101: seven_o = 7'b0010010;//5
                4'b0110: seven_o = 7'b0000010;//6
                4'b0111: seven_o = 7'b1111000;//7
                4'b1000: seven_o = 7'b0000000;//8
                4'b1001: seven_o = 7'b0011000;//9
                4'b1010: seven_o = 7'b0001000;//A
                4'b1011: seven_o = 7'b0000000;//B
                4'b1100: seven_o = 7'b1000110;//C
                4'b1101: seven_o = 7'b1000000;//D
                4'b1110: seven_o = 7'b0000110;//E
                4'b1111: seven_o = 7'b0001110;//F
            endcase
        end
    end
            
endmodule
