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
	put	#$CA,BKGRND   ; green field (may revise in dli)
	put	#$05,P0C1	     ;palette 0
	put	#$08,P0C2	    ; Mountains, sky
	put	#$06,P0C3	    ;
	put	#$C5,P1C1	     ;palette 1
	put	#$C6,P1C2	    ; Playfield
	put	#$C7,P1C3	    ;
	put	#$0A,P2C1	     ;palette 2
	put	#$0C,P2C2	    ; clouds
	put	#$0E,P2C3	    ;
	put  #$B5,P3C1	     ;palette 3
	put  #$B6,P3C2	    ;
	put  #$B7,P3C3	    ;
	put  #$9A,P4C1	     ;palette 4
	put  #$06,P4C2	    ;
	put  #$64,P4C3	    ;
	put  #$10,P5C1	     ;palette 5
	put  #$11,P5C2	    ;
	put  #$12,P5C3	    ;
	 put #$24,P6C1	     ;palette 6  -speedometer
	 put #$03,P6C2	    ;   time display	Motorcycle
	 put #$00,P6C3	    ;   shadow
	put  #$0f,P7C1	     ;palette 7
	put  #$68,P7C2	    ; display readouts
	put  #$d4,P7C3	    ;

	put	#0,OFFSET	    ;$38 future expansion

	put #$C0,LumenBK	;[SSCDLI]
	put #255,DLICOUNT	;

	jsr ZoomDLS		;[SSCZOOM]  Sets up DLists in RAM4.

;DMA on, screen on, mode set:
	jsr waitvb		;to turn on CTRL during VBI
	put #DLL1 &$FF,DPPL	;DPPL/DPPH separated - can't use "putadr"
	put #DLL1 >>8,DPPH

	put #%01000000,CTRL	;COLORon,DMAon,CHAR1by,BORDERbg,TRANSon,MODE160

	put #111,ShiftReg
	put #99,ShiftReg+1
	put #37,ShiftReg+2
	put #%10101011,ShiftReg+3

; Sound effect - static "put-put"
;	put #$0E,AUDC0
;	put #$0F,AUDC1
;	put #$1A,AUDF0
;	put #$1C,AUDF1
;	put #$0F,AUDV0
;	put #$0f,AUDV1

; initialization complete:

	rts
; Z-1________ -0

                                                                                                                                                                               