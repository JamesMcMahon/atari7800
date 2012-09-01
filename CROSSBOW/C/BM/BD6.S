;	bank data 6
;	castle screen

	.6502

	.include	"ADDR.S"
	.include	"\\c\\macros.s"
;
;	bank sw
;
setbank	6
;
;castle screen
;
;background

bitmap	CAS1,"cas1.s"

bitmap	CAS2,"cas2.s"

bitmap	CAS3,"cas3.s"

bitmap	CHAIN,"chain.s"

bitmap	DOOR1,"door1.s"

bitmap	DOOR2,"door2.s"

bitmap	DOOR4,"door4.s"

bitmap	DOOR7,"door7.s"

bitmap	DOOR9,"door9.s"

bitmap	ARCHER1 - (11*$100),"archer.s"	;shift down 11 lines

bitmap	ARROW3,"arrow3.s"

bitmap	ARROW4,"arrow4.s"

bitmap	PTERA,"bird1.s"

bitmap	PTDIE,"DYING1.S"

bitmap	ALI2,"ALI.S"

	.end
