; CHUCK.S
;
; THE CHUCK DRIVER FIRST POLES THE JOYSTICK AND SETS HERODIR AND HEROSTAT
;         APPROPRIATELY.  THE JOYSTICK IS READ AS 8-POSITION; 0 IS NORTH,
;         AND THE OTHER DIRECTIONS ARE NUMBERED CLOCKWISE.
;    IT THEN DOES MOTION AND ANIMATION IF THE COUNTERS HAVE DECREMENTED TO
;         0.

          GLBL    CHUCK
          GLBL    SCRAPALL,TUNIN

          GLBL    GAME
          GLBL    AFDERASE
          GLBL    CCHEADS
          GLBL    MKPROMPT
          GLBL    FLYCHAR,FLYPALW        ; IN "PILEHIT.S"

          GLBL    CCRUNL,CHHEADS,MUNCHPW,MUNCHLOW,MUNCHHI

          GLBL    COLRINIT,NEWGAME
          GLBL    KERNEL,MKLOGO,LOGOLOOP,CHARINIT,RACKINIT,PUTSCORE
          GLBL    PUTSC2
          GLBL    DPPINIT
          GLBL    STATDISP

BASEBON   EQU     11                    ; FIRST BONUS SCORE INDEX

          RSEG    CODE3

CHUCK     LDA     STATUS
          CMP     #STATINIT              ; IF CHEFS ARE RISING, ONLY SET DIR.
          BEQ     ZCKCONT2
          CMP     #STATWAIT
          BEQ     ZCKCONT2

          CMP     #STATHIT               ; IF FOOD IS HITTING CHUCK, DO NOTHING
          BNE     ZCKCONTA
          RTS                            ; JMP HEROBYE

ZCKCONTA  CMP     #STATDIE               ; IF EYES ARE ROLLING
          BMI     ZCKCONT9
          JMP     EYEROLL

ZCKCONT9  CMP     #STATWON
          BNE     ZCKCONT8
          JMP     MUNCH                  ; IF HERO IS EATING THE CONE

ZCKCONT8  CMP     #STATBON               ; IF FOOD IS FLYING, DO NOTHING
          BNE     ZCKCONT7
          RTS                            ; JMP HEROBYE

ZCKCONT7  LDA     CSTATE
          CMP     #FEETFALL
          BNE     ZCKCONT1
          JMP     CFTFALL               ; IF HIS FEET ARE FALLING, HEAD OK

ZCKCONT1  CMP     #HEADFALL
          BNE     ZCKCONT2
          JMP     CHDFALL               ; IF THE FEET ARE GONE, HEAD FALLING

ZCKCONT2
          LDA     JOYDIR                 ; IF JOYSTICK CENTERED, DON'T
          CMP     #8                     ;   MOVE OR ANIMATE
          BNE     ZCHK011
          JMP     ZCHUCK00

ZCHK011   STA     CDIR                   ; ELSE, USE THIS DIRECTION FOR
                                         ;   ANIMATION, MOVEMENT, ETC.
          TAY                            ; SET THE HEAD FACING STAMP
          LDA     CCHEADS,Y
          STA     CSTAMP

; NOTE: THE CARRYING ARM STAMP IS ALWAYS SET, EVEN IF JOYSTICK IS CENTERED,
;         IN "ZCHUCK04" BELOW.

ZCHK002   LDA     STATUS
          CMP     #STATINIT              ; DON'T CONTINUE IF RACK IS STARTING
          BEQ     ZCKJMP3

          CMP     #STATWAIT              ; DON'T CONTINUE IF CHEFS ARE WAITING
          BNE     ZCKCONT4

ZCKJMP3   LDA     CSTATE                 ; COME HERE IF STATUS IS "INIT" OR
          CMP     #CARRYING              ;        "WAIT"
          BNE     ZCKJMP4

          JMP     ZCHUCK04               ; ADJUST ARMS AND FOOD
ZCKJMP4   JMP     ZCHUCK05               ; NOT CARRYING-- LEAVE ROUTINE

ZCKCONT4  TYA                            ; NEW DIRECTION
          CMP     OLDDIR
          BEQ     ZCKCONT5               ; NO NEED TO SET IF NOT CHANGED

          LDA     CSINDEX
          TAX
          LDA     MTABINC,X
          ASL     A
          ASL     A
          ASL     A
          ADC     CDIR                   ; NOW CONTAINS AN INDEX TO THE
          TAX                            ;   DELTA TABLES

          LDA     STABXH,X               ; SET SPEED FOR THIS DIRECTION
          STA     CXSPEED
          LDA     STABXL,X
          STA     CXSPEEDL
          LDA     STABYH,X
          STA     CYSPEED
          LDA     STABYL,X
          STA     CYSPEEDL

          STY     OLDDIR

ZCKCONT5  LDX     #HEROSTRT              ; ARGUMENT FOR "MOVE" ROUTINE
          JSR     MOVE                   ; MOVE THE HERO

          LDA     CFRAME+1               ; ANIMATE COUNT IS AFTER FRAME COUNT
                                         ; IF ZERO, ANIMATE
          BNE     ZCHUCK00               ; ELSE, LEAVE THE ROUTINE

CHANIM    LDA     CDIR
          BEQ     ZCHKA00                ; STRAIGHT UP-- RUN LEFT
          LSR     A
          LSR     A
          JMP     ZCHKA01
ZCHKA00   LDA     #1                     ; BIT 0 IS LEFT/RIGHT
ZCHKA01   ORA     CSTATE                 ; BIT 1 IS CARRYING/ NOT
          TAX
          LDA     CHKCHOFF,X
          CLC
          ADC     CACOUNT                ; CURRENT FRAME
          TAX
          LDA     CHUCKRUN,X             ; CHOOSES PROPER STAMP FROM 4 TABLES
          STA     CSTAMP+1

          DEC     CACOUNT
          LDA     CACOUNT
          BPL     ZCHUCK31               ; NO NEED TO RESET IF >= 0

          LDA     #5                     ; 6 FRAMES OF FEET ANIMATION
          STA     CACOUNT
          JMP     ZCHUCK00               ; DOWN END OF BOUNCE

; NOW HANDLE THE BOUNCE IN HIS STEP ON THE 3RD AND 0TH FRAMES:

ZCHUCK31  CMP     #4
          BEQ     ZCHUCK33               ; BOUNCE IN STEP
          CMP     #1                     ;  AT 4 AND 1
          BEQ     ZCHUCK33

          CMP     #3                     ; DOWN OF BOUNCE, AND FOOTSTEP SOUND
          BEQ     ZCHUCK34
          CMP     #0
          BEQ     ZCHUCK34
          BNE     ZCHUCK00               ; SAME AS A JUMP

ZCHUCK33  LDA     CYPOS
          CLC
          ADC     #1
          STA     CYPOS
          JMP     ZCHUCK00

ZCHUCK34  LDA     #5
          JSR     TUNIN

          LDA     CYPOS
          SEC
          SBC     #1
          STA     CYPOS

; MOVEMENT AND ANIMATION ARE OVER, OR JUST NOT DONE.  CHECK TO SEE IF
;         CHUCK SHOULD THROW AND/OR CALL "CFOODADJ":

ZCHUCK00  LDA     CSTATE
          CMP     #CARRYING
          BEQ     ZTHTEST                 ; IF CARRYING, TEST THE THROW BUTTON
          JMP     ZCHUCK05               ; IF NOT CARRYING, LEAVE ROUTINE

ZTHTEST   LDA     STATUS                 don't let him throw if chefs are
          CMP     #STATINIT              rising
          BEQ     ZJMP4                  a jump
          CMP     #STATWAIT
          BEQ     ZJMP4                  a jump

ZTHTESTA  LDA     THRWTIME
          BEQ     ZTHTEST1
          DEC     THRWTIME
ZJMP4     JMP     ZCHUCK04               ; IF NOT DEBOUNCED, ADJUST FOOD AND
                                         ;       ARMS
ZTHTEST1  LDA     THROWBUT
          BNE     THROW
          JMP     ZCHUCK04               ; ADJUST FOOD AND ARMS

THROW     LDA     #10
          STA     THRWTIME               ; DEBOUNCING FOR THROW BUTTON

          LDA     #3
          JSR     TUNIN

          LDY     HELDFOOD
          LDA     CDIR
          STA     CDIR,Y

          TAX                            ; USE AS INDEX FOR POSITIONING
          LDA     CXPOS
          CLC
          ADC     CTHXPOS,X              ; ADJUST FOOD TO CENTER OF HEAD
          STA     CXPOS,Y

          LDA     CYPOS
          CLC
          ADC     CTHYPOS,X
          STA     CYPOS,Y

          LDA     #FLYING                ; SO THAT FOOD DRIVER MOVES IT
          STA     CSTATE,Y

; CTYPE SHOULD HAVE BEEN COPIED FROM CINFO BY "TAKEFOOD", SINCE "CINFO"
;         IS NOW A TIMER.

          LDA     CTYPE,Y
          CMP     #2                     ; PIE TYPE IS 2
          BEQ     ZTH004
          CMP     #1                     ; PEAS
          BEQ     ZTH0041

ZTH0042    LDA     #01                   ; ANYTHING NOT PEAS
          STA     CINFO,Y                ; FOR ALL TYPES OTHER THAN PEAS

          LDA     #0
          STA     CACOUNT,Y
          JMP     ZTH005

ZTH004     LDA     CDIR                   ; USE DIRECTION AS TABLE INDEX
          TAX
          LDA     PIEFLY,X               ; GET STAMP
          STA     CSTAMP,Y               ; STORE IT
          LDA     PIEFLYPW,X             ; GET PALETTE WIDTH
          STA     CPALW,Y

          JMP     ZTH005

ZTH0041    LDA     #1                     ; IF IT'S PEAS, SET UP FOR DISPERSAL
          STA     CACOUNT,Y              ; FRAME INDEX

          LDA     #8
          STA     CINFO,Y

; calculate throw speed.  Vary speed with MAXSET-- multiply by 4
;         to get base address of a table to be indexed by food type.

ZTH005    JSR     MAXSET
          DEX
          TXA
          ASL     A
          ASL     A
          STA     TEMP0

          LDA     CTYPE,Y                ; MODIFY FLYING SPEED BASED ON
          CMP     #4
          BNE     ATH0051                ; NOT WATERMELON

          JSR     RANDOM                 ; WATERMELON CHOOSES RANDOMLY
          AND     #$3

ATH0051   TAX
          LDA     FLYDIST,X              ; MODIFY DISTANCE BASED ON TYPE OF
          STA     CFLYTIME,Y             ; FOOD

          TXA
          ORA     TEMP0
          TAX

; GET THE "CSINDEX" AND SET "CSPEED" AND THE DELTAS ACCORDINGLY.

          LDA     FLYSPEED,X             ; BASED ON FOOD TYPE

          JSR     SETFSPD                in chefmove.s

          LDA     #RUNNING               ; FREE HIM TO PICK UP MORE FOOD
          STA     CSTATE

          LDA     CCRUNL                 ; JUST SO THAT THERE'S NO BLANK SPACE
          STA     CSTAMP+1

          LDA     #0                     ; ERASE THE ARM STAMP
          STA     CYPOS+2

          JMP     ZCHUCK05

; AT THIS POINT, ADJUST CARRIED FOOD AND SET CARRYING ARM STAMP:

ZCHUCK04
          JSR     CFOODADJ                ; ADJUST THE FOOD BY THE HERO

          LDA     CDIR                   ; SET THE PROPER ARM STAMP
          TAY
          LDA     CCARMS,Y
          STA     CSTAMP+2

; WHEN I GET HERE, ALL PROCESSING IS DONE-- JUST SET THE BODY AND FEET
;         TO FOLLOW THE HEAD.

ZCHUCK05
          LDA     CXPOS
          STA     CXPOS+1                ; SAME FOR UPPER AND LOWER HALF

          LDA     CYPOS
          SEC
          SBC     #12                    ; 12 SCAN LINES DOWN
          STA     CYPOS+1                ; FOR LOWER HALF

          LDA     CSTATE                 ; IF CARRYING, ADJUST ARMS
          CMP     #CARRYING
          BNE     HEROBYE

          LDA     CDIR
          BEQ     ZCHK021                ; UP IS "LEFT"
          CMP     #4
          BPL     ZCHK021

          LDA     CXPOS                  ; RIGHT
          SEC
          SBC     #3
          STA     CXPOS+2
          JMP     ZCHK022

ZCHK021   LDA     CXPOS
          SBC     #2                     ; CARRY MUST BE SET
          STA     CXPOS+2

ZCHK022   LDA     CYPOS
          SEC
          SBC     #4                     ; MOVE ARMS DOWN 4 PIXELS
          STA     CYPOS+2

HEROBYE   RTS

; THE FOLLOWING CODE HANDLES THE HERO FALLING THROUGH A HOLE.

CFTFALL   DEC     CACOUNT
          BNE     HEROBYE

          LDA     #FSPEED                ; FALL FRAME COUNTER
          STA     CACOUNT

          DEC     CYPOS                  ; LOWER HEAD ONE
          DEC     CYPOS+1                ; LOWER FEET ONE
          LDA     CYPOS+1
          CMP     CFRAME                 ; IF FEET HAVE PASSED BOTTOM OF ZONE,
          BMI     ZCHFL010                ;    THEN ERASE THE FEET.
          RTS                            ; JMP HEROBYE

; MAKE THE HEAD START TO FALL; ERASE THE FEET ALTOGETHER--

ZCHFL010   LDA     #HEADFALL
          STA     CSTATE

          LDA     #$FF                   ; RANDOM NON-ZERO VALUE
          STA     CSECOND                ; HEAD STAMP

          LDA     CFRAME
          CLC
          ADC     #14                    ; POSITION TOP OF HEAD AT TOP OF ZONE
          STA     CYPOS

          LDA     #0
          STA     CYPOS+1                ; MAKE FEET STAMP INVISIBLE
          RTS                            ; JMP HEROBYE

CHDFALL   DEC     CACOUNT
          BNE     HEROBYE

          LDA     #FSPEED                ; RESET ANIMATE COUNTER
          STA     CACOUNT

          DEC     CYPOS                  ; LOWER HEAD ONE
          LDA     CYPOS
          CMP     CFRAME                 ; IF HEAD HAS REACHED BOTTOM OF ZONE,
          BMI     CFLEND                 ;    ERASE IT !
          RTS                            ; JMP HEROBYE

CFLEND    LDA     #0
          STA     CYPOS

          JSR     AFDERASE               ; ERASE ALL CURRENT FOODS

          LDA     #STATEND               ; MAKE "GAME" LOOP 3 SECONDS
          STA     STATUS

          LDA     #95
          STA     WAITCNT

          LDA     #DEAD
          STA     CSTATE                 ; THIS WILL MAKE GAMELOOP EXIT

          RTS                            ; JMP HEROBYE

; IF THE STATUS == "STATDIE", JUMP HERE AND HANDLE THE EYES ROLLING.

EYEROLL   LDA     CYCLECNT
          CMP     CINFO
          BCS     ZIROLL0               ; WAIT TILL CYCLECNT REACHES CINFO
          RTS                            ; JMP HEROBYE

ZIROLL0  CLC                            ; "CYCLECNT" IS ALREADY IN A
          ADC     #2
          STA     CINFO
          DEC     CDIR
          BMI     ZIROLL2
          LDA     CDIR
          JMP     ZIROLL3

ZIROLL2  LDA     #7
          STA     CDIR

ZIROLL3  TAY                            ; USE DIRECTION AS INDEX
          LDA     CCHEADS,Y
          STA     CSTAMP                 ; MAKE EYES ROLL

          LDA     SYSCOUNT
          CMP     #245
          BCS     ENDROLL
          RTS                            ; JMP HEROBYE

ENDROLL   LDA     #STATHIT               ; MAKE FOOD HIT CHUCK
          STA     STATUS

          JSR     AFDERASE

          LDA     #SADCHAR
          STA     CSTAMP

          LDA     #2
          STA     MAXCYCLE

          LDA     #BLOCK2
          STA     CHSTAMP

          RTS                            ; JMP HEROBYE

; THE ROUTINE BRANCHES HERE IF CHUCK IS EATING THE CONE

MUNCH     DEC     CACOUNT                ; ANIMATE COUNTER
          BEQ     ZMUNCH00
          RTS                            ; JMP MUNCHBYE

ZMUNCH00   LDA     CSPEED
          STA     CACOUNT

          LDA     CFRAME
          BMI     ZMCLOSE                 ; BIT 8 SET MEANS MOUTH CLOSING
          JMP     ZMOPEN

ZMCLOSE    INC     CFRAME
          LDA     CFRAME
          AND     #$7F
          CMP     #6
          BMI     ZMCONT01
          JMP     MKSMILE                ; MUNCH IS FINISHED

ZMCONT01  STA     TEMP0
          LDA     #5
          SEC
          SBC     TEMP0
          STA     TEMPX                  ; USED FOR TONGUE ANIMATION

          JMP     ZMUNCH01

ZMOPEN     DEC     CFRAME
          BMI     AMKCLOSE               ; IF OPEN IS FINISHED

          LDA     CFRAME
          CLC
          ADC     #6
          STA     TEMPX                  ; USED FOR TONGUE ANIMATION

          JMP     ZMUNCH01

AMKCLOSE  LDA     #$80                   ; VALUE OF 0; HIGH BIT SET
          STA     CFRAME

          LDA     DOITOVER
          BNE     ZMKCL00                ; IF IR, DON'T CLEAR TUNE !

          JSR     SCRAPALL

          LDA     #28
          JSR     TUNIN
          LDA     #29
          JSR     TUNIN

ZMKCL00   LDA     #5