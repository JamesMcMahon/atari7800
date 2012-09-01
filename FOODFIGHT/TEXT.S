; TEXT.S
; THIS ROUTINE HANDLES THE TEXT STRING DISPLAY, AND CONTAINS ALL TABLES
;         NEEDED FOR THE PROMPTS.
;

          GLBL    MTEXT
          GLBL    PROMPT,MKPROMPT

          GLBL    GOD
          GLBL    DLIST6,DLIST5,DLIST7
          GLBL    TXTLIST1,TXTLIST2,TXTLIST3
          GLBL    NULL2
          GLBL    TRUE,FALSE
          GLBL    NEWGAME,MKLOGO
          GLBL    COLORS

          GLBL    FINFO

          GLBL    TEXTTM1,TEXT0,TEXT1,TEXT2,TEXT4,TEXT5,TEXT6
          GLBL    TEXTLEN,TEXTPOS,PPTRL,PPTRH
          GLBL    FSTATE

GOTIME    EQU     $30

          RAMDEF                         ; ZERO PAGE

          RSEG    CODE1

; THE ROUTINE  "MKPROMPT" EXPECTS THE TYPE OF PROMPT IN A.
;         CURRENTLY ALL PROMPTS TAKE UP TWO LINES
;         IT SETS UP THE MODE AND THE TIME COUNT.
;   CURRENTLY, TRY THIS-- DON'T DO AN "RTS" UNTIL THE WAIT IS OVER
;         THIS WAY, I CAN RE-ENTER THE CODE EXACTLY WHERE THIS WAS CALLED.

MKPROMPT  ASL     A                      ; MULTIPLY BY TWO
          TAX                            ; FIND FIRST STRING HERE

          ONSCREEN                       wait until off-screen to hack
          INVBLANK                       display lists

          LDA     TEXTTM1,X
          STA     SYSCOUNT

          LDA     #FALSE
          STA     RUNLOAD                ; NO LOADER !

; ZERO OUT ALL THREE "TXTLIST" STRINGS:

          LDY     #$2A                   ; 13+14+15

T0LP      LDA     #NULL2
          STA     TXTLIST1,Y
          DEY
          BPL     T0LP

          CPX     #4                     ; INSTANT REPLAY MESSAGE
          BNE     TXTDL6

          LDY     LISTSIZE+7

          LDA     #L(TXTLIST3)
          STA     DLIST7,Y

          LDA     #H(TXTLIST3)
          STA     DLIST7+2,Y
          LDA     #$B2                   ; PALETTE 5, WIDTH 14
          STA     DLIST7+3,Y
          LDA     TEXTPOS,X
          STA     DLIST7+4,Y               ; HPOS

          LDA     #0
          STA     DLIST7+6,Y

; STORE PALW LAST OF ALL:
          LDY     LISTSIZE+7
          LDA     #$60
          STA     DLIST7+1,Y

; COPY THE TEXT STRING:

          LDA     PPTRL,X
          STA     LISTPTRA               ; POINTER TO THIS TEXT
          LDA     PPTRH,X
          STA     LISTPTRA+1

          LDY     TEXTLEN,X              ; NUMBER OF CHARACTERS

TXT3LP    LDA     (LISTPTRA),Y
          STA     TXTLIST3,Y
          DEY
          BPL     TXT3LP

          INX

; PUT TEXT IN DLIST6.  THIS WILL NORMALLY BE THE UPPERMOST LINE OF TEXT,
;         THE EXCEPTION BEING THE INSTANT REPLAY MESSAGE, WHICH
;         ALSO USES DLIST7.

TXTDL6    LDY     LISTSIZE+6             ; FIRST STRING DLIST 6

          LDA     #L(TXTLIST1)
          STA     DLIST6,Y

; STORE PALW LAST OF ALL

          LDA     #H(TXTLIST1)
          STA     DLIST6+2,Y
          LDA     #$B3                   ; PALETTE 5, WIDTH 13
          STA     DLIST6+3,Y
          LDA     TEXTPOS,X
          STA     DLIST6+4,Y               ; HPOS

          LDA     #0
          STA     DLIST6+6,Y

; STORE PALW LAST OF ALL, TO PREVENT ON-SCREEN GLITCH:

          LDY     LISTSIZE+6
          LDA     #$60
          STA     DLIST6+1,Y

; COPY THE TEXT STRING:

          LDA     PPTRL,X
          STA     LISTPTRA               ; POINTER TO THIS TEXT
          LDA     PPTRH,X
          STA     LISTPTRA+1

          LDY     TEXTLEN,X              ; NUMBER OF CHARACTERS

TXT1LP    LDA     (LISTPTRA),Y
          STA     TXTLIST1,Y
          DEY
          BPL     TXT1LP

          INX                            ; NEXT TEXT STRING

          LDY     LISTSIZE+5             ; NEXT LOWER DLIST

          LDA     #L(TXTLIST2)
          STA     DLIST5,Y
          LDA     #H(TXTLIST2)
          STA     DLIST5+2,Y
          LDA     #$B1                   ; PALETTE 5, 15 CHARACTER MAXIMUM
          STA     DLIST5+3,Y
          LDA     TEXTPOS,X
          STA     DLIST5+4,Y               ; HPOS

          LDA     #0
          STA     DLIST5+6,Y

; STORE PALW LAST OF ALL:
          LDY     LISTSIZE+5
          LDA     #$60
          STA     DLIST5+1,Y

; COPY THIS TEXT STRING:

          LDY     TEXTLEN,X

          LDA     PPTRL,X
          STA     LISTPTRA
          LDA     PPTRH,X
          STA     LISTPTRA+1

TXT2LP    LDA     (LISTPTRA),Y
          STA     TXTLIST2,Y
          DEY
          BPL     TXT2LP

;  NOTE-- IF THIS MESSAGE IS "PLAYER N", FILL IN THE PLAYER NUMBER

          MOVE    #0,TEMP4               used as an indicator for GAME OVER

          CPX     #1                     ; "EAT THE CONE!"
          BEQ     TXTADDPL
          CPX     #3                     ; "GAME OVER"
          BEQ     TXTGOVER
          CPX     #6
          BNE     TXTCONT0               if equal, an IR message

; If this is the "GAME OVER" message, set up the counters which
;         make the palettes flash.
;   Use the RAM location FINFO, which was being used for the cone timing.

TXTIROVR
          MOVE    #$80,TEMP4             flag for IR message
          MOVE    COLORS+15,TEMP5        start with this color
          JMP     TXTCONT0

TXTGOVER  MOVE    #GOTIME,FINFO
          MOVE    #0,FSTATE
          MOVE    #$40,TEMP4             flag for GAME OVER message

TXTADDPL  LDA     CURRENT                ; 0 OR 1
          ASL     A                      ; 0 OR 2
          CLC
          ADC     #$D8                   ; LOW BYTE FOR DIGIT "1"
          STA     TXTLIST2+7

TXTCONT0  LDA     MODE                   ; KEEP TO RESTORE LATER
          STA     TEMP0

          MOVEWORD  GODPTR,TEMP2           ; SAVE POINTER AS WELL

          LDA     #MTEXT
          STA     MODE

          NEWSTATE  PROMPT

          ENDCYCLE

; THIS ROUTINE JUST WAITS UNTIL IT'S TIME TO GET RID OF THE TEXT.
;         AT THIS TIME, LET THE LOADER RUN AGAIN, THEREBY ERASING
;         THE TEXT AS A SIDE EFFECT OF "MLOADER".  ALSO , RESTORE
;         THE PREVIOUS MODE FROM "TEMP0".
;   FIRST POLL THE RESET AND SELECT BUTTONS TO CHANGE MODES
;
; Addition: If this is the GAME OVER message, then decrement the timer
;         to see if a new palette is due for the message.  FSTATE
;         tells whether the colors are palette 4 or 5.

PROMPT    LDA     FPRESET                ; IF RESET WAS PUSHED, GO TO GAME
          BPL     PRCONT2

          LDA     RESREADY
          BPL     PRCONT2

          LDA     #FALSE                 ; DON'T LET IT GO AGAIN !
          STA     RESREADY

          JMP     NEWGAME                ; START A NEW GAME AND RETURN

PRCONT2   LDA     FPSELECT               ; SELECT SWITCH
          BEQ     PRCONT3                ; IF IT'S NOT PRESSED

          JMP     MKLOGO                 ; START MENU MODE AND RETURN

PRCONT3   LDA     NUMCYCLE               ; ONLY ONCE PER FRAME !
          CMP     #1
          BNE     PCONT00

          DEC     SYSCOUNT
          BNE     PCONT00

; IF WE GET HERE, THE WAIT IS OVER; RESTORE STUFF AND FINALLY DO THE
;         "RTS" TO WHATEVER LOCATION CALLED "MKPROMPT"

          LDA     TEMP0
          STA     MODE

          MOVEWORD   TEMP2,GODPTR

          RTS

; If TEMP4 is non-zero, this is the GAME OVER message.

PCONT00   LDA     TEMP4
          BPL     PCONT10                not IR message

          INC     TEMP5                  actually stored in DLI2

          JMP     PCONT01

PCONT10   ASL     A
          BPL     PCONT01                not GAME OVER either

          DEC     FINFO                  else, this is the GAME OVER message
          BNE     PCONT01

          LDA     FSTATE                 only flash 4 times:
          CMP     #4                     (yellow)->red->yellow->red->yellow
          BPL     PCONT01

          LDX     #$93
          LSR     A
          BCC     PCONT02                time for palette 4, RED

                                         ;time for YELLOW again
          LDX     #$B3

PCONT02
          INC     FSTATE

          LDA     LISTSIZE+6
          CLC
          ADC     #3
          TAY
          TXA
          STA     DLIST6,Y

          LDA     LISTSIZE+5
          CLC
          ADC     #3
          TAY
          TXA
          STA     DLIST5,Y

          LDA     #GOTIME
          STA     FINFO

PCONT01   ENDCYCLE

          END

