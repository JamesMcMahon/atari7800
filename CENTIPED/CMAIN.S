** CMAIN.S **

* CENTIPEDE MAIN LOOP
* DVP     4/26/84    ALL PAUSE MODE CODE FROM GAMELOOP MOVED INTO CHKSTRT

          ORG     $FF76
          DB      'GCC(C)1984'

          ORG     $FFF8
          DB      $FF,$C7
          DB      L(BURP),H(BURP)
          DB      L(RESET),H(RESET)
          DB      L(RITS),H(RITS)

          ORG     $D800

BURP      PHA                            ;THE RUDE ISR
          JMP     (VECTORI)


RESET
          SEI
          CLD

* NOW ALIEN DOES THIS ALSO
          LDA     #$17                   ;ENCRYPTION CRAPOLA -- GO INTO MARIA
          STA     $01                    ;   MODE.

          LDX     #$7F
          STX     CTRL
          LDX     #$FF                   ;Initialize stack to be in PAGE ONE
          TXS

          INX
          TXA
          STA     CTLSWA                 ;A=0 -- MAKE PORTS READ ONLY
          STA     CTLSWB
          STA     OFFSET                 $0038
          STA     INTIM

ZEROMEM   STA     $1E00,X                KILL THAT LAST DL!!!!!
          STA     $1F00,X
          STA     $2000,X
          STA     $2100,X
          STA     $2700,X
          DEX
          BNE     ZEROMEM

          JSR     CLRTRACK
          JSR     INITALL
          JSR     ONSCREEN
          JSR     OFFSCRN
          LDA     #$43
          STA     CTRL

******************************************
* BEGIN MAIN LOOP OF GAME                *
******************************************

GAMELOOP
          JSR     CHKSTRT                ALL PAUSE MODE CODE NOW IN CHKSTRT
          JSR     CHKEND
          JSR     LOOSENDS
          JSR     JOYSTICK
          JSR     RESTOR
          JSR     EXPLODE
          JSR     FLEASCRP
          JSR     MOVCENTI
          JSR     NEWHD
          JSR     MVSPIDER
          JSR     SHOOT

GAMEWAIT  BIT     OBJTBSEM               ;WAIT UNTIL SEMAPHORE CLEARED BY LOADER
          BMI     GAMEWAIT               ;   ENSURING THAT EVERY GAME PLAY GETS
                                         ;   DISPLAYED AT LEAST ONCE
          LDA     #$80                   ;SET SEMAPHORE
          STA     OBJTBSEM
          INC     FRMCNT
          JMP     GAMELOOP

******************************************
*   END MAIN LOOP OF GAME                *
******************************************


;DEADEND   JMP     DEADEND                ;NONMASKABLE INTERRUPT VECTOR


ONSCREEN  BIT     MSTAT
          BMI     ONSCREEN
          BIT     MSTAT
          BMI     ONSCREEN
          RTS

OFFSCRN   BIT     MSTAT
          BPL     OFFSCRN
          BIT     MSTAT
          BPL     OFFSCRN
          RTS

******************************************
* Perform all initialization to get the system ready to do anything else -- sync
*         Maria with TV screen, etc.
******************************************
INITALL
          LDA     #L(MORPHO)
          STA     VECTORI
          LDA     #H(MORPHO)
          STA     VECTORI+1

          LDA     #H(STMPBASE)
          STA     CHARBASE

          LDX     #ENDLL-DLLTABLE        ;LOAD DLL
LODUPT    LDA     DLLTABLE,X
          STA     DLL,X
          DEX
          BPL     LODUPT

          LDA     #L(DLL)
          STA     DPL
          LDA     #H(DLL)
          STA     DPH

          LDA     INPT4
          STA     DEBOUNCE

          LDA     #-12
          STA     CLRINDEX

          LDX     #$FF
          STX     DEBOUNC1
          STX     PANEL
          INX
          STX     AUDV0
          STX     AUDV1
          STX     TPDL+1
          STX     BACKGRND
          INX
          STX     DIFLEVEL

          LDA     #$80
          STA     ATTRACT

          LDA     #L(SHOT)               ;INITIAL SHOT OFFSET
          STA     SHOTOFST
          STA     SHOTOFST+1

          LDA     #60                    ;ONE SECOND DELAYS
          STA     OPTCNT2                ;NEXT OPTION
          STA     SHOTTIMR               ;GAME START

*******************
INITGAME  LDA     #0                     ;GAME START INITIALIZATION, CLEAR
          LDX     #2                     ;   SCORES
CLRSCRLP  STA     SCORE0,X
          STA     SCORE1,X
          STA     SCORE2,X
          STA     SCORE3,X
          DEX
          BPL     CLRSCRLP

          JSR     CLRTRACK

          LDX     DIFLEVEL
          LDA     DFNSEGS,X              ;DFNSEGS DEFINED AT END OF INITALL
          STA     MAXSGCNT
          STA     CHAINSIZ
          STA     CHAINSIZ+1

*******************
INITATGM  LDA     #0                     ;ATTRACT MODE INITIALIZATION ENTRY PT.
          STA     PAUSETMR
          STA     FLAGS
          STA     PLAYER
          STA     NUMSEG
          STA     FASTWAVE
          STA     NEWHDFLG
          STA     CLRINDEX+1
          STA     HSCFLAG
          STA     SHTRTIMR

          LDX     #17                    ;KILL ALL OBJECTS
CLROBJLP  STA     OBJSTAT,X
          DEX
          BPL     CLROBJLP

          STA     MENLEFT                ;CLEAR THE NUMBER OF MEN LEFT
          STA     MENLEFT+1              ;   VARIABLES AND DISPLAY

          STA     P7C1                   ;LOAD PALETTE 7 FOR BLANK
          LDA     #$CA                   ;COLOR FOR HIGH SCORE
          STA     P7C2
          LDA     #$08
          STA     P7C3                   ;BORDER COLOR

          LDA     #$10
          STA     FASTWAVE+1

          LDX     #0
          JSR     CLRMAPZN

          LDA     #$20                   ;SET INITIAL BONUS VALUES
          STA     BONUSL                 ;   (CURRENTLY FIRST BONUS AT 12,000)
          STA     BONUSL+1
          LDA     #1
          STA     BONUSM
          STA     BONUSM+1

          LDA     #$C0
          STA     NHDCOUNT
          STA     NHDCOUNT+1

          LDA     #-12
          STA     CLRINDEX

          LDA     #CENTPCNT
          STA     LETTRNUM

          JSR     SHTRCLRS               ;SUB. IN DEATH.S TO INIT. SHTR. COLORS

* INITIAL SHOOTER, SHOT POSITION, STATUS, AND GRAPHICS
          BIT     ATTRACT
          BMI     NOPLRS
          JSR     INITPLRS               ;THIS SUBROUTINE IS IN DEATH

NOPLRS    JSR     SCRAPALL

* SET THE FIRST HEADER IN EACH DISPLAY LIST TO POINT TO THE CHARACTER MAP
LOGOINIT                                 ;LOGOINIT IS FOR HSC
          JSR     SETATVAR
          JSR     DLSTINIT               ;SET FIRST HDR. IN EACH DL TO MAP
          JSR     LOADPLWD
          JSR     MAPINIT

          LDA     ATTRACT
          BMI     ENDINIT
          LDA     GAMETYPE
          CMP     #1
          BEQ     MAP2INIT
ENDINIT   RTS

DFNSEGS   DB      10,10,11,12

MAP2INIT  LDA     MUSHCNT
          STA     MUSHCNT+1
          JSR     SWAP


******************************************
MAPINIT
DSPLYOPT
          LDX     #NZONES-2
CLRMAPLP  JSR     CLRMAPZN
          DEX
          BNE     CLRMAPLP

          LDA     ATTRACT
          BPL     LDSHROOM

************************************************************
****      SUBROUTINE DSPLYOPT   - -  DISPLAY GAME OPTIONS IN MENU PAGE
************************************************************
          LDY     DIFLEVEL               ;DIFFICULTY LEVEL DISPLAY
          LDA     DFLVLLOW,Y
          STA     GTEMP1
          LDA     DFLVLHGH,Y
          STA     GTEMP2

          LDA     DFPOS,Y
          TAX
          LDA     DFLNGTH,Y
          TAY
DFLVLLP   LDA     (GTEMP1),Y
          STA     DFLVLDSP,X
          DEX
          DEY
          BPL     DFLVLLP

          LDX     GAMETYPE               ;GAME OPTION DISPLAY
          LDA     ALOW,X
          STA     GTEMP1
          LDA     AHIGH,X
          STA     GTEMP2

          LDY     #22
AOPTLP    LDA     (GTEMP1),Y
          STA     GMTYPDSP,Y
          DEY
          BPL     AOPTLP

;         CPX     #1
;         BNE     ENDDSPOP
;         LDA     #L(TWOCTRLS)
;         LDX     #H(TWOCTRLS)
;         LDY     ALTCTRLS
;         BEQ     CTRLLN
;         LDA     #L(SHRTRCKB)
;         LDX     #H(SHRTRCKB)
;TRLLN    STA     GTEMP1
;         STX     GTEMP2
;         LDY     #14
;TRLLP    LDA     (GTEMP1),Y
;         STA     CTRLDSP+9,Y
;         DEY
;         BPL     CTRLLP

          LDA     ALTCTRLS
          BEQ     ENDDSPOP
          LDY     #14
SHARELP   LDA     SHRTRCKB,Y
          STA     CTRLDSP+9,Y
          DEY
          BPL     SHARELP
ENDDSPOP  RTS


******************************************
* Fill a mushroom map randomly.
* The top 2 lines of PF don't get any mushrooms, next 14 get one or two per row,
* next 6 get 1 per row, last row gets none.
* Starting address of mushroom map, +3*ZONELEN, assumed to be in (GTEMP+1,GTEMP)
* MUSHCNT for current player gets count of mushrooms in infield (bottom N rows)
******************************************
LDSHROOM
          LDA     #H(MUSHMAP+3*ZONELEN)
          STA     GTEMP2
          LDA     #L(MUSHMAP+3*ZONELEN)
          STA     GTEMP1

          LDA     #INFLDZN-4             ;First 9 lines, one or two mush. per
          STA     NLOOPS                 ;line, no count
RMLP1     LDX     #2
          JSR     RNDMUSH
          DEC     NLOOPS
          BNE     RMLP1

          LDA     #0                     ;PLAYER ALWAYS = 1 AT THIS POINT
          STA     MUSHCNT                ;GOING INTO INFIELD, CLEAR MUSHCNT

          LDA     #NZONES-6-INFLDZN      ;Next 5 lines, one or two per line but
          STA     NLOOPS                 ;count
RMLP2     LDX     #2
          JSR     RNDMUSH
          DEC     NLOOPS
          BNE     RMLP2

          LDA     #6                     ;Next 6 lines, one per row, count
          STA     NLOOPS
RMLP3     LDX     #1
          JSR     RNDMUSH
          DEC     NLOOPS
          BNE     RMLP3

          RTS

******************************************
* Place a mushroom randomly in a row; return 0 if mushroom was already there,
* 1 if new mushroom was placed
* On entering, (GTEMP1+1,GTEMP1) should contain starting address of row
******************************************
RNDMUSH   JSR     RANDOM                 ;Pick a random column between 1 and 32,
          AND     #$1F
          BEQ     ZNOMUSH
          TAY
          DEY                            ; then decrement onto line
          LDA     (GTEMP1),Y             ;What's already there?
          CMP     #L(EMPTY)
          BNE     ZNOMUSH
          LDA     #L(LIVE)               ;PUT IN MUSHROOM
          STA     (GTEMP1),Y             ;RETURN TRUE (Z=1) IF NEW MUSHROOM
          INC     MUSHCNT
ZNOMUSH   DEX
          BNE     RNDMUSH


INCROW    LDA     GTEMP1
          CLC
          ADC     #ZONELEN
          STA     GTEMP1
          BCC     ZNR001
          INC     GTEMP2
ZNR001    RTS


CLRMAPZN  LDA     MMAPTBLL,X
          STA     GTEMP1
          LDA     MMAPTBLH,X
          STA     GTEMP2
          LDY     #ZONELEN-1
          LDA     #L(EMPTY)
ZCLRZNLP  STA     (GTEMP1),Y
          DEY
          BPL     ZCLRZNLP
          RTS


***************************************************************************
********  SUBROUTINE LOOSENDS
********  HANDLE LOOSE ENDS (CHANGE WAVES AND PLAYERS, MAKE SHOOTERS AND
********  CENTIPEDES, ETC.
***************************************************************************

LOOSENDS  LDA     SHTRTIMR
          BNE     GOOP
          LDA     DELAYSEG
          BNE     SPDY
          LDA     NUMSEG
          BEQ     SPDY
          LDA     #7
          CMP     TUNNUM
          BEQ     SPDY
          CMP     TUNNUM1
          BEQ     SPDY
          JSR     TUNIN
SPDY      BIT     SPDRSTAT
          BPL     FLECK
          LDA     SPDROFST
          CMP     #L(POINT300)
          BCS     FLECK
          LDA     #1
          CMP     TUNNUM
          BEQ     FLECK
          CMP     TUNNUM1
          BEQ     FLECK
          JSR     TUNIN
FLECK     LDA     FLEAOFST
          CMP     #L(EXPLOS)
          BCS     GOOP
          LDA     FLEASTAT
          AND     #$C0
          CMP     #$80
          BNE     GOOP
          LDA     #5
          CMP     TUNNUM
          BEQ     GOOP
          CMP     TUNNUM1
          BEQ     GOOP
          JSR     TUNIN

GOOP      LDA     NUMSEG
          BEQ     SKPRTSS7
ZSRTS1    RTS

SKPRTSS7  BIT     ATTRACT
          BPL     NRMLMKCN
          LDA     #12
          CLC
          ADC     CLRINDEX
          CMP     #TOPCOLOR
          BNE     SKPRSTCL
          LDA     #0
SKPRSTCL  STA     CLRINDEX
          LDA     #1
          STA     COLORFLG
          DEC     LETTRNUM
          BMI     ATTROVER
          JMP     NRML1234

ATTROVER  JSR     HSATRACT
          BMI     ZSRTS1                 ;RETURN IF BUTTON PRESSED IN HSC

          LDA     #$40
          STA     ATTRACT                ;CHANGE TO ATTRACT MODE GAME PLAY
          LDA     #0
          STA     ATGMTMR                ;COUNT FOR ENDING ATTRACT MODE GAME
                                         ;BIT 7 OF ATGMTMR'S USED AS MOVEMENT
                                         ;   FLAG IN JOYSTICK
          LDA     #$80
          STA     ATSITTMR               ;COUNT FOR SHOOTER TO SIT/MOVE
          STA     ATGMTMR+1
          LDA     #$40
          STA     ATSITTMR+1
          LDA     #-1
          STA     ATTSHTRY               ;Y VECTOR FOR ATTRACT MODE SHOOTER
          STA     ATTSHTRY+1

          JSR     RANDOM
          AND     #$01
          BNE     SKPYDIR1
          LDA     #-1
SKPYDIR1  STA     ATTSHTRX               ;X VECTOR FOR ATTRACT MODE SHOOTER

          JSR     RANDOM
          AND     #$01
          BNE     SKPYDIR2
          LDA     #-1
SKPYDIR2  STA     ATTSHTRX+1             ;X VECTOR FOR ATTRACT MODE SHOOTER

          JMP     INITATGM

NRMLMKCN  LDA     #7                     ;TURN OFF CENTIPEDE FEET SOUND
          JSR     SCRAPONE

          LDX     PLAYER                 ;ROTATE COLORS FOR NEXT CENTIEDE
          LDA     GAMETYPE
          CMP     #2
          BCC     ZNRMLMK1
          LDX     #0
ZNRMLMK1  LDA     CLRINDEX,X
          CLC
          ADC     #12
          CMP     #TOPCOLOR
          BNE     SKPCLRST
          LDA     #0
SKPCLRST  STA     CLRINDEX,X

          LDA     #1                     ;SET FLAG TO CHANGE COLORS
          STA     COLORFLG

          LDA     FASTWAVE,X
          BEQ     WVSPCHNG               ;IF NOT A FAST SPEED WAVE
          DEC     CHAINSIZ,X             ;MAKE CENTIPEDE CHAIN ONE LINK SHORTER
          BNE     SKPSGRST               ;IF CHAIN SIZE IS NOT TOO SMALL
          LDA     MAXSGCNT
          STA     CHAINSIZ,X             ;BACK TO FULL CENTIPEDE CHAIN

SKPSGRST  LDY     PLAYER
          LDA     GAMETYPE               ;USE CORRECT SCORE FOR GAME TO
          CMP     #2                     ;   DETERMINE WHETHER TO HAVE FAST/SLOW
          BCC     FASTSLOW               ;   CENTIPEDES
          LDY     #2
          CMP     #2
          BNE     FASTSLOW
          DEY
          LDA     SCORE2+1
          CMP     SCORE2
          BCS     FASTSLOW
          DEY

FASTSLOW  LDA     SCORE2,Y
          CMP     #4
          LDA     #$10
          BCS     WAVEFAST               ;IF SCORE IS >= 40,000
WVSPCHNG  LDA     FASTWAVE,X
          EOR     #$10
WAVEFAST  STA     FASTWAVE,X             ;CHANGE SPEED OF THE NEXT WAVE
NRML1234  JMP     MAKCENTI



**************************************************************************
********  SUBROUTINE DLSTINIT
********  INITIALIZE DISPLAY LIST HEADERS TO POINT TO THE MUSHROOM MAP
**************************************************************************

DLSTINIT  LDX     #NZONES-2              ;MINUS 1 FOR INDEX, 1 FOR NO CHAR. MAP
                                         ;   FOR LAST ROW
NEXT      LDA     LDLTBL,X               ;ADDRESS OF DL FOR ZONE X
          STA     GTEMP1
          LDA     HDLTBL,X
          STA     GTEMP2

          LDY     #0                     ;WRITE HEADER
          LDA     MMAPTBLL,X
          STA     (GTEMP1),Y             ;STORE LOW ADDRESS

          INY                            ;Y=1
          LDA     #$60                   ;INDIRECT, 160X2 WRITE MODE
          STA     (GTEMP1),Y

          INY                            ;Y=2
          LDA     MMAPTBLH,X
          STA     (GTEMP1),Y             ;STORE HIGH ADDRESS

          INY                            ;Y=3
          LDA     #PALWIDTH
          STA     (GTEMP1),Y             ;STORE PALETTE AND WIDTH

          INY                            ;Y=4
          LDA     #HORIZPOS
          STA     (GTEMP1),Y             ;STORE HORIZONTAL POSITION

          LDY     #6
          LDA     #0                     ;END DL WITH 0 IN PALWIDTH
          STA     (GTEMP1),Y
          DEX
          BNE     NEXT                   ;DO ALL ZONES EXCEPT SCORE -- ZONE 1

          LDA     ATTRACT
          BPL     SCOREDL

******************************************
* SET UP ATTRACT MODE DL'S
******************************************
MKATTRDL
          LDX     #4                     ;BOTTOM HEADERS FOR LOGO DISPLAY LISTS
NEXTATR   LDA     ATTRYBSE/8+LDLTBL,X
          STA     GTEMP1
          LDA     ATTRYBSE/8+HDLTBL,X
          STA     GTEMP2

          LDY     #0
          LDA     LTITLGRP,X
          STA     (GTEMP1),Y

          INY
          LDA     PWATTBL,X
          STA     (GTEMP1),Y

          INY
          LDA     #H(TPG8LIN1)
          STA     (GTEMP1),Y

          INY
          LDA     XPOSOFFS,X
          CLC
          ADC     #HORIZPOS
          STA     (GTEMP1),Y

          LDY     #5
          LDA     #0
          STA     (GTEMP1),Y

SKPHDR2   DEX
          BPL     NEXTATR


;;;;;     LDA     #0
          STA     DL1+1
          LDA     SCRTIMER               ;IF NO PLAY FOR A WHILE, TURN SCORE OFF
          BMI     NOSCRDL                ;DURING TITLE PAGE

******************************************
* SET UP SCORE ZONE DL'S
******************************************
SCOREDL   LDY     #33                    ;HIGH INDEX FOR GAME 3 SCORE DL
          LDA     GAMETYPE
          CMP     #3
          BEQ     ZSCRDL
          LDY     #16                    ;HIGH INDEX FOR GAME 0, 1, 2 SCORE DL

ZSCRDL    LDX     #16
SCRDLLP   LDA     DLSCR012,Y
          STA     DL1,X
          DEY
          DEX
          BPL     SCRDLLP
NOSCRDL   RTS


LTITLGRP  DB      L(TPG8LIN1),L(TPG8LIN2),L(TPG8LIN3),L(TPG8LIN4),L(TPG8LIN5)
XPOSOFFS  DB      16,16,0,0,40
PWATTBL   DB      $C5,$C5,$C2,$C5,PWCOPYRT

DLSCR012  DB      L(MUSHMAP),$60,H(MUSHMAP),$14,HORIZPOS
          DB      L(MUSHMAP+12),$60,H(MUSHMAP+12),$FA,12*4+HORIZPOS
          DB      L(MUSHMAP+19),$60,H(MUSHMAP+19),$34,19*4+HORIZPOS,0,0

DLSCR3    DB      L(MUSHMAP),$60,H(MUSHMAP),$1A,HORIZPOS
          DB      L(MUSHMAP+9),$60,H(MUSHMAP+9),$F2,9*4+HORIZPOS
          DB      L(MUSHMAP+25),$60,H(MUSHMAP+25),$3A,25*4+HORIZPOS,0,0



***************************************************************************
**********        SUBROUTINE  LOADPLWD    --    LOAD THE PALETTE/WIDTH TABLE
***************************************************************************

LOADPLWD
          LDX     MAXSGCNT
          DEX
          BMI     ZNOCENTS               ;IF MAXSGCNT WAS ZERO

          LDA     #PWCENTI               ;LOAD THE PAL/WD BYTES FOR CENTIPEDES
ZLDPWCNT  STA     OBJPALWD,X
          DEX
          BPL     ZLDPWCNT

ZNOCENTS  LDX     MAXSGCNT
          LDA     #PWSPIDER              ;LOAD THE PAL/WD BYTE(S) FOR THE SPIDER
ZLDPWSPI  STA     OBJPALWD,X
          INX
          CPX     #13
          BNE     ZLDPWSPI

          LDA     #PWSCORP
          STA     OBJPALWD+13
          LDA     #PWSHOOTR              ;LOAD THE PAL/WD BYTE FOR THE SHOOTER
          STA     OBJPALWD+14
          ORA     #$20
          STA     OBJPALWD+15
          LDA     #PWSHOT                ;LOAD THE PAL/WD BYTE FOR THE SHOT
          STA     OBJPALWD+16
          ORA     #$20
          STA     OBJPALWD+17
          RTS

****************************************************************
*         SET ATTRACT MODE DEPENDENT VARIABLES
****************************************************************

SETATVAR  LDA     ATTRACT
          BMI     ATTRVAR

          LDA     #MAXX-5
          STA     CENTRGHT
          LDA     #MINX+2
          STA     CENTLEFT

          LDA     #0
          STA     SCRLONZN
          STA     TOPLINE
          LDA     #8
          STA     MINIMUMY
          RTS


ATTRVAR   LDA     #MAXX-6
          STA     CENTRGHT
          LDA     #MINX+3
          STA     CENTLEFT

          LDA     #ATTRYBSE-8
          STA     TOPLINE
          LDA     #ATTRYBSE
          STA     MINIMUMY
          LDA     #ATTRYBSE/8-1
          STA     SCRLONZN
          RTS



RANDOM    LDA     FRMCNT
RANDOM2   ADC     RNDM
          ADC     RNDM+1
          LDY     RNDM
          STY     RNDM+1
          STA     RNDM
          RTS


******************************************
* CHECK WHETHER WE'RE ABOUT TO MEET AN OBSTACLE (MUSHROOM)
* ENTERED WITH    ACC. = VERT. POS. OF MOVING OBJECT
*                 GTEMP1 = HORIZ. POSITION
* RETURNS WITH PLAYFIELD ADDRESS IN (GTEMP4,GTEMP3), CONTENTS OF ADDRESS IN ACC.
******************************************
OBSTAC    LSR     A
          LSR     A
          LSR     A
          BPL     OBBOTH                 ;ALWAYS

COBSTAC   LSR     A
          LSR     A
          LSR     A
          ADC     #0
OBBOTH    CMP     #23
          BEQ     OFFROWZZ
          TAY
          LDA     GTEMP1                 ; (X/4) - 4  , SAME AS (X-16)/4
          LSR     A
          LSR     A
          SEC
          SBC     #MINX/4                ;SUBTRACTING 4, LEAVING CARRY SET
          BMI     OFFROWZZ
          CMP     #$1F
          BCC     OBSTAC2
OFFROWZZ  LDA     #0                     ;SET Z FLAG
          RTS

* ENTRY POINT FROM RESTORE ROUTINE, COLUMN IN ACC., ROW IN Y
OBSTAC2   CLC
          ADC     MMAPTBLL,Y
          STA     GTEMP3
          LDA     MMAPTBLH,Y             ;INCREMENT HIGH BYTE IF NECESSARY
          ADC     #0
          STA     GTEMP4
          LDY     #0
          LDA     (GTEMP3),Y
          CMP     #L(EMPTY)
          RTS



******************************************
* ADD A MUSHROOM TO PLAYFIELD IF NOT ON LAST ROW
* COUNT IF MUSHROOM ADDED TO INFIELD
* ENTERED WITH    ACC. = VERT. POS. OF OBJECT IN QUESTION
*                 (GTEMP4,GTEMP3) POINTING TO PLAYFIELD ADDRESS IN QUESTION
******************************************
MUSHER    LSR     A
          LSR     A
          LSR     A
          BPL     MUBOTH                 ;ALWAYS

CMUSHER   LSR     A
          LSR     A
          LSR     A
          ADC     #0
MUBOTH    BEQ     NOM001
MUSHER1   CMP     #23
          BEQ     NOM001
          CMP     #INFLDZN-1
          BCC     NEWM001

          LDX     PLAYER
          LDA     GAMETYPE
          CMP     #1
          BEQ     INCMUSHC
          LDX     #0                     ;USE ONLY MUSHCNT, NOT MUSHCNT+1, IN
                                         ;   DUAL PLAYER GAMES
INCMUSHC  INC     MUSHCNT,X
NEWM001   LDY     #0
          LDA     #L(LIVE)
          STA     (GTEMP3),Y
NOM001    RTS



******************************************
* RESTORE MUSHROOMS AFTER PLAYER DIES    *
*    FLAGS BIT 6 1=DO RESTORATION        *
*    ROW COUNTER IN GTEMP5               *
*    COLUMN COUNTER IN GTEMP6            *
******************************************
RESTOR    BIT     FLAGS
          BVC     NOM001

          LDA     FRMCNT
          AND     #$07
          BNE     NOM001

          LDX     PLAYER
          LDA     GAMETYPE
          CMP     #2
          BCC     RSTRNEXT               ;NOT A DUAL PLAYER GAME

          LDX     #1                     ;ASSUME PLAYER 1 DIED
          LDA     SHTRSTAT+1
          BNE     RSTRNEXT               ;YES -- PLAYER 2 DIDN'T DIE

          LDA     SHTRSTAT               ;PLAYER 2 DID DIE
          BNE     DRSTR2                 ;   BUT PLAYER 1 DIDN'T

          LDA     FRMCNT                 ;BOTH PLAYERS DIED -- TRADE OFF WHO
          AND     #$08                   ;   GETS POINTS
          BEQ     RSTRNEXT
DRSTR2    DEX

* START LOOP
RSTRNEXT  LDA     GTEMP5                 ;INCREMENT TO NEXT MUSHROOM
          CLC
          ADC     #1
          CMP     #NZONES-1
          BCC     ROWRSTR
          INC     GTEMP6
          LDA     #1
ROWRSTR   STA     GTEMP5

          TAY                            ;GET ROW
          LDA     GTEMP6                 ;COL IN A, ROW IN Y FOR OBSTAC2
          CMP     #ZONELEN
          BCS     DONERSTR

          JSR     OBSTAC2                ;GET CONTENTS OF MUSHROOM SLOT
          CMP     #L(EMPTY+1)
          BCC     RSTRNEXT
          CMP     #L(POISONED+1)
          BCS     RSTRNEXT
          CMP     #L(LIVE)
          BEQ     RSTRNEXT

          LDA     #L(LIVE)
          STA     (GTEMP3),Y
          LDA     #2
          JSR     SCRAPONE
          LDA     #2
          JSR     TUNIN

          LDA     #5
;         LDY     #0
          JSR     ADDSCORE

*PUT IN AN OBJECT EXPLOSION HERE
          LDX     #14
          LDA     SHTRSTAT
          BEQ     USESHTR1
          INX

USESHTR1  LDA     #L(EXPLOS)
          STA     OBJOFFST,X

          LDA     GTEMP6
          ASL     A
          ASL     A
;         CLC
          ADC     #MINX
          STA     OBJX,X

          LDA     GTEMP5
          ASL     A
          ASL     A
          ASL     A
          STA     OBJY,X

          LDA     #$80
          STA     OBJSTAT,X
RSTROK    RTS

DONERSTR  LDA     FLAGS                  ;CLEAR MUSHROOM RESTORATION FLAG,
          AND     #$BF                   ;   ALLOWING GAME TO CONTINUE
          STA     FLAGS

COMPOVER  LDA     GAMETYPE               ;DUAL PLAYER COMPETITION GAME?
          CMP     #2
          BNE     RSTROK                 ;NO

          LDA     FLAGS                  ;EITHER PLAYER DEAD?
          BPL     RSTROK                 ;NO

          LDX     #0                     ;DEAD PLAYER'S SCORE >= LIVE PLAYER'S?
          BIT     SHTRSTAT+1
          BVC     HGHRYET
          INX
HGHRYET   JSR     CMPSCORE
          BCS     RSTROK                 ;YES
          LDA     #0                     ;NO, LIVE PLAYER AHEAD, AND WE HAVE A
          STA     MENLEFT,Y              ;   DEFINITE WINNER
          LDA     #15
          STA     SHTRTIMR
          RTS


* ADD TO SCORE
*         ENTERED WITH (A) = SCORE TO ADD TO TENS, ONES DIGITS
*                      (Y) = SCORE TO ADD TO HUNDREDS, THOUSANDS
*                      (X) = WHICH PLAYER GETS THE POINTS
ADDSCORE  BIT     ATTRACT
          BVS     RSTROK
          SED
          PHA
          LDA     GAMETYPE
          CMP     #3
          BNE     ZADD1

          PLA                            ;IN TWO PLAYER TEAM PLAY MODE,
          PHA                            ;   ADD TO INDIVIDUAL PLAYER'S SCORE
          CLC                            ;   FIRST, THEN DOWN BELOW ADD TO TEAM
          ADC     SCORE0,X               ;   SCORE
          STA     SCORE0,X               ;NO BONUSES OR ANYTHING ARE BASED ON
          TYA                            ;   THE INDIVIDUAL SCORE
          ADC     SCORE1,X
          STA     SCORE1,X
          BCC     TEAMADD
          LDA     SCORE2,X
          ADC     #0
          STA     SCORE2,X
TEAMADD   LDX     #2                     ;TEAM SCORE INDEX

ZADD1     PLA
          CLC
          ADC     SCORE0,X
          STA     SCORE0,X
          TYA
          ADC     SCORE1,X
          STA     SCORE1,X
          BCC     BONUSCHK
          TXA
          TAY
          CPY     #2
          BCC     NHDPLYR
          LDY     #0
NHDPLYR   LDA     NHDCOUNT,Y             ;CHANGE SPEED AT WHICH HEADS COME OUT
          SEC
          SBC     #2                     ;   YES -- DECIMAL MODE
          CMP     #4
          BCS     SKPNHRST               ;IF NEW HEAD TIMER IS ABOVE MINIMUM
          LDA     #$C0
SKPNHRST  STA     NHDCOUNT,Y             ;BACK TO ITS SLOWEST RATE. WHEW!!
          LDA     SCORE2,X               ;NEED TO DO THIS DUE TO DECIMAL MODE
          CLC
          ADC     #1
          STA     SCORE2,X
          BCC     BONUSCHK
          LDA     SCORE3,X
          CLC
          ADC     #1
          STA     SCORE3,X

BONUSCHK  CLD                            ;CHECK FOR BONUS
          LDA     GAMETYPE
          CMP     #3
          BNE     ZBONUSCH
          LDX     #0
          LDA     SCORE1+2
          CMP     BONUSL
          LDA     SCORE2+2
          JMP     ZBONUSZ

ZBONUSCH  LDA     SCORE1,X
          CMP     BONUSL,X
          LDA     SCORE2,X
ZBONUSZ   SBC     BONUSM,X
          BCC     NOBONUS

          CMP     #$90
          BCS     NOBONUS

          SED                            ;YES, GOT A BONUS--SET NEXT BONUS VALUE
          LDA     #$20                   ;   (ONE EVERY 12,000 POINTS, NOW)
;;;;      CLC
          ADC     BONUSL,X
          STA     BONUSL,X
          LDA     #1
          ADC     BONUSM,X
          STA     BONUSM,X
          CLD

          LDA     MENLEFT,X              ;ADD A LIFE, IF POSSIBLE
          CMP     #6
          BCS     NOBONUS

          LDY     GAMETYPE
          CPY     #3
          BNE     NORESMAN
          BIT     FLAGS                  ;DURING MUSHROOM RESTORATION, JUST ADD
          BVS     NORESMAN               ;   MAN TO TOTAL
          LDA     SHTRSTAT               ;IN TEAM PLAY, IF ONLY ONE PLAYER ALIVE
          AND     SHTRSTAT+1             ;   RES THE OTHER ONE IN
          BPL     RESMAN

NORESMAN  LDA     SHTRSTAT,X             ;ONCE HE'S DEAD IN NON-TEAM PLAY, DON'T
          AND     #$40                   ;   EVER BRING HIM BACK
          BNE     NOBONUS

          LDA     MENLEFT,X
          CLC
          ADC     #1
          STA     MENLEFT,X

          CPX     #0
          BEQ     ADDLIFE1

ADDLIFE2  EOR     #$FF
          CLC
          ADC     #21
ADDLIFE1 ;LDY     GAMETYPE
          CPY     #3
          BNE     ADD1
          CLC
          ADC     #TEAMMEN-6
ADD1      TAY
          LDA     #L(ELF320)
          STA     MUSHMAP+6-1,Y

MANSOUND  LDA     #6                     ;TURN ON EXTRA MAN SOUND
          JSR     TUNIN

NOBONUS   BIT     FLAGS
          BVS     ENDBONUS
          JMP     COMPOVER
ENDBONUS  RTS




RESMAN                                   ;RES A MAN INTO PLAY, TEAM PLAY
          LDX     #0
          LDA     SHTRSTAT
          BPL     RESBACK
          LDX     #1
RESBACK   LDA     FLAGS
          AND     #$7F
          STA     FLAGS
          LDA     #CNTRCLMN
          STA     SHOOTERX,X
          LDA     #CNTRCLMN+2
          STA     SHOTX,X
          LDY     #184
          STY     SHOOTERY,X
          DEY
          STY     SHOTY,X
          LDA     #L(ELF)
          CPX     #0
          BEQ     RESELF
          LDA     #L(ELFB)
RESELF    STA     SHTROFST,X
          LDA     #$90                   ;TURN HIM BACK ON, RES HIM IN
RESFRONT  STA     SHTRSTAT,X
          JMP     MANSOUND

SCALE     CLC
          BPL     NOTNEG
          EOR     #$FF
          ADC     #2                     ;TWOS COMP AND ADD 1
          LSR     A                      ;DIVIDED BY 2
          CMP     #$3
          BCC     OKDOKEY
          LDA     #$3
OKDOKEY
          EOR     #$FF                   ;RENEGE
          CLC
          ADC     #1
          RTS                            ;SCALED VALUE IN ACC
NOTNEG
          ADC     #1
          LSR     A
          CMP     #$3
          BCC     RETUX
          LDA     #$3
RETUX     RTS



CLRTRACK  LDX     #$06                   ;CLEAR OUT ALL TBALL STUFF
          LDA     #$00
TLOOPY    STA     DELTAY,X
          DEX
          BPL     TLOOPY
          STX     BUTNIB
          STX     BUTNIB+1
          STX     SCHTICK
          LDA     YCOUNT
          STA     OLDY
          LDA     YCOUNT1
          STA     OLDY1
          LDA     XCOUNT
          STA     OLDX
          LDA     XCOUNT1
          STA     OLDX1
          RTS

