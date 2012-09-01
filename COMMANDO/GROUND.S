
	.include	"maria.s"

	.title		"Sample Atari 7800 "
	.subttl		"zero page declarations"

ROM	=	$f000	; start of ROM cart

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
	.subttl		"ram subroutines and display list data"
	.org	RAM3

dllist:	ds.b	96
filler:  ds.b	6
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
line13:	ds.b	12
line14:	ds.b	12
line15:	ds.b	12
line16:	ds.b	12
line17:	ds.b	12
line18:	ds.b	12
line19:	ds.b	12
line20:	ds.b	12
line21:	ds.b	12
line22:	ds.b	12
line23:	ds.b	12
line24:	ds.b	12

	.subttl			"video matrix ram"
	.org	$2400

columns	=	40	;number of characters per line
SCREEN:
row1:	ds.b	columns
row2:	ds.b	columns
row3:	ds.b	columns
row4:	ds.b	columns
row5:	ds.b	columns
row6:	ds.b	columns
row7:	ds.b	columns
row8:	ds.b	columns
row9:	ds.b	columns
row10:	ds.b	columns
row11:	ds.b	columns
row12:	ds.b	columns
row13:	ds.b	columns
row14:	ds.b	columns
row15:	ds.b	columns
row16:	ds.b	columns
row17:	ds.b	columns
row18:	ds.b	columns
row19:	ds.b	columns
row20:	ds.b	columns
row21:	ds.b	columns
row22:	ds.b	columns
row23:	ds.b	columns
row24:	ds.b	columns
	.subttl			"begin ROM -- RAM routines"
	.org	ROM
; here begins the display list list

	display		0,0,0,7,filler
	display		0,0,0,7,filler
	display		0,0,0,7,filler
	display		0,0,0,0,filler
	display		0,0,0,7,line1
	display		0,0,0,7,line2
	display		0,0,0,7,line3
	display		0,0,0,7,line4
	display		0,0,0,7,line5
	display		0,0,0,7,line6
	display		0,0,0,7,line7
	display		0,0,0,7,line8
	display		0,0,0,7,line9
	display		0,0,0,7,line10
	display		0,0,0,7,line11
	display		0,0,0,7,line12
	display		0,0,0,7,line13
	display		0,0,0,7,line14
	display		0,0,0,7,line15
	display		0,0,0,7,line16
	display		0,0,0,7,line17
	display		0,0,0,7,line18
	display		0,0,0,7,line19
	display		0,0,0,7,line20
	display		0,0,0,7,line21
	display		0,0,0,7,line22
	display		0,0,0,7,line23
	display		0,0,0,7,line24
	display		0,0,0,7,filler
	display		0,0,0,7,filler
	display		0,0,0,7,filler
	display		0,0,0,1,filler
	.subttl		"display lists"
;here are the display lists referenced in the display list list

;filler
	header		RAM1,0,0,0	;address,palette,width,hpos
	nullhdr
;line1
	xheader		row1,0,20,0,0,1	;address,palette,width,hpos,wm,ind
	xheader		row1+(columns/2),0,20,80,0,1
	nullhdr

;line2
	xheader		row2,0,20,0,0,1
	xheader		row2+(columns/2),0,20,80,0,1
	nullhdr
;line3
	xheader		row3,0,20,0,0,1
	xheader		row3+(columns/2),0,20,80,0,1
	nullhdr
;line4
	xheader		row4,0,20,0,0,1
	xheader		row4+(columns/2),0,20,80,0,1
	nullhdr
;line5
	xheader		row5,0,20,0,0,1
	xheader		row5+(columns/2),0,20,80,0,1
	nullhdr
;line6
	xheader		row6,0,20,0,0,1
	xheader		row6+(columns/2),0,20,80,0,1
	nullhdr
;line7
	xheader		row7,0,20,0,0,1
	xheader		row7+(columns/2),0,20,80,0,1
	nullhdr
;line8
	xheader		row8,0,20,0,0,1
	xheader		row8+(columns/2),0,20,80,0,1
	nullhdr
;line9
	xheader		row9,0,20,0,0,1
	xheader		row9+(columns/2),0,20,80,0,1
	nullhdr
;line10
	xheader		row10,0,20,0,0,1
	xheader		row10+(columns/2),0,20,80,0,1
	nullhdr 
;line11
	xheader		row11,0,20,0,0,1
	xheader		row11+(columns/2),0,20,80,0,1
	nullhdr
;line12
	xheader		row12,0,20,0,0,1
	xheader		row12+(columns/2),0,20,80,0,1
	nullhdr
;line13
	xheader		row13,0,20,0,0,1
	xheader		row13+(columns/2),0,20,80,0,1
	nullhdr
;line14
	xheader		row14,0,20,0,0,1
	xheader		row14+(columns/2),0,20,80,0,1
	nullhdr
;line15
	xheader		row15,0,20,0,0,1
	xheader		row15+(columns/2),0,20,80,0,1
	nullhdr
;line16
	xheader		row16,0,20,0,0,1
	xheader		row16+(columns/2),0,20,80,0,1
	nullhdr
;line17
	xheader		row17,0,20,0,0,1
	xheader		row17+(columns/2),0,20,80,0,1
	nullhdr
;line18
	xheader		row18,0,20,0,0,1
	xheader		row18+(columns/2),0,20,80,0,1
	nullhdr
;line19
	xheader		row19,0,20,0,0,1
	xheader		row19+(columns/2),0,20,80,0,1
	nullhdr
;line20
	xheader		row20,0,20,0,0,1
	xheader		row20+(columns/2),0,20,80,0,1
	nullhdr
;line21
	xheader		row21,0,20,0,0,1
	xheader		row21+(columns/2),0,20,80,0,1
	nullhdr
;line22
	xheader		row22,0,20,0,0,1
	xheader		row22+(columns/2),0,20,80,0,1
	nullhdr
;line23
	xheader		row23,0,20,0,0,1
	xheader		row23+(columns/2),0,20,80,0,1
	nullhdr
;line24
	xheader		row24,0,20,0,0,1
	xheader		row24+(columns/2),0,20,80,0,1
	nullhdr

	.subttl		"Character generation data"
;The data here is represented so that every 128 bytes sequentially is the next
;row of the 8 x 8 character represented.  As an example, the first row of a
;capital A is located at table + $41, the second at table + $41 + $80, etc.

table:
	dc.b	$00,$7E,$7E,$6C,$10,$38,$10,$00
	dc.b	$FF,$00,$FF,$0F,$3C,$3F,$7F,$99
	dc.b	$80,$02,$18,$66,$7F,$3E,$00,$18
	dc.b	$18,$18,$00,$00,$00,$00,$00,$00
	dc.b	$00,$30,$6C,$6C,$30,$00,$38,$60
	dc.b	$18,$60,$00,$00,$00,$00,$00,$06
	dc.b	$7C,$30,$78,$78,$1C,$FC,$38,$FC
	dc.b	$78,$78,$00,$00,$18,$00,$60,$78
	dc.b	$7C,$30,$FC,$3C,$F8,$FE,$FE,$3C
	dc.b	$CC,$78,$1E,$E6,$F0,$C6,$C6,$38
	dc.b	$FC,$78,$FC,$78,$FC,$CC,$CC,$C6
	dc.b	$C6,$CC,$FE,$78,$C0,$78,$10,$00
	dc.b	$30,$00,$E0,$00,$1C,$00,$38,$00
	dc.b	$E0,$30,$0C,$E0,$70,$00,$00,$00
	dc.b	$00,$00,$00,$00,$10,$00,$00,$00
	dc.b	$00,$00,$00,$1C,$18,$E0,$76,$00
	dc.b	$00,$81,$FF,$FE,$38,$7C,$10,$00
	dc.b	$FF,$3C,$C3,$07,$66,$33,$63,$5A
	dc.b	$E0,$0E,$3C,$66,$DB,$63,$00,$3C
	dc.b	$3C,$18,$18,$30,$00,$24,$18,$FF
	dc.b	$00,$78,$6C,$6C,$7C,$C6,$6C,$60
	dc.b	$30,$30,$66,$30,$00,$00,$00,$0C
	dc.b	$C6,$70,$CC,$CC,$3C,$C0,$60,$CC
	dc.b	$CC,$CC,$30,$30,$30,$00,$30,$CC
	dc.b	$C6,$78,$66,$66,$6C,$62,$62,$66
	dc.b	$CC,$30,$0C,$66,$60,$EE,$E6,$6C
	dc.b	$66,$CC,$66,$CC,$B4,$CC,$CC,$C6
	dc.b	$C6,$CC,$C6,$60,$60,$18,$38,$00
	dc.b	$30,$00,$60,$00,$0C,$00,$6C,$00
	dc.b	$60,$00,$00,$60,$30,$00,$00,$00
	dc.b	$00,$00,$00,$00,$30,$00,$00,$00
	dc.b	$00,$00,$00,$30,$18,$30,$DC,$10
	dc.b	$00,$A5,$DB,$FE,$7C,$38,$38,$18
	dc.b	$E7,$66,$99,$0F,$66,$3F,$7F,$3C
	dc.b	$F8,$3E,$7E,$66,$DB,$38,$00,$7E
	dc.b	$7E,$18,$0C,$60,$C0,$66,$3C,$FF
	dc.b	$00,$78,$6C,$FE,$C0,$CC,$38,$C0
	dc.b	$60,$18,$3C,$30,$00,$00,$00,$18
	dc.b	$CE,$30,$0C,$0C,$6C,$F8,$C0,$0C
	dc.b	$CC,$CC,$30,$30,$60,$FC,$18,$0C
	dc.b	$DE,$CC,$66,$C0,$66,$68,$68,$C0
	dc.b	$CC,$30,$0C,$6C,$60,$FE,$F6,$C6
	dc.b	$66,$CC,$66,$E0,$30,$CC,$CC,$C6
	dc.b	$6C,$CC,$8C,$60,$30,$18,$6C,$00
	dc.b	$18,$78,$60,$78,$0C,$78,$60,$76
	dc.b	$6C,$70,$0C,$66,$30,$CC,$F8,$78
	dc.b	$DC,$76,$DC,$7C,$7C,$CC,$CC,$C6
	dc.b	$C6,$CC,$FC,$30,$18,$30,$00,$38
	dc.b	$00,$81,$FF,$FE,$FE,$FE,$7C,$3C
	dc.b	$C3,$42,$BD,$7D,$66,$30,$63,$E7
	dc.b	$FE,$FE,$18,$66,$7B,$6C,$00,$18
	dc.b	$18,$18,$FE,$FE,$C0,$FF,$7E,$7E
	dc.b	$00,$30,$00,$6C,$78,$18,$76,$00
	dc.b	$60,$18,$FF,$FC,$00,$FC,$00,$30
	dc.b	$DE,$30,$38,$38,$CC,$0C,$F8,$18
	dc.b	$78,$7C,$00,$00,$C0,$00,$0C,$18
	dc.b	$DE,$CC,$7C,$C0,$66,$78,$78,$C0
	dc.b	$FC,$30,$0C,$78,$60,$FE,$DE,$C6
	dc.b	$7C,$CC,$7C,$70,$30,$CC,$CC,$D6
	dc.b	$38,$78,$18,$60,$18,$18,$C6,$00
	dc.b	$00,$0C,$7C,$CC,$7C,$CC,$F0,$CC
	dc.b	$76,$30,$0C,$6C,$30,$FE,$CC,$CC
	dc.b	$66,$CC,$76,$C0,$30,$CC,$CC,$D6
	dc.b	$5C,$CC,$98,$E0,$00,$1C,$00,$6C
	dc.b	$00,$BD,$C3,$7C,$7C,$FE,$FE,$3C
	dc.b	$C3,$42,$BD,$CC,$3C,$30,$63,$E7
	dc.b	$F8,$3E,$18,$66,$1B,$6C,$7E,$7E
	dc.b	$18,$7E,$0C,$60,$C0,$66,$FF,$3C
	dc.b	$00,$30,$00,$FE,$0C,$30,$DC,$00
	dc.b	$60,$18,$3C,$30,$00,$00,$00,$60
	dc.b	$F6,$30,$60,$0C,$FE,$0C,$CC,$30
	dc.b	$CC,$0C,$00,$00,$60,$00,$18,$30
	dc.b	$DE,$FC,$66,$C0,$66,$68,$68,$CE
	dc.b	$CC,$30,$CC,$6C,$62,$D6,$CE,$C6
	dc.b	$60,$DC,$6C,$1C,$30,$CC,$CC,$FE
	dc.b	$38,$30,$32,$60,$0C,$18,$00,$00
	dc.b	$00,$7C,$66,$C0,$CC,$FC,$60,$CC
	dc.b	$66,$30,$0C,$78,$30,$FE,$CC,$CC
	dc.b	$66,$CC,$66,$78,$30,$CC,$CC,$FE
	dc.b	$38,$CC,$30,$30,$18,$30,$00,$C6
	dc.b	$00,$99,$E7,$38,$38,$7C,$7C,$18
	dc.b	$E7,$66,$99,$CC,$18,$70,$67,$3C
	dc.b	$E0,$0E,$7E,$00,$1B,$38,$7E,$3C
	dc.b	$18,$3C,$18,$30,$FE,$24,$FF,$18
	dc.b	$00,$00,$00,$6C,$F8,$66,$CC,$00
	dc.b	$30,$30,$66,$30,$30,$00,$30,$C0
	dc.b	$E6,$30,$CC,$CC,$0C,$CC,$CC,$30
	dc.b	$CC,$18,$30,$30,$30,$FC,$30,$00
	dc.b	$C0,$CC,$66,$66,$6C,$62,$60,$66
	dc.b	$CC,$30,$CC,$66,$66,$C6,$C6,$6C
	dc.b	$60,$78,$66,$CC,$30,$CC,$78,$EE
	dc.b	$6C,$30,$66,$60,$06,$18,$00,$00
	dc.b	$00,$CC,$66,$CC,$CC,$C0,$60,$7C
	dc.b	$66,$30,$CC,$6C,$30,$D6,$CC,$CC
	dc.b	$7C,$7C,$60,$0C,$34,$CC,$78,$FE
	dc.b	$6C,$7C,$64,$30,$18,$30,$00,$C6
	dc.b	$00,$81,$FF,$10,$10,$38,$38,$00
	dc.b	$FF,$3C,$C3,$CC,$7E,$F0,$E6,$5A
	dc.b	$80,$02,$3C,$66,$1B,$CC,$7E,$18
	dc.b	$18,$18,$00,$00,$00,$00,$00,$00
	dc.b	$00,$30,$00,$6C,$30,$C6,$76,$00
	dc.b	$18,$60,$00,$00,$30,$00,$30,$80
	dc.b	$7C,$FC,$FC,$78,$1E,$78,$78,$30
	dc.b	$78,$70,$30,$30,$18,$00,$60,$30
	dc.b	$78,$CC,$FC,$3C,$F8,$FE,$F0,$3E
	dc.b	$CC,$78,$78,$E6,$FE,$C6,$C6,$38
	dc.b	$F0,$1C,$E6,$78,$78,$FC,$30,$C6
	dc.b	$C6,$78,$FE,$78,$02,$78,$00,$00
	dc.b	$00,$76,$DC,$78,$76,$78,$F0,$0C
	dc.b	$E6,$78,$CC,$E6,$78,$C6,$CC,$78
	dc.b	$60,$0C,$F0,$F8,$18,$76,$30,$6C
	dc.b	$C6,$0C,$FC,$1C,$18,$E0,$00,$FE
	dc.b	$00,$7E,$7E,$00,$00,$7C,$7C,$00
	dc.b	$FF,$00,$FF,$78,$18,$E0,$C0,$99
	dc.b	$00,$00,$18,$00,$00,$78,$00,$FF
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$60,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$FF
	dc.b	$00,$00,$00,$00,$00,$00,$00,$F8
	dc.b	$00,$00,$78,$00,$00,$00,$00,$00
	dc.b	$F0,$1E,$00,$00,$00,$00,$00,$00
	dc.b	$00,$F8,$00,$00,$00,$00,$00,$00
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

RAM4	=	$C000

;move character rom data
;Maria fetches character data every 256 locations so the character
;ROM data is thus spread out from the packed ROM representation

	lda	table,x
	sta	RAM4+$700,x

	lda	table+$80,x
	sta	RAM4+$600,x

	lda	table+$100,x
	sta	RAM4+$500,x

	lda	table+$180,x
	sta	RAM4+$400,x

	lda	table+$200,x
	sta	RAM4+$300,x

	lda	table+$280,x
	sta	RAM4+$200,x

	lda	table+$300,x
	sta	RAM4+$100,x

	lda	table+$380,x
	sta	RAM4,x

	inx
 	bne	loop
main30:
	bit	MSTAT	;Vblank?
	bmi	main30	;wait while it is on...
main32:
	bit	MSTAT 	;Vblank?
	bpl	main32	;wait until it comes back...

	lda	#$C0
	STA	CBTMP
	sta	CHBASE		;character base address.

	dppload dllist		;init display list list.

	screen	0,2,0,1,0,0	;Maria setups:
				;0=normal color.
				;2=Normal DMA.
				;0=single byte wide characters.
				;1=background colored border.
				;0=transparency mode.
				;3=320 a or c mode.

around:
	lda	#$0
	sta	BKGRND		;maria background color register

	lda	#$0e
	sta	P0C2		;maria pallette 0 - color 2

	JSR	CLEAR

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
	STA	BKGRND
	JMP	OVER

DOIT:	LDA	#$0E
	STA	BKGRND

OVER:	LDA	SWCHA
	AND	#$0F
	STA	VALUE

	JSR	CLEAR

;	INC 	COUNT
;	LDA	COUNT
;	AND	#$1F
;	BNE	main40
;	
;	dec	CBTMP
;	LDA	CBTMP
;	CMP	#$B9
;	BNE 	main46
;	LDA	#$C0
;	STA	CBTMP
;main46:	LDA	CBTMP
;	STA	CHBASE
	jmp	main40


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CLEAR:
	LDX	#$0
	LDA	VALUE	
CLEAR10:
	STA	SCREEN,X
	STA	SCREEN+$100,X
	STA	SCREEN+$200,X
	STA	row24+columns-$100,x
	inx
	bne	CLEAR10
	RTS
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org	$FFF8

	.dc.w	$F7FF
	.dc.w	dummy	;NMI
	.dc.w	main	;RESET
	.dc.w	dummy	;IRQ
