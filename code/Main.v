`include "clk_div_3.v" //3.3HZ
`include "clk_div_25M.v" //25MHZ
`include "vga_main.v"
`include "vga_aux.v"
`include "SevenDisplay.v"
`include "random.v"

module Main(clk, rst, up, right, left, down, red, green, blue, H_sync, V_sync, seven_out);
input clk, rst, up, right, left, down; 
output wire [3:0] red, green, blue;
output wire H_sync, V_sync;
output wire [6:0] seven_out;

wire [9*8-1:0] snake;
wire [7:0] apple, random_num;
wire clk_25M, clk_3, clk_line;
wire [9:0] row_count;
wire [3:0] score;


clk_div_25M(.clk(clk),.div_clk(clk_25M));
clk_div_3(.clk(clk),.div_clk(clk_3));
random(.clk(clk_25M),.num(random_num));

Snake(.clk(clk_3), .rst(rst), .up(up), .right(right), .left(left), .down(down), 
        .snake(snake), .apple(apple), .score(score), .random_num(random_num));

vga_main(.clk(clk_line), .rst(rst), .V_sync(V_sync), .row_count(row_count));
vga_aux(.clk(clk_25M), .rst(rst), .H_sync(H_sync), .snake(snake), .apple(apple), 
        .red_out(red), .green_out(green), .blue_out(blue), .work_clk(clk_line), .row_count(row_count));
SevenDisplay(.num(score),.seven_out(seven_out));        
endmodule