;******************************************************************
;������ESAM�Ӵ�ʽ����
;_FUN_ContactIssue_INIT		---	���г�ʼ��
;_FUN_ContactIssue_RXBST	---	����_����BST
;_FUN_ContactIssue_RX		---	���շ�����Ϣ����PC��
;_FUN_ContactIssue_TX		---	���ͷ��л�Ӧ��Ϣ����PC��
;******************************************************************
NAME	ContactIssue
	
$INCLUDE(COMMON.INC)
$INCLUDE(C_Issue.INC)
	
	RSEG	?pr?ContactIssue?Mater
	USING	0
	
;--------------------------------------------------------------------------
;����:���г�ʼ�� ����2 115200
;�ⲿ����
;--------------------------------------------------------------------------
_FUN_ContactIssue_INIT:
	
	;LCALL	_FUN_SERIAL_InitUART
	CALL	_FUN_SERIAL_INIT
	;MOV	IE2,#0
	;CLR	ET0
	;CLR	ET1
	MOV	R7,#CONST_BAUD_115200PC
	;MOV	R7,#CONST_BAUD_9600PC
	CALL	_FUN_Contact_CHANGEBAUD		;�� 24.576 ����� 115200 �Ĳ�����
	
	MOV	SCON,#40H			;��ɲ���Ҫ����λ
	MOV	A,REG_51_AUXR1
	ORL	A,#10000000B
	;ANL	A,#01111111B
	MOV	REG_51_AUXR1,A
	
	RET
;--------------------------------------------------------------------------
;����:�����ͷ� ����01 115200*6.144/3.58
;�ⲿ����
;--------------------------------------------------------------------------	
_FUN_ContactIssue_Release:
	
	MOV	R7,#CONST_BAUD_115200
	CALL	_FUN_Contact_CHANGEBAUD		;�� 24.576 �����  115200 * 6 / 3.58 �Ĳ�����	
	MOV	SCON,#0C0H			;�����Ҫ����λ
	
	MOV	A,REG_51_AUXR1
	;ORL	A,#10000000B
	ANL	A,#01111111B
	MOV	REG_51_AUXR1,A
	
	RET
;--------------------------------------------------------------------------
;����:���г�ʼ��  ����01 115200
;�ⲿ����
;--------------------------------------------------------------------------
_FUN_ContactIssue_INIT02:
	
	CALL	_FUN_SERIAL_INIT
	MOV	R7,#CONST_BAUD_115200PC
	CALL	_FUN_Contact_CHANGEBAUD		;�� 24.576 �����  115200 * 6 / 3.58 �Ĳ�����	
	MOV	SCON,#40H			;��ɲ���Ҫ����λ
	
	MOV	A,REG_51_AUXR1
	;ORL	A,#10000000B
	ANL	A,#01111111B
	MOV	REG_51_AUXR1,A
	
	RET
;--------------------------------------------------------------------------
;	
;--------------------------------------------------------------------------
_FUN_ContactIssue_INITDown:
	
	CALL	_FUN_SERIAL_INIT
	
	MOV	R7,#CONST_BAUD_38400PC
	CALL	_FUN_Contact_CHANGEBAUD		;�� 24.576 �����  115200 * 6 / 3.58 �Ĳ�����	
	MOV	SCON,#40H			;��ɲ���Ҫ����λ
	
	MOV	A,REG_51_AUXR1
	;ORL	A,#10000000B
	
	ANL	A,#01111111B
	MOV	REG_51_AUXR1,A
	
	RET
;--------------------------------------------------------------------------
;����:����_���� BST 
;�ⲿ����
;	XXX
;����ֵ
;	BIT_ContactIssue	---	���п�ʼ���=0��û�н��շ�����Ϣ�����յ�������Ϣ
;	R3			---	���յ�BST�ĳ���
;	R7			---	����״̬
;--------------------------------------------------------------------------	
_FUN_ContactIssue_RXBST:
	
	SETB	BIT_SERIALOVERTIMERX
	MOV	R7,#DATA_RXBUF
	CALL	_FUN_ContactIssue_RX
	MOV	A,R3
	JNZ	ContactIssue_RXBST_RXED
	JMP	ContactIssue_RXBST_ERR
	
ContactIssue_RXBST_RXED:
	
	;�ж�BSTǰ4���ֽ��Ƿ���BST��������ǣ����趨���п�ʼ���
	MOV	R0,#DATA_RXBUF
	MOV	A,@R0
	XRL	A,#0FFH
	JNZ	ContactIssue_RXBST_ERR
	INC	R0
	MOV	A,@R0
	XRL	A,#0FFH	
	JNZ	ContactIssue_RXBST_ERR
	INC	R0
	MOV	A,@R0
	XRL	A,#0FFH
	JNZ	ContactIssue_RXBST_ERR
	INC	R0
	MOV	A,@R0
	XRL	A,#0FFH	
	JNZ	ContactIssue_RXBST_ERR

	;SETB	BIT_ContactIssue
		
	RET
	
ContactIssue_RXBST_ERR:
	MOV	R3,#0
	MOV	R7,#CONST_STATE_FALSE
	RET
;--------------------------------------------------------------------------
;����:���շ�����Ϣ����PC��
;�ⲿ����
;	BIT_BST			---	;=1��ʾ�յ���bst,=0��ʾû���յ���bst	(=0ʱ���������ֺ���1 Byte ��״̬��)
;	BIT_SERIALOVERTIMERX	---	=0,û������ ; =1��ʱ������
;	R7			---	����ָ�루�ڴ棩
;����ֵ
;	R3			---	�������ݳ���
;	R7			---	����״̬
;	AR5			---	����ͷ
;	XDATA_IssueRSCTL	---	���߷������
;	XDATA_IssueCMD		---	���߷���������

;STX(2) + RSCTL(1) + LEN(2) + CMD(1)+State(1 byte bit_bst=1ʱ����) + DATA(XX)+ BCC(1)
;--------------------------------------------------------------------------	
_FUN_ContactIssue_RX:
	
	CLR	BIT_BUFADDR		;= 0���������ݵ��ڴ棻 = 1���������ݵ����
	CLR	BIT_VERIFY		;�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ
	
	MOV	R3,#000H
	PUSH	AR7
	CALL	_FUN_SERIAL_RXHARD
	POP	AR7
	MOV	A,R3
		
	;~~~~~~~~~~~~TEST~~~~~~~~
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~
	
	CJNE	A,#7,$+3			;STX(2) + RSCTL(1) + LEN(2) + CMD(1) DATA(XX)+ BCC(1) >= 7 BYTE
	;JNC	ContactIssue_RX_VerifyBCC
	JNC	ContactIssue_RX_VerifyHead
	JMP	ContactIssue_RX_ERR
	
ContactIssue_RX_VerifyHead:
	;ɨ��0x55 0xAA
	;PUSH	AR3
	;PUSH	AR7
	mov	AR0,AR7
ContactIssue_RX_VerifyHeadloop:
	MOV	A,@R0
	XRL	A,#055H
	JZ	ContactIssue_RX_VerifyHeadloop02
	INC	R0
	DJNZ	R3,ContactIssue_RX_VerifyHeadloop
	
ContactIssue_RX_VerifyHeadloop02:
	MOV	A,@R0
	XRL	A,#0AAH
	JZ	ContactIssue_RX_VerifyBCC
	INC	R0
	DJNZ	R3,ContactIssue_RX_VerifyHeadloop02
	;pop	ar7
	;pop	ar3	
	JMP	ContactIssue_RX_ERR
	
ContactIssue_RX_VerifyBCC:			;��֤BCC
	
	DEC	R3
	INC	R0
	MOV	AR0,AR7
	;DEC	R0
	
	;--- ��֤ BCC �Ƿ���ȷ ---
	PUSH	AR3
	PUSH	AR7
	
	;---DEC	R3
	;---DEC	R3
	;---INC	R7
	;---INC	R7
	
	CLR	BIT_BUFADDR
	CALL	_FUN_LIB_GetBCC
	POP	AR7
	POP	AR3
	
	;~~~~~~~~~~TEST~~~~~~~~
	;MOV	A,R6
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~		
	
	JZ	ContactIssue_RX_GetData
	JMP	ContactIssue_RX_ERR	; ��֤BCC��������
ContactIssue_RX_GetData:		; ֻ�����ݣ��������

	MOV	AR1,AR7			; HEAD 0 55	
	INC	R1			; HEAD 1 AA
	INC	R1			; RSCTL
	
	;��¼���
	MOV	A,@R1
	MOV	R0,#XDATA_IssueRSCTL
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	INC	R1			; LEN 0
	INC	R1			; LEN 1
	INC	R1			; CMD
	
	;��¼������
	MOV	A,@R1
	MOV	R0,#XDATA_IssueCMD
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	MOV	AR5,AR7
		
;	MOV	R2,#7
;	JNB	BIT_BST,ContactIssue_RX_Broad01
;ContactIssue_RX_NBroad01:
;	INC	R1			; State
;	INC	R2			; 7+1 ����״̬��ĳ���
;ContactIssue_RX_Broad01:		; 
;	INC	R1			; DATA 0	
;	CLR	C
;ContactIssue_RX_Broad01Over:
;	MOV	A,R3
;	SUBB	A,R2
;	MOV	R3,A

	;~~~~~~~~~~~~TEST~~~~~~~~
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~
	;��Dataǰ��,ȥ��STX(2) / RSCTL(1) / LEN(2) / CMD(1) / BCC(1)
;	MOV	AR2,AR3
;	MOV	AR0,AR7			;HEAD 0
;ContactIssue_RX_PREMOV:
;	MOV	A,@R1
;	MOV	@R0,A
	
;	INC	R1
;	INC	R0
	
;	DJNZ	R2,ContactIssue_RX_PREMOV
	MOV	R7,#CONST_STATE_TRUE
ContactIssue_RX_OVER:
	RET	
;////////////////////////////////////////////////////////////////////////////
ContactIssue_RX_ERR:			;���շ�����Ϣ����	
	MOV	R7,#CONST_STATE_FALSE	
	
	RET	
;////////////////////////////////////////////////////////////////////////////	
_FUN_ContactIssue_RX03:
	;CLR	BIT_BUFADDR		;= 0���������ݵ��ڴ棻 = 1���������ݵ����
	;CLR	BIT_VERIFY		;�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ	
	MOV	R3,#000H		;
	PUSH	AR7			;
	CALL	_FUN_SERIAL_RXHARD	;
	POP	AR7			;
	MOV	A,R3			;
	JMP	ContactIssue_RX02_RXO	;
	
;////////////////////////////////////////////////////////////////////////////
_FUN_ContactIssue_RX02:	
	;CLR	BIT_BUFADDR		;= 0���������ݵ��ڴ棻 = 1���������ݵ����
	;CLR	BIT_VERIFY		;�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ
	
	MOV	R3,#000H
	PUSH	AR7
	CALL	_FUN_SERIAL_RXHARD
	POP	AR7
	
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;����
;	��֤��������
;����
;	R7		����緳�
;	BIT_BUFADDR 	=1��� =0 �ڴ�
;����ֵ
;	R5	������[ȥ�� 55aaserlen0len1cmd xxx bcc]��緳�ͷ��R5��
;	R3	�����ݳ���
;	R7=0	��������ȷ
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ContactIssue_RX02_Deal:
	
	MOV	A,R3
	
ContactIssue_RX02_RXO:
	
	;~~~~~~~~~~~~TEST~~~~~~~~
	;MOV	R7,#0
	;JMP	ContactIssue_RX02_OVER
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~
	
	CJNE	A,#7,$+3			;STX(2) + RSCTL(1) + LEN(2) + CMD(1) DATA(XX)+ BCC(1) >= 7 BYTE
	;JNC	ContactIssue_RX02_VerifyBCC
	JNC	ContactIssue_RX02_VerifyHead
	JMP	ContactIssue_RX02_ERR
	
ContactIssue_RX02_VerifyHead:
	
	;ɨ��0x55 0xAA
	;PUSH	AR3
	;PUSH	AR7
	
	MOV	AR0,AR7
ContactIssue_RX02_VerifyHeadloop:
	JB	BIT_BUFADDR,ContactIssue_RX02_55X
	MOV	A,@R0
	JMP	ContactIssue_RX02_55O
ContactIssue_RX02_55X:
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
ContactIssue_RX02_55O:
	
	XRL	A,#055H
	JZ	ContactIssue_RX02_VerifyHeadloop02P
	INC	R0
	DJNZ	R3,ContactIssue_RX02_VerifyHeadloop
	
	JMP	ContactIssue_RX02_ERR
	
ContactIssue_RX02_VerifyHeadloop02P:
	INC	R0
	DEC	R3
	
ContactIssue_RX02_VerifyHeadloop02:
	JB	BIT_BUFADDR,ContactIssue_RX02_AAX
	MOV	A,@R0
	JMP	ContactIssue_RX02_AAO
ContactIssue_RX02_AAX:
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
ContactIssue_RX02_AAO:
	
	XRL	A,#0AAH
	JZ	ContactIssue_RX02_VerifyBCC
	
	INC	R0
	DEC	R3
	
	MOV	A,R3
	JNZ	ContactIssue_RX02_VerifyHeadloop
	
	JMP	ContactIssue_RX02_ERR
	
	
ContactIssue_RX02_VerifyBCC:			;��֤BCC
	
	;~~~~~~~~~~~~TEST~~~~~~~~
	;MOV	R7,#0
	;JMP	ContactIssue_RX02_OVER
	;MOV	A,R3
	;MOV	A,#37
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~	
	
	DEC	R3
	INC	R0
	
	;MOV	AR0,AR7
	MOV	AR7,AR0
	;DEC	R0
	
	;--- ��֤ BCC �Ƿ���ȷ ---
	PUSH	AR3
	PUSH	AR7
	
	;---DEC	R3
	;---DEC	R3
	;---INC	R7
	;---INC	R7
	
	;~~~~~~~~~~ TEST ~~~~~~~~
	;MOV	A,R6
	;	;MOVX	A,@R0
	;MOV	DPH,#1
	;MOV	DPL,R0
	;MOVX	A,@DPTR
	
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~
	;CLR	BIT_BUFADDR
	CALL	_FUN_LIB_GetBCC
	POP	AR7
	POP	AR3
	
	;~~~~~~~~~~TEST~~~~~~~~
	;MOV	A,R6
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~
	
	;~~~~~~~~~~TEST~~~~~~~~
	;MOV	A,R6
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~
	
	JZ	ContactIssue_RX02_GetData
	JMP	ContactIssue_RX02_ERR	; ��֤BCC��������
	
ContactIssue_RX02_GetData:		; ֻ�����ݣ��������

	;~~~~~~~~~~TEST~~~~~~~~
	;MOV	A,R6
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY	
	;~~~~~~~~~~~~~~~~~~~~~~~~	
	MOV	AR1,AR7			; RSCTL
	JB	BIT_BUFADDR,ContactIssue_RX02_RecordX
	
ContactIssue_RX02_Record:
	;��¼���
	MOV	A,@R1
	MOV	R0,#XDATA_IssueRSCTL
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	INC	R1			; LEN 0
	INC	R1			; LEN 1
	INC	R1			; CMD
	
	;��¼������
	MOV	A,@R1
	MOV	R0,#XDATA_IssueCMD
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	JMP	ContactIssue_RX02_RecordOver
	
ContactIssue_RX02_RecordX:
	
	;��¼���
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	MOV	R0,#XDATA_IssueRSCTL
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	INC	R1			; LEN 0
	INC	R1			; LEN 1
	INC	R1			; CMD
	
	;��¼������
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	MOV	R0,#XDATA_IssueCMD
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	;~~~~~~~~~~ TEST ~~~~~~~~
	; MOV	A,R3
	; JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~
	
ContactIssue_RX02_RecordOver:
	
	;~~~~~~~~~~TEST~~~~~~~~
	;MOV	A,R6
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~
	
	INC	R7
	INC	R7
	INC	R7
	INC	R7
	
	DEC	R3
	DEC	R3
	DEC	R3
	DEC	R3
	DEC	R3	;BCC
	
	MOV	AR5,AR7
	MOV	R7,#CONST_STATE_TRUE
	
ContactIssue_RX02_OVER:
	
	;~~~~~~~~~~TEST~~~~~~~~
	;MOV	A,R6
	;MOV	A,R3
	;MOV	A,R7
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~	
	
	RET
;////////////////////////////////////////////////////////////////////////////
ContactIssue_RX02_ERR:			;���շ�����Ϣ����	
	MOV	R3,#0
	MOV	R7,#CONST_STATE_FALSE	
	
	RET		
	
	
;--------------------------------------------------------------------------
;����:���ͷ��л�Ӧ��Ϣ����PC��
;�ⲿ����
;	R7			---	����ָ�루��棩
;	R3			---	�������ݳ���
;	XDATA_IssueRSCTL	---	���߷������
;	XDATA_IssueCMD		---	���߷���������
;����ֵ
;	XXX
;--------------------------------------------------------------------------	
_FUN_ContactIssue_TX:
	
	;~~~~~~~~~~~~TEST~~~~~~~~~~~~	
	;JMP	ContactIssue_TX_SEND
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	MOV	A,R3
	JNZ	ContactIssue_TXVerifyParam
	JMP	ContactIssue_TX_Err
ContactIssue_TXVerifyParam:
		
	;�����ݺ���		
	MOV	A,R7	
	ADD	A,R3
	DEC	A
	MOV	R0,A	;DATA 0
	ADD	A,#6
	MOV	R1,A
	
	MOV	A,R3
	MOV	R2,A
ContactIssue_TX_BACKMOV:			; Data �����
	
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	DEC	R1
	DEC	R0
	
	DJNZ	R2,ContactIssue_TX_BACKMOV
	;~~~~~~~~~~~~TEST~~~~~~~~~~~~	
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY
	
	;INC	R3
	;INC	R3
	
	;INC	R3
	;INC	R3
	;INC	R3
	;MOV	R3,#10
	;JMP	ContactIssue_TX_SEND
	;~~~~~~~~~~~~~~~~~~~~~~~~	
	
	;�����ݼ���STX(2) / RSCTL(1) / LEN(2) / CMD(1) / BCC(1)
	MOV	AR0,AR7	
	MOV	A,#055H
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	;~~~~~~~~~~~~TEST~~~~~~~~~~~~	
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	INC	R0						;STX 1
	MOV	A,#0AAH
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A	
	;~~~~~~~~~~~~TEST~~~~~~~~~~~~	
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~		
	INC	R0						;RSCTL
	MOV	R1,#XDATA_IssueRSCTL
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	INC	A						;��ż�1
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	;~~~~~~~~~~~~TEST~~~~~~~~~~~~	
	;MOV	A,R0
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~		
	
	INC	R0	;LEN 0
	CLR	A
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	INC	R0	;LEN 1
	MOV	A,R3
	;---INC	A	;����state�ĳ���
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A	
	
	INC	R0	;CMD
	MOV	R1,#XDATA_IssueCMD
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	ANL	A,#0EFH	;
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	;INC	R0	;State
	;CLR	A		
	;	;MOVX	@R0,A
	;MOV 	DPH,#1 
	;MOV 	DPL,R0 
	;MOVX 	@DPTR,A
	
	;~~~~~~~~~~~~TEST~~~~~~~~~~
	; MOV	A,R3
	; JMP	_FUN_TEST_DISPLAY
	
	; INC	R3
	; INC	R3
	
	; INC	R3
	; INC	R3
	; INC	R3
	; MOV	R3,#10
	; JMP	ContactIssue_TX_SEND
	;~~~~~~~~~~~~~~~~~~~~~~~~
	
	PUSH	AR7
	;--- ���BCC ---
	SETB	BIT_BUFADDR
	INC	R7	;HEAD 1
	
	INC	R7	;RSCTL
	MOV	A,R3
	ADD	A,#4	; RSCTL(1) / LEN(2) / CMD(1)
	MOV	R3,A
	PUSH	AR3
	CALL	_FUN_LIB_GetBCC	
	POP	AR3
	POP	AR7	
	;CALL	_FUN_SERIAL_TXHARD
	;RET
	
	;---BCC---
	INC	R3	;���� head0 head1�ĳ���
	INC	R3
	
	MOV	A,R7
	ADD	A,R3
	MOV	R0,A
	MOV	A,R6
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A	
	
	INC	R3	;����BCC�ĳ���
ContactIssue_TX_SEND:
	
	SETB	BIT_BUFADDR
	CLR	BIT_VERIFY
	push	ar3
	CALL	_FUN_SERIAL_TXHARD
	pop	AR3
	MOV	R7,#CONST_STATE_TRUE	
	RET
;///////////////////////////////////////////////////////////////////////////
ContactIssue_TX_Err:	;���ͷ�����Ϣ����
	MOV	R7,#CONST_STATE_FALSE
	RET
;///////////////////////////////////////////////////////////////////////////


	
	END

