*********** MAIN ROUTINE FOR XEVIOUS     AFTER INITIAL TEST AND DEBUG RUN(1)
*MAIN

          ZEROPAGE                       ;a macro
          MARIAREG
          COLORS
          TRUEFALS
          PUBLIC  MAIN
          PUBLIC  ZNODOMEC
          ELGLBL                         public
          FLUFGLBL
          GTARGLBL
          DLIGLBL
          SOLVGLBL
          COLLGLBL
          PUBLIC  MOMSTAT
          PUBLIC  DETHWAIT               movement
          PUBLIC  LOADSCOR
          PUBLIC  LISTTABL,LISTTABH
          PUBLIC  CONSINT2
          PUBLIC  AIREXPQ
          TUNEGLBL                       extrn
          ANIMGLBL
          LINKGLBL
          BUTTGLBL
          SHOTGLBL
          HEADGLBL
          PLAYGLBL
          WAVEGLBL
          ASKGLBL
          EXTRN   LOGOCOL
          EXTRN   MEANNESS
          EXTRN   MOMWAIT
          EXTRN   RACK0SEQ
          EXTRN   MOVEMENT,BOMBING
          EXTRN   INITPLDR
          EXTRN   CSWAIT1
          EXTRN   CLRSTMP
          EXTRN   WVBLANK,RANDOM
          DLLGLBL
          MAPGLBL
          GODGLBL
          ZONEGLBL
          FLAGGLBL
          LOADGLBL


*****************************************
RAM1A     CSECT
DLIOFF    DS      1
NUMDLI    DS      1
FRMCNT    DS      1                      number of frames-- inc'ed in DLI2
OLDFCNT   DS      1                      used to ensure only one cycle per
OFRMCNT   DS      1                      frame
OFRMCNT0  DS      1

MOMSTAT   DS      1                      ;STATUS OF MOTHER SHIP
DETHWAIT  DS      1
SOLVSTAT  DS      1                      ;STATUS OF SOLVALOU (1 IS DYING)
********************************************************************************
*  WHAT FOLLOW ARE ARRAYS USED IN SETTING UP GROUND TARGETS AND MAINTAINING
*  INFORMATION USED BY THE PLAY CODE.
********************************************************************************

RAM2      CSECT
GTARNUM   EQU     20
TARGLINE  DS      $1B                    ; HOLDS THE STAMP INDICES OF THE GROUND
                                         ; TARGETS IN THE POSITION IN WHICH THEY
                                         ; WILL APPEAR.
*
*  INFORMATION ABOUT ALL CURRENTLY DISPLAYED GROUND TARGETS IS CONTAINED
*  IN THE FOLLOWING TABLES.  THE CURRENT TABLE SIZE ALLOWS FOR 20 GROUND TARGETS
*
GTARTYPE  DS      GTARNUM                ; THE GROUND TARGET TYPE
GTARPOS   DS      GTARNUM                ; THE HORIZONTAL PIXEL POSITION
GTARPTRL  DS      GTARNUM                ; GTARPTR POINTS TO THE STAMP INDEX
GTARPTRH  DS      GTARNUM                ; WITHIN THE HEADER 2 CHARACTER LIST
                                         ; FOR THE GROUND TARGET.
GTARGID   DS      GTARNUM                ; EACH TARGET ON THE SCREEN HAS AN ID
                                         ; DISTINCT FROM THE ID'S OF ALL OTHER
                                         ; DISPLAYED TARGETS.  THIS IS ONLY USED
                                         ; TO FIND THE TOP AND BOTTOM HALVES OF
                                         ; 2 ZONE TARGETS LIKE MEGASITES.
GTARVPOS  DS      GTARNUM+2              ; THE VERTICAL PIXEL POSITION OF THE
                                         ; GROUND TARGET.
* converting EQU's to DS's GTARVPOS was allocated 22 (?) --NA

FGTTIME   DS      GTARNUM                ;TIME DELAY FOR FIRING GROUND TARGETS

FGTSPRT   DS      GTARNUM                ;SHOTS PER SPURT OF FIRING
CRATSTMP  DS      20                     CRATERSTUFF
CRATTIME  DS      20                     ;?
CRATTYPE  EQU     15

          ASECT

          ORG     $FFF4                  ;;;
          DB      L(COLLDET),H(COLLDET)  ;;;
          DB      L(MAPINIT),H(MAPINIT)  ;;;
          ORG     $FFF8
          DB      $FF,$87                ;MARIA SIGNATURE ENCRYPTION STUFF
          DB      L(DLI),H(DLI)        ;NMI VECTOR FOR DLI'S
          DB      L(MAIN),H(MAIN)        ;POWER ON RESTART VECTORS TO MAIN
          DB      L(IRQ),H(IRQ)          ;JUST IN CASE WE GET A STRAY IRQ

*****************************************
CODE9000  CSECT

ATOPMAIN
MAIN
          SEI
          CLD
          LDA     #$97                   ;LOCK INTO MARIA MODE
          STA     $0001                  ; and discharge paddle caps

          LDA     #$70
          STA     CTRLWT

          LDX     #$FF                   ;STACK IN AREA FROM $140-$1FF
          TXS                            ;SET STACK POINTER
          JSR     ZERORAM
ZRAMRTN
          JSR     INIT2BUT
          JSR     CONSINIT

          JMP      INITTITL               initializes for gameplay
                                         ; will return to GOD

AUTOPLAY
* Autoplay checks input:  trig,reset-->gamestart  joy,select-->menu
* otherwise, it fakes up some input for game, ignoring pause
          LDA     HBUTTON                ;GAME tests reset button
          BMI     ITSAHIT
*         LDA     NEWDIR
          LDA     SWCHA                  ;;;sorry...
          AND     #$F0
          EOR     #$F0
*         ORA     FPSELECT               ;GAME tests this
          BNE     ITSAMENU
          JSR     DECSYSCO
          BEQ     ITSAMENU
          JSR     FAKENPUT
          JMP     NOPAUSE                ;ignore pause in autoplay
ITSAHIT   JMP     INITGAME
ITSAMENU  JMP     INITTITL
; This routine handles the gameplay during GAME mode.  The mode
;         variable will equal "MGAME" and GODPTR will be set to this
;         label.

GAME
          LDA     FPPAUSE
          BEQ     NOPAUSE
          LDA     PSREADY                ;NECESS?
          BEQ     NOPAUSE                ;NECESS?
          LDX     #2
          JSR     SETSYSCO
          LDA     #0
          STA     PSREADY
          STA     AUDV0
          STA     AUDV1
          LDA     #MPAUSE
          STA     MODE
          NEWSTATE PAUSE
          ENDCYCLE

NOPAUSE
          LDA     FRMCNT
          LSR     A
          BCC     EVENFCNT

ODDFCNT
          JSR     SLOADER
          JSR     CRATERS
          LDA     DIFCULTY
          ASL     A
          ASL     A
          ASL     A
          ASL     A
          ASL     A
          ASL     A
          ADC     RACK
          ADC     RACK
          STA     MEANNESS
          JMP     GLNEXT

EVENFCNT
          LDA     FPRESET                if not pressed, will be 0
          BEQ     EVECONT0
          LDA     RESREADY               if not ready, will be 0
          BEQ     EVECONT0

          LDA     #FALSE
          STA     RESREADY

          JMP     INITGAME               else, start new game

EVECONT0
          LDA     FPSELECT
          BEQ     EVECONT1
          LDA     SELREADY
          BEQ     EVECONT1

          LDA     #FALSE
          STA     SELREADY

          JMP     INITTITL

EVECONT1
          JSR     SOLVMOVE               controllers are now polled in "GOD"
          JSR     MOVEMENT
          JSR     GFIRE
          JSR     PRELOAD

GLNEXT
          LDA     #CRUSTUNE
          CMP     TUNNUM
          BEQ     ZNOCRUSE
          CMP     TUNNUM1
          BEQ     ZNOCRUSE
ZCRUISE   JSR     TUNIN
ZNOCRUSE  JSR     TUNER

GLNEXT0
          ENDCYCLE                       back to the GOD loop

** ** clears out RAM, except for [$40,$50] and [$140,$150] ** ** (~optimal ?)
ZERORAM
CLRMARIA  LDA     #0                     ;zeroing is the game
          LDX     #$B0                   ;[$50,$FF]
ZZ01V     STA     $4F,X
          DEX
          BNE     ZZ01V

          LDX     #$A8                   ;[$150,$1F8]
ZZ02V     STA     $14F,X
          DEX
          BNE     ZZ02V

          LDX     #$3F                   ;[$2100,$213F]
ZZ03V     STA     $2100,X
          DEX
          BPL     ZZ03V

          LDX     #$9D                   ;[$2062,$20FF]
ZZ04V     STA     $2062,X
          DEX
          BPL     ZZ04V

          STA     TEMP0                  ;[$1800,$2060]
          LDY     #$20                   ;high address of same
          STY     TEMP1                  ;save zero in acc.
          STA     $2000                  ;kludge, 'coz of fencepost in algorithm
          LDX     #9                     ;pages to clear, incl. partial page
          LDY     #$60                   ;partial page, starting #
          JSR     ZZZFILL0               ;page filling routine

          LDX     #$27                   ;[$2200,$27FF]
          STX     TEMP1                  ;save zero in acc.
          LDX     #6                     ;pages to clear, incl. partial page
          LDY     #$FF
*                                        ;fall through to routine ZZZZFILL
ZZZFILL0  STA     (TEMP0),Y
          DEY
          BNE     ZZZFILL0
          DEC     TEMP1
          DEX
          BNE     ZZZFILL0
          RTS
*ZRA      JMP     ZRAMRTN


*SETS UP BACKGROUND AND PALETTE COLORS
COLRINIT

          LDX     #0
          LDY     #0
COLRLOOP  LDA     COLORS,X
          STA     P0C1,Y
          INX
          INY
          LDA     COLORS,X
          STA     P0C1,Y
          INX
          INY
          LDA     COLORS,X
          STA     P0C1,Y
          INX
          INY
          INY
          CPX     #24
          BNE     COLRLOOP
          RTS
COLORS    DB      $46,$0F,$2E            ;PALETTE ZERO        AIR EXPLOSION
*      RED    WHITE   ORANGE

          DB      $04,$08,$0C            ;PALETTE ONE         SHIPS
*      DK.GRAY   GRAY   LT.GRAY

          DB      $A6,$08,$0C            ;PALETTE TWO         SOLVALOU
*      BLUE     GRAY    LT.GRAY

          DB      $D8,$D3,$A3            ;PALETTE THREE       GROUND
*      LT.GREEN    DK.GREEN   BLUE

          DB      $97,$42,$0E            ;PALETTE FOUR        SIGHT
*      LT.BLUE    RED    WHITE

          DB      $04,$09,$0E            ;PALETTE FIVE        GRAYS
*      DK.GRAY    LTR. GRAY    LT.GRAY

          DB      $00,$46,$0F            ;PALETTE SIX         EIGHTBALLS,BARS
*      BLACK    RED    WHITE

          DB      $88,$2C,$42            ;PALETTE SEVEN       GROUND EXPLOSIONS
*      ORANGE   YELLOW    RED



*INITIALIZE CONSTANTS

CONSINIT
          LDA     #L(RACK0SEQ)
          STA     RACKSEQU
          LDA     #H(RACK0SEQ)
          STA     RACKSEQU+1

          LDX     #20                    ;ZERO OUT SCORE CHARACTER MAP
          LDA     #L(BLANKCHR)
BLNKLOOP
          STA     SCCHMAP,X
          DEX
          BNE     BLNKLOOP

          LDA     #L(XTRASCHR)           ;PUT UP EXTRA SOLVALU CHARACTER
          STA     SCCHMAP+9

          LDA     #$20                   ;EXTRA MAN AT 20,000
          STA     XTRASOLV
          STA     XTRASOLV-NMPLVARS

          LDA     #$04
          STA     NUMLIVES
;         LDA     #$04
          STA     NUMLIVES-NMPLVARS

          LDA     #$00
          STA     NUMDEAD                ;;;
          LDX     #$05
PLVLOOP
          STA     OTHERSTF,X             ;ZERO OUT SCORE
          STA     OTHERSTF+NMPLVARS,X
          DEX
          BPL     PLVLOOP

*LOAD UP SCORE AND BLANK DISPLAY LIST HEADERS
          LDX     #17
ZZSBDLOP  LDA     SCLSTROM,X
          STA     SCORELST,X
          DEX
          BPL     ZZSBDLOP

          LDA     #$00
          STA     PLAYER
          JSR     LOADSCOR
          LDA     NUMPLYRS               ;LOOP COUNTER
          BEQ     ONEPLYR                ;0-->1, 1-->2
          JSR     SWITCHP
          JSR     LOADSCOR
          JSR     SWITCHP
ONEPLYR
CONSINT2
          LDA     #$91
          STA     MAXYPOS
          LDA     #$18
          STA     MINYPOS

          LDA     #$00
          STA     ANTITOTL
          STA     TARG2CNT
          STA     SCOFFSET
          STA     BACKGRND
          STA     GTARGCNT
          STA     NGTARCNT
          STA     WAVEFLAG
          STA     FLAGFLAG
          STA     WAVEFLAG
          STA     SOLVSTAT
          STA     DOTREES
          STA     BOMBTRIG
          STA     SHOTTRIG
          STA     OLDSBUTT
          STA     MOMWAIT
          STA     MOMSTAT
          STA     0001

          LDA     #18
          STA     TREEROWS
          LDA     #$01
          STA     ROWCNT
          STA     CSWAIT1
;         LDA     #$04
;         STA     $282
;         STA     $283
          RTS

SCLSTROM  DB      L(SCCHMAP)             ;LO ADDR
          DB      $60                    ;P1 (INDIRECT, 5-BYTE HEADER)
          DB      H(SCCHMAP)             ;HI ADDR
          DB      $17                    ;PW (PALETTE 0, WIDTH 9)
          DB      $04                    ;HPOS
          DB      L(SCCHMAP+$9)          ;LO ADDR
          DB      $60                    ;P1 (INDIRECT, 5-BYTE HEADER)
          DB      H(SCCHMAP+$9)          ;HI ADDR
          DB      $FF                    ;PW (PALETTE 0, WIDTH 1)
          DB      76                     ;HPOS
          DB      L(SCCHMAP+$A)          ;LO ADDR
          DB      $60                    ;P1 (INDIRECT, 5-BYTE HEADER)
          DB      H(SCCHMAP+$A)          ;HI ADDR
          DB      $37                    ;PW (PALETTE 0, WIDTH 9)
          DB      84                     ;HPOS
          DB      0,0                    ;BLANK DL




********** COLLISION DETECT ROUTINE              AUGUST 8, 1983 ****************
*PART 1           AIR-SOLVALOU COLLISIONS


*
*         CLASS                          MEMBERS
*           0                       SOLVALOU,ENEMY SHOTS,OTHER IGNORED THINGS
*           1                       SHIPS
*           2                       FLUFF,EIGHT BALLS
*           3                       BACULAS
*           4                       HERO SHOT
*           5                       HERO BOMB
*           6                       MOVING GRND OBJECTS (INC. MAMA)
*           7                       NON MOVING GRND OBJECTS (INC. FLAGS AND CIT.
*


COLLDET
          NOP                            ;;;
          LDA     SOLVSTAT
          BNE     COLLRTS

          LDA     ELCLASS,X
          CMP     #$4
          BCS     COLLRTS
          CMP     #$01
          BEQ     SHSOLV
          CMP     #$02
*         BEQ     FLEISOLV
          BEQ     ENSHSOLV
          CMP     #$03
          BEQ     BACSOLV
          LDA     ELTYPE,X
          CMP     #L(CSHOT)
          BNE     COLLRTS


*ENEMY SHOT SOLVALOU COLLISIONS
ENSHSOLV
          LDA     ELYPOS                 ;YPOS OF SOLVALOU
          CLC
          ADC     #04
          STA     T0
          SEC
          SBC     #20
          STA     T1

          LDA     ELXPOS                 ;XPOS OF SOLVALOU
          SEC
          SBC     #00
          STA     T2
          CLC
          ADC     #09
          STA     T3
          JMP     GENCOLLD



*SHIP SOLVALOU COLLISIONS
SHSOLV    LDA     ELYPOS                 ;YPOS OF SOLVALOU
          CLC                            ;OPTIONAL
          ADC     #15                    ;16+1
          STA     T0
          SEC
          SBC     #31
          STA     T1

          LDA     ELXPOS                 ;XPOS OF SOLVALOU
          CLC
          ADC     #08                    ;12+1
          STA     T3
          SEC
          SBC     #13
          STA     T2
          JMP     GENCOLLD
COLLRTS   RTS


*BACULA SOLVALOU COLLISIONS

BACSOLV
          LDA     ELYPOS                 ;YPOS OF SOLVALOU
          CLC                            ;OPTIONAL
          ADC     #11
          STA     T0
          SEC
          SBC     #27
          STA     T1

          LDA     ELXPOS                 ;XPOS OF SOLVALOU
          CLC
          ADC     #10                    ;12+1
          STA     T3
          SEC
          SBC     #25
          STA     T2
;         JMP     GENCOLLD               ;MUST FALL THROUGH TO GENCOLLD

*
*                                T0
*                                !
*                                !
*                        T2 ---- X ---- T3
*                                !
*                                !
*                                T1
*
*    X IS SOLVALOU POSITION, T0-T3 ARE TEMP0-TEMP3 REGISTERS

GENCOLLD  LDA     ELXPOS,X
          CMP     T2
          BCC     COLLRTS
          CMP     T3
          BCS     COLLRTS
          LDA     ELYPOS,X
          CMP     T0
          BCS     COLLRTS
          CMP     T1
          BCC     COLLRTS
***********BOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOMMMMMMMMMMMMMMMM!!!!!!!!!!!******
HIT

          LDA     #XPLOTUNE
          JSR     TUNIN

          LDA     #L(C3BLANK)
          STA     ELTYPE+1               ;DELETE SIGHT
          LDA     #$35
          STA     DETHWAIT
          LDA     #$01
          STA     SOLVSTAT
          LDY     #$00
          JSR     FLFNO2
          LDA     #$06
          STA     ELANIMT
          LDA     #ASKNOLY0              ;ACSOLDED-ACTIONRL
          STA     ELSTATE
          LDA     #$0F
          STA     ELWAIT

;         ENDCYCLE
BOOMRTS   RTS


COLLDETS                                 ;HERO SHOT - OTHER COLLISIONS
          LDY     PRIOR3
CDSLOOP
          CPY     #$FF
          BEQ     CLDETRTS
          LDA     ELFORLNK,Y
          STA     NXTFLNK1

          LDA     ELCLASS,Y
          CMP     #1
          BNE     NOSHSH                 ;SHOT SHIP COLLISION
          JMP     SHSHIP
NOSHSH    CMP     #2
          BEQ     SHFLEI                 ;SHOT FLUFF EIGHT BALL COLLISION
          CMP     #3
          BEQ     SHBACULA
NOHIT
          LDY     NXTFLNK1
          JMP     CDSLOOP
CLDETRTS
          LDA     #0
          RTS

SHBACULA  LDA     ELYPOS,X               ;SHOT BACULA COLLISION
          CMP     ELYPOS,Y
          BCS     NOHIT
*         CLC                            ;OPTIONAL
          ADC     #13
          CMP     ELYPOS,Y
          BCC     NOHIT
          LDA     ELXPOS,X
*         SEC                            ;OPTIONAL
ADJ       SBC     #16
          CMP     ELXPOS,Y
          BCS     NOHIT
*         CLC                            ;OPTIONAL
          ADC     #26
          CMP     ELXPOS,Y
          BCC     NOHIT

ZDINK     LDA     #DINKTUNE
          JSR     TUNIN                  ;DINK SOUND
          LDA     #L(CBOUNCE)            ;DINK DINK
          STA     ELTYPE,X
*PUT STATE AND OTHER VARIABLE HERE
          LDA     #0
          STA     ELCLASS,X
          LDA     #1
          RTS

SHFLEI    LDA     ELYPOS,X
*         SEC                            ;OPTIONAL
          SBC     #4
          CMP     ELYPOS,Y
          BCS     NOHIT
*         CLC                            ;OPTIONAL
          ADC     #12
          CMP     ELYPOS,Y
          BCC     NOHIT
          LDA     ELXPOS,X
*         SEC                            ;OPTIONAL
LIM       SBC     #05
          CMP     ELXPOS,Y
          BCS     NOHIT
*         CLC                            ;OPTIONAL
          ADC     #15
          CMP     ELXPOS,Y
          BCC     NOHIT
          LDA     ELWHICH,Y              ;SEE IF FLUFF OR 8 BALL
          CMP     #$06
          BMI     NOTFLF

;MAKE ANIMATION ONE OF THE FLUFF ONES
          LDA     #ASKNOLY1              ;ANFLFEXP-ANIMTAB
          STA     ELANIM,Y
          LDA     ANFLFEXP
          STA     ELTYPE,Y
          LDA     #$DD
          STA     ELPALW,Y
          LDA     ELWHICH,Y
          STA     TEMP15
          LDA     #$1E
          STA     ELWHICH,Y
          BNE     ZENDFLEI               ;REALLY A JMP
NOTFLF
          JSR     FLFNO
ZENDFLEI
          JSR     ENDFLEI

          TXA
          PHA
;         TYA
;         PHA
          LDX     TEMP15
          JSR     ZNODOMEC               ;SCORE COMPUTATION FOR SHIPS
;         PLA
;         TAY
          PLA
          TAX

          LDA     #DISNTUNE
          JSR     TUNIN                  ;DISINTEGRATION SOUND
          LDA     #1                     ;DELETE HERO SHOT FLAG
          STA     TEMP14
          RTS

SHSHIP    LDA     ELYPOS,X
          CMP     ELYPOS,Y
          BCS     NOHITT
*         CLC                            ;OPTIONAL
          ADC     #16
          CMP     ELYPOS,Y
          BCC     NOHITT
          LDA     ELXPOS,X
*         SEC                            ;OPTIONAL
          SBC     #10
          CMP     ELXPOS,Y
          BCS     NOHITT
*         CLC                            ;OPTIONAL
          ADC     #20
          CMP     ELXPOS,Y
          BCC     NOHITT
          JMP     NOTFLF

NOHITT    JMP     NOHIT


*SCORE COMPUTE AND UPDATE ROUTINE
*TEMP0,1 USED
* ON ENTRY, X CONTAINS TYPE OF OBJECT BEING SCORED, TEMP11 CONTAINS # OF
*           BUILDINGS BEING DESTROYED (TO FIGURE HOW CENTER OF DOME WAS HIT)
SCORCOMP
          CPX     #$38                   ;18 = CENTER OF DOME COMPLEX
          BNE     ZNODOMEC
          LDA     TEMP11                 ;IF ALL 5 BUILDINGS ARE BEING BLOWN UP
          CMP     #5                     ; THEN WE MUST SCORE MORE POINTS
          BNE     ZNODOMEC
          LDX     #$3F                   ; 1F = CENTER OF DOME BEFORE SIDES HIT
ZNODOMEC
          LDA     LSCORES,X
          STA     TEMP0
          LDA     HSCORES,X
          STA     TEMP1

          SED
          LDA     TEMP0
          CLC
          ADC     PSCOR1
          STA     PSCOR1
          LDA     TEMP1
          ADC     PSCOR1+1
          STA     PSCOR1+1
          LDA     PSCOR1+2
          ADC     #$00
          STA     PSCOR1+2

ZZNCARRY  LDA     TEMP0
          CLC
          ADC     PMOD0
          STA     PMOD0
          LDA     TEMP1
          ADC     PMOD0+1
          STA     PMOD0+1
          CMP     XTRASOLV               ;COMPARE AGAINST XTRA MAN THRESHOLD
          BCC     ZNOXTRA
          INC     NUMLIVES
          LDA     #XTRATUNE
          JSR     TUNIN

          LDA     PMOD0+1
          SEC
          SBC     XTRASOLV
          STA     PMOD0+1
          LDA     PMOD0
          SBC     #$00
          STA     PMOD0

          LDA     XTRASOLV               ;ADJUST THRESHOLD
          CMP     #$60                   ; (MAXIMUM EVERY 60,000 POINTS)
          BCS     ZNOXTRA
;         CLC                            ;OPTIONAL
          ADC     #$20                   ; MAKE IT 20,000 HARDER FOR EACH XTRA
          STA     XTRASOLV
ZNOXTRA   CLD
          RTS

LSCORES
          DB      $00,$00,$10,$15,$60,$00,$03,$05
          DB      $01,$07,$15,$30,$70,$00,$00,$00
          DB      $00,$00,$40,$00,$00,$00,$00,$00 ;12 SHE1--> TANK
          DB      $00,$00,$00,$00,$00,$00,$00,$50

          DB      $80,$20,$10,$15,$60,$00,$03,$05
          DB      $01,$07,$15,$30,$70,$00,$00,$00
          DB      $30,$10,$20,$00,$30,$00,$00,$00
          DB      $60,$30,$30,$30,$30,$30,$00,$30

HSCORES
          DB      $00,$00,$00,$00,$00,$01,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$01,$04
          DB      $01,$00,$00,$10,$00,$00,$00,$00 ;13: SHE2--> SUPERTANK
          DB      $00,$00,$00,$00,$00,$00,$00,$00

          DB      $00,$00,$00,$00,$01,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$05,$00
          DB      $00,$00,$00,$01,$00,$02,$02,$01
          DB      $00,$00,$00,$00,$00,$00,$02,$02

SCORPOS   DB      0,12                   ;POSITION IN CHARACTER MAP OF SCORES
XTRASPOS  DB      8,10                   ;POSITION IN CHARACTER MAP OF XTRA SOLV
ZBLNKCHR  DB      L(BLANKCHR),$FF        ;PAD CHARS: BLANK FOR P1, NULL FOR P2


* LOADSCOR --     SET UP CHARACTER MAP FOR CURRENT PLAYER
* USES X, Y AND TEMP0
LOADSCOR
          LDA     MODE
          CMP     #MAUTO
          BEQ     LDSCORTS
          LDX     PLAYER
          LDA     NUMLIVES               ;FIRST PUT UP THE EXTRA SOLVALUS
          CMP     #$0A
          BCC     NOGRNINE
          LDA     #$09                   ;ONLY DISPLAY UP TO NINE MORE LIVES
NOGRNINE  ASL     A
          ADC     #L(ZEROCHAR)
          LDY     XTRASPOS,X             ; POINT Y INTO CORRECT POSITION
          STA     SCCHMAP,Y

          ;LOAD CHARACTER MAP.  X POINTS INTO SCORE, Y INTO CHARMAP
          LDA     #L(BLANKCHR)           ;POINT TEMP0 TO THE PADDING CHARACTER
          STA     TEMP0                  ; (FOR LEADING ZERO SUPRESSION)

          LDY     SCORPOS,X              ;GET CHARMAP POSITION OF FIRST DIGIT

          LDX     #2                     ;SET UP LOOP COUNTER FOR # OF DIGITS
LSCORLOP  LDA     PSCOR1,X
          LSR     A                      ;DO HI BYTE
          LSR     A
          LSR     A
          LSR     A
          JSR     WRTCHAR
          LDA     PSCOR1,X
          AND     #$0F                   ;DO LO BYTE
          JSR     WRTCHAR
          DEX
          BPL     LSCORLOP

          LDA     #L(ZEROCHAR)           ;PUT IN THE TRAILING ZERO
          STA     SCCHMAP,Y

LDSCORTS  RTS

WRTCHAR   BEQ     ZNOTDIG                ;IF NOT DIGIT 1-9, USE OPTIONAL BLANK
          ASL     A                      ;COMMENT OUT FOR ONE-BYTE CHARACTERS
;         CLC                            ;COMMENT OUT FOR TWO-BYTE CHARACTERS
          ADC     #L(ZEROCHAR)           ;ADD IN BASE OF CHARACTER SET
          STA     SCCHMAP,Y
          INY
          LDA     #L(ZEROCHAR)           ;CHANGE OVER TO ZERO PADDING
          STA     TEMP0
          RTS

ZNOTDIG   LDA     TEMP0                  ;USE THE PADDING CHARACTER
          CMP     #L(BLANKCHR)           ;IF NOT BLANK, PUT IT UP ANYWAY
          BNE     ZPUTZERO
          LDA     PLAYER                 ;OTHERWISE, DON'T BLANK PAD P2 SCORE
          BNE     ZNOADV
          LDA     TEMP0
ZPUTZERO  STA     SCCHMAP,Y
          INY
ZNOADV    RTS


*TABLES OF POINTERS TO DISPLAY LISTS
LISTTABL  DB      L(ZONE0),L(ZONE1),L(ZONE2)
          DB      L(ZONE3),L(ZONE4),L(ZONE5)
          DB      L(ZONE6),L(ZONE7),L(ZONE8)
          DB      L(ZONE9),L(ZONE10),L(ZONE11)
LISTTABH  DB      H(ZONE0),H(ZONE1),H(ZONE2)
          DB      H(ZONE3),H(ZONE4),H(ZONE5)
          DB      H(ZONE6),H(ZONE7),H(ZONE8)
          DB      H(ZONE9),H(ZONE10),H(ZONE11)


****************************
*DLI HANDLER
DLI       PHA                            ;DLI HANDLER
          TXA
          PHA
          LDX     NUMDLI                ;SEE WHAT DLI IT IS
          BMI     ZRTI                   ;IF NEGATIVE, NO DLI
          LDA     DLITABL,X
          STA     DLIPTR
          LDA     DLITABH,X
          STA     DLIPTR+1
          JMP     (DLIPTR)

HSCDLI
          LDA     #$FF
          STA     NUMDLI
          LDA     #$48                   ;B3-B0 = BORDER CONTROL,KANG,READMODE
          STA     CTRLWT                 ;RM: 0 = 160, 1 = X, 2 = 320B, 3 =320A
          LDX     #66-16
HSCDLOOP  STA     WSYNC
          DEX
          BPL     HSCDLOOP
          LDA     #$4B                   ;FOR HSC DISPLAY
          STA     CTRLWT
          INC     FRMCNT
          JSR     WVBLANK
          LDA     #NHSCDLI
          STA     NUMDLI
          BPL     ZRTI                   ;always

TITLEDLI  LDA     #$FF
          STA     NUMDLI
          INC     FRMCNT
          JSR     WVBLANK
          LDA     #NTITLDLI
          STA     NUMDLI
          BPL     ZRTI                   ;always


OVERDLI0
GAMEDLI0  LDA     #$00                   ;SET STATE FOR SCORE
          STA     BACKGRND
          LDA     #H(CHARS)              ;POINT CHARBASE TO SCORE CHARSET
          STA     CHARBASE
          INC     NUMDLI
          JMP     ZRTI

OVERDLI1  LDA     #$D3
          BNE     OVEROVER               ;JMP...
GAMEDLI1                                 ;SET STATE FOR SCREEN
          LDA     #H(ISTAMPS)            ;POINT CHARBASE TO PLAYFIELD STAMPS
          STA     CHARBASE
          LDA     #$F9
OVEROVER  INC     NUMDLI
          STA     WSYNC                  ;WAIT FOR LINE RAM TO FILL
*         STA     WSYNC                  ;(MARIA IS 1+ LINES AHEAD OF US)
          STA     BACKGRND
          JMP     ZRTI

OVERDLI2  LDA     #$FF                   ;DEFAULT, SYNC DLI'S
          STA     NUMDLI                ;TURN DLI'S OFF
          INC     FRMCNT
          JSR     WVBLANK
          MOVE    #NOVERDLI,NUMDLI
          BPL     ZRTI

GAMEDLI2  INC     NUMDLI
          INC     FRMCNT
ZRTI      PLA
          TAX
          PLA
IRQ       RTI                            ;IRQ'S GET VECTORED HERE ALSO

GAMEDLI3  LDA     #$FF                   ;DEFAULT, SYNC DLI'S
          STA     NUMDLI                ;TURN DLI'S OFF
          JSR     WVBLANK
          MOVE    #NGAMEDLI,NUMDLI
          STA     BACKGRND
          BEQ     ZRTI                   ;BRANCH ALWAYS

DLITABL   DB      L(GAMEDLI0),L(GAMEDLI1),L(GAMEDLI2),L(GAMEDLI3)
          DB      L(OVERDLI0),L(OVERDLI1),L(OVERDLI2)
          DB      L(TITLEDLI),L(HSCDLI)
DLITABH   DB      H(GAMEDLI0),H(GAMEDLI1),H(GAMEDLI2),H(GAMEDLI3)
          DB      H(OVERDLI0),H(OVERDLI1),H(OVERDLI2)
          DB      H(TITLEDLI),H(HSCDLI)
********** GROUND TARGET SUBROUTINES *******************************************


*THIS ROUTINE UPDATES GTARVPOS OF ALL FULLY LOADED GROUND TARGETS
*IT MUST BE RUN IN THE SCROLL SUBROUTINE (COARSE OR FINE)

GTARG
          LDA     FLAGFLAG
          CMP     #$02
          BCC     ZFLAGZIP
          DEC     FLAGYPOS
ZFLAGZIP  LDX     GTARGCNT
          BEQ     ZSTOP0                 ;BRANCH IF NO TARGETS
GSCRLOOP  DEC     GTARVPOS-1,X
          DEX
          BNE     GSCRLOOP
ZSTOP0




********************************************************************************
********************************************************************************


*THIS ROUTINE UPDATES GROUND TARGET TABLES WHEN IT FINDS TARGET(S) THAT HAVE
*SCROLLED OFF THE SCREEN

          LDX     GTARGCNT
          BEQ     ZSTOP1                 ;BRANCH IF NO TARGETS
GCHKLOOP  LDA     GTARVPOS-1,X
          BEQ     ZSCRLOFF
ZGTDEX    DEX
          BNE     GCHKLOOP
ZSTOP1    JMP     ZSTOP2

*TARGET HAS SCROLLED OFF SCREEN (I.E. GTARVPOS=0)
ZSCRLOFF
          LDA     GTARTYPE-1,X
          CMP     #$07
          BNE     ZSVC
          LDA     #$00
          STA     FLAGFLAG

ZSVC
          DEC     GTARGCNT
          LDY     GTARGCNT

          LDA     GTARTYPE,Y             ;GET INFO FROM BOTTOM OF TABLE
          STA     GTARTYPE-1,X             ;AND PUT IT INTO NEW EMPTY SPACE

          LDA     FGTTIME,Y              ;FIRING TIME DELAY
          STA     FGTTIME-1,X

          LDA     FGTSPRT,Y              ;NUMBER OF SHOTS IN A SPURT
          STA     FGTSPRT-1,X

          LDA     GTARPOS,Y              ;X IS POINTER INTO NEW SLOT
          STA     GTARPOS-1,X              ;Y POINTS TO BOTTOM OF LIST

          LDA     GTARGID,Y
          STA     GTARGID-1,X

          LDA     GTARPTRL,Y
          STA     GTARPTRL-1,X

          LDA     GTARPTRH,Y
          STA     GTARPTRH-1,X

          LDA     GTARVPOS,Y
          STA     GTARVPOS-1,X

          LDA     CRATTIME,Y
          STA     CRATTIME-1,X

          LDA     CRATSTMP,Y
          STA     CRATSTMP-1,X

          DEC     NGTARCNT
          LDA     NGTARCNT               ;SEE IF THE TWO POINTERS OVERLAP
          CMP     GTARGCNT
          BEQ     ZGTDEX
          LDY     NGTARCNT
          STX     TEMP0                  ;SAVE STATE OF X
          LDX     GTARGCNT

          LDA     GTARTYPE,Y             ;GET INFO FROM BOTTOM OF TABLE
          STA     GTARTYPE,X             ;AND PUT IT INTO NEW EMPTY SPACE

          LDA     FGTTIME,Y              ;FIRING TIME DELAY
          STA     FGTTIME,X

          LDA     FGTSPRT,Y              ;NUMBER OF SHOTS IN A SPURT
          STA     FGTSPRT,X

          LDA     GTARPOS,Y              ;X IS POINTER INTO NEW SLOT
          STA     GTARPOS,X              ;Y POINTS TO BOTTOM OF LIST

          LDA     GTARGID,Y
          STA     GTARGID,X

          LDA     GTARPTRL,Y
          STA     GTARPTRL,X

          LDA     GTARPTRH,Y
          STA     GTARPTRH,X

          LDA     GTARVPOS,Y
          STA     GTARVPOS,X

          LDA     CRATTIME,Y
          STA     CRATTIME,X

          LDA     CRATSTMP,Y
          STA     CRATSTMP,X

          LDX     TEMP0                  ;GET BACK STATE OF X

          JMP     ZGTDEX
ZSTOP2
          CLC                            ;NEEDED TO HAVE A CLEAR  CARRY IN THE
                                         ;LOADER!!!!!
          RTS



********************************************************************************
********************************************************************************

*THIS ROUTINE HANDLES GROUND BASED COLLISIONS


*                             T1
*                             !
*                             !
*                   T2 ------ X ------ T3
*                             !
*                             !
*                             T1

* X IS POSITION OF BOMB
* T0-T3 ARE TEMPORARY REGISTERS


************************         NEW COLLDETB           ************************

************************************
SIGHTCIT                                 ;see if sight passes over citadel
          LDA     BOMBING                ;set COLLDETB FLAG
          BEQ     ENUFTIME               ;cannot run with COLLDETB
          MOVE    #0,BOMBING
          RTS
ENUFTIME
          LDA     ELYPOS+1               ;FIND AREA OF EFFECT FOR SIGHT
          CLC
          ADC     #11
          SEC
          SBC     ANTITOTL
          STA     T0
          SEC
          SBC     #22
          STA     T1

          LDA     ELXPOS+1               ;FIND AREA OF EFFECT FOR SIGHT
          SEC
          SBC     #5
          STA     T2
          CLC
          ADC     #14
          STA     T3

          MOVE    #BLUSIGHT,SIGHTCOL
          LDX     GTARGCNT               ;THESE TWO COMMANDS MUST COME AFTER THE
          BEQ     CITADONE               ;BOMB POSITION CALCULATOR SO THAT THE
                                         ;VALUES T0-T4 CAN BE USED BY HYBCOLL
CITALOOP
          LDA     GTARTYPE-1,X
          CMP     #CRATTYPE                    ;IGNORE IF A CRATER
          BEQ     CITADEX
          CMP     #FLAGTYPE
          BEQ     CITADEX
          LDA     GTARPOS-1,X
          CMP     T2
          BCC     CITADEX
          CMP     T3
          BCS     CITADEX
          LDA     GTARVPOS-1,X
          CMP     T0
          BCS     CITADEX
          CMP     T1
          BCC     CITADEX
;IT'S A CIT!!! IT'S A CIT!!!! IT'S A CIT!!!
          MOVE    #REDSIGHT,SIGHTCOL
          BNE     CITADONE               ;JMP...
CITADEX   DEX
          BPL     CITALOOP
CITADONE  RTS

**************************************
COLLDETB
          INC     BOMBING                ;set COLLDETB FLAG
          TXA
          PHA
          TAY

          LDA     ELYPOS,Y               ;FIND AREA OF EFFECT FOR BOMB
          CLC
          ADC     #17
          SEC
          SBC     ANTITOTL
          STA     T0
          SEC
          SBC     #21
          STA     T1

          LDA     ELXPOS,Y               ;FIND AREA OF EFFECT FOR BOMB
          SEC
          SBC     #9
          STA     T2
          CLC
          ADC     #14
          STA     T3

          LDX     GTARGCNT               ;THESE TWO COMMANDS MUST COME AFTER THE
          BEQ     COLBDONE               ;BOMB POSITION CALCULATOR SO THAT THE
                                         ;VALUES T0-T4 CAN BE USED BY HYBCOLL
GCOLLOOP
          LDA     GTARTYPE-1,X
          CMP     #CRATTYPE
          BEQ     GCOLLDEX
          LDA     GTARPOS-1,X
          CMP     T2
          BCC     GCOLLDEX
          CMP     T3
          BCS     GCOLLDEX
          LDA     GTARVPOS-1,X
          CMP     T0
          BCS     GCOLLDEX
          CMP     T1
          BCC     GCOLLDEX
;IT'S A HIT!!! IT'S A HIT!!!! IT'S A HIT!!!
          LDA     GTARTYPE-1,X
          CMP     #$06
          BEQ     NOTUNYET

          LDA     #XPLOTUNE
          JSR     TUNIN                  ;PUT IN THE EXPLOSION SOUND

NOTUNYET
          LDA     GTARPOS-1,X            ;SET UP VARIABLES FOR AIREXPQ ROUTINE
          STA     TEMP7
          LDA     GTARVPOS-1,X
          STA     TEMP8

          LDA     GTARPTRL-1,X           ;SET UP THE POINTERS NEEDED TO FIND THE
          STA     TEMP9                  ;GROUND TARGET IN THE CHARACTER MAP
          LDA     GTARPTRH-1,X
          STA     TEMP10

          LDA     #$FC                   ;STOP THE OBJECT FROM FIRING EVER AGAIN
          STA     FGTSPRT-1,X

          LDA     GTARTYPE-1,X
          TAY
          LDA     DETBLPTR,Y
          STA     TEMP0
          LDA     DETBHPTR,Y
          STA     TEMP1
          JMP     (TEMP0)                ;VECTOR TO APPROPRIATE ROUTINE

GCOLLDEX                                 ;ALMOST ALL OF THE ROUTINES ABOVE WILL
                                         ;VECTOR BACK TO HERE
          DEX
          BNE     GCOLLOOP
COLBDONE
          PLA
          TAX
          RTS
DETBLPTR  DB      L(COLBDOME),L(COLBDOME),L(COLBDOME),L(COLBDOME)
          DB      L(COLBMEGA),L(COLBMEGA),L(COLBCIT),L(COLBFLAG)
          DB      L(COLBCPX),L(COLBDOME),L(COLBDOME),L(COLBDOME)
          DB      L(COLBDOME),L(COLBMEGA),L(COLBMEGA)

DETBHPTR  DB      H(COLBDOME),H(COLBDOME),H(COLBDOME),H(COLBDOME)
          DB      H(COLBMEGA),H(COLBMEGA),H(COLBCIT),H(COLBFLAG)
          DB      H(COLBCPX),H(COLBDOME),H(COLBDOME),H(COLBDOME)
          DB      H(COLBDOME),H(COLBMEGA),H(COLBMEGA)


;ROUTINE FOR DOMES, SM. PYRAMID, DETECTORS, MINI-HOSER, PERIPHERAL DOME AND THE
;FINAL CITADEL COLLIOSION

COLBDOME
          JSR     DOSCORE
          JSR     AIREXPQ
          JSR     GNDEXPQ
          LDA     #CRATTYPE
          STA     GTARTYPE-1,X
          JMP     GCOLLDEX


;ROUTINE FOR LARGE PYRAMID AND MEGASITE

COLBMEGA
          JSR     DOSCORE
          STX     TEMP4                  ;NON-ZERO AND X STORAGE REGISTER
          LDA     GTARGID-1,X
          STA     TEMP5

ZAPP
          LDY     #0
          LDA     #CRATTYPE
          STA     GTARTYPE-1,X
          LDA     (TEMP9),Y
          CLC
          ADC     #$8
          STA     (TEMP9),Y
          INY
          LDA     (TEMP9),Y
          CLC
          ADC     #$8
          STA     (TEMP9),Y

          LDA     TEMP4
          BNE     ZASQ
          DEC     TEMP7                  ;POSITION AIR EXPLOSION PROPERLY
          JSR     AIREXPQ
          JMP     COLBDONE

ZASQ
          LDX     GTARGCNT
ZPYMMEGA
          LDA     GTARGID-1,X
          CMP     TEMP5                  ;FIND THE OTHER HALF
          BNE     ZZ2
          CPX     TEMP4
          BNE     ZOTHRHLF
ZZ2       DEX
          BNE     ZPYMMEGA
          BEQ     COLBDONE               ;ALWAYS

ZOTHRHLF                                 ;WE FOUND THE  OTHER HALF
          LDA     #$FC
          STA     FGTSPRT-1,X
          LDA     GTARPTRL-1,X
          STA     TEMP9
          LDA     GTARPTRH-1,X
          STA     TEMP10
          LDA     #0
          STA     TEMP4
          BEQ     ZAPP                   ;BRANCH ALWAYS


;THIS ROUTINE IS FOR THE FLAG

COLBFLAG
          JSR     DOSCORE
          LDA     FLAGFLAG
          CMP     #$02
          BNE     BDONE
          LDA     #$DE
          LDY     #$0
          STA     (TEMP9),Y
          LDA     #$3
          STA     FLAGFLAG
          TYA
          STA     CRATSTMP-1,X           ;NO ANIMATION THANKS

BDONE     JMP     COLBDONE

;THIS ROUTINE IS FOR THE CITADEL

COLBCIT
          LDY     #$0
          LDA     (TEMP9),Y
          CMP     #$DA
          BCC     NOZHIT1
          LDA     #XPLOTUNE
          JSR     TUNIN                  ;PUT IN THE EXPLOSION SOUND
          LDY     #6                     ;GTARTYPE
          JMP     COLBDOME
NOZHIT1   CMP     #$D6
          BCS     ZAX
          LDA     #$D6
          STA     (TEMP9),Y
          LDA     #$0D
          STA     CRATTIME-1,X
          STA     CRATSTMP-1,X
          LDY     #$6                    ;GTARTYPE
          JSR     DOSCORE
          LDA     #XPLOTUNE
          JSR     TUNIN                  ;PUT IN THE EXPLOSION SOUND
ZAX       JMP     GCOLLDEX

;THIS ROUTINE IS FOR DOME CENTER AND COMPLEX DESTRUCTION

COLBCPX
          LDA     #$01
          STA     TEMP11                 ;BUILDING COUNTER
          JSR     AIREXPQ
          JSR     GNDEXPQ
          LDA     #CRATTYPE
          STA     GTARTYPE-1,X

          LDX     GTARGCNT
CPXLOOP
          LDA     GTARTYPE-1,X
          CMP     #9
          BNE     NOPERIPH
          INC     TEMP11                 ;FOUND ANOTHER PERIPHERAL DOME
          LDA     GTARPOS-1,X
          STA     TEMP7
          LDA     GTARVPOS-1,X
          STA     TEMP8
          LDA     GTARPTRL-1,X
          STA     TEMP9
          LDA     GTARPTRH-1,X
          STA     TEMP10
          LDA     #$FC
          STA     FGTSPRT-1,X
          JSR     AIREXPQ
          JSR     GNDEXPQ
          LDA     #CRATTYPE
          STA     GTARTYPE-1,X
NOPERIPH
          DEX
          BNE     CPXLOOP
          LDY     #8                     ;TYPE VALUE FOR CENTER OF DOME COMPLEX
          JSR     DOSCORE
          LDX     TEMP11
          CPX     #$05
JBDONE    BEQ     BDONE
DOPERIPH
          DEX
          BEQ     JBDONE
          LDY     #9                     ;TYPE VALUE FOR PERIPHERAL DOME
          JSR     DOSCORE
          JMP     DOPERIPH








;COLLDETB SUBROUTINES

* PUT IN AIR EXPLOSION STAMP
AIREXPQ
          TXA
          PHA
          LDA     OBJRESRV
          CMP     SHOTCNT
          BCS     NOAIREXP               ;SORRY, NO ROOM AT THE INN
          LDA     #$3
          STA     PRIORITY
          JSR     LNKINSRT
          TXA
          TAY

          LDA     #$03
          STA     ELPRIOR,Y
          LDA     #$06
          STA     ELANIMT,Y
          JSR     FLFNO2
          LDA     #$20
          STA     ELYSPEED,Y
          LDA     #$40
          STA     ELDIR,Y
          LDA     #ASKNOLY2              ;ACEXPLOS-ACTIONRL
          STA     ELSTATE,Y

          LDA     TEMP7                  ;GTARPOS-1,X
          SEC
          SBC     #$01
          STA     ELXPOS,Y
          LDA     TEMP8                  ;GTARVPOS-1,X
          CLC
          ADC     ANTITOTL
          SEC
          SBC     #$01
          STA     ELYPOS,Y

          LDA     #$00
          STA     ELCLASS,Y
          STA     ELACCELT,Y
          STA     ELXACCEL,Y
          STA     ELYACCEL,Y
          STA     ELXSPEED,Y
          STA     ELXSLOP,Y
          STA     ELYSLOP,Y

          INC     OBJCNT
          INC     OBJRESRV
NOAIREXP
          PLA
          TAX
          RTS




* PUT IN GROUND EXPLOSION STAMP
GNDEXPQ
          LDA     #$DC
          PHA
          LDA     #CLRSTMP
          PHA

          LDY     #0
          LDA     (TEMP9),Y
          CMP     #$BC
          BCC     GRNCRAT
          CMP     #$D0
          BCS     GRNCRAT
GRYCRAT
          AND     #$03
          CLC
          ADC     #$CC
          ORA     #$F0
          STA     FGTSPRT-1,X            ;COLOR OF CRATER INDICATOR
          CMP     #$FC
          BEQ     GRNCRAT
          PLA
          PLA
          LDA     #$0A                   ;GRAY BACKED EXPLOSION
          PHA
          LDA     #$B0                   ;GRAY SQUARE
          PHA

GRNCRAT
          PLA
          STA     CRATSTMP-1,X
          PLA
          STA     (TEMP9),Y

* SET UP PARAMETERS TO ANIMATE EXPLOSIONS

          LDA     #$06                   ;NUMBER OF FRAMES BEFORE PUTTING IN
          STA     CRATTIME-1,X           ;CRATER STAMP
          RTS

;UPDATE SCORE
DOSCORE
          TXA                                ;JUST TO TEST OUT SCORE MECHANISM
          PHA

          TYA
          CLC
          ADC         #$30                   ;TO SHOW IT'S A GROUND TARGET
          TAX                                ;TARGET TYPE IS PASSED IN X
          JSR         SCORCOMP               ;SCORE COMPUTE FOR BUILDINGS

          PLA
          TAX
          RTS






*ANIMATE EXPLOSIONS INTO CRATERS
CRATERS   LDX     GTARGCNT
          BEQ     CRATDONE               ;BRANCH IF NO EXPOSIONS  TO ANIMATE
          LDY     #$00                   ;FOR INDIRECT INDEXING PURPOSES
CRATLOOP
          LDA     CRATSTMP-1,X
          BEQ     ZCRATDEX               ;A ZERO INDICATES NO ANIMATION WANTED

          LDA     GTARPTRL-1,X
          STA     TEMP0
          LDA     GTARPTRH-1,X
          STA     TEMP1

          LDA     GTARTYPE-1,X
          CMP     #$6
          BEQ     ANIMCIT                ;NO FLASHING FOR CITADELS

          DEC     CRATTIME-1,X
          BEQ     EXPTOCRT
          LDA     (TEMP0),Y              ;JUST FLIP TWO STAMPS FOR FLASHING
          PHA
          LDA     CRATSTMP-1,X
          STA     (TEMP0),Y
          PLA
          STA     CRATSTMP-1,X
ZCRATDEX  DEX
          BNE     CRATLOOP
CRATDONE
          RTS


*TURN EXPLOSION INTO CRATER
EXPTOCRT
          LDA     FGTSPRT-1,X            ;GET COLOR OF CRATER INDICATOR
          AND     #$CF
          STA     (TEMP0),Y
          TYA                            ;Y IS A ZERO
          STA     CRATSTMP-1,X
          BEQ     ZCRATDEX               ;BRANCH ALWAYS

ANIMCIT
          DEC     CRATTIME-1,X
          BNE     ZCRATDEX
          LDA     #$10
          STA     CRATTIME-1,X           ;NEXT ANIMATION TIME
          LDA     (TEMP0),Y
          CLC
          ADC     #$02
          CMP     #$DC
          BCS     ZCRATDEX               ;NO MORE ANIMATING
          STA     (TEMP0),Y
          BCC     ZCRATDEX               ;ALWAYS


****************** NEW AND IMPROVED GROUND FIRING ROUTINES *********************
*NOTE:  ALL DELAY TIMES SHOULD BE MULTIPLIED BY TWO TO REACH DELAY TIMES IN
*       NUMBER OF FRAMES


GFIRE
          LDX     GTARGCNT
          BEQ     FGTRTS                 ;NO GROUND TARGETS
          LDA     RACK
          ASL     A
          ASL     A
          STA     TEMP7
          DEX
DECTIME   DEC     FGTTIME,X
          BEQ     TIME2FIR               ;BRANCH TO FIRE
FGTDEX    DEX
          BPL     DECTIME
FGTRTS    RTS                            ;ALL DONE WITH LIST

TIME2FIR
          LDA     FGTSPRT,X
          CMP     #$FC
          BCS     FGTDEX                 ;OOPS, NOT A FIREABLE TARGET
          LDY     #$00
          LDA     GTARTYPE,X
          BEQ     FIREBLDG               ;DOME
          INY
          CMP     #$03
          BEQ     FIREBLDG               ;MINI HOSER
          INY
          CMP     #$05
          BEQ     FIREBLDG               ;MEGA HOSER
          INY
          CMP     #$08
          BCC     FGTDEX                 ;CENTER OF COMPLEX IS AN 8
          CMP     #13                    ;NO DOLLAR SIGN!!!!
          BCS     FGTDEX                 ;BOTTOM OF COMPLEX IS A 12
;FALLS THROUGH HERE IF IT'S A DOME COMPLEX

FIREBLDG

          STY     TEMP8
          LDA     GTARTYPE,X
          CMP     #$05                   ;MEGA  HOSER FIRES FROM BEHIND
          BEQ     ZK100
          LDA     GTARVPOS,X
          ADC     ANTITOTL
          SEC
          SBC     #16
          CMP     ELYPOS
          BCS     ZK100
          LDA     #$FC                   ;DONT FIRE ANYMORE
          STA     FGTSPRT,X
          BNE     FGTDEX                 ;BRANCH ALWAYS
ZK100
          LDA     FGTSPRT,X
          BEQ     GRNDSPRT
          LDA     GTARVPOS,X             ;POSITION SHOT ABOVE DOME IN COMPLEX
          CLC
          ADC     VSHFTTAB,Y
          CLC
          ADC     ANTITOTL               ;ACCUMULATED ANTI SCROLL
          STA     TEMP15
          LDA     GTARPOS,X
          SEC
CENTBLDG  SBC     HSHFTTAB,Y
          STA     TEMP14
          JSR     FIRE1                  ;AND FIRE!!!!

          DEC     FGTSPRT,X              ;UPDATE SPURT SHOT COUNTER
          BEQ     GRNDSPRT

AA1S      LDA     SPRTTAB,Y              ;SPURT TIME DELAY
          STA     FGTTIME,X
          JMP     FGTDEX                 ;NOW FINISH TABLE

GRNDSPRT
          LDA     LRNDPTR,Y
          STA     TEMP14
          LDA     HRNDPTR,Y
          STA     TEMP15
          JMP     (TEMP14)               ;JUMP TO APPROPRIATE RANDOM ROUTINE FOR
                                         ;NUMBER AND DELAY TIME FOR SHOTS

ZCMPXRND
          LDA     RNDM                   ;REGISTER USED IN RANDOM NUMBER GENER.
          LSR     A                      ;GENERATE A RANDOM 1 OR 2 FOR NUMBER
          AND     #$01                   ;OF SHOTS PER SPURT
          CLC
          ADC     #$01
          STA     FGTSPRT,X
CALCSPRT  JSR     RANDOM
          LDA     CURROW
          LSR     A
          LSR     A
          AND     #$1F
          STA     TEMP9
AA1       LDA     TEMP7                  ;RACK TIMES 4
          CLC
          ADC     TEMP8                  ;BLDG TYPE
          TAY
          LDA     RNDM
          AND     #$0E
          ADC     INTRSPRT,Y
          SEC
          SBC     #$07
          SBC     TEMP9                  ;INTER-SPURT TIME DELAY
                                         ;WAS 80
          STA     FGTTIME,X              ;FASTEST SPURT IS 40 DECIMAL
          LDA     DIFCULTY
          BEQ     OREZ
          CMP     #$01
          BNE     GOTODEX
ENO       LDA     #$28
          CLC
          ADC     FGTTIME,X
          STA     FGTTIME,X
          BCS     FIXIT
          BCC     GOTODEX
OREZ      LDA     #$50
          CLC
          ADC     FGTTIME,X
          STA     FGTTIME,X
          BCC     GOTODEX
FIXIT     LDA     #$F0
          STA     FGTTIME,X
GOTODEX   JMP     FGTDEX


ZMINIRND
          LDA     RNDM                   ;REGISTER USED IN RANDOM NUMBER GENER.
          AND     #$01                   ;GENERATE A RANDOM 1, 2 OR 3 FOR NUMBER
          CLC                            ;OF SHOTS PER SPURT
          ADC     #$01                   ;50 PERCENT CHANCE FOR 2 SHOTS PER
          STA     TEMP0
          LDA     RNDM
          LSR     A
          AND     #$01
          CLC
          ADC     TEMP0
          STA     FGTSPRT,X
          JMP     CALCSPRT


ZDOMERND
          LDA     RNDM                   ;REGISTER USED IN RANDOM NUMBER GENER.
          LSR     A                      ;GENERATE A RANDOM 1 OR 2 FOR NUMBER
          AND     #$01                   ;OF SHOTS PER SPURT
          CLC
          ADC     #$01
          STA     FGTSPRT,X
          JMP     CALCSPRT


ZMEGARND
          LDA     RNDM                   ;REGISTER USED IN RANDOM NUMBER GENER.
          LSR     A                      ;GENERATE A RANDOM 1, 2, 3, FOR 4 FOR
          AND     #$01                   ;NUMBER OF SHOTS PER SPURT
          CLC                            ;EQUAL PROBABILITY FOR ALL
          ADC     #$01
          STA     TEMP0
          LDA     RNDM
          LSR     A
          AND     #$02
          CLC
          ADC     TEMP0
          STA     FGTSPRT,X
          JMP     CALCSPRT


;DOME THEN MINI THEN MEGA THEN COMPLEX
INTRSPRT  DB      248,150,90,230         ;RACK 0
          DB      218,137,84,211         ;RACK 1
          DB      188,125,78,192         ;RACK 2
          DB      158,112,71,173         ;RACK 3
          DB      128,100,65,154         ;RACK 4
          DB      98,87,58,135         ;RACK 5
          DB      68,75,52,116         ;RACK 6
          DB      58,62,45,97          ;RACK 7
          DB      55,50,39,78          ;RACK 8
          DB      52,37,32,59          ;RACK 9
          DB      48,25,26,40           ;RACK A
          DB      48,25,26,40            ;RACK B
          DB      48,25,26,40            ;RACK C
          DB      48,25,26,40            ;RACK D
          DB      48,25,26,40            ;RACK E
          DB      48,25,26,40            ;RACK F

VSHFTTAB  DB      6,6,6,6
HSHFTTAB  DB      1,0,1,1
SPRTTAB   DB      20,6,6,10
LRNDPTR   DB      L(ZDOMERND),L(ZMINIRND),L(ZMEGARND),L(ZCMPXRND)
HRNDPTR   DB      H(ZDOMERND),H(ZMINIRND),H(ZMEGARND),H(ZCMPXRND)


*SUBROUTINES FOR MAIN

FLFNO
          LDA     ELWHICH,Y
          STA     TEMP15
FLFNO2
          LDA     #ASKNOLY3              ;ANEXPLOS-ANIMTAB not fluff
          STA     ELANIM,Y
          LDA     ANEXPLOS               ;GET THE INITIAL STAMP
          STA     ELTYPE,Y
          LDA     #$1D
          STA     ELPALW,Y
*         LDA     #$1D
          STA     ELWHICH,Y
          RTS

ENDFLEI                                 ;GENERAL DESTRUCTO HANDLER
          LDA     #ASKNOLY4              ;ACEXPLOS-ACTIONRL
          STA     ELSTATE,Y
          LDA     #$03                   ;SET INITIAL ANIMATION TIME
          STA     ELANIMT,Y
ENDFLEI2
          LDA     #0
          STA     ELCLASS,Y              ;CHECK FOR JDM CONFLICT WITH CLASS=0
          STA     ELACCELT,Y             ;JUST IN CASE
          RTS

; This routine is called to initiate the "gameplay" mode; a jsr here could
;         be triggered by pressing the reset switch, or by pressing the
;         joystick button when not already in gameplay mode.

INITAUTO
          NEWSTATE AUTOPLAY
          LDX     #SEC20
          JSR     SETSYSCO               init timer
          LDA     #MAUTO
          BNE     WTVBLANK
INITGAME
          NEWSTATE  GAME                 call game next time
          LDA     #MGAME
WTVBLANK  STA     MODE
          JSR     WVBLANK
          LDA     #$70                   turn dma off
          STA     CTRLWT

          JSR     COLRINIT
          JSR     SOLVINIT
          LDA     MODE
          CMP     #MAUTO
          BNE     GAMEGAME
          JSR     CONSINT2
          JMP     MAPIMAPI
GAMEGAME  JSR     CONSINIT
MAPIMAPI  JSR     MAPINIT
          JSR     INITPLDR
          JSR     PRELOAD
          JSR     SLOADER
          JSR     SCRAPALL
          LDA     #MAN0TUNE
          JSR     TUNIN
          LDA     #MAN1TUNE
          JSR     TUNIN

          LDA     #NGAMEDLI
          STA     NUMDLI
          JSR     WVBLANK
          LDA     #$50                   ;TURN ON DMA
          STA     CTRLWT

BOTMAIN   ENDCYCLE
          END
