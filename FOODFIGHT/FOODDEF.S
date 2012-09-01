; FOODDEF.S
; THIS ROUTINE CONTAINS DEFINITIONS FOR:
;         ALL TIA REGISTERS;
;         ALL MARIA REGISTERS;
;         ALL 6532 TIMERS AND PORTS;
;         ALL OF THE VARIABLES USED;
;         ALL OF THE SYMBOLIC CONSTANTS USED.

; USED BY "WALLDRAW.S":

          GLBL    RNDSTA,RNDSTA2,RNDCMP,RNDCMP2
          GLBL    XDMAON,XDMAOFF
          GLBL    LISTPTR
          GLBL    ULCORNER,URCORNER,LLCORNER,LRCORNER,LWALL,RWALL,WHORIZ
          GLBL    CORNPALW,WALLPALW,SIDEPALW,XRIGHT,XLEFT,TOPWHGH,BOTWHGH
          GLBL    TEMP3,TEMPY,BLOCK2
          GLBL    LISTSTRT
          GLBL    STATUS,NUMFOOD
          GLBL    MODE,FOODSTUF
          GLBL    FPRESET,FPSELECT,FPPAUSE
          GLBL    PSREADY,SELREADY,RESREADY,THREADY

; USED BY FOODMOVE.A
          GLBL    THRWTUFF               to get it in symbol table
          GLBL    CHSTAMP,BLOCK1,SYSCOUNT,THRWTIME
          GLBL    NEXTPILE,LASTPILE,FINFO,FSTATE,NUMEPILE,PILESTRT
          GLBL    FXPOS,FYPOS,CSPEED,CFRAME,CTYPE,CFLYTIME,CYPOS
          GLBL    CSINDEX
          GLBL    CSTATE,FLYING,STATHIT,CDIR,CXPOS,TEMPX
          GLBL    DEAD,WON,CACOUNT,CSTAMP,CPALW,CINFO,STATBON
          GLBL    STATDIE,FOODSTRT,NUMINAIR,ALLGONE,SPLAT,HSPLAT
          GLBL    ANGLE,STICKING,NUMSTUCK
          GLBL    CXSPEED,CXSPEEDL,CYSPEED,CYSPEEDL
          GLBL    CXPOSL,CYPOSL
          GLBL    TEMP2,TEMP4,TEMP5,TEMP6
          GLBL    STATEND,STATENDR


; USED BY FOODHIT.A
          GLBL    FALLING,YCENTER,TEMP0
          GLBL    CREATOR,DYCHAR,DXCHAR
          GLBL    TEMP1,CARRYING,HELDFOOD,RETREAT,LEAVING,RLEAVING
          GLBL    NUMCHHIT,NUMFALL
          GLBL    LASTCHEF

; USED BY SOUND.A
          GLBL    TBASE,TBASEH,VBASE,VBASEH,CBASE,CBASEH
          GLBL    VOLTABL,FREQTABL
          GLBL    DCH0,DCH1,TUNNUM,TUNNUM1,TINDEX0,TINDEX1,CINDEX0
          GLBL    VINDEX0,VINDEX1,MPTRL,MPTRH,TUNTEMP
          GLBL    AUDV0,AUDV1,STATATTR,AUDF0,AUDC0
          GLBL    IRTNDONE

; USED BY HOLEHIT.A

          GLBL    NUMHOLES,DYHOLE,DXHOLE,FSPEED,RUNNING
          GLBL    FEETRISE,FEETFALL,STATDIEH,CSECOND,HATHITE,HEADHITE,REJOYING
          GLBL    CHEFSTRT,PL0LIVES,PLLIVES
          GLBL    HOLEUSED

; CONEHIT.A
          GLBL    XCLOSE,STATWON,PL0CARRY,P1C3
          GLBL    CARRIED
          GLBL    DXHERO,DYHERO

; CHEFHIT.A
          GLBL    GOALX,GOALY,NULLCHAR,FRAMECNT
          GLBL    IRCHTIME,IRDXHERO,IRDYHERO

; INPUT.S
          GLBL    TRUE,FALSE
          GLBL    SWCHA,SWCHB,INPT4
          GLBL    THROWBUT,JOYDIR
          GLBL    OLDDIR,STATPLAY
          GLBL    CYCLEIDX,THROWIDX,IRDIRA,IRDIRB,IRTHROW,IRCCNT
          GLBL    IRDIRC,IRDIRD
          GLBL    CYCLECNT
          GLBL    STATCOMB

; MAIN.S
          GLBL    GAMECNT
          GLBL    INTIM,CTLSWA,CTLSWB,HIGHSCOR,M160X2,CTRL,MSTAT
          GLBL    MNODMA
          GLBL    M2BYTE
          GLBL    STATINIT,STATWAIT,PL0RACK,PL1RACK
          GLBL    PLBANAN
          GLBL    PL0FIRST,PL1FIRST,PLFIRST
          GLBL    PL0IRTIM,PL1IRTIM
          GLBL    PL1LIVES,PL0SCORE,PL1SCORE,PL1CARRY
          GLBL    PL0BONUS,PL1BONUS
          GLBL    PL0BCD,PL1BCD
          GLBL    PLRACK,PLCARRY,PLBCD
          GLBL    RANDOM0,RANDOM1,RANDOM2,CMAP1,SCORELST,CMAPHIGH
          GLBL    RANDSEED,RANDJ,RANDK
          GLBL    CMAP2,CLOWMAP1,CLOWMAP2,STATLIST,CHARBASE,NULL2
          GLBL    TXTLIST1,TXTLIST2,TXTLIST3
          GLBL    BACKCOLR,BACKGRND,P0C1,STATLOGO,P1C1,P1C2
          GLBL    COLORS
          GLBL    P5C1,P5C2,P5C3
          GLBL    DLIST0,DLIST1,DLIST2,DLIST3,DLIST4,DLIST5,DLIST6
          GLBL    DLIST7,DLIST8,DLIST9,DLIST10
          GLBL    DLISTA,DLISTB
          GLBL    DLLRAM,DPPL,DPPH,DLIADR,P0C2,M320X1
          GLBL    P0C3
          GLBL    STATREPL
          GLBL    STHEADCH
          GLBL    DOITOVER
          GLBL    HTHROW,HJOYDIR
          GLBL    OTHER,CURRENT,PLAYNUM,PLMESS
          GLBL    HOWHARD,HIGHEST,OLDHIGH
          GLBL    WAITCNT

          GLBL    DRIPTIME
          GLBL    RUNLOAD,OLDFCNT
          GLBL    WSYNC
          GLBL    OFFSET

; FOR GOD.S

          GLBL    MGAME,MLOGO,MATTRACT,MHISCORE,MENDGAME,MENTER,MPAUSE
          GLBL    NUMCYCLE,MAXCYCLE
          GLBL    MBLANK,MSELECT

; FOR TEXT.S

          GLBL    LISTSIZE,LISTPTRA
          GLBL    MTEXT
          GLBL    HSCRAM

; FOR ATTRACT.S

          GLBL    AIRDIRA,AIRDIRB,AIRDIRC,AIRDIRD,AIRTHROW
          GLBL    ASET

* TIA REGISTERS
INPT4     EQU     $0C                    ;BUTTONS
INPT5     EQU     $0D
AUDC0     EQU     $15      ;BITS     3210 AUDIO CONTROL 0
AUDC1     EQU     $16      ;BITS     3210 AUDIO CONTROL 1
AUDF0     EQU     $17      ;BITS     3210 AUDIO FREQUENCY 0
AUDF1     EQU     $18      ;BITS     3210 AUDIO FREQUENCY 1
AUDV0     EQU     $19      ;BITS     3210 AUDIO VOLUME 0
AUDV1     EQU     $1A      ;BITS     3210 AUDIO VOLUME 1


* MARIA REGISTERS
          ORG     $20
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
DPPH      EQU     $2C                    ;DISPLAY LIST LIST POINTER HIGH   WO
P3C1      EQU     $2D                    ;PALETTE THREE COLOR ONE           RW
P3C2      EQU     $2E                    ;PALETTE THREE COLOR TWO           RW
P3C3      EQU     $2F                    ;PALETTE THREE COLOR THREE         RW
DPPL      EQU     $30                    ;DISPLAY LIST LIST POINTER LOW    WO
P4C1      EQU     $31                    ;PALETTE FOUR COLOR ONE            RW
P4C2      EQU     $32                    ;PALETTE FOUR COLOR TWO            RW
P4C3      EQU     $33                    ;PALETTE FOUR COLOR THREE          RW
CHARBASE  EQU     $34                    :CHARACTER MODE HIGH POINTER       WO
P5C1      EQU     $35                    ;PALETTE FIVE COLOR ONE            RW
P5C2      EQU     $36                    ;PALETTE FIVE COLOR TWO            RW
P5C3      EQU     $37                    ;PALETTE FIVE COLOR THREE          RW
OFFSET    EQU     $38                    ;OLD-- STORE ZERO HERE ALWAYS      RW
P6C1      EQU     $39                    ;PALETTE SIX COLOR ONE             RW
P6C2      EQU     $3A                    ;PALETTE SIX COLOR TWO             RW
P6C3      EQU     $3B                    ;PALETTE SIX COLOR THREE           RW
CTRL      EQU     $3C            ;?????? ;BIT 7  CHARACTER WIDTH,BIT 6 BCNT WO
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
;         BIT 3   BLACK & WHITE/COLOR  COLOR WHEN SET
;         BIT 1   GAME SELECT  CLEAR WHEN PRESSED
;         BIT 0   GAME RESET   CLEAR WHEN PRESSED

CTLSWA    EQU     $281
CTLSWB    EQU     $283
INTIM     EQU     $284  ;INTERVAL TIMER IN
TIM8T     EQU     $295  ;TIMER 8T WRITE OUT
TIM64T    EQU     $296  ;TIMER 64T WRITE OUT
TIM64TI   EQU     $29E  ;INTERUPT TIMER 64T

********************************************************************************
*                 ZERO PAGE RAM  40-FF                                         *
*         93 BYTES CURRENTLY STORED HERE !                                     *
********************************************************************************

NUMZONES  EQU     11

          ORG     $40

DLIADR    EQU     $40                    ; JMP INDIRECT FROM NMI VECTOR

LISTPTR   EQU     $42                    ; USED IN LOADER AS A DLIST POINTER
LISTPTRA  EQU     $44

LISTSIZE  EQU     $46                    ; MUST BE IN ZERO PAGE, SO THAT
                                         ; "STY   LISTSIZE,X" WORKS
LISTSTRT  EQU     LISTSIZE+NUMZONES      ; BEGINNING OF MOVING CHAR INFO

TEMP0     EQU     $5C
TEMP1     EQU     TEMP0+1
TEMP2     EQU     TEMP0+2
TEMP3     EQU     TEMP0+3
TEMP4     EQU     TEMP0+4
TEMP5     EQU     TEMP0+5
TEMP6     EQU     TEMP0+6
KTEMP0    EQU     TEMP0+7                ; USED FOR SOUND DRIVER
KTEMP1    EQU     TEMP0+8

RANDOM0   EQU     $65                    ; THESE ARE USED BY RANDOM ROUTINES
RANDOM1   EQU     RANDOM0+1
RANDOM2   EQU     RANDOM0+2

TEMPX     EQU     $68                    ; USED FOR INDEX REGISTERS
TEMPY     EQU     TEMPX+1

LTEMPY    EQU     $6A                    ; FOR THE LOADER
LSECOND   EQU     LTEMPY+1               ; USED FOR OVERLAP TEST
TEMPYPOS  EQU     LTEMPY+2               ; ALSO FOR THE LOADER
HIGHPOS   EQU     LTEMPY+3               ; USED BY THE LOADER FOR HIGH BYTE

RTEMPX    EQU     $6E
RTEMPY    EQU     RTEMPX+1               ; FOR RANDOM ROUTINES

RTEMP0    EQU     HIGHPOS+3
RTEMP1    EQU     HIGHPOS+4

HEADER0   EQU     $72                    ; LOADER : TEMP STORAGE FOR HEADER
HEADER1   EQU     HEADER0+1              ;   BYTES
HEADER2   EQU     HEADER0+2
HEADER3   EQU     HEADER0+3

FRAMECNT  EQU     $76                    ; ONE PER VBLANK
OLDFCNT   EQU     FRAMECNT+1
CYCLECNT  EQU     FRAMECNT+2             ; ONE PER GAMEPLAY CYCLE
NUMCYCLE  EQU     FRAMECNT+3
MAXCYCLE  EQU     FRAMECNT+4

SYSCOUNT  EQU     FRAMECNT+5

STATUS    EQU     FRAMECNT+7
MODE      EQU     FRAMECNT+8

; 63 BYTES UP TO THIS POINT.

; NOTE "TOTALCH" WAS EQU $20 AND "TOTALCHR" DID NOT EXIST.
TOTALCH   EQU     $20                    ; 32 MOVING CHARS (ROB 6.14.84)
TOTALCHR  EQU     $20                    ; 32 OBJECTS RESERVED (ROB 6.14.84)
TOTALFX   EQU     $1B                    ; 27 FIXED OBJECTS PER SCREEN

CSTATE    EQU     $7F                    ; 32 BYTES EACH
CYPOS     EQU     CSTATE+TOTALCHR
CXPOS     EQU     CYPOS+TOTALCHR

; 159 BYTES UP TO THIS POINT

PLAYNUM   EQU     $DF                    ; TRUE IF TWO-PLAYER
CURRENT   EQU     $E0                    ; TELLS WHICH PLAYER

RUNLOAD   EQU     $E1                    ; WHETHER TO RUN LOADER OR NOT

GODPTR    EQU     $E2                    two bytes

; added late-- Jan. 30, 1984

GAMECNT   EQU     $E4
WAITCNT   EQU     $E5
OTHER     EQU     $E6
HOWHARD   EQU     $E7
HIGHEST   EQU     $E8                    two bytes

PLRACK    EQU     $EA
PLCARRY   EQU     $EB
PLLIVES   EQU     $EC
PLBCD     EQU     $ED                    two bytes

PSREADY   EQU     $EF
RESREADY  EQU     $F0
SELREADY  EQU     $F1
THREADY   EQU     $F2                    ; USED BY "SELECT"

GOALX     EQU     $F3
GOALY     EQU     $F4

CYCLEIDX  EQU     $F5                     ; AT RACK START, EQUALS 0
THROWIDX  EQU     $F7

THROWBUT  EQU     $F8                     ; FOR PURPOSE OF GAMEPLAY
JOYDIR    EQU     $F9

HJOYDIR   EQU     $FA                     ; CONTROLLER STATUS
HTHROW    EQU     $FB

DOITOVER  EQU     $FC

FPRESET   EQU     $FD
FPSELECT  EQU     $FE
FPPAUSE   EQU     $FF

********************************************************************************
*                                                                              *
*         FIRST PAGE RAM-- 140--1FF                                            *
*         THE STACK STARTS AT 1FF                                              *
*
********************************************************************************

          ORG     $140


; END OF PAGE 1 RAM

********************************************************************************
; RAM--   1800 TO 2800
; SOME OF THIS RAM IS SHADOWED ELSEWHERE:
;         2040-20FF IS A SHADOW OF 40-FF
;         2140-21FF IS A SHADOW OF 140-1FF
********************************************************************************

; SINCE THE LARGEST CONTIGUOUS BLOCK OF RAM IS 1800-2000 (2K),
;         PLACE ALL DISPLAY LISTS AND INSTANT REPLAY ARRAYS HERE.

          ORG     $1800

; DISPLAY LISTS FIRST-- REQUIRES 1261 BYTES, 1800-1CED

DLSIZE    EQU     $72                     ; ENOUGH FOR 20 HEADERS + EOL
SCORESIZ  EQU     $11                    ; ENOUGH FOR 3 HEADERS + 2
STATSIZE  EQU     $0C                    ; 2 HEADERS + 2
BLOCK1    EQU     $A0                    ; FIRST 16 PAGES
BLOCK2    EQU     $E0                    ; NEXT 16 PAGES
STAMPHGH  EQU     $A0                    ; OLD CONSTANT FOR FIRST 16 PAGES

; DISPLAY LISTS TAKE UP A TOTAL OF (11) * (114) + 7 = 1261 BYTES
;         ALSO USE THIS AREA FOR THE HIGH SCORE TABLES; MAKE SURE
;         THAT THE 2 PAGES (512 BYTES) DON'T EXTEND INTO DLIST8 AND DLIST9

HSCRAM
DLIST0    DS      DLSIZE
DLIST1    DS      DLSIZE
DLIST2    DS      DLSIZE
DLIST3    DS      DLSIZE
DLIST4    DS      DLSIZE
DLIST5    DS      DLSIZE+5               ; IN CASE OF TEXT
DLIST6    DS      DLSIZE+5
DLIST7    DS      DLSIZE+5
DLIST8    DS      DLSIZE
DLIST9    DS      DLSIZE
DLIST10   DS      DLSIZE
DLISTA    DS      5                      ; SETS WRITE MODE
DLISTB    DS      2                      ; NULL DLIST

********************************************************************************
*         ORG     $1CED                  ; FIRST RAM AFTER DLISTS
*
*         (PLACE INSTANT REPLAY TABLES HERE)
********************************************************************************

; INSTANT REPLAY TABLES-- (1CE6-1F7A)

IRCCNT    DS      1                      ; "FRAMECNT" VALUE AT RACK START
IRAND0    DS      1                      ; VALUES AT RACK START
IRAND1    DS      1
IRCARRY   DS      1                      ; TELLS IF HE WAS CARRYING

AIRCCNT   DS      1                      values for the awesome IR
AIRAND0   DS      1
AIRAND1   DS      1
AIRCARRY  DS      1
AIRLEVEL  DS      1                      tells which level this was
AIRBCD    DS      1

IRTNDONE  DS      1

; Note: these were changed 1/24/84 to reflect half the old polling rate.
;         It's now once every 4 cycles, rather than every 2.

IRDIRA    DS      $40                    ; 128 EACH = 8 SECONDS
IRDIRB    DS      $40
IRDIRC    DS      $40
IRDIRD    DS      $40

IRTHROW   DS      $40

IRCHTIME  DS      2                      ; HOW LONG NEAR CHEFS ?

AIRDIRA   DS      $40                    last instant replay gets stored here
AIRDIRB   DS      $40                    for attract mode
AIRDIRC   DS      $40
AIRDIRD   DS      $40

AIRTHROW  DS      $40

ASET      DS      1                      flag will be set if A tables set

; AFTER INSTANT REPLAY TABLES:
;         SHOULD BE $1F7C

DLLRAM    DS      57                     ; ENOUGH ROOM FOR 19 ENTRIES

COLORS    DS      31                     need 4*7 + 3

; FREE SPACE SHOULD BE AT $1Fcd

********************************************************************************
*         2200-27FF
*         LAST LARGE BLOCK OF MEMORY
*         863 BYTES CURRENTLY STORED HERE (2200-255F)
*
********************************************************************************

          ORG     $2200

SCORELST  DS      SCORESIZ               ; TABLE FOR SCORE INFO
STATLIST  DS      STATSIZE               ; TABLE FOR LEVEL AND LIVES REMAINING

TXTLIST1  DS      14                    ; NUMBER OF LETTERS EACH
TXTLIST2  DS      15                     ; "INSTANT REPLAY"-- LONGEST STRING
TXTLIST3  DS      14                     ; "LET'S SEE THAT"

CMAP1     DS      $08                    ; PLAYER 1 SCORE
CMAP2     DS      $08                    ; PLAYER 2 SCORE
CMAPHIGH  DS      $08                    ; HIGH SCORE

CLOWMAP1  DS      $11                    ; CHUCKS REMAINING (ROOM FOR 6)
                                         ;  5X3 + 2
CLOWMAP2  DS      $12                    ; 18 (LEVEL NNN = 9 CHARACTERS)

;MOVING CHARACER INFORMATION

NUMFOOD   EQU     $10                    ; CHANGED FROM $10 -ROB 6-13-84

; ALL MOVING CHARACTERS HAVE THEIR INFO STORED HERE.  THERE ARE TABLES FOR:
;         STATE (CSTATE): STATUS INFORMATION FOR A CHARACTER;
;   NOTE-- CSTATE, CYPOS, CXPOS ARE ALL IN ZERO PAGE
;         STAMP CHARACTER (CSTAMP): A POINTER TO THE ROM TABLE FOR THE CHAR;
;         PALETTE/WIDTH (CPALW): 2ND BYTE OF THE HEADER (3 BIT PALETTE);
;         COORDINATES (CXPOS, CYPOS): POSITION ON THE SCREEN, GIVEN AN
;                                        ORIGIN IN THE LOWER LEFT CORNER.
; CURRENTLY, THE CHARACTERS ARE STORED:
;         0-2:    HERO STAMPS
;         3-14:   CHEF STAMPS
;         15-31:  FLYING FOODS
;         32: CONE DROPLET

CPALW     DS      TOTALCHR
CXPOSL    DS      TOTALCHR
CYPOSL    DS      TOTALCHR

CSTAMP    DS      TOTALCHR
CHSTAMP   DS      TOTALCHR
CSECOND   DS      TOTALCHR                ; USED BY LOADER TO DECIDE ON 2ND HALF
CINFO     DS      TOTALCHR
CTYPE     DS      TOTALCHR
CDIR      DS      TOTALCHR

CYSPEED   DS      TOTALCHR
CYSPEEDL  DS      TOTALCHR
CXSPEED   DS      TOTALCHR
CXSPEEDL  DS      TOTALCHR

CSINDEX   DS      TOTALCHR                ; TELLS THE OVERALL SPEED GRADATION

CFRAME    DS      TOTALCHR                ; TELLS HOW SOON WE MOVE AND ANIMATE
CSPEED    DS      TOTALCHR                ; VALUE TO RESET "CFRAME" WITH
CACOUNT   DS      TOTALCHR                ; ANIMATE FRAME COUNTER

HOLEUSED
CFLYTIME  DS      TOTALCHR

CREATOR   DS      TOTALCHR                ; NOT NEEDED WHEN FOOD IS ANGLED

THRWTIME  DS      $0E                    ; DEBOUNCING FOR THE THROW BUTTON
                                         ;  AS WELL AS COUNTERS FOR THE CHEFS
HELDFOOD  DS      $0D                    ; TELLS WHICH FOOD IS BEING CARRIED
OLDDIR    DS      $0D                    ; COMPARE WITH NEW DIRECTION TO SEE
                                         ;   IF SPEED DELTAS SHOULD CHANGE
MOODTUFF  DS      1
THRWTUFF  DS      2

; FIXED CHARACTERS

; THE FOLLOWING TABLES CONTAIN INFORMATION FOR CHARACTERS WHICH DON'T MOVE:
;         FOOD PILES, MANHOLES, AND THE ICE CREAM CONE.  THIS INFORMATION
;         IS IN A SEPARATE TABLE FROM THE MOVING INFO TO MAKE THE LOADER
;         MUCH QUICKER.
; THE MAXIMUMS ARE: 10 PILES, 8 MANHOLES, 1 CONE.  THE BANANAS AND TOMATOES
;         CAN TAKE 2 ENTRIES FOR ONE PILE, FOR A WORST CASE OF 20 ENTRIES.
;
;   NOTE-- FSTATE IS NOW IN ZERO PAGE

FSTAMP    DS      TOTALFX
FHSTAMP   DS      TOTALFX
FPALW     DS      TOTALFX
FCENTER   DS      TOTALFX
FDX       DS      TOTALFX
FYCENTER  DS      TOTALFX
FDY       DS      TOTALFX

FXPOSH    DS      1                      ; FOR HERO
FXPOS     DS      TOTALFX

FYPOSH    DS      1
FYPOS     DS      TOTALFX
FSTATE    DS      TOTALFX
FINFO     DS      TOTALFX                ;  TOP BIT IS FLAG FOR DOUBLE PILE
FDLPOS    DS      TOTALFX                ; TELLS WHERE IN THE DLIST THIS IS

DRIPTIME  DS      1                      ; COUNTER FOR DRIP ANIMATION
DRIPFRAM  DS      1

; LOCATIONS NEEDED BY THE SOUND DRIVER:

DCH0      DS      1                      ONE BYTE--DURATION CNTR CHAN. 0
DCH1      DS      1                      ONE BYTE--DURATION CNTR CHAN. 1
TUNNUM    DS      1                      ONE BYTE--TUNE NUM FOR CHAN. 0
TUNNUM1   DS      1                      ONE BYTE--TUNE NUM FOR CHAN. 1
TINDEX0   DS      1                      ONE BYTE--NOTE POINTER 0
TINDEX1   DS      1                      ONE BYTE--NOTE POINTER 1
CINDEX0   DS      1                      CONTROL INDEX
CINDEX1   DS      1
VINDEX0   DS      1                      VOLUME INDEX
VINDEX1   DS      1
MPTRL     EQU     KTEMP0                 ZERO PAGE TEMP(NOT GAMEPLAY)
MPTRH     EQU     KTEMP1                 ZERO PAGE TEMP(NOT GAMEPLAY)
TUNTEMP   EQU     TEMP4

; addresses up to this point should be $2660

          ;THIS WAS IN FIRST PAGE BUT MOVED BY MGF ON 6/1/84 TO MAKE SURE
          ;THAT THE STACK NEVER GETS DOWN HERE.  GRASPING AT STRAWS, HUH??

NUMCHHIT  DS      1                      ; NUMBER OF CHEFS HIT DURING RACK
HOLENUM   DS      1                      ; NUMBER OF HOLES THIS LEVEL

STEMPX    DS      1                      ; FOR SCORE ROUTINES
STEMPY    DS      1

INDEX     DS      1                      ; USED AS MAXIMUM INDEX IN LOOPS

PL0SCORE  DS      4
PL1SCORE  DS      4

PL0BONUS  DS      4
PL1BONUS  DS      4

PL0RACK   DS      1
PL1RACK   DS      1
PLBANAN   DS      1                      ; USED TO SLOW BANANA ANIMATION AFTER
                                         ; LEVEL 17.  <ROB 6.18.84>

PL0LIVES  DS      1
PL1LIVES  DS      1

PL0CARRY  DS      1
PL1CARRY  DS      1

PL0BCD    DS      2
PL1BCD    DS      2

PL0FIRST  DS      1
PL1FIRST  DS      1

PL0IRTIM  DS      1
PL1IRTIM  DS      1

PLFIRST   DS      1
PLMESS    DS      1

NUMSTUCK  DS      1
NUMINAIR  DS      1
ALLGONE   DS      1

HIGHSCOR  DS      4

NUMFALL   DS      1                      ; NUMBER OF CHEFS FALLEN
LASTCHEF  DS      1                      ; LAST CHEF TO HAVE FALLEN
FOODSTUF       DS      1

NEXTPILE  DS      1
LASTPILE  DS      1

; RESERVE LOCATIONS FF80-FFF7 FOR THE ENCRYPTION ALGORITHM:

          ORG     $FF80

          DS      $77                    ; FF80+77=FFF7

****************** CONSTANTS ***************************************************

MGAME     EQU     $00
MLOGO     EQU     $01
MATTRACT  EQU     $02
MHISCORE  EQU     $03
MENDGAME  EQU     $04
MENTER    EQU     $05
MPAUSE    EQU     $06
MBLANK    EQU     $08
MTEXT     EQU     $09
MSELECT   EQU     $0A

TRUE      EQU     $FF
FALSE     EQU     $00

M160X2    EQU     $40                    ; 160 X 2
M320X1    EQU     $43                    ; 320 X 1, 1 BYTE CHARS
M2BYTE    EQU     $50                    ; 2 BYTE CHARACTERS
MNODMA    EQU     $60                    ; TURN OFF DMA
CTRLOFF   EQU     $60

STATINIT  EQU     $00                    ; WHILE CHEFS ARE RISING
STATWAIT  EQU     $01                    ; CHEFS WAITING AFTER RISE
STATPLAY  EQU     $02                    ; DURING GAMEPLAY
STATWON   EQU     $03                    ; HERO EATING CONE; CHEFS RUNNING AWAY
STATBON   EQU     $04
STATDIEH  EQU     $05                    ; FALLING THROUGH HOLE
STATDIE   EQU     $06                    ; HERO JUST DIED; REJOICING CHEFS
STATDIEC  EQU     $07                    ; DEATH FROM CONE
STATHIT   EQU     $08                    ; WHILE FOOD IS HITTING HERO
STATLOGO  EQU     $10                    ; WHILE LOGO IS DISPLAYED
STATATTR  EQU     $11
STATREPL  EQU     $12                    ; INSTANT REPLAY
STATEND   EQU     $13
STATENDR  EQU     $14
STATCOMB  EQU     $15

DLISTCH   EQU     $1C                    ; MAXIMUM HEADERS PER DLIST (28)
LISTLENG  EQU     $70                     ; VALUE OF LISTSIZE IF FULL
XMAX      EQU     $9D                    ; MAXIMUM X COORDINATE
XMIN      EQU     $05                    ; MINIMUM X COORDINATE
YMAX      EQU     $AC                    ; MAXIMUM Y COORDINATE
YMIN      EQU     $05                    ; MINIMUM Y COORDINATE
XLEFT     EQU     $00
XRIGHT    EQU     $A0

TOPTHIRD  EQU     124                   ; USED BY HWIN ROUTINE TO MAKE CHEFS
BOTTHIRD  EQU     66                    ;   RUN AWAY IN THE RIGHT DIRECTION

BACKCOLR  EQU     $00

; CONSTANTS USED TO HANDLE THE MANHOLE FALLING AND RISING SEQUENCES:

FSPEED    EQU     $2                     ; FALL ONE PIXEL EVERY 8*2 CYCLES
RZSPEED   EQU     $4                     ; RISE HALF AS FAST

;CHUCK:

CFEETTOP   EQU     $10                    ; 16 HIGH, FOR NOW ANYWAY
CFTXTRA  EQU     $08                    ; 16-FEET HEIGHT
CHDXTRA   EQU     $00                    ; HEAD IS 16 HIGH
CFTHITE  EQU     $08
CHDHITE  EQU     $10
CHEADEND  EQU     $01
CFEETEND   EQU     $11                    ; CFRAME VALUE TO ERASE FEET

CFALLCNT  EQU     $17                    ; HEAD HITE + FEET HITE

SMILECH   EQU     $2D

; CHEFS:

FTTOP     EQU     $0F                    ; 10 + 5 (HAT + HEAD HEIGHT)
HDTOP     EQU     $0A                    ; HAT HEIGHT
FEETXTRA    EQU     $0C                    ; 16 - FEET HEIGHT
HEADXTRA    EQU     $0B                    ; 16 - HEAD HEIGHT
FEETEND     EQU     $12                    ; IFALLFRM - FEET HEIGHT
HEADEND     EQU     $0D                    ; FTEND - HEAD HEIGHT
FEETHITE    EQU     $04
HEADHITE    EQU     $05
HATHITE    EQU     $0A
HATXTRA    EQU     $06                    ; EXTRA FOR HAT; 16 - HAT HEIGHT

; FALLING AND RISING STATES:

FALLING   EQU     $09
FEETFALL    EQU     $09
HEADFALL    EQU     $0A
HATFALL    EQU     $0B

HATRISE   EQU     $0C
HEADRISE  EQU     $0D
FEETRISE  EQU     $0E

; THESE CONSTANTS TELL WHERE IN THE MOVING AND FIXED CHARACTER TABLES
;         EACH CHARACTER TYPE BEGINS.  THEY'RE NECESSARY FOR THE DRIVERS:

;MOVING CHARACTERS:

HEROSTRT  EQU     $00
CHEFSTRT  EQU     $03                    ; FIRST THREE ARE HERO CHARACTERS
FOODSTRT  EQU     $0F                    ; 12 STAMPS FOR THE CHEFS
DRIPSTRT  EQU     $1F                    ; LAST MOVING CHARACTER

NUMHERO   EQU     $02
NUMCHEF   EQU     $0C                    ; 3 STAMPS PER CHEF; 4 CHEFS
*NUMFOOD   EQU     $10                    ; ALREADY DEFINED ABOVE

; FIXED CHARACTERS:
;   NOTE:  THESE MUST COME IN THE SAME ORDER WHICH THEY ARE INITIALIZED IN,
;         BECAUSE OF THE NEED TO SET "FDLPOS" AT INITIALIZATION TIME.

CONESTRT  EQU     $00
PILESTRT  EQU     $01
HOLESTRT  EQU     $11                    ; 16 FOOD PILES

NUMEPILE  EQU     $10                    ; 16 ENTRIES FOR 8 PILES
NUMPILES  EQU     $08                    ; 8 PILES (ACTUALLY, 16 ENTRIES)
NUMHOLES  EQU     $0A
NUMCONE   EQU     $01

; VALUES FOR THE "STATE" SLOT:

RUNNING   EQU     $00                    ; CARRYING FLAG IS BIT 1
DEAD      EQU     $01
CARRYING  EQU     $02
WON       EQU     $03                    ; WHEN THE HERO REACHES THE CONE
DYING     EQU     $05                    ; DEATH ANIMATION
FLYING    EQU     $07                    ; FOR FLYING FOODS
CARRIED   EQU     $08                    ; FOR CARRIED FOODS
                                         ; 9-11 ARE FALLING STATES
SPLAT     EQU     $0C                    ; FOOD SPLATTING ON CHARACTER
LEAVING   EQU     $10
NOTYET    EQU     $11
ANGLE     EQU     $12
STICKING  EQU     $13
RETREAT   EQU     $14
HSPLAT    EQU     $15                    ; IF FOOD IS HITTING HERO
REJOYING  EQU     $16
RLEAVING  EQU     $17                    was leaving but becomes rejoicing

; HOLE STATES

OPEN      EQU     $01
CLOSED    EQU     $00

; FOOD STATES (TRY MAKING THIS VALUE REPRESENT THE NUMBER OF FOODS IN THE PILE)

ACTIVE    EQU     $01
EMPTY     EQU     $00

********** CHARACTER INFORMATION **************************

; CONSTANTS FOR LOGO DISPLAY:

LOGOTOP1  EQU     $5A
LOGOTOP2  EQU     $6A
LOGOBOT1  EQU     $78
LOGOBOT2  EQU     $88

LOGOPW1   EQU     $D0                    ; PALETTE 6, WIDTH 16 BYTES
LOGOPW2   EQU     $D2                    ; PALETTE 6, WIDTH 14 BYTES
                                         ; (TOTAL WIDTH OF 30)
; CHARACTER INFORMATION FOR THE WALLS:

WALLPALW  EQU     $10                    ; PALETTE AND WIDTH OF TOP AND BOTTOM
CORNPALW  EQU     $1E                    ;  CORNERS ARE 8 BITS WIDE
SIDEPALW  EQU     $1F                    ;  SIDE WALLS ARE 4 BITS WIDE (1 BYTE)

WHORIZ    EQU     $A2                    ; THESE ARE WALL CHARACTER LOW BYTES
TOPWHGH   EQU     $D1                    ;  HIGH BYTE OF TOP WALL
BOTWHGH   EQU     $E0                    ;  HIGH BYTE OF BOTTOM WALL
ULCORNER  EQU     $98                    ;  THE FOUR CORNERS
URCORNER  EQU     $9A
LRCORNER  EQU     $9C
LLCORNER  EQU     $9E
LWALL     EQU     $A0                    ;  THE LEFT AND RIGHT VERTICAL SIDES
RWALL     EQU     $A1

NUMCHAR   EQU     $D6                    ; 160X2 NUMBERS

; CHARACTER INFO FOR THE HERO AND CHEFS:

HEROPALW  EQU     $1E                    ; PALETTE 0, WIDTH 2 BYTES
ARMPALW   EQU     $1D                    ; WIDTH OF 3 BYTES
HEROX     EQU     $8C                    ; HERO STARTING X POSITION

SADCHAR   EQU     $96                    ; FACING FORWARD LOOKING SAD
STHEADCH  EQU     $B2

; THESE ARE FOR THE 3 CHEF STAMPS' ADJUSTMENT:

HEADTOP   EQU     $0A                    ; DISTANCE FROM HAT TO HEAD
FEETTOP   EQU     $01                    ; DISTANCE FROM HEAD TO FEET

; INFO FOR THE CONE, THE MANHOLES:

XCLOSE    EQU     $11                    ; WHEN HERO'S GETTING CLOSE
CONEX     EQU     $04                    ; CONE X POSITION
SPLASHX   EQU     $02
DRIPX     EQU     $03

CONECHAR  EQU     $00                    ; IN BLOCK2
CONEPALW  EQU     $FE                    ; PALETTE 7, WIDTH 2 BYTES

SHUTCHAR  EQU     $B8                    ; HOLE CLOSED
OPENCHAR  EQU     $BB                    ; HOLE OPEN
HOLEPALW  EQU     $1D                    ; PALETTE 0, WIDTH 4 BYTES

; INFO FOR ALL OF THE PILES:
;         NOTE THAT ALL OF THE CHARACTER INFO IS STORED
;         IN TABLES AT THE END OF "MAIN.S", FOR PILE SIZES 8 THROUGH 1.

BANTYPE   EQU     $00
PEATYPE   EQU     $01
PIETYPE   EQU     $02
TOMTYPE   EQU     $03
WATTYPE   EQU     $04

PEAFLYPW  EQU     $7E                    ; FLYING PEAS ALL THE SAME WIDTH

; BANANAS:

B12PALW   EQU     $BE                    ; PALETTE 5, WIDTH 2
B34PALW   EQU     $BC                    ; WIDTH 4

; PEAS:

P84PALW   EQU     $7D                    ; PALETTE 3, WIDTH 3
P31PALW   EQU     $7E                    ; WIDTH 2

; PIES:

PIEPALW   EQU     $5C                    ; PALETTE 2, WIDTH 4

; TOMATOES:

TOMPALW   EQU     $9D                    ; PALETTE 4, WIDTH 3

; WATERMELON

WATPALW   EQU     $DD                    ; PALETTE 6, WIDTH 3
WATCHAR   EQU     $78

SLICECH   EQU     $F4
SLICEPW   EQU     $DE

; NULL CHARACTERS

NULLCHAR  EQU     $BE                    ; FOR BLOCK1
NULL2     EQU     $2F                    ; FOR BLOCK2

; DELTA VALUES FOR ALL THE CHARACTERS:

DXHERO    EQU     $02
DYHERO    EQU     $0A

DXHCHEF    EQU     $02
DYHCHEF    EQU     $06
DXFCHEF   EQU     $04
DYFCHEF   EQU     $08

DXCONE    EQU     $03
DYCONE    EQU     $07

DXHOLE    EQU     $03
DYHOLE    EQU     $02

YCENTER   EQU     $0A                    ; CHARCENTER - FOODCENTER

DXFOOD    EQU     $03
DYFOOD    EQU     $03

DXCHAR    EQU     $04                    ; GENERIC DELTAS FOR USE BY "PILEHIT"
DYCHAR    EQU     $08

DXCLOSE   EQU     $10                    ; FOR INITIALIZATION
DYCLOSE   EQU     $10                    just more than the next zone

IRDXHERO  EQU     15                     ; IF CHEFS ARE THIS NEAR, COUNT FOR
IRDYHERO  EQU     22                     ; REPLAY

DOIRLOW   EQU     30                     ;  GIVE HIM A REPLAY

