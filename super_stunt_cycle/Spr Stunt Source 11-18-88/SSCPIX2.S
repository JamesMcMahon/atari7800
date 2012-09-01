*SSC 11/88
*	4k of 7800 Graphics Data
*            from: TEM24.NEO
*
*
;	BLANK00	One byte wide object filled with color 00
; 	BIKE00	Upper left segment of motorcycle
;	BIKE01	Upper right segment of motorcycle
;	BIKE02	Left upper mid segment of motorcycle
;	BIKE03	Right upper mid segment of motorcycle
;	BIKE04	Left lower mid segment of motorcycle
;	BIKE05	Right lower mid segment of motorcycle
;	BIKE06	Left lower segment of motorcycle
;	BIKE07	Right lower segment of motorcycle
;	NMBR08	Numbers 0-9 in #14 type
;	PIXL09	Zoom 32-47
;	PIXL0A	Zoom 48-63
;	NULL0B	: and ! (! in same color 3 as "stop")
;	PIXL0C	Zoom 16-31
;	PIXL0D	Zoom 64-79
;	NULL0E	"ST" probably will be Zoom detail also
;	PIXL0F	Zoom 0-15
;	NULL10	"OP"


BLANK00:	;FIRST TWO BYTES ONLY
BIKE00:	;0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F |
	dc.B	$00,$00,$0F,$FF,$FF,$FF,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
BIKE01:
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$3F,$FF,$FF,$FF
BIKE02:
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF
BIKE03:
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$3F,$FF,$FF,$FF,$FF,$FF,$FF
BIKE04:
	dc.B	$3F,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$FA,$AA,$AA,$AA
BIKE05:
	dc.B	$AA,$AA,$AB,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$F0
BIKE06:
	dc.B	$00,$0F,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
BIKE07:
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FF,$F0,$00
NMBR08:
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
PIXL09:
	dc.B	$55,$5F,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB,$FF,$D5,$54
PIXL0A:
	dc.B	$55,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB,$FD,$54
NULL0B:
	dc.B	$00,$00
PIXL0C:
	dc.B	$55,$55,$FF,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB,$FF,$FF,$55,$55
PIXL0D:
	dc.B	$5F,$EA,$AA,$AA,$AB,$F5
NULL0E:
	dc.B	$00,$00
PIXL0F:
	dc.B	$55,$55,$5F,$FF,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB,$FF,$FF,$F5,$55,$55
NULL10:
	dc.B	$00,$00
*
*  ------------------------
*
*
	dc.B	$00,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*BIKE1
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$FF,$FF,$F3,$FC
*BIKE2
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*BIKE3
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$3F,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$3F,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$03,$FF,$FF,$FF,$FB,$FF,$FF,$FF
*ICON
	dc.B	$FF,$FF,$FB,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FC
*ICON
	dc.B	$00,$0F,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FF,$F0,$00
*
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$15,$5F,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AF,$FF,$D5,$50
*
	dc.B	$15,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AF,$FD,$50
*
	dc.B	$00,$00
*ICON
	dc.B	$55,$55,$FF,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AF,$FF,$FD,$55,$54
*
	dc.B	$17,$EA,$AA,$AA,$AB,$D4
*
	dc.B	$00,$00
*ICON
	dc.B	$55,$55,$5F,$FF,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AF,$FF,$FF,$F5,$55,$54
*
	dc.B	$00,$00
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$F3,$FF,$FF,$FF,$FF,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*BIKE1
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$0F,$FF,$FF,$FF,$F3,$F0
*BIKE2
	dc.B	$3F,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*BIKE3
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$3F,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$03,$FF,$FF,$FF,$FB,$AA,$AA,$AA
*ICON
	dc.B	$AA,$AA,$BB,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$03,$FF,$FF,$FF,$FF,$FF,$FC
*ICON
	dc.B	$00,$0F,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$F0,$00
*
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
*ICON
	dc.B	$15,$57,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AF,$FF,$55,$40
*
	dc.B	$15,$7F,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AF,$F5,$40
*
	dc.B	$20,$10
*ICON
	dc.B	$15,$55,$7F,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AF,$FF,$F5,$55,$50
*
	dc.B	$15,$FA,$AA,$AA,$AF,$54
*
	dc.B	$54,$10
*ICON
	dc.B	$15,$55,$57,$FF,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AF,$FF,$FF,$D5,$55,$50
*
	dc.B	$14,$40
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$03,$FF,$F3,$FF,$F0,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*BIKE1
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$FF,$F3,$FF,$F0,$00
*BIKE2
	dc.B	$3F,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$3F,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*BIKE3
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FC
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FB,$AA,$AA,$AA
*ICON
	dc.B	$AA,$AA,$BB,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$03,$FF,$FF,$FF,$FF,$FF,$FC
*ICON
	dc.B	$00,$0F,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$F0,$00
*
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
*ICON
	dc.B	$05,$55,$FF,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$BF,$FD,$55,$40
*
	dc.B	$05,$5F,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$BF,$D5,$40
*
	dc.B	$20,$10
*ICON
	dc.B	$05,$55,$5F,$FF,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$BF,$FF,$F5,$55,$50
*
	dc.B	$05,$FA,$AA,$AA,$AF,$50
*
	dc.B	$54,$10
*ICON
	dc.B	$05,$55,$55,$FF,$FF,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$BF,$FF,$FF,$55,$55,$50
*
	dc.B	$54,$40
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$00,$FF,$F0,$3F,$C0,$00,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*BIKE1
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$00,$00,$00,$FF,$C0,$FF,$F0,$00
*BIKE2
	dc.B	$03,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$3F,$EA,$AA,$AA,$AA,$AA,$AA,$AA
*BIKE3
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$BF,$FF,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$F0
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FB,$AA,$AA,$AA
*ICON
	dc.B	$AA,$AA,$BB,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$00,$0F,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$F0,$00
*
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
*ICON
	dc.B	$01,$55,$FF,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$BF,$FD,$55,$00
*
	dc.B	$01,$5F,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$BF,$D5,$00
*
	dc.B	$20,$10
*ICON
	dc.B	$01,$55,$5F,$FF,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$BF,$FF,$D5,$55,$40
*
	dc.B	$01,$7E,$AA,$AA,$BD,$40
*
	dc.B	$04,$10
*ICON
	dc.B	$01,$55,$55,$FF,$FF,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$BF,$FF,$FF,$55,$55,$40
*
	dc.B	$44,$40
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$00,$FF,$C0,$0F,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*BIKE1
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$3C,$00,$FF,$C0,$00
*BIKE2
	dc.B	$03,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA
*BIKE3
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$BF,$FF,$C0,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$F0
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FB,$BF,$AE,$AA
*ICON
	dc.B	$BF,$AE,$BB,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$00,$0F,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$F0,$00
*
	dc.B	$BA,$FE,$FE,$BA,$AE,$BA,$BA,$BA,$BA,$BA
*ICON
	dc.B	$00,$55,$7F,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$FF,$F5,$54,$00
*
	dc.B	$00,$57,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$FF,$54,$00
*
	dc.B	$20,$00
*ICON
	dc.B	$01,$55,$57,$FF,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$FF,$FF,$D5,$55,$00
*
	dc.B	$01,$7E,$AA,$AA,$BD,$40
*
	dc.B	$04,$10
*ICON
	dc.B	$01,$55,$55,$7F,$FF,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$FF,$FF,$FD,$55,$55,$00
*
	dc.B	$44,$40
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$00,$3F,$00,$00,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$FF,$FF,$FF
*BIKE1
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$3F,$C0,$00
*BIKE2
	dc.B	$03,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$00,$00,$03,$FF,$FB,$FF,$FE,$FF,$FF,$BF,$FF
*BIKE3
	dc.B	$EF,$FF,$FB,$FB,$FB,$FF,$FF,$FF,$F0,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$F0
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$03,$FF,$FF,$FB,$AE,$BB,$AE
*ICON
	dc.B	$AE,$AE,$BB,$FF,$FF,$FC,$00,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$00,$0F,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$F0,$00
*
	dc.B	$EE,$BA,$BA,$EE,$AE,$EE,$EE,$BA,$EE,$AA
*ICON
	dc.B	$00,$55,$5F,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$FF,$D5,$50,$00
*
	dc.B	$00,$55,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$FD,$50,$00
*
	dc.B	$00,$10
*ICON
	dc.B	$00,$55,$57,$FF,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$FF,$FF,$55,$54,$00
*
	dc.B	$00,$5F,$AA,$AA,$F5,$00
*
	dc.B	$04,$10
*ICON
	dc.B	$00,$55,$55,$7F,$FF,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$FF,$FF,$F5,$55,$54,$00
*
	dc.B	$44,$54
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$FF,$FF
*BIKE1
	dc.B	$FF,$FF,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
*BIKE2
	dc.B	$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$00,$3F,$FF,$D5,$55,$55,$55,$55,$55,$55
*BIKE3
	dc.B	$55,$55,$56,$66,$66,$66,$7F,$FF,$FC,$00,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FB,$AE,$BB,$AE
*ICON
	dc.B	$AE,$AE,$BB,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$FF,$FF,$FC
*ICON
	dc.B	$00,$0F,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$03,$FF,$FF,$FF,$C0,$00
*
	dc.B	$EE,$BA,$BA,$AE,$FE,$AE,$EE,$BA,$EE,$AE
*ICON
	dc.B	$00,$15,$5F,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB,$FF,$D5,$50,$00
*
	dc.B	$00,$15,$FF,$AA,$AA,$AA,$AA,$AA,$AB,$FD,$50,$00
*
	dc.B	$00,$10
*ICON
	dc.B	$00,$15,$55,$FF,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB,$FF,$FD,$55,$54,$00
*
	dc.B	$00,$17,$AA,$AA,$D4,$00
*
	dc.B	$14,$10
*ICON
	dc.B	$00,$15,$55,$5F,$FF,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB,$FF,$FF,$F5,$55,$54,$00
*
	dc.B	$44,$54
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$FF,$FF
*BIKE1
	dc.B	$FF,$FF,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
*BIKE2
	dc.B	$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$55,$55,$55,$55,$55,$55
*BIKE3
	dc.B	$55,$55,$59,$99,$99,$99,$BF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FB,$AE,$BF,$AA
*ICON
	dc.B	$AE,$AE,$BB,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$FF,$FF,$F0
*ICON
	dc.B	$00,$0F,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*ICON
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$03,$FF,$FF,$FF,$F0,$00
*
	dc.B	$FE,$BA,$AA,$AA,$EE,$AE,$FA,$BA,$BA,$BE
*ICON
	dc.B	$00,$05,$57,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB,$FF,$55,$40,$00
*
	dc.B	$00,$05,$7F,$AA,$AA,$AA,$AA,$AA,$AB,$F5,$40,$00
*
	dc.B	$20,$10
*
	dc.B	$00,$05,$55,$7F,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$AB,$FF,$FD,$55,$50,$00
*
	dc.B	$00,$17,$EA,$AB,$D4,$00
*
	dc.B	$10,$10
*
	dc.B	$00,$05,$55,$57,$FF,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB,$FF,$FF,$D5,$55,$50,$00
*
	dc.B	$44,$44
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$FF,$FF
*BIKE1
	dc.B	$FF,$FF,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
*BIKE2
	dc.B	$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$55,$55,$55,$55,$55,$55
*BIKE3
	dc.B	$55,$55,$56,$66,$66,$66,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0
*
	dc.B	$CF,$FF,$FF,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FB
	dc.B	$AE,$BB,$AE
*
	dc.B	$AE,$AB,$BB,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF
	dc.B	$FF,$FF,$FF
*
	dc.B	$00,$0F,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF
	dc.B	$FF,$FF,$FF
*
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$03,$FF,$FF
	dc.B	$FF,$C0,$00
*
	dc.B	$EE,$BA,$AE,$BA,$BE,$FA,$EA,$AE,$EE,$EE
*
	dc.B	$00,$01,$57,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AF,$FF,$55
	dc.B	$00,$00
*
	dc.B	$00,$01,$7F,$EA,$AA,$AA,$AA,$AA,$AF,$F5,$00,$00
*
	dc.B	$20,$10
*
	dc.B	$00,$05,$55,$7F,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$AF,$FF,$F5,$55,$40,$00
*
	dc.B	$00,$05,$EA,$AB,$50,$00
*
	dc.B	$50,$10
*
	dc.B	$00,$05,$55,$57,$FF,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AF,$FF,$FF,$55,$55,$40,$00
*
	dc.B	$44,$44
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$FF,$FF
*BIKE1
	dc.B	$FF,$FF,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
*BIKE2
	dc.B	$00,$FC,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$55,$55,$55,$55,$55,$55
*BIKE3
	dc.B	$55,$55,$59,$99,$99,$99,$BF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$CF,$C0
*
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FB
	dc.B	$BE,$BB,$AE
*
	dc.B	$BE,$AB,$BB,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF
	dc.B	$FF,$FF,$FF
*
	dc.B	$00,$0F,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF
	dc.B	$FF,$FF,$FF
*
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$03,$FF,$FF
	dc.B	$FF,$F0,$00
*
	dc.B	$EE,$FA,$EE,$AE,$BE,$EA,$EA,$AE,$EE,$EE
*
	dc.B	$00,$01,$55,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AF,$FD,$54
	dc.B	$00,$00
*
	dc.B	$00,$01,$5F,$EA,$AA,$AA,$AA,$AA,$AF,$D4,$00,$00
*
	dc.B	$20,$10
*
	dc.B	$00,$01,$55,$5F,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$AF,$FF,$F5,$55,$00,$00
*
	dc.B	$00,$01,$FA,$AF,$40,$00
*
	dc.B	$40,$10
*
	dc.B	$00,$01,$55,$55,$FF,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AF,$FF,$FF,$55,$55,$00,$00
*
	dc.B	$44,$44
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$FF,$FF
*BIKE1
	dc.B	$FF,$FF,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
*BIKE2
	dc.B	$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$55,$55,$55,$55,$55,$55
*BIKE3
	dc.B	$55,$55,$56,$66,$66,$66,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00
*
	dc.B	$CF,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FB
	dc.B	$AE,$AE,$AA
*
	dc.B	$AE,$BF,$BB,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FF
	dc.B	$FF,$FF,$FF
*
	dc.B	$00,$0F,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF
	dc.B	$FF,$FF,$FF
*
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$03,$FF,$FF
	dc.B	$FF,$F0,$00
*
	dc.B	$BA,$BA,$BA,$FE,$AE,$FE,$BE,$FE,$BA,$BA
*
	dc.B	$00,$00,$55,$7F,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$BF,$F5,$54
	dc.B	$00,$00
*
	dc.B	$00,$00,$57,$FA,$AA,$AA,$AA,$AA,$BF,$54,$00,$00
*
	dc.B	$20,$10
*
	dc.B	$00,$00,$55,$57,$FF,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$BF,$FF,$D5,$54,$00,$00
*
	dc.B	$00,$01,$7A,$AD,$40,$00
*
	dc.B	$40,$10
*
	dc.B	$00,$00,$55,$55,$7F,$FF,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$BF,$FF,$FD,$55,$54,$00,$00
*
	dc.B	$44,$44
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF
*BIKE1
	dc.B	$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
*BIKE2
	dc.B	$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$55,$55,$55,$55,$55,$55
*BIKE3
	dc.B	$55,$55,$59,$99,$99,$99,$BF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00
*
	dc.B	$F3,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FB
	dc.B	$AA,$AA,$AA
*
	dc.B	$AA,$AA,$BB,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FF
	dc.B	$FF,$FF,$FF
*
	dc.B	$00,$0F,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FF,$FF
	dc.B	$FF,$FF,$FF
*
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$03,$FF,$FF
	dc.B	$FF,$C0,$00
*
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
*
	dc.B	$00,$00,$15,$7F,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$BF,$F5,$50
	dc.B	$00,$00
*
	dc.B	$00,$00,$17,$FA,$AA,$AA,$AA,$AA,$BF,$50,$00,$00
*
	dc.B	$00,$10
*
	dc.B	$00,$00,$15,$57,$FF,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$BF,$FF,$55,$54,$00,$00
*
	dc.B	$00,$00,$7E,$BD,$00,$00
*
	dc.B	$54,$54
*
	dc.B	$00,$00,$15,$55,$7F,$FF,$FA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$BF,$FF,$F5,$55,$54,$00,$00
*
	dc.B	$54,$54
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$3F,$FF
*BIKE1
	dc.B	$FF,$FC,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
*BIKE2
	dc.B	$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*BIKE3
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00
*
	dc.B	$33,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FB
	dc.B	$AA,$AA,$AA
*
	dc.B	$AA,$AA,$BB,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FF
	dc.B	$FF,$FF,$FC
*
	dc.B	$00,$0F,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FF,$FF
	dc.B	$FF,$FF,$FF
*
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$0F,$FF,$FF
	dc.B	$FF,$F0,$00
*
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
*
	dc.B	$00,$00,$05,$5F,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$FF,$D5,$40
	dc.B	$00,$00
*
	dc.B	$00,$00,$05,$FE,$AA,$AA,$AA,$AA,$FD,$40,$00,$00
*
	dc.B	$00,$10
*
	dc.B	$00,$00,$15,$55,$FF,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$FF,$FF,$55,$50,$00,$00
*
	dc.B	$00,$00,$5E,$B5,$00,$00
*
	dc.B	$14,$54
*
	dc.B	$00,$00,$15,$55,$5F,$FF,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$FF,$FF,$F5,$55,$50,$00,$00
*
	dc.B	$14,$54
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$FF
*BIKE1
	dc.B	$FF,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
*BIKE2
	dc.B	$00,$00,$FF,$FF,$FF,$CF,$FF,$FF,$FF,$FF,$FF,$FF,$FB,$FF,$FE,$FF,$FF,$BF,$FF
*BIKE3
	dc.B	$EF,$FF,$FB,$FF,$FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$FF,$FF,$FF,$C0,$00
*
	dc.B	$3F,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FB
	dc.B	$FF,$FF,$FF
*
	dc.B	$FF,$FF,$FB,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FF
	dc.B	$FF,$FF,$FC
*
	dc.B	$00,$0F,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FF,$FF
	dc.B	$FF,$FF,$FF
*
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$3F,$FF,$FF
	dc.B	$FF,$F0,$00
*
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*
	dc.B	$00,$00,$05,$57,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$FF,$55,$00
	dc.B	$00,$00
*
	dc.B	$00,$00,$05,$7E,$AA,$AA,$AA,$AA,$F5,$40,$00,$00
*
	dc.B	$00,$00
*
	dc.B	$00,$00,$05,$55,$FF,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$FF,$FD,$55,$40,$00,$00
*
	dc.B	$00,$00,$1F,$F4,$00,$00
*
	dc.B	$00,$00
*
	dc.B	$00,$00,$05,$55,$5F,$FF,$FE,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$FF,$FF,$D5,$55,$40,$00,$00
*
	dc.B	$00,$00
*
*  ------------------------
*
*
	dc.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$3F
*BIKE1
	dc.B	$FC,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
*BIKE2
	dc.B	$00,$00,$3F,$FF,$FF,$C3,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*BIKE3
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$FF,$FF,$FF,$00,$00
*
	dc.B	$3F,$FF,$FF,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FA
	dc.B	$AA,$AA,$AA
*
	dc.B	$AA,$AA,$AB,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$3F,$FF,$FF,$FF
	dc.B	$FF,$FF,$FC
*
	dc.B	$0F,$3F,$FF,$FF,$FF,$FC,$00,$00,$00,$00,$00,$0F,$FF,$FF,$FF,$FF
	dc.B	$FF,$FF,$FF
*
	dc.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$3F,$FF,$FF
	dc.B	$FF,$F0,$F0
*
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
*
	dc.B	$00,$00,$01,$57,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB,$FF,$55,$00
	dc.B	$00,$00
*
	dc.B	$00,$00,$01,$7F,$AA,$AA,$AA,$AB,$F5,$00,$00,$00
*
	dc.B	$00,$00
*
	dc.B	$00,$00,$01,$55,$7F,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AB,$FF,$FD,$55,$00,$00,$00
*
	dc.B	$00,$00,$07,$D0,$00,$00
*
	dc.B	$00,$00
*
	dc.B	$00,$00,$01,$55,$57,$FF,$FF,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	dc.B	$AA,$AA,$AA,$AA,$AA,$AA,$AB,$FF,$FF,$55,$55,$00,$00,$00
*
	dc.B	$00,$00
*
*  ------------------------
*







