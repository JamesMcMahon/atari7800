;                 ***** ROVERS ******
*GROUND MOVEMENT  SUBROUTINES

          ZEROPAGE
          PUBLIC  HYBCOLLD
          PUBLIC  MOVEGND
          PUBLIC  ROVXSPD,ROVYSPD
          PUBLIC  CONSTANT               <groan>
          EXTRN   RANDOM,ROVDIFTB,DIFCULTY
          EXTRN   ZNODOMEC
          EXTRN   GNDMOTN,GNDMOTN2,RACK
          MOMGLBL
          TANKGLBL
          FLUFGLBL                       main
          ANIMGLBL                       movement
          ASKGLBL
          ELGLBL
          TUNEGLBL
          EXTRN   AIREXPQ

****************** CONSTANTS
CONSTANT  EQU     $04                    give.  me.  a.  break.   --NA

******************************************
CODE9000  CSECT
MOVEGND
          JSR     MSMOTION               ;MOVE  THAT BABY!

          DEC     ELACCELT,X             ;SMALL TIMER
          BNE     GNDSHOOT
          LDA     #CONSTANT
          STA     ELACCELT,X
          DEC     ELWAIT,X               ;LARGE SCALE TIMER
          BNE     GNDSHOOT

*OK,  IT'S TIME TO  DO A TRANSFORM
          LDA     ELYACCEL,X             ;MOTION TABLE OFFSET
          TAY
          LDA     RACK
          CMP     #$0E
          BCS     UPERPART
          LDA     GNDMOTN,Y            ;GET  MOTION TABLE BYTE
          JMP     UANDME
UPERPART  LDA     GNDMOTN2,Y
UANDME    BEQ     GNDSHOOT
          AND     #$07
          EOR     ELXACCEL,X             ;REVERSE OR NEGATE BIT
          LSR     A                      ;CHECK FOR PLUS OR MINUS DELTA
          TAY
          LDA     ELANIM,X               ;GET OLD VECTOR POINTER
          BCS     MINDEL
POSDEL
*         CLC
          ADC     TAB0,Y
          JMP     ENDDEL
MINDEL
*         SEC
          SBC     TAB0,Y
ENDDEL
          AND     #$07
          STA     ELANIM,X               ;NEW VELOCITY  POINTER
          TAY
          LDA     ROVXSPD,Y
          STA     TEMP0
          ASL     A
          STA     ELXSPEED,X
          LDA     ROVYSPD,Y
          STA     TEMP1
          ASL     A
          STA     ELYSPEED,X
          LDA     TEMP0
          AND     #$80
          STA     TEMP0
          LDA     TEMP1
          LSR     A
          AND     #$40
          CLC
          ADC     TEMP0
          STA     ELDIR,X
          INC     ELYACCEL,X             ;MOTION  TABLE  POINTER
          LDY     ELYACCEL,X
          LDA     RACK
          CMP     #$0E
          BCS     PARTUPER
          LDA     GNDMOTN,Y
          JMP     MEANDU
PARTUPER  LDA     GNDMOTN2,Y
MEANDU    BEQ     GNDSHOOT
          AND     #$F8                   ;GET LARGE SCALE TIMER
          LSR     A
          LSR     A
          LSR     A
          STA     ELWAIT,X
GNDSHOOT
          DEC     ELMEAN,X
          BNE     GNDOUT

          LDA     ELYPOS,X
          CMP     #$18
          BCC     GNDOUT

          ADC     #$20
          CMP     ELYPOS
          BCC     GNDOUT

          LDA     RACK
          LSR     A
          LSR     A
          TAY
          JSR     RANDOM
          AND     #$1F

          ADC     ROVDIFTB,Y
          ADC     #$0F
          STA     ELMEAN,X
          LDY     DIFCULTY
          LDA     CULTAB,Y
          CLC
          ADC     ELMEAN,X
          BCC     NTSOEAZY
          LDA     #$F0
NTSOEAZY
          STA     ELMEAN,X

          LDA     ELXPOS,X
*         SEC
*         SBC     #$02
          SBC     #$00
          STA     TEMP14
          LDA     ELYPOS,X
          CLC
          ADC     #$09
          STA     TEMP15
          JSR     FIRE1                  ;FIRE THAT ROVER!
GNDOUT
          RTS

CULTAB    DB      $40,$20,$00,$00        ;TABLE USED TO ADJUST ROVER FIRING RATE

ROVDIFTB  DB      $10,$20,$30,$40

TAB0      DB      0,1,2,4


********** HYBRID COLLISION DETECT (ROVERS,TANKS,MOMMY) ************************
* T0,T1,T2,T3 FROM PREVIOUS COLLDETB

HYBCOLLD
          LDA     T0
          CLC
          ADC     ANTITOTL
          STA     T0
          LDA     T1
          CLC
          ADC     ANTITOTL
          STA     T1

          LDY     PRIOR1
          BMI     ZSKIPP
          JMP     HYBLOOP
ZSKIPP    LDY     PRIOR2
          BPL     MOMCOLL
          JMP     JHYBOUT                 ;NOTHING TO COLLIDE WITH

;MOMSTAT
;         BIT                            MEANING
;         ---                            ------- 
;         0                              LOWER RIGHT PORT WAS HIT (SET)
;         1                              LOWER LEFT PORT WAS HIT (SET)
;         2                              CENTER PORT WAS HIT (SET)
;         3                              UPPER RIGHT PORT WAS HIT (SET)
;         4                              UPPER LEFT PORT WAS HIT (SET)
;         5-7                            0 - NO MOMMY PRESENT
;                                        1 - MOMMY COMING ONTO SCREEN
;                                        2 - MOMMY FULLY ON SCREEN AND STILL
;                                        3 - MOMMY RETREATING BACK UP SCREEN
;                                        4 - MOMMY DEAD AND SCROLLING DOWN

MOMCOLL
          LDA     ELFORLNK,Y
          STA     NXTFLNK1
          LDA     ELWHICH,Y
          CMP     #$0F
          BNE     CNTRNYET
          JMP     CNTRMOM


CNTRNYET
          LSR     A
          BCC     MIDMOM
          JMP     NXTMOM
MIDMOM    LSR     A
          BCS     TMIDMOM                ;GO TO SECTION FOR TOP MIDDLE OF MOM

BMIDMOM
          LDA     #$01
          STA     TEMP5                  ;USED FOR UPDATING MOMSTAT
          BNE     ZTMID
TMIDMOM                                  ;FOR NOW
          LDA     #$08
          STA     TEMP5
ZTMID
          LDA     ELYPOS,Y
          CLC
          ADC     #$08
          CMP     T1
          BCC     MISSEDCC
          SBC     #$08
          CMP     T0
          BCC     ZZ1000
JMSMOM    JMP     MISSMOM
;OK, DONE WITH VERTICAL CHECKING
ZZ1000
          LDA     T2
          CMP     #$3C                   ;LEFTMOST SIDE OF LEFT PORT
MISSEDCC  BCC     JMSMOM
          CMP     #$42                   ;RIGHTMOST SIDE OF LEFT PORT
          BCS     MISLPORT
;THE LEFT PORT HAS BEEN HIT!!!
          ASL     TEMP5
          LDA     MOMSTAT
          AND     TEMP5
          BNE     MISSMOM                ;ALREADY BEEN HIT
          LDA     TEMP5
          ORA     MOMSTAT
          STA     MOMSTAT
          JSR     DOSCORES

LPORTHIT  LDA     #$45
          STA     TEMP7                  ;SET UP FOR AIREXPQ
          JMP     EXPMOM

MISLPORT
;         LDA     T2
          CMP     #$4E                   ;RIGHTMOST SIDE OF RIGHT PORT
          BCC     MISSMOM
          CMP     #$54                   ;LEFTMOST SIDE OF RIGHT PORT
          BCS     MISSMOM
;THE RIGHT PORT HAS BEEN HIT!!!
          LDA     MOMSTAT
          AND     TEMP5
          BNE     MISSMOM                ;ALREADY BEEN HIT
          LDA     TEMP5
          ORA     MOMSTAT
          STA     MOMSTAT
          JSR     DOSCORES

RPORTHIT  LDA     #$56
          STA     TEMP7                  ;SET UP FOR AIREXPQ
EXPMOM
          LDA     ELYPOS,Y
          CLC
          ADC     #$00
          SEC
          SBC     ANTITOTL               ;TO CORRECT FOR ADDITION OF ANTITOTL
          STA     TEMP8                  ;IN AIREXPQ

MOMEXP
          JSR     AIREXPQ
          LDA     #$06
          STA     ELANIMT,Y
          LDA     MOMSTAT
          AND     #$E0
          CMP     #$20
          BNE     NOTDESC
          LDA     #$40
          STA     ELYSPEED,Y
          STA     ELDIR,Y
          RTS
NOTDESC
          CMP     #$40
          BNE     NOTSTILL
          LDA     #$00
          STA     ELYSPEED,Y
          RTS
NOTSTILL
          CMP     #$60
          BNE     MUSTBDED
          LDA     #$40
          STA     ELYSPEED,Y
          LDA     #$00
          STA     ELDIR,Y
          RTS
MUSTBDED
          LDA     #$20
          STA     ELYSPEED,Y
          LDA     #$40
          STA     ELDIR,Y
          RTS
JHYBOUT   JMP     HYBOUT


NXTMOM
MISSMOM
          LDY     NXTFLNK1
          CPY     #$FF
          BEQ     JHYBOUT
          LDA     ELPRIOR,Y
          CMP     #$02
          BNE     JHYBOUT
          JMP     MOMCOLL

CNTRMOM
          LDA     MOMSTAT
          AND     #$04
          BNE     MISSMOM
          LDA     ELYPOS,Y
          CLC
          ADC     #$02
          CMP     T1
          BCC     MISSMOM
          SBC     #$00
          CMP     T0
          BCS     MISSMOM
;DONE WITH VERTICAL
          LDA     T2
          CMP     #$41
          BCC     MISSMOM
          LDA     T2
          CMP     #$4D
          BCS     MISSMOM
;CENTER OF MOMMY HAS BEEN HIT!!!!
KILLMOM
          JSR     DOSCORES
          STY     TEMP0

          LDA     #$04
          JSR     SCRAPONE               ;KILL THAT MOTHER TUNE!!
          LDA     #$0C
          JSR     TUNIN                  ;EXPLOSION
          LDA     MOMSTAT
          ORA     #$84
          STA     MOMSTAT
          LDA     PRIOR2
NEXTKILL  CMP     #$FF
          BEQ     DONEKILL
          TAY
          LDA     ELPRIOR,Y
          CMP     #$02
          BEQ     OKKILL
          LDA     ELBAKLNK,Y
          TAY
          JMP     DONEKILL
OKKILL
          LDA     #$20
          STA     ELYSPEED,Y
          LDA     #$40
          STA     ELDIR,Y
          LDA     #$00
          STA     ELSTATE,Y
          LDA     ELFORLNK,Y
          JMP     NEXTKILL
DONEKILL

          LDY     TEMP0

          LDA     ELYPOS,Y
          CLC
          ADC     #$02
          SEC
          SBC     ANTITOTL               ;TO CORRECT FOR ADDITION OF ANTITOTL
          STA     TEMP8                  ;IN AIREXPQ
          LDA     #$4D
          STA     TEMP7
          JSR     MOMEXP
          LDA     #$40
          STA     ELDIR,Y
          LDA     #$20
          STA     ELYSPEED,Y

          LDY     TEMP0
          LDA     ELBAKLNK,Y             ;TO GET UPPER MIDDLE OF MOMMY
          TAY
          LDA     MOMSTAT
          AND     #$18
          CMP     #$18
          BEQ     ZSKIP100               ;SKIP IF BOTH UPPER PORTS HAVE BEEN HIT
          LDA     MOMSTAT
          AND     #$10
          BNE     ZSKIP101               ;SKIP IF UPPER LEFT PORT HAS BEEN HIT
          JSR     LPORTHIT
ZSKIP101
          LDA     MOMSTAT
          AND     #$08
          BNE     ZSKIP100               ;SKIP IF UPPER RIGHT HAS BEEN HIT
          JSR     RPORTHIT

ZSKIP100
          LDY     TEMP0
          LDA     ELFORLNK,Y
          TAY
          LDA     MOMSTAT
          AND     #$03
          CMP     #$03
          BEQ     ZSKIP102               ;SKIP IF BOTH LOWER PORTS HAVE BEEN HIT
          LDA     MOMSTAT
          AND     #$02
          BNE     ZSKIP103               ;SKIP IF LOWER LEFT PORT HAS BEEN HIT
          JSR     LPORTHIT
ZSKIP103
          LDA     MOMSTAT
          AND     #$01
          BNE     ZSKIP102               ;SKIP IF LOWER RIGHT HAS BEEN HIT
          JSR     RPORTHIT
ZSKIP102
          LDA     MOMSTAT
          ORA     #$9F
          STA     MOMSTAT
          LDY     TEMP0                  ;RESTORE Y OF MIDDLE OF MOMMY
          RTS

HYBLOOP
          CPY     #$FF
          BEQ     HYBOUT                 ;FOR NOW
          LDA     ELPRIOR,Y
          CMP     #$03
          BCS     HYBOUT                 ;NOTHING OVER PRIORITY 2 CAN BE HIT BY
                                         ;A  SOLVALOU BOMB
          CMP     #$02
          BNE     ZSKP
          JMP     MOMCOLL
ZSKP
          LDA     ELFORLNK,Y
          STA     NXTFLNK1
          LDA     ELCLASS,Y
          CMP     #$06
          BEQ     AHHA
HYBDEY
          LDY     NXTFLNK1
          JMP     HYBLOOP
HYBOUT    RTS

AHHA
          LDA     ELXPOS,Y
          CMP     T2
          BCC     HYBDEY
          CMP     T3
          BCS     HYBDEY
          LDA     ELYPOS,Y
          CMP     T0
          BCS     HYBDEY
          CMP     T1
          BCC     HYBDEY
HYBHIT                                   ;IT'S A HIT!
          JSR     DOSCORES
          LDA     ELWHICH,Y
          CMP     #$21                   ;TANK
          BNE     KRATER
          LDA     ELMEAN,Y
          BPL     KRATER
          JSR     FLFNO2
          JSR     ENDFLEI                <sic>   no crater
          JMP     NOKRATER               ;JMP...

KRATER    JSR     FLFNO2
          JSR     ENDFLEI2
          LDA     #ASKNOLY               ;ACCRATER-ACTIONRL
          STA     ELSTATE,Y
NOKRATER  LDA     #$40
          STA     ELDIR,Y
          LDA     #$20
          STA     ELYSPEED,Y
          LDA     #$00
          STA     ELXSPEED,Y
          LDA     #$05
          STA     ELANIMT,Y

          LDA     #$0C                   ;BOOOOOOOM!
          JSR     TUNIN
          JMP     HYBDEY






********************** ROVER ROUTINES AND INFORMATION **************************

*INFORMATION BYTES NEEDED IN CSHIPS TABLE TO CREATE A ROVER


;BYTE#            BITS                   INFORMATION
;-----            ----                   ----------- 

; 1               0-6                    DECIMAL ROW NUMBER
; 1                7                     SPECIAL CASE FLAG (A ONE FOR ROVERS)
; 2               0-4                    SHIP TYPE
; 2               5-7                    NUMBER OF ROVERS (USUALLY ONE)
; 3                0                     REVERSAL BIT (A ONE NEGATES SIGN OF
;                                        ANGLE CHANGE)
; 3               1-7                    STARTING XPOS-$10
; 4               0-2                    INITIAL VELOCITY POINTER
; 4               3-5                    DON'T CARE
; 4               6-7                    INITIAL ELDIR
; 5               0-7                    OFFSET INTO MOTION TABLE


ROVXSPD
          DB      $00+$0A                ;0
          DB      $00+$08                ;45
          DB      $00+$00                ;90
          DB      $80+$08                ;135
          DB      $80+$0A                ;180
          DB      $80+$08                ;225
          DB      $00+$00                ;270
          DB      $00+$08                ;315

ROVYSPD
          DB      $80+$10                ;0
          DB      $00+$00                ;45
          DB      $80+$00                ;90
          DB      $00+$00                ;135
          DB      $80+$10                ;180
          DB      $80+$20                ;225
          DB      $80+$20                ;270
          DB      $80+$20                ;315

;_______________________________________________________________________________



;UPDATE SCORE
DOSCORES
          TXA                                ;JUST TO TEST OUT SCORE MECHANISM
          PHA

          LDA     ELWHICH,Y
          TAX
          CMP     #$21
          BNE     OKYDOKY
          LDA     ELMEAN,Y
          AND     #$7F
          BEQ     DULLTANK               ;200
          LDX     #$12                   ;"SHEONITE 1"
          CMP     #L(TNKRWOW)
          BNE     DULLTANK               ;400
          LDX     #$13                   ;"SHEONITE 2"
DULLTANK                                 ;TARGET TYPE PASSED IN X
OKYDOKY   JSR     ZNODOMEC               ;SCORE COMPUTE FOR SHIPS

          PLA
          TAX
          RTS
BOTROV
          END


