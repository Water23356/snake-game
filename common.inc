
param1 DATA 58H						//函数统一参数寄存器
param2 DATA 59H						
param3 DATA 5AH						
param4 DATA 5BH						
param5 DATA 5CH						
param6 DATA 5DH						
param7 DATA 5EH						
result DATA 5FH						//函数统一结果寄存器
	
TIMES 			EQU 10				//宏定义: 计时数, 决定每帧间隔时间, 帧间隔 = 10ms * TIMES
CP 				EQU P1.6
CPK 			EQU P1.7
CANVAS_HEAD 	EQU	60H				//画布起始地址
QUEUE_HEAD		EQU 80H				//宏定义: 队列首地址 80H~FFH 队列数据区域
									//队列存储蛇所在的坐标, 队列头存蛇尾, 队列尾存蛇头
									//地图坐标(posIndex): 左上角index=0, 右下角index=63
									//取坐标行索引:	rIndex = posIndex/8
									//取坐标列索引:	cIndex = posIndex%8 
RANDOM_SEED		EQU 73				//宏定义: 随机数种子
RANDOM_C		EQU 13				//宏定义: 随机数增量
GAME_FRAME_MOD	EQU	5				//游戏帧模数
MAP_SIZE		EQU 256				//地图大小


queueSize 		DATA 50H			//队列长度
timerCounter 	DATA 51H			//计时数存储
key				DATA 52H			//按键值
randomCounter	DATA 53H			//上一个随机数
starPos			DATA 54H			//星星位置
gameState		DATA 55H			//游戏状态
frameCounter	DATA 56H			//帧记录器
aimPos			DATA 57H			//蛇头指向的下一个位置

