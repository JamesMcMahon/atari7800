*         SPHINX--SMCP.S


;          ZERODEF

;          RSEG    CODEE

* INITIALIZE MASTER CONTROL PROGRAMS *
MCPINIT:
* CLEAR SOME RAM *
          LDX     #CRISVARS&$FF           ;SORRY CRIS! HAD TO DO IT
          LDA     #0
MCPICLR:  STA     SVDIST,X
          DEX
          BPL     MCPICLR

* DIFFICULTY AND MAP ADVANCE *

          LDX     DIFCULTY		;Range 0-3
          LDA     DFINIT,X
          STA     DIFIND

* PROGRESSION STUFF *
          LDA     #2
          STA     DUMPAREA
          LDA     #3
          STA     DUMPAREA+1

          LDA     DFRANDA,X
          STA     PSRANDA1
          STA     PSRANDA1+1
          STA     PSRANDA1+2
          STA     PSRANDA1+3
          LDA     DFRANDB,X
          STA     PSRANDB2
          STA     PSRANDB2+1
          STA     PSRANDB2+2
          STA     PSRANDB2+3
          LDA     #$3
          STA     PSRANDA2
          STA     PSRANDA2+1
          STA     PSRANDA2+2
          STA     PSRANDA2+3
          LDA     #$62
          STA     PSRANDB1
          STA     PSRANDB1+1
          STA     PSRANDB1+2
          STA     PSRANDB1+3

** SCROLLING OBJECTS INIT **
          LDA     #$9
          STA     SVNEWBLK
          STA     SVNEWBLK+1
          STA     SVNEWBLK+2
          STA     SVNEWBLK+3

          RTS

** DIFICULTY LEVELS **
DFINIT:   .dc.b      0                      ;NOVICE
          .dc.b      $20                    ;STANDARD
          .dc.b      $40                    ;ADVANCED
          .dc.b      $80                    ;EXPERT

DFRANDA:  .dc.b      $41,$56,$F5,$B1
DFRANDB:  .dc.b      $72,$11,$60,$AA

DFSINIT:  .dc.b      0
          .dc.b      $10
          .dc.b      $15
          .dc.b      $20

** LEVEL 3 MCP INITIALIZATION **
MCPINIT2:
* ENEMY INITS *
          LDA     CDELAY0                ;DELAY BETWEEN FLIGHTS IS DIFIND DRIVEN
          STA     WAITING

          LDX     PLAYER
          LDA     DUMPAREA,X
          EOR     #2
          STA     DUMPAREA,X
          TAX

          LDA     SVDIST,X
          STA     DISTANCE
          LDA     SVHDIST,X
          STA     HDIST

          LDA     PSRANDA1,X             ;PROGRESSION SEEDS
          STA     PSRA1
          LDA     PSRANDA2,X
          STA     PSRA2
          LDA     PSRANDB1,X
          STA     PSRB1
          LDA     PSRANDB2,X
          STA     PSRB2

          LDA     SVGRNDPC,X             ;GROUND STATE
          STA     GRNDPC
          LDA     SVOBJTYP,X
          STA     OBJTYP
          LDA     SVNEWBLK,X
          STA     NEWBLK
          LDA     SVBAND,X
          STA     BAND
          LDA     SVBLOCK,X
          STA     BLOCK

;         DEC     DISTANCE               ;TO INSURE PROPER SPHINX PLACEMENT

          LDA     #$FF
          STA     NBFLAG
          RTS

** ENEMY MASTER CONTROL PROGRAM - LABELS STARTING WITH C **
ENEMYMCP:
          LDA     PHASE
          BMI     CWAITRTS

          LDA     PARAM
          BEQ     CWAIT
          LDA     SPNCLASS
          CMP     #16
          BCS     UWEROUT
          JMP     FLEAOUT
CWAIT:
          LDA     WAITING                ;CURRENTLY WAITING?
;	jmp	CWVCTRL		;!!!!!!!!Put fleas and uwes up fast!!!!
          BEQ     CWVCTRL                ;NO - EXERCISE SOME CONTROL
          LDA     MAINCNT
          AND     #$F                    ;SCALE WAITING VARIABLE
          BNE     CWAITRTS
          DEC     WAITING                ;YES - CONTINUE TO DO SO.
CWAITRTS: RTS

* WAVE CONTROL *
CWVCTRL:
          JSR     RANDOM                 ;NUMBER OF ENEMIES IS RANDOM
          AND     #$3
          ADC     #1
          STA     PARAM

          LDA     WAVECNT
          AND     #$F			;IF WAVE IS ACTIVE, CONTINUE WAVE
	BNE     CWVCONT			;!!!!!!Comment out for uwes only

* FETCH A NEW WAVE OF ENEMIES *
          LDA     DIFIND                 ;LOAD DIFFICULTY INDEX
          CLC
          ADC     #3                     ;BUMP IT UP SOME
          BCC     CSTORDIF
          LDA     #$C0

CSTORDIF: STA     DIFIND
          LSR     
          LSR                           ;ONE IN 32
          LSR     
          TAY
          JSR     RANDOM
          AND     #$3
          ADC     #$2
          ORA     WAVE,Y                 ;LOAD IN A WAVE
          STA     WAVECNT

          TYA
          LSR     
          LSR                           ;ONE IN 8
          TAY
          LDA     CDELAY1,Y              ;DELAY BEFORE NEXT WAVE
          STA     WAITING

UWEROUT:                                 ;PARAM = 1 TO 3 UWES
          BIT     UWEOK
          BPL     CLRPARAM
          LDA     #16
          STA     SPNCLASS
          JSR     DOUWE			;!!!!!!!!!!!!!!!!!!!!!!!
          DEC     PARAM
          BNE     UWEROUT		;!!!WAS COMMENTED OUT!!!!
          RTS

CLRPARAM: LDA     #0
          STA     PARAM
          RTS

** CONTINUE THE ATTACK OF A WAVE OF ENEMIES **
CWVCONT:
          DEC     WAVECNT
          LDA     DIFIND
          LSR     
          LSR     
          LSR     
          LSR     
          LSR     
          TAY
          LDA     CDELAY0,Y              ;DELAY BETWEEN FLIGHTS IS DIFIND DRIVEN
          STA     WAITING

          LDA     WAVECNT                ;HIGH NIBBLE DETERMINES ENEMY TYPE
          LSR     
          LSR     
          LSR     
          LSR     
          STA     SPNCLASS

FLEAOUT:  LDA     NUMFLEAS               ;CHECK TO SEE IF WE CAN CALL FLEAS
          BEQ     CLRPARAM               ;ZERO MEANS NO AVAIL FLEAS
          JSR     FLEAINIT               ;INITIALIZE A FLEA
          DEC     PARAM
         BNE     FLEAOUT		;!!!!!!!Was commented out!!!!!!
          RTS


* DELAYS *
CDELAY0:  .dc.b      16,7,6,5,5,4,4,3
CDELAY1:  .dc.b      32,12,11,10,9,8,7,6

*         MASTER GAME PROGRAMS
WAVE:
          .dc.b      $00,$10,$40,$50
          .dc.b      $80,$90,$C0,$D0
          .dc.b      $A0,$60,$D0,$20
          .dc.b      $00,$40,$80,$C0
          .dc.b      $A0,$B0,$E0,$F0
          .dc.b      $20,$30,$60,$70
          .dc.b      $80,$90,$C0,$D0
          .dc.b      $40,$50,$E0,$F0

**** GROUND MASTER CONTROL PROGRAM ****

* BONUS WAVE DRIVER *
GRBONUS:
          DEC     DISTANCE
          LDA     DISTANCE
          BEQ     GRBON1
          LDA     #0
          STA     DISTANCE
          STA     HDIST
          STA     TAKEOVER
          LDA     #$5B
          STA     PSRA1
GRBON1:
          JSR     RANDOM
;         BMI     GRBJEWEL
          AND     #$3
          BEQ     GRBEND
          CLC
          ADC     #$7
;         BPL     GRBHPOS
;GRBJEWEL
;         AND     #$7
GRBHPOS:  TAX

          JSR     RANDOM                 ;RANDOM HPOS. FIRST WE WILL CHECK
          AND     #$7F
          CLC                            ;BIRD RANGE IS 112 TO 239 (70 TO EF)
          ADC     #106                ;BUT SCROBJ RANGE IS 106 TO 233 (6A TO E9)
 ;        ORA     #$80                   ;FOOTPRINT FOR 1X1 STAMP
  ;       SEC                            ;PRIOR TO CALLING SCRBUF
   ;      SBC     #$10

          JSR     PRINTOK
          BCS     GRBRTS                 ;CARRY MEANS PUNT WITH PREJUDICE
          JSR     SCRBUF
GRBEND:   JMP     GRNDFOO
GRBRTS:   RTS

***/< GROUND MASTER CONTROL >\***

GRNDMCP:
          BIT     GCOARSE                ;PUNT FOR NON COARSE SCROLLS
          BPL     GRBRTS

*** DO PROGRESSION EVERY COARSE SCROLL ***
          JSR     LANDPROG

          LDA     PHASE
          BMI     GRBONUS
          BNE     GRBRTS

*** CHECK FOR SPHINX ***
          LDX     PLAYER
          LDA     RACK,X
          CLC
          ADC     DIFCULTY		;Range 0-3
          CMP     #8
          BCC     SPHXD1
          LDA     #7
SPHXD1:   ASL     
          TAX
          LDA     HDIST
          CMP     SPHXDIST,X
          BCC     GRNDFOO
          LDA     DISTANCE
          CMP     SPHXDIST+1,X
          BCC     GRNDFOO
          LDA     PHASE
          BMI     GRNDFOO

* BRING OUT SPHINX *
          LDA     TAKEOVER
          CMP     #$85
          BCS     PLSPHNX
          CMP     #80
          BCS     PLSPWAIT
          LDA     #$80
          STA     TAKEOVER
          RTS
PLSPWAIT: INC     TAKEOVER
          RTS
PLSPHNX:  LDX     #$C                    ;SPHINX
          LDA     #$B0
          JSR     PRINTOK
          BCS     GRBRTS                 ;CARRY MEANS PUNT WITH PREJUDICE
          LDX     #$10
          JSR     SCRBUF
          RTS

SPHXDIST: .dc.b      $00,$60,$00,$C0,$01,$20,$01,$80
          .dc.b      $01,$E0,$02,$40,$03,$A0,$04,$00

GRNDFOO:
          LDY     GRNDPC                 ;Y GETS PC OF PLAYER
          LDA     GRO,Y                  ;A GETS OPCODE FROM GRNDPROG
          CMP     #$FF
          BNE     GNOJMP                 ;FF MEANS LOOP

          LDA     PSRA1                  ;SELECT AN OBJECT
          AND     #$7
          STA     TEMP0
          LDX     PLAYER
          LDA     RACK,X                 ;GRADED WITH RACK
          CMP     #8
          BCC     GRRACK
          LDA     #7
GRRACK:   CLC
          ADC     TEMP0
          TAY
          LDA     PHASE
          BPL     GRBHACK
          LDY     TEMP0
GRBHACK:  LDA     GROBJ,Y
          STA     OBJTYP                 ;CURRENT OBJECT FOR A PATTERN

          LDA     PSRA2
          AND     #$F
          TAY
          LDA     GRSTARTS,Y             ;START AGAIN
          TAY
          STY     GRNDPC                 ;SET PC TO ZERO. YA THIS IS ZERO PAGE
;         LDA     GRO,Y
          JMP     GNDSPACE
GNOJMP:                                  ;NEW WAVE OF GROUND OBJECTS
          INC     GRNDPC
          STA     TEMP9
          AND     #$FE
          BEQ     GRNDRTS
          LDX     OBJTYP

          JSR     PRINTOK
          BCS     GRNDBAR                ;CARRY MEANS PUNT WITH PREJUDICE
          JSR     SCRBUF
GRNDBAR:  LDA     TEMP9
          AND     #1
          BNE     GRNDFOO

GNDSPACE: LDA     PHASE
          BMI     GRNDRTS

* DO JEWELS & HIEROS *
          JSR     RANDOM
          AND     #$1F
          CMP     #11
          BCS     GRNDRTS
          TAX

          JSR     RANDOM                 ;RANDOM HPOS. FIRST WE WILL CHECK
          AND     #$7F
          CLC                            ;BIRD RANGE IS 112 TO 239 (70 TO EF)
          ADC     #106                ;BUT SCROBJ RANGE IS 106 TO 233 (6A TO E9)
          JSR     PRINTOK
          BCS     GRNDRTS                ;CARRY MEANS PUNT WITH PREJUDICE
          JSR     SCRBUF
GRNDRTS:  RTS

GROBJ:    .dc.b      11,11,12,13,11,12,13,11
          .dc.b      15,14,13,15,14,12,14

GRSTARTS: .dc.b      GRO0-GRO,GRO1-GRO,GRO2-GRO,GRO3-GRO
          .dc.b      GRO4-GRO,GRO5-GRO,GRO6-GRO,GRO7-GRO
          .dc.b      GRO4-GRO,GRO7-GRO,GRO2-GRO,GRO6-GRO
          .dc.b      GRO8-GRO,GRO9-GRO,GROA-GRO,GROB-GRO

GRO:      .dc.b      $00,$00,$00,$00,$00,$00,$00,$FF
GRO0:     .dc.b      $A0,$81,$A1,$C0,$A0,$FF           ;\/\
GRO1:     .dc.b      $C2,$A0,$A0,$A0,$7F,$FF           ;Z
GRO2:     .dc.b      $C0,$C0,$80,$80,$00,$FF           ;//
GRO3:     .dc.b      $81,$A1,$C0,$00,$00,$FF           ;--- 
GRO4:     .dc.b      $C0,$A0,$80,$FF                   ;\
GRO5:     .dc.b      $C2,$00,$A0,$00,$7E,$00,$FF       ;!
GRO6:     .dc.b      $C2,$00,$81,$A1,$C0,$00,$7E,$00,$FF ;X
GRO7:     .dc.b      $A0,$A0,$A0,$A0,$FF               ;/
GRO8:     .dc.b      $EE,$EE,$EE,$EE,$6E,$6E,$6E,$6E,$FF ;/ /
GRO9:     .dc.b      $EE,$CE,$00,$8E,$6E,$FF
GROA:     .dc.b      $EE,$00,$CC,$00,$AA,$00,$FF
GROB:     .dc.b      $6F,$8E,$00,$8F,$AE,$00,$FF

*** CHARACTER MAP GENERATION ***
NEWBLOCK:
; THIS ROUTINE FIGURES OUT WHICH BLOCK OF CHARACTER MAP TO BRING ONTO THE
; SCREEN AT THE NEXT COARSE SCROLL

          BIT     NBFLAG                 ;CHECK IF NEW BLOCK IS READY
          BMI     NONEWS                 ;IF NEW BLOCK HAS BEEN PICKED, PUNT OUT

          BIT     TAKEOVER               ;IF NOT TAKING OVER, DO IT RANDOMLY
          BPL     CHOOSEBL

** FORCE BLOCK TO PURE DIRT (9) **
          LDY     NEWBLK
          LDA     RIVERP,Y               ;IF RIVERP(7) = LO, NEWBLK = 9.
          BPL     STUFFIT
          JSR     RANDOM
          AND     #1
          CLC
          ADC     #6                     ;ELSE NEWBLK = 6 OR 7
          BNE     STUFF                  ;JMP

STUFFIT:
          LDA     #9                     ;FORCE IT TO (9)
STUFF:    STA     NEWBLK
          DEC     NBFLAG                 ;NBFLAG(7) = HI
NONEWS:   RTS

** CHOOSE A NEW BLOCK BASED ON THE PROGRESSION **
CHOOSEBL:
          CLC
          LDA     PSRA1
          ADC     PSRA2
          AND     #$7
          TAX

          LDY     NEWBLK
          LDA     RIVERP,Y
          BPL     CHLAND
          LDA     RIVERTBL,X             ;RIVER BLOCKS
          CMP     NEWBLK
          BNE     CHOOSE1
          LDA     RIVERALT,X
          BNE     CHOOSE1

CHLAND:   LDA     LANDTBL,X              ;LAND BLOCKS
          CMP     NEWBLK
          BNE     CHOOSE1
          LDA     LANDALT,X
CHOOSE1:
          STA     NEWBLK
          DEC     NBFLAG
          RTS

RIVERTBL: .dc.b      $1,$2,$3,$3,$4,$5,$6,$7
RIVERALT: .dc.b      $7,$6,$4,$5,$5,$3,$2,$1
LANDTBL:  .dc.b      $0,$8,$9,$9,$A,$B,$C,$D
LANDALT:  .dc.b      $9,$9,$C,$D,$9,$8,$A,$B

RIVERP:   .dc.b      $80,$80,$80,$80,$80,$80   ;0 - 5  -> RIVER
          .dc.b      0,0,0,0,0,0,0,0           ;6 - 13 -> LAND

LANDPROG:
          LDA     DISTANCE
          AND     #$F
          BNE     LANDFOO

** COPY STATE INTO DUMP AREAS **
          LDX     PLAYER
          LDA     DUMPAREA,X
          EOR     #$2
          STA     DUMPAREA,X
          TAX

          LDA     DISTANCE
          STA     SVDIST,X
          LDA     HDIST
          STA     SVHDIST,X
          LDA     PSRA1
          STA     PSRANDA1,X
          LDA     PSRA2
          STA     PSRANDA2,X
          LDA     PSRB1
          STA     PSRANDB1,X
          LDA     PSRB2
          STA     PSRANDB2,X
          LDA     GRNDPC
          STA     SVGRNDPC,X
          LDA     OBJTYP
          STA     SVOBJTYP,X
          LDA     NEWBLK
          STA     SVNEWBLK,X
          LDA     BLOCK
          STA     SVBLOCK,X
          LDA     BAND
          STA     SVBAND,X

*** CALCULATE THE NEXT STEP IN THE PROGRESSION ***
LANDFOO:  INC     DISTANCE
          BNE     LPROG1
          INC     HDIST
LPROG1:   LDA     PSRA1
          CLC
          ADC     PSRB1
          PHA
          LDA     PSRA2
          ADC     PSRB2
          PHA
          LDA     PSRA1
          STA     PSRB1
          LDA     PSRA2
          STA     PSRB2
          PLA
          STA     PSRA2
          PLA
          STA     PSRA1
          RTS

;LANDPREV
;         LDA     PSRA1
 ;        SEC
  ;       SBC     PSRB1
   ;      PHA
    ;     LDA     PSRA2
     ;    SBC     PSRB2
;         PHA
 ;        LDA     PSRB1
  ;       STA     PSRA1
   ;      LDA     PSRB2
    ;     STA     PSRA2
     ;    PLA
;         STA     PSRB2
 ;        PLA
  ;       STA     PSRB1
   ;      RTS


*         PRINTOK  PASSED OBJECTID IN X AND HPOS IN ACCUMULATOR
*DETERMINES WHETHER AN OBJECT CAN BE PLACED AT THAT LOCATION
*SAVES X AND A    USES TEMPS 0 THROUGH 5

CURDEX    EQU     TEMP0
VCOUNT    EQU     TEMP1
HCOUNT    EQU     TEMP2

PRINTOK:
          STX     TEMPX                  ;SAVE A AND X
          STA     TEMP3

          SEC                            ;CALCULATE INDEX INTO MASK
          SBC     #ZSTHPOS               ;NORMALIZE HPOS TO ZSTHPOS
          STA     TEMP5                  ;TO SEE IF WE NEED VCOUNT ADJUST LATER
          LSR                           ;DIVIDE BY 8
          LSR     
          LSR     
          STA     CURDEX                 ;SAVE AWAY

          LDA     VPRNTBL,X              ;GET VERTICAL HEIGHT OF OBJECT
          STA     VCOUNT                 ;AND STORE TO VERTICAL COUNTER

          LDY     LOADFDEX               ;GET POINTER TO CURRENT CHAR MAP MASK

VCHKLP:   LDX     TEMPX
          CLC                            ;IF OBJ IS BETWEEN 2-7 TO RIGHT OF CHAR
          LDA     TEMP5                  ;THEN WE WANT TO ADD 1 TO HCOUNT
          AND     #$06
          BEQ     NOADD1                 ;WE MIGHT BE ABLE TO MOVE THIS OUT VLUP
          SEC                            ;BETWEEN 2-7 SO ADD ONE
NOADD1:   LDA     HPRNTBL,X              ;ALSO MAKE IT INTO A TABLE
          ADC     #0
          STA     HCOUNT                 ;AND STORE TO HORIZONTAL COUNTER

          LDA     CURDEX                 ;GET CURRENT INDEX
          BMI     OUTAHERE               ;IF MINUS THEN WE'RE GONE

HCHKLP:   CMP     #8                     ;CHECK TO USE EITHER LEFT, MID, OR RIGT
          BCS     DICKLESS               ;USE MID OR RIGT

          TAX                            ;USE LEFT
          LDA     LEFTMASK,Y
          AND     BKONEMSK,X
          BEQ     OUTAHERE               ;GO AWAY

          EOR     #$FF                   ;THIS GIVES US ZERO MASK TO AND WITH
          AND     LEFTMASK,Y             ;MASK AND THEREFORE ZERO OUT WHERE OBJ
          STA     LEFTMASK,Y             ;IS GOING

INXS:     INX
          TXA                            ;PUNT INDEX BACK INTO A
          DEC     HCOUNT                 ;ARE WE DONE WITH HORIZ
          BNE     HCHKLP                 ;NO, CONTINUE

          BEQ     NEXTV                  ;YES, GO TO NEXT V

DICKLESS: CMP     #16                    ;IF >= 16 THEN WE MUST GO TO RIGTMASK
          BCS     DIKLESS2

          SEC
          STA     TEMP4
          SBC     #8                     ;USE MIDMASK
          TAX                            ;CLEVER HACKERY.  DON'T ASK
          LDA     BKONEMSK,X
          LDX     TEMP4
          AND     MIDMASK,Y
          BEQ     OUTAHERE               ;NO, SO PUNT WITH PREJUDICE

          EOR     #$FF                   ;ZERO OUT MASK BIT WHERE OBJECT IS
          AND     MIDMASK,Y             ;BEING PLACED
          STA     MIDMASK,Y
          JMP     INXS                   ;CAN BE A BCS BUT WHOSE COUNTING?

DIKLESS2:                                ;WE MUST USE RIGTMASK
          ;SEC                           ;CARRY SET FROM BRANCH
          STA     TEMP4
          SBC     #16                    ;USE MIDMASK
          TAX                            ;CLEVER HACKERY.  DON'T ASK
          LDA     BKONEMSK,X
          LDX     TEMP4
          AND     RIGTMASK,Y
          BEQ     OUTAHERE               ;NO, SO PUNT WITH PREJUDICE

          EOR     #$FF                   ;ZERO OUT MASK BIT WHERE OBJECT IS
          AND     RIGTMASK,Y             ;BEING PLACED
          STA     RIGTMASK,Y
          JMP     INXS                   ;CAN BE A BCS BUT WHOSE COUNTING?

NEXTV:    DEC     CURDEX                 ;DECREMENT H START INDEX BY TWO
          DEC     CURDEX

          INY                            ;UPDATE MASK TABLE INDEX
          TYA
          AND     #$03
          TAY

          DEC     VCOUNT
          BNE     VCHKLP                 ;NOT DONE YET

OKDOKIE:  LDA     TEMP3
          LDX     TEMPX
          CLC                            ;INDICATES ALL IS WELL
          RTS                            ;CLC INDICATES PRINT OK

OUTAHERE: LDA     TEMP3
          LDX     TEMPX
          SEC                            ;SEC INDICATES WE SHOULD PUNT OK
          RTS

HPRNTBL:  .dc.b      1,2,1,2,2,1,2,2,1,1,2,2,5,1,5,1
VPRNTBL:  .dc.b      1,1,1,1,1,1,1,1,1,1,1,1,2,1,2,1

BKZRMASK: .dc.b      $7F,$BF,$DF,$EF,$F7,$FB,$FD,$FE
BKONEMSK: .dc.b      $80,$40,$20,$10,$08,$04,$02,$01


** COLOR INITIALIZATION **
COLINIT:
          LDX     #$1B
          LDY     #20
CLRIN1:
          LDA     INCOLOR,Y
          STA     BACKGRND+4,X
          DEY
CLRIN2:   DEX
          BMI     NOMORE
          TXA
          AND     #3
          BNE     CLRIN1
          BEQ     CLRIN2
NOMORE:

CCSPHINX:
          LDX     PLAYER                 ;PALETTE ZERO
          LDA     BRDCOLOR,X
          STA     BACKGRND+1
          LDA     BRDCOLOR+1,X           ;COLOR 2 MUST BE SHADOWED FOR TOP
          STA     P0C2SHAD               ;OF SCREEN
          LDA     BRDCOLOR+2,X
          STA     BACKGRND+3

          LDA     RACK,X
          AND     #$7
          ASL     
          ASL     
          TAY
          LDA     SPHCOLOR,Y
          STA     BACKGRND+$1D
          LDA     SPHCOLOR+1,Y
          STA     BACKGRND+$1E
          LDA     SPHCOLOR+2,Y
          STA     BACKGRND+$1F

** CHANGE BACKGROUND, CHARACTER MAP **
CCBAKGR:
;         JSR     RANDOM
 ;        AND     #$1C
  ;       TAY
          LDA     BAKCOLOR,Y             ;PALETTE 2
          STA     BACKCOL
          LDA     BAKCOLOR+1,Y
          STA     BACKGRND+9
          LDA     BAKCOLOR+2,Y
          STA     P2C2SHAD               ;COLOR TWO HAS TO BE PUT IN SHADOW REG
          LDA     BAKCOLOR+3,Y
          STA     BACKGRND+$B

CCSCRBS:  LDA     SCBCOLOR,Y             ;CHANGE SCROLLING OBJECT COLOR
          STA     P3C1                   ;ADDED 7/26 JEM
          LDA     SCBCOLOR+1,Y
          STA     P3C2
          LDA     SCBCOLOR+2,Y
          STA     P3C3

          LDA     RACK                   ;ONLY EIGHT ENTRIES IN TABLE
          AND     #$07
          TAY
          LDA     SHCOLTBL,Y             ;SOME MORE JEM HACKS 7/26
          STA     P1C1
          STA     P1C2SHAD               ;COLOR TWO IS SHADOWED
          STA     P1C3

          LDA     #$58                   ;BE CAREFUL MORE JEM HACKS EVEN
          STA     P5C2SHAD               ;COLOR 2 OF PAL 5 MUST BE SHADOWED
          LDA     #$6F                   ;SOME MORE HACKS FOR THE MASSES
          STA     P1C2SHDB
          RTS

** INITIAL SET OF COLORS **
;NCOLOR   .dc.b      $13                    ;BACKGRND
 ;        .dc.b      $C7,$CC,$CF            ;PALLETTE ZERO  (BIRD)
INCOLOR:  .dc.b      $02,$02,$02            ;PALLETTE ONE   (SHADOW)
          .dc.b      $16,$76,$72            ;PALLETTE TWO  (SCROLLING PLAYFIELD)
          .dc.b      $0C,$04,$08            ;PALLETTE THREE (PYRAMIDS)
          .dc.b      $3D,$38,$32            ;PALLETTE FOUR  (GLIDERS 1)
          .dc.b      $5D,$58,$52            ;PALLETTE FIVE  (GLIDERS 2)
          .dc.b      $3C,$34,$F1            ;PALLETTE SIX  (GLIDERS 3)
          .dc.b      $2C,$26,$F0            ;PALLETTE SEVEN (SPHINX)

BRDCOLOR: .dc.b      $E7,$07
          .dc.b      $EC,$0C
          .dc.b      $CF,$0F

SPHCOLOR:
          .dc.b      $2C,$26,$F0,0
          .dc.b      $0A,$06,$01,0
          .dc.b      $7C,$76,$B0,0
          .dc.b      $C9,$C5,$E0,0
          .dc.b      $0C,$08,$01,0
          .dc.b      $BC,$98,$B0,0
          .dc.b      $0C,$08,$03,0
          .dc.b      $CA,$C6,$E0,0

BAKCOLOR:
          .dc.b      $15,$16,$76,$72
          .dc.b      $C2,$C4,$85,$61
          .dc.b      $08,$0A,$B6,$B3
          .dc.b      $00,$73,$38,$52
          .dc.b      $12,$14,$96,$90
          .dc.b      $A0,$C3,$69,$63
          .dc.b      $40,$43,$29,$26
          .dc.b      $03,$05,$08,$05

SCBCOLOR: .dc.b      $0C,$04,$08,0
          .dc.b      $AA,$A2,$A6,0
          .dc.b      $1F,$C3,$C7,0
          .dc.b      $7C,$01,$67,0
          .dc.b      $2C,$12,$06,0
          .dc.b      $CA,$E0,$C6,0
          .dc.b      $7B,$77,$B0,0
          .dc.b      $0C,$03,$08,0

SHCOLTBL: .dc.b      $02,$02,$02,$A0,$02,$02,$02,$02
;          END
