
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	PAGE ZERO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.ORG	$40

ZONEVEC:	.DS.B	2
ZONETMP:	.DS.B	2
OBJBASE:	.DS.B	2
OBJADR:		.DS.B	2
LINEOFF:	.DS.B	2
TPTR1:		.DS.B	2

TBULL:
LOOPCNT:	.DS.B	1
HICNT:		.DS.B	1
TMPLSB:		.DS.B	1
TMPMSB:		.DS.B	1
ADDONE:		.DS.B	1
VLINES:		.DS.B	1
OBJSTART:	.DS.B 	1
INVISVAL:	.DS.B	1
OBJVINIT:	.DS.B	1
?OFFTOP:	.DS.B	1
?OFFBOT:	.DS.B	1		
?MAPLO:		.DS.B	1
?TERRAIN:	.DS.B	1
VNDXCNT:	.DS.B	1
SAVEVLSB:	.DS.B	1
OBJVTMP:	.DS.B	1

CASENUM:	.DS.B	1	
MAPNUM:		.DS.B	1
VOFF:		.DS.B	1
VNDX:		.DS.B	1
VZONE:		.DS.B	1
OBJNUM:		.DS.B	1
OBJVCNT:	.DS.B	1
OBJVPART:	.DS.B	1
TWIDTH:		.DS.B	1
TCOLOR:		.DS.B	1
VLSBACC:	.DS.B	1
VMSBACC:	.DS.B	1
MAPLO:		.DS.B	1
MAPHI:		.DS.B	1

FRAME:		.DS.B	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ZONEPTR:	.DS.B	24

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	HEADER BUFFER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LOADR:		.DS.B	1
COLORWTH:	.DS.B	1
HIADR:		.DS.B	1
HPOS:		.DS.B	1
	
