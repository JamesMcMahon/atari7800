;	bank data 3
;	cave and jungle screens

	.6502

	.include	"ADDR.S"
	.include	"\\c\\macros.s"
;
;	bank sw
;
setbank	3
;
;	bitmaps
;
;cave screen

bitmap	BM_CAVE,"cave1.s"

;icicle

bitmap	ICE1,"ice.s"

;stalagmites

bitmap	MITE1,"mite1.s"

bitmap	MITE2,"mite2.s"

bitmap	MITE3,"mite3.s"

bitmap	MITE4,"mite4.s"

bitmap	FST1,"FALLST.S"

bitmap	SNOWMAN,"SNOMAN.S"

bitmap	BAT1,"BAT1.S"

bitmap	BAT2,"BAT2.S"

bitmap	CAVET,"CAVET.S"		;cave treasure
;
;	jungle screen
;
bitmap	JUN1,"jun1.s"

bitmap	JUN2,"jun2.s"

bitmap	JUN3,"jun3.s"

bitmap	JUN4,"jun4.s"

bitmap	C23,"C23.S"

bitmap	MONKEY,"monkey.s"

bitmap	MONKE2,"monke2.s"

bitmap	MONKE3,"monke3.s"

bitmap	MONKE4,"monke4.s"

bitmap	MONKE5,"monke5.s"

bitmap	PLANT,"PLANT.S"

bitmap	JUNPRI,"JUNPRI.S"

bitmap	COCO1,"COCO1.S"

bitmap	COCO2,"COCO2.S"

bitmap	TOCAN,"TOCAN.S"

bitmap	TOCAN2,"TOCAN2.S"

	.end
