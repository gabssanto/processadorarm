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
module TopDE (CLK_50, 
			  KEY, 
			  HEX0, oHEX0_DP, 
			  HEX1, oHEX1_DP, 
			  HEX2, oHEX2_DP,
			  HEX3, oHEX3_DP,
			  HEX4, oHEX4_DP,
			  HEX5, oHEX5_DP,
			  HEX6, oHEX6_DP,
			  HEX7, oHEX7_DP,
			  LEDG, 
			  LEDR, 
			  SW);

/* I/O type definition */
input CLK_50;
input [3:0] KEY;
input [9:0] SW;
output [7:0] LEDG;
output [9:0] LEDR;
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
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
assign LEDG[7] =	CLK;
always @(posedge SW[5])
begin
	if(SW[5])
	begin
		LEDR[1:0] <=	Mem2Reg;
		LEDR[3:2] <=	OrigALU;
		LEDR[5:4] <=	RegDst;
		LEDR[7:6] <=	OrigPC;
		LEDR[9:8] <=	ALUOp;

	end
	else
	begin
		LEDR[0] <=	RegWrite;
		LEDR[1] <=	MemWrite;
		LEDR[2] <=	MemRead;
		LEDR[9:3] <= 6'b0;
	end
end
	
/* para apresentacao nos displays */
assign extOpcode = {26'b0,wOpcode};

/* 7 segment display register content selection */
assign wRegDispSelect =	SW[4:0];


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
				
assign wSelectPlaquinha = SW[7:6];
				
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

always @(posedge KEY[3])
begin
	CLKManual <= ~CLKManual;       // Manual
end

always @(posedge KEY[2])
begin
	CLKSelectAuto <= ~CLKSelectAuto;
end

always @(posedge KEY[1])
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
	.iCLK50(CLK_50),
	.iReset(~KEY[0]),
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
	.Out(HEX0)
	);

Decoder7 Dec1 (
	.In(wOutput[7:4]),
	.Out(HEX1)
	);

Decoder7 Dec2 (
	.In(wOutput[11:8]),
	.Out(HEX2)
	);

Decoder7 Dec3 (
	.In(wOutput[15:12]),
	.Out(HEX3)
	);

Decoder7 Dec4 (
	.In(wOutput[19:16]),
	.Out(HEX4)
	);

Decoder7 Dec5 (
	.In(wOutput[23:20]),
	.Out(HEX5)
	);

Decoder7 Dec6 (
	.In(wOutput[27:24]),
	.Out(HEX6)
	);

Decoder7 Dec7 (
	.In(wOutput[31:28]),
	.Out(HEX7)
	);

endmodule
