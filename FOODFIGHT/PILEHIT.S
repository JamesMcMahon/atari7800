; PILEHIT.S
; THIS FILE CONTAINS THE ROUTINE "PILEHIT".  IT ALSO CONTAINS THE SMALL
;         ROUTINE "FOODADJ" WHICH IS CALLED FROM A CHARACTER DRIVER WHEN
;         THE CHARACTER IS DETECTED CARRYING A FOOD.
;   THIS ROUTINE IS LENGTHY AND COMPLEX BECAUSE IT MUST DO TWO THINGS:
;         1) CREATE A MOVING FOOD STRUCTURE AND ATTACH IT TO THE CHARACTER
;            WHO'S PICKED IT UP;
;         2) MODIFY THE DISPLAY LIST DIRECTLY TO DISPLAY A FOOD PILE WITH
;            ONE LESS FOOD.
;

          GLBL    TAKEFOOD
          GLBL    PILEHIT

DYPILE    EQU     10

PILEHIT   LDX     #12                    ; X WILL BE THE CHARACTER INDEX
          STX     TEMPX                  ;  IN CASE NXTPHPL IS REACHED

PHLOOP1   LDA     CYPOS,X                ; THIS IS THE CHARACTER LOOP
          BNE     PHCONT3                ; IF CHARACTER ON SCREEN, DO IT ALL
NPHCHJ    JMP     NXTPHCH                ; IF CHARACTER NOT ON SCREEN

PHCONT3   LDA     CSTATE,X
          CMP     #CARRYING
          BEQ     NPHCHJ                 ; IF HE'S NOT CARRYING, CHECK PILES
;;;       JMP     NXTPHCH                ; IF ALREADY CARRYING, HE CAN'T PICKUP

PHCONT5   CMP     #FALLING
          BPL     NPHCHJ                 ; IF STATE < FALLING, THEN CONTINUE
;;;       JMP     NXTPHCH

; NOW WE KNOW TO TEST THIS CHARACTER:

PHCONT6   LDA     CYPOS,X
          SEC
          SBC     CHHITE,X
          STA     TEMP1
          LDA     CXPOS,X
;         CLC
;         ADC     #0
          STA     TEMP0

          LDY     #PILESTRT+NUMEPILE     ; START WITH LAST PILE AND DECREMENT
          DEY                            ; INDEX IS ONE LESS THAN THE NUMBER
          STY     TEMPY                  ;  IN CASE NXTPHPL IS REACHED

PHLOOP2   LDA     FSTATE,Y               ; NUMBER OF FOODS IN PILE
          BNE     PHCONT1
NPHPLJ    JMP     NXTPHPL                ; IF NO FOOD, SKIP TO NEXT PILE

PHCONT1   LDA     FYPOS,Y
          BEQ     NPHPLJ
;;;       JMP     NXTPHPL                ; IF NO PILE HERE IN THE FIRST PLACE

; MAKE SURE THAT THE PILE IS NOT THE BOTTOM HALF OF A TWO-HALF PILE.
;         IF IT IS, SKIP TO THE NEXT PILE; WE JUST FINISHED THE TOP HALF.

PHCONT2   LDA     FINFO,Y                ; BIT 6 HIGH MEANS BOTTOM HAFL
          ASL     A                      ; TO GET BIT 6 INTO BIT 7 POSITION
          BMI     NPHPLJ
;;;       JMP     NXTPHPL                ; IF IT'S SET, SKIP THIS ONE

; NOW WE'VE FINALLY DECIDED THAT THE PILE IS REALLY THERE AND HAS FOOD
;         IN IT.

PHCONT4   LDA     FYCENTER,Y
          SEC
          SBC     TEMP1                  ; CHARACTER Y
          BPL     PHYPOS                 ; POSITIVE Y DIFFERENCE
          EOR     #$FF                   ; ELSE 2'S COMPLEMENT
          CLC
          ADC     #1

PHYPOS    CMP     FDY,Y
          BPL     NPHPLJ

PHXTST    LDA     FCENTER,Y
          SEC
          SBC     TEMP0                  ; CHARACTER X
          BPL     PHXPOS                 ; POSITIVE X DIFFERENCE
          EOR     #$FF
          CLC
          ADC     #1

PHXPOS    CMP     FDX,Y
          BPL     NPHPLJ

; THE CODE WILL REACH HERE IF THE CHARACTER AT INDEX X IS ON TOP OF THE
;         PILE AT INDEX Y.  NOW HE HAS TO PICK UP A FOOD AND DECREMENT
;         THE PILE SIZE.

PICKUP    TXA                            ; IF A CHEF, NO PICKUP ON FIRST LEVEL
          BEQ     PICKUP1                ; IF THE HERO, GO AHEAD

          LDA     HOWHARD                if "beginner" setting, no chef throw
          BEQ     PU003                  ; JMP NXTPHCH

PICKUP0   LDA     PLRACK
          BEQ     PU003                  ; JMP NXTPHCH

PICKUP1   JSR     TAKEFOOD
          BMI     PHBYE                  if result is negative, no foods left

          LDX     TEMPX                  ; GET CHARACTER INDEX BACK
          STA     HELDFOOD,X             ; FOOD INDEX PLACED IN A BY TAKEFOOD

          LDA     #CARRYING
          STA     CSTATE,X

          TXA
          BEQ     PU002                  ; IF CHARLEY
          JSR     FOODADJ                ; PLACES FOOD X,Y PROPERLY
          JMP     PU003

PU002     JSR     CFOODADJ

PU003     JMP     NXTPHCH                ; GO ON TO NEXT CHARACTER

NXTPHPL   LDX     TEMPX
          LDY     TEMPY
          DEY
          CPY     #PILESTRT
          BMI     ZPH03                  ; END OF PILES FOR THIS CHARACTER

ZPH02     STY     TEMPY
          JMP     PHLOOP2                ; DO IT AGAIN FOR THIS FOOD
ZPH03
NXTPHCH   LDX     TEMPX
          DEX
          DEX
          DEX
          BMI     PHBYE
          STX     TEMPX                  ; UPDATE THE TEMP REGISTER AS WELL
          JMP     PHLOOP1                ; DO IT AGAIN FOR THE NEXT CHARACTER

PHBYE     RTS

; THIS ROUTINE ASSUMES THAT THE CHARACTER INDEX IS IN REGISTER X, AND
;         THAT THE FOOD INDEX IS STORED IN "HELDFOOD,X".

FOODADJ   TYA
          PHA
          LDY     HELDFOOD,X             ; GET INDEX OF FOOD CHARACTER
          LDA     CXPOS,X
          STA     CXPOS,Y
          LDA     CYPOS,X
          SEC
          SBC     #4
          STA     CYPOS,Y

; NOW ADJUST X POSITION DEPENDING ON CHARACTER DIRECTION:

          LDA     CDIR,X
          CMP     #4                     ; 4-7 IS LEFT, 0-3 IS RIGHT
          BMI     FARIGHT                ; 0-3
;;;       JMP     FALEFT                 ; 0-3

FALEFT    LDA     CXPOS,Y                ; FOOD'S Y
          CLC
          ADC     #04
          STA     CXPOS,Y
          JMP     FABYE

FARIGHT   LDA     CXPOS,Y                ; FOOD'S Y
          SEC
          SBC     #04
          STA     CXPOS,Y

FABYE     PLA
          TAY                            ; RESTORE Y VALUE

          RTS

; USED ONLY BY HERO

CFOODADJ  TYA
          PHA
          TXA
          PHA

          LDY     HELDFOOD
          LDX     CDIR

; If the food is not being carried, erase it and change the hero's state.

          LDA     CSTATE,Y
          CMP     #CARRIED
          BEQ     FOODISOK

          LDA     #RUNNING
          STA     CSTATE

          LDA     #0
          STA     CYPOS,Y

          BEQ     CADJEXIT               ;JMP


*********

FOODISOK  LDA     CXPOS
          CLC
          ADC     XFOODADJ,X
          STA     CXPOS,Y

          LDA     CYPOS
          CLC
          ADC     YFOODADJ,X
          STA     CYPOS,Y

CADJEXIT
          PLA
          TAX
          PLA
          TAY

          RTS

; THIS ROUTINE IS ALSO CALLED FROM "FOODMOVE" AT THE END OF MOST RACKS.

ATAKE
TAKEFOOD  LDA     FINFO,Y                ; TYPE OF FOOD
          AND     #$3F                   ; MASK OUT DOUBLE PILE BITS
          STA     TEMP2                  ; CONTAINS TYPE OF FOOD

; NOW FIND THE FIRST FREE ENTRY IN THE "CSTRUCT" ARRAY:
;         NOTE: IF "NUMSTUCK" IS NON-ZERO, WE CAN USE A FOOD WITH STATE
;         OF "STICKING".  IF ALL THE FOODS ARE DISPLAYED, LOOK
;         NEXT FOR A FOOD WITH THIS STATE.

          STY     TEMPY                  ; PILE INDEX
          LDY     #FOODSTRT              ; FIRST ENTRY AFTER CHEFS
PHFREE1   LDA     CYPOS,Y
          BEQ     PHFREE2                ; IF 0, THIS ENTRY IS FREE !
          INY                            ;  ELSE TRY NEXT ENTRY...
          CPY     #FOODSTRT+NUMFOOD
          BMI     PHFREE1

          LDA     STATUS                 ; if foods flying through air, let
          CMP     #STATBON               ; them grab stuck ones.
          BEQ     PHFREE12
          CMP     #STATHIT
          BEQ     PHFREE12

          LDA     #$FF                   return negative if no food
          RTS                            ; WAS JMP PHBYE

; IF I GET HERE, THEN THERE MUST BE A FOOD WITH STATE "STICKING".  FIND
;         THE FIRST ONE AND GET IT.

PHFREE12
          LDY     #FOODSTRT
PHFREE11  LDA     CSTATE,Y
          CMP     #STICKING
          BEQ     PHFREE22
          INY
          JMP     PHFREE11               ; MUST BE ONE HERE !

PHFREE22  DEC     NUMSTUCK               ; ONE LESS STUCK FOOD NOW

; NOW Y CONTAINS THE INDEX OF THE FOOD ENTRY, X CONTAINS THE CHARACTER INDEX.

PHFREE2   TXA                            ; SAVE THE CHARACTER INDEX IN
          STA     CREATOR,Y              ;   THE "CREATOR" ARRAY

          STX     TEMPX
          LDX     TEMP2                  ; TYPE OF FOOD
          LDA     FLYCHAR,X
          STA     CSTAMP,Y               ; SET CHARACTER OF FLYING FOOD

          LDA     #BLOCK1
          STA     CHSTAMP,Y

          LDA     FLYPALW,X
          STA     CPALW,Y                ; SET PALETTE/WIDTH OF FOOD

          LDA     TEMP2                  ; TYPE OF FOOD
          STA     CINFO,Y
          STA     CTYPE,Y

          LDA     #CARRIED               ; NEEDED BY FOOD DRIVERS
          STA     CSTATE,Y

          TYA                            ; SAVE FOOD INDEX ON STACK
          PHA                            ;  IN CASE "FOODMOVE" NEEDS IT

; FIND THE PROPER DLIST ENTRY AND
;         MODIFY THE CHARACTER TO DISPLAY ONE LESS FOOD.
;  NOTE: IF THIS IS A WATERMELON PILE, NO MODIFICATION IS NECESSARY.

          LDY     TEMPY                  ; RESTORE FIXED CHARACTER INDEX

          LDA     FINFO,Y                ; TYPE OF PILE
          AND     #$F
          CMP     #4                     ; WATERMELON
          BNE     NOTWAT

          LDA     STATUS
          CMP     #STATHIT
          BEQ     DECWAT
          CMP     #STATBON
          BEQ     DECWAT

          JMP     TFOODBYE

; IF HITTING, DECREMENT "FSTATE" BUT NO NEED TO ALTER THE CHARACTER

DECWAT    LDA     FSTATE,Y
          SEC
          SBC     #1
          STA     FSTATE,Y

          JMP     TFOODBYE               ;  THIS IS IT !

NOTWAT    LDA     FDLPOS,Y
          AND     #$F                   ; LOWER 4 BITS ARE DLIST
          TAX
          LDA     LISTTABL,X
          STA     LISTPTRA
          LDA     LISTTABH,X
          STA     LISTPTRA+1

          LDA     FDLPOS,Y               ; NOW GET POSITION IN DLIST
          AND     #$F0                   ; TOP FOUR BITS
          LSR     A
          LSR     A                      ; DIVIDE BY 8 TO GET INDEX
          TAX

; X NOW CONTAINS THE APPROPRIATE DLIST INDEX; Y CONTAINS THE FIXED CHARACTER
;         INDEX.  (NOTE: "TEMPY" ALSO CONTAINS THE FIXED CHAR INDEX).

; SWITCH THE TWO INDICES SO THAT 1) THE "DEC FSTATE,X" CAN BE USED,
;         2) THE "STA   (LISTPTRA),Y" CAN BE USED.

          TYA
          STX     TEMP3                  ; X GOES TO TEMP3 THEN TO Y
          TAX                            ; Y GOES TO A THEN TO X
          LDY     TEMP3

; NOW REGISTER Y CONTAINS THE DLIST INDEX (JUST AS IN THE ROUTINE "MLOADER"),
;         AND REGISTER X CONTAINS THE FSTRUCT INDEX.
;   NOW FIND OUT WHICH CHARACTER SHOULD BE DISPLAYED HERE.

          DEC     FSTATE,X
          BNE     PHSHRINK               ; SHRINK PILE BY ONE

PHGONE    LDA     #NULLCHAR              ; KEEP THE OLD "PALW" INFO
          STA     (LISTPTRA),Y

; IF THIS IS THE TOP HALF OF A TWO-HALF PILE, THEN REMOVE THE FLAGS
;         WHICH CONNECT THE TWO FSTRUCTS.

          LDA     FINFO,X                ; BIT 7 (NEG BIT) MEANS TOP HALF
          BPL     TFOODBYE

PHLOWER   LDA     #$3F                   ; MASK OUT THE TOP TWO BITS
          AND     FINFO,X
          STA     FINFO,X
          DEX                            ; BOTTOM HALF IS X-1
          LDA     #$3F
          AND     FINFO,X
          STA     FINFO,X

          LDA     FINFO,X
          ASL     A
          ASL     A
          ASL     A
          CLC
          ADC     #3                     must be 4 high
          STX     TEMP4
          LDY     TEMP4
          TAX
          JMP     NOTTOP                 reset the center and delta

PHSHRINK  LDA     FINFO,X                ; TYPE OF FOOD
          ASL     A
          ASL     A
          ASL     A                      ; MULTIPLY BY 8
          CLC
          ADC     FSTATE,X               ; ADD NUMBER OF FOODS
          SEC
          SBC     #1                     ; INDEX IS ONE LESS THAN THIS
          STX     TEMP4
          TAX                            ; USE AS "PILECHAR" INDEX
          LDA     PILECHAR,X             ; LOW BYTE -- FIRST HEADER
          STA     (LISTPTRA),Y
          INY
          LDA     PILEPALW,X             ; SECOND HEADER
          STA     (LISTPTRA),Y            ; THIRD AND FOURTH HEADER UNCHANGED

          STX     TEMP3                  save away the table index
          LDY     TEMP3                  put the table index in y
          LDX     TEMP4                  pile index

;         LDA     FINFO,X
;         BPL     NOTTOP

; If this is the top of a pile, use the maximum width, which will
;         be at the beginning of the table for this pile type
;         (a multiple of 8) plus 3.
;         note: this should only affect the X coordinate !

;         LDA     TEMP3                  the table index for this pile
;         AND     #$FC                   multiple of 8
;         CLC
;         ADC     #3
;         TAY                            contains the table index

NOTTOP    JSR     SETCTR                 in INIT.S

TFOODBYE
          PLA                            ; PLACE FOOD INDEX IN A, FOR FOODMOVE
          RTS

