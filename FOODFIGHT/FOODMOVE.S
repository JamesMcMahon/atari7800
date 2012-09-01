; FOODMOVE.S
; (THIS FILE ALSO CONTAINS THE ICE CREAM CONE DRIVER, "ICEMELT").
; THIS ROUTINE MAKES THE FOODS FLY THROUGH THE AIR.  IN ADDITION, IT
;         DECREMENTS THE TIME COUNTER ("FINFO"), AND IF IT'S ZERO,
;         DECREMENTS THE SECOND TIME COUNTER ("FLYTIMER").  WHEN THIS TIMER
;         IS ZERO, THEN IT'S TIME TO FADE OUT THE FOOD.
;   THE MOVEMENT ALGORITHM USED IS THE SAME AS FOR THE CHEFS AND CHUCK;
;         TO GET A FASTER SPEED, DIFFERENT MOVEMENT TABLES MUST BE USED.
;         THESE ARE USED BY CHUCK AND CHEFS IN HIGHER RACKS ANYWAY TO
;         GET LIGHTNING FAST GAMES.
;   8/26/83 : CODE FOR THE ANIMATED BANANA INSERTED.
;   9/01/83 : CODE FOR THE DISPERSING PEAS INSERTED.
;  11/04/83 : CODE FOR ANGLED MOVEMENT INSERTED

          GLBL    PLRACK,GOD
          GLBL    STATBON,STATDIE
          GLBL    NUMFOOD
          GLBL    CHSTAMP,BLOCK1,SPLATCH,SPLATPW,THRWTIME
          GLBL    NEXTPILE,LASTPILE,FINFO,NUMEPILE
          GLBL    TAKEFOOD,FXPOS,FYPOS,CSPEED,CFRAME,CTYPE,CFLYTIME
          GLBL    SPLAT,FLYING,STATHIT,CDIR
          GLBL    CHASE,MOVE,DEAD,WON,CACOUNT,CSTAMP,CPALW
          GLBL    ANGLE,STICKING,NUMSTUCK
          GLBL    CINFO,NUMINAIR,ALLGONE
          GLBL    STATEND
          GLBL    STATENDR
          GLBL    CXSPEED,CXSPEEDL,CYSPEED,CYSPEEDL
          GLBL    CXPOSL,CYPOSL
          GLBL    FLYCHAR,FLYPALW
          GLBL    FSTATE

          GLBL    FOODMOVE
          GLBL    WAIT

          GLBL    PIEFLY,PIEFLYPW,BANFLY,BANFLYPW,PEAFLY
          GLBL    XVECTORH,XVECTORL,YVECTORH,YVECTORL,SCOREX

FOODSTRT  EQU     $0F
PILESTRT  EQU     $01

SCOREY    EQU     $AF

          RAMDEF                         ; ZERO PAGE

          RSEG    CODE2

FOODMOVE  LDA     STATUS
          CMP     #STATBON
;         BNE     FMCONT11
          BEQ     FMWONJMP               becomes a jump

FMCONT11  CMP     #STATHIT
          BNE     FMCONT10
FMWONJMP  JMP     FMWON

FMWONBYE
FMCONT10  LDX     #$1E                   foodstrt($f) + numfood($10) - 1

FLOOP     LDA     CYPOS,X
;         BNE     FMSKIP11
          BEQ     NXTFJMP                becomes a jump

FMSKIP11  LDA     CSTATE,X
          CMP     #STICKING
          BNE     FMSKIP12
NXTFJMP   JMP     NXTFOOD

FMSKIP12  CMP     #SPLAT
          BNE     FMSKIP1
          JMP     FMSPLAT

FMSKIP1
          STX     TEMPX

          CMP     #FLYING
          BEQ     FM040
          CMP     #ANGLE
;         BEQ     FM030

          BNE     NXTFJMP                same as a jump

FM030     LDY     TEMPX                  ; IF IT'S HITTING SCORE OR CHUCK
                                         ; PUT THE FOOD INDEX IN Y
          JSR     SETDELTA

          LDX     TEMPX                  ; RESTORE FOR "MOVE"

FM040     JSR     MOVE                   ; MOVES THE FOOD
          LDX     TEMPX                  ; RESTORE FOOD INDEX

FM060     LDA     CSTATE,X               ; SEE IF "MOVE" JUST SET THE FOOD
          CMP     #SPLAT                 ;   TO BE SPLATTING
;         BNE     FMSKIP21
          BEQ     NXTFJMP                same as a jump

FMSKIP21  CMP     #ANGLE                 ; IF FLYING AT END OF RACK,
          BEQ     FMSKIP22               ;   DON'T LET IT DISAPPEAR

          LDA     NUMCYCLE               only decrement once every second
          CMP     #1
          BNE     FMSKIP22

          DEC     CFLYTIME,X                ; DECREMENT THE TIMER
          BEQ     FDERASE                ; IF ZERO, REMOVE FOOD

; NOW TEST TO SEE IF ANIMATION IS NECESSARY:

FMSKIP22  LDA     CTYPE,X                ; TYPE OF FOOD
          BEQ     BANANI1                ; BANANA TYPE IS 0
          CMP     #1                     ; PEAS
          BEQ     PEAANI1
JNXTFD    JMP     NXTFOOD

BANANI1   LDA     CFRAME,X
          AND     #$7F
          BNE     NXTFOOD
          LDA     PLRACK                 ; IF RACK 17 OR ABOVE
          AND     #$F0                   ; THEN ONLY ANIMATE EVERY OTHER TIME.
          BEQ     BANANI2
          LDA     CYCLECNT
          AND     #$01
          BNE     NXTFOOD

BANANI2   LDA     CACOUNT,X              ; TELLS WHICH FRAME OF ANIMATION
          TAY
          LDA     BANFLY,Y
          STA     CSTAMP,X
          LDA     BANFLYPW,Y
          STA     CPALW,X

          DEC     CACOUNT,X
;         BMI     ZFM001
          BPL     JNXTFD

ZFM001    LDA     #7                     ; 8 DIFFERENT BANANA FRAMES
          STA     CACOUNT,X
          JMP     NXTFOOD

PEAANI1   DEC     CINFO,X                ; ANIMATE COUNTER
;         BEQ     PEAANI2
          BNE     NXTFOOD                same as a jump

PEAANI2   LDA     #8                     ; RESET ANIMATE COUNTER
          STA     CINFO,X

          LDY     CACOUNT,X              ; FRAME INDEX
          BMI     NXTFOOD                ; IF LAST FRAME WAS ALREADY REACHED

          LDA     PEAFLY,Y
          STA     CSTAMP,X
          DEC     CACOUNT,X              ; PREPARE FOR NEXT FRAME
          JMP     NXTFOOD

FDERASE   LDA     STATUS
          CMP     #STATBON               ; IF FLYING TOWARDS SCORE,
          BEQ     FDERASE1               ; GO ALL THE WAY TO THE WALL
          CMP     #STATDIE               ; IF FLYING TOWARDS HERO,
          BMI     FDERASE2

FDERASE1  LDA     #$7F                   ; KEEP IT FLYING
          STA     CFLYTIME,X
          BNE     NXTFOOD                same as a jump

FDERASE2  LDA     #0
          STA     CYPOS,X

NXTFOOD   DEX
          CPX     #FOODSTRT
          BMI     FMSKIP9
          JMP     FLOOP

FMSKIP9
FMBYE
          RTS

; THIS CODE IS EXECUTED WHEN THE HERO HAS FINISHED MUNCHING AND
;         IS SMILING; THE FOOD SHOULD ALL FLY UP TO THE SCORE
;   THIS SAME CODE IS USED TO MAKE THE FOOD FLY AT THE HERO
;         WHEN HE'S JUST DIED.

;FMDIE    LDA     STATUS
;         CMP     #STATHIT
;         BEQ     FMWON
;         JMP     FMBYE

FMDIE
FMWON
          LDA     NUMINAIR               ; IF THERE'S A FREE FOOD SPACE, THROW
          CMP     #NUMFOOD
;         BMI     FMWCONT0
          BPL     FMWBYE

FMWCONT0  LDA     ALLGONE                ; TEST TO SEE IF ALL ARE IN THE AIR
          BNE     ZFM003                 ; IF SO, STOP IF NUMINAIR == 0

          LDA     THRWTIME               ; SPACES OUT FOOD THROWS
          BEQ     ZFM004                 ;  THROW IF IT'S TIME
          DEC     THRWTIME
FMWBYE    JMP     FMWONBYE

ZFM003    LDA     NUMINAIR
          BNE     FMWBYE
          JMP     ALLOVER                ; IF NO FOODS REMAIN IN THE AIR

ZFM004    LDA     #5                    ; "DEBOUNCING" TIMER FOR FOOD
          STA     THRWTIME

          LDX     NEXTPILE              ; FIND A FOOD
          STX     LASTPILE

ZFMLOOP1  LDA     FINFO,X
          ASL     A                      ; BIT 6 HIGH MEANS BOTTOM HALF
          BMI     ZFMEND1                ; ONLY TOP HALVES

          AND     #$08                   ; DONT THROW WATERMELONS AT SCORE
          BEQ     ZFMENDZZ
          LDA     STATUS                 ; THROW WATERMELON IF CHARLIE DIED.
          CMP     #STATHIT
          BNE     ZFMEND1

ZFMENDZZ  LDA     FSTATE,X
          BNE     ZFMWONTH               ; IF THE PILE IS NON-EMPTY

ZFMEND1   INX
          STX     NEXTPILE
          CPX     LASTPILE
          BNE     ZFMEND2
          JMP     SETALLGN               ; IF WE'VE LOOPED ALL THE WAY AROUND

ZFMEND2   CPX     #PILESTRT+NUMEPILE
          BMI     ZFMLOOP1

          LDX     #PILESTRT              ; WE'VE REACHED THE END-- WRAP AROUND
          STX     NEXTPILE
          CPX     LASTPILE
          BNE     ZFMLOOP1
          JMP     SETALLGN

ZFMWONTH  INC     NEXTPILE               ; NEXT ONE TO CHECK IS ONE BEYOND
          LDA     NEXTPILE
          CMP     #PILESTRT+NUMEPILE
          BMI     ITSOKAY

          LDA     #PILESTRT
          STA     NEXTPILE

ITSOKAY   TXA
          PHA                            ; SAVE PILE INDEX
          TAY                            ; PILE INDEX MUST BE IN Y

          JSR     TAKEFOOD               ; GET ONE FOOD FROM PILE

          TAY                            ; FOOD INDEX IS NOW IN A
          PLA
          TAX                            ; X CONTAINS PILE INDEX

          INC     NUMINAIR

          LDA     FXPOS,X                ; SET FOOD POSITION
          STA     CXPOS,Y
          LDA     FYPOS,X
          STA     CYPOS,Y

          LDA     #ANGLE
          STA     CSTATE,Y

; INITIALIZE THE DELTA VALUES FOR ANGLED MOVEMENT

          LDA     STATUS
          CMP     #STATBON
          BNE     ZFMDIE                 ; "GOALN" SET IN "HEROKILL"

          LDX     CURRENT                ;  ELSE ITS HITTING CHUCK
          LDA     SCOREX,X
          STA     GOALX
          LDA     #SCOREY
          STA     GOALY

ZFMDIE
          JSR     SETDELTA               ; DOESN'T ALTER Y

          STY     TEMPY
          LDX     TEMPY                  ; FOOD INDEX IN "X" FOR CHASE
          JSR     CHASE                  ; SETS "CDIR" FOR SPLAT POSITION

          LDY     TEMPY                  ; "Y" USED BY "CHASE"
          LDA     #0                     ; INITIALIZE LOW BYTES OF POSITION
          STA     CYPOSL,Y
          STA     CXPOSL,Y

; NOW INITIALIZE FOOD FOR ANIMATION, CHARACTERS, ETC.

ZFMANIM   LDA     CTYPE,Y
          CMP     #2                     ; PIE TYPE IS 2
          BEQ     ZFMTH00
          CMP     #1                     ; PEAS
          BEQ     ZFMTH01

ZFMTH02   LDA     #01                    ;ANYTHING BUT PEAS
          STA     CINFO,Y                ; FOR ALL TYPES OTHER THAN PEAS

          LDA     #0
          STA     CACOUNT,Y
          JMP     ZFMTH10

ZFMTH00   LDA     CDIR,Y                 ; USE DIRECTION AS TABLE INDEX
          TAX
          LDA     PIEFLY,X               ; GET STAMP
          STA     CSTAMP,Y               ; STORE IT
          LDA     PIEFLYPW,X             ; GET PALETTE WIDTH
          STA     CPALW,Y
          JMP     ZFMTH10

ZFMTH01   LDA     #1                     ; IF IT'S PEAS, SET UP FOR DISPERSAL
          STA     CACOUNT,Y              ; FRAME INDEX

          LDA     #16
          STA     CINFO,Y

*ZFMTH10   LDA     #$81                   ; DOUBLE THE SPEED
ZFMTH10   LDA     #0
          STA     CSPEED,Y
          STA     CFRAME,Y

          LDA     #$FF                   ; 4 SECONDS
          STA     CFLYTIME,Y

          JMP     FMWONBYE               ; THROW ONE PER CODE CYCLE

SETALLGN  LDA     #$FF
          STA     ALLGONE
          JMP     FMWONBYE

ALLOVER   LDA     STATUS
          CMP     #STATBON               ; IF HE'S WON
          BEQ     ZALLOV01

          LDA     #DEAD                  ; ELSE, WE KNOW HE'S LOST
          STA     CSTATE
          JMP     ZALLOV02

ZALLOV01  LDA     #WON
          STA     CSTATE                 ; MAKES NEW RACK START

ZALLOV02  LDA     #90                    ; WAIT FOR 1.5 SECONDS
          STA     WAITCNT

          LDA     DOITOVER
          BEQ     ZALLOV03               ; NOT AN IR

          LDA     #STATENDR              ; AN IR
          JMP     ZALLOV04

ZALLOV03  LDA     #STATEND               ; ONLY CHEF DRIVER WILL RUN
ZALLOV04  STA     STATUS

; INSTEAD OF "RTS" TO "GAME", POP THE RETURN ADDRESS AND JUMP TO GOD

          PLA
          PLA

          ENDCYCLE

; HANDLE THE ANIMATION OF THE SPLATTING CHARACTER
;   NOTE: IF IT'S HITTING THE HERO, MAKE IT STICK; THIS WILL BE THE CASE
;         IF "STATUS" IS "STATHIT"

FMSPLAT   DEC     CACOUNT,X
          BEQ     ZFMSP00
          RTS                            ; JMP FMBYE

ZFMSP00   LDA     #2
          STA     CACOUNT,X

          DEC     CFRAME,X
          BMI     AENDSPLT

          LDY     CFRAME,X
          LDA     SPLATCH,Y
          STA     CSTAMP,X

          LDA     CPALW,X
          AND     #$E0                   ; TOP THREE BITS ARE PALETTE
          ORA     SPLATPW,Y
          STA     CPALW,X

          JMP     NXTFOOD

; Make the food dissappear-- check to see if it's hitting the score

AENDSPLT  LDA     #DEAD                  ; NO LONGER SPLAT
          STA     CSTATE,X

          LDA     #0                     ; MAKE IT AVAILABLE FOR NEXT TAKEFOOD
          STA     CYPOS,X

          LDA     STATUS
          CMP     #STATBON
          BNE     ZENDSP02

          DEC     NUMINAIR

ZENDSP02  LDA     #BLOCK1
          STA     CHSTAMP,X

          JMP     NXTFOOD

; THIS ROUTINE IS CALLED FIRST WHEN EACH FOOD IS TAKEN FROM A PILE AND
;         LATER TO PERIODICALLY UPDATE IT'S FLIGHT.

SETDELTA  LDA     #0
          STA     TEMP2
          STA     TEMP3
          STA     TEMP4

          LDA     GOALX
          SEC
          SBC     CXPOS,Y
          BCS     SD0001
          INC     TEMP2                  ; FLAG FOR NEGATIVE DX
          EOR     #$FF
          CLC
          ADC     #1

SD0001    STA     TEMP0                  ; DX

          LDA     GOALY
          SEC
          SBC     CYPOS,Y
          BCS     SD0002
          INC     TEMP3                  ; FLAG FOR NEGATIVE DY
          EOR     #$FF
          CLC
          ADC     #1

SD0002    STA     TEMP1                  ; DY

; NORMALIZE VECTOR FOR ASPECT RATIO.  FLIP THE VECTOR TO THE FIRST OCTANT
;         (NNE)

          LSR     A                      ; 5/8 = 1/2 + 1/8
          STA     TEMP5
          LSR     A
          LSR     A
          CLC
          ADC     TEMP5
          CMP     TEMP0
          BCS     SD0003
          INC     TEMP4                  ; FLAG FOR OCTANT FLIP
          TAX                            ; SWITCH DX AND DY
          LDA     TEMP0
          STX     TEMP0

SD0003    LSR     A                      ; DY = DY/4
          LSR     A
          STA     TEMP1

; COMPUTE 3/8 DX

          LDA     TEMP0
          LSR     A
          LSR     A
          STA     TEMP5
          LSR     A
          CLC
          ADC     TEMP5
          STA     TEMP6

; COMPUTE SECTOR 0,1,2,3

          LDA     TEMP0
          LSR     A
          STA     TEMP5
          LSR     A
          LSR     A
          CLC
          ADC     TEMP5

          LDX     #0
          CMP     TEMP1
          BCC     SECTOR01
          LDX     #2
          LDA     #0
          JMP     SECTOR23

SECTOR01  LDA     TEMP0
SECTOR23  CLC
          ADC     TEMP6
          CMP     TEMP1
          BCC     SECTOR02
SECTOR13  INX
SECTOR02  STX     TEMP0

; NOW UNFOLD THIS 0-3 NUMBER INTO THE CORRECT OCTANT BY
;         USING THE THREE "NEGATIVE" FLAGS:

          LDX     TEMP4                  ; DIAGONAL FLIP
          BEQ     SD0010
          LDA     #7
          SEC
          SBC     TEMP0
          STA     TEMP0
SD0010
          LDX     TEMP3                  ; DY NEGATIVE
          BEQ     SD0011
          LDA     #15
          SEC
          SBC     TEMP0
          STA     TEMP0
SD0011
          LDX     TEMP2                  ; DX NEGATIVE
          BEQ     SD0012
          LDA     #31
          SEC
          SBC     TEMP0
          STA     TEMP0
SD0012
          LDA     TEMP0
          AND     #$1F

; NOW AT LAST WE'VE GOT AN INDEX 0-31.  SET THE FIXNUM DELTAS FROM THE
;         TABLES

          TAX
          LDA     XVECTORH,X
          STA     CXSPEED,Y
          LDA     XVECTORL,X
          STA     CXSPEEDL,Y
          LDA     YVECTORH,X
          STA     CYSPEED,Y
          LDA     YVECTORL,X
          STA     CYSPEEDL,Y

          RTS

          END
