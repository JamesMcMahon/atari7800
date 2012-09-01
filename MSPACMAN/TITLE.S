
*  TITLE.S        ROUTINES TO CONTROL THE TITLE PAGE

*  THIS IS THE ENTRY ROUTINE.  IT DOES ALL THE WORK.
DOTITLE   JSR     TITLESET               ;DO BASIC SETUP
          JSR     INITSTMP               ;INITIALIZE THE STAMPS

          LDX     #$00
DTLOOP    JSR     WRTNAME                ;WRITE THE MONSTER'S NAME
          JSR     TMOVEMON               ;MOVE THE MONSTER
          INX                            ;GET THE NEXT ONE
          CPX     #$04
          BMI     DTLOOP

          JSR     WRTPNAME               ;WRITE MS PAC-MAN'S NAME
          JMP     TMOVEPAC               ;MOVE HER


*  THIS ROUTINE DOES BASIC SET UP FOR TITLE PAGE AND MENU
TITLESET  JSR     ZERORAM                ;GET RID OF THE MAZE (IF ANY)
          JSR     CLEARTUN
          JSR     LOADDLST               ;RELOAD DISPLAY LISTS
          JSR     SCREENON               ;DISPLAY BACK ON
          JSR     INITSCRN               ;INITIALIZE THE SCREEN
          LDA     #$00                   ;LOOK AT PLAYER 1 JOYSTICK
          STA     PLAYER
          RTS


*  INITIALIZE THE STAMPS - SET COLORS AND PUT OFF SCREEN
INITSTMP  LDX     #$03                   ;SET THE MONSTERS TO THE SAME PLACE
ISLOOP    LDA     #RGHTWRAP
          STA     M0HPOS,X
          STA     PHPOS
          LDA     #$8C
          STA     M0VPOS,X
          STA     PVPOS
          LDA     #$00                   ;AND MAKE SURE THEY AREN'T BLUE OR EYES
          STA     M0BLUE,X
          STA     M0DISP,X               ;INITIALIZE DISP STATE
          LDA     #DLEFT
          STA     M0DIR,X                ;FACING LEFT
          STA     PDIR
          JSR     DISPMON                ;PUT IT ON SCREEN UNDER BAR
          JSR     MONSTAMP               ;SET MONSTER COLORS
          DEX
          BPL     ISLOOP

          LDA     #$01                   ;INITIALIZE DISP STATE
          STA     PDISP
          JSR     PACVTOZO               ;ADJUST ZONE AND COLUMN
          JSR     WRITEPAC               ;PUT IT ON SCREEN UNDER BAR
          JSR     PACSTAMP               ;SET MS PAC COLORS

          RTS


*  INITIALIZE THE SCREEN FOR THE TITLE PAGE
INITSCRN  LDA     #WHITE                 ;FIRST - SET COLORS
          STA     P0C3
          LDA     #YELLOW
          STA     P0C2
          LDA     #PINK
          STA     P0C1
          STA     P7C2                   ;SET COLOR FOR SECOND PLAYER

          JSR     TITLEIND               ;SET UP INDICATORS FOR TITLE PAGE

          LDY     #$08                   ;NOW, WRITE THE MS PAC-MAN LOGO
          JSR     WRTMESG
          LDY     #$09
          JSR     WRTMESG
          LDY     #$0A
          JSR     WRTMESG
          LDY     #$0B
          JSR     WRTMESG
          LDY     #$0C
          JSR     WRTMESG
          LDY     #$05                   ;WRITE THE 'COPYRIGHT ATARI 1983'
          JSR     WRTMESG

          LDA     #$09                   ;SET UP STATE FOR PUTTING MARQUIS DOTS
          STA     TEMP0
          LDA     #$06
          STA     TEMP1
          LDX     #MARQCHAR

ISCLOOP0  JSR     PLOPCHAR               ;MOVE DOWN
          JSR     NEXTMARQ
          INC     TEMP0
          LDA     TEMP0
          CMP     #$12
          BNE     ISCLOOP0

ISCLOOP1  JSR     PLOPCHAR               ;MOVE RIGHT
          JSR     NEXTMARQ
          INC     TEMP1
          LDA     TEMP1
          CMP     #$15
          BNE     ISCLOOP1

ISCLOOP2  JSR     PLOPCHAR               ;MOVE UP
          JSR     NEXTMARQ
          DEC     TEMP0
          LDA     TEMP0
          CMP     #$09
          BNE     ISCLOOP2

ISCLOOP3  JSR     PLOPCHAR               ;MOVE LEFT
          JSR     NEXTMARQ
          DEC     TEMP1
          LDA     TEMP1
          CMP     #$06
          BNE     ISCLOOP3

          RTS


*  THIS ROUTINE PUTS UP THE FRUIT INDICATOR AND SCORE FOR TITLE PAGE
TITLEIND  LDA     STLEVEL                ;GET READY FOR WRITING INDICATORS
          STA     LEVEL
          LDA     #$00
          STA     LIVES
          JMP     WRTINDS                ;WRITE INDICATORS


*  WRITE THE NAME OF A MONSTER UP
WRTNAME   TXA                            ;NOW, WRITE MONSTERS NAME
          TAY
          JSR     WRTMESG
          LDY     #$06                   ;WRITE THE 'WITH'
          JMP     WRTMESG


*  WRITE MS PAC'S NAME UP
WRTPNAME  LDY     #$07                   ;FIRST - WRITE 'STARRING'
          JSR     WRTMESG
          LDY     #$04                   ;NOW, WRITE "MS PAC-MAN"
          JMP     WRTMESG


*  THIS ROUTINE MOVES A MONSTER.
*  INPUT: X = MONSTER
TMOVEMON  JSR     ADJSTMON               ;ADJUST THE MONSTER POSITION
          JSR     TWRTMON                ;WRITE IT
          LDA     M0HPOS,X               ;SEE IF LEFT YET
          CMP     #LEFTEDGE+8
          BCS     TMOVEMON

          LDA     #DUP                   ;MAKE IT LOOK UP
          STA     M0DIR,X

TMLOOP    JSR     ADJSTMON
          JSR     TWRTMON                ;WRITE IT
          LDA     M0ZONE,X               ;SEE IF IN PLACE YET
          CMP     TENDZONE,X
          BPL     TMLOOP

          RTS

*  THIS ROUTINE WRITES THE MONSTER AND FLIPS IT'S STATE
TWRTMON   JSR     DISPMON                ;WRITE IT
          JMP     TWAIT                  ;WAIT A BIT


*  THIS ROUTINE MOVES MS PAC ALONG THE BOTTOM
TMOVEPAC  LDA     PHPOS                  ;ADJUST HPOS
          LDY     PDIR
          JSR     HPOSADJ
          STA     PHPOS
          JSR     PACCHOMP               ;SWITCH DISPLAY STATE
          JSR     WRITEPAC               ;WRITE IT
          JSR     TWAIT                  ;WAIT A BIT
          LDA     PHPOS                  ;SEE IF LEFT YET
          CMP     #INITHPOS+3
          BCS     TMOVEPAC
          LDX     #$17                   ;WAIT A BIT BEFORE CONTINUING
TMPLOOP   JSR     TWAIT
          DEX
          BPL     TMPLOOP
          RTS


*  THIS IS THE WAIT ROUTINE FOR MONSTER AND PAC MOVEMENT
*  PRESERVES X
TWAIT     TXA                            ;STORE X
          PHA
          LDA     RTLOCAL+1              ;FIND TIME TO LEAVE
          CLC
          ADC     #$01
          STA     TEMP16                 ;STORE IT
          JSR     ROTMARQ                ;ROTATE MARQUIS

TWLOOP    JSR     SEEBAUTO               ;SEE IF TIME TO START
          LDA     TEMP16
          CMP     RTLOCAL+1              ;AND WAIT TILL OUR TIME IS OVER
          BPL     TWLOOP

          PLA                            ;RESTORE X
          TAX
          RTS


*  THIS ROTATES THE MARQUIS
ROTMARQ   LDA     #$08                   ;START AT ZONE 8
          STA     TEMP0
RMLOOP0   LDA     #$05                   ;START EACH ZONE AT COLUMN 5
          STA     TEMP1
RMLOOP1   JSR     GETCHAR                ;GET EXISTING CHARACTER
          CMP     #MARQCHAR              ;SEE IF MARQUIS CHARACTER
          BMI     RMNEXT
          TAX
          JSR     NEXTMARQ               ;ROTATE MARQUIS CHARACTER
          JSR     PLOPCHAR               ;PUT NEW CHARACTER
RMNEXT    INC     TEMP1                  ;NEXT COLUMN
          LDA     TEMP1
          CMP     #$16                   ;UP TO COLUMN $16
          BMI     RMLOOP1
          INC     TEMP0                  ;NEXT ZONE
          LDA     TEMP0
          CMP     #$14                   ;UP TO ZONE $14
          BMI     RMLOOP0
          RTS


*  THIS 'INCREMENTS' X WITH WRAP TO INCREMENT THROUGH MARQUIS DOTS
*  INPUT:  X
*  OUTPUT: X
NEXTMARQ  INX
          CPX     #MARQCHAR+8
          BMI     NMOUT
          LDX     #MARQCHAR
NMOUT     RTS


*  THIS DOES THE WORK FOR THE MENU PAGE
MENU      JSR     TITLESET               ;DO BASIC SET UP
          JSR     MENUMSGS               ;PUT UP NUMBER PLAYERS AND FRUIT

          LDY     #$0D                   ;WRITE INSTRUCTIONS
          JSR     WRTMESG
          LDY     #$0E
          JSR     WRTMESG

          JSR     DTBOUNCE               ;DEBOUNCE JOYSTICK
          JSR     DTSELBNC               ;DEBOUNCE SELECT SWITCH
          JSR     DTSAVE                 ;WE DID SOMETHING, SAVE THE TIME

DTBODY    JSR     SEEBMENU               ;SEE IF TIME TO START
          LDA     NEWDIR                 ;SEE IF CENTERED - ZERO TEMP17 IF SO
          CMP     #DCENTER
          BMI     DTBJMP1                ;IF NEGATIVE, JUST INTERPRET IT
          BNE     DTBJMP1A               ;IF POSITIVE, DROP IT TO A 'REAL' VALUE
          LDA     #$00                   ;NOT HIT, CLEAR JOYSTICK WAIT
          STA     TEMP17
          JMP     DTBSEL
DTBJMP1A  SEC                            ;TURN DIAGNALS INTO ADJACENT DIRECTIONS
          SBC     #DDWRIGHT
          STA     NEWDIR
DTBJMP1   DEC     TEMP17                 ;SEE IF LOOK AT JOYSTICK
          BPL     DTBSEL
          JSR     DTBOUNCE               ;DEBOUNCE THE JOYSTICK

          LDA     NEWDIR
          CMP     #DLEFT                 ;SEE WHAT TO DO
          BNE     DTBRIGHT
          JMP     DECDIFF
DTBRIGHT  CMP     #DRIGHT
          BNE     DTBUP
          JMP     INCDIFF
DTBUP     CMP     #DUP
          BNE     DTBDOWN
          JMP     INCPLYR
DTBDOWN   JMP     DECPLYR

DTBSEL    LDA     SWCHB                  ;SEE IF SELECT SWITCH HIT
          AND     #$02
          BEQ     DTBSJMP
          LDA     #$00                   ;NOT HIT, CLEAR SELECT WAIT
          STA     TEMP18
          JMP     DTBNEXT
DTBSJMP   DEC     TEMP18                 ;SEE IF LOOK AT SWITCH
          BPL     DTBNEXT
          JSR     DTSELBNC               ;DEBOUNCE THE JOYSTICK
          JSR     OADVANCE               ;ADVANCE THE OPTION

DTBDIDIT  JSR     DTSAVE                 ;SAVE THE TIME - WE DID SOMETHING
          JSR     MENUMSGS               ;UPDATE THE MESSAGES
          JSR     TITLEIND               ;UPDATE THE INDICATORS

DTBNEXT   LDA     RTLOCAL                ;SEE IF WE'VE WAITED TOO LONG
          CMP     TEMP19
          BNE     DTBNJMP
          JMP     DOATRACT               ;TIME OUT - GO TO TITLE PAGE
DTBNJMP   LDA     RTLOCAL+1              ;WAIT A FRAME
DTBNLOOP  CMP     RTLOCAL+1
          BEQ     DTBNLOOP
          JSR     ROTMARQ                ;ROTATE MARQUIS
          JMP     DTBODY


*  DEBOUNCE CODE FOR JOYSTICK
DTBOUNCE  LDA     #$0C                   ;PUT A LITTLE DEBOUNCING INTO JOYSTICK
          STA     TEMP17
          RTS


*  DEBOUNCE CODE FOR SELECT SWITCH
DTSELBNC  LDA     #$0C                   ;PUT A LITTLE DEBOUNCING INTO SELECT
          STA     TEMP18
          RTS


*  THIS ROUTINE SAVES THE CURRENT TIME AWAY
DTSAVE    LDX     RTLOCAL
          DEX                            ;SUBTRACT 1 FOR EASY COMPARES
          STX     TEMP19
          RTS


*  THIS ROUTINE INCREMENTS DIFFICULTY
INCDIFF   LDX     STLEVEL
          CPX     #$07
          BPL     IDOUT
          INX
          STX     STLEVEL
          JSR     ZEROSCOR
IDOUT     JMP     DTBDIDIT


*  THIS ROUTINE INCREMENTS DIFFICULTY
DECDIFF   LDX     STLEVEL
          BEQ     IDOUT
          DEX
          STX     STLEVEL
          JSR     ZEROSCOR
DDOUT     JMP     DTBDIDIT


*  THIS ROUTINE INCREMENTS PLAYERS
INCPLYR   LDA     #$01
          STA     TWOPLAYR
          JMP     DTBDIDIT


*  THIS ROUTINE DECREMENTS PLAYERS
DECPLYR   LDA     #$00
          STA     TWOPLAYR
          JMP     DTBDIDIT


*  THIS ROUTINE ADVANCES THE OPTION
OADVANCE  INC     STLEVEL                ;GO TO NEXT STARTING LEVEL
          LDA     STLEVEL                ;SEE IF WE WENT OVER THE TOP
          CMP     #$08
          BMI     OAOUT
          LDA     #$00                   ;WRAP LEVEL TO 0
          STA     STLEVEL
          LDA     TWOPLAYR               ;CHANGE NUMBER OF PLAYERS
          EOR     #$01
          STA     TWOPLAYR
OAOUT     JMP     ZEROSCOR               ;OPTION CHANGED, ZERO SCORE


*  THIS ROUTINE WRITES THE NUMBER OF PLAYERS AND FRUIT
MENUMSGS  LDX     TWOPLAYR               ;DO NUMBER OF PLAYERS
          LDY     PLAYRMSG,X
          JSR     WRTMESG
          LDX     STLEVEL                ;NOW DO FRUIT
          LDY     FRUITMSG,X
          JMP     WRTMESG


*  THIS TELLS HOW HI THE MONSTERS GO
TENDZONE  DB      $09,$0C,$0F,$12

*  THESE TABLES CONTROL MESSAGES FOR NUM PLAYERS AND FRUIT
PLAYRMSG  DB      $11,$12
FRUITMSG  DB      $13,$14,$15,$16,$17,$18,$19,$1A

