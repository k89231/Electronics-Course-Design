module charing(clk,reset,in1,in2,in3,in4,in5,in6,in7,in8,in9,in11,ok,out,scan,start);
//module charing(clk,in,out,scan);
input reset,in1,in2,in3,in4,in5,in6,in7,in8,in9,in11,ok,clk,start;
output reg[6:0] out;//七段译码器的输出
output reg[3:0] scan;//扫描显示的输出
reg [3:0] data;                        //扫描时记录
reg [1:0] count;                         //扫描计数
reg [3:0] T1=0;                        //存储输入的数
reg [3:0] T2=0;
parameter  s0=0,s1=1,s2=2,s3=3,s4=4,s5=5,s6=6;//一共5个状态
reg [2:0] state=s4;			//初始状态为0
reg flag=0;		//确认信号
reg switch =0;				
reg [11:0] secten=0;				//开始信号
reg [8:0] temp=0;
wire [7:0] out1;                        //记录前两个数
reg [7:0] out2;                         //记录后两个数
assign out1[7:4]=T1[3:0];               
assign out1[3:0]=T2[3:0];
reg change;
reg right;
reg [15:0] number;

 
 
 
always @(posedge clk)
begin
 temp=temp+1;
 if (change==1) begin secten=0; end
 secten=secten+1;
end
always @(posedge clk)
begin
   if(clk)
   begin
case(state)
//-------------------------------------输入第一个数字--------------------------------------------
   s0:                             
	begin
		change=0;
		number <= 0;
	    if(reset==1)   begin  T1=0; T2=0;  out2=0; change=1;state<=s0;  end  
       else if(in1==1) begin T1=4'b0001; state<=s1;  number <= number + 1000;end   
		 else if(in2==1) begin T1=4'b0010; state<=s1; number <= number + 2000 ;end	 
		 else if(in3==1) begin T1=4'b0011; state<=s1;  number <= number + 3000 ;end    
       else if(in4==1) begin T1=4'b0100; state<=s1;  number <= number + 4000 ;end
	    else if(in5==1) begin T1=4'b0101; state<=s1; number <= number + 5000 ;end
       else if(in6==1) begin T1=4'b0110; state<=s1; number <= number + 6000 ;end
		 else if(in7==1) begin T1=4'b0111; state<=s1; number <= number + 7000 ;end     
		 else if(in8==1) begin T1=4'b1000; state<=s1; number <= number + 8000 ;end
	    else if(in9==1) begin T1=4'b1001; state<=s1; number <= number + 9000 ;end
	    else if(in11==1) begin T1=4'b0000;state<=s1;  end
		 else if(secten==12'b111111111111) begin state<=s4; end
	end
//-----------------------------------输入第二个数时的状态--------------------------------------------------
   s1:                                          
	begin   
		change=0;
	   if(reset==1)      begin  T1=0; T2=0;  out2=0;change=1; state<=s0;       end  
	   else
	   begin
	     if(in1==1)       begin T2=4'b0001;state<=s3; number <= number + 100 ;end
	     else if(in2==1)  begin T2=4'b0010;state<=s3; number <= number + 200 ;end
        else if(in3==1)  begin T2=4'b0011;state<=s3; number <= number + 300 ;end
        else if(in4==1)  begin T2=4'b0100;state<=s3; number <= number + 400 ;end
 	     else if(in5==1)  begin T2=4'b0101;state<=s3; number <= number + 500 ;end
	     else if(in6==1)  begin T2=4'b0110;state<=s3; number <= number + 600 ;end
 	     else if(in7==1)  begin T2=4'b0111;state<=s3; number <= number + 700 ;end
 	     else if(in8==1)  begin T2=4'b1000;state<=s3; number <= number + 800 ;end
	     else if(in9==1)  begin T2=4'b1001;state<=s3; number <= number + 900 ;end
        else if(in11==1) begin T2=4'b0000;state<=s3; end
		  else if(secten==12'b111111111111) begin state<=s4; end
		end
	end
//-------------------------------输入第三个数时的状态-----------------------------------
	s3:                       
	begin   
		change=0;
	   if(reset==1)      begin  T1=0; T2=0;  out2=0;change=1; state<=s0;       end  
	   else
	   begin
	     if(in1==1)       begin out2[7:4]=4'b0001;state<=s5;number <= number + 10 ;end
	     else if(in2==1)  begin out2[7:4]=4'b0010;state<=s5;number <= number + 20 ; end
        else if(in3==1)  begin out2[7:4]=4'b0011;state<=s5;number <= number + 30 ; end
        else if(in4==1)  begin out2[7:4]=4'b0100;state<=s5;number <= number + 40 ; end
 	     else if(in5==1)  begin out2[7:4]=4'b0101;state<=s5;number <= number + 50 ; end
	     else if(in6==1)  begin out2[7:4]=4'b0110;state<=s5;number <= number + 60 ; end
 	     else if(in7==1)  begin out2[7:4]=4'b0111;state<=s5;number <= number + 70 ; end
 	     else if(in8==1)  begin out2[7:4]=4'b1000;state<=s5;number <= number + 80 ; end
	     else if(in9==1)  begin out2[7:4]=4'b1001;state<=s5;number <= number + 90 ; end
        else if(in11==1) begin out2[7:4]=4'b0000;state<=s5; end
		  else if(secten==12'b111111111111) begin state<=s4; end
		end
	end
//-------------------------------输入第四个数时的状态-----------------------------------
	s5:                       
	begin   
		change=0;
	   if(reset==1)      begin  T1=0; T2=0;  out2=0;change=1; state<=s0;       end  
	   else
	   begin
	     if(in1==1)       begin out2[3:0]=4'b0001;state<=s6;number <= number + 1 ; end
	     else if(in2==1)  begin out2[3:0]=4'b0010;state<=s6;number <= number + 2 ; end
        else if(in3==1)  begin out2[3:0]=4'b0011;state<=s6;number <= number + 3; end
        else if(in4==1)  begin out2[3:0]=4'b0100;state<=s6;number <= number + 4 ; end
 	     else if(in5==1)  begin out2[3:0]=4'b0101;state<=s6;number <= number + 5 ; end
	     else if(in6==1)  begin out2[3:0]=4'b0110;state<=s6;number <= number + 6 ; end
 	     else if(in7==1)  begin out2[3:0]=4'b0111;state<=s6;number <= number + 7 ; end
 	     else if(in8==1)  begin out2[3:0]=4'b1000;state<=s6;number <= number + 8 ; end
	     else if(in9==1)  begin out2[3:0]=4'b1001;state<=s6;number <= number + 9 ; end
        else if(in11==1) begin out2[3:0]=4'b0000;state<=s6; end
		  else if(secten==12'b111111111111) begin state<=s4; end
		end
	end
//------------------------------三位数字输入完之后的确认状态-----------------------------------
	s6:                       
	begin
	 change=0;
	 if(reset==1)    begin  T1=0;  T2=0;  out2=0; change=1;state<=s0;  end
    else if(ok==1)   begin  flag=1;   state<=s2;              end 
	 else if(secten==12'b111111111111) begin state<=s4; end
	end
//-----------------------------------确认状态----------------------------------------------
   s2:                                                  
	begin
	    if(flag==1&&number==1234)	
         begin 
					T1 = 4'b1111;
					T2 = 4'b0000;
					out2 = 8'b10101111;
            end
			else
			begin
				T1 = 4'b1111;
				T2 = 4'b1011;
				out2 = 8'b00001111;
			end
			if(reset==1)    begin  T1=0;  T2=0;  out2=0; change=1;state<=s0;  end
  end
 //-----------------------------------初始状态----------------------------------------------
 s4:                       
	begin
	switch=0;
	 if (start==1)  begin T1=0;  T2=0;  out2=0; change=1;switch=1;state<=s0; end
	 else begin switch=0; end
	end
endcase
end
end


//------------------数码管扫描-------------------
always@(posedge clk)
begin 
   count<=count+1;
end

always@(count)
begin

if (switch==1)
begin
   case(count[1:0])
      2'b00:begin data<=out1[7:4];scan<='b1000;end
      2'b01:begin data<=out1[3:0];scan<='b0100;end
      2'b10:begin data<=out2[7:4];scan<='b0010;end
      2'b11:begin data<=out2[3:0];scan<='b0001;end
      default:begin data<='bx;scan<='bx;end
   endcase
end

else begin data<=out1[7:4];scan<='b0000; end
//------------------七段译码-------------------
   case(data[3:0])
     4'b0000:out[6:0]<=7'b1111110;
     4'b0001:out[6:0]<=7'b0110000;
     4'b0010:out[6:0]<=7'b1101101;
     4'b0011:out[6:0]<=7'b1111001;
     4'b0100:out[6:0]<=7'b0110011;
     4'b0101:out[6:0]<=7'b1011011;
     4'b0110:out[6:0]<=7'b1011111;
     4'b0111:out[6:0]<=7'b1110000;
     4'b1000:out[6:0]<=7'b1111111;
     4'b1001:out[6:0]<=7'b1111011;
	  4'b1010:out[6:0]<=7'b1001110;//c
	  4'b1011:out[6:0]<=7'b1110110;//n
	  4'b1111:out[6:0]<=7'b0000000;
     default:out[6:0]<='bx;
   endcase
	
end
endmodule