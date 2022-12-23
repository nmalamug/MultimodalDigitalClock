`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2022 04:49:55 PM
// Design Name: 
// Module Name: stopwatch2
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


module stopwatch(
reset, clk_1hz, clk,  sw1, sb_i, en,
tm_o
    );
    input reset, sb_i, clk_1hz, clk, sw1;
    input [3:0] en;
    output reg [23:0] tm_o;
    reg [7:0] stopwatch_sec_reg, stopwatch_min_reg, stopwatch_hr_reg;
    reg swflag;
    initial begin
            stopwatch_sec_reg <= 0;
            stopwatch_min_reg <= 0;
            stopwatch_hr_reg <= 0;
            tm_o <= 0;
            swflag <= 0;
    end
     
    always @ (posedge clk or negedge reset) begin
        if (!reset) begin
            stopwatch_sec_reg <= 0;
            stopwatch_min_reg <= 0;
            stopwatch_hr_reg <= 0;
            tm_o <= 0;
            swflag <= 0;
        end
        else if(sb_i == 1) begin
            stopwatch_sec_reg <= 0;
            stopwatch_min_reg <= 0;
            stopwatch_hr_reg <= 0;
            tm_o <= 0;
        end else if (clk_1hz == 1 && swflag == 1) begin
            stopwatch_sec_reg <= stopwatch_sec_reg + 1;
        end else begin
             if(stopwatch_sec_reg[3:0] == 4'b1010) begin
                 stopwatch_sec_reg[3:0] <= 0;
                 stopwatch_sec_reg[7:4] <= stopwatch_sec_reg[7:4] + 1'b1;
                    if(stopwatch_sec_reg[7:4] == 4'b0101) begin
                         stopwatch_sec_reg <= 0;
                         stopwatch_min_reg <=  stopwatch_min_reg + 1;
                        if(stopwatch_min_reg[3:0] == 4'b1001) begin
                                 stopwatch_min_reg[3:0] <= 0;
                                 stopwatch_min_reg[7:4] <= stopwatch_min_reg[7:4] + 1'b1;
                                 if(stopwatch_min_reg[7:4] == 4'b0101) begin
                                     stopwatch_min_reg <= 0;
                                     stopwatch_hr_reg <=  stopwatch_hr_reg + 1;
                                     if(stopwatch_hr_reg[3:0] == 4'b1001) begin
                                         stopwatch_hr_reg[3:0] <= 0;
                                         stopwatch_hr_reg[7:4] <= stopwatch_hr_reg[7:4] + 1'b1;
                                     end
                                  end
                            end
                         end
                      end
            if(en == 4'b0010) begin
                if(sw1 == 1'b1)begin
                    swflag <= ~swflag;
                end
            end
            tm_o <= {stopwatch_hr_reg,stopwatch_min_reg,stopwatch_sec_reg};
        end
    end

    
    
endmodule
