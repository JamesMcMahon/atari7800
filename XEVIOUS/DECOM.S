*DECOM
          ZEROPAGE
          GTARGLBL
          MAPGLBL                        public
          GODGLBL                        extrn
          PLAYGLBL
          HEADGLBL
          MAPVGLBL
          FLAGGLBL
          EXTRN   SEQPTRH,SEQPTRL        cships
          EXTRN   GETTARG                decsubr
          EXTRN   RANDOM,RNDM

******************************************
RAM2      CSECT
FLAGFLAG  DS      1
FLAGYPOS  DS      1
FLAGXPOS  DS      1
FLAGPTRH  DS      1
FLAGPTRL  DS      1

NEWCITAD  EQU     $FF                    ;full timer value
CITATIME  DS      1

******************************************
* GROUND TARGET SECRET CODES (SSHHHH!)
*         0       regular dome           logram
*         1       regular pyramid        barra
*         2       detector dome          zolbak (and your mama, too)
*         3       small defense site     derota
*         4       Orange Julius stand    berra
*         5       rest area              gasfoodphone
*         6       citadel                sittuhdell
*         7       flag                   frag
*         8       ctr of dome complex    da-da
*         9       left of dome complex   athos
*         A       right of dome complex  porthos
*         B       top of dome complex    aramis
*         C       bottom of dome complex d'artagnan
*         D       lahge pyramid          garu barra
*         E       lahge defense site     garu derota
*         F       crater                 bigg hoel
******************************************
CODE9000  CSECT
ATOPDECO

*  SHIFTBIT SUBROUTINE.  THIS ROUTINE SHIFTS THE LONG BIT STRING USED IN
*  COMPRESSING THE MAP.  THE CARRY IS SET TO THE BIT SHIFTED OUT.
*  THE Y REGISTER MUST = 0 WHEN THIS ROUTINE IS CALLED.
*  ESTIMATED TIME - 25 CYCLES 7 OUT OF 8 TIMES, 56 CYCLES 1 OUT OF 8, 29 AVG
*
SHIFTBIT  DEC     BITSLEFT               ; NUMBER OF BITS LEFT IN CURRENT BYTE.
          BPL     SHIFTBT                ; LOAD IN THE NEXT BYTE IF NO MORE BITS
          LDA     (BITPTRL),Y            ; ARE LEFT IN THE CURRENT BYTE.
          STA     WORKBYTE
          CLC
          LDA     BITPTRL                ; THE LOW BYTE OF MPTR MUST BE
          ADC     #1                     ; INCREMENTED IN THE ACCUMULATOR SO
          STA     BITPTRL                ; THAT THE CARRY BIT IS SET.
          BCC     STOBITSL
          INC     BITPTRH
STOBITSL  LDA     #7
          STA     BITSLEFT
SHIFTBT   ASL     WORKBYTE               ; C <-- W7...W0 <-- 0
          RTS


********************************************************************************
*  THIS IS THE MULTI-PLAYFIELD VERSION OF DECOMPRESS.  IN THIS VERSION THERE IS
*  NO EXPLICIT BOUND ON THE NUMBER OF PLAYFIELD HEADERS, ALTHOUGH THE TABLE
*  SIZES CURRENTLY ALLOW AT MOST 3 PLAYFIELD HEADERS.  (WITH CAREFUL PLACEMENT
*  OF GROUND TARGETS MORE THAN 3 PLAYFIELDS ARE NOT NECESSARY.)  ALLOWING 4
*  PLAYFIELD HEADERS WOULD MAKE IT POSSIBLE TO POSITION GROUND TARGETS ALMOST
*  ARBITRARILY.
********************************************************************************
CONVERT
MAPINIT
* THIS ROUTINE IS USED FOR INITIALIZING THE MAP.  IT SHOULD BE CALLED AT THE
* START OF A NEW GAME.
*
MAPINIT2  LDA     #$FF;FF                ; RACK WILL BE INCREMENTED TO 0 WHEN
          LDX     MODE
          CPX     #MAUTO
          BNE     STARACK
          JSR     RANDOM
          AND     #$07
          TAX                            ;-1  TO 6
          DEX
          TXA
STARACK
          STA     RACK                   ; GETMAPRW IS CALLED NEXT.
          STA     RACK-NMPLVARS
          LDA     #L(GETMPRW0)
          STA     MAPBRADL
          LDA     #H(GETMPRW0)
          STA     MAPBRADH
          JMP     ZNEWRACK
*
* THIS ROUTINE IS CALLED WHEN A PLAYER IS KILLED.  WE EITHER RESTART THE
* CURRENT RACK OR SKIP AHEAD TO THE NEXT ONE, DEPENDING UPON HOW CLOSE TO THE
* END HE GOT.
*
KILLPLAY
          LDA     CURROW
          CMP     #NEWRACK
          BPL     ZNEWRACK
          DEC     RACK
          LDA     RACK
          TAX
          LDA     SEQPTRL,X
          STA     RACKSEQU
          LDA     SEQPTRH,X
          STA     RACKSEQU+1
          LDA     #L(GETMPRW0)
          STA     MAPBRADL
          LDA     #H(GETMPRW0)
          STA     MAPBRADH
ZNEWRACK  LDA     #18                    ; START THE RACK WITH 1 1/2 SCREENS
          STA     TREEROWS               ; OF TREES.
          LDA     #$00                   ; MAKE IT LOOK LIKE WE JUST COMPLETED A
          STA     DOTREES                ; SCAN.
          STA     TARG2CNT
          LDA     #1
          STA     ROWCNT
          RTS
********************************************************************************
*
* THIS CODE IS CALLED BY THE LOADER WHEN IT NEEDS A NEW MAP ROW.  IT SETS UP
* THE PLAYFIELD HEADERS NEEDED BY THE LOADER, INCLUDING THE SET UP OF GROUND
* TARGETS.  THE PLAY CODE IS INFORMED OF THE TYPES AND LOCATIONS OF THE GROUND
* TARGETS.
*
GETMAPRW  JMP     (MAPBRADL)
GETMPRW0  DEC     ROWCNT
          BEQ     ZSKIP1
          JMP     DECOMPRS               ; CONTINUE WITH CURRENT SCAN
ZSKIP1    LDA     #0                     ; SET UP A NEW SCAN OF THE MAP
          STA     SBITSLFT               ; ALL VALUES OF BITSLEFT MUST BE SET
          STA     SBITSLFT+1             ; TO 0 AT START OF A NEW SCAN.
          STA     SBITSLFT+2
          LDX     #DECWIDTH-1            ; SET MAPLINE TO TREES
          LDA     #TREES
ZCLRMAPL  STA     MAPLINE,X
          DEX
          BPL     ZCLRMAPL
          LDA     DOTREES                ; ARE WE DOING THE FOREST BETWEEN RACKS
          BNE     MAINSCAN               ; OR THE MAIN MAP AFTER THE FOREST?
          LDA     #H(ZMAPC9)             ; WAS NOT DOING FOREST, SO WE ARE NOW.
          STA     SMPTRH+1               ; SET UP THE POINTERS TO POINT TO THE
          LDA     #L(ZMAPC9)             ; COMPRESSED FOREST DATA.
          STA     SMPTRL+1
          LDA     #H(ZMAPC10)
          STA     SMPTRH
          LDA     #L(ZMAPC10)
          STA     SMPTRL
          LDA     #H(ZMAPB9)
          STA     SBPTRH+1
          LDA     #L(ZMAPB9)
          STA     SBPTRL+1
          LDA     #H(ZMAPB10)
          STA     SBPTRH
          LDA     #L(ZMAPB10)
          STA     SBPTRL
          LDA     #1                     ; THE FOREST IS TWO STRIPS WIDE
          STA     NOSTRIPS
          LDA     TREEROWS               ; THE NUMBER OF ROWS OF FOREST
          STA     ROWCNT
          LDA     #5                     ; CURROW NORMALLY STARTS AT 0 FOR THE
          SEC                            ; START OF A RACK BUT STARTS AT -12 FOR
          SBC     ROWCNT                 ; THE BEGINNING OF A GAME OR AFTER THE
          STA     CURROW                 ; PLAYER GETS KILLED.
          LDA     #6                     ; THE USUAL NUMBER OF ROWS OF FOREST
          STA     TREEROWS
          LDA     #$FF
          STA     DOTREES                ; WE'RE CURRENTLY DOING TREES.
          LDA     #0
          STA     BEGINCOL
          INC     RACK
          LDY     RACK                   ; IF WE'RE PAST THE LIMIT RESTART RACK
          CPY     #NUMRACK               ; AT RACKCYCL.
          BMI     ZSKIP2
          LDY     #RACKCYCL
          TYA
          STA     RACK
ZSKIP2
          LDA     RACK
          TAX
          LDA     SEQPTRL,X
          STA     RACKSEQU
          LDA     SEQPTRH,X
          STA     RACKSEQU+1
          LDA     TARGPTRL,Y             ; INITIALIZE THE POINTER TO THE FIXED
          STA     TRCTYPL                ; GROUND TARGET LIST FOR THIS RACK.
          LDA     TARGPTRH,Y
          STA     TRCTYPH
          JSR     GETTARG
          JMP     DECOMPRS
MAINSCAN                                 ; WE'RE STARTING THE MAIN SCAN OF A
          LDX     RACK                   ; RACK (THE PART AFTER THE FOREST).
          LDA     RACKCOL,X
          TAX                            ; THE LEFTMOST COLUMN OF THE SCAN
          LDY     #2                     ; USUAL NUMBER OF STRIPS PER SCAN = 3
          AND     #$07                   ; LOW 3 BITS = BEGINNING COL WITHIN
          STA     BEGINCOL               ; LEFTMOST STRIP.
          BNE     ZGTSTRPS
          LDY     #1                     ; TWO STRIPS IF COLUMN MOD 8 = 0
ZGTSTRPS  STY     NOSTRIPS
          TXA
          LSR     A                      ; FLOOR(COLUMN/8) = FIRST STRIP
          LSR     A
          LSR     A
          TAX
          LDY     NOSTRIPS
ZSTRPLP   LDA     STRIPCH,X
          STA     SMPTRH,Y
          LDA     STRIPCL,X
          STA     SMPTRL,Y
          LDA     STRIPBH,X
          STA     SBPTRH,Y
          LDA     STRIPBL,X
          STA     SBPTRL,Y
          INX
          DEY
          BPL     ZSTRPLP
          LDA     #$00
          STA     DOTREES                ; WE'RE NOT DOING THE FOREST ANYMORE.
          LDA     #MAPROWS
          STA     ROWCNT
*
* DECOMPRESS A 16 OR 24 STAMP LINE, ONE 8 STAMP STRIP AT A TIME.
* THE DECOMPRESSED LINE IS STORED IN THE ARRAY MAPLINE.
* ONLY THE 16 STAMPS BEGINNING AT POSITION "BEGINCOL" WITHIN MAPLINE ARE
* ACTUALLY USED IN THE DISPLAY.  THE REASON THAT 24 STAMPS MAY HAVE TO BE
* DECOMPRESSED IS THAT IN GENERAL THE SUCCESSIVE PASSES OVER THE MAP DON'T
* ALIGN WITH THE BOUNDARIES OF THE 8 COLUMN WIDE STRIPS OF WHICH THE MAP IS
* COMPOSED.  SO IN THE TYPICAL CASE THE 16 STAMP DISPLAY LINE WILL STRADDLE
* PART OF A FIRST STRIP, ALL OF A SECOND, AND PART OF A THIRD.
*
DECOMPRS  INC     CURROW
          LDX     #0                     ; X is the column of MAPLINE
          LDY     NOSTRIPS               ; STRIPCNT is 2 or 3
          STY     STRIPCNT
STRPLOOP  STX     HOLDX
          LDA     #L(GETMPRW1)
          STA     MAPBRADL
          LDA     #H(GETMPRW1)
          STA     MAPBRADH
          RTS
**************************************
GETMPRW1
          LDX     HOLDX
          LDY     STRIPCNT
          LDA     SMPTRL,Y               ; Load the working storage for the
          STA     MPTRL                  ; current strip into page 0.
          LDA     SMPTRH,Y
          STA     MPTRH
          LDA     SBPTRL,Y
          STA     BITPTRL
          LDA     SBPTRH,Y
          STA     BITPTRH
          LDA     SWORKBYT,Y
          STA     WORKBYTE
          LDA     SBITSLFT,Y
          STA     BITSLEFT
          LDY     #0                     ; Y must = 0 throughout inner loop
          LDA     #GRASS                 ; For decompression purposes we pretend
          STA     LEFTSTMP               ; there's a column of grass stamps on
          LDA     #STRWIDTH              ; the left.  There are 8 columns per
          STA     COLCOUNT               ; strip.
                                         ;ITS NOT BITSLEFT,STRIPCNT
*         LDA     STRIPCNT
*         STA     TEMPSAV1
*         RTS
*         LDY     TEMPSAV0
*         LDX     HOLDX
*         LDA     TEMPSAV1
*         STA     STRIPCNT
*
* Each interation of the loop that follows decompresses one stamp.
*
ONESTAMP                                 ; A 1 in the bitstring means that the
                                         ; stamp below is copied up, which is
                                         ; accomplished by leaving MAPLINE as it
                                         ; is.
*  SHIFTBIT SUBROUTINE.  THIS ROUTINE SHIFTS THE LONG BIT STRING USED IN
*  COMPRESSING THE MAP.  THE CARRY IS SET TO THE BIT SHIFTED OUT.
*  THE Y REGISTER MUST = 0 WHEN THIS ROUTINE IS CALLED.
*  ESTIMATED TIME - 25 CYCLES 7 OUT OF 8 TIMES, 56 CYCLES 1 OUT OF 8, 29 AVG
*
          DEC     BITSLEFT               ; NUMBER OF BITS LEFT IN CURRENT BYTE.
          BPL     SHIFTBT0               ; LOAD IN THE NEXT BYTE IF NO MORE BITS
          LDA     (BITPTRL),Y            ; ARE LEFT IN THE CURRENT BYTE.
          STA     WORKBYTE
          CLC
          LDA     BITPTRL                ; THE LOW BYTE OF MPTR MUST BE
          ADC     #1                     ; INCREMENTED IN THE ACCUMULATOR SO
          STA     BITPTRL                ; THAT THE CARRY BIT IS SET.
          BCC     STOBITL
          INC     BITPTRH
STOBITL   LDA     #7
          STA     BITSLEFT
SHIFTBT0  ASL     WORKBYTE               ; C <-- W7...W0 <-- 0

          BCS     ZSTRLEFT               ; stamp below is copied up, which is
                                         ; accomplished by leaving MAPLINE as it
                                         ; is.
*  SHIFTBIT SUBROUTINE.  THIS ROUTINE SHIFTS THE LONG BIT STRING USED IN
*  COMPRESSING THE MAP.  THE CARRY IS SET TO THE BIT SHIFTED OUT.
*  THE Y REGISTER MUST = 0 WHEN THIS ROUTINE IS CALLED.
*  ESTIMATED TIME - 25 CYCLES 7 OUT OF 8 TIMES, 56 CYCLES 1 OUT OF 8, 29 AVG
*
          DEC     BITSLEFT               ; NUMBER OF BITS LEFT IN CURRENT BYTE.
          BPL     SHIFTBT1               ; LOAD IN THE NEXT BYTE IF NO MORE BITS
          LDA     (BITPTRL),Y            ; ARE LEFT IN THE CURRENT BYTE.
          STA     WORKBYTE
*         CLC
          LDA     BITPTRL                ; THE LOW BYTE OF MPTR MUST BE
          ADC     #1                     ; INCREMENTED IN THE ACCUMULATOR SO
          STA     BITPTRL                ; THAT THE CARRY BIT IS SET.
          BCC     STOBITS
          INC     BITPTRH
STOBITS   LDA     #7
          STA     BITSLEFT
SHIFTBT1  ASL     WORKBYTE               ; C <-- W7...W0 <-- 0

          BCC     NOCOMPR
          LDA     LEFTSTMP               ; A 0 followed by a 1 in the bitstring
          STA     MAPLINE,X              ; means that the stamp on the left is
          JMP     INCX                   ; copied over.
NOCOMPR   LDA     (MPTRL),Y              ; Two 0's in a row in the bitstring
          STA     MAPLINE,X              ; means there is no compression; the
          STA     LEFTSTMP               ; NEXT BYTE POINTED AT BY MPTR IS
          LDA     MPTRL                  ; LOADED INTO MAPLINE.
*         CLC
          ADC     #1                     ; MPTR is then incremented.  The
          STA     MPTRL                  ; increment of the low byte must be
          BCC     INCX                   ; done in the accumulator because INC
          INC     MPTRH                  ; doesn't set the carry bit.
          JMP     INCX
ZSTRLEFT  LDA     MAPLINE,X
          STA     LEFTSTMP
INCX      INX
          DEC     COLCOUNT               ; Do next column of strip
          BEQ     FOGEL
          LDA     COLCOUNT
          CMP     #$04
          BNE     ONESTAMP
          LDA     #L(GETMPR1A)
          STA     MAPBRADL
          LDA     #H(GETMPR1A)
          STA     MAPBRADH
          STY     TEMPSAV0
          STX     TEMPSAV1
          RTS

**************************************
GETMPR1A
          LDX     TEMPSAV1
          LDY     TEMPSAV0
          LDA     #$04
          STA     COLCOUNT
          BNE     ONESTAMP               ;BRANCH ALWAYS
*
* END OF INNER DECOMPRESSION LOOP.
*
FOGEL
          LDY     STRIPCNT               ; Move the working storage back into
          LDA     MPTRL                  ; the holding area.
          STA     SMPTRL,Y
          LDA     MPTRH
          STA     SMPTRH,Y
          LDA     BITPTRL
          STA     SBPTRL,Y
          LDA     BITPTRH
          STA     SBPTRH,Y
          LDA     WORKBYTE
          STA     SWORKBYT,Y
          LDA     BITSLEFT
          STA     SBITSLFT,Y
          DEY                            ; Count down to next strip
          STY     STRIPCNT
          BMI     Z1SKIP
          JMP     STRPLOOP
Z1SKIP    LDA     NOSTRIPS               ; IN ORDER TO MAKE THE NUMBER OF CALLS
          CMP     #2                     ; TO GETMAPRW A CONSTANT WE NEED AN
          BEQ     GETMPR2A               ; EXTRA RETURN FOR THE CASE WHERE ONLY
          LDA     #L(GETMPRW2)           ; 2 STRIPS WERE DECOMPRESSED RATHER
          STA     MAPBRADL               ; THAN 3.
          LDA     #H(GETMPRW2)
          STA     MAPBRADH
          RTS
**************************************
GETMPRW2  LDA     #L(GETMPR2A)
          STA     MAPBRADL
          LDA     #H(GETMPR2A)
          STA     MAPBRADH
          RTS
*******************************
GETMPR2A  LDA     #L(GETMPRW3)
          STA     MAPBRADL
          LDA     #H(GETMPRW3)
          STA     MAPBRADH
          RTS
**************************************
*
* NOW THE FIXED GROUND TARGETS ARE SET UP.
*
GETMPRW3
*HACK
*         LDA     NGTARCNT
*         STA     GTARGCNT
          LDX     #DECWIDTH+2            ; ZERO OUT TARGLINE AND RESET THE
          LDA     #0                     ; COUNT OF TARGETS IN THIS ROW.
ZERTARGL  STA     TARGLINE,X
          DEX
          BPL     ZERTARGL

SETTARGL  LDA     TARGROW                ; KEEP LOADING UP TARGETS UNTIL
          CMP     CURROW                 ; THE NEXT TARGET IS AT A HIGHER ROW
          BEQ     ZYQ                    ; THAN THE CURRENT ROW.
          JMP     DOHEADRS
ZYQ       LDA     TARGCOL
          CLC
          ADC     BEGINCOL
          STA     TEMP                   ; TEMP = POSITION OF TARGET WITHIN
                                         ;        MAPLINE.
          TAX
          LDY     TARGTYPE
          LDA     TSTMPX1,Y              ; STORE THE STAMP OR STAMPS APPROPRIATE
          STA     TARGLINE,X             ; TO THE TARGET TYPE.
          LDA     TSTMPX2,Y              ; IF TSTMPX2 IS 0 THERE IS NO SECOND
          BEQ     ZCONVDOM               ; STAMP.
          STA     TARGLINE+1,X
ZCONVDOM  CPY     #DCMPLXPE              ; IF THE TARGET TYPE IS ONE OF THE 4
          BMI     ZINFPLAY               ; DOME COMPLEX PERIPHERAL DOMES MAKE IT
          CPY     #DCMPLXPE+4            ; A CANONICAL TYPE.  (THE PLAY CODE
          BPL     ZINFPLAY               ; DOESN'T CARE ABOUT THE DISTINCTION
          LDY     #DCMPLXPE              ; BETWEEN THE FOUR DOMES.)

*HACK NGTARCNT AND GTARGCNT HAVE BEEN REVERSED IN THE FOLLOWING LINES
ZINFPLAY  INC     NGTARCNT
          LDX     NGTARCNT
*INFPLAY  INC     GTARGCNT              ; LOAD UP THE TABLES USED BY THE PLAY
*         LDX     GTARGCNT               ; CODE.
*         INX
*         STX     NGTARCNT
*END OF HACK!

          TYA
          STA     GTARTYPE-1,X
*NOW PUT IN FIRING INFORMATION
          BEQ     CANFIRE                ;DOME
          CMP     #3                     ;MINI HOSER
          BEQ     CANFIRE
          CMP     #5                     ;MEGA HOSER
          BEQ     CANFIRE
          CMP     #8
          BCC     CANTFIRE               ;CENTER OF COMPLEX IS AN 8
          CMP     #$D
          BCS     CANTFIRE               ;BOTTOM OF COMPLEX IS A 12
CANFIRE   LDA     RNDM
          AND     #$01
          CLC
          ADC     #$01
          STA     FGTSPRT-1,X
          JSR     RANDOM
          AND     #$1F
          ADC     #06
          STA     FGTTIME-1,X
          LDA     RACK
          BNE     ZX
          LDA     CURROW
          CMP     #55
          BCS     ZX
          LDA     #$C0
          ADC     FGTTIME-1,X
          STA     FGTTIME-1,X
          JMP     ZX

CANTFIRE  LDA     #$FF
          STA     FGTSPRT-1,X

ZX
          LDA     DIFCULTY
          CMP     #$02
          BCS     ZX2
          LDA     FGTTIME-1,X
;         CLC
          ADC     #$20
          BCC     ZX1
          LDA     #$F0

ZX1       STA     FGTTIME-1,X

ZX2
          LDA     TEMP                   ; ONCE WE KNOW WHICH HEADER DISPLAYS
          STA     GTARPTRL-1,X           ; THIS TARGET AND WHERE IT BEGINS WE
                                         ; WILL USE THE TARGET COLUMN TO GET
                                         ; THE PTR TO THE TARGET STAMP INDEX.
          LDA     TARGCOL
          ASL     A                      ; PIXELPOS = 8*STAMP_COLUMN + FIRSTPXL
          ASL     A
          ASL     A                      ; CARRY = 0 AT THIS POINT
          ADC     #FIRSTPXL
          STA     GTARPOS-1,X
          LDA     #$00
          STA     CRATSTMP-1,X           ;SHOWS IT'S NOT TO BE ANIMATED

ZPOSNORM  LDA     TARGID
          STA     GTARGID-1,X

*MUST ACCOUNT FOR LARGE HOSER AND PYRAMID
          LDA     #TOPPIXEL              ; GROUND TARGETS ALWAYS START FROM
          STA     GTARVPOS-1,X           ; THE TOP OF THE SCREEN.
          CPY     #14                    ;Y CONTAINS GTARTYPE
          BEQ     POSNNORM
          CPY     #13
          BEQ     POSNNORM
          CPY     #4
          BEQ     POSNNORM
          CPY     #5
          BNE     ZNXTTARG
POSNNORM  LDA     GTARPOS-1,X
          CLC
          ADC     #4
          STA     GTARPOS-1,X
          LDA     GTARVPOS-1,X
          CPY     #$05                   ;TOP
          BEQ     POSUP
          CPY     #$04                   ;TOP
          BEQ     POSUP
POSDWN
          CLC
          ADC     #11
          JMP     ZYUKK

POSUP
*         LDA     GTARVPOS-1,X
          SEC
          SBC     #5
ZYUKK     STA     GTARVPOS-1,X

ZNXTTARG
          LDA     FLAGFLAG
          CMP     #$01
          BNE     ZNOOFLAG
          LDA     #$02
          STA     FLAGFLAG
          LDA     GTARPOS-1,X
          STA     FLAGXPOS
          LDA     GTARVPOS-1,X
          STA     FLAGYPOS

ZNOOFLAG
          JSR     GETTARG
          JMP     SETTARGL
*
* FIGURE OUT WHAT PLAYFIELD HEADERS ARE NEEDED AND WHICH STAMPS ARE DISPLAYED
* BY WHICH HEADERS.  THERE ARE TWO TYPES OF HEADERS - "GREEN" HEADERS, WHICH
* USE THE LT. GREEN, DK. GREEN, AND BLUE PALETTE, AND "GRAY" HEADERS, WHICH USE
* THE WHITE, LT. GRAY, AND DK. GRAY PALETTE.  MOST OF THE MAP USES THE GREEN
* PALETTE; THE DOCKS, AIRPORT, AND GROUND TARGETS USE THE GRAY HEADER.
* "GREEN" STAMPS (THOSE REQUIRING THE GREEN PALETTE) ALL HAVE INDICES LESS
* THAN CLRSTMP (THE INDEX OF THE CLEAR, I.E., TRANSPARENT, STAMP).  "GRAY"
* STAMPS ALL HAVE INDICES GREATER THAN CLRSTMP.  THE CLEAR STAMP IS NOT
* REGARDED AS BELONGING TO EITHER PALETTE.  (THE BACKGROUND COLOR IS BROWN;
* THAT IS THE COLOR THAT APPEARS WHEN NO GREEN OR GRAY STAMP IS USED.)
* THE METHOD FOR DETERMINING THE NUMBER AND POSITIONING OF THE GREEN HEADERS
* IS AS FOLLOWS.  STARTING FROM THE LEFT, A NEW GREEN HEADER IS STARTED AT THE
* FIRST GREEN STAMP.  THIS HEADER CONTINUES UNTIL THE FIRST GAP OF 3 OR MORE
* NON-GREEN STAMPS OCCURS.  WHEN SUCH A GAP IS FOUND THE OLD GREEN HEADER IS
* TERMINATED AT THE LAST GREEN STAMP BEFORE THE GAP AND A NEW GREEN HEADER IS
* STARTED AT THE FIRST GREEN STAMP AFTER THE GAP (IF THERE IS ONE).  THIS
* PROCESS CONTINUES UNTIL THE ENTIRE 16 STAMP LINE HAS BEEN PROCESSED.
* THE RATIONALE IS THAT FEWER DMA CYCLES ARE USED IN STARTING UP A NEW HEADER
* THAN ARE USED IN DISPLAYING A BUNCH OF CLEAR STAMPS.  (A NEW HEADER
* REQUIRES 12 MARIA CYCLES TO START UP, EACH INDIRECT STAMP REQUIRES 9 CYCLES.
* EVEN MORE DMA CYCLES WOULD BE CONSERVED IF NEW HEADERS WERE CREATED AFTER
* GAPS OF LENGTH 2.  A GAP SIZE OF 3 WAS CHOSEN AS A COMPROMISE TO PREVENT A
* PROLIFERATION OF TOO MANY HEADERS.)
* THE GRAY HEADERS ARE SET UP IN THE SAME WAY, WITH GROUND TARGETS COUNTED AS
* GRAY STAMPS.  GRAY HEADERS APPEAR AFTER ALL GREEN HEADERS IN THE DISPLAY LIST.
* IT IS THE RESPONSIBILITY OF THE MAP MAKER AND TARGET POSITIONER TO MAKE SURE
* THAT THE CURRENT LIMITATION ON NUMBER OF HEADERS IS NOT EXCEEDED AFTER THIS
* ALGORITHM IS APPLIED.  IT IS ALSO NECESSARY TO ENSURE THAT THE TOTAL NUMBER
* OF INDIRECT STAMPS DISPLAYED DOES NOT EXCEED 24.
*
DOHEADRS  LDA     #L(GETMPRW4)
          STA     MAPBRADL
          LDA     #H(GETMPRW4)
          STA     MAPBRADH
          RTS
*******************************
GETMPRW4  LDX     BEGINCOL
          TXA
          CLC
          ADC     #DISWIDTH              ; TEMP = THE POSITION IN MAPLINE OF
          STA     TEMP                   ; THE STAMP AFTER THE LAST DISPLAYED
                                         ; STAMP.
          DEX
          LDA     #CLRSTMP               ; SET 3 STAMPS AFTER THE 16 DISPLAYED
          STA     MAPLINE+DISWIDTH+1,X   ; STAMPS TO CLEAR IN ORDER TO FORCE
          STA     MAPLINE+DISWIDTH+2,X   ; HEADERS TO TERMINATE AT THE END OF
          STA     MAPLINE+DISWIDTH+3,X   ; THE 16 STAMPS.
          LDY     #0                     ; Y = # OF HEADERS
ZHLOOP1   INX
          CPX     TEMP
          BPL     ZHEND1
          LDA     MAPLINE,X              ; FIND NEXT GREEN STAMP.
          CMP     #CLRSTMP
          BCS     ZHLOOP1
          TXA
          STA     HLEFT,Y
ZHLOOP2   INX                            ; FIND NEXT GAP OF 3 NON-GREEN STAMPS.
*         LDA     #CLRSTMP
*         CMP     MAPLINE,X
*         BCS     ZHLOOP2
*         CMP     MAPLINE-1,X
*         BCS     ZHLOOP2
*         CMP     MAPLINE-2,X
*         BCS     ZHLOOP2

          LDA     MAPLINE,X
          CMP     #CLRSTMP
          BCC     ZHLOOP2
          LDA     MAPLINE-1,X
          CMP     #CLRSTMP
          BCC     ZHLOOP2
          LDA     MAPLINE-2,X
          CMP     #CLRSTMP
          BCC     ZHLOOP2

          TXA
*         SEC
          SBC     #3                     ; C = 1 AT THIS POINT.
          STA     HRIGHT,Y               ; X IS 3 BEYOND THE END OF THE LAST
          INY                            ; GREEN HEADER AT THIS POINT.
          JMP     ZHLOOP1
ZHEND1    STY     GREENCNT               ; THE NUMBER OF GREEN HEADERS.
                                         ;THIS IS ALSO USED AS A Y HOLDER
          LDA     TEMP
          STA     TEMPSAV0               ;SAVE TEMP FOR NEXT PASS
          LDA     #L(GETMPR4A)
          STA     MAPBRADL
          LDA     #H(GETMPR4A)
          STA     MAPBRADH
          RTS


**************************************
GETMPR4A
          LDY     GREENCNT               ;GET BACK OLD Y
          LDA     TEMPSAV0               ;AND OLD TEMP
          STA     TEMP
          LDX     BEGINCOL
          DEX
ZHLOOP3   INX
          CPX     TEMP
          BPL     ZHEND2
          LDA     MAPLINE,X              ; FIND NEXT GRAY STAMP.
          CMP     #PAL2STMP
          BCS     ZHEND3
          LDA     TARGLINE,X
          BEQ     ZHLOOP3
ZHEND3    TXA
          STA     HLEFT,Y
ZHLOOP4   INX                            ; FIND NEXT GAP OF 3 NON-GRAY STAMPS

          LDA     MAPLINE,X
          CMP     #PAL2STMP
          BCS     ZHLOOP4
          LDA     TARGLINE,X
          BNE     ZHLOOP4
          LDA     MAPLINE-1,X
          CMP     #PAL2STMP
          BCS     ZHLOOP4
          LDA     TARGLINE-1,X
          BNE     ZHLOOP4
          LDA     MAPLINE-2,X
          CMP     #PAL2STMP
          BCS     ZHLOOP4
          LDA     TARGLINE-2,X
          BNE     ZHLOOP4

          TXA
          SEC
          SBC     #3
          STA     HRIGHT,Y
          INY
          JMP     ZHLOOP3
ZHEND2    STY     HCOUNT                 ; THE TOTAL NUMBER OF HEADERS.

*
* SET UP THE STAMP LISTS FOR THE LOADER.  INFORMATION ABOUT THE HEADERS IS
* PASSED TO THE LOADER IN THE FOLLOWING ARRAYS:
* PALW - THE PALETTE AND WIDTH BYTE
* HPOS - THE STARTING PIXEL POSITION.
* CPTRL, CPTRH - THE LOW AND HIGH BYTES OF THE POINTER INTO THE CHARACTER MAP
*
* THE SCALAR HCOUNT GIVES THE TOTAL NUMBER OF HEADERS (IN THE RANGE 0..3).
* THE SCALAR HDRSTMPS GIVES THE TOTAL NUMBER OF INDIRECT STAMPS DISPLAYED BY
* ALL HEADERS FOR THE ZONE.
*
DOSTPLST  LDA     #L(GETMPRW5)
          STA     MAPBRADL
          LDA     #H(GETMPRW5)
          STA     MAPBRADH
          RTS
**************************************
GETMPRW5  LDY     #0                     ; SET UP THE STAMP LISTS FOR ALL GREEN
          LDX     #0                     ; HEADERS.
ZHLOOP5   CPX     GREENCNT               ; ARE THERE NO GREEN HDRS LEFT TO
          BPL     ZHLOOP7A               ; PROCESS?
          LDA     HRIGHT,X
          STA     TEMP
          SEC
          SBC     HLEFT,X                ; ACC = WIDTH OF HEADER - 1
          EOR     #$1F                    ; LOW 5 BITS OF ACC = 2'S COMP OF WIDT
          ORA     #GREENPAL              ; FORM THE PALETTE/WIDTH BYTE FOR HDR
          STA     PALW,X
          LDA     HLEFT,X                ; HPOS = 8*(HLEFT - BEGINCOL)+FIRSTPXL
          SEC
          SBC     BEGINCOL
          ASL     A
          ASL     A
          ASL     A
          ADC     #FIRSTPXL              ; CARRY = 0 BEFORE AND AFTER THIS POINT
          STA     HPOS,X
          TYA
          ADC     CHMAPLPT               ; AND Y TO CHMAPLPT TO GET A PTR TO THE
          STA     CPTRL,X                ; START OF THE CHARACTER LIST FOR THE
          LDA     CHMAPLPT+1             ; CURRENT HEADER.
          ADC     #0                     ; PROPAGATE CARRY TO HIGH BYTE
          STA     CPTRH,X
          LDA     HLEFT,X                ; NOW GET READY TO MOVE THE STAMP
          STX     HOLDX                  ; INDICES FROM MAPLINE INTO THE CHAR
          TAX                            ; MAP AREA.
ZHLOOP6   LDA     MAPLINE,X
          STA     (CHMAPLPT),Y
          INY
          INX
          CPX     TEMP                   ; RECALL THAT TEMP = HRIGHT, THE
          BMI     ZHLOOP6                ; RIGHTMOST STAMP FOR THIS HEADER.
          BEQ     ZHLOOP6
          LDX     HOLDX
          LDX     HOLDX                  ; RESTORE X TO THE INDEX INTO THE
          INX                            ; HEADER LIST AND BUMP IT UP TO THE
          JMP     ZHLOOP5                ; NEXT HEADER.
ZHLOOP7A
          LDA     #L(GETMPR5A)
          STA     MAPBRADL
          LDA     #H(GETMPR5A)
          STA     MAPBRADH
          STX     TEMPSAV0
          STY     TEMPSAV1
          RTS



*******************************
GETMPR5A
          LDX     TEMPSAV0
          LDY     TEMPSAV1
ZHLOOP7   CPX     HCOUNT                 ; DO THE SAME THINGS FOR THE GRAY HDRS.
          BPL     ZHEND4                 ; THE MAIN DIFFERENCE IS THAT THE
          LDA     HRIGHT,X               ; TARGETS MUST BE MERGED IN WITH THE
          STA     TEMP                   ; PLAYFIELD INFORMATION.
          SEC
          SBC     HLEFT,X
          EOR     #$1F
          ORA     #GRAYPAL
          STA     PALW,X
          LDA     HLEFT,X
          SEC
          SBC     BEGINCOL
          ASL     A
          ASL     A
          ASL     A
          ADC     #FIRSTPXL              ; CARRY = 0 BEFORE AND AFTER THIS
          STA     HPOS,X
          TYA
          ADC     CHMAPLPT
          STA     CPTRL,X
          LDA     CHMAPLPT+1
          ADC     #0                     ; PROPAGATE CARRY
          STA     CPTRH,X
          LDA     HLEFT,X                ; PREPARE TO MOVE IN THE STAMPS FOR
          STX     HOLDX                  ; THE CURRENT HDR, MERGING IN TARGET
          TAX                            ; INFORMATION.
ZHLOOP8   LDA     TARGLINE,X             ; IS THERE A TARGET AT THIS STAMP?
          BNE     ZISTARG
          LDA     MAPLINE,X              ; NO TARGET.  SET STAMP TO CLEAR IF
          CMP     #PAL2STMP              ; MAPLINE CONTAINS A GREEN PLAYFIELD
          BCS     ZHEND8                 ; STAMP.
          LDA     #CLRSTMP
          JMP     ZHEND8
ZISTARG   LDA     MAPLINE,X              ; THERE'S A TARGET.  IF MAPLINE IS A
          CMP     #PAL2STMP              ; GRAY STAMP THEN THE "GRAY VERSION"
          BCS     ZGRAYTAR               ; OF THE TARGET MUST BE USED.
          LDA     TARGLINE,X
          JMP     ZHEND8
ZGRAYTAR  LDA     TARGLINE,X             ; THE "GRAY VERSION" OF A TARGET STAMP
          ADC     #1                     ; IS OBTAINED BY ADDING 2.  CARRY = 1
                                         ; BEFORE THE ADD.
ZHEND8    STA     (CHMAPLPT),Y
          INY
          INX
          CPX     TEMP
          BMI     ZHLOOP8
          BEQ     ZHLOOP8
          LDX     HOLDX
          INX
          JMP     ZHLOOP7
ZHEND4    STY     HDRSTMPS               ; AT THIS POINT Y = TOTAL # OF STAMPS
          LDA     #L(GETMPR5B)
          STA     MAPBRADL
          LDA     #H(GETMPR5B)
          STA     MAPBRADH
          RTS

**************************************
GETMPR5B
*HACK
          LDX     GTARGCNT               ; COMPUTE GTARPTR FOR THE NEW TARGETS.
ZHLOOP10  CPX     NGTARCNT
          BPL     ZMAPRET
*END OF HACK

          LDY     GREENCNT               ; SEARCH THROUGH ALL GRAY HEADERS TO
          LDA     GTARPTRL,X             ; FIND THE ONE WHICH DISPLAYS THIS
ZHLOOP11  CMP     HRIGHT,Y               ; TARGET.  (THE # OF GREEN HDRS = THE
          BMI     ZSKIP6                 ; INDEX OF THE FIRST GRAY HDR)
          BEQ     ZSKIP6
          INY
          JMP     ZHLOOP11
ZSKIP6    SEC                            ; GTARPTR = CPTR + (TARGET COLUMN - 
          SBC     HLEFT,Y                ;           HLEFT)
          STA     GTARPTRL,X
          LDA     CPTRH,Y
          SBC     #0
          STA     GTARPTRH,X

          LDA     GTARPTRL,X
          CLC
          ADC     CPTRL,Y
          STA     GTARPTRL,X
          LDA     CPTRH,Y
          ADC     #0
          STA     GTARPTRH,X
          LDA     GTARTYPE,X
          CMP     #$07
          BNE     NEINFLAG
          LDA     GTARPTRH,X
          STA     FLAGPTRH
          LDA     GTARPTRL,X
          STA     FLAGPTRL
          JMP     NEINCIT

NEINFLAG  CMP     #6                     ;CITADEL
          BNE     NEINCIT
          LDA     #NEWCITAD
          STA     CITATIME
NEINCIT   INX
          JMP     ZHLOOP10
*HACK
ZMAPRET   STX     GTARGCNT
          LDA     #L(GETMPRW0)
          STA     MAPBRADL
          LDA     #H(GETMPRW0)
          STA     MAPBRADH
          RTS

BOTDECO
          END
