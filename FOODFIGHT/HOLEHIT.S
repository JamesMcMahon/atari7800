; HOLEHIT.S
; THIS ROUTINE TESTS TO SEE IF ANY OF THE CHARACTERS HAVE RUN INTO
;         A HOLE.
;   IT'S SLIGHTLY DIFFERENT FROM THE "FOODHIT" ROUTINE, BECAUSE IT
;         MUST TEST THE CHARACTERS' FEET, RATHER THAN THE ENTIRE CHARACTER.
;         THE TABLE "CHARHITE" CONTAINS A VALUE TO BE SUBTRACTED FROM EACH
;         CHARACTERS' Y COORDINATE TO TEST AGAINST THE HOLE'S DELTA BOX.

; THE OUTER LOOP INDEX, X, IS FOR THE CHARACTER TABLE (5 CHARS X 2 ENTRIES EA)
;         THE INNER LOOP (INDEX Y) GOES THROUGH ALL THE HOLES.

          GLBL    HOLEHIT
          GLBL    MKAREJOY,MKREJOY
          GLBL    MKDIE

          GLBL    TUNIN

          GLBL    CREATOR,FALLING,LEAVING,RLEAVING,NUMHOLES
          GLBL    FYPOS,DYHOLE,FXPOS,DXHOLE,CARRYING
          GLBL    HELDFOOD,FEETFALL,STATDIEH,CSECOND
          GLBL    FSPEED,CACOUNT,CFRAME,ADDSCORE,RISEPALW,CPALW,HATHITE
          GLBL    HEADHITE,RUNNING,CSPEED,REJOYING,CHHEADS,CSTAMP,CHEFSTRT
          GLBL    FEETRISE
          GLBL    CCRUNL
          GLBL    TRUE,FINFO,HOLEUSED
          GLBL    FSTATE

          GLBL    CHARHITE,FALLSND

          GLBL    ERASEIT

          GLBL    GOD

HOLESTRT  EQU     $11

          RAMDEF                         ; ZERO PAGE

          RSEG    CODE3

HOLEHIT   LDX     #12                    ; INDEX OF LAST CHEF

HHLOOP1   LDA     CREATOR,X
          BEQ     HHSKIP1                ; DON'T LET HIM DIE IF IT'S NOT ZERO
HHNXTJMP  JMP     HHNXTCH

HHSKIP1   LDA     CYPOS,X                ; IF ZERO, HE'S NOT VISIBLE
;         BNE     HHSKIP2                ;  GO ON TO NEXT CHARACTER
          BEQ     HHNXTJMP

HHSKIP2   LDA     CSTATE,X               ; SEE IF HE'S ALREADY FALLING
          CMP     #FALLING               ; THE THREE FALLING STATES ARE
;         BMI     HHSKIP3                ;    ALL GREATER THAN "FALLING"
          BPL     HHNXTJMP               ;  AS ARE THE RISING STATES

HHSKIP3   CMP     #LEAVING
;         BNE     HHSKIP4
          BEQ     HHNXTJMP

HHSKIP4   LDA     CYPOS,X
          SEC                            ; ELSE FIND FEET
          SBC     CHARHITE,X
          STA     TEMP1                  ; THIS LOCATION IS TO BE TESTED
          LDA     CXPOS,X
          SEC
          SBC     #2
          STA     TEMP0                  ; TESTED X LOCATION

          LDY     #NUMHOLES+HOLESTRT     ; START AT LAST HOLE AND DECREMENT
          DEY                            ;  THE LAST INDEX IS ONE LESS

HHLOOP2   LDA     FSTATE,Y               ; IF "CLOSED" (ZERO), SKIP IT
          BEQ     HHNXTHL                ; IF NOT VISIBLE, STATE==CLOSED

          LDA     FYPOS,Y                ; HOLE Y
          SEC
          SBC     TEMP1                  ; FEET Y
          BPL     HHYPOS                 ; Y DIFF POSITIVE
          EOR     #$FF                   ; ELSE, DO TWO'S COMPLEMENT
          CLC
          ADC     #1

HHYPOS    CMP     #DYHOLE
;         BMI     HHXTST                 ; GO ON TO CHECK X
          BPL     HHNXTHL                ; ELSE, DO NEXT HOLE

HHXTST    LDA     FXPOS,Y
          SEC
          SBC     TEMP0                  ; CHARACTER X
          BPL     HHXPOS                 ; X DIFF POSITIVE
          EOR     #$FF                   ; ELSE, TWO'S COMPLEMENT
          CLC
          ADC     #1

HHXPOS    CMP     #DXHOLE
          BPL     HHNXTHL

; We end up here if he's falling in the hole.  Find out whether its the hero
;         or a chef, and branch accordingly.

HLKILL
          TXA                            ; CHARACTER INDEX
;         BNE     HCHFALL                if not 0, it's a chef
          BEQ     MKHFALL                else, it's charley

HCHFALL   JMP     MKFALL                 ; MAKE THIS CHEF FALL

HHNXTHL   DEY                            ;  TEST FOR END OF HOLE LOOOP
          TYA
          CMP     #HOLESTRT
          BPL     HHLOOP2                ; IF POSITIVE, MORE HOLES
                                         ; ELSE GO ON TO NEXT CHARACTER

HHNXTCH   DEX
          DEX
          DEX
          BMI     HHBYE
          JMP     HHLOOP1

HHBYE     RTS

MKHFALL   LDA     #8
          JSR     TUNIN

          JSR     MKDIE                  ; DO GENERIC DEATH STUFF ("CHEFHIT.S")

          LDA     #FEETFALL
          STA     CSTATE

          LDA     #STATDIEH              ; SO THE CHEFS WILL REJOICE
          STA     STATUS

          LDA     FYPOS,Y                ; HOLE Y POSITION
          CLC
          ADC     #4
          STA     CYPOS                  ; ADJUST HERO'S Y COORD.
          SEC
          SBC     #$10
          STA     CYPOS+1                ; FEET COORDINATE

          LDA     FXPOS,Y                ; HOLE X POS.
          CLC
          ADC     #2
          STA     CXPOS
          STA     CXPOS+1

          LDA     #$FF                    ; RANDOM NON-ZERO VALUE
          STA     CSECOND+1              ; ONLY FIRST ZONE OF FEET

          LDA     #FSPEED                ; ANIMATE TIMER
          STA     CACOUNT

          LDA     FYPOS,Y
          SEC
          SBC     #14                    ; SCAN LINE WHERE STAMPS DISSAPPEAR
          STA     CFRAME

          PLA
          PLA                            ; pop the return address off stack
          ENDCYCLE                       go back to GOD so that CONEHIT
                                         ; doesn't run
; THIS ROUTINE IS ISOMORPHIC TO THE ABOVE ROUTINE; IT'S USED TO MAKE
;         A CHEF BEGIN HIS FALL INTO AN OPEN MANHOLE.

MKFALL    STX     TEMPX
          LDX     #2                     ; 200 POINTS
          JSR     ADDSCORE
          LDX     TEMPX

          LDA     FALLSND,X
          JSR     TUNIN

          LDA     #TRUE                  ; HOLE IS IN USE DURING FALL
          STA     FINFO,Y

          TYA
          STA     HOLEUSED,X

          LDA     RISEPALW-3,X             ; CHANGE CHEF COLOR WHILE FALLING
          STA     CPALW,X                ; AND RISING
          LDA     RISEPALW-2,X
          STA     CPALW+1,X
          LDA     RISEPALW-1,X
          STA     CPALW+2,X

          LDA     CSTATE,X
          CMP     #CARRYING
          BEQ     MKF001
          JMP     MKF002

MKF001    LDA     HELDFOOD,X             ; GET CARRIED FOOD
          STX     TEMPX                  ; SAVE INDEX
          TAX                            ; FOOD INDEX
          LDA     #0
          STA     CYPOS,X
          LDX     TEMPX                  ; RESTORE INDEX

MKF002    LDA     #FEETFALL              ; START OUT WITH FEET FALLING
          STA     CSTATE,X

          LDA     FYPOS,Y                ; HOLE POSITION
          CLC
          ADC     #4                     ; TOP OF HAT
          STA     CYPOS,X                ; HAT POSITION
          SEC
          SBC     #HATHITE
          STA     CYPOS+1,X                ; HEAD POSITION
          SEC
          SBC     #HEADHITE
          STA     CYPOS+2,X                ; FEET POSITION

          LDA     FXPOS,Y                ; HOLE X POSITION
          CLC
          ADC     #2
          STA     CXPOS,X
          STA     CXPOS+2,X                ; FEET
          CLC
          ADC     #1
          STA     CXPOS+1,X                ; HEAD

          LDA     #$FF                   ; MAKE THE FEET SECOND HALF INVISO
          STA     CSECOND+2,X

          LDA     #FSPEED
          STA     CACOUNT,X

          LDA     FYPOS,Y                ; HOLE Y
          SEC
          SBC     #14
          STA     CFRAME,X               ; BOTTOM OF THE ZONE

          JMP     HHNXTCH                test the next chef

; THIS ROUTINE IS ALSO CALLED FROM "CHEFHIT"-- "HEROKILL"

MKAREJOY
          LDX     #12

ZMKR001   JSR     MKREJOY

NXTMRCH   DEX
          DEX
          DEX
          CPX     #CHEFSTRT
          BPL     ZMKR001

MRBYE     RTS

; MAKES THE CHEF IN "X" REJOICE.

MKREJOY   LDA     CSTATE,X
          CMP     #RUNNING               ; ONLY DO IT IF HE'S VISIBLE
          BEQ     ZMKR0010
          CMP     #CARRYING
          BEQ     ZMKR0020
          CMP     #FEETRISE
          BEQ     ZMKR0010
          CMP     #LEAVING               if he's leaving, make him be rleaving
;         BEQ     ZMKR0011
          BNE     MRBYE                  ; RTS
;         RTS                            no rejoice for this chef

ZMKR0011  LDA     #RLEAVING
          STA     CSTATE,X
          BNE     ZMKR0012               a jump

ZMKR0020  JSR     ERASEIT                erases carried food
                                         ; in FOODHIT.S
ZMKR0010  LDA     #REJOYING
          STA     CSTATE,X

ZMKR0012   LDA     #3
          STA     CSPEED,X
          ASL     A
          STA     CFRAME+1,X

          LDA     CHHEADS+4              ; FACE FORWARD (DOWN)
          STA     CSTAMP+1,X

          LDA     #1
          STA     CACOUNT,X

          DEC     CXPOS+2,X                ; SHIFT ARMS LEFT 1 PIXEL

          RTS

          END
