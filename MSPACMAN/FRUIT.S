
*  FRUIT.S        ROUTINES FOR THE FRUIT


*  MOVE THE FRUIT
MOVEFRT   JSR     SETFRT                 ;SET NEXT FRUIT MOVE
          LDA     FENABLE
          BEQ     MFOUT
          LDA     FSCORE
          BNE     MFSCORE
          JSR     FRTSOUND               ;DO THE FRUIT SOUND, IF NEEDED
          JMP     FRTDIR                 ;SET THE DIRECTION
MFSCORE   DEC     FSCORE
          BNE     MFOUT
          JMP     CLEARFRT
MFOUT     RTS


*  SET THE NEXT FRUIT MOVE
SETFRT    LDA     RTLOCAL+1
          CLC
          ADC     #WAITFRT
          STA     FRTWAIT
          RTS


*  THIS ROUTINE DOES THE BOUNCING SOUND FOR THE FRUIT
FRTSOUND  DEC     FSOUND                 ;SEE IF TIME FOR SOUND YET
          BPL     FSOUT
          LDA     #$03                   ;SET UP NEXT SOUND
          STA     FSOUND
          LDA     #$0B                   ;MAKE FRUIT BOUNCE NOISE
          JSR     DOTUNE
FSOUT     RTS


*  THIS ROUTINE FINDS OUT WHAT DIRECTION TO MOVE
FRTDIR    LDA     FCOUNT                 ;SEE IF IN 'CENTER' OF CHAR
          AND     #$03
          BNE     FDEND
          LDA     FTUNNEL                ;SEE IF FRUIT IN TUNNEL
          BNE     FDEND

          LDA     FZONE                  ;SEE IF WE HAVE REACHED THE GOAL
          CMP     FGZONE
          BNE     FDIRCONT
          LDA     FCOL
          CMP     FGCOL
          BNE     FDIRCONT
          JSR     FRTGOAL                ;GET THE NEXT GOAL

FDIRCONT  LDX     FZONE                  ;SET UP FOR CALL ON WHCHWAY
          STX     TEMP4
          LDA     FCOL
          STA     TEMP5
          LDA     FDIR
          STA     TEMP6
          JSR     CHECKDIR
          LDX     FGZONE
          STX     TEMP7
          LDA     FGCOL
          STA     TEMP8
          JSR     WHCHWAY                ;FIND OUT WHICH WAY TO GO
          STA     FDIR                   ;NEW DIRECTION

FDEND     JMP     FRTMOVE
FDCLEAR   JMP     CLEARFRT

*  MOVE THE FRUIT
FRTMOVE   LDY     FDIR
          LDX     FOFF
          LDA     FHPOS                  ;MOVE HORIZONTALLY
          JSR     HPOSADJ
          STA     FHPOS
          LDA     FVPOS                  ;MOVE VERTICALLY
          JSR     VPOSADJ
          STA     FVPOS

          LDY     FCOUNT
          LDA     FVPOS                  ;MOVING VERTICALLY
          CLC
          ADC     BOUNCTB,Y              ;ADJUST FOR BOUNCE
          STA     FVPOS

          DEY                            ;ADJUST COUNT
          BPL     FMJMP0
          LDY     #$03
FMJMP0    STY     FCOUNT

          LDA     FHPOS                  ;SEE IF IN TUNNEL OR OFF SCREEN
          CMP     #LEFTEDGE
          BCS     FMCHKRGT
          CMP     #LEFTWRAP
          BCS     FMTUNNEL
          JMP     CLEARFRT               ;OFF SCREEN - KILL IT
FMCHKRGT  CMP     #RGHTEDGE
          BCC     FMNORMAL
          CMP     #RGHTWRAP
          BCC     FMTUNNEL
          JMP     CLEARFRT               ;OFF SCREEN - KILL IT

FMTUNNEL  LDA     #$01                   ;MOVING THROUGH TUNNEL
          STA     FTUNNEL
          JMP     FMZONE                 ;ADJUST ZONE, BUT NOT COLUMN, COL BOGUS

FMNORMAL  LDA     #$00                   ;MOVING AROUND MAZE
          STA     FTUNNEL
          LDA     FHPOS                  ;SET COLUMN
          JSR     HTOC
          STA     FCOL
FMZONE    LDA     FVPOS                  ;SET ZONE
          JSR     VTOZO
          INY
          STY     FZONE
          STA     FOFF

          JMP     WRITEFRT


*  INITIALIZE THE FRUIT STATE
INITFRT   LDA     FENABLE                ;MAKE SURE FRUIT IS NOT ON YET
          BNE     IFOUT
          LDA     #$01
          STA     FENABLE                ;ENABLE
          STA     FTUNNEL                ;STARTING IN TUNNEL
          LDA     #$00
          STA     FGCOUNT
          STA     FSCORE
          STA     FSOUND
          LDA     #$02
          STA     FCOUNT

          LDA     LEVEL                  ;SET FRUIT TYPE
          CMP     #$08
          BMI     IFCONT
IFRAND    JSR     RAND                   ;RANDOM FRUIT
          AND     #$07
          CMP     STLEVEL
          BMI     IFRAND                 ;NO RANDOM FRUIT BELOW WHAT YOU STARTED
IFCONT    STA     FFRUIT

          JSR     RAND                   ;RANDOM TUNNEL TO COME THROUGH
          AND     #$01                   ;SET STARTING ZONE
          STA     TEMP0
          LDA     RACK
          ASL     A
          ORA     TEMP0                  ;A = 2*RACK + [0..1], INDEX TO TUNNEL
          TAX
          LDA     #$02                   ;SET OFFSET
          STA     FOFF
          LDA     TNLZONE,X              ;SET ZONE
          STA     FZONE
          JSR     ZTOV
          SEC
          SBC     #$04                   ;SET VPOS
          STA     FVPOS

          JSR     RAND                   ;SET STARTING COLUMN/DIRECTION
          AND     #$02                   ;EITHER 0 (RIGHT) OR 2 (LEFT)
          STA     FDIR                   ;SET DIR
          LSR     A                      ;EITHER 0 (LEFT COL) OR 1 (RIGHT COL)
          TAX
          LDA     TNLCOL,X
          STA     FCOL                   ;SET COL
          LDA     TNLHPOS,X
          STA     FHPOS                  ;SET HPOS

          JSR     FRTGOAL                ;GET A GOAL

          JSR     FRTSTAMP               ;SET THE STAMP
          JSR     WRITEFRT               ;WRITE IT

IFOUT     LDA     #$70
          STA     FDOTS                  ;SET UP THE NEXT FRUIT
          RTS


*  THIS ROUTINE FINDS THE NEXT GOAL FOR THE FRUIT
*  RETURN VALUE IS BOTH 0 IN X AND THE EQ BIT SET WHEN NO MORE GOALS TO BE HAD
FRTGOAL   LDX     FGCOUNT
          CPX     #$04
          BPL     FGOUT
          CPX     #$03
          BPL     FGLEAVE
          LDA     GOALZONE,X             ;GET NEXT GOAL
          STA     FGZONE
          LDA     GOALCOL,X
          STA     FGCOL
          INX
          STX     FGCOUNT
          RTS
FGLEAVE   JSR     RAND                   ;GET A RANDOM TUNNEL TO LEAVE
          AND     #$03                   ;  GET THE COLUMN FIRST
          STA     TEMP0
          LDA     RACK
          ASL     A
          ASL     A
          ORA     TEMP0                  ;A = 3*RACK + [0..3], INDEX TO TUNNEL
          TAY
          LDA     TNLCOLG,Y
          STA     FGCOL
          TYA                            ;GET THE ZONE
          LSR     A
          TAY
          LDA     TNLZONE,Y
          STA     FGZONE
          INX
          STX     FGCOUNT
FGOUT     RTS


*  CLEAR FRUIT
CLEARFRT  LDA     #$00
          STA     FENABLE


*  ERASE THE FRUIT
ERASEFRT  LDA     #OFFSCRN               ;SET HPOS AND DOLIST
          STA     HPLIST+1
          STA     DOLIST+1
          RTS


*  WRITE A FRUIT ON THE SCREEN
WRITEFRT  LDA     FHPOS                  ;SET HPOS AND DOLIST
          SEC
          SBC     #$03
          STA     HPLIST+1
          LDX     FZONE
          DEX
          STX     VZLIST+1
          STA     DOLIST+1
          RTS


*  PUT THE RIGHT FRUIT STAMPS INTO STAMPS
FRTSTAMP  LDX     FFRUIT                 ;WHICH ONE IT IS
          LDA     FLSTAMP,X              ;SET STAMP
          STA     SLLIST+1
          LDA     FHSTAMP,X
          STA     SHLIST+1
          LDY     FPALETTE,X
          LDA     FCOLOR1,Y              ;SET PALETTE FOR FRUIT
          STA     P2C1
          LDA     FCOLOR2,Y
          STA     P2C2
          LDA     FCOLOR3,Y
          STA     P2C3
          RTS


*  EAT THE FRUIT - MAKE IT GO AWAY
EATFRT    LDX     FFRUIT
          LDA     NLSTAMP,X              ;SET STAMP
          STA     SLLIST+1
          LDA     NHSTAMP,X
          STA     SHLIST+1
          STA     DOLIST+1

          LDA     #LTGREEN
          STA     P2C3

          LDA     #$10                   ;SET TIME FOR IT TO STAY
          STA     FSCORE

          LDA     #$12                   ;MAKE FRUIT EAT SOUND
          JSR     DOTUNE
          RTS


*  TABLE TO CONTROL FRUIT BOUNCING
BOUNCTB   DB      $FF,$FF,$01,$01

*  TABLES TO SET FRUIT STAMPS AND FRUIT NUMBER STAMPS
FLSTAMP   DB      L(FRUITCHR),L(FRUITCHR+$18),L(FRUITCHR+$30)
          DB      L(FRUITCHR+$48),L(FRUITCHR+$60),L(FRUITCHR+$78)
          DB      L(FRUITCHR+$90),L(FRUITCHR+$A8)
FHSTAMP   DB      H(FRUITCHR),H(FRUITCHR+$18),H(FRUITCHR+$30)
          DB      H(FRUITCHR+$48),H(FRUITCHR+$60),H(FRUITCHR+$78)
          DB      H(FRUITCHR+$90),H(FRUITCHR+$A8)
NLSTAMP   DB      L(FRUITNUM),L(FRUITNUM+$18),L(FRUITNUM+$30)
          DB      L(FRUITNUM+$48),L(FRUITNUM+$60),L(FRUITNUM+$78)
          DB      L(FRUITNUM+$90),L(FRUITNUM+$A8)
NHSTAMP   DB      H(FRUITNUM),H(FRUITNUM+$18),H(FRUITNUM+$30)
          DB      H(FRUITNUM+$48),H(FRUITNUM+$60),H(FRUITNUM+$78)
          DB      H(FRUITNUM+$90),H(FRUITNUM+$A8)

*  TABLES TO SET FRUIT COLORS
FPALETTE  DB      0,0,1,2,0,0,3,4
FCOLOR1   DB      RED,RED,ORANGE,GREEN,YELLOW
FCOLOR2   DB      WHITE,WHITE,BROWN,WHITE,BLACK
FCOLOR3   DB      BROWN,GREEN,GREEN,BROWN,BLACK

*  TABLES TO SET TUNNEL ENTRANCES
TNLZONE   DB      $07,$10,$01,$16
          DB      $08,$08,$0C,$0F
TNLCOL    DB      $00,$1B
TNLHPOS   DB      LEFTWRAP,RGHTWRAP
TNLCOLG   DB      $02,$19,$02,$19,$05,$16,$02,$19
          DB      $00,$1B,$00,$1B,$03,$18,$03,$18

*  TABLES FOR FRUIT GOALS
GOALZONE  DB      $10,$0A,$10
GOALCOL   DB      $0F,$10,$0F
