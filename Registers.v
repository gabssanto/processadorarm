/*
 * Registers.v
 *
 * Main processor register bank testbench.
 * Stores information in 63-bit registers. 31 registers are available for
 * writing and 32 are available for reading.
 * Also allows for two simultaneous data reads, has a write enable signal
 * input, is clocked and has an synchronous reset signal input.
 */
module Registers (iCLK, iReset, iAddressRm, iAddressRn, iAddressRt,
	iWriteData, iRegControlWrite, oRead1, oRead2, iRegisterShow, oRegisterShow);

//iXXXXX = sinais de entrada
//oXXXXX = sinais de saida
input wire [4:0] iAddressRm, iAddressRn, iAddressRt,
	iRegisterShow;
input wire [63:0] iWriteData;
input wire iCLK, iReset, iRegControlWrite;
output wire [63:0] oRead1, oRead2, oRegisterShow;

//Definindo os registradores de 64 bits
reg [31:0] registers[63:0];

integer i;

initial
begin
	for (i = 0; i <= 31; i = i + 1)
	begin
		registers[i] = 64'b0;	// Zerando os registradores
	end
	registers[5'd28] = 64'h7fffeffc;  // Definindo o sp
end

//Passando o conteudo dos registradores para as saidas
assign oRead1 =	registers[iAddressRm];
assign oRead2 =	registers[iAddressRn];

assign oRegisterShow =	registers[iRegisterShow];


//Escrevendo dados nos registradores
always @(posedge iCLK)
begin
	if (iReset)
	begin
		for (i = 1; i <= 31; i = i + 1)
		begin
			registers[i] = 64'b0;
		end
		registers[5'd28] = 64'h7fffeffc;
	end
	else if (iCLK && iRegControlWrite)
	begin
		if (iAddressRt != 5'd31)
		begin
			registers[iAddressRt] =	iWriteData;
		end
	end
end

endmodule

