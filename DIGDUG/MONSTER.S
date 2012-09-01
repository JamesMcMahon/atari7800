;   THIS FILE IS . . .                   MONSTER.S


;-------- DEFINITIONS

CHARDF    EQU     $1E                    ;*** MARIA 1 ($1E)
CHARD12   EQU     $24                    ;*** MARIA 1 ($24)
SETFLEE   EQU     $20

;-------- MONSTER MOVEMENT

MONSTERS  ASL     PROPORT                ;THIS GETS DONE ONCE PER FRAME
          BCC     ENDRATIO
          INC     PROPORT
ENDRATIO  LDA     ENTRY
          BNE     ENDTHIS
ZNXT113   JSR     PUMPER
          JSR     FRUITER
          JSR     FLAMER
          LDX     #$07                   TOP LEVEL MONSTER MOVEMENT ROUTINE
BRATS     JSR     MOVEMONS               -TO BE CALLED EVERY FRAME
          DEX
          BPL     BRATS

          LDA     SPEEDUP                ;TIME TO SPEEDUP?
          BNE     NOWFAST
          LDA     FAST                   ;NOT ALREADY FAST OR ESCAPING?
          ORA     ESCAPER
          BNE     NOWFAST
          LDA     #1                                                 !
          STA     FAST
          LDY     #SNG12                 ;SPEEDUP SOUND
          JSR     NOISE
;                                        SIMULTANEOUS SPEEDUP FROM HERE...
          LDX     #$07
PREV151   LDA     MONSTAT,X
          BMI     END151
          JSR     SPEEDER
END151    DEX
          BPL     PREV151
NOWFAST
          RTS

MOVEMONS  LDA     MONSTAT,X              X HOLDS MONSTER NUMBER
          BNE     ENDTHIS

CHKRATIO  LDA     DIR,X
          AND     #$0A                   ANY HORIZONTAL COMPONENT
          BEQ     THISVERT
*         JSR     DOOM
          LDA     PROPORT
          BPL     ENDTHIS

CHKSPEED  ASL     SPEEDL,X               IF SPEED SHIFT OUT IS ZERO
          ROL     SPEEDH,X               -THEN RETURN
          BCS     DISPCHAR               -THEN RETURN
ENDTHIS   RTS

THISVERT  ASL     SPEEDL,X
          ROL     SPEEDH,X
          BCC     ENDTHIS
SCRAT2    ASL     PROPORT2
          BCC     PREMOVE
          INC     PROPORT2

DISPCHAR  LDA     CHARSEQL,X             (DISPLAY CHARACTER)
          STA     TEMP1                  TEMP1 MUST BE ZERO PAGE
          LDA     #H(RPOOKA)
          STA     TEMP2                  TEMP2 MUST BE TEMP1+1
          LDY     CHARSEQN,X             INDEX INTO SEQUENCE
PREV1     LDA     (TEMP1),Y              ZERO PAGE INDIRECT ADDRESSING
          BNE     ZNXT50                  WHEN CHAR CODE=0 GO BACK TO
          TAY                            -BEGINNING OF CHAR SEQUENCE
          BEQ     PREV1
ZNXT50    INY                            GO TO ZNXT CHAR IN SEQUENCE
          STA     MONSI,X                UPDATE MONSTER INDEX ARRAY
          TYA                            USE A FOR ABS. INDEX STORE
          STA     CHARSEQN,X             SAVE CHARSEQ INDEX

PREMOVE   INC     SPEEDL,X
          LDY     DIR,X                  (MOVEMENT OF MONSTER)
          LDA     XTABLE,Y               TABLE OF VELOCITY VECTORS
          CLC                            -BASED UPON DIRECTION IN Y
          ADC     XPOS,X
          STA     XPOS,X                 (POSITION=POS+VELOCITY)
          LDA     YTABLE,Y
          CLC
          ADC     YPOS,X

          CMP     #192                   ;IF Y REQUEST IS OUT OF RANGE,
          BCS     FIXY                   ; DON'T ADJUST YPOS OR YMODC.
          CMP     #23                    ; I KNOW THIS IS AWFUL, BUT
          BCC     FIXY                   ; HOPEFULLY IT'LL NEVER HAPPEN, AND
;                                        ; AT LEAST THE SCORE WON'T BE WRECKED.

          STA     YPOS,X
          LDA     YTABLE,Y               UPDATE Y OFFSET COUNTER
          CLC                            -Y MOD C
          ADC     YMODC,X
          CMP     #$0C
          BNE     ZNXT69
          LDA     #$00
          BEQ     ZNXT12                 SAME AS JUMP
ZNXT69    CMP     #$FF
          BNE     ZNXT12
          LDA     #$0B
ZNXT12    STA     YMODC,X
FIXY      LDA     XPOS,X                 CHECK X GRID
          LDY     GHOST,X                CHECK IF GHOST
          BNE     DOGHOST
*         LDA     XPOS,X                 CHECK X GRID
          AND     #$07
          ORA     YMODC,X                CHECK Y GRID
          BNE     ENDTHIS                (RELATIVE JUMP OUT OF RANGE OTHERWISE)
          JMP     MOVEMODE               ONLY IF BOTH GRIDS ARE CENTERED

DOGHOST
*         LDA     XPOS,X                 CHECK X GRID
          AND     #$07
          BEQ     GHOSTONX
          LDA     YMODC,X                CHECK Y GRID
          BEQ     GHOSTONY
          RTS

GHOSTONX  JSR     GETDIRT
          CMP     #CHARD12
          BCS     JMODE
          CMP     #CHARDF                ;ALWAYS REMATERIALIZE ON SKY+FLOWERS
          BCS     ZNXT13
          STA     TEMP3
          TYA
          JSR     GHSTSUB2
*         SEC
*         SBC     #$10                   GET OTHER DIRT
*         TAY
*         LDA     DIRTMAP,Y
*         CMP     #CHARD12
          BCS     JMODE
          LSR     A                      SEE IF GHOST CAN APPEAR
          LSR     A
          ORA     TEMP3
          AND     #$02                   CHAR 1
          BNE     JMODE
          LSR     GHOST,X
          JSR     SPEEDER
          LDY     YMODC,X                IF GHOST APPEARS ON X AND Y
          BNE     ZNXT130
          JSR     GHSTSUB1
*         JSR     GETDIRT
*         STY     TEMP3
*         JSR     CHKOTHER
          LSR     A
          AND     #$04
          BEQ     ZNXT130
          STA     DIR,X                  HERE A = 4
JMODE     JMP     MODE
ZNXT130   LDA     #$05
          BPL     JMODE

GHOSTONY  JSR     GETDIRT
          CMP     #CHARD12
          BCS     JMODE
          CMP     #CHARDF                ;ALWAYS REMATERIALIZE ON SKY+FLOWERS
          BCS     ZNXT13
          STA     TEMP3
          INY                            GET OTHER DIRT
          LDA     DIRTMAP,Y
          CMP     #CHARD12
          BCS     JMODE
          LSR     A                      SEE IF GHOST CAN APPEAR
          LSR     A
          ORA     TEMP3
          AND     #$04                   CHAR 2
          BNE     JMODE
ZNXT13    LSR     GHOST,X
          JSR     SPEEDER
          LDA     #$0A
          BPL     JMODE

MOVECONT  JSR     GHSTSUB1
*         JSR     GETDIRT                A = DIRT CHAR, Y = DIRT ADDR.
*         STY     TEMP3                  NECESSARY FOR CHKOTHER CODE
*         JSR     CHKOTHER
*         AND     #$FE
          LSR     A
          TAY                            USE DIRT CHAR. AS INDEX INTO
          CMP     #$0F                   UPPER LIMIT OF DIRTABLE
          BCC     ZNXT51
          LDY     #$0F
ZNXT51    LDA     DIRTABLE,Y             GET LOW BYTE OF DIRTCODE ADDR.
          STA     TEMP1                  PUT IN ZERO PAGE FOR INDIRECT
          LDA     #H(DIRT0)
*         INY
*         LDA     DIRTABLE,Y             GET HIGH BYTE OF DIRTCODE ADDR.
          STA     TEMP2                  TEMP2 = TEMP1 + 1 (ZERO PAGE)
          JMP     (TEMP1)                JUMP TO DIRTCODE INDIRECTLY

;-------- FLAME DETERMINING CODE

MOVEMODE  JSR     MOVECONT
          LDA     MONSTAT,X              ; CREATURE COULD HAVE DIED
          BMI     FLAMOUT                ;    BY ESCAPING
          CPX     #$04                   ;FYGAR?
          BCC     FLAMOUT
          LDA     GHOST,X                ; LDA DOES NOT AFFECT CARRY
          BNE     FLAMOUT
          LDA     DIR,X                  ; LDA DOES NOT AFFECT CARRY
          AND     #$0A                   FLAME ONLY ON HORIZONTAL
          BEQ     FLAMOUT                ; AND DOES NOT AFFECT CARRY

*         LDA     SCNDTIM
*         BEQ     FLAMOUT                ;DON'T FLAME RIGHT AWAY
*         LDA     RACKTIME
*         AND     #$1F
*         CMP     #06
*         BCS     FLAMOUT

          LDA     FLAMTIME
*         CLC                            ; CARRY IS SET HERE
          ADC     #$0F                   FREQUENCY OF FLAMING
          STA     FLAMTIME
          BCC     FLAMOUT
          LDY     FLAMIE
          BNE     FLAMOUT
*G        LDA     #H(FLAMDET)
*G        PHA
*G        LDA     #L(FLAMDET)
*G        PHA
*G        JMP     MOVECONT
***       JSR     MOVECONT

FLAMDET   LDA     #ZBLANK
          STA     FLAMEIX
          INY
          STY     MONSTAT,X              ;FREEZE FYGAR
          JSR     SETFLAM
*         LDA     #$00
*         STA     FLAMSIZE               HERE A=0
*         LDA     #$E8                   THERE IS 16 CHAR SEQUENCE OF FYGAR
*         STA     FLAMNUM                -PRIOR TO FLAMING.
*         LDA     #$07
*         STA     FLAMWAIT
          STX     FLAMIE
          LDA     YPOS,X
          STA     FLAMEY
          LDA     XPOS,X
          CLC
          ADC     #$08
          STA     FLAMEX
;
;     NOTE: CODE FROM HERE THROUGH SKY15 LABEL MUST FALL ON SAME PAGE
;
DIRT5
DIRT10
FLAMOUT   RTS


;DIRTCODE                                 A = ALL POSSIBLE DIRECTIONS
DIRT0     JSR     NOREV                  -BASED UPON PRESENT DIRECTION
JJMODE    JMP     MODE                   -AND CURRENT DIRT CHARACTER
DIRT1     JSR     NOREV                  AT THIS POINT IN THE CODE,
          AND     #$0B                   -THE MONSTER IS CENTERED ON
          BPL     JJMODE                 -THE DIRT GRID (I.E. IMMEDIATELY
DIRT2     JSR     NOREV                  -ON TOP OF A DIRT CHARACTER)
          AND     #$07                   JUMP TO MODE DETERMINES THE
          BPL     JJMODE                 -MOVEMENT MODE (DESTINATION)
DIRT3     JSR     NOREV                  -OF THE MONSTER
          AND     #$03
          BPL     JGHOSTER
DIRT4     JSR     NOREV
          AND     #$0E
          BPL     JJMODE
*DIRT5     RTS                            ;SEE FLAMOUT
DIRT6     JSR     NOREV
          AND     #$06
          BPL     JGHOSTER
DIRT7     LDA     #$02
          BPL     JGHOSTER
DIRT8     JSR     NOREV
          AND     #$0D
          BPL     JJMODE
DIRT9     JSR     NOREV
          AND     #$09
          BPL     JGHOSTER
*DIRT10    RTS                            ;SEE FLAMOUT
DIRT11    LDA     #$01
          BPL     JGHOSTER
DIRT12    JSR     NOREV
          AND     #$0C
          BPL     JGHOSTER
DIRT13    LDA     #$08
          BPL     JGHOSTER
DIRT14    LDA     #$04
          BPL     JGHOSTER
SKY15
          JSR     SKYSUB
*         LDA     TEMP3
*         CLC                            GET DIRT UNDER POSITION
*         ADC     #$10
*         TAY
*         LDA     DIRTMAP,Y

          AND     #$E2                   NOT FULL AND NOT TOP EDGE!!!
          BEQ     ZNXT32
          LDA     #$01
ZNXT32    EOR     #$0B
          STA     TEMP1
          JSR     NOREV                  MAKE ALL POSSIBLE DIR.
          AND     TEMP1
          STA     TEMP1
          LDA     TEMP3                  MODE FOR INDEX $1E (CHAR $F)
          CMP     #$01
          BNE     ZNXT28
          LDA     TEMP1
          AND     #$FD                   BOUNCE OFF LEFT SCREEN
          JMP     MODE
ZNXT28    CMP     #$0E
          BNE     ZNXT29
          LDA     TEMP1
          AND     #$F7                   BOUNCE OFF RIGHT SCREEN
JGHOSTER  JMP     GHOSTER
ZNXT29    LDA     TEMP1
          JMP     MODE

NOREV     LDA     DIR,X                  (NO REVERSE)
          AND     #$0A                   TAKES DIRECTION AND GIVES A
          BEQ     ZNXT11                 -THE VALUE OF ALL POSSIBLE
          ORA     #$05                   -DIRECTIONS WITHOUT REVERSE
          RTS
ZNXT11    LDA     DIR,X
          ORA     #$0A
          RTS

;
;     NOTE:  DIGVERT THROUGH DIGDIAG MUST OCCUR ON THE SAME PAGE
;
;-------- MOVEMENT MODE CODE

*DIGVERT   JSR     SUB1                   ;WITH APOLOGIES TO GENE
*         LDY     #0
*         BPL     DIGPREF
*DIGHORIZ  JSR     SUB1
*         LDY     #5
*DIGPREF   STA     MTEMP
*DIGPREFL  LDA     DIGPREFA,Y
*         BEQ     DIGPREF2
*         AND     MTEMP
*         PHA
*         BNE     DIGPREF2
*         INY
*         BPL     DIGPREFL
*DIGPREF2  PLA
*         JMP     ZNXT23

*DIGPREFA  DB      1,4,2,8,0              ;VERT
*         DB      8,2,4,1,0              ;HORIZ

DIGVERT   JSR     SUB1                   (TO DIG-DUG VERTICAL PREFERENCE)
          TAY
          AND     #$01                   THIS IS VERTICAL PREFERENCE
          BNE     ZNXT17
          TYA
          AND     #$04
          BNE     ZNXT17
          TYA
          AND     #$02
          BNE     ZNXT17
          TYA
          AND     #$08
ZNXT17    BPL     ZNXT23                 SAVE NEW DIRECTION

DIGHORIZ  JSR     SUB1                   (TO DIG-DUG HORIZONTAL PREFERENCE)
          TAY
          AND     #$08                   THIS IS HORIZONTAL PREFERENCE
          BNE     ZNXT20
          TYA
          AND     #$02
          BNE     ZNXT20
          TYA
          AND     #$04
          BNE     ZNXT20
          TYA
          AND     #$01
ZNXT20    BPL     ZNXT23                 SAVE NEW DIRECTION

DIGDIAG   JSR     SUB1                   (TO DIG-DUG DIAGONAL PREFERENCE)
ESCONT    STA     TEMP3
          LDA     TEMP1                  THIS IS DIAGONAL PREFERENCE
          BPL     ZNXT24                 FROM HERE ...
          EOR     #$FF
          STA     TEMP1
ZNXT24    LDA     TEMP2
          BPL     ZNXT25
          EOR     #$FF
ZNXT25    CMP     TEMP1
          BCS     ZNXT26
          LDA     TEMP3
          AND     #$08                   HORIZONTAL IS GREATER
          BNE     ZNXT23
          LDA     TEMP3
          AND     #$02
          BNE     ZNXT23
ZNXT26    LDA     TEMP3
          AND     #$04                   VERTICAL IS GREATER
          BNE     ZNXT23
          LDA     TEMP3
          AND     #$01
          BNE     ZNXT23
          LDA     TEMP3
          AND     #$08                   TRY HORIZ. AGAIN
          BNE     ZNXT23
          LDA     TEMP3
          AND     #$02                   TO HERE.
ZNXT23    STA     DIR,X                  SAVE NEW DIRECTION
          JMP     NEWSEQ                 ;NEWSEQ IS A SUBR

OFFSCR    LDA     #$00
          STA     GHOST,X
          LDA     #$02
          STA     DIR,X
          JSR     NEWSEQ
          JSR     SPEEDER
          LDA     XPOS,X                 ;LAST CREATURE VANISHES
          BMI     OFFSCR2
          BNE     ZNXT112
OFFSCR2                                  ;CALLED AS SUBR BY BLOWUP,CHKDEATH
          LDA     #$80                   ;  AND TITLEPAG
          STA     MONSTAT,X
          ASL     A                      ;STOP DISPLAYING CREATURE
          STA     POOKAY,X               ;SUBR MUST RETURN A 0
ZNXT112   RTS

ESCAPE    STA     TEMP5                  (TO ESCAPE UPPER LEFT SCREEN)
          LDA     XPOS,X                 SET UP TEMPS FOR GETPOINT
          STA     TEMP1                  TEMP1 = X0
          LDA     #$10                   TEMP2 = X DESTINATION
          STA     TEMP2                  TEMP3 = Y0
          LDA     YPOS,X                 TEMP4 = Y DESTINATION
          STA     TEMP3
          LDA     #$BF                   UPPER LEFT SCREEN POS
          STA     TEMP4
          JSR     GETPOINT
          BNE     ZNXT111
SCRAM     LDA     #L(OFFSCR)
          STA     MODEL,X
          LDA     #H(OFFSCR)
          STA     MODEH,X
          BNE     OFFSCR

ZNXT111   LDY     GHOST,X                CHECK IF GHOST JUST USE POINTER
          BEQ     ZNXT41                 -FOR NEW DIRECTION
          STA     DIR,X
          AND     #$0A                   ;CORRECT FACING
          BEQ     ENDTHIS2
          STA     FACING,X
ENDTHIS2  RTS
ZNXT41    AND     TEMP5                  FOR NORMAL (NOT GHOST) USE
          BNE     ZNXT42                 -POINTER AND ALL POSSIBLE DIR.
          LDA     #$04                   ;GO NORTH
          LDY     POOKAY,X
          CPY     #$BF
          BCC     ZNXT41A
          LSR     A                      ;GO WEST YOUNG MONSTER
          LDY     POOKAX,X
          CPY     #$10
          BCS     ZNXT41B
          BCC     SCRAM                  ;CHANGE MODE TO OFF SCREEN
ZNXT41A   INC     GHOST,X                ;CALLED AS SUBR BY GOGHOST
ZNXT41B   STA     DIR,X
          JSR     NEWSEQ                 ;EXPECTS DIR IN A
          JMP     SPEEDER                ;SPEEDER IS A SUBR
ZNXT42    JMP     ESCONT

;-------- UTILITIES

GHOSTER   STA     TEMP1                  SEE IF IT'S TIME TO GHOST THEN
          JSR     NOREV
          EOR     #$0F
          STA     GHOSTTMP
          LDA     #L(ESCAPE)             ;THERE IS PROBABLY A NEATER WAY TO
          CMP     MODEL,X                ;    DO THIS...
          BEQ     GHOSTER3

*         LDA     SCNDTIM
*         BEQ     GHOSTER7
*         TXA
*         AND     #$01
*         EOR     RACKTIME
*         BEQ     GHOSTER7

          LDA     BONZO                  ;BONZO LEVEL IS ALWAYS RACK 1 LEVEL
          BNE     GHOSTER0
          LDY     PLAYNUM
          LDA     RACKNUM,Y
GHOSTER0
          ASL     A
*         ASL     A
*         AND     #$03
          CLC
          ADC     #$0A
          BCS     ZNXT9
          ADC     FLEE
          BCS     ZNXT9
          ADC     GHOSTIME
          BCS     ZNXT9
          STA     GHOSTIME

          LDA     DIGREST                ;MORE LIKELY TO GHOST IF DD NOT MOVING
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          CLC
          ADC     GHOSTIME
          BCS     ZNXT9
          STA     GHOSTIME
*         LDA     RACKTIME
*         BMI     GHOSTER7
*         CMP     GHOSTIME
*         BCS     GHOSTER7
*         AND     #$0A
*         BNE     ZNXT9
*         BCS     ZNXT9
GHOSTER7  LDY     GHOSTOUT
          BEQ     ZNXT9

*         STA     GHOSTIME
GHOSTER3  LDA     TEMP1
GHOSTER2  STA     DIR,X
          JSR     NEWSEQ
          LDA     #L(ESCAPE)             KLUDGE TO FORCE GHOSTING WHEN
          CMP     MODEL,X
          BNE     ENDTHIS2
          LDA     DIR,X
          JMP     MODE

ZNXT9
          STA     GHOSTIME
          LDA     #0
          STA     DIGREST
;                                        TO HERE.
ZNXT34    LDA     TEMP1                  ;WHERE I CAN GO
          JSR     SUB11                  ;CALC WHERE I WANT TO GO
;                                        ;SUB11 STORES TEMP1 IN TEMP5
          PHA
          LDY     TEMP5                  ;IS ONLY POSSIBLE DIR REVERSE?
          CPY     GHOSTTMP
          BEQ     GOGHOST
          AND     TEMP5                  ;TEMP5 IS NOW WHERE I CAN GO
          BNE     NOGHOST
GOGHOST   LDA     #4
          STA     GHOSTOUT
          PLA
          JMP     ZNXT41A
*         INC     GHOST,X
*         STA     DIR,X
*         JSR     NEWSEQ
*         JMP     SPEEDER                ;SPEEDER IS A SUBR
NOGHOST   PLA
          LDA     TEMP5
          JMP     GHOSTER2

*ZNXT34    INC     GHOSTOK
*         JMP     GHOSTER2
*ZNXT34    INC     GHOST,X
*         LDA     TEMP1
*         JSR     NEWSEQ
*         JSR     SPEEDER
*         LDA     TEMP1
*         JMP     MODE

NEWSEQ    AND     #$0A                   INPUT: A=DIR
          BEQ     SEQER                  MODIFIES: FACING AND CHAR SEQUENCE
          STA     FACING,X
SEQER     TXA                            TYPE OF MONSTER
          AND     #$04
          ORA     FACING,X               DIRECTION
          LSR     A
          EOR     GHOST,X                GHOST OR NOT
          TAY
          LDA     SEQTAB,Y
          STA     CHARSEQL,X

          TAY                            ; SET UP FIRST ANIMATION OF NEW SERIES
          LDA     $EE00,Y                ; ASSUME RPOOKA IS ON THIS PAGE
          STA     POOKAIX,X

          LDA     #$00
          STA     CHARSEQN,X
          RTS

MODE      LDY     MODEL,X                MODE JUMPS TO CODE FOR THE
          STY     TEMP1                  -MOVEMENT MODE OF THE MONSTER
          LDY     MODEH,X                -(IT'S DESTINATION)
          STY     TEMP2
          JMP     (TEMP1)

;-------- SUBROUTINES

SUB11
          STA     TEMP5                  SUBROUTINE FOR CRUNCHED CODE
          LDA     XPOS,X                 SET UP TEMPS FOR GETPOINT
          STA     TEMP1                  TEMP1 = X0
          LDA     DDXPOS                 TEMP2 = X DESTINATION
          STA     TEMP2                  TEMP3 = Y0
          LDA     YPOS,X                 TEMP4 = Y DESTINATION
          STA     TEMP3
          LDA     DDYPOS
          STA     TEMP4
          JMP     GETPOINT               ;CALC WHERE YOU WANT TO GO
*         RTS                            ;GETPOINT IS A SUBR

SUB1      JSR     SUB11
          LDY     GHOST,X                CHECK IF GHOST JUST USE POINTER
          BEQ     ZNXT14                 -FOR NEW DIRECTION
          STA     DIR,X
          AND     #$0A
          BEQ     SUB1A
          STA     FACING,X
SUB1A     PLA                            REMOVE THE LAST CALL TO SUB1
          PLA
          RTS
ZNXT14    AND     TEMP5                  FOR NORMAL (NOT GHOST) USE
          BNE     ZNXT16                 -POINTER AND ALL POSSIBLE DIR.
          LDA     TEMP5
ZNXT16    RTS

AVOID     LDX     #$07
PREV47    LDA     MONSTAT,X              ;ENABLED?
          BMI     ZNXT108
          LDA     GHOST,X
          BNE     ZNXT108                ;NOT A GHOST?
          LDA     DIR,X
          CMP     #$04                   ;HEADED NORTH?
          BNE     ZNXT108
          LDA     YMODC,X                ;NOT IN BOTTOM 3 PIXELS OF TUNNEL?
          CMP     #$03
          BCC     ZNXT108
          LDA     ESCAPER
          BNE     ZNXT108
          LDA     #L(DIGVERT)            ;RESTORED WHEN ROCK IS DONE FALLING
          STA     MODEL,X
*         BEQ     ZNXT108                DO NOT GO DOWN IF AT BOTTOM OF TUNNEL
*         JSR     GETDIRT
*         STY     TEMP3
*         JMP     ZNXT108                TAKE THIS OUT . . .
*         JSR     CHKOTHER
*         AND     #$08
*         BNE     ZNXT108
ZNXT140   LDA     #$01                   ;GO SOUTH
          STA     DIR,X
ZNXT108   DEX
          BPL     PREV47
          RTS

FRUITER   LDA     FRUIT
          BEQ     FRUITOUT
          TAY
          LDA     RACKTIME
          LSR     A
          BCC     FRUITOUT
          TYA
          INC     FRUIT
          CMP     #$C0                   TIME WAIT TIL REMOVAL OF FRUIT
          BEQ     RFRUIT
          CMP     #$0E                   TIME WAIT TIL DISPLAY OF FRUIT
          BNE     FRUITOUT               -APPROX 2 SEC.
DFRUIT    LDY     #0
          CPY     BONZO                  ;BONZO MODE?
          BNE     ZNXT98
DFRUIT2   LDX     PLAYNUM
          LDY     RACKNUM,X
          CPY     #$12                   RACK NO. WHERE FRUIT REPEATS ...
          BCC     ZNXT98
          LDY     #$12                   VALUE OF HIGHEST FRUIT
ZNXT98    LDA     FRUITAB,Y
          STA     FRUITIX
          LDA     #56
          STA     FRUITX
          LDA     #107
          BPL     RFRUIT2
RFRUIT    LDA     #$00
          STA     FRUIT
RFRUIT2   STA     FRUITY
FRUITOUT  RTS

*WHNSPEED  DB      2,3,4,5,6             ;MOVED TO ARRAYS
GETMODE   LDX     #$07                   TO BE CALLED BY CREATURE DEATH
          LDY     #$00                   -AND INITIALIZATION ROUTINE
DIGMODE   LDA     MONSTAT,X              ; ALSO CALLED BY FALL IF ESCAPER
          BMI     ZNXT35                 ;  IS NOT SET IN ORDER TO RESTORE
          LDA     MODETAB,Y              ;  MODES DESTROYED BY AVOID
          STA     MODEL,X
          LDA     #H(DIGVERT)
*         INY
*         LDA     MODETAB,Y
          STA     MODEH,X
          INY
ZNXT35    DEX
          BPL     DIGMODE
*         DEY
          DEY
          BEQ     ESCMODE
          LDA     FAST
          BNE     ENDTHIS3               ;ALREADY FAST
          LDA     SPEEDUP
          CMP     #3
          BCC     ENDTHIS3
*         INY                            ;CREATURES LEFT
          LDA     BONZO
          BNE     TEDSPED
          LDX     PLAYNUM
          LDA     RACKNUM,X
*         CMP     #24                    ;WHEN RACK IS GE 24, SPEEDUP IS SET
*         BCS     ENDTHIS3               ; TO 2 IN INCREATS
TEDSPED   CMP     #4
          BCC     ENDTHIS3
          LSR     A
          LSR     A
          TAX
*         DEX                            ;!
          TYA
          CMP     WHNSPEED-1,X
          BCS     ENDTHIS3
          LDA     #1
          STA     SPEEDUP
          RTS
ESCMODE   LDX     #$08
PREV2     DEX
          LDA     MONSTAT,X
          TAY
          BMI     PREV2
          AND     #$40                   ;NO ESCAPE MUSIC IF LAST CR SQUASHING
          BNE     NOESCMUS
          TYA
          AND     #$06                   ;NO ESCAPE MUSIC IF LAST CR GBNF
          CMP     #$02
          BEQ     NOESCMUS
          LDY     #SNG9                  ESCAPING NOISE
          JSR     NOISE
NOESCMUS  LDA     #L(ESCAPE)
          STA     MODEL,X
          LDA     #H(ESCAPE)
          STA     MODEH,X
          INC     ESCAPER
*         LDA     #1
*         STA     FAST
*         JMP     SPEEDER                ;SPEEDER IS A SUBR

SPEEDER   TXA                            MODIFIES MONSTER SPEED BASED UPON
          AND     #$04                   -FAST OR NOT, GHOST AND TYPE
          ORA     GHOST,X
          LSR     A
          ORA     FAST
          ROL     A
          ASL     A                      FOR 16 BIT VERSION
          TAY
          LDA     SPEEDTAB,Y
          STA     SPEEDH,X
*         INY
          LDA     SPEEDTAB+1,Y
          STA     SPEEDL,X
ENDTHIS3  RTS

CHKOTHER  STA     TEMP2                  CHECKS ALL POSSIBLE ADJACENT
          LSR     TEMP2                  MAKES DIRT INDEX = DIRT CHAR
CHKUP     LSR     TEMP2
          BCS     CHKRIGHT
          STA     TEMP1
          LDA     TEMP3
          JSR     GHSTSUB2
*         SEC
*         SBC     #$10
*         TAY
*         LDA     DIRTMAP,Y              MODIFIES ALL POSSIBLE DIRECTIONS
*         CMP     #CHARD12               -AFTER CHECKING ADJACENT DIRT
          BCC     OUTUP
          LDA     #$02                   NO UP TURN
          ORA     TEMP1
          STA     TEMP1
OUTUP     LDA     TEMP1
CHKRIGHT  LSR     TEMP2
          BCS     CHKDOWN
          STA     TEMP1
          LDY     TEMP3
          INY
          LDA     DIRTMAP,Y              MODIFIES ALL POSSIBLE DIRECTIONS
          CMP     #CHARD12               -AFTER CHECKING ADJACENT DIRT
          BCC     OUTRIGHT
          LDA     #$04                   NO RIGHT TURN
          ORA     TEMP1
          STA     TEMP1
OUTRIGHT  LDA     TEMP1
CHKDOWN   LSR     TEMP2                  -HALF DIRTS
          BCS     CHKLEFT
          STA     TEMP1
          JSR     SKYSUB
*         LDA     TEMP3
*         CLC
*         ADC     #$10
*         TAY
*         LDA     DIRTMAP,Y              MODIFIES ALL POSSIBLE DIRECTIONS

          CMP     #CHARD12               -AFTER CHECKING ADJACENT DIRT
          BCC     OUTDOWN
          LDA     #$08                   NO DOWN TURN
          ORA     TEMP1
          STA     TEMP1
OUTDOWN   LDA     TEMP1
CHKLEFT   LSR     TEMP2
          BCS     CHKOUT
          STA     TEMP1
          LDY     TEMP3
          DEY
          LDA     DIRTMAP,Y              MODIFIES ALL POSSIBLE DIRECTIONS
          CMP     #CHARD12               -AFTER CHECKING ADJACENT DIRT
          BCC     OUTLEFT
          LDA     #$10                   NO LEFT TURN
          ORA     TEMP1
          STA     TEMP1
OUTLEFT   LDA     TEMP1
CHKOUT    RTS

GETPOINT  LDY     #$00                   USES TEMP1 - TEMP4, A, Y
          LDA     TEMP1                  TEMP1 = X0
          SEC                            TEMP2 = X DESTINATION
          SBC     TEMP2                  TEMP3 = Y0
          STA     TEMP1                  ; FOR DIAG INFO
          BEQ     VERTICAL               TEMP4 = Y DESTINATION
          BCS     LEFT                   A WILL HOLD THE POINTER
RIGHT     TYA                            NOTE: THE POINTER WILL BE
          ORA     #$08                   -AT MOST TWO BITS ON
          TAY
          BNE     VERTICAL
LEFT      TYA
          ORA     #$02
          TAY
VERTICAL  LDA     TEMP3
          SEC
          SBC     TEMP4
          STA     TEMP2                  ; FOR DIAG INFO
          BEQ     DONEPNT
          BCS     DOWN
UP        TYA
          ORA     #$04
          TAY
          RTS
DOWN      TYA
          ORA     #$01
          TAY
DONEPNT   TYA
          RTS

GETDIRT   LDA     XPOS,X                 RETURNS DIRT, A = CHAR, Y = ADDR.
GETX      LSR     A                      (GET DIRT CHARACTER)
          LSR     A
          LSR     A
          STA     TEMP1                  PUT X VALUE IN TEMP1 (ZERO PAGE)
GETY      LDA     YPOS,X                 GET Y POSITION
          SEC
*         SBC     YMODC,X                MAKE Y POSITION CENTERED IF IT'S NOT
          SBC     #$0B                   -CENTER TO GRID BECAUSE OF 11 OFFSET
          LSR     A                      DIVIDE BY 4
          LSR     A
          TAY
          LDA     DIV3TAB,Y
          EOR     #$0F                   DIRT ADDR. IS F - Y ADDR.
GETCHAR   ASL     A                      MOVE Y ADDR. TO LEFT NIBBLE
          ASL     A                      -OF A
          ASL     A
          ASL     A
          ORA     TEMP1                  MERGE X ADDR. WITH Y ADDR.
          TAY                            PUT DIRT ADDR. IN Y INDEX
          LDA     DIRTMAP,Y              GET DIRT CHARACTER FROM MAP
          RTS

*GHSTSUB2  SEC                            ;USED BY GHOSTONX AND CHKOTHER
*         SBC     #$10                    ;MOVED TO INITDIRT
*         TAY
*         LDA     DIRTMAP,Y
*         CMP     #CHARD12
*         RTS

;-------- FLAME DRIVER CODE

FLAMER    LDX     FLAMIE
          BEQ     ENDFLAM
          LDA     FLAMNUM
          BEQ     SNDFLAME               JUST BEFORE DRAWFLAM
          BPL     DRAWFLAM
          INC     FLAMNUM
          EOR     #$FF                   ; FLAP YOUR WINGS AND SMILE
          AND     #$0F
          LSR     A
          LSR     A
          STA     TEMP1
          LDA     FACING,X
          LSR     A
          LSR     A
          LDA     TEMP1
          ROL     A
          TAY
          LDA     FLAMTABL,Y             SEQUENCE FOR FLAMING FYGAR
          STA     MONSI,X                <--- 
ENDFLAM   RTS

SNDFLAME                                 ;SOUND AND LENGTH CALC DONE ONCE A FLAM
          JSR     GETDIRT                WE NEED Y (ADDRESS OF DIRT)
*         TXA
*         PHA
          LDA     FACING,X
          LDX     #2
          AND     #$02
          BNE     FLAMLEFT
FLAMRIGT
FLMRLOOP  INC     FLAMSIZE
          INY
          LDA     DIRTMAP,Y
          CMP     #CHARD12
          BCS     FLAMOUT0
          DEX
          BPL     FLMRLOOP
          INC     FLAMSIZE
          BNE     FLAMOUT0               SAME AS JMP FLAMOUT
FLAMLEFT  DEC     FLAMSIZE
FLMLLOOP  DEC     FLAMSIZE
          DEY
          LDA     DIRTMAP,Y
          CMP     #CHARD12
          BCS     FLAMOUT0
          DEX
          BPL     FLMLLOOP
          DEC     FLAMSIZE
FLAMOUT0
*         PLA
*         TAX
          LDX     FLAMIE

          LDY     #SNG3                  FLAME SOUND
          JSR     NOISE
DRAWFLAM  LDA     FLAMSIZE
          BPL     DRAWR
DRAWL     EOR     #$FF
          CMP     FLAMNUM
          BEQ     FLAMOUT2
          LDY     FLAMNUM
          LDA     XPOS,X
          SEC
          SBC     FLAMPOS,Y
          STA     FLAMEX
          LDA     LFLAMSEQ,Y
          BNE     DRAWR2
*         STA     FLAMEIX
*         INC     FLAMNUM
*         JMP     FLAMCOLL               ;FLAMCOLL IS A SUBR
DRAWR     CMP     FLAMNUM
          BEQ     FLAMOUT2
          LDY     FLAMNUM
          LDA     RFLAMSEQ,Y
DRAWR2    STA     FLAMEIX
          INC     FLAMNUM
DRAWR4    JMP     FLAMCOLL               ;FLAMCOLL IS A SUBR
FLAMOUT2  DEC     FLAMWAIT
          BNE     DRAWR4                 ;TWEAK THIS
          LDA     #ZBLANK
          STA     FLAMEIX
          LDA     PROPORT
          BMI     FLAMOUT4
SETFLAM   LDA     #0                     ;CALLED AS SUBR BY FLAMDET
          STA     FLAMSIZE
          LDA     #$E8
          STA     FLAMNUM
          LDA     #$07
          STA     FLAMWAIT
          RTS
FLAMOUT4  LDA     #$00                   ;CALLED AS SUBR BY PUMPCOLL
          STA     FLAMEY
          STA     FLAMIE
          STA     MONSTAT,X
          RTS




