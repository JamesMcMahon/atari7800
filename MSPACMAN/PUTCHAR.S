
*  PUTCHAR.S      THIS PROVIDES ROUTINES FOR MODIFYING THE SCREEN

*  THIS ROUTINE PUTS UP A SET OF CHARACTERS IN A BLOCK ON THE SCREEN.  IT'S
*  PARAMETERS ARE:
*         TEMP0   THE NUMBER OF LINES TO BE CHANGED
*         TEMP1   THE NUMBER OF COLUMNS TO BE CHANGED
*         TEMP2   WHAT CHARACTER IN THE FONT TO START WITH (THIS IS INCREMENTED)
*         TEMP3   WHAT ZONE THE MODIFICATION STARTS IN
*         TEMP4   WHAT COLUMN IN THE ZONE IT STARTS IN
*         TEMP5, 6, AND 7 ARE USED FOR INTERNAL USE
PUTCHARS  LDA     #$01
          STA     TEMP5
          JMP     PCHAR


*  THIS ROUTINE IS THE SAME AS PUTCHARS, BUT THE CHARACTER USED FOR MODIFICATION
*  DOES NOT CHANGE.
PUTCHAR   LDA     #$00
          STA     TEMP5
          JMP     PCHAR


*  THIS ROUTINE DOES THE WORK FOR PUTCHARS AND PUTCHAR
PCHAR     LDX     TEMP3                  ;THE ZONE
          LDA     SCRLOW,X               ;LOW BYTE OF ADDRESS FOR ZONE
          STA     TEMP6                  ;TEMP LOCATION
          LDA     SCRHI,X                ;HI BYTE OF ADDRESS FOR ZONE
          STA     TEMP7

          LDX     TEMP1                  ;NUMBER OF COLUMNS
          LDY     TEMP4                  ;STARTING COLUMN
PLOOP     LDA     TEMP2                  ;STARTING CHAR
          STA     (TEMP6),Y
          LDA     TEMP5                  ;SEE IF STARTING CHAR IS INCREMENTED
          BEQ     PJMP0
          INC     TEMP2                  ;NEXT CHAR
PJMP0     INY
          DEX
          BNE     PLOOP

          INC     TEMP3                  ;NEXT ZONE
          DEC     TEMP0                  ;ONE LESS LINE
          BNE     PCHAR                  ;DO IT AGAIN IF MORE LINES
          RTS


*  THIS ROUTINE PUTS A SINGLE CHARACTER INTO A SINGLE PLACE ON THE SCREEN.
*  PARAMETERS:
*         TEMP0   ZONE
*         TEMP1   COLUMN
*         X       CHARACTER
*  TEMP2-3 ARE USED.
PLOPCHAR  STY     TEMP23
          LDY     TEMP0                  ;THE ZONE
          LDA     SCRLOW,Y               ;LOW BYTE OF ADDRESS FOR ZONE
          STA     TEMP2                  ;TEMP LOCATION
          LDA     SCRHI,Y                ;HI BYTE OF ADDRESS FOR ZONE
          STA     TEMP3
          LDY     TEMP1
          TXA
          STA     (TEMP2),Y
          LDY     TEMP23
          RTS


*  THIS RETURNS (IN A) THE CONTENTS OF A CHARACTER.
*  PARAMETERS:  TEMP0 - ZONE, TEMP1 - COL
*  TEMPS:  TEMP2-3
GETCHAR   STY     TEMP23
          LDY     TEMP0                  ;THE ZONE
          LDA     SCRLOW,Y               ;LOW BYTE OF ADDRESS FOR ZONE
          STA     TEMP2                  ;TEMP LOCATION
          LDA     SCRHI,Y                ;HI BYTE OF ADDRESS FOR ZONE
          STA     TEMP3

          LDY     TEMP1                  ;STARTING COLUMN
          LDA     (TEMP2),Y
          LDY     TEMP23
          RTS


*  THIS ROUTINE ADDS THE ACCUMULATOR TO THE PRESENT SCORE.  NOTE THAT THE
*  ACCUMULATOR SHOULD HAVE A DECIMAL NUMBER, THIS WILL BE MULTIPLIED BY 10
*  TEMP 8-12 ARE USED.  REGISTERS ARE PRESERVED.  TEMP 6-7 ARE USED BY WRTSCORE
*  IF ADDTOTAL IS CALLED, THE USER SETS UP TEMP11-12 TO THE ADDED SCORE
ADDSCORE  STA     TEMP12
          LDA     #$00
          STA     TEMP11
ADDTOTAL  TXA                            ;STACK REGISTERS
          PHA
          TYA
          PHA

          LDA     #$00                   ;CLEAR TOP TWO BYTES OF ADDED VALUE
          STA     TEMP9
          STA     TEMP10
          LDX     AUTOPLAY
          BNE     ADSOUT
          LDY     PLAYER                 ;SEE WHICH PLAYER IS ACTIVE
          BNE     ADSP2

          LDY     #$03
          SED                            ;DECIMAL MODE ON
          CLC
ADS1LOOP  LDA     TEMP9,Y
          ADC     P1SCORE,Y
          STA     P1SCORE,Y
          LDA     #$00
          DEY
          BPL     ADS1LOOP
          CLD                            ;DECIMAL MODE OFF
          JSR     CHKSCOR1
          JMP     ADSOUT

ADSP2     LDY     #$03
          SED                            ;DECIMAL MODE ON
          CLC
ADS2LOOP  LDA     TEMP9,Y
          ADC     P2SCORE,Y
          STA     P2SCORE,Y
          LDA     #$00
          DEY
          BPL     ADS2LOOP
          CLD                            ;DECIMAL MODE OFF
          JSR     CHKSCOR2

ADSOUT    JSR     WRTSCORE
          PLA                            ;UNSTACK REGISTERS
          TAY
          PLA
          TAX
          RTS


*  THIS ROUTINE CHECKS TO SEE IF PLAYER 1 HAS A BONUS LIFE COMING
CHKSCOR1  LDA     P1BONUS                ;MAKE SURE BONUS IS ENABLED
          BMI     CKS1OUT
          SED
          SEC                            ;DECIMAL MODE ON
          LDA     P1BONUS+1
          SBC     TEMP12
          STA     P1BONUS+1
          LDA     P1BONUS
          SBC     TEMP11
          STA     P1BONUS
          CLD                            ;DECIMAL MODE OFF
          LDA     P1BONUS                ;COMPENSATE FOR 6502 BUG
          BPL     CKS1OUT
          JSR     INCLIVES
CKS1OUT   RTS


*  THIS ROUTINE CHECKS TO SEE IF PLAYER 2 HAS A BONUS LIFE COMING
CHKSCOR2  LDA     P2BONUS                ;MAKE SURE BONUS IS ENABLED
          BMI     CKS2OUT
          SED
          SEC                            ;DECIMAL MODE ON
          LDA     P2BONUS+1
          SBC     TEMP12
          STA     P2BONUS+1
          LDA     P2BONUS
          SBC     TEMP11
          STA     P2BONUS
          CLD                            ;DECIMAL MODE OFF
          LDA     P2BONUS                ;COMPENSATE FOR 6502 BUG
          BPL     CKS2OUT
          JSR     INCLIVES
CKS2OUT   RTS


*  THIS ROUTINE INITIALIZES THE LIVES
INITLIV   LDA     #$04
          STA     LIVES
          STA     TOTLIVES
          LDX     TWOPLAYR
          BEQ     ILOUT
          STA     BAKLIVES               ;FOR THE OTHER PLAYER
          LDA     #$09
          STA     TOTLIVES
ILOUT     RTS


*  THIS ROUTINE DECREMENTS THE LIVES.
DECLIVES  LDA     AUTOPLAY
          BNE     DECALT
          JSR     CLEARTUN
          JSR     WAIT
          DEC     LIVES
          JSR     WRTLIVES
          LDA     LIVES
          BPL     DLCONT
          JSR     OVER                   ;PUT GAME OVER UP
          JSR     WAIT
          JSR     WCLEAR
DLCONT    DEC     TOTLIVES
          BMI     DLDEAD
          LDA     TWOPLAYR
          BNE     DLSWITCH
          JSR     LIFEINIT
DLREADY   JSR     READY                  ;PUT PLAYER READY UP
          JSR     WAIT
          JMP     WCLEAR
DLSWITCH  JSR     OTHRINIT               ;SWITCH TO OTHER PLAYER
          JMP     DLREADY
DLDEAD    LDA     #$01                   ;GAME OVER
          STA     GAMEOVER
          RTS
DECALT    JMP     NEXTRACK               ;IF AUTOPLAY - SWITCH RACKS INSTEAD


*  THIS ROUTINE INCREMENTS THE LIVES.
INCLIVES  INC     LIVES
          INC     TOTLIVES
          LDA     #$14
          JSR     DOTUNE
          JMP     WRTLIVES


*  THIS ROUTINE WRITES THE SCORES OF THE PLAYERS ON THE SCREEN
*  TEMPS 6-7 AND 10 ARE USED
*  NOTE:  SCORE+1 IS USED SINCE THE HI BYTE IS ONLY MAINTAINED FOR THE HIGH
*         SCORE CART
WRTSCORE  LDX     #$1E
          LDA     SCRLOW,X               ;LOW BYTE OF ADDRESS FOR ZONE
          STA     TEMP6                  ;TEMP LOCATION
          LDA     SCRHI,X                ;HI BYTE OF ADDRESS FOR ZONE
          STA     TEMP7                  ;NOW - ZONE LINE IS SET UP
          LDY     #P1SCRCOL              ;STARTING COLUMN

          LDX     PLAYER
          LDA     NUMCHAR,X
          STA     TEMP10                 ;SET STARTING CHARACTER FOR ZERO
          LDX     #$00

WRSALOOP  LDA     P1SCORE+1,X            ;ELIMINATE LEADING ZEROS
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          BNE     WRS1JMP0
          JSR     WRTBLANK
          LDA     P1SCORE+1,X
          AND     #$0F
          BNE     WRS1JMP1
          JSR     WRTBLANK
          INX
          CPX     #$03
          BMI     WRSALOOP
          JMP     WRS1JMP2

WRS1LOOP  LDA     P1SCORE+1,X            ;WRITE SCORE FOR PLAYER 1
          LSR     A
          LSR     A
          LSR     A
          LSR     A
WRS1JMP0  JSR     WRTDIGIT
          LDA     P1SCORE+1,X
          AND     #$0F
WRS1JMP1  JSR     WRTDIGIT
          INX
          CPX     #$03
          BMI     WRS1LOOP

WRS1JMP2  LDA     #$00                   ;TRAILING ZERO
          JSR     WRTDIGIT

WRSB      LDA     TWOPLAYR               ;DON'T DO SECOND IF ONE-PLAYER
          BEQ     WRS2NONE
          LDX     PLAYER
          LDA     NUMCHAR2,X
          STA     TEMP10                 ;SET STARTING CHARACTER FOR ZERO
          LDX     #$00                   ;START WITH HIGH BYTE
          LDY     #P2SCRCOL              ;STARTING COLUMN

WRSBLOOP  LDA     P2SCORE+1,X            ;ELIMINATE LEADING ZEROS
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          BNE     WRS2JMP0
          JSR     WRTBLANK
          LDA     P2SCORE+1,X
          AND     #$0F
          BNE     WRS2JMP1
          JSR     WRTBLANK
          INX
          CPX     #$03
          BMI     WRSBLOOP
          JMP     WRS2JMP2

WRS2LOOP  LDA     P2SCORE+1,X            ;WRITE SCORE FOR PLAYER 2
          LSR     A
          LSR     A
          LSR     A
          LSR     A
WRS2JMP0  JSR     WRTDIGIT
          LDA     P2SCORE+1,X
          AND     #$0F
WRS2JMP1  JSR     WRTDIGIT
          INX
          CPX     #$03
          BMI     WRS2LOOP

WRS2JMP2  LDA     #$00                   ;TRAILING ZERO
          JMP     WRTDIGIT               ;ALL DONE

WRS2NONE  LDY     #P2SCRCOL              ;CLEAR OUT PLAYER 2 (JUST IN CASE)
          LDX     #$06
WRS2NLP   JSR     WRTBLANK
          DEX
          BPL     WRS2NLP
          RTS

*  THIS ROUTINE WRITES A DIGIT (IN THE ACCUMULATOR) TO THE NEXT SPOT ON THE
*  SCREEN (TEMP6).  TEMP10 IS ADDED (TO GIVE OFFSET INTO FONT).
WRTDIGIT  CLC
          ADC     TEMP10
          STA     (TEMP6),Y
          INY
          RTS

*  THIS ROUTINE WRITES A BKANK TO THE NEXT SPOT ON THE SCREEN (TEMP6).
WRTBLANK  LDA     #BLNKCHAR
          STA     (TEMP6),Y
          INY
          RTS


*  THIS ROUTINE WRITES THE LIVES ON THE SCREEN
WRTLIVES  LDA     LIVES                  ;GET NUMBER OF LIVES
          CMP     #$05                   ;MAKE SURE NOT TOO BIG
          BMI     WLJMP0
          LDA     #$05
WLJMP0    ASL     A                      ;TURN IT INTO AN INDEX INTO DLISTS
          ASL     A
          STA     TEMP16

          LDX     #$10                   ;NOW, GO THROUGH THE INDICATORS
WLLOOP    CPX     TEMP16
          BPL     WLBLANK
          LDA     #$28                   ;TURN ON AN INDICATOR
          STA     BDLIST0,X
          LDA     #$2A
          STA     BDLIST1,X
          JMP     WLNEXT
WLBLANK   LDA     #$00                   ;TURN ON A BLANK
          STA     BDLIST0,X
          STA     BDLIST1,X
WLNEXT    DEX                            ;NEXT ONE IS 4 LESS
          DEX
          DEX
          DEX
          BPL     WLLOOP

          RTS


*  FLASH THE POWER DOTS
FLASHDOT  JSR     SETFLSH                ;SET NEXT FLASH

          LDY     RACK
          LDA     EDZONE0,Y
          STA     TEMP0
          LDA     EDCOL0,Y
          STA     TEMP1
          JSR     SWTCHDOT               ;SWITCH ZONE 0 COLUMN 0
          LDA     EDCOL1,Y
          STA     TEMP1
          JSR     SWTCHDOT               ;SWITCH ZONE 0 COLUMN 1
          LDA     EDZONE1,Y
          STA     TEMP0
          JSR     SWTCHDOT               ;SWITCH ZONE 1 COLUMN 1
          LDA     EDCOL0,Y
          STA     TEMP1
          JMP     SWTCHDOT               ;SWITCH ZONE 1 COLUMN 0


*  SWITCH A SINGLE POWER DOT - ZONE AND COL IN TEMP0 AND 1
SWTCHDOT  JSR     GETCHAR
          CMP     #BLNKCHAR
          BEQ     SDOUT
          EOR     #$01
          TAX
          JMP     PLOPCHAR
SDOUT     RTS


*  MAKE THE POWER DOTS WHITE FOR END OF RACK
FINALDOT  LDY     RACK
          LDA     EDZONE0,Y
          STA     TEMP0
          LDA     EDCOL0,Y
          STA     TEMP1
          JSR     ONDOT                  ;TURN ON ZONE 0 COLUMN 0
          LDA     EDCOL1,Y
          STA     TEMP1
          JSR     ONDOT                  ;TURN ON ZONE 0 COLUMN 1
          LDA     EDZONE1,Y
          STA     TEMP0
          JSR     ONDOT                  ;TURN ON ZONE 1 COLUMN 1
          LDA     EDCOL0,Y
          STA     TEMP1
          JMP     ONDOT                  ;TURN ON ZONE 1 COLUMN 0


*  TURN ON SINGLE POWER DOT - ZONE AND COL IN TEMP0 AND 1
ONDOT     JSR     GETCHAR
          AND     #$FE
          TAX
          JMP     PLOPCHAR


*  SET THE NEXT FLASH MOVE
SETFLSH   LDA     RTLOCAL+1
          CLC
          ADC     #WAITFLSH
          STA     FLSHWAIT
          RTS


*  THIS JUST SETS TEMP0 AND TEMP1 TO HAVE THE SCREEN LOCATION FOR ZONE Y
SETSCRN   LDA     SCRLOW,Y               ;LOW BYTE OF ADDRESS FOR ZONE
          STA     TEMP0                  ;TEMP LOCATION
          LDA     SCRHI,Y                ;HI BYTE OF ADDRESS FOR ZONE
          STA     TEMP1
          RTS


*  PUT THE READY MESSAGE UP
READY     JSR     WPLAYR                 ;WRITE THE PLAYER
          LDY     #$21
          JMP     WRTMESG                ;WRITE READY


*  PUT THE GAME OVER MESSAGE UP
OVER      JSR     WPLAYR                 ;WRITE THE PLAYER
ALLOVER   LDY     #$22
          JMP     WRTMESG                ;WRITE GAME OVER


*  PUT A PLAYER UP ON THE SCREEN
WPLAYR    LDA     TWOPLAYR
          BEQ     WPLOUT
          LDA     #OFFSCRN               ;MOVE THE RED GUY AWAY
          STA     HPLIST+1
          STA     DOLIST+1

          LDA     PLAYER                 ;WRITE THE PLAYER
          CLC
          ADC     #$0F
          TAY
          JSR     WRTMESG
WPLOUT    RTS


*  ERASE ALL THE MESSAGES ON THE SCREEN
WCLEAR    JSR     WCSETUP
          LDA     #MESHZONE
          STA     TEMP3                  ;ZONE
          JSR     PUTCHAR
          JSR     WCSETUP
          LDA     #MESLZONE
          STA     TEMP3                  ;ZONE
          JMP     PUTCHAR


*  PREPARE THE TEMPS FOR WCLEAR
WCSETUP   LDA     #$01
          STA     TEMP0                  ;ONE LINE
          LDA     #$0A
          STA     TEMP1                  ;10 COLUMNS
          LDA     #BLNKCHAR
          STA     TEMP2                  ;CHARACTER
          LDA     #MESCOL
          STA     TEMP4                  ;COLUMN
          RTS


*  THIS ROUTINE WRITES ONE OF THE TITLE PAGE MESSAGES ON THE SCREEN
*  INPUT:  MESSAGE IN Y (SMASHES Y)
WRTMESG   STX     TEMP5                  ;SAVE X
          LDA     TMLENGTH,Y             ;SET LENGTH OF MESSAGE
          STA     TEMP4
          LDA     TMZONE,Y               ;SET STARTING ZONE AND COLUMN
          STA     TEMP0
          LDA     TMCOL,Y
          STA     TEMP1
          TYA                            ;TEMP 6 NON ZERO IF MESSAGE $10 OR OVER
          SEC
          SBC     #$13
          STA     TEMP6
          LDA     TMOFFSET,Y             ;SET Y TO OFFSET
          TAY

WMLOOP    LDA     TEMP6
          BPL     WMLJMP0
          LDA     TMESSAGE,Y             ;DO IT
          JMP     WMLJMP1
WMLJMP0   LDA     TMESSAG2,Y             ;DO IT - SECOND BANK OF MESSAGES
WMLJMP1   TAX
          JSR     PLOPCHAR
          INY                            ;NEXT INPUT CHAR
          INC     TEMP1                  ;NEXT OUTPUT CHAR
          DEC     TEMP4                  ;SEE IF DONE
          BPL     WMLOOP

          LDX     TEMP5                  ;RESTORE X
          RTS


*  DATA FOR MESSAGES.  NOTE - MESSAGES OVER $13 COME FROM TMESSAG2, OTHERS COME
*  FROM TMESSAGE.

*  THESE ARE OFFSETS INTO THE MESSAGE TABLE
TMOFFSET  DB      $00,$06,$0C,$12,$18,$22,$36,$3A        ;OFFSETS INTO TMESSAGE
          DB      $42,$52,$62,$72,$82,$92,$A1,$BF
          DB      $B4,$B0,$BB
HSCOFF    DB      $00,$0A,$14,$1E,$28,$32,$3C,$46
          DB      $50,$55,$5A,$5F,$68,$71,$7A,$84
TMLENGTH  DB      $05,$05,$05,$05,$09,$13,$03,$07        ;LENGTH (-1)
          DB      $0F,$0F,$0F,$0F,$0F,$0E,$0E,$09
          DB      $09,$09,$09
          DB      $09,$09,$09,$09,$09,$09,$09,$09
          DB      $04,$04,$04,$08,$08,$08,$09,$09
TMZONE    DB      $0F,$0F,$0F,$0F,$0F,$1C,$0C,$0C        ;ZONE MESSAGE APPEARS
          DB      $02,$03,$04,$05,$06,$16,$18,$0A
          DB      $0A,$0C,$0C
          DB      $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
          DB      $0F,$0F,$0F,$0E,$0E,$0E,$10,$10
TMCOL     DB      $0A,$0A,$0A,$0A,$0A,$04,$08,$08        ;COLUMN FOR MESSAGE
          DB      $06,$06,$06,$06,$06,$06,$06,$09
          DB      $09,$09,$09
          DB      $09,$09,$09,$09,$09,$09,$09,$09
          DB      $04,$04,$04,$0C,$0C,$0C,$09,$09

*  THESE ARE THE MESSAGES FOR THE TITLE PAGE
TMESSAGE  DB      $5F,$69,$66,$6B,$68,$76                ;0 - BLINKY
          DB      $6D,$66,$6B,$68,$76,$50                ;1 - PINKY
          DB      $66,$6B,$68,$76,$50,$50                ;2 - INKY
          DB      $70,$72,$62,$50,$50,$50                ;3 - SUE
          DB      $6A,$70,$50,$6D,$5E,$60,$7A,$6A,$5E,$6B ;4 - MS PAC-MAN
          DB      $60,$6C,$6D,$76,$6F,$66,$64,$65,$71,$00 ;5 - COPYRIGHT
          DB      $5E,$71,$5E,$6F,$66,$00,$55,$5D,$5C,$58 ;    ATARI 1984
          DB      $74,$66,$71,$65                        ;6 - WITH
          DB      $70,$71,$5E,$6F,$6F,$66,$6B,$64        ;7 - STARRING
          DB      $83,$88,$8D,$92,$97,$00,$00,$00        ;8 - LINE 1 - MS PAC LO
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $84,$89,$8E,$93,$98,$9C,$00,$00        ;9 - LINE 2
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $85,$8A,$8F,$94,$99,$9D,$A0,$00        ;A - LINE 3
          DB      $A4,$A7,$AA,$AD,$AF,$A4,$B2,$B3
          DB      $86,$8B,$90,$95,$9A,$9E,$A1,$A3        ;B - LINE 4
          DB      $A5,$A8,$AB,$AE,$95,$B0,$A8,$AB
          DB      $87,$8C,$91,$96,$9B,$9F,$A2,$00        ;C - LINE 5
          DB      $A6,$A9,$AC,$91,$96,$B1,$A9,$AC
          DB      $72,$70,$62,$00,$67,$6C,$76,$70        ;D - USE JOYS
          DB      $71,$66,$60,$68,$00,$71,$6C            ;    TICK TO
          DB      $60,$65,$5E,$6B,$64,$62,$00,$70        ;E - CHANGE S
          DB      $62,$71,$71,$66,$6B,$64,$70            ;    ETTINGS
          DB      $6C,$6B,$62,$00,$6D,$69,$5E,$76,$62,$6F  ;11 - ONE PLAYER
          DB      $00                                      ;10 - PLAYER TWO
          DB      $71,$74,$6C,$00,$6D,$69,$5E,$76,$62,$6F  ;12 - TWO PLAYER
          DB      $00,$6C,$6B,$62                          ;F - PLAYER ONE

TMESSAG2  DB      $71,$62,$61,$61,$76,$00,$5F,$62,$5E,$6F  ;13 - TEDDY BEAR
          DB      $00,$60,$65,$62,$6F,$6F,$66,$62,$70,$00  ;14 -  CHERRIES
          DB      $70,$71,$6F,$5E,$74,$5F,$62,$6F,$6F,$76  ;15 - STRAWBERRY
          DB      $00,$00,$6C,$6F,$5E,$6B,$64,$62,$00,$00  ;16 -   ORANGE
          DB      $00,$6D,$6F,$62,$71,$77,$62,$69,$00,$00  ;17 -  PRETZEL
          DB      $00,$00,$5E,$6D,$6D,$69,$62,$00,$00,$00  ;18 -   APPLE
          DB      $00,$00,$00,$6D,$62,$5E,$6F,$00,$00,$00  ;19 -    PEAR
          DB      $00,$00,$5F,$5E,$6B,$5E,$6B,$5E,$00,$00  ;1A -   BANANA
          DB      $5E,$60,$71,$50,$55                      ;1B - ACT 1
          DB      $5E,$60,$71,$50,$56                      ;1C - ACT 2
          DB      $5E,$60,$71,$50,$57                      ;1D - ACT 3
          DB      $71,$65,$62,$76,$50,$6A,$62,$62,$71      ;1E - THEY MEET
          DB      $71,$65,$62,$50,$60,$65,$5E,$70,$62      ;1F - THE CHASE
          DB      $67,$72,$6B,$66,$6C,$6F,$50,$50,$50      ;20 - JUNIOR
          DB      $00,$00,$6F,$62,$5E,$61,$76,$78,$00,$00  ;21 -   READY
          DB      $64,$5E,$6A,$62,$00,$00,$6C,$73,$62,$6F  ;22 - GAME  OVER


*  START OF DIGITS FOR CURRENT AND NON-CURRENT PLAYERS
NUMCHAR   DB      $54,$46
NUMCHAR2  DB      $46,$54

*  ZONES AND COLUMNS FOR MESSAGES
MESHZONE  EQU     $0A
MESLZONE  EQU     $10
MESCOL    EQU     $09

