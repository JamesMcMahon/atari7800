
********************************************************************************
***********                                                           **********
***********       INITDIRT:  CALLED AT START OF EACH RACK TO          **********
***********                  INITIALIZE DIRT, TUNNELS, AND            **********
***********                  CREATURES FOR THE RACK.                  **********
********************************************************************************
INITDIRT
          LDA     NOTUNNEL
          BNE     JUSTCRET

          LDA     #FULLDIRT              ;FULL DIRT CHARACTER INDEX.
          LDX     #224                   ;FIRST, FILL IN ALL THE DIRT.
FILLDRT   STA     DIRTMAP+$F,X
          DEX
          BNE     FILLDRT

          LDX     #$76
          JSR     HCARVE

          LDX     #13                    ;FILL LEFT AND RIGHT EDGES OF DIRT WITH
BLACKEDG  LDY     MAPLOW,X               ;  BLANKS: THIS CREATES 14 COLUMNS OF
          LDA     #BLANKL
          STA     DIRTMAP,Y              ;  DIRT, 8 PIXELS WIDE EACH.
          STA     DIRTMAP+$10
          LDA     #BLANKR
          STA     DIRTMAP-1,Y
          DEX
          BNE     BLACKEDG
          STA     DIRTMAP+$EF

***       LDX     #0                     ;X IS ALREADY 0.
          TXA                            ;CALCULATE EFFECTIVE RACK NUMBER, GIVEN
          LDY     ATTRACT                ;  THAT RACKS 12-15 REPEAT.
          BNE     GOTERACK
          LDX     PLAYNUM
          LDY     RACKNUM,X              ;ACTUAL RACK NUMBER.
          BNE     RACKN                  ;  NUMBER WHEN WE'RE DONE.
          INY
          STY     RACKNUM,X
RACKN     DEY
          LDA     BONZO
          BEQ     NOBONZ
          TYA                            ;BONZO MODE: EFFRACK MAX AT 2+15.
          CLC
          ADC     #15
          BCS     WRAPBONZ
          CMP     #MAXEFFR               ;17
          BCC     GOTERACK
WRAPBONZ  LDA     #MAXEFFR
          BNE     GOTERACK
NOBONZ    TYA
          CPY     #15
          BCC     GOTERACK
          LDA     RACKNUM,X
          AND     #3                     ;CLOSEST MULTIPLE OF 4.
***       CLC
***       ADC     #11
          ADC     #10                    ;(CARRY SET).
GOTERACK  STA     EFFRACK,X

JUSTCRET  LDY     PLAYNUM
          LDX     EFFRACK,Y
          CPX     #MAXEFFR
          BCC     REGTUNL
          LDA     NOTUNNEL
          BEQ     ZNEWCRET
          LDX     BRCREAT
          LDA     RANDCRET,X
          STA     RCREATS
          LDA     BRTUNNL
          JMP     ZANYCRET
ZNEWCRET  LDA     FRMCNT
          AND     #7
          TAX
          LDA     RANDCRET,X
          STA     RCREATS
          STX     BRCREAT
          JSR     RANDOM
ZANYCRET  STA     RTUNNELS
          STA     BRTUNNL
          TXA
          CLC
          ADC     #17
          BNE     ZTUNNEL0
REGTUNL   LDY     CREATS,X               ;CREATURE BYTE: 0=> POOKA, 1=> FYGAR.
          STY     RCREATS
          LDY     TUNLDIR,X              ;TUNNEL DIRECTION: 0=> HORIZ, 1=> VERT.
          STY     RTUNNELS
          TXA
ZTUNNEL0  ASL     A                      ;MULTIPLY BY 8 FOR INDEX INTO TUNNELS.
          ASL     A
          ASL     A
          TAY
          LDA     #0                     ;INITIALIZE POINTERS INTO POOKA AND
          STA     PCOUNT                 ;  FYGAR ARRAYS.
          LDA     #4
          STA     FCOUNT
          LDX     #7                     ;POSSIBLE 8 TUNNELS PER RACK.
          STX     TCOUNT
ITUNNEL   LDX     TUNNELS,Y
          BNE     ZTUNNEL
          TXA
          PHA
          PHP
          BEQ     ZCREATS
ZTUNNEL   ASL     RTUNNELS               ;GET TUNNEL DIRECTION.
          LDA     NOTUNNEL               ;JUST INIT CREATURES?
          BNE     ICREATS
          BCS     VTUNNEL                ;(SET BY ASL).
          JSR     HCARVE
          BNE     ICREATS
VTUNNEL   LDA     #DTOPEND               ;***MARIA 1...
          STA     DIRTMAP,X              ;VERTICAL TUNNEL.
          LDA     #DVMIDDLE              ;***MARIA 1...
          STA     DIRTMAP+$10,X
          LDA     #DBOTEND               ;***MARIA 1...
          STA     DIRTMAP+$20,X
ICREATS
          TXA                            ;IF CARRY CLEAR, HORIZONTAL TUNNEL.
          JSR     GETRXY                 ;RETURNS X POS IN A, Y IN X.
          PHA
          PHP
          TXA
ZCREATS   ASL     RCREATS
          BCS     IFYGAR
          LDX     PCOUNT                 ;INDEX INTO POOKA ARRAY.
          INC     PCOUNT
          BNE     GOTCINDX
IFYGAR    LDX     FCOUNT
          INC     FCOUNT
GOTCINDX
          PLP
          PHP
          BCC     ZHTUNL
          SBC     CRYOFST,X              ;VERT TUNNEL - OFFSET CREATURE Y POS.
          BCS     ZHTUNL
          LDA     #0
ZHTUNL    STA     POOKAY,X
*         JSR     DOOM
          CMP     #0
          BNE     ZGOTCRET
          PLP
          PLA
          LDA     #$80
          STA     MONSTAT,X
          BMI     NOCREAT
ZGOTCRET
          PLP
          PLA
          BCS     ZVTUNL
          ADC     CRXOFST,X              ;HORIZ TUNNEL: OFFSET CREATURE X POS.
ZVTUNL    STA     POOKAX,X
          LDA     MONSTAT,X
          BMI     NOCREAT
          LDA     #0
          STA     MONSTAT,X
          BEQ     ZGOTC2
NOCREAT   LDA     #0
          STA     POOKAY,X
ZGOTC2    INY
          DEC     TCOUNT
          BPL     ITUNNEL

          LDY     PLAYNUM
          LDA     BONZO
          BEQ     REALVEG
          LDX     #NUMVEG+1
          BNE     GETVCOL
REALVEG   LDX     RACKNUM,Y
          BEQ     GETVCOL
          DEX
          CPX     #NUMVEG
          BCC     GETVCOL
          LDX     #NUMVEG
GETVCOL   LDA     VEGCOL2,X
          STA     VEGCOLR
          LDA     VEGCOL1,X
          STA     VEGCOLR+1
          LDA     VEGCOL3,X
          STA     P0C0SHAD+23
          LDA     #CSET1
          STA     FRUITCST
          LDA     #VEGPALW
          STA     FRUITPAL
          LDX     RACKNUM,Y
          BEQ     DORAK1
          DEX
          BNE     ADJ12
DORAK1
          LDA     NOTUNNEL
          BNE     ADJ12
          LDA     ATTRACT
          BNE     ZDORAK1
          LDA     BONZO
          BNE     ADJ12
ZDORAK1   LDA     #DHMIDDLE              ;RACK 1 IS ONLY RACK WITH TUNNELS
          STA     DIRTMAP+$2C            ;  TALLER OR WIDER THAN 3 DIRT BLOCKS.
          STA     DIRTMAP+$A5
          LDA     #DRHTEND
          STA     DIRTMAP+$2D
          STA     DIRTMAP+$A6
          LDA     #DVMIDDLE
          STA     DIRTMAP+$42
          STA     DIRTMAP+$52
          STA     DIRTMAP+$BA
          STA     DIRTMAP+$CA
          LDA     #DBOTEND
          STA     DIRTMAP+$62
          STA     DIRTMAP+$DA
ADJ12     TXA
          CMP     #12
          BCC     GOTDCOLR
ADJ12A    SBC     #12                    ;3 COLOR SCHEMES: EACH COLOR SCHEME
          CMP     #12
          BCS     ADJ12A                 ;  LASTS FOR FOUR RACKS.
GOTDCOLR  AND     #$C
          TAX
          LDA     DIRTCOLR,X             ;INITIALIZE PALETTES FOR THIS RACK.
          STA     P0C0SHAD+25
          LDA     PEBBCOLR,X
          STA     P0C0SHAD+27
          LDY     #0
ZTOPLOOP  LDA     DIRTCOLR+1,X
          STA     DRT1COLR,Y
          LDA     PEBBCOLR+1,X
          STA     DRT1COLR+1,Y
          INX
          INY
          INY
          CPY     #6
          BCC     ZTOPLOOP
*         LDA     DIRTCOLR+1,X           LDY #0
*         STA     DRT1COLR               LDA DIRTCOLR+1,X
*         LDA     PEBBCOLR+1,X           STA DRT1COLR,Y
*         STA     DRT1COLR+1             LDA PEBBCOLR+1,X
*         LDA     DIRTCOLR+2,X           STA DRT1COLR+1,Y
*         STA     DRT2COLR               INX
*         LDA     PEBBCOLR+2,X           INY  INY
*         STA     DRT2COLR+1             CPY #6
*         LDA     DIRTCOLR+3,X           BCC TOPLOOP
*         STA     DRT3COLR
*         LDA     PEBBCOLR+3,X
*         STA     DRT3COLR+1

********  RTS     OLD RTS FOR INITDIRT!!!!!!!!!!!!!!!!

********************************************************************************
***********                                                          ***********
***********       INCREATS:  INITIALIZE CREATURES IN TUNNELS.        ***********
***********                                                          ***********
***********    INCREATS : NOW A PART OF INITDIRT!!!!!

;-------- INITIALIZE RAM VARIABLES FOR MONSTER MOVEMENT ALGORITHMS
;-------- AND OTHER THINGS .....

          JSR     DOSTART                ;RETURNS 0 IN A

*         LDA     #0
          LDX     #8
ZPRIOR0   STA     STMPRIOR,X
          DEX
          BPL     ZPRIOR0

          LDX     #$07
EACHMONS  LDA     #$00
          STA     BLWSTAT,X
          STA     GHOST,X
          STA     YMODC,X
          LDA     #$08
          STA     FACING,X
          JSR     GHSTSUB1
*         JSR     GETDIRT
*         STY     TEMP3                  NECESSARY FOR CHKOTHER CODE
*         JSR     CHKOTHER
          LSR     A                      INDEX=CHAR
          STA     TEMP1
          LDA     #$04
          LSR     TEMP1
          BCC     NEXT115
          ASL     A                      ;ASSUME A CONTAINS 4
          LSR     TEMP1
          BCC     NEXT115
          LDA     #$01
          LSR     TEMP1
          BCC     NEXT115
          ASL     A                      ;ASSUME A CONTAINS 1
          LSR     TEMP1
          BCC     NEXT115
          LDA     #$00
NEXT115   STA     DIR,X                  SETUP FOR JSR NEWSEQ
          JSR     NEWSEQ
          JSR     SPEEDER
*         LDA     CHARSEQL,X             ;NOW DONE IN NEWSEQ - 1/18/84
*         STA     TEMP1
*         LDA     #H(RPOOKA)
*         STA     TEMP2
*         LDY     #$00
*         LDA     (TEMP1),Y
*         STA     POOKAIX,X
          DEX
          BPL     EACHMONS

          JMP     GETMODE                ;GETMODE IS A SUBR
;-------- END OF MONSTER MOVEMENT VAR. INITIALIZATION

*         RTS

DOSTART   LDA     FRMCNT                 ;CALLED FROM INCREATS AND DDMOVE
          CLC
          ADC     #60                    ; CHANGE FOR PAL/SECAM
          STA     NXTSEC                 ;  ...ALSO NEXT LINE

          LDX     #67                    ;1 MINUTE, 7 SECONDS
          LDA     BONZO
          BNE     BONZSPED
          LDY     PLAYNUM
          LDA     RACKNUM,Y
BONZSPED  CMP     #24
          BCC     SETFAST
          LDX     #2                     ;ABOUT TWO SECONDS
SETFAST   STX     SPEEDUP

          JSR     SETDFAST               ;SET DD SPEEDS

          JSR     INITALLS               ;SETS A TO 0, USES Y
          STA     CURSONG
          STA     SNGTEMP1
*         LDA     #$00
*         STA     ANIMCNT                ;THESE 20 REGISTERS MUST STAY ADJACENT
*         STA     DIGGING
*         STA     PUMPNUM
*         STA     SQUASH

*         STA     NOTGRID
*         STA     NEEDDIR
*         STA     FSCORE
*         STA     FSCORCTR
*         STA     GHOSTIME
*         STA     ESCAPER
*         STA     PUMP
*         STA     PUMPING
*         STA     PUMPCNT
*         STA     WALKING
*         STA     FREEZE
*         STA     FLAMIE
*         STA     FLAMTIME
*         STA     FRUIT
*         STA     DIGREST
*         STA     SCNDTIM

          LDX     #19
ZIFSCOR   STA     ANIMCNT,X
          DEX
          BPL     ZIFSCOR

          STX     PUMPIE                 ;EXPECTS X TO BE FF
          STA     FLEE                   ;EXPECTS A TO BE 0
          STA     FAST
          STA     LASTMOVE


          LDX     #$B5
          STX     PROPORT3
          STX     PROPORT2
          STX     PROPORT
          LDX     #4                     ;FORCE GHOSTING AFTER ABOUT 4 SECONDS
          STX     GHOSTOUT

          JMP     INITDIGS               ;SETS A TO 0, USES Y (INITDIGS IS SUBR)
*         RTS


********************************************************************************
***********                                                          ***********
***********       INITROCK:  INITIALIZE ROCKS IN DIRT.               ***********
***********                                                          ***********
********************************************************************************
INITROCK
          LDA     #0
          STA     REGROCK
          LDY     #$07
ZIROCK0   STA     TEMP+5,Y
          DEY
          BPL     ZIROCK0
          LDA     FRMCNT
          ROR     A
          STA     RANDROCK
          LDY     #4                     ;MAXIMUM OF 5 ROCKS.
          LDX     PLAYNUM
          LDA     EFFRACK,X
          CMP     #MAXEFFR
          BCC     ZIROCK
          INC     REGROCK                ;RANDOM ROCK RACK.
          BPL     DOROCKS
ZIROCK    ASL     A
          ASL     A
          CLC
          ADC     EFFRACK,X
          STA     TEMPX

DOROCKS   LDX     TEMPX
          LDA     REGROCK
          BEQ     TABLROCK

          JSR     RANDOM                 ;RANDOM ROCK RACK:  SHOULD WE PLACE A
          AND     #1                     ;  ROCK HERE?
          BEQ     ZTABROK0
ZGETROK   ROR     RANDROCK               ;YES: GET A RANDOM INDEX INTO POSSIBLE
          JSR     RANDOM                 ;  ROCKS FOR RANDOM RACKS.
          EOR     RANDROCK
          AND     #7
          TAX
          LDA     TEMP+5,X
          BNE     ZGETROK
          LDA     RANDROKS,X             ;GET ROCK POSITION.
          STA     TEMP+5,X
          BNE     ZROCK

TABLROCK  LDA     ROCKS,X                ;ROCK X,Y COMBINED POSITION.
          BNE     ZROCK

ZTABROK0  TAX                            ;NO ROCK HERE...
          BEQ     ZROCK1

ZROCK     JSR     GETRXY                 ;RETURNS X IN A, Y IN X.
          STA     ROCKSX,Y
ZROCK1    STX     ROCKSY,Y
          LDA     #STRTROCK
          STA     ROCKSIX,Y
          LDA     #0
          STA     TUMBLE,Y
          INC     TEMPX                  ;MOVE TO NEXT ENTRY IN ROCK TABLE.
          DEY                            ;MOVE TO NEXT POSSIBLE ROCK.
          BPL     DOROCKS
          RTS



*******************
*******************
*******************
*******************
*******************
RANDOM
          LDA     FRMCNT
          ADC     RNDM
          ADC     RNDM+1
          PHA
          LDA     RNDM
          STA     RNDM+1
          PLA
          STA     RNDM
          RTS

*DOOM      PHA
*         TYA
*         PHA
*         LDY     #15
*         LDA     GHOST,X
*         BNE     Z2
*         LDA     POOKAY,X
*         BEQ     Z2
*DOOMLOOP  CMP     TOPZONE,Y
*         BEQ     Z2
*         DEY
*         BPL     DOOMLOOP
*DOOMTRAP  NOP
*         NOP
*Z2        PLA
*         TAY
*         PLA
*DOOMRTS   RTS
PTUNNELS  DB      $2A,$A3
          DB      $22,$9A
          DB      0

          DB      $97,$BB,$3B,$62
          DB      $92
          DB      0

          DB      $2B,$52,$C9
          DB      $38,$96
          DB      0

          DB      $34,$A4,$C8
          DB      $38,$7C
          DB      0

          DB      $32,$93,$AB
          DB      $36,$2A,$6B
          DB      0

          DB      $34,$34,$8A,$92,$B6
*                 PP F F F
          DB      $53
*                 F
          DB      0

          DB      $3A,$3A,$93,$93,$B9
*                 FP  FP  F
          DB      $26,$26
*                 PP
          DB      0

          DB      $32,$4A,$AA,$C5
*                 F P F P
          DB      $36,$36,$83
*                 PP F
          DB      0

          DB      $59,$59,$96,$B2,$B2,$BB
*                 PP F FF F
          DB      $35,$5D
*                 P P

          DB      $48,$48,$A4,$BA
*                 PF F P
          DB      $2C,$2C,$54,$6A
*                 PP F F

          DB      $44,$44,$62,$62
*                 PF PP
          DB      $4A,$4A,$6D,$93
*                 PF F F

          DB      $43,$43,$58,$58,$AA,$AA,$B5    ;THESE REPEAT -- RACK 12
*                 PF PP FF F
          DB      $4D
*                 P

          DB      $3A,$3A,$A6,$A6,$CB,$CB
*                 PP FF FF
          DB      $6C,$54
*                 P P

          DB      $38,$38,$8A,$A4,$A4
*                 PP F FF
          DB      $34,$34,$4D
*                 PF P

          DB      $2B,$6A,$72,$72
*                 P P FF
          DB      $36,$36,$96,$98
*                 PP F F

          DB      $3B,$A2,0              ;BONZO LEVEL 0.
*                 F P
          DB      $23,$A7,0              ;BONZO LEVEL 1.
*                 P F

          DB      $6B,$42,$BA,0          ;RANDOM RACKS.
*                 F F P
          DB      $23,$93,$3A,0
*                 F F F
          DB      $6B,$42,$A7,0
*                 P F P
          DB      $B2,$BA,$23,$3A,0
*                 P P P P
          DB      $23,$BA,0
*                 F P
          DB      $B2,$A7,$BA,0
*                 P F F
          DB      $23,$3A,$A7,0
*                 P P F
          DB      $93,$6B,$42,$3A,0
*                 F P P F
*MOVED TO ARRAYS:
*TEDYPINE  DB      TEDDY,$BE,CSET1,76,0,0             ;(PALETTE 5).

ISCOREL   LDX     #58                    ;INIT DISPLAY LIST FOR SCORE LINE.
ISCOREL0  LDA     ISCORLIN,X
          STA     L0Z0,X
          DEX
          BPL     ISCOREL0
          LDX     #5
          LDA     #0
ISCOREL1  STA     SCOREL,X
          DEX
          BPL     ISCOREL1
          RTS                            ;RETURNS 0 IN A.


CRUNCH    STA     VICTIMY
          LDA     ROCKSX,X               ;ROCK HOR POS
          SEC
          SBC     VICTIMX
          BPL     CRUNCH2
          EOR     #$FF                   ; DOES NOT AFFECT CARRY
*         CLC                            ; MINUS MEANS CARRY CLEAR
          ADC     #1
CRUNCH2   CMP     #6                     ;REQUIRE OVERLAP OF 2
          BCS     CRUNCH5
          LDA     ROCKSY,X               ;LDA DOES NOT AFFECT CARRY
*         CLC
          ADC     #6
          SEC
          SBC     VICTIMY
          BCC     CRUNCH5
          CMP     #17
          BCS     CRUNCH5

          LDA     ROCKSY,X
*         SEC                            ; CARRY IS CLEAR HERE
          SBC     #$06-1                 ;MIGHT NEED TO TWEAK THIS
          STA     RTEMP
          CMP     #MINDDY                ;DON'T SQUASH OFF EDGE
          BCC     MINSQSHY
*         SEC
          SBC     VICTIMY
          BCC     NEWSQSHY
          CMP     #$04
          BCC     NEWSQSHY
          LDA     VICTIMY
          BNE     NOCADJST
NEWSQSHY  LDA     RTEMP
NOCADJST  SEC                            ;SQUASH
          RTS
CRUNCH5   CLC                            ;NO SQUASH
          RTS
MINSQSHY  LDA     #MINDDY
          SEC
          RTS

LOOKDIRT  LDA     DIRTMAP,Y
          CMP     #CHARD12
          BCS     ENDLOOK
          CMP     #CHARDF
          BCC     ZNXT120
          LDA     #$02                   ;SKY CHARACTER
*         LDA     #$01                   SKY CHARACTER
*         RTS
ZNXT120   LSR     A
          RTS
ENDLOOK   LDA     #$0F
          RTS

TITLCOLR  LDA     #RED
          STA     P0C0SHAD+26
          STA     P0C0SHAD+27
          LDA     #DDBLUE
          STA     P0C0SHAD,X
          LDA     #RED
          STA     P0C0SHAD+1,X
          LDA     #WHITE
          STA     P0C0SHAD+2,X
PINECOLR  LDA     VEGCOL1+17
          STA     VEGCOLR+1
          LDA     VEGCOL3+17
          STA     P0C0SHAD+23
          LDA     VEGCOL2+17
          STA     VEGCOLR
          RTS


SETTITLE
          JSR     BACKMAP
          LDX     #9                     ;ZONE 9.
          LDA     #163                   ;COPYRIGHT ATARI AND NAMCO.
          LDY     #14
          JSR     PUTTITLE
          LDX     #13                    ;ZONE 13.
          LDA     #29                    ;TOP OF DIGDUG LOGO.
          LDY     #34
          JSR     PUTTITLE
          LDX     #12                    ;ZONE 12.
          LDA     #153                   ;BOTTOM OF DIGDUG LOGO.
          LDY     #34
          JMP     PUTTITLE
***       RTS

***BONZDIFF  DB      29,29,29,29,29,29,29,29
***       DB      29,29,29,29,29,29,29,29
***       DB      29,29,29,29,29,29,29,29
***       DB      29,29


;-------- BUTTON INPUT ROUTINE           (FROM COLLISON FILE)


INPUT     LDX     #0
          LDY     PLAYNUM
*         BEQ     INPUTGO
*         LDA     ALIEN
*         BNE     INPUTGO
*         DEY
*INPUTGO
          LDA     INPT4,Y
          BMI     INOUT
          LDA     PUMPCNT
          BEQ     DOPUMP
          INC     PUMPCNT
          CMP     #$18                   TIME DELAY FOR PUMPING
          BEQ     DPUMPING
          BNE     INOUT2
*         LDA     #$00
*         BEQ     INOUT2
INOUT
*         LDA     #$00
*         STA     PUMPCNT
          STX     PUMPCNT
INOUT2
*         STA     PUMPING
*         STA     PUMP
          STX     PUMPING
          STX     PUMP
          RTS
DPUMPING
*         LDA     #$01
*         STA     PUMPING
*         STA     PUMPCNT
          INX
          STX     PUMPING
          STX     PUMPCNT
          RTS
DOPUMP
*         LDA     #$01
*         STA     PUMP
*         STA     PUMPCNT
          INX
          STX     PUMP
          STX     PUMPCNT
          LDY     PUMPIE
          INY
          BEQ     DOPEND
          LDA     PUMPCT
          BNE     DOPEND
          LDA     #$10
          STA     PUMPCT
DOPEND    RTS


TEDYPINE  DB      TEDDY,$BE,CSET1,72   ;  ,0,0             ;(PALETTE 5).
*****  FROM DDMOVE.S FILE
YFROMPL   DB      $00                         ;       ,$00,$00,$F4

YTOPL     DB      $00,$00,$F4,$00,$00,$00,$F4,$0C,$0C,$0C,$00,$11
          DB      $00,$00,$E8,$0C
          DB      $0C,$0C,$00,$17

DIRTCOLR  DB      YELLOW0,GOLD0,ORANG0,DKORANG0
          DB      PALPURP1,PALBRWN1,YELLOW1,GOLD1
          DB      PALPURP2,PALBRWN2,PALTURQ2,DKPURP2

GHSTSUB2  SEC                            ;USED BY GHOSTONX AND CHKOTHER
          SBC     #$10
          TAY
          LDA     DIRTMAP,Y
          CMP     #CHARD12
          RTS

SKYSUB    LDA     TEMP3                  ;USED BY SKY15 AND CHKDOWN
          CLC                            GET DIRT UNDER POSITION
          ADC     #$10
          TAY
          LDA     DIRTMAP,Y
          RTS

GHSTSUB1  JSR     GETDIRT                ;USED BY GHOSTONX AND MOVECONT
          STY     TEMP3                  ;   AND EACHMONS
          JMP     CHKOTHER               ;CHKOTHER IS A SUBR

SUB3      LDA     DDYPOS
          CLC
          ADC     #$01
          LSR     A
          LSR     A
          TAY
          LDA     DIV3TAB,Y
          STA     TEMP1
          CLC
          ADC     TEMP1
          ADC     TEMP1
          ASL     A
          ASL     A
          STA     TEMP1
          LDA     DDYPOS
          CLC
          ADC     #$01
          SEC
          SBC     TEMP1
          RTS

CVTDIR    DB      $02,$01,$04,$03
