NAME Game
$INCLUDE (common.inc)
	
EXTRN CODE (InputListen)
EXTRN CODE (Enqueue)
EXTRN CODE (Dequeue)
EXTRN CODE (GetRandom)
EXTRN CODE (QueueGet)
EXTRN CODE (QueueGetLast)
EXTRN CODE (QueueGetFirst)
EXTRN CODE (Contains)
EXTRN CODE (SetPoint)
EXTRN CODE (ClearCanvas)

PUBLIC InitGame
PUBLIC Update
PUBLIC DrawFrame	
PUBLIC DrawGameOver
	
ORG 0750H
//----------------------------------------------
//游戏初始化
InitGame:
	//初始蛇的位置
	MOV param1,#24H
	LCALL Enqueue
	MOV param1,#25H
	LCALL Enqueue
	MOV param1,#26H
	LCALL Enqueue
	MOV param1,#27H
	LCALL Enqueue
	
	//初始化果实的位置
	LCALL GetRandom		
	MOV starPos,randomCounter
	
	//初始移动方向: 右
	MOV key,#1
	//初始化游戏状态
	MOV gameState,#01H
	MOV P0,gameState
	RET
//----------------------------------------------

//----------------------------------------------
//游戏帧逻辑
Update:
	//sjmp HandleFrame
	MOV A,frameCounter
	MOV B,#GAME_FRAME_MOD
	DIV AB
	MOV R0,B
	CJNE R0,#0,GameFrameEnd			//选择是否执行游戏帧逻辑						
HandleFrame:
	//获取蛇头节点地址->R1
	LCALL QueueGetLast
	MOV A,result					//获取蛇头坐标
	ADD A,key						//计算下一个位置的坐标
	MOV aimPos,A					//暂存下一个坐标的位置	
	
_IfEatSelf:
	MOV param1, aimPos					//查询目标位置是否包含身体
	LCALL Contains
	MOV A,result
	JNZ GameOver					//如果包含身体, 则说明将会咬到自己, 游戏结束
_SkipEatSelf:						
	MOV A,aimPos					//判断是否吃到星星
	SUBB A,starPos
	CJNE A,#0,SnakeMove				//没有吃到则直接移动
	MOV param1,starPos				//令蛇变长
	LCALL Enqueue					//加入队列
	LCALL GetRandom					//重置星星位置
	MOV starPos,randomCounter
	RET								//跳过移动逻辑, 直接绘制画布帧
SnakeMove:							//这里执行蛇移动的指令
	LCALL Dequeue					//移除队列头元素
	MOV param1,aimPos				//将目标坐标存入队列, 作为新的队尾
	LCALL Enqueue
	
GameFrameEnd:
	RET	
//----------------------------------------------
GameOver:
	MOV gameState,#2
	LCALL DrawGameOver
	RET
//----------------------------------------------
//绘制蛇
DrawSnake:
	MOV param7,#QUEUE_HEAD
	MOV param6,queueSize
DrawSnakeLoop:							//遍历队列
	MOV R0,param7
	MOV param1,@R0
	LCALL SetPoint
	INC param7
	DJNZ param6,DrawSnakeLoop
	RET
//----------------------------------------------

//----------------------------------------------
//绘制星星
DrawStar:
	MOV A,frameCounter
	MOV B,#3
	DIV AB
	MOV R0,B
	CJNE R0,#0,_StarDraw
	RET
_StarDraw:
	MOV param1,starPos
	LCALL SetPoint
	RET
//----------------------------------------------

//----------------------------------------------
//绘制当前游戏帧
DrawFrame:
	INC frameCounter				//帧数计数+1
	LCALL ClearCanvas
	LCALL DrawSnake
	LCALL DrawStar
	RET
//----------------------------------------------

//-----------------------------
//游戏结束画面绘制
DrawGameOver:
	MOV CANVAS_HEAD+1,	#11000000B
	MOV CANVAS_HEAD+3,	#01100000B
	MOV CANVAS_HEAD+5,	#00110000B
	MOV CANVAS_HEAD+7,	#00011000B
	MOV CANVAS_HEAD+9,	#00001100B
	MOV CANVAS_HEAD+11,	#00000110B
	MOV CANVAS_HEAD+13,	#00000011B
	MOV CANVAS_HEAD+15,	#00000001B
	
	MOV CANVAS_HEAD+0,	#00000011B
	MOV CANVAS_HEAD+2,	#00000110B
	MOV CANVAS_HEAD+4,	#00001100B
	MOV CANVAS_HEAD+6,	#00011000B
	MOV CANVAS_HEAD+8,	#00110000B
	MOV CANVAS_HEAD+10,	#01100000B
	MOV CANVAS_HEAD+12,	#11000000B
	MOV CANVAS_HEAD+14,	#10000000B
	
	MOV CANVAS_HEAD+17,	#00000011B
	MOV CANVAS_HEAD+19,	#00000110B
	MOV CANVAS_HEAD+21,	#00001100B
	MOV CANVAS_HEAD+23,	#00011000B
	MOV CANVAS_HEAD+25,	#00110000B
	MOV CANVAS_HEAD+27,	#01100000B
	MOV CANVAS_HEAD+29,	#11000000B
	MOV CANVAS_HEAD+31,	#10000000B
	
	MOV CANVAS_HEAD+16,	#11000000B
	MOV CANVAS_HEAD+18,	#01100000B
	MOV CANVAS_HEAD+20,	#00110000B
	MOV CANVAS_HEAD+22,	#00011000B
	MOV CANVAS_HEAD+24,	#00001100B
	MOV CANVAS_HEAD+26,	#00000110B
	MOV CANVAS_HEAD+28,	#00000011B
	MOV CANVAS_HEAD+30,	#00000001B
	RET
//----------------------------

END