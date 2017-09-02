module f_1hz(clkin,clkout);
input clkin;
output clkout;
reg clkout1,clkout2;
reg [16:0] i1;
//reg [6:0] i2;
always @(posedge clkin)
begin
    if(clkin==1)
	   i1=i1+1;
    if(i1==17'b11000000000000000)
	 begin
	 clkout1=1; i1=0;
	 end
	 else clkout1=0;

end
assign clkout=clkout1;
endmodule