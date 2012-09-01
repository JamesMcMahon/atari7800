; ATTRACT.S
; THIS ROUTINE IS CALLED BY "GOD" WHEN THE "MODE==MATTRACT".
;         IF THIS IS THE FIRST GAME, CHUCK USES RANDOM DIRECTIONS,
;         FOR RANDOM AMOUNTS OF TIME.
;         IF THIS ISN'T THE FIRST GAME, USE THE INSTANT REPLAY TABLE
;         FOR ATTRACT MODES.
;

          GLBL    DIRTABL,DIRTABH
          GLBL    CDIR
          GLBL    RANDOM
          GLBL    DOGAME
          GLBL    REPLAY
          GLBL    GAMEINIT
          GLBL    AWOLDRAW
          GLBL    ATTRACT
          GLBL    MKAUTO
          GLBL    MKLOGO

          GLBL    CINFO,FINFO,NEWRACK,MATTRACT
          GLBL    WON,FALSE
          GLBL    NEWGAME
          GLBL    GOD
          GLBL    STATEND,STATDIE,GLCONT21
          GLBL    THRWTIME
          GLBL    DRIPTIME
          GLBL    ASET

          RAMDEF                         ; ZERO PAGE

          RSEG    CODE1

ATTRACT   LDA     STATUS                 ; IF THIS IS A DEATH WAIT LOOP,
          CMP     #STATEND               ; THEN DON'T CHECK CONTROLLERS
          BEQ     DOAUTO

          LDA     NUMCYCLE               ; MAKE SURE THAT TIMERS ARE STILL
          CMP     #1                     ;  BASED ON REAL (INTERRUPT) TIME
          BNE     ASKIPINC

          INC     CYCLECNT               ; MAKE SURE THIS IS ONLY ONCE
                                         ;   PER FRAME
          DEC     DRIPTIME               ; ICE CREAM CONE TIMER FOR ANIMATION

          DEC     SYSCOUNT               ; GENERAL PURPOSE SYSTEM COUNTER

          LDA     CYCLECNT               update FINFO every odd frame
          LSR     A
          BCC     ATTCONTZ
          DEC     FINFO
ASKIPINC  JMP     DOAUTO

ATTCONTZ  LSR     A                      update direction and button every
                                         ;fourth frame
          BCS     ASKIPINC                a jump -- not a fourth frame

; ONCE WE REACH HERE, EVERYTHING THAT FOLLOWS IS BEING EXECUTED ONCE
;         EVERY TWO FRAMES, REGARDLESS OF "MAXCYCLE"

ATTCONT0  LDA     STATUS                 ; IF HIS EYES ARE ROLLING
          CMP     #STATDIE
          BPL     DOAUTO                 jump-- he's dying

ATTCONT1  LDA     GAMECNT                use IR tables if its not the first
          BEQ     ATTCONT2               game, and at least one rack is
          LDA     ASET                   completed
;         BEQ     ATTCONT2
          BNE     USEIR                  a jump

ATTCONT2  LDA     #6                     just make him go left, if no tables
          STA     JOYDIR
          STA     CDIR
          BNE     DOAUTO                 jump

USEIR     JSR     REPLAY                 ; IN "MAIN.S"

; ONLY INCREMENT "CYCLEIDX" AND "THROWIDX" FOR CYCLES
;         DURING WHICH CONTROLLERS ARE POLLED

          INC     CYCLEIDX               each table is $80 values of CYCLEIDX
          BPL     ZATT001
          INC     CYCLEIDX+1             ; GO TO NEXT BLOCK OF STORAGE
          LDX     #0
          STX     CYCLEIDX

ZATT001   LDA     CYCLEIDX
          AND     #$07
          BNE     DOAUTO
          INC     THROWIDX               ; INCREMENT EVERY 8 TIMES

; TEST FOR THROW, RESET, AND SELECT BUTTONS BEFORE EXECUTING THE GAME
;         DRIVER CODE.
;  ADDED: TEST THE JOYSTICK: IF "HJOYDIR != CENTER" THEN GO TO LOGO MODE

DOAUTO    LDX     HTHROW                 ; SEE IF WE SHOULD START A GAME
          BEQ     DOAUTO1

          LDX     THREADY
          BEQ     DOAUTO1

          INX                            will be TRUE ($FF) if we get here
          STX     THREADY

          BEQ     NGJSR                  a jump

; ELSE, TEST FOR THE RESET BUTTON:

DOAUTO1   LDA     FPRESET                ; IF RESET BUTTON IS PUSHED, NEW GAME
          BEQ     DOAUTO2

          LDA     RESREADY               ; MUST BE READY ALSO !
          BEQ     DOAUTO2

          STX     RESREADY               X=0, the value of FALSE

NGJSR     JMP     NEWGAME                ; BUTTON WAS JUST PUSHED
;         ENDCYCLE

DOAUTO2   LDA     FPSELECT               ; TEST THE SELECT BUTTON
          BEQ     DOAUTO3

          LDA     SELREADY
;         BEQ     DOAUTO3
          BNE     MKLJMP                 ; BACK TO THE MENU
                                         ; a jump
DOAUTO3   LDA     HJOYDIR                ; IF THE JOYSTICK HAS BEEN TOUCHED
          CMP     #08
          BEQ     DOAUTO4

MKLJMP    JMP     MKLOGO                 ; GO TO THE MENU

; SAME AS AT THE BEGINNING OF "GAME"; HANDLES THE WAIT LOOPS AT THE END OF THE
;         RACK

DOAUTO4   LDA     STATUS
          CMP     #STATEND
;         BEQ     ATTCONTA
          BNE     AUTOON                 a jump

ATTCONTA  DEC     WAITCNT                ; IF WAITCNT HAS REACHED 0,
          BNE     ATTCONTB
          JMP     GLCONT21               ; TIME TO COMPLETE WAIT

ATTCONTB  ENDCYCLE

AUTOON    JMP     DOGAME                 ; IN "MAIN.S"

; THIS ROUTINE INITIATES THE ATTRACT MODE.  IT CALLS ALL THE SAME
;         CODE AS "NEWRACK".

MKAUTO    LDA     #MATTRACT
          STA     MODE

          NEWSTATE  ATTRACT

;         DMAOFF                         turn off while loading

          LDA     GAMECNT                ; IF USING THE LAST IR, DON'T RESET
          BNE     MKAUTO1                ;   GAME VARIABLES

          JSR     GAMEINIT               ; SETS APPROPRIATE VARIABLES
MKAUTO1   JSR     AWOLDRAW               ; DRAWS THE PLAYFIELD WALLS

          LDA     #FALSE
          STA     DOITOVER               ; SO THAT "RACKINIT" WILL DO IT

          LDA     #WON
          STA     CSTATE

          JMP     NEWRACK                same as JSR followed by RTS
                                         ; turns DMA back on

          END

