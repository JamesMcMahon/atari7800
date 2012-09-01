
*  LOADMAP.S      ROUTINES DEALING WITH MAZE MAINTENANCE

*  MAZE DRAWING ROUTINE: CALLED WITH THE NUMBER OF THE DESIRED MAZE IN RACK,
*  WILL DRAW THE APPROPRIATE MAZE.

          ;ZERO PAGE TEMPORARY VARIABLES.
          ; TEMP0-7  : EIGHT BYTE SHIFT REGISTER
          ; TEMP8-9  : POINTER TO MAZE DATA
          ; TEMP10-11: POINTER TO PLAY FIELD (CHARACTER MAP)
          ; TEMP12   : TEMPORARY VALUE STORAGE FOR COMPUTATIONS
          ; TEMP13   : OFFSET TO PLAYFIELD POINTER FOR LEFT HALF OF MAZE
          ; TEMP14   : OFFSET TO PLAYFIELD POINTER FOR RIGHT HALF OF MAZE
          ; TEMP15   : COUNTER TO KEEP TRACK OF CURRENT ROW

LOADMAP   LDA     #$00
          STA     DOTS                   ;INITIALIZE DOT COUNTER
          STA     DOTS+1

          LDY     RACK
          LDA     MAZEBEGL,Y
          STA     TEMP8
          LDA     MAZEBEGH,Y
          STA     TEMP8+1

          LDA     #0
          STA     TEMP13
          LDA     #WIDTH-1
          STA     TEMP14

          JSR     LDSHFTL

NEXTCOL   JSR     LDSHFTH

          LDA     #L(SCREEN)
          STA     TEMP10
          LDA     #H(SCREEN)
          STA     TEMP10+1

          LDA     #HEIGHT
          STA     TEMP15

NEXTROW   LDA     TEMP0+0
          AND     #$03
          STA     TEMP12
          LDA     TEMP0+4
          ASL     A
          ASL     A
          AND     #$0C
          ORA     TEMP12
          TAX

          LDA     TEMP13
          CMP     #10
          BCC     NOTPEN
          LDA     TEMP15
          SBC     #15
          CMP     #5
          BCS     NOTPEN

;PEN
          TXA
          ADC     #$10
          TAX

NOTPEN
;NORMAL PLAYFIELD
          TXA                            ;SEE IF SHOULD BE AN EMPTY CHARACTER
          CMP     #$0F                   ;  NEAR THE BORDER INSTEAD OF FULL
          BNE     DOCHAR
          LDA     TEMP13
          CMP     #$03
          BPL     DOCHAR
          LDX     #$00                   ;IT SHOULD BE EMPTY

DOCHAR    LDA     LEFT,X
          LDY     TEMP13
          STA     (TEMP10),Y
          LDA     RIGHT,X
          LDY     TEMP14
          STA     (TEMP10),Y

          JSR     SHIFT

          CLC
          LDA     TEMP10
          ADC     #WIDTH
          STA     TEMP10
          BCC     NOINC
          INC     TEMP10+1

NOINC     DEC     TEMP15
          BNE     NEXTROW

          INC     TEMP13
          DEC     TEMP14
          LDA     TEMP13
          CMP     TEMP14
          BCS     LOADDONE
          JSR     SHIFT
          JSR     SHIFT
          JMP     NEXTCOL

SHIFT     LDX     #$07
          LSR     TEMP0+7
SHIFT1    ROR     TEMP0-1,X
          DEX
          BNE     SHIFT1
          RTS

LOADDONE  LDA     #DOORCHAR              ;PEN ENTRANCE CHARACTER
          STA     SCREEN+28*11+13        ;ENTRANCE AT 11TH ROW, 13TH COLUMN
          STA     SCREEN+28*11+14        ; AND 11TH ROW, 14TH COLUMN.

*  THIS CODE TAKES CARE OF PUTTING UP THE DOTS
          LDA     #$00                   ;INITIALIZE EVERYTHING TO ZERO
          TAY
          STA     TEMP0
          STA     TEMP1

LMDLOOP   LDA     DOTARRAY,Y             ;GET NEW SET OF DOT BITS
          STA     TEMP15
          JSR     LMDOTS                 ;DO EACH OF THE 8 BITS
          JSR     LMDOTS
          JSR     LMDOTS
          JSR     LMDOTS
          JSR     LMDOTS
          JSR     LMDOTS
          JSR     LMDOTS
          JSR     LMDOTS
          INY
          CPY     #$78
          BNE     LMDLOOP

*  AND FINALLY - DO THE POWER DOTS
          LDY     RACK                   ;GET THE RACK
          LDA     EDZONE0,Y
          STA     TEMP0
          LDA     EDCOL0,Y
          STA     TEMP1
          JSR     LMEDOTS                ;ZONE 0 COLUMN 0
          LDA     EDCOL1,Y
          STA     TEMP1
          JSR     LMEDOTS                ;ZONE 0 COLUMN 1
          LDA     EDZONE1,Y
          STA     TEMP0
          JSR     LMEDOTS                ;ZONE 1 COLUMN 1
          LDA     EDCOL0,Y
          STA     TEMP1
          JSR     LMEDOTS                ;ZONE 1 COLUMN 0

          RTS


*  THIS ROUTINE CHECKS FOR A PARTICULAR POWER DOT
LMEDOTS   JSR     GETCHAR                ;SEE WHAT'S THERE
          CMP     #DOTCHAR               ;IS IT A DOT?
          BNE     LMEDOUT
          LDX     #EDOTCHAR              ;PUT AN EDOT DOWN
          JSR     PLOPCHAR
LMEDOUT   RTS


*  THIS ROUTINE LOADS IN A PARTICULAR DOT
LMDOTS    ASL     TEMP15                 ;GET A BIT OFF
          BCC     LMDINC                 ;SEE IF A DOT HERE
          LDX     #DOTCHAR               ;DOT HERE
          JSR     PLOPCHAR               ;PUT IT IN
          INC     DOTS                   ;ADD IT TO THE DOT COUNTER
          BNE     LMDINC
          INC     DOTS+1
LMDINC    JMP     NEXTPLOP               ;INCREMENT COLUMN


LEFT      DB    $50,$30,$31,$32,$33,$34,$50,$35,$36,$50,$37,$38,$39,$3A,$3B,$3C
PLEFT     DB    $50,$3E,$3F,$40,$41,$42,$50,$50,$43,$50,$44,$50,$45,$50,$50,$50
RIGHT     DB    $50,$33,$36,$39,$30,$34,$50,$3A,$31,$50,$37,$3B,$32,$35,$38,$3C
PRIGHT    DB    $50,$41,$43,$45,$3E,$42,$50,$50,$3F,$50,$44,$50,$40,$50,$50,$50

LDSHFTL   LDX     #$03
          BNE     LDSHFT1
LDSHFTH   LDX     #$07
LDSHFT1   LDY     #$03
LDSHFT2   LDA     (TEMP8),Y
          STA     TEMP0,X
          DEX
          DEY
          BPL     LDSHFT2
          CLC
          LDA     TEMP8
          ADC     #$04
          STA     TEMP8
          BCC     LDSHFT3
          INC     TEMP8+1
LDSHFT3   RTS


; <=======================================================================>

*  THIS ROUTINE LOADS IN THE DOTS FOR A NEW RACK INTO DOTARRAY
*  USES:  TEMP0-1, X
LOADDOTS  LDX     RACK                   ;SET UP FOR TRANSFER
          LDA     DOTBEGL,X
          STA     TEMP0
          LDA     DOTBEGH,X
          STA     TEMP1

          LDY     #$7F
LDDLOOP   LDA     (TEMP0),Y              ;AND MOVE THEM
          STA     DOTARRAY,Y
          DEY
          BPL     LDDLOOP
          RTS


; <=======================================================================>

*  THIS ROUTINE USES THE CHARACTER MAP IN SCREEN TO UPDATE THE INFORMATION
*  IN DOTARRAY.
SAVEDOTS  LDA     #$00                   ;INITIALIZE EVERYTHING TO ZERO
          TAY
          STA     TEMP0
          STA     TEMP1

SDLOOP    JSR     SDDOTS                 ;DO EACH OF THE 8 BITS
          JSR     SDDOTS
          JSR     SDDOTS
          JSR     SDDOTS
          JSR     SDDOTS
          JSR     SDDOTS
          JSR     SDDOTS
          JSR     SDDOTS
          LDA     TEMP15
          STA     DOTARRAY,Y
          INY
          CPY     #$78
          BNE     SDLOOP
          RTS


*  THIS ROUTINE CHECKS FOR A PARTICULAR DOT
SDDOTS    LDA     TEMP1                  ;SEE IF OUT OF RANGE
          CMP     #$1C
          BPL     SDNODOTS
          JSR     GETCHAR                ;FIND OUT WHAT IS HERE
          CMP     #DOTCHAR
          BMI     SDNODOTS
          SEC                            ;SHIFT IN A 1
          JMP     SDDOIT
SDNODOTS  CLC                            ;SHIFT IN A 0
SDDOIT    ROL     TEMP15

*  THIS ROUTINE INCREMENTS THE COLUMN FOR ROUTINES USING PUT/PLOPCHAR
NEXTPLOP  INC     TEMP1                  ;NEXT COLUMN
          LDA     TEMP1
          CMP     #$20
          BMI     NCOUT
          LDA     #$00                   ;NEXT ZONE
          STA     TEMP1
          INC     TEMP0
NCOUT     RTS

; <=======================================================================>

;TABLES OF POINTERS TO TABLES...

MAZEBEGL  DB      L(MAZE1),L(MAZE2),L(MAZE3),L(MAZE4)
MAZEBEGH  DB      H(MAZE1),H(MAZE2),H(MAZE3),H(MAZE4)

DOTBEGL   DB      L(DOT1),L(DOT2),L(DOT3),L(DOT4)
DOTBEGH   DB      H(DOT1),H(DOT2),H(DOT3),H(DOT4)

; <=======================================================================>

MAZE1     DB      $7F,$FE,$FC,$7F,$41,$FE,$3C,$40,$41,$FE,$3C,$40
          DB      $09,$00,$00,$4F,$09,$00,$00,$4F,$C9,$F3,$24,$4F
          DB      $01,$12,$24,$40,$01,$12,$24,$40,$4F,$92,$27,$4F
          DB      $41,$00,$04,$41,$41,$00,$04,$41,$49,$F2,$24,$49
          DB      $09,$F2,$20,$48,$09,$F2,$20,$48,$C9,$F3,$3C,$4F

DOT1      DB      $00,$00,$00,$00,$7E,$7F,$E7,$E0
          DB      $42,$40,$24,$20,$42,$40,$24,$20
          DB      $7F,$FF,$FF,$E0,$12,$09,$04,$80
          DB      $12,$09,$04,$80,$13,$F9,$FC,$80
          DB      $10,$00,$00,$80,$10,$00,$00,$80
          DB      $10,$00,$00,$80,$10,$00,$00,$80
          DB      $10,$00,$00,$80,$10,$00,$00,$80
          DB      $10,$00,$00,$80,$10,$00,$00,$80
          DB      $10,$00,$00,$80,$10,$00,$00,$80
          DB      $10,$00,$00,$80,$1F,$C0,$3F,$80
          DB      $10,$40,$20,$80,$10,$40,$20,$80
          DB      $7F,$F9,$FF,$E0,$42,$09,$04,$20
          DB      $42,$09,$04,$20,$42,$79,$E4,$20
          DB      $42,$40,$24,$20,$42,$40,$24,$20
          DB      $7F,$FF,$FF,$E0,$00,$00,$00,$00

; <=======================================================================>

MAZE2     DB      $F9,$FF,$3F,$7F,$09,$10,$3C,$41,$09,$10,$3C,$41
          DB      $C9,$93,$00,$48,$49,$90,$00,$48,$49,$90,$27,$4F
          DB      $41,$02,$20,$40,$41,$02,$20,$40,$4F,$3E,$E7,$49
          DB      $01,$00,$24,$48,$01,$00,$24,$48,$C9,$F3,$00,$49
          DB      $09,$F2,$00,$41,$09,$F2,$3C,$41,$79,$F2,$3C,$4F

DOT2      DB      $00,$00,$00,$00,$00,$7F,$E0,$00
          DB      $00,$40,$20,$00,$00,$40,$20,$00
          DB      $7F,$F9,$FF,$E0,$40,$49,$20,$20
          DB      $40,$49,$20,$20,$4F,$CF,$3F,$20
          DB      $48,$00,$01,$20,$48,$00,$01,$20
          DB      $7E,$00,$07,$E0,$02,$00,$04,$00
          DB      $02,$00,$04,$00,$7E,$00,$07,$E0
          DB      $42,$00,$04,$20,$42,$00,$04,$20
          DB      $72,$00,$04,$E0,$12,$00,$04,$80
          DB      $12,$00,$04,$80,$1F,$F0,$FF,$80
          DB      $10,$10,$80,$80,$10,$10,$80,$80
          DB      $1E,$70,$E7,$80,$12,$40,$24,$80
          DB      $12,$40,$24,$80,$73,$F9,$FC,$E0
          DB      $42,$09,$04,$20,$42,$09,$04,$20
          DB      $7F,$FF,$FF,$E0,$00,$00,$00,$00

; <=======================================================================>

MAZE3     DB      $FF,$FC,$FF,$7F
          DB      $81,$00,$20,$40
          DB      $81,$00,$20,$40
          DB      $99,$9C,$07,$49
          DB      $09,$10,$04,$49
          DB      $09,$10,$E4,$49
          DB      $C9,$83,$00,$40
          DB      $09,$82,$00,$40
          DB      $09,$F2,$3C,$7F
          DB      $41,$00,$04,$41
          DB      $41,$00,$04,$41
          DB      $4F,$F2,$24,$49
          DB      $01,$F2,$20,$48
          DB      $01,$F2,$20,$48
          DB      $79,$F2,$3C,$4F

DOT3      DB      $00,$00,$00,$00,$7F,$CF,$3F,$E0
          DB      $40,$49,$20,$20,$40,$49,$20,$20
          DB      $4F,$F9,$FF,$20,$79,$09,$09,$E0
          DB      $09,$09,$09,$00,$09,$FF,$F9,$00
          DB      $78,$00,$01,$E0,$40,$00,$00,$20
          DB      $40,$00,$00,$20,$40,$00,$00,$20
          DB      $40,$00,$00,$20,$40,$00,$00,$20
          DB      $40,$00,$00,$20,$40,$00,$00,$20
          DB      $40,$00,$00,$20,$40,$00,$00,$20
          DB      $40,$00,$00,$20,$7E,$79,$E7,$E0
          DB      $12,$40,$24,$80,$12,$40,$24,$80
          DB      $73,$F9,$FC,$E0,$42,$09,$04,$20
          DB      $42,$09,$04,$20,$7E,$79,$E7,$E0
          DB      $42,$40,$24,$20,$42,$40,$24,$20
          DB      $7E,$7F,$E7,$E0,$00,$00,$00,$00

; <=======================================================================>

MAZE4     DB      $FF,$4F,$FE,$7F
          DB      $01,$4E,$3E,$40
          DB      $01,$4E,$3E,$40
          DB      $79,$40,$00,$4F
          DB      $41,$40,$00,$41
          DB      $41,$F2,$39,$41
          DB      $09,$02,$20,$48
          DB      $09,$02,$20,$48
          DB      $C9,$9F,$27,$4F
          DB      $01,$02,$04,$48
          DB      $01,$02,$04,$48
          DB      $79,$F2,$E4,$49
          DB      $09,$F0,$00,$41
          DB      $09,$F0,$00,$41
          DB      $C9,$F3,$3C,$79

DOT4      DB      $00,$00,$00,$00,$7F,$FF,$FF,$E0
          DB      $48,$40,$21,$20,$48,$40,$21,$20
          DB      $4F,$CF,$3F,$20,$42,$49,$24,$20
          DB      $42,$49,$24,$20,$7E,$79,$E7,$E0
          DB      $10,$00,$00,$80,$10,$00,$00,$80
          DB      $1E,$00,$07,$80,$02,$00,$04,$00
          DB      $02,$00,$04,$00,$02,$00,$04,$00
          DB      $02,$00,$04,$00,$02,$00,$04,$00
          DB      $02,$00,$04,$00,$1E,$00,$07,$80
          DB      $12,$00,$04,$80,$13,$C0,$3C,$80
          DB      $10,$40,$20,$80,$10,$40,$20,$80
          DB      $7F,$C0,$3F,$E0,$42,$40,$24,$20
          DB      $42,$40,$24,$20,$4E,$7F,$E7,$20
          DB      $48,$09,$01,$20,$48,$09,$01,$20
          DB      $7F,$F9,$FF,$E0,$00,$00,$00,$00

; <=======================================================================>

          ;CONSTANT VALUES FOR MS.PACMAN
WIDTH     EQU     28
HEIGHT    EQU     30

*  ZONES AND COLUMNS FOR THE ENERGY DOTS - INDEXED BY RACK
EDZONE0   DB      $03,$04,$03,$03
EDZONE1   DB      $19,$19,$16,$1A
EDCOL0    DB      $01,$01,$01,$01
EDCOL1    DB      $1A,$1A,$1A,$1A

