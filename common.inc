
param1 DATA 58H						//����ͳһ�����Ĵ���
param2 DATA 59H						
param3 DATA 5AH						
param4 DATA 5BH						
param5 DATA 5CH						
param6 DATA 5DH						
param7 DATA 5EH						
result DATA 5FH						//����ͳһ����Ĵ���
	
TIMES 			EQU 10				//�궨��: ��ʱ��, ����ÿ֡���ʱ��, ֡��� = 10ms * TIMES
CP 				EQU P1.6
CPK 			EQU P1.7
CANVAS_HEAD 	EQU	60H				//������ʼ��ַ
QUEUE_HEAD		EQU 80H				//�궨��: �����׵�ַ 80H~FFH ������������
									//���д洢�����ڵ�����, ����ͷ����β, ����β����ͷ
									//��ͼ����(posIndex): ���Ͻ�index=0, ���½�index=63
									//ȡ����������:	rIndex = posIndex/8
									//ȡ����������:	cIndex = posIndex%8 
RANDOM_SEED		EQU 73				//�궨��: ���������
RANDOM_C		EQU 13				//�궨��: ���������
GAME_FRAME_MOD	EQU	5				//��Ϸ֡ģ��
MAP_SIZE		EQU 256				//��ͼ��С


queueSize 		DATA 50H			//���г���
timerCounter 	DATA 51H			//��ʱ���洢
key				DATA 52H			//����ֵ
randomCounter	DATA 53H			//��һ�������
starPos			DATA 54H			//����λ��
gameState		DATA 55H			//��Ϸ״̬
frameCounter	DATA 56H			//֡��¼��
aimPos			DATA 57H			//��ͷָ�����һ��λ��
