;@A D	 *4>HR\+p
; Z-1________ -0

	.subttl "SSCSUB.S:  Subroutines and Calls"
; Z-1________ -0

waitvb:		;Wait for start of Vertical Blank, 1/120 to 1/60 sec. delay
		lda MSTAT 	;[SSCEQU]
		rol
		bcs waitvb	;vblank on, but unknown time remaining
.1:		lda MSTAT
		rol
		bcc .1		;vblank off, wait until it starts then return
        rts 

waitnovb:	lda MSTAT
		rol
		bcc waitvb
.1:		lda MSTAT
		rol
		bcs .1		;exit when vblank ends
		rts

waitsc:	   	; wait for one screen time
	     lda WhirliGig
.0:		cmp WhirliGig
		beq .0
		rts

pause:		;wait for multiple screen times to 4 seconds
	sta PCOUNT
.0:	jsr waitsc
	dec PCOUNT
	bne .0
	rts

; Z-1________ -0

ramzero:		;Store COUNT zeros in block starting at POINT.
	lda #0
	ldx #0 
pokit: sta (POINT,X)
	   inc POINT		;[SSCEQU] pg0
	   bne hiok
	   inc POINT+1		
hiok:  dec COUNT		;[SSCEQU] pg0
	   bne pokit
	   dec COUNT+1
	   bpl pokit		;ok for <$8000 bytes
	   rts
; Z-1________ -0

Random:		;Pseudorandom Sequence Generator, or "Poly-Counter"
	lda ShiftReg+1		;[SSCEQU]
	and #%00001000		;tap at stage 13
	sta Feedback		;
	lda ShiftReg+3
	and #%00000010		;tap at stage 31
	ora Feedback
	sta Feedback		;feedback taps determine sequence length
	bne .0	;NAND both inputs low = 0 out
	clc		;carry will rotate into the shift register
	bcc .4	;always
.0: cmp #%00001010
	bne .1
	clc		;NAND both inputs high = 0 out
	bcc .4	;always
.1: sec		;NAND for either high = 1 out
.4: ror ShiftReg
	ror ShiftReg+1
	ror ShiftReg+2
	ror ShiftReg+3
;tap for output
	lda ShiftReg
	and #%00000110		; 6 and 7
	sta RandomNumber
	lda ShiftReg+1
	and #%00101000		; 11 and 13
	ora RandomNumber
	sta RandomNumber
	lda ShiftReg+2
	and #%10010000		;17 and 20
	ora RandomNumber
	sta RandomNumber
	lda ShiftReg+3
	and #%01000001		;26 and 32
	ora RandomNumber
	sta RandomNumber	;Outputs RandomNumber and accumulator
	rts
; The nominal repeat rate for the above number series is 2,147,483,647 numbers.
; Always use realtime inputs whenever possible to increase randomness by
; seeding ShiftReg from WhirliGig when a realtime input occurs.



; Z-1________ -0

* Read Console Switches, Joy Stick and Buttons
direc:
;snooze:
right:
left:
down:
up:     rts
fire:
        lda  INPT0
        and  #$80
        bne  pushed
        rts
pushed:
        jsr  waitvb
        put  #0,BKGRND
        put  #$4A,DPPH
	 	RTS

; Z-1________ -0

SequenceText:
  lda Event+1	;[SSCDLI] pg0
  bne .9		;bypass until used
  lda #2		 ;of 2 vbi's
  sta Event+1
	lda ST0	; flag for phase 0, Print.	in RAM3 [SSCEQU]
	beq .1
	ldx TextLin	; indicate line to print
	jsr Print
	put #0,ST0		;off until reset
	inc TextLin	;in RAM3.  Points to current line of text to display
	lda TextLin
	cmp #TI_L	;option to repeat after last text line displayed
	bcc .0
	put #0,TextLin	;resets to 0
.0:	 rts			; no repeat until reset
.1: lda ST1	;Phase 1:  Fade-in
	beq .2
	dec ST1
	inc TextLum		; Luminance of text line	RAM3
	put TextLum,P5C2
	 rts			; exit after each step
.2: lda ST2	;Phase 2:  Pause at full luminance
	beq .3
	dec ST2
	 rts
.3:	lda ST3	;Phase 3:  Fade-Out
	beq .4
	dec ST3
	dec TextLum
	put TextLum,P5C2
	 rts
.4: put #1,ST0
	put #$A,ST1
	put #80,ST2
	put #$A,ST3
.9:	 rts

; Z-1________ -0


Print:		;index of 0-256 possible text lines entered in X
	stx TEMPX
	txa
	asl
	tax			;2 byte index table
	lda TextIndex,x
	sta STRING
	lda TextIndex+1,x
	sta STRING+1		;STRING points to text to output
	put #0,COLUMN		;COLUMN counts into string, to eol
.0:	 
	ldy COLUMN	
	lda (STRING),y		;one letter at a time:
	cmp #"`"		; eol chr
	bne .1	
	ldx TEMPX
	rts			;finished - exit
.1:	sec
	sbc #$20		;no ctrl chr in [SSCASCII]
	sta IMAGE		
	put #0,IMAGE+1		;sscascii value * 8 bytes/chr font image
	asl IMAGE		;= offset into font data
	rol IMAGE+1		;5cy * 6
	asl IMAGE
	rol IMAGE+1
	asl IMAGE
	rol IMAGE+1	;*8
	clc
	lda IMAGE
	adc #ASCII &$FF   	;add offset to font data base location
	sta IMAGE
	lda IMAGE+1
	adc #ASCII >>8 
	sta IMAGE+1	   ;IMAGE points to contiguous font data [SSCASCII.S]
   	ldy #0
	ldx COLUMN
	lda (IMAGE),y		
	sta LineBufr,x		;txt1
	iny
	lda (IMAGE),y		
	sta LineBufr+$20,x	;txt2
	iny
	lda (IMAGE),y		
	sta LineBufr+$40,x	;txt3
	iny
	lda (IMAGE),y
	sta LineBufr+$60,x	;txt4
	iny
	lda (IMAGE),y
	sta LineBufr+$80,x	;txt5
	iny
	lda (IMAGE),y
	sta LineBufr+$A0,x	;txt6
	iny
	lda (IMAGE),y
   	sta LineBufr+$C0,x	;txt7
	iny
	lda (IMAGE),y
	sta LineBufr+$E0,x	;txt8	TOTAL= 256 bytes
	cpx #33		;temporary abort on overflow
	bcc .4
	ldx TEMPX
	rts
.4:	inc COLUMN
  	jmp .0

Divide:
; dividend/divisor= quotient,  dividend= 16bit, divisor= 8bit, quotient= 8bit
	stx DTX	;division temp x
	put #0,Dividend+1
	ldx #8
	lda Dividend	;all variables on page 0
	sta Quotient
	lda Dividend+1
.0: asl Quotient
	rol
	cmp Divisor
	bcc .1
	sbc Divisor
	inc Quotient
.1: dex
	bne .0
	sta Remainder
	ldx DTX
	rts 
	
ZeroMatrix:
	ldx #80
	lda #0
.0:  sta Matrix,x
	dex
	bpl .0
	rts



; Z-1________ -0

