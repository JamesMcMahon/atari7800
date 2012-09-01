********* SHIP LOADER                              SEPTEMBER  6, 1983
*LOADER
          SHOTGLBL
          ZEROPAGE
          ZONEGLBL                       public
          LOADGLBL                       public subs
          HEADGLBL
          ELGLBL                         extrn
          SCROGLBL
          MARIAREG
          GLBL    BAR,CSHOT              dstamps
          GLBL    LOADSCOR               main
          EXTRN   WVBLANK

*****************************************
RAM1      CSECT
STDLSIZE  EQU     60                     ;HAC!!!!!
CMAPSIZE  EQU     26
ZCHMAP14  DS      CMAPSIZE               ;20 BYTES OF SCORE CHARACTER MAP
CHMAP14   EQU     ZCHMAP14
ZONE14    DS      STDLSIZE

ZCHMAP13  DS      CMAPSIZE               ;SAVE 32 BYTES FOR EACH CHAR. MAP
CHMAP13   EQU     ZCHMAP13
ZONE13    DS      STDLSIZE

ZCHMAP12  DS      CMAPSIZE
CHMAP12   EQU     ZCHMAP12
ZONE12    DS      STDLSIZE

ZCHMAP11  DS      CMAPSIZE
CHMAP11   EQU     ZCHMAP11
ZONE11    DS      STDLSIZE

ZCHMAP10  DS      CMAPSIZE
CHMAP10   EQU     ZCHMAP10
ZONE10    DS      STDLSIZE

ZCHMAP9   DS      CMAPSIZE
CHMAP9    EQU     ZCHMAP9
ZONE9     DS      STDLSIZE

ZCHMAP8   DS      CMAPSIZE
CHMAP8    EQU     ZCHMAP8
ZONE8     DS      STDLSIZE

ZCHMAP7   DS      CMAPSIZE
CHMAP7    EQU     ZCHMAP7
ZONE7     DS      STDLSIZE

ZCHMAP6   DS      CMAPSIZE
CHMAP6    EQU     ZCHMAP6
ZONE6     DS      STDLSIZE

ZCHMAP5   DS      CMAPSIZE
CHMAP5    EQU     ZCHMAP5
ZONE5     DS      STDLSIZE

ZCHMAP4   DS      CMAPSIZE
CHMAP4    EQU     ZCHMAP4
ZONE4     DS      STDLSIZE

ZCHMAP3   DS      CMAPSIZE
CHMAP3    EQU     ZCHMAP3
ZONE3     DS      STDLSIZE

ZCHMAP2   DS      CMAPSIZE
CHMAP2    EQU     ZCHMAP2
ZONE2     DS      STDLSIZE

ZCHMAP1   DS      CMAPSIZE
CHMAP1    EQU     ZCHMAP1
ZONE1     DS      STDLSIZE

ZCHMAP0   DS      CMAPSIZE
CHMAP0    EQU     ZCHMAP0
ZONE0     DS      STDLSIZE

*****************************************
CODED     CSECT


Q         EQU     STDLSIZE

PRELOAD
          LDA     ZONE0+Q-2            ;NUMBER OF PLAYFIELD HEADER BYTES
          STA     ZONE0+Q-1            ;LISTSIZE
          LDA     ZONE1+Q-2
          STA     ZONE1+Q-1
          LDA     ZONE2+Q-2
          STA     ZONE2+Q-1
          LDA     ZONE3+Q-2
          STA     ZONE3+Q-1
          LDA     ZONE4+Q-2
          STA     ZONE4+Q-1
          LDA     ZONE5+Q-2
          STA     ZONE5+Q-1
          LDA     ZONE6+Q-2
          STA     ZONE6+Q-1
          LDA     ZONE7+Q-2
          STA     ZONE7+Q-1
          LDA     ZONE8+Q-2
          STA     ZONE8+Q-1
          LDA     ZONE9+Q-2
          STA     ZONE9+Q-1
          LDA     ZONE10+Q-2
          STA     ZONE10+Q-1
          LDA     ZONE11+Q-2
          STA     ZONE11+Q-1
          LDA     ZONE12+Q-2
          STA     ZONE12+Q-1
          LDA     ZONE13+Q-2
          STA     ZONE13+Q-1
          LDA     ZONE14+Q-2
          STA     ZONE14+Q-1
          RTS

SLOADER
          LDA     SCOFFSET
          CMP     #$0F
          BEQ     CORSANTI

FINEANTI                                 ;FINE SCROLLING
          INC     ANTITOTL               ;ACCUMULATED ANTI SCROLL
          LDA     #01
          STA     ANTISCRO
          BNE     DOSCROLL
CORSANTI                                 ;COARSE SCROLLINT
          LDA     #$F1                   ;MINUS $0F
          STA     ANTISCRO
          LDA     #$00
          STA     ANTITOTL               ;ACCUMULATED ANTI SCROLL
                                         ;Y  HAS A  ZERO IN IT
DOSCROLL                                 ;DO PLAYFIELD SCROLLING
          JSR     SCROLL

*NOW IS THE TIME FOR ALL GOOD LOADERS ...

          JSR     WVBLANK
NOANTISC                                 ;NO SCROLLING
          LDY     PRIOR0
          BPL     ANENTRY
          LDY     PRIOR1
          BPL     ANENTRY
          LDY     PRIOR2
          BPL     ANENTRY
          LDY     PRIOR3
          BPL     ANENTRY
          JMP     SSLOADER

ANENTRY

GETSTAMP  STY     TEMP2
          LDA     ELYPOS,Y
          CLC
          ADC     ANTISCRO               ;ANTI-SCROLLING
          STA     ELYPOS,Y
          BEQ     NXTSTAMP
          CMP     #$E1
HUH       BCS     NXTSTAMP
          STA     TEMP8

*THIS LITTLE SECTION COMPUTES THE OFFSET FROM SDPPL,SDPPH TO USE IF FINDING DL
          ADC     #$FF                   ;ACTUALLY WANT TO SUBTRACT ONE
          LSR     A
          LSR     A
          LSR     A
          LSR     A
HELPME    TAX                            ;ZONE NUMBER (0 IS BOTTOM, C IS TOP)
          LDA     ELXPOS,Y
          STA     TEMP3
          LDA     ELTYPE,Y
          STA     TEMP0
          LDA     ELPALW,Y
          STA     TEMP1
*         CPX     #$0D                   ;NEEDED TO ALLOW SHIP TO FLY SMOOTHLY
*         BNE     OVERLAPS               ;OFF TOP OF SCREEN IF LISTSIZE OF TOP
*         DEX                            ;ZONE IS EASILY OVERLOADED BY PRESENT
                                         ;SCHEME

OVERLAPS  LDY     SDPPOFST,X             ;LOOK UP OFFSET VALUE
          LDA     (SDPPL),Y
          STA     SLLSTPTR
          DEY
          LDA     (SDPPL),Y
          STA     SLLSTPTR+1

          LDY     #Q-1
          LDA     (SLLSTPTR),Y           ;LISTSIZE
          CMP     #LISTLENG
          BCS     NXTZLST
          STA     TEMP4
          ADC     #$04                   ;CARRY IS ASSUMED TO BE CLEAR
*         CLC
          STA     (SLLSTPTR),Y           ;LISTSIZ
          LDY     TEMP4

          LDA     TEMP0
          STA     (SLLSTPTR),Y
          INY
          LDA     TEMP1
          STA     (SLLSTPTR),Y
          INY
          LDA     #H(DSTAMPS)
          ADC     TOPZONE,X
          SEC
          SBC     TEMP8
          STA     (SLLSTPTR),Y
          INY
          LDA     TEMP3
          STA     (SLLSTPTR),Y
NXTZLST   LDA     TEMP8
          CMP     TOPZONE,X
          BCS     NXTSTAMP
          DEX
          BPL     OVERLAPS

NXTSTAMP  LDY     TEMP2
          LDA     ELFORLNK,Y
          BMI     SSLOADER
          TAY
          JMP     GETSTAMP

********* SPECIAL SHOT LOADER                        SEPTEMBER  1, 1983
*SSLOADER

SSLOADER
          LDY     PRIOR4
          BPL     ZIP
          JMP     ZAJDA
ZIP
;NEXT TWO LINES SHOULD BE  REMOVED FOR SHOT HACK
          LDA     SHOTCNT
          SEC
          SBC     OBJCNT
          CMP     #$10
          BCC     SHOTHACK
          LDA     #$02
          STA     TEMP7
          STA     OVLPSFLG
          BNE     GTSTAMP                ;BRANCH ALWAYS
SHOTHACK
          LDA     #$FF                    ;INITIALIZE OVERLAP FLAG
          STA     TEMP7
          STA     OVLPSFLG
GTSTAMP   LDA     ELYPOS,Y
          STY     TEMP2
          CLC
          ADC     ANTISCRO
          STA     ELYPOS,Y
          BEQ     NXSTAMP
          CMP     #$E1
          BCS     NXSTAMP
          STA     TEMP8
          ADC     #$FF                   ;ACTUALLY WANT TO SUBTRACT A ONE
          LSR     A
          LSR     A
          LSR     A
;THESE NEXT TWO LINES SHOULD BE REMOVED FOR THE SHOT HACK
          BCS     ONEZONE                ;BRANCH OUT IN CASE OF NO ZONE OVERLAP
          DEC     OVLPSFLG               ;OVERLAP FLAG
ONEZONE   LSR     A
;THESE NEXT TWO LINES SHOULD BE REMOVED FOR THE SHOT HACK
          BCS     ONZONE
          DEC     OVLPSFLG               ;OVERLAP FLAG
ONZONE    TAX
          LDA     ELXPOS,Y
          STA     TEMP3

OVRLAPS   LDY     SDPPOFST,X
          LDA     (SDPPL),Y
          STA     SLLSTPTR
*         SEC
*         SBC     #$02
*         STA     TEMP5
          DEY
          LDA     (SDPPL),Y
          STA     SLLSTPTR+1
*         SBC     #$00
*         STA     TEMP6



          LDY     #STDLSIZE-1
          LDA     (SLLSTPTR),Y           ;LISTSIZE
          CMP     #LISTLENG
          BCS     NXZLST
          STA     TEMP4
          ADC     #$04                   ;CLEAR CARRY IS ASSUMED
          STA     (SLLSTPTR),Y           ;LISTSIZ
          LDY     TEMP4

          LDA     #L(CSHOT)
          STA     (SLLSTPTR),Y
          INY
          LDA     #SHPALW
          STA     (SLLSTPTR),Y
          INY
          LDA     #H(DSTAMPS)
          ADC     TOPZONE,X
          SEC
          SBC     TEMP8
          STA     (SLLSTPTR),Y
          INY
          LDA     TEMP3
          STA     (SLLSTPTR),Y

NXZLST
;THESE NEXT FOUR LINES SHOULD BE OMITTED FOR SHOT HACK
          LDA     OVLPSFLG               ;OVERLAP FLAG
          BNE     NXSTAMP
          INC     OVLPSFLG               ;INSURES THAT NXZLST ONLY RUNS ONCE
          DEX
          BPL     OVRLAPS

NXSTAMP
;THESE NEXT TWO LINES SHOULD BE REMOVED FOR HACK
          LDA     TEMP7
          STA     OVLPSFLG
          LDY     TEMP2
          LDA     ELFORLNK,Y
          BMI     ZAJDA                   ;26 (ITEMS ON OBJECT LIST)
          TAY
          JMP     GTSTAMP

ZAJDA
;         LDA     #$56
;         STA     BACKGRND
          LDX     #12                    ;NUMZONES-1
PUTZBAR   LDY     SDPPOFST,X             ;PUT IN TERMINATING ZEROES AND BARS
          LDA     (SDPPL),Y
          STA     SLLSTPTR
          DEY
          LDA     (SDPPL),Y
          STA     SLLSTPTR+1

          LDY     #Q-1
          LDA     (SLLSTPTR),Y           ;LISTSIZ
          TAY

          LDA     #L(BAR)
          STA     (SLLSTPTR),Y
          INY
          LDA     #PALWHBAR
          STA     (SLLSTPTR),Y
          INY
          LDA     #H(DSTAMPS)
          STA     (SLLSTPTR),Y
          INY
          LDA     #HPOSLBAR
          STA     (SLLSTPTR),Y
          INY
          LDA     #L(BAR)
          STA     (SLLSTPTR),Y
          INY
          LDA     #PALWHBAR
          STA     (SLLSTPTR),Y
          INY
          LDA     #H(DSTAMPS)
          STA     (SLLSTPTR),Y
          INY
          LDA     #HPOSRBAR
          STA     (SLLSTPTR),Y
          INY
          INY
          LDA     #0
          STA     (SLLSTPTR),Y
          DEX
          BPL     PUTZBAR


          JSR     LOADSCOR               ;PUT UP THE SCORE

          RTS

SDPPOFST  DB      $2F,$2C,$29,$26,$23,$20,$1D,$1A,$17,$14,$11,$0E,$0B,$0B


*LIST OF Y POSITIONS OF THE TOPS OF THE ZONES
TOPZONE   DB      16,32,48,64,80,96        ;ZONE0-ZONE5
          DB      112,128,144,160,176,192  ;ZONE6-ZONE11
          DB      208,208                  ;ZONE 12
BOTLDR
          END
