********** MARIA II INITIAL PLAYFIELD LOADER  *******   SEPTEMBER 28,1983
********** ATTENTION: THIS IS THE CIRCULAR DISPLAY LIST VERSION!!!!!!!**********
********** AND EXTRA DISPLAY LIST VERSION!!!!!!!@@@@@@@@######******************
*         LOADPF
*TEMP0    LOW BYTE OF POINTER TO DISPLAY LIST
*TEMP1    HIGH BYTE OF POINTER TO DISPLAY LIST
*TEMP15   LOOP COUNTER

          ZEROPAGE
          MARIAREG
          HEADGLBL
          PUBLIC  INITPLDR
          ZONEGLBL                       ;extrn
          MAPGLBL
          SCROGLBL
          LOADGLBL
          DLLGLBL
          GTARGLBL
          EXTRN   WVBLANK

******************************************
RAM1      CSECT
* THE FOLLOWING ARRAYS PASS INFORMATION ABOUT PLAYFIELD HEADERS TO THE SCROLLING
* ROUTINE.  THEY ARE USED ONLY BY THE MULTI-PLAYFIELD MAP ROUTINE.
*
SCORESIZ  EQU     15                     ;ONE 5-BYTE HEADER
SCORELST  DS      SCORESIZ
BLNKLST   DS      2
SCCHMAP   DS      20

NUMHEADS  EQU     3
PALW      DS      NUMHEADS               ; THE PALETTE/WIDTH BYTES.
HPOS      DS      NUMHEADS               ; THE STARTING HORIZONTAL PIXEL
CPTRL     DS      NUMHEADS               ; CPTR IS THE POINTER INTO THE CHAR MAP
CPTRH     DS      NUMHEADS               ; FOR THE HEADER.
*
* HLEFT[I] AND HRIGHT[I] STORE THE LEFTMOST AND RIGHTMOST POSITIONS WITHIN
* MAPLINE OF THE STAMPS FOR THE I'TH HEADER.  THEY ARE USED ONLY BY THE
* MULTI-PLAYFIELD VERSION OF THE MAP ROUTINE.
* THE CURRENT TABLE SIZE ALLOWS FOR 3 HEADERS.
*
* EQU's to DS's   this was how much allocated (?) -NA
HLEFT     DS      NUMHEADS
HRIGHT    DS      NUMHEADS
******************************************
RAM2      CSECT
DLLTOP    DS      42                     ;TOP OF DISPLAY LIST LIST
DLLMID    DS      45                     ;MIDDLE (STARTING POS.) OF DISPLAY LIST
                                         ;LIST
DLLSAVE   DS      SAVZSIZE               ;HOLDING REGISTERS FOR SCORE-PLAYFIELD
                                         ;HEADER SWITCHING
* SCROLL RAM
NMAPGETS  EQU     13
MPDLSIZE  EQU     86
MAPCALLS  DS      1
SCRLFLG   DS      1
JSRCNT    DS      1                      ;COUNTS JSRS TO SCROLL AND LOADER

******************************************
CODE9000  CSECT

INITPLDR  JSR     INITCPTR               ;INITIALIZE CHMAP POINTERS

          LDA     #L(GETMPRW0)
          STA     MAPBRADL
          LDA     #H(GETMPRW0)
          STA     MAPBRADH
*INITIALIZE LOOP COUNTER AND ZONE POINTERS
          LDA     #11
          STA     TEMP15

          LDA     #L(ZONE0)
          STA     LISTPTR
          LDA     #H(ZONE0)
          STA     LISTPTR+1

ILDRLOOP

*PUT IN NEW ZONE OF MAP USING CURRENT CHMAPLPT AND CHMAPSPT
          LDA     #NMAPGETS-1
MOREGETS
          PHA
          JSR     GETMAPRW
          PLA
          SEC
          SBC     #$01
          BPL     MOREGETS

*LOAD FIRST HEADER
          LDY     #STDLSIZE-2
          LDA     HCOUNT
          ASL     A
          ASL     A
          CLC
          ADC     HCOUNT
          STA     (LISTPTR),Y            ;NUMBER OF BYTES FOR PLFLD. HEADERS
          INY
          STA     (LISTPTR),Y            ;LIST SIZE
          BEQ     ZNOHDRS


          LDY     #$00                   ;FIRST HEADER
          LDA     CPTRL                  ;PPL FOR FIRST HEADER
          STA     (LISTPTR),Y

          INY                            ;W1 FOR FIRST HEADER
          LDA     #$60                   ;MODE IS 160X2 AND INDIRECT
          STA     (LISTPTR),Y

          INY
          LDA     CPTRH                  ;PPH FOR FIRST HEADER
          STA     (LISTPTR),Y

          INY
          LDA     PALW                   ;PAL/WID FOR FIRST HEADER
          STA     (LISTPTR),Y

          INY
          LDA     HPOS                   ;HPOS BYTE FOR SECOND HEADER
          STA     (LISTPTR),Y


          LDA     HCOUNT
          CMP     #$02
          BEQ     ZNOHDRS
          INY                            ;SECOND HEADER
          LDA     CPTRL+1                ;PPL FOR SECOND HEADER
          STA     (LISTPTR),Y

          INY                            ;W1 FOR SECOND HEADER
          LDA     #$60                   ;MODE IS 160X2 AND INDIRECT
          STA     (LISTPTR),Y

          INY
          LDA     CPTRH+1                ;PPH FOR SECOND HEADER
          STA     (LISTPTR),Y

          INY
          LDA     PALW+1                 ;PAL/WID FOR SECOND HEADER
          STA     (LISTPTR),Y

          INY
          LDA     HPOS+1                 ;HPOS BYTE FOR SECOND HEADER
          STA     (LISTPTR),Y

          LDA     HCOUNT
          CMP     #$03
          BEQ     ZNOHDRS
          INY                            ;THIRD HEADER
          LDA     CPTRL+2                ;PPL FOR FIRST HEADER
          STA     (LISTPTR),Y

          INY                            ;W1 FOR THIRD HEADER
          LDA     #$60                   ;MODE IS 160X2 AND INDIRECT
          STA     (LISTPTR),Y

          INY
          LDA     CPTRH+2                ;PPH FOR THIRD HEADER
          STA     (LISTPTR),Y

          INY
          LDA     PALW+2                 ;PAL/WID FOR THIRD HEADER
          STA     (LISTPTR),Y

          INY
          LDA     HPOS+2                 ;HPOS BYTE FOR THIRD HEADER
          STA     (LISTPTR),Y

*UPDATE POINTERS USED IN LOOP
ZNOHDRS   LDA     CHMAPLPT
          SEC
          SBC     #MPDLSIZE              ;24 BYTES PER CHARACTER MAP
*NOTE!  CHANGE ABOVE TO 24 BYTES PER MAP IN MULTI PLAYFIELD VERSION
          STA     CHMAPLPT
          LDA     CHMAPLPT+1
          SBC     #0
          STA     CHMAPLPT+1

          LDA     LISTPTR                  ;ZONE POINTER
          SEC
          SBC     #MPDLSIZE
          STA     LISTPTR
          LDA     LISTPTR+1
          SBC     #0
          STA     LISTPTR+1

          DEC     TEMP15                 ;UPDATE LOOP COUNTER
          BMI     ZIPZAP
          JMP     ILDRLOOP

*NOW PUT CHARACTER MAP POINTERS INTO ZONES 12,13,14
ZIPZAP    LDA     #$5                    ;;;
          STA     ZONE12
          STA     ZONE12+1
          STA     ZONE13
          STA     ZONE13+1
          STA     ZONE14
          STA     ZONE14+1
          LDA     #L(CHMAP12)
          STA     ZONE12+2
          LDA     #L(CHMAP13)
          STA     ZONE13+2
          LDA     #L(CHMAP14)
          STA     ZONE14+2
          LDA     #$60
          STA     ZONE12+3
          STA     ZONE13+3
          STA     ZONE14+3
          LDA     #H(CHMAP12)
          STA     ZONE12+4
          LDA     #H(CHMAP13)
          STA     ZONE13+4
          LDA     #H(CHMAP14)
          STA     ZONE14+4


          LDA     #L(ZONE12)
          STA     XDLPTR
          LDA     #H(ZONE12)
          STA     XDLPTR+1
          LDY     #2
          LDA     #L(CHMAP12)
          STA     CHMAPLPT
          STA     (XDLPTR),Y
          LDY     #4
          LDA     #H(CHMAP12)
          STA     CHMAPLPT+1
          STA     (XDLPTR),Y

*NOW SET UP DOUBLE LENGTH DISPLAY LIST LIST (WELL, ALMOST DOUBLE LENGTH)
          LDX     #0
          STX     SCOFFSET
          STX     MAPCALLS

          LDA     #L(ZONE13)
          STA     TEMP0
          LDA     #H(ZONE13)
          STA     TEMP1
INITDLL
          LDA     #$4F
          STA     DLLTOP,X               ;DLI,HOLY DMA,OFFSET BYTE

          LDA     TEMP1                  ;HOLDS HIGH BYTE OF DL POINTER
          STA     DLLTOP+1,X

          LDA     TEMP0                  ;HOLDS LOW BYTE OF DL POINTER
          STA     DLLTOP+2,X

          CMP     #L(ZONE0)
          BEQ     ZRESTORE
ZUPDATE   LDA     TEMP0                  ;UPDATES DL POINTERS USING STDLSIZE
          CLC
          ADC     #MPDLSIZE
          STA     TEMP0
          LDA     TEMP1
          ADC     #0
          STA     TEMP1
          JMP     ZINX3

ZRESTORE  LDA     TEMP1
          CMP     #H(ZONE0)
          BNE     ZUPDATE
          LDA     #L(ZONE14)             ;THIS RESETS DL POINTERS TO ZONE12
          STA     TEMP0
          LDA     #H(ZONE14)
          STA     TEMP1

ZINX3     INX
          INX
          INX

          CPX     #87                    ;87 ENTRIES IN DLL
          BNE     INITDLL

*NOW INITIALIZE DPPL,DPPH AND UPDATE ZONE12 DLL TO HOLD SCORE DLL
          LDA     #L(DLLMID)
          STA     SDPPL                  ;SHADOW OF DPPL
          STA     DPPL
          LDA     #H(DLLMID)
          STA     SDPPH                  ;SHADOW OF DPPH
          STA     DPPH

* SAVE DL'S AND PUT IN SCORE DL'S
          LDX     #SAVZSIZE-1            ;SAVE DLLS FOR FUTURE
ZLOOP1    LDA     DLLMID,X
          STA     DLLSAVE,X
          LDA     SCOREDLL,X
          STA     DLLMID,X
          DEX
          BPL     ZLOOP1

          LDY     #SAVZSIZE              ;AND SET OFFSET IN FIRST PLAYFIELD TO 0
          LDA     (SDPPL),Y
          AND     #$F0
          ORA     #$80                   ;AND SET DLI
          STA     (SDPPL),Y

          LDY     #DLIBIT2               ;SET DLI BIT FOR END OF SCREEN
          LDA     (SDPPL),Y
          ORA     #$80
          STA     (SDPPL),Y

          LDA     #$10
          STA     JSRCNT
ASCR      JSR     SCROLL
          JSR     SLOADER
          DEC     JSRCNT
          BNE     ASCR
          RTS
*******8
SCOREDLL  DB      $CF,H(BLNKLST),L(BLNKLST)
          DB      $47,H(BLNKLST),L(BLNKLST)
          DB      $0F,H(SCORELST),L(SCORELST)


* INITIALIZE CHARACTER MAP POINTERS SUBROUTINE
INITCPTR  LDA     #L(CHMAP0)            ;POINTER TO NEXT LARGE CHARACTER MAP
          STA     CHMAPLPT               ;TO BE UPDATED DURING SCROLLING
          LDA     #H(CHMAP0)
          STA     CHMAPLPT+1

          RTS
BOTPLDR
********** MARIA II XEVIOUS SCROLLER (FINE AND COARSE)
*WITH CIRCULAR DISPLAY LIST LIST AND EXTRA ZONE!!!!!!!!!!!!!!!!!
******** ATTENTION: THIS IS THE CIRCULAR DISPLAY LIST VERSION!!!!!!!!!**********
******** WITH EXTRA ZONE!!!!!!!!!!!@@@@@@@@@#########***************************

*FINE SCROLLING-----ASSUMES THAT DLI BIT IN DLL OF ZONE 11 IS A ZERO
SCROLL
          LDA     SCOFFSET               ;UPDATE SCROLL OFFSET VALUE
          CMP     #$0F
          BNE     ZZSCROLL
          JMP     CORSCROL               ;IF NEGATIVE, DO SOME COARSE SCROLLING

ZZSCROLL  INC     SCOFFSET
          LDY     #SAVZSIZE
          LDA     (SDPPL),Y              ;PLACE NEW OFFSET VALUE INTO DLL
          AND     #$F0
          ORA     SCOFFSET
          STA     (SDPPL),Y

          LDA     MAPCALLS
          CMP     #NMAPGETS
          BEQ     XTFPTR
          CMP     #NMAPGETS-1
          BEQ     ZLSTGTMP
          JSR     GETMAPRW
          INC     MAPCALLS
XTFPTR    JMP     XTF00002

GETHEADR
ZLSTGTMP  JSR     GETMAPRW

          LDA     HCOUNT
          LDY     #STDLSIZE-2
          ASL     A
          ASL     A
          CLC
          ADC     HCOUNT
          STA     (XDLPTR),Y             ;NUMBER OF PLAYFIELD HEADER BYTES
          INY
          STA     (XDLPTR),Y
          BEQ     NOHDRS

          LDA     CPTRL                  ;FIRST HEADER
          LDY     #$00
          STA     (XDLPTR),Y

          INY
          LDA     #$60
          STA     (XDLPTR),Y

          INY
          LDA     CPTRH
          STA     (XDLPTR),Y

          INY
          LDA     PALW
          STA     (XDLPTR),Y

          INY
          LDA     HPOS
          STA     (XDLPTR),Y


          LDA     HCOUNT
          CMP     #$01
          BEQ     NOHDRS
          INY
          LDA     CPTRL+1                ;SECOND HEADER
          STA     (XDLPTR),Y

          INY
          LDA     #$60
          STA     (XDLPTR),Y

          INY
          LDA     CPTRH+1
          STA     (XDLPTR),Y

          INY
          LDA     PALW+1
          STA     (XDLPTR),Y

          INY
          LDA     HPOS+1
          STA     (XDLPTR),Y


          LDA     HCOUNT
          CMP     #$02
          BEQ     NOHDRS
          INY
          LDA     CPTRL+2                ;THIRD HEADER
          STA     (XDLPTR),Y
          INY

          LDA     #$60
          STA     (XDLPTR),Y
          INY

          LDA     CPTRH+2
          STA     (XDLPTR),Y

          INY
          LDA     PALW+2
          STA     (XDLPTR),Y

          INY
          LDA     HPOS+2
          STA     (XDLPTR),Y


NOHDRS    INC     MAPCALLS

XTF00002
          JMP     GTARG
*         JSR     GTARG                  ;UPDATE GROUND TARGETS POSITIONS
*         RTS


*COARSE SCROLLING
CORSCROL
*RESET SCROLL OFFSET
          LDA     #$0
          STA     SCOFFSET
          STA     MAPCALLS
          LDY     #SAVZSIZE-1

          JSR     WVBLANK
*RESTORE ZONES DLLS OVER SCORE AND BLANK DLLS
ZLOOP2    LDA     DLLSAVE,Y
          STA     (SDPPL),Y
          DEY
          BPL     ZLOOP2

          LDY     #DLIBIT1               ;CLEAR DLI BIT    OOOOOH...
          LDA     (SDPPL),Y
          AND     #$7F
          STA     (SDPPL),Y

          LDY     #DLIBIT2               ;CLEAR DLI BIT
          LDA     (SDPPL),Y
          AND     #$7F
          STA     (SDPPL),Y

*RESTORE DLI BIT OF PREVIOUS TOP PLAYFIELD DLL POINTER TO ZERO
          LDY     #SAVZSIZE
          LDA     (SDPPL),Y
          AND     #$7F
          STA     (SDPPL),Y
*NOW UPDATE SDPPH,SDPPL,DPPH,DPPL
          LDA     SDPPL
          CMP     #L(DLLTOP)
          BNE     ZUPDDPP
          LDA     SDPPH
          CMP     #H(DLLTOP)
          BNE     ZUPDDPP

          LDA     #L(DLLMID)             ;RESET SDPPL, ETC. TO MIDDLE OF DLL
          STA     SDPPL
          STA     DPPL
          LDA     #H(DLLMID)
          STA     SDPPH
          STA     DPPH
          JMP     VADER

ZUPDDPP   LDA     SDPPL
          SEC
          SBC     #3
          STA     SDPPL
          STA     DPPL
          LDA     SDPPH
          SBC     #0
          STA     SDPPH
          STA     DPPH

VADER
*NOW SAVE NEW ZONES DLLS AND PUT SCORE AND BLANK DLLS INTO NEW ZONES DLLS
          LDY     #SAVZSIZE-1
ZLOOP3    LDA     (SDPPL),Y
          STA     DLLSAVE,Y
          LDA     SCOREDLL,Y
          STA     (SDPPL),Y
          DEY
          BPL     ZLOOP3

          LDY     #DLIBIT1               ;ADD DLI BIT
          LDA     (SDPPL),Y
          ORA     #$80
          STA     (SDPPL),Y


          LDY     #DLIBIT2               ;ADD DLI BIT
          LDA     (SDPPL),Y
          ORA     #$80
          STA     (SDPPL),Y

*UPDATE XDLPTR
          LDA     XDLPTR
          CMP     #L(ZONE14)
          BEQ     ZUPDXDL
ZUPDX     LDA     XDLPTR
          SEC
          SBC     #MPDLSIZE
          STA     XDLPTR
          LDA     XDLPTR+1
          SBC     #0
          STA     XDLPTR+1
          JMP     ZLUKE
ZUPDXDL   LDA     XDLPTR+1
          CMP     #H(ZONE14)
          BNE     ZUPDX
          LDA     #L(ZONE0)
          STA     XDLPTR
          LDA     #H(ZONE0)
          STA     XDLPTR+1
*NOW UPDATE CHMAPLPT AND COMPANY
ZLUKE     LDA     XDLPTR
          SEC
          SBC     #CMAPSIZE
          STA     CHMAPLPT               ;LOW BYTE OF POINTER TO CHARACTER MAP
          LDA     XDLPTR+1
          SBC     #$00
          STA     CHMAPLPT+1             ;HIGH BYTE OF POINTER TO CHARACTER MAP


*AND FINALLY, SET OFFSET OF TOP ZONE (NOT SCORE) TO ZERO
          LDY     #SAVZSIZE
          LDA     (SDPPL),Y
          AND     #$F0
          ORA     #$80
          STA     (SDPPL),Y

          JMP     GTARG
*         JSR     GTARG                  ;UPDATE GROUND TARGETS POSITIONS
*         RTS
BOTSCRL

          END
