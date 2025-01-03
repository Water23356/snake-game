NAME Displayer
$INCLUDE(common.inc)
//CANVAS_HEAND

EXTRN CODE (SendD1)
EXTRN CODE (SendD2)
EXTRN CODE (SendA1)
EXTRN CODE (SendA2)
EXTRN CODE (WaitNextFrame)

PUBLIC DrawCanvas
PUBLIC SetCanvas
PUBLIC ClearCanvas
PUBLIC SetPoint
PUBLIC Delay
	
ORG 0350H	
//------------------------------------------------------------	
//���Ƶ�
//����1: ������
//		�Ĵ������� = ��ʼ��ַ + ������/8
SetPoint:
	MOV A,param1
	MOV B,#8
	DIV AB
	//��ѯ�����Ĵ���λ��
	ADD A,#CANVAS_HEAD
	MOV R0,A
	//��ȡ������
	MOV param1,B
	LCALL GetRowData
	MOV R1,result
	//����: R0����ǻ����Ĵ����ĵ�ַ
	//		R1����ǽ�Ҫ�����ֵ
	MOV A,@R0
	ORL A,R1
	MOV @R0,A
	RET
	

//-----------------------------	
//��ȡ����������
//����1: ��ʼƫ����
//���: λ����
//ʹ����: A,R0
//�޴μ�����
GetRowData:
	MOV R7,param1
	MOV A,#00000001B
	INC R7							//����+1, Ϊ�˷�ֹѭ��������1
	SJMP _if_GetRowData_
NextMove:
	RL A
_if_GetRowData_:
	DJNZ R7,NextMove
	MOV result,A
	RET
//-----------------------------


//------------------------------------------------------------

	
//-------------------------------------------------------------
//���ƻ���
//����1: д�뻭����Ԫ�Ĵ�����ֵ
SetCanvas:
	MOV R7,#32
	MOV R0,#CANVAS_HEAD
SetLoop:
	MOV @R0,param1
	INC R0
	DJNZ R7,SetLoop
	RET
//-------------------------------------------------------------
	
//-------------------------------------------------------------
//��ջ���
ClearCanvas:
	MOV R7,#32
	MOV R0,#CANVAS_HEAD
ClearLoop:
	MOV @R0,#00H
	INC R0
	DJNZ R7,ClearLoop
	RET
//-------------------------------------------------------------

//-------------------------------------------------------------
//��Ⱦ 4�� 8x8 led����
//��ַΪ: 30H~3FH
DrawCanvas:
	MOV R2,#CANVAS_HEAD				//��״̬��
DrawRowUp:
	MOV R3,#11111110B				//��λ��
	MOV R4,#8						//��8��
DrawRowUpLoop:
	MOV A,R2
	MOV R0,A
	MOV R1,A
	INC R1
	
	MOV A,#0FFH						//����λ��
	LCALL SendA2
	MOV A,R3						
	LCALL SendA1
	
	MOV A,@R0						//������״̬��
	LCALL SendD1
	MOV A,@R1	
	LCALL SendD2
	
	INC R2
	INC R2
	MOV A,R3
	RL A
	MOV R3,A
	
	LCALL Delay						//������ʱ, ȷ����ǰ����ʾ���
	
	MOV A,#0						//���������, ��ֹ���ڲ�Ӱ
	LCALL SendD1
	MOV A,#0
	LCALL SendD2
	DJNZ R4,DrawRowUpLoop			//ѭ����Ⱦ��8��
	
//----------------------------------------------
	
	
DrawRowDown:
	MOV R3,#11111110B				//��λ��
	MOV R4,#8						//��8��
DrawRowDownLoop:
	MOV A,R2
	MOV R0,A
	MOV R1,A
	INC R1
	
	MOV A,#0FFH						//����λ��
	LCALL SendA1
	MOV A,R3						
	LCALL SendA2
	
	MOV A,@R0						//������״̬��
	LCALL SendD1
	MOV A,@R1	
	LCALL SendD2
	
	INC R2
	INC R2
	MOV A,R3
	RL A
	MOV R3,A
	
	LCALL Delay
	
	MOV A,#0						//���������, ��ֹ���ڲ�Ӱ
	LCALL SendD1
	MOV A,#0
	LCALL SendD2
	DJNZ R4,DrawRowDownLoop			//ѭ����Ⱦ��8��
	RET
//-------------------------------------------------------------


DelayShort:
	LCALL Delay
	LCALL Delay
	LCALL Delay
	LCALL Delay
	LCALL Delay
	LCALL Delay
	LCALL Delay
	LCALL Delay
	RET
Delay:
    MOV R6, #40      ; �ڲ�ѭ������
DELAY_INNER:
    DJNZ R6, DELAY_INNER  ; �ڲ�ѭ��
    MOV R7, #50      ; ���ѭ������
DELAY_OUTER:
    DJNZ R7, DELAY_OUTER  ; ���ѭ��
    RET                  ; ����

END
