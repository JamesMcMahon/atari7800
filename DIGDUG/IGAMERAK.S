********************************************************************************
***********                                                           **********
***********       INIT:  CALLED UPON POWER-UP, THIS INITIALIZES       **********
***********              THE DISPLAY LISTS, SKY IN DIRTMAP, AND       **********
***********              CALLS INITGAME TO INITIALIZE ATTRACT MODE.   **********
***********                                                           **********
********************************************************************************
*IGAMERAK
INIT
          LDA     #0
          STA     VBLANK
          STA     INTIM
          STA     HSCOREX
          STA     AVAROBIN
*         STA     ALIEN

          LDX     #CSET1
          STX     CHARBASE
          LDX     #$B5                   ;WILL NEED DIFF VALUE FOR PAL/SECAM
          STX     SYNCFRAM               ;WILL NEED DIFF VALUE FOR PAL/SECAM
          LDX     #$4C                   ;SET UP JUMP INSTRUCTION FOR DLI'S.
          STX     DLIJMP
          LDX     #L(DLISETUP)
          STX     DLIVECT
          LDX     #H(DLISETUP)
          STX     DLIVECT+1

          STA     $38                    ; A CONTAINS 0
          STA     DUMMYDPL+1

*         STA     CURSONG                ;THESE 11 REGISTERS ARE ZERO PAGE.
*         STA     SNGTEMP1               ;THEY MUST BE KEPT ADJACENT TO BE
*         STA     LASTMOVE               ;SERVED BY THE FOLLOWING LOOP.
*         STA     DLSTPTR
*         STA     NUMPLAYR
*         STA     DEATH
*         STA     DETHWISH
*         STA     ENTRY
*         STA     FRMCNT
*         STA     PLAYNUM
*         STA     BONZO

          LDX     #10
ZIVARS    STA     CURSONG,X             ;SEE DIGDEF FOR WHICH VARS ARE INIT'ED
          DEX
          BPL     ZIVARS

          LDX     #TOTLSTMP
ZEROSTMY  STA     STMPYPOS,X             ;NO STAMPS ON SCREEN INITIALLY.
          STA     STMPRIOR,X
          DEX
          BPL     ZEROSTMY

          LDA     #1
          STA     NONOISE
          LDX     #3
ZPRIOR1   STA     PUMPRIOR,X
          STA     RCKPRIOR,X
          DEX
          BPL     ZPRIOR1
          STA     RCKPRIOR+4

          LDY     #143                   ;SET UP STMPPALW ARRAY.
          LDX     #40
EXPANDA   LDA     NUMBYTES,X
          STA     TEMP
          LDA     PALWBYTE,X
EXPANDB   STA     STMPPALW,Y
          DEY
          DEC     TEMP
          BPL     EXPANDB
          DEX
          BPL     EXPANDA

          LDX     #47                    ;THIS LOOP LEAVES A=0,Y=FF,X=FF
          LDY     #15                    ;SET UP DIV3TAB IN RAM.
ZEXPAND0  LDA     #2
          STA     TEMP
          TYA
ZEXPAND1  STA     DIV3TAB,X
          DEX
          DEC     TEMP
          BPL     ZEXPAND1
          DEY
          BPL     ZEXPAND0

          TAY                            ;ASSUME A CONTAINS 0
          TAX                            ;ASSUME A CONTAINS 0
RACKTUNL  LDA     PTUNNELS,X
ZEROTUNL  PHA
          STA     TUNNELS,Y
          INY
          INX
          TYA
          AND     #7
          BEQ     TRAKDONE
          PLA
          BNE     RACKTUNL
          DEX
          BNE     ZEROTUNL
TRAKDONE  PLA
          CPY     #200
          BCC     RACKTUNL

          LDX     #0
          LDY     #17
SETDPLS   LDA     DLIBITS,Y
          STA     DPL0LIST,X
          STA     DPL1LIST,X
          STA     DPL2LIST,X
          INX
          LDA     LISTTBH0+1,Y
          STA     DPL0LIST,X
          LDA     LISTTBH1+1,Y
          STA     DPL1LIST,X
          LDA     #H(DUMMYDPL)
          STA     DPL2LIST,X
          INX
          LDA     LISTTABL+1,Y
          STA     DPL0LIST,X
          STA     DPL1LIST,X
          LDA     #L(DUMMYDPL)
          STA     DPL2LIST,X
          INX
          CPX     #69
          BEQ     ZDPLDONE
          DEY
          BPL     SETDPLS
          LDY     #20
          BNE     SETDPLS

ZDPLDONE  LDX     #14                    ;INIT CHARACTER MAP FOR SCORE LINE.
          LDA     #FULLSKY               ;SKY BEHIND NUMBERS AT TOP OF SCREEN.
ISCOREM   STA     SCOREMAP,X
          DEX
          BNE     ISCOREM


          JSR     IDIRTRAM               ;INITIALIZE DIRT RAM.
          JSR     ISCOREL

          JSR     SETRACK1
          TAX                            ;ATTRACT MODE.
          JSR     INITGAME

          JMP     SCRNON                 ;TURN DISPLAY BACK ON.
***       RTS


ICOLORS   LDX     #24                    ;INIT ORIGINAL PALETTE COLORS.
          LDY     #31
IPALS     LDA     IPALETTE,X             ;X INDEXES THROUGH PALETTE COLOR TABLE
          STA     P0C0SHAD,Y
          DEX
          BEQ     ENDIPAL
          DEY
          TYA
          AND     #3
          BNE     IPALS
          DEY
          BPL     IPALS
ENDIPAL   STX     P0C0                   ;BACKGROUND COLOR 0.
          STX     P0C0SHAD
          RTS
******************************************
IDLISTS   JSR     CHARDPL
          LDA     DLSTPTR
          PHA
          EOR     #$40
          STA     DLSTPTR
          JSR     CHARDPL
          PLA
          STA     DLSTPTR
          RTS
******************************************
CHARDPL
          LDX     #NUMZONES
INITBACK  JSR     SETDPLH                ;ADDRESS OF ZONE DISPLAY LIST.
          LDY     #0
          LDA     MAPLOW,X               ;LOW ADDRESS OF CHARACTER MAP.
          STA     (DPLOW),Y
          INY
          LDA     #W1ZONE
          STA     (DPLOW),Y
          STA     L0Z0+1
          INY
          LDA     #H(DIRTMAP)            ;INIT TO CURRENT PLAYER'S DIRT MAP.
          STA     (DPLOW),Y
          INY
          LDA     PALWIDZ,X              ;PALETTE/WIDTH FOR ZONE.
          STA     (DPLOW),Y
          INY
          LDA     #16                    ;HORIZONTAL POSITION.
          STA     (DPLOW),Y
          INY
          INY
          LDA     #0
          STA     (DPLOW),Y              ;ZERO OUT WIDTH OF NEXT HEADER IN ZONE.
          DEX
          BNE     INITBACK
          RTS
******************************************
IDIRTRAM
          LDA     #BLANK1
          LDX     #$F0
FILLBLNK  STA     DIRTMAP,X              ;ZERO OUT END OF DIRTMAP FOR SELECT,
          STA     BACKDIRT,X             ;  TITLE PAGE USE.
          INX
          BNE     FILLBLNK

          LDA     #LSKYHALF
          STA     SCOREMAP               ;HALF SKY.
          STA     DIRTMAP
          STA     BACKDIRT
          LDA     #RSKYHALF
          STA     SCOREMAP+15
          STA     DIRTMAP+15
          STA     BACKDIRT+15
          RTS
******************************************
SCRNOFF
          JSR     WAITVBL
          LDA     #L(DPL2LIST)           ;TURN DISPLAY OFF BY SETTING DPPL,DPPH
          STA     DPPL                   ;  TO POINT TO BLANK DISPLAY LIST.
          LDA     #H(DPL2LIST)
          STA     DPPH
          RTS
SCRNON
          JSR     WAITVBL
          LDX     #0                     ;TURN DISPLAY ON BY SETTING DPPL,DPPH
          BIT     DLSTPTR                ;  TO POINT TO CURRENT DISPLAY LIST.
          BVC     ZSCRNON
          INX
ZSCRNON   LDA     LDPPL,X
          STA     DPPL
          LDA     #H(DPL0LIST)
          STA     DPPH
          RTS

********************************************************************************
***********                                                          ***********
***********       INITGAME:  INITIALIZE DIGDUG GAME.                 ***********
***********                  INPUT:  X = 0 => REAL GAME.             ***********
***********                          X = 1 => ATTRACT GAME.          ***********
***********                                                          ***********
********************************************************************************
INITGAME
          STX     ATTRACT
          TXA
          EOR     #1                     ;IF ATTRACT MODE, DON'T GO THROUGH
          STA     ENTRY                  ;  ENTRY WALK.

          JSR     IDLISTS
          JSR     ICOLORS                ;RETURNS 0 IN X.

          TXA
***       LDA     #0                     ;START WITH PLAYER 0.
          STA     P2INIT
          STA     PLAYNUM
          STA     DEATH
          STA     DETHWISH
          STA     IGNORE
          LDX     #TOTLSTMP
ZISTAMPS  STA     STMPYPOS,X
          DEX
          BPL     ZISTAMPS
          LDA     ATTRACT
          BNE     ZNOPLAY0
          LDA     NUMPLAYR
          BEQ     ZNOPLAY0
          INX
          JSR     PLAYREDY

ZNOPLAY0  JSR     INITRACK               ;INITIALIZE APPROPRIATE RACK: THIS
                                         ;  INVOLVES FILLING IN DIRT, PUTTING
                                         ;  CREATURES IN TUNNELS, AND UPDATING
                                         ;  FLOWERS AT TOP OF SCREEN.


          LDX     ATTRACT                ;ATTRACT MODE?
          BNE     IATTRACT
          LDX     #5                     ;SET UP NUMBER OF MEN LEFT.
          STX     NUMMEN                 ;PLAYER 0'S MEN.
          LDA     NUMPLAYR
          BNE     ISCORE
          TAX
ISCORE    STX     NUMMEN+1               ;PLAYER 1'S MEN.
          JSR     ISCOREL                ;RETURNS 0 IN A.

***       LDA     #0                     ;SET UP SCORE:  IT TAKES MORE TIME TO
          TAY                            ;  CALL UPDSCORE, BUT LESS ROM.
          JSR     UPDSCORE
          LDA     NUMPLAYR
          BEQ     ZISETBZ
          INC     PLAYNUM                ;ALSO SET UP SCORE FOR PLAYER 2.
          LDA     #FULL0
          STA     L0Z0+49
          LDA     #0
          TAY
          JSR     UPDSCORE
          DEC     PLAYNUM
ZISETBZ   JMP     UPDMEN                 ;UPDMEN IS A SUBR

*IGAMEDON  RTS

IATTRACT  INX                            ;2 MEN IN ATTRACT MODE.
          STX     NUMMEN
          LDA     #0
          STA     ASTAGE
          STA     NUMMEN+1               ;NO MEN FOR PLAYER 1.
          RTS



********************************************************************************
***********                                                          ***********
***********       INITRACK:  CALLED WHEN INITIALIZING A GAME, OR     ***********
***********                  WHEN ALL CREATURES HAVE BEEN KILLED     ***********
***********                  OR HAVE ESCAPED, AND A NEW RACK IS      ***********
***********                  NEEDED.                                 ***********
***********                                                          ***********
********************************************************************************
INITRACK
          LDX     #7                     ;SET UP MONSTAT SO ALL POSSIBLE
          LDA     #0                     ;  CREATURES ARE INITIALIZED.
PUTALLC   STA     MONSTAT,X
          STA     FLAMEY-3,X             ;FRUITY,PUMPY,FLAMEY,ROCKYS REDUNDANT
          DEX
          BPL     PUTALLC
                                         ;DO TUNNELS AND CREATURES.
          STA     NOTUNNEL               ;ZERO PAGE
          STA     FALLCNT                ;ZERO PAGE
*         STA     FRUIT                  ;ABSOLUTE
          STA     RACKTIME               ;ABSOLUTE

          JSR     INITDIRT               ;FILL IN DIRT FOR NEW RACK.
          JSR     INITROCK               ;INITIALIZE ROCKS IN DIRT.

          LDA     ENTRY
          BNE     DOEWALK
          TAY
          JSR     DDMIDDLE               ;USES A ONLY
WELLOOP   LDA     #20
          STA     $2617,Y                ;DIG OUT VERTICAL TUNNEL.
          TYA
          CLC
          ADC     #$10
          TAY
          CPY     #$60
          BNE     WELLOOP

*         STX     $2617                  ;DIG OUT VERTICAL TUNNEL.
*         STX     $2627
*         STX     $2637
*         STX     $2647
*         STX     $2657
*         STX     $2667
          LDX     #8
          STX     $2677
          BNE     DOFLOWR
DOEWALK   LDA     #DDSTRTX               ;DIGDUG WILL MAKE ENTRANCE: SET HIM
          STA     DDXPOS                 ;  UP IN TOP RIGHT CORNER OF DIRT.
          LDA     #DDSTRTY
          STA     DDYPOS
          LDA     #LDIGDUG1
          STA     DDINDX

DOFLOWR   LDX     PLAYNUM
          LDA     RACKNUM,X
          LDY     #$E
          LDX     #0
          CMP     #10
          BCC     GOTBIG
*         SEC
GETBIG    INX
          SBC     #10
          CMP     #10
          BCS     GETBIG
GOTBIG    STA     TEMP                   ;TEMP CONTAINS NUMBER OF SMALL FLOWERS.
          TXA                            ;X CONTAINS NUMBER OF BIG FLOWERS.
          BEQ     GETSMALL               ;ANY BIG FLOWERS?
          LDA     #BIGFLOWR              ;STAMP INDEX FOR BIG FLOWER.
PUTBIG    STA     DIRTMAP,Y
          DEY
          BEQ     IRACKDON               ;SKY IS FULL OF FLOWERS ALREADY.
          DEX
          BNE     PUTBIG
GETSMALL  LDX     TEMP                   ;NUMBER OF SMALL FLOWERS.
          BEQ     IFILLSKY
          LDA     #SMLFLOWR              ;STAMP INDEX FOR SMALL FLOWER.
PUTSMALL  STA     DIRTMAP,Y
          DEY
          BEQ     IRACKDON
          DEX
          BNE     PUTSMALL

IFILLSKY
          LDA     #FULLSKY               ;FILL IN REST OF SKY WITH SKY CHAR.
ZFILLSKY  STA     DIRTMAP,Y
          DEY
          BNE     ZFILLSKY

IRACKDON  RTS
