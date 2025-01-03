NAME Test
$INCLUDE (common.inc)

PUBLIC Test
	
EXTRN CODE (Enqueue)
EXTRN CODE (Dequeue)
EXTRN CODE (Contains)
	
	
ORG 1100H
Test:
	MOV param1,#13H
	LCALL Enqueue
	
	MOV param1,#15H
	LCALL Enqueue
	
	MOV param1,#16H
	LCALL Enqueue
	
	LCALL Dequeue
	
	MOV param1,#16H
	LCALL Contains
	
	LCALL Dequeue
	
	SJMP $
END