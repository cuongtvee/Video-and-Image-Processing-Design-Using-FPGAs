//===============================================================================
// Copyright (c) 2014 by Cuong-TV
//===============================================================================
// Project  : Video and Image Processing Design Using FPGAs
// File name: DE1_TOP.v 
// Author   : cuongtv
// Email	: cuongtv.ee@gmail.com - tvcuong@hcmut.edu.vn
//===============================================================================
// Description

// Revision History :
// --------+----------------+-----------+--------------------------------+
//   Ver   | Author         | Mod. Date | Changes Made:					 |
// --------+----------------+-----------+--------------------------------+
//   V1.0  | Cuong-TV       | 2014/11/1 | Initial Revision               |
// --------+----------------+-----------+--------------------------------+
module DE1_TOP
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_24,						//	24 MHz
		CLOCK_27,						//	27 MHz
		CLOCK_50,						//	50 MHz
		EXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		KEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		SW,								//	Toggle Switch[9:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,							//	Seven Segment Digit 0
		HEX1,							//	Seven Segment Digit 1
		HEX2,							//	Seven Segment Digit 2
		HEX3,							//	Seven Segment Digit 3
		////////////////////////	LED		////////////////////////
		LEDG,							//	LED Green[7:0]
		LEDR,							//	LED Red[9:0]
		////////////////////////	UART	////////////////////////
		UART_TXD,						//	UART Transmitter
		UART_RXD,						//	UART Receiver
		/////////////////////	SDRAM Interface		////////////////
		DRAM_DQ,						//	SDRAM Data bus 16 Bits
		DRAM_ADDR,						//	SDRAM Address bus 12 Bits
		DRAM_LDQM,						//	SDRAM Low-byte Data Mask 
		DRAM_UDQM,						//	SDRAM High-byte Data Mask
		DRAM_WE_N,						//	SDRAM Write Enable
		DRAM_CAS_N,						//	SDRAM Column Address Strobe
		DRAM_RAS_N,						//	SDRAM Row Address Strobe
		DRAM_CS_N,						//	SDRAM Chip Select
		DRAM_BA_0,						//	SDRAM Bank Address 0
		DRAM_BA_1,						//	SDRAM Bank Address 0
		DRAM_CLK,						//	SDRAM Clock
		DRAM_CKE,						//	SDRAM Clock Enable

		////////////////////	USB JTAG link	////////////////////
		TDI,  							// CPLD -> FPGA (data in)
		TCK,  							// CPLD -> FPGA (clk)
		TCS,  							// CPLD -> FPGA (CS)
	   TDO,  							// FPGA -> CPLD (data out)
	
		////////////////////	VGA		////////////////////////////
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_R,   						//	VGA Red[3:0]
		VGA_G,	 						//	VGA Green[3:0]
		VGA_B,  							//	VGA Blue[3:0]
		GPIO_0,							//	GPIO Connection 0
		GPIO_1							//	GPIO Connection 1
	);

////////////////////////	Clock Input	 	////////////////////////
input		[1:0]	CLOCK_24;				//	24 MHz
input		[1:0]	CLOCK_27;				//	27 MHz
input				CLOCK_50;				//	50 MHz
input				EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input		[3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input		[9:0]	SW;						//	Toggle Switch[9:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digit 0
output	[6:0]	HEX1;					//	Seven Segment Digit 1
output	[6:0]	HEX2;					//	Seven Segment Digit 2
output	[6:0]	HEX3;					//	Seven Segment Digit 3
////////////////////////////	LED		////////////////////////////
output	[7:0]	LEDG;					//	LED Green[7:0]
output	[9:0]	LEDR;					//	LED Red[9:0]
////////////////////////////	UART	////////////////////////////
output			UART_TXD;				//	UART Transmitter
input			UART_RXD;				//	UART Receiver
///////////////////////		SDRAM Interface	////////////////////////
inout		[15:0]	DRAM_DQ;				//	SDRAM Data bus 16 Bits
output	[11:0]	DRAM_ADDR;				//	SDRAM Address bus 12 Bits
output			DRAM_LDQM;				//	SDRAM Low-byte Data Mask 
output			DRAM_UDQM;				//	SDRAM High-byte Data Mask
output			DRAM_WE_N;				//	SDRAM Write Enable
output			DRAM_CAS_N;				//	SDRAM Column Address Strobe
output			DRAM_RAS_N;				//	SDRAM Row Address Strobe
output			DRAM_CS_N;				//	SDRAM Chip Select
output			DRAM_BA_0;				//	SDRAM Bank Address 0
output			DRAM_BA_1;				//	SDRAM Bank Address 0
output			DRAM_CLK;				//	SDRAM Clock
output			DRAM_CKE;				//	SDRAM Clock Enable
////////////////////	USB JTAG link	////////////////////////////
input  			TDI;					// CPLD -> FPGA (data in)
input  			TCK;					// CPLD -> FPGA (clk)
input  			TCS;					// CPLD -> FPGA (CS)
output 			TDO;					// FPGA -> CPLD (data out)
////////////////////////	VGA			////////////////////////////
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output	[3:0]	VGA_R;   				//	VGA Red[3:0]
output	[3:0]	VGA_G;	 				//	VGA Green[3:0]
output	[3:0]	VGA_B;   				//	VGA Blue[3:0]

////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0;					//	GPIO Connection 0
inout	[35:0]	GPIO_1;					//	GPIO Connection 1

assign	HEX0		=	7'h01;
assign	HEX1		=	7'h01;
assign	HEX2		=	7'h03;
assign	HEX3		=	7'h00;

wire	SIO_C1;
wire	SIO_D1;
wire	SYNC1;
wire	HREF1;
wire	PCLK1;
wire	XCLK1;
wire	[7:0]	CCD_DATA1; 
// WIRE
assign	SIO_C1 = GPIO_1[1];
assign	SYNC1  = GPIO_1[3];
assign	PCLK1  = GPIO_1[5];

assign	SIO_D1 = GPIO_1[0];
assign	HREF1  = GPIO_1[2];
assign  	XCLK1  = CLOCK_24;
assign  	GPIO_1[4] = XCLK1;

assign	CCD_DATA1[6] = GPIO_1[6];
assign	CCD_DATA1[7] = GPIO_1[7];
assign	CCD_DATA1[4] = GPIO_1[8];
assign	CCD_DATA1[5] = GPIO_1[9];
assign	CCD_DATA1[2] = GPIO_1[10];
assign	CCD_DATA1[3] = GPIO_1[11];
assign	CCD_DATA1[0] = GPIO_1[12];
assign	CCD_DATA1[1] = GPIO_1[13];
//---------------------------------------------
// RESET DELAY
//---------------------------------------------
wire				DLY_RST_0;
wire				DLY_RST_1;
wire				DLY_RST_2;
Reset_Delay u2	
	(	
		.iCLK  (CLOCK_50),
		.iRST  (KEY[0]),
		.oRST_0(DLY_RST_0),
		.oRST_1(DLY_RST_1),
		.oRST_2(DLY_RST_2)
	);
//--------------------------------
// CONFIG I2C
//--------------------------------
always@(posedge OSC_50)	clk_25	<=	~clk_25;
reg clk_25;
assign CLK_25 = clk_25;

I2C_AV_Config CCD_CF
(
	//Global clock
	.iCLK(CLK_25),		//25MHz
	.iRST_N(DLY_RST_2),		//Global Reset
	
	//I2C Side
	.I2C_SCLK(SIO_C1),
	.I2C_SDAT(SIO_D1),	
	.Config_Done(config_done2),//Config Done
	.I2C_RDATA(I2C_RDATA2)	//I2C Read Data
);

//------------------------------------
// DATA ACQUISITION
//------------------------------------

reg   [7:0]  	rCCD_DATA1;// DICH DATA VAO BO DEM
reg           	rCCD_LVAL1;// OUTPUT LINE VALID
reg           	rCCD_FVAL1;// OUTPUT FRAME VALID
always@(posedge PCLK1) 
	begin
		rCCD_DATA1	<=	CCD_DATA1;
		rCCD_FVAL1	<=	SYNC1;
		rCCD_LVAL1	<=	HREF1;		
	end

// CAPTURE
wire	[15:0] YCbCr1;	// Camera Left YUV 4:2:2
wire	[15:0] YCbCr2;	// Camera Right YUV 4:2:2
wire				oDVAL1;// OUPUT DATA VALID
wire				oDVAL2;// OUPUT DATA VALID
wire	[7:0]	mCCD_DATA11;
wire	[7:0]	mCCD_DATA12;

wire  [10:0]	X_Cont1;
wire  [9:0]  	Y_Cont1;
wire  [31:0] 	Frame_Cont1;
CCD_Capture	CAMERA_DECODER
	(
		.oYCbCr(YCbCr1),
		.oDVAL(oDVAL1),
		.oX_Cont(X_Cont1),
		.oY_Cont(Y_Cont1),
		.oFrame_Cont(Frame_Cont1),
	//	oPIXCLK,
		.iDATA(rCCD_DATA1),
		.iFVAL(rCCD_FVAL1),
		.iLVAL(rCCD_LVAL1),
		.iSTART(!KEY[1]),
		.iEND(!KEY[2]),
		.iCLK(PCLK1),
		.iRST(DLY_RST_1)	
	);	

// SDRAM PLL
wire	sdram_ctrl_clk;
sdram_pll 	SDRAM_PLL 	
	(
		.inclk0(CLOCK_24),
		.c0    (sdram_ctrl_clk),
		.c1    (DRAM_CLK)
	);

// DRAM CONTROL 
Sdram_Control_4Port	SDRAM_FRAME_BUFFER
	(
	//	HOST Side						
		.REF_CLK     	(CLOCK_50),
		.RESET_N     	(	1'b1),
		.CLK    	(sdram_ctrl_clk),
	//	FIFO Write Side 1
		.WR1_DATA	(YCbCr1),
		.WR1     	(oDVAL1),
		.WR1_ADDR	(0),
		.WR1_MAX_ADDR	(640*480),
		.WR1_LENGTH  	(9'h100),
		.WR1_LOAD	(!DLY_RST_0),
		.WR1_CLK	(PCLK1),
	//	FIFO Write Side 2
		.WR2_DATA	(YCbCr2), // for dual camera
		.WR2     	(oDVAL2),
		.WR2_ADDR	(22'h100000),
		.WR2_MAX_ADDR	(22'h100000+640*480),
		.WR2_LENGTH  	(9'h100),
		.WR2_LOAD	(!DLY_RST_0),
		.WR2_CLK	 (PCLK2),
		
 //	FIFO Read Side 1
		.RD1_DATA	  	(READ_DATA1),
		.RD1			(VGA_Read),
		.RD1_ADDR    	(0),
		.RD1_MAX_ADDR	(640*480),
		.RD1_LENGTH  	(9'h100),
		.RD1_LOAD	  	(!DLY_RST_0),
		.RD1_CLK	  		(CLOCK_24),		//			
 //	FIFO Read Side 1	

		.RD2_DATA	  	(READ_DATA2),
		.RD2			(VGA_Read),
		.RD2_ADDR    	(22'h100000),
		.RD2_MAX_ADDR	(22'h100000+640*480),
		.RD2_LENGTH  	(9'h100),
		.RD2_LOAD	  	(!DLY_RST_0),
		.RD2_CLK	  		(CLOCK_24),		//	
		
 //	SDRAM Side
      .SA			  	(DRAM_ADDR),
		.BA			  	({DRAM_BA_1,DRAM_BA_0}),
		.CS_N		  		(DRAM_CS_N),
      .CKE			  	(DRAM_CKE),
		.RAS_N		  	(DRAM_RAS_N),
		.CAS_N		  	(DRAM_CAS_N),
		.WE_N		  		(DRAM_WE_N),
		.DQ			  	(DRAM_DQ),
		.DQM			  	({DRAM_UDQM,DRAM_LDQM})
	);
//-------------------------------------------------
//	YUV 4:2:2 TO YUV 4:4:4
//-------------------------------------------------
wire	[7:0]	mY1;
wire	[7:0]	mCb1;
wire	[7:0]	mCr1;

wire	[7:0]	mY2;
wire	[7:0]	mCb2;
wire	[7:0]	mCr2;

YUV422_to_444	YUV422to444
	(
	//	YUV 4:2:2 Input
		.iYCbCr(READ_DATA1),
	//	YUV	4:4:4 Output
		.oY (mY1),
		.oCb(mCb1),
		.oCr(mCr1),
	//	Control Signals
		.iX(VGA_X),
		.iCLK(CLOCK_24),
		.iRST_N(DLY_RST_0)
	);

wire	mDVAL1,mDVAL2;
wire	[9:0]		mR1;
wire	[9:0]		mG1;
wire	[9:0]		mB1;

YCbCr2RGB YUV2RGB
	(
	// input data
		.iY(mY1),
		.iCb(mCb1),
		.iCr(mCr1),
	// output data 
		.Red(mR1),
		.Green(mG1),
		.Blue(mB1),
	// controller
		.oDVAL(mDVAL),
		.iDVAL(VGA_Read),
		.iRESET(!DLY_RST_2),
		.iCLK(CLOCK_24)
	);
VGA_Controller VGA_DISPLAY
	(
	//	Host Side
		.iRed(mR1),
		.iGreen(mG1),
		.iBlue(mB1),
		//.oCurrent_X(VGA_X),
		//.oCurrent_Y(VGA_Y),
		.oRequest(VGA_Read),		
	//	VGA Side
		.oVGA_R(oVGA_R),
		.oVGA_G(oVGA_G),
		.oVGA_B(oVGA_B),
		.oVGA_HS(VGA_HS),
		.oVGA_VS(VGA_VS),
	//	Control Signal
		.iCLK(CLOCK_24),
		.iRST_N(DLY_RST_2)	
	);

endmodule
