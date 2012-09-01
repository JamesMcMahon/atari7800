;
;	bd0.s
;	bank data 0
.6502
;
.include	"\\C\\MACROS.S"
.include	"ADDR.S"
;
;	set the bank
;
setbank	0
;
;	actual bitmap loads
;
bitmap	BM_SELECT,"SELECT.S"
bitmap	CBLOGO,"CBLOGO.S"
bitmap	LOGO2,"LOGO2.S"
bitmap	LOGO3,"LOGO3.S"
bitmap	LOGO4,"LOGO4.S"
bitmap	THEEND,"THEEND.S"
bitmap	GTRDY,"GTRDY.S"
bitmap	COPYR,"COPYR.S"
bitmap	RAGU,"RAGU.S"
bitmap	RAGD,"RAGD.S"
bitmap	RAGL,"RAGL.S"
bitmap	RAGR,"RAGR.S"
bitmap	PATHBUT,"PATHBUT.S"
bitmap	REDP,"REDP.S"
bitmap	GREENP,"GREENP.S"
bitmap	BLUEP,"BLUEP.S"
bitmap	MAPDES,"MAPDES.S"
bitmap	MAPCAV,"MAPCAV.S"
bitmap	MAPVOL,"MAPVOL.S"
bitmap	MAPJUN,"MAPJUN.S"
bitmap	MAPTOW,"MAPTOW.S"
bitmap	MAPROO,"MAPROO.S"
bitmap	MAPBRI,"MAPBRI.S"
bitmap	MAPCAS,"MAPCAS.S"
bitmap	MAPFR,"MAPFR.S"
bitmap	PATHLINES,"PATHLI.S"

bitmap	CONQUER,"BEWARE.S"
bitmap	NOWPRE,"NOWPRE.S"

.end
