;	file: vars.s
;
;	ATARI 7800 Crossbow program variables
;
;	zero page
;
;	sky and ground background pal
;
	.org	$40

fadsky:		.ds.b	1
fadgrnd1:	.ds.b	1
fadgrnd2:	.ds.b	1
;
;	misc zero pagers
;
	.org	$43

temp:		.ds.b	1	;very local variable
intcnt:		.ds.b	1	;interrupt count from vbl

xpos:		.ds.b	1	;subroutine passsage and temp
ypos:		.ds.b	1

curhdr:		.ds.b	1	;for make header
curzon:		.ds.b	1
haddrl:		.ds.b	1	;header addr
haddrh:		.ds.b	1
baddrl:		.ds.b	1	;bitmap addr
baddrh:		.ds.b	1
addrl:		.ds.b	1	;temp general purpose
addrh:		.ds.b	1
palwid:		.ds.b	1	;pal, width
hpos:		.ds.b	1	;hpos
vpos:		.ds.b	1	;vpos
destht:		.ds.b	1	;dest height
srcht:		.ds.b	1	;source height
srchts:		.ds.b	1	;..save
srcw:		.ds.b	1	;source width
baddrhs:	.ds.b	1	;bitmap addrh save

seedtab:	.ds.b	3	;random number generator
rindex:		.ds.b	1	;random number index

clock:		.ds.b	1	;decrements every field
timer:		.ds.b	1	;resettable field count
i:		.ds.b	1	;temp

intptr:		.ds.b	1	;interrupt jump table pointer

frypos:		.ds.b	1	;current screen friend y pos
fallevel:	.ds.b	1	;y level that enemies fall to

animl:		.ds.b	1	;animation sequence indirect address
animh:		.ds.b	1

jaddr:		.ds.w	1	;jump address
intjmp:		.ds.w	1	;interrupt indirect jump

sky:		.ds.b	1	;sky
ground1:	.ds.b	1	;ground
ground2:	.ds.b	1	;ground
pauseon:	.ds.b	1	;pause on

curfr:		.ds.b	1	;current friend

paddrl:		.ds.b	1	;points display data
ppalwid:	.ds.b	1
ptime:		.ds.b	1
phpos:		.ds.b	1
pvpos:		.ds.b	1

;current
gottreasure:	.ds.b	1

curarcher:	.ds.b	1	;current archer
curarrow:	.ds.b	1

;
;collision detection vars

xd:		.ds.b	1	;x down
xu:		.ds.b	1	;x up
yd:		.ds.b	1	;y down
yu:		.ds.b	1	;y up
xl:		.ds.b	1	;x left
xr:		.ds.b	1	;x right
yl:		.ds.b	1	;y left
yr:		.ds.b	1	;y right
cdheight:	.ds.b	1	;height of overlap (2's comp)
cdwidth:	.ds.b	1	;width of overlap (2's comp)
lesserup:	.ds.b	1	;lesser of xu,yu
lesserright:	.ds.b	1	;lesser of xr,yr

xah:		.ds.b	1	;x address high
yah:		.ds.b	1	;y address high

pal:		.ds.b	1	;primary address low/high
pah:		.ds.b	1
sal:		.ds.b	1	;secondary address low/high
sah:		.ds.b	1

pshift:		.ds.b	1	;primary shift
sshift:		.ds.b	1	;secondary shift

palsav:		.ds.b	1	;saved
salsav:		.ds.b	1

pbyte:		.ds.b	1	;primary byte
sbyte:		.ds.b	1	;secondary byte

rwidth:		.ds.b	1	;remaining width

;moving object records in zero page for memory and cycle saving

movsta:		.ds.b	MAXMOV	;status
movx:		.ds.b	MAXMOV	;mover location
movy:		.ds.b	MAXMOV

soundon:	.ds.b	1		;anded with avol
audvshadow:	.ds.b	AUDCHANNELS	;volume shadow
saddrl:		.ds.b	AUDCHANNELS	;seq addr
saddrh:		.ds.b	AUDCHANNELS
sptr:		.ds.b	AUDCHANNELS	;seq offset index
stime:		.ds.b	AUDCHANNELS	;till next update
shistory:	.ds.b	AUDCHANNELS	;length played already
spriority:	.ds.b	AUDCHANNELS	;sound priority

gun:		.ds.b	1	;boolean true if light gun selected

endzero:
ENDZERO equ endzero

	.assert	(* <= $100)		;assure that zero page is not overrun
;
;	base ram storage
;
	.org	RAM1

hdrlst:	.ds.b	HDRPITCH * ZONECNT

	.assert (* <= (RAM1 + R1SIZE))	;check end
;
;
;
	.org	RAM2

r160tmp:	.ds.b	1	;rand160 temp

timeout:	.ds.b	1	;menu choice timeout

selecton:	.ds.b	1	;select on
left:		.ds.b	1	;joystick direction flags
right:		.ds.b	1
up:		.ds.b	1
down:		.ds.b	1
cursc:		.ds.b	1	;current screen
prevsc:		.ds.b	1	;previous screen
gameover:	.ds.b	1

idlemode:	.ds.b	1	;if true, than idle mode

facefade:	.ds.b	1	;dissolve states
skullfade:	.ds.b	1
disdir:		.ds.b	1	;dissolve direction

doordown:	.ds.b	1	;true if castle door fallen

path1:		.ds.b	1	;next screens after map
path2:		.ds.b	1
path3:		.ds.b	1
frlimit:	.ds.b	1	;friend limit
greenline:	.ds.b	1	;map scr button dividing lines
redline:	.ds.b	1
choice:		.ds.b	1	;path the player chose
subpal:		.ds.b	1	;substitute pal
gavewarning:	.ds.b	1	;dont shoot friends warn
fallsta:	.ds.b	1	;status of fallen stalactites
frstop:		.ds.b	1	;x pos frs stop before proceeding
stoptime:	.ds.b	1	;time friends have waited
dropflag:	.ds.b	1	;high when trap doors opened

curmes:		.ds.b	1	;current message after face screen
mesclock:	.ds.b	1	;has its own clock


eyesred:	.ds.b	1	;bool face screen
frtarget:	.ds.b	1	;bool frs in range

botflag:	.ds.b	1	;bottom of screen flag
activefrs:	.ds.b	1	;number of active friends
frwait:		.ds.b	1	;boolean, high if any friend is waiting
oldsw:		.ds.b	1	;old state consol switches
oldjs:		.ds.b	1	;old state joystick
fadlum:		.ds.b	1	;faded luminance
fadsta:		.ds.b	1	;fade state
faddir:		.ds.b	1	;fade direction
fadtim:		.ds.b	1	;fade time

lampcount:		.ds.b	1	;lamp count

.if DEBUG
nodefeat:	.ds.b	1	;game can't be lost if true
.endif


	.assert (* <= $2200)	;check end of RAM2
;
;
	.org	RAM3

;moving object records
movht:		.ds.b	MAXMOV	;height zones
movw:		.ds.b	MAXMOV	;width bytes
movpw:		.ds.b	MAXMOV	;pal width
movt1:		.ds.b	MAXMOV	;timer1
movfrl:		.ds.b	MAXMOV	;frame address
movfrh:		.ds.b	MAXMOV
movaniml:	.ds.b	MAXMOV	;animation sequence address
movanimh:	.ds.b	MAXMOV
movdseql:	.ds.b	MAXMOV	;death sequence
movdseqh:	.ds.b	MAXMOV
movdscore:	.ds.b	MAXMOV	;death score
movtype:	.ds.b	MAXMOV	;type, moving xy or stationary (T_XY/T_ST)
movframe:	.ds.b	MAXMOV	;animation frame
movid:		.ds.b	MAXMOV	;identity or velocity

movloop:	.ds.b	MAXMOV	;anim loop counter

ramzon:		.ds.b	256	;zone list in ram
hdrplst:	.ds.w	ZONECNT	;header pointer list
hdrmlst:	.ds.w	ZONECNT	;header moving object list
frstat:		.ds.b	NUMBFRS	;friend status
limptab:	.ds.b	2	;active friends limping bool

palshad:	.ds.b	34	;pal shadow for fades

intjt:		.ds.w	NUMBINT	;interrupt jump table

pathmem:	.ds.b	NUMBPATHS	;paths already taken by player (boolean)

score:		.ds.b	SCRDGTS		;current score
hiscore:	.ds.b	SCRDGTS		;hi-score to date
savescore:	.ds.b	SCRDGTS		;temp score storage

vblhdr:		.ds.b	7	;null vblank header

beenhere:	.ds.b	NUMBSCRS	;+1 each time each screen is completed

	.assert	(* <= $2700)	;locations above here reserved for lite gun
;
