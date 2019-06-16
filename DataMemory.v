module DataMemory (iCLK, iCLKMem, iAddress, iWriteData, iMemRead, iMemWrite, oMemData);

//DEFINICAO DE I/O
input wire iCLK, iCLKMem, iMemRead, iMemWrite;
input wire [63:0] iAddress, iWriteData;
output wire [63:0] oMemData;

reg MemWritten;
wire wMemWrite, wMemWriteMB0;
wire [63:0] wMemDataMB0;


/*
 * Avoids writing twice in a CPU cycle, since the memory is not necessarily
 * synchronous.
 */
always @(iCLK)
begin
	MemWritten <= iCLK;
end 

assign wMemWrite = (iMemWrite && ~MemWritten);
assign wMemWriteMB0 = (wMemWrite && (iAddress< 64'h0000000000004000));

assign oMemData = (iAddress < 64'h0000000000004000 ? wMemDataMB0 : ZERO);

UserDataBlock MB0 (
	.address(iAddress[15:2]),
	.clock(iCLKMem),
	.data(iWriteData),
	.wren(wMemWriteMB0),
	.q(wMemDataMB0)
	);
 
endmodule