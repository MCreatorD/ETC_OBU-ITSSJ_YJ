;---�ζ���---
?pr?ContactIssue?Mater	SEGMENT CODE

;--- ���� ---
EXTRN	BIT(BIT_BUFADDR)
EXTRN	BIT(BIT_VERIFY)
;EXTRN	BIT(BIT_ContactIssue)			;���п�ʼ���=0��û�н��շ�����Ϣ�����յ�������Ϣ
EXTRN	BIT(BIT_SERIALOVERTIMERX)		
EXTRN	BIT(BIT_BST)				;=1��ʾ�յ���bst,=0��ʾû���յ���bst		

EXTRN	DATA(DATA_RXBUF)

EXTRN	XDATA(XDATA_IssueRSCTL)			;���߷������
EXTRN	XDATA(XDATA_IssueCMD)			;���߷���������
EXTRN	XDATA(XDATA_TXBUF)

EXTRN	CODE(_FUN_LIB_GetBCC)
EXTRN	CODE(_FUN_Contact_CHANGEBAUD)
EXTRN	CODE(_FUN_SERIAL_RXHARD)
EXTRN	CODE(_FUN_SERIAL_TXHARD)
EXTRN	CODE(_FUN_LIB_DATATOXDATA)

EXTRN	CODE(_FUN_SERIAL_TXSOFT)
;--- ��� --- 
PUBLIC	_FUN_ContactIssue_INIT			;	���г�ʼ��
PUBLIC	_FUN_ContactIssue_Release
PUBLIC	_FUN_ContactIssue_RXBST			;	����_����BST
PUBLIC	_FUN_ContactIssue_RX			;	���շ�����Ϣ����PC��
PUBLIC	_FUN_ContactIssue_TX			;	���ͷ��л�Ӧ��Ϣ����PC��		 	���ͷ��л�Ӧ��Ϣ����PC��
public	_FUN_ContactIssue_RX02
PUBLIC	_FUN_ContactIssue_INIT02
PUBLIC	_FUN_ContactIssue_INITDown
PUBLIC	_FUN_ContactIssue_RX03
public	ContactIssue_RX02_Deal

;--- TEST ---
EXTRN	CODE(_FUN_TEST_DISPLAY)
;EXTRN	CODE(_FUN_SERIAL_InitUART2)
EXTRN	CODE(_FUN_SERIAL_RXHARD02)
EXTRN	CODE(_FUN_SERIAL_TXHARD02)
EXTRN	CODE(_FUN_SERIAL_INIT)

