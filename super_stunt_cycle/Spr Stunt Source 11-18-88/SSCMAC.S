;@A D	 *4>HR\+p
; Z-1________ -0

	.subttl "SSCMAC.S:  Macros for Atari 7800"
; Z-1________ -0

*____ MACROS TO ABBREVIATE SYNTAX ______

	.macro put this,there
	lda \this	      
	sta \there	      
	.endm

	.macro putadr adr,des
	lda	#\adr &$ff
	sta	\des
	lda	#\adr >>8
 	sta	\des+1
	.endm

;.macro add num1,num2
;clc
;lda \num1
;adc \num2
;.endm

;.macro sub num1,num2
;sec
;lda \num1
;sbc \num2
;.endm
; Z-1________ -0

;____ CRITICAL SYSTEM SETUP SIMPLIFICATION _____

; Param options:
;COLORon	 =  $0	;normal color
;COLORoff	 =  $1	;kill the color
;DMAoff	=   $3	;turn off dma
;DMAon	=   $2	;normal dma
;CHAR1by	 =  $0	;one byte character definition
;CHAR2by	 =  $1	;two byte character definition
;BORDERbk	=   $0	;black border
;BORDERbg	=   $1	;background colored border
;TRANSon	 =  $0	;transparency
;TRANSoff	 =  $1	;"kangaroo" mode : no transparency!
;mode160	  =   $0	;160x2 or 160x4 modes
;mode320bd  =   $2	;320b or 320d modes
;mode320ac  =   $3	;320a or 320c modes

;  %01000000 	;for 160 mode
;  %01000011 	;for 320ac mode

*____ DISPLAY LIST AND DISPLAY LIST LIST ______

*  "dlist" constructs a 4 byte header for display lists:

  .macro dlist address,palette,width,hpos	 
	dc.B	\address & $ff		       
	dc.B	(\palette*$20) | ($1f & -\width)     
	dc.B	\address >> 8		       
	dc.B	\hpos			       
	.endm

*  "dlist_" constructs a 4 byte header with 2 byte integral nullhdr:

	.macro dlist_ address,palette,width,hpos
	dc.B	\address & $ff		       
	dc.B	(\palette*$20) | ($1f & -\width)     
	dc.B	\address >> 8		       
	dc.B	\hpos			       
	dc.B	0,0
	.endm
;note- byte sequence is loaddr, pal/wid, hiaddr, hpos
; Z-1________ -0

*  "dlistX" constructs a 5 byte header for display lists:

;  .macro dlistX address,palette,width,hpos,wm,ind
;	dc.B	\address & $ff		       
;	dc.B	((\wm*$80) | $40 | (\ind*$20))       
;	dc.B	\address >> 8		       
;	dc.B	((\palette*$20) | ($1F & -\width))   
;	dc.B	\hpos			       
;	.endm

*  "dlistX_" constructs a 5 byte header for display lists with 2 byte nullheader

  .macro dlistX_ address,palette,width,hpos,wm,ind
	dc.B	\address & $ff
	dc.B	((\wm*$80) | $40 | (\ind*$20))
	dc.B	\address >> 8
	dc.B	((\palette*$20) | ($1F & -\width))
	dc.B	\hpos   
	dc.B	0,0
	.endm

; Z-1________ -0

*  "display" constructs a 3 byte entry for the display list list:

	.macro display dli,h16,h8,offset,address

	dc.B	((\dli*$80) | (\h16*$40) | (\h8*$20) | \offset)
	dc.B	\address >> 8
	dc.B	\address & $ff
	.endm

;	.macro paint palnum,colornum,color,lum
;	lda	#(\color*$10) | \lum
;	sta	\bkgrnd | ((\palnum*4) | (\colornum))
;	.endm

; Z-1________ -0

