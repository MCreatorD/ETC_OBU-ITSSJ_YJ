;******************************************************************
;������MF��Ƭ������չ����
;_FUN_MF_Rc500Auth		---	��֤����
;_FUN_MF_Rc500Read		---	����
;_FUN_MF_Rc500Write		---	д��
;_FUN_MF_Rc500Decrement		---	�ۿ�
;_FUN_MF_Rc500Transfer		---	����
;_FUN_MF_RC500Restore		---	���ݿ�
;_FUN_MF_Channel	---	MF����֤���ϲ���

;;������ϵ
;	_FUN_MF_Channel 
;		| 
;	_FUN_MF_Rc500Auth-- Err -->���� XX F1
;		|(OK)
;		|
;		|--->_FUN_MF_Rc500Read -> Err -->���� 00 FF
;		|		|(OK) 
;		|		����--> 00  00 	[16 Byte����]
;		|
;		|--->_FUN_MF_Rc500Write -> Err -->���� 01 FF
;		|		|(OK)
;		|		����--> 01 00
;		|
;		|--->_FUN_MF_Rc500Decrement -> Err--->���� 02 FF 
;		|		|(OK)
;		|		����--> 02 00
;		|
;		|--->_FUN_MF_Rc500Increment -> Err--->���� 03 FF 
;		|		|(OK)
;		|		����--> 03 00
;		|
;		|--->_FUN_MF_RC500Restore -> Err--->���� 04 FF 
;				|(OK)
;				����--> 04 00 

;******************************************************************
NAME	MFCard

$INCLUDE(COMMON.INC)
$INCLUDE(MFCard.INC)

	RSEG	?pr?MFCard?Mater
	USING	0
	
;--------------------------------------------------------------------------
;����:	��֤
;�ⲿ����:
;	R6		---	��ԿA/B(0/1)   
;	R4		---	Block number 
;	R5		---	6 byte��Կ(�ڴ�)
;	DATA_CardNO	---	����(�ڴ�)
;����ֵ:
;	R7		--- 	=0 ��ʾִ�гɹ�;=ff ��ʾִ��ʧ��
;--------------------------------------------------------------------------	
_FUN_MF_Rc500Auth:

	ret

_Rc500Autherr:
	mov	r7,#0FFh
	ret		
;--------------------------------------------------------------------------
;����:	����
;�ⲿ����
;	R4		---	��ȡ����
;	R5		---	��Ŷ�ȡ����緳�ָ��
;	BIT_BUFADDR	---	�������ݴ�����ڴ棬��������ʶ;��ʾ��ǰ�����Ĵ洢��,=0�ڴ�;=1���
;����ֵ:
;	R7		--- 	=0 ��ʾִ�гɹ�;=ff ��ʾִ��ʧ��
;--------------------------------------------------------------------------	
;r7: ����״̬,r5:buf of addr , r4;block addr
_FUN_MF_Rc500Read:

	RET

;--------------------------------------------------------------------------
;����:	д��
;�ⲿ����

;	R4		---	��ȡ����
;	R5		---	��Ŷ�ȡ����緳�ָ��
;	BIT_BUFADDR	---	д�����ݴ�����ڴ棬��������ʶ;��ʾ��ǰ�����Ĵ洢��,=0�ڴ�;=1���

;�ڲ�����:
;	XXX
;����ֵ
;	R7		--- 	=0 ��ʾִ�гɹ�;=ff ��ʾִ��ʧ��
;--------------------------------------------------------------------------	
;r7 ����״̬,r5:buf of addr , r4;block addr
_FUN_MF_Rc500Write:

	RET	
	
;--------------------------------------------------------------------------
;����:	����
;�ⲿ����
;	R4		---	���ѿ���
;	R5		---	��Ž��緳�ָ��(�ڴ�)
;����ֵ
;	R7		--- 	=0 ��ʾִ�гɹ�;=ff ��ʾִ��ʧ��
;--------------------------------------------------------------------------
;r7: ����״̬,r5:buf of addr, r4;block addr
_FUN_MF_Rc500Decrement:

	
	RET
;--------------------------------------------------------------------------
;����:	����
;�ⲿ����
;	R4		---	��Ҫȷ��ִ��ָ��Ŀ��
;����ֵ:
;	R7		--- 	=0 ��ʾִ�гɹ�;=ff ��ʾִ��ʧ��
;--------------------------------------------------------------------------
_FUN_MF_Rc500Transfer:

	ret

;--------------------------------------------------------------------------
;����:	���ݿ�
;�ⲿ����
;	R4		---	��Ҫ���ݵĿ��;	
;����ֵ
;	R7		--- 	=0 ��ʾִ�гɹ�;=ff ��ʾִ��ʧ��
;--------------------------------------------------------------------------
_FUN_MF_RC500Restore:

	RET

;--------------------------------------------------------------------------
;����:	MF����֤���ϲ���
;�ⲿ����
;	R7	---	ָ��緳�ָ��(�ڴ�) (ָ������ ������   ���     "A"/"B"(41H|42H)   ��Կ + UUU
;					����	ָ������ = 00 ,UUU = ��
;					д��	ָ������ = 01 ,UUU = 16 Byte Data
;					�ۿ�	ָ������ = 02 ,UUU = 4 Byte ���
;					��ֵ 	ָ������ = 03 ,UUU = 4 Byte ���
;					����	ָ������ = 04 ,UUU = Ŀ����
;	R5	---	��Ӧ緳�ָ��(���)
;					����	��ȷ���� 00 00 16 Byte	���󷵻� 00 FF
;					д��	��ȷ���� 01 00 		���󷵻� 01 FF
;					�ۿ�	��ȷ���� 02 00 		���󷵻� 02 FF
;					��ֵ 	��ȷ���� 03 00 		���󷵻� 03 FF
;					����	��ȷ���� 04 00 		���󷵻� 04 FF
;����ֵ
;	R3	---	���ػ�Ӧ緳����ݳ���
;--------------------------------------------------------------------------	
_FUN_MF_Channel:


	MOV	A,#CONST_STATE_FALSE

	MOV	AR0,AR5
	
	MOV	A,#0FFH
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	INC	R0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A

		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	MOV	R3,#2
	JMP	MF_Channel_Over 				; ����ָ��
	RET

;-------------------------------------------------------------


;	MOV	AR1,AR7
;	MOV	AR0,AR5

;	MOV	A,@R1						; R1[0] ָ������
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,R0
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A						; R0[0] ָ������
;	INC	R0						; R0[1]
		
;MF_Channel_AuthRead:
	
;	MOV	A,R3
;	XRL	A,#03H
;	JNZ	MF_Channel_NeedAuth01
;	JMP	MF_Channel_AUTHOK	;����Ҫ��֤��ֱ����ת	
	
MF_Channel_NeedAuth01:
;	MOV	A,R3
;	XRL	A,#04H
;	JNZ	MF_Channel_NeedAuth02
;	JMP	MF_Channel_AUTHOK	;����Ҫ��֤��ֱ����ת	
		
MF_Channel_NeedAuth02:
;	MOV	A,R3
;	XRL	A,#07H
;	JNZ	MF_Channel_NeedAuth03
;	JMP	MF_Channel_AUTHOK	;����Ҫ��֤��ֱ����ת	
MF_Channel_NeedAuth03:
;	MOV	A,R3
;	XRL	A,#13H
;	JNZ	MF_Channel_NeedAuth04
	
;	JMP	MF_Channel_AUTHOK	;����Ҫ��֤��ֱ����ת
MF_Channel_NeedAuth04:			;��Ҫ��֤
			
			
			
			
			
;	PUSH	AR0
;	PUSH	AR1
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,@R1
	;XRL	A,#2
	;JNZ	MF_Channel_Consume
	;INC	R1
	;INC	R1
	;MOV	A,@R1	
	;CALL	_FUN_TEST_DISPLAY
;MF_Channel_Consume:		
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
;	INC	R1						; R1[1] ������
;	INC	R1						; R1[2] ���	
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,@R1
;	MOV	A,@R1
;	XRL	A,#9
;	JNZ	MF_Channel_Consume
;;	mov	a,#9
;	dec	r1
;	dec	r1
;	MOV	A,@R1
;	CALL	_FUN_TEST_DISPLAY
;MF_Channel_Consume:	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
	
;	MOV	A,@R1
;	MOV	R4,A						; ���

;	INC	R1						; R1[3] ��Կ����
;	MOV	A,@R1
;	ANL	A,#01H						; 0000 0001
;	XRL	A,#01H						; 
;	MOV	R6,A						; 
	
;	INC	R1						; R1[3]	��Կ
;	MOV	AR5,AR1						;
	
;	CALL	_FUN_MF_Rc500Auth
;	POP	AR1
;	POP	AR0
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,@R1
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
;	MOV	A,R7
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,#35
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
;	JZ	MF_Channel_AUTHOK
MF_Channel_AUTHERR:						; ��֤ʧ��
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,#35
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	
;	MOV	A,#CONST_STATE_AUTHER
;		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A	
;;	MOV	R3,#02H						; �������ݳ���=2 
;	JMP	MF_Channel_Over
	
MF_Channel_AUTHOK:						; ��֤ͨ��	
;	
;	MOV	A,@R1						; R1[0] ָ������	
;	INC	R1						; R1[1] ������
;	INC	R1						; R1[2] ���	
	
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,#35
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	
;************************************************************************************************
MF_Channel_Read:	; �������
;	CJNE	A,#CONST_MF_READ,MF_Channel_Write	
	
	;R7: ����״̬,R5:BUF Of Addr , R4;Block Addr
;	MOV	A,@R1						; R1[2] ���
;	MOV	R4,A	 	;
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,#36
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
;	PUSH	AR0						; R0[1] ָ��ִ��״̬
;	INC	R0						; R0[2] ָ��ӷ���
;	MOV	AR5,AR0						; R0[2]
;	SETB	BIT_BUFADDR					; �����ݴ浽���
;;	CALL	_FUN_MF_Rc500Read
;	POP	AR0						; R0[1]ָ��ִ��״̬
;	MOV	A,R7
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,#36
	;INC	R0
	;INC	R0
	;	;MOVX	A,@R0
;	MOV	DPH,#1
;	MOV	DPL,R0
;	MOVX	A,@DPTR
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
;	JNZ	MF_Channel_ReadERR
	
MF_Channel_ReadOK:	; ����ɹ�
;	MOV	A,#CONST_STATE_TRUE
		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A						; R0[1] ָ��ִ��״̬
	
;	MOV	R3,#18
;	JMP	MF_Channel_Over 				; ����ָ��
MF_Channel_ReadERR:	
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,#36
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~						; ����ʧ��
;	MOV	A,#CONST_STATE_FALSE
		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A
;	MOV	R3,#2
;	JMP	MF_Channel_Over 				; ����ָ��
	
MF_Channel_ReadOver:	
;************************************************************************************************		
MF_Channel_Write:	; д�����

;	CJNE	A,#CONST_MF_WRITE,MF_Channel_Decrement	
	;R7: ����״̬,r5:buf of addr , r4;block addr
;	MOV	A,@R1						; R1[2] ���
;	MOV	R4,A	 					;
;	MOV	A,R1
;	ADD	A,#8
;	MOV	R1,A
;	MOV	AR5,AR1
;
;	CLR	BIT_BUFADDR					; д���ݴ�����ڴ���
;	PUSH	AR0						; R0[1] ָ��ִ��״̬
;	CALL	_FUN_MF_Rc500Write
;	POP	AR0						; R0[1]ָ��ִ��״
;	MOV	A,R7
;	JNZ	MF_Channel_WriteERR
MF_Channel_WriteOK:	; д��ɹ�
;	MOV	A,#CONST_STATE_TRUE
		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A						; R0[1] ָ��ִ��״̬
	
;	MOV	R3,#2
;	JMP	MF_Channel_Over 				; ����ָ��
MF_Channel_WriteERR:
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,#37
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~							; д��ʧ��
;	MOV	A,#CONST_STATE_FALSE
		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A
;	MOV	R3,#2	
;;	JMP	MF_Channel_Over 				; ����ָ��
	
MF_Channel_WriteOver:	

;************************************************************************************************	
MF_Channel_Decrement:	; �ۿ����
;	CJNE	A,#CONST_MF_DECREMENT,MF_Channel_Increment
	;R7: ����״̬,r5:buf of addr , r4;block addr

	
;	MOV	A,@R1						; R1[2] ���
;	MOV	R4,A	 					;
;	MOV	A,R1
;	ADD	A,#8
;	MOV	R1,A
;	MOV	AR5,AR1


	;����ۿ���Ϊ0�������ۿ����
	;PUSH	AR1
;	MOV	A,@R1
;	JNZ	MF_Channel_DecrementVerifyEnd
;
;	INC	R1
;	MOV	A,@R1
;	JNZ	MF_Channel_DecrementVerifyEnd
;
;	INC	R1
;	MOV	A,@R1
;	JNZ	MF_Channel_DecrementVerifyEnd

;	INC	R1
;	MOV	A,@R1
;	JNZ	MF_Channel_DecrementVerifyEnd
;	JMP	MF_Channel_DecrementOK
MF_Channel_DecrementVerifyEnd:	
	;POP	AR1
	


;	CLR	BIT_BUFADDR					; �ۿ��������ڴ���
;	MOV	DATA_CMDTYPE,#CONST_MF_RC500DECREMENT		; �ۿ�
;	PUSH	AR0						; R0[1] ָ��ִ��״̬
;	PUSH	AR4
;	CALL	_FUN_MF_Rc500Decrement
;	POP	AR4
;	POP	AR0						; R0[1]ָ��ִ��״

;	MOV	A,R7
;	JNZ	MF_Channel_DecrementERR
	
	;MOV	R4,#10
;	PUSH	AR0
;	CALL	_FUN_MF_Rc500Transfer
;	POP	AR0
;	MOV	A,R7
;	JNZ	MF_Channel_DecrementERR	
	
MF_Channel_DecrementOK:	; �ۿ�ɹ�

;	MOV	A,#CONST_STATE_TRUE
		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A						; R0[2] ָ��ִ��״̬
	
;	MOV	R3,#2
;	JMP	MF_Channel_Over 				; ����ָ��
MF_Channel_DecrementERR:					; �ۿ�ʧ��
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,#38
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
;	MOV	A,#CONST_STATE_FALSE
		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A
;	MOV	R3,#2	
;	JMP	MF_Channel_Over 				; ����ָ��
	
MF_Channel_DecrementOver:	
;************************************************************************************************	
MF_Channel_Increment:	; ��ֵ����	
;	CJNE	A,#CONST_MF_INCREMENT,MF_Channel_Restore
	
	;R7: ����״̬,r5:buf of addr , r4;block addr
;	MOV	A,@R1						; R1[2] ���
;	MOV	R4,A	 					;
;	MOV	A,R1
;	ADD	A,#8
;	MOV	R1,A
;	MOV	AR5,AR1
	
	
	;����ۿ���Ϊ0�������ۿ����
	;PUSH	AR1
;	MOV	A,@R1
;	JNZ	MF_Channel_IncrementVerifyEnd

;	INC	R1
;	MOV	A,@R1
;	JNZ	MF_Channel_IncrementVerifyEnd

;	INC	R1
;	MOV	A,@R1
;	JNZ	MF_Channel_IncrementVerifyEnd

;	INC	R1
;	MOV	A,@R1
;	JNZ	MF_Channel_IncrementVerifyEnd
;	JMP	MF_Channel_IncrementOK
;MF_Channel_IncrementVerifyEnd:	
	;POP	AR1
		
;	CLR	BIT_BUFADDR					; ��ֵ��������ڴ���
;	MOV	DATA_CMDTYPE,#CONST_MF_RC500Increment		; ��ֵ
;	PUSH	AR0						; R0[1] ָ��ִ��״̬
;	PUSH	AR4
;	CALL	_FUN_MF_Rc500Decrement
;	POP	AR4
;	POP	AR0						; R0[1]ָ��ִ��״
;	MOV	A,R7
;	JNZ	MF_Channel_IncrementERR
	
;	PUSH	AR0
;	CALL	_FUN_MF_Rc500Transfer
;	POP	AR0
	;MOV	A,R7
	;JNZ	MF_Channel_IncrementERR	
	
MF_Channel_IncrementOK:	; ��ֵ�ɹ�
;	MOV	A,#CONST_STATE_TRUE
		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A						; R0[2] ָ��ִ��״̬
	
;	MOV	R3,#2
;	JMP	MF_Channel_Over 				; ����ָ��
MF_Channel_IncrementERR:					; ��ֵʧ��
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,#39
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
;	MOV	A,#CONST_STATE_FALSE
		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A
;	MOV	R3,#2	
;	JMP	MF_Channel_Over 			; ����ָ��
	
MF_Channel_IncrementOver:
;************************************************************************************************	
MF_Channel_Restore:	; ����
;	CJNE	A,#CONST_MF_RESTOR,MF_Channel_Over
	
	;R7: ����״̬,R5:buf of addr , r4;block addr
;	MOV	A,@R1						; R1[2] ���
;	MOV	R4,A	 					;
;	MOV	A,R1
;	ADD	A,#8
;	MOV	R1,A
;	MOV	A,@R1
;	MOV	R5,A

	;CLR	BIT_BUFADDR					; д���ݴ�����ڴ���
;	PUSH	AR0						; R0[1] ָ��ִ��״̬
;	PUSH	AR5
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,#36
	;MOV	A,R4
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
;	CALL	_FUN_MF_Rc500Restore
;	POP	AR5
;	POP	AR0						; R0[1]ָ��ִ��״
;	MOV	A,R7
;	JNZ	MF_Channel_RestoreERR
;	
;	MOV	AR4,AR5						;���ݵ�Ŀ����		
;	PUSH	AR0
;	CALL	_FUN_MF_Rc500Transfer
;	POP	AR0
;;	MOV	A,R7
;	
;	JNZ	MF_Channel_RestoreERR		
;	
MF_Channel_RestoreOK:	; ���ݳɹ�
;	MOV	A,#CONST_STATE_TRUE
;		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A						; R0[1] ָ��ִ��״̬
;	
;	MOV	R3,#2
;	JMP	MF_Channel_Over 				; ����ָ��
MF_Channel_RestoreERR:						; ����ʧ��
	;~~~~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~
	;MOV	A,#40
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
;	MOV	A,#CONST_STATE_FALSE
		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A
;	MOV	R3,#2	
;	JMP	MF_Channel_Over 				; ����ָ��
	
MF_Channel_RestoreOver:
;************************************************************************************************	
MF_Channel_Other:	;����MFָ��
;	MOV	A,#CONST_STATE_FALSE
;		;MOVX	@R0,A
;	MOV 	DPH,#1 
;	MOV 	DPL,R0 
;	MOVX 	@DPTR,A
;	MOV	R3,#2	
MF_Channel_OtherOver:
;************************************************************************************************	
MF_Channel_Over:

	RET
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////		

	END
