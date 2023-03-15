module control_unit(input wire [6:0] op_code,
input  wire [2:0] funct3,
input  wire funct7,
input  wire Zero,
input  wire sign_flag,  
output reg PCSrc,
output wire mem_write,
output wire [1:0]ImmSrc,
output wire reg_write,
output wire ALU_SRC,
output wire Result_SRC,
output wire [2:0] ALU_control);
wire [1:0] ALU_OP;
wire branch;
wire BEQ;
wire BNQ;
wire BLT;
main_decoder MAIN_DECODER(.op_code(op_code), .Result_Src(Result_SRC),.mem_write(mem_write),.branch(branch),
.ImmSrc(ImmSrc),.reg_write(reg_write),.ALU_SRC(ALU_SRC),.ALU_OP(ALU_OP));

ALU_decoder ALU_DECODER(.OP(op_code[5]),.ALU_OP(ALU_OP),.funct3(funct3),.funct7(funct7),.ALU_control(ALU_control));

and_gate gate1 (.IN1(branch),.IN2(Zero),.OUT(BEQ));
and_gate gate2 (.IN1(branch),.IN2(!Zero),.OUT(BNQ));
and_gate gate3 (.IN1(branch),.IN2(sign_flag),.OUT(BLT));
always @(*)
begin
 case(funct3)
   3'b000:begin
	PCSrc=BEQ;
       end
   3'b001:begin
	PCSrc=BNQ;
       end
   3'b100:begin
	PCSrc=BLT;
       end
   default:begin
	    PCSrc=1'b0;
           end
  endcase
  end
endmodule
