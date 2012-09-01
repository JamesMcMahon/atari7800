; SELECT.S
; THIS FILE CONTAINS "MKSELECT" AND "SELECT"
;         BOTH VERY SIMILAR TO "MKLOGO" AND "LOGO" RESPECTIVELY.

          GLBL    DRAWLOGO
          GLBL    TRUE,FALSE
          GLBL    TEXT1                  ; IN "TEXT.S"
          GLBL    TXTLIST1,TXTLIST2,TXTLIST3,CLOWMAP2
          GLBL    DLIST6,DLIST5,DLIST4,DLIST2
          GLBL    MSELECT
          GLBL    SCORELST,STATLIST
          GLBL    NULL2,DPPINIT,SCRAPALL
          GLBL    THRWTIME,HTHROW,HJOYDIR
          GLBL    THREADY
          GLBL    PLRACK,PLBCD,PL1BCD,PL0BCD,PL0RACK,PL1RACK
          GLBL    PLLIVES,PL0LIVES
          GLBL    MGAME
          GLBL    GAME,GOD
          GLBL    AWOLDRAW,CLRSCRN
          GLBL    FPSELECT,SELREADY,MKLOGO
          GLBL    HIGHEST
          GLBL    STATINIT,STATCOMB,STATPLAY,FPPAUSE,JOYDIR,OLDDIR,DLIST3

          GLBL    SELECT,MKSELECT

          RAMDEF                         ; ZERO PAGE

          RSEG    CODE1

MKSELECT  LDA     #FALSE                 ; NO MLOADER IN LOGO MODE
          STA     RUNLOAD
          STA     TEMP4                  zero out in case this was IR text

          LDA     #MSELECT
          STA     MODE

          NEWSTATE  SELECT

          LDA     #$19                   ; COLORS FOR TEXT
          STA     P5C1
          LDA     #$15
          STA     P5C2
          LDA     #$1F
          STA     P5C3

          LDA     #00                    ; CLEAR OUT ALL CHARACTER MAP INFO
          STA     SCORELST+1
          STA     STATLIST+1

          JSR     DRAWLOGO               ; DRAW THE "FOODFIGHT" LOGO

          LDA     #8                     ; LOGO DLISTS-- EACH WITH TWO ENTRIES
          STA     LISTSTRT+8
          STA     LISTSTRT+9

; SETUP THE HEADERS USED BELOW THE LOGO:
;         "PLAYER N"
;         "SELECT STARTING"
;         "LEVEL"
;         "NNN"

; PUT BLANKS IN THE CHARACTER MAPS:
;         (ALL THREE, LENGTHS 13,14, AND 15)

          LDX     #$2A
          LDA     #NULL2
MKSELP0   STA     TXTLIST1,X
          DEX
          BNE     MKSELP0

; FIRST LINE OF TEXT:

          LDA     #L(TXTLIST2)           ; "SELECT STARTING"
          STA     DLIST6
          LDA     #$60
          STA     DLIST6+1
          LDA     #H(TXTLIST2)
          STA     DLIST6+2
          LDA     #$B1                   ; 15 CHARACTERS; PALETTE 5
          STA     DLIST6+3
          LDA     #$10
          STA     DLIST6+4

          LDA     #0
          STA     DLIST6+6

          LDY     #14
SCOPYLP0  LDA     SELTEXT1,Y             ; "SELECT STARTING"
          STA     TXTLIST2,Y             ; 15 WIDE MAP
          DEY
          BPL     SCOPYLP0

; DO SECOND LINE OF TEXT:

          LDA     #L(TXTLIST3)           ; "LEVEL"
          STA     DLIST5
          LDA     #$60
          STA     DLIST5+1
          LDA     #H(TXTLIST3)
          STA     DLIST5+2
          LDA     #$B4                   ; 12 CHARACTERS; PALETTE 5
          STA     DLIST5+3
          LDA     #$38                   ; HPOS
          STA     DLIST5+4

          LDA     #0
          STA     DLIST5+6

          LDY     #4
SCOPYLP1  LDA     SELTEXT2,Y
          STA     TXTLIST3,Y
          DEY
          BPL     SCOPYLP1

; THIRD LINE OF TEXT:

          LDA     #L(TXTLIST1)           ; "PLAYER N"
          STA     DLIST4
          LDA     #$60
          STA     DLIST4+1
          LDA     #H(TXTLIST1)
          STA     DLIST4+2
          LDA     #$B3                   ; PALETTE 5, 13 LENGTH
          STA     DLIST4+3

          LDA     #$30
          STA     DLIST4+4

; NOW FILL THIS WITH THE TEXT "PLAYER  "

          LDX     #05

SCOPYLP2  LDA     TEXT1,X                ; IN "TEXT.S"
          STA     TXTLIST1,X
          DEX
          BPL     SCOPYLP2

; TACK ON THE PLAYER NUMBER:

          LDA     CURRENT                ; 0 OR 1
          ASL     A                      ; 0 OR 2
          CLC
          ADC     #$D8                   ; LOW BYTE FOR DIGIT "1"
          STA     TXTLIST1+7

; NOW DISPLAY THE STARTING LEVEL OF 1 (ALREADY INITIALIZED TO THIS):

          LDX     #4                     ; FIRST FILL WITH NULL
SCOPYLP4  LDA     #NULL2
          STA     CLOWMAP2,X
          DEX
          BPL     SCOPYLP4

          LDA     #L(CLOWMAP2)
          STA     DLIST2
          LDA     #$60
          STA     DLIST2+1
          LDA     #H(CLOWMAP2)
          STA     DLIST2+2
          LDA     #$BC                   ; WIDTH OF 4
          STA     DLIST2+3
          LDA     #$40
          STA     DLIST2+4

          LDA     #0
          STA     DLIST2+6

          JSR     NEWLEVEL               ; PUTS LEVEL INTO "CLOWMAP2"

          LDA     #30                    ; DE-BOUNCE BEFORE FIRST SWITCH
          STA     THRWTIME
          STA     TEMP2

          LDA     #2
          STA     TEMP1

          LDA     #FALSE
          STA     THREADY

          JSR     SCRAPALL

          JSR     DPPINIT                ; TURN DMA ON

          ENDCYCLE

; THE ROUTINE WHICH DISPLAYS THE RACK NUMBER

SELECT    LDA     STATUS
          CMP     #STATCOMB
          BNE     SELTEST0
          JMP     COMBINE

SELTEST0  LDA     PLRACK
          CMP     #12
          BNE     ITISNT
          LDA     FPPAUSE
          BEQ     ITISNT
          JMP     MKCOMB

ITISNT    LDA     HTHROW
          BPL     SELTEST1

          LDA     THREADY
          BPL     SELTEST1

          JMP     GENDSEL

; SEE IF WE SHOULD GO INTO "LOGO" MODE:

SELTEST1  LDA     FPSELECT
          BPL     SELTEST2

          LDA     SELREADY
          BPL     SELTEST2

          JMP     MKLOGO                 ; HOP INTO LOGO; IT RESETS THE STACK
                                         ;  AND GOES TO "GOD"
; DO THE LEVEL SELECT BY POLLING THE JOYSTICK:

SELTEST2  LDA     THRWTIME               ; JOYSTICK DEBOUNCE
          BEQ     SELTEST3
          DEC     THRWTIME
          JMP     SELCONT1

SELTEST3   LDA     HJOYDIR
          CMP     #8
          BNE     SELTEST4
          JMP     SETTT0                 ; IF 8, NO PUSH AT ALL

SELTEST4  CMP     #7                     ; DON'T LET 7 DECREASE LEVEL
          BEQ     SELOVER
          CMP     #3                     ; INCREASES ON 0,1,2
          BMI     SELRIGHT
          CMP     #4                     ; DECREASES ON 4,5,6
          BPL     SELLEFT

          JMP     SELOVER                ; MUST BE = 3

SELRIGHT  LDX     CURRENT
          LDA     PLRACK
          CMP     HIGHEST,X              ; indexed for each player
          BCS     SELOVER

          INC     PLRACK

; ADD ONE TO THE BCD REPRESENTATION OF THE LEVEL:

          SED
          LDA     PLBCD+1
          CLC
          ADC     #1
          STA     PLBCD+1
          DEX                            ; HIGH ORDER DIGITS
          LDA     PLBCD
          ADC     #0
          STA     PLBCD
          CLD

          JSR     NEWLEVEL

          JMP     SELOVER

SELLEFT
          LDA     PLRACK
          BEQ     SELOVER

          DEC     PLRACK

          SED
          LDA     PLBCD+1
          SEC
          SBC     #1
          STA     PLBCD+1
          LDA     PLBCD
          SBC     #0
          STA     PLBCD
          CLD

          JSR     NEWLEVEL               ; DISPLAYS PLBCD

; COME HERE AFTER A JOYSTICK PUSH HAS BEEN DETECTED-- RESET DEBOUNCE

SELOVER   LDA     TEMP2
          STA     THRWTIME

          DEC     TEMP1
          BMI     SPEEDUP
          ENDCYCLE

SPEEDUP   LDA     #5
          STA     TEMP2

          ENDCYCLE

SELCONT1  LDA     HJOYDIR
          CMP     #8
          BNE     SELBYE

SETTT0    LDA     #0
          STA     THRWTIME

          LDA     #2                     ; FASTER TIMER
          STA     TEMP1

          LDA     #30
          STA     TEMP2

SELBYE    ENDCYCLE

GENDSEL
          LDX     CURRENT
          BEQ     SELCOPY1

          MOVE    PLBCD,PL1BCD
          MOVE    PLBCD+1,PL1BCD+1

          JMP     SELEXIT

SELCOPY1  MOVE    PLBCD,PL0BCD
          MOVE    PLBCD+1,PL0BCD+1

SELEXIT   MOVE    PLRACK,PL0RACK,X

;         SED
          LDA     PLBCD
          BEQ     NO10

          LDA     #10                    10 extra lives for the 100
          CLC
          ADC     PLLIVES
          STA     PLLIVES
          STA     PL0LIVES,X

NO10      LDA     PLBCD+1                now, one for every 10s digit
          LSR     A
          LSR     A
          LSR     A
          LSR     A

          CLC
          ADC     PLLIVES
          STA     PLLIVES
          STA     PL0LIVES,X
;         CLD

          LDA     #MGAME
          STA     MODE

          MOVE    #STATINIT,STATUS

          NEWSTATE  GAME

          JSR     AWOLDRAW               ; PUT WALL BACK
          JSR     CLRSCRN                ; GET RID OF THIS DISPLAY

          RTS                            ; GOES BACK INTO "INIT.S"

NEWLEVEL  LDA     #FALSE                 ; USE THIS TO TELL IF ZEROES ARE
          STA     TEMP0                  ;   DISPLAYED

          LDA     PLBCD                  ; LIVES IN BCD
          BEQ     SBLANK1               ; IF ZERO, PUT A BLANK

          ASL     A                      ; TIMES 2
          ADC     #$D6                   ; DIGIT "1" IS AT $D8
          STA     CLOWMAP2
          LDA     #TRUE
          STA     TEMP0
          JMP     NEWLP1

SBLANK1   LDA     #$2F
          STA     CLOWMAP2

NEWLP1   LDA     PLBCD+1
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          LDX     TEMP0
          BNE     NEWLP2               ; IF "TRUE", DISPLAY IT
          TAY                            ;  TO RESET FLAGS TO "A"
          BNE     NEWLP2                ; IF NOT ZERO, DISPLAY IT

          LDA     #$2F                   ; IF A LEADING ZERO, PUT A BLANK
          STA     CLOWMAP2+1
          JMP     NEWLP3

NEWLP2   ASL     A                      ; TIMES 2
          ADC     #$D6                   ; THE "O" CHARACTER
          STA     CLOWMAP2+1

NEWLP3   LDA     PLBCD+1
          AND     #$F
          ASL     A                      ; TIMES 2
          ADC     #$D6
          STA     CLOWMAP2+2

          RTS

mkcomb    lda     #statcomb
          sta     status
          lda     #0
          sta     temp5

          endcycle

combine   ldx     temp5
          lda     hjoydir
          cmp     olddir
          beq     skip
          sta     olddir
          cmp     #8
          beq     skip

          cmp     nextcomb,x
          beq     cont

          lda     #statplay
          sta     status
skip      endcycle

cont      inc     temp5
          cpx     #7
          bpl     doit
          endcycle

doit      lda     #0                     blank out the text
          sta     dlist5+1
          sta     dlist4+1
          sta     dlist3+1
          endcycle

nextcomb  DB      0,2,4,6,0,2,4,6

SELTEXT1  DB      $CA,$BA,$C4,$BA,$B6,$CC,$2F    ; SELECT
          DB      $CA,$CC,$B8,$C8,$CC,$C2,$BE,$B4        ; STARTING

SELTEXT2  DB      $C4,$BA,$BC,$BA,$C4            ; LEVEL

          END
