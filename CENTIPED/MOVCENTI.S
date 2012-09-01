******************************************************************************
****      CENTIPEDE MOTION
****      SMD     7/15/83
******************************************************************************

MOVCENTI  LDA     NUMSEG
          BEQ     SEEYA                  ;IF NO LIVE SEGMENTS
          CMP     #1
          BNE     SKPSPDUP               ;IF NOT TIME TO SPEED UP LAST HEAD
          LDA     DIFLEVEL               ;DON'T SPEED UP LAST HEAD IN NOVICE GM
          BEQ     SKPSPDUP
          LDA     #0
          STA     SPDCTRL                ;SPEED UP LAST HEAD
SKPSPDUP  LDA     SHTRTIMR
          BNE     SEEYA                  ;IF THE SHOOTER IS DEAD
          LDA     DELAYSEG
          BEQ     NOSEGDLY               ;IF NO DELAY OCCURS BEFORE MOTION
          DEC     DELAYSEG               ;DECREMENT THE DELAY COUNTER
          BNE     ZDELAY
          LDA     #7                     ;TURN ON FEET SOUND
          JSR     TUNIN
ZDELAY    RTS

NOSEGDLY  LDX     #0
DOCENT    LDA     OBJSTAT,X
          BMI     SEGALIVE               ;IF SEGMENT ALIVE
          LDA     #0
          STA     GTEMP2
SEGSKIP   INX
          CPX     MAXSGCNT
          BNE     DOCENT                 ;IF MORE SEGMENTS LEFT
SEEYA     RTS                            ;IT'S BEEN FUN, BUT WE'RE DONE


SEGALIVE  LDA     OBJOFFST,X
          CMP     #L(EXPLOS)
          BCS     SEGSKIP
          JSR     SHTRCOLL               ;DID THIS SEGMENT HIT SHOOTER?
          LDA     SHTRTIMR
          BNE     SEEYA                  ;YES, SHOOTER DEAD
          LDA     OBJSTAT,X
          AND     #$10
          BNE     FASTSEG                ;IF THIS IS A FAST MOVING SEGMENT
          LDA     FRMCNT
          AND     SPDCTRL                ;SPDCTRL = 0 IF ONLY ONE SEGMENT LEFT
          BNE     SEGSKIP                ;IF NOT TIME TO MOVE A SLOW SEGMENT
FASTSEG   LDA     OBJSTAT,X
          AND     #$20
          BNE     SKPHMP1                ;IF SEGMENT IS NOT A HEAD
          JMP     NOTHEAD
SKPHMP1   LDA     #0
          STA     GTEMP2                 ;RESET TURN FLAG FROM PREVIOUS CHAIN
          LDA     OBJSTAT,X
          AND     #$03
          BEQ     SGNTTURN
          JMP     SEGTURN                ;IF HEAD IS IN THE PROCESS OF TURNING
SGNTTURN  LDA     OBJSTAT,X
          AND     #$40
          BEQ     SGNTPOIS               ;IF HEAD IS NOT POISONED
MAKETURN  LDA     OBJSTAT,X
          ORA     #$03
          STA     OBJSTAT,X              ;PUT HEAD IN STAGE 3 OF TURNING
          JMP     SEGTURN3               ;ALWAYS
SGNTPOIS  LDA     OBJOFFST,X             ;CHECK DIRECTION OF HEAD
          AND     #$04
          BNE     HDNGLEFT               ;IF HEAD IS HEADING LEFT
          LDA     OBJX,X
          CMP     CENTRGHT               ;135 IN GAME PLAY, 134 IN TITLE
          BCC     NOSGEDGE               ;IF OBJECT ISN'T ABOUT TO HIT RT. EDGE
SGATEDGE  LDA     OBJY,X
          CMP     #184
          BNE     MAKETURN               ;IF HEAD ISN'T ON BOTTOM ROW
          LDA     OBJSTAT,X
          AND     #$08
          BEQ     SKPBNCE2
BOUNC     LDA     OBJSTAT,X
          EOR     #$08
          STA     OBJSTAT,X
          LDA     OBJOFFST,X
          EOR     #$04
          STA     OBJOFFST,X
          JMP     XMOVESEG

SKPBNCE2  TXA
          TAY
          INY
          CPY     MAXSGCNT
          BEQ     MAKETURN               ;IF HEAD HAS NO BODY
          LDA     OBJSTAT,Y
          BPL     MAKETURN               ;"   "    "   "  "
          AND     #$20
          BNE     MAKETURN               ;"   "    "   "  "
NXTSGBCK  INY
          CPY     MAXSGCNT
          BEQ     SGBOUNCE               ;IF LAST LINK
          LDA     OBJSTAT,Y
          BPL     SGBOUNCE               ;IF END OF LAST CHAIN
          AND     #$20
          BEQ     NXTSGBCK               ;IF SEGMENT IS NOT A HEAD
SGBOUNCE  DEY
          LDA     OBJY,Y
          CMP     #184
          BNE     MAKETURN               ;IF TAIL IS NOT ON THE BOTTOM ROW
          LDA     OBJSTAT,Y
          EOR     #$28
          STA     OBJSTAT,Y              ;CONVERT IT TO A HEAD
          LDA     OBJOFFST,Y
          EOR     #$34
          STA     OBJOFFST,Y             ;REVERSE HIS DIRECTION, TOO
          BNE     MAKETURN               ;ALWAYS

HDNGLEFT  LDA     OBJX,X
          CMP     CENTLEFT               ;18 IN GAME PLAY, 19 IN TITLE PAGE
          BCC     SGATEDGE               ;IF HEAD IS ABOUT TO HIT LEFT EDGE
 ;        SEC
          SBC     #7

NOSGEDGE  CLC
          ADC     #5
          STA     GTEMP1
          LDA     OBJY,X
          BEQ     MAKETRN1
          JSR     COBSTAC                ;LOOK FOR COLLISION WITH A CHARACTER
          BEQ     NODETECT               ;IF NO COLLISION WAS FOUND
MDETCT    AND     #$FC                   ;CHECK FOR COLLISION W/POISONED MUSH
          CMP     #$4C
          BNE     MAKETRN1               ;IF NOT A POISONED SHROOM COLLISION
          LDA     OBJSTAT,X
          ORA     #$E7                   ;CHANGE HEAD TO A POISONED ONE
          STA     OBJSTAT,X
;         LDA     OBJOFFST,X             ;different graphics for poison heads
;         ORA     #$10                   ;   no longer exists
;         STA     OBJOFFST,X
          BNE     SEGTURN3               ;ALWAYS

NODETECT  JSR     OVRLAP                 ;LOOK FOR COLLISION WITH OTHER OBJECTS
          BCC     SEGANIM                ;IF NO COLLISION WAS DETECTED
MAKETRN1  LDA     OBJSTAT,X
          AND     #$08
          BNE     JMPBOUNC
          JMP     MAKETURN               ;ALWAYS
JMPBOUNC  LDA     OBJOFFST,X             ;BUMP IT OVER TWO PIXELS ON BOTTOM ROW
          AND     #$04
          BEQ     JMPBOUNL
          INC     OBJX,X
          INC     OBJX,X
          JMP     BOUNC
JMPBOUNL  DEC     OBJX,X
          DEC     OBJX,X
          JMP     BOUNC

NOTHEAD   LDA     OBJSTAT,X
          AND     #$03
          BNE     SEGTURN                ;IF SEGMENT IS CURRENTLY TURNING
          LDA     GTEMP2                 ;CHECK TURN FLAG FOR CHAIN
          BEQ     SEGANIM                ;IF NO TURN SHOULD COMMENCE
          LDA     #0
          STA     GTEMP2                 ;RESET TURN FLAG
          LDA     OBJSTAT,X
          ORA     #$03
          STA     OBJSTAT,X              ;MAKE OBJECT TURN ON NEXT MOTION PASS

SEGANIM   LDA     FRMCNT                 ;CHANGE CENTIPEDE ANIMATION
          AND     #$03
          BNE     XMOVESEG               ;IF NOT RIGHT FRAME TO CHANGE ANIM.
          LDA     OBJOFFST,X
          AND     #$03
          BNE     NOANMRST
          LDA     OBJOFFST,X
          ORA     #$03
          STA     OBJOFFST,X             ;RESET ANIMATION SEQUENCE
          BNE     XMOVESEG               ;ALWAYS
NOANMRST  DEC     OBJOFFST,X             ;NEXT ANIMATION IN SEQUENCE

XMOVESEG  LDA     OBJOFFST,X             ;MODIFY X POSITION OF CENTIPEDE
          AND     #$04
          BNE     SEGLEFT                ;IF SEGMENT IS GOING LEFT
          INC     OBJX,X                 ;MOVE RIGHT ONE PIXEL
          JMP     SEGSKIP                ;ALWAYS
SEGLEFT   DEC     OBJX,X                 ;MOVE LEFT ONE PIXEL
          JMP     SEGSKIP                ;ALWAYS

SEGTURN   CMP     #3
          BNE     SEGTURN2               ;IF NOT IN STAGE 3 OF TURNING
SEGTURN3  LDA     OBJSTAT,X              ;GET UP/DOWN BIT FROM STATUS
          AND     #$04
          LSR     A
          STA     GTEMP1                 ;SAVE IT FOR JUST A MOMENT
          LDA     OBJOFFST,X             ;CHANGE OFFSET TO APPROPRIATE STAMP
          ORA     #$0B
          AND     #$FD
          ORA     GTEMP1

STATCHNG  DEC     OBJSTAT,X              ;CHANGE TO NEXT TURNING STATE
YMOVESEG  STA     OBJOFFST,X             ;MODIFY CENTIPEDE'S Y POSITION
YMOVE2    AND     #$02
          BEQ     SEGUP                  ;IF SEGMENT IS MOVING UP
          LDA     OBJY,X
          CLC
          ADC     #2
          STA     OBJY,X                 ;MOVE SEGMENT DOWN TWO PIXELS
          BNE     XMOVESEG               ;ALWAYS

SEGUP     LDA     OBJY,X
          SEC
          SBC     #2
          STA     OBJY,X                 ;MOVE OBJECT UP TWO PIXELS
          BNE     XMOVESEG               ;ALWAYS

SEGTURN2  CMP     #2
          BNE     SEGTURN1               ;IF NOT IN STATE 2 OF TURNING
          LDA     OBJOFFST,X
          AND     #$FE                   ;CHANGE STAMP TO VERTICAL CENTIPEDE
          BNE     STATCHNG               ;ALWAYS

SEGTURN1  LDA     OBJOFFST,X
          AND     #$01
          BNE     FINALTRN               ;IF ON LAST STAGE OF TURN
          LDA     OBJOFFST,X
          EOR     #$05                   ;CHANGE STAMP
          BNE     YMOVESEG               ;ALWAYS

FINALTRN  LDY     OBJY,X
          LDA     ATTRACT
          BPL     SKPATTR2               ;IF NOT IN ATTRACT MODE
          CPY     #YBTMATTR+6
          BNE     SKPATTR2
          STA     GTEMP2
          LDA     #0
          STA     OBJSTAT,X
          DEC     NUMSEG
          JMP     SEGSKIP
SKPATTR2  LDA     OBJSTAT,X
          AND     #$04
          BNE     DWNWRDSG               ;IF SEGMENT IS TRAVELLING DOWN
          CPY     #146
          BEQ     CHNGUPDN               ;CHANGE VERTICAL DIRECTION
          BNE     NOREVRSE               ;ALWAYS
DWNWRDSG  CPY     #182
          BNE     NOREVRSE               ;IF NOT ON BOTTOM ROW
          LDA     OBJSTAT,X
          CMP     #$C0
          BCC     STRTNEWD               ;IF NOT POISONED
          EOR     #$41                   ;UNPOISON, MAKE VERT. DIR. = UP, AND
          STA     OBJSTAT,X              ;INITIALIZE START OF TURN
          LDA     OBJOFFST,X
          AND     #$E6
          STA     GTEMP2                 ;TURN FLAG FOR NEXT SEGMENT IN CHAIN
          BNE     STATCHNG               ;ALWAYS

STRTNEWD  AND     #$20
          BEQ     CHNGUPDN               ;IF OBJECT ON BOTTOM ISN'T A HEAD
          STA     NEWHDFLG
CHNGUPDN  LDA     OBJSTAT,X
          EOR     #$04                   ;CHANGE UP/DOWN BIT
          STA     OBJSTAT,X
NOREVRSE  LDY     #1                     ;NON-ZERO VALUE FOR TURN FLAG
SKIPFLAG  LDA     GTEMP2                 ;TURN FLAG FOR NEXT SEGEMENT IN CHAIN
          BEQ     NOQUIKTN               ;IF NO TURN IS TO BE DONE IMMEDIATELY
          LDA     OBJSTAT,X              ;CHANGE STATUS TO 'SEGMENT ABOUT TO
          CLC                            ;TURN' (AFTER IT IS DECREMENTED)
          ADC     #3
          STA     OBJSTAT,X
NOQUIKTN  STY     GTEMP2
          LDA     OBJOFFST-1,X
          AND     #$03
          STA     GTEMP6
          LDA     OBJOFFST,X
          TAY
          AND     #$F4
          ORA     GTEMP6
          STA     OBJOFFST,X
          DEC     OBJSTAT,X
          TYA
          JMP     YMOVE2                 ;ALWAYS

*********  OBJECT COLLISION DETECTION TO BE BUILT ON THIS SITE
OVRLAP    NOP
          LDY     #$FF
          LDA     OBJOFFST,X
          AND     #$04
OVRLAP2   BNE     STYGTMP3
          INY
STYGTMP3  STY     GTEMP3

          STX     GTEMP4

          LDY     #13
OVRLOOP   CPY     #12
          BEQ     OFFROW
          LDA     OBJY,Y                 ;IN SAME ROW?
          CMP     OBJY,X
          BNE     OFFROW

          LDA     OBJSTAT,Y              ;LIVE OBJECT?
          BPL     OFFROW
          LDA     OBJOFFST,Y
          CMP     #L(EXPLOS)
          BCS     OFFROW

          CPY     GTEMP4                 ;COMPARING WITH SELF?
          BEQ     OFFROW

          LDA     OBJX,X                 ;IN SAME COLUMN (ONLY LOOKING AHEAD)?
          SEC
          SBC     OBJX,Y
          EOR     GTEMP3
          CMP     #$FA
          BCS     FNDOVRLP

OFFROW    DEY
          BPL     OVRLOOP

NOVRLAP   CLC
          RTS

FNDOVRLP  CPX     #12                    ;DID WE TEST FOR SPIDER OVERLAPPING
          BCS     FOUNDOUT               ;   WITH CENTIPEDE?  JMP IF YES

          CPY     GTEMP4                 ;IS Y < X?  (IF SO, DIFFERENT CHAINS,
          BCC     FOUNDOUT               ;   SINCE X IS A HEAD)

SAMECHN   LDA     OBJSTAT,Y              ;ANY HEADS BETWEENS X AND Y?
          AND     #$20
          BNE     FOUNDOUT               ;IF SO, DIFFERENT CHAINS
          DEY
          CPY     GTEMP4
          BNE     SAMECHN
          BEQ     NOVRLAP                ;IF NOT, SAME CHAIN, NO OVERLAP

FOUNDOUT  SEC
          RTS

****************************************************************************
*********         NEWHD  --  ADD NEW HEADS
****************************************************************************

NEWHD     LDA     ATTRACT
          BMI     AUREVOIR               ;FRENCH FOR GOODBYE
          LDA     NEWHDFLG
          BEQ     AUREVOIR               ;IF NEW HEADS SHOULDN'T COME OUT YET
          LDA     SHTRTIMR
          BNE     AUREVOIR               ;IF SHOOTER IS EXPLODING
          LDA     NHDTIMER
          BEQ     LAUNCHED
          DEC     NHDTIMER
AUREVOIR  RTS

LAUNCHED  LDY     PLAYER
          LDA     GAMETYPE
          CMP     #1
          BEQ     ZGMTPMV1
          LDY     #0
ZGMTPMV1  LDX     MAXSGCNT
NEXTGUY   DEX
          BMI     AUREVOIR
          LDA     OBJSTAT,X
          BPL     CANDIDAT               ;FOUND A CANDIDATE TO MAKE A NEW HEAD
          BMI     NEXTGUY                ;ALWAYS

CANDIDAT  LDA     DIFLEVEL
          BNE     NHDFAST
          LDA     #$A4                   ;ALL NEW HEADS GO SLOW IN NOVICE GAME
          BNE     NHDSPD
NHDFAST   LDA     #$B4
NHDSPD    STA     OBJSTAT,X              ;OBJECT STATUS OF NEW HEAD
          LDA     #$63
          STA     OBJOFFST,X             ;OBJECT OFFSET
          LDA     #136
          STA     OBJY,X                 ;YPOS OF OBJECT
          LDA     #12
          STA     OBJX,X                 ;XPOS

          LDA     NHDCOUNT,Y
          CMP     #$60                   ;SHORTEST TIME (EXCEPT FROM SCORE)
          BCC     ZSKIPDC1
;;;;;     SEC
          SBC     #4
          STA     NHDCOUNT,Y
          LDA     DIFLEVEL
          BEQ     ZSKIPDC1
          LDA     NHDCOUNT,Y
          SEC                            ;SUBTRACT 8 FROM TIME IF STANDARD
          SBC     #4                     ;   DIFFICULTY GAME
          STA     NHDCOUNT,Y
ZSKIPDC1  LDA     NHDCOUNT,Y
          STA     NHDTIMER

          JSR     RANDOM
          BMI     ZNHDRGT                ;IF THE NEW HEAD SHOULD MOVE RIGHT
          LDA     #140
          STA     OBJX,X
          LDA     #$67
          STA     OBJOFFST,X
ZNHDRGT   INC     NUMSEG                 ;ONE MORE OF THESE CRITTERS NOW

          RTS
