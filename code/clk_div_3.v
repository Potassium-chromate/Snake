`define TimeConst 7'd25
`define TimeExpire `TimeConst*32'd10000000 //(TimeExpire+1)*2

module clk_div_3(clk,div_clk,div_clk_2,score);
input clk;
input wire [3:0]score;
output reg div_clk;
output reg div_clk_2;

reg [31:0]count;
reg [31:0]count_2=`TimeConst-10000;

always@(posedge clk) begin
        if(count >= `TimeExpire)begin
            count <= 32'd0;
            div_clk <= ~div_clk;
        end
        else begin
            count <= count + (`TimeConst+score)*32'd1;	//TimeExpire/(1+snakelen/TimeConst)
        end
		  
        if(count_2 >= `TimeExpire)begin
            count_2 <= 32'd0;
            div_clk_2 <= ~div_clk_2;
        end
        else begin
            count_2 <= count_2 + (`TimeConst+score)*32'd1;	//TimeExpire/(1+snakelen/TimeConst)
        end
end

endmodule

