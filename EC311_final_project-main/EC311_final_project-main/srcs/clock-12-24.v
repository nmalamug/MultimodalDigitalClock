`timescale 1ns / 1ps

module clock_12_24(
    clk,//clock
    clk_1hz,
    reset, //reset
    en_i, //enable
    digit_i,//button for shifting digit select
    inc_bn_i,//button for incrementing
    tlve_o, //twelve hour time
    milt_o, //24 hr/military time
    AMPM_o
    );
    input clk, clk_1hz, reset, inc_bn_i; 
    input [3:0] en_i;
    input [2:0] digit_i;
    output reg [23:0] tlve_o, milt_o;
    output reg AMPM_o;
    reg [23:0] tlve_next,milt_next;
    
    always@(posedge clk or negedge reset)begin
        if(!reset)begin
            tlve_o = 24'b000000000000000000000000;
            milt_o = 24'b000000000000000000000000;
        end else if(clk_1hz == 1'b1) begin
            milt_o = milt_next;
        end else begin 
            if (en_i == 4'b1000 || en_i == 4'b0100)begin
                if (inc_bn_i == 1'b1)begin
                    case(digit_i)
                        3'b001:begin
                            if(milt_o[3:0] >= 4'b1001)begin
                                milt_o[3:0] <= 4'b0000;
                            end else begin
                                milt_o[3:0] <= milt_o[3:0] + 1'b1;  
                            end
                        end // Button for seconds
                        3'b010:begin
                            if(milt_o[7:4] >= 4'b0101)begin
                                milt_o[7:4] <= 4'b0000;
                            end else begin
                                milt_o[7:4] <= milt_o[7:4] + 1'b1; 
                            end
                        end//Button for tens of seconds
                        3'b011:begin
                            if(milt_o[11:8] >= 4'b1001)begin
                                milt_o[11:8] <= 4'b0000;
                            end else begin
                                milt_o[11:8] <= milt_o[11:8] + 1'b1;  
                            end
                        end//Button for minutes
                        3'b100:begin
                            if(milt_o[15:12] >= 4'b0101)begin
                                milt_o[15:12] <= 4'b0000;
                            end else begin
                                milt_o[15:12] <= milt_o[15:12] + 1'b1; 
                            end
                        end // Assign military time to the right places
                        3'b101:
                        begin
                            case (milt_o[23:20])
                                4'b0000:begin
                                    if (milt_o[19:16] >= 4'b1001) begin
                                        milt_o[23:16] <= 8'b00010000;
                                    end else begin
                                        milt_o[19:16] <= milt_o[19:16] + 1'b1;
                                        milt_o[23:20] <= milt_o[23:20];
                                    end
                                end
                                4'b0001:begin
                                    if (milt_o[19:16] >= 4'b1001) begin
                                        milt_o[23:16] <= 8'b00100000;
                                    end else begin
                                        milt_o[19:16] <= milt_o[19:16] + 1'b1;
                                        milt_o[23:20] <= milt_o[23:20];
                                    end
                                end
                                4'b0010:begin
                                    if (milt_o[19:16] >= 4'b0011) begin
                                        milt_o[23:16] <= 8'b00000000;
                                    end else begin
                                        milt_o[19:16] <= milt_o[19:16] + 1'b1;
                                        milt_o[23:20] <= milt_o[23:20];
                                    end
                                end
                            endcase// Hours
                        end
                    endcase
                end
            end
            
            tlve_o[15:0] <= milt_o[15:0];//Assign twelve hour time same as military
            
            case(milt_o[23:16]) //Hardcoded hour conversion LOL
                8'b00000000:begin
                    tlve_o [23:16]<= 8'b00010010;
                    AMPM_o <= 1'b0;
                end//0
                8'b00000001:begin//1
                    tlve_o [23:16]<= 8'b0000001;
                    AMPM_o <= 1'b0;
                end
                8'b00000010:begin//2
                    tlve_o [23:16]<= 8'b00000010;
                    AMPM_o <= 1'b0;
                end
                8'b00000011:begin
                    tlve_o [23:16]<= 8'b00000011;
                    AMPM_o <= 1'b0;
                end//3
                8'b00000100:begin
                    tlve_o [23:16]<= 8'b00000100;
                    AMPM_o <= 1'b0;
                end//4
                8'b00000101:begin
                    tlve_o [23:16]<= 8'b00000101;
                    AMPM_o <= 1'b0;
                end//5
                8'b00000110:begin
                    tlve_o [23:16]<= 8'b00000110;
                    AMPM_o <= 1'b0;
                end//6
                8'b00000111:begin
                    tlve_o [23:16]<= 8'b00000111;
                    AMPM_o <= 1'b0;
                end//7
                8'b00001000:begin
                    tlve_o [23:16]<= 8'b00001000;
                    AMPM_o <= 1'b0;
                end//8
                8'b00001001:begin
                    tlve_o [23:16]<= 8'b00001001;
                    AMPM_o <= 1'b0;
                end//9
                8'b00010000:begin
                    tlve_o [23:16]<= 8'b00010000;
                    AMPM_o <= 1'b0;
                end//10
                8'b00010001:begin
                    tlve_o [23:16]<= 8'b00010001;
                    AMPM_o <= 1'b0;
                end//11
                8'b00010010:begin
                    tlve_o [23:16]<= 8'b00010010;
                    AMPM_o <= 1'b1;
                end//12
                8'b00010011:begin
                    tlve_o [23:16]<= 8'b00000001;
                    AMPM_o <= 1'b1;
                end//13
                8'b00010100:begin
                    tlve_o [23:16]<= 8'b00000010;
                    AMPM_o <= 1'b1;
                end//14
                8'b00010101:begin
                    tlve_o [23:16]<= 8'b00000011;
                    AMPM_o <= 1'b1;
                end//15
                8'b00010110:begin
                    tlve_o [23:16]<= 8'b00000100;
                    AMPM_o <= 1'b1;
                end//16
                8'b00010111:begin
                    tlve_o [23:16]<= 8'b00000101;
                    AMPM_o <= 1'b1;
                end//17
                8'b00011000:begin
                    tlve_o [23:16]<= 8'b00000110;
                    AMPM_o <= 1'b1;
                end//18
                8'b00011001:begin
                    tlve_o [23:16]<= 8'b00000111;
                    AMPM_o <= 1'b1;
                end//19
                8'b00100000:begin
                    tlve_o [23:16]<= 8'b00001000;
                    AMPM_o <= 1'b1;
                end//20
                8'b00100001:begin
                    tlve_o [23:16]<= 8'b00001001;
                    AMPM_o <= 1'b1;
                end//21
                8'b00100010:begin
                    tlve_o [23:16]<= 8'b00010000;
                    AMPM_o <= 1'b1;
                end//22
                8'b00100011:begin
                    tlve_o [23:16]<= 8'b00010001;
                    AMPM_o <= 1'b1;
                end//23
            endcase // Update the twelve hours to military hours. 
        end    
    end

    always@(*) begin //Combinational logic for the time. 
        if(milt_o[3:0] < 4'b1001)begin
            milt_next[3:0] <= milt_o[3:0] + 1'b1;
        end else begin
            milt_next[3:0] <= 4'b0000;
        end
        
        if(milt_o[3:0] != 4'b1001)begin
            milt_next[7:4] <= milt_o[7:4];
        end else if(milt_o[7:4] < 4'b0101) begin
            milt_next[7:4] <= milt_o[7:4] + 1'b1;
        end else begin
            milt_next[7:4] <= 4'b0000;
        end
        
        if(milt_o[7:0] != 8'b01011001)begin
            milt_next[11:8] <= milt_o[11:8];
        end else if(milt_o[11:8] < 4'b1001) begin
            milt_next[11:8] <= milt_o[11:8] + 1'b1;
        end else begin
            milt_next[11:8] <= 4'b0000;
        end
        
        if(milt_o[11:0] != 12'b100101011001)begin
            milt_next[15:12] <= milt_o[15:12];
        end else if(milt_o[15:12] < 4'b0101) begin
            milt_next[15:12] <= milt_o[15:12] + 1'b1;
        end else begin
            milt_next[15:12] <= 4'b0000;
        end
        
        if(milt_o[15:0] == 16'b0101100101011001) begin   
            case (milt_o[23:20])
                4'b0000:begin
                    if (milt_o[19:16] >= 4'b1001) begin
                        milt_next[23:16] <= 8'b00010000;
                    end else begin
                        milt_next[19:16] <= milt_o[19:16] + 1'b1;
                        milt_next[23:20] <= milt_o[23:20];
                    end
                end
                4'b0001:begin
                    if (milt_o[19:16] >= 4'b1001) begin
                        milt_next[23:16] <= 8'b00100000;
                    end else begin
                        milt_next[19:16] <= milt_o[19:16] + 1'b1;
                        milt_next[23:20] <= milt_o[23:20];
                    end
                end
                4'b0010:begin
                    if (milt_o[19:16] >= 4'b0011) begin
                        milt_next[23:16] <= 8'b00000000;
                    end else begin
                        milt_next[19:16] <= milt_o[19:16] + 1'b1;
                        milt_next[23:20] <= milt_o[23:20];
                    end
                end
            endcase
            
        end else begin
            milt_next[23:16] <= milt_o[23:16];
        end
    end
endmodule
