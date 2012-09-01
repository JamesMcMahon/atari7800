; SCORE.S
; THIS FILE CONTIANS THE ROUTINES WHICH UPDATE AND DISPLAY THE THREE SCORES--
;         PLAYER 1, HIGH SCORE, AND PLAYER 2.
;   THERE'S NO PLAYER 2 SCORE IF "PLAYNUM" IS FALSE.

; THIS ROUTINE USES A, X AND Y.  THE X REGISTER CONTAINS AN INDEX INTO
;         THE SCORE VALUE TABLES.

          GLBL    ADDSCORE

ADDSCORE  STX     STEMPX                 ; SAVE REGISTERS
          STY     STEMPY

          LDA     DOITOVER               ; NO POINTS IN INSTANT REPLAY !
          BEQ     ZSCONT01
          JMP     SCOREBYE

ZSCONT01  LDA     CURRENT                ; GET OFFSET FROM "PL0SCORE"
          ASL     A                      ;  IN Y
          ASL     A
          TAY

ZSCR010   SED                            ; DECIMAL MODE
          CLC
          LDA     LOSCORE,X              ; LOW TWO DIGITS OF POINTS
          ADC     PL0SCORE+2,Y              ; ADD TO THOUSANDS AND HUNDREDS
          STA     PL0SCORE+2,Y
          LDA     HISCORE,X              ; NEXT TWO DIGITS OF SCORE
          ADC     PL0SCORE+1,Y
          STA     PL0SCORE+1,Y

          LDA     #0
          ADC     PL0SCORE,Y                ; IF THERE'S A CARRY, ADD IT
          STA     PL0SCORE,Y
          CLD                            ; DECIMAL OFF

; CHECK TO SEE IF THIS PLAYER RECEIVES AN EXTRA LIFE

          TYA
          SEC
          SBC     #1
          TAX                            ; STARTING INDEX
          CLC
          ADC     #5
          STA     TEMP6                  ; ENDING INDEX

CKXTRA1   INX
          CPX     TEMP6                  ; COMPARE ALL 4 REGISTERS
          BEQ     ANEXTRA                equal to bonus-- give a life

          LDA     PL0SCORE,X
          CMP     PL0BONUS,X
          BEQ     CKXTRA1                ; MIGHT BE HIGH SCORE
          BCC     PUTSCORE               ; IF HISCORE GREATER, CARRY IS CLEAR

; ELSE TIME FOR AN EXTRA LIFE !

ANEXTRA   LDA     #27
          JSR     TUNIN

          LDX     CURRENT

          INC     PL0LIVES,X
          INC     PLLIVES

          TXA
          PHA
          TYA
          PHA

          JSR     STATDISP               ; DISPLAY THE EXTRA HEAD

          PLA
          TAY
          PLA
          TAX

          LDA     PL0BONUS+1,Y
          CMP     #02
          BEQ     CKX001

          SED                            do this in decimal so that it
                                        ;carries appropriately to millions
          LDA     PL0BONUS+1,Y           ; ELSE, A MULTIPLE OF 100,000
          CLC
          ADC     #$10
          STA     PL0BONUS+1,Y
          LDA     PL0BONUS,Y
          ADC     #0
          STA     PL0BONUS,Y
          CLD

          JMP     PUTSCORE

CKX001    LDA     #$10                    ; AFTER FIRST AWARDING
          STA     PL0BONUS+1,Y
          LDA     #0
          STA     PL0BONUS+2,Y

; PUTSCORE -- THIS ROUTINE PUTS THE SCORE AT "SCORE" INTO "CMAP1"

PUTSCORE
          TYA                            ; 0 OR 4
          ASL     A                      ;CALCULATE OFFSET 0 OR 8
          TAX                            ; INDEX INTO CHARACTER MAPS

          TYA
          CLC                            ;COMPARE VALUE FOR TERMINATION
          ADC     #4
          STA     TEMP5

SCORLOOP  LDA     PL0SCORE,Y                ;GET NEXT BYTE OF SCORE
          LSR     A
          LSR     A
          LSR     A
          LSR     A                      ;GET HIGH NYBBLE
          BNE     PUTHINUM               ;IF NOT ZERO PUT NUMBER FROM HI NYBBLE
          JSR     PUTBLANK               ;IF ZERO PUT IN BLANK
          LDA     PL0SCORE,Y
          AND     #$F                    ;GET LO NYBBLE
          BNE     PUTLONUM               ;IF NOT ZERO PUT NUMBER FROM LO NYBBLE
          JSR     PUTBLANK               ;IF ZERO PUT IN BLANK
          INY
          CPY     TEMP5                  ;4 BYTES OF SCORE
          BMI     SCORLOOP

          LDA     #NUMCHAR               ;PUT UP A ZERO IF NO POINTS YET
          DEX
          JSR     WRTCHAR

SCOREBYE  LDX     STEMPX
          LDY     STEMPY

          RTS                            ; BYE BYE !

** PUTNUMS, ROUTINE TO PUT NUMBERS FROM PLAYERS SCORE INTO CHARACTER MAP **
PUTNUMS
          LDA     PL0SCORE,Y                ;GET NEXT BYTE OF SCORE
          LSR     A
          LSR     A
          LSR     A
          LSR     A                      ;GET HI NYBBLE

** PUTHINUM, ROUTINE TO PUT HIGH BYTE NUMBERS INTO CHARACTER MAP **
PUTHINUM
          ASL     A
          CLC                            ;POINT TO NUMBER IN CHARS
          ADC     #NUMCHAR
          JSR     WRTCHAR                ;WRITE CHAR IN CHARACTER MAP

          LDA     PL0SCORE,Y
          AND     #$F                    ;GET LO NYBBLE

** PUTLONUM, ROUTINE TO PUT LOW BYTE NUMBERS INTO CHARACTER MAP **
PUTLONUM
          ASL     A
          CLC                            ;POINT TO NUMBER IN CHARS
          ADC     #NUMCHAR
          JSR     WRTCHAR                ;WRITE CHAR IN CHARACTER MAP

          INY
          CPY     TEMP5                  ;4 BYTE OF SCORE DATA
          BMI     PUTNUMS

          JMP     SCOREBYE

** PUTBLANK, ROUTINE TO PUT A BLANK SPACE INTO NEXT POS IN CMAP1 **

PUTBLANK
          LDA     #NULL2

; ACC MUST BE LOW BYTE OF CHARACTER

WRTCHAR
          STA     CMAP1,X                 ;PUT CHAR IN CHARACTER MAP
          INX
          RTS

