;	bank data 5
;	bridge screen

	.6502

	.include	"ADDR.S"
	.include	"\\C\\MACROS.S"	;esp setbank
	.include	"\\c\\equates.s"
;
;	bank sw
;
setbank	5
;
;	bitmaps
bitmap	BM_BRIDGE,"bridge.s"
;
;	onlay
;
bitmap 	BRONLAY,"bronlay.s"
bitmap	FROG,"frog.s"
bitmap	FISH,"fish.s"
bitmap	BIRD1,"bird1.s"
bitmap	DYING1,"dying1.s"
bitmap	ROCKA,"rocka.s"
bitmap	ROCKB,"rockb.s"
bitmap	ROCKC,"rockc.s"
bitmap	ROCKD,"rockd.s"
bitmap	BEAVER,"beaver.s"
bitmap	ALI,"ali.s"
bitmap	OWL,"owl.s"

.end
