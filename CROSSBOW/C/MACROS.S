;	file: macros.s
;	contains custom macros for Atari 7800 Crossbow
;	Author: Scott Marshall
;	Copyright 1988 by Imagineering, Inc.
;
;	Macros
;
;
;	push and pop data items on the stack
;
.macro	save	addr

	lda	\addr
	pha
.endm
.macro	restore	addr

	pla
	sta	\addr
.endm
.macro	pushx
	txa
	pha
.endm
.macro	popx
	pla
	tax
.endm
.macro	pushy
	tya
	pha
.endm
.macro	popy
	pla
	tay
.endm
;
;	bitmap include and address assignment
;
.macro	bitmap	addr,name
RBMA	set	\addr
.include	\name
.endm
;
;
;this macro constructs a zone list entry
;
.macro	zone	dli,h16,h8,offset,addr

dc.b	((\dli*$80) | (\h16*$40) | (\h8*$20) | (\offset-1))
dc.b	\addr >> 8
dc.b	\addr & $ff
.endm
;
;this macro loads the accumulator with an immediate palette and width
;
.macro	ldpw	pal,width

	lda	#((\pal << 5) | (((~\width)+1)&$1f))
.endm
;
;this macro sets the shadow pal to load into maria on fade-in
;
.macro	setpal	pal,index,hue	;only to the shadow

	lda	#(\hue)
	sta	palshad+(\pal*4)+(\index)
.endm
.macro	resetpal	pal,index,hue	;both pal and shadow

	lda	#(\hue)
	sta	palshad+(\pal*4)+(\index)
	sta	PALS+(\pal*4)+(\index)
.endm
;
;	this macro makes four constant bytes representing palette values
;	a null byte is a place saver for the null fourth color
;
.macro	paltab	c1,c2,c3

	dc.b	0,(\c1),(\c2),(\c3)
.endm
;
;	this macro loads baddrl/h with a constant address
;
.macro	setbaddr	baddr

	lda	#(\baddr) & $FF
	sta	baddrl
	lda	#(\baddr) >> 8
	sta	baddrh
.endm
;
;	this macro sets an interrupt jump table entry
;
.macro	setijt	zone,proc

	lda	#(\proc) & $FF
	sta	intjt+(\zone)
	lda	#(\proc) >> 8
	sta	intjt+(\zone+1)
.endm
;
;	This macro increments a word in memory
;
.macro	incw	addrl

	inc	\addrl
	bne	.\~
	inc	\addrl+1
.\~:
.endm
;
;	These macros create animation instructions.
;	Init:	h,w,pal,x,y,type,stat,time,fr,seq,deathseq,killseq
;	(addr of first seq is first byte after init data)
;	Format: time to next inst, bitmap addr, delta x,y
;
;
;	anim init
.macro	animini	h,w,pal,x,y,stat,time,fr,seq,dseq,type

	.dc.b	(\h),(\w),(((\pal) << 5) | (((~(\w))+1)&$1f))
	.dc.b	(\x) & $FF,(\y) & $FF,(\stat) & $FF,(\time)
	.dc.b	(\fr) & $FF,(\fr) >> 8,(\seq) & $FF,(\seq) >> 8
	.dc.b	(\dseq) & $FF,(\dseq) >> 8,(\type)
CURTYPE	set	(\type)
.endm
;
.macro	animi	time,addr,dx,dy

	.dc.b	\time,\addr & $FF,\dx & $FF,\dy & $FF
.endm
;
.macro	animend	stat,addr,time

	.dc.b	0,\stat,\addr & $FF,\addr >> 8
.endm
;
.macro	makeaniminit	addr
	lda	#(\addr) & $FF
	sta	animl
	lda	#(\addr) >> 8
	sta	animh
	jsr	doaniminit
.endm
.macro	makeanim	addr
	lda	#(\addr) & $FF
	sta	movaniml,x
	lda	#(\addr) >> 8
	sta	movanimh,x
.endm
;
;	These macros create animation instructions for stationary objects.
;	Format: time to next inst, bitmap addrl
;	End list: zero time, new status, jump address
;
.macro	animsi	time,addr,dx,dy

	.dc.b	\time,\addr & $FF
.endm
;
.macro	animsend	stat,addr,time

	.dc.b	0,\stat,\addr & $FF,\addr >> 8
.endm
;
;	new animation instruction set
;
.macro	animf	dx,dy,frame,time	;anim frame
.if (CURTYPE = T_XY)
	.dc.b	(\time),(\frame) & $FF,\dx,\dy
.endif
.if (CURTYPE = T_ST)
.assert ((\dx) = 0) & ((\dy) = 0)
	.dc.b	(\time),(\frame) & $FF
.endif
.endm
;
;
;
.macro	anima	id	;anim audio
	.dc.b	0,A_AUDIO,(\id)
.endm
.macro	animj	addr	;anim jump
	.dc.b	0,A_JUMP,(\addr) & $FF,(\addr) >> 8
.endm
.macro	anims	stat	;anim status
	.dc.b	0,A_STATUS,\stat
.endm
.macro	animp	points	;points for killing this thing
	.dc.b	0,A_POINTS,\points
.endm
.macro	animl	count	;count for allowing jumps
	.dc.b	0,A_LOOP,(\count)-1
.endm
.macro	animd	dx,dy
	.dc.b	0,A_DELTA,(\dx),(\dy)
.endm
;
;	bank switch macro
;	execute this in any source file that contains code for loading
;	into a switched bank
;
.macro	setbank	bank
BANKNBR	equ	\bank
DUMMY	equ	BANKNBR
.endm
;
;	these macros create header data lists
;	input: zone, baddr, pal, width, hpos
;	output baddrh (hi nibble) zone (lo nibble), baddrl, palwid, hpos
;	end of header list is $FF (F is not a valid zone)
;
.macro	hdrdat	z,baddr,p,w,hpos
.dc.b	((\baddr)>>8)|(\z),(\baddr)&$FF,((\p)<<5)|(((~(\w))+1)&$1f),\hpos
.endm

.macro	hdrdatend
.dc.b	$FF
.endm
;
.macro	makeheaders	addr
	lda	#(\addr) & $FF
	sta	addrl
	lda	#(\addr) >> 8
	sta	addrh
	jsr	readhdrs
.endm
;
;	tall object data
;	output: baddrh|zone,baddrl,srcht/w,destx,destht,palwid
;
.macro talldat z,baddr,srcht,srcw,destx,destht,w,p
.dc.b	((\baddr)>>8)|(\z),(\baddr)&$FF,(\srcht),(\srcw)
.dc.b	(\destx),(\destht),((\p)<<5)|(((~(\w))+1)&$1f)
.endm

.macro	talldatend
.dc.b	$FF
.endm

.macro	maketall	addr
	lda	#(\addr) & $FF
	sta	addrl
	lda	#(\addr) >> 8
	sta	addrh
	jsr	readtall
.endm
;
;	supersound system audio
;	call sequence:
;	audstart	id, control, priority
;	audi		vol, freq, time
;	audend
;	AUDDAT asserts that data has been started or stopped
;
AUDDAT	set	0

.macro	audstart	id,control,pri
.assert (AUDDAT = 0)
AUDDAT set	1
AASAVE	set	*			;save current addr
.org	soundtable + (\id)		;word addr (only even id's)
.dc.w	AASAVE				;write address word
.org	AASAVE				;reset current addr
.dc.b	(\control) | ((\pri) << 4)	;write priority/control byte
.endm

.macro	audi		vol,freq,time
.assert (AUDDAT = 1)
.dc.b	((\time) << 1) | ((\vol) & 1),((\freq) << 3) | ((\vol) >> 1)
.endm

.macro	audend
AUDDAT	set	0
.dc.b	0
.endm

.macro	makesound	id
	lda	#(\id)
	jsr	playsound
.endm
.end
