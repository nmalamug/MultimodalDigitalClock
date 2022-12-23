`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2020 12:29:25 PM
// Design Name: 
// Module Name: top_square
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
//////////////////////////////////////////////////////////////////////////////
module top_square(
    input wire CLK,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire RST_BTN,
    input wire shft_bn_i, //Shift select
    input wire inc_bn_i, //Increment select
    input wire mode_bn_i, //mode switch
    input wire swt_i, //Pause,Unpause stopwatch and timer   
    output wire VGA_HS_O,       // horizontal sync output
    output wire VGA_VS_O,       // vertical sync output
    output wire [3:0] VGA_R,    // 4-bit VGA red output
    output wire [3:0] VGA_G,    // 4-bit VGA green output
    output wire [3:0] VGA_B     // 4-bit VGA blue output
    );
    
    wire rst = ~RST_BTN;    // reset is active low on Arty & Nexys Video
    

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge CLK)
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511

    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_HS_O), 
        .o_vs(VGA_VS_O), 
        .o_x(x), 
        .o_y(y)
    );
    
    wire [23:0] time_o; //Current time value for sw,t,clk
    wire [2:0] mode; //WHAT mode WE ARE ON
    wire [2:0] digit_o;//What digit we are currently selecting
    wire XM; //Am OR Pm
    
    top_clock clock(
    .clk(CLK),
    .reset(RST_BTN),
    .shft_bn_i(shft_bn_i),
    .inc_bn_i(inc_bn_i),
    .mode_bn_i(mode_bn_i),
    .swt_i(swt_i),
    .tm_o(time_o),
    .AMPM_o(XM),
    .digit_o(digit_o),
    .mode_o(mode)
    );


    // Wires to hold regions on FPGA
    wire SQ0;
	wire hd1A, hd1B, hd1C, hd1D, hd1E, hd1F, hd1G; 
	wire hd2A, hd2B, hd2C, hd2D, hd2E, hd2F, hd2G; 
	wire md1A, md1B, md1C, md1D, md1E, md1F, md1G;
	wire md2A, md2B, md2C, md2D, md2E, md2F, md2G;
	wire sd1A, sd1B, sd1C, sd1D, sd1E, sd1F, sd1G;
    wire sd2A, sd2B, sd2C, sd2D, sd2E, sd2F, sd2G;//Registers for entities
    wire xm1A, xm1B, xm1C, xm1D, xm1E, xm1F, xm1G, xm1H, xm1I; //AM PM, this displays P or A
    wire xm2A, xm2B, xm2C, xm2D, xm2E, xm2F, xm2G, xm2H, xm2I; // AM PM this displays M. 
    wire dots1top, dots1bot, dots2top, dots2bot;
	reg green,red;
	
	// Creating Regions on the VGA Display represented as wires (640x480)
	
 //These parameters replace the minimum and maximum values for easier adjustment of the size of the digits. Note that some segments, such as 
 //A and D for example, have the same X values. We could add more parameters to control each segment individually but for now this should work
    parameter xADG_min = 5;
    parameter yA_min = 160;
    parameter xADG_max = 85;
    parameter yA_max = 170;
    
    parameter xBC_min = 75;
    parameter yBF_min = 160;
    parameter xBC_max = 85;
    parameter yBF_max = 241;
    
    parameter yCE_min = 249;
    parameter yCE_max = 330;
    
  
    parameter yD_min = 320;
    parameter yD_max = 330;
    
    parameter xEF_min = 5;
    parameter xEF_max = 15;
    
    parameter yG_min = 240;
    parameter yG_max = 250;
    assign SQ0 = ((x > 0) & (x < 620) & (y > 10) & (y < 460)) ? 1 : 0; //background
    
    
    
    // hour digit 1
    wire [6:0] disphd1;
    seven_segment_decoder H1(.num_i(time_o[23:20]),.resetn_i(RST_BTN),.seven_o(disphd1)); // assign encoding 
    assign hd1A = ((x > xADG_min) & (y > yA_min) & (x < xADG_max) & (y < yA_max)) & ~disphd1[0]? 1 : 0;    // top
    assign hd1B = ((x > xBC_min) & (y > yBF_min) & (x < xBC_max) & (y < yBF_max)) & ~disphd1[1]? 1 : 0;   // top right
    assign hd1C = ((x > xBC_min) & (y > yCE_min) & (x < xBC_max) & (y < yCE_max)) & ~disphd1[2]? 1 : 0;   // bottom right
    assign hd1D = ((x > xADG_min) & (y > yD_min) & (x < xADG_max) & (y < yD_max)) & ~disphd1[3]? 1 : 0;    // bottom
    assign hd1E = ((x > xEF_min) & (y > yCE_min) & (x < xEF_max) & (y < yCE_max)) & ~disphd1[4]? 1 : 0;      // bottom left
    assign hd1F = ((x > xEF_min) & (y > yBF_min) & (x < xEF_max) & (y < yBF_max)) & ~disphd1[5]? 1 : 0;      // top left 
    assign hd1G = ((x > xADG_min) & (y > yG_min) & (x < xADG_max) & (y < yG_max)) & ~disphd1[6]? 1 : 0;    // middle
    
    //hour digit 2
    parameter offset1 = 95;
    wire [6:0] disphd2;
    seven_segment_decoder H2(.num_i(time_o[19:16]),.resetn_i(RST_BTN),.seven_o(disphd2)); 
    assign hd2A = ((x > xADG_min+offset1) & (y > yA_min) & (x < xADG_max+offset1) & (y < yA_max)) & ~disphd2[0]? 1 : 0;     // top
    assign hd2B = ((x > xBC_min+offset1) & (y > yBF_min) & (x < xBC_max+offset1) & (y < yBF_max)) & ~disphd2[1]? 1 : 0;     // top right
    assign hd2C = ((x > xBC_min+offset1) & (y > yCE_min) & (x < xBC_max+offset1) & (y < yCE_max)) & ~disphd2[2]? 1 : 0;     // bottom right
    assign hd2D = ((x > xADG_min+offset1) & (y > yD_min) & (x < xADG_max+offset1) & (y < yD_max)) & ~disphd2[3]? 1 : 0;     // bottom
    assign hd2E = ((x > xEF_min+offset1) & (y > yCE_min) & (x < xEF_max+offset1) & (y < yCE_max)) & ~disphd2[4]? 1 : 0;     // bottom left
    assign hd2F = ((x > xEF_min+offset1) & (y > yBF_min) & (x < xEF_max+offset1) & (y < yBF_max)) & ~disphd2[5]? 1 : 0;     // top left 
    assign hd2G = ((x > xADG_min+offset1) & (y > yG_min) & (x < xADG_max+offset1) & (y < yG_max)) & ~disphd2[6]? 1 : 0;     // middle
    
    //minute digit 1
    parameter offset2 = 215;
    wire [6:0] dispmd1;                                                               
    seven_segment_decoder M1(.num_i(time_o[15:12]),.resetn_i(RST_BTN),.seven_o(dispmd1));
    assign md1A = ((x > xADG_min+offset2) & (y > yA_min) & (x < xADG_max+offset2) & (y < yA_max)) & ~dispmd1[0]? 1 : 0;     // top
    assign md1B = ((x > xBC_min+offset2) & (y > yBF_min) & (x < xBC_max+offset2) & (y < yBF_max)) & ~dispmd1[1]? 1 : 0;     // top right
    assign md1C = ((x > xBC_min+offset2) & (y > yCE_min) & (x < xBC_max+offset2) & (y < yCE_max)) & ~dispmd1[2]? 1 : 0;     // bottom right
    assign md1D = ((x > xADG_min+offset2) & (y > yD_min) & (x < xADG_max+offset2) & (y < yD_max)) & ~dispmd1[3]? 1 : 0;     // bottom
    assign md1E = ((x > xEF_min+offset2) & (y > yCE_min) & (x < xEF_max+offset2) & (y < yCE_max)) & ~dispmd1[4]? 1 : 0;     // bottom left
    assign md1F = ((x > xEF_min+offset2) & (y > yBF_min) & (x < xEF_max+offset2) & (y < yBF_max)) & ~dispmd1[5]? 1 : 0;     // top left 
    assign md1G = ((x > xADG_min+offset2) & (y > yG_min) & (x < xADG_max+offset2) & (y < yG_max)) & ~dispmd1[6]? 1 : 0;     // middle
    
    
     //minute digit 2
    parameter offset3 = 310;
    wire [6:0] dispmd2;                                                               
    seven_segment_decoder M2(.num_i(time_o[11:8]),.resetn_i(RST_BTN),.seven_o(dispmd2));
    assign md2A = ((x > xADG_min+offset3) & (y > yA_min) & (x < xADG_max+offset3) & (y < yA_max)) & ~dispmd2[0]? 1 : 0;    // top
    assign md2B = ((x > xBC_min+offset3) & (y > yBF_min) & (x < xBC_max+offset3) & (y < yBF_max)) & ~dispmd2[1]? 1 : 0;    // top right
    assign md2C = ((x > xBC_min+offset3) & (y > yCE_min) & (x < xBC_max+offset3) & (y < yCE_max)) & ~dispmd2[2]? 1 : 0;    // bottom right
    assign md2D = ((x > xADG_min+offset3) & (y > yD_min) & (x < xADG_max+offset3) & (y < yD_max)) & ~dispmd2[3]? 1 : 0;    // bottom
    assign md2E = ((x > xEF_min+offset3) & (y > yCE_min) & (x < xEF_max+offset3) & (y < yCE_max)) & ~dispmd2[4]? 1 : 0;    // bottom left
    assign md2F = ((x > xEF_min+offset3) & (y > yBF_min) & (x < xEF_max+offset3) & (y < yBF_max)) & ~dispmd2[5]? 1 : 0;    // top left 
    assign md2G = ((x > xADG_min+offset3) & (y > yG_min) & (x < xADG_max+offset3) & (y < yG_max)) & ~dispmd2[6]? 1 : 0;    // middle
    
    //Seconds digit 1
    parameter offset4 = 430;
    wire [6:0] dispsd1;                                                               
    seven_segment_decoder S1(.num_i(time_o[7:4]),.resetn_i(RST_BTN),.seven_o(dispsd1));
    assign sd1A = ((x > xADG_min+offset4) & (y > yA_min) & (x < xADG_max+offset4) & (y < yA_max)) & ~dispsd1[0]? 1 : 0;    // top
    assign sd1B = ((x > xBC_min+offset4) & (y > yBF_min) & (x < xBC_max+offset4) & (y < yBF_max)) & ~dispsd1[1]? 1 : 0;    // top right
    assign sd1C = ((x > xBC_min+offset4) & (y > yCE_min) & (x < xBC_max+offset4) & (y < yCE_max)) & ~dispsd1[2]? 1 : 0;    // bottom right
    assign sd1D = ((x > xADG_min+offset4) & (y > yD_min) & (x < xADG_max+offset4) & (y < yD_max)) & ~dispsd1[3]? 1 : 0;    // bottom
    assign sd1E = ((x > xEF_min+offset4) & (y > yCE_min) & (x < xEF_max+offset4) & (y < yCE_max)) & ~dispsd1[4]? 1 : 0;    // bottom left
    assign sd1F = ((x > xEF_min+offset4) & (y > yBF_min) & (x < xEF_max+offset4) & (y < yBF_max)) & ~dispsd1[5]? 1 : 0;    // top left 
    assign sd1G = ((x > xADG_min+offset4) & (y > yG_min) & (x < xADG_max+offset4) & (y < yG_max)) & ~dispsd1[6]? 1 : 0;    // middle
    
        //Seconds digit 2
    parameter offset5 = 525;
    wire [6:0] dispsd2;                                                               
    seven_segment_decoder S2(.num_i(time_o[3:0]),.resetn_i(RST_BTN),.seven_o(dispsd2));
    assign sd2A = ((x > xADG_min+offset5) & (y > yA_min) & (x < xADG_max+offset5) & (y < yA_max)) & ~dispsd2[0]? 1 : 0;     // top
    assign sd2B = ((x > xBC_min+offset5) & (y > yBF_min) & (x < xBC_max+offset5) & (y < yBF_max)) & ~dispsd2[1]? 1 : 0;     // top right
    assign sd2C = ((x > xBC_min+offset5) & (y > yCE_min) & (x < xBC_max+offset5) & (y < yCE_max)) & ~dispsd2[2]? 1 : 0;     // bottom right
    assign sd2D = ((x > xADG_min+offset5) & (y > yD_min) & (x < xADG_max+offset5) & (y < yD_max)) & ~dispsd2[3]? 1 : 0;     // bottom
    assign sd2E = ((x > xEF_min+offset5) & (y > yCE_min) & (x < xEF_max+offset5) & (y < yCE_max)) & ~dispsd2[4]? 1 : 0;     // bottom left
    assign sd2F = ((x > xEF_min+offset5) & (y > yBF_min) & (x < xEF_max+offset5) & (y < yBF_max)) & ~dispsd2[5]? 1 : 0;     // top left 
    assign sd2G = ((x > xADG_min+offset5) & (y > yG_min) & (x < xADG_max+offset5) & (y < yG_max)) & ~dispsd2[6]? 1 : 0;     // middle
    
    //wire xm1A, xm1B, xm1C, xm1D, xm1E, xm1F, xm1G, xm1H, xm1I //AM PM, this displays P or A
    //wire xm2A, xm2B, xm2C, xm2D, xm2E, xm2F, xm2G, xm2H, xm2I; // AM PM this displays M. 
    //XM is the bit for am pm. 0 is AM 1 is PM
    parameter xmoffset = 190;
    assign xm1A = ((x > xADG_min+offset5)& (y > yA_min+xmoffset) & (x < xADG_max-40+offset5-5) & (y < yA_max-5+xmoffset)) ? 1 : 0;     // top         
    assign xm1B = ((x > xBC_min+offset5-40) & (y > yBF_min+xmoffset) & (x < xBC_max-45+offset5) & (y < yBF_max-39+xmoffset)) ? 1 : 0;     // top right   
    assign xm1C = ((x > xBC_min+offset5-40) & (y > yBF_max-39+5+xmoffset) & (x < xBC_max-45+offset5) & (y < yBF_max-39+40+xmoffset)) ? 1 : 0;     // bottom right
    assign xm1D = ((x > xADG_min+offset5)& (y > yBF_max+xmoffset) & (x < xADG_max-40+offset5-5) & (y < yBF_max+xmoffset+5)) ? 1 : 0;     // bottom                                  (       + // bot +
    assign xm1E = ((x > xEF_min+offset5) & (y > yBF_max-39+5+xmoffset) & (x < xEF_max+offset5-5) & (y < yBF_max-39+40+xmoffset)) ? 1 : 0;     // bottom left 
    assign xm1F = ((x > xEF_min+offset5) & (y > yBF_min+xmoffset) & (x < xEF_max+offset5-5) & (y < yBF_max-39+xmoffset)) ? 1 : 0;     // top left    
    assign xm1G = ((x > xADG_min+offset5)& (y > yBF_max-40+xmoffset) & (x < xADG_max-40+offset5-5) & (y < yBF_max-39+6+xmoffset)) ? 1 : 0;     // middle
    assign xm1H = ((x > xBC_min+offset5-40-15) & (y > yA_min+xmoffset) & (x < xBC_max-45+offset5-15) & (y < yBF_max-39+xmoffset)) ? 1 : 0;     // TOP MID
    assign xm1I = ((x > xBC_min+offset5-40-15) & (y > yBF_max-39+5+xmoffset) & (x < xBC_max-45+offset5-15) & (y < yBF_max-39+40+xmoffset)) ? 1 : 0;     // BOT MID
    
    parameter offset6 = 45;
    assign xm2A = 0;//((x > xADG_min+offset5+offset6)& (y > yA_min+xmoffset) & (x < xADG_max-40+offset5-5+offset6) & (y < yA_max-5+xmoffset)) ? 1 : 0;     // top         
    assign xm2B = 0;//((x > xBC_min+offset5-40+offset6) & (y > yBF_min+xmoffset) & (x < xBC_max-45+offset5+offset6) & (y < yBF_max-39+xmoffset)) ? 1 : 0;     // top right   
    assign xm2C = ((x > xBC_min+offset5-40+offset6) & (y > yBF_max-39+5+xmoffset) & (x < xBC_max-45+offset5+offset6) & (y < yBF_max-39+40+xmoffset)) ? 1 : 0;     // bottom right
    assign xm2D = 0;     // bottom                                  (       + // bot +
    assign xm2E = ((x > xEF_min+offset5+offset6) & (y > yBF_max-39+5+xmoffset) & (x < xEF_max+offset5-5+offset6) & (y <yBF_max-39+40+xmoffset)) ? 1 : 0;     // bottom left 
    assign xm2F = 0;//((x > xEF_min+offset5+offset6) & (y > yBF_min+xmoffset) & (x < xEF_max+offset5-5+offset6) & (y < yBF_max-39+xmoffset)) ? 1 : 0;     // top left    
    assign xm2G = ((x > xADG_min+offset5+offset6)& (y > yBF_max-40+xmoffset) & (x < xADG_max-40+offset5-5+offset6) & (y < yBF_max-39+6+xmoffset)) ? 1 : 0;     // middle
    assign xm2H = 0;     // TOP MID
    assign xm2I = ((x > xBC_min+offset5-40+offset6-15) & (y > yBF_max-39+5+xmoffset) & (x < xBC_max-45+offset5+offset6-15) & (y < yBF_max-39+40+xmoffset)) ? 1 : 0;     // BOT MID          
     
                                                                                                                                             
                                                                                                                                       
    
    
    //separation ::
    
    
    parameter dotsoffsetytopMin = yG_max - 15;                //top of top .
    parameter dotsoffsetytopMax = dotsoffsetytopMin + 5;    //bottom of top .
    parameter dotsoffsetybotMin = yG_max + 10;              //top of bottom .
    parameter dotsoffsetybotMax = dotsoffsetybotMin + 5;    //bottom of bottom .
    
    //1st :
    parameter dots1offsetxMin = xBC_max + offset1 + 15;       // left side of : 1
    parameter dots1offsetxMax = dots1offsetxMin + 5;          // right side of : 1
    
    assign dots1top = ((x > dots1offsetxMin) & (y > dotsoffsetytopMin) & (x < dots1offsetxMax) & (y < dotsoffsetytopMax))? 1 : 0;
    assign dots1bot = ((x > dots1offsetxMin) & (y > dotsoffsetybotMin) & (x < dots1offsetxMax) & (y < dotsoffsetybotMax))? 1 : 0;
    
    //2nd :
    parameter dots2offsetxMin = dots1offsetxMin - offset1 + offset3;    // left side of : 2
    parameter dots2offsetxMax = dots1offsetxMax - offset1 + offset3;    // right side of : 2
    assign dots2top = ((x > dots2offsetxMin) & (y > dotsoffsetytopMin) & (x < dots2offsetxMax) & (y < dotsoffsetytopMax))? 1 : 0;
    assign dots2bot = ((x > dots2offsetxMin) & (y > dotsoffsetybotMin) & (x < dots2offsetxMax) & (y < dotsoffsetybotMax))? 1 : 0;
    
     // Assign the registers to the VGA 3rd output. This will display strong red on the Screen when 
     // red = 1, and strong green on the screen when green = 1;
     assign VGA_R[3] = red;
     assign VGA_G[3] = green;
 


 
 
  
      always @ (*)
      begin 	
        
        red =  SQ0 - hd1A - hd1B - hd1C - hd1D - hd1E - hd1F - hd1G;
        red = red  - hd2A - hd2B - hd2C - hd2D - hd2E - hd2F - hd2G;
        red = red - md1A - md1B - md1C - md1D - md1E - md1F - md1G; 
        red = red - md2A - md2B - md2C - md2D - md2E - md2F - md2G;
        red = red - sd1A - sd1B - sd1C - sd1D - sd1E - sd1F - sd1G; 
        red = red - sd2A - sd2B - sd2C - sd2D - sd2E - sd2F - sd2G;  
        red = red - dots1top - dots1bot - dots2top - dots2bot;
        case(mode)
            2'b00:red = red - xm2A-xm2B-xm2C-xm2D-xm2E-xm2F-xm2G-xm2H-xm2I; //clk 24
            2'b01:begin //clk 12
                red = red - xm1A-xm1B -(xm1C & (XM==0))-xm1E-xm1F-xm1G;                  //A/P
                red = red - xm2A-xm2B-xm2C-xm2D-xm2E-xm2F-xm2G-xm2H-xm2I;   //m
            end
            2'b10:red = red - xm1A - xm1C - xm1D - xm1F - xm1G  ; // sw
            2'b11:red = red - xm1A - xm1H;// timer
         endcase
        
        green = 0;
        if(!(mode == 2'b10)) begin
            case(digit_o)
                3'b000: green = 0;
                3'b001: green = green + sd2A + sd2B + sd2C + sd2D + sd2E + sd2F + sd2G;
                3'b010: green = green + sd1A + sd1B + sd1C + sd1D + sd1E + sd1F + sd1G;
                3'b011: green = green + md2A + md2B + md2C + md2D + md2E + md2F + md2G;
                3'b100: green = green + md1A + md1B + md1C + md1D + md1E + md1F + md1G;
                3'b101: begin green = green + hd2A + hd2B + hd2C + hd2D + hd2E + hd2F + hd2G;
                            if(mode == 2'b00 | mode == 2'b01)begin
                                green = green + hd1A + hd1B + hd1C + hd1D + hd1E + hd1F + hd1G;
                            end
                        end
                3'b110: green = green + hd1A + hd1B + hd1C + hd1D + hd1E + hd1F + hd1G;
             endcase
        end
      end
    
    
endmodule
