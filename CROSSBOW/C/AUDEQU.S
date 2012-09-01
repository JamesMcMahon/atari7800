;	file: audequ.s
;	audio equates
;
AUDADDR		equ	$4000		;main data table start address

AUDIDCNT	equ	0		;make sequential id values
;
;	macro increments each audio id by 2 (they point to word addresses)
;
.macro	audid	name
\name	equ	AUDIDCNT
AUDIDCNT	set	AUDIDCNT + 2	;inc 2 bytes for word each
.endm

AUDCHANNELS	equ	2
;
;	audio id's
;
audid	TESTA
audid	TESTB
audid	TESTC
audid	TESTD
audid	UWILLDA
audid	UWILLDB
audid	WHIP
audid	BEEP
audid	BARF
audid	AH1
audid	AH2
audid	AH3
audid	AH4
audid	OWHER
audid	OWDWA
audid	OWWOM
audid	OUCH
audid	CROAK
audid	FIRE
audid	CLANKA
audid	CLANKB
audid	CLANK2A
audid	CLANK2B
audid	CUCKOO
audid	TREASURE
audid	HAHAHA
audid	BLAH
audid	BOOM
audid	CREAKY
;
;	cave
;
audid	BATCRY
audid	ICED
audid	FSTDA
audid	FSTDB
audid	BATD
audid	SNOD
audid	ICEHIT
;
;	town
;
audid	THANKYOU
audid	WHOHAHA
audid	OHHH
audid	POOF
audid	BOLTDIE
audid	WIZFB
audid	LAMPD
audid	WOLFD
audid	CURSUA
audid	CURSUB
;
;	desert
;
audid	ANTD
audid	BIRDCRY
audid	BIRDD
audid	RAB
audid	RABD
audid	SNAKED
audid	SCORPD
;
;	jungle
;
audid	TOCANCRY
audid	CHIMPD
audid	PLANTD
audid	COCOD
;
;	castle
;
audid	BOW
audid	PTERACRY
audid	ARCHERD
audid	PTERAD
;
;	bridge
;
audid	FROGJ
audid	OWLCRY
audid	BLOOP
;
;	room
;
audid	FANFAREA
audid	FANFAREB
;
;	volcano
;
audid	UPBOOM
audid	ROCKDIE
audid	FROCKD
;
;	room
;
audid	FACE1D
audid	FACE2D
audid	GROWL	;dragon
audid	SPEARS
audid	TRAPSOUND
;
;	face
;
audid	DRUM
audid	WHTEYED
audid	DIEA
audid	DIEB
;
;	offscreen fire cuckoo
;
audid	CUCKOO2

.end
