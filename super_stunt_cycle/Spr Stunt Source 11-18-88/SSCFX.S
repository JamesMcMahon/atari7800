; @A D	 *4>HR\+p
; Z-1________ -0

	.subttl "SSCFX:  Special Effects"
; by James St. Louis 10/31/88	       Key: [*] in this segment

; Z-1________ -0

; very low priority graphic updates, housekeeping for Nature:

TwirlWorld:
	lda MSTAT
	rol
	bcs .0		;vblank on - good time to revise dll.
	rts
.0:	lda Event+3
	bne .9
	put #4,Event+3
	dec mountains+$3
	dec mountains+$7
	dec mountains+$B
	dec mountains+$F
	dec mountains+$13
	dec mountains+$17	
	dec clouds+3
	dec clouds+7
	dec clouds+$B
	dec clouds+$F
	lda BounceNow
	cmp BounceTo
	beq .3
	bcc .2
	dec BounceNow
	jmp .3
.2:	inc BounceNow
.3:	lda BounceNow
	clc
	adc #4
	ora #%10000000
	sta Bounce2
	sec
	lda #15
	sbc BounceNow
	sta Bounce1
	jsr Random
	and #%00000011
	sta BounceTo

	jsr Random
	lsr
	bne .4
	inc clouds+3
.4:	jsr Random
	bne .5
	inc clouds+7
.5:	jsr Random
	lsr
	bne .6
	inc clouds+$B
.6:	jsr Random
	bne .9
	inc clouds+$F
.9:  rts

; Z-1________ -0

