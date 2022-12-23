`timescale 1ns / 1ps

// EC-311 Lab-2 Part-1

module debouncer (
  input clk,
  input reset,
  input btn_i,
  output reg btn_o
);
    integer deb_count=0;
    reg deb_count_start, output_exist;
    integer MAX = 1000000;
    
    always@(posedge clk or negedge reset) begin
        if(!reset) begin
            deb_count <= 0;
            deb_count_start <= 0;
            output_exist <= 0;
        end else begin
            if(btn_i != 1)begin
                deb_count <= 0;
                output_exist <= 0;
            end else begin
                if (output_exist == 0) begin
                    deb_count = deb_count + 1;
                    if(deb_count == MAX)begin
                        btn_o <= 1;
                        deb_count <= 0;
                        output_exist <= 1;
                    end
                end else begin
                    btn_o <= 0;
                end
            end
       end
      // if(btn_i == 0)begin
       //     btn_o = 0;
     //  end
            
    end
endmodule