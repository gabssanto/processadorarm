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

module Datapath (
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
	wRegisterShowSelect,			//wRegDispSelect
	wRegisterShow, 				//wRegDisp
	wControlALUOp,
	woInstruction,					//woInstr
	wDebug
);

//DEFINICAO DE I/O

input wire iCLK, iCLKMem, iCLK50, iRST;
output wire [63:0] wPC, wRegisterShow;
output wire [31:0] woInstruction;
output wire wControlRegWrite, wControlMemRead, wControlMemWrite;
output wire [1:0] wControlReg2Loc, wControlALUOp, wControlALUSrc, wControlOrigemPC, wControlMemtoReg;
output wire [10:0] wControlOpcode;
input wire [4:0] wRegisterShowSelect;
//Para Debug
output wire [63:0] wDebug;

	
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
//SIRE INSTRUCTION
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
wire [25:0] wImmediate;
wire [63:0] wImmediateExtension;
wire [63:0] wBranchPC;
wire [63:0] wImmediateZeroExtension; //wExtZeroImm;

initial
begin
	PC <= 32'b0;
end

endmodule
