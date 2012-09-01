*** LOADER.S ***  (CENTIPEDE)

* 12/17   DVP


******************************************
          ORG     $C398                  ;103 BYTES
SCORIT
          LDX     #0+2*NSCORES
          LDY     #0
          JSR     SCRDSP

          LDA     GAMETYPE
          BEQ     SCRHIGH

          LDX     #1+2*NSCORES
          LDY     #25
          JSR     SCRDSP

          LDA     GAMETYPE
          CMP     #3
          BNE     SCRHIGH
          LDX     #2+2*NSCORES           ;DISPLAY TOTAL SCORE IN TEAM PLAY
          LDY     #9
          BNE     SCRDSP

SCRHIGH   LDA     DIFLEVEL
          CLC
          ADC     #3+2*NSCORES
          TAX
          LDY     #12

SCRDSP    LDA     #L(EMPTY)
          STA     MUSHMAP,Y
          STA     MUSHMAP+1,Y
          STA     MUSHMAP+2,Y
          STA     MUSHMAP+3,Y
          STA     MUSHMAP+4,Y

          SEC
SCRDSPLP  LDA     SCORE0,X
          AND     #$F0
          BCC     DOIT1
          BEQ     NXTDGT1
DOIT1     LSR     A
          LSR     A
          LSR     A
          LSR     A
          STA     MUSHMAP,Y
NXTDGT1   INY
          LDA     SCORE0,X
          AND     #$0F
          BCC     DOIT2
          BEQ     NXTDGT2
          CLC
DOIT2     STA     MUSHMAP,Y
NXTDGT2   INY
          DEX
          DEX
          DEX
          DEX
          DEX
          DEX
          DEX
          BPL     SCRDSPLP

          STA     MUSHMAP-1,Y
SCRDONE   RTS




******************************************
          ORG     $C498                  ;103 BYTES (WITH HLINE)

LMST      LDA     COLORFLG               ;DO NEW COLORS NEED TO BE DEFINED?
          BMI     ENDLMST                ;NO, SO SKIP THE COLOR LOADING
          DEC     COLORFLG
          BPL     ENDLMST                ;YES, BUT FOR THE NEXT OBJECT TABLE

          JSR     OFFSCRN

          LDX     PLAYER                 ;COMPUTE ADDRESS OF NEW COLORS
          LDA     GAMETYPE
          CMP     #2
          BCC     ZLOAD1
          LDX     #0
ZLOAD1    LDA     CLRINDEX,X
          CLC
          ADC     #L(COLORTBL)
          STA     TEMPADDR
          LDA     #H(COLORTBL)
          ADC     #0
          STA     TEMPADDR+1
          LDX     #12                    ;LOAD PALETTES  6, 5, 4, AND 3
          LDY     #11
PALLOOP   LDA     (TEMPADDR),Y           ;LOAD A PALETTE WITH COLORS
          STA     P3C3,X
          DEY
          LDA     (TEMPADDR),Y
          STA     P3C2,X
          DEY
          LDA     (TEMPADDR),Y
          STA     P3C1,X
          DEY
          DEX
          DEX
          DEX
          DEX
          CPX     HSCFLAG
          BPL     PALLOOP

ENDLMST   RTS






******************************************
          ORG     $CD10

LOADER    BIT     OBJTBSEM               ;IS LOADER'S OBJ. TBL. READY?
          BMI     LOADIT
          RTS

LOADIT    LDY     #5                     ;INITIALIZE DISPLAY LIST OFFSETS TO 5
          LDX     #22
INITDLOF  STY     DLOFFSTS-1,X
          DEX
          BNE     INITDLOF

          BIT     ATTRACT
          BPL     GOLOAD
          DEY
          STY     DLOFFSTS+4
          STY     DLOFFSTS+5
          STY     DLOFFSTS+6
          STY     DLOFFSTS+7
;;;;;     LDX     #0
          STX     DL2+6
          STX     DL3+6
          STX     DL4+6
          STX     DL5+6
          STX     DL10+6
          STX     DL11+6
          STX     DL12+6
          STX     DL13+6
          STX     DL14+6
          STX     DL15+6
          STX     DL16+6
          STX     DL17+6
          STX     DL18+6
          STX     DL19+6
          STX     DL20+6
          STX     DL21+6
          STX     DL22+6
          STX     DL23+6
          STX     DL24+1
GOLOAD    STX     DLOFFSTS+22

INITBFLG ;LDX     #0
LOADOBJ   LDA     OBJSTAT,X
          BPL     SKPOBJMP               ;DON'T LOAD DEAD OBJECTS

DOOBJ     LDA     OBJY,X                 ;COMPUTE OBJECT'S ZONE
          CMP     TOPLINE
          BCS     ZDOOBJ
SKPOBJMP  JMP     SKIPOBJ                ;IF AT VERY TOP OF SCREEN
ZDOOBJ    LSR     A
          LSR     A
          LSR     A
          STA     TEMP2
          TAY                            ;STORE ZONE # IN Y
          CMP     SCRLONZN
          BNE     DOOBJ123
          INY                            ;SCROLLING ON FROM TOP, DISPLAY BOTTOM
                                         ;    ZONE ONLY

DOOBJ123                                 ;COMPUTE LOW BYTE OF HEADER ADDRESS
          LDA     DLOFFSTS-1,Y
          CMP     #5+16*4                ;CHECK TO MAKE SURE DL NOT FULL
          BCS     SKPOBJMP
;;;;;     CLC
          ADC     LDLTBL,Y
          STA     TEMPADDR
          LDA     HDLTBL,Y               ;COMPUTE HIGH BYTE OF HEADER ADDRESS
          ADC     #0
          STA     TEMPADDR+1

          LDA     #4                     ;UPDATE ZONE'S DISPLAY LIST OFFSET
          ADC     DLOFFSTS-1,Y
          STA     DLOFFSTS-1,Y

          LDA     OBJY,X                 ;DOES OBJECT CROSS ZONE BOUNDARY?
          CMP     MINIMUMY
          AND     #$07
          BCC     TOPSCRLL               ;SCROLLING ON, BOTTOM ZONE ONLY
          STA     TEMP1
          BEQ     INONEZNE
          LDA     ATTRACT
          BPL     SKPATTR5               ;IF NOT IN ATTRACT MODE
          CPY     #YBTMATTR/8
          BEQ     INONEZNE               ;SPECIAL ATTRACT MODE DISAPPEARENCE
          BCS     SKIPOBJ
SKPATTR5  CPY     #23
          BCS     INONEZNE               ;SCROLLING OFF, TOP ZONE ONLY

* INTWOZNS
          INY                            ;NOW WORK ON THE ZONE BELOW
          LDA     LDLTBL,Y               ;COMPUTE LOW BYTE OF HEADER ADDRESS
;         CLC                            ;CLEARED BY CPY #23
          ADC     DLOFFSTS-1,Y
          STA     TEMP3
          LDA     HDLTBL,Y               ;COMPUTE HIGH BYTE OF HEADER ADDRESS
          ADC     #0
          STA     TEMP4

          LDA     #4                     ;ALSO UPDATE THIS ZONE'S DSPY LST OFST
          ADC     DLOFFSTS-1,Y
          STA     DLOFFSTS-1,Y

          LDY     #0                     ;LOAD THE TWO HEADERS
          LDA     OBJOFFST,X              ;LOW ADDRESS BYTE
          STA     (TEMPADDR),Y
          CMP     #L(LSCRP)
          BCC     SCRP2ZN
          CMP     #L(LSCRP+16)
          BCS     SCRP2ZN
          DEY
          STY     TEMP1
          INY
;         CLC
          ADC     #$40
SCRP2ZN   STA     (TEMP3),Y

          INY                            ;Y=1
          LDA     OBJPALWD,X             ;PALETTE/WIDTH BYTE
          STA     (TEMPADDR),Y
          STA     (TEMP3),Y

          INY                            ;Y=2
          LDA     TEMP1                  ;HIGH ADDRESS BYTE
          BMI     HISCORP
          CLC                            ;(CARRY IS CLEAR AFTER ADD 4 TO OFST.)
          ADC     #H(STMPBASE)
          STA     (TEMPADDR),Y
;         CLC
          SBC     #7
          BNE     NOHIGHS

HISCORP   LDA     #H(STMPBASE)
          STA     (TEMPADDR),Y
NOHIGHS   STA     (TEMP3),Y

          INY                            ;Y=3
          LDA     OBJX,X                 ;HORIZONTAL POSITION BYTE
          STA     (TEMP3),Y
SKIPOBJ2  STA     (TEMPADDR),Y

SKIPOBJ   INX
          CPX     #18
          BEQ     LOADDONE
          JMP     LOADOBJ

*******************
TOPSCRLL  ;CLC
          SBC     #7
          STA     TEMP1

INONEZNE  LDY     #0                     ;LOAD HEADER FOR NO ZONE CROSSING
          LDA     OBJOFFST,X             ;LOW ADDRESS BYTE
          STA     (TEMPADDR),Y

          INY                            ;Y=1
          LDA     OBJPALWD,X             ;PALETTE/WIDTH BYTE
          STA     (TEMPADDR),Y

          INY                            ;Y=2
          LDA     TEMP1                  ;HIGH ADDRESS BYTE
          CLC
          ADC     #H(STMPBASE)
          STA     (TEMPADDR),Y

          INY                            ;Y=3
          LDA     OBJX,X                 ;HORIZONTAL POSITION BYTE
          JMP     SKIPOBJ2

******************
LOADDONE
          LDA     #$00                   ;SET FOR NO LINES AT TOP OR BOTTOM
          STA     HLINEDL+1
          BIT     ATTRACT
          BMI     LDATTRHD

          LDX     #11                    ;SET UP DL FOR HORIZONTAL LINES
HLNLP     LDA     HLNDL,X
          STA     HLINEDL,X
          DEX
          BPL     HLNLP

          LDX     #23
BLNKLP    LDA     LDLTBL,X               ;GET ADDRESS OF DL
          STA     TEMPADDR
          LDA     HDLTBL,X
          STA     TEMPADDR+1

          LDY     DLOFFSTS-1,X

          LDA     #L(BLACKL)             ;BLNKLEFT
          STA     (TEMPADDR),Y

          INY
          LDA     #$FE                   ;PALETTE 7, WIDTH 2 BYTES
          STA     (TEMPADDR),Y

          INY
          LDA     #H(STMPBASE)
          STA     (TEMPADDR),Y

          INY
          LDA     #MINX-8
          STA     (TEMPADDR),Y

          INY
          LDA     #L(BLACKR)             ;BLNKRGHT
          STA     (TEMPADDR),Y

          INY
          LDA     #$FE                   ;PALETTE 7, WIDTH 2 BYTES
          STA     (TEMPADDR),Y

          INY
          LDA     #H(STMPBASE)
          STA     (TEMPADDR),Y

          INY
          LDA     #MAXX
          STA     (TEMPADDR),Y

          INY                            ;ENDDL
          INY
          LDA     #0
          STA     (TEMPADDR),Y

          DEX                            ;NOBLNK
          BNE     BLNKLP
          BEQ     LOADOUT


LDATTRHD
          LDX     #3                     ;TOP HEADERS FOR LOGO DISPLAY LISTS
NEXTATCV  LDA     ATTRYBSE/8+LDLTBL,X
          STA     TEMPADDR
          LDA     ATTRYBSE/8+HDLTBL,X
          STA     TEMPADDR+1

          LDY     DLOFFSTS+4,X
          LDA     HTITLGRP,X
          STA     (TEMPADDR),Y

          INY
          LDA     #PWTITLE
          STA     (TEMPADDR),Y

          INY
          LDA     #H(TPG8LIN1)
          STA     (TEMPADDR),Y

          INY
          LDA     #MINX
          STA     (TEMPADDR),Y

          INY
          INY
          LDA     #0
          STA     (TEMPADDR),Y

          DEX
          BPL     NEXTATCV

LOADOUT   LDA     #0                     ;RESET SEMAPHORE
          STA     OBJTBSEM
          RTS

HTITLGRP  DB   L(TPG8CVR1),L(TPG8CVR2),L(TPG8CVR3),L(TPG8CVR4)


HLNDL     DB      L(HLINE),$E1,H(HLINE),MINX
          DB      L(BLACKL),$FE,H(BLACKL),MINX-8
          DB      L(BLACKR),$FE,H(BLACKR),MAXX

HLINE     DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DB      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DB      $FF


*******************************************************************************
************************ START OF TRACKBALL STUFF ******************************


TRACKIT   LDY     #$00                   ;INITIALIZE LOOP FLAG
          STY     TRACKF                 ;ASSUME JOYSTICK
          STY     TRACKF+1
          STY     CTLSWB
          LDA     SWCHB
          STA     PANEL
          INY
BIGLOOP   LDA     INPT4,Y
          STA     BUTNIB,Y
          IF      NEWBOARD
          TYA
          ASL     A
          TAY
          LDA     INPT0,Y                ;THESE FOUR LINES MUST BE INCLUDED IN
                                         ;THE FINAL VERSION
          AND     INPT1,Y                ;REMEMBER
          BMI     FUCKBAR                ;REMEMBER,. . ., ROSEBUD
          TYA
          LSR     A
          TAY
JEXIT     JMP     EXIT
          ENDIF
FUCKBAR   TYA
          LSR     A
          TAY
          LDX     #0
IDAGAIN   LDA     CLOCK,Y
          STA     CTLSWB                 ;FORCE CLOCK TO OUTPUT
          IF      NEWBOARD
          LDA     #0                     ;ON NEWBOARD PULL CLOCK LOW FIRST
          ENDIF
          STA     SWCHB                  ;FORCE CLOCK HIGH
          LDA     PMASK,Y
          STA     CTLSWA                 ;FORCE PADDLE LINES TO OUTPUT

          LDA     #0
          STA     SWCHA                  ;FORCE PADDLE LINES LOW

          IF      NEWBOARD
          LDA     CLOCK,Y                ;CLOCK HIGH
          ELSE
          LDA     #$00                   ;CLOCK LOW
          ENDIF

          STA     SWCHB
          STA     CTLSWA                 ;CONFIGURE PADDLES TO READ
          LDA     SWCHA                  ;READ PADDLES FOR ID
          AND     PMASK,Y                ;MASK OFF PLAYER 2 PADDLE INPUTS
          CMP     PID,Y                  ;SEE IF TRACKBALL
          BEQ     IDFOUND                ;IF TRACKBALL THEN SERVICE
          ;****************** ID SYNC LOOP *******************
          TXA                            ;SEE IF THROUGH ID LOOP TWICE
          BMI     JEXIT                  ;IF SO NO ID TO BE FOUND
          DEX                            ;SET THROUGH LOOP FLAG
          BNE     IDAGAIN                ;TRY TO GET ID AGAIN ALWAYS A JUMP
          ;*************** CLOCK OUT NIBBLES ********************
IDFOUND   LDA     CLOCK,Y                ;CLOCKHIGH
          STA     TRACKF,Y               ;TELL US ITS TRACKBALL TIME
          IF      NEWBOARD
          EOR     #$FF                   ;CLOCK LOW
          ENDIF
          STA     SWCHB
          IF      NEWBOARD
          LDA     CLOCK,Y                ;FORCE CLOCK HIGH
          ELSE
          LDA     #$00                   ;FORCE CLOCK LOW
          ENDIF
          STA     SWCHB                  ;FORCE CLOCK LOW
          LDA     SWCHA                  ;READ FIRST NIBBLE (BUTTON STATUS)
          JSR     SHIFTY                 ;GET APPROPRIATE NIBBLE
          STA     BUTNIB,Y               ;STORE BUTTON STATUS AT BUTNIB
          ASL     A
          ORA     BUTNIB,Y
          EOR     #$80
          STA     BUTNIB,Y

                                         ;**************************
          LDX     INDX,Y                 ;GET INDEX FOR PLAYER

TLOOP
          IF      NEWBOARD
          LDA     #0                     ;CLOCK LOW
          ELSE
          LDA     CLOCK,Y                ;CLOCK HIGH
          ENDIF

          STA     SWCHB
          IF      NEWBOARD
          LDA     CLOCK,Y
          ELSE
          LDA     #$00
          ENDIF

          STA     SWCHB                  ;FORCE CLOCK LOW
          LDA     SWCHA                  ;READ SECOND NIBBLE (X HIGH)
          JSR     SHIFTY                 ;GET IT IN UPPER NIBBLE

          STA     YCOUNT,X               ;STORE UNTIL GET HIGH NIBBLE
          IF      NEWBOARD
          LDA     #0                     ;CLOCK LOW
          ELSE
          LDA     CLOCK,Y                ;CLOCK HIGH
          ENDIF

          STA     SWCHB

          IF      NEWBOARD
          LDA     CLOCK,Y                ;CLOCK HIGH
          ELSE
          LDA     #$00                   ;CLOCK LOW
          ENDIF

          STA     SWCHB                  ;FORCE CLOCK LOW
          LDA     SWCHA                  ;READ THIRD NIBBLE (X LOW)
          JSR     SHIFTR                 ;SHIFT IT RIGHT OR NOT AT ALL
;         LSR     A                      ;SHIFT TO LOW NIBBLE POSITION
;         LSR     A
;         LSR     A
;         LSR     A
          ORA     YCOUNT,X               ;COMBINE LOW AND HIGH NIBBLES
          STA     YCOUNT,X               ;TRANSFER COMPLETE X COUNT BYTE
                                         ;*********************************
          DEX
          TXA
          CMP     COCOW,Y
          BNE     TLOOP

          TYA
          ASL     A
          TAX
          LDA     YCOUNT,X
          SEC
          CLD
          SBC     OLDY,X                 ;GET DELTA X VALUE
          STA     DELTAY,Y               ;**** NOTE IF DELTAX > 80 HEX THEN
                                         ;** DELTA X IS NEGATIVE WITH MAGNITUDE
                                         ;** EQUAL TO THE 2'S COMPLEMENT OF
                                         ;** DELTA X. IF  DELTA X <80 HEX THEN
                                         ;** THE CHANGE IN X IS POSITIVE WITH
                                         ;** MAGNITUDE OF DELTAX
          LDA     YCOUNT,X
          STA     OLDY,X                 ;SET 'OLDX' TO PRESENT XCOUNT
          LDA     XCOUNT,X
          SEC
          CLD
          SBC     OLDX,X                 ;GET DELTA X VALUE
          STA     DELTAX,Y               ;**** NOTE IF DELTAX > 80 HEX THEN
                                         ;** DELTA X IS NEGATIVE WITH MAGNITUDE
                                         ;** EQUAL TO THE 2'S COMPLEMENT OF
                                         ;** DELTA X. IF  DELTA X <80 HEX THEN
                                         ;** THE CHANGE IN X IS POSITIVE WITH
                                         ;** MAGNITUDE OF DELTAX
          LDA     XCOUNT,X
          STA     OLDX,X                 ;SET 'OLDX' TO PRESENT XCOUNT

          ;*******************************************************************
EXIT      DEY
          BMI     GOWAY
          JMP     BIGLOOP                ;DETERMINE IF THERE IS A SECOND TBALL
GOWAY
          LDA     TRACKF
          ASL     A
          ASL     A
          EOR     TRACKF+1
          BNE     ZGOWAY
          STA     ALTCTRLS
ZGOWAY    INY
          STY     CTLSWA                 ;FORCE PORT A TO INPUT MODE
          STY     CTLSWB                 ;FORCE PORT B TO INPUT MODE
          RTS
INDX      DB      $01,$03
COCOW     DB      $FF,$01
CLOCK     DB      $04,$10
PMASK     DB      $F0,$0F
PID       DB      $10,$01
SHIFTY    CPY     #0
          BEQ     NOSHIT
          ASL     A
          ASL     A
          ASL     A
          ASL     A
NOSHIT    AND     #$F0
          RTS
SHIFTR    CPY     #1
          BEQ     NOSHR
          LSR     A
          LSR     A
          LSR     A
          LSR     A
NOSHR     AND     #$F
          RTS

