	.6502
	.SUBTTL	"MARIA EQUATES -- ATARI CONFIDENTIAL"
;************************************************************************
;	THIS DOCUMENT CONTAINS CONFIDENTIAL PROPRIETARY INFORMATION	*
;	OF ATARI WHICH MAY NOT BE COPIED, DISCLOSED, OR USED EXCEPT	*
;	AS EXPRESSLY AUTHORIZED IN WRITING BY ATARI.               	*
;************************************************************************
;
;	MY MEMORY MAP USAGE OF THE 3600
;
;	00-1F		TIA REGISTERS
;	20-3F		MARIA REGISTERS
;	40-FF		ZERO PAGE RAM
;	100-13F		SHADOW OF TIA AND MARIA REGISTERS -- USED FOR 
;			PUSHING ACCUMULATOR ONTO REGISTERS
;	140-1FF		RAM (STACK) -- SHADOW OF 40-FF
;	200-27F		NOT USED
;	280-2FF		PIA PORTS AND TIMERS
;	300-17FF	NOT USED
;	1800-203F	RAM
;	2040-20FF	SHADOW OF ZERO PAGE RAM
;	2100-213F	RAM
;	2140-21FF	SHADOW OF STACK RAM
;	2200-27FF	RAM
;	2800-3FFF	DUPLICATION OF ADDRESS SPACE 2000-27FF
;	4000-FF7F	UNUSED ADDRESS SPACE
;	FF80-FFF9	RESERVED FOR ENCRYPTION
;	FFFA-FFFF	6502 VECTORS

TIA	=	$00	;BASE ADDRESS FOR TIA CHIP

PTCTRL	=	$01	;INPUT PORT CONTROL ("VBLANK" IN TIA )
INPT0	=	$08	;PADDLE CONTROL INPUT 0
INPT1	=	$09	;PADDLE CONTROL INPUT 1
INPT2	=	$0A	;PADDLE CONTROL INPUT 2
INPT3	=	$0B	;PADDLE CONTROL INPUT 3
INPT4	=	$0C	;PLAYER 0 FIRE BUTTON INPUT
INPT5	=	$0D	;PLAYER 1 FIRE BUTTON INPUT
AUDC0	=	$15	;AUDIO CONTROL CHANNEL 0
AUDC1	=	$16	;AUDIO CONTROL CHANNEL 1
AUDF0	=	$17	;AUDIO FREQUENCY CHANNEL 0
AUDF1	=	$18	;AUDIO FREQUENCY CHANNEL 1
AUDV0	=	$19	;AUDIO VOLUME CHANNEL 0
AUDV1	=	$1A	;AUDIO VOLUME CHANNEL 1

;
;******************************************************************************
;

MARIA	=	$20	;BASE ADDRESS FOR MARIA CHIP

BKGRND	=	$20	;BACKGROUND COLOR
P0C1	=	$21	;PALETTE 0 - COLOR 1
P0C2	=	$22	;          - COLOR 2
P0C3	=	$23	;          - COLOR 3
WSYNC	=	$24	;WAIT FOR SYNC
P1C1	=	$25	;PALETTE 1 - COLOR 1
P1C2	=	$26	;          - COLOR 2
P1C3	=	$27	;          - COLOR 3
MSTAT	=	$28	;MARIA STATUS
P2C1	=	$29	;PALETTE 2 - COLOR 1
P2C2	=	$2A	;          - COLOR 2
P2C3	=	$2B	;          - COLOR 3
DPPH	=	$2C	;DISPLAY LIST LIST POINT HIGH BYTE
P3C1	=	$2D	;PALETTE 3 - COLOR 1
P3C2	=	$2E	;          - COLOR 2
P3C3	=	$2F	;          - COLOR 3
DPPL	=	$30	;DISPLAY LIST LIST POINT LOW BYTE
P4C1	=	$31	;PALETTE 4 - COLOR 1
P4C2	=	$32	;          - COLOR 2
P4C3	=	$33	;          - COLOR 3
CHBASE	=	$34	;CHARACTER BASE ADDRESS
P5C1	=	$35	;PALETTE 5 - COLOR 1
P5C2	=	$36	;          - COLOR 2
P5C3	=	$37	;          - COLOR 3
OFFSET	=	$38	;FOR FUTURE EXPANSION HERE - STORE ZER0 HERE
P6C1	=	$39	;PALETTE 6 - COLOR 1
P6C2	=	$3A	;          - COLOR 2
P6C3	=	$3B	;          - COLOR 3
CTRL	=	$3C	;MARIA CONTROL REGISTER
P7C1	=	$3D	;PALETTE 7 - COLOR 1
P7C2	=	$3E	;          - COLOR 2
P7C3	=	$3F	;          - COLOR 3

;
; PIA and TIMER (6532) locations
;

SWCHA	=	$0280	;player	and player 1 joysticks
CTLSWA	=	$0281	;I/O CONTROL FOR SWCHA

RESET	=	1	;bits for consle switches
SELECT	=	2
PAUSE	=	8
SWCHB	=	$0282	;console switches
CTLSWB	=	$0283	;I/O CONTROL FOR SWCHB

RAM1	=	$1800	;FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
RAM2	=	$2100	;FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
RAM3	=	$2200	;FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
R1SIZE	=	($2040-RAM1)	;SIZE OF THE RAM1 BLOCK
R2SIZE	=	($2140-RAM2)	;SIZE OF THE RAM2 BLOCK
R3SIZE	=	($2800-RAM3)	;SIZE OF THE RAM3 BLOCK

	.subttl	"system macros 7800"
;********************************************************
;	MARIA MACROS FOR EASIER GRAPHICS CONSTRUCTION	*
;********************************************************

;
;this macro constructs a 4 byte header for display lists
;
	.macro	header	address,palette,width,hpos
	dc.b	\address & $ff
	dc.b	(\palette*$20) | ($1f & -\width)
	dc.b	\address >> 8
	dc.b	\hpos
	.endm
;
;this macro constructs a 5 byte header for display lists
;
	.macro	xheader	address,palette,width,hpos,wm,ind

	dc.b	\address & $ff
	dc.b	((\wm*$80) | $40 | (\ind*$20))
	dc.b	\address >> 8
	dc.b	((\palette*$20) | ($1F & -\width))
	dc.b	\hpos
	.endm

;
;this macro constructs a end-of-display-list header
;
	.macro	nullhdr

	dc.b	0,0
	.endm

;
;this macro constructs a display list entry for the display list list
;
	.macro	display	dli,h16,h8,offset,address

	dc.b	((\dli*$80) | (\h16*$40) | (\h8*$20) | \offset)
	dc.b	\address >> 8
	dc.b	\address & $ff
	.endm

;
;this macro loads a palette register with a color
;
	.macro	paint	palnum,colornum,color,lum

	lda	#(\color*$10) | \lum
	sta	\bkgrnd | ((\palnum*4) | (\colornum))
	.endm

;
;this macro writes to the crtl register
;
ckoff	=	$0	;normal color
ckon	=	$1	;kill the color

dmaoff	=	$3	;turn off dma
dmaon	=	$2	;normal dma

char1b	=	$0	;one byte character definition
char2b	=	$1	;two byte character definition

bcoff	=	$0	;black border
bcback	=	$1	;background colored border

kangoff	=	$0	;transparency
kangon	=	$1	;"kangaroo" mode : no transparency!

mode1	=	$0	;160x2 or 160x4 modes
modebd	=	$2	;320b or 320d modes
modeac	=	$3	;320a or 320c modes

	.macro	screen	ck,dma,cw,bc,km,mode
	lda	#((\ck*$80) | (\dma*$20) | (\cw*$10) | (\bc*8) | (\km*4)|\mode)
	sta	CTRL
	.endm

	.macro	dppload	adr
	lda	#\adr & $ff
	sta	DPPL
	sta	sdppl
	lda	#\adr >> 8
	sta	DPPH
	sta	sdpph
	.endm

;********************************************************
;	end of the system macros definitions		*
;********************************************************

