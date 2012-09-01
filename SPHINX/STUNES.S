*******************************************************************************
*
*         STUNES.S      by Kevin G. Osborn
*         ADAPTED FOR SPHINX --- A GAME OF SKILL AND CHANCE
*         Contains subroutines
*                 TUNER
*                 SCRAPALL
*                 SCRAPONE
*                 TUNIN
*******************************************************************************
********************************************************************************
* SIMPSONG VERSION 0.035
*
* THIS SIMPLE SOUND DRIVER HAS, IN SOME WAYS, FEWER FEATURES BUT USES LESS RAM
* AND ROM AND DOES NOT BACK UP SOUNDS FOR LATER (SOMETIMES MUCH LATER)
* CONTINUATION. IT FEATURES 256 NOTE TUNES, SINGLE DURATION PER TUNE, ENDLESS
* TUNES. IF A VALUE IN THE CONTROL OR VOLUME TABLES HAS THE HIGH BIT SET, THAT
* VOLUME OR CONTROL WILL REMAIN IN EFFECT TILL THE END OF THE TUNE.
* AN FF IN THE FREQUENCY TABLE WILL TERMINATE THE TUNE, AN FE WILL CAUSE IT TO
* RESTART.  AN FD WILL DECREMENT TUNREPT.  IF THIS IS NON-ZERO, THE TUNE
* CONTINUES.  IF IT IS ZERO, THE NEXT BYTE IN FREQ. TABLE IS S TUNE WHICH
* SHOULD BE CALLED.  TUNREPT IS SET IN TUNIN.
*
* AS A NEW WHIZZY FEATURE, TUNER ALSO SUPPORTS RESTS. IF BIT 6 IS SET (NOT BIT 7
* ALSO) IN A FREQUENCY TABLE ENTRY, IT SILENCES SOUND IN THAT CHANNEL FOR THE
* NUMBER OF FRAMES INDICATED IN THE REMAINING 5 BITS.
*
* NOTE ALSO THAT IN THIS VERSION A DURATION OF 1 INDICATES CHANGING SOUND EVERY
* FRAME. THIS IS A CHANGE OVER VERSION .03 WHERE 0 INDICATED ONCE PER FRAME
* SAMPLING.
* SUBROUTINES:
*     SCRAPALL -- KILL ALL TUNES. SHOULD BE CALLED AT POWERUP, CHANGING PLAYERS,
*                AND GAME OVER
*
*     SCRAPONE -- KILL A PARTICULAR TUNE. PUT THE NUMBER OF THE TUNE YA WANNA
*                 AXE IN THE ACCUMULATOR.
*
*     TUNIN   --  START THAT TUNE YOU PUT IN ACC.
*
* THE ABOVE ROUTINES PRESERVE THE X AND Y REGS
*
* TABLES NEEDED ARE:
* RAM:
*DCH0      .ds.b     1                      ONE BYTE--DURATION CNTR CHAN. 0
*DCH1      .ds.b     1                      ONE BYTE--DURATION CNTR CHAN. 1
*TUNNUM    .ds.b     1                      ONE BYTE--TUNE NUM FOR CHAN. 0
*TUNNUM1   .ds.b     1                      ONE BYTE--TUNE NUM FOR CHAN. 1
*TINDEX0   .ds.b     1                      ONE BYTE--NOTE POINTER 0
*TINDEX1   .ds.b     1                      ONE BYTE--NOTE POINTER 1
*CINDEX0   .ds.b     1                      CONTROL INDEX
*CINDEX1   .ds.b     1
*VINDEX0   .ds.b     1                      VOLUME INDEX
*VINDEX1   .ds.b     1
*TUNREPT0  .ds.b     1                      TUNE REPEAT COUNTER
*TUNREPT1  .ds.b     1
*MPTRL     EQU     KTEMP0                 ZERO PAGE TEMP(NOT GAMEPLAY)
*MPTRH     EQU     KTEMP1                 ZERO PAGE TEMP(NOT GAMEPLAY)
*TUNTEMP   EQU     TEMP0                  ANY GAMEPLAY TEMP
* ROM:
*   DURTABL       ONE DURATION IN FRAMES PER TUNE
*   TBASE         LOW ADDRESS OF THE START OF FREQ DATA BY TUNE NUMBER
*   TBASEH        DITTO FOR HIGH ADDRESS
*   VBASE         LOW ADDRESS OF THE START OF VOL DATA BY TUNE NUMBER
*   VBASEH        DITTO FOR HIGH ADDRESS
*   CBASE         LOW ADDRESS OF THE START OF CTRL DATA BY TUNE NUMBER
*   CBASEH        DITTO FOR HIGH ADDRESS
*   PRYOR         PRIORITY BY TUNE NUMBERS  --  ZERO THE LOWEST
*   VOLTABL       VOLUMES
*   FREQTABL      FREQUENCIES
*   CTLTABL       CONTROLS


;          ZERODEF

;          RSEG    CODE6

********************************************************************************
* SCRAPALL
*         KILL ALL TUNES. SHOULD BE CALLED AT POWERUP, CHANGING PLAYERS,
*                AND GAME OVER
*         USES A , DOESN'T USE X OR Y
          ;IF WE CAN USE X HERE, THEN WE CAN SAVE A BYTE
SCRAPALL:
          LDA     #0
          STA     AUDV0                  ;CLEAR SOUND REGISTERS
          STA     AUDV1
          LDA     #$FF
          STA     TUNNUM                 ;FLAG NO TUNES, BOTH CHANNELS
          STA     TUNNUM1
          RTS

; IF YOU WANT, LOOP THIS UP

********************************************************************************
* SCRAPONE
*         KILL A PARTICULAR TUNE. PUT THE NUMBER OF THE TUNE YA WANNA
*                 AXE IN THE ACCUMULATOR.
          ;CAN WE USE X OR Y HERE??

SCRAPONE: CMP     TUNNUM                 ;ON CHAN 0?
          BNE     CKCH1
          LDA     #0
          STA     AUDV0                  ;CLEAR REGISTER
          LDA     #$FF
          STA     TUNNUM                 ;FLAG NO TUNE, CHANNEL 0
          RTS
CKCH1:    SEC
          SBC     TUNNUM1                ;ON CHAN 1?
          BNE     REETS                  ;IF NON ZERO, RETURN
          STA     AUDV1                  ;CLEAR REGISTER
          LDA     #$FF
          STA     TUNNUM1                ;FLAG NO TUNE, CHAN 1
REETS:    RTS

********************************************************************************
* TUNIN
*         START THAT TUNE YOU PUT IN ACC.
;
TUNIN:
	BIT	GAMEOVR			;Is game ending?\
	BPL	TUNIN2			;If not, OK to start tune.
	RTS				;Otherwise, don't start.
TUNIN2:
	STA     TUNTEMP
	BIT     GAMEU
	BPL     REETS2
;
          TYA                            ;SAVE Y,X REGS ON STACK
          PHA
          TXA
          PHA
;
          LDY     #1
TROIKA:   LDA     TUNNUM,Y               ;FIRST CHECK FOR AN EMPTY CHANNEL
          CMP     #$FF
          BEQ     DO
TRKNX:    DEY
          BPL     TROIKA

          LDA     TUNNUM1                ;THIS IS DONE TO PREVENT GLITCHINESS
          AND     #$7F
          TAY
          LDA     TUNNUM
          AND     #$7F
          TAX
          LDA     PRYOR,Y
          LDY     #1
          CMP     PRYOR,X
          BCC     REPTUN1
          LDY     #0
REPTUN1:
          LDA     TUNNUM,Y
          AND     #$7F
          TAX
          LDA     PRYOR,X
          LDX     TUNTEMP
          CMP     PRYOR,X
          BCS     ROOTS

DO:       LDX     TUNTEMP
          CPX     #HISCOR0
          BCC     REGDO
          CPX     #LOSCOR1+1
          BCS     REGDO

          LDA     #4                     ;REPEAT HISCORE TUNES FOUR TIMES
          STA     TUNREPT0,Y             ;BEFORE GOING TO ENDING

REGDO:
          TXA                            ;PLAY TUNE X ON CHANNEL Y
          ORA     #$80                   ;SET HIGH BIT
          STA     TUNNUM,Y

          LDA     #BACKGR0               ;PUNT BOTH CHANNELS OF BACKGROUND
          JSR     SCRAPONE
          LDA     #BACKGR1
          JSR     SCRAPONE

ROOTS:    PLA                            ;RESTORE X,Y REGISTERS
          TAX
          PLA
          TAY
REETS2:   RTS

********************************************************************************
*TUNER SHOULD BE CALLED ONCE PER FRAME, NO INPUTS, AND IT OPERATES WITH
*A TOTAL DISREGARD FOR REGISTER SANCTITY. EACH TUNE CAN BE 256 NOTES LONG
*IF YOUR TUNES ARE VERY SMALL, YOU COULD DO AWAY WITH ALL THE INDIRECT STUFF

TUNER:
;PUT A CHECK FOR ATTRACT MODE HERE

          BIT     GAMEU
          BMI     NOREETS                ; RTS  WHEN IN ATTRACT MODE
          LDA     #0
          STA     AUDV0                  ;TURN OFF SOUND
          STA     AUDV1
          BEQ     REETS2

* PLAY CHANNELS 0 AND 1 *
NOREETS:  LDX     #1

TUNLOP:   LDY     TUNNUM,X
          INY
          BNE     NETN                   ;TUNNUM=FF DO NEXT CHANNEL
JNXTCH:   JMP     NXTCH
NETN:     DEY
          BPL     BOOGIE

* INITIALIZE A NEW TUNE (HIGH BIT ON Y IS SET) *
          TYA
          AND     #$7F
          STA     TUNNUM,X
          TAY
          LDA     #1
          STA     DCH0,X                 ;START (DCHANNEX=1)
          LDA     #$FF                   ; INCREMENTS ON THE FIRST CALL
          STA     TINDEX0,X              ;AND INDEXES WILL BE ZEROED.
          STA     CINDEX0,X
          STA     VINDEX0,X
          LDA     #0
          STA     VRUN,X

BOOGIE:   LDA     TBASE,Y
          STA     MPTRL
          LDA     TBASEH,Y
          STA     MPTRH                  ;MPTR = FREQUENCY BASE ADDRESS

          DEC     DCH0,X                 ;DEC DURATION
          BNE     JNXTCH

          LDA     DURTABL,Y              ;NEW DURATION
          STA     DCH0,X
          LDY     TINDEX0,X              ;FREQUENCY INDEX (OFF OF BASE)
          INC     CINDEX0,X
          INC     VINDEX0,X
          INY
          LDA     (MPTRL),Y              ;FETCH FREQUENCY

          CMP     #$FF                   ;IS IT OVER?
          BNE     CKENL
          STA     TUNNUM,X               ;END THIS FUNKY TUNE
          LDA     #0
          STA     AUDV0,X
          BEQ     JNXTCH                 ;JMP NEXT CHANNEL

SKIPTWO:
          INY
          JMP     PSTFREQ                ;Y BETTER NOT BE ZERO HERE

CKENL:    CMP     #$FE                   ;CODE FOR PLAYING TUNE AGAIN
          BEQ     FOOBEQ

CKNXTT:   CMP     #$FD
          BNE     SKIP                   ;DO A NORMAL FREQUENCY!

* CODE $FD --> JUMP TO ANOTHER TUNE *
          INY                            ;DEFINATELY SKIP TO NEXT BYTE

          DEC     TUNREPT0,X             ;IF NOT DONE REPEATING, SKIP THIS AND
          BNE     SKIPTWO                ;NEXT BYTE IN FREQ TABLE.

          LDA     (MPTRL),Y              ;NEXT BYTE IS NEW TUNE
          STA     TUNNUM,X
          TAY
          LDA     TBASE,Y
          STA     MPTRL
          LDA     TBASEH,Y
          STA     MPTRH                  ;LOAD NEW BASE

* CODE $FE --> PLAY THE TUNE AGAIN *
FOOBEQ:   LDY     #0
          TYA
          STA     CINDEX0,X              ;RESET CONTROL, VOLUME INDEXES
          STA     VINDEX0,X
          STA     VRUN,X
PSTFREQ:  LDA     (MPTRL),Y

; STFREQ    BPL     SKIP                   ;IF BIT 7 CLR, DO A REST

* CHANGE THE DURATION *
; HUH       INY
  ;       LDA     (MPTRL),Y
   ;      STA     DCH0,X                 ;STORE DURATION
    ;     DEY
     ;    LDA     (MPTRL),Y
      ;   INY
       ;  JMP     STIT0                  ;STORE FREQUENCY

* CHECK FOR A REST *
SKIP:     ASL     
          BPL     STIT                   ;STORE FREQ IF BIT 6 CLEAR
          LSR     
          AND     #$BF                   ;RESET BIT 6
          STA     DCH0,X                 ;USE REMAINING 5 BITS FOR
          TYA                            ;A DURATION OF SILENCE
          STA     TINDEX0,X
          DEC     VINDEX0,X
          DEC     CINDEX0,X              ;HOLD CONTROL AND VOLUME INDEXES

          LDA     #0                     ;SILENCE
          STA     AUDV0,X
          BEQ     NXTCH                  ;JMP NEXT CHANNEL

* STORE OUT THE FREQUENCY *
STIT:     LSR     
STIT0:    STA     AUDF0,X                ;STORE AUDIO FREQUENCY
          TYA
          STA     TINDEX0,X              ;TINDEX = Y

* LOOK UP VOLUME *
          DEC     VRUN,X
          BPL     CTRLOAD

          LDY     TUNNUM,X
          LDA     VBASE,Y
          STA     MPTRL
          LDA     VBASEH,Y
          STA     MPTRH                  ;MPTR = VOLUME BASE
          LDY     VINDEX0,X              ;Y = VINDEX
          LDA     (MPTRL),Y
          TAY
          AND     #$0F
          STA     AUDV0,X                ;STORE AUDIO VOLUME
          TYA
          BMI     CTRLOAD                ;HIGH BIT SET

          LSR     
          LSR     
          LSR     
          LSR     
          STA     VRUN,X
          INC     VINDEX0,X

* LOOK UP CONTROL *
CTRLOAD:
          DEC     VINDEX0,X
          LDY     TUNNUM,X
          LDA     CBASE,Y
          STA     MPTRL
          LDA     CBASEH,Y
          STA     MPTRH
          LDY     CINDEX0,X              ;Y = CINDEX
          LDA     (MPTRL),Y
          BPL     STCTRL
          DEY                            ;REPEAT FOREVER
          AND     #$7F
STCTRL:   STA     AUDC0,X                ;STORE AUDIO CONTROL
          TYA
          STA     CINDEX0,X              ;CINDEX = Y

NXTCH:    DEX                            ;X = 0 (NEXT CHANNEL)
          BMI     ROTS
          JMP     TUNLOP                 ;DO CHANNEL 0
ROTS:     RTS

RUNBACK:
;PUT A CHECK FOR ATTRACT MODE HERE

          BIT     GAMEU
          BMI     NORTSBK                ; RTS  WHEN IN ATTRACT MODE
          LDA     #0
          STA     AUDV0                  ;TURN OFF SOUND
          STA     AUDV1
          RTS

* PLAY CHANNELS 0 AND 1 *
NORTSBK:  LDX     #1

BAKLOP:   LDY     BACKNUM,X
          LDA     TBASE,Y
          STA     MPTRL
          LDA     TBASEH,Y
          STA     MPTRH                  ;MPTR = FREQUENCY BASE ADDRESS

          DEC     DBK0,X                 ;DEC DURATION
          BNE     JNEXBK

          LDA     DURTABL,Y              ;NEW DURATION
          STA     DBK0,X
          LDY     TBINDX0,X              ;FREQUENCY INDEX (OFF OF BASE)
          INC     CBINDX0,X
          INC     VBINDX0,X
          INY
          LDA     (MPTRL),Y              ;FETCH FREQUENCY

          CMP     #$FE                   ;CODE FOR PLAYING TUNE AGAIN
          BNE     STITBK

* CODE $FE --> PLAY THE TUNE AGAIN *
REPEATER: LDY     #0
          TYA
          STA     CBINDX0,X              ;RESET CONTROL, VOLUME INDEXES
          STA     VBINDX0,X
          STA     VBRUN,X
PLOKRST:  LDA     (MPTRL),Y

; LOOKRST   BPL     SKIPBK                 ;IF BIT 7 CLR, DO A REST

* CHANGE THE DURATION *
; HUH1      INY
  ;       LDA     (MPTRL),Y
   ;      STA     .dc.bK0,X                 ;STORE DURATION
    ;     DEY
     ;    LDA     (MPTRL),Y
      ;   INY
       ;  BNE     STITBK                 ;STORE FREQUENCY

* CHECK FOR A REST *
SKIPBK:   ASL     
          BPL     STITBK                 ;STORE FREQ IF BIT 6 CLEAR
          LSR     
          AND     #$BF                   ;RESET BIT 6
          STA     DBK0,X                 ;USE REMAINING 5 BITS FOR
          TYA                            ;A DURATION OF SILENCE
          STA     TBINDX0,X
          DEC     VBINDX0,X
          DEC     CBINDX0,X              ;HOLD CONTROL AND VOLUME INDEXES
JNEXBK:   JMP     NEXBK

* STORE OUT THE FREQUENCY *
STITBK:
          TYA
          STA     TBINDX0,X              ;TINDEX = Y

* LOOK UP VOLUME *
          DEC     VBRUN,X
          BPL     CBLOAD

          LDY     BACKNUM,X
          LDA     VBASE,Y
          STA     MPTRL
          LDA     VBASEH,Y
          STA     MPTRH                  ;MPTR = VOLUME BASE
          LDY     VBINDX0,X              ;Y = VINDEX
          LDA     (MPTRL),Y
          BMI     CBLOAD                 ;HIGH BIT SET

          LSR     
          LSR     
          LSR     
          LSR     
          STA     VBRUN,X
          INC     VBINDX0,X

* LOOK UP CONTROL *
CBLOAD:
          DEC     VBINDX0,X
          LDY     BACKNUM,X
          LDA     CBASE,Y
          STA     MPTRL
          LDA     CBASEH,Y
          STA     MPTRH
          LDY     CBINDX0,X              ;Y = CINDEX
          LDA     (MPTRL),Y
          BPL     STCBX
          DEY                            ;REPEAT FOREVER
STCBX:
          TYA
          STA     CBINDX0,X              ;CINDEX = Y

NEXBK:    DEX                            ;X = 0 (NEXT CHANNEL)
          BMI     ROTSBK
          JMP     BAKLOP                 ;DO CHANNEL 0
ROTSBK:   RTS

BACKON:
          BIT     GAMEU
          BPL     NOBAKON

          LDA     DEATH
          BNE     NOBAKON                ;NOT WHEN BIRD IS DYING

          LDA     TUNNUM
          AND     TUNNUM+1
          CMP     #$FF
          BNE     NOBAKON

          LDX     #1
BAKONLP:
          LDA     BACKNUM,X
          STA     TUNNUM,X

          LDA     DBK0,X
          STA     DCH0,X

          LDA     TBINDX0,X
          STA     TINDEX0,X

          LDA     CBINDX0,X
          STA     CINDEX0,X

          LDA     VBINDX0,X
          STA     VINDEX0,X

          LDA     VBRUN,X
          STA     VRUN,X

          DEX
          BPL     BAKONLP

NOBAKON:  RTS


BRDSHOT   EQU     0                      ;TUNE NUMBERS
RICCHET   EQU     1
UWERUN    EQU     2
ALADIN0   EQU     3
ALADIN1   EQU     4
UWEEXP    EQU     5
SCBEXPL   EQU     6
GLDEXPL   EQU     7
SWIM      EQU     8
ENDGAM0   EQU     9
ENDGAM1   EQU     10
MINISHOT  EQU     11
VHDEATH   EQU     12
CUCKOO1   EQU     13
CUCKOO2   EQU     14
NHIERO1   EQU     15
NHIERO2   EQU     16
NHIERO3   EQU     17
HMISS3    EQU     18
SPTUNE    EQU     19                     ;SPAWN
RUNNING   EQU     20
JWTUNE    EQU     21                     ;JEWEL
SFINKS    EQU     22
XLPOWER   EQU     23
POWRUSE   EQU     24
SPHXBM0   EQU     25
SPHXBM1   EQU     26
MINIBM    EQU     27
HISCOR0   EQU     28
HISCOR1   EQU     29
LOSCOR0   EQU     30
LOSCOR1   EQU     31
HISEND0   EQU     32
HISEND1   EQU     33
LOSEND0   EQU     34
LOSEND1   EQU     35
BACKGR0   EQU     36
BACKGR1   EQU     37
FLASHT0   EQU     38
FLASHT1   EQU     39

BACKNUM:  .dc.b      BACKGR0&$FF,BACKGR1&$FF


********************************************************************************
*         pointer tables.
TBASE:    .dc.b      BRDSHOTF&$FF,RICCHETF&$FF,UWERUNF&$FF
	  .dc.b	     ALADIN0F&$FF,ALADIN1F&$FF
          .dc.b      UWEEXPF&$FF,SCBEXPLF&$FF,GLDEXPLF&$FF
          .dc.b      SWIMF&$FF,ENDGAM0F&$FF,ENDGAM1F&$FF
          .dc.b      MINISHTF&$FF
          .dc.b      VHDEATHF&$FF,CUCKOO1F&$FF,CUCKOO2F&$FF
          .dc.b      NHIERO1F&$FF,NHIERO2F&$FF,NHIERO3F&$FF,HMISS3F&$FF
          .dc.b      SPAWNF&$FF,RUNNINGF&$FF
          .dc.b      JEWELF&$FF,SFINKSF&$FF,XLPOWERF&$FF
          .dc.b      POWRUSEF&$FF,SPHXBM0F&$FF,SPHXBM1F&$FF,MINIBMF&$FF
          .dc.b      HISCOR0F&$FF,HISCOR1F&$FF,LOSCOR0F&$FF,LOSCOR1F&$FF
          .dc.b      HISEND0F&$FF,HISEND1F&$FF,LOSEND0F&$FF,LOSEND1F&$FF
          .dc.b      BACKGR0F&$FF,BACKGR1F&$FF,FLASHT0F&$FF,FLASHT1F&$FF

TBASEH:   .dc.b      BRDSHOTF/256,RICCHETF/256,UWERUNF/256
	  .dc.b      ALADIN0F/256,ALADIN1F/256
          .dc.b      UWEEXPF/256,SCBEXPLF/256,GLDEXPLF/256
          .dc.b      SWIMF/256,ENDGAM0F/256,ENDGAM1F/256
          .dc.b      MINISHTF/256
          .dc.b      VHDEATHF/256,CUCKOO1F/256,CUCKOO2F/256
          .dc.b      NHIERO1F/256,NHIERO2F/256,NHIERO3F/256,HMISS3F/256
          .dc.b      SPAWNF/256,RUNNINGF/256
          .dc.b      JEWELF/256,SFINKSF/256,XLPOWERF/256
          .dc.b      POWRUSEF/256,SPHXBM0F/256,SPHXBM1F/256,MINIBMF/256
          .dc.b      HISCOR0F/256,HISCOR1F/256,LOSCOR0F/256,LOSCOR1F/256
          .dc.b      HISEND0F/256,HISEND1F/256,LOSEND0F/256,LOSEND1F/256
          .dc.b      BACKGR0F/256,BACKGR1F/256,FLASHT0F/256,FLASHT1F/256

VBASE:    .dc.b      BRDSHOTV&$FF,RICCHETV&$FF,UWERUNV&$FF
	  .dc.b	     ALADIN0V&$FF,ALADIN1V&$FF
          .dc.b      UWEEXPV&$FF,SCBEXPLV&$FF,GLDEXPLV&$FF
          .dc.b      SWIMV&$FF,ENDGAM0V&$FF,ENDGAM1V&$FF
          .dc.b      MINISHTV&$FF
          .dc.b      VHDEATHV&$FF,CUCKOO1V&$FF,CUCKOO2V&$FF
          .dc.b      NHIERO1V&$FF,NHIERO2V&$FF,NHIERO3V&$FF,HMISS3V&$FF
          .dc.b      SPAWNV&$FF,RUNNINGV&$FF
          .dc.b      JEWELV&$FF,SFINKSV&$FF,XLPOWERV&$FF
          .dc.b      POWRUSEV&$FF,SPHXBM0V&$FF,SPHXBM1V&$FF,MINIBMV&$FF
          .dc.b      HISCOR0V&$FF,HISCOR1V&$FF,LOSCOR0V&$FF,LOSCOR1V&$FF
          .dc.b      HISEND0V&$FF,HISEND1V&$FF,LOSEND0V&$FF,LOSEND1V&$FF
          .dc.b      BACKGR0V&$FF,BACKGR1V&$FF,FLASHT0V&$FF,FLASHT1V&$FF

VBASEH:   .dc.b      BRDSHOTV/256,RICCHETV/256,UWERUNV/256
	  .dc.b      ALADIN0V/256,ALADIN1V/256
          .dc.b      UWEEXPV/256,SCBEXPLV/256,GLDEXPLV/256
          .dc.b      SWIMV/256,ENDGAM0V/256,ENDGAM1V/256
          .dc.b      MINISHTV/256
          .dc.b      VHDEATHV/256,CUCKOO1V/256,CUCKOO2V/256
          .dc.b      NHIERO1V/256,NHIERO2V/256,NHIERO3V/256,HMISS3V/256
          .dc.b      SPAWNV/256,RUNNINGV/256
          .dc.b      JEWELV/256,SFINKSV/256,XLPOWERV/256
          .dc.b      POWRUSEV/256,SPHXBM0V/256,SPHXBM1V/256,MINIBMV/256
          .dc.b      HISCOR0V/256,HISCOR1V/256,LOSCOR0V/256,LOSCOR1V/256
          .dc.b      HISEND0V/256,HISEND1V/256,LOSEND0V/256,LOSEND1V/256
          .dc.b      BACKGR0V/256,BACKGR1V/256,FLASHT0V/256,FLASHT1V/256

CBASE:    .dc.b      BRDSHOTC&$FF,RICCHETC&$FF,UWERUNC&$FF
	  .dc.b	     ALADIN0C&$FF,ALADIN1C&$FF
          .dc.b      UWEEXPC&$FF,SCBEXPLC&$FF,GLDEXPLC&$FF
          .dc.b      SWIMC&$FF,ENDGAM0C&$FF,ENDGAM1C&$FF
          .dc.b      MINISHTC&$FF
          .dc.b      VHDEATHC&$FF,CUCKOO1C&$FF,CUCKOO2C&$FF
          .dc.b      NHIERO1C&$FF,NHIERO2C&$FF,NHIERO3C&$FF,HMISS3C&$FF
          .dc.b      SPAWNC&$FF,RUNNINGC&$FF
          .dc.b      JEWELC&$FF,SFINKSC&$FF,XLPOWERC&$FF
          .dc.b      POWRUSEC&$FF,SPHXBM0C&$FF,SPHXBM1C&$FF,MINIBMC&$FF
          .dc.b      HISCOR0C&$FF,HISCOR1C&$FF,LOSCOR0C&$FF,LOSCOR1C&$FF
          .dc.b      HISEND0C&$FF,HISEND1C&$FF,LOSEND0C&$FF,LOSEND1C&$FF
          .dc.b      BACKGR0C&$FF,BACKGR1C&$FF,FLASHT0C&$FF,FLASHT1C&$FF

CBASEH:   .dc.b      BRDSHOTC/256,RICCHETC/256,UWERUNC/256
	  .dc.b      ALADIN0C/256,ALADIN1C/256
          .dc.b      UWEEXPC/256,SCBEXPLC/256,GLDEXPLC/256
          .dc.b      SWIMC/256,ENDGAM0C/256,ENDGAM1C/256
          .dc.b      MINISHTC/256
          .dc.b      VHDEATHC/256,CUCKOO1C/256,CUCKOO2C/256
          .dc.b      NHIERO1C/256,NHIERO2C/256,NHIERO3C/256,HMISS3C/256
          .dc.b      SPAWNC/256,RUNNINGC/256
          .dc.b      JEWELC/256,SFINKSC/256,XLPOWERC/256
          .dc.b      POWRUSEC/256,SPHXBM0C/256,SPHXBM1C/256,MINIBMC/256
          .dc.b      HISCOR0C/256,HISCOR1C/256,LOSCOR0C/256,LOSCOR1C/256
          .dc.b      HISEND0C/256,HISEND1C/256,LOSEND0C/256,LOSEND1C/256
          .dc.b      BACKGR0C/256,BACKGR1C/256,FLASHT0C/256,FLASHT1C/256

********************************************************************************
DURTABL:  .dc.b      $01                    ;BRDSHOT
          .dc.b      $01                    ;RICCHET
          .dc.b      $02                    ;UWERUN
          .dc.b      $04                    ;ALADIN0
          .dc.b      $04                    ;ALADIN1
          .dc.b      $01                    ;UWEEXP
          .dc.b      $01                    ;SCBEXPL
          .dc.b      $01                    ;GLDEXPL
          .dc.b      $03                    ;SWIM
          .dc.b      $04                    ;ENDGAM0
          .dc.b      $04                    ;ENDGAM1
          .dc.b      $02                    ;MINISHOT
          .dc.b      $02                    ;VHDEATH
          .dc.b      $01                    ;CUCKOO1
          .dc.b      $01                    ;CUCKOO2
          .dc.b      $05                    ;NHIERO1
          .dc.b      $05                    ;NHIERO2
          .dc.b      $05                    ;NHIERO3
          .dc.b      $02                    ;HMISS3
          .dc.b      $02                    ;SPAWN
          .dc.b      $03                    ;RUNNING
          .dc.b      $02                    ;JEWEL
          .dc.b      $02                    ;SFINKS
          .dc.b      $03                    ;XLPOWER
          .dc.b      $04                    ;POWRUSE
          .dc.b      $02                    ;SPHXBM0
          .dc.b      $02                    ;SPHXBM1
          .dc.b      $03                    ;MINIBM
          .dc.b      $08                    ;HISCOR0
          .dc.b      $08                    ;HISCOR1
          .dc.b      $08                    ;LOSCOR0
          .dc.b      $08                    ;LOSCOR1
          .dc.b      $08                    ;HISEND0
          .dc.b      $08                    ;HISEND1
          .dc.b      $08                    ;LOSEND0
          .dc.b      $08                    ;LOSEND1
          .dc.b      $02                    ;BACKGR0
          .dc.b      $02                    ;BACKGR1
          .dc.b      $06                    ;FLASHT0
          .dc.b      $06                    ;FLASHT1

PRYOR:    .dc.b      $01                    ;BRDSHOT        OR THESE EVEN??
          .dc.b      $02                    ;RICCHET
          .dc.b      $02                    ;UWERUN
          .dc.b      $05                    ;ALADIN0
          .dc.b      $05                    ;ALADIN1
          .dc.b      $03                    ;UWEEXP
          .dc.b      $03                    ;SCBEXPL
          .dc.b      $03                    ;GLDEXPL
          .dc.b      $03                    ;SWIM
          .dc.b      $09                    ;ENDGAM0
          .dc.b      $09                    ;ENDGAM1
          .dc.b      $04                    ;ANY MINISPHINX OR SPHINX SHOT
          .dc.b      $06                    ;VHDEATH
          .dc.b      $07                    ;CUCKOO1
          .dc.b      $07                    ;CUCKOO2
          .dc.b      $04                    ;NHIERO1
          .dc.b      $04                    ;NHIERO2
          .dc.b      $04                    ;NHIERO3
          .dc.b      $04                    ;HMISS3
          .dc.b      $03                    ;SPAWN
          .dc.b      $02                    ;RUNNING
          .dc.b      $04                    ;JEWEL
          .dc.b      $03                    ;SFINKS
          .dc.b      $04                    ;XLPOWER
          .dc.b      $04                    ;POWRUSE
          .dc.b      $05                    ;SPHXBM0
          .dc.b      $05                    ;SPHXBM1
          .dc.b      $04                    ;MINIBM
          .dc.b      $0A                    ;HISCOR0
          .dc.b      $0B                    ;HISCOR1
          .dc.b      $0A                    ;LOSCOR0
          .dc.b      $0B                    ;LOSCOR1
          .dc.b      $0C                    ;HISEND0
          .dc.b      $0D                    ;HISEND1
          .dc.b      $0C                    ;LOSEND0
          .dc.b      $0D                    ;LOSEND1
          .dc.b      $00                    ;BACKGR0
          .dc.b      $00                    ;BACKGR1
          .dc.b      $08                    ;FLASHT0
          .dc.b      $08                    ;FLASHT1

********************************************************************************
* FREQTABL
RICCHETF: .dc.b      $44,$07,$07,$03,$06,$03,$06,$03,$06,$FF

BRDSHOTF: .dc.b      $00,$01,$02,$03,$04,$05,$07,$09,$0B,$0D,$0F,$12,$14,$16
          .dc.b      $18,$1C,$1B,$1A,$1C,$1B,$1A,$1C,$FF

ALADIN0F: .dc.b      $1F,$1F,$48,$14,$44,$14,$44
          .dc.b      $15,$15,$48,$14,$14,$48

          .dc.b      $14,$14,$48,$13,$13,$48
          .dc.b      $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D

          .dc.b      $1F,$1F,$48,$14,$14,$15,$15
          .dc.b      $14,$14,$15,$15,$14,$14,$15,$15

          .dc.b      $14,$14,$48,$13,$13,$48
          .dc.b      $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D

          .dc.b      $1F,$1F,$48,$14,$44,$14,$44
          .dc.b      $15,$15,$48,$14,$14,$48

          .dc.b      $14,$14,$48,$13,$13,$48
          .dc.b      $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D

          .dc.b      $1F,$1F,$48,$14,$14,$15,$15
          .dc.b      $14,$14,$15,$15,$14,$14,$15,$15

          .dc.b      $14,$14,$48,$13,$13,$48
          .dc.b      $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D

          .dc.b      $1F,$1F,$48,$14,$44,$14,$44
          .dc.b      $15,$15,$48,$14,$14,$48

          .dc.b      $14,$14,$48,$13,$13,$48
          .dc.b      $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D

          .dc.b      $1F,$1F,$48,$14,$14,$15,$15
          .dc.b      $14,$14,$15,$15,$14,$14,$15,$15

          .dc.b      $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
          .dc.b      $FF

ALADIN1F: .dc.b      $5F                    ;31
          .dc.b      $5F                    ;62

          .dc.b      $5F                    ;93
          .dc.b      $5F                    ;124

          .dc.b      $5F                    ;155
          .dc.b      $5F                    ;186

          .dc.b      $5F                    ;217
          .dc.b      $5F,$48                ;248+8=256 FRAMES OF SILENCE

          .dc.b      $13,$13,$12,$12,$0F,$0F,$0E,$0E
          .dc.b      $0C,$0C,$48,$0F,$0F,$0E,$0E

          .dc.b      $0C,$0C,$48,$0F,$0F,$0E,$0E
          .dc.b      $0C,$0C,$0B,$0B,$0C,$0C,$0E,$0E

          .dc.b      $0F,$0F,$48,$13,$13,$14,$14
          .dc.b      $13,$13,$12,$12,$0F,$0F,$0E,$0E

          .dc.b      $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
          .dc.b      $0F,$0F,$0F,$0F,$12,$12,$12,$12

          .dc.b      $13,$13,$48,$13,$13,$14,$14
          .dc.b      $18,$18,$18,$18,$14,$14,$14,$14

          .dc.b      $13,$13,$14,$14,$13,$13,$12,$12
          .dc.b      $0F,$0F,$0F,$0F,$0F,$0F,$0E,$0E

          .dc.b      $0F,$0F,$48,$0C,$0C,$0E,$0E
          .dc.b      $0F,$0F,$12,$12,$13,$13,$16,$16

          .dc.b      $13,$13,$13,$13,$13,$13,$13,$13
          .dc.b      $FF


UWEEXPF:  .dc.b      $16,$15,$14,$13,$12,$11,$41,$0F
          .dc.b      $00,$0C,$01,$00,$0C,$00,$FF

GLDEXPLF: .dc.b      $17,$17,$06,$06,$05,$04,$04,$04,$FF


ENDGAM0F: .dc.b      $1F,$1F,$48,$14,$44,$14,$44,$15,$15,$48,$14,$14
          .dc.b      $48,$14,$14,$48,$13,$13,$48,$1D,$1D,$1D,$1D
          .dc.b      $1D,$1D,$1D,$1D,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$FF

ENDGAM1F: .dc.b      $13,$13,$12,$12,$0F,$0F,$0E,$0E,$0C,$0C,$48,$0F,$0F
          .dc.b      $0E,$0E,$0C,$0C,$48,$0F,$0F,$0E,$0E,$0C,$0C,$0B,$0B
          .dc.b      $0C,$0C,$0E,$0E,$09,$09,$09,$09,$09,$09,$09,$09,$FF

MINISHTF: .dc.b      $03,$00,$07,$07,$05,$1F,$1F,$1F,$FF


VHDEATHF: .dc.b      $19,$1A,$1B,$1C,$1D,$1E,$1F,$1A
          .dc.b      $04,$05,$06
          .dc.b      $07,$08,$09,$0A,$0B,$0C,$0D,$0E
          .dc.b      $0F,$10,$11,$12,$13,$14,$15,$16
          .dc.b      $17,$18,$19,$1A,$1B,$1C,$1D,$1E,$FF

CUCKOO1F: .dc.b      $1E,$1D,$1F,$1A,$1E,$1C,$1F,$1A
          .dc.b      $0C,$0C,$0C,$06,$05,$06,$0F,$0F
          .dc.b      $0F,$0F,$0F,$0F,$03,$06,$04,$03
          .dc.b      $06,$04,$0C,$0C,$0C,$03,$05,$04
          .dc.b      $0F,$0F,$0F,$0F,$0F,$0F,$03,$04
          .dc.b      $06,$04,$06,$04,$0C,$0C,$0C,$03
          .dc.b      $06,$05,$0F,$0F,$0F,$0F,$0F,$0F,$FF

CUCKOO2F: .dc.b      $00,$00,$00,$00,$00,$00,$00,$00
          .dc.b      $03,$04,$05,$03,$04,$05,$03,$04
          .dc.b      $05,$03,$04,$05,$03,$04,$05,$03
          .dc.b      $04,$05,$03,$04,$05,$03,$04,$05
          .dc.b      $03,$04,$05,$03,$04,$05,$03,$04
          .dc.b      $05,$03,$04,$05,$03,$04,$05,$03
          .dc.b      $04,$05,$03,$04,$05,$03,$04,$05,$FF

NHIERO1F: .dc.b      $17,$16,$12,$11,$0F,$FF

NHIERO2F: .dc.b      $45,$12,$11,$0F,$45,$12,$FF

NHIERO3F: .dc.b      $11,$0F,$0E,$0F,$45,$0B,$0B,$0B,$FF

HMISS3F:  .dc.b      $45,$13,$15,$17,$18,$19,$1A,$1C,$15
          .dc.b      $1F,$1D,$1F,$1D,$1F,$1D,$1F,$1D,$FF

SPAWNF:   .dc.b      $17,$17,$18,$18,$19,$19,$FF

RUNNINGF: .dc.b      $1F,$1F,$1F,$49,$14,$12,$10,$0F,$FE     ;REPEATS

JEWELF:   .dc.b      $8,$7,$6,$5,$4,$3,$4,$4
          .dc.b      $4,$4,$4,$4,$4,$4,$4,$4
          .dc.b      $4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$FF

SFINKSF:  .dc.b      $5,$4,$3,$2,$1,$8,$7,$6
          .dc.b      $5,$4,$3,$3,$4,$3,$2,$FE      ;REPEATS

XLPOWERF: .dc.b      $13,$43,$11,$43,$E,$43,$9,$9,$9,$9,$FF

UWERUNF:  .dc.b      9,$42,8,$42,4,$42,8,$42
          .dc.b      7,$42,4,$42,6,$42,5,$42,6,$FF
SWIMF:    .dc.b      $8,$F,$8,$F,$8,$F,$8,$F
          .dc.b      $8,$F,$8,$F,$8,$F,$8,$F,$FE        ;REPEATS
SCBEXPLF: .dc.b      $06,$07,$0C,$10,$12,$15,$15,$00
          .dc.b      $14,$18,$14,$12,$0E,$08,$07,$00,$FF

SPHXBM0F: .dc.b      $08,$08,$03,$03,$04,$04,$06,$06
          .dc.b      $08,$08,$03,$03,$04,$04,$06,$06
          .dc.b      $08,$08,$03,$03,$04,$04,$06,$06
          .dc.b      $08,$08,$03,$03,$04,$04,$06,$06,$FF

SPHXBM1F: .dc.b      $0A,$0A,$0A,$0A,$0B,$0B,$0C,$0C
          .dc.b      $0D,$0D,$0A,$0E,$0F,$0F,$10,$10
          .dc.b      $11,$11,$12,$12,$13,$0C,$14,$14
          .dc.b      $15,$0A,$16,$16,$17,$09,$18,$18,$FF

MINIBMF:  .dc.b      $12,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$FF

POWRUSEF: .dc.b      $07,$0B,$08,$0B,$07,$0B,$08,$0B,$07,$0B,$FF

HISCOR0F: .dc.b      $0B,$09,$13,$06,$08,$0B,$0D,$11
          .dc.b      $0E,$0D,$0E,$0B,$09,$0D,$08,$11
          .dc.b      $0B,$06,$13,$05,$04,$13,$08,$09
          .dc.b      $0B,$13,$10,$FD,HISEND0,$0E,$0D,$10,$11,$11,$FE     ;REPEATS

HISEND0F: .dc.b      $0D,$11,$11,$11,$11,$FF

HISCOR1F: .dc.b      $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          .dc.b      $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          .dc.b      $12,$12,$12,$12,$12,$12,$12,$12
          .dc.b      $FD,HISEND1,$12,$12,$12,$12,$0F,$0F,$0F,$0F,$FE     ;REPEA

HISEND1F: .dc.b      $0F,$0F,$0F,$0F,$0D,$0D,$0D,$0D,$FF

LOSCOR0F: .dc.b      $0B,$09,$06,$09,$08,$0B,$0D,$10
          .dc.b      $11,$0E,$0D,$0E,$09,$0D,$08,$11
          .dc.b      $0D,$0B,$09,$06,$13,$06,$08,$09
          .dc.b      $0B,$13,$10,$FD,LOSEND0,$0E,$0D,$10,$11,$11,$FE     ;REPEATS

LOSEND0F: .dc.b      $0D,$11,$11,$11,$11,$FF

LOSCOR1F: .dc.b      $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          .dc.b      $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          .dc.b      $12,$12,$12,$12,$12,$12,$12,$12
          .dc.b      $FD,LOSEND1,$12,$12,$12,$12,$0F,$0F,$0F,$0F,$FE     ;REPEATS

LOSEND1F: .dc.b      $0F,$0F,$0F,$0F,$0D,$0D,$0D,$0D,$FF

BACKGR1F:
BACKGR0F: .dc.b      $B,$B,$B,$B,$B,$B,$B,$B
          .dc.b      $B,$B,$B,$B,$B,$B,$B,$B
          .dc.b      $C,$C,$C,$C,$C,$C,$C,$C
          .dc.b      $C,$C,$C,$C,$C,$C,$C,$C,$FE

FLASHT0F: .dc.b      $0D,$0E,$10,$11,$0D,$0E,$12,$13
          .dc.b      $0D,$0E,$10,$11,$0D,$0E,$12,$13,$FF

FLASHT1F: .dc.b      $09,$08,$06,$13,$09,$08,$13,$05
          .dc.b      $09,$08,$06,$13,$08,$08,$13,$05,$FF

********************************************************************************
* VOLTABL

RICCHETV: .dc.b      $1F,$08,$07,$06,$05,$04,$02

BRDSHOTV: .dc.b      $09,$18,$17,$16,$25,$24,$23,$22,$21


ALADIN0V: .dc.b      $14,$04,$04
          .dc.b      $14,$14

          .dc.b      $14,$14
          .dc.b      $75

          .dc.b      $14,$34
          .dc.b      $75

          .dc.b      $14,$14
          .dc.b      $75

          .dc.b      $14,$04,$04
          .dc.b      $14,$14

          .dc.b      $14,$14
          .dc.b      $75

          .dc.b      $14,$34
          .dc.b      $75

          .dc.b      $14,$14
          .dc.b      $75

          .dc.b      $14,$04,$04
          .dc.b      $14,$14

          .dc.b      $14,$14
          .dc.b      $75

          .dc.b      $14,$34
          .dc.b      $56

          .dc.b      $32,$13,$12,$11

ALADIN1V:
          .dc.b      $15,$16,$17,$18
          .dc.b      $19,$17,$18

          .dc.b      $19,$17,$18
          .dc.b      $19,$1A,$19,$18

          .dc.b      $17,$17,$16
          .dc.b      $17,$18,$19,$1A

          .dc.b      $B9,$3A

          .dc.b      $1A,$19,$18
          .dc.b      $37,$38

          .dc.b      $19,$18,$19,$1A
          .dc.b      $3B,$3C

          .dc.b      $1C,$1D,$1C
          .dc.b      $1B,$1A,$19,$18

          .dc.b      $39,$08,$07,$06,$05


UWEEXPV:  .dc.b      $04,$05,$06,$07,$08,$09,$0F
          .dc.b      $0E,$0C,$09,$08,$06,$04

GLDEXPLV: .dc.b      $18,$07,$06,$05,$04,$03,$02


ENDGAM0V: .dc.b      $14,$04,$04,$14,$14
          .dc.b      $14,$14,$75,$74

ENDGAM1V: .dc.b      $15,$16,$17,$18,$19,$17,$18
          .dc.b      $19,$17,$18,$19,$1A,$19
          .dc.b      $18,$17,$06,$05,$04,$03,$02,$01

MINISHTV: .dc.b      $0F,$07,$08,$06,$04,$03,$02,$01


VHDEATHV: .dc.b      $18,$17,$16,$15
          .dc.b      $E8
          .dc.b      $37
          .dc.b      $36,$35

CUCKOO1V: .dc.b      $08,$07,$06,$05,$04,$05,$06,$07
          .dc.b      $F5,$F5,$F5

CUCKOO2V: .dc.b      $73,$F3,$F3,$F3

NHIERO1V: .dc.b      $88

NHIERO2V: .dc.b      $28,$8

NHIERO3V: .dc.b      $38,$28

HMISS3V:  .dc.b      $1A,$1B,$1C,$1D
          .dc.b      $1E,$1D,$1C,$1B

SPAWNV:   .dc.b      $8A
RUNNINGV: .dc.b      $23,$33

JEWELV:   .dc.b      $3,$14,$15,$6,$19
          .dc.b      $7,$8,$9,$A,$19,$18
          .dc.b      $17,$16,$15,$4,$3,$2,$1
SFINKSV:  .dc.b      $47,$8,$19
          .dc.b      $1A,$B,$1E,$C,$D
XLPOWERV: .dc.b      $A,$A,$A,$1A,$9,$8

UWERUNV:  .dc.b      3,6,5,4
          .dc.b      3,3,3,3,6
SWIMV:    .dc.b      2,3,4,5,4,3,$22
          .dc.b      3,4,5,4,3,$22
SCBEXPLV: .dc.b      $15,$16,$17,$18
          .dc.b      $19,$18,$17,$16

SPHXBM0V: .dc.b      $0D,$0E,$2F,$0E,$0D,$0C
          .dc.b      $0B,$0A,$09,$08,$07,$06,$05,$04
          .dc.b      $1A,$19,$18,$17
          .dc.b      $16,$15,$14,$13

SPHXBM1V: .dc.b      $7F
          .dc.b      $7E
          .dc.b      $7D
          .dc.b      $1C,$19,$17,$15

MINIBMV:  .dc.b      $1F,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05

POWRUSEV: .dc.b      $08,$07,$06,$05,$04,$03,$02,$02,$01,$01

LOSCOR0V:
LOSEND0V:
HISCOR0V:
HISEND0V: .dc.b      $88

HISCOR1V:
HISEND1V: .dc.b      $18,$17,$16,$15
          .dc.b      $14,$13,$12,$11
          .dc.b      $08,$17,$06,$15,$04,$03
          .dc.b      $08,$07,$06,$05,$08,$07,$06,$05

LOSCOR1V: .dc.b      $08,$05,$02,$90,$F0,$08,$05,$02,$00
LOSEND1V: .dc.b      $08,$05,$03,$02

BACKGR1V:
BACKGR0V: .dc.b      6,6,4,2,1,$61,$31
          .dc.b      6,6,4,2,1,$61,$31

FLASHT0V:
FLASHT1V: .dc.b      $78,8,7,6,5,4,3,2,1

********************************************************************************
* CTLTABL


MINISHTC: .dc.b      $83

RICCHETC: .dc.b      $08,$08,$8F

ALADIN0C:
HMISS3C:
ENDGAM0C: .dc.b      $81

HISEND0C:
HISCOR0C:
          .dc.b      $0D,$0D,$04,$0D,$0D,$0D,$0D,$0D
          .dc.b      $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          .dc.b      $0D,$0D,$04,$0D,$0D,$0D,$0D,$0D
          .dc.b      $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
BACKGR0C:
BACKGR1C:
LOSCOR1C:
LOSEND1C:
HISEND1C:
HISCOR1C:
          .dc.b      $8A

LOSEND0C:
LOSCOR0C: .dc.b      $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          .dc.b      $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          .dc.b      $0D,$0D,$0D,$0D,$04,$8D

FLASHT0C:
POWRUSEC:
ALADIN1C:
ENDGAM1C:
RUNNINGC: .dc.b      $8D

BRDSHOTC:
UWEEXPC:
UWERUNC:
SWIMC:
MINIBMC:
GLDEXPLC: .dc.b      $88

JEWELC:   .dc.b      $08,$08,$08,$08,$08,$08,$84
XLPOWERC:
CUCKOO2C:
NHIERO1C:
NHIERO2C:
NHIERO3C: .dc.b      $84


VHDEATHC: .dc.b      $03,$07,$0F,$08,$08,$08,$08,$08
          .dc.b      $84

CUCKOO1C: .dc.b      $08,$08,$08,$08,$08,$08,$08,$08
          .dc.b      $84



SPAWNC:   .dc.b      $D,$1,$D,$1,$D,$1


SFINKSC:  .dc.b      $8F

SCBEXPLC: .dc.b      $D,$D,7,7,4,4,$F,$F
          .dc.b      $84

SPHXBM0C: .dc.b      $08,$03,$08,$03,$08,$03,$08,$08
          .dc.b      $08,$03,$08,$03,$08,$03,$08,$08
          .dc.b      $08,$03,$08,$03,$08,$03,$08,$08
          .dc.b      $08,$03,$08,$03,$08,$03,$08,$08

SPHXBM1C: .dc.b      $08,$08,$03,$08,$08,$03,$08,$08
          .dc.b      $03,$08,$08,$03,$08,$08,$03,$08
          .dc.b      $08,$03,$08,$04,$03,$08,$08,$03
          .dc.b      $08,$08,$03,$08,$08,$03,$08,$08

FLASHT1C: .dc.b      $0D,$0D,$0D,$04,$0D,$0D,$04,$0D
          .dc.b      $0D,$0D,$0D,$04,$0D,$0D,$04,$0D

**


;          END

