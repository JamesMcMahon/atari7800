*         2600    JOUST             JULY05.S

******   *     *     ****    *      *    ****    ******     *     *  *****
*        *     *    *    *   **     *   *    *   *          **   **  *
*        *     *    *    *   * *    *   *        *          * * * *  *
*        *******    ******   *  *   *   *        *****      *  *  *  ****
*        *     *    *    *   *   *  *   *  ****  *          *     *  *
*        *     *    *    *   *    * *   *    *   *          *     *  *
******   *     *    *    *   *     **    ****    ******     *     *  *****


;THIS IS THE NECESSARY PROLOG FOR STELLA (TIA) CODE

;  PIA AND TIMER (6532) LOCATIONS

SWCHA     EQU     $280  ;PO, P1 JOYSTICKS
SWCHB     EQU     $282  ;CONSOLE SWITCHES
CTLSWA    EQU     $281
CTLSWB    EQU     $283
INTIM     EQU     $284  ;INTERVAL TIMER IN
TIM8T     EQU     $295  ;TIMER 8T WRITE OUT
TIM64T    EQU     $296  ;TIMER 64T WRITE OUT

;  STELLA (TIA) REGISTER ADDRESSES

VSYNC     EQU     $00      ;BIT        1  VERTICAL SYNC SET-CLR
VBLANK    EQU     $01      ;BIT        1  VERTICAL BLANK SET-CLR
WSYNC     EQU     $02      ;STROBE        WAIT FOR HORIZ BLANK
RSYNC     EQU     $03      ;STROBE        RESET HORIZ SYNC COUNTER
NUSIZ0    EQU     $04      ;BITS   54 210 NUMBER-SIZE PLAYER/MISSILE 0
NUSIZ1    EQU     $05      ;BITS   54 210 NUMBER-SIZE PLAYER/MISSILE 1
COLUP0    EQU     $06      ;BITS 7654321  COLOR(4)-LUM(3) PLAYER 0
COLUP1    EQU     $07      ;BITS 7654321  COLOR(4)-LUM(3) PLAYER 1
COLUPF    EQU     $08      ;BITS 7654321  COLOR(4)-LUM(3) PLAYFIELD
COLUBK    EQU     $09      ;BITS 7654321  COLOR(4)-LUM(3) BACKGROUND
CTRLPF    EQU     $0A      ;BITS 7 54 210 PLAYFIELD CONTROL
REFP0     EQU     $0B      ;BIT      3    REFLECT PLAYER 0
REFP1     EQU     $0C      ;BIT      3    REFLECT PLAYER 1
PF0       EQU     $0D      ;BITS 7654     PLAYFIELD REG BYTE 0
PF1       EQU     $0E      ;BITS ALL      PLAYFIELD REG BYTE 1
PF2       EQU     $0F      ;BITS ALL      PLAYFIELD REG BYTE 2
RESP0     EQU     $10      ;STROBE        RESET PLAYER 0
RESP1     EQU     $11      ;STROBE        RESET PLAYER 1
RESM0     EQU     $12      ;STROBE        RESET MISSILE 0
RESM1     EQU     $13      ;STROBE        RESET MISSILE 1
RESBL     EQU     $14      ;STROBE        RESET BALL
AUDC0     EQU     $15      ;BITS     3210 AUDIO CONTROL 0
AUDC1     EQU     $16      ;BITS     3210 AUDIO CONTROL 1
AUDF0     EQU     $17      ;BITS     3210 AUDIO FREQUENCY 0
AUDF1     EQU     $18      ;BITS     3210 AUDIO FREQUENCY 1
AUDV0     EQU     $19      ;BITS     3210 AUDIO VOLUME 0
AUDV1     EQU     $1A      ;BITS     3210 AUDIO VOLUME 1
GRP0      EQU     $1B      ;BITS ALL      GRAPHICS FOR PLAYER 0
GRP1      EQU     $1C      ;BITS ALL      GRAPHICS FOR PLAYER 1
ENAM0     EQU     $1D      ;BIT        1  ENABLE MISSILE 0
ENAM1     EQU     $1E      ;BIT        1  ENABLE MISSILE 1
ENABL     EQU     $1F      ;BIT        1  ENABLE BALL
HMP0      EQU     $20      ;BITS 7654     HORIZ MOTION PLAYER 0
HMP1      EQU     $21      ;BITS 7654     HORIZ MOTION PLAYER 1
HMM0      EQU     $22      ;BITS 7654     HORIZ MOTION MISSILE 0
HMM1      EQU     $23      ;BITS 7654     HORIZ MOTION MISSILE 1
HMBL      EQU     $24      ;BITS 7654     HORIZ MOTION BALL
VDELP0    EQU     $25      ;BIT         0 VERTICAL DELAY PLAYER 0
VDELP1    EQU     $26      ;BIT         0 VERTICAL DELAY PLAYER 1
VDELBL    EQU     $27      ;BIT         0 VERTICAL DELAY BALL
RESMP0    EQU     $28      ;BIT        1  RESET MISSILE TO PLAYER 0
RESMP1    EQU     $29      ;BIT        1  RESET MISSILE TO PLAYER 1
HMOVE     EQU     $2A      ;STROBE        ACT ON HORIZ MOTION
HMCLR     EQU     $2B      ;STROBE        CLEAR ALL HM REGISTERS
CXCLR     EQU     $2C      ;STROBE        CLEAR ALL COLLISION LATCHES
CXM0P     EQU     $30           ;READ ADDRESSES BITS 6 + 7 ONLY
CXM1P     EQU     $31
CXP0FB    EQU     $32
CXP1FB    EQU     $33
CXM0FB    EQU     $34
CXM1FB    EQU     $35
CXBLPF    EQU     $36
CXPPMM    EQU     $37
INPT0     EQU     $38
INPT1     EQU     $39
INPT2     EQU     $3A
INPT3     EQU     $3B
INPT4     EQU     $3C
INPT5     EQU     $3D

************   CONSTANTS   ****************
PFCOLOR1  EQU     $28
PFCOLOR2  EQU     $26
PFCOLOR3  EQU     $24
PFCOLOR4  EQU     $22
HEIGHT    EQU     5
UPPER     EQU     $34                    ;UPPER ZONE BOUNDARY
LOWER     EQU     $6C                    ;LOWER ZONE BOUNDARY
;ZERO PAGE RAM
          ORG     $80
FRMCNT    DS      1
LIVES     DS      2
HISCORE   DS      2
MIDSCORE  DS      2
LOWSCORE  DS      2
ATTRACT   DS      1                      ;FOR NOW BIT 7 AUTOPLAY BIT 6 FOR
                                         ;SHOW TITLE
                                         ;BOTTOM 5 BITS FOR DEBOUNCE COUNTER
RACKNUM   DS      1
TIMER     DS      1
PTR0      DS      1
TEMPM4FC  EQU     PTR0
PTR0H     DS      1
TEMP4     EQU     PTR0H
PTR1      DS      1
PTR1H     DS      1
STAMP0    DS      3                      ;ALSO  PTR2-PTR3H
PTR2      EQU     STAMP0
PTR2H     EQU     STAMP0+1
PTR3      EQU     STAMP0+2
STAMP1    DS      3                      ;ALSO  PTR4-PTR5H
PTR3H     EQU     STAMP1
PTR4      EQU     STAMP1+1
PTR4H     EQU     STAMP1+2
P0VTBL    DS      3
PTR5      EQU     P0VTBL
PTR5H     EQU     P0VTBL+1
P1VTBL    DS      3
P0HPOS    DS      3
P1HPOS    DS      3
;THESE REDEFINE P0HPOS THRU P1HPOS   AS TEMPS FOR CROSSING ROUTINE
TOPDEX    EQU     P0HPOS
MIDDEX    EQU     P0HPOS+2
BOTDEX    EQU     P1HPOS+1
P0CNT     DS      1
P1CNT     DS      1
COLOR0    DS      3
SCNTRLI0  EQU     COLOR0+0               SOUND CONTROL INPUT 0
SCNTRLI1  EQU     COLOR0+1               SOUND CONTROL INPUT 1
COLOR1    DS      3
INFP0     DS      3
PLAYCOL   EQU     INFP0                  ;COLOR OF JOUST BITMAP
LINECNT   EQU     INFP0+1                ;NUMBER OF LINES DOWN THAT BITMAP
                                         ;STARTS
COLORCNT  EQU     INFP0+2                ;INDEX INTO COLOR ROT TABLE
INFP1     DS      3
TEMP0     DS      1
TEMP1     DS      1
P0VOFF    EQU     TEMP1
TEMP2     DS      1
P1VOFF    EQU     TEMP2
PREVIOUS  EQU     TEMP2
TEMP3     DS      1
MPTR      EQU     TEMP3
ZONECNT   DS      1
CFIGINDX  DS      1                      INDEX INTO CLIFF CONFIGURATIONS
XPOS      DS      8                      X POSSITION FOR ALL MOVABLE OBJECTS
YPOSINT   DS      8                      INTEGER Y " "   "   "       "
STATES    DS      2                      ;BIT  7        FACING
                                         ;BIT   6       WALKING FOR PLAYERS
                                         ;BIT    5      FLY/SKID FOR PLAYERS
                                         ;              FOR NON-WALKING PLAYERS
                                         ;BITS   54     ANIMATION # FOR PLAYERS
                                         ;              WALKING
;TYPE MUST FOLLOW STATES
TYPE      DS      6                      ;BOTTOME NYBBLE,ENEMY  TYPE
STAT2     DS      2                      X VELOCITY AND GONE DEATH.... CODES
GEN2      DS      2                      EFFECTIVENESS/DELAY TIMER FOR PLAYERS

GENERALS  DS      2                      ;BITS 76543210 PLAYER Y POSSITION FRAC
SPEED     DS      6
                                         ;              IF FLYING
                                         ;BITS      210 CLIFF NUMBER
                                         ;BITS 7        BUTTON MEMORY FOR W/S
ASPEED    DS      6                      ;VERTICAL SPEED
EGGO      DS      6
EGGSCORE  DS      2
YVELINT   DS      2                      PLAYER Y VELOCITY INTEGER
PDTHSNUM  EQU     YVELINT
BIRTHAN   EQU     YVELINT                BIRTH ANIMATION COUNTER
SHLDSEC   EQU     YVELINT                SHEILD SECOND
YVELFRAC  DS      2                      PLAYER Y VELOCITY FRAC
PDETHTIM  EQU     YVELFRAC
SHLDTIM   EQU     YVELFRAC               SHEILD TIMER
PGONETIM  EQU     YVELFRAC               PLAYER GONE TIMER
BIRTHTIM  EQU     YVELFRAC               BIRTH TIMER
ENEMA     DS      1                      ;NUMBER OF ENEMIES



SNDTIM0   DS      1                      TIMER   SOUND 0
SNDTIM1   DS      1                      TIMER   SOUND 1
SNDINDX0  DS      1                      SOUND INDEX 0
SNDINDX1  DS      1                      SOUND INDEX 1
SNDTYP0   DS      1                      ;SOUND TYPE 0
SNDTYP1   DS      1                      ;SOUND TYPE 1
DEPNUM    DS      1                      ;NUMBER OF ENEMIES DEPLOYED
TOPCNT    DS      1
MIDCNT    DS      1
BOTCNT    DS      1

TERYCNT   DS      1                      NUMBER OF TERRIES CURRENTLY OUT
TERYTIME  DS      1                      TIMER FOR TERRY DEPLOYMENT
TITIMNDX  DS      1                      INDEX INTO INITIAL TERRY TIMES TABLE
GAMETYPE  DS      1                      ;BIT 0 FOR 1 OR 2 PLAYERS
                                         ;BIT 1 FOR REGULAR OR BONZO
GLADRAG   DS      1                      ;GLADIATOR, SURVIVAL, TEAM FLAGS
                                         ;BIT 7 FOR GLADIATOR
                                         ;BIT 6 FOR SURVIVAL, TEAM
*         THESE CONSTANTS ARE THE BITS PATTERNS RETURNED BY PMOTION FOR SOUNDS

NOTSOUND  EQU     0
WLKSOUND  EQU     1
FLPSOUND  EQU     2
BNCSOUND  EQU     3
SKDSOUND  EQU     4
STPSKDSN  EQU     5
XPLSOUND  EQU     6
BIRTHSND  EQU     7
SHLDSND   EQU     8
STPSHLDS  EQU     9
TIESOUND  EQU     10
SCREETCH  EQU     11
VBRTHSND  EQU     12
EGGHTCH   EQU     13
EATEGG    EQU     14
EXTRAMAN  EQU     15


*         THESE ARE THE CONSTANTS RELATIVE TO PLAYER DEATH AND EXPLOIN ANIMATION

PDETHSTM  EQU     3
SHIELD    EQU     11
BIRTH1ST  EQU     13
PGONE     EQU     14
PDEATH    EQU     15
EXP0SNUM  EQU     7
EXP2SNP1  EQU     10
ISTATB1   EQU     $F0
ISTA2B1   EQU     $0D
ISTA2SLD  EQU     $0B
ISTA2WLK  EQU     $05

SHLDITIM  EQU     53
BRTHITIM  EQU     5
GONEITIM  EQU     $EE

*         THE FOLLOWING EQUIVILENCES ARE THE UP AND DOWN TERMINAL VELOCITIES
*                 ONLY THE INTEGER PART OF THE VELOCITY IS CHECKED; THEREFORE
*                 THE FOLLOWING ARE THE INTEGER TERMINAL VELOCITIES

UPVMAX    EQU     $FD
DWNVMAX   EQU     $2

*         THE FOLLOWING CONSTANTS ARE THE BOUNDS ON LEGAL X VALUES FOR A STAMP.
*                 THERE ARE TWO RIGHTS, SET AND COMPARE.

LMOSTPXL  EQU     1
RMSTSPXL  EQU     126
RMSTCPXL  EQU     127

*         THE FOLLOWING CONSTANT IS THE TOP OF SCREEN COMPARISON NUMBER
TOPSCNUM  EQU     191

*         TERRY CONSTANTS

TERYFLAG  EQU     $60                    TELLS BADGUY TO DEPLOY TERRY AT FLAG
LTERYTYP  EQU     $8C                    INITIAL TYPE FOR A LEFT TERRY
RTERYTYP  EQU     $0C                    INITIAL TYPE FOR A RIGHT TERRY
LTERYSPD  EQU     4                      INITIAL LEFT TERRY SPEED
RTERYSPD  EQU     0                      INITIAL RIGHT TERRY SPEED
ITITI     EQU     4                      INITIAL TERRY INITIAL TIME INDEX

*         THE FOLLOWING ARE BOUNDS FOR DELAY FOR WALK/SKID

MAXWDLAY  EQU     12                     MAXIMUM WALK DELAY
MAXSDLAY  EQU     8                      MAXIMUM SKID DELAY

*         THIS IS THE FLYING CLIFF TOP BOUNCE Y FRACTION

FBFRAC    EQU     $80

*         THE FOLLOWING ARE THE NUMBERS TO SET TO ALLOW AND TEST FOR HAPPENING
*                 FIRST EFFECTIVE FLYING FRAME.  THESE GO IN DELAY/EFFECT.

FLYFEFST  EQU     5
FLYFEFCP  EQU     4

ENDRAM

          ORG     $E000
E000      DB      0                      ;STORE 80 IN HERE TO FREEZE
E001      DB      0                      ;SLOWDOWN SPEED
E002      DB      0                      ;TEMP
E003      DB      0                      ;WHEN FROZEN, NUMBER OF FRAMES TO
                                         ;ADVANCE BEFORE STOPPING.  THE SPEED
                                         ;OF ADVANCEMENT IS SET IN E001

          ORG     $E100
FRZEOS    LDX     E000
          BMI     FREEZER
          DEX
          BPL     HOLDF
          BMI     NEWFRRTS
FREEZER   LDX     E003
          BEQ     HOLDF
          LDY     E002
          DEY
          BPL     HOLDF
NEWFRRTS  RTS
HOLDF     PLA
          PLA
          JMP     OWLOOP


FRZEBL    LDX     E000
          BMI     FRZE
          DEX
          STX     E000
          BPL     HOLDFB
          LDA     E001
          STA     E000
          RTS
FRZE      LDX     E003
          BEQ     HOLDFB
          LDY     E002
          DEY
          STY     E002
          BPL     HOLDFB
          DEC     E003
          LDA     E001
          STA     E002
          RTS
HOLDFB    PLA
          PLA
          JMP     DONE

* START OF EXECUTABLE CODE =====================================================
          ORG     $F000

FBANK     JMP     START

NOSEL     BMI     JMPOW

          BIT     ATTRACT                ;CHECK FOR TITLE PAGE
          BVC     REGDRVER

NORESET   LDX     LINECNT                ;IF LINECNT IS 0, WE ARE DONE
          BEQ     DOCOLROT

          LDA     FRMCNT                 ;FRMCNT IS ANDED TO GET BITMAP COLOR
          AND     #$77
          STA     PLAYCOL

          AND     #$03                   ;NOW AND FRMCNT WITH 3 TO GET RATE
          BNE     JMPOW                  ;OF BITMAP RISING
          DEX                            ;DEX TO MOVE BITMAP UP ONE LINE
          STX     LINECNT                ;STORE AWAY LINECNT
          BPL     JMPOW

DOCOLROT
          LDX     COLORCNT               ;INC INDEX EVERY FOUR FRAMES
          LDA     FRMCNT
          AND     #$03
          BNE     JMPOW
          INX
          STX     COLORCNT
          CPX     #9                     ;PEG IT AT EIGHT
          BCS     JMPOW
          LDA     ROT,X                  ;READ PLAYER COLORS OUT OF TABLE
          STA     PLAYCOL

JMPOW     JMP     OWLOOP

;;;;;;;;;;
REGDRVER  LDA     FRMCNT
          AND     #$03
          STA     TEMPM4FC

          LDA     #0
          STA     SCNTRLI0
          STA     SCNTRLI1
********************************************************************************
*                                                                              *
*         PLAYER 0 MOTION                                                      *
*                                                                              *
********************************************************************************

          BIT     ATTRACT                IF NOT IN AUTOPLAY GOTO CONTROL READER
;         BPL     GPSKP005
;         LDA     #0                     ;A IS STILL ZERO
          BMI     GPSKP010               ELSE DO AUTOPLAY CONTROL SIMULATION

GPSKP005  LDA     SWCHA                  FORMAT CONTROLS INTO ACC
          EOR     #$F0
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          LDX     INPT4
          BMI     GPSKP010
          ORA     #$80
GPSKP010  LDX     #0                     SELECT INDEX FOR PLAYER 0
          JSR     PMOTION                DO PLAYER 0'S MOTION
          CMP     SCNTRLI0               ;CHECK FOR PRIORITIES
          BMI     GPSKP011
          STA     SCNTRLI0
GPSKP011
********************************************************************************
*                                                                              *
*         PLAYER 0 / ENEMY COLLISION DETECT                                    *
*                                                                              *
********************************************************************************

          LDX     #0
          LDA     STAT2,X                IF PLAYER 0 NOT PRESENT SKIP ENEMY
          CMP     #SHIELD
          BPL     ENDHITP0

          LDA     FRMCNT
          LSR     A
          BCC     ODD
;         LDX     #0                     ;X IS ALREADY ZERO
          LDY     #2
          JSR     BONK
          LDX     #0
          LDY     #4
          JSR     BONK
          LDX     #0
          LDY     #6
          JSR     BONK
          JMP     ENDHITP0

ODD
;         LDX     #0                     ;X IS ALREADY ZERO
          LDY     #3
          JSR     BONK
          LDX     #0
          LDY     #5
          JSR     BONK
          LDX     #0
          LDY     #7
          JSR     BONK
ENDHITP0

********************************************************************************
*                                                                              *
*         ENEMY MOTION                                                         *
*                                                                              *
********************************************************************************

          LDA     FRMCNT
          BNE     PAST1

          LDA     GAMETYPE               ;NO TERRIES IN BONZO MODE
          CMP     #2
          BCS     JND

          DEC     TERYTIME               CONDITIONALS, FORCED TERRY DEPLOYMENT
          BPL     TTIME

          LDA     ENEMA
          BEQ     UNTIME
          CMP     #6
          BCS     UNTIME

          LDA     DEPNUM
          BPL     UNTIME

          LDA     TERYCNT
          CMP     #3
          BCC     DOTERYFL

UNTIME    INC     TERYTIME
          JMP     TTIME

DOTERYFL  LDX     #5                      FLAG AN ENEMY AREA TO DEPLOY A TERRY
NEXTENMY  LDA     TYPE,X
          BEQ     NOWTERY
          DEX
          BPL     NEXTENMY
          BMI     TTIME

NOWTERY
          LDA     #TERYFLAG
          STA     TYPE,X


          LDY     TITIMNDX               SET UP NEW TERRY TIMER
          DEY
          BPL     PTERY100
          LDY     #1
PTERY100  STY     TITIMNDX

          LDA     TITIMES,Y
          STA     TERYTIME
          BPL     TTIME
                                         ;CAN SKIP THIS IF WE WANT TO
                                         ;ON FALL THROUGH

PAST1     AND     #$3F
          BEQ     TTIME
JND       JMP     NODEP

TTIME
          LDX     #5
TRYLP     LDA     TYPE,X
          CMP     #TERYFLAG
          BEQ     TRYIT
          DEX
          BPL     TRYLP
          JMP     ENDEMOVE

TRYIT
          STX     ZONECNT
          LDY     #5
LBOUNDLP  LDA     TYPE,Y
          AND     #$0F
          BEQ     NEY
          LDA     YPOSINT+2,Y
          LDX     #2
          CMP     #UPPER+4
          BCC     STEP
          DEX
          CMP     #LOWER+4
          BCC     STEP
          DEX

STEP      CMP     LB,X
          BCC     NEY
          LDA     SPHINX-1,X
          TAX
          INC     TOPCNT,X
NEY       DEY
          BPL     LBOUNDLP

          LDY     #1
          LDA     LIVES
          BMI     YIS1
          LDA     LIVES+1
          BMI     YIS0
          LDA     HISCORE
          CMP     HISCORE+1
          BCC     YIS1
YIS0      DEY
YIS1      LDA     YPOSINT,Y
          LDX     #0
          CMP     #UPPER+4
          BCC     CHECKME
          INX
          CMP     #LOWER+4
          BCC     CHECKME
          INX
CHECKME   LDA     TOPCNT,X
          BEQ     GOHERE
          CMP     #2
          BCS     NOJLM
          CPX     #2
          BEQ     GOHERE
          INX
          LDA     TOPCNT,X
          DEX
          CMP     #2
          BNE     GOHERE


NOJLM     LDX     #2
ANSRCH    LDA     TOPCNT,X
          BEQ     GOHERE
          CMP     #2
          BCS     MOREX
          CPX     #2
          BEQ     GOHERE
          INX
          LDA     TOPCNT,X
          DEX
          CMP     #2
          BNE     GOHERE
MOREX     DEX
          BPL     ANSRCH

          LDA     #TERYFLAG              ;TERY FLAG IS ALREADY HERE
          LDX     ZONECNT
          STA     TYPE,X
          JMP     JEM

GOHERE    LDA     YVELFRAC
          ORA     TEMP2
          LSR     A
          STA     TEMP0
          CPX     #1
          BEQ     MIDDER
          BCS     BOTTER
                                         ;DO IN TOPZONE
TOPPER    LDA     #$0B
          BNE     STORER
MIDDER    AND     #$10
          BEQ     TOPPER
          BNE     STORER
BOTTER    AND     #$20
          BNE     STORER
LDA1F     LDA     #$1B
STORER    AND     TEMP0
          STA     TEMP0
          LDA     REVZONE,X
          TAY
          LDA     UB,Y
          CLC
          ADC     TEMP0

          LDX     ZONECNT
          STA     YPOSINT+2,X
          INC     ENEMA
          INC     TERYCNT

          LDA     GAMETYPE
          LSR     A
          BCC     NOHER1
          LDA     LIVES
          BMI     CHKHER1
          LDA     TEMP3                  ;RANDOM FACTOR???
          LSR     A
          BCC     CHKHER1
NOHER1    LDA     XPOS
          BPL     GOAHEAD
CHKHER1   LDA     XPOS+1
GOAHEAD   CMP     #$40
          BCC     LEFTTER
          LDA     #RMSTSPXL              DEPLOY A NEW TERRY ON THE RIGHT
          STA     XPOS+2,X
          LDY     #LTERYTYP
          LDA     #LTERYSPD
          BNE     COMTERY
LEFTTER
          LDA     #LMOSTPXL
          STA     XPOS+2,X
          LDY     #RTERYTYP
          LDA     #RTERYSPD
COMTERY   STY     TYPE,X
          STA     SPEED,X
          LDA     #SCREETCH
          CMP     SCNTRLI0
          BCC     CHSCN1
          STA     SCNTRLI0
          BCS     JEM
CHSCN1    CMP     SCNTRLI1
          BCC     JEM
          STA     SCNTRLI1

JEM       JMP     ENDEMOVE

SPHINX    DB      2,1

;PUT THIS CODE BEFORE CALLS TO BADGUY-- IT DERIVES WHICH ZONES THE HEROES ARE IN
NODEP
          LDY     #2
          LDA     YPOSINT
          CMP     #$FF
          BEQ     LDYFF0
          CMP     #UPPER
          BCC     DRIVE0
          CMP     #LOWER
          DEY
          BCC     DRIVE0
          DEY
DRIVE0    LDA     STAT2
          CMP     #SHIELD
          BEQ     LDYFF0
          CMP     #$E
          BNE     STYTEM0
LDYFF0    LDY     #$FF
STYTEM0   STY     TEMP2

          LDY     #2
          LDA     YPOSINT+1
          CMP     #$FF
          BEQ     LDYFF1
          CMP     #UPPER
          BCC     DRIVE
          CMP     #LOWER
          DEY
          BCC     DRIVE
          DEY
DRIVE     LDA     STAT2+1
          CMP     #SHIELD
          BEQ     LDYFF1
          CMP     #$E
          BNE     STYTEM3
LDYFF1    LDY     #$FF
STYTEM3   STY     TEMP2+1

          LDA     FRMCNT
          LSR     A
          BCC     ODD1
          LDX     #0                     ;X IS FF ON FALL THROUGH
          JSR     BADGUY
          LDX     #2
          JSR     BADGUY
          LDX     #4
          JSR     BADGUY
          JMP     ENDEMOVE

ODD1
          LDX     #1
          JSR     BADGUY
          LDX     #3
          JSR     BADGUY
          LDX     #5
          JSR     BADGUY
ENDEMOVE

********************************************************************************

          LDA     GAMETYPE               IF A TWO PLAYER GAME
          LSR     A
          BCC     OWLOOP

********************************************************************************
*                                                                              *
*         PLAYER 1 MOTION                                                      *
*                                                                              *
********************************************************************************


P1MOSHUN
          LDA     #0
          BIT     ATTRACT                IF NOT IN AUTOPLAY GOTO CONTROL READER
          BMI     GPSKP020

GPSKP015  LDA     SWCHA                  FORMAT CONTROLS FOR PLAYER 1
          EOR     #$0F
          AND     #$0F
          LDX     INPT5
          BMI     GPSKP020
          ORA     #$80
GPSKP020  LDX     #1                     SELECT INDEX FOR PLAYER 0
          JSR     PMOTION                DO PLAYER 1'S MOTION
          CMP     SCNTRLI1               ;CHECK FOR PRIORITIES
          BMI     PPCOL
          STA     SCNTRLI1


********************************************************************************
*                                                                              *
*         PLAYER / PLAYER COLLISION                                            *
*                                                                              *
********************************************************************************

PPCOL     LDA     STAT2+0
          CMP     #SHIELD                IF PLAYER 0 NOT PRESENT SKIP COLLISIONS
          BPL     PPCOLEND
          LDA     STAT2+1
          CMP     #SHIELD                IF PLAYER 1 NOT PRESENT SKIP COLLISIONS
          BPL     PPCOLEND

          LDX     #0
          LDY     #1
          JSR     NOPUNT
PPCOLEND
OWLOOP
          LDA     INTIM
          BNE     OWLOOP

* VERTICAL BLANK ===============================================================

NOOW      STA     WSYNC
          LDX     #2                     ;2 Turn on vertical sync and blanking
          STX     VSYNC                  ;5
          STX     VBLANK                 ;8

          LDA     DEPNUM                 ;11
          BPL     DOMORE                 ;13/14

DONTDO    STA     WSYNC                  ;16
          STA     WSYNC                  ;3
          JMP     NODEPL                 ;3

EGGER     LDA     #$20                   ;5
          STA     EGGO,Y                 ;9
          LDA     #0                     ;11
          BEQ     EGGBCK                 ;14

DOMORE    LDA     FRMCNT                 ;17
          AND     #$1F                   ;19
          BNE     DONTDO                 ;21/22

          LSR     SWCHB                  ;26
          BCC     DONTDO                 ;28/29 NOT WHEN RESET IS DOWN

          LDX     RACKNUM                ;31
          LDA     RACKLO,X               ;35
          STA     PTR0                   ;38
          LDA     #H(RACK0ENM)           ;40
          STA     PTR0H                  ;43

          LDY     ENEMA                  ;46
          DEY                            ;48
          TYA                            ;50
          SEC                            ;52
          SBC     DEPNUM                 ;55
          TAY                            ;57
          LDA     (PTR0),Y               ;62
          STA     TYPE,Y                 ;66

          CMP     #4                     ;68
          STA     WSYNC                  ;71
          BCS     EGGER                  ;2/3
EGGBCK    STA     SPEED,Y                ;18    WHEN AN EGG
          STA     ASPEED,Y               ;22
          TYA                            ;24
          AND     #$01                   ;26 CAN'T SHIFT BECAUSE WE NEED X
          TAX                            ;28
          BEQ     PUNTNEG                ;30/31
          LDA     SPEED,Y                ;34
          ORA     #$04                   ;36
          STA     SPEED,Y                ;40
PUNTNEG
          LDA     TYPE,Y                 ;44
          CMP     #$4                    ;46
          BCS     INCDEP                 ;48/49
          LDA     #VBRTHSND              ;50 QUEUE UP BIRTH SOUND
          CMP     SCNTRLI0,X             ;54
          BCC     INCDEP                 ;56/57
          STA     SCNTRLI0,X             ;60

INCDEP    INC     DEPNUM                 ;65
          LDA     DEPNUM                 ;68
          CMP     ENEMA                  ;71
          STA     WSYNC                  ;74
          BNE     NODEPL                 ;2/3
ENDDEP    LDA     #$FF                   ;4
          STA     DEPNUM                 ;7
NODEPL
          LDA     #0
          STA     PF1
          STA     PF2

          BIT     ATTRACT                ;FOR BEGINNING OF BLANKING

          STA     WSYNC                  ;10
;         LDA     #0
          STA     VSYNC                  ; Turn off vertical sync

BEGBLNK

                  ;WON'T HELP TO PUT THIS IN VSYNC SINCE WE ARE ONLY WORRIED
                  ;ABOUT TIME AFTER THE STORE TO THE TIMER
          LDA     #$2D                   ; (43 decimal) Count vertical blanking
          STA     TIM64T

****
;         JSR     FRZEBL                 ;COMMENT THIS OUT FOR NO FREEZE FRAMER
                                         ;OR TO BURN A CART

          BVC     NOTITLE
          JMP     GOBANKD

NOTITLE

********************************************************************************
*                                                                              *
*         RACK ADVANCE CONDITIONALS                                            *
*                                                                              *
********************************************************************************

CADVNTRY  LDA     ENEMA
          BEQ     DECTIMER               IF ENEMIES DON'T ADVANCE CLIFFS
JCAD      JMP     CADVEXIT


DECTIMER  DEC     TIMER                  IF TIMER NOT OUT DON'T ADVANCE
          BNE     JCAD                   THIS IS ONLY FOR QUICKY ENEMY DEPLOY

********************************************************************************
*                                                                              *
*         ADVANCE RACK NUMBER AND CLIFF CONFIGURATION                          *
*                                                                              *
********************************************************************************

          LDA     GAMETYPE
          CMP     #2
          BCS     REAGAN

          BIT     GLADRAG
          BVC     NOBONUS
          LDA     LIVES
          BMI     PLAY1
          LDA     #$00
          LDY     #$30
          TAX
          JSR     ADDSCORE

PLAY1     LDA     GAMETYPE
          LSR     A
          BCC     NOBONUS
          LDA     LIVES+1
          BMI     NOBONUS
          LDA     #$00
;         LDY     #$30                   ;Y SHOULD STILL BE 30
          LDX     #1
          JSR     ADDSCORE

NOBONUS
          LDY     RACKNUM
          INY
          CPY     #27
          BNE     STRCK
          LDY     #19
STRCK     STY     RACKNUM
          TYA
          AND     #3
          CMP     #2
          BNE     BUSH
          LDA     GLADRAG
          ORA     #$80
          BMI     NANCY
BUSH      CMP     #1
          BNE     CASPAR
          LDA     GLADRAG
          ORA     #$40
          BNE     NANCY

CASPAR    LDA     #0
NANCY     STA     GLADRAG
REAGAN
          LDY     CFIGINDX
          INY
          CPY     #15
          BNE     STCFIG
          LDY     #3
STCFIG    STY     CFIGINDX

********************************************************************************
*                                                                              *
*         HAVE PLAYERS FALL OFF DISOLVED CLIFFS                                *
*                                                                              *
********************************************************************************

GPSKP98A  LDX     #1                     SETUP PLAYER INDEX

GPSKP98B  LDA     STATES,X
          AND     #$60                   IF PLAYER FLYING
          BEQ     GPSKP98D               SKIP CLIFF EXISTENCE CHECK

          STX     TEMP0
          LDA     GENERALS,X
          AND     #$7                    GET CLIFF NUMER INTO X
          CMP     #1
          BNE     GPSKP98C

          CPY     #2
          BNE     GPSKP98D

          LDA     XPOS,X
          CMP     LEFTSM4
          BCC     FLYTRANS
          CMP     RIGHTSM1
          BCS     FLYTRANS

          LDA     #0
          STA     GENERALS,X
          BEQ     GPSKP98D

GPSKP98C  TAX
          LDA     CNUMASKS,X
          LDX     TEMP0
          AND     CLIFIGS,Y              IF CLIFF DOESN'T EXIST ANYMORE
          BNE     GPSKP98D               SKIP TO TRANS TO FLY SECTION


FLYTRANS  LDA     #1                     TRANSITION TO FLYING
          STA     GEN2,X
          LDA     STATES,X
          AND     #$8F
          STA     STATES,X
          LDA     #0
          STA     YVELINT,X
          STA     YVELFRAC,X
          STA     GENERALS,X

GPSKP98D  DEX                            IF NEED BE DO NEXT PLAYER
          BPL     GPSKP98B
          JSR     DEPENMYS               DEPLOY ENEMIES

          LDA     #0
          BIT     ENEMA
          BMI     STZTT
          LDX     #ITITI                 RESET TERRY TIMER...
          STX     TITIMNDX
          LDA     #11
STZTT     STA     TERYTIME

          LDA     ENEMA
          AND     #$7F
          STA     ENEMA

JMPVB     JMP     VBEND                  ;TO PREVENT SCREEN FLIPS

CADVEXIT
********************************************************************************
*                                                                              *
*         PLAYER 1 / ENEMY COLLISION
*                                                                              *
********************************************************************************

          LDX     #1
          LDA     STAT2+1                IF PLAYER 1 NOT PRESENT SKIP ENEMY
          CMP     #SHIELD
          BPL     ENDHITP1
          LDA     GAMETYPE
          LSR     A
          BCC     VBEND

          LDA     FRMCNT
          LSR     A
          BCC     ODD2

          LDY     #2                     ;X IS STILL ONE
          JSR     BONK
          LDX     #1
          LDY     #4
          JSR     BONK
          LDX     #1
          LDY     #6
          JSR     BONK
          JMP     ENDHITP1

ODD2                                     ;X IS STILL ONE
          LDY     #3
          JSR     BONK
          LDX     #1
          LDY     #5
          JSR     BONK
          LDX     #1
          LDY     #7
          JSR     BONK
ENDHITP1


VBEND
BLOAD
          JMP     GOBANKD


PMOSKP05  LDA     STATES,X
          AND     #$60
                                         ;IF NOT FLYING
          BNE     PMOSKP10               GOTO WALK SKID COMMON FRONT END START
          JMP     FLYENTRY
PMOSKP10  JMP     WSFENTRY
;===============================================================================

*         SUBROUTINE PMOTION
*
*         THIS SUBROUTINE DOES THE MOTION FOR A PLAYER
*
*         INPUTS  THE CONTROLS SHOULD BE IN THE ACC, BIT 7 SET/RESET BUTTON D/U
*                                        BITS 3210 INVERTED JOYSTICK INPUT
*                 AN INDEX FOR THE PLAYER SHOULD BE IN X
*
*         OUTPUTS ALL THE FIELDS OF A PLAYER'S DATA MIGHT BE CHANGED
*                 THE ACC WILL HAVE A SOUND CONTROL CODE

PMOTION   STX     TEMP0                  STORE PLAYER INDEX
          STA     TEMP1                  STORE CONTROLS

          LDA     STAT2,X
          CMP     #SHIELD
          BMI     PMOSKP05

          CMP     #PDEATH
          BNE     GBSENTRY

PDTHSK02  LDY     PDETHTIM,X
          DEY
          BMI     PDTHSK05
          STY     PDETHTIM,X
          BPL     PDTHSK15

PDTHSK10
          STY     PDTHSNUM,X
          LDY     #PDETHSTM
          STY     PDETHTIM,X
          BNE     PDTHSK15

PDTHSK05  LDY     PDTHSNUM,X
          INY
          CPY     #EXP2SNP1
          BNE     PDTHSK10


          LDA     #PGONE
          STA     STAT2,X
          LDA     #GONEITIM
          STA     PGONETIM,X

PGONE010
PDTHSK15  LDA     #NOTSOUND
          RTS

GBSENTRY  CMP     #PGONE
          BNE     BSENTRY

          LDA     LIVES,X
          BMI     PGONE010

          DEC     PGONETIM,X
          BNE     PGONE010

PGONE020  DEC     LIVES,X
          BMI     PGONE010
          LDA     C1XPOS,X               ALWAY DO BIRTH ON CLIFF ONE FOR NOW
          STA     XPOS,X
          LDA     TOPSM9
          STA     YPOSINT,X
          LDA     #ISTATB1
          STA     STATES,X
          LDA     #ISTA2B1
          STA     STAT2,X

          LDA     #$01                   PUT PLAYER ON CORRECT CLIFF
          STA     BIRTHAN,X
          CMP     CFIGINDX
          LDA     #0
          STA     EGGSCORE,X
          ROL     A
          STA     GENERALS,X

          LDA     #BRTHITIM
          STA     BIRTHTIM,X

          LDA     TERYCNT
          BEQ     NONEWTT
          LDY     TITIMNDX               SET UP NEW TERRY TIMER
          LDA     TITIMES,Y
          STA     TERYTIME

NONEWTT   LDA     #BIRTHSND
          RTS

BSENTRY   CMP     #SHIELD
          BEQ     SHLDNTRY

          DEC     BIRTHTIM,X
          BNE     PGONE010


BIRTH010  DEC     YPOSINT,X
          INC     BIRTHAN,X
          LDA     BIRTHAN,X
          CMP     #7
          BNE     BIRTH030

          LDA     #SHLDITIM
          STA     SHLDTIM,X
          LDA     #1
          STA     SHLDSEC,X
          LDA     #ISTA2SLD
          STA     STAT2,X
          LDA     #SHLDSND
          RTS

BIRTH030  LDA     #BRTHITIM
          STA     BIRTHTIM,X
PGONE011
          LDA     #NOTSOUND
          RTS

SHLDNTRY  LDA     TEMP1
          BEQ     SHLD010

SHLD005   LDA     #ISTA2WLK
          STA     STAT2,X
          LDA     #STPSHLDS
          RTS

SHLD010   DEC     SHLDTIM,X
          BNE     PGONE011

SHLD020   LDY     SHLDSEC,X
          INY
          CPY     #7
          BEQ     SHLD005

SHLD030   STY     SHLDSEC,X
          LDA     #SHLDITIM
          STA     SHLDTIM,X
WSFSKP18
          LDA     #NOTSOUND
          RTS

;==============================================================================

WSFENTRY  LDA     #NOTSOUND              STORE DEFAULT SOUND CONTROL CODE
          STA     TEMP4                  IN TEMP

          LDA     GENERALS,X             IF BUTTON HAS NOT BEEN UP YET
          BMI     WSFSKP05               GOTO BUTTON STILL DOWN CHECK

          LDY     TEMP1                  IF BUTTON IS UP
          BPL     WSFSKP10               GOTO STILL ON CLIFF CHECK
          LDA     #FLYFEFST              SETUP AND GOTO TRANS TO FLY
          BNE     WSFSKP15

WSFSKP05  LDY     TEMP1                  IF BUTTON STILL DOWN
          BMI     WSFSKP10               GOTO STILL ON CLIFF CHECK

          AND     #$7F                   CLEAR BUTTON DOWN BIT
          STA     GENERALS,X

WSFSKP10  LDA     GENERALS,X             CHECK IF STILL ON CLIFF
          AND     #$7                    GET CLIFF # INTO Y ALONE
          TAY
          STA     TEMP3                  STORE CLIFF # FOR W/S BACK END USE

          LDA     XPOS,X
          CMP     LEFTSM4,Y              IF LEFT OF CENTER SECTION OF CLIFF
          BCC     WSFSKP14               GOTO TRANS TO FLY
          CMP     RIGHTSM1,Y             IF NOT RIGHT OF CENTER SECTION OF CLIFF
          BCC     WSFSKP20               GOTO BRANCHES FOR WALK/SKID FRONT ENDS
WSFSKP14  LDA     #1

WSFSKP15  STA     GEN2,X                 TRANSITION TO FLY
          LDA     STATES,X
          STA     TEMP2
          AND     #$8F                   MAINTAIN FACING
                                         ;RESET FLY BITS, CLEAR WALK/SKID BITS
          STA     STATES,X

          LDA     #0
          STA     YVELINT,X
          STA     YVELFRAC,X
          STA     GENERALS,X

          LDA     TEMP2                  IF WERE SKIDDING RETURN WITH STOP
          AND     #$40                   SKID SOUND
          BNE     WSFSKP18
          LDA     #STPSKDSN
          RTS

WSFSKP20  LDA     STATES,X               BRANCH OUT TO INDIVIDUAL WALK AND SKID
          AND     #$40                   FRONT ENDS
          BNE     WFENTRY
          JMP     SFENTRY

;===============================================================================

WFENTRY   LDA     STAT2,X                 WALK FRONT END
          CMP     #5
          BPL     WFESKP05               GOTO LEFT SPEED AND STICK CHECK

          CMP     #3                     IF RIGHT SPEED < 3
          BMI     WBENTRY0               GOTO WALK BACK END

          LDA     TEMP1
          AND     #$04                   IF STICK LEFT
          BNE     WFESKP10               GOTO TRANSITION TO SKID
          BEQ     WBENTRY0               ELSE GOTO WALK BACK END

WFESKP05  CMP     #8                     LEFT SPEED AND STICK CHECK
          BMI     WBENTRY0               IF LEFT SPEED < 8 GOTO WALK BACK END

          LDA     TEMP1
          AND     #$08                   IF NOT STICK RIGHT
          BEQ     WBENTRY0               GOTO WALK BACK END

WFESKP10  LDA     STATES,X               TRANSITION TO SKID
          AND     #$8F                   CLEAR WALK AND SET SKID BIT
          ORA     #$20
          STA     STATES,X

          INC     YPOSINT,X
          INC     YPOSINT,X

          LDA     #MAXSDLAY
          STA     GEN2,X

          LDA     #SKDSOUND
          RTS

;===============================================================================
WBESKP03
          STY     GEN2,X
          JMP     WBESKP25               GOTO GET DELTA X SECTION


WBENTRY0  LDY     GEN2,X                  WALK BACK END
          DEY                            IF DELAY NOW ZERO
          BNE     WBESKP03               THEN GOTO SPEED CHANGE/DELAY RESET SPOT



          LDY     STAT2,X                SPEED CHANGE SECTION    GET SPED INTO Y

          LDA     TEMP1                  GET EAST/WEST BITS INTO ACC ALONE
          AND     #$0C
          BEQ     WBESKP25               IF NOT CHANGE GOTO GET DELTA X SPOT

          AND     #$08                   IF EAST NOT SET
          BNE     WBESKP10               GOTO RIGHT STICK SPEED CHANGE

                                        ;LEFT STICK SPEED CHANGE SECTION
                                         ;CLEAR OUT OLD SPEED
          LDA     SPEDCNGL,Y             HUAL IN NEW SPEED
          JMP     WBESKP15               GOTO FACING SETING SECTION

WBESKP10                                ;RIGHT STICK SPEED CHANGE SECTION
                                         ;CLEAR OUT OLD SPEED
          LDA     SPEDCNGR,Y             HUAL IN NEW SPEED

WBESKP15  STA     STAT2,X                STORE NEW STATES UNTIL CONVIENIENT
                                        ;SET FACING IN DIRECTION OF SPEED
          CMP     #5
          BPL     WBESKP20               IF LEFT SPEED GOTO SET LEFT FACING SPOT

          LDA     STATES,X               GET IN NEW STATES
          AND     #$7F                   CLEAR FACING BIT FOR FACING RIGHT
          BPL     WBESKP23               GOTO STORE TEMPS AND DELTA X

WBESKP20  LDA     STATES,X
          ORA     #$80                   SET FACING IN DIRECTION OF SPEED

WBESKP23  STA     STATES,X               STORE NEW STATES

          LDA     #MAXWDLAY
          STA     GEN2,X

WBESKP25  LDA     STAT2,X                GET DELTA X INTO Y
          ASL     A
          ASL     A
          ADC     TEMPM4FC
          TAY
          LDA     DELTAX,Y
          TAY

          LDA     STAT2,X
          BEQ     WBESKP28               IF NOT MOVING GOTO STAND SECTION
          CMP     #5
          BNE     WBESKP30               IF MOVING GOTO ANIMATION SECTION

WBESKP28  LDA     STATES,X
          AND     #$CF                   CLEAR OUT OLD ANIMATION # AND SELECT
          ORA     #$30                   3 WHICH IS USED FOR STANDING
          STA     STATES,X
JMP50     JMP     WSBSKP50               GOTO NO SOUND RETURN SECTION

WBESKP30  TYA                            IF MOTION THIS FRAME
;         BNE     WBESKP35               GOTO ANIMATION INCREMENT
          BEQ     JMP50                  ELSE GOTO NO SOUND RETURN

WBESKP35  LDA     STATES,X               GET AN # INTO ACC ALONE, BUT UNSHIFTED
          AND     #$30                   IF AN # IS ZERO
          BEQ     WBESKP55               GOTO START NEW CYCLE SECTION

          SEC                            SUBTRACT "1" FROM AN #
          SBC     #$10
          STA     TEMP2

          CMP     #$10                   IF NOT AT FOOT DOWN
          BNE     WBESKP50               GOTO STORE NEW AN # SECTION

          LDA     #WLKSOUND              QUE UP FOOT DOWN NOISE
          STA     TEMP4

WBESKP50  LDA     STATES,X
          AND     #$CF                   KILL OLD AN #
          ORA     TEMP2                  HUAL IN NEW ONE
          STA     STATES,X
          TYA
          JMP     WSBENTRY               GOTO COMMON WALK SKID BACK END

WBESKP55  LDA     #$30
          STA     TEMP2
          BNE     WBESKP50

;===============================================================================

SFENTRY   LDA     STAT2,X                SKID FRONT END
          BEQ     SFESKP10               IF SPEED RIGHT 0 GOTO WALK TRANS
          CMP     #5
          BEQ     SFESKP10               IF SPEED LEFT 0 GOTO WALK TRANS

          BMI     SFESKP05               IF LEFT GOTO LEFT STICK CHECK

          LDA     TEMP1
          AND     #$04                   IF STICK LEFT
          BEQ     SBENTRY0
          BNE     SFESKP10

SFESKP05
          LDA     TEMP1
          AND     #$08                   IF STICK RIGHT
          BEQ     SBENTRY0               ELSE GOTO SKID BACK END

SFESKP10  LDA     STATES,X               TRANSITION TO WALK
          AND     #$8F                   CLEAR OUT SKID INDICATIONS
          ORA     #$70                   HUAL IN WALK STUFF
          STA     STATES,X

          DEC     YPOSINT,X
          DEC     YPOSINT,X

          LDA     #MAXWDLAY
          STA     GEN2,X

          LDA     #STPSKDSN
          RTS

;===============================================================================

SBENTRY0                                ;GET CURRENT SPEED INTO Y
          LDY     GEN2,X                 GET AND DECREMENT DELAY
          DEY                            IF DELAY = 0
          BEQ     SBESKP05               THEN GOTO SPEED CHANGE/DELAY RESET SPOT

          STY     GEN2,X                 REBUILD GENERALS WITH NEW DELAY
          LDA     STAT2,X
          JMP     SBESKP26               GOTO GET DELTA X SECTION

SBESKP05  LDA     #MAXSDLAY              SPEED CHANGE SECTION
          STA     GEN2,X


          LDY     STAT2,X
          LDA     SPEEDEC,Y              HUAL IN SMALLER SPEED
          STA     STAT2,X

SBENTRY1                                 ;QUE UP SKID NOISE Y

SBESKP25  TYA                            ;SPEED IS STILL IN Y
SBESKP26  ASL     A
          ASL     A
          ADC     TEMPM4FC
          TAY
          LDA     DELTAX,Y

;===============================================================================
;WALK AND SKID COMMON BACK END DEALING WITH X MOTION AND WRAP AROUND

WSBENTRY                                 ; IF HORIZONTAL MOTION THIS FRAME
;         BNE     WSBSKP35               GOTO X CALC AND CHECK SECTION
          BEQ     WSBSKP50               ELSE SELECT NO SOUND AND RETURN

WSBSKP35  CLC
          ADC     XPOS,X                 CALCULATE NEW X POSSITION

          CMP     #LMOSTPXL              IF TO RIGHT OF LEFTMOST LEGAL PIXEL
          BPL     WSBSKP40               GOTO RIGHT EDGE CHECK SECTION


          LDA     #RMSTSPXL              SET TO RIGHT OF SCREEN
          BNE     WSBSKP41               GOTO CLIFF WRAP SECTION

WSBSKP40  CMP     #RMSTCPXL              IF IN CENTER OF SCREEN
          BMI     WSBSKP45               GOTO STORE NEW X SECTION

          LDA     #LMOSTPXL              SET TO LEFT OF SCREEN
WSBSKP41  STA     XPOS,X

WSBSKP42  LDY     TEMP3                  GET CLIFF NUMBER INTO Y
          LDA     GENERALS,X
          AND     #$F8                   KILL CLIFF #, BITS 210
          ORA     CLIFWRAP,Y             HUAL IN WRAPED AROUND CLIFF #
          STA     GENERALS,X
          JMP     WSBSKP50

WSBSKP45  STA     XPOS,X

WSBSKP50  LDA     TEMP4                  GET POSSIBLE SOUND
          RTS

;==============================================================================
                                         ; FLYING SECTION

FLYSK12B  LDA     STAT2,X                SETUP AND GOTO GET DELTA X SECTION
          JMP     FLYSKP08

FLYSK12C  AND     #$04                   GET WEST CONTROL BIT INTO Y ALONE
          TAY
          LDA     STATES,X               GET STATES AND CLEAR OLD FACING BIT
          AND     #$7F
          CPY     #0                     IF WEST IS SET
          BEQ     FLYSK12D               SET LEFT FACING BIT
          ORA     #$80
FLYSK12D  STA     STATES,X
          LDA     STAT2,X
          JMP     FLYSKP08

FLYENTRY
*         SUBPROCESS GET RAW Y
*
*         THIS SUBPROCESS LOOKS AT THE CONTROLS AND STATE FOR THE "PASSED"
*         PLAYER BIRD AND UPDATES ITS VERTICLE VELOCITY, POSSITION AND DELAY
*         EFFECTIVENESS FOR EFFECTIVE FLAPPING FRAMES.  THE ONLY BOUNDRY
*         CONDITION DEALT WITH IN THE SUBPROCESS IS TERMINAL VELOCITIES.
*
*         INPUTS  THE CONTROLS FOR THIS BIRD SHOULD BE IN THE ACC AND AN INDEX
*                 AS TO WHICH PLAYER IN X
*
*         OUTPUTS THE FOLLOWING FIELDS OF THE PLAYER BIRD ARE UPDATED:
*                 YPOSINT, GENERALS (YPOSFRAC, DELAY/EFFECT), YVELINT, YVELFRAC
*
*         SIDE EFFECTS    THE PROCESSOR STATUS IS ABOUT YPOSINT.
*                 THE ACC CONTAINS YPOSINT.
*                 RAM LOC TEMP2 CONTAINS DELAY/EFFECT
*                 Y IS TRASHED.
*
          LDA     TEMP1                  GET CONTROLS    IF BUTTON DOWN
          BMI     GETYSKP0               GOTO SECTION FOR BUTTON DOWN

                                         ;SECTION FOR BUTTON UP
          LDA     #FLYFEFST              RESET FLYING EFFECTIVENESS
          BNE     GETYSKP                GOTO VELOCITY CALC SECTION

                                         ;SECTION FOR EFFECTIVEFLAPPING
GETMGF    LDY     #2                     SELECT RESULTANT UPWARD ACCELERATION
          BNE     GETYSKP2               GOTO VELOCITY CALC SECTION

                                         ;SECTION FOR BUTTON DOWN
GETYSKP0  LDY     GEN2,X                  GET DELAY/EFFECT INTO Y ALONE
          DEY                            DECREMENT DELAY/EFFECT
          TYA                            IF DELAY/EFFECT = 0
          BNE     GETMGF                 GOTO NON-EFFECTIVE FLAPPING SPOT


                                         ;SECTION FOR NON-EFFECTIVE FLAPS
GETYSKP1  LDA     #1                     SET D/E TO ALLOW MORE NON-EFFECT
GETYSKP   LDY     #0                     SELECT GRAVITAITIONAL ACCELERATION
GETYSKP2  STA     GEN2,X                 TEMP STORE NEW DELAY EFFECT

                                         ;SECTION FOR VELOCITY CALC
          CLC                            CALC AND STORE YVELFRAC
          LDA     YVELFRAC,X
          ADC     ACCELS,Y
          STA     YVELFRAC,X
          INY                            ADJUST INDEX FOR ACCEL INT
          LDA     YVELINT,X              CALCULATE YVELINT
          ADC     ACCELS,Y
                                         ;GET INTEGER PART OF VELOCITY IN BOUNDS
          AND     #$0F                   VIA TABLE LOOKUP ON COMPUTED SPEED
          TAY
          LDA     TERMVELS,Y

                                         ;POSSITION CALC SECTION
GETYSKP4  STA     YVELINT,X              STORE INTEGER VELOCITY
          LDA     GENERALS,X             GET OLD YPOSFRAC INTO
          CLC
          ADC     YVELFRAC,X             CALC NEW YPOSFRAC
          STA     GENERALS,X

          LDA     YVELINT,X              CALC AND STORE YPOSINT
          ADC     YPOSINT,X
          STA     YPOSINT,X

          LDA     TEMP1
          AND     #$0C                    IF NO STICK
          BEQ     FLYSK12B                GOTO SETUP AND THEN GET DELTA X SPOT

          LDY     GEN2,X
          CPY     #FLYFEFCP               IF NOT FIRST EFFECTIVE FLAP FRAME
          BNE     FLYSK12C                GOTO FACING CHANGE ONLY

          LSR     A                       COMPUTE INDEX INTO NEW FLYING STATES
          LSR     A                       TABLE, BITS 4-1 X SPEED, BIT 0 WEST
          LSR     A
          LDA     STAT2,X
          ROL     A
          TAY

          ROR     A
          LDA     #0
          ROR     A
          STA     STATES,X

          LDA     NFSTAT2,Y
          STA     STAT2,X                 HUAL IN AND STORE NEW STATES

                                         ;GET NEW X SECTION
FLYSKP08                                 ;GET DELTA X
          ASL     A
          ASL     A
          ADC     TEMPM4FC
          TAY
          LDA     DELTAX,Y

          ADC     XPOS,X
                                         ;HORIZONTAL WRAP AROUND SECTION
          CMP     #LMOSTPXL              IF TO RIGHT OF LEFTMOST LEGAL X
          BPL     FLYSKP10               GOTO RIGHT EDGE CHECK SECTION

          LDA     #RMSTSPXL              SET TO RIGHT OF SCREEN GOTO TOP OF
          BNE     FLYSKP12               SCREEN REFLECT CHECK SECTION

FLYSKP10  CMP     #RMSTCPXL              IF TO LEFT OF RIGHTMOST LEGAL X
          BMI     FLYSKP12               GOTO SCREEN TOP CHECK SECTION

          LDA     #LMOSTPXL              SET TO LEFT EDGE

FLYSKP12  STA     TEMP2                  STORE NEW X
          STA     XPOS,X
                                         ;TOP OF SCREEN REFLECT CHECK SECTION
FLYSKP13  LDY     YVELINT,X              IF GOING DOWN
          BPL     FLYSKP14               GOTO CLIFF COLLISION CHECK SECTION
          LDY     YPOSINT,X
          BPL     FLYSKP14
          CPY     #TOPSCNUM              IF NOT PAST TOP OF SCREEN
          BMI     FLYSKP14               GOTO CLIFF COLLISION CHECK SECTION

                                         ;TOP OF SCREEN REFLECT SECTION
          LDA     #0
          SEC
          SBC     YPOSINT,X
          STA     YPOSINT,X              IGNORE Y FRAC IT IS INSIGNIFICANT

          LDA     YVELINT,X              GET REFLECTED AND DAMPED Y VELOCITY
          AND     #$0F
          TAY
          LDA     CLFBVELS,Y             FROM TABLE
          STA     YVELINT,X

          LDY     TEMP0                  RESTORE PLAYER INDEX INTO Y
          JMP     FLYSKP22               GOTO FLAP SOUND CHECK

FLYS160   JMP     FLYSKP21               GOTO LAVA SECTION
FLYS161   JMP     FLYSKP20               GOTO RIGHT EDGE CHECK SECTION

WCLFSK10  LDA     CFIGINDX
          LDY     TEMP0
          CMP     #2
          BPL     FLYSKP16
          LDX     #1
          BNE     FLYSKP16
                                         ;CLIFF COLLISION CHECK SECTION
FLYSKP14  LDA     YPOSINT,X              GET STAMP'S Y INTO ACC FOR WHATCLIF

*         SUBPROCESS WHATCLIF
*
*         THIS SUBPROCESS DETERMINES WHAT CLIFF, IF ANY, THE "PASSED" STAMP
*         MIGHT BE IN.
*
*         INPUTS
*                 THE Y OF THE STAMP SHOULD BE IN THE ACC
*                 THE X "  "   "     "      "  "  LOCATION     TEMP2
*
*         OUTPUTS
*                 THE CLIFF # IS IN X; IF NO CLIFF, X IS GARBAGE

WHATCLIF  LSR     A                      2 DIVIDE STAMP'S Y BY 4
          LSR     A                      2
          TAY                            2
          LDX     CCHKNUMS,Y             4 GET LEFT CLIFF NUMBER INTO Y
          BEQ     WCLFSK10               2 IF ON BOTTOM OF SCREEN GOTO ITS SPOT
          LDA     TEMP2                  3
          CMP     #80                    2 IF ON LEFT SIDE OF SCREEN
          BMI     WCLFSKP7               2 DON'T WRAP TO GET RIGHT CLIFF NUMBER
          LDA     WCLFWRAP,X             4 GET RIGHT WRAPED CLIFF NUMBER
          TAX                            2

WCLFSKP7  LDY     CFIGINDX               3 HAUL IN CONFIG INDEX
          LDA     CLIFIGS,Y              4 GET CLIFF CONFIG INTO ACC
          LDY     TEMP0                  3 RESTORE PLAYER INDEX INTO Y
          AND     CNUMASKS,X             4 MASK FOR CURRENT CLIFF
          BEQ     FLYS160                2 IF CLIFF CHECK, ELSE GO FLAP SND AREA

                                         ;POSSIBLE CLIFF # IS IN X
FLYSKP16  LDA     TEMP2                  GET NEW X INTO ACC
                                         ;MID CLIFF CHECK SECTION
          CMP     RIGHTSM1,X             IF IN THE CENTER SECTION OF CLIFF
          BCS     FLYS161                THEN DROP THRU TO CENTER CLIFF SECTION
          CMP     LEFTSM4,X              ELSE GOTO PROPER EDGE CHECK SECTION
          BCC     FLYSKP19

FLYSK16A  LDA     YVELINT,Y
          BMI     FLYSKP18               IF VELOCITY NEG GOTO MIDCLIFF GOING UP


                                         ;GOING DOWN MIDCLIFF HIT AND WALK CHECK
FLYS16A2  LDA     YPOSINT,Y              CALC DISTANE A WALK STAMP INTO CLIFF
          SEC
          SBC     TOPSM15,X
          BMI     FLYS162                IF NOT IN CLIFF GOTO FLAP SOUND CHECK

                                         ;TRANSITION TO WALK
          LDA     TOPSM15,X
          STA     YPOSINT,Y              PUT BIRD ON CLIFF

          TXA                            BUILD GENERALS BASED ON CLIFF NUMBER
          ORA     #$80
          STA     GENERALS,Y

          LDA     #MAXWDLAY
          STA     GEN2,Y

          LDA     STATES,Y
          ASL     A                      BUILD INDEX INTO NEW WALK STATES FROM
          LDA     STAT2,Y                HORIZONTAL SPEED AND FACING
          ROL     A
          TAX
          LDA     IWLKSTAT,X             HUAL IN NEW INITIAL WALK STATE
          STA     STATES,Y

          LDA     #NOTSOUND              NO SOUND RETURN
          RTS                            RETURN FROM PMOTION SUBROUTINE

                                         ;MIDCLIFF GOING UP SECTION
FLYSKP18  LDA     BOTSP1,X               CALCULATE DISTANCE INTO CLIFF
          SEC
          SBC     YPOSINT,Y
          BMI     FLYS162                IF NOT INTO CLIFF THEN GOTO
          BEQ     FLYS162                FLAP SOUND SECTION
          CMP     #5
          BPL     FLYS162

                                         ;HIT MIDCLIFF GOING UP
          CLC                            CALCULATE BOUNCED Y
          ADC     YPOSINT,Y
          STA     YPOSINT,Y

          LDA     YVELINT,Y              GET REFLECTED AND DAMPED Y VELOCITY
          AND     #$0F
          TAX
          LDA     CLFBVELS,X             FROM TABLE
          STA     YVELINT,Y

          LDA     #BNCSOUND              QUE UP BOUND SOUND
          RTS                            RETURN FROM PMOTION SUBROUTINE

FLYS162   JMP     FLYSKP22               GOTO FLAP SOUND SECTION

FLYSKP19  CMP     LEFTSM7,X              IF LEFT OF POSSIBLE CLIFF
          BCC     FLYSKP21               THEN GOTO LAVA SECTION

                                         ;LEFT PIXELS VERT ZONE CHECK
          LDA     YPOSINT,Y
          CMP     TOPSM11,X              IF STAMP ABOVE CLIFF
          BMI     FLYSKP22               THEN GOTO FLAP SOUND SECTION

          CMP     BOTSP1,X               IF STAMP BELOW CLIFF
          BPL     FLYSKP22               THEN GOTO FLAP SOUND SECTION

                                         ;HAVE HIT LEFT EDGE OF CLIFF #X BOUNCE
          LDA     LEFTSM7,X              MOVE STAMP JUST LEFT OF CLIFF
          SEC
          SBC     #1
          STA     XPOS,Y

          LDX     STAT2,Y                GET H SPEED INTO X ALONE
          LDA     SPCNGIFR,X             HUAL IN POSSIBLE CHANGED SPEED
          STA     STAT2,Y

          LDA     #BNCSOUND              QUE UP BOUNCE SOUND
          RTS                            RETURN FROM PMOTION SUBROUTINE

                                         ;CHECK FOR RIGHT EDGE HIT SECTION
FLYSKP20  CMP     RIGHTSP1,X             IF RIGHT OF CLIFF
          BCS     FLYSKP21               THEN GOTO LAVA

          LDA     YPOSINT,Y              GET NEW Y
          CMP     TOPSM11,X              IF ABOVE CLIFF
          BMI     FLYSKP22               THEN GOTO FLAP SOUND SECTION

          CMP     BOTSP1,X               IF BELOW CLIFF
          BPL     FLYSKP22               THEN GOTO FLAP SOUND SECTION

                                         ;HIT RIGHT EDGE
          LDA     RIGHTSP1,X             PUT STAMP JUST RIGHT OF CLIFF
          STA     XPOS,Y

          LDX     STAT2,Y                GET OLD H SPEED INTO X ALONE
          LDA     SPCNGIFL,X             HUAL IN POSSIBLE CHANGE SPEED
          STA     STAT2,Y


          LDA     #BNCSOUND              QUE UP BOUNCE NOISE
          RTS                            RETURN FROM PMOTION SUBROUTINE

FLYSKP21  LDA     YPOSINT,Y              LAVA CHECK
          BPL     FLYSKP22
          CMP     #LAVAM11
          BMI     FLYSKP22

          LDA     #PDEATH
          STA     STAT2,Y
          STY     TEMP2
          LDX     TEMP2
          LDA     #$50
          LDY     #0
          JSR     ADDSCORE
          LDY     TEMP2



          LDA     #EXP0SNUM
          STA     PDTHSNUM,Y
          LDA     #PDETHSTM
          STA     PDETHTIM,Y
          LDA     #XPLSOUND              QUE UP EXPLOSION NOISE
          RTS                            RETURN FROM PMOTION SUBROUTINE

                                         ;SOUND SECTION FOR POSSIBLE WING NOISE
FLYSKP22  LDA     GEN2,Y
          CMP     #FLYFEFCP              IF FIRST EFFECTIVE FLAP FRAME
          BNE     FLYSKP25               THEN
          LDA     #FLPSOUND              QUE UP FLAP NOISE
          RTS                            RETURN FROM PMOTION SUBROUTINE

FLYSKP25  LDA     #NOTSOUND              NO SOUND
          RTS                            RETURN FROM PMOTION SUBROUTINE
********************************************************************************

ADDSCORE  BIT     ATTRACT                IF AUTOPLAY FORGET SCORING
          BMI     ADSCEXIT

          SED
          CLC
          ADC     LOWSCORE,X
          STA     LOWSCORE,X

          TYA
          ADC     MIDSCORE,X
          STA     MIDSCORE,X

          BCC     CLEARD
          LDA     HISCORE,X
          LSR     A
          BCC     NOINCLS
          INC     LIVES,X
          LDA     #EXTRAMAN
          STA     SCNTRLI0,X
NOINCLS   SEC

          LDA     HISCORE,X
          ADC     #0
          STA     HISCORE,X
CLEARD    CLD

ADSCEXIT  RTS

********************************************************************************

DEPENMYS
          LDA     GAMETYPE
          CMP     #2
          BCC     NOBONZ
          LDA     #0
          STA     RACKNUM
          LDA     #1
          BNE     STAENM

NOBONZ
          LDX     RACKNUM
          LDA     ENEMATBL,X

STAENM
          STA     ENEMA

          LDA     #$D                    ;FOR NOW LEAVE X AND Y ALONE
          STA     YPOSINT+2
          STA     YPOSINT+3
          LDA     #UPPER+10
          STA     YPOSINT+4
          STA     YPOSINT+5
          LDA     #LOWER+10
          STA     YPOSINT+6
          STA     YPOSINT+7

          LDA     #9
          LDX     #$72
          STA     XPOS+2
          STX     XPOS+3
          STA     XPOS+4
          STX     XPOS+5
          STA     XPOS+6
          STX     XPOS+7

          LDA     #0
          LDX     #5
ZERTPLP   STA     TYPE,X                 ;ZERO OUT ALL TYPES FIRST
          DEX
          BPL     ZERTPLP

          STA     EGGSCORE
          STA     EGGSCORE+1
          STA     DEPNUM
          STX     TIMER
          STA     TERYCNT
BGEND     RTS

********************************************************************************

;ENEMY DRIVER
; TYPE    BITS        10              ENEMY TYPE--0=NOTHING,1=RED,2=GREY.3=BLUE
;         BITS      32                00=REGULAR,01=EGG,10=EXPLOSION,11=TERRY
;         BIT      4                  ANIMATION NUMBER--0=WINGUP
;         BITS   56                   UNUSED  OR FLAG TO DEPLOY THIS AS A TERRY
;         BIT   7                     DIRECTION 1=LEFT
;SPEED    BITS       210                  XVELOCITY CODE
;         BITS    543                     YVELOCITY CODE
;         BITS  76                        UP.DOWN ZONE CROSSING FLAGS
BADGUY    ;SOME LOGIC SHOULD GO HERE TO DO DIFFERENT TYPES OF ENEMIES/EGG

          LDA     TYPE,X
          AND     #$0F
          BEQ     BGEND
          AND     #$C
          CMP     #$C
          BNE     BCHECK
          JMP     PTERRY
;YVELOCITY
BCHECK    LDA     TYPE,X
          AND     #7
          STA     ZONECNT
          LDA     YPOSINT+2,X
          CMP     #UPPER
          LDY     #2
          BCC     BOUNDS
          CMP     #LOWER
          DEY
          BCC     BOUNDS
          DEY
BOUNDS
          SEC
          SBC     UB,Y                   ;UPPER BOUNDS TABLE
          CMP     #2
          BCC     UNTEN                  ;BOUNCE DOWN
          LDA     LB,Y
          SBC     YPOSINT+2,X

          CMP     #2
          BCS     NORM
OBEN
          LDA     SPEED,X
          AND     #$40
          BNE     NORM                   ;ZONE CROSSING FLAG SET, IGNORE BOUND

          LDY     ZONECNT
          LDA     UPSPEED,Y
          STA     ASPEED,X
          DEC     YPOSINT+2,X
          BNE     NORM                   ;JMP
UNTEN     LDA     SPEED,X                ;BOUNCE DOWN
          BMI     NORM                   ;ZONE CROSSING UP--DON'T BOUNCE DOWN

          LDY     ZONECNT
          LDA     DWNSPD,Y
          STA     ASPEED,X
          INC     YPOSINT+2,X

NORM      LDA     FRMCNT
          AND     #$E
          ASL     A
          ASL     A
          STA     TEMP0
          LDA     ASPEED,X
          ORA     TEMP0
          TAY
          LDA     YSPEED0,Y              ;YSPEED0 IS ADD FACTOR FOR FRAME ZERO
          CLC
          ADC     YPOSINT+2,X
          STA     YPOSINT+2,X
ENDVERT
          LDA     #8                     ;BEFORE BEING USED
          AND     FRMCNT
          BNE     XDRIVE
          LDA     TYPE,X
          EOR     #$10
          STA     TYPE,X


XDRIVE    LDA     FRMCNT
          AND     #$0E
          ASL     A
          ASL     A
          STA     TEMP0
          LDA     SPEED,X
          AND     #7
          STA     TEMP1
          ORA     TEMP0
          TAY
          LDA     TEMP1
          CMP     #4
          LDA     TYPE,X
          BCS     SEDIRR
          AND     #$7F
          BPL     DOPOS
SEDIRR    ORA     #$80
DOPOS     STA     TYPE,X
          LDA     XSPEED,Y
          CLC
          ADC     XPOS+2,X
          CMP     #RMSTCPXL+4
          BCS     WRAPLT
          CMP     #RMSTCPXL
          BCS     WRAPRT
          CMP     #LMOSTPXL
          BCS     NOWRAP
WRAPLT    LDA     #RMSTSPXL
          BNE     NOWRAP
WRAPRT    LDA     #LMOSTPXL              ;WRAP IT AROUND
NOWRAP    STA     XPOS+2,X

          LDA     ZONECNT
          AND     #4
          BNE     JNSEEK
          LDY     ZONECNT
          LDA     FRMCNT
          AND     SKIPMSK,Y
          BEQ     ATTACK
JNSEEK    JMP     NOSEEK


;HERO SEEK LOGIC
;TEMP2 CONTAINS THE ZONE NUMBER OF HERO0, TEMP3-HERO1
ATTACK    LDA     YPOSINT+2,X
          LDY     #2
          CMP     #UPPER
          BCC     GOON
          CMP     #LOWER
          DEY
          BCC     GOON
          DEY
GOON
;         STY     TEMP1                  ;NOT NECESSARY SINCE NEVER USED
          CPY     TEMP2
          BEQ     CKH1                   ;CHECK HERO1 ONLY
          CPY     TEMP3
          BNE     NOSEEK
          LDY     #1
          BNE     GOFORIT                ;DOHERO1
CKH1      CPY     TEMP3
          BNE     DOHERO0

;DETERMINE WHICH IS CLOSER
DOBOTH    LDY     #1                     ;PRELOAD FOR PLAYER 1
          LDA     YPOSINT+2,X
          SEC
          SBC     YPOSINT
          BPL     XSTDF1
          EOR     #$FF
XSTDF1    STA     TEMP0
          LDA     YPOSINT+2,X
          SEC
          SBC     YPOSINT+1
          BPL     XSTDF2
          EOR     #$FF
XSTDF2    CMP     TEMP0
          BCS     GOFORIT                ;HERO1 CLOSER VERTICALLY

DOHERO0   LDY     #0

GOFORIT
          LDA     XPOS,Y
          STA     TEMP3
          LDA     YPOSINT,Y
          SEC
          SBC     #5
          STA     TEMP2

          LDY     ZONECNT
          LDA     SKIPDIR,Y
          AND     FRMCNT
          BNE     VSEEK

          LDY     #$80                   ;PRELOAD LEFT
          LDA     XPOS+2,X
          CMP     TEMP3                  ;TEMP3 IS XPOS
          LDA     #4
          STA     TEMP4
          BCS     STXDIR                 ;GO LEFT
          LDY     #0
          STY     TEMP4
STXDIR    LDA     TYPE,X
          AND     #$7F
          STA     TEMP0
          LDA     SPEED,X
          AND     #$FB
          ORA     TEMP4
          STA     SPEED,X
          TYA
          ORA     TEMP0
          STA     TYPE,X
VSEEK
          LDA     YPOSINT+2,X
          CMP     TEMP2                  ;TEMP2 IS YPOSINT
          LDY     ZONECNT
          BCS     GOUP
          LDA     DWNSPD,Y
          BCC     STORMY
GOUP
          LDA     UPSPEED,Y
STORMY    STA     ASPEED,X

NOSEEK

          LDA     ZONECNT
          AND     #4
          BEQ     CLIFF

          LDA     FRMCNT
          AND     #$E
          BNE     CLIFF
          LDA     EGGO,X
          CMP     #4
          BNE     DECEGG

          LDA     #EGGHTCH
          CMP     SCNTRLI0
          BCC     DECEGG
          STA     SCNTRLI0

DECEGG    DEC     EGGO,X
          BNE     CLIFF
          LDA     GAMETYPE
          CMP     #2
          LDA     ZONECNT
          AND     #3
          BCS     SKIPINC
          CMP     #3
          BCS     SKIPINC
          ADC     #1
SKIPINC   STA     TEMP1
          LDA     TYPE,X
          AND     #$F0                   ;ENEMY TYPE
          ORA     TEMP1
          STA     TYPE,X
          AND     #$F
          STA     SPEED,X
CLIFF
          LDA     XPOS+2,X
          STA     TEMP1
          STX     TEMP0


          LDA     YPOSINT+2,X
          LSR     A
          LSR     A
          TAY
          LDX     CCHKNUMS,Y
          BEQ     CLF10
          LDA     TEMP1
          CMP     #80
          BMI     CLF7
          LDA     WCLFWRAP,X
          TAX
CLF7      LDY     CFIGINDX
          LDA     CLIFIGS,Y
          LDY     TEMP0
          AND     CNUMASKS,X
          BEQ     FLY162

FLY16     LDA     TEMP1
          CMP     RIGHTSM1,X
          BCC     MORECOMP
          JMP     FLY20
MORECOMP  CMP     LEFTSM4,X
          BCC     FLY19

          LDA     ASPEED,Y
          AND     #$4
          BNE     FLY18


          LDA     YPOSINT+2,Y
          CMP     #4
          BCC     FLY162
          SBC     #4                     ;CARRY IS SET
          SBC     TOPSM15,X
          BMI     FLY162

          LDA     #4
          STA     ASPEED,Y
          LDX     TEMP0
          DEC     YPOSINT+2,X            ;QUICKER IN X
          RTS

FLY18
          LDA     BOTSP1,X
          SBC     YPOSINT+2,Y            ;CARRY IS SET
          BMI     FLY162
          BEQ     FLY162
          CMP     #5
          BPL     FLY162

          CLC
          ADC     YPOSINT+2,Y
          STA     YPOSINT+2,Y

FLY162    RTS

CLF10
          LDA     CFIGINDX
          LDY     TEMP0
          CMP     #2
          BPL     FLY16
          LDX     #1
          BNE     FLY16

FLY19     CMP     LEFTSM7,X
          BCC     FLY22

          LDA     YPOSINT+2,Y
          CMP     TOPSM11,X
          BMI     FLY22

          LDA     LEFTSM7,X
          SEC
          SBC     #1
          STA     XPOS+2,Y

UPY
          LDA     TYPE,Y
          AND     #$0C
          CMP     #4
          BEQ     EGGDROP
          LDA     SPEED,Y
          ASL     A
          ASL     A
          LDA     ASPEED,Y
          ORA     #$01
          BCS     COMUPPY
          ORA     #$4
COMUPPY   STA     ASPEED,Y
FLY22     RTS

FLY20
          CMP     RIGHTSP1,X
          BCS     FLY22

          LDA     YPOSINT+2,Y
          CMP     TOPSM11,X
          BMI     FLY22

          CMP     BOTSP1,X
          BPL     FLY22

          LDA     RIGHTSP1,X
          STA     XPOS+2,Y
          BNE     UPY                    ;SHOULD NOT BE ZERO

EGGDROP   LDA     SPEED,Y
          EOR     #$4
          STA     SPEED,Y
          RTS

;NOTE THERE IS NO MORE CHECK FOR EXPLOSION IN LAVA SINCE THE ENEMIES SHOULD
;NEVER BE ABLE TO GET THERE



PTERRY
          LDY     #1
SETBTLP   LDA     YPOSINT+2,X
          SEC
          SBC     YPOSINT,Y
          CMP     #2
          BCC     SETBIT
          CMP     #-2
          BCS     SETBIT
          DEY
          BPL     SETBTLP
          BMI     NOSET

SETBIT
          LDA     SPEED,X
          ORA     #2
          STA     SPEED,X
NOSET
          LDY     XPOS+2,X               MOVE TERRY
          LDA     SPEED,X
          AND     #6
          CMP     #4
          BCC     PTERY010               +/- ONE PIXEL BASED ON SPEED DIRECTION
          BEQ     ONLY2D
          DEY
ONLY2D    DEY
          DEY
          BMI     PTERY040
          BPL     PTERY050
PTERY010  CMP     #2
          BCC     ONLY2I
          INY
ONLY2I    INY
          INY
          BPL     PTERY050

PTERY040  DEC     ENEMA
          DEC     TERYCNT
          LDA     ENEMA                  HAVE WRAP AROUND IF ONLY TERRIES OUT
          CMP     TERYCNT                HAVE THIS TERRY VANISH, ELSE DO WRAP
          BNE     PTERY055


          LDA     #0
          STA     TYPE,X                 XPOS AND YPOS ?????????????
          RTS

PTERY050  STY     XPOS+2,X               STORE NEW X POSSITION AND SET WING
          LDA     FRMCNT                 POSSITION
          AND     #$10
          STA     TEMP0
          LDA     TYPE,X
          AND     #$8F
          ORA     TEMP0
          STA     TYPE,X
          RTS

PTERY055
          LDA     #TERYFLAG
          STA     TYPE,X
          RTS



SKIPMSK   DB      0,$FE,$1E,$6
SKIPDIR   DB      0,$FE,$7E,$3E
UPSPEED   DB      $04,$05,$06,$07,$04,$04,$04,$04
DWNSPD    DB      0,1,$02,$03,0,0,0,0
XSPEED    DB      01,01,01,02,-1,-1,-1,-2
XSPEED1   DB      01,01,02,02,-1,-1,-2,-2
XSPEED2   DB      01,02,01,02,-1,-2,-1,-2
XSPEED3   DB      01,01,01,02,-1,-1,-1,-2
XSPEED4   DB      01,01,02,02,-1,-1,-2,-2
XSPEED5   DB      01,01,01,02,-1,-1,-1,-2
XSPEED6   DB      01,02,01,02,-1,-2,-1,-2
XSPEED7   DB      01,01,02,02,-1,-1,-2,-2

YSPEED0   DB      01,01,01,01,-1,-1,-1,-1        SPEED0   POSITIVE-DOWN
SPEED1    DB      00,00,00,01,00,00,00,-1
SPEED2    DB      00,01,01,01,00,-1,-1,-1
SPEED3    DB      00,00,01,01,00,00,-1,-1
SPEED4    DB      01,01,00,01,-1,-1,00,-1        SPEED4   NEGATIVE-UP
SPEED5    DB      00,00,01,01,00,00,-1,-1
SPEED6    DB      00,01,01,01,00,-1,-1,-1
SPEED7    DB      00,00,00,01,00,00,00,-1

UB        DB      LOWER+4,UPPER+4,0
LB        DB      LAVAM11-1,LOWER-21,UPPER-21
REVZONE   DB      2,1,0


********************************************************************************


EXPLH     LDA     #EXP0SNUM              START PLAYER X EXLODING
          STA     PDTHSNUM,X
          LDA     #PDETHSTM
          STA     PDETHTIM,X
          LDA     #PDEATH
          STA     STAT2,X

          STY     ZONECNT                ;ZONECNT IS USED AS A TEMP HERE
          LDA     #$50
          LDY     #0

          BIT     ATTRACT                IF AUTOPLAY FORGET SCORING
          BMI     KGOEXIT

          SED
          CLC
          ADC     LOWSCORE,X
          STA     LOWSCORE,X

          TYA
          ADC     MIDSCORE,X
          STA     MIDSCORE,X

          BCC     CLRD
          LDA     HISCORE,X
          LSR     A
          BCC     ANOINK
          INC     LIVES,X
          LDA     #EXTRAMAN
          STA     SCNTRLI0,X
ANOINK    SEC

          LDA     HISCORE,X
          ADC     #0
          STA     HISCORE,X
CLRD      CLD

KGOEXIT   LDY     ZONECNT
          JMP     EXPL020

EXPLE     LDA     TYPE-2,X               START ENEMY EXPLODING
          ORA     #4
          STA     TYPE-2,X
          LDA     #$20
          STA     EGGO-2,X
          LDA     #0
          STA     SPEED-2,X
          LDY     TEMP2
          LDA     XPOS,Y
          SEC
          LDY     XPOS,X
          SBC     XPOS,X
          BPL     DECXP
          INY
          INY
          BNE     STXP
DECXP     DEY
          DEY
          LDA     #4
          STA     SPEED-2,X
STXP      TYA
          AND     #$7F
          STA     XPOS,X

EXPL020   TXA
          AND     #$1
          TAX
          LDA     #XPLSOUND
          CMP     SCNTRLI0,X
          BCC     RETEXPL
          STA     SCNTRLI0,X
RETEXPL   RTS

********************************************************************************

********************************************************************************

TCOLIDE   SEC
          LDA     YPOSINT,X
          SBC     YPOSINT,Y
          CMP     #9
          BCC     TCOLI030
          CMP     #-9
          BCC     TCOLI010
TCOLI030  STA     TEMP0
          SEC                            TERRY COLLISION DETECTOR...
          LDA     XPOS,X
          SBC     XPOS,Y

          CMP     #16                    TERY LEFT OF PLAYER
          BCC     TCOLI020               HORIZONTAL INTERSECT GOTO VERT CHECK

          CMP     #-7                    PLAYER LEFT OF TERY
          BCS     TCOLI020
TCOLI010  RTS

TCOLI020  STA     TEMP1                  STORE FOR LATTER FACING CHECK
          LDA     TEMP0
          CMP     #2
          BCC     TCOLI070               GOTO CHECK FOR POSSIBLE PLAYER WIN
          CMP     #-1
          BCS     TCOLI070

          CMP     #9
          BCC     TCOLI050               GOTO KILL PLAYER

          CMP     #-9
          BCC     TCOLI010
TCOLI050  JMP     EXPLH                  KILL THIS PLAYER QUICKLY!

TCOLI070  LDA     TEMP1                  PLAY MAY KILL TERRY IF FACING CORRECT
          BMI     TCOLI090

          LDA     STATES,X
          BMI     TCOLI100               GOTO KILL TERRY
TCOLI080  JMP     EXPLH                  ELSE KILL PLAYER FAST

TCOLI090  LDA     STATES,X
          BMI     TCOLI080               KILL PLAYER

TCOLI100  LDA     #TIESOUND              KILL THIS TERRY !!
          CMP     SCNTRLI0,X
          BCC     NOEXPL
          STA     SCNTRLI0,X

NOEXPL    DEC     TERYCNT
          DEC     ENEMA
          LDA     #0
          STA     TYPE-2,Y
          LDY     #$10
          JMP     ADDSCORE

BONK

          LDA     TYPE-2,Y
          AND     #$F
          CMP     #$C                    IF TERRY GOTO TERRY COLLISION CHECKER
          BEQ     TCOLIDE

          AND     #7
          BEQ     PUNT
          AND     #4
          BEQ     NOPUNT
          JMP     OMELETTE

NOPUNT
          STX     TEMP2
          STY     TEMP3
          LDA     YPOSINT,X
          SEC
          SBC     YPOSINT,Y
          STA     PTR4H
          CMP     #11
          BCC     XCHECK
          CMP     #-10
          BCC     PUNT

XCHECK    LDA     XPOS,X
          SEC
          SBC     XPOS,Y
          CMP     #8
          BCC     VCHECK
          CMP     #-8
          BCS     VCHECK
          CMP     #0
          BPL     C113120
          CMP     #-126
          BCC     PUNT
          CMP     #-124
          BCS     PUNT
          BCC     VCHECK
C113120   CMP     #124
          BCC     PUNT
          CMP     #126
          BCS     PUNT
VCHECK
          LDA     PTR4H
          BNE     NOBOINK

          JMP     BOINK                  ;TIE

PUNT      RTS

NOBOINK
          BMI     XWIN

YWIN      JSR     EXPLH                  KILL PLAYER 0

          CPY     #1
          BEQ     CONFRONT

          LDA     GAMETYPE
          LSR     A
          BCS     NOSURV
          LDA     GLADRAG                ;CLEAR FLAG FOR SURVIVAL WAVE
          AND     #$BF
          STA     GLADRAG
NOSURV    RTS

CONFRONT  LDX     #1

          LDA     YVELINT+1
          BMI     NOBNC1
          LDA     #$FF
          STA     YVELINT+1

NOBNC1    BIT     GLADRAG
          BPL     NOBONE
          AND     #$7F
          STA     GLADRAG
          LDY     #$50
          LDA     #0
          JMP     ADDSCORE
NOBONE
          LDA     GLADRAG                ;CLEAR FLAG FOR TEAM WAVE
          AND     #$BF
          STA     GLADRAG
          LDY     #$20
          LDA     #0
          JMP     ADDSCORE
;         RTS


XWIN      LDA     YVELINT,X
          BMI     NOBNC2
          LDA     #$FF
          STA     YVELINT,X

NOBNC2    CPY     #1                     IF PLAYER 0 KILLED PLAYER 1 AWARD 2000
          BNE     XWIN010
;         LDX     TEMP2
          LDA     GLADRAG
          BPL     BONO
          AND     #$7F
          STA     GLADRAG
          LDA     #0
          LDY     #$50
          JSR     ADDSCORE
          LDX     TEMP3
          JMP     EXPLH

BONO      LDA     GLADRAG                ;CLEAR FLAG FOR TEAM WAVE
          AND     #$BF
          STA     GLADRAG
          LDA     #0
          LDY     #$20
          JSR     ADDSCORE
          LDX     TEMP3
          JMP     EXPLH


XWIN010   LDA     TYPE-2,Y               AWARD ENEMY VALUE TO WHATEVER PLAYER
          AND     #3                     KILLED IT
          TAX
          LDA     ENSCRLOW,X
          LDY     ENSCRMID,X

          LDX     TEMP2
          JSR     ADDSCORE

          LDX     TEMP3
          JMP     EXPLE
;         RTS

OMELETTE
          STX     TEMP2
          STY     TEMP3
          SEC
          LDA     YPOSINT,X
          SBC     YPOSINT,Y
POSLIM    CMP     #2
          BCC     EXCHEK
NEGLIM    CMP     #-9
          BCC     MOO

EXCHEK    LDA     XPOS,X
          SEC
          SBC     XPOS,Y
          CMP     #6
          BCC     SKEGGS
          CMP     #-6
          BCC     MOO
SKEGGS
          LDA     #0
          STA     TYPE-2,Y
          LDX     TEMP2
          LDA     #EATEGG
          CMP     SCNTRLI0,X
          BCC     DECENMA
          STA     SCNTRLI0,X
DECENMA   DEC     ENEMA
          LDA     DEPNUM
          BMI     NOFUN
          DEC     DEPNUM
NOFUN
          LDY     EGGSCORE,X
          LDA     EGMID,Y
          LDX     EGLO,Y
          TAY
          TXA
          LDX     TEMP2
          JSR     ADDSCORE
;         LDX     TEMP2                  ;IS THIS NEEDED???
          LDY     EGGSCORE,X
          INY
          CPY     #4
          BCS     MOO
          STY     EGGSCORE,X
MOO       RTS


EGLO      DB      $50,$00,$50            ;NEEDS FOLLOWING ZERO
ENSCRLOW  DB      0,0,$50                ;NEEDS FOLLOWING ZERO
ENSCRMID  DB      0,5,7,$15
EGMID     DB      $02,$05,$07,$10

BOINK     LDA     XPOS,X
          SEC
          SBC     XPOS,Y
          BMI     DECX
          CMP     #117
          BCS     DXCX
INCX      LDA     XPOS,X
          CLC
          ADC     #1
          CMP     #RMSTCPXL
          BCC     STBX
          LDA     #LMOSTPXL
STBX      STA     XPOS,X
          LDA     XPOS,Y
          SEC
          SBC     #1
          BPL     STBY
          LDA     #RMSTSPXL
STBY      STA     XPOS,Y
          JMP     DELTAV
DECX      CMP     #-123
          BCC     INCX
DXCX      LDA     XPOS,Y
          CLC
          ADC     #1
          CMP     #RMSTCPXL
          BCC     STBY1
          LDA     #LMOSTPXL
STBY1     STA     XPOS,Y
          LDA     XPOS,X
          SEC
          SBC     #1
          BPL     STBX1
          LDA     #RMSTSPXL
STBX1     STA     XPOS,X

DELTAV                                   ;HEAD ON HEAD TIE, CHANGE VELOC, ETC
          LDY     STAT2,X
          LDA     REVERSO,Y
          STA     STAT2,X

          LDA     STATES,X
          EOR     #$80
          STA     STATES,X

          LDX     TEMP3
          CPX     #1
          BNE     DV010

          LDY     STAT2,X
          LDA     REVERSO,Y
          STA     STAT2,X

          LDA     STATES,X
          EOR     #$80
          STA     STATES,X
          JMP     DV020

DV010     LDA     SPEED-2,X
          AND     #7
          TAY
          LDA     EREVERSE,Y
          STA     SPEED-2,X

DV020     TXA
          AND     #1
          TAX
          LDA     #TIESOUND
          CMP     SCNTRLI0,X
          BCC     RETBNK
          STA     SCNTRLI0,X
RETBNK    RTS

REVERSO   DB      5,6,7,8,9,0,1,2,3,4
EREVERSE  DB      4,5,6,7,0,1,2,3

*         THIS IS A VECTOR OF COLORS TO ROTATE THRU FOR THE TITLE PAGE ?????

ROT       DB      $40,$52,$64,$76,$88,$9A,$AC,$0E,$28


RACKLO    DB      L(RACK0ENM),L(RACK1ENM),L(RACK2ENM),L(RACK3ENM),L(RACK4ENM)
          DB      L(RACK5ENM),L(RACK6ENM),L(RACK7ENM),L(RACK8ENM),L(RACK9ENM)
          DB      L(RACK10EN),L(RACK11EN),L(RACK12EN),L(RACK13EN),L(RACK14EN)
          DB      L(RACK15EN),L(RACK16EN),L(RACK17EN),L(RACK18EN),L(RACK19EN)
          DB      L(RACK20EN),L(RACK21EN),L(RACK22EN),L(RACK23EN),L(RACK24EN)
          DB      L(RACK25EN),L(RACK26EN)

********************************************************************************
RACK7ENM
RACK3ENM  DB      4,4,4,4,4,4
RACK15EN
RACK19EN
RACK11EN  DB      5,5,5,5,5,5
RACK0ENM
RACK1ENM
RACK4ENM                                 ;PLUS A TERRY
RACK2ENM  DB      1
RACK10EN
RACK5ENM  DB      1
RACK8ENM                                 ;PLUS A TERRY
RACK9ENM
RACK6ENM
RACK12EN  DB      1,2,2,2,3
RACK14EN                                 ;PLUS A TERRY
RACK13EN  DB      1
RACK16EN  DB      2
RACK18EN                                 ;PLUS A TERRY
RACK17EN
RACK20EN  DB      2
RACK22EN                                 ;PLUS A TERRY
RACK24EN
RACK25EN
RACK26EN                                 ;PLUS A TERRY
RACK21EN  DB      3,3,3,3,3,3
RACK23EN  DB      6,6,6,6,6,6

ENEMATBL  DB      2,3,4,6,$83,4,4,6,$83,4,5,6,5,5,$84,6,5,5,$85,6,6,6,$85,6,6,6
          DB      $85

ENDF
*         ORG     $FD40

*         CCHKNUMS IS A VECTOR OF CLIFF NUMBERS.  THERE IS ONE ENTRY FOR EVERY
*                 FOUR LINES.  THESE ARE LEFTS CLIFF NUMBERS.  IF THE STAMP
*                 IS ON THE RIGHT OF THE SCREEN THE CLIFF NUMBER MUST BE
*                 WRAPED AROUND USING THE VECTOR WCLFWRAP.

CCHKNUMS  DB      5,5,5,5,5,5,5,5,6,6
          DB      6,6,6,2,2,2,2,2,2,2
          DB      2,2,3,3,3,3,3,0,0,0
          DB      0,0,0,0,0,0,0,0,0,0
CLIFWRAP
WCLFWRAP  DB      0,1,4,3,2,7,6,5

*         THESE VECTORS CONTAIN THE BOUNDRY PIXELS OF THE CLIFFS
*         THE REGULAR VALUES ARE NEVER USED ONLY THE ONES WITH +'S AND -'S

*RIGHTS    DB      096,148,032,080,148,024,084,148
*LEFTS     DB      032,001,001,048,096,001,044,104
*TOPS      DB      156,156,084,104,084,028,048,028
*BOTS      DB      191,159,087,107,087,031,051,031

*         THESE VECTORS CONTAIN CLIFF BOUNDIES +/- (P/M) A CONSTANT

*RIGHTSM2  DB      094,146,030,078,146,022,082,146
RIGHTSM1  DB      095,147,031,079,147,023,083,147
RIGHTSP1  DB      097,129,033,081,129,025,085,129
LEFTSM4   DB      028,000,000,044,092,000,040,100
LEFTSM7   DB      025,000,000,041,089,000,037,097
TOPSM9    DB      147                    ;,147,075,095,075,019,039,019
TOPSM11   DB      145,145,073,093,073,017,037,017
TOPSM15   DB      141,141,069,089,069,013,033,013
BOTSP1    DB      192,160,088,108,088,032,052,032

LAVA      EQU     158
LAVAM11   EQU     147

*         CLIFIGS IS A VECTOR OF CLIF CONFIGURATIONS.  THE CURRENT ONE IS
*                 INDEXED BY CFIGINDX IN RAM.  BITS  ARE SET IDICATING WHICH
*                 CLIFFS ARE IN THE CURRENT CONFIGURATION.  MAPPED AS 76543210

CLIFIGS   DB      $FF,$B7,$B5,$FD
          DB      $BD,$1D,$15,$FD
          DB      $5D,$55,$15,$FD
          DB      $F5,$B5,$15


*         CNUMASKS IS A VECTOR OF MASKS FOR EACH CLIFF NUMBER.   THESE ARE
*                 USED WITH THE CONFIGURATIONS ABOVE TO DETERMINE IF A GIVEN
*                 CLIFF IS IN A PARTICULAR RACK.

CNUMASKS  DB      $01,$02,$04,$08,$10,$20,$40,$80

*         THIS VECTOR IS THE NUMBER OF FRAME COUNT WRAPS FOR INITIALIZES THE
*                 TERRY TIMES

TITIMES   DB      3,4,5,9,11

*         ACCELS IS A VECTOR CONTAINING THE GRAVITATIONAL AND RESULTANT
*                 UPWARD ACCELERATIONS.  THE UNITS ARE RASTERS PER FRAME SQUARED

ACCELS    DB      $0B                    ;GRAVITY ACCEL FRACTION
          DB      $0                     ;GRAVITY ACCEL INTEGER
          DB      $C0                    ;UP ACCEL FRACTION
          DB      $FF                    ;UP ACCEL INTEGER

*         THE NEXT TWO VECTORS ARE THE HORIZONT SPEEDS CHANGE 1 LEFT OR RIGHT

SPEDCNGR  DB      1,2,3,4,4,0,5,6,7,8
SPEDCNGL  DB      5,0,1,2,3,6,7,8,9,9

*         THESE VECTORS CONTAIN X SPEED CHANGED AND INVERTED IF MOVING L/R

SPCNGIFR  DB      6,6,6,7,7,5,6,7,8,9
SPCNGIFL  DB      0,1,2,3,4,1,1,1,2,2

*         THIS VECTOR CONTAINS X SPEED SLOWED BY ONE

SPEEDEC   DB      0,0,1,2,3,5,5,6,7,8

*         THESE  NUMBERS ARE NEW FLYING SPEEDS INDEXED BY SPEED
*                 AND ONE BIT FOR STICK LEFT/RIGHT

NFSTAT2   DB      $01,$06,$02,$00,$04,$01,$04,$02,$04,$02
          DB      $01,$06,$05,$07,$06,$09,$07,$09,$07,$09

*         THESE ARE THE DELTA X NUMBERS FOR ALL SPEEDS BY MOD 4 FRAME COUNT

DELTAX    DB      0,0,0,0,1,0,0,0,1,0,1,0,1,1,1,0,1,1,1,1
          DB      0,0,0,0,-1,0,0,0,-1,0,-1,0,-1,-1,-1,0,-1,-1,-1,-1

*         THESE ARE THE STARTING X POSSITIONS FOR CLIFF ONE BIRTHS

C1XPOS    DB      40,82

*         THIS VECTOR CONTAINS THE INITIAL WALK STATES BASED ON SPEED AND FACING

IWLKSTAT  DB      $70,$F0,$70,$70,$70,$70,$70,$70,$70,$70
          DB      $70,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0

*         THIS VECTOR CONTAINS THE INITIAL WALK GENERALS BASED ON CLIFF NUMBER

*IWLKGENS  DB      $8C,$9C,$AC,$BC,$CC,$DC,$EC,$FC

*         THIS VECTOR CONTAINS THE RESULTANT INTEGER VELOCITIES

TERMVELS  DB      0,1,2,2,2,2,2,2
          DB      -3,-3,-3,-3,-3,-3,-2,-1

*         THIS VECTOR CONTAINS THE CLIFF BOTTOM BOUNCE VELOCITIES INDEXED BY
*                 OLD YVELINT AND #$0F

CLFBVELS  DB      0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0
ENDFF

          ORG     $FFF2
GOBANKD   JMP     DOBANKD
DOBANKF   JMP     NOSEL
          ORG     $FFFC

          DB      L(FBANK),H(FBANK)      ; INTERRUPT RESET VECTOR

          ORG     $D000
          NOP
          NOP
          NOP
START     SEI
          CLD
          LDX     #$FF
          TXS
          LDA     #0
INITRAM   STA     WSYNC,X
          DEX
          BNE     INITRAM


          LDA     #$C0
          STA     ATTRACT
          LDA     #1
          STA     GAMETYPE
          JSR     GMINIT
          LDA     #29
          STA     LINECNT

          JMP     NEWFRAME
***********


;POSITION PLAYERS FOR BITMAP
BITMAP    STA     WSYNC
BITMAPPL  LDA     #3                     ;2
          STA     VDELP1                 ;5
          STA     NUSIZ0                 ;8
          STA     NUSIZ1                 ;11
          LDA     #0                     ;13
          STA     GRP0                   ;16
          STA     GRP1                   ;19
          STA     GRP0                   ;22
          LDX     #$40                   ;24
          STX     HMP0                   ;27
          LDA     #$50                   ;29
          STA     HMP1                   ;32
          NOP                            ;34
          NOP                            ;36
          NOP                            ;38
          STA     RESP0                  ;41
          STA     RESP1                  ;44
MINBIT    STY     TEMP0                  ;47
          LDA     (PTR0),Y               ;52
          STA     GRP0                   ;55
          LDA     (PTR4),Y               ;60
          TAX                            ;62
          STA     WSYNC                  ;65
          STA     HMOVE                  ;3
BITLP     LDA     (PTR1),Y               ;8
          STA     GRP1                   ;11
          LDA     (PTR2),Y               ;16
          STA     GRP0                   ;19
          LDA     (PTR3),Y               ;24
          STA     PREVIOUS               ;27
          LDA     (PTR5),Y               ;32
          TAY                            ;34
          LDA     PREVIOUS               ;37
          DEC     TEMP0                 ;42
          STA     GRP1                   ;45
          STX     GRP0                   ;48
          STY     GRP1                   ;51
          STA     GRP0                   ;54
          LDY     TEMP0                 ;57
          LDA     (PTR0),Y               ;62
          STA     GRP0                   ;65
          LDA     (PTR4),Y               ;70
          TAX                            ;72
          TYA                            ;74
          NOP                            ;76
          BPL     BITLP                  ;2 (3)
          LDA     #0                     ;4
          STA     GRP0                   ;7
          STA     GRP1                   ;10
          STA     GRP0                   ;13
          RTS                            ;19

DLOAD
          BIT     ATTRACT
          BVC     DOLOAD
          JMP     BWLOOP

VOL4      LDA     #4                     ;PLEASE DON'T LET THESE START A PAGE!!
          BNE     LDYINDX
VOL7      LDA     #7
LDYINDX   LDY     SNDINDX0,X

          BPL     STVOL

MAJKLDG
          STY     TEMP1
          LDA     SNDINDX0,X
          AND     #3
          STA     TEMP0
          LDA     SNDINDX0,X
          LSR     A
          LSR     A
          TAY
          LDA     TEMP1
          CMP     #EGGHTCH
          BNE     NOEGGH
          LDY     TEMP0
NOEGGH    LDA     (PTR0),Y
          LDY     TEMP0
          BPL     STVOL

DOLOAD

SNDRIVER
          BIT     ATTRACT
          BMI     SNDEXIT

DOSND
          LDA     #H(SOUNDS)
          STA     PTR0H
          STA     PTR1H
          LDX     #1
SOUNDLP
          LDA     SCNTRLI0,X             IF SOUND CONTROL >= CURRENT SOUND
          CMP     SNDTYP0,X              THEN INITIATE SOUND OF SOUND CONTROL
          BCC     SNDSKP10               ELSE DO CURRENT SOUND

          STA     SNDTYP0,X
          TAY
          LDA     DUR-1,Y
          STA     SNDTIM0,X
          LDA     SCNTRLS-1,Y
          STA     AUDC0,X
          LDA     LENGTH-1,Y
          STA     SNDINDX0,X

SNDSKP10
          LDY     SNDTYP0,X
          BEQ     NULL
          CPY     #STPSKDSN
          BEQ     NULL
          CPY     #STPSHLDS
          BEQ     NULL


          LDA     LFTABL-1,Y
          STA     PTR1

          CPY     #SHLDSND
          BEQ     VOL4
          CPY     #VBRTHSND
          BEQ     VOL4
          CPY     #SKDSOUND
          BEQ     VOL7
          CPY     #SCREETCH
          BEQ     VOL7

          LDA     LVTABL-1,Y
          STA     PTR0

          CPY     #TIESOUND
          BEQ     MAJKLDG
          CPY     #EXTRAMAN
          BEQ     MAJKLDG
          CPY     #EGGHTCH
          BEQ     MAJKLDG

          LDY     SNDINDX0,X
          LDA     (PTR0),Y
STVOL     STA     AUDV0,X

          LDA     (PTR1),Y
          STA     AUDF0,X

          DEC     SNDTIM0,X
          BPL     SNDSKP30
          DEC     SNDINDX0,X
          BMI     ENDSND

          LDY     SNDTYP0,X
          LDA     DUR-1,Y
          STA     SNDTIM0,X
          BPL     SNDSKP30


ENDSND    LDA     #0
          BEQ     SNDSKP29
NULL      LDA     #0
          STA     AUDV0,X
SNDSKP29  STA     SNDTYP0,X

SNDSKP30  DEX
          BPL     SOUNDLP
SNDEXIT

;ZONE CROSSING CODE
;TTHIS SETS BITS IN ENEMY SPEED BYTE FOR POSSIBILITY OF UP OR DOWN
;ZONE CROSSING.  BIT 7 IS UP, BIT 6 IS DOWN.  OBJECTS IN THE TOP ZONE
;WILL HAVE THEIR UP BITS ALWAYS ON, OBJECTS IN THE BOTTOM ZONE WILL HAVE THEIR
;DOWN BITS ALWAYS ON
;THIS ROUTINE NEEDS NINE BYTES OF TEMPS, CONTIGUOUS IF POSSIBLE. THIS SHOULD
;NOT BE A PROBLEM

;THE TEMPS ARE
;TOPCNT, MIDCNT, BOTCNT   (1 BYTE EACH)
;TOPDEX, MIDDEX, BOTDEX   (2 BYTES EACH)

CROSS
          BIT     DEPNUM                 ;DONT RUN THIS UNTIL ALL ENEMIES ARE
          BPL     JDONE                  ;OUT
          LDA     #0
          STA     TOPCNT
          STA     MIDCNT
          STA     BOTCNT

          LDX     #5
FILLP     LDA     TYPE,X
          AND     #$0F
          BEQ     NOPE1

          LDA     YPOSINT+2,X
          CMP     #UPPER+4
          BCC     DOTOP
          CMP     #LOWER+4
          BCS     DOLOW
                                         ;OTHERWISE IN MIDDLE
          LDY     MIDCNT
          STX     MIDDEX,Y
          INC     MIDCNT
          BNE     NOPE

DOTOP     LDY     TOPCNT
          STX     TOPDEX,Y
          INC     TOPCNT
          BNE     NOPE

DOLOW     LDY     BOTCNT
          STX     BOTDEX,Y
          INC     BOTCNT

NOPE      LDA     SPEED,X
          AND     #$3F
          STA     SPEED,X
NOPE1     DEX
          BPL     FILLP

          LDA     #1
          CMP     TOPCNT
          BNE     DOREST
          CMP     MIDCNT
          BNE     DOREST
          CMP     BOTCNT
          BEQ     SPECIAL

DOREST
          LDX     TOPCNT
          BEQ     DOMID
          CPX     #2
          BEQ     DOTOP2

          LDA     MIDCNT
          CMP     #2
          BEQ     DOMID
          BNE     SETDN


SPECIAL
          LDX     MIDDEX                 ;1-1-1 CASE    ALL GO DOWN
          LDA     SPEED,X
          ORA     #$40
SPECFLO   STA     SPEED,X
SPECIAL2  LDX     TOPDEX
          LDA     SPEED,X
          ORA     #$40
          STA     SPEED,X
JDONE     JMP     DONE

DOTOP2
          LDA     MIDCNT
          BNE     DOMID

          LDA     BOTCNT
          CMP     #2
          BEQ     SPECIAL2


SETDN
          LDX     TOPDEX
          LDA     SPEED,X
          ORA     #$40
          STA     SPEED,X

DOMID
          LDX     MIDCNT
          BEQ     DOBOT
          CPX     #2
          BEQ     DOMID2

          LDA     TOPCNT
          LDX     MIDDEX                 ;SHOULD BE ZEROTH ONE
          CMP     #2
          BEQ     CHK1BOT
          LDA     SPEED,X
          ORA     #$80
          STA     SPEED,X
CHK1BOT   LDA     BOTCNT
          CMP     #2
          BEQ     DOBOT
          LDA     SPEED,X
          ORA     #$40
          BNE     DOBOTM

DOMID2
          LDX     MIDDEX
          LDA     TOPCNT
          BNE     CHK2BOT
          LDA     SPEED,X
          ORA     #$80
          STA     SPEED,X
          LDX     MIDDEX+1
          LDA     SPEED,X
          ORA     #$80
          STA     SPEED,X
CHK2BOT   LDA     BOTCNT
          BNE     DOBOT
          LDX     MIDDEX
          LDA     SPEED,X
          ORA     #$40
          STA     SPEED,X
          LDX     MIDDEX+1
          LDA     SPEED,X
          ORA     #$40
DOBOTM    STA     SPEED,X


DOBOT
          LDY     BOTCNT
          BEQ     DONE
          CPY     #2
          BEQ     DOBOT2

          DEY                            ;Y NOW IS 0
          LDA     MIDCNT
          CMP     #2
          BEQ     DONE
          BNE     SETUP

DOBOT2
          LDA     MIDCNT
          BNE     DONE
          LDY     #1
          LDA     TOPCNT
          BEQ     SETUP
          DEY

SETUP
SETUPLP   LDX     BOTDEX,Y
          LDA     SPEED,X
          ORA     #$80
          STA     SPEED,X
          DEY
          BPL     SETUPLP

DONE
          LDA     SWCHB
          AND     #8
          STA     TEMP3

          LDA     #0
          STA     P0VTBL
          STA     P1VTBL
          STA     P0VTBL+1
          STA     P1VTBL+1
          STA     P0VTBL+2
          STA     P1VTBL+2

          STA     P0CNT
          STA     P1CNT

          LDA     FRMCNT
          LSR     A
          BCC     ELOAD

          LDX     #1
PLDLP     LDA     STAT2,X
          CMP     #PGONE
          BEQ     ANOTHX
          LDA     XPOS,X
          CMP     #$7A
          BCS     ANOTHX
          INC     P0CNT,X
          TXA
          BEQ     PLAY0
          STA     P1VTBL
          BNE     ANOTHX
PLAY0     STA     P0VTBL
ANOTHX    DEX
          BPL     PLDLP
          BMI     RESTLOAD

ELOAD     LDY     #7
LOOP      LDA     TYPE-2,Y
          AND     #$0F
          BEQ     LABEL

          LDA     XPOS,Y
          CMP     #$7A
          BCS     LABEL
          LDA     YPOSINT,Y
          CMP     #UPPER
          LDX     #2
          BCC     STUFFIT
          DEX
          CMP     #LOWER
          BCC     STUFFIT
          DEX

STUFFIT
          TXA
          LSR     A
          BCS     BRADKLDG
          LDA     P0VTBL,X
          BNE     USE1
USE0      STY     P0VTBL,X
          INC     P0CNT
          BNE     LABEL

BRADKLDG  LDA     P1VTBL,X
          BNE     USE0

USE1      STY     P1VTBL,X
          INC     P1CNT
LABEL     DEY
          CPY     #1
          BNE     LOOP

          LDA     #L(P0VTBL)
          STA     PTR0
          DEY                            ;Y GOES FROM 1 TO 0
          STY     PTR0H
          LDA     #L(P1VTBL)
          STA     PTR1
          JMP     SQUISH

RESTLOAD
          LDY     P0CNT
          BNE     DOP0
          STY     P0HPOS
          DEY
          STY     P0VTBL
          STY     P0VOFF
          JMP     DONEP0

DOP0      DEY
          STY     P0CNT
          LDA     #0
          STA     ZONECNT

P0LOADLP  STY     PREVIOUS
          LDA     #0
          STA     INFP0,Y
          LDX     P0VTBL,Y               ;THIS IS INDEX OF HIGHEST ONE

          JSR     PICKSTP

          STA     STAMP0,Y

          LDY     XPOS,X
          LDA     HTABLE,Y
          LDY     PREVIOUS
          STA     P0HPOS,Y

          CPX     #2
          BCS     ENMYCOL

          LDA     STAT2,X

          CMP     #BIRTH1ST
          BEQ     DOCHEK
          CMP     #SHIELD
          BNE     USEYCOL

DOCHEK    LDA     FRMCNT
          AND     #8
          BEQ     USEYCOL
          LDA     #$0E
          BNE     FORCE0

ENMYCOL   LDA     TYPE-2,X
          AND     #$0C
          BEQ     DOENM
          CMP     #4
          BEQ     ANEGG

          LDA     #$80
          STA     INFP0,Y
          LDY     #6                     ;OTHERWISE, A TERRY
          BNE     USEYCOL
ANEGG     LDY     #5
          BNE     USEYCOL
DOENM     LDA     TYPE-2,X
          AND     #$03
          TAY
          INY
USEYCOL   TYA
          CLC
          ADC     TEMP3
          TAY
          LDA     COLORTAB,Y
FORCE0    LDY     PREVIOUS
          STA     COLOR0,Y

          LDA     STATES,X
          AND     #$80
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          ORA     INFP0,Y
          STA     INFP0,Y

          LDA     YPOSINT,X
          LSR     A
          LSR     A
          TAX
          INX
          CLC
          ADC     #6
          PHA
          TXA
          SEC
          SBC     ZONECNT
          STA     P0VTBL,Y
          PLA
          STA     ZONECNT

          DEY
          BMI     DONEP0
          JMP     P0LOADLP

DONEP0

          LDY     P1CNT
          BNE     DOP1
          STY     P1HPOS
          DEY
          STY     P1VTBL
          STY     P1VOFF
          JMP     DONEP1

DOP1      DEY
          STY     P1CNT
          LDA     #0
          STA     ZONECNT

P1LOADLP  STY     PREVIOUS
          LDA     #0
          STA     INFP1,Y
          LDX     P1VTBL,Y               ;THIS IS INDEX OF HIGHEST ONE

          JSR     PICKSTP

          STA     STAMP1,Y

          LDY     XPOS,X
          LDA     HTABLE,Y
          LDY     PREVIOUS
          STA     P1HPOS,Y

          CPX     #2
          BCS     USETYPE1
          INY
          LDA     STAT2,X

          CMP     #BIRTH1ST
          BEQ     DOWHT
          CMP     #SHIELD
          BNE     USEYCOL1

DOWHT     LDA     FRMCNT
          AND     #4
          BEQ     USEYCOL1
          LDA     #$0E
          BNE     FORCE1
USETYPE1  LDA     TYPE-2,X
          AND     #$0C
          BEQ     DOENM1
          CMP     #4
          BEQ     ANEGG1

          LDA     #$80
          STA     INFP1,Y
          LDY     #6                     ;OTHERWISE, A TERRY
          BNE     USEYCOL1
ANEGG1    LDY     #5
          BNE     USEYCOL1
DOENM1    LDA     TYPE-2,X
          AND     #$03
          TAY
          INY
USEYCOL1  TYA
          CLC
          ADC     TEMP3
          TAY
          LDA     COLORTAB,Y
FORCE1    LDY     PREVIOUS
          STA     COLOR1,Y

          LDA     STATES,X
          AND     #$80
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          ORA     INFP1,Y
          STA     INFP1,Y

          LDA     YPOSINT,X
          LSR     A
          LSR     A
          TAX
          INX
          CLC
          ADC     #6
          PHA
          TXA
          SEC
          SBC     ZONECNT
          STA     P1VTBL,Y
          PLA
          STA     ZONECNT

          DEY
          BMI     DONEP1
          JMP     P1LOADLP

DONEP1

          LDA     #40
          STA     ZONECNT
          LDX     P0CNT
          LDA     P0VTBL,X
          STA     P0VOFF
          LDX     P1CNT
          LDA     P1VTBL,X
          STA     P1VOFF

          LDX     CFIGINDX
          LDA     MTINDX,X
          STA     MPTR

          LDA     #H(RWALK0)
          STA     PTR0H
          STA     PTR1H
          LDA     #1
          STA     VDELP0


BWLOOP    LDA     INTIM
          BNE     BWLOOP
JKERN     JMP     KERNAL

LENGTH    DB      0,4,4,23,0,9,7,21,0,15,19,12,11,13,23

LOWBYTE   DB      L(RWALK0),L(RWALK1),L(RWALK2),L(RWALK3),L(RSKID)
          DB      L(RWINGUP),L(RWINGDWN),L(REXPL0),L(REXPL1),L(REXPL2)
          DB      L(RTERYWUP),L(RTERYWDN),L(EGG)

LIVES1    DB      $D2,$95,$95,$95,$95,$95,$95


LFTABL    DB      L(WALKFRQ)
          DB      L(FLAPFRQ),L(BNCEFRQ)
          DB      L(SKIDFRQ),L(NULL)
          DB      L(EXPLFRQ),L(BRTHFRQ)
          DB      L(SHLDFRQ),L(NULL)
          DB      L(TIEDFRQ)
          DB      L(SCRCHFRQ),L(VBRTHFRQ)
          DB      L(EGGHHFRQ),L(EATEGFRQ)
          DB      L(EXTRFRQ)

ENDSOUND

SOUNDS
EATEGFRQ  DB      $C,$D,$E,$F,$10,$11,$12,$13,$15,$17,$19,$1B,$1D,$1F
TIEDFRQ   DB      $12,$11,$10,$0F
BRTHFRQ   DB      $10,$1D,$00,$11,$1E,$00,$12
                                         ;THESE TWO ARE CONNECTED
EXPLFRQ   DB      $1F,$1E,$1D,$1B,$19,$17,$15,$13,$11
          DB      $F
SHLDFRQ   DB      $0B,$0C,$0D,$0E,$0F,$10,$11,$12
          DB      $13                    ;THESE TWO ARE CONNECTED
VBRTHFRQ  DB      $14,$15,$16,$17,$18,$19,$1A,$1B
          DB      $1C,$1D,$1E,$1F
BNCEFRQ   DB      $1F,$D,$C,$B           ;THESE TWO ARE CONNECTED
          DB      $A

SCRCHFRQ  DB      $F,$F,$F,$E,$E,$D,$C,$B,$A,$9,$8,$7,$6,$6,$6,$6,$6,$6
          DB      $6,$6

EGGHHFRQ  DB      0,3,7,9
EGGHHVOL  DB      0,7,6,5
EXTRFRQ   DB      $16,$11,$E,$C

FLAPVOL   DB      2,3,5,6
          DB      3
TIEDVOL   DB      2,4,6,8
EXPLVOL   DB      1,2,3
WALKFRQ   DB      4,5,6
WALKVOL   DB      7,8,9
                                         ;THESE TWO ARE CONNECTED
SKIDFRQ   DB      $19,$1B,$1C,$1A,$18,$1B,$17,$19,$1A,$19,$1C,$18
          DB      $1A,$17,$19,$1C,$1A,$17,$1B,$19,$18,$19,$1B
FLAPFRQ   DB      $18,$18,$18,$18        ;THESE TWO ARE CONNECTED
          DB      $18
BNCEVOL   DB      6,6,6                  ;THESE TWO ARE CONNECTED
BRTHVOL   DB      6,6,0,6,6,0,6
          DB      6

EATEGVOL  DB      2,3,4,4,5,5,6,7,8,9,$A,$A,$B,$B
EXTRVOL   DB      2,4,6,7,9,$B

TEDDY     DB      $38,$6C,$6C,$7C,$54,$BA,$C6

ENDLOAD

          ORG     $D4F6

KERNAL    STA     WSYNC
          LDA     #0                     ;2
          STA     VBLANK                 ;5
          LDA     #$E2                   ;17 ONLY FOR TITLE PAGE
          STA     TIM64T                 ;21
          BIT     ATTRACT                ;8
          BVC     STRTKERN               ;12/13
          NOP
          JMP     TTLKERN                ;15

STRTKERN

          LDX     P0CNT                  ;16
          LDA     STAMP0,X               ;20
          STA     PTR0                   ;23
          LDY     #0                     ;32
          LDA     INFP0,X                ;36
          STA     REFP0                  ;39
          BPL     STNZ0                  ;41/42
          LDY     #5                     ;43
STNZ0     STY     NUSIZ0                 ;46
          LDX     P1CNT                  ;49
          LDA     STAMP1,X               ;53
          STA     PTR1                   ;56
          LDY     #0                     ;58
          LDA     INFP1,X                ;62
          STA     REFP1                  ;65
          BPL     STNZ1                  ;67/68
          LDY     #5                     ;69
STNZ1     STY     NUSIZ1                 ;72
          STA     WSYNC                  ;75
;RASTER 2
          LDA     COLOR1,X               ;4
          STA     COLUP1                 ;7
          LDA     P1HPOS,X               ;11
          LDX     P0CNT                  ;14
          STA     HMP1                   ;17
          AND     #$F                    ;19
          TAY                            ;21
PS1       DEY                            ;23
          BPL     PS1                    ;25/26
          STA     RESP1                  ;28---->68
          STA     WSYNC                  ;71
;RASTER 3
          DEC     P0VOFF                 ;5
          DEC     ZONECNT                ;10
          LDA     P0HPOS,X               ;14
          STA     HMP0                   ;17
          AND     #$F                    ;19
          TAY                            ;21
PS0       DEY                            ;23
          BPL     PS0                    ;25/26
          STA     RESP0                  ;28--->68
          STA     WSYNC                  ;71
;RASTER 4
          STA     HMOVE                  ;3
          LDA     #5                     ;5
          STA     CTRLPF                 ;8
          LDA     COLOR0,X               ;12
          STA     COLUP0                 ;15
          LDA     #HEIGHT                ;17
          INY                            ;19
          LDX     P0VOFF                 ;22
          STA     HMCLR                  ;25
          BEQ     DOAP0                  ;27/28
          DEC     P1VOFF                 ;32
          BNE     PP0PP1                 ;34/35
          STA     P1VOFF                 ;37

          JMP     PP0DP1                 ;40
DOAP0     STA     P0VOFF                 ;31
          DEC     P1VOFF                 ;36
          BNE     DDP                    ;38/39
          STA     P1VOFF                 ;41
          JMP     DP0DP1                 ;44
DDP       JMP     DP0PP1                 ;42


;POSITION BOTH
;RASTER1
PP0PP1    STA     WSYNC
          LDA     #PFCOLOR1              ;2
          STA     COLUPF                 ;5
          LDX     P0CNT                  ;8
          LDA     STAMP0,X               ;12
          STA     PTR0                   ;15
          LDA     COLOR0,X               ;19
          STA     COLUP0                 ;22
          LDY     #0                     ;24
          LDA     INFP0,X                ;28
          STA     REFP0                  ;31
          BPL     STNSIZ0                ;33/34
          LDY     #5                     ;35
STNSIZ0   STY     NUSIZ0                 ;38
          LDX     P1CNT                  ;41
          LDA     STAMP1,X               ;45
          STA     PTR1                   ;48
          LDA     COLOR1,X               ;52
          STA     COLUP1                 ;55
          LDY     #0                     ;57
          LDA     INFP1,X                ;61
          STA     REFP1                  ;64
          BPL     STNSIZ1                ;66/67
          LDY     #5                     ;68
STNSIZ1   STY     NUSIZ1                 ;71
          STA     WSYNC                  ;74
;RASTER 2
          LDA     #PFCOLOR2              ;2
          STA     COLUPF                 ;5
          DEC     P0VOFF                 ;10
          LDA     P1HPOS,X               ;14
          STA     HMP1                   ;17
          AND     #$F                    ;19
          TAY                            ;21
POS1      DEY                            ;23
          BPL     POS1                   ;25/26
          STA     RESP1                  ;28---->68
          LDX     P0CNT                  ;71
          STA     WSYNC                  ;74
;RASTER 3
          LDA     #PFCOLOR3              ;2
          STA     COLUPF                 ;5
          DEC     ZONECNT                ;10
          LDA     P0HPOS,X               ;14
          STA     HMP0                   ;17
          AND     #$F                    ;19
          TAY                            ;21
POS0      DEY                            ;23
          BPL     POS0                   ;25/26
          STA     RESP0                  ;28--->68
          LDX     #PFCOLOR4              ;70
          LDA     #HEIGHT                ;72
          STA     WSYNC                  ;75
;RASTER 4
          STA     HMOVE                  ;3
          STX     COLUPF                 ;6
          LDX     ZONECNT                ;9
          BNE     NOEND                  ;11/12
          JMP     ENDKERN
NOEND     LDY     P0VOFF                 ;15
          BEQ     GOINP0                 ;17/18
          DEC     P1VOFF                 ;22
          BNE     POOPP1PF               ;24/25
          STA     P1VOFF                 ;27
          STA     HMCLR

          JMP     PP0DP1PF               ;30
GOINP0    STA     P0VOFF                 ;21
          DEC     P1VOFF                 ;26
          BNE     DPFPP0                 ;28/29
          STA     P1VOFF                 ;31
          JMP     DP0DP1PF               ;34
DPFPP0    JMP     WASTE303               ;32
POOPP1PF  NOP                            ;27 (28 ON PAGE CROSS)
WASTE102  NOP                            ;32
          NOP                            ;34
WASTE101  NOP
;WASTE TIME HERE
PP0PP1PF  STA     HMCLR                  ;37     3
OHMY      TXA                            ;39     5
          LSR     A                      ;41     7
          LDY     MPTR                   ;44     10
          LDA     PF,X                   ;48     14
          BEQ     AROUND                 ;50/51  16/17
          INC     MPTR                   ;55     21
          AND     MTABLE,Y               ;59     25
ARNDINC   LDY     #0                     ;61     27
          BCC     PF1ST                  ;63/64  29/30
          STA     PF2+$100               ;66     32
          STY     PF1                    ;69     35
          JMP     PP0PP1                 ;72     38
PF1ST     STY     PF2                    ;67     33
          STA     PF1                    ;70     36
          JMP     PP0PP1                 ;73     39
AROUND    STA     HMCLR
          NOP
          BEQ     ARNDINC                ;


;DRAW PLAYER1
;RASTER 1
PP0DP1    STA     WSYNC
          LDA     #PFCOLOR1              ;2
          STA     COLUPF                 ;5
          LDA     (PTR1),Y               ;10
          STA     GRP1                   ;13
          LDX     P0CNT                  ;16
          LDA     STAMP0,X               ;20
          STA     PTR0                   ;23
          LDA     COLOR0,X               ;27
          STA     COLUP0                 ;30
          LDA     INFP0,X                ;34
          STA     REFP0                  ;37
          BPL     STNS0                  ;39/40
          LDY     #5                     ;41
STNS0     STY     NUSIZ0                 ;44
          INC     PTR1                   ;49
          LDY     #0                     ;51
          STY     TEMP0                  ;54
          LDA     (PTR1),Y               ;59
          LDY     #PFCOLOR2              ;61
          INC     PTR1                   ;66
          LDX     P0CNT                  ;69
          STY     COLUPF                 ;72
          STA     WSYNC                  ;75
;RASTER 2
          STA     GRP1
          LDY     #0
          DEC     P0VOFF
          LDA     P0HPOS,X
          STA     HMP0
          AND     #$F
          TAX
POS0A     DEX
          BPL     POS0A
          STA     RESP0
;3 CYCLES AVAILABLE HERE
          LDA     #PFCOLOR3
          STA     WSYNC
;RASTER 3
          STA     HMOVE                  ;3
          STA     COLUPF                 ;6
          LDA     (PTR1),Y               ;11
          STA     GRP1                   ;14
          INC     PTR1                   ;19
          DEC     P1VOFF                 ;24
          BNE     DONE31A                ;26/27
          LDA     #$40                   ;28
          STA     TEMP0                  ;31
          LDX     P1CNT                  ;34
          DEX                            ;36
          LDA     P1VTBL,X               ;40
          STA     P1VOFF                 ;43
          TXA                            ;45
          BPL     NO1A                   ;47/48
          STX     P1VOFF                 ;50
          INX                            ;52
NO1A      STX     P1CNT                  ;55
DONE31A   LDA     (PTR1),Y               ;60
          LDX     #PFCOLOR4              ;62
          DEC     ZONECNT                ;67
          INC     PTR1                   ;72
          STA     WSYNC                  ;75
;RASTER 4
          STA     GRP1
          STX     COLUPF
          LDX     ZONECNT
          BNE     FOOBAR
          JMP     ENDKERN
FOOBAR    LDA     #HEIGHT
          BIT     TEMP0
          LDY     P0VOFF
          BEQ     NXTP0
          BVC     WASTCAS
          JMP     WASTE102               ;3 NOP'S THEN POS BOTH
NXTP0     STA     P0VOFF
          BVC     DODP0PP1
          STA     HMCLR
          JMP     DP0PP1PF
DODP0PP1  NOP
          JMP     DP0DP1PF
WASTCAS   NOP
          NOP
          NOP
          STA     HMCLR
PP0DP1PF  STA     HMCLR                  ;3
          TXA                            ;5
          LSR     A                      ;7
          LDY     MPTR                   ;10
          LDA     PF,X                   ;14
          BEQ     UNINCM                 ;16/17
          INC     MPTR                   ;21
          AND     MTABLE,Y               ;25
UNINC     LDY     #0                     ;27
          BCC     PF1OK
          STA     PF2+$100
          STY     PF1
          JMP     PP0DP1
PF1OK     STY     PF2
          STA     PF1
          JMP     PP0DP1
UNINCM    STA     HMCLR                  ;20
          NOP                            ;22
          BEQ     UNINC                  ;25
;DRAW BOTH CASE
;RASTER1
DP0DP1    STA     WSYNC
          LDA     #PFCOLOR1              ;2
          STA     COLUPF                 ;5
          LDA     (PTR0),Y               ;10
          STA     GRP0                   ;13
          LDA     (PTR1),Y               ;18
          STA     GRP1                   ;21
          INC     PTR0                   ;26
          INC     PTR1                   ;31
          LDA     (PTR0),Y               ;36
          STA     GRP0                   ;39
          LDA     (PTR1),Y               ;44
          LDX     #PFCOLOR2              ;46
          INC     PTR0                   ;51
          INC     PTR1                   ;56
          STY     TEMP0                  ;59
          STA     WSYNC                  ;62


;RASTER2
          STA     GRP1                   ;3
          STX     COLUPF                 ;6
          DEC     ZONECNT                ;11
          DEC     P1VOFF                 ;16
          DEC     P0VOFF                 ;21
          BNE     NOTEST                 ;23/24
          LDA     #$80                   ;25
          STA     TEMP0                  ;28
          LDX     P0CNT                  ;31
          DEX                            ;33
          LDA     P0VTBL,X               ;37
          STA     P0VOFF                 ;40
          TXA                            ;42
          BPL     NO0                    ;44/45
          STX     P0VOFF                 ;47
          INX                            ;49
NO0       STX     P0CNT                  ;52
NOTEST    LDA     (PTR0),Y               ;57
          STA     GRP0                   ;60
          LDA     (PTR1),Y               ;65
          STA     WSYNC                  ;68

;RASTER3
          STA     HMOVE                  ;3
          STA     GRP1                   ;6
          LDA     #PFCOLOR3              ;8
          STA     COLUPF                 ;11
          INC     PTR0                   ;16
          INC     PTR1                   ;21
          LDA     P1VOFF                 ;24
          BNE     DONE3                  ;27/28
          LDA     TEMP0                  ;29
          ORA     #$40                   ;31
          STA     TEMP0                  ;34
          LDX     P1CNT                  ;37
          DEX                            ;39
          LDA     P1VTBL,X               ;43
          STA     P1VOFF                 ;46
          TXA                            ;48
          BPL     NO1                    ;50/51
          STX     P1VOFF                 ;53
          INX                            ;55
NO1       STX     P1CNT                  ;58
DONE3     LDA     (PTR0),Y               ;63
          STA     GRP0                   ;66
          LDA     (PTR1),Y               ;71
          LDX     #PFCOLOR4              ;73
          STA     WSYNC                  ;76


;RASTER4
          STA     GRP1                   ;3
          STX     COLUPF                 ;6
          LDX     ZONECNT                ;9
          BNE     MORE                   ;11/12
          JMP     ENDKERN                ;14
MORE      INC     PTR0                   ;17
          INC     PTR1                   ;22
          BIT     TEMP0                  ;25
          BMI     GOTOP0                 ;27/28
          BVC     WASTEDD                ;29/30
          NOP
          JMP     DP0PP1PF               ;25
GOTOP0    BVC     DOPP0DP1               ;30/31
          STA     HMCLR+$100             ;34
          JMP     OHMY                   ;37
DOPP0DP1  JMP     PP0DP1PF               ;27
          ;PADDING AS NEEDED
WASTEDD   NOP
          NOP
DP0DP1PF  STA     HMCLR                  ;26
          TXA                            ;28
          LSR     A                      ;30
          LDY     MPTR                   ;33
          LDA     PF,X                   ;37
          BEQ     NOINCMK                ;39/40
          INC     MPTR                   ;44
          AND     MTABLE,Y                ;48   47 ON BRANCH
NOINCM    LDY     #0                     ;50
          BCC     PF1IN                  ;52/53
          STA     PF2+$100               ;55
          STY     PF1                    ;58
          JMP     DP0DP1                 ;61
PF1IN     STY     PF2                    ;56
          STA     PF1                    ;59
          JMP     DP0DP1                 ;62
NOINCMK   STA     HMCLR
          NOP
          BEQ     NOINCM

;THIS TABLE IS HERE FOR PAGE BOUNDARY CROSSING PROTECTION

MTABLE    DB      $00,$00,$FF,$00
          DB      $FF,$FF,$FF,$FF
          DB      $00,$FF,$00,$00
          DB      $FF,$FF,$00
;DRAW PLAYER0
;RASTER 1
DP0PP1    STA     WSYNC
          LDA     #PFCOLOR1              ;2
          STA     COLUPF                 ;5
          LDA     (PTR0),Y               ;10
          STA     GRP0                   ;13
          STY     GRP1                   ;16
          LDX     P1CNT                  ;19
          LDA     STAMP1,X               ;23
          STA     PTR1                   ;26
          LDA     COLOR1,X               ;30
          STA     COLUP1                 ;33
          LDA     INFP1,X                ;37
          STA     REFP1                  ;40
          BPL     STNS1                  ;42/43
          LDY     #5                     ;44
STNS1     STY     NUSIZ1                 ;47
          INC     PTR0                   ;52
          LDY     #0                     ;54
          LDA     (PTR0),Y               ;59
          INC     PTR0                   ;64
          STY     TEMP0                  ;67
          STA     GRP0                   ;70
          STY     GRP1                   ;73
          STA     WSYNC                  ;76
;RASTER 2
          LDA     #PFCOLOR2              ;2
          STA     COLUPF                 ;5
          DEC     P1VOFF                 ;10
          LDA     P1HPOS,X               ;14
          STA     HMP1                   ;17
          AND     #$F                    ;19
          TAX                            ;21
POS1A     DEX                            ;23
          BPL     POS1A                  ;25
          STA     RESP1                  ;28
          LDA     (PTR0),Y
          STA     WSYNC
;RASTER 3
          LDX     #PFCOLOR3              ;2
          STX     COLUPF                 ;5
          STA     GRP0                   ;8
          STY     GRP1                   ;11
          INC     PTR0                   ;16
          DEC     P0VOFF                 ;21
          BNE     DONE30A                ;23/24
          LDA     #$40                   ;25
          STA     TEMP0                  ;28
          LDX     P0CNT                  ;31
          DEX                            ;33
          LDA     P0VTBL,X               ;37
          STA     P0VOFF                 ;40
          TXA                            ;42
          BPL     NO0A                   ;44/45
          STX     P0VOFF                 ;47
          INX                            ;49
NO0A      STX     P0CNT                  ;52
DONE30A   LDA     (PTR0),Y               ;57
          LDX     #PFCOLOR4              ;59
          DEC     ZONECNT                ;64
          INC     PTR0                   ;69
          STA     GRP0                   ;72
          STA     WSYNC                  ;75
;RASTER 4
          STA     HMOVE                  ;3
          STY     GRP1                   ;6
          STX     COLUPF                 ;9
          LDX     ZONECNT                ;12
          BEQ     ENDKERN                ;14/15
          LDA     #HEIGHT                ;16
          BIT     TEMP0                  ;19
          LDY     P1VOFF                 ;22
          BEQ     NXTP1                  ;24/25
          BVC     WASTE0                 ;26/27
          STA     HMCLR                  ;29
          JMP     WASTE101               ;32      1 NOP'S THEN POS BOTH
NXTP1     STA     P1VOFF                 ;28
          BVC     DPP0DP1                ;30/31
          JMP     PP0DP1PF               ;33
DPP0DP1   JMP     DP0DP1PF               ;34
WASTE0    NOP
          STA     HMCLR
WASTE303  NOP
DP0PP1PF  STA     HMCLR                  ;30
          TXA                            ;32
          LSR     A                      ;34
          LDY     MPTR                   ;37
          LDA     PF,X                   ;41
          BEQ     UNINCMX                ;43/44
          INC     MPTR                   ;48
          AND     MTABLE,Y               ;52
UNINCX    LDY     #0                     ;54
          BCC     PF10K                  ;56/57
          STA     PF2+$100               ;59
          STY     PF1                    ;62
          JMP     DP0PP1                 ;65
PF10K     STY     PF2                    ;60
          STA     PF1                    ;63
          JMP     DP0PP1                 ;66
UNINCMX   STA     HMCLR
          NOP
          BEQ     UNINCX                 ;47


SQUISH
          LDX     #1
SQUISHER  LDY     #0
          LDA     (PTR0),Y
          BNE     TOPNOTB
          INY                            ;Y=1
          LDA     (PTR0),Y
          BNE     TOPYMIDN
          INY                            ;Y=2
          LDA     (PTR0),Y               ;NOW TOP AND MIDDLE ARE BLANK
          LDY     #0                     ;Y=0
          STA     (PTR0),Y
          BEQ     LOOPER
TOPNOTB   INY                            ;Y=1
          LDA     (PTR0),Y
          BEQ     HALFWAY
          BNE     LOOPER
TOPYMIDN  LDA     (PTR0),Y               ;Y STILL = 1
          DEY                            ;Y = 0
          STA     (PTR0),Y
HALFWAY   LDY     #2                     ;Y = 2
          LDA     (PTR0),Y
          DEY                            ;Y = 1
          STA     (PTR0),Y
LOOPER    LDA     PTR1
          STA     PTR0
          DEX
          BPL     SQUISHER
          JMP     RESTLOAD

ENDKERN
          LDA     #H(ZERO)               ;17
          STA     PTR0H                  ;20
          STA     PTR1H                  ;23
          STA     PTR2H                  ;26
          STA     PTR3H                  ;29
          STA     PTR4H                  ;32
          LDA     #$26                   ;34
          STA     COLUPF                 ;37
          LDY     #L(BLANK)              ;39
          LDA     CFIGINDX               ;42
          CMP     #2                     ;44
          BMI     NOTHING                ;46/47
          STX     MPTR                   ;49

NOTHING   LDA     GAMETYPE               ;52
          CMP     #2                     ;54
          BCC     NONTED                 ;56/57

          LDA     #H(TEDDY)              ;58
          STA     PTR0H                  ;61
          LDA     #L(TEDDY)              ;63
          STA     PTR0                   ;66
          BCS     NEXT3                  ;69

NONTED    SEC                            ;59
          LDA     HISCORE                ;62
          AND     #$F0                   ;64
          BNE     DOIT4                  ;66/67
          STY     PTR0                   ;69
          BEQ     NEXT3                  ;72
DOIT4     LSR     A                      ;69
          STA     PTR0                   ;72
NEXT3     STA     WSYNC                  ;75

          STX     GRP0                   ;3
          STX     GRP1                   ;6
          STX     PTR5                   ;9
          DEX                            ;11
          LDA     MPTR                   ;14
          BEQ     ST2ONLY                ;16/17
          STX     PF1                    ;19
ST2ONLY   STX     PF2                    ;22
          STY     REFP0                  ;25
          STY     REFP1                  ;28


NOTED     LDA     HISCORE                ;33
          AND     #$0F                   ;35
          BCC     DOIT3                  ;37/38
          BNE     DOIT3                  ;39/40
SUCKER    STY     PTR1                   ;42
          BEQ     NEXT2                  ;45
DOIT3     ASL     A                      ;42
          ASL     A                      ;44
          ASL     A                      ;46
          STA     PTR1                   ;49
NEXT2
          LDA     MIDSCORE               ;52
          AND     #$F0                   ;54
          BCC     DOIT2                  ;56/57
          BNE     DOIT2                  ;58/59
          STY     PTR2                   ;61
          BEQ     NEXT1                  ;64
DOIT2     LSR     A                      ;61
          STA     PTR2                   ;64
NEXT1     LDA     MIDSCORE               ;67
          AND     #$0F                   ;69
          STA     WSYNC                  ;72
          BCC     DOIT1A                 ;2/3
          BNE     DOIT1                  ;4/5
          STY     PTR3                   ;7
          NOP
          NOP
          BEQ     NEXT0                  ;14
DOIT1A    NOP                            ;5
DOIT1     ASL     A                      ;7
          ASL     A                      ;9
          ASL     A                      ;11
          STA     PTR3                   ;14
NEXT0     LDA     LOWSCORE               ;17
          AND     #$F0                   ;19
          BCC     DOIT0A                 ;21/22
          BNE     DOIT0                  ;23/24
          STY     PTR4                   ;26
          BEQ     NOMORE                 ;29
DOIT0A    NOP                            ;24
DOIT0     LSR     A                      ;26
          STA     PTR4                   ;29
NOMORE    LDA     #$28                   ;36
          STA     COLUP0                 ;39
          STA     COLUP1                 ;42
          LDA     #H(ZERO)
          STA     PTR5H
          LDY     #$6                    ;44
          LDA     #H(RETURN-1)           ;46
          PHA                            ;49
          LDA     #L(RETURN-1)           ;51
          PHA                            ;54
          LDA     #$1                    ;56
          STA     PF2                    ;59
          LDA     #$42                   ;61
          NOP                            ;63
          NOP                            ;65
          NOP                            ;67
          STX     PF1                    ;70
          STA     COLUPF                 ;73
          JMP     BITMAPPL               ;76

RETURN
          LDA     GAMETYPE               ;22
          CMP     #2                     ;24
          LDY     #L(BLANK)              ;26
          BCS     OEXT3                  ;28/29
          SEC                            ;30
          LDA     HISCORE+1              ;33
          AND     #$F0                   ;35
          BNE     OOIT4                  ;37/38
          STY     PTR0                   ;40
          BEQ     OEXT3                  ;43
OOIT4     LSR     A                      ;40
          STA     PTR0                   ;43
OEXT3     LDA     HISCORE+1              ;46
          AND     #$0F                   ;48
          BCC     OOIT3                  ;50/51
          BNE     OOIT3                  ;52/53
          STY     PTR1                   ;55
          BEQ     OEXT2                  ;58
OOIT3     ASL     A                      ;55
          ASL     A                      ;57
          ASL     A                      ;59
          STA     PTR1                   ;62
OEXT2     LDA     MIDSCORE+1             ;65
          AND     #$F0                   ;67
          BCC     OOIT2                  ;69/70
          BNE     OOIT2                  ;71/72
          STA     WSYNC                  ;74
          STY     PTR2                   ;3
          BEQ     OEXT1                  ;6
OOIT2     STA     WSYNC                  ;75
          LSR     A                      ;2
          STA     PTR2                   ;5
OEXT1     LDA     #$FF                   ;8
          STA     PF2                    ;11
          LDA     MIDSCORE+1             ;14
          AND     #$0F                   ;16
          BCC     OOIT1                  ;18/19
          BNE     OOIT1                  ;20/21
          STY     PTR3                   ;23
          BEQ     OEXT0                  ;26
OOIT1     ASL     A                      ;23
          ASL     A                      ;25
          ASL     A                      ;27
          STA     PTR3                   ;30
OEXT0     LDA     LOWSCORE+1             ;33
          AND     #$F0                   ;35
          BCC     OOIT0                  ;37/38
          BNE     OOIT0                  ;39/40
          STY     PTR4                   ;42
          BEQ     OOMORE                 ;45
OOIT0     LSR     A                      ;42
          STA     PTR4                   ;45
OOMORE    LDY     #6                     ;47
          LDA     #$76                   ;49
          STA     COLUP0                 ;52
          STA     COLUP1                 ;55
          LDA     GAMETYPE               ;58
          LSR     A                      ;60
          BCC     DOBITMAP               ;62/63
          LDA     #1                     ;64
          STA     PF2                    ;67
DOBITMAP  JSR     BITMAP                 ;73  WORST CASE
          LDA     #$70                   ;57
          STA     HMP0                   ;60
          LDA     #$80                   ;62
          STA     HMP1                   ;65
          LDX     #L(BLANK)              ;5
          LDY     #$FF                   ;67
          STA     WSYNC                  ;75
          STA     HMOVE                  ;3
          STY     PF2                    ;70
          LDA     LIVES                  ;8
          BPL     CMP10                  ;10/11
          TXA                            :12
          BPL     STPR0                  ;15
CMP10     CMP     #10                    ;13
          BCC     AROO                   ;15/16
          LDA     #9                     ;17
AROO      ASL     A                      ;19
          ASL     A                      ;21
          ASL     A                      ;23
STPR0     STA     PTR0                   ;26
          LDA     GAMETYPE               ;34
          LSR     A
          BCC     DOBLNK                 ;36/37
          LDA     LIVES+1                ;29
          BPL     CMP10A                 ;31/32
DOBLNK    TXA                            ;38
          BPL     STPR1                  ;41
CMP10A    CMP     #10                    ;39
          BCC     ARF                    ;41/42
          LDA     #9                     ;43
ARF       ASL     A                      ;45
          ASL     A                      ;47
          ASL     A                      ;49
STPR1     STA     PTR1                   ;52
          LDY     #6                     ;54
          LDX     #2                     ;56
          STX     NUSIZ0                 ;59
          STX     NUSIZ1                 ;62
          LDX     #$28                   ;64
          STA     WSYNC                  ;70
          LDA     #0
          STA     PF2
          LDA     #H(ZERO)
          STA     PTR0H
          STA     WSYNC                  ;29
          STX     COLUP0                 ;67
LIFLUP    LDA     (PTR0),Y               ;8
          STA     GRP0                   ;11
          LDA     LIVES1,Y               ;15
          STA     GRP1                   ;18
          LDA     LIVES0,Y               ;22
          STA     GRP0                   ;25
          LDX     #$26                   ;27
          STX     COLUP1                 ;30
          LDA     (PTR1),Y               ;35
          NOP                            ;37
          NOP
          STX     COLUP0                 ;42
          LDX     #$76                   ;44
          STA     GRP1                   ;47
          STX     COLUP1                 ;50
          STA     GRP0                   ;53
          LDX     #$28                   ;55
          STX     COLUP0                 ;58

          DEY                            ;60
          STA     WSYNC                  ;63
          BPL     LIFLUP                 ;2/3
          INY
          STY     GRP0
          STY     GRP1
          STY     VDELP1
          STA     WSYNC
          DEY
          STY     PF2
;         STA     WSYNC
;         INY
;         STY     PF1
;         STY     PF2

          JMP     NEWFRAME

* VISIBLE ======================================================================

TTLKERN
          LDA     #3                     ;23     NEED VERT. DELAY AND NUSIZE
          STA     VDELP0                 ;26     FOR BITMAP
          STA     VDELP1                 ;29
          LDX     #0                     ;31
          STX     GRP0                   ;34
          STX     GRP1                   ;37
          STA     RESP0+$100             ;41     POSITION FOR BITMAP
          STA     RESP1                  ;44
          STX     GRP0                   ;47
          STA     NUSIZ0                 ;50
          STA     NUSIZ1                 ;53
          LDX     #$40                   ;55     THESE ARE ONE TO THE LEFT OF
          STX     HMP0                   ;58     THE ONE CURRENTLY IN JOUST
          LDA     #$50                   ;60     BUT THESE ARE CENTERED
          STA     HMP1                   ;63
          STA     WSYNC                  ;66

          LDA     PLAYCOL                ;3      STORE PLAYER COLORS FOR BITMAP
          STA     COLUP0                 ;6
          STA     COLUP1                 ;9
          LDA     #L(LOGO0)              ;11     POINTERS ARE LOW BYTE PLUS
          CLC                            ;13     LINECNT SO THAT THE TOP IS
          ADC     LINECNT                ;16     ALWAYS DRAWN
          STA     PTR0                   ;19
          LDA     #L(LOGO1)              ;21     CARRY REMAINS CLEAR THROUGHOUT
          ADC     LINECNT                ;24
          STA     PTR1                   ;27
          LDA     #L(LOGO2)              ;29
          ADC     LINECNT                ;32
          STA     PTR2                   ;35
          LDA     #L(LOGO3)              ;37
          ADC     LINECNT                ;40
          STA     PTR3                   ;43
          LDA     #L(LOGO4)              ;45
          ADC     LINECNT                ;48
          STA     PTR4                   ;51
          LDA     #L(LOGO5)              ;53
          ADC     LINECNT                ;58
          STA     PTR5                   ;61
          LDA     #$52                   ;63     COLOR OF PLAYFIELD BOX
          STA     COLUPF                 ;66
          STA     WSYNC                  ;69

          LDA     #H(LOGO0)              ;2
          STA     PTR0H                  ;5      STORE HIGH POINTERS
          STA     PTR1H                  ;8
          STA     PTR2H                  ;11
          STA     PTR3H                  ;14
          STA     PTR4H                  ;17
          STA     PTR5H                  ;20

          LDA     #1
          STA     CTRLPF
          LDA     #28                    ;22     Y IS NUMBER OF LINES USED BY
          SEC                            ;24     BITMAP ROUTINE
          SBC     LINECNT                ;27
          TAY                            ;29
          LDA     #74                    ;31     X IS NUMBER OF LINES TO WAIT
          CLC                            ;33     BEFORE DRAWING BITMAP
          ADC     LINECNT                ;36
          TAX                            ;38
WAITLP    STA     WSYNC                  ;41     THIS LOOP WAITS UNTIL BITMAP
          DEX                            ;       IS TO START
          BPL     WAITLP
          STX     PF2                    ;X IS FF, FOR TOP OF BOX
          STA     WSYNC                  ;FOR TWO LINES, JUST HAVE TOP OF BOX
          STA     WSYNC
          LDA     #7                     ;NO MAKE HOLE IN BOX
          STA     PF2
          TYA                            ;IF Y IS NEGATIVE, DON'T CALL BITMAP
          BPL     DOBITM
          STA     WSYNC                  ;EXTRA WSYNC TO KEEP BOX IN ONE SPOT
          BMI     NOBITM                 ;ON SCREEN

DOBITM    JSR     MINBIT                 ;DRAW "JOUST"

NOBITM    STA     WSYNC                  ;END OF BLANK LINE UNDER JOUST
          LDX     #$FF                   ;MAKE BOTTOM OF BOX
          STX     PF2
          STA     WSYNC                  ;IT LASTS FOR TWO LINES
          STA     WSYNC
          INX                            ;NOW CLEAR OUT PLAYFIELD 2
          STX     PF2
          LDA     LINECNT                ;22     IF LINECNT = 0, DO COPYRIGHT
          BNE     VWLOOP                 ;24/25
          LDA     #H(COPY0)              ;26     SET HIGH BYTES
          STA     PTR0H                  ;29
          STA     PTR1H                  ;32
          STA     PTR2H                  ;35
          STA     PTR3H                  ;38
          STA     PTR4H                  ;41
          STA     PTR5H                  ;44
          LDA     #L(COPY0)              ;46     AND LOW BYTES
          STA     PTR0                   ;49
          LDA     #L(COPY1)              ;51
          STA     PTR1                   ;54
          LDA     #L(COPY2)              ;56
          STA     PTR2                   ;59
          LDA     #L(COPY3)              ;61
          STA     PTR3                   ;64
          LDA     #L(COPY4)              ;66
          STA     PTR4                   ;69
          LDA     #L(COPY5)              ;71
          STA     WSYNC                  ;74
          STA     PTR5                   ;3
          STA     HMCLR                  ;6      CLEAR OUT HM'S
          LDY     #6                     ;8      Y = 6 FOR HEIGHT OF COPY
          LDA     #$26                   ;MAKE IT A DARKER YELLOW THAN JOUST
          STA     COLUP0
          STA     COLUP1
          LDX     #29                    ;WAIT THIS MANY LINES BEFOR DOING COPY
CPWAIT    STA     WSYNC
          DEX
          BNE     CPWAIT
          JSR     MINBIT

***********
                              ;NOW LET TIMER RUN OUT FOR END OF SCREEN
VWLOOP    LDA     INTIM
          BNE     VWLOOP
          STA     WSYNC



* OVERSCAN =====================================================================

NEWFRAME  LDA     #$24                   ; (35 decimal)
          STA     TIM64T

;         JSR     FRZEOS                 ;COMMENT THIS OUT FOR NO FREEZE FRAMER
                                         ;OR TO BURN A CART
                                         ;MAY NOT HAVE ROM FOR THIS NOW
*         GAME OVERSCAN MAINLINE

GPENTRY   INC     FRMCNT
          BNE     NOALT

          LDA     ATTRACT
          AND     #$C0
          BEQ     NOALT
          LDA     ATTRACT
DOALT
          EOR     #$40
          STA     ATTRACT
          LDA     #29
          STA     LINECNT
          LDA     #0
          STA     COLORCNT


NOALT     LDA     ATTRACT
          AND     #$C0
          BEQ     NOAXE

          BIT     INPT4
          BPL     DOASET

          BIT     INPT5
          BPL     DOASET

NOAXE     LSR     SWCHB
          BCS     NORST

DOASET    JSR     GMINIT
          LDA     ATTRACT                ;CLEAR ATTRACT AND TITLE
          AND     #$3F
          STA     ATTRACT

          LDA     #0
          STA     SNDTYP0
          STA     SNDTYP1
          LDX     #5                     CLEAR SCORE
          STA     SCNTRLI0
          STA     SCNTRLI1
SCOREZIP  STA     HISCORE,X
          DEX
          BPL     SCOREZIP

                                         ;NEED MINUS SET FOR BANK SELECT
          JMP     GBEF

NORST     LDA     LIVES
          BPL     SELCHK
          LDA     GAMETYPE
          LSR     A
          BCC     GAMEOVER
          LDA     LIVES+1
          BPL     SELCHK

GAMEOVER
          LDA     #$C0
          STA     ATTRACT


          JSR     GMINIT
          LDA     #29
          STA     LINECNT
          LDA     #0
          STA     FRMCNT                 ;TO INSURE FULL TITLE PAGE
          STA     CFIGINDX
          STA     AUDV0
          STA     AUDV1
          STA     COLORCNT
          BEQ     GBEF

SELCHK    LDA     SWCHB
          LSR     A
          LSR     A
          BCC     SELHIT
          LDA     ATTRACT
          AND     #$C0
          BCS     GBEFM                  ;STORES ATTRACT
SELHIT
          LDA     #0
          STA     AUDV0
          STA     AUDV1
          LDA     ATTRACT                ;CLEAR TITLE
          AND     #$BF
          ORA     #$80
          STA     ATTRACT
          AND     #$1F
          BEQ     TOGGLE
          CMP     #$1F
          BNE     ORON
          LDA     ATTRACT                ;CLEAR COUNTER
          AND     #$C0
          STA     ATTRACT


TOGGLE
          LDX     GAMETYPE
          INX
          TXA
          AND     #3
          STA     GAMETYPE
          LSR     A
          BCC     DOAFF
          LDA     #$8D
          BNE     STYPOS1
DOAFF     LDA     #$FF
STYPOS1   STA     YPOSINT+1

ORON      LDA     ATTRACT
          AND     #$1F
          CLC
          ADC     #1
          STA     TEMP0                  ;CAN'T GO OVER $1F
          LDA     ATTRACT
          AND     #$C0
          ORA     TEMP0
GBEFM     STA     ATTRACT
          LDA     #0
GBEF      JMP     GOBANKF



PICKSTP
          LDY     #4
          CPX     #2
          BCC     DOPICK

          LDA     TYPE-2,X
          AND     #$0C
          BEQ     REGULAR
          LDY     #12
          CMP     #$04
          BEQ     P050
                                         ;OTHERWISE A TERRY
          DEY
          LDA     TYPE-2,X
          AND     #$10
          BNE     P050
          DEY
          BNE     P050

REGULAR
          LDA     TYPE-2,X
          AND     #$10
          BNE     WDN
          BEQ     WUP

DOPICK    LDA     STAT2,X

          CMP     #BIRTH1ST
          BEQ     BSTAND

          CMP     #PDEATH
          BEQ     P019

          LDA     STATES,X
          AND     #$60
          BEQ     P015

          CMP     #$20
          BEQ     P020

WALKER    LDA     STATES,X
          AND     #$30
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          TAY
          BPL     P050

BSTAND    DEY
          BPL     P050

P019      LDY     PDTHSNUM,X
          BNE     P050

P015      LDA     GEN2,X
          CMP     #FLYFEFST
          BEQ     P018

SIXER
WDN
          INY                            ;ENTER HERE FOR Y = 6
WUP
P018      INY                            ;ENTER HERE FOR Y = 5

P020                                     ;ENTER HERE FOR Y = 4

P050
          LDA     YPOSINT,X
          AND     #3
          STA     TEMP0

          LDA     LOWBYTE,Y
          SEC
          SBC     TEMP0
          LDY     PREVIOUS
          RTS

GMINIT

          LDX     #ITITI                 SET UP TERRY TIMER...
          STX     TITIMNDX
          LDA     #11
          STA     TERYTIME

          LDA     GAMETYPE
          LSR     A
          LDA     #141
          STA     YPOSINT
          BCS     STY1
          LDA     #$FF
STY1      STA     YPOSINT+1
          LDA     #40
          STA     XPOS
          LDA     #82
          STA     XPOS+1
          LDA     #1
          STA     GENERALS
          STA     GENERALS+1

          LDA     #$70
          STA     STATES
          STA     STATES+1

          LDX     #4
          STX     LIVES
          STX     LIVES+1
          LDX     #1                     ;SETS UP END OF RACK FF
          STX     TIMER
          DEX
          STX     ENEMA
          STX     STAT2
          STX     STAT2+1
          STX     GLADRAG
          DEX
          STX     RACKNUM
          STX     CFIGINDX
          STX     DEPNUM
          RTS

ENDD



DUR       DB      $00,$02,$00,$00,$00,$02,$03,$0D,$00,$02,$01,$02
          DB      1,0,1

LVTABL    DB      L(WALKVOL)
          DB      L(FLAPVOL),L(BNCEVOL)
          DB      L(NULL),L(NULL)
          DB      L(EXPLVOL),L(BRTHVOL)
          DB      L(NULL),L(NULL)
          DB      L(TIEDVOL)
          DB      L(NULL),L(NULL)
          DB      L(EGGHHVOL),L(EATEGVOL)
          DB      L(EXTRVOL)
COLORTAB  DB      $0E,$0A,$08,$06,$0A,$08,$06,0
          DB      $2A,$78,$56,$08,$D8,$C8,$46
SCNTRLS   DB      6,8,4,4,0,8,$D,7,0,4,7,3,8,4,4
ENDDC

*         THE FOLLOWING ARE PLAYER STAMPS

          ORG     $DD00
;ALL STAMPS ON THIS PAGE HAVE BEEN PACKED .  DON'T TOUCH WITHOUT CARE
          DB      0,0,0
RWALK0    DB      $06,$37,$26,$32,$3F,$32,$7A,$FE,$FC,$78,$60,$70,$18,$40,$60,0
          DB      0,0,0,0
RWALK1    DB      $06,$37,$26,$32,$3F,$32,$7A,$FE,$FC,$78,$30,$60,$30,$20,$30,0
          DB      0,0,0,0
RWALK2    DB      $06,$37,$26,$32,$3F,$32,$7A,$FE,$FC,$78,$70,$50,$50,$90,$08,0
          DB      0,0,0,0
RWALK3    DB      $06,$37,$26,$32,$3F,$32,$7A,$FE,$FC,$78,$30,$28,$28,$24,$24,0
          DB      0,0,0,0
RSKID     DB      $0C,$6E,$4C,$68,$7F,$34,$7A,$FE,$FC,$78,$28,$24,$12,$00,$00,0
          DB      0,0,0,0
RWINGDWN  DB      $06,$37,$26,$32,$3F,$32,$7A,$FE,$FC,$78,$70,$60,$40,$00,$00,0
          DB      0,0,0,0
RWINGUP   DB      $06,$B7,$E6,$F2,$FF,$F2,$7A,$FE,$FC,$78,$10,$00,$00,$00,$00,0
          DB      0
REXPL0    DB      $00,$00,$00,$08,$1C,$36,$1C,$08,$00,$00,$00,$00,$00,$00,$00,0
          DB      0,0
REXPL1    DB      $00,$00,$49,$2A,$1C,$77,$1C,$2A,$49,$00,$00,$00,$00,$00,$00,0
          DB      0,0,0,0
REXPL2    DB      $14,$08,$49,$22,$00,$63,$00,$22,$49,$08,$14,$00,$00,$00,$00,0
          DB      0,0,0,0
RTERYWUP  DB      $00,$E0,$71,$3E,$74,$FE,$7D,$00,$00,$00,$00,$00,$00,$00,$00,0
          DB      0,0
RTERYWDN  DB      $00,$00,$00,$0F,$74,$FF,$7C,$38,$70,$E0,$00,$00,$00,$00,$00,0
          DB      0,0,0,0
EGG       DB      $18,$3C,$7C,$7C,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,0
          DB      0,0,0,0
ENDSTAMP
ENDDD
          ORG     $DE00

ZERO      DB      $38,$6C,$6C,$6C,$6C,$7C,$38,0
ONE       DB      $7E,$18,$18,$18,$18,$58,$38,0
TWO       DB      $7E,$7A,$38,$1C,$0C,$6C,$38,0
THREE     DB      $38,$6C,$0C,$18,$0C,$6C,$38,0
FOUR      DB      $1C,$0C,$FE,$CC,$6C,$3C,$1C,0
FIVE      DB      $38,$6C,$0C,$6C,$78,$40,$7C,0
SIX       DB      $38,$6C,$6C,$78,$60,$6C,$38,0
SEVEN     DB      $70,$70,$30,$18,$4C,$64,$7C,0
EIGHT     DB      $38,$6C,$6C,$38,$6C,$6C,$38,0
NINE      DB      $38,$18,$0C,$3C,$66,$66,$3C,0
BLANK     DB      $00,$00,$00,$00

;GRAPHICS FOR JOUST LOGO
LOGO0     DB      0,0,0,$FE,$FF,$FF,$FF,$FF,$FF,$07,$03,$03,$03,$03,$03,$03
          DB      $03,$43,$63,$73,$7F,$3F,$3F,$1F,$0F,$03,0,0

LOGO1     DB      0,$0F,$1F,$1F,$3F,$3F,$BF,$BF,$F9,$F9,$F0,$F0,$F0,$F0,$F0
          DB      $F0,$F0,$F0,$F0,$F0,$F9,$B9,$BF,$BF,$DF,$DF,$DF,$0F,0

LOGO2     DB      $03,$07,$8F,$8F,$DF,$DF,$DF,$DE,$FC,$FC,$F8,$F8,$F8,$F8,$F8
          DB      $F8,$F8,$F8,$F8,$F8,$F8,$D8,$DC,$DC,$DC,$8C,$8C,$1C,$3E

LOGO3     DB      $80,$C1,$E7,$EF,$FF,$FF,$FF,$FE,$7C,$78,$38,$38,$38,$39,$3B
          DB      $3F,$3F,$3F,$3F,$3F,$3F,$3F,$77,$77,$73,$63,$61,$60,$F0

LOGO4     DB      0,$F0,$F8,$FD,$FF,$FF,$1F,$0F,$0F,$1F,$3F,$7F,$FD,$FD,$F9
          DB      $F0,$E0,$C0,$82,$03,$07,$8F,$9F,$FF,$FE,$FC,$F8,$F0

LOGO5     DB      0,0,0,$FF,$FF,$FF,$FF,$FF,$FF,$E0,$C0,$C0,$C0,$E0,$E0,$E0
          DB      $F0,$70,$FF,$FF,$FF,$FF,$FE,$F8,$F8,$98,$0C,$04,0


ENDDE
          ORG     $DF00

MTINDX    DB      4,7,7,4
          DB      2,10,0,4
          DB      3,11,0,4
          DB      5,7,0


HTABLE    DB      $60,$50,$40,$30,$20,$10,$00,$F0,$E0,$D0,$C0,$B0,$A0,$90,$80
          DB      $61,$51,$41,$31,$21,$11,$01,$F1,$E1,$D1,$C1,$B1,$A1,$91,$81
          DB      $62,$52,$42,$32,$22,$12,$02,$F2,$E2,$D2,$C2,$B2,$A2,$92,$82
          DB      $63,$53,$43,$33,$23,$13,$03,$F3,$E3,$D3,$C3,$B3,$A3,$93,$83
          DB      $64,$54,$44,$34,$24,$14,$04,$F4,$E4,$D4,$C4,$B4,$A4,$94,$84
          DB      $65,$55,$45,$35,$25,$15,$05,$F5,$E5,$D5,$C5,$B5,$A5,$95,$85
          DB      $66,$56,$46,$36,$26,$16,$06,$F6,$E6,$D6,$C6,$B6,$A6,$96,$86
          DB      $67,$57,$47,$37,$27,$17,$07,$F7,$E7,$D7,$C7,$B7,$A7,$97,$87
          DB      $68,$58,$48,$38,$28,$18,$08,$F8,$E8,$D8,$C8,$B8,$A8,$98,$88


;GRAPHICS FOR COPYRIGHT (38 BYTES)
COPY0     DB      $06,$09,$16,$14,$16,$09,$06
COPY1     DB      0,$29,$A9,$B9,$A9,$13
COPY2     DB      0,$2A,$2A,$3B,$2A,$93
COPY3     DB      0,$A3,$A1,$21,$A3,$A1
COPY4     DB      0,$97,$15,$77,$55,$77
COPY5     DB      0,$70,$10,$30,$10,$70,0

LIVES0    DB      $EE,$82,$82,$CE,$88,$88,$EE

PF        DB      $00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$F0,$00,$00,$00,$00,$FF,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$F8,$00,$00,$00,$00,$FC,$00,$00,$00,$00
          DB      $00,$00,$00,$00

ENDDF

          ORG     $DFF2
GOBANKF   JMP     DOBANKF
DOBANKD   JMP     DLOAD

          ORG     $DFFC
          DB      L(START),H(START)
          END     $F000
