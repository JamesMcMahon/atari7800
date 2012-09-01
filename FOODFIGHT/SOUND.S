*******************************************************************************
*
*         SOUND.S       by Kevin G. Osborn
*         Contains subroutines
*                 TUNER
*                 SCRAPALL
*                 SCRAPONE
*                 TUNIN
*******************************************************************************
********************************************************************************
* SIMPSONG VERSION 0.03
*
* THIS SIMPLE SOUND DRIVER HAS, IN SOME WAYS, FEWER FEATURES BUT USES LESS RAM
* AND ROM AND DOES NOT BACK UP SOUNDS FOR LATER (SOMETIMES MUCH LATER)
* CONTINUATION. IT FEATURES 256 NOTE TUNES, SINGLE DURATION PER TUNE, ENDLESS
* TUNES. IF A VALUE IN THE CONTROL OR VOLUME TABLES HAS THE HIGH BIT SET, THAT
* VOLUME OR CONTROL WILL REMAIN IN EFFECT TILL THE END OF THE TUNE.
* AN FF IN THE FREQUENCY TABLE WILL TERMINATE THE TUNE, AN FE WILL CAUSE IT TO
* RESTART.  AN FD WILL CALL THE TUNE NUMBER FOLLOWING (IN THE FREQ TABLE).
*
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
*DCH0      DS      1                      ONE BYTE--DURATION CNTR CHAN. 0
*DCH1      DS      1                      ONE BYTE--DURATION CNTR CHAN. 1
*TUNNUM    DS      1                      ONE BYTE--TUNE NUM FOR CHAN. 0
*TUNNUM1   DS      1                      ONE BYTE--TUNE NUM FOR CHAN. 1
*TINDEX0   DS      1                      ONE BYTE--NOTE POINTER 0
*TINDEX1   DS      1                      ONE BYTE--NOTE POINTER 1
*CINDEX0   DS      1                      CONTROL INDEX
*CINDEX1   DS      1
*VINDEX0   DS      1                      VOLUME INDEX
*VINDEX1   DS      1
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

          GLBL    DURTABL,TBASE,TBASEH,VBASE,VBASEH,CBASE,CBASEH
          GLBL    VOLTABL,FREQTABL
          GLBL    DCH0,DCH1,TUNNUM,TUNNUM1,TINDEX0,TINDEX1,CINDEX0
          GLBL    VINDEX0,VINDEX1,MPTRL,MPTRH,TUNTEMP

          GLBL    STATATTR

          GLBL    IRTNDONE
          GLBL    TUNEDONE
          GLBL    SCRAPALL,SCRAPONE,TUNIN,TUNER
          GLBL    MATTRACT
          GLBL    MPAUSE,MBLANK
          GLBL    TRUE,FALSE

; globals in Tables.s

          GLBL    CTRLTABL,PRYOR,ZTUNE0F
          GLBL    ZTUNE1F,ZTUNE2F,ZTUNE1V,ZTUNE2V,ZTUNE0V
          GLBL    ZTUNE3F,ZTUNE3V,ZTUNE4F,ZTUNE4V,ZTUNE5F,ZTUNE5V
          GLBL    ZTUNE6F,ZTUNE6V,ZTUNE7F,ZTUNE7V,ZTUNE8F,ZTUNE8V
          GLBL    ZTUNE9F,ZTUNE9V,ATUNE10F,ZTUNE10V,ATUNE11F,ZTUNE11V
          GLBL    ATUNE12F,ZTUNE12V,ATUNE13F,ZTUNE13V,ZTUNE14F,ZTUNE14V
          GLBL    ZTUNE15F,ZTUNE15V,ZTUNE16F,ZTUNE16V,ZTUNE17F,ZTUNE17V
          GLBL    ZTUNE18F,ZTUNE18V,ZTUNE19F,ZTUNE19V,ZTUNE20F,ZTUNE20V
          GLBL    ZTUNE21F,ZTUNE21V,ZTUNE22F,ZTUNE22V,ZTUNE23F,ZTUNE23V
          GLBL    ZTUNE24F,ZTUNE24V,ZTUNE25F,ZTUNE25V,ZTUNE26F,ZTUNE26V
          GLBL    ZTUNE27F,ZTUNE27V,ZTUNE28F,ZTUNE28V,ZTUNE29F,ZTUNE29V
          GLBL    ZTUNE30F,ZTUNE30V,ZTUNE31F,ZTUNE31V,ZTUNE32F,ZTUNE32V

          RAMDEF                         ; ZERO PAGE

          RSEG    CODE1

********************************************************************************
* SCRAPALL
*         KILL ALL TUNES. SHOULD BE CALLED AT POWERUP, CHANGING PLAYERS,
*                AND GAME OVER
*   ALSO BEFORE INITIATING A TUNE WITH TWO VOICES

SCRAPALL  TYA
          PHA
          TXA
          PHA
          LDY     #0
          STY     AUDV0
          STY     AUDV1
          DEY
          STY     TUNNUM
          STY     TUNNUM1
          PLA
          TAX
          PLA
          TAY
          RTS

; IF YOU WANT, LOOP THIS UP

********************************************************************************
* SCRAPONE
*         KILL A PARTICULAR TUNE. PUT THE NUMBER OF THE TUNE YA WANNA
*                 AXE IN THE ACCUMULATOR.
;SCRAPONE  CMP     TUNNUM
;         BNE     CKCH1
;         LDA     #0
;         STA     AUDV0
;         LDA     #$FF
;         STA     TUNNUM
;         RTS
;CKCH1     SEC
;         SBC     TUNNUM1
;         BNE     REETS
;         STA     AUDV1
;         LDA     #$FF
;         STA     TUNNUM1
;REETS     RTS

********************************************************************************
* TUNEDONE
*         RETURNS TRUE IF NO TUNES ARE PLAYING
*         IF BOTH TUNNUM CHANNELS ARE FF, THEN RETURN TRUE

;TUNEDONE  LDA     TUNNUM1
;         CMP     #$FF
;         BNE     TDRTNF

;         LDA     TUNNUM
;         CMP     #$FF
;         BNE     TDRTNF

;         LDA     #TRUE
;         RTS

;TDRTNF    LDA     #FALSE

REETS     RTS

********************************************************************************
* TUNIN
*         START THAT TUNE YOU PUT IN ACC.

TUNIN     STA     TUNTEMP

          LDA     MODE                   ; NO SOUND IN ATTRACT
          CMP     #MATTRACT
          BEQ     REETS

          LDA     DOITOVER               ; NO SOUND IN REPLAY
          BNE     REETS

          TYA
          PHA
          TXA
          PHA

          LDY     #1
          LDX     TUNTEMP
TROIKA    LDA     TUNNUM,Y               ;FIRST CHECK FOR AN EMPTY CHANNEL
          CMP     #$FF
          BEQ     DO
TRKNX     DEY
          BPL     TROIKA
          LDA     TUNNUM1                ;THIS IS DONE TO PREVENT GLITCHINESS
          AND     #$7F
          TAY
          LDA     PRYOR,X
          CMP     PRYOR,Y               ;CHECK FOR LOWEST PRIORITY
          LDY     #1
          BCS     DO
          LDA     TUNNUM                ;THIS IS DONE TO PREVENT GLITCHINESS
          AND     #$7F
          TAY
          LDA     PRYOR,X
          CMP     PRYOR,Y               ;CHECK FOR LOWEST PRIORITY
          BCC     ROOTS
          LDY     #0
DO        TXA
          ORA     #$80
          STA     TUNNUM,Y
ROOTS     PLA
          TAX
          PLA
          TAY
          RTS

********************************************************************************
*TUNER SHOULD BE CALLED ONCE PER FRAME, NO INPUTS, AND IT OPERATES WITH
*A TOTAL DISREGARD FOR REGISTER SANCTITY. EACH TUNE CAN BE 256 NOTES LONG
*IF YOUR TUNES ARE VERY SMALL, YOU COULD DO AWAY WITH ALL THE INDIRECT STUFF
TUNER     LDA     STATUS
          CMP     #STATATTR
          BEQ     REETS                  ; RTS

          LDA     MODE                   ; DURING PAUSE, RETAIN STATE OF
          CMP     #MPAUSE                ;  CURRENT SOUNDS
          BEQ     REETS
          CMP     #MBLANK
          BEQ     REETS

          LDX     #1
TUNLOP    LDY     TUNNUM,X
          INY
          BNE     NETN                   ;TUNNUM=FF DO NEXT CHANNEL
JNXTCH    JMP     NXTCH
NETN      DEY
          BPL     BOOGIE

          TYA                            ;NEW TUNE--INTITIATE
          AND     #$7F
          STA     TUNNUM,X

          TAY
          LDA     CTRLTABL,Y
          STA     AUDC0,X                ; IN EFFECT UNTIL CHANGED

          LDA     #1
          STA     DCH0,X                 ;START

          LDA     #$FF                   ; INCREMENTS ON THE FIRST CALL
          STA     TINDEX0,X
*         STA     CINDEX0,X
          STA     VINDEX0,X
BOOGIE    LDA     TBASE,Y
          STA     MPTRL
          LDA     TBASEH,Y
          STA     MPTRH
          DEC     DCH0,X
          BNE     JNXTCH                 ; SAME AS PATTY'S SOUND EDITOR
          LDA     DURTABL,Y
          STA     DCH0,X
          LDY     TINDEX0,X
*         INC     CINDEX0,X
          INC     VINDEX0,X
TESTBYTE  INY
TBYTE0    LDA     (MPTRL),Y              ;FREQ
          CMP     #$FF
          BNE     CKNXTT

          STA     TUNNUM,X               ;END THIS FUNKY TUNE
          LDA     #0
          STA     AUDV0,X
          BEQ     JNXTCH

;CKENL     CMP     #$FE                  ; NO REPEATS FOR ME !
;         BEQ     FOOBEQ

CKNXTT    CMP     #$FD                   ; CONTINUE WITH THE NEXT TUNE
          BEQ     NEXTTUNE
          CMP     #$FC                   ; A VALID STOPPING POINT
          BEQ     SIRTRUE
          CMP     #$FB                   ; NO LONGER VALID FOR STOPPING
          BEQ     SIRFALSE
          JMP     STFREQ

SIRTRUE   LDA     #TRUE
          JMP     SETIRTN
SIRFALSE  LDA     #FALSE
SETIRTN   STA     IRTNDONE
          JMP     TESTBYTE               ; PROCESS THE NEXT BYTE

NEXTTUNE  INY                            ; NEXT BYTE IS TUNE INDEX
          LDA     (MPTRL),Y
          TAY
          ORA     #$80                   ; SO THAT NEW CTRL AND VOLUME GET READ
          STA     TUNNUM,X

          LDA     TBASE,Y                ; GET ADDRESS OF NEW TUNE
          STA     MPTRL
          LDA     TBASEH,Y
          STA     MPTRH

          LDY     #0                     ; JUMP HERE FOR REPEAT
          TYA                            ; Y MUST BE 0, IT'S THE FREQ. INDEX
*         STA     CINDEX0,X
          STA     VINDEX0,X

          JMP     TBYTE0                 ; IN CASE IT'S AN IR SPECIAL

FRQLOOP   LDA     (MPTRL),Y
STFREQ    BPL     SKIP0                  ; IF BIT 7 SET, GET NEW DURATION
          INY
          LDA     (MPTRL),Y
          STA     DCH0,X
          DEY
          LDA     (MPTRL),Y
          INY
          JMP     STIT0

SKIP0     ASL     A
          BPL     SKIP1                  ; IF BIT 6 SET, THIS IS A REST
          LSR     A
          AND     #$BF
          STA     DCH0,X
          TYA
          STA     TINDEX0,X
          DEC     VINDEX0,X
*         DEC     CINDEX0,X

          LDA     #0
          STA     AUDV0,X
          BEQ     NXTCH

SKIP1     ASL     A
          BPL     STIT                   ; IF BIT 5 IS SET, THIS IS A NEW CTRL
          LSR     A
          LSR     A
          AND     #$1F
          STA     AUDC0,X

          INY
          JMP     FRQLOOP                ; DO NEXT BYTE BEFORE RETURNING

STIT      LSR     A
          LSR     A
STIT0     STA     AUDF0,X
          TYA
          STA     TINDEX0,X
          LDY     TUNNUM,X
          LDA     VBASE,Y
          STA     MPTRL
          LDA     VBASEH,Y
          STA     MPTRH
          LDY     VINDEX0,X
          LDA     (MPTRL),Y
          BPL     STVL
          DEY
STVL      STA     AUDV0,X
          TYA
          STA     VINDEX0,X
*         LDY     TUNNUM,X

*         LDA     CBASE,Y
*         STA     MPTRL
*         LDA     CBASEH,Y
*         STA     MPTRH
*         LDY     CINDEX0,X
*         LDA     (MPTRL),Y
*         BPL     STCTRL
*         DEY
*STCTRL    STA     AUDC0,X
*         TYA
*         STA     CINDEX0,X

NXTCH     DEX
          BMI     ROTS
          JMP     TUNLOP
ROTS      RTS




********************************************************************************
*         pointer tables.

TBASE     DB      L(ZTUNE0F),L(ZTUNE1F),L(ZTUNE2F),L(ZTUNE3F)
          DB      L(ZTUNE4F),L(ZTUNE5F),L(ZTUNE6F),L(ZTUNE7F),L(ZTUNE8F)
          DB      L(ZTUNE9F),L(ATUNE10F),L(ATUNE11F),L(ATUNE12F)
          DB      L(ATUNE13F),L(ZTUNE14F),L(ZTUNE15F),L(ZTUNE16F)
          DB      L(ZTUNE17F),L(ZTUNE18F),L(ZTUNE19F),L(ZTUNE20F)
          DB      L(ZTUNE21F),L(ZTUNE22F),L(ZTUNE23F)
          DB      L(ZTUNE24F),L(ZTUNE25F),L(ZTUNE26F)
          DB      L(ZTUNE27F),L(ZTUNE28F),L(ZTUNE29F)
          DB      L(ZTUNE30F),L(ZTUNE31F),L(ZTUNE32F)

TBASEH    DB      H(ZTUNE0F),H(ZTUNE1F),H(ZTUNE2F),H(ZTUNE3F)
          DB      H(ZTUNE4F),H(ZTUNE5F),H(ZTUNE6F),H(ZTUNE7F),H(ZTUNE8F)
          DB      H(ZTUNE9F),H(ATUNE10F),H(ATUNE11F),H(ATUNE12F)
          DB      H(ATUNE13F),H(ZTUNE14F),H(ZTUNE15F),H(ZTUNE16F)
          DB      H(ZTUNE17F),H(ZTUNE18F),H(ZTUNE19F),H(ZTUNE20F)
          DB      H(ZTUNE21F),H(ZTUNE22F),H(ZTUNE23F)
          DB      H(ZTUNE24F),H(ZTUNE25F),H(ZTUNE26F)
          DB      H(ZTUNE27F),H(ZTUNE28F),H(ZTUNE29F)
          DB      H(ZTUNE30F),H(ZTUNE31F),H(ZTUNE32F)

VBASE     DB      L(ZTUNE0V),L(ZTUNE1V),L(ZTUNE2V),L(ZTUNE3V)
          DB      L(ZTUNE4V),L(ZTUNE5V),L(ZTUNE6V),L(ZTUNE7V),L(ZTUNE8V)
          DB      L(ZTUNE9V),L(ZTUNE10V),L(ZTUNE11V),L(ZTUNE12V)
          DB      L(ZTUNE13V),L(ZTUNE14V),L(ZTUNE15V),L(ZTUNE16V)
          DB      L(ZTUNE17V),L(ZTUNE18V),L(ZTUNE19V),L(ZTUNE20V)
          DB      L(ZTUNE21V),L(ZTUNE22V),L(ZTUNE23V)
          DB      L(ZTUNE24V),L(ZTUNE25V),L(ZTUNE26V)
          DB      L(ZTUNE27V),L(ZTUNE28V),L(ZTUNE29V)
          DB      L(ZTUNE30V),L(ZTUNE31V),L(ZTUNE32V)

VBASEH    DB      H(ZTUNE0V),H(ZTUNE1V),H(ZTUNE2V),H(ZTUNE3V)
          DB      H(ZTUNE4V),H(ZTUNE5V),H(ZTUNE6V),H(ZTUNE7V),H(ZTUNE8V)
          DB      H(ZTUNE9V),H(ZTUNE10V),H(ZTUNE11V),H(ZTUNE12V)
          DB      H(ZTUNE13V),H(ZTUNE14V),H(ZTUNE15V),H(ZTUNE16V)
          DB      H(ZTUNE17V),H(ZTUNE18V),H(ZTUNE19V),H(ZTUNE20V)
          DB      H(ZTUNE21V),H(ZTUNE22V),H(ZTUNE23V)
          DB      H(ZTUNE24V),H(ZTUNE25V),H(ZTUNE26V)
          DB      H(ZTUNE27V),H(ZTUNE28V),H(ZTUNE29V)
          DB      H(ZTUNE30V),H(ZTUNE31V),H(ZTUNE32V)

          END
