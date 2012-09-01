; @A D	 *4>HR\+p
; Z-1________ -0

	.subttl "SSCZOOM.S:  Zooming Playfield Effect"
; by James St. Louis 10/31/88	       Key: [*] in this segment

; Z-1________ -0

ZoomFWD:

	lda Event+2
	bne .9
	put #3,Event+2		;3= 20fps

	jsr QueueFWD	;[*] Fifo 10 steps into view area and scale
	jsr Integrate	;[*] Connect-the-dots
	jsr UpdateObj0	;[*] Move scaled data into display list
	jsr Overlay0	;[*] Scaled data into 18 byte overlay dlists b0z0 etc.

.9:	    rts
QueueFWD:
	dec Step	;Current track position updated.  Offset from Course#.
	put Step,POINT	  ; begin load from point where Step is.
	put #0,DEPTH	;Depth plane corresponds with magnification and Fifo pos.
	put #10,COUNT
.ScaleFifo:
	ldy POINT	;track position;	lda DEPTH	  ;Mag depends on Fifo position, not track position.
	lda (Track),y
	ldy DEPTH	; x= 0-F
	clc
	adc RCTR,x       ;[SSCTABLE]
	sta Fifo,y	; Fully scaled and expanded set of 10 positions!
	inc POINT
	inc DEPTH
	dec COUNT
	bne .ScaleFifo
   rts


UpdateObj0:
	putadr ZOOM+3,DEST0		;in display list, object 0 HPOS/line
	putadr Matrix,SRCE0		;pg0 [SSCEQU] 64 computed from map
	ldy #80
	ldx #0
.7:  lda (SRCE0,x)		;
	 sta (DEST0,x)		;
	 inc SRCE0
	 bne .71
	 inc SRCE0+1
.71: clc
	 lda DEST0
	 adc #10	;6 for one, 10 for two object header display list
	 sta DEST0
	 bcc .73
	 inc DEST0+1
.73: dey
	 bpl .7
	rts

; Z-1________ -0

Integrate:
;Note- Higher numbers in Fifo are foreground, likewise in the Course.
	putadr Mag80,POINT	;
	put #0,MatrixPoint	;[RAM3] increments 0-79       Start in background
	sta FifoPoint		;[RAM3] increments 0-10 	"	"
	ldx #2		; Active Line 2, sc0-sc1
	jsr FillMatrix		;sequences Fifo, averages
	ldx #3		; Active Line 3, sc2-sc4
	jsr FillMatrix
	ldx #4		; Active Line 4, sc5-sc8
	jsr FillMatrix
	ldx #5		; Active Line 5, sc9-scD
	jsr FillMatrix
	ldx #6		; Active Line 6, scE-sc13
	jsr FillMatrix
	ldx #8		; Active Line 8,  sc14-sc1B
	jsr FillMatrix
	ldx #10		; Active Line 10, sc1C-sc25
	jsr FillMatrix
	ldx #12		; Active Line 12, sc26-sc31
	jsr FillMatrix
	ldx #14		; Active Line 14  sc32-sc3f
	jsr FillMatrix
	ldx #16		; Active Line 16  sc40-sc4f
	jsr FillMatrix
	rts	


Overlay0:	;overlap region bike/road for "Trail" course
	ldx #0
	ldy #0
.0: 	sty TEMP
	lda Matrix+65,y		;64***
	sec
	sbc #2		;twiddle hpos
	sbc TEMP
	sbc TEMP
 	sta b0z0+3,x	;left side
	clc
	adc #48
;	asl TEMP
;	asl TEMP
;	clc
	adc TEMP
	adc TEMP
	adc TEMP
	sta b0z0+7,x	;right side
	txa
	clc
	adc #18
	tax
	iny
	cpy #15 		;14*18=238
	bcc .0
; last is drone
	lda b3z0+3
	sec
 	sbc #8
	sta b3z1+3
	lda b3z0+7
	clc
	adc #6
	sta b3z1+7
	rts

FillMatrix:
	stx SCAN	;# scan lines passed in
 	ldx FifoPoint
	ldy Fifo,x	;Current Fifo value
.0:	lda (POINT),y	;Mag80 matrix
	ldx MatrixPoint
	clc
	adc CenterLine,x
	sta TEMP
	 jsr Random	;returns random number in A
	ldx FifoPoint
	and MaskRoad,x
	ora TEMP
	ldx MatrixPoint
	sta Matrix,x
	clc
	lda #$10	;16 planes in Mag80
	adc POINT
	sta POINT
	bcc .1
	inc POINT+1
.1:	inc MatrixPoint
	dec SCAN
	bne .0
	inc FifoPoint		; When depth plane full.  Up to 10
	 rts

CenterPath:
	ldx #5
	ldy #79	
.0:	put #16,COUNT
.1:	lda RCTR,x
	sta CenterLine,y
	dey
	dec COUNT
	bne .1
	dex
	bpl .0
	rts

SetWend:
	ldx #79
.0: lda Wend1,x
	sta CenterLine,x
	dex
	bpl .0
	rts


FlushFifo:
	ldx #10				     
	lda #0
.2:	sta Fifo,x
	dex
	bpl .2
	rts

TestMatrix:
	put #16,COUNT
	put #0,MatrixPoint
	sta FifoPoint
.0:	ldx FifoPoint
	lda Fifo,x
	ldy MatrixPoint
	sta Matrix,y
	inc MatrixPoint
	dec COUNT
	bne .0
	put #16,COUNT
	inc FifoPoint
	lda #80
	cmp MatrixPoint
	bcs .0

	dec Matrix
	rts	


; Z-1________ -0
	    

Course0:
	dc.B $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
	dc.B $0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03,$02,$01,$00	
	dc.B $01,$03,$05,$07,$09,$0B,$0D,$0F,$0E,$0C,$0A,$08,$06,$04,$02,$00
	dc.B $01,$02,$04,$08,$0C,$0B,$09,$06,$03,$01,$00,$01,$02,$03,$05,$07
	dc.B $05,$03,$01,$00,$01,$03,$05,$08,$0A,$0E,$0F,$0E,$0D,$0C,$0D,$0B
	dc.B $0C,$0D,$0E,$0F,$0E,$0D,$0C,$0B,$0A,$05,$02,$03,$05,$09,$0E,$0F
	dc.B $0D,$0C,$0B,$0A,$09,$08,$07,$06,$04,$02,$00,$02,$03,$05,$07,$09
	dc.B $0A,$0C,$0E,$0C,$0B,$0A,$09,$07,$06,$04,$01,$00,$02,$04,$06,$08
	dc.B $0A,$0C,$0E,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$03,$04
	dc.B $05,$04,$03,$05,$02,$03,$04,$05,$06,$04,$02,$01,$00,$04,$08,$0A
	dc.B $0E,$0C,$09,$04,$02,$03,$04,$03,$02,$05,$06,$07,$08,$07,$06,$05
	dc.B $04,$05,$06,$08,$0A,$0C,$0E,$0F,$0C,$0B,$0A,$09,$07,$05,$03,$02
	dc.B $01,$00,$03,$05,$07,$09,$0A,$0C,$0E,$0B,$0A,$0B,$0E,$0B,$0C,$0B
	dc.B $08,$05,$03,$01,$03,$00,$01,$02,$05,$03,$06,$02,$03,$04,$05,$04
	dc.B $07,$0A,$0C,$0D,$0F,$0E,$0D,$0F,$0A,$08,$05,$03,$01,$00,$01,$03
	dc.B $05,$07,$08,$09,$0A,$0C,$0E,$0F,$0D,$0A,$08,$06,$04,$02,$01,$02

Wend1:
c0	=	48
c1	=	36
c2	=	24
c3 	=	12
c4	=	0
;        0     1     2     3     4     5     6     7
  dc.B c0+88,c0+81,c0+75,c0+70,c0+67,c0+64,c0+62,c0+60
  dc.B c0+58,c0+56,c0+54,c0+53,c0+51,c0+50,c0+49,c0+48

  dc.B c1+47,c1+46,c1+45,c1+44,c1+43,c1+42,c1+41,c1+40
  dc.B c1+39,c1+38,c1+37,c1+36,c1+35,c1+34,c1+33,c1+32

  dc.B c2+31,c2+30,c2+29,c2+28,c2+27,c2+26,c2+25,c2+24
  dc.B c2+23,c2+22,c2+21,c2+20,c2+19,c2+18,c2+17,c2+16

  dc.B c3+15,c3+15,c3+14,c3+13,c3+13,c3+12,c3+11,c3+11
  dc.B c3+10,c3+09,c3+09,c3+08,c3+08,c3+07,c3+07,c3+06

  dc.B c4+06,c4+05,c4+05,c4+05,c4+04,c4+04,c4+04,c4+03
  dc.B c4+03,c4+03,c4+02,c4+02,c4+02,c4+01,c4+01,c4

; Z-1________ -0
