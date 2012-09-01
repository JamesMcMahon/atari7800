	.subttl	"tables.s"
;
;	file: table.s
;	ROM data tables for Atari 7800 Crossbow
;
;	algorithm tables
;
convzsign:	;zones above 11 are negative,for vermov
	.dc.b	0,1,2,3,4,5,6,7,8,9,10,11,$FC,$FD,$FE,$FF
;
;	header address list tables
;	
hdradl:
	.dc.w	hdrlst+(HDRPITCH*0 )
	.dc.w	hdrlst+(HDRPITCH*1 )
	.dc.w	hdrlst+(HDRPITCH*2 )
	.dc.w	hdrlst+(HDRPITCH*3 )
	.dc.w	hdrlst+(HDRPITCH*4 )
	.dc.w	hdrlst+(HDRPITCH*5 )
	.dc.w	hdrlst+(HDRPITCH*6 )
	.dc.w	hdrlst+(HDRPITCH*7 )
	.dc.w	hdrlst+(HDRPITCH*8 )
	.dc.w	hdrlst+(HDRPITCH*9 )
	.dc.w	hdrlst+(HDRPITCH*10)
	.dc.w	hdrlst+(HDRPITCH*11)
;
;	zone list
;	30 lines top, 192 lines middle, 30 lines bottom
;
romzon:
;
;	above picture
;
	zone	0,0,0,12,vblhdr
	zone	0,0,0,13,vblhdr
;
;	picture
;
	zone	1,0,0,16,(hdrlst+(HDRPITCH*11))	;if interrupts are enabled
	zone	0,0,0,16,(hdrlst+(HDRPITCH*10))	;or disabled, remember to
	zone	1,0,0,16,(hdrlst+(HDRPITCH*9 ))	;change the intz equates and
	zone	1,0,0,16,(hdrlst+(HDRPITCH*8 ))	;total NUMBINT
	zone	0,0,0,16,(hdrlst+(HDRPITCH*7 ))
	zone	1,0,0,16,(hdrlst+(HDRPITCH*6 ))
	zone	1,0,0,16,(hdrlst+(HDRPITCH*5 ))
	zone	0,0,0,16,(hdrlst+(HDRPITCH*4 ))
	zone	1,0,0,16,(hdrlst+(HDRPITCH*3 ))
	zone	1,0,0,16,(hdrlst+(HDRPITCH*2 ))
	zone	0,0,0,16,(hdrlst+(HDRPITCH*1 ))
	zone	1,0,0,16,(hdrlst+(HDRPITCH*0 ))
;
;	below picture
;
	zone	1,0,0,13,vblhdr	;interrupt for early signal of vbl
	zone	0,0,0,13,vblhdr
;
;	cursor
;
cursorinit:
	animini	1,2,7,SCHWP,SCHHL,S_NOTHREAT,1,CURSOR1,curseq1,0,T_ST
curseq1:				;normal cursor
	animf	0,0,CURSOR1,1
	animj	curseq1
curseq2:
	anims	S_STOPPED
	anima	FIRE
	animf	0,0,CURSOR2,1		;display
	anims	S_NOTHREAT | S_STOPPED	;cancel threat
	animf	0,0,CURSOR3,4		;animate splotch
	animf	0,0,CURSOR4,4
	animf	0,0,CURSOR5,5
	animf	0,0,CURSOR1,6		;idle
	anims	S_NOTHREAT		;enable firing
	animj	curseq1
;
;	numerals address table
;
numadt:
	.dc.b	ZERO  & $FF,ONE   & $FF,TWO   & $FF,THREE & $FF
	.dc.b	FOUR  & $FF,FIVE  & $FF,SIX   & $FF,SEVEN & $FF
	.dc.b	EIGHT & $FF,NINE  & $FF,BLANK & $FF,BLANK & $FF
	.dc.b	BLANK & $FF,BLANK & $FF,BLANK & $FF,BLANK & $FF
;
;	points, displayed where a dying enemy has just disappeared
;
ptsbmtab:	;points - bitmap table
.dc.b	P500 & $FF,P1000 & $FF,P1500 & $FF,P2000 & $FF,P2500 & $FF,P5000 & $FF

ptspwtab:	;points - palette/width table (how wide bitmap)

	.dc.b	(7 << 5) | ((~3)+1 & %00011111)
	.dc.b	(7 << 5) | ((~4)+1 & %00011111)
	.dc.b	(7 << 5) | ((~4)+1 & %00011111)
	.dc.b	(7 << 5) | ((~4)+1 & %00011111)
	.dc.b	(7 << 5) | ((~4)+1 & %00011111)
	.dc.b	(7 << 5) | ((~4)+1 & %00011111)

ptsinctab:	;points - increment score table

	.dc.b	$52,$00
	.dc.b	$13,$00
	.dc.b	$13,$52
	.dc.b	$23,$00
	.dc.b	$23,$52
	.dc.b	$53,$00
;
;	path button control jump table
;
pathtab:					;from

	.dc.b	TOWN,	DESERT,	-1,	-1	;start (map)
	.dc.b	DESERT,	JUNGLE,	CASTLE,	-1	;cave
	.dc.b	VOLCANO,BRIDGE,	DESERT,	-1	;town
	.dc.b	VOLCANO,TOWN,	CAVE,	-1	;desert
	.dc.b	CASTLE,	DESERT,	CAVE,	-1	;jungle
	.dc.b	ROOM,	BRIDGE,	JUNGLE,	-1	;castle
	.dc.b	BRIDGE,	TOWN,	JUNGLE,	-1	;volcano
	.dc.b	VOLCANO,JUNGLE,	-1,	-1	;bridge
;
;	path choice table. in: prevsc/button. out: ord of draw path (pathlist)
;
pathmatrix:
	.dc.b	 0, 1,-1,-1	;map
	.dc.b	 2, 3, 4,-1	;cave
	.dc.b	 6, 7, 5,-1	;town
	.dc.b	 9, 5, 2,-1	;desert
	.dc.b	10, 8, 3,-1	;jungle
	.dc.b	14,13,10,-1	;castle
	.dc.b	15, 6,11,-1	;volcano
	.dc.b	15,12,-1,-1	;bridge
;
;
;	next screen jump table
;
jmptab:
	.dc.w	domap,docave,dotown,dodesert,dojungle,docastle
	.dc.w	dovolcano,dobridge,doroom,doface
;
;	the friends
;
;	heights
;
frhts:	.dc.b	2,3,3,2,2,3,3,3
;
;	friend colors
;
frpaltab:
	paltab	RED+10,	BROWN+2,WHITE	;monk
	paltab	RED+10,	$63,	BLACK+2	;merlin
	paltab	RED+10,	BLACK+2,WHITE	;wimp
	paltab	RED+10,	BROWN,	WHITE	;girl
	paltab	GRAY+4,	RED+10,	BROWN	;dwarf
	paltab	BLACK,	BROWN+1,GREEN	;negro
	paltab	YELLOW,	RED+10,	RED	;woman
	paltab	YELLOW,	BLACK+2,GREEN	;hero
	paltab	YELLOW,	RED,	GREEN	;fiery death
;
;	screen to new friend
;
newfrtab:
	.dc.b	-1, MERLIN,-1,  NEGRO, WIMP,  -1,    MONK,   GIRL,  -1,  -1
;		map,cave  ,town,desert,jungle,castle,volcano,bridge,room,face
;
;	screen to friend ypos
;
frypostab:
	.dc.b	0,  32,    32,  32,   32,    32,    32,     80,     48,   32
;
;	screen to friend x limit (where they complete their walk)
;
frlimits:
	.dc.b	0,SCWP, SCWP, SCWP, SCWP,  120,  SCWP,   SCWP,  SCWP,SCWP
;
;	screen to enemy fall level
;
fallevels:
	.dc.b	0,  32,    32,  32,   8,    32,    32,     78,     48,   32
;
;	fr animation frame address table
;
fftab:
.dc.b	(MON+15)&$FF,(MON+12)&$FF,(MON+9)&$FF,(MON+6)&$FF,(MON+3)&$FF,(MON)&$FF,(MON+12)&$FF,0
.dc.b	(MER+15)&$FF,(MER+12)&$FF,(MER+9)&$FF,(MER+6)&$FF,(MER+3)&$FF,(MER)&$FF,(MER+12)&$FF,0
.dc.b	(WIM+15)&$FF,(WIM+12)&$FF,(WIM+9)&$FF,(WIM+6)&$FF,(WIM+3)&$FF,(WIM)&$FF,(WIM   )&$FF,0
.dc.b	(GIR+15)&$FF,(GIR+12)&$FF,(GIR+9)&$FF,(GIR+6)&$FF,(GIR+3)&$FF,(GIR)&$FF,(GIR   )&$FF,0
.dc.b	(DWA+15)&$FF,(DWA+12)&$FF,(DWA+9)&$FF,(DWA+6)&$FF,(DWA+3)&$FF,(DWA)&$FF,(DWA+15)&$FF,0
.dc.b	(NEG+15)&$FF,(NEG+12)&$FF,(NEG+9)&$FF,(NEG+6)&$FF,(NEG+3)&$FF,(NEG)&$FF,(NEG+3 )&$FF,0
.dc.b	(WOM+15)&$FF,(WOM+12)&$FF,(WOM+9)&$FF,(WOM+6)&$FF,(WOM+3)&$FF,(WOM)&$FF,(WOM+12)&$FF,0
.dc.b	(HER+15)&$FF,(HER+12)&$FF,(HER+9)&$FF,(HER+6)&$FF,(HER+3)&$FF,(HER)&$FF,(HER+15)&$FF,0
;
;	fr walk times .. rythm of walking, limp or not
;
limpwalk:
	.dc.b	7,21,21,21,7,7,14
okwalk:
	.dc.b	13,14,13,14,15,15,14
;
;	friend sound tables
;
frouchtab:
	.dc.b	OWDWA,OWHER,OWHER,OWWOM,OWDWA,OWHER,OWWOM,OWHER
frahtab:
	.dc.b	AH1,AH3,AH3,AH2,AH1,AH4,AH2,AH3
;
;	fr die table (flames)
;
frdietab:
	.dc.w	DIE+9,DIE+6,DIE+3,DIE
;
;	animation sequences
;
eyeseqinit:
	animini	1,3,7,40,160,-10,61,EYE1,eyeseq,eyedseq,T_ST
eyeseq:
	anims	S_NOTHREAT
	animf	0,0,EYE1,19
	anima	HAHAHA
	animf	0,0,EYE2,19
	animf	0,0,EYE3,19
	animf	0,0,EYE4,19
	animf	0,0,EYE5,19
	animf	0,0,EYE6,19
	animf	0,0,EYE7,19
	animf	0,0,EYE2,19
	animf	0,0,EYE1,19
	anims	S_HANG
eyedseq:
	anima	BLAH
	animp	PTS5000
	animf	0,0,EYE3,5
	anims	S_HANG
;
;	town screen
;
;
;	treasure
;
ttinit:
animini	1,3,3,140,ZONEHL*2,S_NOTHREAT | S_INVULNERABLE,1,JUNPRI,ttseq,ttdseq,T_ST
ttseq:
	animf	0,0,TOWNT,ONESEC
	animj	ttseq
ttdseq:
	animp	PTS2500
	anima	TREASURE
	anims	S_HANG
;
;
;
ghostinit:
	animini	1,5,7,160,90,-15,3,GHOST1,ghostseq,ghostdseq,T_XY
ghostseq:
	anima	WHOHAHA
.loop:	animf	-2,0,GHOST1,3
	animf	-2,0,GHOST2,3
	animf	-2,0,GHOST2,3
	animf	-2,0,GHOST2,3
	animf	-2,0,GHOST3,3
	animf	-2,0,GHOST4,3
	animf	-2,0,GHOST4,3
	animf	-2,0,GHOST4,3
	animf	-2,0,GHOST5,3
	animf	-2,0,GHOST6,3
	animf	-2,0,GHOST6,3
	animf	-2,0,GHOST6,3
	animj	.loop
ghostdseq:
	anima	OHHH
	animp	PTS1000
gdloop:	animf	0,-2,GHOST5,3
	animf	0,-2,GHOST6,3
	animj	gdloop
boltinit:
	animini	1,2,7,-8,192,-7,ONESEC,BOLT,boltseq,boltdseq,T_XY
boltseq:
	animf	1,-2,BOLT,2
	animf	1,-2,BOLT,2
	animf	1,-2,BOLT+2,2
	animf	1,-2,BOLT+2,2
	animj	boltseq
boltdseq:
	anima	BOLTDIE
	animp	PTS2000
	anims	S_SETINIT
wolfinit:
	animini	1,3,2,80,16,-4,3,WOLF,wolfseq,wolfdseq,T_ST
wolfseq:
	anims	S_NOTHREAT
wolfseq2:
	animf	0,0,WOLF,10
	animf	0,0,WOLF+3,10
	animf	0,0,WOLF+6,10
	animf	0,0,WOLF+9,10
	animl	2
.loop:
	animf	0,0,WOLF+12,7
	animf	0,0,WOLF+15,7
	animj	.loop

	animf	0,0,WOLF+12,7
	animf	0,0,WOLF+9,10
	animf	0,0,WOLF+6,10
	animf	0,0,WOLF+3,10
	animf	0,0,WOLF,10
	anims	S_SETINIT
wolfdseq:
	anima	WOLFD
	animf	0,0,WLFDED,20		;death sequence
	animp	PTS1500
	anims	S_SETINIT
;
;	window sequences
;
win1init:
	animini	1,2,5,7,  80,-5,1,BM_WIN1,win1seq,win1d,T_ST
win2init:
	animini	1,2,4,53, 80,-1,3,BM_WIN2,win2seq,win2d,T_ST
win3init:
	animini	1,2,2,64, 80,-4,5,BM_WIN3,win3seq,win3d,T_ST
win4init:
	animini	1,2,4,80, 80,-1,16,BM_WIN4,win4seq,win4d,T_ST
win5init:
	animini	1,2,4,128,96,-4,34,BM_WIN5,win5seq,win5d,T_ST
win6init:
	animini	1,2,2,140,96,-9,2,BM_WIN6,win6seq,win6d,T_ST

win1seq:
	anims	S_NOTHREAT
	animf	0,0,BM_WIN1,15
	animf	0,0,BM_WIN1+2,15
	animf	0,0,BM_WIN1+4,15
	animf	0,0,BM_WIN1+6,20
	animf	0,0,BM_WIN1+4,15
	animf	0,0,BM_WIN1+2,15
	animf	0,0,BM_WIN1,  15
	anims	-15
	animj	win1seq
win1d:	anima	BARF
	animp	PTS1000
	anims	-15
	animj	win1seq
win2seq:
	anims	S_NOTHREAT
	animf	0,0,BM_WIN2, 15
	animf	0,0,BM_WIN2+2,15
	animf	0,0,BM_WIN2+4,20
	animf	0,0,BM_WIN2+2,15
	animf	0,0,BM_WIN2, 15
	anims	-4
	animj	win2seq
win2d:	anima	BARF
	animp	PTS1000
	anims	-4
	animj	win2seq
win3seq:
	anims	S_NOTHREAT
	animf	0,0,BM_WIN3,15
	animf	0,0,BM_WIN3+2,15
	animf	0,0,BM_WIN3+4,20
	animf	0,0,BM_WIN3+2,15
	animf	0,0,BM_WIN3,  15
	anims	-3
	animj	win3seq
win3d:	anima	BARF
	animp	PTS1000
	anims	-3
	animj	win3seq
win4seq:
	anims	S_NOTHREAT
	animf	0,0,BM_WIN4,20
	animf	0,0,BM_WIN4+2,20
	animf	0,0,BM_WIN4+4,30
	animf	0,0,BM_WIN4+2,20
	animf	0,0,BM_WIN4,20
	anims	-5
	animj	win4seq
win4d:	anima	THANKYOU
	animp	PTS1000
	anims	-5
	animj	win4seq
win5seq:
	anims	S_NOTHREAT
	animf	0,0,BM_WIN5,  20
	animf	0,0,BM_WIN5+2,20
	animf	0,0,BM_WIN5+4,30
	animf	0,0,BM_WIN5+2,20
	animf	0,0,BM_WIN5,  20
	anims	-4
	animj	win5seq
win5d:	anima	BARF
	animp	PTS1000
	anims	-4
	animj	win5seq
win6seq:
	anims	S_NOTHREAT
	animf	0,0,BM_WIN6,  15
	animf	0,0,BM_WIN6+2,15
	animf	0,0,BM_WIN6+4,15
	animf	0,0,BM_WIN6+6,20
	animf	0,0,BM_WIN6+4,15
	animf	0,0,BM_WIN6+2,15
	animf	0,0,BM_WIN6,  15
	anims	-9
	animj	win6seq
win6d:	anima	BARF
	animp	PTS1000
	anims	-9
	animj	win6seq
;
;	wizard
;
wizinit:
	animini	2,3,2,130, 128,-9,ONESEC,WIZA,wizseq,wizdseq,T_ST
wizseq:
	anima	POOF
	animf	0,0,WIZA,10
	animf	0,0,WIZA+3,10
	animf	0,0,WIZA+6,10
	animf	0,0,WIZA+9,10
	animf	0,0,WIZA+12,20
	anims	S_LAUNCH
	animf	0,0,WIZA+15,8
	animf	0,0,WIZA+18,8
	animf	0,0,WIZA+21,8
	animf	0,0,WIZA+24,10
	animf	0,0,WIZA+27,10
	animf	0,0,WIZA+30,10
	animf	0,0,WIZA+33,10
	animf	0,0,WIZA+36,10
	animf	0,0,WIZA+39,10
	animf	0,0,WIZA+42,10
	anims	-9
	animj	wizseq
wizdseq:
	anima	CURSUA
	anima	CURSUB
	animp	PTS1000
	anims	-9
	animj	wizseq
frballinit:
	animini	1,2,2,0,0,S_HANG,ONESEC,FRBALL,frballseq,frballdseq,T_XY
frballseq:
	anima	WIZFB
	animf	6,23,FRBALL,8
	animf	-5,0,FRBALL+2,8
	animf	-5,-1,FRBALL+4,8
	animf	-5,-2,FRBALL,8
	animf	-5,-4,FRBALL+2,8

.loop:	animf	-3,-4,FRBALL+4,4
	animf	-3,-4,FRBALL+4,4
	animf	-3,-4,FRBALL  ,4
	animf	-3,-4,FRBALL  ,4
	animf	-3,-4,FRBALL+2,4
	animf	-3,-4,FRBALL+2,4
	animj	.loop

frballdseq:
	anima	LAMPD
	animp	PTS2000
	anims	S_SETINIT
;
;	street lamp
;
lampinit:
	animini	1,2,2,34, 64,0,15,LAMP1,lampseq,lampdseq,T_ST
lampseq:
	anims	S_NOTHREAT
lamploop:
	animf	0,0,LAMP1,8
	animf	0,0,LAMP2,10
	animf	0,0,LAMP1,7
	animf	0,0,LAMP2,5
	animf	0,0,LAMP1,11
	animf	0,0,LAMP2,19
	animj	lamploop
lampdseq:
	anima	LAMPD
	animp	PTS500
	anims	S_HANG
;
;	desert seqs
;
;
;	treasure
;
destinit:
animini	1,3,2,140,ZONEHL*2,S_NOTHREAT | S_INVULNERABLE,1,DEST,destseq,destdseq,T_ST
destseq:
	animf	0,0,DEST,ONESEC
	animj	destseq
destdseq:
	animp	PTS2500
	anima	TREASURE
	anims	S_HANG
;
scorpinit:
	animini	1,4,7,SCWP, 32,-11,2,SCORPION,scorpseq,scorpdseq,T_XY
scorpseq:
	anims	S_NOTHREAT
	animl	16
.loop1:	animf	-1,0,SCORPION,5
	animf	-1,0,SCORPION+4,5
	animf	-1,0,SCORPION+8,5
	animj	.loop1

	anims	0
	animl	32
.loop2:	animf	-1,0,SCORPION,5
	animf	-1,0,SCORPION+4,5
	animf	-1,0,SCORPION+8,5
	animj	.loop2

	anims	S_NOTHREAT
	animl	11
.loop3:	animf	-1,0,SCORPION,5
	animf	-1,0,SCORPION+4,5
	animf	-1,0,SCORPION+8,5
	animj	.loop3

	anims	S_SETINIT
scorpdseq:
	anima	SCORPD
	animf	5,0,SCORPION,15
	animp	PTS500
	anims	S_SETINIT
;
;	ants, left and right
;
antupdown:
	.dc.b	0,-1,1,0,-1,1,0,-1
;
antlinit:
	animini	1,3,7,SCWP-1, 32,-1,3,ANTL,antlseq,antldseq,T_XY
antlseq:
	animf	-1,0,ANTL,4
	animf	-1,0,ANTL+3,4
	animf	-1,0,ANTL+6,4
	animf	-1,0,ANTL+9,4
	animj	antlseq
antldseq:
	anima	ANTD
	animf	0,3,ANTL,20
	animp	PTS500
	anims	S_SETINIT
;
antrinit:
	animini	1,3,7,-7, 32,-1,3,ANTR,antrseq,antrdseq,T_XY
antrseq:
	animf	1,0,ANTR,4
	animf	1,0,ANTR+3,4
	animf	1,0,ANTR+6,4
	animf	1,0,ANTR+9,4
	animj	antrseq
antrdseq:
	anima	ANTD
	animf	0,3,ANTR,20
	animp	PTS500
	anims	S_SETINIT
;
;	desert bird
;
birdinit:
	animini	1,6,3,30, 125,-9,4,BIRD1R,birdseq,birddseq,T_XY
birdseq:
	anima	BIRDCRY
	animf	0,-1,BIRD1R,15
	animf	0,-5,BIRD1R+6,15
	animf	0,5,BIRD1R+12,15
	animf	0,0,BIRD1R+18,15
	animf	0,0,BIRD2R,8
.loop:
	anima	BIRDCRY
	animf	1,0,BIRD2R+6,4
	animf	1,0,BIRD2R+6,4
	animf	1,0,BIRD2R+12,4
	animf	1,0,BIRD2R+12,4
	animf	1,-9,BIRD2R+18,4
	animf	1, 0,BIRD2R+18,4
	animf	1, 9,BIRD2R+12,4
	animf	1, 0,BIRD2R+12,4
	animj	.loop
birddseq:
	anima	BIRDD
	animp	PTS1000
.loop:	animf	0,-2,BIRD2R,1
	animj	.loop
	animj	birdseq
;
;	snake
;
snakeinit:
	animini	1,2,3,80, 96,-5,1,SNAKE,snakeseq,snakedseq,T_ST
snakeseq:
	anims	S_NOTHREAT
	animf	0,0,SNAKE,15
	animf	0,0,SNAKE+2,15
	animf	0,0,SNAKE+4,15
	animf	0,0,SNAKE+6,20
	animf	0,0,SNAKE+4,15
	animf	0,0,SNAKE+2,15
	animf	0,0,SNAKE,  15
	anims	-3
	anims	S_SETINIT
snakedseq:
	anima	SNAKED
	animp	PTS2000
	anims	S_SETINIT
;
;	rabbit
;
rabbitinit:
	animini	2,3,7,-12, 32,-5,1,RABBIT,rabbitseq,rabbitdseq,T_XY
rabbitseq:
	anims	S_NOTHREAT
.loop:	anima	RAB
	animf	3,-2,RABBIT,4
	animf	3,0,RABBIT,4
	animf	3,4,RABBIT+3,4
	animf	3,0,RABBIT+3,4
	animf	3,2,RABBIT+6,4
	animf	3,0,RABBIT+6,4
	animf	2,-4,RABBIT+9,4
	animf	2,0,RABBIT+9,4
	animj	.loop
rabbitdseq:
	anima	RABD
	animf	0,5,RABBIT,20
	animp	PTS1500
	anims	S_SETINIT
;
;	jungle treasure
;
baginit:
animini	1,3,7,140,ZONEHL*2,S_NOTHREAT | S_INVULNERABLE,1,JUNPRI,bagseq,bagdseq,T_ST
bagseq:
	animf	0,0,JUNPRI,ONESEC
	animj	bagseq
bagdseq:
	animp	PTS2500
	anima	TREASURE
	anims	S_HANG
;
;	plant (jungle)
;
plantinit:
	animini	2,3,3,0, 4,-7,1,PLANT,plantseq,plantdseq,T_XY
plantseq:
	anims	S_NOTHREAT
	animf	0,0,PLANT,60
	animf	0,0,PLANT+3,60

	animl	3
.loop:	animf	0,0,PLANT+6,15
	anims	0
	animf	0,0,PLANT+9,15
	anims	S_NOTHREAT
	animf	0,0,PLANT+6,15
	animf	0,0,PLANT+3,15
	animj	.loop

	animf	0,0,PLANT+3,45
	animf	0,0,PLANT,60
	anims	S_SETINIT
plantdseq:
	anima	PLANTD
	animf	0,5,PLANT+9,15
	animd	0,20
	animp	PTS1500
	anims	S_SETINIT
;
;	plant x locations
;
plantxtab:
	.dc.b	53,93
;
;	chimp
;
chimpinit:
	animini	2,3,5,0,151,-1,1,MONKEY,chimp1seq,chimpdseq,T_XY
;
chimp1seq:		;climb down, reach, climb up
	animl	7
.loop1:
	animf	0,-3,MONKEY,7
	animf	0,-3,MONKEY+3,7
	animf	0,-3,MONKEY+6,7
	animf	0,-3,MONKEY+9,6
	animj	.loop1

	animf	0,-3,MONKEY,7
	animf	0,-3,MONKEY+3,7

	animf	-2,0,MONKE4,8

	animl	4
.loop2:
	animf	0,0,MONKE4+3,12
	animf	0,0,MONKE4+6,12
	animj	.loop2

	animf	0,0,MONKE4,10

	animf	2,0,MONKEY  ,1

	animl	7
.loop3:
	animf	0,3,MONKEY+9,7
	animf	0,3,MONKEY+6,7
	animf	0,3,MONKEY+3,7
	animf	0,3,MONKEY  ,7
	animj	.loop3

	animf	0,3,MONKEY+9,7
	animf	0,3,MONKEY+6,7

	anims	S_SETINIT
;
;	slide, throw coconut, climb up
;
chimp2seq:
	animf	3,-1,MONKE5,1

	animl	28		;slide down
.loop4:	animf	0,-1,MONKE5,1
	animj	.loop4

	animf	-3,-1,MONKE5,1

	animf	0,0,MONKE2,40
	animf	0,0,MONKE2+3,7
	anims	S_LAUNCH	;throw
	animf	0,0,MONKE2+6,7

	animl	2		;climb up
.loop5:
	animf	0,3,MONKEY+9,7
	animf	0,3,MONKEY+6,7
	animf	0,3,MONKEY+3,7
	animf	0,3,MONKEY  ,7
	animj	.loop5

	anims	S_SETINIT
;
;	climb down, throw tocan, climb up
;
chimp3seq:
	animl	3
.loop6:
	animf	0,-3,MONKEY,7
	animf	0,-3,MONKEY+3,7
	animf	0,-3,MONKEY+6,7
	animf	0,-3,MONKEY+9,7
	animj	.loop6

	anims	S_LAUNCH
	animf	0,-3,MONKEY,10	;throw
	anims	S_DEPENDENT
	animf	-2,0,MONKE4,10
	animf	0,0,MONKE4+3,10
	animf	0,0,MONKE4,7
	animf	0,0,MONKE2,5
	animf	0,0,MONKE2+3,7
	animf	0,0,MONKE2+6,7
	anims	0
chimp3climb:
	animf	2,0,MONKEY,7

	animl	3		;climb up
.loop7:
	animf	0,3,MONKEY+9,7
	animf	0,3,MONKEY+6,7
	animf	0,3,MONKEY+3,7
	animf	0,3,MONKEY  ,7
	animj	.loop7

	anims	S_SETINIT
;
;
chimpdseq:

	animp	PTS1000
	anima	CHIMPD

.loop:
	animf	0,-3,MONKE3,3
	animf	0,-3,MONKE3,3
	animf	0,-3,MONKE3+3,3
	animf	0,-3,MONKE3+3,3
	animf	0,-3,MONKE3+6,3
	animf	0,-3,MONKE3+6,3
	animj	.loop

	anims	S_SETINIT
;
;	hpos of the chimp vines
;
chimpvines:
	.dc.b	26,37,54,65,90,110,120,133
;
;	coconut, thrown by chimps
;
cocoinit:
	animini	1,3,5,80,SCHL/2,S_HANG,ONESEC,COCO1,cocoseq,cocodseq,T_XY

cocoseq:
	animf	-4,5,COCO1,10

	animl	12
.loop1:	animf	0,-1,COCO1,1
	animf	-1,-1,COCO1,1
	animj	.loop1

	animl	9
.loop2:	animf	0,-1,COCO1,1
	animf	0,-1,COCO1,1
	animf	-1,-1,COCO1,1
	animj	.loop2

	animl	70
.loop3:	animf	0,-1,COCO1,1
	animj	.loop3
	anims	S_SETINIT

cocodseq:
	anima	LAMPD
	animf	0,0,COCO2,12
	animf	0,0,COCO2+3,12
	animf	0,0,COCO2+6,12
	animp	PTS1500
	anims	S_SETINIT
;
;	tocan seqs
;
toc1init:
	animini	1,3,2,96,116,-8,1,TOCAN,toc1seq,tocdseq,T_XY
toc1seq:
	anims	-8
	animf	0,0,TOCAN+12,30
	anima	TOCANCRY

	animl	3
.loop:	animf	0,0,TOCAN,15
	animf	0,0,TOCAN+3,15
	animj	.loop

tocescapeseq:
	animf	0,0,TOCAN+6,12
	animf	0,0,TOCAN+9,12
	animf	0,0,TOCAN+12,12
	animf	0,0,TOCAN+15,12
	anims	S_SETINIT

tocdseq:
	anima	TOCANCRY
	animf	0,3,TOCAN2+3,15
	animp	PTS1500
	anims	S_SETINIT
;
;	tocan 2 (thrown by chimp)
;
toc2init:
	animini	1,3,2,SCHWP,SCHL/2,S_HANG,ONESEC,TOCAN,toc2seq,tocdseq,T_XY
toc2seq:
	anims	S_DEPENDENT
	anima	TOCANCRY
	animf	-10,3,TOCAN+12,10
	animf	0,0,TOCAN,10
	animf	0,0,TOCAN,10
	anims	0
	animf	5,2,TOCAN2,7
	animf	3,1,TOCAN2,16
	animf	-3,1,TOCAN2,8
	anims	0

	animl	6
.loop:
	animf	0,-4,TOCAN2,4
	animf	0,-4,TOCAN2,4
	animf	0,-4,TOCAN2+3,4
	animf	0,-4,TOCAN2+3,4
	animf	0,-4,TOCAN2+6,4
	animf	0,-4,TOCAN2+6,4
	animf	0,-4,TOCAN2+9,4
	animf	0,-4,TOCAN2+9,4
	animj	.loop

	anims	S_SETINIT
;
;	chains holding drawbridge door
;
chain1init:	;right
	animini	1,3,7,111,92,S_NOTHREAT,1,CHAIN,chainseq,chaindseq,T_ST
chain2init:	;left
	animini	1,3,7,91,96,S_NOTHREAT,20,CHAIN,chainseq,chaindseq,T_ST
chainseq:

.loop:	animf	0,0,CHAIN+3,15
	animf	0,0,CHAIN+6,30
	animf	0,0,CHAIN+3,15
	animf	0,0,CHAIN  ,30
	animj	.loop

chaindseq:
	anima	LAMPD
	animf	0,0,CHAIN+9,20
	anims	S_HANG
;
;	archers
;
archerinit:
	animini	2,3,2,0,0,0,0,ARCHER1,archerseq,archerdseq,T_ST
archerseq:
	anims	S_NOTHREAT
	animf	0,0,ARCHER1,30
	animf	0,0,ARCHER2,30
	anims	S_LAUNCH
	anima	BOW
	animf	0,0,ARCHER3,30
	animf	0,0,ARCHER4,30
	animf	0,0,ARCHER5,30
	anims	S_SETINIT
archerdseq:
	anima	ARCHERD
	animp	PTS1000
	anims	S_SETINIT
;
;	archer alignments with the castle
;
archersx:
	.dc.b	92,97,102,107,112,117,122
archersy:
	.dc.b	137,139,141,143,145,147,149
;
;	arrows
;
arrowinit:
	animini	1,3,3,0,0,0,1,ARROW3,0,arrowdseq,T_XY
arrow1seq:
	anims	S_HANG
.loop:
	animf	-1,-2,ARROW3,2
	animj	.loop

arrow2seq:
	anims	S_HANG
.loop:
	animf	-1,-3,ARROW4,3
	animj	.loop

arrowdseq:
	anima	ICEHIT
	animp	PTS1000
	anims	-2

arrowseqtab:
	.dc.w	arrow1seq,arrow2seq
;
;	castle pteradactyl
;
pterainit:
	animini	2,6,7,-(6*4),102,-10,1,PTERA,pteraseq,pteradseq,T_XY
pteraseq:
	animl	6
	anima	PTERACRY
.loop1:
	animf	2,-2,PTERA,6
	animf	2,-2,PTERA+6,6
	animf	2,-2,PTERA+12,6
	animf	2,-2,PTERA+18,6
	animf	2,-2,PTERA+24,6
	animj	.loop1

	animf	2,0,PTERA,6
	animf	2,0,PTERA+6,6
	animf	2,0,PTERA+12,6
	animf	2,0,PTERA+18,6
	animf	2,0,PTERA+24,6

	animl	10
.loop3:
	animf	3,3,PTERA,6
	animf	2,3,PTERA+6,6
	animf	3,3,PTERA+12,6
	animf	2,3,PTERA+18,6
	animf	3,3,PTERA+24,6
	animj	.loop3
	anims	S_SETINIT

pteradseq:
	anima	PTERAD
	animp	PTS2000
.loop:	animf	0,-4,PTDIE,3
	animf	0,-4,PTDIE,3
	animf	0,-4,PTDIE+6,3
	animf	0,-4,PTDIE+6,3
	animj	.loop
;
;	bridge
;	fish
;
fishx:	.dc.b	15,20,110,105
fishy:	.dc.b	0,32,48,100
;
fishinit:
	animini	1,3,4,40,3,-3,ONESEC,FISH,fishseq,fishdseq,T_XY
fishseq:
	anima	BLOOP
	anims	S_INVULNERABLE | S_NOTHREAT
	animf	0,0,FISH,10
	animf	0,-3,FISH+3,10
	anims	S_NOTHREAT
	animf	0,0,FISH+6,10
	animf	0,1,FISH+9,10
	animf	0,0,FISH+12,10
	animf	0,0,FISH+15,10
	animf	0,-1,FISH+18,10
	anims	S_INVULNERABLE | S_NOTHREAT
	animf	0,0,FISH+3,10
	animf	0,3,FISH,10
	anims	S_SETINIT
fishdseq:
	anima	RABD
	animp	PTS2000
	animf	0,0,FISH+3,15
	animf	0,3,FISH,15
	anims	S_SETINIT
;
;	frog
;
froginit:
	animini	1,2,3,163,0,-4,ONESEC,FROG,frogseq,frogdseq,T_XY
frogseq:
	anims	S_NOTHREAT
	animl	9

.loop:	anima	FROGJ
	animf	 0,1,FROG,15
	animf	-1,1,FROG+2,4
	animf	-1,1,FROG+4,4
	animf	-1,1,FROG+6,4
	animf	-2,1,FROG+8,4
	animj	.loop

	animf	0,1,FROG,4

	anims	S_SETINIT
frogdseq:
	anima	SCORPD
	animf	-1,5,FROG+4,15
	animp	PTS2000
	anims	S_SETINIT
;
;	alligator
;
aliinit:
	animini	1,3,7,20,16,-12,ONESEC,ALI,aliseq,alidseq,T_ST
aliseq:
	anima	BLOOP
	anims	S_NOTHREAT
	animf	0,0,ALI,15
	animf	0,0,ALI+3,15
	animf	0,0,ALI+6,15
	animf	0,0,ALI+9,15
	animf	0,0,ALI+12,15
	animf	0,0,ALI+15,15
	animf	0,0,ALI+9,15
	animf	0,0,ALI+6,15
	animf	0,0,ALI+3,15
	animf	0,0,ALI,15
	anims	S_SETINIT
alidseq:
	anima	WHIP
	animf	0,0,ALI+12,20
	animf	0,0,ALI,15
	animp	PTS2500
	anims	S_SETINIT
;
;	castle alligator
;
ali2init:
	animini	1,3,7,98,0,-12,ONESEC,ALI2,aliseq,ali2dseq,T_ST
ali2dseq:
	anima	WHIP
	animf	0,0,ALI+12,20
	animf	0,0,ALI,15
	animp	PTS1500
	anims	S_SETINIT
;
;	beaver
;
beaverinit:
	animini	2,3,7,100,32,-11,ONESEC,BEAVER,beaverseq,beaverdseq,T_ST
beaverseq:
	anims	S_NOTHREAT
	animf	0,0,BEAVER,15
	animf	0,0,BEAVER+3,15
	animf	0,0,BEAVER+6,15
	animf	0,0,BEAVER+9,15
	animf	0,0,BEAVER+12,15
	animf	0,0,BEAVER+15,15
	animf	0,0,BEAVER+12,15
	animf	0,0,BEAVER+9,15
	animf	0,0,BEAVER+6,15
	animf	0,0,BEAVER+3,15
	animf	0,0,BEAVER,15
	anims	S_SETINIT
beaverdseq:
	anima	ANTD
	animf	0,0,BEAVER+9,20
	animp	PTS1500
	anims	S_SETINIT
;
;	owl
;
owlinit:
	animini	2,3,3,56,16,-8,ONESEC,OWL,owlseq,owldseq,T_ST
owlseq:
	anima	OWLCRY
	anims	S_NOTHREAT
	animf	0,0,OWL,10
	animf	0,0,OWL+3,10
	animf	0,0,OWL+6,10
	animf	0,0,OWL+3,10
	animf	0,0,OWL+9,10
	animf	0,0,OWL+3,10
	animf	0,0,OWL+6,10
	animf	0,0,OWL+3,10
	animf	0,0,OWL,10
	anims	S_SETINIT
owldseq:
	anima	OWLCRY
	animf	0,0,OWL+3,15
	animp	PTS2000
	anims	S_SETINIT
;
;	buzzard
;
buzzinit:
	animini	2,6,4,-(6*4),116,-10,ONESEC,BIRD1,buzzseq,buzzdseq,T_XY
buzzseq:
	anima	PTERACRY
	animl	5		;cruise
	anims	S_NOTHREAT
.loop1:	animf	2,0,BIRD1,5
	animf	2,0,BIRD1+6,5
	animf	2,0,BIRD1+12,5
	animf	2,0,BIRD1+18,5
	animf	2,0,BIRD1+24,5
	animj	.loop1

	anima	PTERACRY
	animl	4		;descend
.loop2:	animf	2,-1,BIRD1,5
	animf	2,0,BIRD1+6,5
	animf	2,-1,BIRD1+12,5
	animf	2,0,BIRD1+18,5
	animf	2,-1,BIRD1+24,5
	animj	.loop2

	animl	9		;cruise
	anims	0	;threat
.loop3:	animf	2,0,BIRD1,5
	animf	2,0,BIRD1+6,5
	animf	2,0,BIRD1+12,5
	animf	2,0,BIRD1+18,5
	animf	2,0,BIRD1+24,5
	animj	.loop3

	anims	S_SETINIT
buzzdseq:
	anima	PTERAD
	animp	PTS1000
.loop:	animf	0,-3,DYING1,4
	animf	0,-3,DYING1,4
	animf	0,-3,DYING1+6,4
	animf	0,-3,DYING1+6,4
	animj	.loop
;
;	rock bridge
;
rockbriinit:
	animini	2,3,2,SCWP,197,-7,ONESEC,ROCKA,rockbriseq,rockbridseq,T_XY
rockbriseq:
	animl	8
.loop1:	animf	-1,-4,ROCKB,6
	animf	-1,-4,ROCKB+3,6
	animf	-1,-4,ROCKB+6,6
	animf	-1,-4,ROCKB+9,6
	animj	.loop1

	animl	9
.loop2:	anima	BOOM
	animf	-2,0,ROCKC,6
	animf	-2,0,ROCKC+3,6
	animf	-2,0,ROCKC+6,6
	animf	-2,0,ROCKC+9,6
	anima	BOOM
	animf	-2,0,ROCKD,6
	animf	-2,0,ROCKD+3,6
	animf	-2,0,ROCKD+6,6
	animf	-2,0,ROCKD+9,6
	animj	.loop2

	anims	S_SETINIT
rockbridseq:
	anima	LAMPD
	animf	0,5,ROCKD,15
	animp	PTS1000
	anims	S_SETINIT
;
;	volcano anims
;
rockinit:
	animini	1,3,5,80,SCHL+16,-1,ONESEC,VROCK,rockseq,rockdseq,T_XY
rockseq:
	animl	8
.loop:	animf	0,-3,VROCK  ,2
	animf	0,-3,VROCK  ,3
	animf	0,-3,VROCK+3,2
	animf	0,-3,VROCK+3,3
	animf	0,-3,VROCK+6,2
	animf	0,-3,VROCK+6,3
	animf	0,-3,VROCK+9,2
	animf	0,-3,VROCK+9,3
	animj	.loop

	anims	S_INVULNERABLE | S_NOTHREAT
	animf	-1,0,VROCK4,15
	anims	S_SETINIT
rockdseq:
	anima	ROCKDIE
	animf	-1,0,VROCK4,15
	animp	PTS500
	anims	S_SETINIT
;
;	falling flaming rock
;
flrockinit:
	animini	1,3,4,80,SCHL,-1,ONESEC,VROCK3,flrockseq,flrockdseq,T_XY
flrockseq:
	animl	7
.loop:	animf	0,-3,VROCK3  ,2
	animf	0,-3,VROCK3  ,3
	animf	0,-3,VROCK3+3,2
	animf	0,-3,VROCK3+3,3
	animf	0,-3,VROCK3+6,2
	animf	0,-3,VROCK3+6,3
	animf	0,-3,VROCK3+9,2
	animf	0,-3,VROCK3+9,3
	animj	.loop
	anims	S_SETINIT
flrockdseq:
	anima	FROCKD
	animf	0,0,VROCK3,15
	animp	PTS1000
	anims	S_SETINIT
;
;	fireballs shooting up from volcano
;
volupinit:
	animini	1,1,4,99,143,-1,ONESEC,VROCK4,volupseq,0,T_XY
volupseq:
	anima	UPBOOM
	anims	S_INVULNERABLE | S_NOTHREAT
	animl	13
.loop:	animf	0,2,VROCK4  ,2
	animf	0,2,VROCK4  ,2
	animf	0,2,VROCK4+1,2
	animf	0,2,VROCK4+1,2
	animj	.loop
	anims	S_SETINIT
;
;	lightning
;
ltnginit:
	animini	3,3,7,70,85,-1,ONESEC,LTNING,ltngseq,0,T_ST
ltngseq:
	anima	BOOM
	anims	S_NOTHREAT | S_INVULNERABLE
	animf	0,0,LTNING,4
	anims	S_SETINIT
;
;	volcano treasure (diamond)
;
diamndinit:
animini	1,3,3,130,ZONEHL*2,S_NOTHREAT | S_INVULNERABLE,1,DIAMND,diamndseq,diamnddseq,T_ST
diamndseq:
	animf	0,0,DIAMND,ONESEC
	animj	diamndseq
diamnddseq:
	anima	TREASURE
	animp	PTS2500
	anims	S_HANG
;
;	boulder to bridge lava
;
bldrinit:
	animini	3,6,5,58,24,S_NOTHREAT,40,BLDR1+12,bldrseq,bldrdseq,T_XY
bldrseq:
	animf	0,0,BLDR1+6 ,40
	animf	0,0,BLDR1+12,40
	animj	bldrseq
bldrdseq:
	anima	LAMPD
	animp	PTS500
bldrdseq2:					;for auto-drop
	anims	S_INVULNERABLE | S_NOTHREAT
	animf	0,0,BLDR1+12,10
	animf	0,0,BLDR1+6 ,10
	anima	BOOM
	animf	-12,0,BLDR1,ONESEC
.loop:	animf	0 ,0,BLDR1,ONESEC
	animj	.loop
;
;	lava river
;
lriverinit:
	animini	4,15,6,30,0,S_NOTHREAT | S_INVULNERABLE,21,LRIVER,.lriverseq,0,T_ST
.lriverseq:
	animf	0,0,LRIVER+15,21
	animf	0,0,LRIVER+45,21
	animf	0,0,LRIVER+30,21
	animf	0,0,LRIVER   ,21
	animj	.lriverseq
;
;	cave anims
;
;
;	treasure
;
ctinit:
animini	1,3,4,130,ZONEHL*2,S_NOTHREAT | S_INVULNERABLE,1,JUNPRI,ctseq,ctdseq,T_ST
ctseq:
	animf	0,0,CAVET,ONESEC
	animj	ctseq
ctdseq:
	animp	PTS2500
	anima	TREASURE
	anims	S_HANG
;
;	obselete bat code (we moved this to lower bank circa $4000)
;
.if 0
batinit:
	animini	1,3,5,60,100,-6,1,BAT1,batseq,batdseq,T_XY
batseq:
	animf	0,0,BAT1,15
	animf	0,0,BAT1+3,15
	animf	0,0,BAT1+6,15
.loop:
	anima	BATCRY
	animf	1,-1,BAT2,8
	animf	1,1 ,BAT2+3,8
	animf	1,0 ,BAT2+6,8
	animf	1,0 ,BAT2+3,8
	animj	.loop
batdseq:
	anima	BATD
	animp	PTS1000
.loop:	animf	0,-1,BAT1+6,1
	animj	.loop
.endif
;
;	snowman
;
snoxtab:	.dc.b	14,94
snoinit:
	animini	2,3,7,14, 48,-6,1,SNOWMAN,snoseq,snodseq,T_ST
snoseq:
	anims	S_NOTHREAT
	animf	0,0,SNOWMAN,15
	animf	0,0,SNOWMAN+3,15
	animf	0,0,SNOWMAN+6,15
	animf	0,0,SNOWMAN+9,20
	animf	0,0,SNOWMAN+6,15
	animf	0,0,SNOWMAN+3,15
	animf	0,0,SNOWMAN,  15
	anims	S_SETINIT
snodseq:
	anima	SNOD
	animf	0,0,SNOWMAN+9,20
	animd	-3,30
	animp	PTS1000
	anims	S_SETINIT
;
;	falling ice stalactites
;
iceinit:
	animini	1,2,6,SCHWP,SCHL,-1,ONESEC,ICE1,iceseq,icedseq,T_XY
iceseq:
	animl	20
.loop:	animf	0,-2,ICE1,2
	animf	0,-2,ICE1,2
	animf	0,-2,ICE2,2
	animf	0,-2,ICE2,2
	animj	.loop

	anima	ICEHIT
	animj	icebseq
icedseq:
	animp	PTS500				;death
	anima	ICED
icebseq:
	anims	S_NOTHREAT | S_INVULNERABLE	;break
	animf	0,0,ICE3,ONESEC/4
	anims	S_SETINIT
;
;	stalagtite that enables path when shot down
;
fstinit:
	animini	2,2,6,64,146,S_NOTHREAT,ONESEC,FST1,fstseq,fstdseq,T_XY
fstseq:
	animf	0,0,FST2,45
	animf	0,0,FST1,30
	animf	0,0,FST3,45
	animf	0,0,FST1,30
	animj	fstseq
fstdseq:
	animp	PTS500
fstdseq2:					;for auto-drop
	anims	S_NOTHREAT | S_INVULNERABLE
	anima	FSTDA
	anima	FSTDB
.loop1:
	animf	0,-2,FST1,1
	animj	.loop1
fstqseq:			;quiescent sequence
	animf	0,0,FST1,60
	animj	fstqseq
;
;	cave stops: where the friends will have to wait for a stag to fall
;	input: bit 0 = first fallen, bit 1 = second fallen
;	out: resulting stop
;
cavestoptab:
	.dc.b	CAVESTOP1,CAVESTOP2,CAVESTOP1,FRNOSTOP
;
;	room anims
;
;	dragon
;
draginit:
	animini	2,5,5,118,152,-3,ONESEC,DRAG,dragseq,dragdseq,T_ST
dragseq:
	anima	GROWL
	animf	0,0,DRAG,10
	animf	0,0,DRAG+5,10
	animf	0,0,DRAG+10,10
	animf	0,0,DRAG+15,30
	anims	S_TRIGGER
	anima	WHIP
	animf	0,0,DRAG+20,20
	animf	0,0,DRAG+15,10
	animf	0,0,DRAG+10,10
	animf	0,0,DRAG+5,10
	animf	0,0,DRAG,10
	anims	-3
	animj	dragseq
dragdseq:
	anima	GROWL
	animf	0,0,DRAG+20,15
	animp	PTS1500
	animf	0,0,DRAG+15,7
	animf	0,0,DRAG+10,7
	animf	0,0,DRAG+5,7
	animf	0,0,DRAG,7
	anims	-3
	animj	dragseq
;
;	room fire balls from dragon
;
roofrblinit:
animini	1,3,2,118,162,S_HANG,ONESEC,ROOFRBL,roofrblseq,roofrbldseq,T_XY

roofrblseq:
	animf	-4,-8,ROOFRBL+6,5
	animl	5
.loop:
	animf	-2,-4,ROOFRBL,5
	animf	-2,-4,ROOFRBL,5
	animf	-2,-4,ROOFRBL+3,5
	animf	-2,-4,ROOFRBL+3,5
	animf	-2,-4,ROOFRBL+6,5
	animj	.loop
	anims	S_SETINIT
roofrbldseq:
	anima	LAMPD
	animp	PTS1500
	anims	S_SETINIT
;
;	falling daggers in room
;
daggerinit:
	animini	1,1,4,20,SCHL,-5,0,DAGGER1,daggerseq,daggerdseq,T_XY
daggerseq:

	animl	5
.loop:
	animf	1,-3,DAGGER1,2
	animf	0,-3,DAGGER1,2
	animf	0,-3,DAGGER1,2
	animf	0,-3,DAGGER1,2
	animf	-1,-3,DAGGER2,2
	animf	0,-3,DAGGER2,2
	animf	0,-3,DAGGER2,2
	animf	0,-3,DAGGER2,2
	animf	0,-3,DAGGER3,2
	animf	0,-3,DAGGER3,2
	animf	0,-3,DAGGER3,2
	animf	0,-3,DAGGER3,2
	animf	0,-3,DAGGER2,2
	animf	0,-3,DAGGER2,2
	animf	0,-3,DAGGER2,2
	animf	0,-3,DAGGER2,2
	animj	.loop
daggerdseq:
	animp	PTS1500
	anims	S_SETINIT
;
;	trap door
;
trapinit:
animini	2,6,6,75,ZONEHL*2,S_HANG,ONESEC,TRAP1,trapseq,0,T_ST

trapseq:
	anima	TRAPSOUND
	anims	S_NOTHREAT | S_INVULNERABLE
	animf	0,0,TRAP2,6
	animf	0,0,TRAP3,6
	anims	S_NOTHREAT | S_INVULNERABLE | S_TRIGGER
	animf	0,0,TRAP4,6
	animf	0,0,TRAP5,12
	animf	0,0,TRAP4,6
	animf	0,0,TRAP3,6
	animf	0,0,TRAP2,6
	anims	S_HANG
	animj	trapseq
;
;	torches
;	
torchinit:
	animini	1,2,2,41,ZONEHL*7,S_NOTHREAT,32,TORCH,torchseq,torchdseq,T_ST
torchseq:
	animf	0,0,TORCH,12
	animf	0,0,TORCH+2,12
	animf	0,0,TORCH+4,12
	animf	0,0,TORCH+6,12
	animj	torchseq
torchdseq:
	anima	LAMPD
	animp	PTS500
	anims	S_HANG
;
;	room treasure chest
;
chestinit:
	animini	1,3,2,SCHWP,ZONEHL*3,S_NOTHREAT | S_INVULNERABLE,20,CHEST,chestseq,chestdseq,T_ST
chestseq:
	animf	0,0,CHEST+3,12
	animf	0,0,CHEST,12
	animj	chestseq
chestdseq:
	anima	TREASURE
	animp	PTS2500
	anims	-10
	anims	S_HANG
;
;	red face on statue, triggered by removal of chest
;
rdfaceinit:
	animini	1,2,2,75,116,S_HANG,ONESEC,RDFACE,rdfaceseq,0,T_ST

rdfaceseq:
	animf	0,0,RDFACE,ONESEC
	anims	S_TRIGGER | S_INVULNERABLE | S_NOTHREAT
	anims	S_SETINIT
;
;	spear out of right wall
;
spearinit:
animini	1,4,2,SCWP,ZONEHL*4,S_HANG,ONESEC,SPEAR,.spearseq,.speardseq,T_XY
.spearseq:
	animf	0,0,SPEAR,ONESEC*3

	anima	SPEARS
	animl	SCWP + (4*4)
.loop:	animf	-1,0,SPEAR,2
	animj	.loop

.speardseq:
	anima	LAMPD
	animp	PTS1500
	anims	S_SETINIT
;
;	flash on statue's staff, triggered by friends over trap door
;
flashinit:
	animini	1,2,4,61,116,S_HANG,1,FLASH,flashseq,flashdseq,T_ST
flashseq:
	animf	0,0,FLASH,15
	animf	0,0,FLASH+2,15
	animj	flashseq
flashdseq:
	anims	S_TRIGGER | S_INVULNERABLE | S_NOTHREAT
	animp	PTS2000
	animf	0,0,FLASH+2,30
	animj	flashseq
;
;	face1 left of statue
;
face1init:
	animini	1,3,2,35,ZONEHL*8,-1,ONESEC,FACE1,.face1seq,.face1dseq,T_ST
.face1seq:
	anims	-7
	animf	0,0,FACE1,10
	animf	0,0,FACE1+3,10
	animf	0,0,FACE1+6,10
	animf	0,0,FACE1+9,10
	animf	0,0,FACE1+12,10
	animf	0,0,FACE1+9,10
	animf	0,0,FACE1+6,10
	animf	0,0,FACE1+9,10
	animf	0,0,FACE1+12,10
	animf	0,0,FACE1+9,10
	animf	0,0,FACE1+6,10
	animf	0,0,FACE1+3,10
	animf	0,0,FACE1,10
	animj	.face1seq
.face1dseq:
	anima	FACE1D
	animf	0,0,SHOTF1,15
	animp	PTS1500
	animj	.face1seq
;
;	face2 left of statue
;
face2init:
	animini	1,3,3,115,ZONEHL*5,-1,ONESEC,FACE2,.face2seq,.face2dseq,T_ST
.face2seq:
	anims	-11
	animf	0,0,FACE2,10
	animf	0,0,FACE2+3,10
	animf	0,0,FACE2+6,10
	animf	0,0,FACE2+9,10
	animf	0,0,FACE2+12,10
	animf	0,0,FACE2+15,10
	animf	0,0,FACE2+12,10
	animf	0,0,FACE2+9,10
	animf	0,0,FACE2+6,10
	animf	0,0,FACE2+3,10
	animf	0,0,FACE2,10
	animj	.face2seq
.face2dseq:
	anima	FACE2D
	animf	0,0,SHOTF2,15
	animp	PTS1500
	animj	.face2seq
;
;	face screen animations
;
wteyelinit:
	animini	1,4,4,60,ZONEHL*8,S_INVULNERABLE,1,WTEYE,wteyeseq,wteyedseq,T_ST
wteyerinit:
	animini	1,4,4,86,ZONEHL*8,S_INVULNERABLE,1,WTEYE2,wteyeseq,wteyedseq,T_ST
wteyedseq:
	anima	WHTEYED
	animp	PTS5000
wteyeseq:
	anims	S_INVULNERABLE | S_SYNC
wteyesync:
	animf	0,0,WTEYE+8 ,1
	anims	S_INVULNERABLE
	animf	0,0,WTEYE+8 ,29
	anims	0
	animf	0,0,WTEYE+4 ,15
	animf	0,0,WTEYE   ,6
	animf	0,0,WTEYE+12,6
	animf	0,0,WTEYE   ,6
	animf	0,0,WTEYE+12,6
	animf	0,0,WTEYE   ,15
	animf	0,0,WTEYE+4 ,10
	animj	wteyeseq
rdeyelinit:
	animini	1,4,3,60,ZONEHL*8,0,25,RDEYE4,rdeyelseq,rdeyedseq,T_ST
rdeyerinit:
	animini	1,4,3,86,ZONEHL*8,0,25,RDEYE3,rdeyerseq,rdeyedseq,T_ST
rdeyelseq:
	anims	N_FD1
	animf	0,0,RDEYE3,6
	anims	N_FD2
	animf	0,0,RDEYE3,6
	anims	N_FD3
	animf	0,0,RDEYE3+4,6
	anims	N_FD4
	animf	0,0,RDEYE3+8,6
	anims	N_FD5
	animf	0,0,RDEYE3+8,6
	anims	N_FD6
	animf	0,0,RDEYE3+8,6
	anims	N_FD7
	animf	0,0,RDEYE3+4,6
	anims	N_FD8
	animf	0,0,RDEYE3,6
	animj	rdeyelseq
rdeyerseq:
	anims	N_FD9
	animf	0,0,RDEYE3,6
	anims	N_FD10
	animf	0,0,RDEYE3,6
	anims	N_FD11
	animf	0,0,RDEYE3+4,6
	anims	N_FD12
	animf	0,0,RDEYE3+8,6
	anims	N_FD13
	animf	0,0,RDEYE3+8,6
	anims	N_FD14
	animf	0,0,RDEYE3+8,6
	anims	N_FD15
	animf	0,0,RDEYE3+4,6
	anims	N_FD16
	animf	0,0,RDEYE3,6
	animj	rdeyelseq
rdeyedseq:
	anima	BLAH
	animp	PTS5000
	animf	0,0,RDEYE3+12,30
	anims	S_HANG
;
;	face daggers
;
fdtab:	.dc.w	fdll,fdl,fdc,fdr,fdrr,fdr,fdc,fdl
	.dc.w	fdll,fdl,fdc,fdr,fdrr,fdr,fdc,fdl

fdll:	animini	1,2,3,80,80,0,1,FDS+2,fdllseq,fddseq,T_XY
fdl:	animini	1,2,3,80,80,0,1,FDS+2,fdlseq,fddseq,T_XY
fdc:	animini	1,2,3,80,80,0,1,FDS+4,fdcseq,fddseq,T_XY
fdr:	animini	1,2,3,80,80,0,1,FDS  ,fdrseq,fddseq,T_XY
fdrr:	animini	1,2,3,80,80,0,1,FDS  ,fdrrseq,fddseq,T_XY

fdllseq:
	animf	2 ,0 ,FDS+2,2
	animl	12
.loop:	animf	0 ,-4,FDS+2,2
	animf	-2,-4,FDS+2,2
	animj	.loop
	anims	S_SETINIT

fdlseq:
	animf	2 ,0 ,FDS+2,2
	animl	12
.loop:	animf	0 ,-4,FDS+2,2
	animf	-1,-4,FDS+2,2
	animj	.loop
	anims	S_SETINIT
fdcseq:
	animf	6,0,FDS+4,2
	animl	24
.loop:	animf	0,-4,FDS+4,2
	animj	.loop
	anims	S_SETINIT
fdrseq:
	animf	10,0,FDS,2
	animl	24
.loop:	animf	1,-4,FDS,2
	animj	.loop
	anims	S_SETINIT
fdrrseq:
	animf	10,0,FDS,2
	animl	24
.loop:	animf	2,-4,FDS,2
	animj	.loop
	anims	S_SETINIT
fddseq:
	anima	LAMPD
	animp	PTS5000
	anims	S_SETINIT
;
;	bank table .. cursc to ROM bank
;
banktab:
	.dc.b	MAPBANK,CAVBANK,TOWBANK,DESBANK,JUNBANK
	.dc.b	CASBANK,VOLBANK,BRIBANK,ROOBANK,FACBANK
	.dc.b	TITBANK
;
;	palette data arranged by screen, has been moved to bm\bdf.s
;
;
;	header lists
;	format: hdrdat	zone,baddr,pal,width,hpos
;	hdrdatend
;
roohdrs:
	hdrdat	4,ROOM1+(13*0),6,13,54	;statue
	hdrdat	5,ROOM1+(13*1),6,13,54
	hdrdat	6,ROOM1+(13*2),6,13,54
	hdrdat	7,ROOM1+(13*3),6,13,54
	hdrdat	8,ROOM1+(13*4),6,13,54
	hdrdat	9,ROOM1+(13*5),6,13,54
	hdrdat	0,ROOM2,6,20,0		;bricks
	hdrdat	0,ROOM2,6,20,SCHWP
	hdrdat	1,ROOM2,6,20,SCWP/4
	hdrdat	1,ROOM2,6,10,(SCWP/4)*3
	hdrdat	1,ROOM2+10,6,10,0
	hdrdat	2,C1B,6,20,0		;dithered floor
	hdrdat	2,C1B,6,SCHWB-7,SCHWP
	hdrdat	3,C1B,6,SCHWB-7,SCHWP
	hdrdat	3,C1B,6,SCHWB-7,7*4
	hdrdat	10,ROOM3,6,15,0		;ceiling left
	hdrdat	11,ROOM3+15,6,15,0
	hdrdat	10,ROOM4,6,15,SCWP-(15*4)	;ceiling right
	hdrdat	11,ROOM4+15,6,15,SCWP-(15*4)
	hdrdat	3,ROOM5+(0*7),6,7,0	;left wall
	hdrdat	4,ROOM5+(1*7),6,7,0
	hdrdat	5,ROOM5+(2*7),6,7,0
	hdrdat	6,ROOM5+(3*7),6,7,0
	hdrdat	7,ROOM5+(3*7),6,7,0
	hdrdat	8,ROOM5+(4*7),6,7,0
	hdrdat	9,ROOM5+(5*7),6,7,0
	hdrdat	2,ROOM6,6,7,SCWP-(7*4)
	hdrdat	3,ROOM6+7,6,7,SCWP-(7*4)
	hdrdat	4,ROOM6+(7*2),6,7,SCWP-(7*4)
	hdrdat	5,ROOM6+(7*2),6,7,SCWP-(7*4)
	hdrdat	6,ROOM6+(7*2),6,7,SCWP-(7*4)
	hdrdat	7,ROOM6+(7*2),6,7,SCWP-(7*4)
	hdrdat	8,ROOM6+(7*2),6,7,SCWP-(7*4)
	hdrdat	9,ROOM6+(7*2),6,7,SCWP-(7*4)
	hdrdat	10,COAT,6,4,SCHWP-8		;coat of arms
	hdrdat	7,BOWL,7,2,13
	hdrdat	6,BOWL,7,2,41
	hdrdat	6,BOWL,7,2,114
	hdrdat	7,BOWL,7,2,142
	hdrdat	2,TRAP1,6,6,75
	hdrdat	3,TRAP1+$1000,6,6,75
	hdrdatend
;
;	map screen
;
;	path buttons
;
p3hdrs:
	hdrdat	1,PATHBUT+3,1,(SCWB/3)+1,0	;red
	hdrdat	2,PATHBUT+3+20,1,(SCWB/3)+1,0
	hdrdat	1,PATHBUT+3,2,(SCWB/3)+1,SCWP/3	;green
	hdrdat	2,PATHBUT+3+20,2,(SCWB/3)+1,SCWP/3
	hdrdat	1,PATHBUT+3,3,(SCWB/3)+1,(SCWP/3)*2	;blue
	hdrdat	2,PATHBUT+3+20,3,(SCWB/3)+1,(SCWP/3)*2
	hdrdat	1,REDP,1,6,5			;"red"
	hdrdat	1,GREENP,2,6,(SCWP/3)+5		;"green"
	hdrdat	1,BLUEP,3,6,((SCWP/3)*2)+5	;"blue"
	hdrdatend
p2hdrs:
	hdrdat	1,PATHBUT,1,SCHWB,0	;red
	hdrdat	2,PATHBUT+20,1,SCHWB,0
	hdrdat	1,PATHBUT,2,SCHWB,SCHWP	;green
	hdrdat	2,PATHBUT+20,2,SCHWB,SCHWP
	hdrdat	1,REDP,1,6,17			;"red"
	hdrdat	1,GREENP,2,6,SCHWP+17		;"green"
	hdrdatend
;
;	map icons
;
iconhdrs:
	hdrdat	9,MAPDES,6,9,28		;desert
	hdrdat	10,MAPDES+9,6,9,28
	hdrdat	9,MAPCAV,6,9,72		;cave
	hdrdat	10,MAPCAV+9,6,9,72
	hdrdat	8,MAPCAS,0,7,126	;castle
	hdrdat	9,MAPCAS+7,0,7,126
	hdrdat	10,MAPCAS+14,0,7,126
	hdrdat	7,MAPFR,6,3,12		;friend
	hdrdat	8,MAPFR+3,6,3,12
	hdrdat	5,MAPVOL,4,12,44	;volcano
	hdrdat	6,MAPVOL+12,4,12,44
	hdrdat	7,MAPVOL+24,4,12,44
	hdrdat	6,MAPJUN,6,10,92	;jungle
	hdrdat	7,MAPJUN+10,6,10,92
	hdrdat	3,MAPTOW,6,10,12	;town
	hdrdat	4,MAPTOW+10,6,10,12
	hdrdat	3,MAPBRI,5,13,64	;bridge
	hdrdat	4,MAPBRI+13,5,13,64
	hdrdat	3,MAPROO,4,6,124	;room
	hdrdat	4,MAPROO+6,4,6,124
	hdrdat	3,RAGD,7,20,0		;ragged down, up
	hdrdat	3,RAGD+20,7,20,SCHWP
	hdrdat	11,RAGU,7,20,0
	hdrdat	11,RAGU+20,7,20,SCHWP
	hdrdatend

raglr2:
	talldat	3,RAGL+2+(5*3),1,5,0  ,9,3,7	;ragged left and right
	talldat	3,RAGR+  (5*3),1,5,148,9,3,7	;for map screen
	talldatend
;
;	path list
;
pathlist:
	.dc.w	p02,p03,p13,p14,p15,p23,p26,p27,p34,p36,p45,p46,p47,p57,p58,p67
;		0    1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
;
;	map path lines between icons
;
p03:	hdrdat	8,PATHLINES,7,2,25
	hdrdatend
p02:	hdrdat	7,PATHLINES+2,7,2,25
	hdrdat	6,PATHLINES+4,7,1,32
	hdrdat	5,PATHLINES+4,7,1,32
	hdrdatend
p13:	hdrdat	9,PATHLINES+5,7,3,62
	hdrdatend
p14:	hdrdat	8,PATHLINES+2,7,2,98
	hdrdatend
p15:	hdrdat	9,PATHLINES+5,7,4,110
	hdrdatend
p23:	hdrdat	5,PATHLINES+4,7,1,38
	hdrdat	6,PATHLINES+4,7,1,38
	hdrdat	7,PATHLINES+4,7,1,38
	hdrdat	8,PATHLINES+4,7,1,38
	hdrdatend
p26:	hdrdat	4,PATHLINES+1,7,1,52
	hdrdat	5,PATHLINES,7,1,56
	hdrdatend
p27:	hdrdat	4,PATHLINES+5,7,4,52
	hdrdatend
p34:	hdrdat	8,PATHLINES+3,7,1,97
	hdrdat	8,PATHLINES+5,7,8,65
	hdrdat	8,PATHLINES+2,7,1,61
	hdrdatend
p36:	hdrdat	8,PATHLINES+2,7,2,57
	hdrdatend
p45:	hdrdat	7,PATHLINES,7,2,130
	hdrdatend
p46:	hdrdat	6,PATHLINES+5,7,3,80
	hdrdatend
p47:	hdrdat	5,PATHLINES+4,7,1,104
	hdrdatend
p57:	hdrdat	7,PATHLINES+4,7,1,137
	hdrdat	6,PATHLINES+4,7,1,137
	hdrdat	5,PATHLINES+1,7,1,134
	hdrdat	5,PATHLINES+5,7,5,114
	hdrdat	5,PATHLINES,7,1,110
	hdrdat	4,PATHLINES+1,7,1,106
	hdrdatend
p58:	hdrdat	7,PATHLINES+4,7,1,140
	hdrdat	6,PATHLINES+4,7,1,140
	hdrdat	5,PATHLINES+4,7,1,140
	hdrdatend
p67:	hdrdat	5,PATHLINES+3,7,1,80
	hdrdat	4,PATHLINES+2,7,1,84
	hdrdatend
;
;	"don't shoot your friends"
;
hdrdntsht:
	hdrdat	8,DNTSHT,7,29,22
	hdrdatend
;
;	"level completed"
;
hdrlvlcmp:
	hdrdat	8,LVLCMP,7,29,23
	hdrdatend
;
;	"survival bonus" and "new friend"
;
hdrsrvbns:
	hdrdat	1,COLOR1,7,9,22
	hdrdat	2,COLOR1,7,9,22
	hdrdat	3,COLOR1,7,9,22
	hdrdat	4,COLOR1,7,9,22
	hdrdat	5,COLOR1,7,9,22
	hdrdat	5,SRVBNS,7,8,26
	hdrdatend
hdrnewfr:
	hdrdat	1,COLOR1,7,9,102
	hdrdat	2,COLOR1,7,9,102
	hdrdat	3,COLOR1,7,9,102
	hdrdat	4,COLOR1,7,9,102
	hdrdat	5,COLOR1,7,9,102
	hdrdat	5,NEWFR,7,6,109
	hdrdatend
hdrbns:
	hdrdat	2,BONUS,3,21,38
	hdrdatend
hdryouhav:
	hdrdat	2,YOUHAVE + $1000,3,24,32
	hdrdatend
hdrtry:
	hdrdat	2,YOUHAVE,3,24,32
	hdrdatend

mestab:	.dc.w	hdrtry,hdryouhav

crsbwhdr:				;main title screen
	hdrdat	6,LOGO2,3,1,160-12	;tail of dragon
	hdrdat	5,BM_SELECT,5,22,36
	hdrdat	2,COPYR + 18,7,19,42
	hdrdat	1,COPYR     ,7,18,44
	hdrdatend
ragudhdr:
	hdrdat	0,RAGD,7,20,0
	hdrdat	0,RAGD+20,7,20,SCHWP
	hdrdat	11,RAGU,7,20,0
	hdrdat	11,RAGU+20,7,20,SCHWP
	hdrdatend
gmovrhdr:
	hdrdat	7,THEEND,7,14,52
	hdrdat	5,FINAL,7,6,28
	hdrdat	5,SCORE,7,7,54
	hdrdat	3,HIGH,7,4,32
	hdrdat	3,SCORE,7,7,54
	hdrdatend
gtrdyhdr:
	hdrdat	7,GTRDY,0,18,44
	hdrdatend
;
;	tall object data
;
logotall:
	talldat	7,CBLOGO   ,4,38,5       ,4,19,6
	talldat	7,CBLOGO+19,4,38,5+(4*19),4,19,6
	talldat	9,LOGO3,2,16,5,2,16,4
	talldat	7,LOGO4,4,15,96,4,15,3
	talldatend

raglr1:
	talldat	0,RAGL,1,5,$FB,12,5,7	;for title screens
	talldat	0,RAGR,1,5,145,12,5,7
	talldatend

cavtall:
	talldat	0,BM_CAVE,2,22,0,12,22,BKGPAL	;cave background
	talldat	0,BM_CAVE+2,2,22,88,12,22,BKGPAL
	talldatend

towtall:
	talldat	3,BM_TOWN,3,40,0,6,20,BKGPAL
	talldat	3,BM_TOWN+20,3,40,80,6,20,BKGPAL
	talldat	9,CHIMN2,1,2,88,2,2,3
	talldat	9,ROOF,1,11,88,2,11,BKGPAL
	talldatend
destall:
	talldat	7,DES1,   1,SCWB,    0,2,20,BKGPAL
	talldat	7,DES1+20,1,SCWB,SCHWP,2,20,BKGPAL
	talldat	0,DES2,   1,20  ,    0,7,20,5
	talldat	0,DES2,   1,20  ,SCHWP,7,20,5
	talldatend
desclouds:
	hdrdat	9,CLOUD1,7,6,33
	hdrdat	10,CLOUD2,7,9,108
	hdrdatend
juntall:
	talldat	4,JUN1   ,2,SCWB,0    ,6,SCHWB,BKGPAL
	talldat	4,JUN1+20,2,SCWB,SCHWP,6,SCHWB,BKGPAL
	talldatend
castall:
	talldat	6,CAS2,2,24,0,2,24,4
	talldat	0,CAS3,2,12,74,4,12,5
	talldat	0,CAS1,2,18,88,12,18,BKGPAL
	talldatend
casclouds:
	hdrdat	8,CLOUD1,7,6,55
	hdrdat	9,CLOUD2,7,9,9
	hdrdatend

plaintall:
	talldat	0,$8000     ,4,40,0    ,12,20,BKGPAL
	talldat	0,$8000 + 20,4,40,SCHWP,12,20,BKGPAL
	talldatend

facetall:
	talldat	4,BM_FACE,4,22,((SCWP - (22*4))/2),8,22,6
	talldatend
skulltall:
	talldat	4,BM_SKULL,4,17,((SCWP - (17*4))/2) + 3,8,17,2
	talldatend
eyehdrs:
	hdrdat	8,WTEYE,4,4,60		;face eyes open
	hdrdat	8,WTEYE2,4,4,86
	hdrdatend

bewarehdrs:
	hdrdat	10,BEWARE,2,14,52
	hdrdat	8,FOOLISH,2,19,42
	hdrdat	6,FORI,2,19,4
	hdrdat	6,FORI+19,2,19,80
	hdrdat	4,IHAVE,2,23,34
	hdrdat	3,CONQUER,2,23,34
	hdrdat	1,NOWPRE,2,30,20
	hdrdatend

;	talldat	curzon,baddr,srcht,srcw,hpos,desth,destw,pal
.end
