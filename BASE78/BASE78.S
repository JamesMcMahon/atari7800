*****************************************************************
*								*
*		7800 Base Unit Rom Code				*
*	Modified Asteroids with a bit of O.S			*
*			16-May-88				*
*								*
*		Dave Staugas, programmer			*
*****************************************************************
*
*
	.include	"RASTDEF.S"
	.include	"STAMPS.S"
	.include	"MAIN.S"
	.include	"JOY.S"
	.include	"FSM.S"
	.include	"EXPLODE.S"
	.include	"COLLIDE.S"
	.include	"SCORE.S"
	.include	"MORESTMP.S"
	.include	"TUNES.S"
	.include	"ROCKMOVE.S"
	.include	"INIT.S"
	.include	"UFO.S"
	.include	"UTILS.S"
	.include	"RASTLOAD.S"
	.include	"TABLES.S"
	.include	"os7800.s"
*
avail	equ	*
*
*
	.org	$fffa
	.dc.w	NMI
	.dc.w	startup
	.dc.w	IRQ
