********************************************************************************
***********                                                          ***********
***********       GENDPL:  THIS LOADS STAMPS INTO THE DISPLAY LISTS  ***********
***********                FOR EACH ZONE.  THE BACKGROUND HEADERS    ***********
***********                ARE CHANGED ONLY WHEN SWITCHING PLAYERS   ***********
***********                SO THERE IS NO NEED TO CHANGE THEM EACH   ***********
***********                TIME THE LOADER IS RUN.                   ***********
***********                                                          ***********
********************************************************************************
****
**** TIMING FOR THE LOADER IS AS FOLLOWS:
****
******************* THIS IS ALL INVALIDATED:  LOADER HAS BEEN ******************
*******************         CHANGED TO SAVE ROM!!!!!!!        ******************
****
****      BEST CASE:        47 ... INITIALIZE LISTSIZ.
****                         2 ... SET UP FOR STAMP LOADER.
****                      2464 ... FILL IN 16 STAMPS: NONE CROSS ZONES.
****                       351 ... ZEROS AT END OF EACH DISPLAY LIST.
****                         8 ... EOR DLSTPTR.
****                      ----
****                      2872 ... TOTAL BEST CASE CYCLES.
****
****
****      AVERAGE CASE:                          WORST CASE:
****      -------------                          ----------- 
****           49                                     49
****         3232 ... 8 CROSS ZONES, 8 DON'T.       4000 ... ALL CROSS ZONES.
****          359                                    359
****         ----                                   ____
****         3640 ... TOTAL AVERAGE CASE.           4408 ... TOTAL WORST CASE.
****
********************************************************************************


**** INITIALIZE INDEX INTO DISPLAY LIST FOR EACH ZONE TO 4: THIS WILL
****      POINT TO BYTE JUST FOLLOWING BACKGROUND HEADER.

GENDPL    LDA     #5                     ;THIS TAKES 32 BYTES AND 47 CYCLES.
          LDX     #15                    ;  DOING THIS IN A LOOP WOULD TAKE
FILLIST   STA     LISTSIZ,X              ;  9 BYTES AND 147 CYCLES.
          DEX                            ;NOTE THAT WE DIDN'T TOUCH LISTSIZ+0.
          BNE     FILLIST


**** NOW FOR EACH STAMP POSSIBLE ON SCREEN, SEE WHICH ZONE(S) THE STAMP APPEARS
****      IN AND PUT THE APPROPRIATE HEADER INTO THE ZONE'S DISPLAY LIST.
****      THE COORDINATE SYSTEM FOR THE POSITIONS OF THE STAMPS RUNS FROM 0
****      AT THE BOTTOM OF THE SCREEN TO 191 AT THE TOP, AND FROM 0 AT THE
****      LEFT TO 159 AT THE RIGHT.  THE TOP ZONE IS ZONE 15 (SKY), AND THE
****      BOTTOM ZONE IS ZONE 0 (SCORE / NUMBER OF EXTRA LIVES LINE).
****      BEST CASE TIMING FOR THIS LOOP IS 154 CYCLES PER STAMP, WORST CASE
***       250 CYCLES PER STAMP.

GENDPL2                                  ;(ENTRY POINT FOR TITLEPAG.)
          LDA     #1                     ;FIRST DO ALL STAMPS WITH STMPRIOR=1:
          STA     LISTPTR                ;  THESE HAVE LOWEST PRIORITY SO WILL
                                         ;  BE PUT IN DISPLAY LIST FIRST.
ZGEN2     LDA     #CSET2                 ;ALL STAMPS ARE IN CSET2 EXCEPT FOR
          STA     LISTPTR+1              ;  FRUIT, WHICH IS IN FIRST SLOT OF
                                         ;  STMPYPOS AND IN CSET1.
          LDY     #0
GETSTAMP
          STY     TEMPY
          LDA     STMPRIOR,Y             ;DOES THIS STAMP HAVE CORRECT PRIORITY
          CMP     LISTPTR                ;  FOR THIS PASS?
          BNE     NXTSTAMP
          LDA     STMPYPOS,Y             ;VERTICAL POSITION OF STAMP.
          BEQ     NXTSTAMP               ;IF ZERO, DON'T DISPLAY STAMP.
          STA     TEMPYPOS
          LSR     A                      ;FIND WHICH ZONE BY DIVIDING BY 12.
          LSR     A
          TAX
          LDA     DIV3TAB,X              ;ZONE NUMBER.
          TAX
          LDA     STMPXPOS,Y             ;SAVE HORIZONTAL POSITION.
          CLC                            ;CENTER STAMPS ON SCREEN.
          ADC     #16
          STA     HEADER3
          LDA     STMPINDX,Y             ;INDEX = LOW ADDRESS OF STAMP.
          STA     HEADER0
          LSR     A
          TAY
          LDA     TEMPY                  ;IS THIS FRUIT STAMP?
          CMP     #TOTLSTMP              ;IF SO, HEADER1 ALREADY SET UP.
          BEQ     OVERLAPS
          LDA     STMPPALW,Y             ;PALETTE/WIDTH BYTE FOR REGULAR STAMP.
          STA     HEADER1

OVERLAPS
          JSR     SETDPLH                ;GET ADDRESS OF DISPLAY LIST FOR ZONE.
          LDY     LISTSIZ,X              ;POINTER INTO DISPLAY LIST FOR ZONE.
          CPY     #LISTLENG              ;LIST FULL YET?
          BCS     NXTZLST
          LDA     HEADER0
          STA     (DPLOW),Y
          INY
          LDA     HEADER1                ;PALETTE/WIDTH FOR STAMP.
          STA     (DPLOW),Y
          INY
          LDA     LISTPTR+1              ;HIGH BYTE FOR STAMP ADDRESSES.
***       CLC                            ;(CARRY ALREADY CLEAR).
          ADC     TOPZONE,X
          SEC
          SBC     TEMPYPOS
          STA     (DPLOW),Y              ;VERTICAL POS. OF STAMP ADJUSTED FOR
          INY                            ;  POSITION IN ZONE.
          LDA     HEADER3
          STA     (DPLOW),Y              ;HORIZ. POSITION.
          INY
          STY     LISTSIZ,X
NXTZLST
          LDA     HEADER0
          CMP     #BIGSTAMP
          LDA     TEMPYPOS               ;SEE IF STAMP OVERLAPS INTO NEXT ZONE.
          BCC     ZNXTZLST
          CMP     TOPZONE,X
          BCC     ZNXTZ3
***       SEC
          SBC     #4
ZNXTZLST  CMP     TOPZONE,X
          BCS     NXTSTAMP
ZNXTZ3    DEX
          BNE     OVERLAPS

NXTSTAMP
          LDY     TEMPY
          INY
          CPY     #TOTLSTMP
          BCC     GOGETSTM
          BNE     TSTPRIOR
          LDA     FRUITCST               ;FRUIT STAMPS ARE IN CSET1, BUT THEIR
          STA     LISTPTR+1              ;  SCORES ARE IN CSET2.
          LDA     FRUITPAL               ;PALETTE WIDTH BYTE FOR ALL FRUITS.
          STA     HEADER1
GOGETSTM  JMP     GETSTAMP

TSTPRIOR  LDA     LISTPTR                ;HAVE WE MADE BOTH PRIORITY PASSES?
          BEQ     ZPUT0
          DEC     LISTPTR
          JMP     ZGEN2

**** NOW PUT A 0 IN THE WIDTH OF THE NEXT HEADER IN EACH ZONE.  THIS WILL
****      SIGNIFY THE END OF THE LIST FOR THAT ZONE.  THE FOLLOWING LOOP
****      COULD BE COMPACTED TO APPROXIMATELY 33 BYTES, BUT WOULD USE 627
****      CYCLES.  BY EXPANDING OUT TO THE LARGER LOOP, WE USE 60 BYTES BUT
****      ONLY 351 CYCLES.  THIS MAKES USE OF THE FACT THAT THERE ARE 4 DISPLAY
****      LISTS IN A PAGE, AND THE LOW BYTES OF ZONES 15,11,7,3, (OR 14,10,6,2,
****      ETC.) ARE IDENTICAL.  (SEE DEFINITION OF ZONE ADDRESSES IN DIGDEF).
****      BY EXPANDING THIS LOOP ALL THE WAY OUT, THE CYCLES COULD BE CUT TO
****      269, BUT THE BYTES WOULD GROW TO 160.

ZPUT0
          LDX     #NUMZONES
          JSR     PUTBLAKB               ;PUT A BLACK BOX IN ZONES 15 AND 14.
          STY     LISTSIZ+15
          LDX     #14
          JSR     PUTBLAKB
          STY     LISTSIZ+14

          LDX     #NUMZONES
PUTZERO   JSR     SETDPLH
          LDY     LISTSIZ,X
          INY
          LDA     #0
          STA     (DPLOW),Y
          DEX
          BNE     PUTZERO                ;DON'T TOUCH ZONE 0 (SCORE)!

DLFLIP
          LDA     DLSTPTR                ;NOW FLIP DLSTPTR SO KERNEL WILL USE
          EOR     #$40                   ;  THE ONE WE JUST CONSTRUCTED.
          STA     DLSTPTR
          JMP     SCRNON
*         LDX     ONSCREEN               ;WAIT TILL WE'RE OFF SCREEN.
*         BNE     DLFLIP
*         BEQ     GETDLST
*         INX
*GETDLST   LDA     LDPPL,X
*         STA     DPPL
*         LDA     #H(DPL0LIST)           ;SAME FOR EITHER DPLLIST.
*         STA     DPPH
*         RTS

PUTBLAKB  JSR     SETDPLH
          LDY     LISTSIZ,X              ;  HALF OF SCREEN.
          LDX     #3                     ;PUT BLACK BOX IN SKY TO BLOCK LEFT
ZPUTBLAK  LDA     BLAKBOX,X              ;  HALF OF SCREEN.
          STA     (DPLOW),Y
          INY
          DEX
          BPL     ZPUTBLAK
          RTS

* PALETTES FOR STAMPS...
*VEGPALW
*         DB      $3E,$3E,$3E,$3E,$3E,$3E                ;TEDDY AND VEGGIES...
*         DB      $3E,$3E,$3E,$3E,$3E,$3E

*STMPPALW  DB      $1E,$1E,$1E,$1E,$1E,$1E                ;R/L DIGDUG.
*         DB      $1E,$1E,$1E,$5E                        ;HDEATH1,2,3,ROCK.
*         DB      $3F,$3E,$3C,$3C,$3A,$3A,$3A            ;RFLAME 4(R,L),8,16,24.
*         DB      $3E,$3C,$3C,$3A,$3A,$3A                ;LFLAME 8,16,24.
*         DB      $3A,$3A,$3C,$3E                        ;LPUMP24,R24->4
*         DB      $3B,$3B,$3B,$3C,$3C,$3D,$3E,$3F        ;LPUMP20,16,12,8,4,OVR.
*         DS      10                                     ;(8 PIXEL NUMBERS...)
*         DB      $BE,$1E                                ;FULLSKY2,BLANK2.
*         DB      $3E                                    ;TEDDY2.
*         DB      $7E,$7E                                ;R,L FLAME FYGAR
*         DB      $5E,$5E                                ;R,L HARPOON.
*         DB      $1E,$1E,$1E,$1E,$1E                    ;FREE STAMPS!!!
*         DB      $5E,$5E                                ;U,D HARPOON.
*         DB      $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E        ;POOKA STAMPS.
*         DB      $3E,$3E,$3E,$3E
*         DB      $7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E        ;FYGAR STAMPS.
*         DB      $7E,$7E,$7E,$7E
*         DB      $3E,$3E,$1E,$1E                        ;POOKA,FYGAR GHOSTS.
*         DB      $1E,$1E,$1E,$1E,$1E,$1E                ;UP/DOWN DIGDUG.
*         DB      $1E,$7E,$3E                            ;SQUISH DD,FYGAR,POOKA.
*         DB      $1E,$1E,$1E,$1E,$5E,$5E,$5E            ;VDEATH1,2,3,S,ROCKS.
*         DB      $3F,$3F,$3F                            ;DPMP,DFULL,UPMP6,12
*         DB      $5E,$5E,$5E                            ;200,300,400
*         DB      $5E,$5E,$5E                            ;500,800,1000
*         DB      $5C,$5C,$5C,$5C,$5C,$5C,$5C,$5C        ;2500,4000,6000,8000
*         DB      $5C,$5C,$5C,$5C,$5C,$5C,$5E            ;10000,12000,15000,600
*         DB      $3F                                    ;UFULL6,12

* PALETTE/WIDTH BYTES FOR ZONE BACKGROUNDS...
*PALWIDZ   DB      $AF                    ;LIFE/SCORE LINE (BOTTOM)
*         DB      $EF,$EF,$EF            ;DIRT LAYER 3
*         DB      $CF,$CF,$CF,$CF        ;DIRT LAYER 2
*         DB      $AF,$AF,$AF,$AF        ;DIRT LAYER 1
*         DB      $8F,$8F,$8F            ;DIRT LAYER 0
*         DB      $AF                    ;SKY LINE

