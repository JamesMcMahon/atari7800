	.subttl	"CONSOLIDATE NUMBER INITIALIZATIONS"

	org	$9000



**********PREINIT***************************************************************
PREINIT:                                  ;SET UP POWER UP DEFAULTS

          LDX     #1                     ;SETS DEFAULT MODES FOR STARTUP
          STX     NUMPLYRS
          STX     DIFCULTY               ;STANDARD DIFFICULTY LEVEL
          DEX                            ;PLAYER ONE ONLY
          STX     PLAYER
          LDX     #5                     ;FIVE LIVES ONLY
          STX     PL1LIVES
          STX     PL2LIVES

          JSR     INITGAME
          JSR     MCPINIT
          RTS


**********INITIT****************************************************************

INITIT:                                   ;INITIALIZE STATE TO TITLE PAGE + MENU

          JSR     ABSZERO                ;ZERO OUT ABSOLUTE MEMORY
          JSR     BLANKMAP               ;BLANK OUT CHARACTER MAP
          JSR     SCRAPALL               ;KILL ALL TUNES
          JSR     IOINIT                 ;SET UP SOFTWARE IO REGISTERS
          JSR     DLYZFILL               ;FILL UP DLY AND DLZ

          LDA     #$80                   ;RESET EAST AND WEST JOYSTICK TIMERS
          STA     ETIMER
          STA     WTIMER
          STA     STIMER                 ;SELECT TIMER

          LDA     #35                    ;DISABLE SELECTION FOR FIRST 35 FRAMES
          STA     OTIMER                 ;OF SELECT MODE

NODELAY:
          LDX     #74                    ;COPY TITLE PAGE DISPLAY LIST LIST
DTITLOOP: LDA     TITBL,X
          STA     DLLIST,X
          DEX
          BPL     DTITLOOP

          LDA     #TITSTATE&$FF		;SET UP STATE POINTER FOR INDIRECT JMP
          STA     STATEPTR		;TO TITSTATE
          LDA     #TITSTATE/256
          STA     STATEPTR+1

          LDA     #$4C
          STA     HANDLER
          LDA     #DLITIT&$FF             ;SET UP DLI POINTER FOR THE DLI
          STA     DLIPTR                 ;OF TITLEPAGE
          LDA     #DLITIT/256
          STA     DLIPTR+1

TITLOGO:
          LDA     #TITCHR1/256            ;LOAD HIGH BYTE OF TITLE PAGE CHARS
          STA     CHARBASE               ;INTO CHARBASE

          LDA     #DLLIST&$FF             ;SET UP DPPL AND DPPH FOR TITLE PAGE
          STA     DPPL
          LDA     #DLLIST/256
          STA     DPPH

          LDX     #79
          LDA     #0
ZERODL:   STA     DL0,X
          STA     DL1,X
          STA     DL2,X
          STA     DL3,X
          STA     DL4,X
          STA     DL5,X
          DEX
          BPL     ZERODL


          LDX     #4                     ;FILL DLISTS
TITZNLP:  LDA     TITZN0TB,X             ;WING HEADER FOR DL0
          STA     DL0,X
          LDA     TITZN1TB,X
          STA     DL1,X
          LDA     TITZN2TB,X             ;WING HEADER FOR LEFT SIDE OF DL2
          STA     DL2,X
          LDA     TTZN2TB2,X             ;WING HEADER FOR RIGHT SIDE OF DL2
          STA     DL2+5,X
          LDA     TITZN3TB,X
          STA     DL3,X
          LDA     TITZN4TB,X
          STA     DL4,X
          LDA     TITZN5TB,X
          STA     DL5,X

          LDA     CRTB1,X                ;CREST HEADERS
          STA     DL1+5,X
          LDA     CRTB2,X
          STA     DL2+10,X
          LDA     CRTB3,X
          STA     DL3+5,X
          LDA     CRTB4,X
          STA     DL4+5,X
          LDA     CRTB5,X
          STA     DL5+5,X

          LDA     NOVHDTBL,X             ;NOVICE HEADER MAP
          STA     DL6,X
          LDA     STDHDTBL,X             ;STANDARD HEADER MAP
          STA     DL6+5,X
          LDA     ADVHDTBL,X             ;ADVANCED HEADER MAP
          STA     DL6+10,X
          LDA     EXPHDTBL,X             ;EXPERT HEADER MAP
          STA     DL6+15,X
          LDA     CRHDTBL,X              ;CRIGHT MESSAGE MAP HEADER
          STA     DL7,X

          DEX
          BPL     TITZNLP

          LDX     #3
PAULOOP:  LDA     DSTOPSTP,X             ;'DESERT FALCON' TEXT IS DONE IN DIRECT
          STA     DL1+10,X               ;MODE
          LDA     FCTOPSTP,X
          STA     DL1+14,X
          LDA     DSSTPSTP,X
          STA     DL2+15,X
          LDA     FCSTPSTP,X
          STA     DL2+19,X
          LDA     DSBOTSTP,X
          STA     DL2+23,X
          LDA     FCBOTSTP,X
          STA     DL2+27,X
          LDA     DSSBTSTP,X
          STA     DL3+10,X
          LDA     FCSBTSTP,X
          STA     DL3+14,X

          DEX
          BPL     PAULOOP

          JSR     PLAYTWID               ;TURN ON CORRECT PLAYER
          JSR     DIFFTWID               ;TURN ON CORRECT DIFFICULTY

          LDX     #10                    ;FILLS TOPMSMAP WITH 'PLAYER TEXT'
MOON:     LDA     PLUTOTBL,X             ;TWO PLAYER ON TOP
          STA     TOPMSMAP+2,X
          LDA     MOONTBL,X              ;ONE PLAYER ON BOTTOM
          STA     BOTMSMAP+2,X
          DEX
          BPL     MOON
          LDA     #50                    ;TWO PLAYER ON TOP
          STA     DLY+9
          LDA     #48                    ;ONE PLAYER ON BOTTOM
          STA     DLZ+9

          LDX     #19                    ;FILL CHAR MAPS WITH CHARS FOR WINGS
WINGSLP:  LDA     WNGMPTB0,X             ;FOR WING MAPS 0 THRU 2
          STA     WINGMAP0,X
          LDA     #WINGS1&$FF
          STA     WINGMAP1,X
          STA     WINGMAP2,X
          DEX
          BPL     WINGSLP
          LDA     #WINGS0&$FF             ;HACK FIRST AND LAST CHAR OF WINGMAP2
          STA     WINGMAP2               ;THIS IS TO SAVE BYTES YOU REALIZE
          LDA     #WINGS2&$FF
          STA     WINGMAP2+19

          LDX     #17                    ;FILL CHAR MAPS 3 AND 4
          LDA     #WINGS1&$FF
WNGSLP34: STA     WINGMAP3,X
          STA     WINGMAP4,X
          DEX
          BPL     WNGSLP34
          LDA     #WINGS6&$FF             ;HACK IN END CHARACTERS AS USUAL
          STA     WINGMAP3
          LDA     #WINGS0&$FF
          STA     WINGMAP4
          LDA     #WINGS9&$FF
          STA     WINGMAP3+17
          LDA     #WINGS2&$FF
          STA     WINGMAP4+17

          LDX     #9                     ;FILL WINGMAP5
          LDA     #WINGS1&$FF
WNGSLP5:  STA     WINGMAP5,X
          DEX
          BPL     WNGSLP5
          LDA     #WINGS7&$FF             ;HACK ENDS OF CHARACTER MAP
          STA     WINGMAP5
          LDA     #WINGS8&$FF
          STA     WINGMAP5+9

          LDX     #29                    ;FILL CREST MAP
          LDA     #WINGS1&$FF
CRSTLP:   STA     CRSTMAP1,X
          DEX
          BPL     CRSTLP
          LDA     #WINGS0&$FF
          STA     CRSTMAP1
          STA     CRSTMAP1+12
          STA     CRSTMAP1+22
          STA     CRSTMAP1+28
          LDA     #WINGS2&$FF
          STA     CRSTMAP1+11
          STA     CRSTMAP1+21
          STA     CRSTMAP1+25
          STA     CRSTMAP1+29

          LDX     #11                    ;STUFF MESSAGE MAP WITH COPYRIGHT MSG
SLEEP:    LDA     CRIGHTBL,X
          STA     CRMAP,X
          DEX
          BPL     SLEEP

          LDX     #27                    ;STUFF DIFFICULTY MAPS
DIFMAPLP: LDA     DIFTBL,X               ;ALL DIFF MAPS ARE CONTIGUOUS IN MEM.
          STA     NOVMAP,X
          DEX
          BPL     DIFMAPLP

          LDX     #2                     ;STUFF PALETTES FOR TITLE PAGE
PALSTFLP: LDA     #$0F                   ;CONSTANT
          STA     P0C1,X
          LDA     PALWD1,X
          STA     P1C1,X
          LDA     PALWD2,X
          STA     P2C1,X
          LDA     PALWD3,X
          STA     P3C1,X
          LDA     PALWD4,X
          STA     P4C1,X
          LDA     #$04                   ;CONSTANT
          STA     P5C1,X
          DEX
          BPL     PALSTFLP
          LDA     #$00                   ;LAST BUT NOT LEAST: BACKGRND
          STA     BACKGRND

          RTS

INITLOGO:
          LDX     #23
FILLLOGO: LDA     LOGOTBL,X
          STA     DLLIST,X
          DEX
          BPL     FILLLOGO


          LDA     #$4C
          STA     HANDLER
          LDA     #DLIHSC0&$FF            ;SET UP DLI POINTER FOR THE DLI
          STA     DLIPTR                 ;OF TITLEPAGE
          LDA     #DLIHSC0/256
          STA     DLIPTR+1

          JMP     TITLOGO                ;COMMON TITLE PAGE AND LOGO INITS.

TITBL:                                   ;22 HEADERS = 66 BYTES LONG
          ; FIRST THE 25 BLANK LINES
          .dc.b    $4F,NULHDR/256,NULHDR&$FF
          .dc.b    $48,NULHDR/256,NULHDR&$FF

          ; VISIBLE SCREEN HAS 192 LINES
          ;       FIRST WE HAVE 24 BLANK LINES
          .dc.b     $47,NULHDR/256,NULHDR&$FF
          .dc.b     $4F,NULHDR/256,NULHDR&$FF

          ;       THEN WE HAVE 6 ZONES OF EIGHT HIGH FOR TITLE AND LOGO
          .dc.b     $C7,DL0/256,DL0&$FF		;1ST ZONE TIT PG. WITH INTER.
          .dc.b     $47,DL1/256,DL1&$FF		;2ND ZONE OF TIT PG
          .dc.b     $47,DL2/256,DL2&$FF		;3RD ZONE OF TIT PG
          .dc.b     $47,DL3/256,DL3&$FF		;4TH ZONE OF TIT PG
          .dc.b     $47,DL4/256,DL4&$FF		;5TH ZONE OF TIT PG
          .dc.b     $47,DL5/256,DL5&$FF		;6TH ZONE OF TIT PG

          ;       THEN THERE ARE 64 MORE BLANK LINES
          .dc.b     $4F,NULHDR/256,NULHDR&$FF
          .dc.b     $4F,NULHDR/256,NULHDR&$FF
          .dc.b     $4F,NULHDR/256,NULHDR&$FF
          .dc.b     $4F,NULHDR/256,NULHDR&$FF

          ;       NOW WE HAVE ONE PLAYER MAP:  8 LINES
          .dc.b     $C7,DLY/256,DLY&$FF

          ;       THEN TWO BLANK LINES
          .dc.b     $41,NULHDR/256,NULHDR&$FF

          ;       DIFFICULTY LEVEL:  8 LINES
          .dc.b     $47,DL6/256,DL6&$FF

          ;       TWO BLANK LINES
          .dc.b     $41,NULHDR/256,NULHDR&$FF

          ;       TWO PLAYER MAP:  8 LINES
          .dc.b     $47,DLZ/256,DLZ&$FF

          ;       8 BLANK LINES
          .dc.b     $47,NULHDR/256,NULHDR&$FF
          ;       COPYRIGHT MESSAGE:  8 LINES
          .dc.b     $47,DL7/256,DL7&$FF
          ;       16 BLANK LINES
          .dc.b     $43,NULHDR/256,NULHDR&$FF
          ;       16 MORE: 8 OF WHICH ARE ON THE SCREEN AND 8 WHICH ARE NOT
          .dc.b     $4F,NULHDR/256,NULHDR&$FF
          ;       THE REMAING 32 ARE OFF THE SCREEN
          .dc.b     $4F,NULHDR/256,NULHDR&$FF
          .dc.b     $CF,NULHDR/256,NULHDR&$FF	;25 NEEDED, EXTRA FOR SAFETY

CRIGHTBL: .dc.b     CRIGHT&$FF,BLANKCHR&$FF,AA&$FF,T&$FF,AA&$FF
	  .dc.b     R&$FF,I&$FF,BLANKCHR&$FF
          .dc.b     1,9,8,7                ;12 LONG EGGHEAD

LOGOTBL:                                 ;DLL FOR LOGO ON HSC
                                         ;8 HEADERS 24 BYTES LONG
          ; FIRST THE 24 BLANK LINES    ---TRUST ME, MGF
          .dc.b     $CF,NULHDR/256,NULHDR&$FF	;DLI HERE TO SET COLORS.
          .dc.b     $47,NULHDR/256,NULHDR&$FF

          ;       THEN WE HAVE 6 ZONES OF EIGHT HIGH FOR TITLE AND LOGO
          .dc.b     $47,DL0/256,DL0&$FF		;1ST ZONE TIT PG.
          .dc.b     $47,DL1/256,DL1&$FF		;2ND ZONE OF TIT PG
          .dc.b     $47,DL2/256,DL2&$FF		;3RD ZONE OF TIT PG
          .dc.b     $47,DL3/256,DL3&$FF		;4TH ZONE OF TIT PG
          .dc.b     $47,DL4/256,DL4&$FF		;5TH ZONE OF TIT PG
          .dc.b     $47,DL5/256,DL5&$FF		;6TH ZONE OF TIT PG  WITH INTER


*         HEADERS FOR WINGS

TITZN0TB: .dc.b     WINGMAP0&$FF,$60,WINGMAP0/256,$2C,0
TITZN1TB: .dc.b     WINGMAP1&$FF,$60,WINGMAP1/256,$2C,0

TITZN2TB: .dc.b     WINGMAP2&$FF,$60,WINGMAP2/256,$3A,0
TTZN2TB2: .dc.b     (WINGMAP2+14)&$FF,$60,(WINGMAP2+14)/256,$3A,112

TITZN3TB: .dc.b     WINGMAP3&$FF,$60,WINGMAP3/256,$2E,8
TITZN4TB: .dc.b     WINGMAP4&$FF,$60,WINGMAP4/256,$2E,8
TITZN5TB: .dc.b     WINGMAP5&$FF,$60,WINGMAP5/256,$36,40

*         HEADERS FOR CREST
CRTB1:   .dc.b     CRSTMAP1&$FF,$60,CRSTMAP1/256,$54,32
CRTB2:   .dc.b     CRSTMAP2&$FF,$60,CRSTMAP2/256,$56,40
CRTB3:   .dc.b     CRSTMAP3&$FF,$60,CRSTMAP3/256,$5C,64
CRTB4:   .dc.b     CRSTMAP4&$FF,$60,CRSTMAP4/256,$5E,72
CRTB5:   .dc.b     CRSTMAP5&$FF,$60,CRSTMAP5/256,$5E,72

*         HEADERS FOR ALL PARTS OF 'DESERT FALCON' TEXT
DSTOPSTP: .dc.b     TITCHR1&$FF,$94,TITCHR1/256,28
FCTOPSTP: .dc.b     TITCHR13&$FF,$94,TITCHR13/256,84
DSBOTSTP: .dc.b     TITCHR7&$FF,$94,TITCHR7/256,28
FCBOTSTP: .dc.b     TITCHR19&$FF,$94,TITCHR19/256,84
DSSTPSTP: .dc.b     TITCHR1&$FF,$74,TITCHR1/256,32
FCSTPSTP: .dc.b     TITCHR13&$FF,$74,TITCHR13/256,88
DSSBTSTP: .dc.b     TITCHR7&$FF,$74,TITCHR7/256,32
FCSBTSTP: .dc.b     TITCHR19&$FF,$74,TITCHR19/256,88

*         HEADERS FOR DIFFICULTY MAPS
NOVHDTBL: .dc.b     NOVMAP&$FF,$60,NOVMAP/256,$BA,12
STDHDTBL: .dc.b     STDMAP&$FF,$60,STDMAP/256,$B8,44
ADVHDTBL: .dc.b     ADVMAP&$FF,$60,ADVMAP/256,$B8,84
EXPHDTBL: .dc.b     EXPMAP&$FF,$60,EXPMAP/256,$BA,124

*         HEADER FOR CRIGHT MESSAGE
CRHDTBL:  .dc.b     CRMAP&$FF,$60,CRMAP/256,$14,56

*         CHAR MAP TABLE FOR WINGS
WNGMPTB0: .dc.b     WINGS3&$FF,WINGS4&$FF,WINGS4&$FF
	  .dc.b     WINGS4&$FF,WINGS4&$FF,WINGS4&$FF
          .dc.b     WINGS4&$FF,WINGS4&$FF,WINGS4&$FF
	  .dc.b     WINGS5&$FF,WINGS3&$FF,WINGS4&$FF
          .dc.b     WINGS4&$FF,WINGS4&$FF,WINGS4&$FF
	  .dc.b	    WINGS4&$FF,WINGS4&$FF,WINGS4&$FF
          .dc.b     WINGS4&$FF,WINGS5&$FF,WINGS3&$FF

*         CHAR MAP TABLE FOR DIFFICULTY MAP
DIFTBL:   .dc.b     N&$FF,O&$FF,V&$FF,I&$FF,C&$FF,E&$FF
	  .dc.b     S&$FF,T&$FF,AA&$FF,N&$FF,D&$FF,AA&$FF
          .dc.b     R&$FF,D&$FF,AA&$FF,D&$FF,V&$FF,AA&$FF
	  .dc.b     N&$FF,C&$FF,E&$FF,D&$FF
          .dc.b     E&$FF,X&$FF,P&$FF,E&$FF,R&$FF,T&$FF

*         PALETTES FOR TITLE PAGE
PALWD1:   .dc.b     $31,$3A,$16            ;PALETTE 1 USED FOR WINGS
PALWD2:   .dc.b     $00,$00,$31            ;CREST (NOT THE TOOTHPASTE!)
PALWD3:   .dc.b     $11,$10,$10            ;SHADOWS
PALWD4:   .dc.b     $1B,$37,$44            ;TITLE

*         CHAR MAPS FOR ONE AND TWO PLAYER SHIT

MOONTBL:  .dc.b     BLANKCHR&$FF,O&$FF,N&$FF,E&$FF,BLANKCHR&$FF
	  .dc.b     P&$FF,L&$FF,AA&$FF,Y&$FF
          .dc.b     E&$FF,R&$FF
PLUTOTBL: .dc.b     T&$FF,W&$FF,O&$FF,BLANKCHR&$FF,P&$FF,L&$FF
	  .dc.b	    AA&$FF,Y&$FF,E&$FF,R&$FF,S&$FF

*         THIS TURNS ON THE BRIGHTNESS OF THE CURRENT DIFFICULTY LEVEL
DIFFTWID:
          LDX     #3
DULLOUT:  LDY     DLDEXTBL,X             ;FIRST DULL THEM ALL OUT
          LDA     DFPWDLL,X
          STA     DL6,Y
          DEX
          BPL     DULLOUT

          LDX     DIFCULTY               ;THEN BRIGHTEN THE CORRECT ONE
          LDY     DLDEXTBL,X
          LDA     DFPWBRT,X
          STA     DL6,Y
          RTS

*         WRITES DIFF LEVEL AND NUM. PLAYERS INTO TIT PAGE DISPLAY
DLDEXTBL: .dc.b     3,8,13,18
DFPWBRT:  .dc.b     $1A,$18,$18,$1A        ;BRIGHT
DFPWDLL:  .dc.b     $BA,$B8,$B8,$BA        ;DULL

PLAYTWID: ;TURN ON CORRECT PLAYER
          LDA     #$10                   ;TURN ON: PALETTE 0, WIDTH 12
          LDY     #$B0                   ;TURN OFF: PALETTE 3, WIDTH 12

          LDX     NUMPLYRS
          DEX
          BNE     TWOTWO

          STY     DLY+8                  ;TURN OFF TWO PLAYERS
          STA     DLZ+8                  ;TURN ON ONE PLAYER
          RTS

TWOTWO:   STA     DLY+8                  ;TURN ON TWO PLAYERS
          STY     DLZ+8                  ;TURN OFF ONE PLAYER
          RTS

**********RANDOM INITS**********************************************************
*         ABSZERO:  ZEROES OUT 7800 RAM
ABSZERO:          LDA     #$18                   ;zero out absolute memory
          STA     PTR0+1                 ;this does pages 18 - 20
          LDA     #0
          STA     NULHDR
          STA     NULHDR+1
          STA     PTR0
          TAY
ABSZERLP: STA     (PTR0),Y
          DEY
          BNE     ABSZERLP
          INC     PTR0+1
          LDX     PTR0+1
          CPX     #$20
          BNE     ABSZERLP

          LDX     #$22                   ;THIS DOES PAGES 22 THRU 27
          STX     PTR0+1                 ;A BETTER BE ZERO HERE OR ELSE
REST0LP:  STA     (PTR0),Y
          DEY
          BNE     REST0LP
          INC     PTR0+1
          LDX     PTR0+1
          CPX     #$28
          BNE     REST0LP

          RTS

*         DLYZFILL:  FILLS CHAR MAP AT BOTTOM OF SCREEN
DLYZFILL:
          LDX     #$E
YZFILL:   LDA     YFILL,X
          STA     DLY,X
          LDA     ZFILL,X
          STA     DLZ,X
          DEX
          BPL     YZFILL
          RTS


*         BLANKMAP: BLANKS OUT CHARACTER MAP ON BOTTOM OF SCREEN
BLANKMAP:
          LDX     #39                    ;BLANK OUT CHARACTER MAP ON BOTTOM
          LDA     #BLANKCHR&$FF
LULUPE:   STA     PL1MAP,X
          STA     PL1LVMAP,X
          DEX
          BPL     LULUPE
          RTS

*         IOINIT:  INITIALIZE SOFTWARE IO REGISTERS
IOINIT:
          LDA     #$0B
          STA     SWCHBIO
          STA     OLDSWCHB
          LDA     #$FF
          STA     LEFTBUT+1
          STA     LEFTBUT
          STA     RIGHTBUT
          STA     RIGHTBUT+1
          RTS

**********TOTINIT***************************************************************
TOTINIT:
          JSR     ABSZERO                ;ZERO OUT ABSOLUTE MEMORY
          JSR     BLANKMAP               ;BLANK OUT CHARACTER MAP
          JSR     DLYZFILL               ;FILL DLISTS FOR BOT OF SCREEN DISPLAY
          JSR     IOINIT                 ;INITIALIZE SOFTWARE IO REGISTERS
          JSR     SCRAPALL               ;KILLS ALL TUNES
          JSR     COLINIT                ;INITIALIZE PALETTES

          LDX     #59                    ;COPY DISPLAY LIST LIST
DLLLOOP:  LDA     DLTBL,X
          STA     DLLIST,X
          DEX
          BPL     DLLLOOP

          LDX     #3
STFLIST:
          LDY     ZREFTBL,X              ;INIT LIST REF PNTS
          LDA     IDXTBL,X
          STA     DXTBL,Y
          STA     DFTBL,Y
          LDA     IRLTBL,X
          STA     RLTBL,Y
          LDA     ILLTBL,X
          STA     LLTBL,Y
          DEX
          BPL     STFLIST

          ;THIS LOOP SETS UP SCROLLING OBJECT AREA TO BE EMPTY

          LDA     #SCRENBOT+1
          LDX     #79                    ;FILL VPTBL WITH SCRENBOT+1'S

FILLVPLP: STA     VPTBL,X
          DEX
          BPL     FILLVPLP

          ; THIS LOOP INITIALIZES THE SCROLLING OBJECT QUEUE
          LDX     #PYRSTOP-PYRSTART
          LDY     #PYRSTART
KILLJACK: TYA
          STA     SLOTQ,X
          INY
          DEX
          BPL     KILLJACK

          LDA     #0
          STA     SLOTGPTR
          STA     SLOTRPTR

          ; THIS LOOP INITIALIZES THE SCROLLING OBJECT BUFFER
          LDX     #9
          STX     FRBUFPTR               ;INIT STACK POINTER
ISOBLOOP: LDA     #$FF
          STA     STAMPID,X
          TXA
          STA     FRBUFSTK,X             ;PUT ALL BUFFER LOCATIONS IN FREE STACK
          DEX
          BPL     ISOBLOOP

          ; THIS LOOP INITIALIZES THE MINI SPHINX TABLE
          LDX     #MININUMB-1
          LDA     #$FF
MINITLP:  STA     MINITBL,X
          DEX
          BPL     MINITLP

          ; THIS LOOP INITIALIZES THE FIRE POT TABLE
          LDX     #FIRENUMB-1
          LDA     #$FF
FIRETLP:  STA     FIRETIP,X
          DEX
          BPL     FIRETLP

;         OF COURSE, X IS NOW FF
          STX     HIEROSLT               ;SLOT NUMBER FOR HIERO ANIMATION
          STX     IOSIM                  ;SIMULATED JOYSTICK INPUT OF FF
          STX     ZONEOFF
          STX     UWEOK                  ;OK TO START UWE
          STX     WAITCNT                ;REST WAIT COUNTER
          STX     OSCRLCNT
          DEX                            ;AND AN FE
          STX     JERKOFF

          LDA     #80                    ;THIS IS DEFINED IN GAME AS ZBIRDZ
          STA     ZTBL+ZBIRD

          LDA     #CHARS/256              ;CHARBASES
          STA     CHARBASE
          STA     D11CBASE

;
;  INITIALIZE DISPLAY LISTS
;
          LDX     #11
          LDA     #DL11&$FF
          STA     PTR0
UPTOP:    LDA     HIBYE,X
          STA     PTR0+1
          LDY     #6                     ;Y=6
          LDA     #00
          STA     (PTR0),Y               ;TO END DMA
          DEY                            ;Y=5
          STA     (PTR0),Y               ;TO END DMA
          DEY                            ;Y=4
          STA     (PTR0),Y               ;HPOS
          DEY                            ;Y=3
          LDA     #ZPALWID
          STA     (PTR0),Y
          DEY                            ;Y=2
          LDA     #ZBUFFB/256
          STA     (PTR0),Y
          DEY                            ;Y=1
          LDA     #$60                   ;160X2 INDIRECT MODE
          STA     (PTR0),Y
          DEY                            ;Y=0
          LDA     #ZBUFFB&$FF
          STA     (PTR0),Y
          DEX
          BPL     UPTOP

          ;MORE RANDOM INITIALIZATIONS
          LDA     #1                     ;1
          STA     NEXFRAME
          LDA     #8                     ;NUMBER OF FLEAS AVAILABLE
          STA     NUMFLEAS               ;THE SCREEN
          LDA     #11
          STA     BUFDEX

          LDA     #2                     ;2
          STA     FIRECNT

;
; CODE TO SET UP FOR LOADER
;
          LDX     #23
          LDY     #DL11/256
INITLP9:  STY     ZNDLPOS,X
          DEY
          DEX
          DEX
          BPL     INITLP9

          LDA     #DL8/256                ;MULTIMEGAHACK
          STA     ZNDLPOS+17
          LDA     #DL9/256
          STA     ZNDLPOS+19
                                         ;INITIALIZE LISTS WITH REFERENCE
          LDA     #ZREF0                 ;POINTS
          STA     LOWEST
          LDA     #ZREF3
          STA     HIGHEST

          LDX     #ZSHAD                 ;INSERT SHADOW AND BIRD INTO LIST
          LDA     #$FE
          STA     TEMP6
          STA     TEMP10
          JSR     OBJINS
          LDX     #ZBIRD
          LDA     #50
          STA     TEMP6
          LDA     #60
          STA     TEMP10
          JSR     OBJINS

          ;SET UP PW'S FOR THINGS THAT ARE CONSTANT
          ;PUT SHTBL IN ROM
TESTHERE: LDA     #$1C
          STA     PWTBL+ZBIRD
          LDA     #$3C
          STA     PWTBL+ZSHAD

          ;AND SOME HIGH BYTES

          LDA     #BIRDFMS/256            ;STORE SH'S AND SM'S
          STA     SHTBL+ZBIRD
          STA     SHTBL+ZSHAD
          CLC
          ADC     #1
          STA     SMTBL+ZBIRD
          STA     SMTBL+ZSHAD

          LDX     #3
STFLP:
          LDA     #$3E
          STA     PWTBL+SHOTSHAD,X
          STA     PWTBL+SPXSHTSH,X

          LDA     #$1E                   ; PALETTE 0, 8 WIDE
          STA     PWTBL+ZSHOT1,X
          LDA     #$9E
          STA     PWTBL+SPHXSHOT,X

          LDA     #SHOTAN0/256
          STA     SHTBL+ZSHOT1,X
          STA     SHTBL+SHOTSHAD,X
          CLC
          ADC     #1
          STA     SMTBL+ZSHOT1,X
          STA     SMTBL+SHOTSHAD,X

          LDA     #SPSHOTST/256           ;SPHINX SHOT
          STA     SHTBL+SPHXSHOT,X
          STA     SHTBL+SPXSHTSH,X
          CLC
          ADC     #17-5
          STA     SMTBL+SPHXSHOT,X
          STA     SMTBL+SPXSHTSH,X

          LDA     #SPSHOTST&$FF           ;SPHINX SHOT
          STA     SLTBL+SPHXSHOT,X
          STA     SLTBL+SPXSHTSH,X

          LDA     IPTBLLO,X              ;INIT CIRCULAR BUFFER FOR LOOKAHEAD
          STA     PTRTBLLO,X             ;CHAR MAP POINTER TABLE TO DIRT ONLY

          LDA     IPTBLHI,X
          STA     PTRTBLHI,X

          DEX
          BPL     STFLP

          ;THOSE TRICKY SM'S

          LDA     #2
          STA     SCRATE

          LDA     MASK9L+2               ;STUFF MASKS AS WELL
          STA     LEFTMASK
          LDA     MASK9L+1
          STA     LEFTMASK+1
          LDA     MASK9L
          STA     LEFTMASK+2
          LDA     MASK9L+3
          STA     LEFTMASK+3

          LDA     MASK9R+2               ;STUFF MASKS AS WELL
          STA     RIGTMASK
          LDA     MASK9R+1
          STA     RIGTMASK+1
          LDA     MASK9R
          STA     RIGTMASK+2
          LDA     MASK9R+3
          STA     RIGTMASK+3

          LDX     #2
          STX     STUFFDEX
          INX
          STX     LOADFDEX
          RTS

IDXTBL:   .dc.b     2*NUMBER,200,140,80
ILLTBL:   .dc.b     $FF
ZREFTBL:  .dc.b     ZREF0&$FF
IRLTBL:   .dc.b     ZREF1&$FF,ZREF2&$FF,ZREF3&$FF,$FF

IPTBLLO:  .dc.b     (BLOCK9+66)&$FF,(BLOCK9+33)&$FF,BLOCK9&$FF,(BLOCK9+99)&$FF
IPTBLHI:  .dc.b     (BLOCK9+66)/256,(BLOCK9+33)/256,BLOCK9/256,(BLOCK9+99)/256

TOTINIT2:
          JSR     MCPINIT2

          LDA     #$F1                   ;DO SCROLLS TO FILL SCREEN
JSRAGAIN:
          PHA
          JSR     VSCRP
          JSR     RANDOM
          JSR     GRNDMCP
          JSR     SCRLOAD
          JSR     NEWBLOCK
          LDA     #0
          STA     GSCRFLAG
          STA     GCOARSE
          JSR     SCROLL
          PLA
          TAY
          DEY
          TYA
          BNE     JSRAGAIN

          LDA     #0
          STA     SCRATE                 ;TO STOP SCROLLING
          STA     SCROLLS                ;TO KEEP FROM SCROLLING AGAIN

          JSR     CLRPFLGS
          JSR     PLACEMNT               ;PUT THAT BIRD DOWN
                                         ; THIS DOES PROJECTION
          LDA     SHADANAD,Y
          STA     SLTBL+ZSHAD

          LDA     #DLLIST&$FF             ;SET UP DLIST LIST POINTER
          STA     DPPL
          LDA     #DLLIST/256
          STA     DPPH

          LDA     #DLITOP&$FF             ;INTERRUPT SHIT
          STA     DLIPTR
          LDA     #DLITOP/256             ;ONLY TIME DLIPTR+1 IS STORED!!!!
          STA     DLIPTR+1

          LDA     #$80
          STA     RUNLOAD                ;FLAG TO ENABLE LOADER
          JSR     LOADER                 ;once for good luck

          RTS

INITGAME: LDA     #GAMSTATE&$FF
          STA     STATEPTR
          LDA     #GAMSTATE/256
          STA     STATEPTR+1

          JSR     INITNPLR

          LDA     #5
          STA     PL1LIVES
          STA     PL2LIVES

          LDA     #40                    ;UNDO AUTO PLAY HACK
          STA     DLZ+9

          LDA     #$50                   ;SET UP TREASURE BASE VALUE
          STA     TRVAL1+1
          STA     TRVAL2+1

          LDA     #1                     ;INITIALIZE TREASURE MULTIPLIERS
          STA     JEWCNT
          STA     JEWCNT+1
          STA     BARCNT
          STA     BARCNT+1
          STA     EGGCNT
          STA     EGGCNT+1

BCKSTART:                                ;STARTUP BACKGROUND TUNE
          LDX     #1
BCKINTLP: LDA     #$0
          STA     VBRUN,X
          LDA     #$1
          STA     DBK0,X
          LDA     #$FF
          STA     TBINDX0,X
          STA     CBINDX0,X
          STA     VBINDX0,X
          DEX
          BPL     BCKINTLP

          RTS

PLYONTBL: .dc.b     BLANKCHR&$FF,BLANKCHR&$FF
          .dc.b     P&$FF,L&$FF,AA&$FF,Y&$FF,E&$FF
	  .dc.b     R&$FF,BLANKCHR&$FF,O&$FF,N&$FF,E&$FF
          .dc.b     BLANKCHR&$FF,BLANKCHR&$FF
PLYTWTBL: .dc.b     BLANKCHR&$FF,BLANKCHR&$FF
          .dc.b     P&$FF,L&$FF,AA&$FF,Y&$FF,E&$FF,R&$FF
	  .dc.b     BLANKCHR&$FF,T&$FF,W&$FF,O&$FF
          .dc.b     BLANKCHR&$FF,BLANKCHR&$FF

INITNPLR: LDX     #13                    ;THERE ARE BETTER WAYS BUT THIS IS MOST
GETCHA:   LDA     PLAYER                 ;BYTE EFFICIENT I THINK AND WE'RE NOT
          BEQ     BLAH1                  ;CONCERNED ABOUT TIME HERE
          LDA     PLYTWTBL,X
          BNE     BLAH2                  ;THE ONLY ZERO CHARACTER IS ZERO
BLAH1:    LDA     PLYONTBL,X
BLAH2:    STA     BOTMSMAP+3,X
          DEX
          BPL     GETCHA

          JSR     BCKSTART               ;START BACKGROUND TUNE

          LDA     #$16                   ;TURN ON PALETTE
          LDY     #$B6                   ;TURN OFF PALETTE
          LDX     PLAYER
          BNE     TWOISUP

          STA     DLY+3                  ;PLAYER ONE IS UP: TURN ON HIS SCORE
          STA     DLZ+3                  ;AND LIVES
          STY     DLY+13                 ;TURN OFF PLAYER TWO'S LIVES AND SCORE
          STY     DLZ+13
          RTS

TWOISUP:  STA     DLY+13                 ;PLAYER TWO IS UP: TURN ON HIS SCORE
          STA     DLZ+13                 ;AND LIVES
          STY     DLY+3                  ;TURN OFF PLAYER ONE'S LIVES AND SCORE
          STY     DLZ+3
          RTS


INITAUTO: LDA     #ATOSTATE&$FF
          STA     STATEPTR
          LDA     #ATOSTATE/256
          STA     STATEPTR+1

          LDA     #38                    ;CENTER 'DESERT FALCON' IN BOTMSMAP
          STA     DLZ+9

          LDX     #12
GGJJ2:    LDA     SPHTBL,X
          STA     BOTMSMAP+4,X
          DEX
          BPL     GGJJ2
          RTS


YFILL:    .dc.b     PL1MAP&$FF,$60,PL1MAP/256,$16,0
          .dc.b     TOPMSMAP&$FF,$60,TOPMSMAP/256,$2C,40
          .dc.b     PL2MAP&$FF,$60,PL2MAP/256,$16,120

ZFILL:    .dc.b     PL1LVMAP&$FF,$60,PL1LVMAP/256,$16,0
          .dc.b     BOTMSMAP&$FF,$60,BOTMSMAP/256,$4C,40
          .dc.b     PL2LVMAP&$FF,$60,PL2LVMAP/256,$16,120

DLTBL:    .dc.b     $4F,NULHDR/256,NULHDR&$FF,$C8,NULHDR/256,NULHDR&$FF
          .dc.b     $4F,DL0/256,DL0&$FF,$4F,DL1/256,DL1&$FF
          .dc.b     $4F,DL2/256,DL2&$FF,$4F,DL3/256,DL3&$FF,$4F,DL4/256,DL4&$FF
          .dc.b     $4F,DL5/256,DL5&$FF,$4F,DL6/256,DL6&$FF,$4F,DL7/256,DL7&$FF
          .dc.b     $4F,DL8/256,DL8&$FF,$4F,DL9/256,DL9&$FF,$4F
	  .dc.b     DL10/256,DL10&$FF
          .dc.b     $CF,DL11/256,DL11&$FF,$C0,NULHDR/256,NULHDR&$FF
                  ;one blank line to clean up dma mess
          .dc.b     $47,DLY/256,DLY&$FF,$47,DLZ/256,DLZ&$FF
          .dc.b     $CF,NULHDR/256,NULHDR&$FF,$46,NULHDR/256,NULHDR&$FF

*         FOR PAL HACKING
*         .dc.b     $4F,NULHDR/256,NULHDR&$FF,$4F,NULHDR/256,NULHDR&$FF
*         .dc.b     $4F,NULHDR/256,NULHDR&$FF,$4B,NULHDR/256,NULHDR&$FF

          .dc.b     $CF,NULHDR/256,NULHDR&$FF


SPHTBL:   .dc.b     D&$FF,E&$FF,S&$FF,E&$FF,R&$FF,T&$FF
	  .dc.b     BLANKCHR&$FF,F&$FF,AA&$FF,L&$FF,C&$FF
          .dc.b     O&$FF,N&$FF

