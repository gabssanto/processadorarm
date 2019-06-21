/*
 TopDE
 
 Top Level para processador MIPS UNICICLO v0 baseado no processador 
 desenvolvido por 
Alexandre Lins 	09/40097
Daniel Dutra 	09/08436
Yuri Maia 	09/16803
em 2010/1 na disciplina OAC

 Adaptado para a placa de desenvolvimento DE2-70.
 Prof. Marcus Vinicius Lamar   2010/2

 */
module TopDE (iCLK_50, 
			  iKEY, 
			  oHEX0_D, oHEX0_DP, 
			  oHEX1_D, oHEX1_DP, 
			  oHEX2_D, oHEX2_DP,
			  oHEX3_D, oHEX3_DP,
			  oHEX4_D, oHEX4_DP,
			  oHEX5_D, oHEX5_DP,
			  oHEX6_D, oHEX6_DP,
			  oHEX7_D, oHEX7_DP,
			  oLEDG, 
			  oLEDR, 
			  iSW);

/* I/O type definition */
input iCLK_50;
input [3:0] iKEY;
input [9:0] iSW;
output [7:0] oLEDG;
output [9:0] oLEDR;
output [6:0] oHEX0_D, oHEX1_D, oHEX2_D, oHEX3_D, oHEX4_D, oHEX5_D, oHEX6_D, oHEX7_D;
output oHEX0_DP, oHEX1_DP, oHEX2_DP, oHEX3_DP, oHEX4_DP, oHEX5_DP, oHEX6_DP, oHEX7_DP;

/* Local Clock signals */
reg CLKManual, CLKAutoSlow, CLKSelectAuto, CLKSelectFast, CLKAutoFast, CLK_5;
wire CLK, clock50_ctrl;

integer CLKCount, CLKCount2, CLKCount5;

/* Local wires */
wire [63:0] PC, wRegDisp, wRegA0, extOpcode, extFunct, wOutput,  wDebug;
wire [31:0] wInstr;
wire [1:0] ALUOp,OrigALU, RegDst, Mem2Reg, OrigPC;
wire MemWrite, MemRead, RegWrite;
wire [4:0] wRegDispSelect;
wire [10:0] wOpcode;
wire [1:0] wSelectPlaquinha;

 
/* LEDs sinais de controle */
//assign oLEDG[7:0] =	PC[9:2];
assign oLEDG[7] =	CLK;
always @(posedge iSW[5])
begin
	if(iSW[5])
	begin
		oLEDR[1:0] <=	Mem2Reg;
		oLEDR[3:2] <=	OrigALU;
		oLEDR[5:4] <=	RegDst;
		oLEDR[7:6] <=	OrigPC;
		oLEDR[9:8] <=	ALUOp;

	end
	else
	begin
		oLEDR[0] <=	RegWrite;
		oLEDR[1] <=	MemWrite;
		oLEDR[2] <=	MemRead;
		oLEDR[9:3] <= 6'b0;
	end
end
	
/* para apresentacao nos displays */
assign extOpcode = {26'b0,wOpcode};

/* 7 segment display register content selection */
assign wRegDispSelect =	iSW[4:0];


/* $a0 initial content, with signal extention */
//assign wRegA0 = {{24{iSW[7]}},iSW[7:0]};


/*assign wOutput	= iSW[12] ?
				(iSW[17] ?
					PC :
					(iSW[16] ?
						wInstr :
						(iSW[15] ?
							extOpcode :
							(iSW[14] ?
								extFunct :
								(iSW[13]?
								wDebug:
								32'h08888880)
							)
						)
					)
				) :
				wRegDisp;*/
				
assign wSelectPlaquinha = iSW[7:6];
				
always @(wSelectPlaquinha)
begin
	case(wSelectPlaquinha)
		2'd0: wOutput <= PC;
		2'd1: wOutput <= wInstr;
		2'd2: wOutput <= extOpcode;
		2'd3: wOutput <= wRegDisp;
	endcase
end
/* Clocks */
assign CLK	= CLKSelectAuto ?
				(CLKSelectFast ?
					CLKAutoFast :
					CLKAutoSlow) :
				CLKManual;

/* Clock inicializacao */
initial
begin
	CLKManual	<= 1'b0;
	CLKAutoSlow	<= 1'b0;
	CLKAutoFast	<= 1'b0;
	CLKSelectAuto	<= 1'b0;
	CLKSelectFast	<= 1'b0;
	CLK_5 <= 1'b0;
end

always @(posedge iKEY[3])
begin
	CLKManual <= ~CLKManual;       // Manual
end

always @(posedge iKEY[2])
begin
	CLKSelectAuto <= ~CLKSelectAuto;
end

always @(posedge iKEY[1])
begin
	CLKSelectFast <= ~CLKSelectFast;
end

always @(posedge clock50_ctrl)
begin

	if(CLKCount5 == 32'd4)   // Clock da memoria
	begin
		CLK_5 = ~CLK_5;
		CLKCount5 = 0;
	end
	else
	begin
		CLKCount5 = CLKCount5 + 1;
	end

	if (CLKCount == 32'd9999999)	// Slow
	begin
		CLKAutoSlow = ~CLKAutoSlow;
		CLKCount = 0;
	end
	else
	begin
		CLKCount = CLKCount + 1;
	end
	
	if (CLKCount2 == 32'd30)  //  Fast
	begin
		CLKAutoFast = ~CLKAutoFast;
		CLKCount2 = 0;
	end
	else
	begin
		CLKCount2 = CLKCount2 + 1;
	end
	
end


/* Mono est�vel 10 segundos */
//mono Mono1 (iCLK_50,~iSW[10],clock50_ctrl,~iKEY[0]);


/* MIPS Datapath instantiation */

DataPath Datapath0 (
	.iCLK(CLK),
	.iCLKMemory(CLK_5),
	.iCLK50(iCLK_50),
	.iReset(~iKEY[0]),
	.wPC(PC),
	.wControlALUOp(ALUOp),
	.wControlMemWrite(MemWrite),
	.wControlMemRead(MemRead),
	.wControlRegWrite(RegWrite),
	.wControlReg2Loc(RegDst),
	.wRegisterShowSelect(wRegDispSelect),
	.wRegisterShow(wRegDisp),
	.wControlOpcode(wOpcode),
	.woInstruction(wInstr),
	.wControlALUSrc(OrigALU),
	.wControlMemtoReg(Mem2Reg),
	.wControlOrigemPC(OrigPC)
	//.wDebug(wDebug)	
);
	
/* 7 segment display instantiations */

assign oHEX0_DP=1'b1;
assign oHEX1_DP=1'b1;
assign oHEX2_DP=1'b1;
assign oHEX3_DP=1'b1;
assign oHEX4_DP=1'b1;
assign oHEX5_DP=1'b1;
assign oHEX6_DP=1'b1;
assign oHEX7_DP=1'b1;

Decoder7 Dec0 (
	.In(wOutput[3:0]),
	.Out(oHEX0_D)
	);

Decoder7 Dec1 (
	.In(wOutput[7:4]),
	.Out(oHEX1_D)
	);

Decoder7 Dec2 (
	.In(wOutput[11:8]),
	.Out(oHEX2_D)
	);

Decoder7 Dec3 (
	.In(wOutput[15:12]),
	.Out(oHEX3_D)
	);

Decoder7 Dec4 (
	.In(wOutput[19:16]),
	.Out(oHEX4_D)
	);

Decoder7 Dec5 (
	.In(wOutput[23:20]),
	.Out(oHEX5_D)
	);

Decoder7 Dec6 (
	.In(wOutput[27:24]),
	.Out(oHEX6_D)
	);

Decoder7 Dec7 (
	.In(wOutput[31:28]),
	.Out(oHEX7_D)
	);

endmodule
