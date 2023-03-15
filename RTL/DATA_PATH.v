module data_path #(parameter data_width1=5,data_width2=32,data_width3=28,CONTROL_WIDTH=3)
(input wire CLK,
input  wire RST,
input  wire [data_width2-1:0] instr,
input  wire PCSrc,
input  wire mem_write,
input  wire [1:0]ImmSrc,
input  wire reg_write,
input  wire ALU_SRC,
input  wire Result_SRC,
input  wire [2:0] ALU_control,
input  wire [data_width2-1:0] Read_Data,
output wire zero,
output wire sign_flag,
output wire [data_width2-1:0] PC,
output wire [data_width2-1:0] ALU_OUT,
output wire [data_width2-1:0] write_data 
);
wire [data_width2-1:0] SRC_A;
wire [data_width2-1:0] SRC_B;
wire [data_width2-1:0] ImmExt;
wire [data_width1-1:0] write_reg;
wire [data_width2-1:0] PC_PLUS4;
wire [data_width2-1:0] PC_Target;
wire [data_width2-1:0] PCNext;
wire [data_width2-1:0] Result;

/**************************Data Memory MUX**********************/

MUX #(.data_width(data_width2)) MUX2 (.in1(ALU_OUT),.in2(Read_Data),.sel(Result_SRC),.out(Result));


/**************************ALU  MUX**********************/

MUX #(.data_width(data_width2)) MUX3 (.in1(write_data),.in2(ImmExt),.sel(ALU_SRC),.out(SRC_B));

/*************************sign extend Block*************************/

sign_extend SIGN_EXTEND (.Instr(instr[31:7]),.ImmSrc(ImmSrc),.Imm_Ext(ImmExt));

/**************************ALU module**********************/

ALU #(.DATA_WIDTH(data_width2),.CONTROL_WIDTH(CONTROL_WIDTH)) ALU1 (.rs1(SRC_A),.rs2(SRC_B),.ALU_FUN(ALU_control),.rd(ALU_OUT),.Zero_Flag(zero),.Sign_Flag(sign_flag));



/**************************1st ADDER(1st shifter output is input to it) **********************/

simple_Adder Adder1(.A(PC),.B(ImmExt),.C(PC_Target));


/**************************2nd ADER (program counter plus 4)**********************/

simple_Adder Adder2(.A(PC),.B(32'd4),.C(PC_PLUS4));


/**************************Program Counter**********************/

program_counter PROGRAM_COUNTER (.clk(CLK),.inst_Address(PCNext),.rst(RST),.fetched_inst(PC));


/**************************2nd MUX before PC**********************/

MUX #(.data_width(data_width2)) MUX5 (.in1(PC_PLUS4),.in2(PC_Target),.sel(PCSrc),.out(PCNext));

/**************************register file module**********************/

register_file REGISTER_FILE (.clk(CLK),.rst(RST),.WE3(reg_write),.WD3(Result),.A1(instr[19:15]),.A2(instr[24:20]), 
.A3(instr[11:7]),.RD1(SRC_A),.RD2(write_data));


endmodule
