NAME Queue
$INCLUDE(common.inc)
	
PUBLIC InitQueue
PUBLIC Enqueue
PUBLIC Dequeue
PUBLIC Contains
PUBLIC QueueGet
PUBLIC QueueGetLast
PUBLIC QueueGetFirst

ORG 0500H
//---------------------------------------------[队列]---------------------------------------------
//--------------------------------
//函数:初始化队列容器
InitQueue:
	MOV queueSize,#0
	RET
//--------------------------------

//--------------------------------
//获取最后一个元素
QueueGetLast:
	MOV A,#QUEUE_HEAD
	ADD A,queueSize
	DEC A
	MOV R0,A
	MOV result,@R0
	RET
//--------------------------------

//--------------------------------
//获取第一个元素
QueueGetFirst:
	MOV R0,#QUEUE_HEAD
	MOV result,@R0
	RET
//--------------------------------

//--------------------------------
//获取队列索引为 index 的元素
//参数1: index 值
QueueGet:
	MOV A,#QUEUE_HEAD
	ADD A,param1
	MOV R0,A
	MOV result,@R0
	RET
	
//--------------------------------
//函数: 数据入队
//参数1: 将 参数1的值送入队列
//使用中: A,R1
Enqueue:
	MOV A,#QUEUE_HEAD
	ADD A,queueSize					//计算队列尾地址
	MOV R1,A
	MOV A,param1
	MOV @R1,A						//移入队尾
	INC queueSize					//队列长度变化
	RET
//--------------------------------

//--------------------------------
//函数: 出队, 将队列第一个元素移除返回
//结果: 队列第一个元素
//使用中: A,R0,R1,R2
Dequeue:	
	MOV R0,#QUEUE_HEAD
	MOV result,@R0				//队列头元素给予R3
	DEC queueSize					//队列长度变化
	MOV R2,queueSize				//循环移位, 将后面的元素向前移动一位
	MOV R0,#QUEUE_HEAD
	MOV A,R2
	JZ DequeueEnd
RemoveLoop:
	MOV A,R0
	MOV R1,A
	INC R1
	MOV A,@R1
	MOV @R0,A
	INC R0
	DJNZ R2,RemoveLoop
DequeueEnd:
	RET
//--------------------------------

//--------------------------------
//判断指定元素是否在队列中
//参数1: 查找值
//结果: 如果值存在则返回FF, 否则返回0
//使用中: A,R0
Contains:
	MOV R0,#QUEUE_HEAD
	MOV R1,queueSize				//循环计数
QueryLoop:
	CLR C
	MOV A,param1
	SUBB A,@R0
	CJNE A,#0,QueryNext	
	MOV result,#0FFH				//找到匹配值, 返回 FFH
	RET
QueryNext:
	INC R0
	DJNZ R1,QueryLoop				//如果还有剩余值未遍历
	MOV result,#00H					//遍历所有未找到目标返回 00H
	RET
//--------------------------------
END