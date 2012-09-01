*** CDEF.S ***

;         MEMORY ALLOCATION AND CONSTANTS FOR 3600 CENTIPEDE

NEWBOARD  EQU     1                      ;SET TO ZERO IF OLD BOARD
                                         ;ONE FOR NEW BOARD
; TIA REGISTERS
VBLANK    EQU     $01

INPT0     EQU     $08
INPT1     EQU     $09
INPT4     EQU     $0C
INPT5     EQU     $0D
AUDC0     EQU     $15      ;BITS     3210 AUDIO CONTROL 0
AUDC1     EQU     $16      ;BITS     3210 AUDIO CONTROL 1
AUDF0     EQU     $17      ;BITS     3210 AUDIO FREQUENCY 0
AUDF1     EQU     $18      ;BITS     3210 AUDIO FREQUENCY 1
AUDV0     EQU     $19      ;BITS     3210 AUDIO VOLUME 0
AUDV1     EQU     $1A      ;BITS     3210 AUDIO VOLUME 1

;MARIA REGISTERS
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
DPH       EQU     $2C                    ;DISPLAY LIST POINTER HIGH         WO
P3C1      EQU     $2D                    ;PALETTE THREE COLOR ONE           RW
P3C2      EQU     $2E                    ;PALETTE THREE COLOR TWO           RW
P3C3      EQU     $2F                    ;PALETTE THREE COLOR THREE         RW
DPL       EQU     $30                    ;DISPLAY LIST POINTER LOW          WO
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
CTRL      EQU     $3C                    ;BIT 7  CHARACTER WIDTH,BIT 6 BCNT WO
P7C1      EQU     $3D                    ;PALETTE SEVEN COLOR ONE           RW
P7C2      EQU     $3E                    ;PALETTE SEVEN COLOR TWO           RW
P7C3      EQU     $3F                    ;PALETTE SEVEN COLOR THREE         RW


;6532  TIMERS AND PORTS
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
;                 NOW IS PAUSE SWITCH    CLEAR WHEN PRESSED
;         BIT 1   GAME SELECT  CLEAR WHEN PRESSED
;         BIT 0   GAME RESET   CLEAR WHEN PRESSED

CTLSWA    EQU     $281
CTLSWB    EQU     $283
INTIM     EQU     $284  ;INTERVAL TIMER IN
TIM8T     EQU     $295  ;TIMER 8T WRITE OUT
TIM64T    EQU     $296  ;TIMER 64T WRITE OUT
TIM64TI   EQU     $29E  ;INTERUPT TIMER 64T


******************************************
*         CONSTANTS                      *
******************************************
INFLDZN   EQU     15                     ;ZONE NUMBER OF TOP LINE OF INFIELD
                                         ;  (ZONE NUMBERING STARTS WITH 1)
NSCORES   EQU     7
BIT7MASK  EQU     $80
NZONES    EQU     24
ZONELEN   EQU     31
DLLENGTH  EQU     18*4+5+2               ;79

PWSHOOTR  EQU     $1E                    0=SHOOTER
PWSHOT    EQU     $1F                    0=SHOT
PWSPIDER  EQU     $7D                    3=SPIDER
PWSCORP   EQU     $9E                    4=SCORPION AND FLEA
PWCENTI   EQU     $BF                    5=CENTIPEDE SEGMENT
PALWIDTH  EQU     $C1                    6=PALETTE, WIDTH FOR CHARACTER MAP
PWTITLE   EQU     $C1                    6=PALETTE/WIDTH FOR TITLE PAGE GRAPHIC
PWCOPYRT  EQU     $D4                    6=PALETTE/WIDTH FOR COPYRIGHT LINE

TOPCOLOR  EQU     144
CENTPCNT  EQU     2                      ;NUMBER OF CHAINS IN TITLE PAGE

HORIZPOS  EQU     20
MINX      EQU     20
MAXX      EQU     MINX+ZONELEN*4         ;16+124=140
CNTRCLMN  EQU     (MAXX-MINX)/2+MINX-2
MINY      EQU     8
MAXY      EQU     191

SEGWDTH   EQU     4
SPDRWDTH  EQU     9
SCRPWDTH  EQU     8
FLEAWDTH  EQU     5

ATTRYBSE  EQU     40
YBTMATTR  EQU     ATTRYBSE+24


******************************************
*         ZERO PAGE RAM                  *
******************************************
*                                        *
* $40 TO $7F SHADOWED AT $2040 TO $207F  *
* $80 TO $FF IS 6532 RAM                 *
*                                        *
******************************************

          ORG     $0040
GTEMP1    DS      1                      ;Temporaries used by game; don't use
GTEMP2    DS      1                      ;   in loader
GTEMP3    DS      1                      ;First four are also used as SCOREBLK
GTEMP4    DS      1                      ;   for HSC
GTEMP5    DS      1                      ;GTEMP6 at other end of page 0

SCOREBLK  EQU     GTEMP1
HSDATA    EQU     $2200

DLOFFSTS  DS      23                     ;INDEX INTO DISPLAY LISTS   $5B

OBJX      DS      18                     ;GAME'S OBJECT TABLE    $6D
OBJY      DS      18                     ;$7F

* ANYTHING FROM $80 TO ABOUT $C0 OR $D0 CAN'T BE USED IN MOVCENTI OR LOADER
* SINCE THESE ROUTINES ARE CALLED DURING HSC DISPLAY, AND HSC USES THESE ZERO
* PAGE ADDRESSES
SCORE0    DS      3                      ;SCORES FOR PLAYER 0, 1, TEAM SCORE
HSCORE0   DS      4
SCORE1    DS      3
HSCORE1   DS      4
SCORE2    DS      3
HSCORE2   DS      4
SCORE3    DS      3                      ;EXTRA SCORE BYTES FOR HIGH SCORE CART

          ORG     $00D0
OBJSTAT   DS      18                     ;$E1
OBJOFFST  DS      18                     ;$F3


;OBJX2     DS      18                     ;GAME'S OBJECT TABLE
;OBJY2     DS      18
;OBJSTAT2  DS      18
;OBJOFFS2  DS      18


FLEAX     EQU     OBJX+13
FLEAY     EQU     OBJY+13
FLEAOFST  EQU     OBJOFFST+13
FLEASTAT  EQU     OBJSTAT+13             ;BIT 7  1=LIVE, 0=DEAD
                                         ;    6  1=FLEA, 0=SCORPION
          ;IF FLEA, BITS 10 GIVE SPEED -1
          ;IF SCORPION, BIT 1  1= FAST,  0= SLOW        BIT 0 1=LEFT, 0=RGHT


SPDRX     EQU     OBJX+12
SPDRY     EQU     OBJY+12
SPDROFST  EQU     OBJOFFST+12
SPDRSTAT  EQU     OBJSTAT+12             ;BIT 7   1=LIVE, 0=DEAD
                                         ;    6   1 = HORIZ. MOVEMENT, 0 = NO
                                         ;    5   1=LEFT, 0=RIGHT
                                         ;    2   1=UP,0=DOWN
                                         ;    0   1=FAST, 0=SLOW

SHOOTERX  EQU     OBJX+14                ;LOCATION OF SHOOTER IN OBJECT TABLE
SHOOTERY  EQU     OBJY+14
SHTROFST  EQU     OBJOFFST+14
SHTRSTAT  EQU     OBJSTAT+14             ;BIT 7   1=LIVE, 0=DEAD
                                         ;    6   USED IN CHKEND
                                         ;    5   RIGHT/LEFT
                                         ;    4   1=RES MAN IN

SHOTX     EQU     OBJX+16
SHOTY     EQU     OBJY+16
SHOTSTAT  EQU     OBJSTAT+16
SHOTOFST  EQU     OBJOFFST+16

VECTORI   DS      2                      ;$F5

TEMPADDR  DS      2                      ;Temporaries used by loader; don't use
MPTRL     EQU     TEMPADDR               ;   in game play
MPTRH     EQU     TEMPADDR+1
TEMP1     DS      1
TEMP2     DS      1
TEMP3     DS      1
TEMP4     DS      1                      ;$FB

GTEMP6    DS      1                      ;$FC

********************************************************************************
* RAM       (DONT USE 2040-20FF, OR 2140-21FF)
********************************************************************************
******************************************
*         DISPLAY LISTS                  *
******************************************

          ORG     $1800                  ;TO $1F91
HLINEDL   DS      12                     ;1 HEADER FOR A HORIZONTAL LINE
TPDL      DS      2                      ;ALWAYS TWO ZEROES
DL1       DS      17                     ; SCORE ZONE -- 3 HEADERS
DL2       DS      DLLENGTH               ;2 + 17 + 23*79 + 28*3 = 1920 dec
DL3       DS      DLLENGTH               ;                         780 hex
DL4       DS      DLLENGTH
DL5       DS      DLLENGTH
DL6       DS      DLLENGTH
DL7       DS      DLLENGTH
DL8       DS      DLLENGTH
DL9       DS      DLLENGTH
DL10      DS      DLLENGTH
DL11      DS      DLLENGTH
DL12      DS      DLLENGTH
DL13      DS      DLLENGTH
DL14      DS      DLLENGTH
DL15      DS      DLLENGTH
DL16      DS      DLLENGTH
DL17      DS      DLLENGTH
DL18      DS      DLLENGTH
DL19      DS      DLLENGTH
DL20      DS      DLLENGTH
DL21      DS      DLLENGTH
DL22      DS      DLLENGTH
DL23      DS      DLLENGTH
DL24      DS      DLLENGTH
DLL       DS      31*3+1
* AND THEN 61 MORE MISCELLANEOUS
LETTRNUM  DS      1
TUNTEMP   DS      1
SCRLONZN  DS      1
TOPLINE   DS      1
MINIMUMY  DS      1

CLMNUSED  DS      4
ATGMTMR   DS      2                      ;ONE OF EACH OF THESE FOR EACH PLAYER
ATSITTMR  DS      2
ATTSHTRY  DS      2
ATTSHTRX  DS      2

OBJPALWD  DS      18                     ;OBJECT PALETTE/WIDTH TABLE
OBJTIMER  DS      18
SPDRTIMR  EQU     OBJTIMER+12
SHTRTIMR  EQU     OBJTIMER+14
SHOTTIMR  EQU     OBJTIMER+16
DIFLEVEL  DS      1                      ;DIFFICULTY LEVEL
DEBOUNC2  DS      1                      ;DEBOUNCE FOR JOYSTICK IN TITLE PAGE
OPTCNT1   DS      1                      ;COUNTER FOR JOYSTICK IN TITLE PAGE
OPTCNT2   DS      1                      ;COUNTER FOR GAME SWITCH IN TITLE PAGE
CENTLEFT  DS      1                      ;18 IN GAME PLAY, 19 IN TITLE PAGE
CENTRGHT  DS      1                      ;135 IN GAME PLAY, 134 IN TITLE PAGE
HSCFLAG   DS      1
HSATRGM   DS      1                      ;WHICH GAME VERSION TO DISPLAY HS OF
ALTCTRLS  DS      1                      ;IN ALTERNATING GAME, 0=USE 1 TRACK,
                                         ;   1 JOYSICK        1=SHARE TRACKBALL

******************************************
* DON'T USE 2040-20FF
******************************************

          ORG     $2100                  ;USED TO BE $1000--MARIA 1 64 BYTES
* 54 BYTES HAVE BEEN USED
FRMCNT    DS      1
RNDM      DS      2
PAUSETMR  DS      2
DEBOUNCE  DS      1
DEBOUNC1  DS      1
NLOOPS    DS      1
OBJTBSEM  DS      1                      ;SEMAPHORE FOR OBJECT TABLE
; BIT 7 SET IF OBJECT TABLE READY TO BE LOADED, 0 IF NOT

PLAYER    DS      1                      ;PLAYER 0 OR 1

BONUSL    DS      2                      ;NEXT BONUS LEVEL, LOW BYTE
BONUSM    DS      2                      ;NEXT BONUS LEVEL, HIGH

MENLEFT   DS      2

RACKNUM   DS      2
NHDCOUNT  DS      2
NHDTIMER  DS      1
NEWHDFLG  DS      1
FASTWAVE  DS      2
SPDCTRL   DS      1
CHAINSIZ  DS      2
MAXSGCNT  DS      1
NUMSEG    DS      1
MUSHCNT   DS      2                      ;NUMBER OF MUSHROOMS IN INFIELD
CLRINDEX  DS      2                      ;SET OF COLORS OF EACH PLAYER GRAPHICS
COLORFLG  DS      1                      ;FLAG FOR NEW COLORS TO BE LOADED
GAMETYPE  DS      1                      ;BIT 0   1 PLAYER/2 PLAYER (0/1)
; BIT 7 SET = 2 PLAYER SIMULTANEOUS      BIT 6 SET = 2 PLAYER TEAM PLAY
DELAYSEG  DS      1
ATTRACT   DS      2
AXCOUNT   DS      2
SCRTIMER  DS      1
FLAGS     DS      1                      ;VARIOUS GAME FLAGS
;         BIT 7   SOMEBODY'S GAME HAS ENDED IN A TWO PLAYER MODE (STAYS SET
;                 UNTIL END OF GAME, AS OPPOSED TO BIT 7)
;         BIT 6   1 = MUSHROOM RESTORATION IS CURRENTLY HAPPENING

******************************************
* DON'T USE 2140-21FF
******************************************

          ORG     $2200                  ;USED SO FAR--11 + 62 + 1395 = 5BC HEX

******************************************
* CHARACTER MAPS TOTAL 1395 dec OR 573 hex BYTES
******************************************
MAP2      DS      (NZONES-2)*ZONELEN     ;This map for other player
MUSHMAP   DS      (NZONES-1)*ZONELEN     ;This map gets displayed
MUSHEND   EQU     MUSHMAP+(NZONES-1)*ZONELEN

GMTYPDSP  EQU     MUSHMAP+ZONELEN*15+5
CTRLDSP   EQU     MUSHMAP+ZONELEN*16
DFLVLDSP  EQU     MUSHMAP+ZONELEN*18

DCH0      DS      1                      ONE BYTE--DURATION CNTR CHAN. 0
DCH1      DS      1                      ONE BYTE--DURATION CNTR CHAN. 1
TUNNUM    DS      1                      ONE BYTE--TUNE NUM FOR CHAN. 0
TUNNUM1   DS      1                      ONE BYTE--TUNE NUM FOR CHAN. 1
TINDEX0   DS      1                      ONE BYTE--NOTE POINTER 0
TINDEX1   DS      1                      ONE BYTE--NOTE POINTER 1
CINDEX0   DS      1
CINDEX1   DS      1
VINDEX0   DS      1
VINDEX1   DS      1
SCRPINDX  DS      1

LIFETMP   DS      ZONELEN*2              ;62 BYTES -- ALLOWS TWO
                                         ;LINES OF CHAR. MAP BUFFER FOR LIFE
MSGSTORE  EQU     LIFETMP
BUTNIB    DS      2                      ;TEMP STORAGE FOR BUTTON STATUS
YCOUNT    DS      1
XCOUNT    DS      1                      ;X COUNT BYTE
YCOUNT1   DS      1                      ;PLAYER2
XCOUNT1   DS      1
OLDY      DS      1
OLDX      DS      1                      ;KEEPS TRACK OF LAST XCOUNT
OLDY1     DS      1
OLDX1     DS      1
DELTAY    DS      1
DELTAY1   DS      1
DELTAX    DS      1                      ;CHANGE IN X COUNT SINCE LAST FRAME
DELTAX1   DS      1
TRACKF    DS      2                      ;TRACKBALL FLAG 0=NOT TRACKBALL
CRAP      DS      1
TTEMP1    DS      1
TTEMP2    DS      1
SCHTICK   DS      1                      ;JOYSTICK SHADOW REGISTER
PANEL     DS      1                      ;SWCHB SHADOW REGISTER
ENDEF
