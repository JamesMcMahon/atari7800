********** SOLVMOVE:  SOLVALOU MOVEMENT ROUTINE             JULY 25,1983  ****
*SOLVMOVE,SWITCHP


          ZEROPAGE
          PLAYGLBL                       public
          ELGLBL                         extrn
          HEADGLBL                       scorelst, etc.
          BUTTGLBL
          FLAGGLBL
          TUNEGLBL
          MAPVGLBL
          SOLVGLBL
*****************************************
RAM1      CSECT
MAXYPOS   DS      1
MINYPOS   DS      1
SLVXSLOP  DS      1
SLVYSLOP  DS      1

*OTHER  PLAYER VARIABLES
OTHERSTF  DS      NMPLVARS
*PLAYER VARIABLES
PSCOR1    DS      3
PGTHTHOU  DS      1
PMOD0     DS      2
XTRASOLV  DS      1
NUMLIVES  DS      1
RACK      DS      1                      ;THE CURRENT RACK
BSTATUS   DS      1                      ;How to treat the 2-button joystick

ONEORTWO  DS      1                      ;Last state of diff-switch
NUMDEAD   DS      1                      ;CURRENT NUMBER OF DEAD PLAYERS
NUMPLYRS  DS      1                      ;NUMBER OF PLAYERS
PLAYER    DS      1
DIFCULTY  DS      1


*****************************************
CODE9000  CSECT
SOLVMOVE
* Update X and Y on solv and sight
          ADD     MAXYPOS,ANTISCRO,MAXYPOS
          ADD     MINYPOS,ANTISCRO,MINYPOS

          LDX     NEWDIR

          LDA     SLOPXPOS,X
          CLC
          ADC     SLVXSLOP
          STA     SLVXSLOP
          LDA     CXPOS,X
          ADC     ELXPOS
          CMP     #$10                   ;LOWER LIMIT ON HPOS
          BCS     ZXPOSCH2
          LDA     #$10
          BEQ     ZYPOSCHK
ZXPOSCH2  CMP     #$87                   ;UPPER LIMIT ON HPOS
          BCC     ZYPOSCHK
          LDA     #$86

ZYPOSCHK  STA     ELXPOS
          STA     ELXPOS+1               ;SIGHT
          LDA     CYPOS,X
          CLC
          ADC     ELYPOS
          CMP     MINYPOS                ;LOWER LIMIT ON YPOS
          BCS     ZYPOSCH2
          LDA     MINYPOS
          BNE     ZPOSCHKE
ZYPOSCH2  CMP     MAXYPOS                ;UPPER LIMIT ON YPOS
          BCC     ZPOSCHKE
          LDA     MAXYPOS

ZPOSCHKE  STA     ELYPOS
          CLC
          ADC     #$30
          STA     ELYPOS+1

* FLAGS
          LDA     FLAGFLAG
          CMP     #$03
          BNE     ZE1

          LDA     ELYPOS                 ;CHECK FOR FLAG INTERSECTION
          SEC
          SBC     ANTITOTL               ;-ANTI
          CLC
          ADC     #15                    ;+15    --> top edge
          STA     TEMP0
          SEC
          SBC     #30                    ;-30    --> bottom edge
          STA     TEMP1

          LDA     ELXPOS
          CLC
          ADC     #07                    ;+7     --> right edge
          STA     TEMP2
          SEC
          SBC     #14                    ;-14    --> left edge
          STA     TEMP3

          LDA     FLAGYPOS
          CMP     TEMP0
          BCS     ZE1
          CMP     TEMP1
          BCC     ZE1
          LDA     FLAGXPOS
          CMP     TEMP2
          BCS     ZE1
          CMP     TEMP3
          BCC     ZE1
*THE FLAG HAS BEEN FLOWN OVER!!
          INC     NUMLIVES
          INC     FLAGFLAG
          LDA     #$0B
          JSR     TUNIN
          MOVE    FLAGPTRL,TEMP0
          MOVE    FLAGPTRH,TEMP1
          STA     TEMP1
          STY     TEMP2
          LDA     #CLRSTMP
          LDY     #$00
          STA     (TEMP0),Y
          LDY     TEMP2

ZE1       RTS

***********
SWITCHP
***********
* Swap vars for the players

          LDA     PLAYER
          EOR     #$01
          STA     PLAYER
          CMP     #$00
          BNE     ONETOTWO
TWOTOONE
          LDA     #$17                   ;WHITE SCORE
          STA     SCORELST+3
          LDA     #$37
          BNE     ZSCOREOK               ;JMP...
ONETOTWO
          LDA     #$37
          STA     SCORELST+3
          LDA     #$17                   ;WHITE SCORE
ZSCOREOK  STA     SCORELST+$D
          LDX     #NMPLVARS
EXSTUFF
          LDA     PSCOR1-1,X
          PHA
          LDA     OTHERSTF-1,X
          STA     PSCOR1-1,X
          PLA
          STA     OTHERSTF-1,X
          DEX
          BNE     EXSTUFF
          RTS

CXPOS     DB      0,0,1,1,1,0,-2,-2,-2
CYPOS     DB      0,2,2,0,-2,-2,-2,0,2
SLOPXPOS  DB      0,0,$7F,$7F,$7F,0,$81,$81,$81
*SLOPYPOS  DB      0,0,0,0,$00,$00,$00,0,0
BOTSOLV
          END
