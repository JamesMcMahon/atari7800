********** MARIA II XEVIOUS SCROLLER (FINE AND COARSE)      SEPTEMBER 29, 1983
*WITH CIRCULAR DISPLAY LIST LIST AND EXTRA ZONE!!!!!!!!!!!!!!!!!
*         SCROLL
*         TEMP12,TEMP13
          MARIAREG
          ZEROPAGE
          SCROGLBL                       public
          ZONEGLBL                       extrn
          MAPGLBL
          LOADGLBL
          HEADGLBL
          GTARGLBL
          DLLGLBL
          EXTRN   WVBLANK

******** ATTENTION: THIS IS THE CIRCULAR DISPLAY LIST VERSION!!!!!!!!!**********
******** WITH EXTRA ZONE!!!!!!!!!!!@@@@@@@@@#########***************************

******************************************
RAM2      CSECT
NMAPGETS  EQU     13
MPDLSIZE  EQU     86
MAPCALLS  DS      1
SCRLFLG   DS      1
JSRCNT    DS      1                      ;COUNTS JSRS TO SCROLL AND LOADER

******************************************
CODE9000  CSECT
ATOPSCRL
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
