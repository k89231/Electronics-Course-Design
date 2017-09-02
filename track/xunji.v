module xunji(clk,left_wheel_PWM_OUT,right_wheel_PWM_OUT,steering_engine_PWM_OUT,left_infrared,right_infrared,mid_right_infrared,mid_left_infrared,tail);

input		clk;
input		right_infrared;
input 	left_infrared; 
input		mid_right_infrared;
input		mid_left_infrared;
input    tail;
/*************************************************************************************************************************/

output reg right_wheel_PWM_OUT;
output reg left_wheel_PWM_OUT;
output reg steering_engine_PWM_OUT;
/**********************************************************************************************************/
reg   [19:0] 	steering_PWM_counter;
reg   [19:0] 	steering_PWM_counter_out;
reg   [9:0]		wheel_PWM_OUT;
reg	[25:0] cnt;
reg   flag;
reg [13:0]start5;
initial
	begin
		start5 <= 0;
		flag=0;
	end
	
	
always @(posedge clk)							//后轮输出控制
begin 
	if(wheel_PWM_OUT <= 10'd5000)
		begin
		wheel_PWM_OUT <= wheel_PWM_OUT + 1'b1;

		if (tail==1'b1)
		begin
		flag = 1;
		if(wheel_PWM_OUT<=10'd30)//20%
				begin
				right_wheel_PWM_OUT <= 1'b1;
				left_wheel_PWM_OUT  <= 1'b0;
				end
		else 
				begin
				right_wheel_PWM_OUT <= 1'b0;
				left_wheel_PWM_OUT  <= 1'b0;
				end
		end
		else if (flag ==1)
		begin
		if(wheel_PWM_OUT<=10'd30)//20%
				begin
				right_wheel_PWM_OUT <= 1'b1;
				left_wheel_PWM_OUT  <= 1'b0;
				end
		else 
				begin
				right_wheel_PWM_OUT <= 1'b0;
				left_wheel_PWM_OUT  <= 1'b0;
				end
		end
		
		else if(left_infrared == 1 && right_infrared == 1 && mid_left_infrared == 1 && mid_right_infrared == 1)
		begin
			start5 <= 0;
			if(wheel_PWM_OUT<=10'd30)//20%
				begin
				right_wheel_PWM_OUT <= 1'b1;
				left_wheel_PWM_OUT  <= 1'b0;
				end
			else 
				begin
				right_wheel_PWM_OUT <= 1'b0;
				left_wheel_PWM_OUT  <= 1'b0;
				end
		end
		
		else
		begin
		start5 <= start5 + 1;
		if(start5 <= 3950)
			begin
			if(wheel_PWM_OUT<=10'd470)//20%
				begin
				right_wheel_PWM_OUT <= 1'b1;
				left_wheel_PWM_OUT  <= 1'b0;
				end
				else 
				begin
				right_wheel_PWM_OUT <=1'b0;
				left_wheel_PWM_OUT  <= 1'b0;
				end
			end
		else
			begin
			if(wheel_PWM_OUT<=10'd50)//20%
				begin
				right_wheel_PWM_OUT <= 1'b1;
				left_wheel_PWM_OUT  <= 1'b0;
				end
			else 
				begin
				right_wheel_PWM_OUT <=1'b0;
				left_wheel_PWM_OUT  <= 1'b0;
				end
			if(start5 == 10000)
				start5 <= 0;
			end
			end
		end
	else 
		wheel_PWM_OUT <= 10'b0;
end



/****************************************************************************************************/
always @(posedge clk)
begin
if(steering_PWM_counter <=20'd100_0000)
	begin
	steering_PWM_counter <= steering_PWM_counter + 1'b1;
	if(left_infrared == 1'b0 && right_infrared == 1'b0 && mid_left_infrared == 1'b0 && mid_right_infrared == 1'b0)
		begin
		steering_PWM_counter_out <= 20'd70000	;	//0°
		if(steering_PWM_counter <= steering_PWM_counter_out)
			steering_engine_PWM_OUT <= 1'b1;
		else
			steering_engine_PWM_OUT <= 1'b0;
		end
	else if((left_infrared == 1'b1 || mid_left_infrared==1'b1)&& ((right_infrared == 1'b0)&&(mid_right_infrared == 1'b0)))
		begin
		steering_PWM_counter_out <= 20'd35000	;	//30°
		if(steering_PWM_counter <= steering_PWM_counter_out)
			steering_engine_PWM_OUT <= 1'b1;
		else
			steering_engine_PWM_OUT <= 1'b0;
		end	
	else if((right_infrared == 1'b1 || mid_right_infrared==1'b1)&& ((left_infrared == 1'b0)&&(mid_left_infrared == 1'b0)))
		begin
		steering_PWM_counter_out <= 20'd100000	;	//40°
		if(steering_PWM_counter <= steering_PWM_counter_out)
			steering_engine_PWM_OUT <= 1'b1;
		else
			steering_engine_PWM_OUT <= 1'b0;
		end
	end
else
	steering_PWM_counter  <= 20'b0;
end


endmodule
	
	
		
		
		
		