;
;	file: addr.s
;
;
;crsbw bitmap address equates
;
;lower fixed bank ($4000 to 7FFF)
;
;friend frames

HER	equ	$5000		;3 z high
WOM	equ	HER + (6*3)
NEG	equ	WOM + (6*3)	
WIM	equ	NEG + (6*3)	
MER	equ	WIM + (6*3)
DWA	equ	MER + (6*3)		;2 z high
GIR	equ	DWA + (6*3)
MON	equ	GIR + (6*3)
DIE	equ	MON + (6*3)	;death frames, 2 high
;
;	1 zone vermov
;
;cursor
CURSOR1	equ	$6100 - (5*2)
CURSOR2	equ	CURSOR1+2
CURSOR3	equ	CURSOR2+2
CURSOR4	equ	CURSOR3+2
CURSOR5 equ	CURSOR4+2

;points display on deaths
POINTS	equ	CURSOR1-17
P500	equ	POINTS+5
P1000	equ	POINTS
P1500	equ	POINTS+4
P2000	equ	POINTS+8
P2500	equ	POINTS+12
P5000	equ	POINTS+13
;
;	1 zone non-vermov
;
COLOR1	EQU	DWA + $2000

;score digits
DIGITS	equ	DIE + (4*3)
ZERO	equ	DIGITS
ONE	equ	ZERO + (2 * 1)
TWO	equ	ZERO + (2 * 2)
THREE	equ	ZERO + (2 * 3)
FOUR	equ	ZERO + (2 * 4)
FIVE	equ	ZERO + (2 * 5)
SIX	equ	ZERO + (2 * 6)
SEVEN	equ	ZERO + (2 * 7)
EIGHT	equ	ZERO + (2 * 8)
NINE	equ	ZERO + (2 * 9)
BLANK	equ	ZERO + (2 * 10)

;eye
EYE1	equ	DIGITS + $1000
EYE2	equ	EYE1+3
EYE3	equ	EYE2+3
EYE4	equ	EYE3+3
EYE5	equ	EYE4+3
EYE6	equ	EYE5+3
EYE7	equ	EYE6+3

;"level completed"
LVLCMP	equ	EYE7 + 3

;"don't shoot your friends!"
DNTSHT	equ	BLANK + 2

;"survival bonus"
SRVBNS	equ	DNTSHT + 29

;"new friend"
NEWFR	equ	SRVBNS + 8

;clouds (desert, castle)
CLOUD1	equ	LVLCMP + 29
CLOUD2	equ	CLOUD1 + 6

;
;switch bank bitmaps
;
;bank 0
;
;map screen
BM_MAP	equ	$8080
PATHBUT	equ	$9026
REDP	equ	$B02A
GREENP	equ	$B030
BLUEP	equ	$B036
MAPDES	equ	$8000
MAPCAV	equ	$9000
MAPVOL	equ	$B006
MAPJUN	equ	$8012
MAPTOW	equ	$9012
MAPROO	equ	$8026
MAPBRI	equ	$A015
MAPCAS	equ	$A000
MAPFR	equ	$B000

;ragged edges for title screens
RAGL	equ	$A02F
RAGR	equ	$8032
RAGU	equ	$B03C
RAGD	equ	$904E

;"now prepare to face me"
NOWPRE	equ	RAGD + 40

;"beware foolish mortal" etc.
CONQUER	equ	$8100 - 38
IHAVE	equ	CONQUER + $1000
FORI	equ	IHAVE + $1000
BEWARE	equ	FORI + $1000
FOOLISH	equ	BEWARE + 14

;path lines
PATHLINES	equ	RAGU + 40

;game logo
CBLOGO	equ	CONQUER - 38
LOGO4	equ	CBLOGO - 15
LOGO3	equ	LOGO4 - 16

;copyright notices (width: 31)
COPYR	equ	PATHLINES + 13

;"THE END" "FINAL SCORE" "HIGH"
THEEND	equ	RAGL + (5*12)
FINAL	equ	THEEND + 14
SCORE	equ	FINAL + 6
HIGH	equ	SCORE + 7

;select gun/stick
BM_SELECT	equ	THEEND + 31

;"GET READY"
GTRDY	equ	RAGR + (5*12)
LOGO2	equ	GTRDY + 18
;
;	bank 3 (cave,jungle)
;
;	backgrounds
;
BM_CAVE	equ	$8000
JUN1	equ	$A000

;checkerboard of colors 2 and 3
C23	EQU	JUN1 + (40*3)
;
;	one-zone non-movers
;
JUN2	equ	$B100 - 20
JUN3	equ	JUN2 - 20
JUN4	equ	JUN3 - 20
MITE1	equ	JUN4 - (3*2)
MITE2	equ	MITE1 - 3
MITE3	equ	MITE2 - 3
MITE4	equ	MITE3 - 3
JUNPRI	equ	MITE4 - 3
CAVET	equ	JUNPRI - 3
;
;	two-zone vermov objects
;
FST3	equ	$8100 - 2
FST2	equ	FST3 - 2
FST1	equ	FST2 - 2
SNOWMAN	equ	FST1 - 12
MONKEY	equ	SNOWMAN - (4*3)
MONKE2	equ	MONKEY - (3*3)
MONKE3	equ	MONKE2 - (3*3)
MONKE4	equ	MONKE3 - (3*3)
MONKE5	equ	MONKE4 - 3
PLANT	equ	MONKE5 - (4*3)
;
;	one-zone vermovers
;
COCO1	equ	PLANT - 3
COCO2	equ	COCO1 - (3*3)
ICE3	equ	COCO2 - 3
ICE2	equ	ICE3 - 3
ICE1	equ	ICE2 - 3

BAT1	equ	ICE1 - (3*3)
BAT2	equ	BAT1 - (3*3)

TOCAN	equ	CAVET - $1000 - (3*6)
TOCAN2	equ	TOCAN - (3*3)
;
;
;town and face screens (bank 2)
;large backgrounds
BM_TOWN	equ	$8000		;w=40 * 3
BM_FACE	equ	BM_TOWN+(40*2)	;add width of town background
BM_SKULL equ	BM_FACE+(22*2)
;
;	smaller backgrounds
ROOF	equ	$B000		;w=11 * 2
CHIMN2	equ	$B016		;w=3 * 2
FFLOOR	equ	CHIMN2 + 6	;w = 12 * 3
;
;	two non-vermovers
BM_WIN2	equ	BM_FACE - (3*2) + $3000
BM_WIN3	equ	BM_WIN2 - (3*2)
WLFDED	equ	BM_WIN3 - 3		;must be in same page as wolf
;
;ver movers 1 high
FDS	equ	$8100 - (3*2)
CHIMN1	equ	FDS - 3		;w=3
STAR	equ	CHIMN1-1	;w=1
GHOST1	equ	STAR-(6*5)	;gst frames (6x5x1)
GHOST2	equ	GHOST1+5
GHOST3	equ	GHOST2+5
GHOST4	equ	GHOST3+5
GHOST5	equ	GHOST4+5
GHOST6	equ	GHOST5+5
BOLT	equ	GHOST1-(2*2)
FRBALL	equ	BOLT - (2*3)
LAMP1	equ	FRBALL - (2*2)
LAMP2	equ	LAMP1 + 2
;
;non-ver movers 2 high
WIZA	equ	$A100-(15*3)
WIZB	equ	WIZA + (5*3)
WIZC	equ	WIZB + (5*3)
;
;non-vermovs 1 high
WTEYE	equ	LAMP1 - (4*4)
WTEYE2	equ	WTEYE + $1000
RDEYE3	equ	WTEYE2 + $1000
RDEYE4	equ	RDEYE3 + $1000

RDEYE6	equ	RDEYE3 + (3*4)
RDEYE5	equ	RDEYE4 + (3*4)

YOUHAVE	equ	BM_SKULL + (17*2)

BONUS	equ	YOUHAVE + $2000

WOLF	equ	RDEYE4 - (6*3) 	;must be in same page as wlfded

BM_WIN1	equ	WIZA - (4*2)
BM_WIN6	equ	WIZA - (4*2) + $1000

BM_WIN4	equ	WOLF - (3*2)
BM_WIN5	equ	RDEYE3 - (3*2)

TOWNT	equ	BM_WIN4 - 3
;
;	desert and room screens
;
;	2-zone high ver movers
DRAG	equ	$8100 - (5*5)
RABBIT	equ	DRAG - (4*3)

;	1-zone high ver movers
DAGGER1	equ	RABBIT - (3*1)
DAGGER2	equ	DAGGER1 + 1
DAGGER3	equ	DAGGER2 + 1
BIRD1R	equ	DAGGER1 - (4*6)
BIRD2R	equ	BIRD1R - (4*6)
ROOFRBL	equ	BIRD2R - (3*3)
SPEAR	equ	ROOFRBL - 4
;
;	2-zone non-vmov
TRAP1	equ	RABBIT + $2000 - (5*6)
TRAP2	equ	TRAP1+6
TRAP3	equ	TRAP2+6
TRAP4	equ	TRAP3+6
TRAP5	equ	TRAP4+6

;	1-zone non-vmov
SCORPION equ	$B100 - (3 * 4)
COAT	equ	SCORPION - 4
SNAKE	equ	COAT - (4*2)
TORCH	equ	SNAKE - (4*2)
BOWL	equ	TORCH - 2

CHEST	equ	TRAP1 - (3*2)
RDFACE	equ	CHEST - 2
FLASH	equ	RDFACE - (2*2)

;	1-zone vermov
ANTL	equ	FLASH - (4*3)
ANTR	equ	ANTL - (4*3)

;background parts
DES1	equ	$8000	;2Z x 40b	mountains
DES2	equ	$9000	;7z x 20b	ground
CACTUS	equ	$A000	;6z x 10b	onlayed cactus
;
DEST	equ	DES2 + (7*20)		;desert treasure, 3 wide
;
;	room screen backgrounds
;
C1B	equ	$B000
ROOM1	equ	$B014
ROOM2	equ	$A032
ROOM3	equ	$A046
ROOM4	equ	$8050	;15*2
ROOM5	equ	$B062
ROOM6	equ	$A064	;7*3
.if 0
BM_ROOM	equ	$8080
.endif
;
;	face frames (1z non-mov)
;
FACE1	equ	ROOM6 + (7*3)		;(5*3)
SHOTF1	equ	FACE1 + (5*3)		;3
FACE2	equ	ROOM4 + (15*2)		;(6*3)
SHOTF2	equ	FACE2 + (6*3)		;3
;
;	castle screen (bank 6)
;
CAS1	equ	$8000
CAS2	equ	$A000
CAS3	equ	CAS2 + 24
DOOR2	equ	CAS3 + 24
DOOR1	equ	DOOR2 + $1000
DOOR4	equ	DOOR2 + 40
DOOR7	equ	DOOR1 + 35
DOOR9	equ	DOOR4 + 30
;
;	two zone vermov
;
ARCHER1	equ	$8100 - (5*3)
ARCHER2	equ	ARCHER1+3
ARCHER3	equ	ARCHER2+3
ARCHER4	equ	ARCHER3+3
ARCHER5	equ	ARCHER4+3
PTERA	equ	ARCHER1 - (5*6)
PTDIE	equ	PTERA - (2*6)

ARROW3	equ	PTDIE - 3
ARROW4	equ	ARROW3 - 3

CHAIN	equ	ARROW4 - (4*3)
;
;	1 zone stat
;
ALI2	equ	$B000 - (6*3)
;
;	volcano screen
;
BM_VOLCANO	equ	$8000
LRIVER	equ	BM_VOLCANO + (40*3)
;
;	3-zone vermov
;
BLDR1	equ	$8100 - (3 * 6)
;
;	2-zone vermov
;
LTNING	equ	BLDR1 - 3
;
;	1-zone vermov
;
VROCK	equ	LTNING - (4*3)
VROCK2	equ	VROCK - 3
VROCK3	equ	VROCK2 - (4*3)
VROCK4	equ	VROCK3 - 2
DIAMND	equ	VROCK4 - 3
;
;	bridge screen (bank 5)
;
BM_BRIDGE	equ	$8000
;
;	two-zone vermovers
;
BIRD1	equ	$8100 - (5*6)
DYING1	equ	BIRD1 - (2*6)
ROCKA	equ	DYING1 - (4*3)
ROCKB	equ	ROCKA - (4*3)
ROCKC	equ	ROCKB - (2*3)
ROCKD	equ	ROCKC - 3
;
;	one-zone vermovers
;
FROG		equ	ROCKD - (5*2)
FISH		equ	FROG - (7*3)
;
;	two-zone non-movers
;
BEAVER	equ	FISH - (6*3)
OWL	equ	BEAVER - (4*3)

BRONLAY	equ	ROCKD + $2000 - 40
;
;	one-zone stationary
;
ALI		equ	$B100 - (6*3)
;
;	special code addresses for lower fixed bank
;
COLTAB	equ	$4B00
BATINIT	equ	$4C00
DOGUN	equ	$4D00
SCPALTAB equ	$4F00

.end
