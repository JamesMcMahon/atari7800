*** FLEA.S ***

* SMD     8/8     ATTRACT MODE CORRECTED
* DVP     7/6     SCORPION MOVEMENT ADDED
* DVP     6/29    FLEA MOVEMENT ROUTINE FOR CENTIPEDE

FLEASCRP
          LDA     ATTRACT
          BPL     NRMLFLEA
FLOUT     RTS

NRMLFLEA  LDA     SHTRTIMR
          BNE     FLOUT                  ;IF SHOOTER IS ALIVE
          LDA     FLEAOFST               ;MOVE IF ON SCREEN
          CMP     #L(EXPLOS)
          BCS     FLOUT
          BIT     FLEASTAT
          BPL     TRYFLEA
          BVS     MOVEFLEA
          JMP     MVSCORP

                                         ;OTHERWISE, DECIDE WHETHER TO START
TRYFLEA   LDX     PLAYER                 ;FIRST RACK?
          LDA     GAMETYPE
          CMP     #1
          BEQ     ZGMTPFL1
          LDX     #0
ZGMTPFL1  LDA     CHAINSIZ,X
          CMP     MAXSGCNT
          BCS     FLOUT                  ;YES

          LDX     PLAYER
          LDA     GAMETYPE
          CMP     #2
          BCC     ZGMTPFL4
          LDX     #2
          CMP     #3
          BEQ     ZGMTPFL4
          DEX                            ;X=1 HERE
          LDA     SCORE2+1               ;IN COMPETITION GAME, USE PLAYER WITH
          CMP     SCORE2                 ;   HIGHER SCORE
          BCS     ZGMTPFL4
          DEX                            ;X=0 HERE

ZGMTPFL4  LDA     SCORE2,X               ;DECIDE NUMBER OF MUSHROOMS IN INFIELD
          STA     GTEMP5
          LDY     #5                     ;  TO PREVENT FLEAS, MUST BE AT LEAST
          CMP     #$02                   ;  5 UP TO 20K
          BCC     ENOUGHM                ;  9 UP TO 120K
          LDY     #9                     ;  12 UP TO 140K
          CMP     #$12                   ;  13 UP TO 160K
          BCC     ENOUGHM                ;  14 UP TO 180K
          LSR     A                      ;  ONE MORE FOR EACH 20K
          CLC
          ADC     #6
          TAY

ENOUGHM   LDX     PLAYER                 ;ENOUGH MUSHROOMS?
          LDA     GAMETYPE
          CMP     #1
          BEQ     ZGMTPFL2
          LDX     #0
ZGMTPFL2  TYA
          CMP     MUSHCNT,X
          BCS     NEWFLEA
          JMP     TRYSCORP

NEWFLEA   LDA     #4                     ;FLEASND
          JSR     TUNIN
          JSR     RANDOM                 ;TIME FOR A NEW FLEA -- PICK A RANDOM
          AND     #$1F                   ; ROW
          BEQ     FLOUT
          CLC
          ADC     #MINX/4-1              ;ADJUST FOR LEFT MARGIN
          ASL     A
          ASL     A
          STA     FLEAX
          LDA     #$C1                   ;INITIALIZE OTHER FLEA VARIABLES
          STA     FLEASTAT
          LDA     #L(FLEA)
          STA     FLEAOFST
          LDA     #MINY
          STA     FLEAY

MOVEFLEA  LDA     FRMCNT                 ;CHANGE GRAPHICS EVERY 4TH FRAME
          LSR     A
          AND     #$06
          CLC
          ADC     #L(FLEA)
          STA     FLEAOFST

          LDA     #0
          LDX     DIFLEVEL
          BEQ     SLOWFLEA
          LDA     #2
          CPX     #3
          BEQ     SLOWFLEA               ;ALWAYS FAST IN EXPERT GAME
          LDA     FLEASTAT               ;MOVE DOWN SCREEN
          AND     #$03
SLOWFLEA  SEC                            ;1 PIXEL/FRAME, NOVICE GAME
          ADC     FLEAY
          CMP     #MAXY                  ;AT BOTTOM?
          BCS     ENDFLEA                ;YES
          STA     FLEAY

          LDX     #13                    ;CHECK FOR COLLISION WITH PLAYER
          JSR     SHTRCOLL
          LDA     SHTRTIMR
          BNE     FLEAOUT

          LDA     FRMCNT                 ;GENERATE A NEW MUSHROOM EVERY 4 FRAMES
          AND     #$03                   ; AT MOST
          BNE     FLEAOUT

          JSR     RANDOM                 ;GENERATE ONLY 1/4 OF THE TIMES ALLOWED
          AND     #$03
          BNE     FLEAOUT

                                         ;CHECK WHETHER MUSHROOM ALREADY THERE
          LDA     FLEAX
          STA     GTEMP1
          LDA     FLEAY
          CMP     #MAXY-ZONELEN
          BCS     FLEAOUT
;         CLC
          SBC     #3                     ;CHECK 4 PIXELS BEHIND FLEA
          JSR     OBSTAC
          BNE     FLEAOUT                ;MUSHROOM THERE
          LDA     FLEAY                  ;PLACE MUSHROOM 4 PIXELS BEHIND FLEA
          SEC
          SBC     #4
          JSR     MUSHER                 ;INCREMENTS COUNT IF IN INFIELD
FLEAOUT   RTS

ENDFLEA   LDA     #0
          STA     FLEAOFST
          STA     FLEASTAT
          LDA     #4
          JSR     SCRAPONE
          RTS

*** START A SCORPION RATHER THAN A FLEA
TRYSCORP
          LDA     FRMCNT                 ;EVERY N FRAMES
          CMP     #$93
          BNE     FLEAOUT

          LDX     PLAYER                 ;ONLY IN RACKS WITH SMALLER CENTIPEDES
          LDA     GAMETYPE
          CMP     #1
          BEQ     ZGMTPFL3
          LDX     #0
ZGMTPFL3  LDY     CHAINSIZ,X
          INY
          CPY     MAXSGCNT
          BCS     FLEAOUT

          JSR     RANDOM                 ;ONLY 1/4 OF THE TIME
          AND     #$03
          BNE     FLEAOUT

          LDA     #5
          JSR     TUNIN
                                         ;START A NEW SCORPION
          LDA     GTEMP5                 ;IF SCORE < 20K USE SLOW
          CMP     #2                     ;   (GTEMP5 SAVED IN TRYFLEA)
          BCC     SLOWSCRP

          JSR     RANDOM                 ;USE SLOW SCORPION 1/4 OF TIME
          AND     #$03                   ; RANDOMLY OVER 20K
          BEQ     SLOWSCRP

          LDA     #$82                   ;BIT 2 SET, 1 CLEAR = FAST
          BNE     SCRPRL

SLOWSCRP  LDA     #$80                   ;BIT 2 CLEAR, 1 SET = SLOW
SCRPRL    BIT     RNDM
          BPL     RGHTSCRP

LEFTSCRP  ORA     #$01                   ;BIT 0 SET FOR LEFT
          LDX     #MAXX
          BNE     SCRPDIR

RGHTSCRP  LDX     #MINX-SCRPWDTH
SCRPDIR   STX     FLEAX
          STA     FLEASTAT

          JSR     RANDOM                 ;PICK A VERTICAL POSITION
          AND     #$1F
          TAY
          LDA     SCRPROW,Y
          STA     FLEAY

***********       SCORPION MAIN ENTRY POINT

MVSCORP   LDA     FRMCNT                 ;CHANGE SCORPION ANIMATION EVERY 4
          LSR     A
          LSR     A
          AND     #$03
          TAX
          LDA     FLEASTAT
          LSR     A
          BCC     SANM1
          LDA     LSCRPANM,X
          BCS     SANM2
SANM1     LDA     RSCRPANM,X
SANM2     STA     FLEAOFST

SAMESCRP
          LDA     FLEASTAT               ;ADJUST SCORPION'S HORZ. POS.
          AND     #$03
          LSR     A                      ;CARRY SET = LEFT, CLEAR = RIGHT
          EOR     #$01                   ;CHECK SPEED (HOW OFTEN SHOULD SCORP.
          AND     FRMCNT                 ;   MOVE)?
          BNE     RSRSRS
          BCC     MVSCRPRT
          DEC     FLEAX                  ;CARRY SET, MOVE LEFT
          BCS     RSRSRS

MVSCRPRT  INC     FLEAX                  ;CARRY CLEAR, MOVE RIGHT

RSRSRS    LDA     FLEAX
          SEC
          SBC     #HORIZPOS-SCRPWDTH     ;EDGE DETECTION
          CMP     #MAXX-(HORIZPOS-SCRPWDTH-1)
          BCS     ENDSCRP

          LDA     FLEAX
          SEC                            ;CHECK WHETHER IN BOUNDARY FOR POISON
          SBC     #SCRPWDTH
          CMP     #MAXX-(SCRPWDTH+4)
          BCS     NOPOISON

          LDA     FLEAX
;;;;;     CLC
          ADC     #4
          STA     GTEMP1                 ;FOR OBSTAC SUBR.

          LDA     FLEAY                  ;TEST FOR MUSHROOM
;;;;;     CLC
          ADC     #4
          JSR     OBSTAC
          CMP     #L(QLIVE)
          BCC     NOPOISON
          CMP     #L(LIVE+1)
          BCS     NOPOISON
          ORA     #$08                   ;IT'S THERE, POISON IT
          STA     (GTEMP3),Y
NOPOISON  RTS

ENDSCRP   LDA     #0
          STA     FLEASTAT
          STA     FLEAOFST
          LDA     #5
          JSR     SCRAPONE
          RTS




SCRPROW   DB      12,20,28,36,44,52,60,68,76,84
          DB      12,20,28,36,44,52,60,68,76,84
          DB      12,20,28,36,44,52,60,68,76,84
          DB      12,84

LSCRPANM  DB      L(LSCRP),L(LSCRP+2),L(LSCRP+4),L(LSCRP+6)

RSCRPANM  DB      L(RSCRP),L(RSCRP+2),L(RSCRP+4),L(RSCRP+6)