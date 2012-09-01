; THIS FILE CONTAINS DATA TABLES AND
; VECTORS FOR COMMANDO GAME (X.S)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	ROM AREA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.ORG	ROMDATA

	.INCLUDE	"XDTA.S"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.ORG	ROMCODE

	DISPLAY	0,0,0,7,FILLER
	DISPLAY	0,0,0,7,FILLER
	DISPLAY	0,0,0,7,FILLER
	DISPLAY	0,0,0,0,FILLER
	DISPLAY	0,1,0,15,V0ZONE1
	DISPLAY	0,1,0,15,V0ZONE2
	DISPLAY	0,1,0,15,V0ZONE3
	DISPLAY	0,1,0,15,V0ZONE4
	DISPLAY	0,1,0,15,V0ZONE5
	DISPLAY	0,1,0,15,V0ZONE6
	DISPLAY	0,1,0,15,V0ZONE7
	DISPLAY	0,1,0,15,V0ZONE8
	DISPLAY	0,1,0,15,V0ZONE9
	DISPLAY	0,1,0,15,V0ZONE10
	DISPLAY	0,1,0,15,V0ZONE11
	DISPLAY	0,1,0,15,V0ZONE12
	DISPLAY	0,0,0,7,FILLER
	DISPLAY	0,0,0,7,FILLER
	DISPLAY	0,0,0,7,FILLER
	DISPLAY	0,0,0,1,FILLER

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	DISPLAY	0,0,0,7,FILLER
	DISPLAY	0,0,0,7,FILLER
	DISPLAY	0,0,0,7,FILLER
	DISPLAY	0,0,0,0,FILLER
	DISPLAY	0,1,0,15,V1ZONE1
	DISPLAY	0,1,0,15,V1ZONE2
	DISPLAY	0,1,0,15,V1ZONE3
	DISPLAY	0,1,0,15,V1ZONE4
	DISPLAY	0,1,0,15,V1ZONE5
	DISPLAY	0,1,0,15,V1ZONE6
	DISPLAY	0,1,0,15,V1ZONE7
	DISPLAY	0,1,0,15,V1ZONE8
	DISPLAY	0,1,0,15,V1ZONE9
	DISPLAY	0,1,0,15,V1ZONE10
	DISPLAY	0,1,0,15,V1ZONE11
	DISPLAY	0,1,0,15,V1ZONE12
	DISPLAY	0,0,0,7,FILLER
	DISPLAY	0,0,0,7,FILLER
	DISPLAY	0,0,0,7,FILLER
	DISPLAY	0,0,0,1,FILLER

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FILLER
	XHEADER	RAM1,0,1,0,1,0
	NULLHDR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OBJPTR:
	.DC.W	XSQUARE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OBJVSIZE:
	.DC.B	2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OBJHSIZE:
	.DC.B	7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OBJCOLOR:
	.DC.B	0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OBJDEF:
XSQUARE:
	.DC.W	RTREE1
	.DC.W	RTREE2
	.DC.W	RTREE3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	VECTORS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ZONES0:
	.DC.W	V0ZONE1
	.DC.W	V0ZONE2
	.DC.W	V0ZONE3
	.DC.W	V0ZONE4
	.DC.W	V0ZONE5
	.DC.W	V0ZONE6
	.DC.W	V0ZONE7
	.DC.W	V0ZONE8
	.DC.W	V0ZONE9
	.DC.W	V0ZONE10
	.DC.W	V0ZONE11
	.DC.W	V0ZONE12

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ZONES1:
	.DC.W	V1ZONE1
	.DC.W	V1ZONE2
	.DC.W	V1ZONE3
	.DC.W	V1ZONE4
	.DC.W	V1ZONE5
	.DC.W	V1ZONE6
	.DC.W	V1ZONE7
	.DC.W	V1ZONE8
	.DC.W	V1ZONE9
	.DC.W	V1ZONE10
	.DC.W	V1ZONE11
	.DC.W	V1ZONE12

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	MAP DEFINITIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MAPOBJ:	
	.DC.B	SQUARE
	.DC.B	SQUARE
	.DC.B	SQUARE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RMAPHPOS: 
	.DC.B	5
	.DC.B	30
	.DC.B	55
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RMAPVLSB:
	.DC.B	0
	.DC.B	30
	.DC.B	60
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RMAPVMSB:
	.DC.B	$00
	.DC.B	$00
	.DC.B	$00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

