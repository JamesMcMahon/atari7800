; Tables.s
; This file contains all of the tables used in every file.
;         They're placed here so that they can overlap in
;         complex and unreadable ways, to save ROM space.

          GLBL    JOYTABLE

          GLBL    TEXTTM1,TEXT0,TEXT1,TEXT2,TEXT4,TEXT5,TEXT6,TEXT8,TEXT9
          GLBL    TEXTLEN,TEXTPOS,PPTRL,PPTRH

          GLBL    COLORROM,LISTTABL,LISTTABH,TOPZONE,DLLROM
          GLBL    SWLIST,NULLLIST,TRUEBUT
          GLBL    DIRTABL,DIRTABH,ADIRTABL,ADIRTABH,RACKWORD,FOODWORD

          GLBL    SELTEXT1,SELTEXT2,CTEXT1,CTEXT2,CTEXT3,CTEXT4

          GLBL    PIEFLY,PIEFLYPW,BANFLY,BANFLYPW,PEAFLY
          GLBL    SPLATCH,SPLATPW
          GLBL    XVECTORH,XVECTORL,YVECTORH,YVECTORL
          GLBL    SCOREX

          GLBL    FCENTERY,DYFCHAR,STUKXPOS,STUKYPOS

          GLBL    CHARHITE,FALLSND

          GLBL    HYCENTER,DYHCHAR

          GLBL    DURTABL,CTRLTABL,PRYOR,ZTUNE0F
          GLBL    ZTUNE1F,ZTUNE2F,ZTUNE1V,ZTUNE2V,ZTUNE0V
          GLBL    ZTUNE3F,ZTUNE3V,ZTUNE4F,ZTUNE4V,ZTUNE5F,ZTUNE5V
          GLBL    ZTUNE6F,ZTUNE6V,ZTUNE7F,ZTUNE7V,ZTUNE8F,ZTUNE8V
          GLBL    ZTUNE9F,ZTUNE9V,ATUNE10F,ZTUNE10V,ATUNE11F,ZTUNE11V
          GLBL    ATUNE12F,ZTUNE12V,ATUNE13F,ZTUNE13V,ZTUNE14F,ZTUNE14V
          GLBL    ZTUNE15F,ZTUNE15V,ZTUNE16F,ZTUNE16V,ZTUNE17F,ZTUNE17V
          GLBL    ZTUNE18F,ZTUNE18V,ZTUNE19F,ZTUNE19V,ZTUNE20F,ZTUNE20V
          GLBL    ZTUNE21F,ZTUNE21V,ZTUNE22F,ZTUNE22V,ZTUNE23F,ZTUNE23V
          GLBL    ZTUNE24F,ZTUNE24V,ZTUNE25F,ZTUNE25V,ZTUNE26F,ZTUNE26V
          GLBL    ZTUNE27F,ZTUNE27V,ZTUNE28F,ZTUNE28V,ZTUNE29F,ZTUNE29V
          GLBL    ZTUNE30F,ZTUNE30V,ZTUNE31F,ZTUNE31V,ZTUNE32F,ZTUNE32V


; From GOD.S

JOYTABLE  DB      $8,$8,$8,$8,$8,$03,$01,$02
          DB      $08,$05,$07,$06,$08,$04,$00,$08

; From LOGO.S

RIGHTNUM  DB      $1,$2,$3,$3

TEXTTM1   DB      $6C,$00,$D8,$00,$6C,$00,$6C,$00,$6C

LEFTNUM   DB      $0,$0                  uses the following bytes (1,2)

SELDIFF   DB      $1,$2,$3,$0,$1,$2,$3,$0
                                         ; find selnum downnum upnum below
DWORDL    DB      L(DIFF0),L(DIFF1),L(DIFF2),L(DIFF3)
DWORDH    DB      H(DIFF0),H(DIFF1),H(DIFF2),H(DIFF3)

DWORDPOS  DB      $03,$10,$44,$70

DWORDLEN  DB      $7,$B,$7,$5

PWORDL    DB      L(PLAY0),L(PLAY1)
PWORDH    DB      H(PLAY0),H(PLAY1)

DIFF0     DB      $EA,$BA,$B4,$C2,$BE,$BE,$BA,$C8        ; "BEGINNER"

DIFF1     DB      $C2,$BE,$CC,$BA,$C8,$F0,$BA,$EC        ; "INTERMEDIATE"
          DB      $C2,$B8,$CC,$BA

DIFF2     DB      $B8,$EC,$BC,$B8,$BE,$B6,$BA,$EC        ; "ADVANCED"

PLAY0     DB      $D6,$BE,$BA,$2F,$C6,$C4,$B8,$CE,$BA,$C8   ; ONE PLAYER

DIFF3     DB      $BA,$EE,$C6,$BA,$C8                    ; "EXPERT"
                                         ; uses following byte
PLAY1     DB      $CC,$F2,$D6,$2F,$C6,$C4,$B8,$CE,$BA,$C8

COPYTXT   DB      $D4,$2F,$D8,$E8,$E6,$DE,$2F    ; (C) 1984 ATARI
          DB      $B8,$CC,$B8,$C8,$C2
******
          RSEG    CODE2
******

; From TEXT.S


TEXT0     DB      $BA,$B8,$CC,$2F,$CC,$C0,$BA,$2F        ; "EAT THE CONE!"
          DB      $B6,$D6,$BE,$BA,$D0

TEXT1     DB      $C6,$C4,$B8,$CE,$BA,$C8,$2F        ; "PLAYER "

TEXT2     DB      $B4,$B8,$F0,$BA,$2F,$D6,$BC,$BA,$C8        ; "GAME OVER"

TEXT4     DB      $C4,$BA,$CC,$D2,$CA,$2F        ; "LET'S SEE THAT"
          DB      $CA,$BA,$BA,$2F,$CC,$C0,$B8,$CC

TEXT5     DB      $B8,$B4,$B8,$C2,$BE,$D0       ; "AGAIN!"

TEXT6     DB      $C2,$BE,$CA,$CC,$B8,$BE,$CC,$2F        ; "INSTANT REPLAY!"
          DB      $C8,$BA,$C6,$C4,$B8,$CE,$D0

TEXT8     DB      $B8,$C4,$F0,$D6,$CA,$CC      ; "ALMOST"
TEXT9     DB      $F0,$B8,$EC,$BA,$2F,$C2,$CC  ; "MADE IT"

TEXTLEN   DB      $0C,$05,$08,$05,$0D,$05,$0E,$00,$05,$06

TEXTPOS   DB      $20,$30,$28,$30,$18,$38,$10,$00,$38,$30

PPTRL     DB      L(TEXT0),L(TEXT1),L(TEXT2),L(TEXT1),L(TEXT4)
          DB      L(TEXT5),L(TEXT6),00,L(TEXT8),L(TEXT9)

PPTRH     DB      H(TEXT0),H(TEXT1),H(TEXT2),H(TEXT1),H(TEXT4)
          DB      H(TEXT5),H(TEXT6),00,H(TEXT8),H(TEXT9)

; From MAIN.S

COLORROM  DB      $3A,$84,$1F,$00        ; 0; CHARLIE CHUCK PALETTE
          DB      $3C,$70,$0E,$00        ; 1; CHEFS' PALETTE
          DB      $0C,$0A,$26,$00        ; 2; PIE PALETTE
          DB      $E6,$EB,$E3,$00        ; 3; PEA PALETTE
          DB      $37,$33,$3B,$00        ; 4; TOMATOE PALETTE
          DB      $19,$15,$1F,$00        better for text-- temporary
;         DB      $16,$17,$1F,$00        ; 5; BANANA PALETTE
          DB      $E7,$00,$36,$00        ; 6; WATERMELON PALETTE
          DB      $4C,$48,$29            ; 7; ICE CREAM CONE PALETTE

; TABLES OF POINTERS TO DISPLAY LISTS
;         USED BY BOTH THE KERNEL AND THE LOADER

LISTTABL  DB      L(DLIST0),L(DLIST1),L(DLIST2)
          DB      L(DLIST3),L(DLIST4),L(DLIST5)
          DB      L(DLIST6),L(DLIST7),L(DLIST8)
          DB      L(DLIST9),L(DLIST10)
LISTTABH  DB      H(DLIST0),H(DLIST1),H(DLIST2)
          DB      H(DLIST3),H(DLIST4),H(DLIST5)
          DB      H(DLIST6),H(DLIST7),H(DLIST8)
          DB      H(DLIST9),H(DLIST10)

; LIST OF Y POSITIONS OF THE TOPS OF THE ZONES
;         NOTE THAT ZONE 0 IS AT THE BOTTOM OF THE SCREEN; ZONE 10
;         IS THE TOPMOST ZONE; THE TOP 8 SCAN LINES ARE SCORE DISPLAY.
;         EVEN THOUGH THE BOTTOM 8 LINES ARE STATUS INFO, THE Y COORDINATES
;         START ON THE FIRST LINE OF PLAYFIELD AREA-- THUS Y==0 MEANS
;         THE 9TH SCAN LINE UP.

TOPZONE   DB      15,31,47,63,79,95      ; ZONE0-ZONE5
          DB      111,127,143,159,175    ; ZONE6-ZONE10

; THE DISPLAY LIST LIST-- LOADED INTO RAM IN "STARTUP" ROUTINE
;         NOTE-- ALL HOLEY DMA BITS ARE SET (BIT 6 OF FIRST BYTE)

DLLROM    DB      $89                    ; FIRST DLI-- SETS 320X1 MODE
                                         ; AND SCORE PALETTE
          DB      H(DLISTA)              ; SETS WRITE MODE
          DB      L(DLISTA)
          DB      $0F
          DB      H(DLISTB)            ;   (15+1)+(9+1)=26
          DB      L(DLISTB)

; FIRST VISIBLE DLIST-- 8 HIGH, SCORE
;  NO HOLY DMA NECESSARY HERE !

          DB      $07
          DB      H(SCORELST),L(SCORELST)

; FIRST GAMEPLAY ZONE-- 16 HIGH UNTIL STATUS ZONE, AT BOTTOM

          DB      $CF                    ; DLI-- CHANGE MODE TO 160X2,
          DB      H(DLIST10),L(DLIST10)  ;   CHANGE HERO PALETTE

          DB      $4F
          DB      H(DLIST9),L(DLIST9)

          DB      $4F
          DB      H(DLIST8),L(DLIST8)

          DB      $4F
          DB      H(DLIST7),L(DLIST7)

          DB      $4F
          DB      H(DLIST6),L(DLIST6)

          DB      $4F
          DB      H(DLIST5),L(DLIST5)

          DB      $4F
          DB      H(DLIST4),L(DLIST4)

          DB      $4F
          DB      H(DLIST3),L(DLIST3)

          DB      $4F
          DB      H(DLIST2),L(DLIST2)

          DB      $4F
          DB      H(DLIST1),L(DLIST1)

          DB      $4F
          DB      H(DLIST0),L(DLIST0)

; NO DMA NEEDED HERE EITHER

          DB      $00                    one line only
          DB      H(DLISTB),L(DLISTB)

          DB      $87                    ; DLI FOR SYSTEM TIMERS, LOADER,
          DB      H(STATLIST),L(STATLIST)   ; MUSIC, INPUT POLLING

; NOTE-- I just made the status zone 9 lines high, and decreased the
;         height of the following zone

; AT THIS POINT I NEED 24 EXTRA LINES.  THE LAST ZONE IS 2 HIGH
;         AND CONTAINS A DLI WHICH WILL SYNCHRONIZE ALL THE DLIS

          DB      $0E                    ; 16
          DB      H(DLISTB),L(DLISTB)

          DB      $06                    ; + 6 = 22
          DB      H(DLISTB),L(DLISTB)

; THIS ZONE SHOULD START AT THE 242ND SCAN LINE (192+50)-- THE LAST
;         14 LINES OF THIS ZONE SHOULD BE IGNORED; JUST TO BE SAFE.

          DB      $8F                    ; + 2 = 24      ; DLI 4
          DB      H(DLISTB),L(DLISTB)

SWLIST    DB      L(NULLCHAR),$40,H(NULLCHAR),$1F,$0
NULLLIST
SELNUM    DB      $0                     uses the following three lines
DOWNNUM   DB      $0,$0
UPNUM     DB      $1,$1,$1,$1,$0

TRUEBUT   DB      $01,$02,$04,$08,$10,$20,$40,$80

DIRTABL   DB      L(IRDIRA),L(IRDIRB),L(IRDIRC),L(IRDIRD)

DIRTABH   DB      H(IRDIRA),H(IRDIRB),H(IRDIRC),H(IRDIRD)

ADIRTABL  DB      L(AIRDIRA),L(AIRDIRB),L(AIRDIRC),L(AIRDIRD)

ADIRTABH  DB      H(AIRDIRA),H(AIRDIRB),H(AIRDIRC),H(AIRDIRD)

RACKWORD  DB      $C4,$C5,$BA,$BB,$BC,$BD,$BA,$BB,$C4,$C5
FOODWORD   DB      $F4,$F5,$BA,$BB,$C2,$C3,$CC,$CD,$C0,$C1

; From SELECT.S

SELTEXT1  DB      $CA,$BA,$C4,$BA,$B6,$CC,$2F    ; SELECT
          DB      $CA,$CC,$B8,$C8,$CC,$C2,$BE,$B4        ; STARTING

SELTEXT2  DB      $C4,$BA,$BC,$BA,$C4            ; LEVEL

CTEXT1    DB      $EA,$CE
CTEXT2    DB      $CC,$C0,$BA,$2F,$FA,$B8,$C4,$B6,$C0,$BA,$F0
          DB      $C2,$CA,$CC
CTEXT3    DB      $D6,$F6,$2F,$F6,$F8,$BE,$FA
CTEXT4    DB      $F4,$BA,$C2,$CC,$C0,$2F,$CA,$B8,$F2,$CE,$BA,$C8

; INIT.S

HSPEED    DB      13,12,11,10,9,8,7,6
HSPEED1   DB      15,14,13,12,11,10,9,8

CHSPEED   DB      23,22,21,20,19,18,16,15
CHSPEED1  DB      25,24,23,22,21,20,18,17

MTUFFTAB  DB      $1F,$1C,$18,$F,$7,$7,$3,$3
          DB      $3,$3,$3               uses following two bytes
MUNCHY    DB      $1,$1,$1,$1,$3,$4


; The following tables are used to vary the chef's repeat throw times
;         linearly with 4 different slopes, depending on the
;         difficulty level.


ZRACK     DB      22,17,13,10           level where thrwtime is zero

LOWTIME   DB      L(TUFFTAB0),L(TUFFTAB1),L(TUFFTAB2),L(TUFFTAB3)
HITIME    DB      H(TUFFTAB0),H(TUFFTAB1),H(TUFFTAB2),H(TUFFTAB3)

; Beginner difficulty

TUFFTAB0  DB      125,125,120,114,109,104,99,94,88,83,78,73,68
          DB      62,57,52,47,42,36,31,26,21        uses following byte

CHHATS    DB      $10,$12,$14,$16        ; TALLEST FIRST

; Intermediate difficulty

TUFFTAB1  DB      123,116,110,103,96,89,83,76,69,62,56,49,42
          DB      35,29,22,16

; Advanced difficulty

TUFFTAB2  DB      121,112,103,95,86,77,68,59,50,41,33,24,15

; Expert difficulty

TUFFTAB3  DB      118,107,95,84,72,61,49,38,26,15

CONECOL1  DB      $2F,$0F,$26,$4C,$DC,$3C,$EC,$54,$1F,$5F
CONECOL2  DB      $2A,$0A,$24,$48,$E8,$38,$E7,$52,$1C,$5A

NUMPTAB
NUMHTAB   DB      $3,$4,$5,$6,$7
          DB      $8,$9,$A,$A,$A

CHEFCHAR
          DB      $14,$18,$28            ; SMALL HAT
          DB      $16,$1A,$2A            ; FLOPPY HAT
          DB      $12,$1D,$2C            ; LARGE HAT
          DB      $10,$19,$2E            ; TALL HAT

CHEFPALW
          DB      $3E,$3F,$3E
          DB      $3E,$3F,$3E
          DB      $3E,$3F,$3E
          DB      $3E,$3F,$3E

RISEPALW
          DB      $BE,$BF,$BE
          DB      $BE,$BF,$BE
          DB      $BE,$BF,$BE
          DB      $BE,$BF,$BE

; CHUCK.S

RISESND
          DB      $07,$00,$00
          DB      $0F,$00,$00
          DB      $11,$00,$00
          DB      $13                    uses following two bytes

TONGUEX   DB      $0,$0,$0,$0,$4,$8
          DB      $8,$8,$8,$4            uses following two bytes
MTABSPD   DB      0,0,0,0,1,1,1,2,1,3,2
          DB      3,4,2,3,4,5,3,7,6,5,4,7,5,6,7


CHKCHOFF  DB      $0,$6,$C,$12           ; MULTIPLES OF 6

; CHARLEY CHUCK ANIMATION TABLES:

CCHEADS   DB      $00,$02,$04,$06
          DB      $08,$0A,$0C,$0E

CHUCKRUN                                 ; MUST BE IN THIS ORDER !
CCRUNR    DB      $4A,$48,$46,$44,$42,$40

CCRUNL    DB      $6E,$6C,$6A,$68,$66,$64

CCRUNRC   DB      $CC,$CA,$C8,$C6,$C4,$C2

CCRUNLC   DB      $D8,$D6,$D4,$D2,$D0,$CE

CCARMS    DB      $DC,$DF,$E2,$E5,$E8,$EB,$EE,$F1

; MUNCH SEQUENCE STAMPS: (ALL IN BLOCK2)

MUNCHLOW  DB      $27,$21,$1B,$18,$15,$13

MUNCHHI   DB      $2A,$24,$1E,$2F,$2F,$2F

MUNCHPW   DB      $1D,$1D,$1D,$1D,$1D,$1E

; THESE TABLES ARE INDEXED BY CFRAME-- WITH SOME TWEAKING.
;         THE TONGUE USES THE TOMATO PALETTE--

TONGPALW  DB      $9F,$9F,$9F,$9F,$9E,$9D,$9D,$9D,$9D,$9E,$9F,$9F

TONGCHAR  DB      $2F,$2F,$45,$44,$42,$3F,$3C,$39,$36,$34,$33,$2F

; TABLES FOR DELTAS:
; THE ACTUAL VALUES ARE:
;         (THE "1" TABLES REPRESENT THESE VALUES TIMES 1.25)
;         (THE "2" TABLES REPRESENT THESE VALUES TIMES 1.5)
;         (THE "3" TABLES REPRESENT THESE VALUES TIMES 1.75)
;         (THE "4" TABLES ARE X3, NO LONGER USED)

;         DX-     0    .71  1.00  .71  0     -.71  -1.00  -.71
;         DY      1.38 .98  0    -.98 -1.38  -.98   0      .98

STABXH    DB      0,0,1,0,0,$FF,$FF,$FF
STABXH1   DB      0,0,1,0,0,$FF,$FE,$FF
STABXH2   DB      0,1,1,1,0,$FE,$FE,$FE
STABXH3   DB      0,1,1,1,0,$FE,$FE,$FE
*STABXH4   DB      0,2,3,2,0,$FD,$FD,$FD

STABXL    DB      0,182,0,182,0,$4A,0,$4A
STABXL1   DB      0,$E4,$40,$E4,0,$1C,$C0,$1C
STABXL2   DB      0,$11,$80,$11,0,$EF,$80,$EF
STABXL3   DB      0,$3E,$C0,$3D,0,$C3,$40,$C3
*STABXL4   DB      0,$21,0,$21,0,$DF,0,$DF

STABYH    DB      1,0,0,$FF,$FE,$FF,0,0
STABYH1   DB      1,1,0,$FE,$FE,$FE,0,1
STABYH2   DB      2,1,0,$FE,$FD,$FE,0,1
STABYH3   DB      2,1,0,$FE,$FD,$FE,0,1
*STABYH4   DB      4,2,0,$FD,$FB,$FD,0,2

STABYL    DB      96,251,0,5,$A0,5,0,251
STABYL1   DB      $BB,$3B,0,$C5,$45,$C5,0,$3B
STABYL2   DB      $12,$78,0,$88,$EE,$88,0,$78
STABYL3   DB      $6B,$B8,0,$48,$95,$48,0,$B8
*STABYL4   DB      $24,$F0,0,$10,$DC,$10,0,$F0

; TABLES FOR THE DIFFERENT SPEED VALUES:
;         INDICES TO THIS TABLE WILL MONOTONICALLY INCREASE THE SPEED OF
;         THE OBJECT.  THE "CSPEED" VALUE AND THE "CNSPEEDM" VALUES
;         ARE CALCULATED TO GIVE A GRADUAL RISE IN SPEED WITH EACH
;         DECREMENT IN THE TABLE INDEX.
;      THE SLOWEST SPEED IS INDEX 25 ($19)

; mtabspd moved above for ROM space
; mtabinc moved below for ROM space
; TABLES FOR DIFFERENT FOOD CHARACTERISTICS:

FLYSPEED  DB      6,4,5,4                ; BAN,PEA,PIE,TOM-- VALUE FOR CSINDEX
          DB      10,8,9,8

FLYDIST   DB      $C7,$35,$9F,$68        ; FOR 1 CYCLE PER FRAME

; FOOD POSITION JUST BEFORE RELEASING:

CTHYPOS   DB      4,0,-4,-8,-12,-8,-4    uses following byte

CTHXPOS   DB      00,4,6,4,0,-4,-6,-4

; CHEFMOVE.S

; CHEF CHARACTER TABLES
; INDEX INTO BY SHIFTING LEFT ONE; THE HEAD WILL BE THERE, THE FEET
;         IN THE NEXT SLOT.

CHRIGHT   DB      $08,$44,$06,$42,$04,$40
CHLEFT    DB      $0E,$4A,$0C,$48,$0A,$46

; CHEF ANIMATION TABLES:

CHHEADS   DB      $1C,$1B,$1A,$19,$18,$1F,$1E,$1D    ; INDEXED BY DIRECTION

CHRUNRC   DB      $26,$24,$22,$20        ; RUNNING RIGHT WITH ARM UP

CHRUNR    DB      $2E,$2C,$2A,$28        ; RUNNING RIGHT, NO CARRY

CHRUNLC   DB      $30,$32,$34,$36        ; RUNNING LEFT WITH CARRY

CHRUNL    DB      $38,$3A,$3C,$3E        ; RUNNING LEFT, NO CARRY

REJOYCH   DB      $FC,$FA,$F8,$F6


CHFLYSPD  DB      9,7,8,7

; FOODMOVE.S

PIEFLY    DB      $62,$5F,$60,$5D        ; UP THROUGH DOWN RIGHT
          DB      $62,$5C,$61,$5E        ; SOUTH THROUGH NWEST

PIEFLYPW  DB      $5E,$5F,$5F,$5F
          DB      $5E,$5F,$5F,$5F

BANFLY    DB      $4E,$4F,$51,$53        ; ANIMATION OF FLYING BANANA
          DB      $55,$57,$59,$5A

BANFLYPW  DB      $BF,$BE,$BE,$BE
          DB      $BE,$BE,$BF,$BF

PEAFLY    DB      $76,$74,$72

SPLATCH   DB      $4E,$4C,$4A,$48,$46
SPLATPW   DB      $1E,$1E,$1E,$1E,$1E

MTABINC   DB      3,2,1,0,3,2,1,3,0,3,1
          DB      2,3,0,1,2,3,0,3,2,1,0,2,0        uses two following bytes

XVECTORH  DB      $00,$00,$01,$02,$03,$03,$04,$04
          DB      $04,$04,$04,$03,$03,$02,$01,$00
          DB      $00,$FF,$FE,$FD,$FC,$FC,$FB,$FB
          DB      $FB,$FB,$FB,$FC,$FC,$FD,$FE,$FF

XVECTORL  DB      $00,$DB,$AD,$6E,$18,$A3,$0B,$4A
          DB      $60,$4A,$0B,$A3,$18,$6E,$AD,$DB
          DB      $00,$26,$54,$93,$E9,$5E,$F6,$B7
          DB      $A1,$B7,$F6,$5E,$E9,$93,$54,$26

; YVECTORH MOVED BELOW FOR ROM SPACE
YVECTORL  DB      $00,$DE,$78,$D2,$F3,$E4,$AE,$5E
          DB      $00,$A3,$53,$1D,$0E,$2F,$89,$23
          DB      $01,$23,$89,$2F,$0E,$1D,$53,$A3
          DB      $00,$5E,$AE,$E4,$F3,$D2,$78,$DE

SCOREX    DB      $30,$82

; ICEMELT.S

ICECHAR   DB      $0E,$0C,$0A,$08,$06,$04,$02,$00

DRIPCHAR  DB      $12,$11,$10

;MOVE.S

CHEIGHT   DB      $17,$0,$0              ; CHUCK
          DB      $16,$0,$0,$16,$0,$0,$16,$0,$0,$16,$0,$0      ; CHEFS
          DB      $9,$9,$9,$9,$9,$9,$9,$9        ; FOODS
          DB      $9,$9,$9,$9,$9,$9,$9,$9

CWIDTH    DB      $8,$0,$0               ; CHUCK
          DB      $8,$0,$0,$8,$0,$0,$8,$0,$0,$8,$0,$0        ; CHEFS
          DB      $6,$6,$6,$6,$6,$6,$6,$6        ; FOODS
          DB      $6,$6,$6,$6,$6,$6,$6,$6

; FOODHIT.S

; TABLES TO MAKE INTERSECTIONS AWESOME:

; CHANGED CHARACTER SIZES FOR FOODHIT. (ROB 6.14.84)
; FCENTERY  DB      7,0,0,7,0,0,7,0,0,4,0,0,4
; DYFCHAR   DB      13,0,0,9,0,0,9,0,0,12,0,0,12
FCENTERY  DB      8,0,0,8,0,0,8,0,0,5,0,0,5
DYFCHAR   DB      14,0,0,10,0,0,10,0,0,13,0,0,13

CHHITE    DB      $3,$3,$3
          DB      $1,$1,$1,$1,$1,$1
          DB      $1,$1,$1,$1

STUKXPOS  DB      2,8,2,-4,4,7,0,-3,6,6,-2,-2,7,4,-3,0

STUKYPOS  DB      4,-4,-12,-4,2,-6,-10,-2,0,-8,-8,0,-2,-10,-6,2

;HOLEHIT.S

CHARHITE  DB      $9,$9,$9            ; HERO HEIGHT
          DB      $7,$7,$7,$7,$7,$7     ; CHEF HEIGHTS
          DB      $7,$7,$7,$7

FALLSND   DB      $08,$00,$00
          DB      $08,$00,$00
          DB      $10,$00,$00
          DB      $12,$00,$00
          DB      $14,$00,$00

;CHEFHIT.S

HYCENTER  DB      $FE,$FE,1,1
DYHCHAR   DB      $0F,$10,$11,$12

;PILEHIT.S

; PUT 9 ENTRIES IN THIS TABLE, BECAUSE THE DIRECTION MIGHT BE "8"
;         IF THE FOOD COMES FROM THE PILE WHICH THE HERO IS ON

XFOODADJ  DB      9,-4,-4,-4,-4,9,9,9
YFOODADJ  DB      -2,-2,-2,-2,0,-3,-2,-2

; THE FOLLOWING TABLES CONTAIN CHARACTER POINTER LOW BYTES FOR THE
;         PILES OF FOOD.  THESE CHARACTERS ARE PLACED IN TABLES SO
;         THAT I CAN GET THE CHARACTER JUST BY INDEXING FROM THE PILE
;         SIZE.

PILECHAR
BANCHTAB  DB      $85,$83,$7F,$7B
          DB      $85,$83,$7F,$7B

PEACHTAB  DB      $A6,$A4,$A2,$9F
          DB      $9C,$99,$96,$93

PIECHTAB  DB      $B4,$B0,$AC,$A8
          DB      $B4,$B0,$AC,$A8

TOMCHTAB  DB      $90,$8D,$8A,$87
          DB      $90,$8D,$8A,$87        ; SAME 4 REPEATED

WATCHTAB  DB      $78,$78,$78,$78
          DB      $78,$78,$78,$78

PILEPALW
BANPWTAB  DB      $BE,$BE,$BC,$BC        ; BANANAS
          DB      $BE,$BE,$BC,$BC
PEAPWTAB  DB      $7E,$7E,$7E,$7D        ; PEAS
          DB      $7D,$7D,$7D,$7D
PIEPWTAB  DB      $5C,$5C,$5C,$5C        ; PIES
          DB      $5C,$5C,$5C,$5C
TOMPWTAB  DB      $9D,$9D,$9D,$9D        ; TOMATOES
          DB      $9D,$9D,$9D,$9D
WATPWTAB  DB      $DD,$DD,$DD,$DD
          DB      $DD,$DD,$DD,$DD

AAPILEX
PILECTR
BANCTR    DB      $FE,$FF,$03,$03        ; BANANAS
          DB      $03,$03,$03,$03
PEACTR    DB      $00,$00,$00,$00        ; PEAS
          DB      $01,$02,$03,$03
PIECTR    DB      $03,$07,$07,$07        ; PIES
          DB      $07,$07,$07,$07
TOMCTR    DB      $00,$02,$02,$02        ; TOMATOES
          DB      $02,$02,$02,$02
WATCTR    DB      $03,$03,$03,$03
          DB      $03,$03,$03,$03

AAPILEDX
PILEDX
          DB      $06,$07,$0B,$0B        ; BANANAS
          DB      $0B,$0B,$0B,$0B
          DB      $07,$07,$07,$07        ; PEAS
          DB      $08,$09,$0A,$0A
          DB      $06,$0A,$0A,$0A        ; PIES
          DB      $0A,$0A,$0A,$0A
          DB      $07,$09,$09,$09        ; TOMATOES
          DB      $09,$09,$09,$09
          DB      $0A,$0A,$0A,$0A
          DB      $0A,$0A,$0A,$0A

AAPILEY
PILECTRY
          DB      $6,$6,$6,$6            bananas
          DB      $3,$3,$3,$3
          DB      $2,$2,$3,$3            peas
          DB      $4,$5,$6,$7
          DB      $2,$2,$4,$4            pie
          DB      $FF,$FF,$1,$1
          DB      $2,$2,$4,$4            tomatoes
          DB      $FF,$FF,$1,$1
          DB      $0,$0,$0,$0,$0,$0,$0,$0        watermelon

AAPILEDY
PILEDY
          DB      16,16,16,16            bananas
          DB      19,19,19,19
          DB      15,15,16,16            peas
          DB      17,18,19,20
          DB      14,14,16,16            pie
          DB      17,17,19,19
          DB      14,14,16,16            tomatoes
          DB      17,17,19,19
          DB      14,14,14,14,14,14,14,14        watermelon

FLYCHAR   DB      $4E,$4C,$62,$5B,$F4
FLYPALW   DB      $BF,$7E,$5E,$9F,$DE

; SCORE.S

; WILL BE ADDED TO PLSCORE+2

LOSCORE   DB      $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$10
          DB      00,$10,$20,$30,$40,$50,$60,$70,$80,$90,00,$10,$20
          DB      $30,$40,$50,$60,$70,$80,$90,$00,$10,$20,$30,$40,$50

; WILL BE ADDED TO PLSCORE+1 (ONLY NEEDED FOR CONE BONUS)

HISCORE   DB      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
          DB      00,00,00,00,00,00,00,00,00,00,01,01,01,01,01,01,01
          DB      01,01,01,02,02,02,02,02,02

; SOUND.S

YVECTORH  DB      $07,$06,$06,$05,$04,$03,$02,$01
          DB      $00,$FE,$FD,$FC,$FB,$FA,$F9,$F9
          DB      $F9,$F9,$F9,$FA,$FB,$FC,$FD,$FE
          DB      $00,$01,$02,$03,$04,$05                uses following 2 bytes

DURTABL   DB      $06,$06,$06,$01,$02,$02,$01,$02,$02,$06,$06,$06
          DB      $06,$0C,$01,$03,$02,$01,$02,$02,$02,$06,$06,$06
          DB      $06,$03,$03,$05,$01,$01,$06,$06,$06
CTRLTABL  DB      $0D,$04,$0D,$08,$08,$08,$0F,$0D,$0D,$04,$04,$0D
          DB      $04,$06,$0D,$06,$06,$0D,$0D,$0D,$04,$04,$0D,$04
          DB      $0D,$04,$0D,$0D,$08,$0D,$0D,$04,$0D

PRYOR     DB      100,110,110,95,95,90,80,97,97,100,110,110
          DB      100,100,90,97,97,97,97,97,97,100,100,100,100
          DB      100,100,100,100,100,100,100,100

; FREQUENCY TABLES FOR ALL SOUNDS:

; BEGINNING THE FIRST RACK:

ZTUNE0F   DB      $17,$42,$12,$42,$17,$42,$12,$42
          DB      $97,$0C,$44,$97,$0C,$44
          DB      $17,$42,$97,$02,$42,$97,$02,$42
          DB      $17,$42,$12,$42
          DB      $97,$1A,$46

          DB      $12,$42,$0F,$42,$12,$42,$0F,$42,$92,$0C,$44
          DB      $92,$0C,$44,$12,$42,$92,$02,$42,$92,$02,$42
          DB      $12,$42,$0F,$42,$92,$1A,$46

          DB      $1F,$42,$17,$42
          DB      $1F,$42,$17,$42,$9F,$0C,$44
          DB      $9F,$0C,$44,$1F,$42,$9F,$02,$42,$9F,$02,$42
          DB      $1F,$42,$17,$42,$9F,$1A,$FF

; TWO VOICES FOR HERO DEATH (ALL BUT LAST TIME)

ZTUNE1F   DB      $11,$46,$14,$46,$17,$14,$4A
          DB      $91,$0A,$92,$02,$94,$02,$97,$02,$9A,$02
          DB      $9B,$02,$9F,$02,$2D,$8B,$14,$FF

ZTUNE2F   DB      $0B,$46,$0D,$46,$0F,$0D,$4A
          DB      $8B,$16,$97,$14,$FF

ZTUNE30V                                 ; BEGINNING OTHER RACKS
ZTUNE1V
ZTUNE2V
ZTUNE0V   DB      $89                    ; ALL SAME VOLUME

; CHUCK THROWING FOOD

ZTUNE3F   DB      $0A,$09,$08,$07,$06,$05,$04,$03,$02,$01,$02,$03,$04,$FF

ZTUNE3V   DB      $01,$02,$03,$04,$05,$06,$07,$06,$05,$04,$03,$02,$81

; CHEF HIT WITH FOOD

ZTUNE4F   DB      $94,$0E,$FF

ZTUNE4V   DB      $09,$07,$05,$04,$03,$02,$81

; FOOTSTEPS

ZTUNE5F   DB      $14,$FF

ZTUNE5V   DB      $87

; FOOD "GLOP" (HITTING HERO, SCORE)

ZTUNE6F   DB      $F,$A,$8,$F,$A,$8,$F,$A
          DB      $8,$F,$A,$24,$B,$28,$A,$2D,$E,$24,$A,$28,$E,$FF

ZTUNE6V   DB      $2,$3,$4,$5,$6,$7,$8,$9
          DB      $9,$8,$7,$6,$5,$4,$3,$2

; ANGELO RISE

ZTUNE7F   DB      $1F,$1D,$1B,$1A,$18,$17,$16,$14,$13,$12,$11
          DB      $10,$0F,$0E,$0D,$0C,$0B,$0A,$09,$FF

; ANGELO FALL

ZTUNE8F   DB      $11,$12,$13,$15,$17,$19,$1B,$1D,$1F,$26
          DB      $06,$06,$07,$07,$08,$FF

ZTUNE7V
ZTUNE8V   DB      $88

; WARNING CHIME

ZTUNE9F   DB      $11,$11,$11,$11,$11,$11,$11,$11,$11,$11
          DB      $11,$11,$11,$11,$11,$11,$11,$11,$11,$FF

ZTUNE9V   DB      $0B,$08,$07,$06,$05,$0B,$08,$07,$06,$05
          DB      $0B,$08,$07,$06,$05,$04,$03,$02,$81

; HERO DEATH, ALL BUT FIRST TIME:

ATUNE10F  DB      $1B,$17,$11,$12,$12,$17,$12,$0F,$91,$1E,$FF

ZTUNE10V  DB      $89

ATUNE11F  DB      $17,$52,$0F,$52,$0B,$46,$0F,$46,$0B,$FF

ZTUNE11V  DB      $0A,$09,$07,$08,$88

; END OF GAME MELODY (SIMILAR TO ALL-BUT-LAST DEATH SOUND)

ATUNE12F  DB      $11,$46,$14,$46,$17,$14,$4C
          DB      $11,$46,$14,$46,$17,$14,$4C
          DB      $11,$46,$14,$46,$17,$14,$4C
          DB      $11,$90,$02,$8F,$02,$8E,02,$8D,$02,$8C,$02
          DB      $8B,$02,$8A,$02,$89,$02,$88,$10,$FF

ZTUNE12V  DB      $89

ATUNE13F  DB      $12,$64,$12,$64
          DB      $2D,$97,$04,$48,$9B,$04,$48,$9F,$04,$48
          DB      $9B,$04,$48,$97,$04,$54,$26,$12,$FF

ZTUNE13V  DB      $88

; CONE DRIP SOUND

ZTUNE14F  DB      $1F,$1B,$18,$15,$13,$11,$0F,$0D,$FF

ZTUNE14V  DB      $87

; OSCAR RISE

ZTUNE15F  DB      $1D,$1B,$1A,$18,$17,$15,$14,$13,$12,$11,$10
          DB      $0F,$0E,$0D,$FF

ZTUNE15V  DB      $89

; OSCAR FALL

ZTUNE16F  DB      $06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
          DB      $10,$11,$12,$FF

ZTUNE16V  DB      $89

;JACQUES RISE

ZTUNE17F  DB      $1F,$1D,$1B,$1A,$18,$17,$16,$14,$13,$12
          DB      $17,$16,$14,$13,$12,$11,$10,$0F,$0E,$0D
          DB      $12,$11,$10,$0F,$0E,$0D,$0C,$0B,$0A,$09
          DB      $0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$FF

ZTUNE17V  DB      $88

; JACQUES FALL

ZTUNE18F  DB      $06,$08,$0A,$0C,$0A,$0C,$0E,$10,$0D,$0F
          DB      $11,$13,$12,$14,$FF

ZTUNE18V  DB      $88

; ZORBA RISE

ZTUNE19F  DB      $1F,$1D,$1B,$1A,$18,$17,$15,$14,$13,$12,$11
          DB      $10,$0F,$0E,$0D,$0C,$0B
          DB      $24,$1F,$1D,$1B,$1A,$18,$17,$15,$14,$FF

ZTUNE19V  DB      $88

; ZORBA FALL

ZTUNE20F  DB      $1A,$1B,$1D,$1F
          DB      $2D,$0B,$0C,$0D,$0E,$0F,$10,$11,$12,$13,$14,$15
          DB      $17,$18,$1A,$1B,$FF

ZTUNE20V  DB      $88

; INSTANT REPLAY TUNE SEGMENTS--

; THIS IS THE INTRO TO THE TUNE: (DURATION 4, PART B IS DURATION 2)
;  THIS INTRO CONTINUES DIRECTLY INTO PART A

ZTUNE21F  DB      $1A,$1B,$1A,$14,$2D,$0B,$0C,$0B,$24,$1A
          DB      $2D,$0D,$0E,$0D,$0B,$11,$12,$11,$0D
          DB      $97,$12,$16,$14,$14,$13,$13
          DB      $92,$18,$97,$18,$FD,$17        ; CONTINUE WITH PART A

ZTUNE22F  DB      $11,$11,$64
          DB      $11,$11,$64
          DB      $70
          DB      $70,$FD,$18

ZTUNE21V  DB      $88
ZTUNE22V  DB      $86

; 23 AND 24 ARE PART A OF THE TUNE, DURATION 4

ZTUNE23F  DB      $1A,$1B,$1A,$1B,$1A,$1B,$1A,$1B
          DB      $1A,$1B,$1A,$1B,$1A,$1B,$1A,$18
          DB      $17,$46,$1B,$46,$1F,$1B,$46,$17
          DB      $97,$1E,$52
          DB      $1B,$1F,$1B,$1A,$17,$1B,$1F,$2D,$0B,$24
          DB      $1B,$1A,$18,$17,$17,$1B,$1F,$2D,$0B,$24
          DB      $1A,$1B,$1A,$17,$14,$1A,$1F,$2D,$0B,$24
          DB      $1A,$17,$15,$14,$FC,$1A,$FB,$1B,$1F,$2D,$0B,$24
          DB      $1A,$1B,$1A,$1B,$1A,$1B,$1A,$1B
          DB      $1A,$1B,$1A,$1B,$1A,$1B,$1A,$18
          DB      $17,$46,$1B,$46,$1F,$1B,$46
          DB      $97,$2A,$4C,$FC
          DB      $1B,$FB,$1A,$17,$1A,$1B,$1D,$1B,$1D
          DB      $1B,$1A,$18,$17,$17,$13,$14,$17
          DB      $1A,$46,$1F,$46,$2D,$0B,$24,$1F,$46,$9A,$18
          DB      $46,$2D,$91,$18,$FC,$FD,$19        ; OKAY ENDING

ZTUNE24F  DB      $11,$46,$0D,$46,$17,$46,$0D,$46
          DB      $11,$46,$0D,$46,$17,$46,$0D,$46
          DB      $12,$46,$0B,$46,$17,$46,$0B,$46
          DB      $12,$46,$0B,$46,$17,$46,$0B,$46
          DB      $12,$46,$0B,$46,$17,$46,$0B,$46
          DB      $12,$46,$14,$46,$12,$46,$17,$46
          DB      $11,$46,$12,$46,$14,$46,$12,$46
          DB      $11,$46,$12,$46,$11,$46,$17,$46
          DB      $11,$46,$0D,$46,$17,$46,$0D,$46
          DB      $11,$46,$0D,$46,$17,$46,$0D,$46
          DB      $12,$46,$0B,$46,$17,$46,$0B,$46
          DB      $12,$46,$0B,$46,$17,$46,$0B,$46
          DB      $12,$46,$0B,$46,$17,$46,$0B,$46
          DB      $12,$46,$0B,$46,$17,$46,$0B,$46
          DB      $4C,$17,$46,$14,$46,$12,$46
          DB      $91,$18,$58,$FC,$FD,$1A

ZTUNE23V  DB      $88
ZTUNE24V  DB      $86

; THE FOLLOWING TWO TUNES ARE FOR THE "B" PART OF THE TUNE.

ZTUNE25F  DB      $15,$FB,$94,$15
          DB      $1B,$9A,$15
          DB      $2D,$0C,$8B,$15
          DB      $0E,$8D,$15
          DB      $12,$12,$11,$11,$0F,$0F,$0D,$0D
          DB      $0F,$0F,$10,$10,$0F,$0F,$11,$11
          DB      $92,$21,$4F,$FC
          DB      $24,$18,$FB,$97,$15
          DB      $1C,$9B,$15
          DB      $2D,$0C,$8B,$15
          DB      $13,$92,$09,$4C
          DB      $11,$11,$12,$12,$11,$11,$17,$17
          DB      $0D,$0D,$0E,$0E,$0D,$0D,$11,$11
          DB      $0B,$0B,$0C,$0C,$0B,$0B,$0D,$0D
          DB      $24,$1A,$1A,$1B,$1B,$1A,$1A,$2D,$0B,$0B,$FC,$24
          DB      $15,$FB,$94,$15
          DB      $1B,$9A,$15
          DB      $2D,$0C,$8B,$15
          DB      $0E,$8D,$15,$FC
          DB      $24,$10,$FB,$8F,$15
          DB      $14,$93,$15
          DB      $1B,$9A,$15
          DB      $2D,$0A,$24,$9F,$15
          DB      $10,$10,$15,$15,$1A,$1A,$2D,$0A,$43
          DB      $0A,$0A,$24,$1A,$1A,$15,$15,$10,$10
          DB      $11,$11,$14,$14,$1A,$1A,$2D,$0B,$43
          DB      $0B,$0B,$24,$1A,$1A,$14,$14,$13,$13
          DB      $91,$12,$13,$13
          DB      $94,$0C,$97,$0C
          DB      $9A,$27,$FC,$FF

ZTUNE25V  DB      $88

ZTUNE26F  DB      $91,$0C,$FB,$8D,$0C,$97,$0C,$8B,$0C
          DB      $91,$0C,$8D,$0C,$97,$0C,$8B,$0C
          DB      $97,$0C,$92,$0C,$9F,$0C,$92,$0C
          DB      $97,$0C,$9F,$0C,$9B,$0C,$98,$0C
          DB      $97,$0C,$92,$0C,$9F,$0C,$92,$0C
          DB      $97,$0C,$92,$0C,$9F,$0C,$97,$0C
          DB      $70
          DB      $91,$0C,$97,$0C,$94,$0C,$92,$0C
          DB      $91,$0C,$8D,$0C,$97,$0C,$8D,$0C
          DB      $91,$0C,$8D,$0C,$97,$0C,$91,$0C
          DB      $9A,$0C,$9B,$0C,$9A,$0C,$97,$0C
          DB      $94,$0C,$92,$0C,$91,$0C,$94,$0C
          DB      $95,$0C,$58,$95,$0C
          DB      $97,$0C,$58,$97,$06,$46
          DB      $97,$0C,$4C,$97,$0C,$4C
          DB      $91,$27,$FC,$FF

ZTUNE26V  DB      $86

; BONUS LIFE SOUND:

ZTUNE27F  DB      $1F,$17,$12,$0F,$0F,$12,$8F,$19,$FF

ZTUNE27V  DB      $8B

; CHARLIE MUNCH SOUND:

ZTUNE28F  DB      $19,$16,$13,$10,$0E,$0C,$0A,$09
          DB      $08,$7,$6,$5,$4,$3,$2,$1,$FF

ZTUNE29F  DB      $11,$13,$15,$17,$19,$1C,$1F,$19
          DB      $17,$15,$13,$11,$0F,$0E,$0D,$0C,$FF

ZTUNE28V  DB      $84

ZTUNE31V
ZTUNE32V
ZTUNE29V  DB      $87

; BEGINNING RACKS OTHER THAN THE FIRST:

ZTUNE30F  DB      $17,$42,$12,$42,$17,$42,$12,$42
          DB      $97,$0C,$44,$97,$0C,$44
          DB      $17,$42,$97,$02,$42,$97,$02,$42
          DB      $17,$42,$12,$42
          DB      $97,$1A,$FF

; TAG AT THE END OF INSTANT REPLAY:

ZTUNE31F  DB      $1A,$46,$1F,$46,$2D,$0B,$24,$1F,$4C
          DB      $1A,$46,$1F,$46,$2D,$0B,$24,$1F,$4C
          DB      $1A,$46,$1F,$46,$2D,$0B,$24,$1F,$48
          DB      $9A,$1E,$58,$FF

ZTUNE32F  DB      $11,$11,$64
          DB      $11,$11,$64
          DB      $11,$46,$17,$46,$14,$46,$12,$46
          DB      $11,$52,$91,$18,$FF

