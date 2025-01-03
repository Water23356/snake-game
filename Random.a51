NAME Random
$INCLUDE (common.inc)
	
PUBLIC GetRandom

ORG 0950H
//获取一个随机数
//结果: 返回一个随机数->randomCounter
GetRandom:
	MOV A,randomCounter
	MOV B,#RANDOM_C
	MUL AB
	ADD A,#RANDOM_SEED
	MOV randomCounter,A
	RET
END