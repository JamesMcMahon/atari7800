*  ______________________________________________________________


    .subttl "SSCDLI.S:  Display Line Interrupts"
;    James St. Louis 04148910
*  ______________________________________________________________


DisplayLineInterrupts:
     sta saveA    ;fast save
    inc DLICOUNT    ; master DLI counter [PG0]
    lda DLICOUNT
  sta WSYNC
     bne .1    ;This form allows easy insert/delete of interrupts
    jmp DLI0    ;without disruption.  The last DLI resets DLICOUNT.
.1:    cmp #1    ;
    bne .2    ;Each cmp is a delay, offsetting lower dli's more.
    jmp DLI1
.2:    cmp #2    ;delay limit is not reached sofar
    bne .3    ;
    jmp DLI2
.3:    ;  6 and 7  considerably delayed at outset, use WSYNC if necessary.
.9:  lda saveA
    rti

DLI0:        ;30 lines above visible screen
    sta WSYNC
    put #%01000000,CTRL    ;COLORon,DMAon,CHAR1by,BORDERbg,TRANSon,MODE160
    put #$9F,BKGRND         ;blue sky
    put #$24,P6C1         ;palette 6 color 1 brown
    put #3,P6C2           ;palette 6 color 2 grey

     stx saveX           ;pg0 [sscequ].  A already saved

    ldx #4        ;5 of 8 reserved "Event" timers, 1/60 sec per count
.0: lda Event,x   ;
    beq .1        ;
    dec Event,x   ;
.1: dex           ;
    bpl .0        ;

TopRiderReader:
	inc TRclockphase	;[SSCPG0]
	ldx TRclockphase   ; 60 clock pulses per second
	beq .0
    cpx #8             ; 0-8 for 9 phases total	
    beq .8
;TRphase1to7
   lda SWCHA
   and #%00000011      ; read only right joystick plug
   sta TRdata,x         ;[SSCPG0]
   put #%00001000,SWCHA   ; bit 3 is clock "step"
   bne .9		;very close timing

.0:  put #%00000100,SWCHA	   ; bit 2 is shift register "READ MODE"
    bne .9 ;always
.8:
   lda SWCHA
   and #%00000011	  ; read only right joystick plug
   sta TRdata,x         ;[SSCPG0]
	ldx #$FF 		   ;becomes zero on next pass
	stx TRclockphase
	ldx #7
.81:
     lda TRdata,x 		;invalid data read is impossible due to this
	 sta TRlatch,x      ;when read from TRlatch
	dex
	bpl .81
.9:  ldx saveX
     lda saveA
     rti


;  9 phases to entire read cycle.  New state of bike about 6 times/sec.
;   The routine above only READS the motorcycle on joystick input #2.
;   (Low bits of SWCHA faster to read.), doesn't interpret results.

;  Lower screen interrupt continually writes 0's to the two output lines
;  clock and mode.  Hence any line set high in the interrupt at the top
;  of the screen will be set low at the bottom.

;  Phase 0  All output lines low.  Disconnect detected here, but is
;           decoded outside the interrupts, as is the state itself.
;           Mode line set high to load the shift registers in Top Rider.

;  Phase 1-7 Copy bytes from port to 7 bytes on page 0.  

;  Phase 8  zips the 7 data bytes to a "latched data" array on page 0.
;           During the transfer, a "data ready" flag is held "not ready".
;           This tells code outside the interrupts to come back later.


DLI1:        ;base of mountains
;no WSYNC here else instability
    put #$B5,BKGRND    ;horizon gradient dark green
.11:    sta WSYNC    ;#1
    put #$B6,BKGRND    ;horizon gradient lighter green
.12:    sta WSYNC    ;#2
    put #$C7,BKGRND    ;horizon gradient (better than C6) medium green
.13:    sta WSYNC    ;#3
    inc WhirliGig      ; visible indicator, "random" if sample timed externally
    put #$C8,BKGRND    ;horizon gradient light green
.14:    sta WSYNC    ;#4
    put #$C9,BKGRND    ;very light green prevalent in foreground
    lda saveA
    rti

* The active playfield area exists in this time zone.

DLI2:        ; just above text line
    sta WSYNC    
    put #0,BKGRND    ;black background, and 
    sta P6C1    ;eliminates off-color line between text and picture
    sta P6C2    ;
    put #255,DLICOUNT    ;count ended
    put #%01000011,CTRL    ;COLORon,DMAon,CHAR1by,BORDERbg,TRANSon,MODE320ac
	put #%00000000,SWCHA   ;Lines low at top of text line
    lda saveA
    rti    

*  ______________________________________________________________




