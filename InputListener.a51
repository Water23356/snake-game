NAME InputListener
$INCLUDE (common.inc)
	
PUBLIC InputListen
	
ORG 0550H
	
	
InputListen:
	MOV R0,key
	JNB P1.0,InputUp
	JNB P1.1,InputLeft
	JNB P1.2,InputDown
	JNB P1.3,InputRight
	RET
InputUp:
	MOV key,#-16
	RET
InputLeft:
	MOV key,#-1
	RET
InputDown:
	MOV key,#16
	RET
InputRight:
	MOV key,#1
	RET
	
END