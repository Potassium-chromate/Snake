module random(clk, num, b);
input clk;


output reg [7:0] num;
output reg [7:0] b;

reg [31:0]register; 
reg [7:0]temp;

reg [31:0]register_2; 
reg [7:0]temp_2;


always@(posedge clk) begin
    register <= register + 32'd1;
    temp <= register % 32'd100;
end

always@(*) begin
    if (temp < 8'd12) num <= 8'd55;
    else if (temp > 8'd89) num <=  8'd33;
    else if (temp % 8'd10 == 1) num <=  8'd67;
    else if (temp % 8'd10 == 0) num <=  8'd72;
	 
	 
    else num <= temp;
end
//random barrier
always@(posedge clk) begin
    register_2 <= register_2 - 32'd1;
    temp_2 <= register_2 % 32'd100;
end

always@(*) begin
    if (temp_2 < 8'd12) b <= 8'd56;
    else if (temp_2 > 8'd89) b <=  8'd34;
    else if (temp_2 % 8'd10 == 1) b <=  8'd68;
    else if (temp_2 % 8'd10 == 0) b <=  8'd73;
    else b <= temp_2;
end

endmodule 