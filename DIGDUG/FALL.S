;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                                                    ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;    FALL: CALLED FROM INIT EVERY FRAME.             ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;          HANDLES ROCK FALLING.                     ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;          SQUASHES CREATURES.                       ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;          SQUASHES DIGDUG.                          ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;          SETS FRUIT TO 1 WHEN 2ND ROCK DROPPED.    ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;          SETS DEATH IF DETHWISH SET AND ROCKS DONE.;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


FALL      LDA     #0
          STA     ROCKSNOW               ;COUNT OF ROCKS FALLING
          LDX     #NUMROCK               ;HANDLE EVERY ROCK
MOREROCK  STX     CURROCK
          JSR     ROCKMOV
          LDX     CURROCK
          DEX
          BPL     MOREROCK
          LDX     ROCKSNOW
          BNE     ENDROCK
          LDA     DETHWISH
          BEQ     ENDROCK
          STX     DETHWISH               ;ASSUME X IS 0
          INX
          STX     DEATH
ENDROCK   RTS


ROCKMOV   LDY     TUMBLE,X               ;ROCK STATE
          CPY     #ONEDGE
          BCC     ENDROCK
ROCKMOV1  INC     ROCKSNOW               ;UPDATE COUNT OF ROCKS FALLING
          LDA     DOROCKL-2,Y
          STA     RTEMP
          LDA     DOROCKH-2,Y
          STA     RTEMP+1
          JMP     (RTEMP)                ;DISPATCH TO CORRECT SUBR


RSLIP     LDY     #SNG7                  ;ROCK FALLING NOISE
          JSR     NOISE
ENDSTAT1  JMP     ENDSTAT2               ;UPDATE ROCK STATE

RTOTTER   LDY     #TOTRROCK
          LDA     ROCKSTAT,X
          AND     #$08
          BEQ     RTOTTER1
          LDY     #STRTROCK
RTOTTER1  STY     ROCKSIX,X
          INC     ROCKSTAT,X
          LDA     ROCKSTAT,X
          CMP     #$19
          BCS     ENDSTAT1
          CMP     #$08
          BCC     ENDROCK
          CMP     #$18
          BNE     DOAVOID
          LDA     #SETFLEE               ;MAKE CREATURES MORE LIKELY TO GHOST
          STA     FLEE
DOAVOID   JMP     AVOID                  ;WARN CREATURES (AVOID IS A SUBR)


GROUND    LDX     CURROCK
          BPL     ENDSTAT1

RFALL     LDY     ROCKSY,X               ;DON'T FALL OFF SCREEN
          CPY     #MINDDY
          BEQ     GROUND
          LDA     ROCKSTAT,X
RFALLOOP  CMP     #$07
          BCC     RFALL0
*         SEC
          SBC     #$07
          BNE     RFALLOOP
RFALL0    TAY
          LDA     ROCKSY,X
          SEC
          SBC     RFALLTBL,Y
          STA     ROCKSY,X
          LDY     ROCKSTAT,X
          CPY     #6
          BCC     CRUSH

          LDA     #H(SOUTH7)
          STA     DRTPTR+1
          LDA     ROCKSY,X
*         SEC
ROCKOFST  SBC     #12                    ;GET DISTANCE ABOVE ROW
          CMP     #12
          BCS     ROCKOFST
          CMP     #10
          BEQ     ROCKONE
          CMP     #4
          BEQ     ROCKHALF
          CMP     #11
          BNE     CRUSH

RKBOUND   JSR     ROCKPUSH               ;USES TEMP+0, RETURNS DIRTMAP,X IN A
          CPX     #$F0                   ;DON'T FALL OFF SCREEN
          BCS     GROUND
          CMP     #36
          BCC     CRUSH
          CMP     #48                    ;*** MARIA 1 BOWTIE  (48)
          BEQ     CRUSH
          CMP     #44                    ;*** MARIA 1 CUP     (44)
          BEQ     CRUSH
          BNE     GROUND


ROCKHALF  JSR     ROCKPUSH               ;USES TEMP+0, RETURNS DIRTMAP,X IN A
          CMP     #36
          BCC     CRUSH
          CMP     #48                    ;BOWTIE DIRT *** MARIA 1 (48)
          BNE     GROUND                 ;STOP AT CUP DIRT
          LDA     #20                    ;*** MARIA 1 (20)
          STA     DIRTMAP,X
          BPL     CRUSH


ROCKONE   LDA     #L(SOUTH1)             ;TO
          STA     DRTPTR
          JSR     ROCKPUSH               ;USES TEMP+0
          CMP     #36
          BCS     ROCKONE3
          LDY     #L(VERTBOT)
          STY     DRTPTR
          JSR     BORE1
ROCKONE3

ROCKONE2  LDA     #L(VERTTOP)            ;FROM
          STA     DRTPTR
          LDX     CURROCK
          LDA     ROCKSX,X
          PHA
          LDA     ROCKSY,X
          TAX
          PLA
          JSR     CALCINDX
          CMP     #36
          BCS     CRUSH
          JSR     BORE1


CRUSH     LDX     CURROCK

          LDY     #NUMCREAT
SQLOOP    LDA     MONSTAT,Y              ;ENABLED AND GBNF NOT SET?
          AND     #$86
          BMI     SQNXT
          CMP     #$02
          BEQ     SQNXT
          PHA
          LDA     POOKAX,Y
          STA     VICTIMX
          PLA
          CMP     #$06
          BNE     NOTBLOW
          LDA     BLWYPOS,Y
          BNE     DOCRUNCH
NOTBLOW   LDA     POOKAY,Y
DOCRUNCH  JSR     CRUNCH                 ;CHECK FOR SQUASH, CALC CREATURE YPOS
          BCC     SQNXT
          STA     POOKAY,Y
          LDA     MONSTAT,Y
          AND     #$40                   ;NOT ALREADY SQUASHED?
          BNE     CALREDSQ
          TXA                            ;CURROCK
          STA     ROCKNUM,Y              ;SAVE NUMBER OF GUILTY ROCK
          STY     RTEMP
          LDY     #SNG1                  ;SQUASH CREATURE SOUND
          JSR     NOISE
          LDY     RTEMP
CALREDSQ  LDA     MONSTAT,Y
          AND     #$F9                   ;TURN OFF PUMPED FLAGS
          ORA     #$41                   ;SET SQUASH AND FREEZE FLAGS
          STA     MONSTAT,Y
          LDX     #SQPOOKA
          TYA                            ;COULD SAVE BYTE HERE
          AND     #$04                   ;POOKA?
          BEQ     SQANIM
          LDX     #SQFYGAR
          CPY     FLAMIE                 ;SQUASHED CREATURE FLAMING?
          BNE     SQANIM
          LDA     #0
          STA     FLAMIE                 ;STOP FLAMING
          STA     FLAMEY                 ;DON'T DISPLAY FLAME
SQANIM    STX     POOKAIX,Y
          LDX     CURROCK
          CPY     PUMPIE                 ;SQUASHED CREATURE PUMPEE?
          BNE     SQNXT
          JSR     VANPUMP                ;FOUND IN COLLISON
;                                        ;USES A
;                                        ;CLEARS PUMPY ETC., SETS PUMPIE TO FF
SQNXT     DEY
          BPL     SQLOOP

          LDA     DDXPOS
          STA     VICTIMX
          LDA     DDYPOS
          JSR     CRUNCH                 ;CHECK FOR SQUASH, CALC DDYPOS
          BCC     RFALL3
          STA     DDYPOS
          JSR     VANPUMP                ;FOUND IN COLLISON
;                                        ;USES A
;                                        ;CLEARS PUMPY ETC., SETS PUMPIE TO FF
          LDY     SQUASH                 ;NOT ALREADY SQUASHED?
          BNE     DALREDSQ
          LDY     #SNG1
          JSR     NOISE
DALREDSQ  LDY     #1
          STY     SQUASH                 ;SET DIGDUG SQUASHING FLAG
          LDA     #SQDIGDUG
          STA     DDINDX
RFALL3    INC     ROCKSTAT,X
          JMP     AVOID                  ;AVOID IS A SUBR

RBOTTOM
*         LDA     ROCKSTAT,X
*         BNE     RBOTTOM2

          LDA     #0
          STA     FLEE                   ;ASSUME A = 0

*         LDY     #0                     ;DO THIS JUST ONCE
*         LDX     #NUMCREAT
*SQCNT     LDA     MONSTAT,X
*         AND     #$40                   ;SQUASHED?
*         BEQ     SQCNTNXT
*         INY                            ;UPDATE SQUASHED CREATURE COUNT
*SQCNTNXT  DEX
*         BPL     SQCNT

*         LDX     CURROCK
*         TYA
*         STA     NUMSQSH,X

          INC     ROCKSTAT,X
          LDA     ROCKSTAT,X
          CMP     #$10
          BCC     RBOTTOM3               ;GO RETURN

          JSR     ENDSTAT2               ;UPDATE ROCKSTATE (RETURNS 0 IN A)

          STA     NUMSQSH,X              ;INIT COUNT OF CRUSHED CREATURES
          LDY     #NUMCREAT
VANLOOP   LDA     MONSTAT,Y              ;STOP DISPLAYING CRUSHED CREATURES
          AND     #$40
          BEQ     VANNXT
          TXA                            ;CURROCK
          CMP     ROCKNUM,Y              ;GUILTY ROCK?
          BNE     VANNXT
          INC     NUMSQSH,X              ;UPDATE COUNT OF CRUSHED CREATURES
          LDA     #0
          STA     POOKAY,Y
VANNXT    DEY
          BPL     VANLOOP

          LDY     #SNG2                  ;HIT GROUND SOUND
          JMP     NOISE                  ; NOISE IS A SUBR

RBOTTOM3  LDY     ESCAPER                ;PREVENT ESCAPE MUSIC FROM SOUNDING 2X
          BNE     ENDFALL2
          CMP     #$01                   ;RESTORE MODES
          BEQ     DOGMODE
          RTS

RSPLIT
RCRUMBL   LDA     RKANIM-6,Y
DORPOINT  STA     ROCKSIX,X
          INC     ROCKSTAT,X
          LDA     ROCKSTAT,X
          CMP     RKTIM-6,Y
          BCC     ENDFALL2
ENDSTAT2  LDA     #0
          STA     ROCKSTAT,X
          INC     TUMBLE,X
ENDFALL2  RTS

RPOINTS   LDY     NUMSQSH,X
          BEQ     ENDSTAT2
*         DEY
          LDA     DISPTS-1,Y             ;POINT DISPLAY
          LDY     #$08                   ;TUMBLE,X
          BNE     DORPOINT

RFINISH   LDA     #0
          STA     TUMBLE,X
          STA     ROCKSY,X
          DEC     ROCKSNOW               ;DECREMENT # OF ROCKS FALLING
          INC     FALLCNT
          LDA     FALLCNT
          CMP     #2
          BNE     NOVEG
          LSR     A
          STA     FRUIT
NOVEG     LDA     SQUASH                 ;DIGDUG WANTS TO DIE FROM SQUASHING?
          BEQ     ROCKDETH
          LDY     #0
          STY     SQUASH
          INY
          STY     DETHWISH

ROCKDETH  LDY     #NUMCREAT
SQDEAD    TXA                            ;CURROCK
          CMP     ROCKNUM,Y              ;GUILTY ROCK?
          BNE     SQDEDNXT
          LDA     MONSTAT,Y
          AND     #$40
          BEQ     SQDEDNXT
          ASL     A                      ;MARK AS DISABLED
          STA     MONSTAT,Y
SQDEDNXT  DEY
          BPL     SQDEAD

          LDY     NUMSQSH,X              ;POINT VALUES STORED HALVED
          BEQ     ENDFALL2
          DEY
          TYA
          ASL     A
          TAX
          LDA     FLATPTS,X
          INX
          LDY     FLATPTS,X
          STX     RTEMP
          JSR     ADDSCORE
          LDX     RTEMP
          LDY     FLATPTS,X
          DEX
          LDA     FLATPTS,X
          JSR     ADDSCORE

DOGMODE   JMP     GETMODE                ;CREATURES REDO STRATEGY
                                         ;GETMODE IS A SUBR

