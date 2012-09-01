	.title	"Desert Falcon"
	.6502
	.list

****      ZERODEF.S   ZERO PAGE RAM MACRO *****
********************************************************************************
*                 ZERO PAGE RAM  40-7F                                         *
********************************************************************************

*         GAME STATE AND ASSOCIATED RAM

*         LEVEL 1 RAM

	org	$40
;
HANDLER:	.ds.b	1	;HAS A 40 (JMP OPCODE) TO JMP TO DLIPT
DLIPTR:		.ds.b	2	;AND E4
TITLMENU:	.ds.b	1	;FLAGS FOR STATES  ACTIVE LOW
AUTOPLAY:	.ds.b	1	;ACTIVE HIGH
USEME:		.ds.b	1	;FREE BYTE
DMA:		.ds.b	1	;ACTIVE HIGH
HSC:		.ds.b	1	;ACTIVE HIGH
GAMEU:		.ds.b	1	;ACTIVE HIGH
STATEPTR:	.ds.b	2	;STATEPTR FOR GAME STATE (i.e. PAUSE..
DIFCULTY:	.ds.b	1	;DIFFICULTY LEVEL
PAUSE:		.ds.b	1	;PAUSE STATE FLAG
NUMPLYRS:	.ds.b	1	;NUMBER OF PLAYERS
RNDOM:		.ds.b	1	;RANDOM NUMBER
RNDOM1:		.ds.b	1	;RANDOM NUMBER
FUTEXP1:	.ds.b	2	;NO ROOM FOR FUTURE EXPANSION

*         LEVEL 2 RAM

RACK:		.ds.b	2	;SPHINX LEVEL
FREEZEP:	.ds.b	1	;FREEZE FRAMER VARIABLE ACTIVE HIGH
PAWSTWID:	.ds.b	1	;PAUSE TWIDDLE FLAG
GAMEOVR:	.ds.b	1	;ACTIVE HIGH
NEWPLYR:	.ds.b	1	;SWITCHING BETWEEN PLAYERS FLAG
PLAYER:		.ds.b	1	;WHICH PLAYER IS UP 0 >> 1,  1>> 2
PL1SCORE:	.ds.b	4	;PLAYER 0'S SCORE
PL2SCORE:	.ds.b	4	;PLAYER 1'S SCORE
PL1LIVES:	.ds.b	1	;PLAYER 0'S LIVES
PL2LIVES:	.ds.b	1	;PLAYER 1'S LIVES
GRNDPC:		.ds.b	1	;GROUND OBJECTS PROGRAM COUNTER
OBJTYP:		.ds.b	1	;OBJECT TYPE OF PATTERN
DISTANCE:	.ds.b	1	;NUMBER OF COARSE SCROLLS
HDIST:		.ds.b	1	;HIGH BYTE OF DISTANCE
PGNUM:		.ds.b	2	;PLAYERS' NUMBER OF GLYPHS
PGPOWER:	.ds.b	2	;PLAYERS' CURRENT POWER
PGS1:		.ds.b	3	;PLAYER ONE'S HEIROS
PGS2:		.ds.b	3	;PLAYER TWO'S HEIROS
PSRA1:		.ds.b	1	;LAND PROGRAM RANDOMS
PSRA2:		.ds.b	1
PSRB1:		.ds.b	1
PSRB2:		.ds.b	1
DUMPAREA:	.ds.b	2	;QUEUE VAR FOR MCP
DIFIND:		.ds.b	1	;DIFICULTY LEVEL
EATME:		.ds.b	1	;AVAILABLE BYTE
TRVAL1:		.ds.b	2
TRVAL2:		.ds.b	2
XTRBNSTM:	.ds.b	2	;EXTRA BONUS TIME
FUTEXP3:	
FUTEXP2:	.ds.b	1	;NO MORE ROOM FOR EXPANSION


*         LEVEL 3 RAM
*         TEMPS AND POINTERS

	org	$80

PTR0:		.ds.b	2
PTR1:		.ds.b	2
TEMP0:		.ds.b	1
COLPX:				;X PASSED TO COLLISION DETECTION
TEMP1:		.ds.b	1
COLPY:				;Y PASSED TO COLLISION DETECTION
TEMP2:		.ds.b	1
COLPZ:				;Z PASSED TO COLLISION DETECTION
TEMP3:		.ds.b	1
TEMP4:		.ds.b	1
TEMP5:		.ds.b	1
TEMP6:		.ds.b	1	
TEMP7:		.ds.b	1	
TEMP8:		.ds.b	1	
TEMP9:		.ds.b	1	
TEMP10:		.ds.b	1	;JUST FOR PASSING DF
TEMPX:		.ds.b	1	
TEMPY:		.ds.b	1	


	org	$91

KTEMPX:		.ds.b	1	;TEMPX AND Y FOR INTERRUPT CODE
KTEMPY:		.ds.b	1	
KTEMP2:		.ds.b	1	
KTEMP3:		.ds.b	1	
KTEMP10:	.ds.b	1	;KERNEL TEMPORARY
KPTR0:		.ds.b	2	;POINTERS FOR INTERRUPT CODE
KPTR1:		.ds.b	2
KPTR:		.ds.b	2

JTEMP:		.ds.b	1	;WHAT THE FUCK

*         RANDOM BOB K. TEMPS  WHAT CAN WE DO WITH THEM

OTEMP1:		.ds.b	1	;BOBS TEMPS
OTEMP2:		.ds.b	1
OTEMP3:		.ds.b	1
OTEMP4:		.ds.b	1

*         RANDOM,BOGUS AND OTHERS

ZONEOFF:	.ds.b	1	;OFFSET INTO 16 HIGH ZONE (FF-F)
FRMCNT:		.ds.b	1	;FRAME COUNTER MOD 256
OLDFRM:		.ds.b	1	;LAST FRAME'S FRAME COUNT
SCRDELTA:	.ds.b	1	;DELTA VS NORMAL SCROLL
JERKOFF:	.ds.b	1	;COUNTER FOR COARSE H SCROLL
SCRATE:		.ds.b	1	;SCROLL RATE
LASTSCRL:	.ds.b	1	;COUNTER FROM 0 TO SCRATE
BIRDACNT:	.ds.b	1	;BIRD'S ANIMATION DELAY
BIRDXCNT:	.ds.b	1	;BIRD'S X MOTION DELAY
BIRDSTAT:	.ds.b	1	;BIRD'S STATUS (ANIMATION?)
BLOCK:		.ds.b	1	;CURRENT BLOCK BEING SCROLLED ON SCREE
BAND:		.ds.b	1	;CURRENT BAND IN BLOCK TO BE SCROLLED
FIRECNT:	.ds.b	1	;FIRE BUTTON DELAY
SHOTCNT:	.ds.b	1	;NUMBER OF SHOTS ON SCREEN (MAX IS 4)
BLKCNT:		.ds.b	1	;BLOCK COUNT

NBFLAG:		.ds.b	1	;FLAG THAT SAYS NEW BLOCK IS READY
NEWBLK:		.ds.b	1	;NEW BLOCK NUMBER

TENS:		.ds.b	1	;VALUES PASSED TO SCORE ROUTINE
HUNDS:		.ds.b	1	;COULD BE TEMPS ALSO I BELIEVE
HUNTHOUS:	.ds.b	1

ZNDLPOS:	.ds.b	24	;FIRST EMPTY BYTE IN EACH DISP. LIST
LOWEST:		.ds.b	1	;START OF RLTBL

MPTRL:				;ZERO PAGE TEMP(NOT GAMEPLAY)
KTEMP0:		.ds.b	1	;TEMPS FOR INTERRUPT CODE
MPTRH:				;ZERO PAGE TEMP(NOT GAMEPLAY)
KTEMP1:		.ds.b	1	;KTEMP0 AND 1 MUST BE PAST $C0

HIGHEST:	.ds.b	1	;OPPOSITE OF LOWEST.. END OF RLTBL
SCROLLS:	.ds.b	1	;NUMBER OF SCROLLS THIS FRAME

MAINCNT:	.ds.b	1	;MAIN LOOP COUNTER

*FLEA STATE
FLEASTAT:	.ds.b	16	;16 FLEA STATUS PRE/ON/OFF SCREEN
FLEANIM:	.ds.b	8	;8  FLEA ANIMATION STATE
NUMFLEAS:	.ds.b	1	;NUMBER OF FLEAS CURRENTLY AROUND
FLSYSCLK:	.ds.b	1	;FLEA SYSTEM CLOCK

BUFDEX:		.ds.b	1	;INDEX OF BUFFER WITH CHAR MAPS (0-11)

BACKCOL:	.ds.b	1	;BACKGROUND FOR PLAY AREA
D11CBASE:	.ds.b	1	;CHARBASE FOR BOTTOM ZONE OF SCREEN

DLZDEST:	.ds.b	2	;POINTER TO DESTINATION OF DLI AT


;	BEGINNING OF ZONE 11

DCH0:		.ds.b	1	;ONE BYTE--DURATION CNTR CHAN. 0
DCH1:		.ds.b	1	;ONE BYTE--DURATION CNTR CHAN. 1
TUNNUM:		.ds.b	1	;ONE BYTE--TUNE NUM FOR CHAN. 0
TUNNUM1:	.ds.b	1	;ONE BYTE--TUNE NUM FOR CHAN. 1
TINDEX0:	.ds.b	1	;ONE BYTE--NOTE POINTER 0
TINDEX1:	.ds.b	1	;ONE BYTE--NOTE POINTER 1
CINDEX0:	.ds.b	1	;CONTROL INDEX0
CINDEX1:	.ds.b	1	;CONTROL INDEX1
VINDEX0:	.ds.b	1	;VOLUME INDEX0
VINDEX1:	.ds.b	1	;VOLUME INDEX1
TUNTEMP:	.ds.b	1	;COULD BE A TEMP

RUNLOAD:			;TELLS LOADER TO RUN, SET BY MAINLOOP
ENDRAM0:	.ds.b	1	;MOVE ME AS NEEDED  YES SIR


*         OBJECT INDEX EQUATES

ZBIRD     EQU     0                      ;0                      BIRD
ZSHOT1    EQU     1                      ;1,2,3,4                SHOTS
FLEADEX   EQU     5                      ;5,6,7,8,9,10,11,12     FLEAS
UWEDEX    EQU     13                     ;13,14,15               UWES
PYRSTART  EQU     16                     ;16-58                  SCROLLING OBJS
PYRSTOP   EQU     58
SPHXSHOT  EQU     59                     ;59,60,61,62            SPHINX SHOTS
LASTPNT   EQU     63                     ;COMPARE VALUE FOR LAST COLLISIONS
FLSHDEX   EQU     63                     ;63 - 70                FLEA SHADOWS
ZSHAD     EQU     71                     ;71                     BIRD SHADOW
SHOTSHAD  EQU     72                     ;72,73,74,75            SHOT SHADOWS
SPXSHTSH  EQU     76                     ;76,77,78,79            SPHNX SHT SHDS
ZREF0     EQU     80                     ;80                     REFERENCE POINT
ZREF1     EQU     81                     ;81                     REFERENCE POINT
ZREF2     EQU     82                     ;82                     REFERENCE POINT
ZREF3     EQU     83                     ;83                     REFERENCE POINT


*         RANDOM EQUATES
SHOTDIFF  EQU     SHOTSHAD-ZSHOT1        ;DIFFERENCE BETWEEN SHOTS AND THEIR
                                         ;SHADOWS
NUMBER    EQU     126                    ;96 + Z OF LOWER LEFT CORNER OF SCREEN
DXADJ     EQU     -16                 ;ADJUST THE RANGE OF DX'S
LOWATER   EQU     72                     ;LOWEST WATER CHARACTER NUMBER
SCRENBOT  EQU     176

*         COLISION BOX ID'S
HIEROCOL  EQU     1                      ; 1 THRU 8  - HIEROGLYPHS
TREASCOL  EQU     9                      ; 9 THRU 11 - TREASURES
PASSVCOL  EQU     12                     ; ALL PASSIVE OBJECTS
MINICOL   EQU     13                     ; MINI SPHINX TARGET
SPHNXCOL  EQU     14                     ; BIG SPHINX TARGET
FLEACOL   EQU     15                     ; FLEAS
UWECOL    EQU     16                     ; UWES
SXSHTCOL  EQU     17                     ; SPHINX SHOTS
FIRECOL   EQU     18                     ; FIRE

                                         ;CAN BE ANYTHING ELSE BUT 0

***       SPHINX--SPROLOG.S


* TIA REGISTERS
INPT4R    EQU     $08                    ;PLAYER 0, RIGHT BUTTON (PADDLE INPUT)
INPT4L    EQU     $09                    ;PLAYER 0, LEFT BUTTON (PADDLE INPUT)
INPT5R    EQU     $0A                    ;PLAYER 1, RIGHT BUTTON (PADDLE INPUT)
INPT5L    EQU     $0B                    ;PLAYER 1, LEFT BUTTON (PADDLE INPUT)

INPT4     EQU     $0C                    ;PLAYER 0 FIRE BUTTON
INPT5     EQU     $0D                    ;PLAYER 1 FIRE BUTTON
AUDC0     EQU     $15      ;BITS     3210 AUDIO CONTROL 0
AUDC1     EQU     $16      ;BITS     3210 AUDIO CONTROL 1
AUDF0     EQU     $17      ;BITS     3210 AUDIO FREQUENCY 0
AUDF1     EQU     $18      ;BITS     3210 AUDIO FREQUENCY 1
AUDV0     EQU     $19      ;BITS     3210 AUDIO VOLUME 0
AUDV1     EQU     $1A      ;BITS     3210 AUDIO VOLUME 1


* MARIA REGISTERS
BACKGRND  EQU     $20                    ;BACKGROUND COLOR                  RW
P0C1      EQU     $21                    ;PALETTE ZERO COLOR ONE            RW
P0C2      EQU     $22                    ;PALETTE ZERO COLOR TWO            RW
P0C3      EQU     $23                    ;PALETTE ZERO COLOR THREE          RW
WSYNC     EQU     $24                    ;FAST MARIA WSYNC STROBE
P1C1      EQU     $25                    ;PALETTE ONE COLOR ONE             RW
P1C2      EQU     $26                    ;PALETTE ONE COLOR TWO             RW
P1C3      EQU     $27                    ;PALETTE ONE COLOR THREE           RW
MSTAT     EQU     $28                    ;BIT 6 IN VBLANK, BIT ? IN DISPLAY RO
P2C1      EQU     $29                    ;PALETTE TWO COLOR ONE             RW
P2C2      EQU     $2A                    ;PALETTE TWO COLOR TWO             RW
P2C3      EQU     $2B                    ;PALETTE TWO COLOR THREE           RW
DPPH      EQU     $2C                    ;DISPLAY LIST POINTER HIGH         WO
P3C1      EQU     $2D                    ;PALETTE THREE COLOR ONE           RW
P3C2      EQU     $2E                    ;PALETTE THREE COLOR TWO           RW
P3C3      EQU     $2F                    ;PALETTE THREE COLOR THREE         RW
DPPL      EQU     $30                    ;DISPLAY LIST POINTER LOW          WO
P4C1      EQU     $31                    ;PALETTE FOUR COLOR ONE            RW
P4C2      EQU     $32                    ;PALETTE FOUR COLOR TWO            RW
P4C3      EQU     $33                    ;PALETTE FOUR COLOR THREE          RW

CHARBASE	EQU	$34

P5C1      EQU     $35                    ;PALETTE FIVE COLOR ONE            RW
P5C2      EQU     $36                    ;PALETTE FIVE COLOR TWO            RW
P5C3      EQU     $37                    ;PALETTE FIVE COLOR THREE          RW
OFFSET    EQU     $38                    ;GRAPHICS HIGH POINTER OFFSET      RW
P6C1      EQU     $39                    ;PALETTE SIX COLOR ONE             RW
P6C2      EQU     $3A                    ;PALETTE SIX COLOR TWO             RW
P6C3      EQU     $3B                    ;PALETTE SIX COLOR THREE           RW
CTRL      EQU     $3C                    ;MAGIC                             WO
P7C1      EQU     $3D                    ;PALETTE SEVEN COLOR ONE           RW
P7C2      EQU     $3E                    ;PALETTE SEVEN COLOR TWO           RW
P7C3      EQU     $3F                    ;PALETTE SEVEN COLOR THREE         RW


* 6532  TIMERS AND PORTS
SWCHA     EQU     $280  ;PO, P1 JOYSTICKS
;         BIT 7 PLAYER 0 EAST IF CLEAR
;         BIT 6          WEST
;         BIT 5          SOUTH
;         BIT 4          NORTH
;         BIT 3 PLAYER 1 EAST IF CLEAR
;         BIT 2          WEST
;         BIT 1          SOUTH
;         BIT 0          NORTH

SWCHB     EQU     $282  ;CONSOLE SWITCHES
;         BIT 7   PLAYER 1 DIFFICULTY A IF SET B IF CLEAR
;         BIT 6   PLAYER 0 DIFFICULTY A IF SET B IF CLEAR
;         BIT 3   BLACK + WHITE/COLOR  COLOR WHEN SET
;         BIT 1   GAME SELECT  CLEAR WHEN PRESSED
;         BIT 0   GAME RESET   CLEAR WHEN PRESSED

CTLSWA    EQU     $281
CTLSWB    EQU     $283
INTIM     EQU     $284  ;INTERVAL TIMER IN
INTIMI    EQU     $28C  ;INTERRUPT INTERVAL TIMER IN
TIM8T     EQU     $295  ;TIMER 8T WRITE OUT
TIM64T    EQU     $296  ;TIMER 64T WRITE OUT
TIM64TI   EQU     $29E  ;INTERUPT TIMER 64T

*         HIGH SCORE EQUATES
HSCSTAT   EQU     $3FF7
HSCATRCT  EQU     $3FFA
HSCENTER  EQU     $3FFD
HSCSETRS  EQU     $3FEB
DFNMADAD  EQU     PTR0



; RAM equates:

	include	"SDEF.S"


; Code from $5000-$7FFF:

	include	"SHSC.S"
	include	"SMAGIC.S"
	include	"STUNES.S"
	include	"SMCP.S"
	include "PATCH.S"

; Code from $8000-$8FFF:

	include	"SGRAPH8.S"


; Code from $9000-$9FFF:

	include	"SINIT.S"
	include	"SKERNEL.S"
	include	"SOBJ.S"


; Code from $A000-$AFFF:

	include	"SGRAPHA.S"


; Code from $B000-$BFFF:

	include	"SGNDOBJ.S"


; Code from $C000-$CFFF:

	include	"SGRAPHC.S"


; Code from $D000-$DFFF:

	include	"SCOLON.S"
	include	"SSCROLL.S"


; Code from $E000-$EFFF:

	include	"SGAME.S"


; Code from $F000-$FFFF:

	include	"SNILE.S"
	include	"SSUBRS.S"
	include	"SSCROBJ.S"
	include	"SPHINX.S"


