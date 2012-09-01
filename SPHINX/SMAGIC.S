********SMAGIC.S  PROCESS POWERS AND TREASURES

;          ZERODEF

;          RSEG    CODE6

*         GOTTREAS - CALLED WHEN BIRD PICKS UP A TREASURE

GOTTREAS: STA     TEMP4                  ;COLSTAT OF TREASURE

          JSR     DELTREAS               ;COUNTS ON INDEX BEING IN X

          LDA     #JWTUNE                ;CALL TREASURE SOUND
          JSR     TUNIN

          LDX     PLAYER                 ;PUT TRVAL INDEX IN X
          BEQ     IHAT3
          INX

IHAT3:    LDA     PHASE
          BMI     BNSTREAS               ;ITS THE BONUS RACK

          LDA     TRVAL1+1,X             ;ADD DIRECTLY TO SCORE
          STA     TENS
          LDA     TRVAL1,X
          STA     HUNDS

          JSR     ADDSCORE

          BIT     TRDSPFLG               ;THIS FLAG SHIT INSURES THAT INITRSMP
          BMI     NOINITT                ;IS CALLED ONLY THE FIRST TIME THAT
                                         ;WE LAND ON A TREASURE

          JSR     INITRSMP

NOINITT:  LDA     TEMP4                  ;GET OBJECT ID
          SEC
          SBC     #TREASCOL
          ASL     
          CLC
          ADC     PLAYER
          TAY

          LDA     JEWCNT,Y
          SED
          CMP     #$9
          BEQ     NOSTOCN                ;IF NINE THEN PUNT
          CLC
          ADC     #1

NOSTOCN:  CLD
          STA     JEWCNT,Y

NOTNOW:   RTS

BNSTREAS: LDA     TRVAL1+1,X
          STA     TEMP10                 ;TENS
          LDA     TRVAL1,X
          STA     TEMP6                  ;HUNDS

          LDA     TEMP4                  ;COLSTAT OF TREASURE
          SEC                            ;GET INDEX INTO TREASURE COUNTERS
          SBC     #TREASCOL
          ASL     
          CLC
          ADC     PLAYER
          TAY

          LDX     JEWCNT,Y
          SED

TVMULT:   LDA     BNSTENS                ;ADD TREASURE VALUE TO BONUS POINTS
          CLC
          ADC     TEMP10
          STA     BNSTENS

          LDA     BNSHUNDS
          ADC     TEMP6
          STA     BNSHUNDS

          LDA     BNSHTHS
          ADC     #0
          STA     BNSHTHS

NOCARRY:  DEX
          BNE     TVMULT                 ;DO FOR EACH MULTIPLE

          CLD

          RTS

* THIS CODE IS CALLED WHEN THE BIRD SHOOTS A TREASURE

HITTREAS:                                 ;COLSTAT OF TREASURE
          BIT     PHASE
          BMI     SAVEME                 ;IGNORE IF IN BONUS

          SEC                            ;ACCUMULATOR HAS COLSTAT OF TREASURE
          SBC     #TREASCOL              ;GET INDEX INTO TREASURE COUNTERS
          ASL     
          CLC
          ADC     PLAYER
          TAY

          LDA     #1
          STA     JEWCNT,Y      ;RESET MULTIPLIER

          ; WE NEED A SOUND FOR THIS

SAVEME:   JMP     DELTREAS               ;THIS WILL RTS

* INITIALIZE THE TREASURE DISPLAY

INITRSMP: LDX     #19

TRMPLP:   LDA     TREASTBL,X
          STA     BOTMSMAP,X
          DEX
          BPL     TRMPLP

          LDA     #$FF
          STA     TRDSPFLG               ; SET FLAG

          RTS

TREASTBL: .dc.b      BLANKCHR&$FF,V&$FF,AA&$FF,L&$FF,U&$FF,E&$FF
	  .dc.b      EQUALS&$FF,0,0,0
          .dc.b      BLANKCHR&$FF,0,JEWCON&$FF,BLANKCHR&$FF,0
	  .dc.b      EGGCON&$FF,BLANKCHR&$FF
          .dc.b      0,BARCON&$FF,BLANKCHR&$FF

*         LDTREAS
ZJEWLOC   EQU     11
ZEGGLOC   EQU     14
ZBARLOC   EQU     17
LDTREAS:
          BIT     PHASE                  ;IF IN BONUS PHASE UNCONDITIONALLY LOAD
          BPL     JUSTREAS               ;BONUS STATE

                                         ;DO BONUS RACK DISPLAY
          LDA     BNSTIMER               ;LOAD STATE NOW
          STA     PTR0                   ;TEMP
          LSR                           ;FIRST THE TIMER
          LSR     
          LSR     
          LSR     
          STA     TOPMSMAP+6
          LDA     PTR0
          AND     #$0F
          STA     TOPMSMAP+7
*         LDSCOREB                       ;LOADS DISPLAY FOR BONUS RACK SCORE
LDSCOREB: LDX     #5                     ;SIX DIGITS
          LDY     #2                     ;THREE BYTES
PEPSIB:   LDA     BNSHTHS,Y              ;GET LOW TWO DIGITS OF BONUS SCORE
          PHA                            ;SAVE AWAY
          AND     #$0F                   ;GET BOTTOM NIBBLE
;         CLC                            ;NUMBERS START AT ZERO
;         ADC     #NUMBERS            ;MAY BE UNNECESSARY
          STA     TEMP0,X                ;STORE AWAY FOR LATER
          DEX
          PLA                            ;GET BACK LOW BYTE AND GET NEXT DIGIT
          AND     #$F0
          LSR     
          LSR     
          LSR     
          LSR     
;         CLC
;         ADC     #NUMBERS
          STA     TEMP0,X
          DEX
          DEY
          BPL     PEPSIB                 ;DO UNTIL ALL 6 DIGITS (3 BYTES) ARE
                                         ;LOADED
          LDA     #$69                   ;SET OVERFLOW
          ADC     #$69
          LDX     #0                     ;THIS ELIMINATES LEADING ZEROES
          LDA     #BLANKCHR&$FF
SPRITEB:  LDY     TEMP0,X
          BVC     NOMORE0B
          BNE     NOMORE0B               ;NOT ZERO SO PUNT ON BLANKS
          STA     TOPMSMAP+14,X
          BEQ     NEXEXB

NOMORE0B: TYA
          STA     TOPMSMAP+14,X
          CLV

NEXEXB:   INX
          CPX     #6
          BNE     SPRITEB

          TYA
          BNE     NOSTUF0B

          LDA     #0                     ;IF ZERO IS LEAST SIGNIFICANT DIGIT
          STA     TOPMSMAP+19            ;THEN DISPLAY IT
NOSTUF0B:

JUSTREAS: BIT     TRDSPFLG               ;IF THIS IS STILL ZERO THEN WE DON'T
          BPL     RTTS                   ;HAVE TO LOAD VALUES YET

          LDX     PLAYER
          LDA     JEWCNT,X               ;LOAD MULTIPLIERS
          STA     BOTMSMAP+ZJEWLOC

          LDA     BARCNT,X
          STA     BOTMSMAP+ZBARLOC

          LDA     EGGCNT,X
          STA     BOTMSMAP+ZEGGLOC

          TXA                            ;LOAD TREASURE VALUE
          BEQ     IHATHIS
          INX

IHATHIS:  LDA     TRVAL1+1,X
          STA     TEMP0
          AND     #$0F
          STA     BOTMSMAP+9
          LDA     TEMP0
          LSR     
          LSR     
          LSR     
          LSR     
          STA     BOTMSMAP+8

          LDA     TRVAL1,X
          AND     #$0F
          STA     BOTMSMAP+7

          LDA     BOTMSMAP+7             ;DO LEADING ZERO SUPPRESSION
          BNE     RTTS
          LDX     #BLANKCHR&$FF
          STX     BOTMSMAP+7

RTTS:     RTS


INITBNS:: LDA     #(-1)&$FF		;INIT OODLES OF BONUS THINGS
          STA     PHASE

          LDX     PLAYER
          SED
          LDA     XTRBNSTM,X             ;EXTRA BONUS TIME
          CLC
          ADC     #$20                   ;MINIMUM BONUS
          STA     BNSTIMER
          CLD
          LDA     #0
          STA     XTRBNSTM,X

          LDA     #0
          STA     BNSTENS
          STA     BNSHUNDS
          STA     BNSHTHS

          BIT     TRDSPFLG
          BMI     LABEL42

          JSR     INITRSMP               ;INCASE IT ISN'T THERE INIT BOTTOM
                                         ;TREASURE MAP
LABEL42:
		lda	#$6F		;Force light blue for text in bonus
		sta	P1C2SHDB	;round.

          LDY     #19                    ;DISPLAY
BNLP:     LDA     BNINTBL,Y
          STA     TOPMSMAP,Y
          DEY
          BPL     BNLP

          LDA     #38                    ;CENTER TOP TREASURE MAP
          STA     DLY+9
          RTS

BNINTBL:  .dc.b      BLANKCHR&$FF,T&$FF,I&$FF,M&$FF,E&$FF
	  .dc.b      BLANKCHR&$FF,BLANKCHR&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,S&$FF,C&$FF
	  .dc.b	     O&$FF,R&$FF,E&$FF,BLANKCHR&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF
	  .dc.b	     BLANKCHR&$FF,BLANKCHR&$FF

ENDBONUS: LDA     BNSTENS
          STA     TENS

          LDA     BNSHUNDS
          STA     HUNDS

          LDA     BNSHTHS
          STA     HUNTHOUS

          JSR     ADDSCORE

          LDX     PLAYER

          LDA     #1                     ;RESET MULTIPLIER FOR PLAYER
          STA     JEWCNT,X
          STA     BARCNT,X
          STA     EGGCNT,X

          TXA                            ;SET FLAG BY DOING TXA

          BEQ     IHAT4
          INX

IHAT4:    LDA     #$50
          STA     TRVAL1+1,X

          LDA     #0
          STA     TRVAL1,X

          RTS

*         EXTRA BONUS TIME POWER

EXTRABNS: LDX     PLAYER

          LDA     XTRBNSTM,X
          CMP     #$70                   ;LIMIT TOTAL BONUS TO 90 SECONDS
          BEQ     GOAWAY

          SED
          CLC
          ADC     #$10                   ;TEN SECONDS OF EXTRA BONUS
          STA     XTRBNSTM,X
          CLD

GOAWAY:   RTS

*         ADDTRVAL        UPDATES TREASURE VALUE
ADDTRVAL:                                 ;ASSUMES VALUE IN A
          SED
          LDX     PLAYER
          BEQ     IHAT2
          INX
IHAT2:    CLC
          ADC     TRVAL1+1,X
          STA     TRVAL1+1,X
          LDA     #0
          ADC     TRVAL1,X
          STA     TRVAL1,X
          CLD

          RTS

********************************************************************************
*                                                                              *
*                                                                              *
*                            HIEROS FOR THE MASSES                             *
*                                                                              *
********************************************************************************

*         GOTHIERO                       ;CALLED WHEN BIRD LANDS ON HIERO
GOTHIERO:
	JSR	GLOHIERO
	JMP	PLAHIERO


;==============================================
;	Game play for Hieros.
;==============================================
;
;   IN:	TEMP1 = Object ID.
;
PLAHIERO:
          LDA     TEMP0                  ;FIRST WE STORE AWAY TYPE OF HIERO

          LDX     PLAYER
          BNE     DOPL2                  ;CAREFUL! TEMP0 IS STORED IN GLOHIERO

; --- Player 1 ------------------------------------------

          LDY     PGNUM,X
          CPY     #3
          BNE     NOTCLR

          LDY     #0                     ;ZERO OUT PGS AS WELL AS RESETING PGNUM
          STY     PGS1+1
          STY     PGS1+2

NOTCLR:   STA     PGS1,Y                 ;PUT HIERO TYPE IN ARRAY

          JMP     NEWNOP

; --- Player 2 ---------------------------

DOPL2:    LDY     PGNUM,X
          CPY     #3
          BNE     NOTCLR2

          LDY     #0                     ;ZERO OUT PGS AS WELL AS PGNUM
          STY     PGS2+1
          STY     PGS2+2

NOTCLR2:  STA     PGS2,Y

; --- For both players --------------------

NEWNOP:
          LDA     HIROSNDS,Y             ;CALL SOUND FOR HIERO
          JSR     TUNIN

          INY                            ;NOW DO A CHECK TO SEE IF ITS POWERTIME
          STY     PGNUM,X                ;CAN DO THIS AS PGNUM IS IN ZERO PAGE
          CPY     #3                     ;TIME FOR A POWER
          BNE     RTSFHIRO

          JSR     DETPOWER               ;DETERMINE WHAT POWER IF ANY IT IS

RTSFHIRO: RTS

HIROSNDS: .dc.b      NHIERO1,NHIERO2,NHIERO3


;============================
;	Hiero gotten.
;============================
;
DETPOWER: 
	jsr	CLRPFLGS	;Turn power flags off.
	lda	#0
	ldx	PLAYER		;ZERO OUT POWER
	sta	PGPOWER,X
	sta	ptCount		;Zero auto counter in case user hit button.
	sta	PTIMER

	LDY     PGSOFF,x
	LDX     PGS1,Y                 ;FIRST HIERO
	LDA     PGHASH1,X

          LDX     PGS1+1,Y               ;SECOND HIERO
          EOR     PGHASH2,X

          LDX     PGS1+2,Y               ;THIRTD HIERO
          EOR     PGHASH3,X

          LDX     #0
PGCMPLP:  CMP     PGDIV,X
          BCS     GOTIT
          INX
          BPL     PGCMPLP

GOTIT:	TXA
	LDA	PGIDENT,X		;GET REAL POWER NUMBER

	jsr	maskPower		;Limit powers to level and round.
					; x and y saved, a = power allowed.
	LDX	PLAYER
	STA	PGPOWER,X

	LDA	#$1F
	STA	ROTATE			;START COLOR ROTATION

	RTS

PGSOFF:   .dc.b      0,3

PGHASH1:  .dc.b      0,$E9,$23,$A8,$53,$FD,$CE,$9F,$69

PGHASH2:  .dc.b      0,$8D,$9A,$C6,$08,$4B,$B3,$1C,$AA

PGHASH3:  .dc.b      0,$38,$EC,$A1,$7B,$55,$B9,$98,$43

PGDIV:    .dc.b      249                    ;SLOWDOWN
          .dc.b      235                    ;POINTS
          .dc.b      229                    ;KILL EVERYTHING
          .dc.b      225                    ;INVINCIBILITY
          .dc.b      220                    ;POINTS
          .dc.b      212                    ;KILL UWES
          .dc.b      204                    ;AFTERBURNER
          .dc.b      197                    ;POINTS
          .dc.b      195                    ;EXTRA LIFE
          .dc.b      185                    ;AIR FREEZE
          .dc.b      173                    ;POINTS
          .dc.b      160                    ;SUPERSONIC SHOTS
          .dc.b      154                    ;HOVER
          .dc.b      133                    ;POINTS
          .dc.b      126                    ;EXTRA BONUS
          .dc.b      119                    ;RANDOM HIEROS
          .dc.b      98                     ;POINTS
          .dc.b      96                     ;KILL SPHINX
          .dc.b      91                     ;CAN'T HOP
          .dc.b      87                     ;POINTS
          .dc.b      84                     ;CAN'T FLY
          .dc.b      76                     ;KILL MINIS
          .dc.b      71                     ;POINTS
          .dc.b      58                     ;KILL POTS
          .dc.b      50                     ;POINTS
          .dc.b      46                     ;CAN'T SWIM
          .dc.b      40                     ;PARALIZE SPHINX
          .dc.b      35                     ;POINTS
          .dc.b      31                     ;DECOY
          .dc.b      23                     ;AIR BOMB
          .dc.b      8                      ;POINTS
          .dc.b      0                      ;WARP

PGIDENT:  .dc.b      18                     ;SLOWDOWN
          .dc.b      2                      ;POINTS
          .dc.b      20                     ;KILL EVERYTHING
          .dc.b      22                     ;INVINCIBILITY
          .dc.b      2                      ;POINTS
          .dc.b      8                      ;KILL UWES
          .dc.b      17                     ;AFTERBURNER
          .dc.b      2                      ;POINTS
          .dc.b      1                      ;EXTRA LIFE
          .dc.b      10                     ;AIR FREEZE
          .dc.b      2                      ;POINTS
          .dc.b      21                     ;SUPERSONIC SHOTS
          .dc.b      16                     ;HOVER
          .dc.b      2                      ;POINTS
          .dc.b      7                      ;EXTRA BONUS
          .dc.b      19                     ;RANDOM HIEROS
          .dc.b      2                      ;POINTS
          .dc.b      6                      ;KILL SPHINX
          .dc.b      12                     ;CAN'T HOP
          .dc.b      2                      ;POINTS
          .dc.b      14                     ;CAN'T FLY
          .dc.b      4                      ;KILL MINIS
          .dc.b      2                      ;POINTS
          .dc.b      5                      ;KILL POTS
          .dc.b      2                      ;POINTS
          .dc.b      13                     ;CAN'T SWIM
          .dc.b      15                     ;PARALIZE SPHINX
          .dc.b      2                      ;POINTS
          .dc.b      11                     ;DECOY
          .dc.b      3                      ;AIR BOMB
          .dc.b      2                      ;POINTS
          .dc.b      9                      ;WARP


*         GIVPOWER                       ;CALLED WHEN RIGHT BUTTON IS PUSHED
GIVPOWER:
	lda	PTIMER		;Already got something cookn'?
	bne	GIVEXIT

          LDX     PLAYER
          LDA     PGPOWER,X              ;IF NO POWER THEN PUNT
          BEQ     GIVEXIT

          TAY                            ;SET UP POWER ROUTINE THROUGH INDIRECT
          LDA     #POWRUSE               ;PLAY TUNE FOR POWER RELEASE
          JSR     TUNIN
          LDA     PWRROUTL,Y             ;JUMP
          STA     PTR0
          LDA     PWRROUTH,Y
          STA     PTR0+1
          JSR     JMPIND                 ;GO TO APPROPRIATE POWER ROUTINE

	lda	PTIMER
	bne	GIVEXIT

powerOff:

	LDA	#0
	LDX	PLAYER		;ZERO OUT POWER
	STA	PGPOWER,X
	sta	ptCount		;Zero auto counter in case user hit button.
	sta	PTIMER

          LDA     PGNUM,X                ;IF THREE HIEROS THEN ZERO OUT NUMBER
          CMP     #3                     ;OF HIEROS
          BNE     GIVEXIT

          LDA     #0
          STA     PGNUM,X

          LDX     PLAYER                 ;ZERO OUT PGS AS WELL
          BEQ     PPONE

          LDX     #3
PPONE:    STA     PGS1,X
          STA     PGS1+1,X
          STA     PGS1+2,X

GIVEXIT:  RTS


*         JMPIND
JMPIND:
          JMP     (PTR0)                 ;GO TO APPROPRIATE POWER ROUTINE
JMPRTS:   RTS

PWRROUTL: .dc.b      JMPRTS&$FF,XLIFE&$FF,JMPRTS&$FF,KAFLEAS&$FF
	  .dc.b	     KAMINIS&$FF,KAFIRES&$FF
          .dc.b      KILLSPHX&$FF,EXTRABNS&$FF,KAUWES&$FF
	  .dc.b	     DOWARP&$FF,FRFLEAS&$FF
          .dc.b      DODECOY&$FF
          .dc.b      NOHOP&$FF,NOSWIM&$FF,NOFLY&$FF,DOPARA&$FF
	  .dc.b	     DOHOVER&$FF,DOSPEED&$FF
          .dc.b      DOSLOW&$FF,DOROUL&$FF,KAOMNI&$FF,DOQUIK&$FF,DOINVINC&$FF

PWRROUTH: .dc.b      JMPRTS/256,XLIFE/256,JMPRTS/256,KAFLEAS/256
	  .dc.b      KAMINIS/256,KAFIRES/256
          .dc.b      KILLSPHX/256,EXTRABNS/256,KAUWES/256
	  .dc.b	     DOWARP/256,FRFLEAS/256
          .dc.b      DODECOY/256
          .dc.b      NOHOP/256,NOSWIM/256,NOFLY/256,DOPARA/256
	  .dc.b      DOHOVER/256,DOSPEED/256
          .dc.b      DOSLOW/256,DOROUL/256,KAOMNI/256,DOQUIK/256,DOINVINC/256

NOTIMP:   RTS

*         WARP POWER
DOWARP:   LDA     #$FF
          STA     WARP                   ;SET WARP FLAG
	sta	PTIMER
          RTS

*         XLIFE                          ;JUST ADDS LIVES
XLIFE:
          INC     PL1LIVES,X             ;X STILL HAS PLAYER NUMBER
          RTS


*         DECOY
DODECOY:  JSR     CLRPFLGS
          LDA     #30
          STA     PTIMER
          JSR     RANDOM
          AND     #$7F
          CLC
          ADC     #1
          STA     NOHOMING
          RTS

*         PARALYSE
DOPARA:   LDA     #(-1)&$FF
          STA     PARASPHX
          RTS

*         SHACKLES/CANT HOP
NOHOP:    JSR     CLRPFLGS
          LDA     #20
          STA     PTIMER
          LDA     #(-1)&$FF
          STA     CANTHOP
          RTS

*         POLYWATER/CANT SWIM
NOSWIM:   JSR     CLRPFLGS
          LDA     #20
          STA     PTIMER
          LDA     #(-1)&$FF
          STA     CANTSWIM
          RTS

*         BROKEN WING/CANT FLY
NOFLY:    JSR     CLRPFLGS
          LDA     #20
          STA     PTIMER
          LDA     #(-1)&$FF
          STA     CANTFLY
          RTS

*         HOVER
DOHOVER:  JSR     CLRPFLGS
          LDA     #20
          STA     PTIMER
          LDA     #(-1)&$FF
          STA     HOVER
          RTS

*         SPEEDUP
DOSPEED:  JSR     CLRPFLGS
          LDA     #20
          STA     PTIMER
          LDA     #(-1)&$FF
          STA     SPEEDUP
          RTS

*         SLOWDOWN
DOSLOW:   JSR     CLRPFLGS
          LDA     #20
          STA     PTIMER
          LDA     #(-1)&$FF
          STA     SLOWDOWN
          RTS

*         ROULETTE
DOROUL:   LDX     PLAYER
          LDA     #2
          STA     PGNUM,X
          LDY     PGSOFF,X
          JSR     RANDOM
          AND     #7
          CLC
          ADC     #1
          STA     PGS1,Y
          JSR     RANDOM
          AND     #7
          CLC
          ADC     #1
          STA     PGS1+1,Y
          LDA     #0
          STA     PGS1+2,Y
          RTS

*         OMNICIDE - KILL ALL ENEMIES
KAOMNI:   JSR     KAFLEAS
          JSR     KAUWES
          JSR     KAMINIS
          JSR     KAFIRES
          JMP     KILLSPHX

*         QUICK SHOTS
DOQUIK:   JSR     CLRPFLGS
          LDA     #6
          STA     QUIKSHOT
          LDA     #20
          STA     PTIMER
          RTS

*         INVINCIBILITY
DOINVINC: JSR     CLRPFLGS
          LDA     #20
          STA     PTIMER
          LDA     #(-1)&$FF
          STA     INVINCBL
LDHEXIT2: RTS


*         LDHIEROS
* LOADS DISPLAY WITH CURRENT HEIROGLYPH STATUS
LDHIEROS:
          BIT     PHASE
          BMI     LDHEXIT2               ;GO AWAY IF IN BONUS RACK

          LDA     DEATH                  ;DO NOT LOAD HIERO STATE WHEN IN
          BEQ     NOEXIT                 ;GAME OVER MODE
          LDA     #$6F
          STA     P1C2SHDB               ;ON DEATH MAKE SURE DISPLAY IS STATIC
          RTS                            ;BYE BYE. TIME TO BLOW THIS CLAMBAKE

NOEXIT:
	lda	#$6F		;Default light blue color for hieros.
	sta	P1C2SHDB

	LDX	PLAYER		
	LDY	PGPOWER,X	
	beq	.ckHelp		;Is there a power?

	lda	PTIMER		;Is power invoked?
	bne	.powerOn	

	lda	ptCount		;Is auot power in effect?
	beq	.ckAuto

.powerOn:
	lda	#$38		;Make auto power red when in effect.
	sta	P1C2SHDB
	jmp	.noHelp

.ckAuto:
	jsr	checkAuto	;Is this an auto power?
	beq	.noHelp		;Don't put up help if auto power.
		
	dec	helpTime	;Time to switch power for help?
	lda	helpTime
	and	#$10
	bne	.noHelp

	lda	#$CA		;Light green.
	sta	P1C2SHDB
	ldy	#24		;Force "HIT R BUTTN" message.
	bne	.noHelp

.ckHelp:		
	lda	RACK,x		;Put up help message only in
	bne	.noHelp		;round 1.

	lda	DIFCULTY	;Put up help message only in
	cmp	#2		;round 1 in Novice and Standard games.
	bcs	.noHelp

	ldy	#23		;Force "GET 3 HIEROS" message.

.noHelp:

	LDA     LOPOWTXT,Y
          STA     PTR0
          LDA     HIPOWTXT,Y
          STA     PTR0+1
          LDY     #10
POWLDLP:  LDA     (PTR0),Y
          STA     TOPMSMAP+8,Y
          DEY
          BPL     POWLDLP

NOWHI:    LDX     PLAYER                 ;THIS SHIT YOU SEE HERE AND MANY PLACES
          BEQ     ONER                   ;GETS THE APPROPRIATE PLAYER INDEX INTO
          LDX     #3                     ;X

ONER:
          LDA     PGS1,X
          ASL     
          TAY
          LDA     PGTABLE,Y
          STA     TOPMSMAP+1
          LDA     PGTABLE+1,Y
          STA     TOPMSMAP+2

          LDA     PGS1+1,X
          ASL     
          TAY
          LDA     PGTABLE,Y
          STA     TOPMSMAP+3
          LDA     PGTABLE+1,Y
          STA     TOPMSMAP+4

          LDA     PGS1+2,X
          ASL     
          TAY
          LDA     PGTABLE,Y
          STA     TOPMSMAP+5
          LDA     PGTABLE+1,Y
          STA     TOPMSMAP+6

          LDA     ROTATE                 ;ROTATE PALETTE FOR TOPMSMAP
          BEQ     LDHEXIT                ;UNLESS ZERO THEN PUNT

          CLC
          ADC     #$0E                   ;SOMEWHAT CONFUSING BUT ROTATE FINISHES
          AND     #$0F                   ;AT ZERO BUT WE WANT COLOR TO BE SET TO
          STA     PTR0                   ;$XF WHEN IT IS FINISHED
          LDA     #$60                   ;THE LAST TIME THIS GOES THROUGH ROTATE
                                         ;IS $01 THEREFORE WE ADD $0E TO GET $0F
          ORA     PTR0                   ;IT DOESN'T MATTER WHAT ROTATE STARTS
          STA     P1C2SHDB               ;AT

          DEC     ROTATE                 ;DECREMENT ROTATE COUNTER

LDHEXIT:
          RTS

*         TABLES FOR HIERO DISPLAY
PGTABLE:  .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,LCANE&$FF,(LCANE+1)&$FF
	  .dc.b      LMWS&$FF,(LMWS+1)&$FF
          .dc.b      LFEATH&$FF,(LFEATH+1)&$FF
          .dc.b      LEYE&$FF,(LEYE+1)&$FF,LAHNK&$FF,(LAHNK+1)&$FF
	  .dc.b	     LBIRD&$FF,(LBIRD+1)&$FF
          .dc.b      LSUN&$FF,(LSUN+1)&$FF,LBOWL&$FF,(LBOWL+1)&$FF

*        TABLES FOR POWER TEXT DISPLAY
LOPOWTXT:
	.dc.b	BLNK&$FF,POWER1&$FF,POWER2&$FF,POWER3&$FF,POWER4&$FF
	.dc.b	POWER5&$FF,POWER6&$FF,POWER7&$FF,POWER8&$FF,POWER9&$FF
	.dc.b	POWER10&$FF,POWER11&$FF,POWER12&$FF,POWER13&$FF
	.dc.b	POWER14&$FF,POWER15&$FF,POWER16&$FF,POWER17&$FF
	.dc.b	POWER18&$FF,POWER19&$FF,POWER20&$FF,POWER21&$FF
	.dc.b	POWER22&$FF,power23&$FF,power24&$FF

HIPOWTXT: .dc.b      BLNK/256,POWER1/256,POWER2/256,POWER3/256
	  .dc.b      POWER4/256,POWER5/256
          .dc.b      POWER6/256,POWER7/256,POWER8/256
	  .dc.b      POWER9/256,POWER10/256,POWER11/256
          .dc.b      POWER12/256,POWER13/256,POWER14/256
	  .dc.b      POWER15/256,POWER16/256
          .dc.b      POWER17/256,POWER18/256,POWER19/256
	  .dc.b      POWER20/256,POWER21/256
          .dc.b      POWER22/256,power23/256,power24/256

BLNK:     .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF
	  .dc.b      BLANKCHR&$FF,BLANKCHR&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF
	  .dc.b      BLANKCHR&$FF,BLANKCHR&$FF
          .dc.b      BLANKCHR&$FF
POWER1:   .dc.b      E&$FF,X&$FF,T&$FF,R&$FF,AA&$FF,BLANKCHR&$FF
	  .dc.b      L&$FF,I&$FF,F&$FF,E&$FF
          .dc.b      BLANKCHR&$FF
POWER2:   .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,P&$FF,O&$FF
	  .dc.b	     I&$FF,N&$FF,T&$FF,S&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF
POWER3:   .dc.b      BLANKCHR&$FF,AA&$FF,I&$FF,R&$FF,BLANKCHR&$FF
	  .dc.b      B&$FF,O&$FF,M&$FF,B&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF
POWER4:   .dc.b      BLANKCHR&$FF,K&$FF,I&$FF,L&$FF,L&$FF,BLANKCHR&$FF
	  .dc.b	     M&$FF,I&$FF,N&$FF
          .dc.b      I&$FF,S&$FF
POWER5:   .dc.b      BLANKCHR&$FF&$FF,K&$FF,I&$FF,L&$FF,L&$FF
	  .dc.b	     BLANKCHR&$FF,(P)&$FF,O&$FF,T&$FF,S&$FF
          .dc.b      BLANKCHR&$FF
POWER6:   .dc.b      K&$FF,I&$FF,L&$FF,L&$FF,BLANKCHR&$FF,S&$FF
	  .dc.b      P&$FF,H&$FF,I&$FF,N&$FF,X&$FF
POWER7:   .dc.b      E&$FF,X&$FF,T&$FF,R&$FF,AA&$FF,BLANKCHR&$FF
	  .dc.b      B&$FF,O&$FF,N&$FF,U&$FF,S&$FF
POWER8:   .dc.b      BLANKCHR&$FF,K&$FF,I&$FF,L&$FF,L&$FF,BLANKCHR&$FF
	  .dc.b      U&$FF,W&$FF,E&$FF
          .dc.b      S&$FF,BLANKCHR&$FF
POWER9:   .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF,W&$FF
	  .dc.b      AA&$FF,R&$FF,P&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF
POWER10:  .dc.b      AA&$FF,I&$FF,R&$FF,BLANKCHR&$FF,F&$FF,R&$FF,E&$FF
	  .dc.b      E&$FF,Z&$FF,E&$FF
          .dc.b      BLANKCHR&$FF
POWER11:  .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF,D&$FF
	  .dc.b      E&$FF,C&$FF,O&$FF,Y&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF
POWER12:  .dc.b      BLANKCHR&$FF,S&$FF,H&$FF,AA&$FF,C&$FF,K&$FF
	  .dc.b      L&$FF,E&$FF,S&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF
POWER13:  .dc.b      BLANKCHR&$FF,P&$FF,O&$FF,L&$FF,Y&$FF,W&$FF,AA&$FF
	  .dc.b      T&$FF,E&$FF,R&$FF
          .dc.b      BLANKCHR&$FF
POWER14:  .dc.b      B&$FF,R&$FF,O&$FF,K&$FF,E&$FF,N&$FF,BLANKCHR&$FF
	  .dc.b      W&$FF,I&$FF,N&$FF,G&$FF
POWER15:  .dc.b      H&$FF,O&$FF,L&$FF,D&$FF,BLANKCHR&$FF,S&$FF,P&$FF
	  .dc.b      H&$FF,I&$FF,N&$FF,X&$FF
POWER16:  .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF,H&$FF,O&$FF
	  .dc.b      V&$FF,E&$FF,R&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF,BLANKCHR&$FF
POWER17:  .dc.b      BLANKCHR&$FF,S&$FF,P&$FF,E&$FF,E&$FF,D&$FF
	  .dc.b      BLANKCHR&$FF,U&$FF,P&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF
POWER18:  .dc.b      BLANKCHR&$FF,S&$FF,L&$FF,O&$FF,W&$FF,BLANKCHR&$FF
	  .dc.b      D&$FF,O&$FF,W&$FF
          .dc.b      N&$FF,BLANKCHR&$FF
POWER19:  .dc.b      BLANKCHR&$FF,R&$FF,O&$FF,U&$FF,L&$FF,E&$FF
	  .dc.b      T&$FF,T&$FF,E&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF
POWER20:  .dc.b      BLANKCHR&$FF,O&$FF,M&$FF,N&$FF,I&$FF,C&$FF
	  .dc.b      I&$FF,D&$FF,E&$FF
          .dc.b      BLANKCHR&$FF,BLANKCHR&$FF
POWER21:  .dc.b      Q&$FF,U&$FF,I&$FF,C&$FF,K&$FF,BLANKCHR&$FF
	  .dc.b      S&$FF,H&$FF,O&$FF,T&$FF,S&$FF
POWER22:  .dc.b      I&$FF,N&$FF,V&$FF,I&$FF,N&$FF,C&$FF,I&$FF
	  .dc.b      B&$FF,L&$FF,E&$FF,BLANKCHR&$FF
power23:
	.dc.b	G&$FF,E&$FF,T&$FF,BLANKCHR&$FF,THREE3&$FF,BLANKCHR&$FF,H&$FF
	.dc.b	I&$FF,E&$FF,R&$FF,O&$FF
power24:
	.dc.b	H&$FF,I&$FF,T&$FF,BLANKCHR&$FF,R&$FF,BLANKCHR&$FF,B&$FF
	.dc.b	U&$FF,T&$FF,T&$FF,N&$FF

CLRPFLGS: LDA     #0                     ;CLEAR TIMED POWER FLAGS
          LDX     #TPNUMB-1
CLRTPLP:  STA     TPSTART,X
          DEX
          BPL     CLRTPLP
          LDA     #3
          STA     QUIKSHOT
          RTS

;          END
