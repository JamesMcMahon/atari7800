;file: coldet.s
;collision detect
;sister file: cdvars.s (collision detect variables)
;
;	precision version
;	call with movs in x and y regs
;	rts carry set if collision
;
coldet:
	pushx
	pushy
;
;	calc useful params
;
	lda	movy,x	;xd = movy,x
	sta	xd

	lda	movht,x	;xu = (movht,x * 16) + xd
	asl
	asl
	asl
	asl
	clc
	adc	xd
	sta	xu

	lda	movy,y	;yd = movy,y
	sta	yd

	lda	movht,y	;yu = (movht,y * 16) + yx
	asl
	asl
	asl
	asl
	clc
	adc	yd
	sta	yu

	lda	movx,x	;xl = movx,x
	clc
	adc	#($100 - SCWP)/2
	sta	xl
	lda	movx,y	;yl = movx,y
	clc
	adc	#($100 - SCWP)/2
	sta	yl

	lda	movw,x	;xr = xl + (movw,x << 2)
	asl
	asl
	clc
	adc	xl
	sta	xr

	lda	movw,y	;yr = yl + (movw,y << 2)
	asl
	asl
	clc
	adc	yl
	sta	yr
;
;	find lesser of xu,yu store as lesserup
;
	lda	xu
	cmp	yu
	bcc	.yuOVERxu
;xuOVERyu:
	lda	yu
	jmp	.break1
.yuOVERxu:
	lda	xu
.break1:
	sta	lesserup
;
;	switch on greater of (xd,yd)
;
	lda	xd
	cmp	yd
	bcc	.ydOVERxd
;
;	set high addresses and height of overlap
;
;xdOVERyd:
	lda	movfrh,x	;xah = movfrh,x
	sta	xah

	lda	movfrh,y	;yah = movfrh,y + (xd - yd)
	clc
	adc	xd
	sec
	sbc	yd
	sta	yah

	lda	xd	;cdheight = xd - lesser(xu,yu) (2's comp)
	sec
	sbc	lesserup
	sta	cdheight
	jmp	.break2
.ydOVERxd:
	lda	movfrh,y	;yah = movfrh,y
	sta	yah

	lda	movfrh,x	;xah = movfrh,x + (yd - xd)
	clc
	adc	yd
	sec
	sbc	xd
	sta	xah

	lda	yd		;cdheight = yd - lesser(xu,yu) (2's comp)
	sec
	sbc	lesserup
	sta	cdheight
.break2:
;
;	2`s comp of height and its carry are ready here
;	if carry set, then no overlap, ret false
;
	bcc	.lineoverlap
	jmp	.exitfalse
.lineoverlap:
;
;	find lesser of xr,yr store as lesserright
;
	lda	xr
	cmp	yr
	bcc	.yrOVERxr
;xrOVERyr:
	lda	yr
	jmp	.break3
.yrOVERxr:
	lda	xr
.break3:
	sta	lesserright
;
;	switch on greater of (xl,yl)
;
	lda	xl
	cmp	yl
	bcc	.yprimary
;
;	set low addresses and width of overlap
;
;xprimary:
	lda	xah		;pah = xah
	sta	pah

	lda	yah		;sah = yah
	sta	sah

	lda	movfrl,x	;pal = movfrl,x
	sta	pal

	lda	xl		;pshift = (xl - yl) & %11
	sec
	sbc	yl
	sta	i		;save this intermediate calc (xl - yl)
	and	#%11
	sta	pshift
	eor	#%11		;sshift = ~pshift + 1 & %11
	clc
	adc	#1
	sta	sshift

	lda	i		;sal = ((xl - yl) >> 2) + movfrl,y
	lsr
	lsr
	clc
	adc	movfrl,y
	sta	sal

	lda	xl	;cdwidth = xl - lesser(xr,yr) (2's comp)
	sec
	sbc	lesserright
	sta	cdwidth
	jmp	.break4
.yprimary:
	lda	yah		;pah = yah
	sta	pah

	lda	xah		;sah = xah
	sta	sah

	lda	movfrl,y	;pal = movfrl,y
	sta	pal

	lda	yl		;pshift = (yl - xl) & %11
	sec
	sbc	xl
	sta	i		;save this intermediate calc (yl - xl)
	and	#%11
	sta	pshift
	eor	#%11		;sshift = ~pshift + 1 & %11
	clc
	adc	#1
	sta	sshift

	lda	i		;sal = ((yl - xl) >> 2) + movfrl,x
	lsr
	lsr
	clc
	adc	movfrl,x
	sta	sal

	lda	yl	;cdwidth = yl - lesser(yr,xr) (2's comp)
	sec
	sbc	lesserright
	sta	cdwidth
.break4:
;
;	2`s comp of width and its carry are ready here
;	carry set, then no overlap, rts false
;
	bcc	.pixoverlap
	jmp	.exitfalse
.pixoverlap:
;
;	x and y regs now used for new purposes
;
	ldy	#0
;
;	save vars that will be clobbered in inner loop but needed again

	lda	pal
	sta	palsav

	lda	sal
	sta	salsav


.lineloop:

	lda	(sal),y		;get first secondary byte
	beq	.skipc1
.if 0
	jsr	convbits
.endif
	tax			;convert 2bits per pixel to 1
	lda	COLTAB,x
.skipc1:
	inc	sal		;point to next byte
	sta	sbyte

	lda	cdwidth		;init remaining width
	sta	rwidth

.pixloop:

	lda	(pal),y		;get primary byte
	beq	.skipc2
.if 0
	jsr	convbits	;convert 2bits per pixel to 1
.endif
	tax
	lda	COLTAB,x
.skipc2:
	inc	pal		;point to next byte
	sta	pbyte

	ldx	pshift		;shift primary byte
	beq	.donepshift
.pshiftloop:
	lsr
	dex
	bne	.pshiftloop
.donepshift:

	and	sbyte		;AND shifted primary with secondary bytes
	bne	.exittrue

	lda	rwidth		;update remaining width, exit inner if zero
	clc
	adc	sshift
	sta	rwidth
	beq	.breakinner
;
;	Get secondary byte, inc pointer, shift, AND with primary byte
;
	lda	(sal),y
	beq	.skipc3
.if 0
	jsr	convbits
.endif
	tax			;convert 2 bits per pixel to 1
	lda	COLTAB,x
.skipc3:
	inc	sal
	sta	sbyte
	
	ldx	sshift		;shift secondary byte
	beq	.donesshift
.sshiftloop:
	lsr
	dex
	bne	.sshiftloop
.donesshift:

	and	pbyte		;AND shifted secondary with primary
	bne	.exittrue

	lda	rwidth		;update remaining width, exit inner if zero
	clc
	adc	pshift
	sta	rwidth
	beq	.breakinner

	jmp	.pixloop
.breakinner:	
;
;	if no remaining height, exit false
;
	inc	cdheight
	beq	.exitfalse
;
;	restore clobbered vars, check next line
;
	lda	palsav
	sta	pal
	lda	salsav
	sta	sal

	inc	pah	;inc address highs
	inc	sah

	jmp	.lineloop
.exittrue:
	popy
	popx
	sec
	rts
.exitfalse:
	popy
	popx
	clc
	rts
;
;	convert bits
;	compresses one byte of 2 bits per pixel to one bit per pixel
;	input and output in accumulator
;	clobbers x reg, i
.if 0
convbits:
	tax
	lda	COLTAB,x
	rts

	tax
	lda	#0
	sta	i
	txa
	and	#%11
	beq	.skip1
	lda	#1
	sta	i
.skip1:	txa
	and	#%1100
	beq	.skip2
	lda	#%10
	ora	i
	sta	i
.skip2:	txa
	and	#%110000
	beq	.skip3
	lda	#%100
	ora	i
	sta	i
.skip3:	txa
	and	#%11000000
	beq	.skip4
	lda	#%1000
	ora	i
	sta	i
.skip4:	lda	i
.endif
	rts
;
;	set score to an absolute number, in A reg (octal readout)
;
.if 0
setscore:
	sta	i
	pushx
	pushy
	lda	#0
	sta	score
	sta	score+1
	sta	score+2
	lda	i
	asl
	asl
	asl
	asl
	and	#%01110000
	jsr	incsc
	lda	i
	asl
	and	#%01110000
	ora	#1
	jsr	incsc		
	lda	i
	lsr
	lsr
	and	#%01110000
	ora	#2
	jsr	incsc
	popy
	popx
	lda	i
	rts
.endif
