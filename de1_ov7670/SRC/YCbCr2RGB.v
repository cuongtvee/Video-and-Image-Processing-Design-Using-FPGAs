// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	YCbCr to RGB Color Doamin Converter. 
//					( 10 Bits Resolution )
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Chen       :| 05/09/05  :|      Initial Revision
// --------------------------------------------------------------------

module YCbCr2RGB
	(
	// input data
		iY,
		iCb,
		iCr,
	// output data 
		Red,
		Green,
		Blue,
	// controller
		oDVAL,		
		iDVAL,
		iRESET,
		iCLK
	);
//	Input
input [7:0] iY,iCb,iCr;
input iDVAL,iRESET,iCLK;
//	Output
output [9:0] Red,Green,Blue;
output reg	oDVAL;
//	Internal Registers/Wires
reg [9:0] oRed,oGreen,oBlue;
reg	[3:0] oDVAL_d;
reg [19:0] X_OUT,Y_OUT,Z_OUT;
wire [26:0] X,Y,Z;

assign	Red  =	oRed;
assign	Green=	oGreen;
assign	Blue =	oBlue;

always@(posedge iCLK)
begin
	if(iRESET)
	begin
		oDVAL<=0;
		oDVAL_d<=0;
		oRed<=0;
		oGreen<=0;
		oBlue<=0;
	end
	else
	begin
		// Red
		if(X_OUT[19])
		oRed<=0;
		else if(X_OUT[18:0]>1023)
		oRed<=1023;
		else
		oRed<=X_OUT[9:0];
		// Green
		if(Y_OUT[19])
		oGreen<=0;
		else if(Y_OUT[18:0]>1023)
		oGreen<=1023;
		else
		oGreen<=Y_OUT[9:0];
		// Blue
		if(Z_OUT[19])
		oBlue<=0;
		else if(Z_OUT[18:0]>1023)
		oBlue<=1023;
		else
		oBlue<=Z_OUT[9:0];
		// Control
		{oDVAL,oDVAL_d}<={oDVAL_d,iDVAL};
	end
end

always@(posedge iCLK)
begin
	if(iRESET)
	begin
		X_OUT<=0;
		Y_OUT<=0;
		Z_OUT<=0;
	end
	else
	begin
		X_OUT<=( X - 114131 ) >>7;
		Y_OUT<=( Y + 69370  ) >>7;
		Z_OUT<=( Z - 141787 ) >>7;			
	end
end

//	Y		596,		0,			817
MAC_3 u0(	iY,			iCb,		iCr,
			17'h00254,	17'h00000,	17'h00331,
			X,		iRESET,		iCLK);
//	Cb		596,		-200,		-416
MAC_3 u1(	iY,			iCb,		iCr,
			17'h00254,	17'h3FF38,	17'h3FE60,
			Y,		iRESET,		iCLK);
//	Cr		596,		1033,		0
MAC_3 u2(	iY,			iCb,		iCr,
			17'h00254,	17'h00409,	17'h00000,
			Z,		iRESET,		iCLK);

endmodule