*** CTABLES.S ***
* KGO     8/30    TUNE TABLES

COLORTBL
          DB      $BA,$54,$57
          DB      $17,$49,$15
          DB      $6A,$C5,$C3            ;COLOR DEFINITIONS      1
          DB      $89,$38,$31            ;RED

          DB      $4B,$15,$17
          DB      $64,$1A,$65
          DB      $9A,$46,$43            ;COLOR DEFINITIONS      2
          DB      $DA,$58,$52            ;

          DB      $1C,$62,$64
          DB      $C5,$6A,$84
          DB      $4B,$36,$34            ;COLOR DEFINITIONS      3
          DB      $69,$1C,$12            ;YELLOW

          DB      $9A,$42,$45
          DB      $85,$4A,$C6
          DB      $1C,$26,$24            ;COLOR DEFINITIONS      4
          DB      $1B,$88,$82            ;DARK BLUE

          DB      $4A,$C3,$B6
          DB      $E7,$69,$E7
          DB      $6A,$C5,$C3            ;COLOR DEFINITIONS      5
          DB      $EB,$67,$62            ;PURPLE?

          DB      $6B,$C2,$C4
          DB      $59,$39,$66
          DB      $4A,$A7,$A5            ;COLOR DEFINITIONS      6
          DB      $89,$36,$31            ;ORANGE

          DB      $39,$E4,$E7
          DB      $B7,$A9,$C8
          DB      $6B,$57,$65            ;COLOR DEFINITIONS      7
          DB      $1B,$99,$93            ;PURPLE?

          DB      $AD,$56,$69
          DB      $86,$59,$85
          DB      $4B,$18,$15            ;COLOR DEFINITIONS      8
          DB      $8C,$48,$21            ;RED

          DB      $5B,$83,$86
          DB      $D6,$1A,$D7
          DB      $AA,$57,$65            ;COLOR DEFINITIONS      9
          DB      $3C,$D9,$D2            ;GREEN

          DB      $5D,$D3,$D6
          DB      $1A,$AB,$18
          DB      $5B,$98,$95            ;COLOR DEFINITIONS      10
          DB      $CC,$26,$21            ;RED

          DB      $5B,$87,$8A
          DB      $46,$9A,$47
          DB      $1B,$76,$74            ;COLOR DEFINITIONS      11
          DB      $8C,$38,$51            ;RED

          DB      $9A,$43,$46
          DB      $97,$BA,$96
          DB      $AB,$C6,$B4            ;COLOR DEFINITIONS      12
          DB      $3B,$A9,$A3            ;PURPLE




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


TBASE     DB      L(SHTSND),L(SPDRSND),L(EXP1SND),L(PLYDTHS),L(FLEASND)
          DB      L(SCRPSND),L(XTRAMAN),L(PEDEWLK)
TBASEH    DB      H(SHTSND),H(SPDRSND),H(EXP1SND),H(PLYDTHS),H(FLEASND)
          DB      H(SCRPSND),H(XTRAMAN),H(PEDEWLK)
VBASE     DB      L(SHTSNDV),L(SPDRSNDV),L(EXP1SNDV),L(PLYDTHSV),L(FLEASNDV)
          DB      L(SCRPSNDV),L(XTRAMANV),L(PEDEWLKV)
VBASEH    DB      H(SHTSNDV),H(SPDRSNDV),H(EXP1SNDV),H(PLYDTHSV),H(FLEASNDV)
          DB      H(SCRPSNDV),H(XTRAMANV),H(PEDEWLKV)
CBASE     DB      L(SHTSNDC),L(SPDRSNDC),L(EXP1SNDC),L(PLYDTHSC),L(FLEASNDC)
          DB      L(SCRPSNDC),L(XTRAMANC),L(PEDEWLKC)
CBASEH    DB      H(SHTSNDC),H(SPDRSNDC),H(EXP1SNDC),H(PLYDTHSC),H(FLEASNDC)
          DB      H(SCRPSNDC),H(XTRAMANC),H(PEDEWLKC)
DURTABL   DB      $00,$01,$00,$01,$06,$03,$07,$01
PRYOR     DB      2,1,2,8,8,3,9,0

FREQTABL
SHTSND    DB      $01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
          DB      $10,$FF
SPDRSND   DB      $00,$10,$00,$0E,$01,$09,$00,$00,$00,$09,$01,$0E,$00,$10,$01
          DB      $0E,$00,$09,$00,$FE    ;REPEATS
EXP1SND   DB      $1A,$1A,$1B,$1C,$1D,$1E,$1F,$1F,$FF
PLYDTHS   DB      $14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$1F,$1F,$1F
          DB      $1F,$FF
FLEASND   DB      $0E,$0F,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C
          DB      $1D,$1E,$1F,$FF
SCRPSND   DB      $11,$1B,$11,$14,$18,$14,$FE    ;REPEATS
XTRAMAN   DB      $1B,$14,$10,$0D,$0D,$10,$0D,$0D,$0D,$0D,$1F,$18,$14,$14,$18
          DB      $14,$14,$FF
PEDEWLK   DB      $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$FE    ;REPEATS


VOLTABL
SHTSNDV   DB      $88

SPDRSNDV  DB      $00,$08,$01,$08,$01,$08,$01,$00,$00,$08,$01,$08,$01,$08,$01
          DB      $08,$01,$08,$01,$FE    ;REPEATS
EXP1SNDV  DB      $0C,$0C,$0B,$0A,$09,$08,$07,$06,$FF
PLYDTHSV  DB      $0C,$0C,$0C,$0B,$0A,$09,$08,$07,$07,$07,$07,$07,$06,$06,$06
          DB      $06,$FF
FLEASNDV  DB      $88

SCRPSNDV  DB      $88
XTRAMANV  DB      $8B

PEDEWLKV  DB      $0A,$0A,$09,$00,$06,$00,$00,$00,$FE    ;REPEATS

CTLTABL
SHTSNDC   DB      $89

SPDRSNDC  DB      $84

EXP1SNDC  DB      $88
PLYDTHSC  DB      $88

FLEASNDC  DB      $8D

SCRPSNDC  DB      $8D
XTRAMANC  DB      $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$04,$04,$04,$04,$04
          DB      $04,$04,$FF
PEDEWLKC  DB      $8F

********************************************************************************
*                         DLL TABLE FOR HSC LOGO                               *
********************************************************************************


;         PAD THE TOP
HSCDLL    DB      $2E,H(TPDL),L(TPDL)
          DB      $A8,H(TPDL),L(TPDL)

          DB      $27,H(DL6),L(DL6)
          DB      $27,H(DL7),L(DL7)
          DB      $27,H(DL8),L(DL8)
          DB      $27,H(DL9),L(DL9)
          DB      $27,H(DL10),L(DL10)
          DB      $26,H(DL16),L(DL16)    ;GAME TYPE
          DB      $26,H(DL19),L(DL19)    ;DIFF. LEVEL
          DB      $A0,H(TPDL),L(TPDL)



******************************************
* ASSEMBLE INTO GRAPHICS BLOCK
******************************************
          ORG     $C098                  ;TO $C0FF
HDLTBL    DB      H(DL1),H(DL2),H(DL3),H(DL4)            ;24
          DB      H(DL5),H(DL6),H(DL7),H(DL8)
          DB      H(DL9),H(DL10),H(DL11),H(DL12)
          DB      H(DL13),H(DL14),H(DL15),H(DL16)
          DB      H(DL17),H(DL18),H(DL19),H(DL20)
          DB      H(DL21),H(DL22),H(DL23),H(DL24)

LDLTBL    DB      L(DL1),L(DL2),L(DL3),L(DL4)            ;24
          DB      L(DL5),L(DL6),L(DL7),L(DL8)
          DB      L(DL9),L(DL10),L(DL11),L(DL12)
          DB      L(DL13),L(DL14),L(DL15),L(DL16)
          DB      L(DL17),L(DL18),L(DL19),L(DL20)
          DB      L(DL21),L(DL22),L(DL23),L(DL24)

MMAPTBLH  DB      H(MUSHMAP),H(MUSHMAP+ZONELEN),H(MUSHMAP+2*ZONELEN)     ;24
          DB      H(MUSHMAP+3*ZONELEN),H(MUSHMAP+4*ZONELEN),H(MUSHMAP+5*ZONELEN)
          DB      H(MUSHMAP+6*ZONELEN),H(MUSHMAP+7*ZONELEN),H(MUSHMAP+8*ZONELEN)
          DB      H(MUSHMAP+9*ZONELEN),H(MUSHMAP+10*ZONELEN)
          DB      H(MUSHMAP+11*ZONELEN),H(MUSHMAP+12*ZONELEN)
          DB      H(MUSHMAP+13*ZONELEN),H(MUSHMAP+14*ZONELEN)
          DB      H(MUSHMAP+15*ZONELEN),H(MUSHMAP+16*ZONELEN)
          DB      H(MUSHMAP+17*ZONELEN),H(MUSHMAP+18*ZONELEN)
          DB      H(MUSHMAP+19*ZONELEN),H(MUSHMAP+20*ZONELEN)
          DB      H(MUSHMAP+21*ZONELEN),H(MUSHMAP+22*ZONELEN)

MMAPTBLL  DB      L(MUSHMAP),L(MUSHMAP+ZONELEN),L(MUSHMAP+2*ZONELEN)     ;24
          DB      L(MUSHMAP+3*ZONELEN),L(MUSHMAP+4*ZONELEN),L(MUSHMAP+5*ZONELEN)
          DB      L(MUSHMAP+6*ZONELEN),L(MUSHMAP+7*ZONELEN),L(MUSHMAP+8*ZONELEN)
          DB      L(MUSHMAP+9*ZONELEN),L(MUSHMAP+10*ZONELEN)
          DB      L(MUSHMAP+11*ZONELEN),L(MUSHMAP+12*ZONELEN)
          DB      L(MUSHMAP+13*ZONELEN),L(MUSHMAP+14*ZONELEN)
          DB      L(MUSHMAP+15*ZONELEN),L(MUSHMAP+16*ZONELEN)
          DB      L(MUSHMAP+17*ZONELEN),L(MUSHMAP+18*ZONELEN)
          DB      L(MUSHMAP+19*ZONELEN),L(MUSHMAP+20*ZONELEN)
          DB      L(MUSHMAP+21*ZONELEN),L(MUSHMAP+22*ZONELEN)

BITTABLE  DB      $01,$02,$04,$08,$10,$20,$40,$80


********************************************************************************
*                        MARIA 2 DLL INTIALIZATION TABLE                       *
********************************************************************************
******************************************
* ASSEMBLE INTO GRAPHICS BLOCK
******************************************
          ORG     $C198                  ;TO $C1F5

DLLTABLE  DB      $2F,H(TPDL),L(TPDL)    ;TOP OF SCREEN INTERRUPT(WHO NEEDS IT?)
          DB      $27,H(TPDL),L(TPDL)
; 25 LINES PADDING ON TOP AND BOTTOM FOR NOW. SOME STANDARD SHOULD BE SET.

          DB      $27,H(DL1),L(DL1)
          DB      $00,H(HLINEDL),L(HLINEDL)
          DB      $A7,H(DL2),L(DL2)      ;CHANGE MODE TO 160 (AFTER SCORE)
          DB      $27,H(DL3),L(DL3)
          DB      $27,H(DL4),L(DL4)
          DB      $27,H(DL5),L(DL5)
          DB      $27,H(DL6),L(DL6)
          DB      $27,H(DL7),L(DL7)
          DB      $27,H(DL8),L(DL8)
          DB      $27,H(DL9),L(DL9)
          DB      $27,H(DL10),L(DL10)
          DB      $27,H(DL11),L(DL11)
          DB      $27,H(DL12),L(DL12)
          DB      $27,H(DL13),L(DL13)
          DB      $27,H(DL14),L(DL14)
          DB      $27,H(DL15),L(DL15)
          DB      $27,H(DL16),L(DL16)
          DB      $27,H(DL17),L(DL17)
          DB      $27,H(DL18),L(DL18)
          DB      $27,H(DL19),L(DL19)
          DB      $27,H(DL20),L(DL20)
          DB      $27,H(DL21),L(DL21)
          DB      $27,H(DL22),L(DL22)
          DB      $27,H(DL23),L(DL23)
          DB      $27,H(DL24),L(DL24)
          DB      $00,H(HLINEDL),L(HLINEDL)
          DB      $AE,H(TPDL),L(TPDL)    ;VERTICAL BLANK INTERRUPT
          DB      $27,H(TPDL),L(TPDL)
          DB      $A0,H(TPDL),L(TPDL)    ;REAL VB INTERRUPT
          DB      0
ENDLL



******************************************
* ASSEMBLE INTO GRAPHICS BLOCK
******************************************
          ORG     $C598                  ;100 BYTES
ALOW      DB      L(A1PLYR),L(AALTERN),L(ACOMPET),L(ATEAM)
AHIGH     DB      H(A1PLYR),H(AALTERN),H(ACOMPET),H(ATEAM)

ACOMPET   DB      L(D),L(U),L(A),L(L),L(EMPTY),L(P),L(L),L(A),L(Y),L(E),L(R)
          DB      L(EMPTY),L(C),L(O),L(M),L(P),L(E),L(T),L(I)
          DB      L(T),L(I),L(O),L(N)
AALTERN   DB      L(T),L(W),L(O),L(EMPTY),L(P),L(L),L(A),L(Y),L(E),L(R),L(EMPTY)
          DB      L(A),L(L),L(T),L(E),L(R),L(N),L(A),L(T),L(I),L(N),L(G)
ATEAM     DB      L(EMPTY),L(EMPTY),L(EMPTY),L(EMPTY),L(EMPTY),L(EMPTY),L(EMPTY)
          DB      L(T),L(E),L(A),L(M),L(EMPTY),L(P),L(L),L(A),L(Y)
          DB      L(EMPTY)
A1PLYR    DB      L(EMPTY),L(EMPTY),L(EMPTY),L(EMPTY),L(EMPTY),L(EMPTY)
          DB      L(O),L(N),L(E),L(EMPTY),L(P),L(L),L(A),L(Y),L(E),L(R)
          DB      L(EMPTY),L(EMPTY),L(EMPTY),L(EMPTY),L(EMPTY),L(EMPTY),L(EMPTY)


******************************************
* ASSEMBLE INTO GRAPHICS BLOCK
******************************************
          ORG     $C698                  ;100 BYTES
;WOCTRLS  DB      L(T),L(W),L(O),L(EMPTY),L(C),L(O),L(N),L(T),L(R),L(O),L(L)
;         DB      L(L),L(E),L(R),L(S)
SHRTRCKB  DB      L(S),L(H),L(A),L(R),L(E),L(EMPTY),L(T),L(R),L(A),L(C),L(K)
          DB      L(B),L(A),L(L),L(L)

DFLVLLOW  DB      L(DFNOVICE),L(DFINTRMD),L(DFADVNCD),L(DFEXPERT)
DFLVLHGH  DB      H(DFNOVICE),H(DFINTRMD),H(DFADVNCD),H(DFEXPERT)

DFNOVICE  DB      L(N),L(O),L(V),L(I),L(C),L(E)
DFINTRMD  DB      L(S),L(T),L(A),L(N),L(D),L(A),L(R),L(D)
DFADVNCD  DB      L(A),L(D),L(V),L(A),L(N),L(C),L(E),L(D)
DFEXPERT  DB      L(E),L(X),L(P),L(E),L(R),L(T)

DFPOS     DB      5,15,24,30
DFLNGTH   DB      5,7,7,5


******************************************
* MESSAGES ("PLAYER", "ONE", "TWO", "GAME  OVER"
* AND ROUTINES TO DISPLAY THEM
******************************************
MPLAYER   DB      L(P),L(L),L(A),L(Y),L(E),L(R)
          DB      L(EMPTY),L(EMPTY),L(DGT1)
          DB      L(W),L(I),L(N),L(S)
MGMOVER   DB      L(G),L(A),L(M),L(E),L(EMPTY)
          DB      L(O),L(V),L(E),L(R)
MTIE      DB      L(Y),L(O),L(U),L(EMPTY),L(H),L(A),L(V),L(E),L(EMPTY)
          DB      L(T),L(I),L(E),L(D)

POINTSPR  DB      L(POINT300),L(POINT600),L(POINT900)
MULT3SP   DB      3,6,9

