module RISCV #(parameter Data_Width1=5,Data_Width2=32,Data_Width3=28,CONTROL_WIDTH=3) 
(input  wire CLK,
input   wire RST,
input   wire [Data_Width2-1:0] INSTR,
input   wire [Data_Width2-1:0] Read_Data,
output  wire  [Data_Width2-1:0] PC,
output  wire [Data_Width2-1:0] ALU_result,
output  wire [Data_Width2-1:0] Write_Data,
output MEM_WRITE_WE
);
wire Zero;
wire sign_flag;
wire MEM_REG;
wire Result_SRC;
wire [1:0] ImmSrc;
wire REG_WRITE;
wire ALU_src;
wire [2:0] ALU_CONTROL;
wire PC_SRC;

 control_unit CONTROL_UNIT (.op_code(INSTR[6:0]),.funct3(INSTR[14:12]),.funct7(INSTR[30]),.Zero(Zero),.sign_flag(sign_flag),.PCSrc(PC_SRC),
.mem_write(MEM_WRITE_WE),.ImmSrc(ImmSrc),.reg_write(REG_WRITE),.ALU_SRC(ALU_src),.Result_SRC(Result_SRC),.ALU_control(ALU_CONTROL));

data_path #(.data_width1(Data_Width1),.data_width2(Data_Width2),.data_width3(Data_Width3),.CONTROL_WIDTH(CONTROL_WIDTH)) DATA_PATH
(.CLK(CLK),.RST(RST),.instr(INSTR),.Read_Data(Read_Data),.PCSrc(PC_SRC),.mem_write(MEM_WRITE_WE),
.ImmSrc(ImmSrc),.reg_write(REG_WRITE),.ALU_SRC(ALU_src),.Result_SRC(Result_SRC),.sign_flag(sign_flag),
.ALU_control(ALU_CONTROL),.zero(Zero),.PC(PC),.ALU_OUT(ALU_result),.write_data(Write_Data));


endmodule
