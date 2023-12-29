module random(clk, num, num_2);
input clk;
output reg [7:0] num, num_2;

reg [31:0]register, register_2; 
reg [7:0] temp;
always@(posedge clk) begin
    if ((register <= 89)&&(register >= 12)) begin
        register <= register + 32'd1;
    end
    else register <= 32'd12;

    if ((register_2 <= 89)&&(register_2 >= 12)) begin
        register_2 <= register_2 - 32'd1;
    end
    else register_2 <= register;
end

always@(negedge clk) begin
    if (register % 8'd10 == 1) num <=  8'd67;
    else if (register % 8'd10 == 0) num <=  8'd72;
    else num <= register;
    
    if (register_2 % 8'd10 == 1) temp <=  8'd68;
    else if (register_2 % 8'd10 == 0) temp <=  8'd73;
    else temp <= register_2;
end

always@(*) begin
    if (num == temp) num_2 = 32'd101 - num;
    else num_2 = temp;
end
endmodule 