
*  INIT           INITIALIZATION ROUTINES FOR MS PAC MAN

*  DO THE INITIALIZATION NEEDED AT THE VERY MINIMUM.
STRTINIT  JSR     ZERORAM                ;ZERO RAM, TURN OFF DISPLAY
          FILL    $40,#0,#$60            ;NULL OUT LOWER PART OF PAGE ZERO
          JSR     ZEROSCOR

          LDX     #$1F                   ;RANDOMIZE SEED
SIRRLOOP  EOR     $00,X
          DEX
          BPL     SIRRLOOP
          STA     NEWRAND

          LDX     #$00                   ;GET JOYSTICK STATE SET UP
          STX     INPTCTRL
          LDA     $3900                  ;SEE IF HI SCORE CART IS THERE
          CMP     #$C6
          BNE     NOHSC
          LDA     $3904
          CMP     #$FE
          BNE     NOHSC
          INX
NOHSC     STX     HSCHERE

          LDA     #$00
          STA     CTLSWA                 ;INITIALIZE JOYSTICKS AND SWITCHES
          STA     CTLSWB
          JSR     OURINIT                ;INIT IT OUR WAY

          LDA     #$01
          STA     STLEVEL                ;START DEFAULT AT CHERRY LEVEL

          RTS


*  INITIALIZE STATE OUR WAY - USED ALSO AFTER HSC STUFF
OURINIT   JSR     SCREENNO               ;TURN SCREEN OFF

          LDA     #BLACK
          STA     BACKGRND               ;PUT BACKGROUND TO BLACK
          JSR     LOADDLST               ;INITIALIZE DISPLAY LISTS

          JSR     LOADFONT               ;LOAD FONT
          LDA     #H(STAMPS)
          STA     CHARBASE               ;INSTALL THE MS PAC MAN CHARACTERS
          LDA     #L(DLL)
          STA     DPPL                   ;SET DPPL AND DPPH TO DLLIST
          LDA     #H(DLL)
          STA     DPPH

          JMP     SCREENON               ;TURN SCREEN DISPLAY ON


*  INITIALIZE THE ENTIRE GAME.  ZERO DATA AREAS AND SET CONTROL REGISTERS.
GAMEINIT  JSR     ZERORAM                ;ZERO RAM, TURN OFF SCREEN
          JSR     SCREENON               ;SCREEN BACK ON AGAIN
          LDA     AUTOPLAY
          BNE     GIJMP0
          JSR     ZEROSCOR               ;ZERO SCORE IF NOT IN AUTO-PLAY

GIJMP0    LDA     #$01                   ;SET UP PLAYER 2
          STA     PLAYER
          LDA     STLEVEL                ;SET STARTING LEVEL
          STA     LEVEL
          STA     ADJLEVEL
          JSR     SETRACK
          JSR     INITLIV                ;INITIALIZE NUMBER OF LIVES
          JSR     SCRNINIT               ;INITIALIZE SCREEN AND TIMERS

          JSR     SWITCHPL               ;SET UP PLAYER 1
          LDA     STLEVEL                ;SET STARTING LEVEL
          STA     LEVEL
          STA     ADJLEVEL
          JSR     SETRACK
          JSR     INITLIV                ;INITIALIZE NUMBER OF LIVES


*  THIS ROUTINE INITIALIZES THE STATE FOR A RACK
RACKINIT  JSR     SCRNINIT
          JMP     COMNINIT


*  THIS ROUTINE INITIALIZES THE SCREEN FOR A RACK
SCRNINIT  JSR     LOADDOTS               ;SET UP DOTS
          LDA     #$38                   ;SET NUMBER OF DOTS BEFORE FRUIT APPEAR
          STA     FDOTS

          LDA     #0
          STA     DOTSEATN
          STA     PINKDOTS
          STA     BLUEDOTS
          STA     GOLDDOTS
          STA     DEATHFLG
          STA     EATNDOTS
          STA     TRELEASE

SCRRAND   JSR     RAND                   ;GET A RANDOM NUMBER 0..3 FOR AUTOPLAY
          AND     #$03
          BEQ     SCRRAND                ;DO NOT ALLOW 0 (SHE DIES TOO MUCH)
          STA     RACKRAND
          RTS


*  THIS ROUTINE INITIALIZES BETWEEN PLAYERS
OTHRINIT  JSR     SAVEDOTS               ;UPDATE DOT ARRAY
          JSR     SWITCHPL               ;SWITCH PLAYERS


*  THIS ROUTINE IS USED IN COMMON BY RACKINIT AND OTHRINIT
COMNINIT  LDA     #$00                   ;ZERO OUR LOCAL CLOCKS
          STA     RTLOCAL
          STA     RTLOCAL+1
          STA     NORMTIME
          STA     NORMTIME+1
          JSR     CLRSCRN                ;TURN OFF THE SCREEN

          LDX     RACK
          LDA     DOTCOLOR,X             ;SET COLORS
          STA     P0C1
          LDA     BARCOLOR,X
          STA     P0C2
          LDA     OUTCOLOR,X
          STA     P0C3
          JSR     LOADDLST               ;RESTORE THE DISPLAY LISTS
          JSR     LOADMAP                ;SET UP SCREEN
          JSR     WRTINDS                ;WRITE INDICATORS - GO TO LIFEINIT


*  THIS ROUTIINE INITIALIZES A NEW LIFE (OTHRINIT FALLS THROUGH TO HERE)
LIFEINIT  JSR     CLEARFRT               ;SET UP FOR STARTING LIFE
          JSR     INITPAC
          JSR     INITMON
          JSR     INITSPED
          JSR     CLEARTUN
          JSR     SETPAC
          JSR     SETFRT
          JMP     SETFLSH


*  TURN THE SCREEN OFF
SCREENOF  JSR     WAITVBL                ;WAIT TILL VBLANK STARTED
          LDA     #$7F                   ;TURN GRAPHICS OFF
          STA     CTRL

          JSR     CLRSCRN                ;CLEAR OFF LIVES, FRUITS, AND MONSTERS

          LDX     #$00                   ;CLEAR CHARACTER MAP, $1800-$1BFF
          TXA
SOLOOP    STA     $1800,X
          STA     $1900,X
          STA     $1A00,X
          STA     $1B00,X
          DEX
          BNE     SOLOOP

SOEND     STA     SCRNSTAT               ;ZERO SOME STATE
          STA     KNLTEMP0
          STA     KNLTEMP1
          RTS


*  TURN THE SCREEN OFF WITHOUT ZEROING THE SCREEN
SCREENNO  JSR     WAITVBL                ;WAIT TILL VBLANK STARTED
          LDA     #$7F                   ;TURN GRAPHICS OFF
          STA     CTRL
          LDA     #$00
          BEQ     SOEND


*  TURN THE SCREEN ON
SCREENON  LDA     SCRNSTAT               ;SEE IF SCREEN WAS EVEN OFF
          BNE     SOOUT

          JSR     LOADER                 ;INITIALIZE KERNAL STATE
          JSR     GETCOLOR               ;GET OUR COLORS

          JSR     WAITVBL
          LDA     #$FF                   ;SET THE KERNAL STATE
          STA     KNLTEMP0
          INC     SCRNSTAT               ;SAY THE SCREEN IS ON
          LDA     #GRAPHON
          STA     CTRL                   ;TURN GRAPHICS ON
SOOUT     RTS


*  A ROUTINE TO WATI TILL VBLANK
WAITVBL   BIT     MSTAT                  ;IS VBLANK STARTED YET?
          BPL     WAITVBL
          BIT     MSTAT                  ;IS VBLANK STILL STARTED?
          BPL     WAITVBL
          RTS


*  TURN MISCELLANEOUS GRAPHICS OFF.  THE MOVING OBJECTS AND INDICATORS ARE
*  TURNED OFF.
CLRSCRN   LDA     #OFFSCRN               ;TURN OFF MOVING OBJECTS
          LDX     #$05
CSMLOOP   STA     HPLIST,X
          STA     DOLIST,X
          DEX
          BPL     CSMLOOP

          LDY     #$0B                   ;PUT BONUS LIFE AND FRUIT INDICATORS
          LDX     #$03                   ;  OFF SCREEN
          LDA     #OFFSCRN
CSBLOOP   STA     BDLIST0,X
          STA     BDLIST1,X
          INX
          INX
          INX
          INX
          DEY
          BPL     CSBLOOP

          RTS                            ;ALL DONE


*  THIS ROUTINE WRITES ALL THE INDICATORS ON THE SCREEN
WRTINDS   LDX     LEVEL                  ;SET TYPE OF FRUIT AT BOTTOM
          CPX     #$07
          BMI     WISETFRT
          LDX     #$07
WISETFRT  INX
          STX     RACKFRT
          JSR     LOADINDS               ;SET UP THE INDICATORS
          JSR     WRTSCORE               ;WRITE THE SCORE
          JMP     WRTLIVES               ;FALL THROUGH TO LIFEINIT


*  THIS ROUTINE ADVANCES THE RACK
NEXTRACK  JSR     CLEARTUN
          JSR     FLASHBAR
          LDA     AUTOPLAY               ;SEE IF IN AUTO-PLAY MODE
          BNE     NRAUTO
          LDX     ADJLEVEL
          LDA     ANIMTAB,X              ;SEE IF ANIMATION DUE
          BMI     NRCONT
          JSR     ANIMATE                ;ANIMATE
NRCONT    INC     LEVEL                  ;INCREMENT LEVEL
          INC     ADJLEVEL               ;AND ADJUSTED LEVEL
          LDA     ADJLEVEL               ;SEE IF OUT OF RANGE
          CMP     #$0E
          BMI     NRJMP0
          LDA     #$06                   ;SET BACK TO LEVEL 6
          STA     ADJLEVEL
NRJMP0    JSR     SETRACK
          JSR     RACKINIT               ;INIT THE NEW RACK
          JSR     READY                  ;PUT PLAYER READY UP
          JSR     WAIT
          JMP     WCLEAR

NRAUTO    INC     RACK                   ;AUTO-PLAY NEXT RACK
          LDX     RACK
          CPX     #NUMRACKS
          BPL     NROVER
          LDA     RACKLVL,X
          STA     LEVEL
          STA     ADJLEVEL
          JMP     RACKINIT
NROVER    LDX     #STACKPTR              ;ALL OVER - GO BACK TO TITLE PAGE
          TXS
          JMP     ATTRACT

SETRACK   LDX     ADJLEVEL
          LDA     RACKTAB,X              ;GET THE RACK
          STA     RACK
          RTS


*  THIS ROUTINE INITIALIZES THE DISPLAY LISTS
LOADDLST  LDX     #$58
LDLLOOP0  LDA     DLISTS,X               ;INITIALIZE SCREEN AND INDICATOR LISTS
          STA     DLIST0,X
          STA     DLIST1,X
          DEX
          BPL     LDLLOOP0

          LDX     #$06
LDLLOOP1  LDA     TDLIST,X               ;INITIALIZE TOP DISPLAY LIST
          STA     TOPDLIST,X
          DEX
          BPL     LDLLOOP1

          LDX     #$6E
LDLLOOP2  LDA     DLLIST,X
          STA     DLL,X
          DEX
          BPL     LDLLOOP2

          RTS


*  THIS ROUTINE MOVES THE BLACK BARS OFF THE SCREEN
BARSOFF   LDA     #OFFSCRN
          STA     DLIST0+$20
          STA     DLIST0+$24
          STA     DLIST1+$20
          STA     DLIST1+$24
          RTS


*  THIS ROUTINE FLASHES THE BAR COLOR
FLASHBAR  LDY     #$02
          LDX     RACK                   ;GET BAR COLOR
FBLOOP    LDA     #BLACK                 ;TURN BAR OFF
          STA     P0C2
          JSR     FBWAIT                 ;PAUSE
          LDA     BARCOLOR,X             ;TURN BAR ON
          STA     P0C2
          JSR     FBWAIT                 ;PAUSE
          DEY
          BPL     FBLOOP
          RTS

FBWAIT    LDA     RTLOCAL+1              ;WAIT A BIT FOR THE BAR FLASHING
          CLC
          ADC     #$0E
          STA     TEMP16
FBWLOOP   JSR     SEEBNORM
          LDA     TEMP16
          CMP     RTLOCAL+1
          BPL     FBWLOOP
          RTS


*  THIS ROUTINE ZEROS OUT THE RAM
ZERORAM   JSR     SCREENOF               ;TURN SCREEN OFF FIRST, ZERO $1800-1BFF

          LDA     #$00
          LDX     #$60                   ;ZERO OUT $A0-$FF
ZRLOOP0   STA     $9F,X
          DEX
          BNE     ZRLOOP0
ZRLOOP    STA     $1C00,X                ;ZERO OUT PAGES $1C00 AND $1D00
          STA     $1D00,X
          DEX
          BNE     ZRLOOP
          RTS


*  THIS ROUTINE ZEROS OUT THE SCORE
ZEROSCOR  LDX     #$05
ZSCLOOP   LDA     INITSCOR,X
          STA     P1SCORE,X
          STA     P2SCORE,X
          DEX
          BPL     ZSCLOOP
          RTS


*  THIS ROUTINE SIMPLY DOES A BUSY-WAIT.  THIS IS USED TO HALT ACTION TEMPORARIL
WAIT      LDA     RTLOCAL+1
          CLC
          ADC     #$40
          STA     TEMP16
WLOOP     JSR     SEEBNORM
          LDA     TEMP16
          CMP     RTLOCAL+1
          BPL     WLOOP
          RTS


*  SWITCH DATA BETWEEN PLAYERS
SWITCHPL  LDX     #$0B                   ;SWITCH PLAYER DEPENDANT DATA
SPLLOOP   LDA     LIVES,X
          LDY     BAKLIVES,X
          STY     LIVES,X
          STA     BAKLIVES,X
          DEX
          BPL     SPLLOOP

          LDX     #$7F                   ;SWITCH DOT ARRAYS
SDTLOOP   LDA     DOTARRAY,X
          LDY     BAKDOTS,X
          STA     BAKDOTS,X
          TYA
          STA     DOTARRAY,X
          DEX
          BPL     SDTLOOP

          LDA     PLAYER                 ;SWITCH PLAYER
          EOR     #$01
          STA     PLAYER

          LDA     LIVES                  ;SWITCH BACK IF NO LIVES LEFT
          BMI     SWITCHPL
          RTS


*  ROUTINE TO LOAD MS PAC MAN FONT - ALSO INITIALIZES BLACK CHARACTERS
LOADFONT  LDA     #L(MSFONT)             ;SET UP TEMP0 FOR READS FROM FONT
          STA     TEMP0
          LDA     #H(MSFONT)
          STA     TEMP1
          LDA     #$30                   ;SET UP TEMP2 FOR WRITES TO STAMP AREA
          STA     TEMP2                  ;  FONT STARTS AT $30
          LDA     #$90                   ;INDEX FOR OUTER LOOP - HOW MANY CHARS
          STA     TEMP4                  ;  GET $60 CHARACTERS FROM FONT
          LDY     #$00

LFLOOP    LDA     #H(STAMPS+$500)        ;SET HI BYTE OF WRITE
          STA     TEMP3
          LDX     #$05                   ;INNER LOOP IS SIX BIG (SIZE OF CHAR)
LFLOOP0   LDA     (TEMP0),Y              ;READ FROM FONT
          STA     (TEMP2),Y              ;WRITE TO STAMPS
          INC     TEMP0                  ;INCREMENT READ
          BNE     LFLJMP0
          INC     TEMP1
LFLJMP0   DEC     TEMP3                  ;DECREMENT HI BYTE OF WRITE
          DEX
          BPL     LFLOOP0
          INC     TEMP2                  ;INCREMENT TO NEXT RAM CHARACTER
          DEC     TEMP4
          BNE     LFLOOP

          LDA     #$FF                   ;SET UP THE STAMP FOR BLACK BARS
          STA     STAMPS+2               ;  CHARACTERS 2 AND 3
          STA     STAMPS+3
          STA     STAMPS+$102
          STA     STAMPS+$103
          STA     STAMPS+$202
          STA     STAMPS+$203
          STA     STAMPS+$302
          STA     STAMPS+$303
          STA     STAMPS+$402
          STA     STAMPS+$403
          STA     STAMPS+$502
          STA     STAMPS+$503

          LDA     #$00                   ;SET UP THE STAMP FOR BLANK AREA
          STA     STAMPS+0               ;  CHARACTERS 2 AND 3
          STA     STAMPS+1
          STA     STAMPS+$100
          STA     STAMPS+$101
          STA     STAMPS+$200
          STA     STAMPS+$201
          STA     STAMPS+$300
          STA     STAMPS+$301
          STA     STAMPS+$400
          STA     STAMPS+$401
          STA     STAMPS+$500
          STA     STAMPS+$501

          LDX     #$1D                   ;ZERO OUT KERNAL LISTS
          LDA     #$00
LFLOOP1   STA     MSADDR,X
          STA     FRTADDR,X
          STA     M0ADDR,X
          STA     M1ADDR,X
          STA     M2ADDR,X
          STA     M3ADDR,X
          DEX
          BPL     LFLOOP1

          RTS


*  THIS ROUTINE LOADS THE BITMAPS FOR THE INDICATORS AND SETS UP FRUIT INDS
LOADINDS  LDA     #L(MSCHAR+48)          ;TEMP0 IS START OF MS PAC
          STA     TEMP0
          LDA     #H(MSCHAR+48)
          STA     TEMP1
          LDA     #$28
          STA     TEMP4
          JSR     LIBODY                 ;DO IT - WRITE THE MS PAC INDICATOR

          LDA     #L(FRUITCHR)           ;TEMP0 IS START OF FRUIT
          STA     TEMP0                  ;  ENTRY POINT FOR CHANGING FRUIT
          LDA     #H(FRUITCHR)
          STA     TEMP1

          LDX     #$00                   ;WRITE THE FRUITS
NFLOOP    LDA     FRTSTMP,X              ;WHERE IT'S GOING TO
          STA     TEMP4
          STX     TEMP15
          JSR     LIBODY                 ;DO IT
          LDX     TEMP15
          LDA     TEMP0                  ;MOVE TO NEXT FRUIT STAMP
          CLC
          ADC     #24
          STA     TEMP0
          LDA     TEMP1
          ADC     #$00
          STA     TEMP1
          INX
          CPX     #$08
          BMI     NFLOOP

          LDX     STLEVEL                ;NOW - SET UP FRUIT INDS
          BNE     LIFLOAD
          LDA     RACKFRT                ;IF STARTING AT TDY BEAR AND GOING TO
          CMP     #$07                   ;  BANANA, THEN DON'T DISPLAY TDY BEAR
          BMI     LIFLOAD
          INX
LIFLOAD   LDY     #$2D                   ;INDEX INTO DISPLAY LISTS
LIFLOOP   LDA     BDLIST0,Y              ;CHANGE PALETTE
          AND     #$1F
          ORA     FRTPAL,X
          STA     BDLIST0,Y
          STA     BDLIST1,Y
          DEY
          LDA     FRTSTMP,X              ;SET STAMP
          STA     BDLIST0,Y
          CLC
          ADC     #$02
          STA     BDLIST1,Y
          DEY
          DEY
          DEY
          INX
          CPX     RACKFRT
          BMI     LIFLOOP

LIFOUT    RTS


*  THIS ROUTINE DOES THE WORK FOR THE FRUIT AND PAC WRITING ROUTINES
LIBODY    LDA     #H(STAMPS+$500)        ;SET TEMP8 TO DESTINATION
          STA     TEMP9
          LDA     TEMP0                  ;SET (TEMP2) TO POINT TO SECOND PART
          CLC
          ADC     #$0C
          STA     TEMP2
          LDA     TEMP1
          ADC     #$00
          STA     TEMP3

          LDX     #$00                   ;AND DO IT
          LDY     #$00
LILOOP    LDA     TEMP4                  ;MOVING INTO STAMPS STARTING AT TEMP4
          STA     TEMP8
          LDA     (TEMP0),Y              ;UPPER STAMP FIRST BYTE
          STA     (TEMP8,X)
          INC     TEMP8
          INY
          LDA     (TEMP0),Y              ;UPPER STAMP SECOND BYTE
          STA     (TEMP8,X)
          INC     TEMP8
          DEY
          LDA     (TEMP2),Y              ;LOWER STAMP FIRST BYTE
          STA     (TEMP8,X)
          INC     TEMP8
          INY
          LDA     (TEMP2),Y              ;LOWER STAMP SECOND BYTE
          STA     (TEMP8,X)
          INC     TEMP8

          INY                            ;GET SET FOR NEXT
          DEC     TEMP9                  ;MOVE TO NEXT OUTPUT PAGE
          LDA     TEMP9
          CMP     #H(STAMPS)
          BPL     LILOOP

          RTS


*  DEFAULT TEMPLATE FOR DISPLAY LIST
DLISTS    DB      L(SCREEN),$60,H(SCREEN),$00+$04,$18      ;SCREEN - PLAY FIELD
          DB      0,$20+$1E,H(STAMPS),OFFSCRN              ;MS PAC
          DB      0,$40+$1E,H(STAMPS),OFFSCRN              ;FRUIT
          DB      0,$60+$1E,H(STAMPS),OFFSCRN              ;MONSTER 0
          DB      0,$80+$1E,H(STAMPS),OFFSCRN              ;MONSTER 1
          DB      0,$A0+$1E,H(STAMPS),OFFSCRN              ;MONSTER 2
          DB      0,$C0+$1E,H(STAMPS),OFFSCRN              ;MONSTER 3
          DB      $02,$20+$1E,H(STAMPS),$10                ;BLACK BAR
          DB      $02,$20+$1E,H(STAMPS),$88                ;BLACK BAR
          DB      $00,$00
          DB      $00,$20+$1E,H(STAMPS),LEFTSIDE-$01       ;INDICATOR ZONE
          DB      $00,$20+$1E,H(STAMPS),LEFTSIDE+$08       ; 5 INDS WITH PAC PLT
          DB      $00,$20+$1E,H(STAMPS),LEFTSIDE+$11
          DB      $00,$20+$1E,H(STAMPS),LEFTSIDE+$1A
          DB      $00,$20+$1E,H(STAMPS),LEFTSIDE+$23
          DB      $00,$00+$1E,H(STAMPS),RGHTSIDE-$44       ;FRUIT INDICATORS
          DB      $00,$00+$1E,H(STAMPS),RGHTSIDE-$3A       ;  STAMP AND PALETTES
          DB      $00,$00+$1E,H(STAMPS),RGHTSIDE-$30       ;  MUST BE SET
          DB      $00,$00+$1E,H(STAMPS),RGHTSIDE-$26
          DB      $00,$00+$1E,H(STAMPS),RGHTSIDE-$1C
          DB      $00,$00+$1E,H(STAMPS),RGHTSIDE-$12
          DB      $00,$00+$1E,H(STAMPS),RGHTSIDE-$08
          DB      $00,$00
TDLIST    DB      L(SCORE),$60,H(SCORE),$00+$04,$18        ;SCORE DLIST
          DB      $00,$00

*  THIS IS THE DISPLAY LIST LIST.  THIS WILL BE DROPPED INTO RAM.
DLLIST    DB      $0F,H(NULDLIST),L(NULDLIST)            ;16 BLANK LINES
          DB      $08,H(NULDLIST),L(NULDLIST)            ;9 BLANK LINES
          DB      $85,H(TOPDLIST),L(TOPDLIST)            ;SCORE ZONE
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $85,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(DLIST0),L(DLIST0)                ;PF ZONE - 0
          DB      $05,H(DLIST1),L(DLIST1)                ;PF ZONE - 1
          DB      $85,H(BDLIST0),L(BDLIST0)              ;INDICATOR ZONE - 0
          DB      $85,H(BDLIST1),L(BDLIST1)              ;INDICATOR ZONE - 1
          DB      $0F,H(NULDLIST),L(NULDLIST)            ;16 BLANK LINES
          DB      $0F,H(NULDLIST),L(NULDLIST)            ;16 BLANK LINES

*  COLORS FOR THE RACKS
BARCOLOR  DB      PINK,BLUE,BROWN,DKBLUE
OUTCOLOR  DB      LTPINK,LTBLUE,LTBROWN,LTGREEN
DOTCOLOR  DB      BLUE,YELLOW,PINK,LTBLUE

*  MAPPING FROM LEVEL TO RACK
RACKTAB   DB      0,0,0,1,1,1,2,2,2,2,3,3,3,3
ANIMTAB   DB      -1,-1,0,-1,-1,1,-1,-1,-1,2,-1,-1,-1,2

*  MAPPING FROM RACK TO LEVEL FOR AUTO-PLAY
RACKLVL   DB      $01,$03,$06,$0A

*  TABLES TO INITIALIZE SCORES AND BONUSES
INITSCOR  DB      $00,$00,$00,$00,$09,$99

*  MAPPING OF FRUIT TO PALETTE AND STAMP
FRTPAL    DB      $60,$60,$80,$A0,$60,$60,$C0,$20
FRTSTMP   DB      $FC,$F8,$F4,$F0,$EC,$E8,$E4,$E0
