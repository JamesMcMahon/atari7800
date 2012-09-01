;@ A D	 *4>HR\+p
*** (C)1988   Property of John Boeschen & Co.     *****
***  "SUPER STUNT CYCLE"  by Jim St. Louis        *****
*** 10/17/88
; Z-1________ -0

	.subttl  "SSCTEXT.S   Plain Text Messages"
; Z-1________ -0

* [SSCSUB] contains Print routine

TextIndex:
	dc.W	t0,t1,t2,t3,t4,t5,t6,t7,t8,tA	;tB for videotapes 
TI_L = ((*-TextIndex)/2)
			
TextData:    ;                                 |buffer size
;	      0123456789ABCDEF0123456789ABCDEF0
t0:	dc.B "  {}  SUPER STUNT CYCLE  {}      `"
t1:	dc.B " Created by John Boeschen & Co.  `"
t2:	dc.B "   @ 1988  Atari Corporation     `"
t3:	dc.B " Reference specification 8/8/88  `"
t4:	dc.B " Milestone 1 (11/3/88) includes: `"
t5:	dc.B " (1) Silhouette of bike.         `"
t6:	dc.B " (2) First version engine sound. `"	
t7:	dc.B " (3) One free-running playfield. `"
t8:	dc.B " (4) No joystick at this stage.  `"
t9:	dc.B " (5) No text line required yet.  `"
tA:	dc.B "   Will have 9 diverse terrains. `"
tB:	dc.B "    {}  ATARI 7800 System  {}    `"
tC:	dc.B " Originated by Jim St.Louis 1988 `"
tD: dc.B " {} {} {} {} {} {} {} {} {} {}   `"	;This visible on crash





Text2:
	ds.B 256

; Z-1________ -0

