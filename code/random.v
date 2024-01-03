module random(clk_25M, clk_1, clk_2, num_1, num_2, new_rnd,apple_grid, barrier_grid, head_grid, body_grid);
input wire [100:0] apple_grid, barrier_grid, head_grid, body_grid;
input clk_1,clk_2,clk_25M;
input new_rnd;

output reg [7:0] num_1;
output reg [7:0] num_2;

reg [31:0]register_1;
reg [31:0]register_2;

reg [31:0]temp_1;
reg [31:0]temp_2;

reg get_rnd_1;
reg get_rnd_2;

//1~8
//11~18

//random apple

always@(posedge clk_25M) begin
	 
	 if(register_1 >= 31'd9999999) begin
	     register_1 <= register_1-31'd9999999;
	 end
	 else begin
	 	  register_1 <= register_1+31'd103;
	 end
	 if(register_2 >= 31'd999999) begin
	     register_2 <= register_2-31'd999999;
	 end
	 else begin
	 	  register_2 <= register_2+31'd659;
	 end
	 
	 if(clk_2) begin		//reset
		  get_rnd_1 <= 1'b0;
		  get_rnd_2 <= 1'b0;
    end
	 else begin
	     get_rnd_1 <= get_rnd_1;
		  get_rnd_2 <= get_rnd_2;
	 end
	 
	 if(~clk_2) begin		   //set
 	     if(~get_rnd_1) begin
 			   temp_1 <= ((register_1%17)%8+1)*10+(register_1%8+2);
			   if((~barrier_grid[temp_1]) && (~head_grid[temp_1]) && (~body_grid[temp_1])) begin
				 	 num_1 <= temp_1;
				 	 get_rnd_1 <= 1'b1;
			   end
			   else begin
				  	 register_1 <= register_1+31'd15;
			   end
		  end
		  else begin
		      num_1 <= num_1;
		  end
		  if(~get_rnd_2) begin
			   temp_2 <= ((register_2%17%8)%8+1)*10+(register_2%8+2);
			   if((~apple_grid[temp_2]) && (~head_grid[temp_2]) && (~body_grid[temp_2])) begin
					 num_2 <= temp_2;
					 get_rnd_2 <= 1'b1;
			   end
			   else begin
				  	 register_2 <= register_2+31'd15;
			   end
		  end
		  else begin
		      num_2 <= num_2;
		  end
	 end
end

endmodule 