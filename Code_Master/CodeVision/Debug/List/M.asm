
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R4
	.DEF _i_msb=R5
	.DEF _j=R6
	.DEF _j_msb=R7
	.DEF _pressed_key_integer=R9
	.DEF _ignore=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0xD:
	.DB  0xF,0x0,0xE,0xD,0x1,0x2,0x3,0xC
	.DB  0x4,0x5,0x6,0xB,0x7,0x8,0x9,0xA
_0x0:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x50,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x3A,0x0
	.DB  0x53,0x79,0x73,0x74,0x65,0x6D,0x20,0x53
	.DB  0x74,0x61,0x72,0x74,0x65,0x64,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x10
	.DW  _table
	.DW  _0xD*2

	.DW  0x10
	.DW  _0x36
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0x36+16
	.DW  _0x0*2+16

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <mlcd_portd.h>
;#include <io.h>
;#include <delay.h>
;
;#define LCD_Dir  DDRD			/* Define LCD data port direction */
;#define LCD_Port PORTD			/* Define LCD data port */
;#define RS 0					/* Define Register Select pin */
;#define EN 1 					/* Define Enable signal pin */
;
;void LCD_Command(unsigned char cmnd) {
; 0000 0003 void LCD_Command(unsigned char cmnd) {

	.CSEG
_LCD_Command:
; .FSTART _LCD_Command
;    LCD_Port = (LCD_Port & 0x0F) | (cmnd & 0xF0); /* sending upper nibble */
	CALL SUBOPT_0x0
;	cmnd -> Y+0
;	LCD_Port &= ~ (1<<RS);		/* RS=0, command reg. */
	CBI  0x12,0
;	LCD_Port |= (1<<EN);		/* Enable pulse */
	RJMP _0x20A0005
;	delay_us(1);
;	LCD_Port &= ~ (1<<EN);
;
;	delay_us(200);
;
;	LCD_Port = (LCD_Port & 0x0F) | (cmnd << 4);  /* sending lower nibble */
;	LCD_Port |= (1<<EN);
;	delay_us(1);
;	LCD_Port &= ~ (1<<EN);
;	delay_ms(2);
;}
; .FEND
;
;void LCD_Char(unsigned char data) {
_LCD_Char:
; .FSTART _LCD_Char
;	LCD_Port = (LCD_Port & 0x0F) | (data & 0xF0); /* sending upper nibble */
	CALL SUBOPT_0x0
;	data -> Y+0
;	LCD_Port |= (1<<RS);						  /* RS=1, data reg. */
	SBI  0x12,0
;	LCD_Port|= (1<<EN);
_0x20A0005:
	SBI  0x12,1
;	delay_us(1);
	__DELAY_USB 3
;	LCD_Port &= ~ (1<<EN);
	CBI  0x12,1
;
;	delay_us(200);
	__DELAY_USW 400
;
;	LCD_Port = (LCD_Port & 0x0F) | (data << 4); /* sending lower nibble */
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	OUT  0x12,R30
;	LCD_Port |= (1<<EN);
	SBI  0x12,1
;	delay_us(1);
	__DELAY_USB 3
;	LCD_Port &= ~ (1<<EN);
	CBI  0x12,1
;	delay_ms(2);
	CALL SUBOPT_0x1
;}
	ADIW R28,1
	RET
; .FEND
;
;void LCD_Init (void) {				/* LCD Initialize function */
_LCD_Init:
; .FSTART _LCD_Init
;	delay_ms(20);					/* LCD Power ON delay always >15ms */
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
;
;	LCD_Command(0x02);				/* send for 4 bit initialization of LCD  */
	LDI  R26,LOW(2)
	RCALL _LCD_Command
;	LCD_Command(0x28);              /* 2 line, 5*7 matrix in 4-bit mode */
	LDI  R26,LOW(40)
	RCALL _LCD_Command
;	LCD_Command(0x0c);              /* Display on cursor off*/
	LDI  R26,LOW(12)
	RCALL _LCD_Command
;	LCD_Command(0x06);              /* Increment cursor (shift cursor to right)*/
	LDI  R26,LOW(6)
	RCALL _LCD_Command
;	LCD_Command(0x01);              /* Clear display screen*/
	LDI  R26,LOW(1)
	RCALL _LCD_Command
;	delay_ms(2);
	CALL SUBOPT_0x1
;}
	RET
; .FEND
;
;void LCD_String (char *str)	{		/* Send string to LCD function */
_LCD_String:
; .FSTART _LCD_String
;	int i;
;	for(i=0;str[i]!=0;i++) {		/* Send each char of string till the NULL */
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x4:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BREQ _0x5
;		LCD_Char (str[i]);
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _LCD_Char
;	}
	__ADDWRN 16,17,1
	RJMP _0x4
_0x5:
;}
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void LCD_String_xy (char row, char pos, char *str) {	/* Send string to LCD with xy position */
;	if (row == 0 && pos<16)
;	row -> Y+3
;	pos -> Y+2
;	*str -> Y+0
;	LCD_Command((pos & 0x0F)|0x80);						/* Command of first row and required position<16 */
;	else if (row == 1 && pos<16)
;	LCD_Command((pos & 0x0F)|0xC0);						/* Command of first row and required position<16 */
;	LCD_String(str);									/* Call LCD string function */
;}
;
;void LCD_Clear() {
_LCD_Clear:
; .FSTART _LCD_Clear
;	LCD_Command (0x01);		/* Clear display */
	LDI  R26,LOW(1)
	RCALL _LCD_Command
;	delay_ms(2);
	CALL SUBOPT_0x1
;	LCD_Command (0x80);		/* Cursor at home position */
	LDI  R26,LOW(128)
	RCALL _LCD_Command
;}
	RET
; .FEND
;#include <keypad.h>
;#include <io.h>
;#include <delay.h>
;
;#define KEY_PORT    PORTC
;#define KEY_DDR     DDRC
;#define KEY_PIN     PINC
;
;#define C1  4
;#define C2  5
;#define C3  6
;#define C4  7
;
;unsigned char table[16] = {
;15, 0, 14, 13,
;1,  2, 3,  12,
;4,  5, 6,  11,
;7,  8, 9,  10};

	.DSEG
;
;// When you want to read a PIN right after writing to PORT you should wait
;const unsigned char Delay = 5;
;
;void keypad_init(void){
; 0000 0004 void keypad_init(void){

	.CSEG
_keypad_init:
; .FSTART _keypad_init
;    KEY_DDR = 0x0f;
	LDI  R30,LOW(15)
	OUT  0x14,R30
;    KEY_PORT = 0xf0;
	LDI  R30,LOW(240)
	OUT  0x15,R30
;}
	RET
; .FEND
;
;unsigned char key_released(void) {
_key_released:
; .FSTART _key_released
;    KEY_PORT = 0xf0;
	CALL SUBOPT_0x2
;    delay_us(Delay);
;    if((KEY_PIN & 0xf0) == 0xf0)
	BREQ _0x20A0004
;        return 1;
;    else
;        return 0;
	RJMP _0x20A0003
;}
; .FEND
;
;unsigned char key_pressed(void) {
_key_pressed:
; .FSTART _key_pressed
;    KEY_PORT = 0xf0;
	CALL SUBOPT_0x2
;    delay_us(Delay);
;    if( (KEY_PIN & 0xf0) != 0xf0 ) { // User presses some key
	BREQ _0x10
;        return 1;
_0x20A0004:
	LDI  R30,LOW(1)
	RET
;    }
;    return 0;
_0x10:
_0x20A0003:
	LDI  R30,LOW(0)
	RET
;}
; .FEND
;
;unsigned char key_scan(void) {
_key_scan:
; .FSTART _key_scan
;
;    unsigned char i, key;
;    if(key_pressed()){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	key -> R16
	RCALL _key_pressed
	CPI  R30,0
	BRNE PC+2
	RJMP _0x11
;        for(i = 0; i < 4; i++){
	LDI  R17,LOW(0)
_0x13:
	CPI  R17,4
	BRSH _0x14
;            KEY_PORT = ~(1 << i);
	MOV  R30,R17
	LDI  R26,LOW(1)
	CALL __LSLB12
	COM  R30
	OUT  0x15,R30
;            delay_us(Delay);
	__DELAY_USB 13
;
;            if(((KEY_PIN >> C1) & 1) == 0)     key = table[i*4];
	IN   R30,0x13
	LDI  R31,0
	CALL __ASRW4
	ANDI R30,LOW(0x1)
	BRNE _0x15
	LDI  R30,LOW(4)
	MUL  R30,R17
	MOVW R30,R0
	SUBI R30,LOW(-_table)
	SBCI R31,HIGH(-_table)
	LD   R16,Z
;
;            if(((KEY_PIN >> C2) & 1) == 0)     key = table[i*4+1];
_0x15:
	IN   R30,0x13
	LDI  R31,0
	ASR  R31
	ROR  R30
	CALL __ASRW4
	ANDI R30,LOW(0x1)
	BRNE _0x16
	LDI  R30,LOW(4)
	MUL  R30,R17
	MOVW R30,R0
	__ADDW1MN _table,1
	LD   R16,Z
;
;            if(((KEY_PIN >> C3) & 1) == 0)     key = table[i*4+2];
_0x16:
	IN   R30,0x13
	LDI  R31,0
	CALL __ASRW2
	CALL __ASRW4
	ANDI R30,LOW(0x1)
	BRNE _0x17
	LDI  R30,LOW(4)
	MUL  R30,R17
	MOVW R30,R0
	__ADDW1MN _table,2
	LD   R16,Z
;
;            if(((KEY_PIN >> C4) & 1) == 0)     key = table[i*4+3];
_0x17:
	IN   R30,0x13
	CALL SUBOPT_0x3
	BRNE _0x18
	LDI  R30,LOW(4)
	MUL  R30,R17
	MOVW R30,R0
	__ADDW1MN _table,3
	LD   R16,Z
;        }
_0x18:
	SUBI R17,-1
	RJMP _0x13
_0x14:
;        while(!key_released());
_0x19:
	RCALL _key_released
	CPI  R30,0
	BREQ _0x19
;        return key;
	MOV  R30,R16
	RJMP _0x20A0002
;    }
;
;    else
_0x11:
;        return 255;
	LDI  R30,LOW(255)
;
;}
_0x20A0002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;#include <shtxx.h>
;#include <io.h>
;#include <delay.h>
;
;#define SHT_DDR DDRA
;#define SHT_PIN PINA
;#define SHT_PORT PORTA
;#define SHT_SCK_PIN_NO 0
;#define SHT_DATA_PIN_NO 1
;#define MEASURE_TEMP 0x03
;#define MEASURE_HUMI 0x05
;#define RESET        0x1e
;
;void sht_start(void) {
; 0000 0005 void sht_start(void) {
_sht_start:
; .FSTART _sht_start
;    SHT_DDR |= (1<<SHT_DATA_PIN_NO); // DATA is output
	SBI  0x1A,1
;
;    SHT_PORT |= (1<<SHT_DATA_PIN_NO);
	SBI  0x1B,1
;    SHT_PORT &= ~(1<<SHT_SCK_PIN_NO);
	CBI  0x1B,0
;    SHT_PORT |= (1<<SHT_SCK_PIN_NO);
	SBI  0x1B,0
;    SHT_PORT &= ~(1<<SHT_DATA_PIN_NO);
	CBI  0x1B,1
;    SHT_PORT &= ~(1<<SHT_SCK_PIN_NO);
	CBI  0x1B,0
;    SHT_PORT |= (1<<SHT_SCK_PIN_NO);
	SBI  0x1B,0
;    SHT_PORT |= (1<<SHT_DATA_PIN_NO);
	SBI  0x1B,1
;    SHT_PORT &= ~(1<<SHT_SCK_PIN_NO);
	CBI  0x1B,0
;}
	RET
; .FEND
;//##########################################################################
;
;char sht_write(unsigned char Byte) {
_sht_write:
; .FSTART _sht_write
;    unsigned char i, error = 0;
;
;    SHT_DDR |= (1<<SHT_DATA_PIN_NO); // Data is an output
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	Byte -> Y+2
;	i -> R17
;	error -> R16
	LDI  R16,0
	SBI  0x1A,1
;    delay_us(5);
	__DELAY_USB 13
;    for(i = 0x80; i > 0; i /= 2) {
	LDI  R17,LOW(128)
_0x1E:
	CPI  R17,1
	BRLO _0x1F
;        SHT_PORT &= ~(1<<SHT_SCK_PIN_NO);
	CBI  0x1B,0
;        if(i & Byte) {
	LDD  R30,Y+2
	AND  R30,R17
	BREQ _0x20
;            PORTA |= (1<<1);
	SBI  0x1B,1
;            SHT_PORT |= (1<<SHT_DATA_PIN_NO);
	SBI  0x1B,1
;        }
;        else {
	RJMP _0x21
_0x20:
;            SHT_PORT &= ~(1<<SHT_DATA_PIN_NO);
	CBI  0x1B,1
;        }
_0x21:
;        SHT_PORT |= (1<<SHT_SCK_PIN_NO);
	SBI  0x1B,0
;    }
	CALL SUBOPT_0x4
	RJMP _0x1E
_0x1F:
;    SHT_PORT &= ~(1<<SHT_SCK_PIN_NO);
	CBI  0x1B,0
;    SHT_DDR &= ~(1<<SHT_DATA_PIN_NO); // DATA is input
	CBI  0x1A,1
;    SHT_PORT |= (1<<SHT_SCK_PIN_NO);
	CALL SUBOPT_0x5
;    error = (SHT_PIN >> SHT_DATA_PIN_NO) & 1;
	MOV  R16,R30
;    SHT_PORT &= ~(1<<SHT_SCK_PIN_NO);
	RJMP _0x20A0001
;
;    return(error);
;}
; .FEND
;//###################################################
;unsigned char sht_read(unsigned char ack) {
_sht_read:
; .FSTART _sht_read
;    unsigned char i, val = 0;
;
;    SHT_DDR &= ~(1<<SHT_DATA_PIN_NO); // DATA is INPUT
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	ack -> Y+2
;	i -> R17
;	val -> R16
	LDI  R16,0
	CBI  0x1A,1
;
;    for(i = 0x80; i > 0; i /= 2) {
	LDI  R17,LOW(128)
_0x23:
	CPI  R17,1
	BRLO _0x24
;        SHT_PORT |= (1<<SHT_SCK_PIN_NO);
	CALL SUBOPT_0x5
;        if(((SHT_PIN >> SHT_DATA_PIN_NO) & 1) == 1) {
	CPI  R30,LOW(0x1)
	BRNE _0x25
;            val = val | i;
	OR   R16,R17
;        }
;        SHT_PORT &= ~(1<<SHT_SCK_PIN_NO);
_0x25:
	CBI  0x1B,0
;    }
	CALL SUBOPT_0x4
	RJMP _0x23
_0x24:
;    SHT_DDR |= (1<<SHT_DATA_PIN_NO); // DATA is output
	SBI  0x1A,1
;    if(ack == 0) {
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x26
;        SHT_PORT |= (1<<SHT_DATA_PIN_NO);
	SBI  0x1B,1
;    }
;    else {
	RJMP _0x27
_0x26:
;        SHT_PORT &= ~(1<<SHT_DATA_PIN_NO);
	CBI  0x1B,1
;    }
_0x27:
;    SHT_PORT |= (1<<SHT_SCK_PIN_NO);
	SBI  0x1B,0
;    SHT_PORT &= ~(1<<SHT_SCK_PIN_NO);
_0x20A0001:
	CBI  0x1B,0
;
;    return(val);
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
;}
; .FEND
;//########################################################
;void connection_reset(void) {
;    unsigned char i;
;    SHT_DDR |= (1<<SHT_DATA_PIN_NO);
;	i -> R17
;    SHT_PORT |= (1<<SHT_DATA_PIN_NO);
;    for (i=0;i<9;i++) {
;        SHT_PORT |= (1<<SHT_SCK_PIN_NO);
;        delay_us(2);
;        SHT_PORT &= ~(1<<SHT_SCK_PIN_NO);
;        delay_us(2);
;    }
;    SHT_PORT |= (1<<SHT_DATA_PIN_NO);
;    sht_start();
;    delay_ms(100);
;}
;//####################################################
;void sht_reset() {
;    sht_start();
;    sht_write(RESET);
;
;    delay_ms(100);
;}
;//#####################################################
;// Read the sensor value. Reg is register to read from
;unsigned int ReadSensor(int Reg) {
_ReadSensor:
; .FSTART _ReadSensor
;    unsigned char msb, lsb, crc;
;
;    sht_start();
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	Reg -> Y+4
;	msb -> R17
;	lsb -> R16
;	crc -> R19
	RCALL _sht_start
;    sht_write(Reg);
	LDD  R26,Y+4
	RCALL _sht_write
;
;    while(((SHT_PIN >> SHT_DATA_PIN_NO) & 1) == 1);
_0x2B:
	IN   R30,0x19
	LDI  R31,0
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BREQ _0x2B
;
;    msb = sht_read(1);
	LDI  R26,LOW(1)
	RCALL _sht_read
	MOV  R17,R30
;    lsb = sht_read(1);
	LDI  R26,LOW(1)
	RCALL _sht_read
	MOV  R16,R30
;    crc = sht_read(0);
	LDI  R26,LOW(0)
	RCALL _sht_read
	MOV  R19,R30
;
;    return(((unsigned short) msb << 8) | (unsigned short) lsb);
	MOV  R31,R17
	LDI  R30,LOW(0)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;}
; .FEND
;//######################################################
;float read_sensor(char humidity0temperture1) {
_read_sensor:
; .FSTART _read_sensor
;    long int income,temp;
;    float out,out0,t;
;    switch(humidity0temperture1) {
	ST   -Y,R26
	SBIW R28,20
;	humidity0temperture1 -> Y+20
;	income -> Y+16
;	temp -> Y+12
;	out -> Y+8
;	out0 -> Y+4
;	t -> Y+0
	LDD  R30,Y+20
	LDI  R31,0
;        case 0:
	SBIW R30,0
	BREQ PC+2
	RJMP _0x31
;            income = ReadSensor(MEASURE_HUMI);
	LDI  R26,LOW(5)
	CALL SUBOPT_0x6
;            out0=(-2.0468+(0.0367*income)+(-1.5955E-6*(income*income)));
	__GETD2N 0x3D1652BD
	CALL __MULF12
	__GETD2N 0xC002FEC5
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	__GETD2S 16
	CALL __MULD12
	CALL __CDF1
	__GETD2N 0xB5D624F6
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	__PUTD1S 4
;            temp=income;
	CALL SUBOPT_0x7
	__PUTD1S 12
;            delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
;            ReadSensor(MEASURE_TEMP);
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _ReadSensor
;            t = -40.1 + 0.01*income;
	CALL SUBOPT_0x7
	CALL __CDF1
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	CALL __ADDF12
	CALL __PUTD1S0
;            out=(t-25)*(0.01+0.00008*temp)+out0;
	__GETD2N 0x41C80000
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 12
	CALL __CDF1
	__GETD2N 0x38A7C5AC
	CALL __MULF12
	CALL SUBOPT_0x8
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	__GETD2S 4
	RJMP _0x5D
;            break;
;        case 1:
_0x31:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x30
;            income = ReadSensor(MEASURE_TEMP);
	LDI  R26,LOW(3)
	CALL SUBOPT_0x6
;            out = -40.1 + 0.01*income;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
_0x5D:
	CALL __ADDF12
	__PUTD1S 8
;            break;
;    }
_0x30:
;        return(out);
	__GETD1S 8
	ADIW R28,21
	RET
;}
; .FEND
;#include <stdio.h>
;#include <string.h>
;#include <stdlib.h>
;
;int i,j;
;
;// Variables for password part
;#define PASSWORD_LENGTH 4
;char password[PASSWORD_LENGTH + 1];
;char user_password[PASSWORD_LENGTH + 1];
;
;unsigned char pressed_key_integer;
;char pressed_key_ascii[8];
;
;eeprom char pas[3] = {1,2,3};
;
;// VAriable for T/C
;long int overflow_count = 0;
;
;// VAriable for SPI
;char ignore;
;
;// Variables for ADC
;float temperature;
;float humidity;
;float ldrValue;
;
;float read_adc();
;
;void main(void){
; 0000 0023 void main(void){
_main:
; .FSTART _main
; 0000 0024     // LCD initialization
; 0000 0025     DDRD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0026     LCD_Init();
	RCALL _LCD_Init
; 0000 0027 
; 0000 0028     // Keypad initialization
; 0000 0029     keypad_init();
	RCALL _keypad_init
; 0000 002A 
; 0000 002B 
; 0000 002C 
; 0000 002D     while (1) {
_0x33:
; 0000 002E         LCD_Clear();
	RCALL _LCD_Clear
; 0000 002F         LCD_String("Enter Password:");
	__POINTW2MN _0x36,0
	RCALL _LCD_String
; 0000 0030         LCD_Command(0xC0); // Go to 2nd line
	LDI  R26,LOW(192)
	RCALL _LCD_Command
; 0000 0031         for(i = 0; i < PASSWORD_LENGTH; i++) {
	CLR  R4
	CLR  R5
_0x38:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x39
; 0000 0032             do {
_0x3B:
; 0000 0033                 pressed_key_integer = key_scan();
	RCALL _key_scan
	MOV  R9,R30
; 0000 0034             } while (pressed_key_integer == 255);
	LDI  R30,LOW(255)
	CP   R30,R9
	BREQ _0x3B
; 0000 0035             // sprintf(pressed_key_ascii, "%d", pressed_key_integer);
; 0000 0036             itoa(pressed_key_integer, pressed_key_ascii);
	MOV  R30,R9
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_pressed_key_ascii)
	LDI  R27,HIGH(_pressed_key_ascii)
	CALL _itoa
; 0000 0037             LCD_String(pressed_key_ascii);
	LDI  R26,LOW(_pressed_key_ascii)
	LDI  R27,HIGH(_pressed_key_ascii)
	RCALL _LCD_String
; 0000 0038             user_password[i] = pressed_key_integer;
	MOVW R30,R4
	SUBI R30,LOW(-_user_password)
	SBCI R31,HIGH(-_user_password)
	ST   Z,R9
; 0000 0039         }
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0x38
_0x39:
; 0000 003A         LCD_Clear();
	RCALL _LCD_Clear
; 0000 003B 
; 0000 003C 
; 0000 003D 
; 0000 003E 
; 0000 003F         if(user_password[0] == 1) {
	LDS  R26,_user_password
	CPI  R26,LOW(0x1)
	BRNE _0x3D
; 0000 0040         if(user_password[1] == 2){
	__GETB2MN _user_password,1
	CPI  R26,LOW(0x2)
	BRNE _0x3E
; 0000 0041         if(user_password[2] == 3){
	__GETB2MN _user_password,2
	CPI  R26,LOW(0x3)
	BRNE _0x3F
; 0000 0042             LCD_String("System Started");
	__POINTW2MN _0x36,16
	RCALL _LCD_String
; 0000 0043             delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 0044             LCD_Clear();
	RCALL _LCD_Clear
; 0000 0045             break;
	RJMP _0x35
; 0000 0046         }
; 0000 0047         }
_0x3F:
; 0000 0048 
; 0000 0049         }
_0x3E:
; 0000 004A         else {}
_0x3D:
; 0000 004B     }
	RJMP _0x33
_0x35:
; 0000 004C 
; 0000 004D     // LDR initialization
; 0000 004E     ADMUX  |= (1 << REFS0); // ADC Voltage Reference: AVCC, cap. on AREF
	SBI  0x7,6
; 0000 004F     ADMUX  |= (0 << MUX4) | (0 << MUX3) | (0 << MUX2) | (1 << MUX1) | (0 << MUX0); // Select ADC2 Single ended as analog ...
	SBI  0x7,1
; 0000 0050     ADCSRA |= (1 << ADEN); // ADC Enable
	SBI  0x6,7
; 0000 0051     ADCSRA |= (1 << ADPS2) | (1 << ADPS1) | (0 << ADPS0); // ADC Prescalar: 64
	IN   R30,0x6
	ORI  R30,LOW(0x6)
	OUT  0x6,R30
; 0000 0052 
; 0000 0053     // SHT initialization
; 0000 0054     DDRA = (0<<DDA1) | (1<<DDA0); // Data is input and Clk is output
	LDI  R30,LOW(1)
	OUT  0x1A,R30
; 0000 0055     PORTA = (1<<PORTA1) | (0<<PORTA0); // Pull up Data
	LDI  R30,LOW(2)
	OUT  0x1B,R30
; 0000 0056 
; 0000 0057     // SPI initialization
; 0000 0058     DDRB = (1<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB2)| (1<<DDB1);
	LDI  R30,LOW(182)
	OUT  0x17,R30
; 0000 0059     PORTB = (1<<PORTB4) | (1<<PORTB2)| (1<<DDB1);
	LDI  R30,LOW(22)
	OUT  0x18,R30
; 0000 005A     SPCR |= (1<<SPE); // SPI Enable
	SBI  0xD,6
; 0000 005B     SPCR |= (0<<CPOL); // SPI Clock Polarity: Low
	IN   R30,0xD
	OUT  0xD,R30
; 0000 005C     SPCR |= (0<<CPHA); // SPI Clock Phase: Leading edge sample / Trailing Edge setup
	IN   R30,0xD
	OUT  0xD,R30
; 0000 005D     SPCR |= (1<<SPR1) | (1<<SPR0); // SPI Clock Rate: f/128 = 62.5 KHz
	IN   R30,0xD
	ORI  R30,LOW(0x3)
	OUT  0xD,R30
; 0000 005E     SPSR |= (0<<SPI2X);
	IN   R30,0xE
	OUT  0xE,R30
; 0000 005F     SPCR |= (0<<DORD); // SPI Data Order: MSB First
	IN   R30,0xD
	OUT  0xD,R30
; 0000 0060     SPCR |= (1<<MSTR); // SPI Type: Master
	SBI  0xD,4
; 0000 0061 
; 0000 0062     // T/C initialization
; 0000 0063     TCCR0 = (0<<CS02) | (1<<CS01) | (0<<CS00); // Prescaler = 8 for t/c 0
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0064     TCNT0 = 0; // Count from 0 in t/c 0
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0065     TIMSK |= (1 << TOIE0); // Enable timer over flow interrupt for t/c 0
	IN   R30,0x39
	ORI  R30,1
	OUT  0x39,R30
; 0000 0066 
; 0000 0067     #asm("sei"); // Set global interrupt flag
	sei
; 0000 0068     while(1) {
_0x41:
; 0000 0069 
; 0000 006A         // Read necessary data
; 0000 006B         temperature = read_sensor(1); // Read temperature
	LDI  R26,LOW(1)
	RCALL _read_sensor
	STS  _temperature,R30
	STS  _temperature+1,R31
	STS  _temperature+2,R22
	STS  _temperature+3,R23
; 0000 006C         humidity = read_sensor(0); // Read humidity
	LDI  R26,LOW(0)
	RCALL _read_sensor
	STS  _humidity,R30
	STS  _humidity+1,R31
	STS  _humidity+2,R22
	STS  _humidity+3,R23
; 0000 006D         ldrValue = read_adc(); // Read light intensity
	RCALL _read_adc
	CALL SUBOPT_0xA
; 0000 006E         ldrValue = (ldrValue*5)/1023; // Real voltage value
	CALL SUBOPT_0xB
	__GETD1N 0x40A00000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x447FC000
	CALL __DIVF21
	CALL SUBOPT_0xA
; 0000 006F         // ldrValue = (500*(5-ldrValue))/ldrValue; // Voltage to resistance
; 0000 0070 
; 0000 0071         // (T(t/c) = prescalar / f(micro) = 8 / 8MHz = 1microSecond)
; 0000 0072         // t/c 0 overflow happens each 2^8 * 1microSecond = 256 microSecond
; 0000 0073         // after 2 seconds t/c overflows 2 second / 256 microsecond = 7812.5 times (overflow_count = 7812)
; 0000 0074         // overflow_count * 256 + TCNT0 = 7812 * 256 + TCNT0 = 2000000 So TCNT0 = 128 = .5 * 256
; 0000 0075         // so when overflow_count = 7812 & TCNT0 = 128 the condition of if will be satisfied
; 0000 0076         if(overflow_count * 256 + TCNT0 >= 1999999) { // 2,000,000 microSecond = 2 second
	CALL SUBOPT_0xC
	__GETD2N 0x100
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	IN   R30,0x32
	LDI  R31,0
	CALL __CWD1
	CALL __ADDD21
	__CPD2N 0x1E847F
	BRGE PC+2
	RJMP _0x44
; 0000 0077             overflow_count = 0;
	LDI  R30,LOW(0)
	STS  _overflow_count,R30
	STS  _overflow_count+1,R30
	STS  _overflow_count+2,R30
	STS  _overflow_count+3,R30
; 0000 0078             TCNT0 = 0;
	OUT  0x32,R30
; 0000 0079 
; 0000 007A             // Send temperature for slave 3
; 0000 007B             PORTB &= ~(1<<PORTB1); // Select Slave #3
	CBI  0x18,1
; 0000 007C             SPDR = humidity;
	LDS  R30,_humidity
	LDS  R31,_humidity+1
	LDS  R22,_humidity+2
	LDS  R23,_humidity+3
	CALL __CFD1U
	OUT  0xF,R30
; 0000 007D             while(((SPSR >> SPIF) & 1) == 0);
_0x45:
	IN   R30,0xE
	CALL SUBOPT_0x3
	BREQ _0x45
; 0000 007E             ignore = SPDR;
	IN   R8,15
; 0000 007F             PORTB |= (1<<PORTB1); // Deselect Slave #3
	SBI  0x18,1
; 0000 0080 
; 0000 0081 
; 0000 0082 
; 0000 0083 
; 0000 0084             // Send temperature for slave 1
; 0000 0085             PORTB &= ~(1<<PORTB2); // Select Slave #1
	CBI  0x18,2
; 0000 0086             SPDR = temperature;
	LDS  R30,_temperature
	LDS  R31,_temperature+1
	LDS  R22,_temperature+2
	LDS  R23,_temperature+3
	CALL __CFD1U
	OUT  0xF,R30
; 0000 0087             while(((SPSR >> SPIF) & 1) == 0);
_0x48:
	IN   R30,0xE
	CALL SUBOPT_0x3
	BREQ _0x48
; 0000 0088             ignore = SPDR;
	IN   R8,15
; 0000 0089             PORTB |= (1<<PORTB2); // Deselect Slave #1
	SBI  0x18,2
; 0000 008A 
; 0000 008B             // Send ldrValue for slave 2
; 0000 008C             PORTB &= ~(1<<PORTB4); // Select Slave #2
	CBI  0x18,4
; 0000 008D             if(ldrValue < 0.01) {
	CALL SUBOPT_0xD
	BRSH _0x4B
; 0000 008E                 SPDR = 0;
	LDI  R30,LOW(0)
	RJMP _0x5E
; 0000 008F             }
; 0000 0090             else if(ldrValue > 0.01 && ldrValue <= 1) {
_0x4B:
	CALL SUBOPT_0xD
	BREQ PC+2
	BRCC PC+2
	RJMP _0x4E
	CALL SUBOPT_0xE
	BREQ PC+3
	BRCS PC+2
	RJMP _0x4E
	RJMP _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
; 0000 0091                 SPDR = 1;
	LDI  R30,LOW(1)
	RJMP _0x5E
; 0000 0092             }
; 0000 0093             else if(ldrValue > 1 && ldrValue <= 2 ) {
_0x4D:
	CALL SUBOPT_0xE
	BREQ PC+2
	BRCC PC+2
	RJMP _0x52
	CALL SUBOPT_0xB
	__GETD1N 0x40000000
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x52
	RJMP _0x53
_0x52:
	RJMP _0x51
_0x53:
; 0000 0094                 SPDR = 2;
	LDI  R30,LOW(2)
	RJMP _0x5E
; 0000 0095             }
; 0000 0096             else {
_0x51:
; 0000 0097                 SPDR = 3;
	LDI  R30,LOW(3)
_0x5E:
	OUT  0xF,R30
; 0000 0098             }
; 0000 0099             while(((SPSR >> SPIF) & 1) == 0);
_0x55:
	IN   R30,0xE
	CALL SUBOPT_0x3
	BREQ _0x55
; 0000 009A             ignore = SPDR;
	IN   R8,15
; 0000 009B             PORTB |= (1<<PORTB4); // Deselect Slave #2
	SBI  0x18,4
; 0000 009C         }
; 0000 009D     }
_0x44:
	RJMP _0x41
; 0000 009E }
_0x58:
	RJMP _0x58
; .FEND

	.DSEG
_0x36:
	.BYTE 0x1F
;
;// Function to read from ADC
;float read_adc(){
; 0000 00A1 float read_adc(){

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 00A2     delay_us(10); // Delay needed for the stabilization of the ADC input voltage
	__DELAY_USB 27
; 0000 00A3     ADCSRA |= (1 << ADSC); // Start the AD conversion
	SBI  0x6,6
; 0000 00A4     while ((ADCSRA & (1 << ADIF)) == 0); // Wait for the AD conversion to complete
_0x59:
	SBIS 0x6,4
	RJMP _0x59
; 0000 00A5     ADCSRA |= (1 << ADIF);
	SBI  0x6,4
; 0000 00A6     return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET
; 0000 00A7 }
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 00AA interrupt [12] void timer0_ovf_isr(void){
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00AB     overflow_count = overflow_count + 1;
	CALL SUBOPT_0xC
	__ADDD1N 1
	STS  _overflow_count,R30
	STS  _overflow_count+1,R31
	STS  _overflow_count+2,R22
	STS  _overflow_count+3,R23
; 0000 00AC }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_table:
	.BYTE 0x10
_user_password:
	.BYTE 0x5
_pressed_key_ascii:
	.BYTE 0x8
_overflow_count:
	.BYTE 0x4
_temperature:
	.BYTE 0x4
_humidity:
	.BYTE 0x4
_ldrValue:
	.BYTE 0x4
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(2)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(240)
	OUT  0x15,R30
	__DELAY_USB 13
	IN   R30,0x13
	ANDI R30,LOW(0xF0)
	CPI  R30,LOW(0xF0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDI  R31,0
	CALL __ASRW3
	CALL __ASRW4
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	SBI  0x1B,0
	IN   R30,0x19
	LDI  R31,0
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
	LDI  R27,0
	CALL _ReadSensor
	CLR  R22
	CLR  R23
	__PUTD1S 16
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__GETD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD2N 0x3C23D70A
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __MULF12
	__GETD2N 0xC2206666
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	STS  _ldrValue,R30
	STS  _ldrValue+1,R31
	STS  _ldrValue+2,R22
	STS  _ldrValue+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xB:
	LDS  R26,_ldrValue
	LDS  R27,_ldrValue+1
	LDS  R24,_ldrValue+2
	LDS  R25,_ldrValue+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDS  R30,_overflow_count
	LDS  R31,_overflow_count+1
	LDS  R22,_overflow_count+2
	LDS  R23,_overflow_count+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0xB
	__GETD1N 0x3C23D70A
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0xB
	__GETD1N 0x3F800000
	CALL __CMPF12
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
