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
          ORG     $D000
*******************************************************************************

***********                    3600 DIG DUG                       *************

*******************************************************************************
*******************************************************************************
MAIN
          SEI
          CLD
          LDA     #$17                   ;LOCK 3600 MODE.
          STA     $1
          LDX     #STACK
          TXS
          LDA     #$7F
          STA     CTRL
          LDA     #0                     ;UNFREEZE JOYSTICKS.
          STA     $1

          JSR     INIT                   ;INIT DISPLAY LIST, VARIABLES, ETC.

          JSR     WAITVBL                ;WE WANT TO SYNC OURSELVES WITH MARIA:
          LDA     #$50                   ;  WAIT FOR VBLANK.
          STA     CTRL                   ;ENABLE DMA.

PLAYTITL  JSR     TITLEPAG               ;START OFF IN TITLE PAGE.


PLAYGAME
          LDA     SYNCFRAM
          BPL     PLAYGAME

DOCODE
          LDA     FRMCNT
          STA     AVAROBIN
*         LDY     DOOMPTR+1
*         CPY     #$A0
*         BEQ     DOOMOVER
*         LDY     #0
*         STA     (DOOMPTR),Y
*         INC     DOOMPTR
*         BNE     DOCODE2
*         INC     DOOMPTR+1
*         BNE     DOCODE2
*DOOMOVER  NOP
DOCODE2   INC     RACKTIME
          JSR     CHKDEATH               ;CHKDEATH SHOULD PRECEDE CHKSTATE
          JSR     CHKSTATE
          JSR     CHKRACK

          LDA     DETHWISH
          BNE     DOFALL

          JSR     DDMOVE                 ;DDMOVE SHOULD PRECEDE COLLISON
;                                        ; DDMOVE SHOULD PRECEDE ALL GAMEPLAY
                                         ;DDMOVE SHOULD PRECEDE PUMPER
          JSR     EATVEG                 ;EATVEG SHOULD PRECEDE FRUITER
          JSR     MONSTERS               ;INCLUDES PUMPER,FRUITER,FLAMER,FLAMCOL
                                         ;PUMPER SHOULD PRECEDE COLLISONS+FALL
          JSR     COLLISON

*         LDA     DETHWISH               ; PROBABLY NOT NECESSARY ANYMORE
*         BNE     DOFALL

          JSR     BLOWUP
DOFALL    JSR     FALL

          JSR     GENDPL                 ;GENERATE NEW DISPLAY LIST.

          LDA     FRMCNT                 ;IF WE TOOK LONGER THAN ONE FRAME, GO
          CMP     AVAROBIN               ;  BACK TO PLAYGAME TO EXECUTE AGAIN IN
*         BEQ     WAIT1FRM
DOCODE4   BNE     PLAYGAME               ;  CASE THE FRAME WE SKIPPED SHOULD
                                         ;  HAVE BEEN EXECUTED.

WAIT1FRM  CMP     FRMCNT                 ;WE TOOK LESS THAN OR EQUAL TO ONE
          BEQ     WAIT1FRM               ;  FRAME TO EXECUTE DOCODE.  WAIT FOR
          BNE     PLAYGAME               ;  NEXT FRAME BEFORE CONTINUING.


*         AND     #$07                   ;DO STUFF 5 OUT OF 8 FRAMES
*         BEQ     DOCODE
*         CMP     #1
*         BEQ     DOCODE
*         CMP     #3
*         BEQ     DOCODE
*         CMP     #4
*         BEQ     DOCODE
*         CMP     #6
*         BNE     PLAYGAME

*         LDA     AVAROBIN
*WAITARC   CMP     FRMCNT
*         BEQ     WAITARC
*         BNE     PLAYGAME
********************************************************************************
***********                                                           **********
***********       INIT:  CALLED UPON POWER-UP, THIS INITIALIZES       **********
***********              THE DISPLAY LISTS, SKY IN DIRTMAP, AND       **********
***********              CALLS INITGAME TO INITIALIZE ATTRACT MODE.   **********
***********                                                           **********
********************************************************************************
*IGAMERAK
INIT
          LDA     #0
          STA     VBLANK
          STA     INTIM
          STA     HSCOREX
          STA     AVAROBIN
*         STA     ALIEN

          LDX     #CSET1
          STX     CHARBASE
          LDX     #$B5                   ;WILL NEED DIFF VALUE FOR PAL/SECAM
          STX     SYNCFRAM               ;WILL NEED DIFF VALUE FOR PAL/SECAM
          LDX     #$4C                   ;SET UP JUMP INSTRUCTION FOR DLI'S.
          STX     DLIJMP
          LDX     #L(DLISETUP)
          STX     DLIVECT
          LDX     #H(DLISETUP)
          STX     DLIVECT+1

          STA     $38                    ; A CONTAINS 0
          STA     DUMMYDPL+1

*         STA     CURSONG                ;THESE 11 REGISTERS ARE ZERO PAGE.
*         STA     SNGTEMP1               ;THEY MUST BE KEPT ADJACENT TO BE
*         STA     LASTMOVE               ;SERVED BY THE FOLLOWING LOOP.
*         STA     DLSTPTR
*         STA     NUMPLAYR
*         STA     DEATH
*         STA     DETHWISH
*         STA     ENTRY
*         STA     FRMCNT
*         STA     PLAYNUM
*         STA     BONZO

          LDX     #10
ZIVARS    STA     CURSONG,X             ;SEE DIGDEF FOR WHICH VARS ARE INIT'ED
          DEX
          BPL     ZIVARS

          LDX     #TOTLSTMP
ZEROSTMY  STA     STMPYPOS,X             ;NO STAMPS ON SCREEN INITIALLY.
          STA     STMPRIOR,X
          DEX
          BPL     ZEROSTMY

          LDA     #1
          STA     NONOISE
          LDX     #3
ZPRIOR1   STA     PUMPRIOR,X
          STA     RCKPRIOR,X
          DEX
          BPL     ZPRIOR1
          STA     RCKPRIOR+4

          LDY     #143                   ;SET UP STMPPALW ARRAY.
          LDX     #40
EXPANDA   LDA     NUMBYTES,X
          STA     TEMP
          LDA     PALWBYTE,X
EXPANDB   STA     STMPPALW,Y
          DEY
          DEC     TEMP
          BPL     EXPANDB
          DEX
          BPL     EXPANDA

          LDX     #47                    ;THIS LOOP LEAVES A=0,Y=FF,X=FF
          LDY     #15                    ;SET UP DIV3TAB IN RAM.
ZEXPAND0  LDA     #2
          STA     TEMP
          TYA
ZEXPAND1  STA     DIV3TAB,X
          DEX
          DEC     TEMP
          BPL     ZEXPAND1
          DEY
          BPL     ZEXPAND0

          TAY                            ;ASSUME A CONTAINS 0
          TAX                            ;ASSUME A CONTAINS 0
RACKTUNL  LDA     PTUNNELS,X
ZEROTUNL  PHA
          STA     TUNNELS,Y
          INY
          INX
          TYA
          AND     #7
          BEQ     TRAKDONE
          PLA
          BNE     RACKTUNL
          DEX
          BNE     ZEROTUNL
TRAKDONE  PLA
          CPY     #200
          BCC     RACKTUNL

          LDX     #0
          LDY     #17
SETDPLS   LDA     DLIBITS,Y
          STA     DPL0LIST,X
          STA     DPL1LIST,X
          STA     DPL2LIST,X
          INX
          LDA     LISTTBH0+1,Y
          STA     DPL0LIST,X
          LDA     LISTTBH1+1,Y
          STA     DPL1LIST,X
          LDA     #H(DUMMYDPL)
          STA     DPL2LIST,X
          INX
          LDA     LISTTABL+1,Y
          STA     DPL0LIST,X
          STA     DPL1LIST,X
          LDA     #L(DUMMYDPL)
          STA     DPL2LIST,X
          INX
          CPX     #69
          BEQ     ZDPLDONE
          DEY
          BPL     SETDPLS
          LDY     #20
          BNE     SETDPLS

ZDPLDONE  LDX     #14                    ;INIT CHARACTER MAP FOR SCORE LINE.
          LDA     #FULLSKY               ;SKY BEHIND NUMBERS AT TOP OF SCREEN.
ISCOREM   STA     SCOREMAP,X
          DEX
          BNE     ISCOREM


          JSR     IDIRTRAM               ;INITIALIZE DIRT RAM.
          JSR     ISCOREL

          JSR     SETRACK1
          TAX                            ;ATTRACT MODE.
          JSR     INITGAME

          JMP     SCRNON                 ;TURN DISPLAY BACK ON.
***       RTS


ICOLORS   LDX     #24                    ;INIT ORIGINAL PALETTE COLORS.
          LDY     #31
IPALS     LDA     IPALETTE,X             ;X INDEXES THROUGH PALETTE COLOR TABLE
          STA     P0C0SHAD,Y
          DEX
          BEQ     ENDIPAL
          DEY
          TYA
          AND     #3
          BNE     IPALS
          DEY
          BPL     IPALS
ENDIPAL   STX     P0C0                   ;BACKGROUND COLOR 0.
          STX     P0C0SHAD
          RTS
******************************************
IDLISTS   JSR     CHARDPL
          LDA     DLSTPTR
          PHA
          EOR     #$40
          STA     DLSTPTR
          JSR     CHARDPL
          PLA
          STA     DLSTPTR
          RTS
******************************************
CHARDPL
          LDX     #NUMZONES
INITBACK  JSR     SETDPLH                ;ADDRESS OF ZONE DISPLAY LIST.
          LDY     #0
          LDA     MAPLOW,X               ;LOW ADDRESS OF CHARACTER MAP.
          STA     (DPLOW),Y
          INY
          LDA     #W1ZONE
          STA     (DPLOW),Y
          STA     L0Z0+1
          INY
          LDA     #H(DIRTMAP)            ;INIT TO CURRENT PLAYER'S DIRT MAP.
          STA     (DPLOW),Y
          INY
          LDA     PALWIDZ,X              ;PALETTE/WIDTH FOR ZONE.
          STA     (DPLOW),Y
          INY
          LDA     #16                    ;HORIZONTAL POSITION.
          STA     (DPLOW),Y
          INY
          INY
          LDA     #0
          STA     (DPLOW),Y              ;ZERO OUT WIDTH OF NEXT HEADER IN ZONE.
          DEX
          BNE     INITBACK
          RTS
******************************************
IDIRTRAM
          LDA     #BLANK1
          LDX     #$F0
FILLBLNK  STA     DIRTMAP,X              ;ZERO OUT END OF DIRTMAP FOR SELECT,
          STA     BACKDIRT,X             ;  TITLE PAGE USE.
          INX
          BNE     FILLBLNK

          LDA     #LSKYHALF
          STA     SCOREMAP               ;HALF SKY.
          STA     DIRTMAP
          STA     BACKDIRT
          LDA     #RSKYHALF
          STA     SCOREMAP+15
          STA     DIRTMAP+15
          STA     BACKDIRT+15
          RTS
******************************************
SCRNOFF
          JSR     WAITVBL
          LDA     #L(DPL2LIST)           ;TURN DISPLAY OFF BY SETTING DPPL,DPPH
          STA     DPPL                   ;  TO POINT TO BLANK DISPLAY LIST.
          LDA     #H(DPL2LIST)
          STA     DPPH
          RTS
SCRNON
          JSR     WAITVBL
          LDX     #0                     ;TURN DISPLAY ON BY SETTING DPPL,DPPH
          BIT     DLSTPTR                ;  TO POINT TO CURRENT DISPLAY LIST.
          BVC     ZSCRNON
          INX
ZSCRNON   LDA     LDPPL,X
          STA     DPPL
          LDA     #H(DPL0LIST)
          STA     DPPH
          RTS

********************************************************************************
***********                                                          ***********
***********       INITGAME:  INITIALIZE DIGDUG GAME.                 ***********
***********                  INPUT:  X = 0 => REAL GAME.             ***********
***********                          X = 1 => ATTRACT GAME.          ***********
***********                                                          ***********
********************************************************************************
INITGAME
          STX     ATTRACT
          TXA
          EOR     #1                     ;IF ATTRACT MODE, DON'T GO THROUGH
          STA     ENTRY                  ;  ENTRY WALK.

          JSR     IDLISTS
          JSR     ICOLORS                ;RETURNS 0 IN X.

          TXA
***       LDA     #0                     ;START WITH PLAYER 0.
          STA     P2INIT
          STA     PLAYNUM
          STA     DEATH
          STA     DETHWISH
          STA     IGNORE
          LDX     #TOTLSTMP
ZISTAMPS  STA     STMPYPOS,X
          DEX
          BPL     ZISTAMPS
          LDA     ATTRACT
          BNE     ZNOPLAY0
          LDA     NUMPLAYR
          BEQ     ZNOPLAY0
          INX
          JSR     PLAYREDY

ZNOPLAY0  JSR     INITRACK               ;INITIALIZE APPROPRIATE RACK: THIS
                                         ;  INVOLVES FILLING IN DIRT, PUTTING
                                         ;  CREATURES IN TUNNELS, AND UPDATING
                                         ;  FLOWERS AT TOP OF SCREEN.


          LDX     ATTRACT                ;ATTRACT MODE?
          BNE     IATTRACT
          LDX     #5                     ;SET UP NUMBER OF MEN LEFT.
          STX     NUMMEN                 ;PLAYER 0'S MEN.
          LDA     NUMPLAYR
          BNE     ISCORE
          TAX
ISCORE    STX     NUMMEN+1               ;PLAYER 1'S MEN.
          JSR     ISCOREL                ;RETURNS 0 IN A.

***       LDA     #0                     ;SET UP SCORE:  IT TAKES MORE TIME TO
          TAY                            ;  CALL UPDSCORE, BUT LESS ROM.
          JSR     UPDSCORE
          LDA     NUMPLAYR
          BEQ     ZISETBZ
          INC     PLAYNUM                ;ALSO SET UP SCORE FOR PLAYER 2.
          LDA     #FULL0
          STA     L0Z0+49
          LDA     #0
          TAY
          JSR     UPDSCORE
          DEC     PLAYNUM
ZISETBZ   JMP     UPDMEN                 ;UPDMEN IS A SUBR

*IGAMEDON  RTS

IATTRACT  INX                            ;2 MEN IN ATTRACT MODE.
          STX     NUMMEN
          LDA     #0
          STA     ASTAGE
          STA     NUMMEN+1               ;NO MEN FOR PLAYER 1.
          RTS



********************************************************************************
***********                                                          ***********
***********       INITRACK:  CALLED WHEN INITIALIZING A GAME, OR     ***********
***********                  WHEN ALL CREATURES HAVE BEEN KILLED     ***********
***********                  OR HAVE ESCAPED, AND A NEW RACK IS      ***********
***********                  NEEDED.                                 ***********
***********                                                          ***********
********************************************************************************
INITRACK
          LDX     #7                     ;SET UP MONSTAT SO ALL POSSIBLE
          LDA     #0                     ;  CREATURES ARE INITIALIZED.
PUTALLC   STA     MONSTAT,X
          STA     FLAMEY-3,X             ;FRUITY,PUMPY,FLAMEY,ROCKYS REDUNDANT
          DEX
          BPL     PUTALLC
                                         ;DO TUNNELS AND CREATURES.
          STA     NOTUNNEL               ;ZERO PAGE
          STA     FALLCNT                ;ZERO PAGE
*         STA     FRUIT                  ;ABSOLUTE
          STA     RACKTIME               ;ABSOLUTE

          JSR     INITDIRT               ;FILL IN DIRT FOR NEW RACK.
          JSR     INITROCK               ;INITIALIZE ROCKS IN DIRT.

          LDA     ENTRY
          BNE     DOEWALK
          TAY
          JSR     DDMIDDLE               ;USES A ONLY
WELLOOP   LDA     #20
          STA     $2617,Y                ;DIG OUT VERTICAL TUNNEL.
          TYA
          CLC
          ADC     #$10
          TAY
          CPY     #$60
          BNE     WELLOOP

*         STX     $2617                  ;DIG OUT VERTICAL TUNNEL.
*         STX     $2627
*         STX     $2637
*         STX     $2647
*         STX     $2657
*         STX     $2667
          LDX     #8
          STX     $2677
          BNE     DOFLOWR
DOEWALK   LDA     #DDSTRTX               ;DIGDUG WILL MAKE ENTRANCE: SET HIM
          STA     DDXPOS                 ;  UP IN TOP RIGHT CORNER OF DIRT.
          LDA     #DDSTRTY
          STA     DDYPOS
          LDA     #LDIGDUG1
          STA     DDINDX

DOFLOWR   LDX     PLAYNUM
          LDA     RACKNUM,X
          LDY     #$E
          LDX     #0
          CMP     #10
          BCC     GOTBIG
*         SEC
GETBIG    INX
          SBC     #10
          CMP     #10
          BCS     GETBIG
GOTBIG    STA     TEMP                   ;TEMP CONTAINS NUMBER OF SMALL FLOWERS.
          TXA                            ;X CONTAINS NUMBER OF BIG FLOWERS.
          BEQ     GETSMALL               ;ANY BIG FLOWERS?
          LDA     #BIGFLOWR              ;STAMP INDEX FOR BIG FLOWER.
PUTBIG    STA     DIRTMAP,Y
          DEY
          BEQ     IRACKDON               ;SKY IS FULL OF FLOWERS ALREADY.
          DEX
          BNE     PUTBIG
GETSMALL  LDX     TEMP                   ;NUMBER OF SMALL FLOWERS.
          BEQ     IFILLSKY
          LDA     #SMLFLOWR              ;STAMP INDEX FOR SMALL FLOWER.
PUTSMALL  STA     DIRTMAP,Y
          DEY
          BEQ     IRACKDON
          DEX
          BNE     PUTSMALL

IFILLSKY
          LDA     #FULLSKY               ;FILL IN REST OF SKY WITH SKY CHAR.
ZFILLSKY  STA     DIRTMAP,Y
          DEY
          BNE     ZFILLSKY

IRACKDON  RTS

********************************************************************************
***********                                                           **********
***********       INITDIRT:  CALLED AT START OF EACH RACK TO          **********
***********                  INITIALIZE DIRT, TUNNELS, AND            **********
***********                  CREATURES FOR THE RACK.                  **********
********************************************************************************
INITDIRT
          LDA     NOTUNNEL
          BNE     JUSTCRET

          LDA     #FULLDIRT              ;FULL DIRT CHARACTER INDEX.
          LDX     #224                   ;FIRST, FILL IN ALL THE DIRT.
FILLDRT   STA     DIRTMAP+$F,X
          DEX
          BNE     FILLDRT

          LDX     #$76
          JSR     HCARVE

          LDX     #13                    ;FILL LEFT AND RIGHT EDGES OF DIRT WITH
BLACKEDG  LDY     MAPLOW,X               ;  BLANKS: THIS CREATES 14 COLUMNS OF
          LDA     #BLANKL
          STA     DIRTMAP,Y              ;  DIRT, 8 PIXELS WIDE EACH.
          STA     DIRTMAP+$10
          LDA     #BLANKR
          STA     DIRTMAP-1,Y
          DEX
          BNE     BLACKEDG
          STA     DIRTMAP+$EF

***       LDX     #0                     ;X IS ALREADY 0.
          TXA                            ;CALCULATE EFFECTIVE RACK NUMBER, GIVEN
          LDY     ATTRACT                ;  THAT RACKS 12-15 REPEAT.
          BNE     GOTERACK
          LDX     PLAYNUM
          LDY     RACKNUM,X              ;ACTUAL RACK NUMBER.
          BNE     RACKN                  ;  NUMBER WHEN WE'RE DONE.
          INY
          STY     RACKNUM,X
RACKN     DEY
          LDA     BONZO
          BEQ     NOBONZ
          TYA                            ;BONZO MODE: EFFRACK MAX AT 2+15.
          CLC
          ADC     #15
          BCS     WRAPBONZ
          CMP     #MAXEFFR               ;17
          BCC     GOTERACK
WRAPBONZ  LDA     #MAXEFFR
          BNE     GOTERACK
NOBONZ    TYA
          CPY     #15
          BCC     GOTERACK
          LDA     RACKNUM,X
          AND     #3                     ;CLOSEST MULTIPLE OF 4.
***       CLC
***       ADC     #11
          ADC     #10                    ;(CARRY SET).
GOTERACK  STA     EFFRACK,X

JUSTCRET  LDY     PLAYNUM
          LDX     EFFRACK,Y
          CPX     #MAXEFFR
          BCC     REGTUNL
          LDA     NOTUNNEL
          BEQ     ZNEWCRET
          LDX     BRCREAT
          LDA     RANDCRET,X
          STA     RCREATS
          LDA     BRTUNNL
          JMP     ZANYCRET
ZNEWCRET  LDA     FRMCNT
          AND     #7
          TAX
          LDA     RANDCRET,X
          STA     RCREATS
          STX     BRCREAT
          JSR     RANDOM
ZANYCRET  STA     RTUNNELS
          STA     BRTUNNL
          TXA
          CLC
          ADC     #17
          BNE     ZTUNNEL0
REGTUNL   LDY     CREATS,X               ;CREATURE BYTE: 0=> POOKA, 1=> FYGAR.
          STY     RCREATS
          LDY     TUNLDIR,X              ;TUNNEL DIRECTION: 0=> HORIZ, 1=> VERT.
          STY     RTUNNELS
          TXA
ZTUNNEL0  ASL     A                      ;MULTIPLY BY 8 FOR INDEX INTO TUNNELS.
          ASL     A
          ASL     A
          TAY
          LDA     #0                     ;INITIALIZE POINTERS INTO POOKA AND
          STA     PCOUNT                 ;  FYGAR ARRAYS.
          LDA     #4
          STA     FCOUNT
          LDX     #7                     ;POSSIBLE 8 TUNNELS PER RACK.
          STX     TCOUNT
ITUNNEL   LDX     TUNNELS,Y
          BNE     ZTUNNEL
          TXA
          PHA
          PHP
          BEQ     ZCREATS
ZTUNNEL   ASL     RTUNNELS               ;GET TUNNEL DIRECTION.
          LDA     NOTUNNEL               ;JUST INIT CREATURES?
          BNE     ICREATS
          BCS     VTUNNEL                ;(SET BY ASL).
          JSR     HCARVE
          BNE     ICREATS
VTUNNEL   LDA     #DTOPEND               ;***MARIA 1...
          STA     DIRTMAP,X              ;VERTICAL TUNNEL.
          LDA     #DVMIDDLE              ;***MARIA 1...
          STA     DIRTMAP+$10,X
          LDA     #DBOTEND               ;***MARIA 1...
          STA     DIRTMAP+$20,X
ICREATS
          TXA                            ;IF CARRY CLEAR, HORIZONTAL TUNNEL.
          JSR     GETRXY                 ;RETURNS X POS IN A, Y IN X.
          PHA
          PHP
          TXA
ZCREATS   ASL     RCREATS
          BCS     IFYGAR
          LDX     PCOUNT                 ;INDEX INTO POOKA ARRAY.
          INC     PCOUNT
          BNE     GOTCINDX
IFYGAR    LDX     FCOUNT
          INC     FCOUNT
GOTCINDX
          PLP
          PHP
          BCC     ZHTUNL
          SBC     CRYOFST,X              ;VERT TUNNEL - OFFSET CREATURE Y POS.
          BCS     ZHTUNL
          LDA     #0
ZHTUNL    STA     POOKAY,X
*         JSR     DOOM
          CMP     #0
          BNE     ZGOTCRET
          PLP
          PLA
          LDA     #$80
          STA     MONSTAT,X
          BMI     NOCREAT
ZGOTCRET
          PLP
          PLA
          BCS     ZVTUNL
          ADC     CRXOFST,X              ;HORIZ TUNNEL: OFFSET CREATURE X POS.
ZVTUNL    STA     POOKAX,X
          LDA     MONSTAT,X
          BMI     NOCREAT
          LDA     #0
          STA     MONSTAT,X
          BEQ     ZGOTC2
NOCREAT   LDA     #0
          STA     POOKAY,X
ZGOTC2    INY
          DEC     TCOUNT
          BPL     ITUNNEL

          LDY     PLAYNUM
          LDA     BONZO
          BEQ     REALVEG
          LDX     #NUMVEG+1
          BNE     GETVCOL
REALVEG   LDX     RACKNUM,Y
          BEQ     GETVCOL
          DEX
          CPX     #NUMVEG
          BCC     GETVCOL
          LDX     #NUMVEG
GETVCOL   LDA     VEGCOL2,X
          STA     VEGCOLR
          LDA     VEGCOL1,X
          STA     VEGCOLR+1
          LDA     VEGCOL3,X
          STA     P0C0SHAD+23
          LDA     #CSET1
          STA     FRUITCST
          LDA     #VEGPALW
          STA     FRUITPAL
          LDX     RACKNUM,Y
          BEQ     DORAK1
          DEX
          BNE     ADJ12
DORAK1
          LDA     NOTUNNEL
          BNE     ADJ12
          LDA     ATTRACT
          BNE     ZDORAK1
          LDA     BONZO
          BNE     ADJ12
ZDORAK1   LDA     #DHMIDDLE              ;RACK 1 IS ONLY RACK WITH TUNNELS
          STA     DIRTMAP+$2C            ;  TALLER OR WIDER THAN 3 DIRT BLOCKS.
          STA     DIRTMAP+$A5
          LDA     #DRHTEND
          STA     DIRTMAP+$2D
          STA     DIRTMAP+$A6
          LDA     #DVMIDDLE
          STA     DIRTMAP+$42
          STA     DIRTMAP+$52
          STA     DIRTMAP+$BA
          STA     DIRTMAP+$CA
          LDA     #DBOTEND
          STA     DIRTMAP+$62
          STA     DIRTMAP+$DA
ADJ12     TXA
          CMP     #12
          BCC     GOTDCOLR
ADJ12A    SBC     #12                    ;3 COLOR SCHEMES: EACH COLOR SCHEME
          CMP     #12
          BCS     ADJ12A                 ;  LASTS FOR FOUR RACKS.
GOTDCOLR  AND     #$C
          TAX
          LDA     DIRTCOLR,X             ;INITIALIZE PALETTES FOR THIS RACK.
          STA     P0C0SHAD+25
          LDA     PEBBCOLR,X
          STA     P0C0SHAD+27
          LDY     #0
ZTOPLOOP  LDA     DIRTCOLR+1,X
          STA     DRT1COLR,Y
          LDA     PEBBCOLR+1,X
          STA     DRT1COLR+1,Y
          INX
          INY
          INY
          CPY     #6
          BCC     ZTOPLOOP
*         LDA     DIRTCOLR+1,X           LDY #0
*         STA     DRT1COLR               LDA DIRTCOLR+1,X
*         LDA     PEBBCOLR+1,X           STA DRT1COLR,Y
*         STA     DRT1COLR+1             LDA PEBBCOLR+1,X
*         LDA     DIRTCOLR+2,X           STA DRT1COLR+1,Y
*         STA     DRT2COLR               INX
*         LDA     PEBBCOLR+2,X           INY  INY
*         STA     DRT2COLR+1             CPY #6
*         LDA     DIRTCOLR+3,X           BCC TOPLOOP
*         STA     DRT3COLR
*         LDA     PEBBCOLR+3,X
*         STA     DRT3COLR+1

********  RTS     OLD RTS FOR INITDIRT!!!!!!!!!!!!!!!!

********************************************************************************
***********                                                          ***********
***********       INCREATS:  INITIALIZE CREATURES IN TUNNELS.        ***********
***********                                                          ***********
***********    INCREATS : NOW A PART OF INITDIRT!!!!!

;-------- INITIALIZE RAM VARIABLES FOR MONSTER MOVEMENT ALGORITHMS
;-------- AND OTHER THINGS .....

          JSR     DOSTART                ;RETURNS 0 IN A

*         LDA     #0
          LDX     #8
ZPRIOR0   STA     STMPRIOR,X
          DEX
          BPL     ZPRIOR0

          LDX     #$07
EACHMONS  LDA     #$00
          STA     BLWSTAT,X
          STA     GHOST,X
          STA     YMODC,X
          LDA     #$08
          STA     FACING,X
          JSR     GHSTSUB1
*         JSR     GETDIRT
*         STY     TEMP3                  NECESSARY FOR CHKOTHER CODE
*         JSR     CHKOTHER
          LSR     A                      INDEX=CHAR
          STA     TEMP1
          LDA     #$04
          LSR     TEMP1
          BCC     NEXT115
          ASL     A                      ;ASSUME A CONTAINS 4
          LSR     TEMP1
          BCC     NEXT115
          LDA     #$01
          LSR     TEMP1
          BCC     NEXT115
          ASL     A                      ;ASSUME A CONTAINS 1
          LSR     TEMP1
          BCC     NEXT115
          LDA     #$00
NEXT115   STA     DIR,X                  SETUP FOR JSR NEWSEQ
          JSR     NEWSEQ
          JSR     SPEEDER
*         LDA     CHARSEQL,X             ;NOW DONE IN NEWSEQ - 1/18/84
*         STA     TEMP1
*         LDA     #H(RPOOKA)
*         STA     TEMP2
*         LDY     #$00
*         LDA     (TEMP1),Y
*         STA     POOKAIX,X
          DEX
          BPL     EACHMONS

          JMP     GETMODE                ;GETMODE IS A SUBR
;-------- END OF MONSTER MOVEMENT VAR. INITIALIZATION

*         RTS

DOSTART   LDA     FRMCNT                 ;CALLED FROM INCREATS AND DDMOVE
          CLC
          ADC     #60                    ; CHANGE FOR PAL/SECAM
          STA     NXTSEC                 ;  ...ALSO NEXT LINE

          LDX     #67                    ;1 MINUTE, 7 SECONDS
          LDA     BONZO
          BNE     BONZSPED
          LDY     PLAYNUM
          LDA     RACKNUM,Y
BONZSPED  CMP     #24
          BCC     SETFAST
          LDX     #2                     ;ABOUT TWO SECONDS
SETFAST   STX     SPEEDUP

          JSR     SETDFAST               ;SET DD SPEEDS

          JSR     INITALLS               ;SETS A TO 0, USES Y
          STA     CURSONG
          STA     SNGTEMP1
*         LDA     #$00
*         STA     ANIMCNT                ;THESE 20 REGISTERS MUST STAY ADJACENT
*         STA     DIGGING
*         STA     PUMPNUM
*         STA     SQUASH

*         STA     NOTGRID
*         STA     NEEDDIR
*         STA     FSCORE
*         STA     FSCORCTR
*         STA     GHOSTIME
*         STA     ESCAPER
*         STA     PUMP
*         STA     PUMPING
*         STA     PUMPCNT
*         STA     WALKING
*         STA     FREEZE
*         STA     FLAMIE
*         STA     FLAMTIME
*         STA     FRUIT
*         STA     DIGREST
*         STA     SCNDTIM

          LDX     #19
ZIFSCOR   STA     ANIMCNT,X
          DEX
          BPL     ZIFSCOR

          STX     PUMPIE                 ;EXPECTS X TO BE FF
          STA     FLEE                   ;EXPECTS A TO BE 0
          STA     FAST
          STA     LASTMOVE


          LDX     #$B5
          STX     PROPORT3
          STX     PROPORT2
          STX     PROPORT
          LDX     #4                     ;FORCE GHOSTING AFTER ABOUT 4 SECONDS
          STX     GHOSTOUT

          JMP     INITDIGS               ;SETS A TO 0, USES Y (INITDIGS IS SUBR)
*         RTS


********************************************************************************
***********                                                          ***********
***********       INITROCK:  INITIALIZE ROCKS IN DIRT.               ***********
***********                                                          ***********
********************************************************************************
INITROCK
          LDA     #0
          STA     REGROCK
          LDY     #$07
ZIROCK0   STA     TEMP+5,Y
          DEY
          BPL     ZIROCK0
          LDA     FRMCNT
          ROR     A
          STA     RANDROCK
          LDY     #4                     ;MAXIMUM OF 5 ROCKS.
          LDX     PLAYNUM
          LDA     EFFRACK,X
          CMP     #MAXEFFR
          BCC     ZIROCK
          INC     REGROCK                ;RANDOM ROCK RACK.
          BPL     DOROCKS
ZIROCK    ASL     A
          ASL     A
          CLC
          ADC     EFFRACK,X
          STA     TEMPX

DOROCKS   LDX     TEMPX
          LDA     REGROCK
          BEQ     TABLROCK

          JSR     RANDOM                 ;RANDOM ROCK RACK:  SHOULD WE PLACE A
          AND     #1                     ;  ROCK HERE?
          BEQ     ZTABROK0
ZGETROK   ROR     RANDROCK               ;YES: GET A RANDOM INDEX INTO POSSIBLE
          JSR     RANDOM                 ;  ROCKS FOR RANDOM RACKS.
          EOR     RANDROCK
          AND     #7
          TAX
          LDA     TEMP+5,X
          BNE     ZGETROK
          LDA     RANDROKS,X             ;GET ROCK POSITION.
          STA     TEMP+5,X
          BNE     ZROCK

TABLROCK  LDA     ROCKS,X                ;ROCK X,Y COMBINED POSITION.
          BNE     ZROCK

ZTABROK0  TAX                            ;NO ROCK HERE...
          BEQ     ZROCK1

ZROCK     JSR     GETRXY                 ;RETURNS X IN A, Y IN X.
          STA     ROCKSX,Y
ZROCK1    STX     ROCKSY,Y
          LDA     #STRTROCK
          STA     ROCKSIX,Y
          LDA     #0
          STA     TUMBLE,Y
          INC     TEMPX                  ;MOVE TO NEXT ENTRY IN ROCK TABLE.
          DEY                            ;MOVE TO NEXT POSSIBLE ROCK.
          BPL     DOROCKS
          RTS



*******************
*******************
*******************
*******************
*******************
RANDOM
          LDA     FRMCNT
          ADC     RNDM
          ADC     RNDM+1
          PHA
          LDA     RNDM
          STA     RNDM+1
          PLA
          STA     RNDM
          RTS

*DOOM      PHA
*         TYA
*         PHA
*         LDY     #15
*         LDA     GHOST,X
*         BNE     Z2
*         LDA     POOKAY,X
*         BEQ     Z2
*DOOMLOOP  CMP     TOPZONE,Y
*         BEQ     Z2
*         DEY
*         BPL     DOOMLOOP
*DOOMTRAP  NOP
*         NOP
*Z2        PLA
*         TAY
*         PLA
*DOOMRTS   RTS
PTUNNELS  DB      $2A,$A3
          DB      $22,$9A
          DB      0

          DB      $97,$BB,$3B,$62
          DB      $92
          DB      0

          DB      $2B,$52,$C9
          DB      $38,$96
          DB      0

          DB      $34,$A4,$C8
          DB      $38,$7C
          DB      0

          DB      $32,$93,$AB
          DB      $36,$2A,$6B
          DB      0

          DB      $34,$34,$8A,$92,$B6
*                 PP F F F
          DB      $53
*                 F
          DB      0

          DB      $3A,$3A,$93,$93,$B9
*                 FP  FP  F
          DB      $26,$26
*                 PP
          DB      0

          DB      $32,$4A,$AA,$C5
*                 F P F P
          DB      $36,$36,$83
*                 PP F
          DB      0

          DB      $59,$59,$96,$B2,$B2,$BB
*                 PP F FF F
          DB      $35,$5D
*                 P P

          DB      $48,$48,$A4,$BA
*                 PF F P
          DB      $2C,$2C,$54,$6A
*                 PP F F

          DB      $44,$44,$62,$62
*                 PF PP
          DB      $4A,$4A,$6D,$93
*                 PF F F

          DB      $43,$43,$58,$58,$AA,$AA,$B5    ;THESE REPEAT -- RACK 12
*                 PF PP FF F
          DB      $4D
*                 P

          DB      $3A,$3A,$A6,$A6,$CB,$CB
*                 PP FF FF
          DB      $6C,$54
*                 P P

          DB      $38,$38,$8A,$A4,$A4
*                 PP F FF
          DB      $34,$34,$4D
*                 PF P

          DB      $2B,$6A,$72,$72
*                 P P FF
          DB      $36,$36,$96,$98
*                 PP F F

          DB      $3B,$A2,0              ;BONZO LEVEL 0.
*                 F P
          DB      $23,$A7,0              ;BONZO LEVEL 1.
*                 P F

          DB      $6B,$42,$BA,0          ;RANDOM RACKS.
*                 F F P
          DB      $23,$93,$3A,0
*                 F F F
          DB      $6B,$42,$A7,0
*                 P F P
          DB      $B2,$BA,$23,$3A,0
*                 P P P P
          DB      $23,$BA,0
*                 F P
          DB      $B2,$A7,$BA,0
*                 P F F
          DB      $23,$3A,$A7,0
*                 P P F
          DB      $93,$6B,$42,$3A,0
*                 F P P F
*MOVED TO ARRAYS:
*TEDYPINE  DB      TEDDY,$BE,CSET1,76,0,0             ;(PALETTE 5).

ISCOREL   LDX     #58                    ;INIT DISPLAY LIST FOR SCORE LINE.
ISCOREL0  LDA     ISCORLIN,X
          STA     L0Z0,X
          DEX
          BPL     ISCOREL0
          LDX     #5
          LDA     #0
ISCOREL1  STA     SCOREL,X
          DEX
          BPL     ISCOREL1
          RTS                            ;RETURNS 0 IN A.


CRUNCH    STA     VICTIMY
          LDA     ROCKSX,X               ;ROCK HOR POS
          SEC
          SBC     VICTIMX
          BPL     CRUNCH2
          EOR     #$FF                   ; DOES NOT AFFECT CARRY
*         CLC                            ; MINUS MEANS CARRY CLEAR
          ADC     #1
CRUNCH2   CMP     #6                     ;REQUIRE OVERLAP OF 2
          BCS     CRUNCH5
          LDA     ROCKSY,X               ;LDA DOES NOT AFFECT CARRY
*         CLC
          ADC     #6
          SEC
          SBC     VICTIMY
          BCC     CRUNCH5
          CMP     #17
          BCS     CRUNCH5

          LDA     ROCKSY,X
*         SEC                            ; CARRY IS CLEAR HERE
          SBC     #$06-1                 ;MIGHT NEED TO TWEAK THIS
          STA     RTEMP
          CMP     #MINDDY                ;DON'T SQUASH OFF EDGE
          BCC     MINSQSHY
*         SEC
          SBC     VICTIMY
          BCC     NEWSQSHY
          CMP     #$04
          BCC     NEWSQSHY
          LDA     VICTIMY
          BNE     NOCADJST
NEWSQSHY  LDA     RTEMP
NOCADJST  SEC                            ;SQUASH
          RTS
CRUNCH5   CLC                            ;NO SQUASH
          RTS
MINSQSHY  LDA     #MINDDY
          SEC
          RTS

LOOKDIRT  LDA     DIRTMAP,Y
          CMP     #CHARD12
          BCS     ENDLOOK
          CMP     #CHARDF
          BCC     ZNXT120
          LDA     #$02                   ;SKY CHARACTER
*         LDA     #$01                   SKY CHARACTER
*         RTS
ZNXT120   LSR     A
          RTS
ENDLOOK   LDA     #$0F
          RTS

TITLCOLR  LDA     #RED
          STA     P0C0SHAD+26
          STA     P0C0SHAD+27
          LDA     #DDBLUE
          STA     P0C0SHAD,X
          LDA     #RED
          STA     P0C0SHAD+1,X
          LDA     #WHITE
          STA     P0C0SHAD+2,X
PINECOLR  LDA     VEGCOL1+17
          STA     VEGCOLR+1
          LDA     VEGCOL3+17
          STA     P0C0SHAD+23
          LDA     VEGCOL2+17
          STA     VEGCOLR
          RTS


SETTITLE
          JSR     BACKMAP
          LDX     #9                     ;ZONE 9.
          LDA     #163                   ;COPYRIGHT ATARI AND NAMCO.
          LDY     #14
          JSR     PUTTITLE
          LDX     #13                    ;ZONE 13.
          LDA     #29                    ;TOP OF DIGDUG LOGO.
          LDY     #34
          JSR     PUTTITLE
          LDX     #12                    ;ZONE 12.
          LDA     #153                   ;BOTTOM OF DIGDUG LOGO.
          LDY     #34
          JMP     PUTTITLE
***       RTS

***BONZDIFF  DB      29,29,29,29,29,29,29,29
***       DB      29,29,29,29,29,29,29,29
***       DB      29,29,29,29,29,29,29,29
***       DB      29,29


;-------- BUTTON INPUT ROUTINE           (FROM COLLISON FILE)


INPUT     LDX     #0
          LDY     PLAYNUM
*         BEQ     INPUTGO
*         LDA     ALIEN
*         BNE     INPUTGO
*         DEY
*INPUTGO
          LDA     INPT4,Y
          BMI     INOUT
          LDA     PUMPCNT
          BEQ     DOPUMP
          INC     PUMPCNT
          CMP     #$18                   TIME DELAY FOR PUMPING
          BEQ     DPUMPING
          BNE     INOUT2
*         LDA     #$00
*         BEQ     INOUT2
INOUT
*         LDA     #$00
*         STA     PUMPCNT
          STX     PUMPCNT
INOUT2
*         STA     PUMPING
*         STA     PUMP
          STX     PUMPING
          STX     PUMP
          RTS
DPUMPING
*         LDA     #$01
*         STA     PUMPING
*         STA     PUMPCNT
          INX
          STX     PUMPING
          STX     PUMPCNT
          RTS
DOPUMP
*         LDA     #$01
*         STA     PUMP
*         STA     PUMPCNT
          INX
          STX     PUMP
          STX     PUMPCNT
          LDY     PUMPIE
          INY
          BEQ     DOPEND
          LDA     PUMPCT
          BNE     DOPEND
          LDA     #$10
          STA     PUMPCT
DOPEND    RTS


TEDYPINE  DB      TEDDY,$BE,CSET1,72   ;  ,0,0             ;(PALETTE 5).
*****  FROM DDMOVE.S FILE
YFROMPL   DB      $00                         ;       ,$00,$00,$F4

YTOPL     DB      $00,$00,$F4,$00,$00,$00,$F4,$0C,$0C,$0C,$00,$11
          DB      $00,$00,$E8,$0C
          DB      $0C,$0C,$00,$17

DIRTCOLR  DB      YELLOW0,GOLD0,ORANG0,DKORANG0
          DB      PALPURP1,PALBRWN1,YELLOW1,GOLD1
          DB      PALPURP2,PALBRWN2,PALTURQ2,DKPURP2

GHSTSUB2  SEC                            ;USED BY GHOSTONX AND CHKOTHER
          SBC     #$10
          TAY
          LDA     DIRTMAP,Y
          CMP     #CHARD12
          RTS

SKYSUB    LDA     TEMP3                  ;USED BY SKY15 AND CHKDOWN
          CLC                            GET DIRT UNDER POSITION
          ADC     #$10
          TAY
          LDA     DIRTMAP,Y
          RTS

GHSTSUB1  JSR     GETDIRT                ;USED BY GHOSTONX AND MOVECONT
          STY     TEMP3                  ;   AND EACHMONS
          JMP     CHKOTHER               ;CHKOTHER IS A SUBR

SUB3      LDA     DDYPOS
          CLC
          ADC     #$01
          LSR     A
          LSR     A
          TAY
          LDA     DIV3TAB,Y
          STA     TEMP1
          CLC
          ADC     TEMP1
          ADC     TEMP1
          ASL     A
          ASL     A
          STA     TEMP1
          LDA     DDYPOS
          CLC
          ADC     #$01
          SEC
          SBC     TEMP1
          RTS

CVTDIR    DB      $02,$01,$04,$03
********************************************************************************
***********                                                          ***********
***********       DDMOVE:  CONTROLS ENTRY MODE IF DIGDUG IS          ***********
***********                JUST WALKING OUT ON SCREEN, AND           ***********
***********                HANDLES MOVING DIGDUG AND DIGGING         ***********
***********                TUNNELS OTHERWISE.  ALSO CHECKS FOR       ***********
***********                EXISTENCE OF ROCKS SO DIGDUG WON'T        ***********
***********                RUN INTO THEM, AND SETS FALLING ROCK      ***********
***********                FLAG WHEN DIRT UNDER A ROCK GOES AWAY.    ***********
***********                                                          ***********
********************************************************************************


DHFASTL   EQU     $D5                    ;DD HOR SPEED FAST LOW BYTE
DHFASTH   EQU     $AA                    ;DD HOR SPEED FAST HIGH BYTE
DHSLOWL   EQU     $52                    ;DD HOR SPEED SLOW LOW BYTE
DHSLOWH   EQU     $52                    ;DD HOR SPEED SLOW HIGH BYTE

DIGSLOW   EQU     $5B                    DIGDUG SLOW    5 BITS
;         FOR 16 BIT VERSION      DIGSLOW = $5B $5B     10 BITS
DIGFAST   EQU     $F7                    DUGDUG FAST    7 BITS
;         FOR 16 BIT VERSION      DIGFAST = $7F $7F     14 BITS



DDMOVE
          LDA     #H(SOUTH7)             ;ASSUME ALL ARRAYS ON SAME PAGE.
          STA     DRTPTR+1

          LDA     DIGGING
          STA     DIGTEMP

          LDA     ATTRACT
          BEQ     CHKENTR

          LDA     SQUASH
          BNE     NOGO

          LDX     LASTMOVE
          LDA     DIGREST                ;DIGDUG MOVING?
          BNE     ATNEWDIR
          LDA     ASTAGE                 ;STILL WALKING IN SAME DIRECTION?
          BEQ     ATNEWDIR
          DEC     ASTAGE
          LDA     JOYSWCH,X              ; E,W,S,N   -    7F,BF,DF,EF
          BNE     GPREZJOY               ; CONTINUE IN OLD DIR
ATNEWDIR  JSR     RANDOM
          AND     #$03
          ADC     #$00
          STA     ASTAGE                 ;NEW COUNTDOWN
DOATDIR   AND     #$03
          TAY
          LDA     JOYSWCH,Y
          CMP     REVSWCH,X
          BNE     GPREZJOY
          INY                            ;TRY NOT TO REVERSE
          TYA
          BPL     DOATDIR

*         LDY     ASTAGE                 ;WE'RE IN ATTRACT MODE: USE ATTRACT
*         LDA     ATTDIREC,Y             ;  MODE TABLE MOVEMENTS INSTEAD OF
*         BPL     AHORIZ                 ;  READING JOYSTICK.
*         ASL     A
*         BPL     AHORIZ
*         LDA     DDYPOS                 ;UP OR DOWN: CHECK Y POSITION.
*         BNE     CHKBOUND
*AHORIZ    LDA     DDXPOS                 ;LEFT OR RIGHT: CHECK X POSITION.
*CHKBOUND  CMP     ATTBOUND,Y
*         BNE     GOTDIREC
***B      CPY     #15                    ;DIGDUG NOT DEAD YET: RECYCLE DIREC'S.
***B      BCC     NEWDIREC
***B      LDY     #3
*NEWDIREC  INY                            ;TURN TO NEW DIRECTION.
*         STY     ASTAGE
*GOTDIREC                                 ;EVENTUALLY, PUMP CHECK WILL GO HERE.
*         LDA     ATTDIREC,Y
*         BNE     GPREZJOY

CHKENTR   LDA     ENTRY                  ;ARE WE IN ENTRY MODE?
          BEQ     JOYMOVE

          LDA     DDXPOS
          CMP     #DDSTRTX
          BNE     NOENTRY
          LDY     #0
          STY     NONOISE
          LDY     #SNG15
          JSR     NOISE

NOENTRY   LDA     DDYPOS                 ;HAS DIGDUG STARTED DOWN YET?
          CMP     #DDSTRTY
          BNE     DOWNDD
          LDA     #$BF                   ;MOVE DIGDUG LEFT.
          LDX     DDXPOS
          CPX     #DDMIDLX               ;ARE WE FAR ENOUGH LEFT YET?
GPREZJOY  BNE     PREZJOY

DOWNDD    CMP     #DDMIDLY               ;ALL THE WAY DOWN?
          BNE     WDOWN
          LDA     #RDIGDUG2
          STA     DDINDX
          LDA     #40
          JSR     GENFREEZ
          LDA     #0
          STA     ENTRY
*         STA     LASTMOVE               ;FAKE LAST DIRECTION
*         STA     NOTGRID
*         LDA     #$B5
*         STA     PROPORT
*         JMP     SETDFAST
*         RTS
          JMP     DOSTART                ;DOSTART IS A SUBR
WDOWN     LDA     #$DF
          BNE     PREZJOY

****MOVEDONE  RTS

*FOO       DB      $7F,$DF,$BF,$EF,$7F    ; E,S,W,N,E  (IN ARRAYS.S)
*BAR       DB      $20,$40,$10,$90        ; S,W,N,NE

NOGO      LDA     WALKING
          BEQ     NOGO2
          DEC     WALKING                ;DIGDUG CAN'T OR WON'T MOVE
NOGO2     RTS

JOYMOVE
*         LDA     WALKING
*         STA     DTEMP1                 ;SAVE FOR LATER...
          LDA     SQUASH
          ORA     FREEZE
          BNE     NOGO
          LDA     SWCHA                  ;READ JOYSTICK...

          LDX     PLAYNUM
          BEQ     JOYMOVE0

*         LDX     ALIEN                  ;IF THERE IS ONLY ONE JOYSTICK,
*         BEQ     JOYMOVE0               ; USE PLAYER 0 INPUT FOR PLAYER 1.

          ASL     A                      ;FETCH SECOND USER'S INPUT
          ASL     A
          ASL     A
          ASL     A

JOYMOVE0  ORA     #$0F
          CMP     #$FF
          BEQ     JOYMOVE1
          LDX     #$0A                   ;TWEAKABLE; <8 STOPS DD SONG REVERSING
          STX     WALKING

          LDX     #6
          TAY
FOOLOOP   AND     BAR-1,X
          BEQ     FOODONE
          TYA
          DEX
          BNE     FOOLOOP
FOODONE   LDA     FOO,X

;*        AND     #$10                   ; N?
;*        BEQ     FOODONE
;*        DEX
;*        TYA
;*        AND     #$40                   ; W?
;*        BEQ     FOODONE
;*        DEX
;*        TYA
;*        AND     #$20                   ; S?
;*        BEQ     FOODONE
;*        DEX                            ; MUST BE EAST
*FOODONE   LDA     FOO,X

;;;       STA     TEMP+10                ;JOYSTICK REQUEST
;;;       LDX     LASTMOVE
;;;       LDA     JOYSWCH,X
;;;       EOR     #$FF                   ;RESULT IS BIT SET WHERE DD LAST MOVED
;;;       BIT     TEMP+10
;;;       BNE     NEWDIR                 ;OLDDIR AMONG DIRS REQUESTED?

;;;       ORA     TEMP+10                ; !!!!! USE NEWDIR
;;;       CMP     #$FF                   ; !!!!! USE NEWDIR

*         LDA     JOYSWCH,X              ; !!!!! USE OLDDIR

;;;       BNE     JOYMOVE1
;;;NEWDIR    LDY     #3
;;;SWCHLOOP  LDA     TEMP+10                ;JOYSTICK REQUEST
;;;       CMP     JOYSWCH,Y
;;;       BEQ     JOYMOVE1               ;IF ONE BIT IS LOW, USE IT
;;;       DEY
;;;       BPL     SWCHLOOP
;;;       ORA     AREVSWCH,X             ;IF TWO BITS ARE LOW, MOVE 90 DEGREES

*         LDA     REVSWCH,X              ;IF TWO BITS ARE LOW, MOVE IN REVERSE

JOYMOVE1

PREZJOY   INC     DIGREST                ;GETS CLEARED IF DD TRIES TO MOVE
ZJOY      LDX     LASTMOVE
          LDY     #0
          ASL     A
          BCC     GOMDDE
ZJOY0     INY
          ASL     A
GOMDDE    BCC     MDDE
ZJOY1     INY
          ASL     A
          BCC     MDDN
          INY
          ASL     A
          BCS     NOGO
MDDN
          LDA     DDXPOS                 ;COLUMN BORDER?
          AND     #$07
          BEQ     COLBORDN
          LDA     JOYSWCH,X              ;TRY PREVIOUS DIRECTION
          BNE     ZJOY

COLBORDN  LDA     JOYSWCH,X
          ASL     DIGSPEED               ;TIME TO MOVE?
          BCS     NTIME
          CMP     REVSWCH,Y              ;ALWAYS MOVE IF REVERSING
          BNE     NOTREST
          BEQ     NREV
*         CMP     JOYSWCH,Y              ;ALWAYS MOVE IF DIFF DIRECTION
*         BEQ     NOTREST
NTIME     INC     DIGSPEED
NREV      STY     LASTMOVE
          CMP     JOYSWCH,Y              ;TUNNEL SPEED AND NO HARPOON
          BEQ     STILLN                 ; IF CHANGING DIRECTION
          LDA     #0
          STA     DIGTEMP
          BEQ     DOANIMN
STILLN    ASL     PROPORT3               ;TIME TO DO VERT ANIMATION?
          BCC     RUBN
          INC     PROPORT3
DOANIMN   JSR     ANIM                   ;UPDATE STAMP INDEX

RUBN      JSR     CHKROCK                ;AGAINST ROCK?
          BMI     RUBN3
          CPY     #2                     ;MOVING SOUTH?
          BNE     RUBN2
          LDA     TUMBLE,X
          CMP     #7                     ;DD CAN MOVE SOUTH THROUGH CRUMBLE
          BCS     RUBN3
RUBN2     LDA     #0
          STA     DIGTEMP
          JMP     FINMOV1

RUBN3     LDX     DDYPOS

          TYA
          LSR     A
          BCC     DIGS                   ;DIG SOUTH
          INX
          CPX     TOPZONE+15             ;AT UPPERMOST LIMIT?
          BCC     NOTTOP
          LDA     DANIMS+0               ;FACE RIGHT
          STA     DDINDX
          LDA     #191
          STA     DDYPOS
          LDY     #0                     ;FAKE LAST DIRECTION
          STY     LASTMOVE
          RTS

DIGS      CPX     #23
          BEQ     RUBN2
          DEX

NOTTOP    STX     DDYPOS                 ;STORE NEW VERT VALUE
          TXA                            ;NEW VERT VALUE
          SEC
GETNOFST  SBC     #12
          CMP     #12
          BCS     GETNOFST

          JMP     FINVERT


MDDE
          JSR     ROWHERE                ;ROW BORDER?
          BEQ     ROWBORDE
          LDX     LASTMOVE
          LDA     JOYSWCH,X              ;TRY PREVIOUS DIRECTION
          JMP     ZJOY

NOTREST   LDA     #0
          STA     DIGREST
GLVDIRTN  RTS

ROWBORDE  LDX     LASTMOVE
          LDA     JOYSWCH,X
          ASL     DHORSPDL               ;ALRIGHT TO MOVE HORIZONTALLY?
          ROL     DHORSPDH
          BCS     ETIME
          CMP     REVSWCH,Y              ;ALWAYS MOVE IF REVERSING
          BNE     NOTREST
          BEQ     EREV
*         CMP     JOYSWCH,Y              ;ALWAYS MOVE IF DIFF DIRECTION
*         BEQ     NOTREST
ETIME     INC     DHORSPDL
EREV      STY     LASTMOVE
          CMP     JOYSWCH,Y              ;TUNNEL SPEED AND NO HARPOON
          BEQ     STILLE                 ; IF CHANGING DIRECTION
          LDA     #0
          STA     DIGTEMP
STILLE    JSR     ANIM                   ;UPDATE STAMP INDEX

          JSR     CHKROCK                ;AGAINST ROCK?
          BPL     RUBN2

          LDX     DDXPOS

          TYA
          LSR     A
          BCS     DIGW                   ;DIG WEST

          CPX     #112
          BEQ     RUBN2
          INX
          BNE     NOTSID

DIGW      CPX     #8
          BEQ     RUBN2
          DEX

NOTSID    STX     DDXPOS                 ;STORE NEW HOR VALUE
          TXA
          AND     #$F8
          STA     TEMP
          LDA     DDXPOS
          SEC
          SBC     TEMP

FINVERT   LDX     #1
          STX     NOTGRID
          JSR     DIGDISP
          JMP     FINMOV


DIGDISP   CMP     VPRE1,Y
          BEQ     VANHARP
          CMP     VPRE2,Y
          BEQ     VANHARP
          CMP     VPRE3,Y
          BNE     DIGONE
VANHARP   LDA     #12
          JMP     CHKNXTD                ;CHKNXTD IS A SUBR

DIGONE    CMP     VONE,Y
          BNE     GETN1                  ; 1 IN

          LDA     FROMXFM,Y
          STA     DRTPTR
          LDA     DDYPOS                 ;FROM
          CLC
          ADC     YFROMPL,Y
          TAX
          LDA     DDXPOS
          CLC
          ADC     XFROMPL,Y

          JSR     CALCINDX
          CMP     #36
          BCS     DIGONE2
          JSR     BORE1                  ;FOUND IN FALL FILE
DIGONE2                                  ;TO
          LDA     #0
          STA     DIGTEMP
          LDY     LASTMOVE
          LDA     ENTRXFM,Y
          STA     DRTPTR
          JSR     ADJUSTTO
          JSR     CALCINDX
          CMP     #36
          BCS     DIGONE3
          PHA
          LDA     TOXFM,Y
          STA     DRTPTR
          PLA
          JMP     BORE1                  ;FOUND IN FALL FILE  (BORE1 IS A SUBR)
DIGONE3
          JMP     DIGGER                 ;DIGGER IS A SUBR

GETN1     CMP     VHALF,Y
          BNE     GETN2                  ; 1 PAST HALFWAY IN

DIGHALF
          LDA     #0
          STA     DIGTEMP
          LDA     HALFXFM,Y
          STA     DRTPTR
          JSR     ADJUSTTO               ;TAKE LEADING EDGE
          JSR     CALCINDX               ;CALC DIRCHAR
          CMP     #36
          BCC     GETN3
          JMP     DIGGER                 ;DIGGER IS A SUBR

GETN2     CMP     VBOUND,Y
          BNE     GETN3

DIGBOUND  JSR     ROWHERE
          BNE     DIGBND2
          LDA     DDXPOS
          AND     #7
          BNE     DIGBND2
          LDA     #4
          JSR     CHKNXTD
          BCS     DIGBND2
          STA     NOTGRID                ;WHEN CARRY CLR, CHKNXTD SET A TO BE 0
DIGBND2
GETN3     RTS

BETTY     LDA     LASTMOVE
          ORA     #$0C
          TAY
          JSR     CHKROCK                ;DIGDUG ONE PIXEL INTO SQUARE
          BMI     FINMOV1                ;   UNDER ROCK?
          LDA     TUMBLE,X               ;ROCK NOT ALREADY FALLING?
          BNE     FINMOV1
          STX     TEMP+10                ;SAVE ROCK INDEX
          JSR     ROCKPUSH               ;SQUARE UNDER ROCK HAS HOLLOW CENTER?
          LDX     TEMP+10                ;RESTORE ROCK INDEX
          CMP     #36
          BCS     FINMOV1
          BCC     CHKFALL1               ;ROCK SHOULD FALL WHEN DD REVERSES

FINMOV                                   ;DO THIS STUFF ONLY IF DIGDUG MOVES

          LDA     #0
          STA     DIGREST
          LDY     NEEDDIR                ; DIGDUG HOLDING UP ROCK?
          BEQ     CHKFALL
          BMI     STRTFALL               ; FF MEANS ANY MOVE WILL CAUSE FALL
          DEY                            ; TRUE DIRECTION NEEDED
          CPY     LASTMOVE               ; WILL CURRENT DIR CAUSE FALL?
          BNE     CHKFALL
STRTFALL  LDX     HITROCK
          LDA     #ONEDGE
          STA     TUMBLE,X
          LDA     #0
          STA     NEEDDIR

CHKFALL   LDA     LASTMOVE
          ORA     #$04
          TAY
          JSR     CHKROCK
          BPL     CHKFALL1
          LDY     #3
          JSR     CHKROCK                ;UNDER ROCK?
          BMI     BETTY
          LDA     #$FF
          BMI     CHKFALL2
CHKFALL1  LDY     LASTMOVE
          LDA     CVTDIR,Y
CHKFALL2  LDY     TUMBLE,X               ;IGNORE ROCK ALREADY FALLING
          BNE     FINMOV1
          STA     NEEDDIR
          STX     HITROCK


FINMOV1   LDY     LASTMOVE               ;DO THIS IF DIGTEMP CHANGED
          LDA     DIGTEMP
          CMP     DIGGING                ;CHANGE IN SPEED REQUESTED?
          BEQ     FINMOV4
          STA     DIGGING
          TAX
          BEQ     FINMOV2
          LDX     #DHSLOWL
          STX     DHORSPDL
          LDX     #DHSLOWH
          STX     DHORSPDH
          LDX     #DIGSLOW
          STX     DIGSPEED
FINMOV4   TAX
          BEQ     FINMOV3
          JMP     HARP                   ;HARP IS A SUBR
FINMOV2   JSR     SETDFAST
FINMOV3   JSR     VANPUMP                ;RETURNS  0 IN A
FINMOV5   STA     PUMPY
LEAVDIRT  RTS

HARP      LDY     LASTMOVE
          LDA     HARPSTMP,Y
          STA     PUMPIX
          LDA     DDXPOS
          CLC
          ADC     HARPXPL,Y
          STA     PUMPX
          LDA     DDYPOS
          CLC
          ADC     HARPYPL,Y
          CMP     #MINDDY
          BCC     FINMOV3
          BCS     FINMOV5

;  USES X AND A.
;  IF WAY CLEAR, RETURNS MINUS.
;  IF WAY BLOCKED, RETURNS PLUS AND ROCK INDEX IN X.
CHKROCK   LDA     DDXPOS                 ;ADJUST FOR DIRECTION
          CLC
          ADC     XTOPL+4,Y
          STA     TEMP+7
          LDA     DDYPOS
          CLC
          ADC     YTOPL+4,Y
          STA     TEMP+1
          LDX     #4

ROCKER    LDA     TEMP+7                 ;HOR COORDINATES MATCH?
          CMP     ROCKSX,X
          BNE     NROCKY

          LDA     ROCKSIX,X              ;IGNORE ROCK AS SCORE
          CMP     #LOWSCOR
          BCS     NROCKY

          LDA     TEMP+1                 ;VERT COORDINATES MATCH?
          CMP     ROCKSY,X
          BEQ     BLOCKED
;
;  LET'S RECONSIDER....
;
          LDA     TUMBLE,X               ;FALLING?
          BEQ     NROCKY
          LDA     LASTMOVE               ;DIGDUG MOVING HORIZONTALLY?
          AND     #$02
          BNE     NROCKY
          LDA     ROCKSY,X               ;ROCK OVERLAPS DIGDUG VERTICALLY?
          CLC
*         ADC     #6                     ;TWEAK??
          ADC     #7
*         SEC
          SBC     TEMP+1
          BCC     NROCKY
          CMP     #17
          BCS     NROCKY
          LDA     DDYPOS
          CMP     #23                    ;DIGDUG ON BOTTOM ROW?
          BEQ     BLOCKED
          STX     TEMP+9                 ;SAVE X
          LDA     DDYPOS
          SEC
          SBC     #12
          TAX                            ;WHAT KIND OF DIRT CHAR IS BELOW ROCK?
          LDA     TEMP+7
          JSR     CALCINDX
          LDX     TEMP+9                 ;RESTORE X
          CMP     #36                    ;SOLID
          BEQ     BLOCKED
          CMP     #44                    ;CUP
          BNE     NROCKY
BLOCKED   LDA     #$00                   ;ROCK FOUND
          RTS
NROCKY    DEX
          BPL     ROCKER
ENDEAT    RTS

EATVEG    LDA     FSCORE                 ;FRUIT SCORE PRESENT?
          BEQ     EATVEG1
          DEC     FSCORCTR
          BNE     ENDEAT
          LDA     #0
          STA     FSCORE
          STA     FRUITY                 ;STOP DISPLAYING SCORE
EATVEG1   LDA     FRUIT                  ;FRUIT PRESENT?
          CMP     #$0F
          BCC     ENDEAT
          LDA     DDYPOS                 ;DIGDUG ON TOP OF FRUIT?
          CMP     #$6B
          BNE     ENDEAT
          LDA     DDXPOS
          CMP     #$38
          BNE     ENDEAT
          LDX     #$01                   ;POINTS DISPLAYING FLAG
          STX     FSCORE
          DEX
          STX     FRUIT                  ;FRUIT DONE
          LDA     #$30                   ;SET SCORE DISPLAY TIMER
          STA     FSCORCTR
          LDA     BONZO                  ;BONZO?
          BNE     EATVEG2                ;ASSUME X IS 0
          LDY     PLAYNUM
          LDX     RACKNUM,Y              ;CALC CORRECT POINT VALUE
          CPX     #19
          BCC     EATVEG2
          LDX     #18                    ;RACKS ABOVE 18 ARE ALL PINEAPPLES
EATVEG2   LDA     FPOINTS,X              ;DISPLAY POINTS
          STA     FRUITIX
          LSR     A
          TAY
          LDA     STMPPALW,Y
          STA     FRUITPAL
          LDY     VEGPTS,X               ;FETCH MID BYTE
          LDA     #53
          STA     FRUITX
          LDA     #0                     ;LOW BYTE ALWAYS 0
          JSR     ADDSCORE
          LDA     #CSET2
          STA     FRUITCST
          LDY     #SNG10                 ;GOT FRUIT
          JMP     NOISE                  ;NOISE IS A SUBR



********************************************************************************
***********
***********       SELECT:  DRIVER FOR SELECT MODE.  WHEN SELECT MODE ENTERED,
***********                CONTROL STAYS IN THIS ROUTINE UNTIL RESET OR THE
***********                BUTTON ON THE JOYSTICK IS PRESSED.
***********                MOVING THE JOYSTICK UP SETS NUMPLAYR TO 2, DOWN TO 1;
***********                LEFT DECREASES THE STARTING LEVEL, RIGHT INCREASES IT
***********                (NO WRAP AROUND).
***********
********************************************************************************
SELECT
          JSR     SETRACK1               ;START OFF WITH LOWEST RACK (RETURNS 1
          STA     NONOISE                ;  IN A).
          LDA     #$40
          STA     DLSTPTR
          JSR     SCRNOFF

          JSR     SETTITLE
          LDX     #6
          JSR     SETDPLH
          LDY     #38                    ;PLAYERS.
          LDX     #89
          JSR     PUTMPLAT
          LDX     #9
          JSR     SETDPLH
          LDY     #30
          LDX     #55                    ;LEVEL.
          JSR     PUTMPLAT
          LDX     #0
          STX     L0Z0+1
          STX     FAKEJOY

          LDX     #17
          JSR     TITLCOLR
          JSR     SETOPT

ZINITPLR  JSR     SETPAL3
          JSR     DLFLIP                 ;FLIP TO DISPLAY LIST JUST CONSTRUCTED.
ZDEBSEL   LDA     SWCHA
          ORA     #$0F                   ;DEBOUNCE ENTRY INTO SELECT BY WAITING
          CMP     #$FF                   ;  FOR JOYSTICK TO CENTER.
          BNE     ZDEBSEL
ZDEBSEL2  LDA     SWCHB                  ;ALSO WAIT FOR SELECT BUTTON RELEASE.
          LSR     A
          LSR     A
          BCC     ZDEBSEL2

          LDA     SELCTIM
***       CLC
***       ADC     #75
          ADC     #74                    ;(CARRY ALREADY SET).
          STA     TEMP
          LDA     BONZO                  ;SAVE GAME OPTION.
          STA     TEMP+1

SLOOP
          INC     P0C0SHAD+27
          LDA     INPT4                  ;BUTTON ON JOYSTICK PRESSED?
          BPL     LEAVSLCT
          LDA     SWCHB                  ;RESET PRESSED?
          LSR     A
          BCS     DOSLCT
WAITRSET  LSR     SWCHB                  ;WAIT TILL RESET BUTTON UP.
          BCC     WAITRSET
          JSR     SETRACK1               ;START ON LOWEST RACK.

LEAVSLCT  LDX     #0
          STX     ATTRACT
          LDA     BONZO                  ;HAS GAME LEVEL CHANGED?
          CMP     TEMP+1
          BNE     ZRESCORE
          BEQ     ZGOATTR

DOSLCT
          LSR     A
          BCS     DOJOY                  ;SELECT PRESSED: ROTATE OPTIONS.
          DEC     FAKEJOY
          LDA     FAKEJOY
          AND     #3
          TAX
          LDA     FJOY,X
          BNE     ZDOJOY

DOJOY     LDA     SWCHA                  ;READ JOYSTICK: UP/DOWN WILL TOGGLE
ZDOJOY    LDX     #1
          ASL     A                      ;  NUMBER OF PLAYERS, RIGHT/LEFT WILL
          BCC     HGHLEVEL               ;  INCREASE/DECREASE STARTING LEVEL.
          ASL     A
          BCC     LOWLEVEL
          ASL     A
          BCC     ONEPGAME
*         ASL     A
*         BCC     TWOPGAME
          BPL     TWOPGAME
          LDX     FRMCNT
          INX
          TXA
          JMP     WAITJOY
ONEPGAME  DEX                            ;X CONTAINS 0 NOW.
TWOPGAME  STX     NUMPLAYR               ;TWO PLAYER GAME.
          JMP     GOSETOPT
HGHLEVEL  DEX                            ;PINEAPPLE MODE: BONZO = 0.
LOWLEVEL  STX     BONZO
GOSETOPT  JSR     SETOPT

DEBJOY    LDA     FRMCNT                 ;WAIT 20 FRAMES TO DEBOUNCE JOYSTICK.
***       CLC                            ;(CARRY ALREADY CLEAR).
          ADC     #20
WAITJOY
          LDX     TEMP
          CPX     SELCTIM                ;APPROXIMATELY 5 MINUTES.
          BNE     TSTWAIT
          LDX     #1
          STX     ATTRACT
          LDA     BONZO
          CMP     TEMP+1
          BEQ     ZGOATTR
ZRESCORE
*ZRESCORE  LDY     #5                    ;THIS NOW DONE IN ISCOREL.
*ZRESCOR   LDA     #0
*         STA     SCOREL,Y
*         DEY
*         BPL     ZRESCOR
          STX     ATTRACT
          JSR     ISCOREL                ;RETURNS 0 IN A.
          TAX
*         LDX     #0                     ;UPDATE PLAYER 0'S SCORE.
          JSR     ADDSDONE
          LDX     NUMPLAYR               ;AND PLAYER 1'S.
          BEQ     ZGOATTR
          JSR     ADDSDONE
ZGOATTR   LDX     ATTRACT
          BNE     ZTITLEP                ;GO TO ATTRACT MODE.
***       JSR     SCRNOFF
***       JSR     DLFLIP
***       LDX     ATTRACT
          RTS                            ;************** RTS ****************

TSTWAIT   CMP     FRMCNT
          BNE     WAITJOY
          JMP     SLOOP

; THIS IS KIND OF SLEAZY, BUT NO MATTER WHERE WE ARE IN THE CODE, SELECT COULD
;    BE CALLED.  IF IT TIMES OUT, WE NEED TO GO BACK TO THE TOP LEVEL OF MAIN
;    TO START ATTRACT MODE.  RATHER THAN PUTTING HOOKS IN EVERY PLACE THAT
;    SELECT (=> ALSO CHKSTATE, FREEZFRM) IS CALLED TO CATCH THE TIMEOUT, WE
;    CAN JUST RELY ON TITLEPAG TO SET UP THE SAMPLE ATTRACT MODE AND JUMP
;    TO PLAYGAME IN MAIN.

ZTITLEP   LDX     #$FF
          TXS
          JSR     ICOLORS
          JMP     PLAYTITL


********************************************************************************
SETOPT    LDA     NUMPLAYR
          ASL     A                      ;TOP BIT OF NUMPLAYR ALWAYS 0!
***       CLC
          ADC     #FULL0+2
          STA     L0Z6+33
          LDA     BONZO
          BNE     ZBONZ
          JSR     PINECOLR
          LDA     #PINEAPPL
          BNE     ZNOBONZ
ZBONZ     JSR     BONZCOLR
          LDA     #TEDDY
ZNOBONZ   STA     L0Z9+25
          RTS

********************************************************************************
***********
***********       DOCOLORS:  RESTORE PALETTES - CALLED EACH FRAME.
***********
********************************************************************************
DOCOLORS  LDX     #31
ZDOCOLR   LDA     P0C0SHAD,X
          STA     P0C0,X
          DEX
          TXA
          AND     #3
          BNE     ZDOCOLR
          DEX
          BPL     ZDOCOLR
          INX
          STX     P0C0
          RTS



SETDPLH   LDA     LISTTBH0,X
          BIT     DLSTPTR                ;GET CORRECT DISPLAY LIST.
          BVS     SLCTLST0
          LDA     LISTTBH1,X
SLCTLST0  STA     DPHIGH
          LDA     LISTTABL,X
          STA     DPLOW
          RTS


BONZCOLR  LDA     VEGCOL1+18
          STA     VEGCOLR+1
          LDA     VEGCOL3+18
          STA     P0C0SHAD+23
          LDA     VEGCOL2+18
          STA     VEGCOLR
          STA     P0C0SHAD+22
ZDRTS     RTS                            ;BRANCHED TO FROM CHKDEATH FILE
********************************************************************************
***********                                                          ***********
***********       CHKDEATH:  IF DIGDUG HAS DIED, DO DEATH            ***********
***********                  SEQUENCE, RESET TO SAME RACK,           ***********
***********                  SWITCH PLAYERS IF NECESSARY, AND        ***********
***********                  INITIALIZE CREATURES IN TUNNELS.        ***********
***********                  NOTE THAT ONCE DEATH IS DETECTED,       ***********
***********                  CONTROL WILL STAY IN THIS ROUTINE       ***********
***********                  UNTIL DEATH SEQUENCE HAS BEEN           ***********
***********                  COMPLETED AND RACK, ETC. IS RESET.      ***********
***********                                                          ***********
********************************************************************************
CHKDEATH
          LDA     DEATH                  ;HAS DIGDUG DIED?
          BEQ     ZDRTS                  ;LOCATED AT END OF SELECT FILE

*********** DO DEATH SEQUENCE ...

DSEQUNC
          LDA     FRUIT                  ;DOES FRUIT NEED TO APPEAR?
          BEQ     DSEQUNC2
          CMP     #$0F
          BCS     DSEQUNC2
          JSR     DFRUIT                 ;DISPLAY FRUIT
DSEQUNC2
          LDA     NEEDDIR                ;IF DIGDUG IS UNDER A ROCK
          BEQ     DSEQUNC3               ;   ....GIVE IT A SHOVE
          LDX     HITROCK
          LDA     #ONEDGE
          STA     TUMBLE,X
DSEQUNC3

          LDA     #40
          JSR     GENFREEZ
**        TXA                            ;BUTTON PUSHED?
**        BNE     ZDRTS

          LDY     #0
          LDX     #NUMCREAT              ;FIRST STAGE OF DEATH SEQUENCE
CHKGBNF   LDA     MONSTAT,X
          AND     #$86
          CMP     #$02                   ;POPPED (GBNF) CREATURES ARE DEAD
          BNE     VANCREAT
          LDA     BLWSTAT,X              ;POP STAGE?
          CMP     #4
          BNE     DOVAN
          JSR     CAROL                  ;MAKE SURE POINTS GET ADDED IN
DOVAN     JSR     OFFSCR2                ;SETS MONSTAT,X TO $80;POOKAY,X TO 0
          TAY                            ;OFFSCR2 RETURNS 0 IN A
*         LDA     #$80
*         STA     MONSTAT,X
VANCREAT  STY     POOKAY,X               ;DON'T DISPLAY CREATURES
          DEX
          BPL     CHKGBNF

          STY     FLAMEY                 ;STOP DISPLAYING FLAME
          STY     FRUITY                 ;STOP DISPLAYING FRUIT

          LDA     #$08
          JSR     GENFREEZ

          LDY     #SNG14                 ;START DEATH NOISE.
          JSR     NOISE

          LDX     #4
          STX     DTEMP2
          LDY     LASTMOVE
          LDX     DANIMIX,Y
          STX     DETHTEMP
DETHANIM  LDA     ADEATH,X               ;APPROPRIATE ANIMATION FOR THIS STAGE.
          STA     DDINDX
          LDA     #18
          JSR     GENFREEZ
**        TXA
**        BNE     ZDRTS                  ;WAS BUTTON PUSHED IN ATTRACT MODE?
          DEC     DETHTEMP
          LDX     DETHTEMP
          DEC     DTEMP2
          BPL     DETHANIM

*********** SEE IF ANY LIVES LEFT FOR THIS OR ANY OTHER PLAYER...

ENDDANIM
          JSR     TESTRACK
          LDX     #0                     ;SET UP FOR NEXT PLAYER'S LIFE:  IF 2
          STX     DEATH                  ;  PLAYER MODE, WE MAY BE SWITCHING.
*         STX     FRUITY
*         STX     FRUIT
          LDX     PLAYNUM                ;DECREMENT NUMBER OF LIVES LEFT.
          DEC     NUMMEN,X
          BNE     CHKSWTCH
          LDA     NUMPLAYR               ;NO LIVES LEFT: MORE THAN ONE PLAYER?
          BEQ     GOATTRAC               ;  IF NOT, GO INTO ATTRACT MODE.
          LDA     ATTRACT
          BNE     GOATTRAC

CHKSWTCH
          LDA     ATTRACT                ;ATTRACT MODE ONE PLAYER ONLY.
          BNE     GOSETC
          LDA     NUMPLAYR               ;MORE THAN ONE PLAYER?
          BEQ     GOSETC
          LDA     PLAYNUM                ;SWITCH PLAYER NUMBER INDEX.
          EOR     #1
          TAY
          LDA     NUMMEN,Y
          BNE     NEWPLAYR
          LDA     NUMMEN,X
          BEQ     GOATTRAC
GOSETC    JMP     SETCREAT               ;THIS PLAYER HAS MORE LIVES LEFT.
GOATTRAC
          LDX     ATTRACT
          BNE     ZGOTITLE
          JSR     UPDMEN
          LDX     #1
          STX     ATTRACT
*         LDX     #1                     ;GAME OVER MESSAGE.
          STX     IGNORE                 ;IGNORE JOYSTICK DURING GAME OVER.
                                         ;THIS WILL DISABLE ENTRY TO SELECT.
          JSR     PLAYREDY               ;(CLOBBERS X).
          JSR     HSCORENT
ZGOTITLE
          LDA     #1
          STA     NONOISE
          JMP     TITLEPAG               ;NO LIVES LEFT: GO TO TITLE PAGE.


*********** WE'RE SWITCHING PLAYERS ...

                                         ;SWITCH TO OTHER PLAYER: SINCE THIS
                                         ;  WILL TAKE LOTS OF CYCLES TO SWITCH
                                         ;  PLAYER'S DIRTMAPS, PUT UP A BLANK
                                         ;  SCREEN UNTIL WE'RE DONE.
NEWPLAYR  STY     PLAYNUM
          JSR     SCRNOFF

          LDX     #TOTLSTX2
SAVEYPOS  LDA     STMPYPOS,X
          PHA                            ;SAVE CURRENT PLAYER'S REMAINING YPOS
          LDA     BACKYPOS,X             ;  VALUES AND READ IN OTHER PLAYER'S.
          STA     STMPYPOS,X             ;WE'RE ALSO SAVING STMPXPOS HERE TOO!
          PLA                            ;IF FOLLOWS STMPYPOS ARRAY.
          STA     BACKYPOS,X
          DEX
          BPL     SAVEYPOS

          LDX     #7
SAVETMBL  LDA     TUMBLE,X               ;SAVE CURRENT PLAYER'S TUMBLE ARRAY.
          PHA                            ;ALSO SAVES FALLCNT,BRCREAT,
          LDA     BACKTMBL,X             ;  AND BRTUNNL.
          STA     TUMBLE,X
          PLA
          STA     BACKTMBL,X
          LDA     MONSTAT,X
          PHA
          LDA     BACKMONS,X
          STA     MONSTAT,X
          PLA
          STA     BACKMONS,X
          LDA     #STRTROCK
          STA     ROCKSIX,X
          DEX
          BPL     SAVETMBL

          LDX     #$F0
SAVEDIRT  LDA     DIRTMAP,X              ;SAVE CURRENT PLAYER'S DIRTMAP.
          PHA
          LDA     BACKDIRT,X
          STA     DIRTMAP,X
          PLA
          STA     BACKDIRT,X
          DEX
          CPX     #$FF
          BNE     SAVEDIRT

          LDX     P2INIT                 ;HAVE WE INITIALIZE P2 YET?
          BNE     SETCREAT
          INX
          STX     P2INIT
          STX     ENTRY
          DEX
          JSR     PLAYREDY
          JSR     INITRACK               ;THEN THIS IS THE FIRST TIME HE'S BEEN
          JMP     RESETSCR               ;  UP SO INITIALIZE THE WORLD FOR HIM.

*********** SET UP CREATURES FOR NEW LIFE ...

SETCREAT
          LDX     ATTRACT
          BNE     ZNOPLAYM
          LDX     NUMPLAYR
          BEQ     ZNOPLAYM
          DEX
          JSR     PLAYREDY               ;PUT UP PLAYER N MESSAGE.
ZNOPLAYM  LDA     #1
          STA     NOTUNNEL               ;JUST INIT CREATURES, NOT TUNNELS.
          JSR     INITDIRT
***       JSR     INCREATS
          JSR     DDMIDDLE
***       JSR     SETDFAST               ;INCLUDED IN INCREATS
RESETSCR
          LDA     #0
          STA     LASTMOVE
          LDA     ATTRACT
          BNE     SETNSCR
          JSR     UPDMEN                 ;UPDATE NUMBER OF MEN LEFT FOR PLAYER.
SETNSCR
          LDA     #40

GENFREEZ  PHA
          JSR     GENDPL
          PLA
          JMP     FREEZFRM
UPDMEN
          LDX     PLAYNUM
          CLC
          LDY     #BLANK1
          LDA     NUMMEN,X
          BEQ     ZRESET0
          ASL     A
          ADC     #FULL0-2
          TAY
ZRESET0   STY     L0Z0+53
          RTS
********************************************************************************
***********                                                          ***********
***********       FREEZFRM:  FREEZE PICTURE ON SCREEN.  A CONTAINS   ***********
***********                  NUMBER OF FRAMES FOR DURATION OF        ***********
***********                  FREEZE.  RETURNS 1 IN X IF WE WERE      ***********
***********                  IN ATTRACT MODE AND THE BUTTON WAS      ***********
***********                  PUSHED DURING THE FREEZE, 0 OTHERWISE.  ***********
***********                                                          ***********
********************************************************************************
FREEZFRM
          CLC
          ADC     FRMCNT
DFREEZE
          PHA
          JSR     CHKSTATE               ;IF SO, CHECK BUTTONS.
          TYA
**        BNE     NOTPAUSD
**        TAX
          BEQ     ZPLA                   ;PAUSE BUTTON PRESSED.
NOTPAUSD  PLA
          CMP     FRMCNT
          BNE     DFREEZE
**        LDX     #0                     ;BUTTON NOT PUSHED.
          RTS
ZPLA      PLA
          RTS



********************************************************************************
***********                                                          ***********
***********       HSCORENT:  SET UP FOR AND CALL HSCENTER TO         ***********
***********                  ENTER HIGH SCORE(S) FOR PLAYER(S)       ***********
***********                  WHOSE GAME JUST ENDED.                  ***********
***********                                                          ***********
********************************************************************************
HSCORENT
          LDA     BONZO
          JSR     HSCINIT                ;INIT RAM BLOCK FOR HSC ARGUMENTS.
          TXA
          BNE     HSCRTS
          LDX     NUMPLAYR
          BEQ     NO10SEC
          DEX                            ;IF TWO PLAYER, DON'T DELAY 10 SECONDS
          STX     HSCTIME                ; AFTER ENTERING INITIALS FOR PLAYER 0.
NO10SEC
***       LDX     #0
          JSR     ENTERHSC

          LDA     NUMPLAYR
          BEQ     HSCDISPL
          LDA     #10
          STA     HSCTIME
          LDA     HSCDIFFL               ;CHANGE PLAYER NUMBER.
          ORA     #1
          STA     HSCDIFFL
          LDX     #1
          JSR     ENTERHSC
HSCDISPL                                 ;THIS ALSO ACTS AS AN ENTRY POINT FOR
          JSR     SCRNOFF                ;  RESTORING RAM AFTER HSCATRCT CALL.
          JSR     IDIRTRAM               ;  PALETTES WILL BE RESTORED WITHIN ONE
          LDA     #$50                   ;  FRAME OF REGULAR DIGDUG DISPLAY.
          STA     CTRL                   ;RESTORE REGISTERS CHANGED BY HSC.
          LDA     #CSET1
          STA     CHARBASE
          LDA     #L(DLISETUP)
          STA     DLIVECT
HSCRTS    RTS

*****************************************
ENTERHSC  LDA     SCOREL,X               ;WRITE PLAYER X'S SCORE INTO SCORE
          STA     HSCOREL                ;  BUFFER. (TOP BYTE OF SCORE BUFFER
          LDA     SCOREM,X               ;  IS ALWAYS ZERO IN DIGDUG'S CASE).
          STA     HSCOREM                ;  FIRST BYTE IS MOST SIGNIFICANT
          LDA     SCOREH,X               ;  BYTE OF SCORE.
          STA     HSCOREH
          LDX     #L(HSCRAM)
          LDY     #H(HSCRAM)
          JMP     HSCENTER               ;*** = RTS!

********************************************************************************
***********                                                          ***********
***********       HSCINIT:  INITIALIZE ARGUMENT BLOCK FOR HSC.       ***********
***********                 RETURN 1 IF HSC DOESN'T EXIST.           ***********
***********                                                          ***********
********************************************************************************
HSCINIT
          PHA
          LDX     #1
          LDA     $3900                  ;SEE IF HSC IS THERE.
          CMP     #$C6
          BNE     NOHSC
          LDA     $3904
          CMP     #$FE
          BNE     NOHSC

**        LDY     #2                     ;HIGH SCORE MUSIC.
**        JSR     NOISE
          JSR     SCRNOFF
***       LDA     #$FF                   ;TURN OFF DMA.
***       STA     CTRL
          LDA     #L(DLITOP)
          STA     DLIVECT

          LDX     #14
INITHSC   LDA     HSCARGS,X              ;INITIALIZE THE HSC ARGUMENT BLOCK.
          STA     HSCRAM,X               ;  THIS DEFAULTS TO BONZO LEVEL.
          DEX
          BPL     INITHSC

          LDA     #$40                   ;SET UP DIGDUG LOGO IN DISPLAY LIST 0.
          STA     DLSTPTR
          JSR     SETTITLE
          LDX     #29                    ;SET UP COLORS FOR LOGO.
          JSR     TITLCOLR
          STA     P0C0SHAD+23

          LDX     #5
SETFRUIT  LDA     TEDYPINE,X             ;ADD STAMP FOR LEVEL INDICATOR INSTEAD
          STA     L0Z9+5,X               ;  OF USING LETTERS PROVIDED IN HSC.
          DEX                            ;  (DEFAULT LEVEL IS BONZO).
          BPL     SETFRUIT
**        INX
          LDX     #$FC
          STX     L0Z13+30               ;NO DIGDUG IN SELECT LOGO.
          STX     L0Z12+30
          JSR     BONZCOLR               ;(TITLCOLR JSR SET UP FOR PINEAPPLE).
          PLA                            ;SET BONZO(1) OR PINEAPPLE(0) MODE?
          PHA
          BNE     ANYLEVEL
          JSR     PINECOLR               ;CHANGE LEVEL INDICATOR TO PINEAPPLE.
          LDA     #$04
          STA     HSCDIFFL
          LDA     #PINEAPPL
          STA     L0Z9+5
ANYLEVEL                                 ;RETURN 0 AS HSC EXISTS.
          LDA     VEGCOLR+1
          STA     P0C0SHAD+21
          LDA     VEGCOLR
          STA     P0C0SHAD+22
          JSR     DOCOLORS               ;RETURNS 0 IN X.
NOHSC     PLA
          RTS


********************************************************************************
***********
***********       PLAYREDY: PUT UP PLAYER N MESSAGE WHEN SWITCHING PLAYERS
***********                 (X = 0 WHEN CALLED), OR GAME OVER (X = 1).
***********
********************************************************************************
PLAYREDY
          TXA
          PHA
          LDA     #1
          STA     NONOISE

          JSR     BACKMAP                ;RETURNS 0 IN X.
***       LDA     #0
          STX     L0Z0+1

          LDX     #10
          JSR     SETDPLH
          LDY     #3
          LDA     #$D0
          STA     (DPLOW),Y
          PLA
          PHA
          TAX
          LDY     MESGDPLY,X
          LDA     MESGOFST,X
          TAX
          JSR     PUTMPLAT

          PLA
          BNE     NOPNUM
          LDY     #29
          LDX     PLAYNUM
          BEQ     NOPNUM
          LDA     #FULL0+4
          STA     (DPLOW),Y

NOPNUM    JSR     DLFLIP
          JSR     SETPAL3

          JSR     SCRNON
          LDA     #100
          JSR     FREEZFRM

          JSR     RESPAL3
          INY
          STY     NONOISE

          JSR     SCRNOFF
          JSR     IDLISTS                ;RE-INITIALIZE DISPLAY LISTS.
          LDA     #W1ZONE
          STA     L0Z0+1

          RTS

********************************************************************************

***********       CHKSTATE:  CHECK FOR RESET, SELECT, OR, IF WE'RE IN ATTRACT
***********                MODE, THE BUTTON ON THE JOYSTICK.  IF ANY OF THESE
***********                BUTTONS ARE PRESSED, THE STATE OF THE GAME WILL
***********                BE CHANGED.  NOTE THAT THIS ROUTINE DOES NOT READ
***********                THE JOYSTICK NOR THE BUTTON ON THE JOYSTICK IF
***********                WE'RE PLAYING A REAL GAME.

********************************************************************************
CHKSTATE
*         LDX     #0
*         LDA     INPT5                  ; SECOND PLAYER'S BUTTON IN USE?
*         BMI     OTHERJOY
*         INX
*OTHERJOY  LDA     SWCHA                  ; SECOND PLAYER'S JOYSTICK IN USE?
*         AND     #$0F
*         CMP     #$0F
*         BEQ     SETALIEN
*         INX
*SETALIEN  TXA
*         ORA     ALIEN
*         STA     ALIEN

          LDY     #1                     ;FLAG FOR PAUSE BUTTON HIT.
          LDX     ATTRACT                ;ATTRACT MODE?
          BNE     CHKBUTN
          LDA     #8
          BIT     SWCHB
          BNE     CHKRSET
          INX
          STX     NONOISE

RPAUSE    BIT     SWCHB                  ;PAUSE BUTTON PRESSED.
          BEQ     RPAUSE
          STX     SELCTIM
          DEY                            ;FLAG FOR PAUSE BUTTON HIT.
          JSR     UNBOUNCE
DOPAUSE
          JSR     RSELRES
          BCS     PSELRES
          LDX     SELCTIM
          BNE     CONTPAUS
          LDX     #$10                   ;TURN OFF DMA.
          STX     CTRL
OFFDMA    LDX     INPT4                  ;IF BUTTON OR JOYSTICKED TOUCHED,
          BPL     ONDMA                  ;  TURN DMA BACK ON, BUT STILL STAY
          LDX     SWCHA                  ;  IN PAUSE MODE.
          CPX     #$FF
          BNE     ONDMA
          BIT     SWCHB
          BEQ     ZRPAUSE
          JSR     RSELRES
          BCS     PSELRES
          BCC     OFFDMA
ONDMA     LDX     #$50                   ;TURN DMA BACK ON.
          STX     CTRL
          LDX     #1                     ;RESET COUNTER.
          STX     SELCTIM
CONTPAUS  BIT     SWCHB
          BNE     DOPAUSE
          JSR     UNBOUNCE
ZRPAUSE   BIT     SWCHB
          BEQ     ZRPAUSE
          LDX     #$50                   ;TURN DMA ON.
          STX     CTRL
          JSR     UNBOUNCE
          LDX     #0
          STX     NONOISE                ;X MUST REMAIN 0 FOR LATER!
          BEQ     CHKRSET
PSELRES   BNE     GOSELCT
          BEQ     PRESET

CHKBUTN   LDA     IGNORE
          BNE     CHKRSET
          DEX
          LDA     INPT4                  ;IF BUTTON PRESSED, BEGIN NEW GAME ON
          BPL     NEWAGAME               ;  CURRENT RACK.
          INX

CHKRSET   LDA     SWCHB                  ;RESET PRESSED?
          LSR     A
          BCS     CHKSEL
PRESET    JSR     SETRACK1               ;START ON RACK 1 (RETURNS 1 IN A).
          STA     NONOISE
DEBRSET   LSR     SWCHB                  ;STAY HERE UNTIL RESET RELEASED.
          BCC     DEBRSET
          LDX     #0                     ;REAL GAME.
          BCS     NEWAGAME

CHKSEL    LSR     A                      ;SELECT PRESSED?
          BCC     GOSELCT                ;IF SO, STAY IN SELECT MODE UNTIL RESET
                                         ;  OR BUTTON PRESSED.
          LDA     ATTRACT                ;TWO WAYS TO ENTER SELECT: IF ATTRACT
          BEQ     RADD                   ;  AND JOYSTICK PRESSED, ENTER SELECT.
          LDA     IGNORE
          BNE     RADD
          LDA     SWCHA
          AND     #$F0
          CMP     #$F0
          BEQ     RADD
GOSELCT   JSR     SELECT

NEWAGAME  STX     ATTRACT
          JSR     SCRNOFF                ;BLANK SCREEN DURING INITIALIZATION.
          LDX     ATTRACT                ;INITIALIZE GAME.
          JSR     INITGAME
          JSR     NEWDLST
          LDX     #$FF
          TXS
          JMP     PLAYGAME

UNBOUNCE  LDX     FRMCNT                 ;DEBOUNCE PAUSE SWITCH.
          INX
          INX
BOUNCER   CPX     FRMCNT
          BNE     BOUNCER
          RTS

CHKRACK
          JSR     TESTRACK
          BNE     RADD
          STX     LASTMOVE
          JSR     DDMIDDLE
NEWDLST
          LDA     ATTRACT
          STA     NONOISE
          LDA     #40
          JMP     GENFREEZ


TESTRACK
          LDA     DETHWISH
          ORA     SQUASH
*         ORA     DEATH                  ;UNNECESSARY SO LONG AS CALL TO
          BNE     NOTEND                 ; CHKDEATH PRECEDES CALL TO TESTRACK
          LDX     #NUMCREAT
NXTCREAT  LDA     MONSTAT,X
          BPL     NOTEND
          DEX
          BPL     NXTCREAT
          LDY     #SNG13                 ;RACKEND MUSIC
          JSR     NOISE
          LDA     #154                   ;ALLOW TIME FOR MUSIC TO FINISH.
          JSR     FREEZFRM
          LDX     PLAYNUM
          INC     RACKNUM,X
          JSR     SCRNOFF
          JSR     INITRACK
          LDX     #0
          RTS
NOTEND    LDX     #1
RADD      RTS

********************************************************************************
RSELRES
          LDX     #0
          LDA     SWCHB
          LSR     A
          BCS     RSELECT
          INX
          BNE     BREAD
RSELECT   LSR     A
          BCS     BREAD
          LDX     #2
BREAD     LDA     #8
          CPX     #1
          RTS
********************************************************************************
***********                                                          ***********
***********       ADDSCORE:  ADDS NEW POINTS TO EXISTING SCORE       ***********
***********                  FOR APPROPRIATE PLAYER, AND UPDATES     ***********
***********                  DIRTMAP CHARACTERS FOR NEW TOTAL.       ***********
***********          INPUT:  Y - MID BYTE.                           ***********
***********                  A - LOW BYTE.                           ***********
***********           USES:  X,Y,A,SCOREPTR,SCOREPTR+1.              ***********
***********                                                          ***********
********************************************************************************

ADDSCORE
          LDX     ATTRACT                ;DON'T CHANGE SCORE IF ATTRACT MODE.
          BNE     RADD
          LDX     ENTRY                  ;DON'T CHANGE SCORE IF ENTRY MODE.
          BNE     RADD                   ;RADD PRECEDES ADDSCORE!

UPDSCORE  LDX     PLAYNUM
          CLC
          SED
          ADC     SCOREL,X               ;LOW BYTE OF SCORE.
          STA     SCOREL,X
          TYA
          ADC     SCOREM,X               ;MID BYTE OF SCORE.
          STA     SCOREM,X
          BCC     ADDSDONE
          LDA     #0
          ADC     SCOREH,X               ;HIGH BYTE OF SCORE.
          STA     SCOREH,X

          CMP     #2                     ;DID WE JUST PASS 20,000?
          BEQ     NEWMAN
          AND     #$F                    ;MULTIPLE OF 100,000?
          BEQ     NEWMAN
          CMP     #5                     ;MULTIPLE OF 50,000?
          BNE     ADDSDONE

NEWMAN    CLD
          LDA     NUMMEN,X
          CMP     #10                    ;MAXIMUM OF 9 EXTRA LIVES AT ONCE.
          BEQ     ADDSDONE
          INC     NUMMEN,X
          JSR     UPDMEN                 ;UPDATE LIVES INDICATOR (CHKDEATH).
          LDY     #SNG11
          JSR     NOISE                  ;NEW LIFE NOISE.
          LDX     PLAYNUM

ADDSDONE  CLD
          LDY     #5                     ;PLAYER 0 SCORE IS AT LEFT EDGE.
          TXA
          BEQ     P0SCORE
          LDY     #29                    ;PLAYER 1 SCORE IS AT RIGHT EDGE.

P0SCORE   SEC                            ;IF (CARRY) THEN WE HAVEN'T SEEN A
          LDA     BONZO                  ;  NUMBER YET IN SCORE (USED FOR
          BEQ     REGGAME                ;  CHANGING LEADING ZEROS TO BLANKS).
          LDA     #$3E                   ;USE PALETTE 3 FOR TEDDY HEAD.
          STA     L0Z0+1,Y
          LDA     #TEDDY                 ;BONZO MODE HAS A LEADING TEDDY HEAD.
          BNE     NEXTT1
REGGAME   LDA     SCOREH,X               ;HIGH BYTE OF SCORE.
          JSR     ANDF0
NEXTT1    STA     L0Z0,Y
          LDA     SCOREH,X
          JSR     ANDF
NEXTT2    STA     L0Z0+4,Y
          LDA     SCOREM,X
          JSR     ANDF0
NEXTT3    STA     L0Z0+8,Y
          LDA     SCOREM,X
          JSR     ANDF
NEXTT4    STA     L0Z0+12,Y
          LDA     SCOREL,X
          JSR     ANDF0
NEXTT5    STA     L0Z0+16,Y

SCOREDON  RTS

*******************
* MOVED TO ARRAYS:
*ANDF0     AND     #$F0
*         BNE     NOTZERO1
*         BCC     NOTZERO1
*         LDA     #BLANK1                ;BLANK STAMP.
*         BEQ     ANDF0RTS
*NOTZERO1  LSR     A                      ;GET INDEX INTO STAMP TABLE FOR THIS
*         LSR     A                      ;  DIGIT OF SCORE.
*         LSR     A
*         CLC
*         ADC     #FULL0
*ANDF0RTS  RTS
*******************
ANDF      AND     #$F
          BCC     NOTZERO2               ;ALREADY HAD A NON-ZERO NUMBER?
          BNE     NOTZERO2               ;IS THIS DIGIT NON-ZERO?
          LDA     #BLANK1                ;NO, SO KEEP DISPLAYING BLANK.
          BEQ     ANDFRTS
NOTZERO2
          ASL     A
          CLC
          ADC     #FULL0
ANDFRTS   RTS
ENDD000
          ORG     $EF00
;   THIS FILE IS . . .                   MONSTER.S


;-------- DEFINITIONS

CHARDF    EQU     $1E                    ;*** MARIA 1 ($1E)
CHARD12   EQU     $24                    ;*** MARIA 1 ($24)
SETFLEE   EQU     $20

;-------- MONSTER MOVEMENT

MONSTERS  ASL     PROPORT                ;THIS GETS DONE ONCE PER FRAME
          BCC     ENDRATIO
          INC     PROPORT
ENDRATIO  LDA     ENTRY
          BNE     ENDTHIS
ZNXT113   JSR     PUMPER
          JSR     FRUITER
          JSR     FLAMER
          LDX     #$07                   TOP LEVEL MONSTER MOVEMENT ROUTINE
BRATS     JSR     MOVEMONS               -TO BE CALLED EVERY FRAME
          DEX
          BPL     BRATS

          LDA     SPEEDUP                ;TIME TO SPEEDUP?
          BNE     NOWFAST
          LDA     FAST                   ;NOT ALREADY FAST OR ESCAPING?
          ORA     ESCAPER
          BNE     NOWFAST
          LDA     #1                                                 !
          STA     FAST
          LDY     #SNG12                 ;SPEEDUP SOUND
          JSR     NOISE
;                                        SIMULTANEOUS SPEEDUP FROM HERE...
          LDX     #$07
PREV151   LDA     MONSTAT,X
          BMI     END151
          JSR     SPEEDER
END151    DEX
          BPL     PREV151
NOWFAST
          RTS

MOVEMONS  LDA     MONSTAT,X              X HOLDS MONSTER NUMBER
          BNE     ENDTHIS

CHKRATIO  LDA     DIR,X
          AND     #$0A                   ANY HORIZONTAL COMPONENT
          BEQ     THISVERT
*         JSR     DOOM
          LDA     PROPORT
          BPL     ENDTHIS

CHKSPEED  ASL     SPEEDL,X               IF SPEED SHIFT OUT IS ZERO
          ROL     SPEEDH,X               -THEN RETURN
          BCS     DISPCHAR               -THEN RETURN
ENDTHIS   RTS

THISVERT  ASL     SPEEDL,X
          ROL     SPEEDH,X
          BCC     ENDTHIS
SCRAT2    ASL     PROPORT2
          BCC     PREMOVE
          INC     PROPORT2

DISPCHAR  LDA     CHARSEQL,X             (DISPLAY CHARACTER)
          STA     TEMP1                  TEMP1 MUST BE ZERO PAGE
          LDA     #H(RPOOKA)
          STA     TEMP2                  TEMP2 MUST BE TEMP1+1
          LDY     CHARSEQN,X             INDEX INTO SEQUENCE
PREV1     LDA     (TEMP1),Y              ZERO PAGE INDIRECT ADDRESSING
          BNE     ZNXT50                  WHEN CHAR CODE=0 GO BACK TO
          TAY                            -BEGINNING OF CHAR SEQUENCE
          BEQ     PREV1
ZNXT50    INY                            GO TO ZNXT CHAR IN SEQUENCE
          STA     MONSI,X                UPDATE MONSTER INDEX ARRAY
          TYA                            USE A FOR ABS. INDEX STORE
          STA     CHARSEQN,X             SAVE CHARSEQ INDEX

PREMOVE   INC     SPEEDL,X
          LDY     DIR,X                  (MOVEMENT OF MONSTER)
          LDA     XTABLE,Y               TABLE OF VELOCITY VECTORS
          CLC                            -BASED UPON DIRECTION IN Y
          ADC     XPOS,X
          STA     XPOS,X                 (POSITION=POS+VELOCITY)
          LDA     YTABLE,Y
          CLC
          ADC     YPOS,X

          CMP     #192                   ;IF Y REQUEST IS OUT OF RANGE,
          BCS     FIXY                   ; DON'T ADJUST YPOS OR YMODC.
          CMP     #23                    ; I KNOW THIS IS AWFUL, BUT
          BCC     FIXY                   ; HOPEFULLY IT'LL NEVER HAPPEN, AND
;                                        ; AT LEAST THE SCORE WON'T BE WRECKED.

          STA     YPOS,X
          LDA     YTABLE,Y               UPDATE Y OFFSET COUNTER
          CLC                            -Y MOD C
          ADC     YMODC,X
          CMP     #$0C
          BNE     ZNXT69
          LDA     #$00
          BEQ     ZNXT12                 SAME AS JUMP
ZNXT69    CMP     #$FF
          BNE     ZNXT12
          LDA     #$0B
ZNXT12    STA     YMODC,X
FIXY      LDA     XPOS,X                 CHECK X GRID
          LDY     GHOST,X                CHECK IF GHOST
          BNE     DOGHOST
*         LDA     XPOS,X                 CHECK X GRID
          AND     #$07
          ORA     YMODC,X                CHECK Y GRID
          BNE     ENDTHIS                (RELATIVE JUMP OUT OF RANGE OTHERWISE)
          JMP     MOVEMODE               ONLY IF BOTH GRIDS ARE CENTERED

DOGHOST
*         LDA     XPOS,X                 CHECK X GRID
          AND     #$07
          BEQ     GHOSTONX
          LDA     YMODC,X                CHECK Y GRID
          BEQ     GHOSTONY
          RTS

GHOSTONX  JSR     GETDIRT
          CMP     #CHARD12
          BCS     JMODE
          CMP     #CHARDF                ;ALWAYS REMATERIALIZE ON SKY+FLOWERS
          BCS     ZNXT13
          STA     TEMP3
          TYA
          JSR     GHSTSUB2
*         SEC
*         SBC     #$10                   GET OTHER DIRT
*         TAY
*         LDA     DIRTMAP,Y
*         CMP     #CHARD12
          BCS     JMODE
          LSR     A                      SEE IF GHOST CAN APPEAR
          LSR     A
          ORA     TEMP3
          AND     #$02                   CHAR 1
          BNE     JMODE
          LSR     GHOST,X
          JSR     SPEEDER
          LDY     YMODC,X                IF GHOST APPEARS ON X AND Y
          BNE     ZNXT130
          JSR     GHSTSUB1
*         JSR     GETDIRT
*         STY     TEMP3
*         JSR     CHKOTHER
          LSR     A
          AND     #$04
          BEQ     ZNXT130
          STA     DIR,X                  HERE A = 4
JMODE     JMP     MODE
ZNXT130   LDA     #$05
          BPL     JMODE

GHOSTONY  JSR     GETDIRT
          CMP     #CHARD12
          BCS     JMODE
          CMP     #CHARDF                ;ALWAYS REMATERIALIZE ON SKY+FLOWERS
          BCS     ZNXT13
          STA     TEMP3
          INY                            GET OTHER DIRT
          LDA     DIRTMAP,Y
          CMP     #CHARD12
          BCS     JMODE
          LSR     A                      SEE IF GHOST CAN APPEAR
          LSR     A
          ORA     TEMP3
          AND     #$04                   CHAR 2
          BNE     JMODE
ZNXT13    LSR     GHOST,X
          JSR     SPEEDER
          LDA     #$0A
          BPL     JMODE

MOVECONT  JSR     GHSTSUB1
*         JSR     GETDIRT                A = DIRT CHAR, Y = DIRT ADDR.
*         STY     TEMP3                  NECESSARY FOR CHKOTHER CODE
*         JSR     CHKOTHER
*         AND     #$FE
          LSR     A
          TAY                            USE DIRT CHAR. AS INDEX INTO
          CMP     #$0F                   UPPER LIMIT OF DIRTABLE
          BCC     ZNXT51
          LDY     #$0F
ZNXT51    LDA     DIRTABLE,Y             GET LOW BYTE OF DIRTCODE ADDR.
          STA     TEMP1                  PUT IN ZERO PAGE FOR INDIRECT
          LDA     #H(DIRT0)
*         INY
*         LDA     DIRTABLE,Y             GET HIGH BYTE OF DIRTCODE ADDR.
          STA     TEMP2                  TEMP2 = TEMP1 + 1 (ZERO PAGE)
          JMP     (TEMP1)                JUMP TO DIRTCODE INDIRECTLY

;-------- FLAME DETERMINING CODE

MOVEMODE  JSR     MOVECONT
          LDA     MONSTAT,X              ; CREATURE COULD HAVE DIED
          BMI     FLAMOUT                ;    BY ESCAPING
          CPX     #$04                   ;FYGAR?
          BCC     FLAMOUT
          LDA     GHOST,X                ; LDA DOES NOT AFFECT CARRY
          BNE     FLAMOUT
          LDA     DIR,X                  ; LDA DOES NOT AFFECT CARRY
          AND     #$0A                   FLAME ONLY ON HORIZONTAL
          BEQ     FLAMOUT                ; AND DOES NOT AFFECT CARRY

*         LDA     SCNDTIM
*         BEQ     FLAMOUT                ;DON'T FLAME RIGHT AWAY
*         LDA     RACKTIME
*         AND     #$1F
*         CMP     #06
*         BCS     FLAMOUT

          LDA     FLAMTIME
*         CLC                            ; CARRY IS SET HERE
          ADC     #$0F                   FREQUENCY OF FLAMING
          STA     FLAMTIME
          BCC     FLAMOUT
          LDY     FLAMIE
          BNE     FLAMOUT
*G        LDA     #H(FLAMDET)
*G        PHA
*G        LDA     #L(FLAMDET)
*G        PHA
*G        JMP     MOVECONT
***       JSR     MOVECONT

FLAMDET   LDA     #ZBLANK
          STA     FLAMEIX
          INY
          STY     MONSTAT,X              ;FREEZE FYGAR
          JSR     SETFLAM
*         LDA     #$00
*         STA     FLAMSIZE               HERE A=0
*         LDA     #$E8                   THERE IS 16 CHAR SEQUENCE OF FYGAR
*         STA     FLAMNUM                -PRIOR TO FLAMING.
*         LDA     #$07
*         STA     FLAMWAIT
          STX     FLAMIE
          LDA     YPOS,X
          STA     FLAMEY
          LDA     XPOS,X
          CLC
          ADC     #$08
          STA     FLAMEX
;
;     NOTE: CODE FROM HERE THROUGH SKY15 LABEL MUST FALL ON SAME PAGE
;
DIRT5
DIRT10
FLAMOUT   RTS


;DIRTCODE                                 A = ALL POSSIBLE DIRECTIONS
DIRT0     JSR     NOREV                  -BASED UPON PRESENT DIRECTION
JJMODE    JMP     MODE                   -AND CURRENT DIRT CHARACTER
DIRT1     JSR     NOREV                  AT THIS POINT IN THE CODE,
          AND     #$0B                   -THE MONSTER IS CENTERED ON
          BPL     JJMODE                 -THE DIRT GRID (I.E. IMMEDIATELY
DIRT2     JSR     NOREV                  -ON TOP OF A DIRT CHARACTER)
          AND     #$07                   JUMP TO MODE DETERMINES THE
          BPL     JJMODE                 -MOVEMENT MODE (DESTINATION)
DIRT3     JSR     NOREV                  -OF THE MONSTER
          AND     #$03
          BPL     JGHOSTER
DIRT4     JSR     NOREV
          AND     #$0E
          BPL     JJMODE
*DIRT5     RTS                            ;SEE FLAMOUT
DIRT6     JSR     NOREV
          AND     #$06
          BPL     JGHOSTER
DIRT7     LDA     #$02
          BPL     JGHOSTER
DIRT8     JSR     NOREV
          AND     #$0D
          BPL     JJMODE
DIRT9     JSR     NOREV
          AND     #$09
          BPL     JGHOSTER
*DIRT10    RTS                            ;SEE FLAMOUT
DIRT11    LDA     #$01
          BPL     JGHOSTER
DIRT12    JSR     NOREV
          AND     #$0C
          BPL     JGHOSTER
DIRT13    LDA     #$08
          BPL     JGHOSTER
DIRT14    LDA     #$04
          BPL     JGHOSTER
SKY15
          JSR     SKYSUB
*         LDA     TEMP3
*         CLC                            GET DIRT UNDER POSITION
*         ADC     #$10
*         TAY
*         LDA     DIRTMAP,Y

          AND     #$E2                   NOT FULL AND NOT TOP EDGE!!!
          BEQ     ZNXT32
          LDA     #$01
ZNXT32    EOR     #$0B
          STA     TEMP1
          JSR     NOREV                  MAKE ALL POSSIBLE DIR.
          AND     TEMP1
          STA     TEMP1
          LDA     TEMP3                  MODE FOR INDEX $1E (CHAR $F)
          CMP     #$01
          BNE     ZNXT28
          LDA     TEMP1
          AND     #$FD                   BOUNCE OFF LEFT SCREEN
          JMP     MODE
ZNXT28    CMP     #$0E
          BNE     ZNXT29
          LDA     TEMP1
          AND     #$F7                   BOUNCE OFF RIGHT SCREEN
JGHOSTER  JMP     GHOSTER
ZNXT29    LDA     TEMP1
          JMP     MODE

NOREV     LDA     DIR,X                  (NO REVERSE)
          AND     #$0A                   TAKES DIRECTION AND GIVES A
          BEQ     ZNXT11                 -THE VALUE OF ALL POSSIBLE
          ORA     #$05                   -DIRECTIONS WITHOUT REVERSE
          RTS
ZNXT11    LDA     DIR,X
          ORA     #$0A
          RTS

;
;     NOTE:  DIGVERT THROUGH DIGDIAG MUST OCCUR ON THE SAME PAGE
;
;-------- MOVEMENT MODE CODE

*DIGVERT   JSR     SUB1                   ;WITH APOLOGIES TO GENE
*         LDY     #0
*         BPL     DIGPREF
*DIGHORIZ  JSR     SUB1
*         LDY     #5
*DIGPREF   STA     MTEMP
*DIGPREFL  LDA     DIGPREFA,Y
*         BEQ     DIGPREF2
*         AND     MTEMP
*         PHA
*         BNE     DIGPREF2
*         INY
*         BPL     DIGPREFL
*DIGPREF2  PLA
*         JMP     ZNXT23

*DIGPREFA  DB      1,4,2,8,0              ;VERT
*         DB      8,2,4,1,0              ;HORIZ

DIGVERT   JSR     SUB1                   (TO DIG-DUG VERTICAL PREFERENCE)
          TAY
          AND     #$01                   THIS IS VERTICAL PREFERENCE
          BNE     ZNXT17
          TYA
          AND     #$04
          BNE     ZNXT17
          TYA
          AND     #$02
          BNE     ZNXT17
          TYA
          AND     #$08
ZNXT17    BPL     ZNXT23                 SAVE NEW DIRECTION

DIGHORIZ  JSR     SUB1                   (TO DIG-DUG HORIZONTAL PREFERENCE)
          TAY
          AND     #$08                   THIS IS HORIZONTAL PREFERENCE
          BNE     ZNXT20
          TYA
          AND     #$02
          BNE     ZNXT20
          TYA
          AND     #$04
          BNE     ZNXT20
          TYA
          AND     #$01
ZNXT20    BPL     ZNXT23                 SAVE NEW DIRECTION

DIGDIAG   JSR     SUB1                   (TO DIG-DUG DIAGONAL PREFERENCE)
ESCONT    STA     TEMP3
          LDA     TEMP1                  THIS IS DIAGONAL PREFERENCE
          BPL     ZNXT24                 FROM HERE ...
          EOR     #$FF
          STA     TEMP1
ZNXT24    LDA     TEMP2
          BPL     ZNXT25
          EOR     #$FF
ZNXT25    CMP     TEMP1
          BCS     ZNXT26
          LDA     TEMP3
          AND     #$08                   HORIZONTAL IS GREATER
          BNE     ZNXT23
          LDA     TEMP3
          AND     #$02
          BNE     ZNXT23
ZNXT26    LDA     TEMP3
          AND     #$04                   VERTICAL IS GREATER
          BNE     ZNXT23
          LDA     TEMP3
          AND     #$01
          BNE     ZNXT23
          LDA     TEMP3
          AND     #$08                   TRY HORIZ. AGAIN
          BNE     ZNXT23
          LDA     TEMP3
          AND     #$02                   TO HERE.
ZNXT23    STA     DIR,X                  SAVE NEW DIRECTION
          JMP     NEWSEQ                 ;NEWSEQ IS A SUBR

OFFSCR    LDA     #$00
          STA     GHOST,X
          LDA     #$02
          STA     DIR,X
          JSR     NEWSEQ
          JSR     SPEEDER
          LDA     XPOS,X                 ;LAST CREATURE VANISHES
          BMI     OFFSCR2
          BNE     ZNXT112
OFFSCR2                                  ;CALLED AS SUBR BY BLOWUP,CHKDEATH
          LDA     #$80                   ;  AND TITLEPAG
          STA     MONSTAT,X
          ASL     A                      ;STOP DISPLAYING CREATURE
          STA     POOKAY,X               ;SUBR MUST RETURN A 0
ZNXT112   RTS

ESCAPE    STA     TEMP5                  (TO ESCAPE UPPER LEFT SCREEN)
          LDA     XPOS,X                 SET UP TEMPS FOR GETPOINT
          STA     TEMP1                  TEMP1 = X0
          LDA     #$10                   TEMP2 = X DESTINATION
          STA     TEMP2                  TEMP3 = Y0
          LDA     YPOS,X                 TEMP4 = Y DESTINATION
          STA     TEMP3
          LDA     #$BF                   UPPER LEFT SCREEN POS
          STA     TEMP4
          JSR     GETPOINT
          BNE     ZNXT111
SCRAM     LDA     #L(OFFSCR)
          STA     MODEL,X
          LDA     #H(OFFSCR)
          STA     MODEH,X
          BNE     OFFSCR

ZNXT111   LDY     GHOST,X                CHECK IF GHOST JUST USE POINTER
          BEQ     ZNXT41                 -FOR NEW DIRECTION
          STA     DIR,X
          AND     #$0A                   ;CORRECT FACING
          BEQ     ENDTHIS2
          STA     FACING,X
ENDTHIS2  RTS
ZNXT41    AND     TEMP5                  FOR NORMAL (NOT GHOST) USE
          BNE     ZNXT42                 -POINTER AND ALL POSSIBLE DIR.
          LDA     #$04                   ;GO NORTH
          LDY     POOKAY,X
          CPY     #$BF
          BCC     ZNXT41A
          LSR     A                      ;GO WEST YOUNG MONSTER
          LDY     POOKAX,X
          CPY     #$10
          BCS     ZNXT41B
          BCC     SCRAM                  ;CHANGE MODE TO OFF SCREEN
ZNXT41A   INC     GHOST,X                ;CALLED AS SUBR BY GOGHOST
ZNXT41B   STA     DIR,X
          JSR     NEWSEQ                 ;EXPECTS DIR IN A
          JMP     SPEEDER                ;SPEEDER IS A SUBR
ZNXT42    JMP     ESCONT

;-------- UTILITIES

GHOSTER   STA     TEMP1                  SEE IF IT'S TIME TO GHOST THEN
          JSR     NOREV
          EOR     #$0F
          STA     GHOSTTMP
          LDA     #L(ESCAPE)             ;THERE IS PROBABLY A NEATER WAY TO
          CMP     MODEL,X                ;    DO THIS...
          BEQ     GHOSTER3

*         LDA     SCNDTIM
*         BEQ     GHOSTER7
*         TXA
*         AND     #$01
*         EOR     RACKTIME
*         BEQ     GHOSTER7

          LDA     BONZO                  ;BONZO LEVEL IS ALWAYS RACK 1 LEVEL
          BNE     GHOSTER0
          LDY     PLAYNUM
          LDA     RACKNUM,Y
GHOSTER0
          ASL     A
*         ASL     A
*         AND     #$03
          CLC
          ADC     #$0A
          BCS     ZNXT9
          ADC     FLEE
          BCS     ZNXT9
          ADC     GHOSTIME
          BCS     ZNXT9
          STA     GHOSTIME

          LDA     DIGREST                ;MORE LIKELY TO GHOST IF DD NOT MOVING
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          CLC
          ADC     GHOSTIME
          BCS     ZNXT9
          STA     GHOSTIME
*         LDA     RACKTIME
*         BMI     GHOSTER7
*         CMP     GHOSTIME
*         BCS     GHOSTER7
*         AND     #$0A
*         BNE     ZNXT9
*         BCS     ZNXT9
GHOSTER7  LDY     GHOSTOUT
          BEQ     ZNXT9

*         STA     GHOSTIME
GHOSTER3  LDA     TEMP1
GHOSTER2  STA     DIR,X
          JSR     NEWSEQ
          LDA     #L(ESCAPE)             KLUDGE TO FORCE GHOSTING WHEN
          CMP     MODEL,X
          BNE     ENDTHIS2
          LDA     DIR,X
          JMP     MODE

ZNXT9
          STA     GHOSTIME
          LDA     #0
          STA     DIGREST
;                                        TO HERE.
ZNXT34    LDA     TEMP1                  ;WHERE I CAN GO
          JSR     SUB11                  ;CALC WHERE I WANT TO GO
;                                        ;SUB11 STORES TEMP1 IN TEMP5
          PHA
          LDY     TEMP5                  ;IS ONLY POSSIBLE DIR REVERSE?
          CPY     GHOSTTMP
          BEQ     GOGHOST
          AND     TEMP5                  ;TEMP5 IS NOW WHERE I CAN GO
          BNE     NOGHOST
GOGHOST   LDA     #4
          STA     GHOSTOUT
          PLA
          JMP     ZNXT41A
*         INC     GHOST,X
*         STA     DIR,X
*         JSR     NEWSEQ
*         JMP     SPEEDER                ;SPEEDER IS A SUBR
NOGHOST   PLA
          LDA     TEMP5
          JMP     GHOSTER2

*ZNXT34    INC     GHOSTOK
*         JMP     GHOSTER2
*ZNXT34    INC     GHOST,X
*         LDA     TEMP1
*         JSR     NEWSEQ
*         JSR     SPEEDER
*         LDA     TEMP1
*         JMP     MODE

NEWSEQ    AND     #$0A                   INPUT: A=DIR
          BEQ     SEQER                  MODIFIES: FACING AND CHAR SEQUENCE
          STA     FACING,X
SEQER     TXA                            TYPE OF MONSTER
          AND     #$04
          ORA     FACING,X               DIRECTION
          LSR     A
          EOR     GHOST,X                GHOST OR NOT
          TAY
          LDA     SEQTAB,Y
          STA     CHARSEQL,X

          TAY                            ; SET UP FIRST ANIMATION OF NEW SERIES
          LDA     $EE00,Y                ; ASSUME RPOOKA IS ON THIS PAGE
          STA     POOKAIX,X

          LDA     #$00
          STA     CHARSEQN,X
          RTS

MODE      LDY     MODEL,X                MODE JUMPS TO CODE FOR THE
          STY     TEMP1                  -MOVEMENT MODE OF THE MONSTER
          LDY     MODEH,X                -(IT'S DESTINATION)
          STY     TEMP2
          JMP     (TEMP1)

;-------- SUBROUTINES

SUB11
          STA     TEMP5                  SUBROUTINE FOR CRUNCHED CODE
          LDA     XPOS,X                 SET UP TEMPS FOR GETPOINT
          STA     TEMP1                  TEMP1 = X0
          LDA     DDXPOS                 TEMP2 = X DESTINATION
          STA     TEMP2                  TEMP3 = Y0
          LDA     YPOS,X                 TEMP4 = Y DESTINATION
          STA     TEMP3
          LDA     DDYPOS
          STA     TEMP4
          JMP     GETPOINT               ;CALC WHERE YOU WANT TO GO
*         RTS                            ;GETPOINT IS A SUBR

SUB1      JSR     SUB11
          LDY     GHOST,X                CHECK IF GHOST JUST USE POINTER
          BEQ     ZNXT14                 -FOR NEW DIRECTION
          STA     DIR,X
          AND     #$0A
          BEQ     SUB1A
          STA     FACING,X
SUB1A     PLA                            REMOVE THE LAST CALL TO SUB1
          PLA
          RTS
ZNXT14    AND     TEMP5                  FOR NORMAL (NOT GHOST) USE
          BNE     ZNXT16                 -POINTER AND ALL POSSIBLE DIR.
          LDA     TEMP5
ZNXT16    RTS

AVOID     LDX     #$07
PREV47    LDA     MONSTAT,X              ;ENABLED?
          BMI     ZNXT108
          LDA     GHOST,X
          BNE     ZNXT108                ;NOT A GHOST?
          LDA     DIR,X
          CMP     #$04                   ;HEADED NORTH?
          BNE     ZNXT108
          LDA     YMODC,X                ;NOT IN BOTTOM 3 PIXELS OF TUNNEL?
          CMP     #$03
          BCC     ZNXT108
          LDA     ESCAPER
          BNE     ZNXT108
          LDA     #L(DIGVERT)            ;RESTORED WHEN ROCK IS DONE FALLING
          STA     MODEL,X
*         BEQ     ZNXT108                DO NOT GO DOWN IF AT BOTTOM OF TUNNEL
*         JSR     GETDIRT
*         STY     TEMP3
*         JMP     ZNXT108                TAKE THIS OUT . . .
*         JSR     CHKOTHER
*         AND     #$08
*         BNE     ZNXT108
ZNXT140   LDA     #$01                   ;GO SOUTH
          STA     DIR,X
ZNXT108   DEX
          BPL     PREV47
          RTS

FRUITER   LDA     FRUIT
          BEQ     FRUITOUT
          TAY
          LDA     RACKTIME
          LSR     A
          BCC     FRUITOUT
          TYA
          INC     FRUIT
          CMP     #$C0                   TIME WAIT TIL REMOVAL OF FRUIT
          BEQ     RFRUIT
          CMP     #$0E                   TIME WAIT TIL DISPLAY OF FRUIT
          BNE     FRUITOUT               -APPROX 2 SEC.
DFRUIT    LDY     #0
          CPY     BONZO                  ;BONZO MODE?
          BNE     ZNXT98
DFRUIT2   LDX     PLAYNUM
          LDY     RACKNUM,X
          CPY     #$12                   RACK NO. WHERE FRUIT REPEATS ...
          BCC     ZNXT98
          LDY     #$12                   VALUE OF HIGHEST FRUIT
ZNXT98    LDA     FRUITAB,Y
          STA     FRUITIX
          LDA     #56
          STA     FRUITX
          LDA     #107
          BPL     RFRUIT2
RFRUIT    LDA     #$00
          STA     FRUIT
RFRUIT2   STA     FRUITY
FRUITOUT  RTS

*WHNSPEED  DB      2,3,4,5,6             ;MOVED TO ARRAYS
GETMODE   LDX     #$07                   TO BE CALLED BY CREATURE DEATH
          LDY     #$00                   -AND INITIALIZATION ROUTINE
DIGMODE   LDA     MONSTAT,X              ; ALSO CALLED BY FALL IF ESCAPER
          BMI     ZNXT35                 ;  IS NOT SET IN ORDER TO RESTORE
          LDA     MODETAB,Y              ;  MODES DESTROYED BY AVOID
          STA     MODEL,X
          LDA     #H(DIGVERT)
*         INY
*         LDA     MODETAB,Y
          STA     MODEH,X
          INY
ZNXT35    DEX
          BPL     DIGMODE
*         DEY
          DEY
          BEQ     ESCMODE
          LDA     FAST
          BNE     ENDTHIS3               ;ALREADY FAST
          LDA     SPEEDUP
          CMP     #3
          BCC     ENDTHIS3
*         INY                            ;CREATURES LEFT
          LDA     BONZO
          BNE     TEDSPED
          LDX     PLAYNUM
          LDA     RACKNUM,X
*         CMP     #24                    ;WHEN RACK IS GE 24, SPEEDUP IS SET
*         BCS     ENDTHIS3               ; TO 2 IN INCREATS
TEDSPED   CMP     #4
          BCC     ENDTHIS3
          LSR     A
          LSR     A
          TAX
*         DEX                            ;!
          TYA
          CMP     WHNSPEED-1,X
          BCS     ENDTHIS3
          LDA     #1
          STA     SPEEDUP
          RTS
ESCMODE   LDX     #$08
PREV2     DEX
          LDA     MONSTAT,X
          TAY
          BMI     PREV2
          AND     #$40                   ;NO ESCAPE MUSIC IF LAST CR SQUASHING
          BNE     NOESCMUS
          TYA
          AND     #$06                   ;NO ESCAPE MUSIC IF LAST CR GBNF
          CMP     #$02
          BEQ     NOESCMUS
          LDY     #SNG9                  ESCAPING NOISE
          JSR     NOISE
NOESCMUS  LDA     #L(ESCAPE)
          STA     MODEL,X
          LDA     #H(ESCAPE)
          STA     MODEH,X
          INC     ESCAPER
*         LDA     #1
*         STA     FAST
*         JMP     SPEEDER                ;SPEEDER IS A SUBR

SPEEDER   TXA                            MODIFIES MONSTER SPEED BASED UPON
          AND     #$04                   -FAST OR NOT, GHOST AND TYPE
          ORA     GHOST,X
          LSR     A
          ORA     FAST
          ROL     A
          ASL     A                      FOR 16 BIT VERSION
          TAY
          LDA     SPEEDTAB,Y
          STA     SPEEDH,X
*         INY
          LDA     SPEEDTAB+1,Y
          STA     SPEEDL,X
ENDTHIS3  RTS

CHKOTHER  STA     TEMP2                  CHECKS ALL POSSIBLE ADJACENT
          LSR     TEMP2                  MAKES DIRT INDEX = DIRT CHAR
CHKUP     LSR     TEMP2
          BCS     CHKRIGHT
          STA     TEMP1
          LDA     TEMP3
          JSR     GHSTSUB2
*         SEC
*         SBC     #$10
*         TAY
*         LDA     DIRTMAP,Y              MODIFIES ALL POSSIBLE DIRECTIONS
*         CMP     #CHARD12               -AFTER CHECKING ADJACENT DIRT
          BCC     OUTUP
          LDA     #$02                   NO UP TURN
          ORA     TEMP1
          STA     TEMP1
OUTUP     LDA     TEMP1
CHKRIGHT  LSR     TEMP2
          BCS     CHKDOWN
          STA     TEMP1
          LDY     TEMP3
          INY
          LDA     DIRTMAP,Y              MODIFIES ALL POSSIBLE DIRECTIONS
          CMP     #CHARD12               -AFTER CHECKING ADJACENT DIRT
          BCC     OUTRIGHT
          LDA     #$04                   NO RIGHT TURN
          ORA     TEMP1
          STA     TEMP1
OUTRIGHT  LDA     TEMP1
CHKDOWN   LSR     TEMP2                  -HALF DIRTS
          BCS     CHKLEFT
          STA     TEMP1
          JSR     SKYSUB
*         LDA     TEMP3
*         CLC
*         ADC     #$10
*         TAY
*         LDA     DIRTMAP,Y              MODIFIES ALL POSSIBLE DIRECTIONS

          CMP     #CHARD12               -AFTER CHECKING ADJACENT DIRT
          BCC     OUTDOWN
          LDA     #$08                   NO DOWN TURN
          ORA     TEMP1
          STA     TEMP1
OUTDOWN   LDA     TEMP1
CHKLEFT   LSR     TEMP2
          BCS     CHKOUT
          STA     TEMP1
          LDY     TEMP3
          DEY
          LDA     DIRTMAP,Y              MODIFIES ALL POSSIBLE DIRECTIONS
          CMP     #CHARD12               -AFTER CHECKING ADJACENT DIRT
          BCC     OUTLEFT
          LDA     #$10                   NO LEFT TURN
          ORA     TEMP1
          STA     TEMP1
OUTLEFT   LDA     TEMP1
CHKOUT    RTS

GETPOINT  LDY     #$00                   USES TEMP1 - TEMP4, A, Y
          LDA     TEMP1                  TEMP1 = X0
          SEC                            TEMP2 = X DESTINATION
          SBC     TEMP2                  TEMP3 = Y0
          STA     TEMP1                  ; FOR DIAG INFO
          BEQ     VERTICAL               TEMP4 = Y DESTINATION
          BCS     LEFT                   A WILL HOLD THE POINTER
RIGHT     TYA                            NOTE: THE POINTER WILL BE
          ORA     #$08                   -AT MOST TWO BITS ON
          TAY
          BNE     VERTICAL
LEFT      TYA
          ORA     #$02
          TAY
VERTICAL  LDA     TEMP3
          SEC
          SBC     TEMP4
          STA     TEMP2                  ; FOR DIAG INFO
          BEQ     DONEPNT
          BCS     DOWN
UP        TYA
          ORA     #$04
          TAY
          RTS
DOWN      TYA
          ORA     #$01
          TAY
DONEPNT   TYA
          RTS

GETDIRT   LDA     XPOS,X                 RETURNS DIRT, A = CHAR, Y = ADDR.
GETX      LSR     A                      (GET DIRT CHARACTER)
          LSR     A
          LSR     A
          STA     TEMP1                  PUT X VALUE IN TEMP1 (ZERO PAGE)
GETY      LDA     YPOS,X                 GET Y POSITION
          SEC
*         SBC     YMODC,X                MAKE Y POSITION CENTERED IF IT'S NOT
          SBC     #$0B                   -CENTER TO GRID BECAUSE OF 11 OFFSET
          LSR     A                      DIVIDE BY 4
          LSR     A
          TAY
          LDA     DIV3TAB,Y
          EOR     #$0F                   DIRT ADDR. IS F - Y ADDR.
GETCHAR   ASL     A                      MOVE Y ADDR. TO LEFT NIBBLE
          ASL     A                      -OF A
          ASL     A
          ASL     A
          ORA     TEMP1                  MERGE X ADDR. WITH Y ADDR.
          TAY                            PUT DIRT ADDR. IN Y INDEX
          LDA     DIRTMAP,Y              GET DIRT CHARACTER FROM MAP
          RTS

*GHSTSUB2  SEC                            ;USED BY GHOSTONX AND CHKOTHER
*         SBC     #$10                    ;MOVED TO INITDIRT
*         TAY
*         LDA     DIRTMAP,Y
*         CMP     #CHARD12
*         RTS

;-------- FLAME DRIVER CODE

FLAMER    LDX     FLAMIE
          BEQ     ENDFLAM
          LDA     FLAMNUM
          BEQ     SNDFLAME               JUST BEFORE DRAWFLAM
          BPL     DRAWFLAM
          INC     FLAMNUM
          EOR     #$FF                   ; FLAP YOUR WINGS AND SMILE
          AND     #$0F
          LSR     A
          LSR     A
          STA     TEMP1
          LDA     FACING,X
          LSR     A
          LSR     A
          LDA     TEMP1
          ROL     A
          TAY
          LDA     FLAMTABL,Y             SEQUENCE FOR FLAMING FYGAR
          STA     MONSI,X                <--- 
ENDFLAM   RTS

SNDFLAME                                 ;SOUND AND LENGTH CALC DONE ONCE A FLAM
          JSR     GETDIRT                WE NEED Y (ADDRESS OF DIRT)
*         TXA
*         PHA
          LDA     FACING,X
          LDX     #2
          AND     #$02
          BNE     FLAMLEFT
FLAMRIGT
FLMRLOOP  INC     FLAMSIZE
          INY
          LDA     DIRTMAP,Y
          CMP     #CHARD12
          BCS     FLAMOUT0
          DEX
          BPL     FLMRLOOP
          INC     FLAMSIZE
          BNE     FLAMOUT0               SAME AS JMP FLAMOUT
FLAMLEFT  DEC     FLAMSIZE
FLMLLOOP  DEC     FLAMSIZE
          DEY
          LDA     DIRTMAP,Y
          CMP     #CHARD12
          BCS     FLAMOUT0
          DEX
          BPL     FLMLLOOP
          DEC     FLAMSIZE
FLAMOUT0
*         PLA
*         TAX
          LDX     FLAMIE

          LDY     #SNG3                  FLAME SOUND
          JSR     NOISE
DRAWFLAM  LDA     FLAMSIZE
          BPL     DRAWR
DRAWL     EOR     #$FF
          CMP     FLAMNUM
          BEQ     FLAMOUT2
          LDY     FLAMNUM
          LDA     XPOS,X
          SEC
          SBC     FLAMPOS,Y
          STA     FLAMEX
          LDA     LFLAMSEQ,Y
          BNE     DRAWR2
*         STA     FLAMEIX
*         INC     FLAMNUM
*         JMP     FLAMCOLL               ;FLAMCOLL IS A SUBR
DRAWR     CMP     FLAMNUM
          BEQ     FLAMOUT2
          LDY     FLAMNUM
          LDA     RFLAMSEQ,Y
DRAWR2    STA     FLAMEIX
          INC     FLAMNUM
DRAWR4    JMP     FLAMCOLL               ;FLAMCOLL IS A SUBR
FLAMOUT2  DEC     FLAMWAIT
          BNE     DRAWR4                 ;TWEAK THIS
          LDA     #ZBLANK
          STA     FLAMEIX
          LDA     PROPORT
          BMI     FLAMOUT4
SETFLAM   LDA     #0                     ;CALLED AS SUBR BY FLAMDET
          STA     FLAMSIZE
          LDA     #$E8
          STA     FLAMNUM
          LDA     #$07
          STA     FLAMWAIT
          RTS
FLAMOUT4  LDA     #$00                   ;CALLED AS SUBR BY PUMPCOLL
          STA     FLAMEY
          STA     FLAMIE
          STA     MONSTAT,X
          RTS




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                    ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;    FALL: CALLED FROM INIT EVERY FRAME.             ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;          HANDLES ROCK FALLING.                     ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;          SQUASHES CREATURES.                       ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;          SQUASHES DIGDUG.                          ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;          SETS FRUIT TO 1 WHEN 2ND ROCK DROPPED.    ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;          SETS DEATH IF DETHWISH SET AND ROCKS DONE.;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


FALL      LDA     #0
          STA     ROCKSNOW               ;COUNT OF ROCKS FALLING
          LDX     #NUMROCK               ;HANDLE EVERY ROCK
MOREROCK  STX     CURROCK
          JSR     ROCKMOV
          LDX     CURROCK
          DEX
          BPL     MOREROCK
          LDX     ROCKSNOW
          BNE     ENDROCK
          LDA     DETHWISH
          BEQ     ENDROCK
          STX     DETHWISH               ;ASSUME X IS 0
          INX
          STX     DEATH
ENDROCK   RTS


ROCKMOV   LDY     TUMBLE,X               ;ROCK STATE
          CPY     #ONEDGE
          BCC     ENDROCK
ROCKMOV1  INC     ROCKSNOW               ;UPDATE COUNT OF ROCKS FALLING
          LDA     DOROCKL-2,Y
          STA     RTEMP
          LDA     DOROCKH-2,Y
          STA     RTEMP+1
          JMP     (RTEMP)                ;DISPATCH TO CORRECT SUBR


RSLIP     LDY     #SNG7                  ;ROCK FALLING NOISE
          JSR     NOISE
ENDSTAT1  JMP     ENDSTAT2               ;UPDATE ROCK STATE

RTOTTER   LDY     #TOTRROCK
          LDA     ROCKSTAT,X
          AND     #$08
          BEQ     RTOTTER1
          LDY     #STRTROCK
RTOTTER1  STY     ROCKSIX,X
          INC     ROCKSTAT,X
          LDA     ROCKSTAT,X
          CMP     #$19
          BCS     ENDSTAT1
          CMP     #$08
          BCC     ENDROCK
          CMP     #$18
          BNE     DOAVOID
          LDA     #SETFLEE               ;MAKE CREATURES MORE LIKELY TO GHOST
          STA     FLEE
DOAVOID   JMP     AVOID                  ;WARN CREATURES (AVOID IS A SUBR)


GROUND    LDX     CURROCK
          BPL     ENDSTAT1

RFALL     LDY     ROCKSY,X               ;DON'T FALL OFF SCREEN
          CPY     #MINDDY
          BEQ     GROUND
          LDA     ROCKSTAT,X
RFALLOOP  CMP     #$07
          BCC     RFALL0
*         SEC
          SBC     #$07
          BNE     RFALLOOP
RFALL0    TAY
          LDA     ROCKSY,X
          SEC
          SBC     RFALLTBL,Y
          STA     ROCKSY,X
          LDY     ROCKSTAT,X
          CPY     #6
          BCC     CRUSH

          LDA     #H(SOUTH7)
          STA     DRTPTR+1
          LDA     ROCKSY,X
*         SEC
ROCKOFST  SBC     #12                    ;GET DISTANCE ABOVE ROW
          CMP     #12
          BCS     ROCKOFST
          CMP     #10
          BEQ     ROCKONE
          CMP     #4
          BEQ     ROCKHALF
          CMP     #11
          BNE     CRUSH

RKBOUND   JSR     ROCKPUSH               ;USES TEMP+0, RETURNS DIRTMAP,X IN A
          CPX     #$F0                   ;DON'T FALL OFF SCREEN
          BCS     GROUND
          CMP     #36
          BCC     CRUSH
          CMP     #48                    ;*** MARIA 1 BOWTIE  (48)
          BEQ     CRUSH
          CMP     #44                    ;*** MARIA 1 CUP     (44)
          BEQ     CRUSH
          BNE     GROUND


ROCKHALF  JSR     ROCKPUSH               ;USES TEMP+0, RETURNS DIRTMAP,X IN A
          CMP     #36
          BCC     CRUSH
          CMP     #48                    ;BOWTIE DIRT *** MARIA 1 (48)
          BNE     GROUND                 ;STOP AT CUP DIRT
          LDA     #20                    ;*** MARIA 1 (20)
          STA     DIRTMAP,X
          BPL     CRUSH


ROCKONE   LDA     #L(SOUTH1)             ;TO
          STA     DRTPTR
          JSR     ROCKPUSH               ;USES TEMP+0
          CMP     #36
          BCS     ROCKONE3
          LDY     #L(VERTBOT)
          STY     DRTPTR
          JSR     BORE1
ROCKONE3

ROCKONE2  LDA     #L(VERTTOP)            ;FROM
          STA     DRTPTR
          LDX     CURROCK
          LDA     ROCKSX,X
          PHA
          LDA     ROCKSY,X
          TAX
          PLA
          JSR     CALCINDX
          CMP     #36
          BCS     CRUSH
          JSR     BORE1


CRUSH     LDX     CURROCK

          LDY     #NUMCREAT
SQLOOP    LDA     MONSTAT,Y              ;ENABLED AND GBNF NOT SET?
          AND     #$86
          BMI     SQNXT
          CMP     #$02
          BEQ     SQNXT
          PHA
          LDA     POOKAX,Y
          STA     VICTIMX
          PLA
          CMP     #$06
          BNE     NOTBLOW
          LDA     BLWYPOS,Y
          BNE     DOCRUNCH
NOTBLOW   LDA     POOKAY,Y
DOCRUNCH  JSR     CRUNCH                 ;CHECK FOR SQUASH, CALC CREATURE YPOS
          BCC     SQNXT
          STA     POOKAY,Y
          LDA     MONSTAT,Y
          AND     #$40                   ;NOT ALREADY SQUASHED?
          BNE     CALREDSQ
          TXA                            ;CURROCK
          STA     ROCKNUM,Y              ;SAVE NUMBER OF GUILTY ROCK
          STY     RTEMP
          LDY     #SNG1                  ;SQUASH CREATURE SOUND
          JSR     NOISE
          LDY     RTEMP
CALREDSQ  LDA     MONSTAT,Y
          AND     #$F9                   ;TURN OFF PUMPED FLAGS
          ORA     #$41                   ;SET SQUASH AND FREEZE FLAGS
          STA     MONSTAT,Y
          LDX     #SQPOOKA
          TYA
          AND     #$04                   ;POOKA?
          BEQ     SQANIM
          LDX     #SQFYGAR
SQANIM    STX     POOKAIX,Y
          LDX     CURROCK
          CPY     FLAMIE                 ;SQUASHED CREATURE FLAMING?
          BNE     CHKPMP
          LDA     #0
          STA     FLAMIE                 ;STOP FLAMING
          STA     FLAMEY                 ;DON'T DISPLAY FLAME
CHKPMP    CPY     PUMPIE                 ;SQUASHED CREATURE PUMPEE?
          BNE     SQNXT
          JSR     VANPUMP                ;FOUND IN COLLISON
;                                        ;USES A
;                                        ;CLEARS PUMPY ETC., SETS PUMPIE TO FF
SQNXT     DEY
          BPL     SQLOOP

          LDA     DDXPOS
          STA     VICTIMX
          LDA     DDYPOS
          JSR     CRUNCH                 ;CHECK FOR SQUASH, CALC DDYPOS
          BCC     RFALL3
          STA     DDYPOS
          JSR     VANPUMP                ;FOUND IN COLLISON
;                                        ;USES A
;                                        ;CLEARS PUMPY ETC., SETS PUMPIE TO FF
          LDY     SQUASH                 ;NOT ALREADY SQUASHED?
          BNE     DALREDSQ
          LDY     #SNG1
          JSR     NOISE
DALREDSQ  LDY     #1
          STY     SQUASH                 ;SET DIGDUG SQUASHING FLAG
          LDA     #SQDIGDUG
          STA     DDINDX
RFALL3    INC     ROCKSTAT,X
          JMP     AVOID                  ;AVOID IS A SUBR

RBOTTOM
*         LDA     ROCKSTAT,X
*         BNE     RBOTTOM2

          LDA     #0
          STA     FLEE                   ;ASSUME A = 0

*         LDY     #0                     ;DO THIS JUST ONCE
*         LDX     #NUMCREAT
*SQCNT     LDA     MONSTAT,X
*         AND     #$40                   ;SQUASHED?
*         BEQ     SQCNTNXT
*         INY                            ;UPDATE SQUASHED CREATURE COUNT
*SQCNTNXT  DEX
*         BPL     SQCNT

*         LDX     CURROCK
*         TYA
*         STA     NUMSQSH,X

          INC     ROCKSTAT,X
          LDA     ROCKSTAT,X
          CMP     #$10
          BCC     RBOTTOM3               ;GO RETURN

          JSR     ENDSTAT2               ;UPDATE ROCKSTATE (RETURNS 0 IN A)

          STA     NUMSQSH,X              ;INIT COUNT OF CRUSHED CREATURES
          LDY     #NUMCREAT
VANLOOP   LDA     MONSTAT,Y              ;STOP DISPLAYING CRUSHED CREATURES
          AND     #$40
          BEQ     VANNXT
          TXA                            ;CURROCK
          CMP     ROCKNUM,Y              ;GUILTY ROCK?
          BNE     VANNXT
          INC     NUMSQSH,X              ;UPDATE COUNT OF CRUSHED CREATURES
          LDA     #0
          STA     POOKAY,Y
VANNXT    DEY
          BPL     VANLOOP

          LDY     #SNG2                  ;HIT GROUND SOUND
          JMP     NOISE                  ; NOISE IS A SUBR

RBOTTOM3  LDY     ESCAPER                ;PREVENT ESCAPE MUSIC FROM SOUNDING 2X
          BNE     ENDFALL2
          CMP     #$01                   ;RESTORE MODES
          BEQ     DOGMODE
          RTS

RSPLIT
RCRUMBL   LDA     RKANIM-6,Y
DORPOINT  STA     ROCKSIX,X
          INC     ROCKSTAT,X
          LDA     ROCKSTAT,X
          CMP     RKTIM-6,Y
          BCC     ENDFALL2
ENDSTAT2  LDA     #0
          STA     ROCKSTAT,X
          INC     TUMBLE,X
ENDFALL2  RTS

RPOINTS   LDY     NUMSQSH,X
          BEQ     ENDSTAT2
*         DEY
          LDA     DISPTS-1,Y             ;POINT DISPLAY
          LDY     #$08                   ;TUMBLE,X
          BNE     DORPOINT

RFINISH   LDA     #0
          STA     TUMBLE,X
          STA     ROCKSY,X
          DEC     ROCKSNOW               ;DECREMENT # OF ROCKS FALLING
          INC     FALLCNT
          LDA     FALLCNT
          CMP     #2
          BNE     NOVEG
          LSR     A
          STA     FRUIT
NOVEG     LDA     SQUASH                 ;DIGDUG WANTS TO DIE FROM SQUASHING?
          BEQ     ROCKDETH
          LDY     #0
          STY     SQUASH
          INY
          STY     DETHWISH

ROCKDETH  LDY     #NUMCREAT
SQDEAD    TXA                            ;CURROCK
          CMP     ROCKNUM,Y              ;GUILTY ROCK?
          BNE     SQDEDNXT
          LDA     MONSTAT,Y
          AND     #$40
          BEQ     SQDEDNXT
          ASL     A                      ;MARK AS DISABLED
          STA     MONSTAT,Y
SQDEDNXT  DEY
          BPL     SQDEAD

          LDY     NUMSQSH,X              ;POINT VALUES STORED HALVED
          BEQ     ENDFALL2
          DEY
          TYA
          ASL     A
          TAX
          LDA     FLATPTS,X
          INX
          LDY     FLATPTS,X
          STX     RTEMP
          JSR     ADDSCORE
          LDX     RTEMP
          LDY     FLATPTS,X
          DEX
          LDA     FLATPTS,X
          JSR     ADDSCORE

DOGMODE   JMP     GETMODE                ;CREATURES REDO STRATEGY
                                         ;GETMODE IS A SUBR

;-------- COLLISION DETECTION ROUTINE
;         BETWEEN DIGDUG AND MONSTERS

COLLISON  LDA     SQUASH
          BNE     ENDCOLL
          LDX     #$07
PREV23    LDA     MONSTAT,X
          CMP     #2                     ;ALLOW TOUCH OF FLAMING FYGAR TO KILL
          BCS     ZNXTCOLL
XCOLL     LDA     DDXPOS
          SEC
          SBC     XPOS,X
          BCS     ZNXT97
          EOR     #$FF                   2'S COMPLEMENT   (DOES NOT AFFECT C)
          ADC     #$01
ZNXT97    CMP     #$05
*         BCC     YCOLL
          BCS     ZNXTCOLL               SAME AS JMP
YCOLL     LDA     DDYPOS
          SEC
          SBC     YPOS,X
          BCS     ZNXT96
          EOR     #$FF                   2'S COMPLEMENT   (DOES NOT AFFECT C)
          ADC     #$01
ZNXT96    CMP     #$07
*         BCC     YESCOLL
          BCS     ZNXTCOLL               SAME AS JMP
YESCOLL   LDA     #$01                   MONSTER AND DIGDUG COLLIDE!!!
          STA     DETHWISH
          LDY     LASTMOVE
          LDX     DANIMIX,Y
          LDA     ADEATH,X
          STA     DDINDX
          JSR     VANPUMP                ;STOP DISPLAYING PUMP
          LDY     #SNG8                  GOTCHA NOISE
          JMP     NOISE                  ;NOISE IS A SUBR
ZNXTCOLL  DEX
          BPL     PREV23
ENDCOLL   RTS


;-------- COLLISION DETECT ROUTINE
;         BETWEEN DIGDUG AND FLAME


FLAMCOLL  LDA     SQUASH
          BNE     ENDCOLL
          LDA     FLAMEX
          SEC
          SBC     #$07
          SEC
          SBC     DDXPOS
          BCS     ENDCOLL
          EOR     #$FF                   ;DOES NOT AFFECT C
*         CLC
          ADC     #$03                   SINCE FLAMNUM IS INCREMENTED BY ONE
          LSR     A
          LSR     A
          LSR     A
          CMP     FLAMNUM
          BCS     ENDCOLL
          LDA     DDYPOS
          SEC
          SBC     FLAMEY
          BCS     ZNXT94
          EOR     #$FF                   2'S COMPLEMENT  (DOESN'T AFFECT C)
          ADC     #$01
ZNXT94    CMP     #$0A
          BCS     ENDCOLL
          LDA     #$00
          STA     MONSTAT,X
          STA     FLAMIE
          BEQ     YESCOLL
*         LDA     #$01                   FLAME AND DIGDUG COLLIDE!!!
*         STA     DETHWISH
*         LDY     #SNG8
*         JSR     NOISE
*         RTS


;-------- PUMPING CODE
;-------- PUMPING STATE MACHINE

;---- BUTTON INPUT ROUTINE MOVED TO INITDIRT


PUMPER    JSR     INPUT
          LDA     PUMPCT
          BEQ     PUMPER2
          DEC     PUMPCT
          BNE     PUMPER2
          LDY     PUMPIE
          BMI     PUMPER2
          STA     PUMPING                HERE A = 1
          STA     PUMPCNT
PUMPER2   LDY     PUMPNUM
          BEQ     NOPUMP
          BPL     EXTEND
PUMPWAIT  LDX     PUMPIE
          BMI     ZNXT102
          LDA     MONSTAT,X
          BMI     ZNXT102                IF DISABLED BIT SET
          ASL     A
          BMI     ZNXT102                IF SQUASHED BIT SET
          AND     #$08
          BEQ     ZNXT102                IF GBNF BIT IS SET
          LDA     PUMPCNT
          BNE     VANEND
*         LDA     #$00
          STA     FREEZE
          LDA     WALKING
          BEQ     VANEND
ZNXT102   LDA     #$00                   IF WHILE WAITING SOMETHING HAPPENS
          STA     FREEZE
          STA     PUMPNUM                -THEN TURN OFF THE PUMP
VANPUMP   LDA     #$FF
          STA     PUMPIE
          LDA     #0                     ;CALLED FROM BLOWUP AND FALL
          STA     PUMPY
          STA     PUMPY+1
          STA     PUMPY+2
VANEND    RTS

NOPUMP    LDA     DIGGING
          BNE     VANEND
          LDA     SQUASH
          BNE     VANEND
          LDA     PUMP
          BEQ     VANEND
          LDA     #$01                   THE VALUE TO FREEZE DIGDUG
          STA     FREEZE                 THE DIGDUG STATUS REGESTER
          LDY     #SNG5                  THROWN HARPOON
          JSR     NOISE
          JSR     GETMAXP
          JMP     EXTEND2
EXTEND    LDA     MAXPUMP
          CMP     #1
          BEQ     ZNXT102
EXTEND2   JSR     DISPPUMP
          JSR     PUMPCOLL
          BNE     ZNXT104
          LDA     PUMPNUM
          INC     PUMPNUM
          CMP     MAXPUMP
          BNE     EXTEND3
          LDA     MAXPUMP
          CMP     #1
          BNE     ZNXT102
EXTEND3   RTS
ZNXT104   LDA     #$FF
          STA     PUMPNUM
          RTS

DISPPUMP  LDA     LASTMOVE
          ROR     A
          ROR     A
          BCS     NORTSOUT
          PHP
          LDA     PUMPNUM                SETUP PUMP XPOS
          ROR     A                      -FOR THE WIDE PUMP
          LDA     #$00
          ROL     A
          ASL     A
          STA     TEMP1
          PLP
          BMI     WEST
EAST      LDA     DDXPOS
          CLC
          ADC     TEMP1
          ADC     #$06
          STA     PUMPX
          LDA     DDYPOS
          STA     PUMPY
          LDA     PUMPNUM                SETUP THE INDEX FOR PUMP
          LSR     A
          TAY
          LDA     PRITES0,Y              -FROM PRITES# TABLES
          BNE     WESTA                  ;USE AS JMP
WEST      LDA     PUMPNUM                SETUP THE INDEX FOR PUMP
          LSR     A
          STA     TEMP2
          ASL     A
          ASL     A
          STA     TEMP3
          LDA     DDXPOS
          SEC
          SBC     TEMP1
          SBC     #$02
          SBC     TEMP3
          STA     PUMPX
          LDA     DDYPOS
          STA     PUMPY
          LDY     TEMP2
          LDA     PLEFTS0,Y              -FROM PRITES# TABLES
WESTA     STA     PUMPIX
          LDA     ZBLANK
          STA     PUMPIX+1
          LDA     ZBLANK
          STA     PUMPIX+2
          RTS
NORTSOUT  BPL     SOUTH
NORTH     LDA     PUMPNUM                SETUP THE INDEX FOR PUMP
          LSR     A
          STA     TEMP2

          LDY     TEMP2
          LDA     PUPS0,Y                -FROM PRITES# TABLES
          STA     PUMPIX
          LDA     PUPS1,Y
          STA     PUMPIX+1
          LDA     PUPS2,Y
          STA     PUMPIX+2

          LDA     PUMPNUM
          ASL     A
          CLC
          ADC     PUMPNUM
          ADC     DDYPOS
          ADC     #$03
          CMP     #192                   DECIMAL
          BCC     ZNXT166
          LDA     #191                   DECIMAL
ZNXT166   JMP     SUB4                   ;SUB4 IS A SUBR
SOUTH     LDA     PUMPNUM                SETUP PUMP XPOS
*         ROR     A                      -FOR THE WIDE PUMP
*         LDA     #$00
*         ROL     A
          AND     #$01                   ;WITH THANKS TO TOM CALDERWOOD
          STA     TEMP1
          CLC
          ADC     TEMP1
          ADC     TEMP1
          STA     TEMP1

          LDA     PUMPNUM                SETUP THE INDEX FOR PUMP
          LSR     A
          TAY
          LDA     PDOWNS0,Y                -FROM PRITES# TABLES
          STA     PUMPIX
          LDA     PDOWNS1,Y
          STA     PUMPIX+1
          LDA     PDOWNS2,Y
          STA     PUMPIX+2

          LDA     DDYPOS
          SEC
          SBC     TEMP1
          SBC     #$09

          LDY     PUMPIX
          CPY     #DPUMP6
          BNE     SOUTHA
*         CLC                            ; CARRY IS SET
          ADC     #6-1

SOUTHA    CMP     #23                    DECIMAL
          BCS     ZNXT156
          LDA     #23                    DECIMAL
ZNXT156   JMP     SUB4                   ;SUB4 IS A SUBR

PUMPCOLL  LDA     LASTMOVE
          ROR     A
          ROR     A
          BCS     PUPDOWN
          BMI     PLEFT
PRIGHT    LDA     PUMPNUM
          ASL     A
          CLC
          ADC     DDXPOS
          ADC     #$01                   IN CONNECTION WITH WIDTH OF COLL
          JMP     PLEFT2
PLEFT     LDA     PUMPX
          SEC
          SBC     #$05                   IN COLL
PLEFT2    STA     TEMP1
          LDA     PUMPY
          SEC
          SBC     #$04
          STA     TEMP2
          JMP     PCOLL
PUPDOWN   BPL     PDOWN
PUP       LDA     PUMPY
          JMP     PDOWN2
PDOWN     LDA     PUMPNUM
          ASL     A
          CLC
          ADC     PUMPNUM
          STA     TEMP1
          LDA     DDYPOS
          SEC
          SBC     TEMP1
          SEC
          SBC     #$09                   IN COLL
PDOWN2    STA     TEMP2
          LDA     PUMPX
          SEC
          SBC     #$05                   IN COLL
          STA     TEMP1
*         JMP     PCOLL
PCOLL     LDX     #$07
PREV39    LDA     MONSTAT,X
          BMI     ENDPCOLL
          ASL     A
          BMI     ENDPCOLL
          AND     #$0C
          CMP     #$04                   WHEN (NOT GBNF) & (BLOWUP)
          BEQ     ENDPCOLL
          LDA     XPOS,X
          SEC
          SBC     TEMP1
          BCC     ENDPCOLL
          CMP     #$06                   WIDTH OF PUMP COLLISION
          BCS     ENDPCOLL
          LDA     MONSTAT,X
          AND     #$02
          BEQ     PCOLL1
          LDA     BLWYPOS,X
          BNE     PCOLL2
PCOLL1    LDA     YPOS,X
PCOLL2    SEC
          SBC     TEMP2
          BCC     ENDPCOLL
          CMP     #$08                   HEIGHT OF PUMP COLLISION
          BCS     ENDPCOLL
          STX     PUMPIE
          CPX     FLAMIE
          BNE     ZNXT107
          JSR     FLAMOUT4               ;SETS FLAMEY+FLAMIE+MONSTAT,X TO 0
*         LDA     #0                     ;FOUND IN FLAMER
*         STA     FLAMEY
*         STA     FLAMIE
ZNXT107   LDA     #$07                   SET GBNF, BLOWUP AND FREEZE FLAGS
          STA     MONSTAT,X
          LDA     #$01
          STA     PUMPING
          RTS                            SO THAT ONLY ONE MONSTER IS AFFECTED
ENDPCOLL  DEX
          BPL     PREV39
          LDA     PUMPING
          RTS



GETMAXP   LDX     #$0E
          LDA     #$00
          STA     MAXPUMP
          LDA     DDXPOS
          STA     PUMPX
          LDA     DDYPOS
          STA     PUMPY
          JSR     GETDIRT
          LDX     #$02
          LDA     LASTMOVE
          ROR     A
          ROR     A
          BCS     PDNS
          BMI     PDW
PDE
          LDA     NOTGRID
          BNE     PDELOOP
          JSR     MOREPUMP
PDELOOP   INY
          JSR     LOOKDIRT
          AND     #$02
          BNE     ENDPDE
          JSR     MOREPUMP
          DEX
          BPL     PDELOOP
ENDPDE    LDA     DDXPOS
          AND     #$07
          BEQ     ENDPDE2
          SEC
          SBC     #1
          LSR     A
          EOR     #$03
ENDPDE2   BPL     SUB2                   ;SUB2 IS A SUBR
PDW       LDA     NOTGRID
          BEQ     PDW1
PDWLOOP   JSR     LOOKDIRT
          AND     #$08
          BNE     ENDPDW
PDW1      JSR     MOREPUMP
          DEY                            ;NOTE - Y GETS DECREMENTED ONE TOO
          DEX                            ; MANY TIMES BUT IT SHOULDN'T MATTER
          BPL     PDWLOOP
ENDPDW    LDA     DDXPOS
          AND     #$07
          LSR     A
          BPL     SUB2                   ;SUB2 IS A SUBR
PDNS      BPL     PDS
PDN
          LDA     NOTGRID
          BNE     PDNLOOP
          JSR     MOREPUMP
PDNLOOP   TYA
          SEC
          SBC     #$10
          TAY
          JSR     LOOKDIRT
          AND     #$01
          BNE     ENDPDN
          JSR     MOREPUMP
          DEX
          BPL     PDNLOOP
ENDPDN    JSR     SUB3                   ;0 1 2 3 4 5 6 7 8 9 A B -->--->
          TAY                            ;0 3 3 3 2 2 2 1 1 1 0 0
          BEQ     ENDPDN2
          SBC     #$0D
          EOR     #$FF
          TAY
ENDPDN2   LDA     DIV3TAB,Y
          BPL     SUB2                   ;SUB2 IS A SUBR
PDS       LDA     NOTGRID
          BEQ     PDS1
PDSLOOP   JSR     LOOKDIRT
          AND     #$04
          BNE     ENDPDS
PDS1      JSR     MOREPUMP
          TYA                            ;NOTE - Y GETS CHANGED ONE TOO MANY
          CLC                            ; TIMES BUT IT SHOULDN'T MATTER
          ADC     #$10
          TAY
          DEX
          BPL     PDSLOOP
ENDPDS    JSR     SUB3
          TAY
          LDA     DIV3TAB,Y
          BPL     SUB2                   ;SUB2 IS A SUBR

** MOVED TO ARRAYS:
*LOOKDIRT  LDA     DIRTMAP,Y
*         CMP     #CHARD12
*         BCS     ENDLOOK
*         CMP     #CHARDF
*         BCC     ZNXT120
*         LDA     #$01                   SKY CHARACTER
*         RTS
*ZNXT120   LSR     A
*         RTS
*ENDLOOK   LDA     #$0F
*         RTS
*MOREPUMP  LDA     MAXPUMP
*         CLC
*         ADC     #$04
*         STA     MAXPUMP
*         RTS




;-------- SUBROUTINES (AND JUMPS)

SUB2      CLC                            THIS IS A JUMP TO . . .
          ADC     MAXPUMP
          CMP     #$0C
          BCC     ENDDPDE
          LDA     #$0B
ENDDPDE   STA     MAXPUMP
          RTS

DISNEY    SEC
          SBC     #$0C
          BCC     DISNEY1
          CMP     #23
          BCS     DISNEY2
DISNEY1   LDA     #23
DISNEY2   RTS

SUB4      STA     PUMPY

          LDY     #DPUMP6
          CPY     PUMPIX+1
          BNE     SUB4A
          CLC
          ADC     #6

SUB4A     JSR     DISNEY
*         SEC
*         SBC     #$0C
*         BCC     ZNXT168
*         CMP     #23                    DECIMAL
*         BCS     ZNXT167
*ZNXT168   LDA     #23                    DECIMAL
*ZNXT167
          STA     PUMPY+1

          CPY     PUMPIX+2
          BNE     SUB4B
          CLC
          ADC     #6

SUB4B     JSR     DISNEY
*         SEC
*         SBC     #$0C
*         BCC     ZNXT169
*         CMP     #23                    DECIMAL
*         BCS     ZNXT170
*ZNXT169   LDA     #23                    DECIMAL
*ZNXT170
          STA     PUMPY+2
          LDA     DDXPOS
          CLC
          ADC     #$02
          STA     PUMPX
          STA     PUMPX+1
          STA     PUMPX+2
          RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                    ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;    BLOWUP:  CALLED FROM MAIN.                      ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;             INFLATES AND DEFLATES CREATURES.       ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;             POPS CREATURES,DISPLAYS POINTS.        ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;             UPDATES SCORE.                         ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                    ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


SETDEFL   EQU     $20                    ;RATE OF DEFLATION



BLOWUP    LDX     #NUMCREAT              ;FOR EACH CREATURE
BLWLOOP   STX     CURRBLW
          LDA     MONSTAT,X
          BMI     JNXTBLW
          LDY     BLWSTAT,X              ;FETCH BLOW UP STATE
*         LDA     MONSTAT,X
          AND     #$02                   ;BLOWN UP?
          BEQ     INFLAT
          CPY     #5                     ;SCORE STAGE?
          BNE     POP
          DEC     BLWCTR,X               ;DONE DISPLAYING POINTS?
          BNE     JNXTBLW
          JSR     OFFSCR2                ;FOUND IN MONSTER FILE
*         LDA     #$80
*         STA     MONSTAT,X              ;DISABLE CREATURE
*         LDA     #0
*         STA     POOKAY,X               ;DON'T DISPLAY ANYTHING
          JSR     GETMODE                ;CREATURES REDO STRATEGY
          JMP     NXTBLW

POP       CPY     #4                     ;POP STAGE?
          BNE     INFLAT
          DEC     BLWCTR,X               ;DONE DISPLAYING POP ANIMATION?
          BNE     JNXTBLW

          JSR     CAROL                  ;ADD IN POINTS

JNXTBLW   JMP     NXTBLW


INFLAT    LDA     PUMPING                ;INFLATING?
          BEQ     DEFLAT
          CPX     PUMPIE                 ;PUMPEE?
          BNE     DEFLAT
          LDA     BLWSTAT,X
          BNE     INFLAT2
          LDA     POOKAIX,X
          STA     PREBLWIX,X             ;SAVE STAMP
          LDA     POOKAY,X
          STA     BLWYPOS,X
*         CLC                            ; CARRY IS SET
          ADC     #4-1
          CMP     #192
          BCC     ADJUSTY
          LDA     #191
ADJUSTY   STA     POOKAY,X
INFLAT2   INC     BLWSTAT,X
          LDA     #SETDEFL               ;INIT DEFLATION CTR
          STA     BLWCTR,X
          JSR     PUFF                   ;CHANGE ANIMATIONS
          LDY     #SNG4                  ;PUMPING CREATURE NOISE
          JSR     NOISE
          LDA     BLWSTAT,X
          CMP     #4                     ;POPPING?
          BNE     JNXTBLW
          LDY     #SNG6                  ;POPPING CREATURE NOISE
          JSR     NOISE
          LDA     MONSTAT,X
          AND     #$FB
          STA     MONSTAT,X
          LDA     LASTMOVE
          STA     BLWLSTMV,X
          LDA     #30                    ;SET POP DISPLAY TIMER
          STA     BLWCTR,X
          BPL     UNLATCH

DEFLAT    LDA     MONSTAT,X              ;DEFLATING?
          AND     #$02
          BEQ     NXTBLW
          DEC     BLWCTR,X
          BNE     NXTBLW
          LDA     #SETDEFL
          STA     BLWCTR,X
          DEC     BLWSTAT,X
          BEQ     GOFREE
          JSR     PUFF
          JMP     NXTBLW
GOFREE    LDA     MONSTAT,X
          AND     #$F8                   ;CLR GBNF,BLOWUP, FREEZE BITS
          STA     MONSTAT,X
          LDA     PREBLWIX,X             ;RESTORE OLD STAMP
          STA     POOKAIX,X
          LDA     BLWYPOS,X
          STA     POOKAY,X               ;RESTORE X POSITION
          CPX     PUMPIE
          BNE     NXTBLW
UNLATCH   JSR     VANPUMP                ;FOUND IN COLLISON
;                                        ;USES A
;                                        ;CLEARS PUMPY ETC., SETS PUMPIE TO FF

NXTBLW    LDX     CURRBLW
          DEX
          BMI     BLWEND
          JMP     BLWLOOP


PUFF      LDY     BLWSTAT,X
          DEY
          STY     BLWTEMP
          LDA     FACING,X
          LSR     A
          LSR     A
          ASL     A
*         CLC
          ADC     BLWTEMP
          STA     BLWTEMP
          TXA
          AND     #$04
          ASL     A
*         CLC
          ADC     BLWTEMP
          TAY
          LDA     BLWSTMPS,Y
          STA     POOKAIX,X
BLWEND    RTS

CAROL     STX     CURRBLW                ;CALLED BY CHKDEATH AND POP
          LDY     #0                     ;CALC CREATURE'S DIRT LEVEL
          LDA     BLWYPOS,X              ;USE TRUE Y POSITION
*         SEC                            ; SET BY CPY WITH 4
          SBC     #$04                   ;REQUIRE 2/3 OVERLAP
FNDLEVEL  SEC
          SBC     #12
          BCC     GOTLEVEL
          INY
          BPL     FNDLEVEL
GOTLEVEL  TYA                            ;RANGE 0 - 14
          LSR     A                      ;FROM BOTTOM UP TUNNELS ARE
          LSR     A                      ;  GROUPED:  3,4,4,4 (INCLUDING SKY)
          TAY
          TXA
          AND     #$04                   ;FYGAR?
          BEQ     LOWPTS
          LSR     A
          AND     BLWLSTMV,X             ;DIGDUG PUMPING HORIZONTALLY?
          BNE     LOWPTS
          INY                            ;DOUBLE POINT VALUE
          INY
          INY
          INY
LOWPTS    LDA     BPOINTS,Y
          STA     POOKAIX,X              ;DISPLAY POINTS
          LDA     #8
          CMP     POOKAX,X
          BCC     LOWPTSA
          STA     POOKAX,X
LOWPTSA   LDA     BLWYPOS,X
          STA     POOKAY,X               ;RESTORE Y POSITION
          LDA     #1                     ;POINTS HAVE LOWEST PRIORITY
          STA     MONPRIOR,X             ;WILL BE RESET BY INCREATS NEXT RACK
          LDA     BURSTPTS,Y             ;LOW ORDER BYTE
          TAY
          LDA     #0
          JSR     ADDSCORE
          LDX     CURRBLW
          LDA     #30                    ;SET POINTS DISPLAY TIMER
          STA     BLWCTR,X
          INC     BLWSTAT,X              ;ADVANCE TO POINT DISPLAY STAGE
          RTS
********************************************************************************
***********                                                          ***********
***********       GENDPL:  THIS LOADS STAMPS INTO THE DISPLAY LISTS  ***********
***********                FOR EACH ZONE.  THE BACKGROUND HEADERS    ***********
***********                ARE CHANGED ONLY WHEN SWITCHING PLAYERS   ***********
***********                SO THERE IS NO NEED TO CHANGE THEM EACH   ***********
***********                TIME THE LOADER IS RUN.                   ***********
***********                                                          ***********
********************************************************************************
****
**** TIMING FOR THE LOADER IS AS FOLLOWS:
****
******************* THIS IS ALL INVALIDATED:  LOADER HAS BEEN ******************
*******************         CHANGED TO SAVE ROM!!!!!!!        ******************
****
****      BEST CASE:        47 ... INITIALIZE LISTSIZ.
****                         2 ... SET UP FOR STAMP LOADER.
****                      2464 ... FILL IN 16 STAMPS: NONE CROSS ZONES.
****                       351 ... ZEROS AT END OF EACH DISPLAY LIST.
****                         8 ... EOR DLSTPTR.
****                      ----
****                      2872 ... TOTAL BEST CASE CYCLES.
****
****
****      AVERAGE CASE:                          WORST CASE:
****      -------------                          ----------- 
****           49                                     49
****         3232 ... 8 CROSS ZONES, 8 DON'T.       4000 ... ALL CROSS ZONES.
****          359                                    359
****         ----                                   ____
****         3640 ... TOTAL AVERAGE CASE.           4408 ... TOTAL WORST CASE.
****
********************************************************************************


**** INITIALIZE INDEX INTO DISPLAY LIST FOR EACH ZONE TO 4: THIS WILL
****      POINT TO BYTE JUST FOLLOWING BACKGROUND HEADER.

GENDPL    LDA     #5                     ;THIS TAKES 32 BYTES AND 47 CYCLES.
          LDX     #15                    ;  DOING THIS IN A LOOP WOULD TAKE
FILLIST   STA     LISTSIZ,X              ;  9 BYTES AND 147 CYCLES.
          DEX                            ;NOTE THAT WE DIDN'T TOUCH LISTSIZ+0.
          BNE     FILLIST


**** NOW FOR EACH STAMP POSSIBLE ON SCREEN, SEE WHICH ZONE(S) THE STAMP APPEARS
****      IN AND PUT THE APPROPRIATE HEADER INTO THE ZONE'S DISPLAY LIST.
****      THE COORDINATE SYSTEM FOR THE POSITIONS OF THE STAMPS RUNS FROM 0
****      AT THE BOTTOM OF THE SCREEN TO 191 AT THE TOP, AND FROM 0 AT THE
****      LEFT TO 159 AT THE RIGHT.  THE TOP ZONE IS ZONE 15 (SKY), AND THE
****      BOTTOM ZONE IS ZONE 0 (SCORE / NUMBER OF EXTRA LIVES LINE).
****      BEST CASE TIMING FOR THIS LOOP IS 154 CYCLES PER STAMP, WORST CASE
***       250 CYCLES PER STAMP.

GENDPL2                                  ;(ENTRY POINT FOR TITLEPAG.)
          LDA     #1                     ;FIRST DO ALL STAMPS WITH STMPRIOR=1:
          STA     LISTPTR                ;  THESE HAVE LOWEST PRIORITY SO WILL
                                         ;  BE PUT IN DISPLAY LIST FIRST.
ZGEN2     LDA     #CSET2                 ;ALL STAMPS ARE IN CSET2 EXCEPT FOR
          STA     LISTPTR+1              ;  FRUIT, WHICH IS IN FIRST SLOT OF
                                         ;  STMPYPOS AND IN CSET1.
          LDY     #0
GETSTAMP
          STY     TEMPY
          LDA     STMPRIOR,Y             ;DOES THIS STAMP HAVE CORRECT PRIORITY
          CMP     LISTPTR                ;  FOR THIS PASS?
          BNE     NXTSTAMP
          LDA     STMPYPOS,Y             ;VERTICAL POSITION OF STAMP.
          BEQ     NXTSTAMP               ;IF ZERO, DON'T DISPLAY STAMP.
          STA     TEMPYPOS
          LSR     A                      ;FIND WHICH ZONE BY DIVIDING BY 12.
          LSR     A
          TAX
          LDA     DIV3TAB,X              ;ZONE NUMBER.
          TAX
          LDA     STMPXPOS,Y             ;SAVE HORIZONTAL POSITION.
          CLC                            ;CENTER STAMPS ON SCREEN.
          ADC     #16
          STA     HEADER3
          LDA     STMPINDX,Y             ;INDEX = LOW ADDRESS OF STAMP.
          STA     HEADER0
          LSR     A
          TAY
          LDA     TEMPY                  ;IS THIS FRUIT STAMP?
          CMP     #TOTLSTMP              ;IF SO, HEADER1 ALREADY SET UP.
          BEQ     OVERLAPS
          LDA     STMPPALW,Y             ;PALETTE/WIDTH BYTE FOR REGULAR STAMP.
          STA     HEADER1

OVERLAPS
          JSR     SETDPLH                ;GET ADDRESS OF DISPLAY LIST FOR ZONE.
          LDY     LISTSIZ,X              ;POINTER INTO DISPLAY LIST FOR ZONE.
          CPY     #LISTLENG              ;LIST FULL YET?
          BCS     NXTZLST
          LDA     HEADER0
          STA     (DPLOW),Y
          INY
          LDA     HEADER1                ;PALETTE/WIDTH FOR STAMP.
          STA     (DPLOW),Y
          INY
          LDA     LISTPTR+1              ;HIGH BYTE FOR STAMP ADDRESSES.
***       CLC                            ;(CARRY ALREADY CLEAR).
          ADC     TOPZONE,X
          SEC
          SBC     TEMPYPOS
          STA     (DPLOW),Y              ;VERTICAL POS. OF STAMP ADJUSTED FOR
          INY                            ;  POSITION IN ZONE.
          LDA     HEADER3
          STA     (DPLOW),Y              ;HORIZ. POSITION.
          INY
          STY     LISTSIZ,X
NXTZLST
          LDA     HEADER0
          CMP     #BIGSTAMP
          LDA     TEMPYPOS               ;SEE IF STAMP OVERLAPS INTO NEXT ZONE.
          BCC     ZNXTZLST
          CMP     TOPZONE,X
          BCC     ZNXTZ3
***       SEC
          SBC     #4
ZNXTZLST  CMP     TOPZONE,X
          BCS     NXTSTAMP
ZNXTZ3    DEX
          BNE     OVERLAPS

NXTSTAMP
          LDY     TEMPY
          INY
          CPY     #TOTLSTMP
          BCC     GOGETSTM
          BNE     TSTPRIOR
          LDA     FRUITCST               ;FRUIT STAMPS ARE IN CSET1, BUT THEIR
          STA     LISTPTR+1              ;  SCORES ARE IN CSET2.
          LDA     FRUITPAL               ;PALETTE WIDTH BYTE FOR ALL FRUITS.
          STA     HEADER1
GOGETSTM  JMP     GETSTAMP

TSTPRIOR  LDA     LISTPTR                ;HAVE WE MADE BOTH PRIORITY PASSES?
          BEQ     ZPUT0
          DEC     LISTPTR
          JMP     ZGEN2

**** NOW PUT A 0 IN THE WIDTH OF THE NEXT HEADER IN EACH ZONE.  THIS WILL
****      SIGNIFY THE END OF THE LIST FOR THAT ZONE.  THE FOLLOWING LOOP
****      COULD BE COMPACTED TO APPROXIMATELY 33 BYTES, BUT WOULD USE 627
****      CYCLES.  BY EXPANDING OUT TO THE LARGER LOOP, WE USE 60 BYTES BUT
****      ONLY 351 CYCLES.  THIS MAKES USE OF THE FACT THAT THERE ARE 4 DISPLAY
****      LISTS IN A PAGE, AND THE LOW BYTES OF ZONES 15,11,7,3, (OR 14,10,6,2,
****      ETC.) ARE IDENTICAL.  (SEE DEFINITION OF ZONE ADDRESSES IN DIGDEF).
****      BY EXPANDING THIS LOOP ALL THE WAY OUT, THE CYCLES COULD BE CUT TO
****      269, BUT THE BYTES WOULD GROW TO 160.

ZPUT0
          LDX     #NUMZONES
          JSR     PUTBLAKB               ;PUT A BLACK BOX IN ZONES 15 AND 14.
          STY     LISTSIZ+15
          LDX     #14
          JSR     PUTBLAKB
          STY     LISTSIZ+14

          LDX     #NUMZONES
PUTZERO   JSR     SETDPLH
          LDY     LISTSIZ,X
          INY
          LDA     #0
          STA     (DPLOW),Y
          DEX
          BNE     PUTZERO                ;DON'T TOUCH ZONE 0 (SCORE)!

DLFLIP
          LDA     DLSTPTR                ;NOW FLIP DLSTPTR SO KERNEL WILL USE
          EOR     #$40                   ;  THE ONE WE JUST CONSTRUCTED.
          STA     DLSTPTR
          JMP     SCRNON
*         LDX     ONSCREEN               ;WAIT TILL WE'RE OFF SCREEN.
*         BNE     DLFLIP
*         BEQ     GETDLST
*         INX
*GETDLST   LDA     LDPPL,X
*         STA     DPPL
*         LDA     #H(DPL0LIST)           ;SAME FOR EITHER DPLLIST.
*         STA     DPPH
*         RTS

PUTBLAKB  JSR     SETDPLH
          LDY     LISTSIZ,X              ;  HALF OF SCREEN.
          LDX     #3                     ;PUT BLACK BOX IN SKY TO BLOCK LEFT
ZPUTBLAK  LDA     BLAKBOX,X              ;  HALF OF SCREEN.
          STA     (DPLOW),Y
          INY
          DEX
          BPL     ZPUTBLAK
          RTS

* PALETTES FOR STAMPS...
*VEGPALW
*         DB      $3E,$3E,$3E,$3E,$3E,$3E                ;TEDDY AND VEGGIES...
*         DB      $3E,$3E,$3E,$3E,$3E,$3E

*STMPPALW  DB      $1E,$1E,$1E,$1E,$1E,$1E                ;R/L DIGDUG.
*         DB      $1E,$1E,$1E,$5E                        ;HDEATH1,2,3,ROCK.
*         DB      $3F,$3E,$3C,$3C,$3A,$3A,$3A            ;RFLAME 4(R,L),8,16,24.
*         DB      $3E,$3C,$3C,$3A,$3A,$3A                ;LFLAME 8,16,24.
*         DB      $3A,$3A,$3C,$3E                        ;LPUMP24,R24->4
*         DB      $3B,$3B,$3B,$3C,$3C,$3D,$3E,$3F        ;LPUMP20,16,12,8,4,OVR.
*         DS      10                                     ;(8 PIXEL NUMBERS...)
*         DB      $BE,$1E                                ;FULLSKY2,BLANK2.
*         DB      $3E                                    ;TEDDY2.
*         DB      $7E,$7E                                ;R,L FLAME FYGAR
*         DB      $5E,$5E                                ;R,L HARPOON.
*         DB      $1E,$1E,$1E,$1E,$1E                    ;FREE STAMPS!!!
*         DB      $5E,$5E                                ;U,D HARPOON.
*         DB      $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E        ;POOKA STAMPS.
*         DB      $3E,$3E,$3E,$3E
*         DB      $7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E        ;FYGAR STAMPS.
*         DB      $7E,$7E,$7E,$7E
*         DB      $3E,$3E,$1E,$1E                        ;POOKA,FYGAR GHOSTS.
*         DB      $1E,$1E,$1E,$1E,$1E,$1E                ;UP/DOWN DIGDUG.
*         DB      $1E,$7E,$3E                            ;SQUISH DD,FYGAR,POOKA.
*         DB      $1E,$1E,$1E,$1E,$5E,$5E,$5E            ;VDEATH1,2,3,S,ROCKS.
*         DB      $3F,$3F,$3F                            ;DPMP,DFULL,UPMP6,12
*         DB      $5E,$5E,$5E                            ;200,300,400
*         DB      $5E,$5E,$5E                            ;500,800,1000
*         DB      $5C,$5C,$5C,$5C,$5C,$5C,$5C,$5C        ;2500,4000,6000,8000
*         DB      $5C,$5C,$5C,$5C,$5C,$5C,$5E            ;10000,12000,15000,600
*         DB      $3F                                    ;UFULL6,12

* PALETTE/WIDTH BYTES FOR ZONE BACKGROUNDS...
*PALWIDZ   DB      $AF                    ;LIFE/SCORE LINE (BOTTOM)
*         DB      $EF,$EF,$EF            ;DIRT LAYER 3
*         DB      $CF,$CF,$CF,$CF        ;DIRT LAYER 2
*         DB      $AF,$AF,$AF,$AF        ;DIRT LAYER 1
*         DB      $8F,$8F,$8F            ;DIRT LAYER 0
*         DB      $AF                    ;SKY LINE

*******************************************************************************
***********                                                         ***********
***********       TITLEPAG:  DRIVER FOR TITLE PAGE ANIMATION.       ***********
***********                  CONTROL STAYS IN THIS ROUTINE UNTIL    ***********
***********                  TITLE PAGE HAS COMPLETED.  A NEW GAME  ***********
***********                  IS THEN INITIALIZED FOR ATTRACT MODE,  ***********
***********                  UNLESS THE PLAYER HAS PUSHED RESET,    ***********
***********                  SELECT, OR THE JOYSTICK BUTTON.        ***********
***********                                                         ***********
*******************************************************************************
ATITLEPA
TITLEPAG
          JSR     SCRNOFF

          JSR     SETTITLE               ;LOAD TITLEPAG LOGO INTO BOTH DISPLAY
          LDA     DLSTPTR                ;  LISTS.
          EOR     #$40
          STA     DLSTPTR
          JSR     SETTITLE

          LDX     #NUMCREAT
TITLALL   LDA     TITLCDIR,X
          STA     CDIREC,X
          LDA     TITLCBOR,X
          STA     CBORDER,X
          LDA     #0
          STA     MONSTAT,X
          DEX
          BPL     TITLALL
          STA     L0Z0+1                 ;SCORE LINE...
          STA     IGNORE
          STA     TITLETIM

          LDX     #TOTLSTMP
TITLINIT  LDA     TITLYPOS,X
          STA     STMPYPOS,X
          LDA     TITLXPOS,X
          STA     STMPXPOS,X
          DEX
          BPL     TITLINIT

          LDX     #17
          JSR     TITLCOLR
          STA     P0C0SHAD+22

*         JSR     SCRNON

*********** THIS IS THE MAIN LOOP FOR TITLE PAGE:  IT UPDATES THE ANIMATION
***********       FOR THE BALLOONING DIGDUG, MOVES CREATURES AROUND ON SCREEN,
***********       AND EVENTUALLY STARTS ROCK FALLING SO CREATURES WILL BE
***********       CRUSHED.
TLOOP
          LDA     FRMCNT
          PHA

          INC     P0C0SHAD+27
          LDX     #10
          JSR     SETDPLH

          LDA     #1                     ;MOVE CREATURES ON SCREEN.
          STA     TCTEMP
          LDA     TITLETIM               ;ONLY UPDATE EVERY OTHER CYCLE.
          LSR     A
          BCS     TCRTS
          LSR     A
          BCS     TCRTS
          AND     #7
          PHA
          DEC     TCTEMP
          LDX     #NUMCREAT
CMOVLOOP
          LDA     MONSTAT,X
          BMI     NXTCMOVE
*         AND     #$C0
*         BNE     NXTCMOVE
          INC     TCTEMP                 ;WE HAVE A CREATURE...
          LDA     CDIREC,X
          LSR     A
          BCS     CLIMBUP
          TAY                            ;CREATURE IS MOVING LEFT OR RIGHT.
          LDA     POOKAX,X
*         CLC
          ADC     CWALK,Y
          STA     POOKAX,X
          CMP     #150
          BCC     CSTILL
          DEC     TCTEMP
          JSR     OFFSCR2                ;SUBR FOUND IN MONSTER FILE
*         LDA     #$80                   ;IT RETURNS A 0
*         STA     MONSTAT,X
*         ASL     A
*         STA     POOKAY,X
          BEQ     NXTCMOVE
CSTILL    TYA
          LSR     A
          PLA
          PHA
          PHP
          CPX     #4
          BCC     HPOOKA
          ADC     #RFYGAR-RPOOKA-1       ;WE HAVE A FYGAR.
HPOOKA    TAY
          PLP
          BCC     ACRLEFT
          LDA     LPOOKA,Y               ; LDA DOESN'T AFFECT CARRY
          BCS     ACRINDX
ACRLEFT   LDA     RPOOKA,Y
ACRINDX   STA     POOKAIX,X
          LDA     POOKAX,X
          CMP     CBORDER,X
          BNE     NXTCMOVE
          BEQ     NDIREC

CLIMBUP   INC     POOKAY,X
          PLA
          PHA
          CPX     #4
          BCC     UPOOKA
          ADC     #RFYGAR-RPOOKA-1       ;WE HAVE AN UP FYGAR.
UPOOKA    TAY
          LDA     LPOOKA,Y
          STA     POOKAIX,X
          LDA     POOKAY,X               ;CREATURE MOVING UP.
          CMP     CBORDER,X
          BNE     NXTCMOVE
NDIREC    INC     CDIREC,X               ;MOVE TO NEW DIRECTION.
          LDY     CDIREC,X
          LDA     CTURNS,Y
          STA     CBORDER,X

NXTCMOVE  DEX
          BPL     CMOVLOOP
          PLA

TCRTS     LDA     TCTEMP                 ;IF 0 UPON RETURN FROM TCMOVE,
          BEQ     TITLEDON               ;  CREATURES ALL WALKED OFF SCREEN.

          PLA
TWAITFRM  CMP     FRMCNT
          BEQ     TWAITFRM

          LDX     #NUMZONES
TITLLIST  LDA     TLISTSIZ,X
          STA     LISTSIZ,X
          DEX
          BPL     TITLLIST
          JSR     GENDPL2

*********** READ THE JOYSTICK BUTTON, RESET, AND SELECT:  SINCE THIS IS
***********       PRECISELY WHAT CHKSTATE DOES EVERY TIME THROUGH PLAYGAME
***********       LOOP IN MAIN, JUST CALL IT HERE.  IF ANY OF THE BUTTONS
***********       ARE PRESSED, WE WILL LEAVE ATTRACT MODE (AND THUS TITLE PAGE).

          JSR     CHKSTATE
          LDA     ATTRACT
          BEQ     TITLEND
          JMP     TLOOP

*********** WE FINISHED ANIMATION BUT WE'RE STILL IN ATTRACT MODE:  SET UP
***********       NEW SAMPLE GAME FOR CONTINUATION OF ATTRACT MODE.

TITLEDON
ATITLEDO  PLA
          JSR     SETRACK1               ;RETURNS 1 IN A.
**        LDA     #1                     ;BONZO
          JSR     HSCINIT
          TXA
          BNE     TRYTEDDY
          LDX     #L(HSCRAM)
          LDY     #H(HSCRAM)
          JSR     HSCATRCT
          JSR     HSCDISPL               ;DISPLAY HIGH SCORE FOR 10 SECONDS.
TRYTEDDY  LDA     #0                     ;PINEAPPLE MODE
          JSR     HSCINIT
          TXA
          BNE     ATTNOHSC
***       LDX     #L(HSCRAM)             ;X CONTAINS 0 ALREADY...
          LDY     #H(HSCRAM)
          JSR     HSCATRCT
          JSR     HSCDISPL
HSCSTOP   LDX     #1
ATTNOHSC  JMP     NEWAGAME               ;NEWAGAME IS A SUBR

BORE      SEC                            ;ALSO USED BY DDMOVE
          SBC     #36
BORE1     LSR     A
          TAY
          LDA     (DRTPTR),Y
          STA     DIRTMAP,X
TITLEND   RTS


TEMPLATE
          DB      TITLED10,$DC,CSET1,28,TITLEI10,$DE,CSET1,44
          DB      TITLEG10,$DC,CSET1,52,TITLED10,$DC,CSET1,84
          DB      TITLEU10,$DC,CSET1,100,TITLEG10,$DC,CSET1,116
          DB      TDDUG10,$9C,CSET1,68
          DB      0,0
          DB      LETRL,$7E,CSET2,38,LETRE,$7E,CSET2,46,LETRV,$7E,CSET2,54
          DB      LETRE,$7E,CSET2,62,LETRL,$7E,CSET2,70,PINEAPPL,$BE,CSET1,104
          DB      0,0
          DB      LETRS,$7E,CSET1,86
          DB      LETRP,$7E,CSET2,38,LETRL,$7E,CSET2,46,LETRA,$7E,CSET1,54
          DB      LETRY,$7E,CSET1,62,LETRE,$7E,CSET2,70,LETRR,$7E,CSET1,78
          DB      FULL0+2,$7E,CSET1,104
          DB      0,0
          DB      LETRG,$7E,CSET1,44,LETRA,$7E,CSET1,52,LETRM,$7E,CSET1,60
          DB      LETRE,$7E,CSET2,68,LETRO,$7E,CSET2,84,LETRV,$7E,CSET2,92
          DB      LETRE,$7E,CSET2,100,LETRR,$7E,CSET1,108
          DB      0,0
          DB      TITLED9,$DC,CSET1,28,TITLEI9,$DE,CSET1,44
          DB      TITLEG9,$DC,CSET1,52,TITLED9,$DC,CSET1,84
          DB      TITLEU9,$DC,CSET1,100,TITLEG9,$DC,CSET1,116
          DB      TDDUG9,$9C,CSET1,68
          DB      0,0
          DB      ATARICP,$3A,CSET1,36,NAMCOCP,$3A,CSET1,95,0,0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                   ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;    SOUND                                          ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                   ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                   ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                   ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                   ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; SONGS
;________________LEN___C0__C1___________________________________________________
; 0                                                 NO SONG ACTIVE
;_______________________________________________________________________________
; 1    SNGC       24   04  00  0  1  3  0           CREATURE MOVEMENT
;_______________________________________________________________________________
; 2    SNGD       63   04  0D  1  2  2  2           SLOW DIGDUG
;_______________________________________________________________________________
; 3    SNGD       63   04  0D  1  1  2  2           FAST DIGDUG
;_______________________________________________________________________________
; 4    SNGNULL    08   00  00  0  7  0  0           THE SOUND OF SILENCE
;_______________________________________________________________________________
; 5    SNG1       08   01  01  1  1  3  3           ROCK CRUSHING MONSTER
;_______________________________________________________________________________
; 6    SNG2       08   0D  00  0  1  3  0           ROCK HITTING GROUND/DIGDUG
;_______________________________________________________________________________
; 7    SNG3       10   07  04  1  1  3  3           FLAME NOISE
;_______________________________________________________________________________
; 8    SNG5       09   04  00  0  2  3  0           DIGDUG THROWING HARPOON
;_______________________________________________________________________________
; 9    SNG4       24   04  00  0  0  0  0           PUMP CREATURE
;_______________________________________________________________________________
;10    SNG6       20   04  00  0  0  4  0           POP CREATURE
;_______________________________________________________________________________
;11    SNG7       08   00  00  0  2  7  0           ROCK FALLING
;_______________________________________________________________________________
;12    SNG8       05   04  0D  1  3  4  7           GOTCHA SOUND
;_______________________________________________________________________________
;13    SNG9       31   04  0D  1  3  4  3           CREATURE ESCAPING
;_______________________________________________________________________________
;14    SNG10      06   04  00  0  2  7  0           EAT VEGETABLE
;_______________________________________________________________________________
;15    SNG11      12   04  00  0  6  5  0           BONUS MAN
;_______________________________________________________________________________
;16    SNG12      23   0D  0D  1  3  3  3           SPEEDUP MUSIC
;_______________________________________________________________________________
;17    SNG13      21   04  0D  1  6  4  4           RACKEND
;_______________________________________________________________________________
;18    SNG14      16   0D  0D  1  3  0  0           DIGDUG DEATH
;_______________________________________________________________________________
;19    SNG15      63   04  0D  1  4  4  4           ENTRANCE
;_______________________________________________________________________________




NOISE     CPY     SNGTEMP1               ;REQUEST SOUND
          BCC     NOISE5
          STY     SNGTEMP1               ;HIGHEST PRIORITY OVERRIDES
NOISE5
*         RTS                            ;ASSUME RTS FOLLOWS DIRECTLY

GLVSOUND  RTS
DNEWSONG  JSR     SAVDUN                 ;SAVE CURRENT DD INFO (USES A AND Y)
GNEWSONG  JMP     NEWSONG
SOUND
*         LDA     ENTRY                  ;UPDATE SECOND TIMER
*         BNE     NOTSEC
          LDA     FRMCNT
          CMP     NXTSEC
          BNE     NOTSEC
*         CLC                            ;CARRY IS SET
          ADC     #60-1                  ;CHANGE FOR PAL/SECAM
          STA     NXTSEC
          INC     SCNDTIM
          LDA     SPEEDUP
          BEQ     NOTSECA
          DEC     SPEEDUP
NOTSECA   LDA     GHOSTOUT
          BEQ     NOTSEC
          DEC     GHOSTOUT
NOTSEC
          LDA     NONOISE                ;OK TO MAKE NOISE?
          BEQ     SOUND2
          LDA     #0                     ;IF NOT, SHUT OFF NOISE
          STA     AUDV0
          STA     AUDV1
          STA     CURSONG
          STA     SNGTEMP1
HLVSOUND  RTS
;
SOUND2    LDA     CURSONG                ;HIGHER PRIORITY SOUNDS OVERRIDE LOWER
          CMP     SNGTEMP1               ;SONGS DON'T INTERRUPT THEMSELVES
          BNE     SOUND2A
          CMP     #SNG1                  ;ROCK CRUSHING CREATURE? --- ALLOWED
          BEQ     SOUND2B                ;     TO OVERRIDE ITSELF (SPECIAL CASE)
          CMP     #SNG4                  ;INFLATING CREATURE? --- ALLOWED
          BEQ     SOUND2B                ;     TO OVERRIDE ITSELF (SPECIAL CASE)
          BNE     SOUNDOK
SOUND2A   BCS     SOUNDOK
SOUND2B   JSR     DIGSONG                ;CURRENT SONG IS DD MUSIC? (USES A)
          BNE     SOUND2C
          JSR     SAVDUN                 ;SAVE DIGDUG MUSIC INFO (USES A AND Y)
SOUND2C   LDA     SNGTEMP1               ;START NEW SONG
          STA     CURSONG
          LDY     #0
          STY     SNGTEMP1
          JSR     DIGSONG                ;CURRENT SONG IS NOT DD MUSIC? (USES A)
          BEQ     SNGCON
          JSR     INITALLS               ;SETS A TO 0, USES Y
          BMI     SOUNDOK
SNGCON    LDY     #6                     ;RESTORE DIGDUG MUSIC INFO
SNGCON2   LDA     DURINDX0,Y
          STA     CURINDX0,Y
          DEY
          BPL     SNGCON2

SOUNDOK   LDA     CURSONG
HNEWSONG  BEQ     GNEWSONG

          JSR     DIGSONG                ;DIGDUG MUSIC?  (USES A)
          BNE     SOUND1C
SOUND1A   LDA     WALKING
          BEQ     DNEWSONG
          LDA     DETHWISH
          ORA     DEATH
          BNE     DNEWSONG
SOUND1C

          DEC     DURCTR                 ;NOTE DONE?
          BPL     HLVSOUND
          LDX     CURSONG                ;CURRENT SONG
          LDA     SNGHBF0,X
          STA     SNGPTR+1
          DEC     CURINDX0               ;BYTE DONE?
          BPL     SETDUR
          BIT     REST0                  ;REST?
          BPL     NEWBYTF0
          LDA     #0
          STA     REST0
          STA     AUDV0
          STA     CURINDX0
          BPL     SETDUR
NEWBYTF0  INC     TUNINDX0               ;DECODE NEXT BYTE
          LDY     TUNINDX0
          TYA
          CMP     SNGLEN,X               ;CURRENT SONG DONE?
          BNE     NOTDONE
          TXA
          JSR     DIGSONG                ;DIGDUG MUSIC? (USES A)
          BNE     JNEWSONG
          JSR     INITDIGS
JNEWSONG  JMP     NEWSONG
NOTDONE   LDA     SNGLBF0,X
          STA     SNGPTR
          LDA     (SNGPTR),Y
          STA     REST0
          STA     AUDF0                  ;SET FREQUENCY 0
          AND     #$60
*         CLC
*         ROL     A
          ASL     A
          ROL     A
          ROL     A
          ROL     A
          STA     CURINDX0
          LDA     (SNGPTR),Y
          AND     #$1F                   ;FREQUENCY OF 0 MEANS VOLUME OF 0
          BEQ     SETVOL0
          LDA     SNGVV0,X               ;ABNORMAL CASE FOR VOLUME?
          AND     #$0F
          BNE     SETVOL0
          LDA     SNG4V0,Y
          CPX     #SNG4                  ; FOR NOW .....
          BEQ     SETVOL0
          LDA     SNG14V0,Y
SETVOL0   STA     AUDV0                  ;SET VOLUME 0
          LDA     SNGC0,X                ;ABNORMAL CASE FOR CONTROL?
          AND     #$0F
          BNE     SETCON0
          LDA     SNG7C0,Y
SETCON0   STA     AUDC0                  ;SET CONTROL 0
SETDUR    LDA     SNGDM,X                ;SET NOTE DURATION
          STA     DURCTR
;
; SECOND VOICE
          LDA     SNGLBF1,X              ;SECOND VOICE NEEDED
          BEQ     KILLVC2
          STA     SNGPTR
NEWNOTF1  DEC     CURINDX1               ;BYTE DONE?
          BPL     LVSOUND
          BIT     REST1                  ;REST?
          BPL     NEWBYTF1
          LDA     #0
          STA     REST1
          STA     CURINDX1
KILLVC2   STA     AUDV1
          RTS
NEWBYTF1  INC     TUNINDX1               ;DECODE NEXT BYTE
          LDY     TUNINDX1
          LDA     (SNGPTR),Y
          STA     REST1
          STA     AUDF1                  ;SET FREQUENCY 1
          AND     #$60
*         CLC
*         ROL     A
          ASL     A
          ROL     A
          ROL     A
          ROL     A
          STA     CURINDX1
          LDA     (SNGPTR),Y
          AND     #$1F                   ;FREQUENCY OF 0 MEANS VOLUME OF 0
          BEQ     SETVOL1
          LDA     SNGVV0,X               ;ABNORMAL CASE FOR VOLUME?
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          BNE     SETVOL1
          LDA     SNG14V1,Y
SETVOL1   STA     AUDV1                  ;SET VOLUME 1
          LDA     SNGC0,X
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          STA     AUDC1                  ;SET CONTROL 1
LVSOUND   RTS

NEWSONG
          LDA     #0
          STA     AUDV0
          STA     AUDV1
          STA     SNGTEMP1

          LDX     CURSONG
          STA     CURSONG
          CPX     #5                     ;SPACE SOUNDS
          BCS     SOUND14A
          LDA     DETHWISH
          ORA     DEATH
          ORA     SQUASH
          ORA     ENTRY
          BNE     SOUND14A
          LDA     WALKING
          BEQ     SOUND14
          LDA     FAST
          LDY     #SNGD
          ORA     ESCAPER
          BEQ     SOUND13A
          LDY     #SNGDF
SOUND13A  JMP     NOISE                  ;NOISE IS A SUBR
SOUND14   CPX     #SNGNULL               ;SOUND JUST ENDED IS SILENCE?
          BEQ     SOUND15
          CPX     #SNGC                  ;SOUND JUST ENDED IS CMOVEMENT?
          BEQ     SOUND15
SOUND14A  LDY     #SNGNULL               ;SOUND OF SILENCE
          BPL     SOUND13A
SOUND15   LDY     #SNGC                  ;START UP CRITTER MOVE NOISE
          BPL     SOUND13A


INITALLS  LDY     #4
          LDA     #0
INITSND   STA     CURINDX0,Y
          DEY
          BPL     INITSND
          STY     TUNINDX0
          STY     TUNINDX1
          RTS

COPYRGHT  DB      $47,$43,$43,$28,$43,$29,$31,$39,$38,$34

ENDSOUND
ENDE000
          ORG     $A000
ENDA000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;                                           ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;  ARRAYS:  PUT RANDOM ARRAYS HERE SO       ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;           THEY CAN BE OVERLAPPED TO       ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;           SAVE ROOM.                      ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;                                           ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;                                           ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;                                           ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;                                           ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

          ORG     $E0AA
*****  FROM FALL.S FILE
DISPTS    DB  THOUSND1,THOUS25,THOUS4,THOUS6
          DB  THOUS8,THOUS10,THOUS12,THOUS15


DOROCKL   DB      L(RSLIP),L(RTOTTER),L(RFALL),L(RBOTTOM)
          DB      L(RSPLIT),L(RCRUMBL),L(RPOINTS),L(RFINISH)

DOROCKH   DB      H(RSLIP),H(RTOTTER),H(RFALL),H(RBOTTOM)
          DB      H(RSPLIT),H(RCRUMBL),H(RPOINTS),H(RFINISH)

RKANIM    DB      SPLTROCK,CRMBROCK


;  DON'T USE THIS SUBR UNTIL SURE DIGDUG IS GOING TO ANIMATE.
;  USES X,A.
;  USES TEMP.
ANIM      LDA     ANIMCNT                ;THERE ARE THREE STAMPS EACH DIRECTION
          SEC
          SBC     #1
          BPL     ANIM2
          LDA     #2
ANIM2     STA     ANIMCNT
          ASL     A
          ASL     A
          STY     TEMP
*         CLC
          ADC     TEMP
          TAX
          LDA     DANIMS,X
          STA     DDINDX
          RTS

*****  FROM DDMOVE.S FILE
XFROMPL   DB      $00                         ;      ,$08,$00,$00

XTOPL     DB      $08,$00,$00,$00,$08,$F8,$00,$00,$03,$FD,$00,$00
          DB      $10,$F8,$00,$00
          DB      $07,$F9,$00                 ;      ,$00

; NOTE:  FLATPTS IS STORED AS HALF OF TRUE POINT VALUE
FLATPTS   DB      $00,$05,$50,$12,$00,$20,$00,$30
          DB      $00,$40,$00,$50,$00,$60,$00,$75

***** PAGE 83 BYTES FULL
ENDE0AA


          ORG     $E1AA
CTURNS    DB      124,47,4,71,255

HALFXFM   DB      L(EAST5),L(WEST5),L(SOUTH7),L(NORTH7)
FROMXFM   DB      L(HORLFT),L(HORRGT),L(VERTTOP),L(VERTBOT)
TOXFM     DB      L(HORRGT),L(HORLFT),L(VERTBOT),L(VERTTOP)
ENTRXFM   DB      L(EAST1),L(WEST1),L(SOUTH1),L(NORTH1)

HARPSTMP  DB      RHARPOON,LHARPOON,DHARPOON,UHARPOON

DANIMS    DB      RDIGDUG1,LDIGDUG1,DDIGDUG1,UDIGDUG1
          DB      RDIGDUG2,LDIGDUG2,DDIGDUG2,UDIGDUG2
          DB      RDIGDUG3,LDIGDUG3,DDIGDUG3,UDIGDUG3


VONE      DB      01,07,10               ;   ,00
VBOUND    DB      00,00,11,11
VHALF     DB      05,03,04               ;   ,06
VPRE2     DB      06,02,01,09            ;MIGHT BE UNNECESSARY FOR HORIZONTAL
VPRE1     DB      07,01,00,10

WHNSPEED  DB      2,3,4,5                ;   ,6

VPRE3     DB      06,02,02,08            ;UNNECESSARY FOR HORIZONTAL
*VPRE4     DB      06,02,03,07            ;PROBABLY NOT NECESSARY

*****
; USES A,X.
ADJUSTTO  LDA     DDYPOS                 ;CALC DIGDUG LEADING EDGE
          CLC
          ADC     YTOPL,Y
          TAX
          LDA     DDXPOS
          CLC
          ADC     XTOPL,Y
          RTS                            ;14

MOREPUMP  LDA     MAXPUMP
          CLC
          ADC     #$04
          STA     MAXPUMP
          RTS

***** PAGE 86 BYTES FULL
ENDE1AA


          ORG     $E2AA

JOYSWCH   DB      $7F,$BF,$DF,$EF

BAR       DB      $20,$40                ; S,W      BOUND TO NEXT PAGE!!!
          DB      $10,$90                ; N,NE     BOUND TO PREVIOUS PAGE!!!
          DB      $30,$C0                ; FILTER OUT ILLEGAL COMBINATIONS

FOO
          DB      $7F                    ; E
FJOY      DB      $DF,$BF,$EF,$7F        ; S,W,N,E
          DB      $FF,$FF                ; END OF FOO
REVSWCH
          DB      $BF,$7F,$EF,$DF
*         DB      $BF,$7F,$EF,$DF
*         DB      $BF


DIGSONG   CMP     #SNGD                  ;RETURNS EQ IF DIGDUG MUSIC
          BEQ     DIGSONG2
          CMP     #SNGDF
DIGSONG2
          RTS                            ;OVERLAPPED WITH FOLLOWING ARRAY!!!

*ATTBOUND  DB      $60,$28,$20,$2F,$50    ;OVERLAPPED WITH PRECEDING SUBR!!!
*         DB      $10,$28,$8F,$83
*         DB      $10                    ;OVERLAPPED WITH FOLLOWING ARRAY!!!

RKTIM     DB      $10,$10,$1E            ;FROM FALL.S, OVERLAPPED!

; NOTE:  ONLY TOP BYTE IS STORED SINCE BOTTOM BYTE IS ALWAYS 0
;        INDEX OF 0 IS FOR TEDDYBEAR MODE
VEGPTS    DB      $02,$04,$06,$08,$10,$10
          DB      $20,$20,$30,$30,$40,$40
          DB      $50,$50,$60,$60,$70,$70
          DB      $80

FPOINTS   DB      VHUND2,VHUND4,VHUND6,VHUND8,VTHOUS1,VTHOUS1
          DB      VTHOUS2,VTHOUS2,VTHOUS3,VTHOUS3,VTHOUS4,VTHOUS4
          DB      VTHOUS5,VTHOUS5,VTHOUS6,VTHOUS6,VTHOUS7,VTHOUS7
          DB      VTHOUS8


HCARVE    LDA     #DLEFTEND
          STA     DIRTMAP,X              ;CARVE OUT CENTER HORIZONTAL TUNNEL.
          LDA     #DHMIDDLE
          STA     DIRTMAP+1,X
          LDA     #DRHTEND
          STA     DIRTMAP+2,X
          RTS

***** PAGE 86 BYTES FULL
ENDE2AA


          ORG     $E3AA
*****  FROM MONSTER.S FILE
;-------- ROM TABLES

XTABLE    DC      $00,$00,$FF,$FF,$00,$00,$FF,$FF
          DC      $01,$01,$00,$00,$01,$01,$00          ;     ,$00

YTABLE    DC      $00,$FF,$00,$FF,$01,$00,$01,$00
          DC      $00,$FF,$00,$FF,$01,$00,$01,$00

SPEEDTAB  DC      $EE                    POOKA SLOW     12 BITS
          DC      $EE
          DC      $92                    POOKA GHOST    5 BITS
          DC      $48
          DC      $7F                    POOKA FAST     15 BITS
          DC      $FF
          DC      $95                    POOKA GHOST    7
          DC      $4A
          DC      $F7                    FYGAR SLOW     13 BITS
          DC      $77
          DC      $89                    FYGAR GHOST    5
          DC      $24
          DC      $FF                    FYGAR FAST     16 BITS
          DC      $FF
          DC      $A9                    FYGAR GHOST    7
          DC      $54

* FJOY: FAKE JOYSTICK MOVEMENTS FOR ROTATING SELECT OPTIONS WITH SELECT BUTTON.
*FJOY      DB      $BF,$7F,$DF,$EF       ;USES REVSWCH INSTEAD.


RFALLTBL  DB      1,2,2,2,1,2,2

ANDF0     AND     #$F0
          BNE     NOTZERO1
          BCC     NOTZERO1
          LDA     #BLANK1                ;BLANK STAMP.
*         BEQ     ANDF0RTS
          RTS
NOTZERO1  LSR     A                      ;GET INDEX INTO STAMP TABLE FOR THIS
          LSR     A                      ;  DIGIT OF SCORE.
          LSR     A
*         CLC
          ADC     #FULL0
ANDF0RTS  RTS


INITDIGS  LDY     #4
          LDA     #0
INITSNDD  STA     DURINDX0,Y             ;TIME TO START DD MUSIC OVER
          DEY
          BPL     INITSNDD
          STY     DUNINDX0
          STY     DUNINDX1
          RTS

ENDE3AA


          ORG     $E4AA
FRUITAB   DC      TEDDY
          DC      CARROT,RUTABAGA,MUSHROOM,CUCUMBER,CUCUMBER
          DC      EGGPLANT,EGGPLANT,BELLPEPP,BELLPEPP,TOMATO
          DC      TOMATO,ONION,ONION,WATERMEL,WATERMEL,GALAXIAN
          DC      GALAXIAN,PINEAPPL      ;BETTY AND AVA-ROBIN WERE HERE!


DIRTABLE  DB      L(DIRT0),L(DIRT1),L(DIRT2),L(DIRT3),L(DIRT4),L(DIRT5)
          DB      L(DIRT6),L(DIRT7),L(DIRT8),L(DIRT9),L(DIRT10),L(DIRT11)
          DB      L(DIRT12),L(DIRT13),L(DIRT14),L(SKY15)

MODETAB   DB      L(DIGDIAG),L(DIGVERT),L(DIGHORIZ)
          DB      L(DIGVERT),L(DIGHORIZ),L(DIGDIAG)
          DB      L(DIGVERT),L(DIGHORIZ)


PRITES0   DB      RPUMP4,RPUMP8,RPUMP12,RPUMP16,RPUMP20,RPUMP24
;                                        ;FROM COLLISON.S

DDMIDDLE
          LDA     #DDMIDLY
          STA     DDYPOS
          LDA     #DDMIDLX
          STA     DDXPOS
          LDA     #RDIGDUG1
          STA     DDINDX
          RTS

********************************************************************************
***********                                                          ***********
***********       GETRXY: TURN DIRTMAP INDEX INTO X AND Y COORDINATE.***********
***********               RETURNS X IN A, Y IN X.                    ***********
********************************************************************************
GETRXY
          PHP
          PHA                            ;SAVE INDEX.
          LSR     A                      ;Y IN TOP NIBBLE.
          LSR     A
          LSR     A
          LSR     A
          EOR     #$FF
          CLC
          ADC     #16
          TAX
          LDA     TOPZONE,X
          TAX
          PLA
          AND     #$0F
          ASL     A                      ;MULTIPLY BOTTOM NIBBLE BY 8 FOR X.
          ASL     A
          ASL     A
          PLP
          RTS

ENDE4AA


          ORG     $E5AA
*****  FROM COLLISON.S FILE

*** PUMP TABLES: ARRANGED BY DIRECTION, THEN STAMP NUMBER.  STAMP 0 SHOULD
***              BE LOCATED AT X,Y POSITION OF UPPER LEFTMOST CORNER OF
***              PUMP.  STAMP 1 WILL BE AT X,(Y-12), AND STAMP 2 AT X,(Y-24).
***              READING ACROSS EACH VERTICAL TABLE GIVES THE APPROPRIATE STAMP
***              FOR PUMP LENGTHS 6,12,18,24,30,36; AND WIDTHS 4,8,12,16,20,24
***              FOR HORIZONTAL TABLES.  HORIZONTAL TABLES DO NOT EXIST FOR
***              STAMPS 1 AND 2 AS A HORIZONTAL PUMP IS ONLY ONE STAMP HIGH.
***              INSTEAD, ZBLANK WILL BE LOADED INTO APPROPRIATE STMPYPOS ENTRY.

PDOWNS2   DB      ZBLANK,ZBLANK          ; ,ZBLANK,ZBLANK,DPUMP6,DPUMP12
PDOWNS1   DB      ZBLANK,ZBLANK          ; ,DPUMP6,DPUMP12,DFULL6,DFULL12
PDOWNS0   DB      DPUMP6,DPUMP12,DFULL6,DFULL12,DFULL6,DFULL12

PUPS0     DB      UPUMP6,UPUMP12,UPUMP12,UPUMP12,UPUMP12,UPUMP12
PUPS2     DB      ZBLANK,ZBLANK          ; ,ZBLANK,ZBLANK,UFULL6,UFULL12
PUPS1     DB      ZBLANK,ZBLANK,UFULL6,UFULL12,UFULL12,UFULL12

PLEFTS0   DB      LPUMP4,LPUMP8,LPUMP12,LPUMP16,LPUMP20,LPUMP24




BURSTPTS  DB      $05,$04,$03,$02
          DB      $10,$08,$06,$04

BPOINTS   DB      HUNDRED5,HUNDRED4,HUNDRED3,HUNDRED2
          DB      THOUSND1,HUNDRED8,HUNDRED6,HUNDRED4

BLWSTMPS  DB      LBPOOKA1,LBPOOKA2,LBPOOKA3,LBPOOKA4
          DB      RBPOOKA1,RBPOOKA2,RBPOOKA3,RBPOOKA4
          DB      LBFYGAR1,LBFYGAR2,LBFYGAR3,LBFYGAR4
          DB      RBFYGAR1,RBFYGAR2,RBFYGAR3,RBFYGAR4

SETPAL3   LDX     #2
PHAMSGC   LDA     #$84                   ;USE PALETTE 3 FOR COLORS OF LETTERS.
          STA     P0C0SHAD+13,X
          DEX
          BPL     PHAMSGC
          RTS

SAVDUN    LDY     #6                     ;SAVES CURRENT DIGDUG MUSIC INFO
SAVDUN2   LDA     CURINDX0,Y
          STA     DURINDX0,Y
          DEY
          BPL     SAVDUN2
          RTS
ENDE5AA


          ORG     $E6AA
***** FROM IGAMERAK.S
* HEADERS FOR INITIAL SCORE LINE STAMPS: 4 EXTRA MEN PER PLAYER, PLAYER POINTER.
ISCORLIN  DB      L(SCOREMAP),W1ZONE,H(SCOREMAP),$B0,16
          DB      BLANK1,$3E,CSET1,24,BLANK1,$3E,CSET1,32,BLANK1,$3E,CSET1,40
          DB      BLANK1,$3E,CSET1,48,BLANK1,$3E,CSET1,56,FULL0,$3E,CSET1,64
          DB      BLANK1,$3E,CSET1,88,BLANK1,$3E,CSET1,96,BLANK1,$3E,CSET1,104
          DB      BLANK1,$3E,CSET1,112,BLANK1,$3E,CSET1,120,BLANK1,$3E,CSET1,128
          DB      BLANK1,$9E,CSET1,76
          DB      0,0


PUTTITLE  PHA
          JSR     SETDPLH
          PLA
          TAX
***       JMP     PUTMPLAT
***       RTS
PUTMPLAT  LDA     TEMPLATE,X
          STA     (DPLOW),Y
          DEX
          DEY
          CPY     #5
          BCS     PUTMPLAT
          RTS


WAITVBL   BIT     CTRLRD
          BPL     WAITVBL
          BIT     CTRLRD
          BPL     WAITVBL
          RTS

*AREVSWCH  DB      $40,$80,$10,$20        ;USED IN DDMOVE
ENDE6AA


          ORG     $E7AA
*DISPLAY LIST LISTS DLI BYTES: FIRST BYTE IS FOR ZONE 1 AT BOTTOM OF SCREEN,
*         LAST BYTE FOR DUMMY ZONE AT TOP OF SCREEN
DLIBITS   DB      $4B,$4B,$4B,$4B,$4B,$CB,$4B,$4B,$4B,$CB,$4B,$4B,$4B,$CB
          DB      $CB,$4B,$4F,$47,$CC,$4B,$4B

* LOW ADDRESSES FOR CHARACTER MAPS FOR EACH ZONE...
MAPLOW    DB      $EF,$E0,$D0,$C0,$B0,$A0,$90,$80,$70,$60,$50,$40,$30,$20,$10
;         DB      0
* INITIAL PALETTE COLORS...              ;OVERLAPS WITH ABOVE (BLACK = 0)
IPALETTE  DB      BLACK,DDBLUE,WHITE,BLACK
          DB      $34,$1A,$0E            ;RED,YELLOW,WHITE
          DB      $30,$00,$44            ;BROWN,BLACK,TAN
          DB      $D6,$24,$0E            ;GREEN, ORANGE, WHITE
          DB      YELLOW,DDBLUE,$A0      ;NUMLIVES IN COL 3.
          DB      SKYBLUE,SKYBLUE,PL1COLR ;SCORE,VEGGIE
          DB      YELLOW,DDBLUE,PEBBLE1  ;DIRT0, DIRT2
          DB      $D4,SKYBLUE,$34        ;SKY,DIRT1,DIRT3

***** FROM INITDIRT.S
CRYOFST   DB      0,12,24,12,0,12,24,12



TITLCBOR  DB      124,47,4,255,124,4,255,255

SEQTAB    DC      L(GPOOKA),L(LPOOKA),L(GFYGAR),L(LFYGAR)
          DC      L(RPOOKA),L(GPOOKA),L(RFYGAR),L(GFYGAR)
***** PAGE 86 BYTES FULL
ENDE7AA


          ORG     $E8AA
* COLORS FOR VEGGIES ARE ARRANGED AS FOLLOWS:
*         CARROT,RUTABAGA,MUSHROOM,CUCUMBER,CUCUMBER,EGGPLANT,EGGPLANT,BELLPEPP
*         BELLPEPP,TOMATO,TOMATO,ONION,ONION,WATERMELON,WATERMELON,GALAXIAN
*         GALAXIAN,PINEAPPLE,TEDDYBEAR

VEGCOL1   DB      $D2,$1E,$3F,$F4,$F4,$50,$50,$D4
          DB      $D4,$32,$32,$26,$26,$34,$34,$74
          DB      $74,$D2,$16
VEGCOL2   DB      $34,$D6,$22,$D6,$D6,$52,$52,$3A
          DB      $3A,$D2,$D2,$1E,$1E,$D8,$D8,$1A
          DB      $1A,$1A,$1A
VEGCOL3   DB      $38,$EE,$04,$FC,$FC,$58,$58,$E8
          DB      $E8,$36,$36,$16,$16,$1A,$1A,$54
          DB      $54,$24,$14

TUNLDIR
          DB      $30,$08,$18,$18,$1C,$04,$06,$0E
          DB      $03,$0F,$0F,$01,$03,$07,$0F
          DB      $40,$80                ;BONZO LEVELS 0,1.

RESPAL3   LDY     #2                     ;RESTORE PALETTE 3: USE Y IN LOOP SO
PLAMSGC   LDA     IPALETTE+10,Y          ;  X RETURNED FROM FREEZFRM WON'T
          STA     P0C0SHAD+13,Y          ;  BE CLOBBERED.
          DEY
          BPL     PLAMSGC
          RTS
***** PAGE 86 BYTES FULL
ENDE8AA


          ORG     $E9AA
CRXOFST   DB      8,16,8,0,8,16,8       ;    ,0


ASNGHBF0
; SNGHBF0 IS INDEXED BY SONG NUMBER.
; IT CONTAINS THE HIGH BYTE FOR FREQUENCY OF FIRST VOICE.
;  20 BYTES
SNGHBF0   DB      $00,H(SNGCF0),H(SNGDF0),H(SNGDF0),H(SNGNULLF)
          DB      H(SNG1F0),H(SNG2F0),H(SNG3F0)
          DB      H(SNG5F0),H(SNG4F0),H(SNG6F0),H(SNG7F0)
          DB      H(SNG8F0),H(SNG9F0),H(SNG10F0),H(SNG11F0)
          DB      H(SNG12F0),H(SNG13F0),H(SNG14F0),H(SNG15F0)

PEBBCOLR  DB      PEBBLE0A,PEBBLE0B,PEBBLE0C,PEBBLE0D
          DB      PEBBLE1A,PEBBLE1B,PEBBLE1C,PEBBLE1D
          DB      PEBBLE2A,PEBBLE2B,PEBBLE2C,PEBBLE2D

CREATS
          DB      $47,$63,$A3,$4B,$65,$3C,$A9,$A3
          DB      $3C,$63,$47,$4E,$3C,$3A,$33
          DB      $87,$78                ;BONZO LEVELS 0,1.

RANDCRET  DB      $AA,$E1,$55,$0F,$8D,$69,$2D,$96


***** FROM SELECT.S

***** FROM CHKDEATH.S
*HSCARGS   DB      LCARTNUM,HCARTNUM,0,1,L(GAMENAME),H(GAMENAME)
HSCARGS   DB      LCARTNUM,HCARTNUM,0,1,0,0
*         DB      L(BONZDIFF),H(BONZDIFF),L(HSCOREX),H(HSCOREX)
          DB      0,0,L(HSCOREX),H(HSCOREX)
*         DB      L(LOGODLL),H(LOGODLL),L(SOUND),H(SOUND),0
          DB      L(LOGODLL),H(LOGODLL),L(HSCRTS),H(HSCRTS),10

SETRACK1  LDA     #1
          STA     RACKNUM
          STA     RACKNUM+1
          RTS
***** 86 BYTES FULL
ENDE9AA


          ORG     $EAAA


***** FROM GENDPL.S
*DISPLAY LIST POINTERS FOR TWO DISPLAY LISTS.
LDPPL     DB      L(DPL0LIST),L(DPL1LIST)

* ZONE SCAN LINE BOUNDARIES....
TOPZONE   DB      11,23,35,47,59,71,83,95,107,119,131,143,155,167,179,191,191


***** FROM TITLEPAG.S
TLISTSIZ  DB      5,5,5,5,5,5,5,5,5,13,5,5,33,33,5
;         DB      5                      ;OVERLAPS
NUMBYTES  DB      5,1,1,0,0,1,2,0        ;OVERLAPS
          DB      1,4,0,0,2,1,0,0
          DB      0,7,0,7,0,6,1,3
          DB      3,1,8,0,0,2,2,5
          DB      15,8,7,0,2,3,3,2
;         DB      0                      ;OVERLAPS
* BLACK BOX HEADER...                    ;OVERLAPS
BLAKBOX   DB      0,CSET1,$1A,BLACKBOX

LFLAMSEQ  DC      LFLAME4                LEFT FLAME SMALL
          DC      LFLAME8                LEFT FLAME 8 PIX
          DC      LFLAME16               LEFT FLAME 16 PIX
          DC      LFLAME24               LEFT FLAME 24 PIX (MAXIMUM)
RFLAMSEQ  DC      RFLAME4                RIGHT FLAME SMALL
          DC      RFLAME8                RIGHT FLAME 8 PIX
          DC      RFLAME16               RIGHT FLAME 16 PIX
          DC      RFLAME24               RIGHT FLAME 24 PIX (MAXIMUM)

ENDEAAA


          ORG     $EBAA
* LOW AND HIGH ADDRESSES OF DISPLAY LISTS FOR EACH ZONE.
LISTTABL  DB      L(L0Z0),L(L0Z1),L(L0Z2),L(L0Z3),L(L0Z4),L(L0Z5),L(L0Z6)
          DB      L(L0Z7),L(L0Z8),L(L0Z9),L(L0Z10),L(L0Z11),L(L0Z12)
          DB      L(L0Z13),L(L0Z14),L(L0Z15),L(L0Z0),L(DUMMYDPL),L(DUMMYDPL)
          DB      L(DUMMYDPL),L(DUMMYDPL),L(DUMMYDPL)
LISTTBH0  DB      H(L0Z0),H(L0Z1),H(L0Z2),H(L0Z3),H(L0Z4),H(L0Z5),H(L0Z6)
          DB      H(L0Z7),H(L0Z8),H(L0Z9),H(L0Z10),H(L0Z11),H(L0Z12)
          DB      H(L0Z13),H(L0Z14),H(L0Z15),H(L0Z0),H(DUMMYDPL),H(DUMMYDPL)
          DB      H(DUMMYDPL),H(DUMMYDPL),H(DUMMYDPL)
LISTTBH1  DB      H(L0Z0),H(L1Z1),H(L1Z2),H(L1Z3),H(L1Z4),H(L1Z5),H(L1Z6)
          DB      H(L1Z7),H(L1Z8),H(L1Z9),H(L1Z10),H(L1Z11),H(L1Z12)
          DB      H(L1Z13),H(L1Z14),H(L1Z15),H(L0Z0),H(DUMMYDPL),H(DUMMYDPL)
          DB      H(DUMMYDPL),H(DUMMYDPL),H(DUMMYDPL)


BACKMAP
          LDX     #NUMZONES              ;SET UP DISPLAY LIST FOR TITLE PAGE.
SETTBACK  JSR     SETDPLH
          LDY     #0                     ;ZERO OUT DIRT BACKGROUND BY SETTING
          LDA     #$F0                   ;  CHAR MAP TO POINT TO ZEROS.
          STA     (DPLOW),Y
          TYA
          LDY     #6
          STA     (DPLOW),Y
          DEX
          BNE     SETTBACK
          RTS
*****   86 BYTES FULL
ENDEBAA


          ORG     $C000
RANDROKS  DB      $29,$35,$64,$82,$8D,$9A,$A5,$C9

PALWBYTE  DB      $1E,$7E,$5E,$3F,$3E,$3C,$3A,$3E
          DB      $3C,$3A,$3C,$3E,$3B,$3C,$3D,$3E
          DB      $3F,$1C,$5E,$1D,$3F,$1E,$5E,$3E
          DB      $7E,$3E,$1E,$7E,$3E,$5E,$3F,$1D
          DB      $1C,$3E,$7E,$B0,$F0,$D0,$F0,$D0
          DB      $F0

DANIMIX   DB      4,9,9,4

CWALK     DB      1,$FF,1
MESGOFST  DB      89,123
MESGDPLY  DB      34
;         DB      38

; SNGLEN IS INDEXED BY SONG NUMBER.
; IT CONTAINS THE SONG LENGTH.
;  20 BYTES
ASNGLEN
SNGLEN    DB      38,16,26,26,1,8,8,5,9,15,20,8,5,14,6,7,12,15,14  ;,22



; SNGDM  IS INDEXED BY SONG NUMBER.
; IT CONTAINS THE DURATION. DURATION FOR 2 VOICE SONGS IS SAME BOTH VOICES.
;  20 BYTES
ASNGDM
SNGDM     DB      22,1,2,1,7,1,1,1,2,0,0,2,3,3,2,6,3,6,3,4


*****  FULL
ENDC000


          ORG     $C100
ROCKS     DB      $35,$B4,$9B,$00,$00
          DB      $23,$39,$8D,$B5,$00
          DB      $23,$6C,$BD,$94,$00
          DB      $43,$2B,$5C,$BD,$84
          DB      $63,$29,$3D,$BB,$A6
          DB      $28,$6B,$97,$B3,$00
          DB      $29,$52,$6D,$AC,$00
          DB      $54,$6D,$96,$B8,$00
          DB      $28,$3C,$7A,$72,$B6
          DB      $34,$72,$8C,$B8,$00
          DB      $33,$3B,$BC,$A6,$00
          DB      $39,$7B,$82,$CA,$00
          DB      $32,$29,$BA,$A3,$00
          DB      $32,$4B,$B9,$83,$00
          DB      $52,$39,$9A,$B4,$00
          DB      $53,$9B,$00,$00,$00    ;BONZO LEVEL 0
          DB      $3B,$00,$00,$00,$00    ;BONZO LEVEL 1

* ADEATH: STAMP INDICES FOR DEATH ANIMATION.
ADEATH    DB      ZBLANK,SDEATH,HRDEATH3,HRDEATH2,HRDEATH1
          DB      ZBLANK,SDEATH,HLDEATH3,HLDEATH2,HLDEATH1


          ORG     $C15F
GENEJMP   DB      $4C,L(DLIJMP),H(DLIJMP)
ENDC100



          ORG     $C200

ASNGLBF0
; SNGLBF0 IS INDEXED BY SONG NUMBER.
; IT CONTAINS THE LOW BYTE FOR FREQUENCY OF FIRST VOICE.
;  20 BYTES
SNGLBF0   DB      $00,L(SNGCF0),L(SNGDF0),L(SNGDF0),L(SNGNULLF)
          DB      L(SNG1F0),L(SNG2F0),L(SNG3F0)
          DB      L(SNG5F0),L(SNG4F0),L(SNG6F0),L(SNG7F0)
          DB      L(SNG8F0),L(SNG9F0),L(SNG10F0),L(SNG11F0)
          DB      L(SNG12F0),L(SNG13F0),L(SNG14F0)    ;,L(SNG15F0)


ASNGLBF1
; SNGLBF1 IS INDEXED BY SONG NUMBER.
; IT CONTAINS THE LOW BYTE FOR FREQUENCY OF SECOND VOICE, IF THERE IS ONE.
; HIGH BYTE IS ASSUMED TO BE SNGHBF0.
;  20 BYTES
SNGLBF1   DB      L(SNG15F0),0,L(SNGDF1),L(SNGDF1)
          DB      0,L(SNG1F1),0,L(SNG3F1)
          DB      0,0,0,0
          DB      L(SNG8F1),L(SNG9F1),0,0
          DB      L(SNG12F1),L(SNG13F1),L(SNG14F1)    ;,L(SNG15F1)


; SNGC0 IS INDEXED BY SONG NUMBER.
; IT CONTAINS THE VALUES FOR THE FIRST VOICE.
; 0 VALUE MEANS SPECIAL CASE - ROCK FALLING.
;  20 BYTES
ASNGC0
SNGC0     DB      L(SNG15F1),$04,$D4,$D4,$00,$11,$0D,$47,$04,$04
          DB      $04,$00,$D4,$D4,$04,$04,$DD,$D4,$DD      ;,$D4



; SNGVV0 IS INDEXED BY SONG NUMBER.
; IT CONTAINS 0 IF THERE ARE SEPARATE VOLUME TABLES, OR VOLUME ITSELF.
;  20 BYTES
ASNGVV0
SNGVV0    DB      $D4,$03,$22,$22,$00,$33,$03,$33,$03,$00
          DB      $04,$07,$74,$34,$07,$05,$33,$44,$00,$44

SETDFAST  LDA     #DHFASTL
          STA     DHORSPDL
          LDA     #DHFASTH
          STA     DHORSPDH
          LDA     #DIGFAST
          STA     DIGSPEED
          RTS                            ;15

HARPXPL   DB      $02,$FE                ;          ,$00,$00
HARPYPL   DB      $00,$00,$FC,$04

***** 98 BYTES FULL
ENDC200



          ORG     $C300
; ROCKPUSH MUST IMMEDIATELY PRECEDE CALCINDX
ROCKPUSH  LDA     ROCKSX,X               ;ENTRANCE POINT FROM FALL
          PHA
          LDA     ROCKSY,X
          SEC
          SBC     #12
          TAX
          PLA
;  EXPECTS X POSITION IN A, Y POSITION IN X.
;  RETURNS DIRT CHAR IN A, INDEX INTO DIRTMAP IN X.
;  USES TEMP.
CALCINDX  LSR     A
          LSR     A
          LSR     A
          STA     TEMP                   ;COLUMN
          TXA
          LSR     A
          LSR     A
          TAX
          LDA     DIV3TAB,X
          TAX                            ;ROW
          LDA     MAPLOW,X               ;ROW ADDRESS
          CLC
          ADC     TEMP
          TAX                            ;INDEX INTO DIRTMAP
          LDA     DIRTMAP,X
          RTS                            ;34


;  USES X,A,Y.
;  EXPECTS DIRTMAP,X IN A.
;  USES TEMP.
;  ASSUMES NEVER CALLED WHEN A<36.
DIGGER    STA     TEMP                   ;DIRTMAP,X
          JSR     BORE                   ;FOUND IN FALL FILE
          CMP     #30                    ;NEVER GOT HERE IF ALREADY < 30.
          BCS     DIGGER5
          LDA     #10                    ;ADD PTS FIRST TIME <30.
          LDY     #0
          JSR     ADDSCORE
          LDX     TEMP                   ;DON'T SLOW DOWN FOR HOURGLASS+BOWTIE
          CPX     #46
          BCS     DIGGER6
DIGGER3   LDA     #1                     ;WANT HARPOON AND SLOW SPEED
          STA     DIGTEMP
          RTS
DIGGER5   CMP     TEMP                   ;ANY CHANGE?
          BNE     DIGGER3
DIGGER6   RTS                            ;32


CHKNXTD   CLC
          ADC     LASTMOVE
          TAY
          JSR     ADJUSTTO
          JSR     CALCINDX
          CMP     #36
          BCS     CHKNXTD2
          LDA     #0                     ;DOES NOT AFFECT CARRY
          STA     DIGTEMP                ;DOES NOT AFFECT CARRY
CHKNXTD2  RTS                            ;19

;  USES X AND A.
;  RETURNS EQ IF ON ROW, NE IF NOT ON ROW.
ROWHERE   LDX     #15
          LDA     DDYPOS
CHKINROW  CMP     TOPZONE,X              ;ARE WE ON A ROW BORDER?
          BEQ     ROWHERE2
          DEX
          BPL     CHKINROW
ROWHERE2  RTS                            ;13

*** ??? BYTE LEFT...
ENDC300

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;                                         ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;  ORG: PUT STUFF HERE WHICH IS PAGE      ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;       BOUNDARY DEPENDENT.               ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;                                         ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;                                         ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;                                         ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;                                         ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


          ORG     $EC00
;  PUT IN AN ORG HERE!!! - THIS PAGE IS 256 BYTES FULL.
;  WARNING!!! - DON'T BEGIN PAGE WITH F1 ARRAY.
ASNG7F0

SNG7F0    DB      $1E,$1C,$1E,$1C,$14,$15,$13    ;,$14      ;8 BYTES-1


ASNG2F0
SNG2F0    DB      $14,$12,$14,$13    ;,$0F,$0E,$0F,$0E      ;8 BYTES-4


;NOTE: IN 2600 THERE IS ALSO 0F,0E,0F,0E.....1F,1E,1F,1E
;      FOR A TOTAL OF 24 BYTES
ASNGCF0
SNGCF0    DB      $0F,$0E,$0F,$0E                      ;16 BYTES-8
          DB      $0F,$0E,$0F,$0E
;                              DB      $1F,$1E,$1F,$1E
;                              DB      $1F,$1E,$1F,$1E

ASNG6F0
SNG6F0    DB      $1F,$1E,$1F,$1E,$1F,$1E,$1F,$1E      ;20 BYTES-5
          DB      $0F,$0E,$0F,$10,$11,$10,$0E     ;,$0D
                     ;          DB      $0E,$0F,$0E,$0F


ASNG14F0
SNG14F0   DB      $0D,$0E,$0F,$0E,$0F,$10,$0F,$10      ;14 BYTES
          DB      $11,$10,$11,$12,$33,$2C


ASNG5F0
SNG5F0    DB      $0B,$08,$06,$0B,$08,$06,$0B,$08  ;,$06  ;9 BYTES-1


ASNG14V0
SNG14V0   DB      $06,$06,$06,$05,$05,$05,$04,$04      ;14 BYTES
          DB      $04,$03,$03,$03,$02,$08


ASNG14F1
SNG14F1   DB      $0E,$0F,$10,$0F,$10,$11,$10,$11      ;14 BYTES
          DB      $12,$11,$12,$13,$34,$2D



ASNG14V1
SNG14V1   DB      $05,$05,$05,$04,$04,$04,$03,$03      ;14 BYTES
          DB      $03,$02,$02,$02,$01,$08



ASNG1F0
SNG1F0    DB      $1B,$18,$15,$14,$12,$10,$0E   ;,$0D      ;8 BYTES-1


ASNG7C0
SNG7C0    DB      $0D,$0D,$0D,$0D,$04,$04,$04,$04      ;8 BYTES


ASNG4V0
SNG4V0    DB      $0A,$0A,$0A,$0A                      ;15 BYTES
          DB      $0A,$0A,$0A,$0A
          DB      $04,$04,$04,$04,$04,$04,$04


ASNG4F0
SNG4F0    DB      $9A,$99,$98,$97                      ;15 BYTES-1
          DB      $96,$95,$94,$93
          DB      $32,$17,$18,$19,$1A,$1B     ;,$1C


ASNG1F1
SNG1F1    DB      $1C,$19,$16,$15,$13,$11,$0F    ;,$0E      ;8 BYTES-1


ASNG8F1
SNG8F1    DB      $0E,$11,$14,$18,$0E                  ;5 BYTES


ASNG12F1
SNG12F1   DB      $20,$93,$93,$93                       ;12 BYTES
          DB      $20,$93,$93,$93
          DB      $20,$93,$93,$13


ASNG12F0
SNG12F0   DB      $8F,$92,$91,$92                       ;12 BYTES-1
          DB      $8E,$92,$91,$92
          DB      $8D,$92,$91       ;,$12


ASNG13F0
SNG13F0   DB      $12,$11,$10,$8F,$12,$91               ;15 BYTES
          DB      $14,$92,$17,$94,$18,$17
          DB      $97,$2B,$17


ASNG9F1
SNG9F1    DB      $8B,$8F,$20,$8F                      ;16 BYTES
          DB      $8B,$8F,$20,$8F
          DB      $8B,$8F,$20,$8F
          DB      $20,$8F,$8F,$0F

ASNG9F0
SNG9F0    DB      $97,$97,$9C,$97                      ;14 BYTES-1
          DB      $94,$92,$91,$8F
          DB      $8D,$8D,$8D,$8D
          DB      $60      ;,$40



ASNG13F1
SNG13F1   DB      $40,$94,$00,$93                       ;12 BYTES-1
          DB      $00,$92,$00,$90,$00,$8F
          DB      $40       ;,$0F



ASNG8F0
SNG8F0    DB      $0F,$12,$15,$19,$0F                  ;5 BYTES


ASNG3F0
SNG3F0    DB      $30,$2F,$2E,$2D                      ;5 BYTES
          DB      $2E


ASNG3F1
SNG3F1    DB      $8A,$8A,$8A,$8A                      ;5 BYTES
          DB      $8A


SNGNULLF  DB      $60                    ; 1 BYTE

FLAMTABL  DC      RFYGAR2,LFYGAR2
          DC      RFLAMFYG,LFLAMFYG
          DC      RFYGAR2,LFYGAR2
          DC      RFLAMFYG,LFLAMFYG

ENDEC00

          ORG     $ED00
; PUT AN ORG HERE!!!
; WARNING!!! - DON'T BEGIN PAGE WITH F1 ARRAY.
;  THESE SOUND ARRAYS NEED 109 BYTES

ASNGDF0
SNGDF0    DB      $8F,$8F,$CF                          ;26 BYTES
          DB      $8F,$8F,$8F,$8F
          DB      $8F,$8F,$CF
          DB      $8F,$8F,$8F,$32
          DB      $D1,$D1
          DB      $31,$32,$31,$2F
          DB      $D1,$D1
          DB      $31,$32,$31,$10


ASNGDF1
SNGDF1    DB      $CF,$CF                              ;16 BYTES
          DB      $D0,$D0
          DB      $D1,$D1
          DB      $D2,$D2
          DB      $D3,$D3
          DB      $D3,$D3
          DB      $D4,$D4
          DB      $D2,$50




ASNG10F0
SNG10F0   DB      $12,$11,$10,$0F,$0D,$0F              ;6 BYTES


ASNG11F0
SNG11F0   DB      $17,$14,$12,$17,$9F,$8D               ;7 BYTES
          DB      $6F



ASNG15F0
SNG15F0   DB      $8F,$8F,$8F,$6F                      ;22 BYTES
          DB      $72,$2F
          DB      $72,$2F,$2D
          DB      $92,$92,$72
          DB      $34,$77,$76
          DB      $7F,$36
          DB      $7F,$76
          DB      $94,$94,$54


ASNG15F1
SNG15F1   DB      $34,$32,$30,$2F                      ;32 BYTES
          DB      $34,$2F,$34,$2F
          DB      $34,$2F,$34,$2F
          DB      $34,$2F,$34,$2F
          DB      $34,$2F,$34,$31
          DB      $94,$94,$94,$31
          DB      $34,$31,$34,$30
          DB      $34,$30,$34,$10


*****  THIS PAGE IS 109 BYTES FULL


;  FOLLOWING TWELVE  ARRAYS MUST OCCUR ON SAME PAGE - NEED 128 BYTES

SOUTH7    DB      36,38,40,42,28,46,20          ;$FF,$FF,$FF,$FF,28,$FF,20
SOUTH1    DB      44,12,48,24,44,08,48

NORTH7    DB      36,38,22,42,44,46,20          ;$FF,$FF,22,$FF,$FF,$FF,20
NORTH1    DB      40,06,40,18,48,02,48

WEST5     DB      36,38,40,26,44,10,48          ;$FF,$FF,$FF,26,$FF,10,$FF
WEST1     DB      42,46,18,42,24,46,16

EAST5     DB      36,14,40,42,44,10,48          ;$FF,14,$FF,$FF,$FF,10,$FF
EAST1     DB      38,38,06,46,12,46,04

VERTTOP   DB      00,02,04,06,00,02,04,06,16,18,20,22,16,18,20,30,32,34
TITLYPOS  DB      0,23,23,47,71,23,47,71,71,0,0,0,0,0,0,0,0
;         DB      0,0
VERTBOT   DB      00,00,04,04,08,08,12,12,16,16,20,20,24,24,28,30,32,34

HORRGT    DB      00,02,04,06,08,10,12,14,00,02,04,06,08,10,12,30,32,34
HORLFT    DB      00,02,00,02,08,10,08,10,16,18,16,18,24,26,24,30,32,34

FLAMPOS   DC      $04,$08                PIXEL X-POS OFFSETS FOR FLAME
;  FROM MONSTER.S                         BOUND TO NEXT PAGE!!!

ENDED00

          ORG     $EE00

          DC      $10,$18                ; BOUND TO PREVIOUS PAGE!!!

*****  FROM MONSTER.S FILE
;-------- CHARACTER SEQUENCE VALUES

;  !!!! IF THESE STAMP ARRAYS ARE MOVED NEWSEQ IN MONSTER FILE MUST CHANGE !!!!
;POOKA ARRAYS MUST STAY TOGETHER AND ON SAME PAGE WITH FYGAR ARRAYS.
RPOOKA    DC      RPOOKA2,RPOOKA2,RPOOKA1,RPOOKA1,RPOOKA1
          DC      RPOOKA1,RPOOKA1,RPOOKA1,0
LPOOKA    DC      LPOOKA2,LPOOKA2,LPOOKA1,LPOOKA1,LPOOKA1
          DC      LPOOKA1,LPOOKA1,LPOOKA1,0
GPOOKA    DC      GPOOKA1,GPOOKA2,GPOOKA2,GPOOKA2        ;,0
TITLXPOS  DB      0,4,124,34,64,64,94,4,124  ;OVERLAPPED WITH ABOVE.

;FYGAR ARRAYS MUST STAY TOGETHER AND ON SAME PAGE WITH POOKA ARRAYS.
RFYGAR    DC      RFYGAR1,RFYGAR1,RFYGAR2,RFYGAR2
          DC      RFYGAR1,RFYGAR1,RFYGAR2,RFYGAR2,0
LFYGAR    DC      LFYGAR1,LFYGAR1,LFYGAR2,LFYGAR2
          DC      LFYGAR1,LFYGAR1,LFYGAR2,LFYGAR2,0
GFYGAR    DC      GFYGAR1,GFYGAR2,GFYGAR2,GFYGAR2        ;,0
TITLCDIR  DB      0,1,2,4,0,2,4,4        ;OVERLAPPED WITH ABOVE.
LOGODLL   DB      $CF,H(DUMMYDPL),L(DUMMYDPL)
          DB      $4F,H(DUMMYDPL),L(DUMMYDPL)
          DB      $43,H(DUMMYDPL),L(DUMMYDPL)
          DB      $4B,H(L0Z13),L0Z13P5
          DB      $4B,H(L0Z12),L0Z12P5
          DB      $43,H(DUMMYDPL),L(DUMMYDPL)
          DB      $4B,H(L0Z9),L0Z9P5
          DB      $4C,H(DUMMYDPL),L(DUMMYDPL)


********************************************************************************
***********                                                          ***********
***********       DLI ROUTINES:  NMI VECTOR POINTS AT A RAM          ***********
***********               LOCATION WHICH CONTAINS A JUMP TO          ***********
***********               THE NEXT DLI, DEPENDING ON THE             **********
***********               CURRENT POSITION ON THE SCREEN.            ***********
***********               THE DLI'S ARE ARRANGED AS FOLLOWS:         ***********
***********                                                          ***********
***********               DLISETUP   -   JUST BEFORE ZONE 0:         ***********
***********                              SETS ONSCREEN FLAG TO 1.    ***********
***********               DLISCORE   -   SCORE ZONE USES PALETTE 5,  ***********
***********                              SO THIS DLI RESETS PAL 5    ***********
***********                              FOR VEGGIE COLORS.          ***********
***********               DLISKY     -   SKY USES PALETTE 7, SO DLI  ***********
***********                              RESETS IT FOR DIRT LAYER 1. ***********
***********               DLIDIRT0   -   USES PALETTE 6; DLI RESETS  ***********
***********                              PALETTE 6 FOR DIRT LAYER 2. ***********
***********               DLIDIRT1   -   USES PALETTE 7; DLI RESETS  ***********
***********                              PALETTE 7 FOR DIRT LAYER 3. ***********
***********               DLIDIRT2   -   USES PALETTE 6; DLI RESETS  ***********
***********                              PALETTE 6 FOR DIRT LAYER 0. ***********
***********               DLIRESET   -   RESETS PALETTE 5 FOR SCORE. ***********
***********               DLIDIRT3   -   USES PALETTE 7; DLI RESETS  ***********
***********                              PALETTE 7 FOR SKY.          ***********
***********               DLIBOTOM   -   RESETS ONSCREEN TO 0.       ***********
***********               DLIVBLNK   -   WAITS FOR VBLANK TO SYNC    ***********
***********                              DLI'S; RESTORES ORIGINAL    ***********
***********                              PALETTES.                   ***********
***********                                                          ***********
***********  NOTE: DLI ROUTINES MUST NOT BEGIN PAGE !!!!!            ***********
********************************************************************************
*DLISETUP
*         PHA
**        LDA     #1                     ;THIS DLI IS FOR THE DUMMY ZONE JUST
**        STA     ONSCREEN               ;  BEFORE ZONE 0.  IT SETS ONSCREEN
*         LDA     #L(DLISCORE)           ;  AND LOW BYTE OF ADDRESS OF NEXT DLI.
*         STA     DLIVECT                ;  EVENTUALLY, WE CAN OPTIMIZE THIS SO
**        LDA     #H(DLISCORE)           ;  THAT ALL DLI CODE IS ON SAME PAGE:
**        STA     DLIVECT+1              ;  THEN ONLY LOW BYTE NEED BE UPDATED.
*         INC     FRMCNT
*         INC     TITLETIM
*         BNE     BYESETUP
*         INC     SELCTIM
*BYESETUP  PLA
*         RTI

DLISETUP
          PHA
          TXA
          PHA                            ;ZONE 0 DLI: SCORE/LIVES LINE.  THIS
          LDX     VEGCOLR                ;  USES PALETTE 5, SO IT MUST RESET
          LDA     VEGCOLR+1              ;  COLORS FOR VEGETABLES WHEN DONE.
*         STA     WSYNC
          STA     WSYNC
          STX     P5C2
          STA     P5C1
          LDA     #L(DLISKY)
          BNE     DLIEND
*         STA     DLIVECT
*         LDA     #H(DLISKY)
*         STA     DLIVECT+1
*         PLA
*         TAX
*         PLA
*         RTI

DLISKY
          PHA
          TXA
          PHA                            ;SKY ZONE:  USES PALETTE 7, RESETS
          LDX     DRT1COLR               ;  PALETTE 7 FOR USE IN DIRT LAYER 1.
          LDA     DRT1COLR+1
*         STA     WSYNC
          STA     WSYNC
          STX     P7C1
          STA     P7C3
          LDA     #L(DLIDIRT0)
          BNE     DLIEND
*         STA     DLIVECT
*         LDA     #H(DLIDIRT0)
*         STA     DLIVECT+1
*         PLA
*         TAX
*         PLA
*         RTI


DLIDIRT0
          PHA
          TXA
          PHA                            ;DIRT LAYER 0: USES PALETTE 6, RESETS
          LDX     DRT2COLR               ;  PALETTE 6 FOR USE IN DIRT LAYER 2.
          LDA     DRT2COLR+1
*         STA     WSYNC
          STA     WSYNC
          STX     P6C1
          STA     P6C3
          LDA     #L(DLIDIRT1)
DLIEND    STA     DLIVECT
*         LDA     #H(DLIDIRT1)
*         STA     DLIVECT+1
          BNE     DLIEXIT
*         PLA
*         TAX
*         PLA
*         RTI


DLIDIRT1
          PHA
          TXA
          PHA                            ;DIRT LAYER 1: USES PALETTE 7, RESETS
          LDX     DRT3COLR               ;  PALETTE 7 FOR USE IN DIRT LAYER 3.
          LDA     DRT3COLR+1
*         STA     WSYNC
          STA     WSYNC
          STX     P7C1
          STA     P7C3
          INC     FRMCNT
          ASL     SYNCFRAM
          BCC     STUFF
          INC     SYNCFRAM
STUFF     INC     TITLETIM
          BNE     ZYXWVU
          INC     SELCTIM
ZYXWVU    LDA     #L(DLIVBLNK)
          BNE     DLIEND
*         STA     DLIVECT
*         LDA     #H(DLIDIRT3)
*         STA     DLIVECT+1
*         PLA
*         TAX
*         PLA
*         RTI


*DLIDIRT3
*         PHA                            ;CLEARS ONSCREEN FLAG AND SETS DLI
*         LDA     #0                     ;  POINTER TO DLI FOR TOP OF SCREEN.
*         STA     ONSCREEN
*         LDA     #L(DLIVBLNK)
*ZDLIRTI   STA     DLIVECT
*         LDA     #H(DLIVBLNK)
*         STA     DLIVECT+1
*         PLA
*         RTI

DLIVBLNK
          PHA
          TXA
          PHA
          TYA
          PHA
          LDY     #4
DLIWLOOP  STA     WSYNC
          DEY
          BPL     DLIWLOOP
ZDLIVBL   LDA     CTRLRD                 ;WAIT FOR VBLANK TO SYNC DLI'S.
          BPL     ENDDLIV
          LDA     CTRLRD
          BPL     ENDDLIV
          JSR     DOCOLORS
          JSR     SOUND
          LDA     #L(DLISETUP)
          STA     DLIVECT
*         LDA     #H(DLISETUP)
*         STA     DLIVECT+1
ENDDLIV   PLA
          TAY
DLIEXIT   PLA
          TAX
          PLA
GENERTI   RTI

DLITOP    PHA
          LDA     #$50
          STA     CTRL
          LDA     #CSET1
          STA     CHARBASE
          INC     P0C0SHAD+27
          LDA     P0C0SHAD+27
          STA     WSYNC
          STA     P0C0+27
          LDA     #L(DLIBOTM)
          BNE     ZDLIRTI

DLIBOTM   PHA
          LDA     #$4B
          STA     CTRL
          LDA     #$39
          STA     CHARBASE
          LDA     #L(DLITOP)
ZDLIRTI   STA     DLIVECT
          PLA
          RTI
ENDDLI
***** THIS PAGE IS ??? BYTES FULL
ENDEE00
*         ORG     $DFC0
*** THESE MUST BE ON SAME PAGE...
*PINEDIFF  DB      29,29,29,29,29,29,29,29,15,8,13,4,0,15,15,11,4
*          DB      29
*BONZDIFF  DB      29,29,29,29,29,29,29,29        ;THIS ROW IS OVERLAPPED.
*          DB      19,4,3,3,24,1,4,0,17
*GAMENAME  DB      29,29,29,29,29,29,29,29,29     ;THIS ROW IS OVERLAPPED.
*          DB      3,8,6,29,3,20,6,29,29,29,29,29
*          DB      29,29,29,29,29
*******************************************************************************
*******************************************************************************

***********               CHARACTER AND STAMP DATA                   **********
***********                        CSET1                             **********
***********                    PAGES 40 - 4B                         **********

*******************************************************************************

          ORG     $E000                  ;BOTTOM SCAN LINE: OFFSET = 0.

          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;0-7    DIRT CHARACTERS
          DB      $54,$54,$54,$54,$54,$5D,$54,$5D        ;8-15
          DB      $40,$00,$40,$00,$40,$00,$40,$00        ;16-23
          DB      $54,$54,$54,$54,$55,$5D                ;24-29
          DB      $6A,$A9                                ;30-31  SKY
          DB      $A9,$5A,$A5,$6A                        ;32-35  BIG,SML FLOWER
          DB      $55,$5D                                ;36-37  FULL DIRT CHAR
          DB      $55,$5D,$40,$01,$55,$5D,$55,$5D        ;38-45  HALF FULL DIRT
          DB      $55,$5D,$40,$01                        ;46-49  HALF FULL DIRT

          DB      $0E,$B0                                ;50-51  TEDDY HEAD
          DB      $80,$00,$00,$00,$0E,$EF,$00,$00        ;52-59  VEGGIES:C,R,M,C
          DB      $0A,$80,$00,$00,$00,$00,$00,$00        ;60-67  E,BP,T,O
          DB      $00,$00,$00,$00,$0A,$A8                ;68-73  W,G,P

          DB      $50,$00,$00,$0D                        ;74-77  R,L DIRT EDGE

          DB      $00,$00                                ;78-79  S
          DB      $00,$00                                ;80-81  A
          DB      $00,$00                                ;82-83  Y
          DB      $00,$00,$00,$00                        ;84-87  LETRG,LETRM

          DB      $00,$CC,$CC,$CC,$CC,$00                ;88-93  (C) 1983 ATARI
          DB      $0C,$33,$33,$30,$C0,$C0                ;94-99  (C) 1982 NAMCO
          DB      $AA,$80,$02,$AA,$2A,$AA,$AA,$80        ;100-07 TITLED10,9
          DB      $AA,$80,$AA,$A8,$00,$AA,$A8,$00        ;108-15 TITLEG10,9
          DB      $AA,$A8,$2A,$AA,$00,$AA,$A8,$00        ;116-23 TITLEU10,9
          DB      $00,$03,$FF,$60,$00,$FF,$3F,$C0        ;124-31 TDDUG10,9
          DB      $AA,$AA,$0A,$A0                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $00,$00                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $00,$00,$00,$00,$00,$00                ;150-55 NUMBERS: 0,1,2
          DB      $00,$00,$00,$00,$00,$00                ;156-61 3,4,5
          DB      $00,$00,$00,$00,$00,$00                ;162-67 6,7,8
          DB      $00,$00                                ;168-69 9


          ORG     $E100                  ;LINE 11: OFFSET = 1.

          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$05,$00,$05        ;8-15
          DB      $40,$00,$40,$00,$40,$01,$40,$01        ;16-23
          DB      $50,$00,$50,$00,$50,$05                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $A5,$56,$95,$5A                        ;32-35  BIG,SML FLOWER
          DB      $55,$55                                ;36-37  FULL DIRT
          DB      $05,$55,$40,$01,$55,$50,$55,$55        ;38-45  HALF FULL DIRT
          DB      $05,$50,$40,$01                        ;46-49  HALF FULL DIRT

          DB      $2B,$2C                                ;50-51  TEDDY HEAD
          DB      $A0,$00,$57,$00,$03,$B8,$00,$00        ;52-59  VEGGIES:C,R,M,C
          DB      $2A,$A0,$00,$00,$00,$00,$33,$30        ;60-67  E,BP,T,O
          DB      $00,$00,$03,$C0,$2A,$EA                ;68-73  W,G,P

          DB      $50,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $55,$50                                ;78-79  S
          DB      $50,$14                                ;80-81  A
          DB      $05,$40                                ;82-83  Y
          DB      $15,$50,$50,$14                        ;84-87  LETRG,LETRM

          DB      $00,$CC,$CC,$CC,$CC,$00                ;88-93  (C) 1983 ATARI
          DB      $0C,$33,$33,$33,$33,$30                ;94-99  (C) 1982 NAMCO
          DB      $FF,$C0,$03,$FF,$FF,$FF,$FF,$F0        ;100-07 TITLED10,9
          DB      $FF,$C0,$00,$00,$0F,$FF,$FF,$C0        ;108-15 TITLEG10,9
          DB      $FF,$FC,$3F,$FF,$0F,$FF,$FF,$C0        ;116-23 TITLEU10,9
          DB      $00,$3F,$FF,$C0,$00,$3F,$0F,$C0        ;124-31 TDDUG10,9
          DB      $FF,$FF,$0F,$F0                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $50,$14                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $3F,$F0,$FF,$FC,$FF,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $3F,$F0,$03,$F0,$3F,$F0                ;156-61 3,4,5
          DB      $3F,$F0,$FF,$00,$3F,$F0                ;162-67 6,7,8
          DB      $FF,$00                                ;168-69 9


          ORG     $E200                  ;LINE 10: OFFSET = 2.

          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;8-15
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;16-23
          DB      $40,$00,$C0,$00,$40,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $96,$66,$5B,$56                        ;32-35  BIG,SML FLOWER
          DB      $D5,$55                                ;35-37  FULL DIRT
          DB      $01,$55,$C0,$01,$D5,$40,$D5,$55        ;38-45  HALF DIRT
          DB      $01,$40,$C0,$01                        ;46-49  HALF DIRT

          DB      $EC,$8B                                ;50-51  TEDDY HEAD
          DB      $A8,$00,$55,$40,$03,$FC,$69,$00        ;52-59  VEGGIES:C,R,M,C
          DB      $96,$A0,$04,$40,$00,$00,$0F,$C0        ;60-67  E,BP,T,O
          DB      $0A,$A0,$03,$C0,$2A,$AE                ;68-73  W,G,P

          DB      $D0,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $AA,$A8                                ;78-79  S
          DB      $A0,$28                                ;80-81  A
          DB      $0A,$80                                ;82-83  Y
          DB      $AA,$A8,$A0,$28                        ;84-87  LETRG,LETRM


          DB      $00,$FC,$CF,$CF,$0C,$00                ;88-93  (C) 1983 ATARI
          DB      $0C,$F3,$F3,$33,$03,$30                ;94-99  (C) 1982 NAMCO
          DB      $AA,$80,$02,$AA,$AA,$AA,$AA,$A8        ;100-07 TITLED10,9
          DB      $AA,$80,$00,$00,$0A,$AA,$AA,$A0        ;108-15 TITLEG10,9
          DB      $AA,$A8,$2A,$AA,$2A,$AA,$AA,$A0        ;116-23 TITLEU10,9
          DB      $00,$FF,$FF,$C0,$00,$0F,$03,$C0        ;124-31 TDDUG10,9
          DB      $AA,$AA,$2A,$A8                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $A0,$28                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FF,$FC,$FF,$FC,$FF,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $FF,$FC,$03,$F0,$FF,$FC                ;156-61 3,4,5
          DB      $FF,$FC,$FF,$C0,$FF,$FC                ;162-67 6,7,8
          DB      $FF,$C0                                ;168-69 9


          ORG     $E300                  ;LINE 9: OFFSET = 3.

          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;8-15
          DB      $40,$00,$40,$00,$40,$00,$40,$00        ;16-23
          DB      $40,$00,$40,$00,$40,$00                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $AB,$EA,$AB,$9A                        ;32-35  BIG,SML FLOWER
          DB      $55,$55                                ;36-37  FULL DIRT
          DB      $01,$55,$40,$01,$55,$40,$55,$55        ;38-45  HALF DIRT
          DB      $01,$40,$40,$01                        ;46-49  HALF DIRT

          DB      $E2,$23                                ;50-51  TEDDY HEAD
          DB      $BA,$00,$55,$70,$E3,$F0,$6E,$80        ;52-59  VEGGIES:C,R,M,C
          DB      $5A,$A8,$15,$50,$15,$54,$6A,$A4        ;60-67  E,BP,T,O
          DB      $29,$68,$03,$C0,$2E,$AA                ;68-73  W,G,P

          DB      $50,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $00,$14                                ;78-79  S
          DB      $50,$14                                ;80-81  A
          DB      $05,$40                                ;82-83  Y
          DB      $50,$14,$50,$14                        ;84-87  LETRG,LETRM

          DB      $00,$CC,$CC,$CC,$CC,$00                ;88-93  (C) 1983 ATARI
          DB      $0F,$F3,$33,$F3,$03,$30                ;94-99  (C) 1982 NAMCO
          DB      $FF,$C0,$0F,$FF,$FF,$FF,$FF,$FC        ;100-07 TITLED10,9
          DB      $FF,$F0,$0F,$F0,$3F,$FF,$FF,$FC        ;108-15 TITLEG10,9
          DB      $FF,$FC,$3F,$FF,$3F,$FF,$FF,$FC        ;116-23 TITLEU10,9
          DB      $00,$05,$5F,$F0,$00,$0F,$FF,$C0        ;124-31 TDDUG10,9
          DB      $FF,$FF,$3F,$FC                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $50,$14                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FF,$FC,$FF,$FC,$3F,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $FC,$FC,$FF,$FC,$F0,$FC                ;156-61 3,4,5
          DB      $FC,$FC,$3F,$C0,$FC,$FC                ;162-67 6,7,8
          DB      $3F,$C0                                ;168-69 9


          ORG     $E400                  ;LINE 8: OFFSET = 4.

          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;0-7
          DB      $00,$00,$00,$00,$00,$00,$00,$03        ;8-15
          DB      $40,$00,$40,$00,$40,$00,$40,$00        ;16-23
          DB      $40,$00,$40,$00,$40,$00                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $AF,$FA,$AF,$6A                        ;32-35  BIG,SML FLOWER
          DB      $55,$57                                ;36-37  FULL DIRT
          DB      $01,$57,$50,$07,$55,$40,$55,$57        ;38-45  HALF DIRT
          DB      $01,$40,$50,$07                        ;46-49  HALF DIRT

          DB      $EA,$2B                                ;50-51  TEDDY HEAD
          DB      $2A,$00,$55,$50,$AB,$F0,$1A,$E0        ;52-59  VEGGIES:C,R,M,C
          DB      $6E,$A8,$55,$54,$55,$55,$6B,$A8        ;60-67  E,BP,T,O
          DB      $64,$59,$03,$C0,$2A,$EA                ;68-73  W,G,P

          DB      $50,$00,$00,$07                        ;74-77  R,L DIRT EDGE

          DB      $00,$28                                ;78-79  S
          DB      $AA,$A8                                ;80-81  A
          DB      $0A,$80                                ;82-83  Y
          DB      $A0,$28,$A0,$28                        ;84-87  LETRG,LETRM

          DB      $00,$CC,$CC,$CC,$CC,$00                ;88-93  (C) 1983 ATARI
          DB      $0F,$33,$33,$F3,$33,$30                ;94-99  (C) 1982 NAMCO
          DB      $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA        ;100-07 TITLED10,9
          DB      $AA,$A8,$2A,$A8,$2A,$AA,$AA,$A8        ;108-15 TITLEG10,9
          DB      $AA,$A8,$2A,$AA,$AA,$AA,$AA,$A8        ;116-23 TITLEU10,9
          DB      $00,$14,$45,$FC,$00,$1F,$FF,$D0        ;124-31 TDDUG10,9
          DB      $AA,$AA,$2A,$A8                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $AA,$A0                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FC,$FC,$0F,$C0,$0F,$C0                ;150-55 NUMBERS: 0,1,2
          DB      $00,$FC,$FF,$FC,$00,$FC                ;156-61 3,4,5
          DB      $FC,$FC,$0F,$F0,$FC,$FC                ;162-67 6,7,8
          DB      $0F,$F0                                ;168-69 9


          ORG     $E500                  ;LINE 7: OFFSET = 5.

          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;8-15
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;16-23
          DB      $00,$00,$40,$00,$00,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $BD,$FE,$BF,$DA                        ;32-35  BIG,SML FLOWER
          DB      $57,$55                                ;       FULL DIRT
          DB      $03,$55,$57,$55,$57,$40,$57,$55        ;       HALF DIRT
          DB      $03,$40,$57,$55                        ;       HALF DIRT

          DB      $EA,$AB                                ;       TEDDY HEAD
          DB      $2B,$80,$55,$50,$AA,$B0,$02,$B4        ;       VEGGIES:C,R,M,C
          DB      $6F,$A8,$65,$54,$55,$55,$AE,$E8        ;       E,BP,T,O
          DB      $A5,$5A,$0F,$F0,$3A,$AB                ;       W,G,P

          DB      $50,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $55,$54                                ;78-79  S
          DB      $55,$54                                ;80-81  A
          DB      $15,$50                                ;82-83  Y
          DB      $50,$54,$51,$14                        ;84-87  LETRG,LETRM

          DB      $00,$33,$F3,$03,$0C,$00                ;88-93  (C) 1983 ATARI
          DB      $0C,$30,$C3,$30,$C0,$C0                ;94-99  (C) 1982 NAMCO
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ;100-07 TITLED10,9
          DB      $3F,$FF,$FF,$FC,$3F,$FF,$FF,$FF        ;108-15 TITLEG10,9
          DB      $FF,$FC,$3F,$FF,$FF,$FF,$FF,$FF        ;116-23 TITLEU10,9
          DB      $00,$14,$45,$FC,$0A,$3F,$FF,$F0        ;124-31 TDDUG10,9
          DB      $FF,$FF,$FF,$FF                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $55,$50                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FC,$FC,$0F,$C0,$03,$F0                ;150-55 NUMBERS: 0,1,2
          DB      $3F,$FC,$FC,$FC,$00,$FC                ;156-61 3,4,5
          DB      $FC,$FC,$03,$F0,$3F,$F0                ;162-67 6,7,8
          DB      $0F,$F0                                ;168-69 9


          ORG     $E600                  ;LINE 6: OFFSET = 6.

          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;8-15
          DB      $40,$00,$40,$00,$40,$01,$40,$01        ;16-23
          DB      $40,$00,$40,$00,$40,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $BF,$DE,$BF,$DA                        ;32-35  BIG,SML FLOWER
          DB      $55,$55                                ;       FULL DIRT
          DB      $01,$55,$55,$55,$55,$40,$55,$55        ;       HALF DIRT
          DB      $01,$40,$55,$55                        ;       HALF DIRT

          DB      $28,$88                                ;       TEDDY HEAD
          DB      $0A,$80,$55,$50,$9A,$A8,$00,$A8        ;       VEGGIES:C,R,M,C
          DB      $17,$AA,$75,$54,$5D,$55,$AE,$E8        ;       E,BP,T,O
          DB      $95,$16,$2B,$E8,$0E,$AC                ;       W,G,P

          DB      $50,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $55,$54                                ;78-79  S
          DB      $50,$14                                ;80-81  A
          DB      $54,$54                                ;82-83  Y
          DB      $50,$54,$51,$14                        ;84-87  LETRG,LETRM

          DB      $00,$00,$00,$00,$00,$00                ;88-93  (C) 1983 ATARI
          DB      $00,$00,$00,$00,$00,$00                ;94-99  (C) 1982 NAMCO
          DB      $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA        ;100-07 TITLED10,9
          DB      $2A,$AA,$AA,$A8,$AA,$AA,$AA,$AA        ;108-15 TITLEG10,9
          DB      $AA,$A8,$2A,$AA,$AA,$AA,$AA,$AA        ;116-23 TITLEU10,9
          DB      $00,$15,$55,$FC,$2A,$3F,$DF,$B0        ;124-31 TDDUG10,9
          DB      $AA,$AA,$AA,$AA                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $50,$14                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FC,$FC,$0F,$C0,$F0,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $3F,$FC,$FC,$F0,$FF,$FC                ;156-61 3,4,5
          DB      $FF,$FC,$00,$FC,$FF,$FC                ;162-67 6,7,8
          DB      $3C,$FC                                ;168-69 9


          ORG     $E700                  ;LINE 5: OFFSET = 7.

          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;8-15
          DB      $40,$00,$40,$00,$40,$01,$40,$01        ;16-23
          DB      $40,$00,$40,$00,$40,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $BF,$FE,$B3,$DA                        ;32-35  BIG,SML FLOWER
          DB      $55,$55                                ;       FULL DIRT
          DB      $01,$55,$55,$55,$55,$40,$50,$05        ;       HALF DIRT
          DB      $01,$40,$50,$05                        ;       HALF DIRT

          DB      $2A,$A8                                ;       TEDDY HEAD
          DB      $0B,$80,$D5,$50,$AA,$AA,$00,$A8        ;       VEGGIES:C,R,M,C
          DB      $19,$EA,$75,$54,$5D,$55,$6E,$E4        ;       E,BP,T,O
          DB      $91,$56,$AD,$7B,$05,$50                ;       W,G,P

          DB      $50,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $50,$00                                ;78-79  S
          DB      $50,$14                                ;80-81  A
          DB      $50,$14                                ;82-83  Y
          DB      $50,$00,$55,$54                        ;84-87  LETRG,LETRM

          DB      $30,$30,$30,$33,$F0,$30                ;88-93  (C) 1983 ATARI
          DB      $30,$30,$30,$33,$F3,$F0                ;94-99  (C) 1982 NAMCO
          DB      $FF,$FF,$FF,$FC,$FF,$FF,$FF,$FF        ;100-07 TITLED10,9
          DB      $3F,$FF,$FF,$FC,$FF,$F0,$3F,$FF        ;108-15 TITLEG10,9
          DB      $FF,$FC,$3F,$FF,$FF,$FF,$FF,$FF        ;116-23 TITLEU10,9
          DB      $03,$FF,$FF,$FC,$AA,$AA,$96,$AA        ;124-31 TDDUG10,9
          DB      $FF,$FF,$FF,$FF                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $50,$14                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FC,$FC,$0F,$C0,$F0,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $00,$FC,$3C,$F0,$FF,$F0                ;156-61 3,4,5
          DB      $FF,$F0,$00,$FC,$FC,$FC                ;162-67 6,7,8
          DB      $FC,$FC                                ;168-69 9


          ORG     $E800                  ;LINE 4: OFFSET = 8.

          DB      $00,$00,$00,$00,$00,$00,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$00,$00,$01        ;8-15
          DB      $40,$00,$40,$00,$40,$00,$40,$00        ;16-23
          DB      $40,$00,$C0,$00,$40,$00                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $B7,$FE,$BF,$DA                        ;32-35  BIG,SML FLOWER
          DB      $D5,$55                                ;       FULL DIRT
          DB      $01,$55,$D5,$55,$D5,$40,$C0,$01        ;       HALF DIRT
          DB      $01,$40,$C0,$01                        ;       HALF DIRT

          DB      $AA,$AA                                ;       TEDDY HEAD
          DB      $02,$A0,$D5,$40,$E6,$6A,$00,$2A        ;       VEGGIES:C,R,M,C
          DB      $06,$AA,$54,$94,$55,$55,$2B,$A0        ;       E,BP,T,O
          DB      $95,$16,$A5,$5A,$15,$14                ;       W,G,P

          DB      $D0,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $50,$00                                ;78-79  S
          DB      $54,$54                                ;80-81  A
          DB      $50,$14                                ;82-83  Y
          DB      $50,$14,$55,$54                        ;84-87  LETRG,LETRM

          DB      $C3,$0C,$30,$33,$30,$30                ;88-93  (C) 1983 ATARI
          DB      $C3,$0C,$30,$33,$33,$00                ;94-99  (C) 1982 NAMCO
          DB      $AA,$AA,$AA,$A8,$AA,$80,$0A,$AA        ;100-07 TITLED10,9
          DB      $0A,$AA,$AA,$A0,$AA,$80,$0A,$AA        ;108-15 TITLEG10,9
          DB      $AA,$A8,$2A,$AA,$AA,$A8,$2A,$AA        ;116-23 TITLEU10,9
          DB      $00,$1F,$FF,$F0,$2A,$7F,$D6,$F0        ;124-31 TDDUG10,9
          DB      $2A,$A8,$AA,$AA                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $50,$14                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FF,$FC,$FF,$F0,$FF,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $FC,$FC,$3F,$F0,$FC,$00                ;156-61 3,4,5
          DB      $FC,$00,$FF,$FC,$FC,$FC                ;162-67 6,7,8
          DB      $FF,$FC                                ;168-69 9


          ORG     $E900                  ;LINE 3: OFFSET = 9.

          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;8-15
          DB      $00,$00,$40,$00,$00,$01,$40,$01        ;16-23
          DB      $00,$00,$40,$00,$00,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $BF,$DE,$AF,$6A                        ;32-35  BIG,SML FLOWER
          DB      $55,$5D                                ;       FULL DIRT
          DB      $01,$5D,$55,$5D,$55,$40,$40,$01        ;       HALF DIRT
          DB      $01,$40,$40,$01                        ;       HALF DIRT

          DB      $8B,$E2                                ;       TEDDY HEAD
          DB      $00,$90,$95,$A0,$2A,$A6,$00,$0A        ;       VEGGIES:C,R,M,C
          DB      $02,$6A,$11,$10,$16,$14,$0A,$80        ;       E,BP,T,O
          DB      $00,$00,$A5,$5A,$51,$45                ;       W,G,P

          DB      $50,$00,$00,$0D                        ;74-77  R,L DIRT EDGE

          DB      $55,$54                                ;78-79  S
          DB      $15,$50                                ;80-81  A
          DB      $50,$14                                ;82-83  Y
          DB      $55,$54,$54,$54                        ;84-87  LETRG,LETRM

          DB      $CC,$0C,$33,$F3,$F3,$F0                ;88-93  (C) 1983 ATARI
          DB      $CC,$0C,$33,$F3,$F3,$F0                ;94-99  (C) 1982 NAMCO
          DB      $FF,$FF,$FF,$F0,$FF,$C0,$03,$FF        ;100-07 TITLED10,9
          DB      $03,$FF,$FF,$C0,$FF,$C0,$0F,$FF        ;108-15 TITLEG10,9
          DB      $FF,$FC,$3F,$FC,$FF,$FC,$3F,$FF        ;116-23 TITLEU10,9
          DB      $00,$07,$FF,$F0,$0A,$1F,$F5,$B0        ;124-31 TDDUG10,9
          DB      $3F,$FC,$FF,$FF                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $55,$54                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FF,$FC,$FF,$F0,$FF,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $FF,$FC,$3F,$F0,$FF,$FC                ;156-61 3,4,5
          DB      $FF,$FC,$FF,$FC,$FF,$FC                ;162-67 6,7,8
          DB      $FF,$FC                                ;168-69 9


          ORG     $EA00                  ;LINE 2: OFFSET = 10.

          DB      $00,$00,$00,$00,$00,$01,$00,$05        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$05        ;8-15
          DB      $00,$00,$50,$00,$00,$01,$50,$05        ;16-23
          DB      $00,$00,$50,$00,$00,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $BD,$FE,$AA,$AA                        ;32-35  BIG,SML FLOWER
          DB      $55,$55                                ;       FULL DIRT
          DB      $05,$55,$55,$55,$55,$50,$40,$01        ;       HALF DIRT
          DB      $05,$50,$40,$01                        ;       HALF DIRT

          DB      $AC,$2A                                ;       TEDDY HEAD
          DB      $00,$50,$02,$28,$0A,$6A,$00,$06        ;       VEGGIES:C,R,M,C
          DB      $00,$AA,$01,$00,$00,$80,$06,$40        ;       E,BP,T,O
          DB      $00,$00,$95,$56,$44,$41                ;       W,G,P

          DB      $50,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $15,$54                                ;78-79  S
          DB      $05,$40                                ;80-81  A
          DB      $50,$14                                ;82-83  Y
          DB      $15,$50,$14,$50                        ;84-87  LETRG,LETRM

          DB      $C3,$0C,$33,$33,$33,$30                ;88-93  (C) 1983 ATARI
          DB      $C3,$0C,$33,$33,$30,$30                ;94-99  (C) 1982 NAMCO
          DB      $2A,$AA,$AA,$A0,$AA,$80,$02,$AA        ;100-07 TITLED10,9
          DB      $00,$AA,$AA,$80,$AA,$80,$AA,$AA        ;108-15 TITLEG10,9
          DB      $2A,$A0,$0A,$A8,$AA,$A8,$2A,$AA        ;116-23 TITLEU10,9
          DB      $00,$01,$FF,$C0,$00,$1F,$FD,$60        ;124-31 TDDUG10,9
          DB      $0A,$A0,$AA,$AA                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $15,$50                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $3F,$F0,$03,$F0,$3F,$F0                ;150-55 NUMBERS: 0,1,2
          DB      $3F,$F0,$0F,$F0,$FF,$FC                ;156-61 3,4,5
          DB      $3F,$FC,$FF,$FC,$3F,$F0                ;162-67 6,7,8
          DB      $3F,$F0                                ;168-69 9


          ORG     $EB00                  ;TOP SCAN LINE: OFFSET = 11.

          DB      $00,$00,$41,$C1,$00,$01,$41,$D5        ;0-7
          DB      $00,$00,$41,$C1,$00,$01,$41,$55        ;8-15
          DB      $40,$00,$51,$C1,$40,$01,$75,$D5        ;16-23
          DB      $40,$00,$51,$C1,$40,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $AF,$FA,$AA,$AA                        ;32-35  BIG,SML FLOWER
          DB      $75,$D5                                ;36-37  FULL DIRT
          DB      $75,$D5,$75,$D5,$75,$D5,$40,$01        ;38-45  HALF DIRT
          DB      $75,$D5,$40,$01                        ;46-49  HALF DIRT

          DB      $28,$28                                ;50-51  TEDDY HEAD
          DB      $01,$14,$0A,$20,$03,$A8,$00,$00        ;52-59  VEGGIES:C,R,M,C
          DB      $00,$28,$00,$00,$00,$00,$02,$00        ;60-67  E,BP,T,O
          DB      $00,$00,$85,$52,$00,$00                ;68-73  W,G,P

          DB      $70,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $00,$00                                ;78-79  S
          DB      $00,$00                                ;80-81  A
          DB      $00,$00                                ;82-83  Y
          DB      $00,$00,$00,$00                        ;84-87  LETRG,LETRM

          DB      $30,$30,$33,$F3,$F3,$30                ;88-93  (C) 1983 ATARI
          DB      $30,$30,$33,$F3,$F3,$F0                ;94-99  (C) 1982 NAMCO
          DB      $3F,$FF,$FF,$C0,$FF,$C0,$03,$FF        ;100-07 TITLED10,9
          DB      $00,$3F,$FC,$00,$FF,$C0,$FF,$FF        ;108-15 TITLEG10,9
          DB      $0F,$C0,$03,$F0,$FF,$FC,$3F,$FF        ;116-23 TITLEU10,9
          DB      $00,$00,$FF,$00,$00,$07,$FF,$60        ;124-31 TDDUG10,9
          DB      $03,$C0,$FF,$FF                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $00,$00                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $00,$00,$00,$00,$00,$00                ;150-55 NUMBERS: 0,1,2
          DB      $00,$00,$00,$00,$00,$00                ;156-61 3,4,5
          DB      $00,$00,$00,$00,$00,$00                ;162-67 6,7,8
          DB      $00,$00                                ;168-69 9
*******************************************************************************
*******************************************************************************

***********               CHARACTER AND STAMP DATA                   **********
***********                         CSET2                            **********
***********                     PAGES 4C - 57                        **********

*******************************************************************************

          ORG     $C062
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0            ;98
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;112
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;128
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;144
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;160
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;176
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;192
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;208
          DB      $06,$00,$06,$00,$05,$00,$DB,$18        ;224-31  RBPOOKA1,2,3,4
          DB      $00,$90,$00,$90,$00,$90,$24,$E7        ;232-39  LBPOOKA1,2,3,4
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;240-47  RBFYGAR1,2,3,4
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;248-55  LBFYGAR1,2,3,4

          ORG     $C162
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0            ;98
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;112
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;128
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;144
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;160
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;176
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;192
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;208
          DB      $15,$DC,$C5,$DC,$C5,$DC,$D1,$57        ;224-31  RBPOOKA1,2,3,4
          DB      $37,$54,$37,$53,$37,$53,$D5,$47        ;232-39  LBPOOKA1,2,3,4
          DB      $1A,$68,$5A,$50,$5A,$68,$16,$9A        ;240-47  RBFYGAR1,2,3,4
          DB      $29,$A4,$05,$A5,$29,$A5,$A6,$94        ;248-255 LBFYGAR1,2,3,4

          ORG     $C262
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0            ;98
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;112
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;128
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;144
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;160
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;176
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;192
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;208
          DB      $55,$57,$D5,$57,$D5,$57,$55,$55        ;224-31  RBPOOKA1,2,3,4
          DB      $D5,$55,$D5,$57,$D5,$57,$55,$55        ;232-39  LBPOOKA1,2,3,4
          DB      $16,$9A,$46,$9C,$56,$BA,$15,$7C        ;240-47  RBFYGAR1,2,3,4
          DB      $A6,$94,$36,$91,$AE,$95,$3D,$54        ;248-255 LBFYGAR1,2,3,4

          ORG     $C362
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0            ;98
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;112
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;128
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;144
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;160
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;176
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;192
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        ;208
          DB      $55,$54,$15,$54,$15,$54,$55,$05        ;224-31  RBPOOKA1,2,3,4
          DB      $15,$55,$15,$54,$15,$54,$50,$55        ;232-39  LBPOOKA1,2,3,4
          DB      $A1,$50,$15,$7C,$17,$FF,$05,$CD        ;240-47  RBFYGAR1,2,3,4
          DB      $05,$4A,$3D,$54,$FF,$D4,$73,$50        ;248-55  LBFYGAR1,2,3,4


          ORG     $C400                  ;BOTTOM SCAN LINE: OFFSET = 0.

***********       STAMPS WITHOUT ZERO PADDING

          DB      $28,$28,$28,$A8,$02,$A0                ;0-5    DDRIGHT 1,2,3
          DB      $28,$28,$2A,$28,$0A,$80                ;6-11   DDLEFT 1,2,3
          DB      $00,$00,$00,$00                        ;12-15  R,L FLAMEFYGAR
          DB      $00,$00,$00,$00                        ;16-19  R,L HARPOON
          DB      $00,$00                                ;20-21  R,L 4PIX FLAME
          DB      $00,$00,$00,$00,$00,$50                ;22-27  8,16PIX RFLAME
          DB      $00,$00,$00,$00,$01,$50                ;28-33  24PIX RFLAME
          DB      $00,$00,$00,$00,$00,$00                ;34-39  8,16PIX LFLAME
          DB      $00,$00,$00,$00,$00,$00                ;40-45  24PIX LFLAME
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;46-53  LPUMP24,R24->4
          DB      $00                                    ;54     (WIDTH OVERLAP)
          DB      $00,$00,$00,$00,$00,$00,$00,$00,$00    ;55-63  LPUMP20,16
          DB      $00,$00,$00,$00,$00,$00                ;64-69  LPUMP12,8,4,OVR

          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;70-77  2000,3000
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;78-85  5000,7000
          DB      $2A,$A0                                ;86-87  TOTRK
          DB      $00,$00                                ;88-89  LETRO
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;90-97  L,E,V,P

***********       ZERO PADDED STAMPS

          DB      $00,$00,$00,$00,$00,$00                ;98-103 400,600
          DB      $00,$0C                                ;104-05 UFULL,12 (PUMP)
          DB      $01,$00                                ;106-07 HDEATH S
          DB      $28,$28,$02,$80,$00,$00                ;108-13 HRDEATH 1,2,3
          DB      $28,$28,$02,$80,$00,$00                ;114-19 HLDEATH 1,2,3
          DB      $2A,$68,$0A,$60                        ;120-23 U,D HARPOON
          DB      $00,$00,$1A,$28,$00,$00,$28,$A4        ;124-31 POOKA:R1,2,L1,2
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;132-39 FYGAR:R1,2,L1,2
          DB      $00,$00,$00,$00,$0A,$A0,$00,$00        ;140-47 GHOST:P1,2,F1,2
          DB      $00,$00,$00,$00,$00,$00                ;148-53 DDUP 1,2,3
          DB      $24,$A2,$25,$A2,$24,$A0                ;154-59 DDDOWN 1,2,3
          DB      $28,$28,$69,$A0,$1A,$28                ;160-65 SQUASH1: DD,F,P
          DB      $28,$A0,$28,$A0,$2A,$A8                ;166-71 ROCK:STR,SP,CRM
          DB      $04,$04,$C0,$03,$00,$0C                ;172-77 DPMP,DFULL,U612
          DB      $00,$00,$00,$00,$00,$00                ;178-83 200,300
          DB      $00,$00,$00,$00,$00,$00                ;184-89 500,800
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;190-97 2500,4000
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;198-05 6000,8000
          DB      $00,$00,$00,$00                        ;206-09 10000
          DB      $00,$00,$00,$00                        ;210-13 12000
          DB      $00,$00,$00,$00                        ;214-17 15000
          DB      $00,$00,$00,$00                        ;218-21 1000
          DB      $00,$00                                ;222-23 ZBLANK
          DB      $AB,$55,$55,$55,$55,$55,$57,$00        ;224-31 RBPOOKA 1,2,3,4
          DB      $55,$EA,$55,$55,$55,$55,$00,$D5        ;232-39 LBPOOKA 1,2,3,4
          DB      $AA,$50,$15,$7C,$97,$FF,$17,$08        ;240-47 RBFYGAR 1,2,3,4
          DB      $05,$AA,$3D,$54,$FF,$D6,$20,$D4        ;248-55 LBFYGAR 1,2,3,4



          ORG     $C500                  ;LINE 11: OFFSET = 1.

***********       STAMPS WITHOUT ZERO PADDING

          DB      $2A,$A0,$2A,$A0,$2A,$80                ;0-5    DDRIGHT 1,2,3
          DB      $0A,$A8,$0A,$A8,$02,$A8                ;6-11   DDLEFT 1,2,3
          DB      $5E,$FE,$3F,$B5                        ;96-99  R,L FLAMEFYGAR
          DB      $AA,$A8,$2A,$AA                        ;100-03 R,L HARPOON
          DB      $00,$00                                ;20-21  R,L 4PIX FLAME
          DB      $00,$00,$00,$05,$41,$50                ;22-27  8,16PIX RFLAME
          DB      $00,$00,$00,$00,$55,$81                ;28-33  24PIX RFLAME
          DB      $00,$00,$01,$00,$00,$00                ;34-39  8,16PIX LFLAME
          DB      $05,$40,$00,$00,$00,$00                ;40-45  24PIX LFLAME
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;46-53  LPUMP24,R24->4
          DB      $00                                    ;54     (WIDTH OVERLAP)
          DB      $00,$00,$00,$00,$00,$00,$00,$00,$00    ;55-63  LPUMP20,16
          DB      $00,$00,$00,$00,$00,$00                ;64-69  LPUMP12,8,4,OVR

          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;70-77  2000,3000
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;78-85  5000,7000
          DB      $16,$A8                                ;86-87  TOTRK
          DB      $15,$50                                ;88-89  LETRO
          DB      $55,$54,$15,$54,$01,$40,$50,$00        ;90-97  L,E,V,P

***********       ZERO PADDED STAMPS

          DB      $00,$00,$00,$00,$00,$00                ;98-103 400,600
          DB      $00,$3C                                ;104-05 UFULL,12 (PUMP)
          DB      $41,$04                                ;106-07 HDEATH S
          DB      $2A,$A0,$2A,$00,$50,$A8                ;108-13 HRDEATH 1,2,3
          DB      $0A,$A8,$00,$A4,$2A,$05                ;114-19 HLDEATH 1,2,3
          DB      $2A,$68,$29,$58                        ;120-23 U,D HARPOON
          DB      $00,$00,$08,$20,$00,$00,$08,$20        ;124-31 POOKA:R1,2,L1,2
          DB      $69,$A0,$5A,$6A,$0A,$69,$A9,$A5        ;132-39 FYGAR:R1,2,L1,2
          DB      $00,$00,$00,$00,$28,$28,$80,$02        ;140-47 GHOST:P1,2,F1,2
          DB      $05,$90,$05,$90,$05,$90                ;148-53 DDUP 1,2,3
          DB      $24,$AA,$25,$AA,$24,$A4                ;154-59 DDDOWN 1,2,3
          DB      $2A,$A0,$15,$68,$08,$20                ;160-65 SQUASH1: DD,F,P
          DB      $AA,$A8,$AA,$A8,$57,$DE                ;166-71 ROCK:STR,SP,CRM
          DB      $15,$15,$C0,$03,$00,$3C                ;172-77 DPMP,DFULL,U612
          DB      $00,$00,$00,$00,$00,$00                ;178-83 200,300
          DB      $00,$00,$00,$00,$00,$00                ;184-89 500,800
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;190-97 2500,4000
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;198-05 6000,8000
          DB      $00,$00,$00,$00                        ;206-09 10000
          DB      $00,$00,$00,$00                        ;210-13 12000
          DB      $00,$00,$00,$00                        ;214-17 15000
          DB      $00,$00,$00,$00                        ;218-21 1000
          DB      $00,$00                                ;222-23 ZBLANK
          DB      $AF,$A5,$55,$55,$55,$55,$5C,$00        ;224-31 RBPOOKA 1,2,3,4
          DB      $5A,$FA,$55,$55,$55,$55,$00,$35        ;232-39 LBPOOKA 1,2,3,4
          DB      $2A,$40,$55,$7C,$57,$FF,$17,$03        ;240-47 RBFYGAR 1,2,3,4
          DB      $01,$A8,$3D,$55,$FF,$D5,$C0,$D4        ;248-55 LBFYGAR 1,2,3,4


          ORG     $C600                  ;LINE 10: OFFSET = 2.

***********       STAMPS WITHOUT ZERO PADDING

          DB      $2A,$A4,$2A,$A4,$2A,$A4                ;0-5    DDRIGHT 1,2,3
          DB      $2A,$A8,$2A,$A8,$1A,$A8                ;6-11   DDLEFT 1,2,3
          DB      $57,$D4,$16,$D5                        ;96-99  R,L FLAMEFYGAR
          DB      $AA,$AA,$AA,$AA                        ;100-03 R,L HARPOON
          DB      $00,$00                                ;20-21  R,L 4PIX FLAME
          DB      $00,$54,$00,$25,$55,$40                ;22-27  8,16PIX RFLAME
          DB      $00,$59,$40,$01,$51,$45                ;28-33  24PIX RFLAME
          DB      $00,$00,$01,$40,$00,$00                ;34-39  8,16PIX LFLAME
          DB      $42,$55,$00,$00,$00,$00                ;40-45  24PIX LFLAME
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;46-53  LPUMP24,R24->4
          DB      $00                                    ;54     (WIDTH OVERLAP)
          DB      $00,$00,$00,$00,$00,$00,$00,$00,$00    ;55-63  LPUMP20,16
          DB      $00,$00,$00,$00,$00,$00                ;64-69  LPUMP12,8,4,OVR

          DB      $3F,$FF,$FF,$FC,$3F,$FF,$FF,$FC        ;70-77  2000,3000
          DB      $3F,$FF,$FF,$FC,$3F,$FF,$FF,$FC        ;78-85  5000,7000
          DB      $55,$7A                                ;86-87  TOTRK
          DB      $AA,$A8                                ;88-89  LETRO
          DB      $AA,$A8,$AA,$A8,$2A,$A0,$A0,$00        ;90-97  L,E,V,P

***********       ZERO PADDED STAMPS

          DB      $3F,$FF,$FC,$3F,$FF,$FC                ;98-103 400,600
          DB      $00,$30                                ;104-05 UFULL,12 (PUMP)
          DB      $11,$10                                ;106-07 HDEATH S
          DB      $2A,$A4,$5A,$AA,$5A,$A0                ;108-13 HRDEATH 1,2,3
          DB      $2A,$A8,$AA,$A5,$0A,$A5                ;114-19 HLDEATH 1,2,3
          DB      $2A,$A8,$2A,$68                        ;120-23 U,D HARPOON
          DB      $CA,$28,$F5,$54,$28,$A3,$15,$5F        ;124-31 POOKA:R1,2,L1,2
          DB      $15,$68,$56,$94,$29,$54,$16,$95        ;132-39 FYGAR:R1,2,L1,2
          DB      $28,$0A,$00,$00,$A2,$8A,$A4,$1A        ;140-47 GHOST:P1,2,F1,2
          DB      $29,$AA,$29,$6A,$29,$A4                ;148-53 DDUP 1,2,3
          DB      $26,$AA,$26,$AA,$26,$A6                ;154-59 DDDOWN 1,2,3
          DB      $2A,$A4,$A5,$5A,$F5,$54                ;160-65 SQUASH1: DD,F,P
          DB      $96,$58,$96,$5A,$96,$75                ;166-71 ROCK:STR,SP,CRM
          DB      $0C,$0C,$C0,$03,$00,$30                ;172-77 DPMP,DFULL,U612
          DB      $3F,$FF,$FC,$3F,$FF,$FC                ;178-83 200,300
          DB      $3F,$FF,$FC,$3F,$FF,$FC                ;184-89 500,800
          DB      $3F,$FF,$FF,$FC,$3F,$FF,$FF,$FC        ;190-97 2500,4000
          DB      $3F,$FF,$FF,$FC,$3F,$FF,$FF,$FC        ;198-05 6000,8000
          DB      $3F,$FF,$FF,$FC                        ;206-09 10000
          DB      $3F,$FF,$FF,$FC                        ;210-13 12000
          DB      $3F,$FF,$FF,$FC                        ;214-17 15000
          DB      $3F,$FF,$FF,$FC                        ;218-21 1000
          DB      $00,$00                                ;222-23 ZBLANK
          DB      $6C,$ED,$55,$55,$55,$55,$54,$03        ;224-31 RBPOOKA 1,2,3,4
          DB      $7B,$39,$55,$55,$55,$55,$C0,$15        ;232-39 LBPOOKA 1,2,3,4
          DB      $F7,$50,$55,$5C,$57,$FF,$57,$00        ;240-47 RBFYGAR 1,2,3,4
          DB      $05,$DF,$35,$55,$FF,$D5,$00,$D5        ;248-55 LBFYGAR 1,2,3,4


          ORG     $C700                  ;LINE 9: OFFSET = 3.

***********       STAMPS WITHOUT ZERO PADDING

          DB      $96,$A8,$5A,$A9,$96,$A8                ;0-5    DDRIGHT 1,2,3
          DB      $2A,$96,$6A,$A5,$2A,$96                ;6-11   DDLEFT 1,2,3
          DB      $15,$F0,$0B,$54                        ;96-99  R,L FLAMEFYGAR
          DB      $AA,$AA,$AA,$AA                        ;100-03 R,L HARPOON
          DB      $00,$00                                ;20-21  R,L 4PIX FLAME
          DB      $21,$54,$00,$59,$15,$40                ;22-27  8,16PIX RFLAME
          DB      $01,$A6,$55,$10,$05,$69                ;28-33  24PIX RFLAME
          DB      $00,$00,$01,$50,$54,$00                ;34-39  8,16PIX LFLAME
          DB      $51,$45,$40,$01,$65,$00                ;40-45  24PIX LFLAME
          DB      $00,$3C,$00,$3C,$00,$3C,$00,$00        ;46-53  LPUMP24,R24->4
          DB      $00                                    ;54     (WIDTH OVERLAP)
          DB      $00,$3C,$00,$3C,$00,$00,$3C,$00,$3C    ;55-63  LPUMP20,16
          DB      $00,$3C,$00,$00,$3C,$00                ;64-69  LPUMP12,8,4,OVR

          DB      $FD,$5F,$77,$7F,$FF,$7F,$77,$7F        ;70-77  2000,3000
          DB      $FF,$7F,$77,$7F,$FD,$FF,$77,$7F        ;78-85  5000,7000
          DB      $7D,$7E                                ;86-87  TOTRK
          DB      $50,$14                                ;88-89  LETRO
          DB      $50,$00,$50,$00,$14,$50,$50,$00        ;90-97  L,E,V,P

***********       ZERO PADDED STAMPS

          DB      $FF,$7D,$DF,$FD,$FD,$DF                ;98-103 400,600
          DB      $00,$C0                                ;104-05 UFULL,12 (PUMP)
          DB      $00,$00                                ;106-07 HDEATH S
          DB      $AA,$A9,$5A,$9A,$6A,$88                ;108-13 HRDEATH 1,2,3
          DB      $6A,$AA,$A6,$A5,$22,$A9                ;114-19 HLDEATH 1,2,3
          DB      $2A,$A8,$2A,$68                        ;120-23 U,D HARPOON
          DB      $D6,$9A,$D5,$55,$A6,$97,$55,$57        ;124-31 POOKA:R1,2,L1,2
          DB      $A5,$5A,$15,$A0,$A5,$5A,$0A,$54        ;132-39 FYGAR:R1,2,L1,2
          DB      $2A,$2A,$A8,$A8,$88,$22,$8A,$A2        ;140-47 GHOST:P1,2,F1,2
          DB      $29,$6A,$2A,$5A,$29,$68                ;148-53 DDUP 1,2,3
          DB      $AE,$A8,$AE,$AA,$AE,$AA                ;154-59 DDDOWN 1,2,3
          DB      $25,$DD,$FF,$37,$AC,$CA                ;160-65 SQUASH1: DD,F,P
          DB      $5D,$76,$5D,$76,$24,$96                ;166-71 ROCK:STR,SP,CRM
          DB      $0C,$0C,$30,$0C,$00,$C0                ;172-77 DPMP,DFULL,U612
          DB      $F5,$7D,$DF,$F5,$FD,$DF                ;178-83 200,300
          DB      $FD,$FD,$DF,$FD,$FD,$DF                ;184-89 500,800
          DB      $D5,$F7,$F7,$7F,$FF,$DF,$77,$7F        ;190-97 2500,4000
          DB      $FF,$7F,$77,$7F,$FF,$7F,$77,$7F        ;198-05 6000,8000
          DB      $FD,$F7,$77,$7F                        ;206-09 10000
          DB      $F7,$57,$DD,$DF                        ;210-13 12000
          DB      $F7,$DF,$DD,$DF                        ;214-17 15000
          DB      $FF,$7D,$DD,$FF                        ;218-21 1000
          DB      $00,$00                                ;222-23 ZBLANK
          DB      $6C,$CD,$9A,$55,$55,$55,$5C,$00        ;224-31 RBPOOKA 1,2,3,4
          DB      $73,$39,$55,$A6,$55,$55,$00,$35        ;232-39 LBPOOKA 1,2,3,4
          DB      $FF,$34,$A9,$55,$55,$FF,$A9,$03        ;240-47 RBFYGAR 1,2,3,4
          DB      $1C,$FF,$55,$6A,$FF,$55,$C0,$6A        ;248-55 LBFYGAR 1,2,3,4


          ORG     $C800                  ;LINE 8: OFFSET = 4.

***********       STAMPS WITHOUT ZERO PADDING

          DB      $5A,$A4,$6A,$A4,$5A,$A4                ;0-5    DDRIGHT 1,2,3
          DB      $1A,$A5,$1A,$A9,$1A,$A5                ;6-11   DDLEFT 1,2,3
          DB      $3E,$50,$05,$BC                        ;96-99  R,L FLAMEFYGAR
          DB      $AA,$A6,$9A,$AA                        ;100-03 R,L HARPOON
          DB      $14,$00                                ;20-21  R,L 4PIX FLAME
          DB      $15,$55,$05,$65,$41,$54                ;22-27  8,16PIX RFLAME
          DB      $1A,$FA,$89,$51,$00,$59                ;28-33  24PIX RFLAME
          DB      $00,$00,$00,$55,$56,$00                ;34-39  8,16PIX LFLAME
          DB      $69,$50,$04,$55,$9A,$40                ;40-45  24PIX LFLAME
          DB      $00,$C3,$00,$C3,$00,$C3,$00,$04        ;46-53  LPUMP24,R24->4
          DB      $00                                    ;54     (WIDTH OVERLAP)
          DB      $00,$C3,$00,$C3,$00,$00,$C3,$00,$C3    ;55-63  LPUMP20,16
          DB      $00,$C3,$00,$00,$C3,$00                ;64-69  LPUMP12,8,4,OVR

          DB      $FD,$FD,$DD,$DF,$FD,$DD,$DD,$DF        ;70-77  2000,3000
          DB      $FD,$DD,$DD,$DF,$FD,$FD,$DD,$DF        ;78-85  5000,7000
          DB      $55,$75                                ;86-87  TOTRK
          DB      $A0,$28                                ;88-89  LETRO
          DB      $A0,$00,$A0,$00,$A8,$A8,$AA,$A0        ;90-97  L,E,V,P

***********       ZERO PADDED STAMPS

          DB      $FF,$77,$77,$F7,$77,$77                ;98-103 400,600
          DB      $00,$C0                                ;104-05 UFULL,12 (PUMP)
          DB      $00,$00                                ;106-07 HDEATH S
          DB      $6A,$A5,$6A,$A5,$6A,$AA                ;108-13 HRDEATH 1,2,3
          DB      $5A,$A9,$5A,$A9,$AA,$A9                ;114-19 HLDEATH 1,2,3
          DB      $2A,$A8,$2A,$A8                        ;120-23 U,D HARPOON
          DB      $F5,$96,$DA,$69,$96,$5F,$69,$A7        ;124-31 POOKA:R1,2,L1,2
          DB      $A9,$50,$2A,$50,$05,$6A,$05,$A8        ;132-39 FYGAR:R1,2,L1,2
          DB      $3F,$FE,$BE,$E8,$A0,$0A,$20,$08        ;140-47 GHOST:P1,2,F1,2
          DB      $AA,$68,$AA,$98,$AA,$68                ;148-53 DDUP 1,2,3
          DB      $A6,$A8,$A6,$A8,$A6,$A8                ;154-59 DDDOWN 1,2,3
          DB      $A5,$DD,$F7,$CC,$AC,$CA                ;160-65 SQUASH1: DD,F,P
          DB      $7D,$75,$7D,$B5,$00,$20                ;166-71 ROCK:STR,SP,CRM
          DB      $3C,$3C,$3C,$3C,$00,$C0                ;172-77 DPMP,DFULL,U612
          DB      $F7,$F7,$77,$FF,$77,$77                ;178-83 200,300
          DB      $F7,$77,$77,$F7,$77,$77                ;184-89 500,800
          DB      $DF,$DD,$DD,$DF,$FF,$DD,$DD,$DF        ;190-97 2500,4000
          DB      $FD,$DD,$DD,$DF,$FD,$DD,$DD,$DF        ;198-05 6000,8000
          DB      $FD,$DD,$DD,$DF                        ;206-09 10000
          DB      $F7,$7F,$77,$77                        ;210-13 12000
          DB      $F7,$77,$77,$77                        ;214-17 15000
          DB      $FF,$77,$77,$7F                        ;218-21 1000
          DB      $00,$00                                ;222-23 ZBLANK
          DB      $5A,$CC,$AB,$A5,$55,$55,$95,$00        ;224-31 RBPOOKA 1,2,3,4
          DB      $33,$A5,$5A,$EA,$55,$55,$00,$56        ;232-39 LBPOOKA 1,2,3,4
          DB      $33,$44,$A7,$57,$15,$FD,$AA,$C8        ;240-47 RBFYGAR 1,2,3,4
          DB      $11,$CC,$D5,$DA,$7F,$54,$23,$AA        ;248-55 LBFYGAR 1,2,3,4


          ORG     $C900                  ;LINE 7: OFFSET = 5.

***********       STAMPS WITHOUT ZERO PADDING

          DB      $69,$54,$69,$54,$69,$54                ;0-5    DDRIGHT 1,2,3
          DB      $15,$69,$15,$69,$15,$69                ;6-11   DDLEFT 1,2,3
          DB      $F9,$55,$55,$6F                        ;96-99  R,L FLAMEFYGAR
          DB      $6A,$55,$55,$A9                        ;100-03 R,L HARPOON
          DB      $55,$05                                ;20-21  R,L 4PIX FLAME
          DB      $5A,$55,$17,$EA,$55,$05                ;22-27  8,16PIX RFLAME
          DB      $AA,$BA,$A5,$41,$00,$69                ;28-33  24PIX RFLAME
          DB      $15,$00,$00,$55,$19,$40                ;34-39  8,16PIX LFLAME
          DB      $65,$00,$45,$62,$AF,$A4                ;40-45  24PIX LFLAME
          DB      $10,$C3,$00,$C3,$00,$C3,$00,$F5        ;46-53  LPUMP24,R24->4
          DB      $00                                    ;54     (WIDTH OVERLAP)
          DB      $10,$C3,$00,$C3,$00,$10,$C3,$00,$C3    ;55-63  LPUMP20,16
          DB      $10,$C3,$00,$10,$C3,$10                ;64-69  LPUMP12,8,4,OVR

          DB      $FF,$7D,$DD,$DF,$FF,$DD,$DD,$DF        ;70-77  2000,3000
          DB      $FF,$DD,$DD,$DF,$FD,$7D,$DD,$DF        ;78-85  5000,7000
          DB      $5D,$DD                                ;86-87  TOTRK
          DB      $50,$14                                ;88-89  LETRO
          DB      $50,$00,$55,$54,$50,$14,$55,$54        ;90-97  L,E,V,P

***********       ZERO PADDED STAMPS

          DB      $F5,$57,$77,$F7,$77,$77                ;98-103 400,600
          DB      $00,$C0                                ;104-05 UFULL,12 (PUMP)
          DB      $51,$15                                ;106-07 HDEATH S
          DB      $69,$55,$A5,$55,$6A,$A6                ;108-13 HRDEATH 1,2,3
          DB      $55,$69,$55,$5A,$9A,$A9                ;114-19 HLDEATH 1,2,3
          DB      $2A,$A8,$2A,$A8                        ;120-23 U,D HARPOON
          DB      $5A,$69,$6F,$BE,$69,$A5,$BE,$F9        ;124-31 POOKA:R1,2,L1,2
          DB      $2A,$50,$A9,$55,$05,$A8,$55,$6A        ;132-39 FYGAR:R1,2,L1,2
          DB      $20,$C2,$B3,$28,$08,$20,$0A,$A4        ;140-47 GHOST:P1,2,F1,2
          DB      $A6,$68,$A6,$A8,$A6,$6A                ;148-53 DDUP 1,2,3
          DB      $AE,$68,$AE,$A8,$AE,$6A                ;154-59 DDDOWN 1,2,3
          DB      $AA,$AA,$73,$55,$6F,$FA                ;160-65 SQUASH: DD,F,P
          DB      $55,$DD,$56,$5D,$00,$00                ;166-71 ROCK:STR,SP,CRM
          DB      $30,$30,$0C,$30,$00,$C0                ;172-77 DPMP,DFULL,U612
          DB      $FD,$F7,$77,$FF,$77,$77                ;178-83 200,300
          DB      $FF,$77,$77,$F7,$77,$77                ;184-89 500,800
          DB      $F7,$FD,$DD,$DF,$FD,$55,$DD,$DF        ;190-97 2500,4000
          DB      $FD,$DD,$DD,$DF,$FD,$DD,$DD,$DF        ;198-05 6000,8000
          DB      $FD,$DD,$DD,$DF                        ;206-09 10000
          DB      $F7,$DF,$77,$77                        ;210-13 12000
          DB      $F7,$F7,$77,$77                        ;214-17 15000
          DB      $FF,$77,$77,$7F                        ;218-21 1000
          DB      $00,$00                                ;222-23 ZBLANK
          DB      $15,$FC,$AF,$E9,$5A,$65,$AB,$43        ;224-31 RBPOOKA 1,2,3,4
          DB      $3F,$54,$6B,$FA,$59,$A5,$C1,$EA        ;232-39 LBPOOKA 1,2,3,4
          DB      $1F,$C0,$FF,$33,$A9,$54,$79,$7C        ;240-47 RBFYGAR 1,2,3,4
          DB      $03,$F4,$CC,$FF,$15,$6A,$3D,$6D        ;248-55 LBFYGAR 1,2,3,4


          ORG     $CA00                  ;LINE 6: OFFSET = 6.

***********       STAMPS WITHOUT ZERO PADDING

          DB      $25,$DD,$25,$DD,$25,$DD                ;0-5    DDRIGHT 1,2,3
          DB      $77,$58,$77,$58,$77,$58                ;6-11   DDLEFT 1,2,3
          DB      $E7,$33,$CC,$DB                        ;96-99  R,L FLAMEFYGAR
          DB      $AA,$A6,$9A,$AA                        ;100-03 R,L HARPOON
          DB      $69,$55                                ;20-21  R,L 4PIX FLAME
          DB      $59,$94,$16,$E9,$65,$05                ;22-27  8,16PIX RFLAME
          DB      $5B,$E9,$99,$95,$01,$64                ;28-33  24PIX RFLAME
          DB      $15,$48,$05,$50,$56,$54                ;34-39  8,16PIX LFLAME
          DB      $69,$00,$41,$5A,$AE,$AA                ;40-45  24PIX LFLAME
          DB      $5F,$00,$C3,$00,$C3,$00,$C3,$04        ;46-53  LPUMP24,R24->4
          DB      $00                                    ;54     (WIDTH OVERLAP)
          DB      $5F,$00,$C3,$00,$C3,$5F,$00,$C3,$00    ;55-63  LPUMP20,16
          DB      $5F,$00,$C3,$5F,$00,$5F                ;64-69  LPUMP12,8,4,OVR

          DB      $FF,$DD,$DD,$DF,$FF,$5D,$DD,$DF        ;70-77  2000,3000
          DB      $FD,$7D,$DD,$DF,$FF,$7D,$DD,$DF        ;78-85  5000,7000
          DB      $5D,$5D                                ;86-87  TOTRK
          DB      $50,$14                                ;88-89  LETRO
          DB      $50,$00,$55,$54,$50,$14,$50,$14        ;90-97  L,E,V,P

***********       ZERO PADDED STAMPS

          DB      $F7,$77,$77,$F5,$F7,$77                ;98-103 400,600
          DB      $30,$30                                ;104-05 UFULL,12 (PUMP)
          DB      $00,$00                                ;106-07 HDEATH S
          DB      $65,$DD,$97,$74,$A5,$55                ;108-13 HRDEATH 1,2,3
          DB      $77,$59,$1D,$D6,$55,$5A                ;114-19 HLDEATH 1,2,3
          DB      $2A,$A8,$2A,$A8                        ;120-23 U,D HARPOON
          DB      $6F,$BE,$AC,$CA,$BE,$F9,$A3,$3A        ;124-31 POOKA:R1,2,L1,2
          DB      $29,$54,$A7,$33,$15,$68,$CC,$DA        ;132-39 FYGAR:R1,2,L1,2
          DB      $2C,$CE,$B3,$28,$68,$29,$90,$06        ;140-47 GHOST:P1,2,F1,2
          DB      $AE,$68,$AE,$A8,$AE,$6A                ;148-53 DDUP 1,2,3
          DB      $A6,$68,$A6,$A8,$A6,$6A                ;154-59 DDDOWN 1,2,3
          DB      $2A,$A0,$3F,$54,$5A,$A9                ;160-65 SQUASH1: DD,F,P
          DB      $5D,$5D,$5E,$5D,$00,$00                ;166-71 ROCK:STR,SP,CRM
          DB      $00,$C0,$03,$C0,$30,$30                ;172-77 DPMP,DFULL,U612
          DB      $FF,$77,$77,$FD,$77,$77                ;178-83 200,300
          DB      $F5,$F7,$77,$FD,$F7,$77                ;184-89 500,800
          DB      $FD,$D7,$DD,$DF,$FD,$DD,$DD,$DF        ;190-97 2500,4000
          DB      $FD,$7D,$DD,$DF,$FF,$7D,$DD,$DF        ;198-05 6000,8000
          DB      $FD,$DD,$DD,$DF                        ;206-09 10000
          DB      $F7,$F7,$77,$77                        ;210-13 12000
          DB      $F7,$5F,$77,$77                        ;214-17 15000
          DB      $FF,$77,$77,$7F                        ;218-21 1000
          DB      $00,$00                                ;222-23 ZBLANK
          DB      $05,$50,$68,$B9,$AB,$E9,$AF,$F8        ;224-31 RBPOOKA 1,2,3,4
          DB      $05,$50,$6E,$29,$6B,$EA,$2F,$FA        ;232-39 LBPOOKA 1,2,3,4
          DB      $01,$70,$F3,$00,$A5,$54,$F5,$55        ;240-47 RBFYGAR 1,2,3,4
          DB      $0D,$40,$00,$CF,$15,$5A,$55,$5F        ;248-55 LBFYGAR 1,2,3,4


          ORG     $CB00                  ;LINE 5: OFFSET = 7.

***********       STAMPS WITHOUT ZERO PADDING

          DB      $A5,$DD,$A5,$DD,$A5,$DD                ;0-5    DDRIGHT 1,2,3
          DB      $77,$5A,$77,$5A,$77,$5A                ;6-11   DDLEFT 1,2,3
          DB      $AF,$00,$00,$FA                        ;96-99  R,L FLAMEFYGAR
          DB      $AA,$AA,$AA,$AA                        ;100-03 R,L HARPOON
          DB      $14,$1A                                ;20-21  R,L 4PIX FLAME
          DB      $14,$40,$05,$11,$15,$54                ;22-27  8,16PIX RFLAME
          DB      $14,$84,$55,$59,$56,$54                ;28-33  24PIX RFLAME
          DB      $55,$54,$54,$15,$6A,$F5                ;34-39  8,16PIX LFLAME
          DB      $19,$40,$56,$66,$6B,$E5                ;40-45  24PIX LFLAME
          DB      $10,$00,$C3,$00,$C3,$00,$C3,$00        ;46-53  LPUMP24,R24->4
          DB      $00                                    ;54     (WIDTH OVERLAP)
          DB      $10,$00,$C3,$00,$C3,$10,$00,$C3,$00    ;55-63  LPUMP20,16
          DB      $10,$00,$C3,$10,$00,$10                ;64-69  LPUMP12,8,4,OVR

          DB      $FD,$DD,$DD,$DF,$FD,$DD,$DD,$DF        ;70-77  2000,3000
          DB      $FD,$FD,$DD,$DF,$FF,$5D,$DD,$DF        ;78-85  5000,7000
          DB      $BD,$5D                                ;86-87  TOTRK
          DB      $50,$14                                ;88-89  LETRO
          DB      $50,$00,$50,$00,$50,$14,$50,$14        ;90-97  L,E,V,P

***********       ZERO PADDED STAMPS

          DB      $FD,$77,$77,$F7,$F7,$77                ;98-103 400,600
          DB      $3C,$3C                                ;104-05 UFULL,12 (PUMP)
          DB      $00,$00                                ;106-07 HDEATH S
          DB      $65,$DD,$97,$74,$94,$44                ;108-13 HRDEATH 1,2,3
          DB      $77,$59,$1D,$D6,$11,$16                ;114-19 HLDEATH 1,2,3
          DB      $2A,$A8,$2A,$A8                        ;120-23 U,D HARPOON
          DB      $AC,$CA,$AC,$CA,$A3,$3A,$A3,$3A        ;124-31 POOKA:R1,2,L1,2
          DB      $FF,$37,$AF,$00,$DC,$FF,$00,$FA        ;144-49 FYGAR:R1,2,L1,2
          DB      $0B,$F8,$BF,$E8,$B8,$2E,$A8,$2A        ;140-47 GHOST:P1,2,F1,2
          DB      $A6,$A8,$A6,$A8,$A6,$AA                ;148-53 DDUP 1,2,3
          DB      $AA,$68,$AA,$98,$AA,$68                ;154-59 DDDOWN 1,2,3
          DB      $0A,$A0,$07,$50,$15,$54                ;160-65 SQUASH1: DD,F,P
          DB      $5D,$5D,$5A,$5D,$00,$00                ;166-71 ROCK:STR,SP,CRM
          DB      $00,$C0,$03,$C0,$3C,$3C                ;172-77 DPMP,DFULL,U612
          DB      $F7,$77,$77,$FF,$77,$77                ;178-83 200,300
          DB      $F7,$F7,$77,$F7,$77,$77                ;184-89 500,800
          DB      $DD,$DF,$DD,$DF,$FF,$5D,$DD,$DF        ;190-97 2500,4000
          DB      $FD,$FD,$DD,$DF,$FD,$DD,$DD,$DF        ;198-05 6000,8000
          DB      $FD,$DD,$DD,$DF                        ;206-09 10000
          DB      $F7,$77,$77,$77                        ;210-13 12000
          DB      $F7,$7F,$77,$77                        ;214-17 15000
          DB      $FF,$77,$77,$7F                        ;218-21 1000
          DB      $00,$00                                ;222-23 ZBLANK
          DB      $00,$00,$5B,$8C,$A8,$89,$68,$B9        ;224-31 RBPOOKA 1,2,3,4
          DB      $00,$00,$32,$D5,$62,$2A,$6E,$29        ;232-39 LBPOOKA 1,2,3,4
          DB      $00,$50,$3F,$C0,$BD,$55,$FF,$74        ;240-47 RBFYGAR 1,2,3,4
          DB      $05,$00,$03,$FC,$55,$7E,$1D,$FF        ;248-55 LBFYGAR 1,2,3,4


          ORG     $CC00                  ;LINE 4: OFFSET = 8.

***********       STAMPS WITHOUT ZERO PADDING

          DB      $AA,$AA,$AA,$AA,$AA,$AA                ;0-5    DDRIGHT 1,2,3
          DB      $AA,$AA,$AA,$AA,$AA,$AA                ;6-11   DDLEFT 1,2,3
          DB      $F7,$CC,$33,$DF                        ;96-99  R,L FLAMEFYGAR
          DB      $AA,$AA,$AA,$AA                        ;100-03 R,L HARPOON
          DB      $00,$05                                ;20-21  R,L 4PIX FLAME
          DB      $00,$10,$00,$14,$40,$14                ;22-27  8,16PIX RFLAME
          DB      $00,$61,$01,$55,$54,$55                ;28-33  24PIX RFLAME
          DB      $55,$A5,$54,$16,$5A,$E5                ;34-39  8,16PIX LFLAME
          DB      $15,$95,$65,$55,$12,$14                ;40-45  24PIX LFLAME
          DB      $00,$00,$3C,$00,$3C,$00,$3C,$00        ;46-53  LPUMP24,R24->4
          DB      $00                                    ;54     (WIDTH OVERLAP)
          DB      $00,$00,$3C,$00,$3C,$00,$00,$3C,$00    ;55-63  LPUMP20,16
          DB      $00,$00,$3C,$00,$00,$00                ;64-69  LPUMP12,8,4,OVR

          DB      $FF,$7F,$77,$7F,$FF,$7F,$77,$7F        ;70-77  2000,3000
          DB      $FD,$5F,$77,$7F,$FD,$5F,$77,$7F        ;78-85  5000,7000
          DB      $29,$7D                                ;86-87  TOTRK
          DB      $50,$14                                ;88-89  LETRO
          DB      $50,$00,$50,$00,$50,$14,$50,$14        ;90-97  L,E,V,P

***********       ZERO PADDED STAMPS

          DB      $FF,$7D,$DF,$FD,$7D,$DF                ;98-103 400,600
          DB      $0C,$0C                                ;104-05 UFULL,12 (PUMP)
          DB      $11,$10                                ;106-07 HDEATH S
          DB      $6A,$AA,$AA,$A8,$AA,$A8                ;108-13 HRDEATH 1,2,3
          DB      $AA,$A9,$2A,$AA,$2A,$AA                ;114-19 HLDEATH 1,2,3
          DB      $2A,$68,$2A,$A8                        ;120-23 U,D HARPOON
          DB      $AC,$CA,$6F,$FA,$A3,$3A,$AF,$F9        ;124-31 POOKA:R1,2,L1,2
          DB      $F7,$CC,$57,$CC,$33,$DF,$33,$DF        ;132-39 FYGAR:R1,2,L1,2
          DB      $02,$A0,$2A,$A0,$B8,$2E,$B8,$2E        ;140-47 GHOST:P1,2,F1,2
          DB      $AE,$A8,$AE,$AA,$AE,$AA                ;148-53 DDUP 1,2,3
          DB      $29,$6A,$2A,$5A,$29,$68                ;154-59 DDDOWN 1,2,3
          DB      $00,$00,$00,$00,$00,$00                ;160-65 SQUASH1: DD,F,P
          DB      $BD,$7D,$BA,$BD,$00,$00                ;166-71 ROCK:STR,SP,CRM
          DB      $00,$C0,$03,$C0,$0C,$0C                ;172-77 DPMP,DFULL,U612
          DB      $FD,$FD,$DF,$F5,$FD,$DF                ;178-83 200,300
          DB      $F5,$7D,$DF,$FD,$FD,$DF                ;184-89 500,800
          DB      $F7,$D5,$F7,$7F,$FF,$DF,$77,$7F        ;190-97 2500,4000
          DB      $FF,$5F,$77,$7F,$FD,$DF,$77,$7F        ;198-05 6000,8000
          DB      $FD,$F7,$77,$7F                        ;206-09 10000
          DB      $F7,$DF,$DD,$DF                        ;210-13 12000
          DB      $F7,$57,$DD,$DF                        ;214-17 15000
          DB      $FF,$7D,$DD,$FF                        ;218-21 1000
          DB      $00,$00                                ;222-23 ZBLANK
          DB      $00,$00,$15,$FC,$68,$8C,$5B,$8C        ;224-31 RBPOOKA 1,2,3,4
          DB      $00,$00,$3F,$54,$32,$29,$32,$E5        ;232-39 LBPOOKA 1,2,3,4
          DB      $00,$00,$0F,$5C,$F7,$33,$33,$16        ;240-47 RBFYGAR 1,2,3,4
          DB      $00,$00,$35,$F0,$CC,$DF,$94,$CC        ;248-55 LBFYGAR 1,2,3,4


          ORG     $CD00                  ;LINE 3: OFFSET = 9.

***********       STAMPS WITHOUT ZERO PADDING

          DB      $2A,$A0,$2A,$A0,$2A,$A0                ;0-5    DDRIGHT 1,2,3
          DB      $0A,$A8,$0A,$A8,$0A,$A8                ;6-11   DDLEFT 1,2,3
          DB      $73,$55,$55,$CD                        ;96-99  R,L FLAMEFYGAR
          DB      $AA,$AA,$AA,$AA                        ;100-03 R,L HARPOON
          DB      $00,$00                                ;20-21  R,L 4PIX FLAME
          DB      $00,$00,$00,$00,$00,$41                ;22-27  8,16PIX RFLAME
          DB      $00,$15,$00,$05,$55,$45                ;28-33  24PIX RFLAME
          DB      $16,$65,$45,$55,$11,$14                ;34-39  8,16PIX LFLAME
          DB      $55,$15,$55,$40,$49,$00                ;40-45  24PIX LFLAME
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;46-53  LPUMP24,R24->4
          DB      $00                                    ;54     (WIDTH OVERLAP)
          DB      $00,$00,$00,$00,$00,$00,$00,$00,$00    ;55-63  LPUMP20,16
          DB      $00,$00,$00,$00,$00,$00                ;64-69  LPUMP12,8,4,OVR

          DB      $3F,$FF,$FF,$FC,$3F,$FF,$FF,$FC        ;70-77  2000,3000
          DB      $3F,$FF,$FF,$FC,$3F,$FF,$FF,$FC        ;78-85  5000,7000
          DB      $09,$56                                ;86-87  TOTRK
          DB      $55,$54                                ;88-89  LETRO
          DB      $50,$00,$55,$54,$50,$14,$55,$54        ;90-97  L,E,V,P

***********       ZERO PADDED STAMPS

          DB      $3F,$FF,$FC,$3F,$FF,$FC                ;98-103 400,600
          DB      $03,$03                                ;104-05 UFULL,12 (PUMP)
          DB      $41,$04                                ;106-07 HDEATH S
          DB      $5A,$A5,$6A,$80,$2A,$80                ;108-13 HRDEATH 1,2,3
          DB      $5A,$A5,$02,$A9,$02,$A8                ;114-19 HLDEATH 1,2,3
          DB      $2A,$68,$2A,$A8                        ;120-23 U,D HARPOON
          DB      $6F,$FA,$5A,$A9,$AF,$F9,$6A,$A5        ;124-31 POOKA:R1,2,L1,2
          DB      $73,$55,$73,$55,$55,$CD,$55,$CD        ;132-39 FYGAR:R1,2,L1,2
          DB      $00,$00,$00,$00,$B8,$2E,$B8,$2E        ;140-47 GHOST:P1,2,F1,2
          DB      $26,$AA,$26,$AA,$26,$A6                ;148-53 DDUP 1,2,3
          DB      $29,$AA,$29,$6A,$29,$A4                ;154-59 DDDOWN 1,2,3
          DB      $00,$00,$00,$00,$00,$00                ;160-65 SQUASH1: DD,F,P
          DB      $29,$56,$20,$95,$00,$00                ;166-71 ROCK:STR,SP,CRM
          DB      $00,$30,$0C,$30,$0C,$0C                ;172-77 DPMP,DFULL,U612
          DB      $3F,$FF,$FC,$3F,$FF,$FC                ;178-83 200,300
          DB      $3F,$FF,$FC,$3F,$FF,$FC                ;184-89 500,800
          DB      $3F,$FF,$FF,$FC,$3F,$FF,$FF,$FC        ;190-97 2500,4000
          DB      $3F,$FF,$FF,$FC,$FF,$7F,$FF,$FF        ;198-05 6000,8000
          DB      $3F,$FF,$FF,$FC                        ;206-09 10000
          DB      $3F,$FF,$FF,$FC                        ;210-13 12000
          DB      $3F,$FF,$FF,$FC                        ;214-17 15000
          DB      $3F,$FF,$FF,$FC                        ;218-21 1000
          DB      $00,$00                                ;222-23 ZBLANK
          DB      $00,$00,$05,$50,$1A,$FC,$15,$FC        ;224-31 RBPOOKA 1,2,3,4
          DB      $00,$00,$05,$50,$3F,$A4,$3F,$54        ;232-39 LBPOOKA 1,2,3,4
          DB      $00,$00,$00,$54,$73,$CC,$1F,$CD        ;240-47 RBFYGAR 1,2,3,4
          DB      $00,$00,$15,$00,$33,$CD,$73,$F4        ;248-55 LBFYGAR 1,2,3,4


          ORG     $CE00                  ;LINE 2: OFFSET = 10.

***********       STAMPS WITHOUT ZERO PADDING

          DB      $0A,$A0,$0A,$A0,$0A,$A0                ;0-5    DDRIGHT 1,2,3
          DB      $0A,$A0,$0A,$A0,$0A,$A0                ;6-11   DDLEFT 1,2,3
          DB      $3F,$54,$15,$FC                        ;96-99  R,L FLAMEFYGAR
          DB      $AA,$A8,$2A,$AA                        ;100-03 R,L HARPOON
          DB      $00,$00                                ;20-21  R,L 4PIX FLAME
          DB      $00,$00,$00,$00,$00,$00                ;22-27  8,16PIX RFLAME
          DB      $00,$00,$40,$00,$50,$01                ;28-33  24PIX RFLAME
          DB      $01,$14,$45,$00,$45,$00                ;34-39  8,16PIX LFLAME
          DB      $51,$55,$50,$00,$54,$00                ;40-45  24PIX LFLAME
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;46-53  LPUMP24,R24->4
          DB      $00                                    ;54     (WIDTH OVERLAP)
          DB      $00,$00,$00,$00,$00,$00,$00,$00,$00    ;55-63  LPUMP20,16
          DB      $00,$00,$00,$00,$00,$00                ;64-69  LPUMP12,8,4,OVR

          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;70-77  2000,3000
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;78-85  5000,7000
          DB      $01,$74                                ;86-87  TOTRK
          DB      $15,$50                                ;88-89  LETRO
          DB      $50,$00,$15,$54,$50,$14,$95,$50        ;90-97  L,E,V,P

***********       ZERO PADDED STAMPS

          DB      $00,$00,$00,$00,$00,$00                ;98-103 400,600
          DB      $03,$03                                ;104-05 UFULL,12 (PUMP)
          DB      $01,$00                                ;106-07 HDEATH S
          DB      $1A,$A5,$2A,$80,$2A,$80                ;108-13 HRDEATH 1,2,3
          DB      $5A,$A4,$02,$A8,$02,$A8                ;114-19 HLDEATH 1,2,3
          DB      $29,$58,$2A,$68                        ;120-23 U,D HARPOON
          DB      $5A,$A9,$15,$54,$6A,$A5,$15,$54        ;124-31 POOKA:R1,2,L1,2
          DB      $3F,$54,$3F,$54,$15,$FC,$15,$FC        ;132-39 FYGAR:R1,2,L1,2
          DB      $00,$00,$00,$00,$A8,$2A,$B8,$2E        ;140-47 GHOST:P1,2,F1,2
          DB      $24,$AA,$25,$AA,$24,$A4                ;148-53 DDUP 1,2,3
          DB      $05,$90,$05,$90,$05,$90                ;154-59 DDDOWN 1,2,3
          DB      $00,$00,$00,$00,$00,$00                ;160-65 SQUASH1: DD,F,P
          DB      $09,$74,$00,$A5,$00,$00                ;166-71 ROCK:STR,SP,CRM
          DB      $00,$3C,$3C,$3C,$15,$15                ;172-77 DPMP,DFULL,U612
          DB      $00,$00,$00,$00,$00,$00                ;178-83 200,300
          DB      $00,$00,$00,$00,$00,$00                ;184-89 500,800
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;190-97 2500,4000
          DB      $00,$00,$00,$00,$3F,$FF,$FF,$FC        ;198-05 6000,8000
          DB      $00,$00,$00,$00                        ;206-09 10000
          DB      $00,$00,$00,$00                        ;210-13 12000
          DB      $00,$00,$00,$00                        ;214-17 15000
          DB      $00,$00,$00,$00                        ;218-21 1000
          DB      $00,$00                                ;222-23 ZBLANK
          DB      $00,$00,$00,$00,$05,$50,$05,$50        ;224-31 RBPOOKA 1,2,3,4
          DB      $00,$00,$00,$00,$05,$50,$05,$50        ;232-39 LBPOOKA 1,2,3,4
          DB      $00,$00,$00,$00,$3F,$54,$0F,$51        ;240-47 RBFYGAR 1,2,3,4
          DB      $00,$00,$00,$00,$15,$FC,$45,$F0        ;248-55 LBFYGAR 1,2,3,4


          ORG     $CF00                  ;TOP SCAN LINE: OFFSET = 11.

***********       STAMPS WITHOUT ZERO PADDING

          DB      $00,$00,$00,$00,$00,$00                ;0-5    DDRIGHT 1,2,3
          DB      $00,$00,$00,$00,$00,$00                ;6-11   DDLEFT 1,2,3
          DB      $07,$50,$05,$D0                        ;96-99  R,L FLAMEFYGAR
          DB      $00,$00,$00,$00                        ;100-03 R,L HARPOON
          DB      $00,$00                                ;20-21  R,L 4PIX FLAME
          DB      $00,$00,$00,$00,$00,$00                ;22-27  8,16PIX RFLAME
          DB      $00,$00,$00,$00,$00,$00                ;28-33  24PIX RFLAME
          DB      $04,$00,$10,$40,$00,$00                ;34-39  8,16PIX LFLAME
          DB      $04,$05,$00,$01,$00,$00                ;40-45  24PIX LFLAME
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;46-53  LPUMP24,R24->4
          DB      $00                                    ;54     (WIDTH OVERLAP)
          DB      $00,$00,$00,$00,$00,$00,$00,$00,$00    ;55-63  LPUMP20,16
          DB      $00,$00,$00,$00,$00,$00                ;64-69  LPUMP12,8,4,OVR

          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;70-77  2000,3000
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;78-85  5000,7000
          DB      $00,$F4                                ;86-87  TOTRK
          DB      $00,$00                                ;88-89  LETRO
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;90-97  L,E,V,P

***********       ZERO PADDED STAMPS

          DB      $00,$00,$00,$00,$00,$00                ;98-103 400,600
          DB      $03,$03                                ;104-05 UFULL,12 (PUMP)
          DB      $00,$00                                ;106-07 HDEATH S
          DB      $00,$00,$00,$00,$00,$00                ;108-13 HRDEATH 1,2,3
          DB      $00,$00,$00,$00,$00,$00                ;114-19 HLDEATH 1,2,3
          DB      $0A,$60,$2A,$68                        ;120-23 U,D HARPOON
          DB      $15,$54,$00,$00,$15,$54,$00,$00        ;124-31 POOKA:R1,2,L1,2
          DB      $07,$50,$07,$50,$05,$D0,$05,$D0        ;132-39 FYGAR:R1,2,L1,2
          DB      $00,$00,$00,$00,$A0,$0A,$68,$29        ;140-47 GHOST:P1,2,F1,2
          DB      $24,$A2,$25,$A2,$24,$A0                ;148-53 DDUP 1,2,3
          DB      $00,$00,$00,$00,$00,$00                ;154-59 DDDOWN 1,2,3
          DB      $00,$00,$00,$00,$00,$00                ;160-65 SQUASH1: DD,F,P
          DB      $02,$F4,$00,$24,$00,$00                ;166-71 ROCK:STR,SP,CRM
          DB      $00,$0C,$30,$0C,$04,$04                ;172-77 DPMP,DFULL,U612
          DB      $00,$00,$00,$00,$00,$00                ;178-83 200,300
          DB      $00,$00,$00,$00,$00,$00                ;184-89 500,800
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;190-97 2500,4000
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;198-05 6000,8000
          DB      $00,$00,$00,$00                        ;206-09 10000
          DB      $00,$00,$00,$00                        ;210-13 12000
          DB      $00,$00,$00,$00                        ;214-17 15000
          DB      $00,$00,$00,$00                        ;218-21 1000
          DB      $00,$00                                ;222-23 ZBLANK
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;224-31 RBPOOKA 1,2,3,4
          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;232-39 LBPOOKA 1,2,3,4
          DB      $00,$00,$00,$00,$07,$50,$00,$54        ;240-47 RBFYGAR 1,2,3,4
          DB      $00,$00,$00,$00,$05,$D0,$15,$00        ;248-55 LBFYGAR 1,2,3,4
ENDCHARS
          END
