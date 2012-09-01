*****************************************
*					*	
*    7800 Crossbow Lite Gun Routine	*
*    					*
*    Software Input Kernel		*
*    for Atari Lite Gun			*
*					*
*    No Additional hardware required	*
*					*
*					*
*    Designed & Programmed		*
*	      by			*
*	  Dave Staugas			*
*					*
*****************************************
*	temp vars at $2600/1/2 moved to $2700 by Scott Marshall 7/12/88
*
dogun:
;
;	check for shot allowed
;
	lda	movsta+N_CURSOR		;check cursor status
	and	#S_STOPPED		;if STOP bit is lo
	bne	.notfire		;br so we can shot now
;
	ldx	#SCWP			;assume gunshot off screen
	stx	movx+N_CURSOR		;stuff offscreen xpos
;
	lda	SWCHA			;check for lite gun fire button
	and	#$10			;hey!!--same bit as S_STOPPED!
	bne	.doshot			;br if fire button not depressed

.notfire:
	lda	#FALSE
	rts
*
*  Shot is fired
*
.doshot:
	lda	#1
	sta	$2700			;use temp for now	
doshot2:
	jsr	vwait
	lda	#$7f			;turn off MARIA
	sta	CTRL
*
	sta	WSYNC
	lda	#0
	sta	BACKGRND
*
	ldx	#32
wloop:
	sta	WSYNC			;count off n lines
	dex
	bne	wloop
*
	lda	#$e			;white out the screen
	sta	WSYNC
	sta	BACKGRND
*
GUNBIT	equ	INPT4
*
*   now do an input kernel for the LITE gun (less filling!)
*
*	jmp	doklop2
*
*  keep the following within a single page to reduce page boundary xing
*   headaches 
*
*	.org	(*&$ff00)+$100
doklop2:
	ldx	#SCWP			;assume gunshot off screen
	stx	movx+N_CURSOR		;stuff offscreen xpos
	ldx	#255-216		;use x as vert position (+ constant)
	sta	WSYNC
*
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ldy	#0
	lda	#$e
kloop1:
	inx			;2
	beq	out		;4
	nop			;6
	bit	$80		;9
	nop			;11
	nop			;13
*
	bit	GUNBIT		;16 1/2
	bpl	out0		;18 1/2
*
	bit	GUNBIT		;22
	bpl	out1		;24
*
	bit	GUNBIT		;27 1/2
	bpl	out2		;29 1/2
*
	bit	GUNBIT		;33
	bpl	out3		;35
*
	bit	GUNBIT		;38 1/2
	bpl	out4		;40 1/2
*
	bit	GUNBIT		;44
	bpl	out5		;46
*
	bit	GUNBIT		;49 1/2
	bpl	out6		;51 1/2
*
	bit	GUNBIT		;55
	bpl	out7		;57
*
	bit	GUNBIT		;60 1/2
	bpl	out8		;62 1/2 
*
	bit	GUNBIT		;66
	bpl	out9		;68
*
	bit	GUNBIT		;71 1/2
	bpl	out10		;73 1/2
*
	bit	GUNBIT		;77
	bpl	out11		;79
*
	bit	GUNBIT		;82 1/2
	bpl	out12		;84 1/2
*
	bit	GUNBIT		;88
	bpl	out13		;90
*
	bit	GUNBIT		;93 1/2
	bpl	out14		;95 1/2
*
	nop			;97 1/2
	nop			;99 1/2
	nop			;101 1/2
	nop			;103 1/2
	nop			;105 1/2
	nop			;107 1/2
	bit	$80		;110 1/2
	jmp	kloop1		;113 1/2
*
out:
	jmp	SSTIME
out5:
	lda	#61
	bne	cyc75
out4:
	lda	#50
	bne	cyc75
out3:
	lda	#39
	bne	cyc75
out2:
	lda	#28
	bne	cyc75
out1:
	lda	#17
	bne	cyc75
out0:
	lda	#6
	bne	cyc75
out14:
	lda	#160		;5
	bne	cyc75		;8
out13:
	lda	#149
	bne	cyc75
out12:
	lda	#138
	bne	cyc75
out11:
	lda	#127
	bne	cyc75
out10:
	lda	#116
	bne	cyc75
out9:
	lda	#105
	bne	cyc75
out8:
	lda	#94
	bne	cyc75
out7:
	lda	#83
	bne	cyc75
out6:
	lda	#72
	bne	cyc75
	bit	$80
cyc75:
	sta	movx+N_CURSOR	;11
	stx	movy+N_CURSOR	;14
	ldy	#8		;16
cycloop:
	ldx	#17		;18
cyclp:
	dex			;20
	bpl	cyclp		;23 28 33 38 43 48 53 58 63 68 73 78 83 88 93
				;98 103 107
	nop			;109
	bit	GUNBIT		;112 1/2
	bmi	doss		;2
	sec			;4
	sbc	#1		;6
	sta	movx+N_CURSOR	;9
	nop			;11
	dey			;13
	bpl	cycloop		;16
doss:
	lda	movy+N_CURSOR
	eor	#$ff
	sec
	sbc	#30
	sta	movy+N_CURSOR
*
	lda	movx+N_CURSOR
	sec
	sbc	#7
	sta	movx+N_CURSOR

SSTIME:
	dec	$2700	;was $2600
	bmi	exitim
*
	lda	movx+N_CURSOR
	sta	$2701	;was $2601
	lda	movy+N_CURSOR
	sta	$2702	;was $2602
*
	jmp	doshot2
exitim:
*
*  take average of 2 screens
*
	lda	movx+N_CURSOR
	clc
	adc	$2701	;was $2601
	ror
	sta	movx+N_CURSOR
*
	lda	movy+N_CURSOR
	clc
	adc	$2702	;was $2602
	ror
	sta	movy+N_CURSOR
*
	jsr	vwait
	lda	#0
	sta	BACKGRND	;restore black background... turn on MARIA
*
	lda	#$40
	sta	CTRL		;turn on MARIA with value used by game
*
	lda	#TRUE
	rts
*
*
*
vwait:
	bit	MSTAT
	bmi	vwait
vwait1:
	bit	MSTAT
	bpl	vwait1
	rts
*
