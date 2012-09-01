; MOVE.S
; THIS FILE CONTAINS THE GENERAL MOVEMENT ROUTINE, USED BY ALL MOVING
;         CHARACTERS.
;    IT DOES A TWO-BYTE FIXNUM X,Y SPEED VECTOR ADD.

          GLBL    MOVE
          GLBL    MKSPLAT

MOVE
          TXA                            ; SEE IF THIS IS A FOOD OR A CHARACTER
          CMP     #FOODSTRT
          BPL     MOVE0011               ; IF A FOOD, NO ANIMATE COUNTER
;         BMI     MOVE001                   ; IT'S A CHARACTER--- 
MOVE001
          DEC     CFRAME+1,X               ; ANIMATE COUNTER
          BPL     MOVE0011               ; DON'T CHANGE UNTIL LESS THAN ZERO
                                         ;   SINCE THE DRIVERS NEED IT AT ZERO
          LDA     CSPEED+1,X               ; IF MINUS, RESET
          AND     #$7F
          CLC
          ADC     #7
          STA     CFRAME+1,X

MOVE0011  LDA     CFRAME,X               ; CURRENT FRAME COUNT FOR CHARACTER
          AND     #$7F                   ; TOP BIT MEANS DOUBLE SPEED
          BEQ     DOMOVE                 ; MOVE IF IT'S ZERO

          DEC     CFRAME,X               ; ELSE DECREMENT AND RETURN
          RTS                            ; JMP MOVEBYE

DOMOVE    LDA     CSPEED,X
          STA     CFRAME,X               ; RESET CFRAME FOR NEXT TIME

; TEST TO SEE IF CHARACTER HAS PASSED RIGHT OR LEFT BORDER:

          LDA     CXPOS,X
          CMP     #XMIN                  ; LEFT BORDER
          BCC     MSKIP11                ;  "BCC XLDTST"

          CMP     #$C8                    ; BIGGER THAN RIGHT SIDE
          BCC     MSKIP1
MSKIP11   JMP     XLDTST                 ; LEFT DIRECTION TEST

MSKIP1    CLC
          ADC     CWIDTH,X               ; ADD WIDTH OF CHARACTER
          CMP     #XMAX                  ; RIGHT BORDER
          BCC     ZMSKIP21
          JMP     XRDTST                 ; RIGHT DIRECTION TEST
ZMSKIP21
XOK                                      ; FINALLY, DO X AXIS MOVEMENT
         LDA     CFRAME,X
          BPL     XNODBL
;        BMI     XDOUBLE                ; BIT 7 MEANS TWICE THE SPEED

XDOUBLE   LDA     CXSPEEDL,X             ; IDENTICAL; DOES IT TWICE
         CLC
         ADC     CXPOSL,X
         STA     CXPOSL,X
         LDA     CXSPEED,X
         ADC     CXPOS,X
         STA     CXPOS,X

XNODBL    LDA     CXSPEEDL,X
          CLC
          ADC     CXPOSL,X
          STA     CXPOSL,X
          LDA     CXSPEED,X
          ADC     CXPOS,X
          STA     CXPOS,X

          JMP     SKSKIPX
SKIPX
          TXA
          CMP     #FOODSTRT              ; IF IT'S A FOOD, REMOVE IT
          BPL     FWLHIT

          LDA     CSTATE,X
          CMP     #LEAVING
          BEQ     CHERASE

; TEST TO SEE IF CHARACTER HAS PASSED TOP OR BOTTOM BORDER:

SKSKIPX
          LDA     CYPOS,X
          CMP     #YMAX                  ; TOP BORDER
          BCC     ZMSKIP22
          JMP     YUDTST                 ; UP DIRECTION TEST

ZMSKIP22  SEC
          SBC     CHEIGHT,X              ; SUBTRACT HEIGHT OF CHARACTER
          CMP     #YMIN                  ; BOTTOM BORDER
          BCS     ZMSKIP23
          JMP     YDDTST                 ; DOWN DIRECTION TEST
ZMSKIP23
YOK
         LDA     CFRAME,X
          BPL     YNODBL
;        BMI     YDOUBLE                ; BIT 7 MEANS DOUBLE SPEED

YDOUBLE   LDA     CYSPEEDL,X
         CLC
         ADC     CYPOSL,X
         STA     CYPOSL,X
         LDA     CYSPEED,X
         ADC     CYPOS,X
         STA     CYPOS,X

YNODBL    LDA     CYSPEEDL,X
          CLC
          ADC     CYPOSL,X
          STA     CYPOSL,X
          LDA     CYSPEED,X
          ADC     CYPOS,X
          STA     CYPOS,X

          JMP     SKSKIPY
SKIPY
          TXA
          CMP     #FOODSTRT              ; IF IT'S A FOOD, REMOVE IT
          BPL     FWLHIT

          LDA     CSTATE,X
          CMP     #LEAVING
          BEQ     CHERASE

SKSKIPY
MOVEBYE
          RTS

; THIS CODE MAKES A FOOD SPLAT ON THE SCORE

FWLHIT    LDA     STATUS                 ; GIVE BONUS POINTS IF
          CMP     #STATBON               ;  THIS IS A BONUS FOOD
          BEQ     FWLH00

          CMP     #STATHIT
          BNE     NONIADEC

          DEC     NUMINAIR

NONIADEC  LDA     #0                     just erase food in all other cases
          STA     CYPOS,X
          RTS                            ; JMP MOVEBYE

FWLH00    TXA
          TAY
          JSR     MKSPLAT

          LDX     #1                     ; 100 POINTS BONUS FOR THE FOOD
          JMP     ADDSCORE               ; WAS JSR, FOLLOWED BY RTS
;         RTS

CHERASE   LDA     #0
          STA     CYPOS,X
          STA     CYPOS+1,X
          STA     CYPOS+2,X

          LDA     #DEAD
          STA     CSTATE,X

          LDA     NUMFALL
          CMP     #4
          BNE     CHERASE9

; ELSE, ALL THE CHEFS ARE GONE-- MAKE HIM RISE IMMEDIATELY

          LDA     #0
          STA     CACOUNT,X
          STA     CACOUNT+1,X

          RTS                            ; JMP MOVEBYE

CHERASE9  LDA     #$1F                   ; SET REBIRTH TIMER
          STA     CACOUNT,X              ; LOW BYTE
          LDA     #$01
          STA     CACOUNT+1,X              ; HIGH BYTE

          RTS                            ; JMP MOVEBYE

; THE FOUR BORDER DIRECTION TESTS FOLLOW.

JSKIPX    JMP     SKIPX
XRDTST    LDA     CDIR,X                 ; IF 1,2,3 SKIP X MOVEMENT
          CMP     #1
          BPL     MAYBE1                 ; IF GREATER THAN 1, MAYBE SKIP
          LDA     CXPOS,X
          JMP     XOK                    ; ELSE IT'S ZERO, OK.
MAYBE1    CMP     #4
          BMI     JSKIPX
ZMSKIP11  LDA     CXPOS,X
          JMP     XOK                    ; ELSE DO IT.

XLDTST    LDA     CDIR,X                 ; CAN'T BE GREATER THAN 4
          CMP     #5
          BPL     JSKIPX
ZMSKIP12  LDA     CXPOS,X
          JMP     XOK

JSKIPY    JMP     SKIPY
YUDTST    LDA     STATUS                 ; IF HITTING SCORE, THEN THERE'S NO
          CMP     #STATBON               ; DIRECTION
          BEQ     JSKIPY

          LDA     CDIR,X                 ; CAN'T BE 0,1, OR 7
          CMP     #7
          BEQ     JSKIPY
ZMSKIP93  CMP     #2
          BMI     JSKIPY
ZMSKIP13  LDA     CYPOS,X
          JMP     YOK

YDDTST    LDA     CDIR,X                 ; CAN'T BE 3,4,5
          CMP     #3
          BPL     MAYBE2
          LDA     CYPOS,X
          JMP     YOK
MAYBE2    CMP     #6
          BMI     JSKIPY
ZMSKIP19  LDA     CYPOS,X
          JMP     YOK

