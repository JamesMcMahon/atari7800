	ORG	RBMA + $0000

	DC.B	$00,$FD,$55,$00,$00,$00,$00,$00,$00,$00,$00,$00

	ORG	RBMA + $0100

	DC.B	$00,$57,$FF,$55,$00,$00,$00,$00,$00,$00,$00,$00

	ORG	RBMA + $0200

	DC.B	$03,$FD,$55,$FF,$55,$50,$00,$00,$00,$00,$00,$00

	ORG	RBMA + $0300

	DC.B	$03,$FF,$FF,$55,$FF,$D5,$54,$00,$00,$00,$00,$00

	ORG	RBMA + $0400

	DC.B	$03,$FF,$FF,$FF,$55,$7F,$F5,$55,$00,$00,$00,$00

	ORG	RBMA + $0500

	DC.B	$03,$FF,$FF,$FF,$FF,$D5,$5F,$FD,$55,$00,$00,$00

	ORG	RBMA + $0600

	DC.B	$01,$5F,$FF,$FF,$FF,$FF,$F5,$57,$FF,$55,$00,$00

	ORG	RBMA + $0700

	DC.B	$0F,$F5,$57,$FF,$FF,$FF,$FF,$FD,$55,$FF,$55,$40

	ORG	RBMA + $0800

	DC.B	$0F,$FF,$FD,$57,$FF,$FF,$FF,$FF,$FF,$55,$FF,$D4

	ORG	RBMA + $0900

	DC.B	$0F,$FF,$FF,$FD,$55,$FF,$FF,$FF,$FF,$FF,$55,$70

	ORG	RBMA + $0A00

	DC.B	$0F,$FF,$FF,$FF,$FF,$55,$7F,$FF,$FF,$FF,$FF,$C0

	ORG	RBMA + $0B00

	DC.B	$05,$7F,$FF,$FF,$FF,$FF,$D5,$5F,$FF,$FF,$FF,$00

	ORG	RBMA + $0C00

	DC.B	$3F,$D5,$5F,$FF,$FF,$FF,$FF,$F5,$5F,$FF,$FC,$00

	ORG	RBMA + $0D00

	DC.B	$3F,$FF,$F5,$57,$FF,$FF,$FF,$FF,$F5,$57,$F0,$00

	ORG	RBMA + $0E00

	DC.B	$3F,$FF,$FF,$FD,$55,$FF,$FF,$FF,$FF,$FD,$40,$00

	ORG	RBMA + $0F00

	DC.B	$3F,$FF,$FF,$FF,$FF,$55,$FF,$FF,$FF,$FF,$00,$00

	ORG	RBMA + $0000 + $0C

	DC.B	$15,$FF,$FF,$FF,$FF,$FF,$55,$7F,$FF,$FC,$00,$00

	ORG	RBMA + $0100 + $0C

	DC.B	$FF,$55,$7F,$FF,$FF,$FF,$FF,$D5,$5F,$F0,$00,$00

	ORG	RBMA + $0200 + $0C

	DC.B	$FF,$FF,$D5,$7F,$FF,$FF,$FF,$FF,$F5,$40,$00,$00

	ORG	RBMA + $0300 + $0C

	DC.B	$FF,$FF,$FF,$D5,$5F,$FF,$FF,$FF,$FF,$00,$00,$00

	ORG	RBMA + $0400 + $0C

	DC.B	$FF,$FF,$FF,$FF,$F5,$57,$FF,$FF,$FC,$00,$00,$00

	ORG	RBMA + $0500 + $0C

	DC.B	$0F,$FF,$FF,$FF,$FF,$FD,$57,$FF,$F0,$00,$00,$00

	ORG	RBMA + $0600 + $0C

	DC.B	$00,$0F,$FF,$FF,$FF,$FF,$FD,$55,$C0,$00,$00,$00

	ORG	RBMA + $0700 + $0C

	DC.B	$00,$00,$0F,$FF,$FF,$FF,$FF,$FD,$00,$00,$00,$00

	ORG	RBMA + $0800 + $0C

	DC.B	$00,$00,$00,$0F,$FF,$FF,$FF,$FC,$00,$00,$00,$00

	ORG	RBMA + $0900 + $0C

	DC.B	$00,$00,$00,$00,$3F,$FF,$FF,$F0,$00,$00,$00,$00

	ORG	RBMA + $0A00 + $0C

	DC.B	$00,$00,$00,$00,$00,$3F,$FF,$C0,$00,$00,$00,$00

	ORG	RBMA + $0B00 + $0C

	DC.B	$00,$00,$00,$00,$00,$00,$3F,$00,$00,$00,$00,$00

	ORG	RBMA + $0C00 + $0C

	DC.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

	ORG	RBMA + $0D00 + $0C

	DC.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

	ORG	RBMA + $0E00 + $0C

	DC.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

	ORG	RBMA + $0F00 + $0C

	DC.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

	.END
