module distribute(clk,out1,out2);

input clk;

output reg[3:0] out1;
output reg[3:0] out2;

always @(posedge clk)
begin
out1 <= 4'b1111;
out2 <= 4'b0000;
end

endmodule