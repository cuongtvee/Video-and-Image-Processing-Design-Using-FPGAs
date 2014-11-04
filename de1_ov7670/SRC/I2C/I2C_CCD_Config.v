//==========================================================
// Copyright (c) 2014 by Cuong-TV
//==========================================================
// Project  : Video and Image Processing Design Using FPGAs
// File name: I2C_CCD_Config.v 
// Author   : cuongtv
// Email	: cuongtv.ee@gmail.com - tvcuong@hcmut.edu.vn
//==========================================================
// Description

// Revision History :
// --------+----------------+-----------+--------------------------------+
//   Ver   | Author         | Mod. Date | Changes Made:					 |
// --------+----------------+-----------+--------------------------------+
//   V1.0  | Cuong-TV       | 2014/11/1 | Initial Revision               |
// --------+----------------+-----------+--------------------------------+
module I2C_CCD_Config (	//	Host Side
						iCLK,
						iRST_N,
						//iExposure,
						//	I2C Side
						I2C_SCLK,
						I2C_SDAT	);
//	Host Side
input			iCLK;
input			iRST_N;
//input	[15:0]	iExposure;
//	I2C Side
output		I2C_SCLK;
inout		I2C_SDAT;
//	Internal Registers/Wires
reg	[15:0]	mI2C_CLK_DIV;
reg	[23:0]	mI2C_DATA;
reg			mI2C_CTRL_CLK;
reg			mI2C_GO;
wire		mI2C_END;
wire		mI2C_ACK;
reg	[15:0]	LUT_DATA;
reg	[9:0]	LUT_INDEX;
reg	[3:0]	mSetup_ST;

//	Clock Setting
parameter	CLK_Freq	=	50000000;	//	50	MHz
parameter	I2C_Freq	=	20000;		//	100	KHz
//	LUT Data Number
parameter	LUT_SIZE	= 166;

/////////////////////	I2C Control Clock	////////////////////////
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		mI2C_CTRL_CLK	<=	0;
		mI2C_CLK_DIV	<=	0;
	end
	else
	begin
		if( mI2C_CLK_DIV	< (CLK_Freq/I2C_Freq) )
		mI2C_CLK_DIV	<=	mI2C_CLK_DIV+1;
		else
		begin
			mI2C_CLK_DIV	<=	0;
			mI2C_CTRL_CLK	<=	~mI2C_CTRL_CLK;
		end
	end
end
////////////////////////////////////////////////////////////////////
I2C_Controller 	u0	(	.CLOCK(mI2C_CTRL_CLK),		//	Controller Work Clock
						.I2C_SCLK(I2C_SCLK),		//	I2C CLOCK
 	 	 	 	 	 	.I2C_SDAT(I2C_SDAT),		//	I2C DATA
						.I2C_DATA(mI2C_DATA),		//	DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
						.GO(mI2C_GO),      			//	GO transfor
						.END(mI2C_END),				//	END transfor 
					  .ACK(mI2C_ACK),				//	ACK
						.RESET(iRST_N)	);
////////////////////////////////////////////////////////////////////
//////////////////////	Config Control	////////////////////////////
always@(posedge mI2C_CTRL_CLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LUT_INDEX	<=	0;
		mSetup_ST	<=	0;
		mI2C_GO		<=	0;
	end
	else
	begin
		if(LUT_INDEX<LUT_SIZE)
		begin
			case(mSetup_ST)
			0:	begin
					mI2C_DATA	<=	{8'h42,LUT_DATA};
					mI2C_GO		<=	1;
					mSetup_ST	<=	1;
				end
			1:	begin
					if(mI2C_END)
						begin
							if(1)
								mSetup_ST	<=	2;
							else
							  mSetup_ST	<=	0;							
							mI2C_GO		<=	0;
						end
					end
			2:	begin
					LUT_INDEX	<=	LUT_INDEX+1;
					mSetup_ST	<=	0;
					
				end
			endcase
		end
	end
end
////////////////////////////////////////////////////////////////////
/////////////////////	Config Data LUT	  //////////////////////////	
always
begin
	case(LUT_INDEX)
	/*
//----------------------------------------
// DATA FORMAT OUTPUT
//----------------------------------------
// FORMAT : YUV
// COM7[2]	COM7[0]	COM15[5]	COM15[4]
//		0			0			X			0

	1 : LUT_DATA	<= 16'h40e0;
//COM15	C0
	//[7:6] : DATA FORMAT OUTPUT RANGE
	//[5:4] rgb565.555 option
	2 : LUT_DATA	<= 16'h1200;//
// COM7	00
//	[1]	CLOR BAR
// {[2],[0]}	output format :
// 	00 : YUV
// 	10 : RGB
// [7] SCCB register reset. 1 RESET ALL REGISTER TO DEFAULT VALUE
//------------------------------------------	
// RESOLUTION FORMAT
//------------------------------------------
// SET YUYV
// 30FPS, VGA YUV MODE

	0 : LUT_DATA	<= 16'h3a00;
	// address	Name	default 
	// 3a			TLSB	0D
	// Linebuffer test option
	// chuoi du lie : UYVY
	//TLSB[3] = 1
		68 : LUT_DATA	<= 16'h6b01;//========
	//THEM
	//DBLV
	
	16 : LUT_DATA	<= 16'h1101;//80
// CLKRC
// hang	01
// CLKRC DEFAULT INTERNAL CLK = INPUT CLK
//[5:0] INTERNAL CLOCK PRE-SCALAR

	9 : LUT_DATA	<= 16'h0c00; //00
// COM3	00	COMMON CONTROL 3
// DIEU KHIEN ZOOM
//

	10 : LUT_DATA	<= 16'h3e00; //
// COM14	00	
// [2:0] PCLK DIVIDER (KHI COM14[4] = 1)
//	[3] MANUAL SCALING ENABLE
//	[4] DCW AND SCALING PCLK ENABLE
// 	0: NORMAL
//		1: SCALING

	11 : LUT_DATA	<= 16'h7000; //00
// SCALING_XSC	3A
//
//[6:0] HOZIZONTAL SCALE FACTOR

	12 : LUT_DATA	<= 16'h7135;
// SCALING_YSC	35
//[6:0] VERTICAL SCALE FACTOR
// SCALING_XSC[7],SCALING_YSC[7]
// 	00 : NO TEST OUTPUT
// 	01 : SHIFTING '1'
// 	10 : 8 BAR COLOR BAR
// 	11 : FADE TO GRAY COLOR

	13 : LUT_DATA	<= 16'h7211;	//
// SCALING_DWCCTR	11	DCW CONTROL
//[1:0]	HOZIZONTAL DOWN SAMPLING RATE
//[2]		HOZIZONTAL DOWN SAMPLING OPTION
//[3]		HOZIZONTAL AVRAGE CALCULATION OPTION
//[5:4]	VERTICAL DOWN SAMPLING RATE
//[6]		VERTICAL DOWN SAMPLING	OPTION
 
//[7]		VERTICAL AVERAGE CALCULATION OPTION 
		

	14 : LUT_DATA	<= 16'h73F0;	// F0
// SCALING_DIV	00
//[2:0] SCALE CONTROL : 1,2,4,8,16,

	15 : LUT_DATA	<= 16'ha202;	//A2
// SCALING PCLK DELAY	02
//	[6:0] 	SCALING OUTPUT DELAY
//#################################################	
//-------------------------------------------------
// WINDOW
//-------------------------------------------------
//HOZIZONTAL FRAME STAR, STOP
	3 : LUT_DATA	<= 16'h32b6;//
	//Name	default
	//  HREF
	// [7:6] : HREF edge offset to data output
	//	[5:3] : HREF end 3 LSB
	// [2:0] : HREF start 3 LSB 
	
	4 : LUT_DATA	<= 16'h1713;//
	// HSTART	11
	// OUTPUT FORMAT - HOZIZONTAL FRAME START HIGHT 8BIT + 3BIT HREF[2:0]
	5 : LUT_DATA	<= 16'h1801;//
	// HSTOP	61
	//// OUTPUT FORMAT - HOZIZONTAL FRAME END HIGHT 8BIT + 3BIT HREF[5:3]
// VERTICAL FRAME STAR STOP.
	6 : LUT_DATA	<= 16'h1902;//
	// VSTRT	03
	// OUTPUT FORMAT VERTICAL FRAME (ROW) START HIGHT 8 BIT + VREF[1:0]
	7 : LUT_DATA	<= 16'h1a7a;//
	// VSTRT	7B
	// OUTPUT FORMAT VERTICAL FRAME (ROW) END HIGHT 8 BIT + VREF[3:2]
	
	8 : LUT_DATA	<= 16'h030a;//
// VREF : 00	VERTICAL FRAME CONTROL
	// [7:6] : AGC[9:8]
	//[3:2] :2BIT VSTOP
	//[1:0]	2BIT VSTRT
//####################################################################3	
	
//===============================================
//GAMMA CONTROL
//===============================================
	17 : LUT_DATA	<= 16'h7a20;
//	SLOP	24	GAMMA CURVE SEGMANT SLOPE.
// SLOP[7:0] = (0X100-GAM15[7:0]*4/3)
// 0x7B-0x89 : GAM1-GAM15

	18 : LUT_DATA	<= 16'h7b1c;
	19 : LUT_DATA	<= 16'h7c28;
	20 : LUT_DATA	<= 16'h7d3c;
	21 : LUT_DATA	<= 16'h7e55;
	22 : LUT_DATA	<= 16'h7f68;
	23 : LUT_DATA	<= 16'h8076;
	24 : LUT_DATA	<= 16'h8180;
	25 : LUT_DATA	<= 16'h8288;
	26 : LUT_DATA	<= 16'h838f;
	27 : LUT_DATA	<= 16'h8496;
	28 : LUT_DATA	<= 16'h85a3;
	29 : LUT_DATA	<= 16'h86af;
	30 : LUT_DATA	<= 16'h87c4;
	31 : LUT_DATA	<= 16'h88d7;
	32 : LUT_DATA	<= 16'h89e8;
//-----------------------------------------------
	33 : LUT_DATA	<= 16'h13E0;
// COM8	8F
//	[0]	: AGC ENABLE
//	[1]	: AWB ENABLE
//	[2]	: AGC ENABLE
//	[4:3]	: NOT USE
//	[5]	: BANDING FILTER ON/OFF
// ON: BD50ST(09XD) OR BD60ST(09E  MUST BE SET TO A NON-ZERO VALUE)
//	[6]AEC STEPSIZE LIMIT. 0: STEPSIZE
//	[7]	: ENABLE FAST AGC/AEC ALGORITHM
	34 : LUT_DATA	<= 16'h0000	;//00
// AGC 00	GAIN CONTROL SETTING
// + AGC[9:0] = {AGC[7:0],VREF[7:6]}
	35 : LUT_DATA	<= 16'h1000;
// ACEH	40	EXPOSURE VALUE
//AEC[15:0] = {AECHH[7:0],ACEH[7:0],COM1[1:0]}
	36 : LUT_DATA	<= 16'h0d00;
//	COM4	00		AVERAGE OPTION
//	[5:4]	00: FULL WINDOW
//			01: 	1/2
//			10:	1/4
//			11: 	1/4
	37 : LUT_DATA	<= 16'h1418;//
// COM9 	4A
//	[6:4]	: AUTOMATIC GAIN CEILING
//	000: 2X
//[0]	: FREEZE AGC/AEC
	38 : LUT_DATA	<= 16'ha505;
// BD50MAX	0F	50HZ BANDING STEP LIMIT
	39 : LUT_DATA	<= 16'hab07;
//	BD60MAX	0F	60HZ....................
//0X21,22,23 NOT USE
	40 : LUT_DATA	<= 16'h2475;	// UPPER LIMIT
	41 : LUT_DATA	<= 16'h2563;	// LOWER LIMIT
	// 65
	// 63
//AEW	75	AGC/AEC STABLE OPERATING REGION 
	42 : LUT_DATA	<= 16'h26a5;
	// VPT D4
	// AGC/AEC FAST MODE OPERATING REGION
	43 : LUT_DATA	<= 16'h9f78;
//	HRL	C0	HIGH REFERENCE LUMINANCE	
	44 : LUT_DATA	<= 16'ha068;
//	LRL	90	LOW REFERENCE LUMINANCE	
	45 : LUT_DATA	<= 16'ha103;
// DSPC3	03	DSP CONTROL 3
	46 : LUT_DATA	<= 16'ha6df;
// LPH	F0	LOWER LIMIT OF PROBBABILITY FOR HRL
	47 : LUT_DATA	<= 16'ha7df;
// UPL	C1 UPPER LIMIT OF PROBBABILITY FOR HRL
	48 : LUT_DATA	<= 16'ha8f0;
// TPL	F0	PROBBABILITY THRESHOLD FOR HRL , AFTER EXPOSURE /GAIN
	49 : LUT_DATA	<= 16'ha990;
// TPL	C1	PROBBABILITY THRESHOLD FOR LRL , AFTER EXPOSURE /GAIN
	50 : LUT_DATA	<= 16'haa94;
// NALG	14	AEC ALGORITHM SELECTION
//[7]	0 : AVERAGE BASED AEC ALGORITHM
//		1 : HISTOGRAM BASED AEC ALGORITHM
	51 : LUT_DATA	<= 16'h13ef;//
// COM8
	52 : LUT_DATA	<= 16'h0e61;
// COMMON CONTROL 5. NO USE
	53 : LUT_DATA	<= 16'h0f4b;
// COM6	43
//	[7] : OUTPUT
	54 : LUT_DATA	<= 16'h1602;
	//55 : LUT_DATA	<= 16'h1e37;//======
	
	56 : LUT_DATA	<= 16'h2102;// NO
	57 : LUT_DATA	<= 16'h2291;// NO USE
	58 : LUT_DATA	<= 16'h2907;// NO USE
	59 : LUT_DATA	<= 16'h330b;// NO USE
	60 : LUT_DATA	<= 16'h350b;// NO USE
	61 : LUT_DATA	<= 16'h371d;// RESERVED
	62 : LUT_DATA	<= 16'h3871;// RESERVED
	63 : LUT_DATA	<= 16'h392a; // RESERVED
	
	64 : LUT_DATA	<= 16'h3c78;//78
// COM12	40
// [7] HREF OPTION
//
	65 : LUT_DATA	<= 16'h4d40;
// DM_POS 00	DUMMY ROW POSITION
// [7]	0:	DUMMY ROW IS INSERTED BEFOR ACTIVE ROW
//			1: DUMMY ROW IS INSERTED AFTER ACTIVE ROW
	66 : LUT_DATA	<= 16'h4e20; // NO USE

	67 : LUT_DATA	<= 16'h6900;
// GFIX	00	FIX GAIN CONTROL

	69 : LUT_DATA	<= 16'h7419;//19
// REG74	00
//[4] DIGITAL GAIN CONTROL SELECTION
//	0: DIGITAL GAIN CONTROL BY VREF[7:6]
// 1: DIGITAL GAIN CONTROL BY REG74[1:0]
// [1:0] DIGITAL MANUAL CONTROL
	70 : LUT_DATA	<= 16'h8d4f;//no use
	71 : LUT_DATA	<= 16'h8e00;//no use
	72 : LUT_DATA	<= 16'h8f00;//no use
	73 : LUT_DATA	<= 16'h9000;//no use
	74 : LUT_DATA	<= 16'h9100;//no use
	75 : LUT_DATA	<= 16'h9200;
// DM_LNL	00	DUMMY ROW LOW CONTROL
	76 : LUT_DATA	<= 16'h9600;//no use
	77 : LUT_DATA	<= 16'h9a80;//no use
	78 : LUT_DATA	<= 16'hb084;//no use
	79 : LUT_DATA	<= 16'hb10c;
// ABLC1	00
//	[2] : 0 DISABLE ABLC FUNTION
//			1 ENABLE
	80 : LUT_DATA	<= 16'hb20e;//no use
	81 : LUT_DATA	<= 16'hb382;
// ABLCTARGET	80
	82 : LUT_DATA	<= 16'hb80a;//no use	
//---------------------------------
// 0x45-48 , 59-5E
// AWB CONTROL 1-6, 7-12 
	83 : LUT_DATA	<= 16'h4314;
	84 : LUT_DATA	<= 16'h44f0;
	85 : LUT_DATA	<= 16'h4534;
	86 : LUT_DATA	<= 16'h4658;
	87 : LUT_DATA	<= 16'h4728;
	88 : LUT_DATA	<= 16'h483a;
//
	89 : LUT_DATA	<= 16'h5988;
	90 : LUT_DATA	<= 16'h5a88;
	91 : LUT_DATA	<= 16'h5b44;
	92 : LUT_DATA	<= 16'h5c67;
	93 : LUT_DATA	<= 16'h5d49;
	94 : LUT_DATA	<= 16'h5e0e;
//----------------------------------
	95 : LUT_DATA	<= 16'h6404;
// LCC3	10 LENCORRECTION OPTION 3
	96 : LUT_DATA	<= 16'h6520;
// LCC3	90	LENCORRECTION OPTION 4
	97 : LUT_DATA	<= 16'h6605; //05
// LCC5 00	LEN CORRECTION CONTROL
//	[0]	LEN CORRECTION ENABLE
//	[2]	LEN CORRECTION CONTROL SELECT
//		0 : RGB COMPENSATION COEFFICIENT IS SET BY REGISTER LCC3
//		1 : RGB COMPENSATION COEFFICIENT IS SET BY REGISTER LCC6,LCC3,LCC7	
	98 : LUT_DATA	<= 16'h9404;
// LCC6	50
	99 : LUT_DATA	<= 16'h9508;
// LCC7	50
//------------------------------------
// 0x6C-6F
// AWB CONTROL [3:0]
	100 : LUT_DATA	<= 16'h6c0a;
	101 : LUT_DATA	<= 16'h6d55;
	102 : LUT_DATA	<= 16'h6e11;
	103 : LUT_DATA	<= 16'h6f9f;
//-----------------------------------
	104 : LUT_DATA	<= 16'h6a40; //40
// GGAIN	00	G CHANNEL AWB GAIN
	105 : LUT_DATA	<= 16'h0140; //40
// BLUE	80		BLUE GAIN
	106 : LUT_DATA	<= 16'h0240; //40
// RED	80		RED GAIN
	107 : LUT_DATA	<= 16'h13e7;	// COM8
	
	108 : LUT_DATA	<= 16'h1500;	/// com10[6], pclk free running
// COM10	00
//	[0]	HSYNC NEGATIVE
//	[1]	VSYNC NEGATIVE
//	[2]	VSYNC OPTION
//		0: CHANGES ON FALLING EDGE OF pclk
//		1 :-----------RISING -------------
//	[3]	HREF RESERVE
//	[4]	PCLK RESERVE
//	[5]	PCLK OUTPUT OPTION
//		0 : FREE RUNNING PLCK
//		1 : PCLK DOES NOT TOGGLE DRUNG HORIZONTAL BLANK
//	[6] 	HREF CHANGES TO HSYNC
//	[7] 	RESERVED	
//------------------------------
// MATRIX COEFFICIENT 1:6
	109 : LUT_DATA	<= 16'h4f80;
	110 : LUT_DATA	<= 16'h5080;
	111 : LUT_DATA	<= 16'h5100;
	112 : LUT_DATA	<= 16'h5222;
	113 : LUT_DATA	<= 16'h535e;
	114 : LUT_DATA	<= 16'h5480;

	115 : LUT_DATA	<= 16'h589e;
// MTXS	1E	,MATRIX COEFFICIENT SIGN FOR COEFFICIENT 5 TO 0
//	[5:0]	MATRIX COEFFICIENT SIGN
//			0: PLUS
// 		1: MINUS
//	[7]	AUTO CONTRAST CENTRE ENABLE 
//		0 : DISABLE, CENTER IS SET BY REGISTER CONTRAST-CENTER(0x57)
//		1 : ENABLE, REGISTER IS UPDATED AUTOMATICALLY
	
//-------------------------------		
	116 : LUT_DATA	<= 16'h4108;
	125 : LUT_DATA	<= 16'h4138;
// COM16
// COM16	10
// [1] COLOR MATRIX COEFFICIENT DOUBLE OPTION
//		0: ORIGINAL MATRIX
//		1: DOUBLE OF ORIGINAL MATRIX	
//	[4]	DENOISE AUTO ADJUSTMENT
//		0: DISABLE	
//		1: ENABLE
//-------------------------------------------------------
//	[5] ENABLE EDGE ENHANCEMENT AUTO ADJUSTMENT FOR YUV OUTPUT
//			KQ LUU VAO THANH GHI : EDGE VA KHOANG DK LUU REG75-REG76
	117 : LUT_DATA	<= 16'h3f00;
//EDGE	88	EDGE ENHANCEMENT FACTOR
	118 : LUT_DATA	<= 16'h7540;//05
// REG75	0F	
//	[4:0]	EDGE ENHANCEMENT LOWER LIMIT
	119 : LUT_DATA	<= 16'h76e1;
// REG76	01	
//	[4:0]	EDGE ENHANCEMENT HIGHER LIMIT
//	[5]	BLACK PIXEL ENABLE
//		0: DISABLE
//		1: ENABLE
//	[6]	WHITE PIXEL ENABLE
//		0: DISABLE
//		1: ENABLE
	120 : LUT_DATA	<= 16'h4c00;
// DNSTH	00	DENOISE STRENGTH
	121 : LUT_DATA	<= 16'h7701;
//	REG77	10	OFFSET DENOISE RANGE CONTROL

	122 : LUT_DATA	<= 16'h3dc3;//
// COM13	99

//	[1] UV SWAP (USE WITH TLSB[3],COM13[1])
//	[6] UV SATURATION LEVEL	,UV AUTO ADJUSTMENT
//			KQ SAVE SATCTR[3:0](0xC9)
//	[7] GAMMA ENABLE		
	123 : LUT_DATA	<= 16'h4b09;
// REG4B	00
// [0] UV AVERAGE ENABLE
	124 : LUT_DATA	<= 16'hc960;
// SATURATION CONTROL	C0
//	[3:0]	UV SATURATION CONTROL RESULT
// [7:4] UV SATURATION CONTROL MINIUM


	126 : LUT_DATA	<= 16'h5640;
// CONTRAST CONTROL	
	
	127 : LUT_DATA	<= 16'h3411; // NO USE
// ARRAY REFERENCE CONTROL
//---------------------------------------------
	128 : LUT_DATA	<= 16'h3b02;
	164 : LUT_DATA	<= 16'h3b42;//42
// COM11
//	[1]	EXPOSURE TIMMING
//	[3]	BANDING FILTER VALUE SELECT(EFFECTIVE ONLY WHEN COM11[4]=0)
//		0: SELECT BD60ST[70](0X9E) AS BANDING FILTER VALUE
//		1: SELECT BD50ST[70](0X9D)AS BANDING FILTER VALUE
//	[4] d56_auto
//		0 : DISABLE 50/60 HZ AUTO DETECTION
// [6:5] MINIUM FRAME RATE OF NIGHT MODE
//		00 : NORMAL
//		01 : 1/2 NORMAL
//		10 :1/4
//		11 : 1.8
//	[7]	NIGHT MODE
//-----------------------------------------
	137 : LUT_DATA	<= 16'h9d4c;
// 50 HZ BANDING FILTER VALUE
	138 : LUT_DATA	<= 16'h9e3f;
// 60HZ BANDING FILTER VALUE
//----------------------------------------------
	129 : LUT_DATA	<= 16'ha489;//
// NT_CTR	00
//	[1:0]	AUTO FRAME RATE ADJUSTMENT SWITCH POINT
//		00: INSERT DUMMY ROW AT 2X GAIN
//		01: INSERT DUMMY ROW AT 4X GAIN
//		10: INSERT DUMMY ROW AT 4X GAIN
//	
//	[3]	AUTO FRAME RATE ADJUSTMENT DUMMY ROW SELECTION
//		0 : N = MAXIMUN EXPOSURE
//		1 : N = SO ROW / FRAME	
//--------------------------------------	
	130 : LUT_DATA	<= 16'h9600;// NO USE
	131 : LUT_DATA	<= 16'h9730;// NO USE
	132 : LUT_DATA	<= 16'h9820;// NO USE
	133 : LUT_DATA	<= 16'h9930;// NO USE
	134 : LUT_DATA	<= 16'h9a84;// NO USE
	135 : LUT_DATA	<= 16'h9b29;// NO USE
	136 : LUT_DATA	<= 16'h9c03;// NO USE
	139 : LUT_DATA	<= 16'h7804;// NO USE	
	140 : LUT_DATA	<= 16'h7901;// NO USE
//--------------------------------------	

	141 : LUT_DATA	<= 16'hc8f0;// NO USE
	142 : LUT_DATA	<= 16'h790f;
	143 : LUT_DATA	<= 16'hc800;
	144 : LUT_DATA	<= 16'h7910;
	145 : LUT_DATA	<= 16'hc87e;
	146 : LUT_DATA	<= 16'h790a;
	147 : LUT_DATA	<= 16'hc880;
	148 : LUT_DATA	<= 16'h790b;
	149 : LUT_DATA	<= 16'hc801;
	150 : LUT_DATA	<= 16'h790c;
	151 : LUT_DATA	<= 16'hc80f;
	152 : LUT_DATA	<= 16'h790d;
	153 : LUT_DATA	<= 16'hc820;
	154 : LUT_DATA	<= 16'h7909;
	155 : LUT_DATA	<= 16'hc880;
	156 : LUT_DATA	<= 16'h7902;
	157 : LUT_DATA	<= 16'hc8c0;
	158 : LUT_DATA	<= 16'h7903;
	159 : LUT_DATA	<= 16'hc840;
	160 : LUT_DATA	<= 16'h7905;
	161 : LUT_DATA	<= 16'hc830; 
	162 : LUT_DATA	<= 16'h7926;
//---------------------------------------	
	163 : LUT_DATA	<= 16'h0903;
// COM2	01
//	[1:0]	OUTPUT DRIVER CAPABILITY
//		00 : 1X
//		01 :	2X
//		10	:	3X
//		11	:	4X		
	164 : LUT_DATA	<= 16'h3b42;
// COM11
	//165 : LUT_DATA	<= 16'h4a40;
	*/

	0 : LUT_DATA	<=	16'h1280;
	
	1 : LUT_DATA	<= 16'h1101;
	2 : LUT_DATA	<= 16'h9200;
	3 : LUT_DATA	<= 16'h9300;
	4 : LUT_DATA	<= 16'h2a00;//
	5 : LUT_DATA	<= 16'h2b00;//
	6 : LUT_DATA	<= 16'h3b0a;//
	7 : LUT_DATA	<= 16'h9d66;//
	8 : LUT_DATA	<= 16'h9e66;//
	// TLSB[3]  = 0
	// [0] = 0
	9 : LUT_DATA	<= 16'h3a00;//
	129 : LUT_DATA	<= 16'h3dc2;//////////
	
	10 : LUT_DATA	<= 16'h40d0;//
	
	11 : LUT_DATA	<= 16'h1200;
	
	
	12 : LUT_DATA	<= 16'h1713;
	13 : LUT_DATA	<= 16'h1801;
	14 : LUT_DATA	<= 16'h32b6;
	15 : LUT_DATA	<= 16'h1902;
	16 : LUT_DATA	<= 16'h1a7a;
	17 : LUT_DATA	<= 16'h030a;//
	
	18 : LUT_DATA	<= 16'h0c00;
	19 : LUT_DATA	<= 16'h3e00;
	20 : LUT_DATA	<= 16'h703a;
	21 : LUT_DATA	<= 16'h7135;
	22 : LUT_DATA	<= 16'h7211;
	23 : LUT_DATA	<= 16'h73f0;
	24 : LUT_DATA	<= 16'ha202;
	
	25 : LUT_DATA	<= 16'h7a20;
	26 : LUT_DATA	<= 16'h7b10;
	27 : LUT_DATA	<= 16'h7c1e;
	28 : LUT_DATA	<= 16'h7d35;
	29 : LUT_DATA	<= 16'h7e5a;
	30 : LUT_DATA	<= 16'h7f69;
	31 : LUT_DATA	<= 16'h8076;
	32 : LUT_DATA	<= 16'h8180;
	33 : LUT_DATA	<= 16'h8288;
	34 : LUT_DATA	<= 16'h838f;
	35 : LUT_DATA	<= 16'h8496;
	36 : LUT_DATA	<= 16'h85a3;
	37 : LUT_DATA	<= 16'h86af;
	38 : LUT_DATA	<= 16'h87c4;//
	39 : LUT_DATA	<= 16'h88d7;
	40 : LUT_DATA	<= 16'h89e8;
	
	41 : LUT_DATA	<= 16'h13e0;//?????
	42 : LUT_DATA	<= 16'h0000;
	43 : LUT_DATA	<= 16'h1000;
	44 : LUT_DATA	<= 16'h0d60;
	45 : LUT_DATA	<= 16'h4280;
	46 : LUT_DATA	<= 16'h1418  ;
	47 : LUT_DATA	<= 16'ha507;
	48 : LUT_DATA	<= 16'hab08;
	49 : LUT_DATA	<= 16'h2444;
	50 : LUT_DATA	<= 16'h253c;
	51 : LUT_DATA	<= 16'h2682;
	52 : LUT_DATA	<= 16'h9f78;//
	53 : LUT_DATA	<= 16'ha068;
	54 : LUT_DATA	<= 16'ha103;
	55 : LUT_DATA	<= 16'ha6d8;
	56 : LUT_DATA	<= 16'ha7d8;//======
	57 : LUT_DATA	<= 16'ha8f0;
	58 : LUT_DATA	<= 16'ha990;
	59 : LUT_DATA	<= 16'haa14;
	60 : LUT_DATA	<= 16'h13e5;
	
	61 : LUT_DATA	<= 16'h0e61;
	62 : LUT_DATA	<= 16'h0f4b;
	63 : LUT_DATA	<= 16'h1602;
	64 : LUT_DATA	<= 16'h1e07 ;
	65 : LUT_DATA	<= 16'h2102;
	66 : LUT_DATA	<= 16'h2291;
	67 : LUT_DATA	<= 16'h2907;
	68 : LUT_DATA	<= 16'h330b ;
	69 : LUT_DATA	<= 16'h350b;//========
	70 : LUT_DATA	<= 16'h371d;
	71 : LUT_DATA	<= 16'h3871;
	72 : LUT_DATA	<= 16'h392a ;
	73 : LUT_DATA	<= 16'h3c78;
	74 : LUT_DATA	<= 16'h4d40;
	75 : LUT_DATA	<= 16'h4e20;
	76 : LUT_DATA	<= 16'h6900;
	77 : LUT_DATA	<= 16'h6b0a;
	78 : LUT_DATA	<= 16'h7410;
	
	79 : LUT_DATA	<= 16'h8d4f;
	80 : LUT_DATA	<= 16'h8e00;
	81 : LUT_DATA	<= 16'h8f00;
	82 : LUT_DATA	<= 16'h9000;
	83 : LUT_DATA	<= 16'h9100;
	84 : LUT_DATA	<= 16'h9600;
	85 : LUT_DATA	<= 16'h9a80;
	86 : LUT_DATA	<= 16'hb084 ;
	87 : LUT_DATA	<= 16'hb10c;
	88 : LUT_DATA	<= 16'hb20e;
	89 : LUT_DATA	<= 16'hb382;
	90 : LUT_DATA	<= 16'hb80a;
	
	91 : LUT_DATA	<= 16'h430a;
	92 : LUT_DATA	<= 16'h44f0;
	93 : LUT_DATA	<= 16'h4534;
	94 : LUT_DATA	<= 16'h4658;
	95 : LUT_DATA	<= 16'h4728;
	96 : LUT_DATA	<= 16'h483a;
	97 : LUT_DATA	<= 16'h5988;
	98 : LUT_DATA	<= 16'h5a88;
	99 : LUT_DATA	<= 16'h5b44;
	100 : LUT_DATA	<= 16'h5c67;
	101 : LUT_DATA	<= 16'h5d49;
	102 : LUT_DATA	<= 16'h5e0e;
	103 : LUT_DATA	<= 16'h6404;
	104 : LUT_DATA	<= 16'h6520;
	105 : LUT_DATA	<= 16'h6605;
	106 : LUT_DATA	<= 16'h9404;
	107 : LUT_DATA	<= 16'h9508;
	108 : LUT_DATA	<= 16'h6c0a;
	109 : LUT_DATA	<= 16'h6d55;
	110 : LUT_DATA	<= 16'h6e11;
	111 : LUT_DATA	<= 16'h6f9f ;
	
	112 : LUT_DATA	<= 16'h6a40;
	113 : LUT_DATA	<= 16'h0140;
	114 : LUT_DATA	<= 16'h0240;
	115 : LUT_DATA	<= 16'h13e7;
	
	116 : LUT_DATA	<= 16'h4f80;
	117 : LUT_DATA	<= 16'h5080;
	118 : LUT_DATA	<= 16'h5100;
	119 : LUT_DATA	<= 16'h5222;
	120 : LUT_DATA	<= 16'h535e;
	121 : LUT_DATA	<= 16'h5480;
	122 : LUT_DATA	<= 16'h589e;
	
	123 : LUT_DATA	<= 16'h4108;
	124 : LUT_DATA	<= 16'h3f00;
	125 : LUT_DATA	<= 16'h7523 ;
	126 : LUT_DATA	<= 16'h76e1;
	127 : LUT_DATA	<= 16'h4c00;
	128 : LUT_DATA	<= 16'h7700 ;
	130 : LUT_DATA	<= 16'h4b09;//
	131 : LUT_DATA	<= 16'hc960;
	132 : LUT_DATA	<= 16'h4138;
	133 : LUT_DATA	<= 16'h5640;
	
	134 : LUT_DATA	<= 16'h3411;
	135 : LUT_DATA	<= 16'ha488;
	136 : LUT_DATA	<= 16'h9600;
	137 : LUT_DATA	<= 16'h9730;
	138 : LUT_DATA	<= 16'h9820;
	139 : LUT_DATA	<= 16'h9930;
	140 : LUT_DATA	<= 16'h9a84;
	141 : LUT_DATA	<= 16'h9b29;
	142 : LUT_DATA	<= 16'h9c03;
	143 : LUT_DATA	<= 16'h7804;
	
	144 : LUT_DATA	<= 16'h7901;
	145 : LUT_DATA	<= 16'hc8f0;
	146 : LUT_DATA	<= 16'h790f;
	147 : LUT_DATA	<= 16'hc800;
	148 : LUT_DATA	<= 16'h7910;
	149 : LUT_DATA	<= 16'hc87e;
	150 : LUT_DATA	<= 16'h790a;
	151 : LUT_DATA	<= 16'hc880;
	152 : LUT_DATA	<= 16'h790b;
	153 : LUT_DATA	<= 16'hc801;
	154 : LUT_DATA	<= 16'h790c;
	155 : LUT_DATA	<= 16'hc80f;
	156 : LUT_DATA	<= 16'h790d;
	157 : LUT_DATA	<= 16'hc820;
	158 : LUT_DATA	<= 16'h7909;
	159 : LUT_DATA	<= 16'hc880;
	160 : LUT_DATA	<= 16'h7902;
	161 : LUT_DATA	<= 16'hc8c0;
	162 : LUT_DATA	<= 16'h7903; 
	163 : LUT_DATA	<= 16'hc840;

	164 : LUT_DATA	<= 16'h7905;
	
	165 : LUT_DATA	<= 16'hc830;
	
	166:	LUT_DATA	<=	16'h7926;
	
	167:	LUT_DATA	<=	16'h2d00;
	168:	LUT_DATA	<=	16'h2e00;
	

	default:LUT_DATA	<=	16'hffff;
	
	endcase
end
////////////////////////////////////////////////////////////////////
endmodule