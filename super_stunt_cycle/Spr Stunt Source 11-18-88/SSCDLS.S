;@A D	 *4>HR\+p
; Z-1________ -0

	.subttl "SSCDLS.S:  Display Lists"
; Z-1________ -0

;_______ Display Lists ___________________________

; <=512 bytes.  Presently at RAM3 [SSC]
;  macro dlist address,palette,width,hpos ( _ indicates nullheader at end)
;  macro dlistX address,palette,width,hpos,wm,ind

; Palette 0 is for sky, mountains - blue and greys
; Palette 1-5 are for the playfield - greens
; Palette 6 is for the Motorcycle   - greys
; Palette 7 is for the display readouts - bright colors

sky:
	dlist_ BLANK00,0,0,0		;BLANK00 is 1-16 blank (also bike0)

clouds:
	dlist  Cloud1,2,24,0		;clouds begin evenly distributed
	dlist  Cloud1,2,24,64
	dlist  Cloud1,2,24,128
	dlist_ Cloud1,2,24,196

field:
	dlist_ BLANK00,1,1,4		;temporary
; Z-1________ -0

mountains:
	dlist  Mountain1,0,11,0 	;place holder graphics here
	dlist  Mountain1,0,13,42	;will eventually be a complete
	dlist  Mountain1,0,11,94	;circular panorama.
	dlist  Mountain1,0,13,138	
	dlist  Mountain1,0,13,180
	dlist_ Mountain1,0,11,220

b0z0:	;Top scan line of bike with Zoom overlay.  2 scan lines of each in b0.
	dlist  PIXL0F,1,31,10		;PIXL0F largest "blurry pixels"
	dlist  PIXL0F+13,1,17,82		;+13 is right edge.
	dlist  BIKE00+$F00,6,19,4	  ;18 bytes per b0 section
	dlist_ BIKE01+$F00,6,17,80
b0z1:
	dlist  PIXL0F,1,31,10
	dlist  PIXL0F+13,1,17,82
	dlist  BIKE00+$E00,6,19,4
	dlist_ BIKE01+$E00,6,17,80
b0z2:
	dlist  PIXL0F,1,31,10
	dlist  PIXL0F+13,1,17,82
	dlist  BIKE00+$C00,6,19,4
	dlist_ BIKE01+$C00,6,17,80
b0z3:
	dlist  PIXL0F,1,31,10
	dlist  PIXL0F+13,1,17,82
	dlist  BIKE00+$A00,6,19,4
	dlist_ BIKE01+$A00,6,17,80
b0z4:
	dlist  PIXL0F,1,31,10
	dlist  PIXL0F+13,1,17,82
	dlist  BIKE00+$800,6,19,4
	dlist_ BIKE01+$800,6,17,80
b0z5:
	dlist  PIXL0F,1,31,10
	dlist  PIXL0F+13,1,17,82
	dlist  BIKE00+$600,6,19,4
	dlist_ BIKE01+$600,6,17,80
b0z6:
	dlist  PIXL0F,1,31,10
	dlist  PIXL0F+13,1,17,82
	dlist  BIKE00+$300,6,19,4
	dlist_ BIKE01+$300,6,17,80
b0z7:	          
	dlist  PIXL0F,1,31,10
	dlist  PIXL0F+13,1,17,82
	dlist  BIKE00,6,19,4
	dlist_ BIKE01,6,17,80
		
b1z0:			;4 scan lines per b1 section.
	dlist  PIXL0F,1,31,5
	dlist  PIXL0F+13,1,17,88
	dlist  BIKE02+$C00,6,19,4		;18 bytes per b1
	dlist_ BIKE03+$C00,6,19,80
b1z1:
	dlist  PIXL0F,1,31,5
	dlist  PIXL0F+13,1,17,88
	dlist  BIKE02+$800,6,19,4
	dlist_ BIKE03+$800,6,19,80
b1z2:
	dlist  PIXL0F,1,31,5
	dlist  PIXL0F+13,1,17,88
	dlist  BIKE02+$400,6,19,4
	dlist_ BIKE03+$400,6,19,80
b1z3:
	dlist  PIXL0F,1,31,5
	dlist  PIXL0F+13,1,17,88
	dlist  BIKE02,6,19,4
	dlist_ BIKE03,6,19,80

b2z0:	     		;8 scan lines per b2 section
	dlist  PIXL0F,1,31,5
	dlist  PIXL0F+10,1,20,88
	dlist  BIKE04+$800,6,19,4
	dlist_ BIKE05+$800,6,19,80
b2z1:
	dlist  PIXL0F,1,31,5
	dlist  PIXL0F+10,1,20,88
	dlist  BIKE04,6,19,4
	dlist_ BIKE05,6,19,80

b3z0:					        
	dlist  PIXL0F,1,31,5
	dlist  PIXL0F+10,1,20,88
	dlist  BIKE06+$800,6,19,4
	dlist_ BIKE07+$800,6,19,80
b3z1:
	dlist  PIXL0F,1,31,5
	dlist  PIXL0F+10,1,20,88
	dlist  BIKE06,6,19,4
	dlist_ BIKE07,6,19,80

; Z-1________ -0


;LineBufr in [SSCTEXT]
txt1:
	dlist_ LineBufr,5,31,20
txt2:
	dlist_ LineBufr+$20,5,31,20
txt3:
	dlist_ LineBufr+$40,5,31,20
txt4:
	dlist_ LineBufr+$60,5,31,20
txt5:
	dlist_ LineBufr+$80,5,31,20
txt6:
	dlist_ LineBufr+$A0,5,31,20
txt7:
	dlist_ LineBufr+$C0,5,31,20
txt8:				;one page LineBufr
	dlist_ LineBufr+$E0,5,31,20	

; Z-1________ -0

ZOOM:		;Headers describing terrain

	dlist  PIXL0D+$F00,1,4,68		;sc0: narrowest portion
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$E00,1,4,68		;sc1:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$D00,1,4,68		;sc2:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$C00,1,5,68		;sc3:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$B00,1,5,68		;sc4:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$A00,1,5,68		;sc5:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$900,1,5,68		;sc6:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$800,1,5,68		;sc7:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$700,1,6,68		;sc8:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$600,1,6,68		;sc9:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$500,1,6,68		;scA:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$400,1,6,68		;scB:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$300,1,6,68		;scC:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$200,1,6,68		;scD:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D+$100,1,6,68		;scE:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0D,1,6,68			;scF:
	dlist_ BIKE00,0,0,0
; 
	dlist  PIXL0A+$F00,1,12,56 		;sc10
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$E00,1,12,56		;sc11
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$D00,1,12,56		;sc12
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$C00,1,12,56		;sc13:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$B00,1,12,56		;sc14:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$A00,1,12,56		;sc15:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$900,1,12,56		;sc16:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$800,1,12,56		;sc17:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$700,1,12,56		;sc18:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$600,1,12,56		;sc19:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$500,1,12,56		;sc1A:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$400,1,12,56		;sc1B:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$300,1,12,56		;sc1C:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$200,1,12,56		;sc1D:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A+$100,1,12,56		;sc1E:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0A,1,12,56			;sc1F:
	dlist_ BIKE00,0,0,0
;
	dlist  PIXL09+$F00,1,18,44		;sc20:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$E00,1,18,44		;sc21:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$D00,1,18,44		;sc22:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$C00,1,18,44		;sc23:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$B00,1,18,44		;sc24:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$A00,1,18,44		;sc25:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$900,1,18,44		;sc26:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$800,1,18,44		;sc27:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$700,1,18,44		;sc28:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$600,1,18,44		;sc29:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$500,1,18,44		;sc2A:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$400,1,18,44		;sc2B:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$300,1,18,44		;sc2C:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$200,1,18,44		;sc2D:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09+$100,1,18,44		;sc2E:
	dlist_ BIKE00,0,0,0
	dlist  PIXL09,1,18,44			;sc2F:
	dlist_ BIKE00,0,0,0  
;
	dlist  PIXL0C+$F00,1,24,32		;sc30:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$E00,1,24,32		;sc31:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$D00,1,24,32		;sc32:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$C00,1,24,32		;sc33:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$B00,1,24,32		;sc34:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$A00,1,24,32		;sc35:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$900,1,24,32		;sc36:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$800,1,24,32		;sc37:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$700,1,24,32		;sc38:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$600,1,24,32		;sc39:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$500,1,24,32		;sc3A:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$400,1,24,32		;sc3B:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$300,1,24,32		;sc3C:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$200,1,24,32		;sc3D:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C+$100,1,24,32		;sc3E:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0C,1,24,32			;sc3F:
	dlist_ BIKE00,0,0,0
;					 
	dlist  PIXL0F+$F00,1,30,20 		;sc40:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$E00,1,30,20		;sc41:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$D00,1,30,20		;sc42:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$C00,1,30,20		;sc43:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$B00,1,30,20		;sc44:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$A00,1,30,20		;sc45:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$900,1,30,20		;sc46:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$800,1,30,20		;sc47:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$700,1,30,20		;sc48:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$600,1,30,20		;sc49:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$500,1,30,20		;sc4A:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$400,1,30,20		;sc4B:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$300,1,30,20		;sc4C:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$200,1,30,20		;sc4D:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F+$100,1,30,20		;sc4E:
	dlist_ BIKE00,0,0,0
	dlist  PIXL0F,1,30,20			;sc4F:
	dlist_ BIKE00,0,0,0

ZH_len	= *-ZOOM

;__________ SSCPIX1.S __________________

;   BLANK00	One byte wide object filled with color 00
; 	BIKE00	Upper left segment of motorcycle
;	BIKE01	Upper right segment of motorcycle
;	BIKE02	Left upper mid segment of motorcycle
;	BIKE03	Right upper mid segment of motorcycle
;	BIKE04	Left lower mid segment of motorcycle
;	BIKE05	Right lower mid segment of motorcycle
;	BIKE06	Left lower segment of motorcycle
;	BIKE07	Right lower segment of motorcycle
;	NMBR08	Numbers 0-9 in #14 type
;	PIXL09	Zoom 32-47
;	PIXL0A	Zoom 48-63
;	NULL0B	: and ! (! in same color 3 as "stop")
;	PIXL0C	Zoom 16-31
;	PIXL0D	Zoom 64-79
;	NULL0E	"ST" probably will be Zoom detail also
;	PIXL0F	Zoom 0-15
;	NULL10	"OP"
			    

; Z-1________ -0
