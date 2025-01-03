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
//��Ϸ��ʼ��
InitGame:
	//��ʼ�ߵ�λ��
	MOV param1,#24H
	LCALL Enqueue
	MOV param1,#25H
	LCALL Enqueue
	MOV param1,#26H
	LCALL Enqueue
	MOV param1,#27H
	LCALL Enqueue
	
	//��ʼ����ʵ��λ��
	LCALL GetRandom		
	MOV starPos,randomCounter
	
	//��ʼ�ƶ�����: ��
	MOV key,#1
	//��ʼ����Ϸ״̬
	MOV gameState,#01H
	MOV P0,gameState
	RET
//----------------------------------------------

//----------------------------------------------
//��Ϸ֡�߼�
Update:
	//sjmp HandleFrame
	MOV A,frameCounter
	MOV B,#GAME_FRAME_MOD
	DIV AB
	MOV R0,B
	CJNE R0,#0,GameFrameEnd			//ѡ���Ƿ�ִ����Ϸ֡�߼�						
HandleFrame:
	//��ȡ��ͷ�ڵ��ַ->R1
	LCALL QueueGetLast
	MOV A,result					//��ȡ��ͷ����
	ADD A,key						//������һ��λ�õ�����
	MOV aimPos,A					//�ݴ���һ�������λ��	
	
_IfEatSelf:
	MOV param1, aimPos					//��ѯĿ��λ���Ƿ��������
	LCALL Contains
	MOV A,result
	JNZ GameOver					//�����������, ��˵������ҧ���Լ�, ��Ϸ����
_SkipEatSelf:						
	MOV A,aimPos					//�ж��Ƿ�Ե�����
	SUBB A,starPos
	CJNE A,#0,SnakeMove				//û�гԵ���ֱ���ƶ�
	MOV param1,starPos				//���߱䳤
	LCALL Enqueue					//�������
	LCALL GetRandom					//��������λ��
	MOV starPos,randomCounter
	RET								//�����ƶ��߼�, ֱ�ӻ��ƻ���֡
SnakeMove:							//����ִ�����ƶ���ָ��
	LCALL Dequeue					//�Ƴ�����ͷԪ��
	MOV param1,aimPos				//��Ŀ������������, ��Ϊ�µĶ�β
	LCALL Enqueue
	
GameFrameEnd:
	RET	
//----------------------------------------------
GameOver:
	MOV gameState,#2
	LCALL DrawGameOver
	RET
//----------------------------------------------
//������
DrawSnake:
	MOV param7,#QUEUE_HEAD
	MOV param6,queueSize
DrawSnakeLoop:							//��������
	MOV R0,param7
	MOV param1,@R0
	LCALL SetPoint
	INC param7
	DJNZ param6,DrawSnakeLoop
	RET
//----------------------------------------------

//----------------------------------------------
//��������
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
//���Ƶ�ǰ��Ϸ֡
DrawFrame:
	INC frameCounter				//֡������+1
	LCALL ClearCanvas
	LCALL DrawSnake
	LCALL DrawStar
	RET
//----------------------------------------------

//-----------------------------
//��Ϸ�����������
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