    
/*
 * CodeMemory.v
 *
 * Main processor code memory bank.
 * Stores information in 4K x 32bit for User and 2K x 32bit for System
 */
module CodeMemory (iCLK, iCLKMem, iAddress, iWriteData, iMemRead, iMemWrite, oMemData);


/* I/O type definition */
input wire iCLK, iCLKMem, iMemRead, iMemWrite;
input wire [31:0] iAddress, iWriteData;
output wire [31:0] oMemData;

reg MemWrited;
wire wMemWrite, wMemWriteMB0, wMemWriteMB1;
wire [31:0] wMemDataMB0, wMemDataMB1;


/*
 * Avoids writing twice in a CPU cycle, since the memory is not necessarily
 * synchronous.
 */
always @(iCLK)
begin
	MemWrited <= iCLK;
end

assign wMemWrite = (iMemWrite && ~MemWrited);
assign wMemWriteMB0 = (wMemWrite && (iAddress<32'h00001000));

assign oMemData = (iAddress<32'h00001000 ? wMemDataMB0 :
						  (iAddress<32'h00001800) ? wMemDataMB0 : ZERO);

UserCodeBlock MB0 (
	.address(iAddress[13:2]),
	.clock(iCLKMem),
	.data(iWriteData),
	.wren(wMemWriteMB0),
	.q(wMemDataMB0)
	);

endmodule
