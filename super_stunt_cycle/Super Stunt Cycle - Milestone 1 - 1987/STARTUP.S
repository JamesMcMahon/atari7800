DEVSYSSTART:	JMP	START
NMI:	
IRQ:		RTI

;*******************************************************************************
;
;	POWER-UP RESET INIT
;
;*******************************************************************************

START:	SEI			;SET UP INTERUPT FLAG
	CLD			;BINARY ARITHMETIC
	LDA	#$FD
	STA	8
	LDA	#0		;CLEAR TIA AND ALL OF RAM
	TAX
.LOOP:	STA	X,0
	DEX
	BNE	.LOOP
	DEX			;X NOW EQUALS FF
	TXS			;SET UP STACK POINTER
	STX	CTLSWA		;INIT PIA PORT AS OUTPUT
				
;
;		PIA AS OUTPUT - ? INPUT FOR JOYSTICKS ? BW
;
	STXI	OVRTIM,TIM64T	;MAKE SURE OVER TIME IS HAPPY
	TAX			;X=0=GAME NUMBER FOR NEW GAME
	JSR	NEWGAME

.over:	


	STAI	0,VDELP0
	STA	VDELP1
	STA	VDELBL
	STA	REFP0
	STA	REFP1
	STA	CTRLPF
	LDX	#6*9
.MLOOP:	LDA	X,MTNPLAY0
	STA	X,MTNPLAY0A
	DEX
	BPL	.MLOOP
	STAI	2,HOLDCNT
	STAI	1,MTNSTART
	PTR	TRACKEND,TRACK
	STAI	20,PERSHIFT
	STAI	$40,MTMASK
	PTR	MTNPLAY0,MOUNTPTR
	
;	STAI	70,CLOUDEND
	STAI	51,MTNEND
	STAI	49,HORIZEND
	STAI	150,TEST
	STAI	0,PLAYF
	STAI	5,FRMCNT
	STA	SCROLLNUM
	STAI	1,HOLDSCROLL
	STAI	1,SHOLDCNT
	STAI	95,CLOUDEND ;used here as temp for loop counter
			;not as cloud end!!
.LOP:
	JSR	SHIFTLEFT
	DEC	CLOUDEND
	BNE	.LOP
	STAI	62,CLOUDEND ;70
	ldx	#17
	lda	#0
.MIL:	sta	x,SONG0_PTR
	DEX
	BPL	.MIL
	JMP	OVRSCN


RESET:
	RTS
;******************************************************

;	SUBROUTINE TO HANDLE THE CONSOLE SELECT SWITCH
SELECT:
	RTS
;******************************************************

NEWGAME:
	RTS
;******************************************************

