NAME Random
$INCLUDE (common.inc)
	
PUBLIC GetRandom

ORG 0950H
//��ȡһ�������
//���: ����һ�������->randomCounter
GetRandom:
	MOV A,randomCounter
	MOV B,#RANDOM_C
	MUL AB
	ADD A,#RANDOM_SEED
	MOV randomCounter,A
	RET
END