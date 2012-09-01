.nlist
.INCLUDE	"HEADER.VCS"
.INCLUDE	"TIAPIA.EQU"
.INCLUDE	"GENERAL.EQU"
.INCLUDE	"EQUATES.VCS"
.INCLUDE	"MACROS.VCS"
.LIST
.include	"zeroram.equ"
.org	$7100
.NLIST
.INCLUDE	"ROAD.TXT"
.INCLUDE	"WIDTH.TXT"
.INCLUDE	"PERSPECTIVE.TXT"
.list
.INCLUDE	"TABLEDRIVER.S"
end7:		nop
.org	$5100
.INCLUDE	"MOTORKER.S"
.NLIST
.INCLUDE	"ENDSTART.TXT"
.INCLUDE	"OURBIKE.TXT"
.INCLUDE	"TSTCOLOR.TXT"
;.INCLUDE	"MOUNTE.TXT"
.INCLUDE	"MOUNT.TXT"
.INCLUDE	"MOUNT2.TXT"
.INCLUDE	"COLORS.TXT"
.INCLUDE	"CLOUDS.TXT"
.LIST
.SDF:	NOP
.org	$D100
.include	"overscan.s"
.INCLUDE	"HMTAB.TXT"
.nlist
.include	"TRACK.TXT"
ENDDAT:	NOP

;*******************************************************************************
;
;	SYSTEM STARTUP
;
;
;
;
;
;******************************************************************************
.ORG   $F000

.include 	"saram.equ"
.include	"startup.s"
.include	"sound.tab"
.include	"msub.s"

.SDSS:	NOP

	.org	$FFF8
	.DC.W	$F7FF
	.DC.W	NMI
	.DC.W	START
	.DC.W	IRQ
.nlist
	.END
