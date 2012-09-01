********************************************************************************
***********                                                          ***********
***********       CHKDEATH:  IF DIGDUG HAS DIED, DO DEATH            ***********
***********                  SEQUENCE, RESET TO SAME RACK,           ***********
***********                  SWITCH PLAYERS IF NECESSARY, AND        ***********
***********                  INITIALIZE CREATURES IN TUNNELS.        ***********
***********                  NOTE THAT ONCE DEATH IS DETECTED,       ***********
***********                  CONTROL WILL STAY IN THIS ROUTINE       ***********
***********                  UNTIL DEATH SEQUENCE HAS BEEN           ***********
***********                  COMPLETED AND RACK, ETC. IS RESET.      ***********
***********                                                          ***********
********************************************************************************
CHKDEATH
          LDA     DEATH                  ;HAS DIGDUG DIED?
          BEQ     ZDRTS                  ;LOCATED AT END OF SELECT FILE

*********** DO DEATH SEQUENCE ...

DSEQUNC
          LDA     FRUIT                  ;DOES FRUIT NEED TO APPEAR?
          BEQ     DSEQUNC2
          CMP     #$0F
          BCS     DSEQUNC2
          JSR     DFRUIT                 ;DISPLAY FRUIT
DSEQUNC2
          LDA     NEEDDIR                ;IF DIGDUG IS UNDER A ROCK
          BEQ     DSEQUNC3               ;   ....GIVE IT A SHOVE
          LDX     HITROCK
          LDA     #ONEDGE
          STA     TUMBLE,X
DSEQUNC3

          LDA     #40
          JSR     GENFREEZ
**        TXA                            ;BUTTON PUSHED?
**        BNE     ZDRTS

          LDY     #0
          LDX     #NUMCREAT              ;FIRST STAGE OF DEATH SEQUENCE
CHKGBNF   LDA     MONSTAT,X
          AND     #$86
          CMP     #$02                   ;POPPED (GBNF) CREATURES ARE DEAD
          BNE     VANCREAT
          LDA     BLWSTAT,X              ;POP STAGE?
          CMP     #4
          BNE     DOVAN
          JSR     CAROL                  ;MAKE SURE POINTS GET ADDED IN
DOVAN     JSR     OFFSCR2                ;SETS MONSTAT,X TO $80;POOKAY,X TO 0
          TAY                            ;OFFSCR2 RETURNS 0 IN A
*         LDA     #$80
*         STA     MONSTAT,X
VANCREAT  STY     POOKAY,X               ;DON'T DISPLAY CREATURES
          DEX
          BPL     CHKGBNF

          STY     FLAMEY                 ;STOP DISPLAYING FLAME
          STY     FRUITY                 ;STOP DISPLAYING FRUIT

          LDA     #$08
          JSR     GENFREEZ

          LDY     #SNG14                 ;START DEATH NOISE.
          JSR     NOISE

          LDX     #4
          STX     DTEMP2
          LDY     LASTMOVE
          LDX     DANIMIX,Y
          STX     DETHTEMP
DETHANIM  LDA     ADEATH,X               ;APPROPRIATE ANIMATION FOR THIS STAGE.
          STA     DDINDX
          LDA     #18
          JSR     GENFREEZ
**        TXA
**        BNE     ZDRTS                  ;WAS BUTTON PUSHED IN ATTRACT MODE?
          DEC     DETHTEMP
          LDX     DETHTEMP
          DEC     DTEMP2
          BPL     DETHANIM

*********** SEE IF ANY LIVES LEFT FOR THIS OR ANY OTHER PLAYER...

ENDDANIM
          JSR     TESTRACK
          LDX     #0                     ;SET UP FOR NEXT PLAYER'S LIFE:  IF 2
          STX     DEATH                  ;  PLAYER MODE, WE MAY BE SWITCHING.
*         STX     FRUITY
*         STX     FRUIT
          LDX     PLAYNUM                ;DECREMENT NUMBER OF LIVES LEFT.
          DEC     NUMMEN,X
          BNE     CHKSWTCH
          LDA     NUMPLAYR               ;NO LIVES LEFT: MORE THAN ONE PLAYER?
          BEQ     GOATTRAC               ;  IF NOT, GO INTO ATTRACT MODE.
          LDA     ATTRACT
          BNE     GOATTRAC

CHKSWTCH
          LDA     ATTRACT                ;ATTRACT MODE ONE PLAYER ONLY.
          BNE     GOSETC
          LDA     NUMPLAYR               ;MORE THAN ONE PLAYER?
          BEQ     GOSETC
          LDA     PLAYNUM                ;SWITCH PLAYER NUMBER INDEX.
          EOR     #1
          TAY
          LDA     NUMMEN,Y
          BNE     NEWPLAYR
          LDA     NUMMEN,X
          BEQ     GOATTRAC
GOSETC    JMP     SETCREAT               ;THIS PLAYER HAS MORE LIVES LEFT.
GOATTRAC
          LDX     ATTRACT
          BNE     ZGOTITLE
          JSR     UPDMEN
          LDX     #1
          STX     ATTRACT
*         LDX     #1                     ;GAME OVER MESSAGE.
          STX     IGNORE                 ;IGNORE JOYSTICK DURING GAME OVER.
                                         ;THIS WILL DISABLE ENTRY TO SELECT.
          JSR     PLAYREDY               ;(CLOBBERS X).
          JSR     HSCORENT
ZGOTITLE
          LDA     #1
          STA     NONOISE
          JMP     TITLEPAG               ;NO LIVES LEFT: GO TO TITLE PAGE.


*********** WE'RE SWITCHING PLAYERS ...

                                         ;SWITCH TO OTHER PLAYER: SINCE THIS
                                         ;  WILL TAKE LOTS OF CYCLES TO SWITCH
                                         ;  PLAYER'S DIRTMAPS, PUT UP A BLANK
                                         ;  SCREEN UNTIL WE'RE DONE.
NEWPLAYR  STY     PLAYNUM
          JSR     SCRNOFF

          LDX     #TOTLSTX2
SAVEYPOS  LDA     STMPYPOS,X
          PHA                            ;SAVE CURRENT PLAYER'S REMAINING YPOS
          LDA     BACKYPOS,X             ;  VALUES AND READ IN OTHER PLAYER'S.
          STA     STMPYPOS,X             ;WE'RE ALSO SAVING STMPXPOS HERE TOO!
          PLA                            ;IF FOLLOWS STMPYPOS ARRAY.
          STA     BACKYPOS,X
          DEX
          BPL     SAVEYPOS

          LDX     #7
SAVETMBL  LDA     TUMBLE,X               ;SAVE CURRENT PLAYER'S TUMBLE ARRAY.
          PHA                            ;ALSO SAVES FALLCNT,BRCREAT,
          LDA     BACKTMBL,X             ;  AND BRTUNNL.
          STA     TUMBLE,X
          PLA
          STA     BACKTMBL,X
          LDA     MONSTAT,X
          PHA
          LDA     BACKMONS,X
          STA     MONSTAT,X
          PLA
          STA     BACKMONS,X
          LDA     #STRTROCK
          STA     ROCKSIX,X
          DEX
          BPL     SAVETMBL

          LDX     #$F0
SAVEDIRT  LDA     DIRTMAP,X              ;SAVE CURRENT PLAYER'S DIRTMAP.
          PHA
          LDA     BACKDIRT,X
          STA     DIRTMAP,X
          PLA
          STA     BACKDIRT,X
          DEX
          CPX     #$FF
          BNE     SAVEDIRT

          LDX     P2INIT                 ;HAVE WE INITIALIZE P2 YET?
          BNE     SETCREAT
          INX
          STX     P2INIT
          STX     ENTRY
          DEX
          JSR     PLAYREDY
          JSR     INITRACK               ;THEN THIS IS THE FIRST TIME HE'S BEEN
          JMP     RESETSCR               ;  UP SO INITIALIZE THE WORLD FOR HIM.

*********** SET UP CREATURES FOR NEW LIFE ...

SETCREAT
          LDX     ATTRACT
          BNE     ZNOPLAYM
          LDX     NUMPLAYR
          BEQ     ZNOPLAYM
          DEX
          JSR     PLAYREDY               ;PUT UP PLAYER N MESSAGE.
ZNOPLAYM  LDA     #1
          STA     NOTUNNEL               ;JUST INIT CREATURES, NOT TUNNELS.
          JSR     INITDIRT
***       JSR     INCREATS
          JSR     DDMIDDLE
***       JSR     SETDFAST               ;INCLUDED IN INCREATS
RESETSCR
          LDA     #0
          STA     LASTMOVE
          LDA     ATTRACT
          BNE     SETNSCR
          JSR     UPDMEN                 ;UPDATE NUMBER OF MEN LEFT FOR PLAYER.
SETNSCR
          LDA     #40

GENFREEZ  PHA
          JSR     GENDPL
          PLA
          JMP     FREEZFRM
UPDMEN
          LDX     PLAYNUM
          CLC
          LDY     #BLANK1
          LDA     NUMMEN,X
          BEQ     ZRESET0
          ASL     A
          ADC     #FULL0-2
          TAY
ZRESET0   STY     L0Z0+53
          RTS
********************************************************************************
***********                                                          ***********
***********       FREEZFRM:  FREEZE PICTURE ON SCREEN.  A CONTAINS   ***********
***********                  NUMBER OF FRAMES FOR DURATION OF        ***********
***********                  FREEZE.  RETURNS 1 IN X IF WE WERE      ***********
***********                  IN ATTRACT MODE AND THE BUTTON WAS      ***********
***********                  PUSHED DURING THE FREEZE, 0 OTHERWISE.  ***********
***********                                                          ***********
********************************************************************************
FREEZFRM
          CLC
          ADC     FRMCNT
DFREEZE
          PHA
          JSR     CHKSTATE               ;IF SO, CHECK BUTTONS.
          TYA
**        BNE     NOTPAUSD
**        TAX
          BEQ     ZPLA                   ;PAUSE BUTTON PRESSED.
NOTPAUSD  PLA
          CMP     FRMCNT
          BNE     DFREEZE
**        LDX     #0                     ;BUTTON NOT PUSHED.
          RTS
ZPLA      PLA
          RTS



********************************************************************************
***********                                                          ***********
***********       HSCORENT:  SET UP FOR AND CALL HSCENTER TO         ***********
***********                  ENTER HIGH SCORE(S) FOR PLAYER(S)       ***********
***********                  WHOSE GAME JUST ENDED.                  ***********
***********                                                          ***********
********************************************************************************
HSCORENT
          LDA     BONZO
          JSR     HSCINIT                ;INIT RAM BLOCK FOR HSC ARGUMENTS.
          TXA
          BNE     HSCRTS
          LDX     NUMPLAYR
          BEQ     NO10SEC
          DEX                            ;IF TWO PLAYER, DON'T DELAY 10 SECONDS
          STX     HSCTIME                ; AFTER ENTERING INITIALS FOR PLAYER 0.
NO10SEC
***       LDX     #0
          JSR     ENTERHSC

          LDA     NUMPLAYR
          BEQ     HSCDISPL
          LDA     #10
          STA     HSCTIME
          LDA     HSCDIFFL               ;CHANGE PLAYER NUMBER.
          ORA     #1
          STA     HSCDIFFL
          LDX     #1
          JSR     ENTERHSC
HSCDISPL                                 ;THIS ALSO ACTS AS AN ENTRY POINT FOR
          JSR     SCRNOFF                ;  RESTORING RAM AFTER HSCATRCT CALL.
          JSR     IDIRTRAM               ;  PALETTES WILL BE RESTORED WITHIN ONE
          LDA     #$50                   ;  FRAME OF REGULAR DIGDUG DISPLAY.
          STA     CTRL                   ;RESTORE REGISTERS CHANGED BY HSC.
          LDA     #CSET1
          STA     CHARBASE
          LDA     #L(DLISETUP)
          STA     DLIVECT
HSCRTS    RTS

*****************************************
ENTERHSC  LDA     SCOREL,X               ;WRITE PLAYER X'S SCORE INTO SCORE
          STA     HSCOREL                ;  BUFFER. (TOP BYTE OF SCORE BUFFER
          LDA     SCOREM,X               ;  IS ALWAYS ZERO IN DIGDUG'S CASE).
          STA     HSCOREM                ;  FIRST BYTE IS MOST SIGNIFICANT
          LDA     SCOREH,X               ;  BYTE OF SCORE.
          STA     HSCOREH
          LDX     #L(HSCRAM)
          LDY     #H(HSCRAM)
          JMP     HSCENTER               ;*** = RTS!

********************************************************************************
***********                                                          ***********
***********       HSCINIT:  INITIALIZE ARGUMENT BLOCK FOR HSC.       ***********
***********                 RETURN 1 IF HSC DOESN'T EXIST.           ***********
***********                                                          ***********
********************************************************************************
HSCINIT
          PHA
          LDX     #1
          LDA     $3900                  ;SEE IF HSC IS THERE.
          CMP     #$C6
          BNE     NOHSC
          LDA     $3904
          CMP     #$FE
          BNE     NOHSC

**        LDY     #2                     ;HIGH SCORE MUSIC.
**        JSR     NOISE
          JSR     SCRNOFF
***       LDA     #$FF                   ;TURN OFF DMA.
***       STA     CTRL
          LDA     #L(DLITOP)
          STA     DLIVECT

          LDX     #14
INITHSC   LDA     HSCARGS,X              ;INITIALIZE THE HSC ARGUMENT BLOCK.
          STA     HSCRAM,X               ;  THIS DEFAULTS TO BONZO LEVEL.
          DEX
          BPL     INITHSC

          LDA     #$40                   ;SET UP DIGDUG LOGO IN DISPLAY LIST 0.
          STA     DLSTPTR
          JSR     SETTITLE
          LDX     #29                    ;SET UP COLORS FOR LOGO.
          JSR     TITLCOLR
          STA     P0C0SHAD+23

          LDX     #5
SETFRUIT  LDA     TEDYPINE,X             ;ADD STAMP FOR LEVEL INDICATOR INSTEAD
          STA     L0Z9+5,X               ;  OF USING LETTERS PROVIDED IN HSC.
          DEX                            ;  (DEFAULT LEVEL IS BONZO).
          BPL     SETFRUIT
**        INX
          LDX     #$FC
          STX     L0Z13+30               ;NO DIGDUG IN SELECT LOGO.
          STX     L0Z12+30
          JSR     BONZCOLR               ;(TITLCOLR JSR SET UP FOR PINEAPPLE).
          PLA                            ;SET BONZO(1) OR PINEAPPLE(0) MODE?
          PHA
          BNE     ANYLEVEL
          JSR     PINECOLR               ;CHANGE LEVEL INDICATOR TO PINEAPPLE.
          LDA     #$04
          STA     HSCDIFFL
          LDA     #PINEAPPL
          STA     L0Z9+5
ANYLEVEL                                 ;RETURN 0 AS HSC EXISTS.
          LDA     VEGCOLR+1
          STA     P0C0SHAD+21
          LDA     VEGCOLR
          STA     P0C0SHAD+22
          JSR     DOCOLORS               ;RETURNS 0 IN X.
NOHSC     PLA
          RTS


********************************************************************************
***********
***********       PLAYREDY: PUT UP PLAYER N MESSAGE WHEN SWITCHING PLAYERS
***********                 (X = 0 WHEN CALLED), OR GAME OVER (X = 1).
***********
********************************************************************************
PLAYREDY
          TXA
          PHA
          LDA     #1
          STA     NONOISE

          JSR     BACKMAP                ;RETURNS 0 IN X.
***       LDA     #0
          STX     L0Z0+1

          LDX     #10
          JSR     SETDPLH
          LDY     #3
          LDA     #$D0
          STA     (DPLOW),Y
          PLA
          PHA
          TAX
          LDY     MESGDPLY,X
          LDA     MESGOFST,X
          TAX
          JSR     PUTMPLAT

          PLA
          BNE     NOPNUM
          LDY     #29
          LDX     PLAYNUM
          BEQ     NOPNUM
          LDA     #FULL0+4
          STA     (DPLOW),Y

NOPNUM    JSR     DLFLIP
          JSR     SETPAL3

          JSR     SCRNON
          LDA     #100
          JSR     FREEZFRM

          JSR     RESPAL3
          INY
          STY     NONOISE

          JSR     SCRNOFF
          JSR     IDLISTS                ;RE-INITIALIZE DISPLAY LISTS.
          LDA     #W1ZONE
          STA     L0Z0+1

          RTS

********************************************************************************

***********       CHKSTATE:  CHECK FOR RESET, SELECT, OR, IF WE'RE IN ATTRACT
***********                MODE, THE BUTTON ON THE JOYSTICK.  IF ANY OF THESE
***********                BUTTONS ARE PRESSED, THE STATE OF THE GAME WILL
***********                BE CHANGED.  NOTE THAT THIS ROUTINE DOES NOT READ
***********                THE JOYSTICK NOR THE BUTTON ON THE JOYSTICK IF
***********                WE'RE PLAYING A REAL GAME.

********************************************************************************
CHKSTATE
*         LDX     #0
*         LDA     INPT5                  ; SECOND PLAYER'S BUTTON IN USE?
*         BMI     OTHERJOY
*         INX
*OTHERJOY  LDA     SWCHA                  ; SECOND PLAYER'S JOYSTICK IN USE?
*         AND     #$0F
*         CMP     #$0F
*         BEQ     SETALIEN
*         INX
*SETALIEN  TXA
*         ORA     ALIEN
*         STA     ALIEN

          LDY     #1                     ;FLAG FOR PAUSE BUTTON HIT.
          LDX     ATTRACT                ;ATTRACT MODE?
          BNE     CHKBUTN
          LDA     #8
          BIT     SWCHB
          BNE     CHKRSET
          INX
          STX     NONOISE

RPAUSE    BIT     SWCHB                  ;PAUSE BUTTON PRESSED.
          BEQ     RPAUSE
          STX     SELCTIM
          DEY                            ;FLAG FOR PAUSE BUTTON HIT.
          JSR     UNBOUNCE
DOPAUSE
          JSR     RSELRES
          BCS     PSELRES
          LDX     SELCTIM
          BNE     CONTPAUS
          LDX     #$70                   ;TURN OFF DMA.
          STX     CTRL
OFFDMA    LDX     INPT4                  ;IF BUTTON OR JOYSTICKED TOUCHED,
          BPL     ONDMA                  ;  TURN DMA BACK ON, BUT STILL STAY
          LDX     SWCHA                  ;  IN PAUSE MODE.
          CPX     #$FF
          BNE     ONDMA
          BIT     SWCHB
          BEQ     ZRPAUSE
          JSR     RSELRES
          BCS     PSELRES
          BCC     OFFDMA
ONDMA     LDX     #$50                   ;TURN DMA BACK ON.
          STX     CTRL
***       LDX     #1                     ;RESET COUNTER.
          STA     SELCTIM                ;A = 8 => SAVE 2 BYTES, LOSE 32 SECS.
CONTPAUS  BIT     SWCHB
          BNE     DOPAUSE
***       JSR     UNBOUNCE               ;WE DON'T REALLY NEED THIS. (MAY10)
ZRPAUSE   BIT     SWCHB
          BEQ     ZRPAUSE
          LDX     #$50                   ;TURN DMA ON.
          STX     CTRL
          JSR     UNBOUNCE
          LDX     #0
          STX     NONOISE                ;X MUST REMAIN 0 FOR LATER!
          BEQ     CHKRSET
PSELRES   BNE     GOSELCT
          BEQ     PRESET

CHKBUTN   LDA     IGNORE
          BNE     CHKRSET
          DEX
          LDA     INPT4                  ;IF BUTTON PRESSED, BEGIN NEW GAME ON
          BPL     NEWAGAME               ;  CURRENT RACK.
          INX

CHKRSET   LDA     SWCHB                  ;RESET PRESSED?
          LSR     A
          BCS     CHKSEL
PRESET    JSR     SETRACK1               ;START ON RACK 1 (RETURNS 1 IN A).
          STA     NONOISE
DEBRSET   LSR     SWCHB                  ;STAY HERE UNTIL RESET RELEASED.
          BCC     DEBRSET
          LDX     #0                     ;REAL GAME.
          BCS     NEWAGAME

CHKSEL    LSR     A                      ;SELECT PRESSED?
          BCC     GOSELCT                ;IF SO, STAY IN SELECT MODE UNTIL RESET
                                         ;  OR BUTTON PRESSED.
          LDA     ATTRACT                ;TWO WAYS TO ENTER SELECT: IF ATTRACT
          BEQ     RADD                   ;  AND JOYSTICK PRESSED, ENTER SELECT.
          LDA     IGNORE
          BNE     RADD
          LDA     SWCHA
          AND     #$F0
          CMP     #$F0
          BEQ     RADD
GOSELCT   JSR     SELECT

NEWAGAME  STX     ATTRACT
          JSR     SCRNOFF                ;BLANK SCREEN DURING INITIALIZATION.
          LDX     ATTRACT                ;INITIALIZE GAME.
          JSR     INITGAME
          JSR     NEWDLST
          LDX     #$FF
          TXS
          JMP     PLAYGAME

UNBOUNCE  LDX     FRMCNT                 ;DEBOUNCE PAUSE SWITCH.
          INX
          INX
BOUNCER   CPX     FRMCNT
          BNE     BOUNCER
          RTS

CHKRACK
          JSR     TESTRACK
          BNE     RADD
          STX     LASTMOVE
          JSR     DDMIDDLE
NEWDLST
          LDA     ATTRACT
          STA     NONOISE
          LDA     #40
          JMP     GENFREEZ


TESTRACK
          LDA     DETHWISH
          ORA     SQUASH
*         ORA     DEATH                  ;UNNECESSARY SO LONG AS CALL TO
          BNE     NOTEND                 ; CHKDEATH PRECEDES CALL TO TESTRACK
          LDX     #NUMCREAT
NXTCREAT  LDA     MONSTAT,X
          BPL     NOTEND
          DEX
          BPL     NXTCREAT
          LDY     #SNG13                 ;RACKEND MUSIC
          JSR     NOISE
          LDA     #154                   ;ALLOW TIME FOR MUSIC TO FINISH.
          JSR     FREEZFRM
          LDX     PLAYNUM
          INC     RACKNUM,X
          JSR     SCRNOFF
          JSR     INITRACK
          LDX     #0
          RTS
NOTEND    LDX     #1
RADD      RTS

********************************************************************************
RSELRES
          LDX     #0
          LDA     SWCHB
          LSR     A
          BCS     RSELECT
          INX                            ; RESET PRESSED.
          BNE     DMAON                  ; JMP.
RSELECT   LSR     A
          BCS     BREAD
          LDX     #2                     ; SELECT PRESSED.
DMAON     LDA     #$50                   ; TURN DMA ON BECAUSE IT MAY HAVE BEEN
          STA     CTRL                   ;   TURNED OFF BY TIMER.
BREAD     LDA     #8
          CPX     #1
          RTS
********************************************************************************
***********                                                          ***********
***********       ADDSCORE:  ADDS NEW POINTS TO EXISTING SCORE       ***********
***********                  FOR APPROPRIATE PLAYER, AND UPDATES     ***********
***********                  DIRTMAP CHARACTERS FOR NEW TOTAL.       ***********
***********          INPUT:  Y - MID BYTE.                           ***********
***********                  A - LOW BYTE.                           ***********
***********           USES:  X,Y,A,SCOREPTR,SCOREPTR+1.              ***********
***********                                                          ***********
********************************************************************************

ADDSCORE
          LDX     ATTRACT                ;DON'T CHANGE SCORE IF ATTRACT MODE.
          BNE     RADD
          LDX     ENTRY                  ;DON'T CHANGE SCORE IF ENTRY MODE.
          BNE     RADD                   ;RADD PRECEDES ADDSCORE!

UPDSCORE  LDX     PLAYNUM
          CLC
          SED
          ADC     SCOREL,X               ;LOW BYTE OF SCORE.
          STA     SCOREL,X
          TYA
          ADC     SCOREM,X               ;MID BYTE OF SCORE.
          STA     SCOREM,X
          BCC     ADDSDONE
          LDA     #0
          ADC     SCOREH,X               ;HIGH BYTE OF SCORE.
          STA     SCOREH,X

          CMP     #2                     ;DID WE JUST PASS 20,000?
          BEQ     NEWMAN
          AND     #$F                    ;MULTIPLE OF 100,000?
          BEQ     NEWMAN
          CMP     #5                     ;MULTIPLE OF 50,000?
          BNE     ADDSDONE

NEWMAN    CLD
          LDA     NUMMEN,X
          CMP     #10                    ;MAXIMUM OF 9 EXTRA LIVES AT ONCE.
          BEQ     ADDSDONE
          INC     NUMMEN,X
          JSR     UPDMEN                 ;UPDATE LIVES INDICATOR (CHKDEATH).
          LDY     #SNG11
          JSR     NOISE                  ;NEW LIFE NOISE.
          LDX     PLAYNUM

ADDSDONE  CLD
          LDY     #5                     ;PLAYER 0 SCORE IS AT LEFT EDGE.
          TXA
          BEQ     P0SCORE
          LDY     #29                    ;PLAYER 1 SCORE IS AT RIGHT EDGE.

P0SCORE   SEC                            ;IF (CARRY) THEN WE HAVEN'T SEEN A
          LDA     BONZO                  ;  NUMBER YET IN SCORE (USED FOR
          BEQ     REGGAME                ;  CHANGING LEADING ZEROS TO BLANKS).
          LDA     #$3E                   ;USE PALETTE 3 FOR TEDDY HEAD.
          STA     L0Z0+1,Y
          LDA     #TEDDY                 ;BONZO MODE HAS A LEADING TEDDY HEAD.
          BNE     NEXTT1
REGGAME   LDA     SCOREH,X               ;HIGH BYTE OF SCORE.
          JSR     ANDF0
NEXTT1    STA     L0Z0,Y
          LDA     SCOREH,X
          JSR     ANDF
NEXTT2    STA     L0Z0+4,Y
          LDA     SCOREM,X
          JSR     ANDF0
NEXTT3    STA     L0Z0+8,Y
          LDA     SCOREM,X
          JSR     ANDF
NEXTT4    STA     L0Z0+12,Y
          LDA     SCOREL,X
          JSR     ANDF0
NEXTT5    STA     L0Z0+16,Y

SCOREDON  RTS

*******************
* MOVED TO ARRAYS:
*ANDF0     AND     #$F0
*         BNE     NOTZERO1
*         BCC     NOTZERO1
*         LDA     #BLANK1                ;BLANK STAMP.
*         BEQ     ANDF0RTS
*NOTZERO1  LSR     A                      ;GET INDEX INTO STAMP TABLE FOR THIS
*         LSR     A                      ;  DIGIT OF SCORE.
*         LSR     A
*         CLC
*         ADC     #FULL0
*ANDF0RTS  RTS
*******************
ANDF      AND     #$F
          BCC     NOTZERO2               ;ALREADY HAD A NON-ZERO NUMBER?
          BNE     NOTZERO2               ;IS THIS DIGIT NON-ZERO?
          LDA     #BLANK1                ;NO, SO KEEP DISPLAYING BLANK.
          BEQ     ANDFRTS
NOTZERO2
          ASL     A
          CLC
          ADC     #FULL0
ANDFRTS   RTS
