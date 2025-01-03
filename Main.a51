NAME Main
$INCLUDE(common.inc)	
	
EXTRN CODE (InitQueue)
EXTRN CODE (Init595)
EXTRN CODE (InitTimer)
EXTRN CODE (InitGame)

EXTRN CODE (Update)
EXTRN CODE (DrawFrame)
EXTRN CODE (DrawGameOver)
EXTRN CODE (DrawCanvas)
EXTRN CODE (ClearCanvas)
EXTRN CODE (SetCanvas)
EXTRN CODE (SetPoint)
EXTRN CODE (Test)
EXTRN CODE (InputListen)
EXTRN CODE (Delay)
EXTRN CODE (BCDHandle)
	
	
ORG 0000H
	LJMP Main
ORG 0100H	
Main:
	MOV SP,#30H
	LCALL InitQueue
	LCALL Init595
	LCALL InitTimer
	//LJMP Test
	LCALL InitGame
	MOV gameState,#2
MainLoop:
	LCALL InputListen
	MOV R0,gameState
	CJNE R0,#1,MainLoop_GameOver
	
	//SJMP _SkipWaitFrame
	JNB CP,MainLoop_SkipCanvasUpdate
	CPL CP
_SkipWaitFrame:
	LCALL Update
	LCALL DrawFrame
	
	MOV A,queueSize
	LCALL BCDHandle
	MOV P0,A
	
	LJMP MainLoop_Draw
MainLoop_SkipCanvasUpdate:	
	LCALL Delay
	LCALL Delay
MainLoop_Draw:
	LCALL DrawCanvas
	SJMP MainLoop

MainLoop_GameOver:
	MOV key,#0						//设置按键值
	LCALL InputListen				//输入监听
	MOV R0,key
	CJNE R0,#0,ResetGame			//按下任意按键重置游戏
	
	JNB CP,GameOver_DrawCanvas
	CPL CP
	LCALL DrawGameOver				//更新画布
GameOver_DrawCanvas:
	LCALL DrawCanvas				//绘制帧
	SJMP MainLoop_GameOver
	
ResetGame:
	LCALL InitQueue
	LCALL InitGame
	SJMP MainLoop
	RET
	
END
	
	