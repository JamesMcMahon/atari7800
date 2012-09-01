;-------- COLLISION DETECTION ROUTINE
;         BETWEEN DIGDUG AND MONSTERS

COLLISON  LDA     SQUASH
          BNE     ENDCOLL
          LDX     #$07
PREV23    LDA     MONSTAT,X
          CMP     #2                     ;ALLOW TOUCH OF FLAMING FYGAR TO KILL
          BCS     ZNXTCOLL
XCOLL     LDA     DDXPOS
          SEC
          SBC     XPOS,X
          BCS     ZNXT97
          EOR     #$FF                   2'S COMPLEMENT   (DOES NOT AFFECT C)
          ADC     #$01
ZNXT97    CMP     #$05
*         BCC     YCOLL
          BCS     ZNXTCOLL               SAME AS JMP
YCOLL     LDA     DDYPOS
          SEC
          SBC     YPOS,X
          BCS     ZNXT96
          EOR     #$FF                   2'S COMPLEMENT   (DOES NOT AFFECT C)
          ADC     #$01
ZNXT96    CMP     #$07
*         BCC     YESCOLL
          BCS     ZNXTCOLL               SAME AS JMP
YESCOLL   LDA     #$01                   MONSTER AND DIGDUG COLLIDE!!!
          STA     DETHWISH
          LDY     LASTMOVE
          LDX     DANIMIX,Y
          LDA     ADEATH,X
          STA     DDINDX
          JSR     VANPUMP                ;STOP DISPLAYING PUMP
          LDY     #SNG8                  GOTCHA NOISE
          JMP     NOISE                  ;NOISE IS A SUBR
ZNXTCOLL  DEX
          BPL     PREV23
ENDCOLL   RTS


;-------- COLLISION DETECT ROUTINE
;         BETWEEN DIGDUG AND FLAME


FLAMCOLL  LDA     SQUASH
          BNE     ENDCOLL
          LDA     FLAMEX
          SEC
          SBC     #$07
          SEC
          SBC     DDXPOS
          BCS     ENDCOLL
          EOR     #$FF                   ;DOES NOT AFFECT C
*         CLC
          ADC     #$03                   SINCE FLAMNUM IS INCREMENTED BY ONE
          LSR     A
          LSR     A
          LSR     A
          CMP     FLAMNUM
          BCS     ENDCOLL
          LDA     DDYPOS
          SEC
          SBC     FLAMEY
          BCS     ZNXT94
          EOR     #$FF                   2'S COMPLEMENT  (DOESN'T AFFECT C)
          ADC     #$01
ZNXT94    CMP     #$0A
          BCS     ENDCOLL
          LDA     #$00
          STA     MONSTAT,X
          STA     FLAMIE
          BEQ     YESCOLL
*         LDA     #$01                   FLAME AND DIGDUG COLLIDE!!!
*         STA     DETHWISH
*         LDY     #SNG8
*         JSR     NOISE
*         RTS


;-------- PUMPING CODE
;-------- PUMPING STATE MACHINE

;---- BUTTON INPUT ROUTINE MOVED TO INITDIRT


PUMPER    JSR     INPUT
          LDA     PUMPCT
          BEQ     PUMPER2
          DEC     PUMPCT
          BNE     PUMPER2
          LDY     PUMPIE
          BMI     PUMPER2
          STA     PUMPING                HERE A = 1
          STA     PUMPCNT
PUMPER2   LDY     PUMPNUM
          BEQ     NOPUMP
          BPL     EXTEND
PUMPWAIT  LDX     PUMPIE
          BMI     ZNXT102
          LDA     MONSTAT,X
          BMI     ZNXT102                IF DISABLED BIT SET
          ASL     A
          BMI     ZNXT102                IF SQUASHED BIT SET
          AND     #$08
          BEQ     ZNXT102                IF GBNF BIT IS SET
          LDA     PUMPCNT
          BNE     VANEND
*         LDA     #$00
          STA     FREEZE
          LDA     WALKING
          BEQ     VANEND
ZNXT102   LDA     #$00                   IF WHILE WAITING SOMETHING HAPPENS
          STA     FREEZE
          STA     PUMPNUM                -THEN TURN OFF THE PUMP
VANPUMP   LDA     #$FF
          STA     PUMPIE
          LDA     #0                     ;CALLED FROM BLOWUP AND FALL
          STA     PUMPY
          STA     PUMPY+1
          STA     PUMPY+2
VANEND    RTS

NOPUMP    LDA     DIGGING
          BNE     VANEND
          LDA     SQUASH
          BNE     VANEND
          LDA     PUMP
          BEQ     VANEND
          LDA     #$01                   THE VALUE TO FREEZE DIGDUG
          STA     FREEZE                 THE DIGDUG STATUS REGESTER
          LDY     #SNG5                  THROWN HARPOON
          JSR     NOISE
          JSR     GETMAXP
          JMP     EXTEND2
EXTEND    LDA     MAXPUMP
          CMP     #1
          BEQ     ZNXT102
EXTEND2   JSR     DISPPUMP
          JSR     PUMPCOLL
          BNE     ZNXT104
          LDA     PUMPNUM
          INC     PUMPNUM
          CMP     MAXPUMP
          BNE     EXTEND3
          LDA     MAXPUMP
          CMP     #1
          BNE     ZNXT102
EXTEND3   RTS
ZNXT104   LDA     #$FF
          STA     PUMPNUM
          RTS

DISPPUMP  LDA     LASTMOVE
          ROR     A
          ROR     A
          BCS     NORTSOUT
          PHP
          LDA     PUMPNUM                SETUP PUMP XPOS
          ROR     A                      -FOR THE WIDE PUMP
          LDA     #$00
          ROL     A
          ASL     A
          STA     TEMP1
          PLP
          BMI     WEST
EAST      LDA     DDXPOS
          CLC
          ADC     TEMP1
          ADC     #$06
          STA     PUMPX
          LDA     DDYPOS
          STA     PUMPY
          LDA     PUMPNUM                SETUP THE INDEX FOR PUMP
          LSR     A
          TAY
          LDA     PRITES0,Y              -FROM PRITES# TABLES
          BNE     WESTA                  ;USE AS JMP
WEST      LDA     PUMPNUM                SETUP THE INDEX FOR PUMP
          LSR     A
          STA     TEMP2
          ASL     A
          ASL     A
          STA     TEMP3
          LDA     DDXPOS
          SEC
          SBC     TEMP1
          SBC     #$02
          SBC     TEMP3
          STA     PUMPX
          LDA     DDYPOS
          STA     PUMPY
          LDY     TEMP2
          LDA     PLEFTS0,Y              -FROM PRITES# TABLES
WESTA     STA     PUMPIX
          LDA     ZBLANK
          STA     PUMPIX+1
          LDA     ZBLANK
          STA     PUMPIX+2
          RTS
NORTSOUT  BPL     SOUTH
NORTH     LDA     PUMPNUM                SETUP THE INDEX FOR PUMP
          LSR     A
          STA     TEMP2

          LDY     TEMP2
          LDA     PUPS0,Y                -FROM PRITES# TABLES
          STA     PUMPIX
          LDA     PUPS1,Y
          STA     PUMPIX+1
          LDA     PUPS2,Y
          STA     PUMPIX+2

          LDA     PUMPNUM
          ASL     A
          CLC
          ADC     PUMPNUM
          ADC     DDYPOS
          ADC     #$03
          CMP     #192                   DECIMAL
          BCC     ZNXT166
          LDA     #191                   DECIMAL
ZNXT166   JMP     SUB4                   ;SUB4 IS A SUBR
SOUTH     LDA     PUMPNUM                SETUP PUMP XPOS
*         ROR     A                      -FOR THE WIDE PUMP
*         LDA     #$00
*         ROL     A
          AND     #$01                   ;WITH THANKS TO TOM CALDERWOOD
          STA     TEMP1
          CLC
          ADC     TEMP1
          ADC     TEMP1
          STA     TEMP1

          LDA     PUMPNUM                SETUP THE INDEX FOR PUMP
          LSR     A
          TAY
          LDA     PDOWNS0,Y                -FROM PRITES# TABLES
          STA     PUMPIX
          LDA     PDOWNS1,Y
          STA     PUMPIX+1
          LDA     PDOWNS2,Y
          STA     PUMPIX+2

          LDA     DDYPOS
          SEC
          SBC     TEMP1
          SBC     #$09

          LDY     PUMPIX
          CPY     #DPUMP6
          BNE     SOUTHA
*         CLC                            ; CARRY IS SET
          ADC     #6-1

SOUTHA    CMP     #23                    DECIMAL
          BCS     ZNXT156
          LDA     #23                    DECIMAL
ZNXT156   JMP     SUB4                   ;SUB4 IS A SUBR

PUMPCOLL  LDA     LASTMOVE
          ROR     A
          ROR     A
          BCS     PUPDOWN
          BMI     PLEFT
PRIGHT    LDA     PUMPNUM
          ASL     A
          CLC
          ADC     DDXPOS
          ADC     #$01                   IN CONNECTION WITH WIDTH OF COLL
          JMP     PLEFT2
PLEFT     LDA     PUMPX
          SEC
          SBC     #$05                   IN COLL
PLEFT2    STA     TEMP1
          LDA     PUMPY
          SEC
          SBC     #$04
          STA     TEMP2
          JMP     PCOLL
PUPDOWN   BPL     PDOWN
PUP       LDA     PUMPY
          JMP     PDOWN2
PDOWN     LDA     PUMPNUM
          ASL     A
          CLC
          ADC     PUMPNUM
          STA     TEMP1
          LDA     DDYPOS
          SEC
          SBC     TEMP1
          SEC
          SBC     #$09                   IN COLL
PDOWN2    STA     TEMP2
          LDA     PUMPX
          SEC
          SBC     #$05                   IN COLL
          STA     TEMP1
*         JMP     PCOLL
PCOLL     LDX     #$07
PREV39    LDA     MONSTAT,X
          BMI     ENDPCOLL
          ASL     A
          BMI     ENDPCOLL
          AND     #$0C
          CMP     #$04                   WHEN (NOT GBNF) & (BLOWUP)
          BEQ     ENDPCOLL
          LDA     XPOS,X
          SEC
          SBC     TEMP1
          BCC     ENDPCOLL
          CMP     #$06                   WIDTH OF PUMP COLLISION
          BCS     ENDPCOLL
          LDA     MONSTAT,X
          AND     #$02
          BEQ     PCOLL1
          LDA     BLWYPOS,X
          BNE     PCOLL2
PCOLL1    LDA     YPOS,X
PCOLL2    SEC
          SBC     TEMP2
          BCC     ENDPCOLL
          CMP     #$08                   HEIGHT OF PUMP COLLISION
          BCS     ENDPCOLL
          STX     PUMPIE
          CPX     FLAMIE
          BNE     ZNXT107
          JSR     FLAMOUT4               ;SETS FLAMEY+FLAMIE+MONSTAT,X TO 0
*         LDA     #0                     ;FOUND IN FLAMER
*         STA     FLAMEY
*         STA     FLAMIE
ZNXT107   LDA     #$07                   SET GBNF, BLOWUP AND FREEZE FLAGS
          STA     MONSTAT,X
          LDA     #$01
          STA     PUMPING
          RTS                            SO THAT ONLY ONE MONSTER IS AFFECTED
ENDPCOLL  DEX
          BPL     PREV39
          LDA     PUMPING
          RTS



GETMAXP   LDX     #$0E
          LDA     #$00
          STA     MAXPUMP
          LDA     DDXPOS
          STA     PUMPX
          LDA     DDYPOS
          STA     PUMPY
          JSR     GETDIRT
          LDX     #$02
          LDA     LASTMOVE
          ROR     A
          ROR     A
          BCS     PDNS
          BMI     PDW
PDE
          LDA     NOTGRID
          BNE     PDELOOP
          JSR     MOREPUMP
PDELOOP   INY
          JSR     LOOKDIRT
          AND     #$02
          BNE     ENDPDE
          JSR     MOREPUMP
          DEX
          BPL     PDELOOP
ENDPDE    LDA     DDXPOS
          AND     #$07
          BEQ     ENDPDE2
          SEC
          SBC     #1
          LSR     A
          EOR     #$03
ENDPDE2   BPL     SUB2                   ;SUB2 IS A SUBR
PDW       LDA     NOTGRID
          BEQ     PDW1
PDWLOOP   JSR     LOOKDIRT
          AND     #$08
          BNE     ENDPDW
PDW1      JSR     MOREPUMP
          DEY                            ;NOTE - Y GETS DECREMENTED ONE TOO
          DEX                            ; MANY TIMES BUT IT SHOULDN'T MATTER
          BPL     PDWLOOP
ENDPDW    LDA     DDXPOS
          AND     #$07
          LSR     A
          BPL     SUB2                   ;SUB2 IS A SUBR
PDNS      BPL     PDS
PDN
          LDA     NOTGRID
          BNE     PDNLOOP
          JSR     MOREPUMP
PDNLOOP   TYA
          SEC
          SBC     #$10
          TAY
          JSR     LOOKDIRT
          AND     #$01
          BNE     ENDPDN
          JSR     MOREPUMP
          DEX
          BPL     PDNLOOP
ENDPDN    JSR     SUB3                   ;0 1 2 3 4 5 6 7 8 9 A B -->--->
          TAY                            ;0 3 3 3 2 2 2 1 1 1 0 0
          BEQ     ENDPDN2
          SBC     #$0D
          EOR     #$FF
          TAY
ENDPDN2   LDA     DIV3TAB,Y
          BPL     SUB2                   ;SUB2 IS A SUBR
PDS       LDA     NOTGRID
          BEQ     PDS1
PDSLOOP   JSR     LOOKDIRT
          AND     #$04
          BNE     ENDPDS
PDS1      JSR     MOREPUMP
          TYA                            ;NOTE - Y GETS CHANGED ONE TOO MANY
          CLC                            ; TIMES BUT IT SHOULDN'T MATTER
          ADC     #$10
          TAY
          DEX
          BPL     PDSLOOP
ENDPDS    JSR     SUB3
          TAY
          LDA     DIV3TAB,Y
          BPL     SUB2                   ;SUB2 IS A SUBR

** MOVED TO ARRAYS:
*LOOKDIRT  LDA     DIRTMAP,Y
*         CMP     #CHARD12
*         BCS     ENDLOOK
*         CMP     #CHARDF
*         BCC     ZNXT120
*         LDA     #$01                   SKY CHARACTER
*         RTS
*ZNXT120   LSR     A
*         RTS
*ENDLOOK   LDA     #$0F
*         RTS
*MOREPUMP  LDA     MAXPUMP
*         CLC
*         ADC     #$04
*         STA     MAXPUMP
*         RTS




;-------- SUBROUTINES (AND JUMPS)

SUB2      CLC                            THIS IS A JUMP TO . . .
          ADC     MAXPUMP
          CMP     #$0C
          BCC     ENDDPDE
          LDA     #$0B
ENDDPDE   STA     MAXPUMP
          RTS

DISNEY    SEC
          SBC     #$0C
          BCC     DISNEY1
          CMP     #23
          BCS     DISNEY2
DISNEY1   LDA     #23
DISNEY2   RTS

SUB4      STA     PUMPY

          LDY     #DPUMP6
          CPY     PUMPIX+1
          BNE     SUB4A
          CLC
          ADC     #6

SUB4A     JSR     DISNEY
*         SEC
*         SBC     #$0C
*         BCC     ZNXT168
*         CMP     #23                    DECIMAL
*         BCS     ZNXT167
*ZNXT168   LDA     #23                    DECIMAL
*ZNXT167
          STA     PUMPY+1

          CPY     PUMPIX+2
          BNE     SUB4B
          CLC
          ADC     #6

SUB4B     JSR     DISNEY
*         SEC
*         SBC     #$0C
*         BCC     ZNXT169
*         CMP     #23                    DECIMAL
*         BCS     ZNXT170
*ZNXT169   LDA     #23                    DECIMAL
*ZNXT170
          STA     PUMPY+2
          LDA     DDXPOS
          CLC
          ADC     #$02
          STA     PUMPX
          STA     PUMPX+1
          STA     PUMPX+2
          RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                    ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;    BLOWUP:  CALLED FROM MAIN.                      ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;             INFLATES AND DEFLATES CREATURES.       ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;             POPS CREATURES,DISPLAYS POINTS.        ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;             UPDATES SCORE.                         ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                    ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


SETDEFL   EQU     $20                    ;RATE OF DEFLATION



BLOWUP    LDX     #NUMCREAT              ;FOR EACH CREATURE
BLWLOOP   STX     CURRBLW
          LDA     MONSTAT,X
          BMI     JNXTBLW
          LDY     BLWSTAT,X              ;FETCH BLOW UP STATE
*         LDA     MONSTAT,X
          AND     #$02                   ;BLOWN UP?
          BEQ     INFLAT
          CPY     #5                     ;SCORE STAGE?
          BNE     POP
          DEC     BLWCTR,X               ;DONE DISPLAYING POINTS?
          BNE     JNXTBLW
          JSR     OFFSCR2                ;FOUND IN MONSTER FILE
*         LDA     #$80
*         STA     MONSTAT,X              ;DISABLE CREATURE
*         LDA     #0
*         STA     POOKAY,X               ;DON'T DISPLAY ANYTHING
          JSR     GETMODE                ;CREATURES REDO STRATEGY
          JMP     NXTBLW

POP       CPY     #4                     ;POP STAGE?
          BNE     INFLAT
          DEC     BLWCTR,X               ;DONE DISPLAYING POP ANIMATION?
          BNE     JNXTBLW

          JSR     CAROL                  ;ADD IN POINTS

JNXTBLW   JMP     NXTBLW


INFLAT    LDA     PUMPING                ;INFLATING?
          BEQ     DEFLAT
          CPX     PUMPIE                 ;PUMPEE?
          BNE     DEFLAT
          LDA     BLWSTAT,X
          BNE     INFLAT2
          LDA     POOKAIX,X
          STA     PREBLWIX,X             ;SAVE STAMP
          LDA     POOKAY,X
          STA     BLWYPOS,X
*         CLC                            ; CARRY IS SET
          ADC     #4-1
          CMP     #192
          BCC     ADJUSTY
          LDA     #191
ADJUSTY   STA     POOKAY,X
INFLAT2   INC     BLWSTAT,X
          LDA     #SETDEFL               ;INIT DEFLATION CTR
          STA     BLWCTR,X
          JSR     PUFF                   ;CHANGE ANIMATIONS
          LDY     #SNG4                  ;PUMPING CREATURE NOISE
          JSR     NOISE
          LDA     BLWSTAT,X
          CMP     #4                     ;POPPING?
          BNE     JNXTBLW
          LDY     #SNG6                  ;POPPING CREATURE NOISE
          JSR     NOISE
          LDA     MONSTAT,X
          AND     #$FB
          STA     MONSTAT,X
          LDA     LASTMOVE
          STA     BLWLSTMV,X
          LDA     #30                    ;SET POP DISPLAY TIMER
          STA     BLWCTR,X
          BPL     UNLATCH

DEFLAT    LDA     MONSTAT,X              ;DEFLATING?
          AND     #$02
          BEQ     NXTBLW
          DEC     BLWCTR,X
          BNE     NXTBLW
          LDA     #SETDEFL
          STA     BLWCTR,X
          DEC     BLWSTAT,X
          BEQ     GOFREE
          JSR     PUFF
          JMP     NXTBLW
GOFREE    LDA     MONSTAT,X
          AND     #$F8                   ;CLR GBNF,BLOWUP, FREEZE BITS
          STA     MONSTAT,X
          LDA     PREBLWIX,X             ;RESTORE OLD STAMP
          STA     POOKAIX,X
          LDA     BLWYPOS,X
          STA     POOKAY,X               ;RESTORE X POSITION
          CPX     PUMPIE
          BNE     NXTBLW
UNLATCH   JSR     VANPUMP                ;FOUND IN COLLISON
;                                        ;USES A
;                                        ;CLEARS PUMPY ETC., SETS PUMPIE TO FF

NXTBLW    LDX     CURRBLW
          DEX
          BMI     BLWEND
          JMP     BLWLOOP


PUFF      LDY     BLWSTAT,X
          DEY
          STY     BLWTEMP
          LDA     FACING,X
          LSR     A
          LSR     A
          ASL     A
*         CLC
          ADC     BLWTEMP
          STA     BLWTEMP
          TXA
          AND     #$04
          ASL     A
*         CLC
          ADC     BLWTEMP
          TAY
          LDA     BLWSTMPS,Y
          STA     POOKAIX,X
BLWEND    RTS

CAROL     STX     CURRBLW                ;CALLED BY CHKDEATH AND POP
          LDY     #0                     ;CALC CREATURE'S DIRT LEVEL
          LDA     BLWYPOS,X              ;USE TRUE Y POSITION
*         SEC                            ; SET BY CPY WITH 4
          SBC     #$04                   ;REQUIRE 2/3 OVERLAP
FNDLEVEL  SEC
          SBC     #12
          BCC     GOTLEVEL
          INY
          BPL     FNDLEVEL
GOTLEVEL  TYA                            ;RANGE 0 - 14
          LSR     A                      ;FROM BOTTOM UP TUNNELS ARE
          LSR     A                      ;  GROUPED:  3,4,4,4 (INCLUDING SKY)
          TAY
          TXA
          AND     #$04                   ;FYGAR?
          BEQ     LOWPTS
          LSR     A
          AND     BLWLSTMV,X             ;DIGDUG PUMPING HORIZONTALLY?
          BNE     LOWPTS
          INY                            ;DOUBLE POINT VALUE
          INY
          INY
          INY
LOWPTS    LDA     BPOINTS,Y
          STA     POOKAIX,X              ;DISPLAY POINTS
          LDA     #8
          CMP     POOKAX,X
          BCC     LOWPTSA
          STA     POOKAX,X
LOWPTSA   LDA     BLWYPOS,X
          STA     POOKAY,X               ;RESTORE Y POSITION
          LDA     #1                     ;POINTS HAVE LOWEST PRIORITY
          STA     MONPRIOR,X             ;WILL BE RESET BY INCREATS NEXT RACK
          LDA     BURSTPTS,Y             ;LOW ORDER BYTE
          TAY
          LDA     #0
          JSR     ADDSCORE
          LDX     CURRBLW
          LDA     #30                    ;SET POINTS DISPLAY TIMER
          STA     BLWCTR,X
          INC     BLWSTAT,X              ;ADVANCE TO POINT DISPLAY STAGE
          RTS
