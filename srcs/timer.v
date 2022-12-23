`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2022 01:29:39 PM
// Design Name: 
// Module Name: TIMER_FINAL
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


module timer(
    clk, 
    clk_1hz, 
    reset, 
    sb_i, 
    ib_i, 
    swt,
    en_i, 
    digit_i,
    tm_o
        );
    input clk, clk_1hz, reset, sb_i, ib_i, swt;
    input [3:0] en_i;
    input [2:0] digit_i;
    output reg [23:0] tm_o;
    reg [23:0] set;
    reg[23:0] tm_next;
    
    always@(posedge clk or negedge reset)begin
        if(!reset)begin
            tm_o <= 24'b000000000000000000000000;//Instantiate to zero
            set <= 24'b000000000000000000000000;
        end else if (clk_1hz == 1'b1 && swt == 1'b1) begin//Normal next behavior
            tm_o <= tm_next;
        end else begin
            if (sb_i == 1'b1 && swt == 1'b0)begin
            tm_o <= set;
            end
            if(en_i == 4'b0001 && ib_i == 1'b1 && swt == 1'b0)begin//Incrementing behavior - only when switch is off
                case(digit_i)
                    3'b001:begin
                        if(tm_o[3:0] >= 4'b1001)begin
                            tm_o[3:0] = 4'b0000;
                        end else begin
                            tm_o[3:0] = tm_o[3:0] + 1'b1;  
                        end
                    end
                    3'b010:begin
                        if(tm_o[7:4] >= 4'b0101)begin
                            tm_o[7:4] = 4'b0000;
                        end else begin
                            tm_o[7:4] = tm_o[7:4] + 1'b1;  
                        end
                    end
                    3'b011:begin
                        if(tm_o[11:8] >= 4'b1001)begin
                            tm_o[11:8] = 4'b0000;
                        end else begin
                            tm_o[11:8] = tm_o[11:8] + 1'b1;  
                        end
                    end
                    3'b100:begin
                        if(tm_o[15:12] >= 4'b0101)begin
                            tm_o[15:12] = 4'b0000;
                        end else begin
                            tm_o[15:12] = tm_o[15:12] + 1'b1;  
                        end
                    end
                    3'b101:begin
                        if(tm_o[19:16] >= 4'b1001)begin
                            tm_o[19:16] = 4'b0000;
                        end else begin
                            tm_o[19:16] = tm_o[19:16] + 1'b1;  
                        end
                    end
                    3'b110:begin
                        if(tm_o[23:20] >= 4'b1001)begin
                            tm_o[23:20] = 4'b0000;
                        end else begin
                            tm_o[23:20] = tm_o[23:20] + 1'b1;  
                        end
                    end
                endcase
                set = tm_o;
            end
        end
    end//end always
    
    always@(*) begin
        if (tm_o == 24'b000000000000000000000000)
            tm_next <= 24'b000000000000000000000000;
        else begin
            if(tm_o[23:0] == 24'b000000000000000000000000)begin
                tm_next[3:0] <= tm_o[3:0];
            end else if(tm_o[3:0] > 4'b0000)begin // seconds
                tm_next[3:0] <= tm_o[3:0] - 1'b1;
            end else begin
                tm_next[3:0] <= 4'b1001;
            end
            
            if(tm_o[3:0] != 4'b0000)begin// tens of seconds
                tm_next[7:4] <= tm_o[7:4];
            end else if(tm_o[7:4] > 4'b0000) begin
                tm_next[7:4] <= tm_o[7:4] - 1'b1;
            end else begin
                tm_next[7:4] <= 4'b0101;
            end
            
            if(tm_o[7:0] != 8'b00000000)begin// minutes
                tm_next[11:8] <= tm_o[11:8];
            end else if(tm_o[11:8] > 4'b0000) begin
                tm_next[11:8] <= tm_o[11:8] - 1'b1;
            end else begin
                tm_next[11:8] <= 4'b1001;
            end
            
            if(tm_o[11:0] != 12'b000000000000)begin// tens of minutes
                tm_next[15:12] <= tm_o[15:12];
            end else if(tm_o[15:12] > 4'b0000) begin
                tm_next[15:12] <= tm_o[15:12] - 1'b1;
            end else begin
                tm_next[15:12] <= 4'b0101;
            end
            
            if(tm_o[15:0] != 16'b0000000000000000)begin// Hours
                tm_next[19:16] <= tm_o[19:16];
            end else if(tm_o[19:16] > 4'b0000) begin
                tm_next[19:16] <= tm_o[19:16] - 1'b1;
            end else begin
                tm_next[19:16] <= 4'b1001;
            end
            
            if(tm_o[19:0] != 20'b00000000000000000000)begin// Tens of hours
                tm_next[23:20] <= tm_o[23:20];
            end else if(tm_o[23:20] > 4'b0000) begin
                tm_next[23:20] <= tm_o[23:20] - 1'b1;
            end else begin
                tm_next[23:20] <= 4'b1001;
            end      
        end
    end
endmodule
