module YUV422_to_444	(	//	YUV 4:2:2 Input
							iYCbCr,
							//	YUV	4:4:4 Output
							oY,
							oCb,
							oCr,
							//	Control Signals
							iX,
							iCLK,
							iRST_N	);
//	YUV 4:2:2 Input
input	[15:0]	iYCbCr;
//	YUV	4:4:4 Output
output	[7:0]	oY;
output	[7:0]	oCb;
output	[7:0]	oCr;
//	Control Signals
input	[9:0]	iX;
input			iCLK;
input			iRST_N;
//	Internal Registers
reg		[7:0]	mY;
reg		[7:0]	mCb;
reg		[7:0]	mCr;

assign	oY	=	mY;
assign	oCb	=	mCb;
assign	oCr	=	mCr;

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		mY	<=	0;
		mCb	<=	0;
		mCr	<=	0;
	end
	else
	begin
		if(iX[0])
		{mCb,mY}	<=	iYCbCr;
		else
		{mCr,mY}	<=	iYCbCr;
	end
end

endmodule