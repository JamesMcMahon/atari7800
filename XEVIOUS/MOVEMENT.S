**************************
*  MOVEMENT       THIS PACKAGE CONTROLS ENEMY MOTION AND ACTION.
*                 THE X REGISTER REFERS TO THE ENEMY INDEX AND SHOULD BE
*                   PRESERVED THROUGHOUT THIS CODE

          ZEROPAGE
          MARIAREG
          COLORS
          PUBLIC  RANDOM,MOVEMENT,BOMBING
          ANIMGLBL
          ASKGLBL
          COLLGLBL
          BUTTGLBL
          SHIPGLBL
          LOADGLBL
          DLIGLBL
          HEADGLBL
          MAPGLBL
          ELGLBL
          LINKGLBL
          SHOTGLBL
          TUNEGLBL
          PLAYGLBL
          GODGLBL
          OVERGLBL
          TANKGLBL
          MOMGLBL
          EXTRN   CSHIPS                 ;CREATE SHIPS IF NECESSA
          EXTRN   MOVEGND                ;MOVE GROUND OBJECTS
          EXTRN   DETHWAIT               main
          EXTRN   WVBLANK
          EXTRN   NEWRACK


*
*                 ENEMY TYPES USED BY MOVEMENT IN ELWHICH
*         SHIP                           TYPE NUMBER
*         ----                           ----------- 
*         SOLVALOU SHOT                  -1
*         DON'T CARE                     0
*        *BACULA                         1
*        *DOCILE BLACK EIGHT             2
*        *MEAN BLACK EIGHT               3
*        *RED EIGHT                      4
*        *SUPER EIGHT                    5

*         TOROID                         6
*         TORKAN                         7
*         FLUFF                          8
*         ZOSHI                          9
*         JARA                           A
*         KAPI                           B
*         TERRAZI                        C

*        *TOP OF MOMMY                   D
*        *TOP MIDDLE OF MOMMY            E
*        *MIDDLE OF MOMMY                F
*        *BOTTOM MIDDLE OF MOMMY         10
*        *BOTTOM OF MOMMY                11
*        *SHEONITE                       12
*        *BRAGZA  SHEONITE1              13

*         EXPLOSION                      1D
*         FLUFF EXPLOSION                1E
*         TRACER                         1F

*         ROVER                          20
*         TANK                           21

*****************************************
RAM1      CSECT
*SPECIES INFORMATION
ENEMLIST  EQU     OBJECTS
REALMAX   EQU     ENEMLIST               ;MAXIMUM NUMBER SKY OBJECTS
MAXOBJ    EQU     ENEMLIST-5             ;MINUS SOLV, SHOTS, BOMB, SIGHT
ELDIR     DS      ENEMLIST
ELXSPEED  DS      ENEMLIST
ELYSPEED  DS      ENEMLIST
ELXACCEL  DS      ENEMLIST
ELYACCEL  DS      ENEMLIST
ELACCELT  DS      ENEMLIST
ELXPOS    DS      ENEMLIST
ELYPOS    DS      ENEMLIST
ELXSLOP   DS      ENEMLIST
ELYSLOP   DS      ENEMLIST
ELWHICH   DS      ENEMLIST
ELTYPE    DS      ENEMLIST
ELANIM    DS      ENEMLIST
ELANIMT   DS      ENEMLIST
ELSTATE   DS      ENEMLIST
ELMEAN    DS      ENEMLIST
ELWAIT    DS      ENEMLIST
ELPALW    DS      ENEMLIST
ELCLASS   DS      ENEMLIST
ELFORLNK  DS      ENEMLIST
ELBAKLNK  DS      ENEMLIST
ELPRIOR   DS      ENEMLIST

*****************************************
RAM2      CSECT
BOMBING   DS      1
SIGHTCOL  DS      1                      ;what color sight is when not flashing
SHOTTRIG  DS      1
BOMBTRIG  DS      1
SHOTFRM   DS      1
OLDSBUTT  DS      1
OBJRESRV  DS      1                      ;1+HOW HIGH THE OBJECT CNTR IS RESERVED
SHOTCNT   DS      1                      ;THE LOWEST ACTIVE SHOT

TRACEX    DS      1                      tracer target
TRACEY    DS      1

*****************************************
CODE9000  CSECT
ATOPMOVE

*  THIS ROUTINE CONTROLS MOVEMENT
MOVEMENT  MOVE    SIGHTCOL,P4C1
          JSR     MOVESHOT               ;MOVE ENEMY SHOTS
          JSR     MOVESHIP               ;MOVE SHIPS AROUND, DO ACTIONS
          JSR     CSHIPS                 ;CREATE SHIPS IF NECESSARY
          JMP     SIGHTCIT               ;CHECK SIGHT OVER GROUND TARGETS
*         RTS


***********
*  THIS ROUTINE MOVES THE SHOTS
MOVESHOT
          LDX     PRIOR4                 ;POINTER TO SHOT LINKED LIST
MTAGAIN
          CPX     #$FF                   ;ARE WE OUT OF SHOTS
          BEQ     MTOUT                  ;BRANCH IF WE ARE
          LDA     ELFORLNK,X
          STA     NXTFLNK
          JSR     COLLDET
          JSR     MSMOTION               ;JUST MOVE SHOTS, CHECK FOR BOUNDARIES
          LDX     NXTFLNK
          JMP     MTAGAIN
MTOUT     RTS


***********
*  THIS ROUTINE CONTROLS ENEMY SHIP MOTION AND ACTION
MOVESHIP
          LDX     PRIOR0
          BPL     MSAGAIN
          LDX     PRIOR1
          BPL     MSAGAIN
          LDX     PRIOR2
          BPL     MSAGAIN
          LDX     PRIOR3
          BPL     MSAGAIN
          BMI     MSOUT

MSAGAIN
          CPX     #$FF                   ;ARE WE OUT OF SHIPS
          BEQ     MSOUT                  ;BRANCH IF YES
          JSR     RANDOM
          LDA     ELFORLNK,X
          STA     NXTFLNK
          LDA     ELWHICH,X
          BMI     NOTGRND
          CMP     #$20
          BNE     NOTGRND
          JSR     MOVEGND                ;MOVE GROUND OBJECTS
          JMP     MSINX
NOTGRND   JSR     MSANIMAT
          JSR     MSACTION               ;DO THE ACTION FOR THE SHIP
MSINX
          LDX     NXTFLNK                ;GO ON TO THE NEXT SHIP
          JMP     MSAGAIN
MSOUT     RTS                            ;RETURN TO GAME CONTROL


***********
*  THIS ROUTINE VECTORS TO THE APPROPRIATE ACTION CODE FOR THE SHIP
MSACTION  LDY     ELSTATE,X              ;FIND WHICH ACTION ROUTINE TO GO TO
          LDA     ACTIONRL,Y
          STA     TEMP0
          LDA     ACTIONRH,Y
          STA     TEMP1
          JMP     (TEMP0)


***********
*  THIS ROUTINE DOES THE MOTION FOR A SHIP, SHOULD BE CALLED FROM ACTION
*  ROUTINES AS NECESSARY
MSMOVE    JSR     COLLDET                ;DO COLLISION DETECTION NOW

          LDA     ELACCELT,X
          BEQ     MSMOTION               ;IF NO ACCELERATION, JUST MOVE IT

          ADD     ELXSPEED,X,ELXACCEL,X,ELXSPEED,X     ;DO X ACCELERATION

          BCS     MSMY                   ;SEE IF SPEED WRAPPED
          LDA     ELXACCEL,X             ;CARRY CLEAR, SEE WHICH WAY ACCELERATE
          BPL     MSMY
                                         ;CARRY CLEAR, ACCEL NEGATIVE, FLIP
          LDA     ELXSPEED,X             ;SPEED FLIPPED OVER, SWITCH IT
          JSR     INVERT
          STA     ELXSPEED,X
          LDA     ELXACCEL,X             ;TURN DECELERATION TO ACCELERATION
          JSR     INVERT
          STA     ELXACCEL,X
          LDA     ELDIR,X                ;FLIP DIRECTION
          EOR     #$80
          STA     ELDIR,X

MSMY      ADD     ELYSPEED,X,ELYACCEL,X,ELYSPEED,X   ;DO Y ACCELERATION

          BCS     MSDECT                 ;SEE IF SPEED WRAPPED
          LDA     ELYACCEL,X             ;CARRY CLEAR, SEE WHICH WAY ACCELERATE
          BPL     MSDECT
                                         ;CARRY CLEAR, ACCEL NEGATIVE, FLIP
          LDA     ELYSPEED,X             ;SPEED FLIPPED OVER, SWITCH IT
          JSR     INVERT
          STA     ELYSPEED,X
          LDA     ELYACCEL,X             ;TURN DECELERATION TO ACCELERATION
          JSR     INVERT
          STA     ELYACCEL,X
          LDA     ELDIR,X                ;FLIP DIRECTION
          EOR     #$40
          STA     ELDIR,X

MSDECT    DEC     ELACCELT,X             ;DECREMENT TIMER
          BNE     MSMOTION
          LDA     ELXSPEED,X             ;IF TIME OUT, MAKE VELOCITIES 'EVEN'
          ADC     #$0F
          AND     #$E0
          STA     ELXSPEED,X
          LDA     ELYSPEED,X
          ADC     #$0F
          AND     #$E0
          STA     ELYSPEED,X


*  MOVE A SHIP OR SHOT - CHECK AGAINST SCREEN BOUNDARIES
MSMOTION  LDA     ELXSPEED,X             ;ADJUST X POS
          JSR     MSMROTAT               ;SHIFT IT TO TWO BYTES
          LDA     ELDIR,X                ;FIND OUT IF MOVING LEFT OR RIGHT
          BMI     MSXLEFT

          LDA     ELXSLOP,X              ;UPDATE SLOP
          CLC
          ADC     TEMP1
          STA     ELXSLOP,X
          LDA     ELXPOS,X               ;UPDATE POS
          ADC     TEMP0
          STA     ELXPOS,X
          CMP     #$90                   ;COMPARE TO RIGHT MARGIN
          BCC     MSMOVEY
          JMP     MSDELETE

***********
MSXLEFT   LDA     ELXSLOP,X              ;UPDATE SLOP
          SEC
          SBC     TEMP1
          STA     ELXSLOP,X
          LDA     ELXPOS,X               ;UPDATE POS
          SBC     TEMP0
          STA     ELXPOS,X
          CMP     #$06                   ;COMPARE TO LEFT MARGIN
          BCS     MSMOVEY
          JMP     MSDELETE               ;DELETE THE SHIP

***********
MSMOVEY   LDA     ELYSPEED,X             ;ADJUST Y POS
          JSR     MSMROTAT               ;SHIFT IT TO TWO BYTES
          LDA     ELDIR,X                ;FIND OUT IF MOVING UP OR DOWN
          AND     #$40
          BNE     MSYDOWN

          LDA     ELYSLOP,X              ;UPDATE SLOP
          CLC
          ADC     TEMP1
          STA     ELYSLOP,X
          LDA     ELYPOS,X               ;UPDATE POS
          ADC     TEMP0
          STA     ELYPOS,X
          CMP     #$E1                   ;COMPARE TO TOP MARGIN
          BCC     MSMOUT
          LDA     ELWHICH,X
          CMP     #$10                   ;BOTTOM OF MOMMY
          BNE     MSNOSOLS
          LDA     #$00
          STA     MOMSTAT
MSNOSOLS  JMP     MSDELETE

***********
MSYDOWN   LDA     ELYSLOP,X              ;UPDATE SLOP
          SEC
          SBC     TEMP1
          STA     ELYSLOP,X
          LDA     ELYPOS,X               ;UPDATE POS
          SBC     TEMP0
          STA     ELYPOS,X
          BEQ     TOMDEL
          CMP     #$E1
          BCC     MSMOUT
          LDA     ELWHICH,X
          CMP     #$0D                   ;TOP OF MOMMY
          BNE     MSNOSOLS
          LDA     #$00
          STA     MOMSTAT
TOMDEL    JMP     MSDELETE
MSMOUT
          RTS

***********
*  THIS ROUTINE TURNS A VELOCITY INTO A TWO BYTE QUANTITY TO BE ADDED TO THE
*  SPEED/SLOP.
MSMROTAT  LDY     #$00                   ;SEPARATE SIGNIFICANT AND SLOP
          STY     TEMP0
          ASL     A
          ROL     TEMP0
          ASL     A
          ROL     TEMP0
          ASL     A
          ROL     TEMP0
          STA     TEMP1
          RTS



***** STATES FOR SHIPS

NULLSTAT  JMP     MSMOVE                 ;DO NOTHING


***********
ANIMATE   LDA     ELANIM,X               ;SET ANIMATION BIT
          AND     #$7F
          STA     ELANIM,X
          LDY     ELWHICH,X              ;SET ANIMATION TIME
          LDA     ANIMTIME,Y
          STA     ELANIMT,X
          INC     ELSTATE,X
          JMP     MSACTION               ;DO SOMETHING ELSE


***********
CHECKX    LDA     ELXPOS,X               ;WAIT TILL SOLVALU NEARLY VERTICAL
          SEC
          SBC     ELXPOS
          BPL     CXPLUS
          JSR     INVERT
CXPLUS    CMP     #$0E
          BCS     CXOUT
          INC     ELSTATE,X
CXOUT     JMP     MSMOVE

***********
CHECKY    LDA     ELYPOS,X               ;WAIT TILL SOLVALU NEARLY HORIZONTAL
          SEC
          SBC     ELYPOS
          BPL     CYPLUS
          JSR     INVERT
CYPLUS    CMP     #$14
          BCS     CYOUT
          INC     ELSTATE,X
CYOUT     JMP     MSMOVE


***********
JTREVSEX  LDA     ELXSPEED,X
          CLC
          ADC     #$13
          JMP     ASEX
REVERSEX  LDA     ELXSPEED,X             ;REVERSE THE X VELOCITY
ASEX      LSR     A
          LSR     A
          LSR     A
          JSR     INVERT
          STA     ELXACCEL,X
          MOVE    #$12,ELACCELT,X
          MOVE    #$00,ELYACCEL,X
          INC     ELSTATE,X
          JMP     MSACTION               ;DO NEXT ACTION IMMEDIATELY

***********
REVRSALL
          LDA     #$10
          BNE     JUSTLIKE               ;JMP...

***********
STOP      LDA     #$08
JUSTLIKE  STA     ELACCELT,X
          LDA     ELXSPEED,X             ;FREEZE THE X VELOCITY
          LSR     A
          LSR     A
          LSR     A
          JSR     INVERT
          STA     ELXACCEL,X
          LDA     ELYSPEED,X             ;FREEZE THE Y VELOCITY
          LSR     A
          LSR     A
          LSR     A
          JSR     INVERT
          STA     ELYACCEL,X
          INC     ELSTATE,X
          JMP     MSACTION               ;DO NEXT ACTION IMMEDIATELY

***********
ZIPOFF
          JSR     ENTOSOLV               ;aim, zip away from solvalu
          MOVE    TEMP5,ELDIR,X
          MOVE    AIMX,Y,ELXACCEL,X      ;GET ACCELERATION
          MOVE    AIMY,Y,ELYACCEL,X
          MOVE    #$04,ELACCELT,X
          INC     ELSTATE,X
          JMP     MSACTION               ;DO NEXT ACTION IMMEDIATELY


***********
SETWAIT   LDY     ELWHICH,X              ;SET THE WAIT TIME
          MOVE    WAITTIME,Y,ELWAIT,X
          INC     ELSTATE,X
          JMP     MSMOVE

WAITTIME  DB      $FF,$FF,$FF,$FF,$0C,$10,$05,$07        ;LENGTH OF WAIT
          DB      $FF,$10,$05,$FF,$FF,$14,$14,$14
          DB      $14,$14,$38,$38,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$0B,$05,$00


***********
WAIT      DEC     ELWAIT,X               ;WAIT
          LDA     ELWAIT,X
          BNE     WAITOUT
          INC     ELSTATE,X              ;WAIT OVER
WAITOUT   JMP     MSMOVE

*********** MOM ROUTINES ********************
FLIPMOM
          MOVE    #$FF,ELWAIT,X
          LDA     PRIOR2
NEXTFLIP  CMP     #$FF
          BEQ     DONEFLIP
          TAY
          LDA     ELPRIOR,Y
          CMP     #$02
          BNE     DONEFLIP
          MOVE    #$00,ELYSPEED,Y
          LDA     ELFORLNK,Y
          JMP     NEXTFLIP
DONEFLIP  INC     ELSTATE,X
          LDA     MOMSTAT
          AND     #$1F
          ORA     #$40
          STA     MOMSTAT
          JMP     MSMOVE

***********
FLYMOM
          LDA     PRIOR2
NEXTFLY   CMP     #$FF
          BEQ     DONEFLY
          TAY
          LDA     ELPRIOR,Y
          CMP     #$02
          BNE     DONEFLY
          MOVE    #$40,ELYSPEED,Y
          MOVE    #$00,ELDIR,Y
          LDA     ELFORLNK,Y
          JMP     NEXTFLY
DONEFLY
          INC     ELSTATE,X
          LDA     MOMSTAT
          AND     #$1F
          ORA     #$60
          STA     MOMSTAT
          JMP     MSMOVE

***********
TRSHFIRE  LDA     ELMEAN,X               ;FIRE IF OVER THRESHOLD
          CMP     #$10
          BCC     TFOUT
          CMP     #$15
          BCS     ZOK2FIRE
          LDA     CURROW
          CMP     #$10
          BCC     TFOUT                  ;DON'T FIRE ON ANY EARLY ROWS
          LDA     RNDM
          LSR     A
          BCC     TFOUT
ZOK2FIRE
          JSR     FIRE
TFOUT     INC     ELSTATE,X
          JMP     MSMOVE

***********
CONTFIRE  LDA     ELMEAN,X               ;FIRE IF RANDOM UNDER MEAN, CONTINUOUSL
          LSR     A
          LSR     A
          STA     TEMP0
          JSR     RANDOM
          CMP     TEMP0
          BCS     CFOUT
          JSR     FIRE
CFOUT     JMP     MSMOVE
***********
MOMFIRTB  DB      $40,$30,$20,$20
LPORTMSK  DB      SWPORT,NWPORT
RPORTMSK  DB      SEPORT,NEPORT
MOMFIRE
* SHOULD THIS SECTION FIRE?
          LDA     MOMSTAT
          AND     #$04                   ;CENTER PORT DEAD?
          BNE     MFOUT
          DEC     ELMEAN,X
          BNE     MFOUT

* YES. SET TIMER FOR NEXT TIME IT SHOULD FIRE.
          LDA     RACK
          LSR     A
          LSR     A
          TAY
          JSR     RANDOM
          AND     #$1F
          CLC
          ADC     MOMFIRTB,Y
          STA     ELMEAN,X

* TOP OR BOTTOM?
          LDY     #0
          LDA     ELWHICH,X
          CMP     #MOMTMID-$20
          BNE     MUSBEBOT
          INY
MUSBEBOT

* FROM LEFT OR RIGHT SIDE
          JSR     RANDOM
          AND     #$04                   ;3 LSR'S AND A BCC...
          BEQ     FLPORT
          LDA     MOMSTAT
          AND     RPORTMSK,Y
          BNE     DEADPORT
          LDA     #RPORTX                ;THE RIGHT PORT
          BNE     ZZX1                   ;ALWAYS
FLPORT
          LDA     MOMSTAT
          AND     LPORTMSK,Y
          BNE     DEADPORT
          LDA     #LPORTX                ;ONLY LEFT PORT FOR NOW
ZZX1      STA     TEMP14
          LDA     ELYPOS,X
          CLC
          ADC     #$08
          STA     TEMP15
          JSR     FIRE1
DEADPORT
MFOUT     JMP     MSMOVE

***********
ONCEFIRE  JSR     FIRE                   ;FIRE ONCE
          INC     ELSTATE,X
          JMP     MSACTION               ;DO SOMETHING ELSE


***********
BALLFIRE  LDA     ELXPOS,X               ;FIRE AN 8 BALL
          SEC                            ;ADJUST POSITION FOR FIRE
          SBC     #$04
          STA     TEMP14
          LDA     ELYPOS,X
          CLC
          ADC     #$0D
          STA     TEMP15
          JSR     FIRE1                  ;FIRE
GOAWAY    JMP     MSDELETE               ;NO MORE SHIP

***********
WALLFIRE  LDA     SHOTCNT                ;fire a red 8-ball
          SEC
          SBC     OBJRESRV               ;see if enough space
          CMP     #6                     ;WAS 4
          BPL     WFNOWAIT
          JMP     MSMOVE                 ;wait for enough space

WFNOWAIT
          LDA     ELXPOS,X               ;STORE SHIP XPOS AND YPOS for GETSHOT
          STA     TEMP14
          LDA     ELYPOS,X
          STA     TEMP15
          TXA                            ;save X
          PHA


          JSR     ENTOSOLV               ;aim at solvalu (T0,T2 = X,Y)
          AND     #$07                   ;BIT5-3 = Y, BIT2-0 = -X
          STA     TEMP7                  ;TEMP7  = x
          TYA
          LSR     A
          LSR     A
          LSR     A
          STA     TEMP8                  ;TEMP8  = Y
          LDY     #0                     ;either 0th or 3rd angle
          SUB     A,TEMP7,TEMP6
          BPL     YGEX
          LDY     #3                     ;3rd angle
          JSR     INVERT
YGEX      STY     TEMP0
          CMP     #4
          BPL     BIGDIFF
          TYA
          EOR     #$01                   ;either 1st or 2nd angle
          STA     TEMP0
BIGDIFF   LDA     TEMP5                  ;quadrant selected by ENTOSOLV
          ASL     A
          ROL     A
          ROL     A
          TAY
          LDA     QUADRANT,Y
          ORA     TEMP0
          STA     TEMP0
          AND     #$40                   ;invert angle selector of odd quads
          BNE     ZORRIGHT
          LDA     TEMP0
          EOR     #$03
          STA     TEMP0
ZORRIGHT
          JSR     MSDELETE               ;get rid of 8-ball

          LDA     #4
          STA     TEMP3                  ;counter
WFLOOP    JSR     SETSHOT                ;SET THE SHOT UP
          LDY     TEMP0
          LDA     AFXSPEED-2,Y             ;SET SPEED
          STA     ELXSPEED,X
          LDA     AFYSPEED-2,Y
          STA     ELYSPEED,X
          LDA     AFDIR-2,Y                ;AND DIRECTION
          STA     ELDIR,X
          INC     TEMP0
          DEC     TEMP3
          BPL     WFLOOP
          PLA                            ;RESTORE X
          TAX
          RTS                            ;ALREADY DELETED RED 8 BALL
QUADRANT  DB      00,$04,$0C,$08          ;0,4,12,8?


***********
ALLFIRE   LDA     SHOTCNT                ;FIRE A SUPER-8 BALL
          SEC
          SBC     OBJRESRV               ;SEE IF ENOUGH SPACE
          CMP     #$0F
          BPL     AFNOWAIT
          JMP     MSMOVE                 ;WAIT FOR ENOUGH SPACE

AFNOWAIT
          LDA     #SUP8TUNE
          JSR     TUNIN
          ADD     ELXPOS,X,#4,TEMP14     ;STORE SHIP's center XPOS AND YPOS
          SUB     ELYPOS,X,#$D,TEMP15
          JSR     MSDELETE               ;GET RID OF THE SUPER 8 BALL
          TXA                            ;SAVE X
          PHA

          LDY     #$0F
AFLOOP    STY     TEMP0
          JSR     SETSHOT                ;SET THE SHOT UP
          LDY     TEMP0
          MOVE    AFXSPEED,Y,ELXSPEED,X  ;SET SPEED
          MOVE    AFYSPEED,Y,ELYSPEED,X
          MOVE    AFDIR,Y,ELDIR,X        ;AND DIRECTION
          DEY
          BPL     AFLOOP

          ADD     ELXPOS,#8,TRACEX       ;target= current center of solv
          SUB     ELYPOS,#6,TRACEY
          LDY     #$03                   ;4 tracers
AFLOOP2   STY     TEMP0
          MOVE    #3,PRIORITY
          JSR     GETSHIP                ;ZERO THE SHIP STATE - WE KNOW IS OK
          CPX     #$FF
          BEQ     ERTE                   ;NO MORE ROOM AT THE INN
          LDA     #ANTRACER-ANIMTAB      ;SET THE STAMP
          STA     ELANIM,X
          LDA     #ACTRACER-ACTIONRL     ;SET THE STATE
          STA     ELSTATE,X
          MOVE    #3,ELPRIOR,X
          MOVE    #$3F,ELPALW,X          ;SET UP SOME SHOT STATE
          MOVE    #2,ELANIMT,X
          MOVE    #8,ELWHICH,X           (fluff)
          MOVE    #2,ELCLASS,X           make 'em mortal
          MOVE    TEMP14,ELXPOS,X        ;GET XPOS OF SHIP WHICH IS FIRING
          MOVE    TEMP15,ELYPOS,X        ;SHIP FIRES FROM CENTER
          JSR     SHOWSHIP

          MOVE    #$31,ELXSPEED,X        ;shoot off on diagonals
          MOVE    #$68,ELYSPEED,X
          LDA     #0                     ;NECESS?
          STA     ELXACCEL,X
          STA     ELYACCEL,X
          MOVE    #7,ELACCELT,X
          LDY     TEMP0
          MOVE    ATDIR,Y,ELDIR,X
          DEY
          BPL     AFLOOP2

ERTE      PLA                            ;RESTORE X
          TAX
          RTS                            ;ALREADY DELETED SUPER 8 BALL

* POSITIONS 0-15 CLOCKWISE FROM NOON.
WFXSPEED  DB      096*2/3,052*2/3            ;14,15
AFXSPEED  DB      000*2/3,052*2/3,096*2/3,128*2/3
          DB      136*2/3,128*2/3,096*2/3,052*2/3 ;0-7
          DB      000*2/3,052*2/3,096*2/3,128*2/3
          DB      136*2/3,128*2/3,096*2/3,052*2/3 ;8-15
          DB      000*2/3,052*2/3            ;0,1
WFYSPEED  DB      175*2/3,227*2/3            ;14,15
AFYSPEED  DB      248*2/3,227*2/3,175*2/3,093*2/3
          DB      000*2/3,093*2/3,175*2/3,227*2/3 ;0-7
          DB      248*2/3,227*2/3,175*2/3,093*2/3
          DB      000*2/3,093*2/3,175*2/3,227*2/3 ;8-15
          DB      248*2/3,227*2/3            ;0,1
WFDIR     DB      $40,$40                ;14,15
AFDIR     DB      $C0,$C0,$C0,$C0,$80,$80,$80,$80 ;0-7
          DB      $00,$00,$00,$00,$40,$40,$40,$40 ;8-15
          DB      $C0,$C0                ;0,1
ATDIR     DB      $00,$80,$40,$C0

***********
TRACEOUT  LDA     ELACCELT,X
          BNE     TOMOVE
          LDA     #$12
          STA     ELACCELT,X
          INC     ELSTATE,X
TOMOVE    JMP     MSMOVE
***********
* Only the acceleration is updated.
TRACERM
          LDA     ELACCELT,X             ;check timer to go to next state
          BEQ     TMCOAST
          MOVE    TRACEY,TEMP1
          MOVE    TRACEX,TEMP3
          JSR     ENTOSOME               ;aim the sucker at the tracer target
          LDA     AIMY,Y
          LSR     A
          STA     ELYACCEL,X
          LDA     TEMP5                  ;test direct (accel or decel?)
          EOR     ELDIR,X
          ASL     A
          BMI     NODECELY               ;;;?
          LDA     ELYACCEL,X
          JSR     INVERT
          STA     ELYACCEL,X
NODECELY  LDA     AIMX,Y
          LSR     A
          STA     ELXACCEL,X
          LDA     TEMP5                  ;test direct (accel or decel?)
          EOR     ELDIR,X
          BMI     NODECELX
          LDA     ELXACCEL,X
          JSR     INVERT
          STA     ELXACCEL,X
NODECELX
          JMP     MSMOVE
TMCOAST   INC     ELSTATE,X              ;send the tracer off
          MOVE    #8,ELYACCEL,X
          MOVE    #5,ELXACCEL,X
          MOVE    #$FF,ELACCELT,X
TRACEOFF  JMP     MSMOVE

************************** ZOSHI ROUTINES ******************************
ZOSHSET   JSR     RANDOM                 ;SET WHICH TYPE OF ZOSHI IT IS
          BMI     ZSTYPE2
          LDA     ELSTATE,X              ;THIS TYPE CHECKS FOR X CROSSINGS
          SEC
          SBC     #$05
          STA     ELSTATE,X
ZSTYPE2   INC     ELSTATE,X              ;THIS TYPE CHECKS FOR Y CROSSINGS
          JMP     MSACTION               ;DO SOMETHING ELSE

***********
ZOSHDIR   LDA     ELMEAN,X               ;SET ZOSHI DIRECTION
          EOR     #$FF                   ;INVERT IT
          ORA     #$3F                   ;MAKE SURE IT ISN'T TOO SMALL
          STA     TEMP5                  ;INVERTED MEAN
ZDJMP0    JSR     RANDOM                 ;GET A PAIR OF RANDOMS <= INVERTED MEAN
          CMP     TEMP5
          BCS     ZDJMP0
          STA     TEMP1
ZDJMP1    JSR     RANDOM
          CMP     TEMP5
          BCS     ZDJMP0
          STA     TEMP3
          LSR     TEMP5                  ;DIVIDE INVERTED BY TWO TO ZERO CENTER

          LDA     ELYPOS                 ;SET UP FOR CALL TO AIM
          ADC     TEMP1                  ;RANDOM OFFSET
          SBC     TEMP5                  ;SET AROUND ZERO
          STA     TEMP0
          LDA     ELXPOS
          ADC     TEMP3                  ;RANDOM OFFSET
          SBC     TEMP5                  ;SET AROUND ZERO
          STA     TEMP2
          LDA     ELYPOS,X
          STA     TEMP1
          LDA     ELXPOS,X
          STA     TEMP3
          JSR     AIM                    ;AIM IT AWAY FROM SOLVALU
          LDA     TEMP5
          STA     ELDIR,X
          LDA     AIMX,Y                 ;GET X VELOCITY
          ASL     A                      ;SCALE UP
          ASL     A
          AND     #$E0                   ;MAKE IT EVEN
          STA     ELXSPEED,X
          LDA     AIMY,Y                 ;GET Y VELOCITY
          ASL     A                      ;SCALE UP
          ASL     A
          AND     #$E0                   ;MAKE IT EVEN
          STA     ELYSPEED,X
          INC     ELSTATE,X
          JMP     MSMOVE                 ;MOVE IT

***********
ZOSHBACK  LDA     ELSTATE,X              ;RESET ZOSHI STATE TO MERGE TWO TYPES
          SEC
          SBC     #$06
          STA     ELSTATE,X
          JMP     MSACTION               ;DO SOMETHING ELSE

***********
CRATDOWN
          LDA     ELXPOS,X
          PHA
          LDA     ELYPOS,X
          PHA
          JSR     LNKDELET
          LDA     #$00
          STA     PRIORITY
          JSR     LNKINSRT
;NOTE  DON'T HAVE TO CHECK FOR A SPACE BECAUSE  WE JUST MADE ONE
          JSR     ZEROSHIP
          PLA
          STA     ELYPOS,X
          PLA
          STA     ELXPOS,X
          LDA     #$3E
          STA     ELPALW,X
          LDA     #L(CCRAT)
          STA     ELTYPE,X
          LDA     #$FF                   ;NO MORE ANIMATION PLEASE
          STA     ELANIM,X
          LDA     #$C0
          STA     ELDIR,X
          LDA     #$20
          STA     ELYSPEED,X
          LDA     #$00
          STA     ELPRIOR,X
          STA     ELSTATE,X
CDBYEBYE  JMP     MSMOVE

***********
DYING
          LDA     #L(C3BLANK)
          STA     ELTYPE
          STA     ELTYPE+1
          DEC     DETHWAIT
          BPL     DYOUT
          INC     ELSTATE
DYOUT
          JMP     MSMOVE

******************  TANK MOTION ROUTINES  ********************


TANKDEAD  DEC     ELWAIT,X
          BPL     MSMORE
          LDA     #$7F                   ;ENOUGH?
          STA     ELANIMT,X
          LDA     #DEADTANK
          BPL     NULLME                 ;JMP...

TANKWOW   JSR     REACTEST               ;REACT: WOW, THEN STOP   10,000!
          BEQ     MSMORE
* HERE TEST WHETHER BOMBING/PUSHING BOMB BUTTON?
          LDA     BBUTTON
          BEQ     MSMORE
          LDA     #1
          STA     ELANIMT,X
          LDA     #ZIPTANK*3/2
          BNE     SETWAITD               ;JMP...

TANKZIP   JSR     REACTEST               ;REACT: ZIP, THEN STOP
          BEQ     MSMORE
          LDA     #2
          STA     ELANIMT,X
          LDA     #ZIPTANK
          BNE     SETWAITD               ;JMP...

TANKSLOW  JSR     REACTEST               ;REACT:  DOWN
          BEQ     MSMORE
          LDA     #SLOWTANK
NULLME    STA     ELYSPEED,X
          LDA     #0
          STA     ELSTATE,X              ;NULLSTAT
MSMORE    JMP     MSMOTION

TANKUP    JSR     REACTEST               ;REACT:  BACK UP, THEN DOWN
          BEQ     MSMORE
          LDA     #3
          STA     ELANIMT,X
          LDA     #0
SETWAITD  STA     ELYSPEED,X
          LDA     #ANTANK-ANIMTAB
          STA     ELANIM,X
          INC     ELSTATE,X
          LDA     #TANKTIME
          STA     ELWAIT,X
          BNE     MSMORE                 ;JMP...

TANKSTOP  JSR     REACTEST               ;REACT: PAUSE, THEN DOWN
          BEQ     MSMORE
          LDA     #$7F
          STA     ELANIMT,X
          LDA     #SCROLSPD
          BNE     SETWAITD               ;JMP...

WAITDOWN  DEC     ELWAIT,X               ;PAUSE THEN DOWN
          BNE     MSMORE
          LDA     #TANKSPED
          BNE     NULLME

REACTEST                                 ;see if sight over you
          LDY     #0                     ;flag: 0 means not over you
          LDA     ELXPOS,X
          SEC
          SBC     #5                     tweak me (offset to left)
          CMP     ELXPOS+1               sight
          BCS     NOREACT
          ADC     #10                    tweak me (offset to right +4)
          CMP     ELXPOS+1
          BCC     NOREACT
          LDA     ELYPOS,X
          SEC
          SBC     #10                    tweak me (offset to bottom)
          CMP     ELYPOS+1               sight
          BCS     NOREACT
          ADC     #12                    tweak me (offset to top +4)
          CMP     ELYPOS+1
          BCC     NOREACT
          INY
NOREACT   TYA
          RTS

***********
ENDPTURN                                 ;END THE PLAYER'S TURN
          JSR     SCRAPALL
          LDA     MODE
          CMP     #MAUTO
          BEQ     GNOTOVER
          DEC     NUMLIVES
          BPL     GNOTOVER
          ;SHOULD DISPLAY APPROPRIATE GAME OVER INDICATOR HERE
          NEWSTATE INITOVER
          RTS                            ;stop stack degrading in GOD?

GNOTOVER  LDA     CURROW
          CMP     #$F0                   ;CAN OCCUR WHILE DISPLAYING FORESTS
          BCS     SAMERACK
          CMP     #NEWRACK
          BPL     NODECRCK
SAMERACK  DEC     RACK
NODECRCK  LDA     NUMPLYRS
          BEQ     REDOCONS               ;if only 1 player
          LDA     NUMDEAD
          BNE     REDOCONS               ;if only current player alive
          LDA     MODE
          CMP     #MAUTO
          BEQ     REDOCONS
          JSR     SWITCHP
REDOCONS
          JMP     RESTART       ; Go to beginning of current player's rack.
*         RTS


***********
*SCRTIN0  SUB     ELXSPEED,X,#5,A
*         JMP     ESCORTIN
*SCRTIN1  ADD     ELXSPEED,X,#5,A
ESCORTIN   ;STA     ELXSPEED,X
          SUB     ELYSPEED,X,#7,ELYSPEED,X       YSPEED = Y off from solv
          CMP     #16
          BCS     ESCORTON
          MOVE    #16,ELYSPEED,X
          MOVE    #$80,ELWAIT,X
          INC     ELSTATE,X              ;goes straight to ESCWAIT
          JMP     ESCORTON

ESCWAIT   DEC     ELWAIT,X
          BNE     ESCORTON
NEXT      INC     ELSTATE,X
ESCORTON  ADD     ELXSPEED,X,ELXPOS,ELXPOS,X     sit on solv
          ADD     ELYSPEED,X,ELYPOS,ELYPOS,X
          RTS

***********
FLIPLEFT
          INC     ELXSPEED,X
          LDA     #ANESCOR0-ANIMTAB
          JMP     FLIPPED
***********
MATE0
          INC     ELXSPEED,X             ;from -8  to 1
          LDA     ELXSPEED,X
          CMP     #1
          BNE     ESCORTON
          LDA     #ANMATING-ANIMTAB
          STA     ELANIM,X
          JMP     NEXT
***********
FLIPRITE
          LDA     #ANESCOR1-ANIMTAB
FLIPPED   STA     ELANIM,X
          MOVE    #4,ELANIMT,X
          MOVE    #$A,ELWAIT,X
          INC     ELSTATE,X
          RTS

***********
MATE1
          DEC     ELXSPEED,X             ;from 16 to 4
          LDA     ELXSPEED,X
          CMP     #3
          BNE     ESCORTON
          LDA     #ESCTTUNE
          JSR     TUNIN
          JMP     MSDELETE
***********

***********
ESCORTGO
          ADD     ELYPOS,X,#14,ELYPOS,X  bag the solv: get the hell out of here
          CMP     #$CF
          BCC     ESCORTED
          JMP     MSDELETE               ;escorts DIE
ESCORTED  RTS                            ;X(escort) = k

***********
SOLVALUA  STX     TEMP9                  ;X IS PRESERVED, MUST HIT SAOUT
          LDA     SBUTTON                ;SOLVALU ACTION ROUTINE - CHECK BUTTONS
          BNE     SACONT                 ;SEE IF BUTTON WAS HIT
          STA     OLDSBUTT               ;INDICATES THAT BUTTON WAS RELEASED
          JMP     SABOMB
SACONT
          DEC     SHOTFRM                ;ONE TIC HAS PASSED
          LDA     SHOTTRIG               ;SEE IF NO SHOTS OUTSTANDING
          BEQ     SASHOOT
          CMP     #$03
          BPL     SABOMB
          LDA     OLDSBUTT               ;SEE IF LET UP ON, THEN RE-DEPRESSED
          BEQ     SASHOOT
          LDA     SHOTFRM                ;SEE IF TIME YET
          BPL     SABOMB
SASHOOT   JSR     FIRESHOT               ;FIRE THE SHOT
* BOMB
SABOMB    LDA     BBUTTON
          BEQ     SAOUT
          LDA     BOMBTRIG               ;CHECK IF BOMB IS ALREADY ON SCREEN
          BNE     SAOUT
          JSR     FIREBOMB               ;FIRE THE BOMB
SAOUT     LDX     TEMP9                  ;RESTORE X
          RTS

***********
SOLVBOMB  DEC     ELWAIT,X               ;SOLVALU BOMB MOVEMENT
          BPL     SBOUT
          DEC     BOMBTRIG               ;ALLOW ANOTHER BOMB
          JSR     COLLDETB               ;SEE IF WE HIT ANYTHING
          JSR     HYBCOLLD               ;ROVERS,TANKS,MAMA COLLISION
          INC     OBJRESRV               ;RESERVE ANOTHER OBJECT FOR NEW BOMB
          JMP     MSDELETE               ;AND BE NO MORE
SBOUT     JMP     MSMOVE

***********
SOLVSITE
          DEC     ELWAIT,X               ;SOLVALU SIGHT MOVEMENT
          BPL     SBOUT
          LDA     SOLVSTAT
          BNE     DYELSITE
          LDA     #$80+(32-3)            this pal has C2 = white
          STA     ELPALW+1
          LDA     #ANSOLSIT-ANIMTAB+$80
          STA     ELANIM+1               sight loses its frame
          LDA     ANSOLSIT
          STA     ELTYPE+1
DYELSITE  JMP     MSDELETE               ;AND BE NO MORE

***********
SOLVSHOT  JSR     COLLDETS               ;SOLVALU SHOT MOVEMENT
          BEQ     SBOUT                  ;SEE IF WE HIT ANYTHING
          JMP     MSDELETE



***** GENERAL UTILITIES

* MAKE A SHIP FIRE.  CREATE A NEW OBJECT IN THE ENEMY LIST WHOSE TYPE IS
* A SHOT, AND POINT IT AT THE HERO, SCALING DOWN THE X AND Y DIFFERENCES
* BETWEEN THE SHOT AND THE HERO UNTIL THEY ARE WITHIN LIMITS (EIGHT PIXELS
* MAX).
FIREOUT   RTS                            ;ALWAYS START WITH AN END
FIRE      LDA     ELXPOS,X
          STA     TEMP14
          LDA     ELYPOS,X
          STA     TEMP15
FIRE1     LDA     OBJRESRV               ;CHECK NO. OF OBJECTS ON SCREEN
          CLC
          ADC     #$06
          CMP     SHOTCNT
          BPL     FIREOUT                ;TOO MANY?

          TXA                            ;STACK REGISTERS
          PHA
          TYA
          PHA

          JSR     SETSHOT                ;SET UP SOME SHOT STATE

          LDA     ELYPOS                 ;SET UP FOR AIM ROUTINE
          SEC
          SBC     #$08                   ;ADJUST FOR CENTERING
          BCC     FIRE2OUT               ;SEE IF WE ARE FIRING ACROSS BOTTOM
          STA     TEMP0
          LDA     ELXPOS
          CLC
          ADC     #$05                   ;ADJUST FOR CENTERING
          STA     TEMP2
          LDA     ELYPOS,X
          STA     TEMP1
          LDA     ELXPOS,X
          STA     TEMP3

          JSR     AIM                    ;AIM IT

          LDA     TEMP5
          STA     ELDIR,X
          CLC
          LDA     AIMX,Y                 ;GET SPEED
          ASL     A
          ASL     A
          STA     ELXSPEED,X
          LDA     AIMY,Y
          ASL     A
          ASL     A
          STA     ELYSPEED,X

FIRE2OUT  PLA                            ;UNSTACK REGISTERS
          TAY
          PLA
          TAX
          RTS


SETSHOT   DEC     SHOTCNT                ;DECREMENT SHOTCNT
          LDA     #$04
          STA     PRIORITY
          JSR     LNKINSRT
          JSR     ZEROSHIP

          LDA     #$04
          STA     ELPRIOR,X

          LDA     #$BF                   ;SET UP SOME SHOT STATE
          STA     ELPALW,X               ;STORE PALETTE
          LDA     #ANENSHOT-ANIMTAB+$80  ;SET THE STAMP
          STA     ELANIM,X
          LDA     TEMP14                 ;GET XPOS OF SHIP WHICH IS FIRING
          CLC
          ADC     #$03                   ;CENTER SHOT ON FRONT OF SHIP
          STA     ELXPOS,X
          LDA     TEMP15
          SEC
          SBC     #$0E                   ;SHIP FIRES FROM FRONT
          STA     ELYPOS,X               ;STORE NEW XPOS AND YPOS
          JMP     SHOWSHIP


*  THIS TAKES CARE OF AIMING SOMETHING.
*  INPUT: TARGETY - TEMP0, TARGETX - TEMP2, SOURCEY - TEMP1, SOURCEX - TEMP3
*  OUTPUT: DIRECTION - TEMP5, POINTER TO AIMING TABLES - Y
ENTOSOLV  MOVE    ELYPOS,TEMP1           set up for AIM: enemy to solvalou
          MOVE    ELXPOS,TEMP3
ENTOSOME  MOVE    ELYPOS,X,TEMP0         set up for AIM: enemy to something
          MOVE    ELXPOS,X,TEMP2

AIM       MOVE    #0,TEMP10,TEMP11,TEMP5 ;round-offs, direction initially zero
          LDA     TEMP0                  ;SEE HOW WE COMPARE TO TARGET YPOS
          SEC
          SBC     TEMP1
          BCS     FDSOLVHI
          JSR     INVERT                 ;REVERSE SIGN
          LDY     #$40                   ;SET DIRECTION TO DOWN
          STY     TEMP5

FDSOLVHI                                 ;VERTICAL DELTA
          LSR     A                      ;halve the Y delta to give X a chance
          STA     TEMP13

          SUB     TEMP2,TEMP3,TEMP12     ;horizontal delta
          BCS     FDAIMIT
          JSR     INVERT                 ;REVERSE SIGN
          STA     TEMP12                 ;HORIZONTAL DELTA
          LDA     TEMP5
          EOR     #$80                   ;SHOT IS POINTED LEFT
          STA     TEMP5

FDAIMIT   LDA     TEMP12                 ;SEE IF HORIZONTAL AND VERTICAL DELTAS
          CMP     #$07                   ;  ARE IN RANGE FOR AN 8 BY 8 TABLE
          BCS     FDNARROW
          LDA     TEMP13
          CMP     #$07
          BCC     FDAIMED
FDNARROW  LSR     TEMP12                 ;MAKE HORIZONTAL DELTA SMALLER
          ROR     TEMP10                 ;SAVE THE ROUND OFF
          LSR     TEMP13                 ;MAKE VERTICAL DELTA SMALLER
          ROR     TEMP11                 ;SAVE THE ROUND OFF
          JMP     FDAIMIT

FDAIMED   LDA     TEMP10                 ;FIRST, ADJUST FOR ROUND-OFF
          CMP     #$98
          BCC     FDAVERT
          INC     TEMP12                 ;IF SO, ROUND UP
FDAVERT   LDA     TEMP11
          CMP     #$98
          BCC     FDASVR
          INC     TEMP13

*  TAKE DELTAS IN TEMP13 AND TEMP12 AND CREATE AN INDEX INTO FIRE TABLES THAT
*  IS PUT INTO Y.  THIS IS CALLED EXTERNALLY.
FDASVR    LDA     TEMP13                 ;GET VERTICAL DELTA
          ASL     A
          ASL     A
          ASL     A                      ;BITS 5-3 ARE Y VELOCITY BITS
          EOR     TEMP12                 ;BITS 2-0 ARE X VELOCITY BITS
          TAY                            ;Y IS INDEX INTO AIMING TABLES
          RTS


*  FIRE A SOLVALU BOMB - X DESTROYED
FIREBOMB
          MOVE    #3,PRIORITY
          JSR     GETSHIP                ;GET OUR CLEARED ENTRY
          CPX     #$FF
          BEQ     ZZZFBOUT
          DEC     OBJRESRV               ;WE HAVE USED ONE RESERVED SLOT
          INC     BOMBTRIG               ;INDICATE BOMB BEING FIRED
          LDA     #$01                   ;BOMB SOUND
          JSR     TUNIN

          ADD     ELXPOS,#4,ELXPOS,X
          MOVE    #3,ELPRIOR,X
          MOVE    ELYPOS,ELYPOS,X
          MOVE    #$3F,ELPALW,X
          MOVE    #5,ELCLASS,X
          MOVE    #$1D,ELACCELT,X

          MOVE    #$10,ELWAIT,X
          MOVE    #$06,ELYACCEL,X
          LDA     #ANSOLBOM-ANIMTAB+$80
          STA     ELANIM,X
          LDA     ANSOLBOM
          STA     ELTYPE,X
          LDA     #ACSOLBOM-ACTIONRL
          STA     ELSTATE,X
* Here let the crosshairs mark the ground where the bomb will hit.
          MOVE    #3,PRIORITY            over ground targets
          JSR     GETSHIP                ;GET OUR CLEARED ENTRY
          CPX     #$FF
ZZZFBOUT  BEQ     FBOUT
          MOVE    #$20,ELYSPEED,X        ground scrolling rate
          MOVE    #3,ELPRIOR,X           over ground targets
          MOVE    #$40,ELDIR,X           scrolling down
          MOVE    #$10,ELWAIT,X          same as for bomb
          MOVE    ELYPOS+1,ELYPOS,X      same Y as sight
          MOVE    ELXPOS+1,ELXPOS,X      same X as sight
          MOVE    #$E0+32-3,ELPALW,X
          LDA     #ANSIGHT2-ANIMTAB+$80
          STA     ELANIM,X
          LDA     ANSIGHT2
          STA     ELTYPE,X
          LDA     #ACSIGHT2-ACTIONRL
          STA     ELSTATE,X
          LDA     #ANSIGHT2-ANIMTAB+$80
          STA     ELANIM+1               sight loses its frame
          LDA     ANSIGHT2
          STA     ELTYPE+1
          LDA     #32-3              this pal has C2 = white
          STA     ELPALW+1
FBOUT     RTS


*  FIRE A SOLVALU SHOT
FIRESHOT  MOVE    #$01,OLDSBUTT          ;INDICATE BUTTON HAS BEEN DEPRESSED
          MOVE    #$0C,SHOTFRM           ;HOW MANY TICS TILL NEXT SHOT
;         LDA     SHOTTRIG
;         BNE     FSDOSHOT

          LDA     #$00                   ;SHOT SOUND IF IT IS FIRST
          JSR     TUNIN

FSDOSHOT
          MOVE    #$03,PRIORITY
          JSR     GETSHIP                ;GET CLEARED SHIP ENTRY
          CPX     #$FF
          BEQ     FSOUT
          DEC     OBJRESRV               ;WE HAVE USED ONE RESERVED SLOT

          MOVE    #$03,ELPRIOR,X

*         LDA     #$03
          STA     ELANIMT,X
          MOVE    ELXPOS,ELXPOS,X
          MOVE    ELYPOS,ELYPOS,X
          MOVE    #$3D,ELPALW,X
          MOVE    #$FF,ELWHICH,X         ;NEG MEANS SOLVALU SHOT
          MOVE    #$04,ELCLASS,X
          MOVE    #$C0,ELYSPEED,X
          LDA     #ANSOLS-ANIMTAB
          STA     ELANIM,X
          LDA     ANSOLS
          STA     ELTYPE,X
          LDA     #ACSOLS-ACTIONRL
          STA     ELSTATE,X
          INC     SHOTTRIG
FSOUT     RTS


*  RANDOM NUMBER GENERATOR - BOTH MAKES A NEW ONE AND LEAVES IT IN A
RANDOM    ADC     FRMCNT                 ;MAKE A PRETTY RANDOM VALUE
          EOR     ELYPOS
          EOR     ELXPOS
          ADC     RNDM
          ADC     RNDM+1
          ROL     A
          PHA
          LDA     RNDM                   ;BACK UP NEWRAND
          STA     RNDM+1
          PLA
          STA     RNDM                   ;NEW VALUE - LEFT IN A
          RTS


* TEST IF ENEMY SHIP IS NEAR HORIZONTAL POSITION OF HERO
MSCHECKY  LDA     ELYPOS,X
          SEC
          SBC     ELYPOS
          BPL     MSCYYES
          JSR     INVERT
MSCYYES   CMP     #$30                   ;48 PIXEL MARGIN
          BCS     MSCYNO
          LDA     #$1                    ;RETURN NONZERO VALUE
          RTS
MSCYNO    LDA     #$0                    ;TEST FAILS; RETURN ZERO
          RTS


* DELETE A SHIP FROM THE ENEMY LIST BY REPLACING IT WITH THE LAST ENTRY
* IN THE LIST.
*  THIS ROUTINE SHOULD BE THE LAST CODE CALLED PRIOR TO RETURNING TO THE
*  TOP-LEVEL MOVESHIP/MOVESHOT SINCE IT ADJUSTS THE X REGISTER TO MAKE SURE
*  NO-ONE GETS NEGLECTED AFTER A COMPACTION.
MSDELETE
          LDA     ELPRIOR,X
          CMP     #$04
          BEQ     DELSHOT

DELSHIP   LDA     ELWHICH,X              ;CHECK IF OBJECT IS SOLVALOU SHOT
          CMP     #$FF
          BNE     DSNOSOLS
          DEC     SHOTTRIG               ;ALLOW ANOTHER SHOT
          INC     OBJRESRV               ;UNDO THE RESERVATION

DSNOSOLS  DEC     OBJCNT                 ;POINT TO LAST SHIP IN LIST
          DEC     OBJRESRV               ;SHOULD HAVE BEEN INCD IF DEL RESERVED
          CMP     #$11
          BNE     ITSOKNOW
          LDA     #MAMATUNE              ;;;
          JSR     SCRAPONE               ;;;
ITSOKNOW  JSR     LNKDELET
          RTS

DELSHOT
          INC     SHOTCNT
          JSR     LNKDELET
          RTS




*  THIS ROUTINE SIMPLY INVERTS THE ACCUMULATOR (2'S COMPLEMENT)
INVERT    EOR     #$FF
          CLC
          ADC     #$01
          RTS


***** ANIMATION ROUTINES

*  ANIMATE A SHIP
MSANIMAT  LDY     ELANIM,X               ;SEE IF HI ANIMATION BIT ON
          BMI     MSAOUT
          DEC     ELANIMT,X              ;SEE IF IT IS TIME YET
          BPL     MSAOUT
          INY                            ;GO TO NEXT ANIMATION
          LDA     ANIMTAB,Y
          CMP     #$F8                   ;SEE IF IT IS A RESET BYTE
          BCC     MSASHOW
          ADC     ELANIM,X               ;CARRY SET
          TAY
          LDA     ANIMTAB,Y              ;GET REAL DATA

MSASHOW   STA     ELTYPE,X               ;STORE STAMP
          TYA                            ;6502 SUX
          STA     ELANIM,X               ;STORE NEXT ANIMATION POINTER
          LDY     ELWHICH,X              ;SET ANIMATION TIME
          LDA     ANIMTIME,Y
          STA     ELANIMT,X

MSAOUT    RTS


*  GIVEN AN ANIMATION, PUT A PICTURE OF THE SHIP UP - SMASHES Y
SHOWSHIP  LDA     ELANIM,X               ;GET THE ANIMATION OFFSET
          AND     #$7F                   ;GET RID OF ENABLE BIT
          TAY
          LDA     ANIMTAB,Y              ;GET THE LOW BYTE OF STAMP
          STA     ELTYPE,X               ;STORE IT FOR THE LOADER
          RTS


*  GET THE INDEX FOR A SHIP
*         OUTPUT:  SHIP INDEX IN X, SHIP IS INITIALLY ZEROED
*                  $FF IN X IF NO ROOM IN THE INN
GETSHIP   LDA     OBJRESRV
          CLC
          ADC     #$01
          CMP     SHOTCNT
          BMI     GSOK
          LDX     #$FF                   ;NO ROOM
ZGETSOUT
          RTS
GSOK
;         LDA     #$03
;         STA     PRIORITY
          JSR     LNKINSRT
          CPX     #$FF
          BEQ     ZGETSOUT
          INC     OBJCNT                 ;INCREMENT THE OBJECT COUNT
          INC     OBJRESRV               ;THIS SHOULD BE DECD IF RESERVED


*  CLEAR OUT THE SHIP IN X
ZEROSHIP  LDA     #$00
          STA     ELDIR,X
          STA     ELXSPEED,X
          STA     ELYSPEED,X
          STA     ELXPOS,X
          STA     ELYPOS,X
          STA     ELXACCEL,X
          STA     ELYACCEL,X
          STA     ELACCELT,X
          STA     ELWHICH,X
          STA     ELTYPE,X
          STA     ELCLASS,X
          STA     ELANIMT,X
          RTS



N         EQU     8
D         EQU     9

* THIS TABLE IS USED TO TRANSLATE AN AIM INTO X AND Y OFFSETS
AIMX      DB    N*$00,N*$17/D,N*$17/D,N*$17/D,N*$17/D,N*$17/D,N*$17/D,N*$17/D
          DB    N*$00,N*$0D/D,N*$13/D,N*$15/D,N*$16/D,N*$16/D,N*$17/D,N*$17/D
          DB    N*$00,N*$08/D,N*$0D/D,N*$11/D,N*$13/D,N*$14/D,N*$15/D,N*$16/D
          DB    N*$00,N*$05/D,N*$09/D,N*$0D/D,N*$10/D,N*$12/D,N*$13/D,N*$14/D
          DB    N*$00,N*$04/D,N*$08/D,N*$0B/D,N*$0D/D,N*$0F/D,N*$11/D,N*$12/D
          DB    N*$00,N*$03/D,N*$06/D,N*$09/D,N*$0B/D,N*$0D/D,N*$0F/D,N*$10/D
          DB    N*$00,N*$02/D,N*$05/D,N*$08/D,N*$0A/D,N*$0C/D,N*$0D/D,N*$0E/D
          DB    N*$00,N*$01/D,N*$04/D,N*$07/D,N*$09/D,N*$0B/D,N*$0C/D,N*$0D/D

AIMY      DB    N*$20/D,N*$00/D,N*$00/D,N*$00/D,N*$00/D,N*$00/D,N*$00/D,N*$00/D
          DB    N*$20/D,N*$1B/D,N*$13/D,N*$0E/D,N*$0B/D,N*$09/D,N*$08/D,N*$07/D
          DB    N*$20/D,N*$1D/D,N*$1B/D,N*$17/D,N*$13/D,N*$10/D,N*$0E/D,N*$0C/D
          DB    N*$20/D,N*$1F/D,N*$1D/D,N*$1B/D,N*$18/D,N*$15/D,N*$13/D,N*$11/D
          DB    N*$20/D,N*$20/D,N*$1E/D,N*$1C/D,N*$1B/D,N*$19/D,N*$16/D,N*$14/D
          DB    N*$20/D,N*$20/D,N*$1F/D,N*$1D/D,N*$1C/D,N*$1B/D,N*$19/D,N*$17/D
          DB    N*$20/D,N*$20/D,N*$1F/D,N*$1E/D,N*$1D/D,N*$1C/D,N*$1B/D,N*$19/D
          DB    N*$20/D,N*$20/D,N*$20/D,N*$1F/D,N*$1E/D,N*$1D/D,N*$1C/D,N*$1B/D


*  ANIMATION TIMES
          DB      $03                    ;SOLVALU SHOT IS FF
ANIMTIME  DB      $03,$03,$01,$01,$01,$01,$02,$02
          DB      $03,$01,$02,$02,$02,$00,$00,$00
          DB      $00,$00,$01,$01,$00,$00,$00,$00
          DB      $02,$02,$00,$00,$00,$02,$02,$02
          DB      $03

*  ANIMATION TABLES
ANIMTAB
ANSOLVAL  DB      L(CSOLVALU)
ANSOLSIT  DB      L(CSIGHT)
ANSIGHT2  DB      L(CSIGHT2)
ANENSHOT  DB      L(CSHOT)
ANSOLBOM  DB      L(CSOLBOMB)
ANSOLS    DB      L(CSSHOT0),L(CSSHOT0+3),-2
ANBACULA  DB      L(CBACULA),L(CBACULA+$04),L(CBACULA+$08),L(CBACULA+$0C),-4
ANZAKATO  ;DB      L(CZAKATO),L(CZAKATO+$01),L(CZAKATO+$02),-1
ANBZAKAT  DB      L(CZAKATO),L(CZAKATO+$01),L(CZAKATO+$02),-1   ;;;
ANGZAKAT  DB      L(CGZAKATO),-1
ANTOROID  DB      L(CTOROID),L(CTOROID+$02),L(CTOROID+$04),L(CTOROID+$06),-4
ANTORKAN  DB      L(CTORKAN),L(CTORKAN+$03),L(CTORKAN+$06),L(CTORKAN),-1
ANFLUFF   DB      L(CFLUFF0),L(CFLUFF0+1),-2
ANZOSHI   DB      L(CZOSHI),L(CZOSHI+$03),L(CZOSHI+$06),L(CZOSHI+$09),-4
ANJARA    DB      L(CJARA),L(CJARA+$03),L(CJARA+$06),L(CJARA+$09),-4
ANKAPI    DB      L(CKAPI),L(CKAPI+$03),L(CKAPI+$06),L(CKAPI+$09),-1
ANTERAZI  DB      L(CTERRAZI),L(CTERRAZI+$03),L(CTERRAZI+$06),L(CTERRAZI+9),-1
ANEXPLOS  DB      L(CAIREXP),L(CAIREXP+$03),L(CAIREXP+$06),L(CAIREXP+$09),-1
ANFLFEXP  DB      L(CFLFEXP0),L(CFLFEXP0+$03),-1
ANTRACER  DB      L(CFLUFF0),-1 ;L(CSHOT),L(CFLUFF0),L(CFLUFF0+1),-3
ANESCIN1  DB      L(SHE1),L(SHE2),L(SHE3),L(SHE4),-4     coming in
ANESCIN0  DB      L(SHE1),L(SHE4),L(SHE3),L(SHE2),-4     coming in
ANESCOR0  DB      L(SHE3),L(SHE5A),L(SHE6A),-1   0    flipping sideways
ANMATING  DB      L(SHE3),-1                     0    mating
ANESCOR1  DB      L(SHE3),L(SHE5B),L(SHE6B),-1   1    flipping sideways
ANTANK    DB      L(CTANK0),L(CTANK1),-2

*  ACTION ROUTINE TABLES, BASICALLY A FINITE STATE MACHINE
ACTIONRL  DB      L(NULLSTAT)
ACSOLVAL  DB      L(SOLVALUA)
ACSOLBOM  DB      L(SOLVBOMB)
ACSOLS    DB      L(SOLVSHOT)
ACSIGHT2  DB      L(SOLVSITE)
TANKRB    DB      L(TANKUP),L(WAITDOWN)
TANKRD    DB      L(TANKSLOW)
TANKRS    DB      L(TANKSTOP),L(WAITDOWN)
TANKRW    DB      L(TANKWOW),L(TANKDEAD)
TANKRZ    DB      L(TANKZIP),L(TANKDEAD)
ACTOROID
ACJARA    DB      L(CHECKX),L(ANIMATE),L(JTREVSEX),L(SETWAIT),L(WAIT)
          DB      L(TRSHFIRE),L(NULLSTAT)
ACTORKAN  DB      L(WAIT),L(STOP),L(SETWAIT),L(WAIT),L(ANIMATE),L(ONCEFIRE)
          DB      L(SETWAIT),L(WAIT),L(ZIPOFF),L(NULLSTAT)
          DB      L(CHECKX),L(ONCEFIRE),L(ZOSHDIR),L(NULLSTAT)    ;ZOSHI STATES
ACZOSHI   DB      L(SETWAIT),L(WAIT),L(ZOSHSET),L(CHECKY),L(ZOSHBACK)
ACZAKATO  DB      L(WAIT),L(BALLFIRE)
ACBZAKAT  DB      L(SETWAIT),L(WAIT),L(WALLFIRE)
ACGZAKAT  DB      L(SETWAIT),L(WAIT),L(ALLFIRE)
ACKAPI
ACTERAZI  DB      L(CHECKX),L(ANIMATE),L(REVRSALL),L(CONTFIRE)
ACEXPLOS  DB      L(SETWAIT),L(WAIT),L(GOAWAY)
ACTRACER  DB      L(TRACEOUT),L(TRACERM),L(TRACEOFF)
ACCRATER  DB      L(SETWAIT),L(WAIT),L(CRATDOWN),L(NULLSTAT)
ACSOLDED  DB      L(WAIT),L(DYING),L(ENDPTURN)
ACMOMMY   DB      L(SETWAIT),L(WAIT),L(FLIPMOM),L(WAIT),L(SETWAIT),L(WAIT)
          DB      L(FLYMOM),L(NULLSTAT)
ACMIDMOM  DB      L(MOMFIRE)
ACESCOR0  DB      L(ESCORTIN),L(ESCWAIT),L(FLIPLEFT),L(ESCWAIT),L(MATE0)
          DB      L(ESCORTGO)
ACESCOR1  DB      L(ESCORTIN),L(ESCWAIT),L(FLIPRITE),L(ESCWAIT),L(MATE1)

ACTIONRH  DB      H(NULLSTAT)
          DB      H(SOLVALUA)
          DB      H(SOLVBOMB)
          DB      H(SOLVSHOT)
          DB      H(SOLVSITE)
          DB      H(TANKUP),H(WAITDOWN)
          DB      H(TANKSLOW)
          DB      H(TANKSTOP),H(WAITDOWN)
          DB      H(TANKWOW),H(TANKDEAD)
          DB      H(TANKZIP),H(TANKDEAD)
          DB      H(CHECKX),H(ANIMATE),H(JTREVSEX),H(SETWAIT),H(WAIT)
          DB      H(TRSHFIRE),H(NULLSTAT)
          DB      H(WAIT),H(STOP),H(SETWAIT),H(WAIT),H(ANIMATE),H(ONCEFIRE)
          DB      H(SETWAIT),H(WAIT),H(ZIPOFF),H(NULLSTAT)
          DB      H(CHECKX),H(ONCEFIRE),H(ZOSHDIR),H(NULLSTAT) ; ZOSHI STATES
          DB      H(SETWAIT),H(WAIT),H(ZOSHSET),H(CHECKY),H(ZOSHBACK)
          DB      H(WAIT),H(BALLFIRE)
          DB      H(SETWAIT),H(WAIT),H(WALLFIRE)
          DB      H(SETWAIT),H(WAIT),H(ALLFIRE)
          DB      H(CHECKX),H(ANIMATE),H(REVRSALL),H(CONTFIRE)
          DB      H(SETWAIT),H(WAIT),H(GOAWAY)
          DB      H(TRACEOUT),H(TRACERM),H(TRACEOFF)
          DB      H(SETWAIT),H(WAIT),H(CRATDOWN),H(NULLSTAT)
          DB      H(WAIT),H(DYING),H(ENDPTURN)
          DB      H(SETWAIT),H(WAIT),H(FLIPMOM),H(WAIT),H(SETWAIT),H(WAIT)
          DB      H(FLYMOM),H(NULLSTAT)
          DB      H(MOMFIRE)
          DB      H(ESCORTIN),H(ESCWAIT),H(FLIPLEFT),H(ESCWAIT),H(MATE0)
          DB      H(ESCORTGO)
          DB      H(ESCORTIN),H(ESCWAIT),H(FLIPRITE),H(ESCWAIT),H(MATE1)

CSANIM    DB      ANBACULA-ANIMTAB,ANBACULA-ANIMTAB,ANZAKATO-ANIMTAB
          DB      ANZAKATO-ANIMTAB,ANBZAKAT-ANIMTAB+$80,ANGZAKAT-ANIMTAB+$80
          DB      ANTOROID-ANIMTAB+$80,ANTORKAN-ANIMTAB+$80,ANFLUFF-ANIMTAB
          DB      ANZOSHI-ANIMTAB,ANJARA-ANIMTAB+$80,ANKAPI-ANIMTAB+$80
          DB      ANTERAZI-ANIMTAB+$80,$00,$00
          DB      $00,$00,$00
          DB      ANESCIN0-ANIMTAB,ANESCIN1-ANIMTAB,$00
          DB      ANTANK-ANIMTAB+$80

CSSTATE   DB      ACTIONRL-ACTIONRL,ACTIONRL-ACTIONRL,ACZAKATO-ACTIONRL
          DB      ACZAKATO-ACTIONRL,ACBZAKAT-ACTIONRL,ACGZAKAT-ACTIONRL
          DB      ACTOROID-ACTIONRL,ACTORKAN-ACTIONRL,ACTIONRL-ACTIONRL
          DB      ACZOSHI-ACTIONRL,ACJARA-ACTIONRL,ACKAPI-ACTIONRL
          DB      ACTERAZI-ACTIONRL,ACMOMMY-ACTIONRL,ACMIDMOM-ACTIONRL
          DB      ACTIONRL-ACTIONRL,ACMIDMOM-ACTIONRL,ACTIONRL-ACTIONRL
          DB      ACESCOR0-ACTIONRL,ACESCOR1-ACTIONRL,ACTIONRL-ACTIONRL
          DB      ACTIONRL-ACTIONRL

BOTMOVE
ASKNOLY   EQU     ACCRATER-ACTIONRL
ASKNOLY0  EQU     ACSOLDED-ACTIONRL
ASKNOLY2  EQU     ACEXPLOS-ACTIONRL
ASKNOLY4  EQU     ACEXPLOS-ACTIONRL
ASKNOLY5  EQU     ACSOLVAL-ACTIONRL
ASKNOLY1  EQU     ANFLFEXP-ANIMTAB
ASKNOLY3  EQU     ANEXPLOS-ANIMTAB
ASKNOLY6  EQU     ANSOLVAL-ANIMTAB
ASKNOLY7  EQU     ANSOLSIT-ANIMTAB
TNKRSTOP  EQU     TANKRS-ACTIONRL        react by stopping
TNKRSLOW  EQU     TANKRD-ACTIONRL        react by going down
TNKRBACK  EQU     TANKRB-ACTIONRL        react by backing up, then going down
TNKRZIP   EQU     TANKRZ-ACTIONRL        react by zipping down (10,000?)
TNKRWOW   EQU     TANKRW-ACTIONRL
          END
