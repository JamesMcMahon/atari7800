;PLAYER JOYSTICK MOVEMENT CONTROL
WLIM      EQU     MINX
ELIM      EQU     MAXX-5                 ;CHANGED FROM 135       DVP
                                         ;CHANGED BACK TO 135 FROM 136  11/29
TOPLIM    EQU     144
BOTLIM    EQU     184

JOYSTICK  LDA     SHTRTIMR
          BEQ     SKPJOY1
ENDOFJOY  RTS

SKPJOY1   LDA     GAMETYPE               ;IS THIS A 2 PLAYER SIMULTANEOUS OR
          CMP     #2                     ;   TEAM PLAY GAME?
          BCC     HAVEJOY                ;NO, PROCEED NORMALLY

          LDA     #0                     ;PLR 1 FIRST
          STA     PLAYER
          BIT     SHTRSTAT+1             ;ONLY PLR 1 IF 2 GAME OVER
          BVS     HAVEJOY
          BIT     SHTRSTAT               ;ONLY PLR 2 IF 1 GAME OVER
          BVS     JOYPL2

          JSR     HAVEJOY                ;RUN JOYSTICK CODE FOR PLR 1 THEN 2
JOYPL2    INC     PLAYER

HAVEJOY   BIT     ATTRACT
          BMI     ENDOFJOY               ;RTS
          BVS     SKPJOY2
          JMP     NRMLJOYS

******************************************
* ATTRACT MODE MOVEMENT
******************************************
SKPJOY2   LDX     PLAYER                 ;INCREMENT THE ATTRACT MODE GAME TIMER
          LDA     FRMCNT                 ;   EVERY SECOND OR SO
          AND     #$3F
          BNE     SKPCRSEC
          LDA     ATGMTMR
          AND     #$7F
          CMP     #$7F
          BEQ     SKPCRSEC
          INC     ATGMTMR

SKPCRSEC  DEC     ATSITTMR,X             ;COUNT FOR MOTION
          BNE     CHKMVMNT
          LDA     #$80
          STA     ATSITTMR,X             ;RESET MOTION COUNT
          LDA     ATGMTMR,X              ;FLIP MOTION FLAG
          EOR     #$80
          STA     ATGMTMR,X

CHKMVMNT  LDA     ATGMTMR,X
          BPL     YESMOVE
          JMP     ENDATJOY               ;MOVING IF BIT 7 = 0
YESMOVE   LDX     PLAYER                 ;MOVE HORIZONTALLY ON EVERY OTHER
          LDA     SHOOTERY,X             ;   VERTICAL MOVEMENT
          AND     #$01
          BEQ     NOEWCHNG

* CHECK FOR LEFT/RIGHT MOVEMENT IN ATTRACT MODE
          LDA     #0
          LDY     ATTSHTRX,X
          BMI     SKPXADJ
          LDA     #4
SKPXADJ   CLC
          ADC     SHOOTERX,X
          STA     GTEMP1
          LDA     SHOOTERY,X
          ADC     #4
          JSR     OBSTAC
          BNE     NOEWCHNG

          JSR     BUMPEW                 ;OTHER PLAYER IN THE WAY?
          BEQ     NOATBMPE
          STA     GTEMP1
          LDA     ATTSHTRX,X
          BPL     ATTEAST
          LDA     GTEMP1
          EOR     #$FF
          CLC
          ADC     #1
          JMP     ATTEW
ATTEAST   LDA     GTEMP1
ATTEW
          CMP     #-4
          BCS     NOEWCHNG               ;YES, OTHER PLAYER THERE

NOATBMPE  JSR     STOPRES
          LDA     SHOOTERX,X
          CLC
          ADC     ATTSHTRX,X
          STA     SHOOTERX,X
          CMP     #ELIM
          BCS     CHNGEWDR
          CMP     #WLIM+1
          BCS     NOEWCHNG

CHNGEWDR  LDA     ATTSHTRX,X
          EOR     #$FF
          CLC
          ADC     #1
          STA     ATTSHTRX,X

* CHECK FOR UP/DOWN MOVEMENT IN ATTRACT MODE
NOEWCHNG
          LDA     SHOOTERX,X
          CLC
          ADC     #2
          STA     GTEMP1
          LDA     #5
          LDY     ATTSHTRY,X
          BPL     SKPYADJ
          LDA     #3
SKPYADJ ; CLC
          ADC     SHOOTERY,X
          JSR     OBSTAC
          BNE     ENDATJOY

          JSR     BUMPNS                 ;OTHER PLAYER IN THE WAY?
          BEQ     NOATBMPS
          STA     GTEMP1
          LDA     ATTSHTRY,X
          BPL     ATTSOUTH
          LDA     GTEMP1
          EOR     #$FF
          CLC
          ADC     #1
          JMP     ATTNS
ATTSOUTH  LDA     GTEMP1
ATTNS
          CMP     #-5
          BCS     ENDATJOY

NOATBMPS  JSR     STOPRES
          LDA     SHOOTERY,X
          CLC
          ADC     ATTSHTRY,X
          STA     SHOOTERY,X
          CMP     #TOPLIM+1
          BCC     CHNGVDIR
          CMP     #BOTLIM
          BCC     ENDATJOY

CHNGVDIR  LDA     ATTSHTRY,X
          EOR     #$FF
          CLC
          ADC     #1
          STA     ATTSHTRY,X

ENDATJOY  LDA     SHOTSTAT,X
          LSR     A
          BCS     NOADJSHT               ;SHOT HAS BEEN FIRED
          LDA     SHOOTERX,X
;         CLC
          ADC     #2
          STA     SHOTX,X
          LDA     SHOOTERY,X
;         CLC
          ADC     #-1
          STA     SHOTY,X
NOADJSHT  RTS

******************************************
* GAME PLAY MOVEMENT
******************************************
NRMLJOYS  LDA     #0
          STA     CRAP
          LDX     PLAYER
          LDA     TRACKF,X
          BEQ     NRML
TRK2P                                    ;X COMING IN HERE IS NOT NECC. PLAYER
          LDA     DELTAY,X               ;SHADOW THESE FOR TWO PLAYER WEIRDNESS
          JSR     SCALE
          STA     TTEMP2
          LDA     DELTAX,X
          BEQ     NORTACK                ;THIS BRANCH PREVENTS DE-REZZING
          JSR     SCALE
          STA     TTEMP1
          LDX     PLAYER
          TAY                            ;SET FLAGS
          BPL     EAST
          JMP     WEST

NORTACK   LDA     TTEMP2
          BEQ     ENDATJOY               ;THIS BRANCH PREVENTS DE-REZZING
          BMI     JNORTH
          JMP     SOUTH
JNORTH    JMP     NORTH

;          LDA     SHOOTERX,X
;          CLC
;          ADC     GTEMP1
;          CMP     #WLIM
;          BCS     CKMO
;          LDA     #WLIM
;          BNE     STSHX
;CKMO      CMP     #ELIM
;          BCC     STSHX
;          LDA     #ELIM-1
;STSHX
;          STA     SHOOTERX,X


;YCALC     LDA     SHOOTERY,X
;          CLC
;          ADC     GTEMP2
;          CMP     #TOPLIM
;          BCS     CKMOR
;          LDA     #TOPLIM
;          BNE     STSHY
;CKMOR     CMP     #BOTLIM
;          BCC     STSHY
;          LDA     #BOTLIM
;STSHY
;          STA     SHOOTERY,X
;JMEAT     JMP     ENDATJOY

NRML      ;WATCH OUT FOR MAJOR KLUDGE HERE
          LDA     TRACKF                 ;IF THERE WASN'T A TRACKBALL IN 0
          BEQ     REALN                  ;NO NEED TO DO KLUDGOMATIC
          CPX     #1
          BNE     REALN
          LDA     ALTCTRLS               ;DOES S/HE REALLY WANT TO SWAP?
          CMP     #1
          BNE     REALN
          LDA     BUTNIB                 ;COERCE FIRING FOR PLAYER2 FROM JACK0
          STA     BUTNIB+1
          LDA     #1
          STA     CRAP
          LDX     #0                     ;COERCE FIRST TRACKBALL FOR TWO PLAY
          BEQ     TRK2P

REALN     LDA     FRMCNT
          AND     #1
          STA     GTEMP5
          LDA     #0
          STA     CTLSWA
          LDA     SWCHA
          LDX     PLAYER
          BNE     PLAY1
          AND     #$F0
          BNE     STCTL                  ;JMP
PLAY1     ASL     A
          ASL     A
          ASL     A
          ASL     A
STCTL     STA     GTEMP2
          ASL     A
          BCC     EAST
          ASL     A
          BCS     BLAH1
          JMP     WEST
BLAH1     ASL     A
          BCS     BLAH
          JMP     SOUTH
BLAH      ASL     A
          BCS     STOP
          JMP     NORTH
STOP      LDA     #1
          STA     AXCOUNT,X
          LDA     SHOOTERX,X
          SEC
          SBC     #16

          LSR     A
          BCS     GOONA
          LSR     A
          BCS     GOONA                  ;NOT EVENLY DIVISABLE BY FOUR
          LDA     #0
          STA     AXCOUNT,X
RETJOY    RTS
GOONA     LDA     SHTRSTAT,X
          AND     #$20
          BEQ     WEST


******************************************
EAST      LDA     #5                     ;IS A MUSHROOM THERE?
          LDY     #5
          JSR     CHECKMSH
          BNE     NORTE                  ;YES, MUSHROOM IN THE WAY

          LDA     SHTRSTAT,X
          AND     #$20
          BNE     ARCLEAR                ;GOING EAST LAST TIME
          LDA     #0
          STA     AXCOUNT,X              ;IF YOU WERE GOING WEST CLEAR ACCEL
          LDA     SHTRSTAT,X
          ORA     #$20
          STA     SHTRSTAT,X             ;SET EAST BIT

ARCLEAR   JSR     ACCEL                  ;DEAL WITH ACCELERATION
          JSR     BUMPEW                 ;OTHER PLAYER IN THE WAY?
          BEQ     NOBMPE
          CLC
          ADC     GTEMP6
          CMP     #-4
          BCS     NORTE                  ;YES, OTHER PLAYER THERE

NOBMPE    LDA     GTEMP6
          CLC
;;;;;     LDX     PLAYER
          ADC     SHOOTERX,X
          CMP     #ELIM
          BCC     STOX                   ;NOT AT LIMIT, STORE
          LDA     #ELIM
STOX      JMP     STOXW

******************************************
WEST      LDA     #0                     ;IS MUSHROOM IN THE WAY?
          LDY     #5
          JSR     CHECKMSH
          BNE     NORTE                  ;YES, MUSHROOM THERE

          LDA     SHTRSTAT,X
          AND     #$20
          BEQ     ACLEAR                ;GOING WEST LAST TIME
          LDA     #0
          STA     AXCOUNT,X              ;IF YOU WERE GOING EAST CLEAR ACCEL
          LDA     SHTRSTAT,X
          AND     #$DF
          STA     SHTRSTAT,X             ;CLEAR WEST BIT

ACLEAR    JSR     ACCEL                  ;DEAL WITH ACCELERATION
          JSR     BUMPEW                 ;OTHER PLAYER IN THE WAY?
          BEQ     NOBMPW
          SEC
          SBC     GTEMP6
          CMP     #4
          BCC     NORTE

NOBMPW
;;;;;     LDX     PLAYER
          LDA     SHOOTERX,X
          SEC
          SBC     GTEMP6
          CMP     #WLIM
          BCS     STOXW                  ;NOT AT LIMIT, STORE
          LDA     #WLIM
STOXW     STA     SHOOTERX,X
          JSR     STOPRES

NORTE     LDA     TRACKF,X
          BNE     JNRTE
          LDA     CRAP
          BEQ     NORAE
JNRTE     JMP     NORTACK

NORAE     LDA     GTEMP2
          ASL     A
          ASL     A
          ASL     A
          BCC     SOUTH
          ASL     A
          BCC     NORTH
;NO MORE  MOVEMENT
          JMP     ENDATJOY               ;ADJUST SHOT POSITION


******************************************
SOUTH     LDA     #2                     ;IS MUSHROOM IN THE WAY?
          LDY     #5
          JSR     CHECKMSH
          BNE     RETS                   ;YES, MUSHROOM THERE

          JSR     BUMPNS                 ;OTHER PLAYER IN THE WAY?
          BEQ     NOBMPS
          CMP     #-6
          BCS     RETS

NOBMPS    JSR     VMOVER                 ;DEAL WITH TRACKBALL
          BNE     GAGA



          LDY     SHOOTERY,X
          INY
          INY
GAGA      CPY     #BOTLIM
          BCC     STXYPOS
          LDY     #BOTLIM
STXYPOS   JMP     STYPOS

******************************************
NORTH     LDA     #2                     ;IS MUSHROOM IN THE WAY?
          LDY     #3
          JSR     CHECKMSH
          BNE     RETS                   ;YES, MUSHROOM THERE

          JSR     BUMPNS                 ;OTHER PLAYER IN THE WAY?
          BEQ     NOBMPN
          CMP     #7
          BCC     RETS
NOBMPN    JSR     VMOVER                 ;DEAL WITH TRACKBALL MOVEMENT
          BNE     GOOGOO
          LDY     SHOOTERY,X
          DEY
          DEY
GOOGOO    CPY     #TOPLIM
          BCS     STYPOS
          LDY     #TOPLIM
STYPOS    STY     SHOOTERY,X
          JSR     STOPRES
RETS      JMP     ENDATJOY               ;ADJUST SHOT POSITION



CHECKMSH
          CLC
          ADC     SHOOTERX,X
          STA     GTEMP1
          TYA
;;;;;     CLC
          ADC     SHOOTERY,X
          JSR     OBSTAC
          RTS



BUMPNS
          LDX     PLAYER
          LDY     #$FF                   ;FLAG FOR NO BUMP
          LDA     SHTRSTAT
          AND     SHTRSTAT+1
          BPL     ENDBUMP

          LDA     SHOOTERX
          SEC
          SBC     SHOOTERX+1
          BPL     ABSBUMP
          EOR     #$FF
          CLC
          ADC     #1
ABSBUMP   CMP     #4
          BCS     ENDBUMP

          TXA
          EOR     #1
          TAY
          LDA     SHOOTERY,X
          SEC
          SBC     SHOOTERY,Y
ENDBUMP   CPY     #$FF
          RTS



BUMPEW
          LDX     PLAYER
          LDY     #$FF                   ;FLAG FOR NO BUMP
          LDA     SHTRSTAT
          AND     SHTRSTAT+1
          BPL     ENDBUMP

          LDA     SHOOTERY
          SEC
          SBC     SHOOTERY+1
          BPL     ABSBMPEW
          EOR     #$FF
          CLC
          ADC     #1
ABSBMPEW  CMP     #5
          BCS     ENDBUMP

          TXA
          EOR     #1
          TAY
          LDA     SHOOTERX,X
          SEC
          SBC     SHOOTERX,Y
          CPY     #$FF
          RTS



******************************************
* ACCEL -- DEAL WITH SHOOTER ACCELERATION
* RETURNS WITH NUMBER OF PIXELS TO MUSH IN GTEMP6
******************************************
ACCEL     LDA     TRACKF,X
          BNE     THETHE
          LDA     CRAP
          BNE     THETHE
          LDY     PLAYER
          LDX     AXCOUNT,Y
          LDA     GTEMP5
          BNE     SKIPP

          INX
          CPX     #$10
          BNE     NORM
          DEX                            ;PEG IT AT F
NORM      TXA
          STA     AXCOUNT,Y
SKIPP     TXA
          ASL     A
          ORA     GTEMP5
          TAX
          LDA     ADDTABL,X
          STA     GTEMP6
          RTS
THETHE    LDA     TTEMP1
          BPL     STGT6
          EOR     #$FF                   ;MAKE THE ABSOLUTE VALUE HO HO
          CLC
          ADC     #1
STGT6     STA     GTEMP6
          LDX     PLAYER
          RTS



ADDTABL   DB      1,0                    ;0
          DB      0,1                    ;1
          DB      1,0                    ;2
          DB      1,1                    ;3
          DB      1,1                    ;4
          DB      1,1                    ;5
          DB      2,1                    ;6
          DB      1,2                    ;7
          DB      2,1                    ;8
          DB      1,2                    ;9
          DB      2,2                    ;10
          DB      2,2                    ;11
          DB      2,2                    ;12
          DB      2,2                    ;13
          DB      2,3                    ;14
          DB      3,2                    ;15
          DB      2,3                    ;16
VMOVER    LDX     PLAYER
          LDA     TRACKF,X
          BNE     DOTHE
          LDA     CRAP
          BEQ     RETSE                  ;NO TRACKB THIS TIME
DOTHE
          LDA     SHOOTERY,X
          CLC
          ADC     TTEMP2
          TAY
          LDA     #1                     ;CLR ZFLAG
RETSE     RTS                            ;ZFLAG APP SET

