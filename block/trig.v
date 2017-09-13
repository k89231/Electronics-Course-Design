module trig(clk,out1,out2);
input clk;
output reg out1,out2;

reg [30:0]count;

initial 
begin 
out1<=0; 
out2<=0; 
count<=0;
end

always @(posedge clk)
begin
count<=count+1;
if(count<1000) begin 
	 out1<=1;
	 end
else if(count>=1000&&count<2000000) 
	 begin
	 out1<=0;
	 end
else if(count>=2000000&&count<2001000) begin
    out2<=1;
	 end
else if(count>=2001000&&count<10000000) out2<=0;
else begin
    count<=0;
	 end
end
endmodule