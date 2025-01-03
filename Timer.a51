NAME Timer
$INCLUDE (common.inc)

PUBLIC TIMES
PUBLIC InitTimer
PUBLIC WaitNextFrame

ORG 000BH
	LJMP Timer_0
ORG 0450H
InitTimer:
//定时器初始化
	MOV TMOD,#00H	
	MOV timerCounter, #TIMES
	MOV TH0,#HIGH(65536-1000);
	MOV TL0,#LOW(65536-1000);
	SETB EA
	SETB ET0
	SETB TR0
	RET


//定时器, 时钟脉冲模块
Timer_0:
	DEC timerCounter
	MOV A,timerCounter
	JNZ TimerReturn
	MOV timerCounter,#TIMES
	CPL CPK
	CPL CP
TimerReturn:
	RETI
	
WaitNextFrame:
	JNB CP,$
	CLR CP
	RET
	
END