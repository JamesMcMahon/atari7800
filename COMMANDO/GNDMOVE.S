
	.include	"maria.s"

	.title		"Sample Atari 7800 "
	.subttl		"zero page declarations"

ROM	=	$F000	; start of ROM cart
ROMDATA	=	$E000
COL	=	40
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.org	$40

INDPT1:		.ds.w	1
INDPT2: 	.ds.w	1
INDPT3:		.ds.w	1

v1fBB:		.ds.b	1	;save .a in outchar
v1fBC:		.ds.b	1	;save .x in outchar
v1fBD:		.ds.b	1	;save .y in outchar
v1fBE:		.ds.b	1	;loop counter in outchar

v1fC0:		.ds.b	1	;temp var used in subrk
CBTMP:		.DS.B	1
VALUE:		.DS.B	1
COUNT:		.ds.b	1
sdppl:		.ds.b	1	;shadow of display list list
sdpph:		.ds.b	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.subttl		"ram subroutines and display list data"
	.org	RAM3

dllist:	ds.b	60
filler:  ds.b	7
line1:	ds.b	12
line2:	ds.b	12
line3:	ds.b	12
line4:	ds.b	12
line5:	ds.b	12
line6:	ds.b	12
line7:	ds.b	12
line8:	ds.b	12
line9:	ds.b	12
line10:	ds.b	12
line11:	ds.b	12
line12:	ds.b	12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.ORG	$2400
SCREEN:
RW1:	DS.B	COL
RW2:	DS.B	COL
RW3:	DS.B	COL
RW4:	DS.B	COL
RW5:	DS.B	COL
RW6:	DS.B	COL
RW7:	DS.B	COL
RW8:	DS.B	COL
RW9:	DS.B	COL
RW10:	DS.B	COL
RW11:	DS.B	COL
RW12:	DS.B	COL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.ORG	ROMDATA+$0F00
	.DC.B	$00
	.DC.B	$00
	.DC.B	$F0
	.DC.B	$01
	.ORG	ROMDATA+$0E00
	.DC.B	$FF
	.DC.B	$00
	.DC.B	$F0
	.DC.B	$01
	.ORG	ROMDATA+$0D00
	.DC.B	$00
	.DC.B	$00
	.DC.B	$F0
	.DC.B	$01
	.ORG	ROMDATA+$0C00
	.DC.B	$7F
	.DC.B	$00
	.DC.B	$F0
	.DC.B	$01
	.ORG	ROMDATA+$0B00
	.DC.B	$00
	.DC.B	$00
	.DC.B	$F0
	.DC.B	$01
	.ORG	ROMDATA+$0A00
	.DC.B	$3F
	.DC.B	$00
	.DC.B	$50
	.DC.B	$01
	.ORG	ROMDATA+$0900
	.DC.B	$00
	.DC.B	$00
	.DC.B	$50
	.DC.B	$01
	.ORG	ROMDATA+$0800
	.DC.B	$1F
	.DC.B	$00
	.DC.B	$A0
	.DC.B	$01
	.ORG	ROMDATA+$0700
	.DC.B	$00
	.DC.B	$00
	.DC.B	$A0
	.DC.B	$01
	.ORG	ROMDATA+$0600
	.DC.B	$0F
	.DC.B	$00
	.DC.B	$AA
	.DC.B	$01
	.ORG	ROMDATA+$0500
	.DC.B	$00
	.DC.B	$C3
	.DC.B	$AA
	.DC.B	$01
	.ORG	ROMDATA+$0400
	.DC.B	$07
	.DC.B	$C3
	.DC.B	$54
	.DC.B	$01
	.ORG	ROMDATA+$0300
	.DC.B	$00
	.DC.B	$41
	.DC.B	$55
	.DC.B	$09
	.ORG	ROMDATA+$0200
	.DC.B	$03
	.DC.B	$41
	.DC.B	$55
	.DC.B	$09
	.ORG	ROMDATA+$0100
	.DC.B	$00
	.DC.B	$82
	.DC.B	$F0
	.DC.B	$09
	.ORG	ROMDATA+$0000
DATA4:
	.DC.B	$01
DATA3:
	.DC.B	$82
DATA2:
	.DC.B	$82
DATA1:
	.DC.B	$09

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.org	ROM

	display		0,0,0,7,filler
	display		0,0,0,7,filler
	display		0,0,0,7,filler
	display		0,0,0,0,filler
	display		0,0,0,15,line1
	display		0,0,0,15,line2
	display		0,0,0,15,line3
	display		0,0,0,15,line4
	display		0,0,0,15,line5
	display		0,0,0,15,line6
	display		0,0,0,15,line7
	display		0,0,0,15,line8
	display		0,0,0,15,line9
	display		0,0,0,15,line10
	display		0,0,0,15,line11
	display		0,0,0,15,line12
	display		0,0,0,7,filler
	display		0,0,0,7,filler
	display		0,0,0,7,filler
	display		0,0,0,1,filler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.subttl		"display lists"
;here are the display lists referenced in the display list list

;filler
	xheader		RAM1,0,0,0,0,0	;address,palette,width,hpos
	nullhdr
;line1
	xheader	RW1,0,20,0,0,1
	xheader RW1+(COL/2),0,20,80,0,1	
	nullhdr
;line2
	xheader	RW2,0,20,0,0,1
	xheader RW2+(COL/2),0,20,80,0,1	
	nullhdr
;line3
	xheader	RW3,0,20,0,0,1
	xheader RW3+(COL/2),0,20,80,0,1	
	nullhdr
;line4
	xheader	RW4,0,20,0,0,1
	xheader RW4+(COL/2),0,20,80,0,1	
	nullhdr
;line5
	xheader	RW5,0,20,0,0,1
	xheader RW5+(COL/2),0,20,80,0,1	
	nullhdr
;line6
	xheader	RW6,0,20,0,0,1
	xheader RW6+(COL/2),0,20,80,0,1	
	nullhdr
;line7
	xheader	RW7,0,20,0,0,1
	xheader RW7+(COL/2),0,20,80,0,1	
	nullhdr
;line8
	xheader	RW8,0,20,0,0,1
	xheader RW8+(COL/2),0,20,80,0,1	
	nullhdr
;line9
	xheader	RW9,0,20,0,0,1
	xheader RW9+(COL/2),0,20,80,0,1	
	nullhdr
;line10
	xheader	RW10,0,20,0,0,1
	xheader RW10+(COL/2),0,20,80,0,1	
	nullhdr 
;line11
	xheader	RW11,0,20,0,0,1
	xheader RW11+(COL/2),0,20,80,0,1	
	nullhdr
;line12
	xheader	RW12,0,20,0,0,1
	xheader RW12+(COL/2),0,20,80,0,1	
	nullhdr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	.subttl		"main program"
; place for IRQ and NMI to attach
dummy:
	rti

main:		
	sei
	cld

	ldx	#$FF	;init stack
 	txs

	lda	#$7
;	sta	PTCTRL

	lda	#$7f
;	sta	CTRL

	LDA	#$E0
	STA	CHBASE

	inx
loop:
;move display list list to RAM

	lda	ROM,x
	sta	RAM3,x

	lda	ROM+$100,x
	sta	RAM3+$100,x

	inx
 	bne	loop

main30:
	bit	MSTAT	;Vblank?
	bmi	main30	;wait while it is on...
main32:
	bit	MSTAT 	;Vblank?
	bpl	main32	;wait until it comes back...

	dppload dllist		;init display list list.

	screen	0,2,0,0,1,2	;Maria setups:
				;0=normal color.
				;2=Normal DMA.
				;0=single byte wide characters.
				;1=background colored border.
				;0=transparency mode.
				;3=320 a or c mode.
	sta	VALUE	

	LDA	#$0F
	STA	COUNT
	
	lda	#$78
	sta	BKGRND		;maria background color register

	LDA	#$00
	STA	P0C1

	lda	#$0E
	sta	P0C2		;maria pallette 0 - color 2

	LDA	#$00
	STA	P0C3


	JSR 	CLEAR
; INIT 2 BUTTON
 	LDA	#$14
 	STA	CTLSWB
	LDA	#0
	STA	CTLSWA
;	STA	$0001
	STA	SWCHB
main40:	
main42:
	bit	MSTAT	;Vblank?
	bmi	main42	;wait while it is on...
main44:
	bit	MSTAT 	;Vblank?
	bpl	main44	;wait until it comes back...

	LDA	INPT0
	BMI	DOIT

	LDA	INPT1
	BMI	DOIT

	LDA	INPT2
	BMI	DOIT

	LDA	INPT3
	BMI	DOIT

	LDA	#$0
;	STA	BKGRND
	JMP	OVER

DOIT:	LDA	#$0E
;	STA	BKGRND

OVER:	LDA	SWCHB
	AND	#PAUSE
	BNE	main40

	DEC	COUNT
	BNE	main40

	LDA	#$0F
	STA	COUNT
	LDA	VALUE
	EOR	#$04
	STA	VALUE
;	STA	CTRL
	jmp	main40

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	SET-UP SCREEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CLEAR:
	LDA	#$00
	LDX	#$00
CLEAR10:
	STA	SCREEN,X
	STA	SCREEN+$100,X
	INX
	BNE	CLEAR10

	RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org	$FFF8

	.dc.w	$F7FF
	.dc.w	dummy	;NMI
	.dc.w	main	;RESET
	.dc.w	dummy	;IRQ
