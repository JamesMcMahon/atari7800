; FRAME # 1  FLASH /SPR

	ORG	RBMA + $0000

	DC.B	$00,$00

	ORG	RBMA + $0100

	DC.B	$00,$00

	ORG	RBMA + $0200

	DC.B	$00,$00

	ORG	RBMA + $0300

	DC.B	$00,$00

	ORG	RBMA + $0400

	DC.B	$00,$00

	ORG	RBMA + $0500

	DC.B	$00,$00

	ORG	RBMA + $0600

	DC.B	$08,$00

	ORG	RBMA + $0700

	DC.B	$08,$00

	ORG	RBMA + $0800

	DC.B	$2E,$00

	ORG	RBMA + $0900

	DC.B	$2E,$00

	ORG	RBMA + $0A00

	DC.B	$2E,$00

	ORG	RBMA + $0B00

	DC.B	$08,$00

	ORG	RBMA + $0C00

	DC.B	$08,$00

	ORG	RBMA + $0D00

	DC.B	$00,$00

	ORG	RBMA + $0E00

	DC.B	$00,$00

	ORG	RBMA + $0F00

	DC.B	$00,$00

; FRAME # 2  FLASH /SPR

	ORG	RBMA + $0000 + $02

	DC.B	$00,$00

	ORG	RBMA + $0100 + $02

	DC.B	$00,$00

	ORG	RBMA + $0200 + $02

	DC.B	$00,$00

	ORG	RBMA + $0300 + $02

	DC.B	$08,$00

	ORG	RBMA + $0400 + $02

	DC.B	$08,$00

	ORG	RBMA + $0500 + $02

	DC.B	$2A,$00

	ORG	RBMA + $0600 + $02

	DC.B	$2E,$00

	ORG	RBMA + $0700 + $02

	DC.B	$AE,$80

	ORG	RBMA + $0800 + $02

	DC.B	$BF,$80

	ORG	RBMA + $0900 + $02

	DC.B	$BF,$80

	ORG	RBMA + $0A00 + $02

	DC.B	$BF,$80

	ORG	RBMA + $0B00 + $02

	DC.B	$AE,$80

	ORG	RBMA + $0C00 + $02

	DC.B	$2E,$00

	ORG	RBMA + $0D00 + $02

	DC.B	$2A,$00

	ORG	RBMA + $0E00 + $02

	DC.B	$08,$00

	ORG	RBMA + $0F00 + $02

	DC.B	$08,$00

	.END
