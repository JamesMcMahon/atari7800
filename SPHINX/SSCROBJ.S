********SSCROBJ.S NEW SCROLLING OBJECT SHIT
;          ZERODEF

;          RSEG    CODEF

; SCRLOAD SCANS THE SCROLLING OBJECT BUFFER FOR STAMPS THAT ARE READY TO BE
; LOADED, AND PUTS THEM INTO THE LOADER TABLES.
; IT IS RUN ONCE EVERY COARSE SCROLL.

SCRBUFSZ  EQU     10                     ; SIZE OF SCROLLING OBJECT BUFFER
INITVP    EQU     $F1                    ; INITIAL VP FOR MOST OBJECTS


SCRLDRTS:
	RTS

SCRLOAD:  BIT     GCOARSE
          BPL     SCRLDRTS               ; DO ONLY ON COARSE SCROLLS
          LDX     #SCRBUFSZ
SCRLDLP:  DEX
          BMI     SCRLDRTS               ; ALL DONE
          LDY     STAMPID,X
          BMI     SCRLDLP                ; NOT AN ACTIVE BUFFER SLOT
          DEC     ZONESBK,X
          BPL     SCRLDLP                ; NOT TIME YET

          STX     TEMP0                  ; SAVE X SINCE WE ARE LOADING THIS ONE
          LDA     HPOS,X
          STA     TEMP1                  ; WE NEED THE HPOS ALL OVER THE PLACE

          JSR     GETASLOT               ; GET SLOT NUMBER FOR OBJECT IN X
          BPL     FUCKTHIS               ; NO SLOT AVAILABLE SO PUNT
          JMP     SCRPUNT

FUCKTHIS: LDA     SCRSL,Y                ; START FILLING IN LOADER TABLES
          STA     SLTBL,X
          LDA     SCRSH,Y
          STA     SHTBL,X
          LDA     SCRSM,Y
          STA     SMTBL,X
          LDA     SCRPW,Y
          STA     PWTBL,X

          LDA     TEMP1                  ; HPOS
          CLC
          ADC     SCRHOFF,Y
          SEC
          SBC     SCRDELTA
          STA     HPTBL,X

          LDA     SCRVP,Y
          CLC
          ADC     SCRDELTA
          STA     VPTBL,X

          LDA     SCRY,Y
          STA     YTBL,X

          LDA     SCRCOL,Y
          STA     COLSTAT,X
          BEQ     NOCOLBOX               ; NO COLISION BOX FOR THIS STAMP
          LDA     TEMP1                  ; HPOS
          LSR     
          CLC
          ADC     SCRXOFF,Y              ; ARE THESE AFFECTED BY SCRDELTA ????
          STA     COLX1,X
          CLC
          ADC     SCRWDTH,Y
          STA     COLX2,X
          LDA     TEMP1                  ; HPOS
          LSR     
          CLC
          ADC     SCRZOFF,Y
          STA     COLZ1,X
          CLC
          ADC     SCRDPTH,Y
          STA     COLZ2,X
          LDA     SCRYOFF,Y
          STA     COLY1,X
          CLC
          ADC     SCRHGHT,Y
          STA     COLY2,X

NOCOLBOX: LDA     SCRDX,Y
          CMP     #$FF
          BEQ     AHIERO
          SEC
          SBC     SCRDELTA
AHIERO:   STA     TEMP6
          CLC
          ADC     SCRDD,Y                ; CALCULATE DF
          STA     TEMP10

          JSR     OBJINS                 ; PUT IT IN THE LINKED LIST

          CPY     #20
          BNE     DISP1
          JSR     MINIINIT
          JMP     SCRPUNT
DISP1:    CPY     #22
          BNE     DISP2
          JSR     FIREINIT
          JMP     SCRPUNT
DISP2:    CPY     #30
          BNE     DISP3
          JSR     SXFLINIT
          JMP     SCRPUNT
DISP3:    CPY     #31
          BNE     SCRPUNT
          JSR     SXFHINIT

SCRPUNT:  LDX     TEMP0                  ; GET SET TO CONTINUE
          LDA     #$FF
          STA     STAMPID,X              ; MARK BUFFER SLOT AS UNUSED
          INC     FRBUFPTR               ; PUSH BUFFER SLOT BACK ONTO STACK
          LDY     FRBUFPTR
          TXA
          STA     FRBUFSTK,Y
          JMP     SCRLDLP

SCRSL:
          .dc.b      CANEH&$FF           ; HIERO 1                       0
          .dc.b      MANWSTAF&$FF        ; HIERO 2                       1
          .dc.b      FEATHER&$FF         ; HIERO 3                       2
          .dc.b      EYEH&$FF            ; HIERO 4                       3
          .dc.b      AHNKH&$FF           ; HIERO 5                       4
          .dc.b      BIRDH&$FF           ; HIERO 6                       5
          .dc.b      SUNOWTRH&$FF        ; HIERO 7                       6
          .dc.b      BOWLH&$FF           ; HIERO 8                       7
          .dc.b      GEM&$FF             ; JEWEL 1                       8
          .dc.b      EGG&$FF             ; JEWEL 2                       9
          .dc.b      BAR&$FF             ; JEWEL 3                      10
          .dc.b      BIGPYR0&$FF         ; SM PYR BOT                   11
          .dc.b      BIGPYR1&$FF         ; SM PYR TOP                   12
          .dc.b      OPEPYR0&$FF         ; LG PYR BOT                   13
          .dc.b      OPEPYR1&$FF         ; LG PYR MID                   14
          .dc.b      OPEPYR2&$FF         ; LG PYR TOP                   15
          .dc.b      OBELISK0&$FF        ; OBELISK BOT                  16
          .dc.b      OBELISK1&$FF        ; OBELISK MID                  17
          .dc.b      OBELISK2&$FF        ; OBELISK TOP                  18
          .dc.b      MINISPH0&$FF        ; MINI BOT                     19
          .dc.b      MINISPH1&$FF        ; MINI TOP                     20
          .dc.b      POT&$FF             ; FIRE POT                     21
          .dc.b      TIP1&$FF            ; FIRE TIP                     22
          .dc.b      SPHINXL1&$FF        ; SPHINX LEFT BOT              23
          .dc.b      SPHINXL2&$FF        ; SPHINX LEFT                  24
          .dc.b      SPHINXL3&$FF        ; SPHINX LEFT                  25
          .dc.b      SPHINXL4&$FF        ; SPHINX LEFT TOP              26
          .dc.b      SPHINXR2&$FF        ; SPHINX RIGHT BOT             27
          .dc.b      SPHINXR3&$FF        ; SPHINX RIGHT                 28
          .dc.b      SPHINXR4&$FF        ; SPHINX RIGHT TOP             29
          .dc.b      SPFACE1L&$FF        ; SPHINX FACE BOT              30
          .dc.b      SPFACE1H&$FF        ; SPHINX FACE TOP              31

SCRSH:
          .dc.b      CANEH/256               ; HIERO 1
          .dc.b      MANWSTAF/256            ; HIERO 2
          .dc.b      FEATHER/256             ; HIERO 3
          .dc.b      EYEH/256                ; HIERO 4
          .dc.b      AHNKH/256               ; HIERO 5
          .dc.b      BIRDH/256               ; HIERO 6
          .dc.b      SUNOWTRH/256            ; HIERO 7
          .dc.b      BOWLH/256               ; HIERO 8
          .dc.b      GEM/256                 ; JEWEL 1
          .dc.b      EGG/256                 ; JEWEL 2
          .dc.b      BAR/256                 ; JEWEL 3
          .dc.b      BIGPYR0/256             ; SM PYR BOT
          .dc.b      BIGPYR1/256             ; SM PYR TOP
          .dc.b      OPEPYR0/256             ; LG PYR BOT
          .dc.b      OPEPYR1/256             ; LG PYR MID
          .dc.b      OPEPYR2/256             ; LG PYR TOP
          .dc.b      OBELISK0/256            ; OBELISK BOT
          .dc.b      OBELISK1/256            ; OBELISK MID
          .dc.b      OBELISK2/256            ; OBELISK TOP
          .dc.b      MINISPH0/256            ; MINI BOT
          .dc.b      MINISPH1/256            ; MINI TOP
          .dc.b      POT/256                 ; FIRE POT
          .dc.b      TIP1/256                ; FIRE TIP
          .dc.b      SPHINXL1/256            ; SPHINX LEFT BOT
          .dc.b      SPHINXL2/256            ; SPHINX LEFT
          .dc.b      SPHINXL3/256            ; SPHINX LEFT
          .dc.b      SPHINXL4/256            ; SPHINX LEFT TOP
          .dc.b      SPHINXR2/256            ; SPHINX RIGHT BOT
          .dc.b      SPHINXR3/256            ; SPHINX RIGHT
          .dc.b      SPHINXR4/256            ; SPHINX RIGHT TOP
          .dc.b      SPFACE1L/256            ; SPHINX FACE BOT
          .dc.b      SPFACE1H/256            ; SPHINX FACE TOP

SCRSM:
          .dc.b      (CANEH+$1100-$1000)/256    ; HIERO 1
          .dc.b      (MANWSTAF+$1100-$1000)/256 ; HIERO 2
          .dc.b      (FEATHER+$1100-$1000)/256  ; HIERO 3
          .dc.b      (EYEH+$1100-$1000)/256     ; HIERO 4
          .dc.b      (AHNKH+$1100-$1000)/256    ; HIERO 5
          .dc.b      (BIRDH+$1100-$1000)/256    ; HIERO 6
          .dc.b      (SUNOWTRH+$1100-$1000)/256 ; HIERO 7
          .dc.b      (BOWLH+$1100-$1000)/256    ; HIERO 8
          .dc.b      (GEM+$1100-$1000)/256      ; JEWEL 1
          .dc.b      (EGG+$1100-$1000)/256      ; JEWEL 2
          .dc.b      (BAR+$1100-$1000)/256      ; JEWEL 3
          .dc.b      (BIGPYR0+$1100-$1000)/256  ; SM PYR BOT
          .dc.b      (BIGPYR1+$1100-$1000)/256  ; SM PYR TOP
          .dc.b      (OPEPYR0+$1100-$1000)/256  ; LG PYR BOT
          .dc.b      (OPEPYR1+$1100-$1000)/256  ; LG PYR MID
          .dc.b      (OPEPYR2+$1100-$1000)/256  ; LG PYR TOP
          .dc.b      (OBELISK0+$1100-$1000)/256 ; OBELISK BOT
          .dc.b      (OBELISK1+$1100-$1000)/256 ; OBELISK MID
          .dc.b      (OBELISK2+$1100-$1000)/256 ; OBELISK TOP
          .dc.b      (MINISPH0+$1100-$1000)/256 ; MINI BOT
          .dc.b      (MINISPH1+$1100-$1000)/256 ; MINI TOP
          .dc.b      (POT+$1100-$1000)/256      ; FIRE POT
          .dc.b      (TIP1+$1100-$100)/256      ; FIRE TIP
          .dc.b      (SPHINXL1+$1100-$1000)/256 ; SPHINX LEFT BOT
          .dc.b      (SPHINXL2+$1100-$1000)/256 ; SPHINX LEFT
          .dc.b      (SPHINXL3+$1100-$1000)/256 ; SPHINX LEFT
          .dc.b      (SPHINXL4+$1100-$1000)/256 ; SPHINX LEFT TOP
          .dc.b      (SPHINXR2+$1100-$1000)/256 ; SPHINX RIGHT BOT
          .dc.b      (SPHINXR3+$1100-$1000)/256 ; SPHINX RIGHT
          .dc.b      (SPHINXR4+$1100-$1000)/256 ; SPHINX RIGHT TOP
          .dc.b      (SPFACE1L+$1100-$1000)/256 ; SPHINX FACE BOT
          .dc.b      (SPFACE1H+$1100-$1000)/256 ; SPHINX FACE TOP

SCRPW:
          .dc.b      $7E                    ; HIERO 1
          .dc.b      $7D                    ; HIERO 2
          .dc.b      $7E                    ; HIERO 3
          .dc.b      $7D                    ; HIERO 4
          .dc.b      $7D                    ; HIERO 5
          .dc.b      $7E                    ; HIERO 6
          .dc.b      $7D                    ; HIERO 7
          .dc.b      $7D                    ; HIERO 8
          .dc.b      $BE                    ; JEWEL 1
          .dc.b      $9E                    ; JEWEL 2
          .dc.b      $7D                    ; JEWEL 3
          .dc.b      $7C                    ; SM PYR BOT
          .dc.b      $7E                    ; SM PYR TOP
          .dc.b      $77                    ; LG PYR BOT
          .dc.b      $77                    ; LG PYR MID
          .dc.b      $79                    ; LG PYR TOP
          .dc.b      $7E                    ; OBELISK BOT
          .dc.b      $7E                    ; OBELISK MID
          .dc.b      $7E                    ; OBELISK TOP
          .dc.b      $F8                    ; MINI BOT
          .dc.b      $F8                    ; MINI TOP
          .dc.b      $FE                    ; FIRE POT
          .dc.b      $9E                    ; FIRE TIP
          .dc.b      $F7                    ; SPHINX LEFT BOT
          .dc.b      $F7                    ; SPHINX LEFT
          .dc.b      $F7                    ; SPHINX LEFT
          .dc.b      $F7                    ; SPHINX LEFT TOP
          .dc.b      $FA                    ; SPHINX RIGHT BOT
          .dc.b      $FA                    ; SPHINX RIGHT
          .dc.b      $FA                    ; SPHINX RIGHT TOP
          .dc.b      $FD                    ; SPHINX FACE BOT
          .dc.b      $FD                    ; SPHINX FACE TOP

SCRHOFF:
          .dc.b      0                      ; HIERO 1
          .dc.b      0                      ; HIERO 2
          .dc.b      0                      ; HIERO 3
          .dc.b      0                      ; HIERO 4
          .dc.b      0                      ; HIERO 5
          .dc.b      0                      ; HIERO 6
          .dc.b      0                      ; HIERO 7
          .dc.b      0                      ; HIERO 8
          .dc.b      0                      ; JEWEL 1
          .dc.b      0                      ; JEWEL 2
          .dc.b      0                      ; JEWEL 3
          .dc.b      0                      ; SM PYR BOT
          .dc.b      4-16                   ; SM PYR TOP
          .dc.b      0                      ; LG PYR BOT
          .dc.b      0-16                   ; LG PYR MID
          .dc.b      4-32                   ; LG PYR TOP
          .dc.b      0                      ; OBELISK BOT
          .dc.b      0-16                   ; OBELISK MID
          .dc.b      0-32                   ; OBELISK TOP
          .dc.b      0                      ; MINI BOT
          .dc.b      0-16                   ; MINI TOP
          .dc.b      0                      ; FIRE POT
          .dc.b      0                      ; FIRE TIP
          .dc.b      0                      ; SPHINX LEFT BOT
          .dc.b      0-16                   ; SPHINX LEFT
          .dc.b      0-32                   ; SPHINX LEFT
          .dc.b      0-48                   ; SPHINX LEFT TOP
          .dc.b      35-16                  ; SPHINX RIGHT BOT
          .dc.b      35-32                  ; SPHINX RIGHT
          .dc.b      35-48                  ; SPHINX RIGHT TOP
          .dc.b      8-16                   ; SPHINX FACE BOT
          .dc.b      8-32                   ; SPHINX FACE TOP

SCRVP:
          .dc.b      INITVP                 ; HIERO 1
          .dc.b      INITVP                 ; HIERO 2
          .dc.b      INITVP                 ; HIERO 3
          .dc.b      INITVP                 ; HIERO 4
          .dc.b      INITVP                 ; HIERO 5
          .dc.b      INITVP                 ; HIERO 6
          .dc.b      INITVP                 ; HIERO 7
          .dc.b      INITVP                 ; HIERO 8
          .dc.b      INITVP                 ; JEWEL 1
          .dc.b      INITVP                 ; JEWEL 2
          .dc.b      INITVP                 ; JEWEL 3
          .dc.b      INITVP                 ; SM PYR BOT
          .dc.b      INITVP                 ; SM PYR TOP
          .dc.b      INITVP                 ; LG PYR BOT
          .dc.b      INITVP                 ; LG PYR MID
          .dc.b      INITVP                 ; LG PYR TOP
          .dc.b      INITVP                 ; OBELISK BOT
          .dc.b      INITVP                 ; OBELISK MID
          .dc.b      INITVP                 ; OBELISK TOP
          .dc.b      INITVP                 ; MINI BOT
          .dc.b      INITVP                 ; MINI TOP
          .dc.b      INITVP-3               ; FIRE POT
          .dc.b      INITVP-2               ; FIRE TIP
          .dc.b      INITVP                 ; SPHINX LEFT BOT
          .dc.b      INITVP                 ; SPHINX LEFT
          .dc.b      INITVP                 ; SPHINX LEFT
          .dc.b      INITVP                 ; SPHINX LEFT TOP
          .dc.b      INITVP-4               ; SPHINX RIGHT BOT
          .dc.b      INITVP-4               ; SPHINX RIGHT
          .dc.b      INITVP-4               ; SPHINX RIGHT TOP
          .dc.b      INITVP+2               ; SPHINX FACE BOT
          .dc.b      INITVP+2               ; SPHINX FACE TOP

SCRY:
          .dc.b      0                      ; HIERO 1
          .dc.b      0                      ; HIERO 2
          .dc.b      0                      ; HIERO 3
          .dc.b      0                      ; HIERO 4
          .dc.b      0                      ; HIERO 5
          .dc.b      0                      ; HIERO 6
          .dc.b      0                      ; HIERO 7
          .dc.b      0                      ; HIERO 8
          .dc.b      1                      ; JEWEL 1
          .dc.b      1                      ; JEWEL 2
          .dc.b      1                      ; JEWEL 3
          .dc.b      1                      ; SM PYR BOT
          .dc.b      2                      ; SM PYR TOP
          .dc.b      1                      ; LG PYR BOT
          .dc.b      2                      ; LG PYR MID
          .dc.b      3                      ; LG PYR TOP
          .dc.b      1                      ; OBELISK BOT
          .dc.b      2                      ; OBELISK MID
          .dc.b      3                      ; OBELISK TOP
          .dc.b      1                      ; MINI BOT
          .dc.b      2                      ; MINI TOP
          .dc.b      1                      ; FIRE POT
          .dc.b      16                     ; FIRE TIP
          .dc.b      1                      ; SPHINX LEFT BOT
          .dc.b      2                      ; SPHINX LEFT
          .dc.b      3                      ; SPHINX LEFT
          .dc.b      4                      ; SPHINX LEFT TOP
          .dc.b      1                      ; SPHINX RIGHT BOT
          .dc.b      2                      ; SPHINX RIGHT
          .dc.b      3                      ; SPHINX RIGHT TOP
          .dc.b      2                      ; SPHINX FACE BOT
          .dc.b      3                      ; SPHINX FACE TOP

SCRCOL:
          .dc.b      HIEROCOL               ; HIERO 1
          .dc.b      HIEROCOL+1             ; HIERO 2
          .dc.b      HIEROCOL+2             ; HIERO 3
          .dc.b      HIEROCOL+3             ; HIERO 4
          .dc.b      HIEROCOL+4             ; HIERO 5
          .dc.b      HIEROCOL+5             ; HIERO 6
          .dc.b      HIEROCOL+6             ; HIERO 7
          .dc.b      HIEROCOL+7             ; HIERO 8
          .dc.b      TREASCOL               ; JEWEL 1
          .dc.b      TREASCOL+1             ; JEWEL 2
          .dc.b      TREASCOL+2             ; JEWEL 3
          .dc.b      PASSVCOL               ; SM PYR BOT
          .dc.b      PASSVCOL               ; SM PYR TOP
          .dc.b      PASSVCOL               ; LG PYR BOT
          .dc.b      PASSVCOL               ; LG PYR MID
          .dc.b      PASSVCOL               ; LG PYR TOP
          .dc.b      PASSVCOL               ; OBELISK BOT
          .dc.b      PASSVCOL               ; OBELISK MID
          .dc.b      PASSVCOL               ; OBELISK TOP
          .dc.b      PASSVCOL               ; MINI BOT
          .dc.b      MINICOL                ; MINI TOP
          .dc.b      PASSVCOL               ; FIRE POT
          .dc.b      FIRECOL                ; FIRE TIP
          .dc.b      PASSVCOL               ; SPHINX LEFT BOT
          .dc.b      PASSVCOL               ; SPHINX LEFT
          .dc.b      PASSVCOL               ; SPHINX LEFT
          .dc.b      0                      ; SPHINX LEFT TOP
          .dc.b      PASSVCOL               ; SPHINX RIGHT BOT
          .dc.b      PASSVCOL               ; SPHINX RIGHT
          .dc.b      0                      ; SPHINX RIGHT TOP
          .dc.b      SPHNXCOL               ; SPHINX FACE BOT
          .dc.b      0                      ; SPHINX FACE TOP

SCRXOFF:
          .dc.b      -7                     ; HIERO 1
          .dc.b      -7                     ; HIERO 2
          .dc.b      -7                     ; HIERO 3
          .dc.b      -7                     ; HIERO 4
          .dc.b      -7                     ; HIERO 5
          .dc.b      -7                     ; HIERO 6
          .dc.b      -7                     ; HIERO 7
          .dc.b      -7                     ; HIERO 8
          .dc.b      -4                     ; JEWEL 1
          .dc.b      -4                     ; JEWEL 2
          .dc.b      -4                     ; JEWEL 3
          .dc.b      -4                     ; SM PYR BOT
          .dc.b      -2                     ; SM PYR TOP
          .dc.b      -8                     ; LG PYR BOT
          .dc.b      -6                     ; LG PYR MID
          .dc.b      -3                     ; LG PYR TOP
          .dc.b      -3                     ; OBELISK BOT
          .dc.b      -3                     ; OBELISK MID
          .dc.b      -2                     ; OBELISK TOP
          .dc.b      -3                     ; MINI BOT
          .dc.b      -2                     ; MINI TOP
          .dc.b      -2                     ; FIRE POT
          .dc.b      -3                     ; FIRE TIP
          .dc.b      -10                    ; SPHINX LEFT BOT
          .dc.b      4                      ; SPHINX LEFT
          .dc.b      -9                     ; SPHINX LEFT
          .dc.b      0                      ; SPHINX LEFT TOP
          .dc.b      -12                    ; SPHINX RIGHT BOT
          .dc.b      -9                     ; SPHINX RIGHT
          .dc.b      0                      ; SPHINX RIGHT TOP
          .dc.b      -2                     ; SPHINX FACE BOT
          .dc.b      0                      ; SPHINX FACE TOP

SCRWDTH:
          .dc.b      12                     ; HIERO 1
          .dc.b      12                     ; HIERO 2
          .dc.b      12                     ; HIERO 3
          .dc.b      12                     ; HIERO 4
          .dc.b      12                     ; HIERO 5
          .dc.b      12                     ; HIERO 6
          .dc.b      12                     ; HIERO 7
          .dc.b      12                     ; HIERO 8
          .dc.b      6                      ; JEWEL 1
          .dc.b      6                      ; JEWEL 2
          .dc.b      6                      ; JEWEL 3
          .dc.b      8                      ; SM PYR BOT
          .dc.b      4                      ; SM PYR TOP
          .dc.b      17                     ; LG PYR BOT
          .dc.b      12                     ; LG PYR MID
          .dc.b      6                      ; LG PYR TOP
          .dc.b      6                      ; OBELISK BOT
          .dc.b      6                      ; OBELISK MID
          .dc.b      4                      ; OBELISK TOP
          .dc.b      10                     ; MINI BOT
          .dc.b      8                      ; MINI TOP
          .dc.b      5                      ; FIRE POT
          .dc.b      7                      ; FIRE TIP
          .dc.b      6                      ; SPHINX LEFT BOT
          .dc.b      6                      ; SPHINX LEFT
          .dc.b      18                     ; SPHINX LEFT
          .dc.b      0                      ; SPHINX LEFT TOP
          .dc.b      24                     ; SPHINX RIGHT BOT
          .dc.b      18                     ; SPHINX RIGHT
          .dc.b      0                      ; SPHINX RIGHT TOP
          .dc.b      4                      ; SPHINX FACE BOT
          .dc.b      0                      ; SPHINX FACE TOP

SCRYOFF:
          .dc.b      0                      ; HIERO 1
          .dc.b      0                      ; HIERO 2
          .dc.b      0                      ; HIERO 3
          .dc.b      0                      ; HIERO 4
          .dc.b      0                      ; HIERO 5
          .dc.b      0                      ; HIERO 6
          .dc.b      0                      ; HIERO 7
          .dc.b      0                      ; HIERO 8
          .dc.b      1                      ; JEWEL 1
          .dc.b      1                      ; JEWEL 2
          .dc.b      1                      ; JEWEL 3
          .dc.b      1                      ; SM PYR BOT
          .dc.b      8                      ; SM PYR TOP
          .dc.b      1                      ; LG PYR BOT
          .dc.b      11                     ; LG PYR MID
          .dc.b      22                     ; LG PYR TOP
          .dc.b      1                      ; OBELISK BOT
          .dc.b      20                     ; OBELISK MID
          .dc.b      39                     ; OBELISK TOP
          .dc.b      1                      ; MINI BOT
          .dc.b      9                      ; MINI TOP
          .dc.b      1                      ; FIRE POT
          .dc.b      16                     ; FIRE TIP
          .dc.b      1                      ; SPHINX LEFT BOT
          .dc.b      1                      ; SPHINX LEFT
          .dc.b      1                      ; SPHINX LEFT
          .dc.b      0                      ; SPHINX LEFT TOP
          .dc.b      1                      ; SPHINX RIGHT BOT
          .dc.b      1                      ; SPHINX RIGHT
          .dc.b      0                      ; SPHINX RIGHT TOP
          .dc.b      SPHNXNSY               ; SPHINX FACE BOT
          .dc.b      0                      ; SPHINX FACE TOP

SCRHGHT:
          .dc.b      1                      ; HIERO 1
          .dc.b      1                      ; HIERO 2
          .dc.b      1                      ; HIERO 3
          .dc.b      1                      ; HIERO 4
          .dc.b      1                      ; HIERO 5
          .dc.b      1                      ; HIERO 6
          .dc.b      1                      ; HIERO 7
          .dc.b      1                      ; HIERO 8
          .dc.b      8                      ; JEWEL 1
          .dc.b      8                      ; JEWEL 2
          .dc.b      8                      ; JEWEL 3
          .dc.b      8                      ; SM PYR BOT
          .dc.b      9                      ; SM PYR TOP
          .dc.b      12                     ; LG PYR BOT
          .dc.b      13                     ; LG PYR MID
          .dc.b      12                     ; LG PYR TOP
          .dc.b      21                     ; OBELISK BOT
          .dc.b      21                     ; OBELISK MID
          .dc.b      8                      ; OBELISK TOP
          .dc.b      12                     ; MINI BOT
          .dc.b      11                     ; MINI TOP
          .dc.b      15                     ; FIRE POT
          .dc.b      2                      ; FIRE TIP
          .dc.b      12                     ; SPHINX LEFT BOT
          .dc.b      12                     ; SPHINX LEFT
          .dc.b      42                     ; SPHINX LEFT
          .dc.b      0                      ; SPHINX LEFT TOP
          .dc.b      12                     ; SPHINX RIGHT BOT
          .dc.b      25                     ; SPHINX RIGHT
          .dc.b      0                      ; SPHINX RIGHT TOP
          .dc.b      4                      ; SPHINX FACE BOT
          .dc.b      0                      ; SPHINX FACE TOP

SCRZOFF:
          .dc.b      NUMBER+6               ; HIERO 1
          .dc.b      NUMBER+6               ; HIERO 2
          .dc.b      NUMBER+6               ; HIERO 3
          .dc.b      NUMBER+6               ; HIERO 4
          .dc.b      NUMBER+6               ; HIERO 5
          .dc.b      NUMBER+6               ; HIERO 6
          .dc.b      NUMBER+6               ; HIERO 7
          .dc.b      NUMBER+6               ; HIERO 8
          .dc.b      NUMBER+4               ; JEWEL 1
          .dc.b      NUMBER+4               ; JEWEL 2
          .dc.b      NUMBER+4               ; JEWEL 3
          .dc.b      NUMBER+4               ; SM PYR BOT
          .dc.b      NUMBER+6-16            ; SM PYR TOP
          .dc.b      NUMBER+8               ; LG PYR BOT
          .dc.b      NUMBER+10-16           ; LG PYR MID
          .dc.b      NUMBER+13-32           ; LG PYR TOP
          .dc.b      NUMBER+2               ; OBELISK BOT
          .dc.b      NUMBER+2-16            ; OBELISK MID
          .dc.b      NUMBER+2-32            ; OBELISK TOP
          .dc.b      NUMBER+6               ; MINI BOT
          .dc.b      NUMBER+4-16            ; MINI TOP
          .dc.b      NUMBER+5               ; FIRE POT
          .dc.b      NUMBER+4               ; FIRE TIP
          .dc.b      NUMBER+9               ; SPHINX LEFT BOT
          .dc.b      NUMBER+9-16            ; SPHINX LEFT
          .dc.b      NUMBER+16-32           ; SPHINX LEFT
          .dc.b      0                      ; SPHINX LEFT TOP
          .dc.b      NUMBER+17              ; SPHINX RIGHT BOT
          .dc.b      NUMBER+10-16           ; SPHINX RIGHT
          .dc.b      0                      ; SPHINX RIGHT TOP
          .dc.b      NUMBER+12-16           ; SPHINX FACE BOT
          .dc.b      0                      ; SPHINX FACE TOP

SCRDPTH:
          .dc.b      12                     ; HIERO 1
          .dc.b      12                     ; HIERO 2
          .dc.b      12                     ; HIERO 3
          .dc.b      12                     ; HIERO 4
          .dc.b      12                     ; HIERO 5
          .dc.b      12                     ; HIERO 6
          .dc.b      12                     ; HIERO 7
          .dc.b      12                     ; HIERO 8
          .dc.b      9                      ; JEWEL 1
          .dc.b      9                      ; JEWEL 2
          .dc.b      9                      ; JEWEL 3
          .dc.b      8                      ; SM PYR BOT
          .dc.b      4                      ; SM PYR TOP
          .dc.b      17                     ; LG PYR BOT
          .dc.b      12                     ; LG PYR MID
          .dc.b      6                      ; LG PYR TOP
          .dc.b      4                      ; OBELISK BOT
          .dc.b      4                      ; OBELISK MID
          .dc.b      2                      ; OBELISK TOP
          .dc.b      17                     ; MINI BOT
          .dc.b      6                      ; MINI TOP
          .dc.b      5                      ; FIRE POT
          .dc.b      7                      ; FIRE TIP
          .dc.b      12                     ; SPHINX LEFT BOT
          .dc.b      12                     ; SPHINX LEFT
          .dc.b      20                     ; SPHINX LEFT
          .dc.b      0                      ; SPHINX LEFT TOP
          .dc.b      20                     ; SPHINX RIGHT BOT
          .dc.b      26                     ; SPHINX RIGHT
          .dc.b      0                      ; SPHINX RIGHT TOP
          .dc.b      5                      ; SPHINX FACE BOT
          .dc.b      0                      ; SPHINX FACE TOP

SCRDX:
          .dc.b      $FF                    ; HIERO 1
          .dc.b      $FF                    ; HIERO 2
          .dc.b      $FF                    ; HIERO 3
          .dc.b      $FF                    ; HIERO 4
          .dc.b      $FF                    ; HIERO 5
          .dc.b      $FF                    ; HIERO 6
          .dc.b      $FF                    ; HIERO 7
          .dc.b      $FF                    ; HIERO 8
          .dc.b      (2*NUMBER)+DXADJ       ; JEWEL 1
          .dc.b      (2*NUMBER)+DXADJ       ; JEWEL 2
          .dc.b      (2*NUMBER)+DXADJ       ; JEWEL 3
          .dc.b      (2*NUMBER)+DXADJ       ; SM PYR BOT
          .dc.b      (2*NUMBER)+DXADJ-16    ; SM PYR TOP
          .dc.b      (2*NUMBER)+DXADJ       ; LG PYR BOT
          .dc.b      (2*NUMBER)+DXADJ-16    ; LG PYR MID
          .dc.b      (2*NUMBER)+DXADJ-32    ; LG PYR TOP
          .dc.b      (2*NUMBER)+DXADJ       ; OBELISK BOT
          .dc.b      (2*NUMBER)+DXADJ-16    ; OBELISK MID
          .dc.b      (2*NUMBER)+DXADJ-32    ; OBELISK TOP
          .dc.b      (2*NUMBER)+DXADJ       ; MINI BOT
          .dc.b      (2*NUMBER)+DXADJ-16    ; MINI TOP
          .dc.b      (2*NUMBER)+DXADJ+1     ; FIRE POT
          .dc.b      (2*NUMBER)+DXADJ       ; FIRE TIP
          .dc.b      (2*NUMBER)+DXADJ       ; SPHINX LEFT BOT
          .dc.b      (2*NUMBER)+DXADJ-8     ; SPHINX LEFT
          .dc.b      (2*NUMBER)+DXADJ-16    ; SPHINX LEFT
          .dc.b      (2*NUMBER)+DXADJ-32    ; SPHINX LEFT TOP
          .dc.b      (2*NUMBER)+DXADJ       ; SPHINX RIGHT BOT
          .dc.b      (2*NUMBER)+DXADJ-16    ; SPHINX RIGHT
          .dc.b      (2*NUMBER)+DXADJ-32    ; SPHINX RIGHT TOP
          .dc.b      (2*NUMBER)+DXADJ       ; SPHINX FACE BOT
          .dc.b      (2*NUMBER)+DXADJ-16    ; SPHINX FACE TOP

SCRDD:
          .dc.b      0                      ; HIERO 1
          .dc.b      0                      ; HIERO 2
          .dc.b      0                      ; HIERO 3
          .dc.b      0                      ; HIERO 4
          .dc.b      0                      ; HIERO 5
          .dc.b      0                      ; HIERO 6
          .dc.b      0                      ; HIERO 7
          .dc.b      0                      ; HIERO 8
          .dc.b      6                      ; JEWEL 1
          .dc.b      6                      ; JEWEL 2
          .dc.b      6                      ; JEWEL 3
          .dc.b      8                      ; SM PYR BOT
          .dc.b      8                      ; SM PYR TOP
          .dc.b      16                     ; LG PYR BOT
          .dc.b      16                     ; LG PYR MID
          .dc.b      16                     ; LG PYR TOP
          .dc.b      4                      ; OBELISK BOT
          .dc.b      4                      ; OBELISK MID
          .dc.b      4                      ; OBELISK TOP
          .dc.b      18                     ; MINI BOT
          .dc.b      18                     ; MINI TOP
          .dc.b      4                      ; FIRE POT
          .dc.b      6                      ; FIRE TIP
          .dc.b      19                     ; SPHINX LEFT BOT
          .dc.b      19                     ; SPHINX LEFT
          .dc.b      19                     ; SPHINX LEFT
          .dc.b      19                     ; SPHINX LEFT TOP
          .dc.b      19                     ; SPHINX RIGHT BOT
          .dc.b      19                     ; SPHINX RIGHT
          .dc.b      19                     ; SPHINX RIGHT TOP
          .dc.b      10                     ; SPHINX FACE BOT
          .dc.b      10                     ; SPHINX FACE TOP

; SCRBUF - ROUTINE TO LOAD THE SCROLLING OBJECT BUFFER WITH ALL THE STAMPS
;         FOR AN OBJECT.

;         A = HORIZONTAL POSITION FOR THE OBJECT
;         X = OBJID FOR THE OBJECT

;         TRASHES A, TEMP0, TEMP1, TEMP2

SCRBUFDN: LDX     TEMP1
          RTS

SCRBUF:   STA     TEMP0                  ; SAVE HPOS FOR LATER
          STX     TEMP1
          LDA     FRBUFPTR
          CMP     BUFSIZE,X              ; NUMBER OF BUFFER SLOTS NEEDED
          BCC     SCRBUFDN               ; NO ROOM IN BUFFER
          LDA     BUFSIZE,X
          STA     TEMP2
          LDY     BUFSTART,X
SCRBUFLP: DEC     TEMP2                  ; NUMBER OF PEICES LEFT
          BMI     SCRBUFDN               ; DONE WHEN NEGATIVE
          LDX     FRBUFPTR               ; STACK POINTER FOR BUFFER LOCATIONS
          LDA     FRBUFSTK,X
          TAX
          TYA                            ; INDEX IS STAMP ID
          STA     STAMPID,X
          LDA     BUFZBK,Y
          STA     ZONESBK,X
          LDA     TEMP0
          STA     HPOS,X
          DEC     FRBUFPTR               ; HAVE JUST POPPED BUFFER STACK
BUFTRAP:  BMI     BUFTRAP                ; TRAP FOR BUFFER STACK UNDERFLOW
          INY
          BPL     SCRBUFLP               ; ALWAYS

BUFSTART: ; THIS TABLE CONTAINS THE BUFFER DATA STARTING INDEX FOR EACH OBJECT
          .dc.b      0                      ; HIERO 1           0
          .dc.b      1                      ; HIERO 2           1
          .dc.b      2                      ; HIERO 3           2
          .dc.b      3                      ; HIERO 4           3
          .dc.b      4                      ; HIERO 5           4
          .dc.b      5                      ; HIERO 6           5
          .dc.b      6                      ; HIERO 7           6
          .dc.b      7                      ; HIERO 8           7
          .dc.b      8                      ; JEWEL 1           8
          .dc.b      9                      ; JEWEL 2           9
          .dc.b      10                     ; JEWEL 3          10
          .dc.b      11                     ; SM PYR           11
          .dc.b      13                     ; LG PYR           12
          .dc.b      16                     ; OBELISK          13
          .dc.b      19                     ; MINI SPHINX      14
          .dc.b      21                     ; FIRE POT         15
          .dc.b      23                     ; BIG SPHINX       16

BUFSIZE:  ; THIS TABLE CONTAINS THE NUMBER OF PEICES IN EACH OBJECT
          .dc.b      1                      ; HIERO 1           0
          .dc.b      1                      ; HIERO 2           1
          .dc.b      1                      ; HIERO 3           2
          .dc.b      1                      ; HIERO 4           3
          .dc.b      1                      ; HIERO 5           4
          .dc.b      1                      ; HIERO 6           5
          .dc.b      1                      ; HIERO 7           6
          .dc.b      1                      ; HIERO 8           7
          .dc.b      1                      ; JEWEL 1           8
          .dc.b      1                      ; JEWEL 2           9
          .dc.b      1                      ; JEWEL 3          10
          .dc.b      2                      ; SM PYR           11
          .dc.b      3                      ; LG PYR           12
          .dc.b      3                      ; OBELISK          13
          .dc.b      2                      ; MINI SPHINX      14
          .dc.b      2                      ; FIRE POT         15
          .dc.b      9                      ; BIG SPHINX       16

BUFZBK:   ; THIS TABLE CONTAINS THE ZONESBK FOR EACH STAMP
          .dc.b      0                      ; HIERO 1
          .dc.b      0                      ; HIERO 2
          .dc.b      0                      ; HIERO 3
          .dc.b      0                      ; HIERO 4
          .dc.b      0                      ; HIERO 5
          .dc.b      0                      ; HIERO 6
          .dc.b      0                      ; HIERO 7
          .dc.b      0                      ; HIERO 8
          .dc.b      0                      ; JEWEL 1
          .dc.b      0                      ; JEWEL 2
          .dc.b      0                      ; JEWEL 3
          .dc.b      0                      ; SM PYR
          .dc.b      1
          .dc.b      0                      ; LG PYR
          .dc.b      1
          .dc.b      2
          .dc.b      0                      ; OBELISK
          .dc.b      1
          .dc.b      2
          .dc.b      0                      ; MINI SPHINX
          .dc.b      1
          .dc.b      0                      ; FIRE POT
          .dc.b      0
          .dc.b      0                      ; BIG SPHINX
          .dc.b      1
          .dc.b      2
          .dc.b      3
          .dc.b      1
          .dc.b      2
          .dc.b      3
          .dc.b      1
          .dc.b      2

;          END



