; CHEFHIT.S
; THIS ROUTINE TESTS TO SEE IF CHUCK HAS DIED DUE TO HITTING A CHEF.

          GLBL    HEROKILL
          GLBL    MKDIE
          GLBL    MKAREJOY
          GLBL    CHEFHIT

          GLBL    SCRAPALL,TUNIN

          GLBL    FALLING,DYHERO,DXHERO,CHEFSTRT
          GLBL    STATDIE,AFDERASE,NULLCHAR
          GLBL    CSTAMP,CCRUNL,CINFO
          GLBL    PL0LIVES
          GLBL    IRCHTIME,IRDXHERO,IRDYHERO
          GLBL    HELDFOOD,CARRYING

          GLBL    HYCENTER,DYHCHAR

          GLBL    ERASEIT

          GLBL    GOD

DXHCHEF   EQU     $04
DYHCHEF   EQU     $08
EXTRA     EQU     1

DRIPSTRT  EQU     $1F

          RAMDEF                         ; ZERO PAGE

          RSEG    CODE1

          PRINT   GEN

CHEFHIT
          LDX     #12                    ; #CHEFSTRT + #NUMCHEFS - 3
          LDY     #3                     ; INDEX TO CENTER AND DELTA TABLES

          LDA     CSTATE                 If the hero is falling, no
          CMP     #FALLING               intersection with chefs
          BMI     ZCHEFH0
          RTS

ZCHEFH0   LDA     CSTATE,X               ; CHEF'S STATE
          CMP     #FALLING               ; IF RISING OR FALLING, IGNORE
          BPL     NXTCHTST

          LDA     #0                     ; TELLS ME THIS IS THE NEARNESS TEST
          STA     TEMP2

          LDA     #IRDXHERO              ; NEARNESS TEST FIRST
          STA     TEMP0
          LDA     #IRDYHERO
          STA     TEMP1
          JMP     IRLOOP2

AAAAX
IRLOOP1   LDA     #DXHERO+DXHCHEF        ; COME HERE IF NEARNESS TEST IS
          STA     TEMP0                  ;  SUCCESSFUL-- TEST FOR REAL
          LDA     DYHCHAR,Y
          STA     TEMP1

; to get y delta, do chefy - (chucky - normalize)

IRLOOP2   LDA     CYPOS,X                ; TEST Y COORD.
          BEQ     NXTCHTST               ;  IF HE'S NOT ON SCREEN
          SEC
          SBC     CYPOS                  ; HERO'S Y
          CLC
AAA1      ADC     HYCENTER,Y             ; CHEFS ARE SHORTER- ADD TO NORMALIZE

          BPL     CHHYPOS                ; Y DIFF POSITIVE
          EOR     #$FF                   ; ELSE, 2'S COMPLEMENT
          CLC
          ADC     #1

CHHYPOS   CMP     TEMP1                  ; IR CLOSENESS OR CHEF
;         BMI     CHXTST                 ; TEST X DIFFERENCE
          BPL     NXTCHTST               ; ELSE, GO ON TO NEXT CHEF

; the x delta is chefx - (chuckx + extra)

CHXTST    LDA     CXPOS,X
          SEC
          SBC     CXPOS                  ; HERO'S X
          SEC
AAA3      SBC     #EXTRA

          BPL     CHHXPOS                ; POSITIVE X DIFFERENCE
          EOR     #$FF                   ; ELSE, 2'S COMPLEMENT
          CLC
          ADC     #1

CHHXPOS   CMP     TEMP0
;         BMI     CHNEAR
          BPL     NXTCHTST

CHNEAR    LDA     TEMP2
          BNE     HEROKILL               this will jump to GOD

          INC     IRCHTIME

          INC     TEMP2
          JMP     IRLOOP1

NXTCHTST  DEX
          DEX
          DEX

          DEY                            ; DELTA TABLE INDEX
          BPL     ZCHEFH0

CHHITBYE  RTS

*************** END OF CHEFHIT ROUTINE ************************

; THIS ROUTINE IS CALLED FROM "CHEFHIT", "HOLEHIT", AND "FOODHIT"
;         IF THE HERO IS KILLED BY ONE OF THESE THINGS.
;         IT SETS THE HERO APPROPRIATELY AND DOES SUITABLE ANIMATIONS.

HEROKILL  LDA     #STATDIE
          STA     STATUS

          JSR     SCRAPALL

          LDA     CXPOS                  ; USED BY "FOODMOVE" TO GO FOR CHUCK
          STA     GOALX

          LDA     CYPOS
          STA     GOALY

          LDA     CYCLECNT
          CLC
          ADC     #02
          STA     CINFO                  ; ANIMATE TIMER
          LDA     #70
          STA     SYSCOUNT

          JSR     MKDIE                  ; HANDLE DEATH STUFF

          LDX     CURRENT
          LDA     PL0LIVES,X
          CMP     #1
          BEQ     ZHKLASTS               ; LAST DEATH THIS GAME

          LDA     #1
          JSR     TUNIN
          LDA     #2
          JMP     TUNIN                  same as jsr and rts

ZHKLASTS  LDA     #10
          JSR     TUNIN
          LDA     #11
          JMP     TUNIN                  same as jsr and rts

; THIS ROUTINE IS CALLED FROM "MKHFALL" AND "HEROKILL"

MKDIE
          LDA     #1
          STA     MAXCYCLE

          LDA     #0                     ; MAKE CONE DRIP GO AWAY
          STA     CYPOS+DRIPSTRT
          STA     CYPOS+2                erase carrying arms, if any

          LDA     CSTATE
          CMP     #CARRYING
          BNE     MKSKIP

          LDX     #0                     chuck index
          JSR     ERASEIT                erase carried food

MKSKIP
          LDA     CCRUNL+2               ; GIVE CHUCK A BODY
          STA     CSTAMP+1

; FOR FINAL VERSION, MOVE "MKAREJOY" INTO THIS ROUTINE--

          JMP     MKAREJOY                ; IN "HOLEHIT.S"
                                         ; same as jsr and rts

          END

