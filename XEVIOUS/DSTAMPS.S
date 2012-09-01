********** XEVIOUS DIRECT MODE (MOSTLY AIR ENEMIES) STAMPS    9-2-83
* (FORMERLY STMPS2)

****** DO NOT ADD TO THIS FILE WITHOUT MODIFYING TUNES! *************
          GLBL    DSTAMPS
          GLBL    CKAPI,CSHOT,CJARA,CTORKAN,CZOSHI,CZAKATO
          GLBL    CSOLVALU,CBACULA,CTERRAZI,CSIGHT,CSIGHT2
          GLBL    BAR,CSOLBOMB,CTOROID,CSSHOT0,CSSHOT1
          GLBL    CFLUFF0,CFLUFF1,CFLFEXP0,CFLFEXP1
          GLBL    CGZAKATO,CGZAKEXP,CZAKATO3
          GLBL    CTANK0,CTANK1,CAIREXP,CAIREXP4,CBOUNCE
          GLBL    CBZAKATO,CROVER,CCRAT,C3BLANK
          GLBL    CMATOP,CMATOPMD,CMAMID,CMABOTMD,CMABOT
          GLBL    SHE1,SHE2,SHE3,SHE4,SHE5A,SHE6A,SHE5B,SHE6B


DSTAMPS   ORG     $C000               ;MUST BE ON EVEN BOUNDARY FOR HOLY DMA

          DB      0,0,0,0 Red8

          DB      $EA,$95,$55,$5A        MATOP
          DB      $AF,$F5,$55,$FF
          DB      $55,$55,$55,$55
          DB      $50

          DB      $5A,$AA,$AA,$AA        MATOPMID
          DB      $55,$AA,$AA,$AA
          DB      $DA,$AA,$AA,$AA
          DB      $50

          DB      $AA,$EA,$AA,$AA        MAMID
          DB      $95,$95,$55,$7A
          DB      $DA,$AA,$AA,$AA
          DB      $A0

          DB      $AA,$A9,$6A,$96        MABOTMID
          DB      $9A,$A9,$6A,$A9
          DB      $65,$6A,$AA,$AA
          DB      $A0

          DB      $00,$00,$01,$66        MABOT
          DB      $66,$66,$66,$66
          DB      $66,$66,$00,$00
          DB      $00

          DB      $01,$55,$00         ROVER

          DB      0,0,0         SHOT AGAINST BACULA
          DB      0,0,0
          DB      0,0,0

          DB      0,0             TOROID 1
          DB      0,0
          DB      0,0
          DB      0,0

          DB      0                 SPACE JUNK
          DB      0

          DB      0,0,0         TORKAN SHIP P15
          DB      0,0,0         TORKAN 2
          DB      0,0,0         TORKAN 3

          DB      $00,$20,$00         ZOSHI 1    P15
          DB      $00,$08,$00         ZOSHI 2    P15
          DB      $08,$02,$00         ZOSHI 3    P15
          DB      $00,$80,$00         ZOSHI 4    P15

          DB      0,0,0         JARA 1     P15
          DB      0,0,0         JARA 2     P15
          DB      0,0,0         JARA 3     P15
          DB      0,0,0         JARA 4     P15

          DB      $00           ZAKATO BIRTH
          DB      $00
          DB      $00           ZAKATO
          DB      0,0,0         GARU ZAKATO
          DB      0,0,0         GARU ZAKATO EXPLOSION

          DB      $02,$20,$00         KAPI 1
          DB      0,0,0
          DB      0,0,0
          DB      0,0,0

          DB      $00,$A0,$00         TERRAZI 1
          DB      0,0,0
          DB      0,0,0
          DB      0,0,0

          DB      0,0,0,$00   BACULA 1   P15
          DB      0,0,0,$00   BACULA 2   P15
          DB      0,0,0,$00   BACULA 3   P15
          DB      0,0,0,$00   BACULA 4   P15

          DB      $08,$01,$20         AIR EXP 1
          DB      0,0,0
          DB      0,0,0
          DB      0,0,0

          DB      0,0,0         SOLVALU SHOT
          DB      0,0,0
          DB      $00                 ENEMY SHOT
          DB      0,0,0         SPACE JUNK EXP 0
          DB      $00,$00,$0C

          DB      $20,$64,$20         SOLV    P15
          DB      0,0,0         SIGHT
          DB      0,0,0         SIGHT2
          DB      $00                 BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      0,0,0         3 BYTE BLANK
          DB      $00,$00             CRATER

SHE1      DB      $00,$00,0 SHE1L0
SHE2      DB      $00,$00,0 SHE2L0
SHE3      DB      $00,$00,0 SHE3L0
SHE4      DB      $00,$00,0 SHE4L0
SHE5A     DB      $00,$00,0 SHE5AL0
SHE6A     DB      $00,$00,0 SHE6AL0
SHE5B     DB      $00,$00,0 SHE5BL0
SHE6B     DB      $80,$00,0 SHE6BL0
CTANK0    DB      $00,$00 ;T0L0
CTANK1    DB      $00,$00 ;T1L0

          ORG     DSTAMPS+$0100

          DB      $00,$00,$00,$00 Red8

          DB      $FA,$AA,$AA,$9A        MATOP
          DB      $AA,$A6,$AA,$AA
          DB      $9A,$5A,$AA,$AA
          DB      $A0

          DB      $FF,$FF,$FF,$FD        MATOPMID
          DB      $55,$6A,$AA,$A9
          DB      $DA,$AA,$AA,$AA
          DB      $A0

          DB      $95,$5F,$FF,$FF        MAMID
          DB      $D6,$95,$55,$7E
          DB      $D6,$AA,$95,$55
          DB      $50

          DB      $55,$55,$55,$5D        MABOTMID
          DB      $57,$E9,$56,$A9
          DB      $57,$55,$55,$55
          DB      $50

          DB      $00,$00,$07,$EA        MABOT
          DB      $A9,$55,$55,$56
          DB      $AA,$A9,$40,$00
          DB      $00

          DB      $0F,$A9,$00         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $00,$00             TOROID 1
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00

          DB      $00                 SPACE JUNK
          DB      $00

          DB      $08,$48,$00         TORKAN SHIP P14
          DB      $08,$08,$00         TORKAN 2
          DB      $08,$08,$00         TORKAN 3

          DB      $00,$50,$00         ZOSHI 1    P14
          DB      $20,$54,$00         ZOSHI 2    P14
          DB      $01,$54,$00         ZOSHI 3    P14
          DB      $00,$50,$80         ZOSHI 4    P14

          DB      $00,$D0,$00         JARA 1     P14
          DB      $00,$D0,$00         JARA 2     P14
          DB      $00,$30,$00         JARA 3     P14
          DB      $00,$D0,$00         JARA 4     P14

          DB      $00                 ZAKATO BIRTH
          DB      $00
          DB      $00                 ZAKATO
          DB      $00,$00,$00         GARU ZAKATO
          DB      $0B,$0E,$00         GARU ZAKATO EXPLOSION

          DB      $02,$20,$00         KAPI 1
          DB      $00,$00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $02,$A8,$00         TERRAZI 1
          DB      $00,$00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $2A,$AA,$AA,$A8      BACULA 1   P14
          DB      $00,$00,$00,$00   BACULA 2   P14
          DB      $00,$00,$00,$00   BACULA 3   P14
          DB      $00,$00,$00,$00   BACULA 4   P14

          DB      $41,$00,$80         AIR EXP 1
          DB      $20,$40,$00
          DB      $03,$00,$00
          DB      $00,$08,$C0

          DB      $00,$00,$00         SOLVALU SHOT
          DB      $00,$00,$00
          DB      $00                 ENEMY SHOT
          DB      $00,$00,$00         SPACE JUNK EXP 0
          DB      $00,$00,$00

          DB      $26,$E6,$60         SOLV    P14
          DB      $05,$01,$40         SOLV SIGHT
          DB      $00,$00,$00         SOLV SIGHT2
          DB      $00                 BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $01,$50             CRATER

          DB      $00,$00,0 SHE1L1
          DB      $00,$00,0 SHE2L1
          DB      $00,$80,0 SHE3L1
          DB      $00,$00,0 SHE4L1
          DB      $02,$00,0 SHE5AL1
          DB      $00,$80,0 SHE6AL1
          DB      $08,$00,0 SHE5BL1
          DB      $80,$00,0 SHE6BL1
          DB      $50,$14 ;T0L1
          DB      $D0,$1C ;T1L1


          ORG     DSTAMPS+$0200

          DB      $00,$00,$00,$00 Red8

          DB      $3A,$A5,$55,$6A        MATOP
          DB      $BF,$F5,$55,$FF
          DB      $D6,$55,$6A,$AA
          DB      $80

          DB      $EA,$AA,$AA,$A5        MATOPMID
          DB      $55,$55,$55,$56
          DB      $95,$7F,$AA,$AA
          DB      $90

          DB      $AA,$AA,$EA,$AA        MAMID
          DB      $96,$75,$55,$DE
          DB      $DA,$AA,$AA,$AA
          DB      $A0

          DB      $E6,$AA,$55,$5A        MABOTMID
          DB      $56,$A9,$5A,$A5
          DB      $95,$5A,$AA,$AA
          DB      $A0

          DB      $00,$00,$2A,$AA        MABOT
          DB      $A9,$AA,$AA,$AA
          DB      $AA,$A6,$A0,$00
          DB      $00

          DB      $1A,$A9,$40         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $02,$80             TOROID 1
          DB      $02,$80
          DB      $02,$80
          DB      $02,$80

          DB      $00                 SPACE JUNK
          DB      $00

          DB      $29,$5A,$00         TORKAN SHIP P13
          DB      $28,$0A,$00         TORKAN 2
          DB      $28,$8A,$00         TORKAN 3

          DB      $29,$54,$80         ZOSHI 1    P13
          DB      $09,$54,$00         ZOSHI 2    P13
          DB      $01,$54,$00         ZOSHI 3    P13
          DB      $01,$55,$80         ZOSHI 4    P13

          DB      $00,$A0,$00         :JARA 1     P13
          DB      $00,$E0,$00         JARA 2     P13
          DB      $00,$34,$00         JARA 3     P13
          DB      $00,$A0,$00         JARA 4     P13

          DB      $00                 ZAKATO BIRTH
          DB      $00
          DB      $00                 ZAKATO
          DB      $00,$00,$00         GARU ZAKATO
          DB      $2C,$F3,$80         GARU ZAKATO EXPLOSION

          DB      $02,$20,$00         KAPI 1
          DB      $00,$00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $0E,$5A,$00         TERRAZI 1
          DB      $02,$58,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $2A,$AA,$AA,$A8      BACULA 1   P13
          DB      $00,$00,$00,$00   BACULA 2   P13
          DB      $00,$00,$00,$00   BACULA 3   P13
          DB      $00,$00,$00,$00   BACULA 4   P13

          DB      $10,$00,$40         AIR EXP 1
          DB      $0D,$B1,$C0
          DB      $08,$03,$00
          DB      $02,$00,$00

          DB      $00,$00,$00         SOLVALU SHOT
          DB      $00,$00,$00
          DB      $00                 ENEMY SHOT
          DB      $00,$00,$00         SPACE JUNK EXP 0
          DB      $30,$00,$C0

          DB      $26,$E6,$60         SOLV    P13
          DB      $15,$01,$50         SOLV SIGHT
          DB      $00,$00,$00         SOLV SIGHT2
          DB      $00                 BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $10,$04                CRATER

          DB      $00,$00,0 SHE1L2
          DB      $00,$A0,0 SHE2L2
          DB      $02,$A0,0 SHE3L2
          DB      $28,$00,0 SHE4L2
          DB      $02,$00,0 SHE5AL2
          DB      $02,$80,0 SHE6AL2
          DB      $08,$00,0 SHE5BL2
          DB      $A0,$00,0 SHE6BL2
          DB      $D7,$5C ;T0L2
          DB      $57,$54 ;T1L2


          ORG     DSTAMPS+$0300

          DB      $00,$00,$00,$00 Red8

          DB      $3E,$AA,$AA,$6A        MATOP
          DB      $AA,$A6,$AA,$AA
          DB      $A6,$96,$AA,$AA
          DB      $80

          DB      $FF,$FF,$FF,$D5        MATOPMID
          DB      $55,$55,$55,$56
          DB      $55,$5A,$AA,$AA
          DB      $A0

          DB      $95,$55,$5F,$FF        MAMID
          DB      $D6,$55,$55,$5E
          DB      $D6,$A5,$55,$55
          DB      $50

          DB      $FD,$55,$55,$75        MABOTMID
          DB      $55,$F9,$56,$A5
          DB      $55,$D5,$5A,$A6
          DB      $90

          DB      $00,$00,$55,$FA        MABOT
          DB      $A9,$55,$55,$56
          DB      $AA,$A6,$A8,$00
          DB      $00

          DB      $39,$9A,$40         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $0A,$A0             TOROID 1
          DB      $02,$80
          DB      $01,$40
          DB      $03,$80

          DB      $00                 SPACE JUNK
          DB      $00

          DB      $99,$55,$80         TORKAN SHIP P12
          DB      $98,$05,$80         TORKAN 2
          DB      $9B,$A5,$80         TORKAN 3

          DB      $06,$A9,$40         ZOSHI 1    P12
          DB      $06,$A9,$20         ZOSHI 2    P12
          DB      $06,$A9,$00         ZOSHI 3    P12
          DB      $86,$A9,$00         ZOSHI 4    P12

          DB      $00,$A0,$00         JARA 1     P12
          DB      $00,$E0,$00         JARA 2     P12
          DB      $00,$34,$00         JARA 3     P12
          DB      $00,$A0,$00         JARA 4     P12

          DB      $00                 ZAKATO BIRTH
          DB      $00
          DB      $00                 ZAKATO
          DB      $02,$58,$00         GARU ZAKATO
          DB      $32,$08,$C0         GARU ZAKATO EXPLOSION

          DB      $0A,$28,$00         KAPI 1
          DB      $00,$00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $39,$56,$80         TERRAZI 1
          DB      $0F,$FA,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $2A,$AA,$AA,$A8      BACULA 1   P12
          DB      $00,$00,$00,$00   BACULA 2   P12
          DB      $00,$00,$00,$00   BACULA 3   P12
          DB      $55,$55,$55,$55      BACULA 4   P12

          DB      $00,$80,$40         AIR EXP 1
          DB      $09,$67,$00
          DB      $02,$C0,$00
          DB      $30,$C0,$00

          DB      $00,$00,$00         SOLVALU SHOT
          DB      $00,$00,$00
          DB      $00                 ENEMY SHOT
          DB      $00,$C0,$30         SPACE JUNK EXP 0
          DB      $00,$00,$00

          DB      $26,$D6,$60         SOLV    P12
          DB      $10,$30,$10         SOLV SIGHT
          DB      $00,$20,$00         SOLV SIGHT2
          DB      $00                 BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $05,$41                CRATER

          DB      $AA,$AC,0 SHE1L3
          DB      $0A,$70,0 SHE2L3
          DB      $02,$A0,0 SHE3L3
          DB      $26,$80,0 SHE4L3
          DB      $0A,$80,0 SHE5AL3
          DB      $02,$80,0 SHE6AL3
          DB      $2A,$00,0 SHE5BL3
          DB      $A0,$00,0 SHE6BL3
          DB      $5E,$94 ;T0L3
          DB      $DE,$9C ;T1L3

          ORG     DSTAMPS+$0400

          DB      $00,$00,$00,$00 Red8

          DB      $0E,$AA,$55,$AA        MATOP
          DB      $FF,$D5,$55,$7F
          DB      $F5,$55,$55,$55
          DB      $00

          DB      $EA,$AA,$AA,$5E        MATOPMID
          DB      $A9,$55,$55,$5F
          DB      $AA,$57,$FA,$AA
          DB      $90

          DB      $BB,$BB,$B9,$EA        MAMID
          DB      $96,$55,$A5,$5E
          DB      $DA,$9E,$EE,$EE
          DB      $E0

          DB      $EA,$56,$A5,$65        MABOTMID
          DB      $55,$AA,$5A,$95
          DB      $55,$56,$AA,$AA
          DB      $A0

          DB      $00,$02,$AA,$AA        MABOT
          DB      $AA,$6A,$AA,$AA
          DB      $AA,$9A,$AA,$00
          DB      $00

          DB      $66,$9A,$50         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $29,$68                TOROID 1
          DB      $0A,$60
          DB      $02,$80
          DB      $09,$A0

          DB      $00                 SPACE JUNK
          DB      $00

          DB      $99,$55,$80         TORKAN SHIP P11
          DB      $98,$05,$80         TORKAN 2
          DB      $9B,$A5,$80         TORKAN 3

          DB      $0A,$5A,$00         ZOSHI 1    P11
          DB      $0A,$5A,$60         ZOSHI 2    P11
          DB      $DA,$5A,$40         ZOSHI 3    P11
          DB      $1A,$5A,$00         ZOSHI 4    P11

          DB      $00,$A0,$00         JARA 1     P11
          DB      $00,$E0,$00         JARA 2     P11
          DB      $00,$14,$00         JARA 3     P11
          DB      $00,$A0,$00         JARA 4     P11

          DB      $00                 ZAKATO BIRTH
          DB      $00
          DB      $00                 ZAKATO
          DB      $0A,$5A,$00         GARU ZAKATO
          DB      $AC,$F3,$A0         GARU ZAKATO EXPLOSION

          DB      $0A,$28,$00         KAPI 1
          DB      $00,$00,$00
          DB      $00,$00,$00
          DB      $02,$A0,$00

          DB      $39,$56,$80         TERRAZI 1
          DB      $39,$56,$80
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $2A,$AA,$AA,$A8      BACULA 1   P11
          DB      $05,$55,$55,$50   BACULA 2   P11
          DB      $00,$00,$00,$00   BACULA 3   P11
          DB      $55,$55,$55,$55      BACULA 4   P11

          DB      $04,$51,$00         AIR EXP 1
          DB      $35,$55,$00
          DB      $01,$26,$00
          DB      $00,$00,$20

          DB      $00,$00,$00         SOLVALU SHOT
          DB      $00,$00,$00
          DB      $00                 ENEMY SHOT
          DB      $00,$00,$00         SPACE JUNK EXP 0
          DB      $00,$00,$00

          DB      $26,$E6,$60         SOLV    P11
          DB      $10,$30,$10         SOLV SIGHT
          DB      $00,$20,$00         SOLV SIGHT2
          DB      $00                 BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $10,$54                CRATER

          DB      $95,$7C,0 SHE1L4
          DB      $A5,$70,0 SHE2L4
          DB      $09,$98,0 SHE3L4
          DB      $25,$6C,0 SHE4L4
          DB      $0A,$80,0 SHE5AL4
          DB      $09,$80,0 SHE6AL4
          DB      $2A,$00,0 SHE5BL4
          DB      $98,$00,0 SHE6BL4
          DB      $DE,$9C ;T0L4
          DB      $5E,$94 ;T1L4

          ORG     DSTAMPS+$0500

          DB      $00,$00,$00,$00 Red8

          DB      $0F,$AA,$AA,$AA        MATOP
          DB      $AA,$9A,$AA,$AA
          DB      $A9,$A5,$AA,$AA
          DB      $00

          DB      $FF,$FF,$FE,$AD        MATOPMID
          DB      $69,$6A,$AA,$BF
          DB      $5A,$5A,$AA,$AA
          DB      $A0

          DB      $95,$55,$55,$5F        MAMID
          DB      $D6,$5A,$AA,$5E
          DB      $D5,$55,$55,$55
          DB      $50

          DB      $FF,$D5,$55,$DE        MABOTMID
          DB      $A9,$7F,$5F,$D7
          DB      $AA,$75,$55,$6A
          DB      $90

          DB      $00,$05,$55,$7E        MABOT
          DB      $AA,$55,$55,$5A
          DB      $AA,$95,$55,$40
          DB      $00

          DB      $F6,$A6,$90         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $25,$58                TOROID 1
          DB      $09,$50
          DB      $02,$80
          DB      $0D,$60

          DB      $00                 SPACE JUNK
          DB      $00

          DB      $A9,$56,$80         TORKAN SHIP P10
          DB      $A8,$86,$80         TORKAN 2
          DB      $AB,$A6,$80         TORKAN 3

          DB      $29,$A6,$40         ZOSHI 1    P10
          DB      $69,$A6,$40         ZOSHI 2    P10
          DB      $29,$A6,$A0         ZOSHI 3    P10
          DB      $29,$A6,$40         ZOSHI 4    P10

          DB      $30,$50,$C0         JARA 1     P10
          DB      $0F,$6A,$00         JARA 2     P10
          DB      $00,$D4,$00         JARA 3     P10
          DB      $0F,$9F,$00         JARA 4     P10

          DB      $00                 ZAKATO BIRTH
          DB      $00
          DB      $00                 ZAKATO
          DB      $06,$A9,$00         GARU ZAKATO
          DB      $C3,$0C,$30         GARU ZAKATO EXPLOSION

          DB      $0A,$28,$00         KAPI 1
          DB      $00,$00,$00
          DB      $00,$00,$00
          DB      $A6,$A6,$80

          DB      $E9,$A6,$A0         TERRAZI 1
          DB      $D9,$56,$60
          DB      $00,$A0,$00
          DB      $06,$A9,$00

          DB      $2A,$AA,$AA,$A8      BACULA 1   P10
          DB      $05,$55,$55,$50   BACULA 2   P10
          DB      $00,$00,$00,$00   BACULA 3   P10
          DB      $FF,$FF,$FF,$FF      BACULA 4   P10

          DB      $11,$55,$00         AIR EXP 1
          DB      $65,$96,$80
          DB      $03,$CA,$00
          DB      $00,$22,$00

          DB      $00,$00,$00         SOLVALU SHOT
          DB      $00,$00,$00
          DB      $00                 ENEMY SHOT
          DB      $00,$00,$C0         SPACE JUNK EXP 0
          DB      $00,$00,$00

          DB      $26,$E6,$60         SOLV    P10
          DB      $10,$30,$10         SOLV SIGHT
          DB      $00,$20,$00         SOLV SIGHT2
          DB      $00                 BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $14,$44                CRATER

          DB      $A5,$7C,0 SHE1L5
          DB      $A5,$EC,0 SHE2L5
          DB      $09,$98,0 SHE3L5
          DB      $29,$7C,0 SHE4L5
          DB      $26,$40,0 SHE5AL5
          DB      $09,$80,0 SHE6AL5
          DB      $19,$80,0 SHE5BL5
          DB      $98,$00,0 SHE6BL5
          DB      $5D,$94 ;T0L5
          DB      $DD,$9C ;T1L5

          ORG     DSTAMPS+$0600

          DB      $05,$00,$00,$00 Red8

          DB      $03,$AA,$A6,$AB        MATOP
          DB      $FF,$D5,$55,$7F
          DB      $FD,$A9,$6A,$A8
          DB      $00

          DB      $EA,$AA,$AA,$AD        MATOPMID
          DB      $69,$7F,$FF,$FF
          DB      $5A,$5A,$BF,$AA
          DB      $90

          DB      $AA,$AA,$A5,$56        MAMID
          DB      $96,$56,$F9,$5E
          DB      $D9,$55,$AA,$AA
          DB      $A0

          DB      $EA,$A5,$69,$AD        MABOTMID
          DB      $69,$6A,$AA,$BF
          DB      $5A,$55,$AA,$AA
          DB      $A0

          DB      $00,$2A,$AA,$AA        MABOT
          DB      $AA,$5A,$AA,$AA
          DB      $AA,$6A,$AA,$80
          DB      $00

          DB      $DA,$A5,$90         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $A4,$1A                TOROID 1
          DB      $28,$18
          DB      $02,$80             TOROID 3
          DB      $24,$28

          DB      $00                 SPACE JUNK
          DB      $00

          DB      $AB,$A6,$80         TORKAN SHIP P9
          DB      $AA,$A6,$80         TORKAN 2
          DB      $AB,$A6,$80         TORKAN 3

          DB      $6A,$A9,$80         ZOSHI 1    P9
          DB      $EA,$A9,$80         ZOSHI 2    P9
          DB      $2A,$A9,$A0         ZOSHI 3    P9
          DB      $2A,$A9,$A0         ZOSHI 4    P9

          DB      $20,$50,$80         JARA 1     P9
          DB      $0E,$65,$00         JARA 2     P9
          DB      $03,$B4,$00         JARA 3     P9
          DB      $0F,$96,$00         JARA 4     P9

          DB      $00                 ZAKATO BIRTH
          DB      $00
          DB      $00                 ZAKATO
          DB      $26,$59,$80         GARU ZAKATO
          DB      $2C,$03,$80         GARU ZAKATO EXPLOSION

          DB      $2A,$2A,$00         KAPI 1
          DB      $02,$20,$00
          DB      $00,$00,$00
          DB      $96,$A5,$80

          DB      $DB,$A6,$60         TERRAZI 1
          DB      $F9,$A6,$E0
          DB      $0E,$5A,$00
          DB      $D6,$A9,$60

          DB      $2A,$AA,$AA,$A8      BACULA 1   P9
          DB      $15,$55,$55,$54      BACULA 2   P9
          DB      $00,$00,$00,$00   BACULA 3   P9
          DB      $FF,$FF,$FF,$FF      BACULA 4   P9

          DB      $01,$54,$00         AIR EXP 1
          DB      $17,$35,$C0
          DB      $30,$B9,$00
          DB      $C2,$00,$C0

          DB      $00,$00,$00         SOLVALU SHOT
          DB      $00,$00,$00
          DB      $00                 ENEMY SHOT
          DB      $03,$00,$00         SPACE JUNK EXP 0
          DB      $03,$00,$0C

          DB      $29,$E5,$A0         SOLV    P9
          DB      $00,$00,$00         SOLV SIGHT
          DB      $00,$00,$00         SOLV SIGHT2
          DB      $00                 BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $44,$11                CRATER

          DB      $A9,$3C,0 SHE1L6
          DB      $99,$DC,0 SHE2L6
          DB      $25,$96,0 SHE3L6
          DB      $99,$DC,0 SHE4L6
          DB      $29,$60,0 SHE5AL6
          DB      $25,$80,0 SHE6AL6
          DB      $96,$80,0 SHE5BL6
          DB      $96,$00,0 SHE6BL6
          DB      $DD,$9C ;T0L6
          DB      $5D,$94 ;T1L6

          ORG     DSTAMPS+$0700

          DB      $15,$40,$03,$C0 Red8

          DB      $03,$EA,$AA,$AA        MATOP
          DB      $AA,$9A,$AA,$AA
          DB      $AA,$6A,$AA,$A8
          DB      $00

          DB      $FF,$FF,$EA,$AD        MATOPMID
          DB      $59,$6A,$5A,$BF
          DB      $56,$56,$AA,$AA
          DB      $A0

          DB      $95,$55,$55,$57        MAMID
          DB      $D6,$5B,$FE,$5E
          DB      $D5,$55,$55,$55
          DB      $50

          DB      $FF,$FD,$55,$5D        MABOTMID
          DB      $69,$55,$55,$7F
          DB      $5A,$55,$56,$AA
          DB      $90

          DB      $00,$15,$55,$5F        MABOT
          DB      $AA,$55,$55,$5A
          DB      $AA,$6A,$AA,$A0
          DB      $00

          DB      $DA,$A9,$90         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $00,$00,$00
          DB      $C0,$00,$C0

          DB      $90,$06                TOROID 1
          DB      $28,$18
          DB      $02,$80             TOROID 3
          DB      $24,$28

          DB      $00                 SPACE JUNK
          DB      $00

          DB      $96,$A5,$80         TORKAN SHIP P8
          DB      $97,$A5,$80         TORKAN 2
          DB      $96,$A5,$80         TORKAN 3

          DB      $EE,$B9,$90         ZOSHI 1    P8
          DB      $2E,$B9,$80         ZOSHI 2    P8
          DB      $2E,$B9,$80         ZOSHI 3    P8
          DB      $6E,$B9,$A0         ZOSHI 4    P8

          DB      $20,$E0,$80         JARA 1     P8
          DB      $0E,$E5,$00         JARA 2     P8
          DB      $03,$A4,$00         JARA 3     P8
          DB      $0F,$B6,$00         JARA 4     P8

          DB      $00                 ZAKATO EXPLOSION
          DB      $00
          DB      $00                 ZAKATO
          DB      $19,$56,$40         GARU ZAKATO
          DB      $CC,$03,$30         GARU ZAKATO EXPLOSION

          DB      $26,$66,$00         KAPI 1
          DB      $0A,$68,$00
          DB      $00,$00,$00
          DB      $EA,$6A,$80

          DB      $FB,$A6,$E0         TERRAZI 1
          DB      $FB,$A6,$E0
          DB      $EA,$AA,$A0
          DB      $E6,$A9,$A0

          DB      $2A,$AA,$AA,$A8      BACULA 1   P8
          DB      $15,$55,$55,$54      BACULA 2   P8
          DB      $AA,$AA,$AA,$AA      BACULA 3   P8
          DB      $FF,$FF,$FF,$FF      BACULA 4   P8

          DB      $01,$65,$00         AIR EXP 1
          DB      $16,$E9,$40
          DB      $01,$B6,$00
          DB      $00,$08,$00

          DB      $00,$00,$00         SOLVALU SHOT
          DB      $00,$00,$00
          DB      $00                 ENEMY SHOT
          DB      $00,$30,$00         SPACE JUNK EXP 0
          DB      $00,$00,$00

          DB      $0A,$E6,$80         SOLV    P8
          DB      $0F,$03,$C0         SOLV SIGHT
          DB      $0A,$02,$80         SOLV SIGHT2
          DB      $00                 BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $54,$01                CRATER

          DB      $9B,$DC,0 SHE1L7
          DB      $97,$5C,0 SHE2L7
          DB      $25,$96,0 SHE3L7
          DB      $97,$5C,0 SHE4L7
          DB      $29,$60,0 SHE5AL7
          DB      $25,$80,0 SHE6AL7
          DB      $96,$B0,0 SHE5BL7
          DB      $96,$00,0 SHE6BL7
          DB      $5D,$94 ;T0L7
          DB      $DD,$9C ;T1L7

          ORG     DSTAMPS+$0800

          DB      $15,$40,$0F,$F0 Red8

          DB      $00,$EA,$AA,$AF        MATOP
          DB      $FF,$55,$55,$5F
          DB      $FF,$55,$55,$50
          DB      $00

          DB      $EA,$AA,$AA,$AD        MATOPMID
          DB      $59,$7F,$5F,$FF
          DB      $56,$55,$57,$FA
          DB      $90

          DB      $BB,$BB,$BB,$56        MAMID
          DB      $96,$57,$FD,$5E
          DB      $D9,$5E,$EE,$EE
          DB      $E0

          DB      $EA,$AA,$56,$AD        MABOTMID
          DB      $59,$55,$55,$7F
          DB      $56,$5A,$AA,$AA
          DB      $A0

          DB      $00,$AA,$AA,$AA        MABOT
          DB      $AA,$96,$AA,$AA
          DB      $A9,$A6,$AA,$A0
          DB      $00

          DB      $FE,$AA,$90         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $91,$46                TOROID 1
          DB      $29,$48
          DB      $02,$80             TOROID 3
          DB      $21,$68

          DB      $00                 SPACE JUNK
          DB      $00

          DB      $BF,$AF,$80         TORKAN SHIP P7
          DB      $BF,$AF,$80         TORKAN2
          DB      $BF,$AF,$80         TORKAN 3

          DB      $2E,$69,$A0         ZOSHI 1    P7
          DB      $2E,$69,$90         ZOSHI 2    P7
          DB      $2E,$69,$80         ZOSHI 3    P7
          DB      $EE,$69,$80         ZOSHI 4    P7

          DB      $20,$E0,$80         JARA 1     P7
          DB      $0E,$E5,$00         JARA 2     P7
          DB      $03,$A4,$00         JARA 3     P7
          DB      $0F,$B6,$00         JARA 4     P7

          DB      $29,$5A,$00         KAPI 1
          DB      $2A,$6A,$00
          DB      $00,$00,$00
          DB      $2A,$6A,$00

          DB      $00                 ZAKATO BIRTH
          DB      $00
          DB      $00                 ZAKATO
          DB      $19,$A6,$40         GARU ZAKATO
          DB      $38,$02,$C0         GARU ZAKATO EXPLOSION

          DB      $FB,$A6,$E0         TERRAZI 1
          DB      $D7,$A5,$60
          DB      $3D,$55,$80
          DB      $EA,$AA,$A0

          DB      $2A,$AA,$AA,$A8      BACULA 1   P7
          DB      $55,$55,$55,$55      BACULA 2   P7
          DB      $AA,$AA,$AA,$AA      BACULA 3   P7
          DB      $3F,$FF,$FF,$FC      BACULA 4   P7

          DB      $20,$55,$00         AIR EXP 1
          DB      $5A,$F5,$80
          DB      $07,$82,$30
          DB      $32,$00,$C0

          DB      $00,$00,$00         SOLVALU SHOT
          DB      $00,$00,$00
          DB      $00                 ENEMY SHOT
          DB      $00,$0B,$00         SPACE JUNK EXP 0
          DB      $00,$00,$00

          DB      $0A,$E6,$80         SOLV    P7
          DB      $0F,$03,$C0         SOLV SIGHT
          DB      $0A,$02,$80         SOLV SIGHT2
          DB      $00                 BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $50,$00             CRATER

          DB      $97,$5C,0 SHE1L8
          DB      $9B,$DC,0 SHE2L8
          DB      $AA,$FF,$C0 SHE3L8      PPPP
          DB      $9F,$9C,0 SHE4L8
          DB      $BF,$FC,0 SHE5AL8
          DB      $AA,$C0,0 SHE6AL8
          DB      $FF,$E0,0 SHE5BL8
          DB      $FF,$C0,0 SHE6BL8
          DB      $D5,$5C ;T0L8
          DB      $55,$54 ;T1L8

          ORG     DSTAMPS+$0900

          DB      $5A,$50,$0F,$F0 Red8

          DB      $00,$FA,$AA,$AA        MATOP
          DB      $AA,$6A,$AA,$AA
          DB      $AA,$9A,$AA,$A0
          DB      $00

          DB      $FF,$FE,$A9,$6D        MATOPMID
          DB      $59,$6A,$5A,$BF
          DB      $56,$55,$AA,$AA
          DB      $A0

          DB      $95,$55,$55,$57        MAMID
          DB      $D6,$5A,$FA,$5E
          DB      $D5,$55,$55,$55
          DB      $50

          DB      $FF,$FF,$D5,$5D        MABOTMID
          DB      $59,$55,$55,$7F
          DB      $56,$55,$6A,$AA
          DB      $90

          DB      $00,$55,$55,$57        MABOT
          DB      $EA,$95,$55,$6A
          DB      $A9,$55,$55,$54
          DB      $00

          DB      $FE,$AA,$90         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $00,$00,$00
          DB      $0C,$0C,$00

          DB      $91,$46                TOROID 1
          DB      $29,$48
          DB      $02,$80             TOROID 3
          DB      $21,$68

          DB      $00                 SPACE JUNK
          DB      $00

          DB      $AB,$A6,$80         TORKAN SHIP P6
          DB      $AB,$66,$80         TORKAN 2
          DB      $AB,$A6,$80         TORKAN 3

          DB      $2E,$5E,$80         ZOSHI 1    P6
          DB      $2E,$5E,$A0         ZOSHI 2    P6
          DB      $6E,$5A,$80         ZOSHI 3    P6
          DB      $2E,$5A,$80         ZOSHI 4    P6

          DB      $22,$A8,$80         JARA 1     P6
          DB      $0E,$E5,$00         JARA 2     P6
          DB      $03,$A4,$00         JARA 3     P6
          DB      $0F,$B6,$00         JARA 4     P6

          DB      $00                 ZAKATO BIRTH
          DB      $00
          DB      $00                 ZAKATO
          DB      $26,$59,$80         GARU ZAKATO
          DB      $CC,$03,$30         GARU ZAKATO EXPLOSION

          DB      $29,$5A,$00         KAPI 1
          DB      $25,$56,$00
          DB      $0F,$70,$00
          DB      $3A,$6A,$00

          DB      $FB,$A6,$E0         TERRAZI 1
          DB      $C7,$F5,$30
          DB      $03,$54,$00
          DB      $3A,$AA,$80

          DB      $2A,$AA,$AA,$A8      BACULA 1   P6
          DB      $55,$55,$55,$55      BACULA 2   P6
          DB      $FF,$FF,$FF,$FF      BACULA 3   P6
          DB      $3F,$FF,$FF,$FC      BACULA 4   P6

          DB      $01,$56,$00         AIR EXP 1
          DB      $17,$A6,$C0
          DB      $0C,$72,$00
          DB      $00,$20,$00

          DB      $00,$00,$00         SOLVALU SHOT
          DB      $00,$00,$00
          DB      $00                 ENEMY SHOT
          DB      $00,$C0,$00         SPACE JUNK EXP 0
          DB      $00,$00,$00

          DB      $02,$D6,$00         SOLV    P6
          DB      $00,$00,$00         SOLV SIGHT
          DB      $00,$00,$00         SOLV SIGHT2
          DB      $00                 BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $54,$05                CRATER

          DB      $9F,$DC,0 SHE1L9
          DB      $AD,$EC,0 SHE2L9
          DB      $25,$D7,0 SHE3L9
          DB      $BD,$EC,0 SHE4L9
          DB      $2D,$70,0 SHE5AL9
          DB      $25,$C0,0 SHE6AL9
          DB      $D7,$C0,0 SHE5BL9
          DB      $D7,$00,0 SHE6BL9
          DB      $56,$54 ;T0L9
          DB      $D6,$5C ;T1L9


          ORG     DSTAMPS+$0A00

          DB      $5A,$50,$3F,$FC Red8

          DB      $00,$3E,$AA,$BF        MATOP
          DB      $FF,$55,$55,$5F
          DB      $FF,$DA,$AA,$80
          DB      $00

          DB      $EA,$AA,$A5,$EF        MATOPMID
          DB      $FD,$FF,$5F,$D7
          DB      $FF,$75,$5A,$BF
          DB      $90

          DB      $AA,$AA,$55,$5A        MAMID
          DB      $96,$55,$A5,$5E
          DB      $DA,$55,$5A,$AA
          DB      $A0

          DB      $EA,$AA,$A5,$6D        MABOTMID
          DB      $5A,$AA,$AA,$AF
          DB      $56,$6A,$AA,$AA
          DB      $A0

          DB      $02,$AA,$AA,$AA        MABOT
          DB      $AA,$96,$AA,$AA
          DB      $A6,$96,$AA,$A8
          DB      $00

          DB      $DF,$A9,$90         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $90,$06                TOROID 1
          DB      $28,$18
          DB      $02,$80             TOROID 3
          DB      $24,$28

          DB      $3C                    SPACE JUNK
          DB      $03

          DB      $57,$A5,$40         TORKAN SHIP P5
          DB      $57,$65,$40         TORKAN 2
          DB      $57,$A5,$40         TORKAN 3

          DB      $2F,$AA,$40         ZOSHI 1    P5
          DB      $2F,$AA,$40         ZOSHI 2    P5
          DB      $EF,$AA,$60         ZOSHI 3    P5
          DB      $2E,$5A,$80         ZOSHI 4    P5

          DB      $29,$A6,$80         JARA 1      P5
          DB      $0E,$E5,$00         JARA 2      P5
          DB      $03,$A4,$00         JARA 3      P5
          DB      $0F,$B6,$00         JARA 4     P5

          DB      $0C                    ZAKATO BIRTH
          DB      $0C
          DB      $14                    ZAKATO
          DB      $19,$A6,$40         GARU ZAKATO
          DB      $2C,$03,$80         GARU ZAKATO EXPLOSION

          DB      $A9,$9A,$80         KAPI 1
          DB      $A9,$5A,$80
          DB      $2A,$6A,$00
          DB      $0E,$68,$00

          DB      $FB,$56,$E0         TERRAZI 1
          DB      $03,$F4,$00
          DB      $00,$00,$00
          DB      $0E,$5A,$00

          DB      $2A,$AA,$AA,$A8      BACULA 1   P5
          DB      $55,$55,$55,$55      BACULA 2   P5
          DB      $00,$00,$00,$00   BACULA 3   P5
          DB      $0F,$FF,$FF,$F0   BACULA 4   P5

          DB      $01,$85,$40         AIR EXP 1
          DB      $E6,$64,$80
          DB      $01,$8A,$C0
          DB      $02,$02,$30

          DB      $00,$00,$00         SOLVALU SHOT
          DB      $00,$00,$00
          DB      $00                 ENEMY SHOT
          DB      $00,$03,$00         SPACE JUNK EXP 0
          DB      $00,$00,$00

          DB      $02,$D6,$00         SOLV    P5
          DB      $10,$30,$10         SOLV SIGHT
          DB      $00,$20,$00         SOLV SIGHT2
          DB      $30                 SOLV BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $51,$01                CRATER

          DB      $AE,$EC,0 SHE1L10
          DB      $2D,$7C,0 SHE2L10
          DB      $25,$D7,0 SHE3L10
          DB      $B5,$F0,0 SHE4L10
          DB      $2E,$70,0 SHE5AL10
          DB      $25,$C0,0 SHE6AL10
          DB      $DB,$C0,0 SHE5BL10
          DB      $D7,$00,0 SHE6BL10
          DB      $DE,$9C ;T0L10
          DB      $5E,$94 ;T1L10


          ORG     DSTAMPS+$0B00

          DB      $5A,$50,$3F,$FC Red8

          DB      $00,$0F,$AA,$AA        MATOP
          DB      $AA,$6A,$AA,$AA
          DB      $AA,$A6,$AA,$00
          DB      $00

          DB      $FF,$EA,$A9,$5A        MATOPMID
          DB      $AA,$A9,$6A,$A5
          DB      $99,$56,$AA,$AA
          DB      $A0

          DB      $95,$55,$55,$FF        MAMID
          DB      $D6,$56,$A9,$5E
          DB      $D6,$A5,$55,$55
          DB      $50

          DB      $FF,$FF,$FD,$5F        MABOTMID
          DB      $FE,$55,$55,$5B
          DB      $FF,$56,$AA,$AA
          DB      $90

          DB      $05,$55,$55,$55        MABOT
          DB      $FA,$95,$55,$6A
          DB      $A6,$55,$AA,$AA
          DB      $00

          DB      $EB,$E6,$90         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $00,$00,$00
          DB      $30,$03,$00

          DB      $A4,$16                TOROID 1
          DB      $28,$18
          DB      $02,$80             TOROID 3
          DB      $24,$28

          DB      $FF                    SPACE JUNK
          DB      $0F

          DB      $FE,$A6,$80         TORKAN SHIP P4
          DB      $FC,$C6,$80         TORKAN 2
          DB      $FE,$A6,$80         TORKAN 3

          DB      $0F,$FE,$00         ZOSHI 1    P4
          DB      $1F,$FE,$00         ZOSHI 2    P4
          DB      $0F,$FE,$20         ZOSHI 3    P4
          DB      $0F,$FE,$60         ZOSHI 4    P4

          DB      $26,$A9,$80         JARA 1      P4
          DB      $0D,$E5,$00         JARA 2      P4
          DB      $03,$A4,$00         JARA 3      P4
          DB      $0F,$B6,$00         JARA 4     P4

          DB      $00                 ZAKATO BIRTH
          DB      $C0
          DB      $55                    ZAKATO
          DB      $1B,$56,$40         GARU ZAKATO
          DB      $C3,$0C,$30         GARU ZAKATO EXPLOSION

          DB      $97,$A5,$80         KAPI 1
          DB      $95,$55,$80
          DB      $95,$55,$80
          DB      $03,$30,$00

          DB      $FB,$A6,$E0         TERRAZI 1
          DB      $00,$00,$00
          DB      $00,$00,$00
          DB      $03,$58,$00

          DB      $2A,$AA,$AA,$A8      BACULA 1   P4
          DB      $FF,$FF,$FF,$FF      BACULA 2   P4
          DB      $00,$00,$00,$00   BACULA 3   P4
          DB      $0F,$FF,$FF,$F0   BACULA 4   P4

          DB      $01,$51,$00         AIR EXP 1
          DB      $15,$56,$00
          DB      $38,$04,$00
          DB      $C8,$00,$00

          DB      $00,$00,$00         SOLVALU SHOT
          DB      $00,$00,$00
          DB      $00                 ENEMY SHOT
          DB      $00,$00,$00         SPACE JUNK EXP 0
          DB      $03,$00,$00

          DB      $00,$D4,$00         SOLV    P4
          DB      $10,$30,$10         SOLV SIGHT
          DB      $00,$20,$00         SOLV SIGHT2
          DB      $FC                    SOLV BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $55,$51                CRATER

          DB      $B5,$BC,0 SHE1L11
          DB      $39,$7C,0 SHE2L11
          DB      $09,$DC,0 SHE3L11
          DB      $F5,$80,0 SHE4L11
          DB      $27,$80,0 SHE5AL11
          DB      $09,$C0,0 SHE6AL11
          DB      $2E,$C0,0 SHE5BL11
          DB      $DC,$00,0 SHE6BL11
          DB      $5E,$94 ;T0L11
          DB      $DE,$9C ;T1L11

          ORG     DSTAMPS+$0C00

          DB      $75,$50,$0F,$F0 Red8

          DB      $00,$03,$EA,$FF        MATOP
          DB      $FF,$55,$55,$5F
          DB      $FF,$F5,$54,$00
          DB      $00

          DB      $EA,$AA,$55,$7A        MATOPMID
          DB      $AA,$FD,$57,$F5
          DB      $55,$D5,$55,$57
          DB      $D0

          DB      $AA,$95,$5A,$AA        MAMID
          DB      $96,$55,$55,$5E
          DB      $DA,$AA,$55,$6A
          DB      $A0

          DB      $EA,$AA,$AA,$5A        MABOTMID
          DB      $AB,$FF,$FF,$FA
          DB      $99,$AA,$AA,$AA
          DB      $A0

          DB      $0A,$AA,$AA,$AA        MABOT
          DB      $AA,$A5,$AA,$AA
          DB      $9A,$5A,$AA,$AA
          DB      $00

          DB      $3B,$E6,$40         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $30,$03,$00
          DB      $0C,$0C,$00

          DB      $25,$58                TOROID 1
          DB      $0D,$50
          DB      $02,$80             TOROID 3
          DB      $0D,$60

          DB      $C3                    qSPACE JUNK
          DB      $3F

          DB      $FE,$A6,$80         TORKAN SHIP P3
          DB      $FC,$06,$80         TORKAN 2
          DB      $FE,$A6,$80         TORKAN 3

          DB      $1B,$FE,$40         ZOSHI 1    P3
          DB      $CB,$FE,$00         ZOSHI 2    P3
          DB      $0B,$FE,$00         ZOSHI 3    P3
          DB      $0B,$FE,$20         ZOSHI 4    P3

          DB      $28,$AA,$80         JARA 1      P3
          DB      $0E,$E5,$00         JARA 2      P3
          DB      $03,$A0,$00         JARA 3      P3
          DB      $0F,$A6,$00         JARA 4     P3

          DB      $33                    ZAKATO BIRTH
          DB      $03
          DB      $55                    ZAKATO
          DB      $27,$D9,$80         GARU ZAKATO
          DB      $AC,$F3,$A0         GARU ZAKATO EXPLOSION

          DB      $F7,$A6,$80         KAPI 1
          DB      $F7,$66,$80
          DB      $36,$66,$00
          DB      $00,$00,$00

          DB      $D7,$F5,$60         TERRAZI 1
          DB      $00,$00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $2A,$AA,$AA,$A8      BACULA 1   P3
          DB      $FF,$FF,$FF,$FF      BACULA 2   P3
          DB      $00,$00,$00,$00   BACULA 3   P3
          DB      $00,$00,$00,$00   BACULA 4   P3

          DB      $04,$41,$40         AIR EXP 1
          DB      $19,$DB,$00
          DB      $00,$30,$00
          DB      $08,$C8,$00

          DB      $0C,$00,$C0         SOLV SHOT
          DB      $0C,$00,$C0         SOLV SHOT 1
          DB      $30                 ENEMY SHOT
          DB      $0C,$00,$30         SPACE JUNK EXP 0
          DB      $00,$03,$00         SPACE JUNK EXP 1

          DB      $00,$D8,$00         SOLV    P3
          DB      $10,$30,$10         SOLV SIGHT
          DB      $00,$20,$00         SOLV SIGHT2
          DB      $EC                    SOLV BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $55,$15                CRATER

          DB      $F5,$7C,0 SHE1L12
          DB      $37,$C0,0 SHE2L12
          DB      $09,$DC,0 SHE3L12
          DB      $0F,$70,0 SHE4L12
          DB      $0B,$C0,0 SHE5AL12
          DB      $09,$C0,0 SHE6AL12
          DB      $3F,$00,0 SHE5BL12
          DB      $DC,$00,0 SHE6BL12
          DB      $DE,$DC ;T0L12
          DB      $5E,$D4 ;T1L12

          ORG     DSTAMPS+$0D00

          DB      $1D,$40,$0F,$F0 Red8

          DB      $00,$00,$FA,$AA        MATOP
          DB      $A9,$AA,$AA,$AA
          DB      $AA,$A9,$A0,$00
          DB      $00

          DB      $FE,$AA,$AA,$56        MATOPMID
          DB      $AA,$A9,$6A,$A9
          DB      $A9,$5A,$AA,$AA
          DB      $A0

          DB      $95,$55,$FF,$FF        MAMID
          DB      $D6,$75,$55,$DE
          DB      $D6,$AA,$A5,$55
          DB      $50

          DB      $FF,$FF,$FF,$D5        MABOTMID
          DB      $A9,$AA,$AA,$AD
          DB      $55,$6A,$AA,$A9
          DB      $50

          DB      $15,$55,$55,$55        MABOT
          DB      $7E,$A5,$55,$AA
          DB      $95,$55,$55,$55
          DB      $40

          DB      $39,$DB,$40         ROVERS

          DB      $00,$00,$00         SHOT AGAINST BACULA
          DB      $30,$03,$00
          DB      $C0,$00,$C0

          DB      $39,$68                TOROID 1
          DB      $0E,$60
          DB      $02,$80             TOROID 3
          DB      $09,$A0

          DB      $C3                    SPACE JUNK
          DB      $FC

          DB      $FE,$A6,$80         TORKAN SHIP P2
          DB      $FC,$06,$80         TORKAN 2
          DB      $FE,$A6,$80         TORKAN 3

          DB      $32,$F8,$80         ZOSHI 1    P2
          DB      $02,$F9,$00         ZOSHI 2    P2
          DB      $02,$F8,$00         ZOSHI 3    P2
          DB      $06,$F8,$00         ZOSHI 4    P2

          DB      $28,$D2,$80         JARA 1      P2
          DB      $0E,$D5,$00         JARA 2      P2
          DB      $03,$A0,$00         JARA 3      P2
          DB      $0F,$76,$00         JARA 4     P2

          DB      $00                 ZAKATO BIRTH
          DB      $CC
          DB      $55                    ZAKATO
          DB      $06,$E9,$00         GARU ZAKATO
          DB      $32,$08,$C0         GARU ZAKATO EXPLOSION

          DB      $3B,$AE,$00         KAPI 1
          DB      $03,$A0,$00
          DB      $03,$A0,$00
          DB      $00,$00,$00

          DB      $D7,$A5,$60         TERRAZI 1
          DB      $00,$00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $2A,$AA,$AA,$A8      BACULA 1   P2
          DB      $00,$00,$00,$00   BACULA 2   P2
          DB      $00,$00,$00,$00   BACULA 3   P2
          DB      $00,$00,$00,$00   BACULA 4   P2

          DB      $10,$00,$40         AIR EXP 1
          DB      $2C,$9D,$00
          DB      $00,$C0,$00
          DB      $0C,$0C,$00

          DB      $3F,$03,$F0         SOLV SHOT
          DB      $33,$03,$30         SOLV SHOT 1
          DB      $EC                    ENEMY SHOT
          DB      $00,$30,$00         SPACE JUNK EXP 0
          DB      $C0,$00,$00         SPACE JUNK EXP 1

          DB      $00,$E8,$00         SOLV    P2
          DB      $15,$01,$50         SOLV SIGHT
          DB      $00,$00,$00         SOLV SIGHT2
          DB      $EC                    SOLV BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $15,$54                CRATER

          DB      $FF,$FC,0 SHE1L13
          DB      $3C,$00,0 SHE2L13
          DB      $02,$F0,0 SHE3L13
          DB      $00,$F0,0 SHE4L13
          DB      $0B,$C0,0 SHE5AL13
          DB      $02,$C0,0 SHE6AL13
          DB      $3F,$00,0 SHE5BL13
          DB      $F0,$00,0 SHE6BL13
          DB      $5B,$94 ;T0L13
          DB      $DB,$9C ;T1L13


          ORG     DSTAMPS+$0E00

          DB      $15,$40,$03,$C0 Red8

          DB      $00,$00,$3B,$FF        MATOP
          DB      $FD,$55,$55,$57
          DB      $FF,$FD,$80,$00
          DB      $00

          DB      $FA,$A5,$55,$5E        MATOPMID
          DB      $AB,$FD,$57,$FD
          DB      $6B,$55,$56,$AA
          DB      $90

          DB      $A5,$5A,$AA,$AA        MAMID
          DB      $96,$95,$55,$6A
          DB      $DA,$AA,$AA,$55
          DB      $A0

          DB      $EA,$AA,$AA,$A5        MABOTMID
          DB      $69,$AA,$AA,$AE
          DB      $9A,$AA,$AA,$AA
          DB      $A0

          DB      $2A,$96,$AA,$A6        MABOT
          DB      $AA,$A5,$AA,$AA
          DB      $69,$6A,$AA,$AA
          DB      $80

          DB      $0F,$F9,$00         ROVERS

          DB      $30,$03,$00         SHOT AGAINST BACULA
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $0E,$A0             TOROID 1
          DB      $03,$80
          DB      $03,$80             TOROID 3
          DB      $03,$C0

          DB      $FF                    SPACE JUNK
          DB      $F0

          DB      $3F,$AA,$00         TORKAN SHIP P1
          DB      $3C,$0A,$00         TORKAN 2
          DB      $3E,$AA,$00         TORKAN 3

          DB      $00,$A0,$00         ZOSHI 1    P1
          DB      $01,$A0,$C0         ZOSHI 2    P1
          DB      $01,$A0,$00         ZOSHI 3    P1
          DB      $30,$A0,$00         ZOSHI 4    P1

          DB      $20,$A0,$80         JARA 1      P1
          DB      $0E,$F5,$00         JARA 2      P1
          DB      $03,$B0,$00         JARA 3      P1
          DB      $0F,$A6,$00         JARA 4     P1

          DB      $0C                    ZAKATO BIRTH
          DB      $03
          DB      $75                    ZAKATO
          DB      $0A,$5A,$00         GARU ZAKATO
          DB      $2C,$F3,$80         GARU ZAKATO EXPLOSION

          DB      $0F,$AC,$00         KAPI 1
          DB      $00,$00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $C7,$A5,$20         TERRAZI 1
          DB      $00,$00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $2A,$AA,$AA,$A8      BACULA 1   P1
          DB      $00,$00,$00,$00   BACULA 2   P1
          DB      $00,$00,$00,$00   BACULA 3   P1
          DB      $00,$00,$00,$00   BACULA 4   P1

          DB      $60,$10,$20         AIR EXP 1
          DB      $20,$40,$80
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $3F,$03,$F0         SOLV SHOT
          DB      $33,$03,$30         SOLV SHOT 1
          DB      $EC                    ENEMY SHOT
          DB      $00,$00,$00         SPACE JUNK EXP 0
          DB      $00,$00,$0C            SPACE JUNK EXP 1

          DB      $00,$20,$00         SOLV    P1
          DB      $05,$01,$40         SOLV SIGHT
          DB      $00,$00,$00         SOLV SIGHT2
          DB      $FC                    SOLV BOMB

          DB      $55,$55,$55,$55        SIDE BAR
          DB      $00,$00,$00         3 BYTE BLANK
          DB      $15,$54                CRATER

          DB      $00,$00,0 SHE1L14
          DB      $00,$00,0 SHE2L14
          DB      $02,$F0,0 SHE3L14
          DB      $00,$00,0 SHE4L14
          DB      $03,$00,0 SHE5AL14
          DB      $02,$C0,0 SHE6AL14
          DB      $0C,$00,0 SHE5BL14
          DB      $F0,$00,0 SHE6BL14
          DB      $DA,$1C ;T0L14
          DB      $5A,$14 ;T1L14


          ORG     DSTAMPS+$0F00

CBZAKATO  DB      $05,$00,$00,$00 Red8

CMATOP    DB      $00,$00,$0F,$FF        MATOP
          DB      $FF,$FF,$FF,$FF
          DB      $FF,$FF,$00,$00
          DB      $00

CMATOPMD  DB      $EA,$AA,$AA,$96        MATOPMID
          DB      $AA,$A9,$AA,$AA
          DB      $69,$6A,$AA,$AA
          DB      $A0

CMAMID    DB      $55,$FF,$FF,$FF        MAMID
          DB      $D6,$95,$55,$6A
          DB      $D6,$AA,$AA,$A5
          DB      $50

CMABOTMD  DB      $9F,$FF,$FF,$FD        MABOTMID
          DB      $E5,$BF,$FF,$FB
          DB      $D6,$AA,$AA,$55
          DB      $50

CMABOT    DB      $55,$55,$55,$56        MABOT
          DB      $5F,$A5,$55,$AA
          DB      $65,$55,$5A,$AA
          DB      $90

CROVER    DB      $0F,$FC,$00         ROVERS

CBOUNCE   DB      $30,$03,$00         BOUNCE OFF BACULA FOR SHOT
          DB      $00,$00,$00
          DB      $00,$00,$00

CTOROID   DB      $02,$80             TOROID 1
          DB      $02,$80             TOROID 2
          DB      $02,$80             TOROID 3
          DB      $02,$80             TOROID 4

CFLUFF0   DB      $3C                    SPACE JUNK 0
CFLUFF1   DB      $C0                 SPACE JUNK 1

CTORKAN   DB      $0C,$08,$00         TORKAN 1    P0
          DB      $0C,$08,$00         TORKAN 2
          DB      $0C,$48,$00         TORKAN 3

CZOSHI    DB      $00,$C0,$00         ZOSHI 1    P0
          DB      $03,$00,$00         ZOSHI 2    P0
          DB      $0C,$03,$00         ZOSHI 3    P0
          DB      $00,$30,$00         ZOSHI 4    P0

CJARA     DB      $33,$A8,$C0         JARA 1     P0
          DB      $0B,$F5,$00         JARA 2     P0
          DB      $00,$C0,$00         JARA 3     P0
          DB      $0F,$AD,$00         JARA 4     P0

CZAKATO   DB      $00                 ZAKATO BIRTH 1
          DB      $30                 ZAKATO BIRTH 2
CZAKATO3  DB      $14                    ZAKATO
CGZAKATO  DB      $02,$58,$00         GARU ZAKATO
CGZAKEXP  DB      $0B,$0E,$00         GARU ZAKATO EXPLOSION

CKAPI     DB      $03,$20,$00         KAPI
          DB      $00,$00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

CTERRAZI  DB      $03,$F4,$00         TERRAZI 1
          DB      $00,$00,$00         TERRAZI 2
          DB      $00,$00,$00         TERRAZI 3
          DB      $00,$00,$00         TERRAZI 4

CBACULA   DB      $00,$00,$00,$00   BACULA 1   P0
          DB      $00,$00,$00,$00   BACULA 2   P0
          DB      $00,$00,$00,$00   BACULA 3   P0
          DB      $00,$00,$00,$00   BACULA 4   P0

CAIREXP   DB      $00,$04,$00         AIR EXP 1
          DB      $00,$00,$00
          DB      $00,$00,$00
CAIREXP4  DB      $00,$00,$00         AIR EXP 4

CSSHOT0   DB      $0C,$00,$C0         SOLV SHOT 0
CSSHOT1   DB      $0C,$00,$C0         SOLV SHOT 1
CSHOT     DB      $30                 ENEMY SHOT
CFLFEXP0  DB      $00,$00,$00         SPACE JUNK EXP 0
CFLFEXP1  DB      $00,$00,$00         SPACE JUNK EXP 1

CSOLVALU  DB      $00,$30,$00         SOLV    P0
CSIGHT    DB      $00,$00,$00         SOLV SIGHT
CSIGHT2   DB      $00,$00,$00         SOLV SIGHT2
CSOLBOMB  DB      $30                 SOLV BOMB

BAR       DB      $55,$55,$55,$55        SIDE BAR    P0
C3BLANK   DB      $00,$00,$00         3 BYTE BLANK
CCRAT     DB      $05,$50

          DB      $00,$00,0 SHE1L15
          DB      $00,$00,0 SHE2L15
          DB      $00,$C0,0 SHE3L15
          DB      $00,$00,0 SHE4L15
          DB      $03,$00,0 SHE5AL15
          DB      $00,$C0,0 SHE6AL15
          DB      $0C,$00,0 SHE5BL15
          DB      $C0,$00,0 SHE6BL15
          DB      $40,$04 ;T0L15
          DB      $C0,$0C ;T1L15
          END
