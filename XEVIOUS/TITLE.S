; TITLE
; This file contains the routine INITTITL which initializes and displays
;         the title page, and TITLE, which times the display of the logo
;         as well as polls the buttons for game start
* THIS FILE ALSO CONTAINS THE GAME-OVER STUFF

          MARIAREG
          ZEROPAGE
          COLORS
          PUBLIC  LOGOCOL,TZONE0,TZONE1,TZONE2,TZONE3,TZONE4
          HSCGLBL
          EXTRN   KG,KA,KC,KD,KE,KI,KL,KM,KN,KO,KP,KR,KS,KT,KV,KX,KY,KCOPY
          EXTRN   LISTTABL,LISTTABH
          EXTRN   INITPLDR,CONSINT2
          EXTRN   WVBLANK
          TRUEFALS
          MAPGLBL
          SCROGLBL
          ZONEGLBL
          BUTTGLBL
          HEADGLBL
          LOADGLBL
          DLLGLBL
          PLAYGLBL
          DLIGLBL
          TUNEGLBL
          GODGLBL
          OVERGLBL

LOGOX0    EQU     6                      ;;;
LOGOX1    EQU     15
LOGOX2    EQU     LOGOX1+(4*17)

LOGOHIGH  EQU     $80                    in the $8000 block

LOGOPW1   EQU     $E0+(32-17)
LOGOPW2   EQU     $E0+(32-16)            64 pixels wide
LOGOPWUL  EQU     $E0+(32-4)
LOGOPWHZ  EQU     $E0+(32-3)
LOGOPWVT  EQU     $E0+(32-1)

DMAOFF    EQU     $60
DMAON     EQU     $50
HALFSEC   EQU     30
DLIBIT    EQU     $80
GOINDIR   EQU     $60
******************************************
DLLZONE   MACRO   OFFSET,DP
          DB      &OFFSET,H(&DP),L(&DP)
          ENDM

FIVEBYTE  MACRO   ADDR,MODE,PALWID,HPOS
          DB      L(&ADDR),&MODE,H(&ADDR),&PALWID,&HPOS
          ENDM

FOURBYTE  MACRO   ADDR,PALWID,HPOS
          DB      L(&ADDR),&PALWID,H(&ADDR),&HPOS
          ENDM

******************************************
*(RAM2 CSECT AT END OF FILE)
CODE9000  CSECT


******************
INITOVER  INC     NUMDEAD                ;0->1,1->2
* TURN OFF DMA
          JSR     WVBLANK
          LDA     #DMAOFF
          STA     CTRLWT
          JSR     SCRAPALL
          LDX     #8                     ;put GAME OVER in character map
GOLOOP    LDA     GOROM,X
          STA     TCMAP2PL,X
          DEX
          BPL     GOLOOP
          LDA     #GOINDIR               ;change HPOS in DL
          STA     TCMAPDL2+1
          LDX     #LASTZONE-DLLOVER+2    ;put DLL in
OVERLOOP  LDA     DLLOVER,X
          STA     TDLLTOP,X
          DEX
          BPL     OVERLOOP
          LDA     #$C
          STA     P5C1
          STA     P5C2
          MOVE    #NOVERDLI,NUMDLI
          LDX     #SEC4
          JSR     SETSYSCO               ;time to display GAME OVER
          LDA     NUMPLYRS               ;NUMPLYRS = 0 or 1
          CMP     NUMDEAD                ;NUMDEAD = 1 or 2
          BNE     ALLOVER
* Here for GAME OVER    PLAYER n
          LDX     PLAYER                 ;put number in character map
          LDA     OVERPLAY,X
          STA     PLAYNUMB+7
          LDA     #H(PLAYNUMB)           ;put charmap in DL
          STA     TCMAPDL0+2
          LDA     #L(PLAYNUMB)
          STA     TCMAPDL0
          LDA     #GOINDIR
          STA     TCMAPDL0+1             (HPOS)
          LDA     #H(TCMAPDL0)           ;put DL in DLL
          STA     TDLLTOP+(PLAYERN-DLLOVER+1)
          LDA     #L(TCMAPDL0)
          STA     TDLLTOP+(PLAYERN-DLLOVER+2)
* Here for GAME OVER
ALLOVER   NEWSTATE GAMEOVER
          JSR     WVBLANK
          LDA     #L(TDLLTOP)             dlltop means zone13 is at the top
          STA     DPPL
          LDA     #H(TDLLTOP)
          STA     DPPH
          LDA     #DMAON                 ;RIGHT VALUE?
          STA     CTRLWT
          ENDCYCLE
***********************
DLLOVER
          DLLZONE  DLIBIT+$F,DUMMYDL     ;NULL
          DLLZONE  $8,DUMMYDL           ;NULL
          DLLZONE  $4F,SCORELST
          DLLZONE  DLIBIT+$4F,DUMMYDL
          DLLZONE  $4F,DUMMYDL
          DLLZONE  $4F,DUMMYDL
          DLLZONE  $4F,DUMMYDL
          DLLZONE  $4F,TCMAPDL2          ;GAME OVER
          DLLZONE  $4F,DUMMYDL
PLAYERN   DLLZONE  $4F,DUMMYDL
          DLLZONE  $4F,DUMMYDL
          DLLZONE  $4F,DUMMYDL
          DLLZONE  $4F,DUMMYDL
          DLLZONE  $4F,DUMMYDL
          DLLZONE  $4F,DUMMYDL
          DLLZONE  DLIBIT+$4F,DUMMYDL
LASTZONE  DLLZONE  $4F,DUMMYDL
******************************************
GAMEOVER
          JSR     DECSYSCO
          BNE     OVERBYE
          LDA     #4                     ;restore palette 5 colors
          STA     P5C1
          LDA     #9
          STA     P5C2
          LDA     NUMPLYRS               ;0 or 1
          CMP     NUMDEAD
          BNE     ENDITALL
          JSR     SWITCHP
          JSR     RESTART
          NEWSTATE GAME
          JMP OVERBYE
ENDITALL
          JSR     MKENTER                handles both players
          JMP     INITTITL               ;STACK...
OVERBYE   ENDCYCLE


**********
RESTART
**********
* Go to beginning of current player's rack.
          JSR     WVBLANK
          MOVE    #0,BACKGRND
          MOVE    #$60,CTRLWT            ;SHUT OFF DMA

          JSR     CONSINT2
          JSR     SOLVINIT
          JSR     INITPLDR
          JSR     PRELOAD
          JSR     SLOADER
          JSR     SCRAPALL
          LDA     #MAN0TUNE
          JSR     TUNIN
          LDA     #MAN1TUNE
          JSR     TUNIN
          JSR     WVBLANK

          MOVE    #$50,CTRLWT
          MOVE    #NGAMEDLI,NUMDLI
          RTS
******************************************
**********
INITTITL
          RESETSTK
          LDA     #FALSE                 select button was pushed to get here
          STA     SELREADY               if this is also menu mode
          STA     SOLVSTAT               ;;;HERE?
          JSR     WVBLANK

          LDA     #DMAOFF
          STA     CTRLWT                 ;SHUT OFF DMA

          JSR     SCRAPALL
          LDA     #NTITLDLI
          STA     NUMDLI
          LDA     #H(LOGO1)
          STA     CHARBASE

          LDA     #MTITLE
          STA     MODE
          NEWSTATE  TITLE

          LDX     PLAYER                 ; MAKE SURE PLAYER 0 JOYSTICK IS USED
          BEQ     PLAY0JOY
          JSR     SWITCHP
PLAY0JOY

; The following code will be used to setup the character maps which
;         display difficulty words in menu select mode:

; setup palette for the text: use palette 5.
          LDA     #$0C ;#0                     ; COLORS FOR TEXT
          STA     P5C1
          STA     P5C2
          JSR     LOGOCOL


; PUT INITIAL VALUES IN THE CHARACTER MAPS:
;         (ALL THREE, LENGTHS 8,9 AND 12)

          LDX     #10+9+11+11-1
NPLAYMAP  LDA     ONEPLAY,X
          STA     TCMAP1PL,X
          DEX
          BPL     NPLAYMAP
          JSR     DRAWLOGO               ; SET UP THE LOGO ITSELF
          JSR     SETDIFFS               ;difficulty character map
; Now create the display list list used by the title mode

          LDY     #(LOGODL-TDLL)-1
TDLLLOOP  LDA     TDLL,Y
          STA     TDLLTOP,Y
          DEY
          BPL     TDLLLOOP

          JSR     WVBLANK
          LDA     #L(TDLLTOP)             dlltop means zone13 is at the top
          STA     DPPL
          LDA     #H(TDLLTOP)
          STA     DPPH

          JSR     SETPLAYS               ;SET NUMBER OF PLAYERS CMAPS

          LDA     #HALFSEC               ; DE-BOUNCE BEFORE FIRST SWITCH
          STA     DBOUNCER               ; (INIT)
          LDX     #SEC20
          JSR     SETSYSCO              ;20-second timer for title page

          LDA     #DMAON                 ;RIGHT VALUE?
          STA     CTRLWT

          ENDCYCLE

LOGOCOL
          MOVE    #0,BACKGRND
          LDA     #$0D                   colors for logo use palette 0
          STA     P7C1
          LDA     #$06
          STA     P7C2
          LDA     #$80
          STA     P7C3
          RTS
TDLL
          DLLZONE  $F,DUMMYDL           ;NULL
          DLLZONE  DLIBIT+$F,DUMMYDL    ;NULL
          DLLZONE  $4F,TZONE0
          DLLZONE  $4F,TZONE1
          DLLZONE  $4F,TZONE2
          DLLZONE  $4F,TZONE3
          DLLZONE  $4F,TZONE4
          DLLZONE  $4F,DUMMYDL
          DLLZONE  $4F,DUMMYDL           ;NULL   6
          DLLZONE  $4F,TCMAPDL0
          DLLZONE  $4F,TCMAPDL1
          DLLZONE  $4F,TCMAPDL2
          DLLZONE  $45,DUMMYDL           ;NULL   8
          DLLZONE  $45,DUMMYDL           ;NULL   10
COPZONE   DLLZONE  $4F,TCMAPDL3
          DLLZONE  $4A,DUMMYDL           ;NULL   11
          DLLZONE  $48,DUMMYDL           ;NULL   12
          DLLZONE  $F,DUMMYDL
          DLLZONE  $F,DUMMYDL
LOGODL
TZ0       FOURBYTE  LOGOUL,LOGOPWUL,LOGOX0
          FOURBYTE  LOGOTOP,LOGOPWHZ,LOGOX0+16
          FOURBYTE  LOGOTOP,LOGOPWHZ,LOGOX0+28
          FOURBYTE  LOGOTOP,LOGOPWHZ,LOGOX0+40
          FOURBYTE  LOGOTOP,LOGOPWHZ,LOGOX0+52
          FOURBYTE  LOGOTOP,LOGOPWHZ,LOGOX0+64
          FOURBYTE  LOGOTOP,LOGOPWHZ,LOGOX0+76
          FOURBYTE  LOGOTOP,LOGOPWHZ,LOGOX0+88
          FOURBYTE  LOGOTOP,LOGOPWHZ,LOGOX0+100
          FOURBYTE  LOGOTOP,LOGOPWHZ,LOGOX0+112
          FOURBYTE  LOGOTOP,LOGOPWHZ,LOGOX0+124
          FOURBYTE  LOGOUR,LOGOPWUL,LOGOX0+134
          DB      0,0
TZ1
          FOURBYTE  LOGOLEFT,LOGOPWVT,LOGOX0
          FOURBYTE  LOGORITE,LOGOPWVT,LOGOX0+146 ;;;
          FOURBYTE  LOGO1,LOGOPW1,LOGOX1 ;TZONE1
          FOURBYTE  LOGO4,LOGOPW2,LOGOX2
          DB      0,0
TZ2
          FOURBYTE  LOGOLEFT,LOGOPWVT,LOGOX0
          FOURBYTE  LOGORITE,LOGOPWVT,LOGOX0+146 ;;;
          FOURBYTE  LOGO2,LOGOPW1,LOGOX1 ;TZONE2
          FOURBYTE  LOGO5,LOGOPW2,LOGOX2
          DB      0,0
TZ3
          FOURBYTE  LOGOLEFT,LOGOPWVT,LOGOX0
          FOURBYTE  LOGORITE,LOGOPWVT,LOGOX0+146 ;;;
          FOURBYTE  LOGO3,LOGOPW1,LOGOX1 ;TZONE3
          FOURBYTE  LOGO6,LOGOPW2,LOGOX2
          DB      0,0
TZ4       FOURBYTE  LOGOLL,LOGOPWUL,LOGOX0 ;TZONE4
          FOURBYTE  LOGOBOT,LOGOPWHZ,LOGOX0+16
          FOURBYTE  LOGOBOT,LOGOPWHZ,LOGOX0+28
          FOURBYTE  LOGOBOT,LOGOPWHZ,LOGOX0+40
          FOURBYTE  LOGOBOT,LOGOPWHZ,LOGOX0+52
          FOURBYTE  LOGOBOT,LOGOPWHZ,LOGOX0+64
          FOURBYTE  LOGOBOT,LOGOPWHZ,LOGOX0+76
          FOURBYTE  LOGOBOT,LOGOPWHZ,LOGOX0+88
          FOURBYTE  LOGOBOT,LOGOPWHZ,LOGOX0+100
          FOURBYTE  LOGOBOT,LOGOPWHZ,LOGOX0+112
          FOURBYTE  LOGOBOT,LOGOPWHZ,LOGOX0+124
          FOURBYTE  LOGOLR,LOGOPWUL,LOGOX0+134
          DB      0,0
TC0       FIVEBYTE  TCMAP1PL,$60,$A0+(32-8),48   ;TCMAPDL0
          DB      0,0
TC1       FIVEBYTE  TCMAPDIF,$60,$A0+(32-12),32  ;TCMAPDL1
          DB      0,0
TC2       FIVEBYTE  TCMAP2PL,$60,$A0+(32-9),44   ;TCMAPDL2
          DB      0,0
TC3
COPY1     FIVEBYTE  TCMAPCOP,$60,$A0+(32-11),32  ;TCMAPDL3
COPY2     FIVEBYTE  TCMAPNAM,$60,$A0+(32-11),32+128
          DB      0,0
TOMEGA
**********
DRAWLOGO
**********
; This is made a separate routine since it will also be called from
;         HISCORE and from MENU.

          LDY     #TOMEGA-LOGODL
TDLLOOP   LDA     LOGODL-1,Y
          STA     TZONE0-1,Y
          DEY
          BNE     TDLLOOP
          RTS

**********
SETDIFFS
**********
* Init the difficulty character map with the current difficulty
          LDX     DIFCULTY
          LDA     DIFFTABL,X
          STA     TEMP0
          LDA     DIFFTABH,X
          STA     TEMP1
          LDY     #11
SDLOOP    LDA     (TEMP0),Y
          STA     TCMAPDIF,Y
          DEY
          BPL     SDLOOP
          LDA     DIFFHPOS,X
          STA     TCMAPDL1+4             five-byte cmap header
          RTS
DIFFHPOS  DB      -4,$1C,$34,$44          remember padding of cmaps

**********
SETPLAYS
**********
; NUMBER OF PLAYERS WILL SWITCH BETWEEN DLIST0 AND DLIST2.  SETUP
;         EVERYTHING THE SAME EXCEPT FOR THE SECOND BYTE.

          LDA     #$60
          LDX     NUMPLYRS
          BEQ     LCOPYLP1               ; IF ONE PLAYER

          STA     TCMAPDL2+1               ; IF TWO PLAYER
          LDA     #0
          STA     TCMAPDL0+1               playnum must be 1
          BEQ     THATAWAY               jump

LCOPYLP1  STA     TCMAPDL0+1
          STX     TCMAPDL2+1               x is 0
THATAWAY  RTS

**********
; GOD COMES HERE DURING TITLE PAGE

TITLE
* ALTERNATE ATARI AND NAMCO COPYRIGHT MESSAGES

          DEC     TZONE0+(COPY1+4-LOGODL)
          DEC     TZONE0+(COPY2+4-LOGODL)
* Sneaky shit of fucking menu is ready now...
          LDA     HBUTTON
          BMI     NEWGAME1               ; BUTTON IS DOWN: START GAME
          LDX     FPRESET                ; IF RESET WAS PUSHED, GO TO GAME
          BPL     OPSELECT
          INX                            from $ff to 0
          STX     RESREADY               "false"
NEWGAME1  JMP      INITGAME              returns to GOD when done

*******************
* OPTION SELECT   *
*******************
; DO THE GAME OPTION SELECT BY POLLING THE SELECT SWITCH;
;         NOTE: ALSO POLL THE JOYSTICK, AT THE SAME DEBOUNCE RATE.

OPSELECT  LDA     DBOUNCER
          BEQ     LSELTEST               ; IF ZERO, STAY HERE WAITING FOR A
          DEC     DBOUNCER               ;   BUTTON
          JMP     TSTBONCE

LSELTEST  LDX     FPSELECT               ; SELECT SWITCH
          BEQ     LLTEST                 ; IF IT'S NOT PRESSED
*
* Select switch has been down long enough:
          INX                            from $ff to 0
          STX     SELREADY               "false"

; THERE ARE REALLY 8 "STATES" OR GAME OPTIONS-- 4 DIFFICULTY LEVELS
;         TIMES 2 PLAYNUM VALUES.  THUS THE FOLLOWING LOGIC--

          LDX     DIFCULTY
          LDA     NUMPLYRS
          BEQ     LSTEST00               ; 1 PLAYER-- FIRST HALF OF TABLES
          INX                            ; 2 PLAYER
          INX
          INX
          INX
LSTEST00  LDA     SELNUM,X               ; NEW PLAYNUM
          STA     NUMPLYRS
          LDA     SELDIFF,X              ; NEW DIFFICULTY
          STA     DIFCULTY
          BPL     LLOVER                 ; (JMP) reset SYSCOUNT and DBOUNCER
*
* If select switch not pressed, check P0 joystick input
LLTEST
          LDY     DIFCULTY
* 8 1 2
* 7 0 3
* 6 5 4
          LDA     NEWDIR                 ;ignore corners
          BEQ     TSTBONCE               ;dec SYSCOUNT if centered
          CMP     #1
          BEQ     UPCHANGE
          CMP     #5
          BEQ     DNCHANGE
          CMP     #3
          BEQ     TORIGHT
          CMP     #7
          BEQ     TOLEFT
          BNE     LLOVER                 ;(JMP) reset SYSCOUNT

UPCHANGE  LDA     #0
          STA     NUMPLYRS
          BPL     LLOVER                 ;JMP...
DNCHANGE  LDA     #1
          STA     NUMPLYRS
          BPL     LLOVER                 ;JMP...

TORIGHT   LDA     RIGHTNUM,Y
          BPL     LLHARD                 ;JMP...

TOLEFT    LDA     LEFTNUM,Y
LLHARD    STA     DIFCULTY

; IF ANY OPTION IS CHANGED, THE CODE WILL COME HERE. ZERO OUT THE PLAYER
;         SCORES-- AND RESET THE DEBOUNCE COUNTER

LLOVER    LDA     #HALFSEC
          STA     DBOUNCER
          LDX     #SEC20
          JSR     SETSYSCO              ;20-second timer for title page

          JSR     SETDIFFS               ; UPDATE DIFFICULTY DISPLAY
          JSR     SETPLAYS               ; UPDATE 1/2 PLAYER DISPLAY


*******************
* DEBOUNCE TEST   *
*******************
TSTBONCE  LDA     SELREADY
          BEQ     DECTTIME               ; STILL UP-- DON'T RESET DEBOUNCE

          LDA     NEWDIR
          BNE     DECTTIME               ; STILL PUSHED-- DON'T RESET

          LDA     #0                     ; MAKE SURE THAT THE FIRST PUSH
          STA     DBOUNCER               ;  REGISTERS IMMEDIATELY
                                         ; selready must have been $ff- 
*******************
* TIMER DECREMENT *
*******************
DECTTIME  JSR     DECSYSCO               ; DEC TIMER AND TEST
          BNE     LOGOBYE

*******************
* HISCORE STATE   *
*******************
AENDLOGO  JSR     MKHISCOR                ; DO ALL FOUR DIFFICULTY LEVELS
          JMP     INITAUTO
LOGOBYE   ENDCYCLE

*
* Next difficulty-state tables
SELNUM    DB      0,0,0,1,1,1,1,0        ;no. of players
SELDIFF   DB      1,2,3,0,1,2,3,0        ;difficulty level
RIGHTNUM  DB      1,2,3,3
LEFTNUM   DB      0,0,1,2
*
* This format is temporary.
ONEPLAY   DB      1*2+2,0,L(KP),L(KL),L(KA),L(KY),L(KE),L(KR)
          DB      0
OVERPLAY  DB      1*2+2                  ;OVERLAPS THESE 2 BYTES
TWOPLAY   DB      2*2+2,0,L(KP),L(KL),L(KA),L(KY),L(KE),L(KR),L(KS)
COPYA     DB      L(KCOPY)
          DB      1*2+2,9*2+2,8*2+2,4*2+2,0
          DB      L(KA),L(KT),L(KA),L(KR),L(KI)
COPYN     DB      L(KCOPY)
          DB      1*2+2,9*2+2,8*2+2,3*2+2,0
          DB      L(KN),L(KA),L(KM),L(KC),L(KO)
* All difficulties are <intermediate=12> letters long.
INTERMED  DB      L(KI),L(KN),L(KT),L(KE),L(KR),L(KM),L(KE),L(KD)
          DB      L(KI),L(KA),L(KT),L(KE)
NOVICE    DB      0,0,0,L(KN),L(KO),L(KV),L(KI),L(KC),L(KE) ;0,0,0
EXPERT    DB      0,0,0,L(KE),L(KX),L(KP),L(KE),L(KR),L(KT),0 ;0,0
ADVANCED  DB      0,0,L(KA),L(KD),L(KV),L(KA),L(KN),L(KC),L(KE),L(KD),0,0
GOROM     DB      L(KG),L(KA),L(KM),L(KE),0,0*2+2,L(KV),L(KE),L(KR)
*
* ptrs to the ROM cmaps
DIFFTABL  DB      L(NOVICE),L(INTERMED),L(ADVANCED),L(EXPERT)
DIFFTABH  DB      H(NOVICE),H(INTERMED),H(ADVANCED),H(EXPERT)
******************************************
RAM2      CSECT
DBOUNCER  DS      1
TDLLTOP   DS      LOGODL-TDLL            ;right now RAM is in abundance
TZONE0    DS      TZ1-TZ0                ;TOP BORDER
TZONE1    DS      TZ2-TZ1
TZONE2    DS      TZ3-TZ2
TZONE3    DS      TZ4-TZ3
TZONE4    DS      TC0-TZ4
TCMAPDL0  DS      TC1-TC0
TCMAPDL1  DS      TC2-TC1
TCMAPDL2  DS      TC3-TC2
TCMAPDL3  DS      TOMEGA-COPY1
TCMAP1PL  DS      8+2                    ;"1 PLAYER"
DUMMYDL   EQU     TZONE1-2
PLAYNUMB  EQU     TCMAP1PL+2             ;"PLAYER n"
TCMAP2PL  DS      9                      ;"2 PLAYERS"
TCMAPCOP  DS      11                     ;"C1984 ATARI"
TCMAPNAM  DS      11                     ;"C1983 NAMCO"
TCMAPDIF  DS      12                     ;"INTERMEDIATE"

**********
          END
