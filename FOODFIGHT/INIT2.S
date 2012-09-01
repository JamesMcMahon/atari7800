; INIT2.S
; THIS ROUTINE HAS TO PICK BOTH RANDOM X AND RANDOM Y (DLIST).  IT WILL
;         ONLY ALLOW TWO PILES PER DLIST, AND USES "CINFO" AS A COUNTER ARRAY.
;   THIS ROUTINE STARTS INSERTING PILES AT "PILESTRT", AND CONTINUES
;         UNTIL "NUMHOLES" (WHICH HAS BEEN SET TO "PILESTRT+NUMHOLES").
;         IF A BANANA OR TOMATO PILE GREATER THAN 4 IS DISPLAYED,
;         "NUMHOLES" WILL BE INCREMENTED.

PILEDRAW
          MOVE    #PILESTRT,NEXTPILE     ; FOR USE AT END OF RACK

          LDX     PLRACK
          CPX     #5                     ; RACKS ABOVE 5 HAVE 8 PILES
          BPL     ZPP00                  ; IF RACK IS HIGHER, USE MAX. NUMBER

          MOVE    #4,TEMP3               else 4 piles per zone (RACKS 0-4)

          LDA     NUMPTAB,X
          CLC
          ADC     #PILESTRT              ; INDEX FROM BEGINNING OF PILES
          STA     INDEX                  ; ACTUAL NUMBER + #PILESTRT

          LDX     #PILESTRT              ; INDEX TO START WITH
          BPL     ZPP01

ZPP00     LDA     #PILESTRT+NUMPILES
          STA     INDEX
          MOVE    #8,TEMP3               8 piles per zone
          LDX     #PILESTRT              ; INDEX TO START WITH

ZPP01     JSR     RANDOMX                ; RESULT IN A
          STA     FXPOS,X

; DON'T LET A GIVEN ZONE CONTAIN MORE PILE ENTRIES THAN 2.  THE INFORMATION
;         FOR THE NUMBER OF PILES SO FAR IS CONTAINED IN THE ARRAY "CINFO".
;   UPDATE: HIGHER RACKS HAVE SO MANY PILES THAT EACH ZONE MUST BE
;         ALLOWED TO CONTAIN MORE THAN 2 ENTRIES.  MAKE IT 3 IF
;         "NUMPILES" IS >= 9.

ZPP02     JSR     RANDOMY                ; REGISTER A CONTAINS A ZONE NUMBER
          STA     TEMP4                 ; CONTAINS THE HALF-ZONE
          LSR     A                      ; NOW A CONTAINS THE ACTUAL ZONE
          TAY                            ; INDEX INTO DLIST COUNTER (CINFO)
          LDA     CINFO,Y
          CMP     TEMP3                  ; THE NUMBER OF PILES PER ZONE IS
          BPL     ZPP02                  ;  DETERMINED FROM "NUMPTAB"

; NOW SET THE ACTUAL COORDINATE BY MULTIPLYING THE ZONE HALF BY 8 AND ADDING
;         7 TO GET THE TOP OF THE ZONE HALF.

          LDA     TEMP4                  ; ZONE HALF
          ASL     A                      ; TIMES 8
          ASL     A
          ASL     A
          ORA     #$07
          STA     FYPOS,X

; NOW PICK A FOOD TYPE AND A NUMBER OF FOODS FOR THE PILE.
; move this here so that SPACEm can be called twice if necessary.

          LDA     PLBCD                  if one of the top two digits is set,
          BNE     NOTRAND                then it's not the first 4 racks

          LDA     PLBCD+1
          CMP     #4
          BCC     ZPPRAND                ; IF THE FIRST 4 RACKS

NOTRAND
          LDA     PLBCD+1                we don't want PLBCD !
          AND     #$F
          STX     TEMP1                  ; SAVE X FOR THIS TRICK
          TAX
          LDA     RACKTYPE,X
          LDX     TEMP1
          CMP     #$80
          BEQ     ZPPRAND                ; TYPE $80 = RANDOM
          CMP     #$FF
          BNE     ZPP041                 ; TYPE $FF = SOME WATERMELONS
;         BEQ     ZPPSOME

ZPPSOME   CPX     #PILESTRT+2            ; FIRST TWO ARE WATERMELON
          BPL     ZPPRAND

          LDA     #WATTYPE
          BPL     ZPP041                 a jump

ZPPRAND   JSR     RANDOM                 ; "RANDOMLC" DOESN'T WORK WELL HERE
          AND     #03                    ; MASK TO 0-3
ZPP041    ORA     FINFO,X                ; IN CASE BIT 7 WAS SET LAST TIME
          STA     FINFO,X                ; CONTAINS TYPE OF FOOD
          ASL     A
          ASL     A
          ASL     A                      ; MULTIPLY BY 8 FOR FOOD TABLE BASE
          STA     TEMP1

          JSR     RANDOMLC               ; NOW GET A RANDOM NUMBER FOR THE PILE
          AND     #07                    ; MASK TO 0-7
          CMP     #4                     ; IF LESS THAN FOUR, ADD 4
          BCS     ZPMAKE2                ; >=

ZPADD4
          ADC     #4

ZPMAKE2   STA     TEMP2                  ; TOTAL NUMBER OF FOODS IN PILE

; Find out if this pile will be two piles.  If so, call spacem for the top
;         half first; if not, skip around the test for the top half.

          LDA     FINFO,X
          AND     #$F
          CMP     #WATTYPE
          BEQ     ONESTAMP
          CMP     #PEATYPE
          BEQ     ONESTAMP

; Reaching here means there are two stamps (pies, tomatoes, or bananas)

          LDA     FYPOS,X
          CLC
          ADC     #8
          STA     FYPOS,X

          JSR     SPACEM                 the top half test

          BNE     PPSKIP
PP01JMP   JMP     ZPP01                  didn't pass: find a new location

PPSKIP    LDY     TEMPY                  contains the zone index-- must be

          LDA     FYPOS,X                restored before next SPACEM call
          SEC
          SBC     #8
          STA     FYPOS,X

; NOW MAKE SURE THAT THIS PILE ISN'T TOO CLOSE TO ANY OTHER ALREADY
;         INITIALIZED PILES, BY CALLING THE ROUTINE "SPACEM".

ONESTAMP  JSR     SPACEM

          BEQ     PP01JMP                ; IF A==0, HE'S TOO CLOSE
          LDY     TEMPY                  ; ELSE, HE'S OKAY-- CONTINUE

; WE NOW KNOW THAT IT'S OKAY TO PUT THIS PILE HERE.
;         SET UP FDLPOS--

          JSR     ZFDLPOS

; INCREMENT "CINFO" FOR THE NEXT PILE TO TRY THIS ZONE:

          JSR     INCCINFO

; NOW CHECK TO SEE IF THIS PILE ENTRY IS IN TWO DLISTS. IF SO, CINFO
;         MUST BE INCREMENTED FOR THE FOLLOWING ZONE ALSO.  THIS WILL BE
;         THE CASE IF THE ZONE HALF (IN TEMP1) IS EVEN.

          LDA     TEMP4
          LSR     A                      ; GET ODDNESS BIT INTO CARRY
          BCS     ZPP04                  ; AN ODD ZONE HALF-- FITS INTO ONE ZN.

ZPP03     DEY                            ; INDEX FOR NEXT LOWER ZONE
          JSR     INCCINFO
          INY                            ; BACK UP TO THE SAME ZONE

ZPP04     LDA     FINFO,X                ; TYPE OF FOOD
          AND     #$3F                   ; IGNORE TOP TWO BITS
          CMP     #1                     ; 1 MEANS PEAS-- ONLY ONE ZONE HIGH
          BEQ     ZPSKIP00
          CMP     #4                     ; WATERMELON-- ONE STAMP
          BNE     ZPMAKE3
                                         ; IF NOT PEAS OR WATERMELON, MAKE
                                         ;   2 STAMPS HIGH
ZPSKIP00  LDA     TEMP2                  ; ELSE, RESTORE A WITH NUMBER OF FOODS
          JMP     ZP000                  ;  AND SKIP THE "BOTTOM HALF" STUFF

; IF WE GET HERE, WE KNOW THAT IT'S A BANANA OR TOMATO OR PIE PILE BIGGER
;         THAN 4 HIGH.  CREATE THE BOTTOM STAMP OF 4, AND SETUP
;         THE ARRAYS FOR THE UPPER STAMP, INCREMENT X, AND CONTINUE
;         AS BEFORE.
;   SET "FINFO" HIGH BITS AS WELL.

ZPMAKE3   INC     INDEX                  ; END TEST IS ONE GREATER NOW

          LDA     FINFO,X                ; FIRST, COPY FOOD TYPE INTO TOP
          INX                            ;  HALF OF PILE
          STA     FINFO,X
          DEX

          LDA     #$40                   ; BOTTOM HALF
          ORA     FINFO,X
          STA     FINFO,X
          INX                            ; NEXT ONE IS TOP HALF
          LDA     #$80                   ;  TOP HALF FLAG
          ORA     FINFO,X
          STA     FINFO,X                ; PUT IT THERE FOR NEXT LOOP
          DEX

          MOVE    #3,FSTATE,X            ; THIS PILE IS 4 HIGH
          INC     FSTATE,X               ; STATE CONTAINS PILE NUMBER
          CLC
          ADC     TEMP1                  ; BASE INDEX INTO TABLE
          TAY                            ; TABLE INDEX IS 4+ TEMP1
          MOVE    PILECHAR,Y,FSTAMP,X
          MOVE    PILEPALW,Y,FPALW,X

          JSR     SETCTR

          LDA     FXPOS,X
          INX
          STA     FXPOS,X
          DEX

          LDA     FYPOS,X                ; ADD 8 FOR YPOS OF TOP HALF
          INX
          CLC
          ADC     #8
          STA     FYPOS,X                ; THIS IS THE TOP HALF !


; SET UP "FLDPOS" FOR THIS TOP HALF.  IT MUST BE DONE HERE RATHER THAN
;         BELOW, BECAUSE THE BELOW CODE GETS EXECUTED FOR ONE- AND TWO- 
;         ENTRY PILES; AND FDLPOS FOR ONE-ENTRY PILES HAS ALREADY BEEN DONE
;         ABOVE.

          INC     TEMP4                  ; TOP HALF IS NEXT ZONE HALF UP

          LDA     TEMP4                  ; GET IT INTO A SO I CAN SHIFT IT
          LSR     A                      ; ACTUAL ZONE INDEX
          TAY

          JSR     ZFDLPOS                ; SET UP FDLPOS
          JSR     INCCINFO               ; INC FOR NEXT TIME

; NOW, AS WITH THE FIRST HALF, CHECK TO SEE IF THIS HALF HANGS OVER
;         INTO THE NEXT LOWER ZONE.  THIS WILL BE TRUE IF THE "HALF-ZONE"
;         IS EVEN.

          LDA     TEMP4                  ; HALF ZONE
          LSR     A                      ; GET "ODDNESS" BIT IN CARRY
          BCS     ZPP06                  ; CARRY CLEAR IF EVEN

ZPP05
          DEY                            ; INDEX TO NEXT LOWER ZONE
          JSR     INCCINFO
          INY                            ; RESET INDEX TO CURRENT ZONE

ZPP06                                    ; COME HERE IF THERE'S NO OVERHANG
          LDA     TEMP2                  ; THE NUMBER IN THE WHOLE PILE
          SEC
          SBC     #4                     ; TAKE OFF FOUR

ZP000
          STA     FSTATE,X               ; THE STATE IS THE NUMBER OF FOODS
          INC     FSTATE,X               ;  SHOULD BE 1-8, NOT 0-7
          CLC
          ADC     TEMP1                  ; ADD TO FOOD TABLE BASE INDEX
          TAY
          MOVE    PILECHAR,Y,FSTAMP,X    ; INDEX INTO PILECHAR TABLE
          MOVE    PILEPALW,Y,FPALW,X

          LDA     FINFO,X                if this is the top of a two-entry
          BPL     DOCTR                 pile, the delta is the maximum

          TYA                            if bit7 is set, it's a top
          AND     #$FC
          CLC
          ADC     #3                     3 + 8N, N=0,1,2,3
          TAY

DOCTR     JSR     SETCTR

          INX                            ; GO TO NEXT FREE STRUCTURE
          TXA
          CMP     INDEX
          BPL     PILEDBYE               ; IF EQUAL OR GREATER, WE'RE FINISHED
          JMP     ZPP01
PILEDBYE
          RTS

RACKTYPE  DB      $FF,TOMTYPE,$80,PIETYPE,$80
          DB      WATTYPE,BANTYPE,$80,PEATYPE,$80

; Used to set the table values of the new pile.  Called twice here
;         and also called from PILEHIT

AASETCTR
SETCTR
          LDA     FINFO,X
          BPL     THEBOT

          TYA                            if the top of a pile, add 4 to the
          CLC                            index
          ADC     #4
          TAY

THEBOT    LDA     PILECTRY,Y             do the Y first, in case index needs
          CLC                            to be changed for the X
          ADC     FYPOS,X
          STA     FYCENTER,X

          LDA     PILEDY,Y
          STA     FDY,X

          LDA     FINFO,X                whats this ? if it's the top of a
          BPL     NOCHANGE               pile, get rid of top bit, take

          TYA                            the index mod 8, and add 3 to get
          AND     #$FC                   the index for a pile of size 4
          CLC
          ADC     #3
          TAY

NOCHANGE  LDA     PILECTR,Y
          CLC
          ADC     FXPOS,X
          STA     FCENTER,X

          LDA     PILEDX,Y
          STA     FDX,X

          RTS

INCCINFO  LDA     CINFO,Y
          CLC
          ADC     #$01
          STA     CINFO,Y
          RTS

ZFDLPOS   LDA     #2                     ; 2 WALL ENTRIES
          CLC
          ADC     CINFO,Y                ; NUMBER OF PILES + 2
          ASL     A
          ASL     A
          ASL     A
          ASL     A                      ; SHIFT LEFT 4 TIMES (UPPER FIELD)
          STA     TEMP0                  ;  UPPER FIELD (TOP FOUR BITS)

          TYA                            ; ACTUAL ZONE NUMBER IS IN Y
          ORA     TEMP0                  ; MASK IN THE UPPER FIELD (3 BITS)
          STA     FDLPOS,X
          RTS

; "HOLEDRAW" IS ISOMORPHIC TO "PILEDRAW".  ALL HOLES START OUT CLOSED;
;         "CHEFINIT" WILL CHANGE SOME HOLES TO OPEN.

HOLEDRAW
          LDA     TEMP3                  each zone has 3 more spaces for
          CLC                            holes
          ADC     #3
          STA     TEMP3

          LDA     PLRACK
          CMP     #8                     ; RACKS ABOVE 7 HAVE 10 HOLES
          BPL     ZHH00

          TAX
          LDA     NUMHTAB,X              ; NUMBER OF HOLES FOR RACK
          JMP     ZHH01

ZHH00     LDA     #NUMHOLES               ; MAXIMUM NUMBER OF HOLES

ZHH01     STA     HOLENUM                ; USED IN "CHEFMOVE" WHEN RISING
          CLC
          ADC     #HOLESTRT
          STA     INDEX                  ; USED FOR END OF ROUTINE TEST
          LDX     #HOLESTRT              ; START WITH FIRST PILE

ZNEWHOLE  JSR     RANDOMX                ; RESULT IN A
          CMP     #120                   ; DON'T LET HOLE GET TOO CLOSE TO HERO
          BCS     ZHSUB40
          JMP     ZHSUB00
ZHSUB40   SEC
          SBC     #40                    ; SUBTRACT 40 FROM X COORDINATE
ZHSUB00   STA     FXPOS,X

ZHH02     JSR     RANDOMY                ; RANDOM DLIST
          LSR     A                      ; GET ACTUAL ZONE
          TAY                            ;  INTO INDEX REGISTER Y
          LDA     CINFO,Y                ; CHECK COUNTER (FROM "PILEDRAW")
          CMP     TEMP3                  ;  VARIES DEPENDING ON TOTAL PILES
          BPL     ZHH02                  ; IF TWO THINGS ARE THERE, TRY ANOTHER

          TYA                            ; BRING DLIST NUMBER BACK INTO A
          ASL     A                      ; MULTIPLY BY 16 TO GET THE COORD.
          ASL     A
          ASL     A
          ASL     A
          CLC
          ADC     #15                     ; ADJUST AT THE TOP OF THE DLIST
          STA     FYPOS,X

; NOW MAKE SURE HE'S NOT TOO CLOSE TO ANY OTHER PILE OR HOLE.

          JSR     SPACEM

          BEQ     ZNEWHOLE               ; IF A==0, HE'S TOO CLOSE

; IF WE GET HERE, THIS LOCATION IS OK-- SET "FDLPOS" AND INCREMENT "CINFO"

          LDY     TEMPY                  ; SAVED IN "SPACEM"

          JSR     ZFDLPOS

; INCREMENT "CINFO"

          JSR     INCCINFO

          MOVE    #SHUTCHAR,FSTAMP,X     ; ALL SHUT FOR NOW
          MOVE    #HOLEPALW,FPALW,X
          MOVE    #CLOSED,FSTATE,X       ; HOLE STATE

          INX
          CPX     INDEX                  ; LAST CHEF TO BE INITIALIZED
          BMI     ZNEWHOLE

; CLEAR OUT "CINFO" SO THAT IT'S ZEROED WHEN RACK STARTS

          LDX     #TOTALCH-1
          LDA     #0
ZHH03     STA     CINFO,X
          DEX
          BPL     ZHH03

          RTS

; "CHEFINIT"
; THIS ROUTINE WILL CAUSE THE CHEFS TO RISE FROM MANHOLES AND APPEAR
;         ON THE PLAYFIELD.  FOR NOW, IT JUST POPS THEM UP RIGHT ON TOP
;         OF THE HOLE.

CHEFINIT
          LDX     HOWHARD
          LDA     PLRACK
          CMP     ZRACK,X
          BPL     ZEROTHRW               zero throw time

          MOVE    LOWTIME,X,TEMP0        otherwise, read throw time from table
          MOVE    HITIME,X,TEMP1
          LDY     PLRACK
          LDA     (TEMP0),Y
          JMP     SETTHTF

ZEROTHRW  LDA     #10
SETTHTF   STA     THRWTUFF

          LDA     PLRACK
          CMP     #23
          BPL     MAXTUFF
          LSR     A
          TAX

          LDA     MTUFFTAB,X             ; DIRECTION CHANGE TIMER
          JMP     SETTUFF

MAXTUFF   LDA     #3
SETTUFF   STA     MOODTUFF

TUFFOVER  LDY     #HOLESTRT              ; MANHOLE INDEX

          MOVE    #$1F,COLORS+6          ; CHANGE THE WHITE TO YELLOW
          MOVE    #0,NUMCHHIT            ; NO CHEFS HIT YET

          LDA     PLRACK
          BEQ     CHEF02                 ; FIRST RACK HAS 2 CHEFS
          CMP     #1
          BEQ     CHEF03                 ; SECOND HAS THREE

          LDA     #3                     ; ALL FOUR CHEFS
          BNE     ZCHINIT0               ; A JUMP

CHEF02    MOVE    #NOTYET,CSTATE+9
          STA     CSTATE+12
          LDA     #1                     ; 2 CHEFS
          BNE     ZCHINIT0               ; A JUMP

CHEF03    MOVE    #NOTYET,CSTATE+12      ; LAST CHEF ISN'T PROCESSED
          LDA     #2                     ; 3 CHEFS

ZCHINIT0  STA     INDEX                  ; TELLS HOW MANY CHEFS THIS LEVEL

; UP TILL NOW, I'VE BEEN SETTING PARAMETERS WHICH APPLY TO ALL THE CHEFS.
;         THE FOLLOWING LOOP SETS PARAMETERS FOR EACH INDIVIDUAL CHEF

          LDX     #CHEFSTRT              ; INITIALIZE FOR THE FOLLOWING LOOP

ZCHINIT1  JSR     CHEFDRAW               ; INITIALIZE THE RISING SEQUENCE

; SET UP CHARACTER INFO:

; TEMPORARY-- REMOVE FOR FINAL VERSION ?
          MOVE    #$10,CINFO,X

          MOVE    CHEFPALW-3,X,CPALW,X
          MOVE    CHEFCHAR-3,X,CSTAMP,X

          MOVE    CHEFPALW-2,X,CPALW+1,X
          MOVE    CHEFCHAR-2,X,CSTAMP+1,X

          MOVE    CHEFPALW-1,X,CPALW+2,X
          MOVE    CHEFCHAR-1,X,CSTAMP+2,X

          INX                            ; GO TO NEXT CHEF
          INX
          INX

          INY                            ; POINT TO NEXT HOLE

          DEC     INDEX
          BPL     ZCHINIT1               ; CONTINUE FOR THIS MANY CHEFS

; WHEN ALL CHEFS HAVE STARTED RISING, SET THE NUMBER OF "FALLEN" CHEFS
;         TO ENSURE THAT THERE'S ALWAYS AT LEAST ONE ON THE SCREEN

          LDA     PLRACK
          BEQ     CHEF012
          CMP     #1
          BEQ     CHEF013

          LDA     #0
          JMP     CHINBYE

CHEF012   LDA     #2                     ; PRETEND THAT TWO HAVE FALLEN
          JMP     CHINBYE

CHEF013   LDA     #1                     ; PRETEND; SO THAT AT LEAST ONE CHEF

CHINBYE   STA     NUMFALL                ;   WILL STILL BE ON SCREEN

          RTS

; THIS ROUTINE DRAWS A SINGLE CHEF.  IT IS ALSO CALLED FROM "CHEFMOVE"
;          WHEN A DEAD CHEF SHOULD RE-GROW FROM A HOLE.

CHEFDRAW  LDA     STATUS
          CMP     #STATWON
          BNE     CDRW00
          RTS                            ; JMP CDRWBYE
                                         ; DON'T LET THEM RISE IF RACK IS OVER

CDRW00    LDA     RISESND-3,X
          JSR     TUNIN

          MOVE    THRWTUFF,THRWTIME,X

          MOVE    #HATRISE,CSTATE,X      ; HAT RISES FIRST
          MOVE    RISEPALW-3,X,CPALW,X
          MOVE    RISEPALW-2,X,CPALW+1,X
          MOVE    RISEPALW-1,X,CPALW+2,X

          DEC     NUMFALL                ; ONE LESS CHEF IS DEAD

          LDA     FYPOS,Y                ; HOLE Y
          SEC
          SBC     #14                    ; BOTTOM LINE OF ZONE
          STA     CYPOS,X                ; HAT Y

          LDA     FXPOS,Y                ; HOLE X
          CLC
          ADC     #2
          STA     CXPOS,X                ; HAT X

          MOVE    #0,CFRAME,X            ; STOPS WHEN "HATHITE" IS REACHED
          MOVE    #RZSPEED,CACOUNT,X
          MOVE    #$FF,CSECOND,X         ; BOTTOM HALF INVISO

          STY     TEMPY

          LDA     PLRACK
          CMP     #31
          BMI     CDRW011                ; USE TABLES

          LDY     #15                    the chspeed tables are 16 long-          JMP     CDRW012                8 for 1-16, and 8 for 9-32

CDRW011   STX     TEMPX

          JSR     MAXSET                 use different tables for
          DEX                            each value of MAXSET
          TXA
          ASL     A
          ASL     A
          ASL     A
          STA     TEMP0

          LDA     PLRACK
          AND     #$F
          LSR     A                      ; 0-7
          ORA     TEMP0
          TAY

          LDX     TEMPX

CDRW012   LDA     CHSPEED,Y              ; USED THROUGHOUT THE RACK

          LDY     HOWHARD
          CPY     #2
          BMI     CDRW013

          SEC                            make chefs faster on top two
          SBC     #1                     difficulty settings
CDRW013   STA     CSINDEX,X

          TAY

          MOVE    MTABSPD,Y,CSPEED,X

          LDY     TEMPY

; NOW, SAVE INFORMATION ABOUT THE HOLE HE'S GROWING FROM.
;         THE "CREATOR" TIMER WON'T START DECREMENTING UNTIL THE RISE
;         IS COMPLETED.

          MOVE    #$20,CREATOR,X         ; 3 SECOND TIMER
                                         ; DON'T LET HIM DIE FOR THIS TIME

          TYA                            ; SO HE'LL KNOW WHICH HOLE THIS IS
          STA     HOLEUSED,X

; NOW CHANGE THE MANHOLE TO BE OPEN FOR THE RISING SEQUENCE:

          MOVE    #OPENCHAR,FSTAMP,Y
          MOVE    #OPEN,FSTATE,Y

CDRWBYE   RTS

; THE REMAINING ROUTINES ARE "RANDOM" ROUTINES WHICH RETURN A VALUE
;         IN REGISTER A.

; THIS ROUTINE RETURNS A ZONE.  TO GET A FIXED CHARACTER'S Y COORD. AT THE
;         TOP OF THIS ZONE, MULTIPLY THE ZONE BY 8, THEN ADD #7; THE VALUE
;         WILL BE EQUAL TO "TOPZONE,ZONE#"

RANDOMY
          JSR     RANDOMLC

          AND     #1F                    ; BOTTOM FIVE BITS -- 31 OR LESS
          CMP     #18                    ; I NEED A NUMBER 2 - 18
          BPL     ZRAND00                ;  IF IT'S GREATER, SUBTRACT 13
          JMP     ZRAND01
ZRAND00   SEC
          SBC     #13
ZRAND01   CMP     #2
          BPL     ZRAND08                ; IF IT'S >= 2, IT'S OKAY
          LDA     #2                     ;  IF IT'S LESS THAN 2, MAKE IT 2
ZRAND08                                  ; AT THIS POINT, "A" CONTAINS 2-18
          RTS

RANDOMX
          STX     TEMPX                  ; SAVE REGISTER

          JSR     RANDOMLC

          AND     #$7F                   ; 0 - 128
          CLC
          ADC     #$0A                   ; 10 - 138

          LDX     TEMPX                   ; RESTORE REGISTER
          RTS

; THIS ROUTINE IS USED DURING INITIALIZATION TO RETURN "LINEAR CONGRUENTIAL"
;         RANDOM NUMBERS.  IT CONTAINS A MULTIPLY !
; THIS COMPUTES: RANDOM0 := (RANDOM0 * RANDOMA) + RANDOMC {MODULO 256}

RANDOMLC  LDA     RANDOM0
          STA     RTEMP0
          LDA     #0
          STA     RANDOM0                ; ALL FACTORS OF POWERS OF 2 WILL
                                         ; BE ADDED TO THIS
          LDA     #RANDOMA

RANDLOOP  LSR     A
          STA     RTEMP1

          BCC     RAND000                ; IF ZERO, JUST SKIP THIS BIT

          LDA     RANDOM0
          CLC
          ADC     RTEMP0                 ; THIS IS THE PROPER MULTIPLE OF
          STA     RANDOM0                ;  "RANDOM0" FOR THIS BIT

RAND000
          ASL     RTEMP0
          LDA     RTEMP1
          BNE     RANDLOOP

          LDA     RANDOM0                ; IF THE "MULTIPLIER"==0, EXIT
          CLC
          ADC     #RANDOMC
          STA     RANDOM0

          RTS

; THIS ROUTINE IS USED DURING GAMEPLAY.  IT RETURNS
;         A RANDOM NUMBER BETWEEN 0 AND 255 IN REGISTER A
ARANDOM
RANDOM    STY     RTEMPY                  ; SAVE Y VALUE
RNDCONT   LDA     #$07
          CLC
          ADC     RANDOM0
          ADC     RANDOM1
          LDY     RANDOM0
          STY     RANDOM1
          STA     RANDOM0
          LDY     RTEMPY                  ; RESTORE REGISTER

          RTS

; THIS ROUTINE IS CALLED FROM "PILEDRAW" AND "HOLEDRAW" TO MAKE
;         SURE THAT THE PILE OR HOLE IS NOT TOO CLOSE TO ANOTHER
;         PILE OR HOLE.
; ADDED 11/15/83: THE BYTES AT FYPOS-1 AND FXPOS-1 ARE CHUCK'S LOCATION.
;         THE LOOP IS CHANGED TO TEST CLOSENESS TO CHUCK AS WELL.
;         NOTE THAT Y INDICES MUST BE TESTED UP TO X+1, SINCE Y STARTS
;         ONE LOCATION LOWER IN THE POSITION TABLES.

ASPACEM
SPACEM    STX     TEMPX                  ; STOP AT CURRENT INDEX
          INC     TEMPX                  ; TO REFLECT Y INDEXING ONE LESS
          STY     TEMPY
          LDY     #0                     ; START WITH CHUCK'S COORDS.

          MOVE    #DXHCLOSE,TEMP0        for piles vs. hero
          MOVE    #DYHCLOSE,TEMP5

SPEMLOOP  CPY     TEMPX                  ; TEST FIRST, IN CASE IT'S THE FIRST
          BMI     ZSPCONT1               ;  PILE INITIALIZED

          LDA     #TRUE                  ; IF THIS IS THE LAST, RETURN TRUE
          RTS                            ; JMP SPACEBYE

ZSPCONT1  LDA     FYPOS-1,Y                ; OBJECT TO TEST
          BEQ     ZSPNEXT

          SEC
          SBC     FYPOS,X                ; CURRENT OBJECT
          BPL     ZSP001
          EOR     #$FF
          CLC
          ADC     #1
ZSP001    CMP     TEMP5
;         BCC     ZSPXTST
          BCS     ZSPNEXT

ZSPXTST   LDA     FXPOS-1,Y                ; OBJECT BEING TESTED
          SEC
          SBC     FXPOS,X                ; CURRENT OBJECT
          BPL     ZSP003
          EOR     #$FF
          CLC
          ADC     #1
ZSP003    CMP     TEMP0
          BCC     ZRTNF                  ; RETURN FALSE

ZSPNEXT   MOVE    #DXCLOSE,TEMP0         for piles vs. piles
          MOVE    #DYCLOSE,TEMP5

          INY                            ; NEXT OBJECT
          JMP     SPEMLOOP               ; CONTINUE UNTIL JUST BEFORE CURRENT

ZRTNF     LDA     #FALSE                 ; RETURN FALSE-- MUST PICK NEW COORD.
SPACEBYE  RTS

; Copy from a block of memory to another
; This routine is called from the macro COPY

ZZZZCOPY  LDA     (TEMP0),Y
          STA     (TEMP2),Y
          DEY
          BNE     ZZZZCOPY
          DEC     TEMP1
          DEC     TEMP3
          DEX
          BNE     ZZZZCOPY
          RTS

