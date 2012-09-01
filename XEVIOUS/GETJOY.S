; GETJOY
; THIS ROUTINE IS THE MAIN GAME LOOP, JUMPED TO FROM "MAIN" RIGHT
;         AFTER ALL THE POWERUP INITIALIZATION IS DONE.  IT
;         TESTS THE "MODE" VARIABLE AND DECIDES WHICH MINOR GOD OR
;         GODDESS ROUTINE TO JUMP TO ACCORDINGLY.  ALL OF THESE ROUTINES
;         RETURN TO GOD (ENDCYCLE)
; This file also contains the routines which handle the modes BLANK and
;         PAUSE.

          ZEROPAGE
          MARIAREG
          TRUEFALS
          GODGLBL                        god and the states
          PUBLIC  WVBLANK,WMARIA
          BUTTGLBL
          DLIGLBL                        extrn
          DLLGLBL
          PLAYGLBL
          EXTRN   RANDOM

******************* CONSTANTS
* state ("GOD") constants
MGAME     EQU     $00
MTITLE    EQU     $01
MAUTO     EQU     $02
MHISCORE  EQU     $03
MENDGAME  EQU     $04
MENTER    EQU     $05
MPAUSE    EQU     $06
MBLANK    EQU     $08
MTEXT     EQU     $09
MSELECT   EQU     $0A

* Joy direction constants
CTR       EQU     0
N         EQU     1
NE        EQU     2
E         EQU     3
SE        EQU     4
S         EQU     5
SW        EQU     6
W         EQU     7
NW        EQU     8

*****************************************
RAM1      CSECT                          ;RAM2?
; added by Keith for controllers


ONEBUT    DS      1                      flag: bits to set in SWCHB for 2button
HJOYDIR
NEWDIR    DS      1
OLDDIR    DS      1
HBUTTON   DS      1                      shot .OR. bomb
OLDBUTT   DS      1                      last state of oldbutt
SBUTTON   DS      1                      shot button   (debounced in movement)
BBUTTON   DS      1                      bomb button          "       "

SELREADY  DS      1
RESREADY  DS      1
PSREADY   DS      1

FPSELECT  DS      1
FPRESET   DS      1
FPPAUSE   DS      1

SYSCOUNT  DS      2                      system counter for timing modes

********************************************************************************
*  PIA AND TIMER (6532) LOCATIONS   0280 TO 02FF
* NOTE THESE REGISTERS ARE SHADOWED AT 0380 TO 03FF
********************************************************************************

SWCHA     EQU     $280                   ;PO, P1 JOYSTICKS

*         BIT 7 PLAYER 0 EAST IF CLEAR
*         BIT 6          WEST
*         BIT 5          SOUTH
*         BIT 4          NORTH
*         BIT 3 PLAYER 1 EAST IF CLEAR
*         BIT 2          WEST
*         BIT 1          SOUTH
*         BIT 0          NORTH

SWCHB     EQU     $282                   ;CONSOLE SWITCHES

*         BIT 7   PLAYER 1 DIFFICULTY A IF SET B IF CLEAR
*         BIT 6   PLAYER 0 DIFFICULTY A IF SET B IF CLEAR
*         BIT 3   BLACK + WHITE/COLOR  COLOR WHEN SET
*         BIT 1   GAME SELECT  CLEAR WHEN PRESSED
*         BIT 0   GAME RESET   CLEAR WHEN PRESSED

CTLSWA    EQU     $281
CTLSWB    EQU     $283
INPT4B    EQU     $08                    ;PLAYER 1 RIGHT BUTTON MINUS WHEN HIT
INPT4A    EQU     $09                    ;PLAYER 1 LEFT BUTTON MINUS WHEN HIT
INPT5B    EQU     $0A
INPT5A    EQU     $0B
INPT4     EQU     $0C
INPT5     EQU     $0D



*****************************************
CODE9000  CSECT
*******************
WVBLANK
*******************
* waits for CTRLRD/STATUS BIT7 to indicate you're in VBLANK
          BIT     CTRLRD
          BPL     WVBLANK
          RTS

*******************
WMARIA
*******************
* waits for CTRLRD/STATUS BIT7 to indicate you're in MARIA
          BIT     CTRLRD
          BMI     WMARIA
          RTS

*******************
SETSYSCO
*******************
          LDA     SYSLOW,X
          STA     SYSCOUNT
          LDA     SYSHIGH,X
          STA     SYSCOUNT+1
          RTS
SECOND    EQU     60                     framerate
MINUTE    EQU     60*SECOND
SEC4      EQU     0
SEC20     EQU     1
MIN18     EQU     2
SYSLOW    DB      L(4*SECOND),L(20*SECOND),L(18*MINUTE) ;20 too big for NTSC
SYSHIGH   DB      H(4*SECOND),H(20*SECOND),H(18*MINUTE)

*******************
DECSYSCO
*******************
          LDA     SYSCOUNT
          SEC
          SBC     #1
          STA     SYSCOUNT
          LDA     SYSCOUNT+1
          SBC     #0
          STA     SYSCOUNT+1
          ORA     SYSCOUNT               ;both should be zero
          RTS

**********
FAKENPUT                                 ;for autoplay (could be put inline)
**********
          LDA     SOLVSTAT
          BNE     CNTRIT                 ;DON'T CHANGE SOLVALOU'S DIRECTION
          LDA     FRMCNT                 ;WHEN IT'S DYING
          LSR     A                      ;forget even/odd
          AND     #$07
          BNE     USEOLDJY
* Do fake fire
          JSR     RANDOM
          AND     #$03
          BEQ     SAMEBUTT
          LDA     #TRUE
          STA     SBUTTON
SAMEBUTT
          JSR     RANDOM
          AND     #$07
          BEQ     BOMSAWAY
          LDA     #FALSE
          STA     BBUTTON
          LDA     SIGHTCOL
          CMP     #REDSIGHT
          BNE     NOTARGET               ;JMP...
BOMSAWAY  LDA     #TRUE
          STA     BBUTTON
NOTARGET  INC     OLDDIR
          LDA     OLDDIR
          CMP     #30
          BNE     USEOLDJY
          LDA     #0
          STA     OLDDIR
USEOLDJY  LDX     OLDDIR
          LDA     FAKEDIR,X
          STA     NEWDIR
          RTS
CNTRIT    LDA     #$00
          STA     NEWDIR
          RTS

FAKEDIR
          DB      N,N,NE,NE,E
          DB      E,SE,SE,CTR,SW
          DB      SW,W,W,NW,NW
          DB      NW,NW,W,W,SW
          DB      SW,CTR,SE,SE,E
          DB      E,NE,NE,N,N

*******************
INIT2BUT
*******************
          MOVE    #$14,CTLSWB            set joy direction reg to select 2-but
          MOVE    #1,DIFCULTY            ;;;powerup difficulty: intermediate
          MOVE    #0,CTLSWA
          STA     $0001                  stop discharging the caps
          STA     SWCHB                  select 2-button mode
          STA     ONEBUT                 clear "1-button" flag
          RTS                            see below

**************************
;         All the polling is here now.
;         Also, code dispatching is handled via an indirect jump
;         through GODPTR.  All routines which set MODE must
;         now set GODPTR as well.

GOD       LDA     FRMCNT
          CMP     OLDFCNT
          BEQ     GOD
          STA     OLDFCNT
          LDX     #$FF                   ;;;;    Put a trap in here
          TXS                            ;;;;    Put a trap in here
*         LDA     FRMCNT
          LSR     A
          BCC     GOGOD
          JMP     JGOD

; At this point, it's time to go-- do the polling, then do the
;         jmp indirect
;     Note that this jump takes less cycles than the old way, even if
;         the first mode test failed and JMP  GAME was executed.
;         NB: ;; indicates 2-button code
GOGOD                                    ;Blank mode comes here.

*
* JOYSTICK BUTTONS  JOYSTICK BUTTONS  JOYSTICK BUTTONS  JOYSTICK BUTTONS
          LDX     PLAYER                 ;FOR PROGRAMS USING THIS ROUTINE
          LDA     INPT4,X                ;A BEQ WILL BRANCH WHEN A BUTTON HAS
          BPL     HIT1BUTT               ;if BIT7 is low, old-style button hit
          LDY     #FALSE
          LDA     ONEBUT                 ;are we already in 1-button mode?
          AND     RJBITS,X
          BNE     OLDSTYLE               ;Yes. Go directly to 1-button handler.
* TWO BUTTON JOYSTICK
*
          TXA                            ;otherwise, compute index into paddle
          ASL     A                      ;ports for player X in y (x*2)
          TAY
          LDX     #FALSE
          LDA     INPT4A,Y               ;LEFT
          BPL     LEFTUP
          LDX     #TRUE
LEFTUP    STX     SBUTTON

          LDX     #FALSE
          LDA     INPT4B,Y
          BPL     RIGHTUP
          LDX     #TRUE
RIGHTUP   STX     BBUTTON
* Now check to see if buttons should be equivalent function
          LDX     PLAYER
          LDA     SWCHB
          AND     DIFFSW,X
          BEQ     EITHER1                ; Treat buttons as individuals
          LDA     BBUTTON                ; Treat buttons the same
          ORA     SBUTTON
          STA     SBUTTON
          STA     BBUTTON
          JMP     HBUTTVAL


DIFFSW    DB      $40,$80                ;left and right difficulty switches
RJBITS    DB      $04,$10                ;button bits corresp. to each player


* ONE BUTTON JOYSTICK
*
HIT1BUTT  LDA     RJBITS,X               ;
          ORA     ONEBUT                 ;
          STA     SWCHB                  ;
          STA     ONEBUT                  ;
          LDY     #TRUE
OLDSTYLE
          STY     BBUTTON
          STY     SBUTTON

EITHER1   LDA     BBUTTON
          ORA     SBUTTON
HBUTTVAL  STA     HBUTTON
* JOYSTICK:  independent of 1button/2button issue
          LDA     SWCHA
          LDY     PLAYER
          BNE     READPL2

          LSR     A
          LSR     A
          LSR     A
          LSR     A

READPL2   AND     #$0F

WRTJOY    TAX
          LDA     JOYTAB,X             ; USE UPPER NIBBLE AS TABLE INDEX

          STA     NEWDIR
          LDA     SOLVSTAT
          BEQ     ZSKIP0
          LDA     #$00
          STA     NEWDIR                 ;KILL JOYSTICK CONTROL IF SOLVALOU IS
                                         ;EXPLODING

; Now poll the front panel switches.

; Reset switch first:

ZSKIP0
          LDY     #TRUE

          LDA     SWCHB
          AND     #$01                   ; RESET BIT
          BEQ     GOD0020               ; CLEAR WHEN DOWN
          STY     RESREADY
          INY                            from $ff to 0

GOD0020   STY     FPRESET

; Now the Select switch:

          LDY     #TRUE

          LDA     SWCHB
          AND     #$02                   ; SELECT BIT
          BEQ     GOD0022               ; CLEAR WHEN DOWN
          STY     SELREADY
          INY                            from $ff to 0

GOD0022   STY     FPSELECT

; Now the Pause switch:

          LDY     #TRUE

          LDA     SWCHB
          AND     #$08                   ; PAUSE BIT (B/W)
          BEQ     GOD0024               ; CLEAR WHEN DOWN
          STY     PSREADY
          INY                            from $ff to 0

GOD0024   STY     FPPAUSE

*********
JGOD      JMP     (GODPTR)


; All these routines end with ENDCYCLE which does JMP GOD

*********
* This is DMAOFF state (after pause, you know)
BLANK
          LDA     FPPAUSE                If pause is pressed, restart the game
          BNE     B001

; If any fp switch, or the button, is touched, turn dma back on, but don't
;         restart gameplay.

          LDA     SWCHA
          EOR     #$FF
          BNE     BLANK00                Turn on DMA

          LDA     HBUTTON                buttons of current player
          ORA     FPRESET
          ORA     FPSELECT
          BNE     BLANK00
JMPGOGOD  JMP     GOGOD

; AT THIS POINT, WE KNOW PAUSE HAS BEEN PRESSED AGAIN.  RESTORE DMA AND
;         MAKE THE GAME START AGAIN--

B001      JSR     TURNON

          JMP     BLANK01                ; SETUP FOR DMA TO OCCUR

; I'LL GET HERE IF 1) THE JOYSTICK IS NOT CENTERED
;         2) ANY FRONT PANEL SWITCH IS PRESSED

BLANK00   LDX     #MIN18                 ; IF JOYSTICK IS CENTERED AND PAUSE
          JSR     SETSYSCO               ; WAS NOT PRESSED AGAIN, COME HERE

          LDA     #MPAUSE
          STA     MODE

          NEWSTATE  PAUSE
          MOVE    PLAYER,TEMP4           ;;;;

BLANK01   LDA     #NGAMEDLI              syncing dli
          STA     NUMDLI
          JSR     WMARIA
          JSR     WVBLANK
          MOVE    #$50,CTRLWT
          BNE     JMPGOGOD


*********
* This is PAUSE state
PAUSE     JSR     DECSYSCO
          BNE     PAUSE00

; AT THIS POINT, 18 MINUTES HAVE PASSED. TURN THE VIDEO OFF BY CHANGING THE
;         MODE TO "MBLANK"

          LDA     #$70                    ; TURN OFF DMA
          STA     CTRLWT
          LDA     #MBLANK
          STA     MODE
          MOVE    #0,BACKGRND
          NEWSTATE  BLANK
          JMP     GOGOD
JMPGOD    ENDCYCLE

PAUSE00   LDA     FPSELECT
          BMI     JMPTITLE
          LDA     FPRESET
          BMI     JMPGAME
          LDA     PLAYER                 ;;;;;   ALTERNATE TESTING PLAYERS BUTS
          EOR     #$01                   ;;;;;
          STA     PLAYER                 ;;;;;
          LDA     FPPAUSE
          BEQ     JMPGOD
          LDA     PSREADY
          BEQ     JMPGOD
; IF THE CODE REACHES THIS POINT, THE PAUSE BUTTON HAS BEEN PUSHED.  GO
;         BACK TO GAMEPLAY:

          MOVE    TEMP4,PLAYER           ;;;;;;;;RESTORE PLAYER!!!!!!
          JSR     TURNON                 back to game
          JMP     GOGOD
JMPTITLE  JMP     INITTITL
JMPGAME   JMP     INITGAME
TURNON    LDA     #MGAME
          STA     MODE
          NEWSTATE  GAME
          LDA     #FALSE
          STA     PSREADY
          RTS

* TABLE OF JOYSTICK DIRECTIONS VS BIT READINGS
*       8 1 2
*       7 0 3
*       6 5 4
*
JOYTAB    DB      CTR,CTR,CTR,CTR
          DB      CTR,SE,NE,E
          DB      CTR,SW,NW,W
          DB      CTR,S,N,CTR

BOTGET
          END
