;@A D	 *4>HR\+p
; Z-1________ -0

	.subttl "SSCDLI.S:  Display Line Interrupts"		;10/30/88
; Z-1________ -0

DisplayLineInterrupts:
	sta saveA	;fast save
	inc DLICOUNT	; master DLI counter
	lda DLICOUNT	;******************
	sta WSYNC
 	bne .1	;This form allows easy insert/delete of interrupts
	jmp DLI0	;without disruption.  The last DLI resets DLICOUNT.
.1:	cmp #1	;
	bne .2	;Each cmp is a delay, offsetting lower dli's more.
	jmp DLI1
.2:	cmp #2	;
	bne .3	;
	jmp DLI2
.3:
;	cmp #3	; 
; 	bne .4	;
;	jmp DLI3
;.4:
;	cmp #4	;
;	bne .5	;
;	jmp DLI4
;.5:	cmp #5	;
;	bne .6	;
;.6:	cmp #6	;
;	bne .7	;considerably delayed at outset, use WSYNC if necessary
.9:	lda saveA
	rti

DLI0:		;30 lines above visible screen
	sta WSYNC
	put #%01000000,CTRL	;COLORon,DMAon,CHAR1by,BORDERbg,TRANSon,MODE160
	put #$9F,BKGRND
	put #$24,P6C1
	put #3,P6C2
	stx saveX		;pg0 [sscequ]
	ldx #4		;only service timers in use (8 available)
.0: lda Event,x
	beq .1
	dec Event,x
.1: dex
	bpl .0
	lda Mountain1		;*********** bank switch?
	ldx saveX
	lda saveA
	rti

DLI1:		;base of mountains
	put #$B5,BKGRND	;no WSYNC here else instability
.11:	sta WSYNC	;#1
	put #$B6,BKGRND
.12:	sta WSYNC	;#2
	put #$C7,BKGRND	;surmounts C6 luminance error
.13:	sta WSYNC	;#3
	inc WhirliGig    ; visible indicator, "random" if sample timed externally
	put #$C8,BKGRND
.14:	sta WSYNC	;#4
	put #$C9,BKGRND
	lda saveA
	rti

;DLI2:		;middle of bike
;	sta WSYNC 	
;;	put #$d5,BKGRND		;D5,BKGRND
;	lda saveA
;	rti	

DLI2:		; just above text line
	lda #0
;	sta WSYNC	
	sta BKGRND
	sta P6C1	; eliminates off-color line between text and picture
	sta P6C2	;
	put #255,DLICOUNT	;counts to 7
	put #%01000011,CTRL	;COLORon,DMAon,CHAR1by,BORDERbg,TRANSon,MODE320ac
	lda saveA
	rti	

; Z-1________ -0


