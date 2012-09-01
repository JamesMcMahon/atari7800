;	****	 (C)1988   Property of John Boeschen & Co.	****
;		****	Source Code - Airball 7800	****	
	.6502
	.TITLE "AB2.S"
	.SUBTTL	"MARIA EQUATES -- ATARI CONFIDENTIAL"	
;
;	THIS DOCUMENT CONTAINS CONFIDENTIAL PROPRIETARY INFORMATION
;	OF JOHN BOESCHEN AND CO. WHICH MAY NOT BE COPIED, DISCLOSED,
;	OR USED EXCEPT AS EXPRESSLY AUTHORIZED IN WRITING.
;
;
;	MEMORY MAP USAGE OF THE 7800
;
;	00-1F		TIA REGISTERS
;	20-3F		MARIA REGISTERS
;	40-FF		ZERO PAGE RAM
;	100-13F		SHADOW OF TIA AND MARIA REGISTERS -- USED FOR 
;			PUSHING ACCUMULATOR ONTO REGISTERS
;	140-1FF		RAM (STACK)
;	200-27F		NOT USED
;	280-2FF		PIA PORTS AND TIMERS
;	300-17FF	NOT USED
;	1800-203F	RAM
;	2040-20FF	SHADOW OF ZERO PAGE RAM
;	2100-213F	RAM
;	2140-21FF	SHADOW OF STACK RAM
;	2200-27FF	RAM
;	2800-3FFF	DUPLICATION OF ADDRESS SPACE 2000-27FF
;	4000-FF7F	UNUSED ADDRESS SPACE
;	FF80-FFF9	RESERVED FOR ENCRYPTION
;	FFFA-FFFF	6502 VECTORS
;
	.org	0
TIA:	ds.b	1	;BASE ADDRESS FOR TIA CHIP

PTCTRL:	ds.b	1	;INPUT PORT CONTROL ("VBLANK" IN TIA )
	ds.b	6
;
;   LEFT AND RIGHT FIRE BUTTONS CAN BE READ FROM THE FOLLOWING 4 LOCATIONS:
;			   THESE ARE ALSO USED FOR PADDLE INPUT
INPT0:	ds.b	1	;PLAYER 0, RIGHT FIRE BUTTON (D7=1 WHEN PUSHED)
INPT1:	ds.b	1	;PLAYER 0, LEFT FIRE BUTTON  (D7=1 WHEN PUSHED)
INPT2:	ds.b	1	;PLAYER 1, RIGHT FIRE BUTTON (D7=1 WHEN PUSHED)
INPT3:	ds.b	1	;PLAYER 1, LEFT FIRE BUTTON  (D7=1 WHEN PUSHED)
;
;   LEFT OR RIGHT FIRE BUTTONS READ FROM THESE LOCATIONS:
;
INPT4:	ds.b	1	;PLAYER 0 FIRE BUTTON INPUT (D7=0 WHEN PUSHED)
INPT5:	ds.b	1	;PLAYER 1 FIRE BUTTON INPUT (D7=0 WHEN PUSHED)
	ds.b	7
;
AUDC0:	ds.b	1	;AUDIO CONTROL CHANNEL 0
AUDC1:	ds.b	1	;AUDIO CONTROL CHANNEL 1
AUDF0:	ds.b	1	;AUDIO FREQUENCY CHANNEL 0
AUDF1:	ds.b	1	;AUDIO FREQUENCY CHANNEL 1
AUDV0:	ds.b	1	;AUDIO VOLUME CHANNEL 0
AUDV1:	ds.b	1	;AUDIO VOLUME CHANNEL 1
;
	.org	$20
MARIA:				;BASE ADDRESS FOR MARIA CHIP
BKGRND:				;BACKGROUND COLOR
BACKGRND:	ds.b	1	;synonym used by GCC
P0C1:		ds.b	1	;PALETTE 0 - COLOR 1
P0C2:		ds.b	1	;          - COLOR 2
P0C3:		ds.b	1	;          - COLOR 3
WSYNC:		ds.b	1	;WAIT FOR SYNC
P1C1:		ds.b	1	;PALETTE 1 - COLOR 1
P1C2:		ds.b	1	;          - COLOR 2
P1C3:		ds.b	1	;          - COLOR 3
MSTAT:		ds.b	1	;MARIA STATUS: 1 = vblank
P2C1:		ds.b	1	;PALETTE 2 - COLOR 1
P2C2:		ds.b	1	;          - COLOR 2
P2C3:		ds.b	1	;          - COLOR 3
DPPH:				;DISPLAY LIST LIST POINT HIGH BYTE
DPH:		ds.b	1	;synonym used by GCC
P3C1:		ds.b	1	;PALETTE 3 - COLOR 1
P3C2:		ds.b	1	;          - COLOR 2
P3C3:		ds.b	1	;          - COLOR 3
DPPL:				;DISPLAY LIST LIST POINT LOW BYTE
DPL:		ds.b	1	;synonym used by GCC
P4C1:		ds.b	1	;PALETTE 4 - COLOR 1
P4C2:		ds.b	1	;          - COLOR 2
P4C3:		ds.b	1	;          - COLOR 3
CHBASE:		ds.b	1	;CHARACTER BASE ADDRESS
P5C1:		ds.b	1	;PALETTE 5 - COLOR 1
P5C2:		ds.b	1	;          - COLOR 2
P5C3:		ds.b	1	;          - COLOR 3
OFFSET:		ds.b	1	;FOR FUTURE EXPANSION HERE - STORE ZER0 HERE
P6C1:		ds.b	1	;PALETTE 6 - COLOR 1
P6C2:		ds.b	1	;          - COLOR 2
P6C3:		ds.b	1	;          - COLOR 3
CTRL:		ds.b	1	;MARIA CONTROL REGISTER
P7C1:		ds.b	1	;PALETTE 7 - COLOR 1
P7C2:		ds.b	1	;          - COLOR 2
P7C3:		ds.b	1	;          - COLOR 3
;
;	PIA AND TIMER (6532) LOCATIONS
;
	.ORG	$280
;
SWCHA:	.DS.B	1	;LEFT & RIGHT JOYSTICKS
;
;	LEFT RITE
;	7654 3210	;BIT POSITION (=0 IF SWITCH IS CLOSED)
;	---- ----
;	RLDU RLDU	;RIGHT/LEFT/DOWN/UP
;
CTLSWA:	.DS.B	1	;SWCHA DATA DIRECTION (0=INPUT)
;
SWCHB:	.DS.B	1	;CONSOLE SWITCHES
;
;	D7-RITE DIFFICULTY
;	D6-LEFT DIFFICULTY
;	D5/D4 NOT USED
;	D3-PAUSE
;	D2-NOT USED
;	D1-GAME SELECT
;	D0-GAME RESET
;
CTLSWB:	.DS.B	1	;SWCHB DATA DIRECTION (0=INPUT)
;
INTIM:	.DS.B	1	;INTERVAL TIMER READ
	.DS.B	15
TIM1T:	.DS.B	1	;SET 1    CLK INTERVAL (838   NSEC/INTERVAL)
TIM8T:	.DS.B	1	;SET 8    CLK INTERVAL (6.7   USEC/INTERVAL)
TIM64T:	.DS.B	1	;SET 64   CLK INTERVAL (53.6  USEC/INTERVAL)
T1024T:	.DS.B	1	;SET 1024 CLK INTERVAL (858.2 USEC/INTERVAL)
;
RESET	=	1	;bits for consle switches
SELECT	=	2
PAUSE	=	8
;
RAM1	=	$1800	;FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
RAM2	=	$2100	;FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
RAM3	=	$2200	;FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
R1SIZE	=	($2040-RAM1)	;SIZE OF THE RAM1 BLOCK
R2SIZE	=	($2140-RAM2)	;SIZE OF THE RAM2 BLOCK
R3SIZE	=	($2800-RAM3)	;SIZE OF THE RAM3 BLOCK
PTRLO	=	$FC
PTRHI	=	$FD
CTRLO	=	$FE
CTRHI	=	$FF
;
	.subttl	"system macros 7800"
;
;	MARIA MACROS FOR EASIER GRAPHICS CONSTRUCTION
;
;this macro constructs a 4 byte header for display lists
;
	.macro	header	address,palette,width,hpos
	dc.b	\address & $ff
	dc.b	(\palette*$20) | ($1f & -\width)
	dc.b	\address >> 8
	dc.b	\hpos
	.endm
;
;this macro constructs a 5 byte header for display lists
;
	.macro	xheader	address,palette,width,hpos,wm,ind
	dc.b	\address & $ff
	dc.b	((\wm*$80) | $40 | (\ind*$20))
	dc.b	\address >> 8
	dc.b	((\palette*$20) | ($1F & -\width))
	dc.b	\hpos
	.endm
;
;this macro constructs a end-of-display-list header
;
	.macro	nullhdr
	dc.b	0,0
	.endm
;
;this macro constructs a display list entry for the display list list
;
	.macro	display	dli,h16,h8,offset,address
	dc.b	((\dli*$80) | (\h16*$40) | (\h8*$20) | \offset)
	dc.b	\address >> 8
	dc.b	\address & $ff
	.endm
;
;
	.macro	paint	palnum,colornum,color,lum
	lda	#(\color*$10) | \lum
	sta	\bkgrnd | ((\palnum*4) | (\colornum))
	.endm
;
;this macro writes to the crtl register
;
ckoff	=	$0	;normal color
ckon	=	$1	;kill the color
;
dmaoff	=	$3	;turn off dma
dmaon	=	$2	;normal dma
;
char1b	=	$0	;one byte character definition
char2b	=	$1	;two byte character definition
;
bcoff	=	$0	;black border
bcback	=	$1	;background colored border
;
kangoff	=	$0	;transparency
kangon	=	$1	;"kangaroo" mode : no transparency!
;
mode1	=	$0	;160x2 or 160x4 modes
modebd	=	$2	;320b or 320d modes
modeac	=	$3	;320a or 320c modes
;
	.macro	screen	ck,dma,cw,bc,km,mode
	lda	#((\ck*$80) | (\dma*$20) | (\cw*$10) | (\bc*8) | (\km*4)|\mode)
	sta	CTRL
	.endm
;
	.macro	dppload	adr
	lda	#\adr & $ff
	sta	DPPL
	sta	sdppl
	lda	#\adr >> 8
 	sta	DPPH
	sta	sdpph
	.endm
;
;       ---- End Maria equates ----
;
;       ****    Airball Source Code starts here.        ****
;
	.org	$4000
;
earlyini:
	cli     ;sei
	cld
	ldx	#$FF
	txs
	bne	initram
;
	rti		;dummy rti
;
initram:
	lda	#RAM1 >> 8
	sta	PTRHI
	lda	#RAM1 & $FF
	sta	PTRLO
	lda	#R1SIZE >> 8
	sta	CTRHI
	lda	#R1SIZE & $FF
	sta	CTRLO	
	jsr	ramzero
;
	lda	#RAM2 >> 8
	sta	PTRHI
	lda	#RAM2 & $FF
	sta	PTRLO
	lda	#R2SIZE >> 8
	sta	CTRHI
	lda	#R2SIZE & $FF
	sta	CTRLO
	jsr	ramzero
;
	lda	#RAM3 >> 8
	sta	PTRHI
	lda	#RAM3 & $FF
	sta	PTRLO
	lda	#R3SIZE >> 8
	sta	CTRHI
	lda	#R3SIZE & $FF
	sta	CTRLO 
	jsr	ramzero
;
;	Register init:
regs:
	lda	#$47    ;palette 0
        sta	P0C1
	lda	#$87
	sta	P0C2
	lda	#$C7
	sta	P0C3
	lda	#$36	;palette 1
	sta	P1C1
	lda	#$48
	sta	P1C2
	lda	#$5A
	sta	P1C3
	lda	#$6C
	sta	P2C1	;palette 2
	lda	#$24
	sta	P2C2
	lda	#$80
	sta	P2C3
;
	lda	#$99
	sta	P4C1	;palette 4
	lda	#$B9
	sta	P4C2
	lda	#$D9
	sta	P4C3
;
	lda	#$80
        lda     #$70
	sta	BKGRND
	lda	#0
	sta	OFFSET
;
start:			;init SWCHB
	lda	#$14
	sta	CTLSWB
	lda	#0
	sta	SWCHB
        sta     DPPL
        lda     #$4A
        sta     DPPH
        jsr     vcheck
        lda     #$48
        sta     CTRL
hang:
        jsr     direc
        jsr     fire
        ldx     #0
        beq     hang
addx:
        inx
        bne     addx
        beq     hang
;
;	-----
;
;	CALLS
vcheck:
        lda     MSTAT
        and     #$80
        beq     vcheck
        rts 
;
ramzero:
	beq	nofix
	inc	CTRHI
nofix:
	lda	#0
	ldx	#0      ;tax
pokit:
	sta	(PTRLO,X)
	inc	PTRLO
	bne	hiok
	inc	PTRHI
hiok:
	dec	CTRLO
	bne	pokit
	dec	CTRHI
	bne	pokit
	rts
;
direc:
        lda     #0
snooze:
        adc     #1
        bne     snooze
        lda     SWCHA   ;7654
        asl             ;rldu
        bcc     right
        asl     
        bcc     left
        asl     
        bcc     down
        asl     
        bcc     up
        rts
;
right:
        jsr     vcheck
        inc     xmov1+3
        inc     xmov2+3
        inc     xmov3+3
        lda     xmov2+3
        cmp     #$69
        bne     right1
        lda     #$1C
        sta     xmov1+3
        sta     xmov2+3  ;chg room, objs here
        sta     xmov3+3
right1:
        rts
left:
        jsr     vcheck
        dec     xmov1+3
        dec     xmov2+3
        dec     xmov3+3
        lda     xmov2+3
        cmp     #$1C
        bne     left1
        lda     #$69
        sta     xmov1+3
        sta     xmov2+3  ;chg room, objs here
        sta     xmov3+3
left1:
        rts
down:
        jsr     vcheck
        lda     xmov2+2
        cmp     #$EF
        beq     downab
        lda     xmov1+2
        cmp     #$F0
        beq     downaa
        inc     xmov1+2
downaa:
        inc     xmov2+2
        lda     xmov1+2
        cmp     #$F0
        bne     downab
        inc     xmov3+2
downab:
        rts
up:
        jsr     vcheck
        lda     xmov2+2
        cmp     #$D1
        beq     upab
        lda     xmov3+2
        cmp     #$D0
        beq     upaa
        dec     xmov3+2
upaa:
        dec     xmov2+2
        lda     xmov3+2
        cmp     #$D0
        bne     upab
        dec     xmov1+2
upab:
        rts
;
fire:
        lda     INPT0
        and     #$80
        bne     pushed
        rts
pushed:
        jsr     vcheck
        lda     #0
        sta     BKGRND
;       lda     #$4A
;       sta     DPPH
        rts
;
;       -------
;
;
        .org    $4A00
        display 0,0,0,15,$5000
        display 0,0,0,10,$5000
;       dc.b    $0F     ;15
;       dc.b    $50
;       dc.b    0
;       dc.b    $0A     ;10
;       dc.b    $50
;       dc.b    0
;
        dc.b    $0F
        dc.b    rm1ua >> 8
        dc.b    rm1ua & $FF
        dc.b    $0F             
        dc.b    rm1ub >> 8      
        dc.b    rm1ub & $FF     
        dc.b    $0F
        dc.b    rm1ub >> 8
        dc.b    rm1ub & $FF
        dc.b    $0F
        dc.b    rm1ud >> 8
        dc.b    rm1ud & $FF
        dc.b    $0F             
        dc.b    rm1ue >> 8      
        dc.b    rm1ue & $FF     
        dc.b    $4F
        dc.b    rm1uf >> 8
        dc.b    rm1uf & $FF
        dc.b    $4F             
        dc.b    rm1ug >> 8      
        dc.b    rm1ug & $FF    
        dc.b    $4F
        dc.b    rm1uh >> 8
        dc.b    rm1uh & $FF
        dc.b    $0F             
        dc.b    nwlbl1 >> 8     
        dc.b    nwlbl1 & $FF    ;        display 0,0,0,15,nwlbl1
        dc.b    $0F
        dc.b    rm1uj >> 8
        dc.b    rm1uj & $FF     ;        display 0,0,0,15,rm1uj
        dc.b    6
        dc.b    rm1uk >> 8
        dc.b    rm1uk & $FF     ;        display 0,0,0,6,rm1uk
;       display 0,0,0,15,$5000
;       display 0,0,0,15,$5000
;
;       display 0,0,0,15,$5000
;       display 0,0,0,10,$5000
;
        .org    $5000
        header space2,0,2,0
        nullhdr
;
rm1ua:
        header walltpl,1,3,68
        header walltpr,1,3,80
        dc.b    0,0
rm1ub:
        header wallmdl,1,3,68
        header wallmdr,1,3,80
        dc.b    0,0
rm1ud:
        header walltpl,1,3,18
        header wallbtl,1,3,68
        header wallbtr,1,3,80
        header walltpr,1,3,128
        dc.b    0,0
rm1ue:
        header wallmdl,1,3,18
        header linepos,1,5,54
        header lineneg,1,5,84
        header wallmdr,1,3,128
        header floorup,2,8,64
        header arch1,0,3,45
        header arch2,0,3,101
        header pineedl,4,2,76
        dc.b    0,0
rm1uf:
        header wallmdl,1,3,18
        header linepos,1,5,38
        header lineneg,1,5,100
        header wallmdr,1,3,128
        header floorup,2,8,48
        header floordn,2,8,64
        header floorup,2,8,80
        header arch1ex,0,1,45
        header arch2ex,0,1,109
xmov1:
        header ball+$1000,0,3,31    ;ball
        dc.b    0,0
rm1ug:
        header wallbtl,1,3,18
        header linepos,1,5,22
        header lineneg,1,5,116
        header wallbtr,1,3,128
        header floorup,2,8,32
        header floordn,2,8,48
        header floorup,2,8,64
        header floordn,2,8,80
        header floorup,2,8,96
xmov2:
        header ball,0,3,31
        dc.b    0,0
rm1uh:
        header lineneg,1,5,22
        header linepos,1,5,116
        header floordn,2,8,32
        header floorup,2,8,48
        header floordn,2,8,64
        header floorup,2,8,80
        header floordn,2,8,96
xmov3:
        header ball-$1000,0,3,31
        dc.b    0,0
nwlbl1:
        header lineneg,1,5,38
        header linepos,1,5,100
        header floordn,2,8,48
        header floorup,2,8,64
        header floordn,2,8,80
        header aroroot,4,2,78
        dc.b    0,0
rm1uj:
        header lineneg,1,5,54
        header linepos,1,5,84
        header floordn,2,8,64
        dc.b    0,0
rm1uk:
        header linepos+$900,1,5,68
        header lineneg+$900,1,5,70
        dc.b    0,0
;
        .org    $E000
        .include       'room.s'
;
        .org    $FFFA
        dc.b    7,$40,0,$40,7,$40
        .end

                                                                    