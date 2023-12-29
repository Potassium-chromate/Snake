module SevenDisplay(num,seven_out);
input [3:0] num;
output reg [6:0] seven_out;


always@(*) begin
case(num)
		1:begin
			seven_out <= 7'b1111001;	
		end
		2:begin
			seven_out <= 7'b0100100;	
		end
        3:begin
			seven_out <= 7'b0110000;	
		end
        4:begin
			seven_out <= 7'b0011001;	
		end
        5:begin
			seven_out <= 7'b0010010;	
		end
        6:begin
			seven_out <= 7'b0000010;	
		end
		7:begin
			seven_out <= 7'b1111000;	
		end
        8:begin
			seven_out <= 7'b0000000;	
		end
		9:begin
			seven_out <= 7'b0010000;	
		end
        10:begin
			seven_out <= 7'b0001000;	
		end
		11:begin
			seven_out <= 7'b0000011;	
		end
        12:begin
			seven_out <= 7'b1000110;	
		end
		13:begin
			seven_out <= 7'b0100001;	
		end
        14:begin
			seven_out <= 7'b0000110;	
		end
		15:begin
			seven_out <= 7'b0001110;	
		end
		default: begin
			seven_out <= 7'b1000000;
		end
	endcase
end
endmodule