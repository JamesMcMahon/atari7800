*         NILE FLYER - ALIAS SPHINX - SENEMIES
* MAY 8 VERSION.  PROGRAMMING NEW FLEAS.
* NO NEED FOR SHADOWS TO HAVE X,Y AND Z


	org	$F000

NFLS      EQU     8                      ; POSSIBLE NUMBER OF FLEAS
NFL2      EQU     $0F                    ; TWICE NUMBER OF FLEAS
SCRWID    EQU     160                    ; HPOS SCREEN WIDTH
FLEXPL    EQU     8                      ; START OF NON EXPLODING FLEAS

*** FOR FLEA MOVEMENT ***
FLYHI     EQU     $2E
FLYLO     EQU     $06
FLXHI     EQU     $78
FLXLO     EQU     $38

* POSITION INITIALIZATIONS *
XSTARTS:  .dc.b      $39,$3D,$41,$47,$4D,$50,$54,$57
          .dc.b      $5D,$60,$65,$69,$6B,$6E,$72,$76
YSTARTS:  .dc.b      $07,$09,$0B,$0F,$12,$14,$16,$19
          .dc.b      $1B,$1D,$20,$23,$26,$28,$2A,$2D
ZSTART    EQU     210

************************************************************

*         ENEMY INITIALIZER
* THIS ROUTINE INITIALIZES X,Y,Z,SM,SH,SL AND PW FOR THE GLIDERS AND THE
* SHADOWS.  THE DRIVER ACTUALLY INSERTS THE OBJECT WHEN IT IS TIME.

FLEAINIT:                                ;CLASS IS ALREADY LOADED
          JSR     RANDOM
          AND     #$0F                   ;RANDOM # <= 15
          TAX
          LDA     XSTARTS,X              ;GET RANDOM XSTART POSITION
          STA     SPNX                   ;PUSH X COORD
          JSR     RANDOM                 ;37
          AND     #$0F                   ;<=15
          TAX
          LDA     YSTARTS,X              ;GET RANDOM Y POSTION
          STA     SPNY                   ;PUSH Y COORD
          LDA     #ZSTART
          STA     SPNZ                   ;PUSH Z COORD
          JSR     SPAWN
          RTS

** SPAWN A NEW FLYING ENEMY (FLEA) **
ZSHADPW   EQU     $3D                    ;PW FOR SHADOWS

SPAWN:
          STY     TEMP0                  ;SAVE X,Y REGISTERS
          STX     TEMP1

	jmp	.enter
	LDX	#UWEDEX+2		;LOOK FOR AVAILABLE UWE
.LOP1:	LDA	UWESTATE-UWEDEX,X
	BNE	ERROR1			;CAN'T HAVE UWE AND FLEA AT SAME TIME.
	DEX
	CPX	#UWEDEX			;ANY MORE UWES TO CHECK?
	BCS	.LOP1
.enter:

** RETURN IN Y THE INDEX OF AN AVAIL FLEA **
          LDY     #NFLS-1
FLOOP:    LDA     FLEASTAT,Y             ;CHECK FOR AVAIL FLEA
          ORA     FLEASTAT+NFLS,Y
          BEQ     HAVEY
          DEY
          BPL     FLOOP
ERROR1:   LDY     TEMP0   ; THIS WAS A TRAP      ;NO AVAILABLE FLEAS
          RTS
HAVEY:
* PLAY A TUNE *
          LDA     #SPTUNE
          JSR     TUNIN

* Y NOW CONTAINS NEW FLEA INDEX (0-7) *
          LDA     #3                     ;INITIALLY MAKE IT OFF SCREEN
          STA     FLEASTAT,Y
          STA     FLEASTAT+NFLS,Y
          LDA     #FLEACOL
          STA     COLSTAT+FLEADEX,Y

          DEC     NUMFLEAS               ;DEC NUM OF AVAIL FLYING ENEMIES

* INITIALIZE FLEA TARGET *
          LDX     SPNCLASS               ;X = CLASS

          LDA     TARLOAD,X
          STA     FLEACNT,Y              ;INIT MT PROG COUNTER
          LDA     #0
          STA     FXRUN,Y                ;INIT X VELOCITY
          LDA     #0
          STA     FYRUN,Y                ;INIT Y VELOCITY
          JSR     RANDOM
          ORA     #$FE
          STA     FZRUN,Y                ;INIT Z VELOCITY
          LDA     TARPW,X                ;LOAD PALETTE WIDTH BYTE
          STA     PWTBL+FLEADEX,Y
          LDA     #ZSHADPW               ;LOAD SHADOW PALETTE WIDTH
          STA     PWTBL+FLSHDEX,Y
          LDA     TARTYPE,X              ;LOAD FLEA TYPE (0 GL, 1 SC, ETC)
          STA     FLEATYPE,Y
          TAX                            ;X = TYPE OF FLEA
** X NOW CONTAINS TYPE OF FLEA **

** SET POSITION OF FLEA **
* ZCOORD *
          LDA     SPNZ
          STA     ZTBL+FLEADEX,Y         ;Z STORED
          STA     ZTBL+FLSHDEX,Y         ;Z STORED FOR SHADOW
          SEC
          SBC     FCOLDZ1,X
          STA     COLZ1+FLEADEX,Y        ;STUFF COLZ1
          CLC
          ADC     FCOLDZ2,X
          STA     COLZ2+FLEADEX,Y        ;STUFF COLZ2

* Y COORD *
          LDA     #0
          STA     YTBL+FLSHDEX,Y         ;Y STORED FOR SHADOW
          LDA     SPNY
          STA     YTBL+FLEADEX,Y         ;Y STORED
          SEC
          SBC     FCOLDY1,X
          STA     COLY1+FLEADEX,Y        ;STUFF COLY1
          CLC
          ADC     FCOLDY2,X
          STA     COLY2+FLEADEX,Y        ;STUFF COLY2

* XCOORD *
          LDA     SPNX
          STA     XTBL+FLEADEX,Y         ;X STORED
          STA     XTBL+FLSHDEX,Y         ;X STORED FOR SHADOW
          SEC
          SBC     FCOLDX1,X
          STA     COLX1+FLEADEX,Y        ;STUFF COLX1
          CLC
          ADC     FCOLDX2,X
          STA     COLX2+FLEADEX,Y        ;STUFF COLX2

* X CONTAINS TYPE (0-3) *
* Y CONTAINS FLEA INDEX (0-7) *

* INITIALIZE FLEA ANIMATION *
          LDA     FLIFTBL,X              ;LOAD INITIAL FRAME FOR THIS TYPE
          STA     FLEANIM,Y
          TAX
          LDA     FLSHAPES,X             ;LOAD IN ANIMATION NUMBER OF FRAME
          TAX
          LDA     FLSHPTBL-1,X           ;LOAD IN SHAPE
          STA     SLTBL+FLEADEX,Y
          LDA     FLSHDTBL-1,X           ;LOAD IN SHADOW
          STA     SLTBL+FLSHDEX,Y
          LDA     #UNFOLD0/256            ;LOAD HI BYTE OF INIT SHAPE
          STA     SHTBL+FLEADEX,Y
          STA     SHTBL+FLSHDEX,Y
          LDA     #(UNFOLD0-$1600+$1700)/256 ;LOAD 16 TALL
                                         ;SM:=SH-#ZNUMLINS+17 OBJ IS NOW 16 TALL
          STA     SMTBL+FLEADEX,Y
          STA     SMTBL+FLSHDEX,Y

          LDY     TEMP0
          LDX     TEMP1
          RTS



*         ENEMY DRIVER
*CHECKS SCREEN BOUNDS, INSERTS, DELETES AND
* MOVES OBJECTS ON SCREEN

FLITBL:   .dc.b      FLEADEX,FLEADEX+1,FLEADEX+2,FLEADEX+3
          .dc.b      FLEADEX+4,FLEADEX+5,FLEADEX+6,FLEADEX+7
          .dc.b      FLSHDEX,FLSHDEX+1,FLSHDEX+2,FLSHDEX+3
          .dc.b      FLSHDEX+4,FLSHDEX+5,FLSHDEX+6,FLSHDEX+7

ANIMFLEA:
          JSR     ADVFRMS                ;ADVANCE THE FRAMES
          JSR     MOVEFLEA

* CHECK FOR COLLISIONS *
          LDY     #NFLS-1
MVDETCOL:
          LDA     FLEASTAT,Y
          CMP     #1                     ;SHOULD FIX STUCK FLEA
          BEQ     MVDETC1
          BNE     MVEND
MVDETC1:  LDA     COLSTAT+FLEADEX,Y
          BEQ     MVEND                  ;ALREADY EXPLODING
          JSR     FLEADET                ;CHECK FOR COLLISION
MVEND:    DEY
          BPL     MVDETCOL

*** MOVE ONTO, AROUND OR OFF OF SCREEN ***
          LDY     #NFL2                  ;SIXTEEN OBJECTS TOTAL
FSCRLOOP:
          LDA     FLEASTAT,Y             ;INSPECT FLAG
          BEQ     NEXTONE                ;IF ZERO TRY NEXT FLEA/SHADOW

          LDA     FLITBL,Y
          TAX                            ;PUT REAL INDEX IN X

          LDA     FLEASTAT,Y             ;LOAD SCREEN STATE OF FLEA
          CMP     #1
          BEQ     ONSCREEN
          CMP     #3                     ;<> 3 ==> ON SCREEN
TRAP:     BNE     TRAP

** PRESCREEN DRIVER **
          JSR     HPDO                   ;HORIZ POSITION
          CMP     #SCRWID+8              ;IF HP>172 THEN PUNT
          BCS     NEXTONE
          STA     HPTBL,X                ;OK TO STORE TO HPTBL

          JSR     VPDO                   ;VERTICAL POSITION
          CMP     #$F4                   ;EMPIRICALLY DETERMINED. BOO HOO
          BCS     BRINGON                ;IF BETWEEN -12 AND SCREEN BOTTOM
          CMP     #SCRENBOT              ;THEN BRING FLEA ON SCREEN
          BCS     NEXTONE
BRINGON:  STA     VPTBL,X                ;ELSE STORE VP AND BRING ON

** INSERT OBJECT WITH A CERTAIN PRIORITY **
          CPY     #NFLS
          STY     TEMPY
          BCC     NOTSHAD                ;HANDLE SHADOWS DIFFERENTLY

          LDA     #$FE                   ;SHADOW GETS PRIORITY OF $FE
          STA     TEMP6
          STA     TEMP10
          BCS     ISHAD

NOTSHAD:  JSR     DXDO                   ;CALCULATE DX OF OBJECT TO BE INSERTED
ISHAD:    JSR     OBJINS
          LDY     TEMPY
          LDA     #1                     ;SET FLAG TO 1 TO SIGNAL ONSCREEN
          STA     FLEASTAT,Y

** GO FOR THE NEXT FLEA **
NEXTONE:  DEY                            ;NEXT ENEMY AND/OR SHADOW
          BPL     FSCRLOOP

;         JSR     LISTEST                ;MARK THOSE ELEMENTS
 ;        LDX     #NFL2
; STATLIST  LDY     FLITBL,X
  ;       LDA     TESTLIST,Y
   ;      BNE     INLIST
    ;     LDA     FLEASTAT,X
     ;    CMP     #1
      ;   BEQ     ATWAP
; INLIST    DEX
  ;       BPL     STATLIST

          RTS

; ATWAP     BEQ     ATWAP

** ONSCREEN DRIVER **
ONSCREEN:
          JSR     HPDO                   ;CALCULATE HP
          STA     HPTBL,X
          CMP     #$F4
          BCS     KEEPGOIN
          CMP     #SCRWID+12             ;WHEN HPOS+12 = 0 THEN DELETE
          BCS     GETRID
KEEPGOIN:
          JSR     VPDO                   ;CALCULATE VP
          STA     VPTBL,X
          CMP     #$D8                   ;IF BETWEEN -40 AND SCREEN BOTTOM
          BCS     FLOBJMV                ;THEN MOVE OBJECT
          CMP     #SCRENBOT
          BCC     FLOBJMV

** REMOVE A FLEA OR SHADOW FROM THE SCREEN **
GETRID:                                  ;ELSE PUNT OBJECT
          JSR     OBJDEL
                                         ;RECALL FLEA/SHAD INDEX
          LDA     #0
          STA     FLEASTAT,Y             ;CLEAR SCREEN STATUS
          CPY     #NFLS                  ;IF SHADOW
          BCS     CHCH                   ;GO CHECK FLEA
          STA     COLSTAT+FLEADEX,Y      ;DELETE FLEA FROM COLLISON TABLES
          LDA     FLEASTAT+NFLS,Y        ;CHECK SHADOW
          BNE     NEXTONE                ;STAT  IF ALSO ZERO THEN DEC NUMSCABS

INCNUM:   INC     NUMFLEAS
          BPL     NEXTONE                ;JMP

CHCH:     LDA     FLEASTAT-NFLS,Y        ;LOAD STATUS OF FLEA
          BEQ     INCNUM                 ;IF ALSO ZERO THEN INC NUMFLEAS
          BNE     NEXTONE                ;ELSE NEXT MOVE

** DO AN OBJECT MOVE ON A FLEA **
FLOBJMV:  CPY     #NFLS
          BCS     NEXTONE                ;IF SHADOW NO NEED TO DO AN OBJECT MOVE
          STY     TEMPY
          JSR     DXDO                   ;UPDATE DX
          JSR     OBJMOV                 ;MOVE IN LINKED LIST
          LDY     TEMPY
          JMP     NEXTONE


**        HPDO: HP CALCULATE ROUTINE     **
HPDO:     LDA     XTBL,X
          CLC
          ADC     ZTBL,X
          SBC     #NUMBER                ;SUBTRACT THE MAGIC NUMBER
;         ADC     HPDOTBL,Y
          RTS
;HPDOTBL   .dc.b      0-NUMBER,-1-NUMBER ;GLID,SCAB HP CONSTANTS

**        VPD0  VP CALCULATE ROUTINE     **
VPDO:     LDA     XTBL,X
          SEC
          SBC     YTBL,X
          SBC     ZTBL,X
          CLC
          ADC     #NUMBER-13
;         ADC     VPDOTBL,Y
          RTS
;VPDOTBL   .dc.b      -14+NUMBER,-13+NUMBER  ;GLID,SCAB VP CONSTANTS

**        DXDO: DX CALCULATE ROUTINE     **
DXDO:     LDA     ZTBL,X
          SEC
          SBC     XTBL,X
          CLC
          ADC     #NUMBER+13+DXADJ
;         ADC     DXDFTBL,Y              ; THIS IS DF
          STA     TEMP10
          SEC
          SBC     #18
;         SBC     DXDCTBL,Y                ; THIS IS DC
          STA     TEMP6
          RTS

;DXDFTBL   .dc.b      NUMBER+13+DXADJ        ;GLIDER DISP FAR CONST
;          .dc.b      NUMBER+10+DXADJ        ;SCARAB FAR CONST
;DXDCTBL   .dc.b      18,12                  ;DISPLAY CLOSE CONST


** ANIMATE THE ENEMIES - ADVANCE FRAMES **
ADVFRMS:
          LDY     #NFLS-1                ;EIGHT ENEMIES
ANIMLOOP: LDA     FLEASTAT,Y
          BEQ     NEXTAN                 ;OFF SCREEN ALREADY SO PUNT
          CMP     #3
          BEQ     NEXTAN                 ;NOT ON SCREEN YET SO PUNT
          LDX     FLEANIM,Y
          LDA     FLSHAPES,X
          BEQ     KLFLEA
          BPL     ADV1
          AND     #$7F
          TAX
          LDA     FLSHAPES,X
ADV1:
          INX
          STX     FLEANIM,Y
          TAX
          LDA     FLSHPTBL-1,X
          STA     SLTBL+FLEADEX,Y
          LDA     FLSHDTBL-1,X
          STA     SLTBL+FLSHDEX,Y
          LDA     FLEANIM,Y
          JMP     NEXTAN

KLFLEA:
          LDX     FLITBL,Y               ;LOAD REAL INDEX
          JSR     OBJDEL                 ;AND DELETE FLEA
          LDA     #0                     ;ZERO OUT FLEASTAT
          STA     FLEASTAT,Y
          LDX     FLITBL+NFLS,Y          ;AND ITS SHADOW
          LDA     FLEASTAT+NFLS,Y
          BEQ     KLFLEA1
          JSR     OBJDEL
          LDA     #0
          STA     FLEASTAT+NFLS,Y
KLFLEA1:  INC     NUMFLEAS               ;ONE LESS FLEA

NEXTAN:   DEY
          BPL     ANIMLOOP
          RTS

* FLEA EXPLOSION TUNES *
FLTUNE:
          .dc.b      GLDEXPL
          .dc.b      SCBEXPL
          .dc.b      GLDEXPL
          .dc.b      SCBEXPL

* INITIAL FRAME INDEX *
FLIFTBL:
          .dc.b      $00                    ;GLIDER
          .dc.b      $0C                    ;SCARAB
          .dc.b      $18                    ;PING
          .dc.b      $22                    ;NEUFY

* COLDATA - COLX1,X2,COLY1,Y2,COLZ1,Z2  BY TYPE *
FCOLDX1:  .dc.b      5,4,3,5
FCOLDX2:  .dc.b      10,8,6,10
FCOLDY1:  .dc.b      2,3,3,3
FCOLDY2:  .dc.b      5,7,6,7
FCOLDZ1:  .dc.b      2,2,2,2
FCOLDZ2:  .dc.b      8,8,8,10

* EXPLOSION FRAME INDEX *
FXITBL:
          .dc.b      $0F                    ;GLIDER
          .dc.b      $12                    ;SCARAB
          .dc.b      $1D                    ;PING
          .dc.b      $25                    ;NEUFY

* POINT VALUE OF FLEAS *
FLSCORE:
          .dc.b      $1                     ;GLIDER
          .dc.b      $3                     ;SCARAB
          .dc.b      $2                     ;PING
          .dc.b      $5                     ;NEUFY

* ANIMATION SEQUENCES *
FLSHAPES:
          .dc.b      $0B                    ;0    FOLDED GLIDER
          .dc.b      $80                    ;GOTO 0
          .dc.b      $0A,$0A,$0A,$0A
          .dc.b      $09,$09,$09,$09
          .dc.b      $08                    ;A   GLIDER
          .dc.b      $8A                    ;GOTO A
          .dc.b      $0C                    ;C   BUZZING SCARAB
          .dc.b      $0D
          .dc.b      $8C                    ;GOTO C
          .dc.b      $07                    ;F   EXPLODING GLIDER
          .dc.b      $06
          .dc.b      $94                    ;GOTO 14
          .dc.b      $05                         ;EXPLODING SCARAB
          .dc.b      $04
          .dc.b      $03                    ;14
          .dc.b      $02                         ;GENERIC EXPLOSIONS
          .dc.b      $01
          .dc.b      $00                    ;DEATH
          .dc.b      $0E,$0E,$0F,$0F,$98    ;18 PING
          .dc.b      $10,$10,$10,$10        ;1D  PING EXPL
          .dc.b      $94                    ;GOTO 14
          .dc.b      $11,$12                ;22 DRAGFLY
          .dc.b      $A2                    ;GOTO 22
          .dc.b      $13,$13,$13,$13        ;25 DRAGFLY EXPL
          .dc.b      $94

* SHAPES *
FLSHPTBL:
          .dc.b      GENERXP2&$FF            ;1 NEXT TO DEATH
          .dc.b      GENERXP1&$FF            ;2
          .dc.b      GENERXP0&$FF            ;3
          .dc.b      SCRBEXP2&$FF            ;4
          .dc.b      SCRBEXP1&$FF            ;5
          .dc.b      GLIDEXP1&$FF            ;6
          .dc.b      GLIDEXP0&$FF            ;7
          .dc.b      GLIDER&$FF              ;8
          .dc.b      UNFOLD2&$FF             ;9
          .dc.b      UNFOLD1&$FF             ;A
          .dc.b      UNFOLD0&$FF             ;B
          .dc.b      SCARAB5&$FF             ;C
          .dc.b      SCARAB4&$FF             ;D
          .dc.b      PING1&$FF               ;E
          .dc.b      PING2&$FF               ;F
          .dc.b      PINGEXPL&$FF           ;10
          .dc.b      NEUFY1&$FF             ;11
          .dc.b      NEUFY2&$FF             ;12
          .dc.b      NEUFYXPL&$FF           ;13

* SHADOWS *
FLSHDTBL:
          .dc.b      GENERXP2&$FF            ;1 DEATH
          .dc.b      GENERXP1&$FF            ;2
          .dc.b      GENERXP0&$FF            ;3
          .dc.b      SCRBEXP2&$FF            ;4
          .dc.b      SCRBEXP1&$FF            ;5
          .dc.b      GLIDEXP1&$FF            ;6
          .dc.b      GLIDEXP0&$FF            ;7
          .dc.b      GLSHAD&$FF              ;8
          .dc.b      UNFOLD2&$FF             ;9
          .dc.b      UNFOLD1&$FF             ;A
          .dc.b      UNFOLD0&$FF             ;B
          .dc.b      SCARAB5&$FF             ;C
          .dc.b      SCARAB4&$FF             ;D
          .dc.b      PING1&$FF               ;E
          .dc.b      PING2&$FF               ;F
          .dc.b      PINGEXPL&$FF           ;10
          .dc.b      NEUFY1&$FF             ;11
          .dc.b      NEUFY2&$FF             ;12
          .dc.b      NEUFYXPL&$FF           ;13

** COLLISION DETECTION **
FLEADET:  LDA     XTBL+FLEADEX,Y         ;X
          STA     COLPX
          LDA     COLY1+FLEADEX,Y        ;Y - DELTA
          STA     COLPY
          LDA     ZTBL+FLEADEX,Y         ;Z
          STA     COLPZ
          LDX     FLITBL,Y               ;LOAD IN REAL INDEX
          JSR     COLDET
          BNE     AXPLO                  ;EXPLOSION IF NOT ZERO
;
          LDA     COLX1+FLEADEX,Y        ;X-DELTA
          STA     COLPX
          LDA     COLY2+FLEADEX,Y        ;Y+DELTA
          STA     COLPY
          LDA     COLZ2+FLEADEX,Y        ;Z+DELTA
          STA     COLPZ
          LDX     FLITBL,Y               ;LOAD REAL INDEX
          JSR     COLDET
          BNE     AXPLO                  ;NON-ZERO MEANS COLLISION
;
          LDA     COLX1+FLEADEX,Y        ;X+DELTA
          STA     COLPX
          LDX     FLITBL,Y
          JSR     COLDET
          BEQ     ENDFLDET               ;NON-ZERO MEANS COLLISION

AXPLO:
          LDX     FLEATYPE,Y
          LDA     FXITBL,X               ;LOOK UP EXPLOSION SEQUENCE START
          STA     FLEANIM,Y
          LDA     #0
          STA     FLEACNT,Y             ;FREEZE MOVEMENT
          STA     COLSTAT+FLEADEX,Y
          LDA     FLTUNE,X               ;JUST FOR JOHN, HONEST.
          JSR     TUNIN

ENDFLDET: RTS

KILLFLEA:                                ;CALL WITH FLEA INDEX IN A
          STX     TEMP2
          LDA     FLEATYPE-FLEADEX,X
          TAX
          LDA     FLTUNE,X
          JSR     TUNIN                  ;PLAY FLEA DEATH TUNE

          LDA     FLSCORE,X              ;DO SOME SCORING
          STA     HUNDS
          JSR     ADDSCORE
          JSR     ADDTRVAL               ;DO TREASURE VALUE UPDATE AS WELL

          LDA     FXITBL,X               ;LOOK UP EXPLOSION SEQ START
          LDX     TEMP2
          STA     FLEANIM-FLEADEX,X
          LDA     #0
          STA     FLEACNT-FLEADEX,X       ;FREEZE MOVEMENT
          STA     COLSTAT,X
          RTS

** FLEA MOVEMENT ROUTINE **
MOVEFLEA:
          LDX     #NFLS-1
MVFLOOP:
          LDA     FLEASTAT,X
          BEQ     FMNEXT

* Z COORDINATES *
          LDA     FZRUN,X
          SEC
          SBC     SCROLLS
          TAY
          CLC
          ADC     ZTBL+FLEADEX,X
          STA     ZTBL+FLEADEX,X
          CLC
          TYA
          ADC     ZTBL+FLSHDEX,X
          STA     ZTBL+FLSHDEX,X
          CLC
          TYA
          ADC     COLZ1+FLEADEX,X
          STA     COLZ1+FLEADEX,X
          CLC
          TYA
          ADC     COLZ2+FLEADEX,X
          STA     COLZ2+FLEADEX,X

* Y COORDINATES *
          LDY     FYRUN,X
          CLC
          TYA
          ADC     YTBL+FLEADEX,X
          CMP     #FLYLO                 ;BOUNDS CHECKS
          BCC     FMXCOORD
          CMP     #FLYHI
          BCS     FMXCOORD
          STA     YTBL+FLEADEX,X
          CLC
          TYA
          ADC     COLY1+FLEADEX,X
          STA     COLY1+FLEADEX,X
          CLC
          TYA
          ADC     COLY2+FLEADEX,X
          STA     COLY2+FLEADEX,X

* X COORDINATES *
FMXCOORD: LDY     FXRUN,X
          CLC
          TYA
          ADC     XTBL+FLEADEX,X
          CMP     #FLXLO                 ;BOUNDS CHECKS
          BCC     FMNEXT
          CMP     #FLXHI
          BCS     FMNEXT
          STA     XTBL+FLEADEX,X
          CLC
          TYA
          ADC     XTBL+FLSHDEX,X
          STA     XTBL+FLSHDEX,X
          CLC
          TYA
          ADC     COLX1+FLEADEX,X
          STA     COLX1+FLEADEX,X
          CLC
          TYA
          ADC     COLX2+FLEADEX,X
          STA     COLX2+FLEADEX,X

FMNEXT:   DEX
          BPL     MVFLOOP

** INTELLIGENTLY MOVE ONE OF THE FLEAS **
          LDA     MAINCNT
          AND     #$03                   ;INDEX OF FLEA
          TAX
          LDA     FLEASTAT,X
          BEQ     FMVCPL
          JSR     FDSPATCH
FMVCPL:   TXA
          ORA     #4
          TAX
          LDA     FLEASTAT,X
          BNE     FDSPATCH
FMRTS:    RTS

** ATTACK INTERPRETER **
FDSPATCH:
          LDY     FLEACNT,X
          LDA     MT,Y
          INC     FLEACNT,X
          STA     TEMP0
          LSR     
          LSR     
          LSR     
          LSR     
          TAY
          LDA     TEMP0
          AND     #$F
          STA     TEMP0
          LDA     FJMPLO,Y
          STA     PTR0
          LDA     FJMPHI,Y
          STA     PTR0+1
          JMP     (PTR0)

*** INSTRUCTION SET FOR FLEA MOVEMENT INTERPRETER ***

** STX    SET X TO BE THE LOW NIBBLE **
FSTX:
          LDA     TEMP0
          CMP     #8
          BCC     FSTX1
          ORA     #$F0
FSTX1:    STA     FXRUN,X
          JMP     FDSPATCH

** STY    SET Y TO BE THE LOW NIBBLE **
FSTY:
          LDA     TEMP0
          CMP     #8
          BCC     FSTY1
          ORA     #$F0
FSTY1:    STA     FYRUN,X
          JMP     FDSPATCH

** STZ    SET Z TO BE THE LOW NIBBLE **
FSTZ:
          LDA     TEMP0
          CMP     #8
          BCC     FSTZ1
          ORA     #$F0
FSTZ1:    STA     FZRUN,X
          JMP     FDSPATCH

** HBX    HOME TOWARDS BIRD IN X DIRECTION **
FHBX:
          LDA     NOHOMING
          BNE     FHBX0
          LDA     XTBL+ZBIRD
FHBX0:    SEC                            ;CALC COORD DIFFERENCE
          SBC     XTBL+FLEADEX,X
          ADC     #5
          BMI     FHBXDEC                ;FL>BD, DEC FLEA
          CMP     #10
          BCC     FHBXNIL
          LDA     TEMP0
          BNE     FHBX1
FHBXDEC:  SEC
          LDA     #0
          SBC     TEMP0
          BNE     FHBX1
FHBXNIL:  LDA     #0
FHBX1:    STA     FXRUN,X
          JMP     FDSPATCH

** HBY    HOME TOWARDS BIRD IN Y DIRECTION **
FHBY:
          LDA     NOHOMING
          LSR     
          BNE     FHBY0
          LDA     YTBL+ZBIRD
FHBY0:    SEC
          SBC     YTBL+FLEADEX,X
          ADC     #5
          BMI     FHBYDEC                ;FL>BD, DEC FLEA
          CMP     #10
          BCC     FHBYNIL
          LDA     TEMP0
          BNE     FHBY1
FHBYDEC:  SEC
          LDA     #0
          SBC     TEMP0
          BNE     FHBY1
FHBYNIL:  LDA     #0
FHBY1:    STA     FYRUN,X
          JMP     FDSPATCH

** RTS    RETURN FROM INTERPRETER **
FRTS:
          RTS

** CYC    CYCLE BACK N STEPS **
FCYC:     LDA     FLEACNT,X
          CLC                            ;SUBT ONE MORE
          SBC     TEMP0
          STA     FLEACNT,X
          JMP     FDSPATCH

** LAN    LOAD ANIMATION INDEX WITH X **
FLAN:
          LDA     TEMP0
          STA     FLEANIM,X
          JMP     FDSPATCH

** DIS    IF Z WITHIN A CERTAIN DISTANCE, JUMP **
FDIS:     LDY     TEMP0
          LDA     FDISTBL,Y
          CMP     ZTBL+FLEADEX,X
          BCC     FDIS1
          LDY     FLEACNT,X
          LDA     MT,Y
          STA     FLEACNT,X
          JMP     FDSPATCH
FDIS1:    INC     FLEACNT,X
          JMP     FDSPATCH

** RND    JUMP WITH PROBABILITY 1/ARG **
FRND:     JSR     RANDOM
          AND     TEMP0
          BEQ     FJMP
          INC     FLEACNT,X
          JMP     FDSPATCH

** JMP    UNCONDITIONAL JUMP **
FJMP:
          LDY     FLEACNT,X
          LDA     MT,Y
          STA     FLEACNT,X
          JMP     FDSPATCH

** SPN    SPAWN A NEW FLEA **
FSPN:
          LDA     TEMP0                  ;X = CLASS OF SPAWNED FLEA
          STA     SPNCLASS
          LDA     NUMFLEAS
          BEQ     FSPNEND                ;ARE THERE ANY AVAIL FLEAS?
* FIX POSITION *
          LDA     XTBL+FLEADEX,X
          STA     SPNX
          LDA     YTBL+FLEADEX,X
          STA     SPNY
          LDA     ZTBL+FLEADEX,X
          ADC     #12
          STA     SPNZ
          JSR     SPAWN
FSPNEND:
          JMP     FDSPATCH

FJMPLO:   .dc.b      FSTX&$FF,FSTY&$FF,FSTZ&$FF,FRTS&$FF
          .dc.b      FHBX&$FF,FHBY&$FF,FCYC&$FF,FDIS&$FF
          .dc.b      FSPN&$FF,FLAN&$FF,FJMP&$FF,FRND&$FF

FJMPHI:   .dc.b      FSTX/256,FSTY/256,FSTZ/256,FRTS/256
          .dc.b      FHBX/256,FHBY/256,FCYC/256,FDIS/256
          .dc.b      FSPN/256,FLAN/256,FJMP/256,FRND/256

MSTX     EQU     0
MSTY     EQU     $10
MSTZ     EQU     $20
MRTS     EQU     $30
MHBX     EQU     $40
MHBY     EQU     $50
MCYC     EQU     $60
MDIS     EQU     $70
MSPN     EQU     $80
MLAN     EQU     $90
MJMP     EQU     $A0
MRND     EQU     $B0

TARLOAD:
          .dc.b      MGLID1-MT,MGLID2-MT,MGLID3-MT,MGLID4-MT
          .dc.b      MSCAB1-MT,MSCAB2-MT,MSCAB3-MT,MSCAB4-MT
          .dc.b      MPING1-MT,MPING2-MT,MPING3-MT,MPING4-MT
          .dc.b      MDRAG1-MT,MDRAG2-MT,MDRAG3-MT,MDRAG4-MT
TARPW:
          .dc.b      $9D,$BD,$DD,$1D,$9D,$BD,$DD,$1D
          .dc.b      $9D,$BD,$DD,$1D,$9D,$BD,$DD,$1D    ;PALWIDTH FOR FLEAS
TARTYPE:
          .dc.b      $00,$00,$00,$00,$01,$01,$01,$01
          .dc.b      $02,$02,$02,$02,$03,$03,$03,$03

* DISTANCE TABLE *
FDISTBL:  .dc.b      $B0,$A0,$90,$80

MIGLID1  EQU     0
MISCAB1  EQU     4
MIPING1  EQU     8
MIDRAG3  EQU     $E

*** MOVEMENT TABLE ***
MT:
MEXPL:    .dc.b      (MSTZ+$0)&$FF,(MSTY+$0)&$FF,(MSTX+$0)&$FF
	  .dc.b	     (MRTS)&$FF,(MCYC+$1)&$FF
MGLID1P:  .dc.b      (MLAN+$2)&$FF,(MSTZ+$F)&$FF,(MRTS)&$FF,(MCYC+$1)&$FF
MGLID1:   .dc.b      (MSTZ+$E)&$FF,(MDIS+1)&$FF,(MGLID1P-MT)&$FF
	  .dc.b	     (MRTS)&$FF,(MCYC+$3)&$FF
MGLID2P:  .dc.b      (MLAN+$2)&$FF,(MSTZ+$F)&$FF
          .dc.b      (MSTY+$1)&$FF,(MRTS)&$FF,(MRTS)&$FF,(MSTY+$F)&$FF
	  .dc.b	     (MRTS)&$FF,(MRTS)&$FF,(MCYC+$6)&$FF
MGLID2:   .dc.b      (MSTZ+$E)&$FF,(MDIS+3)&$FF,(MGLID2P-MT)&$FF
	  .dc.b      (MHBY+$1)&$FF,(MRTS)&$FF,(MCYC+$4)&$FF
MGLID3P:  .dc.b      (MLAN+$2)&$FF,(MSTZ+$D)&$FF,(MRTS)&$FF,(MSTZ+$E)&$FF
          .dc.b      (MHBY+$1)&$FF,(MRTS)&$FF,(MCYC+$2)&$FF
MGLID3:   .dc.b      (MSTZ+$D)&$FF,(MDIS+2)&$FF,(MGLID3P-MT)&$FF
	  .dc.b      (MHBY+$2)&$FF,(MRTS)&$FF,(MCYC+$4)&$FF
MGLID4P:  .dc.b      (MLAN+$2)&$FF,(MSTZ+$D)&$FF,(MRTS)&$FF,(MSTZ+$E)&$FF
          .dc.b      (MSTY+$1)&$FF,(MRTS)&$FF,(MHBY+$1)&$FF,(MRTS)&$FF
          .dc.b      (MSTY+$F)&$FF,(MRTS)&$FF,(MHBY+$1)&$FF,(MRTS)&$FF
	  .dc.b      (MCYC+$8)&$FF
MGLID4:   .dc.b      (MSTZ+$D)&$FF,(MDIS+0)&$FF,(MGLID4P-MT)&$FF
	  .dc.b      (MHBY+$1)&$FF,(MRTS)&$FF,(MCYC+$4)&$FF

MPING1:   .dc.b      (MSTZ+$F)&$FF,(MHBX+$1)&$FF,(MHBY+$1)&$FF
	  .dc.b      (MRTS)&$FF,(MCYC+$3)&$FF
MPING2:   .dc.b      (MHBY+$1)&$FF,(MSTX+$2)&$FF,(MRTS)&$FF,(MRTS)&$FF
          .dc.b      (MHBY+$1)&$FF,(MSTX+$E)&$FF,(MRTS)&$FF,(MRTS)&$FF
	  .dc.b      (MCYC+$8)&$FF
MPING3:   .dc.b      (MDIS+$2)&$FF,(MPING1-MT)&$FF,(MRTS)&$FF,(MCYC+$3)&$FF
MPING4:   .dc.b      (MSTZ+$E)&$FF,(MHBY+$1)&$FF,(MHBX+$2)&$FF,(MRTS)&$FF
          .dc.b      (MHBY+$2)&$FF,(MSTX+$1)&$FF,(MRTS)&$FF
          .dc.b      (MHBY+$2)&$FF,(MSTX+$F)&$FF,(MRTS)&$FF
          .dc.b      (MHBY+$2)&$FF,(MRTS)&$FF,(MCYC+$B)&$FF

MSCAB1A:	.dc.b	(MSTZ+$0)&$FF,(MSTY+$0)&$FF,(MSTX+$0)&$FF,MRTS&$FF
		.dc.b	MRTS&$FF,MRTS&$FF,MRTS&$FF,MJMP&$FF,(MPING1-MT)&$FF
MSCAB1:		.dc.b	(MSTZ+$F)&$FF,(MDIS+1)&$FF,(MSCAB1A-MT)&$FF
		.dc.b	MRTS&$FF,(MCYC+$3)&$FF
MSCAB2A:	.dc.b	(MSTZ+$0)&$FF,(MSTY+$0)&$FF,(MSTX+$0)&$FF,MRTS&$FF
		.dc.b	MRTS&$FF,MRTS&$FF,MJMP&$FF,(MPING4-MT)&$FF
MSCAB2:		.dc.b	(MSTZ+$F)&$FF,(MDIS+2)&$FF,(MSCAB2A-MT)&$FF
		.dc.b	(MHBX+$1)&$FF,MRTS&$FF,(MCYC+$4)&$FF
MSCAB3A:	.dc.b	(MSTZ+$0)&$FF,(MSTX+$0)&$FF
		.dc.b	(MHBY+$2)&$FF,MRTS&$FF,(MSTY+$E)&$FF,MRTS&$FF
		.dc.b	(MSTZ+$E)&$FF,(MHBX+$2)&$FF,(MHBY+$1)&$FF
		.dc.b	(MRTS)&$FF,(MCYC+$3)&$FF
MSCAB3:		.dc.b	(MDIS+$1)&$FF,(MSCAB3A-MT)&$FF,(MSTX+$1)&$FF
		.dc.b	(MRTS)&$FF,(MSTX+$F)&$FF,(MRTS)&$FF,(MCYC+$6)&$FF
MSCAB4A:  	.dc.b	(MSTZ+$0)&$FF,(MSTY+$1)&$FF,(MSTX+$1)&$FF,MRTS&$FF
          	.dc.b	(MSTY+$F)&$FF,MRTS&$FF,(MSTX+$F)&$FF,MRTS&$FF
		.dc.b	(MSTY+$0)&$FF
		.dc.b	MRTS&$FF,(MSTX+$0)&$FF
	    	.dc.b	MRTS&$FF,(MSTZ+$D)&$FF,(MHBY+$4)&$FF,(MHBX+$4)&$FF
		.dc.b	MRTS&$FF
	    	.dc.b	(MHBY+$2)&$FF,(MHBX+$2)&$FF,MRTS&$FF,(MCYC+$3)&$FF
MSCAB4:   	.dc.b	(MSTZ+$F)&$FF,(MDIS+1)&$FF,(MSCAB4A-MT)&$FF
		.dc.b	MRTS&$FF,(MCYC+$3)&$FF

MDRAG1A:  .dc.b      (MSTZ+$0)&$FF,(MSTY+$0)&$FF,(MSTX+$0)&$FF,MRTS&$FF
          .dc.b      MRTS&$FF,(MSPN+MISCAB1)&$FF
          .dc.b      (MSTZ+$E)&$FF,MJMP&$FF,(MPING2-MT)&$FF
MDRAG1:   .dc.b      (MSTZ+$F)&$FF,(MDIS+0)&$FF,(MDRAG1A-MT)&$FF
	  .dc.b	     MRTS&$FF,(MCYC+$3)&$FF
MDRAG2A:  .dc.b      (MSTZ+$0)&$FF,(MSTX+$0)&$FF,MRTS&$FF
;         .dc.b      (MSTY+$F)&$FF,MRTS&$FF,(MSTY+$1)&$FF,MRTS&$FF
          .dc.b      (MSTY+$F)&$FF,MRTS&$FF,(MSTY+$1)&$FF,MRTS&$FF
	  .dc.b      (MSPN+MIGLID1)&$FF
MDRAG2:   .dc.b      (MSTZ+$E)&$FF,(MSTX+$2)&$FF,MRTS&$FF,MRTS&$FF
          .dc.b      (MSTX+$E)&$FF,MRTS&$FF,MRTS&$FF
	  .dc.b      (MRND+$1)&$FF,(MDRAG2A-MT)&$FF,(MCYC+$8)&$FF
MDRAG3A:  .dc.b      (MSTZ+$0)&$FF,(MSTY+$0)&$FF,(MSTX+$0)&$FF,MRTS&$FF
          .dc.b	     MRTS&$FF,MRTS&$FF,MRTS&$FF
	  .dc.b	     (MSPN+MIDRAG3)&$FF,MJMP&$FF,(MPING4-MT)&$FF
MDRAG3:   .dc.b      (MSTZ+$F)&$FF,(MDIS+1)&$FF,(MDRAG3A-MT)&$FF
	  .dc.b      MRTS&$FF,(MCYC+$3)&$FF
MDRAG4A:  .dc.b      (MSPN+MIPING1)&$FF,MRTS&$FF
MDRAG4:   .dc.b      (MSTZ+$D)&$FF,(MRND+$1)&$FF,(MDRAG4A-MT)&$FF
	  .dc.b      MRTS&$FF,(MCYC+$3)&$FF

*******************************************
**        UWE    ENEMY DRIVER            **
*******************************************
UWEOFFH  EQU     2
UWEOFFV  EQU     -13

NOUWE    EQU     0                      ;NO UWE AT ALL
WCTRLFL  EQU     TEMP8

** INITIALIZE A UWE **
DOUWE:
	jmp	.enter
	LDY	#NFLS-1			;CAN'T BE ANY FLEAS FOR NEW UWE.
.LOP1:	LDA	FLEASTAT,Y		;CHECK FOR AVAIL FLEA
	ORA	FLEASTAT+NFLS,Y
	BNE	.EXIT1			;EXIT IF FLEA FOUND.
	DEY
	BPL	.LOP1
.enter:
	LDX     #UWEDEX+2		;LOOK FOR AVAILABLE UWE
.LOP2:	LDA     UWESTATE-UWEDEX,X	;THIS USED TO LOOK FOR VPTBL = TO
	BEQ     THISISX			;SCREENBOT+1.  NOW LOOKS FOR ZERO
	DEX				;UWESTATE
	CPX     #UWEDEX			;WE CAN PROBABLY PUNT THIS SCREENBOT+1
	BCS	.LOP2			;SHIT AT THIS POINT
;
.EXIT1:	LDA	#$00			;TELLS JOHN NOT TO DO UWES
	STA	UWEOK
	RTS

THISISX:

          TXA                            ;IS THIS LAST UWE
          CMP     #UWEDEX
          BNE     TISX
          LDA     #$00
          STA     UWEOK

* INITIALIZE COORDS *
TISX:     JSR     RANDOM                 ;RANDOM X FOR UWE
          AND     #$3F
          ADC     #58
          STA     XTBL,X
          LDA     #5                     ;AND 5 Y
          STA     YTBL,X
          JSR     RANDOM                 ;AND SOME RANDOM DISTANCE IN FRONT
          AND     #$1F
          ADC     ZTBL+ZBIRD
          ADC     #50
          STA     ZTBL,X

          LDA     #200                   ;HP SHOULD BE OFF SCREEN
          STA     HPTBL,X
          JSR     UWEVP                  ;DO THE VP
          STA     VPTBL,X

* INITIALIZE COLLISION DATA *
          LDA     XTBL,X                 ;THESE COLLISION PARAMETERS ARE
          SEC                            ;GUESSES
          SBC     #4
          STA     COLX1,X
          CLC
          ADC     #8
          STA     COLX2,X
          LDA     #1
          STA     COLY1,X
          LDA     #17
          STA     COLY2,X
          LDA     ZTBL,X
          STA     COLZ1,X
          CLC
          ADC     #10
          STA     COLZ2,X

* INITIAL STATE *
          JSR     RANDOM
          AND     #1
          STA     UWETYPE-UWEDEX,X
          LDA     #$DC                   ;PAL AND WIDTH
          STA     PWTBL,X

          LDA     #1                     ;START UNDERGROUND
          JSR     WSTINIT
          JSR     UWEDX
          JSR     OBJINS
          RTS
;
;  IN:	A = 1 to start uwe underground.
;	  = 7 to blow-up uwe up.
;	X = index to uwe.
;
WSTINIT:
          STA     UWESTATE-UWEDEX,X
          TAY
          LDA     WCOLST-1,Y
          STA     COLSTAT,X
;
          LDA     WSTST-1,Y
          STA     WANIMCNT-UWEDEX,X
          TAY
          LDA     UWESH,Y
          ORA     #$80
          STA     SHTBL,X
          LDA     UWESL,Y
          STA     SLTBL,X

          RTS
;
;
;=====================================
;	UWE ANIMATION ROUTINE.
;=====================================
;
UWEANIM:
	LDX	#UWEDEX+2
.loop:	LDA	UWESTATE-UWEDEX,X
	beq	.next			;Is there a Uwe to handle?
	jsr	.handleUwe
.next:	dex
	cpx	#UWEDEX
	bcs	.loop
	rts
;
;
; = = = = = = = = = = = = = = = = 
;	Uwe handler routine.
; = = = = = = = = = = = = = = = = 
;
;   IN:	x = uwe's index.
;
.handleUwe:
	JSR	UWEMOVE			;MOVE UWES
	JSR	UWECOLD			;DO COLLISION DETECTION
;
;
; --- UWE ANIMATION ---------------------------------------
;
	LDA	#0			;Clear control flag.
	STA	WCTRLFL
;
	LDA	MAINCNT			;Frame counter.
	AND	#$03			;Time to change state?
	BNE	.projection
;
;
; --- Map Uwe's state to graphic image --------------------
;
	LDY	WANIMCNT-UWEDEX,X	;Get the animation count.
	LDA	ZTBL,X
	CMP	#30			;Off bottom of screen?
	bcs	.ok
.toKill:
	jmp	.removeUwe
.ok:

	LDA	UWESH,Y			;LOAD HIGH BYTE OF STAMP
	BEQ	.toKill			;Time to remove the desd Uwe?
	BMI	.skip2
;
	ORA	#$80			;END OF SEQUENCE FLAG
	STA	WCTRLFL			;CONTROL SHOULD CHANGE ANIMCNT
;
.skip2:	STA	SHTBL,X
	LDA	UWESL,Y
	STA	SLTBL,X
	INC	WANIMCNT-UWEDEX,X	;UPDATE ANIMCNT
;
;
; --- Compute Uwe's projection ----------------------
;
.projection:
	JSR	UWEHP
	STA	HPTBL,X
;
	JSR	UWEVP
	STA	VPTBL,X
;
	JSR	UWEDX
;
	JSR	OBJMOV			;MOVE HIM IN LINKED LIST
;
	LDA	UWESTATE-UWEDEX,X
	CMP	#7
	BEQ	.exit
;
;
; --- GROUND TYPE CHECK --------------------
;
	LDY	UWESTATE-UWEDEX,X
	LDA	WCGTBL,Y		;FIND OUT WHAT TO CHECK
	BEQ	.control
;
	LDA	#0
	JSR	GRNDTYPE
	CMP	#78			;EMPIRICALLY DETERMINED
	BCS	.water
	LDA	WGTRANS,Y		;GROUND TYPE TRANSITION
	BNE	.storeState
	BEQ	.control
;
.water:	LDA	WWTRANS,Y		;WATER TYPE TRANSITION
	BNE	.storeState
;
;
; --- UWE CONTROL ----------------------------------------
;
.control:
	LDA	WCTRLFL
	BEQ	.exit
;
	LDA	#UWERUN
	JSR	SCRAPONE
;
	LDA	UWESTATE-UWEDEX,X
	SEC
	SBC	#1			;TAKE OUT NULL
	ASL	
	ASL	
	STA	TEMP9
;
;
; --- CALCULATE CHANGE INDEX (0-3) -----------------------
;
	LDY	UWETYPE-UWEDEX,X
	LDA	WHOMEP,Y
	BEQ	.random
;
	LDA	NOHOMING
	BNE	.ok1
	LDA	XTBL+ZBIRD
.ok1:	SEC
	SBC	XTBL,X
	ADC	#8
	BMI	.right			;BIRD IS ON UWE'S RIGHT
;
	CMP	#16
	BCC	.one
;
	LDA	#3
	BNE	.ok2
;
.right:	LDA	#2
	BNE	.ok2
;
.one:	LDA	#1
	BNE	.ok2
;
.random:
	JSR	RANDOM			;PICK RND OF FOUR POSSIBLE STATES
	AND	#3
.ok2:	ORA	TEMP9
	TAY
	LDA	WNEWST,Y
.storeState:
	STA	UWESTATE-UWEDEX,X	;NEW STATE ESTABLISHED
	TAY
	LDA	WCOLST-1,Y
	STA	COLSTAT,X
	LDA	WSTST-1,Y
	STA	WANIMCNT-UWEDEX,X	;NEW ANIMATION ESTABLISHED
;
.exit:	rts
;
;
;=========================================
;	DELETE UWE AND CLEAR STATE.
;=========================================
;
;   IN:	x = uwe index.
;
.removeUwe:
;KLUWE:
	JSR	OBJDEL			;Remove uwe's object.
	LDA	#$80
	STA	UWEOK
;
	LDA	#0			;Mark uwe as gone.
	STA	UWESTATE-UWEDEX,X
;
	LDA	#SCRENBOT+1
	STA	VPTBL,X
;
	LDA	#UWERUN			;Something about tunes.
	JSR	SCRAPONE
	rts
;
;

* TRANSITIONS - NEW STATES *
WCGTBL:	 ;'CHECK GROUND?' TABLE
	.dc.b	 0,1,1,1,1,0,0	;UWESTATES 0-6  1=YES 0=NO
WGTRANS:	;GROUND TYPE TRANSITIONS
	.dc.b	 0,6,0,0,0,0,0	;UNDERGROUND TO RISING
WWTRANS:	;WATER TYPE TRANSITIONS
	.dc.b	 0,0,5,5,5,0,0	;RUNNING TO DIVING

WNEWST:	;0 1 2 3 CONTROL
	.dc.b	 1,1,1,1		 ;UNDER
	.dc.b	 2,2,3,4		 ;! RUN
	.dc.b	 3,2,3,4		 ;/ RUN
	.dc.b	 4,2,3,4		 ;\ RUN
	.dc.b	 1,1,1,1		 ;BURY
	.dc.b	 2,2,2,2		 ;RISE

* MOVEMENTS *
WZMOV:    .dc.b	 0,$FF,$FE,$FF,$FF,0,0,0
WXMOV:    .dc.b	 0,0,0,$FF,1,0,0,0
WLIMCTRL: .dc.b	 0,1,2,2,2,5,6,7

WHOMEP:   .dc.b	 0,1		;TYPE TO WHETHER IT HOMES

* COLSTATS *
WCOLST:   .dc.b	 0,UWECOL,UWECOL,UWECOL,UWECOL,UWECOL,UWECOL

* STATE STARTS *
WSTST:    .dc.b	 19		 ;UNDERGROUND
	.dc.b	 0		  ;STRAIGHT
	.dc.b	 2		  ;RIGHT
	.dc.b	 4		  ;LEFT
	.dc.b	 6		  ;BURY
	.dc.b	 9		  ;RISE
	.dc.b	 13		 ;EXPLODE

UWESL:    .dc.b	 EWERUN1&$FF,EWERUN2&$FF		 ;STRAIGHT 0
	.dc.b	 EWERITE1&$FF,EWERITE2&$FF		    ;RIGHT    2
	.dc.b	 EWELEFT1&$FF,EWELEFT2&$FF		    ;LEFT	4
	.dc.b	 EWEDIG3&$FF,EWEDIG2&$FF,EWEDIG1&$FF	;BURY	6
	.dc.b	 EWEDIG1&$FF,EWEDIG2&$FF,EWEDIG3&$FF	;RISE	9
	.dc.b	 EWEJUMP&$FF
	.dc.b	 UWEEXPL1&$FF,UWEEXPL2&$FF		    ;EXPLODE 13
	.dc.b	 GENERXP0&$FF,GENERXP1&$FF,GENERXP2&$FF,0
	.dc.b	 UWEBLANK&$FF

* HIGH BYTE TABLE DOUBLES AS CONTROL *
UWESH:    .dc.b	 EWERUN1/256,$40
	.dc.b	 EWERITE1/256,$40
	.dc.b	 EWELEFT1/256,$40
	.dc.b	 EWEDIG3/256,EWEDIG2/256,$40
	.dc.b	 EWEDIG1/256,EWEDIG2/256,EWEDIG3/256
	.dc.b	 $40
	.dc.b	 UWEEXPL1/256,UWEEXPL2/256
	.dc.b	 GENERXP0/256,GENERXP1/256,GENERXP2/256,0
	.dc.b	 $40


*	    HPDO: HP CALCULATE ROUTINE
;THE CONSTANTS IN THIS ROUTINE ARE RUMORED TO BE CLOSE
UWEHP:    LDA	XTBL,X
	SEC
	SBC	#126-UWEOFFH
	CLC
	ADC	ZTBL,X
	RTS

*	    VPDO: VP CALCULATE ROUTINE
UWEVP:    LDA	XTBL,X
	SEC
	SBC	ZTBL,X
	CLC
	ADC	#126+UWEOFFV
	SEC
	SBC	YTBL,X
	RTS

*	    DXDO: DX CALCULATE ROUTINE
UWEDX:    LDA	ZTBL,X
	SEC
	SBC	XTBL,X
	CLC
	ADC	#NUMBER+10+DXADJ	  ; THIS IS DF
	STA	TEMP10
	SEC
	SBC	#12		; THIS IS DC
	STA	TEMP6
	RTS


KILLUWE:
	STX	TEMP9
	LDA	#1		 ;SCORE SOME MEGA POINTS
	STA	HUNDS
	LDA	#$50
	STA	TENS
	JSR	ADDSCORE
	JMP	WSTEXPL2


** UWE MOVEMENT **			
UWEMOVE:
	LDY	UWESTATE-UWEDEX,X
	LDA	WZMOV,Y
	SEC
	SBC	SCROLLS
	STA	TEMP9
	BEQ	WXMOVEM

	LDA	#UWERUN
	CMP	TUNNUM
	BEQ	.ok1
	CMP	TUNNUM+1
	BEQ	.ok1
	JSR	TUNIN
.ok1:
	LDA	TEMP9
	TAY
	CLC
	ADC	ZTBL,X
	STA	ZTBL,X

	TYA
	CLC
	ADC	COLZ1,X
	STA	COLZ1,X

	TYA
	CLC
	ADC	COLZ2,X
	STA	COLZ2,X

WXMOVEM:  LDY	UWESTATE-UWEDEX,X
	LDA	WXMOV,Y
	BEQ	WMOVEND
	BMI	WXDEC
WXINC:
	LDA	XTBL,X
	CMP	#FLXHI
	BCS	WSTRAIT
WXINC1:   INC	XTBL,X
	INC	COLX1,X
	INC	COLX2,X
	JMP	WMOVEND
WXDEC:
	LDA	XTBL,X
	CMP	#FLXLO
	BCC	WSTRAIT
WXDEC1:   DEC	XTBL,X
	DEC	COLX1,X
	DEC	COLX2,X
	JMP	WMOVEND

WSTRAIT:  LDA	WLIMCTRL-1,Y
	JSR	WSTINIT

WMOVEND:
	RTS

** COLLISION DETECTION WITH OBJECTS OTHER THAN SHOTS AND BIRD ***
UWECOLD:
	LDA	UWESTATE-UWEDEX,X
	CMP	#7
	BEQ	WNOCOL1

	STX	TEMP9
	LDA	ZTBL,X
	CLC
	ADC	#2
	STA	COLPZ
	LDA	#5
	STA	COLPY
	LDA	XTBL,X
	CLC
	ADC	#4
	STA	COLPX
	JSR	COLDET
;	jmp	WSTEXPL2		;!!!!!!!Always blowup uwes!!!!DEBUG!!
	BNE	WSTEXPL2
	LDX	TEMP9

WNOCOL0:

	LDA	XTBL,X
	SEC
	SBC	#4
	STA	COLPX
	JSR	COLDET
	BNE	WSTEXPL2
	LDX	TEMP9
WNOCOL1:
	RTS

WSTEXPL2:
	LDX	TEMP9
;
	LDA	#7			;Start uwe explosion.
	JSR	WSTINIT			;!!!!!!!!!
;
	LDA	#UWEEXP
	JSR	TUNIN
;
	LDX	TEMP9
	RTS
;
;

** REMOVE ALL ON SCREEN ENEMIES AFTER BIRD DEATH **
CLEAN:
	LDY	#FLEADEX+15
FLEADELP: LDA	FLEASTAT-FLEADEX,Y
	CMP	#1
	BNE	NEXTXOX		 ;IF FLEA NOT ON SCREEN, NEXT FLEA

	LDA	FLITBL-FLEADEX,Y
	TAX

	JSR	OBJDEL

NEXTXOX:  LDA	#0
	STA	FLEASTAT-FLEADEX,Y

	DEY
	CPY	#FLEADEX
	BCS	FLEADELP

	LDA	#0
	STA	NOHOMING
	LDA	#8
	STA	NUMFLEAS

* CLEAN OUT UWES *
	LDX	#UWEDEX+2
UWEDELP:  LDA	UWESTATE-UWEDEX,X
	BEQ	NEXTOXO

	JSR	OBJDEL

NEXTOXO:
	LDA	#0
	STA	UWESTATE-UWEDEX,X

	LDA	#SCRENBOT+1
	STA	VPTBL,X

	DEX
	CPX	#UWEDEX
	BCS	UWEDELP

	LDA	#$80
	STA	UWEOK

	RTS

** KILL ALL FLEAS - ALIAS SMART BOMB **
KAFLEAS:
	LDX	#FLEADEX+NFLS-1
FLPOW:				;KILL EACH FLEA
	LDA	FLEASTAT-FLEADEX,X
	BEQ	FLPOWNXT
	JSR	KILLFLEA

FLPOWNXT: DEX
	CPX	#FLEADEX
	BCS	FLPOW
	RTS

** KILL ALL UWES **
KAUWES:
	LDX	#UWEDEX+2
UWPOW:				;KILL EACH UWE
	LDA	UWESTATE-UWEDEX,X
	BEQ	UWPOWNXT
	JSR	KILLUWE

UWPOWNXT: DEX
	CPX	#UWEDEX
	BCS	UWPOW
	RTS

*** FREEZE FLEAS ***
FRFLEAS:
	LDX	#NFLS-1
FLFRZ:				;FREEZE EACH FLEA
	LDA	#MEXPL-MT
	STA	FLEACNT,X

FLFRZNXT: DEX
	BPL	FLFRZ
	RTS

;	END

