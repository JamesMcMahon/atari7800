;
;	This is code that was added to finish up this game.  Instead
;	of inserting code in other places, which could overflow banks,
;	I JSR here.
;
;
;===================================================
;	Extra initialization when switching
;	from title page to auto play screen.
;===================================================
;
EXTRAINIT:
	JSR	MCPINIT		;Initialize master control.
	RTS
;
;
;============================================================
;	Decrement power timer and change power color.
;============================================================


decTimer:
	lda	#$38		;Change color of power text to red.
	sta	P1C2SHDB

	dec	PTIMER
	beq	.endPower

	ldx	PLAYER
	lda	PGPOWER,x
	cmp	#9		;Is the power warp?
	beq	.flash		;Always flash when warping.
;
	lda	PTIMER
	cmp	#5		;Time almost up?
	bcs	.exit
.flash:	lda	#$1F
	sta	ROTATE		;Start power text blinking.
.exit:	rts
;
.endPower:
	JSR	CLRPFLGS	;CLEAR TIMED POWER FLAGS
	jsr	powerOff	;Clear power text.
	rts
;
;
;=======================================================
;	Make some powers automatic, user doesn't
;	have to press the right button to invoke.
;=======================================================
;
; Called from SGAME.S just before the right button is read.
;
;   IN:	PLAYER = player number.
;	PGPOWER = current power waiting to be selected.
;	ptCount = number of times left to increment score.
;
;  OUT:	Carry clear to continue (check fire button).
;	Carry set to act like right button was selected.
;
autoPower:

	ldx	PLAYER		;Get player number.
	lda	PGPOWER,x	;Is there a power waiting?
	beq	exit
	cmp	#2		;Is the power POINTS?
	bne	next1


; --- Auto POINTS -------------------------------------------------------

	lda	ptCount		;Have I already started adding score?
	bne	cont1

	lda	#50		;Add ten points 50 times.
	sta	ptCount

cont1:	lda	#10		;Add ten points to score.
	sta	TENS
	jsr	ADDSCORE
	jmp	doAuto2


; --- Other Auto powers -----------------------------------------------

next1:	cmp	#7		;Extra bonus power?
	beq	doAuto

	cmp	#18		;Slowdown power?
	beq	doAuto

	cmp	#1		;Extra life power?
	beq	doAuto

	cmp	#19		;Random power?
	beq	doAuto

	cmp	#12		;Can't hop power?
	beq	doAuto

	cmp	#13		;Can't swim power?
	beq	doAuto

	cmp	#14		;Can't fly power?
	bne	exit

doAuto:	
	lda	ptCount
	bne	doAuto2
	lda	#40
	sta	ptCount
doAuto2:
	dec	ptCount
	bne	exit
	sec			;Act like right button was pressed
	rts

exit:	clc			;else, continue as normal.
	rts


;===================================================================
;	Allow only certain power in certain rounds and levels.
;===================================================================
;
;   IN:	a = desired power index.
;	DIFCULTY = 0 for novice, 1 for standard, 2 for advanced, 3 for expert.
;	RACK = round number (0 is the first round).
;
;  OUT:	a = allowed power.
;	x = same as in (saved).
;	y = same as in (saved).
;
maskPower:
	stx	saveX
	sty	saveY
	pha

	ldx	PLAYER
	lda	#0		;Turn off any current power.
	sta	PTIMER
	sta	PGPOWER,x

	lda	RACK,x
	tax
	pla
	cpx	#4		;Allow everything in rounds 4 and above.
	bcs	.exit

	asl			;Given power times 4 to access tables,
	asl
	ora	DIFCULTY	;plus diffculty.
	tay

	txa			;Which table to access?
	bne	.next1

; --- Round 1 --------------

	lda	#0		;Reset help timer while here.
	sta	helpTime

	lda	Table1,y
	jmp	.exit

; --- Round 2 --------------

.next1:	cmp	#1
	bne	.next2

	lda	Table2,y
	jmp	.exit

; --- Round 3 --------------

.next2:	lda	Table3,y	


.exit:	ldx	saveX
	ldy	saveY
	rts

; Mask powers for round one:
;
;	Form of table:
;		novice,standard,advanced,expert
Table1:
	.dc.b	0,0,0,0		;Never happens.
	.dc.b	21,21,21,21	;Extra life.
	.dc.b	2,2,2,2		;Points.
	.dc.b	8,8,3,3		;Air bombs.
	.dc.b	15,15,15,15	;Kill Minis.
	.dc.b	22,22,22,22	;Kill pots.
	.dc.b	6,6,6,6		;Kill sphinx.
	.dc.b	7,7,7,7		;Extra bonus time.
	.dc.b	8,8,8,8		;Kill uwes.
	.dc.b	20,20,9,9	;Warp.
	.dc.b	22,22,22,10	;Air freeze.
	.dc.b	11,11,11,11	;Decoy.
	.dc.b	2,2,12,12	;Can't hop.
	.dc.b	2,2,13,13	;Can't swim.
	.dc.b	2,2,14,14	;Can't fly.
	.dc.b	15,15,15,15	;Paralize sphinx.
	.dc.b	21,21,21,16	;Hover.
	.dc.b	8,8,17,17	;Afterburner.
	.dc.b	18,18,18,18	;Slowdown.
	.dc.b	19,19,19,19	;Random hieros.
	.dc.b	20,20,20,20	;Kill everything.
	.dc.b	21,21,21,21	;Supersonic shots.
	.dc.b	22,22,22,22	;Invincibility.



; Mask powers for round two:
;
;	Form of table:
;		novice,standard,advanced,expert
Table2:
	.dc.b	0,0,0,0		;Never happens.
	.dc.b	21,21,21,21	;Extra life.
	.dc.b	2,2,2,2		;Points.
	.dc.b	3,3,3,3		;Air bombs.
	.dc.b	15,15,15,15	;Kill Minis.
	.dc.b	5,5,5,5		;Kill pots.
	.dc.b	6,6,6,6		;Kill sphinx.
	.dc.b	7,7,7,7		;Extra bonus time.
	.dc.b	8,8,8,8		;Kill uwes.
	.dc.b	9,9,9,9		;Warp.
	.dc.b	22,22,10,10	;Air freeze.
	.dc.b	11,11,11,11	;Decoy.
	.dc.b	2,2,12,12	;Can't hop.
	.dc.b	2,2,13,13	;Can't swim.
	.dc.b	2,2,14,14	;Can't fly.
	.dc.b	15,15,15,15	;Paralize sphinx.
	.dc.b	21,21,16,16	;Hover.
	.dc.b	17,17,17,17	;Afterburner.
	.dc.b	18,18,18,18	;Slowdown.
	.dc.b	19,19,19,19	;Random hieros.
	.dc.b	20,20,20,20	;Kill everything.
	.dc.b	21,21,21,21	;Supersonic shots.
	.dc.b	22,22,22,22	;Invincibility.



; Mask powers for round three:
;
;	Form of table:
;		novice,standard,advanced,expert
Table3:
	.dc.b	0,0,0,0		;Never happens.
	.dc.b	1,1,1,1		;Extra life.
	.dc.b	2,2,2,2		;Points.
	.dc.b	3,3,3,3		;Air bombs.
	.dc.b	4,4,4,4		;Kill Minis.
	.dc.b	5,5,5,5		;Kill pots.
	.dc.b	6,6,6,6		;Kill sphinx.
	.dc.b	7,7,7,7		;Extra bonus time.
	.dc.b	8,8,8,8		;Kill uwes.
	.dc.b	9,9,9,9		;Warp.
	.dc.b	21,10,10,10	;Air freeze.
	.dc.b	11,11,11,11	;Decoy.
	.dc.b	2,12,12,12	;Can't hop.
	.dc.b	2,13,13,13	;Can't swim.
	.dc.b	2,14,14,14	;Can't fly.
	.dc.b	15,15,15,15	;Paralize sphinx.
	.dc.b	21,16,16,16	;Hover.
	.dc.b	17,17,17,17	;Afterburner.
	.dc.b	18,18,18,18	;Slowdown.
	.dc.b	19,19,19,19	;Random hieros.
	.dc.b	20,20,20,20	;Kill everything.
	.dc.b	21,21,21,21	;Supersonic shots.
	.dc.b	22,22,22,22	;Invincibility.

;
;======================================
;	Check if an auto power.
;======================================
;
;   IN:	y = power number.
;
;  OUT:	Equal flag TRUE if auto power.
;
checkAuto:
;
	lda	autoTable-1,y
	rts
;
autoTable:
	.dc.b	0,0,1,1,1,1,0,1,1,1,1,0,0,0,1,1,1,0,0,1,1,1
;
