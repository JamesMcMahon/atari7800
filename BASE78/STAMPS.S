*         2010    201283
*
** STAMPS.S **
** ASTEROIDS FOR THE ATARI 3600 **
** UNCONVERTED GRAPHICS DATA. **
** SWITCHED NOW FOR MARIA2. **


* START OF GRAPHICS DATA *
	.ORG	$C000
GRAPHICS  EQU	*

STAMPS    EQU     GRAPHICS-$1000	;ODD 4K PAGE BOUNDARY FOR HOLY DMA

				;1
********************************************************************************
	.DC.B	$03,$FC,$00	;ROCK1L
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00	;ROCK2L
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$03,$FC,$00
	.DC.B	$00,$F0,$00	;ROCK3L
	.DC.B	$00,$F0,$00
	.DC.B	$00,$F0,$00
	.DC.B	$00,$F0,$00
	.DC.B	$00,$F0,$00
	.DC.B	$00,$F0,$00
	.DC.B	$00,$F0,$00
	.DC.B	$00,$F0,$00
	.DC.B	$00,$F0,$00
	.DC.B	$00,$F0,$00
	.DC.B	$00,$F0,$00
	.DC.B	$00,$F0,$00
	.DC.B	$00,$00,$00	;ROCKEL
	.DC.B	$00,$23,$00
	.DC.B	$00,$10,$00
	.DC.B	$00,$08,$00
	.DC.B	$00,$20,$00
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;ROCK1M
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;ROCK2M
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;ROCK3M
	.DC.B	0,0,0,0,0,0,0,0,0,0		;ROCKEM
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;SHIP
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0		;SHIPE
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0		;UFO
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	ORG     GRAPHICS+$100			;2
********************************************************************************
	.DC.B	$0F,$AA,$00	;ROCK1L
	.DC.B	$0F,$AA,$00
	.DC.B	$0F,$AA,$00
	.DC.B	$0F,$AB,$00
	.DC.B	$0F,$AF,$00
	.DC.B	$0F,$B6,$00
	.DC.B	$0F,$AA,$00
	.DC.B	$0F,$6A,$00
	.DC.B	$0F,$AB,$00
	.DC.B	$0F,$AD,$00
	.DC.B	$0F,$AD,$00
	.DC.B	$0F,$B5,$00
	.DC.B	$0F,$EA,$00	;ROCK2L
	.DC.B	$0F,$DA,$00
	.DC.B	$0F,$E9,$00
	.DC.B	$0F,$E9,$00
	.DC.B	$0F,$EA,$00
	.DC.B	$0F,$F5,$00
	.DC.B	$0F,$B9,$00
	.DC.B	$0F,$EB,$00
	.DC.B	$0F,$FA,$00
	.DC.B	$0F,$E9,$00
	.DC.B	$0F,$E9,$00
	.DC.B	$0F,$EA,$00
	.DC.B	$0F,$FF,$00	;ROCK3L
	.DC.B	$0F,$FF,$00
	.DC.B	$0F,$FF,$00
	.DC.B	$0F,$FF,$00
	.DC.B	$0F,$FF,$00
	.DC.B	$0F,$FE,$00
	.DC.B	$0F,$BF,$00
	.DC.B	$0F,$FF,$00
	.DC.B	$0F,$FF,$00
	.DC.B	$0F,$FF,$00
	.DC.B	$0F,$FF,$00
	.DC.B	$0F,$FF,$00
	.DC.B	$00,$00,$00	;ROCKEL
	.DC.B	$00,$10,$00
	.DC.B	$00,$08,$00
	.DC.B	$08,$10,$40
	.DC.B	$23,$04,$00
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;ROCK1M
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;ROCK2M
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;ROCK3M
	.DC.B	0,0,0,0,0,0,0,0,0,0		;ROCKEM
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;SHIP
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0		;SHIPE
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0		;UFO
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	ORG     GRAPHICS+$200			;3
********************************************************************************
	.DC.B	$0F,$F6,$00	;ROCK1L
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$AF,$00
	.DC.B	$0F,$BF,$00
	.DC.B	$0F,$D5,$00
	.DC.B	$0D,$A5,$00
	.DC.B	$0F,$99,$00
	.DC.B	$0E,$9D,$00
	.DC.B	$0F,$B5,$00
	.DC.B	$0F,$B7,$00
	.DC.B	$0F,$A5,$00	;ROCK2L
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$A9,$00
	.DC.B	$0F,$A9,$00
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$B9,$00
	.DC.B	$0F,$AD,$00
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$A9,$00
	.DC.B	$0F,$A6,$00
	.DC.B	$0F,$AA,$00
	.DC.B	$0F,$95,$00
	.DC.B	$0F,$AA,$00	;ROCK3L
	.DC.B	$0F,$AA,$00
	.DC.B	$0F,$AA,$00
	.DC.B	$0F,$AA,$00
	.DC.B	$0F,$AA,$00
	.DC.B	$0F,$A6,$C0
	.DC.B	$0F,$DE,$00
	.DC.B	$0F,$BA,$00
	.DC.B	$0E,$AA,$00
	.DC.B	$0F,$AA,$00
	.DC.B	$0F,$AA,$00
	.DC.B	$0F,$AA,$00
	.DC.B	$00,$01,$00	;ROCKEL
	.DC.B	$00,$10,$90
	.DC.B	$00,$20,$08
	.DC.B	$08,$10,$40
	.DC.B	$00,$00,$00
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;ROCK1M
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;ROCK2M
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;ROCK3M
	.DC.B	0,0,0,0,0,0,0,0,0,0		;ROCKEM
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;SHIP
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0		;SHIPE
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0		;UFO
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	ORG     GRAPHICS+$300			;4
********************************************************************************
	.DC.B	$3F,$55,$80	;ROCK1L
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$95,$80
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$A5,$40
	.DC.B	$3E,$BD,$40
	.DC.B	$3E,$FD,$40
	.DC.B	$3F,$56,$40
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$A5,$C0
	.DC.B	$3E,$B5,$40
	.DC.B	$3E,$D6,$80
	.DC.B	$3F,$99,$40	;ROCK2L
	.DC.B	$3F,$69,$40
	.DC.B	$3E,$A5,$40
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$A5,$40
	.DC.B	$3E,$ED,$40
	.DC.B	$3E,$95,$C0
	.DC.B	$3E,$A5,$40
	.DC.B	$3F,$A5,$40
	.DC.B	$3E,$A5,$40
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$96,$80	;ROCK3L
	.DC.B	$3E,$96,$80
	.DC.B	$3E,$96,$80
	.DC.B	$3E,$96,$80
	.DC.B	$3E,$95,$C0
	.DC.B	$3E,$9F,$C0
	.DC.B	$3E,$75,$80
	.DC.B	$3F,$D6,$80
	.DC.B	$3B,$96,$80
	.DC.B	$3E,$96,$80
	.DC.B	$3E,$96,$80
	.DC.B	$3E,$96,$80
	.DC.B	$00,$20,$00	;ROCKEL
	.DC.B	$04,$14,$40
	.DC.B	$01,$29,$10
	.DC.B	$01,$04,$48
	.DC.B	$00,$40,$00
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;ROCK1M
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;ROCK2M
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;ROCK3M
	.DC.B	0,0,0,0,0,0,0,0,0,0		;ROCKEM
	.DC.B	$01,$00				;SHIP
	.DC.B	$04,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$40
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0		;SHIPE
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0		;UFO
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	ORG     GRAPHICS+$400	;5
********************************************************************************
	.DC.B	$3F,$75,$40	;ROCK1L
	.DC.B	$3F,$99,$40
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$65,$40
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$F6,$40
	.DC.B	$3F,$F5,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$57,$C0
	.DC.B	$3E,$D6,$80
	.DC.B	$3E,$A5,$40	;ROCK2L
	.DC.B	$3F,$A5,$40
	.DC.B	$3F,$99,$40
	.DC.B	$3E,$65,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$95,$80
	.DC.B	$3E,$55,$C0
	.DC.B	$3E,$55,$40
	.DC.B	$3F,$95,$40
	.DC.B	$3E,$D5,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$95,$40	;ROCK3L
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$55,$80
	.DC.B	$3E,$55,$C0
	.DC.B	$3A,$55,$80
	.DC.B	$3A,$D7,$40
	.DC.B	$3A,$95,$40
	.DC.B	$39,$D5,$40
	.DC.B	$2E,$55,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$55,$40
	.DC.B	$00,$38,$80	;ROCKEL
	.DC.B	$10,$94,$80
	.DC.B	$80,$51,$50
	.DC.B	$03,$49,$00
	.DC.B	$00,$01,$00
	.DC.B	$03,$F0		;ROCK1M
	.DC.B	$00,$F0
	.DC.B	$00,$F0
	.DC.B	$00,$F0
	.DC.B	$03,$F0
	.DC.B	$03,$F0
	.DC.B	$03,$F0
	.DC.B	$00,$F0
	.DC.B	$0F,$F0		;ROCK2M
	.DC.B	$0F,$F0
	.DC.B	$0E,$F0
	.DC.B	$0F,$F0
	.DC.B	$0F,$F0
	.DC.B	$03,$F0
	.DC.B	$03,$F0
	.DC.B	$03,$F0
	.DC.B	$0F,$F0		;ROCK3M
	.DC.B	$0F,$F0
	.DC.B	$0F,$F0
	.DC.B	$0F,$F0
	.DC.B	$0F,$F0
	.DC.B	$0F,$F0
	.DC.B	$0F,$F0
	.DC.B	$0F,$F0
	.DC.B	$00,$00		;ROCKEM
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$04,$20
	.DC.B	$01,$00		;SHIP
	.DC.B	$04,$80
	.DC.B	$02,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$02,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$02,$00
	.DC.B	$08,$40
	.DC.B	$00,$00		;SHIPE
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$02
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	0,0,0,0,0,0,0,0	;UFOL
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	ORG     GRAPHICS+$500	;6
********************************************************************************
	.DC.B	$FD,$6D,$50	;ROCK1L
	.DC.B	$FD,$55,$50
	.DC.B	$FE,$65,$50
	.DC.B	$FE,$55,$50
	.DC.B	$FE,$55,$50
	.DC.B	$FE,$95,$50
	.DC.B	$FE,$95,$50
	.DC.B	$FB,$D5,$50
	.DC.B	$FF,$D9,$D0
	.DC.B	$FE,$55,$50
	.DC.B	$FE,$95,$D0
	.DC.B	$FE,$9F,$D0
	.DC.B	$FE,$65,$50	;ROCK2L
	.DC.B	$FF,$95,$50
	.DC.B	$FF,$95,$50
	.DC.B	$FE,$D6,$50
	.DC.B	$FE,$95,$50
	.DC.B	$FA,$65,$50
	.DC.B	$FF,$55,$50
	.DC.B	$FF,$5D,$D0
	.DC.B	$FE,$55,$70
	.DC.B	$FE,$A5,$50
	.DC.B	$FF,$D5,$50
	.DC.B	$FF,$75,$50
	.DC.B	$FA,$65,$60	;ROCK3L
	.DC.B	$FA,$95,$60
	.DC.B	$FA,$55,$60
	.DC.B	$FA,$5D,$70
	.DC.B	$FA,$76,$F0
	.DC.B	$FA,$59,$60
	.DC.B	$FE,$55,$60
	.DC.B	$FF,$55,$60
	.DC.B	$FA,$55,$60
	.DC.B	$FA,$55,$60
	.DC.B	$FA,$5D,$60
	.DC.B	$F9,$B5,$60
	.DC.B	$02,$25,$80	;ROCKEL
	.DC.B	$05,$69,$04
	.DC.B	$26,$99,$40
	.DC.B	$00,$62,$00
	.DC.B	$01,$04,$08
	.DC.B	$03,$F0		;ROCK1M
	.DC.B	$0F,$F0
	.DC.B	$0B,$F0
	.DC.B	$0E,$F0
	.DC.B	$0F,$B0
	.DC.B	$0F,$EC
	.DC.B	$0F,$F8
	.DC.B	$03,$FC
	.DC.B	$2F,$FC		;ROCK2M
	.DC.B	$3F,$FC
	.DC.B	$3F,$FC
	.DC.B	$3F,$BC
	.DC.B	$0F,$FC
	.DC.B	$03,$FC
	.DC.B	$03,$FC
	.DC.B	$03,$FC
	.DC.B	$3F,$FC		;ROCK3M
	.DC.B	$3F,$FC
	.DC.B	$3F,$FC
	.DC.B	$3F,$FC
	.DC.B	$3F,$FC
	.DC.B	$3F,$FC
	.DC.B	$3F,$FC
	.DC.B	$3F,$FC
	.DC.B	$00,$00		;ROCKEM
	.DC.B	$00,$00
	.DC.B	$05,$20
	.DC.B	$04,$08
	.DC.B	$00,$00
	.DC.B	$20,$20		;SHIP
	.DC.B	$03,$80
	.DC.B	$42,$00
	.DC.B	$08,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$80
	.DC.B	$02,$00
	.DC.B	$08,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$80
	.DC.B	$02,$04
	.DC.B	$0B,$00
	.DC.B	$00,$00		;SHIPE
	.DC.B	$00,$20
	.DC.B	$00,$08
	.DC.B	$01,$00
	.DC.B	$00,$00
	.DC.B	$00,$08
	.DC.B	0,0,0,0,0,0,0,0	;UFOL
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	ORG     GRAPHICS+$600	;7
********************************************************************************
	.DC.B	$FD,$6D,$50	;ROCK1L
	.DC.B	$FF,$55,$70
	.DC.B	$FF,$55,$50
	.DC.B	$FA,$55,$50
	.DC.B	$FA,$95,$50
	.DC.B	$FA,$55,$50
	.DC.B	$FA,$55,$50
	.DC.B	$F9,$55,$50
	.DC.B	$FF,$65,$50
	.DC.B	$FF,$95,$50
	.DC.B	$F9,$55,$50
	.DC.B	$F9,$67,$50
	.DC.B	$FA,$D5,$50	;ROCK2L
	.DC.B	$FA,$99,$50
	.DC.B	$FA,$D5,$50
	.DC.B	$F6,$E5,$50
	.DC.B	$FA,$95,$90
	.DC.B	$FE,$96,$50
	.DC.B	$FA,$95,$50
	.DC.B	$FB,$65,$D0
	.DC.B	$F9,$97,$70
	.DC.B	$FA,$95,$50
	.DC.B	$FF,$55,$50
	.DC.B	$FF,$F5,$50
	.DC.B	$F9,$D5,$50	;ROCK3L
	.DC.B	$FD,$55,$50
	.DC.B	$F9,$55,$50
	.DC.B	$F9,$55,$70
	.DC.B	$FA,$56,$D0
	.DC.B	$F9,$55,$50
	.DC.B	$F9,$55,$50
	.DC.B	$FA,$55,$50
	.DC.B	$F9,$55,$50
	.DC.B	$F9,$57,$50
	.DC.B	$F9,$5A,$50
	.DC.B	$FA,$59,$50
	.DC.B	$0A,$57,$00	;ROCKEL
	.DC.B	$02,$75,$80
	.DC.B	$01,$55,$10
	.DC.B	$02,$02,$18
	.DC.B	$06,$00,$C2
	.DC.B	$0F,$FC		;ROCK1M
	.DC.B	$0F,$FC
	.DC.B	$0F,$FC
	.DC.B	$0F,$F0
	.DC.B	$0F,$F8
	.DC.B	$0F,$FF
	.DC.B	$0F,$FC
	.DC.B	$0F,$FF
	.DC.B	$3F,$D8		;ROCK2M
	.DC.B	$3B,$D8
	.DC.B	$3E,$A8
	.DC.B	$3E,$A8
	.DC.B	$3E,$A8
	.DC.B	$3E,$98
	.DC.B	$3F,$A8
	.DC.B	$3F,$D8
	.DC.B	$3E,$A8		;ROCK3M
	.DC.B	$3E,$A8
	.DC.B	$3E,$A8
	.DC.B	$3E,$A8
	.DC.B	$3E,$A8
	.DC.B	$3E,$E8
	.DC.B	$3D,$A8
	.DC.B	$3E,$A8
	.DC.B	$00,$00		;ROCKEM
	.DC.B	$00,$30
	.DC.B	$01,$40
	.DC.B	$09,$10
	.DC.B	$C0,$08
	.DC.B	$2F,$E0		;SHIP
	.DC.B	$02,$80
	.DC.B	$0E,$00
	.DC.B	$0A,$00
	.DC.B	$2C,$00
	.DC.B	$00,$00
	.DC.B	$00,$E0
	.DC.B	$02,$80
	.DC.B	$02,$00
	.DC.B	$0A,$00
	.DC.B	$2C,$00
	.DC.B	$00,$00
	.DC.B	$00,$E0
	.DC.B	$02,$80
	.DC.B	$02,$C0
	.DC.B	$0A,$00
	.DC.B	$01,$04		;SHIPE
	.DC.B	$04,$10
	.DC.B	$00,$A0
	.DC.B	$02,$40
	.DC.B	$02,$80
	.DC.B	$02,$00
	.DC.B	0,0,0,0,0,0,0,0	;UFOL
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	ORG     GRAPHICS+$700	;8
********************************************************************************
	.DC.B	$F9,$5D,$50	;ROCK1L
	.DC.B	$F5,$D5,$50
	.DC.B	$FD,$55,$D0
	.DC.B	$F9,$55,$50
	.DC.B	$FA,$55,$50
	.DC.B	$FA,$65,$50
	.DC.B	$F9,$65,$50
	.DC.B	$F5,$95,$50
	.DC.B	$F9,$55,$50
	.DC.B	$FD,$5D,$50
	.DC.B	$FD,$96,$50
	.DC.B	$FA,$55,$50
	.DC.B	$FA,$F7,$50	;ROCK2L
	.DC.B	$FA,$95,$50
	.DC.B	$F9,$D6,$50
	.DC.B	$FA,$B5,$50
	.DC.B	$F9,$9D,$50
	.DC.B	$F6,$95,$50
	.DC.B	$FB,$95,$50
	.DC.B	$FF,$D5,$50
	.DC.B	$F9,$75,$70
	.DC.B	$FA,$55,$D0
	.DC.B	$FA,$95,$50
	.DC.B	$FB,$D9,$50
	.DC.B	$FD,$D5,$50	;ROCK3L
	.DC.B	$FF,$55,$50
	.DC.B	$F9,$55,$90
	.DC.B	$F9,$65,$70
	.DC.B	$F9,$55,$50
	.DC.B	$F9,$55,$50
	.DC.B	$F9,$59,$50
	.DC.B	$F9,$65,$50
	.DC.B	$FA,$56,$50
	.DC.B	$F9,$55,$90
	.DC.B	$F9,$66,$50
	.DC.B	$FE,$6D,$50
	.DC.B	$00,$B5,$80	;ROCKEL
	.DC.B	$00,$96,$60
	.DC.B	$00,$75,$60
	.DC.B	$01,$08,$88
	.DC.B	$80,$00,$80
	.DC.B	$0E,$E8		;ROCK1M
	.DC.B	$3F,$BC
	.DC.B	$3F,$AC
	.DC.B	$3E,$A8
	.DC.B	$3B,$A8
	.DC.B	$3E,$F4
	.DC.B	$0F,$BF
	.DC.B	$0F,$AF
	.DC.B	$FB,$FB		;ROCK2M
	.DC.B	$FB,$FB
	.DC.B	$FA,$FB
	.DC.B	$FA,$5B
	.DC.B	$FA,$5B
	.DC.B	$FA,$97
	.DC.B	$FA,$9B
	.DC.B	$FB,$DB
	.DC.B	$FA,$5B		;ROCK3M
	.DC.B	$FA,$5B
	.DC.B	$F9,$5B
	.DC.B	$FA,$5F
	.DC.B	$FB,$58
	.DC.B	$FA,$AB
	.DC.B	$F6,$9F
	.DC.B	$FA,$6F
	.DC.B	$00,$00		;ROCKEM
	.DC.B	$01,$00
	.DC.B	$01,$40
	.DC.B	$00,$62
	.DC.B	$20,$30
	.DC.B	$3A,$B0		;SHIP
	.DC.B	$EA,$80
	.DC.B	$0A,$C0
	.DC.B	$4A,$80
	.DC.B	$2A,$00
	.DC.B	$2A,$C0
	.DC.B	$02,$A0
	.DC.B	$0E,$80
	.DC.B	$0E,$C0
	.DC.B	$0A,$00
	.DC.B	$2A,$00
	.DC.B	$0E,$A0
	.DC.B	$02,$A0
	.DC.B	$0A,$84
	.DC.B	$0E,$80
	.DC.B	$0A,$AC
	.DC.B	$01,$04		;SHIPE
	.DC.B	$0A,$90
	.DC.B	$02,$10
	.DC.B	$00,$A0
	.DC.B	$03,$88
	.DC.B	$00,$00
	.DC.B	0,0,0,0,0,0,0,0	;UFOL
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	ORG     GRAPHICS+$800	;9
********************************************************************************
	.DC.B	$F9,$75,$50	;ROCK1L
	.DC.B	$F9,$D5,$50
	.DC.B	$F7,$55,$50
	.DC.B	$F6,$57,$50
	.DC.B	$FA,$55,$50
	.DC.B	$F9,$55,$50
	.DC.B	$FA,$55,$50
	.DC.B	$F9,$55,$50
	.DC.B	$FA,$55,$50
	.DC.B	$FA,$55,$50
	.DC.B	$FA,$55,$50
	.DC.B	$FA,$59,$50
	.DC.B	$FA,$FF,$50	;ROCK2L
	.DC.B	$FE,$9D,$50
	.DC.B	$FB,$95,$50
	.DC.B	$F9,$75,$90
	.DC.B	$FA,$5D,$50
	.DC.B	$F9,$95,$60
	.DC.B	$FA,$95,$50
	.DC.B	$FD,$95,$50
	.DC.B	$FA,$75,$50
	.DC.B	$FA,$9D,$50
	.DC.B	$FA,$55,$70
	.DC.B	$FA,$95,$50
	.DC.B	$FA,$E5,$50	;ROCK3L
	.DC.B	$FB,$55,$90
	.DC.B	$FD,$55,$50
	.DC.B	$F9,$55,$50
	.DC.B	$F9,$95,$50
	.DC.B	$FA,$56,$50
	.DC.B	$F9,$56,$50
	.DC.B	$F9,$59,$90
	.DC.B	$F9,$95,$D0
	.DC.B	$FA,$55,$D0
	.DC.B	$F9,$67,$50
	.DC.B	$F9,$AD,$50
	.DC.B	$00,$64,$80	;ROCKEL
	.DC.B	$04,$5D,$28
	.DC.B	$10,$15,$62
	.DC.B	$20,$50,$00
	.DC.B	$00,$52,$00
	.DC.B	$2F,$98		;ROCK1M
	.DC.B	$3A,$BB
	.DC.B	$3E,$AF
	.DC.B	$3E,$97
	.DC.B	$3F,$A4
	.DC.B	$3E,$D6
	.DC.B	$3F,$B6
	.DC.B	$3E,$B4
	.DC.B	$FA,$F6		;ROCK2M
	.DC.B	$FA,$FD
	.DC.B	$F9,$FE
	.DC.B	$FD,$7E
	.DC.B	$F9,$96
	.DC.B	$FE,$56
	.DC.B	$F9,$56
	.DC.B	$F9,$56
	.DC.B	$F9,$56		;ROCK3M
	.DC.B	$F9,$5A
	.DC.B	$F9,$74
	.DC.B	$FD,$5C
	.DC.B	$F9,$54
	.DC.B	$F9,$76
	.DC.B	$F9,$7F
	.DC.B	$F9,$5E
	.DC.B	$02,$00		;ROCKEM
	.DC.B	$09,$80
	.DC.B	$06,$C8
	.DC.B	$11,$10
	.DC.B	$00,$00
	.DC.B	$0A,$80		;SHIP
	.DC.B	$2A,$80
	.DC.B	$3A,$80
	.DC.B	$0E,$B0
	.DC.B	$0A,$B0
	.DC.B	$3A,$A8
	.DC.B	$3A,$B0
	.DC.B	$0A,$80
	.DC.B	$0A,$80
	.DC.B	$0A,$80
	.DC.B	$3A,$B0
	.DC.B	$AA,$B0
	.DC.B	$3A,$80
	.DC.B	$3A,$C0
	.DC.B	$0A,$B0
	.DC.B	$0A,$A0
	.DC.B	$02,$54	;SHIPE
	.DC.B	$09,$60
	.DC.B	$06,$10
	.DC.B	$0A,$12
	.DC.B	$00,$20
	.DC.B	$00,$80
	.DC.B	$0,0,0,0,0,0,0,0	;UFOL
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	ORG     GRAPHICS+$900	;10
********************************************************************************
	.DC.B	$FA,$55,$50	;ROCK1L
	.DC.B	$FF,$D5,$70
	.DC.B	$F7,$65,$70
	.DC.B	$FE,$65,$70
	.DC.B	$FD,$5D,$50
	.DC.B	$FA,$55,$50
	.DC.B	$FA,$95,$50
	.DC.B	$FA,$55,$50
	.DC.B	$F9,$65,$50
	.DC.B	$FA,$55,$50
	.DC.B	$FA,$D5,$50
	.DC.B	$F9,$55,$50
	.DC.B	$FE,$7D,$50	;ROCK2L
	.DC.B	$FE,$5F,$70
	.DC.B	$FB,$57,$50
	.DC.B	$FA,$D5,$50
	.DC.B	$FA,$9D,$60
	.DC.B	$FA,$55,$D0
	.DC.B	$FA,$59,$50
	.DC.B	$FA,$95,$50
	.DC.B	$FA,$FD,$50
	.DC.B	$FA,$5D,$50
	.DC.B	$FA,$57,$50
	.DC.B	$FA,$55,$50
	.DC.B	$FF,$D5,$50	;ROCK3L
	.DC.B	$FB,$95,$50
	.DC.B	$EE,$59,$50
	.DC.B	$F9,$59,$50
	.DC.B	$F9,$55,$50
	.DC.B	$F9,$55,$90
	.DC.B	$F9,$55,$50
	.DC.B	$F9,$55,$70
	.DC.B	$F9,$56,$D0
	.DC.B	$F9,$56,$D0
	.DC.B	$F9,$6F,$50
	.DC.B	$F9,$B6,$50
	.DC.B	$00,$44,$00	;ROCKEL
	.DC.B	$00,$E5,$00
	.DC.B	$02,$46,$40
	.DC.B	$00,$62,$C0
	.DC.B	$00,$10,$00
	.DC.B	$3E,$B4		;ROCK1M
	.DC.B	$FE,$5C
	.DC.B	$FE,$57
	.DC.B	$FF,$94
	.DC.B	$3D,$D6
	.DC.B	$3E,$75
	.DC.B	$3E,$9E
	.DC.B	$3E,$94
	.DC.B	$E9,$55		;ROCK2M
	.DC.B	$E9,$7E
	.DC.B	$E6,$7C
	.DC.B	$FD,$7C
	.DC.B	$EB,$5C
	.DC.B	$ED,$96
	.DC.B	$FB,$55
	.DC.B	$E9,$56
	.DC.B	$E9,$56		;ROCK3M
	.DC.B	$E5,$DE
	.DC.B	$F9,$7C
	.DC.B	$EA,$5C
	.DC.B	$E9,$D5
	.DC.B	$E9,$FF
	.DC.B	$E9,$76
	.DC.B	$EA,$56
	.DC.B	$02,$40		;ROCKEM
	.DC.B	$01,$60
	.DC.B	$15,$A0
	.DC.B	$88,$80
	.DC.B	$00,$40
	.DC.B	$0A,$80		;SHIP
	.DC.B	$3A,$80
	.DC.B	$AA,$80
	.DC.B	$0A,$AC
	.DC.B	$4A,$A8
	.DC.B	$0A,$AC
	.DC.B	$AA,$80
	.DC.B	$3A,$80
	.DC.B	$0A,$80
	.DC.B	$0A,$B0
	.DC.B	$0A,$A8
	.DC.B	$EA,$80
	.DC.B	$AA,$84
	.DC.B	$EA,$80
	.DC.B	$0A,$A8
	.DC.B	$0A,$B0
	.DC.B	$00,$54		;SHIPE
	.DC.B	$01,$50
	.DC.B	$01,$98
	.DC.B	$04,$60
	.DC.B	$02,$08
	.DC.B	$00,$00
	.DC.B	$0A,$A0		;UFOL
	.DC.B	$0A,$A0
	.DC.B	$0A,$A0
	.DC.B	$0A,$A0
	.DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	ORG     GRAPHICS+$A00	;11
********************************************************************************
	.DC.B	$FE,$95,$40	;ROCK1L
	.DC.B	$FF,$55,$70
	.DC.B	$FF,$55,$F0
	.DC.B	$FE,$55,$F0
	.DC.B	$FE,$95,$D0
	.DC.B	$FD,$55,$70
	.DC.B	$FE,$55,$50
	.DC.B	$FE,$55,$50
	.DC.B	$FE,$55,$70
	.DC.B	$FD,$55,$50
	.DC.B	$FD,$55,$50
	.DC.B	$FF,$55,$50
	.DC.B	$FE,$95,$70	;ROCK2L
	.DC.B	$FE,$9F,$F0
	.DC.B	$FE,$57,$D0
	.DC.B	$FE,$D5,$D0
	.DC.B	$FA,$7D,$50
	.DC.B	$FE,$55,$D0
	.DC.B	$FE,$55,$70
	.DC.B	$FA,$55,$90
	.DC.B	$FE,$D5,$50
	.DC.B	$FA,$BF,$50
	.DC.B	$FD,$97,$50
	.DC.B	$FE,$95,$D0
	.DC.B	$FF,$55,$60	;ROCK3L
	.DC.B	$FB,$56,$60
	.DC.B	$ED,$55,$60
	.DC.B	$B9,$55,$60
	.DC.B	$F9,$55,$50
	.DC.B	$F9,$55,$50
	.DC.B	$F9,$55,$50
	.DC.B	$F9,$55,$B0
	.DC.B	$F9,$57,$D0
	.DC.B	$F9,$5B,$50
	.DC.B	$FA,$6D,$50
	.DC.B	$FE,$55,$50
	.DC.B	$01,$08,$00	;ROCKEL
	.DC.B	$02,$44,$04
	.DC.B	$01,$14,$10
	.DC.B	$81,$04,$10
	.DC.B	$81,$80,$08
	.DC.B	$FE,$56		;ROCK1M
	.DC.B	$FD,$54
	.DC.B	$FD,$55
	.DC.B	$FE,$55
	.DC.B	$FB,$D5
	.DC.B	$F9,$F5
	.DC.B	$FA,$7D
	.DC.B	$F9,$5B
	.DC.B	$E9,$55		;ROCK2M
	.DC.B	$E5,$56
	.DC.B	$A9,$5C
	.DC.B	$FD,$5C
	.DC.B	$EF,$5C
	.DC.B	$EA,$D6
	.DC.B	$EF,$55
	.DC.B	$ED,$D6
	.DC.B	$E7,$76		;ROCK3M
	.DC.B	$E5,$FC
	.DC.B	$E9,$7C
	.DC.B	$E5,$54
	.DC.B	$EB,$FE
	.DC.B	$E5,$D5
	.DC.B	$E9,$56
	.DC.B	$E9,$56
	.DC.B	$01,$80		;ROCKEM
	.DC.B	$0B,$40
	.DC.B	$02,$40
	.DC.B	$31,$18
	.DC.B	$00,$01
	.DC.B	$0A,$80		;SHIP
	.DC.B	$0A,$80
	.DC.B	$3A,$B0
	.DC.B	$3A,$A8
	.DC.B	$0A,$B0
	.DC.B	$0E,$B0
	.DC.B	$3A,$80
	.DC.B	$2A,$80
	.DC.B	$0A,$80
	.DC.B	$0A,$A0
	.DC.B	$0A,$B0
	.DC.B	$3A,$C0
	.DC.B	$3A,$80
	.DC.B	$AA,$B0
	.DC.B	$3A,$B0
	.DC.B	$0A,$80
	.DC.B	$00,$64		;SHIPE
	.DC.B	$03,$42
	.DC.B	$02,$50
	.DC.B	$00,$10
	.DC.B	$00,$80
	.DC.B	$00,$00
	.DC.B	$3A,$A8		;UFOL
	.DC.B	$2F,$A8
	.DC.B	$2A,$F8
	.DC.B	$2A,$BC
	.DC.B	$00		;UFOS
	.DC.B	$00
	.DC.B	$00
	.DC.B	$00
	.DC.B	$3C		;ROCK1S
	.DC.B	$3C
	.DC.B	$3C
	.DC.B	$3C
	.DC.B	$3C		;ROCK2S
	.DC.B	$3C
	.DC.B	$3C
	.DC.B	$3C
	.DC.B	$3C		;ROCK3S
	.DC.B	$3C
	.DC.B	$3C
	.DC.B	$3C
	.DC.B	$00		;ROCKES
	.DC.B	$08
	.DC.B	$08
	.DC.B	$08
	.DC.B	$08
	.DC.B	$00		;SHOT
	.DC.B	$00

	ORG     GRAPHICS+$B00	;12
********************************************************************************
	.DC.B	$3E,$55,$40	;ROCK1L
	.DC.B	$3E,$95,$40
	.DC.B	$3D,$65,$40
	.DC.B	$3E,$95,$C0
	.DC.B	$3E,$57,$C0
	.DC.B	$3E,$57,$40
	.DC.B	$3E,$D5,$40
	.DC.B	$3D,$A5,$40
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$65,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$65,$40	;ROCK2L
	.DC.B	$3E,$57,$C0
	.DC.B	$3E,$97,$C0
	.DC.B	$3E,$D5,$C0
	.DC.B	$3E,$B5,$40
	.DC.B	$3E,$55,$C0
	.DC.B	$3E,$95,$40
	.DC.B	$3D,$55,$40
	.DC.B	$3D,$5D,$40
	.DC.B	$3E,$75,$40
	.DC.B	$3A,$5F,$C0
	.DC.B	$3E,$55,$C0
	.DC.B	$3A,$95,$40	;ROCK3L
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$56,$40
	.DC.B	$2E,$55,$40
	.DC.B	$3A,$55,$D0
	.DC.B	$3A,$55,$40
	.DC.B	$3A,$55,$C0
	.DC.B	$3A,$55,$C0
	.DC.B	$3A,$5B,$40
	.DC.B	$3A,$55,$40
	.DC.B	$3E,$55,$80
	.DC.B	$3E,$55,$40
	.DC.B	$00,$08,$00	;ROCKEL
	.DC.B	$08,$08,$00
	.DC.B	$04,$04,$04
	.DC.B	$06,$00,$42
	.DC.B	$10,$08,$00
	.DC.B	$FB,$55		;ROCK1M
	.DC.B	$3A,$D5
	.DC.B	$39,$75
	.DC.B	$3E,$5D
	.DC.B	$EA,$54
	.DC.B	$F9,$54
	.DC.B	$FA,$54
	.DC.B	$F9,$55
	.DC.B	$EB,$75		;ROCK2M
	.DC.B	$E9,$56
	.DC.B	$E5,$54
	.DC.B	$EA,$54
	.DC.B	$EF,$58
	.DC.B	$EB,$D4
	.DC.B	$E5,$74
	.DC.B	$EB,$D6
	.DC.B	$EB,$FE		;ROCK3M
	.DC.B	$E5,$FC
	.DC.B	$E5,$5D
	.DC.B	$ED,$56
	.DC.B	$EB,$56
	.DC.B	$E9,$56
	.DC.B	$E9,$56
	.DC.B	$ED,$D6
	.DC.B	$00,$80		;ROCKEM
	.DC.B	$06,$50
	.DC.B	$05,$4C
	.DC.B	$01,$43
	.DC.B	$81,$30
	.DC.B	$0E,$C0		;SHIP
	.DC.B	$02,$80
	.DC.B	$02,$A0
	.DC.B	$2A,$C0
	.DC.B	$2A,$00
	.DC.B	$4A,$80
	.DC.B	$0A,$C0
	.DC.B	$EA,$80
	.DC.B	$3A,$B0
	.DC.B	$0A,$AC
	.DC.B	$0E,$80
	.DC.B	$0A,$84
	.DC.B	$02,$A0
	.DC.B	$0E,$A0
	.DC.B	$2A,$00
	.DC.B	$0A,$00
	.DC.B	$06,$14		;SHIPE
	.DC.B	$05,$D0
	.DC.B	$24,$00
	.DC.B	$00,$80
	.DC.B	$00,$00
	.DC.B	$80,$00
	.DC.B	$AA,$AA		;UFOL
	.DC.B	$AA,$AA
	.DC.B	$AA,$AA
	.DC.B	$AA,$AA
	.DC.B	$38		;UFOS
	.DC.B	$3C
	.DC.B	$2C
	.DC.B	$28
	.DC.B	$38		;ROCK1S
	.DC.B	$3B
	.DC.B	$38
	.DC.B	$F8
	.DC.B	$3B		;ROCK2S
	.DC.B	$FB
	.DC.B	$FB
	.DC.B	$FB
	.DC.B	$FB		;ROCK3S
	.DC.B	$F7
	.DC.B	$FF
	.DC.B	$F7
	.DC.B	$08		;ROCKES
	.DC.B	$10
	.DC.B	$10
	.DC.B	$00
	.DC.B	$00
	.DC.B	$00		;SHOT
	.DC.B	$00

	ORG     GRAPHICS+$C00	;13
********************************************************************************
	.DC.B	$3E,$A5,$40	;ROCK1L
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$97,$40
	.DC.B	$3E,$5F,$40
	.DC.B	$3E,$5F,$40
	.DC.B	$3F,$55,$40
	.DC.B	$3F,$95,$40
	.DC.B	$3E,$65,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$67,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$95,$00	;ROCK2L
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$55,$C0
	.DC.B	$3F,$65,$C0
	.DC.B	$3E,$B9,$40
	.DC.B	$3E,$A7,$C0
	.DC.B	$3E,$95,$40
	.DC.B	$3E,$A5,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$97,$40
	.DC.B	$3E,$5D,$40
	.DC.B	$3E,$65,$C0
	.DC.B	$3E,$55,$80	;ROCK3L
	.DC.B	$3E,$56,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$55,$40
	.DC.B	$2E,$55,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$55,$C0
	.DC.B	$3E,$56,$C0
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$55,$40
	.DC.B	$3E,$55,$80
	.DC.B	$3E,$95,$80
	.DC.B	$00,$08,$00	;ROCKEL
	.DC.B	$00,$08,$00
	.DC.B	$20,$04,$C0
	.DC.B	$00,$00,$00
	.DC.B	$00,$00,$20
	.DC.B	$3A,$96		;ROCK1M
	.DC.B	$39,$64
	.DC.B	$39,$54
	.DC.B	$3A,$54
	.DC.B	$39,$54
	.DC.B	$39,$54
	.DC.B	$39,$54
	.DC.B	$3A,$54
	.DC.B	$F5,$F6		;ROCK2M
	.DC.B	$F5,$DE
	.DC.B	$F5,$56
	.DC.B	$F9,$54
	.DC.B	$FD,$58
	.DC.B	$FB,$D4
	.DC.B	$F9,$F4
	.DC.B	$F9,$5E
	.DC.B	$F7,$FE		;ROCK3M
	.DC.B	$F9,$76
	.DC.B	$F9,$55
	.DC.B	$FF,$D6
	.DC.B	$F9,$56
	.DC.B	$F9,$56
	.DC.B	$FB,$56
	.DC.B	$FF,$F6
	.DC.B	$00,$00		;ROCKEM
	.DC.B	$01,$00
	.DC.B	$04,$50
	.DC.B	$09,$10
	.DC.B	$00,$00
	.DC.B	$02,$00		;SHIP
	.DC.B	$02,$80
	.DC.B	$00,$E0
	.DC.B	$00,$00
	.DC.B	$2C,$00
	.DC.B	$0A,$00
	.DC.B	$0E,$00
	.DC.B	$02,$80
	.DC.B	$2F,$E0
	.DC.B	$0A,$00
	.DC.B	$02,$C0
	.DC.B	$02,$80
	.DC.B	$00,$E0
	.DC.B	$00,$00
	.DC.B	$2C,$00
	.DC.B	$0A,$00
	.DC.B	$05,$10		;SHIPE
	.DC.B	$25,$04
	.DC.B	$1A,$22
	.DC.B	$28,$00
	.DC.B	$88,$20
	.DC.B	$20,$00
	.DC.B	$39,$54		;UFOL
	.DC.B	$39,$54
	.DC.B	$39,$54
	.DC.B	$39,$54
	.DC.B	$AA		;UFOS
	.DC.B	$AA
	.DC.B	$AA
	.DC.B	$AA
	.DC.B	$E5		;ROCK1S
	.DC.B	$35
	.DC.B	$F5
	.DC.B	$EC
	.DC.B	$E5		;ROCK2S
	.DC.B	$F5
	.DC.B	$DD
	.DC.B	$E5
	.DC.B	$D4		;ROCK3S
	.DC.B	$15
	.DC.B	$D6
	.DC.B	$D5
	.DC.B	$24		;ROCKES
	.DC.B	$B6
	.DC.B	$02
	.DC.B	$0C
	.DC.B	$0C
	.DC.B	$00		;SHOT
	.DC.B	$00

	ORG     GRAPHICS+$D00	;14
********************************************************************************
	.DC.B	$0E,$95,$00	;ROCK1L
	.DC.B	$0E,$A5,$00
	.DC.B	$0E,$65,$00
	.DC.B	$0E,$95,$00
	.DC.B	$0E,$9D,$00
	.DC.B	$0E,$BC,$00
	.DC.B	$0E,$BD,$00
	.DC.B	$0E,$96,$00
	.DC.B	$0E,$A5,$00
	.DC.B	$0E,$95,$00
	.DC.B	$0D,$97,$00
	.DC.B	$0E,$9D,$00
	.DC.B	$0E,$95,$00	;ROCK2L
	.DC.B	$0E,$95,$00
	.DC.B	$0E,$95,$00
	.DC.B	$0E,$55,$00
	.DC.B	$0F,$55,$00
	.DC.B	$0E,$A7,$00
	.DC.B	$0E,$95,$00
	.DC.B	$0E,$55,$00
	.DC.B	$0E,$55,$00
	.DC.B	$0E,$95,$00
	.DC.B	$0E,$95,$00
	.DC.B	$0E,$97,$00
	.DC.B	$0E,$F5,$00	;ROCK3L
	.DC.B	$0E,$E5,$00
	.DC.B	$0E,$F5,$00
	.DC.B	$0E,$F5,$00
	.DC.B	$0E,$F5,$00
	.DC.B	$0E,$F7,$00
	.DC.B	$0E,$F7,$00
	.DC.B	$0E,$F5,$00
	.DC.B	$0E,$F5,$00
	.DC.B	$0E,$F5,$00
	.DC.B	$0F,$F5,$00
	.DC.B	$0F,$F5,$00
	.DC.B	$00,$00,$00	;ROCKEL
	.DC.B	$00,$08,$00
	.DC.B	$00,$40,$00
	.DC.B	$08,$10,$00
	.DC.B	$00,$10,$00
	.DC.B	$39,$54	;ROCK1M
	.DC.B	$39,$54
	.DC.B	$0E,$54
	.DC.B	$3A,$94
	.DC.B	$3A,$50
	.DC.B	$3E,$90
	.DC.B	$3D,$60
	.DC.B	$3E,$58
	.DC.B	$39,$54	;ROCK2M
	.DC.B	$39,$7C
	.DC.B	$39,$74
	.DC.B	$39,$58
	.DC.B	$39,$58
	.DC.B	$3B,$58
	.DC.B	$39,$F8
	.DC.B	$39,$5C
	.DC.B	$39,$D4	;ROCK3M
	.DC.B	$39,$54
	.DC.B	$3F,$54
	.DC.B	$39,$54
	.DC.B	$39,$54
	.DC.B	$3E,$54
	.DC.B	$3F,$D8
	.DC.B	$3F,$F8
	.DC.B	$00,$00	;ROCKEM
	.DC.B	$00,$00
	.DC.B	$10,$80
	.DC.B	$04,$08
	.DC.B	$00,$00
	.DC.B	$02,$00	;SHIP
	.DC.B	$00,$80
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$08,$00
	.DC.B	$42,$00
	.DC.B	$03,$80
	.DC.B	$20,$20
	.DC.B	$0B,$00
	.DC.B	$02,$04
	.DC.B	$00,$80
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$08,$00
	.DC.B	$06,$00	;SHIPE
	.DC.B	$17,$00
	.DC.B	$9A,$00
	.DC.B	$A8,$20
	.DC.B	$E0,$00
	.DC.B	$00,$08
	.DC.B	$0E,$50	;UFOL
	.DC.B	$0E,$50
	.DC.B	$0E,$50
	.DC.B	$0E,$50
	.DC.B	$75		;UFOS
	.DC.B	$75
	.DC.B	$75
	.DC.B	$75
	.DC.B	$D5		;ROCK1S
	.DC.B	$F5
	.DC.B	$DD
	.DC.B	$E7
	.DC.B	$F5		;ROCK2S
	.DC.B	$D5
	.DC.B	$DD
	.DC.B	$D7
	.DC.B	$D4		;ROCK3S
	.DC.B	$D5
	.DC.B	$D5
	.DC.B	$DD
	.DC.B	$18		;ROCKES
	.DC.B	$04
	.DC.B	$88
	.DC.B	$02
	.DC.B	$02
	.DC.B	$00		;SHOT
	.DC.B	$00

	ORG     GRAPHICS+$E00	;15
********************************************************************************
	.DC.B	$0F,$A9,$00	;ROCK1L
	.DC.B	$0F,$95,$00
	.DC.B	$0F,$95,$00
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$B5,$00
	.DC.B	$0F,$F5,$00
	.DC.B	$0F,$F5,$00
	.DC.B	$0F,$E9,$00
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$AD,$00
	.DC.B	$0F,$A5,$00	;ROCK2L
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$95,$00
	.DC.B	$0F,$A5,$00
	.DC.B	$0F,$FE,$00
	.DC.B	$0F,$E5,$00
	.DC.B	$0F,$E5,$00
	.DC.B	$0F,$D5,$00
	.DC.B	$0F,$D5,$00
	.DC.B	$0F,$D5,$00
	.DC.B	$0F,$D5,$00
	.DC.B	$0F,$96,$00	;ROCK3L
	.DC.B	$0F,$96,$00
	.DC.B	$0F,$96,$00
	.DC.B	$0F,$96,$00
	.DC.B	$0F,$96,$00
	.DC.B	$0F,$96,$00
	.DC.B	$0F,$E6,$00
	.DC.B	$0F,$D6,$00
	.DC.B	$0F,$D6,$00
	.DC.B	$0F,$D6,$00
	.DC.B	$0F,$96,$00
	.DC.B	$0F,$D6,$00
	.DC.B	$00,$00,$00	;ROCKEL
	.DC.B	$00,$00,$00
	.DC.B	$00,$08,$00
	.DC.B	$00,$04,$30
	.DC.B	$0C,$00,$00
	.DC.B	$0A,$50	;ROCK1M
	.DC.B	$0A,$50
	.DC.B	$0D,$50
	.DC.B	$0D,$50
	.DC.B	$0E,$50
	.DC.B	$0E,$50
	.DC.B	$0F,$50
	.DC.B	$0D,$50
	.DC.B	$3A,$5C	;ROCK2M
	.DC.B	$3A,$54
	.DC.B	$3A,$5C
	.DC.B	$3A,$6C
	.DC.B	$3A,$6C
	.DC.B	$39,$5C
	.DC.B	$3A,$E8
	.DC.B	$3A,$7C
	.DC.B	$3A,$58	;ROCK3M
	.DC.B	$3E,$58
	.DC.B	$3A,$58
	.DC.B	$3A,$58
	.DC.B	$0A,$58
	.DC.B	$0F,$5C
	.DC.B	$0F,$DB
	.DC.B	$3B,$58
	.DC.B	$00,$00	;ROCKEM
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$40,$80
	.DC.B	$20,$03
	.DC.B	$02,$00	;SHIP
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$02,$00
	.DC.B	$04,$80
	.DC.B	$01,$00
	.DC.B	$08,$40
	.DC.B	$02,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$00,$00
	.DC.B	$07,$00	;SHIPE
	.DC.B	$20,$00
	.DC.B	$00,$00
	.DC.B	$24,$80
	.DC.B	$28,$08
	.DC.B	$00,$00
	.DC.B	$02,$40	;UFOL
	.DC.B	$02,$40
	.DC.B	$02,$40
	.DC.B	$02,$40
	.DC.B	$3C		;UFOS
	.DC.B	$28
	.DC.B	$28
	.DC.B	$28
	.DC.B	$E6		;ROCK1S
	.DC.B	$E4
	.DC.B	$D6
	.DC.B	$E5
	.DC.B	$D6		;ROCK2S
	.DC.B	$DD
	.DC.B	$E5
	.DC.B	$E4
	.DC.B	$D5		;ROCK3S
	.DC.B	$15
	.DC.B	$35
	.DC.B	$DD
	.DC.B	$20		;ROCKES
	.DC.B	$1E
	.DC.B	$02
	.DC.B	$00
	.DC.B	$00
	.DC.B	$00		;SHOT
STAR2:
	.DC.B	$0C

	.ORG     GRAPHICS+$F00	;16
********************************************************************************
ROCK1L1:
	.DC.B	$03,$F8,$00
ROCK1L2:
	.DC.B	$03,$E8,$00
ROCK1L3:
	.DC.B	$03,$E8,$00
ROCK1L4:
	.DC.B	$03,$E8,$00
ROCK1L5:
	.DC.B	$03,$E8,$00
ROCK1L6:
	.DC.B	$03,$E8,$00
ROCK1L7:
	.DC.B	$03,$D8,$00
ROCK1L8:
	.DC.B	$03,$E8,$00
ROCK1L9:
	.DC.B	$03,$E8,$00
ROCK1L10:
	.DC.B	$03,$E8,$00
ROCK1L11:
	.DC.B	$03,$E8,$00
ROCK1L12:
	.DC.B	$03,$E8,$00
ROCK2L1:
	.DC.B	$03,$F8,$00
ROCK2L2:
	.DC.B	$03,$E8,$00
ROCK2L3:
	.DC.B	$03,$E8,$00
ROCK2L4:
	.DC.B	$03,$F8,$00
ROCK2L5:
	.DC.B	$03,$F8,$00
ROCK2L6:
	.DC.B	$03,$F8,$00
ROCK2L7:
	.DC.B	$03,$FC,$00
ROCK2L8:
	.DC.B	$03,$FC,$00
ROCK2L9:
	.DC.B	$03,$F8,$00
ROCK2L10:
	.DC.B	$03,$F8,$00
ROCK2L11:
	.DC.B	$03,$F8,$00
ROCK2L12:
	.DC.B	$03,$F8,$00
ROCK3L1:
	.DC.B	$00,$E0,$00
ROCK3L2:
	.DC.B	$00,$E0,$00
ROCK3L3:
	.DC.B	$00,$E0,$00
ROCK3L4:
	.DC.B	$00,$E0,$00
ROCK3L5:
	.DC.B	$00,$E0,$00
ROCK3L6:
	.DC.B	$00,$E0,$00
ROCK3L7:
	.DC.B	$00,$E0,$00
ROCK3L8:
	.DC.B	$00,$E0,$00
ROCK3L9:
	.DC.B	$00,$E0,$00
ROCK3L10:
	.DC.B	$00,$E0,$00
ROCK3L11:
	.DC.B	$00,$E0,$00
ROCK3L12:
	.DC.B	$00,$E0,$00
ROCKEL1:
	.DC.B	$00,$00,$00
ROCKEL2:
	.DC.B	$00,$00,$00
ROCKEL3:
	.DC.B	$00,$00,$00
ROCKEL4:
	.DC.B	$00,$04,$00
ROCKEL5:
	.DC.B	$00,$20,$00
ROCK1M1:
	.DC.B	$02,$80
ROCK1M2:
	.DC.B	$00,$80
ROCK1M3:
	.DC.B	$00,$80
ROCK1M4:
	.DC.B	$02,$80
ROCK1M5:
	.DC.B	$00,$80
ROCK1M6:
	.DC.B	$02,$00
ROCK1M7:
	.DC.B	$02,$80
ROCK1M8:
	.DC.B	$03,$40
ROCK2M1:
	.DC.B	$0E,$B0
ROCK2M2:
	.DC.B	$0E,$A0
ROCK2M3:
	.DC.B	$0D,$A0
ROCK2M4:
	.DC.B	$0E,$A0
ROCK2M5:
	.DC.B	$0E,$A0
ROCK2M6:
	.DC.B	$0E,$A0
ROCK2M7:
	.DC.B	$0E,$A0
ROCK2M8:
	.DC.B	$0E,$B0
ROCK3M1:
	.DC.B	$0E,$A0
ROCK3M2:
	.DC.B	$0E,$A0
ROCK3M3:
	.DC.B	$0E,$A0
ROCK3M4:
	.DC.B	$0E,$A0
ROCK3M5:
	.DC.B	$02,$A0
ROCK3M6:
	.DC.B	$00,$A0
ROCK3M7:
	.DC.B	$02,$A0
ROCK3M8:
	.DC.B	$0E,$A0
ROCKEM1:
	.DC.B	$00,$00
ROCKEM2:
	.DC.B	$00,$00
ROCKEM3:
	.DC.B	$00,$00
ROCKEM4:
	.DC.B	$00,$00
ROCKEM5:
	.DC.B	$42,$00
SHIP1:
	.DC.B	$00,$00
SHIP2:
	.DC.B	$00,$00
SHIP3:
	.DC.B	$00,$00
SHIP4:
	.DC.B	$00,$00
SHIP5:
	.DC.B	$00,$00
SHIP6:
	.DC.B	$00,$00
SHIP7:
	.DC.B	$00,$00
SHIP8:
	.DC.B	$04,$00
SHIP9:
	.DC.B	$01,$00
SHIP10:
	.DC.B	$00,$40
SHIP11:
	.DC.B	$00,$00
SHIP12:
	.DC.B	$00,$00
SHIP13:
	.DC.B	$00,$00
SHIP14:
	.DC.B	$00,$00
SHIP15:
	.DC.B	$00,$00
SHIP16:
	.DC.B	$00,$00
SHIPE1:
	.DC.B	$04,$00
SHIPE2:
	.DC.B	$00,$00
SHIPE3:
	.DC.B	$00,$00
SHIPE4:
	.DC.B	$00,$00
SHIPE5:
	.DC.B	$00,$20
SHIPE6:
	.DC.B	$20,$00
UFOL1:
	.DC.B	$02,$40
UFOL2:
	.DC.B	$02,$40
UFOL3:
	.DC.B	$02,$40
UFOL4:
	.DC.B	$02,$40
UFOS1:
	.DC.B	$34
UFOS2:
	.DC.B	$34
UFOS3:
	.DC.B	$34
UFOS4:
	.DC.B	$34
ROCK1S1:
	.DC.B	$34
ROCK1S2:
	.DC.B	$34
ROCK1S3:
	.DC.B	$34
ROCK1S4:
	.DC.B	$34
ROCK2S1:
	.DC.B	$34
ROCK2S2:
	.DC.B	$38
ROCK2S3:
	.DC.B	$34
ROCK2S4:
	.DC.B	$38
ROCK3S1:
	.DC.B	$34
ROCK3S2:
	.DC.B	$04
ROCK3S3:
	.DC.B	$04
ROCK3S4:
	.DC.B	$34
ROCKES1:
	.DC.B	$00
ROCKES2:
	.DC.B	$20
ROCKES3:
	.DC.B	$20
ROCKES4:
	.DC.B	$20
ROCKES5:
	.DC.B	$20
SHOT1:
	.DC.B	$40
	.DC.B	$00
