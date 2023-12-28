module random(clk,num);
input clk;
output reg [7:0] num;

reg [31:0]register; 
reg [7:0]temp;

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

endmodule