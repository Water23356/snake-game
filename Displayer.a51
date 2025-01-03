NAME Displayer
$INCLUDE(common.inc)
//CANVAS_HEAND

EXTRN CODE (SendD1)
EXTRN CODE (SendD2)
EXTRN CODE (SendA1)
EXTRN CODE (SendA2)
EXTRN CODE (WaitNextFrame)

PUBLIC DrawCanvas
PUBLIC SetCanvas
PUBLIC ClearCanvas
PUBLIC SetPoint
PUBLIC Delay
	
ORG 0350H	
//------------------------------------------------------------	
//绘制点
//参数1: 点索引
//		寄存器索引 = 起始地址 + 点索引/8
SetPoint:
	MOV A,param1
	MOV B,#8
	DIV AB
	//查询画布寄存器位置
	ADD A,#CANVAS_HEAD
	MOV R0,A
	//获取行数据
	MOV param1,B
	LCALL GetRowData
	MOV R1,result
	//这里: R0存的是画布寄存器的地址
	//		R1存的是将要处理的值
	MOV A,@R0
	ORL A,R1
	MOV @R0,A
	RET
	

//-----------------------------	
//获取绘制行数据
//参数1: 起始偏移量
//结果: 位数据
//使用中: A,R0
//无次级调用
GetRowData:
	MOV R7,param1
	MOV A,#00000001B
	INC R7							//这里+1, 为了防止循环次数少1
	SJMP _if_GetRowData_
NextMove:
	RL A
_if_GetRowData_:
	DJNZ R7,NextMove
	MOV result,A
	RET
//-----------------------------


//------------------------------------------------------------

	
//-------------------------------------------------------------
//绘制画布
//参数1: 写入画布单元寄存器的值
SetCanvas:
	MOV R7,#32
	MOV R0,#CANVAS_HEAD
SetLoop:
	MOV @R0,param1
	INC R0
	DJNZ R7,SetLoop
	RET
//-------------------------------------------------------------
	
//-------------------------------------------------------------
//清空画布
ClearCanvas:
	MOV R7,#32
	MOV R0,#CANVAS_HEAD
ClearLoop:
	MOV @R0,#00H
	INC R0
	DJNZ R7,ClearLoop
	RET
//-------------------------------------------------------------

//-------------------------------------------------------------
//渲染 4个 8x8 led矩阵
//地址为: 30H~3FH
DrawCanvas:
	MOV R2,#CANVAS_HEAD				//行状态码
DrawRowUp:
	MOV R3,#11111110B				//行位码
	MOV R4,#8						//共8行
DrawRowUpLoop:
	MOV A,R2
	MOV R0,A
	MOV R1,A
	INC R1
	
	MOV A,#0FFH						//送入位码
	LCALL SendA2
	MOV A,R3						
	LCALL SendA1
	
	MOV A,@R0						//送入行状态码
	LCALL SendD1
	MOV A,@R1	
	LCALL SendD2
	
	INC R2
	INC R2
	MOV A,R3
	RL A
	MOV R3,A
	
	LCALL Delay						//短暂延时, 确保当前行显示完毕
	
	MOV A,#0						//清空数据码, 防止存在残影
	LCALL SendD1
	MOV A,#0
	LCALL SendD2
	DJNZ R4,DrawRowUpLoop			//循环渲染上8行
	
//----------------------------------------------
	
	
DrawRowDown:
	MOV R3,#11111110B				//行位码
	MOV R4,#8						//共8行
DrawRowDownLoop:
	MOV A,R2
	MOV R0,A
	MOV R1,A
	INC R1
	
	MOV A,#0FFH						//送入位码
	LCALL SendA1
	MOV A,R3						
	LCALL SendA2
	
	MOV A,@R0						//送入行状态码
	LCALL SendD1
	MOV A,@R1	
	LCALL SendD2
	
	INC R2
	INC R2
	MOV A,R3
	RL A
	MOV R3,A
	
	LCALL Delay
	
	MOV A,#0						//清空数据码, 防止存在残影
	LCALL SendD1
	MOV A,#0
	LCALL SendD2
	DJNZ R4,DrawRowDownLoop			//循环渲染下8行
	RET
//-------------------------------------------------------------


DelayShort:
	LCALL Delay
	LCALL Delay
	LCALL Delay
	LCALL Delay
	LCALL Delay
	LCALL Delay
	LCALL Delay
	LCALL Delay
	RET
Delay:
    MOV R6, #40      ; 内层循环次数
DELAY_INNER:
    DJNZ R6, DELAY_INNER  ; 内层循环
    MOV R7, #50      ; 外层循环次数
DELAY_OUTER:
    DJNZ R7, DELAY_OUTER  ; 外层循环
    RET                  ; 返回

END
