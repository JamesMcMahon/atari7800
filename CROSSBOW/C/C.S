	.title		"CROSSBOW for Atari 7800"

;	10/2/87		Started by Scott Marshall
;	12/17/87	Milestone #1 delivered
;	2/1/88		Milestone #2 delivered
;	2/16/88		Milestone #3 delivered
;	2/24/88		Milestone #4 delivered
;	3/14/88		Milestone #5 delivered
;	4/6/88		Milestone #6 delivered
;	4/18/88		Milestone #7 delivered
;
;
	.include	"\\INCLUDE\\MARIA.S"	;maria equates and some macros
	.include	"BM\\ADDR.S"		;bitmap addresses
	.include	"MACROS.S"		;special-purpose macros
	.include	"EQUATES.S"
	.include	"AUDEQU.S"		;audio equates
	.include	"VARS.S"		;all variables
;
;	set the bank

setbank	7
;
;	choose if debug examine is enabled for compiling. If true,
;	the finish quest sequence after killing the face is disabled
;
EXAMINE	equ	FALSE
;
	.org	CODE	;fixed ROM $C000 .. $FFFF
;
;	load in the ROM data tables
;
	.include	"TABLES.S"
;
;	the executable code
;
; place for IRQ to attach
;
dummy:
	rti

main:		
;
;	initialize hardware
;
	lda	#$7	;lock in 7800 mode
	sta	PTCTRL

	sei		;block interrupts
	cld		;clear decimal mode

	lda	#0
	sta	OFFSET	;future expansion
	sta	PTCTRL	;avoid joystick freeze

	ldx	#$FF	;init stack
 	txs
;
;	init high score
;
	jsr	initscore	;clear score to zero
	jsr	newhiscore	;clear hi score
;
restart0:		;from hitting SELECT during a game

	lda	#$7f	;turn MARIA off
	sta	CTRL
;
;	init audio
;
	lda	#$FF
	sta	soundon
	lda	#0
	tax
	sta	spriority,x
	sta	shistory,x
	jsr	setav
	inx
	sta	spriority,x
	sta	shistory,x
	jsr	setav
;
;	Initialize software
;
;	Maria zones and headers
;
;	Copy zone list from ROM to RAM (MARIA can't read it from ROM)
;
	ldx	#0
.loop1:	dex
	lda	romzon,x
	sta	ramzon,x
	txa
	bne	.loop1
;
;	make the vblank header
;
	lda	#%01000000	;5 byte to set write mode
	sta	vblhdr+1
	lda	#SCWP		;offscreen to the right
	sta	vblhdr+4
	lda	#0		;2nd header null
	sta	vblhdr+6
;
;	initialize application
;
;
;	set switch states
;
	lda	SWCHB	;console
	sta	oldsw
	lda	SWCHA	;joystick
	sta	oldjs
*
***** added by Dave S. 5-Jul-88
*
*   init default state of gun mode based on "UP" bit of left joystick
*
	ldx	#$ff	;assume gun
	and	#$10	;see if lite gun likely to be installed
	beq	.gunok	;power-up UP means probable gun
	ldx	#0	;else, do 'stick
.gunok:
	stx	gun	;init this guy
*
***** end Dave's addition
*
	lda	#0	;turn off
	sta	selecton ;select
	sta	pauseon	;pause,
	sta	left	;and js
	sta	right
	sta	up
	sta	down

	sta	faddir	;fader init
	sta	fadtim
;
;	gun/stick option init
;
	lda	gun		;if 0 or FF, this is a warm start
	beq	.warmstart	;so don't clear this flag
	eor	#$FF
	beq	.warmstart
	lda	#0
	sta	gun
.warmstart:
;
;	init rand
;
	jsr	initrand
;
;	Set up Maria zone and header lists
;
;	clear screen
;
	jsr	clearsc
;
;	init fader
;
	jsr	cutout
;
;	setup interrupts
;
	jsr	clrijt1
;
;	init MARIA to 160 x 2 mode
;
	lda	#(ramzon & $ff)	;zone addr low
	sta	DPPL

	lda	#(ramzon >> 8)	;zone addr high
	sta	DPPH

	jsr	waitvbl		;wait for vert blank
;
;	TURN MARIA ON
	lda	#%01000000	;color,DMA on,CW 2,border on,transp,160x2
	sta	CTRL

	jsr	waitvbl		;wait while MARIA reads 5-byte header
	lda	#0		;null vbl header to buy future time
	sta	vblhdr+1
;
;	main program loop (forever)
;
mainloop:

	jsr	doattr	;attract mode
restart:		;from hitting RESET
	lda	#FALSE
	sta	idlemode
	sta	pauseon
	jsr	cutout
	ldx	#$FF
	txs

	jsr	doplay	;play game
	jsr	doend	;say "the end"
	jmp	mainloop
;
;	do attract mode
;
doattr:
	lda	#TRUE
	sta	idlemode	;turns true if fire button down

.loop:	jsr	dotitle
	beq	.exit
	lda	#DESERT
	jsr	doselfplay
	beq	.exit
	jsr	dotitle
	beq	.exit
	lda	#TOWN
	jsr	doselfplay
	bne	.loop
.exit:
	makesound	UWILLDA
	makesound	UWILLDB
	jsr	fadeoutwait
	rts
;
;	title screen
;
dotitle:
	lda	#TITLE
	sta	cursc

	jsr	setupsc

	makeheaders	crsbwhdr
	maketall	logotall
	jsr	titlerags

	jsr	fadeinwait
	jsr	showselect
	ldx	#4
	jsr	doidlewait
	jsr	fadeout
	jsr	doidlefade
	lda	idlemode	;set return flag
	rts
;
;	idle fade .. wait for fade done or idlemode going low
;
doidlefade:
	jsr	waitbot
	jsr	dofades
	lda	idlemode
	beq	.exit
	lda	faddir
	bne	doidlefade
.exit:	rts
;
;	do self-play
;
doselfplay:
	sta	cursc
	jsr	clrbh
	jsr	initrand
	jsr	setroster
	jsr	nextsc
	jsr	fadeout
	jsr	doidlefade

	lda	idlemode	;set return flag
	rts
;
;	do idle wait .. call with 4 second units in x reg, returns when
;	time elapsed or idlemode false
doidlewait:

	lda	#$FF
	sta	clock
.loop:	pushx
	jsr	waitbot
	jsr	dofades
	popx
	lda	clock
	bne	.nodec
	dex
	beq	.exit
.nodec:
	lda	idlemode
	bne	.loop
.exit:
	rts
;
;	init score (clear to zero)
;
initscore:
	lda	#0		;init score
	sta	score

	lda	#LDZERO		;blank leading zeroes
_curdig	set	1

.rept	SCRDGTS-1		;assembly loop
	sta	score+_curdig
_curdig	set	_curdig+1
.endr
rts
;
;	set roster (friends joined and potential)
;
setroster:
	lda	#JOINED
	sta	frstat+HERO
	sta	frstat+WOMAN
	sta	frstat+DWARF
	lda	#POTENTIAL
	sta	frstat+NEGRO
	sta	frstat+MONK
	sta	frstat+GIRL
	sta	frstat+WIMP
	sta	frstat+MERLIN
	rts
;
;	do play mode
;
doplay:
;
;	clear been-here record
;
	jsr	clrbh
;
;	set these things false
;
	lda	#FALSE
	sta	gavewarning
	sta	gameover
;
;	set current screen
;
	lda	#MAP ;should be MAP	;set current and previous screen
	sta	cursc
	sta	prevsc
;
;	clear the list of map paths
;
	ldx	#NUMBPATHS-1
	lda	#FALSE
.loop:	sta	pathmem,x
	dex
	bpl	.loop
;
;	init score
;
	jsr	initscore
;
;	set roster of friends
;
	jsr	setroster
;
;	play until gameover
;
.nextscloop:
	jsr	waitbot
	jsr	clearsc
	jsr	nextsc
	jsr	fadeoutwait
	lda	gameover	;exit if game over
	beq	.nextscloop
	rts
;
;	next screen jump table
;	reads cursc (current screen), jumps to right subroutine
nextsc:
	lda	cursc
	asl
	tay
	lda	jmptab,y
	sta	jaddr
	lda	jmptab+1,y
	sta	jaddr+1
	jmp	(jaddr)
;
;	clear been here table
;
clrbh:
	ldx	#NUMBSCRS-1
	lda	#0
.loop:	sta	beenhere,x
	dex
	bpl	.loop
	rts	
;
;	each screen has its own function
;	the game screens are called using the jump table
;	do the map screen
;
domap:
	jsr	waitbot
	jsr	clearsc

	jsr	setupsc
	setpal	0,1,BLACK	;loadpals doesn't set these, so we set them here
	setpal	0,2,BLUE
	setpal	0,3,GRAY
	setpal	1,1,RED+1

	makeheaders	iconhdrs
;
;	left and right ragged edges
;
	maketall	raglr2
;
;	draw in black all connecting paths that player has already taken
;
	ldy	#NUMBPATHS-1	;set loop counter
.loop:	lda	pathmem,y	;if not walked on, don't draw
	beq	.skip
	tya			;convert pointer from byte to word
	asl
	tax
	lda	pathlist,x	;get data
	sta	addrl
	lda	pathlist+1,x
	sta	addrh

	pushy
	jsr	readhdrs	;draw the lines
	popy

.skip:	dey
	bpl	.loop
;
;
;	path buttons
;
;	read path table to decide 2 or 3 paths
;
	lda	prevsc
	asl
	asl
	tay
	lda	pathtab+2,y
	sta	path3
;
;
;	switch to two-path or three-path according to sign of path3
;
	bmi	twopaths

	lda	#p3hdrs & $FF	;3 paths
	sta	addrl
	lda	#p3hdrs >> 8
	sta	addrh
	lda	#SCWP/3		;set dividing lines for buttons
	sta	redline
	lda	#(SCWP/3)*2
	sta	greenline
	jmp	end3p
twopaths:
	lda	#p2hdrs & $FF	;2 paths
	sta	addrl
	lda	#p2hdrs >> 8
	sta	addrh
	lda	#SCHWP		;set dividing lines for buttons
	sta	redline
	lda	#SCWP
	sta	greenline
end3p:
;
	jsr	readhdrs
;
	jsr	doscore

	jsr	lockbkg		;lock background
;
;	setup interrupts
;
	jsr	waitbot

	setijt	INTZ2,intgrnd1
	setijt	INTZ0,intgrnd2	;blink button backgrounds

	jsr	fadeinwait

	lda	#0	;set clock for blink
	sta	clock

	lda	#20
	sta	timeout	;start timeout

.maploop:
	jsr	waitclear
	jsr	docursor
	jsr	doblink
	jsr	setcursor
	lda	movsta+N_CURSOR
	and	#S_NOTHREAT	;test for cursor firing
	bne	.maploop
	makesound	FIRE
	lda	movy+N_CURSOR	;fire button, check for cursor not over buttons
	cmp	#ZONEHL-5	;below buttons?
	bmi	.maploop		;yes, loop
	cmp	#(ZONEHL*3)-5	;above buttons?
	bpl	.maploop		;yes, loop

	lda	movx+N_CURSOR	;on a button, read x
	clc
	adc	#5		;fudge, compensate in doblink
	cmp	redline		;red?
	bmi	.choosered
	cmp	greenline	;green?
	bmi	.choosegreen
	lda	#CHOOSEBLUE	;blue.
	jmp	.break
.choosered:
	lda	#CHOOSERED
	jmp	.break
.choosegreen:
	lda	#CHOOSEGREEN
.break:
	sta	choice		;store player's choice

	clc			;set pal so line is drawn in button color
	adc	#1
	asl
	asl
	asl
	asl
	asl
	sta	subpal

	jsr	clrmov		;erase cursor to make room in header list

	lda	prevsc		;calc choice in 2d matrix of paths
	asl
	asl
	clc
	adc	choice
	tay

	lda	pathtab,y	;now we know the next screen
	sta	cursc

	ldx	pathmatrix,y	;find out which path to draw on screen
	lda	#TRUE
	sta	pathmem,x	;register that we're drawing this path
	txa			;convert byte to word
	asl
	tax
	lda	pathlist,x	;get header data for this path
	sta	addrl
	lda	pathlist+1,x
	sta	addrh
	jsr	readhdrs2	;draw the new lines
;
	lda	#BLACK		;kill blink
	sta	ground1
	sta	fadgrnd1
	makesound	CUCKOO
;
;	timeout
;
	lda	#ONESEC
	jsr	waitalarm

	rts
;
;	do blink, also the 20 sec map limit
;
doblink:
	lda	clock	;timeout 20 seconds
	and	#%00111111
	bne	.notyet
	dec	timeout
	bne	.notyet

	lda	#ZONEHL		;time is up .. set cursor on path buttons
	sta	movy+N_CURSOR
	jsr	rand160		;random x pos
	sec
	sbc	#5		;compensate for fudge in maploop
	sta	movx+N_CURSOR
	lda	#0		;activate
	sta	movsta+N_CURSOR
.notyet:
	lda	clock
	ror
	ror
	ror
	ror
	and	#1
	tay
	lda	.blinkcolors,y
	sta	ground1
	sta	fadgrnd1
	rts
.blinkcolors:	.dc.b	BLACK,YELLOW+2
;
;	do the cave screen
;
docave:
	jsr	dogtrdy
	maketall	cavtall
	jsr	lockbkg
	jsr	initfrs
	jsr	initcavet
	jsr	initeye
	jsr	initsnowman
	jsr	initices
	jsr	initbat
	jsr	initfsts	;path enable falling stal.

	jsr	waitbot

	jsr	domites		;ready on fadein
	jsr	dofsts
	ldx	#N_CAVET
	jsr	dotreasure

	makesound	BATCRY
	jsr	fadeinwait
	makesound	BATCRY
;
;	cave loop
;
.caveloop:
	jsr	waitclear
	jsr	doeye
	jsr	dosnowman
	jsr	dofsts		;falling stalactites that enable path
	jsr	dobat
	jsr	dofrs		;do friend
	ldx	#N_CAVET
	jsr	dotreasure
	jsr	doices		;do enemy
	jsr	domites		;onlayed stalagmites

	jsr	cpst		;cursor, points, score, threats, exit flag
	ldx	#N_CAVET
	jsr	checktreasure

	lda	activefrs
	bne	.caveloop

	jsr	checkend	;gameover?
	bne	.exit

	jsr	waitclear
	jsr	domites		;put onlays into background

	jsr	levelcomp	;level completed

	lda	cursc		;set previous screen
	sta	prevsc
	lda	#MAP		;update current screen
	sta	cursc
.exit:	rts
;
;	do stalagmites
;
domites:
	setbaddr	(MITE1+3)	;top half of mite 1
	ldpw	BKGPAL,3
	sta	palwid
	lda	#3
	sta	curzon
	lda	#10
	sta	hpos
	jsr	mkhdr

	lda	#2			;bottom half
	sta	curzon
	lda	#(MITE1 & $FF)
	sta	baddrl
	jsr	mkhdr

	lda	#(MITE2 & $FF)		;mite 2
	sta	baddrl
	lda	#37
	sta	hpos
	jsr	mkhdr

	lda	#(MITE3 & $FF)		;mite 3
	sta	baddrl
	lda	#90
	sta	hpos
	jsr	mkhdr

	lda	#(MITE4 & $FF)		;mite 4
	sta	baddrl
	lda	#118
	sta	hpos
	jsr	mkhdr
	rts	
;
;	do the town screen
;
dotown:
	jsr	dogtrdy
;
;	make background
;
	maketall	towtall

	setbaddr	CHIMN1	;chimney that sticks up over bitmap
	lda	#1
	sta	srcht
	lda	#141
	sta	vpos
	lda	#132
	sta	hpos
	ldpw	3,3	;pal, width
	sta	palwid
	jsr	xvermov

	setbaddr	CHIMN1	;chimney over center house
	lda	#1
	sta	srcht
	lda	#113
	sta	vpos
	lda	#94
	sta	hpos
	ldpw	3,3	;pal, width
	sta	palwid
	jsr	xvermov
	setbaddr	STAR	;stars in the sky
	ldpw	7,1
	sta	palwid

	lda	#1
	sta	srcht
	lda	#170
	sta	vpos
	lda	#40
	sta	hpos
	jsr	xvermov

	setbaddr	STAR	;stars in the sky
	lda	#1
	sta	srcht
	lda	#160
	sta	vpos
	lda	#47
	sta	hpos
	jsr	xvermov

	setbaddr	STAR	;stars in the sky
	lda	#1
	sta	srcht
	lda	#183
	sta	vpos
	lda	#77
	sta	hpos
	jsr	xvermov

	setbaddr	STAR	;stars in the sky
	lda	#1
	sta	srcht
	lda	#189
	sta	vpos
	lda	#152
	sta	hpos
	jsr	xvermov

	jsr	lockbkg
;
;	init friends
;
	jsr	initfrs
;
;
	jsr	inittownt	;town treasure
;
;	enemys
;
	jsr	initeye
	jsr	initwolf
	jsr	initlamps
	jsr	initghost
	jsr	initwinds
	jsr	initbolt
	jsr	initwiz
;
;	setup interrupts
;
	jsr	waitbot

	setijt	INTZ2,intgrnd1
	setijt	INTZ0,intgrnd2

	ldx	#N_TOWNT	;ready on fadein
	jsr	dotreasure
	jsr	fadeinwait
;
;	town loop
;
.townloop:
	jsr	waitclear
	jsr	doeye
	jsr	dowinds
	jsr	dolamps
	jsr	dofrs
	ldx	#N_TOWNT
	jsr	dotreasure
	jsr	dobolt
	jsr	doghost
	jsr	dowolf
	jsr	dowiz

	jsr	cpst		;cursor, points, score, threats, exit flag
	ldx	#N_TOWNT
	jsr	checktreasure

	lda	activefrs
	bne	.townloop

	jsr	checkend	;gameover?
	bne	.exit

	jsr	waitclear
	jsr	levelcomp

	lda	cursc		;set previous screen
	sta	prevsc
	lda	#MAP		;update current screen
	sta	cursc
.exit:	rts
;
;	do the desert screen
;
dodesert:
	jsr	dogtrdy
;
;	make background
;
	makeheaders	desclouds
	maketall	destall
	jsr	lockbkg
;
;	init friends
;
	jsr	initfrs
	jsr	initdest
;
;	enemys
;
	jsr	initscorp
	jsr	initants
	jsr	initeye
	jsr	initbird
	jsr	initsnake
	jsr	initrabbit
;
;	setup interrupts
;
	jsr	waitbot

	setijt	INTZ6,intgrnd1

	ldx	#N_DEST		;ready on fadein
	jsr	dotreasure
	jsr	docactuses

	makesound	BIRDCRY
	jsr	fadeinwait
	makesound	BIRDCRY
;
;	desert loop
;
.desertloop:
;
;	high priority tasks
;
	jsr	waitclear
	jsr	dosnake
	jsr	dorabbit
	jsr	doscorp
	jsr	doants
	jsr	dofrs		;do friends
	ldx	#N_DEST
	jsr	dotreasure
	jsr	dobird
	jsr	docactuses	;onlays
	jsr	doeye

	jsr	cpst		;cursor, points, score, threats, exit flag

	ldx	#N_DEST
	jsr	checktreasure

	lda	activefrs
	bne	.desertloop
;
	jsr	checkend	;gameover?
	bne	.exit

	jsr	waitclear
	jsr	docactuses

	jsr	levelcomp	;level completed

	lda	cursc		;set previous screen
	sta	prevsc
	lda	#MAP		;update current screen
	sta	cursc
.exit:
	rts
;
;	do cactuses, onlayed over desert scene
;
docactuses:

	setbaddr	CACTUS	;left
	lda	#0
	sta	curzon
	lda	#11
	sta	hpos
	ldpw	4,10
	sta	palwid
	lda	#5
	sta	destht
	lda	#1
	sta	srcht
	lda	#10
	sta	srcw
	jsr	tallobj

	lda	#(CACTUS + 10) & $FF	;right one shifted down 1 zone
	sta	baddrl
	lda	#4
	sta	destht
	lda	#110
	sta	hpos
	jsr	tallobj

	rts
;
;	do the jungle screen
;
dojungle:
	jsr	dogtrdy
;
;	make background
;
	maketall	juntall
	jsr	lockbkg
;
;	init friends
;
	jsr	initfrs
;
	jsr	initbag		;jungle treasure
;
;	enemys
;
	jsr	initchimps
	jsr	inittoc
	jsr	initplant
	jsr	initeye
;
;	setup interrupts
;
	jsr	waitbot
	setijt	INTZ9,intgrnd1
	setijt	INTZ3,intgrnd2

	jsr	dojunonlays	;ready on fadein
	ldx	#N_BAG
	jsr	dotreasure

	makesound	TOCANCRY
	jsr	fadeinwait
	makesound	TOCANCRY
;
;	jungle loop
;
.jungleloop:
;
;	high priority tasks
;
	jsr	waitclear
	ldx	#N_BAG
	jsr	dotreasure
	jsr	dofrs
	jsr	doplant
	jsr	dochimps
	jsr	dotoc
	jsr	dojunonlays	;jungle onlays
	jsr	doeye

	jsr	cpst		;cursor, points, score, threats

	ldx	#N_BAG
	jsr	checktreasure
;
	lda	activefrs
	bne	.jungleloop
;
;	exit seq
;
	jsr	checkend
	bne	.exit

	jsr	waitclear
	jsr	dojunonlays

	jsr	levelcomp

	lda	cursc		;set previous screen
	sta	prevsc
	lda	#MAP		;update current screen
	sta	cursc
.exit:	rts
;
;	do jungle onlays, treetops and ground veg
;
dojunonlays:
	setbaddr	JUN3	;rough tops of trees
	lda	#0
	sta	hpos
	lda	#9
	sta	curzon
	ldpw	BKGPAL,SCHWB
	sta	palwid
	jsr	mkhdr

	lda	#SCHWP
	sta	hpos
	jsr	mkhdr

	setbaddr	JUN4	;darkening leaves above
	inc	curzon
	ldpw	4,SCHWB
	sta	palwid
	jsr	mkhdr

	lda	#0
	sta	hpos
	jsr	mkhdr

	setbaddr	JUN2	;undergrowth onlay, top left half
	lda	#1
	sta	curzon
	ldpw	BKGPAL,SCHWB
	sta	palwid
	jsr	mkhdr

	lda	#(SCWP/4)*3	;top fourth quarter
	sta	hpos
	ldpw	BKGPAL,SCWB/4
	sta	palwid
	jsr	mkhdr

	lda	#(JUN2 + 10) & $FF	;top third quarter
	sta	baddrl
	lda	#SCHWP
	sta	hpos
	jsr	mkhdr

	setbaddr	C23	;bottom left half
	lda	#0
	sta	hpos
	dec	curzon
	ldpw	BKGPAL,SCHWB
	sta	palwid
	jsr	mkhdr

	lda	#SCHWP		;bottom right half
	sta	hpos
	jsr	mkhdr

	rts
;
;	do the castle screen
;
docastle:
	jsr	dogtrdy
;
;	make background
;
	maketall	castall
	makeheaders	casclouds
	jsr	lockbkg
;
;	init friends
;
	jsr	initfrs
;
;	enemys
;
	jsr	initarchers
	jsr	initptera
	jsr	initali2
	jsr	initeye
;
;	castle door
;
	jsr	initdoor
;
;	set interrupts
;
	setijt	INTZ6,intgrnd1

	jsr	dodoor	;ready on fadein
	jsr	fadeinwait
;
;	castle loop
;
.castleloop:
;
;	high priority tasks
;
	jsr	waitclear
	jsr	doeye
	jsr	dodoor		;drawbridge door
	jsr	dofrs		;do friends
	jsr	dowall		;the wall the frs walk behind
	jsr	doarchers
	jsr	doptera
	jsr	doali2

	jsr	cpst		;cursor, points, score, threats, exit flag
	bne	.castleloop
;
;	exit seq
;
	jsr	checkend
	bne	.exit

	jsr	waitclear
	jsr	dodoor
	jsr	levelcomp

	lda	cursc		;set previous screen
	sta	prevsc
	lda	#MAP		;update current screen
	sta	cursc
.exit:
	rts
;
;	do castle wall that friends walk behind
;
dowall:
	setbaddr	(CAS1 + 18 + 8)
	ldpw	BKGPAL,4
	sta	palwid
	lda	#18
	sta	srcw
	lda	#2
	sta	srcht
	lda	#3
	sta	destht
	lda	#2
	sta	curzon
	lda	#120
	sta	hpos
	jsr	tallobj
	rts
;
;	do the volcano screen
;
dovolcano:
	jsr	dogtrdy
;
;	background
;
	setbaddr	BM_VOLCANO
	jsr	mkbkg
	jsr	lockbkg
;
;	init movers
;
	jsr	initfrs
	jsr	initrocks
	jsr	initflrocks
	jsr	initvolups
	jsr	initltng
	jsr	initskyflash
	jsr	initdiamnd
	jsr	initbldr
	jsr	initeye
	jsr	initlriver

	setijt	INTZ5,intgrnd1

	ldx	#N_DIAMOND	;ready on fadein
	jsr	dotreasure
	jsr	dobldr

	makesound	BOOM
	jsr	fadeinwait
	makesound	BOOM

.volcanoloop:
;
;	high priority
;
	jsr	waitclear

	jsr	doeye
	jsr	doskyflash
	jsr	doltng
	jsr	dovolups
	jsr	dolriver
	jsr	dobldr
	ldx	#N_DIAMOND
	jsr	dotreasure
	jsr	dofrs
	jsr	doflrocks
	jsr	dorocks

	jsr	cpst		;cursor, points, score, threats

	ldx	#N_DIAMOND
	jsr	checktreasure

	lda	activefrs
	bne	.volcanoloop
;
;	terminate volcano screen
;
	lda	#GRAY		;clear skyflash
	sta	sky
	sta	fadsky
	lda	#RED-1		;clear mountain flash
	sta	P6C2

	jsr	checkend
	bne	.exit

	jsr	waitclear
	jsr	levelcomp

.exit:	lda	cursc		;set previous screen
	sta	prevsc
	lda	#MAP		;update current screen
	sta	cursc
	rts
;
;	sky flash
;
initskyflash:
	ldx	#N_SKYFLASH
	jsr	randt1
	lda	#FALSE
	sta	movid+N_SKYFLASH
	rts
doskyflash:
	lda	movid+N_SKYFLASH
	beq	.noton
	lda	#GRAY		;this should match volpal table sky color
	sta	fadsky
	bne	initskyflash	;always branch, target does rts
.noton:	dec	movt1+N_SKYFLASH
	bne	.exit
	lda	#WHITE		;time up .. flash the sky
	sta	fadsky
	lda	#TRUE
	sta	movid+N_SKYFLASH
	makesound	BOOM
.exit:	rts
;
;	do the bridge screen
;
dobridge:
	jsr	dogtrdy
;
;	make background
;
	setbaddr	BM_BRIDGE
	jsr	mkbkg
;
	jsr	lockbkg
;
;	init friends
;
	jsr	initfrs
;
;	enemys
;
	jsr	initfrog
	jsr	initfish
	jsr	initali
	jsr	initbeaver
	jsr	initowl
	jsr	initrockbri
	jsr	initbuzz
	jsr	initeye

	jsr	waitbot
	setijt	INTZ8,intgrnd1

	jsr	fadeinwait
;
;	bridge loop
;
.bridgeloop:
	jsr	waitclear
	jsr	doeye
	jsr	doali
	jsr	dofish
	jsr	dobeaver
	jsr	doowl
	jsr	dofrs		;do friend
	jsr	dorockbri
	jsr	dobuzz
	jsr	dobronlay	;bridge onlay
	jsr	dofrog

	jsr	cpst		;cursor, points, score, threats, exit flag
	bne	.bridgeloop

	jsr	checkend	;gameover?
	bne	.exit

	jsr	waitclear
	jsr	levelcomp

	lda	cursc
	sta	prevsc
	lda	#MAP		;update current screen
	sta	cursc
.exit:	rts
;
;	do bridge onlayed
;
dobronlay:

	setbaddr	BRONLAY	;left
	lda	#5
	sta	curzon
	lda	#0
	sta	hpos
	ldpw	6,SCHWB
	sta	palwid
	lda	#2
	sta	destht
	lda	#2
	sta	srcht
	lda	#SCHWB
	sta	srcw
	jsr	tallobj

	lda	#(BRONLAY + 20) & $FF	;right
	sta	baddrl
	lda	#SCHWP
	sta	hpos
	jsr	tallobj

	rts
;
;	do the room screen
;
doroom:
	jsr	dogtrdy
;
;	make background
;
	makeheaders	roohdrs

	jsr	lockbkg
;
;	init friends
;
	jsr	initfrs
;
;	enemys
;
	jsr	initeye
	jsr	initdaggers
	jsr	initdrag
	jsr	inittrap
	jsr	inittorches
	jsr	initchest
	jsr	initrdface
	jsr	initspear1
	jsr	initspear2
	jsr	initflsh
	jsr	initface1
	jsr	initface2

	ldx	#N_CHEST
	jsr	dotreasure		;ready on fade in
	jsr	dotorches
	makesound	CREAKY
	jsr	fadeinwait
;
;	room loop
;
.roomloop:
	jsr	waitclear
	jsr	doeye
	jsr	dotrap		;trap door
	jsr	doflsh
	ldx	#N_CHEST
	jsr	dotreasure
	jsr	doface1
	jsr	doface2
	jsr	dordface
	jsr	dotorches
	jsr	dofrs		;friends
	jsr	dodaggers	;enemies
	jsr	dospears
	jsr	dodrag

	jsr	cpst		;cursor, points, score, threats

	ldx	#N_CHEST
	jsr	checktreasure
;
	lda	activefrs
	bne	.roomloop

	jsr	checkend
	bne	.exit

	jsr	waitclear
	jsr	levelcomp

	lda	cursc		;set previous screen
	sta	prevsc
	lda	#FACE		;update current screen
	sta	cursc
.exit:
	rts
;
;	do the face screen
;
doface:
	jsr	dobeware
	jsr	setupsc
;
;	make background
;
	jsr	drawface
	jsr	drawfloor

	jsr	lockbkg
;
;	init friends
;
	jsr	initfrs
;
;	enemys
;
	jsr	initeyes

	jsr	doeyes	;ready on fadein
	makesound	HAHAHA
	jsr	fadeinwait
;
;	face loop
;
.faceloop:
	jsr	waitclear
	jsr	doeyes
	jsr	dofrs		;do friend
	jsr	dofds		;face daggers

	jsr	cpst		;cursor, points, score, threats
;
	lda	movsta+N_EYEL
	and	movsta+N_EYER
	bmi	finishquest	;target does rts

	lda	activefrs
	bne	.faceloop

	jsr	checkend
	bne	.exit

	jsr	waitclear
	jsr	doeyes

	jsr	levelcomp

	lda	#MAP		;update current screen
	sta	prevsc		;setting previous screen to map
	sta	cursc		;allows us to start from beginning again
.exit:
	rts
;
;	finish quest
;
finishquest:
.if	(EXAMINE = FALSE)
;
;	mark any joined friends survived
;
	ldy	#NUMBFRS-1
.loop1:	lda	frstat,y
	cmp	#JOINED
	bne	.skip
	lda	#SURVIVED
	sta	frstat,y
.skip:	dey
	bpl	.loop1
;
;	do skull animation
;
	jsr	waitbot
	jsr	clearsc		;erase face
	jsr	drawfloor	;redraw floor
	jsr	lockbkg

	lda	#$FF		;set clock to sync dissolve
	sta	clock
	lda	#$D8
	sta	mesclock	;message clock

	lda	#2		;set current message
	sta	curmes

	makesound	BOOM

	lda	#1		;dissolve direction
	sta	disdir
	lda	#0		;dissolve state
	sta	facefade
	jsr	setdissolve

.loop2:	jsr	drawdissolve

	lda	facefade
	cmp	#MAXFADE
	bne	.loop2

	lda	#ONESEC*2
	sta	clock

	makesound	BOOM
.loop3:	jsr	waitclear	;show only skull
	jsr	drawskull
	jsr	domessage
	jsr	dofrs
	jsr	doscore

	lda	clock
	bne	.loop3
	lda	#$FF		;dissolve direction
	sta	disdir
	sta	clock

.loop4:	jsr	drawdissolve

	lda	facefade
	bne	.loop4
;
;	play out fr walk until no friends
;
	jsr	waitclear
	jsr	drawface
	makeheaders	eyehdrs
	jsr	lockbkg
	jsr	domessage
	jsr	dofrs
	jsr	doscore

.loop5:	jsr	waitclear
	jsr	domessage
	jsr	dofrs
	jsr	doscore
	lda	activefrs
	bne	.loop5
;
;	screen end seq
;
	lda	#$25
	jsr	incsc
	lda	#$54
	jsr	incsc

	jsr	waitclear
	jsr	doscore
	makeheaders	hdrbns
	makesound	CLANKA
	makesound	CLANKB

	lda	#ONESEC*2
	jsr	waitalarm

	jsr	checkend
	bne	.exit

	jsr	waitclear

	jsr	levelcomp

	lda	#MAP		;update current screen
	sta	prevsc		;setting previous screen to map
	sta	cursc		;allows us to start from beginning again
.exit:
.endif
	rts
;
;	draw dissolve
;
drawdissolve:
	jsr	waitclear	;dissolve from face to skull
	jsr	dodissolve
	jsr	dostagger
	jsr	domessage
	jsr	dofrs
	jsr	doscore
	rts
;
;	do staggered draw of face and skull
;
dostagger:
	lda	clock
	and	#1
	beq	.face
;skull:
	jsr	drawskull
	rts
.face:
	jsr	drawface
	rts
;
;	do messages (you have .. try again..)
;
domessage:
	dec	mesclock
	bne	.draw
	dec	curmes	;twice for words
	dec	curmes
	bmi	.exit
	makesound	BOOM
.draw:
	ldx	curmes
	bmi	.exit
	lda	mestab,x
	sta	addrl
	lda	mestab+1,x
	sta	addrh
	jsr	readhdrs
.exit:
	rts
;
;	draw face floor
;
drawfloor:
	setbaddr	FFLOOR	;tiled floor
	ldpw	5,12
	sta	palwid
	lda	#12
	sta	srcw
	lda	#1
	sta	srcht
	lda	#3
	sta	destht
	lda	#0
	sta	curzon
	lda	#-3 & $FF
	sta	hpos
	jsr	tallobj

	lda	#-3 + (48*1)	;five repititions
	sta	hpos
	jsr	tallobj

	lda	#-3 + (48*2)
	sta	hpos
	jsr	tallobj

	lda	#-3 + (48*3)
	sta	hpos
	jsr	tallobj

	lda	#-3 + (48*4)
	sta	hpos
	jsr	tallobj
	rts
;
;	draw face
;
drawface:
	maketall	facetall
.if 0
	setbaddr	BM_FACE
	lda	#(SCWP - (22*4))/2	;center hpos
	sta	hpos
	ldpw	6,22
	sta	palwid
	lda	#22
	sta	srcw
	lda	#4
	sta	srcht
	lda	#8
	sta	destht
	lda	#4
	sta	curzon
	jsr	tallobj
.endif
	rts
;
;	draw skull
;
drawskull:
	maketall	skulltall
.if 0
	setbaddr	BM_SKULL
	lda	#((SCWP - (17*4))/2) + 3	;center hpos
	sta	hpos
	ldpw	2,17
	sta	palwid
	lda	#17
	sta	srcw
	lda	#4
	sta	srcht
	lda	#8
	sta	destht
	lda	#4
	sta	curzon
	jsr	tallobj
.endif
	rts
;
;	do dissolve from face to skull
;
dodissolve:
	lda	clock
	and	#%00001111
	beq	.changeit
	rts
.changeit:
	lda	facefade
	clc
	adc	disdir
	sta	facefade

setdissolve:
	lda	facefade
	sta	fadsta	;fade the face
	ldx	#(6*4)	;pal 6
	jsr	fadepal

	lda	#MAXFADE	;fade the skull
	sec
	sbc	facefade
	sta	fadsta
	ldx	#(2*4)	;pal 2
	jsr	fadepal

	lda	#0		;clear fadsta so subsequent fade will be right
	sta	fadsta
	rts
;
;	do "get ready" screen
;
dogtrdy:
	lda	idlemode	;if idle mode, skip "get ready"
	bne	.skipthis

	jsr	clearsc
	lda	#BLACK
	sta	sky
	setpal	0,1,YELLOW
	jsr	clrijt
	makeheaders	gtrdyhdr
	jsr	cutin
	lda	#ONESEC*3
	jsr	waitalarm
	jsr	cutout
.skipthis:
	jsr	setupsc		;altruistic act of this function to caller
	rts
;
;	do "beware" screen
;
dobeware:
	makesound	DRUM

	lda	#TITLE	;temp setting to title screen sets pals
	sta	cursc

	jsr	setupsc

	lda	#BLACK
	sta	sky

	lda	#FACE
	sta	cursc

	jsr	cutin
	makeheaders	bewarehdrs

	lda	#255
	jsr	waitalarm

	lda	#102
	jsr	waitalarm

	jsr	cutout
	rts
;
;	do end.. say "the end" or "gameover"
;
doend:
	jsr	comparesc	;compare hi score and current score
	bcs	.nonew		;if higher
	jsr	newhiscore	;make new high score
.nonew:
	lda	#TITLE
	sta	cursc

	jsr	setupsc

	makesound	CREAKY
	makeheaders	gmovrhdr
	jsr	titlerags

	setpal	6,1,YELLOW

	lda	#5	;display final score
	sta	curzon
	lda	#80
	sta	hpos
	ldpw	6,2
	sta	palwid
	jsr	drawscore
;
;	display high score
;
	ldy	#SCRDGTS-1	;copy current score to save buffer
.loop1:	lda	score,y
	sta	savescore,y
	dey
	bpl	.loop1

	ldy	#SCRDGTS-1	;copy hi score to score buffer
.loop2:	lda	hiscore,y
	sta	score,y
	dey
	bpl	.loop2

	lda	#3	;display hi score
	sta	curzon
	lda	#80
	sta	hpos
	ldpw	6,2
	sta	palwid
	jsr	drawscore

	ldy	#SCRDGTS-1	;copy saved current score back to score buffer
.loop3:	lda	savescore,y
	sta	score,y
	dey
	bpl	.loop3

	jsr	fadeinwait
	lda	#128
	jsr	waitalarm
	makesound	BOOM
	lda	#255
	jsr	waitalarm
	lda	#255
	jsr	waitalarm

	jsr	fadeoutwait
	rts
;
;	title screen style ragged edges
;
titlerags:
	maketall	raglr1
	makeheaders	ragudhdr
	rts
;
;	setupscreen
;	standard setup for interactive screens
;
setupsc:
	jsr	clrijt
	jsr	clearsc
	jsr	clrmsta		;clear moving object status to idle
	jsr	loadpals
	jsr	screenbank
	jsr	initcursor

	ldy	cursc
	lda	frypostab,y
	sta	frypos
	lda	fallevels,y	;enemy fall level where they die
	sta	fallevel
	lda	frlimits,y	;set walk limit before friend survives
	sta	frlimit
	lda	#FRNOSTOP	;for waiting for path enables like drawbridge
	sta	frstop
	lda	#0		;points display time
	sta	ptime
	sta	gottreasure
	sta	dropflag
	rts
;
;	do threats .. find collisions between dangerous enemies and friends.
;
dothreats:
;
;	check the cursor against the enemies
;
	lda	movsta+N_CURSOR	;if cursor not hot, skip
	and	#S_NOTHREAT
	bne	.donecursor

	ldy	#N_CURSOR	;y is cursor
	ldx	#N_CURSOR	;right before first enemy
.loop:
	inx			;first enemy
	txa
	cmp	#MAXMOV		;done?
	beq	.donecursor
	lda	movsta,x	;chk status bits
	and	#S_IDLE | S_INVULNERABLE
	bne	.loop

	jsr	coldet		;collision detect
	bcc	.loop

	jsr	dodeath		;yes! cursor hit something
.donecursor:	
;
;	check friends against threats (including cursor)
;
	ldy	#FRIEND1	;fr 1
.outerloop:
	lda	movsta,y	;check status
	and	#S_IDLE | S_INVULNERABLE
	bne	.donefr		;if idle or invulnerable, skip

	ldx	#1		;just before first enemy
.innerloop:
	inx			;next enemy
	txa			;
	cmp	#MAXMOV		;done?
	beq	.donefr
	lda	movsta,x	;active?
	and	#S_IDLE | S_NOTHREAT
	bne	.innerloop	;if idle or no threat, loop
	jsr	coldet		;collision detect
	bcc	.innerloop	;check for injured friend
	jsr	hurtfr

	jmp	.exit		;only one fr injury allowed
.donefr:
	dey			;point next fr
	bpl	.outerloop	;loop if no overflow
.exit:
.if 0
	lda	movsta+N_CURSOR	;if cursor still firing, means it hit nothing
	and	#S_NOTHREAT	;so make fire sound
	bne	.nosound
	makesound	FIRE
.nosound:
.endif
	rts
;
;	hurt friend
;	This func called when something dangerous hits a friend
;	FR in y reg, enemy (or cursor) in x reg
hurtfr:
	pushy
	pushx			;leaves x in acc

	cmp	#N_CURSOR	;injured by player?
	bne	.notcursor

	lda	movsta,x	;null cursor threat for subsequent target
	ora	#S_NOTHREAT
	sta	movsta,x

	lda	gavewarning	;already warned player?
	bne	.alreadywr
	makeheaders	hdrdntsht	;give first warning
	makesound	FIRE	;crossbow fire sound
	lda	#ONESEC*2
	sta	timer
	jsr	waitalarm
	lda	#TRUE
	sta	gavewarning
	jmp	.exit
.alreadywr:
;
;	friend has been shot by player and warning has already been issued
;
	lda	limptab,y	;already limping?
	bne	.alreadylp
	ldx	movid,y		;fr says "ouch"
	lda	frouchtab,x
	jsr	playsound
	lda	#TRUE		;mark fr limping
	sta	limptab,y
	bne	.exit		;always branch
.alreadylp:
;
;	enemy kills a friend
;
.notcursor:
	lda	#S_SETINIT		;flag to reinit killer
	sta	movsta,x
	lda	#1
	sta	movt1,x

	jsr	killfr
.exit:
	popx
	popy
	rts
;
;	kill friend, mov in y reg
;
killfr:
	ldx	movid,y		;friend cries out
	lda	frahtab,x
	jsr	playsound

	lda	#DIEING		;status
	sta	movsta,y
	lda	#1		;immediate update
	sta	movt1,y
	lda	#4		;above first frame of fire
	sta	movframe,y
	lda	#2
	sta	movht,y

	tya			;put mov in x reg
	tax
	ldy	#DEATHID	;special id for death flames
	jsr	setfrpal
	rts
;
;	do death of enemy
;	killer in y, victim in x
;
dodeath:
	lda	movsta,y	;null threat of killer
	ora	#S_NOTHREAT
	sta	movsta,y
	jsr	startdeath
	rts
;
;	start death seq, mov in x
;
startdeath:
	lda	#S_NOTHREAT | S_INVULNERABLE	;strip victim
	sta	movsta,x
	lda	movdseql,x	;start death sequence
	sta	movaniml,x
	lda	movdseqh,x
	sta	movanimh,x
	lda	#1		;flag for immediate update
	sta	movt1,x
	lda	#JUMPALWAYS
	sta	movloop,x
	rts	
;
;
;
.include	"coldet.s"
;coldet: goes here
;
;
;	clear moving object status .. set them all to inactive
;
clrmsta:
	ldy	#MAXMOV-1
	lda	#S_HANG
.loop:	sta	movsta,y
	dey
	bpl	.loop
	rts
;
;	screenbank
;	use cursc to lookup ROM bank, and switch
;
screenbank:
	ldy	cursc
	lda	banktab,y
	sta	BANKSW
	rts
;
;	transfer pal, source in y reg, dest in x reg
;	increments regs
;
transpal:
	inx			;skip control reg shadow

	lda	(haddrl),y	;c1
	sta	palshad,x
	inx
	iny

	lda	(haddrl),y	;c2
	sta	palshad,x
	inx
	iny

	lda	(haddrl),y	;c3
	sta	palshad,x
	inx
	iny

	rts
;
;	load pals .. reads global cursc, looks up addr of pal data, loads
;	pal data into shadow pals
;
loadpals:
	lda	cursc		;get par
	asl			;point to words
	tax			;index
	lda	SCPALTAB,x	;low byte
	sta	haddrl
	lda	SCPALTAB+1,x	;high byte
	sta	haddrh

	ldy	#0		;source index first table byte
	ldx	#8		;dest index first palshad byte of pal 2

	jsr	transpal	;transfer pals 2 .. 7
	jsr	transpal	;(pals 0 .. 1 for frs)
	jsr	transpal
	jsr	transpal
	jsr	transpal
	jsr	transpal

	lda	(haddrl),y	;backgrounds
	sta	sky
	iny
	lda	(haddrl),y
	sta	ground1
	iny
	lda	(haddrl),y
	sta	ground2
	rts
;
;	start of game logic subroutines
;
;	level completed routine
;	who survived, new friends, etc
levelcomp:

	ldx	cursc		;register that we were here
	inc	beenhere,x

	cpx	#FACE			;if not face screen
	beq	.skipmessage
	makeheaders	hdrlvlcmp	;say "level completed"
.skipmessage:

	jsr	lockbkg

	jsr	doscore			;show score

	lda	#ONESEC
	jsr	waitalarm

	jsr	clrmov

	makeheaders	hdrsrvbns	;survival bonus window

	jsr	lockbkg

;	go through roster of friends to see who survived

	lda	#NUMBFRS	;show survivals to player
	sta	curfr
.loop1:	dec	curfr
	bmi	break20		;done?
	ldy	curfr
	lda	frstat,y
	cmp	#SURVIVED
	bne	.loop1		;not survived?

				;survived
	lda	#JOINED		;update his stat for next sc
	sta	frstat,y

	ldx	#0
	ldy	curfr
	jsr	setfrpal

	jsr	clrmov

	lda	#35		;draw new icon
	sta	hpos
	lda	#32
	sta	vpos
	ldpw	0,FRWB
	sta	palwid
	jsr	xdrawfr
	lda	#$14	;add 10000 to score
	jsr	incsc
	jsr	doscore
	makesound	CLANKA
	makesound	CLANKB

	lda	#50
	jsr	waitalarm
	jmp	.loop1

break20:		;done with survival bonuses

;
;	find and echo the new friend
;
;	lookup new friend for this screen
	ldx	cursc
	ldy	newfrtab,x
;
;	leave if no new friend for this screen
	bmi	skipnewfr

;	leave if this friend not potential anymore
	lda	frstat,y
	cmp	#POTENTIAL
	bne	skipnewfr

;	set this friend's status
	lda	#JOINED
	sta	frstat,y
	sty	curfr

	makeheaders	hdrnewfr	;new friend window

;	draw new friend
	ldx	#1
	ldy	curfr
	jsr	setfrpal

	lda	#115		;draw icon
	sta	hpos
	lda	#32
	sta	vpos
	ldpw	1,FRWB
	sta	palwid
	jsr	xdrawfr
	makesound	CLANK2A
	makesound	CLANK2B

skipnewfr:
	lda	#50
	jsr	waitalarm
	rts
;
;	check end of screen to see if game over
;	exit with gameover var in acc
checkend:
;
;	see if any friends survived
;
	lda	idlemode	;if idlemode, set gameover
	bne	.nosurvivors
	ldy	#NUMBFRS
.loop:	dey
	bmi	.nosurvivors		;done?
	lda	frstat,y
	cmp	#SURVIVED
	bne	.loop		;not survived?
	rts			;zero flag set, tested as return value
.nosurvivors:
	lda	#TRUE
	sta	gameover
	rts
;
;	draw friend
;	give it curfr, hpos, curzon
xdrawfr:
	lda	curfr	;fr id
	tax		;get height
	lda	frhts,x
	sta	srcht

	lda	curfr	;get bitmap addr
	asl		;times 8
	asl
	asl
	clc
	adc	#6	;get standing frame
	tax
	lda	fftab,x
	sta	baddrl
	lda	#HER >> 8
	sta	baddrh

	jsr	xvermov
	rts
;
;	do switches
;
dosw:
	lda	idlemode
	beq	.nofire
*
*** added by dave 5-Jul-88 ***
*
*  New stuff added by Dave S. to start-up a game via gun
*
	lda	gun		;are we in gun mode?
	beq	.notgun		;br if not--just do previous stuff
	lda	SWCHA		;else, check gun trigger
	and	#$10		;it's like a joystick "UP" switch
	beq	.nofire		;br if not actuated
	bne	.gunfire	;else, always br to start-up game
.notgun:
*
****  end of Dave S. additions *****
*
*
	lda	INPT4	;if not play mode and fire button down, start play
	bmi	.nofire
.gunfire:
	lda	#FALSE
	sta	activefrs
	sta	idlemode
.nofire:
	lda	SWCHA	;check joystick
	cmp	oldjs
	bne	newjs
	lda	SWCHB	;check console
	cmp	oldsw
	bne	newcon
	rts		;return if no switches changed
newjs:
	sta	oldjs		;save
	eor	#$FF
	tax
	and	#%10000000
	sta	right
	txa
	and	#%01000000
	sta	left
	txa
	and	#%00010000
	sta	up
	txa
	and	#%00100000
	sta	down
	rts
newcon:
	sta	oldsw

	lda	#RESET
	bit	oldsw
	bne	noreset
	jmp	restart
noreset:
	lda	#PAUSE
	bit	oldsw
	bne	nopause

	lda	pauseon		;handle descent of PAUSE button
	eor	#$FF
	sta	pauseon
	bne	enterpause
	lda	#$FF	;exit pause
	sta	soundon
	ldx	#0
	lda	audvshadow,x
	jsr	setav
	ldx	#1
	lda	audvshadow,x
	jsr	setav
	rts
enterpause:
	lda	#0	;enter pause
	sta	soundon
	sta	AUDV0
	sta	AUDV1
	rts
nopause:
	lda	#SELECT		;select button down?
	bit	oldsw
	bne	.noselect

.if EXAMINE
	jmp	doex
.endif
	lda	cursc
	cmp	#TITLE		;if not title screen, ignore select
	beq	.selectgun
	jmp	restart0
.selectgun:
	lda	gun		;toggle gun flag
	eor	#$FF
	sta	gun
	jmp	showselect	;target does rts
.noselect:
	rts
;
;	show select .. gun or stick?
;
showselect:
	lda	gun
	beq	.stick
;gun:
	resetpal	5,2,WHITE
	resetpal	5,3,BLACK
	rts	
.stick:
	resetpal	5,3,WHITE
	resetpal	5,2,BLACK
	rts
;
;	do examine (look at a video bank)
;
.if EXAMINE
doex:
;	lda	#7		;set the bank
;	sta	BANKSW

	lda	#0
	sta	xpos
	sta	ypos

	jsr	fadeoutwait

	jsr	clrijt

	lda	#BLACK
	sta	sky

	setpal	7,1,BLUE
	setpal	7,2,GRAY
	setpal	7,3,WHITE

	jsr	clearsc
	jsr	fadein

.loop:	jsr	waitclear
	jsr	setex
	jsr	dofades
	lda	right
	beq	.notright
	inc	xpos
.notright:
	lda	left
	beq	.notleft
	dec	xpos
.notleft:
	lda	up
	beq	.notup
	inc	ypos
.notup:
	lda	down
	beq	.notdown
	dec	ypos
.notdown:
	jmp	.loop
;
;	set examine
;
setex:	lda	#$80
	sta	baddrh
	lda	xpos
	sta	baddrl
	ldpw	7,31
	sta	palwid
	lda	#((160-(31*4))/2)
	sta	hpos
	lda	#4
	sta	curzon
	lda	#4
	sta	destht
	lda	#4
	sta	srcht
	lda	#31
	sta	srcw
	jsr	tallobj
	rts
.endif
;
;	inc score, only by integer times power of 10
;	input data in A reg, format: low nib: exponent, hi nib: mantissa
;	uses x and y regs
incsc:
	ldy	idlemode	;if idle, no score
	bne	.exit

	pha			;save input
	and	#%00001111	;mask exp
	tay			;set indexes
	tax
;
;	clear leading zeroes from here to ones place
;
.loop1:
	lda	score,y
	cmp	#LDZERO
	bne	.break
	lda	#0
	sta	score,y
	dey
	beq	.break
	bne	.loop1
.break:
;
;	add and carry
;
	pla			;get mantissa
	lsr
	lsr
	lsr
	lsr

.loop2:	clc			;carry amount is now in acc
	adc	score,x
	sta	score,x
	cmp	#10
	bmi	.nocarry
	lda	#0
	sta	score,x
	inx			;next higher digit
	txa			;avoid overflow
	cmp	#SCRDGTS
	bpl	.nocarry
	lda	score,x		;if target is ldzero, make it #1 and rts
	cmp	#LDZERO
	bne	.notldzero
	lda	#1
	sta	score,x
.exit:	rts
.notldzero:
	lda	#1		;carry a 1
	bne	.loop2	
.nocarry:
	rts
;
;	cursor, points, score, threats
;
cpst:
	jsr	docursor
	jsr	drawpoints
	jsr	doscore
	jsr	setcursor
	jsr	dothreats
	lda	activefrs	;also set exit flag
	rts
;
;	score value table. Input: score index, Output, score value
;	this makes a blank leading zero ($F) = 0
scorevals:
	.dc.b	0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0
;
;	compare score
;	return carry clear if current score greater than hi score
comparesc:
	ldy	#SCRDGTS-1	;index high digit
.loop:	ldx	hiscore,y	;read score digit
	lda	scorevals,x	;load absolute digit value
	ldx	score,y		;read hiscore digit
	cmp	scorevals,x	;compare values
	bne	.exit		;if new score different from old hi, return
.nexty:
	dey			;else loop
	bpl	.loop		;and return carry set (by above) if done
	sec	
.exit:
	rts
;
;	new high score .. copy current score to high score
;
newhiscore:
	ldy	#SCRDGTS-1	;index top digit
.loop:	lda	score,y
	sta	hiscore,y
	dey
	bpl	.loop
	rts
;
;	do score: draw it once at bottom center of screen
;
doscore:
	lda	#((SCWP-(DGTWP*SCRDGTS))/2)	;init hdr pars
	sta	hpos
	ldpw	7,2
	sta	palwid
	lda	#0
	sta	curzon
	jsr	drawscore
	rts
;
;	draw score: put it where needed, in specified pal
;	give it hpos,palwid,curzon
;
drawscore:
	ldy	#SCRDGTS-1	;loop counter
.loop:	lda	score,y		;lookup baddr in table
	tax
	lda	numadt,x
	sta	baddrl
	lda	#ZERO >> 8
	sta	baddrh
	pushy
	jsr	mkhdr		;make header
	popy
	lda	hpos		;inc hpos
	clc
	adc	#DGTWP
	sta	hpos
	dey			;dec loop count
	bpl	.loop
	rts
;
;	draw points .. where an enemy has been killed
;
drawpoints:
	lda	ptime
	beq	.exit

	dec	ptime
	lda	paddrl		;baddrl
	sta	baddrl
	lda	#POINTS >> 8	;baddrh
	sta	baddrh
	lda	ppalwid		;palwid
	sta	palwid
	lda	phpos		;hpos
	sta	hpos
	lda	pvpos		;vpos
	sta	vpos
	lda	#1		;srcht
	sta	srcht
	jsr	xvermov
.exit:
	rts
;
;	init friends
;
initfrs:
	lda	#0		;init active frs count
	sta	activefrs
;
;	friend0
;
	ldy	#NUMBFRS	;search for friend
.fr0loop:
	dey

	lda	frstat,y
	cmp	#JOINED
	bne	.fr0loop

	pushy			;fr found! init
	ldx	#FRIEND0
	jsr	initfr
	popy

	lda	cursc		;if face screen, only 1 fr
	cmp	#FACE
	beq	.onefr
;
;	friend1
;
.fr1loop:
	dey			;continue search for friend
	bmi	.onefr
	lda	frstat,y
	cmp	#JOINED
	bne	.fr1loop		;not joined

	ldx	#FRIEND1	;create fr 1
	jsr	initfr

	jsr	rand		;rand idle status 0 .. 8 sec
	ora	#%11111000
	sta	movsta,x
	jsr	randt1		;rand start time 0 .. 4 sec
	rts
;
;	here if only fr0 active
;
.onefr:
	ldx	#FRIEND1
	lda	#S_HANG
	sta	movsta,x
	rts
;
;	init friend
;	mov in X, id in Y
initfr:
	lda	#FALSE			;clear limp
	sta	limptab,x

	inc	activefrs

	lda	#WALKING		;assume stat walking
	sta	movsta,x
	tya				;id
	sta	movid,x
	lda	#0			;frame
	sta	movframe,x
	lda	#HER >> 8		;baddrh
	sta	movfrh,x

	pushy
	jsr	randt1			;randomized start time
	popy

	lda	#((-FRWP) & $FF)	;initial position
	sta	movx,x
	lda	frypos			;set his vertical pos
	sta	movy,x
	lda	#FRWB			;width
	sta	movw,x
	lda	frhts,y		;table lookup height
	sta	movht,x

	lda	#CROSSING	;use id in y
	sta	frstat,y
;
;	if face screen, start fr falling
;
	lda	cursc		;is this screen
	cmp	#FACE		;face?
	bne	.notface	;no, skip
	lda	#SCHL		;set y above screen
	sta	movy,x
	lda	#FALLHPOS	;set x onscreen
	sta	movx,x
	lda	#FALLING	;set status to falling
	sta	movsta,x
	lda	#FALLTIME	;frame time
	sta	movt1,x
.notface:

	jsr	setfrpal
	rts
;
;	set friend pal, id in y reg, mov in x reg
;
setfrpal:
	pushx

	tya		;calc source pal from id
	asl		;4 bytes per pal
	asl
	tay

	txa		;calc dest pal from mov
	asl		;4 bytes per pal
	asl
	tax

	inx			;color 1
	iny
	lda	frpaltab,y
	sta	palshad,x
	sta	PALS,x

	inx			;color 2
	iny
	lda	frpaltab,y
	sta	palshad,x
	sta	PALS,x

	inx			;color 3
	iny
	lda	frpaltab,y
	sta	palshad,x
	sta	PALS,x

	popx
	rts	
;
;	do friends
;
dofrs:
	ldpw	0,FRWB
	sta	palwid
	ldx	#FRIEND0	;first friend
	jsr	dofr

	ldpw	1,FRWB
	sta	palwid
	ldx	#FRIEND1	;second friend
	jsr	dofr
;
;	see if any fr is waiting
;
	lda	#FALSE		;assume false
	sta	frwait

	lda	movx+FRIEND0
	cmp	frstop
	bne	.try1
	lda	movsta+FRIEND0
	bpl	.rettrue
.try1:
	lda	movx+FRIEND1
	cmp	frstop
	bne	.exit
	lda	movsta+FRIEND1
	bmi	.exit
.rettrue:
	lda	#TRUE
	sta	frwait
.exit:	rts
;
;	do one friend
;	ord of friend in x reg
;	uses y reg
;	clobbers all regs
;
dofr:	dec	movt1,x		;update?
	bne	.frnoup
	lda	movsta,x	;active?
	bmi	.fridle
	bne	.notwalking	;walking?
;
;	fr walking
;
.walking:
	lda	movx,x	;see if stopped by obstacle
	cmp	frstop
	bne	.notstopped
;
;	fr stopped
;
	lda	#6		;stopped, set standing frame
	sta	movframe,x
	lda	#13		;reset time
	sta	movt1,x
	lda	dropflag	;drop thru trap door?
	bne	.startdrop	;if not dropping, draw
	jmp	.drawfr
.startdrop:
	lda	#DROPPING	;set status to ..
	sta	movsta,x
	jmp	.dropping
.notstopped:
	lda	movx,x	;inc, check for this friend done
	clc
	adc	#2
	sta	movx,x
	cmp	frlimit
	bne	.frnocomp
	lda	#SURVIVED	;YES! friend completed
	jsr	nextfr
	rts
.frnocomp:
	ldy	movframe,x	;limp or don't limp depends on timing table
	lda	limptab,x	;selected
	beq	.nolimp
;limp:
	lda	limpwalk,y
	bne	.donelimp	;branch always
.nolimp:
	lda	okwalk,y
.donelimp:
	sta	movt1,x
	dec	movframe,x
	bpl	.nowrap
	lda	#5		;wrap walk cycle
	sta	movframe,x
.nowrap:
	jmp	.drawfr
;
;	fr idle
;
.fridle:
	cmp	#S_HANG
	beq	.hung		;if not hung,
	inc	movsta,x	;inc inactive status
.hung:
	lda	#ONESEC
	sta	movt1,x
	rts
;
;	fr no update (just draw)
;
.frnoup:
	lda	movsta,x	;abort if idle
	bmi	.nodraw
	jmp	.drawfr2
.nodraw:
	rts
;
;	not walkng .. switch on status
;
.notwalking:
	cmp	#DIEING
	beq	.dieing
	cmp	#DROPPING	;in room screen, dropping thru trap door
	beq	.dropping
;
;	only alternative is:
;	fr falling in face screen
;
.falling:
	lda	movy,x		;move friend down one zone
	sec
	sbc	#ZONEHL
	sta	movy,x
	cmp	frypos
	beq	.donefalling	;done falling?
	lda	#FALLTIME	;set time
	sta	movt1,x
	jmp	.drawfr
.donefalling:
	lda	#WALKING	;reset to walking stat
	sta	movsta,x
	lda	#0
	sta	movframe,x
	lda	#14
	sta	movt1,x
	jmp	.walking
;
;	fr dieing in flames
;
.dieing:
	lda	movframe,x	;if done dieing, nextfr
	bne	.contdie
	lda	#DEAD
	jsr	nextfr
	rts
.contdie:
	lda	#14		;reset time
	sta	movt1,x
	dec	movframe,x	;next frame
	lda	movframe,x	;lookup bitmap address
	asl
	tay
	lda	frdietab,y
	sta	movfrl,x
	jmp	.drawfr2	;draw it
;
;	fr dropping down trap door
;
.dropping:
	dec	movht,x		;show only upper portion of fr
	beq	.donedrop	;done if no fr left
	lda	movfrh,x	;inc baddrh to show upper part
	clc
	adc	#$10
	sta	movfrh,x
	lda	#6
	sta	movt1,x
	inc	movx,x
	inc	movx,x
	jmp	.drawfr2
.donedrop:			;fr has finished dropping thru trap door
	lda	#SURVIVED
	jsr	nextfr
	rts
.drawfr:
;
;	calc bitmap addr from id and frame number
;
	lda	movid,x		;get guy's identity
	asl
	asl
	asl			;shift left by number of frames per guy
	clc
	adc	movframe,x	;add for which frame
	tay

	lda	fftab,y		;read table
	sta	movfrl,x
	lda	#HER >> 8	;constant page address
	sta	movfrh,x
;
;	xvermov call
;
.drawfr2:
	lda	movfrl,x
	sta	baddrl
	lda	movfrh,x
	sta	baddrh
	lda	movy,x
	sta	vpos
	lda	movx,x
	sta	hpos
	lda	movht,x
	sta	srcht
	jsr	xvermov

	rts	
;
;	next friend .. a friend has completed, so who's next?
;	call with mov in x reg, new status in acc
;
nextfr:
	dec	activefrs	;one less friend active

	ldy	movid,x		;put friend identity in y reg
	sta	frstat,y	;store new status
;
;	look for next party member
;
	ldy	#NUMBFRS-1
.loop:	lda	frstat,y
	cmp	#JOINED
	beq	.newfr
	dey
	bpl	.loop
				;no more friends for this screen
				;null this mover
	lda	#S_HANG		;set status to inactive
	sta	movsta,x
	lda	#ONESEC
	sta	movt1,x
	rts

.newfr:
	jsr	initfr
	rts
;
;	init scorpion
;
initscorp:
	ldx	#N_SCORP
	makeaniminit	scorpinit
	jsr	harder
	rts
;
;	do scorpion
;
doscorp:
	ldx	#N_SCORP
	jsr	checkreinit
	beq	initscorp	;target does rts
	jsr	doanim
	rts
;
;	init ghost
;
initghost:
	ldx	#N_GHOST
	makeaniminit	ghostinit
	jsr	rand63
	adc	movy+N_GHOST
	sta	movy+N_GHOST
	lda	#$FF			;id controls up or down movement
	sta	movid+N_GHOST
	jsr	harder
	rts
;
;	do ghost
;
doghost:
	ldx	#N_GHOST
	jsr	falldeath
	bcs	initghost	;target does rts

	lda	movsta+N_GHOST	;see if dead
	and	#S_NOTHREAT
	bne	.ghostok
;ghostalive
	lda	movy+N_GHOST
	cmp	#ZONEHL*3	;see if too low
	bcs	.notlow
;low
	lda	#1		;too low, start rising
	sta	movid+N_GHOST
.notlow:
	lda	clock		;change height every other field
	and	#1
	beq	.nomove
	lda	movid+N_GHOST
	clc
	adc	movy+N_GHOST
	sta	movy+N_GHOST
.nomove:
	lda	movx+N_GHOST	;reinit if finished crossing
	tay
	cmp	#-(5*4) & $FF	;offscreen to left?
	bcs	.ghostok
	tya
	cmp	#SCWP+1		;offscreen to right?
	bcs	initghost	;target does rts
	bcc	.ghostok
.ghostok:
	jsr	doanim		;checked ok
	rts
;
;	init bolt
;
initbolt:
	ldx	#N_BOLT
	makeaniminit	boltinit
	jsr	rand63		;random x pos
	adc	#(-8) & $FF
	sta	movx+N_BOLT
	rts
dobolt:
	ldx	#N_BOLT		;check for reset
	jsr	falldeath
	bcs	initbolt

	jsr	doanim
	rts
;
;	init wolf
;
initwolf:
	ldx	#N_WOLF
	makeaniminit	wolfinit
	jsr	rand140x		;set random h pos
	rts
;	
;	do wolf
;
dowolf:
	ldx	#N_WOLF
	jsr	checkreinit
	beq	initwolf	;initwolf performs rts
	jsr	doanim
	rts
;
;	init eye
;
initeye:
	ldx	#N_EYE
	makeaniminit	eyeseqinit
	rts
;	
;	do eye
;
doeye:
	ldx	#N_EYE
	jsr	doanim
	rts
;
;	town wiz and fireball
;
initwiz:
	ldx	#N_WIZ
	makeaniminit	wizinit
	jsr	harder
initfrball:
	ldx	#N_FRBALL
	makeaniminit	frballinit
	rts
dowiz:
	ldx	#N_FRBALL
	jsr	falldeath
	bcc	.noreinit
	jsr	initfrball
.noreinit:
	ldx	#N_WIZ		;launch frball
	ldy	#N_FRBALL
	jsr	dolaunch

	jsr	doanim		;wiz anim

	ldx	#N_FRBALL	;frball anim
	jsr	doanim
	rts
;
;	bridge fish
;
initfish:
	ldx	#N_FISH
	makeaniminit	fishinit
	jsr	rand		;put fish randomly at various pos
	and	#%00000011
	tay
	lda	fishx,y
	sta	movx,x
	lda	fishy,y
	sta	movy,x
	rts
dofish:
	ldx	#N_FISH
	jsr	checkreinit
	beq	initfish	;target does rts	
	jsr	doanim
	rts
;
;	init frog
;
initfrog:
	ldx	#N_FROG
	makeaniminit	froginit
	rts
;	
;	do frog
;
dofrog:
	ldx	#N_FROG
	jsr	checkreinit
	beq	initfrog	;target does rts
	jsr	doanim
	rts
;
;	init rock (bridge)
;
initrockbri:
	ldx	#N_ROCKBRI
	makeaniminit	rockbriinit
	jsr	harder
	rts
dorockbri:
	ldx	#N_ROCKBRI
	jsr	checkreinit
	beq	initrockbri	;target does rts
	jsr	doanim
	rts
;
;	init buzzard
;
initbuzz:
	ldx	#N_BUZZ
	makeaniminit	buzzinit
	jsr	harder
	rts
;
;	do buzzard
;
dobuzz:
	ldx	#N_BUZZ
	jsr	falldeath
	bcs	initbuzz	;target does rts
	jsr	doanim
	rts
;
;	init aligator
;
initali:
	ldx	#N_ALI
	makeaniminit	aliinit
	rts
;
;	do alligator
;
doali:
	ldx	#N_ALI
	jsr	checkreinit
	beq	initali		;target does rts
	jsr	doanim
	rts
;
;	init aligator 2 (castle)
;
initali2:
	ldx	#N_ALI2
	makeaniminit	ali2init
	rts
;
;	do alligator 2 (castle)
;
doali2:
	ldx	#N_ALI2
	jsr	checkreinit
	beq	initali2	;target does rts
	jsr	doanim
	rts
;
;	init beaver
;
initbeaver:
	ldx	#N_BEAVER
	makeaniminit	beaverinit
	rts
;
;	do beaver
;
dobeaver:
	ldx	#N_BEAVER
	jsr	checkreinit
	beq	initbeaver		;target does rts
	jsr	doanim
	rts
;
;	init owl
;
initowl:
	ldx	#N_OWL
	makeaniminit	owlinit
	rts
;
;	do owl
;
doowl:
	ldx	#N_OWL
	jsr	checkreinit
	beq	initowl		;target does rts
	jsr	doanim
	rts
;
;	volcano animations
;
;
;	init rocks
;
initrocks:
	ldx	#N_ROCK1
	jsr	initrock
	ldx	#N_ROCK2
	jsr	initrock
	rts
;
;	init rock
;
initrock:
	makeaniminit	rockinit
	jsr	randxth		;set random xpos, time, harder
	rts
;
;	do rocks
;
dorocks:
	ldx	#N_ROCK1
	jsr	dorock
	ldx	#N_ROCK2
	jsr	dorock
	rts
;	
;	do rock
;
dorock:
	jsr	checkreinit
	beq	initrock	;target does rts
	jsr	doanim
	rts
;
;	init flaming rocks
;
initflrocks:
	ldx	#N_FLROCK1
	jsr	initflrock
	ldx	#N_FLROCK2
	jsr	initflrock
	rts
;
;	init flaming rock
;
initflrock:
	makeaniminit	flrockinit
	jsr	randxth		;rand x, t1, harder
	rts
;
;	do flaming rocks
;
doflrocks:
	ldx	#N_FLROCK1
	jsr	doflrock
	ldx	#N_FLROCK2
	jsr	doflrock
	rts
;
;	do flaming rock
;
doflrock:
	jsr	checkreinit
	beq	initflrock	;target does rts
	jsr	doanim
	rts
;
;	treasure code
;
;	cave treasure
;
initcavet:
	ldx	#N_CAVET
	makeaniminit	ctinit
	rts
;
;	bag treasure (jungle)
;
initbag:
	ldx	#N_BAG
	makeaniminit	baginit
	rts
;
;	desert treasure
;
initdest:
	ldx	#N_DEST
	makeaniminit	destinit
	rts
;
;	town treasure
;
inittownt:
	ldx	#N_TOWNT
	makeaniminit	ttinit
	rts
;
;	init chest treasure
;
initchest:
	ldx	#N_CHEST
	makeaniminit	chestinit
	rts
;
;	init diamond treasure
;
initdiamnd:
	ldx	#N_DIAMOND
	makeaniminit	diamndinit
	rts
;
;	generic do treasures
;
dotreasure:
	lda	movsta,x	;if treasure status idle, quit
	bmi	.exit
	lda	gottreasure	;if treasure not gotten, just draw
	beq	.notgot
	jsr	startdeath
.notgot:
	jsr	doanim
.exit:	rts
;
;	check treasure .. returns TRUE if friend touches treasure
;	call with mov in X reg
;
checktreasure:
	lda	gottreasure
	bne	.exitfalse
	lda	movsta+FRIEND0
	bmi	.fr0idle
	ldy	#FRIEND0
	jsr	coldet
	bcs	.exittrue
.fr0idle:
	lda	movsta+FRIEND1
	bmi	.exitfalse
	ldy	#FRIEND1
	jsr	coldet
	bcc	.exitfalse
.exittrue:
	lda	#TRUE
	sta	gottreasure
.exitfalse:
	rts
;
;	init boulder that allows friends to walk
;
initbldr:
	ldx	#N_BLDR
	makeaniminit	bldrinit
	lda	#30
	sta	frstop
	rts
;
;	do boulder
;
dobldr:
	ldx	#N_BLDR
	jsr	dostoptime	;if frs stopped too long, drop boulder
	bcc	.cont
	makeanim	bldrdseq2
.cont:
	lda	movsta + N_BLDR	;has it fallen yet?
	and	#S_INVULNERABLE
	beq	.stillup
	lda	#FRNOSTOP	;YES! clear friend stop
	sta	frstop
.stillup:
	jsr	doanim
	rts
;
;	init volcano up flares
;
initvolups:
	ldx	N_VOLUP1
	jsr	initvolup
	ldx	N_VOLUP2
	jsr	initvolup
	rts
initvolup:
	makeaniminit	volupinit
	jsr	rand63			;random wait time
	sta	movt1,x
	and	#%00000111		;rand x pos
	pha
	clc
	adc	movx,x
	sta	movx,x
	pla
	tay		;random left, right angle
	lda	flangles,y
	sta	movid,x
	rts
flangles:	.dc.b	$FF,$FF,$FF,0,0,1,1,1
;
;	do flares
;
dovolups:
	ldx	#N_VOLUP1
	jsr	dovolup
	ldx	#N_VOLUP2
	jsr	dovolup
	rts
dovolup:
	lda	movsta,x
	bmi	.inactive	;if active, shift in x every 4 fields
	lda	clock
	and	#%00000011
	bne	.noshift
	lda	movx,x
	clc
	adc	movid,x
	sta	movx,x
.inactive:
	jsr	checkreinit
	beq	initvolup	;target does rts
.noshift:
	jsr	doanim
	rts
;
;	lightning
;
initltng:
	ldx	#N_LTNG
	makeaniminit	ltnginit
	jsr	randt1
	rts
;
;	do lightning
;
doltng:
	ldx	#N_LTNG
	jsr	checkreinit
	beq	initltng	;target does rts
	jsr	doanim
	lda	#RED-1		;set the mountain color (match to volpal table)
	sta	P6C2		;pal 6 color 2
	lda	movsta+N_LTNG	;read lightning status
	bmi	.exit
	lda	#WHITE		;if active turn mountains white
	sta	P6C2
.exit:	rts
;
;	lava river
;
initlriver:
	ldx	#N_LRIVER
	makeaniminit	lriverinit
	rts
dolriver:
	ldx	#N_LRIVER
	jsr	doanim
	rts
;
;	room daggers
;
initdaggers:
	ldx	#N_DAGGER1
	jsr	initdagger
	ldx	#N_DAGGER2
	jsr	initdagger
	ldx	#N_DAGGER3
	jsr	initdagger
	rts
initdagger:
	makeaniminit	daggerinit

	jsr	rand		;random x pos
	and	#%00011111
	adc	#10
	sta	movx,x
	jsr	randt1		;random start time
	jsr	harder
	rts
dodaggers:
	ldx	#N_DAGGER1
	jsr	dodagger
	ldx	#N_DAGGER2
	jsr	dodagger
	ldx	#N_DAGGER3
	jsr	dodagger
	rts
dodagger:
	jsr	falldeath
	bcs	initdagger	;target does rts
	jsr	doanim
	rts
;
;	face daggers
;
initfd:
	txa		;read lookup table to select seq
	sec
	sbc	#N_FD1
	asl
	tay
	lda	fdtab,y
	sta	animl
	lda	fdtab+1,y
	sta	animh
	jsr	doaniminit
	rts
;
;
;
dofds:
	jsr	rand		;randomly launch left or right
	bcs	.rightfirst
;leftfirst:
	ldy	#N_EYEL		;to check for launch
	jsr	fdlaunch
	ldy	#N_EYER
	bne	.leftdone	;branch always
.rightfirst:
	ldy	#N_EYER
	jsr	fdlaunch
	ldy	#N_EYEL
.leftdone:
	jsr	fdlaunch

	ldx	#N_FD1		;animate all the face daggers
.loop:	pushx
	jsr	doanim
	popx
	inx
	cpx	#N_FD16 + 1
	bmi	.loop

	rts
;
;	face dagger launch .. eye in y
;
fdlaunch:
	lda	movsta,y
	cmp	#N_FD1		;if eye has valid fd mov
	bmi	.exit
	cmp	#N_FD16 + 1
	bpl	.exit
	tax
	lda	movsta,x	;and target dag idle
	bpl	.exit

	pushy
	jsr	initfd		;init it!
	popy
	lda	#0		;turn it on
	sta	movsta,x
	lda	#1
	sta	movt1,x
	lda	movx,y		;copy x and y
	sta	movx,x
	lda	movy,y
	sta	movy,x
.exit:	rts
;
;	init trap
;
inittrap:
	ldx	#N_TRAP
	makeaniminit	trapinit
	lda	#SCHWP-4		;friends will stop over trap door
	sta	frstop
	rts
;
;	do trap
;
dotrap:
	ldx	#N_TRAP		;check for flash triggers trap
	ldy	#N_FLASH
	jsr	dotrigger

	jsr	doanim

	lda	movsta+N_TRAP	;check for trap triggers drop
	bmi	.trigoff
	and	#S_TRIGGER
	beq	.notrig
	sta	dropflag	;set flag
	lda	#S_INVULNERABLE | S_NOTHREAT	;clear trigger status
	sta	movsta+N_TRAP
.notrig:
	rts
.trigoff:
	lda	#FALSE
	sta	dropflag
	rts
;
;	torches
;
inittorches:
	ldx	#N_TORCH1
	makeaniminit	torchinit
	lda	#8*ZONEHL
	sta	movy,x
	lda	#13
	sta	movx,x
	lda	#14
	sta	movt1,x
	ldx	#N_TORCH2
	makeaniminit	torchinit
	ldx	#N_TORCH3
	makeaniminit	torchinit
	lda	#114
	sta	movx,x
	lda	#42
	sta	movt1,x
	ldx	#N_TORCH4
	makeaniminit	torchinit
	lda	#142
	sta	movx,x
	lda	#7
	sta	movt1,x
	lda	#8*ZONEHL
	sta	movy,x
	rts
;
;	do torches
;
dotorches:
	ldx	#N_TORCH1
	jsr	doanim
	ldx	#N_TORCH2
	jsr	doanim
	ldx	#N_TORCH3
	jsr	doanim
	ldx	#N_TORCH4
	jsr	doanim

	lda	movsta+N_TORCH1		;if all torches idle, darken room
	and	movsta+N_TORCH2
	and	movsta+N_TORCH3
	and	movsta+N_TORCH4
	bpl	.exit
	resetpal	6,3,CYAN-5
	sta	sky
	sta	fadsky
	resetpal	6,2,RED-2
.exit:	rts
;
;	init rdface
;
initrdface:
	ldx	#N_RDFACE
	makeaniminit	rdfaceinit
	rts
;
;	do rdface
;
dordface:
	lda	movsta+N_CHEST	;if chest status
	bpl	.notrig		;minus and not
	cmp	#S_HANG	;hang, trigger red face
	beq	.notrig

	lda	#S_HANG	;turn off chest
	sta	movsta+N_CHEST
	lda	#S_NOTHREAT | S_INVULNERABLE	;activate face
	sta	movsta+N_RDFACE
	lda	#1
	sta	movt1+N_RDFACE
.notrig:
	ldx	#N_RDFACE
	jsr	doanim
	rts
;
;	room spears
;
initspear1:
	ldx	#N_SPEAR1
	makeaniminit	spearinit
	rts
initspear2:
	ldx	#N_SPEAR2
	makeaniminit	spearinit
	lda	#ZONEHL*5
	sta	movy+N_SPEAR2
	rts
dospears:
	lda	movsta+N_FLASH	;launch if flash and not launched
	bmi	.nolaunch
	lda	movsta+N_SPEAR1
	bpl	.nolaunch
	lda	movsta+N_SPEAR2
	bpl	.nolaunch
	lda	#0
	sta	movsta+N_SPEAR1
	sta	movsta+N_SPEAR2
	lda	#1
	sta	movt1+N_SPEAR1	
	lda	#12
	sta	movt1+N_SPEAR2
.nolaunch:
	ldx	#N_SPEAR1
	jsr	doanim
	ldx	#N_SPEAR2
	jsr	doanim

	ldx	#N_SPEAR1
	jsr	checkreinit
	beq	initspear1

	ldx	#N_SPEAR2
	jsr	checkreinit
	beq	initspear2
.exit:	rts
;
;	flash on statue's staff
;
initflsh:
	ldx	#N_FLASH
	makeaniminit	flashinit
	rts
doflsh:
	ldx	#N_FLASH
	lda	movsta+N_FLASH
	bpl	.flshactive	;if not active

	lda	frwait	;and frs stopped
	beq	.drawflsh

	lda	#1		;activate
	sta	movt1+N_FLASH
	lda	#S_NOTHREAT
	sta	movsta+N_FLASH
	makeanim	flashseq
	makesound	FANFAREA
	makesound	FANFAREB
	jmp	.drawflsh
.flshactive:
	lda	frwait	;if active and frs not stopped
	beq	initflsh	;reinit flash (does rts)

.drawflsh:
	jsr	doanim
	rts
;
;	init face1
;
initface1:
	ldx	#N_FACE1
	makeaniminit	face1init
	rts
;
;	do face1
;
doface1:
	ldx	#N_FACE1
	jsr	doanim
	rts
;
;	init face2
;
initface2:
	ldx	#N_FACE2
	makeaniminit	face2init
	rts
;
;	do face2
;
doface2:
	ldx	#N_FACE2
	jsr	doanim
	rts
;
;	init dragon (room)
;
initdrag:
	ldx	#N_DRAG
	makeaniminit	draginit
	jsr	harder
	jsr	initroofrbl
	rts
;
;	init room fireball
;
initroofrbl:
	ldx	#N_ROOFRBL
	makeaniminit	roofrblinit
	rts
;	
;	do dragon
;
dodrag:
	ldx	#N_ROOFRBL
	jsr	falldeath
	bcc	.noreinit
	jsr	initroofrbl	;target does rts
.noreinit:
	jsr	doanim

	ldx	#N_DRAG
	jsr	doanim

	ldx	#N_ROOFRBL
	ldy	#N_DRAG
	jsr	dotrigger
	rts
;
;	init windows
;
initwinds:
	ldx	#N_WIN1
	makeaniminit	win1init
	inx
	makeaniminit	win2init
	inx
	makeaniminit	win3init
	inx
	makeaniminit	win4init
	inx
	makeaniminit	win5init
	inx
	makeaniminit	win6init
	rts
;	
;	do window enemies
;
dowinds:
	ldx	#N_WIN1
	jsr	doanim
	ldx	#N_WIN2
	jsr	doanim
	ldx	#N_WIN3
	jsr	doanim
	ldx	#N_WIN4
	jsr	doanim
	ldx	#N_WIN5
	jsr	doanim
	ldx	#N_WIN6
	jsr	doanim
	rts
;
;	init street lamps
;
initlamps:
	ldx	#N_LAMP1
	makeaniminit	lampinit
	jsr	rand
	and	#%00011111
	sta	movt1+N_LAMP1
	inx
	makeaniminit	lampinit
	lda	#86
	sta	movx+N_LAMP2
	jsr	rand
	and	#%00011111
	sta	movt1+N_LAMP2
	inx
	makeaniminit	lampinit
	lda	#116
	sta	movx+N_LAMP3
	rts
;	
;	do street lamps
;
dolamps:
	ldx	#N_LAMP1
	jsr	doanim
	ldx	#N_LAMP2
	jsr	doanim
	ldx	#N_LAMP3
	jsr	doanim

	lda	movsta+N_LAMP1	;darken scene if all lamps idle
	and	movsta+N_LAMP2
	and	movsta+N_LAMP3
	bpl	.exit
	resetpal	6,1,BLUE-3
	sta	ground1
	sta	fadgrnd1
	resetpal	6,2,WHITE-6
	sta	ground2
	sta	fadgrnd2
	resetpal	6,3,GREEN-3
.exit:	rts
;
;	init plant
;
initplant:
	ldx	#N_PLANT
	makeaniminit	plantinit
	jsr	rand			;randomly choose x pos
	and	#%00000001
	tay
	lda	plantxtab,y
	sta	movx+N_PLANT
	jsr	harder
	rts
;	
;	do plant
;
doplant:
	ldx	#N_PLANT
	jsr	checkreinit
	beq	initplant	;target does rts
	jsr	doanim
	rts
;
;	init chains holding up drawbridge
;
initchains:
	ldx	#N_CHAIN1
	makeaniminit	chain1init
	ldx	#N_CHAIN2
	makeaniminit	chain2init
	rts
;
;	do chains holding up drawbridge
;
dochains:
	jsr	dostoptime	;if frs stopped too long, force chains
	bcc	.cont
	ldx	#N_CHAIN1
	makeanim	chaindseq
	ldx	#N_CHAIN2
	makeanim	chaindseq
.cont:
	ldx	#N_CHAIN1
	jsr	doanim
	ldx	#N_CHAIN2
	jsr	doanim
	rts	
;
;	init door
;
initdoor:
	lda	#FALSE
	sta	doordown
	jsr	initchains
	lda	#1
	sta	movt1+N_DOOR
	lda	#4
	sta	movframe+N_DOOR
	lda	#S_HANG
	sta	movsta+N_DOOR	;inactivate
	lda	#60
	sta	frstop		;stop friends
	rts
;
;	do drawbridge door
;
dodoor:
	jsr	dochains
	lda	movsta+N_CHAIN1		;if chains exist, just draw
	and	movsta+N_CHAIN2
	bpl	.drawdoor

	lda	movframe+N_DOOR		;if on frame 0, just draw
	beq	.drawdoor
	dec	movt1+N_DOOR		;if time not up, just draw
	bne	.drawdoor

	lda	#12			;reset time, inc frame
	sta	movt1+N_DOOR
	dec	movframe+N_DOOR
	bne	.drawdoor		;if frame zero, let friends walk
	lda	#FRNOSTOP
	sta	frstop

.drawdoor:
	lda	#1
	sta	curzon
	sta	srcht
	lda	movframe+N_DOOR
	asl
	tay
	lda	.doorjtab,y
	sta	jaddr
	lda	.doorjtab+1,y
	sta	jaddr+1
	jmp	(jaddr)
.doorjtab:	.dc.w	.jdoor9,.jdoor7,.jdoor4,.jdoor2,.jdoor1

.jdoor1:
	setbaddr	DOOR1	;closed
	ldpw	4,7
	sta	palwid
	lda	#7
	sta	srcw
	lda	#5
	sta	destht
	lda	#91
	sta	hpos
	bne	.readydoor
.jdoor2:
	setbaddr	DOOR2
	ldpw	4,10
	sta	palwid
	lda	#10
	sta	srcw
	lda	#4
	sta	destht
	lda	#83
	sta	hpos
	bne	.readydoor
.jdoor4:
	setbaddr	DOOR4
	ldpw	4,10
	sta	palwid
	lda	#10
	sta	srcw
	lda	#3
	sta	destht
	lda	#81
	sta	hpos
	bne	.readydoor
.jdoor7:
	setbaddr	DOOR7
	ldpw	4,12
	sta	palwid
	lda	#12
	sta	srcw
	lda	#2
	sta	destht
	lda	#73
	sta	hpos
	bne	.readydoor
.jdoor9:
	lda	doordown
	bne	.notdown
	makesound	BOOM
	lda	#TRUE
	sta	doordown
.notdown:
	setbaddr	DOOR9	;open
	ldpw	4,12
	sta	palwid
	lda	#12
	sta	srcw
	lda	#2
	sta	destht
	lda	#73
	sta	hpos

.readydoor:
	jsr	tallobj
	rts
;
;	archers amd arrows
;
initarchers:
	lda	#N_ARCHERS
	sta	curarcher
	lda	#N_ARROWS
	sta	curarrow
.loop:	jsr	initarcher
	jsr	initarrow
	inc	curarcher
	inc	curarrow
	lda	curarcher
	cmp	#N_ARCHERS + MAXARCHERS
	bne	.loop
	rts
;
;
;
initarcher:
	ldx	curarcher
	makeaniminit	archerinit

	txa			;table lookup vhpos
	sec
	sbc	#N_ARCHERS
	tay
	lda	archersy,y	;vpos
	sta	movy,x
	lda	archersx,y	;hpos
	sta	movx,x

	jsr	randt1		;random start time
	ora	#%11110000
	sta	movsta,x
	jsr	harder
	rts
;
;
;
initarrow:
	ldx	curarrow
	makeaniminit	arrowinit

	jsr	rand		;randomly choose arrow angle
	and	#%00000010
	tay
	lda	arrowseqtab,y
	sta	movaniml,x
	lda	arrowseqtab+1,y
	sta	movanimh,x
	rts
;
;	do archers and arrows
;
doarchers:
	lda	#N_ARCHERS
	sta	curarcher
	lda	#N_ARROWS
	sta	curarrow
.loop:	jsr	doarcher
	jsr	doarrow
	inc	curarcher
	inc	curarrow
	lda	curarcher
	cmp	#N_ARCHERS + MAXARCHERS
	bne	.loop
	rts
;	
;
;
doarcher:
	tax
	jsr	checkreinit
	beq	initarcher	;target does rts
	jsr	doanim
	rts
;
;
;
doarrow:
	ldx	curarrow	;if special reinit code (-1)
	lda	movsta,x
	cmp	#$FF
	beq	initarrow	;target does rts

	ldx	curarcher	;check for launching
	ldy	curarrow
	jsr	dolaunch

	ldx	curarrow	;animate
	jsr	doanim

	ldx	curarrow	;if active and
	lda	movsta,x
	bmi	.exit

	lda	movy,x		;below ground, reinit
	cmp	#32
	bcc	initarrow	;target does rts

.exit:	rts
;
;	falldeath
;	mov in x, carry set if enemy fallen below fall level, or
;	if hung
;
falldeath:
	lda	movsta,x	;hung?
	cmp	#S_READINIT
	beq	.rettrue

	lda	movsta,x	;idle?
	bmi	.retfalse
	
	lda	fallevel		;below fall level?
	cmp	movy,x
	rts
.retfalse:
	clc
	rts
.rettrue:
	sec
	rts
;
;	check reinit rts false (equal) if status = readinit
;
checkreinit:
	lda	movsta,x
	cmp	#S_READINIT
	rts
;
;	do launch..launcher in x, launchee in y
;	if stat of x is launch, sets x and y of launchee and launches
dolaunch:
	lda	movsta,x	;time to launch?
	cmp	#S_LAUNCH
	bne	.exit

	lda	#0		;YES, clear launch status
	sta	movsta,x
	lda	movx,x		;copy coords
	sta	movx,y
	lda	movy,x
	sta	movy,y
	lda	#1		;time to activate
	sta	movt1,y
	lda	#0		;activated launchee
	sta	movsta,y
.exit:	rts
;
;	init ptera
;
initptera:
	ldx	#N_PTERA
	makeaniminit	pterainit
	jsr	harder
	rts
;
;	do ptera
;
doptera:
	ldx	#N_PTERA
	jsr	falldeath
	bcs	initptera	;target does rts

	jsr	doanim
	rts
;
;	init tocan
;
inittoc:
	ldx	#N_TOC1
	makeaniminit	toc1init
	rts
;
;	do tocan (the one standing alone)
;
dotoc:
	ldx	#N_TOC1
	jsr	doanim
	rts
;
;	init dependent animations
;
initcoco:
	ldx	#N_COCO
	makeaniminit	cocoinit
	rts
inittoc2:
	ldx	#N_TOC2
	makeaniminit	toc2init
	rts
;
;	init chimps
;
initchimps:
	ldx	#N_CHIMP1
	jsr	initchimp1

	ldx	#N_CHIMP2		;coconut chimp
	jsr	initchimp2

	ldx	#N_CHIMP3		;tocan chimp
	jsr	initchimp3

	jsr	inittoc2		;dependent animations
	jsr	initcoco

	rts
;
;	reinit chimp 1
;
initchimp1:
	jsr	stdchimp
	makeanim	chimp1seq
	rts
;
;	reinit chimp 2 (coconut thrower)
;
initchimp2:
	jsr	stdchimp
	makeanim	chimp2seq
	rts
;
;	reinit chimp 3	(tocan thrower)
;
initchimp3:
	jsr	stdchimp
	makeanim	chimp3seq
	rts
;
;	do chimps
;
dochimps:
	ldx	#N_CHIMP1
	jsr	junreinit
	bcc	.skipinit1
	jsr	initchimp1
.skipinit1:
	jsr	doanim

	ldx	#N_CHIMP2	;do coconut throwing chimp 2
	jsr	junreinit
	bcc	.skipinit2
	jsr	initchimp2
.skipinit2:
	jsr	doanim

	ldx	#N_CHIMP2
	ldy	#N_COCO
	jsr	dolaunch

	ldx	#N_COCO
	jsr	junreinit
	bcc	.skipinit3
	jsr	initcoco
.skipinit3:
	jsr	doanim

	ldx	#N_CHIMP3	;chimp 3, who throws the tocan
	jsr	junreinit
	bcc	.skipinit4
	jsr	initchimp3
.skipinit4:
	jsr	doanim

	ldx	#N_CHIMP3	;launch and do victum tocan
	ldy	#N_TOC2
	jsr	dolaunch

	ldx	#N_TOC2
	jsr	junreinit
	bcc	.skipinit5
	jsr	inittoc2
.skipinit5:
	jsr	doanim
;
;	if toc2 shot while chimp3 dependent, redirect chimp3
;
	lda	movsta+N_CHIMP3
	cmp	#S_DEPENDENT
	bne	.norechimp
	lda	movsta+N_TOC2
	cmp	#S_NOTHREAT | S_INVULNERABLE	;dieing status
	bne	.norechimp
	ldx	#N_CHIMP3
	makeanim	chimp3climb
	lda	#S_NOTHREAT
	sta	movsta+N_CHIMP3
.norechimp:
;
;	if chimp3 shot while toc2 dependent, redirect toc2
;
	lda	movsta+N_TOC2
	cmp	#S_DEPENDENT
	bne	.noretoc
	lda	movsta+N_CHIMP3
	cmp	#S_NOTHREAT | S_INVULNERABLE	;dieing status
	bne	.noretoc
	ldx	#N_TOC2
	makeanim	tocescapeseq
	lda	#S_NOTHREAT
	sta	movsta+N_TOC2
.noretoc:
	rts
;
;	jungle reinit, give mov in x reg
;	returns carry set if status=reinit or fallen below screen
;
junreinit:
	lda	movsta,x
	cmp	#S_READINIT
	beq	.rettrue
	lda	movy,x
	clc
	adc	#ZONEHL
	rts
.rettrue:
	sec
	rts
;
;	standard chimp init
;	call with mov in x reg, sets movx, and movid to vine ord,
;	y, randomized idle sta
;
stdchimp:
	makeaniminit	chimpinit
	lda	#$FF		;invalidate this guy's id
	sta	movid,x

.loop:
	jsr	rand		;select a random vine
	and	#%00000111
	cmp	movid+N_CHIMP1	;repeat until unreserved vine found
	beq	.loop
	cmp	movid+N_CHIMP2
	beq	.loop
	cmp	movid+N_CHIMP3
	beq	.loop

	sta	movid,x		;set id to ord of vine
	tay
	lda	chimpvines,y	;table lookup x value
	sta	movx,x

	jsr	randt1		;random wait time
	jsr	harder
	rts
;
;	init snowman
;
initsnowman:
	ldx	#N_SNOWMAN
	makeaniminit	snoinit
	jsr	rand
	and	#%1
	tay
	lda	snoxtab,y
	sta	movx+N_SNOWMAN
	rts
;
;	do snowman
;
dosnowman:
	ldx	#N_SNOWMAN
	jsr	checkreinit
	beq	initsnowman	;target does rts

	jsr	doanim
	rts
;
;	init bat
;
initbat:
	ldx	#N_BAT
	makeaniminit	BATINIT
	jsr	rand63		;random x pos
	adc	#20
	sta	movx,x
	jsr	harder
	rts
dobat:
	ldx	#N_BAT		;check reinit
	jsr	falldeath
	bcs	initbat		;target does rts

	lda	movx+N_BAT	;reinit if offscreen to right
	cmp	#SCWP
	bcs	initbat		;target does rts

	jsr	doanim

	rts
;
;	init ices
;
initices:
	ldx	#ICE + MAXICE
.loop:	dex
	jsr	initice
	txa
	cmp	#ICE
	bne	.loop
	rts
;
;	init ice
;
initice:
	makeaniminit	iceinit
	jsr	rand		;random idle status
	ora	#%11111100
	sta	movsta,x
	jsr	randxth		;rand x, t1, harder
	rts
;
;	doices
;
doices:	ldx	#ICE		;first ice

.loop:	pushx
	jsr	doice
	popx
	inx
	txa
	cmp	#(ICE+MAXICE)	;done with all ices?
	bne	.loop
	rts
;
;	do ice
;
doice:
	jsr	checkreinit
	beq	initice		;initice performs rts

	jsr	doanim
	rts
;
;	init falling stalactites that enable path
;
initfsts:
	ldx	#N_FST1		;init them
	makeaniminit	fstinit
	ldx	#N_FST2
	makeaniminit	fstinit
	lda	#144		;move 2nd one to proper x
	sta	movx+N_FST2

	lda	#35		;scramble time
	sta	movt1+N_FST2

	lda	#%00000001	;set bit pattern of ids to mark fall sta
	sta	movid+N_FST1
	lda	#%00000010
	sta	movid+N_FST2

	lda	#0		;clear fall status bits
	sta	fallsta

	lda	#CAVESTOP1	;set fr stop
	sta	frstop
	rts
;
;	do falling stalactites
;
dofsts:
	ldx	#N_FST1
	jsr	dofst
	ldx	#N_FST2
	jsr	dofst
	rts
;
;
;
dofst:
	lda	movsta,x	;if status
	and	#S_INVULNERABLE	;invulnerable bit
	bne	.nodrop		;high, don't try to auto-drop it
	jsr	dostoptime	;is fr idly waiting for stag to fall?
	bcc	.nodrop		;no, skip
	makeanim	fstdseq	;yes, start death seq
	jmp	.readydraw	;and draw
.nodrop:
	lda	movsta,x	;quiescent?
	and	#S_QUIET
	bne	.readydraw

	lda	movy,x		;see if hit ground
	cmp	#8
	bcs	.readydraw

	makeanim	fstqseq	;YES! just hit ground
	makesound	BOOM
	lda	#S_NOTHREAT | S_INVULNERABLE | S_QUIET
	sta	movsta,x
	lda	#8		;lock y level
	sta	movy,x

	lda	movid,x		;register fall status
	ora	fallsta
	sta	fallsta
	tay			;lookup new stop point
	lda	cavestoptab,y
	sta	frstop

.readydraw:
	jsr	doanim
	rts
;
;	do stop time .. return carry set if frs are waiting too long
;
dostoptime:
	lda	frwait
	beq	.nostop
	lda	clock
	bne	.retfalse

	dec	clock		;move clock past trigger point
	dec	stoptime	;1 stop time click
	bne	.retfalse
;rettrue:
	lda	#4	;reset stop time to avoid redundant signals
	sta	stoptime
	sec
	rts
.nostop:		;if no frs stopped, keep time at 4*4 (12 .. 16 secs)
	lda	#4
	sta	stoptime
.retfalse:
	clc
	rts
;
;	init ants
;
initants: ldx	#ANTS + MAXANTS
.loop1:	dex
	jsr	initant
	txa
	cmp	#ANTS
	bne	.loop1
	rts
;
;	Input: ant number in x reg
;
antytab:	.dc.b	5,59

initant:
	jsr	rand	;randomly decide if right or left ant
	bcs	.doleft
	makeaniminit	antrinit
	jmp	.finishant
.doleft:
	makeaniminit	antlinit
.finishant:
	lda	#0		;make ant go neither up nor down
	sta	movid,x

	jsr	rand		;randomly choose y pos
	and	#%1
	tay
	lda	antytab,y
	sta	movy,x

	jsr	rand		;randomize idle time
	ora	#%11100000	;make from -1 .. -31
	sta	movsta,x
	jsr	harder
	rts
;
;	do ants
;
doants:
	ldx	#ANTS		;first ice
.loop:
	jsr	doant
	inx
	txa
	cmp	#(ANTS+MAXANTS)	;done with all ices?
	bne	.loop
	rts
;
;	do one ant
;	ord of ant in X reg
doant:
	pushx
	jsr	doanim
	popx

	jsr	checkreinit
	beq	initant		;target does rts

	lda	movsta,x	;if idle, forget the rest
	bpl	.notidle
	rts
.notidle:
	lda	movx,x		;reinit if crawled offscreen
	clc
	adc	#8		;check partly off on left
	bcs	.notoff
	adc	#(256-SCWP-8)
	bcs	initant		;target does rts
	
.notoff:
	lda	movy,x		;a threat only if near friend's height
	cmp	#28
	bcc	.nothreat
	cmp	#36
	bcs	.nothreat
	lda	#0		;set status threatening
	beq	.yesthreat	;cheat .. branch always
.nothreat:
	lda	#S_NOTHREAT
.yesthreat:
	sta	movsta,x

	lda	clock		;every so often, change the rise and fall
	and	#%01111111
	bne	.nochange
	jsr	rand
	bcs	.nochange
	and	#%00000111
	tay
	lda	antupdown,y
	sta	movid,x
.nochange:
	lda	clock		;move it up or down
	and	#%00000111
	bne	.skip
	lda	movid,x
	clc
	adc	movy,x
	sta	movy,x
.skip:
	lda	movy,x		;see if its too high
	cmp	#64
	bmi	.nottoohigh
	lda	#64
	sta	movy,x
.nottoohigh:	
	lda	movy,x		;see if its too low
	bpl	.nottoolow
	lda	#0
	sta	movy,x
.nottoolow:
	lda	movy,x		;if at friend's level, stop rise or fall
	cmp	#32
	bne	.nolevel
	lda	#0
	sta	movid,x
.nolevel:
	rts
;
;	init bird (desert)
;
initbird:
	ldx	#N_BIRD
	makeaniminit	birdinit
	lda	#0		;y delta
	sta	movid+N_BIRD
	lda	#$FF		;time till descent 
	sta	timer
	jsr	rand		;random x pos
	and	#%00001111
	adc	#20
	sta	movx,x
	jsr	harder
	rts
dobird:
	ldx	#N_BIRD		;check reinit
	jsr	falldeath
	bcs	initbird	;target does rts

	lda	movsta+N_BIRD	;control descent
	bmi	.nodrop
	lda	timer
	bne	.nodrop
	jsr	rand
	bcs	.nodrop
	lda	#-1 & $FF
	sta	movid+N_BIRD
.nodrop:
	lda	movy+N_BIRD	;stop descent if too low
	cmp	#4*ZONEHL
	bcs	.nostopdrop
	lda	#0
	sta	movid+N_BIRD
.nostopdrop:
	lda	movx+N_BIRD	;reinit if offscreen to right
	clc
	adc	#(256 - SCWP)
	bcs	initbird	;target does rts

	jsr	doanim

	lda	movy+N_BIRD	;add delta to y
	clc
	adc	movid+N_BIRD
	sta	movy+N_BIRD
	rts
;
;	init snake
;
initsnake:
	ldx	#N_SNAKE
	makeaniminit	snakeinit

	jsr	rand63			;rand x and y pos
	adc	#(160 - 64 - 8)/2
	sta	movx,x

	jsr	rand			;rand y pos (only on zone)
	and	#%00010000
	clc
	adc	#3*ZONEHL
	sta	movy,x

	rts
;
;	do snake (desert)
;
dosnake:
	ldx	#N_SNAKE
	jsr	checkreinit
	beq	initsnake	;target does rts

	jsr	doanim
	rts
;
;	init rabbit
;
initrabbit:
	ldx	#N_RABBIT
	makeaniminit	rabbitinit
	rts
;
;	do rabbit (desert)
;
dorabbit:
	ldx	#N_RABBIT
	jsr	checkreinit
	beq	initrabbit	;target does rts

	lda	movx+N_RABBIT
	clc			;reinit of offscreen to right
	adc	#20		;slightly left of screen is ok
	bcs	.notoff
	lda	movx+N_RABBIT
	adc	#(256 - SCWP)
	bcs	initrabbit	;target does rts
.notoff:
	jsr	doanim
	rts
;
;	face screen animations
;
initeyes:
	lda	#FALSE
	sta	eyesred
	sta	frtarget
	ldx	#N_EYEL
	makeaniminit	wteyelinit
	ldx	#N_EYER
	makeaniminit	wteyerinit
	rts
;
initrdeyes:
	lda	#%10000000 | S_NOTHREAT	;if idle or no threat
	bit	movsta+N_EYEL
	bne	.next			;don't reint
	ldx	#N_EYEL
	makeaniminit	rdeyelinit	;init
.next:	lda	#%10000000 | S_NOTHREAT	;ditto
	bit	movsta+N_EYER
	bne	.exit
	ldx	#N_EYER
	makeaniminit	rdeyerinit	;init
.exit:	
	lda	#TRUE
	sta	eyesred
	makesound	DIEA
	makesound	DIEB
	rts
;
initwteyes:
	lda	#%10000000 | S_NOTHREAT	;if idle or no threat
	bit	movsta+N_EYEL
	bne	.next
	ldx	#N_EYEL
	makeaniminit	wteyelinit	;init
.next:	lda	#%10000000 | S_NOTHREAT	;ditto
	bit	movsta+N_EYER
	bne	.exit
	ldx	#N_EYER
	makeaniminit	wteyerinit	;init
.exit:	lda	#FALSE
	sta	eyesred
	rts
;
doeyes:
	ldx	#N_EYEL			;do anims
	jsr	doanim

	ldx	#N_EYER
	jsr	doanim

	lda	movsta+FRIEND0		;if friend not dieing
	cmp	#DIEING
	beq	.notarg			;and within range
	lda	movx+FRIEND0
	cmp	#45
	bcc	.notarg
	lda	#TRUE			;set target flag
	bne	.skip	;cheat always branch
.notarg:
	lda	#FALSE
.skip:
	sta	frtarget		;store as frtarget

	lda	eyesred			;if eyes not red
	bne	.doeyesred
;doeyeswt:				;do eyes white
	lda	movsta+N_EYEL		;if neither idle nor no threat
	ora	movsta+N_EYER
	and	#%10000000
	bne	.insync

	lda	movsta+N_EYEL		;and sync bits different,
	eor	movsta+N_EYER
	and	#S_SYNC
	beq	.insync

	jsr	initwteyes		;resync
.insync:
	lda	frtarget		;if fr target
	beq	.exit
	jsr	initrdeyes		;make red
	jmp	.exit
.doeyesred:
	lda	frtarget		;if not frtarget
	bne	.exit
	jsr	initwteyes		;make white
.exit:
	rts
;
;	harder	.. reduce idle time to make screens harder when revisited
;
harder:
	txa			;put x (mov) in y
	ldy	cursc
	ldx	beenhere,y	;put times been here in x
	tay

.loop:	dex
	bmi	.exit
	lda	movsta,y
	lsr
	ora	#%10000000	;keep negative
	sta	movsta,y
	lda	movt1,y
	lsr
	ora	#1		;make sure this isn't zero
	sta	movt1,y
	bne	.loop		;cheat always
	
.exit:	tya
	tax
	rts
;
;	do trigger .. a mover in y may trigger the mover in x
;
dotrigger:
	lda	movsta,x	;if triggeree active, abort
	bpl	.exit

	lda	movsta,y
	bmi	.exit		;triggerer must be active
	and	#S_TRIGGER	;and trigger bit set
	beq	.exit

	lda	movsta,y	;shut off trigger
	and	#(~S_TRIGGER) & $FF
	sta	movsta,y

	lda	#0		;activate triggered
	sta	movsta,x
	lda	#1
	sta	movt1,x
.exit:
	rts
;
;	do animation init
;	pass it address of initialization data, and mov in x reg.
;	completely sets up the sequence
;
doaniminit:
	ldy	#0
	lda	(animl),y	;height
	sta	movht,x
	iny	
	lda	(animl),y	;width
	sta	movw,x
	iny
	lda	(animl),y	;palwid
	sta	movpw,x
	iny
	lda	(animl),y	;xpos
	sta	movx,x
	iny
	lda	(animl),y	;ypos
	sta	movy,x
	iny
	lda	(animl),y	;status
	sta	movsta,x
	iny
	lda	(animl),y	;time
	sta	movt1,x
	iny
	lda	(animl),y	;frame addr
	sta	movfrl,x
	iny
	lda	(animl),y
	sta	movfrh,x
	iny
	lda	(animl),y	;seq addr
	sta	movaniml,x
	iny
	lda	(animl),y
	sta	movanimh,x
	iny
	lda	(animl),y	;death seq
	sta	movdseql,x
	iny
	lda	(animl),y
	sta	movdseqh,x
	iny
	lda	(animl),y	;type (stationary or moving xy)
	sta	movtype,x

	lda	#JUMPALWAYS		;null loop counter
	sta	movloop,x
	rts
;
;	super animation machine .. moving, multi-header objects
;	start by setting movaniml/h to address of first instruction
;	instruction format is time .. frame .. delta .. etc.
;	delta is x,y in high, low nibble, plus 8 to avoid sign extension
;	a null time ends sequence
;	end seq format: (null time), status, restart addrl/h
;	THIS VERSION ALSO HAS AUDIO,JUMP, STATUS, POINTS, LOOP FUNCTIONS
doanim:
	dec	movt1,x
	beq	.animup		;update?

	lda	movsta,x	;no update .. check status
	bpl	.drawanim	;not idle?
	rts			;idle .. return

.animup:
	lda	movsta,x	;check status
	bpl	.active		;active?
	cmp	#S_HANG		;if hang, return
	bne	.nothang
	rts
.nothang:
	inc	movsta,x	;idle .. inc status
	bpl	.active		;newly active?
	lda	#ONESEC		;inactive .. reset time for one sec
	sta	movt1,x
	rts			;bye!
		
.active:
	ldy	#0		;clear indirect index register
	lda	movaniml,x	;fetch address of animation instruction
	sta	animl		;and put it in zero page for indirection
	lda	movanimh,x
	sta	animh

.nextinst:
	lda	(animl),y	;get time value
	beq	.animnonframe	;zero time = non-frame instruction
	sta	movt1,x		;set time
	iny

	lda	(animl),y	;get frame address
	sta	movfrl,x
	iny

	lda	movtype,x	;if type minus, skip dx,dy
	bmi	.skipdxdy

	lda	(animl),y	;delta x
	clc
	adc	movx,x
	sta	movx,x
	iny

	lda	(animl),y	;delta y
	clc
	adc	movy,x
	sta	movy,x
	iny

.skipdxdy:
	tya		;update and save animation pointer
	clc
	adc	animl
	sta	movaniml,x
	lda	#0		;carry into high byte
	adc	animh
	sta	movanimh,x

.drawanim:
	lda	movfrl,x		;format vermov call
	sta	baddrl
	lda	movfrh,x
	sta	baddrh
	lda	movy,x
	sta	vpos
	lda	movx,x
	sta	hpos
	lda	movht,x
	sta	srcht
	lda	movpw,x
	sta	palwid
	jsr	xvermov
	rts	

.animnonframe:			;non-frame instruction
	iny
	pushx
	lda	(animl),y	;lookup the instruction token in jumptable
	tax
	lda	.jmptab,x
	sta	jaddr
	lda	.jmptab+1,x
	sta	jaddr+1
	popx
	iny
	jmp	(jaddr)

.jmptab:
	.dc.w	.doaudio,.dojump,.dostatus,.dopoints,.doloop,.dodelta

.doaudio:
	lda	(animl),y
	jsr	playsound
	iny
	jmp	.nextinst
.dojump:
	lda	movloop,x
	cmp	#JUMPALWAYS	;if invalid loop time, jump always
	beq	.readyjump
	sec			;decrement
	sbc	#1
	sta	movloop,x
	bcs	.readyjump	;if repeated required times, don't jump
	iny
	iny
	jmp	.nextinst
.readyjump:
	lda	(animl),y	;replace old address with new
	sta	movaniml,x
	iny
	lda	(animl),y
	sta	movanimh,x
	jmp	.animup		;back to top
.dostatus:
	lda	(animl),y		;new status, next action
	sta	movsta,x		;depends on status, so
	iny				;re-evaluate
	tya		;update and save animation pointer
	clc
	adc	animl
	sta	movaniml,x
	lda	#0		;carry animl to animh
	adc	animh
	sta	movanimh,x
	jmp	.animup
.dopoints:
	pushx
	pushy
	lda	(animl),y
	tay
	jsr	addpoints
	popy
	popx
	iny
	jmp	.nextinst
.doloop:
	lda	(animl),y	;set the loop counter
	sta	movloop,x
	iny
	jmp	.nextinst
.dodelta:
	lda	(animl),y	;add delta x and y
	clc
	adc	movx,x
	sta	movx,x
	iny
	lda	(animl),y
	clc
	adc	movy,x
	sta	movy,x
	iny
	jmp	.nextinst
;
;	add points.. given ord of point value, sets up screen display
;	and increments player's score
;	call with mov in x, score code in y
addpoints:
	lda	ptsbmtab,y	;baddrl
	sta	paddrl
	lda	ptspwtab,y	;palwid
	sta	ppalwid
	lda	movx,x		;hpos
	sta	phpos
	lda	movy,x		;vpos
	sta	pvpos
	lda	#ONESEC		;time
	sta	ptime

	tya			;inc score (two data bytes)
	asl
	tay
	pushx
	pushy
	lda	ptsinctab,y
	jsr	incsc
	popy
	pushy
	lda	ptsinctab+1,y
	jsr	incsc
	popy
	popx
	rts
;
;	fade machine: the following subroutines manage fades and cuts.
;	cut in and cut out cause immediate actions to the screen.
;	fade in and fade out set the flag faddir (fade direction), and
;	the fade occurs when the routine "dofades" is called every field.
;	waitfade is called when there is no action by the caller until
;	any pending fade is completed.
;	fadepals and fadecolor are utilities internal to the fade machine.
;	Any setting of colors intended to be faded correctly must be done
;	in the pal shadows (use the macro setpal).
;
;	fade in and wait
;
fadeinwait:
	jsr	fadein
	jsr	waitfade
	rts
;
;	fade out and wait
;
fadeoutwait:
	jsr	fadeout
	jsr	waitfade
	rts
;
;	wait for fade to finish
;
waitfade:
	jsr	waitbot
	jsr	dofades
	lda	faddir
	bne	waitfade
	rts
;
;	cut to black
;
cutout:
	lda	#MAXFADE
	sta	fadsta
	jsr	fadepals
	rts
;
;	cut from black
;
cutin:
	lda	#0
	sta	fadsta
	jsr	fadepals
	rts
;
;	fade in
;
fadein:
	lda	#FADEIN
	sta	faddir
	rts
;
;	fade out
;
fadeout:
	lda	#FADEOUT
	sta	faddir
	rts
;
;	do fades
;	task for fade in/out
;	reads global: faddir
;	uses locals: fadsta, fadtim, fadlum
dofades:
	lda	faddir
	bne	.fadewaits	;return if no fade waiting
	rts
.fadewaits:
	dec	fadtim	;time between changes
	bmi	.update
	rts
.update:
	lda	#FADSP	;reset timer
	sta	fadtim

	lda	faddir	;test direction
	bmi	.fadingout
;fadingin:	
	lda	fadsta
	beq	.faddone
	dec	fadsta		;fade in
	jsr	fadepals
	rts
.fadingout:
	lda	fadsta
	cmp	#MAXFADE
	beq	.faddone
	inc	fadsta		;fade out
	jsr	fadepals
	rts
.faddone:
	lda	#0	;fade done, switch to idle mode
	sta	fadtim
	sta	faddir
	rts
;
;	fade pals
;
fadepals:
	lda	#NUMBPAL
	sta	i
	ldx	#0

.loop:	jsr	fadepal
	dec	i
	bne	.loop

	ldy	sky		;fade ground and sky
	jsr	fadecolor
	sta	fadsky

	ldy	ground1
	jsr	fadecolor
	sta	fadgrnd1

	ldy	ground2
	jsr	fadecolor
	sta	fadgrnd2
	rts	
;
;	fade pal .. put pal color zero offset in x reg
;
fadepal:
	inx			;skip MARIA register
	ldy	palshad,x	;color 1
	jsr	fadecolor
	sta	PALS,x
	inx
	ldy	palshad,x	;color 2
	jsr	fadecolor
	sta	PALS,x
	inx
	ldy	palshad,x	;color 3
	jsr	fadecolor
	sta	PALS,x
	inx
	rts
;
;	fadecolor
;	call with intended color in Y reg
;	returns faded color in A reg
;	uses global fadsta (fade state)
;	uses temp fadlum (faded luminance)
fadecolor:
	tya			;get input
	and	#$0F		;mask in luminance
	sec
	sbc	fadsta		;subtract fade state
	bpl	fall30
	lda	#BLACK		;if negative return (black)
	rts			;done for negative
fall30:
	sta	fadlum		;get input
	tya			;get intended color
	and	#$F0		;keep chroma
	ora	fadlum		;add lum
	rts			;done
;
;	wait for alarm
;	call with field count in a reg
;	returns when time is up
;
waitalarm:
	sta	timer
.loop:	jsr	waitbot
	jsr	dofades
	lda	timer
	bne	.loop
	rts
;
;	wait for vblank
;
waitvbl:

.loop1:
	bit	MSTAT	;wait until vblank is off
	bmi	.loop1

.loop2:
	bit	MSTAT	;wait until vblank is on
	bpl	.loop2

	lda	#0	;clear bottom-of-screen flag
	sta	botflag
	sta	intcnt	;set interrupt count flag
	rts		;return
;
;	wait for bottom of screen (set by last-zone interrupt)
;	also, sound and pause functions occur in this routine
;
waitbot:
	jsr	dosound
.loop:
	lda	botflag	;check flag
	beq	.loop	;loop

	lda	#0	;clear flag
	sta	botflag

	jsr	dosw	;read console sw
	lda	pauseon	;check pause mode
	bne	.loop	;wait more if paused
	rts
;
;	make background, plain-jane format
;
mkbkg:				;left half
	maketall	plaintall
	rts
;
;	init cursor to center screen
;
initcursor:
	ldx	#N_CURSOR
	makeaniminit	cursorinit
	rts
;
;	do cursor: show it on screen
;
docursor:
	lda	idlemode		;if idle, exit
	bne	.exit

	lda	gun		;if light gun selected
	beq	.stick
	jsr	DOGUN		;call routine in lower fixed bank
	bne	.fire		;returns TRUE if fired
	beq	.nofire
.stick:
	lda	movsta+N_CURSOR		;see if firing allowed
	and	#S_STOPPED
	bne	.nofire

	lda	INPT4			;check fire button
	bmi	.nofire
.fire:
	lda	movx+N_CURSOR		;if cursor pos
	cmp	#SCWP			;offscreen
	bne	.onscreen
	makesound	CUCKOO2		;make cuckoo sound
.onscreen:
	lda	#S_STOPPED		;fire crossbow, forbid new fire
	sta	movsta+N_CURSOR
	ldx	#N_CURSOR
	makeanim	curseq2
.nofire:
	ldx	#N_CURSOR
	jsr	doanim
.exit:
	rts
;
;	setcursor
;
setcursor:
	lda	idlemode	;if idle mode
	bne	.exit		;exit
	lda	gun		;if light gun selected,
	bne	.exit		;exit
;
;	process joystick positioning of cursor (site)
;
;tryright
	lda	right		;if right
	beq	.tryleft	;false, try left
	lda	movx+N_CURSOR	;load curpos x
	cmp	#SCWP-4-2	;going offscreen?
	bcs	.trydown	;if at edge, abort
	inc	movx+N_CURSOR	;else inc
	inc	movx+N_CURSOR	;else inc
	jmp	.trydown
.tryleft:
	lda	left		;if left
	beq	.trydown	;false, try down
	lda	movx+N_CURSOR	;load curpos x
	cmp	#2		;going offscreen?
	bcc	.trydown	;if at left edge, abort
	dec	movx+N_CURSOR	;else dec
	dec	movx+N_CURSOR	;else dec
.trydown:
	lda	down		;if right
	beq	.tryup		;false, try up
	lda	movy+N_CURSOR	;load curpos y
	cmp	#2		;check for limit
	bcc	.exit		;if at bottom, abort
	lda	movy+N_CURSOR	;else dec
	sec
	sbc	#2
	sta	movy+N_CURSOR	;twice
	jmp	.exit
.tryup:
	lda	up		;if right
	beq	.exit		;false, try up
	lda	movy+N_CURSOR	;load curpos 
	cmp	#SCHL-4-2	;compare with top
	bcs	.exit		;if at bottom, abort
	lda	movy+N_CURSOR	;else inc
	clc
	adc	#2
	sta	movy+N_CURSOR	;twice
.exit:
	rts
;
;	header management machine: call the following functions to create
;	headers in MARIA's display lists. The list may be cleared (clearsc),
;	background headers can be locked (lockbkg), foreground headers can
;	be cleared (clrmov), collections of headers can be made (tallobj),
;	vertical positions can be managed (vermov). The basic header-maker
;	is mkhdr.
;
;	read headers
;	given addr of header list in addrl/h, calls mkhdr until all in place
;	data format: baddrh (hi nibble) zone (lo nibble), baddrl, palwid, hpos
;	end list = $FF in first byte
;	It is important to maintain this and readheaders2 together.
;
readhdrs:
	ldy	#0

	lda	(addrl),y	;baddrh and curzon
	cmp	#$FF
	beq	.exit

	tax
	and	#$0F
	sta	curzon

	txa
	and	#$F0
	sta	baddrh
	incw	addrl

	lda	(addrl),y	;baddrl
	sta	baddrl
	incw	addrl

	lda	(addrl),y	;palwid
	sta	palwid
	incw	addrl

	lda	(addrl),y	;hpos
	sta	hpos
	incw	addrl

	jsr	mkhdr
	jmp	readhdrs	;loop

.exit:	rts
;
;	This special read header 2 is for use of the map screen to draw
;	connecting paths with different palettes, overriding the palette
;	in the header data
;	It is important to maintain this and readheaders together.
;
readhdrs2:
	ldy	#0

	lda	(addrl),y	;baddrh and curzon
	cmp	#$FF
	beq	.exit

	tax
	and	#$0F
	sta	curzon

	txa
	and	#$F0
	sta	baddrh
	incw	addrl

	lda	(addrl),y	;baddrl
	sta	baddrl
	incw	addrl

	lda	(addrl),y	;palwid
	and	#%00011111	;substitute palette
	ora	subpal
	sta	palwid
	incw	addrl

	lda	(addrl),y	;hpos
	sta	hpos
	incw	addrl

	jsr	mkhdr
	jmp	readhdrs2	;loop

.exit:	rts
;
;	read tall .. reads data for a tall object or series of tall objects
;	calls tallobj. Clobbers x,y,a
;
readtall:
	ldy	#0

	lda	(addrl),y	;baddrh and curzon
	cmp	#$FF
	beq	.exit

	tax			;curzon
	and	#$0F
	sta	curzon

	txa			;baddrh
	and	#$F0
	sta	baddrh
	incw	addrl

	lda	(addrl),y	;baddrl
	sta	baddrl
	incw	addrl

	lda	(addrl),y	;srcht
	sta	srcht
	incw	addrl

	lda	(addrl),y	;srcwid
	sta	srcw
	incw	addrl

	lda	(addrl),y	;hpos
	sta	hpos
	incw	addrl

	lda	(addrl),y	;destht
	sta	destht
	incw	addrl

	lda	(addrl),y	;palwid
	sta	palwid
	incw	addrl

	jsr	tallobj
	jmp	readtall	;loop

.exit:	rts
;
;	tall object
;	passes on mkhdr vars
;	also: dest height (destht) source height (srcht) source width (srcw)
tallobj:
	save	curzon	;save destructable vars
	save	destht
	save	baddrl
	save	baddrh
	sta	baddrhs
	save	srcht
	sta	srchts

.loop:	jsr	mkhdr
	dec	destht
	bne	.cont	;done?

	restore	srcht	;return
	restore	baddrh
	restore	baddrl
	restore	destht
	restore	curzon
	rts
.cont:
			;setup next zone
	inc	curzon	;dest
	dec	srcht	;src height
	bne	.else	;wrap src?
	lda	srchts	;yes, wrap zone counter
	sta	srcht
	lda	baddrhs	;wrap baddrh
	sta	baddrh
	lda	baddrl	;advance baddrl
	clc	
	adc	srcw
	sta	baddrl
	bne	.loop	;branch always .. acc will never be zero
.else:
	lda	baddrh	;source
	clc
	adc	#ZONEHL
	sta	baddrh
	bne	.loop	;branch always .. acc will never be zero
;
;	fill region with same bitmap
;	passes on mkhdr vars
;	also: dest height (destht)
fillreg:
	save	curzon	;save destructable vars
	save	destht

.loop:	jsr	mkhdr	;make headers until done
	inc	curzon
	dec	destht
	bne	.loop

	restore	destht	;return
	restore	curzon
	rts
;
;	vertical moving object
;	extended
;	Some peculiar code follows. I need to know if the object is above
;	or below screen, or on screen. A vpos from 192 to 255 is NEGATIVE
;	(below the screen) in this context, but the 6502 sees numbers going
;	negative at 128. Therefore, a double test is needed to determine if
;	it is negative in THIS context, and the shift-lefts (divide by 16) must
;	be SIGN EXTENDED to work in this context.
;	Parameters: vpos, srcht, all mkhdr pars except curzon
xvermov:
	lda	vpos
	lsr	;calc zone
	lsr
	lsr
	lsr
	tax
	lda	convzsign,x	;lookup proper zone sign
	sta	curzon

	lda	vpos	;calc address offset
	and	#$0f
	beq	.loop	;fraction of a zone?
	sta	vpos	;yes, store fractional vpos,
	inc	srcht	;increase vertical size,
	lda	baddrh	;adjust source addr
	sec
	sbc	vpos
	sta	baddrh

.loop:
	jsr	mkhdr	;make
	dec	srcht
	beq	.break	;more height?
	inc	curzon	;...yes
	lda	#ZONEHL
	clc
	adc	baddrh
	sta	baddrh
	jmp	.loop
.break:
	rts
;
;	clear screen
;
clearsc:
	jsr	clrhdr
	jsr	lockbkg
	jsr	nullhdrs
	rts
;
;	lock background .. this function protects stationary background
;	headers by setting the header base addresses to right after them
;	Should be called after backgrounds are set up
;
lockbkg:
	ldx	#(ZONECNT*2)-1	;copy from hdrplst to hdrmlst
.loop:	lda	hdrplst,x
	sta	hdrmlst,x
	dex
	bpl	.loop
	rts
;
;	clear moving objects from header lst
;	Copy locked header info to list
;	Should be called before moving objects are re-written
;
waitclear:
	jsr	waitbot
clrmov:
	ldx	#(ZONECNT*2)-1	;copy from hdrmlst to hdrplst
.loop:	lda	hdrmlst,x
	sta	hdrplst,x
	dex
	bpl	.loop
	jsr	nullhdrs
	rts
;
;	clear headers completely for re-forming
;	copy rom-based header addresses to ram
;
clrhdr:
	ldx	#(ZONECNT*2)-1	;copy from rom to ram
.loop:	lda	hdradl,x
	sta	hdrplst,x
	dex
	bpl	.loop
	rts
nullhdrs:
	ldx	#(ZONECNT-1)<<1
	ldy	#1		;point to second, palwid byte

.loop:	lda	hdrplst,x	;low byte
	sta	haddrl
	lda	hdrplst+1,x	;high byte
	sta	haddrh

	lda	#0		;null the header
	sta	(haddrl),y

	dex
	dex
	bpl	.loop
	rts
;
;	make header
;
;	parameters:	baddrl/h, palwid, curzon, hpos
;	locals:		haddrl/h
;	uses: a,x,y regs
mkhdr:
	lda	curzon		;return if off screen
	bmi	abort1
	cmp	#ZONECNT
	bpl	abort1

	asl	;lookup header list address, store in haddrl/h
	tax
	lda	hdrplst,x	;low byte, indirect addr
	sta	haddrl
	clc			;point to next header
	adc	#4		;notice only low address is incremented
	sta	hdrplst,x	;without carry, so a row of headers must be
				;spaced within one page

	lda	hdrplst+1,x	;high byte, indirect addr
	sta	haddrh

	ldy	#0
	lda	baddrl		;bitmap address low
	sta	(haddrl),y

	iny		;pal width
	lda	palwid
	sta	(haddrl),y

	iny		;bitmap address high
	lda	baddrh
	sta	(haddrl),y

	iny		;hpos
	lda	hpos
	sta	(haddrl),y

	ldy	#5		;null next header
	lda	#0
	sta	(haddrl),y

abort1:
	rts
;
;	init rand .. seed random number generator
;
initrand:
	lda	#189	;183: one survivor in town
	sta	seedtab
	lda	#202
	sta	seedtab+1
	lda	#215
	sta	seedtab+2
	lda	#2
	sta	rindex
	rts
;
;	init x to rand140, t1 to 0..256, jsr harder
;
randxth:
	jsr	rand140x
	jsr	randt1
	jsr	harder
	rts
;
;	place a random number in movt1,x
;
randt1:
	jsr	rand
	sta	movt1,x
	rts
;
;	return a random number from 13 .. 140, put it in movx,x
;
rand140x:
	jsr	rand
	and	#%01111111
	adc	#(SCWP-128-6)/2		;center range
	sta	movx,x
	rts
;
;	return a random number from 0 .. 63
;
rand63:
	jsr	rand
	and	#%00111111
	rts
;
;	return random number from 0 .. 159
;
rand160:
	jsr	rand
	and	#128-1
	sta	r160tmp
	jsr	rand
	and	#32-1
	clc
	adc	r160tmp
	rts

;
;	random number generator (mod 256)
;	three values in a table are added together, the sum replaces each of
;	the values in successive calls
;	uses A, Y regs
;
rand:	ldy	rindex		;load sum pointer
	adc	seedtab		;first value
	adc	seedtab+1	;second value
	adc	seedtab+2	;third value
	sta	seedtab,y	;store
	dey			;dec sum pointer
	bpl	.fall		;no wrap?
	ldy	#2		;wrap
.fall:
	sty	rindex		;store sum pointer
	rts	
;
;	play sound
;	give it id in A reg
;	this func called from macro "makesound"
;	clobbers temp
playsound:
	sta	temp		;save regs
	pushx
	pushy
	ldy	temp			;sound table index

	lda	AUDADDR,y	;read table for data address
	sta	addrl
	lda	AUDADDR+1,y
	sta	addrh

	ldy	#0
	lda	(addrl),y	;read priority nibble
	and	#%01110000
	sta	temp
;
;	if a channel is idle, choose it
;
	ldx	#0
	lda	shistory
	beq	.replacesound

	inx
	lda	shistory+1
	beq	.replacesound
;
;	set x to channel with lowest priority
;	or longest history if pri same
;
	sec
	lda	spriority
	sbc	spriority+1
	bne	.pridiff
	
	lda	shistory	;pri same, choose channel playing longest
	cmp	shistory+1
	rol			;carry bit becomes
	and	#1
	tax			;chosen channel
	jmp	.prready

.pridiff:
	rol			;carry
	and	#1		;bit
	tax			;becomes chosen channel
.prready:
;
;	if new sound has higher priority than lowest pri channel
;	replace channel with new sound, else return
;
	lda	temp		;if new sound has lower pri than
	cmp	spriority,x	;old sound,
	bmi	.exit		;exit
.replacesound:
	lda	addrl		;set saved address
	sta	saddrl,x
	lda	addrh
	sta	saddrh,x

	lda	temp		;set priority
	sta	spriority,x
;
;	set these things to zero
;
	lda	#0

	tay
	jsr	setav
	sta	sptr,x
	sta	audvshadow,x
;
;	set these things to 1
;
	lda	#1
	sta	sptr,x		;point to after control byte
	sta	stime,x		;1st count, immediate update

	lda	#$FF
	sta	shistory,x

	lda	(addrl),y	;set control byte
	sta	AUDC0,x

.exit:	popy
	popx
	rts
;
;	do sound
;	looks at saddrh, if non-zero, takes saddrh/l, and starts interpreting
;	audio data (format in macro "audi" and "audend")
dosound:
	ldx	#0
	jsr	dochannel
	ldx	#1
	jsr	dochannel
	rts
;
;	do one channel of audio
;	channel in x reg
;
dochannel:
	lda	shistory,x	;if no history, idle
	bne	.notidle
	rts
.notidle:
	cmp	#1		;if history > 1, dec
	beq	.nodec
	dec	shistory,x
.nodec:
	dec	stime,x		;if dec time not zero, exit
	beq	.update
	rts
.update:
	lda	saddrl,x	;set indirect address
	sta	addrl
	lda	saddrh,x
	sta	addrh

	ldy	sptr,x		;set index pointer
	lda	(addrl),y	;read first byte
	beq	.stopchan	;if zero, stop channel
	iny

	lsr			;set time till next update
	sta	stime,x		;low bit of vol now in carry

	lda	(addrl),y	;second byte (freq, vol)
	iny
	pha			;save it
	rol			;shift left, bringing back low bit from carry
	and	#%00001111
	jsr	setav

	pla			;get freq
	lsr			;shift in
	lsr
	lsr
	sta	AUDF0,x		;set freq

	tya			;save index pointer
	sta	sptr,x
	rts

.stopchan:
	lda	#0		;channel becomes idle
	sta	shistory,x
	jsr	setav
	rts
;
;	set audio volume
;	shadow to audvshadow
;	using these subs is necessary to allow PAUSE to fully stop audio
;	and resume it exactly where it left off.
;	Call with volume in a reg, channel in x reg
setav:	sta	audvshadow,x
	and	soundon
	sta	AUDV0,x
	rts
;
;	Interrupt machine: an interrupt jump table is maintained, and at any
;	time, the global word "intjmp" is set so that an indirect jump will be
;	made at the next MARIA zone interrupt, performing the correct function.
;
;	clear interrupt jump table
;	set them all to point to null function, except for the top and bottom of
;	screen, which sets background to sky color and black, respectively.
;
clrijt:
	jsr	waitbot
clrijt1:			;for "internal" use
	ldy	#0
.loop:	lda	#(intnull & $FF)
	sta	intjt,y
	iny
	lda	#(intnull >> 8)
	sta	intjt,y
	iny
	tya
	cmp	#(NUMBINT*2)
	bne	.loop


	lda	#(intsky & $FF)	;top of screen, PLUS first interrupt
	sta	intjt+INTZB
	sta	intjmp
	lda	#(intsky >> 8)
	sta	intjt+INTZB+1
	sta	intjmp+1

	setijt	INTBOT,intbot	;bottom of screen

	lda	#2		;set ptr to next jmp addr
	sta	intptr

	rts
;
;	non-maskable interrupt handler (maria zones)
;
inter:	sta	WSYNC
	pha		;save regs
	pushy
	jmp	(intjmp)

intsky:	lda	fadsky
	sta	WSYNC
	sta	BKGRND
	jmp	intret
intgrnd1:
	lda	fadgrnd1
	sta	WSYNC
	sta	BKGRND
	jmp	intret
intgrnd2:
	lda	fadgrnd2
	sta	WSYNC
	sta	BKGRND
	jmp	intret
intbot:
	lda	#BLACK
	sta	WSYNC
	sta	BKGRND
	lda	#1	;set bottom flag
	sta	botflag
	lda	#0	;clear interrupt count
	sta	intcnt
	lda	pauseon	;if not in pause, service clocks
	bne	intret
	dec	timer
	dec	clock
intnull:
intret:
	ldy	intptr		;setup next intjmp
	lda	intjt,y
	sta	intjmp
	iny
	lda	intjt,y
	sta	intjmp+1
	iny
	tya			;check for overflow
	cmp	#(NUMBINT*2)
	bne	.nowrap
	ldy	#0		;wrap
.nowrap:
	sty	intptr
	popy			;restore regs
	pla
	rti
endcode:
ENDCODE	equ	endcode
;
;	encryption area
;
;	if the following fails, code has invaded top-of-ROM

	.assert	(* <= $FF7A)	;check end (codeend)
;
;	encryption data
;
	.org	$FF80
.dc.b	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.dc.b	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.dc.b	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.dc.b	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.dc.b	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.dc.b	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.dc.b	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.dc.b	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
;
;
;		
	.assert	(* <= $FFF8)	;check encryption end

	.org	$FFF8		;region verification
	.dc.b	$FF

	.org	$FFF9		;7800 cart identification
	.dc.b	((FIXROM >> 8) | $7)

	.org	$FFFA		;interrupt and reset vectors
	.dc.w	inter	;NMI
	.dc.w	main	;RESET
	.dc.w	dummy	;IRQ

.end
