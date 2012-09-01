; MACRO.S
* * * macro file,  created 12/5/83       ks/pg * * *

; The following stuff gets used to handle nested conditionals and loops.
;         This macro is called inside the MACRODEF macro, at the top
;         of every source file.

$SETUP    MACRO
STK       DEFG    'STK'                  needed for concatenation syntax
PTR       DEFG    0                      stack pointer

INDEX     DEFL    0
          DO 10                          change this for more nesting levels
STK&INDEX DEFG    1                      create each entry in the stack-INDEX     DEFL    &INDEX+1               labels "STK0000n"
INDEX     DEFL    &INDEX+1
          ENDDO

; Used to derive the proper opcode for branching to ENDIF
;   The possible arguments to IF and UNTIL and WHILE are all here:

LT        DEFG    'BCS'
CC        DEFG    'BCS'

GE        DEFG    'BCC'
CS        DEFG    'BCC'

NOTZERO   DEFG    'BEQ'
NOTEQUAL  DEFG    'BEQ'

ZERO      DEFG    'BNE'
EQUAL     DEFG    'BNE'
EQUALS    DEFG    'BNE'
EQU       DEFG    'BNE'

PLUS      DEFG    'BMI'
MINUS     DEFG    'BPL'

          ENDM

RAMDEF    MACRO

          $SETUP                         needed for conditionals and iteration

CTRLOFF   EQU     $60

* * VCS holdovers * *
INPTCTRL  EQU     $01                    Input Port Control ???
INPT4     EQU     $0C                    player 0 button, player 1 is next
INPT5     EQU     $0D
AUDC0     EQU     $15      ;BITS     3210 AUDIO CONTROL 0
AUDC1     EQU     $16      ;BITS     3210 AUDIO CONTROL 1
AUDF0     EQU     $17      ;BITS     3210 AUDIO FREQUENCY 0
AUDF1     EQU     $18      ;BITS     3210 AUDIO FREQUENCY 1
AUDV0     EQU     $19      ;BITS     3210 AUDIO VOLUME 0
AUDV1     EQU     $1A      ;BITS     3210 AUDIO VOLUME 1
* * Maria, you doll * *
BACKGRND  EQU     $20                    ; background color
P0C1      EQU     $21
P0C2      EQU     $22
P0C3      EQU     $23
WSYNC     EQU     $24                    ; fast Maria wsync strobe
P1C1      EQU     $25
P1C2      EQU     $26
P1C3      EQU     $27
MSTAT     EQU     $28                    ; bit 7 in vblank, bit 6 in display
P2C1      EQU     $29
P2C2      EQU     $2A
P2C3      EQU     $2B
DPPH      EQU     $2C                    ; display list pointer high
P3C1      EQU     $2D
P3C2      EQU     $2E
P3C3      EQU     $2F
DPPL      EQU     $30                    ; display list pointer low
P4C1      EQU     $31
P4C2      EQU     $32
P4C3      EQU     $33
CHARBASE  EQU     $34                    ; character mode high pointer
P5C1      EQU     $35
P5C2      EQU     $36
P5C3      EQU     $37
OFFSET    EQU     $38                    ; future expansion, ignore
P6C1      EQU     $39
P6C2      EQU     $3A
P6C3      EQU     $3B
CTRL      EQU     $3C                    ; bit 7 character width, bit 6 BCNT
P7C1      EQU     $3D
P7C2      EQU     $3E
P7C3      EQU     $3F

* 6532  TIMERS AND PORTS
SWCHA     EQU     $280  ;PO, P1 JOYSTICKS
;         BIT 7 PLAYER 0 EAST IF CLEAR
;         BIT 6          WEST
;         BIT 5          SOUTH
;         BIT 4          NORTH
;         BIT 3 PLAYER 1 EAST IF CLEAR
;         BIT 2          WEST
;         BIT 1          SOUTH
;         BIT 0          NORTH

SWCHB     EQU     $282  ;CONSOLE SWITCHES
;         BIT 7   PLAYER 1 DIFFICULTY A IF SET B IF CLEAR
;         BIT 6   PLAYER 0 DIFFICULTY A IF SET B IF CLEAR
;         BIT 3   BLACK & WHITE/COLOR  COLOR WHEN SET
;         BIT 1   GAME SELECT  CLEAR WHEN PRESSED
;         BIT 0   GAME RESET   CLEAR WHEN PRESSED

CTLSWA    EQU     $281
CTLSWB    EQU     $283

********************************************************************************
*                 ZERO PAGE RAM  40-FF                                         *
*         93 BYTES CURRENTLY STORED HERE !                                     *
********************************************************************************

NUMZONES  EQU     11

          ORG     $40

DLIADR    EQU     $40                    ; JMP INDIRECT FROM NMI VECTOR

LISTPTR   EQU     $42                    ; USED IN LOADER AS A DLIST POINTER
LISTPTRA  EQU     $44

LISTSIZE  EQU     $46                    ; MUST BE IN ZERO PAGE, SO THAT
                                         ; "STY   LISTSIZE,X" WORKS
LISTSTRT  EQU     LISTSIZE+NUMZONES      ; BEGINNING OF MOVING CHAR INFO

TEMP0     EQU     $5C
TEMP1     EQU     TEMP0+1
TEMP2     EQU     TEMP0+2
TEMP3     EQU     TEMP0+3
TEMP4     EQU     TEMP0+4
TEMP5     EQU     TEMP0+5
TEMP6     EQU     TEMP0+6
KTEMP0    EQU     TEMP0+7                ; USED FOR SOUND DRIVER
KTEMP1    EQU     TEMP0+8

RANDOM0   EQU     $65                    ; THESE ARE USED BY RANDOM ROUTINES
RANDOM1   EQU     RANDOM0+1
RANDOM2   EQU     RANDOM0+2

TEMPX     EQU     $68                    ; USED FOR INDEX REGISTERS
TEMPY     EQU     TEMPX+1

LTEMPY    EQU     $6A                    ; FOR THE LOADER
LSECOND   EQU     LTEMPY+1               ; USED FOR OVERLAP TEST
TEMPYPOS  EQU     LTEMPY+2               ; ALSO FOR THE LOADER
HIGHPOS   EQU     LTEMPY+3               ; USED BY THE LOADER FOR HIGH BYTE

RTEMPX    EQU     $6E
RTEMPY    EQU     RTEMPX+1               ; FOR RANDOM ROUTINES

RTEMP0    EQU     HIGHPOS+3
RTEMP1    EQU     HIGHPOS+4

HEADER0   EQU     $72                    ; LOADER : TEMP STORAGE FOR HEADER
HEADER1   EQU     HEADER0+1              ;   BYTES
HEADER2   EQU     HEADER0+2
HEADER3   EQU     HEADER0+3

FRAMECNT  EQU     $76                    ; ONE PER VBLANK
OLDFCNT   EQU     FRAMECNT+1
CYCLECNT  EQU     FRAMECNT+2             ; ONE PER GAMEPLAY CYCLE
NUMCYCLE  EQU     FRAMECNT+3
MAXCYCLE  EQU     FRAMECNT+4

SYSCOUNT  EQU     FRAMECNT+5

STATUS    EQU     FRAMECNT+7
MODE      EQU     FRAMECNT+8

; 63 BYTES UP TO THIS POINT.

TOTALCH   EQU     $20                    ; 32 MOVING OBJECTS AT ONE TIME
TOTALFX   EQU     $1B                    ; 27 FIXED OBJECTS PER SCREEN

CSTATE    EQU     $7F                    ; 32 BYTES EACH
CYPOS     EQU     CSTATE+TOTALCH
CXPOS     EQU     CYPOS+TOTALCH

; 159 BYTES UP TO THIS POINT

PLAYNUM   EQU     $DF                    ; TRUE IF TWO-PLAYER
CURRENT   EQU     $E0                    ; TELLS WHICH PLAYER

RUNLOAD   EQU     $E1                    ; WHETHER TO RUN LOADER OR NOT

GODPTR    EQU     $E2                    two bytes

; added late-- Jan. 30, 1984

GAMECNT   EQU     $E4
WAITCNT   EQU     $E5
OTHER     EQU     $E6
HOWHARD   EQU     $E7
HIGHEST   EQU     $E8

PLRACK    EQU     $EA
PLCARRY   EQU     $EB
PLLIVES   EQU     $EC
PLBCD     EQU     $ED                    two bytes

PSREADY   EQU     $EF
RESREADY  EQU     $F0
SELREADY  EQU     $F1
THREADY   EQU     $F2                    ; USED BY "SELECT"

GOALX     EQU     $F3
GOALY     EQU     $F4

CYCLEIDX  EQU     $F5                     ; AT RACK START, EQUALS 0
THROWIDX  EQU     $F7

THROWBUT  EQU     $F8                     ; FOR PURPOSE OF GAMEPLAY
JOYDIR    EQU     $F9

HJOYDIR   EQU     $FA                     ; CONTROLLER STATUS
HTHROW    EQU     $FB

DOITOVER  EQU     $FC

FPRESET   EQU     $FD
FPSELECT  EQU     $FE
FPPAUSE   EQU     $FF

          ENDM

MOVE      MACRO   A,B,C,D,E,F,G,H        universal moving

; First test to see if this is a multiple move.

  IF      '&C'<>''.AND.'&D'<>'X'.AND.'&D'<>'Y'
   IF   '&C'<>'X'.AND.'&C'<>'Y'.AND.'&B'<>'X'.AND.'&B'<>'Y'

                  LDA   &A
                  STA   &B
                  STA   &C
                  IF '&D'<>''
                     STA   &D
                  ENDIF
                  IF '&E'<>''
                     STA   &E
                  ENDIF
                  IF '&F'<>''
                     STA   &F
                  ENDIF
                  IF '&G'<>''
                     STA   &G
                  ENDIF
                  IF '&H'<>''
                     STA   &H
                  ENDIF

                  EXITM
             ENDIF
          ENDIF

          IF      '&D'<>''               handles indirect addressing mode
A         DEFL    '&A!,&B'
B         DEFL    '&C!,&D'
          ELSEIF  '&C'<>''
          IF      '&B'='X'.OR.'&B'='Y'
A         DEFL    '&A!,&B'
B         DEFL    '&C'
          ELSE
B         DEFL    '&B!,&C'
          ENDIF
          ENDIF

          IF      '&A'='A'                 store accumulator somewhere
          IF      '&B'='X'
          TAX
          ELSEIF  '&B'='Y'
          TAY
          ELSEIF  '&B'='S'
          TAX
          TXS
          ELSE
          STA     &B
          ENDIF

          ELSEIF  '&A'='Y'                 store y somewhere
          IF      '&B'='A'
          TYA
          ELSEIF  '&B'='X'
          TYA
          TAX
          ELSE
          STY     &B
          ENDIF

          ELSEIF  '&A'='X'                 store x somewhere
          IF      '&B'='A'
          TXA
          ELSEIF  '&B'='Y'
          TXA
          TAY
          ELSE
          STX     &B
          ENDIF

          ELSEIF  '&B'='A'                 load a with memory
          LDA     &A
          ELSEIF  '&B'='X'                 load x with memory
          LDX     &A
          ELSEIF  '&B'='Y'                 load y with memory
          LDY     &A
          ELSEIF  '&B'='S'
          LDX     &A
          TXS
          ELSE
          LDA     &A
          STA     &B
          ENDIF
          ENDM

DELTA     MACRO   A,B,C,D

          IF      '&B'='X'.OR.'&B'='Y'
A         DEFL    '&A!,&B'
B         DEFL    C
C         DEFL    D
          ENDIF

          IF      '&C'='X'.OR.'&C'='Y'
B         DEFL    '&B!,&C'
          ENDIF

          IF '&A'<>'A'                   get correct value in A
          IF '&A'='X'
          TXA
          ELSEIF '&A'='Y'
          TYA
          ELSE
          LDA     &A
          ENDIF
          ENDIF

          SEC
          SBC     &B
          BPL     Z&INDX
          EOR     #$FF
          CLC
          ADC     #1
Z&INDX
          ENDM

ADD       MACRO   A,B,C,D,E,F            source1,source2,destination

          IF '&B'='X'.OR.'&B'='Y'
A         DEFL    '&A!,&B'
B         DEFL    '&C'
C         DEFL    '&D'
D         DEFL    '&E'
E         DEFL    '&F'
          ENDIF

          IF '&C'='X'.OR.'&C'='Y'
B         DEFL    '&B!,&C'
C         DEFL    '&D'
D         DEFL    '&E'
          ENDIF

          IF '&D'<>''
C         DEFL    '&C!,&D'
          ELSEIF '&C'=''
C         DEFL    '&A'
          ENDIF

          IF '&A'<>'A'
          LDA     &A
          ENDIF

          CLC                            hackable byte, if not needed
          ADC     &B

          IF '&C'<>'A'
          STA     &C
          ENDIF

          ENDM

MOVEWORD  MACRO   A,B
          MOVE    &A,&B
          MOVE    &A+1,&B+1
          ENDM

CLRB      MACRO   A
          MOVE    #0,&A
          ENDM

CLRW      MACRO   A
          MOVE    #0,&A,&A+1
          ENDM

INCWORD   MACRO   A,B,C,D

          IF      '&B'='X'.OR.'&B'='Y'
A         DEFL    '&A!,&B'
B         DEFL    C
C         DEFL    D
          ENDIF

          IF      '&C'='X'.OR.'&C'='Y'
B         DEFL    '&B!,&C'
          ENDIF

          INC     &A
          BNE     Z&INDX

          IF  '&B'=''
          INC     &A!+1
          ELSE
          INC     &B
          ENDIF

Z&INDX
          ENDM

DECWORD   MACRO   A,B,C,D

          IF      '&B'='X'.OR.'&B'='Y'
A         DEFL    '&A!,&B'
B         DEFL    C
C         DEFL    D
          ENDIF

          IF      '&C'='X'.OR.'&C'='Y'
B         DEFL    '&B!,&C'
          ENDIF

          SEC
          LDA     &A
          SBC     #1
          STA     &A
          LDA     &B
          SBC     #0
          STA     &B
          ENDM

ADDWORD   MACRO   A,B,C,D,E,F,G,H

          IF '&B'='X'.OR.'&B'='Y'
A         DEFL    '&A!,&B'
B         DEFL    '&C'
C         DEFL    '&D'
D         DEFL    '&E'
E         DEFL    '&F'
F         DEFL    '&G'
G         DEFL    '&H'
          ENDIF

          IF '&C'='X'.OR.'&C'='Y'
B         DEFL    '&B!,&C'
C         DEFL    '&D'
D         DEFL    '&E'
E         DEFL    '&F'
F         DEFL    '&G'
          ENDIF

          IF '&D'='X'.OR.'&D'='Y'
C         DEFL    '&C!,&D'
D         DEFL    '&E'
E         DEFL    '&F'
          ENDIF

          IF '&E'='X'.OR.'&E'='Y'
D         DEFL    '&D!,&E'
          ENDIF

          CLC
          LDA     &A
          ADC     &C
          STA     &A
          LDA     &B
          ADC     &D
          STA     &B

          ENDM

INCTIME   MACRO   R
          INCWORD &R,&R!+1
          ENDM

SUBWORD   MACRO   A,B,C,D,E,F,G,H

          IF '&B'='X'.OR.'&B'='Y'
A         DEFL    '&A!,&B'
B         DEFL    '&C'
C         DEFL    '&D'
D         DEFL    '&E'
E         DEFL    '&F'
F         DEFL    '&G'
G         DEFL    '&H'
          ENDIF

          IF '&C'='X'.OR.'&C'='Y'
B         DEFL    '&B!,&C'
C         DEFL    '&D'
D         DEFL    '&E'
E         DEFL    '&F'
F         DEFL    '&G'
          ENDIF

          IF '&D'='X'.OR.'&D'='Y'
C         DEFL    '&C!,&D'
D         DEFL    '&E'
E         DEFL    '&F'
          ENDIF

          IF '&E'='X'.OR.'&E'='Y'
D         DEFL    '&D!,&E'
          ENDIF

          SEC
          LDA     &A
          SBC     &C
          STA     &A
          LDA     &B
          SBC     &D
          STA     &B

          ENDM

SUB       MACRO   A,B,C,D,E,F            source1,source2,destination

          IF '&B'='X'.OR.'&B'='Y'
A         DEFL    '&A!,&B'
B         DEFL    '&C'
C         DEFL    '&D'
D         DEFL    '&E'
E         DEFL    '&F'
          ENDIF

          IF '&C'='X'.OR.'&C'='Y'
B         DEFL    '&B!,&C'
C         DEFL    '&D'
D         DEFL    '&E'
          ENDIF

          IF '&D'<>''
C         DEFL    '&C!,&D'
          ELSEIF '&C'=''
C         DEFL    '&A'
          ENDIF

          IF '&A'<>'A'
          LDA     &A
          ENDIF

          SEC                            hackable byte
          SBC     &B

          IF '&C'<>'A'
          STA     &C
          ENDIF

          ENDM

BLT       MACRO   A,B,C
          IF      '&B'='X'.OR.'&B'='Y'.AND.'&C'<>''   ; handles label='X'
A         DEFL    '&A!,&B'
B         DEFL    C
          ENDIF

          IF      '&B'<>''
          LDA     &A
          BMI     &B
          ELSE
          BCC     &A
          ENDIF
          ENDM

BGE       MACRO   A,B,C
          IF      '&B'='X'.OR.'&B'='Y'.AND.'&C'<>''
A         DEFL    '&A!,&B'
B         DEFL    C
          ENDIF

          IF      '&B'<>''
          LDA     &A
          BPL     &B
          ELSE
          BCS     &A
          ENDIF
          ENDM

BGT       MACRO   A,B,C
          IF      '&B'='X'.OR.'&B'='Y'.AND.'&C'<>''
A         DEFL    '&A!,&B'
B         DEFL    C
          ENDIF

          IF      '&B'<>''
          LDA     &A
          BEQ     ZZ&INDX                who knows if conflict ?
          BPL     &B                     (with this assembler !?!)
ZZ&INDX
          ELSE
          BEQ     Z&INDX
          BCS     &A
Z&INDX
          ENDIF
          ENDM


PHX       MACRO
          TXA
          PHA
          ENDM

PHY       MACRO
          TYA
          PHA
          ENDM

PLX       MACRO
          PLA
          TAX
          ENDM

PLY       MACRO
          PLA
          TAY
          ENDM

PUSH      MACRO   A

          IF '&A'='X'
          PHX

          ELSEIF  '&A'='Y'
          PHY

          ELSEIF  '&A'='A'.OR.'&A'='ACC'
          PHA

          ELSEIF  '&A'='XY'.OR.'&A'='INDEX'.OR.'&A'='YX'
          PHX
          PHY

          ELSE                           otherwise, you got'em all
          PHX
          PHY
          PHA
          ENDIF
          ENDM

PULL      MACRO   A

          IF '&A'='X'
          PLX

          ELSEIF  '&A'='Y'
          PLY

          ELSEIF  '&A'='A'.OR.'&A'='ACC'
          PLA

          ELSEIF  '&A'='XY'.OR.'&A'='INDEX'.OR.'&A'='YX'
          PLY
          PLX

          ELSEIF  '&A'='YX'
          PLX
          PLY

          ELSE                           otherwise, you got'em all
          PLY
          PLX
          PLA
          ENDIF
          ENDM

SAVE      MACRO   A
          LDA     &A
          PHA
          ENDM

RESTORE   MACRO   A
          PLA
          STA     &A
          ENDM

; Note that MSTAT must read the same value TWICE to be assured the value is
;         correct.

ONSCREEN  MACRO
Z&INDX    BIT     $28                    mstat
          BMI     Z&INDX
          ENDM

OFFSCRN   MACRO
Z&INDX    BIT     $28                    mstat
          BPL     Z&INDX
          ENDM

INVBLANK  MACRO
          OFFSCRN
          ENDM


FILL      MACRO   ADDR,COUNT,VALUE
          IF '&VALUE'=''
VALUE     DEFL    0
          ENDIF

          IF &COUNT<5                    5 is changeable

          LDA     #&VALUE
          DO      &COUNT                 for really short fills
COUNT     DEFL    &COUNT-1
          STA     &ADDR+&COUNT
          ENDDO

          ELSEIF &COUNT<$100

          LDA     #&VALUE                short form, less than a page
          LDX     #&COUNT
Z&INDX    STA     &ADDR-1,X
          DEX
          BNE     Z&INDX

          ELSE
          LDA     #L(&ADDR)
          STA     TEMP0
          LDA     #H(&ADDR+&COUNT-1)     change
          STA     TEMP1
          LDA     #&VALUE

          IF      &COUNT.MOD.$100<>0     special case
          STA     &ADDR+((&COUNT/$100)*$100)   missing byte
          LDY     #&COUNT.MOD.$100-1
          LDX     #&COUNT/$100+1
          ELSE
          LDY     #0
          LDX     #&COUNT/$100
          ENDIF

          JSR     ZZZZFILL
          ENDIF
          ENDM

COPY      MACRO   FROM,TO,COUNT
          IF &COUNT<5                    5 is changeable

          DO      &COUNT                 for really short fills
COUNT     DEFL    &COUNT-1
          LDA     &FROM+&COUNT
          STA     &TO+&COUNT
          ENDDO

          ELSEIF &COUNT<$100

          LDX     #&COUNT                short form, less than a page
Z&INDX    LDA     &FROM-1,X
          STA     &TO-1,X
          DEX
          BNE     Z&INDX

          ELSE                           greater than one page

          IF      &COUNT.MOD.$100<>0     special case
          LDA     &FROM+((&COUNT/$100)*$100)     special case-- missing byte
          STA     &TO+((&COUNT/$100)*$100)
          LDY     #&COUNT.MOD.$100-1
          LDX     #&COUNT/$100+1
          ELSE
          LDY     #0
          LDX     #&COUNT/$100
          ENDIF

          LDA     #L(&FROM)
          STA     TEMP0
          LDA     #H(&FROM+&COUNT.AND.$FF00)
          STA     TEMP1
          LDA     #L(&TO)
          STA     TEMP2
          LDA     #H(&TO+&COUNT.AND.$FF00)
          STA     TEMP3
          JSR     ZZZZCOPY               If this is used, change "library.s"
          ENDIF
          ENDM

MOVEPTR   MACRO   PTR,WHERE
          LDA     #L(&PTR)
          STA     &WHERE
          LDA     #H(&PTR)
          STA     &WHERE+1
          ENDM


CLEAR     MACRO   A
          IF '&A'='ALL'.OR.'&A'='TOP'
* * expand this for optimality ! * *
          LDA     #0
          LDX     #$10                   [$40,$4F]
Z&INDX    STA     $3F,X
          DEX
          BNE     Z&INDX

          LDX     #$10                   [$140,$14F]
Y&INDX    STA     $13F,X
          DEX
          BNE     Y&INDX
          ENDIF

          IF '&A'<>'TOP'
          DMAOFF                         off when wiping out display list(s)
          JSR     CLRMARIA
          ENDIF
          ENDM


DMAOFF    MACRO
          JSR     XDMAOFF
          ENDM

DMAON     MACRO
          JSR     XDMAON
          ENDM

NEWSTATE  MACRO   STATE                  ; advance to a new state
          MOVEPTR &STATE,GODPTR          ; GOD is zero page address
          ENDM

ENDCYCLE  MACRO
          JMP     GOD
          ENDM

; conditional and iteration macros; with nesting up to 10 levels
;         Note: the maximum number of levels can be increased
;         indefinitly if anyone needs more (!).

; The conditional macros:

$IF        MACRO  A,B,C

          IF '&B'<>''                    If three arguments, do the compare
             LDA  &A
             CMP  &C
A         DEFL    '&B'
          ENDIF

          &&&A    LS&INDX
STK&PTR   DEFG    'LS&INDX'              pop off in ENDIF
PTR       DEFG    &PTR+1

          ENDM

$ELSE     MACRO
          JMP     END&INDX             ;if was satisfied; skip to ENDIF
PTR       DEFG    &PTR-1
&&STK&PTR

STK&PTR   DEFG    'END&INDX'
PTR       DEFG    &PTR+1
          ENDM

$ENDIF    MACRO                          ;if not, it comes here
PTR       DEFG    &PTR-1
&&STK&PTR
          ENDM

; Iteration macros: DO ... WHILE condition
;         and       REPEAT ... UNTIL condition
;   Note that since DO==REPEAT and WHILE==UNTIL, any combination
;         will have the desired effect: DO... UNTIL; REPEAT...WHILE

$DO       MACRO
DO&INDX
STK&PTR   DEFG    'DO&INDX'
PTR       DEFG    &PTR+1
          ENDM

$WHILE    MACRO   A,B,C

          IF '&B'<>''                    If three arguments, do the compare
             LDA  &A
             CMP  &C
A         DEFL    '&B'
          ENDIF

          &&&A    WH&INDX              branch around jump if not satisfied

PTR       DEFG    &PTR-1
          JMP     &&STK&PTR              jump back to label on stack

WH&INDX
          ENDM

; repeat-until macro-- identical to do--while

$REPEAT   MACRO
DO&INDX
STK&PTR   DEFG    'DO&INDX'
PTR       DEFG    &PTR+1
          ENDM

$UNTIL    MACRO   A,B,C

          IF '&B'<>''                    If three arguments, do the compare
             LDA  &A
             CMP  &C
A         DEFL    '&B'
          ENDIF

          &&&A    WH&INDX              branch around jump if not satisfied

PTR       DEFG    &PTR-1
          JMP     &&STK&PTR

WH&INDX

          ENDM

