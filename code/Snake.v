module Snake(clk, rst, up, right, left, down, snake, apple, score, random_num);
input clk, rst, up, right, left, down; 
input [7:0] random_num; //use random number to renew apple
output reg [9*8-1:0] snake; //index(0~8) * body(0~7) length
output reg [7:0] apple;
output reg [3:0] score;

reg [7:0] temp_head, pre_move;  
reg down_flag, up_flag, right_flag, left_flag, dead_flag, score_flag, rst_flag;
reg up_t, right_t, left_t, down_t;
reg [2:0] curr_state, next_state;
reg [9:0] col_count;



integer i;

//stage
parameter head_renew = 3'b000;  
parameter check = 3'b001;
parameter move = 3'b010;
parameter check_body = 3'b011;  
parameter reset = 3'b100;  

// state reg
always@(negedge clk or negedge rst) begin
    if(~rst) curr_state <= reset;
    else curr_state <= next_state;
end

// next state logic    
always@(*) begin
   case (curr_state)
        reset:  begin
            if(~rst) next_state <= reset;
            else next_state <= head_renew;
        end
        
        head_renew: begin
            if(~rst) next_state <= reset;
            else next_state <= check;     
        end

        check: begin
            if(~rst) next_state <= reset;
            else if(dead_flag) next_state <= reset;
            else next_state <= move;     
        end

        move: begin
            if(~rst) next_state <= reset;
            else next_state <= check_body;     
        end

        check_body: begin
            if(~rst) next_state <= reset;
            else if(dead_flag) next_state <= reset;
            else next_state <= head_renew;     
        end
   endcase
	
end

always@(posedge clk) begin 
	case(curr_state)
	head_renew: begin 
		temp_head <= snake[71:64];//snake[71:64] is the head of snake
		if(up_flag) begin
		//use pre_move to store the loction of head in the future
		pre_move <= snake[71:64] - 8'd10; 
		end
		else if (down_flag) begin
		    pre_move <= snake[71:64] + 8'd10;
		end
		else if (left_flag) begin
		    pre_move <= snake[71:64] - 8'd1;
		end
		else if (right_flag) begin
		    pre_move <= snake[71:64] + 8'd1;
		end
		else pre_move <= snake[71:64];
		rst_flag <= 1'b0;
		end      

        check: begin
		//check if went out of bounds or ate apple
                if (pre_move < 8'd12) dead_flag <= 1'b1;
                else if (pre_move > 8'd89) dead_flag <= 1'b1;
                else if (pre_move % 8'd10 == 1) dead_flag <= 1'b1;
                else if (pre_move % 8'd10 == 0) dead_flag <= 1'b1;
                else if (pre_move == apple) score_flag <= 1'b1;                  
                else begin 
                    score_flag <= 1'b0;
                    dead_flag <= 1'b0;
                    end
                end

        move: begin // move the body
                if (~score_flag) begin // not need to growth
                    if (snake[7:0] != 8'd0) snake[7:0] <= snake[15:8];
                    else snake[7:0] <= 8'd0;
                    if (snake[15:8] != 8'd0) snake[15:8] <= snake[23:16];
                    else snake[15:8] <= 8'd0;
                    if (snake[23:16] != 8'd0) snake[23:16] <= snake[31:24];
                    else snake[23:16] <= 8'd0;
                    if (snake[31:24] != 8'd0) snake[31:24] <= snake[39:32];
                    else snake[39:32] <= 8'd0;
                    if (snake[39:32] != 8'd0) snake[39:32] <= snake[47:40];
                    else snake[39:32] <= 8'd0;
                    if (snake[47:40] != 8'd0) snake[47:40] <= snake[55:48];
                    else snake[47:40] <= 8'd0;
                    if (snake[55:48] != 8'd0) snake[55:48] <= snake[63:56];
                    else snake[55:48] <= 8'd0;
                    if (snake[63:56] != 8'd0) snake[63:56] <= temp_head;
                    else snake[63:56] <= 8'd0;
                end
                else begin // need to growth
                    snake[7:0] <= snake[15:8];
                    snake[15:8] <= snake[23:16];
                    snake[23:16] <= snake[31:24];
                    snake[31:24] <= snake[39:32];
                    snake[39:32] <= snake[47:40];
                    snake[47:40] <= snake[55:48];
                    snake[55:48] <= snake[63:56];
                    snake[63:56] <= temp_head;
                end
                snake[71:64] <= pre_move;

                //if apple was ate, then reset the location of apple
                if(score_flag) begin
                    apple <= random_num;
                    score <= score + 4'b0001;
                end
                else begin
                    apple <= apple;
                    score <= score;
                end
            end

        check_body: begin //check if it bite it self
            if (snake[71:64] == snake[63:56]) dead_flag <= 1'b1;
            else if (snake[71:64] == snake[55:48]) dead_flag <= 1'b1;
            else if (snake[71:64] == snake[47:40]) dead_flag <= 1'b1;
            else if (snake[71:64] == snake[39:32]) dead_flag <= 1'b1;
            else if (snake[71:64] == snake[31:24]) dead_flag <= 1'b1;
            else if (snake[71:64] == snake[23:16]) dead_flag <= 1'b1;
            else if (snake[71:64] == snake[15:8]) dead_flag <= 1'b1;
            else if (snake[71:64] == snake[7:0]) dead_flag <= 1'b1;
            else dead_flag <= 1'b0;
        end

        reset: begin 	
		snake[71:64] <= 8'd12; // set as upper left corner of the grid
                score_flag <= 1'b0;
                apple <= random_num;
                score <= 4'b0000;
                rst_flag <= 1'b1;
                for ( i = 0; i < 64; i = i +1) begin
                    snake[i] <= 0;
                end
                end 

        default :   begin
                    snake[71:64] <= 8'd12;
                    score_flag <= 1'b0;
                    apple <= random_num;
                    rst_flag <= 1'b1;
                    for ( i = 0; i < 64; i = i +1) begin
                        snake[i] <= 0;
                    end
                    end    
	endcase
end

always@(negedge up_t or negedge down_t or negedge left_t or negedge right_t or negedge rst or posedge rst_flag) begin
	if ((~rst) || (rst_flag)) begin // if reset was press or game was over
        up_flag <= 1'b0;
        down_flag <= 1'b0;
        right_flag <= 1'b0;
        left_flag <= 1'b0;
    end
    else if (~up_t) begin
        up_flag <= 1'b1;
        down_flag <= 1'b0;
        right_flag <= 1'b0;
        left_flag <= 1'b0;
    end
    else if (~down_t) begin
        up_flag <= 1'b0;
        down_flag <= 1'b1;
        right_flag <= 1'b0;
        left_flag <= 1'b0;
    end
    else if (~left_t) begin
        up_flag <= 1'b0;
        down_flag <= 1'b0;
        right_flag <= 1'b0;
        left_flag <= 1'b1;
    end
    else if (~right_t) begin
        up_flag <= 1'b0;
        down_flag <= 1'b0;
        right_flag <= 1'b1;
        left_flag <= 1'b0;
    end
    else  begin
        up_flag <= up_flag;
        down_flag <= down_flag;
        right_flag <= right_flag;
        left_flag <= left_flag;
    end
end

always@(*) begin
    //if down was press previously, then u can't press up.
    up_t = up | down_flag;
    down_t = down | up_flag;
    left_t = left | right_flag;
    right_t = right | left_flag;
end

endmodule
