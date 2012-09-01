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
	XHEADER	RAM1,0,1,0,0,0
	NULLHDR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OBJPTR:
	.DC.W	XSAND
	.DC.W	XTREN
	.DC.W	XSHELLL
	.DC.W	XSHELLR
	.DC.W	XTREE
	.DC.W	XMTANL
	.DC.W	XHAY
	.DC.W	XCANNL
	.DC.W	XTUNNL
	.DC.W	XMTANR
	.DC.W	XCANNR
	.DC.W	XUJOA
	.DC.W	XUJOB
	.DC.W	XLUJOA
	.DC.W	XLUJOB
	.DC.W	XLJOA
	.DC.W	XLJOB
	.DC.W	XLDJOA
	.DC.W	XLDJOB
	.DC.W	XDJOA
	.DC.W	XDJOB
	.DC.W	XRDJOA
	.DC.W	XRDJOB
	.DC.W	XRJOA
	.DC.W	XRJOB
	.DC.W	XRUJOA
	.DC.W	XRUJOB
	.DC.W	XGREN
	.DC.W	XBULL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OBJVSIZE:
	.DC.B	0
	.DC.B	1
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	3
	.DC.B	1
	.DC.B	2
	.DC.B	3
	.DC.B	3
	.DC.B	2
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	1
	.DC.B	0
	.DC.B	0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OBJHSIZE:
	.DC.B	11
	.DC.B	13
	.DC.B	7
	.DC.B	7
	.DC.B	5
	.DC.B	7
	.DC.B	4
	.DC.B	7
	.DC.B	6
	.DC.B	7
	.DC.B	7
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	2
	.DC.B	0
	.DC.B	0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OBJCOLOR:
	.DC.B	$60
	.DC.B	$C0
	.DC.B	$40
	.DC.B	$40
	.DC.B	$80
	.DC.B	$A0
	.DC.B	$C0
	.DC.B	$60
	.DC.B	$C0
	.DC.B	$A0
	.DC.B	$60
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
	.DC.B	$20
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OBJDEF:
XSAND:
	.DC.W	RSAND1
XTREN:
	.DC.W	RTREN1
	.DC.W	RTREN2
XSHELLL:
	.DC.W	RSHL1
	.DC.W	RSHL2
	.DC.W	RSHL3
XSHELLR:
	.DC.W	RSHR1
	.DC.W	RSHR2
	.DC.W	RSHR3
XTREE:
	.DC.W	RTREE1
	.DC.W	RTREE2
	.DC.W	RTREE3
XMTANL:
	.DC.W	RMTANL1
	.DC.W	RMTANL2
	.DC.W	RMTANL3
	.DC.W	RMTANL4
XHAY:
	.DC.W	RHAY1
	.DC.W	RHAY2
XCANNL:
	.DC.W	RCANNL1
	.DC.W	RCANNL2
	.DC.W	RCANNL3
XTUNNL:
	.DC.W	RTUNNL1
	.DC.W	RTUNNL2
	.DC.W	RTUNNL3
	.DC.W	RTUNNL4
XMTANR:
	.DC.W	RMTANR1
	.DC.W	RMTANR2
	.DC.W	RMTANR3
	.DC.W	RMTANR4
XCANNR:
	.DC.W	RCANNR1
	.DC.W	RCANNR2
	.DC.W	RCANNR3
XUJOA:
	.DC.W	RUJOA1
	.DC.W	RUJOA2
XUJOB:
	.DC.W	RUJOB1
	.DC.W	RUJOB2
XLUJOA:
	.DC.W	RLUJOA1
	.DC.W	RLUJOA2
XLUJOB:
	.DC.W	RLUJOB1
	.DC.W	RLUJOB2
XLJOA:
	.DC.W	RLJOA1
	.DC.W	RLJOA2
XLJOB:
	.DC.W	RLJOB1
	.DC.W	RLJOB2
XLDJOA:
	.DC.W	RLDJOA1
	.DC.W	RLDJOA2
XLDJOB:
	.DC.W	RLDJOB1
	.DC.W	RLDJOB2
XDJOA:	
	.DC.W	RDJOA1
	.DC.W	RDJOA2
XDJOB:
	.DC.W	RDJOB1
	.DC.W	RDJOB2
XRDJOA:
	.DC.W	RRDJOA1
	.DC.W	RRDJOA2
XRDJOB:
	.DC.W	RRDJOB1
	.DC.W	RRDJOB2
XRJOA:
	.DC.W	RRJOA1
	.DC.W	RRJOA2
XRJOB:
	.DC.W	RRJOB1
	.DC.W	RRJOB2
XRUJOA:
	.DC.W	RRUJOA1
	.DC.W	RRUJOA2
XRUJOB:
	.DC.W	RRUJOB1
	.DC.W	RRUJOB2
XGREN:
	.DC.W	RGREN
XBULL:
	.DC.W	RBULL
	
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

HPOSVEC:
	.DC.W	HPOS1
	.DC.W	HPOS2
	.DC.W	HPOS3
;;;;;;;;;;;;;;;;;;;

HPOS1:	.DC.B	60
HPOS2:	.DC.B	60
HPOS3:	.DC.B	60
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

COPYS:
	.DC.B	$0
	.DC.B	$FF
	.DC.B	$FF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	MAP DEFINITIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RMAPOBJ:	
; DO MEN
	.DC.B	GREN
	.DC.B	BULL
	.DC.B	GREN
	.DC.B	BULL
	.DC.B	UJOA
	.DC.B	UJOA
	.DC.B	UJOA
; DO TERRAIN	
	.DC.B	TREE

	.DC.B	SAND
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE

	.DC.B	TREN
	.DC.B	SHELLR
	.DC.B	SHELLL
	.DC.B	TREN
	.DC.B	TREN
	.DC.B	SHELLR
	.DC.B	SHELLL

	.DC.B	SHELLR
	.DC.B	TREN
	.DC.B	SHELLL
	.DC.B	SHELLR
	.DC.B	SHELLL

	.DC.B	SHELLR
	.DC.B	SHELLR
	.DC.B	SHELLL
	.DC.B	SHELLR
	.DC.B	SHELLL

	.DC.B	SHELLR
	.DC.B	SHELLL
	.DC.B	SHELLL

	.DC.B	TUNNL
	.DC.B	TUNNL
	.DC.B	TUNNL

	.DC.B	CANNL
	.DC.B	CANNR

	.DC.B	CANNL

	.DC.B	TREN

	.DC.B	TREN
	.DC.B	TREN
	.DC.B	TREN
	.DC.B	TREN

	.DC.B	TREN
	.DC.B	TREN
	.DC.B	TREN
	.DC.B	TREN

	.DC.B	SAND
	.DC.B	SAND
	.DC.B	SAND

	.DC.B	SAND
	.DC.B	SAND
	.DC.B	SAND

	.DC.B	HAY
	.DC.B	HAY
	.DC.B	HAY
	.DC.B	HAY
	.DC.B	HAY

	.DC.B	HAY
	.DC.B	HAY

	.DC.B	SAND
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE

	.DC.B	MTANL

	.DC.B	MTANL
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	SAND
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE

	.DC.B	MTANR
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE

	.DC.B	MTANR
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE
	.DC.B	TREE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RMAPHPOS: 
; DO MEN
	.DC.B	70
	.DC.B	40
	.DC.B	55
	.DC.B	65
	.DC.B	80
	.DC.B	35
	.DC.B	50
; DO TERRIAN	
	.DC.B	110

	.DC.B	1
	.DC.B	80
	.DC.B	65
	.DC.B	95
	.DC.B	20

	.DC.B	1
	.DC.B	90
	.DC.B	60
	.DC.B	100
	.DC.B	15
	.DC.B	90
	.DC.B	10

	.DC.B	80
	.DC.B	90
	.DC.B	30
	.DC.B	100
	.DC.B	25

	.DC.B	70
	.DC.B	1
	.DC.B	100
	.DC.B	40
	.DC.B	80

	.DC.B	15
	.DC.B	90
	.DC.B	25
 
	.DC.B	0
	.DC.B	0
	.DC.B	0

	.DC.B	20
	.DC.B	120

	.DC.B	10

	.DC.B	20

	.DC.B	50
	.DC.B	0
	.DC.B	140
	.DC.B	40

	.DC.B	90
	.DC.B	20
	.DC.B	80
	.DC.B	10

	.DC.B	150
	.DC.B	10
	.DC.B	50

	.DC.B	0
	.DC.B	100
	.DC.B	30

	.DC.B	10
	.DC.B	60
	.DC.B	110
	.DC.B	100
	.DC.B	60

	.DC.B	15
	.DC.B	60

	.DC.B	130
	.DC.B	50
	.DC.B	25
	.DC.B	120

	.DC.B	0

	.DC.B	0
	.DC.B	120
	.DC.B	90
	.DC.B	100
	.DC.B	30
	.DC.B	110
	.DC.B	10
	.DC.B	50
	.DC.B	30

	.DC.B	135
	.DC.B	65
	.DC.B	100
	.DC.B	85
	.DC.B	115
	.DC.B	40

	.DC.B	125
	.DC.B	10
	.DC.B	120
	.DC.B	120
	.DC.B	100
	.DC.B	130
	.DC.B	30
	.DC.B	115

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RMAPVLSB:
; DO MEN
	.DC.B	20
	.DC.B	20
	.DC.B	20
	.DC.B	50
	.DC.B	50
	.DC.B	50
	.DC.B	50
; DO TERRIAN
	.DC.B	90

	.DC.B	10
	.DC.B	80
	.DC.B	100
	.DC.B	101
	.DC.B	140

	.DC.B	5
	.DC.B	10
	.DC.B	55
	.DC.B	60
	.DC.B	120
	.DC.B	130
	.DC.B	180

	.DC.B	5
	.DC.B	60
	.DC.B	90
	.DC.B	100
	.DC.B	160

	.DC.B	5
	.DC.B	15
	.DC.B	70
	.DC.B	75
	.DC.B	130

	.DC.B	20
	.DC.B	60
	.DC.B	110

	.DC.B	64
	.DC.B	124
	.DC.B	184

	.DC.B	80
	.DC.B	130

	.DC.B	30

	.DC.B	140

	.DC.B	30
	.DC.B	60
	.DC.B	90
	.DC.B	160

	.DC.B	15
	.DC.B	40
	.DC.B	70
	.DC.B	90

	.DC.B	15
	.DC.B	40
	.DC.B	90

	.DC.B	5
	.DC.B	25
	.DC.B	90

	.DC.B	15
	.DC.B	16
	.DC.B 	17
	.DC.B	80
	.DC.B	120

	.DC.B	10
	.DC.B	55

	.DC.B	20
	.DC.B	40
	.DC.B	110
	.DC.B	115

	.DC.B	120

	.DC.B	0
	.DC.B	20
	.DC.B	70
	.DC.B	110
	.DC.B	100
	.DC.B	120
	.DC.B	130
	.DC.B	131
	.DC.B	145

	.DC.B	20
	.DC.B	50
	.DC.B	80
	.DC.B	100
	.DC.B	101
	.DC.B	130

	.DC.B	5
	.DC.B	90
	.DC.B	95
	.DC.B	110
	.DC.B	135
	.DC.B	136
	.DC.B	140
	.DC.B	142
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RMAPVMSB:
; DO MEN
	.DC.B	$1
	.DC.B	$1
	.DC.B	$0
	.DC.B	$0
	.DC.B	$0
	.DC.B	$0
	.DC.B	$0
; DO TERRAIN
	.DC.B	$E2

	.DC.B	$E4
	.DC.B	$E4
	.DC.B	$E4
	.DC.B	$E4
	.DC.B	$E4

	.DC.B	$EB
	.DC.B	$EB
	.DC.B	$EB
	.DC.B	$EB
	.DC.B	$EB
	.DC.B	$EB
	.DC.B	$EB

	.DC.B	$EC
	.DC.B	$EC
	.DC.B	$EC
	.DC.B	$EC
	.DC.B	$EC

	.DC.B	$ED
	.DC.B	$ED
	.DC.B	$ED
	.DC.B	$ED
	.DC.B	$ED

	.DC.B	$EE
	.DC.B	$EE
	.DC.B	$EE

	.DC.B	$EF
	.DC.B	$EF
	.DC.B	$EF

	.DC.B	$F0
	.DC.B	$F0

	.DC.B	$F1

	.DC.B	$F3

	.DC.B	$F4
	.DC.B	$F4
	.DC.B	$F4
	.DC.B	$F4

	.DC.B	$F5
	.DC.B	$F5
	.DC.B	$F5
	.DC.B	$F5

	.DC.B	$F8
	.DC.B	$F8
	.DC.B	$F8

	.DC.B	$F9
	.DC.B	$F9
	.DC.B	$F9

	.DC.B	$FA
	.DC.B	$FA
	.DC.B	$FA
	.DC.B	$FA
	.DC.B	$FA

	.DC.B	$FB
	.DC.B	$FB

	.DC.B	$FC
	.DC.B	$FC
	.DC.B	$FC
	.DC.B	$FC

	.DC.B	$FD

	.DC.B	$FE
	.DC.B	$FE
	.DC.B	$FE
	.DC.B	$FE
	.DC.B	$FE
	.DC.B	$FE
	.DC.B	$FE
	.DC.B	$FE
	.DC.B	$FE

	.DC.B	$FF
	.DC.B	$FF
	.DC.B	$FF
	.DC.B	$FF
	.DC.B	$FF
	.DC.B	$FF

	.DC.B	0
	.DC.B	0
	.DC.B	0
	.DC.B	0
	.DC.B	0
	.DC.B	0
	.DC.B	0
	.DC.B	0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DATA TABLES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MENCASE0:
	.DC.B	LJOA
	.DC.B	RJOA
	.DC.B	DJOA
	.DC.B	UJOA
	.DC.B	RUJOA
	.DC.B	RDJOA
	.DC.B	LUJOA
	.DC.B	LDJOA
	.DC.B	UJOA
	.DC.B	LUJOA
	.DC.B	UJOA
	.DC.B	RUJOA
;
	.DC.B	GREN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MENCASE1:
	.DC.B	LJOB
	.DC.B	RJOB
	.DC.B	DJOB
	.DC.B	UJOB
	.DC.B	RUJOB
	.DC.B	RDJOB
	.DC.B	LUJOB
	.DC.B	LDJOB
	.DC.B	UJOA
	.DC.B	LUJOB
	.DC.B	UJOB
	.DC.B	RUJOB
;
	.DC.B	GREN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DIRVLSB:
	.DC.B	$0
	.DC.B	$0
	.DC.B	$1
	.DC.B	$FF
	.DC.B	$FF
	.DC.B	$1
	.DC.B	$FF
	.DC.B	$1
	.DC.B	$0
	.DC.B	$0
	.DC.B	$0
	.DC.B	$0
	.DC.B	$FF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DIRHPOS:
	.DC.B	$FF
	.DC.B	$1
	.DC.B	$0
	.DC.B	$0
	.DC.B	$1
	.DC.B	$1
	.DC.B	$FF
	.DC.B	$FF
	.DC.B	$0
	.DC.B	$FF
	.DC.B	$0
	.DC.B	$1
	.DC.B	$0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RDIRECTION:
	.DC.B	12
	.DC.B	12
	.DC.B	$2
	.DC.B	$3
	.DC.B	$4
	.DC.B	$5
	.DC.B	$8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPEED:
	.DC.B	$01
	.DC.B	$00
	.DC.B	$00
	.DC.B	$01
	.DC.B	$0F
	.DC.B	$0F
	.DC.B	$07

	
