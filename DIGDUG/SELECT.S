********************************************************************************
***********
***********       SELECT:  DRIVER FOR SELECT MODE.  WHEN SELECT MODE ENTERED,
***********                CONTROL STAYS IN THIS ROUTINE UNTIL RESET OR THE
***********                BUTTON ON THE JOYSTICK IS PRESSED.
***********                MOVING THE JOYSTICK UP SETS NUMPLAYR TO 2, DOWN TO 1;
***********                LEFT DECREASES THE STARTING LEVEL, RIGHT INCREASES IT
***********                (NO WRAP AROUND).
***********
********************************************************************************
SELECT
          JSR     SETRACK1               ;START OFF WITH LOWEST RACK (RETURNS 1
          STA     NONOISE                ;  IN A).
          LDA     #$40
          STA     DLSTPTR
          JSR     SCRNOFF

          JSR     SETTITLE
          LDX     #6
          JSR     SETDPLH
          LDY     #38                    ;PLAYERS.
          LDX     #89
          JSR     PUTMPLAT
          LDX     #9
          JSR     SETDPLH
          LDY     #30
          LDX     #55                    ;LEVEL.
          JSR     PUTMPLAT
          LDX     #0
          STX     L0Z0+1
          STX     FAKEJOY

          LDX     #17
          JSR     TITLCOLR
          JSR     SETOPT

ZINITPLR  JSR     SETPAL3
          JSR     DLFLIP                 ;FLIP TO DISPLAY LIST JUST CONSTRUCTED.
ZDEBSEL   LDA     SWCHA
          ORA     #$0F                   ;DEBOUNCE ENTRY INTO SELECT BY WAITING
          CMP     #$FF                   ;  FOR JOYSTICK TO CENTER.
          BNE     ZDEBSEL
ZDEBSEL2  LDA     SWCHB                  ;ALSO WAIT FOR SELECT BUTTON RELEASE.
          LSR     A
          LSR     A
          BCC     ZDEBSEL2

          LDA     SELCTIM
***       CLC
***       ADC     #75
          ADC     #74                    ;(CARRY ALREADY SET).
          STA     TEMP
          LDA     BONZO                  ;SAVE GAME OPTION.
          STA     TEMP+1

SLOOP
          INC     P0C0SHAD+27
          LDA     INPT4                  ;BUTTON ON JOYSTICK PRESSED?
          BPL     LEAVSLCT
          LDA     SWCHB                  ;RESET PRESSED?
          LSR     A
          BCS     DOSLCT
WAITRSET  LSR     SWCHB                  ;WAIT TILL RESET BUTTON UP.
          BCC     WAITRSET
          JSR     SETRACK1               ;START ON LOWEST RACK.

LEAVSLCT  LDX     #0
          STX     ATTRACT
          LDA     BONZO                  ;HAS GAME LEVEL CHANGED?
          CMP     TEMP+1
          BNE     ZRESCORE
          BEQ     ZGOATTR

DOSLCT
          LSR     A
          BCS     DOJOY                  ;SELECT PRESSED: ROTATE OPTIONS.
          DEC     FAKEJOY
          LDA     FAKEJOY
          AND     #3
          TAX
          LDA     FJOY,X
          BNE     ZDOJOY

DOJOY     LDA     SWCHA                  ;READ JOYSTICK: UP/DOWN WILL TOGGLE
ZDOJOY    LDX     #1
          ASL     A                      ;  NUMBER OF PLAYERS, RIGHT/LEFT WILL
          BCC     HGHLEVEL               ;  INCREASE/DECREASE STARTING LEVEL.
          ASL     A
          BCC     LOWLEVEL
          ASL     A
          BCC     ONEPGAME
*         ASL     A
*         BCC     TWOPGAME
          BPL     TWOPGAME
          LDX     FRMCNT
          INX
          TXA
          JMP     WAITJOY
ONEPGAME  DEX                            ;X CONTAINS 0 NOW.
TWOPGAME  STX     NUMPLAYR               ;TWO PLAYER GAME.
          JMP     GOSETOPT
HGHLEVEL  DEX                            ;PINEAPPLE MODE: BONZO = 0.
LOWLEVEL  STX     BONZO
GOSETOPT  JSR     SETOPT

DEBJOY    LDA     FRMCNT                 ;WAIT 20 FRAMES TO DEBOUNCE JOYSTICK.
***       CLC                            ;(CARRY ALREADY CLEAR).
          ADC     #20
WAITJOY
          LDX     TEMP
          CPX     SELCTIM                ;APPROXIMATELY 5 MINUTES.
          BNE     TSTWAIT
          LDX     #1
          STX     ATTRACT
          LDA     BONZO
          CMP     TEMP+1
          BEQ     ZGOATTR
ZRESCORE
*ZRESCORE  LDY     #5                    ;THIS NOW DONE IN ISCOREL.
*ZRESCOR   LDA     #0
*         STA     SCOREL,Y
*         DEY
*         BPL     ZRESCOR
          STX     ATTRACT
          JSR     ISCOREL                ;RETURNS 0 IN A.
          TAX
*         LDX     #0                     ;UPDATE PLAYER 0'S SCORE.
          JSR     ADDSDONE
          LDX     NUMPLAYR               ;AND PLAYER 1'S.
          BEQ     ZGOATTR
          JSR     ADDSDONE
ZGOATTR   LDX     ATTRACT
          BNE     ZTITLEP                ;GO TO ATTRACT MODE.
***       JSR     SCRNOFF
***       JSR     DLFLIP
***       LDX     ATTRACT
          RTS                            ;************** RTS ****************

TSTWAIT   CMP     FRMCNT
          BNE     WAITJOY
          JMP     SLOOP

; THIS IS KIND OF SLEAZY, BUT NO MATTER WHERE WE ARE IN THE CODE, SELECT COULD
;    BE CALLED.  IF IT TIMES OUT, WE NEED TO GO BACK TO THE TOP LEVEL OF MAIN
;    TO START ATTRACT MODE.  RATHER THAN PUTTING HOOKS IN EVERY PLACE THAT
;    SELECT (=> ALSO CHKSTATE, FREEZFRM) IS CALLED TO CATCH THE TIMEOUT, WE
;    CAN JUST RELY ON TITLEPAG TO SET UP THE SAMPLE ATTRACT MODE AND JUMP
;    TO PLAYGAME IN MAIN.

ZTITLEP   LDX     #$FF
          TXS
          JSR     ICOLORS
          JMP     PLAYTITL


********************************************************************************
SETOPT    LDA     NUMPLAYR
          ASL     A                      ;TOP BIT OF NUMPLAYR ALWAYS 0!
***       CLC
          ADC     #FULL0+2
          STA     L0Z6+33
          LDA     BONZO
          BNE     ZBONZ
          JSR     PINECOLR
          LDA     #PINEAPPL
          BNE     ZNOBONZ
ZBONZ     JSR     BONZCOLR
          LDA     #TEDDY
ZNOBONZ   STA     L0Z9+25
          RTS

********************************************************************************
***********
***********       DOCOLORS:  RESTORE PALETTES - CALLED EACH FRAME.
***********
********************************************************************************
DOCOLORS  LDX     #31
ZDOCOLR   LDA     P0C0SHAD,X
          STA     P0C0,X
          DEX
          TXA
          AND     #3
          BNE     ZDOCOLR
          DEX
          BPL     ZDOCOLR
          INX
          STX     P0C0
          RTS



SETDPLH   LDA     LISTTBH0,X
          BIT     DLSTPTR                ;GET CORRECT DISPLAY LIST.
          BVS     SLCTLST0
          LDA     LISTTBH1,X
SLCTLST0  STA     DPHIGH
          LDA     LISTTABL,X
          STA     DPLOW
          RTS


BONZCOLR  LDA     VEGCOL1+18
          STA     VEGCOLR+1
          LDA     VEGCOL3+18
          STA     P0C0SHAD+23
          LDA     VEGCOL2+18
          STA     VEGCOLR
          STA     P0C0SHAD+22
ZDRTS     RTS                            ;BRANCHED TO FROM CHKDEATH FILE
