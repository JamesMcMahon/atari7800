
*  MSDEF.S        MS PAC MAN SYMBOL DEFINITIONS
*  ADDRESS DEFINITIONS

*  ZERO PAGE

*  ZERO PAGE VARIABLES THAT ARE NOT ERASED  $40-$9F

STLEVEL   EQU     $40                    ;STARTING LEVEL OF GAME
TWOPLAYR  EQU     $41                    ;WHETHER TWO-PLAYER MODE
AUTOPLAY  EQU     $42                    ;1 IF AUTO-PLAY MODE

NEWRAND   EQU     $43                    ;CURRENT SEED FOR RAND ROUTINE
OLDRAND   EQU     $44                    ;OLD SEED FOR RAND ROUTINE

PLAYER    EQU     $45                    ;WHICH PLAYER IS PLAYING
P1SCORE   EQU     $46                    ;PLAYER 1 SCORE - 4 BYTES
P1BONUS   EQU     $4A                    ;TIME TILL PLAYER 1 GETS BONUS LIFE
P2SCORE   EQU     $4C                    ;PLAYER 2 SCORE - 4 BYTES
P2BONUS   EQU     $50                    ;TIME TILL PLAYER 2 GETS BONUS LIFE

RACKRAND  EQU     $52                    ;NUMBER BETWEEN 0..3 FOR THE RACK
MENUFLAG  EQU     $53                    ;WHETHER IN MENU MODE OR NOT
KNLTEMP0  EQU     $54                    ;STATE VARIABLE FOR KERNAL
KNLTEMP1  EQU     $55                    ;STATE VARIABLE FOR KERNAL

*  LOADER VARIABLES
HPLIST    EQU     $56                    ;6 BYTES - HORIZONTAL POSITION
VZLIST    EQU     $5C                    ;6 BYTES - VERTICAL ZONE
VOLIST    EQU     $62                    ;6 BYTES - VERTICAL OFFSET
SLLIST    EQU     $68                    ;6 BYTES - LOW BYTE STAMP ADDRESS
SHLIST    EQU     $6E                    ;6 BYTES - HI BYTE STAMP ADDRESS
DOLIST    EQU     $74                    ;6 BYTES - SOMETHING CHANGED - RELOAD
OLDZONE   EQU     $7A                    ;6 BYTES - LAST ZONE CHARACTER IN

*  SHADOWS FOR MONSTER COLORS (USED FOR FRUIT PALETTES)
P0C1      EQU     $81                    ;PALETTE 2, COLOR 1
P0C2      EQU     $82                    ;PALETTE 2, COLOR 2
P0C3      EQU     $83                    ;PALETTE 2, COLOR 3

RACKFRT   EQU     $84                    ;TYPE OF FRUIT TO DISPLAY UNDER RACK

P1C1      EQU     $85                    ;PALETTE 3, COLOR 1
P1C2      EQU     $86                    ;PALETTE 3, COLOR 2
P1C3      EQU     $87                    ;PALETTE 3, COLOR 3

DBSELECT  EQU     $88                    ;DEBOUNCE BYTE FOR SELECT

P2C1      EQU     $89                    ;PALETTE 4, COLOR 1
P2C2      EQU     $8A                    ;PALETTE 4, COLOR 2
P2C3      EQU     $8B                    ;PALETTE 4, COLOR 3

DBRESET   EQU     $8C                    ;DEBOUNCE BYTE FOR RESET

P3C1      EQU     $8D                    ;PALETTE 5, COLOR 1
P3C2      EQU     $8E                    ;PALETTE 5, COLOR 2
P3C3      EQU     $8F                    ;PALETTE 5, COLOR 3

DBPAUSE   EQU     $90                    ;DEBOUNCE BYTE FOR PAUSE

P4C1      EQU     $91                    ;PALETTE 2, COLOR 1
P4C2      EQU     $92                    ;PALETTE 2, COLOR 2
P4C3      EQU     $93                    ;PALETTE 2, COLOR 3

SCRNSTAT  EQU     $94                    ;SCREEN STATE, OFF IF $FF

P5C1      EQU     $95                    ;PALETTE 3, COLOR 1
P5C2      EQU     $96                    ;PALETTE 3, COLOR 2
P5C3      EQU     $97                    ;PALETTE 3, COLOR 3

TWOPORTS  EQU     $98                    ;WHETHER THE SECOND PORT HAS BEEN USED

P6C1      EQU     $99                    ;PALETTE 4, COLOR 1
P6C2      EQU     $9A                    ;PALETTE 4, COLOR 2
P6C3      EQU     $9B                    ;PALETTE 4, COLOR 3

HSCHERE   EQU     $9C                    ;IS HIGH SCORE CART PLUGGED IN

P7C1      EQU     $9D                    ;PALETTE 5, COLOR 1
P7C2      EQU     $9E                    ;PALETTE 5, COLOR 2
P7C3      EQU     $9F                    ;PALETTE 5, COLOR 3

*  ZERO PAGE VARIABLES THAT ARE ERASED IN GAMEINIT  $A0-$FF

RTLOCAL   EQU     $A0                    ;TWO BYTES - MY CLOCK
GAMEOVER  EQU     $A2                    ;FLAG FOR GAME OVER

TOTLIVES  EQU     $A3                    ;TOTAL NUMBER OF LIVES
*  $64-$6F ARE SWAPPED BETWEEN PLAYERS
LIVES     EQU     $A4                    ;NUMBER OF LIVES
RACK      EQU     $A5                    ;RACK PLAYER IS AT
LEVEL     EQU     $A6                    ;LEVEL PLAYER IS AT
ADJLEVEL  EQU     $A7                    ;LEVEL ADJUSTED FOR 'WRAP' AT HIGH LVL
DOTS      EQU     $A8                    ;NUMBER OF DOTS
DOTSEATN  EQU     $AA                    ;NUMBER OF DOTS EATEN
DEATHFLG  EQU     $AB                    ;TRUE IF THE PAC HAS DIED YET
PINKDOTS  EQU     $AC                    ;PINK RELEASE COUNTER
BLUEDOTS  EQU     $AD                    ;BLUE RELEASE COUNTER
GOLDDOTS  EQU     $AE                    ;GOLD RELEASE COUNTER
FDOTS     EQU     $AF                    ;FRUIT RELEASE COUNTER

*  TEMP VARIABLES
TEMP0     EQU     $B0                    ;SCRATCH DATA FOR PROGRAM USE
TEMP1     EQU     $B1                    ;MORE SCRATCH DATA
TEMP2     EQU     $B2                    ;MORE SCRATCH DATA
TEMP3     EQU     $B3                    ;MORE SCRATCH DATA
TEMP4     EQU     $B4                    ;MORE SCRATCH DATA
TEMP5     EQU     $B5                    ;MORE SCRATCH DATA
TEMP6     EQU     $B6                    ;MORE SCRATCH DATA
TEMP7     EQU     $B7                    ;MORE SCRATCH DATA
TEMP8     EQU     $B8                    ;MORE SCRATCH DATA
TEMP9     EQU     $B9                    ;MORE SCRATCH DATA
TEMP10    EQU     $BA                    ;MORE SCRATCH DATA
TEMP11    EQU     $BB                    ;MORE SCRATCH DATA
TEMP12    EQU     $BC                    ;MORE SCRATCH DATA
TEMP13    EQU     $BD                    ;MORE SCRATCH DATA
TEMP14    EQU     $BE                    ;MORE SCRATCH DATA
TEMP15    EQU     $BF                    ;MORE SCRATCH DATA
TEMP16    EQU     $C0                    ;MORE SCRATCH DATA
TEMP17    EQU     $C1                    ;MORE SCRATCH DATA
TEMP18    EQU     $C2                    ;MORE SCRATCH DATA
TEMP19    EQU     $C3                    ;MORE SCRATCH DATA
TEMP20    EQU     $C4                    ;MORE SCRATCH DATA
TEMP21    EQU     $C5                    ;MORE SCRATCH DATA
TEMP22    EQU     $C6                    ;MORE SCRATCH DATA
TEMP23    EQU     $C7                    ;MORE SCRATCH DATA

LDRTEMP0  EQU     $C8                    ;SCRATCH DATA FOR KERNAL USE
LDRTEMP1  EQU     $C9                    ;MORE SCRATCH DATA
LDRTEMP2  EQU     $CA                    ;MORE SCRATCH DATA
LDRTEMP3  EQU     $CB                    ;MORE SCRATCH DATA
LDRTEMP4  EQU     $CC                    ;MORE SCRATCH DATA
LDRTEMP5  EQU     $CD                    ;MORE SCRATCH DATA
LDRTEMP6  EQU     $CE                    ;MORE SCRATCH DATA
LDRTEMP7  EQU     $CF                    ;MORE SCRATCH DATA
SOUNDZP   EQU     $C8                    ;ZERO PAGE FOR SOUND - SAME AS LOADER

NEWDIR    EQU     $D0                    ;CURRENT JOYSTICK DIRECTION
OLDDIR    EQU     $D1                    ;PREVIOUS DIFFERENT JOYSTICK DIRECTION
BUTSTATE  EQU     $D2                    ;BOTTON STATUS - ON OR 0

RTSAVE    EQU     $D4                    ;A PLACE TO SAVE RTLOCAL - 2 BYTES

INDRJUMP  EQU     $D6                    ;PLACE TO PUT VALUES FOR INDERECT JUMP

MONWAIT   EQU     $D8                    ;WAIT TILL NEXT MONSTER MOVE
PACWAIT   EQU     $D9                    ;WAIT TILL NEXT PAC MOVE
FRTWAIT   EQU     $DA                    ;WAIT TILL NEXT FRUIT MOVE
FLSHWAIT  EQU     $DB                    ;WAIT TILL NEXT RACK INC
BLUWAIT   EQU     $DC                    ;WAIT TILL END OF BLUE TIME
SCORWAIT  EQU     $DD                    ;WAIT TILL NEXT ITER OF TIGHT LOOP
RESWAIT   EQU     $DE                    ;WAIT TILL END OF RESET

BAKLIVES  EQU     $E4                    ;OTHER PLAYER VERSION OF $54-$5F

*  TIME LAST DOT WAS EATEN
DOTTIME   EQU     $F0                    ;TWO BYTES

* GLOBAL MONSTER STATE INFO
SCORTIME  EQU     $F2                    ;MONSTER SCORE DELAY COUNTER
BLUETIME  EQU     $F3                    ;BLUE TIME FOR THIS RACK
M1REL     EQU     $F4                    ;MONSTER RELEASE THRESHHOLDS
M2REL     EQU     $F5
M3REL     EQU     $F6
EATNDOTS  EQU     $F7                    ;DOTS EATEN SINCE LAST PAC DEATH
TRELEASE  EQU     $F8                    ;COUNTER FOR MONSTER RELEASE
REDTHRSH  EQU     $F9                    ;2 BYTES - RED SPEED THRESHHOLD
NORMTIME  EQU     $FB                    ;2 BYTES - TIME SINCE BOR WHILE NOT BLU
ISBLUE    EQU     $FD                    ;PAC IN BLUE MODE
GREEDCNT  EQU     $FE                    ;MONSTERS EATEN ON THIS POWER DOT
BORED     EQU     $FF                    ;MONSTERS ARE BORED


*  HIGH RAM - NOTE, 1800-1DFF IS ZEROED IN ZERORAM

*  HIGH SCORE RAM - SMASHED WHEN HIGH SCORE ROUTINES ARE CALLED
HSCRAM    EQU     $1800                  ;$200 BYTES

*  HIGH SCORE CART DIFFICULTY NAME
HSCDIF    EQU     $1A00                  ;$20 BYTES

*  SCREEN MAP - THROUGH $1BFF
SCREEN    EQU     $1800                  ;SCREEN MAP
SCORE     EQU     $1B48                  ;SCORE MAP - EFFECTIVELY THE 31ST LINE

*  DOT ARRAYS - THROUGH $1CFF
DOTARRAY  EQU     $1C00                  ;CURRENT PLAYER DOT ARRAY
BAKDOTS   EQU     $1C80                  ;OTHER PLAYER DOT ARRAY

*  TUNE VARIABLES
TUNON     EQU     $1D00                  ;4 BYTES - WHETHER TUNE IS ACTIVE
TUNINDEX  EQU     $1D04                  ;4 BYTES - WHAT TUNE IS PLAYING
TUNPRIOR  EQU     $1D08                  ;4 BYTES - WHAT THE PRIORITY OF TUNE IS
TUNBASE   EQU     $1D0C                  ;4 BYTES - BASE ADDRESS OF TUNE DATA
TUNBASE1  EQU     $1D10                  ;4 BYTES - HI BYTE OF BASE ADDRESS
FREQOFF   EQU     $1D14                  ;4 BYTES - OFFSET INTO DATA FOR FREQ'S
CTLOFF    EQU     $1D18                  ;4 BYTES - OFFSET INTO DATA FOR CTL'S
VOLOFF    EQU     $1D1C                  ;4 BYTES - OFFSET INTO DATA FOR VOL'S
FREQTIME  EQU     $1D20                  ;4 BYTES - NUMBER FRAMES TILL NEXT FREQ
CTLTIME   EQU     $1D24                  ;4 BYTES - NUMBER FRAMES TILL NEXT CTL
VOLTIME   EQU     $1D28                  ;4 BYTES - NUMBER FRAMES TILL NEXT VOL
TUNNUM    EQU     $1D2C                  ;WHAT TUNE YOU WANT - PARAMETER
TUNTEMP0  EQU     $1D2D                  ;TEMP VALUE FOR TUNE DRIVER
TUNTEMP1  EQU     $1D2E                  ;TEMP VALUE FOR TUNE DRIVER
TUNOFF    EQU     $1D2F                  ;ARE TUNES TURNED OFF?

*  KERNAL DISPLAY TABLES
MSADDR    EQU     $1E40                  ;$1E BYTES - MS ADDRESS TABLE
FRTADDR   EQU     $1E60                  ;$1E BYTES - FRUIT ADDRESS TABLE
M0ADDR    EQU     $1E80                  ;$1E BYTES - MONSTER 0 ADDRESS TABLE
M1ADDR    EQU     $1EA0                  ;$1E BYTES - MONSTER 1 ADDRESS TABLE
M2ADDR    EQU     $1EC0                  ;$1E BYTES - MONSTER 2 ADDRESS TABLE
M3ADDR    EQU     $1EE0                  ;$1E BYTES - MONSTER 3 ADDRESS TABLE

*  KERNAL DISPLAY LISTS - MUST BE ON SAME PAGE
DLIST0    EQU     $1F00                  ;$27 BYTES - DISPLAY LIST FOR GAME
BDLIST0   EQU     $1F27                  ;$32 BYTES - DISPLAY LIST FOR INDICATOR
DLIST1    EQU     $1F59                  ;$27 BYTES - DISPLAY LIST FOR GAME
BDLIST1   EQU     $1F80                  ;$32 BYTES - DISPLAY LIST FOR INDICATOR
TOPDLIST  EQU     $1FB2                  ;$07 BYTES - DISPLAY LIST FOR SCORE
NULDLIST  EQU     $1FB7                  ;$02 BYTES - NULL DISPLAY LIST

*  DISPLAY LIST LIST
DLL       EQU     $1FC0                  ;$72 BYTES - LIST OF DISPLAY LISTS

*         ***** HOLE FROM $2040 TO $20FF - SHADOWED IN PAGE 0 *****

*  PAC STATE VARIABLES
PVPOS     EQU     $2100                  ;VERTICAL POSITION
PHPOS     EQU     $2101                  ;HORIZONTAL POSITION
PZONE     EQU     $2102                  ;ROW
POFF      EQU     VOLIST                 ;OFFSET
PCOL      EQU     $2103                  ;COLUMN
PDIR      EQU     $2104                  ;DIRECTION
PDISP     EQU     $2105                  ;DISPLAY STATE
PMOVING   EQU     $2106                  ;WHETHER IT IS STOPPED
PTZONE    EQU     $2107                  ;ZONE OF LAST TURN
PTCOL     EQU     $2108                  ;COLUMN OF LAST TURN
PTEMP     EQU     $2109                  ;TEMP VARIABLE
PDELAY    EQU     $210A                  ;DELAY FOR NEXT MOVE
PTUNNEL   EQU     $210B                  ;WHETHER PAC IN TUNNEL

*  FRUIT STATE VARIABLES
FENABLE   EQU     $2110                  ;WHETHER FRUIT IS 'ON'
FVPOS     EQU     $2111                  ;VERTICAL POSITION
FHPOS     EQU     $2112                  ;HORIZONTAL POSITION
FZONE     EQU     $2113                  ;ROW
FOFF      EQU     VOLIST+1               ;OFFSET
FCOL      EQU     $2114                  ;COLUMN
FDIR      EQU     $2115                  ;DIRECTION
FFRUIT    EQU     $2116                  ;WHICH FRUIT IT IS
FCOUNT    EQU     $2117                  ;WHERE WE ARE RELATIVE TO CHAR CENTER
FGZONE    EQU     $2118                  ;GOAL ZONE
FGCOL     EQU     $2119                  ;GOAL COLUMN
FGCOUNT   EQU     $211A                  ;WHAT GOAL TO LOOK FOR NEXT
FSCORE    EQU     $211B                  ;IF NON-ZERO, FRUIT IS A SCORE
FTUNNEL   EQU     $211C                  ;WHETHER FRUIT IN TUNNEL
FSOUND    EQU     $211D                  ;SOUND STATE VARIABLE

*  MONSTER STATE VARIABLES
M0VPOS    EQU     $2120                  ;VERTICAL POSITION
M0HPOS    EQU     $2124                  ;HORIZONTAL POSITION
M0ZONE    EQU     $2128                  ;ROW
M0OFF     EQU     VOLIST+2               ;OFFSET
M0COL     EQU     $212C                  ;COLUMN
M0DIR     EQU     $2130                  ;DIRECTION
M0DISP    EQU     $2134                  ;DISPLAY STATE
M0STATE   EQU     $2138                  ;STATE - ACTIVE, BLUE, EYES, ETC
M0SLOW    EQU     $213C                  ;USED TO SLOW DOWN MONSTERS IN PEN
M0BLUE    EQU     $2140                  ;BLUE MODE FLAG
M0SPEED   EQU     $2144                  ;MONSTER SPEED
M0TUNNEL  EQU     $2148                  ;IS IN TUNNEL
M0FLIP    EQU     $214C                  ;IS ABOUT TO FLIP

* SPEED REGISTER STUFF
M0SPEED0  EQU     $2150                  ;MONSTER SPEED REGISTERS (BY 5 SPEEDS)
M0SPEED1  EQU     $2155
M0SPEED2  EQU     $215A
M0SPEED3  EQU     $215F
P0SPEED0  EQU     $2164                  ;PAC SPEED REGISTERS (BY 2 SPEEDS)
P0SPEED1  EQU     $2166
P0SPEED2  EQU     $2168
P0SPEED3  EQU     $216A
REVWAIT   EQU     $216C                  ; REVERSE TIME

*  VARIABLES FOR ANIMATION DRIVER - OVERLAPS MONSTER VARIABLES
ANAOFF    EQU     $2120                  ;OFFSET INTO ANIMATION DATA
ANSOFF    EQU     $2121                  ;OFFSET INTO ANIMATION SEGMENT DATA
ANCOUNT   EQU     $2122                  ;TICS TILL NEXT SEGMENT
ANSTATE   EQU     $2123                  ;VARIOUS USES
ANWHICH   EQU     $2124                  ;WHICH ANIMATION WE ARE WORKING ON
ANFRM     EQU     $2125                  ;HOW MANY FRAMES PER TIC
A0ENABLE  EQU     $2130                  ;WHETHER THIS CHARACTER IS ON
A0VPOS    EQU     $2136                  ;VERTICAL POSITION OF THIS CHARACTER
A0CHAR    EQU     $213C                  ;STAMP FOR THIS CHARACTER
A0HPDIF   EQU     $2142                  ;INDEX INTO HPOS DELTA TABLE
A0VPDIF   EQU     $2148                  ;INDEX INTO VPOS DELTA TABLE
A0ANDIF   EQU     $214E                  ;INDEX INTO ANIMATE CHARACTER TABLE

*         ***** HOLE FROM $2140 TO $21FF SHADOWED IN PAGE 1 *****

*  STAMP DATA AREA - STAMPS IN $1X00-$1X2F, FONT IN $1X30-$1XFF
STAMPS    EQU     $2200                  ;THROUGH THE END OF RAM - INCLUDES FONT
*                 0-1                    BLANK
*                 2-3                    BLACK BAR
*                 4-9                    MS PAC
*                 A-21                   MONSTERS (6 PER)
*                 22-27                  FRUIT
*                 28-2B                  MS PAC BONUS LIFE INDICATOR (4 PER)
*                 30-BF                  FONT
*                 E0-FF                  FRUIT INDICATORS (4 PER) - BANANA FIRST


*
*  MS CONSTANTS

*  SOME SCREEN CONSTANTS
LEFTSIDE  EQU     $18                    ;LEFT SIDE OF VISIBLE SCREEN
RGHTSIDE  EQU     $88                    ;RIGHT SIDE OF VISIBLE SCREEN
TOPSIDE   EQU     $00                    ;TOP SIDE OF VISIBLE SCREEN
OFFSCRN   EQU     $B0                    ;AN OFF SCREEN LOCATION TO PUT INVIS.
LEFTEDGE  EQU     27                     ;A MONSTER HERE IS ON LEFT OF SCREEN
LEFTWRAP  EQU     19                     ;A MONSTER HERE IS ABOUT TO WRAP AROUND
RGHTEDGE  EQU     131                    ;A MONSTER HERE IS ON RIGHT OF SCREEN
RGHTWRAP  EQU     139                    ;A MONSTER HERE IS ABOUT TO WRAP AROUND
WRAPSIZE  EQU     RGHTWRAP-LEFTWRAP      ;SIZE OF TUNNEL WRAP
*
NUMRACKS  EQU     $04                    ;NUMBER OF RACKS
*
*  MONSTER CONSTANTS
MSTATPEN  EQU     $04                    ; IT IS SITTING IN THE PEN *
MSTINPEN  EQU     $03                    ; EYES TRYING TO GET INTO PEN
MSTLVPEN  EQU     $02                    ; MONSTER LEAVING PEN *
MSTEYES   EQU     $01                    ; EYES MOVING ARROUND
MSTNORM   EQU     $00                    ; NORMAL MOVEMENT *
SPDNORM   EQU     $00
SPDBLUE   EQU     $01
SPDSLOW   EQU     $02
SPDRED1   EQU     $03
SPDRED2   EQU     $04
*
* EVENT DRIVER CONSTANTS
MAXEVENT  EQU     $F
*
*  SCREEN LOCATIONS
INITHPOS  EQU     $4F                    ;HPOS OF INITIAL MS PAC PLACE
INITVPOS  EQU     $81                    ;VPOS OF INITIAL MS PAC PLACE
*
*  CONSTANT TIMES TO WAIT FOR THINGS
WAITMON   EQU     $01                    ;WAIT FOR MONSTER MOVES
WAITPAC   EQU     $01                    ;WAIT FOR PAC MOVES
WAITFRT   EQU     $05                    ;WAIT FOR FRUIT MOVES
WAITFLSH  EQU     $08                    ;WAIT FOR FLASHING POWER DOTS
*
*  COLOR DEFINITIONS
BLACK     EQU     $00
LTPINK    EQU     $5E
WHITE     EQU     $0C
PINK      EQU     $57
RED       EQU     $32
GREEN     EQU     $E7
PURPLE    EQU     $63
BLUE      EQU     $98
YELLOW    EQU     $1E
LTBLUE    EQU     $AE
DKBLUE    EQU     $82
BROWN     EQU     $15
LTGREEN   EQU     $EB
LTBROWN   EQU     $3B
GOLD      EQU     $2A
HOTPINK   EQU     $54
ORANGE    EQU     $35
*
*  FONT DEFINITIONS
BLNKCHAR  EQU     $50                    ;BLANK
DOTCHAR   EQU     $51                    ;DOT
EDOTCHAR  EQU     $52                    ;ENERGY DOT
DOORCHAR  EQU     $3D                    ;DOOR TO THE PEN
MARQCHAR  EQU     $7B                    ;START OF MARQUEE CHARACTERS
*
*  JOYSTICK DIRECTIONS
DRIGHT    EQU     0
DDOWN     EQU     1
DLEFT     EQU     2
DUP       EQU     3
DCENTER   EQU     4
DDWRIGHT  EQU     5
DDWLEFT   EQU     6
DUPLEFT   EQU     7
DUPRIGHT  EQU     8
*
P1SCRCOL  EQU     $00                    ;COLUMN FOR PLAYER 1 SCORE
P2SCRCOL  EQU     $15                    ;COLUMN FOR PLAYER 2 SCORE
*
STACKPTR  EQU     $FF                    ;WHERE STACK IS ON PAGE 1
*
GRAPHON   EQU     $48                    ;CTL VALUE FOR NORMAL GRAPHICS
GRAPHOFF  EQU     $FF                    ;CTL VALUE FOR GRAPHICS OFF
