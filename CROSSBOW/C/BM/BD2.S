;	bank data 2
;	town screen

	.6502

	.include	"ADDR.S"
	.include	"\\c\\macros.s"
	.include	"\\c\\equates.s"
;
;	bank sw
;
setbank	2
;
;	bitmaps
;
;town screen

;background

bitmap	BM_TOWN,"TOWN1.S"

bitmap	ROOF,"ROOF.S"

bitmap	CHIMN1,"CHIMN1.S"

bitmap	CHIMN2,"CHIMN2.S"

bitmap	STAR,"STAR.S"

;window enemies

bitmap	BM_WIN1,"WIN1.S"

bitmap	BM_WIN2,"WIN2.S"

bitmap	BM_WIN3,"WIN3.S"

bitmap	BM_WIN4,"WIN4.S"

bitmap	BM_WIN5,"WIN5.S"

bitmap	BM_WIN6,"WIN6.S"

;wolf

bitmap	WOLF,"WOLF.S"

bitmap	WLFDED,"WLFDED.S"

bitmap	TOWNT,"TOWNT.S"		;town treasure
;
;	face screen
;
bitmap	BM_FACE,"SFACE.S"
bitmap	BM_SKULL,"SKULL.S"
bitmap	FFLOOR,"FFLOOR.S"
bitmap	FDS,"BOLTS.S"
bitmap	GHOST1,"GHOST.S"
bitmap	BOLT,"BOLT.S"
bitmap	WIZA,"WIZA.S"
bitmap	WIZB,"WIZB.S"
bitmap	WIZC,"WIZC.S"
bitmap	FRBALL,"FRBALL.S"
bitmap	LAMP1,"LAMP.S"
bitmap	WTEYE,"WTEYE.S"
bitmap	WTEYE2,"WTEYE2.S"
bitmap	RDEYE3,"RDEYE3.S"
bitmap	RDEYE4,"RDEYE4.S"
bitmap	RDEYE5,"RDEYE5.S"
bitmap	RDEYE6,"RDEYE6.S"
bitmap	BONUS,"BONUS.S"
bitmap	YOUHAVE,"YOUHAV.S"

.end
