********************************************************************************
***********                                                          ***********
***********       DDMOVE:  CONTROLS ENTRY MODE IF DIGDUG IS          ***********
***********                JUST WALKING OUT ON SCREEN, AND           ***********
***********                HANDLES MOVING DIGDUG AND DIGGING         ***********
***********                TUNNELS OTHERWISE.  ALSO CHECKS FOR       ***********
***********                EXISTENCE OF ROCKS SO DIGDUG WON'T        ***********
***********                RUN INTO THEM, AND SETS FALLING ROCK      ***********
***********                FLAG WHEN DIRT UNDER A ROCK GOES AWAY.    ***********
***********                                                          ***********
********************************************************************************


DHFASTL   EQU     $D5                    ;DD HOR SPEED FAST LOW BYTE
DHFASTH   EQU     $AA                    ;DD HOR SPEED FAST HIGH BYTE
DHSLOWL   EQU     $52                    ;DD HOR SPEED SLOW LOW BYTE
DHSLOWH   EQU     $52                    ;DD HOR SPEED SLOW HIGH BYTE

DIGSLOW   EQU     $5B                    DIGDUG SLOW    5 BITS
;         FOR 16 BIT VERSION      DIGSLOW = $5B $5B     10 BITS
DIGFAST   EQU     $F7                    DUGDUG FAST    7 BITS
;         FOR 16 BIT VERSION      DIGFAST = $7F $7F     14 BITS



DDMOVE
          LDA     #H(SOUTH7)             ;ASSUME ALL ARRAYS ON SAME PAGE.
          STA     DRTPTR+1

          LDA     DIGGING
          STA     DIGTEMP

          LDA     ATTRACT
          BEQ     CHKENTR

          LDA     SQUASH
          BNE     NOGO

          LDX     LASTMOVE
          LDA     DIGREST                ;DIGDUG MOVING?
          BNE     ATNEWDIR
          LDA     ASTAGE                 ;STILL WALKING IN SAME DIRECTION?
          BEQ     ATNEWDIR
          DEC     ASTAGE
          LDA     JOYSWCH,X              ; E,W,S,N   -    7F,BF,DF,EF
          BNE     GPREZJOY               ; CONTINUE IN OLD DIR
ATNEWDIR  JSR     RANDOM
          AND     #$03
          ADC     #$00
          STA     ASTAGE                 ;NEW COUNTDOWN
DOATDIR   AND     #$03
          TAY
          LDA     JOYSWCH,Y
          CMP     REVSWCH,X
          BNE     GPREZJOY
          INY                            ;TRY NOT TO REVERSE
          TYA
          BPL     DOATDIR

*         LDY     ASTAGE                 ;WE'RE IN ATTRACT MODE: USE ATTRACT
*         LDA     ATTDIREC,Y             ;  MODE TABLE MOVEMENTS INSTEAD OF
*         BPL     AHORIZ                 ;  READING JOYSTICK.
*         ASL     A
*         BPL     AHORIZ
*         LDA     DDYPOS                 ;UP OR DOWN: CHECK Y POSITION.
*         BNE     CHKBOUND
*AHORIZ    LDA     DDXPOS                 ;LEFT OR RIGHT: CHECK X POSITION.
*CHKBOUND  CMP     ATTBOUND,Y
*         BNE     GOTDIREC
***B      CPY     #15                    ;DIGDUG NOT DEAD YET: RECYCLE DIREC'S.
***B      BCC     NEWDIREC
***B      LDY     #3
*NEWDIREC  INY                            ;TURN TO NEW DIRECTION.
*         STY     ASTAGE
*GOTDIREC                                 ;EVENTUALLY, PUMP CHECK WILL GO HERE.
*         LDA     ATTDIREC,Y
*         BNE     GPREZJOY

CHKENTR   LDA     ENTRY                  ;ARE WE IN ENTRY MODE?
          BEQ     JOYMOVE

          LDA     DDXPOS
          CMP     #DDSTRTX
          BNE     NOENTRY
          LDY     #0
          STY     NONOISE
          LDY     #SNG15
          JSR     NOISE

NOENTRY   LDA     DDYPOS                 ;HAS DIGDUG STARTED DOWN YET?
          CMP     #DDSTRTY
          BNE     DOWNDD
          LDA     #$BF                   ;MOVE DIGDUG LEFT.
          LDX     DDXPOS
          CPX     #DDMIDLX               ;ARE WE FAR ENOUGH LEFT YET?
GPREZJOY  BNE     PREZJOY

DOWNDD    CMP     #DDMIDLY               ;ALL THE WAY DOWN?
          BNE     WDOWN
          LDA     #RDIGDUG2
          STA     DDINDX
          LDA     #40
          JSR     GENFREEZ
          LDA     #0
          STA     ENTRY
*         STA     LASTMOVE               ;FAKE LAST DIRECTION
*         STA     NOTGRID
*         LDA     #$B5
*         STA     PROPORT
*         JMP     SETDFAST
*         RTS
          JMP     DOSTART                ;DOSTART IS A SUBR
WDOWN     LDA     #$DF
          BNE     PREZJOY

****MOVEDONE  RTS

*FOO       DB      $7F,$DF,$BF,$EF,$7F    ; E,S,W,N,E  (IN ARRAYS.S)
*BAR       DB      $20,$40,$10,$90        ; S,W,N,NE

NOGO      LDA     WALKING
          BEQ     NOGO2
          DEC     WALKING                ;DIGDUG CAN'T OR WON'T MOVE
NOGO2     RTS

JOYMOVE
*         LDA     WALKING
*         STA     DTEMP1                 ;SAVE FOR LATER...
          LDA     SQUASH
          ORA     FREEZE
          BNE     NOGO
          LDA     SWCHA                  ;READ JOYSTICK...

          LDX     PLAYNUM
          BEQ     JOYMOVE0

*         LDX     ALIEN                  ;IF THERE IS ONLY ONE JOYSTICK,
*         BEQ     JOYMOVE0               ; USE PLAYER 0 INPUT FOR PLAYER 1.

          ASL     A                      ;FETCH SECOND USER'S INPUT
          ASL     A
          ASL     A
          ASL     A

JOYMOVE0  ORA     #$0F
          CMP     #$FF
          BEQ     JOYMOVE1
          LDX     #$0A                   ;TWEAKABLE; <8 STOPS DD SONG REVERSING
          STX     WALKING

          LDX     #6
          TAY
FOOLOOP   AND     BAR-1,X
          BEQ     FOODONE
          TYA
          DEX
          BNE     FOOLOOP
FOODONE   LDA     FOO,X

;*        AND     #$10                   ; N?
;*        BEQ     FOODONE
;*        DEX
;*        TYA
;*        AND     #$40                   ; W?
;*        BEQ     FOODONE
;*        DEX
;*        TYA
;*        AND     #$20                   ; S?
;*        BEQ     FOODONE
;*        DEX                            ; MUST BE EAST
*FOODONE   LDA     FOO,X

;;;       STA     TEMP+10                ;JOYSTICK REQUEST
;;;       LDX     LASTMOVE
;;;       LDA     JOYSWCH,X
;;;       EOR     #$FF                   ;RESULT IS BIT SET WHERE DD LAST MOVED
;;;       BIT     TEMP+10
;;;       BNE     NEWDIR                 ;OLDDIR AMONG DIRS REQUESTED?

;;;       ORA     TEMP+10                ; !!!!! USE NEWDIR
;;;       CMP     #$FF                   ; !!!!! USE NEWDIR

*         LDA     JOYSWCH,X              ; !!!!! USE OLDDIR

;;;       BNE     JOYMOVE1
;;;NEWDIR    LDY     #3
;;;SWCHLOOP  LDA     TEMP+10                ;JOYSTICK REQUEST
;;;       CMP     JOYSWCH,Y
;;;       BEQ     JOYMOVE1               ;IF ONE BIT IS LOW, USE IT
;;;       DEY
;;;       BPL     SWCHLOOP
;;;       ORA     AREVSWCH,X             ;IF TWO BITS ARE LOW, MOVE 90 DEGREES

*         LDA     REVSWCH,X              ;IF TWO BITS ARE LOW, MOVE IN REVERSE

JOYMOVE1

PREZJOY   INC     DIGREST                ;GETS CLEARED IF DD TRIES TO MOVE
ZJOY      LDX     LASTMOVE
          LDY     #0
          ASL     A
          BCC     GOMDDE
ZJOY0     INY
          ASL     A
GOMDDE    BCC     MDDE
ZJOY1     INY
          ASL     A
          BCC     MDDN
          INY
          ASL     A
          BCS     NOGO
MDDN
          LDA     DDXPOS                 ;COLUMN BORDER?
          AND     #$07
          BEQ     COLBORDN
          LDA     JOYSWCH,X              ;TRY PREVIOUS DIRECTION
          BNE     ZJOY

COLBORDN  LDA     JOYSWCH,X
          ASL     DIGSPEED               ;TIME TO MOVE?
          BCS     NTIME
          CMP     REVSWCH,Y              ;ALWAYS MOVE IF REVERSING
          BNE     NOTREST
          BEQ     NREV
*         CMP     JOYSWCH,Y              ;ALWAYS MOVE IF DIFF DIRECTION
*         BEQ     NOTREST
NTIME     INC     DIGSPEED
NREV      STY     LASTMOVE
          CMP     JOYSWCH,Y              ;TUNNEL SPEED AND NO HARPOON
          BEQ     STILLN                 ; IF CHANGING DIRECTION
          LDA     #0
          STA     DIGTEMP
          BEQ     DOANIMN
STILLN    ASL     PROPORT3               ;TIME TO DO VERT ANIMATION?
          BCC     RUBN
          INC     PROPORT3
DOANIMN   JSR     ANIM                   ;UPDATE STAMP INDEX

RUBN      JSR     CHKROCK                ;AGAINST ROCK?
          BMI     RUBN3
          CPY     #2                     ;MOVING SOUTH?
          BNE     RUBN2
          LDA     TUMBLE,X
          CMP     #7                     ;DD CAN MOVE SOUTH THROUGH CRUMBLE
          BCS     RUBN3
RUBN2     LDA     #0
          STA     DIGTEMP
          JMP     FINMOV1

RUBN3     LDX     DDYPOS

          TYA
          LSR     A
          BCC     DIGS                   ;DIG SOUTH
          INX
          CPX     TOPZONE+15             ;AT UPPERMOST LIMIT?
          BCC     NOTTOP
          LDA     DANIMS+0               ;FACE RIGHT
          STA     DDINDX
          LDA     #191
          STA     DDYPOS
          LDY     #0                     ;FAKE LAST DIRECTION
          STY     LASTMOVE
          RTS

DIGS      CPX     #23
          BEQ     RUBN2
          DEX

NOTTOP    STX     DDYPOS                 ;STORE NEW VERT VALUE
          TXA                            ;NEW VERT VALUE
          SEC
GETNOFST  SBC     #12
          CMP     #12
          BCS     GETNOFST

          JMP     FINVERT


MDDE
          JSR     ROWHERE                ;ROW BORDER?
          BEQ     ROWBORDE
          LDX     LASTMOVE
          LDA     JOYSWCH,X              ;TRY PREVIOUS DIRECTION
          JMP     ZJOY

NOTREST   LDA     #0
          STA     DIGREST
GLVDIRTN  RTS

ROWBORDE  LDX     LASTMOVE
          LDA     JOYSWCH,X
          ASL     DHORSPDL               ;ALRIGHT TO MOVE HORIZONTALLY?
          ROL     DHORSPDH
          BCS     ETIME
          CMP     REVSWCH,Y              ;ALWAYS MOVE IF REVERSING
          BNE     NOTREST
          BEQ     EREV
*         CMP     JOYSWCH,Y              ;ALWAYS MOVE IF DIFF DIRECTION
*         BEQ     NOTREST
ETIME     INC     DHORSPDL
EREV      STY     LASTMOVE
          CMP     JOYSWCH,Y              ;TUNNEL SPEED AND NO HARPOON
          BEQ     STILLE                 ; IF CHANGING DIRECTION
          LDA     #0
          STA     DIGTEMP
STILLE    JSR     ANIM                   ;UPDATE STAMP INDEX

          JSR     CHKROCK                ;AGAINST ROCK?
          BPL     RUBN2

          LDX     DDXPOS

          TYA
          LSR     A
          BCS     DIGW                   ;DIG WEST

          CPX     #112
          BEQ     RUBN2
          INX
          BNE     NOTSID

DIGW      CPX     #8
          BEQ     RUBN2
          DEX

NOTSID    STX     DDXPOS                 ;STORE NEW HOR VALUE
          TXA
          AND     #$F8
          STA     TEMP
          LDA     DDXPOS
          SEC
          SBC     TEMP

FINVERT   LDX     #1
          STX     NOTGRID
          JSR     DIGDISP
          JMP     FINMOV


DIGDISP   CMP     VPRE1,Y
          BEQ     VANHARP
          CMP     VPRE2,Y
          BEQ     VANHARP
          CMP     VPRE3,Y
          BNE     DIGONE
VANHARP   LDA     #12
          JMP     CHKNXTD                ;CHKNXTD IS A SUBR

DIGONE    CMP     VONE,Y
          BNE     GETN1                  ; 1 IN

          LDA     FROMXFM,Y
          STA     DRTPTR
          LDA     DDYPOS                 ;FROM
          CLC
          ADC     YFROMPL,Y
          TAX
          LDA     DDXPOS
          CLC
          ADC     XFROMPL,Y

          JSR     CALCINDX
          CMP     #36
          BCS     DIGONE2
          JSR     BORE1                  ;FOUND IN FALL FILE
DIGONE2                                  ;TO
          LDA     #0
          STA     DIGTEMP
          LDY     LASTMOVE
          LDA     ENTRXFM,Y
          STA     DRTPTR
          JSR     ADJUSTTO
          JSR     CALCINDX
          CMP     #36
          BCS     DIGONE3
          PHA
          LDA     TOXFM,Y
          STA     DRTPTR
          PLA
          JMP     BORE1                  ;FOUND IN FALL FILE  (BORE1 IS A SUBR)
DIGONE3
          JMP     DIGGER                 ;DIGGER IS A SUBR

GETN1     CMP     VHALF,Y
          BNE     GETN2                  ; 1 PAST HALFWAY IN

DIGHALF
          LDA     #0
          STA     DIGTEMP
          LDA     HALFXFM,Y
          STA     DRTPTR
          JSR     ADJUSTTO               ;TAKE LEADING EDGE
          JSR     CALCINDX               ;CALC DIRCHAR
          CMP     #36
          BCC     GETN3
          JMP     DIGGER                 ;DIGGER IS A SUBR

GETN2     CMP     VBOUND,Y
          BNE     GETN3

DIGBOUND  JSR     ROWHERE
          BNE     DIGBND2
          LDA     DDXPOS
          AND     #7
          BNE     DIGBND2
          LDA     #4
          JSR     CHKNXTD
          BCS     DIGBND2
          STA     NOTGRID                ;WHEN CARRY CLR, CHKNXTD SET A TO BE 0
DIGBND2
GETN3     RTS

BETTY     LDA     LASTMOVE
          ORA     #$0C
          TAY
          JSR     CHKROCK                ;DIGDUG ONE PIXEL INTO SQUARE
          BMI     FINMOV1                ;   UNDER ROCK?
          LDA     TUMBLE,X               ;ROCK NOT ALREADY FALLING?
          BNE     FINMOV1
          STX     TEMP+10                ;SAVE ROCK INDEX
          JSR     ROCKPUSH               ;SQUARE UNDER ROCK HAS HOLLOW CENTER?
          LDX     TEMP+10                ;RESTORE ROCK INDEX
          CMP     #36
          BCS     FINMOV1
          BCC     CHKFALL1               ;ROCK SHOULD FALL WHEN DD REVERSES

FINMOV                                   ;DO THIS STUFF ONLY IF DIGDUG MOVES

          LDA     #0
          STA     DIGREST
          LDY     NEEDDIR                ; DIGDUG HOLDING UP ROCK?
          BEQ     CHKFALL
          BMI     STRTFALL               ; FF MEANS ANY MOVE WILL CAUSE FALL
          DEY                            ; TRUE DIRECTION NEEDED
          CPY     LASTMOVE               ; WILL CURRENT DIR CAUSE FALL?
          BNE     CHKFALL
STRTFALL  LDX     HITROCK
          LDA     #ONEDGE
          STA     TUMBLE,X
          LDA     #0
          STA     NEEDDIR

CHKFALL   LDA     LASTMOVE
          ORA     #$04
          TAY
          JSR     CHKROCK
          BPL     CHKFALL1
          LDY     #3
          JSR     CHKROCK                ;UNDER ROCK?
          BMI     BETTY
          LDA     #$FF
          BMI     CHKFALL2
CHKFALL1  LDY     LASTMOVE
          LDA     CVTDIR,Y
CHKFALL2  LDY     TUMBLE,X               ;IGNORE ROCK ALREADY FALLING
          BNE     FINMOV1
          STA     NEEDDIR
          STX     HITROCK


FINMOV1   LDY     LASTMOVE               ;DO THIS IF DIGTEMP CHANGED
          LDA     DIGTEMP
          CMP     DIGGING                ;CHANGE IN SPEED REQUESTED?
          BEQ     FINMOV4
          STA     DIGGING
          TAX
          BEQ     FINMOV2
          LDX     #DHSLOWL
          STX     DHORSPDL
          LDX     #DHSLOWH
          STX     DHORSPDH
          LDX     #DIGSLOW
          STX     DIGSPEED
FINMOV4   TAX
          BEQ     FINMOV3
          JMP     HARP                   ;HARP IS A SUBR
FINMOV2   JSR     SETDFAST
FINMOV3   JSR     VANPUMP                ;RETURNS  0 IN A
FINMOV5   STA     PUMPY
LEAVDIRT  RTS

HARP      LDY     LASTMOVE
          LDA     HARPSTMP,Y
          STA     PUMPIX
          LDA     DDXPOS
          CLC
          ADC     HARPXPL,Y
          STA     PUMPX
          LDA     DDYPOS
          CLC
          ADC     HARPYPL,Y
          CMP     #MINDDY
          BCC     FINMOV3
          BCS     FINMOV5

;  USES X AND A.
;  IF WAY CLEAR, RETURNS MINUS.
;  IF WAY BLOCKED, RETURNS PLUS AND ROCK INDEX IN X.
CHKROCK   LDA     DDXPOS                 ;ADJUST FOR DIRECTION
          CLC
          ADC     XTOPL+4,Y
          STA     TEMP+7
          LDA     DDYPOS
          CLC
          ADC     YTOPL+4,Y
          STA     TEMP+1
          LDX     #4

ROCKER    LDA     TEMP+7                 ;HOR COORDINATES MATCH?
          CMP     ROCKSX,X
          BNE     NROCKY

          LDA     ROCKSIX,X              ;IGNORE ROCK AS SCORE
          CMP     #LOWSCOR
          BCS     NROCKY

          LDA     TEMP+1                 ;VERT COORDINATES MATCH?
          CMP     ROCKSY,X
          BEQ     BLOCKED
;
;  LET'S RECONSIDER....
;
          LDA     TUMBLE,X               ;FALLING?
          BEQ     NROCKY
          LDA     LASTMOVE               ;DIGDUG MOVING HORIZONTALLY?
          AND     #$02
          BNE     NROCKY
          LDA     ROCKSY,X               ;ROCK OVERLAPS DIGDUG VERTICALLY?
          CLC
*         ADC     #6                     ;TWEAK??
          ADC     #7
*         SEC
          SBC     TEMP+1
          BCC     NROCKY
          CMP     #17
          BCS     NROCKY
          LDA     DDYPOS
          CMP     #23                    ;DIGDUG ON BOTTOM ROW?
          BEQ     BLOCKED
          STX     TEMP+9                 ;SAVE X
          LDA     DDYPOS
          SEC
          SBC     #12
          TAX                            ;WHAT KIND OF DIRT CHAR IS BELOW ROCK?
          LDA     TEMP+7
          JSR     CALCINDX
          LDX     TEMP+9                 ;RESTORE X
          CMP     #36                    ;SOLID
          BEQ     BLOCKED
          CMP     #44                    ;CUP
          BNE     NROCKY
BLOCKED   LDA     #$00                   ;ROCK FOUND
          RTS
NROCKY    DEX
          BPL     ROCKER
ENDEAT    RTS

EATVEG    LDA     FSCORE                 ;FRUIT SCORE PRESENT?
          BEQ     EATVEG1
          DEC     FSCORCTR
          BNE     ENDEAT
          LDA     #0
          STA     FSCORE
          STA     FRUITY                 ;STOP DISPLAYING SCORE
EATVEG1   LDA     FRUIT                  ;FRUIT PRESENT?
          CMP     #$0F
          BCC     ENDEAT
          LDA     DDYPOS                 ;DIGDUG ON TOP OF FRUIT?
          CMP     #$6B
          BNE     ENDEAT
          LDA     DDXPOS
          CMP     #$38
          BNE     ENDEAT
          LDX     #$01                   ;POINTS DISPLAYING FLAG
          STX     FSCORE
          DEX
          STX     FRUIT                  ;FRUIT DONE
          LDA     #$30                   ;SET SCORE DISPLAY TIMER
          STA     FSCORCTR
          LDA     BONZO                  ;BONZO?
          BNE     EATVEG2                ;ASSUME X IS 0
          LDY     PLAYNUM
          LDX     RACKNUM,Y              ;CALC CORRECT POINT VALUE
          CPX     #19
          BCC     EATVEG2
          LDX     #18                    ;RACKS ABOVE 18 ARE ALL PINEAPPLES
EATVEG2   LDA     FPOINTS,X              ;DISPLAY POINTS
          STA     FRUITIX
          LSR     A
          TAY
          LDA     STMPPALW,Y
          STA     FRUITPAL
          LDY     VEGPTS,X               ;FETCH MID BYTE
          LDA     #53
          STA     FRUITX
          LDA     #0                     ;LOW BYTE ALWAYS 0
          JSR     ADDSCORE
          LDA     #CSET2
          STA     FRUITCST
          LDY     #SNG10                 ;GOT FRUIT
          JMP     NOISE                  ;NOISE IS A SUBR



