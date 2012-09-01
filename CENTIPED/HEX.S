QLIVE     DB      $00                    $XX04
HLIVE     DB      $00
TLIVE     DB      $00
LIVE      DB      $00

QPOIS     DB      $00                    $XX0C
HPOIS     DB      $00
TPOIS     DB      $00
POISONED  DB      $00

QLIVE7    DB      $00                    $XX04
HLIVE7    DB      $00
TLIVE7    DB      $00
LIVE7     DB      $2C

QPOIS7    DB      $00                    $XX0C
HPOIS7    DB      $00
TPOIS7    DB      $00
POISON7   DB      $14

QLIVE6    DB      $00                    $XX04
HLIVE6    DB      $00
TLIVE6    DB      $00
LIVE6     DB      $2C

QPOIS6    DB      $00                    $XX0C
HPOIS6    DB      $00
TPOIS6    DB      $00
POISON6   DB      $14

QLIVE5    DB      $00                    $XX04
HLIVE5    DB      $00
TLIVE5    DB      $20
LIVE5     DB      $2C

QPOIS5    DB      $00                    $XX0C
HPOIS5    DB      $00
TPOIS5    DB      $00
POISON5   DB      $14

QLIVE4    DB      $00                    $XX04
HLIVE4    DB      $80
TLIVE4    DB      $B3
LIVE4     DB      $BF

QPOIS4    DB      $00                    $XX0C
HPOIS4    DB      $00
TPOIS4    DB      $7F
POISON4   DB      $7F

QLIVE3    DB      $80                    $XX04
HLIVE3    DB      $83
TLIVE3    DB      $AB
LIVE3     DB      $AB

QPOIS3    DB      $00                    $XX0C
HPOIS3    DB      $54
TPOIS3    DB      $57
POISON3   DB      $57

QLIVE2    DB      $68                    $XX04
HLIVE2    DB      $6A
TLIVE2    DB      $6A
LIVE2     DB      $6A

QPOIS2    DB      $15                    $XX0C
HPOIS2    DB      $95
TPOIS2    DB      $95
POISON2   DB      $95

QLIVE1    DB      $18                    $XX04
HLIVE1    DB      $18
TLIVE1    DB      $18
LIVE1     DB      $18

QPOIS1    DB      $24                    $XX0C
HPOIS1    DB      $24
TPOIS1    DB      $24
POISON1   DB      $24

ELF       DB      $2A,$00                ;39
ELFB      DB      $2A,$00                ;3B

ELF7      DB      $2A,$00
ELFB7     DB      $AA,$80

ELF6      DB      $AA,$80
ELFB6     DB      $AA,$80

ELF5      DB      $AA,$80
ELFB5     DB      $BB,$80

ELF4      DB      $BB,$80
ELFB4     DB      $2A,$00

ELF3      DB      $3B,$00
ELFB3     DB      $2A,$00

ELF2      DB      $2A,$00
ELFB2     DB      $08,$00

ELF1      DB      $08,$00
ELFB1     DB      $08,$00

* CENTIPEDE GRAPHICS
CENTBOD8  DB     $18,$04,$18,$48,$24,$10,$24,$21,$69,$32,$28,$88,$69,$8C,$28,$22
CENTHED8  DB     $18,$04,$18,$48,$24,$10,$24,$21,$69,$30,$00,$08,$69,$0C,$00,$20

CENTBOD7  DB     $2A,$2A,$2A,$2A,$A8,$A8,$A8,$A8,$3C,$F8,$AA,$2A,$3C,$2F,$AA,$A8
CENTHED7  DB     $2A,$2A,$2A,$2A,$A8,$A8,$A8,$A8,$3C,$F9,$28,$6A,$3C,$6F,$28,$A9

CENTBOD6  DB     $EA,$EA,$EA,$EA,$AB,$AB,$AB,$AB,$AA,$E8,$AA,$2A,$AA,$2B,$AA,$A8
CENTHED6  DB     $EE,$E6,$EE,$E6,$BB,$9B,$BB,$9B,$AA,$E8,$AA,$2A,$AA,$2B,$AA,$A8

CENTBOD5  DB     $EA,$EA,$EA,$EA,$AB,$AB,$AB,$AB,$AA,$EA,$AA,$EA,$AA,$AB,$AA,$AB
CENTHED5  DB     $EA,$EA,$EA,$EA,$AB,$AB,$AB,$AB,$AA,$EA,$69,$EA,$AA,$AB,$69,$AB

CENTBOD4  DB     $EA,$EA,$EA,$EA,$AB,$AB,$AB,$AB,$AA,$EA,$AA,$EA,$AA,$AB,$AA,$AB
CENTHED4  DB     $EA,$EA,$EA,$EA,$AB,$AB,$AB,$AB,$69,$EA,$AA,$EA,$69,$AB,$AA,$EA

CENTBOD3  DB     $EA,$EA,$EA,$EA,$AB,$AB,$AB,$AB,$AA,$2A,$3C,$E8,$AA,$A8,$3C,$2B
CENTHED3  DB     $EE,$E6,$EE,$E6,$BB,$9B,$BB,$9B,$AA,$2A,$A9,$E8,$AA,$A8,$A9,$E8

CENTBOD2  DB     $2A,$2A,$2A,$2A,$A8,$A8,$A8,$A8,$28,$2A,$7D,$F8,$28,$A8,$7D,$2F
CENTHED2  DB     $2A,$2A,$2A,$2A,$A8,$A8,$A8,$A8,$28,$6A,$3C,$F9,$28,$A9,$3C,$F9

CENTBOD1  DB     $18,$48,$18,$04,$24,$21,$24,$10,$00,$88,$00,$32,$00,$22,$00,$8C
CENTHED1  DB     $18,$48,$18,$04,$24,$21,$24,$10,$00,$08,$7C,$30,$00,$20,$7C,$30

FLEA      DB      $00,$00,$00,$00,$00,$80,$08,$00        ;87

FLEA7     DB      $28,$80,$A2,$80,$22,$80,$08,$80

FLEA6     DB      $3A,$80,$2A,$00,$2A,$00,$3A,$80

FLEA5     DB      $3D,$C0,$3D,$C0,$3D,$C0,$3D,$C0

FLEA4     DB      $F5,$40,$F5,$40,$F5,$40,$F5,$40

FLEA3     DB      $B7,$40,$B7,$40,$B7,$40,$B7,$40

FLEA2     DB      $B7,$C0,$B7,$C0,$B7,$C0,$B7,$C0

FLEA1     DB      $0F,$00,$0F,$00,$0F,$00,$0F,$00

SPIDER    DB      $C3,$30,$C0            ;26
          DB      $00,$C0,$00            ;29
          DB      $CB,$33,$80            ;2C
          DB      $B0,$C0,$C0            ;2F

SPIDER7   DB      $C1,$50,$C0
          DB      $C1,$50,$C0
          DB      $C3,$30,$C0
          DB      $C1,$50,$C0

SPIDER6   DB      $FE,$6F,$C0
          DB      $C2,$60,$C0
          DB      $F1,$53,$C0
          DB      $F2,$63,$C0

SPIDER5   DB      $01,$50,$00
          DB      $FD,$5F,$C0
          DB      $3E,$6F,$00
          DB      $3D,$5F,$00

SPIDER4   DB      $C1,$50,$C0
          DB      $31,$53,$00
          DB      $01,$50,$C0
          DB      $C1,$50,$00

SPIDER3   DB      $C1,$50,$C0
          DB      $C2,$60,$C0
          DB      $C1,$53,$C0
          DB      $F3,$70,$C0

SPIDER2   DB      $EF,$3E,$C0
          DB      $F3,$33,$C0
          DB      $CF,$7F,$00
          DB      $3F,$3C,$C0

SPIDER1   DB      $F8,$0B,$C0
          DB      $3F,$3F,$00
          DB      $FE,$00,$00
          DB      $00,$0F,$C0

LSCRP11   DB      $05,$40                ;70,71
          DB      $01,$50
          DB      $00,$54
          DB      $05,$41
RSCRP11   DB      $01,$50
          DB      $05,$40
          DB      $15,$00
          DB      $41,$50                ;7F

LSCRP10   DB      $15,$54
          DB      $05,$54
          DB      $01,$55
          DB      $15,$51
RSCRP10   DB      $15,$54
          DB      $15,$50
          DB      $55,$40
          DB      $45,$54

LSCRP9    DB      $14,$04
          DB      $05,$05
          DB      $05,$41
          DB      $14,$1D
RSCRP9    DB      $10,$14
          DB      $50,$50
          DB      $41,$50
          DB      $74,$14

LSCRP8    DB      $14,$05
          DB      $05,$01
          DB      $05,$11
          DB      $05,$15
RSCRP8    DB      $50,$54
          DB      $40,$50
          DB      $44,$50
          DB      $54,$50

LSCRP7    DB      $05,$01
          DB      $05,$01
          DB      $05,$1D
          DB      $05,$00
RSCRP7    DB      $40,$50
          DB      $40,$50
          DB      $74,$50
          DB      $00,$50

LSCRP6    DB      $D5,$01
          DB      $05,$75
          DB      $D5,$04
          DB      $05,$70
RSCRP6    DB      $40,$57
          DB      $5D,$50
          DB      $10,$57
          DB      $0D,$50

LSCRP5    DB      $55,$71
          DB      $D5,$50
          DB      $55,$70
          DB      $D5,$50
RSCRP5    DB      $4D,$55
          DB      $05,$57
          DB      $0D,$55
          DB      $05,$57

LSCRP4    DB      $45,$50
          DB      $55,$10
          DB      $45,$50
          DB      $55,$10
RSCRP4    DB      $05,$51
          DB      $04,$55
          DB      $05,$51
          DB      $04,$55

LSCRP     DB      $49,$10
          DB      $49,$10
          DB      $49,$10
          DB      $49,$10
RSCRP     DB      $04,$61
          DB      $04,$61
          DB      $04,$61
          DB      $04,$61                ;3F

LSCRP2    DB      $85,$10
          DB      $45,$20
          DB      $85,$10
          DB      $45,$20
RSCRP2    DB      $04,$52
          DB      $08,$51
          DB      $04,$52
          DB      $08,$51

LSCRP1    DB      $00,$20
          DB      $80,$00
          DB      $00,$20
          DB      $80,$00
RSCRP1    DB      $08,$00
          DB      $00,$02
          DB      $08,$00
          DB      $00,$02

