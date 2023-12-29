`include "clk_div_3.v" //3.3HZ
`include "clk_div_25M.v" //25MHZ
`include "vga_main.v"
`include "vga_aux.v"
`include "SevenDisplay.v"
`include "random.v"
`include "firework.v"
module Main(clk, rst, up, right, left, down, red, green, blue, H_sync, V_sync, seven_out, row, col_1, col_2);
input clk, rst, up, right, left, down; 
output wire [3:0] red, green, blue;
output wire H_sync, V_sync;
output wire [6:0] seven_out;
output wire [7:0] col_1, col_2, row;

wire [9*8-1:0] snake;
wire [7:0] apple, barrier, random_num, random_num_2;
wire clk_25M, clk_3, clk_line ,clk_1M;
wire [9:0] row_count;
wire [3:0] score;
wire dead_flag, score_flag, win_flag;

clk_div_25M(.clk(clk),.div_clk(clk_25M));
clk_div_3(.clk(clk),.div_clk(clk_3));
random(.clk(clk_25M),.num(random_num), .num_2(random_num_2));

Snake(.clk(clk_3), .rst(rst), .up(up), .right(right), .left(left), .down(down), 
        .snake(snake), .apple(apple),.barrier(barrier), .score(score), .win_flag(win_flag),.dead_flag(dead_flag),
		  .score_flag(score_flag), .random_num(random_num), .random_num_2(random_num_2));

vga_main(.clk(clk_line), .rst(rst), .V_sync(V_sync), .row_count(row_count));
vga_aux(.clk(clk_25M), .rst(rst), .H_sync(H_sync), .snake(snake), .apple(apple), .barrier(barrier),
        .red_out(red), .green_out(green), .blue_out(blue), .work_clk(clk_line), .row_count(row_count));
SevenDisplay(.num(score),.seven_out(seven_out)); 
firework(.clk(clk_line), .rst(rst), .score_flag(score_flag), .dead_flag(dead_flag),.win_flag(win_flag), .col_1(col_1), .col_2(col_2), .row(row));
       
endmodule 