; INPUT.S
; THIS FILE CONTAINS THE INPUT ROUTINES "POLE" AND "REPLAY"

          GLBL    POLE
          GLBL    REPLAY

          GLBL    SWCHA,INPT4
          GLBL    CDIR,THROWBUT,JOYDIR
          GLBL    TRUE,FALSE
          GLBL    TEMP0,TEMP1

          GLBL    FRAMEIDX,THROWIDX
          GLBL    IRDIRA,IRDIRB,IRTHROW
          GLBL    IRDIRC,IRDIRD

          RAMDEF                         ; ZERO PAGE

CODE      CSECT

POLE      LDA     INPT4
          BPL     SETBUTTN
          LDA     #FALSE
          JMP     ZSETOVER
SETBUTTN  LDA     #TRUE                  ; BUTTON IS DOWN
ZSETOVER  STA     THROWBUT

          LDA     SWCHA
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          TAX
          LDA     JOYTABLE,X             ; USE UPPER NIBBLE AS TABLE INDEX
          CMP     #8
          BEQ     ZNOERR

          STA     CDIR

ZNOERR    STA     JOYDIR

; NOW SAVE AWAY VALUES IN THE INSTANT REPLAY TABLES :
;   NOTE: DIRTAB CONTAINS POINTERS TO THE FOUR DIRECTION TABLES.
;         EACH ONE OF THESE HAS 128 LOCATIONS, ACCOUNTING FOR 256
;         VALUES OF FRAMEIDX; THIS REPRESENTS 8 SECONDS OF GAMEPLAY.

          LDX     FRAMEIDX+1
          LDA     DIRTABL,X
          STA     TEMP0
          LDA     DIRTABH,X
          STA     TEMP1

          LDA     FRAMEIDX
          LSR     A                      ; GET INDEX AS WELL AS NIBBLE
          TAY
          BCC     ZUPNIB01               ; ODD FRAME == UPPER NIBBLE

          LDA     (TEMP0),Y
          ORA     JOYDIR                 ; UPPER NIBBLE ALREADY IN A
          STA     (TEMP0),Y
          JMP     ZINSKIP1

ZUPNIB01  LDA     JOYDIR
          ASL     A
          ASL     A
          ASL     A
          ASL     A                      ; PUT INTO UPPER NIBBLE
          STA     (TEMP0),Y
          JMP     ZINSKIP1

; JOYSTICK STORAGE IS FINISHED-- DO THE BUTTON STORAGE

ZINSKIP1  LDA     THROWBUT               ; IF THE BUTTON IS UP, LEAVE A
          BEQ     ZINPTBYE               ;  ZERO IN THE BIT FOR THIS CYCLE

          LDA     FRAMEIDX
          AND     #$7                    ; TELLS WHICH BIT OF IRTHROW
          TAY
          LDA     TRUEBUT,Y              ; MASK FOR PROPER BIT
          AND     #TRUE                  ; ALL 1'S
          LDX     THROWIDX               ; INC'ED EVERY EIGHTH CYCLE
          ORA     IRTHROW,X              ; ADDS IN THIS NEXT BIT
          STA     IRTHROW,X

ZINPTBYE  RTS

; THIS ROUTINE IS CALLED INSTEAD OF "POLE" DURING INSTANT REPLAY.  IT
;         PRETENDS THAT IT'S LOOKING AT THE CONTROLS, BUT INSTEAD IT'S
;         LOOKING AT TABLES STORED UP FROM THE PREVIOUS RACK

REPLAY    LDX     FRAMEIDX+1
          LDA     DIRTABL,X
          STA     TEMP0
          LDA     DIRTABH,X
          STA     TEMP1

          LDA     FRAMEIDX
          LSR     A
          TAY
          BCC     ZUPNIB02
          LDA     (TEMP0),Y              ; LOWER NIBBLE
          AND     #$0F
          JMP     ZSETD02

ZUPNIB02  LDA     (TEMP0),Y
          LSR     A
          LSR     A
          LSR     A
          LSR     A

ZSETD02   STA     JOYDIR
          CMP     #8
          BEQ     ZRPSKIP1

          STA     CDIR

ZRPSKIP1  LDA     FRAMEIDX
          AND     #7
          TAY
          LDA     TRUEBUT,Y
          LDX     THROWIDX
          AND     IRTHROW,X              ; GET THE BIT FOR THIS FRAME
          BEQ     ZNOTHROW               ; IF 0, BUTTON IS UP

          LDA     #TRUE
          JMP     ZRPSETB

ZNOTHROW  LDA     #FALSE
ZRPSETB   STA     THROWBUT

          RTS

JOYTABLE  DB      $FF,$FF,$FF,$FF,$FF,$03,$01,$02
          DB      $FF,$05,$07,$06,$FF,$04,$00,$08

TRUEBUT   DB      $01,$02,$04,$08,$10,$20,$40,$80

DIRTABL   DB      L(IRDIRA),L(IRDIRB),L(IRDIRC),L(IRDIRD)

DIRTABH   DB      H(IRDIRA),H(IRDIRB),H(IRDIRC),H(IRDIRD)

          END
