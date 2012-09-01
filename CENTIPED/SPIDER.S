*** SPIDER.S ***

*         DVP     7/20/83        SPIDER MOVEMENT

SPDROBJ   EQU     12

MVSPIDER  LDA     ATTRACT
          BMI     SPPOINTS               ;IF IN ATTRACT MODE
          LDA     SHTRTIMR
          BNE     SPPOINTS               ;IF SHOOTER IS DEAD
          LDA     SPDRSTAT
          BMI     BUGON                  ;IF SPIDER IS LIVE

* BUG IS OFF SCREEN, WAITING TO COME ON
BUGOFF    LDA     #1
          JSR     SCRAPONE
          DEC     SPDRTIMR
          BNE     SPPOINTS               ;RTS

          LDA     #1
          JSR     TUNIN
          LDY     PLAYER                 ;SET SPEED AND DIRECTION OF SPIDER
          LDA     GAMETYPE
          CMP     #2
          BCC     ZGMTPSP2
          LDY     #2
          CMP     #2
          BNE     ZGMTPSP2
          DEY
          LDA     SCORE2+1
          CMP     SCORE2
          BCS     ZGMTPSP2
          DEY

ZGMTPSP2  LDX     #$C1                   ;FAST
          LDA     DIFLEVEL
          BEQ     EASYSPDR               ;ALWAYS SLOW SPDR IN XPRT
          CMP     #3                     ;ALWAYS FAST SPDR IN XPRT
          BEQ     FASTSPDR
          LDA     SCORE2,Y
          BNE     FASTSPDR
          LDA     SCORE1,Y
          CMP     #$50
          BCS     FASTSPDR
EASYSPDR  LDX     #$C0                   ;SLOW

FASTSPDR  JSR     RANDOM
          ASL     A
          TXA
          LDX     #MINX-SPDRWDTH+1
          BCC     RGHTSPDR
          ORA     #$20
          LDX     #MAXX-1

RGHTSPDR  STA     SPDRSTAT
          STX     SPDRX

          LDX     #L(SPIDER)
          STX     SPDROFST
          LDX     #PWSPIDER
          STX     OBJPALWD+SPDROBJ

          LDX     #96                    ;INITIAL V. POS.
          STX     SPDRY

          LDA     #60                    ;IN BONZO MODE, BOUNCE IN SAME DIR.
          LDX     DIFLEVEL               ;   FOR 60 SECONDS ALWAYS
          BEQ     BNCEASY
          JSR     RANDOM                 ;SET TIMER VALUE FOR CHANGING
          AND     #$2F                   ;   DIRECTION
          ORA     #$0F
BNCEASY   STA     SPDRTIMR
SPPOINTS  RTS

*******************
BUGON     LDA     SPDROFST               ;IS IT A SPIDER OR ARE POINTS BEING
          CMP     #L(SPIDER)             ;   DISPLAYED?
          BCC     SPPOINTS
          CMP     #L(SPIDER+12)
          BCS     SPPOINTS

*******************
OLDSPDR   LDA     FRMCNT                 ;CHANGE ANIMATIONS EVERY 4 FRAMES
          AND     #$03
          BNE     SAMESPDR

          LDA     SPDROFST               ;TIME TO CHANGE ANIM.
          CLC
          ADC     #3
          CMP     #L(SPIDER+12)
          BCC     SPDROK
          LDA     #L(SPIDER)
SPDROK    STA     SPDROFST

SAMESPDR  LDA     DIFLEVEL               ;ASSUMPTION -- ONLY 2 DIFFICULTY LEVELS
          BNE     SAMESPD2
          LDA     FRMCNT
          LSR     A
          BCC     SAMESPD2
          JMP     SPIDSHTR
SAMESPD2  DEC     SPDRTIMR               ;TIME TO CHANGE DIRECTION?
          BNE     SAMEDIR1

          JSR     RANDOM                 ;RANDOMLY KEEP H DIRECTION
          ASL     A
          BCC     SAMEHDIR

          BIT     SPDRSTAT
          BVC     NEWHDIR

          LDA     SPDRX                  ;IF PARTLY OFF SCREEN KEEP MOVING
          CMP     #MAXX-SPDRWDTH-1       ;   HORIZONTALLY
          BCS     SAMEHDIR
          CMP     #MINX
          BCC     SAMEHDIR

NEWHDIR   LDA     SPDRSTAT               ;FLIP WHETHER SPIDER IS MOVING HORIZ.
          EOR     #$40
          STA     SPDRSTAT

SAMEHDIR  LDA     RNDM                   ;RANDOMLY CHANGE V DIR.
          LSR     A
          LDA     SPDRSTAT
          BCC     SAMEVDIR               ;DON'T CHANGE V DIR.
          EOR     #$04
          STA     SPDRSTAT

SAMEVDIR  LDA     #$30                   ;PUT NEW TIMER VALUE INTO STATUS
          STA     SPDRTIMR

SAMEDIR1  LDA     SPDRSTAT               ;MOVE HORIZONTALLY
          CMP     #$C0
          BCC     NOHSPDR                ;NOT H MOVE

          LDX     DIFLEVEL
          BNE     FRMFAST
          LDA     #$03
          BNE     FRMSLOW
FRMFAST   AND     #$01                   ;HOW FAST SHOULD WE MOVE HORIZ.?
          EOR     #$01                   ;  (ACTUALLY, HOW OFTEN?)
FRMSLOW   AND     FRMCNT
          BNE     NOHSPDR

          LDA     SPDRSTAT
          AND     #$20
          BEQ     SPDRRGHT

          DEC     SPDRX
          JMP     NOHSPDR

SPDRRGHT  INC     SPDRX

NOHSPDR   LDA     SPDRX                  ;SET UP FOR OBSTAC ROUTINE
          CLC
          ADC     #SPDRWDTH/2-1          ;(USE MIDDLE OF SPIDER TO EAT MUSH.S)
          STA     GTEMP1

          LDA     SPDRSTAT               ;MOVE VERTICALLY
          AND     #$05
          CLC
          ADC     #1
          CMP     #$04
          BCC     SPDRDOWN               ;MOVE DOWN

          AND     #$03                   ;2'S COMPL. TO MOVE UP
          EOR     #$FF
;         SEC
          ADC     #$00

SPDRDOWN  ;CLC
          ADC     SPDRY
          STA     SPDRY

          ADC     #4
          JSR     OBSTAC                 ;EAT ANY MUSHROOMS ENCOUNTERED
          BEQ     NOEATM
          LDA     #L(EMPTY)
          STA     (GTEMP3),Y
          LDA     SPDRY
          CLC
          ADC     #4
          LSR     A
          LSR     A
          LSR     A
          CMP     #INFLDZN-1
          BCC     NOEATM

          LDX     PLAYER
          LDA     GAMETYPE
          CMP     #1
          BEQ     DECMUSHC
          LDX     #0
DECMUSHC  DEC     MUSHCNT,X

NOEATM    LDA     SPDRX                  ;DID SPIDER MOVE OFF EDGE OF SCREEN?
          CMP     #MINX-SPDRWDTH+1
          BCC     OFFEDGE
          CMP     #MAXX
          BCC     ONSCRN

OFFEDGE   LDX     DIFLEVEL               ;SET TIMER VALUE FOR COMING BACK ONTO
          LDA     SPDRWTDF,X
          STA     SPDRTIMR               ;   SCREEN
          LDA     #$00
          STA     SPDRSTAT
          RTS

SPDRWTDF  DB      $C0,$80,$60,$30

ONSCRN    LDA     SPDRY                  ;AT BOTTOM OF SCREEN?
          CMP     #MAXY-9
          BCC     CHECKTOP               ;YES

          LDA     SPDRSTAT
          AND     #$04
          BNE     NOTTOP
          BEQ     NEWVDIR

CHECKTOP  LDX     PLAYER                 ;NO -- AT UPPER LIMIT FOR CURRENT SCORE
          LDA     GAMETYPE
          CMP     #2
          BCC     ZGMTPSP1
          LDX     #2
          CMP     #2
          BNE     ZGMTPSP1
          DEX
          LDA     SCORE2+1
          CMP     SCORE2
          BCS     ZGMTPSP1
          DEX

ZGMTPSP1  LDA     SCORE2,X
          SED
          SEC
          SBC     #6
          CLD
          BPL     NOTZ12
          LDA     #0
NOTZ12    LSR     A
          CMP     #6
          BCC     NOTZ7
          LDA     #5
NOTZ7     ASL     A
          ASL     A
          ASL     A
;         CLC
          ADC     #96
          CMP     SPDRY
          BCC     NOTTOP

          LDA     SPDRSTAT               ;AT TOP
          AND     #$04
          BNE     NEWVDIR                ;GOING UP

NOTTOP    LDX     #SPDROBJ
          LDY     #$FF
          LDA     OBJOFFST,X
          AND     #$20
          JSR     OVRLAP2               ;ALREADY GOING RIGHT WAY -- DO WE HIT
          BCC     SPIDSHTR               ;   CENTIPEDE?

NEWVDIR   LDA     SPDRSTAT               ;FLIP V DIR.
          EOR     #$04
          STA     SPDRSTAT

* CHECK FOR COLLISION WITH PLAYER
SPIDSHTR  LDX     #SPDROBJ
          JSR     SHTRCOLL
          RTS
