;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                   ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;    SOUND                                          ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                   ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                   ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                   ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                   ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; SONGS
;________________LEN___C0__C1___________________________________________________
; 0                                                 NO SONG ACTIVE
;_______________________________________________________________________________
; 1    SNGC       24   04  00  0  1  3  0           CREATURE MOVEMENT
;_______________________________________________________________________________
; 2    SNGD       63   04  0D  1  2  2  2           SLOW DIGDUG
;_______________________________________________________________________________
; 3    SNGD       63   04  0D  1  1  2  2           FAST DIGDUG
;_______________________________________________________________________________
; 4    SNGNULL    08   00  00  0  7  0  0           THE SOUND OF SILENCE
;_______________________________________________________________________________
; 5    SNG1       08   01  01  1  1  3  3           ROCK CRUSHING MONSTER
;_______________________________________________________________________________
; 6    SNG2       08   0D  00  0  1  3  0           ROCK HITTING GROUND/DIGDUG
;_______________________________________________________________________________
; 7    SNG3       10   07  04  1  1  3  3           FLAME NOISE
;_______________________________________________________________________________
; 8    SNG5       09   04  00  0  2  3  0           DIGDUG THROWING HARPOON
;_______________________________________________________________________________
; 9    SNG4       24   04  00  0  0  0  0           PUMP CREATURE
;_______________________________________________________________________________
;10    SNG6       20   04  00  0  0  4  0           POP CREATURE
;_______________________________________________________________________________
;11    SNG7       08   00  00  0  2  7  0           ROCK FALLING
;_______________________________________________________________________________
;12    SNG8       05   04  0D  1  3  4  7           GOTCHA SOUND
;_______________________________________________________________________________
;13    SNG9       31   04  0D  1  3  4  3           CREATURE ESCAPING
;_______________________________________________________________________________
;14    SNG10      06   04  00  0  2  7  0           EAT VEGETABLE
;_______________________________________________________________________________
;15    SNG11      12   04  00  0  6  5  0           BONUS MAN
;_______________________________________________________________________________
;16    SNG12      23   0D  0D  1  3  3  3           SPEEDUP MUSIC
;_______________________________________________________________________________
;17    SNG13      21   04  0D  1  6  4  4           RACKEND
;_______________________________________________________________________________
;18    SNG14      16   0D  0D  1  3  0  0           DIGDUG DEATH
;_______________________________________________________________________________
;19    SNG15      63   04  0D  1  4  4  4           ENTRANCE
;_______________________________________________________________________________




NOISE     CPY     SNGTEMP1               ;REQUEST SOUND
          BCC     NOISE5
          STY     SNGTEMP1               ;HIGHEST PRIORITY OVERRIDES
NOISE5
*         RTS                            ;ASSUME RTS FOLLOWS DIRECTLY

GLVSOUND  RTS
DNEWSONG  JSR     SAVDUN                 ;SAVE CURRENT DD INFO (USES A AND Y)
GNEWSONG  JMP     NEWSONG
SOUND
*         LDA     ENTRY                  ;UPDATE SECOND TIMER
*         BNE     NOTSEC
          LDA     FRMCNT
          CMP     NXTSEC
          BNE     NOTSEC
*         CLC                            ;CARRY IS SET
          ADC     #60-1                  ;CHANGE FOR PAL/SECAM
          STA     NXTSEC
          INC     SCNDTIM
          LDA     SPEEDUP
          BEQ     NOTSECA
          DEC     SPEEDUP
NOTSECA   LDA     GHOSTOUT
          BEQ     NOTSEC
          DEC     GHOSTOUT
NOTSEC
          LDA     NONOISE                ;OK TO MAKE NOISE?
          BEQ     SOUND2
          LDA     #0                     ;IF NOT, SHUT OFF NOISE
          STA     AUDV0
          STA     AUDV1
          STA     CURSONG
          STA     SNGTEMP1
HLVSOUND  RTS
;
SOUND2    LDA     CURSONG                ;HIGHER PRIORITY SOUNDS OVERRIDE LOWER
          CMP     SNGTEMP1               ;SONGS DON'T INTERRUPT THEMSELVES
          BNE     SOUND2A
          CMP     #SNG1                  ;ROCK CRUSHING CREATURE? --- ALLOWED
          BEQ     SOUND2B                ;     TO OVERRIDE ITSELF (SPECIAL CASE)
          CMP     #SNG4                  ;INFLATING CREATURE? --- ALLOWED
          BEQ     SOUND2B                ;     TO OVERRIDE ITSELF (SPECIAL CASE)
          BNE     SOUNDOK
SOUND2A   BCS     SOUNDOK
SOUND2B   JSR     DIGSONG                ;CURRENT SONG IS DD MUSIC? (USES A)
          BNE     SOUND2C
          JSR     SAVDUN                 ;SAVE DIGDUG MUSIC INFO (USES A AND Y)
SOUND2C   LDA     SNGTEMP1               ;START NEW SONG
          STA     CURSONG
          LDY     #0
          STY     SNGTEMP1
          JSR     DIGSONG                ;CURRENT SONG IS NOT DD MUSIC? (USES A)
          BEQ     SNGCON
          JSR     INITALLS               ;SETS A TO 0, USES Y
          BMI     SOUNDOK
SNGCON    LDY     #6                     ;RESTORE DIGDUG MUSIC INFO
SNGCON2   LDA     DURINDX0,Y
          STA     CURINDX0,Y
          DEY
          BPL     SNGCON2

SOUNDOK   LDA     CURSONG
HNEWSONG  BEQ     GNEWSONG

          JSR     DIGSONG                ;DIGDUG MUSIC?  (USES A)
          BNE     SOUND1C
SOUND1A   LDA     WALKING
          BEQ     DNEWSONG
          LDA     DETHWISH
          ORA     DEATH
          BNE     DNEWSONG
SOUND1C

          DEC     DURCTR                 ;NOTE DONE?
          BPL     HLVSOUND
          LDX     CURSONG                ;CURRENT SONG
          LDA     SNGHBF0,X
          STA     SNGPTR+1
          DEC     CURINDX0               ;BYTE DONE?
          BPL     SETDUR
          BIT     REST0                  ;REST?
          BPL     NEWBYTF0
          LDA     #0
          STA     REST0
          STA     AUDV0
          STA     CURINDX0
          BPL     SETDUR
NEWBYTF0  INC     TUNINDX0               ;DECODE NEXT BYTE
          LDY     TUNINDX0
          TYA
          CMP     SNGLEN,X               ;CURRENT SONG DONE?
          BNE     NOTDONE
          TXA
          JSR     DIGSONG                ;DIGDUG MUSIC? (USES A)
          BNE     JNEWSONG
          JSR     INITDIGS
JNEWSONG  JMP     NEWSONG
NOTDONE   LDA     SNGLBF0,X
          STA     SNGPTR
          LDA     (SNGPTR),Y
          STA     REST0
          STA     AUDF0                  ;SET FREQUENCY 0
          AND     #$60
*         CLC
*         ROL     A
          ASL     A
          ROL     A
          ROL     A
          ROL     A
          STA     CURINDX0
          LDA     (SNGPTR),Y
          AND     #$1F                   ;FREQUENCY OF 0 MEANS VOLUME OF 0
          BEQ     SETVOL0
          LDA     SNGVV0,X               ;ABNORMAL CASE FOR VOLUME?
          AND     #$0F
          BNE     SETVOL0
          LDA     SNG4V0,Y
          CPX     #SNG4                  ; FOR NOW .....
          BEQ     SETVOL0
          LDA     SNG14V0,Y
SETVOL0   STA     AUDV0                  ;SET VOLUME 0
          LDA     SNGC0,X                ;ABNORMAL CASE FOR CONTROL?
          AND     #$0F
          BNE     SETCON0
          LDA     SNG7C0,Y
SETCON0   STA     AUDC0                  ;SET CONTROL 0
SETDUR    LDA     SNGDM,X                ;SET NOTE DURATION
          STA     DURCTR
;
; SECOND VOICE
          LDA     SNGLBF1,X              ;SECOND VOICE NEEDED
          BEQ     KILLVC2
          STA     SNGPTR
NEWNOTF1  DEC     CURINDX1               ;BYTE DONE?
          BPL     LVSOUND
          BIT     REST1                  ;REST?
          BPL     NEWBYTF1
          LDA     #0
          STA     REST1
          STA     CURINDX1
KILLVC2   STA     AUDV1
          RTS
NEWBYTF1  INC     TUNINDX1               ;DECODE NEXT BYTE
          LDY     TUNINDX1
          LDA     (SNGPTR),Y
          STA     REST1
          STA     AUDF1                  ;SET FREQUENCY 1
          AND     #$60
*         CLC
*         ROL     A
          ASL     A
          ROL     A
          ROL     A
          ROL     A
          STA     CURINDX1
          LDA     (SNGPTR),Y
          AND     #$1F                   ;FREQUENCY OF 0 MEANS VOLUME OF 0
          BEQ     SETVOL1
          LDA     SNGVV0,X               ;ABNORMAL CASE FOR VOLUME?
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          BNE     SETVOL1
          LDA     SNG14V1,Y
SETVOL1   STA     AUDV1                  ;SET VOLUME 1
          LDA     SNGC0,X
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          STA     AUDC1                  ;SET CONTROL 1
LVSOUND   RTS

NEWSONG
          LDA     #0
          STA     AUDV0
          STA     AUDV1
          STA     SNGTEMP1

          LDX     CURSONG
          STA     CURSONG
          CPX     #5                     ;SPACE SOUNDS
          BCS     SOUND14A
          LDA     DETHWISH
          ORA     DEATH
          ORA     SQUASH
          ORA     ENTRY
          BNE     SOUND14A
          LDA     WALKING
          BEQ     SOUND14
          LDA     FAST
          LDY     #SNGD
          ORA     ESCAPER
          BEQ     SOUND13A
          LDY     #SNGDF
SOUND13A  JMP     NOISE                  ;NOISE IS A SUBR
SOUND14   CPX     #SNGNULL               ;SOUND JUST ENDED IS SILENCE?
          BEQ     SOUND15
          CPX     #SNGC                  ;SOUND JUST ENDED IS CMOVEMENT?
          BEQ     SOUND15
SOUND14A  LDY     #SNGNULL               ;SOUND OF SILENCE
          BPL     SOUND13A
SOUND15   LDY     #SNGC                  ;START UP CRITTER MOVE NOISE
          BPL     SOUND13A


INITALLS  LDY     #4
          LDA     #0
INITSND   STA     CURINDX0,Y
          DEY
          BPL     INITSND
          STY     TUNINDX0
          STY     TUNINDX1
          RTS

COPYRGHT  DB      $47,$43,$43,$28,$43,$29,$31,$39,$38,$34

ENDSOUND
