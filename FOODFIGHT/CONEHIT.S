; CONEHIT.S
; THIS ROUTINE TESTS TO SEE IF CHUCK HAS WON DUE TO HITTING THE CONE.

          GLBL    CONEHIT

          GLBL    STATDIEH
          GLBL    XCLOSE,FXPOS,DXHERO,FYPOS,DYHERO,HWIN
          GLBL    STATWON,BLOCK2,CHSTAMP,CFRAME,MUNCHPW
          GLBL    CPALW,MUNCHLOW,CSTAMP,MUNCHHI,CACOUNT,CSPEED
          GLBL    CARRYING,HELDFOOD,CTYPE,PL0CARRY,CDIR
          GLBL    REJOYING,RETREAT,LEAVING,RUNNING
          GLBL    CCRUNL
          GLBL    CARRIED
          GLBL    COLORS

CONESTRT  EQU     $00
FOODSTRT  EQU     $0F
DRIPSTRT  EQU     $1F
DXCONE    EQU     $03
DYCONE    EQU     $07

          RAMDEF                         ; ZERO PAGE

          RSEG    CODE1

CONEHIT   LDA     STATUS                 don't test if he's dead
          CMP     #STATDIEH
          BPL     CBYE001

          LDA     CXPOS                  ; HERO'S X
          CMP     #XCLOSE                ;  IF HE'S NOT EVEN CLOSE, RETURN.
          BMI     CHCONT00
CBYE001   RTS

CHCONT00  SEC
          SBC     FXPOS+CONESTRT         ; CONE'S X
          BCS     CHXPOS                 ; X DIFF POSITIVE
          EOR     #$FF                   ; ELSE, TWO'S COMPLEMENT
;         CLC                            guaranteed clear
          ADC     #1

CHXPOS    CMP     #DXHERO+DXCONE
;         BCC     YCONETST
          BCS     CBYE001                a jump

YCONETST  LDA     CYPOS
          SEC
          SBC     FYPOS+CONESTRT
          BCS     CHYPOS                 ; Y DIFF POSITIVE
          EOR     #$FF                   ; ELSE, TWO'S COMPLEMENT
;         CLC                            guaranteed clear
          ADC     #1

CHYPOS    CMP     #DYHERO+DYCONE
;         BCC     HWIN
          BCS     CBYE001                a jump

HWIN      LDA     #STATWON
          STA     STATUS

          LDA     #1                     ; SLOW DOWN FOR MUNCH
          STA     MAXCYCLE

; POSITION HERO FOR MUNCH AND SET APPROPRIATE COUNTERS ETC.

          LDA     FXPOS
;         CLC                            clear from above
          ADC     #9
          STA     CXPOS
          STA     CXPOS+1
          STA     CXPOS+2

          LDA     FYPOS
          SEC
          SBC     #1
          STA     CYPOS
          CLC
          ADC     #16
          STA     CYPOS+2                ; UPPER HALF OF HEAD
          SEC
          SBC     #32
          STA     CYPOS+1

          LDA     #BLOCK2                ; THE TONGUE AND TWO HEAD HALVES
          STA     CHSTAMP
          STA     CHSTAMP+2
          STA     CHSTAMP+DRIPSTRT

          LDA     CCRUNL                 ; GIVE HIM A BODY, IF HE WAS CARRYING
          STA     CSTAMP+1

          LDX     #5
          STX     CFRAME

          LDA     MUNCHPW,X
          STA     CPALW
          STA     CPALW+2

          LDA     MUNCHLOW,X
          STA     CSTAMP
          LDA     MUNCHHI,X
          STA     CSTAMP+2

          STX     CACOUNT                X already has 5
          STX     CSPEED

; SET UP PLCARRY: IF NO FOOD, SET IT TO ZERO

          LDY     CURRENT

          LDA     CSTATE
          CMP     #CARRYING
;         BEQ     CHIT080
          BNE     CHIT090                a jump

CHIT080   LDX     HELDFOOD               ; HERO'S FOOD

          LDA     #$80
          ORA     CTYPE,X
          STA     PL0CARRY,Y

          LDA     #0                     ; ERASE THE FOOD
          STA     CYPOS,X
          BEQ     CHIT091                a jump

CHIT090   LDA     #0
          STA     PL0CARRY,Y

; NOW DEAL WITH ALL THE CHEFS SO THAT THEY RUN AWAY FROM THE CONE
;         APPROPRIATELY

CHIT091   LDX     #$0C

HWINLOOP  LDA     CSTATE,X               if this chef is leaving due to
          CMP     #LEAVING               being hit, let him keep going
          BEQ     HWINNXT

          LDA     FYPOS
          CLC
          ADC     #16
          CMP     CYPOS,X
          BCS     HWIN11

HWIN10    LDA     #1                     ; UPPER RIGHT DIRECTION
          BNE     HWIN20                 A JUMP

HWIN11
;         SEC                            carry is set from BCS above
          SBC     #48
          CMP     CYPOS,X
          BCS     HWIN12
          LDA     #2                     ; RUN RIGHT
          BNE     HWIN20

HWIN12    LDA     #3                     ; LOWER RIGHT

HWIN20    STA     CDIR,X

          LDA     #$1                    ; FASTER SPEED
          STA     CSPEED,X

; GET RID OF ANY FOOD BEING CARRIED:

          LDA     CSTATE,X
          CMP     #CARRYING
          BNE     HWIN30

          LDA     HELDFOOD,X
          TAY
          LDA     #0
          STA     CYPOS,Y

          JMP     HWIN31                 ; OKAY TO MAKE RETREAT

HWIN30    CMP     #RUNNING               ; MUST BE RUNNING OR CARRYING
          BEQ     HWIN31
                                         ;  OR REJOICING (ONLY HAPPENS IF
                                         ;  "MKDIE" WAS CALLED SAME CYCLE)
HWIN301   CMP     #REJOYING
          BNE     HWINNXT

HWIN31    LDA     #LEAVING               ; CHEF SHOULDN'T CHANGE DIRECTION
          STA     CSTATE,X

HWINNXT   DEX
          DEX
          DEX
          CPX     #3                     ; FIRST CHEF
          BPL     HWINLOOP

          LDA     #$60                   ; MAKE THE CHEFS BLUE
          STA     COLORS+6

; SET POSITION OF THE TONGUE STAMP (FOR THIS I USE THE CONE DROP STAMP)

          LDA     CXPOS
          STA     CXPOS+DRIPSTRT

          LDA     CYPOS
          STA     CYPOS+DRIPSTRT

CONEHBYE  RTS

          END

