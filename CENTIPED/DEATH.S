*** DEATH.S ***
* DVP     4/26/84   ALL PAUSE MODE CODE NOW LOCALIZED IN CHKSTRT
* DVP     8/12    CHECK FOR START AND END OF GAME, COLLISIONS WITH SHOOTER,
*                 AND HANDLE FIRING AND EXPLOSIONS

STRTMEN   EQU     3                      ;HOW MANY MEN DO WE START GAME WITH?
STRTDUAL  EQU     6                      ;START DUAL GAME WITH 2 ON SCREEN, 4
                                         ;   EXTRA
TEAMMEN   EQU     17                     ;LEFTMOST MAN LOCATION IN TEAM MAN POOL


CHKSTRT   JSR     STICKIT0               ;DO TRACKBALL CRAP
          LDA     FRMCNT                 ;DISPLAY OF THE SCORE IS DISABLED
          BNE     CHKSTRT1               ;   WHEN SCRTIMER IS NEGATIVE
          LDA     ATTRACT                ;   THIS CHUNK INCREMENTS THE VALUE
          BEQ     CHKSTRT1               ;   DURING ATTRACT MODE;  LATER IN THIS
          LDX     SCRTIMER               ;   ROUTINE, ANY INPUT SETS SCRTIMER
          BMI     CHKSTRT1               ;   BACK TO 0
          INC     SCRTIMER

CHKSTRT1  LDA     PANEL                  ;TEST RESET SWITCH
          LSR     A
          BCS     RSTDBNC
          STA     DEBOUNC1
          RTS

RSTDBNC   LDA     #$FF
          EOR     DEBOUNC1
          BPL     SKPGMRST
          STA     DEBOUNC1               DEBOUNC1 SHOULD BE NEGATIVE ON LEAVING
          JMP     GMRESET

SKPGMRST  LDA     ATTRACT                ;NO RESET -- IN GAME SELECT?
          BPL     NOOPTSET
          JMP     SETGMOPT

* GAME PLAY OR ATTRACT
NOOPTSET
          LDA     PANEL                  ;TEST GAME SELECT SWITCH DURING GAME
          AND     #$02
          BNE     THATSALL               ;BRANCH IF SWITCH NOT PRESSED
          JMP     GOINTOTP

THATSALL  LDA     ATTRACT
          BEQ     PAUSEME
          JMP     SKPNORST

* GAME PLAY
* PAUSE HANDLING
PAUSEME
          LDA     PANEL
          LDX     PAUSETMR               CURRENTLY PAUSED?
          BNE     PAUSED                    YES

*********** NOT CURRENTLY PAUSED
          AND     #$08                   IS BUTTON PRESSED?
          BEQ     STRTPAUS
          RTS                               NO
STRTPAUS  LDX     #1                     THIS DISABLES TUNER FROM RUNNING
          STX     PAUSETMR
          DEX
          STX     AUDV0                  YES, START PAUSE
          STX     AUDV1
WAITPSE   LDA     PANEL                  AND WAIT FOR BUTTON TO BE RELEASED
          AND     #$08                      (PANEL IS UPDATED AT 60 HZ.)
          BEQ     WAITPSE
STAYPSD   LDA     PANEL                  INTERNAL PAUSE LOOP CHECK OF RESET
          LSR     A                         BUTTON
          BCS     NOOPTSET               NOT PRESSED
WAITRST   LDA     PANEL                  PRESSED, WAIT FOR RELEASE
          LSR     A
          BCC     WAITRST
          JMP     GMRESET

*********** CURRENTLY PAUSED WITH DMA STILL ON
PAUSED    AND     #$08                   IS BUTTON PRESSED?
          BEQ     ENDPAUSE                  YES, ENDPAUSE
          JSR     ONSCREEN
          JSR     OFFSCRN
          INC     PAUSETMR+1             NO, INCREMENT TIME.  EVERY FRAME
          BNE     STAYPSD
          INC     PAUSETMR               EVERY 256 FRAMES
          LDA     PAUSETMR
          CMP     #$FF
          BNE     STAYPSD

*********** 18 MINUTE TIMEOUT
          LDX     #$7F                   TURN DMA OFF
          STX     CTRL
          LDA     #L(MORPHO)             TOP OF SCREEN VECTOR
          STA     VECTORI
          LDA     #H(MORPHO)
          STA     VECTORI+1

BLANKLP   JSR     ONSCREEN
          JSR     OFFSCRN                SINCE DMA IS OFF ...
          JSR     TRACKIT                FOR COMING OUT OF PAUSE WITH TRACKBALL
          LDX     #1                     RESET PAUSE TIMER AND TURN SCREEN BACK
          JSR     STICKIT                   ON IF WE SEE ANY ...
          CMP     #$F0                   JOYSTICK MOVEMENT
          BMI     UNBLANK
          JSR     STICKIT0
          CMP     #$F0
          BMI     UNBLANK
          LDA     BUTNIB                 OR BUTTON PUSHES
          AND     BUTNIB+1
          BPL     UNBLANK
          LDA     PANEL                  OR SELECT OR RESET PUSHES
          AND     #$03
          CMP     #$03
          BNE     ENDBLANK
          LDA     PANEL                  PAUSE BUTTON PRESSED?
          AND     #$08
          BNE     BLANKLP                   NO

*********** RESTART GAME AFTER TIMEOUT
ENDBLANK  JSR     TURNON                 TURN DMA ON
ENDPAUSE  LDA     PANEL                  WAIT FOR BUTTON TO BE RELEASED
          AND     #$08
          BEQ     ENDPAUSE
          LDA     PANEL                  DID RESET BRING US OUT OF BLANK?
          LSR     A
          BCS     RESUME                 NO
WAITRST2  LDA     PANEL                  RESET PRESSED, WAIT FOR RELEASE
          LSR     A                         DON'T TURN PAUSE OFF YET SO SOUND
          BCC     WAITRST2                  STAYS OFF
          JMP     GMRESET

RESUME    LDA     #0                     TURN PAUSE OFF, RESUME GAME PLAY
          STA     PAUSETMR
          RTS

*********** RESTART PAUSE AFTER SELECT OR RESET WHEN SCREEN BLANK
UNBLANK   LDA     #1
          STA     PAUSETMR
          JSR     TURNON
          JMP     STAYPSD

*********** RESTART DISPLAY
TURNON    JSR     ONSCREEN               TURN DMA ON
          JSR     OFFSCRN
          LDX     #$43
          STX     CTRL
          RTS


* ATTRACT MODE
SKPNORST
          LDA     SCHTICK                ;CHECK JOYSTICK DURING ATTRACT GAME
          ORA     #$0F                   ;   PLAY;  ANY MOVEMENT GOES INTO
          EOR     #$FF                   ;   TITLE PAGE TO START GAME SELECT
          BEQ     SWTCHCLR
          LDA     #1
          STA     DEBOUNC2
SKMNPGJP  JMP     SKPMENPG               ;ALWAYS

SWTCHCLR  LDA     DEBOUNC2
          BEQ     SKMNPGJP
GOINTOTP  LDA     #60
          STA     OPTCNT2
          LDA     #0
          STA     DEBOUNC2

;;;;;     LDA     #0
          STA     SCRTIMER
          JSR     SCOREDL                ;DISPLAY SCORES AGAIN IN TITLE PAGE

          LDA     #$80
          STA     ATTRACT
          JMP     INITATGM


* TITLE PAGE
SETGMOPT  LDA     PANEL                  ;CHECK GAME SELECT SWITCH IN TITLE PAGE
          AND     #$02
          BEQ     SELECTIT
          LDA     #$00                   ;SET NEXT CHANGE TO HAPPEN WHEN SWITCH
          STA     OPTCNT2                ;   PRESSED
          BEQ     NOGMSEL                ;ALWAYS

SELECTIT  LDA     #0                     ;SWITCH WAS PRESSED
          STA     SCRTIMER               ;   DISPLAY SCORES AGAIN IN TITLE PAGE
          JSR     SCOREDL

          DEC     OPTCNT2                ;DELAY BETWEEN CHANGES WHILE SWITCH
          BPL     NOGMSEL                ;   DOWN
          LDA     #45
          STA     OPTCNT2
          JSR     NXTGMOPT               ;SWITCH PRESSED, GO TO NEXT OPTION
          JMP     UPDATDSP

NOGMSEL   LDA     SCHTICK                ;CHECK FOR JOYSTICK MOVEMENT DURING
          STA     GTEMP1                 ;   TITLE PAGE GAME SELECT
          ORA     #$0F
          EOR     #$FF
          BNE     SKPOPCTZ

          LDA     #0                     ;NO INPUT
          STA     OPTCNT1
GOSKPMN   JMP     LVMENUPG               ;ALWAYS

SKPOPCTZ  LDA     #0
          STA     SCRTIMER
          JSR     SCOREDL                ;DISPLAY SCORE AGAIN IN TITLE PAGE

          DEC     OPTCNT1                ;WHAT IS OPTCNT1, 2?
          BPL     GOSKPMN
          LDA     #30
          STA     OPTCNT1
          LDA     GTEMP1
          BMI     NOATEAST
          LDA     DIFLEVEL
          CMP     #3
          BEQ     UPDATDSP
          INC     DIFLEVEL               ;INCREASE DIFFICULTY
          BNE     UPDATDSP               ;ALWAYS
NOATEAST  ASL     A
          BMI     CHKPLYNM
DFWEST    LDA     DIFLEVEL
          BEQ     UPDATDSP
          DEC     DIFLEVEL               ;DECREASE DIFFICULTY
          BPL     UPDATDSP               ;ALWAYS

CHKPLYNM ;LDA     GTEMP1
         ;ASL     A
          ASL     A
          BMI     NOATSTH

          LDA     GAMETYPE
          AND     ALTCTRLS
          CMP     #1
          BNE     ALTTP2
          LDA     #0
          STA     ALTCTRLS
          BEQ     UPDATDSP

ALTTP2    LDA     GAMETYPE
          CMP     #2
          BNE     INCGMTP2
          LDA     TRACKF
          BEQ     INCGMTP2
          LDA     TRACKF+1
          BNE     INCGMTP2               ;TWO TRACKBALLS
NXTGMTP2  LDA     #1                     ;SHARE THE TRACKBALL
          STA     ALTCTRLS

INCGMTP2  LDA     GAMETYPE
          BEQ     UPDATDSP
          DEC     GAMETYPE               ;DECREASE GAMETYPE
          BPL     UPDATDSP

NOATSTH   ASL     A
          BMI     UPDATDSP

          JSR     INCALT
          BNE     UPDATDSP

          LDA     GAMETYPE
          CMP     #3
          BEQ     UPDATDSP
          INC     GAMETYPE               ;INCREASE GAMETYPE

UPDATDSP
          LDA     #0
          LDX     #2
ZSCRLP    STA     SCORE0,X
          STA     SCORE1,X
          STA     SCORE2,X
          DEX
          BPL     ZSCRLP

          LDX     #0
          JSR     CLRMAPZN

          LDA     #1                     ;WHEN AN INPUT HAS BEEN RECEIVED, KEEP
          STA     LETTRNUM               ;   TITLE PAGE UP THERE LONGER

LVMENUPG  JSR     DSPLYOPT

SKPMENPG  LDA     SHOTTIMR               ;CHECK FOR BUTTON RESTART
          BEQ     CHKBTTN
          DEC     SHOTTIMR
          BNE     NORESET

CHKBTTN   LDA     BUTNIB                 ;GAME START WHEN BUTTON COMES UP
          BMI     BTNUP
          STA     DEBOUNCE               ;INPT4 LOW (BTN. DOWN), SET DEBOUNCE LO
NORESET   RTS

BTNUP     EOR     DEBOUNCE
          BPL     NORESET
          STA     DEBOUNCE               ;INPT4 HIGH (BTN. UP), DEBOUNCE LOW
                                         ;   =START, DEBOUNCE HIGH

******************************************
* RESET -- START A NEW GAME
******************************************
GMRESET   LDA     #$00                   ;TURN ON GAME AND INITIALIZE
          STA     SCRTIMER
          STA     ATTRACT
          JSR     INITGAME

          LDX     #STRTMEN-1             ;SET THE NUMBER OF MEN LEFT IN GAME
          STX     MENLEFT                ;   AND DISPLAY IT

          LDY     GAMETYPE
          BEQ     ZINITLV1               ;ONE PLAYER GAME
          DEY
          BEQ     ZINITLVX               ;TWO PLAYER ALTERNATING
          DEY
          BEQ     ZINITLV2               ;TWO PLAYER SIMULTANEOUS

          LDX     #STRTDUAL-2            ;TEAM PLAY -- MEN LEFT POOL
          STX     MENLEFT
          LDA     #L(ELF320)
INITLVB   STA     MUSHMAP+TEAMMEN-1,X
          DEX
          BNE     INITLVB
          RTS

ZINITLVX  INX
ZINITLV2  STX     MENLEFT+1

          LDY     #5
          LDA     #L(ELF320)
INITLV2   STA     MUSHMAP+ZONELEN-12,Y
          DEY
          DEX
          BNE     INITLV2

ZINITLV1  LDX     MENLEFT
          LDA     #L(ELF320)
INITLV1   STA     MUSHMAP+6-1,X
          DEX
          BNE     INITLV1

          RTS


******************************************
***       CHANGE GAME OPTIONS
******************************************

NXTGMOPT
          INC     DIFLEVEL
          LDA     DIFLEVEL
          CMP     #4
          BNE     NOGMEND
          LDX     #0
          STX     DIFLEVEL

          JSR     INCALT
          BNE     NOGMEND

INCGMTP   INC     GAMETYPE
          LDA     GAMETYPE
          CMP     #4
          BNE     NOGMEND
WRAPGMTP  STX     GAMETYPE
NOGMEND   RTS

INCALT    LDA     GAMETYPE
          CMP     #1
          BNE     NEXTGMTP
          LDA     ALTCTRLS
          BNE     NEXTGMTP
          LDA     TRACKF
          BEQ     NEXTGMTP
          LDA     TRACKF+1
          BNE     NEXTGMTP               ;TWO TRACKBALLS
          LDA     #1
          STA     ALTCTRLS               ;SHARE THE TRACKBALL
          BNE     INCALTND

NEXTGMTP  LDA     #0
          STA     ALTCTRLS
INCALTND  RTS

********************************************************************************
*         CHKEND                                                               *
* CHECK FOR THE END OF A GAME AND THE END OF EACH PLAYER'S TURN                *
********************************************************************************
CHKEND    LDA     SHTRTIMR
          BEQ     NOGMEND

* CHECK TO MAKE SURE MUSHROOM RESTORATION HAS FINISHED BEFORE PROCEEDING
          BIT     FLAGS
          BVS     NOGMEND

          SEC
          SBC     #1
          STA     SHTRTIMR
          AND     #$7F
          BNE     NOGMEND

          LDA     GAMETYPE
          CMP     #2
          BCC     CHKEND1                ;NOT A DUAL PLAYER MODE
          LDX     #0
          STX     PLAYER
;;;;;     LDA     GAMETYPE
          CMP     #3
          BEQ     CHKEND1

          LDA     MENLEFT                ;IS THERE A MESSAGE UP?
          AND     #$C0
          BNE     CHKEND1
          LDA     MENLEFT+1
          AND     #$C0
          BNE     CHKEND2
          LDA     SHTRSTAT               ;ONLY CHECK SHOOTER WITH POSITIVE
          BEQ     CHKEND1                ;   STATUS (HAS BEEN BLOWN AWAY)
CHKEND2   INC     PLAYER

CHKEND1   BIT     ATTRACT
          BMI     NOGMEND
          BVC     SKPGMATR

******************************************
* ATTRACT MODE GAME OVER?
******************************************
          LDA     ATGMTMR
          AND     #$7F
          CMP     #20
          BCC     ZGAME
          JMP     GAMEDONE
ZGAME     LDA     #-1
          STA     ATTSHTRY
          STA     ATTSHTRY+1
          JMP     INATGAME

******************************************
* "PLAYER X" MESSAGE DISPLAYED LONG ENOUGH, START PLAYING AGAIN
******************************************
OTHERPLR                                 ;GET RID OF "PLAYER x " MESSAGE AT
          LDA     MENLEFT,X              ;   START OF A PLAYER'S TURN
          AND     #$07
          STA     MENLEFT,X

          LDA     #0
          STA     SHTRTIMR

ERSPLR    LDY     #8
ERASEPLR  LDA     MSGSTORE+9,Y
          STA     MUSHMAP+13*ZONELEN+11,Y
          DEY
          BPL     ERASEPLR
          RTS

******************************************
* SOMEBODY DIED RECENTLY, DO SOMETHING ABOUT IT
******************************************
SKPGMATR
          LDX     PLAYER
          LDA     MENLEFT,X
          BEQ     OUTOFGM                ;SOMEBODY'S GAME JUST ENDED
          BPL     ZCONTGM
          JMP     ZMSGOVER               ;"GAME OVER" MESSAGE DONE DISPLAYING
ZCONTGM   AND     #$40
          BNE     OTHERPLR               ;"PLAYER X" MESSAGE DONE, RESUME PLAY
JMPINGM   JMP     INGAME                 ;GAME STILL IN PROGRESS

******************************************
* SOMEBODY'S GAME JUST ENDED, DISPLAY
*   "GAME OVER ,  PLAYER X" MESSAGE
******************************************
OUTOFGM   LDA     GAMETYPE
          CMP     #3
          BNE     GAMEOUT

          LDA     SHTRSTAT               ;A TEAM PLAY GAME DOESN'T END UNTIL
          ORA     SHTRSTAT+1             ;   BOTH PLAYERS HAVE DIED
          BPL     GAMEOUT
          LDA     #$40
          LDY     SHTRSTAT
          BMI     NOTDEAD1
          STA     SHTRSTAT
          BPL     DEAD1                  ;ALWAYS
NOTDEAD1  STA     SHTRSTAT+1
DEAD1     LDA     FLAGS
          ORA     #$80
          STA     FLAGS
          JMP     INATGAME

GAMEOUT   LDY     #8                     ;DISPLAY "GAME  OVER"
ZDSPGOVR  LDA     MUSHMAP+12*ZONELEN+11,Y
          STA     MSGSTORE,Y
          LDA     MGMOVER,Y
          STA     MUSHMAP+12*ZONELEN+11,Y
          DEY
          BPL     ZDSPGOVR

          LDY     GAMETYPE               ;IN ONE PLAYER OR TEAM PLAY GAMES,
          DEY                            ;   DON'T CARE WHICH PLAYER
          CPY     #2
          BCS     STMSGTMR

* ALTERNATING OR COMPETITION GAME
          LDA     SHTRTIMR               ;DID BOTH PLAYERS LOSE A LIFE?
          BPL     COMPCHK                ;NO

          LDA     MENLEFT                ;DID BOTH PLAYERS GAMES END?
          ORA     MENLEFT+1
          BEQ     STBTHVR                ;YES

          LDA     MENLEFT                ;IF OTHER PLAYER GOT BROUGHT BACK TO
          AND     MENLEFT+1              ;   LIFE BY MY MUSHROOM RESTORATION,
          BEQ     COMPCHK                ;   CLEAR THE FLAG
          LDA     FLAGS
          AND     #$7F
          STA     FLAGS

COMPCHK   DEY                            ;AFTER THIS, Y=#$FF=ALT, Y=0=COMP
          BNE     PLRXOVER               ;ALTERNATING

          BIT     FLAGS                  ;IS OTHER PLAYER ALSO DEAD?
          BMI     WHOWINS                ;YES

;;;;;     LDX     PLAYER                 ;IS SCORE OF PLAYER WHO DIED HIGHER
          JSR     CMPSCORE               ;   THAN OR SAME AS PLAYER WHO LIVED?
          BCS     PLRXOVER               ;YES--KEEP PLAYING
          LDA     FLAGS                  ;NO, OTHER PLAYER WON AND GAME IS OVER
          ORA     #$80
          STA     FLAGS
          BCC     OTHRWINS

* DISPLAY "PLAYER X"
PLRXOVER  JSR     SHOWPLR1               ;"PLAYER 1" MESSAGE
          LDX     PLAYER                 ;GET CORRECT PLAYER NUMBER
          TXA
          CLC
          ADC     #L(DGT1)
          STA     MUSHMAP+13*ZONELEN+19  ;PUT CORRECT PLAYER NUMBER UP
          JMP     STMSGTMR

* SET BOTH-GAMES-OVER FLAG
STBTHVR   LDA     FLAGS                  ;BOTH DIED, SET FLAG TO SHOW OTHER
          ORA     #$80                   ;   PLAYER'S GAME HAS ENDED
          STA     FLAGS

* DECIDE WHICH PLAYER WON
WHOWINS
;;;;;     LDX     PLAYER
          JSR     CMPSCORE
          BCC     OTHRWINS               ;OTHER PLAYER DEFINITELY WON
          TYA
          TAX                            ;SWITCH PLAYERS
          JSR     CMPSCORE
          BCS     GAMETIED
                                         ;SWITCH BACK
OTHRWINS  TYA
          TAX

* DISPLAY "PLAYER X WINS"
PLRXWINS  LDY     #12                    ;PUT UP "PLAYER  1WINS"
ZDSPWINR  LDA     MPLAYER,Y
          STA     MUSHMAP+14*ZONELEN+9,Y
          DEY
          BPL     ZDSPWINR

          TXA
          CLC
          ADC     #L(DGT1)
          STA     MUSHMAP+14*ZONELEN+16  ;PUT CORRECT PLAYER NUMBER UP
          LDA     #L(EMPTY)
          STA     MUSHMAP+14*ZONELEN+17

* SET TIMER FOR MESSAGE
STMSGTMR  DEC     MENLEFT,X              ;SET MENLEFT,X = #$FF AS "GAME OVER"
                                         ;   DISPLAY FLAG
          LDA     SHTRTIMR
          ORA     #$7F                   ;SET TIMER TO LEAVE GAME OVER MESSAGE
          STA     SHTRTIMR               ;   UP
          RTS

GAMETIED  LDY     #12                    ;PUT UP "YOU HAVE TIED"
ZDSPTIE   LDA     MTIE,Y
          STA     MUSHMAP+14*ZONELEN+9,Y
          DEY
          BPL     ZDSPTIE
          BMI     STMSGTMR

******************************************
* "GAME OVER" MESSAGE DISPLAYED LONG ENOUGH
******************************************
ZMSGOVER  LDA     GAMETYPE
          BEQ     DONEHSCR               ;ALWAYS HIGH SCORE IN ONE PLAYER

          CMP     #3
          BEQ     GMEDONE                ;NEVER HIGH SCORE AT TOP IN TEAM PLAY

          LDA     FLAGS                  ;IN TWO PLAYER MODES, WE'RE STILL IN
          BPL     NOTGMVR                ;   GAME IF OTHER PLAYER HADN'T ALREADY
                                         ;   DIED

******************************************
* ALL GAMES HAVE ENDED -- DO SOMETHING ABOUT IT
******************************************
DONEHSCR  JSR     CHKHSCR                ;CHECK HIGH SCORE AT TOP OF DISPLAY

GMEDONE   LDX     #0
          LDA     GAMETYPE               ;TEAM PLAY?
          BEQ     TMHSC0
          CMP     #3
          BNE     NOTMHSC
          JSR     CMPSCORE               ;YES--IS PLAYER 1'S SCORE HIGHER?
          BCS     TMHSC0                 ;   YES
          BCC     TMHSC1                 ;   NO--USE PLAYER 2

NOTMHSC   JSR     HSCNTR1
TMHSC1    LDX     #1
TMHSC0    JSR     HSCNTR1

GAMEDONE  LDA     #$80
          STA     ATTRACT
          JMP     INITATGM               ;INITIALIZE GAME ATTRACT MODE

******************************************
* RESTART THE OTHER PLAYER IN A TWO PLAYER ALTERNATING OR SIMULTANEOUS GAME
*   AFTER OTHER PLAYER'S GAME JUST ENDED
******************************************
NOTGMVR   ORA     #$80
          STA     FLAGS                  ;SET THAT FLAG

          LDA     #0                     ;DELETE "GAME OVER" DISPLAY FLAG
          STA     MENLEFT,X
          LDA     #$40                   ;INDICATE THAT THIS PLAYER'S GAME IS
          STA     SHTRSTAT,X             ;   OVER

          LDA     GAMETYPE
          CMP     #2
          BNE     ALTGM                  ;BRANCH IF ALTERNATING GAME

          LDY     #8                     ;IN SIMULTANEOUS GAME, MUST ERASE
ZERSGOVR  LDA     MSGSTORE,Y             ;   "GAME OVER" FROM MUSHROOM FIELD
          STA     MUSHMAP+12*ZONELEN+11,Y
          DEY
          BPL     ZERSGOVR
          BMI     SIMULTGM               ;"PLAYER  X" MESSAGE STAYS UP AS READY
                                         ;   MESSAGE

******************************************
* ENTRY POINT FOR RESTARTING GAMES AFTER LOSING A LIFE, NOT A GAME
******************************************
INGAME    LDA     GAMETYPE
          CMP     #1
          BNE     INGAME1P

* TWO PLAYER ALTERNATING GAME, SWITCH PLAYERS IF BOTH ALIVE
          LDA     FLAGS
          BMI     INGAME1P               ;BRANCH IF ONLY ONE ALIVE

ALTGM     JSR     SWAP
          JSR     SHOWPLR1               ;DISPLAY "PLAYER 1"

SIMULTGM  LDA     #1
          STA     COLORFLG
          EOR     PLAYER
          TAX
          STX     PLAYER

          CLC
          ADC     #L(DGT1)
          STA     MUSHMAP+13*ZONELEN+19  ;PUT CORRECT PLAYER NUMBER UP

          LDA     MENLEFT,X              ;SET "PLAYER X" MESSAGE FLAG
          ORA     #$40
          STA     MENLEFT,X

          LDA     SHTRTIMR
          ORA     #$7F                   ;TIME TO LEAVE IT UP
          STA     SHTRTIMR
          BMI     KILL1                  ;HANDLES CASE OF BOTH PLAYERS DYING
                                         ;   OTHER PLAYER LOST GAME, THIS ONE
                                         ;   DIDN'T

          LDA     GAMETYPE               ;AT THIS POINT IN SIMULT. GAME, OTHER
          CMP     #2                     ;   PLAYER'S GAME JUST ENDED AND THIS
          BEQ     INATGAME               ;   PLAYER SHOULDN'T LOSE A LIFE

******************************************
* REMOVE AN EXTRA MAN TO BE USED AS CURRENT MAN
******************************************
INGAME1P
          LDA     SHTRTIMR               ;SHTRTIMR IS NEGATIVE IF BOTH PLAYERS
          BPL     KILL1                  ;   DIED IN SAME FRAME

* BOTH PLAYERS LOST A LIFE
          LDA     GAMETYPE               ;TEAM PLAY?
          CMP     #3
          BNE     KILL2                  ;NO
          LDA     MENLEFT
          BNE     STILLTM
          JMP     GAMEOUT                ;LOST TWO LIVES, ENDING THE GAME

STILLTM
;;;;;     LDX     #0                     ;YES
          JSR     TAKEMAN
          DEC     MENLEFT                ;IN GAME 3 PLAYER ALWAYS IS 0
          BNE     KILL1
* AT THIS POINT IN TEAM PLAY GAME, ONLY ONE PLAYER CONTINUES -- DECIDE WHICH
          LDX     #1
          JSR     CMPSCORE
          LDA     #$40                   ;PLAYER 2 CONTINUES
          LDY     #$80
          BCS     GOPLR2
          TAY                            ;PLAYER 1 CONTINUES
          ASL     A
GOPLR2    STA     SHTRSTAT
          STY     SHTRSTAT+1
          LDA     FLAGS
          ORA     #$80
          STA     FLAGS
          BNE     INATGAME

KILL2     LDX     #1                     ;DUAL PLAYER COMPETITION, BOTH PLAYERS
          STX     PLAYER                 ;   LOST A LIFE.  WE KNOW PLAYER 1'S
          LDA     MENLEFT+1              ;   GAME ISN'T OVER, HOW ABOUT PLAYER
          BNE     DOKILL2                ;   2'S?
          JMP     OUTOFGM
DOKILL2   JSR     TAKEMAN
          DEC     MENLEFT+1
          LDX     #0
          STX     PLAYER

KILL1  ;  LDX     PLAYER
          JSR     TAKEMAN
          DEC     MENLEFT,X              ;DEDUCT A LIFE

******************************************
* INITIALIZE TO START PLAYING AGAIN
******************************************
INATGAME  LDA     #$00
;;;;;     STA     SHOTSTAT               ;THIS IS ALWAYS SET TO $80 LATER
          STA     SHOTSTAT+1

          LDA     SHTRTIMR
          AND     #$7F
          STA     SHTRTIMR

          JSR     MAKCENTI

          LDA     #$00
          STA     FLEASTAT

          STA     SPDRSTAT
          LDX     DIFLEVEL
          LDA     SPDRWTDF,X
          STA     SPDRTIMR


* PUT THE SHOOTERS BACK TOGETHER
INITPLRS  LDA     #CNTRCLMN              ;CALLED AS SUBROUTINE FROM CMAIN
          STA     SHOOTERX
          STA     SHOOTERX+1
          LDA     #CNTRCLMN+2
          STA     SHOTX
          STA     SHOTX+1
          LDY     #184
          STY     SHOOTERY
          STY     SHOOTERY+1
          DEY
          STY     SHOTY
          STY     SHOTY+1
          LDA     #L(ELF)
          STA     SHTROFST
          LDA     #L(ELFB)
          STA     SHTROFST+1
          JSR     SHTRCLRS

          LDA     GAMETYPE
          CMP     #2
          BCC     SNGLSHIT               ;GAMES 0 OR 1 -- NOT DUAL PLAY
          BEQ     CHKFLAGS

          LDX     #1                     ;TEAM PLAY
          LDA     SHTRSTAT+1
          BMI     SHTEMUP
          LDX     #0
SHTEMUP   STX     PLAYER

CHKFLAGS  LDA     FLAGS                  ;IS EITHER PLAYER DEAD?
          BPL     DUALSHIT               ;NO

SNGLSHIT  LDX     PLAYER
          LDA     #$80
          STA     SHTRSTAT,X
          STA     SHOTSTAT,X
          TXA
          EOR     #$01
          TAX
          LDA     #$40
          STA     SHTRSTAT,X
          LDA     #$00
          STA     SHOTSTAT,X
          RTS

DUALSHIT  LDA     #$80
          STA     SHTRSTAT
          STA     SHTRSTAT+1
          STA     SHOTSTAT
          STA     SHOTSTAT+1

          LDA     #CNTRCLMN-8
          STA     SHOOTERX
          LDA     #CNTRCLMN-8+2
          STA     SHOTX
          LDA     #CNTRCLMN+8
          STA     SHOOTERX+1
          LDA     #CNTRCLMN+8+2
          STA     SHOTX+1
          RTS


SHTRCLRS  LDA     #$18                   ;SHOOTER1
          STA     P0C1
          STA     P0C2
          LDA     #$6E
          STA     P0C3

          LDA     #$97                   ;SHOOTER2
          STA     P1C1
          STA     P1C2
          LDA     #$0F
          STA     P1C3
          RTS

******************************************
SHOWPLR1  LDY     #8                     ;PUT UP "PLAYER 1 " OR "PLAYER 2 "
ZDSPPLR1  LDA     MUSHMAP+13*ZONELEN+11,Y        ;MESSAGE AT THE START OF A
          STA     MSGSTORE+9,Y           ;PLAYER'S TURN, AND GET RID OF IT
          LDA     MPLAYER,Y              ;WITH OTHERPLR CODE ABOVE
          STA     MUSHMAP+13*ZONELEN+11,Y
          DEY
          BPL     ZDSPPLR1
          RTS

******************************************
* REMOVE A MAN FROM EXTRA MAN POOL
******************************************
TAKEMAN   LDX     PLAYER
          LDA     MENLEFT,X
          AND     #$07
          CPX     #0
          BEQ     SUBLIFE1

SUBLIFE2  EOR     #$FF
          CLC
          ADC     #21
SUBLIFE1  LDY     GAMETYPE
          CPY     #3
          BNE     SUB1
SUBTEAM   CLC
          ADC     #TEAMMEN-6
SUB1      TAY
          LDA     #L(EMPTY)
          STA     MUSHMAP+6-1,Y
          RTS

******************************************
* COMPARE THE TWO PLAYER'S SCORES
******************************************
CMPSCORE  TXA                            ;RETURNS CARRY SET IF PLAYER X'S SCORE
          EOR     #$01                   ;   GREATER THAN OR EQUAL TO OTHER
          TAY                            ;   PLAYER'S
          LDA     SCORE0,X
          CMP     SCORE0,Y
          LDA     SCORE1,X
          SBC     SCORE1,Y
          LDA     SCORE2,X
          SBC     SCORE2,Y
          LDA     SCORE3,X
          SBC     SCORE3,Y
          RTS


******************************************
* CHECK HIGH SCORE, PUT INTO TOP ROW OF SCREEN
******************************************
;FIRST CHECK FOR THE PRESENSE OF HIGH SCORE CART
CHKHSCR

          LDY     DIFLEVEL               ;HIGH SCORE IN DIFFERENT GAME VERSIONS?
          LDX     GAMETYPE               ;CHECK SCORES OF BOTH PLAYERS
          BEQ     HSCORELP
          LDX     #1

HSCORELP  LDA     HSCORE0,Y
          CMP     SCORE0,X
          LDA     HSCORE1,Y
          SBC     SCORE1,X
          LDA     HSCORE2,Y
          SBC     SCORE2,X
          BCS     HSCNXTPL

          LDA     SCORE0,X
          STA     HSCORE0,Y
          LDA     SCORE1,X
          STA     HSCORE1,Y
          LDA     SCORE2,X
          STA     HSCORE2,Y

HSCNXTPL  DEX
          BPL     HSCORELP
          RTS



************************************************
* SWAP THE MUSHROOM MAPS FOR TWO PLAYER GAME
************************************************

SWAP      LDX     #1                     ;IGNORE ROW 0 (SCORE ROW)

          LDA     #L(MUSHMAP+ZONELEN)    ;INITIAL ROW, MUSHMAP
          STA     GTEMP1
          LDA     #H(MUSHMAP+ZONELEN)
          STA     GTEMP2

          LDA     #L(MAP2)               ;INITIAL ROW, MAP2
          STA     GTEMP3
          LDA     #H(MAP2)
          STA     GTEMP4

SWTCHLP1  LDY     #ZONELEN-1             ;LOOP THROUGH ROW
SWTCHLP2  LDA     (GTEMP1),Y             ;READ OUT OF MUSHMAP, INTO A TEMP.
          STA     GTEMP5
          LDA     (GTEMP3),Y             ;READ OUT OF MAP2, INTO MUSHMAP
          STA     (GTEMP1),Y
          LDA     GTEMP5                 ;READ OUT OF TEMP., INTO MAP2
          STA     (GTEMP3),Y
          DEY
          BPL     SWTCHLP2

          INX                            ;NEXT ROW
          CPX     #NZONES-1              ;THERE IS NO MAP FOR LAST ROW
          BEQ     SWTCHOUT

          LDA     GTEMP1
          CLC
          ADC     #ZONELEN
          STA     GTEMP1
          BCC     NROWMAP2
          INC     GTEMP2

NROWMAP2  LDA     GTEMP3
          CLC
          ADC     #ZONELEN
          STA     GTEMP3
          BCC     SWTCHLP1
          INC     GTEMP4
          BNE     SWTCHLP1

SWTCHOUT  RTS



******************************************
* COLLISION DETECTION ROUTINE FOR SHOOTER
*    CALLED BY THE INDIVIDUAL OBJECT MOVEMENT ROUTINES
*    X = OBJECT NUMBER
******************************************
SHTRCOLL  BIT     ATTRACT
          BMI     SWTCHOUT
          LDA     GAMETYPE
          CMP     #2
          BCC     ZSHTRCOL

          LDA     #0
          STA     PLAYER
          LDA     SHTRSTAT+1
          AND     #$D0
          CMP     #$80
          BNE     ZSHTRCOL
          LDA     SHTRSTAT
          AND     #$D0
          CMP     #$80
          BNE     SHTRCOL2

          JSR     ZSHTRCOL
SHTRCOL2  INC     PLAYER

ZSHTRCOL  LDY     PLAYER
          LDA     OBJX,X
          SEC
          SBC     SHOOTERX,Y

          CPX     #SPDROBJ
          CLC
          BNE     NOTSPCLL

          ADC     #SPDRWDTH-1            ;DO IF X=12
          CMP     #SPDRWDTH+5-2
          BCC     HITSHTRX
          RTS

NOTSPCLL  BPL     FLEAPLXX               ;BRANCH IF X=13
          ADC     #SEGWDTH-1
          CMP     #SEGWDTH+5-2
          BCS     SHCLRTS
          BCC     HITSHTRX

* COLLISION RANGE FOR FLEA:   -2 <= (OBJX-SHTRX) <= 3
*    SO ADD 2 AND COMPARE:     0 <= (OBJX-SHTRX) <= 5
FLEAPLXX  ADC     #2                     ;FLEAWDTH-3
          CMP     #6                     ;
          BCS     SHCLRTS

HITSHTRX
          LDA     OBJY,X
          SEC
          SBC     SHOOTERY,Y
          BPL     NOTNEGC2
          EOR     #$FF
          CLC
          ADC     #$01
NOTNEGC2  CMP     #6
          BCS     SHCLRTS

HITPLAY   LDA     SHTRTIMR
          BEQ     ONEDEAD
          LDA     #$80
ONEDEAD   ORA     #$30
          STA     SHTRTIMR

          LDA     #L(EXPLOS)             ;DIFFERENT EXPLOSION?
          STA     SHTROFST,Y
* START PLAYER DEATH SOUND?
          JSR     SCRAPALL
          LDA     #3
          JSR     TUNIN

          LDA     #0
          STA     SHOTSTAT,Y
SHCLRTS   RTS



******************************************
*** SHOT.S ***
******************************************

* DVP     7/29

SHOOT     BIT     ATTRACT
          BMI     SHCLRTS

          LDA     GAMETYPE
          CMP     #2
          BCC     SHOOTZ

          LDA     #0
          STA     PLAYER
          BIT     SHTRSTAT+1
          BVS     SHOOTZ
          BIT     SHTRSTAT
          BVS     SHOOTHR

          LDA     FRMCNT
          AND     #$01
          STA     PLAYER
          JSR     SHOOTZ
          LDA     PLAYER
SHOOTHR   EOR     #$01
          STA     PLAYER

SHOOTZ    LDA     SHTRTIMR
          BNE     SHOTOUT                ;IF SHOOTER IS DEAD
          LDX     PLAYER
          LDA     SHOTSTAT,X
          LSR     A
          BCS     SHOTCOLL               ;DID SHOT HIT ANYTHING?
          LDA     SHTRSTAT,X             ;IS THE SHOOTER RESING IN?
          AND     #$90
          CMP     #$90
          BNE     RESIN2
          LDA     FRMCNT
          AND     #$0F
          ORA     #$10
          CPX     #1
          BNE     RESIN1
          ORA     #$80
          STA     P1C2
          BNE     RESIN2
RESIN1    STA     P0C2
RESIN2    JMP     CHKSHOT

*CHECK FOR COLLISION OF SHOT AND OBJECT
SHOTCOLL ;LDX     PLAYER
          LDA     SHOTX,X
          STA     GTEMP1

          LDA     SHOTY,X
          CLC                            ;IF THIS IS CHANGED, ALSO CHANGE WHERE
          ADC     #2                     ;   MUSHCNT IS DECREMENTED BELOW
          JSR     OBSTAC                 ;CHECK FOR MUSHROOM
          CMP     #L(EMPTY+1)
          BCC     NOMSHHIT
          CMP     #L(POISONED+1)
          BCS     NOMSHHIT
;;;;;     CMP     #L(FLOWER)             ;FLOWER STOPS THE SHOT
;;;;;     BEQ     ENDSHOT

          TAX                            ;GET VALUE FOR MUSHROOM AFTER HIT
          LDA     MUSHHIT-$41,X
          STA     (GTEMP3),Y
          CMP     #L(EMPTY)
          BNE     ENDSHOT

          LDA     #1                     ;KILLED A MUSHROOM--ADD 1 TO SCORE
;         LDY     #0
          LDX     PLAYER
          JSR     ADDSCORE

          LDX     PLAYER                 ;X WAS TRASHED BY ADDSCORE, MAYBE
          LDA     SHOTY,X                ;DECREMENT MUSHROOM COUNT, IF NECESSARY
          CLC
          ADC     #2
          LSR     A
          LSR     A
          LSR     A
          CMP     #INFLDZN-1
          BCC     ENDSHOT

          LDA     GAMETYPE
          CMP     #1
          BEQ     ZDECMSH
          LDX     #0                     ;USE ONLY MUSHCNT, NOT MUSHCNT+1, IN
ZDECMSH   DEC     MUSHCNT,X              ;   DUAL PLAYER GAMES

ENDSHOT   LDX     PLAYER
          LDA     #$80
          STA     SHOTSTAT,X
          LDA     SHOOTERX,X
          CLC
          ADC     #2
          STA     SHOTX,X
          LDA     SHOOTERY,X
          SEC
          SBC     #1
          STA     SHOTY,X
;;;;;     LDA     #L(ELFWSHOT)
;;;;;     STA     SHTROFST,X
SHOTOUT   RTS

;USHHIT   DB      L(EMPTY),L(QDYING),L(HDYING)
;         DB      L(EMPTY),L(QLIVE),L(HLIVE),L(TLIVE)
;         DB      L(HGROWN),L(QGROWN),L(EMPTY),L(FLOWER)
;         DB      L(EMPTY),L(QPOIS),L(HPOIS),L(TPOIS)

MUSHHIT   DB      L(ZERO),L(ZERO),L(ELF320)
          DB      L(EMPTY),L(QLIVE),L(HLIVE),L(TLIVE)
          DB      L(ZERO),L(ZERO),L(ZERO),L(ZERO)
          DB      L(EMPTY),L(QPOIS),L(HPOIS),L(TPOIS)

NOMSHHIT
          LDA     PLAYER
          CLC
          EOR     #$01
          ADC     #14
          TAX
SHOTOBJC  LDA     OBJSTAT,X
          BPL     NXTOB                  ;NEXTOBJC
          LDA     OBJOFFST,X
          CMP     #L(POINT300)
          BCS     NXTOB

          LDY     PLAYER
          LDA     SHOTY,Y                ;SHOTY-OBJY
          SEC
          SBC     OBJY,X
          BPL     POSDIFF
          EOR     #$FF
          CLC
          ADC     #1

POSDIFF   CMP     #8
          BCS     NXTOB

          LDA     SHOOTERY,Y             ;CHECK TO MAKE SURE OBJECT IS ABOVE
          SEC                            ;SHOOTER
          SBC     OBJY,X                 ;SHOOTERY-OBJY
          SBC     #6
          CMP     #200
          BCS     NXTOB

          LDA     SHOTX,Y
          SEC
          SBC     OBJX,X
          CPX     #13
          BEQ     FLSCSHOT
          BCS     JMPPLRHT
          CPX     #12
          BCS     NOTSEGSH
          JMP     SEGSHOT
NOTSEGSH  CMP     #SPDRWDTH
          BCC     SPDRPNTS
NXTOB     JMP     NEXTOBJC
JMPPLRHT  CMP     #FLEAWDTH
          BCS     NXTOB
          LDA     GAMETYPE
          CMP     #2
          BNE     NXTOB
          TXA                            ;GET PLAYER NUMBER OF PLAYER WHO DIED
          SEC
          SBC     #14
          TAY
          JMP     HITPLAY

SPDRPNTS  LDX     PLAYER
          LDY     #0
          LDA     SHOOTERY,X
          SEC
          SBC     SPDRY
          CMP     #40
          BCS     SPDREXPL
          LDY     #2
          CMP     #16
          BCC     SPDREXPL
          LDY     #1
SPDREXPL  LDA     POINTSPR,Y
          STA     SPDROFST

* CHANGE PALETTE FOR SPIDER POINTS TO THAT OF PLAYER WHO SHOT IT
          LDA     OBJPALWD+12
          AND     #$1F
          LDX     PLAYER
          BEQ     PNTSCLR
          ORA     #$20
PNTSCLR   STA     OBJPALWD+12

          LDA     FRMCNT
          AND     #$18
          EOR     #$80
          STA     SPDRSTAT
          LDA     #$10
          STA     SPDRTIMR
          LDA     #MINX
          CMP     SPDRX
          BCS     PNTSON
          LDA     #MAXX-SPDRWDTH-3
          CMP     SPDRX
          BCS     GOSPOUT
PNTSON    STA     SPDRX
GOSPOUT   LDA     MULT3SP,Y
          TAY
          LDA     #1
          JSR     SCRAPONE
          JMP     SKER                   ;USED TO BE SHOTSCR

FLSCSHOT  TAY
          LDA     FLEASTAT
          AND     #$40
          BEQ     SCRPSHOT
FLEASHOT  CPY     #FLEAWDTH
          BCC     HITFLEA
NXOB      JMP     NEXTOBJC
HITFLEA   LDY     #2
          LDA     DIFLEVEL
          CMP     #2
          BCC     ICPTYOG                ;ONLY ONE SHOT KILLS FLEA IN EASY
          LDA     FLEASTAT
          ORA     #$03
          CMP     FLEASTAT
          BEQ     ICPTYOG
          STA     FLEASTAT
          JMP     ENDSHOT
ICPTYOG   LDA     #4
          JMP     SHOTSCR

SCRPSHOT  CPY     #SCRPWDTH
          BCS     NXOB
          INC     FLEAX                  ;ADJUST EXPLOSION POSITION
          LDY     #10
          LDA     #5                     ;TURN OFF SCORPION SOUND
JMPSHTSC  JMP     SHOTSCR

SEGSHOT   CMP     #SEGWDTH
          BCS     NEXTOBJC
          LDA     OBJY,X
          CMP     #2
          BCC     NEXTOBJC

* WE HAVE HIT A SEGMENT
* MIDDLE OF A CHAIN? -- IF SO, MAKE NEXT SEG. NEW HEAD
          CPX     #11
          BEQ     KILLSEGM
          LDA     OBJOFFST+1,X
          CMP     #L(EXPLOS)
          BCS     KILLSEGM
          LDA     OBJSTAT+1,X
          AND     #$A0
          CMP     #$80
          BNE     KILLSEGM
          LDA     OBJSTAT+1,X
          ORA     #$20
          STA     OBJSTAT+1,X
          LDA     OBJOFFST+1,X
          EOR     #$30
          STA     OBJOFFST+1,X

* PUT MUSHROOM UP, KILL SEGM
KILLSEGM  LDA     OBJOFFST,X
          AND     #$04
          EOR     #$04
          BNE     SKIPFC
          LDA     #$FE
SKIPFC    ORA     #$02                   ;X-2 OR X+6
          CLC
          ADC     OBJX,X                 ;PUT UP A MUSHROOM IN SEGMENT'S PLACE
          CMP     #MINX
          BCS     SEGML
          LDA     #MINX
SEGML     CMP     #MAXX
          BCC     SEGMR
          LDA     #MAXX-1
SEGMR     STA     GTEMP1
          LDA     OBJY,X
          JSR     COBSTAC
          BNE     KILLIT
          TXA
          PHA
          LDA     OBJY,X
          JSR     CMUSHER
          PLA
          TAX

KILLIT    LDA     #L(EXPLOS)
          STA     OBJOFFST,X
          DEC     NUMSEG                 ;ONE LESS SEG. ON SCREEN
          LDA     #2
          JSR     TUNIN

* SCORE A CENTIPEDE SEGMENT
SEGSCORE  LDY     #$00                   ;ADDING SCORE FOR CENTIPEDE SEGMENT
          LDA     OBJSTAT,X              ;IF BODY SEGMENT -- ADD 10 POINTS
          AND     #$20
          LSR     A
          EOR     #$10
          BNE     BODYSCR
          INY                            ;HEAD -- ADD 100 POINTS
BODYSCR   LDX     PLAYER
          JSR     ADDSCORE
          JMP     ENDSHOT

NEXTOBJC  DEX
          BMI     SHOTUP
          CPX     #13
          BCC     JUMPSHOT
          LDX     #13
JUMPSHOT  JMP     SHOTOBJC

SHOTSCR
* EXPLOSION PICTURE, SOUND
          JSR     SCRAPONE
          LDA     #L(EXPLOS)
          STA     OBJOFFST,X
SKER
          LDA     #2
          JSR     TUNIN
          LDX     PLAYER
          LDA     #0
          JSR     ADDSCORE
JENDS     JMP     ENDSHOT                ;JENDS CALLED FROM SHOTUP BELOW

* CHECK FOR NEW SHOT
CHKSHOT   LDX     PLAYER
          BIT     ATTRACT
          BMI     NOSHOT
          BVS     ATTRSHOT
          LDA     BUTNIB,X             ;CHECK FIRE BUTTON
          BMI     NOSHOT

ATTRSHOT ;LDA     #L(ELF)
;;;;;     STA     SHTROFST,X

          JSR     STOPRES

          LDA     #$81                   ;MARK SHOT AS FIRED -- ALWAYS AT RIGHT
          STA     SHOTSTAT,X             ;   POSITION

          LDA     #0                     ;START A NEW SHOT
          JSR     SCRAPONE
          LDA     #0
          JMP     TUNIN

SHOTUP    LDX     PLAYER
          LDA     SHOTY,X
          CMP     #8                     ;AT TOP?
          BCC     JENDS
          SBC     #8                     ;SHOT NOT AT TOP -- MOVE UP
          STA     SHOTY,X
NOSHOT    RTS


STOPRES   LDA     SHTRSTAT,X             ;TAKE OUT OF RES MODE
          AND     #$EF
          STA     SHTRSTAT,X
          JMP     SHTRCLRS

******************************************
* ADVANCE ALL OBJECT EXPLOSION ANIMATIONS
******************************************
EXPLODE   LDA     FRMCNT
          AND     #1
          BNE     NOSHOT

          LDX     #15
EXPLLP    LDY     OBJOFFST,X
          CPY     #L(POINT300)
          BCC     EXPLNEXT               ;EXPLOSION STAMP PUNT, TRY NEXT
          CPX     #12
          BCC     NRMLEXPL               ;CENTIPEDE EXPLOSION
          BEQ     SPIDEY                 ;SPIDER  EXPLOSION
          CPX     #13
          BEQ     NRMLEXPL               ;FLEA EXPLOSION
;ELSE SHOOTER EXPLOSION

          BIT     FLAGS                  ;IF MUSHROOM RESTORATION, USE NORMAL
          BVS     NRMLEXPL               ;   EXPLOSION
          LDA     FRMCNT                 ;SHOOTER EXPLOSION IS SLOWED DOWN
          AND     #$07
          BNE     EXPLNEXT

          CPY     #L(EXPLOS+4)
          BNE     ZNRMLEXP
          LDA     FLAGS                  ;SHOOTER EXPLOSION DONE, TURN ON
          ORA     #$40                   ;   MUSHROOM RESTORATION
          STA     FLAGS
          LDA     #0                     ;ROW, COLUMN OF FIRST MUSHROOM
          STA     GTEMP5
          STA     GTEMP6
          BEQ     NOTHING                ;ALWAYS

***********
NRMLEXPL  CPY     #L(EXPLOS+4)
          BEQ     NOTHING
ZNRMLEXP  INC     OBJOFFST,X
          INC     OBJOFFST,X
          BNE     EXPLNEXT               ;ALWAYS

***********
SPIDEY    DEC     SPDRTIMR               ;LEAVE SPIDER POINTS UP FOR A WHILE
          BNE     EXPLNEXT
          LDY     DIFLEVEL               ;SET TIMER FOR REAPPEARANCE
          LDA     SPDRWTDF,Y
          STA     SPDRTIMR

***********
NOTHING   LDA     #0
          STA     OBJOFFST,X
          STA     OBJSTAT,X
EXPLNEXT  DEX
          BPL     EXPLLP
          RTS



;HSCSETUP FIRST DETERMINES IF THERE IS A HSC PLUGGED IN IF IT IS A ZERO IS
;RETUNED AND THE ARGUMENT BLOCK IS SETUP. IF THE CART IS NOT PRESENT, THE ZERO
;FLAG IS RESET. DURATION IS SET TO ZERO FOR HSCENTER. ANY OTHER VALUE MUST BE
;STORED AFTER CALLING HSCSETUP. ACTUAL SCORES MUST BE MOVED INTO THE SCORE BLOCK
;OUTSIDE THIS ROUTINE.
;FIRST CHECK FOR THE PRESENSE OF HIGH SCORE CART

HSCSETUP
          LDA     $3900                  ;HSC THERE?
          CMP     #$C6
          BNE     NOHSC
          LDA     $3904
          CMP     #$FE
          BNE     NOHSC

          TXA
          PHA

          LDA     #$80
          STA     ATTRACT

          LDX     #14                    ;LOAD FIXED HSC ARGS INTO DATA BLOCK
HSLOADLP  LDA     HSCARGS,X              ;this argument loading must come first
          STA     HSDATA,X               ;in setup, since some args are
          DEX                            ;variable and get reloaded
          BPL     HSLOADLP

          LDA     #$7F
          STA     CTRL

          LDA     #0
          LDX     #5
HSCOBJCL  STA     OBJSTAT+12,X
          DEX
          BPL     HSCOBJCL

          LDA     #5                     ;SO THAT COLOR LOADING ROUTINE ONLY
          STA     HSCFLAG                ;   DOES PAL.S 5,6
          JSR     LOGOINIT               ;LOGO BOTTOM
          LDA     #1
          STA     COLORFLG

          LDA     #L(HSTOPDLI)
          STA     VECTORI
          LDA     #H(HSTOPDLI)
          STA     VECTORI+1

          LDX     GAMETYPE               ;NO GAME TYPE DISPLAY IF IN A SINGLE
          LDA     HSGMTYP,X              ;   PLAYER AT A TIME GAME
          BNE     NOTYPDSP
;;;;;     LDA     #0
          STA     DL16+1

NOTYPDSP  LDA     DIFLEVEL
          ASL     A
          ASL     A
          ORA     HSGMTYP,X
          ASL     A
          ASL     A
          STA     GTEMP3

          PLA
          TAX
          ORA     GTEMP3
          STA     HSDATA+2               ;DIFFY PLAYNUM

          LDA     #0                     ;MAKE EQUAL ON RETURN
                                         ;MUST RETURN WITH INITIAL X RESTORED
NOHSC     RTS                            ;   AND ZERO FLAG SET



HSCNTR1   ;ENTER THE INITIALS FOR PLAYER1
          JSR     HSCSETUP
          BNE     RHS1

          TXA
          PHA
          JSR     MAKCENTI               ;CENTIPEDE FOR HSC LOGO
          PLA
          TAX

          LDA     GAMETYPE
          BEQ     DOSCREG                ;ONE PLAYER GAME
          CMP     #3
          BEQ     TMSCREG                ;TEAM
          CPX     #0
          BNE     DOSCREG
          STX     HSDATA+$E              ;NO WAIT AFTER FIRST PLAYER IN TWO PLR
          BEQ     DOSCREG
TMSCREG   LDX     #2                     ;USE TEAM SCORE IN TEAM PLAY GAME
DOSCREG   LDA     SCORE3,X
          STA     SCOREBLK
          LDA     SCORE2,X               ;INITIALIZE SCORE INFO TO BE PASSED
          STA     SCOREBLK+1
          LDA     SCORE1,X
          STA     SCOREBLK+2
          LDA     SCORE0,X
          STA     SCOREBLK+3

          LDY     #H(HSDATA)
          JSR     $3FFD                  ;HSCENTER


HSCREC    LDX     #$7F                   ;RECOVER FROM HSC
          STX     CTRL
          LDA     #H(DLL)
          STA     DPH
          LDA     #L(DLL)
          STA     DPL
          LDA     #H(STMPBASE)
          STA     CHARBASE
          LDA     #L(MORPHO)
          STA     VECTORI
          LDA     #H(MORPHO)
          STA     VECTORI+1
          JSR     TURNON                 WAIT FOR TOP OF SCREEN AND TURN DMA ON
          LDX     #0
          STX     HSCFLAG
          INX
          STX     COLORFLG
RHS1      RTS




HSATRACT  LDA     #11                    ;LOOP FOR ALL GAME LEVELS
          STA     HSATRGM
          JSR     MAKCENTI

          LDA     GAMETYPE
          PHA
          LDA     DIFLEVEL
          PHA

HSATRLP   LDX     HSATRGM
          LDA     GAMETBL,X
          LSR     A
          LSR     A
          AND     #$03
          TAY
          BEQ     ZXABD
          INY
ZXABD     STY     GAMETYPE               ;GAMETYPE
          LDA     GAMETBL,X
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          STA     DIFLEVEL               ;DIFLEVEL

          LDX     #0
          JSR     HSCSETUP
          BNE     ATRREC

          LDA     #0
          STA     HSDATA+$E

          LDY     #H(HSDATA)
          JSR     $3FF7                  ;HSCSTAT

          LDX     HSDATA+4
          CPX     #5
          BCC     ZNHSOK
          LDX     #5
ZNHSOK    LDA     HSTIME,X
          STA     HSDATA+$E               ;DURATION OF HSC

          LDA     #L(STICKIT)
          STA     HSDATA+4
          LDA     #H(STICKIT)
          STA     HSDATA+5

          LDY     #H(HSDATA)
          JSR     $3FFA                  ;HSCATRCT

          LDA     PANEL
          LSR     A
          BCC     ATRLEAVE               ;RESET SWITCH PRESSED
          LSR     A
          BCC     ATRREC                 ;SELECT SWITCH PRESSED

          LDA     BUTNIB
          BPL     ATRLEAVE

          JSR     STICKIT0
;;        LDA     SCHTICK
          AND     #$F0
          CMP     #$F0
          BNE     ATRREC

          DEC     HSATRGM
          BPL     HSATRLP

ATRREC    PLA
          STA     DIFLEVEL
          PLA
          STA     GAMETYPE
          JMP     HSCREC

ATRLEAVE  LDA     #$60
          STA     DL16+1
          PLA
          STA     DIFLEVEL
          PLA
          STA     GAMETYPE
          JSR     HSCREC
          LDA     #$FF                   ;MAKE FLAG NEG
NOSOUND   RTS


GAMETBL   DB      $38,$28,$18,$08,$34,$24,$14,$04,$30,$20,$10,$00

HSTIME    DB      0,9,6,5,4,3

HSCARGS   DB      1,1,0,2,L(STICKIT),H(STICKIT),0,0,L(SCOREBLK),H(SCOREBLK)
          DB      L(HSCDLL),H(HSCDLL),L(NOSOUND),H(NOSOUND),9

HSGMTYP   DB      0,0,1,2


HSTOPDLI
          TXA
          PHA
          TYA
          PHA
          CLD
          LDA     #$40
          STA     CTRL
          LDA     #H(STMPBASE+$100)
          STA     CHARBASE
          LDA     #$80                   ;GROUND CAPS
          STA     VBLANK
          LDA     #L(HSBTMDLI)
          LDY     #H(HSBTMDLI)
ENDHSDLI  STA     VECTORI
          STY     VECTORI+1
          PLA
          TAY
          PLA
          TAX
          PLA
          RTI

HSBTMDLI
          TXA
          PHA
          TYA
          PHA
          CLD
          LDA     #0
          STA     VBLANK                 ;UNGROUND CAPS
          STA     WSYNC
          STA     WSYNC
          LDA     #$39
          STA     CHARBASE
          LDA     #$4B
          STA     CTRL
          INC     FRMCNT
          JSR     LOADIT
          JSR     MOVCENTI
          JSR     TRACKIT

          LDA     NUMSEG
          BNE     HSLMST
          LDA     #12
          CLC
          ADC     CLRINDEX
          CMP     #TOPCOLOR
          BNE     HSNOCLR
          LDA     #0
HSNOCLR   STA     CLRINDEX
          LDA     #1
          STA     COLORFLG
          JSR     MAKCENTI

HSLMST    JSR     LMST                   STUPID NAME FOR COLOR LOAD ROUTINE
          LDA     #L(HSTOPDLI)
          LDY     #H(HSTOPDLI)
          JMP     ENDHSDLI


STICKIT
          CPX     #0
          BEQ     ZSTICK                 ;IF PLAYER 0 GO AHEAD
          LDX     #1                     ;ENSURE THAT IT'S PLAYER 1
          LDA     ALTCTRLS               ;SHARE TRACKBALL?
          BEQ     ZSTICK                 ;   NO
                                         ;YES
STICKIT0  LDX     #0
ZSTICK    LDY     BUTNIB,X
          LDA     TRACKF,X
          BNE     DOMOVM                 ;DO TRACKBALL
          CPX     #1
          BNE     STIKI
          LDA     ALTCTRLS
          CMP     #$1
          BNE     STIKI                  ;THE PLAYER WANTS TO SHARE TRACKBALL
          LDX     #0                     ;coerce track0 for two play alt
DOMOVM    LDA     FRMCNT
          AND     #$7
          BNE     ROTSI
          LDA     DELTAX,X
          BNE     CALCIT
          LDA     DELTAY,X
          BNE     CALCIT
          LDA     #$FF
          BMI     DITTY                  ;NO MOVEMENT
CALCIT    LDA     DELTAX,X
          BPL     POSIT
          EOR     #$FF

          CLC
          ADC     #1
POSIT     STA     TTEMP1
          LDA     DELTAY,X
          BPL     YSOT
          EOR     #$FF
          CLC
          ADC     #1
YSOT      STA     TTEMP2
          CMP     TTEMP1
          BCC     EW
NS        LDA     DELTAY,X               ;SET FLAGS
          BPL     SOU
          LDA     #$EF
DITTY     STA     SCHTICK
          RTS
SOU
          LDA     #$DF                   ;SOUTH JOYSTICK VALUE
          STA     SCHTICK
          RTS
EW        LDA     DELTAX,X
          BPL     EAS
          LDA     #$BF
          STA     SCHTICK
          RTS
EAS       LDA     #$7F
          STA     SCHTICK
          RTS
STIKI     LDA     #0
          STA     CTLSWA
          LDA     SWCHA                  ;joystick
          CPX     #0
          BEQ     ZSTIKI
          ASL     A
          ASL     A
          ASL     A
          ASL     A
ZSTIKI    STA     SCHTICK
          RTS
ROTSI     LDA     SCHTICK
          RTS
