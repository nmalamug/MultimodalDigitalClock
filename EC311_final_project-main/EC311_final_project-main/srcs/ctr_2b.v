`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2022 03:22:06 PM
// Design Name: 
// Module Name: ctr_2b
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


module ctr_2b(
    clk,
    reset,
    inc_i,
    ct_o
    );
    input clk,reset,inc_i;
    output reg [1:0] ct_o;
    reg [1:0] next;
    initial begin
        ct_o <= 0;
    end
    always@(posedge clk or negedge reset) begin
       if(!reset) begin
          ct_o <= 0;  
       end else if(inc_i == 1'b1) begin
          ct_o <= ct_o + 1'b1;
       end else begin
          ct_o <= ct_o;
       end
    end

    
endmodule
