*		SPHINX--SGRAPHA.S
* THE GRAPHICS ARE ORGANIZED AS FOLLOWS:
* 8000 - 8FFF ARE ALL CHARACTERS (16 PAGES)
* A000 - AFFF ARE ALL GRAPHICS (16 PAGES)	INCLUDING SCROLLING STAMPS
* C000 - CFFF ARE ALL BIRD GRAPHICS (16 PAGES)
*MIKE, ARE THERE ANY GRAPHICS WE DON'T NEED IN HERE

;		ZERODEF

		ORG	$A000					; LINE 16
BIGPYR0:	.dc.b	$00,$03,$40,$00				;4;BIGPYR0
BIGPYR1:	.dc.b	$BB,$66					;6;BIGPYR1
OPEPYR0:	.dc.b	$00,$00,$00,$02,$94,$00,$00,$00,$00	;OPEPYR0
OPEPYR1:	.dc.b	$3A,$AD,$DD,$DE,$97,$B7,$77,$55,$80	;24;OPEPYR1
OPEPYR2:	.dc.b	$00,$2A,$82,$94,$15,$40,$00		;31;OPEPYR2
OBELISK0:	.dc.b	$02,$80					;OBELISK0
OBELISK1:	.dc.b	$EE,$99					;OBELISK1
OBELISK2:	.dc.b	$EE,$99				;37	;OBELISK2
GLIDER:		.dc.b	$04,$00,$00				;GLIDER
GLSHAD:		.dc.b	$00,$00,$00				;GLSHAD
UNFOLD0:	.dc.b	$00,$00,$00				;UNFOLD0
UNFOLD1:	.dc.b	$00,$00,$00				;UNFOLD1
UNFOLD2:	.dc.b	$00,$00,$00				;UNFOLD2
GLIDEXP0:	.dc.b	$04,$00,$00				;GLIDEXP0
GLIDEXP1:	.dc.b	$2A,$80,$00				;GLIDEXP1
GENERXP0:	.dc.b	$3A,$BE,$C0				;GENERXP0
GENERXP1:	.dc.b	$30,$02,$C0				;GENERXP1
GENERXP2:	.dc.b	$00,$02,$30				;67;GENERXP2
SPHINXL1:	.dc.b	$00,$00,$00,$00,$FC,$00,$00,$00,$00	;SPHINXL1
SPHINXL2:	.dc.b	$FB,$9F,$00,$00,$00,$BF,$FF,$BE,$B0	;SPHINXL2
SPHINXL3:	.dc.b	$00,$00,$00,$00,$00,$EE,$EF,$F9,$FC	;SPHINXL3
SPHINXL4:	.dc.b	$00,$00,$FF,$FE,$FB,$FA,$E5,$D9,$54	;103;SPHINXL4
SPHINXR2:	.dc.b	$00,$00,$00,$00,$00,$00			;SPHINXR2
SPHINXR3:	.dc.b	$AF,$FF,$BF,$FF,$FB,$FC			;SPHINXR3
SPHINXR4:	.dc.b	$9F,$AB,$FA,$B5,$A6,$60		;121	;SPHINXR4
SPFACE1L:	.dc.b	$00,$00,$00				;SPFACE1L
SPFACE2L:	.dc.b	$00,$00,$00				;SPFACE2L
SPFACE3L:	.dc.b	$00,$00,$00				;SPFACE3L
SPFACE4L:	.dc.b	$00,$00,$00				;SPFACE4L
SPFACE5L:	.dc.b	$00,$00,$00				;SPFACE5L
SPFACE1H:	.dc.b	$FF,$FA,$AA				;SPFACE1H
SPFACE2H:	.dc.b	$FF,$EA,$AB				;SPFACE2H
SPFACE3H:	.dc.b	$FF,$AA,$AA				;SPFACE3H
SPFACE4H:	.dc.b	$FF,$FA,$AA				;SPFACE4H
SPFACE5H:	.dc.b	$FF,$FA,$AE				;SPFACE5H
SCRBEXP1:	.dc.b	$00,$00,$00				;SCRBEXP1
SCRBEXP2:	.dc.b	$00,$00,$00				;SCRBEXP2
NEUFY1:		.dc.b	$00,$00,$00				;NEUFY1
NEUFY2:		.dc.b	$00,$00,$00				;NEUFY2
NEUFYXPL:	.dc.b	$14,$00,$00				;NEUFY3
SCARAB4:	.dc.b	$00,$00,$00				;SCARAB4
SCARAB5:	.dc.b	$00,$00,$00			;172	;SCARAB5
MINISPH0:	.dc.b	$00,$03,$F0,$00,$00,$00,$00,$00		;MINISPH0
MINISPH1:	.dc.b	$01,$DA,$AE,$FF,$EF,$5A,$FB,$E4	;188	;MINISPH1
UWEEXPL1:	.dc.b	$00,$55,$00,$00				;UWEEXPL1
UWEEXPL2:	.dc.b	$03,$EF,$00,$00			;196	;UWEEXPL2
CRATERL:	.dc.b	$00,$00,$00				;CRATERL
CRATERH:	.dc.b	$FF,$AF,$FA			;202	;CRATERH
CANEH:		.dc.b	$00,$00				;204	;CANEH
EYEH:		.dc.b	$00,$00,$00				;EYEH
AHNKH:		.dc.b	$00,$00,$00				;AHNKH
BOWLH:		.dc.b	$00,$00,$00				;BOWLH
MANWSTAF:	.dc.b	$00,$00,$00			;216	;MANWSTAF
FEATHER:	.dc.b	$00,$00					;FEATHER
BIRDH:		.dc.b	$00,$00				;220	;BIRDH
SUNOWTRH:	.dc.b	$00,$00,$00			;223	;SUNOWTRH
PING1:		.dc.b	$00,$00,$00,$00			;227	;PING1
PING2:		.dc.b	$00,$00,$00			;230	;PING2
PINGEXPL:	.dc.b	$00,$00,$00,$00			;234	;PINGEXPL
MINIEXP1:	.dc.b	$00,$00,$00,$00				;MINIEXP1
MINIEXP2:	.dc.b	$00,$41,$42,$00				;MINIEXP2
MINIEXP3:	.dc.b	$EA,$F6,$FA,$FE			;246	;MINIEXP3
SPHXEXPL:	.dc.b	$00,$00					;SPHXEXPL
SPHXFLSH:	.dc.b	$00,$00					;SPHXFLSH
SPHXGLMR:	.dc.b	$00,$00					;SPHXGLMR
BLANK:		.dc.b	$00,$00					;BLANK

ENDOFA:
		ORG	$A100					; LINE 15
		.dc.b	$00,$0E,$90,$00				;BIGPYR0
		.dc.b	$2E,$98					;BIGPYR1
		.dc.b	$00,$00,$00,$0A,$E5,$00,$00,$00,$00	;OPEPYR0
		.dc.b	$2A,$BB,$B7,$76,$96,$DD,$EE,$D5,$40	;OPEPYR1
		.dc.b	$00,$2A,$B2,$94,$D5,$40,$00		;OPEPYR2
		.dc.b	$0B,$60					;OBELISK0
		.dc.b	$BB,$66					;OBELISK1
		.dc.b	$BB,$66					;OBELISK2
		.dc.b	$01,$00,$00				;GLIDER
		.dc.b	$00,$00,$00				;GLSHAD
		.dc.b	$00,$00,$00				;UNFOLD0
		.dc.b	$00,$00,$00				;UNFOLD1
		.dc.b	$04,$00,$00				;UNFOLD2
		.dc.b	$2D,$A0,$00				;GLIDEXP0
		.dc.b	$2A,$A0,$00				;GLIDEXP1
		.dc.b	$2A,$AF,$A0				;GENERXP0
		.dc.b	$2A,$AF,$A0				;GENERXP1
		.dc.b	$08,$0C,$80				;GENERXP2
		.dc.b	$00,$00,$00,$00,$FF,$00,$00,$00,$00	;SPHINXL1
		.dc.b	$F7,$9B,$00,$00,$00,$FF,$FF,$FF,$B0	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$EB,$BB,$FE,$EC	;SPHINXL3
		.dc.b	$00,$00,$FF,$BE,$FA,$FD,$7E,$6B,$FC	;SPHINXL4
		.dc.b	$00,$00,$F0,$00,$00,$00			;SPHINXR2
		.dc.b	$6E,$FF,$FE,$AA,$FA,$FB			;SPHINXR3
		.dc.b	$7B,$EE,$FD,$A5,$79,$40			;SPHINXR4
		.dc.b	$00,$00,$00				;SPFACE1L
		.dc.b	$00,$00,$00				;SPFACE2L
		.dc.b	$00,$00,$00				;SPFACE3L
		.dc.b	$00,$00,$00				;SPFACE4L
		.dc.b	$00,$00,$00				;SPFACE5L
		.dc.b	$FF,$AA,$BA				;SPFACE1H
		.dc.b	$FF,$AA,$EA				;SPFACE2H
		.dc.b	$FF,$AE,$AE				;SPFACE3H
		.dc.b	$FF,$AA,$AE				;SPFACE4H
		.dc.b	$FF,$AA,$AE				;SPFACE5H
		.dc.b	$08,$90,$00				;SCRBEXP1
		.dc.b	$00,$24,$00				;SCRBEXP2
		.dc.b	$00,$00,$00				;NEUFY1
		.dc.b	$00,$00,$00				;NEUFY2
		.dc.b	$00,$00,$00				;NEUFYXPL
		.dc.b	$00,$00,$00				;SCARAB4
		.dc.b	$00,$00,$00				;SCARAB5
		.dc.b	$00,$0F,$BC,$00,$00,$00,$00,$00		;MINISPH0
		.dc.b	$03,$DA,$AE,$BF,$FF,$DF,$FE,$F4		;MINISPH1
		.dc.b	$01,$D7,$41,$00				;UWEEXPL1
		.dc.b	$3F,$FE,$F1,$00				;UWEEXPL2
		.dc.b	$00,$00,$00				;CRATERL
		.dc.b	$FE,$EB,$FF				;CRATERH

		.dc.b	$00,$00					;CANEH
		.dc.b	$00,$00,$00				;EYEH
		.dc.b	$00,$00,$00				;AHNKH
		.dc.b	$00,$00,$00				;BOWLH
		.dc.b	$00,$00,$00				;MANWSTAF
		.dc.b	$00,$00					;FEATHER
		.dc.b	$00,$00					;BIRDH
		.dc.b	$00,$03,$00				;SUNOWTRH
		.dc.b	$07,$C0,$00,$00				;PING1
		.dc.b	$00,$00,$00				;PING2
		.dc.b	$00,$00,$00,$00				;PING EXPL
		.dc.b	$00,$00,$00,$00				;MINIEXP1
		.dc.b	$09,$67,$A1,$40				;MINIEXP2
		.dc.b	$9F,$BB,$FF,$FF				;MINIEXP3
		.dc.b	$30,$48					;SPHXEXPL
		.dc.b	$00,$00					;SPHXFLSH
		.dc.b	$00,$00					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$A200					; LINE 14
		.dc.b	$00,$3B,$64,$00				;BIGPYR0
		.dc.b	$3B,$64					;BIGPYR1
		.dc.b	$00,$00,$00,$2B,$99,$40,$00,$00,$00	;OPEPYR0
		.dc.b	$0A,$AE,$EE,$DE,$97,$BB,$BB,$55,$00	;OPEPYR1
		.dc.b	$00,$0A,$A2,$94,$55,$00,$00		;OPEPYR2
		.dc.b	$2E,$98					;OBELISK0
		.dc.b	$EE,$99					;OBELISK1
		.dc.b	$EE,$99					;OBELISK2
		.dc.b	$03,$C0,$00				;GLIDER
		.dc.b	$00,$00,$00				;GLSHAD
		.dc.b	$10,$00,$00				;UNFOLD0
		.dc.b	$10,$00,$00				;UNFOLD1
		.dc.b	$01,$00,$00				;UNFOLD2
		.dc.b	$3A,$B0,$00				;GLIDEXP0
		.dc.b	$3A,$6A,$AC				;GLIDEXP1
		.dc.b	$3A,$68,$02				;GENERXP0
		.dc.b	$00,$08,$02				;GENERXP1
		.dc.b	$00,$00,$02				;GENERXP2
		.dc.b	$00,$00,$00,$0F,$EB,$C0,$00,$00,$00	;SPHINXL1
		.dc.b	$B6,$EB,$00,$00,$00,$BA,$BF,$FF,$B0	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$EE,$EE,$FD,$F8	;SPHINXL3
		.dc.b	$00,$00,$BF,$BE,$BD,$BF,$6F,$9D,$5C	;SPHINXL4
		.dc.b	$00,$0F,$FC,$00,$00,$00			;SPHINXR2
		.dc.b	$9B,$EF,$EA,$FE,$BF,$B7			;SPHINXR3
		.dc.b	$AE,$FB,$BF,$99,$55,$80			;SPHINXR4
		.dc.b	$FC,$03,$FB				;SPFACE1L
		.dc.b	$FC,$03,$FB				;SPFACE2L
		.dc.b	$FC,$03,$FB				;SPFACE3L
		.dc.b	$FC,$0F,$FB				;SPFACE4L
		.dc.b	$FC,$3E,$BB				;SPFACE5L
		.dc.b	$FF,$FE,$BE				;SPFACE1H
		.dc.b	$FF,$FA,$FA				;SPFACE2H
		.dc.b	$FF,$A7,$AF				;SPFACE3H
		.dc.b	$FF,$FE,$AE				;SPFACE4H
		.dc.b	$FF,$FE,$AE				;SPFACE5H
		.dc.b	$30,$20,$40				;SCRBEXP1
		.dc.b	$0C,$08,$00				;SCRBEXP2
		.dc.b	$7F,$00,$00				;NEUFY1
		.dc.b	$7F,$05,$40				;NEUFY2
		.dc.b	$75,$05,$40				;NEUFYXPL
		.dc.b	$00,$90,$00				;SCARAB4
		.dc.b	$00,$90,$00				;SCARAB5
		.dc.b	$00,$0E,$AF,$00,$00,$00,$3F,$00		;MINISPH0
		.dc.b	$03,$EB,$EF,$AB,$BB,$FE,$BF,$B4		;MINISPH1
		.dc.b	$13,$D5,$50,$00				;UWEEXPL1
		.dc.b	$EB,$AF,$FC,$00				;UWEEXPL2
		.dc.b	$FC,$03,$FB				;CRATERL
		.dc.b	$FD,$AF,$FE				;CRATERH

		.dc.b	$00,$00					;CANEH
		.dc.b	$00,$00,$00				;EYEH
		.dc.b	$00,$00,$00				;AHNKH
		.dc.b	$00,$00,$00				;BOWLH
		.dc.b	$00,$00,$00				;MANWSTAF
		.dc.b	$00,$00					;FEATHER
		.dc.b	$00,$40					;BIRDH
		.dc.b	$00,$02,$00				;SUNOWTRH
		.dc.b	$0D,$40,$00,$00				;PING1
		.dc.b	$02,$F0,$14				;PING2
		.dc.b	$00,$F0,$04,$00				;PING EXPL
		.dc.b	$00,$20,$00,$00				;MINIEXP1
		.dc.b	$2A,$E6,$45,$20				;MINIEXP2
		.dc.b	$76,$BF,$FF,$BF				;MINIEXP3
		.dc.b	$06,$60					;SPHXEXPL
		.dc.b	$00,$00					;SPHXFLSH
		.dc.b	$00,$00					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$A300					; LINE 13
		.dc.b	$00,$EE,$99,$00				;BIGPYR0
		.dc.b	$0E,$90					;BIGPYR1
		.dc.b	$00,$00,$00,$AE,$96,$50,$00,$00,$00	;OPEPYR0
		.dc.b	$0A,$AB,$BB,$BA,$96,$EE,$EE,$55,$00	;OPEPYR1
		.dc.b	$00,$0A,$AE,$97,$55,$00,$00		;OPEPYR2
		.dc.b	$BB,$66					;OBELISK0
		.dc.b	$BB,$66					;OBELISK1
		.dc.b	$BB,$66					;OBELISK2
		.dc.b	$00,$FC,$00				;GLIDER
		.dc.b	$00,$00,$00				;GLSHAD
		.dc.b	$04,$00,$00				;UNFOLD0
		.dc.b	$04,$00,$00				;UNFOLD1
		.dc.b	$0F,$C0,$00				;UNFOLD2
		.dc.b	$3A,$AA,$00				;GLIDEXP0
		.dc.b	$1A,$AA,$60				;GLIDEXP1
		.dc.b	$00,$2A,$60				;GENERXP0
		.dc.b	$00,$2A,$60				;GENERXP1
		.dc.b	$00,$22,$20				;GENERXP2
		.dc.b	$00,$00,$00,$0F,$9E,$F0,$00,$00,$00	;SPHINXL1
		.dc.b	$79,$DA,$00,$00,$00,$EB,$AF,$FF,$AC	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$EF,$F7,$BE,$EC	;SPHINXL3
		.dc.b	$00,$00,$BB,$AE,$BE,$6F,$D6,$55,$64	;SPHINXL4
		.dc.b	$C0,$0F,$AF,$00,$00,$00			;SPHINXR2
		.dc.b	$6E,$EF,$EB,$FF,$EF,$77			;SPHINXR3
		.dc.b	$E7,$AA,$6B,$E6,$55,$00			;SPHINXR4
		.dc.b	$FF,$0F,$FE				;SPFACE1L
		.dc.b	$FF,$0F,$FE				;SPFACE2L
		.dc.b	$FF,$0F,$FE				;SPFACE3L
		.dc.b	$FF,$FA,$FE				;SPFACE4L
		.dc.b	$FF,$FB,$FE				;SPFACE5L
		.dc.b	$EF,$6E,$6F				;SPFACE1H
		.dc.b	$ED,$BA,$BE				;SPFACE2H
		.dc.b	$EF,$96,$AB				;SPFACE3H
		.dc.b	$EF,$6E,$6F				;SPFACE4H
		.dc.b	$EF,$6E,$6E				;SPFACE5H
		.dc.b	$86,$22,$30				;SCRBEXP1
		.dc.b	$25,$9C,$C0				;SCRBEXP2
		.dc.b	$3F,$C0,$00				;NEUFY1
		.dc.b	$3F,$D6,$40				;NEUFY2
		.dc.b	$00,$02,$00				;NEUFYXPL
		.dc.b	$26,$20,$50				;SCARAB4
		.dc.b	$26,$20,$00				;SCARAB5
		.dc.b	$00,$09,$FB,$C0,$00,$00,$EA,$00		;MINISPH0
		.dc.b	$02,$FB,$6E,$EA,$EE,$FA,$EE,$E8		;MINISPH1
		.dc.b	$56,$7A,$74,$00				;UWEEXPL1
		.dc.b	$7E,$E7,$A6,$02				;UWEEXPL2
		.dc.b	$FF,$0F,$FE				;CRATERL
		.dc.b	$EF,$7B,$FA				;CRATERH

		.dc.b	$00,$00					;CANEH
		.dc.b	$00,$00,$00				;EYEH
		.dc.b	$00,$00,$00				;AHNKH
		.dc.b	$00,$00,$00				;BOWLH
		.dc.b	$00,$00,$00				;MANWSTAF
		.dc.b	$00,$00					;FEATHER
		.dc.b	$01,$0C					;BIRDH
		.dc.b	$00,$35,$00				;SUNOWTRH
		.dc.b	$07,$F0,$00,$00				;PING1
		.dc.b	$03,$52,$A9				;PING2
		.dc.b	$00,$C0,$A0,$00				;PING EXPL
		.dc.b	$01,$26,$40,$00				;MINIEXP1
		.dc.b	$1E,$49,$B9,$30				;MINIEXP2
		.dc.b	$59,$FD,$DE,$AF				;MINIEXP3
		.dc.b	$1D,$48					;SPHXEXPL
		.dc.b	$0C,$00					;SPHXFLSH
		.dc.b	$00,$00					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$A400					; LINE 12
		.dc.b	$03,$BB,$66,$40				;BIGPYR0
		.dc.b	$0B,$60					;BIGPYR1
		.dc.b	$00,$00,$02,$BA,$95,$94,$00,$00,$00	;OPEPYR0
		.dc.b	$02,$AA,$EE,$EE,$97,$BB,$B9,$54,$00	;OPEPYR1
		.dc.b	$00,$02,$AA,$95,$54,$00,$00		;OPEPYR2
		.dc.b	$EE,$99					;OBELISK0
		.dc.b	$EE,$99					;OBELISK1
		.dc.b	$EE,$99					;OBELISK2
		.dc.b	$6A,$AA,$A9				;GLIDER
		.dc.b	$FF,$FF,$FF				;GLSHAD
		.dc.b	$6C,$00,$00				;UNFOLD0
		.dc.b	$6B,$C0,$00				;UNFOLD1
		.dc.b	$6A,$B0,$00				;UNFOLD2
		.dc.b	$2A,$AA,$A9				;GLIDEXP0
		.dc.b	$AA,$AA,$A9				;GLIDEXP1
		.dc.b	$AA,$AA,$A8				;GENERXP0
		.dc.b	$00,$08,$00				;GENERXP1
		.dc.b	$00,$00,$00				;GENERXP2
		.dc.b	$00,$00,$00,$FB,$9F,$BC,$00,$00,$00	;SPHINXL1
		.dc.b	$6D,$9B,$00,$00,$00,$EF,$E7,$FF,$EC	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$EF,$FD,$ED,$F8	;SPHINXL3
		.dc.b	$00,$00,$3A,$DF,$6F,$97,$FD,$59,$98	;SPHINXL4
		.dc.b	$C0,$FB,$9B,$C0,$00,$00			;SPHINXR2
		.dc.b	$9B,$BB,$AF,$FF,$F6,$77			;SPHINXR3
		.dc.b	$FA,$E9,$9E,$69,$54,$00			;SPHINXR4
		.dc.b	$FF,$FF,$BF				;SPFACE1L
		.dc.b	$FF,$FF,$BF				;SPFACE2L
		.dc.b	$FF,$FF,$FF				;SPFACE3L
		.dc.b	$FF,$EF,$FF				;SPFACE4L
		.dc.b	$FF,$FE,$BF				;SPFACE5L
		.dc.b	$6F,$6A,$9B				;SPFACE1H
		.dc.b	$6D,$A9,$AE				;SPFACE2H
		.dc.b	$6E,$AA,$A7				;SPFACE3H
		.dc.b	$6F,$6A,$9F				;SPFACE4H
		.dc.b	$6F,$6A,$9F				;SPFACE5H
		.dc.b	$8A,$95,$C8				;SCRBEXP1
		.dc.b	$23,$B4,$18				;SCRBEXP2
		.dc.b	$35,$C0,$00				;NEUFY1
		.dc.b	$35,$D9,$00				;NEUFY2
		.dc.b	$35,$00,$00				;NEUFYXPL
		.dc.b	$2A,$91,$50				;SCARAB4
		.dc.b	$2A,$90,$00				;SCARAB5
		.dc.b	$00,$07,$6E,$F0,$00,$03,$94,$00		;MINISPH0
		.dc.b	$01,$DF,$FF,$BE,$AB,$EB,$BB,$D0		;MINISPH1
		.dc.b	$3E,$EF,$95,$04				;UWEEXPL1
		.dc.b	$3E,$EE,$7D,$06				;UWEEXPL2
		.dc.b	$FF,$FF,$BF				;CRATERL
		.dc.b	$6E,$EF,$EB				;CRATERH

		.dc.b	$00,$00					;CANEH
		.dc.b	$00,$00,$00				;EYEH
		.dc.b	$00,$00,$00				;AHNKH
		.dc.b	$00,$00,$00				;BOWLH
		.dc.b	$00,$00,$00				;MANWSTAF
		.dc.b	$40,$00					;FEATHER
		.dc.b	$06,$4C					;BIRDH
		.dc.b	$00,$20,$00				;SUNOWTRH
		.dc.b	$07,$FC,$00,$00				;PING1
		.dc.b	$01,$FA,$A8				;PING2
		.dc.b	$00,$3C,$00,$00				;PING EXPL
		.dc.b	$12,$81,$88,$00				;MINIEXP1
		.dc.b	$01,$69,$98,$40				;MINIEXP2
		.dc.b	$16,$FB,$66,$EB				;MINIEXP3
		.dc.b	$14,$54					;SPHXEXPL
		.dc.b	$04,$20					;SPHXFLSH
		.dc.b	$00,$00					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$A500					; LINE 11
		.dc.b	$0E,$EE,$99,$90				;BIGPYR0
		.dc.b	$02,$80					;BIGPYR1
		.dc.b	$00,$00,$0A,$EA,$95,$65,$00,$00,$00	;OPEPYR0
		.dc.b	$02,$AB,$BB,$BA,$96,$EE,$ED,$54,$00	;OPEPYR1
		.dc.b	$00,$02,$AA,$95,$54,$00,$00		;OPEPYR2
		.dc.b	$BB,$66					;OBELISK0
		.dc.b	$BB,$66					;OBELISK1
		.dc.b	$BB,$66					;OBELISK2
		.dc.b	$BF,$FF,$FF				;GLIDER
		.dc.b	$FF,$FF,$FF				;GLSHAD
		.dc.b	$BB,$00,$00				;UNFOLD0
		.dc.b	$BE,$FC,$00				;UNFOLD1
		.dc.b	$FB,$FF,$C0				;UNFOLD2
		.dc.b	$AA,$6B,$FF				;GLIDEXP0
		.dc.b	$6B,$7A,$B7				;GLIDEXP1
		.dc.b	$68,$00,$34				;GENERXP0
		.dc.b	$28,$00,$34				;GENERXP1
		.dc.b	$28,$00,$30				;GENERXP2
		.dc.b	$00,$00,$00,$F7,$9B,$EF,$00,$00,$00	;SPHINXL1
		.dc.b	$6E,$6A,$00,$00,$00,$EF,$F9,$FF,$EC	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$EF,$FF,$7A,$EC	;SPHINXL3
		.dc.b	$00,$00,$3D,$EB,$AF,$E5,$FB,$FF,$E8	;SPHINXL4
		.dc.b	$F0,$F7,$9E,$F0,$00,$00			;SPHINXR2
		.dc.b	$66,$EF,$BF,$B7,$7D,$B7			;SPHINXR3
		.dc.b	$EE,$AA,$69,$56,$60,$00			;SPHINXR4
		.dc.b	$FF,$EB,$EF				;SPFACE1L
		.dc.b	$FF,$BF,$FF				;SPFACE2L
		.dc.b	$FF,$EA,$EF				;SPFACE3L
		.dc.b	$FF,$FA,$EF				;SPFACE4L
		.dc.b	$FF,$FB,$FF				;SPFACE5L
		.dc.b	$7E,$AB,$EB				;SPFACE1H
		.dc.b	$7E,$AA,$6E				;SPFACE2H
		.dc.b	$7E,$AB,$F6				;SPFACE3H
		.dc.b	$7E,$AB,$EB				;SPFACE4H
		.dc.b	$7E,$AB,$EB				;SPFACE5H
		.dc.b	$6A,$ED,$D3				;SCRBEXP1
		.dc.b	$1F,$9D,$64				;SCRBEXP2
		.dc.b	$1F,$F0,$95				;NEUFY1
		.dc.b	$1F,$D4,$40				;NEUFY2
		.dc.b	$1F,$D4,$40				;NEUFYXPL
		.dc.b	$1A,$65,$50				;SCARAB4
		.dc.b	$1A,$65,$00				;SCARAB5
		.dc.b	$00,$05,$9B,$BC,$00,$02,$40,$00		;MINISPH0
		.dc.b	$03,$FA,$AB,$EA,$6A,$EA,$AF,$C0		;MINISPH1
		.dc.b	$F7,$FE,$A7,$40				;UWEEXPL1
		.dc.b	$F7,$BE,$AB,$40				;UWEEXPL2
		.dc.b	$FF,$EB,$EF				;CRATERL
		.dc.b	$7E,$FF,$FE				;CRATERH

		.dc.b	$C0,$00					;CANEH
		.dc.b	$00,$00,$80				;EYEH
		.dc.b	$00,$00,$00				;AHNKH
		.dc.b	$00,$0A,$A0				;BOWLH
		.dc.b	$03,$00,$00				;MANWSTAF
		.dc.b	$30,$00					;FEATHER
		.dc.b	$14,$BC					;BIRDH
		.dc.b	$03,$50,$00				;SUNOWTRH
		.dc.b	$00,$FA,$A8,$00				;PING1
		.dc.b	$01,$FE,$A0				;PING2
		.dc.b	$03,$F1,$08,$00				;PING EXPL
		.dc.b	$02,$61,$98,$00				;MINIEXP1
		.dc.b	$27,$B6,$67,$40				;MINIEXP2
		.dc.b	$05,$EE,$DD,$FA				;MINIEXP3
		.dc.b	$35,$58					;SPHXEXPL
		.dc.b	$01,$10					;SPHXFLSH
		.dc.b	$01,$00					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$A600					; LINE 10
		.dc.b	$3B,$BB,$66,$64				;BIGPYR0
		.dc.b	$03,$40					;BIGPYR1
		.dc.b	$00,$00,$2B,$AA,$95,$59,$40,$00,$00	;OPEPYR0
		.dc.b	$00,$AA,$DE,$EE,$97,$BB,$75,$50,$00	;OPEPYR1
		.dc.b	$00,$00,$AA,$95,$50,$00,$00		;OPEPYR2
		.dc.b	$EE,$99					;OBELISK0
		.dc.b	$EE,$99					;OBELISK1
		.dc.b	$EE,$99					;OBELISK2
		.dc.b	$BE,$AA,$A8				;GLIDER
		.dc.b	$FF,$FF,$FC				;GLSHAD
		.dc.b	$2E,$C0,$00				;UNFOLD0
		.dc.b	$2E,$AB,$C0				;UNFOLD1
		.dc.b	$3E,$AA,$BF				;UNFOLD2
		.dc.b	$A6,$AA,$A8				;GLIDEXP0
		.dc.b	$A6,$AE,$A8				;GLIDEXP1
		.dc.b	$A6,$AE,$A8				;GENERXP0
		.dc.b	$00,$00,$00				;GENERXP1
		.dc.b	$00,$00,$00				;GENERXP2
		.dc.b	$00,$00,$00,$B6,$EB,$FB,$C0,$00,$00	;SPHINXL1
		.dc.b	$59,$9B,$00,$00,$00,$EF,$FE,$7F,$EC	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$EF,$FF,$D7,$B8	;SPHINXL3
		.dc.b	$00,$00,$2D,$E7,$DB,$F9,$58,$3B,$F8	;SPHINXL4
		.dc.b	$FC,$B7,$DF,$BC,$00,$00			;SPHINXR2
		.dc.b	$9B,$BF,$BE,$ED,$DF,$A7			;SPHINXR3
		.dc.b	$BA,$66,$96,$55,$00,$00			;SPHINXR4
		.dc.b	$FF,$BF,$BF				;SPFACE1L
		.dc.b	$FE,$BF,$BF				;SPFACE2L
		.dc.b	$FF,$FF,$FF				;SPFACE3L
		.dc.b	$FF,$EF,$FF				;SPFACE4L
		.dc.b	$FF,$FE,$8F				;SPFACE5L
		.dc.b	$7E,$AE,$FA				;SPFACE1H
		.dc.b	$7E,$AF,$5A				;SPFACE2H
		.dc.b	$7E,$FB,$BD				;SPFACE3H
		.dc.b	$7E,$AE,$FA				;SPFACE4H
		.dc.b	$7E,$AE,$FA				;SPFACE5H
		.dc.b	$0E,$AE,$70				;SCRBEXP1
		.dc.b	$35,$EB,$54				;SCRBEXP2
		.dc.b	$1F,$FC,$59				;NEUFY1
		.dc.b	$1F,$FC,$00				;NEUFY2
		.dc.b	$1D,$35,$54				;NEUFYXPL
		.dc.b	$46,$A5,$40				;SCARAB4
		.dc.b	$06,$A5,$40				;SCARAB5
		.dc.b	$3F,$01,$6E,$EF,$00,$02,$80,$00		;MINISPH0
		.dc.b	$03,$AA,$BA,$FD,$9B,$E6,$BB,$80		;MINISPH1
		.dc.b	$2F,$FF,$E9,$40				;UWEEXPL1
		.dc.b	$AF,$7B,$EF,$60				;UWEEXPL2
		.dc.b	$FF,$BF,$BF				;CRATERL
		.dc.b	$7F,$BF,$FB				;CRATERH

		.dc.b	$E0,$00					;CANEH
		.dc.b	$00,$02,$00				;EYEH
		.dc.b	$C0,$00,$00				;AHNKH
		.dc.b	$00,$EA,$6B				;BOWLH
		.dc.b	$0C,$C0,$00				;MANWSTAF
		.dc.b	$0C,$00					;FEATHER
		.dc.b	$42,$BC					;BIRDH
		.dc.b	$02,$00,$00				;SUNOWTRH
		.dc.b	$00,$2E,$AA,$40				;PING1
		.dc.b	$00,$3F,$A0				;PING2
		.dc.b	$00,$3E,$AA,$40				;PING EXPL
		.dc.b	$88,$84,$64,$00				;MINIEXP1
		.dc.b	$59,$99,$D6,$00				;MINIEXP2
		.dc.b	$03,$FB,$BF,$BE				;MINIEXP3
		.dc.b	$D9,$54					;SPHXEXPL
		.dc.b	$05,$80					;SPHXFLSH
		.dc.b	$01,$80					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$A700					; LINE 9
		.dc.b	$EE,$EE,$99,$99				;BIGPYR0
		.dc.b	$00,$00					;BIGPYR1
		.dc.b	$00,$00,$AE,$AA,$95,$56,$50,$00,$00	;OPEPYR0
		.dc.b	$00,$AA,$B7,$7A,$96,$DD,$E5,$50,$00	;OPEPYR1
		.dc.b	$00,$00,$AA,$95,$50,$00,$00		;OPEPYR2
		.dc.b	$BB,$66					;OBELISK0
		.dc.b	$BB,$66					;OBELISK1
		.dc.b	$BB,$66					;OBELISK2
		.dc.b	$BB,$FF,$FC				;GLIDER
		.dc.b	$FF,$FF,$FC				;GLSHAD
		.dc.b	$3B,$B0,$00				;UNFOLD0
		.dc.b	$2B,$FA,$BC				;UNFOLD1
		.dc.b	$3B,$FF,$AA				;UNFOLD2
		.dc.b	$9A,$A9,$BC				;GLIDEXP0
		.dc.b	$BA,$A9,$BC				;GLIDEXP1
		.dc.b	$80,$29,$A9				;GENERXP0
		.dc.b	$80,$09,$89				;GENERXP1
		.dc.b	$80,$08,$08				;GENERXP2
		.dc.b	$00,$00,$00,$79,$DE,$FE,$F0,$00,$00	;SPHINXL1
		.dc.b	$E6,$6A,$00,$00,$00,$EF,$FF,$9F,$EC	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$EE,$EF,$FB,$E8	;SPHINXL3
		.dc.b	$00,$00,$0F,$7A,$E5,$FE,$60,$3B,$FC	;SPHINXL4
		.dc.b	$FC,$75,$DF,$EF,$00,$00			;SPHINXR2
		.dc.b	$66,$AF,$BB,$BD,$77,$DB			;SPHINXR3
		.dc.b	$6B,$EB,$69,$54,$00,$00			;SPHINXR4
		.dc.b	$FF,$EB,$FF				;SPFACE1L
		.dc.b	$FF,$EF,$FF				;SPFACE2L
		.dc.b	$FF,$EA,$FF				;SPFACE3L
		.dc.b	$FF,$FA,$3F				;SPFACE4L
		.dc.b	$FF,$FB,$FF				;SPFACE5L
		.dc.b	$FE,$ED,$7A				;SPFACE1H
		.dc.b	$FF,$AE,$DA				;SPFACE2H
		.dc.b	$FF,$EB,$5E				;SPFACE3H
		.dc.b	$FE,$ED,$7A				;SPFACE4H
		.dc.b	$FE,$ED,$7A				;SPFACE5H
		.dc.b	$CA,$BA,$9C				;SCRBEXP1
		.dc.b	$12,$E6,$70				;SCRBEXP2
		.dc.b	$0F,$FF,$64				;NEUFY1
		.dc.b	$0F,$FC,$00				;NEUFY2
		.dc.b	$0F,$00,$00				;NEUFYXPL
		.dc.b	$5A,$BA,$00				;SCARAB4
		.dc.b	$0A,$BA,$50				;SCARAB5
		.dc.b	$FB,$C3,$EB,$BB,$C0,$01,$C0,$00		;MINISPH0
		.dc.b	$01,$EB,$FD,$A6,$66,$EA,$AE,$C0		;MINISPH1
		.dc.b	$3F,$AF,$BE,$00				;UWEEXPL1
		.dc.b	$EA,$AA,$BE,$00				;UWEEXPL2
		.dc.b	$FF,$EB,$FF				;CRATERL
		.dc.b	$FF,$FF,$EA				;CRATERH

		.dc.b	$2C,$00					;CANEH
		.dc.b	$00,$08,$0C				;EYEH
		.dc.b	$F0,$04,$00				;AHNKH
		.dc.b	$03,$AA,$AC				;BOWLH
		.dc.b	$33,$53,$C0				;MANWSTAF
		.dc.b	$0F,$00					;FEATHER
		.dc.b	$00,$BC					;BIRDH
		.dc.b	$35,$03,$F0				;SUNOWTRH
		.dc.b	$00,$2B,$AA,$90				;PING1
		.dc.b	$00,$2F,$F0				;PING2
		.dc.b	$00,$7B,$A0,$80				;PING EXPL
		.dc.b	$09,$6D,$5E,$00				;MINIEXP1
		.dc.b	$96,$6E,$E9,$48				;MINIEXP2
		.dc.b	$03,$EE,$FF,$EB				;MINIEXP3
		.dc.b	$65,$9C					;SPHXEXPL
		.dc.b	$01,$50					;SPHXFLSH
		.dc.b	$01,$40					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$A800					; LINE 8
		.dc.b	$BB,$BB,$66,$66				;BIGPYR0
		.dc.b	$00,$00					;BIGPYR1
		.dc.b	$00,$02,$BA,$AE,$97,$55,$94,$00,$00	;OPEPYR0
		.dc.b	$00,$2A,$9D,$DE,$97,$77,$55,$40,$00	;OPEPYR1
		.dc.b	$00,$00,$2A,$95,$40,$00,$00		;OPEPYR2
		.dc.b	$EE,$99					;OBELISK0
		.dc.b	$EE,$99					;OBELISK1
		.dc.b	$2A,$54					;OBELISK2
		.dc.b	$BB,$EA,$A0				;GLIDER
		.dc.b	$FF,$FF,$F0				;GLSHAD
		.dc.b	$0E,$EC,$00				;UNFOLD0
		.dc.b	$3B,$EF,$A8				;UNFOLD1
		.dc.b	$3B,$EA,$F8				;UNFOLD2
		.dc.b	$AA,$AA,$A0				;GLIDEXP0
		.dc.b	$6A,$EB,$60				;GLIDEXP1
		.dc.b	$6A,$EB,$60				;GENERXP0
		.dc.b	$02,$C0,$00				;GENERXP1
		.dc.b	$02,$C0,$00				;GENERXP2
		.dc.b	$00,$00,$00,$6D,$BB,$BF,$BC,$00,$00	;SPHINXL1
		.dc.b	$19,$9B,$00,$00,$00,$EF,$FF,$E7,$EC	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$EB,$BB,$F7,$B8	;SPHINXL3
		.dc.b	$00,$00,$0B,$79,$F9,$7F,$E0,$3B,$B8	;SPHINXL4
		.dc.b	$FF,$79,$D7,$FB,$C0,$00			;SPHINXR2
		.dc.b	$97,$BF,$BE,$EE,$6E,$5E			;SPHINXR3
		.dc.b	$55,$96,$DD,$50,$00,$00			;SPHINXR4
		.dc.b	$BF,$BF,$FF				;SPFACE1L
		.dc.b	$BE,$BF,$FF				;SPFACE2L
		.dc.b	$BF,$FF,$FF				;SPFACE3L
		.dc.b	$BF,$EF,$EB				;SPFACE4L
		.dc.b	$BF,$FE,$BB				;SPFACE5L
		.dc.b	$FF,$AF,$FE				;SPFACE1H
		.dc.b	$FF,$B5,$EA				;SPFACE2H
		.dc.b	$FF,$5B,$FF				;SPFACE3H
		.dc.b	$FF,$AF,$FE				;SPFACE4H
		.dc.b	$FF,$AF,$FE				;SPFACE5H
		.dc.b	$13,$EA,$A4				;SCRBEXP1
		.dc.b	$04,$F7,$A0				;SCRBEXP2
		.dc.b	$15,$FF,$51				;NEUFY1
		.dc.b	$00,$FF,$00				;NEUFY2
		.dc.b	$54,$3F,$00				;NEUFYXPL
		.dc.b	$5B,$EA,$80				;SCARAB4
		.dc.b	$1B,$EA,$90				;SCARAB5
		.dc.b	$EA,$F6,$FA,$FE,$C0,$01,$C0,$00		;MINISPH0
		.dc.b	$02,$FE,$FB,$61,$9A,$F9,$AB,$80		;MINISPH1
		.dc.b	$3E,$BF,$E6,$40				;UWEEXPL1
		.dc.b	$FE,$BB,$DF,$40				;UWEEXPL2
		.dc.b	$BF,$BF,$FF				;CRATERL
		.dc.b	$FF,$FF,$FA				;CRATERH

		.dc.b	$0E,$00					;CANEH
		.dc.b	$0F,$F0,$30				;EYEH
		.dc.b	$3C,$30,$00				;AHNKH
		.dc.b	$0E,$A6,$B0				;BOWLH
		.dc.b	$00,$54,$C0				;MANWSTAF
		.dc.b	$0D,$C0					;FEATHER
		.dc.b	$00,$BC					;BIRDH
		.dc.b	$20,$0F,$BC				;SUNOWTRH
		.dc.b	$00,$2A,$E8,$04				;PING1
		.dc.b	$00,$0B,$F0				;PING2
		.dc.b	$00,$2F,$D4,$04				;PING EXPL
		.dc.b	$A6,$4B,$9A,$00				;MINIEXP1
		.dc.b	$21,$69,$11,$14				;MINIEXP2
		.dc.b	$03,$FF,$FF,$FF				;MINIEXP3
		.dc.b	$2E,$94					;SPHXEXPL
		.dc.b	$07,$40					;SPHXFLSH
		.dc.b	$02,$40					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$A900					; LINE 7
		.dc.b	$2E,$EE,$99,$98				;BIGPYR0
		.dc.b	$00,$00					;BIGPYR1
		.dc.b	$00,$0A,$EA,$B6,$95,$D5,$65,$00,$00	;OPEPYR0
		.dc.b	$00,$2A,$B7,$76,$96,$DD,$D5,$40,$00	;OPEPYR1
		.dc.b	$00,$00,$2A,$E5,$40,$00,$00		;OPEPYR2
		.dc.b	$BB,$66					;OBELISK0
		.dc.b	$BB,$66					;OBELISK1
		.dc.b	$2A,$54					;OBELISK2
		.dc.b	$BB,$BF,$F0				;GLIDER
		.dc.b	$FF,$FF,$F0				;GLSHAD
		.dc.b	$03,$BB,$00				;UNFOLD0
		.dc.b	$0B,$BA,$F1				;UNFOLD1
		.dc.b	$0F,$BA,$A0				;UNFOLD2
		.dc.b	$A9,$AA,$F0				;GLIDEXP0
		.dc.b	$AB,$AE,$A0				;GLIDEXP1
		.dc.b	$AB,$80,$A0				;GENERXP0
		.dc.b	$8B,$A2,$A0				;GENERXP1
		.dc.b	$03,$20,$20				;GENERXP2
		.dc.b	$00,$00,$00,$6E,$6E,$EF,$EF,$00,$00	;SPHINXL1
		.dc.b	$36,$66,$00,$00,$00,$EE,$EF,$FA,$EC	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$EE,$EE,$FB,$E4	;SPHINXL3
		.dc.b	$00,$00,$03,$6D,$7E,$5F,$80,$0D,$EC	;SPHINXL4
		.dc.b	$EF,$6D,$5A,$FE,$F0,$00			;SPHINXR2
		.dc.b	$59,$EF,$BB,$BF,$9B,$72			;SPHINXR3
		.dc.b	$65,$65,$55,$80,$00,$00			;SPHINXR4
		.dc.b	$FF,$E8,$FF				;SPFACE1L
		.dc.b	$FF,$EB,$FF				;SPFACE2L
		.dc.b	$FF,$E8,$BF				;SPFACE3L
		.dc.b	$FF,$FA,$BE				;SPFACE4L
		.dc.b	$FF,$FA,$AE				;SPFACE5L
		.dc.b	$EF,$6F,$FE				;SPFACE1H
		.dc.b	$EF,$FF,$FA				;SPFACE2H
		.dc.b	$EF,$FA,$AF				;SPFACE3H
		.dc.b	$EF,$6F,$FE				;SPFACE4H
		.dc.b	$EF,$6A,$FE				;SPFACE5H
		.dc.b	$06,$5A,$AC				;SCRBEXP1
		.dc.b	$AD,$9B,$A8				;SCRBEXP2
		.dc.b	$59,$0F,$C0				;NEUFY1
		.dc.b	$00,$3F,$C0				;NEUFY2
		.dc.b	$00,$3F,$D5				;NEUFYXPL
		.dc.b	$0A,$5B,$A0				;SCARAB4
		.dc.b	$5A,$5B,$A0				;SCARAB5
		.dc.b	$9F,$BB,$FF,$FF,$C0,$01,$C0,$00		;MINISPH0
		.dc.b	$03,$EE,$BE,$F3,$A9,$BA,$66,$80		;MINISPH1
		.dc.b	$3F,$EF,$E9,$90				;UWEEXPL1
		.dc.b	$BA,$EB,$AB,$80				;UWEEXPL2
		.dc.b	$FF,$EA,$FF				;CRATERL
		.dc.b	$EF,$FF,$FE				;CRATERH

		.dc.b	$02,$C0					;CANEH
		.dc.b	$35,$60,$C0				;EYEH
		.dc.b	$0F,$C0,$00				;AHNKH
		.dc.b	$0A,$AA,$C0				;BOWLH
		.dc.b	$80,$55,$C0				;MANWSTAF
		.dc.b	$0E,$70					;FEATHER
		.dc.b	$00,$AC					;BIRDH
		.dc.b	$50,$0E,$AF				;SUNOWTRH
		.dc.b	$00,$2A,$B8,$00				;PING1
		.dc.b	$00,$02,$FC				;PING2
		.dc.b	$00,$02,$88,$00				;PING EXPL
		.dc.b	$21,$59,$12,$00				;MINIEXP1
		.dc.b	$25,$96,$A4,$10				;MINIEXP2
		.dc.b	$00,$BE,$FB,$FF				;MINIEXP3
		.dc.b	$09,$30					;SPHXEXPL
		.dc.b	$00,$30					;SPHXFLSH
		.dc.b	$00,$00					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$AA00					; LINE 6
		.dc.b	$3B,$BB,$66,$64				;BIGPYR0
		.dc.b	$00,$00					;BIGPYR1
		.dc.b	$00,$2B,$AA,$DE,$97,$75,$59,$40,$00	;OPEPYR0
		.dc.b	$00,$0A,$A1,$DE,$97,$74,$55,$00,$00	;OPEPYR1
		.dc.b	$00,$00,$0B,$99,$00,$00,$00		;OPEPYR2
		.dc.b	$EE,$99					;OBELISK0
		.dc.b	$EE,$99					;OBELISK1
		.dc.b	$2A,$54					;OBELISK2
		.dc.b	$3B,$B5,$40				;GLIDER
		.dc.b	$3F,$FF,$C0				;GLSHAD
		.dc.b	$00,$E6,$C0				;UNFOLD0
		.dc.b	$0E,$E7,$C0				;UNFOLD1
		.dc.b	$0E,$E7,$C0				;UNFOLD2
		.dc.b	$3A,$95,$40				;GLIDEXP0
		.dc.b	$19,$9A,$90				;GLIDEXP1
		.dc.b	$1A,$9A,$92				;GENERXP0
		.dc.b	$00,$00,$02				;GENERXP1
		.dc.b	$00,$00,$02				;GENERXP2
		.dc.b	$00,$00,$00,$59,$BB,$BB,$FB,$C0,$00	;SPHINXL1
		.dc.b	$0D,$9B,$00,$00,$00,$EB,$BB,$FD,$FC	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$EF,$F7,$B7,$98	;SPHINXL3
		.dc.b	$00,$00,$02,$DF,$5F,$96,$00,$0D,$98	;SPHINXL4
		.dc.b	$FF,$6D,$6B,$BF,$BC,$20			;SPHINXR2
		.dc.b	$5A,$BF,$BE,$AF,$EE,$60			;SPHINXR3
		.dc.b	$95,$8A,$58,$00,$00,$00			;SPHINXR4
		.dc.b	$FF,$BF,$BF				;SPFACE1L
		.dc.b	$FE,$BE,$BF				;SPFACE2L
		.dc.b	$FF,$FF,$EB				;SPFACE3L
		.dc.b	$FF,$EA,$AF				;SPFACE4L
		.dc.b	$FF,$EF,$EF				;SPFACE5L
		.dc.b	$6F,$FA,$FF				;SPFACE1H
		.dc.b	$6F,$AF,$FE				;SPFACE2H
		.dc.b	$6F,$AB,$AA				;SPFACE3H
		.dc.b	$6F,$FA,$FF				;SPFACE4H
		.dc.b	$6F,$AE,$AF				;SPFACE5H
		.dc.b	$16,$BE,$A8				;SCRBEXP1
		.dc.b	$06,$B6,$A8				;SCRBEXP2
		.dc.b	$64,$03,$C0				;NEUFY1
		.dc.b	$02,$57,$C0				;NEUFY2
		.dc.b	$02,$17,$C0				;NEUFYXPL
		.dc.b	$29,$D6,$E0				;SCARAB4
		.dc.b	$69,$D6,$E0				;SCARAB5
		.dc.b	$76,$B6,$FF,$BF,$C0,$01,$C0,$00		;MINISPH0
		.dc.b	$00,$2F,$6F,$82,$E6,$6E,$99,$00		;MINISPH1
		.dc.b	$0E,$FE,$BA,$94				;UWEEXPL1
		.dc.b	$FA,$A5,$BF,$80				;UWEEXPL2
		.dc.b	$FF,$BF,$FF				;CRATERL
		.dc.b	$6E,$FE,$EB				;CRATERH

		.dc.b	$00,$E0					;CANEH
		.dc.b	$DF,$63,$00				;EYEH
		.dc.b	$03,$FB,$80				;AHNKH
		.dc.b	$2A,$6B,$00				;BOWLH
		.dc.b	$20,$15,$C0				;MANWSTAF
		.dc.b	$0E,$9C					;FEATHER
		.dc.b	$00,$2C					;BIRDH
		.dc.b	$00,$0E,$AB				;SUNOWTRH
		.dc.b	$00,$2A,$AF,$00				;PING1
		.dc.b	$00,$00,$0E				;PING2
		.dc.b	$00,$28,$8F,$00				;PING EXPL
		.dc.b	$06,$5E,$68,$00				;MINIEXP1
		.dc.b	$69,$59,$7A,$00				;MINIEXP2
		.dc.b	$00,$FF,$FF,$EB				;MINIEXP3
		.dc.b	$06,$04					;SPHXEXPL
		.dc.b	$00,$00					;SPHXFLSH
		.dc.b	$00,$00					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$AB00					; LINE 5
		.dc.b	$0E,$EE,$99,$90				;BIGPYR0
		.dc.b	$00,$00					;BIGPYR1
		.dc.b	$00,$AE,$AB,$76,$96,$DD,$56,$50,$00	;OPEPYR0
		.dc.b	$00,$0A,$AC,$76,$95,$D2,$55,$00,$00	;OPEPYR1
		.dc.b	$00,$00,$0E,$96,$00,$00,$00		;OPEPYR2
		.dc.b	$BB,$66					;OBELISK0
		.dc.b	$BB,$66					;OBELISK1
		.dc.b	$0A,$50					;OBELISK2
		.dc.b	$3B,$B5,$40				;GLIDER
		.dc.b	$3F,$FF,$C0				;GLSHAD
		.dc.b	$00,$39,$80				;UNFOLD0
		.dc.b	$02,$ED,$40				;UNFOLD1
		.dc.b	$0E,$E9,$40				;UNFOLD2
		.dc.b	$2A,$A5,$40				;GLIDEXP0
		.dc.b	$2A,$AA,$A0				;GLIDEXP1
		.dc.b	$28,$0A,$A0				;GENERXP0
		.dc.b	$28,$0A,$20				;GENERXP1
		.dc.b	$20,$00,$00				;GENERXP2
		.dc.b	$00,$00,$00,$D6,$EE,$EE,$FE,$F0,$00	;SPHINXL1
		.dc.b	$03,$66,$00,$00,$00,$EE,$EE,$FE,$EC	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$EF,$FD,$EB,$64	;SPHINXL3
		.dc.b	$00,$00,$00,$37,$D7,$FC,$00,$03,$AC	;SPHINXL4
		.dc.b	$EF,$55,$9A,$EF,$EF,$00			;SPHINXR2
		.dc.b	$56,$EF,$BF,$AB,$AB,$98			;SPHINXR3
		.dc.b	$00,$00,$00,$00,$00,$00			;SPHINXR4
		.dc.b	$FF,$EB,$EF				;SPFACE1L
		.dc.b	$FF,$EB,$EF				;SPFACE2L
		.dc.b	$FF,$EA,$BE				;SPFACE3L
		.dc.b	$FF,$EF,$AB				;SPFACE4L
		.dc.b	$FF,$FA,$FB				;SPFACE5L
		.dc.b	$7F,$AE,$AA				;SPFACE1H
		.dc.b	$7E,$EA,$AA				;SPFACE2H
		.dc.b	$7F,$AA,$AA				;SPFACE3H
		.dc.b	$7F,$AE,$AA				;SPFACE4H
		.dc.b	$7F,$AB,$AB				;SPFACE5H
		.dc.b	$0D,$AF,$A8				;SCRBEXP1
		.dc.b	$32,$BF,$A8				;SCRBEXP2
		.dc.b	$51,$00,$F0				;NEUFY1
		.dc.b	$01,$64,$F1				;NEUFY2
		.dc.b	$00,$00,$01				;NEUFYXPL
		.dc.b	$28,$75,$C0				;SCARAB4
		.dc.b	$28,$75,$C0				;SCARAB5
		.dc.b	$59,$FA,$BE,$AF,$F0,$3E,$B0,$00		;MINISPH0
		.dc.b	$00,$2B,$DA,$81,$B9,$9B,$56,$00		;MINISPH1
		.dc.b	$0F,$AF,$EA,$F0				;UWEEXPL1
		.dc.b	$3B,$AF,$AA,$C0				;UWEEXPL2
		.dc.b	$FF,$EA,$BF				;CRATERL
		.dc.b	$7F,$FE,$AA				;CRATERH

		.dc.b	$00,$2C					;CANEH
		.dc.b	$DF,$63,$00				;EYEH
		.dc.b	$0C,$D2,$C0				;AHNKH
		.dc.b	$2A,$AC,$00				;BOWLH
		.dc.b	$08,$05,$00				;MANWSTAF
		.dc.b	$02,$A6					;FEATHER
		.dc.b	$00,$2C					;BIRDH
		.dc.b	$00,$0E,$AB				;SUNOWTRH
		.dc.b	$00,$2A,$03,$80				;PING1
		.dc.b	$00,$00,$0A				;PING2
		.dc.b	$00,$00,$00,$00				;PING EXPL
		.dc.b	$29,$95,$42,$00				;MINIEXP1
		.dc.b	$20,$55,$A0,$20				;MINIEXP2
		.dc.b	$00,$CF,$FF,$BA				;MINIEXP3
		.dc.b	$04,$08					;SPHXEXPL
		.dc.b	$00,$00					;SPHXFLSH
		.dc.b	$00,$00					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$AC00					; LINE 4
		.dc.b	$0B,$BB,$66,$60				;BIGPYR0
		.dc.b	$00,$00					;BIGPYR1
		.dc.b	$02,$BA,$AD,$DE,$97,$77,$55,$94,$00	;OPEPYR0
		.dc.b	$00,$02,$A8,$1E,$97,$41,$54,$00,$00	;OPEPYR1
		.dc.b	$00,$00,$02,$94,$00,$00,$00		;OPEPYR2
		.dc.b	$EE,$99					;OBELISK0
		.dc.b	$EE,$99					;OBELISK1
		.dc.b	$0A,$50					;OBELISK2
		.dc.b	$3B,$B5,$00				;GLIDER
		.dc.b	$3F,$FF,$00				;GLSHAD
		.dc.b	$00,$0E,$00				;UNFOLD0
		.dc.b	$03,$BD,$00				;UNFOLD1
		.dc.b	$0E,$B9,$00				;UNFOLD2
		.dc.b	$3A,$B5,$00				;GLIDEXP0
		.dc.b	$39,$A9,$20				;GLIDEXP1
		.dc.b	$B9,$A9,$20				;GENERXP0
		.dc.b	$B9,$00,$00				;GENERXP1
		.dc.b	$00,$00,$00				;GENERXP2
		.dc.b	$00,$FC,$00,$19,$BB,$BB,$BF,$BC,$00	;SPHINXL1
		.dc.b	$00,$DB,$00,$00,$00,$EF,$F7,$BD,$FC	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$BF,$FF,$7F,$98	;SPHINXL3
		.dc.b	$00,$00,$00,$2D,$F5,$60,$00,$03,$68	;SPHINXL4
		.dc.b	$FF,$96,$6B,$BB,$FB,$C0			;SPHINXR2
		.dc.b	$59,$BB,$AE,$6B,$EA,$90			;SPHINXR3
		.dc.b	$00,$00,$00,$00,$00,$00			;SPHINXR4
		.dc.b	$EF,$AA,$BB				;SPFACE1L
		.dc.b	$EF,$AA,$BB				;SPFACE2L
		.dc.b	$EF,$AA,$AB				;SPFACE3L
		.dc.b	$EF,$FA,$EB				;SPFACE4L
		.dc.b	$EF,$EF,$BB				;SPFACE5L
		.dc.b	$7F,$AA,$AA				;SPFACE1H
		.dc.b	$7E,$AA,$AA				;SPFACE2H
		.dc.b	$7E,$AA,$AA				;SPFACE3H
		.dc.b	$7F,$AA,$AA				;SPFACE4H
		.dc.b	$7E,$AA,$AA				;SPFACE5H
		.dc.b	$C0,$EF,$63				;SCRBEXP1
		.dc.b	$0E,$B1,$EC				;SCRBEXP2
		.dc.b	$00,$00,$35				;NEUFY1
		.dc.b	$01,$90,$34				;NEUFY2
		.dc.b	$15,$90,$34				;NEUFYXPL
		.dc.b	$28,$05,$00				;SCARAB4
		.dc.b	$28,$05,$00				;SCARAB5
		.dc.b	$16,$EF,$BE,$EB,$FC,$FA,$6C,$00		;MINISPH0
		.dc.b	$00,$0A,$F6,$02,$7E,$56,$98,$00		;MINISPH1
		.dc.b	$F0,$3F,$FE,$2C				;UWEEXPL1
		.dc.b	$F3,$3A,$FE,$00				;UWEEXPL2
		.dc.b	$EF,$AF,$AF				;CRATERL
		.dc.b	$7E,$EA,$AA				;CRATERH

		.dc.b	$00,$0E					;CANEH
		.dc.b	$D5,$83,$00				;EYEH
		.dc.b	$13,$96,$C0				;AHNKH
		.dc.b	$26,$B0,$00				;BOWLH
		.dc.b	$02,$F4,$BC				;MANWSTAF
		.dc.b	$00,$AB					;FEATHER
		.dc.b	$00,$0A					;BIRDH
		.dc.b	$00,$0E,$A7				;SUNOWTRH
		.dc.b	$00,$1A,$02,$80				;PING1
		.dc.b	$00,$00,$00				;PING2
		.dc.b	$00,$1A,$02,$80				;PING EXPL
		.dc.b	$10,$96,$10,$00				;MINIEXP1
		.dc.b	$0D,$25,$91,$00				;MINIEXP2
		.dc.b	$00,$0B,$FF,$FE				;MINIEXP3
		.dc.b	$00,$00					;SPHXEXPL
		.dc.b	$00,$00					;SPHXFLSH
		.dc.b	$00,$00					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$AD00					; LINE 3
		.dc.b	$02,$EE,$99,$80				;BIGPYR0
		.dc.b	$00,$00					;BIGPYR1
		.dc.b	$0A,$EA,$B7,$76,$96,$DD,$D5,$65,$00	;OPEPYR0
		.dc.b	$00,$02,$AB,$06,$95,$09,$54,$00,$00	;OPEPYR1
		.dc.b	$00,$00,$02,$94,$00,$00,$00		;OPEPYR2
		.dc.b	$BB,$66					;OBELISK0
		.dc.b	$BB,$66					;OBELISK1
		.dc.b	$0A,$50					;OBELISK2
		.dc.b	$3B,$B0,$00				;GLIDER
		.dc.b	$3F,$F0,$00				;GLSHAD
		.dc.b	$00,$00,$00				;UNFOLD0
		.dc.b	$00,$A0,$00				;UNFOLD1
		.dc.b	$03,$B0,$00				;UNFOLD2
		.dc.b	$3B,$B0,$00				;GLIDEXP0
		.dc.b	$3B,$A8,$00				;GLIDEXP1
		.dc.b	$2B,$A8,$08				;GENERXP0
		.dc.b	$0B,$A8,$08				;GENERXP1
		.dc.b	$00,$08,$08				;GENERXP2
		.dc.b	$00,$FF,$00,$36,$EE,$EE,$EF,$EF,$00	;SPHINXL1
		.dc.b	$00,$37,$00,$00,$00,$EF,$FD,$EE,$EC	;SPHINXL2
		.dc.b	$00,$00,$00,$00,$00,$FF,$FF,$DE,$64	;SPHINXL3
		.dc.b	$00,$00,$00,$0B,$BF,$00,$00,$00,$D8	;SPHINXL4
		.dc.b	$EF,$D9,$EE,$EE,$FE,$F0			;SPHINXR2
		.dc.b	$D6,$AF,$EF,$9A,$FB,$90			;SPHINXR3
		.dc.b	$00,$00,$00,$00,$00,$00			;SPHINXR4
		.dc.b	$EF,$BE,$AE				;SPFACE1L
		.dc.b	$EF,$FA,$AE				;SPFACE2L
		.dc.b	$EF,$BF,$AA				;SPFACE3L
		.dc.b	$EF,$EF,$AB				;SPFACE4L
		.dc.b	$EF,$EF,$EB				;SPFACE5L
		.dc.b	$FE,$BF,$FA				;SPFACE1H
		.dc.b	$FE,$BF,$FA				;SPFACE2H
		.dc.b	$FE,$BF,$FA				;SPFACE3H
		.dc.b	$FE,$BF,$FA				;SPFACE4H
		.dc.b	$FE,$BF,$FA				;SPFACE5H
		.dc.b	$04,$38,$04				;SCRBEXP1
		.dc.b	$0E,$8F,$30				;SCRBEXP2
		.dc.b	$00,$00,$1E				;NEUFY1
		.dc.b	$01,$44,$04				;NEUFY2
		.dc.b	$01,$44,$04				;NEUFYXPL
		.dc.b	$30,$00,$00				;SCARAB4
		.dc.b	$30,$00,$00				;SCARAB5
		.dc.b	$05,$FE,$BF,$FA,$FF,$F7,$AB,$C0		;MINISPH0
		.dc.b	$00,$02,$A0,$00,$6F,$95,$60,$00		;MINISPH1
		.dc.b	$00,$C2,$A0,$0C				;UWEEXPL1
		.dc.b	$0F,$EF,$6C,$00				;UWEEXPL2
		.dc.b	$EF,$BB,$FB				;CRATERL
		.dc.b	$FE,$BF,$FA				;CRATERH

		.dc.b	$05,$0A					;CANEH
		.dc.b	$EA,$0C,$00				;EYEH
		.dc.b	$03,$96,$C0				;AHNKH
		.dc.b	$2A,$C0,$00				;BOWLH
		.dc.b	$00,$80,$B3				;MANWSTAF
		.dc.b	$00,$2B					;FEATHER
		.dc.b	$00,$0E					;BIRDH
		.dc.b	$00,$0E,$5B				;SUNOWTRH
		.dc.b	$00,$04,$00,$00				;PING1
		.dc.b	$00,$00,$00				;PING2
		.dc.b	$00,$00,$10,$00				;PING EXPL
		.dc.b	$01,$28,$80,$00				;MINIEXP1
		.dc.b	$18,$A8,$43,$00				;MINIEXP2
		.dc.b	$00,$0F,$FE,$EA				;MINIEXP3
		.dc.b	$00,$00					;SPHXEXPL
		.dc.b	$00,$00					;SPHXFLSH
		.dc.b	$00,$00					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$AE00					; LINE 2
		.dc.b	$03,$BB,$66,$40				;BIGPYR0
		.dc.b	$00,$00					;BIGPYR1
		.dc.b	$2B,$AA,$DD,$DE,$97,$77,$75,$59,$40	;OPEPYR0
		.dc.b	$00,$00,$AA,$02,$94,$05,$50,$00,$00	;OPEPYR1
		.dc.b	$00,$00,$00,$90,$00,$00,$00		;OPEPYR2
		.dc.b	$EE,$99					;OBELISK0
		.dc.b	$EE,$99					;OBELISK1
		.dc.b	$02,$40					;OBELISK2
		.dc.b	$3B,$00,$00				;GLIDER
		.dc.b	$3F,$00,$00				;GLSHAD
		.dc.b	$00,$00,$00				;UNFOLD0
		.dc.b	$00,$E4,$00				;UNFOLD1
		.dc.b	$03,$80,$00				;UNFOLD2
		.dc.b	$3B,$00,$00				;GLIDEXP0
		.dc.b	$3B,$00,$00				;GLIDEXP1
		.dc.b	$00,$AA,$80				;GENERXP0
		.dc.b	$00,$82,$80				;GENERXP1
		.dc.b	$00,$80,$00				;GENERXP2
		.dc.b	$0F,$EB,$C0,$0D,$BB,$BB,$BB,$FB,$C0	;SPHINXL1
		.dc.b	$00,$0D,$00,$00,$00,$EF,$FF,$79,$FC	;SPHINXL2
		.dc.b	$00,$00,$FF,$FF,$FF,$FA,$5F,$DD,$94	;SPHINXL3
		.dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$34	;SPHINXL4
		.dc.b	$BF,$F6,$BB,$BB,$BF,$B0			;SPHINXR2
		.dc.b	$F5,$BB,$EB,$96,$AA,$90			;SPHINXR3
		.dc.b	$00,$00,$00,$00,$00,$00			;SPHINXR4
		.dc.b	$BF,$EB,$AB				;SPFACE1L
		.dc.b	$BF,$EE,$AF				;SPFACE2L
		.dc.b	$BF,$BB,$EA				;SPFACE3L
		.dc.b	$BF,$EF,$EB				;SPFACE4L
		.dc.b	$BF,$FB,$EB				;SPFACE5L
		.dc.b	$FE,$FF,$FF				;SPFACE1H
		.dc.b	$FE,$FF,$FF				;SPFACE2H
		.dc.b	$FE,$FF,$FF				;SPFACE3H
		.dc.b	$FE,$FF,$FF				;SPFACE4H
		.dc.b	$FE,$FF,$FF				;SPFACE5H
		.dc.b	$00,$00,$00				;SCRBEXP1
		.dc.b	$02,$88,$40				;SCRBEXP2
		.dc.b	$00,$00,$18				;NEUFY1
		.dc.b	$00,$00,$05				;NEUFY2
		.dc.b	$00,$00,$00				;NEUFYXPL
		.dc.b	$00,$00,$00				;SCARAB4
		.dc.b	$00,$00,$00				;SCARAB5
		.dc.b	$03,$EA,$BF,$BE,$FF,$DE,$FA,$B0		;MINISPH0
		.dc.b	$00,$00,$00,$00,$9A,$AA,$80,$00		;MINISPH1
		.dc.b	$00,$00,$00,$0C				;UWEEXPL1
		.dc.b	$03,$FE,$C0,$0C				;UWEEXPL2
		.dc.b	$BF,$6E,$FB				;CRATERL
		.dc.b	$FE,$FF,$FF				;CRATERH

		.dc.b	$01,$CE					;CANEH
		.dc.b	$00,$30,$00				;EYEH
		.dc.b	$03,$AB,$00				;AHNKH
		.dc.b	$0B,$00,$00				;BOWLH
		.dc.b	$00,$20,$00				;MANWSTAF
		.dc.b	$00,$0B					;FEATHER
		.dc.b	$00,$04					;BIRDH
		.dc.b	$00,$03,$AF				;SUNOWTRH
		.dc.b	$00,$09,$00,$00				;PING1
		.dc.b	$00,$00,$00				;PING2
		.dc.b	$00,$08,$00,$00				;PING EXPL
		.dc.b	$08,$84,$00,$00				;MINIEXP1
		.dc.b	$00,$4A,$0A,$50				;MINIEXP2
		.dc.b	$00,$0B,$BF,$FD				;MINIEXP3
		.dc.b	$00,$00					;SPHXEXPL
		.dc.b	$00,$00					;SPHXFLSH
		.dc.b	$00,$00					;SPHXGLMR
		.dc.b	$00,$00					;BLANK

		ORG	$AF00					; LINE 1
		.dc.b	$00,$EE,$99,$00				;BIGPYR0
		.dc.b	$00,$00					;BIGPYR1
		.dc.b	$AE,$AB,$77,$76,$96,$DD,$DD,$56,$50	;OPEPYR0
		.dc.b	$00,$00,$AA,$C2,$94,$35,$50,$00,$00	;OPEPYR1
		.dc.b	$00,$00,$00,$90,$00,$00,$00		;OPEPYR2
		.dc.b	$BB,$66					;OBELISK0
		.dc.b	$BB,$66					;OBELISK1
		.dc.b	$02,$40					;OBELISK2
		.dc.b	$10,$00,$00				;GLIDER
		.dc.b	$30,$00,$00				;GLSHAD
		.dc.b	$00,$00,$00				;UNFOLD0
		.dc.b	$00,$00,$00				;UNFOLD1
		.dc.b	$01,$00,$00				;UNFOLD2
		.dc.b	$10,$00,$00				;GLIDEXP0
		.dc.b	$10,$00,$00				;GLIDEXP1
		.dc.b	$28,$00,$00				;GENERXP0
		.dc.b	$08,$00,$00				;GENERXP1
		.dc.b	$00,$00,$00				;GENERXP2
		.dc.b	$0F,$9E,$F0,$03,$AE,$FF,$FE,$FE,$C0	;SPHINXL1
		.dc.b	$00,$03,$00,$00,$00,$EF,$FF,$DE,$EC	;SPHINXL2
		.dc.b	$00,$00,$EF,$FA,$EB,$EB,$97,$DA,$54	;SPHINXL3
		.dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00	;SPHINXL4
		.dc.b	$AE,$FE,$FF,$FE,$EF,$EC			;SPHINXR2
		.dc.b	$7E,$AE,$FA,$E6,$B9,$60			;SPHINXR3
		.dc.b	$00,$00,$00,$00,$00,$00			;SPHINXR4
		.dc.b	$FF,$BE,$AB				;SPFACE1L
		.dc.b	$FF,$BA,$AB				;SPFACE2L
		.dc.b	$FF,$FF,$AA				;SPFACE3L
		.dc.b	$FF,$FF,$AB				;SPFACE4L
		.dc.b	$FF,$FF,$EB				;SPFACE5L
		.dc.b	$FE,$FF,$FF				;SPFACE1H
		.dc.b	$FE,$FF,$FF				;SPFACE2H
		.dc.b	$FE,$FF,$FF				;SPFACE3H
		.dc.b	$FE,$FF,$FF				;SPFACE4H
		.dc.b	$FE,$FF,$FF				;SPFACE5H
		.dc.b	$00,$00,$00				;SCRBEXP1
		.dc.b	$03,$00,$CC				;SCRBEXP2
		.dc.b	$00,$00,$18				;NEUFY1
		.dc.b	$00,$00,$01				;NEUFY2
		.dc.b	$00,$00,$51				;NEUFYXPL
		.dc.b	$00,$00,$00				;SCARAB4
		.dc.b	$00,$00,$00				;SCARAB5
		.dc.b	$02,$FE,$BF,$EB,$FF,$77,$BF,$9C		;MINISPH0
		.dc.b	$00,$00,$00,$00,$25,$28,$00,$00		;MINISPH1
		.dc.b	$00,$00,$00,$00				;UWEEXPL1
		.dc.b	$00,$00,$00,$00		;UWEEXPL2
		.dc.b	$FF,$7B,$FE		;CRATERL
		.dc.b	$FE,$FF,$FF		;CRATERH

		.dc.b	$00,$EC			;CANEH
		.dc.b	$0F,$80,$00		;EYEH
		.dc.b	$00,$FC,$00		;AHNKH
		.dc.b	$0C,$00,$00		;BOWLH
		.dc.b	$00,$00,$00		;MANWSTAF
		.dc.b	$00,$03			;FEATHER
		.dc.b	$00,$10			;BIRDH
		.dc.b	$00,$00,$FC		;SUNOWTRH
		.dc.b	$00,$00,$00,$00		;PING1
		.dc.b	$00,$00,$00		;PING2
		.dc.b	$00,$00,$00,$00		;PING EXPL
		.dc.b	$00,$48,$00,$00		;MINIEXP1
		.dc.b	$01,$49,$10,$00		;MINIEXP2
		.dc.b	$00,$00,$33,$A6		;MINIEXP3
		.dc.b	$00,$00			;SPHXEXPL
		.dc.b	$00,$00			;SPHXFLSH
		.dc.b	$00,$00			;SPHXGLMR
		.dc.b	$00,$00			;BLANK

;		END
