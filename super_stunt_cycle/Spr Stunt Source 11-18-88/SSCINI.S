;@A D	 *4>HR\+p
; Z-1________ -0
	
	.subttl "SSCINI.S:  Initialization"
; Z-1________ -0

WarmStart:
	put #$0F,BACKGRND	;tag white screen on init

	jsr waitvb		;during vertical blank,   [SSCSUB]  
	put #%01100000,CTRL	;shut off DMA without forbidden bits

; System Display List List pointer
	put #DLL0 &$FF,DPPL	;DPPL/DPPH separated - can't use "putadr"
	put #DLL0 >>8,DPPH

	put  #%00110100,CTLSWB	;Set consol switch mask
	put  #0,SWCHB		;Assures shut-off of unused bits

	putadr  RAM2,POINT  	;[SSCEQU]  $1800-$1FFF (2112 bytes)
	putadr  R2SIZE,COUNT	; Store COUNT zeroes starting at POINT.  [SSCSUB]
	 jsr	ramzero		
	putadr  RAM3,POINT	;[SSCEQU]  $2100-$213F (64 bytes)
	putadr  R3SIZE,COUNT
	 jsr	ramzero
	putadr  RAM4,POINT	;[SSCEQU]  $2200-$27FF (1024 bytes)
	putadr  R4SIZE,COUNT
	 jsr	ramzero

; Palette 0 is for sky, mountains - blue and greys
; Palette 1-5 are for the playfield - greens
; Palette 6 is for the Motorcycle   - greys
; Palette 7 is for the display readouts - bright colors
	put #$CA,BKGRND   ; green field (may revise in dli)
	put #$04,P0C1	     ;palette 0
	put #$09,P0C2	    ; Mountains, sky
	put #$06,P0C3	    ;
	put #$C8,P1C1	     ;palette 1
	put #$d5,P1C2	    ; Playfield
	put #$d7,P1C3	    ;
	put #$0D,P2C1	     ;palette 2
	put #$0F,P2C2	    ; clouds
	put #$0B,P2C3	    ;
	put  #$74,P3C1	     ;palette 3
	put  #$64,P3C2	    ;   unused
	put  #$44,P3C3	    ;
	put  #$03,P4C1	     ;palette 4
	put  #$05,P4C2	    ; Shading on bike
	put  #$06,P4C3	    ;
	put  #$00,P5C1	     ;palette 5
	put  #$00,P5C2	    ; Atascii text colors
	put  #$00,P5C3	    ;
	 put #$24,P6C1	     ;palette 6  -speedometer
	 put #$03,P6C2	    ;   time display	Motorcycle
	 put #$00,P6C3	    ;   shadow
	put  #$0f,P7C1	     ;palette 7
	put  #$68,P7C2	    ; display readouts
	put  #$d4,P7C3	    ;

	put #0,OFFSET	    ;$38 future expansion

	put #255,DLICOUNT	;[SSCDLI] line interrupt synchronizer

* Zoom Effect Initialization:
	putadr Course0,Track	;[SSCZOOM] pg0 pointer to start of course
	put #0,Step		;[SSCZOOM] position in course, reset each circuit
	put #80,Fifo-1		;init foreground center for demo
	jsr ZeroMatrix		;[SSCSUB] clears matrix to zeros
	jsr FlushFifo		;[SSCZOOM] zeros Fifo

;DMA on, screen on, mode set:
	jsr waitvb		;to turn on CTRL during VBI
	put #DLL1 &$FF,DPPL	;DPPL/DPPH separated - can't use "putadr"
	put #DLL1 >>8,DPPH

	lda #0
	ldx #7
.5:	sta Event,x
	dex
	bpl .5

	put #3,BounceTo
	sta BounceNow

	put #%01000000,CTRL	;COLORon,DMAon,CHAR1by,BORDERbg,TRANSon,MODE160

	put #%01110110,ShiftReg		;Seed the pseudorandom generator with
	put #%00011110,ShiftReg+1	;almost any busy pattern, but test it.
	put #%11000001,ShiftReg+2	;
	put #%10101011,ShiftReg+3	;





*  Sound effect - static "put-put"

; AUDC:  1= low, 2&3= noisy&low, 4&5= pure midrange, 6-10= low noise
;		11= white noise, 12&13= pure lowrange, 15= low noise
	put #$06,AUDC0		;ROAR
	put #$02,AUDC1		;RUMBLE

; AUDF: 0 - $1F
	put #$0D,AUDF0		;harmonious
	put #$07,AUDF1		;  "

; AUDV: 0 - $F
	put #$06,AUDV0		;blended
	put #$0f,AUDV1		;  "

; Text Fade In/Out [SSCSUB], var. in RAM3

	put #0,TextLum		
	sta TextLin
	sta ST0		;will reset when these all zero
	sta ST1
	sta ST2
	sta ST3

; initialization complete:


; temporary init for demo.  Will be dispatched as needed in final:
	
	jsr SetWend	;[SSCZOOM]
	
	rts

; Z-1________ -0

