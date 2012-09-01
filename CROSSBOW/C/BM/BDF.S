	.subttl	"bdf.s"
;	bank data fixed (from $4000 to $7FFF)
;
;	This bank contains graphics and code common to many screens, plus
;	some overflow code and tables from the main section ($C000-$FFFF).
;
;	Special code and tables run from $4000 to $4FFF.
;	GRAPHICS ONLY from $5000 to $7FFF.
;
;	They are: Audio tables, collision table, cave bat sequence,
;	and light gun subroutine.
;
	.6502

	.include	"\\INCLUDE\\MARIA.S"
	.include	"\\C\\EQUATES.S"
	.include	"\\C\\AUDEQU.S"
	.include	"ADDR.S"
	.include	"\\C\\MACROS.S"
	.include	"\\C\\VARS.S"
;
;	friends
;
bitmap	HER - (6*$100),	"HERO.S"
bitmap	WOM - (6*$100),	"WOMAN.S"
bitmap	NEG - (6*$100),	"NEGRO.S"
bitmap	DWA - (6*$100),	"DWARF.S"
bitmap	GIR - (6*$100),	"GIRL.S"
bitmap	WIM - (6*$100),	"WIMP.S"
bitmap	MER - (6*$100),	"MERLIN.S"
bitmap	MON - (6*$100),	"MONK.S"
bitmap	DIE,	"DIE.S"
;
;	vermov
;
bitmap	CURSOR1,	"CURSOR.S"
bitmap	POINTS,	"points.s"
;
;	misc
;
bitmap	DIGITS,	"DIGITS.S"
bitmap	COLOR1,	"C1.S"
bitmap	SRVBNS,	"SRVBNS.S"
bitmap	NEWFR,	"NEWFR.S"
bitmap	CLOUD1,	"cloud1.s"
bitmap	CLOUD2,	"cloud2.s"
bitmap	DNTSHT,	"dntsht.s"
bitmap	LVLCMP,	"lvlcmp.s"
bitmap	EYE1,	"eye.s"
;
;	audio data in this bank
;

.org	AUDADDR
soundtable:			;open space for id table
.org	AUDADDR + AUDIDCNT

audstart	TESTA,4,0
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audend

audstart	TESTB,4,0
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audend

audstart	TESTC,1,7
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audi	15,15,60
audend

audstart	TESTD,1,7
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audi	15,17,60
audend

audstart	BEEP,4,7
audi	$F,8,2
audi	$12,8,2
audi	$9,8,2
audi	$4,8,2
audend

audstart	BARF,2,4
audi	$F,4,10
audend

audstart	AH1,1,4	;monk,dwarf dies
audi	15,20,5
audi	14,20,4
audi	13,20,5
audi	12,21,4
audi	11,21,5
audi	10,21,4
audi	9,22,5
audi	8,22,4
audi	7,22,5
audi	6,23,4
audi	5,23,5
audi	4,23,4
audi	3,24,5
audi	2,24,4
audi	1,24,5
audend

audstart	AH3,1,4	;hero, wimp, merlin dies
audi	10,17,6
audi	15,16,18
audi	13,17,1
audi	12,17,1
audi	11,17,1
audi	10,17,1
audi	09,18,1
audi	08,18,1
audi	07,18,1
audi	06,18,1
audi	05,19,1
audi	04,19,1
audi	03,19,1
audi	02,19,1
audi	01,19,1
audend

audstart	AH2,4,4	;woman, girl dies
audi	15,28,9
audi	15,26,15
audi	15,23,10
audi	15,22,2
audi	14,23,3
audi	13,24,3
audi	12,25,3
audi	11,26,3
audi	9,27,3
audi	7,28,3
audi	5,29,3
audi	3,30,3
audi	1,31,3
audend

audstart	AH4,1,4	;negro dies
audi	15,16,2
audi	14,17,2
audi	13,18,2
audi	12,19,2
audi	11,20,2
audi	10,21,2
audi	09,22,2
audi	08,23,2
audi	07,24,2
audi	06,25,2
audi	05,26,2
audi	04,27,2
audi	03,28,2
audi	02,29,2
audi	01,30,2
audend

audstart	OUCH,6,4

audi	$F,2,1
audi	$F,3,1
audi	$F,4,1
audi	$F,5,1
audi	$F,6,1
audi	$A,7,1
audi	$5,8,1
audend

audstart	OWHER,1,4	;hero ow!
audi	$F,15,2
audi	$E,16,1
audi	$E,17,2
audi	$E,18,1
audi	$E,19,2
audi	$E,21,1
audi	$D,22,2
audi	$D,23,1
audi	$D,24,2
audi	$D,25,1
audi	$D,26,2
audi	$C,27,1
audi	$C,28,2
audi	$C,29,1
audi	$C,30,2
audi	$C,31,1
audi	$B,30,3
audend

audstart	OWDWA,1,4	;dwarf ow!
audi	$F,19,2
audi	$F,20,2
audi	$E,21,2
audi	$E,22,2
audi	$D,23,2
audi	$D,24,2
audi	$C,25,2
audi	$C,26,2
audi	$B,27,2
audi	$B,28,2
audi	$A,27,2
audend

audstart	OWWOM,4,4	;woman ow!
audi	$F,23,2
audi	$F,24,2
audi	$E,25,2
audi	$E,26,2
audi	$D,27,2
audi	$D,28,2
audi	$C,29,2
audi	$C,30,2
audi	$B,31,1
audend

audstart	UWILLDA,1,7
audi	$4,18,4	;you
audi	$8,18,4
audi	$C,18,4
audi	$8,18,4
audi	$4,18,4
audi	$0,0,4

audi	$4,19,4	;will
audi	$8,19,4
audi	$C,19,4
audi	$8,19,4
audi	$4,19,4
audi	$0,0,4

audi	$F,19,5	;die
audi	$F,20,5
audi	$D,21,4
audi	$C,22,5
audi	$A,23,4
audi	$9,24,5
audi	$8,25,5
audi	$7,26,4
audi	$5,27,5
audi	$4,28,4
audi	$3,29,5
audi	$2,30,4
audi	$1,31,5
audend

audstart	UWILLDB,8,7
audi	2,16,6	;you
audi	4,16,8
audi	2,16,6
audi	0,0,4

audi	2,16,6	;will
audi	4,16,8
audi	2,16,6
audi	0,0,4

audi	$F,12,4	;die
audi	$F,15,4
audi	$E,13,4
audi	$D,14,4
audi	$C,15,4
audi	$A,13,4
audi	$9,13,4
audi	$8,11,4
audi	$7,15,4
audi	$6,16,4
audi	$5,11,4
audi	$4,12,4
audi	$3,13,4
audi	$2,12,4
audi	$1,13,4
audend

audstart	DIEA,1,7

audi	$F,19,5	;die
audi	$F,20,5
audi	$D,21,4
audi	$C,22,5
audi	$A,23,4
audi	$9,24,5
audi	$8,25,5
audi	$7,26,4
audi	$5,27,5
audi	$4,28,4
audi	$3,29,5
audi	$2,30,4
audi	$1,31,5
audend

audstart	DIEB,8,7

audi	$F,12,4	;die
audi	$F,15,4
audi	$E,13,4
audi	$D,14,4
audi	$C,15,4
audi	$A,13,4
audi	$9,13,4
audi	$8,11,4
audi	$7,15,4
audi	$6,16,4
audi	$5,11,4
audi	$4,12,4
audi	$3,13,4
audi	$2,12,4
audi	$1,13,4
audend

audstart	CROAK,$f,4
audi	$F,1,2
audi	$7,1,8
audend

audstart	FIRE,8,1
audi	4,10,2
audi	2,18,2
audi	1,22,2
audi	2,21,2
audi	4,17,2
audi	8,13,2
audi	12,8,1
audi	4,8,1
audend

audstart	CUCKOO,$C,7
audi	2,11,1
audi	5,11,1
audi	8,11,1
audi	11,11,1
audi	14,11,3
audi	10,11,1
audi	05,11,1
audi	02,11,1
audi	0,0,4
audi	1,14,1
audi	3,14,1
audi	5,14,1
audi	7,13,1
audi	9,13,1
audi	11,13,1
audi	13,13,1
audi	14,13,5
audi	08,14,1
audi	02,14,1
audend

audstart	CLANKA,5,7
audi	15,10,1
audi	8,10,1
audi	7,10,2
audi	6,10,2
audi	5,10,2
audi	4,10,2
audi	3,10,3
audi	2,10,3
audi	1,10,3
audi	1,10,1	;vol once was 5
audend

audstart	CLANKB,5,7
audi	15,28,1
audi	11,28,1
audi	10,28,1
audi	9,28,2
audi	8,28,2
audi	7,28,3
audi	6,28,3
audi	5,28,3
audi	7,28,2
audi	3,28,2
audend

audstart	CLANK2A,5,7
audi	2,10,1
audi	1,10,19
audend

audstart	CLANK2B,5,7
audi	2,28,1
audi	1,28,19
audend

audstart	TREASURE,4,1
audi	1,6,2
audi	1,5,2
audi	1,4,2
audi	1,3,2
audend

audstart	HAHAHA,1,6
audi	8,7,1
audi	15,7,3
audi	12,7,1
audi	8,7,1
audi	4,8,1
audi	0,0,15
audi	4,8,1
audi	15,8,3
audi	12,8,1
audi	8,8,1
audi	4,9,1
audi	0,0,11
audi	04,09,01
audi	08,09,01
audi	12,10,02
audi	15,10,02
audi	14,11,02
audi	13,12,01
audi	12,13,02
audi	11,14,02
audi	10,15,02
audi	09,16,01
audi	08,17,02
audi	07,18,01
audi	06,19,02
audi	05,20,02
audi	04,21,02
audi	03,20,02
audi	02,20,01
audi	01,21,02
audend

audstart	BLAH,3,4
audi	8,27,1
audi	9,26,6
audi	10,25,1
audi	11,24,1
audi	12,23,1
audi	13,22,1
audi	14,21,1
audi	15,20,1
audi	15,19,1
audi	14,19,1
audi	13,19,1
audi	12,19,1
audi	11,19,1
audi	10,19,1
audi	09,19,1
audi	08,19,1
audi	07,19,1
audi	06,19,1
audi	05,19,1
audi	04,20,1
audi	03,21,1
audi	02,22,1
audi	01,23,1
audend

audstart	BOOM,8,2
audi	15,31,2
audi	14,31,2
audi	13,31,2
audi	12,31,2
audi	11,31,2
audi	10,31,2
audi	09,31,2
audi	08,31,2
audi	07,31,2
audi	06,31,2
audi	05,31,2
audi	04,31,2
audi	03,31,2
audi	02,31,2
audi	01,31,2
audend

audstart	WHIP,8,5
audi	$F,15,1
audi	$F,16,1
audi	$F,17,1
audi	$D,18,1
audi	$B,19,1
audi	$9,20,1
audi	$7,21,1
audi	$5,22,1
audi	$3,23,1
audi	$1,24,1
audend
;
;	cave
;
audstart	BATCRY,4,2
audi	4,19,1
audi	8,20,1
audi	8,21,1
audi	4,22,1
audi	0,0,1
audi	4,19,1
audi	8,20,1
audi	8,21,1
audi	4,22,1
audend

audstart	ICED,4,4
audi	15,12,1
audi	12,12,1
audi	10,12,1
audi	6,13,1
audi	4,13,1
audi	2,13,1
audend

audstart	FSTDA,$C,4
audi	15,11,2
audi	10,11,4
audi	8,11,4
audi	6,11,4
audi	4,11,4
audi	2,11,4
audend

audstart	FSTDB,4,4
audi	15,18,2
audi	10,19,4
audi	8,19,4
audi	6,19,4
audi	4,19,4
audi	2,19,4
audend

audstart	BATD,4,4
audi	15,25,3
audi	13,25,4
audi	11,25,2
audi	09,24,3
audi	07,24,3
audi	05,24,2
audi	04,23,4
audi	03,23,2
audi	02,23,4
audi	01,23,3
audend

audstart	SNOD,1,4
audi	14,15,10
audi	15,14,6
audi	14,14,6
audi	13,15,6
audi	12,15,6
audi	11,16,6
audi	10,16,6
audi	09,17,6
audi	08,17,6
audi	07,18,6
audi	06,18,6
audi	05,19,6
audi	04,19,6
audi	03,19,6
audi	02,19,6
audi	01,19,6
audend

audstart	ICEHIT,8,2
audi	8,4,1
audi	4,4,1
audend
;
;	town
;
audstart	THANKYOU,1,4
audi	8,8,10
audi	0,0,10
audi	8,9,10	
audend

audstart	WHOHAHA,$C,5
audi	2,25,1
audi	4,25,1
audi	6,25,1
audi	8,25,1
audi	10,25,1
audi	12,25,1
audi	13,25,1
audi	11,25,1
audi	9,25,1
audi	7,25,1
audi	5,25,1
audi	3,25,1

audi	2,26,1
audi	4,26,1
audi	6,26,1
audi	8,26,1
audi	10,26,1
audi	12,26,1
audi	13,26,1
audi	27,26,1
audi	9,26,1
audi	7,26,1
audi	5,26,1
audi	3,26,1

audi	2,27,1
audi	4,27,1
audi	6,27,1
audi	8,27,1
audi	10,27,1
audi	12,27,1
audi	13,27,1
audi	11,27,1
audi	9,27,1
audi	7,27,1
audi	5,27,1
audi	3,27,1

audi	2,28,1
audi	4,28,1
audi	6,28,1
audi	8,28,1
audi	10,28,1
audi	12,28,1
audi	13,28,1
audi	11,28,1
audi	9,28,1
audi	7,28,1
audi	5,28,1
audi	3,28,1

audi	2,29,1
audi	4,29,1
audi	6,29,1
audi	8,29,1
audi	10,29,1
audi	12,29,1
audi	13,29,1
audi	11,29,1
audi	9,29,1
audi	7,29,1
audi	5,29,1
audi	3,29,1
audi	0,0,12

audi	2,30,1
audi	4,30,1
audi	6,30,1
audi	8,30,1
audi	10,30,1
audi	12,30,1
audi	13,30,1
audi	11,30,1
audi	9,30,1
audi	7,30,1
audi	5,30,1
audi	3,30,1
audi	0,0,12

audi	2,30,1
audi	4,30,1
audi	6,30,1
audi	8,30,1
audi	10,30,1
audi	12,30,1
audi	13,30,1
audi	11,30,1
audi	9,30,1
audi	7,30,1
audi	5,30,1
audi	3,30,1
audi	0,0,12

audi	2,31,1
audi	4,31,1
audi	6,31,1
audi	8,31,1
audi	10,31,1
audi	12,31,1
audi	13,31,1
audi	13,31,36
audi	11,31,1
audi	9,31,1
audi	7,31,1
audi	5,31,1
audi	3,31,1
audend

audstart	OHHH,$C,4
audi	12,19,10
audi	10,20,43
audi	12,19,10
audi	12,20,20
audi	12,21,10
audi	06,21,10
audi	03,22,10
audend

audstart	POOF,8,5
audi	15,15,1
audi	14,15,1
audi	13,15,1
audi	12,15,1
audi	11,15,1
audi	10,15,1
audi	9,15,1
audi	8,15,1
audi	7,15,1
audi	6,15,1
audi	5,15,1
audi	4,15,1
audi	3,15,1
audi	2,15,1
audi	1,15,1
audend

audstart	BOLTDIE,$C,4
audi	15,7,1
audi	12,7,1
audi	9,6,1
audi	6,6,1
audend

audstart	WIZFB,8,5
audi	15,10,6
audi	14,10,6
audi	13,10,6
audi	12,10,6
audi	11,10,6
audi	10,10,6
audi	9,10,6
audi	8,10,6
audi	7,10,6
audi	6,10,6
audi	5,10,6
audi	4,10,6
audi	3,10,6
audi	2,10,6
audi	1,10,6
audend

audstart	LAMPD,8,4
audi	12,10,9
audend

audstart	WOLFD,8,4
audi	15,15,8
audi	12,16,8
audi	10,17,8
audend

audstart	CURSUA,1,6
audi	0,0,6
audi	10,18,14
audi	0,0,20
audi	6,22,10
audi	8,22,10
audi	5,22,10
audi	2,23,10
audend

audstart	CURSUB,8,6
audi	12,5,3
audi	0,0,17
audi	8,5,10
audi	6,5,3
audi	3,5,3
audend
;
;	desert
;
audstart	ANTD,1,4
audi	8,12,2
audi	6,7,1
audi	5,8,1
audi	4,9,1
audi	3,10,1
audi	2,11,1
audi	1,12,1
audend

audstart	SCORPD,1,4
audi	15,7,1
audi	0,0,1
audi	15,7,1
audi	0,0,1
audi	15,7,1
audi	0,0,1
audi	15,6,1
audi	0,0,1
audi	15,6,1
audi	0,0,1
audi	15,6,1
audi	0,0,1
audend

audstart	BIRDD,1,4
audi	15,10,15
audi	13,11,6
audi	11,11,6
audi	09,12,6
audi	07,12,6
audi	05,12,6
audi	03,13,6
audi	01,13,5
audend

audstart	RAB,1,2
audi	4,31,2
audi	3,31,2
audi	2,31,2
audi	1,31,2
audi	4,31,2
audi	3,31,2
audi	2,31,2
audi	1,31,2
audend

audstart	BIRDCRY,4,5
audi	6,10,1
audi	4,11,1
audi	2,12,1
audi	0,0,2
audi	6,10,1
audi	4,11,1
audi	2,12,1
audi	0,0,2
audend

audstart	SNAKED,1,4
audi	15,6,1
audi	13,7,1
audi	11,8,1
audi	09,9,1
audi	07,10,1
audi	05,10,1
audi	03,10,1
audend

audstart	RABD,1,4
audi	15,6,4
audi	13,5,3
audi	11,4,4
audend
;
;	jungle sounds
;
audstart	TOCANCRY,4,5
audi	12,19,1
audi	12,20,1
audi	12,21,1
audi	12,22,1
audi	12,23,1
audi	12,19,1
audi	10,20,1
audi	09,21,1
audi	08,22,1
audi	07,23,1
audi	06,24,1
audi	05,25,1
audi	04,26,1
audi	03,27,1
audi	02,28,1
audi	01,29,1
audend

.if 0		;old chimp sound
audstart	CHIMPD,4,4
audi	15,31,1
audi	0,0,1
audi	15,31,1
audi	0,0,1
audi	15,31,1
audi	0,0,10
audi	15,31,1
audi	0,0,1
audi	15,31,1
audi	0,0,1
audi	15,30,1
audi	0,0,1
audi	15,30,1
audi	0,0,1
audi	15,30,1
audi	0,0,1
audi	15,30,1
audi	0,0,1
audi	15,30,1
audi	0,0,1
audi	15,30,1
audi	0,0,1
audi	15,29,1
audi	0,0,1
audi	15,29,1
audi	0,0,1
audi	13,29,1
audi	0,0,1
audi	13,29,1
audi	0,0,1
audi	11,29,1
audi	0,0,1
audi	11,28,1
audi	0,0,1
audi	9,28,1
audi	0,0,1
audi	9,28,1
audi	0,0,1
audi	7,29,1
audi	0,0,1
audi	7,29,1
audi	0,0,1
audi	5,29,1
audi	0,0,1
audi	5,30,1
audi	0,0,1
audi	3,30,1
audi	0,0,1
audi	3,30,1
audi	0,0,1
audi	1,31,1
audend
.endif

audstart	CHIMPD,4,4	;new chimp sound
audi	15,9,1
audi	0,0,1
audi	15,9,1
audi	0,0,1
audi	15,9,1
audi	0,0,10
audi	15,9,1
audi	0,0,1
audi	15,9,1
audi	0,0,1
audi	15,8,1
audi	0,0,1
audi	15,8,1
audi	0,0,1
audi	15,8,1
audi	0,0,1
audi	15,8,1
audi	0,0,1
audi	15,8,1
audi	0,0,1
audi	15,8,1
audi	0,0,1
audi	15,7,1
audi	0,0,1
audi	15,7,1
audi	0,0,1
audi	13,7,1
audi	0,0,1
audi	13,7,1
audi	0,0,1
audi	11,7,1
audi	0,0,1
audi	11,7,1
audi	0,0,1
audi	9,7,1
audi	0,0,1
audi	9,7,1
audi	0,0,1
audi	7,7,1
audi	0,0,1
audi	7,7,1
audi	0,0,1
audi	5,7,1
audi	0,0,1
audi	5,8,1
audi	0,0,1
audi	3,8,1
audi	0,0,1
audi	3,8,1
audi	0,0,1
audi	1,9,1
audend

audstart	PLANTD,8,4
audi	12,25,2
audi	0,0,2
audi	12,25,2
audi	0,0,2
audi	12,25,2
audi	0,0,2
audi	12,25,2
audi	0,0,2
audi	12,25,2
audi	0,0,2
audi	12,25,2
audi	0,0,2
audi	12,25,2
audi	0,0,2
audend
;
;	castle sounds
;
audstart	BOW,4,5
audi	8,11,1
audi	7,12,1
audi	6,13,1
audi	5,14,1
audi	4,15,1
audi	3,16,1
audi	2,17,1
audi	1,18,1
audend

audstart	PTERACRY,4,5
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1

audi	0,0,23

audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	15,12,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audi	11,13,1
audi	0,0,1
audend

audstart	PTERAD,1,4
audi	15,6,1
audi	15,7,1
audi	15,8,1
audi	15,10,1
audi	15,11,1
audi	15,12,1
audi	10,14,1
audi	05,15,1
audi	02,17,1
audend

audstart	ARCHERD,$C,4
audi	15,6,1
audi	14,7,1
audi	13,8,1
audi	11,10,1
audi	10,11,1
audi	9,12,1
audi	7,14,1
audi	6,15,1
audi	5,16,1
audi	3,18,1
audi	2,19,1
audi	1,20,1
audend

audstart	FANFAREA,4,7
audi	$8,13,1
audi	$C,13,2
audi	$8,13,1
audi	$4,13,1
audi	0,0,5

audi	$8,16,1
audi	$C,16,2
audi	$8,16,1
audi	$4,16,1
audi	0,0,5

audi	$8,21,1
audi	$C,21,2
audi	$8,21,1
audi	$4,21,1
audi	0,0,5

audi	$8,25,1
audi	$C,25,2
audi	$8,25,1
audi	$4,25,1
audi	0,0,5

audi	$8,21,1
audi	$C,21,2
audi	$8,21,1
audi	$4,21,1
audi	0,0,5

audi	$8,16,1
audi	$C,16,2
audi	$8,16,1
audi	$4,16,1
audi	0,0,5

audi	$8,13,1
audi	$C,13,1
audi	$C,13,2
audi	$A,13,2
audi	$8,13,1
audi	$6,13,1
audi	$4,13,1
audi	$2,13,1
audi	0,0,10

audi	$8,16,1
audi	$C,16,2
audi	$8,16,1
audi	$4,16,1
audi	0,0,5

audi	$8,21,1
audi	$C,21,2
audi	$8,21,1
audi	$4,21,1
audi	0,0,5

audi	$8,25,1
audi	$C,25,2
audi	$8,25,1
audi	$4,25,1
audi	0,0,5

audi	$8,21,1
audi	$C,21,2
audi	$8,21,1
audi	$4,21,1
audi	0,0,5

audi	$8,16,1
audi	$C,16,2
audi	$8,16,1
audi	$4,16,1
audi	0,0,5

audi	$8,13,1
audi	$C,13,1
audi	$C,13,2
audi	$A,13,2
audi	$8,13,1
audi	$6,13,1
audi	$4,13,1
audi	$2,13,1
audend

audstart	FANFAREB,4,7
audi	$8,16,1
audi	$C,16,2
audi	$8,16,1
audi	$4,16,1
audi	0,0,5

audi	$8,21,1
audi	$C,21,2
audi	$8,21,1
audi	$4,21,1
audi	0,0,5

audi	$8,25,1
audi	$C,25,2
audi	$8,25,1
audi	$4,25,1
audi	0,0,5

audi	$8,31,1
audi	$C,31,2
audi	$8,31,1
audi	$4,31,1
audi	0,0,5

audi	$8,25,1
audi	$C,25,2
audi	$8,25,1
audi	$4,25,1
audi	0,0,5

audi	$8,21,1
audi	$C,21,2
audi	$8,21,1
audi	$4,21,1
audi	0,0,5

audi	$8,16,1
audi	$C,16,1
audi	$C,16,2
audi	$A,16,1
audi	$8,16,2
audi	$6,16,1
audi	$4,16,1
audi	$2,16,1
audi	0,0,10

audi	$8,21,1
audi	$C,21,2
audi	$8,21,1
audi	$4,21,1
audi	0,0,5

audi	$8,25,1
audi	$C,25,2
audi	$8,25,1
audi	$4,25,1
audi	0,0,5

audi	$8,31,1
audi	$C,31,2
audi	$8,31,1
audi	$4,31,1
audi	0,0,5

audi	$8,25,1
audi	$C,25,2
audi	$8,25,1
audi	$4,25,1
audi	0,0,5

audi	$8,21,1
audi	$C,21,2
audi	$8,21,1
audi	$4,21,1
audi	0,0,5

audi	$8,16,1
audi	$8,16,1
audi	$C,16,2
audi	$C,16,2
audi	$8,16,1
audi	$8,16,1
audi	$4,16,1
audi	$4,16,1

audend
;
;	bridge
;
audstart	FROGJ,1,2
audi	1,31,2
audi	1,31,2
audi	0,0,4
audi	1,31,2
audi	1,31,2
audi	0,0,4
audend

audstart	OWLCRY,4,2
audi	8,26,10
audi	12,25,10
audi	8,26,5
audi	4,27,5
audend

audstart	BLOOP,4,5
audi	8,18,1
audi	7,17,1
audi	6,16,1
audi	5,15,1
audi	4,14,1
audi	3,13,1
audi	2,12,1
audi	1,11,1
audend
;
;	volcano
;
audstart	UPBOOM,8,2
audi	12,8,2
audi	11,9,2
audi	10,10,2
audi	9,11,2
audi	8,12,2
audi	7,13,2
audi	6,14,2
audi	5,15,2
audi	4,16,2
audi	3,17,2
audi	2,18,2
audi	1,19,2
audend

audstart	ROCKDIE,8,4
audi	15,14,2
audi	12,15,2
audi	8,15,2
audend

audstart	FROCKD,8,4
audi	15,3,1
audi	11,4,1
audi	07,5,1
audend

audstart	FACE1D,4,4
audi	7,15,2
audi	0,0,4
audi	7,13,2
audi	0,0,4
audi	5,11,2
audi	0,0,4
audi	2,11,2
audend

audstart	FACE2D,4,4
audi	7,10,2
audi	0,0,4
audi	7,09,4
audi	0,0,4
audi	5,07,2
audi	0,0,4
audi	2,07,2
audend

audstart	GROWL,1,5
audi	15,15,5
audi	15,14,5
audi	14,15,1
audi	13,16,1
audi	12,17,1
audi	11,18,1
audi	10,19,1
audi	09,20,1
audi	08,21,1
audi	07,22,1
audi	06,23,1
audi	05,24,1
audi	04,25,1
audi	03,26,1
audi	02,27,1
audi	01,28,1
audend

audstart	SPEARS,8,5
audi	15,10,5
audi	10,20,5
audend

audstart	TRAPSOUND,1,5
audi	15,25,1
audi	10,20,1
audi	8,15,1
audi	6,10,1
audi	4,5,1
audend

audstart	WHTEYED,1,4
audi	15,12,4
audend

audstart	CREAKY,1,4
audi	7,06,1
audi	0,0,2
audi	7,07,1
audi	0,0,3
audi	7,08,1
audi	0,0,1
audi	7,09,1
audi	0,0,3
audi	7,10,1
audi	0,0,4
audi	7,11,1
audi	0,0,1
audi	7,12,1
audi	0,0,2
audi	7,13,1
audi	0,0,4
audi	7,14,1
audi	0,0,3
audi	7,15,1
audi	0,0,3
audi	7,16,1
audi	0,0,5
audi	7,17,1
audi	0,0,2
audi	7,18,1
audi	0,0,4
audi	7,19,1
audi	0,0,5
audi	7,20,1
audi	0,0,3
audi	7,21,1
audi	0,0,6
audi	7,22,1
audi	0,0,5
audi	7,23,1
audi	0,0,7
audi	7,24,1
audi	0,0,4
audi	7,25,1
audi	0,0,8
audi	7,26,1
audi	0,0,9
audi	7,27,1
audi	0,0,10
audi	7,28,1
audi	0,0,7
audi	7,29,1
audi	0,0,8
audi	7,30,1
audi	0,0,11
audi	7,31,1
audi	0,0,12
audi	7,31,1
audi	0,0,15
audi	7,31,1
audend

audstart	DRUM,1,7
audi	10,30,1
audi	6,30,1
audi	4,30,1
audi	2,30,1
audi	0,0,14

audi	10,30,1
audi	6,30,1
audi	4,30,1
audi	2,30,1
audi	0,0,14

audi	0,0,36

audi	10,30,1
audi	6,30,1
audi	4,30,1
audi	2,30,1
audi	0,0,14

audi	10,30,1
audi	6,30,1
audi	4,30,1
audi	2,30,1
audi	0,0,14

audi	0,0,36

audi	10,30,1
audi	6,30,1
audi	4,30,1
audi	2,30,1
audi	0,0,14

audi	10,30,1
audi	6,30,1
audi	4,30,1
audi	2,30,1
audi	0,0,14

audi	0,0,36

audi	10,30,1
audi	6,30,1
audi	4,30,1
audi	2,30,1
audi	0,0,14

audi	10,30,1
audi	6,30,1
audi	4,30,1
audi	2,30,1
audi	0,0,14

audi	0,0,36

audi	10,30,1
audi	6,30,1
audi	4,30,1
audi	2,30,1
audi	0,0,14

audi	10,30,1
audi	6,30,1
audi	4,30,1
audi	2,30,1
audi	0,0,14

audend

audstart	CUCKOO2,4,6
audi	2,23,1
audi	8,23,1
audi	14,23,2
audi	05,23,1
audi	0,0,2
audi	3,28,1
audi	7,28,1
audi	11,28,1
audi	14,28,3
audi	02,28,1
audend

endaud:
ENDAUD equ endaud
;
;	collision table
;
	.assert	(* <= COLTAB)
	.org	COLTAB
	.include	"COLTAB.S"
;
;	cave bat flying sequences
;
	.assert (* <= BATINIT)
;BATINIT:
	animini	1,3,5,60,100,-6,1,BAT1,.batseq,.batdseq,T_XY
.batseq:
	anima	BATCRY		;appearance
	animf	0,0,BAT1,15
	animf	0,0,BAT1+3,15
	animf	0,0,BAT1+6,15

.repeat:
	animf	1,-1,BAT2,5	;initial down
	animf	1,-1,BAT2+3,5
	animf	1,-1,BAT2+6,5
	animf	1,-1,BAT2+3,5

	anima	BATCRY
	animl	4
.loop1:
	animf	1,-2,BAT2,5	;long down
	animf	1,-2,BAT2+3,5
	animf	1,-2,BAT2+6,5
	animf	1,-2,BAT2+3,5
	animj	.loop1

	animl	4
.loop2:
	animf	1,1,BAT2,5	;short up
	animf	1,1,BAT2+3,5
	animf	1,1,BAT2+6,5
	animf	1,1,BAT2+3,5
	animj	.loop2

	anima	BATCRY
	animl	3
.loop3:
	animf	1,-1,BAT2,5	;short down
	animf	1,-1,BAT2+3,5
	animf	1,-1,BAT2+6,5
	animf	1,-1,BAT2+3,5
	animj	.loop3


	animl	3
.loop4:
	animf	1,1,BAT2,5	;short up
	animf	1,1,BAT2+3,5
	animf	1,1,BAT2+6,5
	animf	1,1,BAT2+3,5
	animj	.loop4

	anima	BATCRY
	animl	4
.loop5:
	animf	1,-1,BAT2,5	;short down
	animf	1,-1,BAT2+3,5
	animf	1,-1,BAT2+6,5
	animf	1,-1,BAT2+3,5
	animj	.loop5

	animl	3
.loop6:
	animf	1,-1,BAT2,5	;cruise
	animf	1,-1,BAT2+3,5
	animf	1,-1,BAT2+6,5
	animf	1,-1,BAT2+3,5
	animj	.loop6

	animl	4
.loop7:
	animf	1,2,BAT2,5	;long up
	animf	1,2,BAT2+3,5
	animf	1,2,BAT2+6,5
	animf	1,2,BAT2+3,5
	animj	.loop7

	animf	1,1,BAT2,5	;final up
	animf	1,1,BAT2+3,5
	animf	1,1,BAT2+6,5
	animf	1,1,BAT2+3,5

	animj	.repeat
.batdseq:
	anima	BATD
	animp	PTS1000
.loop8:	animf	0,-1,BAT1+6,1
	animj	.loop8
endbat:
ENDBAT	equ	endbat
;
;
;	light gun code
;
;	assert that preceeding code has not run into space reserved
;	for the light gun routine
;
	.assert (* <= DOGUN)
;
;	DUMMY LIGHT GUN SUBROUTINE
;	To be revised by ATARI into real function.
;
;	Inputs: none.
;	Output: zero flag clear if gun firing
;	It's OK to clobbers: A,X,Y regs
;	Global read: movsta+N_CURSOR
;	Globals modified: movx+N_CURSOR, movy+N_CURSOR
;	Bytes available for this function: 512
;	Temp variables may be added in file "\C\VARS.S"
;
;
;	set the address for the start of this routine
;
	.org DOGUN
;DOGUN:
	.if	0		;****  added by dave 5-Jul-88 ****
;
;	if S_STOPPED bit of movsta+N_CURSOR is set, gun has been fired on
;	previous call and is not done firing, so refuse to fire until
;	this bit is cleared. Like in the arcade game, holding down the trigger
;	should result in repeated firing. This bit controls the refiring rate.
;
	lda	movsta+N_CURSOR	;if cursor status
	and	#S_STOPPED	;STOP bit is high
	bne	.retfalse	;return false (fire sequence incomplete)
;
;	put the visible sight offscreen
;
	lda	#SCWP		;put cursor off-screen
	sta	movx+N_CURSOR
;
;	DUMMY CODE: fire every 256 clock cycles
;
	lda	clock		;every 256 cycles, fire gun (dummy code)
	beq	.rettrue
;
;	if reached here, return false (gun not fired)
;
.retfalse:
	lda	#FALSE
	rts
;
;	if reached here, gun fired
;
.rettrue:
;
;	set x and y position, subtract fudge factor of 5 to
;	center graphic of "splat"
;
;	DUMMY CODE
;
	lda	#SCHWP-5	;set x position (-5 is fudge factor)
	sta	movx+N_CURSOR
	lda	#SCHHL-5	;set y position (-5 is fudge factor) 
	sta	movy+N_CURSOR
	lda	#TRUE		;return TRUE
	rts
;
	.endif				;****  added by dave 5-Jul-88 ****
	.include	"gunxbow.s"	;****  added by dave 5-Jul-88 ****
endgun:
ENDGUN	equ	endgun
;
;	pal data for each of 11 screens
;
	.assert	(* <= SCPALTAB)
	.org	SCPALTAB

;SCPALTAB:
	.dc.w	mappal,cavpal,towpal,despal,junpal,caspal,volpal,bripal
	.dc.w	roopal,facpal,titpal
mappal:
	.dc.b	GREEN-1,0,0		;p2
	.dc.b	BLUE+1,0,0		;p3
	.dc.b	BLACK,BROWN,WHITE	;p4
	.dc.b	BLACK,BROWN,BLUE	;p5
	.dc.b	BLACK,BROWN,GREEN	;p6
	.dc.b	BLACK,BLACK,WHITE	;p7,score,site,prompts
	.dc.b	YELLOW-1,BLACK,BLACK	;bkgs
cavpal:
	.dc.b	0,0,0			;p2
	.dc.b	0,0,0			;p3
	.dc.b	BLUE+2,CYAN+2,BLUE+2	;p4 treasure
	.dc.b	YELLOW,GRAY,GREEN	;p5(bats)
	.dc.b	CYAN,WHITE,BLUE		;p6 bkg, ice
	.dc.b	BLACK,LTYELLOW,WHITE	;p7,score,site,prompts
	.dc.b	BLACK,BLACK,BLACK	;bkgs
towpal:
	.dc.b	YELLOW+1,BROWN+1,GREEN	;p2,win3/6,wolf,wiz,treas
	.dc.b	BLACK,YELLOW,BROWN	;p3,chimneys
	.dc.b	YELLOW,GRAY-2,GREEN	;p4,win2/3/5
	.dc.b	YELLOW,BLACK,BLUE	;p5,win1
	.dc.b	BLUE,$0C,GREEN		;p6,bkg
	.dc.b	BLACK,LTYELLOW,WHITE	;p7,score,site,prompts
	.dc.b	BLACK,BLUE-1,$0C	;bkgs
despal:
	.dc.b	RED,BLUE,CYAN		;p2 treasure
	.dc.b	YELLOW,BROWN,GREEN	;p3 bird, snake
	.dc.b	GREEN-8,GREEN-5,GREEN-8	;p4 cactus onlays
	.dc.b	SAND1,GREEN-5,SAND2	;p5 sand
	.dc.b	SAND1,BLUE,SAND2	;p6 mountains
	.dc.b	BLACK,BLACK,WHITE	;p7,score,site,prompts,ants
	.dc.b	CYAN,GREEN-8		;bkgs
junpal:
	.dc.b	CYAN,RED,WHITE		;p2 toucan
	.dc.b	BLACK,RED,WHITE		;p3 plant
	.dc.b	GREEN-8,GREEN-3,0	;p4 alt bkgd
	.dc.b	BLACK,BROWN+3,WHITE	;p5 chimp/coconut
	.dc.b	BROWN,GREEN-3,YELLOW	;p6 background
	.dc.b	BLACK,YELLOW,WHITE	;p7,score,site,prompts
	.dc.b	GREEN-8,BLACK,GREEN-3	;bkgs
caspal:
	.dc.b	YELLOW,BLUE,0		;p2 archer
	.dc.b	BROWN,WHITE,BLACK	;p3 arrows
	.dc.b	BLACK,WHITE,BROWN-1	;p4 mountains, door
	.dc.b	BLACK,BLUE,BROWN	;p5 moat
	.dc.b	BLACK,WHITE,GRAY	;p6 castle
	.dc.b	BLACK,YELLOW,WHITE	;p7,score,site,prompts,ptera
	.dc.b	CYAN,GRASS		;bkgs
volpal:
	.dc.b	ORANGE,BROWN,YELLOW	;p2 
	.dc.b	CYAN,WHITE,BLUE+5	;p3 diamond
	.dc.b	YELLOW+1,RED+1,0	;p4 firey rocks
	.dc.b	YELLOW+2,BROWN+2,GREEN	;p5 rocks, boulder
	.dc.b	BLACK+1,RED-1,YELLOW+1	;p6 background
	.dc.b	BLACK,YELLOW+4,WHITE	;p7,score,site,prompts
	.dc.b	GRAY,GRAY-2,0		;bkgs
bripal:
	.dc.b	YELLOW,ORANGE,GREEN	;p2 rock
	.dc.b	YELLOW,BROWN,GREEN	;p3 frog
	.dc.b	BLACK,RED+3,WHITE	;p4 bird,fish
	.dc.b	BLUE,BLUE+5,BLUE+10	;p5 rippling water
	.dc.b	RED,GREEN-3,BLACK	;p6 background
	.dc.b	BLACK,YELLOW,WHITE	;p7,score,site,prompts
	.dc.b	CYAN,BLUE,0		;bkgs
roopal:
	.dc.b	YELLOW,RED,GREEN	;p2 fireball,torch,chest,rdface,face1
	.dc.b	YELLOW,BLACK,GREEN	;p3 face2
	.dc.b	YELLOW,WHITE,GREEN	;p4 dagger,flash
	.dc.b	YELLOW,RED,GREEN	;p5 dragon
	.dc.b	BLACK+1,RED,CYAN-2	;p6 background,trap
	.dc.b	BLACK,LTYELLOW,WHITE	;p7,score,site,prompts
	.dc.b	CYAN-2,0,0		;bkgs
facpal:
	.dc.b	WHITE,BLACK+10,BLACK+5	;p2 skull
	.dc.b	YELLOW+1,RED,LTBLUE	;p3 rdeye
	.dc.b	YELLOW+1,WHITE,LTBLUE	;p4 wteye
	.dc.b	GRAY,GRAY,GRAY		;p5 floor
	.dc.b	YELLOW+4,RED-1,YELLOW-2	;p6 face
	.dc.b	BLACK,GREEN+2,WHITE	;p7,score,site,prompts
	.dc.b	BLACK,0,0		;bkgs
titpal:
	.dc.b	YELLOW,GREEN+2,RED+3	;p2
	.dc.b	GREEN,GREEN-4,GREEN-8	;p3 dragon
	.dc.b	6,3,0			;p4 bat (gray shades)
	.dc.b	BLACK,BLACK,BLACK	;p5 select gun/stick
	.dc.b	$88,$80,0		;p6 graphic
	.dc.b	BLACK,YELLOW,WHITE	;p7
	.dc.b	YELLOW,0,0		;bkgs
;
;	assert that this code does not overrun other data in this bank
;	
	.assert (* <= $5000)
.end
