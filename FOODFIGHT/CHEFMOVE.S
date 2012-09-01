; CHEFMOVE.S
; THIS ROUTINE MAKES THE CHEFS CHASE THE HERO.
;    EACH CHEF HAS A CERTAIN POINT ON THE SCREEN TO AIM FOR.  THE
;         COORDINATES OF THIS POINT ARE STORED IN "XGOAL", "YGOAL".
;         THE FIRST PART OF THE CHEF LOOP FIGURES OUT THESE TWO VALUES
;         DEPENDING ON WHICH CHEF IS CURRENTLY BEING PROCESSED; THE LATER
;         PART MOVES THE CHEF TOWARDS THAT POINT.
;         THE METHOD OF FIGURING THE DIRECTION IS OBSCURE:
;                 DO X AND Y AXES SEPARATELY. FIRST DO THE Y AXIS.
;         FOR EACH AXIS, COMPARE THE GOAL AND THE CHEF COORDINATES-;         IF
;         EQUAL, "STA 0".  SAVE THIS VALUE IN "TEMP0" WHILE DOING THE
;         SAME FOR X AXIS.  USE THE FOLLOWING FORMULA TO DERIVE AN INDEX
;         INTO THE DIRECTION TABLE FROM THESE TWO VALUES:
;         (X + 2) * 4 + (Y + 1) - 4

          GLBL    CHASE
          GLBL    CHEFMOVE
          GLBL    MKREJOY

CHEFMOVE  LDA     STATUS                 ; IF THEY'RE WAITING AFTER A RISE,
          CMP     #STATWAIT              ;    THEN DON'T DO ANYTHING
          BNE     CHCONT0
          JMP     RISELOOP

CHCONT0    LDX     #12                    ; #CHEFSTRT+#NUMCHEF-3

DOCHEF    STX     TEMPX

          LDA     CSTATE,X               ; STATUS IS >= STATDIEH
          CMP     #REJOYING
          BMI     CHCONT12               there are two rejoice states, $15 and
          JMP     REJOICE                $16

CHCONT12  CMP     #FEETFALL              ; THREE FALLING STATES
          BNE     CHCONT1
          JMP     FTFALL

CHCONT1   CMP     #HEADFALL
          BNE     CHCONT2
          JMP     HDFALL

CHCONT2   CMP     #HATFALL
          BNE     CHCONT4
          JMP     HTFALL

CHCONT4   CMP     #HATRISE               ; THREE RISING STATES
          BNE     CHCONT5
          JMP     HTRISE

CHCONT5   CMP     #HEADRISE
          BNE     CHCONT6
          JMP     HDRISE

CHCONT6   CMP     #FEETRISE
          BNE     CHCONT7
          JMP     FTRISE

CHCONT7   CMP     #LEAVING
          BNE     CHCONT8
          JMP     CHMOVE

CHCONT8   CMP     #NOTYET                ; IF THIS IS AN EARLY RACK
          BNE     CHCONT9
          JMP     NXTCHEF

; DON'T PROCESS INVISIBLE CHEFS IF THE STATUS IS WON OR BON.
;         OR DYING !

CHCONT9
          LDA     STATUS
          CMP     #STATWON              ; IF HERO IS MUNCHING, KEEP DIRECTION
          BEQ     ZCH204
          CMP     #STATBON               ; IF FOOD IS HITTING SCORE
          BEQ     ZCH204
          CMP     #STATDIEH              ; IF CHUCK HAS DIED VIA ANYTHING
          BPL     ZCH204                 ;   ALSO HANDLES "STATEND"

          LDA     CREATOR,X              ; COUNTER FOR DEATH AND REBIRTH
          BEQ     ZCH202
ZCH201    DEC     CREATOR,X              ; IF NOT ZERO, DECREMENT

ZCH202    LDA     CYPOS,X                ; IF ZERO, GO TO CHEFWAIT
          BNE     ZCH203                 ; ELSE, MOVE HIM
          JMP     CHEFWAIT

ZCH203    LDA     CINFO,X                ; A DIRECTION-CHANGE TIMER
          BMI     ZCH100                 ; ONLY CHANGE WHEN IT REACHES 0
          DEC     CINFO,X                ;  OTHERWISE, DECREMENT AND MOVE HIM

; WE ALWAYS COME HERE BEFORE CONTINUING THROUGH THIS ROUTINE:

ZCH204    LDA     CYPOS,X                ; DO THIS TEST AGAIN FOR THE CASE
          BNE     ZCH205                 ;  WHERE THE RACK IS ENDING
          JMP     NXTCHEF                ; DON'T PROCESS DEAD CHEFS

ZCH205    JMP     CHMOVE                 ; SKIP OVER DIRECTION CHANGE STUFF

; IF WE GET HERE, IT'S TIME TO CHANGE THE DIRECTION OF THIS CHEF:

ZCH100    JSR     RANDOM                 ; RESET THE MOOD COUNTER
          AND     MOODTUFF               ; 0-$1F
          STA     CINFO,X

; THE NEXT BODY OF CODE DECIDES WHICH "GOALX, GOALY" SETTING ROUTINE
;         TO USE.

          STX     TEMP0                  ; SAVE REGISTER

          LDA     JOYDIR                 ; JOYSTICK FOR HERO
          CMP     #8                     ;  IF JOYSTICK IS CENTERED,
          BNE     SETCHASE

ALLCHASE  JMP     FCHEF                  ; FOLLOWER ALGORITHM

SETCHASE  CPX     #3                     ; FOLLOWER
          BEQ     ALLCHASE               ; IF NOT, CONTINUE FCHEF
ZCH010    CPX     #9                     ; INTERLOPER
          BNE     ZCH020                 ; IF NOT, CONTINUE
          JMP     ICHEF                  ;  INTERLOPER CHEF
ZCH020    CPX     #12                    ; ANTICIPATOR CHEF
          BNE     ZCH030
          JMP     ACHEF
ZCH030    JMP     BCHEF                  ; BEHINDOR CHEF IS THE 2ND (IDX = 6)

ZCHASE    STA     GOALY

          LDX     TEMP0                  ; RESTORE REGISTER

          JSR     CHASE                  ; SETS NEW DIRECTION
                                         ; BASED ON VALUES IN "GOALX, GOALY".

          LDA     CDIR,X                 ; NO CENTER FOR CHEFS !
          CMP     #8
          BNE     ZCHASE00

          LDA     OLDDIR,X               ; KEEP OLD DIRECTION.,
          STA     CDIR,X

; NOW SET THE HEAD TO FACE IN THIS DIRECTION:

ZCHASE00  TAY
          LDA     CHHEADS,Y              ; TELLS US THE CHARACTER
          STA     CSTAMP+1,X               ; HEAD STAMP (SECOND OF THE THREE)

CHMOVE    LDA     CDIR,X                 ; IF DIRECTION HAS CHANGED,
          CMP     OLDDIR,X               ; RESET THE DELTAS
          BEQ     CHMOVE01

          LDY     CSINDEX,X
          LDA     MTABINC,Y              ; GET INDEX FOR PROPER TABLE AND DIR
          ASL     A
          ASL     A
          ASL     A
          ADC     CDIR,X
          TAY

          LDA     STABXL,Y
          STA     CXSPEEDL,X
          LDA     STABXH,Y
          STA     CXSPEED,X
          LDA     STABYL,Y
          STA     CYSPEEDL,X
          LDA     STABYH,Y
          STA     CYSPEED,X

          LDA     CDIR,X
          STA     OLDDIR,X

CHMOVE01  JSR     MOVE                   ; DO THE ACTUAL MOVEMENT

; AT THIS POINT, CFRAME,X+1 IS THE ANIMATE COUNTER.  IF ZERO, DO THE
;         ANIMATION; ELSE, JUST SKIP EVERYTHING.

          LDA     CFRAME+1,X               ; ANIMATE COUNT IS X+1

          BNE     ZCHEFA00

CHEFANIM
          LDA     CDIR,X                 ; GET DIRECTION
          CMP     #4                     ; 0-3 GET RIGHT ANIMATION
          BPL     CHFLANIM

CHFRANIM  LDY     CACOUNT,X

          LDA     CSTATE,X
          CMP     #CARRYING              ; IF CARRYING, USE ARM
          BEQ     ZCHC00
          LDA     CHRUNR,Y               ; ELSE, DON'T
          JMP     ZCHC01

ZCHC00    LDA     CHRUNRC,Y

ZCHC01
          STA     CSTAMP+2,X             ; FEET STAMP

          JMP     ZCHEFA01

CHFLANIM  LDA     CACOUNT,X
          TAY

          LDA     CSTATE,X
          CMP     #CARRYING
          BEQ     ZCHC02

          LDA     CHRUNL,Y
          JMP     ZCHC03

ZCHC02    LDA     CHRUNLC,Y

ZCHC03
          STA     CSTAMP+2,X               ; STORE TO FEET STAMP (3RD STAMP)

ZCHEFA01   DEC     CACOUNT,X
          LDA     CACOUNT,X
          BPL     ZCHEFA00

ZCHF001   LDA     #3                     ; NUMBER OF CHEF ANIMATIONS (4 FRAMES)
          STA     CACOUNT,X

; CONTINUE PROCESSING AFTER MOVEMENT AND ANIMATION:

ZCHEFA00
          LDA     CSTATE,X
          CMP     #CARRYING
          BEQ     CHCONT31
          JMP     CHCONT3                ; IF NOT CARRYING, DON'T ADJUST
                                         ; AND DON'T DEC THRWTIME
; IF WE GET HERE, THEN CHECK FOR THROWING AND/OR ADJUSTING FOOD:

CHCONT31  JSR     FOODADJ                ; WE KNOW TO ADJUST IF HE'S CARRYING

          LDA     THRWTIME,X
          BEQ     CHTHROW

          DEC     THRWTIME,X             ; IN ANY CASE, IF TIMER IS NOT
                                         ;  0, THEN DECREMENT AND LEAVE
          JMP     CHCONT3

CHTHROW
          LDA     THRWTUFF
          STA     THRWTIME,X

          LDY     HELDFOOD,X
          LDA     CDIR,X
          STA     CDIR,Y

;         LDA     CXSPEED,X              ; SET FOOD DELTAS
;         STA     CXSPEED,Y
;         LDA     CXSPEEDL,X
;         STA     CXSPEEDL,Y

;         LDA     CYSPEED,X
;         STA     CYSPEED,Y
;         LDA     CYSPEEDL,X
;         STA     CYSPEEDL,Y

          LDA     #FLYING                ; FOR FOODMOVE
          STA     CSTATE,Y

          LDA     CTYPE,Y
          CMP     #2                     ;  IF IT'S A PIE
          BEQ     CHTH004
          CMP     #1                     ; PEAS
          BEQ     CHTH0041
CHTH0042  LDA     #0                     ; ANYTHING NOT PEAS (BANANAS)
          STA     CACOUNT,Y

          LDA     #1
          STA     CINFO,Y
          JMP     CHTH005

CHTH004   LDA     CDIR,X                 ; USE DIRECTION AS INDEX
          TAX
          LDA     PIEFLY,X
          STA     CSTAMP,Y               ; STORE STAMP
          LDA     PIEFLYPW,X
          STA     CPALW,Y                ; GET PROPER WIDTH OF STAMP
          JMP     CHTH005                a jump

CHTH0041  LDA     #1                     ; PEAS
          STA     CACOUNT,Y

          LDA     #16
          STA     CINFO,Y

CHTH005   LDA     CTYPE,Y                ; MODIFY FLYING SPEED BASED ON
          CMP     #4
          BNE     CHTH0051

          JSR     RANDOM                 ; WATERMELON CHOOSES RANDOM BEHAVIOR
          AND     #$3

CHTH0051  TAX

          LDA     FLYDIST,X              ; MODIFY DISTANCE BASED ON TYPE OF
          STA     CFLYTIME,Y             ; FOOD AND NUMBER OF CYCLES PER FRAME

; GET THE "CSINDEX" AND SET "CSPEED" AND THE DELTAS ACCORDINGLY.

          LDA     CHFLYSPD,X             ; BASED ON FOOD TYPE
          SEC
          SBC     HOWHARD                faster based on difficulty level

          JSR     SETFSPD                sets all the food speed stuff

          LDX     TEMPX

          LDA     #RUNNING               ; FREE HIM TO PICK UP MORE FOOD
          STA     CSTATE,X

CHCONT3   LDA     CXPOS,X                ; SET BOTTOM THIRD COORDS.
          STA     CXPOS+2,X                ; FEET
          STA     CXPOS+1,X                ; HEAD
          INC     CXPOS+1,X

          LDA     CYPOS,X
          SEC
          SBC     #HEADTOP               ; TOP OF THE HEAD
          STA     CYPOS+1,X
          SEC
          SBC     #FEETTOP               ; TOP OF THE FEET (3RD) STAMP
          STA     CYPOS+2,X
          JMP     NXTCHEF

; JUMP HERE IF THE CHEF'S Y COORDINATE IS ZERO (DEAD CHEF).
;         IF THE COUNTER HAS REACHED ZERO, THEN MAKE HIM APPEAR.
;         THE COUNTER TAKES UP TWO BYTES-- LOW BYTE AT CACOUNT,X
;         HIGH BYTE AT CACOUNT,X+1

CHEFWAIT  LDA     CACOUNT,X
          BEQ     CH301

          DEC     CACOUNT,X              ; LOW BYTE
          JMP     NXTCHEF

CH301
          LDA     CACOUNT+1,X              ; HIGH BYTE
          BEQ     CH3032

          DEC     CACOUNT+1,X
          LDA     #$7F
          STA     CACOUNT,X              ; LOW BYTE
          JMP     NXTCHEF

; THE CHEF CAN RISE OUT OF ANY HOLE, OPEN OR SHUT.  "CHEFDRAW" WILL OPEN
;         THE HOLE IF IT'S SHUT--

CH3032    JSR     RANDOM                 ; PICK A RANDOM OPEN HOLE
          AND     #$0F                   ; TO GET 0-F
          CMP     HOLENUM
          BMI     CH303                  ; NUMBER IS OK

CH3031    SEC                            ; KEEP SUBTRACTING UNTIL IT'S OK
          SBC     #3
          CMP     HOLENUM
          BPL     CH3031

CH303     CLC
          ADC     #HOLESTRT
          TAY
          LDA     FINFO,Y                ; IF "TRUE", SOMEONE'S RISING FROM IT
          BMI     CH3032                 ;   ALREADY

          STY     TEMPY                  ; PLACE IN Y FOR "CHEFDRAW"

          LDA     FDLPOS,Y
          AND     #$0F                   ; DISPLAY LIST
          TAX
          LDA     LISTTABL,X
          STA     LISTPTRA
          LDA     LISTTABH,X
          STA     LISTPTRA+1
          LDA     FDLPOS,Y
          AND     #$F0                   ; GET POSITION IN DLIST
          LSR     A                      ; POSITION TIMES 4
          LSR     A
          TAY

          LDA     #OPENCHAR              ; DISPLAY THE OPEN HOLE CHARACTER
          STA     (LISTPTRA),Y           ; LOW BYTE OF HEADER

          LDX     TEMPX
          LDY     TEMPY

          JSR     CHEFDRAW

NXTCHEF   DEX
          DEX
          DEX                            ; SUBTRACT THREE ! EACH CHEF IS
                                         ;    THREE CHARACTERS
          CPX     #CHEFSTRT              ; COMPARE X WITH #CHEFSTRT
          BMI     CHEFBYE
          JMP     DOCHEF
CHEFBYE
          RTS

; THE ROUTINES TO DETERMINE "GOALX, GOALY" FOLLOW:

FCHEF     LDA     CXPOS
          STA     GOALX
          LDA     CYPOS                  ; STORE ABOVE
          JMP     ZCHASE

ICHEF     LDA     CXPOS                  ; GO BETWEEN HERO AND CONE
          CLC
          ADC     FXPOS+CONESTRT        ; ADD CONE X
          LSR     A                      ; DIVIDE BY 2
          STA     GOALX

          LDA     CYPOS
          CLC
          ADC     FYPOS+CONESTRT
          ROR     A                      ; DIVIDE BY 2 (BRING IN CARRY BIT
                                         ;  SINCE IT CAN BE > 256)
          JMP     ZCHASE

ACHEF     LDX     JOYDIR                 ; USE HERO'S DIR AS INDEX TO GOAL
          LDA     XCHTAB,X               ;  COORD. TABLE
          CLC
          ADC     CXPOS                  ; IN FRONT OF HERO
          STA     GOALX

          LDA     YCHTAB,X
          CLC
          ADC     CYPOS                  ; STORE AFTER RETURN
          JMP     ZCHASE

BCHEF     LDX     JOYDIR                 ; USE SAME TABLE, BUT SUBTRACT
          LDA     CXPOS
          SEC
          SBC     XCHTAB,X               ; GO BEHIND HERO
          STA     GOALX

          LDA     CYPOS
          SEC
          SBC     YCHTAB,X               ; STORE ABOVE
          JMP     ZCHASE

; THESE TABLES TELL HOW FAR IN FRONT OF OR BEHIND THE HERO TO AIM FOR,
;         FOR THE ANTICIPATOR AND BEHINDOR.

; requires a 00 in the following table:
YCHTAB    DB      $10,$0D,$00,-$0D,-$10,-$0D,$00,$0D

XCHTAB    DB      $00,$0D,$10,$0D,$00,-$0D,-$10,-$0D,$00

CHASETAB  DB      5,6,7,$FF,4,8,0,$FF,3,2,1  ; $FF REPRESENTS IMPOSSIBLE
                                               ;  RESULTS FOR THE FORMULA

; THE FOLLOWING ROUTINES HANDLE THE THREE FALLING STAGES:

FTFALL    DEC     CACOUNT,X
          BNE     NCHFJMP                ; BNE NXTCHEF

ZFT001    LDA     #FSPEED
          STA     CACOUNT,X

          DEC     CYPOS,X                ; LOWER HAT
          DEC     CYPOS+1,X                ; LOWER HEAD
          DEC     CYPOS+2,X                ; LOWER FEET

          LDA     CYPOS+2,X                ; FEET Y POSITION
          CMP     CFRAME,X               ; BOTTOM OF ZONE
          BMI     MKHDFALL               ; IF IT'S THERE, GO TO HEAD FALL
NCHFJMP   JMP     NXTCHEF

MKHDFALL  LDA     #HEADFALL
          STA     CSTATE,X

          LDA     #$FF                   ; LOWER ZONE OF HEAD NOT VISIBLE
          STA     CSECOND+1,X

          LDA     #0
          STA     CYPOS+2,X                ; FEET POSITION-- ERASE FROM SCREEN
          BEQ     NCHFJMP                a jump

HDFALL    DEC     CACOUNT,X
          BNE     NCHFJMP                ; A JUMP TO NXTCHEF

ZHD001    LDA     #FSPEED
          STA     CACOUNT,X

          DEC     CYPOS,X                ; HAT POSITION
          DEC     CYPOS+1,X                ; HEAD POSITION

          LDA     CYPOS+1,X
          CMP     CFRAME,X               ; BOTTOM OF ZONE
          BPL     NCHFJMP                ; JUMP NXTCHEF

MKHTFALL  LDA     #HATFALL
          STA     CSTATE,X

          LDA     #$FF                   ; MAKE BOTTOM HALF OF HAT INVISO
          STA     CSECOND,X

          LDA     #0
          STA     CYPOS+1,X                ; ERASE HEAD STAMP
          JMP     NXTCHEF

HTFALL    DEC     CACOUNT,X
          BNE     NCHFJMP

ZHT001    LDA     #FSPEED
          STA     CACOUNT,X

          DEC     CYPOS,X                ; HAT POSITION
          LDA     CYPOS,X
          CMP     CFRAME,X               ; BOTTOM OF ZONE
          BPL     NCHFJMP                ; JMP NXTCHEF

FLEND     LDA     #0
          STA     CYPOS,X                ; ERASE HAT

          LDA     #DEAD
          STA     CSTATE,X

          LDY     HOLEUSED,X             ; HOLE NO LONGER IN USE
          LDA     #FALSE
          STA     FINFO,Y

          INC     NUMFALL                ; IF IT'S 3, ALL CHEFS HAVE FALLEN
          LDA     NUMFALL
          CMP     #4
          BNE     ZFL002

ZFL001    LDX     LASTCHEF               ; LOAD LAST CHEF TO HAVE FALLEN
          LDA     #0
          STA     CACOUNT,X              ; SET COUNTER TO 0 SO IT RISES
          STA     CACOUNT+1,X

          LDX     TEMPX                  ; RESTORE CURRENT CHEF INDEX

ZFL002    STX     LASTCHEF               ; IN CASE ALL HAVE FALLEN AT ONCE

          LDA     #0                     ; DISPLAY AS NORMAL WHEN REAPPEARS
          STA     CSECOND,X
          STA     CSECOND+1,X
          STA     CSECOND+2,X

          LDA     #$7F
          STA     CACOUNT,X              ; LOW BYTE OF TIMER
          LDA     #1
          STA     CACOUNT+1,X              ; HIGH BYTE OF TIMER

          JMP     NXTCHEF                ; GO TO NEXT CHARACTER

; THE FOLLOWING ROUTINES HANDLE THE CHEF RISING FROM A HOLE:


HTRISE    DEC     CACOUNT,X
          BNE     NCHFJMP2

ZHTRS01   LDA     #RZSPEED
          STA     CACOUNT,X

          INC     CYPOS,X                ; HAT Y
          INC     CFRAME,X
          LDA     CFRAME,X
          CMP     #HATHITE               ; GROW UNTIL ALL IS VISIBLE
          BNE     NCHFJMP2

MKHDRISE  LDA     #HEADRISE
          STA     CSTATE,X

          LDA     #0
          STA     CSECOND,X              ; MAKE HAT ALL VISIBLE

          LDA     CXPOS,X                ; HAT X
          CLC
          ADC     #1
          STA     CXPOS+1,X                ; HEAD X

          LDA     CYPOS,X                ; HAT Y
          SEC
          SBC     #HATHITE
          STA     CYPOS+1,X                ; HEAD Y

          LDA     #$FF
          STA     CSECOND+1,X              ; HEAD-- SECOND HALF INVISO

          LDA     #0
          STA     CFRAME,X
NCHFJMP2  JMP     NXTCHEF

HDRISE    DEC     CACOUNT,X
          BNE     NCHFJMP2

ZHDRS01   LDA     #RZSPEED
          STA     CACOUNT,X

          INC     CYPOS,X                ; HAT Y
          INC     CYPOS+1,X                ; HEAD Y

          INC     CFRAME,X
          LDA     CFRAME,X
          CMP     #HEADHITE
          BNE     NCHFJMP2               ; IF HEAD IS ALL VISIBLE

MKFTRISE  LDA     #FEETRISE
          STA     CSTATE,X

          LDA     #0
          STA     CSECOND+1,X              ; MAKE HEAD ALL VISIBLE
          STA     CFRAME,X

          LDA     #$FF
          STA     CSECOND+2,X              ; MAKE BOTTOM HALF OF FEET INVISO

          LDA     CXPOS,X                ; HAT X
          STA     CXPOS+2,X                ; FEET X

          LDA     #$38                   ; FEET STAMP
          STA     CSTAMP+2,X

          LDA     CYPOS+1,X                ; HEAD Y
          STA     CYPOS+2,X                ; FEET Y
          DEC     CYPOS+2,X

NCHFJMP3  JMP     NXTCHEF

FTRISE    DEC     CACOUNT,X
          BNE     NCHFJMP3

ZFTRS01   LDA     #RZSPEED
          STA     CACOUNT,X

          INC     CYPOS,X                ; HAT Y
          INC     CYPOS+1,X                ; HEAD Y
          INC     CYPOS+2,X                ; FEET Y

          INC     CFRAME,X
          LDA     CFRAME,X
          CMP     #FEETHITE
          BNE     NCHFJMP3               ; IF FEET ARE ALL VISIBLE

ENDRISE   LDA     #0
          STA     CSECOND+2,X              ; FEET ALL VISIBLE

          LDY     HOLEUSED,X             ; FREE HOLE FOR RISINGS
          LDA     #FALSE
          STA     FINFO,Y

          LDA     STATUS
          CMP     #STATWON               ; IF HE SHOULD RUN RIGHT AND RETREAT
          BEQ     ZER000
          CMP     #STATBON
          BEQ     ZER000
          CMP     #STATEND               should cover STATENDR also
          BPL     ZER011                 means that chuck is dead
          CMP     #STATDIEH              ; REJOICE IF GREATER THAN THIS STATE
          BMI     ZER001                 ;  ELSE, JUST START RUNNING

; Come here if STATEND or STATENDR.  If it is, then chuck could have WON
;         or be DEAD-- depending on this, chef should be LEAVING or
;         REJOICING.

ZER011    LDA     CHEFPALW-3,X             change him back from yellow
          STA     CPALW,X
          LDA     CHEFPALW-2,X
          STA     CPALW+1,X
          LDA     CHEFPALW-1,X
          STA     CPALW+2,X

          LDA     CSTATE                 make him LEAVE if CHUCK just won.
          CMP     #WON
          BEQ     ZER000

          JSR     MKREJOY                else, make him rejoice-- chuck is dead
          JMP     NXTCHEF

ZER000    LDA     #2                     ; MAKE HIM RUN RIGHT
          STA     CDIR,X

          LDA     #LEAVING               ; SO THAT HE DOESN'T CHANGE DIRECTION
          JMP     ZER0013

ZER001    LDA     #RUNNING
ZER0013   STA     CSTATE,X

ZER0012   LDA     CSPEED,X
          STA     CFRAME,X
          ASL     A
          STA     CFRAME+1,X

          LDA     #3
          STA     CACOUNT,X

          LDA     #10
          STA     CINFO,X

          LDA     STATUS
          CMP     #STATINIT
          BEQ     RWTSTRT                ; MAKE THEM SIT GREY FOR AWHILE

          LDA     CHEFPALW-3,X            ; ELSE, MAKE THIS ONE CHANGE BACK
          STA     CPALW,X                ;   TO REGULAR CHEF PALETTE
          LDA     CHEFPALW-2,X
          STA     CPALW+1,X
          LDA     CHEFPALW-1,X
          STA     CPALW+2,X

          JMP     NXTCHEF

RWTSTRT   LDA     CYCLECNT               ; WAIT FOR TWO SECONDS
          CLC
          ADC     #60
          STA     WAITCNT

          LDA     #STATWAIT
          STA     STATUS

CBIJUMP   RTS                            ; JMP CHEFBYE

RISELOOP  LDA     CYCLECNT
          CMP     WAITCNT
          BNE     CBIJUMP                a jump


RISEOVER  LDA     #STATPLAY              ; MAKE THE GAME START
          STA     STATUS

; SETUP THE OVERALL SPEED SCALING:

          JSR     MAXSET
          LDA     #$0F                   ; THE COLOR WHITE
          STA     COLORS+6               ; MAKES THE CHEFS CHANGE

          RTS                            ; JMP CHEFBYE

; This routine is also called from INIT.S & CHUCK.S

MAXSET    LDX     #1

          LDA     PLRACK
          CMP     #$10
          BMI     MAXCSET                if 1-16, set to 1
          INX                            else set to 2
MAXCSET   STX     MAXCYCLE
          RTS

; THIS ROUTINE IS USED BY CHEFS MOSTLY, BUT ALSO BY THE FOOD WHEN
;         IT MUST FLY AT THE HERO AT THE END OF A RACK.

CHASE     LDA     CYPOS,X
          LDY     #0                     for later
          SEC
          SBC     GOALY
          BPL     ZCHEF011
          EOR     #$FF
          CLC
          ADC     #1
ZCHEF011
          CMP     #4                     compares accumulator
          BCC     YEND                   ; CHASE CHUCK ON THE HORIZONTAL

          LDA     CYPOS,X                ; ELSE, SEE IF HE'S ABOVE OR BELOW
          CMP     GOALY                  ; DESTINATION Y COORD
          BCC     ZCHEF01                ; GOAL IS ABOVE
          DEY
          BNE     YEND                   a jump

ZCHEF01   INY
YEND      STY     TEMP0                  ; Y VALUE

          LDY     #0
          LDA     CXPOS,X                ; NOW DO THE X TEST
          SEC
          SBC     GOALX
          BPL     ZCHEF031
          EOR     #$FF
          CLC
          ADC     #1
ZCHEF031
          CMP     #4
          BCC     XEND                   ; CHASE ALONG THE VERTICAL

          LDA     CXPOS,X                ; ELSE, HE'S RIGHT OR LEFT
          CMP     GOALX                  ; DESTINATION X COORDINATE
          BCC     ZCHEF04                ; HERO TO THE RIGHT
          DEY
          BNE     XEND                   a jump

ZCHEF04   INY
XEND
          TYA
; NOW REGISTER A CONTAINS THE X AXIS INFO, AND "TEMP0" CONTAINS THE Y.
;         CALCULATE THE "CHASETAB" INDEX USING THE FORMULA ABOVE:

          CLC
          ADC     #2                     ; X = 1,2,3
          ASL     A
          ASL     A                      ; X = 4,8,12
          CLC
          ADC     TEMP0                  ; ADD Y = -1,0,1
          SEC
          SBC     #3                      ; Y - 3 = -4,-3,-2

          TAY
          LDA     CHASETAB,Y             ; GET DIRECTION
          CMP     #8
          BEQ     CHASEBYE
          STA     CDIR,X

CHASEBYE  RTS

; ALMOST THE SAME AS NORMAL ANIMATION, EXCEPT THERE'S NO VARIATION
;         FOR DIRECTION

REJOICE
          DEC     CFRAME+1,X
          LDA     CFRAME+1,X               ; ANIMATE COUNT IS X+1

          BEQ     REJANIM                  ; IF ZERO, ANIMATE

          JMP     NXTCHEF               ; ELSE, LEAVE THE ROUTINE

REJANIM
          LDA     CSPEED,X               ; ANIMATE COUNT IS SPEED TIMES 2
          ASL     A
          STA     CFRAME+1,X

          LDA     CACOUNT,X
          CMP     #1                     ; LAST TWO FRAMES ARE HIGHER
          BNE     REJ001
          INC     CYPOS+2,X
          LDA     CACOUNT,X
          JMP     REJ003

REJ001    CMP     #3                     ; FIRST TWO FRAMES MUST BE LOWER
          BNE     REJ003                 a jump

REJ002
          DEC     CYPOS+2,X

REJ003    LDY     CACOUNT,X

          LDA     REJOYCH,Y

          STA     CSTAMP+2,X             ; FEET STAMP

          DEC     CACOUNT,X
          LDA     CACOUNT,X
          BPL     NCJUMP                 will be a jump

ZREJ001   LDA     #3                     ; NUMBER OF CHEF ANIMATIONS (4 FRAMES)
          STA     CACOUNT,X

NCJUMP    JMP     NXTCHEF

; Used from both chuck and chefmove-- placing it here cuts the number of
;         bytes needed in half !

SETFSPD   STA     CSINDEX,Y

          TAX
          LDA     MTABSPD,X
          STA     CSPEED,Y
          STA     CFRAME,Y

          LDA     MTABINC,X              ; TELLS WHICH INCREMENT TABLE TO USE
          ASL     A                      ; MULTIPLY BY 8 FOR TABLE BASE
          ASL     A
          ASL     A
          ADC     CDIR,Y                 ; GET INCREMENT FOR THIS DIRECTION
          TAX

          LDA     STABXL,X             ; SET FOOD DELTAS
          STA     CXSPEEDL,Y
          LDA     STABXH,X
          STA     CXSPEED,Y

          LDA     STABYL,X
          STA     CYSPEEDL,Y
          LDA     STABYH,X
          STA     CYSPEED,Y

          RTS

