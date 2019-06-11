//ALU Control (iOpcode, iALUOperacao, oControlSignal); 

module ALUControl (iOpcode, iALUOperacao, oControlSignal);


/* I/O type definition */
input wire [10:0] iOpcode;
input wire [1:0] iALUOp;
output reg [3:0] oControlSignal;

wire DefOp = {iOpcode[9:8], iOpcode[3]};

always @(iALUOp)
begin
	case (iALUOp)
		2'b00:
			oControlSignal <=	OPADD;
		2'b01:
			oControlSignal <=	OPSUB;
		2'b10:
			begin
				case (DefOp)
					3'b001:	//ADD
						oControlSignal <= OPADD;
					3'b101: 	//SUB
						oControlSignal <= OPSUB;
					3'b000:	//AND
						oControlSignal <= OPAND;
					3'b010:	//ORR
						oControlSignal <= OPORR;
					default:
						oControlSignal <= 4'b0000;
				endcase
			end
	endcase
end

endmodule
