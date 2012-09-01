*
*  MONSTER.S       BASIC MONSTER CODE FOR MS PAC-MAN
*

* SETMON, SET THE NEXT INTERUPT
SETMON
          LDA     RTLOCAL+1
          CLC
          ADC     #WAITMON
          STA     MONWAIT
          RTS

* MAIN LOOP FOR MONSTER ALGORITM, JUST CALL DOMONSTR WITH X=3->0
MONSTER   JSR     MONTUNE
          JSR     MONBEFOR
          CLC
          LDX     #3
MONSTRLP  JSR     MONLOOP                ; TOP OF MONSTER LOOP
          DEX
          BPL     MONSTRLP
          JMP     MONAFTER


*  MAKE SURE THE MONSTER TUNE IS PLAYING
MONTUNE   LDA     #$0A
          CMP     TUNINDEX               ;MAKE SURE IT ISN'T PLAYING
          BEQ     MTOUT
          CMP     TUNINDEX+1
          BEQ     MTOUT
          JSR     DOTUNE                 ;JUST TRY TO PUT IT OUT
MTOUT     RTS


* MONBEFOR        -STUFF AT TOP OF MONSTER LOOP
*

MONBEFOR  JSR     SETMON
          JSR     INCMSPED
          LDA     ISBLUE
          JSR     CHKBLUE                ;SEE IF TIME TO DO SOMETHING WITH BLUE
          LDA     BLUWAIT                ;DO NOT CHECK FOR REVERSAL IF BLUE
          BNE     MOREMON
NOTBLUE
          INC     NORMTIME+1
          BNE     CHKREV
          INC     NORMTIME
CHKREV
          LDA     NORMTIME
          CMP     REVWAIT
          BCC     MOREMON

          LDA     NORMTIME+1
          CMP     REVWAIT+1
          BCC     MOREMON

          LDA     REVWAIT
          CMP     #$FF
          BEQ     MOREMON

          JMP     MONFLIP

MOREMON
MONLPEND  RTS

* MONAFTER        -STUFF AT BOTTOM OF MONSTER LOOP
*

MONAFTER
          JSR     PMINTR
          JMP     RELEASE

* MONLOOP         - MONSTER PROCESSING LOOP
*         IN:     X IS THE MONSTER NUMBER
*         OUT:
*         USES:   EVERYTHING EXCEPT X

MONLOOP   JSR     CHKMON                 ; TOP OF MONSTER LOOP
          BEQ     MONLPEND               ;JUST AN RTS

          LDA     M0STATE,X              ; CHECK THE MONSTER STATE
          CMP     #MSTLVPEN
          BMI     MONSTR1
          JMP     MMVPEN                 ; IT'S IN THE PEN, SO SPCL CASE IT
MONSTR1
          LDA     M0OFF,X                ;MAKE SURE WE ARE AT THE CENTER
          CMP     #3
          BNE     MONSTRMV
          LDA     M0HPOS,X
          AND     #3
          CMP     #1
          BNE     MONSTRMV
          LDA     M0FLIP,X               ;SEE IF MONSTER IS TO BE FLIPPED
          BEQ     MONSTRZZ
          LDA     M0DIR,X
          EOR     #$02
          STA     M0DIR,X
          LDA     #$00
          STA     M0FLIP,X
          BEQ     MONSTRMV               ;DO NOT CHECK FOR TURN IF FLIPPED
MONSTRZZ  LDA     M0TUNNEL,X             ;SEE IF IN TUNNEL, IF SO JUST MOVE
          BNE     MONSTRMV
          JSR     MNCHKDIR               ; FIND OUT IF WE ARE AT INTERSECT
          CMP     #0
          BNE     MONSTRMV               ;IF WE ARE NOT, JUST MOVE
          JSR     MONNEWDR               ;GET NEW DIRECTION
MONSTRMV  JMP     MOVEMON                ; MOVE THE MONSTER

* WE NEED A NEW DIRECTION FOR THIS MONSTER
MONNEWDR  LDA     M0STATE,X              ;LOOK AT THE STATE AGAIN
          CMP     #MSTNORM
          BNE     MONSTR2
          LDA     M0BLUE,X               ; SEE IF IS IS BLUE
          BEQ     MONSTR3
          JMP     MMVBLUE
MONSTR3   LDA     BORED                  ; SEE IF IT'S BORED
          BEQ     MONSTR5
          JMP     MMVBORED
MONSTR5   JMP     MMVINTER               ; ELSE IT'S INTERESTED
MONSTR2   JMP     MMVEYES                ; IT'S EYES


* MMVBLUE         - BLUE MONSTER MOVEMENT
*         IN:     X IS MONSTER NUMBER, TEMP12-15 IS INTERSECTION STATE
*         OUT:
*         USE: EVERYTHING EXCEPT X

MMVBLUE   JSR     RAND
          AND     #3
          TAY
          LDA     TEMP12,Y
          BNE     MMVBLUE
          TYA
          STA     M0DIR,X
          RTS

* MMVEYES         - EYES MONSTER MOVEMENT
*         IN:     X IS MONSTER NUMBER, TEMP12-15 IS INTERSECTION STATE
*         OUT:
*         USE: EVERYTHING EXCEPT X

MMVEYES   LDA     #$0A
          STA     TEMP7
          LDA     #$0F
          STA     TEMP8
          JMP     STWHCHWY

* MMVBORED        - BORED MONSTER MOVEMENT
*         IN:     X CONTAINS MONSTER NUMBER, TEMP12-15 CONTAISN INTERSECT STATE
*         OUT:    M0DIR,X IS SET TO NEW DIRECTION
*         USES:   EVERYTHING EXCEPT X

MMVBORED  TXA
          CMP     #02
          BEQ     MMVBORD1
          BPL     MMVBORD2

MMVBORD3  JSR     RAND                   ; RED AND PINK
          AND     #3
          TAY
          LDA     TEMP12,Y
          BNE     MMVBORD3
          TYA
          STA     M0DIR,X
          RTS

MMVBORD1  LDA     #$1C
          STA     TEMP7
          LDA     #$1A
          STA     TEMP8
          JMP     MMVBORD4

MMVBORD2                                 ;GOLD
          LDA     #$1C
          STA     TEMP7
          LDA     #$01
          STA     TEMP8

MMVBORD4  JMP     STWHCHWY

* MMVINTER        - INTERESTED MONSTER MOVEMENT
*         IN:     X HAS MONSTER NUMBER, TEMP12-15 HAS INTERSECTION STATE
*         OUT:    M0DIR,X IS SET TO NEW DIRECTION
*         USED:   EVERYTHING EXCEPT X

MMVINTER  TXA
          CMP     #2
          BEQ     MMVINTR1
          BPL     MMVINTR3
          CMP     #1
          BEQ     MMVINTR2

          LDA     M0STATE+3              ;SEE IF GOLD GUY IN NORMAL STATE
          CMP     #MSTNORM               ;  IF NOT, RED GUY MOVES NORMAL
          BNE     REDSPD2
          LDA     #$F0
          SEC
          SBC     DOTSEATN
          CMP     REDTHRSH+1
          BCS     REDSPD1
          LDA     #SPDRED2
          STA     M0SPEED                ;RED GUY MOVING FASTEST
          JMP     REDSPD3
REDSPD1
          CMP     REDTHRSH
          BCS     REDSPD2
          LDA     #SPDRED1               ;RED GUY MOVING FASTER
          STA     M0SPEED
          JMP     REDSPD3
REDSPD2
          LDA     #SPDNORM               ;RED GUY MOVING NORMAL SPEED
          STA     M0SPEED
REDSPD3

          LDA     PZONE                  ; RED
          STA     TEMP7
          LDA     PCOL
          STA     TEMP8
          JMP     MMVINTR4

MMVINTR2
          LDY     PDIR                   ; PINK
          LDA     PZONE
          CLC
          ADC     DIROFFZ4,Y
          STA     TEMP7
          LDA     PCOL
          CLC
          ADC     DIROFFC4,Y
          STA     TEMP8
          JMP     MMVINTR4

MMVINTR1  LDY     PDIR                   ;BLUE - GOAL ON OTHER SIDE OF MS FROM R
          LDA     DIROFFZ2,Y             ;START WITH THE OFFSET TO LOOK AHEAD
          CLC
          ADC     PZONE                  ;ADD TO MS PAC'S ZONE
          ASL     A
          SEC
          SBC     M0ZONE                 ;SUBTRACT RED MONSTER'S ZONE
          STA     TEMP7                  ;= ADJ MS - (DELTA BETWEEN MS AND RED)
          LDA     DIROFFC2,Y             ;START WITH THE OFFSET TO LOOK AHEAD
          CLC
          ADC     PCOL                   ;ADD TO MS PAC'S COLUMN
          ASL     A
          SEC
          SBC     M0COL                  ;SUBTRACT RED MONSTER'S COLUMN
          STA     TEMP8                  ;= ADJ MS - (DELTA BETWEEN MS AND RED)
          JMP     MMVINTR4

MMVINTR3
          LDA     PZONE                  ; GOLD
          STA     TEMP7
          LDA     PCOL
          STA     TEMP8
          SEC
          SBC     M0COL,X
          STA     TEMP0
          BPL     GOLD1
          LDA     #0
          SEC
          SBC     TEMP0
GOLD1     STA     TEMP1                  ; TEMP1 = ABS(PCOL-MCOL)
          LDA     PZONE
          SEC
          SBC     M0ZONE,X
          STA     TEMP0
          BPL     GOLD2
          LDA     #0
          SEC
          SBC     TEMP0
GOLD2     CLC                            ; A = ABS(PZONE-MZONE)
          ADC     TEMP1
          CMP     #8                     ; IF ABS(PCOL-MCOL)+ABS(PZONE-MZONE)>8
          BPL     MMVINTR4
          LDA     #$15
          STA     TEMP7
          LDA     #$06
          STA     TEMP8
MMVINTR4  JMP     STWHCHWY

* STWHCHWY        - SET UP FOR MONSTER'S WHCHWAY CALL
*         IN:     MONSTER VALUE IN X, INTERSECTION STATE IN TEMP12-15
*         OUT:    ALL PARAMETERS FOR WHCHWAY EXCEPT GOALZONE AND GOALCOL
*         USES:   ALL EXCEPT X

STWHCHWY  LDA     M0ZONE,X
          STA     TEMP4
          LDA     M0COL,X
          STA     TEMP5
          LDA     M0DIR,X
          STA     TEMP6
          JSR     WHCHWAY
          STA     M0DIR,X
          RTS

* MMVPEN          - MONSTER PEN MOVEMENT STUFF
*         IN:     X IS MONSTER NUMBER
*         USE:

MMVPEN    LDA     M0SLOW,X               ;SLOW THEM DOWN IN PEN
          EOR     #$01
          STA     M0SLOW,X
          BNE     MMVPBODY
          RTS

MMVPBODY  LDA     M0STATE,X
          CMP     #MSTATPEN              ; SEE IF HE'S JUST HANGING ARROUND
          BNE     MMVPEN1

          LDA     M0VPOS,X               ; SEE WHERE IT IS
          CMP     #$48                    ; IF IT IS AT THE TOP
          BCS     MMVPEN4
          LDA     #DDOWN                 ; THEN MOVE IT DOWN
          STA     M0DIR,X
          JMP     MMVPEN3

MMVPEN4   CMP     #$4E                    ; IF ITS AT THE BOTTOM
          BCC     MMVPEN5
          LDA     #DUP                   ; THEM MOVE IT UP
          STA     M0DIR,X
MMVPEN5   JMP     MMVPEN3                ; THEN GET OUT

MMVPEN1   CMP     #MSTINPEN              ; SEE IF HE WANTS TO GET IN
          BNE     MMVPEN2

          LDA     M0VPOS,X               ; SEE IF ITS IN YET
          CMP     #$4E
          BCC     MMVPEN6
          LDA     HOMEDIR,X              ; MOVE IT TOWATRDS IT'S HOME SLOT
          STA     M0DIR,X
          LDA     M0HPOS,X
          CMP     IMHPOS,X
          BNE     MMVPEN6
          LDA     #MSTATPEN
          STA     M0STATE,X
          LDA     #DUP
          STA     M0DIR,X
          JSR     MONSTAMP               ;MAKE IT LOOK NORMAL
          TXA
          BNE     MMVPEN7
          JSR     GETOUT
MMVPEN7
          JMP     MMVPEN3

MMVPEN2                                  ; HE IS TRYING TO GET OUT
          LDA     M0HPOS,X
          CMP     #$37+LEFTSIDE
          BNE     MMVPEN6
          LDA     #DUP
          STA     M0DIR,X
          LDA     M0VPOS,X               ; SEE OF HE'S OUT YET
          CMP     #$3A                   ;SZY-4C????
          BCS     MMVPEN3

          LDA     #DLEFT                 ;SET IT'S DIRECTION
          LDY     M0BLUE,X
          BEQ     MMVPENDR
          LDA     #DRIGHT
MMVPENDR  STA     M0DIR,X
          LDA     #MSTNORM
          STA     M0STATE,X              ; IF HE IS THEN ALL IS BACK TO NORMAL

MMVPEN3
MMVPEN6

* MOVEMON         - MONSTER MOVEMENT STUFF
*         IN:     X IS MONSTER NUMBER
*         USE:

MOVEMON   JSR     ADJSTMON               ;FIRST, ADJUST THE POSITION

          LDA     M0TUNNEL,X
          BNE     MVTUNNEL               ;DIFFERENT CODE FOR TUNNEL MOVEMENT

          LDA     M0HPOS,X               ;SEE IF MOVING INTO TUNNEL
          CMP     #RGHTEDGE
          BCC     MVZZJMP0
          STA     M0TUNNEL,X
MVZZJMP0  CMP     #LEFTEDGE
          BCS     MVZZJMP1
          STA     M0TUNNEL,X

MVZZJMP1  JSR     DISPMON                ;UPDATE THE MONSTER DISPLAY
          JMP     CHKPEN

MVTUNNEL  LDA     M0DIR,X                ;MOVEMENT THROUGH TUNNEL
          BEQ     MVTRIGHT
          LDA     M0HPOS,X               ;MOVING LEFT
          CMP     #LEFTWRAP              ;SEE IF WRAP TIME
          BCS     MVTLJMP0
          CLC
          ADC     #WRAPSIZE
          STA     M0HPOS,X
MVTLJMP0  CMP     #RGHTEDGE
          BCS     MVTLJMP1
          CMP     #80
          BCC     MVTLJMP1
          LDA     #$00
          STA     M0TUNNEL,X
MVTLJMP1  JMP     WRTMON                 ;WRITE IT AND LEAVE

MVTRIGHT  LDA     M0HPOS,X               ;MOVING RIGHT
          CMP     #RGHTWRAP              ;SEE IF WRAP TIME
          BCC     MVTRJMP0
          SEC
          SBC     #WRAPSIZE
          STA     M0HPOS,X
MVTRJMP0  CMP     #LEFTEDGE
          BCC     MVTRJMP1
          CMP     #80
          BCS     MVTRJMP1
          LDA     #$00
          STA     M0TUNNEL,X
MVTRJMP1  JMP     WRTMON                 ;WRITE IT, THEN WE'RE DONE

*  ADJUST THE POSITION OF THE MONSTER
ADJSTMON  LDA     M0DISP,X               ;FIRST, ANIMATE THE MONSTER
          EOR     #$10
          STA     M0DISP,X

          LDY     M0DIR,X                ;NOW, MOVE IT
          LDA     M0HPOS,X
          JSR     HPOSADJ                ;ADJUST HORIZONTALLY
          STA     M0HPOS,X
          STX     TEMP0
          LDA     M0OFF,X
          STA     TEMP1
          LDA     M0VPOS,X
          LDX     TEMP1
          JSR     VPOSADJ                ;ADJUST VERTICALLY
          LDX     TEMP0
          STA     M0VPOS,X
          RTS

* SPECIAL CODE FOR GETTING EYES INTO PEN
CHKPEN
          LDA     M0STATE,X
          CMP     #MSTEYES
          BNE     MMOVEND               ; IF IT'S NOT EYES ITS NOT INTERESTED

          LDA     #$13                   ;SEE IF EYE TUNE PLAYING
          CMP     TUNINDEX
          BEQ     CPJMP0
          CMP     TUNINDEX+1
          BEQ     CPJMP0
          JSR     DOTUNE                 ;MAKE IT PLAY

CPJMP0    LDA     #$39                   ; NOW SEE IF ITS AT THE ENTRY POINT
          CMP     M0VPOS,X
          BNE     MMOVEND
          LDA     #$37+LEFTSIDE
          CMP     M0HPOS,X
          BNE     MMOVEND
          LDA     #MSTINPEN
          STA     M0STATE,X              ; IT IS NOW GOING INTO PEN
          LDA     #DDOWN
          STA     M0DIR,X

          LDA     M0STATE+0
          CMP     #MSTEYES
          BEQ     MMOVEND
          LDA     M0STATE+1
          CMP     #MSTEYES
          BEQ     MMOVEND
          LDA     M0STATE+2
          CMP     #MSTEYES
          BEQ     MMOVEND
          LDA     M0STATE+3
          CMP     #MSTEYES
          BEQ     MMOVEND
          LDA     #$13
          JSR     KILLTUNE

MMOVEND   RTS


*  THIS ROUTINE ADJUSTS THE CURRENT COLUMN, ZONE, AND OFFSET, THEN FALLS THROUGH
*  TO WRTMON
DISPMON   LDA     M0HPOS,X               ;ADJUST COLUMN
          JSR     HTOC
          STA     M0COL,X
          LDA     M0VPOS,X               ;ADJUST ZONE AND OFFSET
          JSR     VTOZO
          STA     M0OFF,X
          INY
          TYA
          STA     M0ZONE,X
                                         ;NOW - FALL THROUGH TO WRTMON

* WRTMON          - WRITE THE MONSTER ON THE SCREEN
*         IN      X IS MONSTER NUMBER
*         USES

WRTMON    LDA     M0HPOS,X               ;UPDATE HPOS
          SEC
          SBC     #3
          STA     HPLIST+2,X
          LDY     M0ZONE,X               ;UPDATE ZONE
          DEY
          TYA
          STA     VZLIST+2,X

          LDA     M0DISP,X               ;FIND WHICH STAMP TO USE
          AND     #$10                   ;FIRST, SET A TO 4 OR 0 DEPENDING
          LSR     A                      ;  ON WHICH ANIMATION CURRENTLY IN
          LSR     A
          ORA     M0DIR,X                ;SET BOTTOM BITS TO DIRECTION
          ORA     M0BLUE,X               ;NORMAL, BLUE, OR EYES
          TAY                            ;THIS IS OUR INDEX
          LDA     MONSTMPH,Y             ;SET THE STAMP
          STA     SHLIST+2,X
          LDA     MONSTMPL,Y
          STA     SLLIST+2,X

          LDA     #$01
          STA     DOLIST+2,X             ;TELL LOADER TO GET IT
          RTS


* EYESTAMP        - FILL IN STAMP FOR EYES
*         IN:     X IS MONSTER NUMBER
*         OUT:
*         USE:    TEMP0,Y

EYESTAMP  LDA     #$10                   ;SET 'M0BLUE' TO EYES
          STA     M0BLUE,X
          TXA
          ASL     A
          ASL     A
          TAY
          LDA     #WHITE                 ;ADJUST COLOR
          STA     P3C2,Y
          RTS

* BLUSTAMP        - FILL IN STAMP FOR BLUR MONSTERS
*         IN:     X IS MONSTER NUMBER
*         OUT:
*         USE:    TEMP0,Y

BLUSTAMP  LDA     #$08                   ;SET 'M0BLUE' TO BLUE
          STA     M0BLUE,X
          TXA
          ASL     A
          ASL     A
          TAY
          LDA     #DKBLUE                ;ADJUST COLOR
          STA     P3C1,Y
          LDA     #LTPINK
          STA     P3C2,Y
          RTS

* MONSTAMP        - FILL IN STAMP FOR MONSTER
*         IN:     X IS MONSTER NUMBER
*         OUT:
*         USE:    TEMP0,Y

MONSTAMP  LDA     #$00                   ;SET 'M0BLUE' TO NORMAL MONSTER
          STA     M0BLUE,X
          TXA
          ASL     A
          ASL     A
          TAY
          LDA     IMCOLOR,X              ;ADJUST COLOR
          STA     P3C1,Y
          LDA     #WHITE
          STA     P3C2,Y
          LDA     #BLUE
          STA     P3C3,Y
          RTS

* SCORSTMP        - FILL IN SCORE FOR MONSTER
*         IN:     X IS MONSTER NUMBER
*         OUT:
*         USE:    TEMP0,Y

SCORSTMP
          LDY     GREEDCNT
          LDA     MSCRTBLH,Y
          STA     SHLIST+2,X
          LDA     MSCRTBLL,Y
          STA     SLLIST+2,X
          LDA     #$01
          STA     DOLIST+2,X
          TXA
          ASL     A
          ASL     A
          TAY
          LDA     #LTGREEN               ;ADJUST COLOR
          STA     P3C2,Y
          RTS

* INITMON         - INITIALIZE MONSTER DATA
*         USES:
*

INITMON
          LDX     #3
INITMNLP

          LDA     IMVPOS,X
          STA     M0VPOS,X
          LDA     IMHPOS,X
          STA     M0HPOS,X
          LDA     IMDIR,X
          STA     M0DIR,X
          LDA     #0
          STA     M0DISP,X
          STA     M0SPEED,X
          STA     M0TUNNEL,X
          STA     M0FLIP,X
          STA     M0SLOW,X
          LDA     IMSTATE,X
          STA     M0STATE,X
          JSR     MONSTAMP
          JSR     DISPMON

          DEX
          BPL     INITMNLP

          LDA     #1
          STA     BORED
          LDA     #0
          STA     ISBLUE
          STA     NORMTIME
          STA     NORMTIME+1
          STA     EATNDOTS
          STA     TRELEASE
          JSR     SETMON

          LDA     LEVEL
          CMP     #2
          BPL     INITREL1
          LDA     #$00
          STA     M1REL
          LDA     #$1A
          STA     M2REL
          LDA     #$34
          STA     M3REL
          JMP     INITBLTM
INITREL1
          CMP     #3
          BPL     INITREL2
          LDA     #$00
          STA     M1REL
          STA     M2REL
          LDA     #$20
          STA     M3REL
          JMP     INITBLTM
INITREL2
          LDA     #$00
          STA     M1REL
          STA     M2REL
          STA     M3REL

INITBLTM                                 ;NOW SET UP BLUE TIME
          LDA     LEVEL
          CMP     #20
          BMI     BLUTIM
          LDA     #19
BLUTIM    TAX
          LDA     BTIME,X
          STA     BLUETIME
          RTS

*         STATE CHANGE ROUTINES          *

* GETOUT          DOES THE STATE CHANGE TO GET OUT OF THE PEN)
*         IN:     A IS MONSTER NUMBER
*         USES:

GETOUT
          TAX
          LDA     #MSTLVPEN
          STA     M0STATE,X
          LDA     OUTDIR,X
          STA     M0DIR,X
          RTS

* TURNBLUE        TURNS A MONSTER BLUE
*         USES

TURNBLUE
          LDX     #3
TRNBLULP
          LDA     M0STATE,X
          CMP     #MSTEYES
          BEQ     TRNBLUND
          CMP     #MSTINPEN
          BEQ     TRNBLUND
          LDA     #SPDBLUE
          STA     M0SPEED,X
          JSR     BLUSTAMP
          LDA     M0STATE,X
          BNE     TRNBLUND
          INC     M0FLIP,X
          JSR     WRTMON
TRNBLUND  DEX
          BPL     TRNBLULP

          LDA     #1
          STA     ISBLUE
          LDA     #0
          STA     GREEDCNT
          LDA     BLUETIME
          STA     BLUWAIT
          LDA     #$0D                   ;MAKE ENERGIZED SOUND
          JSR     DOTUNE
          RTS

* TURNNORM        TURNS A MONSTER NORMAL
*         USES

TURNNORM
FOO       LDX     #3
TRNNRMLP
          LDA     M0STATE,X
          CMP     #MSTEYES
          BEQ     TRNNRMND
          LDA     M0STATE,X
          CMP     #MSTINPEN
          BEQ     TRNNRMND
          LDA     #SPDNORM
          STA     M0SPEED,X
          JSR     MONSTAMP
          JSR     WRTMON
TRNNRMND  DEX
          BPL     TRNNRMLP

          LDA     #0
          STA     ISBLUE
          STA     BLUWAIT
          JSR     KILLBSND
          RTS

* TURNEYES        TURNS A MONSTER INTO EYES
*         IN      X IS A MONETR NUMBER
*         USES

TURNEYES
          LDA     #$00                   ;TURN FLIP OFF, JUST IN CASE
          STA     M0FLIP,X
          LDA     #MSTEYES
          STA     M0STATE,X
          LDA     #SPDNORM
          STA     M0SPEED,X
          JSR     EYESTAMP
          JMP     WRTMON

* MONFLIP         DOES THE MONSTER FLIP
*         USES

MONFLIP   LDX     #3
FLIPLOOP  LDA     M0STATE,X
          BNE     FLIPEND
          INC     M0FLIP,X
FLIPEND   DEX
          BPL     FLIPLOOP

          LDA     #0
          STA     BORED
          LDA     REVWAIT+2
          STA     REVWAIT
          LDA     REVWAIT+3
          STA     REVWAIT+1
          LDA     #$FF
          STA     REVWAIT+2
          STA     REVWAIT+3

          RTS
*
* RELEASE         -CHECK FOR MONSTER RELEASES FORM PEN
*

RELEASE
          LDA     LEVEL                  ; FIRST CHECK FOR TIMED RELEASE
          CMP     #5
          BMI     TIMEREL1
          LDA     TRELEASE
          CMP     #$B4
          BCC     PINKREL
          JMP     DOREL
TIMEREL1
          LDA     TRELEASE
          CMP     #$F0
          BCC     PINKREL
DOREL                                    ;TIME TO RELEASE SOMEONE
          LDA     #0
          STA     TRELEASE
          LDA     M0STATE+1
          CMP     #MSTATPEN
          BNE     WHCHREL1
          LDA     #1
          JSR     GETOUT
          JMP     PINKREL
WHCHREL1
          LDA     M0STATE+2
          CMP     #MSTATPEN
          BNE     WHCHREL2
          LDA     #2
          JSR     GETOUT
          JMP     PINKREL
WHCHREL2
          LDA     M0STATE+3
          CMP     #MSTATPEN
          BNE     PINKREL
          LDA     #3
          JSR     GETOUT
          JMP     PINKREL
PINKREL
          LDA     M0STATE+1
          CMP     #MSTATPEN
          BNE     BLUEREL
          LDA     DEATHFLG
          BEQ     PINKREL1
          LDA     EATNDOTS
          CMP     #6
          BNE     BLUEREL
          LDA     #1
          JSR     GETOUT
          JMP     BLUEREL
PINKREL1  LDA     PINKDOTS
          CMP     M1REL
          BCC     BLUEREL
          LDA     #1
          JSR     GETOUT

BLUEREL
          LDA     M0STATE+2
          CMP     #MSTATPEN
          BNE     GOLDREL
          LDA     DEATHFLG
          BEQ     BLUEREL1
          LDA     EATNDOTS
          CMP     #15
          BNE     GOLDREL
          LDA     #2
          JSR     GETOUT
          JMP     GOLDREL
BLUEREL1  LDA     BLUEDOTS
          CMP     M2REL
          BCC     GOLDREL
          LDA     #2
          JSR     GETOUT

GOLDREL
          LDA     M0STATE+3
          CMP     #MSTATPEN
          BNE     RELOUT
          LDA     DEATHFLG
          BEQ     GOLDREL1
          LDA     EATNDOTS
          CMP     #28
          BNE     RELOUT
          LDA     #0
          STA     DEATHFLG
          STA     EATNDOTS
          JMP     RELOUT
GOLDREL1
          LDA     GOLDDOTS
          CMP     M3REL
          BCC     RELOUT
          LDA     #3
          JSR     GETOUT
RELOUT
          RTS

*
* FLASHON

FLASHON   LDA     #DKBLUE                ;FLASH COLOR
          STA     TEMP17
          LDA     #LTPINK
          STA     TEMP18
          JMP     FLASHMON

*
* FLASHOFF

FLASHOFF  LDA     #WHITE                 ;FLASH COLOR
          STA     TEMP17
          LDA     #PINK
          STA     TEMP18


*  THIS ROUTINE FLASHES A MONSTER
FLASHMON  LDX     #3                     ;DO FOR EACH MONSTER
FLSHLOOP  LDA     M0BLUE,X
          CMP     #$08
          BNE     FLASHEND
          LDA     M0STATE,X
          CMP     #MSTINPEN
          BEQ     FLASHEND
          TXA
          ASL     A
          ASL     A
          TAY
          LDA     TEMP17                 ;BLUE MONSTER - FLASH COLOR
          STA     P3C1,Y
          LDA     TEMP18
          STA     P3C2,Y

FLASHEND  DEX
          BPL     FLSHLOOP
          RTS


* CHKBLUE
*
CHKBLUE   LDA     RTLOCAL+1              ;ONLY EXECUTE EVERY OTHER TIME
          AND     #$01
          BEQ     CKBOUT
          LDA     BLUWAIT                ;IF BLUWAIT <> 0, WE ARE BLUE
          BEQ     CKBOUT
          DEC     BLUWAIT
          BEQ     CKBNORM

          LDY     #$04                   ;SEE IF TIME TO FLASH
CKBLOOP   CMP     ONFLASH,Y
          BEQ     CKBONFL
          CMP     OFFFLASH,Y
          BEQ     CKBOFFFL
          DEY
          BPL     CKBLOOP
CKBOUT    RTS

CKBNORM   JMP     TURNNORM               ;TURN MONSTER NORMAL
CKBONFL   JMP     FLASHON                ;FLASH MONSTER ON
CKBOFFFL  JMP     FLASHOFF               ;FLASH MONSTER OFF

OFFFLASH  DB      $07,$13,$1F,$2B,$37    ;TIMES MONSTERS FLASH PINK
ONFLASH   DB      $0D,$19,$25,$31,$3D    ;TIMES MONSTERS FLASH BLUE


* TIGHT LOOP FOR MOVING EYES DURRING SCORE DISPLAY
TIGHT
          STX     TEMP16
          LDX     #3
TIGHTLP                                  ; TOP OF TIGHT LOOP
          LDA     M0STATE,X
          CMP     #MSTEYES
          BEQ     DOTIGHT
          CMP     #MSTINPEN
          BNE     TIGHTEND
          JSR     MMVPEN
          JMP     TIGHTEND
DOTIGHT
          JSR     MNCHKDIR               ; FIND OUT IF WE ARE AT INTERSECT
          CMP     #0
          BNE     TIGHTMV                ; WE ARE NOT, SO JUST MOVE
          LDA     M0OFF,X                ; AND MAKE SURE WE ARE AT THE CENTER
          CMP     #3
          BNE     TIGHTMV
          LDA     M0HPOS,X
          AND     #3
          CMP     #1
          BNE     TIGHTMV
          JSR     MMVEYES                ; IT'S EYES
TIGHTMV   JSR     MOVEMON                ; MOVE THE MONSTER
TIGHTEND
          DEX
          BPL     TIGHTLP
          LDX     TEMP16
          RTS


*  THIS ROUTINE IS SIMPLY ONE TO CHECK IF A MONSTER IS IN AN INTERSECTION
MNCHKDIR  LDA     M0ZONE,X
          STA     TEMP4
          LDA     M0COL,X
          STA     TEMP5
          LDA     M0DIR,X
          STA     TEMP6
          JMP     CHECKDIR


*  THIS ROUTINE GETS RID OF THE ENERGIZED SOUND
KILLBSND  LDA     #$0D                   ;3 TUNES - D, E, AND F - TO KILL
          JSR     KILLTUNE
          LDA     #$0E
          JSR     KILLTUNE
          LDA     #$0F
          JMP     KILLTUNE


IMVPOS    DB      $39,$4B,$4B,$4B
IMHPOS    DB      $37+LEFTSIDE,$37+LEFTSIDE,$2F+LEFTSIDE,$3F+LEFTSIDE
IMDIR     DB      DLEFT,DUP,DDOWN,DDOWN
IMSTATE   DB      MSTNORM,MSTATPEN,MSTATPEN,MSTATPEN
IMCOLOR   DB      PINK,LTPINK,LTBLUE,GOLD

HOMEDIR   DB      DUP,DUP,DLEFT,DRIGHT
OUTDIR    DB      DUP,DUP,DRIGHT,DLEFT

DIROFFZ4  DB      $00,$04,$00,$FC
DIROFFC4  DB      $04,$00,$FC,$00
DIROFFZ2  DB      $00,$02,$00,$FE
DIROFFC2  DB      $02,$00,$FE,$00

BTIME     DB      $C0,$B4,$96,$78,$5A,$3C,$96,$3C,$3C,$1E
          DB      $96,$3C,$1E,$1E,$5A,$1E,$1E,$01,$1E,$01

*  STAMPS FOR THE MONSTERS - INDEX: M0BLUE + M0DIR + (M0STATE ^ $10)/4
MONSTMPH  DB      H(NRMMONST),H(NRMMONST+48),H(NRMMONST+96),H(NRMMONST+144)
          DB      H(NRMMONST+24),H(NRMMONST+72),H(NRMMONST+120),H(NRMMONST+168)
          DB      H(BLUMONST),H(BLUMONST),H(BLUMONST),H(BLUMONST)
          DB      H(BLUMONST+24),H(BLUMONST+24),H(BLUMONST+24),H(BLUMONST+24)
          DB      H(EYEMONST),H(EYEMONST+24),H(EYEMONST+48),H(EYEMONST+72)
          DB      H(EYEMONST),H(EYEMONST+24),H(EYEMONST+48),H(EYEMONST+72)
MONSTMPL  DB      L(NRMMONST),L(NRMMONST+48),L(NRMMONST+96),L(NRMMONST+144)
          DB      L(NRMMONST+24),L(NRMMONST+72),L(NRMMONST+120),L(NRMMONST+168)
          DB      L(BLUMONST),L(BLUMONST),L(BLUMONST),L(BLUMONST)
          DB      L(BLUMONST+24),L(BLUMONST+24),L(BLUMONST+24),L(BLUMONST+24)
          DB      L(EYEMONST),L(EYEMONST+24),L(EYEMONST+48),L(EYEMONST+72)
          DB      L(EYEMONST),L(EYEMONST+24),L(EYEMONST+48),L(EYEMONST+72)

*  TABLES OF SCORE BITMAPS
MSCRTBLH  DB      H(MONSTNUM),H(MONSTNUM+24),H(MONSTNUM+48),H(MONSTNUM+72)
MSCRTBLL  DB      L(MONSTNUM),L(MONSTNUM+24),L(MONSTNUM+48),L(MONSTNUM+72)

*  HACK TABLE TO SLOW MONSTERS IN PEN
HACKVPOS  DB      $00,$FF,$00,$01
