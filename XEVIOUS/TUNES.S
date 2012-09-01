*  TUNES
          ZEROPAGE
          TUNEGLBL
          GODGLBL

SHOTTUNE  EQU     0
BOMBTUNE  EQU     1
FLAGTUNE  EQU     2
EIGHTUNE  EQU     3
MAMATUNE  EQU     4
CRUSTUNE  EQU     5
DISNTUNE  EQU     6
DINKTUNE  EQU     7
ESC2TUNE  EQU     8
MAN0TUNE  EQU     9
MAN1TUNE  EQU     $A
XTRATUNE  EQU     $B
XPLOTUNE  EQU     $C
ESCTTUNE  EQU     $D
SUP8TUNE  EQU     $E
HSC0TUNE  EQU     $F
HSC1TUNE  EQU     $10
HSC2TUNE  EQU     $11
*****************************************
RAM2      CSECT
*TUNE RAM STUFF
DCH0      DS      1                      ;DURATION
DCH1      DS      1
TUNNUM    DS      1                      ;TUNE NUMBER
TUNNUM1   DS      1
TINDEX0   DS      1                      ;NOTE POINTER
TINDEX1   DS      1
CINDEX0   DS      1                      ;CONTROL INDEX
CINDEX1   DS      1
VINDEX0   DS      1                      ;VOLUME INDEX
VINDEX1   DS      1


*****************************************
CODE9000  CSECT
ATOPTUNE

* SIMPSONG VERSION 0.035
*
* THIS SIMPLE SOUND DRIVER HAS, IN SOME WAYS, FEWER FEATURES BUT USES LESS RAM
* AND ROM AND DOES NOT BACK UP SOUNDS FOR LATER (SOMETIMES MUCH LATER)
* CONTINUATION. IT FEATURES 256 NOTE TUNES, SINGLE DURATION PER TUNE, ENDLESS
* TUNES. IF A VALUE IN THE CONTROL OR VOLUME TABLES HAS THE HIGH BIT SET, THAT
* VOLUME OR CONTROL WILL REMAIN IN EFFECT TILL THE END OF THE TUNE.
* AN FF IN THE FREQUENCY TABLE WILL TERMINATE THE TUNE, AN FE WILL CAUSE IT TO
* RESTART.  AN FD WILL CALL THE TUNE NUMBER FOLLOWING (IN THE FREQ TABLE).
*
* AS A NEW WHIZZY FEATURE, TUNER ALSO SUPPORTS RESTS. IF BIT 6 IS SET (NOT BIT 7
* ALSO) IN A FREQUENCY TABLE ENTRY, IT SILENCES SOUND IN THAT CHANNEL FOR THE
* NUMBER OF FRAMES INDICATED IN THE REMAINING 5 BITS.
*
* AS AN OLD WHIZZY FEATURE, TUNER ALSO SUPPORTS RUN-LENGTH FREQS.  IF BIT 7
* IS SET IN A FREQUENCY TABLE ENTRY, THE NEXT BYTE INDICATES THE DURATION.(?)
*
* NOTE ALSO THAT IN THIS VERSION A DURATION OF 1 INDICATES CHANGING SOUND EVERY
* FRAME. THIS IS A CHANGE OVER VERSION .03 WHERE 0 INDICATED ONCE PER FRAME
* SAMPLING.
* SUBROUTINES:
*     SCRAPALL -- KILL ALL TUNES. SHOULD BE CALLED AT POWERUP, CHANGING PLAYERS,
*                AND GAME OVER
*
*     SCRAPONE -- KILL A PARTICULAR TUNE. PUT THE NUMBER OF THE TUNE YA WANNA
*                 AXE IN THE ACCUMULATOR.
*
*     TUNIN   --  START THAT TUNE YOU PUT IN ACC.
*
* THE ABOVE ROUTINES PRESERVE THE X AND Y REGS
*
* TABLES NEEDED ARE:
* RAM:
*ZMPTRL     EQU     KTEMP0                 ZERO PAGE TEMP(NOT GAMEPLAY)
*ZMPTRH     EQU     KTEMP1                 ZERO PAGE TEMP(NOT GAMEPLAY)
*TUNTEMP    EQU     TEMP0
* ROM:
*   DURTABL       ONE DURATION IN FRAMES PER TUNE
*   TBASE         LOW ADDRESS OF THE START OF FREQ DATA BY TUNE NUMBER
*   TBASEH        DITTO FOR HIGH ADDRESS
*   VBASE         LOW ADDRESS OF THE START OF VOL DATA BY TUNE NUMBER
*   VBASEH        DITTO FOR HIGH ADDRESS
*   CBASE         LOW ADDRESS OF THE START OF CTRL DATA BY TUNE NUMBER
*   CBASEH        DITTO FOR HIGH ADDRESS
*   PRYOR         PRIORITY BY TUNE NUMBERS  --  ZERO THE LOWEST
*   VOLTABL       VOLUMES
*   FREQTABL      FREQUENCIES
*   CTLTABL       CONTROLS
AUDC0     EQU     $15                    ;BITS     3210 AUDIO CONTROL 0
AUDC1     EQU     $16                    ;BITS     3210 AUDIO CONTROL 1
AUDF0     EQU     $17                    ;BITS     3210 AUDIO FREQUENCY 0
AUDF1     EQU     $18                    ;BITS     3210 AUDIO FREQUENCY 1
AUDV0     EQU     $19                    ;BITS     3210 AUDIO VOLUME 0
AUDV1     EQU     $1A                    ;BITS     3210 AUDIO VOLUME 1


********************************************************************************
* SCRAPALL
*         KILL ALL TUNES. SHOULD BE CALLED AT POWERUP, CHANGING PLAYERS,
*                AND GAME OVER
SCRAPALL
          PHA
          LDA     #0
          STA     AUDV0
          STA     AUDV1
          LDA     #$FF
          STA     TUNNUM
          STA     TUNNUM1
          PLA
          RTS

; IF YOU WANT, LOOP THIS UP

********************************************************************************
* SCRAPONE
*         KILL A PARTICULAR TUNE. PUT THE NUMBER OF THE TUNE YA WANNA
*                 AXE IN THE ACCUMULATOR.
SCRAPONE  CMP     TUNNUM
          BNE     CKCH1
          LDA     #0
          STA     AUDV0
          LDA     #$FF
          STA     TUNNUM
          RTS
CKCH1     SEC
          SBC     TUNNUM1
          BNE     REETS
          STA     AUDV1
          LDA     #$FF
          STA     TUNNUM1
REETS     RTS

********************************************************************************
* TUNIN
*         START THAT TUNE YOU PUT IN ACC.
TUNIN     STA     TUNTEMP
          TYA
          PHA
          TXA
          PHA
          LDY     #1
          LDX     TUNTEMP
TROIKA    LDA     TUNNUM,Y               ;FIRST CHECK FOR AN EMPTY CHANNEL
          CMP     #$FF
          BEQ     DO
TRKNX     DEY
          BPL     TROIKA
          LDA     TUNNUM1                ;THIS IS DONE TO PREVENT GLITCHINESS
          AND     #$7F
          TAY
          LDA     PRYOR,X
          CMP     PRYOR,Y               ;CHECK FOR LOWEST PRIORITY
          LDY     #1
          BCS     DO
          LDA     TUNNUM                ;THIS IS DONE TO PREVENT GLITCHINESS
          AND     #$7F
          TAY
          LDA     PRYOR,X
          CMP     PRYOR,Y               ;CHECK FOR LOWEST PRIORITY
          BCC     ROOTS
          LDY     #0
DO        TXA
          ORA     #$80
          STA     TUNNUM,Y
ROOTS     PLA
          TAX
          PLA
          TAY
          RTS

********************************************************************************
*TUNER SHOULD BE CALLED ONCE PER FRAME, NO INPUTS, AND IT OPERATES WITH
*A TOTAL DISREGARD FOR REGISTER SANCTITY. EACH TUNE CAN BE 256 NOTES LONG
*IF YOUR TUNES ARE VERY SMALL, YOU COULD DO AWAY WITH ALL THE INDIRECT STUFF
TUNER     LDA     MODE
          CMP     #MAUTO
          BEQ     REETS                  ; RTS
          LDX     #1
TUNLOP    LDY     TUNNUM,X
          INY
          BNE     NETN                   ;TUNNUM=FF DO NEXT CHANNEL
JNXTCH    JMP     NXTCH
NETN      DEY
          BPL     BOOGIE
          TYA                            ;NEW TUNE--INTITIATE
          AND     #$7F
          STA     TUNNUM,X
          TAY
          LDA     #1
          STA     DCH0,X                 ;START
          LDA     #$FF                   ; INCREMENTS ON THE FIRST CALL
          STA     TINDEX0,X
          STA     CINDEX0,X
          STA     VINDEX0,X
BOOGIE    LDA     TBASE,Y
          STA     ZMPTRL
          LDA     TBASEH,Y
          STA     ZMPTRH
          DEC     DCH0,X
          BNE     JNXTCH
          LDA     DURTABL,Y
          STA     DCH0,X
          LDY     TINDEX0,X
          INC     CINDEX0,X
          INC     VINDEX0,X
          INY
          LDA     (ZMPTRL),Y             ;FREQUENCY
          CMP     #$FF                   ;FF
          BNE     CKENL
          STA     TUNNUM,X               ;END THIS FUNKY TUNE
          LDA     #0
          STA     AUDV0,X
          BEQ     JNXTCH
CKENL     CMP     #$FE                   ;FE
          BEQ     FOOBEQ
CKNXTT    CMP     #$FD                   ;FD
          BNE     STFREQ
          INY
          LDA     (ZMPTRL),Y
          STA     TUNNUM,X
          TAY
          LDA     TBASE,Y
          STA     ZMPTRL
          LDA     TBASEH,Y
          STA     ZMPTRH

FOOBEQ    LDY     #0                     ;REPEATREPEATREPEAT
          TYA
          STA     CINDEX0,X
          STA     VINDEX0,X
          LDA     (ZMPTRL),Y
STFREQ    BPL     SKIP                   ;TOP BIT
          INY
          LDA     (ZMPTRL),Y
          STA     DCH0,X
          DEY
          LDA     (ZMPTRL),Y
          INY
          JMP     STIT0

SKIP      ASL     A
          BPL     STIT
          LSR     A                      ;THIS CODE FOR RESTS
          AND     #$BF                   ;IF BIT 6 OF THE FREQUENCY IS SET
          STA     DCH0,X                 ;IT USES THE REMAINING 5 BITS FOR
          TYA                            ;A DURATION OF SILENCE
          STA     TINDEX0,X
          DEC     VINDEX0,X
          DEC     CINDEX0,X

          LDA     #0
          STA     AUDV0,X
          BEQ     NXTCH

STIT      LSR     A
STIT0     STA     AUDF0,X
          TYA
          STA     TINDEX0,X
          LDY     TUNNUM,X
          LDA     VBASE,Y
          STA     ZMPTRL
          LDA     VBASEH,Y
          STA     ZMPTRH
          LDY     VINDEX0,X
          LDA     (ZMPTRL),Y
          BPL     STVL
          DEY
STVL      STA     AUDV0,X
          TYA
          STA     VINDEX0,X
          LDY     TUNNUM,X

          LDA     CBASE,Y
          STA     ZMPTRL
          LDA     CBASEH,Y
          STA     ZMPTRH
          LDY     CINDEX0,X
          LDA     (ZMPTRL),Y
          BPL     STCTRL
          DEY
STCTRL    STA     AUDC0,X
          TYA
          STA     CINDEX0,X

NXTCH     DEX
          BMI     ROTS
          JMP     TUNLOP
ROTS      RTS



********************************************************************************
*         pointer tables.
TBASE     DB      L(FSHOT),L(FBOMB),L(FFLAG),L(F8BALLS),L(FMAMA)
          DB      L(FCRUISE),L(FKABOOM),L(FDINK),L(FESCORT2),L(FMAIN0)
          DB      L(FMAIN1),L(FEXTRA),L(FEXPLO),L(FESCORT),L(FSUPER8)
          DB      L(FHSC0),L(FHSC1),L(FHSC2)

TBASEH    DB      H(FSHOT),H(FBOMB),H(FFLAG),H(F8BALLS),H(FMAMA)
          DB      H(FCRUISE),H(FKABOOM),H(FDINK),H(FESCORT2),H(FMAIN0)
          DB      H(FMAIN1),H(FEXTRA),H(FEXPLO),H(FESCORT),H(FSUPER8)
          DB      H(FHSC0),H(FHSC1),H(FHSC2)

VBASE     DB      L(VSHOT),L(VBOMB),L(VFLAG),L(V8BALLS),L(VMAMA)
          DB      L(VCRUISE),L(VKABOOM),L(VDINK),L(VESCORT2),L(VMAIN0)
          DB      L(VMAIN1),L(VEXTRA),L(VEXPLO),L(VESCORT),L(VSUPER8)
          DB      L(VHSC0),L(VHSC1),L(VHSC2)

VBASEH    DB      H(VSHOT),H(VBOMB),H(VFLAG),H(V8BALLS),H(VMAMA)
          DB      H(VCRUISE),H(VKABOOM),H(VDINK),H(VESCORT2),H(VMAIN0)
          DB      H(VMAIN1),H(VEXTRA),H(VEXPLO),H(VESCORT),H(VSUPER8)
          DB      H(VHSC0),H(VHSC1),H(VHSC2)

CBASE     DB      L(CSHOT),L(CBOMB),L(CFLAG),L(C8BALLS),L(CMAMA)
          DB      L(CCRUISE),L(CKABOOM),L(CDINK),L(CESCORT2),L(CMAIN0)
          DB      L(CMAIN1),L(CEXTRA),L(CEXPLO),L(CESCORT),L(CSUPER8)
          DB      L(CHSC0),L(CHSC1),L(CHSC2)

CBASEH    DB      H(CSHOT),H(CBOMB),H(CFLAG),H(C8BALLS),H(CMAMA)
          DB      H(CCRUISE),H(CKABOOM),H(CDINK),H(CESCORT2),H(CMAIN0)
          DB      H(CMAIN1),H(CEXTRA),H(CEXPLO),H(CESCORT),H(CSUPER8)
          DB      H(CHSC0),H(CHSC1),H(CHSC2)

********************************************************************************
HSCDUR    EQU     7
MAINDUR   EQU     4
ESCDUR    EQU     1
ESC2DUR   EQU     2*ESCDUR
DINKDUR   EQU     1
DURTABL   DB      1,1,4,2,4
          DB      6,2,DINKDUR,ESC2DUR,MAINDUR
          DB      MAINDUR,5,$A,ESCDUR,4
          DB      HSCDUR,HSCDUR,HSCDUR
PRYOR     DB      1,1,5,4,5
          DB      0,2,3,4,6
          DB      6,5,3,4,2
          DB      2,2,2

****************************************
FHSC0     DB      5,8,$F,$B,$8,$1B,$7,$8
          DB      $13,$F,$5,$5,$5,$7,$8,$1B
          DB      $B,$11,$F,$14,$17,$1A,$11,$11
          DB      $F,$11,$B,$F,$8,$B,$7,$13
          DB      $FD,HSC0TUNE

CHSC0     DB      $D,$D,$D,$D,$D,$4,$D,$D
          DB      $4,$4,$D,$D,$D,$D,$D,$4
          DB      $D,$D,$D,$D,$D,$D,$D,$D
          DB      $D,$D,$D,$D,$D,$D,$D,$4

VHSC1
VHSC2
          DB      8,8,7,7,6,6,5,5
          DB      4,4,3,3,2,2,1,1
****************************************
FBOMB
          DB      $1F,$1B,$19,$17,$18
          DB      $19,$1A,$1B,$1C,$1D
          DB      $1E,$1F,$0B,$0C,$0C
          DB      $0D,$0E,$0F,$10,$11
          DB      $12,$13,$14,$15,$17
          DB      $18,$1A,$1B,$1D,$1F
          DB      $06,$06,$07,$07,$08
          DB      $08,$09,$09,$0A,$0A
          DB      $0B,$0B,$0C,$0C,$FF

CBOMB
          DB      $04,$04,$04,$04,$04
          DB      $04,$04,$04,$04,$04
          DB      $04,$04,$0D,$0D,$0D
          DB      $0D,$0D,$0D,$0D,$0D
          DB      $0D,$0D,$0D,$0D,$0D
          DB      $0D,$0D,$0D,$0D,$0D
          DB      $86
****************************************
FCRUISE
          DB      $1D,$0E,$0F,$0E,$0B
          DB      $0E,$0F,$0E,$1D,$0E
          DB      $10,$0E,$0B,$0E,$10
          DB      $0E,$1D,$0E,$11,$0E
          DB      $0B,$0E,$11,$0E,$1D
          DB      $0E,$12,$0E,$0B,$0E
          DB      $12,$0E,$FE

****************************************
FMAIN0
          DB      $97,8*MAINDUR
          DB      $40+2*MAINDUR
          DB      $13,$13,$17,$17,$13
          DB      $13,$0E,$0E,$13,$13
          DB      $40+2*MAINDUR,$17,$17,$16
          DB      $16,$40+2*MAINDUR,$96,6*MAINDUR
          DB      $40+2*MAINDUR
          DB      $11,$11,$40+2*MAINDUR
          DB      $96,4*MAINDUR,$40+2*MAINDUR
          DB      $16,$16,$97,8*MAINDUR
          DB      $40+2*MAINDUR,$13,$13
          DB      $17,$17,$13,$13,$0E
          DB      $0E,$13,$13,$40+2*MAINDUR
          DB      $17,$17,$16,$16,$40+2*MAINDUR
          DB      $96,4*MAINDUR
          DB      $40+2*MAINDUR,$97,14*MAINDUR
          DB      $FF

****************************************
FMAIN1
          DB      $1D,$40+MAINDUR,$1D,$40+MAINDUR,$1D
          DB      $40+MAINDUR,$1D,$40+3*MAINDUR
          DB      $17,$17,$1D,$1D,$17
          DB      $17,$13,$13,$17,$17
          DB      $40+2*MAINDUR,$1D,$1D,$1A
          DB      $1A,$40+2*MAINDUR,$9A,6*MAINDUR
          DB      $40+2*MAINDUR
          DB      $1D,$1D,$40+2*MAINDUR
          DB      $1A,$1A,$1D,$1D,$40+2*MAINDUR
          DB      $1F,$1F,$9D,8*MAINDUR
          DB      $40+2*MAINDUR,$17,$17
          DB      $1D,$1D,$17,$17,$13
          DB      $13,$17,$17,$40+2*MAINDUR
          DB      $1D,$1D,$1C,$1C,$40+2*MAINDUR
          DB      $9C,4*MAINDUR
          DB      $40+2*MAINDUR,$9D,14*MAINDUR
          DB      $FF

VESCORT2  DB      6,$A
          DB      6,$A
          DB      6,$A
          DB      6,$A
          DB      6,$A
          DB      6,$A


          ASECT
          ORG     $C0F5
VEXPLO
          DB      $0F,$0A,$07,$04,$02
          DB      $02,$00

CEXPLO
CSUPER8
VMAMA
VHSC0
VMAIN0
VMAIN1
          DB      $88

          ORG     $C1F5
****************************************
FEXTRA
          DB      $13,$17,$1D,$1D,$17
          DB      $13,$0E,$0E,$FF

          ORG     $C2F5
****************************************
FEXPLO
FSUPER8
          DB      $0F,$0A,$08,$06,$05
          DB      $04,$FF


          ORG     $C3F5
VDINK
          DB      $10,$0C,$0A,$08,$07
          DB      $06,$05,$04,$03,$02

          ORG     $C4F5
****************************************
FFLAG
          DB      $15,$10,$0C,$15,$10
          DB      $0C,$15,$10,$0C,$FF

          ORG     $C5F5
****************************************
FMAMA
          DB      $1F,$10,$0F,$10,$0E
          DB      $10,$11,$10,$FE


CMAMA
          DB      $87

          ORG     $C6F5
****************************************
FDINK
          DB      $0C,$0D,$0C,$0D,$0D
          DB      $0C,$8D,4*DINKDUR
          DB      $FF

          ORG     $C7F5
*****************************************
FSHOT
          DB      $13,$09,$1A,$0C,$0B
          DB      $11,$0F,$17,$FF

VSHOT
CHSC1
CHSC2
          DB      $8A                    ;OR BALANCE

          ORG     $C8F5
FESCORT   DB      $A,5,5,$A,$B,$D,$E,$F,$4D,$FD,ESC2TUNE

          ORG     $C9F5
*****************************************
VESCORT   DB      $F,$F,$E,$E,$D,$D,$8A

          ORG     $CAF5
****************************************
* DISINTEGRATION
FKABOOM
          DB      $06,$06,$05,$05,$04
          DB      $FF

VKABOOM
          DB      $08,$04,$08,$04,$08

          ORG     $CBF5
****************************************
F8BALLS
          DB      $1B,$0D,$0C,$0D,$0C
          DB      $FF

VCRUISE
          DB      $82                    ;BALANCE

          ORG     $CCF5
****************************************
CSHOT
          DB      $04,$04,$04,$04,$0D
          DB      $04,$0D,$04

          ORG     $CDF5
FESCORT2  DB      $9E,12*ESC2DUR
          DB      $FF
CESCORT2  DB      $87
CEXTRA
VSUPER8                                  ;<sic>
CMAIN1
CMAIN0
CDINK
CKABOOM
CCRUISE
C8BALLS
CFLAG
CESCORT   DB      $84
VEXTRA
V8BALLS
VFLAG
VBOMB
          DB      $89

          ORG     $CEF5
FHSC1     DB      $92,16*HSCDUR,$FD,HSC2TUNE

FHSC2     DB      $86,16*HSCDUR,$FD,HSC1TUNE
          END
