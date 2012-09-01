;@MAD	 *4>HR\+p		     
; z-1______ -0

	.LIST
	.6502
	.TITLE  "SUPER STUNT CYCLE   John Boeschen & Co."
    .subttl "SSC1.S:  Include List - Bank 1"
; z-1______ -0

	.include "SSCEQU.S"	;Atari 7800 System Equates, global variables
	.include "SSCMAC.S"	;Special syntax ("put", "header", etc.)
; z-1______ -0

*____ RAM BLOCKS ( <4K total as defined in [SSCEQU]) ___

;"RAM2" $1800 FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
;R2SIZE=$840 $1800 to $203F, $840 or 2112 bytes.  Graphic buffers.   (1088 unused)

	.org RAM2	;2K+ RAM at $1800
Dlsts:	ds.B 1024	; Mutable display lists.

;"RAM3" at $2100, first segment of memory minus the ZP,stack, TIA & Maria
;R3SIZE=$40 $2100 to $213F, $40 or 64 bytes.  (64 unused)

;"RAM4" at $2200  first segment of memory minus the ZP,stack, TIA & Maria
;R4SIZE=$400 $2200 to $27FF, $400 or 1024 bytes.	   (768 unused)

	.org RAM4	; 1K RAM at $2200
LineBufr: ds.B 256	; [SSCTEXT] text image buffer, decompression area, &c.

;____ 3 SWITCHED 16K ROM BANKS $8000-$BFFF __________

; Approx. 8 types of effects separated into 3 banks:
; Bank 1:  Trail, holes, rocks
; Bank 2:  Hill R, Hill L, Trench
; Bank 3:  Big Hill, Canyon

*____ Bank 1: Trail, Holes, and Rocks _______________

;	.org $8000	; 4K Images:  Rock and Hole
;	.org $9000	; 4K Course Data
;	.include "SSCROUTE.S"
;	.org $A000	; 4K Images:  Game Play variation code
	.org $B000	; 4K Images:  Landscape
	.include "SSCPIX1.S" 

;____ 1 FIXED 16K ROM BANK $C000 to $FFFF, 16K ______

	.org $C000	; 1K, $400, approx. $144 used sofar
DLL:    .include "SSCDLL.S"	; Display List Lists. 
	.org DLL+$800	; 3K, $C00, approx. $39D used sofar
DLS:    .include "SSCDLS.S"	; Display Lists	  

	.org $D000	; 4K Images:  Foreground bike, mountains, clouds
	.include "SSCPIX2.S"	; 
	.org $E000	; 1K Character Set:
	.include "SSCASCII.S"	; 1K Alphanumeric (ATASCII) character set
	.include "SSCTABLE.S"	; Math, no data
	.include "SSCTEXT.S"	; 3K plaintext messages

* 3K Resident "Operating System" code in FIXED ROM
	.org $F000		
RUN:
	.include "SSCNEXUS.S" 	;Main Loop and dispatch, "Master Control Program"
	.include "SSCINI.S"	; Set ups	
	.include "SSCSUB.S"	; Print, Clear, change
	.include "SSCZOOM.S"	; Playfield forward movement
	.include "SSCFX.S"	; Special Effects - Nature, crash, explode, etc.
;	.include "SSCSOUND.S"	; put-put, growl, crash, crunch, fanfares.

;____ INTERRUPTS ____________________________________

DLI:  .include "SSCDLI.S"	; Display Line Interrupts

DummyRTI:  rti	; Temporarily unused $4395

;____ ENCRYPTION AND 6502 VECTORS ___________________

	.org  $FF7A
	.include  "SSCENC.S"	;Encryption block of 128 bytes
;6502 Vectors at $FFFA-$FFFF
   dc.W  DLI,RUN,$FF80	;[*] Interrupt Vectors for the 6502:
;  interrupts in [SSCDLI]	$FFFA=NMI $FFFC=Reset $FFFE=IRQ ($ff80=dload)

        .end
; Z-1________ -0
