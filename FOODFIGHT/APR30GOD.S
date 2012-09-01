; GOD.S
; THIS ROUTINE IS THE MAIN GAME LOOP, JUMPED TO FROM "MAIN" RIGHT
;         AFTER ALL THE POWERUP INITIALIZATION IS DONE.  IT
;         TESTS THE "MODE" VARIABLE AND DECIDES WHICH MINOR GOD OR
;         GODDESS ROUTINE TO JUMP TO ACCORDINGLY.  ALL OF THESE ROUTINES
;         RETURN TO GOD (ENDCYCLE)

          GLBL    GOD

          GLBL    GAME
          GLBL    LOGO
          GLBL    ATTRACT
          GLBL    HISCORE
          GLBL    ENDGAME
          GLBL    ENTER
          GLBL    PAUSE
          GLBL    PROMPT
          GLBL    SELECT
          GLBL    POLLALL

          GLBL    MGAME,MLOGO,MATTRACT,MHISCORE,MENDGAME,MENTER
          GLBL    MPAUSE,MBLANK,MTEXT,MSELECT

          GLBL    TRUE,FALSE
          GLBL    DIEWAIT

          GLBL    MNODMA,M160X2
          GLBL    DLLRAM

          GLBL    DLI1,DLI4

          GLBL    JOYTABLE

          GLBL    MLOADER

          RAMDEF                         ; ZERO PAGE

          RSEG    CODE1

; God's gonna change !
;         All the polling is here now, instead of in DLI4.
;         Also, code dispatching is handled via an indirect jump
;         through GODPTR.  All routines which set MODE must
;         now set GODPTR as well.

GOD       LDA     MODE
          CMP     #MBLANK
          BEQ     GOGOD

          LDA     NUMCYCLE
          CMP     MAXCYCLE
          BMI     GOGOD

          LDA     FRAMECNT
          CMP     OLDFCNT
          BEQ     GOD

          STA     OLDFCNT

          LDA     #0
          STA     NUMCYCLE

; At this point, it's time to go-- do the polling, then do the
;         jmp indirect
;     Note that this jump takes less cycles than the old way, even if
;         the first mode test failed and JMP  GAME was executed.

GOGOD     INC     NUMCYCLE

; Poll all of the controllers

          JSR     POLLALL

*********
          JMP     (GODPTR)
*********

; All these routines end with ENDCYCLE which does JMP GOD

BLANK
          LDA     HJOYDIR
          CMP     #8
          BNE     BLANK00                Turn on DMA

          LDA     FPPAUSE                If pause is pressed, restart the game
          BNE     B001

; If any fp switch, or the button, is touched, turn dma back on, but don't
;         restart gameplay.

          LDA     SWCHB                  If no switches are pressed, value
          CMP     #$3F                   will be $3f
          BNE     BLANK00

          BEQ     JMPGOD                 substitute for JMP

; AT THIS POINT, WE KNOW PAUSE HAS BEEN PRESSED AGAIN.  RESTORE DMA AND
;         MAKE THE GAME START AGAIN--

B001      JSR     TURNON

          JMP     BLANK01                ; SETUP FOR DMA TO OCCUR

; I'LL GET HERE IF 1) THE JOYSTICK IS NOT CENTERED
;         2) ANY FRONT PANEL SWITCH IS PRESSED

BLANK00   LDA     #00                    ; IF JOYSTICK IS CENTERED AND PAUSE
          STA     SYSCOUNT               ; WAS NOT PRESSED AGAIN, COME HERE
          STA     SYSCOUNT+1

          LDA     #MPAUSE
          STA     MODE

          NEWSTATE  PAUSE

BLANK01   LDA     #L(DLI1)               ; Turn DMA on
          STA     DLIADR
          LDA     #H(DLI1)
          STA     DLIADR+1

          DMAON

JMPGOD    ENDCYCLE

PAUSE     LDA     SYSCOUNT
          SEC
          SBC     #1
          STA     SYSCOUNT
          LDA     SYSCOUNT+1
          SBC     #0
          STA     SYSCOUNT+1

          BNE     PAUSE00

          LDA     SYSCOUNT
          BNE     PAUSE00

; AT THIS POINT, 18 MINUTES HAVE PASSED. TURN THE VIDEO OFF BY CHANGING THE
;         MODE TO "MBLANK"

          LDA     #MNODMA                 ; TURN OFF DMA
          STA     CTRL

          LDA     #MBLANK
          STA     MODE

          NEWSTATE  BLANK

JMPGOD1   JMP     GOD

PAUSE00   LDA     FPPAUSE
          BEQ     JMPGOD1

          LDA     PSREADY
          BEQ     JMPGOD1                ; IF SWITCH HAS NOT BEEN TURNED OFF

; IF THE CODE REACHES THIS POINT, THE PAUSE BUTTON HAS BEEN PUSHED.  GO
;         BACK TO GAMEPLAY:

          JSR     TURNON                 back to game

          ENDCYCLE

TURNON    LDA     #MGAME
          STA     MODE

          NEWSTATE  GAME

          LDA     #FALSE
          STA     PSREADY

          RTS

********************

; Poll all the registers:

POLLALL   LDY     #TRUE

          LDX     CURRENT
          LDA     INPT4,X                ; GET PLAYER 0 OR 1 BUTTON
          BPL     SETBUTTN

          STY     THREADY

          INY                            from $ff to 0
SETBUTTN  STY     HTHROW                 ; BUTTON IS DOWN

          LDA     SWCHA
          LDY     CURRENT
          BNE     READPL2

          LSR     A
          LSR     A
          LSR     A
          LSR     A
          BNE     WRTJOY                 jump (can't be 0)

READPL2   AND     #$0F

WRTJOY    TAX
          LDA     JOYTABLE,X             ; USE UPPER NIBBLE AS TABLE INDEX

          STA     HJOYDIR

; Now poll the front panel switches.

; Reset switch first:

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

          RTS

          END

