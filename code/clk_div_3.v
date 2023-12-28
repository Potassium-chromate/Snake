`define TimeExpire 32'd7500000 //(TimeExpire+1)*2

module clk_div_3(clk,div_clk);

input clk;
output reg div_clk;

reg [31:0]count;
always@(posedge clk) begin
        if(count == `TimeExpire)begin
            count <= 32'd0;
            div_clk <= ~div_clk;
        end
        else begin
            count <= count + 32'd1;
        end
end

endmodule

