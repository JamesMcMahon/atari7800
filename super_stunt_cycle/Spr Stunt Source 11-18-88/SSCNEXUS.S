;@ A D	 *4>HR\+p
*** (C)1988   Property of John Boeschen & Co.     *****
***  "SUPER STUNT CYCLE"  by Jim St. Louis        *****
*** 10/31/88
; Z-1________ -0

	.subttl  "SSCNEXUS.S  Main Loop and Dispatch"
; Z-1________ -0

;___________ MAIN LOOP ___________________

*RUN:	  	; Cold Start from [SSC]
	cld
	cli		;sei in final
 	ldx	#$FF
	txs
	put #7,PTCTRL

   jsr WarmStart	;[INIT]

;	put #$48,P5C2	;if RED atari logos appear, program has siezed.
;	ldx #$D
;	jsr Print	;
	jsr waitvb	;*********

mainloop:

	lda SWCHB
	and #%00001000   ;detect pause switch
	beq .9

	jsr ZoomFWD		;[SSCZOOM]
	jsr TwirlWorld		;[SSCFX]  Update landscape parallax
	jsr SequenceText	;[sscsub]

.9:	 jmp mainloop

; Z-1________ -0

