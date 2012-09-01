*         SPHINX--SGAME.S


	org	$E000

* THIS ROUTINE DRIVES THE BIRD AND ITS SHOTS.  IT HANDLES ANIMATING THE BIRD
* THROUGH ITS STATE MACHINE, COLLISIONS FOR BIRD, MOVING AND GENERATING SHOTS,
* AND THEIR COLLISIONS.  IT BRINGS BIRD BACK TO LIFE AND SUCH.

ZBIRDZ    EQU     80                     ;Z COORDINATE OF BIRD
ZXLIMLOW  EQU     56                     ;LIMITS ON X MOTION
ZXLIMHI   EQU     121
ZYLIMLOW  EQU     5                      ;Y WHEN BIRD ON GROUND
ZYLIMHI   EQU     45                     ;LIMIT ON Y MOTION

*         GAME
GAME:
          LDA     #0                     ;CLEAR MOVEMENT FLAG
          STA     TEMP7                  ; MOVEMENT FLAG IS TEMP7 (OBVIOUSLY)

          LDA     DEATH                  ;DON'T READ JOYSTICK WHEN BIRD IS DEAD
          BEQ     LIVE
          JMP     DIE                    ;INSTEAD, GO TO DEAD BIRD HANDLER


*         READ JOYSTICK OR SIMULATED JOYSTICK
LIVE:
	jsr	autoPower	;Check for auto powers.
	bcs	ok2		;Invoke power automatically?

	LDX	PLAYER
	LDA     RIGHTBUT,X             ;CHECK FIRE BUTTON FOR POWER
	BMI     STKCHK

ok2:	JSR     GIVPOWER               ;RIGHT BUTTON PRESSED SO POWER???

STKCHK:   BIT     AUTOPLAY               ;AUTOPLAY MODE??
          BPL     LDASWCHA               ;IF NO AUTOPLAY, LOAD JOYSTICK

          LDA     MAINCNT                ;DO WE CHANGE INPUT VECTOR?
          AND     #$1F                   ;CHANGE INPUT EVERY 32 MAINCNTS

          BEQ     THIS2                  ;YES, GOTO THIS2
          LDA     IOSIM                  ;NO JUST USE IOSIM AS USUAL
          JMP     LSRA

THIS2:    JSR     RANDOM                 ;GENERATE NEW INPUT VECTOR
          AND     #$0F
          TAX                            ;READ VALUE OUT OF TABLE
          LDA     JOYSIM,X
          STA     IOSIM
          BNE     LSRA                   ;WATCHOUT!

LDASWCHA: BIT     WARP
          BPL     LDASWCH1


          LDA     PHASE                  ;SEE IF WARP IS LEGAL
          BEQ     LDAWARP

          LDA     #0                     ;THIS HAPPENS WHEN WE REACH THE SPHINX
          STA     WARP
	jsr	powerOff
	jmp	LDASWCH1


LDAWARP:  LDA     #$0D                   ;FORCE CLIMB DURING WARP POWER
          BNE     LDXXTBL


LDASWCH1: LDA     SWCHA                  ; CHECK JOYSTICK
          LDX     PLAYER
          BEQ     LSRA
          AND     #$0F                   ;IF IT AINT 1 THEN ITS 2 SO
          BNE     LDXXTBL                ;JOYSTICK CAN NEVER BE 0

LSRA:     LSR                            ;LOOK AT PLAYER1 FOR NOW (TOP NIBBLE)
          LSR
          LSR
          LSR


*         TURN BACK ON THOSE BITS THAT ARE TO BE IGNORED
LDXXTBL:  LDX     XTBL+ZBIRD             ; SET BITS FOR DIRS HE CANT MOVE
          CPX     #ZXLIMLOW+1            ;BY CHECKING LIMITS OF MOTION
          BCS     CKBIRDXH
          ORA     #4                     ; SET WEST BIT
          BNE     CKBIRDYH

CKBIRDXH: CPX     #ZXLIMHI
          BCC     CKBIRDYH
          ORA     #8                     ; SET EAST BIT

CKBIRDYH: LDX     YTBL+ZBIRD
          CPX     #ZYLIMHI
          BCC     CKBIRDON
          ORA     #2                     ; SET SOUTH BIT

CKBIRDON:
          STA     TEMP0                  ;THIS IS "FIXED" JOYSTICK VALUE

;         LDX     YTBL+ZBIRD             ;ALREADY IN X
          CPX     #ZYLIMLOW
          BNE     INTHEAIR

          BIT     SWIMMING
          BPL     CLLTYPE

          BIT     CANTSWIM               ;HACK FOR CANT SWIM POWER
          BPL     SWIMFOO
          LDA     TEMP0
          ORA     #$D                    ;PROHIBIT ANY BUT SOUTH
          STA     TEMP0
SWIMFOO:
          LDX     #ZBIRD                 ;BIRD'S OBJECT NUMBER
          LDA     #0                     ;Z OFFSET IS 0

          STA     TEMP4                  ;IF SWIMMING, ENTER GRNDTYPE WITH
          STX     TEMP3                  ;FIXED VP TO AVOID SANDFUCKER MODE
          LDA     VPTBL,X
          SEC
          SBC     #3                     ;VP ADJUST FOR SWIMMING
          JSR     GRNDFLO
          JMP     POSTGTFL

CLLTYPE:
          BIT     CANTHOP
          BPL     HOPFOO
          LDA     TEMP0
          ORA     #$D
          STA     TEMP0
HOPFOO:
          LDX     #ZBIRD                 ;BIRD'S OBJECT NUMBER
          LDA     #0                     ;Z OFFSET IS 0
          JSR     GRNDTYPE               ; CHECK CHAR UNDER BIRD

POSTGTFL: CMP     #126                   ;A MAGIC NUMBER IF I EVER SAW ONE
          BCC     NOWATER

          LDA     #$80
          STA     SWIMMING

          LDA     TEMP0                  ;JOYSTICK
          CMP     #$F
          BEQ     NOSWIM2                ;ONLY MAKE SWIMMING SOUND WHEN MOVING

          LDA     #SWIM                  ;START SWIM SOUND
          CMP     TUNNUM
          BEQ     JOHNTMPS
          CMP     TUNNUM+1
          BEQ     JOHNTMPS
          JSR     TUNIN

          JMP     JOHNTMPS

INTHEAIR:
          BIT     CANTFLY
          BPL     NOWATER
          LDA     #$E
          STA     TEMP0
NOWATER:  LDA     SWIMMING
          AND     #$7F
          STA     SWIMMING
NOSWIM2:  LDA     #SWIM
          JSR     SCRAPONE

JOHNTMPS:

          LDX     TEMP0                  ;JOYSTICK
          LDA     JOYTBL,X               ;GET ACTION FROM TABLE

          LDY     YTBL+ZBIRD             ;BIRD'S Y AFFECTS ACTION
          CPY     #5+ZYLIMLOW            ;5 + 4 ARE SPECIAL SYNCHRONIZED STATES
          BCS     NOSWAP
          CPY     #4+ZYLIMLOW
          BEQ     SWAP

                  ;IF Y IS <=3 THEN LOOK TO SEE IF THERE IS WATER

          BIT     SWIMMING               ;WATER ALSO AFFECTS
          BMI     NOSWAP                 ; DON'T SWAP IF OVER WATER

SWAP:     LSR                            ;SHIFT TO TOP NIBBLE IF OVER WATER
          LSR
          LSR
          LSR

NOSWAP:
          AND     #$F
          STA     TEMP1
          LDA     BIRDSTAT
          LSR
          LSR
          LSR
          LSR
          TAX                            ;THIS REPLACES THE HUGE ANIM TABLE
          LDA     BIRDATBL,X
          BPL     BADIRECT
          AND     #$7F
          CLC
          ADC     TEMP1
          TAX
          LDA     BIRDAI,X
BADIRECT: STA     TEMP4

          AND     #$1F
          TAY

          LDA     TEMP1                  ;PREPARE X FOR STATE LOOKUP
          ORA     BIRDSTAT               ;ORA ON BIRDSTAT FOR TOP BITS
          TAX

          LDA     BIRDANAD,Y             ;GET POINTER TO GRAPHCS
          STA     SLTBL+ZBIRD

          LDA     SHADANAD,Y             ;GET GRAPHCS FOR SHADOW
          STA     SLTBL+ZSHAD

          STY     TEMP8                  ; SAVE FOR GETTING OFFSETS IN PROJECT

TESTPNT:  LDA     STATETBL,X             ;USE STATE TO GET SCROLL RATE
          AND     #$F
          TAY

          LDA     YTBL+ZBIRD
          CMP     #ZYLIMLOW
          BNE     PUNTRUN                ;FOR TAKEOFF

          BIT     SWIMMING
          BMI     PUNTRUN

          LDA     TEMP0
          CMP     #$F
          BEQ     PUNTRUN

          LDA     #$40
          STA     SWIMMING

          LDA     #RUNNING
          CMP     TUNNUM
          BEQ     DOSCROLL
          CMP     TUNNUM+1
          BEQ     DOSCROLL

          JSR     TUNIN
          JMP     DOSCROLL

PUNTRUN:
          LDA     #RUNNING
          JSR     SCRAPONE

          LDA     SWIMMING
          AND     #$BF
          STA     SWIMMING

DOSCROLL: LDA     PHASE
          CMP     #2
          BEQ     ZROSCRAT               ;SPHINX IS STOPPED

          CPY     #$F
          BEQ     SAMSCRAT               ;STAY STATE

          CPY     #$E
          BNE     NMLSCRAT               ;NOT HOPPING
          LDA     TEMP0                  ;JOYSTICK VALUE
          CMP     #$07                   ;EAST
          BEQ     ZROSCRAT
          CMP     #$0B                   ;WEST
          BEQ     ZROSCRAT

NMLSCRAT: BIT     WARP
          BPL     NMLSCRA1
          LDA     #$20
          BPL     STRSCRAT

NMLSCRA1: LDA     SCRATBL,Y
          BPL     STRSCRAT               ;NEAR GROUND - ABSOLUTE CONTROL

          BIT     HOVER
          BMI     ZROSCRAT

          STX     TEMP6                  ;SAVE X

          LDX     PLAYER
          LDA     RACK,X

          LDX     #2                     ;MININUM FLYING SCRATE

          CMP     #1
          BCC     BNSSCRAT
          INX

          CMP     #3
          BCC     BNSSCRAT
          INX

          CMP     #7
          BCC     BNSSCRAT
          INX

          CMP     #12
          BCC     BNSSCRAT
          INX

          CMP     #20
          BCC     BNSSCRAT
          INX

BNSSCRAT: TXA
          CLC
          ADC     DIFCULTY		;Range 0-3

          LDX     PHASE
          CPX     #$FE                   ;ACTUAL BONUS
          BNE     ENDSCRAT

          CLC
          ADC     #2

ENDSCRAT: BIT     SPEEDUP
          BPL     ENDSCRA2
          ASL
          JMP     ENDSCRA3

ENDSCRA2: LDX     SLOWDOWN
          BPL     ENDSCRA3
          LSR

ENDSCRA3: CMP     #3
          BNE     ENDSCRA1
          LDA     #2                     ;SCRATE = 3 LOOKS TOO SHITTY
ENDSCRA1: STA     SCRATE
          LDX     TEMP6                  ;RESTORE X

          LDA     YTBL+ZBIRD
          SEC
          SBC     #ZYLIMLOW
          BEQ     SAMSCRAT               ;ON GROUND

          CMP     SCRATE
          BCS     SAMSCRAT               ;SCRATE OK

          STA     SCRATE                 ;LIMIT SCRATE NEAR GROUND
          BCC     SAMSCRAT               ;ALWAYS

ZROSCRAT: LDA     #0
STRSCRAT: STA     SCRATE

SAMSCRAT: LDA     ADELTBL,Y              ;CHECK FOR CHANGE OF AIMATION
          INC     BIRDACNT
          CMP     BIRDACNT
          BCS     NONEWSTA               ; NOT TIME FOR NEXT ANIMATION

          LDA     #0                     ;DO NEW ANIMATION
          STA     BIRDACNT
          LDA     STATETBL,X             ;TOP OF STATE IS NEW BIRDSTAT
          AND     #$F0
          STA     BIRDSTAT

NONEWSTA: LDA     SCRATE
          LSR
          LSR
          CLC
          ADC     #2
          STA     TEMP10

          LDA     TEMP0                  ;THIS IS JOYSTICK VALUE
          LDX     YMODTBL,Y              ;CHECK FOR Y MOTION
          BEQ     NONEWY
          BMI     YMOVE

          STX     YTBL+ZBIRD
          LDX     #$FF
          STX     TEMP7                  ; SET MOVEMENT FLAG
          JMP     NONEWY

YMOVE:    LSR     
          BCS     CKUP                   ;LOOK FOR DOWN BIT (NORTH)

          TAX

          LDA     YTBL+ZBIRD
          SEC
          SBC     TEMP10

          BMI     FIXYNEG
          CMP     #ZYLIMLOW+3
          BCS     GOTYDN
FIXYNEG:  LDA     #ZYLIMLOW+3

GOTYDN:   STA     YTBL+ZBIRD
          TXA

          LDX     #$FF
          STX     TEMP7                  ; SET MOVEMENT FLAG
          LSR     
          JMP     CKNEWX

CKUP:     LSR                           ;CHECK FOR UP (SOUTH)
          BCS     CKNEWX

          TAX

          LDA     YTBL+ZBIRD
          CLC
          ADC     TEMP10

          CMP     #ZYLIMHI
          BCC     GOTYUP
          LDA     #ZYLIMHI

GOTYUP:   STA     YTBL+ZBIRD
          TXA

          LDX     #$FF
          STX     TEMP7                  ; SET MOVEMENT FLAG
          JMP     CKNEWX

NONEWY:   LSR                           ;THIS CATCHES A UP IN SHIFTING
          LSR     

CKNEWX:   INC     BIRDXCNT               ;MOVE IN X DIR IN SAME WAY.
          LDX     XDELTBL,Y
          BEQ     PROJ

          CPX     BIRDXCNT
          BCS     PROJ                   ; NOT TIME TO UPDATE X

          LDX     #1                     ;RESET X COUNTER
          STX     BIRDXCNT

          LSR                           ;LOOK FOR WEST
          BCS     CKRIGHT

          LDA     XTBL+ZBIRD             ;DO THIS ON WEST
          SEC
          SBC     TEMP10
          STA     XTBL+ZBIRD

          LDX     #$FF
          STX     TEMP7                  ; SET MOVEMENT FLAG
          BMI     PROJ                   ;JMP

CKRIGHT:  LSR                           ;LOOK FOR EAST
          BCS     PROJ
          LDA     XTBL+ZBIRD             ;DO THIS ON EAST

          CLC
          ADC     TEMP10
          STA     XTBL+ZBIRD

          LDX     #$FF
          STX     TEMP7                  ; SET MOVEMENT FLAG

PROJ:     JSR     PROJECT                ;MAP X,Y,Z TO HP,VP


*         COLLISION DETECTION FOR BIRD IS DONE HERE

          BIT     WARP
          BMI     SURVIVE                ;DON'T DETECT COLISIONS DURING WARP

          JSR     DOCOL                  ;DO COLLISION DETECTION
          CMP     #TREASCOL              ;SURVIVE IF ZERO RETURNED OR IF
          BCC     SURVIVE                ;IT HIT A HIERO

	CMP	#FLEACOL		;Did the bird run into a flea?
	BNE	CC1
;
	lda	FLEANIM-FLEADEX,x	;Is flea blowing up?
	cmp	#15
	bcc	.kill
	cmp	#24
	bcc	SURVIVE
	cmp	#29
	bcc	.kill
	cmp	#33
	bcc	SURVIVE
	cmp	#37
	bcc	.kill
	cmp	#41
	bcc	SURVIVE
;
.kill:	JSR	KILLFLEA		;Kill flea when run into by bird.
	JMP	STOP1			;Bird is also killed in the collision.

CC1:      CMP     #SXSHTCOL              ;WAS IT WITH A SPHINX SHOT
          BNE     CC2
          LDA     #0
          STA     SXSHTSTT-SPHXSHOT,X
          JSR     OBJDEL                 ;DELETE SHOT WHICH HIT YOU
          TXA
          CLC
          ADC     #SPXSHTSH-SPHXSHOT
          TAX
          JSR     OBJDEL                 ;DELETE SHADOW AS WELL
          JMP     STOP1

CC2:	CMP	#UWECOL			;Did bird run into a uwe?
	bne	.ok2
;
	lda	WANIMCNT-UWEDEX,x	;Is the uwe exploding?
	cmp	#13			;If yes, don't kill again.
	bcc	STOP1			;Kill bird.
	bcs	SURVIVE			;Just ran into uwe dust, bird is OK.
	
;
.ok2:	CMP     #TREASCOL+3		;Was it a treasure?
	bcs	ckBad

          JSR     GOTTREAS               ;TAKE CARE OF TREASURE

SURVIVE:  LDA     YTBL+ZBIRD             ;CHECK FOR HIERO'S
          CMP     #ZYLIMLOW
          BNE     NOLUCK                 ;BIRD NOT ON GROUND

	BIT	AUTOPLAY		;DON'T PICKUP HIEROS IN AUTO.
	BMI	NOLUCK			;!!!!!!!!!!!!!!
;
          JSR     HIERODET               ;SPECIALIZED COLISION DETECT

          BEQ     NOLUCK
          CMP     #TREASCOL
          BCS     NOLUCK
          JSR     GOTHIERO

NOLUCK:   JSR     DOSHOTS                ;DO SHOT CODE
          RTS

ckBad:	cmp	#SXSHTCOL+1
	bcs	SURVIVE
;
;
;         INITIATE DEATH
STOP1:
;	JMP	SURVIVE			;!!!!!!!!!Never Die!!!!!DEBUG
	BIT	INVINCBL		;Is the Player invincable?
	BMI	SURVIVE
STOP:	JSR	CLRPFLGS		;CLEAR TIMED POWER FLAGS
;
	LDA	#0
	STA	SCRATE			;ON DEATH STOP SCROLLING
;
	LDA	#1
	STA	BIRDACNT
	LDA	#VHDEATH
	JSR	TUNIN
	LDA	#ALADIN0
	JSR	SCRAPONE		;KILL BASS LINE OF OPENING TUNE IF
;
	LDA	ptCount			;Is there an auto power in effect?
	BNE	.turnOff		;If yes, turn it off.
	LDA	PTIMER			;Is there a power in effect?
	BEQ	DIE
.turnOff:
	JSR	powerOff		;Turn off the power in effect.
;
;
*         ROUTINE (YOU MEAN CODE FRAGMENT) TO DO DEATH ANIMATION
DIE:
          DEC     BIRDACNT               ;CHECK ANIMATION DELAY
          BMI     FALLING
          BNE     DIEDONE

          INC     DEATH                  ;ADVANCE DEATH STATE
          LDX     DEATH
          LDA     DEATHDEL-1,X           ;CHECK FOR RESTART
          BEQ     RESTART
          STA     BIRDACNT

          LDA     DEATHANI-1,X           ;POINTER TO GRAPHICS FOR BIRD
          STA     SLTBL+ZBIRD            ;EXPLOSION
          STA     SLTBL+ZSHAD

DIEDONE:
          LDA     #$1B
          CLC
          ADC     DEATH
          STA     TEMP8
          JSR     PROJECT
          JMP     SURVIVE

NODEC:
          INC     BIRDACNT
          JMP     RESTART1               ;GO TO WAIT FOR END OF TUNES
                                         ;DON'T DEC LIVES AGAIN
FALLING:
          LDA     YTBL+ZBIRD
          CMP     #5
          BCC     NODEC

          DEC     YTBL+ZBIRD             ;ONLY DEC IF GREATER THAN 4
          LDX     #$FF                   ;FUCK WITH THE MOVEMENT FLAG
          STX     TEMP7
          INC     BIRDACNT
          LDA     YTBL+ZBIRD
          CMP     #5
          BCS     DIEDONE

* HIT THE GROUND *
          LDA     #CUCKOO1
          JSR     TUNIN
          LDA     #CUCKOO2
          JSR     TUNIN
          LDA     #1
          STA     BIRDACNT
          BNE     DIEDONE                ;ALWAYS BRANCHES

*         TWO PLAYER SWITCH CODE
GMVRTBL:  .dc.b      BLANKCHR&$FF,BLANKCHR&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF
	  .dc.b      G&$FF,AA&$FF,M&$FF,E&$FF
          .dc.b      BLANKCHR&$FF,O&$FF,V&$FF,E&$FF,R&$FF
	  .dc.b      BLANKCHR&$FF,BLANKCHR&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF

*         CODE TO RESTART AFTER DEATH

RESTART:  BIT     AUTOPLAY               ;IN AUTO PLAY, DO IT FAST
          BMI     SAMEPLYR

          LDA     PHASE
          BMI     SAMEPLYR               ;DON'T DO LIVES IF BONUS RACK

          LDX     PLAYER                 ;WHICH PLAYER IS UP
          DEC     PL1LIVES,X             ;DECREMENT LIVES
          BNE     NOTGOVER

          LDA     #42                    ;MOVE HPOS TO ALLOW CENTERING
          STA     DLY+9

          LDY     #19                    ;PUT GAMEPOVER MESSAGE
GMVRLP:   LDA     GMVRTBL,Y
          STA     TOPMSMAP,Y
          DEY
          BPL     GMVRLP

          LDA     #ENDGAM1               ;START ENDGAME TUNE
          JSR     TUNIN2		;TUNIN2 doesn't check end of game.
          LDA     #ENDGAM0
          JSR     TUNIN2
;
	lda	#200		;Start end of game counter.
	sta	ENDCOUNT
;
;
RESTART1:	lda	ENDCOUNT	;End of game tune had enough time?
		BNE	WTEOT		;If yes, then end game.
; JSR     ZOUNDS
;          BNE     WTEOT

NOTGOVER: LDX     PLAYER
          LDA     NUMPLYRS               ;IF TWO PLAYER THEN GOTO TWOPLYR
          CMP     #2
          BEQ     TWOPLYR

          LDA     PL1LIVES,X  ; NO X BFR ;ELSE ONE PLAYER.  SEE IF THERE ARE
          BEQ     GAMEOVER               ;ANY LEFT

          LDA     PHASE
          BNE     LDA0E                  ;NEED TO RESTART IF IN BATTLE
          BEQ     SAMEPLYR               ;OTHERWISE JUST DO PLACEMENT

TWOPLYR:  TXA                            ;TRANSFER PLAYER TO ACCUMULATOR
          EOR     #$01                   ;AND TWIDDLE BIT TO GET OTHER PLAYER
          TAY
          LDA     PL1LIVES,Y             ;GET NUMBER OF LIVES FOR OTHER PLAYER
          BEQ     UTTERWAY               ;IF ZERO GOTO UTTERWAY
          STY     PLAYER                 ;ELSE STORE OTHER PLAYER TO PLAYER,CONT
          JMP     LDA0E

UTTERWAY: LDA     PL1LIVES,X             ;IF NONE LEFT THEN PUNT
          BEQ     GAMEOVER

SAMEPLYR:
          JSR     CLEAN
          JSR     SCRAPALL               ;KILL ALL TUNES
          JSR     PLACEMNT
WTEOT:    RTS

LDA0E:
          LDA     #$FF
          STA     NEWPLYR
          RTS
;
;
;===========================
;	End of game.
;===========================
;
GAMEOVER:
	jsr	powerOff		;Turn off any power.
;
	LDX	#$FF
	STX	GAMEOVR
	RTS
;
;
*         DOSHOTS  THIS IS THE SHOT ROUTINE
DOSHOTS:
          LDA     DEATH                  ;IF DEAD THEN DON'T ALLOW FOR NEW
          BNE     JDONT                  ;SHOTS

          LDA     PHASE
          CMP     #(-2)&$FF
          BEQ     JDONT                  ;CAN'T SHOOT DURING BONUS RACK

          DEC     FIRECNT                ;CHECK FOR FIRING (DELAY)
          BNE     JDONT

          LDA     #1
          STA     FIRECNT

JOHNTMP2: BIT     AUTOPLAY               ;FORCE FIRING IN AUTOPLAY
          BPL     NORMAL

          BIT     FRMCNT
          BMI     SHOTTER                ;SHOT ON NEGATIVE FRAMES
          BPL     JDONT                  ;DON'T ON POSITIVE FRAMES

NORMAL:   LDX     PLAYER
          LDA     LEFTBUT,X
          BPL     SHOTTER		;!!!!FIRE!!!!!!!!!!!!
;	jmp	SHOTTER			;!!!!!!!!!!!!!!!!
JDONT:    JMP     DONTFIRE

SHOTTER:
          LDX     SHOTCNT                ;COMMENT THIS
          INX
          TXA
          AND     #3
          TAX                            ;SHOT NUMBER
          LDA     SHOTSTAT,X             ;IF SHOT IS STILL AROUND
          BNE     JDONT                  ;THEN DON'T SHOOT

          STX     SHOTCNT

          LDA     #5
          STA     FIRECNT

*         ADJUST X FOR TURNING
          LDA     #8                     ; EAST
          BIT     TEMP0                  ; JOYSTICK VALUE
          BEQ     ADJXEAST
          LDA     #4                     ; WEST
          BIT     TEMP0
          BEQ     ADJXWEST
          LDA     XTBL+ZBIRD
          BNE     ADJXDONE               ; ALWAYS
ADJXEAST: LDA     XTBL+ZBIRD
          CLC
          ADC     #2
          BNE     ADJXDONE               ; ALWAYS
ADJXWEST: LDA     XTBL+ZBIRD
          SEC
          SBC     #2
ADJXDONE: STA     XTBL+ZSHOT1,X          ;SET SHOT COORDINATES (SAME X AS BIRD)
          STA     XTBL+SHOTSHAD,X        ;SHADOW IS SAME, TOO.

*         ADJUST Y FOR GROUND, WATER, OR AIR
          LDA     YTBL+ZBIRD             ;SAME Y AS BIRD
          CMP     #ZYLIMLOW              ;BYTE SAVING POSSIBLE
          BNE     ADJYAIR
          BIT     SWIMMING
          BMI     ADJYH2O                ; IF IN WATER
          LDA     #7
          BNE     ADJYDONE
ADJYH2O:  LDA     #3
          BNE     ADJYDONE               ;NEVER HAPPENS.  WHAT DA FUCK??
ADJYAIR:  CLC                            ;WHAT GIVES FOLKS??
          ADC     #1
ADJYDONE: STA     YTBL+ZSHOT1,X

          LDA     #ZBIRDZ+6              ;Z IS SAME FOR SHOT AND SHADOW
          STA     ZTBL+ZSHOT1,X
          STA     ZTBL+SHOTSHAD,X

          LDA     #0                     ;Y OF SHADOW IS 0
          STA     YTBL+SHOTSHAD,X

NOHACK:   LDA     #$80                   ;SET SHOT STATUS
          STA     SHOTSTAT,X

          LDA     #SHOTAN0&$FF            ; INITIAL ANIMATION ADDRESS
          STA     SLTBL+ZSHOT1,X
          STA     SLTBL+SHOTSHAD,X


*         CODE TO DO PROJECTION FOR NEW SHOT.  CALCULATES HP AND VP FROM X,Y,Z
          LDA     XTBL+ZSHOT1,X
          CLC
          ADC     ZTBL+ZSHOT1,X
          ADC     #(-NUMBER-7)&$FF	;-7 IS HPOFF FOR BOTH SHOT ANIMATIONS
          STA     HPTBL+ZSHOT1,X         ;HERE ARE THE SHOT AND SHADOW HP'S
          STA     HPTBL+SHOTSHAD,X

          LDA     XTBL+ZSHOT1,X
          SEC
          SBC     ZTBL+ZSHOT1,X
          CLC
          ADC     #NUMBER
          STA     VPTBL+SHOTSHAD,X       ;HERE IS SHADOW VP
          SEC
          SBC     YTBL+ZSHOT1,X
          STA     VPTBL+ZSHOT1,X         ;HERE IS SHOT VP

* CALCULATE PRIORITY AND INSERT NEW SHOT IN OBJECT LIST
          LDA     #$FE
          STA     TEMP6                  ;PRIORITY OF SHADOW IS FE
          STA     TEMP10
          STX     TEMPX
          TXA
          CLC
          ADC     #SHOTSHAD              ;INDEX OF SHADOW
          TAX
          JSR     OBJINS                 ;INSERT IT
          LDX     TEMPX

          LDA     ZTBL+ZSHOT1,X          ; Z-X+NUMBER+OFFSET
          SEC
          SBC     XTBL+ZSHOT1,X
          CLC
          ADC     #NUMBER+DXADJ          ; THIS IS DF
          STA     TEMP10
          SEC
          SBC     #5                     ; THIS IS DS
          STA     TEMP6                  ;PRIORITY OF SHOT
          TXA
          CLC
          ADC     #ZSHOT1
          TAX
          JSR     OBJINS                 ; INSERT NEW SHOT IN LIST

          LDA     #BRDSHOT               ; SOUND OF SHOT
          JSR     TUNIN


*         MOVE THE FOUR HERO SHOTS
DONTFIRE:
          LDX     #ZSHOT1+4              ; INDEX INTO OBJECT TABLES

NEXTSHOT: DEX                            ;LOOP THROUGH ALL SHOTS
          CPX     #ZSHOT1
          BCS     DOSHOT

* SETBACK IS NOT CALLED ANYMORE
;         JSR     SETBACK                ; MOVE THIS TO MAIN LOOP
          RTS                            ; DONE MOVING SHOTS

DOSHOT:   LDA     SHOTSTAT-ZSHOT1,X
          BEQ     NEXTSHOT               ; SHOT X IS INACTIVE

* CODE TO ANIMATE SHOT (EXPLODE)
          BMI     MOVESHOT               ;IF TOP BIT IS CLEAR, IT IS EXPLODING
          DEC     SHOTSTAT-ZSHOT1,X

          LDA     SHOTSTAT-ZSHOT1,X
          BNE     DOSHOTAN
JKILLSHT: JMP     KILLSHOT               ;REMOVE SHOT WHEN IT IS DONE EXPLODING

DOSHOTAN: AND     #$3
          BNE     NEXTSHOT
          LDA     SLTBL,X                ;ADJUST LOW BYTE OF GRAPHICS
          CLC
          ADC     #2                     ; EXPLOSION STAMPS FOLLOW SHOT STAMPS
          STA     SLTBL,X
          STA     SLTBL+SHOTDIFF,X       ;SHADOW TOO!
          JMP     NEXTSHOT

* MOVE SHOT
MOVESHOT:
          LDA     ZTBL,X                 ; DO SHOT Z CALCULATION
          CLC
          ADC     QUIKSHOT               ;SHOTS MOVE THREE Z AT A TIME
          STA     ZTBL,X
          STA     ZTBL+SHOTDIFF,X

          STA     COLPZ                  ; FOR COLLISION DETECTION CALLS BELOW

          CMP     #ZBIRDZ+27             ; WAS 25
          BCC     NOBIGGER

          LDA     #(SHOTAN0+2)&$FF	;THIS CORRECTS SHOT GRAPHICS WHEN THEY
          STA     SLTBL,X		;SHOULD BE MAX SIZE
          STA     SLTBL+SHOTDIFF,X

NOBIGGER: LDA     HPTBL,X                ;HP CHANGES BY THREE
          CLC
          ADC     QUIKSHOT
          STA     HPTBL,X
          STA     HPTBL+SHOTDIFF,X       ;SHADOW, TOO!

          CMP     #160                   ; OFF RIGHT SIDE OF SCREEN?
BKILLSHT: BCS     JKILLSHT

          LDA     VPTBL,X                ;TAKE AWAY THREE FROM VP
          SEC
          SBC     QUIKSHOT
          STA     VPTBL,X
          CLC
          ADC     YTBL,X
          STA     VPTBL+SHOTDIFF,X

          LDA     VPTBL+SHOTDIFF,X       ;DON'T FORGET THAT PESKY SHADOW
          CMP     #SCRENBOT
          BCC     NOKILLSH
          CMP     #(-8)&$FF

          BCS     BKILLSHT               ;THIS BCS'S TO ANOTHER BCS

NOKILLSH: LDA     DXTBL,X
;         CLC
          ADC     QUIKSHOT
          STA     TEMP6

          LDA     DFTBL,X
          CLC
          ADC     QUIKSHOT
          STA     TEMP10

          JSR     OBJMOV                 ; MOVE SHOT IN LIST


*         DO COLLISION DETECTION FOR SHOT
          LDA     XTBL,X                 ;CHECK X,Y,Z
          STA     COLPX
          LDA     YTBL,X
          STA     COLPY
          STX     TEMP0                  ;X HERE IS SHOT INDEX
          JSR     COLDET                 ;IN THE COLLISION LIST
          BNE     ASHOTT                 ;YES, A COLLISION
          LDX     TEMP0

          LDA     COLPZ
          SEC
          SBC     QUIKSHOT
          STA     COLPZ
          JSR     COLDET
          BNE     ASHOTT
SAVESHOT: LDX     TEMP0

          JMP     NEXTSHOT


*         INITIATE SHOT EXPLOSION ANIMATION
EXPLSHOT:
          LDX     TEMP0
          LDA     #RICCHET               ; CALL SOUND OF SHOT RICCOCHET
          JSR     TUNIN
          LDA     #$8                    ; INITIAL EXPLOSION STATE + 1
          STA     SHOTSTAT-ZSHOT1,X
          LDA     #(SHOTAN0+4)&$FF	;GRAPHICS FOR SPLAT
          STA     SLTBL,X
          STA     SLTBL+SHOTDIFF,X
          JMP     NEXTSHOT               ;LOOP FOR NEXT SHOT


*         DETEMINE WHAT THE SHOT COLLIDED WITH AND ACT APPROPRIATELY
ASHOTT:
	BIT	AUTOPLAY		;!!!!!!!!!!!!
	BPL	.SKIP
          JSR     KILLSPHX
          JMP     EXPLSHOT
;
.SKIP:
          CMP     #FLEACOL               ;HOW ABOUT A FLEA?
          BNE     ASHOT1
;
	lda	FLEANIM-FLEADEX,x		;Is flea blowing up?
	cmp	#15
	bcc	.ok1
	cmp	#24
	bcc	.noHit
	cmp	#29
	bcc	.ok1
	cmp	#33
	bcc	.noHit
	cmp	#37
	bcc	.ok1
	cmp	#41
	bcs	.ok1
.noHit:	jmp	EXPLSHOT		;If blowing up, no hit.
.ok1:
;
          JSR     KILLFLEA               ;BLOW FLEAS DOORS OFF
          BIT     TRDSPFLG               ;IF DISPLAY ALREADY UP THEN DON'T
          BMI     EXPLSHOT               ;PUT IT UP AGAIN
          JSR     INITRSMP               ;PUT UP TREASURE DISPLAY
          JMP     EXPLSHOT

ASHOT1:   CMP     #UWECOL                ;WHAT ABOUT A UWE
          BNE     ASHOT2
	lda	WANIMCNT-UWEDEX,x	;Is the uwe exploding?
	cmp	#13			;If yes, don't kill again.
	bcc	.ok1
	jmp	SAVESHOT
.ok1:
          JSR     KILLUWE
          JMP     EXPLSHOT

ASHOT2:   CMP     #MINICOL               ;A MINI SPHINX?
          BNE     ASHOT3
          JSR     MINIKILL
          JMP     EXPLSHOT

ASHOT3:   CMP     #SPHNXCOL              ;THE BIG SPHINX?
          BNE     ASHOT4
;
	BIT	AUTOPLAY		;DON'T KILL SPHINX IN AUTOPLAY.
	BMI	.SKIP			;!!!!!!!!!!
;
	JSR     KILLSPHX
.SKIP:	JMP     EXPLSHOT

ASHOT4:   CMP     #FIRECOL               ; FIRE??????
          BNE     ASHOT5
          JMP     SAVESHOT               ; DON'T EXPLODE IT

ASHOT5:   CMP     #TREASCOL              ; A TREASURE ????
          BCC     ASHOT6                 ; NO
          CMP     #TREASCOL+3
          BCS     ASHOT6                 ; NO
          JSR     HITTREAS               ; YES
          JMP     EXPLSHOT

ASHOT6:   JMP     EXPLSHOT

*         CHANGE SHOT TO INACTIVE STATE
KILLSHOT: LDA     #0                     ;RESET SHOTSTAT
          STA     SHOTSTAT-ZSHOT1,X

          JSR     OBJDEL                 ;REMOVE SHOT FROM LIST

          STX     TEMPX
          TXA
          CLC
          ADC     #SHOTDIFF
          TAX
          JSR     OBJDEL                 ;REMOVE SHADOW FROM LIST
          LDX     TEMPX
          JMP     NEXTSHOT
          RTS

*         SIMULATAED GAMEPLAY FROM AUTOPLAY
JOYSIM:   .dc.b      $F0,$F0,$F0,$D0,$70,$D0,$E0,$50,$60,$70,$90,$A0,$B0,$D0,$E0
          .dc.b      $F0

; TABLE TO TRANSLATE SWCHA TO ACTION, HIGH NIBBLE FOR NEAR GROUND
;
JOYTBL:   .dc.b      $00                   ; N S W E - ILLEGAL
          .dc.b      $00                   ;   S W E - ILLEGAL
          .dc.b      $00                   ; N   W E - ILLEGAL
          .dc.b      $00                   ;     W E - ILLEGAL
          .dc.b      $00                   ; N S   E - ILLEGAL
          .dc.b      $B7                   ;   S   E
          .dc.b      $E5                   ; N     E
          .dc.b      $C3                   ;       E
          .dc.b      $00                   ; N S W   - ILLEGAL
          .dc.b      $B8                   ;   S W
          .dc.b      $F6                   ; N   W
          .dc.b      $D4                   ;     W
          .dc.b      $00                   ; N S     - ILLEGAL
          .dc.b      $B2                   ;   S
          .dc.b      $A1                   ; N
          .dc.b      $90                   ; NONE

; TABLE TO TRANSLATE STATE AND ACTION INTO NEW STATE (HIGH) AND CONTROL CODE
;
STATETBL: .dc.b      $10                   ; F0 A     FLIGHT STATES
          .dc.b      $11                   ; F0 AN
          .dc.b      $12                   ; F0 AS
          .dc.b      $13                   ; F0 AE
          .dc.b      $13                   ; F0 AW
          .dc.b      $14                   ; F0 ANE
          .dc.b      $14                   ; F0 ANW
          .dc.b      $15                   ; F0 ASE
          .dc.b      $15                   ; F0 ASW
          .dc.b      $16                   ; F0 G
          .dc.b      $16                   ; F0 GN
          .dc.b      $12                   ; F0 GS,GSE,GSW
          .dc.b      $16                   ; F0 GE
          .dc.b      $16                   ; F0 GW
          .dc.b      $16                   ; F0 GNE
          .dc.b      $16                   ; F0 GNW
          .dc.b      $20                   ; F1 A
          .dc.b      $11                   ; F1 AN
          .dc.b      $22                   ; F1 AS
          .dc.b      $23                   ; F1 AE
          .dc.b      $23                   ; F1 AW
          .dc.b      $14                   ; F1 ANE
          .dc.b      $14                   ; F1 ANW
          .dc.b      $25                   ; F1 ASE
          .dc.b      $25                   ; F1 ASW
          .dc.b      $26                   ; F1 G
          .dc.b      $47                   ; F1 GN
          .dc.b      $22                   ; F1 GS,GSE,GSW
          .dc.b      $26                   ; F1 GE
          .dc.b      $26                   ; F1 GW
          .dc.b      $47                   ; F1 GNE
          .dc.b      $47                   ; F1 GNW
          .dc.b      $30                   ; F2 A
          .dc.b      $31                   ; F2 AN
          .dc.b      $32                   ; F2 AS
          .dc.b      $33                   ; F2 AE
          .dc.b      $33                   ; F2 AW
          .dc.b      $34                   ; F2 ANE
          .dc.b      $34                   ; F2 ANW
          .dc.b      $35                   ; F2 ASE
          .dc.b      $35                   ; F2 ASW
          .dc.b      $36                   ; F2 G
          .dc.b      $36                   ; F2 GN
          .dc.b      $32                   ; F2 GS,GSE,GSW
          .dc.b      $36                   ; F2 GE
          .dc.b      $36                   ; F2 GW
          .dc.b      $36                   ; F2 GNE
          .dc.b      $36                   ; F2 GNW
          .dc.b      $00                   ; F3 A
          .dc.b      $01                   ; F3 AN
          .dc.b      $02                   ; F3 AS
          .dc.b      $03                   ; F3 AE
          .dc.b      $03                   ; F3 AW
          .dc.b      $04                   ; F3 ANE
          .dc.b      $04                   ; F3 ANW
          .dc.b      $05                   ; F3 ASE
          .dc.b      $05                   ; F3 ASW
          .dc.b      $06                   ; F3 G
          .dc.b      $06                   ; F3 GN
          .dc.b      $02                   ; F3 GS,GSE,GSW
          .dc.b      $06                   ; F3 GE
          .dc.b      $06                   ; F3 GW
          .dc.b      $06                   ; F3 GNE
          .dc.b      $06                   ; F3 GNW
          .dc.b      $58                   ; S0 A     STALL STATES
          .dc.b      $58                   ; S0 AN
          .dc.b      $3F                   ; S0 AS
          .dc.b      $58                   ; S0 AE
          .dc.b      $58                   ; S0 AW
          .dc.b      $58                   ; S0 ANE
          .dc.b      $58                   ; S0 ANW
          .dc.b      $3F                   ; S0 ASE
          .dc.b      $3F                   ; S0 ASW
          .dc.b      $58                   ; S0 G
          .dc.b      $58                   ; S0 GN
          .dc.b      $3F                   ; S0 GS,GSE,GSW
          .dc.b      $58                   ; S0 GE
          .dc.b      $58                   ; S0 GW
          .dc.b      $58                   ; S0 GNE
          .dc.b      $58                   ; S0 GNW
          .dc.b      $49                   ; S1 A
          .dc.b      $69                   ; S1 AN
          .dc.b      $49                   ; S1 AS
          .dc.b      $49                   ; S1 AE
          .dc.b      $49                   ; S1 AW
          .dc.b      $69                   ; S1 ANE
          .dc.b      $69                   ; S1 ANW
          .dc.b      $49                   ; S1 ASE
          .dc.b      $49                   ; S1 ASW
          .dc.b      $49                   ; S1 G
          .dc.b      $69                   ; S1 GN
          .dc.b      $49                   ; S1 GS,GSE,GSW
          .dc.b      $49                   ; S1 GE
          .dc.b      $49                   ; S1 GW
          .dc.b      $69                   ; S1 GNE
          .dc.b      $69                   ; S1 GNW
          .dc.b      $7B                   ; L0 A     LANDING STATES
          .dc.b      $7B                   ; L0 AN
          .dc.b      $CF                   ; L0 AS
          .dc.b      $7B                   ; L0 AE
          .dc.b      $7B                   ; L0 AW
          .dc.b      $7B                   ; L0 ANE
          .dc.b      $7B                   ; L0 ANW
          .dc.b      $CF                   ; L0 ASE
          .dc.b      $CF                   ; L0 ASW
          .dc.b      $7B                   ; L0 G
          .dc.b      $7B                   ; L0 GN
          .dc.b      $CF                   ; L0 GS,GSE,GSW
          .dc.b      $7B                   ; L0 GE
          .dc.b      $7B                   ; L0 GW
          .dc.b      $7B                   ; L0 GNE
          .dc.b      $7B                   ; L0 GNW
          .dc.b      $8C                   ; L1 A
          .dc.b      $8C                   ; L1 AN
          .dc.b      $BF                   ; L1 AS
          .dc.b      $8C                   ; L1 AE
          .dc.b      $8C                   ; L1 AW
          .dc.b      $8C                   ; L1 ANE
          .dc.b      $8C                   ; L1 ANW
          .dc.b      $BF                   ; L1 ASE
          .dc.b      $BF                   ; L1 ASW
          .dc.b      $8C                   ; L1 G
          .dc.b      $8C                   ; L1 GN
          .dc.b      $BF                   ; L1 GS,GSE,GSW
          .dc.b      $8C                   ; L1 GE
          .dc.b      $8C                   ; L1 GW
          .dc.b      $8C                   ; L1 GNE
          .dc.b      $8C                   ; L1 GNW
          .dc.b      $8D                   ; H0 A     HOPPING STATES
          .dc.b      $8E                   ; H0 AN
          .dc.b      $AF                   ; H0 AS
          .dc.b      $8E                   ; H0 AE
          .dc.b      $8E                   ; H0 AW
          .dc.b      $8E                   ; H0 ANE
          .dc.b      $8E                   ; H0 ANW
          .dc.b      $AF                   ; H0 ASE
          .dc.b      $AF                   ; H0 ASW
          .dc.b      $8D                   ; H0 G
          .dc.b      $9D                   ; H0 GN
          .dc.b      $9D                   ; H0 GS,GSE,GSW
          .dc.b      $9D                   ; H0 GE
          .dc.b      $9D                   ; H0 GW
          .dc.b      $9D                   ; H0 GNE
          .dc.b      $9D                   ; H0 GNW
          .dc.b      $8D                   ; H1 A
          .dc.b      $8E                   ; H1 AN
          .dc.b      $8E                   ; H1 AS
          .dc.b      $8E                   ; H1 AE
          .dc.b      $8E                   ; H1 AW
          .dc.b      $8E                   ; H1 ANE
          .dc.b      $8E                   ; H1 ANW
          .dc.b      $8E                   ; H1 ASE
          .dc.b      $8E                   ; H1 ASW
          .dc.b      $8E                   ; H1 G
          .dc.b      $8E                   ; H1 GN
          .dc.b      $AF                   ; H1 GS,GSE,GSW  WAS 8E
          .dc.b      $8E                   ; H1 GE
          .dc.b      $8E                   ; H1 GW
          .dc.b      $8E                   ; H1 GNE
          .dc.b      $8E                   ; H1 GNW
          .dc.b      $8F                   ; T0 A     TAKE-OFF STATES
          .dc.b      $8F                   ; T0 AN
          .dc.b      $BC                   ; T0 AS
          .dc.b      $8F                   ; T0 AE
          .dc.b      $8F                   ; T0 AW
          .dc.b      $8F                   ; T0 ANE
          .dc.b      $8F                   ; T0 ANW
          .dc.b      $BC                   ; T0 ASE
          .dc.b      $BC                   ; T0 ASW
          .dc.b      $8F                   ; T0 G
          .dc.b      $8F                   ; T0 GN
          .dc.b      $BC                   ; T0 GS,GSE,GSW
          .dc.b      $8F                   ; T0 GE
          .dc.b      $8F                   ; T0 GW
          .dc.b      $8F                   ; T0 GNE
          .dc.b      $8F                   ; T0 GNW
          .dc.b      $7F                   ; T1 A
          .dc.b      $7F                   ; T1 AN
          .dc.b      $CB                   ; T1 AS
          .dc.b      $7F                   ; T1 AE
          .dc.b      $7F                   ; T1 AW
          .dc.b      $7F                   ; T1 ANE
          .dc.b      $7F                   ; T1 ANW
          .dc.b      $CB                   ; T1 ASE
          .dc.b      $CB                   ; T1 ASW
          .dc.b      $7F                   ; T1 G
          .dc.b      $7F                   ; T1 GN
          .dc.b      $CB                   ; T1 GS,GSE,GSW
          .dc.b      $7F                   ; T1 GE
          .dc.b      $7F                   ; T1 GW
          .dc.b      $7F                   ; T1 GNE
          .dc.b      $7F                   ; T1 GNW
          .dc.b      $4F                   ; T2 A
          .dc.b      $6F                   ; T2 AN
          .dc.b      $2A                   ; T2 AS
          .dc.b      $4F                   ; T2 AE
          .dc.b      $4F                   ; T2 AW
          .dc.b      $6F                   ; T2 ANE
          .dc.b      $6F                   ; T2 ANW
          .dc.b      $2A                   ; T2 ASE
          .dc.b      $2A                   ; T2 ASW
          .dc.b      $4F                   ; T2 G
          .dc.b      $6F                   ; T2 GN
          .dc.b      $2A                   ; T2 GS,GSE,GSW
          .dc.b      $4F                   ; T2 GE
          .dc.b      $4F                   ; T2 GW
          .dc.b      $6F                   ; T2 GNE
          .dc.b      $6F                   ; T2 GNW

; TABLE TO TRANSLATE STATE AND ACTION TO ANIMATION NUMBER
;
BIRDATBL: .dc.b      $80                    ;F0
          .dc.b      $90                    ;F1
          .dc.b      $80                    ;F2
          .dc.b      $A0                    ;F3
          .dc.b      $A                     ;S0
          .dc.b      $9                     ;S1
          .dc.b      $B                     ;L0
          .dc.b      $C                     ;L1
          .dc.b      $B0                    ;H0
          .dc.b      $C0                    ;H1
          .dc.b      $13                    ;T0
          .dc.b      $14                    ;T1
          .dc.b      $15                    ;T2

BIRDAI:   .dc.b      $0                     ; F0 A
          .dc.b      $0                     ; F0 AN
          .dc.b      $0                     ; F0 AS
          .dc.b      $3                     ; F0 AE
          .dc.b      $6                     ; F0 AW
          .dc.b      $3                     ; F0 ANE
          .dc.b      $6                     ; F0 ANW
          .dc.b      $3                     ; F0 ASE
          .dc.b      $6                     ; F0 ASW
          .dc.b      $0                    ; F0 G
          .dc.b      $0                    ; F0 GN
          .dc.b      $0                    ; F0 GS,GSE,GSW
          .dc.b      $3                    ; F0 GE
          .dc.b      $6                    ; F0 GW
          .dc.b      $3                    ; F0 GNE
          .dc.b      $6                    ; F0 GNW
          .dc.b      $1                     ; F1 A
          .dc.b      $1                     ; F1 AN
          .dc.b      $1                     ; F1 AS
          .dc.b      $4                     ; F1 AE
          .dc.b      $7                     ; F1 AW
          .dc.b      $4                     ; F1 ANE
          .dc.b      $7                     ; F1 ANW
          .dc.b      $4                     ; F1 ASE
          .dc.b      $7                     ; F1 ASW
          .dc.b      $1                    ; F1 G
          .dc.b      $1                    ; F1 GN
          .dc.b      $1                    ; F1 GS,GSE,GSW
          .dc.b      $4                    ; F1 GE
          .dc.b      $7                    ; F1 GW
          .dc.b      $4                    ; F1 GNE
          .dc.b      $7                    ; F1 GNW
          .dc.b      $2                     ; F3 A
          .dc.b      $2                     ; F3 AN
          .dc.b      $2                     ; F3 AS
          .dc.b      $5                     ; F3 AE
          .dc.b      $8                     ; F3 AW
          .dc.b      $5                     ; F3 ANE
          .dc.b      $8                     ; F3 ANW
          .dc.b      $5                     ; F3 ASE
          .dc.b      $8                     ; F3 ASW
          .dc.b      $2                    ; F3 G
          .dc.b      $2                    ; F3 GN
          .dc.b      $2                    ; F3 GS,GSE,GSW
          .dc.b      $5                    ; F3 GE
          .dc.b      $8                    ; F3 GW
          .dc.b      $5                    ; F3 GNE
          .dc.b      $8                    ; F3 GNW
          .dc.b      $96                   ; H0 A
          .dc.b      $97                   ; H0 AN
          .dc.b      $96                   ; H0 AS
          .dc.b      $98                   ; H0 AE
          .dc.b      $99                   ; H0 AW
          .dc.b      $9A                   ; H0 ANE
          .dc.b      $9B                   ; H0 ANW
          .dc.b      $96                   ; H0 ASE
          .dc.b      $96                   ; H0 ASW
          .dc.b      $E                    ; H0 G
          .dc.b      $E                    ; H0 GN
          .dc.b      $E                    ; H0 GS,GSE,GSW
          .dc.b      $10                   ; H0 GE
          .dc.b      $12                   ; H0 GW
          .dc.b      $10                   ; H0 GNE
          .dc.b      $12                   ; H0 GNW
          .dc.b      $D                    ; H1 A
          .dc.b      $D                    ; H1 AN
          .dc.b      $D                    ; H1 AS
          .dc.b      $F                    ; H1 AE
          .dc.b      $11                   ; H1 AW
          .dc.b      $F                    ; H1 ANE
          .dc.b      $11                   ; H1 ANW
          .dc.b      $D                    ; H1 ASE
          .dc.b      $D                    ; H1 ASW
          .dc.b      $D                    ; H1 G
          .dc.b      $D                    ; H1 GN
          .dc.b      $D                    ; H1 GS,GSE,GSW
          .dc.b      $F                    ; H1 GE
          .dc.b      $11                   ; H1 GW
          .dc.b      $F                    ; H1 GNE
          .dc.b      $11                   ; H1 GNW

; TABLE TO TRANSLATE CONTROL CODE INTO SCROLLING RATE
;
SCRATBL:  .dc.b      -1                     ; NORMAL FLIGHT
          .dc.b      -1                     ; DIVING
          .dc.b      -1                     ; CLIMBING
          .dc.b      -1                     ; TURNING
          .dc.b      -1                     ; DIVING + TURNING
          .dc.b      -1                     ; CLIMBING + TURNING
          .dc.b      2                      ; LAST FLAP     THESE ARE ABSOLUTE
          .dc.b      2                      ; LAST GLIDE
          .dc.b      1                      ; STALL 0
          .dc.b      1                      ; STALL 1
          .dc.b      1                      ; H = 3
          .dc.b      1                      ; H = 2
          .dc.b      1                      ; H = 1
          .dc.b      0                      ; STAND
          .dc.b      2                      ; HOP
          .dc.b      0                      ; STAY          NO CHANGE

; TABLE TO TRANSLATE CONTROL CODE INTO ANIMATION DELAY
;
ADELTBL:  .dc.b      3                      ; NORMAL FLIGHT
          .dc.b      2                      ; DIVING
          .dc.b      2                      ; CLIMBING
          .dc.b      3                      ; TURNING
          .dc.b      2                      ; DIVING + TURNING
          .dc.b      2                      ; CLIMBING + TURNING
          .dc.b      4                      ; LAST FLAP
          .dc.b      2                      ; LAST GLIDE
          .dc.b      3                      ; STALL 0
          .dc.b      3                      ; STALL 1
          .dc.b      2                      ; H = 3
          .dc.b      2                      ; H = 2
          .dc.b      3                      ; H = 1
          .dc.b      2                      ; STAND
          .dc.b      2                      ; HOP
          .dc.b      2                      ; STAY       WAS 1

; TABLE TO TRANSLATE CONTROL CODE INTO X UPDATE DELAY
;
XDELTBL:  .dc.b      0                      ; NORMAL FLIGHT
          .dc.b      0                      ; DIVING
          .dc.b      0                      ; CLIMBING
          .dc.b      1                      ; TURNING
          .dc.b      1                      ; DIVING + TURNING
          .dc.b      1                      ; CLIMBING + TURNING
          .dc.b      1                      ; LAST FLAP
          .dc.b      1                      ; LAST GLIDE
          .dc.b      2                      ; STALL 0
          .dc.b      2                      ; STALL 1
          .dc.b      0                      ; H = 3
          .dc.b      0                      ; H = 2
          .dc.b      0                      ; H = 1
          .dc.b      2                      ; STAND
          .dc.b      2                      ; HOP
          .dc.b      2                      ; STAY

; TABLE TO TRANSLATE CONTROL CODE INTO Y UPDATE MODES

;         0       DON'T UPDATE Y
;         -1      INCREMENT OR DECREMENT Y DEPENDING ON JOYSTICK
;         N > 0   SET Y TO N
YMODTBL:  .dc.b      0                      ; NORMAL FLIGHT
          .dc.b      -1                     ; DIVING
          .dc.b      -1                     ; CLIMBING
          .dc.b      0                      ; TURNING
          .dc.b      -1                     ; DIVING + TURNING
          .dc.b      -1                     ; CLIMBING + TURNING
          .dc.b      (ZYLIMLOW+4)&$FF             ; LAST FLAP
          .dc.b      (ZYLIMLOW+4)&$FF             ; LAST GLIDE
          .dc.b      (ZYLIMLOW+3)&$FF             ; STALL 0
          .dc.b      (ZYLIMLOW+3)&$FF             ; STALL 1
          .dc.b      (ZYLIMLOW+6)&$FF             ; H = 6
          .dc.b      (ZYLIMLOW+3)&$FF             ; H = 3
          .dc.b      (ZYLIMLOW+1)&$FF             ; H = 1
          .dc.b      (ZYLIMLOW)&$FF               ; STAND
          .dc.b      (ZYLIMLOW)&$FF               ; HOP
          .dc.b      0                      ; STAY

; TABLE TO TRANSLATE ANIMATION NUMBER TO BIRD ANIMATION ADDRESS
;
BIRDANAD: .dc.b      BIRDFMS&$FF             ; 0
          .dc.b      BIRDFUS&$FF             ; 1
          .dc.b      BIRDFDS&$FF             ; 2
          .dc.b      BIRDFMR&$FF             ; 3
          .dc.b      BIRDFUR&$FF             ; 4
          .dc.b      BIRDFDR&$FF             ; 5
          .dc.b      BIRDFML&$FF             ; 6
          .dc.b      BIRDFUL&$FF             ; 7
          .dc.b      BIRDFDL&$FF             ; 8
          .dc.b      BIRDSU&$FF              ; 9
          .dc.b      BIRDSD&$FF              ; A
          .dc.b      BIRDLU&$FF              ; B
          .dc.b      BIRDLD&$FF              ; C
          .dc.b      BIRDHUS&$FF             ; D
          .dc.b      BIRDHDS&$FF             ; E
          .dc.b      BIRDHUR&$FF             ; F
          .dc.b      BIRDHDR&$FF             ; 10
          .dc.b      BIRDHUL&$FF             ; 11
          .dc.b      BIRDHDL&$FF             ; 12
          .dc.b      BIRDTU1&$FF             ; 13
          .dc.b      BIRDTD&$FF              ; 14
          .dc.b      BIRDTU2&$FF             ; 15
          .dc.b      BIRDWS&$FF             ; 16
          .dc.b      BIRDWS&$FF             ; 17
          .dc.b      BIRDWR&$FF             ; 18
          .dc.b      BIRDWL&$FF             ; 19
          .dc.b      BIRDWR&$FF             ; 1A
          .dc.b      BIRDWL&$FF             ; 1B

; TABLE TO TRANSLATE ANIMATION NUMBER TO SHADOW ANIMATION ADDRESS
;
SHADANAD: .dc.b      BIRDFMS&$FF             ; 0
          .dc.b      BIRDFUS&$FF             ; 1
          .dc.b      BIRDFDS&$FF             ; 2
          .dc.b      BIRDFMR&$FF             ; 3
          .dc.b      BIRDFUR&$FF             ; 4
          .dc.b      BIRDFDR&$FF             ; 5
          .dc.b      BIRDFML&$FF             ; 6
          .dc.b      BIRDFUL&$FF             ; 7
          .dc.b      BIRDFDL&$FF             ; 8
          .dc.b      SHADSU&$FF              ; 9
          .dc.b      SHADSD&$FF              ; A
          .dc.b      BIRDLU&$FF              ; B
          .dc.b      BIRDLD&$FF              ; C
          .dc.b      SHADHUS&$FF              ; D
          .dc.b      SHADHDS&$FF              ; E
          .dc.b      SHADHUR&$FF              ; F
          .dc.b      SHADHDR&$FF              ; 10
          .dc.b      SHADHUL&$FF              ; 11
          .dc.b      SHADHDL&$FF              ; 12
          .dc.b      BIRDTU1&$FF             ; 13
          .dc.b      BIRDTD&$FF              ; 14
          .dc.b      BIRDTU2&$FF             ; 15
          .dc.b      UWEBLANK&$FF            ; 16
          .dc.b      UWEBLANK&$FF            ; 17
          .dc.b      UWEBLANK&$FF            ; 18
          .dc.b      UWEBLANK&$FF            ; 19
          .dc.b      UWEBLANK&$FF            ; 1A
          .dc.b      UWEBLANK&$FF            ; 1B

DOFF1     EQU     0
DOFF2     EQU     2
DOFF3     EQU     5
DOFF4     EQU     7
DOFF5     EQU     8
DOFF6     EQU     8

; TABLE TO TRANSLATE ANIMATION NUMBER TO BIRD HORIZONAL POSITION OFFSET
;         - NUMBER + OFFSET
BHPOFF:   .dc.b      (-NUMBER-7)              ; 0
          .dc.b      (-NUMBER-7)             ; 1
          .dc.b      (-NUMBER-7)             ; 2
          .dc.b      (-NUMBER-7)             ; 3
          .dc.b      (-NUMBER-7)             ; 4
          .dc.b      (-NUMBER-7)             ; 5
          .dc.b      (-NUMBER-7)             ; 6
          .dc.b      (-NUMBER-7)             ; 7
          .dc.b      (-NUMBER-7)             ; 8
          .dc.b      (-NUMBER-7)             ; 9
          .dc.b      (-NUMBER-7)             ; A
          .dc.b      (-NUMBER-8)             ; B
          .dc.b      (-NUMBER-7)             ; C
          .dc.b      (-NUMBER-7)             ; D
          .dc.b      (-NUMBER-7)             ; E
          .dc.b      (-NUMBER-6)             ; F
          .dc.b      (-NUMBER-6)             ; 10
          .dc.b      (-NUMBER-7)             ; 11
          .dc.b      (-NUMBER-7)             ; 12
          .dc.b      (-NUMBER-7)             ; 13
          .dc.b      (-NUMBER-7)             ; 14
          .dc.b      (-NUMBER-7)             ; 15
          .dc.b      (-NUMBER-7)             ; 16
          .dc.b      (-NUMBER-7)             ; 17
          .dc.b      (-NUMBER-7)             ; 18
          .dc.b      (-NUMBER-7)             ; 19
          .dc.b      (-NUMBER-7)             ; 1A
          .dc.b      (-NUMBER-7)             ; 1B
          .dc.b      (-NUMBER-7-DOFF1)    ;D1
          .dc.b      (-NUMBER-7-DOFF2)    ;D2
          .dc.b      (-NUMBER-7-DOFF3)    ;D3
          .dc.b      (-NUMBER-7-DOFF4)    ;D4
          .dc.b      (-NUMBER-7-DOFF5)    ;D5
          .dc.b      (-NUMBER-7-DOFF6)    ;D6
          .dc.b      (-NUMBER-7-DOFF5)    ;D5
          .dc.b      (-NUMBER-7-DOFF6)    ;D6
          .dc.b      (-NUMBER-7-DOFF5)    ;D5
          .dc.b      (-NUMBER-7-DOFF6)    ;D6

; TABLE TO TRANSLATE ANIMATION NUMBER TO BIRD VERTICAL POSITION OFFSET
;         NUMBER + OFFSET
BVPOFF:   .dc.b      (NUMBER-7)&$FF              ; 0
          .dc.b      (NUMBER-7)&$FF          ; 1
          .dc.b      (NUMBER-7)&$FF          ; 2
          .dc.b      (NUMBER-8)&$FF          ; 3
          .dc.b      (NUMBER-8)&$FF          ; 4
          .dc.b      (NUMBER-6)&$FF               ; 5
          .dc.b      (NUMBER-4)&$FF               ; 6
          .dc.b      (NUMBER-4)&$FF               ; 7
          .dc.b      (NUMBER-5)&$FF               ; 8
          .dc.b      (NUMBER-8)&$FF               ; 9
          .dc.b      (NUMBER-8)&$FF               ; A
          .dc.b      (NUMBER-4)&$FF               ; B
          .dc.b      (NUMBER-4)&$FF               ; C
          .dc.b      (NUMBER-7)&$FF               ; D
          .dc.b      (NUMBER-7)&$FF               ; E
          .dc.b      (NUMBER-9)&$FF               ; F
          .dc.b      (NUMBER-7)&$FF               ; 10 WAS -8
          .dc.b      (NUMBER-9)&$FF               ; 11
          .dc.b      (NUMBER-8)&$FF               ; 12
          .dc.b      (NUMBER-9)&$FF               ; 13
          .dc.b      (NUMBER-6)&$FF               ; 14
          .dc.b      (NUMBER-7)&$FF               ; 15
          .dc.b      (NUMBER-4)&$FF               ; 16
          .dc.b      (NUMBER-4)&$FF               ; 17
          .dc.b      (NUMBER-7)&$FF               ; 18
          .dc.b      (NUMBER-7)&$FF               ; 19
          .dc.b      (NUMBER-7)&$FF               ; 1A
          .dc.b      (NUMBER-7)&$FF               ; 1B
          .dc.b      (NUMBER-7+DOFF1)&$FF         ; D1
          .dc.b      (NUMBER-7+DOFF2)&$FF         ; D2
          .dc.b      (NUMBER-7+DOFF3)&$FF         ; D3
          .dc.b      (NUMBER-7+DOFF4)&$FF         ; D4
          .dc.b      (NUMBER-7+DOFF5)&$FF         ; D5
          .dc.b      (NUMBER-7+DOFF6)&$FF         ; D6
          .dc.b      (NUMBER-7+DOFF5)&$FF         ; D5
          .dc.b      (NUMBER-7+DOFF6)&$FF         ; D6
          .dc.b      (NUMBER-7+DOFF5)&$FF         ; D5
          .dc.b      (NUMBER-7+DOFF6)&$FF         ; D6

; TABLE TO TRANSLATE ANIMATION NUMBER TO SHADOW VERTICAL POSITION OFFSET
;         NUMBER + OFFSET
SVPOFF:   .dc.b      (NUMBER-7)&$FF               ; 0
          .dc.b      (NUMBER-8)&$FF               ; 1
          .dc.b      (NUMBER-5)&$FF               ; 2
          .dc.b      (NUMBER-8)&$FF               ; 3
          .dc.b      (NUMBER-9)&$FF               ; 4
          .dc.b      (NUMBER-5)&$FF               ; 5
          .dc.b      (NUMBER-4)&$FF               ; 6
          .dc.b      (NUMBER-5)&$FF               ; 7
          .dc.b      (NUMBER-4)&$FF               ; 8
          .dc.b      (NUMBER-10)&$FF              ; 9
          .dc.b      (NUMBER-10)&$FF              ; A
          .dc.b      (NUMBER-7)&$FF               ; B
          .dc.b      (NUMBER-7)&$FF               ; C
          .dc.b      (NUMBER-11)&$FF              ; D
          .dc.b      (NUMBER-11)&$FF              ; E
          .dc.b      (NUMBER-12)&$FF              ; F
          .dc.b      (NUMBER-12)&$FF              ; 10
          .dc.b      (NUMBER-11)&$FF              ; 11
          .dc.b      (NUMBER-11)&$FF              ; 12
          .dc.b      (NUMBER-8)&$FF               ; 13
          .dc.b      (NUMBER-5)&$FF               ; 14
          .dc.b      (NUMBER-8)&$FF               ; 15
          .dc.b      (NUMBER-11)&$FF              ; 16
          .dc.b      (NUMBER-11)&$FF              ; 17
          .dc.b      (NUMBER-11)&$FF              ; 18
          .dc.b      (NUMBER-11)&$FF              ; 19
          .dc.b      (NUMBER-11)&$FF              ; 1A
          .dc.b      (NUMBER-11)&$FF              ; 1B
          .dc.b      (NUMBER-11+DOFF1)&$FF        ;D1
          .dc.b      (NUMBER-11+DOFF2)&$FF        ; D2
          .dc.b      (NUMBER-11+DOFF3)&$FF        ; D3
          .dc.b      (NUMBER-11+DOFF4)&$FF        ; D4
          .dc.b      (NUMBER-11+DOFF5)&$FF        ; D5
          .dc.b      (NUMBER-11+DOFF6)&$FF        ; D6
          .dc.b      (NUMBER-11+DOFF5)&$FF        ; D5
          .dc.b      (NUMBER-11+DOFF6)&$FF        ; D6
          .dc.b      (NUMBER-11+DOFF5)&$FF        ; D5
          .dc.b      (NUMBER-11+DOFF6)&$FF        ; D6

; TABLE OF DEATH ANIMATION ADDRESSES
;
DEATHANI: .dc.b      BDS1&$FF
          .dc.b      BDS2&$FF
          .dc.b      BDS3&$FF
          .dc.b      BDS4&$FF
          .dc.b      BDS5&$FF
          .dc.b      BDS6&$FF
          .dc.b      BDS5&$FF
          .dc.b      BDS6&$FF
          .dc.b      BDS5&$FF
          .dc.b      BDS6&$FF
          .dc.b      0

; TABLE OF DEATH ANIMATION DELAYS
;
DEATHDEL: .dc.b      3
          .dc.b      4
          .dc.b      5
          .dc.b      $FF
          .dc.b      6
          .dc.b      6
          .dc.b      6
          .dc.b      6
          .dc.b      6
          .dc.b      6
          .dc.b      0

BIRDROOM  EQU     3

RESETXLO: LDA     #$48
          STA     TEMP4                  ;AND I HOPE I CAN USE TEMP4
          BNE     NORESTX

* WE NEED TO DEAL WITH THIS NOT BEING ABLE TO FIND A PLACE
PLACEMNT:
          LDA     #6
          STA     TEMP0                  ;HOPEFULLY I CAN USE TEMP0

          LDA     #ZYLIMLOW              ;THE BIRD WILL BE ON THE GROUND
          STA     YTBL+ZBIRD
          LDA     #$E
          STA     TEMP8                  ; ANIMATION NUMBER FOR PROJECT
          STA     TEMP7                  ; MOVEMENT FLAG

TRYPLAC:
          DEC     TEMP0
          BEQ     RESETXLO
          BPL     USERAND

NORESTX:  LDA     TEMP4
          CLC
          ADC     #2
          STA     TEMP4
          CMP     #ZXLIMHI
          BCC     FLOWINX
          LDA     #ZXLIMLOW              ;IF OVER, TRY LOWEND
          STA     TEMP4
          BNE     FLOWINX

USERAND:  JSR     RANDOM                 ;TRY TO PLACE THE BIRD SAFELY
          LSR     
          LSR     
          ADC     #ZXLIMLOW
          CMP     #ZXLIMHI               ;MAKE SURE IT IS IN X RANGE
          BCS     TRYPLAC

FLOWINX:  CLC
          ADC     #BIRDROOM
          STA     XTBL+ZBIRD
          LDA     #ZBIRDZ+8
          STA     ZTBL+ZBIRD
          JSR     PROJECT                ; X+3,Z+8
          JSR     DOCOL
          BNE     TRYPLAC

          LDA     #ZBIRDZ
          STA     ZTBL+ZBIRD
          JSR     PROJECT                ; X+3,Z
          JSR     DOCOL
          BNE     TRYPLAC

          LDA     XTBL+ZBIRD
          SEC
          SBC     #BIRDROOM*2
          STA     XTBL+ZBIRD
          JSR     PROJECT                ; X-3,Z
          JSR     DOCOL
          BNE     TRYPLAC

          LDA     #ZBIRDZ+8
          STA     ZTBL+ZBIRD
          JSR     PROJECT                ; X-3,Z+8
          JSR     DOCOL
          BNE     TRYPLAC

          LDA     XTBL+ZBIRD
          CLC
          ADC     #BIRDROOM
          STA     XTBL+ZBIRD
          JSR     PROJECT                ; X,Z+8
          JSR     DOCOL
BTRYPLC:  BNE     TRYPLAC

          LDA     #ZBIRDZ
          STA     ZTBL+ZBIRD
          JSR     PROJECT                ; X,Z    - THIS IS WHERE IT STAYS
          JSR     DOCOL
          BNE     BTRYPLC

          LDA     #0                     ;PLACE BIRD BECAUSE WE MADE IT
          STA     DEATH                  ;RESET DEATH STATE

          LDA     #(BIRDHDS)&$FF	;GRAPHICS OF STANDING BIRD
          STA     SLTBL+ZBIRD
          STA     SLTBL+ZSHAD

          LDA     #$80                   ; HOP MODE
          STA     BIRDSTAT

          LDA     #$FF                   ;JOYSTICK VALUE (NO MOTION)
          STA     TEMP0

PUNTSHIT:

          RTS

*         DOCOL   SUBROUTINE TO DO COLLISION DETECTION FOR BIRD
* LEAVES RESULT IN ACCUMULATOR
* MORE WORK SHOULD BE DONE ON DECIDING WHICH POINTS TO USE
DOCOL:    LDA     XTBL+ZBIRD             ;STORE X,Y,AND Z FOR FIRST CALL
          STA     COLPX
          LDA     YTBL+ZBIRD
          STA     COLPY
          LDA     ZTBL+ZBIRD
          CLC
          ADC     #2
          STA     COLPZ
          LDX     #ZBIRD
          JSR     COLDTNC
          BNE     COLDONE                ;Z FLAG SHOULD BE SET

* SHOULD CHECK NARROWER IF ON GROUND OR WATER
          LDA     XTBL+ZBIRD             ;TRY X+3,Y,Z-2
          CLC
          ADC     #3
          STA     COLPX
          LDA     ZTBL+ZBIRD
          SEC
          SBC     #2
          STA     COLPZ
          LDX     #ZBIRD
          JSR     COLDTNC                ;SECOND CALL
          BNE     COLDONE                ;Z FLAG SHOULD BE SET

          LDA     XTBL+ZBIRD             ;TRY X-3,Y,Z-2
          SEC
          SBC     #3
          STA     COLPX
          LDX     #ZBIRD
          JSR     COLDTNC                ;THIRD CALL
COLDONE:  RTS

PROJECT:  LDY     TEMP8                  ; ANIMATION NUMBER FOR OFFSETS

          LDA     XTBL+ZBIRD             ; CALCULATE BIRD AND SHADOW HP
          CLC
          ADC     ZTBL+ZBIRD
          ADC     BHPOFF,Y               ; HPOFF-NUMBER
          STA     HPTBL+ZBIRD            ; HP OF BIRD AND SHADOW
          STA     HPTBL+ZSHAD

          LDA     XTBL+ZBIRD             ; CALCULATE SHADOW VP
          CLC
          ADC     SVPOFF,Y               ; VPOFF+NUMBER
          SEC
          SBC     ZTBL+ZBIRD
          STA     VPTBL+ZSHAD            ; VP OF SHADOW

          LDA     XTBL+ZBIRD             ; CALCULATE BIRD VP
          SEC
          SBC     YTBL+ZBIRD
          CLC
          ADC     BVPOFF,Y               ; VPOFF+NUMBER
          SEC
          SBC     ZTBL+ZBIRD
          STA     VPTBL+ZBIRD            ; VP OF BIRD

          LDA     TEMP7                  ;DON'T DO OBJMOV IF IT DIDN'T
          BEQ     ONLYCOL

WEMOVED:  LDA     #NUMBER-7+DXADJ        ; NUMBER+OFFSET
          SEC
          SBC     XTBL+ZBIRD
          CLC
          ADC     ZTBL+ZBIRD             ; THIS IS DC
          STA     TEMP6
          ADC     #14                    ; THIS IS DF
          STA     TEMP10
          LDX     #ZBIRD
          JSR     OBJMOV
ONLYCOL:
          RTS

ZOUNDS:   LDA     TUNNUM		;Check if tunes are done.
          CMP     #$FF
          BNE     NOZOUND
          LDA     TUNNUM+1
          CMP     #$FF
                                         ;SET Z FLAG
NOZOUND:  RTS

;          END
