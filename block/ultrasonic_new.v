module ultrasonic_new(iclk,trigcenter,centerecho,data6,data7,distance);

input iclk,centerecho;
output trigcenter;
output [3:0]data6;
output [7:0]data7;
reg trigcenter;
reg [20:0]centerdistance;
output reg [20:0]distance;

reg [9:0]cnt;              //计数器，计625个20ns，12.5us，为echo提供时序
reg [16:0] cnt1;           //计数器，计8000个12.5us，100ms

reg [10:0]cntcenter3;			

reg [7:0] dis[9:0];        //数码管显示的数字
reg [3:0]                  //数码管需要显示的数字
datacenter1,
datacenter2,
datacenter3,
datacenter4;
reg [3:0]data6;             //数码管位选寄存器
reg [7:0]data7;            //数码管段选寄存器
reg flag2;
reg[1:0]cnt4;              //控制数码管依次闪亮的计数器
reg 
echo_buf_center,                  
echo_rising_center,               
echo_falling_center;


reg             
flagcenter1;                     //echo为高电平时flag1会是1，低电平时会是0
reg clk;                   //数码管显示所需的时钟
reg[19:0] cnt5;             //用于产生数码管显示用的时钟的分频器
reg clk2;
reg [3:0] qian,bai,shi,ge;
reg [12:0]cnt61,cnt62;
reg clk61,clk62;
reg [20:0] distancebefore1,distancebefore2;
//显示存储器初始化
initial
begin
dis[0] = 8'b11111100;
dis[1] = 8'b01100000;
dis[2] = 8'b11011010;
dis[3] = 8'b11110010;
dis[4] = 8'b01100110;
dis[5] = 8'b10110110;
dis[6] = 8'b10111110;
dis[7] = 8'b11100000;
dis[8] = 8'b11111110;
dis[9] = 8'b11110110;
end

always @(posedge iclk)
	 begin
	 cnt61 <= cnt61 + 1;
	 if(cnt61 == 1)
		begin
		clk61 <= ~clk61;
		cnt61 <= 0;
		end
	 end
always @(posedge clk61)
	 begin
	 cnt62 <= cnt62 + 1;
	 if(cnt62 == 4)
		begin
		clk62 <= ~clk62;
		cnt62 <= 0;
		end
	 end
	 
always @(posedge clk62)
	 begin
	 distance <= centerdistance;
	 /*if(flag2 == 1'b0)
		begin
		distancebefore1 <= centerdistance;
		if(((distancebefore2 < distancebefore1) &&(distancebefore2 > distancebefore1 - 10)) 
		|| ((distancebefore2 > distancebefore1) &&(distancebefore2 < distancebefore1 + 10)))
			begin
			distance <= distancebefore1;
			flag2 <= 1'b1;
			end
		else
			begin
			distance <= distancebefore2;
			flag2 <= 1'b1;
			end
		end
	 else
		begin
		distancebefore2 <= centerdistance;
		if(((distancebefore2 < distancebefore1) &&(distancebefore2 > distancebefore1 - 10)) 
		|| ((distancebefore2 > distancebefore1) &&(distancebefore2 < distancebefore1 + 10)))
			begin
			distance <= distancebefore2;
			flag2 <= 1'b0;
			end
		else
			begin
			distance <= distancebefore1;
			flag2 <= 1'b0;
			end
		end*/
	 end



//产生echo控制信号625*8000*20ns，echo高电平持续12.5us，即625个时钟周期
always@(posedge iclk)                   
	begin
		if(cnt == 624)
			cnt <= 1'b0;
		else
			cnt <= cnt +1;
	end

	
always@(posedge iclk)
	begin
		if(cnt == 624)
			if(cnt1 == 39999)
				begin
				trigcenter <= 1'b1;
				cnt1 <= 1'b0;
				end
			else
				begin
				trigcenter <= 1'b0;
				cnt1 <= cnt1 + 1'b1;
				end
	end

always@(posedge iclk)
begin 
echo_buf_center <= centerecho;
echo_rising_center <= centerecho & (~echo_buf_center);
echo_falling_center <= (~centerecho) & echo_buf_center;
end
always@(posedge iclk)
begin
if(echo_rising_center == 1'b1)
begin
flagcenter1 = 1'b1;                       //echo已经变为高电平
end
else if(echo_falling_center == 1'b1)
begin
flagcenter1 = 1'b0;                       //echo已经变为低电平
end
end

/////////////////////////////////////////////////////////////////
always@(posedge iclk)
begin
if(flagcenter1 == 1'b1)
begin
if(cntcenter3 == 288)                     //1mm
cntcenter3 <= 1'b0;
else
cntcenter3 <= cntcenter3 + 1'b1;
end 
else if(echo_rising_center == 1'b1)
cntcenter3 <= 1'b0;
end

always@(posedge iclk)
begin
if(flagcenter1 == 1'b1)
begin
if(cntcenter3 == 288)
if(datacenter1 == 9)                      //1cm
datacenter1 <= 4'd0;
else 
datacenter1 <= datacenter1 + 1'b1;
end
else if(echo_rising_center == 1'b1)
datacenter1 <= 1'b0;
end

always@(posedge iclk)
begin
if(flagcenter1 == 1'b1)
begin
if(datacenter1 == 9 && cntcenter3 == 288)
if(datacenter2 == 9)                     //1dm
datacenter2 <= 1'b0;
else
datacenter2 <= datacenter2 + 1'b1;
end
else if(echo_rising_center == 1'b1)
datacenter2 <= 1'b0;
end

always@(posedge iclk)
begin
if(flagcenter1 == 1'b1)
begin
if(datacenter2 == 9 && datacenter1 == 9 && cntcenter3 == 288)
if(datacenter3 == 9)                    //1m
datacenter3 <= 1'b0;
else
datacenter3 <= datacenter3 + 1'b1;
end
else if(echo_rising_center == 1'b1)
datacenter3 <= 1'b0;
end

always@(posedge iclk)
begin
if(flagcenter1 == 1'b1)
begin
if(datacenter3 == 9 && datacenter2 == 9 && datacenter1 == 9 && cntcenter3 == 288)
if(datacenter4 == 9)                     //说明书上最远是测距4m
datacenter4 <= 1'b0;
else
datacenter4 <= datacenter4 + 1'b1;
end
else if(echo_rising_center == 1'b1)
datacenter4 <= 1'b0;
end


/////////////////////////////////////////////////////////////////

//产生显示用的时钟信号
always@(posedge iclk)
begin
if(cnt5 == 20000)
begin
clk = ~clk;
cnt5 = 1'b0;
end
else
cnt5 = cnt5 + 1'b1;
end

//00-11为一个周期，每个周期点亮一个数码管
always@(posedge clk)
begin
cnt4 = cnt4 + 1'b1;
end

 
//让数码管显示中央超声波模块测得的距离值，即小车正前方的障碍物离小车的距离
//让4个数码管显示四位数字，单位是毫米。
always@(posedge clk)
begin
	if(flagcenter1 == 1'b0)
	begin
		case(cnt4)
		2'b00:
			begin
			ge = ((centerdistance % 1000) % 100) % 10;
			data7 = dis[ge];
			data6 = 6'b0001;
			end
		2'b01:
			begin
			shi = ((centerdistance % 1000) % 100)/10;
			data7 = dis[shi];
			data6 = 6'b0010;
			end
		2'b10: 
			begin
			bai = (centerdistance % 1000)/100;
			data7 = dis[bai];
			data6 = 6'b0100;
			end
		2'b11:
			begin
			centerdistance = 1000 * datacenter4 + 100 * datacenter3 + 10 * datacenter2 + datacenter1;
			data7 = dis[datacenter4];
			data6 = 6'b1000;
			end
		default: ;
		endcase
	end
	else 
		begin
		data7 = dis[0];
		data6 = 4'b1111;
		centerdistance <= 0;
		end
end

endmodule