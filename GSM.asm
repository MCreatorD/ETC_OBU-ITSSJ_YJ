NAME	GSM
	
;--------------------------------------------------------------------------
;_FUN_GSM_Insert		�忨�������
;_FUN_GSM_GetOffset		���� CellID �����Ӧ��ƫ����
;_FUN_GSM_RTCDeal		RTC �жϴ���
;_FUN_GSM_ETCInputDeal		GSM��ETC��ڴ�������
;_FUN_GSM_ETCOnputDeal		GSM��ETC���ڴ�������
	
;_FUN_GSM_PlayInputOutput	���ų����״̬
;_FUN_GSM_SerialINTRX		�����жϽ���
;_FUN_GSM_ReportMSG		�������Ź���
;_FUN_GSM_LowVotage		�͵�ѹ����
	
;_FUN_GSM_RTCCtrl		
;_Fun_GSM_RTCDis		����RTC
;_Fun_GSM_RTCEn			����RTC
;_FUN_GSM_RTCON			��RTC
;_FUN_GSM_RTCOFF		��RTC
;--------------------------------------------------------------------------
$INCLUDE(GSM.INC)
$INCLUDE(COMMON.INC)
	
	RSEG	?pr?GSM?Mater
	USING	0
	
;----------------------------------------------------------
;������
;	�û��忨��ʱGSM��صĴ���
;����	
;	
;����
;	��鵱ǰ�����״̬
;	����(mtc etc 1,3)
;		1.�� GSM 0020
;		2.�忨Ƭ 0020
;		3.��ֹ RTC���� GSM ����
;	���(mtc etc 2,4)
;		���OBU 0020 �����ʱ�估��ڵص���0019�Ƿ���ͬ
;			��ͬ
;				���OBU CellID�����Ƿ���ͬ
;					��ͬ
;						��������
;					��ͬ
;						��鿨Ƭ�����һ�� CellID �� obu ��Ӧλ�õ�CelliD�Ƿ���ͬ
;							��ͬ
;								д������cellID
;							����ͬ
;								���½�OBU0020�ļ��е�ID���뵽��Ƭ��ȥ
;			����ͬ
;				1.����0019�� ���ʱ�估��ڵص㵽OBU  0020
;				2.����0019�� ���ʱ�估��ڵص㵽��Ƭ 0020
;				3.��������
;			
;ʹ���� DATA_RXBUF XDATA_TXBUF
;ǰ��:	
;	Ԥ������Ϣ�ǶԵ�


;����
;�����û���ǰ5������+unixtime
;����ESAM��ǰ5������+unixtime
;�û��� = ���� ����
;�û��� = ��� 
;	�û���ʱ��С�ڵ���ESAM
;		����ESAM���ݵ��û�����
;			����������
;				����������52��byte 5~56
;				����������52��byte 57~108
;			����ǰ5 0~4
;			����unixtime 4 109~113
;	�û���ʱ�����ESAM
;		ESAM�б��û�ʱ���µļ�¼ǰ��
;			���ǰ�Ƶĵ�һ����¼�ţ�����Ҫǰ�Ƶļ�¼��
;			ǰ������
;			ǰ��unixtime
;			�����ܼ�¼��
;		����ESAM���ݵ��û�����
;----------------------------------------------------------
_FUN_GSM_Insert:
	
	;--- RET 
	JB	BIT_INSERTCARD,GSM_Insert_ReadESAMbaseinfo
	JMP	GSM_Insert_Over
	
	;���� ESAM ǰ 5 ������ unixtime
	;	���� ESAM ǰ5������
	;	����ESAM unixtime	
GSM_Insert_ReadESAMbaseinfo:
	
	;xdata_hold [0~4] ESAMǰ5 0~4
	;xdata_hold [5~8] ESAM unixtime  109~113
	;xdata_hold [9~13] User ǰ5 0~4
	;xdata_hold [14~17] User unixtime  109~113
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R3,#0DFH
	MOV	R2,#001H
	CALL	_FUN_CARDAPP_SelectFile
	
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R3,#CONST_ESAMCellfile_H
	MOV	R2,#CONST_ESAMCellfile_L
	CALL	_FUN_CARDAPP_SelectFile
	
	;;xdata_hold [0~4] ESAM ǰ5 0~4
	CLR	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF						;R7		---	����緳�ָ��(�ڴ�)\
	MOV	R5,#XDATA_HOLD
	MOV	R4,#00	
	MOV	R3,#00	
	MOV	R2,#05							;04;03
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7
	;;---jnz	GSM_Insert_Over
	JZ	GSM_Insert_ReadESAMbaseinfo02
	JMP	GSM_Insert_Over
GSM_Insert_ReadESAMbaseinfo02:	
	
	;xdata_hold [5~8] ESAM unixtime  109~113
	CLR	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF	
	MOV	R5,#XDATA_HOLD+5
	MOV	R4,#00						
	MOV	R3,#109						
	MOV	R2,#4;04;03
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7	
	;---jnz	GSM_Insert_Over
	JZ	GSM_Insert_ReadUserbaseinfo
	JMP	GSM_Insert_Over
	
	;�����û���ǰ5������ + unixtime
	;	�����û���ǰ5������
	;	�����û���unixtime
	;xdata_hold [0~4] ESAMǰ5 0~4
	;xdata_hold [5~8] ESAM unixtime  109~113
	;xdata_hold [9~13] User ǰ5 0~4
	;xdata_hold [14~17] User unixtime  109~113
GSM_Insert_ReadUserbaseinfo:
	
	SETB	BIT_GETRESULT
	SETB	BIT_ESAMICC
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R3,#010H
	MOV	R2,#001H
	CALL	_FUN_CARDAPP_SelectFile
	
	SETB	BIT_GETRESULT
	SETB	BIT_ESAMICC
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R3,#CONST_Cellfile_H
	MOV	R2,#CONST_Cellfile_L
	CALL	_FUN_CARDAPP_SelectFile
	
	;xdata_hold [9~13] User ǰ5 0~4
	SETB	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_HOLD+9
	MOV	R4,#00
	MOV	R3,#00
	MOV	R2,#05;04;03
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7
	;---jnz	GSM_Insert_Over
	JZ	GSM_Insert_ReadESAMbaseinfo3
	JMP	GSM_Insert_Over
GSM_Insert_ReadESAMbaseinfo3:
	
	;xdata_hold [14~17] User unixtime  109~113	
	SETB	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_HOLD+14
	MOV	R4,#00
	MOV	R3,#109
	MOV	R2,#4;04;03
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7
	;---jnz	GSM_Insert_Over
	JZ	GSM_Insert_ReadESAMbaseinfo4
	JMP	GSM_Insert_Over
GSM_Insert_ReadESAMbaseinfo4:
	;xdata_hold [0~4] ESAMǰ5 0~4
	;xdata_hold [5~8] ESAM unixtime  109~113
	;xdata_hold [9~13] User ǰ5 0~4
	;xdata_hold [14~17] User unixtime  109~113		
	
	MOV	R0,#xdata_hold+11
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	
	;---CALL	_FUN_TEST_DISPLAY
	XRL	A,#CONST_Flag_INPUT
	;---JZ	GSM_Insert_Input
	JNZ	GSM_Insert_Output
	JMP	GSM_Insert_Input
	
;�û��� = ���� ����
GSM_Insert_Output:
	
	;=== �� unixtime ===
	;xdata_hold [0~4] ESAMǰ5 0~4
	;xdata_hold [5~8] ESAM unixtime  109~113
	;xdata_hold [9~13] User ǰ5 0~4
	;xdata_hold [14~17] User unixtime  109~113	
	;xdata_hold [29] TMP OFFSET 01
	;xdata_hold [30] TMP OFFSET 02
	
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	
	MOV	R0,#DATA_RXBUF + 5
	MOV	R3,#52
	CLR	A	
Insert_Output_loopclr:
	MOV	@R0,A
	INC	R0
	DJNZ	R3,Insert_Output_loopclr	
	
	MOV	R0,#XDATA_HOLD+30
	MOV	A,#71H
	;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	CLR	A
	DEC	R0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	MOV	R6,#4
Insert_Output_loop:
	;assign offset H/L into r4 / r3
	MOV	R0,#XDATA_HOLD+29
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R4,A;#0	
	
	MOV	R0,#XDATA_HOLD+30
		;MOVX	A,@R0
	MOV	DPH,#01
	MOV	DPL,R0
	MOVX	A,@DPTR	
	MOV	R3,A;#1
	
	MOV	R2,#52;#1
	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	
	PUSH	AR6
	CALL	_FUN_CARDAPP_UpdateBinary
	POP	AR6
	
	MOV	A,R7	
	JNZ	GSM_Insert_Over
	
	MOV	R0,#XDATA_HOLD+30
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#52
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	DEC	R0	
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A	
	DJNZ	R6,Insert_Output_loop


	;=== ��ESAMǰ 5 ���� ===
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	
	MOV	R0,#DATA_RXBUF + 5
	mov	a,#0
	mov	@r0,a	
	inc	r0
	mov	@r0,a	
	inc	r0
	mov	@r0,a	
	inc	r0
	mov	@r0,a	
	inc	r0
	mov	@r0,a	


	;assign offset H/L into r4 / r3
	MOV	R4,#0	
	MOV	R3,#0
	MOV	R2,#5
	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	
	CALL	_FUN_CARDAPP_UpdateBinary
	MOV	A,R7
	jnz	GSM_Insert_Over


	;=== ���û������� ===
	SETB	BIT_GETRESULT
	setb	BIT_ESAMICC
	
	MOV	R0,#DATA_RXBUF + 5
	mov	a,#0
	mov	@r0,a
	
	;assign offset H/L into r4 / r3
	MOV	R4,#0	
	MOV	R3,#1
	MOV	R2,#1		
	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	
	CALL	_FUN_CARDAPP_UpdateBinary

	JMP	GSM_Insert_Over

;�û��� = ��� 
;	�û���ʱ��С�ڵ���ESAM
;		����ESAM���ݵ��û�����
;			����������
;				����������52��byte 5~56
;				����������52��byte 57~108
;			����ǰ5 0~4
;			����unixtime 4 109~113
;	�û���ʱ�����ESAM
;		ESAM�б��û�ʱ���µļ�¼ǰ��
;			���ǰ�Ƶĵ�һ����¼�ţ�����Ҫǰ�Ƶļ�¼��
;			ǰ������
;			ǰ��unixtime
;			�����ܼ�¼��
;		����ESAM���ݵ��û�����
	
GSM_Insert_Input:
;�û��� = ��� 
	
	;�Ƚ� unixtime
;	�û���ʱ��С�ڵ���ESAM
;		����ESAM���ݵ��û�����
;	�û���ʱ�����ESAM
;		ESAM�б��û�ʱ���µļ�¼ǰ��
;		����ESAM���ݵ��û�����
	
	;xdata_hold [0~4] ESAMǰ5 0~4
	;xdata_hold [5~8] ESAM unixtime  109~113
	;xdata_hold [9~13] User ǰ5 0~4
	;xdata_hold [14~17] User unixtime  109~113
GSM_Insert_compareunixtime:
	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;����ESAM���ݵ��û�����
	;1��д��ESAM ǰ0~4 /���м�¼ 5~108 / unixtime 109~112
	;2����������û�����Ϣ
	;user < esam
	;>= ����
	;3����� 0~112 �Ƿ���ͬ	
	;CALL	_FUN_GSM_ESAMToUserCard;	r5<=r7 ���� C=1
	;CALL	_FUN_GSM_ESAMQY
	;mov	a,#37
	;call	_fun_test_display
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	r5<=r7 ���� C=1
;	R5>r7 ����C = 0

;	r5<r7 ���� C=1
;	R5>=r7 ����C = 0
	MOV	r5,#xdata_hold+5
	MOV	r7,#xdata_hold+14
	CALL	_fun_GSM_compareunixtime2
	
	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;mov	a,#37
	;clr	a
	;mov	acc.0,c	
	;call	_fun_test_display
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	
	JNC	GSM_Insert_XiaoDunYu
;	�û���ʱ�����ESAM
;		ESAM�б��û�ʱ���µļ�¼ǰ��
;			���ǰ�Ƶĵ�һ����¼�ţ�����Ҫǰ�Ƶļ�¼��
;			ǰ������
;			ǰ��unixtime
;			�����ܼ�¼��
;		����ESAM���ݵ��û�����	
GSM_Insert_DaYu:
	CALL	_FUN_GSM_ESAMQY
	;CALL	_FUN_GSM_ESAMToUserCard	
;	�û���ʱ��С�ڵ���ESAM
;		����ESAM���ݵ��û�����
;			����������
;				����������52��byte 5~56
;				����������52��byte 57~108
;			����ǰ5 0~4
;			����unixtime 4 109 ~ 113
GSM_Insert_XiaoDunYu:
	CALL	_FUN_GSM_ESAMToUserCard
GSM_Insert_Over:
	RET
;////////////////////////////////////////////////////////////////
;����
;	r5	xdata 4 byte
;	r7	xdata 4 byte
;	r5<=r7 ���� C=1
;	R5>r7 ����C = 0
_fun_GSM_compareunixtime:
	
	MOV	AR0,AR5
	MOV	AR1,AR7
	
	;��ͬ������C=1
	MOV	R3,#4
GSM_compareunixtime_LOOP1:
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	B,A
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	XRL	A,B
	JNZ	GSM_compareunixtime_S
	INC	R0
	INC	R1	
	DJNZ	R3,GSM_compareunixtime_LOOP1	
		
	SETB	C
	JMP	GSM_compareunixtime_OVER
	
	;����ͬ��R5<r7 ���� C=1 �����򣬷���C=0
GSM_compareunixtime_S:
	MOV	AR0,AR5
	MOV	AR1,AR7
	INC	R1
	INC	R0
	INC	R1
	INC	R0
	INC	R1
	INC	R0

	CLR	C
	MOV	R3,#4
GSM_compareunixtime_LOOP2:
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	MOV	B,A
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR	
	SUBB	A,B

	DEC	R0
	DEC	R1
	DJNZ	R3,GSM_compareunixtime_LOOP2
	
	JC	GSM_compareunixtime_OVER
	
GSM_compareunixtime_OVER:
	
	RET
;--------------------------------------------------------------------------
;����
;	r5	xdata 4 byte
;	r7	xdata 4 byte
;	r5<r7 ���� C=1
;	R5>=r7 ����C = 0
;--------------------------------------------------------------------------
_fun_GSM_compareunixtime2:
		
	;R5<r7 ���� C=1 �����򣬷���C=0
GSM_compareunixtime2_S:
	MOV	AR0,AR5
	MOV	AR1,AR7
	INC	R1
	INC	R0
	INC	R1
	INC	R0
	INC	R1
	INC	R0

	CLR	C
	MOV	R3,#4
GSM_compareunixtime2_LOOP2:
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	MOV	B,A
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR	
	SUBB	A,B
	
	DEC	R0
	DEC	R1
	DJNZ	R3,GSM_compareunixtime2_LOOP2
		
	;JC	GSM_compareunixtime2_OVER	
GSM_compareunixtime2_OVER:

	RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;����
;	���ǰ�Ƶĵ�һ����¼�ţ�����Ҫǰ�Ƶļ�¼��
;ǰ��
;	1.�Ѿ߱�����ESAM usercard�������������Χ����Ƭ�Ѹ�λ�ɹ�
;	2.��ѡ��ESAM df01 ef07 �� usercard 1001 0009 �ļ�
;����
	;xdata_hold [0~4] ESAMǰ5 0~4
	;xdata_hold [5~8] ESAM unixtime  109~113
	;xdata_hold [9~13] User ǰ5 0~4
	;xdata_hold [14~17] User unixtime  109~113	
	;xdata_hold [18] ���ǰ�Ƶĵ�һ����¼��
	;xdata_hold [19] ��Ҫǰ�Ƶļ�¼��
	
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [21] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [22] ��Ҫ�ƶ����ֽ���
	
	;xdata_hold [23] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [24] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [25] ��Ҫ�ƶ���UNIXTIME���ֽ���	
	;xdata_hold [26] unixtime ƫ���� 01 lingshi
	;xdata_hold [27] unixtime ƫ���� 02 
	;xdata_hold [28] unixtime�ܳ���
;����ֵ��
;	R7=��һ����¼��,R5=��Ҫǰ�Ƶļ�¼��
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_FUN_GSM_GETRecordCode:
	
	;unixtime ƫ���� 01 / 02
	MOV	R0,#xdata_hold + 26
	CLR	A
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	INC	R0
	MOV	A,#113
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	;unixtime�ܳ���
	MOV	R0,#xdata_hold + 28
	MOV	R1,#xdata_hold + 1
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	;---JZ	GSM_GETRecordCode_ER
	JNZ	GSM_GETRecordCode_RVLOOPPre
	JMP	GSM_GETRecordCode_ER
GSM_GETRecordCode_RVLOOPPre:
	MOV	B,A	
	MOV	A,#4
	MUL	AB
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	MOV	R6,#1
GSM_GETRecordCode_RVLOOP:
	
	;=== ����ESAM Unixtime===
	CLR	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF	
	MOV	R5,#XDATA_TXBUF
	
	MOV	R0,#xdata_hold + 26
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R4,A
	
	MOV	R0,#xdata_hold + 27
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R3,A
	
	MOV	R0,#xdata_hold + 28
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CJNE	A,#104,$+3
	JNC	GSM_GETRecordCode_ReadNum
	;��Ҫ����������
GSM_GETRecordCode_ReadNumSY:;��ʣ�ಿ��
	MOV	R2,A
	CLR	A
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	JMP	GSM_GETRecordCode_ReadNumOV
GSM_GETRecordCode_ReadNum:
	MOV	R2,#104	
	CLR	C
	subb	a,#104
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	MOV	R0,#xdata_hold + 27
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR	
	clr	c
	addc	a,#104
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	dec	r0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	addc	a,#0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
GSM_GETRecordCode_ReadNumOV:
	PUSH	AR2
	PUSH	AR6
	CALL	_FUN_CARDAPP_ReadBinary02
	POP	AR6
	POP	AR2
	MOV	A,R7
	JNZ	GSM_GETRecordCode_ER	
;GSM_GETRecordCode_TWORV:
	

	MOV	r5,#XDATA_TXBUF
	
	MOV	A,#4
	MOV	B,A
	MOV	a,r2
	DIV	ab
	MOV	R3,A
	
GSM_GETRecordCode_Loop:
	
;	r5	xdata 4 byte
;	r7	xdata 4 byte
;	r5<r7 ���� C=1
;	R5>=r7 ����C = 0
	;xdata_hold [14~17] User unixtime  109~113	
	MOV	r7,#xdata_hold+14	
	push	ar6
	PUSH	AR5
	push	ar3
	CALL	_fun_GSM_compareunixtime2
	pop	ar3
	POP	AR5
	pop	ar6
	
	JNC	GSM_GETRecordCode_over
	INC	ar6
	
	;unixtime ����һ����¼
	INC	R5
	INC	R5
	INC	R5
	INC	R5	
	DJNZ	R3,GSM_GETRecordCode_loop
	
	;�鿴�Ƿ񻹴�û��û�����unixtime
	MOV	R0,#xdata_hold + 28
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;---JNZ	GSM_GETRecordCode_RVLOOP
	JZ	GSM_GETRecordCode_RVLOOPZZ
	JMP	GSM_GETRecordCode_RVLOOP
GSM_GETRecordCode_RVLOOPZZ:

	;R7=��һ����¼��
	MOV	A,#0FFH
	MOV	AR7,A
	
	;R5=��Ҫǰ�Ƶļ�¼��
	MOV	A,#0
	MOV	R5,A
	
	RET

	;JMP	GSM_GETRecordCode_ER
	;R7=��һ����¼�ţ�û�з���ʱ��ʹ��һ����¼��������һ��
	;SETB	C
	;DEC	AR6
	;MOV	AR7,AR6	
	;R5=��Ҫǰ�Ƶļ�¼��
	;mov	r5,#0
GSM_GETRecordCode_over:
	;R7=��һ����¼��
	MOV	AR7,AR6
	
	MOV	A,R7
	XRL	A,#1
	JZ	GSM_GETRecordCode_ER
	
	;R5=��Ҫǰ�Ƶļ�¼��
	;CLR	C
	;MOV	A,#1
	;MOV	B,A
	;MOV	A,R7
	;SUBB	A,B
	;MOV	R5,A
	
	MOV	R0,#XDATA_HOLD+1
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	clr	c
	SUBB	A,R7
	INC	A
	MOV	R5,A
	
	RET
	
GSM_GETRecordCode_ER:
	;R7=��һ����¼��
	MOV	A,#0
	MOV	AR7,A
	
	;R5=��Ҫǰ�Ƶļ�¼��
	MOV	R5,A
	
	RET	


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;����
;		ESAM�б��û�ʱ���µļ�¼ǰ��
;ǰ��
;	1.�Ѿ߱�����ESAM usercard�������������Χ����Ƭ�Ѹ�λ�ɹ�
;	2.��ѡ��ESAM df01 ef07 �� usercard 1001 0009 �ļ�
;���̣�
;			���ǰ�Ƶĵ�һ����¼�ţ�����Ҫǰ�Ƶļ�¼��
;				R7=��һ����¼��,R5=��Ҫǰ�Ƶļ�¼��
;			ǰ������
;				��Ҫ�ƶ������ݳ���>52���ֶ����ƣ���Ȼһ����
;					��Ҫ�ƶ������ݣ�����xdata_txbuf��
;					��Ҫ�ƶ������ݣ�д��ESAM��
;			ǰ��unixtime
;					��Ҫ�ƶ������ݣ�����xdata_txbuf��
;					��Ҫ�ƶ������ݣ�д��ESAM��
;			�����ܼ�¼��
;					
;����
	;xdata_hold [0~4] ESAMǰ5 0~4
	;xdata_hold [5~8] ESAM unixtime  109~113
	;xdata_hold [9~13] User ǰ5 0~4
	;xdata_hold [14~17] User unixtime  109~113	
	;xdata_hold [18] ���ǰ�Ƶĵ�һ����¼��
	;xdata_hold [19] ��Ҫǰ�Ƶļ�¼��
	
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [21] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [22] ��Ҫ�ƶ����ֽ���
	
	;xdata_hold [23] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [24] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [25] ��Ҫ�ƶ���UNIXTIME���ֽ���	
	;xdata_hold [26] unixtime ƫ���� 01 lingshi
	;xdata_hold [27] unixtime ƫ���� 02 lingshi
	;xdata_hold [28] unixtime�ܳ���	    lingshi
	
	;xdata_hold [29] TMP OFFSET 01
	;xdata_hold [30] TMP OFFSET 02
	
	
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_FUN_GSM_ESAMQY:
	
	CALL	_FUN_GSM_GETRecordCode
	MOV	A,R5
	
	;mov	a,r7
	;call	_fun_test_display
	
	;---JZ	GSM_ESAMQY_OVER
	jnz	GSM_ESAMQY_KS
	MOV	A,R7
	JZ	GSM_ESAMQY_NORecord
	
	;=== ������ ===
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	
	MOV	R0,#DATA_RXBUF + 5
	mov	a,#0
	mov	@r0,a
	
	;assign offset H/L into r4 / r3
	MOV	R4,#0	
	MOV	R3,#1
	MOV	R2,#1		
	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	
	CALL	_FUN_CARDAPP_UpdateBinary
	
	
GSM_ESAMQY_NORecord:
	jmp	GSM_ESAMQY_OVER
GSM_ESAMQY_KS:
	;R7=��һ����¼��,R5=��Ҫǰ�Ƶļ�¼��
	;xdata_hold [18] ���ǰ�Ƶĵ�һ����¼��
	;xdata_hold [19] ��Ҫǰ�Ƶļ�¼��
	
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [21] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [22] ��Ҫ�ƶ����ֽ���
	
	;xdata_hold [23] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [24] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [25] ��Ҫ�ƶ���UNIXTIME���ֽ���
	;R7=��һ����¼��,R5=��Ҫǰ�Ƶļ�¼��
	MOV	R0,#xdata_hold + 18
	MOV	A,R7
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	MOV	R0,#xdata_hold + 19
	MOV	A,R5
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	;JNZ	GSM_ESAMQY_COMPY
	;JMP	GSM_ESAMQY_OVER
GSM_ESAMQY_COMPY:
	
	;xdata_hold [0~4] ESAMǰ5 0~4
	;xdata_hold [5~8] ESAM unixtime  109~113
	;xdata_hold [9~13] User ǰ5 0~4
	;xdata_hold [14~17] User unixtime  109~113	
	;xdata_hold [18] ���ǰ�Ƶĵ�һ����¼��
	;xdata_hold [19] ��Ҫǰ�Ƶļ�¼��
	
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [21] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [22] ��Ҫ�ƶ����ֽ���

	;xdata_hold [23] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [24] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [25] ��Ҫ�ƶ���UNIXTIME���ֽ���	

	MOV	R0,#xdata_hold + 18
	MOV	R1,#xdata_hold + 21
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	DEC	A
	
	CLR	C
	MOV	B,A
	MOV	A,#2
	MUL	AB
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	DEC	R1
	MOV	A,B
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	CLR	C
	INC	R1
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	ADDC	A,#5
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	DEC	R1
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	;xdata_hold [22] ��Ҫ�ƶ����ֽ���
	MOV	R1,#xdata_hold + 22
	MOV	R0,#xdata_hold + 19
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	MOV	B,A
	MOV	A,#2
	MUL	AB
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	
	;xdata_hold [18] ���ǰ�Ƶĵ�һ����¼��
	;xdata_hold [23] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [24] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 02
	MOV	R0,#xdata_hold + 18
	MOV	R1,#xdata_hold + 24
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	DEC	A
	
	CLR	C
	MOV	B,A
	MOV	A,#4
	MUL	AB
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	DEC	R1
	MOV	A,B
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	CLR	C
	INC	R1
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	ADDC	A,#113
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	DEC	R1
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	;xdata_hold [25] ��Ҫ�ƶ���UNIXTIME���ֽ���
	MOV	R1,#xdata_hold + 25
	MOV	R0,#xdata_hold + 19
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	MOV	B,A
	MOV	A,#4
	MUL	AB
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [21] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [22] ��Ҫ�ƶ����ֽ���

	;xdata_hold [23] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [24] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [25] ��Ҫ�ƶ���UNIXTIME���ֽ���	

	;xdata_hold [29] TMP OFFSET 01 ǰ��Ŀ���ַ offset01
	;xdata_hold [30] TMP OFFSET 02 ǰ��Ŀ���ַ offset02
	
	
	
	
	MOV	R0,#xdata_hold+30
	MOV	A,#5
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	DEC	R0
	CLR	A
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
GSM_ESAMQY_ReadESAMdataS:
	MOV	R0,#xdata_hold+22
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	
	;CALL	_FUN_TEST_DISPLAY
	;CJNE	A,#53,$+3
	CJNE	A,#52,$+3
	JNC	GSM_ESAMQY_ReadESAMdataTWO
GSM_ESAMQY_ReadESAMdataOne:

	;R7=��һ����¼��,R5=��Ҫǰ�Ƶļ�¼��
	;xdata_hold [18] ���ǰ�Ƶĵ�һ����¼��
	;xdata_hold [19] ��Ҫǰ�Ƶļ�¼��
	
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [21] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [22] ��Ҫ�ƶ����ֽ���
	
	;xdata_hold [23] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [24] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [25] ��Ҫ�ƶ���UNIXTIME���ֽ���

	;����ESAM xdata_hold [21] ��Ҫ�ƶ����ֽ�����byte XX~XX
	CLR	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF	
	MOV	R5,#XDATA_TXBUF
	MOV	R0,#xdata_hold+20
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R4,A	
	
	MOV	R0,#xdata_hold+21
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R3,A		
	
	MOV	R0,#xdata_hold+22
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R2,A	
	
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7	
	;---JNZ	GSM_ESAMQY_OVER
	jz	GSM_ESAMQY_ReadESAMdataOneup
	JMP	GSM_ESAMQY_OVER
	
GSM_ESAMQY_ReadESAMdataOneup:
	;дESAM xdata_hold [21] ��Ҫ�ƶ����ֽ�����byte XX~XX
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	
	MOV	R5,#DATA_RXBUF + 5
	MOV	R7,#XDATA_TXBUF
	;MOV	R3,#52
	MOV	R0,#xdata_hold+22
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R3,A		
	CALL	_FUN_LIB_XDATATODATA
	
	MOV	R0,#xdata_hold+29
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R4,A	
	MOV	R0,#xdata_hold+30
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R3,A		
	MOV	R0,#xdata_hold+22
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R2,A
	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	
	CALL	_FUN_CARDAPP_UpdateBinary
	
	MOV	A,R7	
	;CALL	_fun_test_display
	;---JNZ	GSM_ESAMQY_OVER	
	;---JMP	GSM_ESAMQY_ReadESAMdataOVER
	;---JZ	GSM_ESAMQY_ReadESAMdataOVER
	JNZ	GSM_ESAMQY_ReadESAMdataOVERZZ
	JMP	GSM_ESAMQY_ReadESAMdataOVER
GSM_ESAMQY_ReadESAMdataOVERZZ:
	JMP	GSM_ESAMQY_OVER
GSM_ESAMQY_ReadESAMdataTWO:
	;xdata_hold [18] ���ǰ�Ƶĵ�һ����¼��
	;xdata_hold [19] ��Ҫǰ�Ƶļ�¼��
	
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [21] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [22] ��Ҫ�ƶ����ֽ���
	
	;xdata_hold [23] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [24] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [25] ��Ҫ�ƶ���UNIXTIME���ֽ���
	;����ESAM xdata_hold [21] ��Ҫ�ƶ����ֽ�����byte XX~XX
	CLR	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF	
	MOV	R5,#XDATA_TXBUF
	
	MOV	R0,#xdata_hold+20
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R4,A	
	;CALL	_FUN_TEST_DISPLAY
	MOV	R0,#xdata_hold+21
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R3,A	
	;CALL	_FUN_TEST_DISPLAY
	MOV	R2,#52	
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7	
	
	;---JNZ	GSM_ESAMQY_OVER
	JZ	GSM_ESAMQY_ReadESAMdataTWOup
	JMP	GSM_ESAMQY_OVER
GSM_ESAMQY_ReadESAMdataTWOup:
	;дESAM xdata_hold [21] ��Ҫ�ƶ����ֽ�����byte XX~XX
	;xdata_hold [18] ���ǰ�Ƶĵ�һ����¼��
	;xdata_hold [19] ��Ҫǰ�Ƶļ�¼��
	
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [21] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [22] ��Ҫ�ƶ����ֽ���
	
	;xdata_hold [23] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [24] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [25] ��Ҫ�ƶ���UNIXTIME���ֽ���

	;xdata_hold [29] TMP OFFSET 01 ǰ��Ŀ���ַ offset01
	;xdata_hold [30] TMP OFFSET 02 ǰ��Ŀ���ַ offset02

	;MOV	R0,#xdata_hold+30	
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	
	MOV	R5,#DATA_RXBUF + 5
	MOV	R7,#XDATA_TXBUF
	MOV	R3,#52	
	CALL	_FUN_LIB_XDATATODATA
	
	;assign offset H/L into r4 / r3
	MOV	R0,#xdata_hold+29
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R4,A	
	
	MOV	R0,#xdata_hold+30
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R3,A		

	MOV	R2,#52					
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	CALL	_FUN_CARDAPP_UpdateBinary
	
	MOV	A,R7
	;CALL	_fun_test_display
	;---JNZ	GSM_ESAMQY_OVER
	JZ	GSM_ESAMQY_ReadESAMdataTWOJS
	JMP	GSM_ESAMQY_OVER
GSM_ESAMQY_ReadESAMdataTWOJS:
	
	;R7=��һ����¼��,R5=��Ҫǰ�Ƶļ�¼��
	;xdata_hold [18] ���ǰ�Ƶĵ�һ����¼��
	;xdata_hold [19] ��Ҫǰ�Ƶļ�¼��
	
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [21] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [22] ��Ҫ�ƶ����ֽ���
	
	;xdata_hold [23] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [24] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [25] ��Ҫ�ƶ���UNIXTIME���ֽ���
	
	;xdata_hold [29] TMP OFFSET 01 ǰ��Ŀ���ַ offset01
	;xdata_hold [30] TMP OFFSET 02 ǰ��Ŀ���ַ offset02		
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ
	MOV	R0,#xdata_hold+21
	
	;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#52
	
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	DEC	R0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	;xdata_hold [21] ��Ҫ�ƶ����ֽ���
	MOV	R0,#xdata_hold+22
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	SUBB	A,#52
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A	
	JZ	GSM_ESAMQY_ReadESAMdataOVER
	
	
	MOV	R0,#xdata_hold+30
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#52
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	DEC	R0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	JMP	GSM_ESAMQY_ReadESAMdataS
	
GSM_ESAMQY_ReadESAMdataOVER:


	MOV	R0,#xdata_hold+30
	MOV	A,#113
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	DEC	R0
	CLR	A
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A

;///////////////////////////////////////////////////////////////////
;GSM_ESAMQY_QYESAMUnixS:
GSM_ESAMQY_QYESAMUnixS2:
	MOV	R0,#xdata_hold+25
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CJNE	A,#52,$+3
	JNC	GSM_ESAMQY_QYESAMUnixTWO
GSM_ESAMQY_QYESAMUnixOne:
	
	;R7=��һ����¼��,R5=��Ҫǰ�Ƶļ�¼��
	;xdata_hold [18] ���ǰ�Ƶĵ�һ����¼��
	;xdata_hold [19] ��Ҫǰ�Ƶļ�¼��
	
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [21] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [22] ��Ҫ�ƶ����ֽ���
	
	;xdata_hold [23] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [24] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [25] ��Ҫ�ƶ���UNIXTIME���ֽ���
	
	;xdata_hold [29] TMP OFFSET 01 ǰ��Ŀ���ַ offset01
	;xdata_hold [30] TMP OFFSET 02 ǰ��Ŀ���ַ offset02	

	;����ESAM xdata_hold [21] ��Ҫ�ƶ����ֽ�����byte XX~XX
	CLR	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF	
	MOV	R5,#XDATA_TXBUF
	MOV	R0,#xdata_hold+23
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R4,A	
	
	MOV	R0,#xdata_hold+24
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R3,A		
	
	MOV	R0,#xdata_hold+25
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R2,A	
	
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7
	;---JNZ	GSM_ESAMQY_OVER
	JZ	GSM_ESAMQY_QYESAMUnixOneUP
	JMP	GSM_ESAMQY_OVER
GSM_ESAMQY_QYESAMUnixOneUP:
	
	;дESAM xdata_hold [21] ��Ҫ�ƶ����ֽ�����byte XX~XX
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	
	MOV	R5,#DATA_RXBUF + 5
	MOV	R7,#XDATA_TXBUF
	;MOV	R3,#52
	MOV	R0,#xdata_hold+25
		;MOVX	A,@R0
	MOV	DPH,#1				
	MOV	DPL,R0				
	MOVX	A,@DPTR				
	MOV	R3,A				
	CALL	_FUN_LIB_XDATATODATA		
	
	MOV	R0,#xdata_hold+29
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R4,A	
	
	MOV	R0,#xdata_hold+30
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R3,A		
	
	MOV	R0,#xdata_hold+25
	;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R2,A
	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF	
	CALL	_FUN_CARDAPP_UpdateBinary
	MOV	A,R7	
	;CALL	_fun_test_display
	;---JNZ	GSM_ESAMQY_OVER
	JZ	GSM_ESAMQY_OVERZZ02
	JMP	GSM_ESAMQY_OVER
GSM_ESAMQY_OVERZZ02:
	JMP	GSM_ESAMQY_QYESAMUnixOVER

GSM_ESAMQY_QYESAMUnixTWO:
	
	;����ESAM xdata_hold [21] ��Ҫ�ƶ����ֽ�����byte XX~XX
	CLR	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF	
	MOV	R5,#XDATA_TXBUF
	MOV	R0,#xdata_hold+23
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R4,A	
	
	MOV	R0,#xdata_hold+24
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R3,A	
	
	MOV	R2,#52	
	
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7	
	;---JNZ	GSM_ESAMQY_OVER
	JZ	GSM_ESAMQY_OVERZZ03
	JMP	GSM_ESAMQY_OVER
GSM_ESAMQY_OVERZZ03:

	;дESAM xdata_hold [21] ��Ҫ�ƶ����ֽ�����byte XX~XX
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	
	MOV	R5,#DATA_RXBUF + 5
	MOV	R7,#XDATA_TXBUF
	MOV	R3,#52	
	CALL	_FUN_LIB_XDATATODATA
	
	;assign offset H/L into r4 / r3
	MOV	R0,#xdata_hold+29
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R4,A	
	
	MOV	R0,#xdata_hold+30
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R3,A		

	MOV	R2,#52		
	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	
	CALL	_FUN_CARDAPP_UpdateBinary
	
	MOV	A,R7	
	;CALL	_fun_test_display
	JNZ	GSM_ESAMQY_OVER
	
	
	;R7=��һ����¼��,R5=��Ҫǰ�Ƶļ�¼��
	;xdata_hold [18] ���ǰ�Ƶĵ�һ����¼��
	;xdata_hold [19] ��Ҫǰ�Ƶļ�¼��
	
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [21] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [22] ��Ҫ�ƶ����ֽ���
	
	;xdata_hold [23] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 01
	;xdata_hold [24] ���ǰ�Ƶĵ�һ����¼�ţ���ӦUNIXTIME������ƫ�Ƶ�ַ OFFSET 02
	;xdata_hold [25] ��Ҫ�ƶ���UNIXTIME���ֽ���
	
	;xdata_hold [29] TMP OFFSET 01 ǰ��Ŀ���ַ offset01
	;xdata_hold [30] TMP OFFSET 02 ǰ��Ŀ���ַ offset02		
	;xdata_hold [20] ���ǰ�Ƶĵ�һ����¼�ţ���Ӧ������ƫ�Ƶ�ַ
	MOV	R0,#xdata_hold+24
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#52
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	DEC	R0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	;xdata_hold [21] ��Ҫ�ƶ����ֽ���
	MOV	R0,#xdata_hold+25
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	SUBB	A,#52
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A	
	JZ	GSM_ESAMQY_QYESAMUnixOVER
	
	MOV	R0,#xdata_hold+30
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#52
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	DEC	R0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A	
	
	JMP	GSM_ESAMQY_QYESAMUnixS2
	
GSM_ESAMQY_QYESAMUnixOVER:

	;===�����ܵļ�¼��===
	;xdata_hold [18] ���ǰ�Ƶĵ�һ����¼��
	;xdata_hold [19] ��Ҫǰ�Ƶļ�¼��	
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	
	mov	r0,#xdata_hold+19
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	R0,#DATA_RXBUF + 5
	mov	@r0,a
	
	;assign offset H/L into r4 / r3
	MOV	R4,#0	
	MOV	R3,#1
	MOV	R2,#1		
	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	
	CALL	_FUN_CARDAPP_UpdateBinary
	
GSM_ESAMQY_OVER:
	
	RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;����
;		����ESAM���ݵ��û�����
;ǰ��
;	1.�Ѿ߱�����ESAM usercard�������������Χ����Ƭ�Ѹ�λ�ɹ�
;	2.��ѡ��ESAM df01 ef07 �� usercard 1001 0009 �ļ�
;���̣�
;				
;				����������
;					����������52��byte 5~56
;					����������52��byte 57~108
;				����ǰ5 0~4
;				����unixtime 4 109~113
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_FUN_GSM_ESAMToUserCard:

	;===����������52��byte 5~56===
	;����ESAM 52��byte 5~56
	CLR	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF	
	MOV	R5,#XDATA_TXBUF
	MOV	R4,#00		
	MOV	R3,#5		
	MOV	R2,#52;04;03
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7	
	
	;mov	a,#66
	;call	_fun_test_display
	
	;---JNZ	GSM_ESAMToUserCard_OVER
	JZ	GSM_ESAMToUserCardUPDATA1
	JMP	GSM_ESAMToUserCard_OVER
GSM_ESAMToUserCardUPDATA1:
	;д�û��� 52 byte 5~56
	SETB	BIT_GETRESULT
	SETB	BIT_ESAMICC
	
	MOV	R5,#DATA_RXBUF + 5
	MOV	R7,#XDATA_TXBUF
	MOV	R3,#52
	CALL	_FUN_LIB_XDATATODATA
	
	;assign offset H/L into r4 / r3
	mov	r4,#000h	
	mov	r3,#005h
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R2,#52
	CALL	_FUN_CARDAPP_UpdateBinary
	
	;MOV	A,R7	
	;CALL	_fun_test_display
	;---JNZ	GSM_SerialINTRX_OVER	
	JZ	GSM_ESAMToUserCardRVDATA2
	JMP	GSM_SerialINTRX_OVER
GSM_ESAMToUserCardRVDATA2:	
	;===����������52��byte 57~108===
	;����ESAM 52��byte 57~108
	CLR	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF	
	MOV	R5,#XDATA_TXBUF
	MOV	R4,#00		
	MOV	R3,#57		
	MOV	R2,#52;04;03
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7	
	;---JNZ	GSM_ESAMToUserCard_OVER
	JZ	GSM_ESAMToUserCardUPDATA02
	JMP	GSM_ESAMToUserCard_OVER
GSM_ESAMToUserCardUPDATA02:
	;д�û��� 52��byte 57~108
	SETB	BIT_GETRESULT
	SETB	BIT_ESAMICC
	
	MOV	R5,#DATA_RXBUF + 5
	MOV	R7,#XDATA_TXBUF
	MOV	R3,#52
	CALL	_FUN_LIB_XDATATODATA
	
	;assign offset H/L into r4 / r3
	mov	r4,#000h	
	mov	r3,#57
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R2,#52
	CALL	_FUN_CARDAPP_UpdateBinary
	
	MOV	A,R7	
	;CALL	_fun_test_display
	;---JNZ	GSM_SerialINTRX_OVER
	JZ	GSM_ESAMToUserCardRV5
	JMP	GSM_SerialINTRX_OVER
GSM_ESAMToUserCardRV5:
	;=== ����ǰ5 0~4 ===
	;����ESAM 5 byte 0~4
	CLR	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF	
	MOV	R5,#XDATA_TXBUF
	MOV	R4,#00		
	MOV	R3,#00		
	MOV	R2,#5;04;03
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7	
	JNZ	GSM_ESAMToUserCard_OVER

	;д�û��� 5 byte 0~4
	SETB	BIT_GETRESULT
	SETB	BIT_ESAMICC
	
	MOV	R5,#DATA_RXBUF + 5
	MOV	R7,#XDATA_TXBUF
	MOV	R3,#5
	CALL	_FUN_LIB_XDATATODATA
	
	;assign offset H/L into r4 / r3
	mov	r4,#000h	
	mov	r3,#000h
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R2,#5
	CALL	_FUN_CARDAPP_UpdateBinary
	
	MOV	A,R7	
	;CALL	_fun_test_display
	;----JNZ	GSM_SerialINTRX_OVER	
	JZ	GSM_ESAMToUserCardRVUNIX
	JMP	GSM_SerialINTRX_OVER
GSM_ESAMToUserCardRVUNIX:						
	;=== ����unixtime 4 109~113 ===
	CLR	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF	
	MOV	R5,#XDATA_TXBUF
	MOV	R4,#00		
	MOV	R3,#109		
	MOV	R2,#4							;04 + 03
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7
	JNZ	GSM_ESAMToUserCard_OVER
	
	;д�û��� 4 109~113
	SETB	BIT_GETRESULT
	SETB	BIT_ESAMICC
	
	MOV	R5,#DATA_RXBUF + 5
	MOV	R7,#XDATA_TXBUF
	MOV	R3,#4
	CALL	_FUN_LIB_XDATATODATA
	
	;assign offset H/L into r4 / r3
	mov	r4,#000h	
	mov	r3,#109
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R2,#4
	;---CALL	_FUN_CARDAPP_UpdateBinary
	
	MOV	A,R7	
	;CALL	_fun_test_display
	;JNZ	GSM_SerialINTRX_OVER	
GSM_ESAMToUserCard_OVER:
	

	
	RET		
;----------------------------------------------------------
;������
;	���ƫ����
;����
;	R7	---	CellID����(���)
;	R5	---	���ص�ƫ����(���)r5=r7*2
;����
;		
;----------------------------------------------------------
_FUN_GSM_GetOffset:
	
	MOV	AR0,AR7
	MOV	AR1,AR5
	
	INC	R1
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	B,#2
	MUL	AB
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	DEC	R1
	MOV	A,B
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	RET
	
;----------------------------------------------------------
;������
;	���ƫ����
;����
;	R7	---	CellID����(���)
;	R5	---	���ص�ƫ����(���)r5=r7*4
;����
;		
;----------------------------------------------------------
_FUN_GSM_GetOffset02:
	
	MOV	AR0,AR7
	MOV	AR1,AR5
	
	INC	R1
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	B,#4
	MUL	AB
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	DEC	R1
	MOV	A,B
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	RET	
		
;////////////////////////////////////////////////////////////	
;ORG
	MOV	AR0,AR7
	MOV	AR1,AR5
	
	INC	R1
	INC	R0
	
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;MOV	A,@R0
	MOV	B,#4
	MUL	AB
	
	MOV	Money,B		
	;MOV	@R1,A
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	DEC	R0
	DEC	R1
	
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;MOV	A,@R0
	MOV	B,#4
	MUL	AB
	
	CLR	C
	ADD	A,MONEY
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	;MOV	@R1,A
	
	RET
;----------------------------------------------------------
;������	
;	�����жϽ��ܳ���
;����
;	
;����	
;	1.��������
;	2.�����ǰ��CellID����
;		��鷵�ص� cellid �� obu 0020�ļ��м�¼�����һ��cellid�Ƿ���ͬ
;		����ͬ
;			1.дobu0020����Ƭ
;			2.�ش��ڽ����ж�
;			3.����cellid����
;		��ͬ
;			�˳�����
;	3.���³�ʼ�����򣬽���
;	
;STX(2) + RSCTL(1) + LEN(2) + CMD(1)+ DATA(XX)+ BCC(1)
;FA	���� CellIDָ��
;----------------------------------------------------------	
_FUN_GSM_SerialINTRX:
	;����һ֡���ݣ�������ɡ�
GSM_SerialINTRX_RXRight:
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	MOV	R0,#XDATA_CELLID
	MOV	R1,#XDATA_HOLD
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	INC	R0
	INC	R1
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	
	;��� ���� ����
GSM_SerialINTRX_SelectFile:
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;��� OBU CellID ����
	;MOV	DPH,#CONST_FLASH_Sys0020numH
	;MOV	DPL,#CONST_FLASH_Sys0020numL
	;MOV	AR7,#XDATA_HOLD
	;MOV	R3,#1					;2
	;CALL	_RDFlashXR
	;MOV	R0,#XDATA_HOLD
	;CALL	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R3,#0DFH
	MOV	R2,#001H
	CALL	_FUN_CARDAPP_SelectFile
	
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R3,#CONST_ESAMCellfile_H
	MOV	R2,#CONST_ESAMCellfile_L
	CALL	_FUN_CARDAPP_SelectFile
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID

	
	CLR	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF						;R7		---	����緳�ָ��(�ڴ�)\
	MOV	R5,#XDATA_HOLD+2
	MOV	R4,#00							;R4		---	�ļ�ID
	MOV	R3,#00							;R3		---	����
	MOV	R2,#05;04;03
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7
	;~~~~~~~~~~ ���ò��Զ� ~~~~~~~~~~
	;mov	A,#53
	;call	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	;---JNZ	GSM_SerialINTRX_NOInput02 
	;---JNZ	GSM_SerialINTRX_OVER
	JZ	GSM_SerialINTRX_lOWvO
	JMP	GSM_SerialINTRX_OVER
	
GSM_SerialINTRX_lOWvO:
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID
	
	MOV	R0,#XDATA_HOLD+3
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CJNE	A,#CONST_GSM_MaxNum,$+3
	JC	GSM_SerialINTRX_IsNotMax
	
	;---CALL	_Fun_GSM_RTCDis
	JMP	GSM_SerialINTRX_OVER
	
GSM_SerialINTRX_IsNotMax:
	
	; �Ƚ����һ��Cell_ID�봮�ڹ�����CellID�Ƿ���ͬ
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID		
	MOV	R0,#XDATA_HOLD+3
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	JZ	GSM_SerialINTRX_getoffset	
	
	MOV	R0,#XDATA_HOLD 		;��ǰ���� CellID	
	MOV	R1,#XDATA_HOLD+5;4	;��һ�����һ�� CellID	
	MOV	R3,#2			;4
GSM_SerialINTRX_CompareCellID:
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	B,A
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	XRL	A,B
	;JNZ	GSM_SerialINTRX_CompareCellIDXXX
	;JNZ	GSM_SerialINTRX_CompareCellIDover
	JNZ	GSM_SerialINTRX_getoffset
	INC	R0
	INC	R1
	DJNZ	R3,GSM_SerialINTRX_CompareCellID
	
	;/////////////////////////////////////////////////////////////////////////////////////////////	
	;�Ƚ�UnixTimeʱ���Ƿ�255 S������ ESAM ���û���ʱ��
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� = 0 �� = 1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����	
	;XDATA_HOLD[9~10] ��һ�����һ�� esam CellID unix timeƫ����	
	;/////////////////////////////////////////////////////////////////////////////////////////////	
	CLR	BIT_ESAMICC
	CALL	_FUN_GSM_JSUnixtimeOff
	
GSM_SerialINTRX_outputovvv:
	;/////////////////////////////////////////////////////////////////////////////////////////////
	JMP	GSM_SerialINTRX_OVER					;���CellID��ͬ����������
	;JMP	GSM_SerialINTRX_ESAMOVER	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;MOV	DPH,#CONST_FLASH_Sys0020H
	;MOV	DPL,#CONST_FLASH_Sys0020L+2
	;MOV	R7,#XDATA_HOLD
	;MOV	R3,#2
	;CALL	_rdflashxr
	
	;SETB	BIT_BUFADDR
	;MOV	R7,#XDATA_HOLD
	;MOV	R3,#2
	;MOV	A,#1
	;CALL	_FUN_TEST_UARTDISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GSM_SerialINTRX_getoffset:
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	
	MOV	R0,#XDATA_HOLD+3;2
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;call	_FUN_TEST_DISPLAY
	
	JNZ	GSM_SerialINTRX_getLastCellIDaddrPY
	
	;CellID ����Ϊ0
GSM_SerialINTRX_getLastCellIDaddr00:
	
	; ���� ��Ƭ ��ǰcellidƫ��
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����
	;XDATA_HOLD[9~10] ��һ�����һ�� esam CellID unix timeƫ����
	CLR	A
	MOV	R0,#XDATA_HOLD + 7;6
	
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	INC	R0
	MOV	A,#5;4 
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	

	MOV	R1,#XDATA_HOLD+10 
	MOV	R0,#XDATA_HOLD+8 
	
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#108;108= 52*2+4=104+4=52����¼��ÿ����¼2���ֽڣ�4���ֽ����unixtime
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	;---INC	R0
	
	dec	r0
	dec	r1
	
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A	

	JMP	GSM_SerialINTRX_getLastCellIDaddrov	
	;CellID ������Ϊ0
GSM_SerialINTRX_getLastCellIDaddrPY:
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����	
	;XDATA_HOLD[9~10] ��һ�����һ�� esam CellID unix timeƫ����
	MOV	R7,#XDATA_HOLD+3	 
	MOV	R5,#XDATA_HOLD+7 
	CALL	_FUN_GSM_GetOffset
	
	
	MOV	R0,#XDATA_HOLD+8 
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#5
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	;---INC	R0
	dec	R0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	
	MOV	R7,#XDATA_HOLD+3	 
	MOV	R5,#XDATA_HOLD+9 
	CALL	_FUN_GSM_GetOffset02
	
	MOV	R0,#XDATA_HOLD+10 
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#113
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	;---INC	R0
	dec	r0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
 	
;////////////////////////////////////////////////////////////////////
GSM_SerialINTRX_CompareCellIDover:
	
GSM_SerialINTRX_getLastCellIDaddrov:
;////////////////////////////////////////////////////////////////////
	
	;== update binary data ==
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����		
	
	MOV	R5,#DATA_RXBUF + 5
	MOV	R7,#XDATA_HOLD
	MOV	R3,#2
	CALL	_FUN_LIB_XDATATODATA
	
	;MOV	R0,#XDATA_HOLD; + 5
	;CALL	_FUN_TEST_DISPLAY
	
	;assign offset H/L into r4 / r3
	CLR	C
	MOV	R0,#XDATA_HOLD+8
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;addc	a,#11
	MOV	r3,a
	
	dec	r0
	;INC	R0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;addc	a,#0
	MOV	r4,a
	
	;mov	r4,#0
	;mov	r3,#00h	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R2,#2;04H
	CALL	_FUN_CARDAPP_UpdateBinary
	
	MOV	A,R7
	
	;CALL	_fun_test_display
	
	;---JNZ	GSM_SerialINTRX_OVER
	;---JZ	GSM_SerialINTRX_UPDATAESAM
	JZ	GSM_SerialINTRX_UPDATAESAMUNIX
	JMP	GSM_SerialINTRX_OVER
	
	;���� unix time
GSM_SerialINTRX_UPDATAESAMUNIX:
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����	
	;XDATA_HOLD[9~10] ��һ�����һ�� esam CellID unix timeƫ����
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC	
	
;R5	---	direct
	MOV	R5,#DATA_RXBUF + 5
	MOV	R7,#XDATA_UnixTime
	
;MOV	R0,#XDATA_UnixTime+3
;call	_fun_test_display	
	
	MOV	R3,#4
	CALL	_FUN_LIB_XDATATODATA
	
	;MOV	R0,#XDATA_HOLD; + 5
	;CALL	_FUN_TEST_DISPLAY
	
	;assign offset H/L into r4 / r3
	
;10:57	11:47
	
	CLR	c
	MOV	R0,#XDATA_HOLD+10
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;addc	a,#11
	mov	r3,a
	
	dec	r0
	;INC	R0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;addc	a,#0
	mov	r4,a
	;call	_fun_test_display
	;mov	r4,#0
	;mov	r3,#00h	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R2,#4;04H
	CALL	_FUN_CARDAPP_UpdateBinary
	
	MOV	A,R7
	
	;CALL	_fun_test_display
		
	;---JNZ	GSM_SerialINTRX_OVER
	JZ	GSM_SerialINTRX_UPDATAESAM
	JMP	GSM_SerialINTRX_OVER
	
	
GSM_SerialINTRX_UPDATAESAM:
	
	;== update record num ==
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����		
	
	
	;COPY  ���յ��� CellID
	MOV	R0,#XDATA_HOLD +3
	MOV	R1,#DATA_RXBUF+5
	
	MOV	A,#33
	mov	@r1,a
	inc	r1
	
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	INC	A
	MOV	@R1,A
	
	INC	R0
	INC	R1
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	@R1,A

	;COPY  ESAM CellID����
	MOV	R0,#XDATA_HOLD
	INC	R1
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;INC	A
	MOV	@R1,A	
	INC	R0
	INC	R1
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	@R1,A	
	;call	_fun_test_display
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;mov	a,r7	
	;call	_fun_test_display
	;setb	BIT_BUFADDR
	;MOV	R7,#XDATA_hold+4
	;CLR	BIT_BUFADDR
	;MOV	R7,#DATA_RXBUF+5	
	;MOV	R3,#4
	;CALL	_FUN_TEST_UARTDISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC
	MOV	r4,#0
	MOV	r3,#00h	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_txbuf
;	MOV	R2,#02H
	MOV	R2,#5
	CALL	_FUN_CARDAPP_UpdateBinary
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;SETB	BIT_BUFADDR
	;MOV	R7,#XDATA_HOLD
	;MOV	R3,#6
	;MOV	A,#1	
	;CALL	_FUN_TEST_UARTDISPLAY	
	;MOV	A,R7
	;Call	_fun_test_display
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	MOV	A,R7
	;---JNZ	GSM_SerialINTRX_OVER
	JZ	GSM_SerialINTRX_ESAMOVER
	JMP	GSM_SerialINTRX_OVER
GSM_SerialINTRX_ESAMOVER:
	SETB	BIT_HaveRecordCellID
;///////////////////////////////////////////////////////////////////////////////////////////////////////

	JB	BIT_INSERTCARD,GSM_SerialINTRX_UserCardStart
	JMP	GSM_SerialINTRX_OVER
GSM_SerialINTRX_UserCardStart:
	
	SETB	BIT_GETRESULT
	SETB	BIT_ESAMICC
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R3,#010H
	MOV	R2,#001H
	CALL	_FUN_CARDAPP_SelectFile	
	
	SETB	BIT_GETRESULT
	SETB	BIT_ESAMICC
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R3,#CONST_Cellfile_H
	MOV	R2,#CONST_Cellfile_L
	CALL	_FUN_CARDAPP_SelectFile
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID

	SETB	BIT_ESAMICC						;��ǰ���û�������
	SETB	BIT_GETRESULT	
	MOV	R7,#DATA_RXBUF						;R7		---	����緳�ָ��(�ڴ�)\
	MOV	R5,#XDATA_HOLD+2					;
	MOV	R4,#00							;R4		---	�ļ�ID
	MOV	R3,#00							;R3		---	����
	MOV	R2,#05							;03
	CALL	_FUN_CARDAPP_ReadBinary02
	MOV	A,R7
	;~~~~~~~~~~ ���ò��Զ� ~~~~~~~~~~
	;mov	A,#53
	;call	_FUN_TEST_DISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;---JNZ	GSM_SerialINTRX_NOInput02
	JZ	GSM_SerialINTRX_USERCARDlOWvO
	;---JMP	GSM_SerialINTRX_NOInput02
	JMP	GSM_SerialINTRX_OVER
	
GSM_SerialINTRX_USERCARDlOWvO:
	MOV	R0,#XDATA_HOLD+3
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CJNE	A,#CONST_GSM_MaxNum,$+3
	JC	GSM_SerialINTRX_USERCARDIsNotMax
	
	;CALL	_Fun_GSM_RTCDis
	JMP	GSM_SerialINTRX_OVER
	
GSM_SerialINTRX_USERCARDIsNotMax:
	
	; �Ƚ����һ��Cell_ID�봮�ڹ�����CellID�Ƿ���ͬ
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	MOV	R0,#XDATA_HOLD+3
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	JZ	GSM_SerialINTRX_USERCARDgetoffset
	
	MOV	R0,#XDATA_HOLD 		;��ǰ���� CellID	
	MOV	R1,#XDATA_HOLD+5	;��һ�����һ�� CellID	
	MOV	R3,#2;4
GSM_SerialINTRX_USERCARDCompareCellID:
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	B,A
		;MOVX	A,@R1
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	A,@DPTR
	XRL	A,B
	;JNZ	GSM_SerialINTRX_USERCARDCompareCellIDXXX
	;JNZ	GSM_SerialINTRX_USERCARDCompareCellIDover
	jnz	GSM_SerialINTRX_USERCARDgetoffset
	INC	R0
	INC	R1
	DJNZ	R3,GSM_SerialINTRX_USERCARDCompareCellID
	
	
	
	JMP	GSM_SerialINTRX_OVER	;���CellID��ͬ����������
	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;MOV	DPH,#CONST_FLASH_Sys0020H
	;MOV	DPL,#CONST_FLASH_Sys0020L+2
	;MOV	R7,#XDATA_HOLD
	;MOV	R3,#2
	;CALL	_rdflashxr
	
	;SETB	BIT_BUFADDR
	;MOV	R7,#XDATA_HOLD
	;MOV	R3,#2
	;MOV	A,#1
	;CALL	_FUN_TEST_UARTDISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GSM_SerialINTRX_USERCARDgetoffset:
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	MOV	R0,#XDATA_HOLD+3
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;call	_FUN_TEST_DISPLAY
	
	JNZ	GSM_SerialINTRX_USERCARDgetLastCellIDaddrPY
	
	;CellID ����Ϊ 0 
GSM_SerialINTRX_USERCARDgetLastCellIDaddr00:
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����
	;XDATA_HOLD[9~10] ��һ�����һ�� esam CellID unix timeƫ����
	
	CLR	A
	MOV	R0,#XDATA_HOLD + 7;6
	
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	INC	R0
	MOV	A,#5;4 
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A

	MOV	R1,#XDATA_HOLD+10 
	MOV	R0,#XDATA_HOLD+8 
	
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#108;108= 52*2+4=104+4=52����¼��ÿ����¼2���ֽڣ�4���ֽ����unixtime
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	;---INC	R0
	
	dec	r0
	dec	r1
	
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A	
	
	;CellID ������Ϊ0
	JMP	GSM_SerialINTRX_USERCARDgetLastCellIDaddrov	
	;CellID ������Ϊ0
GSM_SerialINTRX_USERCARDgetLastCellIDaddrPY:
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����	
	;XDATA_HOLD[9~10] ��һ�����һ�� esam CellID unix timeƫ����
	MOV	R7,#XDATA_HOLD+3	 
	MOV	R5,#XDATA_HOLD+7 
	CALL	_FUN_GSM_GetOffset
	
	
	MOV	R0,#XDATA_HOLD+8 
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#5
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	;---INC	R0
	dec	r0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	MOV	R7,#XDATA_HOLD+3	 
	MOV	R5,#XDATA_HOLD+9 
	CALL	_FUN_GSM_GetOffset02
	
	MOV	R0,#XDATA_HOLD+10 
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#113
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	;---INC	R0
	dec	r0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
GSM_SerialINTRX_USERCARDCompareCellIDover:
	
GSM_SerialINTRX_USERCARDgetLastCellIDaddrov: 
	
	;== update binary data ==
	SETB	BIT_GETRESULT
	SETB	BIT_ESAMICC
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����
	MOV	R5,#DATA_RXBUF + 5
	MOV	R7,#XDATA_HOLD
	MOV	R3,#2
	CALL	_FUN_LIB_XDATATODATA
	
	;MOV	R0,#XDATA_HOLD; + 5
	;CALL	_FUN_TEST_DISPLAY
	
	;assign offset H/L into r4 / r3
	CLR	c
	MOV	R0,#XDATA_HOLD+8
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;addc	a,#11
	mov	r3,a
	
	dec	r0
	;INC	R0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;addc	a,#0
	mov	r4,a
	
	;mov	r4,#0
	;mov	r3,#00h	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R2,#2;04H
	CALL	_FUN_CARDAPP_UpdateBinary
	
	MOV	A,R7
	
	;CALL	_fun_test_display
	
	JNZ	GSM_SerialINTRX_OVER
	
	;== update record num ==
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����
	
	;COPY  ���յ��� CellID
	MOV	R0,#XDATA_HOLD +3
	MOV	R1,#DATA_RXBUF+5
	
	MOV	A,#33
	mov	@r1,a
	inc	r1
	
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	INC	A
	MOV	@R1,A
	INC	R0
	INC	R1
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	@R1,A

	;COPY  ESAM CellID����
	MOV	R0,#XDATA_HOLD
	INC	R1
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;INC	A
	MOV	@R1,A	
	INC	R0
	INC	R1
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	MOV	@R1,A	
	;call	_fun_test_display
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;mov	a,r7	
	;call	_fun_test_display
	;setb	BIT_BUFADDR
	;MOV	R7,#XDATA_hold+4
	;CLR	BIT_BUFADDR
	;MOV	R7,#DATA_RXBUF+5	
	;MOV	R3,#4
	;CALL	_FUN_TEST_UARTDISPLAY
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	SETB	BIT_GETRESULT
	SETB	BIT_ESAMICC
	MOV	r4,#0
	MOV	r3,#00h	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_txbuf
	;MOV	R2,#02H
	MOV	R2,#5
	CALL	_FUN_CARDAPP_UpdateBinary
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;SETB	BIT_BUFADDR
	;MOV	R7,#XDATA_HOLD
	;MOV	R3,#6
	;MOV	A,#1
	;CALL	_FUN_TEST_UARTDISPLAY
	;MOV	A,R7
	;call	_fun_test_display
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	MOV	A,R7
	JNZ	GSM_SerialINTRX_OVER
	
GSM_SerialINTRX_USERCARDESAM:

;///////////////////////////////////////////////////////////////////////////////////////////////////////		
	CALL	_FUN_ContactIssue_INIT				
	
GSM_SerialINTRX_OVER:
	;CALL	_FUN_ContactIssue_Release
	
	;---JMP	AP_satrt
	
	RET
	

;----------------------------------------------------------
;�������Ź���
;R7	---	����緳�
;R7+5	---	����緳�����
;R3	---	���ų���
;head(1) + len(2) + cmd(1) + cmdPara(1) + data(n) + bcc(1)[from head to data xor]
;fd + xx xx + 01 + 03(unicode) + bcc
;����
;	��������ģ���Դ
;	���Ͷ�����Ϣ��ģ��
;	��������ģ���Դ
;----------------------------------------------------------
_FUN_GSM_ReportMSG:
	
	MOV	AR0,AR7		;[head]
	MOV	A,#0FDH
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	INC	R0		;len[0]
	INC	R0		;len[1]
	MOV	A,R3
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	INC	R0
	MOV	A,#001H		;CMD
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	INC	R0
	MOV	A,#003H		;CMD Para
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	INC	R0		;DATA[0]
	
	MOV	A,R0
	ADD	A,R3
	MOV	R0,A
	
	PUSH	AR3
	PUSH	AR7
	
	MOV	A,R3
	ADD	A,#5	
	MOV	R3,A	
	CLR	BIT_BUFADDR	
	CALL	_FUN_LIB_GetBCC
	
	POP	AR7
	POP	AR3
	
	JNZ	GSM_ReportMSG_OVER
	
	;����������Ϣ
	
GSM_ReportMSG_OVER:
	RET
	
;----------------------------------------------------------
;����:
;	����RTC	
;----------------------------------------------------------
_Fun_GSM_RTCEn:
	
;clr	es
	;���� RTC �������б��
	MOV	R0,#XDATA_RTCMode
	MOV	A,#CONST_RTC_ON
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	;��ʼ��RTC��ʱ��
	MOV	R0,#XDATA_RTCTime
	CLR	A
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	;����RTC [h0~3 L0~7]fffh = 6s
	;MOV	REG_MCU_WKCTH,#CONST_MCU_WKCTH
	;ORL	REG_MCU_WKCTH,#10000000B
	;MOV	REG_MCU_WKCTL,#CONST_MCU_WKCTL
	CALL	_FUN_GSM_RTCON
	;CALL	_Fun_GSM_GetCellIDEN
	
	Anl	REG_5412AD_P1M0,#00111111B	 ;
	Orl	REG_5412AD_P1M1,#01000000B	 ; MISO Ϊ����(����)
	
	CLR	PIN_PWR_GSM			 ; [GSM] 
;       	SETB	Pin_CC1101_SS
;	CLR	PIN_CC1101_SCLK
;	CLR	PIN_CC1101_MOSI
;	setb	PIN_CC1101_MISO
	;setb	PIN_CC1101_GDO2 
	;MOV	r7,#10
	;CALL	_fun_lib_delay
	
	CALL	_FUN_CC1101_RESET
	CALL	_FUN_CC1101_INIT
;	A			---	��ַ
;	R7			---	����
;	R6			---	���
;	R4			---	����
	;MOV	R4,#8
	;MOV	A,#7EH
	;MOV	R6,#XDATA_TXBUF
	;MOV	R7,#0C0H
	;CALL	_FUN_CC1101_spioSoftRXCC1101RXCC1101
	;34
	CALL	_FUN_CC1101_RVOn
	PUSH	AR7
	MOV	R7,#255
	DJNZ	R7,$	
	DJNZ	R7,$	
	DJNZ	R7,$	
	DJNZ	R7,$		
	DJNZ	R7,$	
	DJNZ	R7,$	
	DJNZ	R7,$	
	DJNZ	R7,$		
	DJNZ	R7,$	
	DJNZ	R7,$		

	POP	AR7
	;36 3A
	CALL	_FUN_CC1101_RVOff
	CALL	_FUN_CC1101_SetWakeUpTime
	CALL	_FUN_CC1101_RVWR
	CALL	_FUN_CC1101_Idle
	CALL	_FUN_CC1101_WakeUP
	
	RET
;----------------------------------------------------------
;����:
;	����RTC	
;----------------------------------------------------------	
_Fun_GSM_RTCDis:
		
	;���� RTC �������б��
	MOV	R0,#XDATA_RTCMode
	CLR	A
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	;��ʼ�� RTC ��ʱ��
	MOV	R0,#XDATA_RTCTime
	CLR	A
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	;�ر� RTC [h0~3 L0~7]fffh = 6s
	;MOV	REG_MCU_WKCTH,#CONST_MCU_WKCTH
	;MOV	REG_MCU_WKCTL,#CONST_MCU_WKCTL
	CALL	_FUN_GSM_RTCOFF
	
	Anl	REG_5412AD_P1M0,#01111111B	 ;
	Anl	REG_5412AD_P1M1,#01111111B	 ; MISO ��ͨ	
	
	SETB	PIN_PWR_GSM			 ; [GSM] 
;       	CLR	Pin_CC1101_SS
;	CLR	PIN_CC1101_SCLK
;	CLR	PIN_CC1101_MOSI
	;PIN_CC1101_MISO
;	CLR	PIN_CC1101_GDO2 
	
	RET
;----------------------------------------------------------
;����:
;	��RTC
;----------------------------------------------------------	
_FUN_GSM_RTCON:
		
	MOV	REG_MCU_WKCTH,#CONST_MCU_WKCTH
	;---ORL	REG_MCU_WKCTH,#10000000B
	MOV	REG_MCU_WKCTL,#CONST_MCU_WKCTL	
	RET	
;----------------------------------------------------------
;����:
;	��RTC	
;----------------------------------------------------------	
_FUN_GSM_RTCOFF:
	
	;ORL	REG_5412AD_P3M0,#01000000B
	;MOV	A,#39
	;CALL	_FUN_TEST_DISPLAY
	
	MOV	REG_MCU_WKCTH,#CONST_MCU_WKCTH
	MOV	REG_MCU_WKCTL,#CONST_MCU_WKCTL
	
	RET	
;----------------------------------------------------------
;����:
;	���cellid
;	1. ���� GSMIO Ϊ��ͨ��	3.7
;	2. GSMPow io�ƻ���	2.0
;	3. set gsmio L
;	4. set GSM Power H
;	5. sleep
;----------------------------------------------------------	
_Fun_GSM_GetCellIDEN:
	

	
	RET
;----------------------------------------------------------
;_FUN_GSM_LowVotage		�͵�ѹ����
;_FUN_GSM_ETCInputDeal		GSM��ETC��ڴ�������
;_FUN_GSM_ETCOnputDeal		GSM��ETC���ڴ�������
;----------------------------------------------------------
;DPTR	
;R7(���)
;BIT_BUFADDR
;----------------------------------------------------------
_Fun_GSM_Audio:
	
	RET


;----------------------------------------------------------
	;�Ƚ�UnixTimeʱ���Ƿ�255 S������ ESAM ���û���ʱ��
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� = 0 �� = 1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
;----------------------------------------------------------
_FUN_GSM_JSUnixtimeOff:
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����	
	;XDATA_HOLD[9~10] ��һ�����һ�� esam CellID unix timeƫ����	
	MOV	R0,#XDATA_HOLD + 3;2
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;CALL	_FUN_TEST_DISPLAY
	
	JNZ	GSM_JSUnixtimeOff_getLastCellIDaddrPY
	
	CLR	A
	MOV	R0,#XDATA_HOLD + 7;6
	
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	INC	R0
	MOV	A,#5;4 
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	MOV	R1,#XDATA_HOLD+10 
	MOV	R0,#XDATA_HOLD+8 
	
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#108;108= 52*2+4=104+4=52����¼��ÿ����¼2���ֽڣ�4���ֽ����unixtime
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A
	;---INC	R0
	
	dec	r0
	dec	r1
	
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R1,A
	MOV	DPH,#1
	MOV	DPL,R1
	MOVX	@DPTR,A	
	
	JMP	GSM_JSUnixtimeOff_UPDATEUNIXTIME	
	;CellID ������Ϊ0
GSM_JSUnixtimeOff_getLastCellIDaddrPY:
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID	
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����	
	;XDATA_HOLD[9~10] ��һ�����һ�� esam CellID unix timeƫ����
	MOV	R7,#XDATA_HOLD+3	 
	MOV	R5,#XDATA_HOLD+7 
	CALL	_FUN_GSM_GetOffset
	
	MOV	R0,#XDATA_HOLD+8 
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#5
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
	;---INC	R0
	DEC	R0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
			
	MOV	R7,#XDATA_HOLD+3	 
	MOV	R5,#XDATA_HOLD+9 
	CALL	_FUN_GSM_GetOffset02
	
	MOV	R0,#XDATA_HOLD+10 
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	CLR	C
	ADDC	A,#109;113
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	;---INC	R0
	DEC	R0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	ADDC	A,#0
		;MOVX	@R0,A
	MOV 	DPH,#1 
	MOV 	DPL,R0 
	MOVX 	@DPTR,A
	
GSM_JSUnixtimeOff_UPDATEUNIXTIME:
	
	;XDATA_HOLD[0~1] ���յ��� CellID
	;XDATA_HOLD[2] 33
	;XDATA_HOLD[3] ESAM CellID ����
	;XDATA_HOLD[4] ������ڡ���ڳ������� =0 �� =1 ��
	;XDATA_HOLD[5~6] ��һ�����һ�� CellID
	;XDATA_HOLD[7~8] ��һ�����һ�� esam CellIDƫ����	
	;XDATA_HOLD[9~10] ��һ�����һ�� esam CellID unix timeƫ����	
	SETB	BIT_GETRESULT
	CLR	BIT_ESAMICC	
	
;R5		---	direct
	MOV	R5,#DATA_RXBUF + 5
	MOV	R7,#XDATA_UnixTime
	
;MOV	R0,#XDATA_UnixTime+3
;call	_fun_test_display	
	
	MOV	R3,#4
	CALL	_FUN_LIB_XDATATODATA
	
	;MOV	R0,#XDATA_HOLD; + 5
	;CALL	_FUN_TEST_DISPLAY
	
	;assign offset H/L into r4 / r3
	
	CLR	c
	MOV	R0,#XDATA_HOLD+10
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;addc	a,#11
	mov	r3,a

	dec	r0
	;INC	R0
		;MOVX	A,@R0
	MOV	DPH,#1
	MOV	DPL,R0
	MOVX	A,@DPTR
	;addc	a,#0
	mov	r4,a
	;call	_fun_test_display
	;mov	r4,#0
	;mov	r3,#00h	
	MOV	R7,#DATA_RXBUF
	MOV	R5,#XDATA_TXBUF
	MOV	R2,#4;04H
	CALL	_FUN_CARDAPP_UpdateBinary
	
	MOV	A,R7



	RET


;----------------------------------------------------------
;_Fun_GSM_GetCellID:

;///////////////////////////////////////////////////////////////////////////////////////////////
;----------------------------------------------------------

	END	


