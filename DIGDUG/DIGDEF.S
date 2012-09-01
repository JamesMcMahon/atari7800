*******************************************************************************

***********                    3600 DIG DUG                       *************

*******************************************************************************
*******************************************************************************


;        THE NECESSARY PROLOG FOR MARIA CODE

;*******************************************************************************
;  STELLA (TIA) REGISTER ADDRESSES
; NOTE THESE REGISTERS ARE SHADOWED AT 0100 TO 011F
;                                      0200 TO 021F
;                                      0300 TO 031F
;*******************************************************************************

VBLANK    EQU     $01
AUDC0     EQU     $15      ;BITS     3210 AUDIO CONTROL 0
AUDC1     EQU     $16      ;BITS     3210 AUDIO CONTROL 1
AUDF0     EQU     $17      ;BITS     3210 AUDIO FREQUENCY 0
AUDF1     EQU     $18      ;BITS     3210 AUDIO FREQUENCY 1
AUDV0     EQU     $19      ;BITS     3210 AUDIO VOLUME 0
AUDV1     EQU     $1A      ;BITS     3210 AUDIO VOLUME 1
INPT0     EQU     $38
INPT1     EQU     $39
INPT2     EQU     $3A
INPT3     EQU     $3B
INPT4     EQU     $0C   ;PLAYER 0 BUTTON CLEAR WHEN HIT
INPT5     EQU     $0D   ;PLAYER 1 BUTTON CLEAR WHEN HIT





;*******************************************************************************
; MARIA REGISTERS
; NOTE THESE REGISTERS ARE SHADOWED AT 0120 TO 013F
;                                      0220 TO 023F
;                                      0320 TO 033F
;*******************************************************************************
P0C0      EQU     $20                    ;BACKGROUND COLOR                  RW
;         ALL PALETTE AND COLOR ARE HIGH NIBBLE COLOR, LOW NIBBLE LUMINANCE
P0C1      EQU     $21                    ;PALETTE ZERO COLOR ONE            RW
P0C2      EQU     $22                    ;PALETTE ZERO COLOR TWO            RW
P0C3      EQU     $23                    ;PALETTE ZERO COLOR THREE          RW
WSYNC     EQU     $24                    ;FAST MARIA WSYNC STROBE
P1C1      EQU     $25                    ;PALETTE ONE COLOR ONE             RW
P1C2      EQU     $26                    ;PALETTE ONE COLOR TWO             RW
P1C3      EQU     $27                    ;PALETTE ONE COLOR THREE           RW
CTRLRD    EQU     $28                    ;BIT 7 IN VBLANK, BIT 6 IN DISPLAY RO
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
CHARBASE  EQU     $34                    :CHARACTER MODE HIGH POINTER       WO
P5C1      EQU     $35                    ;PALETTE FIVE COLOR ONE            RW
P5C2      EQU     $36                    ;PALETTE FIVE COLOR TWO            RW
P5C3      EQU     $37                    ;PALETTE FIVE COLOR THREE          RW
OFFSET    EQU     $38                    ;GRAPHICS HIGH POINTER OFFSET      RW
P6C1      EQU     $39                    ;PALETTE SIX COLOR ONE             RW
P6C2      EQU     $3A                    ;PALETTE SIX COLOR TWO             RW
P6C3      EQU     $3B                    ;PALETTE SIX COLOR THREE           RW
CTRL      EQU     $3C                    ;WRITE: (SEE BELOW FOR MORE INFO)
                                         ;   CK DM1 DM0 CWIDTH BCNTL KM RM1 RM0
P7C1      EQU     $3D                    ;PALETTE SEVEN COLOR ONE           RW
P7C2      EQU     $3E                    ;PALETTE SEVEN COLOR TWO           RW
P7C3      EQU     $3F                    ;PALETTE SEVEN COLOR THREE         RW

*CTRL REGISTER:   CK:      COLOR KILL
*                 DMn:     DMA MODE
*                 CWIDTH:  CHAR MAP WIDTH
*                 BCNTL:   BORDER CONTROL
*                 KM:      KANGAROO MODE
*                 RMn:     READ MODE

*         DM1     DM0      MEANING:
*         0       0        TEST A "EOVB"
*         0       1        TEST B "STARTSCAN"
*         1       0        RUN NORMALLY
*         1       1        INACTIVE


;*******************************************************************************
; ZERO PAGE RAM   0040 TO 007F
; NOTE THIS RAM IS SHADOWED AT 2040 TO 207F
;*******************************************************************************
          ORG       $0040

STMPYPOS  EQU     $40                    ;THESE ARE TOTLSTMP BYTES EACH: USED
STMPXPOS  EQU     $53                    ;  BY GENDPL TO GENERATE DISPLAY LIST.
STMPINDX  EQU     $66                    ;  ORDER OF STAMPS IS IN INCREASING
                                         ;  PRIORITY.
DDYPOS    EQU     $40                    ;DIGDUG.
DDXPOS    EQU     $53
DDINDX    EQU     $66

POOKAY    EQU     $41                    ;4 POOKAS.
POOKAX    EQU     $54
POOKAIX   EQU     $67

FYGARY    EQU     $45                    ;4 FYGARS.
FYGARX    EQU     $58
FYGARIX   EQU     $6B

ROCKSY    EQU     $49                    ;5 ROCKS POSSIBLE.
ROCKSX    EQU     $5C
ROCKSIX   EQU     $6F

FLAMEY    EQU     $4E                    ;1 FLAME AT A TIME.
FLAMEX    EQU     $61
FLAMEIX   EQU     $74

PUMPY     EQU     $4F                    ;SHARED BY PUMP AND HARPOON.
PUMPX     EQU     $62
PUMPIX    EQU     $75

FRUITY    EQU     $52                    ;FRUIT (ALIAS VEGGIES...).
FRUITX    EQU     $65
FRUITIX   EQU     $78

SNGPTR    EQU     $79
SNGPTR2   EQU     $7A

PUMPIE    EQU     $7B
FLAMSIZE  EQU     $7C
FLAMNUM   EQU     $7D

* FOLLOWING 11 REGISTERS ARE INIT IN INIT. THEY MUST REMAIN ADJACENT
CURSONG   EQU     $7E                    ;CURRENT SONG.
SNGTEMP1  EQU     $7F                    ;HIGHEST PRIORITY NOISE REQUEST
;*******************************************************************************
; ZERO PAGE RAM   0080 TO 00FF
; NOTE THIS RAM IS SHADOWED AT 2180 TO 21FF
;*******************************************************************************
          ORG       $0080
LASTMOVE  EQU     $80                    ;LAST DIGDUG MOVEMENT.
DLSTPTR   EQU     $81                    ;0,$40 FOR DLIST 0,1: USE VFLAG!
NUMPLAYR  EQU     $82                    ;NUMBER OF PLAYERS (0 => 1, 1 => 2).
DEATH     EQU     $83
DETHWISH  EQU     $84
ENTRY     EQU     $85                    ;DIGDUG WALKING ONTO SCREEN.
FRMCNT    EQU     $86
PLAYNUM   EQU     $87                    ;CURRENT PLAYER NUMBER.
BONZO     EQU     $88

PROPORT2  EQU     $89
PROPORT3  EQU     $8A

LISTSIZ   EQU     $8B                    ;# OF BYTES USED IN DLIST FOR EACH ZONE
                                         ;  (THROUGH $9A).



RACKNUM   EQU     $9B                    ;AND $9C:ACTUAL RACK # FOR EACH PLAYER.
* +1      EQU     $9C
MAXPUMP   EQU     $9D
NUMMEN    EQU     $9E                    ;AND $9F: NUMBER OF MEN LEFT.
* +1      EQU     $9F
ATTRACT   EQU     $A0
SYNCFRAM  EQU     $A1                    ;IT'S BACK!!!
SCOREL    EQU     $A2                    ;AND $A3: LOW BYTES OF SCORE FOR P0,P1.
SCOREM    EQU     $A4                    ;AND $A5: MIDDLE BYTES FOR EACH PLAYER.
SCOREH    EQU     $A6                    ;AND $A7: HIGH BYTES OF SCORE.
NONOISE   EQU     $A8
ASTAGE    EQU     $A9                    ;STAGE FOR ATTRACT MODE SAMPLE RACK.
AVAROBIN  EQU     $AA
RNDM      EQU     $AB                    ;FOR 2 BYTES
*         EQU     $AC
TITLETIM  EQU     $AD                    ;TIMER FOR TITLEPAG: GETS INCREMENTED
                                         ;  EVERY FRAME ALL THE TIME!
SELCTIM   EQU     $AE                    ;TIMER FOR SELECT: COUNTS NUMBER OF 4
                                         ;  SECOND INTERVALS IN KERNEL.
PROPORT   EQU     $AF
DIGSPEED  EQU     $B0
PUMPCT    EQU     $B1                    ;ANIMATION COUNTER.
MONSTAT   EQU     $B2                    ;THROUGH $B9.
DIR       EQU     $BA                    ;THROUGH $C1.
NOTUNNEL  EQU     $C2
*KEEP TUMBLE, FALLCNT, BRCREAT, BRTUNNL  NEXT TO EACH OTHER.
TUMBLE    EQU     $C3                    ;THROUGH $C7.
FALLCNT   EQU     $C8                    ;NUMBER OF ROCKS FALLEN THIS RACK
BRCREAT   EQU     $C9                    ;SAVE RCREATS FOR BONZO MODE.
BRTUNNL   EQU     $CA                    ;SAVE RTUNNELS FOR BONZO MODE.

HITROCK   EQU     $CB                    ;ROCK WHICH DIGDUG IS DIRECTLY UNDER.

TEMP      EQU     $CC                    ;THROUGH $DF.
TEMP1     EQU     $CC
TEMP2     EQU     $CD
TEMP3     EQU     $CE
TEMP4     EQU     $CF
TEMP5     EQU     $D0

***********
TEMP0     EQU     TEMP
TCOUNT    EQU     TEMP+2                 ;INITDIRT,INCREATS TEMPS.
PCOUNT    EQU     TEMP+3
FCOUNT    EQU     TEMP+4
RCREATS   EQU     TEMP+5
RTUNNELS  EQU     TEMP+6

TEMPX     EQU     TEMP+2                 ;INITROCK TEMPS.
REGROCK   EQU     TEMP+3
RANDROCK  EQU     TEMP+4

CURROCK   EQU     TEMP+2                 ;FALL TEMP
VICTIMX   EQU     TEMP+4                 ;FALL TEMP
VICTIMY   EQU     TEMP+5                 ;FALL TEMP
RTEMP     EQU     TEMP+6                 ;FALL TEMP
RTEMP2    EQU     TEMP+7                 ;FALL TEMP - MUST FOLLOW RTEMP
ROCKSNOW  EQU     TEMP+8                 ;FALL TEMP

GHOSTTMP  EQU     TEMP+12                ;MONSTER TEMP
MTEMP     EQU     TEMP+13                ;MONSTER TEMP

CURRBLW   EQU     TEMP+2                 ;BLOWUP TEMP
BLWTEMP   EQU     TEMP+3                 ;BLOWUP TEMP

;                                        ;DDMOVE TEMPS (+0,+1)
DRTPTR    EQU     TEMP+3                 ;DDMOVE: AND TEMP+4
DIGTEMP   EQU     TEMP+6                 ;DDMOVE
;                                        ;DDMOVE: TEMP+7,TEMP+9,TEMP+10

CHKTMP1   EQU     TEMP+11                ;CHKSTATE TEMPS
CHKTMP2   EQU     TEMP+12
CHKTMP3   EQU     TEMP+13
CHKTMP4   EQU     TEMP+14

DETHTEMP  EQU     TEMP+9                 ;DEATH TEMP: MUST NOT OVERLAP GENDPL
DEATHCNT  EQU     TEMP+10                ;(ACTUALLY FREEZFRM TEMP) OR CHKSTATE.
DTEMP2    EQU     TEMP+10

DPLOW2    EQU     TEMP+12                ;TITLEPAGE TEMPS (+0,+1,+15,+16) - 
DPHIGH2   EQU     TEMP+13                ;  MUST NOT OVERLAP FALL (2-8),
TSTAGE    EQU     TEMP+10                ;  CHKSTATE, LOADER (11-19), OR TCMOVE
TCTEMP    EQU     TEMP+2                 ;  TEMPS.

FAKEJOY   EQU     TEMP+5                 ;SELECT MODE TEMPS... (+0,1,12-16)

SCORTEMP  EQU     TEMP+19                ;ADDSCORE TEMP.

DIRTPTR   EQU     TEMP+14                ;INITDIRT TEMPS: THRU TEMP+19.

TEMPYPOS  EQU     TEMP+11                ;LOADER TEMP VARIABLES...
HEADER0   EQU     TEMP+12
HEADER1   EQU     TEMP+13
HEADER3   EQU     TEMP+14
DPLOW     EQU     TEMP+15
DPHIGH    EQU     TEMP+16
TEMPY     EQU     TEMP+17
LISTPTR   EQU     TEMP+18                ;AND TEMP+19.
***********

* FOLLOWING 20 REGISTERS MUST REMAIN ADJACENT. THEY ARE SET TO 0 IN INCREATS.
ANIMCNT   EQU     $E0                    ;ANIMATION CTR
DIGGING   EQU     $E1
PUMPNUM   EQU     $E2
SQUASH    EQU     $E3                    ;DIGDUG SQUASHING
NOTGRID   EQU     $E4
NEEDDIR   EQU     $E5
FSCORE    EQU     $E6
FSCORCTR  EQU     $E7
GHOSTIME  EQU     $E8
ESCAPER   EQU     $E9
PUMP      EQU     $EA
PUMPING   EQU     $EB
PUMPCNT   EQU     $EC
WALKING   EQU     $ED
FREEZE    EQU     $EE
FLAMIE    EQU     $EF
FLAMTIME  EQU     $F0
FRUIT     EQU     $F1
DIGREST   EQU     $F2
SCNDTIM   EQU     $F3



; THE FOLLOWING 7 REGISTERS MUST REMAIN IN THEIR CURRENT POSITION
CURINDX0  EQU     $F4
CURINDX1  EQU     $F5
REST0     EQU     $F6
REST1     EQU     $F7
DURCTR    EQU     $F8
TUNINDX0  EQU     $F9
TUNINDX1  EQU     $FA

ROCKSTAT  EQU     $FB                    ;FOR 5 BYTES
*         EQU     $FC
*         EQU     $FD
*         EQU     $FE
*         EQU     $FF


;*******************************************************************************
; FIRST PAGE RAM  0140 TO 017F
; NOTE THIS RAM IS SHADOWED AT 2140 TO 217F
;*******************************************************************************
          ORG       $0140





;*******************************************************************************
;  PIA AND TIMER (6532) LOCATIONS   0280 TO 02FF
; NOTE THESE REGISTERS ARE SHADOWED AT 0380 TO 03FF
;*******************************************************************************
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
;         BIT 3   BLACK AND WHITE/COLOR  COLOR WHEN SET
;         BIT 1   GAME SELECT  CLEAR WHEN PRESSED
;         BIT 0   GAME RESET   CLEAR WHEN PRESSED

CTLSWA    EQU     $281
CTLSWB    EQU     $283
INTIM     EQU     $284  ;INTERVAL TIMER IN
TIM8T     EQU     $295  ;TIMER 8T WRITE OUT
TIM64T    EQU     $296  ;TIMER 64T WRITE OUT
TIM64TI   EQU     $29E  ;INTERUPT TIMER 64T



;*******************************************************************************
; RAM     2000 TO 2FFF
; NOTE SOME OF THIS RAM IS SHADOWED ELSEWHERE
; 2040 TO 20FF IS SHADOWED AT 0040 TO 00FF
; 2140 TO 217F IS SHADOWED AT 0140 TO 017F
; 2240 TO 227F IS SHADOWED AT 0240 TO 027F
; 2340 TO 237F IS SHADOWED AT 0340 TO 037F
;*******************************************************************************
          ORG     $1800

;
;         DISPLAY LIST ZERO              NO PAGE BOUNDARIES CROSSED!
L0Z1      EQU     $1800
L0Z2      EQU     $183F
L0Z3      EQU     $187E
L0Z4      EQU     $18BD                  ;THRU $18FB.
L0Z5      EQU     $1900
L0Z6      EQU     $193F
L0Z7      EQU     $197E
L0Z8      EQU     $19BD
L0Z9      EQU     $1A00
L0Z9P5    EQU     5
L0Z10     EQU     $1A3F
L0Z11     EQU     $1A7E
L0Z12     EQU     $1ABD
L0Z12P5   EQU     $C2
L0Z13     EQU     $1B00
L0Z13P5   EQU     5                      ;LOW BYTE OF L0Z13 PLUS 5.
L0Z14     EQU     $1B3F
L0Z15     EQU     $1B7E
L0Z0      EQU     $1BBD                  ;THRU $1BFF: LONGER THEN OTHER LISTS.

;
;         DISPLAY LIST ONE
;
L1Z1      EQU     $1C00                  ;LOW BYTE OF L1 ZONES = LOW BYTE OF L0.
L1Z2      EQU     $1C3F
L1Z3      EQU     $1C7E
L1Z4      EQU     $1CBD
L1Z5      EQU     $1D00
L1Z6      EQU     $1D3F
L1Z7      EQU     $1D7E
L1Z8      EQU     $1DBD
L1Z9      EQU     $1E00
L1Z10     EQU     $1E3F
L1Z11     EQU     $1E7E
L1Z12     EQU     $1EBD
L1Z13     EQU     $1F00
L1Z14     EQU     $1F3F
L1Z15     EQU     $1F7E                  ;THRU $1FBC.

DLIJMP    EQU     $1FBD
DLIVECT   EQU     $1FBE                  ;AND $1FBF.
HSCOREX   EQU     $1FC0
HSCOREH   EQU     $1FC1
HSCOREM   EQU     $1FC2
HSCOREL   EQU     $1FC3
EFFRACK   EQU     $1FC4                  ;AND $1FC5
BACKMONS  EQU     $1FC6                  ;THROUGH $1FCD.
FRUITCST  EQU     $1FCE
FRUITPAL  EQU     $1FCF
*******   EQU     $1FD0

*KEEP BACKXPOS NEXT TO BACKYPOS, AND BACKTMBL,BACKHROK, BACKFCNT TOGETHER.
BACKYPOS  EQU     $2000                  ;STMPYPOS TEMP FOR OTHER PLAYER:THRU 12
BACKXPOS  EQU     $2013                  ;STMPXPOS TEMP: THROUGH 15.
BACKTMBL  EQU     $2026                  ;TUMBLE TEMP FOR OTHER PLAYER:THRU 2A.
BACKHROK  EQU     $202B                  ;HITROCK TEMP FOR OTHER PLAYER.
BACKFCNT  EQU     $202C                  ;FALLCNT TEMP.
BAKRCRET  EQU     $202D                  ;BRCREAT TEMP.
BAKRTUNL  EQU     $202E                  ;BRTUNNL TEMP.
STATUS    EQU     $202F                  ;USED IN MAIN.
MODEH     EQU     $2030
SPEEDL    EQU     $2038                  ;THRU $213F.

;*******************************************************************************
          ORG     $2040
; 2040 TO 20FF IS SHADOWED AT 0040 TO 00FF
;
;*******************************************************************************
          ORG     $2100

SPEEDH    EQU     $2100                  ;THRU $2107.
CDIREC    EQU     $2108                  ;FOR TITLE PAGE: CREATURE DIRECTION.
CBORDER   EQU     $2110                  ;TITLE PAGE: TURNING POINT. (THRU 17)
CHARSEQL  EQU     $2118
BLWYPOS   EQU     $2120
CHARSEQN  EQU     $2128
GHOST     EQU     $2130
FACING    EQU     $2138                  ;THRU $213F.


;*****************************************************.*************************
          ORG     $2140
; 2140 TO 21FF IS SHADOWED AT 0140 TO 01FF
;
;*******************************************************************************
          ORG     $2200

TUNNELS   EQU     $2200                  ;THRU $22C8.

YMODC     EQU     $22E8
MODEL     EQU     $22F0                  ;THRU $22F7.
PREBLWIX  EQU     $22F8                  ;THRU $22FF
RACKTIME  EQU     $2300
SPEEDUP   EQU     $2301
FLAMWAIT  EQU     $2302
GHOSTOUT  EQU     $2303
FLEE      EQU     $2304
FAST      EQU     $2305                  ;INIT TO 0 IN INCREATS
NXTSEC    EQU     $2306
P0C0SHAD  EQU     $2307                  ;SHADOW OF PALETTES: THROUGH $231F.
NUMSQSH   EQU     $2327                  ;THROUGH $232B
*******   EQU     $232C
*******   EQU     $232D
*******   EQU     $232E
DHORSPDL  EQU     $232F
DHORSPDH  EQU     $2330                  ;MUST FOLLOW DHORSPDL
***FREE   EQU     $2331
******    EQU     $2332                  ;THROUGH $2336
BLWSTAT   EQU     $2337                  ;THROUGH $233E
BLWCTR    EQU     $233F                  ;THROUGH $2346
BLWLSTMV  EQU     $2347                  ;THROUGH $234E

; FOR SOUNDS
******    EQU     $234F
; THE FOLLOWING 7 REGISTERS MUST REMAIN IN THEIR CURRENT POSITION
DURINDX0  EQU     $2350
DURINDX1  EQU     $2351
DEST0     EQU     $2352
DEST1     EQU     $2353
DDURCTR   EQU     $2354
DUNINDX0  EQU     $2355
DUNINDX1  EQU     $2356

SNGREQ    EQU     $2357                  ;THROUGH $235C.
DPL0LIST  EQU     $235D                  ;THRU $23A1.
DPL1LIST  EQU     $23A2                  ;THRU $23E6.
DUMMYDPL  EQU     $23E7                  ;AND $23E8.
DRT1COLR  EQU     $23E9                  ;KEEP DRTNCOLR'S TOGETHER.
DRT2COLR  EQU     $23EB
DRT3COLR  EQU     $23ED
VEGCOLR   EQU     $23EF                  ;AND $23F0
IGNORE    EQU     $23F1                  ;FOR IGNORING JOYSTICK.
SAVEFRMC  EQU     $23F2
P2INIT    EQU     $23F3

STMPPALW  EQU     $2400
PALWIDZ   EQU     $2480                  ;THROUGH $248F.
DIV3TAB   EQU     $2490                  ;THROUGH $24BF.
STMPRIOR  EQU     $24C0                  ;THROUGH $24D2.
MONPRIOR  EQU     $24C1                  ;(THESE ARE JUST EQUATES...)
RCKPRIOR  EQU     $24C9                  ;(  ""   "   ""     ""     )
PUMPRIOR  EQU     $24CF                  ;(  ""   "   ""     ""     )

DPL2LIST  EQU     $2500                  ;THROUGH $2544.

ROCKNUM   EQU     $2550                  ;THROUGH $2557, USED BY FALL

SCOREMAP  EQU     $25F0                  ;ONE SCORE MAP FOR EITHER PLAYER.

**** THE FOLLOWING RAM IS SHARED BY HSC:  IT IS RESTORED AFTER HSC RETURNS.
DIRTMAP   EQU     $2600                  ;CHAR MAP FOR CURRENT PLAYER, AND OTHER
                                         ;  PLAYER IF TWO PLAYER MODE.  EACH
BACKDIRT  EQU     $2700                  ;  CONTAINS CHAR INDICES FOR SKY AND
                                         ;  DIRT AND RUNS THROUGH $F0 INCLUSIVE.
HSCRAM    EQU     $2600
HSCDIFFL  EQU     $2602
*HSCDIFFN  EQU     $2606
HSCTIME   EQU     $260E


****      GENERAL IMMEDIATES
HSCATRCT  EQU     $3FFA
HSCENTER  EQU     $3FFD
LCARTNUM  EQU     $41
HCARTNUM  EQU     $42
STACK     EQU     $FF                    ;FOR NOW, GIVES 32 BYTES OF STACK.
DDSTRTX   EQU     96
DDSTRTY   EQU     191
DDMIDLX   EQU     56
DDMIDLY   EQU     107
XPOS      EQU     POOKAX
YPOS      EQU     POOKAY
MONSI     EQU     POOKAIX
NUMVEG    EQU     17
NUMZONES  EQU     15                     ;ZONES RUN FROM 0 (BOTTOM) TO 15 (TOP).
NUMCREAT  EQU     7                      ;NUMBER OF POOKAS + FYGARS - 1.
NUMROCK   EQU     4                      ;MAX NUMBER OF ROCKS-1
TOTLSTMP  EQU     18                     ;TOTAL NUMBER OF STAMPS POSSIBLE ON
                                         ;  SCREEN AT ANY ONE TIME - 1.
TOTLSTX2  EQU     TOTLSTMP+TOTLSTMP+1
CSET1     EQU     $E0                    ;CHARACTER SET 1: PAGES 40 - 4B.
CSET2     EQU     $C4
W1ZONE    EQU     $60
LISTLENG  EQU     61                     ;LENGTH OF DISPLAY LIST.
NORMSCRN  EQU     0                      ;VALUES FOR KERNTYPE: NORMAL DIRT SCRN.
BLNKSCRN  EQU     3                      ;BLANK SCREEN (BLACK).
MAXSRACK  EQU     19                     ;HIGHEST RACK PLAYER CAN CHOOSE.
MAXSR1    EQU     MAXSRACK-1
MAXEFFR   EQU     17
MINDDX    EQU     8                      ;MINIMUM DIGDUG X POSITION.
MAXDDX    EQU     113                    ;MAX DIGDUG X POSITION.
MINDDY    EQU     23
MAXDDY    EQU     192
ONEDGE    EQU     2                      ;TUMBLE STATE - ROCK READY TO FALL
SECOND    EQU     60                     ;60 FRAMES PER SECOND.
STRTWALK  EQU     9                      ;TITLEPAGE: AFTER 8 SECS, DD WALKS UP.
MAXCLIMB  EQU     167                    ;TITLEPAGE: HIGH POINT FOR DD CLIMB.
DROPROCK  EQU     64                     ;TITLEPAGE: HORIZ DD POS WHEN ROCK
                                         ;  WILL BEGIN TO FALL.

****      SOUND IMMEDIATES
SNGC      EQU     1                      ;CREATURE MOVEMENT
SNGD      EQU     2                      ;SLOW DIGDUG
SNGDF     EQU     3                      ;FAST DIGDUG
SNGNULL   EQU     4                      ;SOUND OF SILENCE
SNG1      EQU     5                      ;ROCK CRUSHING MONSTER
SNG2      EQU     6                      ;ROCK HITTING GROUND/DIGDUG
SNG3      EQU     7                      ;FLAME NOISE
SNG4      EQU     9                      ;PUMP CREATURE
SNG5      EQU     8                      ;DIGDUG THROWING HARPOON
SNG6      EQU     10                     ;POP
SNG7      EQU     11                     ;ROCK FALLING
SNG8      EQU     12                     ;GOTCHA
SNG9      EQU     13                     ;CREATURE ESCAPING
SNG10     EQU     14                     ;EAT VEGETABLE
SNG11     EQU     15                     ;BONUS MAN
SNG12     EQU     16                     ;SPEEDUP MUSIC
SNG13     EQU     17                     ;RACKEND
SNG14     EQU     18                     ;DIGDUG DEATH
SNG15     EQU     19                     ;ENTRANCE

****      CHARACTER INDEX IMMEDIATES
FULLDIRT  EQU     36                     ;CHARACTER INDEX FOR FILLED IN DIRT.
FULLSKY   EQU     30                     ;SKY CHARACTER (USES COLOR 10).
FULLSKY2  EQU     92                     ;SKY IN CSET2.
RSKYHALF  EQU     136
LSKYHALF  EQU     140
NODIRT    EQU     0                      ;EMPTY DIRT CHARACTER.
DTOPEND   EQU     $16                    ;TOP OF A VERTICAL TUNNEL.
DVMIDDLE  EQU     $14                    ;MIDDLE OF VERTICAL TUNNEL.
DBOTEND   EQU     $1C                    ;BOTTOM OF VERTICAL TUNNEL.
DLEFTEND  EQU     $1A                    ;LEFT END OF A HORIZONTAL TUNNEL.
DHMIDDLE  EQU     $A                     ;MIDDLE OF HORIZONTAL TUNNEL.
DRHTEND   EQU     $E                     ;RIGHT END OF HORIZONTAL TUNNEL.
BIGFLOWR  EQU     32
SMLFLOWR  EQU     34
TEDDY     EQU     50                     ;LEVEL INDICATORS: TEDDY AND VEGGIES.
*TEDPALW   EQU     $3E
VEGPALW   EQU     $BE
CARROT    EQU     52
RUTABAGA  EQU     54
MUSHROOM  EQU     56
CUCUMBER  EQU     58
EGGPLANT  EQU     60
BELLPEPP  EQU     62
TOMATO    EQU     64
ONION     EQU     66
WATERMEL  EQU     68
GALAXIAN  EQU     70
PINEAPPL  EQU     72
PINEPALW  EQU     $3E
BLANK1    EQU     0
BLANK2    EQU     222
BLANK3    EQU     137
BLANKR    EQU     74                     ;RIGHT EDGE OF DIRT.
BLANKL    EQU     76                     ;LEFT EDGE OF DIRT.
BLACKBOX  EQU     144
BIGSTAMP  EQU     224

****      STAMP INDEX IMMEDIATES: CSET2 STAMPS WHOSE INDEX IS <= 106
****              DON'T NEED ZERO PADDING.  ALL OTHER STAMPS DO.
FULL0     EQU     150                    ;FULL SIZE NUMBERS IN CSET2 (8 PIX).

*PUMP AND HARPOON...
DPUMP6    EQU     172
DPUMP12   EQU     173
DFULL6    EQU     174
DFULL12   EQU     175
UPUMP6    EQU     176
UPUMP12   EQU     177
UFULL6    EQU     104
UFULL12   EQU     105
ZBLANK    EQU     222
RPUMP24   EQU     48
RPUMP20   EQU     49
RPUMP16   EQU     50
RPUMP12   EQU     51
RPUMP8    EQU     52
RPUMP4    EQU     53
LPUMP24   EQU     46
LPUMP20   EQU     55
LPUMP16   EQU     60
LPUMP12   EQU     64
LPUMP8    EQU     67
LPUMP4    EQU     69
RHARPOON  EQU     16
LHARPOON  EQU     18
UHARPOON  EQU     120
DHARPOON  EQU     122

*DIGDUG...
UDIGDUG1  EQU     148
UDIGDUG2  EQU     150
UDIGDUG3  EQU     152
DDIGDUG1  EQU     154
DDIGDUG2  EQU     156
DDIGDUG3  EQU     158
RDIGDUG1  EQU     0
RDIGDUG2  EQU     2
RDIGDUG3  EQU     4
LDIGDUG1  EQU     6
LDIGDUG2  EQU     8
LDIGDUG3  EQU     10
SQDIGDUG  EQU     160
SDEATH    EQU     106                    ;(STAR).
HRDEATH1  EQU     108
HRDEATH2  EQU     110
HRDEATH3  EQU     112
HLDEATH1  EQU     114
HLDEATH2  EQU     116
HLDEATH3  EQU     118

*MONSTERS...
RPOOKA1   EQU     124
RPOOKA2   EQU     126
LPOOKA1   EQU     128
LPOOKA2   EQU     130
RBPOOKA1  EQU     224
RBPOOKA2  EQU     226
RBPOOKA3  EQU     228
RBPOOKA4  EQU     230
LBPOOKA1  EQU     232
LBPOOKA2  EQU     234
LBPOOKA3  EQU     236
LBPOOKA4  EQU     238
GPOOKA1   EQU     140
GPOOKA2   EQU     142
SQPOOKA   EQU     164
RFYGAR1   EQU     132
RFYGAR2   EQU     134
LFYGAR1   EQU     136
LFYGAR2   EQU     138
RBFYGAR1  EQU     240
RBFYGAR2  EQU     242
RBFYGAR3  EQU     244
RBFYGAR4  EQU     246
LBFYGAR1  EQU     248
LBFYGAR2  EQU     250
LBFYGAR3  EQU     252
LBFYGAR4  EQU     254
GFYGAR1   EQU     144
GFYGAR2   EQU     146
SQFYGAR   EQU     162
RFLAMFYG  EQU     12
LFLAMFYG  EQU     14

*FLAMES ...
RFLAME4   EQU     20
RFLAME8   EQU     22
RFLAME16  EQU     24
RFLAME24  EQU     28
LFLAME4   EQU     21
LFLAME8   EQU     34
LFLAME16  EQU     36
LFLAME24  EQU     40

*ROCKS...
STRTROCK  EQU     166
SPLTROCK  EQU     168
CRMBROCK  EQU     170
TOTRROCK  EQU     86

*SCORES   -   CSET1   (VEGETABLES)
VHUND4    EQU     98
VHUND6    EQU     101
VHUND8    EQU     187
VTHOUS1   EQU     218
VTHOUS2   EQU     70
VTHOUS3   EQU     74
VTHOUS4   EQU     194
VTHOUS5   EQU     78
VTHOUS6   EQU     198
VTHOUS7   EQU     82
VTHOUS8   EQU     202
VHUND2    EQU     178

*SCORES   -   CSET2   (BLOWUP AND SQUASHING)
LOWSCOR   EQU     178
HUNDRED2  EQU     178
HUNDRED3  EQU     181
HUNDRED4  EQU     98
HUNDRED5  EQU     184
HUNDRED8  EQU     187
THOUSND1  EQU     218
THOUS25   EQU     190
THOUS4    EQU     194
THOUS6    EQU     198
THOUS8    EQU     202
THOUS10   EQU     206
THOUS12   EQU     210
THOUS15   EQU     214
HIGHSCOR  EQU     218
HUNDRED6  EQU     101

*TITLEPAGE STAMPS
LETRL     EQU     90                     ;CSET2...
LETRE     EQU     92
LETRV     EQU     94
LETRP     EQU     96
LETRO     EQU     88
LETRS     EQU     78                     ;CSET1...
LETRA     EQU     80
LETRY     EQU     82
LETRG     EQU     84
LETRM     EQU     86
LETRR     EQU     142

*TITLE PAGE STAMPS...
ATARICP   EQU     88
NAMCOCP   EQU     94
TITLED10  EQU     100
TITLED9   EQU     104
TITLEG10  EQU     108
TITLEG9   EQU     112
TITLEU10  EQU     116
TITLEU9   EQU     120
TDDUG10   EQU     124
TDDUG9    EQU     128
TITLEI10  EQU     132
TITLEI9   EQU     134

****      COLORS
WHITE     EQU     $0E
RED       EQU     $37

PEBBLE1   EQU     $24
PEBBLE2   EQU     $14
PEBBLE0A  EQU     $24
PEBBLE0B  EQU     $14
PEBBLE0C  EQU     $17
PEBBLE0D  EQU     $26
PEBBLE1A  EQU     $52
PEBBLE1B  EQU     $42
PEBBLE1C  EQU     $24
PEBBLE1D  EQU     $10
PEBBLE2A  EQU     $52
PEBBLE2B  EQU     $42
PEBBLE2C  EQU     $00
PEBBLE2D  EQU     $52

YELLOW0   EQU     $1A
GOLD0     EQU     $27
ORANG0    EQU     $24
DKORANG0  EQU     $10
PALPURP1  EQU     $0A
PALBRWN1  EQU     $15
YELLOW1   EQU     $1E
GOLD1     EQU     $27
PALPURP2  EQU     $0A
PALBRWN2  EQU     $15
PALTURQ2  EQU     $B2
DKPURP2   EQU     $04

DKORANGE  EQU     $10
ORANGE    EQU     $24
GOLD      EQU     $27
YELLOW    EQU     $1A
GREEN     EQU     $C8
PALETURQ  EQU     $F8
SKYBLUE   EQU     $86
DDBLUE    EQU     $85
PALEPURP  EQU     $86
DARKPURP  EQU     $87
PALEBRWN  EQU     $25
TAN       EQU     $23
BROWN     EQU     $41
BLACK     EQU     $00
ANYCOLR   EQU     $00
PL0COLR   EQU     WHITE
PL1COLR   EQU     WHITE

********************************************************************************
********************************************************************************

          ORG     $FF80
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
          DB      0,0,0,0,0,0,0,0

          ORG     $FFF8
          DB      $FF                    ;COUNTRY CODE
          DB      $C7                    ;MARIA SIGNATURE AND START OF CODE
*                                        ;DLI VECTOR:  THIS LOCATION IS A
*                                        ;  JMP TO LOCATION IN RAM (DLIJMP).
          DB      L(GENEJMP),H(GENEJMP)  ;  JUMP ADDRESS IS CHANGED AS DMA
                                         ;  MOVES DOWN SCREEN.
          ORG     $FFFC
          DB      L(MAIN),H(MAIN)        ;INTERRUPT RESET VECTOR.
          DB      L(GENERTI),H(GENERTI)  ;JUST IN CASE....
