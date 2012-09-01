
*  GETJOY.S
*  READ JOYSTICK DATA
*
*  GAME PLAY JOYSTICK ROUTINE
GETJOY    TXA                            ;STORE X
          PHA
          LDX     PLAYER                 ;USE APPROPRIATE PORT

GJDOIT    JSR     GETBUT                 ;FIND BUTTON STATE
          STA     BUTSTATE               ;STORE IT
          JSR     GETSTICK
          STA     NEWDIR

          PLA                            ;GET X BACK
          TAX
          RTS


*  GET THE BUTTON STATE
*  INPUT: PORT IN X
*  OUTPUT: STATE IN A (0 IF NOT DEPRESSED)
GETBUT    LDA     INPT4,X                ;GET BUTTON BIT
          AND     #$80                   ;ISOLATE IT
          EOR     #$80                   ;INVERT IT
          RTS


*  GET THE STICK STATE
*  INPUT: JOYSTICK PORT IN X
*  OUTPUT: DIRECTION IN A
*  SMASHES: X
GETSTICK  LDA     SWCHA                  ;GET JOYSTICK BITS
          CPX     #$00
          BNE     GSJMP0
          LSR     A                      ;GET PLAYER 0 JOYSTICK IN LOW BITS
          LSR     A
          LSR     A
          LSR     A
GSJMP0    AND     #$0F                   ;GET RID OF ANY EXTRA BITS
          TAX
          LDA     JOYTAB,X               ;LOOK IT UP IN TABLE
          RTS


* TABLE OF JOYSTICK DIRECTIONS VS BIT READINGS
JOYTAB    DB      DCENTER,DCENTER,DCENTER,DCENTER
          DB      DCENTER,DDWRIGHT,DUPRIGHT,DRIGHT
          DB      DCENTER,DDWLEFT,DUPLEFT,DLEFT
          DB      DCENTER,DDOWN,DUP,DCENTER
