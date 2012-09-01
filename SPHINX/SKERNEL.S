*         SPHINX--SKERNEL.S

;          ZERODEF

;          RSEG    CODE9

***************   ALL DLI'S MUST START ON SAME PAGE!!!!!! ***********


*         DLITOP                         ;FIRST DLI TAKES PLACE AT TOP OF SCREEN
DLITOP:                                  ;SAVE REGISTERS
          PHA                            ;A,X,Y USED
          TXA
          PHA
          TYA
          PHA

          LDA     #$50                   ;RESTORE CTRL TO ITS OWN STATE
          STA     CTRL

          LDA     P0C2SHAD               ;RESTUFF PALETTES FOR GAME SCREEN
          STA     P0C2                   ;SHOULD PROBABLY BE DONE WITH SHADOWS
          LDA     P1C2SHAD
          STA     P1C2                   ;5/25/84
          LDA     P2C2SHAD
          STA     P2C2
          LDA     P5C2SHAD               ;TO UNDO OTHER HACK JEM: 5/14/84
          STA     P5C2

          CLD                            ;RANDOM IS CALLED HERE, SO CLD
;         BIT     FUCKFLAG               ;PUT THESE BACK TO SEE IF LOADER IS
;         BPL     FINE                   ;INTERRUPTED BY THIS DLI
; GOTCHA  NOP
                                         ;REMEMBER THIS DLI HAPPENS EARLIER NOW!
FINE:     LDA     DLZDEST                ;CHANGE DLIPTR
          STA     DLIPTR
          JSR     RANDOM                 ;RANDOM NUMBER GENERATOR
          STA     WSYNC
          LDA     BACKCOL                ;TURN ON BACKGROUND COLOR
          STA     BACKGRND

          BIT     FUCKFLAG
          BPL     DONTFUCK

          JSR     DOZEROS                ;PUT ZEROS AT END OF DISPLAY LISTS

DONTFUCK: PLA                            ;RESTORE REGISTERS
          TAY
          PLA
          TAX
          PLA
          RTI


*         DLIZ11                         ;THIS MUST BE DONE AT END OF ZONE10 TO
* SET CHARBASE FOR ZONE11.  POTENTIALLY A SHORT ZONE AND MAY BE FOLLOWED BY ONE
DLIZ11:
          PHA
          LDA     D11CBASE
          STA     WSYNC                  ;WAIT UNTIL END OF ZONE 10
          STA     CHARBASE
          LDA     #DLIBOT&$FF
                                         ;DMA SHOULD KICK IN HERE
          STA     DLIPTR                 ;NEED TO HAVE TIME TO DO THIS STORE
          PLA
          RTI


*         DLISNCTT        SYNCING DLI FOR TITLE PAGE
DLISNCTT:
          PHA
          LDA     #DLITIT&$FF
          JMP     SYNCSAME

*         DLISYNC         SYNCING DLI FOR REGULAR SCREEN
DLISYNC:                                 ;THIS IS THE SYNCIN' DLI
          PHA                            ;ARE WE SURE THIS IS CORRECT??
          LDA     #DLITOP&$00FF
SYNCSAME: STA     WSYNC
          STA     WSYNC                  ;THIS SHOULD BE END OF KERNEL

          BIT     MSTAT
          BPL     UNSYNC                 ;PUNT IF IN KERNEL
          BIT     MSTAT
          BPL     UNSYNC

          STA     DLIPTR

UNSYNC:
          PLA
          RTI


*         DLZ11A                         ;ALTRNTE. DLI HANDLER FOR 1 LINE ZONE11
DLZ11A:
          PHA

          LDA     D11CBASE
          STA     WSYNC                  ;WSYNC TO FINISH ZONE 10
          STA     CHARBASE               ;NEW CHARBASE FOR ZONE 11


* THIS IS FUNCTIONALITY OF DLIBOT WHICH IS SKIPPED WHEN ZONE11 IS 1 HIGH
          LDA     #DLISYNC&$00FF
          STA     DLIPTR
          STA     WSYNC                  ;THIS SHOULD FINISH ZONE 11

          LDA     #CHARS/256
          STA     CHARBASE               ;THIS IS CHARBASE FOR SCORE

          LDA     #$43
          STA     WSYNC

          STA     CTRL                   ;CTROL VALUE FOR 320 MODE

          LDA     #0                     ;BLACK BACKGROUND
          STA     BACKGRND

          JMP     NOWLOAD

*         DLITIT        TITLE PAGE DLI
DLITIT:                                  ;ALL THESE REGISTERS MAY NOT HAVE TO
          PHA                            ;BE SAVED
          TXA
          PHA
          TYA
          PHA

          LDA     #TITCHR1/256
          STA     CHARBASE

          LDA     #$50                   ;COMMENT
          STA     CTRL

          JSR     DOALLIO
          INC     FRMCNT
          BNE     SHITT
          INC     STATIMER

SHITT:
          LDA     #DLITIT2&$FF
          STA     DLIPTR
          LDA     #DLITIT2/256
          STA     DLIPTR+1

          PLA
          TAY
          PLA
          TAX
          PLA
          RTI

*         DLITIT2                        ;SETS CHARBASE FOR CHAR FONT AT BOTTOM
DLITIT2:                                 ;SECOND TITLE PAGE DLI
          PHA

          LDA     #CHARS/256
          STA     CHARBASE

          LDA     #$43
          STA     CTRL

          LDA     #DLISNCTT&$00FF
          STA     DLIPTR
          LDA     #DLISNCTT/256
          STA     DLIPTR+1

          PLA
          RTI

*         DLIBOT                         ;THIS MUST BE DONE IN DLI AT END OF
DLIBOT:                                  ;REGULAR ZONES
          PHA
                                         ;DLI TO CHANGE BACKGROUND COLOR

          LDA     #CHARS/256
          STA     CHARBASE
          STA     WSYNC                  ;THIS SHOULD FINISH ZONE 11

          LDA     #DLISYNC&$00FF
          STA     DLIPTR

          LDA     #$43                   ;CTRL FOR 320 MODE
          STA     WSYNC

          STA     CTRL

          LDA     #0                     ;BLACKGROUND
          STA     BACKGRND

NOWLOAD:
*         COLOR CHANGES FOR BOTTOM OF SCREEN DISPLAY
          LDA     #$06                   ;THESE ARE HARDWIRED NOT THE ONES AT
          STA     P5C2                   ;TOP OF SCREEN
          LDA     P1C2SHDB               ;SHADOW NEEDED HERE
          STA     P1C2                   ;FOR TOPMSMAP
          LDA     #$3E
          STA     P2C2                   ;FOR BOTMSMAP
          LDA     #$EF
          STA     P0C2                   ;FOR SCORE AND XTRA LIVES

          TXA
          PHA
          TYA
          PHA

          CLD                            ;ONLY NEEDED FOR DLI'S WHICH ADD OR SUB

*         FREEZE FRAMER
FRZFRMR:  BIT     FREEZEP
          BPL     DOTODO

		LDA     PERIOD
		beq	.toNothing

		DEC     NEXFRAME
		beq	.ok1
.toNothing:	jmp	NOTHING
.ok1:

          STA     NEXFRAME

          LDX     HOWMANY
          BEQ     DOTODO
          DEX
          STX     HOWMANY
          BNE     DOTODO

          LDX     #0
          STX     PERIOD
          INX
          STX     NEXFRAME

DOTODO:   INC     FRMCNT                 ;GO FOR FRMCNT
          BNE     BLAH
          INC     STATIMER               ;IT IS TWO BYTES

BLAH:		lda	ENDCOUNT
		beq	.skip
		dec	ENDCOUNT
.skip:
          DEC     SECOND                 ;SECOND COUNTER
          BPL     NOTSECND

          LDA     #59                    ;START NEXT SECOND
          STA     SECOND

          LDA     PHASE                  ;TIME THE BONUS RACK
          CMP     #$FE
          BNE     NOTBONUS               ;NOT IN BONUS RACK

          SED
          LDA     BNSTIMER
          SEC
          SBC     #1
          STA     BNSTIMER
          CLD
          BNE     NOTBONUS               ;NOT DONE WITH BONUS

          JSR     LDTREAS                ;DISPLAY ZERO SECONDS

          DEC     PHASE                  ;GOTO FLASH PHASE
          LDA     #FLASHT0
          JSR     TUNIN
          LDA     #FLASHT1
          JSR     TUNIN

NOTBONUS:
	LDA	PTIMER			;POWER TIMER
	BEQ	.ok1

	jsr	decTimer		;Decrement power timer and flash power.
	jmp	NOTSECND

.ok1:	ldx	PLAYER		
	lda	RACK,x			;Round one?
	bne	NOTSECND		;Only give help message in round 1.

	lda	DIFCULTY		;Novice or Standard game?
	cmp	#2
	bcs	NOTSECND		;Only give help in Novice and Standard.

	lda	PGPOWER,x		;Does player currently have a power?
	bne	.ok2

	lda	#$1F			;Flash "GET 3 HIERO" message.
	sta	ROTATE
.ok2:

NOTSECND: LDA     FRMCNT                 ;DISPATCH ON ODD OR EVEN
          LSR     
          BCC     DOTUNE

DOLOAD:   BIT     RUNLOAD
          BPL     DOTUNE
          JSR     SCROLL                 ;ON ODD, SCROL CMAPS AND RUN LOADER
          JSR     LOADER
          LDA     #0
          STA     RUNLOAD

DOTUNE:   JSR     TUNER                  ;TUNE DRIVER
          JSR     RUNBACK                ;UPDATE BACKGROUND TUNE
          JSR     BACKON                 ;CHECK TO PUT ON BACKGOUND TUNE.  IF
                                         ;SO, SWAP IT IN

NOTHING:
          JSR     DOALLIO

INTEROUT:
          PLA                            ;RESTORE REGISTERS
          TAY
          PLA
          TAX
          PLA
          RTI

ZERO	=	0

DLIHSC0:
          PHA
          TXA
          PHA
          TYA
          PHA
                                         ;DO COLORS, CHARBASE, AND CONTROL
          LDA     #TITCHR1/256
          STA     CHARBASE

          LDA     #$50
          STA     CTRL

          LDA     #DLIHSC1&$FF            ;SAME PAGE I HOPE
          STA     DLIPTR

          LDA     #$0F
          STA     P0C2

          LDA     #$3A
          STA     P1C2

          LDA     #$00
          STA     P2C2

          LDA     #$10
          STA     P3C2

          LDA     #$37
          STA     P4C2

          JSR     TUNER                  ;RUN THE TUNES

          PLA
          TAY
          PLA
          TAX
          PLA
          RTI

DLIHSC1:
          PHA
          TXA
          PHA
          TYA
          PHA

          LDA     #DLIHSC0&$00FF
          STA     DLIPTR

          JSR     HSCSETRS               ;RESETS WAT'S REG'S

          JMP     INTEROUT

********************************************************************************
*                                                                              *
*                                  STARTUP                                     *
*                                                                              *
********************************************************************************

STARTUP:  SEI                            ;HARDWARE DEPENDENT INITS
          CLD
;         LDA     #$07                   ;LOCK ME IN MARIA MODE
          LDA     #$87                   ;PUT THIS IN WHEN WE HAVE 2BUT HARDWARE
          STA     $1
          LDA     #0                     ;FOR FUTURE EXPANSION AND IMPERIALISM
          STA     OFFSET
          LDX     #$FF                   ;STACK POINTER AT $1FF

          TXS

          LDX     #$7F                   ;KEEP COLOR BURST ON
          STX     CTRL                   ;TURN OFF DMA

          LDY     #$FF                   ;zero out zero page
ZERLOOP:
          CPY     #CTRL                  ;DON'T STORE TO CTRL AGAIN
          BEQ     NOSTOR                 ;TO AVOID TURNING ON DMA
          STA     ZERO,Y
NOSTOR:   DEY
          BNE     ZERLOOP

          LDA     #0                     ;ENOUGH TIME HAS ELAPSED TO ALLOW CAPS
          STA     $1                     ;TO DISCHARGE SO CONTINUE FUCKING WITH
          LDA     #$14                   ;IO HARDWARE
          STA     CTLSWB
          LDA     #0                     ;SELECT TWO BUTTON MODE
          STA     SWCHB

          LDX     #$40                    ;POWER UP GETS THIS ONE
          LDA     #0
LEVEL1LP: STA     ZERO,X
          INX
          BNE     LEVEL1LP
          JSR     PREINIT                ;THIS SETS UP THE POWER UP DEFAULT
          JSR     INITIT
                                         ;MODES FOR THE GAME
          JMP     VBLNK

GAMEDO:                                  ;RESETS GO TO HERE
          LDX     #FUTEXP1
          LDA     #0
LEVEL2LP: STA     ZERO,X
          INX
          BNE     LEVEL2LP
;
          JSR     TOTINIT
          JSR     MCPINIT                ;TAKEN OUT OF TOTINIT
          JSR     TOTINIT2
;
          BIT     GAMEU
          BPL     SHINIT
;
          JSR     INITGAME
          JMP     SHINIT

NEWPLYDO:                                ;AUTOPLAY GOES HERE
          LDX     #FUTEXP3		;!!!!!!!!!
          LDA     #0
LEVEL3LP: STA     ZERO,X
          INX
          BNE     LEVEL3LP
          JSR     TOTINIT
          JSR     TOTINIT2
;
          BIT     TITLMENU               ;TITLMENU?
          BMI     CKPLR
          JSR     INITIT                 ;YES, JSR INITIT AND CONTINUE
          JMP     VBLNK

CKPLR:    BIT     NEWPLYR
          BPL     ATOCK
          JSR     INITNPLR
          JMP     SHINIT
ATOCK:    BIT     AUTOPLAY
          BPL     SHINIT
          JSR     INITAUTO
          JMP     SHINIT

SHINIT:
VBLNK:    BIT     MSTAT                  ;WAIT FOR V BLANK
          BPL     VBLNK
          BIT     MSTAT                  ;DO WE STILL NEED TWO OF THESE???
          BPL     VBLNK                  ;NO

          LDA     #$50                   ;FINALLY TURN ON DMA
          STA     CTRL

          BIT     NEWPLYR
          BMI     JFK

          LDA     #ALADIN1               ;START TUNE     THIS IS BULLSHIT
          JSR     TUNIN                  ;COMMENTED OUT CAUSE I CANT STAND IT
          LDA     #ALADIN0
          JSR     TUNIN

JFK:      LDA     #0                     ;FLAGS JOB IS DONE SO RESET
          STA     NEWPLYR


MAINLOOP:
          LDA     SWCHBIO                ;GET CURRENT STATE OF IO
          TAY                            ;TUCK SWCHBIO AWAY FOR NOW
          EOR     OLDSWCHB
          BEQ     CONTGAME               ;NO CHANGE IN IO SO BRANCH

*         CHANGE!  IS IT A RESET?
          LSR                            ;CHECK FOR CHANGE IN RESET
          BCC     PCHKSLCT               ;NO CHANGE SO CHECK SELECT
          LSR     OLDSWCHB               ;CHECK OLD RESET BIT IF ZERO
                                         ;THEN WE'VE GOT A RESET
          BCS     CHEKSLCT               ;OTHERWISE CHECK FOR SELECT
                                         ;CARRY CLEAR SO CHANGE IN RESET BIT
                                         ;& OLD VALUE OF ZERO INDICATES A RESET
GOTOGAME: LDX     #$7F                   ;DONT'T TURN OFF COLOR BURST
          STX     CTRL                   ;BUT DONT TURN OFF DMA
          LDX     #$FF
          STX     TITLMENU               ;TURN OFF TITLMENU FLAG
          STX     GAMEU                  ;TURN ON GAME FLAG
          INX
          STX     NEWPLYR                ;MAKE SURE NEWPLYR IS OFF
          STX     PAUSE                  ;TURN OFF ALL OTHER STATE FLAGS
          STX     HSC                    ;FOR SECURITY
          STX     AUTOPLAY
          STX     DMA
          STX     GAMEOVR
          STX     PLAYER                 ;PLAYER 1 IS FIRST
          JMP     GAMEDO

*         IS IT A SELECT?
PCHKSLCT: LSR     OLDSWCHB               ;ACCUM. HAS EOR OF SWCHB AND OLDSWCHB
CHEKSLCT: LSR                            ;CHECK FOR SELECT BIT
          BCC     PPAWS                  ;NO SELECT CHECK FOR PAUSE NEXT

          LSR     OLDSWCHB               ;POSSIBLE SELECT CHECK FOR 0 TO 1 TRANS
          BCC     MENOPAWS               ;1 TO 0 TRANSITION SO IGNORE
                                         ;LOOKS LIKE A SELECT TO ME
          BIT     TITLMENU               ;BUT ARE WE ALREADY IN TIT PGE. IF SO
          BPL     MENOPAWS               ;PUNT

GOTOTIT:  LDX     #0
          STX     STATIMER               ;RESET STATIMER
          STX     GAMEU                  ;TURN OFF GAME IF ON
          STX     NEWPLYR                ;TURN OFF NEWPLYR
          STX     TITLMENU               ;TURN ON TITLMENU
          STX     AUTOPLAY               ;TURN OFF AUTOPLAY
          STX     DMA                    ;TURN OFF DMA FLAG
          STX     GAMEOVR                ;TURN OFF GAME OVER FLAG IF SET

NEWPLR:   LDX     #$7F                   ;SWITCH PLAYERS BUT
          STX     CTRL
          LDX     #$FF
          TXS                            ;THIS IS PROBABLY NOT NECESSARY
          JMP     NEWPLYDO               ;GO TO TITLE PAGE

PPAWS:    LSR     OLDSWCHB
MENOPAWS: LSR                           ;THIS JUST SETS A FLAG WHICH GAME LOOKS
          LSR                           ;AT.  SHIFT TO CHECK PAUSE BIT
          BCC     CONTGAME

          LSR     OLDSWCHB               ;CHECK TO SEE IF OLD VALUE IS LOW
          LSR     OLDSWCHB
          BCS     CONTGAME               ;NOT LOW SO PUNT

          LDA     #$FF                   ;PAUSE BUTTON HAS BEEN PRESSED
          STA     PAWSTWID

CONTGAME: STY     OLDSWCHB
          JMP     (STATEPTR)             ;JUMP TO APPROPRIATE STATE


*         GAME STATE
GAMSTATE: BIT     GAMEOVR                ;IF OVER BOOGIE ON TO TITLE PAGE
          BPL     NOGOTIT

          LDX     #$7F                   ;WHO THE FUCK KNOWS ANYWAY
          STX     CTRL
          JSR     HSPOWNIT
          JSR     HSGAMOVR
          JMP     GOTOTIT

NOGOTIT:  BIT     NEWPLYR                ;IF NOT OVER BUT NEW PLAYER RESET
          BMI     NEWPLR

          BIT     PAWSTWID
          BPL     JPDOGAME
                                         ;SET UP PAUSE STATE
          LDX     #$FF
          STX     FREEZEP                ;TURN ON FREEZE FRAME
          LDA     #PSESTATE&$FF           ;INITIALIZE POINTER TO PAUSE
          STA     STATEPTR
          LDA     #PSESTATE/256
          STA     STATEPTR+1
          INX
          STX     GAMEU                  ;TURN OFF GAME FLAG
          STX     PAWSTWID               ;TURN OFF PAUSE TWIDDLE
          STX     AUDV0                  ;KILL SOUNDS
          STX     AUDV1                  ;TUNER NEVER CALLED WHEN IN FREEZE MODE
          JMP     MAINLOOP

JPDOGAME: JMP     DOGAME


*         PAUSE STATE
PSESTATE:
          BIT     PAWSTWID
          BPL     JMNLP                  ;PAUSE TWIDDLE NOT SET SO JMP MAINLOOP

          LDX     #$FF                   ;GO BACK TO GAME STATE
          STX     GAMEU

          INX
          STX     PAWSTWID
          STX     FREEZEP                ;TURN OFF FREEZE FRAMER
          STX     PAUSE                  ;TURN OFF PAUSE
          LDA     #GAMSTATE&$00FF	;INITIALIZE POINTER FOR GAME STATE
          STA     STATEPTR
          LDA     #GAMSTATE/256
          STA     STATEPTR+1
JMNLP:    JMP     MAINLOOP


*         TIT STATE
TITSTATE:                                ;ONLY DO IT ONCE A FRAME???
          LDA     FRMCNT
          CMP     TITCNT
          BEQ     JMNLP

          LDA     FRMCNT
          STA     TITCNT

          DEC     OTIMER                 ;HAVE WE WAITED AFTER INITIAL START
          BNE     JMNLP                  ;OF TITLE PAGE

          LDA     #1                     ;HACK TO DEACTIVATE OTIMER
          STA     OTIMER

          BIT     LEFTBUT                ;CHECK FOR TRIGGER RESET
          BMI     SLDKFJ

          JMP     GOTOGAME               ;BUTTON PRESSED, SO RESET TO GAME MODE

SLDKFJ:   LDA     SWCHA                  ;ANY PLAYER ONE JOYSTICK INPUT RESET
          AND     #$F0                   ;TIMER
          CMP     #$F0
          BEQ     NOTIMRST
          LDA     #0
          STA     STATIMER

NOTIMRST: LDA     SWCHB                  ;IS SELECT DEPRESSED?
          AND     #$02
          BEQ     CHKSTIM                ;YES, BRANCH

          LDA     #$80                   ;NO MAKE SURE TIMER ISN'T STARTED
          STA     STIMER
          BMI     DIFFCHK                ;AND CONTINUE TO OTHER CODE

CHKSTIM:  LDA     #0                     ;IO HAS OCCURRED SO RESET TIT. PGE TIMR
          STA     STATIMER

          LDA     #$80                   ;BLOW OTHER TIMERS OUT OF THE WATER
          STA     ETIMER                 ;SELECT SWITCH HAS PRIORITY OVER
          STA     WTIMER                 ;JOYSTICK

          BIT     STIMER                 ;HAS TIMER BEEN SET?
          BMI     CHGSETNG               ;NO SO GO AHEAD AND CHANGE SETTING

          DEC     STIMER                 ;TIMER IS SET SO DECREMENT IT
          BNE     JMNLP                  ;PUNT IF NOT AT ZERO

CHGSETNG: INC     DIFCULTY               ;CYCLE THROUGH DIFFICULTIES
          LDA     DIFCULTY
          AND     #$03
          STA     DIFCULTY		;Range 0-3
          BNE     TWIDIL
          LDA     NUMPLYRS
          EOR     #$03
          STA     NUMPLYRS
          JSR     PLAYTWID
TWIDIL:   JSR     DIFFTWID
          LDA     #35
          STA     STIMER
          JMP     MAINLOOP

DIFFCHK:  LDA     SWCHA
          AND     #$80                   ;CHECK EAST BIT
          BEQ     CHKETIM                ;YES

          LDA     #$80                   ;NO, SO ENABLE EAST MOVEMENT
          STA     ETIMER
          BMI     CHKWEST

CHKETIM:  BIT     ETIMER                 ;IS EAST MOVEMENT ENABLED?
          BMI     INCDIFF                ;YES SO INC DIFFICULTY

          DEC     ETIMER                 ;NOT ENABLED SO WE MUST COUNT DOWN
          BNE     CHKWEST                ;AND THEN GO AWAY

INCDIFF:  INC     DIFCULTY               ;INCREMENT DIFFICULTY LEVEL
          LDA     DIFCULTY
          AND     #$03
          STA     DIFCULTY		;Range 0-3
          JSR     DIFFTWID
          LDA     #35
          STA     ETIMER                 ;DISABLE EAST MOVEMENT AND SET TIMRE

CHKWEST:  LDA     SWCHA
          AND     #$40
          BEQ     CHKWTIM

          LDA     #$80
          STA     WTIMER
          BMI     SELCHK

CHKWTIM:  BIT     WTIMER
          BMI     DECDIFF

          DEC     WTIMER
          BNE     SELCHK

DECDIFF:  DEC     DIFCULTY
          LDA     DIFCULTY
          AND     #$03
          STA     DIFCULTY		;Range 0-3
          JSR     DIFFTWID
          LDA     #35
          STA     WTIMER

SELCHK:   LDA     SWCHA                  ;CHECK NORTH BIT FOR NUMBER OF PLAYERS
          AND     #$F0
          CMP     #$E0                   ;SELECT
          BNE     CHKSOUTH

          LDX     #2
          STX     NUMPLYRS               ;TWO PLAYERS
          JSR     PLAYTWID

          JMP     TIMCHK

CHKSOUTH:                                ;A STILL HAD SWCHA AND F0
          CMP     #$D0                   ;CHECK SOUTH BIT
          BNE     TIMCHK                 ;ACCUMULATOR STILL SET FROM LDA ABOVE

          LDX     #1
          STX     NUMPLYRS               ;SET NUMBER OF PLAYERS TO ONE
          JSR     PLAYTWID

TIMCHK:   LDA     STATIMER               ;CHECK FOR TIMEOUT
          CMP     #4
          BNE     .MJMP

          LDX     #$7F                   ;DONT' TURN OFF COLOR BURST
          STX     CTRL                   ;BUT TURN OFF DMA

          JSR     HSPOWNIT
          JSR     HSDISP                 ;DO HIGH SCORE CART DISPLAY

          LDX     #$7F                   ;WHEN IN DOUBT TURN OFF CTRL
          STX     CTRL

          LDX     #$FF
          TXS
          STX     TITLMENU               ;TURN OFF TITLEMENU
          STX     AUTOPLAY               ;TURN ON AUTOPLAY
          INX
          STX     STATIMER               ;CLEAR TIMING FLAG
	JSR	EXTRAINIT		;!!!!!!!!!
          JMP     NEWPLYDO

.MJMP:    JMP     MAINLOOP


*         AUTOPLAY STATE
ATOSTATE: BIT     LEFTBUT                ;CHECK FOR TRIGGER RESTART
          BMI     TIMCHKA

          JMP     GOTOGAME               ;GO TO GAME STATE TRIGGER PRESSED

TIMCHKA:  LDA     STATIMER               ;MORE TIMEOUT CHECKS
          CMP     #5
          BNE     CHKSTK

GOTOSEL:  JMP     GOTOTIT                ;DON'T TURN OFF COLOR

CHKSTK:   LDA     SWCHA                  ;CHECK FOR SELECT
          AND     #$F0
          CMP     #$F0
          BNE     GOTOSEL




DOGAME:   LDA     FRMCNT                 ;MAIN LOOP
          SEC
          SBC     OLDFRM
          CMP     #2                     ;ONLY EXECUTE EVERY OTHER FRAME
          BCS     DOALL
          JSR     RANDOM                 ;DO RANDOM IF NOTHING LEFT TO DO
          JMP     MAINLOOP
DOALL:    LDA     FRMCNT                 ;THIS IS THE MAMA LOOP
          STA     OLDFRM

          INC     MAINCNT
          BNE     DOALL1
          LDX     PLAYER
;         INC     GAMETIME,X
DOALL1:
          BIT     RUNLOAD
          BMI     DOALL1

          LDA     PHASE
          BPL     .NOFLASH
          CMP     #$FE
          BCC     FLASH                  ;FLASH STARTS AT -3

.NOFLASH: JSR     VSCRP
          LDA     #$80
          STA     RUNLOAD
          JSR     ENEMYMCP               ;MCP FOR NON-SCROLL RELATED ENEMIES
          JSR     GRNDMCP                ;CALL MCP FOR SCROLLING COUPLED ENEMIES
          JSR     GAME                   ;BIRD AND SHOT DRIVER AND OTHER THINGS
          JSR     ANIMFLEA               ;FLEA DRIVER
          JSR     UWEANIM                ;UWE DRIVER
          JSR     SCRLOAD
          JSR     DOMINIS
          JSR     DOSPHINX
          JSR     DOSXSHTS
          JSR     DOFIRE
          JSR     DOHIEROS
          JSR     NEWBLOCK
          JSR     LDSCORE                ;LOAD SCORE DISPLAY
          JSR     LDLIVES                ;LOAD LIVES DISPLAY
          JSR     LDTREAS                ;LOADS TREASURE DISPLAY

          JSR     LDHIEROS               ;LOAD HEIROGLYPH DISPLAY
*         JSR     LDPOWER                ;LOAD POWER DISPLAY
*****
          LDA     #0
          STA     GSCRFLAG
          STA     GCOARSE
          JMP     MAINLOOP               ;AND AGAIN AND AGAIN

** FLASH COLORS ON THE SCREEN **
FLASH:    DEC     PHASE
          LDA     PHASE
          CMP     #$C4			;TIME THE FLASH, -60.
          BNE     CCFL0

          LDX     PLAYER
          INC     RACK,X

          LDA     #0
          STA     SVDIST,X
          STA     SVDIST+2,X
          STA     SVHDIST,X
          STA     SVHDIST+2,X

          LDA     #$FF
          STA     NEWPLYR

          JSR     ENDBONUS

          LDA     #0
          STA     PHASE

          JMP     MAINLOOP

* SET RANDOM COLORS INTO ALL PALLETTES *
CCFL0:    LDX     #$1F
CCFL1:
          JSR     RANDOM
          STA     BACKGRND,X
CCFL2:    DEX
          BMI     FNOMORE
          TXA
          AND     #3
          BNE     CCFL1
          BEQ     CCFL2
FNOMORE:
          JSR     RANDOM
          STA     BACKCOL

          JMP     MAINLOOP


RANDOM:   ADC     FRMCNT                 ;RANDOM NUMBER GENERATOR
          ADC     RNDOM
          ADC     RNDOM1
          PHA
          LDA     RNDOM
          STA     RNDOM1
          PLA
          STA     RNDOM
	clc
          RTS

*         DOALLIO         MAPS HARDWARE FIREBUTTON INTO SOFTWARE REGS. SAME FOR
* SWCHB.  COMPLEMENTS OF ETHAN
DOALLIO:
          LDA     SWCHA                  ;FOR TRIGGERING BREAKPOINTS.  WILL BE
                                         ;MADE INTO MECHANISM TO STUFF SOFTWARE
                                         ;REGISTERS
          LDA     SWCHB                  ;GET SWCHB FOR RESETS AND SUCH
          AND     #$0B
          STA     SWCHBIO

CKJOY:    LDX     #1                     ;DO PLAYERS 1 AND 0
ZNXTRJ:   JSR     READJOY                ;READ HIS JOYSTICK
          DEX
          BPL     ZNXTRJ
          RTS

* READJOY: READ JOYSTICK/BUTTONS.  ON ENTRY X = PLAYER.  Y GETS TRASHED
READJOY:  LDY     INPT4,X
          BPL     GOTONE                 ;IF BIT 7 IS LO, OLD-STYLE BUTTON HIT

          LDA     ONEBUT                 ;ARE WE ALREADY IN OLD-STYLE MODE?
          AND     RJBITS,X
          BNE     GOTONE2                ;YES.  GO RIGHT TO ONE-BUTTON HANDLER.

          TXA                            ;OTHERWISE, COMPUTE INDEX INTO
          ASL                           ; PADDLE PORTS, FOR PLAYER X,
          TAY                            ; IN Y (X * 2)

          LDA     INPT4L,Y               ;READ LEFT BUTTON
          EOR     #$FF                   ;INVERT SENSE
          STA     LEFTBUT,X
          LDA     INPT4R,Y               ; RIGHT BUTTON
          EOR     #$FF                   ;INVERT SENSE
RJSTORE:  STA     RIGHTBUT,X

RJRTS:    RTS

          ;HERE ON OLD-STYLE SINGLE BUTTON JOYSTICK PRESS.
GOTONE:   LDA     ONEBUT                 ;SET ONE-BUTTON MODE IMMEDIATELY
          ORA     RJBITS,X               ; TO AVOID DESTROYING HARDWARE!
          STA     SWCHB
          STA     ONEBUT                 ;UPDATE ONE BUTTON FLAG BYTE

          ;HERE ON ANY OLD-STYLE JOYSTICK, WHETHER PRESSED OR NOT
GOTONE2:  TYA
          STA     LEFTBUT,X              ; (Y CONTAINS CURRENT VALUE OF INPT4)
          STA     RIGHTBUT,X             ;CLEAR RIGHT BUTTON COPY

          RTS

RJBITS:   .dc.b      $04,$10                ;MASK OF "ONE-BUTTON" BITS PER PLAYER
          RTS


*         PUT ZEROS AT THE END OF EACH DISPLAY LIST

DOZEROS:  TXA
          PHA
          TYA
          PHA

          LDA     #0                     ;STORE ZEROES AT END OF DLISTS
          TAX                            ;TRADE ROM FOR TIME
          LDY     #1                     ;TWO ZEROS EACH
          STA     (ZNDLPOS,X)
          STA     (ZNDLPOS),Y
          STA     (ZNDLPOS+2,X)
          STA     (ZNDLPOS+2),Y
          STA     (ZNDLPOS+4,X)
          STA     (ZNDLPOS+4),Y
          STA     (ZNDLPOS+6,X)
          STA     (ZNDLPOS+6),Y
          STA     (ZNDLPOS+8,X)
          STA     (ZNDLPOS+8),Y
          STA     (ZNDLPOS+10,X)
          STA     (ZNDLPOS+10),Y
          STA     (ZNDLPOS+12,X)
          STA     (ZNDLPOS+12),Y
          STA     (ZNDLPOS+14,X)
          STA     (ZNDLPOS+14),Y
          STA     (ZNDLPOS+16,X)
          STA     (ZNDLPOS+16),Y
          STA     (ZNDLPOS+18,X)
          STA     (ZNDLPOS+18),Y
          STA     (ZNDLPOS+20,X)
          STA     (ZNDLPOS+20),Y
          STA     (ZNDLPOS+22,X)
          STA     (ZNDLPOS+22),Y

          PLA
          TAY
          PLA
          TAX
          RTS


