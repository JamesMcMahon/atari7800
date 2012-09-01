
*  UTIL.S         GENERAL UTILITY ROUTINES


*  MOVE A CREATURE HORIZONTALLY
*  INPUT: A - CURRENT HORIZONTAL POS, Y - DIRECTION CREATURE FACING
*  OUTPUT:A - NEW HORIZONTAL POS
HPOSADJ   CLC
          ADC     PHPOSTAB,Y
          RTS

*  MOVE A CREATURE VERTICALLY
*  INPUT: A - CURRENT VERTICAL POS, Y - DIRECTION CREATURE FACING
*         X - CURRENT VERTICAL OFFSET
*  OUTPUT:A - NEW VERTICAL POS
VPOSADJ   CPY     #DUP
          BEQ     VPAUP
          CPY     #DDOWN
          BNE     VPAOUT
          CLC                            ;MOVE IT DOWN
          ADC     DNADJUST,X
          RTS
VPAUP     SEC                            ;MOVE IT UP
          SBC     UPADJUST,X
VPAOUT    RTS


*  BODY OF MACRO PFILL
PFILLIT   LDY     #0
PFLOOP    STA     (TEMP0),Y
          DEY
          BNE     PFLOOP
          INC     TEMP1
          DEX
          BNE     PFLOOP
          RTS

*  BODY OF MACRO PLOAD
PLOADIT   LDY     #0
PLLOOP    LDA     (TEMP2),Y
          STA     (TEMP0),Y
          DEY
          BNE     PLLOOP
          INC     TEMP1
          INC     TEMP3
          DEX
          BNE     PLLOOP
          RTS

*  CONVERT HORIZONTAL BIT COUNT TO COLUMN
HTOC      SEC
          SBC     #LEFTSIDE              ;SHIFT ORIGIN
          LSR     A
          LSR     A                      ;AND SCALE
          RTS

*  CONVERT COLUMN TO HORIZONTAL BIT COUNT
CTOH      ASL     A                      ;SCALE
          ASL     A
          CLC
          ADC     #LEFTSIDE              ;SHIFT ORIGIN
          RTS

*  CONVERT VERTICAL BIT TO ZONE AND OFFSET
*  OUTPUT:  ZONE IN Y, OFFSET IN A
*  USES Y!
VTOZO     LDY     #$00                   ;BRUTE FORCE - SLOW
VTZAGAIN  CMP     #$06                   ;SEE IF ANYTHING TO DO
          BCS     VTZDOIT
          RTS
VTZDOIT   INY                            ;INCREMENT ZONE
          SEC                            ;SUBTRACT 6
          SBC     #$06
          JMP     VTZAGAIN

*  CONVERT ZONE TO VERTICAL BIT
*  USES Y!
ZTOV      TAY
          LDA     #$00
ZVLOOP    CPY     #$00
          BEQ     ZVOUT
          CLC
          ADC     #$06
          DEY
          JMP     ZVLOOP
ZVOUT     RTS


*  TABLES FOR EASY MOVEMENT
PHPOSTAB  DB      $01,$00,$FF,$00
DNADJUST  DB      $02,$01,$01,$02,$01,$01
UPADJUST  DB      $01,$01,$02,$01,$01,$02
