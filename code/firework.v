module firework(clk, rst, score_flag,dead_flag, win_flag, col_1, col_2, row);
input clk,rst;
input score_flag;
input dead_flag;
input win_flag;

output reg [7:0] col_1,col_2;
output reg [7:0] row;
reg [2:0] row_cnt;

always@(posedge clk or negedge rst)
begin
	if(~rst)
	begin
		row <= 8'b0;
		col_1 <= 8'b0;
		col_2 <= 8'b0;
		row_cnt <= 0;
	end
	else if(score_flag)
	begin
		if(row_cnt == 3'b111) row_cnt <= 0;
		else row_cnt <= row_cnt + 1;
		case(row_cnt)
			3'd0: row <= 8'b01111111;
			3'd1: row <= 8'b10111111;
			3'd2: row <= 8'b11011111;
			3'd3: row <= 8'b11101111;
			3'd4: row <= 8'b11110111;
			3'd5: row <= 8'b11111011;
			3'd6: row <= 8'b11111101;
			3'd7: row <= 8'b11111110;
		endcase
		case(row_cnt)
			3'd0: col_1 <= 8'b00000000;
			3'd1: col_1 <= 8'b00000000;
			3'd2: col_1 <= 8'b01000010;
			3'd3: col_1 <= 8'b10100101;
			3'd4: col_1 <= 8'b00000000;
			3'd5: col_1 <= 8'b00100100;
			3'd6: col_1 <= 8'b00011000;
			3'd7: col_1 <= 8'b00000000;
		endcase
		
		case(row_cnt)
			3'd0: col_2 <= 8'b00000000;
			3'd1: col_2 <= 8'b01100110;
			3'd2: col_2 <= 8'b10011001;
			3'd3: col_2 <= 8'b11000011;
			3'd4: col_2 <= 8'b01100110;
			3'd5: col_2 <= 8'b01101100;
			3'd6: col_2 <= 8'b00011000;
			3'd7: col_2 <= 8'b00000000;
		endcase
		
	end
	else if(dead_flag)
	begin
		if(row_cnt == 3'b111) row_cnt <= 0;
		else row_cnt <= row_cnt + 1;
		case(row_cnt)
			3'd0: row <= 8'b01111111;
			3'd1: row <= 8'b10111111;
			3'd2: row <= 8'b11011111;
			3'd3: row <= 8'b11101111;
			3'd4: row <= 8'b11110111;
			3'd5: row <= 8'b11111011;
			3'd6: row <= 8'b11111101;
			3'd7: row <= 8'b11111110;
		endcase
		case(row_cnt)
			3'd0: col_1 <= 8'b00000000;
			3'd1: col_1 <= 8'b10000001;
			3'd2: col_1 <= 8'b01000010;
			3'd3: col_1 <= 8'b01100110;
			3'd4: col_1 <= 8'b00000000;
			3'd5: col_1 <= 8'b00000000;
			3'd6: col_1 <= 8'b00011000;
			3'd7: col_1 <= 8'b00100100;
		endcase
		case(row_cnt)
			3'd0: col_2 <= 8'b11000011;
			3'd1: col_2 <= 8'b01100110;
			3'd2: col_2 <= 8'b00111100;
			3'd3: col_2 <= 8'b00011000;
			3'd4: col_2 <= 8'b00111100;
			3'd5: col_2 <= 8'b01100110;
			3'd6: col_2 <= 8'b11000011;
			3'd7: col_2 <= 8'b00000000;
		endcase
	end
	
	else if(win_flag)
	begin
		if(row_cnt == 3'b111) row_cnt <= 0;
		else row_cnt <= row_cnt + 1;
		case(row_cnt)
			3'd0: row <= 8'b01111111;
			3'd1: row <= 8'b10111111;
			3'd2: row <= 8'b11011111;
			3'd3: row <= 8'b11101111;
			3'd4: row <= 8'b11110111;
			3'd5: row <= 8'b11111011;
			3'd6: row <= 8'b11111101;
			3'd7: row <= 8'b11111110;
		endcase
		case(row_cnt)
			3'd0: col_1 <= 8'b00000000;
			3'd1: col_1 <= 8'b00000000;
			3'd2: col_1 <= 8'b10000001;
			3'd3: col_1 <= 8'b10011001;
			3'd4: col_1 <= 8'b01011010;
			3'd5: col_1 <= 8'b01011010;
			3'd6: col_1 <= 8'b00100100;
			3'd7: col_1 <= 8'b00000000;
		endcase
		
		case(row_cnt)
			3'd0: col_2 <= 8'b00000000;
			3'd1: col_2 <= 8'b01000000;
			3'd2: col_2 <= 8'b00001110;
			3'd3: col_2 <= 8'b01010001;
			3'd4: col_2 <= 8'b01010001;
			3'd5: col_2 <= 8'b01010001;
			3'd6: col_2 <= 8'b01010001;
			3'd7: col_2 <= 8'b00000000;
		endcase
		
	end
	
	
	else
	begin
		row <= 8'b0;
		col_1 <= 8'b0;
		col_2 <= 8'b0;
		row_cnt <= 0;
	end
end
endmodule 