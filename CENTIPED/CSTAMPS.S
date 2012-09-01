** GLOBAL.S **
          GLBL    ZERO,ONE,TWO,THREE,FOUR,FIVE,SIX,SEVEN,EIGHT,NINE
          GLBL    HDLTBL,LDLTBL,COLORTBL,MMAPTBLH,MMAPTBLL,BITTABLE
          GLBL    EMPTY,QDYING,HDYING,TDYING
          GLBL    QLIVE,HLIVE,TLIVE,LIVE
          GLBL    TGROWN,HGROWN,QGROWN,FLOWER
          GLBL    QPOIS,HPOIS,TPOIS,POISONED
          GLBL    SAMPLE
          GLBL    STMPBASE
          GLBL    DISPLAY
          GLBL    ELF,ELFB,ELFWSHOT,ELF320
          GLBL    FLEA,LSCRP,RSCRP,EXPLOS,SPIDER
          GLBL    POINT300,POINT600,POINT900
          GLBL    SHOT
          GLBL    BLACKL,BLACKR
          GLBL    A,B,C,D,E,G,H,I,K,L,M,N,O,P,R,S,T,U,V,W,X,Y
          GLBL    DGT1,DGT2

          GLBL    TOV,BLANKOFF,ZONE2
          GLBL    TPG8LIN1,TPG8LIN2,TPG8LIN3,TPG8LIN4,TPG8LIN5
          GLBL    TPG8CVR1,TPG8CVR2,TPG8CVR3,TPG8CVR4

*** CSTAMPS.S ***

STADDR    EQU     $B900
*******************       LINE 8         ***************************************
          ORG     STADDR+$700
STMPBASE
ZERO      DB      $00                    ;00
ONE       DB      $00                    ;01
TWO       DB      $00                    ;02
THREE     DB      $00                    ;03
FOUR      DB      $00                    ;04
FIVE      DB      $00                    ;05
SIX       DB      $00                    ;06
SEVEN     DB      $00                    ;07
EIGHT     DB      $00                    ;08
NINE      DB      $00                    ;09
A         DB      $00                    ;0A
;;;;;B         DB      $00                    ;0B    LOOK AT $41
C         DB      $00                    ;0B
D         DB      $00                    ;0C
E         DB      $00                    ;0D
;;;;;F         DB      $00                    ;0F
G         DB      $00                    ;0E
H         DB      $00                    ;0F
I         DB      $00                    ;10
;;;;;J         DB      $00                    ;13
K         DB      $00                    ;14
L         DB      $00                    ;11
M         DB      $00                    ;12
N         DB      $00                    ;13
O         DB      $00                    ;14
P         DB      $00                    ;15
;;;;;Q         DB      $00                    ;1A
R         DB      $00                    ;16
S         DB      $00                    ;17
T         DB      $00                    ;18
U         DB      $00                    ;19
V         DB      $00                    ;1A
W         DB      $00                    ;1B
X         DB      $00                    ;1C
Y         DB      $00                    ;1D
;;;;;Z         DB      $00                    ;23
DGT1      DB      $00                    ;1E
DGT2      DB      $00                    ;1F
BLACKR    DB      $D5                    ;20
BLACKL    DB      $55,$57            ;21,22,23

SPIDER    DB      $C3,$30,$C0            ;26
          DB      $00,$C0,$00            ;29
          DB      $CB,$33,$80            ;2C
          DB      $B0,$C0,$C0            ;2F

LSCRP     DB      $49,$10
          DB      $49,$10
          DB      $49,$10
          DB      $49,$10
RSCRP     DB      $04,$61
          DB      $04,$61
          DB      $04,$61
          DB      $04,$61                ;3F

          ORG     STADDR+$740
EMPTY     DB      $00                    ;$XX00
B         DB      $00
          DB      $00                    ;FREE
;LFWSHOT  DB      $2A,$00
ELF320    DB      $00                    ;88

QLIVE     DB      $00                    $XX04
HLIVE     DB      $00
TLIVE     DB      $00
LIVE      DB      $00

ELF       DB      $2A,$00                ;39
ELFB      DB      $2A,$00                ;3B

QPOIS     DB      $00                    $XX0C
HPOIS     DB      $00
TPOIS     DB      $00
POISONED  DB      $00

          ORG     STADDR+$750
* CENTIPEDE GRAPHICS
CENTBOD8  DB     $18,$04,$18,$48,$24,$10,$24,$21,$69,$32,$28,$88,$69,$8C,$28,$22
CENTHED8  DB     $18,$04,$18,$48,$24,$10,$24,$21,$69,$30,$00,$08,$69,$0C,$00,$20

LSCRP11   DB      $05,$40                ;70,71
          DB      $01,$50
          DB      $00,$54
          DB      $05,$41
RSCRP11   DB      $01,$50
          DB      $05,$40
          DB      $15,$00
          DB      $41,$50                ;7F

FLEA      DB      $00,$00,$00,$00,$00,$80,$08,$00        ;87

SHOT      DB      $40                    ;88

POINT300  DB      $00,$00,$00            ;8B
POINT600  DB      $00,$00,$00            ;8E
POINT900  DB      $00,$00,$00            ;91

EXPLOS    DB      $3C,0,$00,0,$00,0      ;97

*******************       LINE 7         ***************************************
          ORG     STADDR+$800
NUMBERS7  DB      $38,$7E,$FE,$7C,$0C,$78,$38,$30,$38,$78  ;EDITOR FONT
;;;;;NUMBERS7  DB      $38,$7C,$7E,$7C,$04,$7C,$7C,$40,$7C,$78
LETTERS7  DB      $11,$15,$14,$15        ;ACDE
          DB      $15,$11,$15,$11        ;GHIK
          DB      $15,$11,$11,$15        ;LMNO
          DB      $10,$11,$15,$04        ;PRST
          DB      $15,$04,$11,$11,$04    ;UVWXY
          DB      $15,$15                ;DGT1,DGT2
BLACK7R   DB      $D5
BLACKL7   DB      $55,$57

SPIDER7   DB      $C1,$50,$C0
          DB      $C1,$50,$C0
          DB      $C3,$30,$C0
          DB      $C1,$50,$C0

LSCRP2    DB      $85,$10
          DB      $45,$20
          DB      $85,$10
          DB      $45,$20
RSCRP2    DB      $04,$52
          DB      $08,$51
          DB      $04,$52
          DB      $08,$51

          ORG     STADDR+$840
EMPTY7    DB      $00                    ;$XX00
B7        DB      $14
          DB      $00                    ;FREE
;LFWSH7   DB      $2A,$00
ELF3207   DB      $3E

QLIVE7    DB      $00                    $XX04
HLIVE7    DB      $00
TLIVE7    DB      $00
LIVE7     DB      $2C

ELF7      DB      $2A,$00
ELFB7     DB      $AA,$80

QPOIS7    DB      $00                    $XX0C
HPOIS7    DB      $00
TPOIS7    DB      $00
POISON7   DB      $14

          ORG     STADDR+$850
CENTBOD7  DB     $2A,$2A,$2A,$2A,$A8,$A8,$A8,$A8,$3C,$F8,$AA,$2A,$3C,$2F,$AA,$A8
CENTHED7  DB     $2A,$2A,$2A,$2A,$A8,$A8,$A8,$A8,$3C,$F9,$28,$6A,$3C,$6F,$28,$A9

LSCRP10   DB      $15,$54
          DB      $05,$54
          DB      $01,$55
          DB      $15,$51
RSCRP10   DB      $15,$54
          DB      $15,$50
          DB      $55,$40
          DB      $45,$54

FLEA7     DB      $28,$80,$A2,$80,$22,$80,$08,$80

SHOT7     DB      $40

POINT30A  DB      $00,$00,$00
POINT60A  DB      $00,$00,$00
POINT90A  DB      $00,$00,$00

EXPLOS7   DB      $DD,0,$CD,0,$00,0

*******************       LINE 6         ***************************************
          ORG     STADDR+$900
NUMBERS6  DB      $6C,$18,$C0,$CE,$0C,$EE,$EE,$30,$EE,$0C   ;EDITOR FONT
;;;;;NUMBERS6  DB      $44,$10,$80,$82,$04,$82,$82,$20,$82,$04
LETTERS6  DB      $11,$10,$11,$10        ;ACDE
          DB      $11,$11,$04,$14        ;GHIK
          DB      $10,$11,$11,$11        ;LMNO
          DB      $10,$14,$01,$04        ;PRST
          DB      $11,$04,$15,$11,$04    ;UVWXY
          DB      $04,$10                ;DGT1,DGT2
BLACK6R   DB      $D5
BLACKL6   DB      $55,$57

SPIDER6   DB      $FE,$6F,$C0
          DB      $C2,$60,$C0
          DB      $F1,$53,$C0
          DB      $F2,$63,$C0

LSCRP1    DB      $00,$20
          DB      $80,$00
          DB      $00,$20
          DB      $80,$00
RSCRP1    DB      $08,$00
          DB      $00,$02
          DB      $08,$00
          DB      $00,$02

          ORG     STADDR+$940
EMPTY6    DB      $00                    ;$XX00
B6        DB      $11
          DB      $00                    ;FREE
;LFWSH6   DB      $AA,$80
ELF3206   DB      $3E

QLIVE6    DB      $00                    $XX04
HLIVE6    DB      $00
TLIVE6    DB      $00
LIVE6     DB      $2C

ELF6      DB      $AA,$80
ELFB6     DB      $AA,$80

QPOIS6    DB      $00                    $XX0C
HPOIS6    DB      $00
TPOIS6    DB      $00
POISON6   DB      $14

          ORG     STADDR+$950
CENTBOD6  DB     $EA,$EA,$EA,$EA,$AB,$AB,$AB,$AB,$AA,$E8,$AA,$2A,$AA,$2B,$AA,$A8
CENTHED6  DB     $EE,$E6,$EE,$E6,$BB,$9B,$BB,$9B,$AA,$E8,$AA,$2A,$AA,$2B,$AA,$A8

LSCRP9    DB      $14,$04
          DB      $05,$05
          DB      $05,$41
          DB      $14,$1D
RSCRP9    DB      $10,$14
          DB      $50,$50
          DB      $41,$50
          DB      $74,$14

FLEA6     DB      $3A,$80,$2A,$00,$2A,$00,$3A,$80

SHOT6     DB      $40

POINT30B  DB      $54,$54,$54
POINT60B  DB      $54,$54,$54
POINT90B  DB      $54,$54,$54

EXPLOS6   DB      $DF,0,$FD,0,$1F,0

*******************       LINE 5         ***************************************
          ORG     STADDR+$A00
NUMBERS5  DB      $C6,$18,$60,$04,$FE,$02,$C6,$30,$EE,$06   ;EDITOR FONT
;;;;;NUMBERS5  DB      $82,$10,$40,$02,$FE,$02,$82,$10,$82,$02
LETTERS5  DB      $15,$10,$11,$15        ;ACDE
          DB      $11,$15,$04,$10        ;GHIK
          DB      $10,$11,$15,$11        ;LMNO
          DB      $15,$15,$15,$04        ;PRST
          DB      $11,$11,$11,$04,$04    ;UVWXY
          DB      $04,$15                ;DGT1,DGT2
BLACK5R   DB      $D5
BLACKL5   DB      $55,$57

SPIDER5   DB      $01,$50,$00
          DB      $FD,$5F,$C0
          DB      $3E,$6F,$00
          DB      $3D,$5F,$00

          DB      0,0,0,0,0,0,0,0        ;SCORPION TOP ZONE
          DB      0,0,0,0,0,0,0,0

          ORG     STADDR+$A40
EMPTY5    DB      $00                    ;$XX00
B5        DB      $14
          DB      $00                    ;FREE
;LFWSH5   DB      $AA,$80
ELF3205   DB      $7F

QLIVE5    DB      $00                    $XX04
HLIVE5    DB      $00
TLIVE5    DB      $20
LIVE5     DB      $2C

ELF5      DB      $AA,$80
ELFB5     DB      $BB,$80

QPOIS5    DB      $00                    $XX0C
HPOIS5    DB      $00
TPOIS5    DB      $00
POISON5   DB      $14

          ORG     STADDR+$A50
CENTBOD5  DB     $EA,$EA,$EA,$EA,$AB,$AB,$AB,$AB,$AA,$EA,$AA,$EA,$AA,$AB,$AA,$AB
CENTHED5  DB     $EA,$EA,$EA,$EA,$AB,$AB,$AB,$AB,$AA,$EA,$69,$EA,$AA,$AB,$69,$AB

LSCRP8    DB      $14,$05
          DB      $05,$01
          DB      $05,$11
          DB      $05,$15
RSCRP8    DB      $50,$54
          DB      $40,$50
          DB      $44,$50
          DB      $54,$50

FLEA5     DB      $3D,$C0,$3D,$C0,$3D,$C0,$3D,$C0

SHOT5     DB      $40

POINT30C  DB      $04,$44,$44
POINT60C  DB      $44,$44,$44
POINT90C  DB      $04,$44,$44

EXPLOS5   DB      $FE,0,$4C,0,$0F,0

*******************       LINE 4         ***************************************
          ORG     STADDR+$B00
NUMBERS4  DB      $C6,$18,$38,$38,$CC,$0E,$DC,$18,$38,$76   ;EDITOR FONT
;;;;;NUMBERS4  DB      $82,$10,$3C,$1C,$44,$02,$BC,$08,$7C,$7A
LETTERS4  DB      $11,$10,$11,$10        ;ACDE
          DB      $10,$11,$04,$14        ;GHIK
          DB      $10,$15,$15,$11        ;LMNO
          DB      $11,$11,$10,$04        ;PRST
          DB      $11,$11,$11,$11,$11    ;UVWXY
          DB      $14,$01                ;DGT1,DGT2
BLACK4R   DB      $D5
BLACKL4   DB      $55,$57

SPIDER4   DB      $C1,$50,$C0
          DB      $31,$53,$00
          DB      $01,$50,$C0
          DB      $C1,$50,$00

          DB      0,0,0,0,0,0,0,0        ;SCORPION TOP ZONE
          DB      0,0,0,0,0,0,0,0

          ORG     STADDR+$B40
EMPTY4    DB      $00                    ;$XX00
B4        DB      $11
          DB      $00                    ;FREE
;LFWSH4   DB      $BB,$80
ELF3204   DB      $49

QLIVE4    DB      $00                    $XX04
HLIVE4    DB      $80
TLIVE4    DB      $B3
LIVE4     DB      $BF

ELF4      DB      $BB,$80
ELFB4     DB      $2A,$00

QPOIS4    DB      $00                    $XX0C
HPOIS4    DB      $00
TPOIS4    DB      $7F
POISON4   DB      $7F

          ORG     STADDR+$B50
CENTBOD4  DB     $EA,$EA,$EA,$EA,$AB,$AB,$AB,$AB,$AA,$EA,$AA,$EA,$AA,$AB,$AA,$AB
CENTHED4  DB     $EA,$EA,$EA,$EA,$AB,$AB,$AB,$AB,$69,$EA,$AA,$EA,$69,$AB,$AA,$EA

LSCRP7    DB      $05,$01
          DB      $05,$01
          DB      $05,$1D
          DB      $05,$00
RSCRP7    DB      $40,$50
          DB      $40,$50
          DB      $74,$50
          DB      $00,$50

FLEA4     DB      $F5,$40,$F5,$40,$F5,$40,$F5,$40

SHOT4     DB      $40

POINT30D  DB      $14,$44,$44
POINT60D  DB      $54,$44,$44
POINT90D  DB      $54,$44,$44

EXPLOS4   DB      $4D,0,$EF,0,$1C,0

*******************       LINE 3         ***************************************
          ORG     STADDR+$C00
NUMBERS3  DB      $C6,$18,$0C,$04,$6C,$F8,$C0,$0C,$EE,$C6   ;EDITOR FONT
;;;;;NUMBERS3  DB      $82,$10,$02,$08,$24,$FC,$80,$04,$82,$82
LETTERS3  DB      $15,$15,$14,$15        ;ACDE
          DB      $15,$11,$15,$11        ;GHIK
          DB      $10,$11,$11,$15        ;LMNO
          DB      $15,$15,$15,$15        ;PRST
          DB      $11,$11,$11,$11,$11    ;UVWXY
          DB      $04,$15                ;DGT1,DGT2
BLACK3R   DB      $D5
BLACKL3   DB      $55,$57

SPIDER3   DB      $C1,$50,$C0
          DB      $C2,$60,$C0
          DB      $C1,$53,$C0
          DB      $F3,$70,$C0

          DB      0,0,0,0,0,0,0,0        ;SCORPION TOP ZONE
          DB      0,0,0,0,0,0,0,0

          ORG     STADDR+$C40
EMPTY3    DB      $00                    ;$XX00
B3        DB      $14
          DB      $00                    ;FREE
;LFWSH3   DB      $3B,$00
ELF3203   DB      $3E

QLIVE3    DB      $80                    $XX04
HLIVE3    DB      $83
TLIVE3    DB      $AB
LIVE3     DB      $AB

ELF3      DB      $3B,$00
ELFB3     DB      $2A,$00

QPOIS3    DB      $00                    $XX0C
HPOIS3    DB      $54
TPOIS3    DB      $57
POISON3   DB      $57

          ORG     STADDR+$C50
CENTBOD3  DB     $EA,$EA,$EA,$EA,$AB,$AB,$AB,$AB,$AA,$2A,$3C,$E8,$AA,$A8,$3C,$2B
CENTHED3  DB     $EE,$E6,$EE,$E6,$BB,$9B,$BB,$9B,$AA,$2A,$A9,$E8,$AA,$A8,$A9,$E8

LSCRP6    DB      $D5,$01
          DB      $05,$75
          DB      $D5,$04
          DB      $05,$70
RSCRP6    DB      $40,$57
          DB      $5D,$50
          DB      $10,$57
          DB      $0D,$50

FLEA3     DB      $B7,$40,$B7,$40,$B7,$40,$B7,$40

SHOT3     DB      $40

POINT30E  DB      $04,$44,$44
POINT60E  DB      $40,$44,$44
POINT90E  DB      $44,$44,$44

EXPLOS3   DB      $3B,0,$3F,0,$1C,0

*******************       LINE 2         ***************************************
          ORG     STADDR+$D00
NUMBERS2  DB      $6C,$78,$C6,$CE,$3C,$C0,$E0,$CE,$EE,$EC   ;EDITOR FONT
;;;;;NUMBERS2  DB      $44,$50,$82,$04,$14,$80,$40,$02,$82,$82
LETTERS2  DB      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00
BLACK2R   DB      $D5
BLACKL2   DB      $55,$57

SPIDER2   DB      $EF,$3E,$C0
          DB      $F3,$33,$C0
          DB      $CF,$7F,$00
          DB      $3F,$3C,$C0

          DB      0,0,0,0,0,0,0,0        ;SCORPION TOP ZONE
          DB      0,0,0,0,0,0,0,0

          ORG     STADDR+$D40
EMPTY2    DB      $00                    ;$XX00
B2        DB      $00
          DB      $00                    ;FREE
;LFWSH2   DB      $2A,$00
ELF3202   DB      $08

QLIVE2    DB      $68                    $XX04
HLIVE2    DB      $6A
TLIVE2    DB      $6A
LIVE2     DB      $6A

ELF2      DB      $2A,$00
ELFB2     DB      $08,$00

QPOIS2    DB      $15                    $XX0C
HPOIS2    DB      $95
TPOIS2    DB      $95
POISON2   DB      $95

          ORG     STADDR+$D50
CENTBOD2  DB     $2A,$2A,$2A,$2A,$A8,$A8,$A8,$A8,$28,$2A,$7D,$F8,$28,$A8,$7D,$2F
CENTHED2  DB     $2A,$2A,$2A,$2A,$A8,$A8,$A8,$A8,$28,$6A,$3C,$F9,$28,$A9,$3C,$F9

LSCRP5    DB      $55,$71
          DB      $D5,$50
          DB      $55,$70
          DB      $D5,$50
RSCRP5    DB      $4D,$55
          DB      $05,$57
          DB      $0D,$55
          DB      $05,$57

FLEA2     DB      $B7,$C0,$B7,$C0,$B7,$C0,$B7,$C0

SHOT2     DB      $40

POINT30F  DB      $54,$54,$54
POINT60F  DB      $54,$54,$54
POINT90F  DB      $54,$54,$54

EXPLOS2   DB      $7F,0,$D9,0,$04,0

*******************       LINE 1         ***************************************
          ORG     STADDR+$E00
NUMBERS1  DB      $38,$38,$7C,$7C,$1C,$FE,$38,$FE,$38,$38   ;EDITOR FONT
;;;;;NUMBERS1  DB      $38,$30,$7C,$FE,$0C,$FE,$3C,$FE,$7C,$7C
LETTERS1  DB      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00
BLACK1R   DB      $D5
BLACKL1   DB      $55,$57

SPIDER1   DB      $F8,$0B,$C0
          DB      $3F,$3F,$00
          DB      $FE,$00,$00
          DB      $00,$0F,$C0

          DB      0,0,0,0,0,0,0,0        ;SCORPION TOP ZONE
          DB      0,0,0,0,0,0,0,0

          ORG     STADDR+$E40
EMPTY1    DB      $00                    ;$XX00
B1        DB      $00
          DB      $00                    ;FREE
;LFWSH1   DB      $0C,$00
ELF3201   DB      $08

QLIVE1    DB      $18                    $XX04
HLIVE1    DB      $18
TLIVE1    DB      $18
LIVE1     DB      $18

ELF1      DB      $08,$00
ELFB1     DB      $08,$00

QPOIS1    DB      $24                    $XX0C
HPOIS1    DB      $24
TPOIS1    DB      $24
POISON1   DB      $24

          ORG     STADDR+$E50
CENTBOD1  DB     $18,$48,$18,$04,$24,$21,$24,$10,$00,$88,$00,$32,$00,$22,$00,$8C
CENTHED1  DB     $18,$48,$18,$04,$24,$21,$24,$10,$00,$08,$7C,$30,$00,$20,$7C,$30

LSCRP4    DB      $45,$50
          DB      $55,$10
          DB      $45,$50
          DB      $55,$10
RSCRP4    DB      $05,$51
          DB      $04,$55
          DB      $05,$51
          DB      $04,$55

FLEA1     DB      $0F,$00,$0F,$00,$0F,$00,$0F,$00

SHOT1     DB      $40

POINT30G  DB      $00,$00,$00
POINT60G  DB      $00,$00,$00
POINT90G  DB      $00,$00,$00

EXPLOS1   DB      $37,0,$23,0,$00,0

*******************                      ***************************************
          ORG     $D000
TPG8CVR1  DB      $40,$0A,$B0,$00,0,0,0,$0A,$AB,$00,0,0,0,$2A,$C0,$00
          DB      0,$AB,$00,$3A,$B0,0,0,0,$AB,$00,$3A,$80,0,0,$01
TPG8CVR2  DB      $40,$AB,$00,$00,0,0,0,$0A,$82,$AC,0,$00,$2A,0,$00,$02
          DB      $A0,0,$3A,$B0,$00,$00,$0A,$80,0,$03,$A8,$00,$00,$2A,$01
TPG8CVR3  DB      $40,0,$00,$00,$2A,$00,$00,0,$00,$0A,$AA,$00,0,$2A,$00,$02
          DB      $A0,$0,$00,$00,$02,$A0,$00,$00,0,$2A,$00,0,0,0,$01
TPG8CVR4  DB     $05,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
          DB     $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$50
TPG8LIN5  DB      $05,$01,$05,$01,$40,$04,$00,$40,$44,$40,$44,$11

TPG8LIN1  DB      $2A,$C0,$00,$00,0,0,$2A,$C0,$EA,0,0,$02
          DB      $A0,0,0,0,$02,$AC,$00,$00,0,0,0,$0A,$B0,$00,$00
TPG8LIN2  DB      $00,$00,$A8,0,0,0,$2A,0,0,$2A,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,0,0,0,0
TPG8LIN3  DB      $02,$AC,0,0,0,0,0,$0A,$80,0,0,0,$2A,0,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,$0A,$80,$00
TPG8LIN4  DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

*******************                      ***************************************
          ORG     $D100
TPG7CVR1  DB      $40,$0A,$AA,$AC,0,0,0,$0A,$A8,$00,0,0,0,$2A,$AA,$C0
          DB      0,$AA,$AA,$AA,$A0,0,0,0,$AA,$AA,$AA,$80,0,0,$01
TPG7CVR2  DB      $40,$AA,$00,$00,0,0,0,$0A,$8E,$A0,0,$00,$2A,0,$00,$02
          DB      $A0,0,$0A,$A0,$00,$3A,$AA,$80,0,$00,$A8,$00,$EA,$AA,$01
TPG7CVR3  DB      $40,0,$00,$00,$2A,$C0,$00,0,$00,$3A,$AA,$00,0,$2A,$00,$02
          DB      $A0,$0,$00,$00,$02,$AC,$00,$00,0,$3A,$C0,0,0,0,$01
TPG7CVR4  DB   $10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$04
TPG7LIN5  DB      $10,$41,$10,$44,$10,$04,$00,$40,$44,$40,$44,$11

TPG7LIN1  DB      $2A,$AA,$AB,$00,0,0,$2A,$AA,$AA,0,0,$02
          DB      $A0,0,0,0,$02,$AA,$AA,$B0,0,0,0,$0A,$AA,$AA,$C0
TPG7LIN2  DB      $02,$AA,$A8,0,0,0,$2A,0,0,$2A,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,0,0,0,0
TPG7LIN3  DB      $02,$A0,0,0,0,0,0,$0A,$80,0,0,0,$2A,0,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,$0A,$B0,$00
TPG7LIN4  DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

*******************                      ***************************************
          ORG     $D200
TPG6CVR1  DB      $40,$0E,$AA,$AB,0,0,0,$0A,$AC,$00,0,0,0,$2A,$AA,$B0
          DB      0,$AA,$AA,$AA,$A0,0,0,0,$AA,$AA,$AA,$C0,0,0,$01
TPG6CVR2  DB      $40,$AA,$00,$00,0,0,0,$0A,$8A,$A0,0,$00,$2A,0,$00,$02
          DB      $A0,0,$0E,$AC,$00,$EA,$AA,$C0,0,$00,$A8,$03,$AA,$AB,$01
TPG6CVR3  DB      $40,0,$00,$00,$3A,$AA,$C0,0,$00,$2A,$AA,$00,0,$2A,$00,$02
          DB      $A0,$0,$00,$00,$03,$AA,$AC,$00,0,$0A,$80,0,0,0,$01
TPG6CVR4  DB      $40,0,0,0,$0E,$AA,$AA,$AB,$00,0,0,$00,$0E,$AC,$00,0
          DB      0,$20,$00,$00,$00,$EA,$AA,$AA,$B0,0,$00,$03,$AA,$AA,$C1
TPG6LIN5  DB      $42,$11,$00,$44,$11,$54,$00,$55,$44,$55,$45,$11

TPG6LIN1  DB      $3A,$AA,$AA,$C0,0,0,$2A,$AA,$AA,0,0,$02
          DB      $A0,0,0,0,$03,$AA,$AA,$AC,0,0,0,$0E,$AA,$AA,$B0
TPG6LIN2  DB      $0A,$AA,$AC,0,0,0,$2A,0,0,$2A,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,0,0,0,0
TPG6LIN3  DB      $02,$A0,0,0,0,0,0,$0A,$80,0,0,0,$2A,0,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,$0E,$AA,$B0
TPG6LIN4  DB      $00,$3A,$AA,$AC,0,0,0,0,0,$00,$EC,0,0,0,0,$00
          DB      $80,0,0,0,0,0,0,0,0,$30,0

*******************                      ***************************************
          ORG     $D300
TPG5CVR1  DB      $40,$02,$AA,$AB,0,0,0,$0A,$A0,$00,0,0,0,$2A,$AA,$B0
          DB      0,$AA,$AA,$AA,$A0,0,0,0,$AA,$AA,$AA,$00,0,0,$01
TPG5CVR2  DB      $40,$EA,$00,$00,0,0,0,$0A,$8A,$B0,0,$00,$2A,0,$00,$02
          DB      $A0,0,$02,$A8,$00,$AA,$AA,$00,0,$00,$AB,$02,$AA,$A8,$01
TPG5CVR3  DB      $40,0,$00,$00,$3A,$AA,$B0,0,$00,$EA,$2A,$00,0,$2A,$00,$02
          DB      $A0,$0,$38,$00,$03,$AA,$AB,$00,0,$0A,$80,0,0,0,$01
TPG5CVR4  DB      $40,0,0,0,$0A,$AA,$AA,$AA,$C0,0,0,$00,$3A,$AB,$00,0
          DB      0,$A8,$00,$00,$00,$AA,$AA,$AA,$AC,0,$00,$02,$AA,$AA,$B1
TPG5LIN5  DB      $48,$11,$05,$41,$41,$04,$00,$11,$04,$11,$04,$41

TPG5LIN1  DB      $3A,$AA,$AA,$C0,0,0,$2A,$AA,$AA,0,0,$02
          DB      $A0,0,0,0,$03,$AA,$AA,$AC,0,0,0,$0E,$AA,$AA,$B0
TPG5LIN2  DB      $0A,$AA,$A0,0,0,0,$2A,0,0,$2A,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,0,0,0,0
TPG5LIN3  DB      $02,$AC,0,0,0,0,0,$0A,$80,0,0,0,$2A,0,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,$0E,$AA,$AC
TPG5LIN4  DB      $00,$EA,$AA,$AB,0,0,0,0,0,$00,$AB,0,0,0,0,$02
          DB      $A0,0,0,0,0,0,0,0,0,$EC,0

*******************                      ***************************************
          ORG     $D400
TPG4CVR1  DB      $40,$03,$AA,$AB,0,0,0,$0E,$B0,$00,0,0,0,$3A,$AA,$B0
          DB      0,$EA,$AA,$AA,$B0,0,0,0,$EA,$AA,$AB,$00,0,0,$01
TPG4CVR2  DB      $40,$2A,$C0,$00,0,0,0,$0A,$BA,$80,0,$00,$2A,0,$00,$02
          DB      $A0,0,$03,$AB,$03,$AA,$AB,$00,0,$00,$EA,$0E,$AA,$AC,$01
TPG4CVR3  DB      $40,0,$00,$00,$0A,$AA,$A0,0,$00,$AA,$2A,$00,0,$2A,$00,$02
          DB      $A0,$0,$EB,$00,$00,$AA,$AA,$00,0,$0E,$B0,0,0,0,$01
TPG4CVR4  DB      $40,0,0,0,$3A,$AA,$AA,$AA,$80,0,0,$00,$3A,$AA,$00,0
          DB      0,$A8,$00,$00,$03,$AA,$AA,$AA,$A8,0,$00,$0E,$AA,$AA,$B1
TPG4LIN5  DB      $42,$11,$10,$44,$10,$44,$00,$11,$04,$11,$04,$11

TPG4LIN1  DB      $0A,$AA,$AA,$C0,0,0,$3A,$AA,$AB,0,0,$02
          DB      $A0,0,0,0,$00,$AA,$AA,$AC,0,0,0,$02,$AA,$AA,$B0
TPG4LIN2  DB      $3A,$AA,$B0,0,0,0,$2A,0,0,$2A,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,0,0,0,0
TPG4LIN3  DB      $02,$A8,0,0,0,0,0,$0A,$80,0,0,0,$2A,0,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,$02,$AA,$A8
TPG4LIN4  DB      $00,$EA,$AA,$AB,0,0,0,0,0,$00,$AB,0,0,0,0,$02
          DB      $A0,0,0,0,0,0,0,0,0,$EC,0

*******************                      ***************************************
          ORG     $D500
TPG3CVR1  DB      $40,$00,$EA,$AC,0,0,0,$03,$C0,$00,0,0,0,$0E,$AA,$C0
          DB      0,$3A,$AA,$AA,$C0,0,0,0,$3A,$AA,$AC,$00,0,0,$01
TPG3CVR2  DB      $40,$2A,$C0,$00,0,0,0,$0A,$AA,$C0,0,$00,$2A,0,$00,$02
          DB      $A0,0,$00,$AA,$03,$AA,$AC,$00,0,$00,$2A,$0E,$AA,$B0,$01
TPG3CVR3  DB      $40,0,$00,$00,$0A,$AA,$AC,0,$00,$AB,$2A,$00,0,$2A,$00,$02
          DB      $A0,$0,$EA,$00,$00,$EA,$AA,$C0,0,$02,$A0,0,0,0,$01
TPG3CVR4  DB      $40,0,0,0,$3A,$AA,$AA,$AA,$80,0,0,$00,$2A,$AA,$00,0
          DB      0,$A8,$00,$00,$03,$AA,$AA,$AA,$A8,0,$00,$0E,$AA,$AA,$B1
TPG3LIN5  DB      $10,$41,$10,$44,$10,$14,$00,$11,$04,$11,$04,$11

TPG3LIN1  DB      $0E,$AA,$AB,$00,0,0,$0E,$AA,$AC,0,0,$00
          DB      $80,0,0,0,$00,$EA,$AA,$B0,0,0,0,$03,$AA,$AA,$C0
TPG3LIN2  DB      $3A,$AA,$C0,0,0,0,$2A,0,0,$2A,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,0,0,0,0
TPG3LIN3  DB      $02,$A8,0,0,0,0,0,$0A,$80,0,0,0,$2A,0,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,$03,$AA,$AB
TPG3LIN4  DB      $03,$AA,$AA,$AB,0,0,0,0,0,$02,$AA,0,0,0,0,$02
          DB      $A0,0,0,0,0,0,0,0,0,$A8,0

*******************                      ***************************************
          ORG     $D600
TPG2CVR1  DB   $10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$04
TPG2CVR2  DB      $40,$2A,$80,$00,0,0,0,$0A,$AA,$00,0,$00,$2A,0,$00,$02
          DB      $A0,0,$00,$EA,$C2,$AC,$00,$00,0,$00,$2A,$0A,$B0,$00,$01
TPG2CVR3  DB      $40,0,$00,$00,$02,$AA,$AC,0,$03,$A8,$2A,$00,0,$2A,$00,$02
          DB      $A0,$0,$EA,$C0,$00,$3A,$AA,$C0,0,$02,$A0,0,0,0,$01
TPG2CVR4  DB      $40,0,0,0,$2A,$AA,$AA,$AA,$80,0,0,$00,$2A,$EA,$00,0
          DB      0,$A8,$00,$00,$02,$AA,$AA,$AA,$A8,0,$00,$0A,$AA,$AA,$C1
TPG2LIN5  DB      $05,$01,$05,$01,$40,$04,$00,$04,$55,$44,$05,$41

TPG2LIN1  DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
TPG2LIN2  DB      $2A,$C0,$00,0,0,0,$2A,0,0,$2A,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,0,0,0,0
TPG2LIN3  DB      $03,$A8,0,0,0,0,0,$0A,$80,0,0,0,$2A,0,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,$00,$EA,$AB
TPG2LIN4  DB      $02,$AA,$AA,$AC,0,0,0,0,0,$02,$AA,0,0,0,0,$02
          DB      $A0,0,0,0,0,0,0,0,0,$EB,0

*******************                      ***************************************
          ORG     $D700
TPG1CVR1  DB     $05,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
          DB     $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$50
TPG1CVR2  DB      $40,$3A,$80,$00,0,0,0,$0A,$AA,$00,0,$00,$2A,0,$00,$02
          DB      $A0,0,$00,$2A,$82,$A0,$00,$00,0,$00,$2A,$CA,$80,$00,$01
TPG1CVR3  DB      $40,0,$00,$00,$00,$00,$A8,0,$02,$A8,$2A,$00,0,$2A,$00,$02
          DB      $A0,$0,$2A,$80,$00,$00,$0A,$80,0,$02,$AC,0,0,0,$01
TPG1CVR4  DB      $40,0,0,0,$2A,$C0,$00,$3A,$80,0,0,$00,$2A,$2A,$00,0
          DB      0,$A8,$00,$00,$02,$AC,$00,$03,$A8,0,$00,$0A,$B0,$00,$01
TPG1LIN5  DB      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

TPG1LIN1  DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
TPG1LIN2  DB      $2A,$00,$00,0,0,0,$2A,0,0,$2A,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,0,0,0,0
TPG1LIN3  DB      $00,$A8,0,0,0,0,0,$0A,$80,0,0,0,$2A,0,0,0
          DB      0,$A8,0,0,0,0,0,0,$A8,0,0,$00,$00,$2A
TPG1LIN4  DB      $02,$AB,$00,$00,0,0,0,0,0,$0E,$AA,0,0,0,0,$02
          DB      $A0,0,0,0,0,0,0,0,0,$2A,0


          END

