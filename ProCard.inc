;---段定义---
?pr?ProCard?Mater		SEGMENT CODE

;--- extrn NConatct.asm --- 
EXTRN	CODE(_FUN_NContact_spio)
EXTRN	CODE(_FUN_NContact_Rc500TxAndRx)
EXTRN	CODE(_FUN_NContact_Rc500TxAndRx02)
EXTRN	CODE(_FUN_LIB_DELAY)
EXTRN	CODE(_FUN_LIB_DELAYSIMPLAY)
;EXTRN	CODE(_FUN_NContact_TESTRc500TxAndRx)
EXTRN	CODE(_Rc500TxAndRx1001)
extrn	code(_Func_LCD_INIT)
;EXTRN	CODE(_FUN_NContact_Rc500Tx)
EXTRN	CODE(_FUN_NContact_Rc500Rx)
;--- extrn for test ---
EXTRN	CODE(_FUN_TEST_DISPLAY)
;EXTRN	CODE(_TESTRc500TxAndRx)

;EXTRN	CODE(NContact_Rc500TxAndRx_01)
EXTRN	DATA(DATA_IRQEN)
EXTRN	DATA(DATA_RXBUF)
EXTRN	DATA(DATA_MFCOM)
EXTRN	BIT(BIT_PROF)
EXTRN	BIT(BIT_BUFADDR)
extrn	bit(BIT_ProMF)
EXTRN	BIT(BIT_GETRESULT)
EXTRN	XDATA(XDATA_TXBUF)
PUBLIC	_FUN_ProCard_RXPro		; Pro卡接收数据
PUBLIC	_FUN_ProCard_TXPro		; Pro卡发送数据
PUBLIC	_FUN_ProCard_rats		; 
PUBLIC	_FUN_Pro_PPS			; Pro卡PPS命令
PUBLIC	_FUN_ProCard_Channel		; PRO通道函数
PUBLIC	_FUN_ProCard_TXBYTE
;PUBLIC	_FUN_ProCard_RXPro02
