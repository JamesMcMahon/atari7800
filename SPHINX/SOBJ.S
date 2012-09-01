*******SOBJ.S     LINKED LIST MANIPULATION SHIT

; OTEMP1 THRU OTEMP4 ARE FOR THESE ROUTINES ONLY RIGHT NOW
;DOES ANYONE USE OTEMP4?????  YES, NOSTUB DOES TO SAVE Y
;         OTEMP1 IS ALWAYS USED TO PRESERVE Y
; ALL OF THESE ROUTINES SHOULD BE INTERUPTABLE

;          ZERODEF

;          RSEG    CODE9
;
; SUBROUTINE TO INSERT NEW OBJECT IN LIST
;         INDEX IN X
;         DC IN TEMP6, DF IN TEMP10
;         TRASHES A, Y AND TEMP5
;
OBJINS:
          STY     OTEMP1

;         JSR     LISTEST                ;FILL TESTLIST WITH ONE'S
 ;        LDA     TESTLIST,X             ;LOOK FOR A ONE.  IF SO, IT IS ALREADY
  ;       BNE     BNE                    ;IN

          LDA     TEMP6
          STA     DXTBL,X
          LDA     TEMP10
          STA     DFTBL,X

          LDY     #ZREF3                 ;FIND REFERENCE POINT TO INSERT AT
;         LDA     TEMP10                 ; NEW DF
          ;TEMP10 IS ALREADY IN A
FOLLLP:   CMP     DXTBL,Y                ; DC OF REFERENCE POINT
          BCC     FOLLOW
          DEY
          CPY     #ZREF0
          BCS     FOLLLP
          LDA     LOWEST                 ;LOWEST IS USED AS DEFAULT

OBJINSLP: TAY                            ;FIND FIRST OBJECT WITH HIGHER PRIORITY
          LDA     DFTBL,Y                ; OLD DF
          CMP     TEMP6                  ; NEW DC
          BCC     OBJINSFN               ; NEW DC > OLD DF - FOUND IT
          LDA     TEMP10                 ; NEW DF
          CMP     DXTBL,Y                ; OLD DC
          BCC     FOLLOW                 ; NEW DF < OLD DC - TRY NEXT ONE
          LDA     YTBL,Y                 ; OLD Y
          CMP     YTBL,X                 ; NEW Y
          BCS     OBJINSFN               ; NEW Y <= OLD Y - FOUND IT
FOLLOW:   LDA     RLTBL,Y                ; OTHERWISE, TRY NEXT ONE
          BPL     OBJINSLP               ; NOT AT END OF LIST
          STA     RLTBL,X                ;PUT OBJECT AT END OF LIST
          STX     HIGHEST
          TXA
          STA     RLTBL,Y
          TYA
          STA     LLTBL,X
;         JSR     LISTEST
          LDY     OTEMP1
          RTS
OBJINSFN: TYA                            ;OTHERWISE INSERT OBJECT
          STA     RLTBL,X
          LDA     LLTBL,Y
          STA     LLTBL,X
          STA     OTEMP3
          TXA
          STA     LLTBL,Y
          LDY     OTEMP3
          BMI     OBJINSBG
          STA     RLTBL,Y
;         JSR     LISTEST
          LDY     OTEMP1
          RTS
OBJINSBG: STX     LOWEST                 ;CHANGE LOWEST IF IT NEEDS IT
;         JSR     LISTEST
          LDY     OTEMP1
          RTS

; BNE       BNE     BNE
; BEQ       BEQ     BEQ

;
; SUBROUTINE TO DELETE OBJECT FROM LIST
;         INDEX IN X
;
OBJDEL:
;         CPX     #PYRSTART
 ;        BCC     NOSTUB
  ;       CPX     #PYRSTOP
   ;      BCS     NOSTUB

    ;     LDA     VPTBL,X                ;THIS LOOKS FOR DELETING SCROLLING
     ;    CMP     #SCRENBOT+1            ;OBJECT WHICH IS NOT IN LIST
      ;   BNE     BNE
NOSTUB:
          STX     OTEMP2
          STY     OTEMP4                 ;ONLY NOSTUB STORES Y IN OTEMP4

;         JSR     LISTEST                ;CHECKS TO SEE OF OBJECT IS NOT IN
;         LDA     TESTLIST,X             ;LIST BEFORE DELETING
 ;        BEQ     BEQ

          LDY     LLTBL,X                ;THIS IS CALLED BY OTHER SCROLLING
                                         ;ROUTINES SO IT CAN'T USE OTEMP1
                                         ;FOR Y
          BMI     OBJDELBG               ; DELETING FIRST OBJECT IN LIST
          LDA     RLTBL,X
          STA     RLTBL,Y
          BMI     OBJDELEN               ; DELETING LAST OBJECT IN LIST
          TAX                            ;OTHERWISE, JUST DELETE
          TYA
          STA     LLTBL,X
          LDX     OTEMP2
;         JSR     LISTEST
          LDY     OTEMP4
          RTS
OBJDELBG: LDA     RLTBL,X                ;RIGHT LINK IS LOWEST NOW
          STA     LOWEST
          TAY
          LDA     #$FF                   ;IT'S LEFT LINK IS FF
          STA     LLTBL,Y
;         JSR     LISTEST
          LDY     OTEMP4
          RTS                            ;NOTHING LEFT TO DELETE END
OBJDELEN: STY     HIGHEST
          LDY     OTEMP4
          RTS
;
; SUBROUTINE TO MOVE AN OBJECT ALREADY IN THE LIST
;         INDEX IN X
;         NEW DC IN TEMP6, DF IN TEMP10
;         TRASHES Y, A AND TEMP5
;
OBJMOV:
          STY     OTEMP1
          LDA     TEMP10
          STA     DFTBL,X
          LDA     TEMP6
          CMP     DXTBL,X
          STA     DXTBL,X
          BEQ     CANTGO
          BCS     LEFTY                  ;IF GOING TO THE RIGHT, THIS ISN'T BAD

          LDY     RLTBL,X
          LDA     DFTBL,Y
          CMP     TEMP6
          BCC     CANTGO                 ; PUNT IF NOT CROSSING NEXT OBJECT

          LDY     LLTBL,X                ; STARTING POINT TO RE-INSERT
          BPL     RIGHTOK
          LDY     RLTBL,X
RIGHTOK:  JSR     NOSTUB                 ; DELETE OBJECT (PRESERVES Y)
                                         ;TRASHES OTEMP1 HOWEVER!!!!
          TYA                            ; GET STARTING POINT
          JMP     OBJINSLP               ; INSERT NEAR STARTING POINT

                                         ;OTHERWISE, CHECK TO THE LEFT
LEFTY:
                                         ; THIS FOLLOWS LIST TO THE LEFT UNTIL
                                         ; EITHER THE BEGINNING OR AN OBJECT
                                         ; THAT DOESN'T OVERLAP AND HAS LOWER
                                         ; PRIORITY IS FOUND. THEN IT CALLS
                                         ; OBJINSLP.
          LDY     LLTBL,X
          LDA     TEMP10
          CMP     DXTBL,Y
          BCC     CANTGO

MOVLLP:   LDA     LLTBL,Y
          BMI     MOVLFN
          TAY                            ; THIS WAS ABOVE THE BMI
          LDA     TEMP10
          CMP     DXTBL,Y
          BCS     MOVLLP                 ; MIGHT WANT TO USE Y TO RIGHT
MOVLFN:   JSR     NOSTUB                 ;Y IS NOT PRESERVED WHEN WE CALL NOSTUB
          TYA                            ;SINCE WE STORED Y IN OTEMP1 WHEN WE
          JMP     OBJINSLP               ;ENTERED OBJMOV!!!!!!!!



CANTGO:
;         JSR     LISTEST
          LDY     OTEMP1
          RTS



;LIST TEST LOOKS FOR LOOPS IN LINKED LIST

; ROUTINE TO VERIFY LIST

; LISTEST   STX     OTEMP2                 ; ROUTINE TO TEST FOR LOOPS IN LIST
                                         ;WE CAN TRASH Y HERE
  ;       LDX     #83
   ;      LDA     #0
; TESTZERO  STA     TESTLIST,X             ;CLEAR OUT TEST LIST
  ;       DEX
   ;      BPL     TESTZERO
    ;     LDY     #0

     ;    LDA     LOWEST
      ;   BMI     PASSED                 ;ITS OVER
; INCTEST   TAX
  ;       LDA     TESTLIST,X
   ;      BNE     THEBNE
    ;     INC     TESTLIST,X             ;MARK ENTRY AS USED
     ;    TXA
      ;   STA     ORDTEST,Y
       ;  INY
;         LDA     RLTBL,X
 ;        BPL     INCTEST
  ;       STA     ORDTEST,Y              ;TO STORE FF AT END OF ORDTEST

   ;      DEY                            ;TO LOOK AT LAST ORDTEST
    ;     LDX     HIGHEST
     ;    BMI     PASSED
      ;   TXA
; ORDERING  CMP     ORDTEST,Y
  ;       BNE     LLFUCK
   ;      DEY
    ;     LDA     LLTBL,X
     ;    TAX
      ;   BPL     ORDERING

; PASSED
  ;       LDX     OTEMP2
   ;      RTS

; THEBNE    BNE     THEBNE
; LLFUCK    BNE     LLFUCK


;
; SUBROUTINE TO UPDATE THE LIST WHEN AN OBJECT IS SCROLLED
;         INDEX IN X
;         TRASHES Y, A, TEMP5 AND TEMP6
;
OBJSCR:                                  ;DECREMENT DC AND DF AUTOMATICALLY
;         LDA     VPTBL,X                ;THIS LOOKS FOR MOVING UNINSERTED OBJ
 ;        CMP     #SCRENBOT+1
  ;       BEQ     BEQ
   ;      CMP     #SCRENBOT+2
    ;     BEQ     BEQ

          LDY     RLTBL,X                ; STARTING POINT TO RE-INSERT
          BMI     FUCKEDUP
          JSR     NOSTUB                 ; DELETE OBJECT (PRESERVES Y)
                                         ;TRASHES OTEMP1

          LDA     DXTBL,X
          STA     TEMP6                  ; NEW DC
          LDA     DFTBL,X
          STA     TEMP10                 ; NEW DF

          TYA                            ; GET STARTING POINT
;         BMI     FUCKEDUP               ; NEED TO INSERT AT END OF LIST
          JMP     OBJINSLP               ; INSERT NEAR STARTING POINT

FUCKEDUP: RTS
;         LDY     HIGHEST
;         LDA     #$FF
;         STA     RLTBL,X
;         TYA
;         STA     LLTBL,X
;         TXA
;         STA     RLTBL,Y
;         RTS

VRTS0:    LDA     #0
          STA     GSCRFLAG
          RTS

*** SCROLLING PROCEDURE CALLED FROM SKERNEL, SINIT ***
VSCRP:
          LDA     #0
          STA     GCOARSE

          LDA     SCRATE
          LSR     
          STA     SCROLLS
          BCC     VSKIP

          LDA     MAINCNT
          LSR     
          BCC     VSKIP
          INC     SCROLLS
VSKIP:
          LDA     SCROLLS
          BEQ     VRTS0
          LDY     #$80                   ;THIS TELLS SCROLL ON NEXT FRAME TO
          STY     GSCRFLAG               ;THIS TELLS MAINLOOP TO SCROLL

          CLC
          ADC     ZONEOFF
          SBC     #14
          STA     SCRDELTA

          BCC     SCRSHIT
          STY     GCOARSE

SCRSHIT:  LDX     HIGHEST
SCRLOOP:
          LDA     LLTBL,X                ; NEED TO GET LINK BEFORE SCROLLING
          STA     TEMP9
          CPX     #PYRSTART
          BCC     SCRNEXT
          CPX     #PYRSTOP+1
          BCS     SCRNEXT

          LDA     VPTBL,X
          CLC
          ADC     SCROLLS
          STA     VPTBL,X
          CMP     #$E0
          BCS     SCRNODEL
          CMP     #SCRENBOT
          BCS     SCRDEL
SCRNODEL:
          LDA     HPTBL,X
          SEC
          SBC     SCROLLS
          STA     HPTBL,X

          LDA     ZTBL,X
          SEC
          SBC     SCROLLS
          STA     ZTBL,X

          LDA     COLZ1,X
          SEC
          SBC     SCROLLS
          STA     COLZ1,X

          LDA     COLZ2,X
          SEC
          SBC     SCROLLS
          STA     COLZ2,X

          LDA     DXTBL,X
          CMP     #$FD
          BCS     SCRNEXT                ; DON'T SCROLL DX OF HIERO'S
          SEC
          SBC     SCROLLS
          BNE     DCOKAY
          LDA     #1
DCOKAY:   STA     DXTBL,X

          LDA     DFTBL,X
          SEC
          SBC     SCROLLS
          BNE     DFOKAY
          LDA     #1
DFOKAY:   STA     DFTBL,X

          LDA     RLTBL,X
          CMP     #PYRSTART
          BCC     SCRNSCR
          CMP     #PYRSTOP+1
          BCC     SCRNEXT
SCRNSCR:  JSR     OBJSCR
SCRNEXT:  LDX     TEMP9
          BPL     SCRLOOP
          RTS

SCRDEL:   LDA     #0
          STA     COLSTAT,X
          LDA     #SCRENBOT+1
          STA     VPTBL,X
          JSR     OBJDEL                 ; ASSUME THIS PRESERVES X
          JSR     RETASLOT

          JMP     SCRNEXT

; GETASLOT - ALLOCATES LOADER TABLE SLOTS FOR ANYTHING THAT NEEDS ONE
; AND RETURNS IT IN X. AN FF MEANS NONE WERE AVAILABLE

GETASLOT: LDX     SLOTGPTR
          LDA     SLOTQ,X

          INX
          CPX     #PYRSTOP-PYRSTART+1
          BNE     GOTASLOT
          LDX     #0

GOTASLOT: CPX     SLOTRPTR
          BEQ     NOTASLOT               ; NO SLOTS ARE LEFT

          STX     SLOTGPTR
          TAX
          RTS

NOTASLOT: LDA     #$FF
          TAX
          RTS

RETASLOT: TXA
          LDX     SLOTRPTR
          CPX     #0
          BEQ     SLOTPUNT
          CPX     #1
          BEQ     SLOTPNT1
          CPX     #2
          BEQ     SLOTPNT2
          CMP     SLOTQ-3,X
          BEQ     SLOTTRAP
SLOTPNT2: CMP     SLOTQ-2,X
          BEQ     SLOTTRAP
SLOTPNT1: CMP     SLOTQ-1,X
          BEQ     SLOTTRAP
SLOTPUNT: STA     SLOTQ,X
          INX
          CPX     #PYRSTOP-PYRSTART+1
          BNE     RTDASLOT
          LDX     #0
RTDASLOT: STX     SLOTRPTR
SLOTTRAP: RTS

;SLOTTRAP  JMP     SLOTTRAP

;          END
