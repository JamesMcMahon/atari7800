;@A D	 *4>HR\+p
; Z-1________ -0

	.subttl  "SSCEQU.S:  Equates, Variables, Matrixes, Buffers"
; Z-1________ -0

*_____ Maria and TIA Zero Page Registers _______________

;7800 Equates from Atari:

TIA:	ds.B 1  ;$0  BASE ADDRESS FOR TIA CHIP (all write-only)

PTCTRL:	ds.B 7  ; always 7.  INPUT PORT CONTROL ("VBLANK" IN TIA )
;
;   LEFT AND RIGHT FIRE BUTTONS CAN BE READ FROM THE FOLLOWING 4 LOCATIONS:
;
;			   THESE ARE ALSO USED FOR PADDLE INPUT
INPT0:	ds.B 1  ;$8	;PLAYER 0, RIGHT FIRE BUTTON (D7 = 1 WHEN PUSHED)
INPT1:	ds.B 1  ;$9	;PLAYER 0, LEFT FIRE BUTTON  (D7 = 1 WHEN PUSHED)
INPT2:	ds.B 1  ;$A	;PLAYER 1, RIGHT FIRE BUTTON (D7 = 1 WHEN PUSHED)
INPT3:	ds.B 1  ;$B	;PLAYER 1, LEFT FIRE BUTTON  (D7 = 1 WHEN PUSHED)
;
;   LEFT OR RIGHT FIRE BUTTONS READ FROM THESE LOCATIONS:
;
INPT4:	ds.B 1  ;$C	;PLAYER 0 FIRE BUTTON INPUT (D7 = 0 WHEN PUSHED)
INPT5:	ds.B 1  ;$D	;PLAYER 1 FIRE BUTTON INPUT (D7 = 0 WHEN PUSHED)

; Z-1________ -0

		ds.B 7		;undefined
; $15 - $1A  (wo)
AUDC0:	ds.B 1  ;$15	;AUDIO CONTROL CHANNEL 0
AUDC1:	ds.B 1  ;$16	;AUDIO CONTROL CHANNEL 1
AUDF0:	ds.B 1  ;$17	;AUDIO FREQUENCY CHANNEL 0
AUDF1:	ds.B 1  ;$18	;AUDIO FREQUENCY CHANNEL 1
AUDV0:	ds.B 1  ;$19	;AUDIO VOLUME CHANNEL 0
AUDV1:	ds.B 1  ;$1A	;AUDIO VOLUME CHANNEL 1
	     ds.B 5
; Z-1________ -0

MARIA:	ds.B 1  ;$20     ;base address for Maria Chip.  Access by ABS,INDEX to read.
BKGRND	=  MARIA ;BACKGROUND COLOR
BACKGRND	=  MARIA ;synonym used by GCC
P0C1:	ds.B 1  ;$21	PALETTE 0 - COLOR 1
P0C2:	ds.B 1  ;$22	          - COLOR 2
P0C3:	ds.B 1  ;$23	          - COLOR 3
WSYNC:	ds.B 1  ;$24   ;WAIT FOR SYNC
P1C1:	ds.B 1  ;$25	PALETTE 1 - COLOR 1
P1C2:	ds.B 1  ;$26	          - COLOR 2
P1C3:	ds.B 1  ;$27	          - COLOR 3
MSTAT:	ds.B 1  ;$28   ;MARIA STATUS: 1 ds.B 1  ;  vblank
P2C1:	ds.B 1  ;$29	PALETTE 2 - COLOR 1
P2C2:	ds.B 1  ;$2A	          - COLOR 2
P2C3:	ds.B 1  ;$2B	          - COLOR 3
DPH	:	ds.B 1  ;$2C   ;synonym used by GCC
DPPH    = DPH    ;$2C		DISPLAY LIST LIST POINT HIGH BYTE
P3C1:	ds.B 1  ;$2D	PALETTE 3 - COLOR 1
P3C2:	ds.B 1  ;$2E	          - COLOR 2
P3C3:	ds.B 1  ;$2F	          - COLOR 3
DPL:	ds.B 1  ;$30   ;synonym used by GCC
DPPL    = DPL		;$30	DISPLAY LIST LIST POINT LOW BYTE
P4C1:	ds.B 1  ;$31	PALETTE 4 - COLOR 1
P4C2:	ds.B 1  ;$32	          - COLOR 2
P4C3:	ds.B 1  ;$33	          - COLOR 3
CHBASE:	ds.B 1  ;$34   CHARACTER BASE ADDRESS
P5C1:	ds.B 1  ;$35	PALETTE 5 - COLOR 1
P5C2:	ds.B 1  ;$36	          - COLOR 2
P5C3:	ds.B 1  ;$37	          - COLOR 3
OFFSET:	ds.B 1  ;$38   FOR FUTURE EXPANSION HERE - STORE ZER0 HERE
P6C1:	ds.B 1  ;$39	PALETTE 6 - COLOR 1
P6C2:	ds.B 1  ;$3A	          - COLOR 2
P6C3:	ds.B 1  ;$3B	          - COLOR 3
CTRL:	ds.B 1  ;$3C   MARIA CONTROL REGISTER
P7C1:	ds.B 1  ;$3D	PALETTE 7 - COLOR 1
P7C2:	ds.B 1  ;$3E	          - COLOR 2
P7C3:	ds.B 1  ;$3F	          - COLOR 3
				;end of Maria, Tia registers
; Z-1________ -0

*_____ SSC Variables on Zero Page _______________________

Matrix:	ds.B 80	;[SSCZOOM] Hpos of center line for 80 objects (1/line)
		ds.B 1	;margin on Fifo
Fifo:	ds.B 16	;[SSCZOOM] 10 values of course * Mag4B
Step:    ds.B 1	;[SSCZOOM] Current position in Course (0-128)
Track:   ds.B 2    ;[SSCZOOM] Pointer to beginning of course
ZoomT:   ds.B 1   ;[SSCZOOM] [SSCDLI] Timer adjusts frame rate

WhirliGig:	ds.B 1  ;	temporary doodle for debugging (inside DLI)
ThingamaJig:	ds.B 1  ;	(outside all interrupts, in "main" loop)

saveA:	ds.B 1	; Temporary register store for use INSIDE DLIs only!
saveX:	ds.B 1	; (faster than PHA/PLA)  [SSCDLI]
saveY:	ds.B 1	;

DLICOUNT: ds.B 1   ; [SSCDLI] Keeps track of current DLI

POINT:	ds.B 2  ;	[SSCINI] FOR FILLING, CLEARING, ETC.
TEMPX  = POINT  	;outside interrupts [SSCSUB]
TEMPY  = POINT+1	;
COUNT:	ds.B 2  ;	outside interrupts only.
COLUMN = COUNT   	;re-use [SSCSUB] Print
PCOUNT = COUNT+1	;
DEPTH = COUNT+1	;re-use [SSCZOOM] Fifo
SRCE0:	ds.B 2  ;	 Move, source
STRING = SRCE0	;2 byte.  re-use [SSCSUB]
DEST0:	ds.B 2  ;  Move, destination
VIEW = DEST0	;re-use [SSCSUB]
SRCE1:	ds.B 2  ;
IMAGE = SRCE1	;2 byte.  re-use [SSCSUB]
DEST1:	ds.B 2  ;
SCAN = DEST1	;[SSCZOOM] Loop counter for writing per scan lines.  re-use
START:	ds.B 1	;[SSCZOOM] re-use
FINISH:	ds.B 1
TARGET:	ds.B 2	;[SSCZOOM] re-use

ZTEMP:	ds.B 2  ; re-use
LIMIT:	ds.B 2  ; [SSCSUB]

ShiftReg:	ds.B 4	;[SSCSUB] Random number generator
RandomNumber: 	ds.B 1	;
Feedback:	ds.B 1	;

Dividend:	ds.B 2	;Number to be divided [SSCSUB]
Divisor:		ds.B 1	;Number to divide by
Quotient:	ds.B 1	;Result of division
Remainder:	ds.B 1	;after division

;Event timers for demos or metering action
Event: ds.B 8	; +0 = Rep. rate for text in demo footer patter
			; +1 = Fade-In and Fade-Out timer [SSCSUB]
			; +2 = Zoom frame rate

Z:	ds.B 2	;Temporary for use outside interrupts  (<$C4 10/26/88)

; Z-1________ -0

;	PIA AND TIMER (6532) LOCATIONS

	.org $280

SWCHA:	ds.B 1  ;$280	;LEFT & RIGHT JOYSTICKS
;		      	;LEFT RITE
;	7654 3210	;BIT POSITION =0 IF SWITCH IS CLOSED)
;	---- ----
;	RLDU RLDU	;RIGHT/LEFT/DOWN/UP

CTLSWA:	ds.B 1  ;$281	;SWCHA DATA DIRECTION (0=INPUT)

SWCHB:	ds.B 1  ;$282	;CONSOLE SWITCHES
;
;	D7-RITE DIFFICULTY
;	D6-LEFT DIFFICULTY
;	D5/D4 NOT USED
;	D3-PAUSE
;	D2-NOT USED
;	D1-GAME SELECT
;	D0-GAME RESET

CTLSWB:	ds.B 1  	;$283	;SWCHB DATA DIRECTION (0=INPUT)

INTIM:	ds.B $10  ;$284	; to $294  INTERVAL TIMER READ
TIM1T:	ds.B 1    ;$294	;SET 1    CLK INTERVAL (838   NSEC/INTERVAL)
TIM8T:	ds.B 1    ;$295	;SET 8    CLK INTERVAL (6.7   USEC/INTERVAL)
TIM64T:	ds.B 1    ;$296	;SET 64   CLK INTERVAL (53.6  USEC/INTERVAL)
T1024T:	ds.B 1    ;$297	;SET 1024 CLK INTERVAL (858.2 USEC/INTERVAL)
;		          
; Z-1________ -0
;
RESET	=    1		;bits for consle switches
SELECT	=    2		;
PAUSE	=    8		;
; Z-1________ -0

* AVAILABLE RAM, FIRST SEGMENT OF MEMORY MINUS ZP REGS, AND CHIPS TIA & MARIA

RAM0	=   $40   ;PAGE 0
RAM0SIZE =   $BF   ;191 FREE

;RAM1	=   $140	; STACK (variable unused, but included for completeness)
;R1SIZE	=   $C0	; $140 to $1FF, $BF (191) BYTES FREE

RAM2	=   $1800	;FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
R2SIZE 	=   $840	;$1800 to $203F, $840 or 2112 bytes (counts to 0).

RAM3	=   $2100	;FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
R3SIZE 	=   $40	;$2100 to $213F, $40 or 64 bytes.
HPOS_T	=   RAM3	;[SSCZOOM]

RAM4	=   $2200	;FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
R4SIZE	=   $400	;$2200 to $27FF, $400 or 1024 bytes.

* ______ RAM 3 VARIABLE BLOCK ____________________
	
	.org RAM3

;general purpose:

TEMP:	ds.B 16	;one-level

; SSC specific variables, buffers, matrixes, counters, pointers:

DTX:	ds.B 1	;isolated x save for Divide [SSCSUB]

Delta:	ds.B 12   ;[SSCZOOM]

TextLum:	ds.B 1	;[SSCSUB] fade-in/out
TextLin:	ds.B 1	;[SSCSUB] indicate current text line to print
ST0:	ds.B 1
ST1:	ds.B 1
ST2:	ds.B 1
ST3:	ds.B 1

ScanPlane:	ds.B 1
Direction:	ds.B 1
MatrixPoint:	ds.B 1
FifoPoint:	ds.B 1

CenterLine:	ds.B 80	;Centering for entire playfield


TWP:	ds.B 1	;twirl world sync [ssczoom]

BounceNow:	ds.B 1	;[ssczoom] vertical bounce
BounceTo:	ds.B 1	;[ssczoom]



; Z-1________ -0

