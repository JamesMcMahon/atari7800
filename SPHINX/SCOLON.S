********  SCOLON.S    COLLISION SHIT

	org	$D000

*         IGNORE THE FOLLOWING DOCUMENTATION ITS ALL BEEN CHANGED
*
* SUBROUTINE TO DETECT COLLISIONS
*
* THIS ROUTINE TAKES A POINT AS INPUT (COLPX,COLPY,COLPZ) AND COMPARES IT TO
* ALL OF THE BOXES STORED IN THE COLLISIN TABLES.  IF IT FINDS AN ACTIVE BOX
* THAT CONTAINS THE PASSED POINT, THEN THE COLSTAT OF THE OBJECT IS RETURNED.
* THIS IS THE OBJECT TABLE INDEX OF THE BOXES CORRESPONDING OBJECT ON THE SCREEN
* CARE MUST BE TAKEN HERE ON BOUNDARIES OF THE COLLISION RANGES.
* CURRENTLY, THE BIRD ITS SHOTS ARE NOT IN THE TABLES TO AVOID REDUNDANT CHECKS.
*

BUFZONE   EQU     15                     ; CUTOFF FOR PUNTING

COLDET:   BIT     GCOARSE                ;NO COLLIISION DETECT ON COARSE SCROLL
          BPL     COLDTNC
          JMP     PUNTCOL

COLDTNC:  STX     TEMPX                  ;SAVE INDEX OF OBJECT BEING TESTED
          LDA     DXTBL,X                ;GET DC OF OBJECT BEING TESTED
          SEC
          SBC     #BUFZONE               ; BUFFER ZONE
          STA     JTEMP

COLOOP1:  LDA     RLTBL,X                ;GET RIGHT LINK
          BMI     NEXLOOP                ;END OF LIST SO GO OTHER DIRECTION
          TAX
          LDA     DFTBL,X                ;GET DF OF POTENTIALLY COLLIDING OBJECT
          CMP     JTEMP
          BCC     NEXLOOP                ;WE'RE DONE GOING RIGHT

          CPX     #ZREF0                 ;DON'T ATTEMPT TO DO COLLISION ON REF.
          BCS     COLOOP1                ;POINT

;DBG1:
          LDA     COLSTAT,X
          BEQ     COLOOP1

          LDA     COLPZ                  ;CHECK EXTENTS
          CMP     COLZ1,X
          BCC     COLOOP1
          CMP     COLZ2,X
          BCS     COLOOP1

          LDA     COLPX
          CMP     COLX1,X
          BCC     COLOOP1
          CMP     COLX2,X
          BCS     COLOOP1

          LDA     COLPY
          CMP     COLY1,X
          BCC     COLOOP1
          CMP     COLY2,X
          BCS     COLOOP1

          LDA     COLSTAT,X              ;YES A COLLISION SO RETURN WITH
          RTS                            ;INDEX IN X AND ID IN ACCUMULATOR



NEXLOOP:  LDX     TEMPX                  ;RETRIEVE INDEX OF OBJECT TO BE TESTED
          LDA     DFTBL,X                ;GET DF OF OBJECT BEING TESTED
          CLC
          ADC     #BUFZONE               ; BUFFER ZONE
          BCC     ZADDOK
          LDA     #$FF                   ; DON'T LET IT WRAP AROUND
ZADDOK:   STA     JTEMP
COLOOP2:  LDA     LLTBL,X                ;NOW GO DOWN THE LEFT LINKS
          TAX
          CMP     #ZREF0                 ;ON REFERENCE POINT GO TO NEXT ITEM
          BCS     COLOOP2
          CMP     #LASTPNT               ;END POINT TO THE LEFT
          BCS     PUNTCOL                ;
          LDA     JTEMP                  ; DF OF OBJECT BEING TESTED + 10
          CMP     DXTBL,X
          BCC     PUNTCOL

DBG2:
          LDA     COLSTAT,X
          BEQ     COLOOP2

          LDA     COLPZ                  ;CHECK EXTENTS
          CMP     COLZ1,X
          BCC     COLOOP2
          CMP     COLZ2,X
          BCS     COLOOP2

          LDA     COLPX
          CMP     COLX1,X
          BCC     COLOOP2
          CMP     COLX2,X
          BCS     COLOOP2

          LDA     COLPY
          CMP     COLY1,X
          BCC     COLOOP2
          CMP     COLY2,X
          BCS     COLOOP2

          LDA     COLSTAT,X              ;PUT ID OF COLLIDED OBJECT IN ACC.
          RTS

PUNTCOL:  LDA     #0
          RTS

; THIS ROUTINE CHECKS TO SEE IF THE BIRD IS OVER A HIEROGLYPH

HIERODET: LDX     #ZREF0                 ; START FROM REF PNT WITH DX = FC
HIEROLP:  LDA     LLTBL,X                ; AND SEARCH LEFT
          BMI     PUNTCOL                ; PUNT IF AT END

          TAX
          LDA     DXTBL,X
          CMP     #$FF
          BNE     HIEROLP                ; ONLY CHECK HIERO'S

          LDA     #ZBIRDZ+3              ;CHECK EXTENTS
          CMP     COLZ1,X
          BCC     HIEROLP
          CMP     COLZ2,X
          BCS     HIEROLP

          LDA     XTBL+ZBIRD
          CMP     COLX1,X
          BCC     HIEROLP
          CMP     COLX2,X
          BCS     HIEROLP

          LDA     COLSTAT,X              ;PUT ID OF COLLIDED OBJECT IN ACC.
          RTS

*
* SUBROUTINE TO FIND THE CHARACTER NUMBER CORRESPONDING TO X AND Z
*         X = OBJECT INDEX
*         A = Z OFFSET FROM REFERENCE POINT
*         THE RESULT IS RETURNED IN A
*

GRNDTYPE:
          STA     TEMP4
          STX     TEMP3
          LDA     VPTBL,X
GRNDFLO:  CMP     #SCRENBOT+1
          BCS     GRACEFUL
          STY     TEMP5                  ;PRESERVE Y

          SEC
          SBC     TEMP4
          SEC                            ;THIS CALCULATES ZONE NUMBER FROM VP
          SBC     ZONEOFF                ;WHICH IS CORRECTED BY ZOFFSET
          CLC
          ADC     #18                    ;14 FROM LOADER PLUS 4 TO GET TO
          CLC                            ;BOTTOM OF STAMP
          ADC     YTBL,X


          LSR     
          LSR     
          LSR     
          LSR                           ;ZONE NUMBER
          TAX                            ;PUT ZONE NUMBER INTO X

          LDA     HIBYE,X                ;USE ZONE NUMBER TO FIND DISPLAY LIST
          STA     PTR0+1                 ;HIGH BYTE OF DLIST
          LDX     #0                     ;CHARACTER MAP IS AT BEGINNING, SO
          STX     PTR0                   ;LOW BYTE OF DLIST IS 0

          LDA     (PTR0,X)               ;READ CHAR MAP POINTER FROM DLIST
          STA     PTR1                   ;LOW BYTE OF CHAR MAP
          LDY     #2
          LDA     (PTR0),Y
          STA     PTR1+1                 ;HIGH BYTE OF CHAR MAP

          LDX     TEMP3
;         LDA     XTBL,X                 ;THIS IS X+Z
 ;        CLC
  ;       ADC     ZTBL,X
     ;    CLC
      ;   ADC     #-NUMBER

          LDA     HPTBL,X
          CLC
          ADC     TEMP4                  ;ZOFFSET
          CLC
          ADC     #$9

          CLC
          ADC     JERKOFF                ;HPOS CORRECTED BY SCROLL

          LSR                           ;DIVIDE BY EIGHT TO GET CHAR NUMBER
          LSR     
          LSR     
          TAY                            ;CHAR NUMBER

          LDA     (PTR1),Y               ;CHAR VALUE
          LDY     TEMP5
          RTS

GRACEFUL:
          LDA     #0                     ;GUARANTEED LAND CHAR EXIT
          RTS

;          END
