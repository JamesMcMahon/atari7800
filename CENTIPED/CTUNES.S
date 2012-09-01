*******************************************************************************
*
*         TUNES.S       by Kevin G. Osborn
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
*<*     SCRAPONE -- KILL A PARTICULA*     SCRAPONE -- KILL A PARTICULAR TUNE. PUT THE NUMBER OF THE TUNE YA WANNA
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


********************************************************************************
* SCRAPALL
*         KILL ALL TUNES. SHOULD BE CALLED AT POWERUP, CHANGING PLAYERS,
*                AND GAME OVER
SCRAPALL  TYA
          PHA
          LDA     TUNNUM
          CMP     #6                     ;XTRAMAN
          BEQ     CHK1CH
          LDY     #0
          STY     AUDV0
          STY     SCRPINDX
          DEY
          STY     TUNNUM
CHK1CH    LDA     TUNNUM1
          CMP     #6
          BEQ     ROTES
          LDY     #0
          STY     AUDV1
          STY     SCRPINDX
          DEY
          STY     TUNNUM1
ROTES     PLA
          TAY
          RTS

; IF YOU WANT, LOOP THIS UP

********************************************************************************
* SCRAPONE
*         KILL A PARTICULAR TUNE. PUT THE NUMBER OF THE TUNE YA WANNA
*                 AXE IN THE ACCUMULATOR.
SCRAPONE  CMP     TUNNUM
          BNE     CKCH1
          LDA     #0
          STA     AUDV0
          STA     SCRPINDX
          LDA     #$FF
          STA     TUNNUM
          RTS
CKCH1     SEC
          SBC     TUNNUM1
          BNE     REETS
          STA     AUDV1
          STA     SCRPINDX
          LDA     #$FF
          STA     TUNNUM1
REETS     RTS

********************************************************************************
* TUNIN
*         START THAT TUNE YOU PUT IN ACC.
TUNIN     STA     TUNTEMP
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
DO        LDA     TUNNUM,Y
          CMP     #5
          BNE     IT
          LDA     TINDEX0,Y
          STA     SCRPINDX
IT        TXA
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
TUNER     BIT     ATTRACT
          BMI     REETS
          BVS     REETS
          LDA     PAUSETMR
          BNE     REETS
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
          LDA     #$FF                   ;NEXT TIME THROUGH TUNER, TUNE WILL
          STA     DCH0,X                 ;START
          STA     TINDEX0,X
          STA     CINDEX0,X
          STA     VINDEX0,X
          CPY     #5
          BNE     BOOGIE
          LDA     SCRPINDX
          STA     TINDEX0,X
          DEC     TINDEX0,X
          LDA     #0
          STA     SCRPINDX
BOOGIE    LDA     TBASE,Y
          STA     MPTRL
          LDA     TBASEH,Y
          STA     MPTRH
          DEC     DCH0,X
          BPL     JNXTCH
          LDA     DURTABL,Y
          STA     DCH0,X
          LDY     TINDEX0,X
          INC     CINDEX0,X
          INC     VINDEX0,X
          INY
          LDA     (MPTRL),Y              ;FREQ
          CMP     #$FF
          BNE     CKENL
          STA     TUNNUM,X               ;END THIS FUNKY TUNE
          LDA     #0
          STA     AUDV0,X
          BEQ     NXTCH
CKENL     CMP     #$FE
          BEQ     FOOBEQ
CKNXTT    CMP     #$FD
          BNE     STFREQ
          INY
          LDA     (MPTRL),Y
          STA     TUNNUM,X
          TAY
          LDA     TBASE,Y
          STA     MPTRL
          LDA     TBASEH,Y
          STA     MPTRH

FOOBEQ    LDY     #0                     ;REPEATREPEATREPEAT
          TYA
          STA     CINDEX0,X
          STA     VINDEX0,X
          LDA     (MPTRL),Y
STFREQ    BPL     STIT
          INY
          LDA     (MPTRL),Y
          STA     DCH0,X
          INY
          LDA     (MPTRL),Y
STIT      STA     AUDF0,X
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
          LDY     TUNNUM,X

          LDA     CBASE,Y
          STA     MPTRL
          LDA     CBASEH,Y
          STA     MPTRH
          LDY     CINDEX0,X
          LDA     (MPTRL),Y
          BPL     STCTRL
          DEY
STCTRL    STA     AUDC0,X
          TYA
          STA     CINDEX0,X

NXTCH     DEX
          BMI     ROTS
          JMP     TUNLOP
ROTS      RTS


