*MAPVARS
          MAPVGLBL                       public
          PLAYGLBL                       extrn

* NAMED CONSTANTS.
*
STRWIDTH  EQU     8                      ; THE NUMBER OF COLUMNS IN A STRIP
MAPROWS   EQU     105                    ; THE NUMBER OF ROWS IN THE MAP
DECWIDTH  EQU     24                     ; THE MAXIMUM NUMBER OF MAP STAMPS
                                         ; DECOMPRESSED FOR EACH ZONE.  THIS
                                         ; EXCEEDS DISWIDTH BECAUSE STRIPS DON'T
                                         ; GENERALLY ALIGN WITH THE AREA
                                         ; DISPLAYED, SO USUALLY 3 RATHER THAN 2
                                         ; STRIPS MUST BE DECOMPRESSED DURING
                                         ; ANY GIVEN RACK.
NEWRACK   EQU     79                     ; THE NUMBER OF ROWS OF THE MAP THAT
                                         ; MUST BE TRAVERSED BEFORE THE PLAYER
                                         ; WILL GET SENT TO THE NEXT RACK UPON
                                         ; BEING KILLED RATHER THAN BEING SENT
                                         ; BACK TO THE START OF THE CURRENT RACK
CLRSTMP   EQU     174                    ; THE INDEX OF A CLEAR (TRANSPARENT)
                                         ; STAMP.  THIS IS THE SAME AS THE ALL
                                         ; BROWN STAMP SINCE BROWN IS THE
                                         ; BACKGROUND COLOR.
PAL2STMP  EQU     CLRSTMP+2              ; A STAMP USES THE GRAY PALETTE IFF ITS
                                         ; INDEX IS >= PAL2STMP.
GRASS     EQU     2                      ; INDEX OF THE "ALL GRASS" STAMP
TREES     EQU     10                     ; INDEX OF THE "ALL TREES" STAMP
TARG2ROW  EQU     13                     ; A "GROUND TARGET" IS THE BOTTOM ROW
                                         ; OF A 2 ZONE GROUND TARGET IF ITS
                                         ; TYPE IS >= TARG2ROW.
DCMPLXPE  EQU     9                      ; THE TARGETS WITH HIGHEST INDEX THAT
                                         ; THE PLAY CODE IS INFORMED OF ARE THE
                                         ; PERIPHERAL DOMES OF THE DOME COMPLEX.
                                         ; THE PERIPHERAL DOME WITH LOWEST INDEX
                                         ; IS DCMPLXPE.  ALL PERIPHERAL DOMES
                                         ; ARE GIVEN THIS INDEX BEFORE BEING
                                         ; PASSED BACK TO THE PLAY CODE.
FIRSTPXL  EQU     16                     ; THE FIRST DISPLAYED PIXEL
TOPPIXEL  EQU     $D4                    ; THE POSITION OF THE UPPERMOST
                                         ; DISPLAYED PIXEL.
TYPDELTA  EQU     9                      ; SUBTRACTED FROM A 2 ROW, FIRST ROW
                                         ; GROUND TARGET TYPE TO GET THE
                                         ; CORRESPONDING SECOND ROW TYPE.
GREENPAL  EQU     $60                    ; THE GREEN PALLETE CODE IN HIGH 3 BITS
GRAYPAL   EQU     $A0                    ; THE GRAY PALLETTE CODE IN HIGH 3 BITS
NUMRACK   EQU     16                     ; THE NUMBER OF DISTINCT RACKS.
                                         ; RACK IS IN THE RANGE [0, NUMRACK-1]
RACKCYCL  EQU     6                      ; WHERE RACK IS RESTARTED AFTER NUMRACK
                                         ; RACKS HAVE BEEN GONE THROUGH.
*
* EXTERNALS
*
* NOTE - HEADER 1 IS ALWAYS THE "GREEN PALETTE" HEADER AND HEADER 2 IS ALWAYS
*        THE "GRAY PALETTE" HEADER.  HEADER 1 IS USUALLY BUT NOT ALWAYS THE
*        LONGER HEADER.  HEADER 1 ALWAYS PRECEDES HEADER 2 IN THE DISPLAY LIST.
*
*****************************************
CODEF000  CSECT
ATOPMAPV
*         ORG     2*((*+1)/2)
ZTARG0    DB      23,$61,23,$72,36,$71,36,$80,41,$91,42,$90,45,$B2,46,$A0
          DB      62,$70,63,$72,70,$E6,85,$87,89,$80,89,$91,97,$B2,98,$A0
          DB      99,$20,99,$92,100,$80,101,$72,104,$8C,105,$79,105,$88
          DB      105,$9A,106,$8B,107,$16,$7F,$00
ZTARG1    DB      19,$80,19,$91,23,$02,23,$10,28,$80,28,$90,37,$80,44,$80
          DB      44,$92,50,$90,63,$12,67,$80,67,$92,68,$82,68,$90,71,$E6,88,$96
          DB      90,$12,90,$20,97,$61,98,$72,99,$81,100,$92,101,$A1,105,$50
          DB      105,$60,107,$42,107,$53,107,$63,107,$72,$7F,$00
ZTARG2    DB      11,$C2,30,$50,31,$52,42,$2D,45,$06,53,$60,54,$61,55,$87
          DB      58,$61,58,$72
          DB      72,$12,72,$50,76,$A0,79,$A2,85,$22,85,$60,94,$21,94,$40
          DB      94,$62,94,$81,97,$62,103,$72,103,$A0,103,$D2,105,$AE
          DB      106,$E6,$7F,00
ZTARG3    DB      21,$81,21,$92,29,$30,29,$42,29,$96,39,$92,40,$B2,41,$90
          DB      43,$B0,$7F,$00
ZTARG4    DB      19,$42,19,$51,19,$83,20,$41,20,$52,20,$83,42,$AE,62,$87,68,$E6
          DB      69,$91,70,$90,71,$91,72,$90,84,$42,94,$82,95,$D6,105,$7E
          DB      105,$D2,106,$22,$7F,$00
ZTARG5    DB      10,$20,10,$31,23,$32,24,$20,36,$30,36,$41,41,$52,41,$62
          DB      45,$6E,55,$E6,62,$3C,63,$29,63,$38,63,$4A,64,$3B,73,$72,74,$80
          DB      78,$80,81,$70,92,$82,99,$80,100,$60,101,$40,105,$3E,105,$5E
          DB      $7F,$00
ZTARG6    DB      9,$62,10,$61,45,$81,46,$90,47,$A2,48,$B1,60,$C0,66,$16,71,$11
          DB      71,$52,71,$B1,71,$F2,75,$87,93,$A2,93,$E2,106,$E6,$7F,$00
ZTARG7    DB      14,$20,14,$D0,16,$42,16,$B2,18,$60,18,$90,26,$B1,28,$90
          DB      28,$BE,28,$E0,31,$B1,37,$B2,50,$B2,50,$C0,62,$26,65,$B0
          DB      65,$C2
          DB      91,$33,91,$C3,105,$52,105,$82,105,$B2,107,$53,107,$B3,$7F,$00
ZTARG8    DB      10,$76,11,$96,12,$B6,13,$D6,23,$AE,$7F,$00
ZTARG9    DB      42,$41,42,$61,43,$51,44,$41,44,$61,53,$B2,54,$B2,57,$B1
          DB      57,$C1,69,$22,69,$51,69,$82
          DB      86,$26,86,$46,86,$66,86,$86,88,$26,88,$46,88,$66,88,$86
          DB      94,$61,94,$90,94,$C1,97,$B2,101,$7D,104,$7D,106,$E3,106,$13
          DB      108,$E3,108,$13,$7F,$00
ZTARG10   DB      12,$9C,13,$89,13,$98,13,$AA,14,$9B,27,$40,27,$52,55,$86,58,$86
          DB      63,$A2,64,$91,65,$82,66,$71,67,$62,68,$51,69,$42,70,$31
          DB      97,$9E,102,$D6,103,$12,103,$52
          DB      104,$B6,105,$A6,106,$11,106,$51,107,$86,$7F,$00
ZTARG11   DB      16,$43,16,$52,16,$A2,16,$B3,17,$42,17,$53,17,$A3,17,$B2
          DB      35,$41,36,$41,36,$61,37,$61,54,$06,54,$16,55,$06,55,$16
          DB      63,$A1,63,$B2,67,$A2,67,$B1
          DB      78,$43,91,$22,91,$32,93,$A3,94,$B3,95,$C3,96,$D3,104,$9E
          DB      $7F,$00
ZTARG12   DB      8,$E3,9,$53,9,$93,12,$52,13,$62,14,$72,15,$82,17,$23,20,$23
          DB      37,$3E,37,$BE,67,$22,68,$30,69,$42,70,$50,71,$62
          DB      87,$D6,87,$E6,94,$43
*         DB      $7F,$00
ZTARG13   DB      $7F,$00
ZTARG14   DB      12,$70,17,$72,23,$32,24,$22,26,$C0,30,$C2,34,$96,36,$32,36,$40
          DB      42,$56,46,$60,46,$72,62,$3E,73,$72,74,$D6,75,$90,77,$B2,89,$30
          DB      91,$62,102,$63,102,$93,102,$C3,104,$93,105,$3E,$7F,$00
ZTARG15   DB      10,$D6,16,$93,22,$73,22,$B3,24,$93,27,$20,27,$90
          DB      50,$72,51,$82,52,$92,53,$A2
          DB      58,$60,58,$A0,59,$00,60,$20,60,$80,61,$E0,65,$7E
          DB      71,$16,72,$26 ;;;CITS
          DB      80,$80,81,$92,85,$93,88,$13,88,$96,89,$E3,92,$93
          DB      105,$4E,105,$6E
* THE REST OF ZTARG15 CAN'T BE FILLED IN UNTIL WE MAKE A VIDEOTAPE OF WHAT
* HAPPENS AFTER THE "SUICIDE ZONE".
ZTARG16   DB      $7F,$00

*
* THE FOLLOWING ROM TABLES ARE USED IN BUILDING THE MAP AND SETTING UP GROUND
* TARGETS.
*
* TSTMPX1[I] IS THE FIRST STAMP INDEX OF THE GROUND TARGET OF TYPE I.
*
TSTMPX1   DB      188                    ; A REGULAR DOME (LOGRAM)
          DB      192                    ; A REGULAR PYRAMID (BARRA)
          DB      196                    ; DETECTOR DOME (ZOLBAK)
          DB      200                    ; SMALL DEFENSE SITE (DEROTA)
          DB      224                    ; TOP ROW OF LARGE PYRAMID
          DB      240                    ; TOP ROW OF GARU DEROTA (MEGASITE)
          DB      CLRSTMP                ; CITADEL
          DB      CLRSTMP                ; FLAG
          DB      208                    ; CENTER DOME OF DOME COMPLEX
          DB      212                    ; LEFT DOME OF DOME COMPLEX
          DB      188                    ; RIGHT DOME OF DOME COMPLEX
          DB      210                    ; TOP DOME OF DOME COMPLEX
          DB      188                    ; BOTTOM DOME OF DOME COMPLEX
          DB      228                    ; BOTTOM ROW OF LARGE PYRAMID
          DB      244                    ; BOTTOM ROW OF GARU DEROTA
TSTMPX2   DB      0,0,0,0                ; TSTMPX2[I] IS THE SECOND STAMP
          DB      226                    ; INDEX OF THE GROUND TARGET I
          DB      242,CLRSTMP            ; IF THERE IS ONE, AND IS 0 IF
          DB      0,0,0,0,0,0            ; GROUND TARGET I IS ONLY 1 STAMP.
          DB      230
          DB      246
*
* STRIPC[I] POINTS TO THE FIRST BYTE OF THE CHARACTER LIST FOR THE I'TH STRIP.
* STRIPB[I] POINTS TO THE FIRST BYTE OF THE BIT STRING FOR THE I'TH STRIP.
*
STRIPCL   DB      L(ZMAPC0),L(ZMAPC1),L(ZMAPC2),L(ZMAPC3),L(ZMAPC4)
          DB      L(ZMAPC5),L(ZMAPC6),L(ZMAPC7),L(ZMAPC8)
STRIPCH   DB      H(ZMAPC0),H(ZMAPC1),H(ZMAPC2),H(ZMAPC3),H(ZMAPC4)
          DB      H(ZMAPC5),H(ZMAPC6),H(ZMAPC7),H(ZMAPC8)
STRIPBL   DB      L(ZMAPB0),L(ZMAPB1),L(ZMAPB2),L(ZMAPB3),L(ZMAPB4)
          DB      L(ZMAPB5),L(ZMAPB6),L(ZMAPB7),L(ZMAPB8)
STRIPBH   DB      H(ZMAPB0),H(ZMAPB1),H(ZMAPB2),H(ZMAPB3),H(ZMAPB4)
          DB      H(ZMAPB5),H(ZMAPB6),H(ZMAPB7),H(ZMAPB8)
*
* TARGPTRL[H] CONTAIN THE LOW AND HIGH BYTES OF THE POINTERS TO THE FIXED
* GROUND TARGET TUPLE LISTS.  THERE IS ONE POINTER FOR EACH RACK.
*
TARGPTRL  DB      L(ZTARG0),L(ZTARG1),L(ZTARG2),L(ZTARG3),L(ZTARG4),L(ZTARG5)
          DB      L(ZTARG6),L(ZTARG7),L(ZTARG8),L(ZTARG9),L(ZTARG10),L(ZTARG11)
          DB      L(ZTARG12),L(ZTARG13),L(ZTARG14),L(ZTARG15),L(ZTARG16)
TARGPTRH  DB      H(ZTARG0),H(ZTARG1),H(ZTARG2),H(ZTARG3),H(ZTARG4),H(ZTARG5)
          DB      H(ZTARG6),H(ZTARG7),H(ZTARG8),H(ZTARG9),H(ZTARG10),H(ZTARG11)
          DB      H(ZTARG12),H(ZTARG13),H(ZTARG14),H(ZTARG15),H(ZTARG16)
*
* RACKCOL[I] CONTAINS THE STARTING COLUMN IN THE MAP OF THE I'TH RACK.
*
RACKCOL   DB      36,56,9,48,20,40,0,53
          DB      32,4,47,53,24,9,40,56
*
* HERE ARE THE ACTUAL CHARACTER AND BIT LISTS USED TO REPRESENT THE MAP.
*
ZMAPC0    DB      140,120,140,120,130,2,136,140,146,120,130,2,132,130,34,2
          DB      22,2,38,22,24,56,18,174,56,18,58,128,2,24,56,142
          DB      122,128,2,10,142,122,140,120,140,120,130,28,174,120,130,28
          DB      174,28,174,28,174,174,24,24,24,24,24,22,174,22,24,44
          DB      32,22,24,22,44,14,32,22,22,180,186,184,180,182,186,184
          DB      180,182,186,184,182,180,186,184,180,180,184,186,184,176,176
          DB      184
          DB      174,186,176,180,182,184,180,186,176,184,186,182,180,180,182
          DB      174
          DB      24,62,16,60,2,122,128,10,142,122
ZMAPC1    DB      146,120,136,24,22,2,132,120,24,22,2,24,22,24,22,24
          DB      22,18,58,2,24,22,24,56,18,174,56,122,128,2,10,142
          DB      122,120,136,56,58,132,120,174,22,2,22,28,66,64,26,22
          DB      36,40,2,26,2,144,44,2,40,36,2,108,14,96,40,26
          DB      2,108,104,2,96,8,22,114,100,44,2,96,14,32,114,26
          DB      54,16,60,2,108,94,110,108,104,8,98,96,8,106,110,106
          DB      110,98,106,94,114,100,102,92,114,100,98,2,114,92,112,22
          DB      174,22,22,22,22,22,22,22,184,184,180,182,186,182,174,174
          DB      184,180,180,182,174,180,184,176,182,174,180,176,176,184,176
          DB      186
          DB      184,180,180,182,174,186,182,174,184,174,186,184,174,184,176
          DB      182
          DB      174,174,26,2,26,2,174,178,186,184,174,186,176,122
ZMAPC2    DB      120,28,36,18,58,28,40,24,22,174,2,122,128,24,22,10
          DB      142,128,62,16,180,142,122,128,28,180,176,140,120,4,84,176
          DB      140,130,28,84,80,126,28,84,80,8,140,130,84,80,8,130
          DB      42,72,8,30,54,60,96,144,108,104,96,8,108,104,96,8
          DB      104,8,100,96,114,100,96,108,104,104,8,92,100,96,108,104
          DB      96,8,114,100,96,114,100,96,114,100,114,100,22,96,174,114
          DB      100,44,96,14,114,100,32,96,22,114,100,22,114,22,22,22
          DB      44,14,40,26,2,26,2,26,2,134,26,2,134,138,132,136
          DB      132,174,180,176,178,174,176,174,176,174,134,122,128,138,10,142
          DB      122
ZMAPC3    DB      140,120,170,120,136,130,2,14,2,132,120,28,40,28,26,2
          DB      26,2,52,20,50,174,22,176,174,22,70,8,8,8,8
          DB      176,176,176,176,182,182,160,174,150,182,160,164,86,182
          DB      160,164,10,82,86,160,164,10,100,98,124,10,114,100,96,140
          DB      120,126,2,114,100,132,120,130,96,2,106,110,114,100,106,94
          DB      110,114,92,100,106,134,122,128,2,114,92,138,10,142,122,128
          DB      2,10,142,122,136,132,120,136,140,120,132,120,130,2,174,176
          DB      184,176,178,174,186,184,174,176,174,134,134,122,138,122,138,10
ZMAPC4    DB      140,120,120,170,120,130,2,14,2,48,18,58,28,40,2,24
          DB      22,28,26,2,24,56,36,2,14,134,122,32,134,138,10,34
          DB      134,138,10,174,150,10,86,158,162,82,86,174,150,8,82,86
          DB      74,158,162,82,86,150,74,158,162,82,86,150,74,158,162,160
          DB      164,150,10,158,162,82,86,150,74,158,162,82,86,150,74,158
          DB      82,86,74,78,88,82,86,74,82,102,102,112,102,112,134,98
          DB      134,138,124,10,102,112,98,134,138,102,112,124,10,176,102,112
          DB      134,138,112,134,138,10,140,182,160,164,10,140,4,182,160,164
          DB      140,120,4,172,160,164,140,76,54,16,0,138,164,140,130,30
          DB      134,122,138,10,140,4,54,0,138,10,126,36,134,138,10,14
          DB      124,10,32,24,6,136,142,128,34,124,140,120,130,12,132,120
          DB      130,2,38,22,24,56,58,52,24,174,94,92,134,122,128,2
          DB      122,138,10,142,122,128,10,126,142,128,136,126,132,120,136,174
          DB      134,138,142,132,136,2,132,136,132,120,136,140,132,120,130,28
          DB      28,174,28,174,36,28,26,14,28,26,2,28,26,2,174,2
          DB      134,122,148,122,128,40,138,10,142,122,148,122,10
ZMAPC5    DB      120,136,132,136,132,120,18,58,24,22,122,128,24,22,10,142
          DB      128,34,126,38,22,142,128,24,22,142,128,34,126,12,38,22
          DB      142,128,34,166,146,162,126,12,152,174,150,38,22,168,148,164
          DB      142,128,24,142,128,142,140,126,162,150,166,146,162,140,130,152
          DB      174,150,142,128,10,126,168,148,164,142,166,146,162,152,174,150
          DB      168,148,164,166,146,158,162,152,174,86,150,74,158,162,168,148
          DB      82,86,150,8,74,78,88,74,160,164,158,162,82,86,150,78
          DB      88,74,160,164,158,146,120,82,70,94,8,102,92,92,112,134
          DB      122,128,2,134,122,138,10,140,130,28,54,138,166,146,156,174
          DB      60,134,140,156,174,122,138,126,174,10,160,140,34,124,10,140
          DB      130,12,142,128,30,140,130,4,172,138,140,120,130,2,172,138
          DB      140,130,52,20,50,138,10,126,28,174,20,10,174,140,130,24
          DB      2,126,2,34,144,12,140,130,126,2,130,20,46,20,174,70
          DB      116,94,68,118,92,174,48,18,14,2,32,24,174,22,24,174
          DB      22,24,174,22,128,24,174,22,126,24,174,22,66,130,28,26
          DB      2,28,174,26,2,52,20,64,174,26,2,174,26,2,26,144
          DB      14,2,144,32,42,174,22,12,38,26,122,128,2,10,142,122,10
ZMAPC6    DB      140,120,146,170,120,140,130,2,174,14,2,130,2,144,2,32
          DB      24,174,22,24,174,22,34,174,12,22,24,22,128,24,44,142
          DB      128,14,10,126,140,130,130,28,40,28,26,2,36,2,14,32
          DB      24,22,128,24,22,142,128,34,10,126,38,22,142,128,24,22
          DB      38,142,128,24,22,2,24,142,128,24,22,2,162,126,2,24
          DB      22,150,142,122,128,24,142,128,164,140,136,142,10,142,138,140
          DB      120,140,120,130,2,126,144,2,142,128,120,130,108,94,94,104
          DB      102,92,92,112,2,28,54,16,16,60,2,128,2,126,130,50
          DB      174,22,28,24,174,66,20,64,174,24,174,26,24,66,20,24
          DB      174,24,20,174,94,70,116,94,92,68,118,92,18,174,14,2
          DB      32,34,174,16,12,2,30,20,20,64,174,174,26,2,12,2
          DB      28,26,2,134,122,128,30,122,138,10,142,122,148,122,10
ZMAPC7    DB      136,132,136,132,120,28,28,174,28,174,28,174,26,2,174,36
          DB      2,14,144,2,16,32,34,174,12,20,22,2,174,22,24,174
          DB      22,24,174,22,30,22,2,24,174,24,22,2,24,36,128,24
          DB      22,2,14,142,128,24,22,10,142,128,24,140,120,130,2,126
          DB      2,130,108,94,70,116,94,94,104,102,92,68,118,92,92,112
          DB      2,174,14,2,16,42,40,12,2,30,42,174,26,12,2,30
          DB      28,174,26,28,174,26,2,174,26,2,134,122,128,26,2,134
          DB      138,10,142,128,144,124,10,142,20,50,132,120,136,174,66,50
          DB      132,120,14,2,24,174,66,20,50,34,174,30,2,24,32,28
          DB      174,174,22,28,174,26,12,24,174,26,2,34,2,20,46,20
          DB      46,20,174,94,110,2,14,2,92,100,106,94,70,116,94,114
          DB      92,68,118,92,28,174,14,2,16,32,20,22,174,22,14,2
          DB      24,174,24,28,40,28,174,26,2,28,174,26,2,174,26,2
          DB      26,2,122,128,134,10,142,122,138
ZMAPC8    DB      120,146,120,28,26,2,26,2,20,174,12,2,144,2,144,2
          DB      144,2,144,2,144,30,28,174,26,174,36,2,14,20,174,94
          DB      70,116,94,92,68,118,92,174,14,2,144,128,126,130,22,174
          DB      22,24,174,22,24,174,22,24,174,24,20,174,94,70,116,94
          DB      92,68,118,92,174,14,2,144,144,22,174,22,144,24,174,22
          DB      24,174,22,144,24,174,24,144,32,134,122,134,148,138,10,122
          DB      138,10,10
ZMAPC9    DB      140,136,142,138,140,142,140,136,142,138,140,136,142,138,10,140
          DB      136,142,138
ZMAPC10   DB      140,136,142,138,136,138,10,140,136,142,138,140,136,142,138,10
          DB      140,136,142,138,140,136,142,138
ZMAPB0    DB      $FC,$3C,$00,$00,$18,$03,$C0,$3C
          DB      $00,$08,$2A,$80,$2A,$08,$AA,$0F
          DB      $D5,$FF,$FF,$FF,$FF,$FF,$E0,$AC
          DB      $00,$50,$07,$A1,$F0,$FC,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE
          DB      $7F,$4F,$E9,$FD,$FF,$3F,$A7,$F7
          DB      $9F,$CF,$F3,$9D,$37,$CF,$E9,$FD
          DB      $CF,$95,$F7,$FC,$FE,$7F,$FF,$3F
          DB      $A7,$F7,$FC,$FE,$FF,$F9,$FC,$3F
          DB      $0F,$C3,$F0,$FC,$3F,$4F,$EF,$FF
          DB      $FC,$FE,$7F,$7F,$FF,$FF,$FE,$24
          DB      $94,$24,$81,$F2,$7F,$33,$98,$4A
          DB      $D2,$C3,$50,$3E,$BF,$F7,$FF,$FF
          DB      $FD,$3F,$A0,$0B,$AB,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$FF,$C5,$54,$8A
          DB      $A8,$00
ZMAPB1    DB      $04,$F0,$01,$54,$05,$5A,$1F,$A1
          DB      $FA,$18,$A0,$15,$40,$01,$41,$51
          DB      $41,$5E,$AA,$FF,$FF,$FF,$FF,$89
          DB      $F0,$05,$51,$05,$5D,$4C,$F4,$0F
          DB      $A9,$FD,$FF,$FE,$7F,$3F,$9F,$9F
          DB      $C3,$F0,$FC,$FC,$0F,$93,$E7,$E0
          DB      $1E,$43,$CF,$EF,$FC,$3E,$07,$CF
          DB      $E4,$FB,$7E,$70,$43,$41,$38,$09
          DB      $C3,$0F,$D0,$FD,$3F,$80,$78,$21
          DB      $C2,$82,$92,$AA,$C3,$FA,$7F,$7F
          DB      $CF,$EF,$F9,$FD,$FF,$3F,$A7,$F4
          DB      $CF,$40,$F8,$1F,$1F,$FF,$FF,$E0
          DB      $FC,$09,$00,$24,$93,$E7,$F9,$CD
          DB      $65,$21,$61,$00,$18,$03,$C5,$FF
          DB      $FF,$FF,$82,$E0,$F5,$7F,$FF,$15
          DB      $57,$FF,$15,$5F,$FD,$01,$7A,$0B
          DB      $EA,$B5,$55,$7F,$FF,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$C5,$55,$40
ZMAPB2    DB      $FF,$15,$55,$55,$55,$FF,$FF,$FE
          DB      $7F,$03,$C1,$0E,$00,$1D,$00,$19
          DB      $40,$03,$00,$30,$03,$80,$18,$01
          DB      $C0,$36,$9F,$81,$E8,$1F,$87,$FF
          DB      $DF,$FF,$E1,$F8,$7F,$FF,$FF,$FF
          DB      $FE,$7F,$3F,$FF,$FF,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$9F,$CF,$FF,$FF,$FF
          DB      $E1,$FA,$7F,$FE,$1F,$87,$E1,$FA
          DB      $7F,$FF,$FE,$1F,$87,$FF,$FF,$FF
          DB      $E1,$FA,$7F,$0F,$D3,$F8,$7E,$87
          DB      $34,$E7,$0E,$69,$CE,$19,$D3,$4E
          DB      $1A,$69,$D3,$7D,$FF,$3F,$A7,$F4
          DB      $FE,$7F,$3F,$0F,$87,$C2,$02,$B0
          DB      $7E,$1F,$A7,$F7,$FC,$55,$57,$05
          DB      $51,$55,$5F,$F1,$50,$51,$5A,$A2
          DB      $AA,$AA,$AA,$BF,$FF,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$E0,$AA,$41,$54,$00
ZMAPB3    DB      $00,$52,$00,$A0,$FD,$61,$F0,$3E
          DB      $1F,$BF,$FF,$F0,$38,$AA,$91,$55
          DB      $0F,$EF,$E3,$F8,$FF,$FF,$C6,$39
          DB      $FF,$BF,$FF,$FF,$FF,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DB      $E7,$FC,$F3,$BF,$F9,$BF,$FF,$FF
          DB      $FF,$F3,$F0,$FC,$3E,$06,$40,$30
          DB      $02,$50,$30,$FD,$3C,$3F,$08,$40
          DB      $D2,$2F,$87,$C0,$13,$41,$00,$50
          DB      $00,$50,$03,$A8,$7E,$A7,$F0,$4C
          DB      $15,$04,$05,$55,$45,$31,$15,$55
          DB      $FF,$15,$40,$15,$55,$15,$55,$55
          DB      $55,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DB      $FE,$70,$50,$50,$54
ZMAPB4    DB      $F8,$22,$80,$2A,$83,$FF,$F0,$3C
          DB      $00,$C0,$A1,$0E,$B3,$05,$90,$16
          DB      $01,$C4,$3C,$87,$80,$78,$1F,$A7
          DB      $F8,$7C,$0F,$A0,$7C,$0F,$A7,$F8
          DB      $7E,$1F,$87,$E1,$F0,$3E,$81,$F0
          DB      $3E,$87,$E1,$FA,$7F,$FE,$1F,$87
          DB      $E9,$FF,$FF,$FF,$FF,$FF,$FC,$FE
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$3F,$0F,$81,$F0
          DB      $3F,$0F,$0F,$C0,$F0,$08,$80,$78
          DB      $04,$80,$40,$00,$40,$00,$00,$00
          DB      $00,$00,$18,$01,$E0,$7C,$FE,$07
          DB      $80,$70,$00,$51,$62,$AF,$FE,$1F
          DB      $A0,$4E,$A0,$8A,$AA,$8A,$AA,$A0
          DB      $82,$80,$81,$1D,$4F,$E0,$7D,$00
          DB      $F8,$1E,$43,$D8,$1F,$A0,$4E,$A0
          DB      $7D,$5F,$F7,$F3,$F0,$F8,$1E,$13
          DB      $81,$E0,$7C,$3C,$00,$C0,$50,$03
          DB      $AA,$FF,$80
ZMAPB5    DB      $15,$3A,$A8,$7E,$83,$F5,$7F,$FF
          DB      $C3,$F4,$3E,$01,$E0,$1F,$40,$F8
          DB      $07,$A0,$7D,$0F,$E1,$F0,$30,$40
          DB      $C1,$3F,$E1,$04,$02,$AA,$87,$E9
          DB      $FD,$FF,$FF,$FF,$FE,$7F,$0F,$E4
          DB      $10,$30,$40,$FC,$30,$49,$AA,$DF
          DB      $04,$F0,$4F,$FF,$04,$F4,$10,$E0
          DB      $87,$E0,$60,$81,$AA,$1F,$87,$E0
          DB      $7E,$1F,$03,$E1,$F8,$1F,$80,$AA
          DB      $08,$AA,$02,$AA,$00,$82,$00,$00
          DB      $02,$00,$02,$C0,$3C,$7E,$48,$0A
          DB      $13,$C2,$78,$00,$08,$00,$01,$00
          DB      $14,$33,$B0,$31,$82,$7E,$1C,$3F
          DB      $0F,$FF,$CF,$EF,$FF,$FF,$FF,$F1
          DB      $52,$22,$AD,$40,$55,$40,$55,$40
          DB      $55,$60,$AA,$CF,$C0,$FA,$07,$D0
          DB      $39,$40,$CD,$03,$ED,$0F,$D7,$90
          DB      $E0,$10,$00,$C5,$0E,$01,$E7,$FC
          DB      $FC,$15,$49,$F5,$FF,$3E,$00,$AA
          DB      $80,$AA,$8A,$AA,$80
ZMAPB6    DB      $82,$02,$02,$02,$1F,$BF,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$FF,$3F,$9F,$FF
          DB      $FF,$9F,$81,$F4,$0F,$A1,$F9,$3F
          DB      $87,$E0,$7C,$0F,$87,$FF,$E1,$F8
          DB      $1F,$03,$E1,$F9,$FC,$FE,$1F,$81
          DB      $F0,$3E,$01,$F0,$09,$A0,$01,$A0
          DB      $01,$A0,$07,$00,$F5,$03,$0A,$18
          DB      $6F,$5F,$FF,$FF,$E0,$B0,$41,$60
          DB      $3E,$1F,$10,$15,$14,$05,$15,$05
          DB      $55,$01,$15,$05,$05,$79,$FF,$FC
          DB      $FE,$FF,$FF,$FF,$FF,$FF,$3F,$87
          DB      $C0,$05,$04,$15,$4A,$A4,$3D,$07
          DB      $EB,$FF,$FF,$FF,$FE,$7F,$7F,$C5
          DB      $55,$45,$55,$45,$01,$45,$01,$45
          DB      $01,$55,$9F,$80,$BC,$8B,$FF,$FF
          DB      $FF,$C8,$A2,$15,$45,$02,$2A,$FF
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$F3,$FB
          DB      $FC,$FE,$40,$98,$00,$20,$AA,$A8
ZMAPB7    DB      $3F,$87,$E8,$2A,$B5,$55,$7F,$9F
          DB      $87,$C3,$E0,$1E,$07,$E7,$FF,$FF
          DB      $FF,$F9,$FC,$FF,$FF,$FF,$FF,$FF
          DB      $FF,$FF,$8A,$FA,$AF,$FF,$FC,$FC
          DB      $3F,$3F,$FF,$FF,$FF,$FF,$FF,$E3
          DB      $FA,$9F,$10,$FC,$0F,$A0,$1C,$01
          DB      $E0,$13,$00,$98,$07,$80,$78,$07
          DB      $83,$F3,$FB,$FF,$FE,$08,$08,$00
          DB      $08,$80,$0A,$BF,$15,$F5,$49,$F2
          DB      $7F,$FF,$FF,$FC,$FC,$0F,$93,$E7
          DB      $E0,$78,$07,$81,$02,$10,$01,$10
          DB      $A0,$80,$51,$40,$10,$04,$0D,$41
          DB      $7C,$81,$86,$80,$06,$08,$74,$9E
          DB      $11,$04,$6A,$A8,$84,$10,$00,$14
          DB      $10,$1A,$80,$22,$BE,$AB,$FF,$FF
          DB      $FF,$31,$5A,$45,$74,$56,$01,$FA
          DB      $7F,$7F,$FF,$F2,$78,$07,$00,$F0
          DB      $3E,$1F,$BF,$FF,$FF,$C5,$52,$0A
          DB      $A0,$00
ZMAPB8    DB      $FF,$FF,$01,$55,$01,$55,$0F,$C5
          DB      $55,$45,$55,$55,$52,$7F,$FF,$FF
          DB      $FF,$FF,$FF,$3F,$9F,$FF,$CF,$E7
          DB      $F3,$F9,$FC,$FE,$7F,$3F,$FF,$FE
          DB      $7E,$07,$C0,$FC,$FF,$FF,$FF,$FF
          DB      $C5,$7C,$57,$D5,$7F,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DB      $FF,$FC,$54,$04,$54,$05,$54,$03
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FC,$FE
          DB      $7F,$3F,$BF,$CF,$E1,$F8,$1F,$40
          DB      $FA,$1F,$A7,$8A,$F8,$AF,$AA,$F8
          DB      $A8,$08,$A8,$0A,$A8,$07,$FF,$FF
          DB      $FF,$FF,$FF,$F7,$F8,$7E,$87,$C0
          DB      $3D,$40,$E5,$0E,$E9,$CE,$F7,$FF
          DB      $FF,$FF,$FF,$E0,$70,$40,$50,$58
          DB      $AF,$80
ZMAPB9    DB      $FF,$FF,$E1,$F8,$7E,$B9,$FC,$FE
          DB      $FF,$F8,$7E,$1F,$AF,$FE,$1F,$87
          DB      $E3,$FF,$C3,$F0,$FD,$60
ZMAPB10   DB      $FF,$E1,$F8,$7E,$BC,$FE,$7F,$3F
          DB      $FF,$FC,$3F,$0F,$D6,$1F,$87,$E3
          DB      $E1,$F8,$7E,$B0,$FC,$3E
*
* HERE ARE THE LISTS OF FIXED GROUND TARGET TUPLES, ONE PER RACK.  EACH MUST
* START ON AN EVEN BOUNDARY.  EACH LIST MUST BE TERMINATED BY THE BOGUS
* "TARGET" $7F,$00.
*
BOTMAPV
          END
