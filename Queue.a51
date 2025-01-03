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
//---------------------------------------------[����]---------------------------------------------
//--------------------------------
//����:��ʼ����������
InitQueue:
	MOV queueSize,#0
	RET
//--------------------------------

//--------------------------------
//��ȡ���һ��Ԫ��
QueueGetLast:
	MOV A,#QUEUE_HEAD
	ADD A,queueSize
	DEC A
	MOV R0,A
	MOV result,@R0
	RET
//--------------------------------

//--------------------------------
//��ȡ��һ��Ԫ��
QueueGetFirst:
	MOV R0,#QUEUE_HEAD
	MOV result,@R0
	RET
//--------------------------------

//--------------------------------
//��ȡ��������Ϊ index ��Ԫ��
//����1: index ֵ
QueueGet:
	MOV A,#QUEUE_HEAD
	ADD A,param1
	MOV R0,A
	MOV result,@R0
	RET
	
//--------------------------------
//����: �������
//����1: �� ����1��ֵ�������
//ʹ����: A,R1
Enqueue:
	MOV A,#QUEUE_HEAD
	ADD A,queueSize					//�������β��ַ
	MOV R1,A
	MOV A,param1
	MOV @R1,A						//�����β
	INC queueSize					//���г��ȱ仯
	RET
//--------------------------------

//--------------------------------
//����: ����, �����е�һ��Ԫ���Ƴ�����
//���: ���е�һ��Ԫ��
//ʹ����: A,R0,R1,R2
Dequeue:	
	MOV R0,#QUEUE_HEAD
	MOV result,@R0				//����ͷԪ�ظ���R3
	DEC queueSize					//���г��ȱ仯
	MOV R2,queueSize				//ѭ����λ, �������Ԫ����ǰ�ƶ�һλ
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
//�ж�ָ��Ԫ���Ƿ��ڶ�����
//����1: ����ֵ
//���: ���ֵ�����򷵻�FF, ���򷵻�0
//ʹ����: A,R0
Contains:
	MOV R0,#QUEUE_HEAD
	MOV R1,queueSize				//ѭ������
QueryLoop:
	CLR C
	MOV A,param1
	SUBB A,@R0
	CJNE A,#0,QueryNext	
	MOV result,#0FFH				//�ҵ�ƥ��ֵ, ���� FFH
	RET
QueryNext:
	INC R0
	DJNZ R1,QueryLoop				//�������ʣ��ֵδ����
	MOV result,#00H					//��������δ�ҵ�Ŀ�귵�� 00H
	RET
//--------------------------------
END