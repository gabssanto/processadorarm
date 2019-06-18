/*
 * Caminho de dados processador uniciclo
 * input: 
 *	iCLK - Clock
 *	iRST - Reset
 * output:
 *	none
 *
 */
//os wXXXX da entrada sao na verdade oXXXX

module DataPath (
	iCLK,
	iCLKMemory,
	iCLK50,
	iReset,	//rst
	wPC,
	wControlReg2Loc,	//RegDst
	wControlALUSrc,	//OrigALU 
	wControlMemtoReg,	//mem2reg
	wControlRegWrite,
	wControlMemRead,
	wControlMemWrite,
	wControlOrigemPC,
	wControlOpcode,
	wControlBranch,	// VER SE REALMENTE VAI SER UTIL 
	wRegisterShowSelect,			//wRegDispSelect
	wRegisterShow, 				//wRegDisp
	wControlALUOp,
	woInstruction,					//woInstr
	//wDebug
);

//DEFINICAO DE I/O

//INPUTS
input wire iCLK, iCLKMemory, iCLK50, iReset;
input wire [4:0] wRegisterShowSelect;

//OUTPUTS
output wire [63:0] wPC, wRegisterShow;
output wire [31:0] woInstruction;
output wire wControlRegWrite, wControlMemRead, wControlMemWrite;
output wire [1:0] wControlALUOp, wControlOrigemPC;						
output wire wControlReg2Loc, wControlALUSrc, wControlMemtoReg, wControlBranch;//ACHO QUE VAI SER UTIL O BRANCH
output wire [10:0] wControlOpcode;
//Para Debug
//output wire [63:0] wDebug;

	
//DEFINICAO DE VARIAVEIS

/* Padrao de nomeclatura
 *
 * XXXXX - registrador XXXX
 * wXXXX - wire XXXX
 * wCXXX - wire do sinal de controle XXX
 * memXX - memoria XXXX
 * Xunit - unidade funcional X
 * iXXXX - sinal de entrada/input
 * oXXXX - sinal de saida/output
 */

//PC
reg [63:0] PC;
//PC+4
wire [63:0] wPC_MAIS_4;
//WIRE INPUT PC
wire [63:0] wiPC;
//WIRE INSTRUCTION
wire [31:0] wInstruction;



//FIZ ATE AQUI NA AULA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA



//WIRE ADDRESS REGISTERS RM, RN, RT AND WREG2LOC TO CHOOSE THE REGISTERS
wire [4:0] wAddressRm, wAddressRn, wAdressRt, wReg2Loc;
//READ DATA ON REGISTER 1 AND 2
wire [63:0] wRead1, wRead2;
//WIRE ALU SOURCE 
wire [63:0] wALUSrc;
//WIRE ALU RESULT
wire [63:0] wALUResult;
//WIRE ZERO 
wire wZero;
//WIRE ALU CONTROL
wire [3:0] wALUControl;
wire [63:0] wReadData;
wire [63:0] wDataRegister;
//USADO APENAS PARA REPLICAR OS BITS NA EXTENSAO DE BITS DA INSTRUCAO ABAIXO
wire [31:0] wZero32; 
//EXTENSAO DE SINAL DE 32 PARA 64 BITS, nao sei se ta funcionando corretamente ainda 
wire [63:0] wInstructionExtended;

wire wBranchANDZero;

//POSTERIOR IMPLEMENTACAO
//wire [63:0] wBranchPC;
/******************************************************************************
					NAO ACREDITO QUE SERAO IMPLEMENTADOS ESSES MAS SO POR GARANTIA
					VER DEPOIS
					//wire [25:0] wImmediate;
					//wire [63:0] wImmediateExtension;
					//wire [63:0] wImmediateZeroExtension; //wExtZeroImm;
*******************************************************************************/
initial
begin
	PC <= 64'b0;
end

assign wPC_MAIS_4 = wPC + 64'h4;	// wPC_MAIS_4 = wPC + 4
//assign wBranchPC;
assign wPC = PC;	//manda valor do registrador PC para wirePC
assign wControlOpcode = wInstruction[31:21];
assign wAddressRm = wInstruction[20:16];
assign wAddressRn = wInstruction[9:5];
assign wAddressRt = wInstruction[4:0];
assign woInstruction = wInstruction;
assign wZero32 = 32'b0;
assign wInstructionExtended = {wZero32, wInstruction};
assign wBranchANDZero = wZero & wControlBranch;

//Memoria de Instrucoes

//Banco de Registradores

//ALU Control

ALUControl ALUControlunit(
	.iOpcode(wControlOpcode),
	.iALUOp(wControlALUOp),
	.oControlSignal(wALUControl)
);


//ALU

ALU ALUunit(
	.ALUControlInput(wALUControl),
	.OperandoA(wRead1),
	.OperandoB(wALUSrc),
	.Out(wALUResult),
	.Zero(wZero)
);

//Memoria de Dados
DataMemory memData(
	.iCLK(iCLK),
	.iCLKMem(iCLKMem),
	.iAddress(wALUResult),
	.iWriteData(wRead2),
	.iMemRead(wControlMemRead),
	.iMemWrite(wControlMemWrite),
	.oMemData(wReadData)
);

CodeMemory codeData(
	.iCLK(iCLK),
	.iCLKMem(iCLKMem),
	.iAddress(wPC),
	.iWriteData(ZERO),
	.iMemRead(wControlMemRead),
	.iMemWrite(wControlMemWrite),
	.oMemData(wInstruction)
	
);
//Control

always @(wControlReg2Loc)
begin
	case(wControlReg2Loc)
		1'b0:
			wControlReg2Loc <= wAddressRm;
		1'b1:
			wControlReg2Loc <= wAddressRt;
	
	endcase
end

always @(wControlALUSrc)
begin
	case(wControlALUSrc)
		1'b0:
			wControlALUSrc <= wRead2;
		1'b1:
			wControlALUSrc <= wInstructionExtended;
	endcase
end

always @(wControlOrigemPC)
begin
	case(wControlOrigemPC)
		1'b0:
			wControlOrigemPC <= wPC_MAIS_4;
		//PARA SER 1 PRECISA DE UM AND ENTRE BRANCH E ZERO
		1'b1:
			wControlOrigemPC <= wBranchANDZero;
	endcase
end

always @(wControlMemtoReg)
begin
	case(wControlMemtoReg)
	1'b0:
		wControlMemtoReg <= wALUResult;		
	1'b1:
		wControlMemtoReg <= wReadData;
	endcase
end

always @(posedge iReset)
begin
	if(iReset)
		PC <= 64'b0;
	else
		PC <= wiPC;

end


endmodule
