;	bank data 1
;	volcano screen

	.6502

	.include	"ADDR.S"
	.include	"\\C\\MACROS.S"
;
;	set sw bank
;
setbank	1
;
;	bitmaps
;
bitmap	BM_VOLCANO,"volcano.s"
bitmap	LRIVER,"lriver.s"
bitmap	VROCK,"vrock.s"
bitmap	VROCK2,"vrock2.s"
bitmap	VROCK3,"vrock3.s"
bitmap	VROCK4,"vrock4.s"
bitmap	LTNING,"ltning.s"
bitmap	DIAMND,"diamnd.s"
bitmap	BLDR1,"bldr1.s"

.end
