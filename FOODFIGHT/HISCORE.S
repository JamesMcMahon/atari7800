; HISCORE.S
; THIS FILE CONTAINS THE HANDLERS FOR THE INTERFACE TO THE HISCORE
;         MODULE.  "MKHISCOR" AND "MKENTER" INITIATE MODES;
;         "HISCORE" AND "ENTER" JUST LOOP IN WAIT.


          GLBL    XDMAON,XDMAOFF
          GLBL    MKHISCOR
          GLBL    MKENTER
          GLBL    MKLOGO
          GLBL    DRAWLOGO
          GLBL    HSCRTN

          GLBL    HSCROM,HSCSCORE,HSCDIFF
          GLBL    HSCRAM

          GLBL    TUNER,DLISTB,DLIST9,DLIST8,DLIST7
          GLBL    NMIRTN
          GLBL    DLI1,PL0SCORE,PL1SCORE,M160X2
          GLBL    COLRINIT
          GLBL    DLLRAM
          GLBL    NULL2,TXTLIST1,DWORDL,DWORDH,DWORDLEN
          GLBL    COLORS
          GLBL    DPPINIT,CLEARALL
          GLBL    PREFRESH

; HIGH SCORE: ROM IS AT 800, RAM IS AT 1000

HSCATRCT  EQU     $3FFA
HSCENTER  EQU     $3FFD
HSCSTAT   EQU     $3FF7

          RAMDEF                         ; ZERO PAGE

          RSEG    CODE2

MKHISCOR  LDA     #H(DLISTB)             ; DON'T SET WRITE MODE ANYMORE
          STA     DLLRAM+1
          LDA     #L(DLISTB)
          STA     DLLRAM+2

          JSR     BUILDHSC
          JSR     FHISCORE

          JMP     HSCATRCT               will RTS

MKENTER   MOVE    HOWHARD,TEMP4

          JSR     BUILDHSC
          JSR     FENTER

          JMP     HSCENTER               will RTS

; COME HERE IF 1) NO HSC, 2) HSC IS OVER

HSCMISS   PLA                            pops two levels out
          PLA
          RTS

; SETUP HISCORE PARAMETERS

BUILDHSC  LDA     $3900
          CMP     #$C6
          BNE     HSCMISS

          LDA     $3904
          CMP     #$FE
          BNE     HSCMISS

          DMAOFF

INITARGS
          LDX     #$0F                   copy into RAM
COPYHSC0  LDA     HSCROM,X
          STA     HSCRAM,X
          DEX
          BPL     COPYHSC0

          LDA     #L(HSCDLI1)            ; ENSURE THAT I'M IN VBLANK
          STA     DLIADR
          LDA     #H(HSCDLI1)
          STA     DLIADR+1

          LDA     TEMP4                  ; DIFFICULTY LEVEL FOR THIS CALL
          TAX
          ASL     A                      ;  --CALLED 4 TIMES FROM "LOGO"
          ASL     A
          ORA     CURRENT
          STA     HSCRAM+2

          LDA     CURRENT
          BEQ     BUILDRTS

          LDA     #L(PL1SCORE)           ; 2ND PLAYER
          STA     HSCRAM+8
          LDA     #H(PL1SCORE)
          STA     HSCRAM+9

BUILDRTS
          RTS

FHISCORE  LDY     #H(HSCRAM)             for HSCSTAT

          JSR     HSCSTAT                see if cart is here
          BMI     HSCMISS                if negative, no table for this level

FENTER    ONSCREEN                       make sure i'm offscreen
          INVBLANK

          JSR     DRAWLOGO               ; LOAD UP DISPLAY LISTS

          JSR     PUTDNAME               ; "TEMP4" SET IN "LOGO"

          JSR     INITARGS               since they're in a dlist

          JSR     PREFRESH               make sure new colors are stored

          LDY     #H(HSCRAM)             for the following routine

          LDA     #4                     four seconds
          STA     HSCRAM+14

REETS     RTS

; THIS TABLE IS COPIED INTO RAM WHEN HSC IS CALLED.  IT'S THE ARGUMENT BLOCK
;         NEEDED BY THE HSC.

HSCROM    DB      $23,$23                ; CARTRIDGE ID NUMBER

          DB      $00                    ; DIFFICULTY LEVEL
                                         ;  + PLAYER NUMBER (BOTTOM 2 BITS)
          DB      $00                    ; CONTROLLER TYPE

          DB      $00,$00                ; HSC NAME-- IGNORED IF I HAVE A DLIST

          DB      $00,$00                ; MAKES HSC COPY 14 MORE SCAN LINES
                                         ;   FOR DISPLAY LIST WITH NAME
          DB      L(PL0SCORE),H(PL0SCORE)   ; POINTER TO THE SCORE
                                         ;   WILL BE PL0SCORE OR PL1SCORE
          DB      L(HSCDLL),H(HSCDLL)    ; DLIST LIST POINTER FOR LOGO

          DB      L(REETS),H(REETS)      ; SOUND ROUTINE

          DB      $00                    ; SECONDS TO WAIT BEFORE RETURNING
                                         ;  (FOR EACH DIFFICULTY LEVEL)

HSCDLL    DB      $8F
          DB      H(DLISTB),L(DLISTB)    ; NULL LIST; DLI FOR MODE CHANGE

          DB      $0D
          DB      H(DLISTB),L(DLISTB)

          DB      $0F                    ; USE "MKLOGO" TO DO THIS
          DB      H(DLIST9),L(DLIST9)

          DB      $0F
          DB      H(DLIST8),L(DLIST8)

          DB      $09                    ; BRINGS NUMBER TO 70 LINES
          DB      H(DLISTB),L(DLISTB)

          DB      $07                    ; DISPLAYS DIFFICULTY NAME
          DB      H(DLIST7),L(DLIST7)

;         DB      $82
;         DB      H(DLISTB),L(DLISTB)

HSCDLI1   LDA     #L(HSCDLI2)            ; OCCURS AT TOP OF SCREEN
         STA     DLIADR
         LDA     #H(HSCDLI2)
         STA     DLIADR+1

          LDA     #$50                   ; 160X2, 2 BYTE CHARACTERS
          STA     CTRL

          LDA     #$E8
          STA     CHARBASE

          JMP     NMIRTN

HSCDLI2   LDA     #L(HSCDLI1)            ; CHANGE BACK FOR HSC DISPLAY
          STA     DLIADR
          LDA     #H(HSCDLI1)            ; CHANGED FROM (HSCDLI2) [ROB 6.19.84]
          STA     DLIADR+1

          STA     WSYNC
          STA     WSYNC

          LDA     #$4B
          STA     CTRL

          LDA     #$39
          STA     CHARBASE

          JMP     NMIRTN

; THIS ROUTINE IS CALLED FROM THE TWO ABOVE ROUTINES TO INSERT
;         THE DIFFICULTY NAME INTO DLIST7.

PUTDNAME  LDX     #11                    ; BLANK OUT TXTLIST1
          LDA     #NULL2
HSLOLP0   STA     TXTLIST1,X
          DEX
          BNE     HSLOLP0

          LDA     #$19                   ; COLORS FOR TEXT
          STA     COLORS+20
          LDA     #$15
          STA     COLORS+21
          LDA     #$1F
          STA     COLORS+22

          LDA     #L(TXTLIST1)
          STA     DLIST7
          LDA     #$60
          STA     DLIST7+1
          LDA     #H(TXTLIST1)
          STA     DLIST7+2
          LDA     #$B4                   ; PALETTE 5, WIDTH 12
          STA     DLIST7+3

          LDA     #0
          STA     DLIST7+6

          LDX     TEMP4                  ; UPDATE DIFFICULTY WORD

          LDA     DWORDL,X               ; COPY WORD INTO "TXTLIST2"
          STA     TEMP0
          LDA     DWORDH,X
          STA     TEMP1

          LDA     HSWPOS,X
          STA     DLIST7+4               ; HPOS

          LDY     DWORDLEN,X

HSDIFFLP  LDA     (TEMP0),Y
          STA     TXTLIST1,Y
          DEY
          BPL     HSDIFFLP

          RTS

; This routine is called after calls to HSC are done, from LOGO and INIT

HSCRTN
          ONSCREEN
          INVBLANK

          JSR     COLRINIT

          JSR     CLEARALL

          JSR     DPPINIT                reset DPP, turning DMA on
                                         ; waits for vblank
          LDA     #$E8
          STA     CHARBASE

          LDA     #L(DLI1)               we're in vblank
          STA     DLIADR
          LDA     #H(DLI1)
          STA     DLIADR+1

          RTS

HSWPOS    DB      48,32,48,56

          END

