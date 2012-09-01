
*  TUNES.S - SOUND DRIVER


*  TURN OFF ALL SOUNDS
STOPTUN   LDA     #$00                   ;TURN OFF SOUNDS
          STA     AUDV0
          STA     AUDV1
          LDA     #$01
          STA     TUNOFF
          RTS


*  TURN ON ALL SOUNDS
STARTTUN  LDX     #$01
STTLOOP   LDA     TUNON,X                ;SEE IF TUNE IS ON
          BEQ     STTLNEXT
          LDY     VOLOFF,X               ;GET OFFSET FOR VOLUME
          DEY
          DEY
          LDA     TUNBASE,X              ;GET ADDRESS OF TUNE
          STA     SOUNDZP
          LDA     TUNBASE1,X
          STA     SOUNDZP+1
          LDA     (SOUNDZP),Y            ;STORE THE VOLUME
          STA     AUDV0,X
STTLNEXT  DEX
          BPL     STTLOOP
          LDA     #$00
          STA     TUNOFF
          RTS


*  THIS ROUTINE ENTERS A TUNE INTO ONE OF THE SOUND CHANNELS IF IT CAN
*  INPUT:  TUNE NUMBER IN A
*  X AND Y ARE PRESERVED
DOTUNE    STA     TUNNUM                 ;SAVE IT
          LDA     AUTOPLAY               ;IF IN AUTOPLAY - NO SOUND
          BEQ     DTCONT
          RTS
DTCONT    TXA                            ;STACK REGISTERS
          PHA
          TYA
          PHA

          LDY     TUNNUM                 ;SEE IF WE CAN PUT IT IN
          LDX     TCHANNEL,Y             ;GET WHAT CHANNEL TO TRY TO PUT IT IN
          LDA     TUNON,X                ;SEE IF CHANNEL OPEN
          BEQ     DTDOIT
          LDA     TPRIOR,Y               ;SEE IF WE CAN BUMP CHANNEL
          CMP     TUNPRIOR,X
          BMI     DTOUT

DTDOIT    LDA     TUNNUM
          JSR     BEGINTUN               ;GOT IT

DTOUT     PLA                            ;UNSTACK REGISTERS
          TAY
          PLA
          TAX
          RTS


*  ROUTINE TO KILL A PARTICULAR TUNE - IF IT IS RUNNING
*  INPUT: TUNE NUMBER IN A
*  X AND Y ARE PRESERVED
KILLTUNE  STA     TUNNUM                 ;SAVE IT
          TXA                            ;STACK REGISTERS
          PHA
          TYA
          PHA
          LDX     #$01                   ;CHECK ALL CHANNELS
KTLOOP    LDA     TUNON,X                ;SEE IF CHANNEL ON
          BEQ     KTNEXT
          LDA     TUNINDEX,X             ;SEE IF HAS TUNE TO BE KILLED
          CMP     TUNNUM
          BNE     KTNEXT
          JSR     ENDTUNE                ;ERASE IT
KTNEXT    DEX
          BPL     KTLOOP
          PLA                            ;UNSTACK REGISTERS
          TAY
          PLA
          TAX
          RTS


*  THIS ROUTINE ERASES ALL TUNES
*  X AND Y ARE PRESERVED
CLEARTUN  TXA                            ;STACK REGISTERS
          PHA
          TYA
          PHA
          LDX     #$01
CTLOOP    JSR     ENDTUNE                ;ERASE CURRENT TUNE
          DEX
          BPL     CTLOOP
          PLA                            ;UNSTACK REGISTERS
          TAY
          PLA
          TAX
          RTS


*  THIS ROUTINE IS CALLED EVERY VBLANK TO TAKE CARE OF TUNES
*  REGISTERS ARE NOT SAVED
TUNER     LDX     #$01                   ;TWO TUNES CHANNELS, START WITH SECOND
          LDA     TUNOFF
          BEQ     TUNLOOP
          RTS

TUNLOOP   LDA     TUNON,X
          BNE     TUNBODY
          STA     AUDV0,X                ;CHANNEL OFF - MAKE SURE VOLUME OFF
          JMP     TUNNEXT

TUNBODY   LDA     TUNBASE,X              ;GET ADDRESS OF TUNE
          STA     SOUNDZP
          LDA     TUNBASE1,X
          STA     SOUNDZP+1

          DEC     FREQTIME,X             ;DO FREQUENCY
          BNE     TUNCTL
          JSR     TNXTFREQ               ;TIME FOR NEXT FREQUENCY
TUNCTL    LDA     CTLTIME,X              ;DO CONTROL
          BEQ     TUNVOL                 ;IS CTL CONSTANT? (STARTS AT 0)
          DEC     CTLTIME,X
          BNE     TUNVOL
          JSR     TNXTCTL                ;TIME FOR NEXT CTL
TUNVOL    LDA     VOLTIME,X              ;DO VOLUME
          BEQ     TUNNEXT                ;IS VOLUME CONSTANT? (STARTS AT 0)
          DEC     VOLTIME,X
          BNE     TUNNEXT
          JSR     TNXTVOL                ;TIME FOR NEXT VOLUME

TUNNEXT   DEX                            ;DONE WITH THAT TUNE, IS THERE ANOTHER?
          BPL     TUNLOOP
          RTS                            ;ALL DONE

*  ROUTINES TO GET NEXT FREQUENCY, CTL, OR VOLUME

*  THIS ROUTINE GETS NEXT FREQUENCY
TNXTFREQ  LDY     FREQOFF,X              ;GET INDEX INTO TABLE
          LDA     (SOUNDZP),Y            ;GET FREQUENCY
          BMI     TNFENDT                ;IS THIS THE END OF THE TUNE?
          STA     AUDF0,X
          INY
          LDA     (SOUNDZP),Y            ;GET DURATION
          STA     FREQTIME,X
          INY
          TYA
          STA     FREQOFF,X
          RTS
TNFENDT   CMP     #$FF                   ;SEE IF TUNE OVER
          BEQ     TNFEOVER
          CMP     #$FE                   ;SEE IF TUNE REPEATS
          BEQ     TNFEREPT
          INY                            ;ANOTHER TUNE COMING
          LDA     (SOUNDZP),Y            ;FIND OUT WHICH TUNE
          JSR     BEGINTUN               ;START TUNE
          JMP     TNFEOUT

TNFEREPT  LDA     TUNINDEX,X             ;TUNE REPEATS - RESTART IT
          JSR     BEGINTUN               ;START TUNE
          JMP     TNFEOUT

TNFEOVER  JSR     ENDTUNE                ;TUNE FINISHED
TNFEOUT   PLA                            ;END OF TUNE
          PLA                            ;GET RID OF WHERE WE ARE RTS'ING TO
          JMP     TUNLOOP                ;UPDATE THIS CHANNEL


*  THIS ROUTINE GETS NEXT CONTROL BYTE
TNXTCTL   LDY     CTLOFF,X               ;GET INDEX INTO TABLE
          LDA     (SOUNDZP),Y            ;GET FREQUENCY
          STA     AUDC0,X
          INY
          LDA     (SOUNDZP),Y            ;GET DURATION
          STA     CTLTIME,X
          INY
          TYA
          STA     CTLOFF,X
          RTS


*  THIS ROUTINE GETS NEXT VOLUME BYTE
TNXTVOL   LDY     VOLOFF,X               ;GET INDEX INTO TABLE
          LDA     (SOUNDZP),Y            ;GET FREQUENCY
          STA     AUDV0,X
          INY
          LDA     (SOUNDZP),Y            ;GET DURATION
          STA     VOLTIME,X
          INY
          TYA
          STA     VOLOFF,X
          RTS


*  THIS ROUTINE CLEARS OUT A TUNE CHANNEL
*  INPUT: X IS CHANNEL
ENDTUNE   LDA     #$00
          STA     TUNON,X                ;INDICATE CHANNEL CLEAR
          STA     TUNINDEX,X             ;CLEAR TUNE INDEX
          RTS


*  THIS ROUTINE STARTS A TUNE IN A CHANNEL
*  INPUT: X IS CHANNEL, A IS TUNE
*  USES:  Y
BEGINTUN  TAY                            ;PUT TUNE IN Y
          STA     TUNINDEX,X             ;SET THE TUNE INDEX
          LDA     #$00                   ;TURN TUNE OFF WHILE CHANGING IT
          STA     TUNON,X
          LDA     TBASE,Y                ;SET THE BASE ADDRESS FOR TUNE
          STA     TUNBASE,X
          LDA     TBASE1,Y
          STA     TUNBASE1,X
          LDA     #$00                   ;FREQUENCY IS AT START OF TUNE
          STA     FREQOFF,X
          LDA     TCTLOFF,Y              ;SET CONTROL OFFSET
          STA     CTLOFF,X
          LDA     TVOLOFF,Y              ;SET VOLUME OFFSET
          STA     VOLOFF,X
          LDA     TPRIOR,Y               ;SET PRIORITY
          STA     TUNPRIOR,X
          LDA     #$01                   ;SET FREQ, CTL, AND VOL TO BE SET
          STA     FREQTIME,X             ;  NEXT VBLANK (TICK DOWN TO 0 EACH)
          STA     CTLTIME,X
          STA     VOLTIME,X
          STA     TUNON,X                ;AND TURN THE TUNE ON!
          RTS


*  DATA FOR TUNES

*  TUNE TABLES, BASE ADDRESSES FOR TUNES AND THE OFFSETS WITHIN THE TUNES WHERE
*  THE CTL AND VOL INFORMATION START
TBASE     DB      L(TINTRO0),L(TINTRO1),L(TANIM10),L(TANIM11),L(TANIM20A)
          DB      L(TANIM20B),L(TANIM21A),L(TANIM21B),L(TANIM30),L(TANIM31)
          DB      L(TBACKG),L(TFRTBNC),L(TPACDTH),L(TENERGA),L(TENERGB)
          DB      L(TENERGC),L(TMUNCH),L(TEATMON),L(TEATFRT),L(TEYES)
          DB      L(TBONUS)
TBASE1    DB      H(TINTRO0),H(TINTRO1),H(TANIM10),H(TANIM11),H(TANIM20A)
          DB      H(TANIM20B),H(TANIM21A),H(TANIM21B),H(TANIM30),H(TANIM31)
          DB      H(TBACKG),H(TFRTBNC),H(TPACDTH),H(TENERGA),H(TENERGB)
          DB      H(TENERGC),H(TMUNCH),H(TEATMON),H(TEATFRT),H(TEYES)
          DB      H(TBONUS)
TCTLOFF   DB      $2D,$2B,$63,$1F,$82,$5D,$42,$3F,$37,$25
          DB      $11,$03,$51,$62,$52,$09,$07,$1F,$27,$15
          DB      $03
TVOLOFF   DB      $2F,$2D,$7B,$21,$92,$73,$44,$41,$3D,$27
          DB      $13,$05,$55,$64,$54,$0B,$13,$21,$29,$17
          DB      $05
TPRIOR    DB      0,0,0,0,0,0,0,0,0,0
          DB      0,4,8,4,4,4,0,6,5,8
          DB      9
TCHANNEL  DB      0,1,0,1,0,0,1,1,0,1
          DB      0,1,1,0,0,0,1,1,1,0
          DB      1

*  TUNE 0 - FIRST VOICE OF INTRODUCTION
TINTRO0   DB      $00,$0C,$1B,$10,$15,$10,$18,$10,$14,$10        ;FREQ
          DB      $15,$08,$14,$08,$12,$08,$15,$08,$18,$10,$14,$10
          DB      $15,$08,$14,$08,$12,$08,$15,$08
          DB      $14,$08,$12,$08,$10,$08,$0E,$08
          DB      $0D,$10,$0E,$10,$0D,$10,$FF
          DB      $04,$00                                        ;CTL
          DB      $0C,$00                                        ;VOL

*  TUNE 1 - SECOND VOICE OF INTRODUCTION
TINTRO1   DB      $0B,$04,$0A,$04,$09,$04,$12,$20                ;FREQ
          DB      $18,$20,$12,$20
          DB      $13,$08,$12,$08,$10,$08,$13,$08
          DB      $12,$08,$10,$08,$0E,$08,$12,$08
          DB      $10,$08,$12,$08,$13,$08,$10,$08
          DB      $12,$10,$18,$10,$12,$10,$FF
          DB      $0D,$00                                        ;CTL
          DB      $08,$1C,$00,$10,$08,$10,$00,$10,$08,$10        ;VOL
          DB      $00,$10,$08,$00

*  TUNE 2 - FIRST VOICE, FIRST ANIMATION
TANIM10   DB      $1A,$08,$17,$08,$1A,$08,$1F,$10                ;FREQ
          DB      $0D,$08,$0B,$08,$0A,$08,$1F,$20
          DB      $0B,$08,$1F,$08,$0B,$08,$0D,$08
          DB      $1A,$08,$17,$08,$1A,$08,$1F,$10
          DB      $0D,$08,$0B,$10,$0D,$28,$14,$08,$11,$08,$10,$08
          DB      $0F,$08,$00,$08,$0F,$04,$00,$04,$11,$04,$0F,$04
          DB      $11,$08,$14,$08,$17,$08,$1A,$08
          DB      $17,$08,$1A,$08,$17,$08,$14,$08
          DB      $14,$08,$17,$08,$1A,$08,$1F,$08
          DB      $0B,$08,$1F,$08,$0B,$08,$0D,$08
          DB      $0B,$08,$0D,$08,$0F,$08,$11,$08,$14,$18,$FF
          DB      $04,$28,$0D,$18,$04,$20,$0D,$08,$04,$08,$0D,$10    ;CTL
          DB      $04,$28,$0D,$40,$04,$98,$0D,$08,$04,$08,$0D,$00
          DB      $0C,$00                                        ;VOL

*  TUNE 3 - SECOND VOICE, FIRST ANIMATION
TANIM11   DB      $14,$C0,$1B,$40                                ;FREQ
          DB      $14,$20,$17,$20,$1A,$20,$1B,$20
          DB      $14,$10,$11,$10
          DB      $0F,$10,$0D,$10
          DB      $0B,$08,$0D,$08,$0F,$08,$11,$08,$14,$10,$FF
          DB      $0D,$00                                        ;CTL
          DB      $00,$08,$09,$08,$00,$08,$09,$04,$00,$04        ;VOL
          DB      $09,$10,$00,$18
          DB      $09,$08,$00,$08,$09,$04,$00,$04
          DB      $09,$10,$00,$18
          DB      $09,$08,$00,$08,$09,$04,$00,$04
          DB      $09,$10,$00,$18
          DB      $09,$08,$00,$08,$09,$04,$00,$04
          DB      $09,$10,$00,$10
          DB      $09,$88,$00,$08,$09,$08,$00,$08
          DB      $09,$08,$00,$08,$09,$08,$00,$08,$09,$00

*  TUNE 4 - FIRST VOICE, SECOND ANIMATION
TANIM20A  DB      $0B,$06,$1F,$06,$1D,$06,$1B,$0C,$1D,$06,$1B,$06,$00,$06 ;FREQ
          DB      $1B,$06,$1A,$06,$18,$06,$17,$0C,$18,$06,$17,$06,$00,$06
          DB      $0D,$06,$0F,$06,$11,$06,$13,$06
          DB      $14,$06,$13,$06,$1F,$06,$1B,$06
          DB      $1A,$18,$00,$0C,$0B,$06,$00,$06
          DB      $14,$06,$13,$06,$12,$06,$11,$06
          DB      $1A,$06,$17,$06,$15,$06,$14,$06
          DB      $1A,$06,$14,$06,$1A,$06,$0B,$0C,$0C,$06,$0B,$06,$0C,$06
          DB      $0B,$18,$1D,$18,$1B,$1E,$00,$12
          DB      $13,$06,$14,$06,$1B,$06,$1A,$06
          DB      $14,$06,$17,$06,$1F,$06,$1D,$06
          DB      $1B,$06,$17,$06,$0D,$06,$0F,$0C,$11,$06,$13,$06,$17,$06
          DB      $1F,$12,$00,$06,$0B,$12,$00,$06,$FD,$05
          DB      $0D,$06,$04,$AE,$0D,$06,$04,$48,$0D,$36        ;CTL
          DB      $04,$C0,$0D,$12,$04,$00
          DB      $0C,$00                                        ;VOL

*  TUNE 5 - SECOND PART TO TUNE 4
TANIM20B  DB      $14,$06,$13,$06,$12,$06,$11,$06                ;FREQ
          DB      $0B,$06,$1F,$06,$1D,$06,$1B,$06
          DB      $14,$06,$13,$06,$12,$06,$11,$06
          DB      $1A,$06,$17,$06,$15,$06,$14,$06
          DB      $1A,$06,$14,$06,$1A,$06,$0B,$12,$0D,$06,$0B,$06
          DB      $1F,$18,$0A,$18,$1F,$24,$00,$0C
          DB      $13,$06,$14,$06,$17,$06,$1A,$0C,$17,$06,$14,$06,$00,$06
          DB      $14,$06,$17,$06,$1A,$06,$0B,$0C,$1A,$06,$1B,$06,$1F,$06
          DB      $0B,$18,$1B,$06,$13,$06,$1F,$06,$1B,$06,$1A,$24,$FF
          DB      $04,$18,$0D,$06,$04,$54,$0D,$1E                ;CTL
          DB      $04,$18,$0D,$18,$04,$72,$0D,$0C,$04,$12
          DB      $0D,$18,$04,$00
          DB      $0C,$00                                        ;VOL

*  TUNE 6 - SECOND VOICE, SECOND ANIMATION
TANIM21A  DB      $17,$8A,$14,$03,$12,$03                        ;FREQ
          DB      $11,$0C,$0D,$0C,$17,$0C,$0D,$0C
          DB      $11,$0C,$0D,$0C,$17,$0C,$0D,$0C
          DB      $11,$0C,$0D,$0C,$17,$0C,$0D,$0C
          DB      $11,$0C,$0D,$0C,$17,$0C,$0E,$0C
          DB      $0F,$0C,$0B,$0C,$17,$0C,$0B,$06,$0E,$06
          DB      $0F,$0C,$0B,$0C,$17,$0C,$0B,$0C
          DB      $0F,$0C,$0B,$0C,$17,$0C,$0B,$0C,$FD,$07
          DB      $0D,$00                                        ;CTL
          DB      $09,$18,$00,$18,$09,$18,$00,$18                ;VOL
          DB      $09,$0C,$00,$0C,$09,$0C,$00,$06,$09,$12
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06

*  TUNE 7 - SECOND PART TO TUNE 6
TANIM21B  DB      $0F,$18,$17,$18                                ;FREQ
          DB      $11,$06,$0F,$06,$0E,$06,$0D,$12,$0F,$06,$17,$06
          DB      $11,$0C,$0D,$0C,$17,$0C,$0D,$0C
          DB      $11,$0C,$0D,$0C,$17,$0C,$0D,$0C
          DB      $1A,$0C,$0F,$0C,$14,$0C,$0D,$0C
          DB      $1A,$0C,$0F,$0C,$14,$0C,$17,$0C
          DB      $1A,$30,$17,$30,$12,$18,$17,$18
          DB      $11,$0C,$17,$0C,$11,$0C,$FF
          DB      $0D,$00                                        ;CTL
          DB      $09,$06,$00,$12,$09,$06,$00,$12                ;VOL
          DB      $09,$18,$00,$06,$09,$12
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06
          DB      $09,$06,$00,$1E,$09,$06,$00,$06
          DB      $09,$06,$00,$1E,$09,$06,$00,$12
          DB      $09,$06,$00,$12,$09,$06,$00,$06
          DB      $09,$06,$00,$06,$09,$06,$00,$06,$09,$06,$00,$06

*  TUNE 8 - FIRST VOICE, THIRD ANIMATION
TANIM30   DB      $1B,$0A,$1D,$0A,$1B,$0A,$17,$14,$18,$0A,$17,$14    ;FREQ
          DB      $0B,$0A,$1F,$0A,$1D,$0A,$1B,$14,$1D,$0A,$1B,$14
          DB      $14,$0A,$17,$0A,$14,$0A,$12,$14,$0D,$0A,$0F,$14
          DB      $00,$14,$11,$0A,$00,$1E,$11,$0A,$00,$0A
          DB      $00,$0A,$14,$14,$17,$0A,$11,$0A,$FF
          DB      $04,$50,$0D,$0A,$04,$00                        ;CTL
          DB      $0C,$00                                        ;VOL

*  TUNE 9 - SECOND VOICE, THIRD ANIMATION
TANIM31   DB      $0F,$1E,$12,$14,$0F,$0A,$10,$0A,$11,$0A        ;FREQ
          DB      $12,$1E,$0F,$14,$17,$0A,$12,$0A,$0F,$0A
          DB      $11,$1E,$0F,$1E,$11,$14
          DB      $12,$3C,$12,$1E
          DB      $11,$14,$0F,$0A,$12,$0A,$FF
          DB      $0D,$00                                        ;CTL
          DB      $09,$0A,$00,$14,$09,$3C,$00,$14,$09,$3C        ;VOL
          DB      $00,$14,$09,$32,$00,$14,$09,$0A,$00,$1E,$09,$0A
          DB      $00,$14,$09,$00

*  TUNE A - BACKGROUND SOUND
TBACKG    DB      $19,$01,$04,$01,$15,$01,$03,$01                ;FREQ
          DB      $11,$01,$02,$01,$0C,$01,$01,$01,$FE
          DB      $04,$00                                        ;CTL
          DB      $04,$00                                        ;VOL

*  TUNE B - FRUIT BOUNCE
TFRTBNC   DB      $1F,$06,$FF                                    ;FREQ
          DB      $0F,$00                                        ;CTL
          DB      $0C,$00                                        ;VOL

*  TUNE C - PAC DEATH
TPACDTH   DB      $18,$02,$19,$02,$1A,$02,$1B,$02                ;FREQ
          DB      $1C,$02,$1D,$02,$1E,$02,$1F,$02
          DB      $1C,$02,$1D,$02,$1E,$02,$1F,$02
          DB      $0A,$02,$0B,$02,$0C,$02,$0D,$02
          DB      $0A,$02,$0B,$02,$0C,$02,$0D,$02
          DB      $0E,$02,$0F,$02,$10,$02,$11,$02
          DB      $0E,$02,$0F,$02,$10,$02,$11,$02
          DB      $12,$02,$13,$02,$14,$02,$15,$02
          DB      $12,$02,$13,$02,$14,$02,$15,$02
          DB      $16,$02,$17,$02,$18,$02,$19,$02,$FF
          DB      $04,$18,$0D,$00                                ;CTL
          DB      $0C,$04,$0B,$04,$0A,$04,$09,$04                ;VOL
          DB      $0B,$04,$0A,$04,$09,$04,$08,$04
          DB      $0A,$04,$09,$04,$08,$04,$07,$04
          DB      $09,$04,$08,$04,$07,$04,$06,$04
          DB      $08,$04,$07,$04,$06,$04,$05,$04

* SOUND D - ENERGIZE SOUND
TENERGA   DB      $1F,$02,$1E,$02,$1D,$02,$1C,$02                ;FREQ
          DB      $1F,$02,$1E,$02,$1D,$02,$1C,$02
          DB      $1E,$02,$1D,$02,$1C,$02,$1B,$02
          DB      $1D,$02,$1C,$02,$1B,$02,$1A,$02
          DB      $1C,$02,$1B,$02,$1A,$02,$19,$02
          DB      $1B,$02,$1A,$02,$19,$02,$18,$02
          DB      $1A,$02,$19,$02,$18,$02,$17,$02
          DB      $19,$02,$18,$02,$17,$02,$16,$02
          DB      $18,$02,$17,$02,$16,$02,$15,$02
          DB      $17,$02,$16,$02,$15,$02,$14,$02
          DB      $16,$02,$15,$02,$14,$02,$13,$02
          DB      $15,$02,$14,$02,$13,$02,$12,$02,$FD,$0E
          DB      $0D,$00                                        ;CTL
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02                ;VOL
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02

*  TUNE E - SECOND PART OF TUNE D
TENERGB   DB      $14,$02,$13,$02,$12,$02,$11,$02
          DB      $13,$02,$12,$02,$11,$02,$10,$02
          DB      $12,$02,$11,$02,$10,$02,$0F,$02
          DB      $11,$02,$10,$02,$0F,$02,$0E,$02
          DB      $10,$02,$0F,$02,$0E,$02,$0D,$02
          DB      $0F,$02,$0E,$02,$0D,$02,$0C,$02
          DB      $0E,$02,$0D,$02,$0C,$02,$0B,$02
          DB      $0D,$02,$0C,$02,$0B,$02,$0A,$02
          DB      $0C,$02,$0B,$02,$0A,$02,$09,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02,$FD,$0F
          DB      $0D,$00                                        ;CTL
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02                ;VOL
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0B,$02,$0A,$02,$09,$02,$08,$02
          DB      $0A,$02,$09,$02,$08,$02,$07,$02
          DB      $09,$02,$08,$02,$07,$02,$06,$02
          DB      $08,$02,$07,$02,$06,$02,$05,$02
          DB      $07,$02,$06,$02,$05,$02,$04,$02

* SOUND F - THIRD PART OF SOUND D
TENERGC   DB      $09,$02,$08,$02,$07,$02,$06,$02,$FE            ;FREQ
          DB      $0D,$00                                        ;CTL
          DB      $05,$00                                        ;VOL

* SOUND 10 - MUNCH SOUND
TMUNCH    DB      $18,$01,$14,$01,$12,$01,$FF                    ;FREQ
          DB      $0D,$01,$04,$01,$0D,$01,$04,$01,$0D,$01,$04,$01  ;CTL
          DB      $08,$00                                        ;VOL

* SOUND 11 - EAT MONSTER
TEATMON   DB      $18,$02,$17,$02,$16,$04                        ;FREQ
          DB      $15,$02,$14,$02,$13,$04
          DB      $13,$01,$12,$01,$11,$01,$10,$01
          DB      $0F,$01,$0E,$01,$0D,$01,$0C,$01,$0B,$01,$FF
          DB      $0D,$00                                        ;CTL
          DB      $0A,$01,$09,$01,$08,$01,$07,$01,$06,$02,$00,$02  ;VOL
          DB      $0A,$01,$09,$01,$08,$01,$07,$01,$06,$02,$00,$02
          DB      $0A,$02,$09,$02,$08,$01,$07,$01,$06,$02

* SOUND 12 - EAT FRUIT
TEATFRT   DB      $0D,$01,$0E,$01,$0D,$01,$0E,$01                ;FREQ
          DB      $0F,$01,$10,$01,$11,$01,$12,$01
          DB      $13,$01,$14,$02,$13,$01
          DB      $12,$01,$11,$01,$10,$01,$0F,$01
          DB      $0E,$01,$0D,$01,$0C,$01,$0B,$01,$FF
          DB      $0D,$00                                        ;CTL
          DB      $08,$02,$07,$02,$06,$02,$04,$04                ;VOL
          DB      $06,$02,$07,$02,$08,$00

* SOUND 13 - EYES
TEYES     DB      $12,$01,$00,$01,$11,$01,$00,$01,$10,$01        ;FREQ
          DB      $00,$01,$0E,$01,$00,$01,$0C,$01,$00,$01,$FE
          DB      $04,$00                                        ;CTL
          DB      $08,$00                                        ;VOL

* SOUND 14 - DING DING (BONUS LIFE)
TBONUS    DB      $0A,$50,$FF                                    ;FREQ
          DB      $04,$00                                        ;CTL
          DB      $0C,$05,$00,$05,$0C,$05,$00,$05
          DB      $0C,$05,$00,$05,$0C,$05,$00,$05
          DB      $0B,$05,$00,$05,$0A,$05,$00,$05
          DB      $09,$05,$00,$05,$08,$05,$00,$05
