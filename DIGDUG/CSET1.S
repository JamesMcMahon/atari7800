*******************************************************************************
*******************************************************************************

***********               CHARACTER AND STAMP DATA                   **********
***********                        CSET1                             **********
***********                    PAGES 40 - 4B                         **********

*******************************************************************************

          ORG     $E000                  ;BOTTOM SCAN LINE: OFFSET = 0.

          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;0-7    DIRT CHARACTERS
          DB      $54,$54,$54,$54,$54,$5D,$54,$5D        ;8-15
          DB      $40,$00,$40,$00,$40,$00,$40,$00        ;16-23
          DB      $54,$54,$54,$54,$55,$5D                ;24-29
          DB      $6A,$A9                                ;30-31  SKY
          DB      $A9,$5A,$A5,$6A                        ;32-35  BIG,SML FLOWER
          DB      $55,$5D                                ;36-37  FULL DIRT CHAR
          DB      $55,$5D,$40,$01,$55,$5D,$55,$5D        ;38-45  HALF FULL DIRT
          DB      $55,$5D,$40,$01                        ;46-49  HALF FULL DIRT

          DB      $0E,$B0                                ;50-51  TEDDY HEAD
          DB      $80,$00,$00,$00,$0E,$EF,$00,$00        ;52-59  VEGGIES:C,R,M,C
          DB      $0A,$80,$00,$00,$00,$00,$00,$00        ;60-67  E,BP,T,O
          DB      $00,$00,$00,$00,$0A,$A8                ;68-73  W,G,P

          DB      $50,$00,$00,$0D                        ;74-77  R,L DIRT EDGE

          DB      $00,$00                                ;78-79  S
          DB      $00,$00                                ;80-81  A
          DB      $00,$00                                ;82-83  Y
          DB      $00,$00,$00,$00                        ;84-87  LETRG,LETRM

          DB      $00,$CC,$CC,$CC,$CC,$00                ;88-93  (C) 1983 ATARI
          DB      $0C,$33,$33,$30,$C0,$C0                ;94-99  (C) 1982 NAMCO
          DB      $AA,$80,$02,$AA,$2A,$AA,$AA,$80        ;100-07 TITLED10,9
          DB      $AA,$80,$AA,$A8,$00,$AA,$A8,$00        ;108-15 TITLEG10,9
          DB      $AA,$A8,$2A,$AA,$00,$AA,$A8,$00        ;116-23 TITLEU10,9
          DB      $00,$03,$FF,$60,$00,$FF,$3F,$C0        ;124-31 TDDUG10,9
          DB      $AA,$AA,$0A,$A0                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $00,$00                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $00,$00,$00,$00,$00,$00                ;150-55 NUMBERS: 0,1,2
          DB      $00,$00,$00,$00,$00,$00                ;156-61 3,4,5
          DB      $00,$00,$00,$00,$00,$00                ;162-67 6,7,8
          DB      $00,$00                                ;168-69 9


          ORG     $E100                  ;LINE 11: OFFSET = 1.

          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$05,$00,$05        ;8-15
          DB      $40,$00,$40,$00,$40,$01,$40,$01        ;16-23
          DB      $50,$00,$50,$00,$50,$05                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $A5,$56,$95,$5A                        ;32-35  BIG,SML FLOWER
          DB      $55,$55                                ;36-37  FULL DIRT
          DB      $05,$55,$40,$01,$55,$50,$55,$55        ;38-45  HALF FULL DIRT
          DB      $05,$50,$40,$01                        ;46-49  HALF FULL DIRT

          DB      $2B,$2C                                ;50-51  TEDDY HEAD
          DB      $A0,$00,$57,$00,$03,$B8,$00,$00        ;52-59  VEGGIES:C,R,M,C
          DB      $2A,$A0,$00,$00,$00,$00,$33,$30        ;60-67  E,BP,T,O
          DB      $00,$00,$03,$C0,$2A,$EA                ;68-73  W,G,P

          DB      $50,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $55,$50                                ;78-79  S
          DB      $50,$14                                ;80-81  A
          DB      $05,$40                                ;82-83  Y
          DB      $15,$50,$50,$14                        ;84-87  LETRG,LETRM

          DB      $00,$CC,$CC,$CC,$CC,$00                ;88-93  (C) 1983 ATARI
          DB      $0C,$33,$33,$33,$33,$30                ;94-99  (C) 1982 NAMCO
          DB      $FF,$C0,$03,$FF,$FF,$FF,$FF,$F0        ;100-07 TITLED10,9
          DB      $FF,$C0,$00,$00,$0F,$FF,$FF,$C0        ;108-15 TITLEG10,9
          DB      $FF,$FC,$3F,$FF,$0F,$FF,$FF,$C0        ;116-23 TITLEU10,9
          DB      $00,$3F,$FF,$C0,$00,$3F,$0F,$C0        ;124-31 TDDUG10,9
          DB      $FF,$FF,$0F,$F0                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $50,$14                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $3F,$F0,$FF,$FC,$FF,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $3F,$F0,$03,$F0,$3F,$F0                ;156-61 3,4,5
          DB      $3F,$F0,$FF,$00,$3F,$F0                ;162-67 6,7,8
          DB      $FF,$00                                ;168-69 9


          ORG     $E200                  ;LINE 10: OFFSET = 2.

          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;8-15
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;16-23
          DB      $40,$00,$C0,$00,$40,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $96,$66,$5B,$56                        ;32-35  BIG,SML FLOWER
          DB      $D5,$55                                ;35-37  FULL DIRT
          DB      $01,$55,$C0,$01,$D5,$40,$D5,$55        ;38-45  HALF DIRT
          DB      $01,$40,$C0,$01                        ;46-49  HALF DIRT

          DB      $EC,$8B                                ;50-51  TEDDY HEAD
          DB      $A8,$00,$55,$40,$03,$FC,$69,$00        ;52-59  VEGGIES:C,R,M,C
          DB      $96,$A0,$04,$40,$00,$00,$0F,$C0        ;60-67  E,BP,T,O
          DB      $0A,$A0,$03,$C0,$2A,$AE                ;68-73  W,G,P

          DB      $D0,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $AA,$A8                                ;78-79  S
          DB      $A0,$28                                ;80-81  A
          DB      $0A,$80                                ;82-83  Y
          DB      $AA,$A8,$A0,$28                        ;84-87  LETRG,LETRM


          DB      $00,$FC,$CF,$CF,$0C,$00                ;88-93  (C) 1983 ATARI
          DB      $0C,$F3,$F3,$33,$03,$30                ;94-99  (C) 1982 NAMCO
          DB      $AA,$80,$02,$AA,$AA,$AA,$AA,$A8        ;100-07 TITLED10,9
          DB      $AA,$80,$00,$00,$0A,$AA,$AA,$A0        ;108-15 TITLEG10,9
          DB      $AA,$A8,$2A,$AA,$2A,$AA,$AA,$A0        ;116-23 TITLEU10,9
          DB      $00,$FF,$FF,$C0,$00,$0F,$03,$C0        ;124-31 TDDUG10,9
          DB      $AA,$AA,$2A,$A8                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $A0,$28                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FF,$FC,$FF,$FC,$FF,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $FF,$FC,$03,$F0,$FF,$FC                ;156-61 3,4,5
          DB      $FF,$FC,$FF,$C0,$FF,$FC                ;162-67 6,7,8
          DB      $FF,$C0                                ;168-69 9


          ORG     $E300                  ;LINE 9: OFFSET = 3.

          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;8-15
          DB      $40,$00,$40,$00,$40,$00,$40,$00        ;16-23
          DB      $40,$00,$40,$00,$40,$00                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $AB,$EA,$AB,$9A                        ;32-35  BIG,SML FLOWER
          DB      $55,$55                                ;36-37  FULL DIRT
          DB      $01,$55,$40,$01,$55,$40,$55,$55        ;38-45  HALF DIRT
          DB      $01,$40,$40,$01                        ;46-49  HALF DIRT

          DB      $E2,$23                                ;50-51  TEDDY HEAD
          DB      $BA,$00,$55,$70,$E3,$F0,$6E,$80        ;52-59  VEGGIES:C,R,M,C
          DB      $5A,$A8,$15,$50,$15,$54,$6A,$A4        ;60-67  E,BP,T,O
          DB      $29,$68,$03,$C0,$2E,$AA                ;68-73  W,G,P

          DB      $50,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $00,$14                                ;78-79  S
          DB      $50,$14                                ;80-81  A
          DB      $05,$40                                ;82-83  Y
          DB      $50,$14,$50,$14                        ;84-87  LETRG,LETRM

          DB      $00,$CC,$CC,$CC,$CC,$00                ;88-93  (C) 1983 ATARI
          DB      $0F,$F3,$33,$F3,$03,$30                ;94-99  (C) 1982 NAMCO
          DB      $FF,$C0,$0F,$FF,$FF,$FF,$FF,$FC        ;100-07 TITLED10,9
          DB      $FF,$F0,$0F,$F0,$3F,$FF,$FF,$FC        ;108-15 TITLEG10,9
          DB      $FF,$FC,$3F,$FF,$3F,$FF,$FF,$FC        ;116-23 TITLEU10,9
          DB      $00,$05,$5F,$F0,$00,$0F,$FF,$C0        ;124-31 TDDUG10,9
          DB      $FF,$FF,$3F,$FC                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $50,$14                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FF,$FC,$FF,$FC,$3F,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $FC,$FC,$FF,$FC,$F0,$FC                ;156-61 3,4,5
          DB      $FC,$FC,$3F,$C0,$FC,$FC                ;162-67 6,7,8
          DB      $3F,$C0                                ;168-69 9


          ORG     $E400                  ;LINE 8: OFFSET = 4.

          DB      $00,$00,$00,$00,$00,$00,$00,$00        ;0-7
          DB      $00,$00,$00,$00,$00,$00,$00,$03        ;8-15
          DB      $40,$00,$40,$00,$40,$00,$40,$00        ;16-23
          DB      $40,$00,$40,$00,$40,$00                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $AF,$FA,$AF,$6A                        ;32-35  BIG,SML FLOWER
          DB      $55,$57                                ;36-37  FULL DIRT
          DB      $01,$57,$50,$07,$55,$40,$55,$57        ;38-45  HALF DIRT
          DB      $01,$40,$50,$07                        ;46-49  HALF DIRT

          DB      $EA,$2B                                ;50-51  TEDDY HEAD
          DB      $2A,$00,$55,$50,$AB,$F0,$1A,$E0        ;52-59  VEGGIES:C,R,M,C
          DB      $6E,$A8,$55,$54,$55,$55,$6B,$A8        ;60-67  E,BP,T,O
          DB      $64,$59,$03,$C0,$2A,$EA                ;68-73  W,G,P

          DB      $50,$00,$00,$07                        ;74-77  R,L DIRT EDGE

          DB      $00,$28                                ;78-79  S
          DB      $AA,$A8                                ;80-81  A
          DB      $0A,$80                                ;82-83  Y
          DB      $A0,$28,$A0,$28                        ;84-87  LETRG,LETRM

          DB      $00,$CC,$CC,$CC,$CC,$00                ;88-93  (C) 1983 ATARI
          DB      $0F,$33,$33,$F3,$33,$30                ;94-99  (C) 1982 NAMCO
          DB      $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA        ;100-07 TITLED10,9
          DB      $AA,$A8,$2A,$A8,$2A,$AA,$AA,$A8        ;108-15 TITLEG10,9
          DB      $AA,$A8,$2A,$AA,$AA,$AA,$AA,$A8        ;116-23 TITLEU10,9
          DB      $00,$14,$45,$FC,$00,$1F,$FF,$D0        ;124-31 TDDUG10,9
          DB      $AA,$AA,$2A,$A8                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $AA,$A0                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FC,$FC,$0F,$C0,$0F,$C0                ;150-55 NUMBERS: 0,1,2
          DB      $00,$FC,$FF,$FC,$00,$FC                ;156-61 3,4,5
          DB      $FC,$FC,$0F,$F0,$FC,$FC                ;162-67 6,7,8
          DB      $0F,$F0                                ;168-69 9


          ORG     $E500                  ;LINE 7: OFFSET = 5.

          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;8-15
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;16-23
          DB      $00,$00,$40,$00,$00,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $BD,$FE,$BF,$DA                        ;32-35  BIG,SML FLOWER
          DB      $57,$55                                ;       FULL DIRT
          DB      $03,$55,$57,$55,$57,$40,$57,$55        ;       HALF DIRT
          DB      $03,$40,$57,$55                        ;       HALF DIRT

          DB      $EA,$AB                                ;       TEDDY HEAD
          DB      $2B,$80,$55,$50,$AA,$B0,$02,$B4        ;       VEGGIES:C,R,M,C
          DB      $6F,$A8,$65,$54,$55,$55,$AE,$E8        ;       E,BP,T,O
          DB      $A5,$5A,$0F,$F0,$3A,$AB                ;       W,G,P

          DB      $50,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $55,$54                                ;78-79  S
          DB      $55,$54                                ;80-81  A
          DB      $15,$50                                ;82-83  Y
          DB      $50,$54,$51,$14                        ;84-87  LETRG,LETRM

          DB      $00,$33,$F3,$03,$0C,$00                ;88-93  (C) 1983 ATARI
          DB      $0C,$30,$C3,$30,$C0,$C0                ;94-99  (C) 1982 NAMCO
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ;100-07 TITLED10,9
          DB      $3F,$FF,$FF,$FC,$3F,$FF,$FF,$FF        ;108-15 TITLEG10,9
          DB      $FF,$FC,$3F,$FF,$FF,$FF,$FF,$FF        ;116-23 TITLEU10,9
          DB      $00,$14,$45,$FC,$0A,$3F,$FF,$F0        ;124-31 TDDUG10,9
          DB      $FF,$FF,$FF,$FF                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $55,$50                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FC,$FC,$0F,$C0,$03,$F0                ;150-55 NUMBERS: 0,1,2
          DB      $3F,$FC,$FC,$FC,$00,$FC                ;156-61 3,4,5
          DB      $FC,$FC,$03,$F0,$3F,$F0                ;162-67 6,7,8
          DB      $0F,$F0                                ;168-69 9


          ORG     $E600                  ;LINE 6: OFFSET = 6.

          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;8-15
          DB      $40,$00,$40,$00,$40,$01,$40,$01        ;16-23
          DB      $40,$00,$40,$00,$40,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $BF,$DE,$BF,$DA                        ;32-35  BIG,SML FLOWER
          DB      $55,$55                                ;       FULL DIRT
          DB      $01,$55,$55,$55,$55,$40,$55,$55        ;       HALF DIRT
          DB      $01,$40,$55,$55                        ;       HALF DIRT

          DB      $28,$88                                ;       TEDDY HEAD
          DB      $0A,$80,$55,$50,$9A,$A8,$00,$A8        ;       VEGGIES:C,R,M,C
          DB      $17,$AA,$75,$54,$5D,$55,$AE,$E8        ;       E,BP,T,O
          DB      $95,$16,$2B,$E8,$0E,$AC                ;       W,G,P

          DB      $50,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $55,$54                                ;78-79  S
          DB      $50,$14                                ;80-81  A
          DB      $54,$54                                ;82-83  Y
          DB      $50,$54,$51,$14                        ;84-87  LETRG,LETRM

          DB      $00,$00,$00,$00,$00,$00                ;88-93  (C) 1983 ATARI
          DB      $00,$00,$00,$00,$00,$00                ;94-99  (C) 1982 NAMCO
          DB      $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA        ;100-07 TITLED10,9
          DB      $2A,$AA,$AA,$A8,$AA,$AA,$AA,$AA        ;108-15 TITLEG10,9
          DB      $AA,$A8,$2A,$AA,$AA,$AA,$AA,$AA        ;116-23 TITLEU10,9
          DB      $00,$15,$55,$FC,$2A,$3F,$DF,$B0        ;124-31 TDDUG10,9
          DB      $AA,$AA,$AA,$AA                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $50,$14                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FC,$FC,$0F,$C0,$F0,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $3F,$FC,$FC,$F0,$FF,$FC                ;156-61 3,4,5
          DB      $FF,$FC,$00,$FC,$FF,$FC                ;162-67 6,7,8
          DB      $3C,$FC                                ;168-69 9


          ORG     $E700                  ;LINE 5: OFFSET = 7.

          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;8-15
          DB      $40,$00,$40,$00,$40,$01,$40,$01        ;16-23
          DB      $40,$00,$40,$00,$40,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $BF,$FE,$B3,$DA                        ;32-35  BIG,SML FLOWER
          DB      $55,$55                                ;       FULL DIRT
          DB      $01,$55,$55,$55,$55,$40,$50,$05        ;       HALF DIRT
          DB      $01,$40,$50,$05                        ;       HALF DIRT

          DB      $2A,$A8                                ;       TEDDY HEAD
          DB      $0B,$80,$D5,$50,$AA,$AA,$00,$A8        ;       VEGGIES:C,R,M,C
          DB      $19,$EA,$75,$54,$5D,$55,$6E,$E4        ;       E,BP,T,O
          DB      $91,$56,$AD,$7B,$05,$50                ;       W,G,P

          DB      $50,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $50,$00                                ;78-79  S
          DB      $50,$14                                ;80-81  A
          DB      $50,$14                                ;82-83  Y
          DB      $50,$00,$55,$54                        ;84-87  LETRG,LETRM

          DB      $30,$30,$30,$33,$F0,$30                ;88-93  (C) 1983 ATARI
          DB      $30,$30,$30,$33,$F3,$F0                ;94-99  (C) 1982 NAMCO
          DB      $FF,$FF,$FF,$FC,$FF,$FF,$FF,$FF        ;100-07 TITLED10,9
          DB      $3F,$FF,$FF,$FC,$FF,$F0,$3F,$FF        ;108-15 TITLEG10,9
          DB      $FF,$FC,$3F,$FF,$FF,$FF,$FF,$FF        ;116-23 TITLEU10,9
          DB      $03,$FF,$FF,$FC,$AA,$AA,$96,$AA        ;124-31 TDDUG10,9
          DB      $FF,$FF,$FF,$FF                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $50,$14                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FC,$FC,$0F,$C0,$F0,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $00,$FC,$3C,$F0,$FF,$F0                ;156-61 3,4,5
          DB      $FF,$F0,$00,$FC,$FC,$FC                ;162-67 6,7,8
          DB      $FC,$FC                                ;168-69 9


          ORG     $E800                  ;LINE 4: OFFSET = 8.

          DB      $00,$00,$00,$00,$00,$00,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$00,$00,$01        ;8-15
          DB      $40,$00,$40,$00,$40,$00,$40,$00        ;16-23
          DB      $40,$00,$C0,$00,$40,$00                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $B7,$FE,$BF,$DA                        ;32-35  BIG,SML FLOWER
          DB      $D5,$55                                ;       FULL DIRT
          DB      $01,$55,$D5,$55,$D5,$40,$C0,$01        ;       HALF DIRT
          DB      $01,$40,$C0,$01                        ;       HALF DIRT

          DB      $AA,$AA                                ;       TEDDY HEAD
          DB      $02,$A0,$D5,$40,$E6,$6A,$00,$2A        ;       VEGGIES:C,R,M,C
          DB      $06,$AA,$54,$94,$55,$55,$2B,$A0        ;       E,BP,T,O
          DB      $95,$16,$A5,$5A,$15,$14                ;       W,G,P

          DB      $D0,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $50,$00                                ;78-79  S
          DB      $54,$54                                ;80-81  A
          DB      $50,$14                                ;82-83  Y
          DB      $50,$14,$55,$54                        ;84-87  LETRG,LETRM

          DB      $C3,$0C,$30,$33,$30,$30                ;88-93  (C) 1983 ATARI
          DB      $C3,$0C,$30,$33,$33,$00                ;94-99  (C) 1982 NAMCO
          DB      $AA,$AA,$AA,$A8,$AA,$80,$0A,$AA        ;100-07 TITLED10,9
          DB      $0A,$AA,$AA,$A0,$AA,$80,$0A,$AA        ;108-15 TITLEG10,9
          DB      $AA,$A8,$2A,$AA,$AA,$A8,$2A,$AA        ;116-23 TITLEU10,9
          DB      $00,$1F,$FF,$F0,$2A,$7F,$D6,$F0        ;124-31 TDDUG10,9
          DB      $2A,$A8,$AA,$AA                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $50,$14                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FF,$FC,$FF,$F0,$FF,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $FC,$FC,$3F,$F0,$FC,$00                ;156-61 3,4,5
          DB      $FC,$00,$FF,$FC,$FC,$FC                ;162-67 6,7,8
          DB      $FF,$FC                                ;168-69 9


          ORG     $E900                  ;LINE 3: OFFSET = 9.

          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$01        ;8-15
          DB      $00,$00,$40,$00,$00,$01,$40,$01        ;16-23
          DB      $00,$00,$40,$00,$00,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $BF,$DE,$AF,$6A                        ;32-35  BIG,SML FLOWER
          DB      $55,$5D                                ;       FULL DIRT
          DB      $01,$5D,$55,$5D,$55,$40,$40,$01        ;       HALF DIRT
          DB      $01,$40,$40,$01                        ;       HALF DIRT

          DB      $8B,$E2                                ;       TEDDY HEAD
          DB      $00,$90,$95,$A0,$2A,$A6,$00,$0A        ;       VEGGIES:C,R,M,C
          DB      $02,$6A,$11,$10,$16,$14,$0A,$80        ;       E,BP,T,O
          DB      $00,$00,$A5,$5A,$51,$45                ;       W,G,P

          DB      $50,$00,$00,$0D                        ;74-77  R,L DIRT EDGE

          DB      $55,$54                                ;78-79  S
          DB      $15,$50                                ;80-81  A
          DB      $50,$14                                ;82-83  Y
          DB      $55,$54,$54,$54                        ;84-87  LETRG,LETRM

          DB      $CC,$0C,$33,$F3,$F3,$F0                ;88-93  (C) 1983 ATARI
          DB      $CC,$0C,$33,$F3,$F3,$F0                ;94-99  (C) 1982 NAMCO
          DB      $FF,$FF,$FF,$F0,$FF,$C0,$03,$FF        ;100-07 TITLED10,9
          DB      $03,$FF,$FF,$C0,$FF,$C0,$0F,$FF        ;108-15 TITLEG10,9
          DB      $FF,$FC,$3F,$FC,$FF,$FC,$3F,$FF        ;116-23 TITLEU10,9
          DB      $00,$07,$FF,$F0,$0A,$1F,$F5,$B0        ;124-31 TDDUG10,9
          DB      $3F,$FC,$FF,$FF                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $55,$54                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $FF,$FC,$FF,$F0,$FF,$FC                ;150-55 NUMBERS: 0,1,2
          DB      $FF,$FC,$3F,$F0,$FF,$FC                ;156-61 3,4,5
          DB      $FF,$FC,$FF,$FC,$FF,$FC                ;162-67 6,7,8
          DB      $FF,$FC                                ;168-69 9


          ORG     $EA00                  ;LINE 2: OFFSET = 10.

          DB      $00,$00,$00,$00,$00,$01,$00,$05        ;0-7
          DB      $00,$00,$00,$00,$00,$01,$00,$05        ;8-15
          DB      $00,$00,$50,$00,$00,$01,$50,$05        ;16-23
          DB      $00,$00,$50,$00,$00,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $BD,$FE,$AA,$AA                        ;32-35  BIG,SML FLOWER
          DB      $55,$55                                ;       FULL DIRT
          DB      $05,$55,$55,$55,$55,$50,$40,$01        ;       HALF DIRT
          DB      $05,$50,$40,$01                        ;       HALF DIRT

          DB      $AC,$2A                                ;       TEDDY HEAD
          DB      $00,$50,$02,$28,$0A,$6A,$00,$06        ;       VEGGIES:C,R,M,C
          DB      $00,$AA,$01,$00,$00,$80,$06,$40        ;       E,BP,T,O
          DB      $00,$00,$95,$56,$44,$41                ;       W,G,P

          DB      $50,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $15,$54                                ;78-79  S
          DB      $05,$40                                ;80-81  A
          DB      $50,$14                                ;82-83  Y
          DB      $15,$50,$14,$50                        ;84-87  LETRG,LETRM

          DB      $C3,$0C,$33,$33,$33,$30                ;88-93  (C) 1983 ATARI
          DB      $C3,$0C,$33,$33,$30,$30                ;94-99  (C) 1982 NAMCO
          DB      $2A,$AA,$AA,$A0,$AA,$80,$02,$AA        ;100-07 TITLED10,9
          DB      $00,$AA,$AA,$80,$AA,$80,$AA,$AA        ;108-15 TITLEG10,9
          DB      $2A,$A0,$0A,$A8,$AA,$A8,$2A,$AA        ;116-23 TITLEU10,9
          DB      $00,$01,$FF,$C0,$00,$1F,$FD,$60        ;124-31 TDDUG10,9
          DB      $0A,$A0,$AA,$AA                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $15,$50                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $3F,$F0,$03,$F0,$3F,$F0                ;150-55 NUMBERS: 0,1,2
          DB      $3F,$F0,$0F,$F0,$FF,$FC                ;156-61 3,4,5
          DB      $3F,$FC,$FF,$FC,$3F,$F0                ;162-67 6,7,8
          DB      $3F,$F0                                ;168-69 9


          ORG     $EB00                  ;TOP SCAN LINE: OFFSET = 11.

          DB      $00,$00,$41,$C1,$00,$01,$41,$D5        ;0-7
          DB      $00,$00,$41,$C1,$00,$01,$41,$55        ;8-15
          DB      $40,$00,$51,$C1,$40,$01,$75,$D5        ;16-23
          DB      $40,$00,$51,$C1,$40,$01                ;24-29
          DB      $AA,$AA                                ;30-31  SKY
          DB      $AF,$FA,$AA,$AA                        ;32-35  BIG,SML FLOWER
          DB      $75,$D5                                ;36-37  FULL DIRT
          DB      $75,$D5,$75,$D5,$75,$D5,$40,$01        ;38-45  HALF DIRT
          DB      $75,$D5,$40,$01                        ;46-49  HALF DIRT

          DB      $28,$28                                ;50-51  TEDDY HEAD
          DB      $01,$14,$0A,$20,$03,$A8,$00,$00        ;52-59  VEGGIES:C,R,M,C
          DB      $00,$28,$00,$00,$00,$00,$02,$00        ;60-67  E,BP,T,O
          DB      $00,$00,$85,$52,$00,$00                ;68-73  W,G,P

          DB      $70,$00,$00,$05                        ;74-77  R,L DIRT EDGE

          DB      $00,$00                                ;78-79  S
          DB      $00,$00                                ;80-81  A
          DB      $00,$00                                ;82-83  Y
          DB      $00,$00,$00,$00                        ;84-87  LETRG,LETRM

          DB      $30,$30,$33,$F3,$F3,$30                ;88-93  (C) 1983 ATARI
          DB      $30,$30,$33,$F3,$F3,$F0                ;94-99  (C) 1982 NAMCO
          DB      $3F,$FF,$FF,$C0,$FF,$C0,$03,$FF        ;100-07 TITLED10,9
          DB      $00,$3F,$FC,$00,$FF,$C0,$FF,$FF        ;108-15 TITLEG10,9
          DB      $0F,$C0,$03,$F0,$FF,$FC,$3F,$FF        ;116-23 TITLEU10,9
          DB      $00,$00,$FF,$00,$00,$07,$FF,$60        ;124-31 TDDUG10,9
          DB      $03,$C0,$FF,$FF                        ;132-35 TITLEI10,9

          DB      $A0                                    ;136    RSKYHALF (137)
          DB      $00,$00,$00,$00                        ;137-40 16 PIX BLANK3.
          DB      $0A                                    ;141    LSKYHALF (140)
          DB      $00,$00                                ;142-43 R
          DB      $FF,$FF,$FF,$FF,$FF,$F0                ;144-49 BLACKBOX

          DB      $00,$00,$00,$00,$00,$00                ;150-55 NUMBERS: 0,1,2
          DB      $00,$00,$00,$00,$00,$00                ;156-61 3,4,5
          DB      $00,$00,$00,$00,$00,$00                ;162-67 6,7,8
          DB      $00,$00                                ;168-69 9
