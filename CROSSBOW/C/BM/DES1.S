	ORG	RBMA + $0000

	DC.B	$FF,$FF,$FF,$FF,$FF,$FF,$7F,$FD,$FD,$FF,$7D,$FD,$FF,$F7,$FD,$F7
	DC.B	$FF,$FF,$75,$F5,$DF,$FF,$5F,$FF,$D5,$D7,$FF,$7F,$FF,$DF,$DD,$FD
	DC.B	$FF,$5F,$F5,$FD,$FF,$7D,$F7,$F5

	ORG	RBMA + $0100

	DC.B	$FD,$FF,$D5,$FF,$FF,$DF,$FD,$FF,$FF,$FD,$FD,$FD,$FD,$D7,$FF,$7F
	DC.B	$DD,$FD,$FF,$FF,$7F,$7F,$7F,$DF,$FF,$FD,$FF,$DF,$7F,$FF,$FF,$FF
	DC.B	$FF,$FF,$FD,$FD,$DF,$F7,$FF,$55

	ORG	RBMA + $0200

	DC.B	$FF,$F7,$F7,$F7,$F5,$FF,$FF,$DF,$DF,$7F,$FF,$DF,$FF,$DF,$FF,$FF
	DC.B	$FF,$FD,$FF,$DF,$FF,$FD,$FF,$FF,$FF,$75,$FF,$FF,$FF,$F7,$F5,$F7
	DC.B	$F7,$DF,$F5,$FF,$FF,$7F,$55,$55

	ORG	RBMA + $0300

	DC.B	$FF,$FF,$FF,$FF,$FF,$F7,$FF,$FF,$DF,$F7,$FF,$D5,$5F,$FD,$FD,$7F
	DC.B	$7F,$FF,$FF,$F7,$DF,$FF,$7D,$FF,$FD,$5F,$FF,$FD,$77,$57,$FF,$FF
	DC.B	$FF,$7F,$7F,$FF,$FF,$F5,$55,$55

	ORG	RBMA + $0400

	DC.B	$FF,$FF,$FF,$D7,$FF,$FF,$FF,$FF,$D7,$FF,$55,$55,$57,$FF,$FD,$FD
	DC.B	$FD,$FF,$DF,$FF,$77,$FD,$75,$FD,$DF,$DF,$F7,$F7,$7F,$F7,$DF,$FF
	DC.B	$FF,$FF,$7F,$7F,$D5,$55,$55,$55

	ORG	RBMA + $0500

	DC.B	$F7,$FF,$F5,$FF,$DD,$7F,$5F,$DF,$F7,$55,$55,$55,$55,$FF,$DF,$FF
	DC.B	$FD,$DF,$7D,$7F,$FF,$FF,$FF,$DF,$7F,$FF,$FF,$FF,$FF,$7F,$FF,$7F
	DC.B	$DF,$FF,$DF,$F5,$F5,$55,$55,$55

	ORG	RBMA + $0600

	DC.B	$D7,$7F,$7D,$FF,$DF,$5F,$F7,$D5,$55,$55,$55,$56,$AA,$BF,$FF,$FF
	DC.B	$7D,$FF,$FF,$FD,$F5,$DD,$77,$FD,$7F,$7F,$FF,$FF,$FD,$FF,$FF,$D5
	DC.B	$D5,$F7,$FF,$FD,$D5,$55,$55,$55

	ORG	RBMA + $0700

	DC.B	$DF,$FF,$FF,$7F,$7D,$5F,$7D,$55,$55,$55,$55,$6A,$AA,$AF,$D7,$FF
	DC.B	$FF,$FF,$FF,$DF,$D7,$7D,$7F,$DF,$DD,$FF,$FF,$DF,$55,$FF,$D7,$F5
	DC.B	$FF,$7F,$7F,$FF,$55,$55,$55,$55

	ORG	RBMA + $0800

	DC.B	$FF,$FF,$7F,$5F,$FF,$F7,$F5,$55,$55,$55,$6A,$AA,$AA,$AB,$FF,$FF
	DC.B	$7F,$7D,$FD,$DF,$FF,$FF,$FF,$FD,$FD,$DD,$5F,$F5,$FF,$F7,$FF,$FF
	DC.B	$FF,$FF,$FF,$FD,$55,$55,$55,$77

	ORG	RBMA + $0900

	DC.B	$FD,$FF,$DF,$FF,$F7,$FF,$D5,$55,$55,$6A,$AA,$AA,$AA,$AA,$FF,$FF
	DC.B	$FF,$FD,$FF,$FD,$FF,$5F,$7D,$F7,$FF,$FF,$75,$FF,$FF,$FD,$F7,$FF
	DC.B	$F5,$FD,$FD,$F5,$55,$55,$5D,$DD

	ORG	RBMA + $0A00

	DC.B	$FD,$FF,$DF,$FF,$DF,$F7,$55,$55,$56,$AA,$AA,$AA,$AA,$AA,$BD,$DF
	DC.B	$F7,$FD,$FF,$FD,$55,$55,$FF,$FF,$FD,$F7,$F7,$F5,$5F,$FF,$FD,$7D
	DC.B	$FF,$FF,$FF,$F5,$55,$57,$77,$77

	ORG	RBMA + $0B00

	DC.B	$FD,$FF,$DF,$FF,$F7,$FD,$55,$55,$5A,$AA,$AA,$AA,$AA,$AA,$AF,$DF
	DC.B	$F7,$DD,$FF,$D5,$55,$55,$55,$55,$55,$FF,$7D,$FF,$FF,$7F,$FF,$FF
	DC.B	$DF,$FF,$FF,$D5,$55,$5D,$DD,$DD

	ORG	RBMA + $0C00

	DC.B	$FF,$FF,$DD,$FD,$FD,$55,$55,$55,$6A,$AA,$AA,$AA,$AA,$AA,$AB,$FF
	DC.B	$FF,$FF,$DF,$55,$55,$55,$55,$55,$55,$55,$55,$FD,$F7,$F5,$7F,$FF
	DC.B	$5D,$7F,$D7,$55,$57,$77,$77,$77

	ORG	RBMA + $0D00

	DC.B	$FF,$FD,$FD,$FD,$DF,$55,$55,$56,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$FF
	DC.B	$FF,$DF,$FF,$55,$55,$55,$55,$55,$55,$55,$56,$BF,$FF,$FD,$FD,$FF
	DC.B	$FF,$5F,$F7,$55,$5D,$DD,$DD,$DD

	ORG	RBMA + $0E00

	DC.B	$FF,$7F,$FF,$5F,$7D,$55,$55,$6A,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$BF
	DC.B	$FF,$5F,$F7,$55,$55,$55,$55,$55,$55,$55,$5A,$AB,$FD,$FF,$FF,$F7
	DC.B	$FF,$FF,$7D,$55,$77,$77,$77,$77

	ORG	RBMA + $0F00

	DC.B	$FF,$DF,$FF,$FD,$5F,$55,$55,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AF
	DC.B	$DF,$FF,$FD,$50,$55,$55,$55,$55,$55,$55,$6A,$AA,$FF,$FF,$FF,$5F
	DC.B	$F7,$FF,$FD,$55,$DD,$DD,$DD,$DD

	ORG	RBMA + $0000 + $28

	DC.B	$DF,$7F,$FF,$DF,$F5,$55,$56,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB
	DC.B	$FF,$FD,$DD,$40,$15,$55,$55,$55,$55,$55,$AA,$AA,$B7,$F7,$7F,$F7
	DC.B	$F5,$FD,$F5,$57,$77,$77,$77,$77

	ORG	RBMA + $0100 + $28

	DC.B	$DF,$FF,$FF,$D7,$D5,$55,$5A,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB
	DC.B	$F7,$FD,$F5,$40,$05,$55,$55,$55,$55,$55,$AA,$AA,$AF,$F7,$FF,$FF
	DC.B	$7F,$D7,$D5,$50,$1D,$DD,$DD,$DD

	ORG	RBMA + $0200 + $28

	DC.B	$FD,$FF,$FF,$DF,$D5,$55,$6A,$AA,$AA,$AA,$AA,$AA,$00,$2A,$AA,$AB
	DC.B	$D7,$F7,$D5,$00,$01,$55,$55,$55,$55,$54,$AA,$AA,$AB,$FF,$FD,$FF
	DC.B	$DF,$FF,$55,$40,$07,$77,$77,$77

	ORG	RBMA + $0300 + $28

	DC.B	$FD,$FF,$FD,$FD,$D5,$55,$AA,$AA,$AA,$AA,$AA,$A8,$00,$00,$AA,$AA
	DC.B	$FF,$F7,$D4,$00,$00,$55,$55,$55,$55,$54,$2A,$AA,$AA,$5F,$F5,$F7
	DC.B	$DF,$5D,$55,$00,$01,$DD,$DD,$DD

	ORG	RBMA + $0400 + $28

	DC.B	$D7,$FF,$FD,$FF,$55,$40,$0A,$AA,$AA,$AA,$AA,$A0,$00,$00,$00,$2A
	DC.B	$BF,$7D,$54,$00,$00,$15,$55,$55,$55,$50,$02,$AA,$AA,$3F,$5F,$FF
	DC.B	$FD,$FD,$54,$00,$00,$77,$77,$77

	ORG	RBMA + $0500 + $28

	DC.B	$FF,$FF,$FF,$FD,$54,$00,$02,$AA,$AA,$AA,$AA,$80,$00,$00,$00,$00
	DC.B	$0F,$FF,$50,$00,$00,$05,$55,$55,$55,$40,$00,$AA,$A8,$0F,$FF,$FD
	DC.B	$FF,$FD,$54,$00,$00,$DD,$DD,$DD

	ORG	RBMA + $0600 + $28

	DC.B	$F7,$DF,$DD,$F5,$50,$00,$00,$AA,$AA,$AA,$AA,$00,$00,$00,$00,$00
	DC.B	$0F,$7D,$50,$00,$00,$00,$55,$55,$55,$00,$00,$2A,$A8,$03,$F7,$FF
	DC.B	$F7,$F5,$50,$00,$00,$37,$77,$77

	ORG	RBMA + $0700 + $28

	DC.B	$FF,$7F,$7F,$F5,$00,$00,$00,$2A,$AA,$AA,$A8,$00,$00,$00,$00,$00
	DC.B	$03,$75,$40,$00,$00,$00,$15,$55,$55,$00,$00,$2A,$A8,$00,$FF,$DD
	DC.B	$FF,$D5,$50,$00,$00,$0D,$DD,$DD

	ORG	RBMA + $0800 + $28

	DC.B	$DF,$FD,$7F,$50,$00,$00,$00,$2A,$AA,$AA,$A0,$00,$00,$00,$00,$00
	DC.B	$00,$DD,$00,$00,$00,$00,$05,$55,$55,$00,$00,$0A,$A0,$00,$3F,$FF
	DC.B	$FF,$55,$50,$00,$00,$03,$77,$77

	ORG	RBMA + $0900 + $28

	DC.B	$DF,$DF,$FD,$50,$00,$00,$00,$0A,$AA,$AA,$00,$00,$00,$00,$00,$00
	DC.B	$00,$F4,$00,$00,$00,$00,$00,$55,$54,$00,$00,$0A,$A0,$00,$0F,$FF
	DC.B	$DF,$55,$40,$00,$00,$00,$DD,$DD

	ORG	RBMA + $0A00 + $28

	DC.B	$FD,$FF,$FD,$40,$00,$00,$00,$02,$AA,$A8,$00,$00,$00,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$00,$00,$05,$54,$00,$00,$02,$80,$00,$03,$7D
	DC.B	$FD,$55,$00,$00,$00,$00,$37,$77

	ORG	RBMA + $0B00 + $28

	DC.B	$F7,$DF,$75,$00,$00,$00,$00,$00,$AA,$80,$00,$00,$00,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$00,$00,$01,$50,$00,$00,$00,$80,$00,$00,$F7
	DC.B	$D5,$54,$00,$00,$00,$00,$0D,$DD

	ORG	RBMA + $0C00 + $28

	DC.B	$FF,$F5,$54,$00,$00,$00,$00,$00,$2A,$00,$00,$00,$00,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$3F
	DC.B	$55,$50,$00,$00,$00,$00,$03,$77

	ORG	RBMA + $0D00 + $28

	DC.B	$FF,$D5,$50,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05
	DC.B	$55,$50,$00,$00,$00,$00,$00,$DD

	ORG	RBMA + $0E00 + $28

	DC.B	$FF,$50,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
	DC.B	$55,$40,$00,$00,$00,$00,$00,$37

	ORG	RBMA + $0F00 + $28

	DC.B	$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	DC.B	$15,$00,$00,$00,$00,$00,$00,$0D

	.END
