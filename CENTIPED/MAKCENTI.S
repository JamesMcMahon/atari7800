******************************************************************************
*****     CREATE A CENTIPEDE             CHAIN IN COLUMN 15, LINKS ELSEWHERE
*****     SMD     7/15
******************************************************************************

* SMD     8/1     ADDED ATTRACT MODE ROUTINE

SEGSPDDD  EQU     NLOOPS

MAKCENTI  LDY     PLAYER                 ;GAME PLAY STUFF
          LDA     GAMETYPE
          CMP     #1
          BEQ     ZMAKCNT1
          LDY     #0

ZMAKCNT1  LDA     CHAINSIZ,Y
          STA     GTEMP5
          LDA     #0
          LDX     DIFLEVEL
          BEQ     CHNSLOW                ;ALWAYS SLOW CENTIPEDE IN NOVICE GAME
          LDA     #$10
          CPX     #3
          BEQ     CHNSLOW                ;ALWAYS FAST CNTPD IN XPRT GM
          LDA     FASTWAVE,Y
CHNSLOW   ORA     #$84
          STA     SEGSPDDD
          LDA     NHDCOUNT,Y
          STA     NHDTIMER               ;HOW OFTEN NEW HEADS APPEAR
          LDA     #CNTRCLMN
          STA     GTEMP2                 ;XPOS OF SEGMENT
          LDA     #0
          STA     GTEMP4                 ;YPOS OF SEGMENT
          STA     NEWHDFLG               ;RESET NEW HEAD INDICATOR
          LDA     #1
          STA     SPDCTRL                ;UNDO SLOWING DOWN OF LAST HEAD

          LDA     ATTRACT
          BPL     MKCNT
          LDA     MAXSGCNT
          STA     GTEMP5                 ;CHAINSIZ
          LDA     #ATTRYBSE-8
          STA     GTEMP4                 ;YPOS
          LDA     #$94
          STA     SEGSPDDD

MKCNT     LDA     #4
          STA     GTEMP3                 ;XPOS DIFFERENCE BETWEEN SEGMENTS
          LDA     #$57
          STA     GTEMP1                 ;LOW BYTE OF STAMP ADDRESS
          JSR     RANDOM
          BMI     SEGCREAT               ;IF SEGMENTS WILL START MOVING RIGHT
          LDA     #-4                    ;SEGMENTS WILL START MOVING LEFT
          STA     GTEMP3
          LDA     #$53
          STA     GTEMP1                 ;FACE SEGMENT TO THE LEFT

******************************************
* CREATE CHAIN
******************************************
SEGCREAT  LDX     #0
SEGCRELP  LDA     GTEMP2                 ;CREATE ENTRY IN OBJECT TABLE FOR EACH
          STA     OBJX,X                 ;SEGMENT IN THE CHAIN
          CLC
          ADC     GTEMP3
          STA     GTEMP2                 ;UPDATE XPOS FOR NEXT SEGMENT
          LDA     GTEMP4
          STA     OBJY,X                 ;YPOS
          LDA     SEGSPDDD
          STA     OBJSTAT,X              ;STATUS = LIVE SEG. MOVING DOWN
          LDA     GTEMP1
          STA     OBJOFFST,X             ;LOW BYTE STAMP ADDRESS
          INX
          CPX     GTEMP5
          BNE     SEGCRELP               ;IF MORE SEGMENTR IN CHAIN

          LDA     OBJOFFST               ;CONVERT THE FIRST SEGMENT INTO A
          EOR     #$30                   ;TURNING HEAD
          STA     OBJOFFST
          LDA     OBJSTAT
          ORA     #$23
          STA     OBJSTAT

          LDX     GTEMP5
          CPX     MAXSGCNT
          BEQ     NOLINKS                ;IF NO INDIVIDUAL LINKS ARE NEEDED
          LDA     #0
          STA     CLMNUSED
          STA     CLMNUSED+1
          STA     CLMNUSED+2
          STA     CLMNUSED+3
          LDA     FRMCNT
          STA     GTEMP5                 ;DIFFERENT USAGE OF GTEMP5 FROM ABOVE!!

******************************************
* CREATE INDIVIDUAL SEGMENTS
******************************************
MAKELINK  LDA     GTEMP5
          EOR     OBJX,X
          JSR     RANDOM2                ;GET COLUMN # (0 - 14, 16 - 30)
          STA     GTEMP5
CHKCLMN   AND     #$1F
          CMP     #31
          BEQ     MAKELINK               ;IF IT'S 31, TRY AGAIN
          CMP     #15
          BEQ     MAKELINK               ;IF IT'S 15, TRY AGAIN
          STA     GTEMP1                 ;SAVE THE COLUMN NUMBER
          AND     #$07                   ;ENSURE NO LINKS ARE IN THIS COLUMN
          TAY
          LDA     BITTABLE,Y
          STA     GTEMP2
          LDA     GTEMP1
          LSR     A
          LSR     A
          LSR     A
          TAY
          LDA     CLMNUSED,Y
          AND     GTEMP2
          BEQ     COLMNOK                ;IF OK FOR LINK TO GO IN THIS COLUMN
          LDA     GTEMP1                 ;TRY ANOTHER COLUMN INSTEAD
          CLC
          ADC     #3
          BPL     CHKCLMN                ;ALWAYS
COLMNOK   LDA     CLMNUSED,Y             ;MARK THIS COLUMN AS ALREADY USED
          ORA     GTEMP2
          STA     CLMNUSED,Y

          LDA     GTEMP1                 ;CREATE OBJ TABLE ENTRY FOR THE LINK
          CLC
          ADC     #4
          ASL     A
          ASL     A
          STA     OBJX,X                 ;XPOS OF LINK = (COL. # + 4) * 4
          LDA     GTEMP4
          STA     OBJY,X                 ;YPOS OF LINK = 0
          LDA     #$A7                   ;SLOW SEGMENT IN NOVICE GAME
          LDY     DIFLEVEL
          BEQ     INDVSLOW
          LDA     #$B7                   ;FAST IN OTHER GAMES
INDVSLOW  STA     OBJSTAT,X              ;STATUS = LIVE HEAD ABOUT TO TURN
          LDA     #$63
          BIT     GTEMP5                 ;SET V FLAG FOR LEFT/RIGHT DIRECTION
          BVS     RGHTLINK               ;IF LINK WILL MOVE RIGHT
          ORA     #$04
RGHTLINK  STA     OBJOFFST,X
          INX
          CPX     MAXSGCNT
          BNE     MAKELINK               ;IF MORE LINKS ARE TO BE MADE

NOLINKS   LDA     MAXSGCNT
          STA     NUMSEG                 ;CURRENT NUMBER OF LIVE SEGS
          LDA     #$60
          STA     DELAYSEG               ;DELAY START OF CENTIPEDE MOTION
          RTS
