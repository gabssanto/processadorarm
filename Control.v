/**
*
*	CONTROLE GERAL DA CPU
*
*/

module Control(
	iCLK,
	iInstruction,
	Reg2Loc,
	Branch,
	MemRead,
	MemtoReg,
	ALUOp,
	MemWrite,
	ALUSrc,
	RegWrite
);

//Definicao de I/O

input wire iCLK;
input wire [31:0] iInstruction;
wire Opcode = {iInstruction[31:21]};
output wire Reg2Loc, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
output wire [1:0] ALUOp;

initial
begin
			Reg2Loc <= 1'b0;
			Branch <= 1'b0;
			MemRead <= 1'b0;
			MemtoReg <= 1'b0;
			MemWrite <= 1'b0;
			ALUSrc <= 1'b0;
			RegWrite <= 1'b0;
			ALUOp <= 2'b00;
end

always @(Opcode)
begin
	case(Opcode)
		OPADD:
		 begin
			Reg2Loc <= 1'b0;
			Branch <= 1'b0;
			MemRead <= 1'b0;
			MemtoReg <= 1'b0;
			MemWrite <= 1'b1;
			ALUSrc <= 1'b0;
			RegWrite <= 1'b0;
			ALUOp <= 2'b10;
		 end
		
		OPSUB:
		begin
			Reg2Loc <= 1'b0;
			Branch <= 1'b0;
			MemRead <= 1'b0;
			MemtoReg <= 1'b0;
			MemWrite <= 1'b1;
			ALUSrc <= 1'b0;
			RegWrite <= 1'b0;
			ALUOp <= 2'b10;
		end
		
		OPAND:
		begin
			Reg2Loc <= 1'b0;
			Branch <= 1'b0;
			MemRead <= 1'b0;
			MemtoReg <= 1'b0;
			MemWrite <= 1'b1;
			ALUSrc <= 1'b0;
			RegWrite <= 1'b0;
			ALUOp <= 2'b10;
		end
		
		OPORR:
			begin
				Reg2Loc <= 1'b0;
				Branch <= 1'b0;
				MemRead <= 1'b0;
				MemtoReg <= 1'b0;
				MemWrite <= 1'b1;
				ALUSrc <= 1'b0;
				RegWrite <= 1'b0;
				ALUOp <= 2'b10;
			end
		
		OPLDUR:
			begin
				Reg2Loc <= 1'bx;
				Branch <= 1'b0;
				MemRead <= 1'b1;
				MemtoReg <= 1'b1;
				MemWrite <= 1'b0;
				ALUSrc <= 1'b1;
				RegWrite <= 1'b0;
				ALUOp <= 2'b00;
			end
		
		OPSTUR:
			begin
				Reg2Loc <= 1'b1;
				Branch <= 1'b0;
				MemRead <= 1'b0;
				MemtoReg <= 1'bx;
				MemWrite <= 1'b1;
				ALUSrc <= 1'b1;
				RegWrite <= 1'b0;
				ALUOp <= 2'b00;
			end
			
//		OPCBZ:
//			begin
//				Reg2Loc <= 1'b1;
//				Branch <= 1'b1;
//				MemRead <= 1'b0;
//				MemtoReg <= 1'bx;
//				MemWrite <= 1'b0;
//				ALUSrc <= 1'b0;
//				RegWrite <= 1'b0;
//				ALUOp <= 2'b01;
//			end
//			
//		OPB:
//			begin
//				Reg2Loc <= 1'b0;
//				Branch <= 1'b1;
//				MemRead <= 1'b0;
//				MemtoReg <= 1'b0;
//				MemWrite <= 1'b0;
//				ALUSrc <= 1'b1;
//				RegWrite <= 1'b0;
//				ALUOp <= 2'b00;
//			end

	endcase
end

endmodule


		
	