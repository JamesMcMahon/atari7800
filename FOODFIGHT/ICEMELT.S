; ICEMELT.S
; THIS ROUTINE HANDLES THE ICE CREAM CONE DRIPPING.  WHEN THE VALUE
;         IN "FINFO" REACHES 0, IT'S TIME FOR ANOTHER DRIP.
;         AT THIS POINT I DECREMENT "FSTATE", WHICH IS ESSENTIALLY
;         A FRAME COUNTER.  WHEN "FSTATE" REACHES 0, THE CONE HAS
;         COMPLETELY MELTED AND I SHOULD INITIATE THE HERO-CONE-TIME-OUT
;         SEQUENCE.
;    THE COUNTER "FINFO" IS DECREMENTED IN THE KERNEL,
;         TO ENSURE ONLY ONE DECREMENT EVERY 30TH OF A SECOND.

          GLBL    HEROKILL               ; IN "CHEFHIT.S"
          GLBL    ICEMELT

; This routine has been placed here so that I can branch to it from the
;         beginning of ICEMELT, rather than having to JUMP.
; ROUTINE JUMPS HERE IF RACK IS ENDING VIA CHUCK DYING

CFLASH    LDA     FINFO
          BNE     IMBYE

ZCF00     LDA     #10
          STA     FINFO

          INC     FSTATE                 ; LOW BIT TELLS WHETHER FLASH OR NOT

          LDA     FDLPOS                 ; FIND OUT WHERE TO PUT THE STAMP
          AND     #$F
          TAX
          LDA     LISTTABL,X
          STA     LISTPTRA
          LDA     LISTTABH,X
          STA     LISTPTRA+1

          LDA     FDLPOS
          AND     #$F0
          LSR     A
          LSR     A
          TAY                            ; INDEX FOR DLIST IS NOW IN Y

          LDA     FSTATE                 ; FIND OUT WHICH STAMP
          LSR     A
          BCC     ZFLSH002

ZFLSH001  LDA     ICECHAR                ; FLASH STAMP
          BNE     ZFLSH003               a jump
ZFLSH002  LDA     ICECHAR+1              ; EMPTY CONE
ZFLSH003  STA     (LISTPTRA),Y           ; CHANGE LOW BYTE OF STAMP

IMBYE     RTS

*****************************************

ICEMELT
          LDA     STATUS
          CMP     #STATDIEC              ; IF CONE IS FLASHING
          BEQ     CFLASH

IMCONT00  CMP     #STATDIEH              ; if he's dying (except for STATDIEC)
          BPL     IMBYE                  ; don't continue

IMCONT10  CMP     #STATHIT
          BEQ     IMBYE

IMCONT01  CMP     #STATBON               ; IF FOOD IS HITTING SCORE, DON'T MELT
          BEQ     IMBYE

; IF WE GET HERE, WE'RE MELTING.  HANDLE THE ANIMATION, ETC.--

IMCONT02  LDA     DRIPFRAM
          CMP     #99                    ; THIS MEANS WAIT BEFORE NEXT DRIP
          BEQ     ZDRPWAIT

          LDA     DRIPTIME
          BEQ     NXTDRIP
          JMP     ZIM000

NXTDRIP   LDA     #5
          STA     DRIPTIME

          DEC     DRIPFRAM

          LDA     DRIPFRAM
          CMP     #1                     ; FIRST SPLASH
          BEQ     ZSPLSH00
          CMP     #0
          BEQ     ZSPLSH01
          BMI     ZDRPSTRT               ; IF NEGATIVE, START ANOTHER DROPLET

          LDA     CYPOS+DRIPSTRT         ; ELSE, JUST MOVE THE DROP DOWN
          SEC
          SBC     #1
          STA     CYPOS+DRIPSTRT
          JMP     ZIM000

ZSPLSH00  LDA     DRIPCHAR+1
          STA     CSTAMP+DRIPSTRT

          LDA     #14   