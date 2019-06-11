//Arquivo da ULA ALUControlInput, OperandoA, OperandoB, Out, Zero

module ALU (ALUControlInput, OperandoA, OperandoB, Out, Zero);

input [3:0] ALUControlInput;
input [63:0] OperandoA, OperandoB;
output reg [63:0] Out;
output Zero;

assign Zero = (OperandoB == 0 ? 1 : 0);	//Se for 0 a saida vai ser 1, se nao vai ser 0

always @(ALUControlInput, OperandoA, OperandoB)
	case(ALUControlInput)
		OPADD: Out <= OperandoA + OperandoB;
		OPSUB: Out <= OperandoA - OperandoB;
		OPAND: Out <= OperandoA & OperandoB;
		OPORR: Out <= OperandoA | OperandoB;
		OPSTUR: Out <= OperandoA + OperandoB;
		OPLDUR:	Out <= OperandoA + OperandoB;
		//OPCBZ: 
		//OPB:
		default: Out <= 0;
	endcase
endmodule
