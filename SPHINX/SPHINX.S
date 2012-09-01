*         SPHINX.S--SVEX.S

;          ZERODEF

*         ALIEN STUFF
          ORG     $FF80                  ; $FF80 - $FFF7 RESERVED FOR ALIEN

	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
	.dc.b      $FF,$FF,$FF,$FF,$FF
;                 ;120 FOR ALIEN

* VECTORS FOR STARTUP
	ORG     $FFF8
          .dc.b      $FF,$47
          .dc.b      HANDLER,HANDLER/256	;DLI HANDLER    NMI
          .dc.b      STARTUP&$FF,STARTUP/256	; STARTUP VECTOR
          .dc.b      0,0			;IRQ VECTOR NOT USED

;          END
