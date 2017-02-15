	
BRT					EQU	09CH
Reg_Sys_BRT				EQU	09CH
;RegBit_SysBRT_S1BRS			BIT	Reg_Sys_BRT.1

S2CON					EQU	09AH
S2BUF					EQU	09BH
IE2					EQU	0AFH
RELOAD2_CONTR				EQU	0EAH
	
CONST_TIMEER02				EQU	1	;һ��6��
CONST_TIMEER03				EQU	254;245
CONST_TIMEER04				EQU	1

REG_51_AUXR1				EQU	0A2H
EPCAI					BIT	IE.6
;/////////////////////////////////////////////////////////////////////////////////////////////////
;NEW LCD
;PIN_Sys_IsDownload			BIT	P3.7
;PIN_LCD_OLEDD1				BIT	P1.2
;PIN_LCD_OLEDD0				BIT	P1.3
;PIN_LCD_OLEDDC				BIT	P1.4
;PIN_LCD_OLEDRES			BIT	P1.5
;PIN_LCD_OLEDCS				BIT	P4.3
;PIN_LCD_BG				BIT	P1.1
;PIN_OLED_ENSY7208			BIT	P4.0
P4					EQU	0C0H
;-----------------------------------------------------------------------------------------------
CONST_MAX_RXNUM				EQU	5
;TI_CCxxx0_SRES				EQU	30H
;Configuration Registers		
CONST_GDO2_VALUE			EQU	46h;046H	;06H
CONST_GDO2_MCSM2			EQU	2;03H
read_burst				EQU	0C0H
TI_CCxxx0_IOCFG2       			EQU	00H        ;GDO2 output pin configuration
TI_CCxxx0_IOCFG1       			EQU	01H        ;GDO1 output pin configuration
TI_CCxxx0_IOCFG0       			EQU	02H        ;GDO0 output pin configuration
TI_CCxxx0_FIFOTHR      			EQU	03H        ;RX FIFO and TX FIFO thresholds
TI_CCxxx0_SYNC1        			EQU	04H        ;Sync word, high byte
TI_CCxxx0_SYNC0        			EQU	05H        ;Sync word, low byte
TI_CCxxx0_PKTLEN       			EQU	06H        ;Packet length
TI_CCxxx0_PKTCTRL1     			EQU	07H        ;Packet automation control
TI_CCxxx0_PKTCTRL0     			EQU	08H        ;Packet automation control
TI_CCxxx0_ADDR         			EQU	09H        ;Device address
TI_CCxxx0_CHANNR       			EQU	0AH        ;Channel number
TI_CCxxx0_FSCTRL1      			EQU	0BH        ;Frequency synthesizer control
TI_CCxxx0_FSCTRL0      			EQU	0CH        ;Frequency synthesizer control
TI_CCxxx0_FREQ2        			EQU	0DH        ;Frequency control word, high byte
TI_CCxxx0_FREQ1        			EQU	0EH        ;Frequency control word, middle byte
TI_CCxxx0_FREQ0        			EQU	0FH        ;Frequency control word, low byte
TI_CCxxx0_MDMCFG4      			EQU	10H        ;Modem configuration
TI_CCxxx0_MDMCFG3      			EQU	11H        ;Modem configuration
TI_CCxxx0_MDMCFG2      			EQU	12H        ;Modem configuration
TI_CCxxx0_MDMCFG1      			EQU	13H        ;Modem configuration
TI_CCxxx0_MDMCFG0      			EQU	14H        ;Modem configuration
TI_CCxxx0_DEVIATN      			EQU	15H        ;Modem deviation setting
TI_CCxxx0_MCSM2        	EQU	16H        ;Main Radio Cntrl State Machine config
TI_CCxxx0_MCSM1        	EQU	17H        ;Main Radio Cntrl State Machine config
TI_CCxxx0_MCSM0        	EQU	18H        ;Main Radio Cntrl State Machine config
TI_CCxxx0_FOCCFG       	EQU	19H        ;Frequency Offset Compensation config
TI_CCxxx0_BSCFG        	EQU	1AH        ;Bit Synchronization configuration
TI_CCxxx0_AGCCTRL2     	EQU	1BH        ;AGC control
TI_CCxxx0_AGCCTRL1     	EQU	1CH        ;AGC control
TI_CCxxx0_AGCCTRL0     	EQU	1DH        ;AGC control
TI_CCxxx0_WOREVT1      	EQU	1EH        ;High byte Event 0 timeout
TI_CCxxx0_WOREVT0      	EQU	1FH        ;Low byte Event 0 timeout
TI_CCxxx0_WORCTRL      	EQU	20H        ;Wake On Radio control
TI_CCxxx0_FREND1       	EQU	21H        ;Front end RX configuration
TI_CCxxx0_FREND0       	EQU	22H        ;Front end TX configuration
TI_CCxxx0_FSCAL3       	EQU	23H        ;Frequency synthesizer calibration
TI_CCxxx0_FSCAL2       	EQU	24H        ;Frequency synthesizer calibration
TI_CCxxx0_FSCAL1       	EQU	25H        ;Frequency synthesizer calibration
TI_CCxxx0_FSCAL0       	EQU	26H        ;Frequency synthesizer calibration
TI_CCxxx0_RCCTRL1      	EQU	27H        ;RC oscillator configuration
TI_CCxxx0_RCCTRL0      	EQU	28H        ;RC oscillator configuration
TI_CCxxx0_FSTEST       	EQU	29H        ;Frequency synthesizer cal control
TI_CCxxx0_PTEST        	EQU	2AH        ;Production test
TI_CCxxx0_AGCTEST      	EQU	2BH        ;AGC test
TI_CCxxx0_TEST2        	EQU	2CH        ;Various test settings	
TI_CCxxx0_TEST1        	EQU	2DH        ;Various test settings
TI_CCxxx0_TEST0        	EQU	2EH        ;Various test settings

;Strobe commands
TI_CCxxx0_SRES         	EQU	30H        ;Reset chip.
TI_CCxxx0_SXOFF        	EQU	32H        ;Turn off crystal oscillator.
TI_CCxxx0_SCAL         	EQU	33H        ;Calibrate freq synthesizer & disable
TI_CCxxx0_SRX          	EQU	34H        ;Enable RX.
TI_CCxxx0_STX          	EQU	35H        ;Enable TX.
TI_CCxxx0_SIDLE        	EQU	36H        ;Exit RX / TX
TI_CCxxx0_SAFC         	EQU	37H        ;AFC adjustment of freq synthesizer
TI_CCxxx0_SWOR         	EQU	38H        ;Start automatic RX polling sequence
TI_CCxxx0_SPWD         	EQU	39H        ;Enter pwr down mode when CSn goes hi
TI_CCxxx0_SFRX         	EQU	3AH        ;Flush the RX FIFO buffer.
TI_CCxxx0_SFTX         	EQU	3BH        ;Flush the TX FIFO buffer.
TI_CCxxx0_SWORRST      	EQU	3CH        ;Reset real time clock.
TI_CCxxx0_SNOP         	EQU	3DH        ;No operation.
	
;Status_registers
TI_CCxxx0_PARTNUM      			EQU	30H        ;Part number
TI_CCxxx0_VERSION      			EQU	31H        ;Current version number
TI_CCxxx0_FREQEST      			EQU	32H        ;Frequency offset estimate
TI_CCxxx0_LQI          			EQU	33H        ;Demodulator estimate for link quality
TI_CCxxx0_RSSI         			EQU	34H        ;Received signal strength indication
TI_CCxxx0_MARCSTATE    			EQU	35H        ;Control state machine state
TI_CCxxx0_WORTIME1     			EQU	36H        ;High byte of WOR timer
TI_CCxxx0_WORTIME0     			EQU	37H        ;Low byte of WOR timer
TI_CCxxx0_PKTSTATUS    			EQU	38H        ;Current GDOx status and packet status
TI_CCxxx0_VCO_VC_DAC   			EQU	39H        ;Current setting from PLL cal module
TI_CCxxx0_TXBYTES      			EQU	3AH        ;Underflow and # of bytes in TXFIFO
TI_CCxxx0_RXBYTES      			EQU	3BH        ;Overflow and # of bytes in RXFIFO
TI_CCxxx0_NUM_RXBYTES  			EQU	7FH        ;Mask "# of bytes" field in _RXBYTES
	
;Other memory locations
TI_CCxxx0_PATABLE      			EQU	3EH
TI_CCxxx0_TXFIFO       			EQU	3FH
TI_CCxxx0_RXFIFO       			EQU	3FH
	
PIN_WAVE_RX				BIT	p0.2;P2.0;p0.1;p1.0
PIN_OUTPUT_CLK				BIT	P3.4;P1.0
REG_WAKE_CLK0				EQU	08FH
CONST_DATA_VALUE1			EQU	15;20;20;20
CONST_DATA_VALUE2			EQU	208+14;14;255;208+14;14
;-----------------------------------------------------------------------------------------------
;��Դ����
PIN_PWRDWN_LCD				BIT	p1.5;p1.3	 
Pin_pwrdwn				BIT 	p2.4;P2.7	 
PIN_PWR_GSM				BIT	p2.3;P2.4	 
	
;--- Active ---
Pin_unfix				BIT 	P3.5	 
PIN_card_exist				BIT	p3.3	
WKO_BK					BIT	P3.2	 
PIN_PWR_LOWIO				BIT	p1.5;P2.1	 
	
;--- ESAM ---
PIN_ESAM_TX				BIT	p0.3;P2.6	 
PIN_ESAM_RX				BIT	p0.3;P2.6	 
PIN_ESAM_RST				BIT	p0.5;P2.5	 
	
;--- ������� ---
Pin_Red					BIT 	p4.5;P4.1	 
Pin_Gre 				BIT	p4.4;P4.5

PIN_BELL_01				BIT	p1.5;P0.3	 
PIN_BELL_02				BIT	p1.5;P0.2	 
	
;--- CC1101 ---
;Pin_CC1101_SS				BIT	p3.6	 
;PIN_CC1101_SCLK				BIT	P2.2	 
;PIN_CC1101_MOSI				BIT	P2.3	 
;PIN_CC1101_MISO				BIT	p3.7	 
;PIN_CC1101_GDO2				BIT	P1.6	 
	
;--- Һ������ ---
Pin_LCD_CS				BIT	p1.5;p1.4	 
Pin_LCD_RST				BIT	P1.5; 	 
Pin_LCD_DC				BIT	p1.5;p1.7	
Pin_LCD_SCL				BIT	p1.5;p3.4	
Pin_LCD_SDA				BIT	p1.5;p4.3	
	
;--- 522 ---
PIN_522_SCLK				BIT	P0.7;P0.7	 
PIN_522_MOSI				BIT	p4.6;P0.5	 
PIN_522_MISO				BIT	p4.1;P0.4	 
Pin_522_SS				BIT	P0.6;P0.6	 
Pin_522_RST				BIT	p0.4;P4.6	 
	
PIN_SOFTSERIALRX			BIT	P3.0	 
PIN_SOFTSERIALTXH			BIT	P3.1	 
	
PIN_PWR_SE				BIT	p1.5	;p2.2	; P2.4	;	[ GSM ]	
Pin_SW					BIT	p1.5	
	
	
;fu dand wei
Pin_ES_Rst 				BIT	p2.6;P2.3	;p4.0;P4.4	; P4.4	
PIN_SE_IO1				BIT	p3.4;p2.4	;P4.4;p2.3;p4.4;P2.2	; P0.5
	
	
;--- CC1101 ---
PIN_UART2_TX				BIT	p1.7	;p3.6	; P3.7
PIN_UART2_RX				BIT	P1.6	; 
	
BUSY					BIT	20H.0
;////////////////////////////////////////////////���Ŷ���/////////////////////////////////////////////////
;��Ϊ��
PIN_BK_CE				BIT	p1.1	 
Pin_5823BK_CS				BIT     P1.0
;�������Ϊ��				
Pin_5823BK_MISO				BIT	p0.0	 
Pin_5823BK_IRQ				BIT	p1.2	  
;   �� �� ��
Pin_5823BK_MOSI				BIT	p0.1	 
Pin_5823BK_SCLK				BIT	p4.2	 
 
PIN_WAVE_CHANNEL1			BIT	p0.2;P2.0	 
 
;=====================================================================================
Reg_WakeClk0				EQU	08fH
Reg_WakeClk_04 				BIT 	CCON.4	;P3.4
Reg_WakeClk_05 				BIT 	CCON.5	;P3.5
;����STC12C5628AD ϵ�� MCU ���⹦�ܼĴ�����ַ
IPH EQU 0B7H ;�ж����ȼ���λ�Ĵ���
EPCA_LVD EQU IE.6 ;PCA �жϺ� LVD(��ѹ���)�жϹ��������жϿ���λ
CH EQU 0F9H ;PCA ��������8 λ��
CL EQU 0E9H ;PCA ��������8 λ��

;------------------------
CCON EQU 0D8H ;PCA ���ƼĴ�����
CCF0 EQU CCON.0 ;PCA ģ��0 �жϱ�־, ��Ӳ����λ, ������������0��
CCF1 EQU CCON.1 ;PCA ģ��1 �жϱ�־, ��Ӳ����λ, ������������0��
CCF2 EQU CCON.2 ;PCA ģ��2 �жϱ�־, ��Ӳ����λ, ������������0��
CCF3 EQU CCON.3 ;PCA ģ��3 �жϱ�־, ��Ӳ����λ, ������������0��
CCF4 EQU CCON.4 ;PCA ģ��4 �жϱ�־, ��Ӳ����λ, ������������0��
CCF5 EQU CCON.5 ;PCA ģ��5 �жϱ�־, ��Ӳ����λ, ������������0��
CR EQU CCON.6 ;1:���� PCA ����������, ������������0��
CF EQU CCON.7 ;PCA ���������(CH,CL �� FFFFH ��Ϊ 0000H)��־,
;PCA �������������Ӳ����λ,������������0��
;------------------------
CMOD EQU 0D9H ;PCA ����ģʽ�Ĵ�����

;CMOD.7 CIDL: idle ״̬ʱ PCA �������Ƿ��������, 0: ��������, 1: ֹͣ������
;CMOD.2 CPS1: PCA ��������������Դѡ��λ 1��
;CMOD.1 CPS0: PCA ��������������Դѡ��λ 0��
; CPS1 CPS0
; 0 0 �ⲿ����Ƶ��/12��
; 0 1 �ⲿ����Ƶ��/2��
; 1 0 Timer 0 ������壬
; Timer 0 ����ͨ�� AUXR �Ĵ������óɹ����� 12T �� 1T ģʽ��
; 1 1 �� ECI/P3.4 ��������ⲿʱ�ӡ�
;CMOD.0 ECF: PCA ����������ж�����λ, 1-- ���� CF(CCON.7) �����жϡ�
;------------------------
CCAP0H EQU 0FAH ;PCA ģ��0 �Ĳ�׽/ �ȽϼĴ����� 8 λ��
CCAP1H EQU 0FBH ;PCA ģ��1 �Ĳ�׽/ �ȽϼĴ����� 8 λ��
CCAP2H EQU 0FCH ;PCA ģ��2 �Ĳ�׽/ �ȽϼĴ����� 8 λ��
CCAP3H EQU 0FDH ;PCA ģ��3 �Ĳ�׽/ �ȽϼĴ����� 8 λ��
CCAP4H EQU 0FEH ;PCA ģ��4 �Ĳ�׽/ �ȽϼĴ����� 8 λ��
CCAP5H EQU 0FFH ;PCA ģ��5 �Ĳ�׽/ �ȽϼĴ����� 8 λ��
CCAP0L EQU 0EAH ;PCA ģ��0 �Ĳ�׽/ �ȽϼĴ����� 8 λ��
CCAP1L EQU 0EBH ;PCA ģ��1 �Ĳ�׽/ �ȽϼĴ����� 8 λ��
CCAP2L EQU 0ECH ;PCA ģ��2 �Ĳ�׽/ �ȽϼĴ����� 8 λ��
CCAP3L EQU 0EDH ;PCA ģ��3 �Ĳ�׽/ �ȽϼĴ����� 8 λ��
CCAP4L EQU 0EEH ;PCA ģ��4 �Ĳ�׽/ �ȽϼĴ����� 8 λ��
CCAP5L EQU 0EFH ;PCA ģ��5 �Ĳ�׽/ �ȽϼĴ����� 8 λ��
;------------------------
PCA_PWM0 EQU 0F2H ;PCA ģ��0 PWM �Ĵ�����
PCA_PWM1 EQU 0F3H ;PCA ģ��1 PWM �Ĵ�����
PCA_PWM2 EQU 0F4H ;PCA ģ��2 PWM �Ĵ�����
PCA_PWM3 EQU 0F5H ;PCA ģ��3 PWM �Ĵ�����
PCA_PWM4 EQU 0F6H ;PCA ģ��4 PWM �Ĵ�����
PCA_PWM5 EQU 0F7H ;PCA ģ��5 PWM �Ĵ�����
;PCA_PWMn: 7 6 5 4 3 2 1 0
; - - - - - - EPCnH EPCnL
;B7-B2: ����
;B1(EPCnH): �� PWM ģʽ�£��� CCAPnH ��� 9 λ����
;B0(EPCnL): �� PWM ģʽ�£��� CCAPnL ��� 9 λ����
;------------------------
CCAPM0 EQU 0DAH ;PCA ģ��0 �Ĺ���ģʽ�Ĵ�����
CCAPM1 EQU 0DBH ;PCA ģ��1 �Ĺ���ģʽ�Ĵ�����
CCAPM2 EQU 0DCH ;PCA ģ��2 �Ĺ���ģʽ�Ĵ�����
CCAPM3 EQU 0DDH ;PCA ģ��3 �Ĺ���ģʽ�Ĵ�����
CCAPM4 EQU 0DEH ;PCA ģ��4 �Ĺ���ģʽ�Ĵ�����
CCAPM5 EQU 0DFH ;PCA ģ��5 �Ĺ���ģʽ�Ĵ�����
;CCAPMn: 7 6 5 4 3 2 1 0
; - ECOMn CAPPn CAPNn MATn TOGn PWMn ECCFn
;
;ECOMn = 1:�����ȽϹ��ܡ�
;CAPPn = 1:���������ش�����׽���ܡ�
;CAPNn = 1:�����½��ش�����׽���ܡ�
;MATn = 1:��ƥ���������ʱ, ���� CCON �е� CCFn ��λ��
;TOGn = 1:��ƥ���������ʱ, CEXn ����ת��
;PWMn = 1:�� CEXn ����Ϊ PWM �����
;ECCFn = 1:���� CCON �е� CCFn �����жϡ�
;ECOMn CAPPn CAPNn MATn TOGn PWMn ECCFn
; 0 0 0 0 0 0 0 00H δ�����κι��ܡ�
; x 1 0 0 0 0 x 21H 16 λCEXn �����ش�����׽���ܡ�
; x 0 1 0 0 0 x 11H 16 λCEXn �½��ش�����׽���ܡ�
; x 1 1 0 0 0 x 31H 16 λCEXn ����(�ϡ�����)������׽���ܡ�
; 1 0 0 1 0 0 x 49H 16 λ������ʱ����
; 1 0 0 1 1 0 x 4DH 16 λ�������������
; 1 0 0 0 0 1 0 42H 8 λ PWM��
;------------------------------------------------------------------------------
;==============================================================================
;//////////////////////////////////////////////�����Ĵ��� ///////////////////////////////////////////
ISP_CONTR				EQU	0C7h
WAKE_CLKO				EQU	08fh
;���ӵ� SFR WAKE_CLKO (��ַ��0x8F)
;b7 - PCAWAKEUP :1, ���� PCA ������ / �½����ж� ���� powerdown��
;b6 - RXD_PIN_IE:1, ���� P3.0(RXD) �½����� RI��Ҳ��ʹ RXD ���� powerdown��
;b5 - T1_PIN_IE :1, ���� T1/P3.5 ���½����� T1 �жϱ�־��Ҳ��ʹ T1 �Ż��� powerdown��
;b4 - T0_PIN_IE :1, ���� T0/P3.4 ���½����� T0 �жϱ�־��Ҳ��ʹ T0 �Ż��� powerdown��
;b3 - N/A
;b2 - N/A
;b1 - T1CLKO : ���� T1 �������P1.1 �����ʱ�ӣ����ʱ��Ƶ�� = 1/2 T1 �����
;	T1 ������1T ģʽʱ�����Ƶ��CLKOUT1 =( Fosc / 2 ) / ( 256 - TH1 )
;	T1 ������12T ģʽʱ�����Ƶ��CLKOUT1 =( Fosc / 2 ) / 12 / ( 256 - TH1 )
;b0 -	T0CLKO : ���� T0 �������P1.0 �����ʱ�ӣ����ʱ��Ƶ�� = 1/2 T0 �����
;	T0 ������1T ģʽʱ�����Ƶ��CLKOUT0 =( Fosc / 2 ) / ( 256 - TH0)
;	T0 ������12T ģʽʱ�����Ƶ��CLKOUT0 =( Fosc / 2 ) / 12 / ( 256 - TH0 )
;--------------------------------------------------------
;--------------------------------------------------------
REG_5412AD_P0M0				EQU 	094h;093h
REG_5412AD_P0M1				EQU 	093h;094h

REG_5412AD_P1M0				EQU 	092h;091h
REG_5412AD_P1M1				EQU 	091h;092h

REG_5412AD_P2M0				EQU 	096h;095h
REG_5412AD_P2M1				EQU 	095h;096h

REG_5412AD_P3M0				EQU 	0b2h;0b1h
REG_5412AD_P3M1				EQU 	0b1h;0b2h

REG_5412AD_P4M0				EQU 	0b4h;0b3h
REG_5412AD_P4M1				EQU 	0b3h;0b4h
;-------------------------------------------------------------
REG_5412AD_AUXR				EQU	08EH		;�����Ĵ���
REG_5412AD_spctl			EQU	085H
REG_5412AD_spstat			EQU	084H
REG_5412AD_spdat			EQU	086H
REG_WDT_CONTR				EQU	0C1H		;0E1H;0C1H
REG_5412AD_P4SW				EQU	0BBH
REG_MCU_WKCTH				EQU	0ABH
REG_MCU_WKCTL				EQU	0AAH	
;//////////////////////////////////////////////RC522�Ĵ��� ///////////////////////////////////////////////////
REG_RC522_RC522PAGE			EQU	00H
REG_RC522_CommandReg 			EQU	01H
REG_RC522_ComIEnReg 			EQU	02H
REG_RC522_DivIEnReg			EQU	03H
REG_RC522_ComIrqReg 			EQU	04H
REG_RC522_DivIrqReg			EQU	05H
REG_RC522_ErrorReg			EQU	06h
REG_RC522_Status1Reg			EQU	07h
REG_RC522_Status2Reg			EQU	08h
REG_RC522_FIFODataReg			EQU	09h
REG_RC522_FIFOLevelReg			EQU	0ah
REG_RC522_WaterLevelReg			EQU	0bh
REG_RC522_ControlReg 			EQU	0ch
REG_RC522_BitFramingReg			EQU	0dh
REG_RC522_CollReg			EQU	0eh
REG_RC522_RFU				EQU	0fh
REG_RC522_ModeReg			EQU	11h
REG_RC522_TxModeReg			EQU	12h
REG_RC522_RxModeReg			EQU	13h
REG_RC522_TxControlReg			EQU	14h
REG_RC522_TxAutoReg			EQU	15h
REG_RC522_TxSelReg			EQU	16h
REG_RC522_RxSelReg			EQU	17h
REG_RC522_RxThresholdReg		EQU	18h
REG_RC522_DemodReg			EQU	19h
REG_RC522_MifareReg			EQU	1ch
REG_RC522_SerialSpeedReg		EQU	1fh
REG_RC522_CRCResultRegH 		EQU	21h
REG_RC522_CRCResultRegL 		EQU	22h
REG_RC522_ModWidthReg 			EQU	24h
REG_RC522_RFCfgReg			EQU	26h
REG_RC522_GsNReg			EQU	27h
REG_RC522_CWGsPReg 			EQU	28h
REG_RC522_ModGsPReg 			EQU	29h
REG_RC522_TModeReg			EQU	2ah
REG_RC522_TPrescalerReg 		EQU	2bh
REG_RC522_TReloadRegH 			EQU	2ch
REG_RC522_TReloadRegL			EQU	2dh
REG_RC522_TCounterValueRegH		EQU	2eh
REG_RC522_TCounterValueRegL		EQU	2fh
	
;/////////////////////////////////////////////////һ��ϵͳ������/////////////////////////////////////////////////
CONST_HOLD_5823TX			EQU	1
CONST_HOLD_5823RX			EQU	0
	
	
CONST_SYS_TradeConfine			EQU	255				;����ʱ������
CONST_SYS_PowerONTimer			EQU	10				;�ϵ綨ʱ��	
CONST_SYS_PREFlag			EQU	088H				;
CONST_SYS_AA				EQU	0AAH
CONST_SYS_55				EQU	55H
CONST_SYS_OBUIDLEN			EQU	4				;obuid ����
CONST_BSTLIMIT				EQU	8;20;10			;����BST����
CONST_BSTLIMIT02			EQU	100

CONST_VSTLIMIT				EQU	255	;100			;����VST����
CONST_Pro_OverTime2S			EQU	250				;��ʱ��ʱ��196-246*30=1200MS 
;/////////////////////////////////////////////////����ڳ�����/////////////////////////////////////////////////
CONST_ETC_INPUT				EQU	3	;ETC ���
CONST_MTC_INPUT				EQU	1	;MTC ���
CONST_INPUT_ISEnable			EQU	1;=1������ =0����
;/////////////////////////////////////////////////״̬������/////////////////////////////////////////////////
CONST_STATE_TRUE			EQU	000H				;ִ�гɹ�
CONST_STATE_FALSE			EQU	0FFH				;����ִ�г���
;һ���Դ���	01	����ʧ��	STR_InputFail
;��ͬ�Ų�ͬ	02	�Ƿ����뿨	STR_IllegalInputCard
;ʹ�ô���=FFH	03	���뿨ʧЧ	STR_InputCardInvalid
CONST_STATE_InputFail			EQU	01
CONST_STATE_IllegalInputCard		EQU	02
CONST_STATE_InputCardInvalid		EQU	03
;һ���Դ���	04	����ʧ��	STR_ActiveFail
;��ͬ�Ų�ͬ	05	�Ƿ����	STR_IllegalACTCard
;ʹ�ô���=FFH	06	���ʧЧ	STR_ACTCardInvalid
CONST_STATE_ActiveFail			EQU	04
CONST_STATE_IllegalACTCard		EQU	05
CONST_STATE_ACTCardInvalid		EQU	06
	
CONST_STATE_5823INIER			EQU	07	;5823��ʼ������
CONST_STATE_5823SleepEr			EQU	08	;5823���߳���
CONST_STATE_GetSecureSelFileEr		EQU	09	;getsecureѡ��Ŀ¼����

CONST_STATE_BaseNinit			EQU	10	;Baseinit02��������ʼ����Ƭʧ��
CONST_STATE_BaseESAMDF01		EQU	11	;Baseinit02������ѡESAM��DF01ʧ��
	
CONST_STATE_CARDPreDeal1001		EQU	12	;Ԥ��1001ʧ��
CONST_STATE_CARDPreDeal0002		EQU	13	;Ԥ��0002ʧ��
CONST_STATE_CARDPreDeal0012		EQU	14	;Ԥ��0012ʧ��
CONST_STATE_CARDPreDeal0015		EQU	15	;Ԥ��0015ʧ��
CONST_STATE_CARDPreDeal0019		EQU	16	;Ԥ��0019ʧ��
CONST_STATE_CARDPreDeal3f00		EQU	17	;Ԥ��3f00ʧ��
CONST_STATE_CARDPreDeal81		EQU	18	;Ԥ��81ʧ��
	
CONST_STATE_BaseN01init			EQU	19	;Baseinit��������ʼ����Ƭʧ��
CONST_STATE_Base01ESAMDF01		EQU	20	;Baseinit������ѡESAM��DF01ʧ��
	
CONST_STATE_Base01Contact		EQU	21	;Baseinit�����������Ӵ�
CONST_STATE_Base02Contact		EQU	22	;Baseinit02�����������Ӵ�	
	
CONST_STATE_test			EQU	23	;Baseinit02�����������Ӵ�	
	
CONST_STATE_Base02Re			EQU	24
CONST_STATE_Base02AntiColl		EQU	25
CONST_STATE_Base02Sel			EQU	26
CONST_STATE_Base02Rats			EQU	27
	
CONST_STATE_Base01Re			EQU	28
CONST_STATE_Base01AntiColl		EQU	29
CONST_STATE_Base01Sel			EQU	30
CONST_STATE_Base01Rats			EQU	31	
	
CONST_STATE_MemoryEr			EQU	32	
CONST_STATE_ExMemoryEr			EQU	33	
CONST_STATE_ExMemoryEr02		EQU	34	
	
CONST_STATE_SERIALACCPET		EQU	001H				;���ڽ��մ���
CONST_STATE_SERIALOVERTIME		EQU	CONST_STATE_SERIALACCPET + 1	;���ڽ��ճ�ʱ
CONST_STATE_ACCEPTOVER			EQU	CONST_STATE_SERIALOVERTIME + 1	;���ڽ�����ϣ�û�к����ֽ� 
CONST_STATE_ACCEPTOVERLEN		EQU	CONST_STATE_ACCEPTOVER + 1	;���ڽ��ճ���
CONST_STATE_RSTCPUER			EQU	CONST_STATE_ACCEPTOVERLEN + 1	;��λ���ڴ���
CONST_STATE_AUTHER			EQU	CONST_STATE_RSTCPUER + 1	;��֤ʧ��
	
;--- �������������� ---
CONST_WORKSTAION_0			EQU	00H	;������0
CONST_WORKSTAION_1			EQU	01H	;������1
CONST_WORKSTAION_2			EQU	02H	;������2	
CONST_WORKSTAION_3			EQU	03H	;������3

;//////////////////////////////////////��Ƭ�߼���������////////////////////////////////////////////
CONST_CARD_PASS				EQU	23
CONST_CARD_CONSUME			EQU	22
;//////////////////////////////////////GSM��������//////////////////////////////////////////////////
CONST_LHX_FLAG				EQU	2 ;0-����OBU  1-GSM OBU  2-433 OBU

;RTC ��ʱ��				;6���ӣ�ƽ������һ��cellID
;CONST_RTCOverFlow			EQU	144;180;180
;CONST_RTCUartRX			EQU	24;4;8,12,16,20,24;142;

CONST_RTCOverFlow			EQU	144;20;144;6;144;6;12;144
;CONST_RTCUartRX				EQU	12
;CONST_RTCUartRX02			EQU	142
CONST_Flag_INPUT			EQU	0
CONST_Flag_OutPUT			EQU	1

;GSM CellID ��¼�������ڵ��ļ���
CONST_Cellfile_H			EQU	000H
CONST_Cellfile_L			EQU	09h;030H

CONST_ESAMCellfile_H			EQU	0EFH;000H
CONST_ESAMCellfile_L			EQU	07H;03h;030H
;CONST_Cellfile_H			EQU	000H
;CONST_Cellfile_L			EQU	008h

CONST_GSM_MaxNum			EQU	240
;CONST_GSM_MaxNum			EQU	5

CONST_GSM_PJNum				EQU	20
;CONST_GSM_PJNum			EQU	1

;RTC С��ʱ��;
CONST_MCU_WKCTH				EQU	008H;0fh;00fH;00fH;00fH
CONST_MCU_WKCTL				EQU	0FFH

;RTC �Ƿ��������ֵ
;=CONST_RTC_ON ��ʾ����
;= ���� û�п���
CONST_RTC_ON				EQU	55H
CONST_RTC_off				EQU	0ffH
CONST_SYS_RTCOverTime			EQU	100

;�忨��obu��Cellid��¼���뵽��Ƭ�У�һ��д�뵽��Ƭ�� cellID ���ֽ���
CONST_GSM_NUM				EQU	8		;40
;//////////////////////////////////////MF��������//////////////////////////////////////////////////
CONST_MF_READ				EQU	00H	;ָ������ ����
CONST_MF_WRITE				EQU	01H	;ָ������ д��
CONST_MF_DECREMENT			EQU	02H	;ָ������ �ۿ�
CONST_MF_INCREMENT			EQU	03H	;ָ������ ��ֵ
CONST_MF_RESTOR				EQU	04H	;ָ������ ���ݿ�

CONST_MF_RC500DECREMENT			EQU	0C0H	;RC500 �ۿ�
CONST_MF_RC500INCREMENT			EQU	0C1H	;RC500 ��ֵ
;//////////////////////////////////////DSRC��������//////////////////////////////////////////////////
CONST_DSRC_MACCTRL			EQU	4	;MAC������
CONST_DSRC_LLCCTRL			EQU	5	;LLC������
CONST_DSRC_HEAD				EQU	6	;�ֶ���ͷ
CONST_DSRC_ACTION			EQU	7	;Action
CONST_DSRC_DID				EQU	8	;DSRC-DID
CONST_DSRC_ACTIONTYPE			EQU	9	;ActionType
CONST_DSRC_CONTAIN			EQU	10	;Contain
CONST_DSRC_Fill				EQU	11	;Fill
CONST_SSRC_FID				EQU	12	;�ļ���ʶ��FID��

CONST_DSRC_FildIDAPPKey			EQU	0	;0�D�DETC Ӧ����Կ�ļ�
CONST_DSRC_FildIDVehicle		EQU	1	;1�D�DETC Ӧ�ó�����Ϣ�ļ�
CONST_DSRC_FildIDConsume		EQU	2	;2-ETC Ӧ�ý��׼�¼�ļ�
CONST_DSRC_FildIDHold			EQU	3	;3-ETC Ӧ�ñ����ļ�

CONST_DSRC_ChannelIDICC			EQU	1
CONST_DSRC_ChannelIDSAM			EQU	2
;//////////////////////////////////////AcionType��������///////////////////////////////////////////////
Const_ActionType_GetSecure		EQU	0	;getSecure
Const_ActionType_SetSecure		EQU	1	;setSecure
Const_ActionType_GetRand		EQU	2	;getRand
Const_ActionType_TransferChannel	EQU	3	;transferChannel
Const_ActionType_SetMMI			EQU	4	;SetMMI
;//////////////////////////////////////Flash��������//////////////////////////////////////////////////
CONST_Flash_SysinfoLen			EQU	88;39;38+12	; ESAMϵͳ��Ϣ�ļ�����
CONST_Flash_0002Len			EQU	4	; 0002ϵͳ��Ϣ�ļ�����	
CONST_Flash_0012Len			EQU	40	; 0012ϵͳ��Ϣ�ļ�����
;CONST_Flash_0015Len			EQU	33	; 0015ϵͳ��Ϣ�ļ�����
CONST_Flash_0015Len			EQU	43	; 0015ϵͳ��Ϣ�ļ�����
CONST_Flash_0019Len			EQU	60;43	; 0019ϵͳ��Ϣ�ļ�����
CONST_Flash_0019GBLen			EQU	43;43	; 0019ϵͳ��Ϣ�ļ�����
CONST_Flash_CardTypeLEN			EQU	1	; �ϴβ忨�ǽӴ������ǷǽӴ�
;CONST_Flash_SYSPARAMLEN		EQU	1	; ϵͳ����
CONST_Flash_BeaconIDUnixTimeLen		EQU	8	; ����ID��unixtime
CONST_FALSH_PREFlagLen			EQU	1	; Ԥ�������=88,��ʾ�ϻ�Ԥ�����ɹ�

;************************************************************************************
;�ر�ע: ������Ԥ��0015/0012/0019ʱ�ݴ������ĳ��ȳ���128���ֽڣ����ԣ�������������λ�ã�Ҫ��Const_Flash_FileLen
;����֮��Const_Flash_FileLen = 8F������Ժ�Const_Flash_FileLen���ȸ��ˣ���������ʼλ��ҲҪ��
;������ʼλ�ö�����OBUmain.inc��XDATA_VARSTART��ֵ
;************************************************************************************
Const_Flash_FileLen			EQU	CONST_Flash_SysinfoLen + CONST_Flash_0015Len + CONST_Flash_0019Len + CONST_Flash_0012Len + CONST_Flash_0002Len + CONST_Flash_CardTypeLEN 

CONST_FLASH_Block01			EQU	72H

CONST_FLASH_STARTHIGH			EQU	CONST_FLASH_Block01;2EH						; FLASH�洢��������ַ
CONST_FLASH_STARTLOW			EQU	00H						; FLASH�洢��������ַ

CONST_FLASH_SYSINFOH			EQU	CONST_FLASH_Block01;2EH						; ESAMϵͳ��Ϣ�ļ�,LEN = 38 BYTE
CONST_FLASH_SYSINFOL			EQU	00H

CONST_FLASH_0002H			EQU	CONST_FLASH_Block01;2EH						; �û���0002,LEN = 4 BYTE
CONST_FLASH_0002L			EQU	CONST_FLASH_SYSINFOL + CONST_Flash_SysinfoLen

CONST_FLASH_0012H			EQU	CONST_FLASH_Block01;2EH						; �û���0012,LEN = 24 BYTE
CONST_FLASH_0012L			EQU	CONST_FLASH_0002L + CONST_Flash_0002Len

CONST_FLASH_0015H			EQU	CONST_FLASH_Block01;2EH						; �û���0015,LEN = 33 BYTE
CONST_FLASH_0015L			EQU	CONST_FLASH_0012L + CONST_Flash_0012Len

CONST_FLASH_0019H			EQU	CONST_FLASH_Block01;2EH						; �û���0019,LEN = 43 BYTE	
CONST_FLASH_0019L			EQU	CONST_FLASH_0015L + CONST_Flash_0015Len
	
;CONST_FLASH_01BlockH			EQU	6EH;2EH						; MF����1������
;CONST_FLASH_01BlockL			EQU	CONST_FLASH_0019L + CONST_Flash_0019Len
	
;CONST_FLASH_04BlockH			EQU	6EH;2EH
;CONST_FLASH_04BlockL			EQU	CONST_FLASH_01BlockL + 16			;MF����4������
	
;CONST_FLASH_10BlockH			EQU	6EH;2EH
;CONST_FLASH_10BlockL			EQU	CONST_FLASH_04BlockL + 16			;MF����16������
	
CONST_FLASH_LASTCARDH			EQU	CONST_FLASH_Block01;2EH						;��һ�β忨����
CONST_FLASH_LASTCARDL			EQU	CONST_FLASH_0019L + CONST_Flash_0019Len		;CONST_FLASH_10BlockL + 16
	
;CONST_FLASH_SYSPARAMH			EQU	6EH;2EH				;ϵͳ����
;CONST_FLASH_SYSPARAML			EQU	CONST_FLASH_LASTCARDL + 1
	
CONST_Flash_BeaconIDUnixTimeH		EQU	CONST_FLASH_Block01;2EH
CONST_Flash_BeaconIDUnixTimeL		EQU	CONST_FLASH_LASTCARDL + 1	; 8 byte ����ID��unixtimeʱ��
	
CONST_FALSH_PREFlagH			EQU	CONST_FLASH_Block01;2EH
CONST_FALSH_PREFlagL			EQU	CONST_Flash_BeaconIDUnixTimeL + CONST_Flash_BeaconIDUnixTimeLen;1 Byte
	
CONST_FALSH_PREFlag02H			EQU	CONST_FLASH_Block01;2EH
CONST_FALSH_PREFlag02L			EQU	CONST_FALSH_PREFlagL + 1	;1	;3 Byte
	 
CONST_FALSH_PREFlag03H			EQU	CONST_FLASH_Block01;2EH
CONST_FALSH_PREFlag03L			EQU	CONST_FALSH_PREFlag02L + 1	;1	;3 Byte
	
CONST_FALSH_PowerH			EQU	CONST_FLASH_Block01;2EH
CONST_FALSH_PowerL			EQU	CONST_FALSH_PREFlag03L + 1	;1	;3 Byte
	
;CONST_FLASH_SysRstH			EQU	06CH
;CONST_FLASH_SysRstL			EQU	000H
	
CONST_FLASH_Sys0020H			EQU	6ch;064H
CONST_FLASH_Sys0020L			EQU	000H
	
CONST_FLASH_Sys0020numH			EQU	6ah;062H
CONST_FLASH_Sys0020numL			EQU	000H
	
;CONST_FLASH_SysHVH			EQU	6CH;68h;062H
;CONST_FLASH_SysHVL			EQU	000H
	
const_black_h				EQU	0ffH
const_black_l				EQU	0ffH
	
const_white_h				EQU	000H;40h				; 00h
const_white_l				EQU	031H;80h				; 00h
;/////////////////////////////////////////////////////////////////////////////////////////////////////
;(����*2)/(32*12*������)		
;CONST_SOF				EQU	22118400			; 24576000
CONST_SOF				EQU	24576000			; ��ǰ��Ƶ����Ƶ��
;//////////////////////////////////////// PPS ���� ���� ///////////////////////////////////////////////
CONST_PPS_9600				EQU	10H				
CONST_PPS_38400				EQU	13H
CONST_PPS_115200			EQU	18H
CONST_PPS_230000			EQU	96H
;//////////////////////////////////////// ���� ���� ���� ///////////////////////////////////////////////
	
CONST_BAUD_9600				EQU	00				; �����ʱ���
CONST_BAUD_38400			EQU	01
CONST_BAUD_115200			EQU	02
CONST_BAUD_115200PC			EQU	03
CONST_BAUD_230000			EQU	04
CONST_BAUD_38400PC			EQU	5
CONST_BAUD_9600PC			EQU	06				; �����ʱ���
	
;��24.576M�´��ڵ�һ���ֽ��趨ΪҪ����100MS = CONST_SOF/(10*(FF*FF) = 38 = 26H
CONST_SOFTFIRSTSCANTIME			EQU	16;8;32;16;8;10H	; 10h	;10h	;10H;0dH;10H	;  26H
CONST_SOFTFIRSTSCANTIMEXX		EQU	0FFH	; ESAM���ǳ���ָ��Ӵ�����ʱ������[��80 E4ָ��]
CONST_SOFTSECOND			EQU	070H	; 10H	;  �����յڶ����ֽڽ���ʱ���޳� CONST_SOFTSECOND*255������
CONST_HANDSECOND			EQU	15H	; 01AH[��9600�����£�Ҫ�ſ���1AH];Ӳ���յڶ����ֽڽ���ʱ���޳� CONST_HANDSECOND*255������
						
CONST_SOFTBYTESP			EQU	20;50;4	;�����ڷ��ͳ����ֽڼ�������_FUN_LIB_DELAYSIMPLAY�������ʹ��
;//////////////////////////////////////// ������ ���� ���� ///////////////////////////////////////////////
;CONST_BAUD_FULL9600			EQU	637	;2560
;CONST_BAUD_HALF9600			EQU	317	;2560
;CONST_BAUD_FULL9600			EQU	576	;2304
;CONST_BAUD_HALF9600			EQU	285	;1152
;CONST_BAUD_FULL9600			EQU	76	;2304
;CONST_BAUD_HALF9600			EQU	85	;1152
;CONST_BAUD_FULL38400			EQU	157	;640
;CONST_BAUD_HALF38400			EQU	77	;213
;CONST_BAUD_FULL38400			EQU	141	;576
;CONST_BAUD_HALF38400			EQU	69	;288
;CONST_BAUD_FULL115200			EQU	50	;213 ÿλ��һ��2�����壬������У���ֱ�ӻ�����ʱ����
;CONST_BAUD_HALF115200			EQU	21	;213 ÿλ��һ��2�����壬������У���ֱ�ӻ�����ʱ����
;CONST_BAUD_FULL115200			EQU	45 	;192 ÿλ��һ��2�����壬������У���ֱ�ӻ�����ʱ����
;CONST_BAUD_HALF115200			EQU	21 	;96  ÿλ��һ��2�����壬������У���ֱ�ӻ�����ʱ����
	
CONST_BAUD_FULL9600			EQU	179	;[(24576000/9600)*(3.58/6)-12]/4-200=[2560*(3.59/6)-12]/4-250=(1527-12)/4-200=378.75=379-200=179
CONST_BAUD_HALF9600			EQU	88	;[(24576000/9600/2)*(3.58/6)-12]/4-100=[2560*(3.59/6)-12]/4=(763-12)/4-100=187.75=188-100=88

CONST_BAUD_FULL38400			EQU	93	;[(24576000/38400)*(3.58/6)-12]/4= [640 * (3.59/6)-12]/4 = (382-12)/4=92.5=93
CONST_BAUD_HALF38400			EQU	45	;[(24576000/38400/2)*(3.58/6)-12]/4= [320 * (3.59/6)-12]/4 = (191-12)/4=44.75=45

CONST_BAUD_FULL115200			EQU	29	;[(24576000/115200)*(3.58/6)-12]/4=[213*(3.58/6)-12]/4=(127-12)/4=28.75=29
CONST_BAUD_HALF115200			EQU	13;	;[(24576000/115200/2)*(3.58/6)-12]/4=[115.5*(3.58/6)-12]/4=(64-12)/4=13

CONST_BAUD_FULL230000			EQU	15;13	;[(24576000/230000/2)*(3.58/6)]/4 = 64/4 = 16
CONST_BAUD_HALF230000			EQU	8;5 	;[(24576000/230000/2)*(3.58/6)]/4=[115.5*(3.58/6)]/4=32/4=8
	
CONST_BAUD_CURRENTBITFULL		EQU	CONST_BAUD_FULL9600
CONST_BAUD_CURRENTBITHALF		EQU	CONST_BAUD_HALF9600
;CONST_BAUD_BITHALF12			EQU	CONST_BAUD_CURRENTBITHALF - 3
;CONST_BAUD_BITFULL8			EQU	CONST_BAUD_CURRENTBITFULL - 2
;CONST_BAUD_BITFULL12			EQU	CONST_BAUD_CURRENTBITFULL - 3
;CONST_BAUD_BITFULL20			EQU	CONST_BAUD_CURRENTBITFULL - 5
;CONST_BAUD_BITFULL28			EQU	CONST_BAUD_CURRENTBITFULL - 7
	
CONST_BAUD_BITHALF12			EQU	3 + 9
CONST_BAUD_BITFULL8			EQU	2 + 9
CONST_BAUD_BITFULL12			EQU	3 + 9
CONST_BAUD_BITFULL20			EQU	5 + 9
CONST_BAUD_BITFULL28			EQU	7 + 9
	
;////////////////////////////////////////  Ӳ���� ���� ���� ///////////////////////////////////////////////
;CONST_BAUD_HAND115200			EQU	0FFH;(256 - CONST_SOF/(192*115200))	;
;CONST_BAUD_HAND38400			EQU	0FDH;(256 - (CONST_SOF/(192*38400)))	;
;CONST_BAUD_HAND9600			EQU	0F4H;(256 - CONST_SOF/(192*9600))	;

CONST_BAUD_HAND230000			EQU	252	;0FCH	24.576x1000000/(230000x6/3.58=)/16 = 4 = F8H
CONST_BAUD_HAND115200PC			EQU	243	;243	;24.576 / 0F3H	;24576000 / 32179 = 764 / 16 = 47.7 = 48 = D0H
CONST_BAUD_HAND115200			EQU	248	;0F8H	;24.576x1000000/(115200x6/3.58=193073)/16 = 8 = F8H		
CONST_BAUD_HAND38400pc			EQU	216	;0E8H	;24.576x1000000/(38400x6/3.58=64358)/16 = 24 = E8H
CONST_BAUD_HAND38400			EQU	233	;0E8H	;24.576x1000000/(38400x6/3.58=64358)/16 = 24 = E8H
CONST_BAUD_HAND9600pc			EQU	96	;0A1H	;24.576x1000000/(9600x6/3.58=16089)/16 = 95 = A1H		

CONST_BAUD_HAND9600			EQU	163	;0A1H	;24.576x1000000/(9600x6/3.58=16089)/16 = 95 = A1H		

;24.576x1000000/(38400x9.6/3.58=102972)/16=15 = f1
;24.576x1000000/(9600x9.6/3.58=25743)/16=60 = c4h
;24.576x1000000/(230000x6/3.58=385475)/16=4 = fch

;////////////////////////////////////////  ָ� ///////////////////////////////////////////////
;LL C2H LH 32H
;ML 62H MH 12H
;HL 32H HH 12H
	
CONST_ACT_L				EQU	1
CONST_ACT_M				EQU	2
CONST_ACT_H				EQU	3
	
CONST_ACT_V				EQU	CONST_ACT_M
	
CONST_ACT_L_L				EQU	0ah;0C2H
CONST_ACT_L_H				EQU	06h;032H
	
CONST_ACT_M_L				EQU	06h;062H
CONST_ACT_M_H				EQU	00h;012H
	
CONST_ACT_H_L				EQU	00h;032H
CONST_ACT_H_H				EQU	01h;012H

