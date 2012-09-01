;	Desert Falcon - SDEF.S

	.subttl	"RAM allocation."


          ORG     $1800

DL0:      .ds.b     80      ;80             ;DISPLAY LIST ZERO

PL1MAP:   .ds.b     10                     ;PLAYER 1 SCORE
TOPMSMAP: .ds.b     20                     ;TOP OF MESSAGE MAP
PL2MAP:   .ds.b     10      ;40             ;PLAYER 2 SCORE

SWIMMING: .ds.b     1                      ;BIT 7 HIGH IF SWIMMING
SPNCNT:   .ds.b     1                      ;DELAY BETWEEN SPAWNINGS
RESERVD:  .ds.b     1       ;3              ;OBJ SLOTS RESERVED

SHOTSTAT: .ds.b     4                      ;STATUS OF SHOTS
SCRLLCNT: .ds.b     1                      ;SCROLL COUNTER
OSCRLCNT: .ds.b     1       ;6              ;OLD SCROLL COUNTER

LEFTBUT:  .ds.b     2                      ;LEFT BUTTON SOFTWARE REGISTER
RIGHTBUT: .ds.b     2                      ;RIGHT BUTTON SOFTWARE REGISTER
ONEBUT:   .ds.b     1                      ;BITS 2-4? SET IFF ONE-BUTTON JOYSTICK
ETIMER:   .ds.b     1                      ;EAST JOYSTICK MOVEMENT TIMER
WTIMER:   .ds.b     1                      ;WEST JOYSTICK MOVEMENT TIMER
TITCNT:   .ds.b     1                      ;TITLE PAGE COUNTER FOR FRAMES SORTA
STIMER:   .ds.b     1                      ;SELECT TIMER
OTIMER:   .ds.b     1       ;10             ;OVERALL SELECT TIMER

P5C2SHAD: .ds.b     1                      ;SHADOWS FOR PALETTES OF BOTTOM OF
P1C2SHAD: .ds.b     1                      ;SCREEN DISPLAY
P2C2SHAD: .ds.b     1
P0C2SHAD: .ds.b     1
P1C2SHDB: .ds.b     1
GRMCPCNT: .ds.b     1

TAKEOVER: .ds.b     1                      ;ARE THESE NEEDED ANYMORE GUYS
ROLLER:   .ds.b     1
WHTUWANT: .ds.b     1
SCRFLAG:  .ds.b     1                      ;FLAG FROM MAINLOOP TO TALK TO INTERR.
MINITBL:  .ds.b     6                      ;MINI SPHINX INDEX TABLE
MINIOVER: .ds.b     6       ;16             ;MINI SPHINX OVERLAY SLOT TABLE

PTRTBLLO: .ds.b     4                      ;LOOKAHEAD CHAR MAP POINTERS
PTRTBLHI: .ds.b     4                      ; " "
STUFFDEX: .ds.b     1                      ;INDEX IN POINTER TABLE USED TO STUFF
LOADFDEX: .ds.b     1                      ;INDEX IN PTR TABLE USED TO LOAD FROM
LEFTMASK: .ds.b     4                      ;LEFT SIDE OF CHAR MAP MASK
MIDMASK:  .ds.b     4                      ;MIDDLE OF CHAR MAP MASK
RIGTMASK: .ds.b     4       ;22             ;RIGHT SIDE OF CHAR MAP MASK

HSLSTEXP: .ds.b     4                      ;HSC DIF LEVEL FLAGS 0 MEANS PRESENT
HSCIN:    .ds.b     1                      ;HSC IN FLAG 0 = NOT PRESENT
DIFNAM:   .ds.b     26      ;31             ;TEMPORARY HSC RAM: DIF NAME 26 BYTES

STATIMER: .ds.b     1                      ;STATE TIMER
JOYCNT:   .ds.b     1                      ;DELAY ON READING JOYSTICK
DEATH:    .ds.b     1                      ;FLAG FOR DEAD BIRD
IOSIM:    .ds.b     1                      ;JOYSTICK SIMULATION BYTE FOR AUTOPLAY
PERIOD:   .ds.b     1                      ;USED BY FREEZE FRAMER
HOWMANY:  .ds.b     1                      ;USED BY FREEZE FRAMER
NEXFRAME: .ds.b     1                      ;WHAT THE FUCK???
FREE:     .ds.b     1                      ;COUNT OF FREE SLOTS
GSCRFLAG: .ds.b     1                      ;FLAG FOR MAINLOOP, SAYING WE SCROLLED
GCOARSE:  .ds.b     1                      ;MORE SCROLLING FLAGS FOR THE MASSES
FUCKFLAG: .ds.b     1       ;11             ;WHO THE FUCK KNOWS!

TRDSPFLG: .ds.b     1       ;1              ;0 = DON'T DISPLAY, <> 0 = DISPLAY

ROTATE:   .ds.b     1                      ;ROTATE HIERO DISPLAY COUNTER

          .ds.b     1                      ;UNUSED
BNSTIMER: .ds.b     1                      ;CURRENT TIMER VALUE FOR B RACK
BNSTIME:  .ds.b     2                      ;PLAYER'S TIME FOR UPCOMING B RACK
BNSHTHS:  .ds.b     1                      ;SCORE FOR BONUS RACK
BNSHUNDS: .ds.b     1
BNSTENS:  .ds.b     1       ;7
SECOND:   .ds.b     1                      ;COUNTER
TUNREPT0: .ds.b     1                      ;TUNE REPEAT COUNTER
TUNREPT1: .ds.b     1                      ;TUNE REPEAT COUNTER
SPHNXNSX: .ds.b     1                      ;SPHINX NOSE X POSITION
SEXP1:    .ds.b     1                      ;SPHINX EXPLOSION INDEX
SEXP2:    .ds.b     1                      ;SPHINX EXPLOSION INDEX
SEXP3:    .ds.b     1                      ;SPHINX EXPLOSION INDEX
WARP:     .ds.b     1                      ;WARP POWER FLAG
ptCount:	.ds.b	1	;Point counter for decrementing.
saveX:		.ds.b	1	;Save x register.
saveY:		.ds.b	1	;Save y register.
helpTime:	.ds.b	1	;Timer for switching in "R BUTTON" message.

ENDRAM18:			;253 used, 5 left free.

MININUMB  EQU     6

          ORG     $1900
DL1:      .ds.b     80                     ;DISPLAY LIST 1
COLSTAT:  .ds.b     63                     ;COLLISION STATUSES
COLX1:    .ds.b     63                     ;COLLISION X'S

SWCHBIO:  .ds.b     1                      ;CURRENT SWCHB IO STATE
OLDSWCHB: .ds.b     1                      ;OLD SWCHB

WAITCNT:  .ds.b     1                      ;WAIT COUNTER
WAVECNT:  .ds.b     1                      ;WAVE PROGRAM COUNTER
WAITING:  .ds.b     1                      ;WAIT COUNTER

PARAM:    .ds.b     1                      ;PARAMETER VALUE FOR MICROROUTINES
SPNCLASS: .ds.b     1                      ;CLASS OF FLEA

SPNX:     .ds.b     1                      ;SPAWN X COORD
SPNY:     .ds.b     1
SPNZ:     .ds.b     1                      ;UPDATE THIS GUYS???

VRUN:     .ds.b     2                      ;VOLUME RUN LENGTH

DBK0:     .ds.b     2                      ;THESE ARE FOR RUNNING THE BACKGROUND
TBINDX0:  .ds.b     2                      ;TUNE IN THE BACKGROUND
CBINDX0:  .ds.b     2
VBINDX0:  .ds.b     2
VBRUN:    .ds.b     2

ENDCOUNT:	.ds.b	1	;Counter that waits for end of game tune.
;
ENDRAM19:         ;219,39 TTL,LEFT


          ORG     $1A00
DL2:      .ds.b     80                     ;DISPLAY LIST 2

COLY1:    .ds.b     63                     ;COLLISION Y'S
COLY2:    .ds.b     63                     ;COLLISON Y EXTENTS
UWESTATE: .ds.b     3                      ;UWESTATES  (SEE UWE DRIVER FOR SPECS.)
UWEOK:    .ds.b     1                      ;CAN WE BRING OUT A UWE?
WANIMCNT: .ds.b     3
UWETYPE:  .ds.b     3                      ;DESIGNATES DIFFICULTY OF UWE
FLEATYPE: .ds.b     8                      ;FLEA TYPE AND SUBTYPE
FXRUN:    .ds.b     8                      ;X VELOCITY
FYRUN:    .ds.b     8                      ;Y    "
FZRUN:    .ds.b     8                      ;Z    "
FLEACNT:  .ds.b     8                      ;TIMERS
ENDRAM1A:         ;256,0 TTL,LEFT


          ORG     $1B00
DL3:      .ds.b     80                     ;DISPLAY LIST 3

COLZ1:    .ds.b     63                     ;COLLISION Z'S
COLZ2:    .ds.b     63                     ;COLLISON Z EXTENTS
PL1LVMAP: .ds.b     10                     ;PLAYER 1 LIVES MAP
BOTMSMAP: .ds.b     20                     ;BOTTOM OF MESSAGE MAP
PL2LVMAP: .ds.b     10                     ;PLAYER 2 LIVES MAP
SPHXSHTD: .ds.b     1                      ;SPHINX SHOT DELAY
SXSHTSTT: .ds.b     4                      ;SPHINX SHOT TABLE
SHOTDEL:  .ds.b     4                      ;SPHINX SHOT TABLE AGAIN
HIEROSLT: .ds.b     1                      ;SLOT NUMBER OF HIERO BEING ANIMATED

ENDRAM1B:         ;256,0 TTL,LEFT


          ORG     $1C00
DL4:      .ds.b     80                     ;DISPLAY LIST 4

SHTBL:    .ds.b     84                     ;HI BYTE OF GRAPHICS.  MIGHT BE ROMMED
DXTBL:    .ds.b     84                     ;Z-X+100'S FOR LOADER
LOWFACE:  .ds.b     1                      ;INDEX OF BOTTOM OF SPHINX FACE
HIFACE:   .ds.b     1                      ;INDEX OF TOP OF SPHINX FACE
FACER:    .ds.b     1                      ;SPHINX FACE ANIMATION
PHASE:    .ds.b     1                      ;0=NORMAL,+=BATTLE,-=BONUS
ENDRAM1C:         ;252,4 TTL,LEFT


          ORG     $1D00
DL5:      .ds.b     80                     ;DISPLAY LIST 5

SMTBL:    .ds.b     84                     ;MAX HIGH BYTE OF GRAPHICS FOR LOADER
                                         ;REF PTS. MIGHT NOT HAVE VALUES HERE

STAMPID:  .ds.b     10                     ;SCROLLING OBJECT BUFFERS
HPOS:     .ds.b     10
ZONESBK:  .ds.b     10
FRBUFSTK: .ds.b     10                     ;STACK OF FREE BUFFER LOCATIONS
FRBUFPTR: .ds.b     1                      ;STACK POINTER

FIRENUMB  EQU     6                      ;NUMBER OF FIREPOT SLOTS
FIRETIP:  .ds.b     FIRENUMB
FIRECOL1: .ds.b     FIRENUMB
FIRECOL2: .ds.b     FIRENUMB
FIREANIM: .ds.b     FIRENUMB
FIREHGHT: .ds.b     FIRENUMB
FIREGOAL: .ds.b     FIRENUMB
FIREMODE: .ds.b     FIRENUMB
ENDRAM1D:         ;247,9  TTL,LEFT


          ORG     $1E00
DL6:      .ds.b     80                     ;DISPLAY LIST 6

XTBL:     .ds.b     84                     ;X POS FOR OBJECTS REF PTS MITE BE NULL
YTBL:     .ds.b     84                     ;Y POS FOR OBJECTS REF PTS AND SHADOWS
ENDRAM1E:         ;248,8  TTL,LEFT        MITE BE NULL


          ORG     $1F00
DL7:      .ds.b     80                     ;DISPLAY LIST 7
ZTBL:     .ds.b     84                     ;Z POS FOR OBJECTS
VPTBL:    .ds.b     84                     ;VPOS FOR LOADER
ENDRAM1F:         ;248,8  TTL,LEFT


          ORG     $2000                  ;ONLY 64 UNSHADOWED BYTES HERE
COLX2:    .ds.b     63                     ;COLLISION X EXTENTS
ENDRAM20:         ;63,1  TTOUT OF 64


          ORG     $2100                  ;ONLY 64 UNSHADOWED BYTES HERE
SVDIST:   .ds.b     4
SVHDIST:  .ds.b     4
PSRANDA1: .ds.b     4
PSRANDA2: .ds.b     4
PSRANDB1: .ds.b     4
PSRANDB2: .ds.b     4
SVGRNDPC: .ds.b     4
SVOBJTYP: .ds.b     4
SVNEWBLK: .ds.b     4
SVBLOCK:  .ds.b     4
SVBAND:   .ds.b     4
VAR1:     .ds.b     1
VAR2:     .ds.b     1
VAR3:     .ds.b     1
VAR4:     .ds.b     1
CRISVARS:
VAR5:     .ds.b     1

JEWCNT:   .ds.b     2                      ;JEWEL COUNTER
EGGCNT:   .ds.b     2                      ;SILVER BAR COUNTER
BARCNT:   .ds.b     2                      ;GOLDEN EGG COUNTER

ENDRAM21:         ;49,15  TTOUT OF 64


          ORG     $2200
DL10:     .ds.b     80                     ;DISPLAY LIST 10
LLTBL:    .ds.b     84                     ;LEFT LINKS IN LIST
SLTBL:    .ds.b     84                     ;LOW BYTE OF GRAPHICS FOR LOADER

HSGAMDAT  EQU     DL10                   ;HSC DATA FIELDS: MAX LENGTH 2 PAGES

ENDRAM22:         ;248,8  TTL,LEFT


          ORG     $2300
DL11:     .ds.b     80                     ;DISPLAY LIST 11

DLY:      .ds.b     20                     ;DISPLAY LIST FOR SCORE
DLZ:      .ds.b     20                     ;DISPLAY LIST FOR EXTRA BIRDS
PWTBL:    .ds.b     84                     ;PALLETTE/WIDTH FOR LOADER
SLOTQ:    .ds.b     43                     ;SHOULD EQUAL PYRSTOP-PYRSTART+1
SLOTGPTR: .ds.b     1                      ;POINTER TO FIRST AVAILABLE SLOT
SLOTRPTR: .ds.b     1                      ;POINTER TO FIRST EMPTY POSITION
ENDRAM23:         ;249,7  TTL,LEFT


          ORG     $2400
ZBUFF0:   .ds.b     33                     ;CHARACTER BUFFERS
ZBUFF1:   .ds.b     33                     ;ALSO USED FOR TITLE PAGE SHIT
ZBUFF2:   .ds.b     33
ZBUFF3:   .ds.b     33
ZBUFF4:   .ds.b     33
ZBUFF5:   .ds.b     33
ZBUFF6:   .ds.b     33

WINGMAP0  EQU     ZBUFF0                 ;TITLE PAGE MAPS USE SAME RAM AS GAME
WINGMAP1  EQU     ZBUFF1                 ;PLAY MAPS
WINGMAP2  EQU     ZBUFF2
WINGMAP3  EQU     ZBUFF3
WINGMAP4  EQU     ZBUFF4
WINGMAP5  EQU     ZBUFF5
CRSTMAP1  EQU     ZBUFF6
CRSTMAP2  EQU     CRSTMAP1+12            ;MOST OF THESE LABELS CAN GO AWAY
CRSTMAP3  EQU     CRSTMAP2+10            ;BECAUSE THE CREST IS PRETTY MUCH
CRSTMAP4  EQU     CRSTMAP3+4             ;HARDWIRED IN SINIT
CRSTMAP5  EQU     CRSTMAP4+2

PTIMER:   .ds.b     1                      ;POWER TIMER

TPSTART:                                 ;BEGINNING OF TIMED POWER FLAGS
NOHOMING: .ds.b     1
CANTHOP:  .ds.b     1
CANTSWIM: .ds.b     1
CANTFLY:  .ds.b     1
HOVER:    .ds.b     1
SPEEDUP:  .ds.b     1
SLOWDOWN: .ds.b     1
QUIKSHOT: .ds.b     1
INVINCBL: .ds.b     1
TPSTOP:
PARASPHX: .ds.b     1

TPNUMB    EQU     TPSTOP-TPSTART         ;NUMBER OF TIMED POWER FLAGS

ENDRAM24:         ;242,14 TTL,LEFT


          ORG     $2500
ZBUFF7:   .ds.b     33                     ;MORE CHARACTER MAP BUFFERS
ZBUFF8:   .ds.b     33
ZBUFF9:   .ds.b     33
ZBUFFA:   .ds.b     33
ZBUFFB:   .ds.b     33
CRMAP     EQU     ZBUFF8                 ;CRIGHT MESSAGE MAP
NOVMAP    EQU     ZBUFF9                 ;NOVICE MAP
STDMAP    EQU     NOVMAP+6               ;STANDARD MAP
ADVMAP    EQU     STDMAP+8               ;ADVANCED MAP
EXPMAP    EQU     ADVMAP+8               ;EXPERTMAP

HPTBL:    .ds.b     84                     ;HPOS FOR LOADER

ENDRAM25:         ;251,5  TTL,LEFT


          ORG     $2600

DL8:      .ds.b     80                     ;DISPLAY LIST 8

RLTBL:    .ds.b     84                     ;RIGHT LINKS IN LIST
DFTBL:    .ds.b     84                     ;FAR DX TABLE
ENDRAM26:         ;248,8  TTL,LEFT


          ORG     $2700
DL9:      .ds.b     80                     ;DISPLAY LIST 9
DLLIST:   .ds.b     84                     ;DISPLAY LIST LIST. DEFINED TO ACCOM.
                                         ;PAL DLLIST + 3 EXTRA FOR YUCKS
NULHDR:   .ds.b     2                      ;HEADER OF TWO ZEROS

ENDRAM27:         ;166,90 TTL,LEFT

          ORG     $7000                  ;FOR RAM CARD ONLY!!!!!!!!!!!!!!
TESTLIST: .ds.b     84                     ;FOR LINKED LIST DIAGNOSTICS
ORDTEST:  .ds.b     84                     ;FOR LINKED LIST DIAGNOSTICS

;          END

