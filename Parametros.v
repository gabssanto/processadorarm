`define PARAM
/* Operacoes Básicas da ULA */
parameter 
	ON = 1'b1,
	OFF =1'b0,
	ZERO = 32'b00000000000000000000000000000000,

    OPAND	= 4'b0000,	//TIPO R
    OPORR	= 4'b0001,	//TIPO R

    OPADD	= 4'b0010,	//TIPO R
    OPSUB   = 4'b0011,  //TIPO R

    OPLDUR = 4'b0100,//TIPO D 
    OPSTUR = 4'b0101,//TIPO D 

    OPCBZ   = 4'b0110, //TIPO CB
    OPB     = 4'b0111;   //TIPO B