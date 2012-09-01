*         SPHINX--SSCROLL.S

*COARSE VERTICAL PRECEDES COARSE HORIZONTAL.  CHAR MAP GENERATION IS STILL DONE
*ON THE SAME FRAME AS COARSE VERTICAL


;          ZERODEF

;          RSEG    CODED

ZSTHPOS    EQU     $5A                   ;STARTING X POS OF CHAR MAP
ZPALWID    EQU     $4B                    ;CHARACTER MAP LENGTH 21 BYTES

* SUPER DUPER SCROLLING ROUTINE

SCROLL:
          LDA     SCROLLS
          BEQ     SCREND
          STA     TEMP8
          DEC     TEMP8
SCROLLP:
          JSR     VSCROLL                ;DO IT
          JSR     HSCROLL                ;DOIT
NOSCROLL:
          INC     SCRLLCNT
SCRNXT:   DEC     TEMP8
          BPL     SCROLLP
SCREND:   RTS


*         VSCROLL


VSCROLL:

          INC     ZONEOFF                ;INC ZONEOFF AND CHECK
          BNE     NOT0
          LDA     #$4F                   ;RESTORE TOP DUMMY ZONES
          STA     DLLIST                 ;HIGH AND LOW BYTES SHOULD BE SAME
          LDA     #$48
          STA     DLLIST+3

          LDA     #$C0                   ;ONE LINE OF ZONE 0
          STA     DLLIST+6               ;STORE IT
          LDA     #DL0/256
          STA     DLLIST+7
          LDA     #DL0&$FF
          STA     DLLIST+8

          LDA     #$4F                   ;FULL ZONE 1 WITH NO DLI
          STA     DLLIST+9

NOT0:
          LDA     ZONEOFF                ;CHECK FOR COARSE SCROLL
          CMP     #15
          BEQ     COARSEV

          ORA     #$C0                   ;ZONEOFF IS HEIGHT OF ZONE0
          STA     DLLIST+6               ;OFFSET

          LDA     ZONEOFF                ;CALCULATE ZONE 11 STUFF FROM ZONEOFF
          CLC
          ADC     #(CHARS+$100)/256
          STA     D11CBASE               ;CHARBASE OF ZONE 11
          LDA     #14
          SEC
          SBC     ZONEOFF
          ORA     #$C0
          STA     DLLIST+39
          CMP     #$C0
          BNE     MORETH1
                                         ;HERE FOR ZONE HEIGHT OF 1
          LDA     #DLZ11A&$FF             ;SPECIAL DLI FOR ZONE HEIGHT OF 1
          STA     DLZDEST
          LDA     #DLZ11A/256
          STA     DLZDEST+1
          LDA     DLLIST+42
          AND     #$7F
          STA     DLLIST+42
          RTS

MORETH1:
          LDA     #DLIZ11&$FF          ;REGULAR DLI FOR ZONE 11
          STA     DLZDEST
          LDA     #DLIZ11/256
          STA     DLZDEST+1

          LDA     DLLIST+42
          ORA     #$80
          STA     DLLIST+42

          RTS

COARSEV:  LDY     #$FF                   ;COARSE V SCROLL
          STY     ZONEOFF


          INY
          STY     KPTR0
          STY     KPTR1

          LDA     #$47                   ;CHANGE TOP ZONE TO EIGHT OF BLANK
          STA     DLLIST
          LDA     #$48                   ;ANOTHER ZONE OF 9 BLANK LINES
          STA     DLLIST+3

          LDA     #$47                   ;DLI TO SET UP PROPER COLOR
          STA     DLLIST+6               ;MAKE THIRD ZONE 8 OF BLANK
          LDA     #NULHDR/256             ;SET UP ITS BLANK HEADER
          STA     DLLIST+7
          LDA     #NULHDR&$FF
          STA     DLLIST+8

          LDA     #$CF                   ;ZONE 1 GETS 16 LINES THIS TIME
          STA     DLLIST+9

          LDX     #11                    ;SHUFFLE CHAR MAPS
VSCRLP:   LDA     HIBYE,X
          STA     KPTR1+1
          LDA     HIBYE-1,X
          STA     KPTR0+1

          LDY     #4
          LDA     (KPTR0),Y              ;HPOS
          STA     (KPTR1),Y
          DEY
          DEY                            ;SKIP PALWIDTH
          LDA     (KPTR0),Y              ;HIGH BYTE CHAR MAP
          STA     (KPTR1),Y
          DEY
          DEY                            ;SKIP W1
          LDA     (KPTR0),Y              ;LOW BYTE CHAR MAP
          STA     (KPTR1),Y
          DEX
          BPL     VSCRLP

          LDX     BAND                   ;GET NEXT BAND
          DEX
          BPL     NEXBAND
          LDY     NEWBLK                 ;GET NEW BLOCK IF NEEDED
          STY     BLOCK
          INC     NBFLAG
          LDX     BANDTBL,Y              ;6 IS MAXIMUM BAND NUMBER
NEXBAND:  STX     BAND

          LDY     BLOCK                  ;GET NEW BLOCK NUMBER

          LDA     MSKLFTLO,Y             ;STUFF POINTERS TO LOAD NEW MASK
          STA     KTEMP0
          LDA     MSKLFTHI,Y
          STA     KTEMP1                 ;(KTEMP0) POINTS TO MASKL TABLE FOR BLK
          LDA     MSKMIDLO,Y
          STA     KPTR0                  ;(KPTR0) POINTS TO MASKM TABLE FOR BLK
          LDA     MSKMIDHI,Y
          STA     KPTR0+1
          LDA     MSKRITLO,Y
          STA     KTEMP2                 ;(KTEMP2) POINTS TO MASKR TABLE FOR BLK
          LDA     MSKRITHI,Y
          STA     KTEMP3

          LDA     BLKTBLLO,Y             ;USE BLOCK TABLE AND TIMES33 TABLE TO
          LDX     STUFFDEX               ;GET POINTER TO CURRENT BAND AND MOVE
          STA     PTRTBLLO,X             ;POINTER TABLES USED FOR LOOKAHEAD
          LDA     BLKTBLHI,Y
          STA     PTRTBLHI,X

          LDY     BAND

          LDA     TIMES33,Y
          CLC
          ADC     PTRTBLLO,X             ;add to lo byte
          STA     PTRTBLLO,X

          LDA     PTRTBLHI,X
          ADC     #0
          STA     PTRTBLHI,X

          LDA     (KTEMP0),Y             ;USE POINTERS TO STUFF MASK TABLE VALUE
          STA     LEFTMASK,X             ;INTO LOCATIONS CORRESPONDING TO CHAR
          LDA     (KPTR0),Y
          STA     MIDMASK,X
          LDA     (KTEMP2),Y             ;MAPS
          STA     RIGTMASK,X

          INX
          TXA
          AND     #$03
          STA     STUFFDEX
                                         ;THIS IS ADDRESS OF CHAR MAP IN ROM
                                         ;NOW WE HAVE TO COPY INTO RAM

          LDX     BUFDEX
          LDA     BUFFERLO,X
          STA     KTEMP2

          LDA     BUFFERHI,X
          STA     KTEMP3

          DEX
          BPL     OLDBUF
          LDX     #11

OLDBUF:   STX     BUFDEX

          LDY     LOADFDEX               ;COPY POINTER OF CHAR MAP FROM POINTER
          LDA     PTRTBLLO,Y             ;BUFFER TABLE INTO FROM POINTER
          STA     KTEMP0
          LDA     PTRTBLHI,Y
          STA     KTEMP1
          INY
          TYA
          AND     #$03
          STA     LOADFDEX

          LDY     #32
COPYLOP:  LDA     (KTEMP0),Y             ;THIS COPIES CHAR MAP INTO RAM
          STA     (KTEMP2),Y
          DEY
          BPL     COPYLOP

          LDA     #ZSTHPOS               ;HEADER FOR NEW CHAR MAP
          STA     DL0+4
          LDA     #ZPALWID               ;PALLETTE WIDTH
          STA     DL0+3
          LDA     KTEMP3                 ;HIGH BYTE OF CHAR MAP
          STA     DL0+2
          LDA     #$60                   ;W1
          STA     DL0+1
          LDA     KTEMP2                 ;LOW BYTE OF CHAR MAP
          STA     DL0

          LDA     #CHARS/256
          STA     D11CBASE               ;CBASE OF ZONE 11
          LDA     #$CF
          STA     DLLIST+39

          CMP     #$C0
          BNE     MORETH1A
                                         ;HERE FOR ZONE HEIGHT OF 1
          LDA     #DLZ11A&$FF             ;ISN'T THIS THE SAME AS ABOVE
          STA     DLZDEST
          LDA     #DLZ11A/256
          STA     DLZDEST+1
          LDA     DLLIST+42
          AND     #$7F
          STA     DLLIST+42
          RTS

MORETH1A:
          LDA     #DLIZ11&$FF             ;AND ISN'T THIS SIMILAR TO ABOVE
          STA     DLZDEST
          LDA     #DLIZ11/256
          STA     DLZDEST+1

          LDA     DLLIST+42
          ORA     #$80
          STA     DLLIST+42

          RTS

TIMES33:  .dc.b      0*33,1*33,2*33,3*33,4*33,5*33,6*33

BUFFERLO: .dc.b      ZBUFF0&$FF,ZBUFF1&$FF,ZBUFF2&$FF
	  .dc.b	     ZBUFF3&$FF,ZBUFF4&$FF,ZBUFF5&$FF
          .dc.b      ZBUFF6&$FF,ZBUFF7&$FF,ZBUFF8&$FF
	  .dc.b	     ZBUFF9&$FF,ZBUFFA&$FF,ZBUFFB&$FF

BUFFERHI: .dc.b      ZBUFF0/256,ZBUFF1/256,ZBUFF2/256
	  .dc.b	     ZBUFF3/256,ZBUFF4/256,ZBUFF5/256
          .dc.b      ZBUFF6/256,ZBUFF7/256,ZBUFF8/256
	  .dc.b	     ZBUFF9/256,ZBUFFA/256,ZBUFFB/256

HIBYE:    .dc.b      DL0/256,DL1/256,DL2/256,DL3/256
	  .dc.b	     DL4/256,DL5/256,DL6/256,DL7/256
          .dc.b      DL8/256,DL9/256,DL10/256,DL11/256

BANDTBL:  .dc.b      6,6,3,2,3,2,3,2,6,3,2,3,2,6

*         HSCROLL
HSCROLL:

          DEC     DL0+4                  ;DECREMENT HORIZONTAL POSITIONS
          DEC     DL1+4
          DEC     DL2+4
          DEC     DL3+4
          DEC     DL4+4
          DEC     DL5+4

          INC     JERKOFF                ;INCREMENT HOR SCROLL COUNTER
          LDA     JERKOFF
          CMP     #7
          BEQ     COARSEH

          DEC     DL6+4                  ;IF APPROPRIATE, DEC REST OF X POS'S
          DEC     DL7+4
          DEC     DL8+4
          DEC     DL9+4
          DEC     DL10+4
          DEC     DL11+4

          RTS

COARSEH:  LDA     #$FF                   ;COARSE H SCROLL
          STA     JERKOFF
          LDA     #0                     ;ZERO OUT H POS'S
          STA     DL6+4
          STA     DL7+4
          STA     DL8+4
          STA     DL9+4
          STA     DL10+4
          STA     DL11+4

          INC     DL6                    ;INC START OF CHAR MAP
          INC     DL7
          INC     DL8
          INC     DL9
          INC     DL10
          INC     DL11

          RTS


BLKTBLLO: .dc.b      BLOCK0&$FF,BLOCK1&$FF,BLOCK2&$FF
	  .dc.b	     BLOCK3&$FF,BLOCK4&$FF,BLOCK5&$FF
          .dc.b      BLOCK6&$FF,BLOCK7&$FF,BLOCK8&$FF
	  .dc.b	     BLOCK9&$FF,BLOCKA&$FF,BLOCKB&$FF
          .dc.b      BLOCKC&$FF,BLOCKD&$FF

BLKTBLHI: .dc.b      BLOCK0/256,BLOCK1/256,BLOCK2/256
	  .dc.b      BLOCK3/256,BLOCK4/256,BLOCK5/256
          .dc.b      BLOCK6/256,BLOCK7/256,BLOCK8/256
	  .dc.b	     BLOCK9/256,BLOCKA/256,BLOCKB/256
          .dc.b      BLOCKC/256,BLOCKD/256

MSKLFTLO: .dc.b      MASK0L&$FF,MASK1L&$FF,MASK2L&$FF
	  .dc.b	     MASK3L&$FF,MASK4L&$FF,MASK5L&$FF
          .dc.b      MASK6L&$FF,MASK7L&$FF,MASK8L&$FF
	  .dc.b	     MASK9L&$FF,MASKAL&$FF,MASKBL&$FF
          .dc.b      MASKCL&$FF,MASKDL&$FF

MSKLFTHI: .dc.b      MASK0L/256,MASK1L/256,MASK2L/256
	  .dc.b      MASK3L/256,MASK4L/256,MASK5L/256
          .dc.b      MASK6L/256,MASK7L/256,MASK8L/256
	  .dc.b      MASK9L/256,MASKAL/256,MASKBL/256
          .dc.b      MASKCL/256,MASKDL/256

MSKMIDLO: .dc.b      MASK0M&$FF,MASK1M&$FF,MASK2M&$FF,MASK3M&$FF
	  .dc.b	     MASK4M&$FF,MASK5M&$FF
          .dc.b      MASK6M&$FF,MASK7M&$FF,MASK8M&$FF,MASK9M&$FF
	  .dc.b	     MASKAM&$FF,MASKBM&$FF
          .dc.b      MASKCM&$FF,MASKDM&$FF

MSKMIDHI: .dc.b      MASK0M/256,MASK1M/256,MASK2M/256
	  .dc.b      MASK3M/256,MASK4M/256,MASK5M/256
          .dc.b      MASK6M/256,MASK7M/256,MASK8M/256
	  .dc.b      MASK9M/256,MASKAM/256,MASKBM/256
          .dc.b      MASKCM/256,MASKDM/256

MSKRITLO: .dc.b      MASK0R&$FF,MASK1R&$FF,MASK2R&$FF
	  .dc.b	     MASK3R&$FF,MASK4R&$FF,MASK5R&$FF
          .dc.b      MASK6R&$FF,MASK7R&$FF,MASK8R&$FF
	  .dc.b	     MASK9R&$FF,MASKAR&$FF,MASKBR&$FF
          .dc.b      MASKCR&$FF,MASKDR&$FF

MSKRITHI: .dc.b      MASK0R/256,MASK1R/256,MASK2R/256
	  .dc.b      MASK3R/256,MASK4R/256,MASK5R/256
          .dc.b      MASK6R/256,MASK7R/256,MASK8R/256
	  .dc.b      MASK9R/256,MASKAR/256,MASKBR/256
          .dc.b      MASKCR/256,MASKDR/256


BLOCK0:
Z0BAND0:  .dc.b      54,56,58,24,26,24,24,24,28,24,36,24,24,24,112,212,184
          .dc.b      184,184,184,184,184,184,184,194,150,82,24,40,42,24,24,28
Z0BAND1:  .dc.b      54,56,58,24,24,24,24,24,40,42,40,38,38,24,84,136,212,184
          .dc.b      184,184,184,184,184,184,184,184,196,24,24,24,26,38,24
Z0BAND2:  .dc.b      54,56,58,24,24,26,24,24,40,24,24,24,24,28,24,24,208,184,184
          .dc.b      184,184,184,184,184,184,184,184,184,110,24,40,24,24
Z0BAND3:  .dc.b      54,56,58,24,40,24,24,84,136,190,76,24,24,24,24,24,24,24,74,114
          .dc.b      176,188,184,184,184,184,184,184,184,184,110,24,24
Z0BAND4:  .dc.b      54,56,58,24,24,24,24,28,96,198,150,82,24,24,26,60,62,64,24,24
          .dc.b      24,24,24,74,114,176,188,184,184,184,184,184,110
Z0BAND5:  .dc.b      54,56,58,24,24,40,42,38,24,24,24,40,24,24,30,24,24,24,66,66
          .dc.b      62,64,24,26,24,24,24,24,208,184,184,184,184
Z0BAND6:  .dc.b      54,56,58,24,24,24,24,24,40,42,24,24,24,24,36,24,24,24,24,24
          .dc.b      24,24,66,70,24,24,24,42,40,112,212,184,184

MASK0L:   .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FE
          .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF

MASK0M:   .dc.b      $FC
          .dc.b      $FC
          .dc.b      $FF
          .dc.b      $1F
          .dc.b      $0F
          .dc.b      $FF
          .dc.b      $FF

MASK0R:   .dc.b      $00,$00,$00,$C0,$FF,$FF,$FF


BLOCK1:
Z1BAND0:  .dc.b      54,56,58,30,24,28,24,26,24,24,42,90,92,142,144,212,184
          .dc.b      184,184,184,184,184,184,194,146,148,82,28,24,42,40,38,24
Z1BAND1:  .dc.b      54,56,58,24,38,90,92,80,80,142,144,186,186,210,204,188
          .dc.b      184,184,184,184,184,184,184,194,150,82,24,36,24,40,40,42,38
Z1BAND2:  .dc.b      54,56,58,24,28,42,130,212,184,184,184,184,184,194,150,82
          .dc.b      24,118,188,184,184,194,150,128,188,196,24,26,38,40,24,28,24
Z1BAND3:  .dc.b      54,56,58,24,28,24,24,112,212,184,184,184,194,150,86,88
          .dc.b      24,26,42,112,212,194,150,82,42,24,208,110,28,24,24,26,30
Z1BAND4:  .dc.b      54,56,58,24,24,42,24,26,38,208,184,184,194,150,82,24
          .dc.b      26,42,90,92,136,210,150,82,30,24,26,24,208,110,34,24,24
Z1BAND5:  .dc.b      54,56,58,24,24,30,24,24,24,26,24,208,184,184,116,24
          .dc.b      42,90,92,136,212,184,184,196,30,24,24,24,24,26,118,110,42
Z1BAND6:  .dc.b      54,56,58,24,26,42,24,28,42,40,24,24,28,208,184,184
          .dc.b      206,186,186,212,184,184,184,184,194,120,24,26,24,26,24,28,42

MASK1L:   .dc.b      $FF
          .dc.b      $F8
          .dc.b      $FC
          .dc.b      $FE
          .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF

MASK1M:   .dc.b      $E0
          .dc.b      $00
          .dc.b      $00
          .dc.b      $00
          .dc.b      $81
          .dc.b      $E1
          .dc.b      $F8

MASK1R:   .dc.b      $00
          .dc.b      $00
          .dc.b      $80
          .dc.b      $E0
          .dc.b      $C0
          .dc.b      $80
          .dc.b      $00


BLOCK2:
Z2BAND0:  .dc.b      54,56,58,24,26,24,24,24,24,90,92,80,80,142,144,184,184
          .dc.b      184,184,184,184,184,184,184,184,150,82,28,24,42,28,26,24
Z2BAND1:  .dc.b      54,56,58,24,90,92,80,80,142,144,212,184,184,184,184,184,184
          .dc.b      184,184,184,184,184,184,184,194,150,82,24,36,24,26,24,40
Z2BAND2:  .dc.b      54,56,58,28,102,104,160,114,176,204,146,148,138,174,184,184
          .dc.b      184,184,184,184,184,184,184,184,194,150,82,24,40,42,26,24,34
Z2BAND3:  .dc.b      54,56,58,24,98,100,88,24,40,42,24,34,24,84,136,212,184
          .dc.b      184,184,184,184,184,184,184,194,150,82,24,28,42,40,42,24

MASK2L:   .dc.b      $FF
          .dc.b      $F0
          .dc.b      $F0
          .dc.b      $F1

MASK2M:   .dc.b      $80
          .dc.b      $00
          .dc.b      $00
          .dc.b      $F8

MASK2R:   .dc.b      $00,$00,$00,$00


BLOCK3:
Z3BAND0:  .dc.b      54,56,58,24,26,24,66,68,62,64,24,24,84,80,140,184
          .dc.b      184,184,184,184,184,184,194,204,150,138,82,24,26,24,24,24,26
Z3BAND1:  .dc.b      54,56,58,24,26,24,28,24,40,24,66,70,24,112,212,184
          .dc.b      184,184,184,184,184,184,184,194,122,24,34,24,24,24,24,28,24
Z3BAND2:  .dc.b      54,56,58,24,28,24,24,24,24,42,38,40,24,84,136,212
          .dc.b      184,184,184,184,184,184,184,184,194,122,24,24,24,26,24,24,24

MASK3L:   .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF

MASK3M:   .dc.b      $F0
          .dc.b      $F8
          .dc.b      $F8

MASK3R:   .dc.b      $00,$00,$00


BLOCK4:
Z4BAND0:  .dc.b      54,56,58,24,24,24,40,24,24,90,92,80,80,142,144,184
          .dc.b      184,184,184,194,150,174,184,184,184,150,82,24,26,42,40,42,24
Z4BAND1:  .dc.b      54,56,58,24,24,24,24,24,24,112,186,212,184,184,184,184
          .dc.b      184,184,194,150,86,88,112,212,184,194,122,24,26,24,24,24,40
Z4BAND2:  .dc.b      54,56,58,24,24,24,26,24,24,24,24,208,184,184,184,184
          .dc.b      184,184,184,184,116,42,36,112,212,184,194,122,24,60,62,64,24
Z4BAND3:  .dc.b      54,56,58,60,62,64,26,30,24,26,28,24,24,208,184,184
          .dc.b      184,184,184,184,184,184,206,186,190,198,146,148,82,24,24,24,66

MASK4L:   .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF

MASK4M:   .dc.b      $80
          .dc.b      $80
          .dc.b      $E0
          .dc.b      $F8

MASK4R:   .dc.b      $00,$00,$06,$00


BLOCK5:
Z5BAND0:  .dc.b      54,56,58,24,26,40,42,24,24,26,24,28,84,80,140,212
          .dc.b      184,184,184,184,184,184,184,184,184,194,122,24,26,24,30,24,24
Z5BAND1:  .dc.b      54,56,58,24,24,24,24,24,38,30,24,24,26,84,202,184
          .dc.b      184,184,184,184,184,184,184,194,146,148,86,88,30,24,24,24,24
Z5BAND2:  .dc.b      54,56,58,24,26,24,34,24,24,24,40,24,24,84,140,212
          .dc.b      184,184,184,184,184,184,184,184,194,122,24,26,24,38,40,42,40

MASK5L:   .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF

MASK5M:   .dc.b      $F0
          .dc.b      $F8
          .dc.b      $F8

MASK5R:   .dc.b      $00,$00,$00


BLOCK6:
Z6BAND0:  .dc.b      54,56,58,24,28,40,38,24,24,30,24,26,30,36,24,24
          .dc.b      26,24,24,24,32,28,24,40,24,24,24,24,90,92,136,212,184
Z6BAND1:  .dc.b      54,56,24,60,62,64,24,26,24,40,38,28,24,24,24,90
          .dc.b      92,80,80,80,80,80,80,142,144,186,186,186,186,186,212,184,184
Z6BAND2:  .dc.b      54,56,58,24,42,26,66,68,68,62,64,24,40,90,92,142
          .dc.b      144,212,184,184,184,184,184,184,184,184,184,184,184,184,194
          .dc.b      146,148
Z6BAND3:  .dc.b      54,56,58,24,42,40,24,26,28,66,72,72,70,84,136,212
          .dc.b      184,184,184,184,184,184,184,184,194,146,148,138,138,138,138,86
          .dc.b      88

MASK6L:   .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF

MASK6M:   .dc.b      $FF
          .dc.b      $FE
          .dc.b      $F8
          .dc.b      $F8

MASK6R:   .dc.b      $FF,$00,$00,$00


BLOCK7:
Z7BAND0:  .dc.b      54,56,58,24,26,40,24,26,24,28,84,80,80,124,126,24
          .dc.b      26,24,24,36,24,26,24,40,42,24,90,92,80,142,144,212,184
Z7BAND1:  .dc.b      54,56,24,44,46,40,24,24,38,24,26,40,208,184,184,184
          .dc.b      206,180,182,124,126,24,24,90,92,80,142,144,212,194,146,148
          .dc.b      138
Z7BAND2:  .dc.b      54,56,58,24,24,48,50,52,24,24,24,40,24,112,212,184
          .dc.b      184,184,184,184,184,184,206,186,190,198,146,148,138,138,86,88
          .dc.b      24

MASK7L:   .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF

MASK7M:   .dc.b      $C1
          .dc.b      $F0
          .dc.b      $F8

MASK7R:   .dc.b      $FF,$06,$00


BLOCK8:
Z8BAND0:  .dc.b      54,56,58,24,24,26,24,28,24,30,24,24,30,24,26,24
          .dc.b      24,24,26,24,40,24,24,26,24,24,28,24,84,142,144,212,184
Z8BAND1:  .dc.b      54,56,58,84,136,186,186,190,76,24,24,24,26,24,24,28,24
          .dc.b      24,24,24,24,28,24,26,24,84,142,144,186,186,212,184,184
Z8BAND2:  .dc.b      54,56,84,142,144,212,194,150,86,88,24,26,24,30,24,24,24
          .dc.b      24,24,24,24,42,24,24,24,24,130,212,184,184,184,184,184
Z8BAND3:  .dc.b      54,56,58,96,198,204,146,148,82,24,42,24,24,24,24,24,60
          .dc.b      62,64,24,24,32,24,24,24,38,24,26,208,184,184,184,184
Z8BAND4:  .dc.b      54,56,58,24,24,24,34,24,24,38,24,24,24,40,24,24,40
          .dc.b      24,24,66,68,62,64,24,24,24,26,24,24,84,202,184,184
Z8BAND5:  .dc.b      54,56,58,24,24,26,24,24,26,40,24,24,32,24,24,24,38
          .dc.b      24,24,34,24,24,24,66,68,62,64,24,24,24,130,212,184
Z8BAND6:  .dc.b      54,56,58,24,24,36,24,24,40,24,24,30,24,24,24,24,24
          .dc.b      24,24,26,24,24,24,26,24,24,24,66,70,24,24,84,202

MASK8L:   .dc.b      $FF
          .dc.b      $E0
          .dc.b      $C0
          .dc.b      $E0
          .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF

MASK8M:   .dc.b      $FF
          .dc.b      $7F
          .dc.b      $3F
          .dc.b      $7F
          .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF

MASK8R:   .dc.b      $FF,$FF,$FF,$FF,$FF,$FF,$FF


BLOCK9:
Z9BAND0:  .dc.b      54,56,58,40,24,24,24,26,24,24,24,26,24,24,40,24
          .dc.b      24,24,26,24,24,26,24,24,24,24,24,30,24,84,136,212,184
Z9BAND1:  .dc.b      54,56,58,26,24,24,24,36,24,24,24,28,24,24,36,24,24,24,42
          .dc.b      24,24,24,24,24,28,24,26,24,28,84,136,212,184
Z9BAND2:  .dc.b      54,56,58,24,24,24,24,24,42,24,24,24,24,26,24,24,24,24,36,24
          .dc.b      24,26,24,24,24,24,24,24,24,84,136,212,184
Z9BAND3:  .dc.b      54,56,58,24,26,24,24,28,24,24,24,40,24,24,24,24,26,24,24,24
          .dc.b      24,24,26,28,24,24,24,24,30,94,152,212,184

MASK9L:   .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF

MASK9M:   .dc.b      $FF,$FF,$FF,$FF

MASK9R:   .dc.b      $FF,$FF,$FF,$FF


BLOCKA:
ZABAND0:  .dc.b      54,56,58,24,24,24,26,84,142,144,186,134,60,62,64,24,40,84
          .dc.b      136,190,76,24,26,24,24,26,24,24,24,24,130,212,184
ZABAND1:  .dc.b      54,56,58,24,44,46,24,24,130,212,194,204,150,82,24,66,68,62
          .dc.b      64,74,138,82,24,26,24,24,24,24,24,84,142,144,212
ZABAND2:  .dc.b      54,56,58,24,24,24,48,50,52,24,74,86,88,24,24,26,24,28
          .dc.b      30,66,70,24,24,26,24,24,24,28,24,84,136,212,184

MASKAL:   .dc.b      $FE
          .dc.b      $FF
          .dc.b      $FF

MASKAM:   .dc.b      $0F,$03,$C7

MASKAR:   .dc.b      $87,$E3,$FF


BLOCKB:
ZBBAND0:  .dc.b      54,56,58,26,24,24,28,24,24,38,24,24,24,26,40,30,24,24,24,24
          .dc.b      24,24,24,36,24,30,24,24,90,92,136,212,184
ZBBAND1:  .dc.b      54,56,58,24,26,24,24,24,38,24,24,90,92,162,200,200,168,78,24
          .dc.b      24,30,24,24,30,90,92,142,144,186,186,212,184,184
ZBBAND2:  .dc.b      54,56,58,24,24,26,24,24,24,26,24,102,104,160,86,88,24,24,74
          .dc.b      170,166,24,24,84,142,144,198,204,146,148,174,184,184
ZBBAND3:  .dc.b      54,56,58,40,24,24,38,24,24,24,24,98,100,88,24,24,28,24,36
          .dc.b      24,24,24,164,172,106,108,86,88,24,84,142,144,212

MASKBL:   .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF

MASKBM:   .dc.b      $FF,$E0,$E0,$E3

MASKBR:   .dc.b      $FF,$3F,$C6,$FC


BLOCKC:
ZCBAND0:  .dc.b      54,56,58,24,24,24,24,26,24,40,24,28,24,34,24,24,24,24,24
          .dc.b      30,26,24,130,132,78,24,40,42,24,84,136,212,184
ZCBAND1:  .dc.b      54,56,58,24,24,28,24,26,24,24,40,24,24,24,24,24,40,24,24
          .dc.b      40,26,24,80,154,198,204,158,24,26,94,152,212,184
ZCBAND2:  .dc.b      54,56,58,24,24,26,24,24,24,24,30,24,24,24,24,26,24,42,24
          .dc.b      42,24,24,24,24,74,82,24,42,38,84,136,212,184

MASKCL:   .dc.b      $FF
          .dc.b      $FF
          .dc.b      $FF

MASKCM:   .dc.b      $FF,$FF,$FF

MASKCR:   .dc.b      $FC,$FC,$FF


BLOCKD:
ZDBAND0:  .dc.b      54,56,58,24,24,24,40,24,24,26,24,28,24,24,28,24,26,24,24
          .dc.b      24,24,90,92,78,24,26,24,46,92,142,144,212,184
ZDBAND1:  .dc.b      54,56,58,24,26,24,24,24,24,42,42,24,24,30,24,26,24,24,24
          .dc.b      90,92,142,144,212,184,206,186,186,190,146,148,114,112
ZDBAND2:  .dc.b      54,56,58,90,92,142,144,186,186,190,76,24,40,38,84,80,80,80
          .dc.b      80,142,144,212,184,184,184,194,146,148,138,138,82,26,24
ZDBAND3:  .dc.b      54,56,58,24,130,212,184,194,146,148,86,88,24,26,24,130,212
          .dc.b      184,184,184,184,184,184,184,184,194,150,82,24,26,24,28,24
ZDBAND4:  .dc.b      54,56,58,24,24,26,156,204,150,82,24,24,28,24,24,84,136,212
          .dc.b      184,184,184,184,184,184,184,194,150,82,24,28,24,24,30
ZDBAND5:  .dc.b      54,56,58,24,26,24,36,30,24,24,30,24,24,24,24,24,96,198,188
          .dc.b      184,184,194,204,204,204,146,148,82,24,24,40,42,34
ZDBAND6:  .dc.b      54,56,58,24,40,24,24,24,28,38,24,24,42,40,26,32,24,24,26
          .dc.b      24,74,138,138,82,24,26,24,36,24,84,142,144,186

MASKDL:   .dc.b      $FF
          .dc.b      $FF
          .dc.b      $E0
          .dc.b      $F0
          .dc.b      $FC
          .dc.b      $FF
          .dc.b      $FF

MASKDM:   .dc.b      $FF,$FF,$1C,$0E,$3E,$FF,$FF

MASKDR:   .dc.b      $F9,$E0,$00,$00,$00,$00,$F0

;          END
