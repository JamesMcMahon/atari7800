**** CSHIPS *******

          ZEROPAGE
          PUBLIC  MEANNESS
          PUBLIC  CSHIPS,CSWAIT1,MOMWAIT
          ELGLBL                         extrn
          EXTRN   ROVXSPD,ROVYSPD,CONSTANT rovers
          EXTRN   RANDOM
          ASKGLBL
          PLAYGLBL
          SHIPGLBL
          ANIMGLBL
          SHOTGLBL
          BUTTGLBL
          MOMGLBL
          MAPGLBL
          LINKGLBL
          TANKGLBL
          TUNEGLBL
          WAVEGLBL
******************************************
RAM1      CSECT
XBNUMBER  DS      1
SIDE      DS      1
WAVESIZE  DS      1
WAVETYPE  DS      1
WAVEFLAG  DS      1
BACKZOSH  DS      1

CSWAIT1   DS      1
STOPROW   DS      1
MOMWAIT   DS      1
WHICHESC  DS      1
MEANNESS  DS      1
MEANNES2  DS      1
OLDSIZE   DS      1
OLDXPOS   DS      1
******************************************
*         ORG     (*+255)/256*256
          ASECT
          ORG     $D000

MINITIAL  DB      $00,$00,$02,$03,$04,$05,$06,$07
          DB      $0,$0,$0,$0,$0,$0,$0,$0
          DB      $00,$00,$12,$13,$14,$15,$16,$17
          DB      $0,$0,$0,$0,$0,$0,$0,$0
          DB      $00,$00,$12,$13,$14,$25,$26,$27
          DB      $0,$0,$0,$0,$0,$0,$0,$0
          DB      $00,$00,$12,$13,$14,$25,$26,$37
          DB      $0,$0,$0,$0,$0,$0,$0,$0
          DB      $00,$00,$12,$13,$24,$35,$36,$47
          DB      $0,$0,$0,$0,$0,$0,$0,$0
          DB      $00,$00,$22,$23,$24,$35,$46,$57
          DB      $0,$0,$0,$0,$0,$0,$0,$0
          DB      $00,$00,$22,$23,$34,$45,$46,$57
          DB      $0,$0,$0,$0,$0,$0,$0,$0
          DB      $00,$00,$22,$23,$34,$45,$56,$67
*SEE WARNING BELOW!!

**********ANOTHER NEW CREATE SHIPS ROUTINES    *********** NOVEMBER 10, 1983

**** CSHIPS *******


*
*                 ENEMY TYPES
*         SHIP                           TYPE NUMBER             CLASS
*         ----                           -----------             ----- 
*        *BACULA (SET NUMBER)            0                         3
*        *BACULA                         1                         3
*        *DOCILE BLACK EIGHT             2                         2
*        *MEAN BLACK EIGHT               3                         2
*        *RED EIGHT                      4                         2
*        *SUPER EIGHT                    5                         2

*         TOROID                         6                         1
*         TORKAN                         7                         1
*         FLUFF                          8                         2
*         ZOSHI                          9                         1
*         JARA                           A                         1
*         KAPI                           B                         1
*         TERRAZI                        C                         1

*        *TOP OF MOMMY                   D                         6
*        *TOP MIDDLE OF MOMMY            E                         6
*        *MIDDLE OF MOMMY                F                         6
*        *BOTTOM MIDDLE OF MOMMY        10                         6
*        *BOTTOM OF MOMMY               11                         6
*        *SHEONITE0                     12                         0
*        *SHE1  (WAS BRAGZA = CRYSTAL)  13                         0
*        *ROVER                         14                         6
*        *TANK                          15                         6

*        *-INDICATES SPECIAL CREATION CODE NEEDED


*         DATA    STRUCTURE


*         WORD    BIT                    MEANING
*         ----    ---                    ------- 
*         1       0-6                    ROW NUMBER (0-104)
*         1       7                      SPECIAL CASE FLAG (0-1)
*         2       0-4                    SHIP TYPE
*         2       5-7                    NUMBER OF SHIPS
*         3       0-6                    ENDING ROW (ONLY FOR BACULAS)

********************************************************************************

******************************************
CODED     CSECT                          ;STARTS D078
RECORDSZ  DB      01,02,01,01,01,01,01,01
          DB      01,01,01,01,01,01,01,01
          DB      01,01,01,01,04,04

ATOPCSHP
ZCSHRTS   RTS

***** THIS ROUTINE CHECKS TO SEE IF A WAVE SHOULD BE CREATED
CSHIPS
WVEMAYBE
          LDA     MOMWAIT
          BEQ     NOMATER
          DEC     MOMWAIT
          BNE     ZCSHRTS
NOMATER                                  ; Well, what about Pater?
          LDY     #0
          LDA     (RACKSEQU),Y           ;CHECK ROW PARAMETER
          TAX
          AND     #$7F                   ;GET RID OF SPECIAL CASE FLAG
          CMP     CURROW
          BEQ     CREASHIP
          LDA     WAVEFLAG
          BEQ     ZCSHRTS
          JMP     ZIPZAP1

DIFFTABL  DB      6,7,8,9,2,$A,3,$B,$C,4     ;SHIP DIFFICULTY PROGRESSION TABLE

DIFTINDX  DB      $FF,$FF,4,6,9,$FF          ;TABLE OF INDEXES INTO DIFFTABL
          DB      0,1,2,3,5,7,8
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

ONEMONE   DB      -7,-6,-6,-6,-6,-6,-6,-5       ;EASIEST DIFFICULTY LEVEL
          DB      -6,-5,-5,-5,-5,-5,-5,-4
          DB      -5,-4,-4,-4,-4,-4,-4,-3
          DB      -4,-3,-3,-3,-3,-3,-3,-2
          DB      -3,-2,-2,-2,-2,-2,-2,-1
          DB      -2,-1,-1,-1,-1,-1,-1,0
          DB      -1,0,0,0,0,0,0,1              ;HARDEST DIFFICULTY LEVEL
          DB      0,0,0,0,1,1,1,2

**** OK, CREATE A WAVE!!!
*WARNING!   INCREMENT OF CSWAIT1 COULD CAUSE PROBLEMS!!
CREASHIP


ZCREATE   INC     WAVEFLAG
          LDY     #$01
          LDA     (RACKSEQU),Y           ;GET TYPE-WAVESIZE BYTE
          TAX
*         AND     #$E0
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          STA     WAVESIZE
          STA     OLDSIZE
          STA     XBNUMBER               ;DEFAULT FOR BACULA
          TXA                            ;GET  BACK TYPE-WAVESIZE BYTE
          AND     #$1F
          TAX
          STA     WAVETYPE

;THIS LITTLE SECTION CHECKS FOR GLITCH OVERRUN
;         JSR     CHEKSIZE
;         BNE     CREE
;         LDA     WAVETYPE
;         CMP     #$01
;         BNE     BACNYET
;         JMP     CHEKBAC
;ACNYET
;         LDA     WAVESIZE
;         BNE     CHEKRTS
;VDNE     JMP     WAVEDONE
;HEKRTS   RTS                            ;NO ROOM
CREE      LDY     #$00
          LDA     (RACKSEQU),Y           ;GET ROW-SPECIAL CASE BYTE
          BPL     NOTSPECL               ;SPECIAL CASE, NO INTELLIGENCE
*CHECK FOR BACKWARDS ZOSHI
          LDA     RACK
          CMP     #$0C
          BNE     NOINTELL
          LDA     WAVETYPE
          CMP     #$09
          BNE     NOINTELL

          LDA     CURROW
          CMP     #76
          BCC     NOINTELL
          CMP     #85
          BCS     NOINTELL
          CMP     #78
          BEQ     NOINTELL
          CMP     #79
          BEQ     NOINTELL
          CMP     #82
          BEQ     NOINTELL
          LDA     #$01
          STA     BACKZOSH
          BNE     NOINTELL               ;BRANCH ALWAYS
NOTSPECL
          LDY     DIFTINDX,X
          BMI     NOINTELL               ;INTELL DOESN'T APPLY TO ALL SHIPS

INTELL
          LDA     MEANNESS
          LSR     A
          LSR     A
          AND     #$38
          STA     TEMP0
          CMP     #$20
          BCS     OOOOOK
          DEC     WAVESIZE
          CMP     #$10
          BCS     ANDONLY1
          DEC     WAVESIZE
ANDONLY1
          LDA     WAVESIZE
;         BEQ     ADJAGAIN               ;DONE IN CRUNCH
          BNE     OOOOOK                 ;WAS A BPL
ADJAGAIN
          INC     WAVESIZE
;         JMP     ANDONLY1               ;DONE IN CRUNCH
OOOOOK
          LDA     WAVESIZE
          STA     OLDSIZE
          JSR     RANDOM
          AND     #$07
          CLC
          ADC     TEMP0                  ;DIFFICULTY SETTING COMPENSATION
          TAY
          LDA     ONEMONE,Y              ;ADD A ONE OR A ZERO OR A MINUS ONE
;         CLC
          ADC     DIFTINDX,X
          BPL     CMP0A
          LDA     #$00
CMP0A     CMP     #$0A                   ;DIFFTABL IS ONLY A ENTRIES LONG
          BCC     NOTOVRX
          SBC     #$0A
          JMP     CMP0A
NOTOVRX
          TAX
          LDA     DIFFTABL,X
          STA     WAVETYPE
NOINTELL
          LDY     #$01
          TYA                            ;ACCUMULATOR MUST BE ONE AS WELL!!
          STA     CSWAIT1                ;DEFAULT WAIT TIME BETWEEN SHIPS

          LDA     WAVETYPE
          CMP     #$14                   ;ROVERS AND TANKS
          BCC     NORO
          INY
          LDA     (RACKSEQU),Y
          STA     TEMP3                  ;XPOS,REVERSAL BIT
          INY
          LDA     (RACKSEQU),Y
          STA     TEMP4                  ;INITIAL SPEEDS down,0,up
          INY
          LDA     (RACKSEQU),Y
          STA     TEMP5                  ;OFFSET INTO MOTION TABLE
          JMP     ZNOT3BTS
NORO      CMP     #$01
          BNE     ZNOT3BTS
          INY
          LDA     (RACKSEQU),Y           ;GET ENDING ROW BYTE
          STA     STOPROW

ZNOT3BTS
*UPDATE SEQUENCING INFORMATION POINTER
UPDRACKS
;         INY
          TYA
          SEC
          ADC     RACKSEQU
          STA     RACKSEQU
          BCC     ZZSLEEP
          INC     RACKSEQU+1
ZZSLEEP   CMP     #L(SEQUEND)
          BNE     NOTENDSQ
          LDA     RACKSEQU+1
          CMP     #H(SEQUEND)
          BNE     NOTENDSQ

*RESET SEQUENCE TO RACK 7
SEQUWRAP  LDA     #L(RACK7SEQ)
          STA     RACKSEQU
          LDA     #H(RACK7SEQ)
          STA     RACKSEQU+1
NOTENDSQ
ZIPZAP1
          DEC     CSWAIT1
          BEQ     QUIP1
QUIP      RTS
QUIP1     JSR     CHEKSIZE
          BNE     ZCREATE0               ;IF ITS ZERO, THERE ARE TOO MANY SHIPS
          LDA     WAVESIZE
          BNE     QUIP
          LDA     WAVETYPE
          CMP     #$01                   ;DON'T WANT TO STOP RANDOM BACULAS
          BNE     WVDN
CHEKBAC   LDA     CURROW
          CMP     STOPROW
          BCC     QUIP
WVDN      JMP     WAVEDONE

*CREATE A SPECIAL WAVE
ZCREATE0
          LDY     WAVETYPE               ;FOR NOW
          LDA     CSPRIOR,Y
          STA     PRIORITY
          JSR     LNKINSRT
          JSR     ZEROSHIP               ;ZERO THE SHIP STATE

          LDA     CURROW
          CLC
          ADC     #$05
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          LDY     RACK
          CLC
          ADC     CSMEAN,Y
          STA     ELMEAN,X

          JSR     SETSTATE

          LDA     CSHIPL,Y
          STA     TEMP6
          LDA     CSHIPH,Y
          STA     TEMP7
          JMP     (TEMP6)




CSHIPL    DB      L(DOONEBAC),L(RNDBAC)
          DB      L(NOTMEEK8),L(MEEK8),L(NOTMEEK8),L(SUPER8TS)
          DB      L(ALTSIDES),L(ZSIDEOUT),L(ZSIDEOUT),L(ZSIDEOUT)
          DB      L(ALTSIDES),L(ZSIDEOUT),L(ALTSIDES)
          DB      L(CREMOM),L(CREMOM),L(CREMOM),L(CREMOM),L(CREMOM)
          DB      L(CRESHEON),L(CRESHEON),L(CREROVER),L(CRETANK)
CSHIPH    DB      H(DOONEBAC),H(RNDBAC)
          DB      H(NOTMEEK8),H(MEEK8),H(NOTMEEK8),H(SUPER8TS)
          DB      H(ALTSIDES),H(ZSIDEOUT),H(ZSIDEOUT),H(ZSIDEOUT)
          DB      H(ALTSIDES),H(ZSIDEOUT),H(ALTSIDES)
          DB      H(CREMOM),H(CREMOM),H(CREMOM),H(CREMOM),H(CREMOM)
          DB      H(CRESHEON),H(CRESHEON),H(CREROVER),H(CRETANK)
***************
SETSTATE
***************
* USE WAVETYPE TO SET INITIAL STATE OF SHIP
          LDA     WAVETYPE
          STA     ELWHICH,X
          TAY                            ;USE WAVETYPE AS AN INDEX INTO TABLES
          LDA     CSPRIOR,Y
          STA     ELPRIOR,X

          LDA     CSTYPE,Y
          STA     ELTYPE,X

          LDA     #$CF
          CLC
          ADC     ANTITOTL
          STA     ELYPOS,X

          MOVE    CSPALW,Y,ELPALW,X
          MOVE    CSCLASS,Y,ELCLASS,X
          MOVE    CSSTATE,Y,ELSTATE,X
          MOVE    #$40,ELDIR,X           ;;;;;

          LDA     INITWAIT,Y             ;TIME TO WAIT INITIALLY
          STA     ELWAIT,X
          LDA     ANIMTIME,Y
          STA     ELANIMT,X
          LDA     CSANIM,Y
          STA     ELANIM,X

          RTS

*******************
* BACULAS
*
RNDBAC
          JSR     RANDOM
          AND     #$01                   ;ONE OR TWO BACULAS
          STA     XBNUMBER
          INC     XBNUMBER
;OONEBAC  LDX     OBJCNT
DOONEBAC
          JSR     GETRNDX                ;SET NUMBER OF BAC'S START HERE
          STA     ELXPOS,X
          LDA     #$40                   ;2*SCROLSPD
          STA     ELYSPEED,X

          INC     OBJCNT
          INC     OBJRESRV
          DEC     XBNUMBER
          BEQ     NOMORBAC
          LDA     OBJRESRV
          CMP     SHOTCNT
          BCS     NOMORBAC

          LDA     #$03
          STA     PRIORITY
          JSR     LNKINSRT
          JSR     ZEROSHIP               ;ZERO STATE

          JSR     SETSTATE               ;USE THIS WAVETYPE TO INIT SHIP
          JMP     DOONEBAC

NOMORBAC  LDA     WAVETYPE
          BNE     RNDWAIT0
          BEQ     JDONE                  ;END WAVE OF SET NUMBER OF BAC'S
RNDWAIT0  JSR     RANDOM                 ;SET UP NEW WAIT TIME
          AND     #$0F
          ADC     #$0E
          STA     CSWAIT1
          LDA     RACK
          CMP     #$09
          BCS     MOSTBAC
          CMP     #$03
          BCC     LEASTBAC
LESSBAC   LDA     #$04
          ADC     CSWAIT1
          BNE     LESSBAC2               ;BRANCH ALWAYS
LEASTBAC  LDA     #$08
          ADC     CSWAIT1
LESSBAC2  STA     CSWAIT1
MOSTBAC   LDA     CURROW
          CMP     STOPROW
          BCC     ZSZ1
JDONE     JMP     WAVEDONE
ZSZ1      RTS

******************************************
* EIGHT BALLS
*
MEEK8     LDA     #0
          STA     ELXSPEED,X
NOTMEEK8  LDA     #$03                   ;RED,BLACK EIGHT BALL SECTION
          JSR     TUNIN
          JSR     GETRNDX
          STA     ELXPOS,X
          JSR     RANDOM
          AND     #$3F
          ADC     #$70
          STA     ELYPOS,X
          JSR     INITDIR
          JSR     RANDOM
          AND     #$1F
          STA     CSWAIT1
          JMP     BOOKKEEP

SUPER8TS                                 ;;;REG SHIPS?
          JSR     GETRNDX
;         LDX     OBJCNT
          STA     ELXPOS,X
;         LDA     #$BF
;         STA     ELYPOS,X
          LDA     #$00
          STA     ELXSPEED,X
          LDA     #$A0
          STA     ELYSPEED,X
          INC     OBJCNT
          INC     OBJRESRV
          JMP     WAVEDONE

******************************************
* MOMMY!
*

CREMOM
;         SEC
;         SBC     #$0D
;         TAY
          LDA     #$08
          STA     MOMWAIT

          LDA     #$40                   ;JUST FOR NOW
          STA     ELYSPEED,X
          LDA     #$38
          STA     ELXPOS,X
          LDA     #$FF
          STA     ELANIM,X               ;NO  ANIMATION PLEASE!!
          LDA     WAVETYPE
          CMP     #$11
          BEQ     MATUNE
          CMP     #$0D
          BNE     NOMATUNE
CHEKTOP                                  ;NEEDED TO PREVENT FUNNY DEATH SEQUENCE
          LDA     MOMSTAT
          AND     #$84
          CMP     #$84
          BNE     NOMATUNE
          LDA     #$20
          STA     ELYSPEED,X
          LDA     #$40
          STA     ELDIR,X
          LDA     #$00
          STA     ELSTATE,X
          BEQ     NOMATUNE               ;BRANCH ALWAYS
MATUNE
          LDA     #$04
          JSR     TUNIN
          LDA     #$20
          STA     MOMSTAT
          JMP     JBOOOK
NOMATUNE
          CMP     #$0D                   ;TOP OF MOM
          BNE     JBOOOK
          LDA     #$00
          STA     MOMWAIT
JBOOOK    JSR     BOOKKEEP
          LDY     #$01
          LDA     (RACKSEQU),Y           ;TYPE WAVESIZE BYTE
          AND     #$1F
          CMP     #$0D
          BCC     IOP
          RTS
IOP       JMP     NOMATER

******************************************
* ROVERS
*
ROVDIFTB  DB      $60,$60,$70,$70
CREROVER
          LDA     RACK
          LSR     A
          LSR     A
          TAY
          JSR     RANDOM
          AND     #$1F
          SEC
          SBC     #$2F
          ADC     ROVDIFTB,Y
          STA     ELMEAN,X               ;SET UP MEAN TO CONTROL FIRING RATE

          LDA     #$20
          STA     ELWHICH,X
          LDA     #CONSTANT
          STA     ELACCELT,X
* XPOS AND REVERSAL BIT
          LDA     TEMP3
          TAY
          AND     #$FE
          LSR     A
;         CLC
          ADC     #$10
          STA     ELXPOS,X
          TYA
          AND     #$01
          STA     ELXACCEL,X
* INIT VEL. AND ELDIR
          LDA     TEMP4
          AND     #$C0
          STA     ELDIR,X
          LDA     TEMP4
          AND     #$07
          STA     ELANIM,X
          TAY
          LDA     ROVXSPD,Y
          ASL     A
          STA     ELXSPEED,X
          LDA     ROVYSPD,Y
          ASL     A
          STA     ELYSPEED,X
* OFFSET INTO MOTION TABLE
          LDA     TEMP5
          STA     ELYACCEL,X
          TAY
          LDA     RACK
          CMP     #$0E
          BCS     JOE
          LDA     GNDMOTN,Y
          BCC     JACKSON                ;ALWAYS
JOE       LDA     GNDMOTN2,Y
JACKSON   BEQ     CREOVER
          AND     #$F8
          LSR     A
          LSR     A
          LSR     A
          STA     ELWAIT,X
CREOVER   JSR     BOOKKEEP               ;FOR THE BOOKKEEPING
          JMP     NOMATER                ;CHECK FOR OTHER ROVERS


******************************************
* TANKS
*
CRETANK
          MOVE    #$21,ELWHICH,X
          MOVE    #0,ELXSPEED,X
*         MOVE    #$40,ELDIR,X
* XPOS
          LDA     TEMP3
          STA     ELXPOS,X
* SPEED                                  SET ANIM BIT IF DEAD
          SEC
          LDA     TEMP4
          STA     ELYSPEED,X
          SBC     #DEADTANK              ;LEAVES A 0 IF =
          BEQ     HESDEDJM
          LDA     #$80
HESDEDJM  EOR     ELANIM,X
          STA     ELANIM,X

* Offset into action table (and later, crater indicator, pater)
          LDA     TEMP5
          STA     ELMEAN,X
          AND     #$7F
          STA     ELSTATE,X
TANKOVER  JSR     BOOKKEEP               ;FOR THE BOOKKEEPING
          JMP     NOMATER                ;CHECK FOR OTHER TANKS


******************************************
* CREATE A SHEONITE       (ESCORT = 12,13)
CRESHEON  LDA     WHICHESC
          EOR     #$01
          STA     WHICHESC
          TAY
          MOVE    #$FF,ELANIMT,X
          MOVE    XOFFSET,Y,ELXSPEED,X     lat. offset from solvalou
          SUB     ELYSPEED,X,ELYPOS,ELYSPEED,X  diff bet top o'screen and solv
          MOVE    SHXPOS,Y,ELXPOS,X      ;NECESS?
          JSR     BOOKKEEP
          JMP     NOMATER
XOFFSET   DB      11,-9                  right,left
SHXPOS    DB      159,0                  right,left
******************************************
*CREATE A NON-SPECIAL WAVE
**** NOTE:  THE X REGISTER WILL CONTAIN OBJCNT FOR THE DURATION OF THIS CODE
;         LDX     OBJCNT
;         LDA     #$BF
;         STA     ELYPOS,X               ;SET UP INITIAL YPOSITION


ALTSIDES
          LDA     WAVESIZE
          CMP     OLDSIZE
          BEQ     DONEWALT
          LDA     RNDM
          AND     #$3F
          CMP     #$28
          BCC     YERT
          SBC     #$25
YERT
          SBC     #$0F
          ADC     OLDXPOS
          STA     ELXPOS,X
          JMP     ZMNN
DONEWALT
          LDA     ELXPOS
          LDY     SIDE
          BEQ     LEFTSIDE
RIGHTSID
          CLC
          ADC     #32
          STA     T2
          CMP     #$77
          BCS     LEFTSIDE
          LDA     #$87
          STA     T0
          SEC
          SBC     T2
          STA     T3                     ;DIFFERENCE BETWEEN T2 AND T0
          JMP     RDX                    ;BRANCH ALWAYS
LEFTSIDE
          SEC
          SBC     #32
          STA     T0
          CMP     #$20
          BCC     RIGHTSID
          LDA     #$10
          STA     T2
          LDA     T0
;         SEC
          SBC     T2
          STA     T3
RDX
          JSR     RANDOM
          AND     #$7F
ZCMPT2    CMP     T2
          BCS     ZCMPT3
;         CLC
          ADC     T3
          JMP     ZCMPT2
ZCMPT3    CMP     T0
          BCC     ZPOSOK
;         SEC
          SBC     T3
          JMP     ZCMPT3

ZSIDEOUT  JSR     GETRNDX
ZPOSOK    STA     ELXPOS,X
          PHA
          LDA     WAVESIZE
          CMP     OLDSIZE
          BNE     ZMNY
          PLA
          STA     OLDXPOS
          JMP     ZMNN
ZMNY      PLA
ZMNN
          JSR     INITDIR                ;IS CALLED FROM OTHER PLACES

          LDA     BACKZOSH
          BEQ     NOBACKZ
BACKZ     LDA     #$01
          CLC
          ADC     ANTITOTL
          STA     ELYPOS,X
          LDA     ELDIR,X
          AND     #$BF                   ;MAKE THE ZOSHI MOVE UP THE SCREEN
          STA     ELDIR,X
NOBACKZ


*GET WAIT TIMES BETWEEN SHIPS

          JSR     RANDOM
          LDY     WAVETYPE
          AND     CSWAITBL,Y
          CLC
          ADC     #1
          STA     CSWAIT1

*FINALLY, DO SOME BOOKEEPING
BOOKKEEP
          INC     OBJCNT
          INC     OBJRESRV
          DEC     WAVESIZE
          BNE     WAVEBYBY

*WAVE IS ALL DONE
WAVEDONE
          LDA     #0
          STA     WAVEFLAG
          STA     OLDSIZE
          STA     OLDXPOS
          STA     BACKZOSH
          LDA     SIDE
          EOR     #1
          STA     SIDE
WAVEBYBY  RTS



******************************************
* INITIALIZE ARRAY TO CONTAIN SOLVALOU (AT ELYPOS) AND SIGHT (AT ELYPOS+1)
SOLVINIT
          JSR     LINKINIT

* SOLVALOU
          LDA     #$03
          STA     PRIORITY
          JSR     LNKINSRT
          JSR     ZEROSHIP
;PX0TRAP  CPX     #0                     ;;;;;;
;         BNE     CPX0TRAP               ;;;;;;

          LDA     #$03
          STA     ELPRIOR

          LDA     #ASKNOLY5              ;ACSOLVAL-ACTIONRL
          STA     ELSTATE
          LDA     #ASKNOLY6+$80          ;ANSOLVAL-ANIMTAB
          STA     ELANIM
          JSR     SHOWSHIP

          MOVE    #$4B,ELXPOS
          MOVE    #$30,ELYPOS
*         MOVE    #$00,ELDIR

          LDA     #$5D
          STA     ELPALW


* SOLV SIGHT
          LDA     #$03
          STA     PRIORITY
          JSR     LNKINSRT
          JSR     ZEROSHIP
;PX1TRAP  CPX     #1                     ;;;;;;
;         BNE     CPX1TRAP               ;;;;;;

          MOVE    #3,ELPRIOR+1

          LDA     #ASKNOLY7+$80          ;ANSOLSIT-ANIMTAB
          STA     ELANIM,X

          JSR     SHOWSHIP
          MOVE    #$4B,ELXPOS+1
          MOVE    #$60,ELYPOS+1          ;ELYPOS+$30
          MOVE    #$9D,ELPALW+1
          MOVE    #$97,SIGHTCOL          ;The default color for the sight

*PUT IN SOLVALOU  AND SIGHT STATE VARIABLE HERE

*INITIALIZE OFFSETS INTO THE SHIP AND SHOT LISTS
          LDA     #2
          STA     OBJCNT
          LDA     #5
          STA     OBJRESRV
          LDA     #OBJECTS
          STA     SHOTCNT
          RTS

******************************************
* SET INITIAL MOTION TABLE POINTER FOR SHIPS.  X VELOCITY POINTER IS HIGH
* FOUR BITS OF DELTA X, AND Y VELOCITY POINTER COMES FROM ENEMY DATA LISTS
* NOTE MAX DELTA X IS $80, SO MAX X PTR IS 8.

INITDIR
          LDY     ELWHICH,X
*         LDA     #$40
*         STA     ELDIR,X                ;FIRST CLEAR ELDIR
          LDA     ELXPOS                 ;GET HERO X MINUS SHIP X
          SEC
          SBC     ELXPOS,X
          BPL     IDSETX
          EOR     #$FF                   ;IF NEGATIVE, REVERSE SIGN
          CLC
          ADC     #$01
          PHA
          LDA     #$C0                   ;STORE DIR BIT IN ELDIR
          STA     ELDIR,X
          PLA
IDSETX    AND     #$F0                   ;SHIFT, USING HIGH FOUR BITS
          CMP     #$50                   ;SET RANGE TO 0-4
          BCC     IDGETPTR
          LDA     #$40
IDGETPTR

          CMP     #0                     ;;;NECESS?
          BNE     ZNOTZ
          LDA     #$10
ZNOTZ
          CLC
          ADC     CSYVEL,Y               ;GET INITIAL Y VELOCITY FROM TABLE
          ADC     #L(MINITIAL)           ;ADD TO LOW BYTE OF TABLE ADDRESS
          STA     TEMP0                  ;POINTER INTO INITIAL MOTION TABLE
          LDA     #H(MINITIAL)
          ADC     #$00
          STA     TEMP1
          LDY     #$00
          LDA     (TEMP0),Y
          TAY
          AND     #$F0                   ;GET X VELOCITY
          ASL     A                      ;MULTIPLY BY TWO
          STA     ELXSPEED,X
          TYA                            ;MULTIPLY BY TWENTY HEX
          AND     #$0F
          ASL     A
          ASL     A
          ASL     A
          ASL     A
          ASL     A
          STA     ELYSPEED,X
          RTS


******************************************
* THIS SUBROUTINE RETURNS A RANDOM XPOS BETWEEN $10 AND $90

GETRNDX   JSR     RANDOM
          AND     #$7F
          CMP     #$40
          BCS     GTRND0
          ADC     #$10
GTRND0    RTS


CHEKSIZE
          LDA     OBJRESRV
          CMP     SHOTCNT
          BCS     MANYSHIP
          LDA     OBJCNT
          CMP     #15                    ;17-16 7/11/84
          BCC     NOTOMANY
          LDA     WAVETYPE
          CMP     #$0D
          BCS     NOTOMANY
MANYSHIP
          DEC     WAVESIZE
          JSR     RANDOM
          AND     #$0F
          ADC     #$0E
          STA     CSWAIT1
          LDA     #$00
          RTS
NOTOMANY  LDA     #$01
          RTS


********* LOOK UP TABLES USED IN LOADING UP INFORMATION ARRAYS WHEN CREATING
*         A SHIP.

CSCLASS   DB      3,3,2,2,2,2
          DB      1,1,2,1,1,1,1
          DB      6,6,6,6,6,0,0
          DB      6,6

CSPRIOR   DB      3,3,3,3,3,3
          DB      3,3,3,3,3,3,3
          DB      2,2,2,2,2,3,3
          DB      1,1

INITWAIT  DB      0,0,$10,$10,$10,0
          DB      0,$20,0,0,0,0,0
          DB      0,0,0,0,0,0,0
          DB      0,$A                   ;TANK

CSPALW    DB      $3C,$3C,$DF,$DF,$DE,$DD
          DB      $3E,$3D,$3F,$3D,$3D,$3D,$3D
          DB      $33,$33,$33,$33,$33,$20+29,$20+29
          DB      $3D,$20+30

CSWAITBL  DB      $0B,$0B,$1F,$1F,$1F,$00
          DB      $04,$05,$0B,$0B,$05,$0F,$0F
          DB      $00,$00,$00,$00,$00,$00,$00
          DB      $00

CSYVEL    DB      $01,$01,$02,$02,$02,$05
          DB      $02,$03,$05,$02,$03,$04,$05
          DB      $01,$01,$01,$01,$01,$06,$06
          DB      $00

CSMEAN    DB      $0F,$13,$17,$1B,$1F,$23
          DB      $27,$2B,$2F,$33,$37,$3B,$3F
          DB      $43,$47,$4B
BOTCSHP
******************
CODEF000  CSECT
CSTYPE
          DB      L(CBACULA)             ;SET NUMBER OF BACULAS
          DB      L(CBACULA)
          DB      L(CZAKATO)             ;DOCILE EIGHT BALLS
          DB      L(CZAKATO)
          DB      L(CBZAKATO)
          DB      L(CGZAKATO)

          DB      L(CTOROID)
          DB      L(CTORKAN)
          DB      L(CFLUFF0)
          DB      L(CZOSHI)
          DB      L(CJARA)
          DB      L(CKAPI)
          DB      L(CTERRAZI)

          DB      L(CMATOP)
          DB      L(CMATOPMD)
          DB      L(CMAMID)
          DB      L(CMABOTMD)
          DB      L(CMABOT)
          DB      L(CTERRAZI)            ;FOR SHEONITE
          DB      L(CTERRAZI)            ;FOR BRAGZA
          DB      L(CROVER)
          DB      L(CTANK0)
YSPEEDS
          DB      $20                    ; 0 DEGRESS
          DB      $00                    ; 45
          DB      $00                    ; 90
          DB      $00                    ; 135
          DB      $20                    ; 180
          DB      $37                    ; 225
          DB      $40                    ; 270
          DB      $37                    ; 315
XSPEEDS
          DB      $14                    ; 0 DEGRESS
          DB      $00                    ; 45
          DB      $00                    ; 90
          DB      $00                    ; 135
          DB      $14                    ; 180
          DB      $0F                    ; 225
          DB      $00                    ; 270
          DB      $0F                    ; 315
          END
