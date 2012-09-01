; NSELECT.S
; THIS FILE CONTAINS "MKSELECT" AND "SELECT"
;         BOTH VERY SIMILAR TO "MKLOGO" AND "LOGO" RESPECTIVELY.

          GLBL    XDMAOFF
          GLBL    DRAWLOGO
          GLBL    TRUE,FALSE
          GLBL    TEXT1                  ; IN "TEXT.S"
          GLBL    TXTLIST1,TXTLIST2,TXTLIST3,CLOWMAP2
          GLBL    DLIST6,DLIST5,DLIST4,DLIST2
          GLBL    MSELECT
          GLBL    SCORELST,STATLIST
          GLBL    NULL2,DPPINIT,FOODSTUF,SCRAPALL
          GLBL    THRWTIME
          GLBL    PL1BCD,PL0BCD,PL0RACK,PL1RACK
          GLBL    PL0LIVES,CTEXT1,CTEXT2,CTEXT3,CTEXT4
          GLBL    MGAME
          GLBL    GAME,GOD
          GLBL    AWOLDRAW,CLRSCRN
          GLBL    MKLOGO
          GLBL    STATINIT,STATCOMB,STATPLAY,OLDDIR,DLIST3
          GLBL    COLORS

          GLBL    SELECT,MKSELECT

          GLBL    SELTEXT1,SELTEXT2

          RAMDEF                         ; ZERO PAGE

          RSEG    CODE1

MKSELECT  LDX     #FALSE                 ; NO MLOADER IN LOGO MODE
          STX     RUNLOAD

;         ONSCREEN                       wait until off screen for init
;         INVBLANK

          DMAOFF

          STX     TEMP4                  zero out in case this was IR text
          STX     SCORELST+1             FALSE is 0
          STX     STATLIST+1
; End of all dlists:

          STX     DLIST2+6
          STX     DLIST4+6
          STX     DLIST5+6
          STX     DLIST6+6


          LDA     #MSELECT
          STA     MODE

          NEWSTATE  SELECT

          LDA     #$19                   ; COLORS FOR TEXT
          STA     COLORS+20
          LDA     #$15
          STA     COLORS+21
          LDA     #$1F
          STA     COLORS+22

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

          JSR     CLRMAPS

; FIRST LINE OF TEXT:

          LDY     #4
NSLOOP    LDA     NSTABLE,Y
          STA     DLIST6,Y
          DEY
          BPL     NSLOOP

          LDY     #14
SCOPYLP0  LDA     SELTEXT1,Y             ; "SELECT STARTING"
          STA     TXTLIST2,Y             ; 15 WIDE MAP
          DEY
          BPL     SCOPYLP0

; DO SECOND LINE OF TEXT:

          LDY     #4
NSLOOP1   LDA     NSTABLE1,Y
          STA     DLIST5,Y
          DEY
          BPL     NSLOOP1

          LDY     #4
SCOPYLP1  LDA     SELTEXT2,Y
          STA     TXTLIST3,Y
          DEY
          BPL     SCOPYLP1

; THIRD LINE OF TEXT:

          LDY     #4
NSLOOP2   LDA     NSTABLE2,Y
          STA     DLIST4,Y
          DEY
          BPL     NSLOOP2

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

          LDY     #4
NSLOOP3   LDA     NSTABLE3,Y
          STA     DLIST2,Y
          DEY
          BPL     NSLOOP3

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

SELTEST0  lda     plrack
          cmp     #22
          bne     itisnt
          lda     fppause
          beq     itisnt
          jmp     mkcomb

; If the throw or the reset button is pushed, select this rack and start
;         a new game.

ITISNT    LDA     HTHROW
          BPL     SELTST1

          LDA     THREADY
          BPL     SELTST1

          JMP     GENDSEL

SELTST1   LDA     FPRESET
          BPL     SELTEST1
          LDA     RESREADY
          BPL     SELTEST1

          MOVE    #FALSE,RESREADY

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

SELRIGHT
          LDX     CURRENT
          LDA     PLRACK
          CMP     HIGHEST,X
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

          LDA     PLBCD
          STA     PL1BCD
          LDA     PLBCD+1
          STA     PL1BCD+1

          JMP     SELEXIT

SELCOPY1  LDA     PLBCD
          STA     PL0BCD
          LDA     PLBCD+1
          STA     PL0BCD+1

SELEXIT   LDA     PLRACK
          STA     PL0RACK,X

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
          JMP     CLRSCRN                ; GET RID OF THIS DISPLAY
                                         ; same as JSR and RTS ( to INIT.S)

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
          cpx     #3
          bmi     cont001
          stx     FOODSTUF
cont001   cpx     #7
          bpl     doit
          endcycle

doit
          jsr     clrmaps

          ldy     #00
          sty     dlist4+1

          iny                            to get 1
doitlp1   lda     ctext1,y               by
          sta     txtlist2,y
          dey
          bpl     doitlp1

          ldy     #11
doitlp0   lda     ctext4,y               keith sawyer
          sta     txtlist3,y
          dey
          bpl     doitlp0

          LDA     #L(TXTLIST1)           ; "PLAYER N"
          STA     DLIST3
          LDA     #$60
          STA     DLIST3+1
          LDA     #H(TXTLIST1)
          STA     DLIST3+2

          ldy     #13
doitlp2   lda     ctext2,y               the "alchemist
          sta     txtlist1,y
          dey
          bpl     doitlp2

          ldy     #6
doitlp3   lda     ctext3,y               of fun"
          sta     clowmap2,y
          dey
          bpl     doitlp3

          ldx     #$be                   new widths for character strings
          stx     dlist6+3
          ldx     #$94
          stx     dlist5+3
          ldx     #$b2
          stx     dlist3+3
          ldx     #$b9
          stx     dlist2+3

          lda     #72                    new horizontal positions
          sta     dlist6+4
          lda     #32
          sta     dlist5+4
          lda     #24
          sta     dlist3+4
          lda     #52
          sta     dlist2+4

          endcycle

nextcomb  DB      0,4,2,6,0,4,2,6

CLRMAPS
          LDX     #$2B
          LDA     #NULL2
MKSELP0   STA     TXTLIST1,X
          DEX
          BNE     MKSELP0
          RTS

NSTABLE   DB      L(TXTLIST2),$60,H(TXTLIST2),$B1,$10

NSTABLE1  DB      L(TXTLIST3),$60,H(TXTLIST3),$B4,$38

NSTABLE2  DB      L(TXTLIST1),$60,H(TXTLIST1),$B3,$30

NSTABLE3  DB      L(CLOWMAP2),$60,H(CLOWMAP2),$BC,$40

          END
