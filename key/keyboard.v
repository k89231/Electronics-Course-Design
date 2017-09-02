module keyboard(clk,row,col,out11,out1,out2,out3,out4,out5,out6,out7,out8,out9,reset,ok,start);
//module keyboard(clk,row,col,out,reset,ok,start);
input clk;
input [3:0] col;
output [3:0]row,out11,out1,out2,out3,out4,out5,out6,out7,out8,out9,reset,ok,start;
//output [3:0]row,reset,ok,start;
//output [9:0]out;
reg [3:0]row;
reg [1:0] i='b00;
reg [4:0] i1=0,i2=0,i3=0,i4=0,i5=0,i6=0,i7=0,i8=0,i9=0,i10=0,i11=0,i12=0,i13=0;
reg out11=0,out1=0,out2=0,out3=0,out4=0,out5=0,out6=0,out7=0,out8=0,out9=0,reset=0,ok=0,start=0;
reg [9:0] out;
always @(posedge clk)
 if(clk)
 begin
 //----------------------------------持续行的扫描--------------------------------------
  case(i[1:0])
  2'b00:begin row<=4'b1110; i<= 2'b01;end
  2'b01:begin row<=4'b1101; i<= 2'b10;end
  2'b10:begin row<=4'b1011; i<= 2'b11;end
  2'b11:begin row<=4'b0111; i<= 2'b00;end 
  endcase
  //----------------------------------键盘中某一个数的判断-----------------------------------------
 if(col==4'b1110&&row==4'b1110)          begin i1=i1+1;   end
 else if(col==4'b1101&&row==4'b1110)     begin i2=i2+1;   end
 else if(col==4'b1011&&row==4'b1110)	  begin i3=i3+1;   end
 else	if(col==4'b0111&&row==4'b1110)     begin i4=i4+1;   end
 else	if(col==4'b1110&&row==4'b1101)     begin i5=i5+1;   end
 else	if(col==4'b1101&&row==4'b1101)     begin i6=i6+1;   end
 else	if(col==4'b1011&&row==4'b1101)     begin i7=i7+1;   end
 else	if(col==4'b0111&&row==4'b1101)     begin i8=i8+1;   end
 else if(col==4'b1110&&row==4'b1011)     begin i9=i9+1;   end
 else	if(col==4'b1011&&row==4'b0111)     begin i10=i10+1; end
 else	if(col==4'b1101&&row==4'b1011)	  begin i11=i11+1; end
 else if(col==4'b0111&&row==4'b0111)     begin i12=i12+1; end
 else if(col==4'b1101&&row==4'b0111)     begin i13=i13+1; end
//---------------------------------------------------键盘的输出-----------------------------------------
 if(i1==31)          begin  out1=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else if(i2==31)     begin  out2=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else if(i3==31)     begin  out3=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else if(i4==31)     begin  out4=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else if(i5==31)     begin  out5=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else if(i6==31)     begin  out6=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else if(i7==31)	   begin  out7=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else if(i8==31)     begin  out8=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else if(i9==31)	   begin  out9=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else if(i10==31)    begin  reset=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else if(i11==31)    begin  out11=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else if(i12==31)    begin  ok=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else if(i13==31)    begin  start=1;i1=0;i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;i8=0;i9=0;i10=0;i11=0;i12=0;i13=0; end
 else                begin out1<=0;out2<=0;out3<=0;out4<=0;out5<=0;out6<=0;out7<=0;out8<=0;out9<=0;reset<=0;out11<=0;ok<=0;start<=0; end
end
endmodule