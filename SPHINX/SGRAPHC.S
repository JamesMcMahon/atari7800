*         SPHINX--SGRAPHC.S
* THE GRAPHICS ARE ORGANIZED AS FOLLOWS:
* 8000 - 8FFF ARE ALL CHARACTERS (16 PAGES)
* A000 - AFFF ARE ALL GRAPHICS (16 PAGES)  INCLUDING SCROLLING STAMPS
* C000 - CFFF ARE BIRD AND OTHER GRAPHICS (16 PAGES)

;          ZERODEF

          ORG     $C000
BIRDFMS:  .dc.b      $00,$00,$00,$00        ; FMS 16   FLYING MIDDLE STRAIGHT
BIRDFUS:  .dc.b      $0F,$C0,$00,$00        ; FUS 16
BIRDFDS:  .dc.b      $00,$00,$00,$00        ; FDS 16
BIRDFMR:  .dc.b      $00,$00,$9F,$C0        ; FMR 16
BIRDFUR:  .dc.b      $0C,$00,$00,$00        ; FUR 16
BIRDFDR:  .dc.b      $00,$03,$C0,$00        ; FDR 16
BIRDFML:  .dc.b      $00,$00,$00,$00        ; FML 16
BIRDFUL:  .dc.b      $00,$00,$00,$00        ; FUL 16
BIRDFDL:  .dc.b      $00,$00,$00,$00        ; FDL 16
BIRDSU:   .dc.b      $03,$00,$00,$00        ; SU  16   STALL UP
BIRDSD:   .dc.b      $03,$00,$00,$00        ; SD  16
BIRDHUS:  .dc.b      $00,$00,$00,$00        ; HUS 16   HOP UP STRAIGHT
BIRDHDS:  .dc.b      $00,$00,$00,$00        ; HDS 16
BIRDHUR:  .dc.b      $00,$00,$00,$00        ; HUR 16
BIRDHDR:  .dc.b      $00,$00,$00,$00        ; HDR 16
BIRDHUL:  .dc.b      $00,$3C,$00,$00        ; HUL 16
BIRDHDL:  .dc.b      $00,$3C,$00,$00        ; HDL 16
BIRDWS:   .dc.b      $00,$00,$00,$00        ; WS  16   WATER STRAIGHT  (DUCK)
BIRDWL:   .dc.b      $00,$3C,$00,$00        ; WL  16
BIRDWR:   .dc.b      $00,$00,$00,$00        ; WR  16
BIRDLU:   .dc.b      $00,$00,$00,$00        ; LU  16   LANDING UP
BIRDLD:   .dc.b      $00,$00,$00,$00        ; LD  16
SHADSU:   .dc.b      $00,$C0,$00,$00        ; SHAD SU 16
SHADSD:   .dc.b      $00,$C0,$00,$00        ; SHAD SD 16
SHADHUS:  .dc.b      $0C,$00,$00,$00        ; SHAD HUS 16
SHADHDS:  .dc.b      $0C,$00,$00,$00        ; SHAD HDS 16
SHADHUR:  .dc.b      $00,$3F,$F0,$00        ; SHAD HUR 16
SHADHDR:  .dc.b      $00,$0C,$F0,$00        ; SHAD HDR 16
SHADHUL:  .dc.b      $00,$3C,$00,$00        ; SHAD HUL 16
SHADHDL:  .dc.b      $00,$3C,$00,$00        ; SHAD HDL 16
SHADLU:   .dc.b      $0C,$00,$3F,$00        ; SHAD LU 16
SHADLD:   .dc.b      $0C,$00,$00,$00        ; SHAD LD 16    128 BYTES
SHOTAN0:  .dc.b      $00,$00                ; SHOTAN0   EARLY SHOT
          .dc.b      $00,$00                ; SHOTAN1   BIGGER SHOT
          .dc.b      $00,$00                ; SHOTAN2   FIRST PUFF
          .dc.b      $00,$00                ; SHOTAN3   SECOND PUFF  136 BYTES
EWERUN1:  .dc.b      $00,$00,$00,$00        ;EWERUN1
EWERUN2:  .dc.b      $00,$00,$00,$00        ;EWERUN2
EWEJUMP:  .dc.b      $00,$00,$00,$00        ;EWEJUMP
EWEDIG3:  .dc.b      $00,$00,$00,$00        ;EWEDIG3
EWEDIG2:  .dc.b      $00,$00,$00,$00        ;EWEDIG2
EWEDIG1:  .dc.b      $00,$00,$00,$00        ;EWEDIG1
EWELEFT1: .dc.b      $00,$00,$44,$00        ;EWELEFT1
EWELEFT2: .dc.b      $07,$4F,$00,$00        ;EWELEFT2
EWERITE1: .dc.b      $00,$00,$00,$00        ;EWERITE1
EWERITE2: .dc.b      $00,$00,$00,$00        ;EWERITE2     176 BYTES
POT:      .dc.b      $2F,$F8                ;POT          178 BYTES
COL1:     .dc.b      $03,$EE,$C0            ;COL1
COL2:     .dc.b      $00,$DB,$C0            ;COL2         184 BYTES
TIP1:     .dc.b      $0F,$90                ;TIP1
TIP2:     .dc.b      $0B,$BC                ;TIP2
TIP3:     .dc.b      $3E,$7C                ;TIP3
SPSHOTST: .dc.b      $00,$00                ;SPSHOTST     192 BYTES
BDS1:     .dc.b      $00,$00,$00,$00        ;BIRD DEATH W/STARS
BDS2:     .dc.b      $00,$00,$00,$00        ;BDS2
BDS3:     .dc.b      $00,$00,$00,$00        ;BDS3
BDS4:     .dc.b      $00,$00,$00,$00        ;BDS4
BDS5:     .dc.b      $00,$00,$0F,$C0        ;BDS5
BDS6:     .dc.b      $00,$00,$0F,$C0        ;BDS6         216 BYTES
GEM:      .dc.b      $00,$00                ;GEM
EGG:      .dc.b      $00,$00                ;EGG
BAR:      .dc.b      $00,$00,$00            ;BAR         223
UWEBLANK: .dc.b      $00,$00,$00,$00        ;UWEBLANK


ENDOFC:
          ORG     $C100
          .dc.b      $0F,$C0,$00,$00        ; FMS 15
          .dc.b      $15,$40,$00,$00        ; FUS 15
          .dc.b      $00,$00,$00,$00        ; FDS 15
          .dc.b      $0C,$02,$9B,$C0        ; FMR 15
          .dc.b      $34,$00,$0B,$80        ; FUR 15
          .dc.b      $00,$03,$C0,$00        ; FDR 15
          .dc.b      $00,$00,$00,$00        ; FML 15
          .dc.b      $00,$00,$00,$00        ; FUL 15
          .dc.b      $00,$00,$00,$00        ; FDL 15
          .dc.b      $47,$00,$00,$00        ; SU  15
          .dc.b      $47,$00,$00,$00        ; SD  15
          .dc.b      $00,$00,$00,$00        ; HUS 15
          .dc.b      $0D,$00,$00,$00        ; HDS 15
          .dc.b      $00,$00,$00,$00        ; HUR 15
          .dc.b      $00,$0C,$00,$00        ; HDR 15
          .dc.b      $0F,$54,$40,$00        ; HUL 15
          .dc.b      $0F,$54,$00,$00        ; HDL 15
          .dc.b      $00,$00,$00,$00        ; WS  15
          .dc.b      $0F,$54,$00,$00        ; WL  15
          .dc.b      $00,$00,$00,$00        ; WR  15
          .dc.b      $00,$00,$00,$00        ; LU  15
          .dc.b      $00,$00,$00,$00        ; LD  15
          .dc.b      $33,$C0,$FC,$00        ; SHAD SU 15
          .dc.b      $33,$C0,$3F,$00        ; SHAD SD 15
          .dc.b      $3F,$CF,$00,$00        ; SHAD HUS 15
          .dc.b      $3F,$CF,$00,$00        ; SHAD HDS 15
          .dc.b      $00,$0F,$FC,$00        ; SHAD HUR 15
          .dc.b      $03,$FF,$FC,$00        ; SHAD HDR 15
          .dc.b      $0F,$FC,$F0,$00        ; SHAD HUL 15
          .dc.b      $0F,$FC,$F0,$00        ; SHAD HDL 15
          .dc.b      $3F,$03,$FF,$C0        ; SHAD LU 15
          .dc.b      $3F,$CF,$C0,$00        ; SHAD LD 15
          .dc.b      $00,$00                ; SHOTAN0
          .dc.b      $00,$00                ; SHOTAN1
          .dc.b      $00,$00                ; SHOTAN2
          .dc.b      $00,$00                ; SHOTAN3
          .dc.b      $00,$FF,$00,$00        ;EWERUN1
          .dc.b      $00,$FF,$00,$00        ;EWERUN2
          .dc.b      $00,$3C,$00,$00        ;EWEJUMP
          .dc.b      $00,$0B,$00,$00        ;EWEDIG3
          .dc.b      $00,$01,$00,$00        ;EWEDIG2
          .dc.b      $00,$01,$00,$00        ;EWEDIG1
          .dc.b      $00,$33,$44,$00        ;EWELEFT1
          .dc.b      $35,$7B,$00,$00        ;EWELEFT2
          .dc.b      $3C,$00,$00,$00        ;EWERITE1
          .dc.b      $3C,$00,$00,$00        ;EWERITE2
          .dc.b      $3F,$FC                ;POT
          .dc.b      $00,$BB,$00            ;COL1
          .dc.b      $01,$5F,$40            ;COL2
          .dc.b      $0D,$B2                ;TIP1
          .dc.b      $0E,$70                ;TIP2
          .dc.b      $0E,$F4                ;TIP3
          .dc.b      $00,$00                ;SPSHOTST
          .dc.b      $00,$00,$00,$00        ;BDS1
          .dc.b      $00,$00,$00,$00        ;BDS2
          .dc.b      $00,$00,$00,$00        ;BDS3
          .dc.b      $00,$00,$00,$00        ;BDS4
          .dc.b      $01,$00,$7F,$C0        ;BDS5
          .dc.b      $00,$00,$7F,$C0        ;BDS6
          .dc.b      $00,$00                ;GEM
          .dc.b      $00,$00                ;EGG
          .dc.b      $00,$00,$00            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $C200
          .dc.b      $15,$40,$00,$00        ; FMS 14
          .dc.b      $D6,$80,$00,$00        ; FUS 14
          .dc.b      $00,$00,$0F,$00        ; FDS 14
          .dc.b      $34,$02,$99,$00        ; FMR 14
          .dc.b      $16,$00,$A6,$F0        ; FUR 14
          .dc.b      $00,$03,$C0,$00        ; FDR 14
          .dc.b      $00,$00,$00,$00        ; FML 14
          .dc.b      $00,$00,$00,$00        ; FUL 14
          .dc.b      $00,$00,$00,$00        ; FDL 14
          .dc.b      $F5,$00,$00,$00        ; SU  14
          .dc.b      $F5,$00,$B0,$00        ; SD  14
          .dc.b      $00,$00,$00,$00        ; HUS 14
          .dc.b      $16,$43,$00,$00        ; HDS 14
          .dc.b      $00,$00,$00,$00        ; HUR 14
          .dc.b      $00,$30,$00,$00        ; HDR 14
          .dc.b      $01,$69,$80,$00        ; HUL 14
          .dc.b      $01,$69,$C0,$00        ; HDL 14
          .dc.b      $0D,$00,$00,$00        ; WS  14
          .dc.b      $01,$69,$00,$00        ; WL  14
          .dc.b      $00,$00,$00,$00        ; WR  14
          .dc.b      $00,$00,$00,$00        ; LU  14
          .dc.b      $00,$00,$00,$00        ; LD  14
          .dc.b      $3F,$F3,$FF,$00        ; SHAD SU 14
          .dc.b      $3F,$F0,$FF,$F0        ; SHAD SD 14
          .dc.b      $FF,$FF,$F0,$00        ; SHAD HUS 14
          .dc.b      $FF,$FF,$F0,$00        ; SHAD HDS 14
          .dc.b      $03,$FF,$FC,$00        ; SHAD HUR 14
          .dc.b      $3F,$F3,$FF,$00        ; SHAD HDR 14
          .dc.b      $03,$FF,$F0,$00        ; SHAD HUL 14
          .dc.b      $03,$FF,$F0,$00        ; SHAD HDL 14
          .dc.b      $FF,$FF,$FF,$F0        ; SHAD LU 14
          .dc.b      $FF,$FF,$FC,$00        ; SHAD LD 14
          .dc.b      $00,$00                ; SHOTAN0
          .dc.b      $00,$00                ; SHOTAN1
          .dc.b      $00,$00                ; SHOTAN2
          .dc.b      $00,$00                ; SHOTAN3
          .dc.b      $03,$7D,$C0,$00        ;EWERUN1
          .dc.b      $03,$7F,$C0,$00        ;EWERUN2
          .dc.b      $00,$FF,$C0,$00        ;EWEJUMP
          .dc.b      $00,$0A,$00,$00        ;EWEDIG3
          .dc.b      $00,$01,$00,$00        ;EWEDIG2
          .dc.b      $00,$01,$00,$00        ;EWEDIG1
          .dc.b      $04,$48,$1C,$C0        ;EWELEFT1
          .dc.b      $02,$3B,$44,$00        ;EWELEFT2
          .dc.b      $7F,$FF,$FF,$00        ;EWERITE1
          .dc.b      $3F,$FF,$FF,$00        ;EWERITE2
          .dc.b      $BE,$9E                ;POT
          .dc.b      $02,$76,$80            ;COL1
          .dc.b      $00,$76,$80            ;COL2
          .dc.b      $26,$68                ;TIP1
          .dc.b      $0D,$D8                ;TIP2
          .dc.b      $1D,$D8                ;TIP3
          .dc.b      $00,$00                ;SPSHOTST
          .dc.b      $00,$00,$00,$00        ;BDS1
          .dc.b      $0C,$00,$00,$00        ;BDS2
          .dc.b      $00,$00,$00,$00        ;BDS3
          .dc.b      $00,$00,$00,$00        ;BDS4
          .dc.b      $00,$00,$57,$00        ;BDS5
          .dc.b      $00,$04,$57,$00        ;BDS6
          .dc.b      $00,$00                ;GEM
          .dc.b      $00,$00                ;EGG
          .dc.b      $00,$00,$00            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $C300
          .dc.b      $D6,$80,$03,$F0        ; FMS 13
          .dc.b      $09,$50,$00,$00        ; FUS 13
          .dc.b      $0F,$C0,$2F,$00        ; FDS 13
          .dc.b      $16,$09,$99,$00        ; FMR 13
          .dc.b      $D9,$49,$66,$B0        ; FUR 13
          .dc.b      $00,$02,$C0,$00        ; FDR 13
          .dc.b      $00,$00,$00,$00        ; FML 13
          .dc.b      $00,$00,$00,$00        ; FUL 13
          .dc.b      $00,$00,$00,$00        ; FDL 13
          .dc.b      $16,$40,$00,$00        ; SU  13
          .dc.b      $16,$46,$AF,$00        ; SD  13
          .dc.b      $0D,$30,$00,$00        ; HUS 13
          .dc.b      $D9,$73,$C0,$00        ; HDS 13
          .dc.b      $00,$C0,$00,$00        ; HUR 13
          .dc.b      $01,$55,$00,$00        ; HDR 13
          .dc.b      $00,$95,$70,$00        ; HUL 13
          .dc.b      $00,$95,$F0,$00        ; HDL 13
          .dc.b      $16,$40,$00,$00        ; WS  13
          .dc.b      $00,$95,$00,$00        ; WL  13
          .dc.b      $00,$00,$00,$00        ; WR  13
          .dc.b      $00,$00,$00,$00        ; LU  13
          .dc.b      $0D,$00,$00,$00        ; LD  13
          .dc.b      $0F,$FF,$FF,$00        ; SHAD SU 13
          .dc.b      $0F,$FF,$FF,$F0        ; SHAD SD 13
          .dc.b      $0F,$FF,$FC,$00        ; SHAD HUS 13
          .dc.b      $00,$FF,$FC,$00        ; SHAD HDS 13
          .dc.b      $3F,$FF,$FF,$00        ; SHAD HUR 13
          .dc.b      $FF,$C3,$FC,$00        ; SHAD HDR 13
          .dc.b      $00,$FF,$FC,$00        ; SHAD HUL 13
          .dc.b      $00,$C3,$FC,$00        ; SHAD HDL 13
          .dc.b      $03,$FF,$FF,$F0        ; SHAD LU 13
          .dc.b      $0F,$FF,$FF,$00        ; SHAD LD 13
          .dc.b      $00,$00                ; SHOTAN0
          .dc.b      $00,$00                ; SHOTAN1
          .dc.b      $00,$00                ; SHOTAN2
          .dc.b      $00,$00                ; SHOTAN3
          .dc.b      $31,$7F,$F0,$00        ;EWERUN1
          .dc.b      $31,$7F,$C0,$00        ;EWERUN2
          .dc.b      $00,$17,$F0,$00        ;EWEJUMP
          .dc.b      $00,$31,$00,$00        ;EWEDIG3
          .dc.b      $00,$01,$00,$00        ;EWEDIG2
          .dc.b      $00,$04,$00,$00        ;EWEDIG1
          .dc.b      $0B,$AA,$BC,$00        ;EWELEFT1
          .dc.b      $00,$AA,$8B,$00        ;EWELEFT2
          .dc.b      $17,$7D,$F7,$C0        ;EWERITE1
          .dc.b      $1F,$FB,$EF,$80        ;EWERITE2
          .dc.b      $FF,$F7                ;POT
          .dc.b      $08,$C5,$10            ;COL1
          .dc.b      $1D,$71,$60            ;COL2
          .dc.b      $2D,$B4                ;TIP1
          .dc.b      $1E,$D8                ;TIP2
          .dc.b      $3B,$78                ;TIP3
          .dc.b      $00,$00                ;SPSHOTST
          .dc.b      $00,$00,$00,$00        ;BDS1
          .dc.b      $1C,$00,$00,$00        ;BDS2
          .dc.b      0,0,0,0                ;BDS3
          .dc.b      0,0,0,0                ;BDS4
          .dc.b      $03,$01,$55,$00        ;BDS5
          .dc.b      $10,$01,$55,$00        ;BDS6
          .dc.b      $00,$00                ;GEM
          .dc.b      $00,$00                ;EGG
          .dc.b      $00,$00,$00            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $C400
          .dc.b      $D9,$50,$07,$FC        ; FMS 12
          .dc.b      $09,$5A,$00,$00        ; FUS 12
          .dc.b      $15,$40,$3E,$00        ; FDS 12
          .dc.b      $D9,$49,$A4,$00        ; FMR 12
          .dc.b      $D9,$56,$55,$40        ; FUR 12
          .dc.b      $0C,$06,$90,$00        ; FDR 12
          .dc.b      $00,$00,$00,$00        ; FML 12
          .dc.b      $00,$00,$00,$00        ; FUL 12
          .dc.b      $00,$00,$00,$00        ; FDL 12
          .dc.b      $29,$50,$00,$00        ; SU  12
          .dc.b      $29,$69,$A7,$C0        ; SD  12
          .dc.b      $16,$4C,$00,$00        ; HUS 12
          .dc.b      $05,$7D,$00,$00        ; HDS 12
          .dc.b      $00,$30,$00,$00        ; HUR 12
          .dc.b      $09,$FD,$40,$00        ; HDR 12
          .dc.b      $00,$55,$F0,$00        ; HUL 12
          .dc.b      $03,$55,$E0,$00        ; HDL 12
          .dc.b      $D9,$70,$00,$00        ; WS  12
          .dc.b      $03,$55,$E0,$00        ; WL  12
          .dc.b      $09,$FD,$40,$00        ; WR  12
          .dc.b      $00,$00,$C0,$00        ; LU  12
          .dc.b      $15,$83,$00,$00        ; LD  12
          .dc.b      $03,$FF,$FC,$00        ; SHAD SU 12
          .dc.b      $03,$FF,$FF,$00        ; SHAD SD 12
          .dc.b      $03,$FF,$FF,$00        ; SHAD HUS 12
          .dc.b      $00,$3C,$FC,$00        ; SHAD HDS 12
          .dc.b      $FF,$FF,$FC,$00        ; SHAD HUR 12
          .dc.b      $00,$00,$C0,$00        ; SHAD HDR 12
          .dc.b      $00,$3F,$FF,$00        ; SHAD HUL 12
          .dc.b      $00,$03,$FC,$00        ; SHAD HDL 12
          .dc.b      $00,$FF,$FF,$C0        ; SHAD LU 12
          .dc.b      $03,$FF,$FF,$C0        ; SHAD LD 12
          .dc.b      $00,$00                ; SHOTAN0
          .dc.b      $00,$00                ; SHOTAN1
          .dc.b      $00,$00                ; SHOTAN2
          .dc.b      $02,$00                ; SHOTAN3
          .dc.b      $FF,$EA,$DC,$00        ;EWERUN1
          .dc.b      $FF,$EA,$FC,$00        ;EWERUN2
          .dc.b      $00,$1B,$FC,$00        ;EWEJUMP
          .dc.b      $03,$D9,$C0,$00        ;EWEDIG3
          .dc.b      $01,$B1,$00,$00        ;EWEDIG2
          .dc.b      $01,$00,$30,$00        ;EWEDIG1
          .dc.b      $02,$6A,$48,$C0        ;EWELEFT1
          .dc.b      $00,$EA,$EF,$C0        ;EWELEFT2
          .dc.b      $4D,$FA,$AB,$FC        ;EWERITE1
          .dc.b      $05,$FF,$FF,$F0        ;EWERITE2
          .dc.b      $F5,$5D                ;POT
          .dc.b      $01,$D4,$64            ;COL1
          .dc.b      $21,$C6,$14            ;COL2
          .dc.b      $1E,$46                ;TIP1
          .dc.b      $17,$46                ;TIP2
          .dc.b      $92,$B4                ;TIP3
          .dc.b      $00,$00                ;SPSHOTST
          .dc.b      $0C,$00,$00,$00        ;BDS1
          .dc.b      $23,$00,$00,$00        ;BDS2
          .dc.b      $00,$27,$00,$00        ;BDS3
          .dc.b      $00,$00,$3C,$00        ;BDS4
          .dc.b      $00,$01,$54,$00        ;BDS5
          .dc.b      $00,$05,$54,$00        ;BDS6
          .dc.b      $00,$00                ;GEM
          .dc.b      $00,$00                ;EGG
          .dc.b      $00,$00,$00            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $C500
          .dc.b      $09,$5A,$66,$FC        ; FMS 11
          .dc.b      $00,$56,$60,$00        ; FUS 11
          .dc.b      $D6,$80,$9B,$00        ; FDS 11
          .dc.b      $D9,$56,$64,$00        ; FMR 11
          .dc.b      $01,$55,$94,$00        ; FUR 11
          .dc.b      $34,$09,$90,$00        ; FDR 11
          .dc.b      $00,$00,$00,$00        ; FML 11
          .dc.b      $00,$00,$00,$00        ; FUL 11
          .dc.b      $00,$00,$00,$00        ; FDL 11
          .dc.b      $05,$66,$00,$00        ; SU  11
          .dc.b      $05,$69,$9B,$C0        ; SD  11
          .dc.b      $D9,$6F,$00,$00        ; HUS 11
          .dc.b      $01,$7E,$50,$00        ; HDS 11
          .dc.b      $01,$55,$00,$00        ; HUR 11
          .dc.b      $F6,$F6,$90,$00        ; HDR 11
          .dc.b      $03,$15,$E8,$00        ; HUL 11
          .dc.b      $03,$D5,$E0,$00        ; HDL 11
          .dc.b      $05,$7D,$00,$00        ; WS  11
          .dc.b      $03,$D5,$E0,$00        ; WL  11
          .dc.b      $F6,$F6,$90,$00        ; WR  11
          .dc.b      $0D,$30,$F0,$00        ; LU  11
          .dc.b      $D6,$53,$C0,$00        ; LD  11
          .dc.b      $00,$FF,$C0,$00        ; SHAD SU 11
          .dc.b      $00,$FF,$FC,$00        ; SHAD SD 11
          .dc.b      $00,$CF,$FF,$00        ; SHAD HUS 11
          .dc.b      $00,$0C,$3C,$00        ; SHAD HDS 11
          .dc.b      $0F,$3F,$C0,$00        ; SHAD HUR 11
          .dc.b      $00,$00,$00,$00        ; SHAD HDR 11
          .dc.b      $00,$03,$FF,$00        ; SHAD HUL 11
          .dc.b      $00,$00,$3C,$00        ; SHAD HDL 11
          .dc.b      $03,$FF,$FC,$00        ; SHAD LU 11
          .dc.b      $00,$FF,$FF,$C0        ; SHAD LD 11
          .dc.b      $00,$00                ; SHOTAN0
          .dc.b      $00,$00                ; SHOTAN1
          .dc.b      $02,$00                ; SHOTAN2
          .dc.b      $00,$02                ; SHOTAN3
          .dc.b      $1F,$F6,$BF,$00        ;EWERUN1
          .dc.b      $1E,$F6,$B7,$00        ;EWERUN2
          .dc.b      $0F,$0B,$7F,$00        ;EWEJUMP
          .dc.b      $0B,$69,$B0,$00        ;EWEDIG3
          .dc.b      $01,$26,$A0,$00        ;EWEDIG2
          .dc.b      $31,$00,$10,$00        ;EWEDIG1
          .dc.b      $02,$EA,$EF,$00        ;EWELEFT1
          .dc.b      $0A,$A6,$AF,$00        ;EWELEFT2
          .dc.b      $0A,$AF,$FA,$C0        ;EWERITE1
          .dc.b      $1F,$7A,$AB,$CC        ;EWERITE2
          .dc.b      $EA,$57                ;POT
          .dc.b      $11,$DA,$44            ;COL1
          .dc.b      $48,$5B,$06            ;COL2
          .dc.b      $A3,$75                ;TIP1
          .dc.b      $31,$74                ;TIP2
          .dc.b      $6D,$D6                ;TIP3
          .dc.b      $00,$00                ;SPSHOTST
          .dc.b      $FC,$30,$00,$00        ;BDS1
          .dc.b      $93,$C0,$00,$00        ;BDS2
          .dc.b      $01,$97,$00,$00        ;BDS3
          .dc.b      $00,$00,$FC,$00        ;BDS4
          .dc.b      $03,$15,$54,$00        ;BDS5
          .dc.b      $23,$19,$54,$00        ;BDS6
          .dc.b      $00,$00                ;GEM
          .dc.b      $00,$00                ;EGG
          .dc.b      $00,$00,$00            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $C600
          .dc.b      $00,$56,$66,$90        ; FMS 10
          .dc.b      $00,$95,$99,$00        ; FUS 10
          .dc.b      $D9,$51,$99,$00        ; FDS 10
          .dc.b      $01,$55,$60,$00        ; FMR 10
          .dc.b      $00,$95,$50,$00        ; FUR 10
          .dc.b      $16,$09,$90,$00        ; FDR 10
          .dc.b      $00,$00,$00,$00        ; FML 10
          .dc.b      $33,$00,$00,$00        ; FUL 10
          .dc.b      $00,$00,$00,$00        ; FDL 10
          .dc.b      $09,$56,$B0,$00        ; SU  10
          .dc.b      $09,$59,$99,$00        ; SD  10
          .dc.b      $05,$5F,$C0,$00        ; HUS 10
          .dc.b      $03,$5E,$90,$00        ; HDS 10
          .dc.b      $F6,$7F,$40,$00        ; HUR 10
          .dc.b      $D9,$69,$90,$00        ; HDR 10
          .dc.b      $03,$D5,$98,$00        ; HUL 10
          .dc.b      $03,$95,$90,$00        ; HDL 10
          .dc.b      $01,$7E,$40,$00        ; WS  10
          .dc.b      $03,$95,$90,$00        ; WL  10
          .dc.b      $D9,$69,$90,$00        ; WR  10
          .dc.b      $16,$83,$00,$00        ; LU  10
          .dc.b      $09,$55,$80,$00        ; LD  10
          .dc.b      $03,$3F,$C0,$00        ; SHAD SU 10
          .dc.b      $00,$3F,$C0,$00        ; SHAD SD 10
          .dc.b      $00,$03,$FC,$00        ; SHAD HUS 10
          .dc.b      $00,$00,$3F,$00        ; SHAD HDS 10
          .dc.b      $00,$CF,$00,$00        ; SHAD HUR 10
          .dc.b      $00,$00,$00,$00        ; SHAD HDR 10
          .dc.b      $00,$03,$3F,$00        ; SHAD HUL 10
          .dc.b      $00,$00,$0C,$00        ; SHAD HDL 10
          .dc.b      $0F,$FF,$F0,$00        ; SHAD LU 10
          .dc.b      $00,$3F,$FF,$00        ; SHAD LD 10
          .dc.b      $00,$00                ; SHOTAN0
          .dc.b      $00,$00                ; SHOTAN1
          .dc.b      $80,$08                ; SHOTAN2
          .dc.b      $80,$00                ; SHOTAN3
          .dc.b      $5F,$66,$AD,$C0        ;EWERUN1
          .dc.b      $5E,$66,$AF,$C0        ;EWERUN2
          .dc.b      $07,$FA,$FF,$C0        ;EWEJUMP
          .dc.b      $0A,$89,$A8,$00        ;EWEDIG3
          .dc.b      $01,$09,$A8,$00        ;EWEDIG2
          .dc.b      $04,$00,$01,$00        ;EWEDIG1
          .dc.b      $02,$A6,$AC,$00        ;EWELEFT1
          .dc.b      $02,$AA,$AB,$00        ;EWELEFT2
          .dc.b      $02,$6A,$AA,$94        ;EWERITE1
          .dc.b      $0A,$AF,$FA,$00        ;EWERITE2
          .dc.b      $EF,$F5                ;POT
          .dc.b      $03,$DD,$C1            ;COL1
          .dc.b      $48,$AC,$D1            ;COL2
          .dc.b      $46,$74                ;TIP1
          .dc.b      $36,$9A                ;TIP2
          .dc.b      $35,$B1                ;TIP3
          .dc.b      $00,$00                ;SPSHOTST
          .dc.b      $57,$C0,$F0,$00        ;BDS1
          .dc.b      $5C,$00,$00,$00        ;BDS2
          .dc.b      $05,$5C,$00,$00        ;BDS3
          .dc.b      $00,$05,$70,$00        ;BDS4
          .dc.b      $0F,$D5,$70,$00        ;BDS5
          .dc.b      $0F,$D5,$70,$00        ;BDS6
          .dc.b      $03,$00                ;GEM
          .dc.b      $0F,$F0                ;EGG
          .dc.b      $03,$C0,$00            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $C700
          .dc.b      $00,$95,$9A,$40        ; FMS 9
          .dc.b      $00,$A5,$66,$C0        ; FUS 9
          .dc.b      $09,$59,$94,$00        ; FDS 9
          .dc.b      $00,$95,$50,$00        ; FMR 9
          .dc.b      $00,$65,$5F,$00        ; FUR 9
          .dc.b      $D9,$49,$90,$00        ; FDR 9
          .dc.b      $33,$00,$00,$00        ; FML 9
          .dc.b      $05,$C0,$00,$00        ; FUL 9
          .dc.b      $03,$00,$03,$C0        ; FDL 9
          .dc.b      $1A,$59,$70,$00        ; SU  9
          .dc.b      $0A,$56,$54,$C0        ; SD  9
          .dc.b      $01,$5F,$90,$00        ; HUS 9
          .dc.b      $02,$5D,$A4,$00        ; HDS 9
          .dc.b      $D9,$5E,$90,$00        ; HUR 9
          .dc.b      $02,$5A,$54,$00        ; HDR 9
          .dc.b      $03,$95,$66,$00        ; HUL 9
          .dc.b      $00,$55,$68,$00        ; HDL 9
          .dc.b      $03,$5E,$90,$00        ; WS  9
          .dc.b      $00,$55,$68,$00        ; WL  9
          .dc.b      $02,$5A,$54,$00        ; WR  9
          .dc.b      $D9,$54,$68,$00        ; LU  9
          .dc.b      $01,$56,$FC,$00        ; LD  9
          .dc.b      $0C,$30,$30,$00        ; SHAD SU 9
          .dc.b      $00,$3F,$F0,$00        ; SHAD SD 9
          .dc.b      $00,$00,$FC,$00        ; SHAD HUS 9
          .dc.b      $00,$00,$00,$00        ; SHAD HDS 9
          .dc.b      $00,$00,$00,$00        ; SHAD HUR 9
          .dc.b      $00,$00,$00,$00        ; SHAD HDR 9
          .dc.b      $00,$00,$3F,$00        ; SHAD HUL 9
          .dc.b      $00,$00,$0C,$00        ; SHAD HDL 9
          .dc.b      $3F,$FF,$FF,$00        ; SHAD LU 9
          .dc.b      $00,$0F,$F0,$00        ; SHAD LD 9
          .dc.b      $C0,$00                ; SHOTAN0
          .dc.b      $C0,$00                ; SHOTAN1
          .dc.b      $02,$80                ; SHOTAN2
          .dc.b      $02,$00                ; SHOTAN3
          .dc.b      $2D,$A6,$EB,$C0        ;EWERUN1
          .dc.b      $2D,$A6,$EB,$C0        ;EWERUN2
          .dc.b      $05,$F6,$B7,$00        ;EWEJUMP
          .dc.b      $01,$A6,$AA,$00        ;EWEDIG3
          .dc.b      $31,$02,$5A,$00        ;EWEDIG2
          .dc.b      $00,$00,$00,$00        ;EWEDIG1
          .dc.b      $06,$AA,$AE,$00        ;EWELEFT1
          .dc.b      $02,$A6,$AF,$00        ;EWELEFT2
          .dc.b      $2B,$6A,$AA,$41        ;EWERITE1
          .dc.b      $22,$6A,$AA,$90        ;EWERITE2
          .dc.b      $FA,$5D                ;POT
          .dc.b      $0C,$7C,$10            ;COL1
          .dc.b      $04,$71,$00            ;COL2
          .dc.b      $25,$96                ;TIP1
          .dc.b      $1D,$E5                ;TIP2
          .dc.b      $1B,$74                ;TIP3
          .dc.b      $00,$00                ;SPSHOTST
          .dc.b      $15,$07,$F0,$00        ;BDS1
          .dc.b      $54,$00,$00,$00        ;BDS2
          .dc.b      $05,$FF,$00,$00        ;BDS3
          .dc.b      $00,$15,$40,$00        ;BDS4
          .dc.b      $43,$5D,$70,$00        ;BDS5
          .dc.b      $03,$55,$70,$00        ;BDS6
          .dc.b      $0E,$00                ;GEM
          .dc.b      $3A,$80                ;EGG
          .dc.b      $0F,$B0,$00            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $C800
          .dc.b      $02,$65,$55,$00        ; FMS 8
          .dc.b      $02,$69,$57,$F0        ; FUS 8
          .dc.b      $5A,$56,$54,$00        ; FDS 8
          .dc.b      $02,$A5,$5F,$00        ; FMR 8
          .dc.b      $00,$9B,$4C,$00        ; FUR 8
          .dc.b      $D9,$55,$90,$00        ; FDR 8
          .dc.b      $05,$C0,$00,$00        ; FML 8
          .dc.b      $02,$55,$00,$00        ; FUL 8
          .dc.b      $33,$00,$0F,$C0        ; FDL 8
          .dc.b      $26,$96,$AC,$00        ; SU  8
          .dc.b      $09,$95,$90,$00        ; SD  8
          .dc.b      $0C,$5D,$A4,$00        ; HUS 8
          .dc.b      $00,$96,$64,$00        ; HDS 8
          .dc.b      $05,$5D,$A4,$00        ; HUR 8
          .dc.b      $00,$96,$54,$00        ; HDR 8
          .dc.b      $02,$95,$66,$00        ; HUL 8
          .dc.b      $00,$95,$64,$00        ; HDL 8
          .dc.b      $02,$5D,$A4,$00        ; WS  8
          .dc.b      $00,$95,$64,$00        ; WL  8
          .dc.b      $00,$96,$54,$00        ; WR  8
          .dc.b      $01,$5A,$6B,$C0        ; LU  8
          .dc.b      $0C,$56,$6F,$00        ; LD  8
          .dc.b      $00,$00,$00,$00        ; SHAD SU 8
          .dc.b      $00,$3C,$00,$00        ; SHAD SD 8
          .dc.b      $00,$00,$30,$00        ; SHAD HUS 8
          .dc.b      $00,$00,$00,$00        ; SHAD HDS 8
          .dc.b      $00,$00,$00,$00        ; SHAD HUR 8
          .dc.b      $00,$00,$00,$00        ; SHAD HDR 8
          .dc.b      $00,$00,$0C,$00        ; SHAD HUL 8
          .dc.b      $00,$00,$0C,$00        ; SHAD HDL 8
          .dc.b      $3F,$FF,$F0,$00        ; SHAD LU 8
          .dc.b      $00,$00,$00,$00        ; SHAD LD 8
          .dc.b      $00,$00                ; SHOTAN0
          .dc.b      $00,$C0                ; SHOTAN1
          .dc.b      $0B,$E0                ; SHOTAN2
          .dc.b      $00,$20                ; SHOTAN3
          .dc.b      $2A,$E6,$BA,$00        ;EWERUN1
          .dc.b      $2A,$E6,$BA,$40        ;EWERUN2
          .dc.b      $08,$66,$EF,$C0        ;EWEJUMP
          .dc.b      $01,$AA,$AA,$00        ;EWEDIG3
          .dc.b      $04,$00,$25,$84        ;EWEDIG2
          .dc.b      $00,$00,$00,$04        ;EWEDIG1
          .dc.b      $02,$A6,$AC,$00        ;EWELEFT1
          .dc.b      $02,$A6,$AF,$00        ;EWELEFT2
          .dc.b      $09,$AA,$A5,$80        ;EWERITE1
          .dc.b      $8B,$6A,$AA,$44        ;EWERITE2
          .dc.b      $FA,$97                ;POT
          .dc.b      $27,$33,$00            ;COL1
          .dc.b      $03,$74,$41            ;COL2
          .dc.b      $14,$D8                ;TIP1
          .dc.b      $04,$B9                ;TIP2
          .dc.b      $66,$94                ;TIP3
          .dc.b      $00,$00                ;SPSHOTST
          .dc.b      $25,$59,$C0,$00        ;BDS1
          .dc.b      $56,$70,$00,$00        ;BDS2
          .dc.b      $15,$30,$00,$00        ;BDS3
          .dc.b      $00,$55,$00,$00        ;BDS4
          .dc.b      $03,$55,$74,$00        ;BDS5
          .dc.b      $03,$55,$74,$00        ;BDS6
          .dc.b      $3A,$40                ;GEM
          .dc.b      $EB,$E8                ;EGG
          .dc.b      $3F,$AC,$00            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $C900
          .dc.b      $02,$99,$70,$00        ; FMS 7
          .dc.b      $02,$99,$F3,$FC        ; FUS 7
          .dc.b      $36,$95,$A4,$00        ; FDS 7
          .dc.b      $01,$69,$0C,$00        ; FMR 7
          .dc.b      $00,$A5,$00,$00        ; FUR 7
          .dc.b      $01,$55,$40,$00        ; FDR 7
          .dc.b      $02,$55,$00,$00        ; FML 7
          .dc.b      $00,$56,$40,$00        ; FUL 7
          .dc.b      $05,$C0,$07,$00        ; FDL 7
          .dc.b      $29,$AF,$AC,$00        ; SU  7
          .dc.b      $02,$A5,$7C,$00        ; SD  7
          .dc.b      $0F,$5E,$64,$00        ; HUS 7
          .dc.b      $00,$96,$64,$00        ; HDS 7
          .dc.b      $02,$5A,$69,$00        ; HUR 7
          .dc.b      $00,$25,$A4,$00        ; HDR 7
          .dc.b      $01,$A5,$66,$00        ; HUL 7
          .dc.b      $00,$A5,$64,$00        ; HDL 7
          .dc.b      $00,$96,$64,$00        ; WS  7
          .dc.b      $00,$A5,$64,$00        ; WL  7
          .dc.b      $00,$25,$A4,$00        ; WR  7
          .dc.b      $00,$56,$99,$F0        ; LU  7
          .dc.b      $0F,$59,$9B,$C0        ; LD  7
          .dc.b      $00,$00,$00,$00        ; SHAD SU 7
          .dc.b      $00,$00,$00,$00        ; SHAD SD 7
          .dc.b      $00,$00,$00,$00        ; SHAD HUS 7
          .dc.b      $00,$00,$00,$00        ; SHAD HDS 7
          .dc.b      $00,$00,$00,$00        ; SHAD HUR 7
          .dc.b      $00,$00,$00,$00        ; SHAD HDR 7
          .dc.b      $00,$00,$00,$00        ; SHAD HUL 7
          .dc.b      $00,$00,$00,$00        ; SHAD HDL 7
          .dc.b      $0F,$FC,$00,$00        ; SHAD LU 7
          .dc.b      $00,$00,$00,$00        ; SHAD LD 7
          .dc.b      $0C,$00                ; SHOTAN0
          .dc.b      $0C,$20                ; SHOTAN1
          .dc.b      $0A,$A0                ; SHOTAN2
          .dc.b      $00,$00                ; SHOTAN3
          .dc.b      $06,$9A,$AE,$C0        ;EWERUN1
          .dc.b      $06,$9A,$AE,$C0        ;EWERUN2
          .dc.b      $09,$A6,$BB,$40        ;EWEJUMP
          .dc.b      $01,$A9,$AA,$B0        ;EWEDIG3
          .dc.b      $00,$00,$00,$04        ;EWEDIG2
          .dc.b      $00,$00,$00,$00        ;EWEDIG1
          .dc.b      $02,$A6,$A0,$00        ;EWELEFT1
          .dc.b      $02,$AA,$AB,$00        ;EWELEFT2
          .dc.b      $0A,$A5,$5A,$00        ;EWERITE1
          .dc.b      $09,$AA,$A5,$84        ;EWERITE2
          .dc.b      $BF,$E6                ;POT
          .dc.b      $84,$C6,$21            ;COL1
          .dc.b      $02,$4E,$40            ;COL2
          .dc.b      $13,$51                ;TIP1
          .dc.b      $16,$E0                ;TIP2
          .dc.b      $15,$D5                ;TIP3
          .dc.b      $00,$00                ;SPSHOTST
          .dc.b      $05,$66,$00,$00        ;BDS1
          .dc.b      $59,$7C,$00,$00        ;BDS2
          .dc.b      $14,$9C,$00,$00        ;BDS3
          .dc.b      $31,$55,$59,$C0        ;BDS4
          .dc.b      $C1,$55,$DD,$70        ;BDS5
          .dc.b      $05,$65,$DD,$70        ;BDS6
          .dc.b      $3F,$E0                ;GEM
          .dc.b      $EE,$A8                ;EGG
          .dc.b      $BF,$AB,$00            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $CA00
          .dc.b      $39,$59,$F0,$00        ; FMS 6
          .dc.b      $02,$54,$2C,$FC        ; FUS 6
          .dc.b      $0D,$A5,$50,$00        ; FDS 6
          .dc.b      $02,$94,$00,$00        ; FMR 6
          .dc.b      $00,$59,$00,$00        ; FUR 6
          .dc.b      $06,$95,$50,$00        ; FDR 6
          .dc.b      $3C,$56,$80,$0F        ; FML 6
          .dc.b      $00,$15,$90,$00        ; FUL 6
          .dc.b      $02,$55,$99,$00        ; FDL 6
          .dc.b      $A5,$50,$5C,$00        ; SU  6
          .dc.b      $00,$50,$F0,$00        ; SD  6
          .dc.b      $0E,$96,$69,$00        ; HUS 6
          .dc.b      $00,$25,$90,$00        ; HDS 6
          .dc.b      $02,$96,$99,$00        ; HUR 6
          .dc.b      $00,$05,$64,$00        ; HDR 6
          .dc.b      $00,$65,$66,$00        ; HUL 6
          .dc.b      $00,$15,$58,$00        ; HDL 6
          .dc.b      $00,$96,$64,$00        ; WS  6
          .dc.b      $00,$15,$58,$00        ; WL  6
          .dc.b      $00,$05,$64,$00        ; WR  6
          .dc.b      $01,$95,$A6,$B0        ; LU  6
          .dc.b      $0E,$95,$A6,$40        ; LD  6
          .dc.b      $00,$00,$00,$00        ; SHAD SU 6
          .dc.b      $00,$00,$00,$00        ; SHAD SD 6
          .dc.b      $00,$00,$00,$00        ; SHAD HUS 6
          .dc.b      $00,$00,$00,$00        ; SHAD HDS 6
          .dc.b      $00,$00,$00,$00        ; SHAD HUR 6
          .dc.b      $00,$00,$00,$00        ; SHAD HDR 6
          .dc.b      $00,$00,$00,$00        ; SHAD HUL 6
          .dc.b      $00,$00,$00,$00        ; SHAD HDL 6
          .dc.b      $00,$00,$00,$00        ; SHAD LU 6
          .dc.b      $00,$00,$00,$00        ; SHAD LD 6
          .dc.b      $03,$00                ; SHOTAN0
          .dc.b      $03,$30                ; SHOTAN1
          .dc.b      $0F,$B0                ; SHOTAN2
          .dc.b      $20,$82                ; SHOTAN3
          .dc.b      $06,$AA,$AB,$B0        ;EWERUN1
          .dc.b      $06,$AA,$AB,$B0        ;EWERUN2
          .dc.b      $0A,$E6,$AE,$C0        ;EWEJUMP
          .dc.b      $31,$2A,$5A,$90        ;EWEDIG3
          .dc.b      $00,$00,$00,$04        ;EWEDIG2
          .dc.b      $00,$00,$00,$00        ;EWEDIG1
          .dc.b      $0A,$AA,$A3,$00        ;EWELEFT1
          .dc.b      $03,$A6,$B0,$00        ;EWELEFT2
          .dc.b      $02,$AA,$A8,$00        ;EWERITE1
          .dc.b      $0A,$A5,$5A,$10        ;EWERITE2
          .dc.b      $3F,$FC                ;POT
          .dc.b      $12,$DB,$00            ;COL1
          .dc.b      $01,$1D,$08            ;COL2
          .dc.b      $62,$60                ;TIP1
          .dc.b      $12,$60                ;TIP2
          .dc.b      $19,$89                ;TIP3
          .dc.b      $00,$00                ;SPSHOTST
          .dc.b      $09,$99,$00,$00        ;BDS1
          .dc.b      $59,$BC,$00,$00        ;BDS2
          .dc.b      $15,$40,$00,$00        ;BDS3
          .dc.b      $F5,$57,$D7,$00        ;BDS4
          .dc.b      $01,$57,$15,$70        ;BDS5
          .dc.b      $01,$57,$15,$70        ;BDS6
          .dc.b      $F9,$60                ;GEM
          .dc.b      $EA,$A6                ;EGG
          .dc.b      $2F,$AA,$C0            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $CB00
          .dc.b      $3E,$A4,$2C,$00        ; FMS 5
          .dc.b      $05,$A4,$00,$00        ; FUS 5
          .dc.b      $00,$55,$70,$00        ; FDS 5
          .dc.b      $0A,$64,$00,$00        ; FMR 5
          .dc.b      $00,$29,$00,$00        ; FUR 5
          .dc.b      $39,$A5,$5F,$00        ; FDR 5
          .dc.b      $0D,$95,$98,$FC        ; FML 5
          .dc.b      $00,$25,$60,$00        ; FUL 5
          .dc.b      $00,$56,$54,$00        ; FDL 5
          .dc.b      $DA,$40,$00,$00        ; SU  5
          .dc.b      $00,$00,$00,$00        ; SD  5
          .dc.b      $02,$56,$99,$00        ; HUS 5
          .dc.b      $00,$25,$70,$00        ; HDS 5
          .dc.b      $00,$A5,$99,$00        ; HUR 5
          .dc.b      $00,$01,$5C,$00        ; HDR 5
          .dc.b      $00,$A9,$58,$00        ; HUL 5
          .dc.b      $00,$29,$58,$00        ; HDL 5
          .dc.b      $00,$25,$90,$00        ; WS  5
          .dc.b      $00,$29,$58,$00        ; WL  5
          .dc.b      $00,$01,$5C,$00        ; WR  5
          .dc.b      $0A,$65,$65,$7C        ; LU  5
          .dc.b      $01,$96,$66,$40        ; LD  5
          .dc.b      $00,$00,$00,$00        ; SHAD SU 5
          .dc.b      $00,$00,$00,$00        ; SHAD SD 5
          .dc.b      $00,$00,$00,$00        ; SHAD HUS 5
          .dc.b      $00,$00,$00,$00        ; SHAD HDS 5
          .dc.b      $00,$00,$00,$00        ; SHAD HUR 5
          .dc.b      $00,$00,$00,$00        ; SHAD HDR 5
          .dc.b      $00,$00,$00,$00        ; SHAD HUL 5
          .dc.b      $00,$00,$00,$00        ; SHAD HDL 5
          .dc.b      $00,$00,$00,$00        ; SHAD LU 5
          .dc.b      $00,$00,$00,$00        ; SHAD LD 5
          .dc.b      $00,$F0                ; SHOTAN0
          .dc.b      $30,$F0                ; SHOTAN1
          .dc.b      $03,$C0                ; SHOTAN2
          .dc.b      $00,$00                ; SHOTAN3
          .dc.b      $06,$A6,$AA,$BC        ;EWERUN1
          .dc.b      $06,$A6,$AA,$BC        ;EWERUN2
          .dc.b      $06,$9A,$AB,$F0        ;EWEJUMP
          .dc.b      $04,$0A,$A5,$A4        ;EWEDIG3
          .dc.b      $00,$00,$00,$00        ;EWEDIG2
          .dc.b      $00,$00,$00,$00        ;EWEDIG1
          .dc.b      $00,$A6,$80,$00        ;EWELEFT1
          .dc.b      $00,$A6,$80,$00        ;EWELEFT2
          .dc.b      $01,$2A,$80,$00        ;EWERITE1
          .dc.b      $02,$AA,$A8,$00        ;EWERITE2
          .dc.b      $E5,$5B                ;POT
          .dc.b      $41,$D8,$00            ;COL1
          .dc.b      $07,$5F,$81            ;COL2
          .dc.b      $11,$41                ;TIP1
          .dc.b      $01,$C8                ;TIP2
          .dc.b      $21,$44                ;TIP3
          .dc.b      $02,$80                ;SPSHOTST
          .dc.b      $01,$64,$00,$00        ;BDS1
          .dc.b      $56,$40,$00,$00        ;BDS2
          .dc.b      $16,$00,$00,$00        ;BDS3
          .dc.b      $35,$57,$57,$00        ;BDS4
          .dc.b      $07,$57,$05,$C0        ;BDS5
          .dc.b      $09,$57,$05,$C0        ;BDS6
          .dc.b      $ED,$98                ;GEM
          .dc.b      $EA,$96                ;EGG
          .dc.b      $0A,$6A,$B0            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $CC00
          .dc.b      $3F,$50,$00,$00        ; FMS 4
          .dc.b      $0F,$A4,$00,$00        ; FUS 4
          .dc.b      $00,$00,$F0,$00        ; FDS 4
          .dc.b      $09,$90,$00,$00        ; FMR 4
          .dc.b      $00,$34,$00,$00        ; FUR 4
          .dc.b      $3E,$5A,$4C,$00        ; FDR 4
          .dc.b      $03,$65,$69,$BC        ; FML 4
          .dc.b      $00,$69,$68,$00        ; FUL 4
          .dc.b      $00,$95,$A4,$00        ; FDL 4
          .dc.b      $E9,$00,$00,$00        ; SU  4
          .dc.b      $00,$00,$00,$00        ; SD  4
          .dc.b      $01,$A5,$99,$00        ; HUS 4
          .dc.b      $00,$04,$F0,$00        ; HDS 4
          .dc.b      $00,$25,$65,$00        ; HUR 4
          .dc.b      $00,$00,$7F,$00        ; HDR 4
          .dc.b      $00,$15,$50,$00        ; HUL 4
          .dc.b      $00,$05,$50,$00        ; HDL 4
          .dc.b      $00,$25,$70,$00        ; WS  4
          .dc.b      $00,$05,$50,$00        ; WL  4
          .dc.b      $00,$00,$7F,$00        ; WR  4
          .dc.b      $36,$99,$5F,$00        ; LU  4
          .dc.b      $01,$A5,$99,$00        ; LD  4
          .dc.b      $00,$00,$00,$00        ; SHAD SU 4
          .dc.b      $00,$00,$00,$00        ; SHAD SD 4
          .dc.b      $00,$00,$00,$00        ; SHAD HUS 4
          .dc.b      $00,$00,$00,$00        ; SHAD HDS 4
          .dc.b      $00,$00,$00,$00        ; SHAD HUR 4
          .dc.b      $00,$00,$00,$00        ; SHAD HDR 4
          .dc.b      $00,$00,$00,$00        ; SHAD HUL 4
          .dc.b      $00,$00,$00,$00        ; SHAD HDL 4
          .dc.b      $00,$00,$00,$00        ; SHAD LU 4
          .dc.b      $00,$00,$00,$00        ; SHAD LD 4
          .dc.b      $00,$F0                ; SHOTAN0
          .dc.b      $0B,$F8                ; SHOTAN1
          .dc.b      $20,$02                ; SHOTAN2
          .dc.b      $00,$00                ; SHOTAN3
          .dc.b      $C4,$A9,$6A,$50        ;EWERUN1
          .dc.b      $C4,$A9,$6A,$4C        ;EWERUN2
          .dc.b      $06,$6A,$AA,$8C        ;EWEJUMP
          .dc.b      $00,$00,$A8,$04        ;EWEDIG3
          .dc.b      $00,$00,$00,$00        ;EWEDIG2
          .dc.b      $00,$00,$00,$00        ;EWEDIG1
          .dc.b      $00,$A6,$80,$00        ;EWELEFT1
          .dc.b      $00,$26,$30,$00        ;EWELEFT2
          .dc.b      $0D,$00,$00,$00        ;EWERITE1
          .dc.b      $01,$2A,$80,$00        ;EWERITE2
          .dc.b      $9F,$E5                ;POT
          .dc.b      $0B,$1D,$70            ;COL1
          .dc.b      $03,$7E,$40            ;COL2
          .dc.b      $49,$41                ;TIP1
          .dc.b      $80,$51                ;TIP2
          .dc.b      $00,$64                ;TIP3
          .dc.b      $A0,$A0                ;SPSHOTST
          .dc.b      $02,$64,$00,$00        ;BDS1
          .dc.b      $19,$00,$00,$00        ;BDS2
          .dc.b      $D8,$00,$00,$00        ;BDS3
          .dc.b      $35,$7C,$5C,$00        ;BDS4
          .dc.b      $05,$43,$01,$C0        ;BDS5
          .dc.b      $05,$43,$01,$C0        ;BDS6
          .dc.b      $AE,$94                ;GEM
          .dc.b      $39,$56                ;EGG
          .dc.b      $01,$5A,$90            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $CD00
          .dc.b      $0F,$00,$00,$00        ; FMS 3
          .dc.b      $0F,$D0,$00,$00        ; FUS 3
          .dc.b      $00,$00,$2C,$00        ; FDS 3
          .dc.b      $3E,$90,$00,$00        ; FMR 3
          .dc.b      $00,$3C,$00,$00        ; FUR 3
          .dc.b      $0F,$95,$00,$00        ; FDR 3
          .dc.b      $00,$55,$56,$90        ; FML 3
          .dc.b      $00,$99,$FB,$00        ; FUL 3
          .dc.b      $00,$25,$50,$00        ; FDL 3
          .dc.b      $34,$00,$00,$00        ; SU  3
          .dc.b      $00,$00,$00,$00        ; SD  3
          .dc.b      $00,$65,$64,$00        ; HUS 3
          .dc.b      $00,$00,$BC,$00        ; HDS 3
          .dc.b      $00,$09,$5C,$00        ; HUR 3
          .dc.b      $00,$00,$3C,$00        ; HDR 3
          .dc.b      $00,$00,$70,$00        ; HUL 3
          .dc.b      $00,$00,$70,$00        ; HDL 3
          .dc.b      $00,$04,$F0,$00        ; WS  3
          .dc.b      $00,$00,$70,$00        ; WL  3
          .dc.b      $00,$00,$3C,$00        ; WR  3
          .dc.b      $39,$54,$3C,$00        ; LU  3
          .dc.b      $00,$65,$64,$00        ; LD  3
          .dc.b      $00,$00,$00,$00        ; SHAD SU 3
          .dc.b      $00,$00,$00,$00        ; SHAD SD 3
          .dc.b      $00,$00,$00,$00        ; SHAD HUS 3
          .dc.b      $00,$00,$00,$00        ; SHAD HDS 3
          .dc.b      $00,$00,$00,$00        ; SHAD HUR 3
          .dc.b      $00,$00,$00,$00        ; SHAD HDR 3
          .dc.b      $00,$00,$00,$00        ; SHAD HUL 3
          .dc.b      $00,$00,$00,$00        ; SHAD HDL 3
          .dc.b      $00,$00,$00,$00        ; SHAD LU 3
          .dc.b      $00,$00,$00,$00        ; SHAD LD 3
          .dc.b      $00,$0C                ; SHOTAN0
          .dc.b      $00,$2C                ; SHOTAN1
          .dc.b      $02,$00                ; SHOTAN2
          .dc.b      $00,$20                ; SHOTAN3
          .dc.b      $10,$2A,$96,$24        ;EWERUN1
          .dc.b      $10,$2A,$96,$50        ;EWERUN2
          .dc.b      $04,$96,$AA,$80        ;EWEJUMP
          .dc.b      $00,$00,$00,$10        ;EWEDIG3
          .dc.b      $00,$00,$00,$00        ;EWEDIG2
          .dc.b      $00,$00,$00,$00        ;EWEDIG1
          .dc.b      $00,$26,$00,$00        ;EWELEFT1
          .dc.b      $00,$00,$00,$00        ;EWELEFT2
          .dc.b      $04,$00,$00,$00        ;EWERITE1
          .dc.b      $0D,$00,$00,$00        ;EWERITE2
          .dc.b      $7F,$FD                ;POT
          .dc.b      $44,$DC,$60            ;COL1
          .dc.b      $12,$FF,$40            ;COL2
          .dc.b      $08,$60                ;TIP1
          .dc.b      $40,$10                ;TIP2
          .dc.b      $08,$42                ;TIP3
          .dc.b      $28,$00                ;SPSHOTST
          .dc.b      $00,$90,$00,$00        ;BDS1
          .dc.b      $34,$00,$00,$00        ;BDS2
          .dc.b      $D4,$00,$00,$00        ;BDS3
          .dc.b      $05,$70,$00,$00        ;BDS4
          .dc.b      $3D,$0C,$C3,$00        ;BDS5
          .dc.b      $3D,$0C,$C3,$00        ;BDS6
          .dc.b      $B9,$A4                ;GEM
          .dc.b      $0A,$5A                ;EGG
          .dc.b      $00,$56,$40            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $CE00
          .dc.b      $00,$00,$00,$00        ; FMS 2
          .dc.b      $0F,$80,$00,$00        ; FUS 2
          .dc.b      $00,$00,$00,$00        ; FDS 2
          .dc.b      $3F,$C0,$00,$00        ; FMR 2
          .dc.b      $00,$0C,$00,$00        ; FUR 2
          .dc.b      $00,$00,$00,$00        ; FDR 2
          .dc.b      $00,$00,$F5,$40        ; FML 2
          .dc.b      $03,$E4,$0F,$C0        ; FUL 2
          .dc.b      $00,$09,$F0,$00        ; FDL 2
          .dc.b      $00,$00,$00,$00        ; SU  2
          .dc.b      $00,$00,$00,$00        ; SD  2
          .dc.b      $00,$14,$F0,$00        ; HUS 2
          .dc.b      $00,$00,$00,$00        ; HDS 2
          .dc.b      $00,$00,$7F,$00        ; HUR 2
          .dc.b      $00,$00,$00,$00        ; HDR 2
          .dc.b      $00,$00,$F0,$00        ; HUL 2
          .dc.b      $00,$00,$F0,$00        ; HDL 2
          .dc.b      $00,$00,$BC,$00        ; WS  2
          .dc.b      $00,$00,$F0,$00        ; WL  2
          .dc.b      $00,$00,$00,$00        ; WR  2
          .dc.b      $3A,$90,$00,$00        ; LU  2
          .dc.b      $00,$54,$50,$00        ; LD  2
          .dc.b      $00,$00,$00,$00        ; SHAD SU 2
          .dc.b      $00,$00,$00,$00        ; SHAD SD 2
          .dc.b      $00,$00,$00,$00        ; SHAD HUS 2
          .dc.b      $00,$00,$00,$00        ; SHAD HDS 2
          .dc.b      $00,$00,$00,$00        ; SHAD HUR 2
          .dc.b      $00,$00,$00,$00        ; SHAD HDR 2
          .dc.b      $00,$00,$00,$00        ; SHAD HUL 2
          .dc.b      $00,$00,$00,$00        ; SHAD HDL 2
          .dc.b      $00,$00,$00,$00        ; SHAD LU 2
          .dc.b      $00,$00,$00,$00        ; SHAD LD 2
          .dc.b      $00,$00                ; SHOTAN0
          .dc.b      $00,$00                ; SHOTAN1
          .dc.b      $00,$00                ; SHOTAN2
          .dc.b      $00,$00                ; SHOTAN3
          .dc.b      $00,$02,$A0,$04        ;EWERUN1
          .dc.b      $00,$02,$A0,$10        ;EWERUN2
          .dc.b      $C4,$A5,$6A,$40        ;EWEJUMP
          .dc.b      $00,$00,$00,$00        ;EWEDIG3
          .dc.b      $00,$00,$00,$00        ;EWEDIG2
          .dc.b      $00,$00,$00,$00        ;EWEDIG1
          .dc.b      $00,$01,$00,$00        ;EWELEFT1
          .dc.b      $00,$02,$00,$00        ;EWELEFT2
          .dc.b      $00,$00,$00,$00        ;EWERITE1
          .dc.b      $04,$00,$00,$00        ;EWERITE2
          .dc.b      $5B,$F6                ;POT
          .dc.b      $03,$37,$10            ;COL1
          .dc.b      $01,$ED,$10            ;COL2
          .dc.b      $01,$10                ;TIP1
          .dc.b      $02,$42                ;TIP2
          .dc.b      $00,$80                ;TIP3
          .dc.b      $00,$02                ;SPSHOTST
          .dc.b      $00,$3F,$00,$00        ;BDS1
          .dc.b      $3C,$00,$00,$00        ;BDS2
          .dc.b      $F0,$00,$00,$00        ;BDS3
          .dc.b      $0D,$00,$00,$00        ;BDS4
          .dc.b      $3F,$00,$00,$00        ;BDS5
          .dc.b      $3F,$00,$00,$00        ;BDS6
          .dc.b      $25,$60                ;GEM
          .dc.b      $02,$A8                ;EGG
          .dc.b      $00,$15,$00            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

          ORG     $CF00
          .dc.b      $00,$00,$00,$00        ; FMS 1
          .dc.b      $0F,$00,$00,$00        ; FUS 1
          .dc.b      $00,$00,$00,$00        ; FDS 1
          .dc.b      $0F,$00,$00,$00        ; FMR 1
          .dc.b      $00,$00,$00,$00        ; FUR 1
          .dc.b      $00,$00,$00,$00        ; FDR 1
          .dc.b      $00,$00,$0C,$00        ; FML 1
          .dc.b      $03,$F0,$00,$F0        ; FUL 1
          .dc.b      $00,$00,$0C,$00        ; FDL 1
          .dc.b      $00,$00,$00,$00        ; SU  1
          .dc.b      $00,$00,$00,$00        ; SD  1
          .dc.b      $00,$00,$BC,$00        ; HUS 1
          .dc.b      $00,$00,$00,$00        ; HDS 1
          .dc.b      $00,$00,$3C,$00        ; HUR 1
          .dc.b      $00,$00,$00,$00        ; HDR 1
          .dc.b      $00,$00,$30,$00        ; HUL 1
          .dc.b      $00,$00,$30,$00        ; HDL 1
          .dc.b      $00,$00,$00,$00        ; WS  1
          .dc.b      $00,$00,$30,$00        ; WL  1
          .dc.b      $00,$00,$00,$00        ; WR  1
          .dc.b      $0D,$40,$00,$00        ; LU  1
          .dc.b      $00,$00,$FC,$00        ; LD  1
          .dc.b      $00,$00,$00,$00        ; SHAD SU 1
          .dc.b      $00,$00,$00,$00        ; SHAD SD 1
          .dc.b      $00,$00,$00,$00        ; SHAD HUS 1
          .dc.b      $00,$00,$00,$00        ; SHAD HDS 1
          .dc.b      $00,$00,$00,$00        ; SHAD HUR 1
          .dc.b      $00,$00,$00,$00        ; SHAD HDR 1
          .dc.b      $00,$00,$00,$00        ; SHAD HUL 1
          .dc.b      $00,$00,$00,$00        ; SHAD HDL 1
          .dc.b      $00,$00,$00,$00        ; SHAD LU 1
          .dc.b      $00,$00,$00,$00        ; SHAD LD 1
          .dc.b      $00,$00                ; SHOTAN0
          .dc.b      $00,$00                ; SHOTAN1
          .dc.b      $00,$00                ; SHOTAN2
          .dc.b      $02,$00                ; SHOTAN3
          .dc.b      $00,$00,$00,$10        ;EWERUN1
          .dc.b      $00,$00,$00,$04        ;EWERUN2
          .dc.b      $10,$2A,$56,$60        ;EWEJUMP
          .dc.b      $00,$00,$00,$00        ;EWEDIG3
          .dc.b      $00,$00,$00,$00        ;EWEDIG2
          .dc.b      $00,$00,$00,$00        ;EWEDIG1
          .dc.b      $00,$00,$40,$00        ;EWELEFT1
          .dc.b      $00,$04,$00,$00        ;EWELEFT2
          .dc.b      $00,$00,$00,$00        ;EWERITE1
          .dc.b      $00,$00,$00,$00        ;EWERITE2
          .dc.b      $25,$5B                ;POT
          .dc.b      $03,$77,$10            ;COL1
          .dc.b      $01,$6E,$00            ;COL2
          .dc.b      $00,$20                ;TIP1
          .dc.b      $02,$01                ;TIP2
          .dc.b      $48,$80                ;TIP3
          .dc.b      $00,$80                ;SPSHOTST
          .dc.b      $00,$0C,$00,$00        ;BDS1
          .dc.b      $03,$00,$00,$00        ;BDS2
          .dc.b      $0C,$00,$00,$00        ;BDS3
          .dc.b      $0F,$00,$00,$00        ;BDS4
          .dc.b      $3C,$00,$00,$00        ;BDS5
          .dc.b      $3C,$00,$00,$00        ;BDS6
          .dc.b      $09,$80                ;GEM
          .dc.b      $00,$20                ;EGG
          .dc.b      $00,$04,$00            ;BAR
          .dc.b      $00,$00,$00,$00        ;UWEBLANK

BIRDTU1   EQU     BIRDFUS
BIRDTD    EQU     BIRDFDS
BIRDTU2   EQU     BIRDFUS

;          END
