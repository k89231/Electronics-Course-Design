module bizhang(clk,left_wheel_PWM_OUT,right_wheel_PWM_OUT,left_echo,right_echo,mid_echo,fire,steering_engine_PWM_OUT,switch);
//申明端口分别有：系统时钟50MHZ，复位，调节后轮目标速度的拨码开关,右光电,左光电,LED显示，led,舵机输出PWM值，右后轮电机PWM输出，左后轮PWM输出，
/**********************************************************************/						
		input		clk;
		input		[20:0]left_echo;
		input 	[20:0]right_echo; 
		input    [20:0]mid_echo;
		
		
		input		[3:0]switch;
		input		[3:0]fire;
/***********************************************************************/	
		//output      [3:0]     			 led;		
		output reg right_wheel_PWM_OUT;
		output reg left_wheel_PWM_OUT;
		output reg steering_engine_PWM_OUT;/***********************************************************************/
	//	reg         [3:0]     			 led;
		reg   [19:0] 	steering_PWM_counter;
		reg   [19:0] 	steering_PWM_counter_out;
		reg   [9:0]		wheel_PWM_OUT;
		reg	[25:0] cnt;
		reg flag;
		reg zigflag,zigflag1;
		reg [13:0] start1,start2,start3,start4,start5;
initial
	begin
		start1 <= 0;
		start2 <= 0;
		start3 <= 0;
		start4 <= 0;
		start5 <= 0;
	end
always @(posedge clk)
	begin
	if(mid_echo < 30)
		flag <= 1'b1;
	else
		flag <= 1'b0;
	end
//电机		
always @(posedge clk)							//后轮输出控制
begin 
	if(wheel_PWM_OUT <= 10'd5000 )
		begin
		wheel_PWM_OUT <= wheel_PWM_OUT + 1'b1;
			
		if((mid_echo< 150) || (fire == 4'b1111))
			begin
			if(wheel_PWM_OUT<=10'd300)//40%
					begin
						right_wheel_PWM_OUT <= 1'b0;
						left_wheel_PWM_OUT  <= 1'b1;
					end
				else 
					begin
						right_wheel_PWM_OUT <= 1'b0;
						left_wheel_PWM_OUT  <= 1'b0;
					end
			end
			else
				begin
					if(switch==4'b0000)
					begin					
							if(wheel_PWM_OUT<=10'd440)//20%
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
				
					else if(switch==4'b0001)
					begin
							if(wheel_PWM_OUT<=10'd450)//20%
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
				
					else if(switch==4'b0011)
					begin
							if(wheel_PWM_OUT<=10'd460)//20%
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
					else if(switch==4'b0111)
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
					else if(switch==4'b1111)
					begin
							if(wheel_PWM_OUT<=10'd480)//20%
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
						if(wheel_PWM_OUT<=10'd200)
							begin
								right_wheel_PWM_OUT <= 1'b1;
								left_wheel_PWM_OUT  <= 1'b0;
							end
						else begin
							right_wheel_PWM_OUT <= 1'b0;
							left_wheel_PWM_OUT  <= 1'b0;
						end
				end  
			end
			end
			else 
			wheel_PWM_OUT <= 10'b0;
		 end
		  
/***********************************************************************/
always @(posedge clk)							//舵机最后输出控制
	begin 
	if(steering_PWM_counter <=20'd100_0000)
			begin
				steering_PWM_counter <= steering_PWM_counter + 1'b1;
			
				if((left_echo>150) && (right_echo>150))
					begin
						steering_PWM_counter_out <= 20'd72000	;	//40°
					if(steering_PWM_counter <= steering_PWM_counter_out)
						steering_engine_PWM_OUT <= 1'b1;
					else
						steering_engine_PWM_OUT <= 1'b0;
				if(fire[1]==1'b0 || fire[2]==1'b0)//if(left_infrared == 1'b0 && right_infrared == 1'b0)
					begin
						steering_PWM_counter_out <= 20'd70000	;	//0°
					if(steering_PWM_counter <= steering_PWM_counter_out)
						steering_engine_PWM_OUT <= 1'b1;
					else
						steering_engine_PWM_OUT <= 1'b0;
					end
				else if(fire[0]==1'b0)//else if(left_infrared == 1'b1&& right_infrared == 1'b1 )
					begin
						steering_PWM_counter_out <= 20'd80000	;	//40°
						if(steering_PWM_counter <= steering_PWM_counter_out)
							steering_engine_PWM_OUT <= 1'b1;
						else
							steering_engine_PWM_OUT <= 1'b0;
						end
				else if(fire[3]==1'b0)//else if(left_infrared == 1'b0&& right_infrared== 1'b1 )
					begin
						steering_PWM_counter_out <= 20'd55000	;	//20°
						if(steering_PWM_counter <= steering_PWM_counter_out)
							steering_engine_PWM_OUT <= 1'b1;
						else
							steering_engine_PWM_OUT <= 1'b0;
					end
					else
					begin
						steering_PWM_counter_out <= 20'd70000	;	//20°
						if(steering_PWM_counter <= steering_PWM_counter_out)
							steering_engine_PWM_OUT <= 1'b1;
						else
							steering_engine_PWM_OUT <= 1'b0;
					end
					end
				else if((left_echo<150) && (right_echo<150) )
					begin
						steering_PWM_counter_out <= 20'd55000	;	//40°
					if(steering_PWM_counter <= steering_PWM_counter_out)
						steering_engine_PWM_OUT <= 1'b1;
					else
						steering_engine_PWM_OUT <= 1'b0;
					end
				
			
				
				else if((left_echo<150) && (right_echo>=150))
						begin
						steering_PWM_counter_out <= 20'd55000	;	//40° 750000
						if(steering_PWM_counter <= steering_PWM_counter_out)
							steering_engine_PWM_OUT <= 1'b1;
						else
							steering_engine_PWM_OUT <= 1'b0;
						end
				
				
				else if((left_echo>=150) && (right_echo<150))
							begin
							steering_PWM_counter_out <= 20'd85000	;	//-40°
							if(steering_PWM_counter <= steering_PWM_counter_out)
								steering_engine_PWM_OUT <= 1'b1;
							else
								steering_engine_PWM_OUT <= 1'b0; 
							end
				
							
				/*		
				else if(left_echo>=100 && right_echo>=100)
				begin
				if(fire[2]==1'b1)//if(left_infrared == 1'b0 && right_infrared == 1'b0)
					begin
						steering_PWM_counter_out <= 20'd72000	;	//0°
					if(steering_PWM_counter <= steering_PWM_counter_out)
						steering_engine_PWM_OUT <= 1'b1;
					else
						steering_engine_PWM_OUT <= 1'b0;
					end
				else if(fire[1]==1'b1)//else if(left_infrared == 1'b1&& right_infrared == 1'b0)
					begin
						steering_PWM_counter_out <= 20'd55000	;	//30°
					if(steering_PWM_counter <= steering_PWM_counter_out)
						steering_engine_PWM_OUT <= 1'b1;
					else
						steering_engine_PWM_OUT <= 1'b0;
					end	
				else if(fire[0]==1'b1)//else if(left_infrared == 1'b1&& right_infrared == 1'b1 )
					begin
						steering_PWM_counter_out <= 20'd45000	;	//40°
						if(steering_PWM_counter <= steering_PWM_counter_out)
							steering_engine_PWM_OUT <= 1'b1;
						else
							steering_engine_PWM_OUT <= 1'b0;
						end
				else if(fire[3]==1'b1)//else if(left_infrared == 1'b0&& right_infrared== 1'b1 )
					begin
						steering_PWM_counter_out <= 20'd85000	;	//20°
						if(steering_PWM_counter <= steering_PWM_counter_out)
							steering_engine_PWM_OUT <= 1'b1;
						else
							steering_engine_PWM_OUT <= 1'b0;
					end
				else if(fire[4]==1'b1)//else if(left_infrared == 1'b0&& right_infrared== 1'b1 )
					begin
						steering_PWM_counter_out <= 20'd94000	;	//20°
						if(steering_PWM_counter <= steering_PWM_counter_out)
							steering_engine_PWM_OUT <= 1'b1;
						else
							steering_engine_PWM_OUT <= 1'b0;
					end
				end
				
				/////////////////////////////////////////////////////////////////
				/*begin
					if(mid_right_infrared==1'b0&& right_infrared == 1'b0)
				begin
				if(left_infrared == 1'b0 && mid_left_infrared == 1'b0)
					begin
						steering_PWM_counter_out <= 20'd9_5000	;	//0°
					if(steering_PWM_counter <= steering_PWM_counter_out)
						steering_engine_PWM_OUT <= 1'b1;
					else
						steering_engine_PWM_OUT <= 1'b0;
					end
				else if(left_infrared == 1'b1&&mid_left_infrared == 1'b0)
					begin
						steering_PWM_counter_out <= 20'd7_5000	;	//30°
					if(steering_PWM_counter <= steering_PWM_counter_out)
						steering_engine_PWM_OUT <= 1'b1;
					else
						steering_engine_PWM_OUT <= 1'b0;
					end	
				else if(left_infrared == 1'b1&&mid_left_infrared == 1'b1 )
					begin
						steering_PWM_counter_out <= 20'd7_5000	;	//40°
						if(steering_PWM_counter <= steering_PWM_counter_out)
							steering_engine_PWM_OUT <= 1'b1;
						else
							steering_engine_PWM_OUT <= 1'b0;
						end
				else if(left_infrared == 1'b0&&mid_left_infrared == 1'b1 )
					begin
						steering_PWM_counter_out <= 20'd7_8000	;	//20°
						if(steering_PWM_counter <= steering_PWM_counter_out)
							steering_engine_PWM_OUT <= 1'b1;
						else
							steering_engine_PWM_OUT <= 1'b0;
					end
				end
					
				if(mid_right_infrared==1'b1&& right_infrared == 1'b0)
					begin
						if(left_infrared == 1'b1&&mid_left_infrared == 1'b1 )
						begin
							steering_PWM_counter_out <= 20'd7_8000;		//60°
							if(steering_PWM_counter <= steering_PWM_counter_out)
								steering_engine_PWM_OUT <= 1'b1;
							else
								steering_engine_PWM_OUT <= 1'b0;
							end
						else if(left_infrared == 1'b0&&mid_left_infrared == 1'b1 )
						begin
							steering_PWM_counter_out <= 20'd7_8000;		//50°
							if(steering_PWM_counter <= steering_PWM_counter_out)
								steering_engine_PWM_OUT <= 1'b1;
							else
								steering_engine_PWM_OUT <= 1'b0;
							end
						else if(left_infrared == 1'b0&&mid_left_infrared == 1'b0 )
						begin
							steering_PWM_counter_out <= 20'd12_0000;		//-30°
							if(steering_PWM_counter <= steering_PWM_counter_out)
								steering_engine_PWM_OUT <= 1'b1;
							else
								steering_engine_PWM_OUT <= 1'b0;
							end
					end
				 
				if(mid_right_infrared==1'b1&& right_infrared == 1'b1)
					begin
						if(left_infrared == 1'b0&&mid_left_infrared == 1'b0 )
							begin
							steering_PWM_counter_out <= 20'd12_0000	;	//-30°
							if(steering_PWM_counter <= steering_PWM_counter_out)
								steering_engine_PWM_OUT <= 1'b1;
							else
								steering_engine_PWM_OUT <= 1'b0; 
							end
						else if(left_infrared == 1'b0&&mid_left_infrared == 1'b1 )
							begin
							steering_PWM_counter_out <= 20'd11_5000	;	//-40°
							if(steering_PWM_counter <= steering_PWM_counter_out)
								steering_engine_PWM_OUT <= 1'b1;
							else
								steering_engine_PWM_OUT <= 1'b0; 
							end
						else if(left_infrared == 1'b1&&mid_left_infrared == 1'b0 )
							begin
							steering_PWM_counter_out <= 20'd7_5000	;	//60°
							if(steering_PWM_counter <= steering_PWM_counter_out)
								steering_engine_PWM_OUT <= 1'b1;
							else
								steering_engine_PWM_OUT <= 1'b0; 
							end
						else if(left_infrared == 1'b1&&mid_left_infrared == 1'b1 )
							begin
							steering_PWM_counter_out <= 20'd9_5000	;	//-60°
							if(steering_PWM_counter <= steering_PWM_counter_out)
								steering_engine_PWM_OUT <= 1'b1;
							else
								steering_engine_PWM_OUT <= 1'b0; 
							end
					end
						
				if(mid_right_infrared==1'b1&& right_infrared == 1'b1)
					begin
						if(left_infrared == 1'b0&&mid_left_infrared == 1'b0 )
							begin
							steering_PWM_counter_out <= 20'd7_5000	;	//-30°
							if(steering_PWM_counter <= steering_PWM_counter_out)
								steering_engine_PWM_OUT <= 1'b1;
							else
								steering_engine_PWM_OUT <= 1'b0; 
							end
						else if(left_infrared == 1'b0&&mid_left_infrared == 1'b1 )
							begin
							steering_PWM_counter_out <= 20'd11_5000	;	//-40°
							if(steering_PWM_counter <= steering_PWM_counter_out)
								steering_engine_PWM_OUT <= 1'b1;
							else
								steering_engine_PWM_OUT <= 1'b0; 
							end
						else if(left_infrared == 1'b1&&mid_left_infrared == 1'b0 )
							begin
							steering_PWM_counter_out <= 20'd11_5000	;	//-40°
							if(steering_PWM_counter <= steering_PWM_counter_out)
								steering_engine_PWM_OUT <= 1'b1;
							else
								steering_engine_PWM_OUT <= 1'b0; 
							end
						else if(left_infrared == 1'b1&&mid_left_infrared == 1'b1 )
							begin
							steering_PWM_counter_out <= 20'd7_5000	;	//30°
							if(steering_PWM_counter <= steering_PWM_counter_out)
								steering_engine_PWM_OUT <= 1'b1;
							else
								steering_engine_PWM_OUT <= 1'b0; 
							end
						end
				*/
				
			end
		else
				steering_PWM_counter  <= 20'b0;

		end
		endmodule