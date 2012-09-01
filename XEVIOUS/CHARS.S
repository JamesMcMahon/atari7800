;GLOBALS FOR CHAR FILE
          GLBL    CHARS,LOGO1,LOGO2,LOGO3,LOGO4,LOGO5,LOGO6
          GLBL    LOGOUR,LOGOUL,LOGOTOP,LOGOLR,LOGOLL,LOGOBOT
          GLBL    LOGORITE,LOGOLEFT
          GLBL    BLANKCHR,ZEROCHAR,XTRASCHR
          PUBLIC  KG,KA,KC,KD,KE,KI,KL,KM,KN,KO,KP,KR,KS,KT,KV,KX,KY,KCOPY
*
* XEVIOUS SCORE CHARACTERS
*

ZERO58    MACRO
          DB      0,0,0,0,0,0,0,0,0,0,0,0
          DB      0,0,0,0,0,0,0,0,0,0,0,0
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
          ENDM

CHARS     ORG     $8000                   ;PUT HERE FOR NOW
          ZERO58
LOGO1     DB      $00,$00,$09,$6B,$EA,$E0,$09,$6B
          DB      $AA,$A8,$02,$5A,$E0,$09,$6B,$80,$9A ;15A
LOGO2     DB      $00,$01,$6B,$E0,$09,$AB,$E0,$02
          DB      $6B,$E0,$00,$02,$5A,$AF,$80,$00,$9A ;31A
LOGO3     DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;47A
LOGO4     DB      $B8,$25,$BE,$00,$A6,$B8,$09,$6E
          DB      $00,$26,$B8,$0A,$5A,$E0,$00,$00 ;15B
LOGO5     DB      $F8,$00,$25,$AA,$F8,$00,$00,$0A
          DB      $6A,$F8,$00,$00,$56,$BA,$00,$00 ;31B
LOGO6     DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;47B
LOGOUL    DB      $B9
LOGOUR
LOGOTOP   DB      $00,$00,$00,$6E ;UL,UR15
LOGOLL    DB      $00
LOGOLR
LOGOBOT   DB      $00,$00,$00,$00 ;LL,LR15
LOGORITE  DB      $6E ;R15
LOGOLEFT  DB      $B9 ;L15

          ORG     CHARS+$100
          ZERO58
          DB      $A5,$56,$A5,$AB,$AA,$F8,$29,$5B
          DB      $E0,$95,$6A,$5B,$E0,$A9,$6B,$A0,$9A ;14A
          DB      $A5,$6A,$5A,$E0,$A5,$AB,$E0,$99
          DB      $6B,$A0,$95,$6A,$5A,$AB,$A0,$96,$9A ;30A
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;46A
          DB      $B8,$29,$6E,$0A,$A6,$E0,$A9,$5E
          DB      $09,$A6,$B8,$26,$6B,$40,$A5,$68 ;14B
          DB      $B8,$26,$A6,$A6,$BE,$0A,$55,$A9
          DB      $6A,$BE,$0A,$56,$95,$BE,$02,$68 ;30B
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;46B
          DB      $B9,$00,$00,$00,$6E ;UL,UR14
          DB      $00,$00,$00,$00,$00 ;LL,LR14
          DB      $6E ;R14
          DB      $B9 ;L14

          ORG     CHARS+$200
          ZERO58
          DB      $00,$00,$25,$AF,$A6,$B8,$02,$5A
          DB      $E8,$00,$0A,$5B,$A0,$0A,$6B,$A0,$9A ;13A
          DB      $00,$00,$5A,$F8,$26,$AF,$80,$09
          DB      $AF,$80,$00,$0A,$5A,$6B,$A0,$00,$9A ;29A
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;45A
          DB      $B8,$09,$6F,$82,$9A,$E0,$09,$5E
          DB      $00,$25,$B8,$29,$6B,$80,$00,$00 ;13B
          DB      $F8,$00,$96,$A5,$BE,$00,$00,$29
          DB      $A9,$BE,$00,$00,$15,$AE,$80,$00 ;29B
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;45B
          DB      $B9,$00,$00,$00,$6E ;UL,UR13
          DB      $00,$00,$00,$00,$00 ;LL,LR13
          DB      $6E ;R13
          DB      $B9 ;L13

          ORG     CHARS+$300
          ZERO58
          DB      $A5,$5A,$96,$AF,$95,$BE,$0A,$56
          DB      $F8,$25,$6A,$6B,$A2,$AA,$6B,$E0,$96 ;12A
          DB      $A5,$5A,$96,$B8,$16,$AF,$82,$65
          DB      $AE,$82,$55,$6A,$6A,$6B,$E0,$96,$9A ;28A
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;44A
          DB      $B8,$2A,$5B,$82,$9B,$82,$A9,$5E
          DB      $09,$A5,$B8,$19,$AD,$02,$95,$68 ;12B
          DB      $F8,$2A,$9A,$A9,$6F,$82,$96,$A5
          DB      $B9,$AF,$82,$95,$A5,$6F,$80,$A8 ;28B
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;44B
          DB      $B9,$00,$00,$00,$6E ;UL,UR12
          DB      $00,$00,$00,$00,$00 ;LL,LR12
          DB      $6E ;R12
          DB      $B9 ;L12

          ORG     CHARS+$400
          ZERO58
          DB      $00,$00,$96,$BE,$15,$AE,$00,$96
          DB      $BA,$00,$09,$6B,$80,$02,$6A,$E0,$96 ;11A
          DB      $00,$00,$16,$BE,$9A,$BE,$00,$26
          DB      $BE,$00,$00,$09,$69,$5B,$E0,$00,$9A ;27A
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;43A
          DB      $B8,$02,$5B,$EA,$6B,$80,$09,$5E
          DB      $00,$25,$B8,$A5,$AE,$00,$00,$00 ;11B
          DB      $B8,$02,$5A,$A9,$6F,$80,$00,$A6
          DB      $B9,$6F,$80,$00,$05,$6B,$A0,$00 ;27B
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;43B
          DB      $BE,$AA,$AA,$AA,$BE ;UL,UR11
          DB      $00,$00,$00,$00,$00 ;LL,LR11
          DB      $6E ;R11
          DB      $B9 ;L11

          ORG     CHARS+$500
          DB      $00,$00                 ;BLANK
          DB      $0A,$A8                 ;ZERO
          DB      $02,$A0                 ;ONE
          DB      $2A,$AA                 ;TWO
          DB      $0A,$A8                 ;THREE
          DB      $00,$A8                 ;FOUR
          DB      $2A,$A8                 ;FIVE
          DB      $0A,$A8                 ;SIX
          DB      $02,$A0                 ;SEVEN
          DB      $0A,$A8                 ;EIGHT
          DB      $0A,$A8                 ;NINE
          DB      $22,$A2                 ;EXTRA SOLVALU CHARACTER

* NB: These characters are done in col1 (except O, which is 0, which is col2)
KA        DB      $14,$15  ;A0
KM        DB      $15,$01  ;M0
KE        DB      $15,$55  ;E0
KV        DB      $01,$50  ;V0
KR        DB      $14,$15  ;R0
KG        DB      $05,$55  ;G0
KC        DB      $05,$55  ;C0
KD        DB      $15,$50  ;D0
KI        DB      $01,$50  ;I0
KL        DB      $15,$55  ;L0
KN        DB      $15,$05  ;N0
KP        DB      $15,$00  ;P0
KS        DB      $15,$54  ;S0
KT        DB      $01,$50  ;T0
KX        DB      $14,$15  ;X0
KY        DB      $15,$54  ;Y0
KCOPY     DB      $00,$00  ;K0
          DB      $A5,$6A,$5A,$BE,$25,$6F,$82,$95
          DB      $BE,$09,$A9,$6B,$82,$5A,$5A,$E8,$96 ;10A
          DB      $A5,$56,$A5,$AE,$AA,$BE,$09,$96
          DB      $BA,$09,$55,$A9,$6E,$5A,$E8,$26,$9A ;26A
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;42A
          DB      $B8,$2A,$96,$EA,$6E,$0A,$69,$5E
          DB      $09,$A5,$B8,$95,$B8,$0A,$55,$68 ;10B
          DB      $B8,$2A,$6A,$82,$5B,$E0,$AA,$96
          DB      $E2,$6B,$E0,$A5,$69,$5B,$E0,$A8 ;26B
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;42B
          DB      $BF,$00,$00,$00,$FE ;UL,UR10
          DB      $00,$00,$00,$00,$00 ;LL,LR10
          DB      $6E ;R10
          DB      $B9 ;L10

          ORG     CHARS+$600
          DB      $00,$00                 ;BLANK
          DB      $2A,$AA                 ;ZERO
          DB      $02,$A0                 ;ONE
          DB      $2A,$AA                 ;TWO
          DB      $2A,$AA                 ;THREE
          DB      $2A,$AA                 ;FOUR
          DB      $2A,$AA                 ;FIVE
          DB      $2A,$AA                 ;SIX
          DB      $02,$A0                 ;SEVEN
          DB      $2A,$AA                 ;EIGHT
          DB      $0A,$AA                 ;NINE
          DB      $2A,$AA                 ;EXTRA SOLVALU CHARACTER

          DB      $14,$15  ;A1
          DB      $15,$01  ;M1
          DB      $15,$55  ;E1
          DB      $01,$50  ;V1
          DB      $14,$15  ;R1
          DB      $05,$55
          DB      $05,$55,$15,$50  ;CD1
          DB      $01,$50  ;I1
          DB      $15,$55  ;L1
          DB      $15,$05  ;N1
          DB      $15,$00  ;P1
          DB      $15,$55,$01,$50  ;ST1
          DB      $14,$15  ;X1
          DB      $15,$55  ;Y1
          DB      $05,$50  ;K1
          DB      $00,$02,$5A,$F8,$05,$6B,$80,$25
          DB      $AE,$80,$29,$6F,$80,$02,$5A,$E8,$96 ;9A
          DB      $00,$00,$05,$AA,$AA,$F8,$00,$9A
          DB      $F8,$00,$00,$29,$6E,$56,$E8,$00,$96 ;25A
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;41A
          DB      $B8,$00,$96,$FA,$AE,$00,$09,$5E
          DB      $00,$25,$B8,$15,$BE,$00,$00,$00 ;9B
          DB      $F8,$09,$6A,$82,$5B,$E0,$02,$9A
          DB      $E2,$5B,$E0,$00,$01,$56,$E0,$00 ;25B
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;41B
          DB      $AF,$FF,$FF,$FF,$FA ;UL,UR9
          DB      $00,$00,$00,$00,$00 ;LL,LR9
          DB      $6E ;R9
          DB      $B9 ;L9

          ORG     CHARS+$700
          DB      $00,$00                 ;BLANK
          DB      $2A,$0A                 ;ZERO
          DB      $02,$A0                 ;ONE
          DB      $2A,$00                 ;TWO
          DB      $20,$2A                 ;THREE
          DB      $2A,$AA                 ;FOUR
          DB      $00,$2A                 ;FIVE
          DB      $28,$2A                 ;SIX
          DB      $02,$A0                 ;SEVEN
          DB      $28,$2A                 ;EIGHT
          DB      $00,$2A                 ;NINE
          DB      $2A,$AA                 ;EXTRA SOLVALU CHARACTER

          DB      $14,$15  ;A2
          DB      $15,$01  ;M2
          DB      $14,$00  ;E2
          DB      $05,$54  ;V2
          DB      $14,$14  ;R2
          DB      $15,$15
          DB      $15,$00,$15,$04  ;CD2
          DB      $01,$50  ;I2
          DB      $15,$00  ;L2
          DB      $15,$05  ;N2
          DB      $15,$00  ;P2
          DB      $00,$15,$01,$50  ;ST2
          DB      $14,$15  ;X2
          DB      $00,$15  ;Y2
          DB      $10,$04  ;K2
          DB      $A5,$A9,$6A,$F8,$29,$5B,$E0,$A5
          DB      $6F,$82,$A9,$AE,$89,$56,$9A,$B8,$96 ;8A
          DB      $A5,$55,$A9,$6A,$AA,$F8,$26,$5A
          DB      $E8,$00,$95,$A9,$BE,$96,$F8,$26,$96 ;24A
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;40A
          DB      $B8,$26,$A5,$BA,$B8,$29,$69,$5E
          DB      $09,$A5,$B8,$25,$6E,$02,$95,$68 ;8B
          DB      $F8,$29,$AA,$0A,$96,$F8,$2A,$5B
          DB      $80,$9A,$E8,$25,$69,$5A,$D0,$A8 ;24B
          DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;40B
          DB      $26,$AA,$AA,$AA,$98 ;UL,UR8
          DB      $00,$00,$00,$00,$00 ;LL,LR8
          DB      $6E ;R8
          DB      $B9 ;L8

          ORG     CHARS+$800
          DB      $00,$00                 ;BLANK
          DB      $2A,$0A                 ;ZERO
          DB      $02,$A0                 ;ONE
          DB      $2A,$00                 ;TWO
          DB      $00,$2A                 ;THREE
          DB      $28,$A8                 ;FOUR
          DB      $00,$2A                 ;FIVE
          DB      $28,$2A                 ;SIX
          DB      $02,$A8                 ;SEVEN
          DB      $28,$2A                 ;EIGHT
          DB      $00,$2A                 ;NINE
          DB      $0A,$A8                 ;EXTRA SOLVALU CHARACTER

          DB      $15,$55  ;A3
          DB      $15,$01  ;M3
          DB      $14,$00  ;E3
          DB      $05,$54  ;V3
          DB      $14,$50  ;R3
          DB      $15,$15
          DB      $15,$00,$15,$05  ;CD3
          DB      $01,$50  ;I3
          DB      $15,$00  ;L3
          DB      $15,$15  ;N3
          DB      $15,$00  ;P3
          DB      $00,$15,$01,$50  ;ST3
          DB      $05,$14  ;X3
          DB      $00,$15  ;Y3
          DB      $11,$44  ;K3
          DB      $00,$09,$6B,$E0,$01,$5A,$E0,$09
          DB      $6B,$A0,$25,$AE,$00,$00,$9A,$B8,$96 ;7A
          DB      $00,$00,$01,$6A,$AB,$E0,$02,$6B
          DB      $E0,$00,$00,$25,$BA,$96,$F8,$00,$9A ;23A
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00,$00 ;39A
          DB      $B8,$00,$25,$BA,$B8,$00,$09,$5E
          DB      $00,$25,$B8,$05,$6F,$80,$00,$00 ;7B
          DB      $F8,$25,$AF,$00,$96,$F8,$0A,$6B
          DB      $80,$96,$F8,$00,$0A,$5A,$E0,$00 ;23B
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00 ;39B
          DB      $29,$55,$55,$55,$68 ;UL,UR7
          DB      $00,$00,$00,$00,$00 ;LL,LR7
          DB      $6E ;R7
          DB      $B9 ;L7

          ORG     CHARS+$900
          DB      $00,$00                 ;BLANK
          DB      $2A,$0A                 ;ZERO
          DB      $02,$A0                 ;ONE
          DB      $2A,$A8                 ;TWO
          DB      $00,$A8                 ;THREE
          DB      $28,$A8                 ;FOUR
          DB      $2A,$AA                 ;FIVE
          DB      $2A,$AA                 ;SIX
          DB      $00,$A8                 ;SEVEN
          DB      $2A,$AA                 ;EIGHT
          DB      $0A,$AA                 ;NINE
          DB      $0A,$28                 ;EXTRA SOLVALU CHARACTER

          DB      $15,$55  ;A4
          DB      $15,$11  ;M4
          DB      $15,$50  ;E4
          DB      $05,$54  ;V4
          DB      $15,$54  ;R4
          DB      $15,$00
          DB      $15,$00,$15,$05  ;CD4
          DB      $01,$50  ;I4
          DB      $15,$00  ;L4
          DB      $15,$15  ;N4
          DB      $15,$54  ;P4
          DB      $05,$55,$01,$50  ;ST4
          DB      $01,$50  ;X4
          DB      $05,$55  ;Y4
          DB      $11,$04  ;K4
          DB      $A6,$A5,$AB,$E0,$9A,$56,$F8,$29
          DB      $5B,$E0,$A5,$AE,$09,$56,$96,$E8,$96 ;6A
          DB      $A5,$55,$6A,$5A,$AB,$E0,$99,$6B
          DB      $AA,$A8,$06,$A5,$BA,$A6,$BA,$0A,$9A ;22A
          DB      $02,$5A,$A0,$00,$00,$05,$AA,$A0
          DB      $02,$AA,$A0,$00,$2A,$A8,$00,$00,$0A ;38A
          DB      $B8,$25,$A9,$6A,$E0,$A5,$69,$5E
          DB      $09,$A5,$B8,$29,$5B,$80,$A5,$68 ;6B
          DB      $B8,$26,$B8,$29,$A5,$BE,$09,$6E
          DB      $82,$A6,$B8,$25,$A6,$6B,$40,$68 ;22B
          DB      $80,$00,$00,$28,$00,$00,$00,$00
          DB      $08,$00,$00,$AA,$AA,$00,$00,$00 ;38B
          DB      $0A,$AA,$AA,$AA,$A0 ;UL,UR6
          DB      $0A,$AA,$AA,$AA,$A0 ;LL,LR6
          DB      $6E ;R6
          DB      $B9 ;L6

          ORG     CHARS+$A00
          DB      $00,$00                 ;BLANK
          DB      $2A,$0A                 ;ZERO
          DB      $02,$A0                 ;ONE
          DB      $0A,$AA                 ;TWO
          DB      $00,$A8                 ;THREE
          DB      $28,$A8                 ;FOUR
          DB      $2A,$A8                 ;FIVE
          DB      $2A,$A8                 ;SIX
          DB      $00,$A8                 ;SEVEN
          DB      $0A,$A8                 ;EIGHT
          DB      $2A,$AA                 ;NINE
          DB      $0A,$28                 ;EXTRA SOLVALU CHARACTER

          DB      $05,$04  ;A5
          DB      $15,$55  ;M5
          DB      $15,$50  ;E5
          DB      $15,$05  ;V5
          DB      $15,$55  ;R5
          DB      $15,$00
          DB      $15,$00,$15,$05  ;CD5
          DB      $01,$50  ;I5
          DB      $15,$00  ;L5
          DB      $15,$55  ;N5
          DB      $15,$55  ;P5
          DB      $15,$54,$01,$50  ;ST5
          DB      $01,$54  ;X5
          DB      $15,$55  ;Y5
          DB      $11,$04  ;K5
          DB      $00,$25,$AF,$80,$00,$56,$B8,$02
          DB      $5A,$E8,$09,$BE,$00,$00,$97,$E0,$96 ;5A
          DB      $00,$00,$00,$5A,$AF,$80,$09,$AF
          DB      $FF,$FA,$00,$A5,$B8,$26,$BA,$00,$96 ;21A
          DB      $00,$5B,$F8,$00,$00,$26,$AF,$80
          DB      $09,$AA,$80,$00,$AF,$FA,$00,$00,$2A ;37A
          DB      $B8,$00,$09,$6A,$D0,$00,$09,$5E
          DB      $00,$25,$B8,$01,$5B,$E0,$00,$00 ;5B
          DB      $B8,$16,$B8,$00,$25,$BE,$09,$5E
          DB      $00,$26,$B8,$00,$29,$6B,$80,$00 ;21B
          DB      $A0,$00,$00,$9E,$00,$00,$00,$00
          DB      $2A,$00,$00,$15,$BE,$80,$00,$00 ;37B
          DB      $00,$00,$00,$00,$00 ;UL,UR5
          DB      $29,$55,$55,$55,$68 ;LL,LR5
          DB      $6E ;R5
          DB      $B9 ;L5

          ORG     CHARS+$B00
          DB      $00,$00                 ;BLANK
          DB      $2A,$0A                 ;ZERO
          DB      $02,$A0                 ;ONE
          DB      $00,$2A                 ;TWO
          DB      $00,$2A                 ;THREE
          DB      $28,$A8                 ;FOUR
          DB      $2A,$00                 ;FIVE
          DB      $2A,$00                 ;SIX
          DB      $00,$2A                 ;SEVEN
          DB      $2A,$0A                 ;EIGHT
          DB      $2A,$0A                 ;NINE
          DB      $02,$20                 ;EXTRA SOLVALU CHARACTER

          DB      $05,$04  ;A6
          DB      $15,$55  ;M6
          DB      $15,$00  ;E6
          DB      $15,$05  ;V6
          DB      $15,$01  ;R6
          DB      $15,$00
          DB      $15,$00,$15,$05  ;CD6
          DB      $01,$50  ;I6
          DB      $15,$00  ;L6
          DB      $15,$45  ;N6
          DB      $15,$05  ;P6
          DB      $15,$00,$01,$50  ;ST6
          DB      $05,$54  ;X6
          DB      $15,$05  ;Y6
          DB      $11,$44  ;K6
          DB      $AA,$96,$AF,$82,$56,$95,$BE,$0A
          DB      $56,$F8,$29,$7A,$25,$55,$A7,$A2,$96 ;4A
          DB      $A5,$55,$5A,$96,$AF,$82,$65,$AF
          DB      $EE,$BE,$06,$A6,$B8,$25,$BE,$0A,$96 ;20A
          DB      $00,$96,$F8,$00,$00,$16,$AF,$80
          DB      $05,$AF,$80,$00,$AB,$FA,$00,$00,$AF ;36A
          DB      $B8,$25,$6A,$5B,$42,$95,$69,$5E
          DB      $09,$A5,$B8,$26,$56,$E0,$29,$68 ;4B
          DB      $B8,$9A,$E0,$A5,$69,$6E,$89,$5E
          DB      $09,$A6,$B8,$26,$99,$AD,$02,$68 ;20B
          DB      $E8,$00,$00,$BF,$80,$00,$00,$00
          DB      $2F,$80,$00,$25,$6F,$80,$00,$00 ;36B
          DB      $00,$00,$00,$00,$00 ;UL,UR4
          DB      $26,$AA,$AA,$AA,$98 ;LL,LR4
          DB      $6E ;R4
          DB      $B9 ;L4

          ORG     CHARS+$C00
          DB      $00,$00                 ;BLANK
          DB      $2A,$0A                 ;ZERO
          DB      $02,$A0                 ;ONE
          DB      $00,$2A                 ;TWO
          DB      $20,$2A                 ;THREE
          DB      $0A,$A8                 ;FOUR
          DB      $2A,$00                 ;FIVE
          DB      $2A,$00                 ;SIX
          DB      $20,$2A                 ;SEVEN
          DB      $2A,$0A                 ;EIGHT
          DB      $2A,$0A                 ;NINE
          DB      $02,$A0                 ;EXTRA SOLVALU CHARACTER

          DB      $05,$04  ;A7
          DB      $15,$55  ;M7
          DB      $15,$00  ;E7
          DB      $15,$05  ;V7
          DB      $15,$01  ;R7
          DB      $15,$00
          DB      $15,$00,$15,$05  ;CD7
          DB      $01,$50  ;I7
          DB      $15,$00  ;L7
          DB      $15,$45  ;N7
          DB      $15,$05  ;P7
          DB      $15,$00,$01,$50  ;ST7
          DB      $15,$05  ;X7
          DB      $15,$05  ;Y7
          DB      $10,$04  ;K7
          DB      $00,$96,$BE,$00,$00,$15,$AE,$00
          DB      $96,$BA,$02,$78,$00,$00,$27,$80,$96 ;3A
          DB      $00,$00,$00,$96,$AE,$00,$15,$AA
          DB      $AA,$AE,$00,$96,$F8,$25,$AE,$00,$96 ;19A
          DB      $00,$16,$BE,$00,$00,$9A,$BE,$00
          DB      $26,$BE,$00,$00,$96,$BE,$00,$00,$BB ;35A
          DB      $F8,$00,$02,$5B,$40,$00,$09,$7E
          DB      $00,$25,$F8,$00,$55,$F8,$00,$00 ;3B
          DB      $F8,$96,$E0,$00,$09,$6E,$89,$6E
          DB      $00,$26,$B8,$00,$A5,$AE,$00,$00 ;19B
          DB      $F8,$00,$02,$6F,$80,$00,$00,$00
          DB      $AF,$80,$00,$05,$6B,$A0,$00,$00 ;35B
          DB      $00,$00,$00,$00,$00 ;UL,UR3
          DB      $AF,$FF,$FF,$FF,$FA ;LL,LR3
          DB      $6E ;R3
          DB      $B9 ;L3

          ORG     CHARS+$D00
          DB      $00,$00                 ;BLANK
          DB      $2A,$AA                 ;ZERO
          DB      $0A,$A0                 ;ONE
          DB      $2A,$AA                 ;TWO
          DB      $2A,$AA                 ;THREE
          DB      $02,$A8                 ;FOUR
          DB      $2A,$AA                 ;FIVE
          DB      $2A,$A8                 ;SIX
          DB      $2A,$AA                 ;SEVEN
          DB      $2A,$AA                 ;EIGHT
          DB      $2A,$AA                 ;NINE
          DB      $02,$A0                 ;EXTRA SOLVALU CHARACTER

          DB      $01,$50  ;A8
          DB      $15,$45  ;M8
          DB      $15,$54  ;E8
          DB      $15,$05  ;V8
          DB      $15,$55  ;R8
          DB      $15,$55
          DB      $15,$55,$15,$54  ;CD8
          DB      $01,$50  ;I8
          DB      $15,$00  ;L8
          DB      $15,$05  ;N8
          DB      $15,$55  ;P8
          DB      $15,$55,$15,$55  ;ST8
          DB      $15,$05  ;X8
          DB      $15,$05  ;Y8
          DB      $05,$50  ;K8
          DB      $00,$5A,$BE,$00,$00,$25,$6F,$80
          DB      $15,$BE,$02,$68,$00,$00,$26,$80,$9A ;2A
          DB      $A5,$55,$6A,$5A,$AF,$82,$95,$6A
          DB      $AA,$5E,$0A,$96,$E8,$29,$AE,$82,$96 ;18A
          DB      $A6,$A5,$AE,$09,$56,$5A,$ABE,$09
          DB      $96,$BA,$09,$5A,$96,$BE,$82,$56,$AA ;34A
          DB      $E8,$00,$00,$95,$00,$00,$09,$FA
          DB      $00,$27,$E0,$00,$95,$78,$00,$00 ;2B
          DB      $B8,$96,$E0,$A5,$6A,$6E,$09,$6E
          DB      $09,$A5,$B8,$2A,$66,$B4,$0A,$68 ;18B
          DB      $F8,$25,$6A,$6B,$E0,$A5,$55,$5A
          DB      $97,$E0,$A5,$69,$5B,$E0,$29,$68 ;34B
          DB      $00,$00,$00,$00,$00 ;UL,UR2
          DB      $BF,$00,$00,$00,$FE ;LL,LR2
          DB      $6E ;R2
          DB      $B9 ;L2

          ORG     CHARS+$E00
          DB      $00,$00                 ;BLANK
          DB      $0A,$A8                 ;ZERO
          DB      $0A,$A0                 ;ONE
          DB      $2A,$A8                 ;TWO
          DB      $0A,$A8                 ;THREE
          DB      $00,$A8                 ;FOUR
          DB      $2A,$AA                 ;FIVE
          DB      $0A,$A8                 ;SIX
          DB      $2A,$AA                 ;SEVEN
          DB      $0A,$A8                 ;EIGHT
          DB      $0A,$A8                 ;NINE
          DB      $00,$80                 ;EXTRA SOLVALU CHARACTER
          DB      $01,$50  ;A9
          DB      $15,$01  ;M9
          DB      $15,$54  ;E9
          DB      $15,$05  ;V9
          DB      $15,$54  ;R9
          DB      $05,$55
          DB      $05,$55,$15,$50  ;CD9
          DB      $01,$50  ;I9
          DB      $15,$00  ;L9
          DB      $15,$05  ;N9
          DB      $15,$54  ;P9
          DB      $05,$55,$15,$55  ;ST9
          DB      $15,$05  ;X9
          DB      $15,$05  ;Y9
          DB      $00,$00  ;K9
          DB      $02,$56,$F8,$00,$00,$05,$6B,$80
          DB      $25,$6E,$80,$98,$00,$00,$26,$00,$16 ;1A
          DB      $00,$00,$02,$5A,$AB,$80,$25,$55
          DB      $55,$5E,$02,$96,$E0,$09,$AE,$80,$9A ;17A
          DB      $00,$05,$AF,$80,$02,$6A,$F8,$00
          DB      $9A,$F8,$00,$02,$9A,$AE,$80,$00,$9A ;33A
          DB      $A0,$00,$00,$96,$00,$00,$02,$68
          DB      $00,$09,$A0,$00,$15,$6E,$00,$00 ;1B
          DB      $B8,$16,$F8,$00,$29,$AE,$09,$6E
          DB      $00,$26,$B8,$02,$96,$B8,$00,$00 ;17B
          DB      $F8,$00,$09,$6B,$E0,$00,$00,$02
          DB      $9B,$E0,$00,$01,$5A,$E8,$00,$00 ;33B
          DB      $00,$00,$00,$00,$00 ;UL,UR1
          DB      $BE,$AA,$AA,$AA,$BE ;LL,LR1
          DB      $6E ;R1
          DB      $B9 ;L1


          ORG     CHARS+$F00
          ZERO58
          DB      $01,$55,$58,$00,$00,$09,$5A,$A0
          DB      $05,$55,$50,$A0,$00,$00,$0A,$00,$09 ;0A
          DB      $A5,$55,$A9,$6A,$EB,$E0,$A5,$55
          DB      $55,$7A,$1A,$9A,$E0,$A9,$AF,$82,$9A ;16A
          DB      $A5,$A9,$6B,$82,$59,$6A,$F8,$26
          DB      $5A,$E8,$25,$5A,$9A,$AF,$82,$96,$9A ;32A
          DB      $80,$00,$00,$28,$00,$00,$00,$90
          DB      $00,$02,$40,$00,$25,$55,$40,$00 ;0B
          DB      $B8,$25,$B8,$29,$A9,$B8,$29,$6E
          DB      $09,$A5,$B8,$29,$9A,$D0,$29,$68 ;16B
          DB      $F8,$25,$A9,$AA,$F8,$29,$55,$6A
          DB      $5A,$F8,$29,$5A,$56,$F8,$0A,$68 ;32B
          DB      $00,$00,$00,$00,$00 ;UL,UR0
          DB      $B9,$00,$00,$00,$6E ;LL,LR0
          DB      $6E ;R0
          DB      $B9 ;L0


BLANKCHR  EQU     CHARS                   ;POINTS TO THE BLANK
ZEROCHAR  EQU     CHARS+2                 ;POINTS TO THE ZERO DIGIT
XTRASCHR  EQU     CHARS+22                ;POINTS TO THE 'EXTRA SOLVALU' CHAR
KO        EQU     ZEROCHAR

          END
