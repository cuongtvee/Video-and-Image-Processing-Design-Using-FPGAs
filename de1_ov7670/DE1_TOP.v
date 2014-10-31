
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
assign 	LEDR = VGA_X[10:1];
//assign	LEDG	=	rCCD_DATA2;
//assign	GPIO_0		=	36'hzzzzzzzzz;
//assign	GPIO_1		=	36'hzzzzzzzzz;
//	Turn on all display
assign	HEX0		=	7'h01;
assign	HEX1		=	7'h01;
assign	HEX2		=	7'h03;
assign	HEX3		=	7'h00;
//--------------------------------------
// 					CAMERA LEFT 
//---------------------------------------
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


//---------------------------------------
// 					CAMERA RIGHT
//---------------------------------------
wire	SIO_C2;
wire	SIO_D2;
wire	SYNC2;
wire	HREF2;
wire	PCLK2;
wire	XCLK2;
wire	[7:0]	CCD_DATA2; 
// WIRE
assign	SIO_C2 = GPIO_1[22];
assign	SYNC2  = GPIO_1[24];
assign	PCLK2  = GPIO_1[26];

assign	SIO_D2 = GPIO_1[23];
assign	HREF2  = GPIO_1[25];
assign   XCLK2  = CLOCK_24;
assign   GPIO_1[27] = XCLK2;

assign	CCD_DATA2[7] = GPIO_1[28];
assign	CCD_DATA2[5] = GPIO_1[30];
assign	CCD_DATA2[3] = GPIO_1[32];
assign	CCD_DATA2[1] = GPIO_1[34];

assign	CCD_DATA2[6] = GPIO_1[29];
assign	CCD_DATA2[4] = GPIO_1[31];
assign	CCD_DATA2[2] = GPIO_1[33];
assign	CCD_DATA2[0] = GPIO_1[35];

//---------------------------------------------
// 					RESET DELAY
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
// CAMERA LEFT
I2C_CCD_Config I2C_CAMERA_LEFT
	(
	//	Host Side
		.iCLK(CLOCK_50),
		.iRST_N(DLY_RST_2),
	//iExposure,
	//	I2C Side
		.I2C_SCLK(SIO_C1),
		.I2C_SDAT(SIO_D1)	
	);
I2C_CCD_Config I2C_CAMERA_RIGHT
	(
	//	Host Side
		.iCLK(CLOCK_50),
		.iRST_N(DLY_RST_2),
	//iExposure,
	//	I2C Side
		.I2C_SCLK(SIO_C2),
		.I2C_SDAT(SIO_D2)	
	);
//------------------------------------
// DATA ACQUISITION
//------------------------------------
// FOR LEFT CAMERA
reg   [7:0]  	rCCD_DATA1;// DICH DATA VAO BO DEM
reg           	rCCD_LVAL1;// OUTPUT LINE VALID
reg           	rCCD_FVAL1;// OUTPUT FRAME VALID
always@(posedge PCLK1) 
	begin
		rCCD_DATA1	<=	CCD_DATA1;
		rCCD_FVAL1	<=	SYNC1;
		rCCD_LVAL1	<=	HREF1;		
	end
	
// FOR RIGHT CAMERA
reg   [7:0]  	rCCD_DATA2;// DICH DATA VAO BO DEM
reg           	rCCD_LVAL2;// OUTPUT LINE VALID
reg           	rCCD_FVAL2;// OUTPUT FRAME VALID
always@(posedge PCLK2) 
	begin
		rCCD_DATA2	<=	CCD_DATA2;
		rCCD_FVAL2	<=	SYNC2;
		rCCD_LVAL2	<=	HREF2;		
	end

// CAPTURE
wire	[15:0] YCbCr1;	// Camera Left YUV 4:2:2
wire	[15:0] YCbCr2;	// Camera Right YUV 4:2:2
wire				oDVAL1;// OUPUT DATA VALID
wire				oDVAL2;// OUPUT DATA VALID
wire	[7:0]	mCCD_DATA11;
wire	[7:0]	mCCD_DATA12;

wire	[7:0]	mCCD_DATA21;
wire	[7:0]	mCCD_DATA22;

wire  [10:0]	X_Cont1;
wire  [9:0]  	Y_Cont1;
wire  [31:0] 	Frame_Cont1;

wire  [10:0]	X_Cont2;
wire  [9:0]  	Y_Cont2;
wire  [31:0] 	Frame_Cont2;

//FOR CAPTURE LEFT CAMERA
CCD_Capture	CAPTURE_LEFT
	(
		.oYCbCr(YCbCr1),
		.oDATA1(mCCD_DATA11),
		.oDATA2(mCCD_DATA12),
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

//FOR CAPTURE RIGHT CAMERA

CCD_Capture	CAPTURE_RIGHT
	(
		.oYCbCr(YCbCr2),
		.oDATA1(mCCD_DATA21),
		.oDATA2(mCCD_DATA22),
		.oDVAL(oDVAL2),
		.oX_Cont(X_Cont2),
		.oY_Cont(Y_Cont2),
		.oFrame_Cont(Frame_Cont2),
	//	oPIXCLK,
		.iDATA(rCCD_DATA2),
		.iFVAL(rCCD_FVAL2),
		.iLVAL(rCCD_LVAL2),
		.iSTART(!KEY[1]),
		.iEND(!KEY[2]),
		.iCLK(PCLK2),
		.iRST(DLY_RST_1)	
	);

//-------------------------------------------------
//						SDRAM CONTRONLER
//-------------------------------------------------

// SDRAM PLL
wire	sdram_ctrl_clk;
sdram_pll 	SDRAM_PLL 	
	(
		.inclk0(CLOCK_24),
		.c0    (sdram_ctrl_clk),
		.c1    (DRAM_CLK)
	);

// DRAM CONTROL 
Sdram_Control_4Port	SDRAM	
	(
	//	HOST Side						
		.REF_CLK     	(CLOCK_50),
		.RESET_N     	(	1'b1),
		.CLK    	  		(sdram_ctrl_clk),
	//	FIFO Write Side 1
		.WR1_DATA	  (YCbCr1),//({mCCD_DATA11,mCCD_DATA12}),//(16'hFFFF),
		.WR1     	  	(oDVAL1),
		.WR1_ADDR	  	(0),
		.WR1_MAX_ADDR	(640*480),
		.WR1_LENGTH  	(9'h100),
		.WR1_LOAD	  	(!DLY_RST_0),
		.WR1_CLK	  		(PCLK1),
	//	FIFO Write Side 2
		.WR2_DATA	   (YCbCr2),//({mCCD_DATA11,mCCD_DATA12}),//(16'hFFFF),
		.WR2     	  	(oDVAL2),
		.WR2_ADDR	  	(22'h100000),
		.WR2_MAX_ADDR	(22'h100000+640*480),
		.WR2_LENGTH  	(9'h100),
		.WR2_LOAD	  	(!DLY_RST_0),
		.WR2_CLK	  		(PCLK2),
		
 //	FIFO Read Side 1
		.RD1_DATA	  	(READ_DATA1),
		.RD1			  	(VGA_Read),
		.RD1_ADDR    	(0),
		.RD1_MAX_ADDR	(640*480),
		.RD1_LENGTH  	(9'h100),
		.RD1_LOAD	  	(!DLY_RST_0),
		.RD1_CLK	  		(CLOCK_24),		//			
 //	FIFO Read Side 1	

		.RD2_DATA	  	(READ_DATA2),
		.RD2			  	(VGA_Read),
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
//					YUV 4:2:2 TO YUV 4:4:4
//-------------------------------------------------
wire	[7:0]	mY1;
wire	[7:0]	mCb1;
wire	[7:0]	mCr1;

wire	[7:0]	mY2;
wire	[7:0]	mCb2;
wire	[7:0]	mCr2;

// LEFT CAMERA
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
// RIGHT CAMERA
YUV422_to_444	YUV422to444_12
	(
	//	YUV 4:2:2 Input
		.iYCbCr(READ_DATA2),
	//	YUV	4:4:4 Output
		.oY (mY2),
		.oCb(mCb2),
		.oCr(mCr2),
	//	Control Signals
		.iX(VGA_X),
		.iCLK(CLOCK_24),
		.iRST_N(DLY_RST_0)
	);
	
//-------------------------------------------------
//					YUV TO YUV RGB
//-------------------------------------------------
wire	mDVAL1,mDVAL2;
wire	[9:0]		mR1;
wire	[9:0]		mG1;
wire	[9:0]		mB1;

wire	[9:0]		mR2;
wire	[9:0]		mG2;
wire	[9:0]		mB2;

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
//--------------------------
YCbCr2RGB YUV2RGB1
	(
	// input data
		.iY(mY2),
		.iCb(mCb2),
		.iCr(mCr2),
	// output data 
		.Red(mR2),
		.Green(mG2),
		.Blue(mB2),
	// controller
		.oDVAL(mDVAL2),
		.iDVAL(VGA_Read),
		.iRESET(!DLY_RST_2),
		.iCLK(CLOCK_24)
	);

//-------------------------------------------------
//					RGB2HSV
//-------------------------------------------------
wire [7:0] H1,S1,V1;
wire [7:0] H2,S2,V2;
RGB2HSV HSV1
	(
	// input
		.iRed(mR1), 
		.iGreen(mG1),
		.iBlue(mB1),
	// output
		.oH(H1), 
		.oS(S1), 	
		.oV(V1),		
	//control
		.iCLK(CLOCK_24),
		.iReset(KEY[0])
	);
RGB2HSV HSV2
	(
	// input
		.iRed(mR2), 
		.iGreen(mG2),
		.iBlue(mB2),
	// output
		.oH(H2), 
		.oS(S2), 	
		.oV(V2),		
	//control
		.iCLK(CLOCK_24),
		.iReset(KEY[0])
	);
	
//-------------------------------------------------
//					PROCESSING 
//-------------------------------------------------
wire	[7:0]	Distance;//
processing PROCESSING
	(
	// camera left 
		.iY1(mY1),
		.iCb1(mCb1),
		.iCr1(mCr1),
	// camera right
		.iY2(mY2),
		.iCb2(mCb2),
		.iCr2(mCr2),
		//iDVAl,		
		.iDVAL(VGA_Read),
		.oDistance(Distance),
		.iCLK(CLOCK_24),
		.iReset(KEY[0])
	);	

//-------------------------------------------------
//						VGA DISPLAY
//-------------------------------------------------
wire	[15:0]	READ_DATA1;
wire	[15:0]	READ_DATA2;
reg	[9:0]		mRed;
reg	[9:0]		mGreen;
reg	[9:0]		mBlue;
wire 				VGA_Read;// VGA REQUEST
wire	[10:0]	VGA_X;
wire	[10:0]	VGA_Y;
wire	[9:0]		oVGA_R;
wire	[9:0]		oVGA_G;
wire	[9:0]		oVGA_B;
assign	VGA_R				=	oVGA_R[9:6];
assign	VGA_G				=	oVGA_G[9:6];
assign	VGA_B				=	oVGA_B[9:6];
reg	[7:0]	rLEDG;

//-------------------------------------
always @ (posedge PCLK2)
begin
	if(SW[3:0]==3'b0000)
	begin
		mRed 		<= {mY1,2'b00};
		mGreen 	<= {mY1,2'b00};
		mBlue		<= {mY1,2'b00};
	end
	else if(SW[3:0]==3'b0001)
	begin
		mRed 		<= {mCr1,2'b00};
		mGreen 	<= {mCr1,2'b00};
		mBlue		<= {mCr1,2'b00};		
	end
	else if(SW[3:0]==3'b0010)
	begin
		mRed 		<= {mCb1,2'b00};
		mGreen 	<= {mCb1,2'b00};
		mBlue		<= {mCb1,2'b00};		
	end	
	else if(SW[3:0]==3'b0011)
	begin
		mRed 		<= mR1;
		mGreen 	<= mG1;
		mBlue		<= mB1;
	end
//------------------------------------
	else if(SW[3:0]==3'b0100)
	begin
		mRed 		<= {H1,2'b00};
		mGreen 	<= {H1,2'b00};
		mBlue		<= {H1,2'b00};
	end
	else if(SW[3:0]==3'b0101)
	begin
		mRed 		<= {S1,2'b00};
		mGreen 	<= {S1,2'b00};;
		mBlue		<= {S1,2'b00};		
	end
	else if(SW[3:0]==3'b0110)
	begin
		mRed 		<= {V1,2'b00};
		mGreen 	<= {V1,2'b00};
		mBlue		<= {V1,2'b00};
		
	end

//-----------------------------------
	// Right
	else if(SW[3:0]==3'b1000)
	begin
		mRed 		<= {mY2,2'b00};
		mGreen 	<= {mY2,2'b00};
		mBlue		<= {mY2,2'b00};
	end
	else if(SW[3:0]==3'b1001)
	begin
		mRed 		<= {mCr2,2'b00};
		mGreen 	<= {mCr2,2'b00};
		mBlue		<= {mCr2,2'b00};		
	end
	else if(SW[3:0]==3'b1010)
	begin
		mRed 		<= {mCb2,2'b00};
		mGreen 	<= {mCb2,2'b00};
		mBlue		<= {mCb2,2'b00};		
	end	
	else if(SW[3:0]==3'b1011)
	begin
		mRed 		<= mR2;
		mGreen 	<= mG2;
		mBlue		<= mB2;
	end
//------------------------------------
	else if(SW[3:0]==3'b1100)
	begin
		mRed 		<= {H2,2'b00};
		mGreen 	<= {H2,2'b00};
		mBlue		<= {H2,2'b00};
	end
	else if(SW[3:0]==3'b1101)
	begin
		mRed 		<= {S2,2'b00};
		mGreen 	<= {S2,2'b00};;
		mBlue		<= {S2,2'b00};		
	end
	else if(SW[3:0]==3'b1110)
	begin
		mRed 		<= {V2,2'b00};
		mGreen 	<= {V2,2'b00};
		mBlue		<= {V2,2'b00};
		
	end
	
	
end

wire [10:0]	data_display;
/*
Data_Display display
	(
		.iVGA_X(VGA_X),
		.iVGA_Y(VGA_Y),	
		.oData(data_display),
		.iCLK(CLOCK_24)		
	);
*/
//-----------------------------------------

VGA_Controller VGA_DISPLAY
	(
	//	Host Side
		.iRed(mRed),
		.iGreen(mGreen),
		.iBlue(mBlue),
		.oCurrent_X(VGA_X),
		.oCurrent_Y(VGA_Y),
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
/*
Line_Buffer u10	
	(
		.clken(VGA_Read),
		.clock(CLOCK_24),
		.shiftin(READ_DATA1),
		.shiftout(m3YCbCr)
	);

Line_Buffer u11	
	(
		.clken(VGA_Read),
		.clock(CLOCK_24),
		.shiftin(m3YCbCr),
		.shiftout(m4YCbCr)
	);

wire	[15:0]	m4YCbCr;
wire	[15:0]	m5YCbCr;
wire	[8:0]	Tmp1,Tmp2;
wire	[7:0]	Tmp3,Tmp4;
wire	[15:0]	m3YCbCr;
assign	Tmp1	=	m4YCbCr[7:0]+READ_DATA1[7:0];
assign	Tmp2	=	m4YCbCr[15:8]+READ_DATA1[15:8];
assign	Tmp3	=	Tmp1[8:2]+m3YCbCr[7:1];
assign	Tmp4	=	Tmp2[8:2]+m3YCbCr[15:9];
assign	m5YCbCr	=	{Tmp4,Tmp3};


	*/
	
endmodule