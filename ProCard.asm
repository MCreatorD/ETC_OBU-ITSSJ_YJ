;******************************************************************
;������PRO��Ƭ������չ����
;_FUN_ProCard_RXBYTE		---	Pro�����յ����ֽڵ�����
;_FUN_ProCard_RXPro		---	Pro����������
;_FUN_ProCard_TXBYTE		---	Pro�����͵����ֽڵ�����
;_FUN_ProCard_TXPro		---	Pro����������
;_FUN_ProCard_Channel		---	Pro��ͨ����������
;******************************************************************
NAME	ProCard
	
$INCLUDE(COMMON.INC)
$INCLUDE(ProCard.INC)
	
	RSEG	?pr?ProCard?Mater
	USING	0
	
;--------------------------------------------------------------------------
;����:Pro�����յ����ֽڵ�����(_FUN_ProCard_RXBYTE)
;�ⲿ����
;	XXX		---	XXX
;�ڲ�����:
;����ֵ
;--------------------------------------------------------------------------	
_FUN_ProCard_RXBYTE:

	PUSH	AR7
	MOV	R7,#00H
	MOV	A,#REG_RC522_FIFODataReg
	RL	A
	SETB	ACC.7
	CALL	_FUN_NContact_spio
	;---MOV	A,REG_5412AD_spdat
	POP	AR7
	RET
;--------------------------------------------------------------------------			
_FUN_ProCard_RXNUM:
	
	MOV	R7,#00H
	MOV	A,#REG_RC522_FIFOLevelReg
	RL	A
	SETB	ACC.7
	CALL	_FUN_NContact_spio
	;MOV	A,REG_5412AD_spdat	
	
	RET	
;--------------------------------------------------------------------------
;����:Pro����������(_FUN_ProCard_RXPro)
;�ⲿ����
;	R7		---	����緳�
;	BIT_BUFADDR	---	=0 �������ݵ��ڴ�;	=1 �������ݵ����
;	BIT_GETRESULT	---	=1 ��ʾȡ��ȡ���ؽ��;	=0 ��ʾ��ȡ���ؽ��
;�ڲ�����:
;	XXX
;����ֵ
;	R3		---	���յ������ݳ���

;--------------------------------------------------------------------------	
_FUN_ProCard_RXPro:	

	MOV	AR0,AR7
_FUN_ProCard_RXPro_j:	
	MOV	DATA_IRQEN,#29H
	PUSH	AR0
	CALL	_FUN_NContact_Rc500Rx	;��PRO��ǰ��Ҫ����׼������,���ؽ��ճ���
	POP	AR0

ProCard_RXPro_StartRX01:
	;~~~~~ ���ò��Ժ��� ~~~~~
	;MOV	A,#33
	;JMP	_FUN_TEST_DISPLAY	
	;~~~~~~~~~~~~~~~~~~~~~~~~~	
;	mov	a,r2
;	xrl	a,#30
;	jnz	xxxxx
;	mov	a,r7
;	CALL	_FUN_TEST_DISPLAY
;xxxxx:	
	MOV	A,R7				;��ȡ���ճ���_D
	XRL	A,#0FFH
	JNZ	ProCard_RXPro_StartRX
	JMP	ProCard_RXPro_ERR

ProCard_RXPro_StartRX:
	MOV	A,R7				;��ȡ���ճ���_D
	XRL	A,#03H
	JNZ	ProCard_RXPro_StartRX_J

	CALL	_FUN_ProCard_RXBYTE
	XRL	A,#0FAh
	JNZ	ProCard_RXPro_StartRX_J1
	
	CALL	_FUN_ProCard_RXBYTE		
	CALL	_FUN_ProCard_RXBYTE		

	mov	a,#REG_RC522_FIFODataReg;09h
	rl	a
	mov	r7,#0FAh
	call	_FUN_NContact_spio

	mov	a,#REG_RC522_FIFODataReg;09h
	rl	a
	mov	r7,#01h
	call	_FUN_NContact_spio

	mov	a,#REG_RC522_FIFODataReg;09h
	rl	a
	mov	r7,#32h
	call	_FUN_NContact_spio

	mov	r7,#0ch
	;mov	r4,#0
	call	_FUN_NContact_Rc500TxAndRx

	jmp	_FUN_ProCard_RXPro_j

	;--- �����ؽ��3��FA ---
ProCard_RXPro_StartRX_J1:
	MOV	A,R7
	DEC	A
	DEC	A
	MOV	R3,A
	
	CJNE	R3,#127,$+3
	JC	ProCard_RXPro_RXRESULT_j
	JMP	ProCard_RXPro_ERR
ProCard_RXPro_RXRESULT_j:
	CALL	_FUN_ProCard_RXBYTE		
	JMP	ProCard_RXPro_RXRESULT_j2
	
	;--- �����ؽ����03 ---
ProCard_RXPro_StartRX_J:
	MOV	A,R7
	DEC	A
	DEC	A
	MOV	R3,A
	
	;------ r3>127 ----
	cjne	r3,#127,$+3
	jc	ProCard_RXPro_RXRESULT	
	jmp	ProCard_RXPro_ERR
	
ProCard_RXPro_RXRESULT:
	CALL	_FUN_ProCard_RXBYTE
	CALL	_FUN_ProCard_RXBYTE			
	
ProCard_RXPro_RXRESULT_j2:
	MOV	AR4,AR3	
	
ProCard_RXPro_StartLoop:
	PUSH	AR4
	PUSH	AR3	;������ճ���
	
ProCard_RXPro_Loop:
	CALL	_FUN_ProCard_RXBYTE
	;��Ҫ����ʱ����Ȼ����̫������ʱ���ղ�����
	MOV	R7,#10
	DJNZ	R7,$
	
	JB	BIT_BUFADDR,RXPro_Loop_ADDRMOVX
RXPro_Loop_ADDRMOV:
	MOV	@R0,A
	JMP	RXPro_Loop_ADDROVER
RXPro_Loop_ADDRMOVX:
		;MOVX	@R0,A
;	push	dph
;	push	dpl	
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
;	pop	dpl
;	pop	dph	
RXPro_Loop_ADDROVER:
	INC	R0
	DJNZ	R3,ProCard_RXPro_Loop		
		
	POP	AR3
	POP	AR4

	;FIFOLevelReg Indicate the number of bytes store in the fifo
	MOV	A,#REG_RC522_FIFOLevelReg
	RL	A
	SETB	ACC.7
	MOV	R7,#00h
	CALL	_FUN_NContact_spio
	
	JZ	ProCard_RXPro_OVER
	MOV	R3,A
	ADD	A,R4
	MOV	R4,A

	;------ r3>127 ----
	cjne	r4,#127,$+3
	jc	ProCard_RXPro_fhfh	
	jmp	ProCard_RXPro_ERR	
	
ProCard_RXPro_fhfh:
	JMP	ProCard_RXPro_StartLoop	
	
ProCard_RXPro_OVER:

;	DEC	R0
;	DEC	R0
	
;		;MOVX	A,@R0

;	CALL	_FUN_TEST_DISPLAY
;xxxx:

;	mov	a,r2
;	xrl	a,#30
;	jnz	xxxxx
	;mov	a,r7
	;CALL	_FUN_TEST_DISPLAY

;dec	r0
;dec	r0
;	;MOVX	A,@R0
	
;call	_fun_test_display		
;xxxxx:	
	

	MOV	AR3,AR4
	PUSH	AR3
	CALL	_FUN_ProCard_CLRResult
	POP	AR3
	


;call	_fun_test_display	



	;dec	r0
	;dec	r0
	;	;MOVX	A,@R0

	;clr	a
	;mov	c,BIT_GETRESULT
	;mov	acc.0,c
	;mov	a,r3
	;call	_fun_test_display
	JB	BIT_GETRESULT,ProCard_RXPro_Ret
	;--- ���� 61 + ����(�������) ---
	MOV	A,R0
	CLR	C
	SUBB	A,R4
	; INC	A
	MOV	R0,A
	MOV	A,#61H
		;MOVX	@R0,A
;	push	dph
;	push	dpl

	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	INC	R0
	MOV	A,R4
		;MOVX	@R0,A
;	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
;	pop	dpl
;	pop	dph
	MOV	R3,#2
	
ProCard_RXPro_Ret:	
	;---setb	BIT_GETRESULT
	RET		
	
ProCard_RXPro_ERR:
	MOV	R7,#CONST_STATE_FALSE
	MOV	R3,#0
	RET	
	
;--------------------------------------------------------------------------
;����:���FIFO����ֹRC522��Excution(_FUN_ProCard_TXBYTE)
;�ⲿ����
;	A		---	��Ҫ���͵�����
;�ڲ�����:
;����ֵ
;--------------------------------------------------------------------------

_FUN_ProCard_CLRResult:
	mov	a,#REG_RC522_ControlReg
	rl	a
	setb	acc.7
	mov	r7,#00h
	call	_FUN_NContact_spio
	;mov	a,REG_5412AD_spdat

	setb	acc.7
	mov	r7,a
	mov	a,#REG_RC522_ControlReg
	rl	a
	call	_FUN_NContact_spio

	;clear FIFO buffer
	mov	a,#REG_RC522_FIFOLevelReg
	rl	a
	mov	r7,#80h
	call	_FUN_NContact_spio

	;stop execution
	mov	a,#REG_RC522_CommandReg
	rl	a
	mov	r7,#00h
	call	_FUN_NContact_spio 	
	RET
;--------------------------------------------------------------------------
;����:Pro�����͵����ֽڵ�����(_FUN_ProCard_TXBYTE)
;�ⲿ����
;	A		---	��Ҫ���͵�����
;�ڲ�����:
;����ֵ

;--------------------------------------------------------------------------	
_FUN_ProCard_TXBYTE:

	PUSH	AR7
	MOV	R7,A
	MOV	A,#REG_RC522_FIFODataReg
	RL	A
	CALL	_FUN_NContact_spio
	POP	AR7

	RET
;--------------------------------------------------------------------------
;����:Pro����������(_FUN_ProCard_TXPro)
;����:
;		Ҫ�ڷ�������ǰ�� 0a/0b + 00����Ҫ����0x01,0x02,0x03
;		�������ķ��������� 0a/0b + 0x00 + 0x01 + 0x02 + 0x03
;�ⲿ����
;BIT_BUFADDR	---	=0�����͵����ڴ����ݣ�=1�����͵����������
;R7		---	��Ҫ�������ݵ�buf
;R3		---	�������ݵĳ���
;BIT_PROF	---	Pro���������	= 0 ��ʾ0A ;= 1 ��ʾ0B
;�ڲ�����:
;����ֵ
;--------------------------------------------------------------------------	
;һ�������緳���д��50���ֽ�
;����50���ֽ�ʱ����Ҫд��50���ֽں�Ҫ�ȴ�緳���С��25���ֽں�����緳�д��<=25���ֽڣ�ֱ������
;--------------------------------------------------------------------------		
_FUN_ProCard_TXPro:
	;����ͷ������
;PUSH AR7
;	mov	a,#REG_RC522_TmodeReg
;	rl	a
;	mov	r7,#82h
;	CALL	_FUN_NContact_spio
	
;	mov	a,#REG_RC522_TPrescalerReg
;	rl	a
;	mov	r7,#0a6h
;	call	_FUN_NContact_spio
	
;	mov	a,#REG_RC522_TModeReg
;	rl	a
;	mov	r7,#82h
;	call	_FUN_NContact_spio

;	mov	a,#REG_RC522_TmodeReg
;	rl	a
;	mov	r7,#82h
;	call	_FUN_NContact_spio
	
;	mov 	a,#REG_RC522_TReloadRegL
;	rl 	a
;	mov 	r7,#150				;30;8;30;75;#155;30 1eh
;	call 	_FUN_NContact_spio
	
;	mov 	a,#REG_RC522_TReloadRegH
;	rl 	a
;	mov 	r7,#01h				;00h
;	call 	_FUN_NContact_spio
;POP AR7


	MOV	A,#0AH
	MOV	C,BIT_PROF
	MOV	ACC.0,C
	CALL	_FUN_ProCard_TXBYTE
	CPL	BIT_PROF
	mov	a,#1
	CALL	_FUN_ProCard_TXBYTE
	
	CJNE	R3,#54,$+3
	JNC	ProCard_TXPro_Len
	MOV	R4,#0
	JMP	ProCard_TXPro_LenTX

ProCard_TXPro_Len:
	CLR	C
	MOV	A,AR3
	SUBB	A,#53
	MOV	R4,A
	MOV	R3,#53
	
ProCard_TXPro_LenTX:
	;����ָ������
	MOV	AR0,AR7
		
ProCard_TXPro_lenLOOP:
	JB	BIT_BUFADDR,TXPro_LOOP_ADDRMOVX
TXPro_LOOP_ADDRMOV:
	MOV	A,@R0
	JMP	TXPro_LOOP_ADDROVER
TXPro_LOOP_ADDRMOVX:
		;MOVX	A,@R0

;	push	dph
;	push	dpl
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
;	pop	dpl
;	pop	dph
TXPro_LOOP_ADDROVER:
	CALL	_FUN_ProCard_TXBYTE
	INC	R0
	DJNZ	R3,ProCard_TXPro_lenLOOP
	
	MOV	DATA_IRQEN,#29H
	MOV	R7,#0ch
	;PUSH	AR4
	CALL	_FUN_NContact_Rc500TxAndRx02
	;CALL	_FUN_NContact_Rc500TxAndRx
	;POP	AR4
	mov	a,r4
	jnz	ProCard_TXPro_TXWAIt
	jmp	ProCard_TXPro_LENOver
ProCard_TXPro_TXWAIT:	
	MOV	R7,#00H
	MOV	A,#REG_RC522_FIFOLevelReg
	RL	A
	SETB	ACC.7
	CALL	_FUN_NContact_spio	

	CJNE	A,#30,$+3
	JNC	ProCard_TXPro_TXWAIT
	MOV	AR3,AR4
	
ProCard_TXPro_lenLOOP2:
	;��Ҫ����ʱ����Ȼ����̫����FiFo����
	MOV	r7,#18
	DJNZ	r7,$
	
	JB	BIT_BUFADDR,TXPro_LOOP_ADDRMOVX2
TXPro_LOOP_ADDRMOV2:
	MOV	A,@R0
	JMP	TXPro_LOOP_ADDROVER2
TXPro_LOOP_ADDRMOVX2:
		;MOVX	A,@R0

;	push	dph
;	push	dpl
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
;	pop	dpl
;	pop	dph
	
TXPro_LOOP_ADDROVER2:
	CALL	_FUN_ProCard_TXBYTE
	INC	R0
	DJNZ	R3,ProCard_TXPro_lenLOOP2

	;MOV	R7,#00H
	;MOV	A,#REG_RC522_FIFOLevelReg
	;RL	A
	;SETB	ACC.7
	;CALL	_FUN_NContact_spio	
	;call	_fun_test_display
;xxx:	
ProCard_TXPro_LENOver:
	
	RET
;/////////////////////////////////////////////////////////
;	JMP	ProCard_TXPro_Len
	;<=50���ֽڵ�ָ�������
;ProCard_TXPro_Short:
	;����ָ������
;	MOV	AR0,AR7
;ProCard_TXPro_LOOP:
;	JB	BIT_BUFADDR,TXPro_LOOP_ADDRMOVX
;TXPro_LOOP_ADDRMOV:
;	MOV	A,@R0
;	JMP	TXPro_LOOP_ADDROVER
;TXPro_LOOP_ADDRMOVX:
;		;MOVX	A,@R0

;	NOP
;	NOP
;	NOP
;TXPro_LOOP_ADDROVER:
;	CALL	_FUN_ProCard_TXBYTE
;	INC	R0
;	DJNZ	R3,ProCard_TXPro_LOOP
;ProCard_TXProOVER:
;	RET	
;--------------------------------------------------------------------------	
	;PUSH	AR7
	;MOV	R7,#122
	;DJNZ	R7,$
	;POP	AR7
;����50���ֽڵ�ָ���
;ProCard_TXPro_Len:
;	CLR	C
;	MOV	A,AR3
;	SUBB	A,#53
	
;	MOV	R4,A
;	MOV	R3,#53
;ProCard_TXPro_LenTX:

	;����ָ������
;	MOV	AR0,AR7
;ProCard_TXPro_lenLOOP:
;	MOV	A,@R0
;	CALL	_FUN_ProCard_TXBYTE
;	INC	R0
;	DJNZ	R3,ProCard_TXPro_lenLOOP
;	MOV	A,R4
;	JZ	ProCard_TXPro_LENOver
;	MOV	AR3,AR4
	;����FiFo�е�һ���ݵ�����
;	MOV	DATA_IRQEN,#29H			
;	MOV	R7,#0CH				
;	CALL	_FUN_NContact_TESTRc500TxAndRx	
	
	;�Ƚ�FiFo�е�����<=25���ֽ�
;ProCard_TXPro_TXWAIT:
;	MOV	R7,#00H
;	MOV	A,#REG_RC522_FIFOLevelReg
;	RL	A
;	SETB	ACC.7
;	CALL	_FUN_NContact_spio
;	CJNE	A,#30,$+3
;	JNC	ProCard_TXPro_TXWAIT
;ProCard_TXPro_lenLOOP2:
;	MOV	A,@R0

;	MOV	R7,#1;122
;	DJNZ	R7,$

;	CALL	_FUN_ProCard_TXBYTE

;	INC	R0
;	DJNZ	R3,ProCard_TXPro_lenLOOP2
	
;	RET
;///////////////////////////////////////////////////
	
	;MOV	A,R4
	;CALL	_FUN_TEST_DISPLAY	
	
;ProCard_TXPro_PRE:
	;CJNE	R3,#26,$+3
	;JNC	ProCard_TXPro_dy25
;	MOV	R4,#0
	
	;MOV	A,R3
	;MOV	AR0,AR7
	;MOV	A,@R0
	;CALL	_FUN_TEST_DISPLAY	
;	JMP	ProCard_TXPro_LenTX
	
	;����25ʱ
;ProCard_TXPro_dy25:
;	CLR	C
;	MOV	A,AR3
;	SUBB	A,#25
	
;	MOV	R4,A
;	MOV	R3,#25
;	JMP	ProCard_TXPro_LenTX
;ProCard_TXPro_PREWC25:		
	
;ProCard_TXPro_LENOver:
	
	;MOV	A,#33
	;CALL	_FUN_TEST_DISPLAY

	;RET
	
;--------------------------------------------------------------------------
;����:XXX
;�ⲿ����
;XXX	---	XXX
;�ڲ�����:
;����ֵ
;--------------------------------------------------------------------------		
;_rats:
_FUN_ProCard_rats:
	
	;mov	r7,#20
	;call	_fun_lib_delay
	
;ѡ��Ӧ������--->E0 +�����ֽ�(FSDI+CID)+CRC1+CRC2
;bit8~bit5-->FSDI  bit4~bit1-->CID
;FSDI	��0��	��1��	��2��	��3��	��4��	��5��	��6��	��7��	��8��	��9��-��F��
;FSD-->�豸֡����
;(�ֽ�)	16	24	32	40	48	64	96	128	256	RFU>256	
	
	MOV	A,#REG_RC522_FIFODataReg
	RL	A
	MOV	R7,#0e0h
	CALL	_FUN_NContact_spio
	
	MOV	A,#REG_RC522_FIFODataReg
	RL	A
	;---MOV	R7,#50h			;��64�ֽ�
	MOV	R7,#71h			;��128�ֽ�
	CALL	_FUN_NContact_spio
	CLR	BIT_BUFADDR
	SETB	BIT_ProMF	
	MOV	DATA_IRQEN,#23h
	MOV	R5,#DATA_RXBUF

	
	MOV	R7,#0ch
	CALL	_FUN_NContact_Rc500TxAndRx

	CJNE	R7,#0ffh,_rats1
_ratserr:
	MOV	R7,#0ffh
	
	RET
_rats1:
	MOV	A,R7
	
	JZ	_ratserr
_rats2:
	mov	ar1,#DATA_RXBUF			;����DATA_RXBUF
_rats2_1:

	CALL	_FUN_ProCard_RXBYTE
	mov	@r1,a				;����DATA_RXBUF
	;mov	a,r7
	;call	_fun_test_display	
	inc	ar1				;����DATA_RXBUF
	DJNZ	r7,_rats2_1
	
	RET
	
;///////////////////////////////////////////////////////////////////////////////////	
_FUN_Pro_PPS:

;Э��Ͳ���ѡ������=====��PPS����--->PPSS+PPS0+PPS1+CRC1+CRC21	
	MOV	A,#REG_RC522_FIFODataReg
	RL	A
	MOV	R7,#0d1h;0d0h			;PPPS
	CALL	_FUN_NContact_spio
	
	MOV	A,#REG_RC522_FIFODataReg
	RL	A
	;---MOV	R7,#50h				
	MOV	R7,#11h				;PPS0
	CALL	_FUN_NContact_spio
	
	MOV	A,#REG_RC522_FIFODataReg
	RL	A
	;---MOV	R7,#50h			
	MOV	R7,#0ah				;PPS1
	CALL	_FUN_NContact_spio
	
	CLR	BIT_BUFADDR
	SETB	BIT_ProMF	
	MOV	DATA_IRQEN,#23h
	MOV	R5,#DATA_RXBUF
	MOV	R7,#0ch
	CALL	_FUN_NContact_Rc500TxAndRx
	
	CJNE	R7,#0ffh,_rat_NContact_PPS_s1
_rat_NContact_PPS_serr:
	MOV	R7,#0ffh	
	RET
	
_rat_NContact_PPS_s1:
	MOV	A,R7
	
	JZ	_rat_NContact_PPS_serr
_rat_NContact_PPS_s2:
	mov	ar1,#DATA_RXBUF			;����DATA_RXBUF

_rat_NContact_PPS_s2_1:
	CALL	_FUN_ProCard_RXBYTE
	mov	@r1,a				;����DATA_RXBUF
	inc	ar1	
	DJNZ	r7,_rat_NContact_PPS_s2_1
	
	RET
;--------------------------------------------------------------------------
;����:Pro��ͨ����������(_FUN_ProCard_Channel)
;����:
;		Ҫ�ڷ�������ǰ�� 0a/0b + 00����Ҫ����0x01,0x02,0x03
;		�������ķ��������� 0a/0b + 0x00 + 0x01 + 0x02 + 0x03
;�ⲿ����
;R7		---	��Ҫ�������ݵ�buf
;R5		---	��Ҫ�������ݵ�buf
;R3		---	�������ݵĳ���
;BIT_PROF	---	Pro���������	= 0 ��ʾ0A ;= 1 ��ʾ0B
;BIT_GETRESULT	---	=1 ��ʾȡ��ȡ���ؽ��;	=0 ��ʾ��ȡ���ؽ��
;�ڲ�����:
;����ֵ
;	�������ݵĳ���
;--------------------------------------------------------------------------	
_FUN_ProCard_Channel:

	CLR	BIT_BUFADDR		; �ڴ淢��
	PUSH	AR5	
	PUSH	AR3			; 
	CALL	_FUN_ProCard_TXPro	; 	
	POP	AR3
	POP	AR5			; 

	SETB	BIT_BUFADDR		; ������
	MOV	AR7,AR5			; 
	CALL	_FUN_ProCard_RXPro

	;MOV	a,r3							;�е�ESAMѡ1001���PPS��Ӧ���죬����Ҫ�ٲ���һЩ��ʱ
	;CALL	_FUN_TEST_DISPLAY	
	
	
	RET				;

	END
;/////////////////////////////////////////////////////////////////////////////


