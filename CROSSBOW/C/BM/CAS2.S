	ORG	RBMA + $0000

	DC.B	$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC
	DC.B	$C0,$00,$00,$00,$00,$00,$00,$00

	ORG	RBMA + $0100

	DC.B	$CC,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	DC.B	$30,$00,$00,$00,$00,$00,$00,$00

	ORG	RBMA + $0200

	DC.B	$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	DC.B	$CC,$00,$00,$00,$00,$00,$00,$00

	ORG	RBMA + $0300

	DC.B	$CC,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$FC,$00
	DC.B	$33,$30,$00,$00,$00,$00,$00,$00

	ORG	RBMA + $0400

	DC.B	$F3,$30,$00,$00,$00,$00,$FC,$C0,$00,$00,$00,$03,$CF,$0F,$FF,$FF
	DC.B	$CC,$CC,$00,$00,$00,$0F,$FF,$FF

	ORG	RBMA + $0500

	DC.B	$FC,$CC,$00,$00,$00,$03,$FF,$30,$00,$00,$0F,$CF,$FF,$FF,$FF,$FF
	DC.B	$F3,$33,$00,$03,$FF,$FF,$FF,$FF

	ORG	RBMA + $0600

	DC.B	$FF,$33,$00,$00,$00,$3F,$FF,$CC,$C0,$00,$0F,$FF,$FF,$FF,$FF,$FF
	DC.B	$FC,$CC,$C0,$0F,$FF,$FF,$FF,$FF

	ORG	RBMA + $0700

	DC.B	$FF,$CC,$C0,$00,$00,$FF,$FF,$F3,$30,$00,$3F,$FF,$FF,$FF,$FF,$FF
	DC.B	$FF,$33,$30,$3F,$FF,$FF,$FF,$FF

	ORG	RBMA + $0800

	DC.B	$FF,$F3,$30,$00,$00,$FF,$FF,$FC,$CC,$00,$FF,$FF,$FF,$FF,$FF,$FF
	DC.B	$FF,$CC,$CC,$FF,$FF,$FF,$FF,$FF

	ORG	RBMA + $0900

	DC.B	$FF,$FC,$CC,$00,$03,$FF,$FF,$FF,$F3,$03,$FF,$FF,$FF,$FF,$FF,$FF
	DC.B	$FF,$FF,$33,$FF,$FF,$FF,$FF,$FF

	ORG	RBMA + $0A00

	DC.B	$FF,$FF,$33,$00,$03,$FF,$FF,$FF,$FC,$0F,$FF,$FF,$FF,$FF,$FF,$FF
	DC.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

	ORG	RBMA + $0B00

	DC.B	$FF,$FF,$CC,$00,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DC.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

	ORG	RBMA + $0C00

	DC.B	$FF,$FF,$F3,$00,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DC.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

	ORG	RBMA + $0D00

	DC.B	$FF,$FF,$FC,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DC.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

	ORG	RBMA + $0E00

	DC.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DC.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

	ORG	RBMA + $0F00

	DC.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DC.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

	ORG	RBMA + $1000

	DC.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$EF,$FF,$FF,$FF,$FE,$66,$FF,$FF
	DC.B	$FF,$FF,$FF,$66,$FF,$FF,$FF,$FF

	ORG	RBMA + $1100

	DC.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$9F,$FF,$FF,$FF,$FF,$99,$BF,$FF
	DC.B	$FF,$FF,$FF,$99,$BF,$FF,$FF,$FF

	ORG	RBMA + $1200

	DC.B	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$7F,$FF,$FF,$FF,$FF,$66,$6F,$FF
	DC.B	$FF,$FF,$FF,$66,$6F,$FF,$FF,$FF

	ORG	RBMA + $1300

	DC.B	$FF,$FF,$FB,$FF,$FF,$FF,$FF,$F9,$BF,$FF,$FB,$FF,$FD,$91,$9B,$FF
	DC.B	$FF,$FF,$FD,$99,$9B,$FF,$FF,$FF

	ORG	RBMA + $1400

	DC.B	$FF,$EF,$F7,$FF,$FF,$FF,$FF,$66,$FF,$F7,$E7,$EF,$76,$40,$66,$7F
	DC.B	$FF,$FF,$E6,$66,$66,$6F,$FF,$FF

	ORG	RBMA + $1500

	DC.B	$BF,$DF,$F9,$FD,$F9,$FF,$F9,$99,$9F,$F9,$DB,$9D,$99,$00,$19,$9F
	DC.B	$FF,$FB,$99,$00,$19,$9B,$FF,$FF

	ORG	RBMA + $1600

	DC.B	$6F,$E7,$E6,$F6,$E6,$7F,$E6,$66,$66,$66,$66,$66,$64,$00,$06,$67
	DC.B	$FF,$E6,$64,$00,$06,$66,$FF,$FF

	ORG	RBMA + $1700

	DC.B	$1B,$D9,$99,$B9,$D9,$BD,$99,$99,$99,$99,$99,$99,$90,$00,$01,$99
	DC.B	$9D,$99,$90,$00,$01,$99,$9F,$FF

	ORG	RBMA + $1800

	DC.B	$06,$66,$66,$66,$66,$66,$40,$00,$06,$66,$66,$64,$00,$00,$00,$06
	DC.B	$66,$66,$40,$00,$00,$66,$66,$FF

	ORG	RBMA + $1900

	DC.B	$01,$99,$99,$99,$99,$99,$00,$00,$00,$19,$99,$90,$00,$00,$00,$01
	DC.B	$99,$99,$00,$00,$00,$19,$99,$FF

	ORG	RBMA + $1A00

	DC.B	$00,$66,$66,$66,$66,$40,$00,$00,$00,$06,$66,$40,$00,$00,$00,$00
	DC.B	$06,$40,$00,$00,$00,$06,$66,$FF

	ORG	RBMA + $1B00

	DC.B	$00,$01,$99,$99,$99,$00,$00,$00,$00,$00,$19,$00,$00,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$01,$99,$9F

	ORG	RBMA + $1C00

	DC.B	$00,$00,$66,$66,$64,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$00,$06,$66

	ORG	RBMA + $1D00

	DC.B	$00,$00,$19,$99,$90,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$00,$00,$99

	ORG	RBMA + $1E00

	DC.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$00,$00,$26

	ORG	RBMA + $1F00

	DC.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$00,$00,$00

	.END
