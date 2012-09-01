	ORG	RBMA + $0000

	DC.B	$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$B0,$03
	DC.B	$BB,$BB,$BB,$BB

	ORG	RBMA + $0100

	DC.B	$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$E0,$02
	DC.B	$EE,$EE,$EE,$EE

	ORG	RBMA + $0200

	DC.B	$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$B0,$00
	DC.B	$BB,$BB,$BB,$BB

	ORG	RBMA + $0300

	DC.B	$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$E0,$00
	DC.B	$EE,$EE,$EE,$EE

	ORG	RBMA + $0400

	DC.B	$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$80,$00
	DC.B	$BB,$BB,$BB,$BB

	ORG	RBMA + $0500

	DC.B	$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$00,$00
	DC.B	$EE,$EE,$EE,$EE

	ORG	RBMA + $0600

	DC.B	$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$00,$00
	DC.B	$BB,$BB,$BB,$BB

	ORG	RBMA + $0700

	DC.B	$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$00,$00
	DC.B	$2E,$EE,$EE,$EE

	ORG	RBMA + $0800

	DC.B	$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$B8,$00,$00,$00
	DC.B	$0B,$BB,$BB,$BB

	ORG	RBMA + $0900

	DC.B	$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EC,$00,$00,$00
	DC.B	$0E,$EE,$EE,$EE

	ORG	RBMA + $0A00

	DC.B	$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$B0,$00,$00,$00
	DC.B	$03,$BB,$BB,$BB

	ORG	RBMA + $0B00

	DC.B	$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE,$C0,$00,$00,$00
	DC.B	$00,$2E,$EE,$EE

	ORG	RBMA + $0C00

	DC.B	$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$B8,$00,$00,$00,$00
	DC.B	$00,$00,$3B,$BB

	ORG	RBMA + $0D00

	DC.B	$EE,$EE,$EE,$EE,$E0,$02,$EE,$EE,$EE,$EE,$EE,$EC,$00,$00,$00,$00
	DC.B	$00,$00,$0E,$EE

	ORG	RBMA + $0E00

	DC.B	$BB,$03,$BB,$BB,$80,$03,$BB,$00,$BB,$BB,$BB,$80,$00,$00,$00,$00
	DC.B	$00,$00,$0B,$BB

	ORG	RBMA + $0F00

	DC.B	$EC,$00,$0E,$EE,$00,$00,$0E,$00,$02,$EE,$00,$00,$00,$00,$00,$00
	DC.B	$00,$00,$02,$EC

	.END
