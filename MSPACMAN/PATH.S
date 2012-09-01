
* PATH.S          ROUTINES FOR PATH ANALYSIS IN MS PAC-MAN
*

* CHECKDIR  - CHECK FOR DIRECTIONS FROM A LOCATION
*         IN:     TEMP4 = ZONE, TEMP5 = COLUMN, TEMP6 = DIR
*         OUT:    T12=RIGHT, T13=DOWN, T14=LEFT, T15=UP,(LEGIT=0,BACK=1,WALL=-1)
*                 A=~INTERSECT
*  Y IS DISTORTED, X IS SAVED
*  TEMP0-3,10-11 ARE USED

CHECKDIR  STX     TEMP11
          LDA     #0
          STA     TEMP12
          STA     TEMP13
          STA     TEMP14
          STA     TEMP15
          TAX

CHDLOOP   LDA     T4OFF,X                ;GET ZONE AND COLUMN NEXT TO POS
          CLC
          ADC     TEMP4
          STA     TEMP0
          LDA     T5OFF,X
          CLC
          ADC     TEMP5
          STA     TEMP1
          JSR     GETCHAR                ;FIND OUT WHAT IS THERE
          CMP     #BLNKCHAR              ;SEE IF VALID PLACE TO GO
          BPL     CHDNEXT
          LDA     #-1                    ;NO GOOD
          STA     TEMP12,X
CHDNEXT   INX
          CPX     #$04
          BMI     CHDLOOP

          LDA     TEMP6                  ;SET DIRECTION WE CAME FROM
          CLC
          ADC     #2
          AND     #3
          TAX
          LDA     #1
          STA     TEMP12,X

          LDA     TEMP6                  ;SEE IF IN INTERSECTION
          CLC
          ADC     #1
          AND     #3
          TAX
          CLC
          ADC     #2
          AND     #3
          TAY
          LDA     #$FF
          AND     TEMP12,X
          AND     TEMP12,Y
          LDX     TEMP11
          RTS

* WHCHWAY - GIVEN A INTERSECTION AND A GOAL, FIGURE OUT BEST PATH
*         IN:     TEMP4=CURRENT ZONE, TEMP5=CURRENT COL, TEMP6= CURRENT DIR
*                 TEMP7=GOAL ZONE, TEMP8=GOAL COL, TEMP12-15 INTERSECTION STATE
*         OUT:    A=GOAL DIR
*         USES:   TEMP0-3,9-11
*         SAVES:  X,Y

WHCHWAY   TXA                            ;STORE REGISTERS ON STACK
          PHA
          TYA
          PHA
          JSR     NORMGOAL               ;NORMALIZE GOAL
          JSR     SETSQUAR
          LDA     TEMP6
          STA     TEMP2                  ; CURRENT BEST DIRECTION
          LDA     #$8F                   ; LARGE NEG NUMBER
          STA     TEMP3                  ; -(CURRENT DISTANCE IN BEST DIRECTION)
          LDX     #0

WWLOOP    LDA     T4OFF,X                ;ADJUST ZONE AND COLUMN
          CLC
          ADC     TEMP4
          STA     TEMP9
          LDA     T5OFF,X
          CLC
          ADC     TEMP5
          STA     TEMP10
          LDA     TEMP12,X               ;GET STATE THERE, SEE IF VALID
          BNE     WWNEXT
          JSR     CALCDIST               ;FIND DISTANCE TO GOAL
          CMP     TEMP3                  ;SEE IF SHORTER
          BCC     WWNEXT
          STA     TEMP3                  ;NEW CURRENT DISTANCE
          STX     TEMP2                  ;NEW DIRECTION
WWNEXT    INX
          CPX     #$04
          BMI     WWLOOP

          PLA                            ;RESTORE REGISTERS FROM STACK
          TAY
          PLA
          TAX
          LDA     TEMP2
          RTS


*  NORMGOAL       NORMALIZES THE GOAL ZONE AND COLUMN.  MAKES SURE THEY ARE IN
*                 THE RANGE 0..3F
*         IN:     TEMP7=GOAL ZONE, TEMP8=GOAL COLUMN
*         OUT:    TEMP7, TEMP8 NORMALIZED
NORMGOAL  LDA     TEMP7                  ;FIRST DO ZONE
          JSR     NORMLIZE
          STA     TEMP7
          LDA     TEMP8                  ;THEN COLUMN
          JSR     NORMLIZE
          STA     TEMP8
          RTS

NORMLIZE  BMI     NMLFLOOR               ;SEE IF TOO LOW
          CMP     #$40
          BPL     NMLTOP                 ;SEE IF TOO HI
          RTS
NMLFLOOR  LDA     #$00                   ;TOO LOW - USE 0
          RTS
NMLTOP    LDA     #$3F                   ;TOO HI - USE 3F
          RTS


* CALCDIST        CALCULATES DISTANCE BETWEEN TWO POINTS
*         INT:    (TEMP7,TEMP8) FIRST POINT (TEMP9, TEMP10) SECOND POINT
*         OUT:    A= NEGOTIVE OF DISTANCE
*         USES:   TEMP0,1

CALCDIST
          LDA     TEMP7
          SEC
          SBC     TEMP9
          STA     TEMP1
          BPL     CALCDIS1
          LDA     #0
          SEC
          SBC     TEMP1
          STA     TEMP1

CALCDIS1
          LDA     TEMP8
          SEC
          SBC     TEMP10
          STA     TEMP0
          BPL     CALCDIS2
          LDA     #0
          SEC
          SBC     TEMP0
          STA     TEMP0

CALCDIS2  TXA                            ;GET TEMP11+X INTO Y
          CLC
          ADC     TEMP11
          TAY
          LDA     TEMP0                  ;GET SUM OF DISTANCES
          CLC
          ADC     TEMP1
          CLC
          ADC     #2                     ;GIVE SOME ROOM FOR SQUARE ADJUSTMENT
          CLC
          ADC     SQUARTAB,Y
          STA     TEMP1                  ;AND NOW INVERT IT
          LDA     #0
          SEC
          SBC     TEMP1
          RTS


*  THIS ROUTINE FINDS OUT WHAT DIRECTION SHOULD BE FAVORED, AND WHAT SHOULD BE
*  SHUNNED.  THIS SETS UP TEMP11, WHICH SHOULD BE USED WITH THE DIRECTION AS
*  AN OFFSET INTO SQUARTAB.
*  THIS SHOULD BE CALLED SOON ENOUGH THAT TEMP0-3 CAN BE USED
SETSQUAR  LDA     #$00
          STA     TEMP0                  ;VERTICAL FLIP BIT
          STA     TEMP1                  ;HORIZONTAL FLIP BIT

          LDA     TEMP7                  ;GOAL FOR ZONE
          SEC
          SBC     TEMP4                  ;OUR ZONE
          STA     TEMP2                  ;VERTICAL DELTA
          BPL     SSQHOR
          LDA     #$08
          STA     TEMP0                  ;VERTICAL FLIP
          LDA     #$00
          SEC
          SBC     TEMP2
          STA     TEMP2

SSQHOR    LDA     TEMP8                  ;GOAL FOR COLUMN
          SEC
          SBC     TEMP5                  ;OUR COLUMN
          STA     TEMP3                  ;HORIZONTAL DELTA
          BPL     SSQCOMP
          LDA     #$08
          STA     TEMP1                  ;HORIZONTAL FLIP
          LDA     #$00
          SEC
          SBC     TEMP3
          STA     TEMP3

SSQCOMP   LDA     TEMP2                  ;VERTICAL DELTA
          SEC
          SBC     TEMP3                  ;HORIZONTAL DELTA
          BMI     HORMORE

          LDA     #$04                   ;VERTICAL MORE
          CLC
          ADC     TEMP0                  ;8 MORE IF VERTICAL FLIPPED
          STA     TEMP11
          RTS

HORMORE   LDA     #$00                   ;HORIZONTAL MORE
          CLC
          ADC     TEMP1                  ;8 MORE IF HORIZONTAL FLIPPED
          STA     TEMP11
          RTS



*  THIS TABLE IS TO ADD A SLIGHT COMPENSATION TO MAKE IT LOOK MORE LIKE A SQUARE
SQUARTAB  DB      -1,0,1,0,0,-1,0,1,1,0,-1,0,0,1,0,-1

*  THIS TABLE USED FOR OFFSETS FOR ZONES AROUND
T4OFF     DB      0,1,0,-1
T5OFF     DB      1,0,-1,0
