*******************************************************************************
***********                                                         ***********
***********       TITLEPAG:  DRIVER FOR TITLE PAGE ANIMATION.       ***********
***********                  CONTROL STAYS IN THIS ROUTINE UNTIL    ***********
***********                  TITLE PAGE HAS COMPLETED.  A NEW GAME  ***********
***********                  IS THEN INITIALIZED FOR ATTRACT MODE,  ***********
***********                  UNLESS THE PLAYER HAS PUSHED RESET,    ***********
***********                  SELECT, OR THE JOYSTICK BUTTON.        ***********
***********                                                         ***********
*******************************************************************************
ATITLEPA
TITLEPAG
          JSR     SCRNOFF

          JSR     SETTITLE               ;LOAD TITLEPAG LOGO INTO BOTH DISPLAY
          LDA     DLSTPTR                ;  LISTS.
          EOR     #$40
          STA     DLSTPTR
          JSR     SETTITLE

          LDX     #NUMCREAT
TITLALL   LDA     TITLCDIR,X
          STA     CDIREC,X
          LDA     TITLCBOR,X
          STA     CBORDER,X
          LDA     #0
          STA     MONSTAT,X
          DEX
          BPL     TITLALL
          STA     L0Z0+1                 ;SCORE LINE...
          STA     IGNORE
          STA     TITLETIM

          LDX     #TOTLSTMP
TITLINIT  LDA     TITLYPOS,X
          STA     STMPYPOS,X
          LDA     TITLXPOS,X
          STA     STMPXPOS,X
          DEX
          BPL     TITLINIT

          LDX     #17
          JSR     TITLCOLR
          STA     P0C0SHAD+22

*         JSR     SCRNON

*********** THIS IS THE MAIN LOOP FOR TITLE PAGE:  IT UPDATES THE ANIMATION
***********       FOR THE BALLOONING DIGDUG, MOVES CREATURES AROUND ON SCREEN,
***********       AND EVENTUALLY STARTS ROCK FALLING SO CREATURES WILL BE
***********       CRUSHED.
TLOOP
          LDA     FRMCNT
          PHA

          INC     P0C0SHAD+27
          LDX     #10
          JSR     SETDPLH

          LDA     #1                     ;MOVE CREATURES ON SCREEN.
          STA     TCTEMP
          LDA     TITLETIM               ;ONLY UPDATE EVERY OTHER CYCLE.
          LSR     A
          BCS     TCRTS
          LSR     A
          BCS     TCRTS
          AND     #7
          PHA
          DEC     TCTEMP
          LDX     #NUMCREAT
CMOVLOOP
          LDA     MONSTAT,X
          BMI     NXTCMOVE
*         AND     #$C0
*         BNE     NXTCMOVE
          INC     TCTEMP                 ;WE HAVE A CREATURE...
          LDA     CDIREC,X
          LSR     A
          BCS     CLIMBUP
          TAY                            ;CREATURE IS MOVING LEFT OR RIGHT.
          LDA     POOKAX,X
*         CLC
          ADC     CWALK,Y
          STA     POOKAX,X
          CMP     #150
          BCC     CSTILL
          DEC     TCTEMP
          JSR     OFFSCR2                ;SUBR FOUND IN MONSTER FILE
*         LDA     #$80                   ;IT RETURNS A 0
*         STA     MONSTAT,X
*         ASL     A
*         STA     POOKAY,X
          BEQ     NXTCMOVE
CSTILL    TYA
          LSR     A
          PLA
          PHA
          PHP
          CPX     #4
          BCC     HPOOKA
          ADC     #RFYGAR-RPOOKA-1       ;WE HAVE A FYGAR.
HPOOKA    TAY
          PLP
          BCC     ACRLEFT
          LDA     LPOOKA,Y               ; LDA DOESN'T AFFECT CARRY
          BCS     ACRINDX
ACRLEFT   LDA     RPOOKA,Y
ACRINDX   STA     POOKAIX,X
          LDA     POOKAX,X
          CMP     CBORDER,X
          BNE     NXTCMOVE
          BEQ     NDIREC

CLIMBUP   INC     POOKAY,X
          PLA
          PHA
          CPX     #4
          BCC     UPOOKA
          ADC     #RFYGAR-RPOOKA-1       ;WE HAVE AN UP FYGAR.
UPOOKA    TAY
          LDA     LPOOKA,Y
          STA     POOKAIX,X
          LDA     POOKAY,X               ;CREATURE MOVING UP.
          CMP     CBORDER,X
          BNE     NXTCMOVE
NDIREC    INC     CDIREC,X               ;MOVE TO NEW DIRECTION.
          LDY     CDIREC,X
          LDA     CTURNS,Y
          STA     CBORDER,X

NXTCMOVE  DEX
          BPL     CMOVLOOP
          PLA

TCRTS     LDA     TCTEMP                 ;IF 0 UPON RETURN FROM TCMOVE,
          BEQ     TITLEDON               ;  CREATURES ALL WALKED OFF SCREEN.

          PLA
TWAITFRM  CMP     FRMCNT
          BEQ     TWAITFRM

          LDX     #NUMZONES
TITLLIST  LDA     TLISTSIZ,X
          STA     LISTSIZ,X
          DEX
          BPL     TITLLIST
          JSR     GENDPL2

*********** READ THE JOYSTICK BUTTON, RESET, AND SELECT:  SINCE THIS IS
***********       PRECISELY WHAT CHKSTATE DOES EVERY TIME THROUGH PLAYGAME
***********       LOOP IN MAIN, JUST CALL IT HERE.  IF ANY OF THE BUTTONS
***********       ARE PRESSED, WE WILL LEAVE ATTRACT MODE (AND THUS TITLE PAGE).

          JSR     CHKSTATE
          LDA     ATTRACT
          BEQ     TITLEND
          JMP     TLOOP

*********** WE FINISHED ANIMATION BUT WE'RE STILL IN ATTRACT MODE:  SET UP
***********       NEW SAMPLE GAME FOR CONTINUATION OF ATTRACT MODE.

TITLEDON
ATITLEDO  PLA
          JSR     SETRACK1               ;RETURNS 1 IN A.
**        LDA     #1                     ;BONZO
          JSR     HSCINIT
          TXA
          BNE     TRYTEDDY
          LDX     #L(HSCRAM)
          LDY     #H(HSCRAM)
          JSR     HSCATRCT
          JSR     HSCDISPL               ;DISPLAY HIGH SCORE FOR 10 SECONDS.
TRYTEDDY  LDA     #0                     ;PINEAPPLE MODE
          JSR     HSCINIT
          TXA
          BNE     ATTNOHSC
***       LDX     #L(HSCRAM)             ;X CONTAINS 0 ALREADY...
          LDY     #H(HSCRAM)
          JSR     HSCATRCT
          JSR     HSCDISPL
HSCSTOP   LDX     #1
ATTNOHSC  JMP     NEWAGAME               ;NEWAGAME IS A SUBR

BORE      SEC                            ;ALSO USED BY DDMOVE
          SBC     #36
BORE1     LSR     A
          TAY
          LDA     (DRTPTR),Y
          STA     DIRTMAP,X
TITLEND   RTS


TEMPLATE
          DB      TITLED10,$DC,CSET1,28,TITLEI10,$DE,CSET1,44
          DB      TITLEG10,$DC,CSET1,52,TITLED10,$DC,CSET1,84
          DB      TITLEU10,$DC,CSET1,100,TITLEG10,$DC,CSET1,116
          DB      TDDUG10,$9C,CSET1,68
          DB      0,0
          DB      LETRL,$7E,CSET2,38,LETRE,$7E,CSET2,46,LETRV,$7E,CSET2,54
          DB      LETRE,$7E,CSET2,62,LETRL,$7E,CSET2,70,PINEAPPL,$BE,CSET1,104
          DB      0,0
          DB      LETRS,$7E,CSET1,86
          DB      LETRP,$7E,CSET2,38,LETRL,$7E,CSET2,46,LETRA,$7E,CSET1,54
          DB      LETRY,$7E,CSET1,62,LETRE,$7E,CSET2,70,LETRR,$7E,CSET1,78
          DB      FULL0+2,$7E,CSET1,104
          DB      0,0
          DB      LETRG,$7E,CSET1,44,LETRA,$7E,CSET1,52,LETRM,$7E,CSET1,60
          DB      LETRE,$7E,CSET2,68,LETRO,$7E,CSET2,84,LETRV,$7E,CSET2,92
          DB      LETRE,$7E,CSET2,100,LETRR,$7E,CSET1,108
          DB      0,0
          DB      TITLED9,$DC,CSET1,28,TITLEI9,$DE,CSET1,44
          DB      TITLEG9,$DC,CSET1,52,TITLED9,$DC,CSET1,84
          DB      TITLEU9,$DC,CSET1,100,TITLEG9,$DC,CSET1,116
          DB      TDDUG9,$9C,CSET1,68
          DB      0,0
          DB      ATARICP,$3A,CSET1,36,NAMCOCP,$3A,CSET1,95,0,0

