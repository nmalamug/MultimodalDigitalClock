`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2022 03:59:10 PM
// Design Name: 
// Module Name: digit_select
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


module digit_select( //note not testbenched
    sb_i,
    digit_o,
    clk,
    reset,
    swt,
    mode_i
    );
    input sb_i, clk, reset,swt;
    input [1:0] mode_i;
    output reg [2:0] digit_o;
    reg [2:0] modelast;
    initial begin
        digit_o <= 0;
    end
    always@(posedge clk or negedge reset) begin
        if(!reset) begin
            digit_o <= 0;  
        end else if(sb_i == 1'b1) begin
            if (mode_i == 2'b00 || mode_i == 2'b01)begin
                if(digit_o < 3'b101) begin
                    digit_o <= digit_o + 1'b1;
                end else begin
                    digit_o <= 3'b000;  
                end
            end else if(mode_i == 2'b11) begin
                if(digit_o < 3'b110 && swt == 1'b0) begin
                    digit_o <= digit_o + 1'b1;
                end else begin
                    digit_o <= 3'b000;  
                end
            end
        end else begin
            digit_o <= digit_o;
            if(modelast != mode_i || (swt == 1'b1 && mode_i == 2'b11))begin
                digit_o <= 3'b000;
            end
            modelast <= mode_i;
        end
    end
endmodule
