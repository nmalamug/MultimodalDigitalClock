`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 06:45:43 PM
// Design Name: 
// Module Name: top_clock
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


module top_clock(
    clk,
    reset,
    shft_bn_i,
    inc_bn_i,
    mode_bn_i,
    swt_i,
    tm_o,
    AMPM_o,
    digit_o,
    mode_o
    );
    input clk, reset, shft_bn_i, inc_bn_i, mode_bn_i, swt_i;
    output wire AMPM_o;
    output wire [1:0] mode_o;
    output wire [2:0] digit_o;
    output wire [23:0] tm_o;
    
    wire sb, ib, mb, clk_1hz, c1hd;
    wire [3:0] en;
    wire [23:0] tlve,milt,stw,tmrs; // ,stw,tmr;
    
    clk_1hz c1h (.clk(clk),.reset(reset),.clk_1hz(c1hd));
    
    debouncer ch (.clk(clk),.reset(reset),.btn_i(c1hd),.btn_o(clk_1hz));
    debouncer sbd (.clk(clk),.reset(reset),.btn_i(shft_bn_i),.btn_o(sb));
    debouncer ibd (.clk(clk),.reset(reset),.btn_i(inc_bn_i),.btn_o(ib));
    debouncer mbd (.clk(clk),.reset(reset),.btn_i(mode_bn_i),.btn_o(mb));  
    
    ctr_2b cr (.clk(clk),.reset(reset),.inc_i(mb),.ct_o(mode_o));
    
    digit_select ds (.sb_i(sb),.clk(clk),.reset(reset),.mode_i(mode_o),.digit_o(digit_o),.swt(swt_i));
    
    decoder2_4 dec (.sct_i(mode_o),.en_o(en));
    
    clock_12_24 ck (.clk(clk),.clk_1hz(clk_1hz),.reset(reset),.en_i(en),.digit_i(digit_o),.inc_bn_i(ib),.tlve_o(tlve),.milt_o(milt),.AMPM_o(AMPM_o));
    
    stopwatch sw (.clk(clk),.clk_1hz(clk_1hz),.reset(reset),.en(en),.sw1(ib),.sb_i(sb),.tm_o(stw));//Add Stopwatch using en[1]
    
    timer tmr (.clk(clk),.clk_1hz(clk_1hz),.reset(reset),.en_i(en),.swt(swt_i),.sb_i(sb),.ib_i(ib),.digit_i(digit_o),.tm_o(tmrs)); //add timer
    
    mux4_1 mx (.clk24(milt),.clk12(tlve),.stw(stw),.tmr(tmrs),.ct_i(mode_o),.t_o(tm_o));
    
endmodule
