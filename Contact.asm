;******************************************************************
;������CPU�Ӵ�����������[�����û�����ESAM���Ļ������������Ļ��������Ǵ��ں�����Searial.asm��]
;_FUN_Contact_INIT		---	��λ��Ƭ[ Ӳ���� ]
;_FUN_Contact_Channel		---	������[���ͣ�Ӳ����(�û���)�����ͣ������(ESAM��)]
;_FUN_Contact_Channel0		---	T0������[���ͣ�Ӳ����(�û���)�����ͣ������(ESAM��)]
;_FUN_Contact_Channel1		---	T1������[���ͣ�Ӳ����(�û���)�����ͣ������(ESAM��)]
;_FUN_Contact_PPS		---	PPS[����ָ��(ֻ����û���)]
;_FUN_Contact_CHANGEBAUD	---	���ò�����[���ڣ�Ӳ��ͬʱ�趨(��ESAM������յĲ�������ʱ���ܴ˺���Ӱ��)]
;******************************************************************
NAME	Contact

$INCLUDE(COMMON.INC)
$INCLUDE(Contact.INC)

	RSEG	?pr?Contact?Mater
	USING	0

;---------------------------------------------------------
;����:��λ��Ƭ[ �������ڲ���]
;�ⲿ����
;Pin_Contact_RST	---	CPU����λ��
;PIN_ESAM_RST		---	ESAM����λ��
;BIT_T0T1		---	��ǰ��ƬЭ��=1��ʾT1;	=0��ʾT0Э��;
;BIT_ESAMICC		---	=1  ��λ�û���  ; = 0  ��λESAM��
;�ڲ�����
;	R7		---	��ʱ��
;����ֵ	
;	R7		---	=#CONST_STATE_TRUE ��ʾ��ȷ=A������ʾ������
;	BIT_T0T1	---	��ǰ��ƬЭ��=1��ʾT1;	=0��ʾT0Э��;
;	DATA_RXBUF	---	��λ��Ϣ
;	R3		---	��λ��Ϣ����
;�����Ӻ���
;-------------------------------------------------------------
_FUN_Contact_INIT:
		
	JB	BIT_ESAMICC,Contact_INIT_USERCARD	;��ǰ�����Ӵ���������=1��ʾ�û���;=0��ʾESAM	
	
	;ESAM��λ
Contact_INIT_ESAM:
	;--- ǿ�и�λCPU�� ---
	CLR	PIN_ESAM_RST
	MOV	R7,#030H
	CALL	_FUN_LIB_DELAYSIMPLAY
	SETB	PIN_ESAM_RST
	
	;--- �������� ---
	CLR	BIT_BUFADDR			;BIT_BUFADDR		---	=0���������ݵ��ڴ棻=1���������ݵ����
	SETB	BIT_SERIALOVERTIMERX		;BIT_SERIALOVERTIMERX	---	���ڵȴ������Ƿ���ʱ��,����=0û������;=1��ʱ������
	SETB	BIT_VERIFY			;BIT_VERIFY		---	�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ
	MOV	R7,#DATA_RXBUF			;R7			---	��Ҫ�����ַ���buf��ָ��
	MOV	R3,#0
	CALL	_FUN_SERIAL_RXSOFT
	;---------------
	;JMP	Contact_INIT_OVER
	;MOV	A,#13
	;MOV	A,R3	
	;JMP	_FUN_TEST_DISPLAY
	;-------------------
	
	MOV	R7,#CONST_STATE_TRUE
	JMP	Contact_INIT_RSTDEAL	

	;--- �û�����λ ---
Contact_INIT_USERCARD:
jmp	Contact_INIT_ERR02

	;--- ǿ�и�λCPU�� ---
;---	CLR	Pin_Contact_RST
;	MOV	R7,#255;030H
;	CALL	_FUN_LIB_DELAYSIMPLAY
	MOV	R7,#255
	DJNZ	R7,$
	MOV	R7,#255
	DJNZ	R7,$
	MOV	R7,#255
	DJNZ	R7,$
	MOV	R7,#255
	DJNZ	R7,$
	MOV	R7,#255
	DJNZ	R7,$
	MOV	R7,#255
	DJNZ	R7,$
	MOV	R7,#255
	DJNZ	R7,$
	MOV	R7,#255
	DJNZ	R7,$
	MOV	R7,#255
	DJNZ	R7,$
	MOV	R7,#255
	DJNZ	R7,$	
	
	;---SETB	Pin_Contact_RST
	
	;PUSH	AR7
	;MOV	R7,#1
	;CALL	_FUN_LIB_DELAY
	;POP	AR7
	
	;--- �������� ---
	CLR	BIT_BUFADDR
	SETB	BIT_SERIALOVERTIMERX
	SETB	BIT_VERIFY
	MOV	R7,#DATA_RXBUF
	MOV	R3,#0
	
;	MOV R0,#XDATA_SOFTFIRSTSCANTIME
;	MOV A,#5
;	MOVX @R0,A
	;---CALL	_FUN_SERIAL_RXHARD
	;CALL	_FUN_SERIAL_RXHBYTE
	CALL	_FUN_SERIAL_RXHBYTE
	MOV	A,R7
	JNZ	Contact_INIT_ERR02
	MOV	A,R5
	XRL	A,#3BH
	JNZ	Contact_INIT_ERR02
	CLR	BIT_T0T1
	MOV	R7,#CONST_STATE_TRUE
	
	RET	
Contact_INIT_ERR02:
	MOV	R7,#CONST_STATE_FALSE
	RET
	
;	MOV R0,#XDATA_SOFTFIRSTSCANTIME
;	MOV A,#30H
;	MOVX @R0,A

	;MOV	R7,#CONST_STATE_TRUE
	
	;~~~~~~~~~~���Զ�~~~~~~~~~~
	; JMP	Contact_INIT_OVER
	; MOV	A,#131
	; MOV	A,R3
	; JMP	_FUN_TEST_DISPLAY
	; JMP	Contact_INIT_HEAD
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
Contact_INIT_RSTDEAL:
	
	;--- �жϸ�λ��ȡ�ķ��ص��ֽ����Ƿ�Ϊ�� ---	
	MOV	A,R3
	JNZ	Contact_INIT_ZERO
	MOV	R7,#CONST_STATE_FALSE
	MOV	R3,#0
	JMP	Contact_INIT_OVER
	
Contact_INIT_ZERO:
	MOV	R0,#DATA_RXBUF
	MOV	A,@R0
	;~~~~~~~~~~���Զ�~~~~~~~~~~
	; JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~		
	XRL	A,#3BH
	JZ	Contact_INIT_HEAD
	MOV	R7,#CONST_STATE_FALSE
	MOV	R3,#0
	JMP	Contact_INIT_OVER
Contact_INIT_HEAD:
	
	;--- ��¼��ǰ�û����Ĳ����� ---
	MOV	R0,#DATA_RXBUF+2
	MOV	A,@R0
	MOV	R0,#XDATA_HighBaud
	;~~~~~~~~~~���Զ�~~~~~~~~~~
	; JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~	
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	;--- ����Э�� ---
	MOV	R0,#DATA_RXBUF + 1
	MOV	A,@R0
	MOV	C,ACC.7
	MOV	BIT_T0T1,C
	
Contact_INIT_OVER:
	CLR	BIT_T0T1
	RET	
;///////////////////////////////////////////////////////////////////////////////////////////////////////
	
	;--- ǿ�и�λCPU�� ---
	;---CLR	Pin_Contact_RST
	MOV	R7,#030H
	CALL	_FUN_LIB_DELAYSIMPLAY
	;---SETB	Pin_Contact_RST
	
	;--- ��ȡ���ֽ� ---
	SETB	BIT_VERIFY	
	CALL	_FUN_SERIAL_RXHBYTE
	;~~~~~~~~~~���Զ�~~~~~~~~~~
	; JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	XRL	A,#3BH
	JZ	Contact_INIT_ReadCtrl
	JMP	Contact_INIT_ERR
Contact_INIT_ReadCtrl:;�����ֽ�
	CALL	_FUN_SERIAL_RXHBYTE
	
	MOV	R3,A
	;~~~~~~~~~~���Զ�~~~~~~~~~~
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~		
	
	;--- ��¼��ƬЭ�� ---
	MOV	C,ACC.7
	MOV	BIT_T0T1,C
		
	;RRC	A
	ANL	A,#0FH
        MOV	R6,A
	
	;~~~~~~~~~~���Զ�~~~~~~~~~~
	; JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~	             
	
;-------------------------------------------------------------------
_cpucardresctl1:
	
        MOV	A,R3			;E9	31
        jbc	acc.4,_cpucardresctl2	;TA1	�� jbc = jb + clr bit
      	jbc	acc.5,_cpucardresctl2	;TB1	00
        jbc	acc.6,_cpucardresctl2	;TC1	00
        jnb	acc.7,_cpucardresdat	;TD1	81

        CALL	_FUN_SERIAL_RXHBYTE
        JB	BIT_RXSerialBaud,_cpucardresctl1_ReadBaud
        SETB	BIT_RXSerialBaud
	MOV	R0,#XDATA_HighBaud	
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A	
_cpucardresctl1_ReadBaud:   
	
        mov	r3,a			;31
        anl	A,#0fh
        cjne	A,#1,_cpucardresctl1
        setb	BIT_rstype
        jmp	_cpucardresctl1
_cpucardresctl2:
        MOV	R3,A
	PUSH	AR3
        call	_FUN_SERIAL_RXHBYTE

        JB	BIT_RXSerialBaud,_cpucardresctl2_ReadBaud
        SETB	BIT_RXSerialBaud
	MOV	R0,#XDATA_HighBaud	
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A	
_cpucardresctl2_ReadBaud:   

        POP	AR3
        jmp	_cpucardresctl1

;-------------------------------------------------------------------

_cpucardresdat:						; 
	MOV	A,r6					; R2	???
	MOV	r3,A					; 
	;~~~~~~~~~~���Զ�~~~~~~~~~~
	; JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~		
	;INC	R6
_cpucardresdat1:					; 
        CALL	_FUN_SERIAL_RXHBYTE			; 

        JB	BIT_RXSerialBaud,_cpucardresdat1_ReadBaud
        SETB	BIT_RXSerialBaud
	MOV	R0,#XDATA_HighBaud	
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A	
_cpucardresdat1_ReadBaud:   
							; R1 ???
        ;CJNE	r1,#0,_cpucardresdat2			; 
	;MOV	@R1,a					; 
        ;INC	R1					; 
_cpucardresdat2:        				; 
        DJNZ	R6,_cpucardresdat1			; ��ʷ�ֽ�

;-------------------------------------------------------------------        
	
        jnb	BIT_rstype,_cpucardresdat3
        call	_FUN_SERIAL_RXHBYTE
	
        cjne	r6,#0,Contact_INIT_ERR
        mov	a,r3
        mov	r6,a

_cpucardresdat3:
	;~~~~~~~~~~���Զ�~~~~~~~~~~
	; MOV	A,#33
	; JMP	_FUN_TEST_DISPLAY
	; CLR	BIT_T0T1
	
	;MOV	R0,#XDATA_HighBaud	
	;MOV	A,#18H
	;	;MOVX	@R0,A
	;MOV 	DPH,#1 
	;MOV 	DPL,R0 
	;MOVX 	@DPTR,A
	
	MOV	r7,#255
	DJNZ	r7,$
	
	MOV	r7,#255
	DJNZ	r7,$	
	
	MOV	r7,#255
	DJNZ	r7,$
	
	MOV	r7,#255
	DJNZ	r7,$		
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~	

	mov	r7,#CONST_STATE_TRUE
        ret
	RET
	
Contact_INIT_ERR:
	MOV	R7,#CONST_STATE_FALSE
	MOV	R3,#0
	RET
	
;---------------------------------------------------------
;����:������[ ����Ӳ���ڲ��� ]
;�ⲿ����
;	BIT_GETRESULT		=1��ʾȡ0ʱ��ȡ���ؽ����=0��ʾ��ȡ���ؽ��(ֻ��T0����ָ�����5���ֽڵ�ָ����Ч��pro��Ч)
;	BIT_ESAMICC		---	��ǰ�����Ӵ���������=1��ʾ�û���;=0��ʾESAM
;	R7			---	����緳�ָ��(�ڴ�)
;	R5			---	������緳�ָ��(���)
;	R3			---	��Ҫ�������ݵĳ���
;����ֵ
;	R3			---	��Ҫ�������ݵĳ������ݵĳ���
;---------------------------------------------------------
_FUN_Contact_Channel:
	
	;CLR	PIN_5830_CE	
	;---JB	BIT_T0T1,_FUN_Contact_Channel1EX
	JMP	_FUN_Contact_Channel0
		
;Contact cpu card T1	
_FUN_Contact_Channel1EX:
	MOV	R3,#0
	RET
;t1:	
;	MOV	A,#XDATA_TXBUF
;	ADD	A,R3
;	MOV	R1,A
;	DEC	R1
	
;	INC	A
;	INC	A
;	MOV	R0,A
;	INC	A
	
;	MOV	A,R3
;	ADD	A,#3
;	MOV	R2,A	
;Contact_OPRET_LOOP:
;		;MOVX	A,@R1

;		;MOVX	@R0,A

;	DEC	R1
;	DEC	R0
;	DJNZ	R2,Contact_OPRET_LOOP	
;	JMP	_FUN_Contact_Channel1		
;	RET

;---------------------------------------------------------
;����:T1������[ ����Ӳ���ڲ��� ]
;	���͹������ڷ���PSAM������ǰ�� 0x00 + 0x0x00/0x40 + ����
;	��Ҫ���͸�PSAM���������� 0x01,0x02,0x03��
;	�����ķ���������0x00 + 0x0x00/0x40 + 0x03 + 0x01 + 0x02 + 0x03 + BCC
;�ⲿ����
;	XDATA_TXBUFCPUSTART	---	��������緳�
;	DATA_RXBUFCPUSTART	---	��������緳�
;	BIT_LASTF		---	��Ƭ��һ�η��͵���� = 0��Ϊ0x00�� = 1���ʾ0x40;
;	R3			---	��Ҫ�������ݵĳ������ݵĳ���
;	R6			---	BCC
;�ڲ�����
;	XXX			---	YYY
;�����Ӻ���
;����ֵ
;	R3			---	���յ����ݵĳ���
;	R7			---	����״̬
;-------------------------------------------------------------
_FUN_Contact_Channel1:

	;--- ����[0x00 + 0x00/0x40]��ͷ�� ---
	;MOV	R0,#XDATA_TXBUFCPUSTART
	;DEC	R0
	;DEC	R0
	;DEC	R0

;	MOV	R0,#XDATA_TXBUF
;	CLR	A
;		;MOVX	@R0,A

;	INC	R0

;	JB	BIT_LASTF,Contact_OPRET1_40
;	CLR	A
;		;MOVX	@R0,A

;	JMP	Contact_OPRET1_NUM

Contact_OPRET1_40:
;	MOV	A,#40H
;		;MOVX	@R0,A

Contact_OPRET1_NUM:
;	CPL	BIT_LASTF
;	INC	R0

;	MOV	A,R3						;LEN
;		;MOVX	@R0,A

	;����BCC 00 00 05 00 84 00 00 08 05
;	MOV	A,R3
;	ADD	A,#3
;	MOV	R2,A
;	MOV	R6,#0
;	MOV	R0,#XDATA_TXBUF
Contact_OPRET1_SENDBCC:
;		;MOVX	A,@R0

;	XRL	A,R6
;	XCH	A,R6
;	INC	R0
;	DJNZ	R2,Contact_OPRET1_SENDBCC

	;---------MOV	A,#XDATA_TXBUFCPUSTART
;	ADD	A,R3
;	MOV	R0,A
;	MOV	A,R6
;		;MOVX	@R0,A


;	SETB	BIT_BUFADDR					;BIT_BUFADDR	---	= 0�����͵����ڴ����ݣ�=1�����͵����������
;	SETB	BIT_VERIFY					;BIT_VERIFY	---	�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ	
;	MOV	R7,#XDATA_TXBUF					;R7		---	��Ҫ�������ݵ�buf
;	MOV	A,R3
;;	ADD	A,#4
;	MOV	R3,A
;	MOV	R5,#CONST_SOFTBYTESP
;	CALL	_FUN_SERIAL_TXSOFT

;	JB	BIT_ESAMICC,Contact_OPRET1_USERCARD
	
Contact_OPRET1_ESAM:
	;---- �������� ----
;	CLR	BIT_BUFADDR
;	SETB	BIT_SERIALOVERTIMERX
;	SETB	BIT_VERIFY
;	MOV	R7,#DATA_RXBUF
;	MOV	R3,#0
;	CALL	_FUN_SERIAL_RXHARD
;	JMP	Contact_OPRET1_RXOVER
Contact_OPRET1_USERCARD:
	;---- �������� ----
;	CLR	BIT_BUFADDR
;	SETB	BIT_SERIALOVERTIMERX
;	SETB	BIT_VERIFY
;	MOV	R7,#DATA_RXBUF
;	MOV	R3,#0
;	CALL	_FUN_SERIAL_RXHARD
Contact_OPRET1_RXOVER:
	
	;--- ��֤BCC�Ƿ���ȷ ---
;	MOV	R0,#DATA_RXBUF
;	MOV	R6,#0
;	PUSH	AR3
Contact_OPRET1_ValidateBCC:
;	MOV	A,@R0
;	XRL	A,R6
;	XCH	A,R6
;	INC	R0
;	DJNZ	R3,Contact_OPRET1_ValidateBCC
;	POP	AR3
;;
;	MOV	A,R6
;	MOV	R7,A

Contact_OPRET1_OVER:

	RET

;---------------------------------------------------------
;����:T0������[ �������ڲ��� ]
;	���͹����ȷ���CLS + INC + P1 + P2 + LC + DATAs
;	�磺 00A40000023F00	---	(CLS + INC + P1 + P2 + LC + DATA)
;	����:0084000008		---	(CLS + INC + P1 + P2 + LC + LE)
;��ʽһ
;	1���������ݣ�CLS + INC + P1 + P2 + LC
;	2���������ݣ�INC
;	3���������ݣ�Data �� LE
;	4���������ݣ�61 + Len(���ݳ���) �� SW12[�������û��5��6��]
;	5���������ݣ����� 00 + 0C + 00 + 00 + Len(���ݳ���)
;	6���������ݣ����� + SW12
;��ʽ��
;	1���������ݣ�CLS + INC + P1 + P2 + LC
;	2���������ݣ�INC + DATA

;�ⲿ����
;	BIT_GETRESULT		=1��ʾȡT0ʱ��ȡ���ؽ����=0��ʾ��ȡ���ؽ��(ֻ��T0����ָ�����5���ֽڵ�ָ����Ч)
;	BIT_ESAMICC		---	��ǰ�����Ӵ���������=1��ʾ�û���;=0��ʾESAM
;	R7			---	����緳�ָ��(�ڴ�)
;	R5			---	������緳�ָ��(���)
;	R3			---	��Ҫ�������ݵĳ���

;�ڲ�����
;����ֵ:
;	R7		---	ִ��״̬
;	R3		---	���ճ���
;�����Ӻ���
;-------------------------------------------------------------
_FUN_Contact_Channel0:
	
	;~~~~~ ���ò��Զ� ~~~~~
	;MOV	A,#31
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~	

	;1���������ݣ�CLS + INC + P1 + P2 + LC
	;��������
	PUSH	AR3
	SETB	BIT_BUFADDR					;BIT_BUFADDR	---	= 0�����͵����ڴ����ݣ�=1�����͵����������
	SETB	BIT_VERIFY					;BIT_VERIFY	---	�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ
	
	;��¼����緳����
	MOV	A,R5
	MOV	R0,#DATA_XDATAP
	MOV	@R0,A	
	
	;��¼����緳����
	MOV	A,R7
	MOV	R0,#DATA_DATAP	
	MOV	@R0,A
	
	;��¼����������
	INC	A		
	MOV	R0,A
	MOV	A,@R0				
	MOV	R6,A			
	;~~~~~~~~~~~~~~~~~~
	;XRL	A,#0B2H						;0A4H
	;JNZ	Contact_Channel0_Start
	;JMP	TESTContact_Channel0_Start		
	;inc	r0
	;inc	r0
	;inc	r0
	;inc	r0	
	;MOV	A,@R0	
	;call	_fun_test_display
	;~~~~~~~~~~~~~~~~~~	
Contact_Channel0_Start:
	
	;--- ����ָ��(5 Byte) ---
	MOV	R0,#DATA_DATAP
	MOV	A,@R0
	MOV	R7,A
	MOV	R5,#CONST_SOFTBYTESP
	MOV	R3,#5
	CLR	BIT_BUFADDR					;=0�����͵����ڴ����ݣ�=1�����͵����������
	SETB	BIT_VERIFY					;�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ						
	PUSH	AR6
	CALL	_FUN_SERIAL_TXSOFT
	POP	AR6
	;~~~~~ ���ò��Զ� ~~~~~
	;MOV	A,#32
	;MOV	A,R6
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~		
	
	;--- ���㽫Ҫ���տ�Ƭ�������ݵĳ��� ---
	;���ָ���<=5������ճ���ΪLe + 2�����>=6����Ӧ��0[�������֣���������ճ�����ΪSW12��Ӧ����һ���ֽ�Ȼ�󷵻�]
	POP	AR3
	MOV	AR2,AR3
	
	PUSH	AR2
	CJNE	R3,#6,$+3
	JC	Contact_Channel0_RXOther
Contact_Channel0_RX1:;����1���ֽڵĳ���
	MOV	R3,#0
	JMP	Contact_Channel0_RXOver
Contact_Channel0_RXOther:	;����N���ֽڵĳ���
	MOV	R0,#DATA_DATAP	
	MOV	A,@R0
	ADD	A,#4
	MOV	R0,A
	MOV	A,@R0
	INC	A
	INC	A
	MOV	R3,A	
Contact_Channel0_RXOver:
	
	;--- ����������	---
	PUSH	AR3
	JB	BIT_ESAMICC,Contact_Channel0_USERCARDRXCMD
Contact_Channel0_ESAM0RXCMD:	
	SETB	BIT_SERIALOVERTIMERX		;���ڵȴ������Ƿ���ʱ��,����=0û������;=1��ʱ������
	SETB	BIT_VERIFY			;�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ
	SETB	BIT_SERFIRBYTE			;=1 ���ó���ʱ���գ����ڽ��տ�Ƭ��һ���ֽڷ��أ�,���ö̳�ʱ����(���ڽ��տ�Ƭ��һ��֮����ֽڷ���)
	CALL	_FUN_SERIAL_RXSBYTE		;���ڽ��յ����ֽڵ�����
	JMP	Contact_Channel0_RXCMD
Contact_Channel0_USERCARDRXCMD:
	CALL	_FUN_SERIAL_RXHBYTE		;Ӳ���ڽ��յ����ֽڵ�����
	
	;~~~~~ ���ò��Զ� ~~~~~
	;MOV	A,#33
	;MOV	A,R7
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~		
Contact_Channel0_RXCMD:	
	
	POP	AR3	;����ָ���
	POP	AR2	;����ָ���
	
	MOV	A,R7
	;~~~~~ ���ò��Զ� ~~~~~
	;MOV	A,#34
	;MOV	A,R7
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~		
	XRL	A,#CONST_STATE_TRUE
	JZ	Contact_Channel0_CMDState	;������ȷ	
	JMP	Contact_Channel0_ERR		;������ճ����������
Contact_Channel0_CMDState:
	MOV	A,R5
	;~~~~~ ���ò��Զ� ~~~~~	
;	XRL	A,#0B4H
;	JNZ	Contact_Channel0_TEST01
;	SETB	BIT_CKXT
	;CALL	_fun_test_display
;Contact_Channel0_TEST01:
;	MOV	A,R5
	;MOV	A,#35
	;MOV	A,R5
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~		
	XRL	A,R6		;�鿴�����֣��Ƿ�ͷ��ص�һ��
	JZ	Contact_Channel0_CMDOK
	
	;--- ��������ֲ��ԣ���ʾ�յ�����SW12 ---
Contact_Channel0_CMDErr:	;�����ֲ���
	PUSH	AR5
	SETB	BIT_SERIALOVERTIMERX		;���ڵȴ������Ƿ���ʱ��,����=0û������;=1��ʱ������
	SETB	BIT_VERIFY			;�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ
	SETB	BIT_SERFIRBYTE			;=1 ���ó���ʱ���գ����ڽ��տ�Ƭ��һ���ֽڷ��أ�,���ö̳�ʱ����(���ڽ��տ�Ƭ��һ��֮����ֽڷ���)	
	CALL	_FUN_SERIAL_RXSBYTE
	MOV	AR4,AR5
	POP	AR5	
	
	MOV	A,R7
	XRL	A,#CONST_STATE_TRUE
	JZ	Contact_Channel0_RXSW2OK		;����SW02��ȷ
	JMP	Contact_Channel0_ERR
Contact_Channel0_RXSW2OK:		
	
	MOV	R3,#2			;���ճ���Ϊ2
	;����緳����
	MOV	R0,#DATA_XDATAP		
	MOV	A,@R0	
	MOV	R0,A
	
	;����sw12������緳岢����
;	MOV	A,R4
;		;MOVX	@R0,A

;	INC	R0
;	MOV	A,R5

	MOV	A,R5
		;MOVX	@R0,A

	;push	dph
	;push	dpl
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
	JMP	Contact_Channel0_OVER	;����SW12��Ȼ�󷵻�
	;JMP	Contact_Channel0_ERR								;������ճ����������
	
	;--- ������������ȷ ---
Contact_Channel0_CMDOK:
		
	;MOV	AR2,AR3				;������ճ���
	;POP	AR3				;�������ͳ���
	MOV	A,R2
	CJNE	A,#6,$+3	
	JNC	Contact_Channel0_MODE1
	JMP	Contact_Channel0_MODE2
Contact_Channel0_MODE1:				;T0��ʽһ		���ճ��ȱ��� = 1
	

	;~~~~~~~ ���ò��Զ� ~~~~~
	;MOV	A,#36
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~
	
	;�������ݣ�Data �� Lc
	CLR	BIT_BUFADDR			;BIT_BUFADDR	---	= 0�����͵����ڴ����ݣ�=1�����͵����������
	SETB	BIT_VERIFY			;BIT_VERIFY	---	�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ
	MOV	R0,#DATA_DATAP
	MOV	A,@R0
	ADD	A,#5
	MOV	R7,A	
	;~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~~
	;MOV	AR0,AR7
	;INC	R0
	;MOV	A,@R0
	;MOV	A,R2
	;jmp	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	MOV	R5,#CONST_SOFTBYTESP
	MOV	A,R2		;��Ƭָ����ݴ���R2��
	CLR	C
	SUBB	A,#5
	MOV	R3,A
	CALL	_FUN_SERIAL_TXSOFT	
	
	;4���������ݣ�61 + Len(���ݳ���)
	JB	BIT_ESAMICC,Contact_Channel0_USERCARD02
Contact_Channel0_ESAM02:
	
	;---- �������� ----
	SETB	BIT_BUFADDR			;=0�����͵����ڴ����ݣ�=1�����͵����������
	SETB	BIT_SERIALOVERTIMERX		;;���ڵȴ������Ƿ���ʱ��,����=0û������;=1��ʱ������
	SETB	BIT_VERIFY			;�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ	
	;---MOV	R7,#DATA_RXBUF
	MOV	R0,#DATA_XDATAP
	MOV	A,@R0
	MOV	R7,A
	MOV	R3,#2	
	CALL	_FUN_SERIAL_RXSOFT
	JMP	Contact_Channel0_RXOVER02
Contact_Channel0_USERCARD02:
	;---- �������� ----
	SETB	BIT_BUFADDR			;=0�����͵����ڴ����ݣ�=1�����͵����������
	SETB	BIT_SERIALOVERTIMERX		;;���ڵȴ������Ƿ���ʱ��,����=0û������;=1��ʱ������
	SETB	BIT_VERIFY			;�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ	
	;CLR	BIT_ISFRX			;=0��ʾ���ڵ�һ���ֽڽ���   ;1��ʾ��һ���ֽڲ�����		
	;--- MOV	R7,#DATA_RXBUF
	MOV	R0,#DATA_XDATAP
	MOV	A,@R0
	MOV	R7,A
	MOV	R3,#2
	CALL	_FUN_SERIAL_RXHARD
Contact_Channel0_RXOVER02:
	;~~~~~~~ ���ò��Զ� ~~~~~
	;MOV	A,#37
;	JNB	BIT_CKXT,Contact_Channel0_TEST02
;	MOV	A,R3
;	CALL	_FUN_TEST_DISPLAY
;Contact_Channel0_TEST02:
	;~~~~~~~~~~~~~~~~~~~~~~~~		
		
	MOV	A,R3
	XRL	A,#2
	;---JNZ	Contact_Channel0_ERR	
	JZ	Contact_Channel0_RX61Right
	JMP	Contact_Channel0_ERR
	
Contact_Channel0_RX61Right:	
	
	;����ֵ��ʱ�п�����61 + ����,Ҳ������SW12
	MOV	R0,#DATA_XDATAP
	MOV	A,@R0
	MOV	R0,A
		;MOVX	A,@R0
	;push	dph
	;push	dpl
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;pop	dpl
	;pop	dph
	XRL	A,#61H
	
	;~~~~~~~ ���ò��Զ� ~~~~~
;	JNB	BIT_CKXT,Contact_Channel0_TEST02
	;MOV	A,R3
;	CALL	_FUN_TEST_DISPLAY
;Contact_Channel0_TEST02:	
	;MOV	A,#38
	;MOV	A,R3
	;inc	r0
	;	;MOVX	A,@R0
;	MOV	DPH,#1
	;MOV	DPL,R0
	;MOVX	A,@DPTR	

	;CALL	_FUN_TEST_DISPLAY
			
	;~~~~~~~~~~~~~~~~~~~~~~~~		
	JZ	Contact_Channel0_61LEN
	JMP	Contact_Channel0_OVER
	
Contact_Channel0_61LEN:
	;~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~~	
	;JNB	BIT_CKXT,Contact_Channel0_TEST02
	;MOV	A,R3
;	CLR	A
;	MOV	C,BIT_GETRESULT
;	MOV	ACC.0,C
	;CALL	_FUN_TEST_DISPLAY
;Contact_Channel0_TEST02:	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	;~~~~~~~ ���ò��Զ� ~~~~~
	;MOV	A,#38
;	clr	a
;	mov	c,BIT_GETRESULT
;	mov	acc.0,c
;	CALL	_FUN_TEST_DISPLAY

	;~~~~~~~~~~~~~~~~~~~~~~~~	
	JB	BIT_GETRESULT,Contact_Channel0_GetResult	
	JMP	Contact_Channel0_OVER;��������
	
Contact_Channel0_GetResult:;��ؽ��
	
	;--- ���յ��ĳ��� ---
	MOV	R0,#DATA_XDATAP
	MOV	A,@R0
	INC	A
	MOV	R0,A
		;MOVX	A,@R0
	;push	dph
	;push	dpl
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;pop	dpl
	;pop	dph
	
	cjne	a,#120,$+3
	jc	Contact_Channel0_GetResultrx
	;call	_fun_test_display
	
	;~~~~~ ���ò��Զ� ~~~~~
	;MOV	A,#31
	;mov	a,sp
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~		
	
	jmp	Contact_Channel0_ERR
	
Contact_Channel0_GetResultrx:
	PUSH	ACC
	;~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~~
	;Ϊ��Ӧ�����ESAM��������40us
	jb	BIT_ESAMICC,Contact_Channel0_GetC0
	push	ar7
	mov	r7,#240
	djnz	r7,$
	pop	ar7
Contact_Channel0_GetC0:
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	;5���������ݣ����� 00 + 0C + 00 + 00 + Len(���ݳ���)
	;---MOV	R0,#XDATA_TXBUF
	MOV	R0,#DATA_DATAP
	MOV	A,@R0	
	MOV	R0,A
	
	CLR	A
	MOV	@R0,A
	INC	R0
	MOV	A,#0C0H
	MOV	@R0,A
	INC	R0		
	CLR	A
	MOV	@R0,A
	INC	R0
	MOV	@R0,A
	INC	R0
	POP	ACC
	MOV	@R0,A
	
	;--- ����ʵ�ʽ�Ҫ���յ����ݳ��� ---
	INC	A
	INC	A
	MOV	R3,A
	PUSH	AR3
	;~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~~
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
	
	CLR	BIT_BUFADDR	;BIT_BUFADDR	---	= 0�����͵����ڴ����ݣ�=1�����͵����������
	SETB	BIT_VERIFY	;BIT_VERIFY	---	�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ
	;---MOV	R7,#XDATA_TXBUF	;R7		---	��Ҫ�������ݵ�buf
	MOV	R0,#DATA_DATAP
	MOV	A,@R0
	MOV	R7,A
	
	MOV	R5,#CONST_SOFTBYTESP
	MOV	R3,#5
	CALL	_FUN_SERIAL_TXSOFT
		
	;--- ����C0 ---
Contact_Channel0_rxc00:
	JB	BIT_ESAMICC,Contact_Channel0_USERCARDRXC0
Contact_Channel0_ESAM0RXC0:	
	SETB	BIT_SERIALOVERTIMERX		;���ڵȴ������Ƿ���ʱ��,����=0û������;=1��ʱ������
	SETB	BIT_VERIFY			;�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ
	SETB	BIT_SERFIRBYTE			;=1 ���ó���ʱ���գ����ڽ��տ�Ƭ��һ���ֽڷ��أ�,���ö̳�ʱ����(���ڽ��տ�Ƭ��һ��֮����ֽڷ���)
	CALL	_FUN_SERIAL_RXSBYTE		;���ڽ��յ����ֽڵ�����
	JMP	Contact_Channel0_RXC0
Contact_Channel0_USERCARDRXC0:
	CALL	_FUN_SERIAL_RXHBYTE		;Ӳ���ڽ��յ����ֽڵ�����
Contact_Channel0_RXC0:	
	POP	AR3				;

;	MOV	A,R7
;	XRL	A,#CONST_STATE_TRUE
;	JZ	Contact_Channel0_RXC0STATEOK	;������ȷ	
;	JMP	Contact_Channel0_ERR		;������ճ����������
;Contact_Channel0_RXC0STATEOK:
	MOV	A,R5
	XRL	A,#0C0H

	JZ	Contact_Channel0_RXC0OK
	JMP	Contact_Channel0_ERR		;������ճ����������	
Contact_Channel0_RXC0OK:
		
	;6���������ݣ����� + SW12
	JB	BIT_ESAMICC,Contact_Channel0_USERCARD03
Contact_Channel0_ESAM03:
	;---- �������� ----
	SETB	BIT_BUFADDR			;=0�����͵����ڴ����ݣ�=1�����͵����������
	SETB	BIT_SERIALOVERTIMERX		;;���ڵȴ������Ƿ���ʱ��,����=0û������;=1��ʱ������
	SETB	BIT_VERIFY			;�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ	
	;CLR	BIT_ISFRX			;=0��ʾ���ڵ�һ���ֽڽ���   ;1��ʾ��һ���ֽڲ�����		
	;---MOV	R7,#DATA_RXBUF
	;MOV	R3,A		
	MOV	R0,#DATA_XDATAP
	MOV	A,@R0
	MOV	R7,A
	CALL	_FUN_SERIAL_RXSOFT
	JMP	Contact_Channel0_RXOVER03
Contact_Channel0_USERCARD03:
	;---- �������� ----
	SETB	BIT_BUFADDR			;=0�����͵����ڴ����ݣ�=1�����͵����������
	SETB	BIT_SERIALOVERTIMERX		;;���ڵȴ������Ƿ���ʱ��,����=0û������;=1��ʱ������
	SETB	BIT_VERIFY			;�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ	
	;CLR	BIT_ISFRX			;=0��ʾ���ڵ�һ���ֽڽ���   ;1��ʾ��һ���ֽڲ�����		
	;---MOV	R7,#DATA_RXBUF
	;MOV	R3,A	
	MOV	R0,#DATA_XDATAP
	MOV	A,@R0
	MOV	R7,A	
	;~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~~
	;MOV	A,R3
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	CALL	_FUN_SERIAL_RXHARD
Contact_Channel0_RXOVER03:

	;~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~~	
;	MOV	A,R3	
;	MOV	R0,#DATA_XDATAP
;	MOV	A,@R0
;	add	a,r3
;	dec	a
;	dec	a
;	MOV	R0,A
;		;MOVX	A,@R0

;	JMP	_FUN_TEST_DISPLAY	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	MOV	A,R3
	;CJNE	A,#4,$+3
	CJNE	A,#2,$+3
	JC	Contact_Channel0_ERR

	;---MOV	R7,#DATA_RXBUF
	MOV	R0,#DATA_XDATAP
	MOV	A,@R0
	MOV	R7,A		
	JMP	Contact_Channel0_OVER
Contact_Channel0_MODE2:			;T0��ʽ��,���ճ��ȱ��� > 1

	JB	BIT_ESAMICC,Contact_Channel0_USERLe
Contact_Channel0_ESAMLe:;����ESAM��LE����

	;---- �������� ----
	SETB	BIT_BUFADDR			; =0�����͵����ڴ����ݣ�=1�����͵����������
	SETB	BIT_SERIALOVERTIMERX		; ���ڵȴ������Ƿ���ʱ��,����=0û������;=1��ʱ������
	SETB	BIT_VERIFY			; �����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ
	;CLR	BIT_ISFRX			; = 0 ��ʾ���ڵ�һ���ֽڽ���   ;1 ��ʾ��һ���ֽڲ�����	
	MOV	R0,#DATA_XDATAP
	MOV	A,@R0
	MOV	R7,A
	CALL	_FUN_SERIAL_RXSOFT
	
	JMP	Contact_Channel0_MODEOVER
Contact_Channel0_USERLe:;�����û���LE����
	
	;---- �������� ----
	SETB	BIT_BUFADDR			; =0�����͵����ڴ����ݣ�=1�����͵����������
	SETB	BIT_SERIALOVERTIMERX		; ���ڵȴ������Ƿ���ʱ��,����=0û������;=1��ʱ������
	SETB	BIT_VERIFY			; �����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ	
	;CLR	BIT_ISFRX			; =0��ʾ���ڵ�һ���ֽڽ���   ;1��ʾ��һ���ֽڲ�����		
	MOV	R0,#DATA_XDATAP
	MOV	A,@R0
	MOV	R7,A

	;~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~~
	;MOV	A,R3
	;MOV	A,#33
	;JMP	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	CALL	_FUN_SERIAL_RXHARD

	JMP	Contact_Channel0_OVER	;�������,��������	
Contact_Channel0_MODEOVER:
	
Contact_Channel0_OVER:
	;~~~~~~~~~~~~~���Զ�~~~~~~~~~~~~~
	;Ϊ��Ӧ�����ESAM��������40us
	jb	BIT_ESAMICC,Contact_Channel0_Getover
	push	ar7
	mov	r7,#240
	djnz	r7,$
	pop	ar7
Contact_Channel0_Getover:
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	RET	
	
	

Contact_Channel0_ERR:
	MOV	R3,#0			;��ʱ��Ԫ
	MOV	R7,#CONST_STATE_FALSE	

	RET



Contact_Channel0_ERR001:
	MOV	R3,#0			;��ʱ��Ԫ
	MOV	R7,#134	
	RET

Contact_Channel0_ERR002:
	MOV	R7,A
	RET
	
	
;---------------------------------------------------------	
;����:���ò�����
;�ⲿ����
;R7	---	CONST_BAUD_9600:��ʾ 9600
;		CONST_BAUD_38400:��ʾ 38400
;		CONST_BAUD_115200:��ʾ 115200
;		CONST_BAUD_115200PC ��ʾ����������115200����
;---------------------------------------------------------	
_FUN_Contact_CHANGEBAUD:
	
	CJNE	R7,#CONST_BAUD_9600,Contact_CHANGEBAUD38400
	;--- ���ò�����Ϊ9600 ---
	SETB	BIT_9600
	
	;�������ڲ�����
	MOV	R0,#DATA_VARBAUDFULL
	MOV	@R0,#CONST_BAUD_FULL9600
	MOV	R0,#DATA_VARBAUDHALF
	MOV	@R0,#CONST_BAUD_HALF9600
	
	;����Ӳ���ڲ�����
	;MOV	TH1,#CONST_BAUD_HAND9600
	;MOV	TL1,#CONST_BAUD_HAND9600
	MOV	Reg_Sys_BRT,#CONST_BAUD_HAND9600
	
	JMP	Contact_CHANGEBAUD_OVER
Contact_CHANGEBAUD38400:
	CJNE	R7,#CONST_BAUD_38400,Contact_CHANGEBAUD115200
	;--- ���ò�����Ϊ38400 ---
	CLR	BIT_9600

	;�������ڲ�����
	MOV	R0,#DATA_VARBAUDFULL
	MOV	@R0,#CONST_BAUD_FULL38400
	MOV	R0,#DATA_VARBAUDHALF
	MOV	@R0,#CONST_BAUD_HALF38400

	;����Ӳ���ڲ�����
	;MOV	TH1,#CONST_BAUD_HAND38400
	;MOV	TL1,#CONST_BAUD_HAND38400
	MOV	Reg_Sys_BRT,#CONST_BAUD_HAND38400
	
	JMP	Contact_CHANGEBAUD_OVER
Contact_CHANGEBAUD115200:
	CJNE	R7,#CONST_BAUD_115200,Contact_CHANGEBAUD115200PC
	;--- ���ò�����Ϊ115200 ---
	CLR	BIT_9600

	;�������ڲ�����
	MOV	R0,#DATA_VARBAUDFULL
	MOV	@R0,#CONST_BAUD_FULL115200
	MOV	R0,#DATA_VARBAUDHALF
	MOV	@R0,#CONST_BAUD_HALF115200
	
	;����Ӳ���ڲ�����
	;MOV	TH1,#CONST_BAUD_HAND115200
	;MOV	TL1,#CONST_BAUD_HAND115200
	MOV	Reg_Sys_BRT,#CONST_BAUD_HAND115200
	
	JMP	Contact_CHANGEBAUD_OVER
Contact_CHANGEBAUD115200PC:
	CJNE	R7,#CONST_BAUD_115200PC,Contact_CHANGEBAUD230000
	
	;--- ���ò�����Ϊ115200 ---
	CLR	BIT_9600
	
	;����Ӳ���ڲ�����
	;MOV	TH1,#CONST_BAUD_HAND115200PC
	;MOV	TL1,#CONST_BAUD_HAND115200PC

	MOV	Reg_Sys_BRT,#CONST_BAUD_HAND115200PC

	JMP	Contact_CHANGEBAUD_OVER
	
Contact_CHANGEBAUD230000:
	CJNE	R7,#CONST_BAUD_230000,Contact_CHANGEBAUD38400PC
	
	;--- ���ò�����Ϊ115200 ---
	CLR	BIT_9600
	
	;�������ڲ�����
	MOV	R0,#DATA_VARBAUDFULL
	MOV	@R0,#CONST_BAUD_FULL230000
	MOV	R0,#DATA_VARBAUDHALF
	MOV	@R0,#CONST_BAUD_HALF230000
	
	;����Ӳ���ڲ�����
	;MOV	TH1,#CONST_BAUD_HAND230000
	;MOV	TL1,#CONST_BAUD_HAND230000		

	MOV	Reg_Sys_BRT,#CONST_BAUD_HAND230000
	JMP	Contact_CHANGEBAUD_OVER
Contact_CHANGEBAUD38400PC:
	CJNE	R7,#CONST_BAUD_38400PC,Contact_CHANGEBAUD9600PC
	;--- ���ò�����Ϊ115200 ---
	CLR	BIT_9600
	
	;����Ӳ���ڲ�����
	;MOV	TH1,#CONST_BAUD_HAND115200PC
	;MOV	TL1,#CONST_BAUD_HAND115200PC
	
	MOV	Reg_Sys_BRT,#CONST_BAUD_HAND38400PC
	JMP	Contact_CHANGEBAUD_OVER
Contact_CHANGEBAUD9600PC:
	CLR	BIT_9600
	MOV	Reg_Sys_BRT,#CONST_BAUD_HAND9600PC
Contact_CHANGEBAUD_OVER:

	RET
;---------------------------------------------------------
;����:PPS��������
;	FF + 10[T0] / 11[T1] +  13[BAUD����] + BCC
;	FF,10,13,FC
;�ⲿ����
;	R7		---	�����ʴ���
;	DATA_RXBUF	---	��������緳�
;	BIT_T0T1	---	��ǰ��ƬЭ��=1��ʾT1;	=0��ʾT0Э��;
;�ڲ�����
;	XDATA_TXBUF	---	��������緳�
;	R7		---	BAUD����ֵ
;	R3		---	��Ҫ�������ݵĳ���
;	R6		---	BCC
;�����Ӻ���
;-------------------------------------------------------------
_FUN_Contact_PPS:
	
	MOV	R6,#0
	
	;MOV	R0,#XDATA_TXBUF
	MOV	R0,#DATA_RXBUF+80
	MOV	A,#0FFH
	;	;MOVX	@R0,A
	;MOV 	DPH,#1 
	;MOV 	DPL,R0 
	;MOVX 	@DPTR,A
	MOV	@R0,A
	XRL	A,R6
	XCH	A,R6
	
	INC	R0
	
	;--- Э����� ---
	;JNB	BIT_T0T1,Contact_PPS_T0
Contact_PPS_T1:
	
	;MOV	A,#011H
	;	;MOVX	@R0,A
	;MOV 	DPH,#1 
	;MOV 	DPL,R0 
	;MOVX 	@DPTR,A
	;XRL	A,R6
	;XCH	A,R6
	;JMP	Contact_PPS_OVER
Contact_PPS_T0:
	MOV	A,#010H
	;	;MOVX	@R0,A
	;MOV 	DPH,#1 
	;MOV 	DPL,R0 
	;MOVX 	@DPTR,A
	MOV	@R0,A
	XRL	A,R6
	XCH	A,R6
Contact_PPS_OVER:

	INC	R0	
	MOV	A,R7
	;	;MOVX	@R0,A
	;MOV 	DPH,#1 
	;MOV 	DPL,R0 
	;MOVX 	@DPTR,A
	MOV	@R0,A
	XRL	A,R6
	XCH	A,R6

	INC	R0
	MOV	A,R6
	;	;MOVX	@R0,A
	;MOV 	DPH,#1 
	;MOV 	DPL,R0 
	;MOVX 	@DPTR,A
	MOV	@R0,A

	SETB	BIT_ESAMICC
	;SETB	BIT_BUFADDR	;BIT_BUFADDR	---	= 0�����͵����ڴ����ݣ�=1�����͵����������
	CLR	BIT_BUFADDR	;BIT_BUFADDR	---	= 0�����͵����ڴ����ݣ�=1�����͵����������
	SETB	BIT_VERIFY	;BIT_VERIFY	---	�����շ��Ƿ�Ҫ����λ,=0��Ҫ��=1Ҫ
	;MOV	R7,#XDATA_TXBUF	;R7		---	��Ҫ�������ݵ�buf
	MOV	R7,#DATA_RXBUF+80	;R7		---	��Ҫ�������ݵ�buf
	MOV	R5,#2
	MOV	R3,#4
	CALL	_FUN_SERIAL_TXSOFT

	RET
;///////////////////////////////////////////////////////////////////////////////////
_FUN_TESTContact_Channel0:	
	CLR	A
;TESTContact_Channel0_OVER:
	
	RET

TESTContact_Channel0_ERR:
;	MOV	R3,#0			;��ʱ��Ԫ
;	MOV	R7,#CONST_STATE_FALSE	

	RET
	


;///////////////////////////////////////////////////////////////////////////////////
	END
