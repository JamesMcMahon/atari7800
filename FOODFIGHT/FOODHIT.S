; FOODHIT.S
;
; THIS ROUTINE HAS TWO NESTED LOOPS-- ONE FOR ALL THE FLYING FOODS, AND
;         ONE FOR THE 5 CHARACTERS.

          GLBL    FOODHIT
          GLBL    MKSPLAT
          GLBL    ERASEIT

          GLBL    TUNIN
          GLBL    STATHIT,STATDIE,FALLING,YCENTER
          GLBL    NUMFOOD,FLYING,CREATOR,DYCHAR,DXCHAR,CDIR
          GLBL    HEROKILL,CPALW,CARRYING,HELDFOOD,LEAVING
          GLBL    CSPEED,CFRAME,NUMCHHIT,CHSTAMP,BLOCK2,NUMFALL,ADDSCORE
          GLBL    LASTCHEF,CACOUNT,SPLAT,SPLATCH,SPLATPW,CSTAMP
          GLBL    ANGLE
          GLBL    NUMSTUCK,NUMINAIR
          GLBL    STICKING,CTYPE,PIEFLY,PIEFLYPW
          GLBL    REJOYING

          GLBL    FCENTERY,DYFCHAR,STUKXPOS,STUKYPOS

FCHKCTR   EQU     2
FCHFCTR   EQU     0

FCHEFDX   EQU     $04
FCHUCKDX  EQU     $03

FOODSTRT  EQU     $0F
FOODDEC   EQU     $0E                    one less than FOODSTRT
DXFOOD    EQU     $02
DYFOOD    EQU     $03

          RAMDEF                         ; ZERO PAGE

          RSEG    CODE1

FOODHIT   LDX     #0
          LDA     STATUS
          CMP     #STATHIT               only test chuck if STATHIT
          BEQ     FHLOOP1

          LDX     #$0C                   else test everyone

FHLOOP1   LDA     CSTATE,X
          CMP     #REJOYING              test if he's rejoicing !
          BEQ     FHSKIP1

          CMP     #FALLING               ; IF FALLING OR RISING,
          BMI     FHSKIP1
FHNXTJMP  JMP     FHNXTCH                ; DON'T TEST FOR INTERSECTION.

FHSKIP1   LDA     CYPOS,X                ; IF ZERO, HE'S NOT VISIBLE
;         BNE     FHSKIP11
          BEQ     FHNXTJMP               ;  GO ON TO NEXT CHARACTER

FHSKIP11  SEC
          SBC     FCENTERY,X             ; CHARACTERS ARE TALLER- NORMALIZE
          STA     TEMP0                  ; USE AS TESTED Y COORDINATE

AAF1      LDY     #FCHKCTR
          TXA
          BEQ     NOTCHEF1

          LDY     #FCHFCTR
NOTCHEF1  STY     TEMP1

          LDA     CXPOS,X
          CLC
          ADC     TEMP1                  center for chef or chuck
          STA     TEMP1                  tested x coordinate

AAF2      LDY     #FCHUCKDX              use a different DX for chefs
          TXA
          BEQ     NOTCHEF

          LDY     #FCHEFDX               it's a chef-- gets killed easier
NOTCHEF   STY     TEMP2

          LDY     #NUMFOOD+FOODDEC      ; START AT LAST HOLE AND DECREMENT
                                         ;  THE LAST INDEX IS ONE LESS
FHLOOP2   LDA     CYPOS,Y               ; IF NO FOOD IS HERE, DON'T TEST IT
;         BNE     FHSKIP4
          BEQ     FHFDJMP                ; IF NOT VISIBLE, Y == 0
                                         ; a jump
FHSKIP4   LDA     CSTATE,Y               ; SEE IF IT'S FLYING
          CMP     #FLYING
          BEQ     FHSKIP5
          CMP     #ANGLE
          BEQ     FHSKIP6                ; DON'T USE "CREATOR"
FHFDJMP   JMP     FHNXTFD                ; IF IT'S NOT FLYING, SKIP IT

FHSKIP5   TXA                            ; GET CHARACTER INTO A
          CMP     CREATOR,Y              ;  SEE IF HE'S THE THROWER
;         BNE     FHSKIP6
          BEQ     FHFDJMP                ;  IF SO, SKIP THIS FOOD
                                         ; a jump
FHSKIP6   LDA     CYPOS,Y                ; GET FOOD'S Y
          SEC
          SBC     TEMP0                  ; SUBTRACT CHAR'S Y
          BPL     ZFHYPOS                 ; Y DIFF IS POSITIVE
          EOR     #$FF                   ; ELSE, DO TWO'S COMPLEMENT
          CLC
          ADC     #1

; AT THIS POINT, ACC CONTAINS THE ABSOLUTE VALUE OF X DIFFERENCE.

ZFHYPOS    CMP    DYFCHAR,X
;         BMI     ZFHXTST                 ; Y IS NEAR-- CHECK X
          BPL     FHFDJMP                ; ELSE, GO TO NEXT FOOD
                                         ; a jump
ZFHXTST    LDA     CXPOS,Y
          SEC
          SBC     TEMP1                  ; CHARACTER X
          BPL     ZFHXPOS                 ; X DIFF IS POSITIVE
          EOR     #$FF                   ; ELSE, DO TWO'S COMPLEMENT
          CLC
          ADC     #1

ZFHXPOS    CMP    TEMP2                  DX for character + food
;         BMI     FDKILL
          BPL     FHFDJMP                a jump

; If this is a chef, make the food splat.  If it's chuck, just make the
;         food stick to him, and update the flying food variables.

FDKILL    STX     TEMPX

          LDA     STATUS                 ; IF IT'S HITTING HERO, MAKE IT
          CMP     #STATHIT               ; SURROUND CHUCK.
          BNE     FDKILL01               not hitting-- don't adjust food

          LDA     #6                     the splat sound (even though it
          JSR     TUNIN                  doesn't splat)

          DEC     NUMINAIR               update counters for food
          INC     NUMSTUCK

          LDA     #STICKING              ; HITTING THE HERO-- MAKE IT STICK
          STA     CSTATE,Y

          LDA     CTYPE,Y
          CMP     #2                     ; PIES
          BNE     ZENDSP12               ; ANY OTHER FOOD

          LDX     CDIR,Y                 ; IF PIE, BASE ON DIRECTION
          LDA     PIEFLY,X
          STA     CSTAMP,Y
          LDA     PIEFLYPW,X
          STA     CPALW,Y

          LDX     TEMPX

ZENDSP12  LDA     CXPOS,X
          CLC
          ADC     STUKXPOS-15,Y          ; FIRST FOOD IS AT 15
          STA     CXPOS,Y

          LDA     CYPOS,X
          CLC
          ADC     STUKYPOS-15,Y
          STA     CYPOS,Y

FDKILL01  TXA                            ; CHARACTER INDEX
          BNE     FCHKILL
                                       ; IF CHARLIE, DO IT TO HIM
                                         ; ELSE, KILL THE CHEF
FHKILL    LDA     #STICKING              state for sitting on top of hero
          STA     CSTATE,Y               keep the same stamp and position

          LDA     STATUS
          CMP     #STATDIE
          BMI     FHKILL1

          RTS

FHKILL1   JMP     HEROKILL               same as a JSR followed by RTS

FCHKILL   LDA     CPALW,Y
          AND     #$E0                   ; GET JUST THE PALETTE
          STA     TEMP0

          LDA     CPALW,X
          AND     #$1F
          ORA     TEMP0
          STA     CPALW,X

          LDA     CPALW+1,X
          AND     #$1F
          ORA     TEMP0
          STA     CPALW+1,X

          LDA     CPALW+2,X
          AND     #$1F
          ORA     TEMP0
          STA     CPALW+2,X

          STX     TEMPX
          JSR     MKSPLAT                make the food splat on the chef
          LDX     TEMPX

          LDA     CSTATE,X               ; SEE IF HE'S CARRYING
          CMP     #CARRYING
          BNE     FCH0010

          JSR     ERASEIT                erase carried food

FCH0010   LDA     CDIR,Y
          STA     CDIR,X

          LDA     #LEAVING
          STA     CSTATE,X

          LDA     #0
          STA     CFRAME,X
          STA     CSPEED,X

          LDA     #2                     ; ANIMATION COUNTER
          STA     CFRAME+1,X

          LDA     CREATOR,Y              ; CREATOR OF THE FOOD
          BNE     FHSKIPSC
                                         ;  IF THE HERO, GIVE POINTS
                                         ;  ELSE, DON'T
FHGIVESC  INC     NUMCHHIT               ; ONE MORE CHEF HIT

          STX     TEMPX                  ; SAVE INDEX

          LDX     #10
          LDA     NUMCHHIT               ; 100 X NUMBER HIT
          CMP     #11                    ; IF GREATER THAN 10, USE 10
          BPL     ZFH013

          TAX

ZFH013    JSR     ADDSCORE
          LDX     TEMPX                  ; RESTORE CHEF INDEX

FHSKIPSC  INC     NUMFALL                ; IF IT'S 4, ALL CHEFS HAVE FALLEN
          LDA     NUMFALL
          CMP     #4
          BNE     ZFH020

ZFH010    STX     TEMPX                  ; SAVE CURRENT CHEF INDEX
          LDX     LASTCHEF               ; LOAD LAST CHEF TO HAVE FALLEN
          LDA     #0
          STA     CACOUNT,X              ; SET COUNTER TO 0 SO IT RISES

          STA     CACOUNT+1,X
          LDX     TEMPX                  ; RESTORE CURRENT CHEF INDEX

ZFH020    STX     LASTCHEF               ; IN CASE ALL HAVE FALLEN AT ONCE
          JMP     FHNXTCH                go right to the next chef
                                         ; since this chef is dead
; END OF THE TWO LOOPS:

FHNXTFD   DEY                            ;  TEST FOR END OF FOOD LOOOP
          CPY     #FOODSTRT
          BMI     FHSKIP3
          JMP     FHLOOP2                ; IF POSITIVE, MORE FOOD
                                         ; ELSE GO ON TO NEXT CHARACTER

FHSKIP3
FHNXTCH   DEX
          DEX
          DEX
          BMI     FHSKIP2
          JMP     FHLOOP1

FHSKIP2
FHBYE     RTS

; THIS ROUTINE IS ALSO CALLED FROM "MOVE" WHEN A FOOD HITS THE WALL
;         REGISTERX GETS TRASHED

MKSPLAT   LDA     #SPLAT
          STA     CSTATE,Y

          LDA     #2
          STA     CACOUNT,Y

          LDA     #4
          STA     CFRAME,Y               ; 5 FRAMES OF ANIMATION

          TAX
          LDA     SPLATCH,X
          STA     CSTAMP,Y

          LDA     CPALW,Y
          AND     #$E0                   ; TOP THREE BITS ARE PALETTE
          ORA     SPLATPW,X
          STA     CPALW,Y


          LDA     #BLOCK2
          STA     CHSTAMP,Y

          LDA     #6                     ; THE SPLAT SOUND

          JMP     TUNIN                  same as JSR followed by RTS

; This routine also called from HOLEHIT-- "MKREJOY" to erase foods of
;         rejoicing chefs

ERASEIT   STY     TEMPY                  ; SAVE INDEX REGISTER
          LDY     HELDFOOD,X             ; ERASE FOOD
          LDA     #0
          STA     CYPOS,Y                ; STORE 0 INTO FOOD'S YPOS
          LDY     TEMPY

          RTS

          END

