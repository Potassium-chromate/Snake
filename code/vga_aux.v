//output the H_sync and RGB value
module vga_aux(clk, rst, H_sync, snake, apple, red_out, green_out, blue_out, work_clk, row_count);
input clk,rst;
input [9*8-1:0] snake;
input [9:0] row_count;
input [7:0] apple;
output reg H_sync,work_clk;
output reg [3:0] red_out, green_out, blue_out;

integer i;
reg [7:0] c_idx, r_idx;
reg [9:0] col_count;
reg [100:0] apple_grid, head_grid, body_grid;
// one grid is 42*42 pixels

always@(posedge clk or negedge rst) begin 
        if (~rst) col_count <= 10'd1;
        else begin
            if ((col_count > 0)&&(col_count <= 96)) begin//h sync 96 pix
                H_sync <= 1'b0;
                red_out <= 4'b0000;
                green_out <= 4'b0000;
                blue_out <= 4'b0000;
                col_count <= col_count + 10'd1;
            end

            else if ((col_count > 96)&&(col_count <= 144)) begin //h back porch 48 pix
                H_sync <= 1'b1;
                col_count <= col_count + 10'd1;
            end

            else if ((col_count > 144)&&(col_count <= 784)) begin //h display 640 pix (145~784)
                if ((row_count > 30)&&(row_count <= 72))begin //upper bound 31~72 (42 lines)                  
                    if ((col_count > 254)&&(col_count <= 674)) begin //255~674 (420 pixels)
                        red_out <= 4'b1111;
                        green_out <= 4'b1111;
                        blue_out <= 4'b0000;
                    end
                    else begin //145~254 and 675~784 (110 + 110 pixels)
                        red_out <= 4'b0000;
                        green_out <= 4'b0000;
                        blue_out <= 4'b0000;
                    end
                end
                else if ((row_count > 72)&&(row_count <= 408))begin //side bound 73~408 (336 lines)
                    //255~296 and 633~674 (42 + 42 pixels)
                    if (((col_count > 254)&&(col_count <= 296))||((col_count > 632)&&(col_count <= 674))) begin 
                        red_out <= 4'b1111;
                        green_out <= 4'b1111;
                        blue_out <= 4'b0000;
                    end
                    else if ((col_count > 296)&&(col_count <= 632)) begin //297~632 (336 pixels)
                        if(head_grid[10*r_idx + c_idx]) begin
                            //head colar is green    
                            red_out <= 4'b0000;
                            green_out <= 4'b1111;
                            blue_out <= 4'b0000;
                        end
                        else if(body_grid[10*r_idx + c_idx]) begin
                            //body colar is white    
                            red_out <= 4'b1111;
                            green_out <= 4'b1111;
                            blue_out <= 4'b1111;
                        end
                        else if(apple_grid[10*r_idx + c_idx]) begin
                            //apple colar is red    
                            red_out <= 4'b1111;
                            green_out <= 4'b0000;
                            blue_out <= 4'b0000;
                        end
                        else begin
                            red_out <= 4'b0000;
                            green_out <= 4'b0000;
                            blue_out <= 4'b0000;
                        end

                    end
                    else begin //145~254 and 675~784 (220 pixels)
                        red_out <= 4'b0000;
                        green_out <= 4'b0000;
                        blue_out <= 4'b0000;
                    end
                end
                else if ((row_count > 408)&&(row_count <= 450))begin //lower bound 409~450 (42 lines)                  
                    if ((col_count > 254)&&(col_count <= 674)) begin //255~674 (420 pixels)
                        red_out <= 4'b1111;
                        green_out <= 4'b1111;
                        blue_out <= 4'b0000;
                    end
                    else begin //145~254 and 675~784 (110 + 110 pixels)
                        red_out <= 4'b0000;
                        green_out <= 4'b0000;
                        blue_out <= 4'b0000;
                    end
                end
                else begin
                    red_out <= 4'b0000;
                    green_out <= 4'b0000;
                    blue_out <= 4'b0000;
                end

                col_count <= col_count + 10'd1;
            end

            else if ((col_count > 784)&&(col_count <= 799)) begin //h front porch 16 pix
                red_out <= 4'b0000;
                green_out <= 4'b0000;
                blue_out <= 4'b0000;
                col_count <= col_count + 10'd1;
            end

            else col_count <= 10'd1;
        end

end

always@(posedge clk) begin
   //output a complete clock in 800 pixels
   if (col_count == 10'd1) work_clk <= ~work_clk;
   else if (col_count == 10'd400) work_clk<= ~work_clk;
   else work_clk <= work_clk;
end

// mapping head, body and apple into grid
always@(*) begin
    if (col_count != 10'd1) begin
        head_grid[snake[71:64]] = 1'b1;
        body_grid[snake[63:56]] = 1'b1;
        body_grid[snake[55:48]] = 1'b1;
        body_grid[snake[47:40]] = 1'b1;
        body_grid[snake[39:32]] = 1'b1;
        body_grid[snake[31:24]] = 1'b1;
        body_grid[snake[23:16]] = 1'b1;
        body_grid[snake[15:8]] = 1'b1;
        body_grid[snake[7:0]] = 1'b1;
        apple_grid[apple] = 1'b1;
    end
    else begin //when a line start, clear the grid
        for ( i = 0; i < 101; i = i +1) begin
                    head_grid[i] = 1'b0;
                    body_grid[i] = 1'b0;
                    apple_grid[i] = 1'b0;
        end
    end
end


// find column index base on col_count
always@(*) begin
    //first column, index = 12,22,32...
    if ((col_count > 296)&&(col_count <= 338)) c_idx = 8'd2;
    //second column, index = 13,23,33...
    else if ((col_count > 338)&&(col_count <= 380)) c_idx = 8'd3;
    //third column, index = 14,24,34...
    else if ((col_count > 380)&&(col_count <= 422)) c_idx = 8'd4;
    //4th column 
    else if ((col_count > 422)&&(col_count <= 464)) c_idx = 8'd5;
    //5th column 
    else if ((col_count > 464)&&(col_count <= 506)) c_idx = 8'd6;
    //6th column 
    else if ((col_count > 506)&&(col_count <= 548)) c_idx = 8'd7;   
    //7th column 
    else if ((col_count > 548)&&(col_count <= 590)) c_idx = 8'd8; 
    //8th column 
    else if ((col_count > 590)&&(col_count <= 632)) c_idx = 8'd9;
    else c_idx = 8'd0; 
end

// find column index base on row_count
always@(*) begin
    //first row, index = 12,13,14...
    if ((row_count > 72)&&(row_count <= 114)) r_idx = 8'd1;
    //second row, index = 22,23,24...
    else if ((row_count > 114)&&(row_count <= 156)) r_idx = 8'd2;
    //third row index = 32,33,34...
    else if ((row_count > 156)&&(row_count <= 198)) r_idx = 8'd3;
    //4th row 
    else if ((row_count > 198)&&(row_count <= 240)) r_idx = 8'd4;
    //5th row 
    else if ((row_count > 240)&&(row_count <= 282)) r_idx = 8'd5;
    //6th row 
    else if ((row_count > 282)&&(row_count <= 324)) r_idx = 8'd6;   
    //7th row 
    else if ((row_count > 324)&&(row_count <= 366)) r_idx = 8'd7; 
    //8th row 
    else if ((row_count > 366)&&(row_count <= 408)) r_idx = 8'd8;
    else r_idx = 8'd0;
end

endmodule
