*
* INTRSECT.S      PAC-FRUIT AND PAC-MONSTER INTERSECT ROUTINES
*

* PFINTR          PAC-FRUIT INTERSECT ROUTINE
*         IN:
*         USES:

PFINTR
          LDA     FENABLE                ;MAKE SURE FRUIT ON
          BEQ     PFIEND
          LDA     FSCORE                 ;MAKE SURE FRUIT NOT SCORE
          BNE     PFIEND

          LDA     PHPOS
          SEC
          SBC     FHPOS
          STA     TEMP0
          BPL     PFINTR1
          LDA     #0
          SEC
          SBC     TEMP0
          STA     TEMP0                  ; TEMP0 = ABS(PHPOS-FHPOS)
PFINTR1   CMP     #$06
          BCS     PFIEND

          LDA     PVPOS
          SEC
          SBC     FVPOS
          STA     TEMP1
          BPL     PFINTR2
          LDA     #0
          SEC
          SBC     TEMP1
          STA     TEMP1                  ; TEMP1 = ABS(PVPOS-FVPOS)
PFINTR2   LDY     TEMP0
          CMP     INTRSECT,Y
          BCS     PFIEND

          LDY     FFRUIT
          LDA     FRTSCORH,Y
          STA     TEMP11
          LDA     FRTSCORL,Y
          STA     TEMP12
          JSR     ADDTOTAL
          JMP     EATFRT

PFIEND    RTS

* PMINTR          PAC-MONSTER INTERSECT ROUTINE
*         IN:
*         USES:

PMINTR
          LDX     #3
PMILOOP
          LDA     PHPOS
          SEC
          SBC     M0HPOS,X
          STA     TEMP0
          BPL     PMINTR1
          LDA     #0
          SEC
          SBC     TEMP0
          STA     TEMP0                  ; TEMP0 = ABS(PHPOS-MHPOS)
PMINTR1   CMP     #$06
          BCS     PMIEND

          LDA     PVPOS
          SEC
          SBC     M0VPOS,X
          STA     TEMP1
          BPL     PMINTR2
          LDA     #0
          SEC
          SBC     TEMP1
          STA     TEMP1                  ; TEMP1 = ABS(PVPOS-MVPOS)
PMINTR2   LDY     TEMP0
          CMP     INTRSECT,Y
          BCS     PMIEND

          LDA     M0STATE,X
          BNE     PMIEND
          LDA     M0BLUE,X
          BNE     PMINTR3
          JSR     KILLPAC
          JMP     DECLIVES
PMINTR3
          CMP     #$08
          BNE     PMIEND
          JSR     MONDEATH
          JSR     TURNEYES
          LDY     GREEDCNT
          LDA     MONSCORH,Y
          STA     TEMP11
          LDA     MONSCORL,Y
          STA     TEMP12
          JSR     ADDTOTAL
          INC     GREEDCNT

PMIEND    DEX
          BPL     PMILOOP
          RTS

*
* MONDEATH        -MONSTER DEATH CODE
*         IN      X IS MONSTER NUMBER

MONDEATH
          JSR     SCORSTMP
          JSR     ERASEPAC
          JSR     CLEARTUN
          LDA     #$11
          JSR     DOTUNE
          LDA     RTLOCAL
          STA     RTSAVE
          LDA     RTLOCAL+1
          STA     RTSAVE+1

          CLC
          ADC     #1
          STA     SCORWAIT
          LDA     #60
          STA     SCORTIME
DEATHLP
          JSR     SEEBNORM
          LDA     RTLOCAL+1
          CMP     SCORWAIT
          BMI     DEATHLP
          JSR     TIGHT
          LDA     RTLOCAL+1
          CLC
          ADC     #1
          STA     SCORWAIT
DEATHEND
          DEC     SCORTIME
          BPL     DEATHLP

          LDA     RTSAVE+1
          STA     RTLOCAL+1
          LDA     RTSAVE
          STA     RTLOCAL
          STX     TEMP16
          JSR     WRITEPAC
          LDX     TEMP16
          RTS

INTRSECT  DB      $05,$04,$03,$02,$01,$00
MONSCORH  DB      $00,$00,$00,$01
MONSCORL  DB      $20,$40,$80,$60
FRTSCORH  DB      $00,$00,$00,$00,$00,$01,$02,$05
FRTSCORL  DB      $05,$10,$20,$50,$70,$00,$00,$00
