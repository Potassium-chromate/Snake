module vga_main(clk, rst, V_sync, row_count);
input clk,rst;

output reg V_sync;
output reg [9:0] row_count;

reg [9:0]count;

always@(posedge clk or negedge rst) begin
    if (~rst) begin
        count <= 10'd1;
        row_count <= 10'd0;
    end
    else begin
        if((count > 0) && (count <= 515)) begin
		      count <= count + 10'd1;
		  end
		  else begin
		      count <= 10'd1;
		  end
		  
        if ((count > 0)&&(count <= 2)) begin //V sync 2 lines
            V_sync <= 1'b0;
            row_count <= 10'd0;
        end
        else if ((count > 2)&&(count <=35)) begin//V back porch 33 lines
            V_sync <= 1'b1;
        end
        else begin // 36~515 V display 408 lines
            row_count <= row_count + 10'd1;
        end
    end
end


endmodule