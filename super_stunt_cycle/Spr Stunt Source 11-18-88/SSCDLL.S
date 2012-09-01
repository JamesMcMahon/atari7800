;@A D	 *4>HR\+p
; Z-1________ -0

	.subttl "SSCDLL.S:  Display List Lists"
; Z-1________ -0

;*___________ Display List List 1  __________

; This is approx. one page of DLL.  Two pages = max. allowable.


;"display" dli,h16,h8,(zone size),address:

DLL0:	 	; blank screen with no DLIs
	display 0,0,0,15,sky
	display 0,0,0,15,sky
	display 0,0,0,15,sky
	display 0,0,0,15,sky
	display 0,0,0,15,sky
	display 0,0,0,15,sky
	display 0,0,0,15,sky
	display 0,0,0,15,sky
	display 0,0,0,15,sky

DLL1:			   ;VIS: SCAN:   DL:
    display 1,0,0,15,sky	   ;_i___$00-$0F  0 | off-screen	*dli 0
Bounce1:
    display 0,0,0,10,sky	   ;_i___$10-$1F  1 |
    display 0,0,0,15,clouds
    display 0,0,0,15,mountains  ; v   $20-$2F  2 | Horizon		
    display 1,0,0,1,field	   ; v   $30-$3F  3 |Background	*dli 1

* Dynamic DLL area:  (%10000001 for DLI and %00000001 no DLI, HiAddr, LoAddr.)

;16 zone #0
	display 0,0,0,0,ZOOM		;sc0  
	display 0,0,0,0,ZOOM+10		;sc1	
	display 0,0,0,0,ZOOM+20		;sc2
	display 0,0,0,0,ZOOM+30		;sc3
	display 0,0,0,0,ZOOM+40		;sc4
	display 0,0,0,0,ZOOM+50		;sc5
	display 0,0,0,0,ZOOM+60		;sc6
	display 0,0,0,0,ZOOM+70		;sc7
	display 0,0,0,0,ZOOM+80		;sc8
	display 0,0,0,0,ZOOM+90		;sc9
	display 0,0,0,0,ZOOM+100		;scA
	display 0,0,0,0,ZOOM+110		;scB
	display 0,0,0,0,ZOOM+120		;scC
	display 0,0,0,0,ZOOM+130		;scD
	display 0,0,0,0,ZOOM+140		;scE
	display 0,0,0,0,ZOOM+150		;scF
;16 zone #1	       
	display 0,0,0,0,ZOOM+160		;sc10 
	display 0,0,0,0,ZOOM+170		;sc11
	display 0,0,0,0,ZOOM+180		;sc12
	display 0,0,0,0,ZOOM+190		;sc13
	display 0,0,0,0,ZOOM+200		;sc14
	display 0,0,0,0,ZOOM+210		;sc15
	display 0,0,0,0,ZOOM+220		;sc16
	display 0,0,0,0,ZOOM+230		;sc17
	display 0,0,0,0,ZOOM+240		;sc18
	display 0,0,0,0,ZOOM+250		;sc19
	display 0,0,0,0,ZOOM+260		;sc1A
	display 0,0,0,0,ZOOM+270		;sc1B
	display 0,0,0,0,ZOOM+280		;sc1C
	display 0,0,0,0,ZOOM+290		;sc1D
	display 0,0,0,0,ZOOM+300		;sc1E
	display 0,0,0,0,ZOOM+310		;sc1F
;16 zone #2	       
	display 0,0,0,0,ZOOM+320		;sc20
	display 0,0,0,0,ZOOM+330		;sc21
	display 0,0,0,0,ZOOM+340		;sc22
	display 0,0,0,0,ZOOM+350		;sc23
	display 0,0,0,0,ZOOM+360		;sc24
	display 0,0,0,0,ZOOM+370		;sc25
	display 0,0,0,0,ZOOM+380		;sc26
	display 0,0,0,0,ZOOM+390		;sc27
	display 0,0,0,0,ZOOM+400		;sc28
	display 0,0,0,0,ZOOM+410		;sc29
	display 0,0,0,0,ZOOM+420		;sc2A
	display 0,0,0,0,ZOOM+430		;sc2B
	display 0,0,0,0,ZOOM+440		;sc2C
	display 0,0,0,0,ZOOM+450		;sc2D
	display 0,0,0,0,ZOOM+460		;sc2E
	display 0,0,0,0,ZOOM+470		;sc2F
;16 zone #3	       
	display 0,0,0,0,ZOOM+480		;sc30
	display 0,0,0,0,ZOOM+490		;sc31
	display 0,0,0,0,ZOOM+500		;sc32
	display 0,0,0,0,ZOOM+510		;sc33
	display 0,0,0,0,ZOOM+520		;sc34
	display 0,0,0,0,ZOOM+530		;sc35
	display 0,0,0,0,ZOOM+540		;sc36
	display 0,0,0,0,ZOOM+550		;sc37
	display 0,0,0,0,ZOOM+560		;sc38
	display 0,0,0,0,ZOOM+570		;sc39
	display 0,0,0,0,ZOOM+580		;sc3A
	display 0,0,0,0,ZOOM+590		;sc3B
	display 0,0,0,0,ZOOM+600		;sc3C
	display 0,0,0,0,ZOOM+610		;sc3D
	display 0,0,0,0,ZOOM+620		;sc3E
	display 0,0,0,0,ZOOM+630		;sc3F
;16 zone #4	       
	display 0,0,0,0,ZOOM+640		;sc40
	display 0,0,0,0,ZOOM+650		;sc41
	display 0,0,0,0,ZOOM+660		;sc42
	display 0,0,0,0,ZOOM+670		;sc43
	display 0,0,0,0,ZOOM+680		;sc44
	display 0,0,0,0,ZOOM+690		;sc45
	display 0,0,0,0,ZOOM+700		;sc46
	display 0,0,0,0,ZOOM+710		;sc47

	display 0,0,0,0,ZOOM+710		;sc47  48
	display 0,0,0,0,ZOOM+720		;sc48  49	 Bike/PF overlap
	display 0,0,0,0,ZOOM+730		;sc49  4A	 half resolution vertically
	display 0,0,0,0,ZOOM+730		;sc49  4B
	display 0,0,0,0,ZOOM+740		;sc4A  4C
	display 0,0,0,0,ZOOM+740		;sc4A  4D
	display 0,0,0,0,ZOOM+750	 	;sc4B  4E 
	display 0,0,0,0,ZOOM+750	 	;sc4B  4F
				
;	display 0,0,0,0,ZOOM+760		;sc4C;
;	display 0,0,0,0,ZOOM+770		;sc4D; OPTIONAL
;	display 0,0,0,0,ZOOM+780		;sc4E;
;	display 0,0,0,0,ZOOM+790		;sc4F;	80 scan lines	
		
	display 0,0,0,0,b0z0  	;1 line
	display 0,0,0,0,b0z1	;1	"Bike0"	[SSCPIX1] 8 object segments
	display 0,0,0,1,b0z2	;2		to overlap activity of ZOOM
	display 0,0,0,1,b0z3	;2		playfield with bike silhouette.
	display 0,0,0,1,b0z4	;2
	display 0,0,0,1,b0z5	;2
	display 0,0,0,2,b0z6	;3
	display 0,0,0,2,b0z7	;3

	display 0,0,0,3,b1z0	;4 line	"Bike1"	
	display 0,0,0,3,b1z1	;4
	display 0,0,0,3,b1z2	;4
	display 0,0,0,3,b1z3	;4

	display 0,0,0,7,b2z0	;8 line	"Bike2"
	display 0,0,0,7,b2z1	;8

	display 0,0,0,7,b3z0	;8 line	"Bike3"
	display 0,0,0,7,b3z1	;8

Bounce2:
	display 1,0,0,4,sky		;margin			*dli 

	display 0,0,0,0,txt1  	;
	display 0,0,0,0,txt2	;Text Message Line
	display 0,0,0,0,txt3	;
	display 0,0,0,0,txt4	;
	display 0,0,0,0,txt5	;
	display 0,0,0,0,txt6	;
	display 0,0,0,0,txt7	;
	display 0,0,0,0,txt8	;
	 	display 0,0,0,15,sky	; 
		display 0,0,0,15,sky	; 

;*___________ Display List List 2 __________

		ds.B DLL1+$200-*	;$4A00 typ.
DLL2:
;3 bytes per sc line
;	ds.B %10000000,h1>>8,h1&$FF
;	ds.B %00000000,h2>>8,h1&$FF
;	ds.B %00000000,h3>>8,h1&$FF
	
; Z-1________ -0


