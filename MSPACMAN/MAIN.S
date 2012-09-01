
*         MAIN ROUTINE FOR MS PAC MAN

MAIN      LDA     #$17                   ;LOCK IN MARIA MODE
          STA     INPTCTRL
          SEI
          CLD
          LDX     #STACKPTR
          TXS                            ;SET STACK POINTER
          JSR     SCREENOF               ;TURN GRAPHICS OFF
          LDA     #$00
          STA     OFFSET                 ;FOR FUTURE EXPANSION
          STA     INPTCTRL               ;TO MAKE JOYSTICKS NOT FREEZE
          JSR     STRTINIT               ;ENTRY TO MS PAC MAN

ATTRACT   JSR     DOTITLE                ;START ATTRACT MODE
          JSR     HOLDSCOR               ;SHOW HI SCORE TABLES
          LDA     #$01
          STA     AUTOPLAY

          JSR     GAMEINIT
          JMP     AGAIN

START     LDA     #$00                   ;START GAME PLAY
          STA     AUTOPLAY
          JSR     GAMEINIT
          JSR     READY                  ;PUT PLAYER READY UP
          LDA     #$00                   ;SET UP STARTING TUNE
          JSR     DOTUNE
          LDA     #$01
          JSR     DOTUNE
STLOOP    JSR     SEEBNORM
          LDA     TUNON                  ;WAIT TILL TUNE OVER
          BNE     STLOOP
          JSR     WCLEAR                 ;GET RID OF PLAYER READY

AGAIN     LDA     GAMEOVER               ;SEE IF GAME OVER
          BEQ     AGSKP0
          JMP     ENDGAME
AGSKP0    JSR     SEEBNORM               ;SEE IF SELECT OR START HIT
          LDA     RTLOCAL+1              ;CHECK EVENTS AGAINST TIMERS
          CMP     PACWAIT
          BMI     AGSKP1
          JSR     MOVEPAC
          LDA     RTLOCAL+1
AGSKP1    CMP     FRTWAIT
          BMI     AGSKP2
          JSR     MOVEFRT
          LDA     RTLOCAL+1
AGSKP2    CMP     FLSHWAIT
          BMI     AGSKP3
          JSR     FLASHDOT
          LDA     RTLOCAL+1
AGSKP3    CMP     MONWAIT
          BMI     AGOUT
          JSR     MONSTER
AGOUT
          JMP     AGAIN


*  END OF GAME HANDLER
ENDGAME   LDA     #$00                   ;SET CONTROL TO JOYSTICK 0
          STA     PLAYER
          LDA     HSCHERE                ;IF HSC HERE, DON'T WASTE TIME WITH MSG
          BNE     EGOUT

          JSR     ALLOVER                ;WRITE GAME OVER
          LDA     RTLOCAL                ;WAIT A BIT BEFORE TITLE PAGE
          CLC
          ADC     #$01
          STA     TEMP16
EGJMP0    JSR     SEEBENDG               ;GAME OVER - WAIT FOR SOMETHING
          LDA     TEMP16
          CMP     RTLOCAL
          BPL     EGJMP0
EGOUT     JSR     HNEWSCOR               ;SEE IF ANY SCORES QUALIFY FOR HI SCORE
          JMP     DOATRACT               ;AND GO BACK TO ATTRACT MODE


*  PAUSE BUTTON HAS BEEN HIT, WAIT TILL BUTTON HIT AGAIN
PAUSE     LDA     RTLOCAL                ;STACK CLOCK
          PHA
          LDA     RTLOCAL+1
          PHA
          TXA                            ;STORE X
          PHA

          JSR     STOPTUN                ;TURN SOUNDS OFF

          LDX     RTLOCAL                ;SET UP TIMER FOR GRAPHICS OFF
          DEX
PLOOPA    JSR     SEEBALL                ;SEE IF RESET OR SELECT HIT
          CPX     RTLOCAL
          BNE     PLJMP0
          JSR     SCREENNO               ;TOO LONG A WAIT, TURN GRAPHICS OFF

PLJMP0    JSR     GETJOY                 ;SEE IF USER WANTS GRAPHICS BACK ON
          LDA     BUTSTATE               ;IS BUTTON PUSHED?
          BNE     PLGRAFON
          LDA     NEWDIR                 ;IS JOYSTICK MOVED?
          CMP     #DCENTER
          BEQ     PLJMP1
PLGRAFON  JSR     SCREENON               ;TURN GRAPHICS ON IF NEEDED
          LDX     RTLOCAL                ;RESET TIMER
          DEX

PLJMP1    LDA     DBPAUSE                ;SEE IF WE ARE DEBOUNCING PAUSE
          BEQ     PLNORM
          LDA     SWCHB                  ;SEE IF IT HAS BEEN RELEASED
          AND     #$08
          EOR     #$08
          STA     DBPAUSE                ;FALL THROUGH TO SEEBALL
          JMP     PLOOPA

PLNORM    LDA     SWCHB                  ;SEE IF PAUSE BUTTON HIT
          AND     #$08
          BNE     PLOOPA                 ;IF NOT, TRY AGAIN

          JSR     STARTTUN               ;TURN TUNES ON
          JSR     SCREENON               ;TURN GRAPHICS ON IF NEEDED
          PLA                            ;UNSTACK X
          TAX
          PLA                            ;UNSTACK CLOCK
          STA     RTLOCAL+1
          PLA
          STA     RTLOCAL
          LDA     #$01
          STA     DBPAUSE                ;AND, OF COURSE, DEBOUNCE PAUSE SWITCH
          RTS


*  THIS ROUTINE CHECKS TO SEE IF TIME TO START OUT END GAME
SEEBENDG  JSR     GETJOY                 ;SEE IF BUTTON PUSHED
          LDA     BUTSTATE
          BNE     DOSTART
          JMP     SEEBALL                ;CHECK FOR SELECT AND RESET


*  THIS ROUTINE CHECKS TO SEE IF TIME TO START OUT OF ATTRACT
SEEBAUTO  JSR     GETJOY                 ;SEE IF BUTTON PUSHED
          LDA     BUTSTATE
          BNE     DOSTART
          LDA     NEWDIR                 ;SEE IF JOYSTICK MOVED
          CMP     #DCENTER
          BNE     DOMENU
          JMP     SEEBALL                ;CHECK FOR SELECT AND RESET


*  THIS ROUTINE CHECKS TO SEE IF SELECT OR RESET HIT
SEEBNORM  LDA     AUTOPLAY               ;SEE IF AUTOPLAY
          BNE     SEEBAUTO
          LDA     DBPAUSE                ;SEE IF WE ARE DEBOUNCING PAUSE
          BNE     SBNDBPSE
          LDA     SWCHB                  ;SEE IF PAUSE BUTTON HIT
          AND     #$08
          BNE     SEEBALL                ;IF NOT, FALL THROUGH TO SEEBALL CODE
          LDA     #$01
          STA     DBPAUSE
          JMP     PAUSE                  ;WAIT TILL WE'RE UN-PAUSED

SBNDBPSE  LDA     SWCHB                  ;SEE IF IT HAS BEEN RELEASED
          AND     #$08
          EOR     #$08
          STA     DBPAUSE                ;FALL THROUGH TO SEEBALL


*  THIS LOOKS FOR SELECT AND RESET - USED BY ALL
SEEBALL   LDA     DBSELECT               ;SEE IF WE ARE DEBOUNCING SELECT
          BNE     SBADBSEL
          LDA     SWCHB                  ;SEE IF SELECT SWITCH HIT
          AND     #$02                   ;SEE IF BIT 1 OFF
          BNE     SBRESET
          LDA     #$01                   ;SET DEBOUNCE VAR
          STA     DBSELECT
          JMP     DOMENU                 ;SELECT

SBADBSEL  LDA     SWCHB                  ;SEE IF IT HAS BEEN RELEASED
          AND     #$02
          EOR     #$02
          STA     DBSELECT

SBRESET   LDA     DBRESET                ;SEE IF WE ARE DEBOUNCING RESET
          BNE     SBADBRES
          LDA     SWCHB                  ;SEE IF RESET SWITCH HIT
          AND     #$01                   ;SEE IF BIT 0 OFF
          BNE     SBAOUT
          LDA     #$01                   ;SET DEBOUNCE VAR
          STA     DBRESET
          JMP     DOSTART                ;START

SBADBRES  LDA     SWCHB                  ;SEE IF IT HAS BEEN RELEASED
          AND     #$01
          EOR     #$01
          STA     DBRESET

SBAOUT    RTS


*  THIS ROUTINE CHECKS TO SEE IF TIME TO START OUT OF THE MENU
SEEBMENU  JSR     GETJOY                 ;SEE IF BUTTON PUSHED
          LDA     BUTSTATE
          BEQ     SBRESET
          JMP     DOSTART


*  START A GAME
DOSTART   LDX     #STACKPTR              ;START THE GAME
          TXS
          JMP     START


*  GO TO THE MENU
DOMENU    LDX     #STACKPTR              ;DO THE MENU
          TXS
          JMP     MENU


*  GO TO THE TITLE PAGE
DOATRACT  LDX     #STACKPTR              ;GO TO ATTRACT MODE
          TXS
          JMP     ATTRACT

