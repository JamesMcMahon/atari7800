; LOGO.S
; THIS FILE CONTAINS THE ROUTINE FOR STARTING UP THE LOGO, "MKLOGO"
;         AND ALSO THE LOOP WHICH POLES THE FIRE BUTTON TO SEE IF
;         I SHOULD JUMP INTO STATPLAY AGAIN.

          GLBL    LOGO
          GLBL    DRAWLOGO
          GLBL    MKHISCOR               ; IN "HISCORE.S"
          GLBL    MKAUTO
          GLBL    CLEARALL

          GLBL    POLLALL

          GLBL    DWORDL,DWORDH,DWORDLEN         ; USED IN "HISCORE"

MKLOGO    LDA     #FALSE                 ; NO MLOADER IN LOGO MODE
          STA     RUNLOAD
          STA     SELREADY

          LDX     #$FF                   ; RESET STACK POINTER
          TXS

          LDA     #STATLOGO
          STA     STATUS

          LDA     #MLOGO
          STA     MODE

          NEWSTATE  LOGO

          INX                            ; MAKE SURE PLAYER 0 JOYSTICK IS USED
          STX     CURRENT

          STX     SCORELST+1
          STX     STATLIST+1

          STX     NUMCYCLE
          INX
          STX     MAXCYCLE

          INX                            now is 2
          STX     SYSCOUNT+1

          LDA     #$58                   ; STAY HERE FOR 10 SECONDS
          STA     SYSCOUNT

          ONSCREEN                       wait for onscreen, then
          INVBLANK                         off screen

          JSR     DRAWLOGO               ; SET UP THE LOGO ITSELF

          LDA     #$19                   ; COLORS FOR TEXT
          STA     COLORS+20              palette 5
          LDA     #$15
          STA     COLORS+21
          LDA     #$1F
          STA     COLORS+22

          LDA     #8                     ; LOGO DLISTS-- EACH WITH TWO ENTRIES
          STA     LISTSTRT+8
          STA     LISTSTRT+9

; NOW, SET UP THE HEADERS USED BY MENU SELECT.  THESE (FOR NOW) ARE IN
;         DLIST3 (DIFFICULTY) AND DLIST4 (PLAYNUM)
;   NOTE: ALSO THERE IS THE COPYRIGHT MESSAGE

; PUT BLANKS IN THE CHARACTER MAPS:
;         (ALL THREE, LENGTHS 13,14, AND 15)

          LDX     #$2A
          LDA     #NULL2
MKLOLP0   STA     TXTLIST1,X
          DEX
          BNE     MKLOLP0

          LDA     #L(TXTLIST1)           ; COPYRIGHT, CENTERED AT BOTTOM
          STA     DLIST0
          LDA     #$60
          STA     DLIST0+1
          LDA     #H(TXTLIST1)
          STA     DLIST0+2
          LDA     #$B3                   ; PALETTE 5, 13 LENGTH
          STA     DLIST0+3

          LDA     #$20
          STA     DLIST0+4

          LDX     #11

LCOPYLP   LDA     COPYTXT,X
          STA     TXTLIST1,X
          DEX
          BPL     LCOPYLP

          LDA     #L(TXTLIST2)
          STA     DLIST3
          LDA     #$60
          STA     DLIST3+1
          LDA     #H(TXTLIST2)
          STA     DLIST3+2
          LDA     #$B4                   ; 12 CHARACTERS; PALETTE 5
          STA     DLIST3+3

          LDX     HOWHARD
          LDA     DWORDPOS,X             ; HPOS
          STA     DLIST3+4

          LDA     DWORDL,X               ; COPY WORD INTO "TXTLIST2"
          STA     TEMP0
          LDA     DWORDH,X               use stack for indirect
          STA     TEMP1

          LDY     DWORDLEN,X

LDIFFLP   LDA     (TEMP0),Y
          STA     TXTLIST2,Y
          DEY
          BPL     LDIFFLP

; NUMBER OF PLAYERS WILL SWITCH BETWEEN DLIST2 AND DLIST4.  SETUP
;         EVERYTHING THE SAME EXCEPT FOR THE SECOND BYTE.

          LDA     #$60
          LDX     PLAYNUM
          BEQ     LCOPYLP1               ; IF ONE PLAYER

          STA     DLIST4+1               ; IF TWO PLAYER
          LDA     #0
          STA     DLIST2+1               playnum must be 1
          BEQ     LCOPYLP2               jump

LCOPYLP1  STA     DLIST2+1
          STX     DLIST4+1               x is 0

LCOPYLP2  LDA     #L(TXTLIST3)
          STA     DLIST2                 ; "ONE PLAYER" IN "DLIST2"
          STA     DLIST4

          LDY     #2
LLOOP22   LDA     LLTABLE,Y              this loop stores to this header
          STA     DLIST2+2,Y             the values #H(txtlist3),#$b4,#$28
          STA     DLIST4+2,Y
          DEY
          BPL     LLOOP22

;                                        PLAYNUM is in X
AALOGO
          LDA     PWORDL,X               ; PLACE IN "TXTLIST3"
          STA     TEMP0
          LDA     PWORDH,X
          STA     TEMP1

          LDY     #9

LPLAYLP   LDA     (TEMP0),Y
          STA     TXTLIST3,Y
          DEY
          BPL     LPLAYLP

          INY                            FALSE is 0
          STY     DOITOVER

          LDA     #30                    ; DE-BOUNCE BEFORE FIRST SWITCH
          STA     THRWTIME

          JSR     SCRAPALL

;         JSR     DPPINIT                ; TURN DMA ON

          ENDCYCLE

; THIS WILL ALSO BE CALLED FROM "HISCORE.S"

DRAWLOGO  LDA     #$37                   ; PROPER COLORS FOR PALETTE 6
          STA     COLORS+24
          LDA     #$35
          STA     COLORS+25
          LDA     #$33
          STA     COLORS+26

          JSR     CLRSTRCT
          JSR     CLEARALL               ; SIMILAR TO "CLRSCRN" BUT MORE SO

          LDA     #LOGOTOP1
          STA     FSTAMP

          LDA     #LOGOTOP2
          STA     FSTAMP+1

          LDA     #LOGOBOT1
          STA     FSTAMP+2

          LDA     #LOGOBOT2
          STA     FSTAMP+3

          LDA     #159                   ; TOP OF ZONE 9
          STA     FYPOS
          STA     FYPOS+1

          LDA     #143
          STA     FYPOS+2                ; TOP OF ZONE 8
          STA     FYPOS+3

          LDA     #BLOCK2
          STA     FHSTAMP
          STA     FHSTAMP+1
          STA     FHSTAMP+2
          STA     FHSTAMP+3

          LDA     #LOGOPW1
          STA     FPALW
          STA     FPALW+2                ; LEFT HALVES

          LDA     #LOGOPW2
          STA     FPALW+1
          STA     FPALW+3                ; RIGHT HALVES

          LDA     #24
          STA     FXPOS
          STA     FXPOS+2                ; LEFT HALVES

          LDA     #88
          STA     FXPOS+1
          STA     FXPOS+3                ; RIGHT HALVES

          JMP     FLOADER                ; LOAD INTO PROPER DLISTS
                                         ; same as JSR followed by RTS
; GOD COMES HERE DURING TITLE PAGE

LOGO      LDA     HTHROW                 ; ACTUAL CONTROLLER VALUE
;         BPL     LOGCONT0              ; IF "THROWBUT == FALSE"
          BMI     NEWGAME1                ; ELSE, BUTTON IS DOWN: START GAME

LOGCONT0   LDX     FPRESET                ; IF RESET WAS PUSHED, GO TO GAME
          BPL     LOGCONT2


          INX                            from $ff to 0
          STX     RESREADY               "false"

NEWGAME1  JMP     NEWGAME

; DO THE GAME OPTION SELECT BY POLLING THE JOYSTICK:
;         NOTE: ALSO POLL THE SELECT SWITCH, AT THE SAME DEBOUNCE RATE.

LOGCONT2  LDA     THRWTIME
          BEQ     LSELTEST               ; IF ZERO, STAY HERE WAITING FOR A
          DEC     THRWTIME               ;   BUTTON
          JMP     LOGCONT1

LSELTEST  LDX     FPSELECT               ; SELECT SWITCH
          BEQ     LLTEST                 ; IF IT'S NOT PRESSED

          INX                            from $ff to 0
          STX     SELREADY               "false"

; THERE ARE REALLY 8 "STATES" OR GAME OPTIONS-- 4 DIFFICULTY LEVELS
;         TIMES 2 PLAYNUM VALUES.  THUS THE FOLLOWING LOGIC--

          LDX     HOWHARD
          LDA     PLAYNUM
          BEQ     LSTEST00               ; 1 PLAYER-- FIRST HALF OF TABLES

          TXA                            ; 2 PLAYER
          CLC
          ADC     #4
          TAX

LSTEST00  LDA     SELNUM,X               ; NEW PLAYNUM
          STA     PLAYNUM
          LDA     SELDIFF,X              ; NEW DIFFICULTY
          STA     HOWHARD

          BPL     LLOVER                 ; RESET 10-SECOND TIMER
                                         ;a jump
LLTEST    LDX     PLAYNUM
          LDY     HOWHARD

          LDA     HJOYDIR
          BEQ     LLUP
          CMP     #2
          BEQ     LLRIGHT
          CMP     #4
          BEQ     LLDOWN
          CMP     #6
          BEQ     LLLEFT
          CMP     #8
          BNE     LLOVER                 ; IF NOT CENTERED, RESET SYSCOUNT
          JMP     LOGCONT1               ;  ELSE DECREMENT

LLUP
          LDA     UPNUM,X
          STA     PLAYNUM
          BPL     LLOVER

LLDOWN
          LDA     DOWNNUM,X
          STA     PLAYNUM
          BPL     LLOVER

LLRIGHT
          LDA     RIGHTNUM,Y
          STA     HOWHARD
          BPL     LLOVER

LLLEFT
          LDA     LEFTNUM,Y
          STA     HOWHARD

; IF ANY OPTION IS CHANGED, THE CODE WILL COME HERE. ZERO OUT THE PLAYER
;         SCORES-- AND RESET THE DEBOUNCE COUNTER

LLOVER    LDA     #30
          STA     THRWTIME

          LDX     #3
          LDA     #0
LLSC0LP   STA     PL0SCORE,X
          STA     PL1SCORE,X
          DEX
          BPL     LLSC0LP

          LDA     #2                     ; IF JOYSTICK WAS PUSHED, 10 MORE
          STA     SYSCOUNT+1             ;        SECONDS
          LDA     #$58
          STA     SYSCOUNT

          LDX     #$1C                   ; ZERO OUT DIFFICULTY AND PLAYNUM
          LDA     #NULL2
LLLOOP0   STA     TXTLIST2,X
          DEX
          BPL     LLLOOP0

          LDX     HOWHARD                ; UPDATE DIFFICULTY WORD

          LDA     DWORDL,X               ; COPY WORD INTO "TXTLIST2"
          STA     TEMP0
          LDA     DWORDH,X
          STA     TEMP1

          LDA     DWORDPOS,X
          STA     DLIST3+4               ; HPOS

          LDY     DWORDLEN,X

LLDIFFLP  LDA     (TEMP0),Y
          STA     TXTLIST2,Y
          DEY
          BPL     LLDIFFLP

          LDX     PLAYNUM                ; UPDATE NUMBER OF PLAYERS WORD

AALOGO1
          LDA     PWORDL,X
          STA     TEMP0
          LDA     PWORDH,X               ; PLACE IN "TXTLIST3"
          STA     TEMP1

          LDY     #9

LLPLAYLP  LDA     (TEMP0),Y
          STA     TXTLIST3,Y
          DEY
          BPL     LLPLAYLP

          LDA     #$60                   ; WILL BE PLACED IN THE LUCKY DLIST

          LDX     PLAYNUM                ; PLACE IN PROPER DLIST
          BEQ     LLPLAY01               ; ONE PLAYER

          STA     DLIST4+1               ; FOR TWO PLAYER
          DEX                            playnum must be 1
          STX     DLIST2+1               store 0

LCJMP     JMP     LOGCONT2

LLPLAY01  STA     DLIST2+1
          LDA     #0
          STA     DLIST4+1

          BEQ     LCJMP                  ; SKIP OVER THIS TEST

LOGCONT1  LDX     SELREADY
          BEQ     LOGCONT3               ; STILL UP-- DON'T RESET DEBOUNCE

          LDA     HJOYDIR
          CMP     #8
          BNE     LOGCONT3               ; STILL PUSHED-- DON'T RESET

          INX                            ; MAKE SURE THAT THE FIRST PUSH
          STX     THRWTIME               ;  REGISTERS IMMEDIATELY
                                         ; selready must have been $ff--
                                         ; store 0 to thrwtime

LOGCONT3  LDA     SYSCOUNT               ; DEC TIMER AND TEST
          SEC
          SBC     #1
          STA     SYSCOUNT
          LDA     SYSCOUNT+1
          SBC     #0
          STA     SYSCOUNT+1

          BNE     LOGOBYE

          LDA     SYSCOUNT
          BNE     LOGOBYE

AENDLOGO  LDX     #0                      ; DO ALL FOUR DIFFICULTY LEVELS
AENDLOOP  STX     TEMP4

          JSR     MKHISCOR

          DMAOFF

          JSR     POLLALL                find out if any switches are down

          LDY     #FALSE

          LDA     FPRESET
          BNE     LEAVE1
          LDA     FPSELECT
          BNE     LEAVE2
          LDA     HTHROW
          BNE     LEAVE3
          LDA     HJOYDIR
          CMP     #$08
          BNE     LEAVEIT

          LDX     TEMP4                  POLLALL trashes X

          INX
          CPX     #4
          BMI     AENDLOOP
          JSR     HSCRTN
          JSR     MKAUTO
          ENDCYCLE

LEAVEIT   JSR     HSCRTN
          JSR     MKLOGO

LEAVE1    STY     RESREADY
          JMP     LEAVE

LEAVE2    STY     SELREADY
          BNE     LEAVE                  ; same as JMP

LEAVE3    STY     THREADY

LEAVE     JSR     HSCRTN                 clean-up after HSC is done
          JMP     NEWGAME

LOGOBYE   ENDCYCLE

; USED TO ERASE ALL DLISTS

CLEARALL  ONSCREEN
          INVBLANK

          LDX     #10

ZCLRA00    LDA     LISTTABL,X
          STA     LISTPTR
          LDA     LISTTABH,X
          STA     LISTPTR+1

          LDY     #0
          STY     LISTSTRT,X
          STY     LISTSIZE,X

ZCLRA01    LDA     #0
          STA     (LISTPTR),Y
          INY
          CPY     #LISTLENG                   ; LENGTH OF A DLIST
          BNE     ZCLRA01

          DEX                            ; GO TO NEXT DLIST
          BPL     ZCLRA00

          RTS

LLTABLE   DB      H(TXTLIST3),$B4,$28
