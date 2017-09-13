module control(rst,clk,steering_engine_PWM_OUT,right_wheel_PWM_OUT,left_wheel_PWM_OUT,blueteeth);

input clk,rst ;
input	[7:0]blueteeth;

output	right_wheel_PWM_OUT ;
output	left_wheel_PWM_OUT ;
output	steering_engine_PWM_OUT ;

reg	right_wheel_PWM_OUT ;
reg	left_wheel_PWM_OUT ;
reg	steering_engine_PWM_OUT ;
//reg	[7:0]		blueteeth 	;
reg	[19:0]	steering_PWM_counter ;
reg	[19:0]	steering_PWM_counter_out;
reg	[9:0]		wheel_PWM_OUT ;

always @(posedge clk or negedge rst )
begin
if(!rst)
	wheel_PWM_OUT <= 10'd0;
	else if(wheel_PWM_OUT <= 10'd1000 )
		begin
			wheel_PWM_OUT <= wheel_PWM_OUT + 1'b1;
			
			if(blueteeth == 8'b11000000)//停车
			begin
				if(wheel_PWM_OUT<=10'd100)
					begin
						right_wheel_PWM_OUT <= 1'b0;
						left_wheel_PWM_OUT  <= 1'b0;
						end
				else 
					begin
						right_wheel_PWM_OUT <= 1'b0;
						left_wheel_PWM_OUT  <= 1'b0;
						end
				end
				
				else if((blueteeth == 8'b11111001)||(blueteeth == 8'b10110000)||(blueteeth == 8'b10011001))//前进/拐弯
				begin
					if(wheel_PWM_OUT<=10'd470)
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
				
				else if(blueteeth == 8'b10100100)//后退
				begin
					if(wheel_PWM_OUT<=10'd470)
					begin
						right_wheel_PWM_OUT <= 1'b0;
						left_wheel_PWM_OUT  <= 1'b1;
						end
					else begin
						right_wheel_PWM_OUT <= 1'b0;
						left_wheel_PWM_OUT  <= 1'b0;
						end
				end
				else begin
				if(wheel_PWM_OUT<=10'd100)
					begin
						right_wheel_PWM_OUT <= 1'b0;
						left_wheel_PWM_OUT  <= 1'b0;
						end
					else begin
						right_wheel_PWM_OUT <= 1'b0;
						left_wheel_PWM_OUT  <= 1'b0;
						end
				end  
			end
			else 
			wheel_PWM_OUT <= 10'b0;
		 end


		 

always @(posedge clk or negedge rst)							//舵机最后输出控制
begin 
		if(!rst)
			begin
				steering_PWM_counter <= 20'd0;
				steering_PWM_counter_out<= 9_5000;  //0
				if(steering_PWM_counter <= steering_PWM_counter_out)
					steering_engine_PWM_OUT <= 1'b1;
				else
					steering_engine_PWM_OUT <= 1'b0;
				end
		else if(steering_PWM_counter <=20'd100_0000)
			begin
			steering_PWM_counter <= steering_PWM_counter + 1'b1;
				if(blueteeth == 8'b10110000)
					begin
						steering_PWM_counter_out <= 20'd85000	;	//左拐
					if(steering_PWM_counter <= steering_PWM_counter_out)
						steering_engine_PWM_OUT <= 1'b1;
					else
						steering_engine_PWM_OUT <= 1'b0;
					end
				else if(blueteeth == 8'b10011001)
					begin
						steering_PWM_counter_out <= 20'd55000	;	//右拐
					if(steering_PWM_counter <= steering_PWM_counter_out)
						steering_engine_PWM_OUT <= 1'b1;
					else
						steering_engine_PWM_OUT <= 1'b0;
					end	
				else 
					begin
						steering_PWM_counter_out <= 20'd70000	;	//直行
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
					