
	.include	"maria.s"

	.title		"Sample Atari 7800 "
	.subttl		"zero page declarations"

ROM	=	$F000	; start of ROM cart
ROMDATA	=	$E000

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
filler:  ds.b	6
line1:	ds.b	7
line2:	ds.b	7
line3:	ds.b	7
line4:	ds.b	7
line5:	ds.b	7
line6:	ds.b	7
line7:	ds.b	7
line8:	ds.b	7
line9:	ds.b	7
line10:	ds.b	7
line11:	ds.b	7
line12:	ds.b	7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.ORG	ROMDATA+$0F00
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0E00
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0D00
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0C00
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0B00
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0A00
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0900
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0800
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0700
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0600
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0500
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0400
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0300
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0200
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0100
	.DC.B	$FF
	.DC.B	$0F
	.DC.B	$F0
	.DC.B	$00
	.ORG	ROMDATA+$0000
DATA4:
	.DC.B	$FF
DATA3:
	.DC.B	$0F
DATA2:
	.DC.B	$F0
DATA1:
	.DC.B	$00

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
	header		RAM1,0,0,0	;address,palette,width,hpos
	nullhdr
;line1
	xheader	DATA1,0,1,0,1,0	
	nullhdr

;line2
	xheader	DATA2,0,1,8,1,0
	nullhdr
;line3
	xheader	DATA3,0,1,16,1,0
	nullhdr
;line4
	xheader	DATA4,0,1,24,1,0
	nullhdr
;line5
	xheader	DATA1,0,1,32,1,0	
	nullhdr
;line6
	xheader	DATA2,0,1,40,1,0
	nullhdr
;line7
	xheader	DATA3,0,1,48,1,0
	nullhdr
;line8
	xheader	DATA4,0,1,56,1,0
	nullhdr
;line9
	xheader	DATA1,0,1,64,1,0	
	nullhdr
;line10
	xheader	DATA2,0,1,72,1,0
	nullhdr 
;line11
	xheader	DATA3,0,1,80,1,0
	nullhdr
;line12
	xheader	DATA4,0,1,90,1,0
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
	sta	CTRL

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

	screen	0,2,0,1,1,2	;Maria setups:
				;0=normal color.
				;2=Normal DMA.
				;0=single byte wide characters.
				;1=background colored border.
				;0=transparency mode.
				;3=320 a or c mode.
	sta	VALUE	

	LDA	#$0F
	STA	COUNT
	
	lda	#$22
	sta	BKGRND		;maria background color register

	LDA	#$0E
	STA	P0C1

	lda	#$00
	sta	P0C2		;maria pallette 0 - color 2

	LDA	#$D4
	STA	P0C3

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
	STA	CTRL
	jmp	main40

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org	$FFF8

	.dc.w	$F7FF
	.dc.w	dummy	;NMI
	.dc.w	main	;RESET
	.dc.w	dummy	;IRQ
