
*  MARIAOS        MARIA DATA LOCATION DEFINITIONS

*  NOTE THE FOLLOWING WIERD THINGS ABOUT THE RAM:
*           $00-$3F <=> $100-$13F
*           $80-$FF <=> $180-$1FF
*           $40-$FF <=> $2040-$20FF
*         $140-$1FF <=> $2140-$21FF

*  TIA REGISTERS
INPTCTRL  EQU     $01                    ;INPUT CONTROL
INPT4     EQU     $0C                    ;BITS 7        PLAYER 0 BUTTON
INPT5     EQU     $0D                    ;BITS 7        PLAYER 1 BUTTON
AUDC0     EQU     $15                    ;BITS     3210 AUDIO CONTROL 0
AUDC1     EQU     $16                    ;BITS     3210 AUDIO CONTROL 1
AUDF0     EQU     $17                    ;BITS    43210 AUDIO FREQUENCY 0
AUDF1     EQU     $18                    ;BITS    43210 AUDIO FREQUENCY 1
AUDV0     EQU     $19                    ;BITS     3210 AUDIO VOLUME 0
AUDV1     EQU     $1A                    ;BITS     3210 AUDIO VOLUME 1

*  MARIA REGISTERS
BACKGRND  EQU     $20                    ;BACKGROUND COLOR
Z0C1      EQU     $21                    ;PALETTE 0, COLOR 1
Z0C2      EQU     $22                    ;PALETTE 0, COLOR 2
Z0C3      EQU     $23                    ;PALETTE 0, COLOR 3
WSYNC     EQU     $24                    ;FAST MARIA WSYNC STROBE             WO
Z1C1      EQU     $25                    ;PALETTE 1, COLOR 1
Z1C2      EQU     $26                    ;PALETTE 1, COLOR 2
Z1C3      EQU     $27                    ;PALETTE 1, COLOR 3
MSTAT     EQU     $28                    ;BIT 6 IN VBLANK, BIT ? IN DISPLAY   RO
Z2C1      EQU     $29                    ;PALETTE 2, COLOR 1
Z2C2      EQU     $2A                    ;PALETTE 2, COLOR 2
Z2C3      EQU     $2B                    ;PALETTE 2, COLOR 3
DPPH      EQU     $2C                    ;DISPLAY LIST POINTER HIGH           WO
Z3C1      EQU     $2D                    ;PALETTE 3, COLOR 1
Z3C2      EQU     $2E                    ;PALETTE 3, COLOR 2
Z3C3      EQU     $2F                    ;PALETTE 3, COLOR 3
DPPL      EQU     $30                    ;DISPLAY LIST POINTER LOW            WO
Z4C1      EQU     $31                    ;PALETTE 4, COLOR 1
Z4C2      EQU     $32                    ;PALETTE 4, COLOR 2
Z4C3      EQU     $33                    ;PALETTE 4, COLOR 3
CHARBASE  EQU     $34                    ;CHARACTER MODE HIGH POINTER         WO
Z5C1      EQU     $35                    ;PALETTE 5, COLOR 1
Z5C2      EQU     $36                    ;PALETTE 5, COLOR 2
Z5C3      EQU     $37                    ;PALETTE 5, COLOR 3
OFFSET    EQU     $38                    ;NOT USED ******
Z6C1      EQU     $39                    ;PALETTE 6, COLOR 1
Z6C2      EQU     $3A                    ;PALETTE 6, COLOR 2
Z6C3      EQU     $3B                    ;PALETTE 6, COLOR 3
CTRL      EQU     $3C                    ;BIT 7 CHARACTER WIDTH, BIT 6 BCNT   WO
Z7C1      EQU     $3D                    ;PALETTE 7, COLOR 1
Z7C2      EQU     $3E                    ;PALETTE 7, COLOR 2
Z7C3      EQU     $3F                    ;PALETTE 7, COLOR 3

*  FREE RAM - $40-$FF

*  ALIASED RAM - $100-$13F

*  STACK - $140-$1FF

*  6532 TIMERS AND PORTS

SWCHA     EQU     $280                   ;JOYSTICKS
*         BIT 7   PLAYER 0 EAST IF CLEAR
*         BIT 6            WEST
*         BIT 5            SOUTH
*         BIT 4            NORTH
*         BIT 3   PLAYER 1 EAST IF CLEAR
*         BIT 2            WEST
*         BIT 1            SOUTH
*         BIT 0            NORTH

SWCHB     EQU     $282                   ;CONSOLE SWITCHES
*         BIT 7   PLAYER 1 DIFFICULTY A IF SET, B IF CLEAR
*         BIT 6   PLAYER 2 DIFFICULTY A IF SET, B IF CLEAR
*         BIT 3   BLACK AND WHITE VS COLOR - COLOR WHEN SET
*         BIT 1   GAME SELECT - CLEAR WHEN PRESSED
*         BIT 0   GAME RESET - CLEAR WHEN PRESSED

CTLSWA    EQU     $281
CTLSWB    EQU     $283
INTIM     EQU     $284                   ;INTERVAL TIMER IN
TIM8T     EQU     $295                   ;TIMER 8T WRITE OUT
TIM64T    EQU     $296                   ;TIMER 64T WRITE OUT
TIM64TI   EQU     $29E                   ;INTERRUPT TIMER 64T

