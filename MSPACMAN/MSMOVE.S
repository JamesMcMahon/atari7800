
*  PAC.S          ROUTINES FOR THE MS PAC


*  MOVE THE MS PAC
MOVEPAC   JSR     SETPAC                 ;SET NEXT PAC MOVE
          INC     TRELEASE

          JSR     INCPSPED
          JSR     CHKPAC                 ;SEE IF SPEED REG SAYS ITS TIME
          BEQ     MPOUT

          DEC     PDELAY                 ;SEE IF WE ARE IN A DOT EATING DELAY
          BNE     MPOUT
          INC     PDELAY

          LDA     PTUNNEL
          BEQ     MPNORM
          JSR     PACDIRT                ;SEE IF DIRECTION CHANGED IN TUNNEL
          JSR     PACTUNNL               ;MOVE THROUGH THE TUNNEL
          JMP     MPCHOMP

MPNORM    JSR     PACDIR                 ;SET THE DIRECTION
          LDA     PMOVING                ;IF NOT MOVING, DO NOTHING
          BEQ     MPOUT
          JSR     PACMOVE                ;MOVE THE PAC
          JSR     PACEAT                 ;SEE IF ANYTHING GOOD TO EAT
MPCHOMP   JSR     PACCHOMP               ;CHANGE THE DISPLAY STATE
          JSR     WRITEPAC               ;WRITE THE PAC
          JMP     PFINTR                 ;LOOK FOR ANY INTERSECTIONS


*  SET THE NEXT MS PAC MOVE
SETPAC    LDA     RTLOCAL+1
          CLC
          ADC     #WAITPAC
          STA     PACWAIT
MPOUT     RTS


*  THIS ROUTINE FINDS OUT WHAT DIRECTION TO MOVE
PACDIR    LDA     AUTOPLAY               ;SEE IF WE ARE PLAYING
          BEQ     PACDCONT
          JMP     AUTODIR

PACDCONT  JSR     PACJOY                 ;GET A JOYSTICK DIRECTION

          LDX     PZONE                  ;SET UP FOR CHECKDIR
          STX     TEMP4
          LDA     PCOL
          STA     TEMP5
          LDA     PDIR
          STA     TEMP6
          JSR     CHECKDIR               ;GET LEGITIMATE JOYSTICK DIRECTIONS

          LDY     NEWDIR                 ;GET THE DIRECTION
          CPY     PDIR                   ;SEE IF TURNED
          BEQ     PDOUT
          CPY     #$04                   ;SEE IF CENTERED
          BPL     PDOUT

          LDA     TEMP12,Y               ;SEE IF LEGITIMATE
          BMI     PDOUT
          STY     PDIR                   ;GOOD - SET DIRECTION
          LDA     #$01
          STA     PMOVING                ;START IT AGAIN IF IT WAS STOPPED

PDOUT     LDA     PHPOS                  ;SEE IF IN 'CENTER' OF CHAR
          AND     #$03
          CMP     #$01
          BNE     PDEND
          LDA     POFF
          CMP     #$03
          BNE     PDEND
          LDX     PDIR
          LDA     TEMP12,X               ;SEE IF PAC STOPPED AGAINST WALL
          BPL     PDEND
          LDA     #$00
          STA     PMOVING
PDEND     RTS


*  THIS ROUTINE GETS A JOYSTICK DIRECTION AND TURNS THE 8-WAY JOYSTICK INTO A
*  4-WAY
PACJOY    JSR     GETJOY                 ;GET THE JOYSTICK DIRECTION

          LDA     NEWDIR                 ;SEE IF ANY INTERPRETATION NEEDED
          SEC
          SBC     #DDWRIGHT
          BMI     PJOUT
          STA     TEMP0                  ;THIS IS AMOUNT OVER DCENTER

          LDA     PDIR                   ;GET CURRENT DIRECTION
          ASL     A
          ASL     A                      ;MULTIPLY BY 4
          ORA     TEMP0                  ;ADD IN DIRECTION
          TAX
          LDA     PJOYTAB,X              ;FIND NEW DIRECTION
          STA     NEWDIR                 ;AND STORE IT AWAY

PJOUT     RTS


*  MOVE THE MS PAC
PACMOVE   LDY     PDIR                   ;MOVE THE PAC IN THE RIGHT DIRECTION
          LDX     POFF
          TYA
          AND     #$01                   ;WILL BE NON-ZERO IF VERTICAL MOVE
          BNE     PMVERT

          LDA     PHPOS                  ;MOVE HORIZONTALLY
          JSR     HPOSADJ
          STA     PHPOS
          CMP     #RGHTEDGE              ;CHECK FOR TUNNEL WRAP
          BCC     PMHJMP0
          STA     PTUNNEL
PMHJMP0   CMP     #LEFTEDGE
          BCS     PMHJMP1
          STA     PTUNNEL

PMHJMP1   LDA     PVPOSADJ,X             ;CENTER ADJUST VERTICALLY
          CLC
          ADC     PVPOS
          STA     PVPOS
          JMP     PMOUT

PMVERT    LDA     PVPOS
          JSR     VPOSADJ                ;MOVE VERTICALLY
          STA     PVPOS

          LDA     PHPOS                  ;CENTER ADJUST HORIZONTALLY
          AND     #$03
          TAX
          LDA     PHPOSADJ,X
          CLC
          ADC     PHPOS
          STA     PHPOS

PMOUT     LDA     PHPOS
          JSR     HTOC
          STA     PCOL
PACVTOZO  LDA     PVPOS                  ;OUTSIDE ENTRY TO SET ZONE AND OFFSET
          JSR     VTOZO
          INY
          STY     PZONE
          STA     POFF
          RTS


*  THIS ROUTINE FINDS OUT IF THE PLAYER IS CHANGING DIRECTION IN TUNNEL
PACDIRT   LDA     AUTOPLAY               ;SEE IF WE ARE PLAYING
          BNE     PDTOUT

          JSR     PACJOY                 ;GET A JOYSTICK DIRECTION

          LDA     NEWDIR                 ;GET THE DIRECTION
          CMP     PDIR                   ;SEE IF TURNED
          BEQ     PDTOUT
          CMP     #DCENTER               ;SEE IF CENTERED
          BPL     PDTOUT
          AND     #$01                   ;MAKE SURE LEFT OR RIGHT
          BNE     PDTOUT

          LDA     NEWDIR
          STA     PDIR                   ;GOOD - SET DIRECTION

PDTOUT    RTS


*  MOVE THE MS PAC THROUGH THE TUNNEL
PACTUNNL  LDY     PDIR                   ;MOVE THE PAC IN THE RIGHT DIRECTION
          LDX     POFF
          LDA     PHPOS                  ;MOVE HORIZONTALLY
          JSR     HPOSADJ
          STA     PHPOS

          CPY     #DRIGHT
          BEQ     PTRIGHT
          CMP     #LEFTWRAP              ;MOVING LEFT
          BCS     PTLJMP0                ;SEE IF WRAP TIME YET
          CLC
          ADC     #WRAPSIZE
          STA     PHPOS
PTLJMP0   CMP     #RGHTEDGE              ;SEE IF END OF TUNNEL
          BCS     PTLJMP1
          CMP     #80
          BCC     PTLJMP1
          LDA     #$00
          STA     PTUNNEL
PTLJMP1   JMP     PMHJMP1

PTRIGHT   CMP     #RGHTWRAP              ;MOVING RIGHT
          BCC     PTRJMP0                ;SEE IF WRAP TIME YET
          SEC
          SBC     #WRAPSIZE
          STA     PHPOS
PTRJMP0   CMP     #LEFTEDGE              ;SEE IF END OF TUNNEL
          BCC     PTRJMP1
          CMP     #80
          BCS     PTRJMP1
          LDA     #$00
          STA     PTUNNEL
PTRJMP1   JMP     PMHJMP1


*  ADJUST THE MS PAC DISPLAY STATE
PACCHOMP  LDX     PDISP                  ;ADJUST MS PAC STATE
          BMI     MPOPEN
          DEX                            ;MS PAC CLOSING
          BNE     MPSDISP
          LDX     #$80
          JMP     MPSDISP
MPOPEN    INX                            ;MS PAC OPENING
          CPX     #$82
          BNE     MPSDISP
          LDX     #$02
MPSDISP   STX     PDISP
          RTS


*  SEE IF ANYTHING GOOD TO EAT WHERE MS PAC IS
PACEAT    LDX     PZONE
          STX     TEMP0
          LDA     PCOL
          STA     TEMP1
          JSR     GETCHAR                ;SEE WHAT IS UNDER HER
          CMP     #DOTCHAR               ;SEE IF NORMAL DOT
          BEQ     PEATDOT
          AND     #$FE                   ;GET RID OF LEFT/RIGHT PARITY
          CMP     #EDOTCHAR              ;SEE IF ENERGY DOT
          BEQ     PEATEDOT
          RTS
PEATEDOT  JSR     TURNBLUE               ;EATING AN ENERGY DOT
          LDA     #$04                   ;ADD 50 TO SCORE
          JSR     ADDSCORE
AAAAA     LDA     #3
          STA     PDELAY
          JMP     PECLEAR
PEATDOT   LDA     #$01                   ;EAT A DOT
          JSR     ADDSCORE               ;ADD 10 TO SCORE
          LDA     #$10                   ;MAKE DOT MUNCH SOUND
          JSR     DOTUNE
          LDA     #1
          STA     PDELAY
PECLEAR   JSR     SAVETIME               ;FIRST - SAY A DOT WAS EATEN NOW
          LDX     PZONE
          STX     TEMP0
          LDA     PCOL
          STA     TEMP1
          LDX     #BLNKCHAR              ;CLEAR THE CURRENT POSITION
          JSR     PLOPCHAR
          DEC     FDOTS
          BPL     PEDCONT
          JSR     INITFRT
PEDCONT   DEC     DOTS                   ;ONE LESS DOT TO EAT - SEE IF RACK DONE
          BNE     PCCONT
          DEC     DOTS+1                 ;SEE IF ALL OUT
          BPL     PCCONT
          JMP     PNEXTRCK               ;RACK ALL OVER
PCCONT    INC     DOTSEATN
          LDA     #0
          STA     TRELEASE

          LDA     DEATHFLG
          BEQ     INCDOTZ
          INC     EATNDOTS
          RTS
INCDOTZ
          LDA     M0STATE+3
          CMP     #MSTATPEN
          BNE     INCDTOUT
          LDA     M0STATE+2
          CMP     #MSTATPEN
          BEQ     INCDOTZ1
          INC     GOLDDOTS
          RTS
INCDOTZ1  LDA     M0STATE+1
          CMP     #MSTATPEN
          BEQ     INCDOTZ2
          INC     BLUEDOTS
          RTS
INCDOTZ2  INC     PINKDOTS
INCDTOUT
          RTS
PNEXTRCK  JMP     NEXTRACK               ;ALL DONE


*  INITIALIZE THE MS PAC STATE
INITPAC   LDA     #INITVPOS              ;SET VERTICAL POSITION AND ZONE
          STA     PVPOS
          JSR     VTOZO
          INY
          STY     PZONE
          STA     POFF
          LDA     #INITHPOS              ;SET HORIZONTAL POSITION AND COLUMN
          STA     PHPOS
          JSR     HTOC
          STA     PCOL
          LDA     #DLEFT                 ;SET DIRECTION
          STA     PDIR
          STA     NEWDIR                 ;AND DEFAULT JOYSTICK DIRECTION
          LDA     #$01                   ;SET DISPLAY STATE
          STA     PDISP
          STA     PMOVING
          STA     PDELAY
          LDA     #$00
          STA     PTUNNEL

          JSR     PACSTAMP
          JSR     WRITEPAC               ;WRITE IT
          JMP     SAVETIME               ;START TIME WITH NOW


*  THIS ROUTINE SETS UP THE COLORS FOR MS PAC-MAN
PACSTAMP  LDA     #YELLOW                ;SET MS PAC COLORS
          STA     P1C1
          LDA     #PINK
          STA     P1C2
          LDA     #BLACK
          STA     P1C3
          RTS


*  WRITE A MS PAC ON THE SCREEN
WRITEPAC  LDA     PDISP                  ;SET WHICH STAMP
          ASL     A
          ASL     A
          ORA     PDIR                   ;A = MOUTH STATE*4 + DIRECTION
          TAX
          LDA     PACSTMPL,X             ;SET STAMP LISTS
          STA     SLLIST
          LDA     PACSTMPH,X
          STA     SHLIST

          LDA     PHPOS                  ;SET HPOS, DO FLAG, AND LEAVE
          SEC
          SBC     #$03
          STA     HPLIST
          LDX     PZONE
          DEX
          STX     VZLIST
          STA     DOLIST
          RTS


*  ERASE THE MS PAC
ERASEPAC  LDA     #OFFSCRN               ;PUT THE CHARACTER OFF SCREEN
          STA     HPLIST
          STA     DOLIST
ADEND     RTS


*  THIS ROUTINE GIVES A DIRECTION WHEN IN AUTO-PLAY MODE
AUTODIR   LDA     PHPOS                  ;SEE IF IN 'CENTER' OF CHAR
          AND     #$03
          CMP     #$01
          BNE     ADEND
          LDA     POFF
          CMP     #$03
          BNE     ADEND

          LDX     PZONE                  ;SET UP FOR CHECKDIR
          STX     TEMP4
          LDA     PCOL
          STA     TEMP5
          LDA     PDIR
          STA     TEMP6

          JSR     RAND                   ;PICK RANDOM CORNER AS DEFAULT GOAL
          AND     #$03
          TAX
          LDA     RANDZONE,X
          STA     TEMP7
          LDA     RANDCOL,X
          STA     TEMP8

          LDX     #$00                   ;FIRST - SEE IF A MONSTER IS THE GOAL
ADMLOOP   LDA     M0BLUE,X               ;MAKE SURE IT IS BLUE AND NORMAL
          BEQ     ADMNEXT
          LDA     M0STATE,X
          CMP     #MSTNORM
          BNE     ADMNEXT
          LDY     M0ZONE,X
          STY     TEMP7
          LDA     M0COL,X
          STA     TEMP8
          JMP     ADOUT
ADMNEXT   INX
          CPX     #$04
          BMI     ADMLOOP

          LDY     RACKRAND               ;GET OUR STARTING POWER DOT
ADPLOOP   LDA     RACK
          EOR     RRZONE,Y
          TAX                            ;GET ZONE FOR THIS DOT
          LDA     EDZONE0,X
          STA     TEMP0
          LDA     RACK
          EOR     RRCOL,Y
          TAX                            ;GET COLUMN FOR THIS DOT
          LDA     EDCOL0,X
          STA     TEMP1
          JSR     GETCHAR                ;SEE IF IT IS THERE
          AND     #$FE                   ;MIGHT BE FLASHED
          CMP     #EDOTCHAR
          BEQ     ADEDOT
          INY                            ;CHECK NEXT DOT
          CPY     #$04
          BMI     ADPJMP0
          LDY     #$00
ADPJMP0   CPY     RACKRAND               ;SEE IF WE'VE TRIED ALL DOTS
          BNE     ADPLOOP
          JMP     ADFRUIT

ADEDOT    LDA     TEMP0                  ;FOUND A DOT
          STA     TEMP7
          LDA     TEMP1
          STA     TEMP8

ADFRUIT   LDA     FENABLE                ;SEE IF TRY FOR FRUIT
          BEQ     ADOUT
          LDA     FSCORE
          BNE     ADOUT
          LDX     FZONE
          STX     TEMP7
          LDA     FCOL
          STA     TEMP8
          JMP     ADOUT

ADOUT     JSR     CHECKDIR               ;FIND VALID DIRECTIONS
          CMP     #0
          BNE     ADFINSH
          JSR     WHCHWAY                ;FIND RIGHT DIRECTION
          STA     PDIR                   ;STORE IT
ADFINSH   RTS


*  THIS PUTS THE MS PAC THROUGH THE DEATH SEQUENCE
KILLPAC   JSR     CLEARTUN
          JSR     FINALDOT
          JSR     WAIT
          LDA     #$00
          STA     DEATHFLG
          LDA     #$01
          STA     PDIR                   ;MAKE HER POINT DOWN
          STA     PDISP                  ;MAKE HER HALF OPEN
          JSR     WRITEPAC
          LDA     #$0C                   ;MAKE DEATH SOUND
          JSR     DOTUNE

          LDX     #$05
          LDA     #OFFSCRN               ;TURN EVERYTHING ELSE OFF THE SCREEN
KPCLLOOP  STA     HPLIST,X
          STA     DOLIST,X
          DEX
          BNE     KPCLLOOP

          LDA     #$09                   ;SPIN 2 1/2 TIMES
          STA     TEMP0
KPSLOOP   LDA     RTLOCAL+1              ;SPIN MS PAC
          CLC
          ADC     #$07
          STA     TEMP16
KPSLLOOP  JSR     SEEBNORM
          LDA     TEMP16
          CMP     RTLOCAL+1              ;WAIT FOR A BIT
          BPL     KPSLLOOP
          INC     PDIR
          LDA     PDIR
          AND     #$03
          STA     PDIR
          JSR     WRITEPAC
          DEC     TEMP0
          BPL     KPSLOOP
          RTS


*  THIS ROUTINE SAVES THE PRESENT TIME IN DOTTIME
SAVETIME  LDA     RTLOCAL
          STA     DOTTIME
          LDA     RTLOCAL+1
          STA     DOTTIME+1
          RTS


*  TABLES FOR PAC STAMPS
PACSTMPL  DB      L(MSCHAR),L(MSCHAR+$48),L(MSCHAR+$90),L(MSCHAR+$D8)
          DB      L(MSCHAR+$18),L(MSCHAR+$60),L(MSCHAR+$A8),L(MSCHAR+$F0)
          DB      L(MSCHAR+$30),L(MSCHAR+$78),L(MSCHAR+$C0),L(MSCHAR+$108)
PACSTMPH  DB      H(MSCHAR),H(MSCHAR+$48),H(MSCHAR+$90),H(MSCHAR+$D8)
          DB      H(MSCHAR+$18),H(MSCHAR+$60),H(MSCHAR+$A8),H(MSCHAR+$F0)
          DB      H(MSCHAR+$30),H(MSCHAR+$78),H(MSCHAR+$C0),H(MSCHAR+$108)

*  TABLES FOR CENTERING ADJUSTMENT
PHPOSADJ  DB      $01,$00,$FF,$FF
PVPOSADJ  DB      $02,$02,$01,$00,$FF,$FE

*  TABLES FOR RANDOM CORNERS
RANDZONE  DB      $00,$1D,$00,$1D
RANDCOL   DB      $00,$1B,$00,$1B

*  TABLES FOR GOING FROM E-DOT INDEX TO ZONE AND COL FOR THAT DOT
RRZONE    DB      $00,$00,$04,$04
RRCOL     DB      $00,$04,$00,$04

*  TABLES FOR CONVERTING THE JOYSTICK FROM 8-WAY TO 4-WAY
PJOYTAB   DB      DRIGHT,DDOWN,DUP,DRIGHT
          DB      DDOWN,DDOWN,DLEFT,DRIGHT
          DB      DDOWN,DLEFT,DLEFT,DUP
          DB      DRIGHT,DLEFT,DUP,DUP
