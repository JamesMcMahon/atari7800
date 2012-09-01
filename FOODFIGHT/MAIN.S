* MAIN.S
* THIS FILE IS FILLED WITH CRITICAL USEFUL ROUTINES.
;         "STARTUP"-- COMES HERE ON POWERUP
;         "POWERUP"-- HANDLES ALL ONE-TIME MEMORY INITIALIZATION
;         "NEWGAME"-- CALLED TO INITIATE A NEWGAME FROM ANOTHER MODE
;         "NEWRACK"-- CALLED WHEN A GAME RACK HAS JUST ENDED
;         "GAME"-- CALLED FROM "GOD" WHEN MODE==MGAME
;         "REPLAY"-- USED TO READ CONTROLLER VALUES FROM REPLAY TABLES
;         "GAMEINIT"-- CALLED FROM "NEWGAME" TO DO ONE-TIME GAME STUFF
;         "COLRINIT"-- SETS ALL PALETTES TO NORMAL GAME PALETTES
;         ALL DLI HANDLERS FOR GAMEPLAY DISPLAY LISTS
;

          GLBL    NUMCHHIT,LASTPILE
          GLBL    MKPROMPT
          GLBL    GOD

          GLBL    STATDISP
          GLBL    GODPTR
          GLBL    SETMAPS
          GLBL    AWOLDRAW
          GLBL    CHUCK
          GLBL    CHEFMOVE
          GLBL    FOODMOVE
          GLBL    ICEMELT
          GLBL    FOODHIT
          GLBL    PILEHIT
          GLBL    HOLEHIT
          GLBL    CONEHIT
          GLBL    CHEFHIT
          GLBL    SCRAPALL,TUNIN
          GLBL    WAIT                   ; IN "FOODMOVE"
          GLBL    COLRINIT,NEWGAME
          GLBL    CLEARALL               ; IN "LOGO.S"
          GLBL    GAME
          GLBL    PAUSE
          GLBL    DLLCOPY
          GLBL    DPPINIT,DPPSTORE
          GLBL    NMIRTN                 ; FROM "HISCORE.S"
          GLBL    GLCONT21
          GLBL    MPAUSE
          GLBL    REPLAY,DOGAME,NEWRACK
          GLBL    GAMEINIT
          GLBL    MKHISCOR
          GLBL    PREFRESH
          GLBL    RANDSEED,RANDK,RANDJ

          GLBL    HIGHSCOR,M160X2,MKLOGO
          GLBL    M320X1
          GLBL    TRUE,LOGO,FALSE
          GLBL    CHARINIT,RACKINIT,STATWON
          GLBL    STATDIE,STATBON,STATDIEH,STATINIT,STATWAIT,DEAD,WON
          GLBL    STATEND
          GLBL    STATENDR
          GLBL    PL0RACK,PL1RACK,PL0LIVES,PL1LIVES,PL0SCORE,PL1SCORE
          GLBL    PL0FIRST,PL1FIRST
          GLBL    PL0IRTIM,PL1IRTIM
          GLBL    PL0BONUS,PL1BONUS
          GLBL    PL0BCD,PL1BCD
          GLBL    PL0CARRY,PL1CARRY,CMAP1
          GLBL    CMAPHIGH,CMAP2,CLOWMAP1,CLOWMAP2,NULL2,NULLCHAR
          GLBL    PUTSCORE,BACKCOLR,STATLOGO
          GLBL    DLIST0,DLIST1,DLIST2,DLIST3,DLIST4,DLIST5,DLIST6
          GLBL    DLIST7,DLIST8,DLIST9,DLIST10
          GLBL    DLISTA,DLISTB
          GLBL    STATLIST,SCORELST
          GLBL    FINFO,POLE,TUNER,MLOADER
          GLBL    DLLRAM
          GLBL    MLOGO,MGAME,MATTRACT,MBLANK
          GLBL    MTEXT,MSELECT

          GLBL    CDIR

          GLBL    IRDIRA,IRDIRB,IRTHROW
          GLBL    IRDIRC,IRDIRD
          GLBL    AIRDIRA,AIRDIRB,AIRDIRC,AIRDIRD,AIRTHROW
          GLBL    ASET

          GLBL    IRTNDONE
          GLBL    DRIPTIME
          GLBL    DLI1,DLI4

          GLBL    COLORROM,COLORS,LISTTABL,LISTTABH,TOPZONE,DLLROM
          GLBL    SWLIST,NULLLIST,JOYTABLE,TRUEBUT
          GLBL    DIRTABL,DIRTABH,ADIRTABL,ADIRTABH,RACKWORD
          GLBL    FOODSTUF,FOODWORD

          RAMDEF                         ; ZERO PAGE

          ORG     $FFF8

          DB      $FF,$E7                ; ADDRESSES START AT $A000
          DB      L(NMIVEC),H(NMIVEC)    ; GO HERE FOR DLI
          DB      L(STRTHERE),H(STRTHERE)  ; GO HERE ON RESET
          DB      L(NOTNMI),H(NOTNMI)    ; SO THAT I CAN INITIATE A DLI
                                         ; FROM SOFTWARE

          ORG     $EFFA

STRTHERE  JMP     STARTUP
NOTNMI    RTI
          RSEG    CODE1                  ; WILL BE SET TO B000

; THE FOLLOWING BODY OF CODE IS THE POWER UP INITIALIZATION:

STARTUP   SEI                            ; PERMANENT

          MOVE    #7,$01                 ; LOCKS THE BASE UNIT INTO 3600 MODE

          MOVE    #$7F,CTRL              color is on
          CLD                            ; ALWAYS CLEARED

          LDA     #0                     ; MAKE SURE BUTTONS WILL WORK
          STA     CTLSWA
          STA     CTLSWB
          STA     OFFSET                 ; OLD LOCATION OF "OFFSET"

; CAN'T USE "JSR" SINCE THIS ROUTINE ZEROS THE STACK

          LDX     #$FF                   ; STACK IN TOP OF ZERO PAGE
          TXS                            ;SET STACK POINTER
          JMP     ZERORAM
ZRAMRTN

          JSR     SCRAPALL               ; INITIALIZE SOUND

          JSR     COLRINIT               ; INITIALIZE COLORS BEFORE LOGO

          JSR     POWERUP                ; SETS DLL AND CTRL (STARTS DMA)

          JMP     MKLOGO                 ; THIS RETURNS TO "GOD"

********************************************************************************

; JMP HERE ANYTIME WE'RE ABOUT TO START A GAME.
; RESET THE STACK POINTER.
;   FIRST OF ALL, MAKE SURE THAT THE FIRST DLIST DOESN'T SET THE WRITE MODE,
;         SINCE THIS WILL HAPPEN ONCE IN THE VERY FIRST DLI1 AFTER POWERUP.

NEWGAME   INC     GAMECNT

          LDX     #$FF
          TXS

          MOVE    #MGAME,MODE

          NEWSTATE   GAME

          MOVE    #FALSE,RUNLOAD

          JSR     CLEARALL               ; IN LOGO.S

          JSR     SCRAPALL               ; NO TUNES, PLEASE !

; ZERO OUT PLAYER SCORES BEFORE A NEW GAME--

          LDA     #0
          LDX     #3
ZGILP01   STA     PL0SCORE,X
          STA     PL1SCORE,X
          DEX
          BPL     ZGILP01

          JSR     GAMEINIT               ; SETS APPROPRIATE VARIABLES
;         JSR     AWOLDRAW               ; CALLED WHEN "SELECT" EXITS

          JSR     COLRINIT               ; NECESSARY SINCE LOGO AND HISCORE
                                         ;    CHANGE THE PALETTES
          JSR     CHARINIT               ; SET UP THE RACK, FIRST TIME !
                                         ;  THIS MEANS THERE'S NO NEED
                                         ; TO TEST FOR END OF GAME, WHICH
                                         ; "RACKINIT" DOES.
;         JSR     DPPINIT                DMA turned on in HERODRAW

          MOVE    #TRUE,RUNLOAD

          ENDCYCLE

; JSR HERE FOR A NEW RACK

NEWRACK
          MOVE    #FALSE,RUNLOAD         ;Must be off after hero displays
                                         ;while fixed stuff initializes
          JSR     RACKINIT               ; INITIALIZE EVERYTHING
                                         ; DMA is turned on there
          MOVE    #TRUE,RUNLOAD
          RTS                            ; LET GOD PROCESS "GAME"

; THIS ROUTINE IS CALLED FROM GAME IF PERCHANCE CHARLIE CHUCK WERE TO DIE
; ON AN INSTANT REPLAY.  BUT, AS WE ALL KNOW THIS IS IMPOSSIBLE (?).

IRDEATH   MOVE    #FALSE,DOITOVER
          JSR     SCRAPALL

          LDA     #27                    ; PLAY FREE MAN TUNE.
          JSR     TUNIN

          LDX     CURRENT
          INC     PL0LIVES,X
          INC     PLLIVES
          JSR     STATDISP               ; GIVE EXTRA C.C. & DISPLAY

          LDA     #4
          JSR     MKPROMPT

          MOVE    #WON,CSTATE
          MOVE    #TRUE,DOITOVER

          JMP     SKIPSKIP

; THIS ROUTINE IS CALLED FROM "GOD" IF WE'RE IN GAMEPLAY MODE.
; FIRST TEST TO SEE IF THIS IS THE WAIT AT THE END OF THE RACK-
GAME      LDA     STATUS
          CMP     #STATENDR
          BNE     GAME99                 ; NOT A REPLAY

          LDA     CSTATE
          CMP     #DEAD                  ; DID CHUCK DIE IN IR ???
          BEQ     IRDEATH

          LDA     IRTNDONE               ; IF FALSE, KEEP WAITING
          BEQ     GAME98

          LDA     DOITOVER
          BPL     SKIPTAG                ; NOT AN IR TUNE

          JSR     SCRAPALL               ; GET RID OF IR TUNE

          MOVE    #FALSE,DOITOVER        ; SO THAT "TUNIN" FUNCTIONS

          LDA     #31                    ; TAG AT END OF IR TUNE
          JSR     TUNIN
          LDA     #32
          JSR     TUNIN

          MOVE    #TRUE,DOITOVER

          BNE     SKIPSKIP               a jump

SKIPTAG   JSR     SCRAPALL

SKIPSKIP  MOVE    #STATEND,STATUS        ; SO THAT THIS CODE WILL WAIT
                                         ;   FOR "WAITCNT" CYCLES
          BPL     GAME98                 a jump

GAME99    CMP     #STATEND               ; END OF RACK BUT EITHER NOT REPLAY,
          BNE     GAME90                 ;   OR AFTER END OF REPLAY TUNE

          DEC     WAITCNT
          BEQ     GAME91

GAME98    JSR     CHEFMOVE               ; KEEP THEM REJOICING

          ENDCYCLE

GAME91    JMP     GLCONT21               ; END OF GAME ROUTINE TESTS

; TEST TO SEE IF I SHOULD GO INTO "PAUSE" MODE.

GAME90    LDA     FPPAUSE                ; TEST FOR PAUSE FIRST THING !
          BEQ     GAMEON1

GAME00    LDA     PSREADY
          BEQ     GAMEON1                ; IF NOT READY, THEN GO AHEAD

; IF I REACH HERE, IT'S TIME TO GO INTO PAUSE MODE:

          LDA     #0
          STA     AUDV0
          STA     AUDV1

          STA     SYSCOUNT               18 minute timer
          STA     SYSCOUNT+1

          STA     PSREADY                "FALSE" = 0

          MOVE    #MPAUSE,MODE
          NEWSTATE   PAUSE

          ENDCYCLE

; Poll the select and reset buttons.  Don't do this if the GAME OVER message
;         is displayed.

;         LDA     MODE
;         CMP     #MTEXT
;         BNE     GAMEON1                not a message
;         LDA     TEMP4
;         BNE     GAMEON                 non-zero means GAME OVER message

GAMEON1   LDA     FPSELECT
          BEQ     GAMEON2                ; BUTTON NOT PUSHED

          LDA     SELREADY               ; IGNORE BUTTON UNLESS IT'S READY
          BEQ     GAMEON2

          JMP     MKLOGO

; TEST THE RESET BUTTON TO SEE IF I SHOULD START A NEW GAME--

GAMEON2   LDA     FPRESET
          BEQ     GAMEON

          LDA     RESREADY
          BEQ     GAMEON

          MOVE    #FALSE,RESREADY

          JMP     NEWGAME

; SET THE "SOFT" CONTROLLER VALUES.  THESE WILL
;         BE COPIED FROM (1) THE "HARD" VALUES IF NOT INSTANT REPLAY;
;         (2) THE INSTANT REPLAY TABLES IF THIS IS AN INSTANT REPLAY.
;      ONLY DO THIS ON EVEN NUMBERED CYCLES, SO THAT I CUT THE RAM NEEDED
;         FOR INSTANT REPLAY IN HALF.
; Change: only do this on every 4th cycle, to aid the diagonal problem
;         and to cut IR RAM even more.
; IN EACH 60TH OF A SECOND, "NUMCYCLE = 1" ONLY ONCE.

GAMEON    LDA     NUMCYCLE               ; MAKE SURE THAT TIMERS ARE STILL
          CMP     #1                     ;  BASED ON REAL (INTERRUPT) TIME
          BNE     SKIPINC

          INC     CYCLECNT               ; MAKE SURE THIS IS ONLY ONCE
                                         ;   PER FRAME
          DEC     DRIPTIME               ; ICE CREAM CONE TIMER FOR ANIMATION

          DEC     SYSCOUNT               ; GENERAL PURPOSE SYSTEM COUNTER

          LDA     CYCLECNT               every even frame, update timer
          LSR     A
          BCC     NOFINFO
          DEC     FINFO                  cone timer
SKIPINC   JMP     DOGAME

NOFINFO   LSR     A                      every fourth frame, update direction
          BCS     SKIPINC                and button values

; ONCE WE REACH HERE, EVERYTHING THAT FOLLOWS IS BEING EXECUTED ONCE
;         EVERY FOUR FRAMES, REGARDLESS OF "MAXCYCLE"

GLCONT10  LDA     DOITOVER
          BNE     DOREPLAY

          MOVE    HJOYDIR,JOYDIR
          MOVE    HTHROW,THROWBUT

; NOW SAVE AWAY VALUES IN THE INSTANT REPLAY TABLES :
;   NOTE: DIRTAB CONTAINS POINTERS TO THE FOUR DIRECTION TABLES.
;         EACH ONE OF THESE HAS 128 LOCATIONS, ACCOUNTING FOR 256
;         VALUES OF CYCLEIDX; THIS REPRESENTS 8 SECONDS OF GAMEPLAY.
; CHANGED: each one now has 64 locations, accounting for 128 values
;         of CYCLEIDX; this still represents 8 seconds of gameplay.
;         128 values of CYCLEIDX represents 128 x 4 cycles, or 512.

          LDX     CYCLEIDX+1
          LDA     DIRTABL,X
          STA     TEMP0
          LDA     DIRTABH,X
          STA     TEMP1

          LDA     CYCLEIDX
          LSR     A                      ; GET INDEX AS WELL AS NIBBLE
          TAY
          BCC     ZUPNIB01               ; EVEN FRAME == UPPER NIBBLE

          LDA     (TEMP0),Y
          ORA     JOYDIR                 ; UPPER NIBBLE ALREADY IN A
          STA     (TEMP0),Y
          JMP     ZINSKIP1

ZUPNIB01  LDA     JOYDIR
          ASL     A                      ; THIS ALSO ZEROS OUT THE VALUE
          ASL     A                      ; FROM THE LAST IR
          ASL     A
          ASL     A                      ; PUT INTO UPPER NIBBLE
          STA     (TEMP0),Y

; JOYSTICK STORAGE IS FINISHED-- DO THE BUTTON STORAGE

ZINSKIP1  LDA     THROWBUT               ; IF THE BUTTON IS UP, LEAVE A
          BEQ     POLLOVER                 ;  ZERO IN THE BIT FOR THIS CYCLE

          LDA     CYCLEIDX
          AND     #$7                    ; TELLS WHICH BIT OF IRTHROW
          TAY
          LDX     THROWIDX               ; INC'ED EVERY EIGHTH CYCLE
          LDA     TRUEBUT,Y              ; SETS PROPER BIT
          ORA     IRTHROW,X              ; ADDS IN THIS NEXT BIT
          STA     IRTHROW,X

          JMP     POLLOVER

DOREPLAY  JSR     REPLAY

; ONLY INCREMENT "CYCLEIDX" AND "THROWIDX" FOR CYCLES WHERE THE IR TABLES
;         ARE WRITTEN TO.

POLLOVER  INC     CYCLEIDX               each table holds $40 bytes, or
          BPL     ZDOGAME0               $80 values of CYCLEIDX
          INC     CYCLEIDX+1             ; GO TO NEXT BLOCK OF STORAGE
          LDA     #0
          STA     CYCLEIDX

ZDOGAME0  LDA     CYCLEIDX
          AND     #$07
          BNE     DOGAME
          INC     THROWIDX               ; INCREMENT EVERY 8 TIMES

; NOW WE'RE FINALLY DOING REAL GAMEPLAY !

; NOTE: FOR FINAL VERSION, FOR SPEED, TAKE OUT THESE "STATUS" TESTS
;         AND CHANGE THE "RTS" IN THE ROUTINES WHICH SET STATUS TO
;         POP THE STACK AND JMP TO A LOCATION HERE (GLCONT00, FOR EXAMPLE)

DOGAME
          JSR     CHUCK                  ; ALWAYS DO THESE
          JSR     CHEFMOVE
          JSR     FOODMOVE

          LDA     STATUS
          CMP     #STATWON               ; NO INTERSECTS OR FOOD IF HE'S EATING
          BEQ     GLCONT00

          JSR     ICEMELT                call this unless he's won.  I can't
                                         ; place this call below because
                                         ; ICEMELT must be called even if the
                                         ; STATUS is STATDIEC
          LDA     STATUS
          CMP     #STATBON               ; IF FOOD IS FLYING TO SCORE
          BEQ     GLCONT00

          JSR     FOODHIT                ; IF FOOD IS FLYING AT SCORE

          LDA     STATUS
          CMP     #STATDIEH
          BPL     GLCONT00               ; ALL DEATH STATES ARE >= STATDIEH

          CMP     #STATINIT
          BEQ     GLCONT00
          CMP     #STATWAIT              ; DON'T DO INTERSECTS IF CHEFS ARE
          BEQ     GLCONT00               ;   RISING

          JSR     PILEHIT
          JSR     HOLEHIT
          JSR     CHEFHIT
          JSR     CONEHIT

; DON'T DO THE FOLLOWING TESTS IF WE'RE SUPPOSED TO BE WAITING BEFORE A RAKC
;         END:

GLCONT00  LDA     STATUS
          CMP     #STATEND
          BNE     GLCONT21

          ENDCYCLE

; HERE I'LL NEED TO INSERT TESTS TO SEE IF THE RACK HAS ENDED:
;         1) TEST TO SEE IF CONE HAS MELTED;
;         2) TEST TO SEE IF HERO HAS REACHED THE CONE;
;         3) TEST TO SEE IF HERO HAS DIED.
;   IF THE RACK HASN'T ENDED, CONTINUE THE MAIN GAME LOOP.
;         NOTE: THIS MIGHT BE AN ATTRACT MODE.  IF THE GAME ENDS, AND
;         THIS IS AN ATTRACT MODE, THEN GO STRAIGHT TO THE HISCORE
;         MODE BY CALLING "MKHISCOR" IN THE FILE "HISCORE.S"

GLCONT21  LDA     CSTATE                 ; HERO'S STATE
          CMP     #DEAD
          BNE     GLCONT01

          LDA     MODE
          CMP     #MATTRACT
          BEQ     GLCONT20

GLCONT02  JSR     NEWRACK
GLCONT03  ENDCYCLE

GLCONT20  JMP     MKLOGO

GLCONT01  CMP     #WON
          BNE     GLCONT03

; If we get here, we know the rack has ended, through either death or
;         munching.  If it's auto play, just go to the logo; else,
;         do a new rack.

          LDA     MODE
          CMP     #MATTRACT
          BEQ     GLCONT20
          BNE     GLCONT02               a jump

; THIS ROUTINE IS CALLED FROM "NEWGAME" TO ZERO ALL OF RAM

ZERORAM
          LDA     #0
          LDX     #$00
ZM000     STA     $00,X                  ; ZEROS OUT THE ZERO PAGE
          DEX
          CPX     #$40                   ; STOPS AT MARIA REGISTERS
          BCS     ZM000

; ZERO OUT THE FIRST PAGE
; Removed-- First Page only used for STACK

AZMFP     LDA     #H(LASTPILE)           ; ZERO OUT MEMORY THAT WAS IN FIRST
          STA     $FF                    ; PAGE BEFORE IT WAS MOVED TO $2660-92
          LDY     #L(LASTPILE)
          LDA     #$00
;         STA     $FE                    ; THIS WAS ZEROED OUT ABOVE
ZMFP      STA     ($FE),Y
          DEY
          CPY     #L(NUMCHHIT)
          BCS     ZMFP

; NOW ZERO OUT THE REST OF RAM, USING COUNTERS IN THE ZERO PAGE.
; ZERO OUT 1800-2000

;         STA     $FE                   ; USE THIS LOCATION BECAUSE
          LDA     #$18                   ;   IT'S NOT SHADOWED HIGHER UP
          LDX     #$08                   ; 8 PAGES FROM 1800-2000
          JSR     ZMSUB

; NOW ZERO OUT 2200-2800 (6 PAGES)

;         STA     $FE                   ; USE THIS LOCATION BECAUSE
          LDA     #$22                   ;   IT'S NOT SHADOWED HIGHER UP
          LDX     #$06                   ; 6 PAGES FROM 2200-2800
          JSR     ZMSUB

          JMP     ZRAMRTN

ZMSUB     STA     $FF
          LDA     #0
          TAY
ZM999     STA     ($FE),Y
          DEY
          BNE     ZM999
          INC     $FF
          DEX
          BNE     ZM999
          RTS

DLLCOPY   LDX     #56                    ; COPIES 57 BYTES-- 19 ENTRIES
ZPUPLOOP  MOVE    DLLROM,X,DLLRAM,X
          DEX
          BPL     ZPUPLOOP

          RTS

POWERUP
          MOVEPTR DLI1,DLIADR             ; SETUP FOR FIRST NMI INTERRUPT

          JSR     DLLCOPY                ; GET DLLRAM CORRECT

          LDX     #0
          STX     PLAYNUM                ; ONE PLAYER
          STX     ASET                   no instant replay tables yet
          STX     FOODSTUF

          INX
          STX     HOWHARD                ; MEDIUM DIFFICULTY

          LDA     #15                    highest level allowed
          STA     HIGHEST                is level 16
          STA     HIGHEST+1

          LDX     #6                     make sure hero starts facing left
          STX     HJOYDIR
          STX     JOYDIR                 center the joystick for first game

; This loop starts with X = 6

ZPUPLP2   MOVE    SWLIST,X,DLISTA,X      ; COPY SWLIST AND NULLLIST
          DEX
          BPL     ZPUPLP2

          LDA     #TRUE
          STA     PSREADY
          STA     RESREADY
          STA     SELREADY

;         JMP     DPPINIT                same as JSR followed by RTS

; TURN DMA BACK ON AFTER SETTING DPPH

DPPINIT   BIT     MSTAT                  ; FIRST WAIT FOR ON-SCREEN
          BMI     DPPINIT

DPPINIT0  BIT     MSTAT                  ; NOW WAIT FOR VBLANK
          BPL     DPPINIT0

DPPSTORE  LDA     #L(DLLRAM)
          STA     DPPL
          LDA     #H(DLLRAM)
          STA     DPPH

          MOVE    #M160X2,CTRL           ; TURN DMA BACK ON, CORRECT VALU

          RTS

GAMEINIT
          LDX     #0
          STX     PL0RACK
          STX     PL1RACK

          STX     PL0BONUS
          STX     PL0BONUS+3
          STX     PL1BONUS
          STX     PL1BONUS+3

          STX     PL0CARRY
          STX     PL1CARRY

          STX     PL0BCD
          STX     PL1BCD

          STX     PL0IRTIM
          STX     PL1IRTIM

          STX     CURRENT

          DEX                            TRUE is $FF
          STX     PL0FIRST
          STX     PL1FIRST

          INX                            level 1 is first
          INX
          STX     PL0BCD+1
          STX     PL1BCD+1

          INX                            bonus at 25000
          STX     PL0BONUS+1
          STX     PL1BONUS+1

          INX                            three lives
          STX     PL0LIVES
          STX     PL1LIVES

          LDA     #$50                   ; BCD FOR 50
          STA     PL0BONUS+2
          STA     PL1BONUS+2

          LDX     #0
          LDA     PLAYNUM
          BEQ     GI0010

          INX

GI0010    STX     OTHER

          LDX     #FALSE
          STX     DOITOVER               ; FIRST RACK ISN'T INSTANT REPLAY

; PICK SOME RANDOM SEEDS:

          LDA     FRAMECNT               ; WAS LDA #$33
          STA     RANDOM0
          LDA     CYCLECNT               ; WAS LDA #$44
          STA     RANDOM1
          ADC     #55                    ; WAS LDA #$55
          STA     RANDOM2

          MOVE    #$E8,CHARBASE          ; SAME FOR NUMBERS AND HEADS

GIBYE     RTS

; ALSO CALLED FROM "INIT.S" BEFORE THE FIRST LEVEL

SETMAPS   MOVE    #L(CMAP1),SCORELST     ; PLAYER 1 SCORE
          MOVE    #$60,SCORELST+1
          MOVE    #H(CMAP1),SCORELST+2
          MOVE    #$B8,SCORELST+3         ; PALETTE 5, WIDTH 8
          MOVE    #08,SCORELST+4         ; HPOS
          MOVE    #L(CMAP2),SCORELST+5   ; PLAYER 2 SCORE

          LDX     #0
          LDA     PLAYNUM                ; IF TRUE, THEN TWO PLAYER
          BEQ     ZGI022                 ; IF FALSE

          LDX     #$60

ZGI022    STX     SCORELST+6
          MOVE    #H(CMAP2),SCORELST+7
          MOVE    #$B8,SCORELST+8       ; PALETTE 5, WIDTH OF 8
          MOVE    #96,SCORELST+9        ; PLAYER 2 SCORE

          LDY     #00                    keep 0 in Y for awhile
          STY     SCORELST+11             ; END OF LIST FLAG

          LDX     #$60                   keep 60 in X

; SET UP CHARACTER MAPS FOR THE BOTTOM HALF ZONE (EXTRA LIVES HEADS):

          MOVE    #L(CLOWMAP1),STATLIST
          STX     STATLIST+1
          MOVE    #H(CLOWMAP1),STATLIST+2
          MOVE    #$0F,STATLIST+3         ; HERO PALETTE, WIDTH 17
          MOVE    #$5C,STATLIST+4          ; FLUSH WITH RIGHT BORDER

          MOVE    #L(CLOWMAP2),STATLIST+5
          STX     STATLIST+6
          MOVE    #H(CLOWMAP2),STATLIST+7
          MOVE    #$8E,STATLIST+8        ; PALETTE 4 (TOMATO), WIDTH 18

          STY     STATLIST+9             ; Y still has 0
          STY     STATLIST+11            ; END OF LIST

          LDY     #59
          LDA     #NULL2
ZCMINIT   STA     CMAP1,Y                ; ALL NULL CHARACTERS
          DEY
          BPL     ZCMINIT

; COPY THE INFORMATION FOR THE WORD "LEVEL" INTO "CLOWMAP2"

          MOVEPTR RACKWORD,TEMP0

          LDA     FOODSTUF
          BEQ     NOFOODW

          MOVEPTR FOODWORD,TEMP0

NOFOODW   LDY     #9
ZCMINIT0  LDA     (TEMP0),Y
          STA     CLOWMAP2,Y
          DEY
          BPL     ZCMINIT0

          LDA     CURRENT
          ASL     A
          ASL     A
          TAY
          JSR     PUTSCORE               ; DISPLAY SCORE FOR CURRENT PLAYER

          LDA     PLAYNUM
          BEQ     SMBYE

          LDA     OTHER
          ASL     A
          ASL     A
          TAY
          JSR     PUTSCORE               ; DISPLAY SCORE FOR OTHER PLAYER

SMBYE     RTS

; Copies the table COLORROM into COLORS

COLRINIT
          LDX     #31
ZCLRLOOP  LDA     COLORROM,X
          STA     COLORS,X
          DEX
          BPL     ZCLRLOOP

          RTS

; refreshes the palettes every frame

PREFRESH
          LDX     #0
          STX     BACKGRND

ZCLR01    LDY     #2
ZPRLOOP   LDA     COLORS,X
          STA     P0C1,X
          INX
          DEY
          BPL     ZPRLOOP
          INX
          CPX     #31
          BMI     ZCLR01

          RTS

NMIVEC    PHA
          TYA
          PHA
          TXA
          PHA

          CLD                            just in case decimal is set

          JMP     (DLIADR)

NMIRTN    PLA
          TAX
          PLA
          TAY
          PLA

IRQVEC    RTI

; ALL OF THE NMI HANDLERS FOLLOW.

DLI1      MOVEPTR DLI2,DLIADR             ; SETUP FOR SCORE DLIST
          MOVE    #$E8,CHARBASE
          MOVE    #$50,CTRL              ; 160X2, 2 BYTE CHARACTERS
; Setup palette 5 for the score:
          MOVE    #$19,P5C1              ; COLORS FOR TEXT (YELLOW)
          MOVE    #$15,P5C2
          MOVE    #$1F,P5C3
          JMP     NMIRTN

DLI2      STA     WSYNC                  wait for end of scan line before
                                         ;changing color of score palette
          MOVEPTR DLI3,DLIADR             ; AFTER SCORE, BEFORE PLAYFIELD
          STA     WSYNC

; If the rack is in progress, use the banana colors here UNLESS the food
;         is hitting the score with the bonus points displayed.
;    Else, text is displayed; if TEMP4 is $80 it's an Instant Replay message
;         and should cycle through all colors.
;    If it's any other message, keep the palette as it was for score display.

          LDA     MODE
          CMP     #MGAME
          BEQ     BARF1
          CMP     #MATTRACT
          BEQ     BARF1

          LDA     TEMP4
          CMP     #$80
          BNE     NOFLASH

          LDA     TEMP5
          STA     P5C1
          STA     P5C2
          STA     P5C3
          JMP     NMIRTN

BARF1     MOVE    #$13,P5C1              ; restore banana colors
          MOVE    #$18,P5C2
NOFLASH   JMP     NMIRTN                 if not IR, same colors as score text

DLI3      MOVE    #M160X2,CTRL           ; 1-BYTE CHARACTERS
          MOVEPTR DLI4,DLIADR             ; OCCURS RIGHT AFTER PLAYFIELD
                                         ;  SO THAT LOADER CAN START DURING
                                          ;  STATUS ZONE DISPLAY

; just moved all this from DLI4 to give the loader the extra 8+24 scan lines
;         of off-screen time

          INC     FRAMECNT

          LDA     FRAMECNT
          LSR     A
          BCC     DONTLOAD

          BIT     RUNLOAD
          BPL     DONTLOAD               ; IF SET TO "FALSE"

          JSR     MLOADER
DONTLOAD
          JSR     TUNER                  ; SOUND DRIVER
          JMP     NMIRTN

DLI4      STA     WSYNC
          LDA     SWCHB                  ;;; TEMP FOR BREAKPOINT DETECTION
          STA     WSYNC
          STA     WSYNC                  ; NOW SHOULD BE IN VBLANK

          JSR     PREFRESH               refresh the palettes and background

; IF MSTAT IS NEGATIVE, WE'RE IN VBLANK

DLI4TEST  BIT     MSTAT                  ; RETURN HERE UNTIL I GET TWO
          BMI     DLI4TST1               ;  IDENTICAL VALUES

          BIT     MSTAT                  ; IF WE'RE NOT IN VBLANK, DON'T
          BPL     DLI4BYE                ;  CHANGE THE NMI VECTOR

          JMP     DLI4TEST               ; IF WE DON'T GET THE SAME TWICE

DLI4TST1  BIT     MSTAT                  ; IF WE DON'T GET THE SAME TWICE
          BPL     DLI4TEST

; ELSE, WE'RE IN VBLANK-- ALL IS WELL.  RESET "DLIADR"

          MOVEPTR DLI1,DLIADR
DLI4BYE   JMP     NMIRTN

; CALL THIS ROUTINE FROM BOTH "GAME" AND "ATTRACT"
;         This routine will use a different set of tables
;         if ASET is non-zero and the mode is ATTRACT.  These tables
;         should represent the last instant replay.
;
;         ASET==0 : no tables; just go left
;         ASET!=0 : use AIR tables

;         this routine should not be called from ATTRACT unless ASET is not
;         zero

REPLAY    LDX     CYCLEIDX+1

          LDA     MODE                   if not attract, use last IR
          CMP     #MATTRACT
          BNE     RGAME00

          LDA     ASET                   if ASET is 0, then just go
          BNE     DOAIR                  left
          JMP     RPBYE

DOAIR     LDA     ADIRTABL,X             last completed instant replay
          STA     TEMP0
          LDA     ADIRTABH,X
          STA     TEMP1

          JMP     RGAME01

RGAME00   LDA     DIRTABL,X              this is an instant replay, or the
          STA     TEMP0                  last death
          LDA     DIRTABH,X
          STA     TEMP1

RGAME01   LDA     CYCLEIDX
          LSR     A
          TAY
          BCC     ZUPNIB02
          LDA     (TEMP0),Y              ; LOWER NIBBLE
          AND     #$0F
          JMP     ZSETD02

ZUPNIB02  LDA     (TEMP0),Y
          LSR     A
          LSR     A
          LSR     A
          LSR     A

ZSETD02   STA     JOYDIR

          LDA     CYCLEIDX
          AND     #7
          TAY
          LDA     TRUEBUT,Y
          LDX     THROWIDX

          LDY     ASET                   Use the A tables if ASET and in
          BEQ     ZSETD001               attract mode

          LDY     MODE
          CPY     #MATTRACT
          BNE     ZSETD001

          AND     AIRTHROW,X
          JMP     ZSETD003

ZSETD001  AND     IRTHROW,X
ZSETD003  BEQ     ZNOTHROW               ; IF 0, BUTTON IS UP

          LDA     #TRUE
          JMP     ZRPSETB

ZNOTHROW  LDA     #FALSE
ZRPSETB   STA     THROWBUT

RPBYE     RTS

          END

