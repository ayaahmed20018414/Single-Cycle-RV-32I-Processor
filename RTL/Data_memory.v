//Data memory RAM in MIPS processor
module data_mem(input clk,
input mem_WE,
input [31:0] mem_WD,
input [31:0] mem_Address,
input reset, 
output [31:0] mem_RD,
output [31:0] test_value);

integer i;

reg [31:0] mem_RAM [0:999];  

initial
begin
for(i=0;i<1000;i=i+1)
mem_RAM[i]<=32'b0;
end

always @(posedge clk or negedge reset)
begin 
if(!reset)
for(i=0;i<1000;i=i+1)
  mem_RAM[i]<=32'b0;
else if(mem_WE & reset)
 mem_RAM[mem_Address[31:2]]<=mem_WD;
end


assign mem_RD= mem_RAM[mem_Address[31:2]];
assign test_value=mem_RAM[0];
endmodule
