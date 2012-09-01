;	file: equates.s
;
;	Atari 7800 Crossbow
;	File of equates
;
TRUE	equ	$FF
FALSE	equ	0

DEBUG	equ	FALSE		;set false for final release

FIXROM	equ	$C000		;start of fixed ROM at top of cart
CODE	equ	FIXROM		;program code

NUMBPAL	equ	8		;number of pals
PALS	equ	$20		;start of MARIA pals

BKGPAL	equ	6		;background pal

;
;	time: 60 fields=1 sec
;
ONESEC	equ	60
;
;	bank switching
;
BANKSW	equ	$8000
;
;	screen banks
;
MAPBANK	equ	0	;should be 0
CAVBANK	equ	3	;should be 3
TOWBANK	equ	2	;should be 2
DESBANK	equ	4	;should be 4
JUNBANK	equ	3	;should be 3
CASBANK	equ	6	;should be 6
VOLBANK	equ	1	;should be 1
BRIBANK	equ	5	;should be 5
ROOBANK	equ	4	;should be 4
FACBANK	equ	2	;should be 2
TITBANK	equ	0	;should be 0
;
;	screen constants
;
MAP	equ	0
CAVE	equ	1
TOWN	equ	2
DESERT	equ	3
JUNGLE	equ	4
CASTLE	equ	5
VOLCANO	equ	6
BRIDGE	equ	7
ROOM	equ	8
FACE	equ	9
TITLE	equ	10

NUMBSCRS equ	10	;number of screens
;
;	display header constants
;
HDRSIZE	equ	4	;4 byte header
ZONECNT	equ	12	;12 zones
MAXHDRS	equ	32	;maximum headers
HDRPITCH equ	MAXHDRS * HDRSIZE	;header pitch
;
;	colors
;
BLACK	equ	0
GRAY	equ	$07
WHITE	equ	$0F
ORANGE	equ	$28
FLESH1	equ	$2A	;caucasion
FLESH2	equ	$26	;negroid
RED	equ	$32
VIOLET	equ	$53
BLUE	equ	$73
LTBLUE	equ	$78
CYAN	equ	$8A
GRASS	equ	$C4
GREEN1	equ	$C7
GREEN	equ	$C9
YELLOW	equ	$EB
LTYELLOW equ	$EF
SAND1	equ	$EC
SAND2	equ	$EF
BROWN	equ	$F1
;
;	interrupts
;
NUMBINT	equ	9

INTZB	equ	0	;if these are enabled or disabled, remember
;INTZA	equ	-	;to change romzon enables
INTZ9	equ	2
INTZ8	equ	4
;INTZ7	equ	-
INTZ6	equ	6
INTZ5	equ	8
;INTZ4	equ	-
INTZ3	equ	10
INTZ2	equ	12
;INTZ1	equ	-
INTZ0	equ	14
INTBOT	equ	16
;
;	fade in/out
;
FADEIN	equ	1
FADEOUT	equ	$FF
MAXFADE	equ	16
FADSP	equ	4	;fade speed
;
;	player's score
;
SCRDGTS	equ	7	;score digits
DGTWP	equ	6	;digit width pixels
LDZERO	equ	$0F	;leading zero
;
;	points displayed on enemy death
;
PTS500	equ	0
PTS1000 equ	1
PTS1500 equ	2
PTS2000 equ	3
PTS2500 equ	4
PTS5000 equ	5
;
;
;	bitmap image constants
;
SCHL	equ	192			;screen height lines
SCHHL	equ	SCHL/2			;half height lines
PITCHB	equ	256			;pitch bytes
PITCHP	equ	PITCHB*4		;pitch pixels
REGHL	equ	64			;region height lines
SCWP	equ	160			;screen width pixels
SCHWP	equ	SCWP/2			;screen halfwidth pixels
SCWB	equ	40			;screen width bytes
SCHWB	equ	SCWB/2			;screen half width bytes
ZONEHL	equ	16			;zone height lines
ZONEHB	equ	ZONEHL * PITCHB		;zone height bytes
;
;	map screen
;
NUMBPATHS	equ	16	;drawn paths between icons
BLINKTIME	equ	ONESEC/4
CHOOSERED	equ	0
CHOOSEGREEN	equ	1
CHOOSEBLUE	equ	2
;
;	moving objects
;
MAXMOV	equ	32		;maximum number of moving objects

FRIEND0	equ	0
FRIEND1	equ	1
;
;	cursor
;
CURPAL	equ	7	;pal
CURWP	equ	4	;width pixels
CURWB	equ	CURWP/4	;width bytes
CURPW	equ	(CURPAL << 5) | (((~CURWB)+1)&$1f) ;pal, width
CURADDRH equ	$A0	;addr high
CURADDRL equ	$08	;low
N_CURSOR equ	2
;
;	eye .. many screens
;
N_EYE	equ	3
;
;	cave screen
;
ICE	equ	4		;falling icicles in cave
MAXICE	equ	7
N_FST1	equ	12
N_FST2	equ	13
N_SNOWMAN equ	14
N_BAT	equ	15
N_CAVET	equ	16
;
;	points that the friends must stop at before something is done
;	these numbers must be even, since frs are only on even pixels
;
CAVESTOP1	equ	52	;shoot stalags to make them fall
CAVESTOP2	equ	132	;and let the frs pass
;
;	town screen
;
N_WOLF	equ	4
N_WIN1	equ	5
N_WIN2	equ	6
N_WIN3	equ	7
N_WIN4	equ	8
N_WIN5	equ	9
N_WIN6	equ	10
N_GHOST	equ	11
N_BOLT	equ	12
N_WIZ	equ	13
N_FRBALL equ	14
N_LAMP1	equ	15
N_LAMP2	equ	16
N_LAMP3	equ	17
N_TOWNT	equ	18
;
;	desert screen
;
N_SCORP	equ	4
ANTS	equ	5
MAXANTS	equ	5
N_BIRD	equ	10
N_SNAKE	equ	11
N_RABBIT equ	12
N_DEST	equ	13
;
;	jungle screen
;
N_PLANT	equ	4
N_CHIMP1 equ	5
N_CHIMP2 equ	6
N_TOC2	equ	7
N_COCO	equ	8
N_TOC1	equ	9
N_CHIMP3 equ	10
N_BAG	equ	11
;
;	castle screen
;
N_DOOR	equ	4
N_CHAIN1 equ	5
N_CHAIN2 equ	6
N_ARCHERS equ	7
MAXARCHERS equ	7
N_ARROWS  equ	N_ARCHERS+MAXARCHERS
MAXARROWS equ	MAXARCHERS
N_PTERA	equ	N_ARROWS + MAXARROWS
N_ALI2	equ	N_PTERA+1
;
;	bridge screen
;
N_FROG	equ	4
N_FISH	equ	5
N_ALI	equ	6
N_BEAVER equ	7
N_BUZZ	equ	8
N_ROCKBRI equ	9
N_OWL	equ	10
;
;	volcano screen
;
N_ROCK1		equ	4
N_ROCK2		equ	5
N_FLROCK1	equ	6
N_FLROCK2	equ	7
N_DIAMOND	equ	8
N_BLDR		equ	9
N_VOLUP1	equ	10
N_VOLUP2	equ	11
N_LTNG		equ	12
N_SKYFLASH	equ	13
N_LRIVER	equ	14
;
;	room screen
;
N_DRAG		equ	4
N_DAGGER1	equ	5
N_DAGGER2	equ	6
N_DAGGER3	equ	7
N_SPEAR1	equ	8
N_SPEAR2	equ	9
N_SPEAR3	equ	10
N_TRAP		equ	11
N_ROOFRBL	equ	12
N_TORCH1	equ	13
N_TORCH2	equ	14
N_TORCH3	equ	15
N_TORCH4	equ	16
N_CHEST		equ	17
N_RDFACE	equ	18
N_FLASH		equ	19
N_FACE1		equ	20
N_FACE2		equ	21
;
;	face screen
;
N_EYEL		equ	4	;eyes
N_EYER		equ	5
N_FD1		equ	N_EYER + 1	;face daggers
N_FD2		equ	N_FD1 + 1
N_FD3		equ	N_FD2 + 1
N_FD4		equ	N_FD3 + 1
N_FD5		equ	N_FD4 + 1
N_FD6		equ	N_FD5 + 1
N_FD7		equ	N_FD6 + 1
N_FD8		equ	N_FD7 + 1
N_FD9		equ	N_FD8 + 1
N_FD10		equ	N_FD9 + 1
N_FD11		equ	N_FD10 + 1
N_FD12		equ	N_FD11 + 1
N_FD13		equ	N_FD12 + 1
N_FD14		equ	N_FD13 + 1
N_FD15		equ	N_FD14 + 1
N_FD16		equ	N_FD15 + 1
;
;	moving object statuses
;
S_IDLE		equ	%10000000
S_NOTHREAT	equ	%01000000
S_INVULNERABLE	equ	%00100000
S_STOPPED	equ	%00010000
S_SYNC		equ	%00010000
S_QUIET		equ	%00001000
S_TRIGGER	equ	%00000100
S_DEPENDENT	equ	%00000010
S_LAUNCH	equ	10

S_SETINIT	equ	$80
S_READINIT	equ	$81
S_HANG		equ	$82
;
;	animation type codes
;
T_XY	equ	0	;moves in x and y
T_ST	equ	$FF	;stationary
;
;	animation instruction codes
;
A_AUDIO	equ	0
A_JUMP	equ	2
A_STATUS equ	4
A_POINTS equ	6
A_LOOP	equ	8
A_DELTA	equ	10

JUMPALWAYS	equ	$FF	;wild card loop counter
;
;	the friends
;
NUMBFRS	equ	8

MAXFFRAMES	equ	16	;maximum friend frames


DEATHID	equ	8	;flaming death
HERO	equ	7
WOMAN	equ	6
NEGRO	equ	5
DWARF	equ	4
GIRL	equ	3
WIMP	equ	2
MERLIN	equ	1
MONK	equ	0
;
;	statuses
;
POTENTIAL	equ	0	;not yet joined party
JOINED		equ	1	;ready to cross screen
CROSSING	equ	2	;onscreen
SURVIVED	equ	3	;crossed
DEAD		equ	4
;
;	active statuses
;
WALKING	equ	0
WAITING	equ	1
FIGHTING equ	2
DIEING	equ	3 | S_INVULNERABLE
DROPPING equ	4	;thru trap door
FALLING	equ	5	;in face screen
;
;
;
FRWP	equ	12		;width pixels
FRWB	equ	FRWP/4		;width bytes
FRSTPOS	equ	(0 - FRWP)& $ff	;start pos
FALLHPOS equ	10		;falling in face screen hpos
FALLTIME equ	6		;fields per frame

;invalid stop position to use when friends shouldn't be stopped

FRNOSTOP	equ	(FRSTPOS + SCWP)/2	
.end
