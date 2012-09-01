; INIT1.S
; THIS FILE CONTAINS THE ROUTINES WHICH ARE CALLED AT THE BEGINNING
;         OF EACH NEW RACK.  THE SCREEN IS CLEARED, THEN ALL OBJECTS
;         ARE REDRAWN-- CONE, HERO, PILES, HOLES, AND CHEFS (APPEARING
;         FROM MANHOLES).

; THIS FIRST ROUTINE, "RACKINIT", IS CALLED FROM "MAIN.S" WHEN IT'S
;         DISCOVERED THAT A NEW RACK IS HAPPENING.

          GLBL    DIEWAIT
          GLBL    CLRSCRN

          GLBL    RISEPALW               ; USED IN "HOLEHIT.A"
          GLBL    RANDOM
          GLBL    GOD
          GLBL    MKENTER
          GLBL    MKSELECT
          GLBL    SETMAPS
          GLBL    HSCRTN                 used also in LOGO.S

RANDOMA   EQU     45                     ; 45 MOD 8 = 5; A>16
RANDOMC   EQU     51                     ; C ODD, C/M= ABOUT .21

CONERAND  EQU     7

DXHCLOSE  EQU     18                     just more than one pile across
DYHCLOSE  EQU     26                     just more than 3 pile halves

*  BODIES OF THE DMAON AND DMAOFF MACROS

XDMAOFF   ONSCREEN
          OFFSCRN
          MOVE    #CTRLOFF,CTRL          defined in MACRODEF
          RTS

XDMAON    ONSCREEN
          OFFSCRN
          MOVE    #L(DLLRAM),DPPL
          MOVE    #H(DLLRAM),DPPH
          MOVE    #M160X2,CTRL
          RTS


RACKINIT
          JSR     SCRAPALL               ; MAKE SURE

          MOVE    #0,ALLGONE             ; 0  EQU FALSE
                                         ; USED BY ALL FOOD FLYING AT RACK END
          LDA     CSTATE                 ; HERO'S STATE
          CMP     #WON                   ; SEE IF HE JUST REACHED THE CONE
          BEQ     RCONT00A
          JMP     HERODIE                ; IF NOT, HE MUST HAVE DIED
RCONT00A

          LDX     CURRENT                do this once for winning, once for
          MOVE    #FALSE,PL0FIRST,X      death

; SEE IF THIS IS THE FIRST ATTRACT MODE RACK:
;         IF IT IS, THEN ONLY DO IR IF THERE'S ALREADY BEEN A GAME PLAYED.
;         ELSE, JUST INITIALIZE AS FOR A FIRST RACK, AND USE RANDOM MOVEMENTS.,

          LDA     MODE
          CMP     #MATTRACT
          BNE     RICONT00

          LDA     GAMECNT                ; IF NON-ZERO, IT'S A REPLAY
          BEQ     RICONT00

          LDA     #TRUE
          JMP     SETRPLY

; HERE I SHOULD TEST TO SEE IF IT'S WORTHY OF INSTANT REPLAY

RICONT00
          LDA     DOITOVER               ; IF LAST WAS A REPLAY
          BNE     NOREPLAY

          LDA     FSTATE                 must be at least 12 seconds long
          CMP     #5                     (2 values of FSTATE)*(6 seconds)
          BPL     NOREPLAY

          LDX     CURRENT
          DEC     PL0IRTIM,X             ; ONE EVERY FIVE RACKS
          BPL     NOREPLAY

          MOVE    #$FF,PL0IRTIM,X        ; DON'T LET IT GET TOO NEGATIVER

          LDA     IRCHTIME               if near chefs for this much time,
          CMP     #DOIRLOW               it's a replay
          BCC     NOREPLAY               if less, no replay

RICONT01  LDA     PLRACK                 ; MUST BE AT LEAST LEVEL 5
          CMP     #4                     ; 0,1,2,3 CAN'T HAVE REPLAY
          BMI     NOREPLAY

          CMP     #17
          BCC     YESRPLY                ; IF BELOW RACK 17 THEN OK
          LDA     PLBCD+1
          AND     #$05
          BEQ     NOREPLAY               ; IF RACK ENDS IN '0' THEN NOREPLAY
          CMP     #$05
          BEQ     NOREPLAY               ; IF RACK ENDS IN '5' THEN NOREPLAY

; At this point, we know it's a replay !  Copy the relevant information
;         into tables and values for the attract mode replay, and
;         setup current gameplay seeds from the saved IR values.

YESRPLY   MOVE    #4,PL0IRTIM,X          ; DON'T GIVER ANOTHER FOR 5 RACKS
          MOVE    #$FF,ASET              ; USE THIS FOR LATER ATTRACT MODES

          JSR     SAVEAIR

          LDA     #TRUE                  ; THIS IS IT.
          JMP     SETRPLY

; Go ahead and copy the tables for IR into AIR, and use this even though
;         it's not an instant replay, until a real IR comes along.
;         If ASET is negative, the AIR tables already contain an IR.
;         Don't copy--

NOREPLAY  LDA     MODE                   don't copy if this is already an
          CMP     #MATTRACT              attract mode
          BEQ     SKIPCOPY

          LDA     ASET
          BMI     SKIPCOPY

          JSR     SAVEAIR

          LDA     #2
          STA     ASET

          LDX     CURRENT                X is used by "SAVEAIR" routine

SKIPCOPY  LDA     PLRACK
          CMP     #124
          BCS     NOINC                  if greater than 124, no increment

          INC     PL0RACK,X              ; PLAYER 0 OR 1
NOINC

; ADD ONE TO THE BCD REPRESENTATION OF THE LEVEL:
;         Increment PLBCD regardless, since all level display is based on
;         the last digit of this:

          TXA
          ASL     A                      ; 0 OR 2
          TAX
          INX                            ; LOW BYTE (LOW ORDER DIGITS)
                                         ;   1 OR 3
          SED
          LDA     PL0BCD,X
          CLC
          ADC     #1
          STA     PL0BCD,X
          DEX                            ; HIGH ORDER DIGITS
          LDA     PL0BCD,X
          ADC     #0
          STA     PL0BCD,X
          CLD

LASTRACK  LDA     #FALSE
SETRPLY   STA     DOITOVER

          JMP     CHARINIT

HERODIE   MOVE    #FALSE,DOITOVER        ; NO IR THIS TIME !

          LDX     CURRENT
          STA     PL0FIRST,X

          LDA     ASET                   If there's no winning rack in the AIR
          BNE     SKIPIT                 tables, then store this one
          JSR     SAVEAIR

          INC     ASET                   set to 1

SKIPIT
          MOVE    #0,PL0CARRY,X          ; GET RID OF ANY CARRIED FOOD
          MOVE    #TRUE,PLMESS           ; SET MESSAGE FOR NEXT PLAYER TO DISP.

          DEC     PL0LIVES,X             ; TAKE AWAY A LIFE
          BEQ     HDIEOVER               ;  IF NO LIVES ARE LEFT

          LDX     OTHER
          LDA     PL0LIVES,X
          BEQ     HERODIE0               ; OTHER PLAYER HAS NO LIVES-                                         ;    DON'T CHANGE "CURRENT"

          MOVE    CURRENT,OTHER          ; SWITCH PLAYERS-- OTHER IN X
          STX     CURRENT

HERODIE0  JMP     CHARINIT

; This routine saves all relevant information for the attract mode IR.

SAVEAIR   COPY    IRDIRA,AIRDIRA,$140   do all five tables in this loop

          MOVE    IRCCNT,AIRCCNT         cyclecnt
          MOVE    IRAND0,AIRAND0         random0
          MOVE    IRAND1,AIRAND1         random1
          MOVE    IRCARRY,AIRCARRY       information about carried food
          MOVE    PLRACK,AIRLEVEL        level the replay occurred on
          MOVE    PLBCD+1,AIRBCD           to get pile type correct

          RTS

; ALL THE LIVES FOR THIS PLAYER ARE GONE.  CHECK THE OTHER PLAYER-;         AFTER PLAYING THE "END OF GAME" TUNE

HDIEOVER  JSR     SCRAPALL               ; GET RID OF ANY SOUNDS

          LDA     #12
          JSR     TUNIN
          LDA     #13
          JSR     TUNIN

; CALL "MKPROMPT" WHICH WILL ACCOMPLISH THE WAIT WHILE DISPLAYING
;         THE "GAME OVER" MESSAGE
;   NOTE: FIRST OF ALL, GET RID OF ALL THE FOODS, SO THERE WILL BE ENOUGH
;         DMA TIME FOR THE TEXT

          LDA     #0
          LDY     #FOODSTRT+NUMFOOD
NUFFDMA   STA     CYPOS,Y
          DEY
          CPY     #FOODSTRT
          BPL     NUFFDMA

          JSR     MLOADER                ; CLEAN OUT THE DLISTS WITH THE FOODS

          LDA     #1
          JSR     MKPROMPT

          LDA     PLAYNUM                ; "TRUE" IF TWO PLAYER
          BEQ     ZEND0                  ; ELSE, GAME IS OVER

          LDX     OTHER                  ; OTHER PLAYER
          LDA     PL0LIVES,X
          BEQ     ZEND0                  ; NEITHER PLAYER HAS ANY LIVES

          MOVE    OTHER,TEMP0            ; SWITCH PLAYERS
          MOVE    CURRENT,OTHER          ; IF ONLY ONE PLAYER, OTHER==CURRENT
          MOVE    TEMP0,CURRENT

          MOVE    #MGAME,MODE

          NEWSTATE  GAME

          JMP     CHARINIT

; BOTH PLAYERS ARE DEAD-- PASS CONTROL TO HISCORE ENTRY, THEN BACK TO LOGO

ZEND0     JSR     MKENTER                ; WILL GET LAST PLAYER TO GO

          DMAOFF

          LDA     PLAYNUM
          BEQ     ZEND00                 ; WAS ONE-PLAYER

          MOVE    OTHER,CURRENT          ; NOW THE OTHER PLAYER

          JSR     MKENTER

ZEND00    JSR     HSCRTN                 clean-up after HSC is done

          MOVE    #FALSE,RUNLOAD
          MOVE    #0,CURRENT             ; SO THAT JOYSTICK AND BUTTON ARE
                                         ;    PLAYER 0
          JMP     MKLOGO

CHARINIT
;         DMAOFF

          MOVE    #STATINIT,STATUS
          MOVE    #1,MAXCYCLE            ; JUST FOR CHEFS RISING
          MOVE    #0,NUMCYCLE

          JSR     CLRSCRN

; WAIT TILL WE'RE ON SCREEN:

RINITLP   BIT     MSTAT
          BPL     RINITLP

; AT THIS POINT, WE'RE ON SCREEN; NOW WAIT FOR VBLANK TO BE REACHED AGAIN
;         SO THAT SETTING OF SEEDS OCCURS BEFORE NEXT SCREEN

RINITLP1  BIT     MSTAT
          BMI     RINITLP1

; VBLANK WAS JUST ENTERED; HANDLE SETTING OF "CYCLECNT", "RANDOM0", AND
;         "RANDOM1" BEFORE THE NEXT DLI OCCURES

; "DOITOVER" WILL BE SET "TRUE" IF IT'S SUPPOSED TO BE A REPLAY

          LDA     DOITOVER
          BEQ     ZIR0003                ; NO IR

          LDA     CSTATE
          CMP     #WON                   ; IF HE JUST DIED, THEN NO IR
          BNE     ZIR0003

; THIS IS AN INSTANT REPLAY !

          LDA     ASET
          BEQ     NORMAL

          LDA     MODE
          CMP     #MATTRACT
          BNE     NORMAL

          MOVE    AIRCCNT,CYCLECNT       this is an attract replay-- use
          MOVE    AIRAND0,RANDOM0        the attract IR values
          MOVE    AIRAND1,RANDOM1

          LDX     CURRENT
          MOVE    AIRCARRY,PL0CARRY,X
          MOVE    AIRLEVEL,PL0RACK,X     ; SAME RACK AS REPLAY ORIGINALLY WAS

          TXA                            get 0 or 2 into X
          ASL     A
          TAX

          MOVE    AIRBCD,PL0BCD+1,X
          JMP     ZIR0004                 go ahead past stuff

NORMAL    MOVE    IRCCNT,CYCLECNT        ; RESTORE CORRECT RANDOM GENERATOR
          MOVE    IRAND0,RANDOM0
          MOVE    IRAND1,RANDOM1

          LDX     CURRENT
          MOVE    IRCARRY,PL0CARRY,X

          LDA     MODE                   ; NO IR MESSAGE IF IT'S JUST AN
          CMP     #MATTRACT              ;   INSTANT REPLAY--
          BEQ     ZIR0004

          JSR     COLRINIT               ; WASTES TIME BUT SAVES ROM
                                         ; RESTORE 19,15,1F INTO P5

          LDA     #2                     ; IR MESSAGE
          JSR     MKPROMPT               ; WHILE PLAYFIELD IS BLANK

          JMP     ZIR0004

; THIS RACK ISN'T AN INSTANT REPLAY-

ZIR0003   MOVE    CYCLECNT,IRCCNT
          MOVE    RANDOM0,IRAND0
          MOVE    RANDOM1,IRAND1

          LDX     CURRENT
          MOVE    PL0CARRY,X,IRCARRY

; ZERO OUT JUST THE THROW TABLE-- THE DIRECTION TABLE WILL BE WRITTEN
;         OVER EACH TIME I STORE A HIGH NIBBLE, BUT THE THROW TABLE
;         IS ALWAYS WRITTEN TO USING "ORA" STATEMENTS.

          LDY     #$3F                   ; TABLE IS $40
          LDA     #0
ZIR0100   STA     IRTHROW,Y
          DEY
          BPL     ZIR0100

ZIR0004   LDA     #0
          STA     CYCLEIDX
          STA     CYCLEIDX+1
          STA     THROWIDX

; FIND OUT WHICH PLAYER THIS IS IF TWO PLAYER-- SET PLRACK APPROPRIATELY

APINOVER
          LDX     CURRENT                gets used at PINOVER
          BEQ     P1INIT

          MOVE    PL1RACK,PLRACK         ; SECOND PLAYER
          MOVE    PL1CARRY,PLCARRY
          MOVE    PL1LIVES,PLLIVES
          MOVE    PL1BCD,PLBCD
          MOVE    PL1BCD+1,PLBCD+1
          MOVE    PL1FIRST,PLFIRST

          JMP     PINOVER

P1INIT    MOVE    PL0RACK,PLRACK         ; FIRST PLAYER
          MOVE    PL0CARRY,PLCARRY
          MOVE    PL0LIVES,PLLIVES
          MOVE    PL0BCD,PLBCD
          MOVE    PL0BCD+1,PLBCD+1
          MOVE    PL0FIRST,PLFIRST

PINOVER   LDA     PLRACK                update highest selected level allowed
          CMP     HIGHEST,X              select up to last highest always
          BCC     NONEWHI                allowed

          CMP     #125                   also, don't let HIGHEST become
          BCS     NONEWHI                greater than 125
          STA     HIGHEST,X

          LDA     PLAYNUM                if one player, copy into 2nd player
          BEQ     COPYTWO

          LDA     PL1FIRST               If this is the first rack for
          BNE     NONEWHI                player 2, don't copy over

; Use the greatest HIGHEST value for both of the HIGHEST registers

COPYTWO   LDA     HIGHEST
          CMP     HIGHEST+1
          BCS     USETHIS

          MOVE    HIGHEST+1,HIGHEST
          BNE     NONEWHI                a jump

USETHIS   STA     HIGHEST+1

NONEWHI

; JUMP TO THE RACK SELECT MODE IF THIS IS THE FIRST RACK FOR THIS PLAYER:

          LDA     PLFIRST
          BEQ     RACKSTRT               not the first rack

          LDA     MODE                   ; NO SELECT IF ATTRACT MODE
          CMP     #MATTRACT
          BEQ     RACKSTRT

          JSR     MKSELECT               ; WON'T "RTS" UNTIL "THROW" IS PUSHED

;         DMAOFF                         turn DMA off while characters init.

          JSR     COLRINIT               ; SINCE "SELECT" HAS A LOGO

          JSR     SETMAPS                ; IN "MAIN.S"-- SETS MAPS FOR GAMEPLAY
                                         ;  INCLUDING SCORES AND HEADS ETC.
RACKSTRT  JSR     CLRSTRCT              ; CLEAR ALL THE STRUCTURE ARRAYS
                                         ; ALSO CLEARS "STATLIST"

; NOW SET UP THE STAT LIST FOR THIS PLAYER-- RACK NUMBER, AND LIVES LEFT

          JSR     STATDISP

; NOW SETUP THE "LEVEL NNN" LIST ; UP TO THREE DIGITS

LIFELP0   MOVE    #FALSE,TEMP0           ; USE THIS TO TELL IF ZEROES ARE
                                         ;   DISPLAYED

          LDA     PLRACK                 if this is level 125 or up, display
          CMP     #124                   the number "125" despite value in
          BMI     NOTLAST                PLBCD

          MOVE    #$D8,CLOWMAP2+12       "1"
          MOVE    #$D9,CLOWMAP2+13
          MOVE    #$DA,CLOWMAP2+14       "2"
          MOVE    #$DB,CLOWMAP2+15
          MOVE    #$E0,CLOWMAP2+16       "5"
          MOVE    #$E1,CLOWMAP2+17
          BNE     STATOVER               a jump

NOTLAST   LDA     PLBCD                  ; LIVES IN BCD
          BEQ     LIFELP1                ; IF ZERO, NO DIGIT
          ASL     A                      ; TIMES 2
          ADC     #$D6                   ; DIGIT "1" IS AT $D8
          STA     CLOWMAP2+12
          ADC     #1
          STA     CLOWMAP2+13
          MOVE    #TRUE,TEMP0

LIFELP1   LDA     PLBCD+1
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          LDX     TEMP0
          BNE     LIFELP2                ; IF "TRUE", DISPLAY IT
          TAY                            ;  TO RESET FLAGS TO "A"
          BEQ     LIFELP3                ; IF ZERO, SKIP THIS ONE

LIFELP2   ASL     A                      ; TIMES 2
          ADC     #$D6                   ; THE "O" CHARACTER
          STA     CLOWMAP2+14
          ADC     #1
          STA     CLOWMAP2+15

LIFELP3   LDA     PLBCD+1
          AND     #$F
          ASL     A                      ; TIMES 2
          ADC     #$D6
          STA     CLOWMAP2+16
          ADC     #1
          STA     CLOWMAP2+17

STATOVER
;         DMAOFF                         now done above at CHARINIT

          JSR     CLRSCRN                ; CLEAR DISPLAY LISTS
          JSR     CONEDRAW
          JSR     HERODRAW               dma gets turned on in here
AAASTOP
          JSR     PILEDRAW
          JSR     HOLEDRAW
          JSR     CHEFINIT

; wait till offscreen, because the two of these together will take forever

          ONSCREEN
          INVBLANK

ATIME1
          JSR     FLOADER                ; DISPLAY ALL THE FIXED CHARS; SET
ATIME15                                  ; UP "LISTSTRT" TO REFLECT THEM
          JSR     MLOADER                ; DISPLAY ALL THE MOVING CHARACTERS
ATIME2
          RTS

; CALLED ABOVE AND ALSO FROM "SCORE.S"

STATDISP  LDX     PLLIVES
          LDY     #$10                   ; INDEX OF LAST MAP ENTRY
LIFELOOP  CPX     #2
          BMI     STATDBYE               ; EXIT LOOP IF 1 OR 0

          MOVE    #STHEADCH+1,CLOWMAP1,Y
          DEY
          MOVE    #STHEADCH,CLOWMAP1,Y
          DEY
          BMI     STATDBYE               ; MAXIMUM DISPLAYED LIVES

          DEY                            ; INSERT A SPACE BETWEEN
          DEX
          JMP     LIFELOOP

STATDBYE  RTS

; THIS ROUTINE CLEARS OUT THE CHARACTER INFORMATION ARRAYS BY
;         SETTING THE Y COORDINATES OF EVERYTHING TO 0 (THIS SIGNIFIES
;         THAT IT'S NOT ON THE SCREEN).

; ZERO OUT ALL OF THE CHARACTERS:

CLRSTRCT  MOVEPTR CPALW,TEMP0

; ZERO OUT ALL OF THE CHARACTER INFORMATION ARRAYS:
;         THIS IS A TOTAL OF 977 BYTES, 3 PAGES + 209 BYTES.(1/3/84)

          LDX     #2                     ; DO THREE PAGES
          LDY     #00
          LDA     #0
ZSLP01    STA     (TEMP0),Y
          DEY
          BNE     ZSLP01
          DEX
          BMI     ZSLPEND1               ; THREE PAGES HAVE BEEN DONE
          INC     TEMP1                  ; ELSE GO TO NEXT PAGE
          JMP     ZSLP01

ZSLPEND1  LDY     #208                  ; DO 209 BYTES OF THE 4TH PAGE
          INC     TEMP1
ZSLP02    STA     (TEMP0),Y
          DEY
          BNE     ZSLP02

          MOVEPTR CSTATE+1,TEMP0      ; ZERO OUT ALL BUT CHUCK'S STATE
          LDA     #0
          LDY     #$5E                   ; 3 ARRAYS, $20 EACH
                                         ;  MINUS 1 FOR CHUCK
ZSLP03    STA     (TEMP0),Y
          DEY
          BPL     ZSLP03

          STA     NUMINAIR               ; NO CARRY OVER FROM LAST LEVEL
          STA     NUMSTUCK               ; ALSO NO CARRY FROM LAST LEVEL
          STA     ALLGONE                ;  STORE "FALSE" HERE

          STA     IRCHTIME               ; RESET NEAR CHEF TIMER
          STA     IRCHTIME+1

          LDX     #TOTALCH-1
ZSTRCT00  LDA     #0
          STA     CYPOS,X
          STA     CXPOS,X
          STA     CYPOSL,X
          STA     CXPOSL,X

          STA     CINFO,X                ; FOR USAGE BY "PILEDRAW"
          STA     CSECOND,X              ; 0 MEANS DO SECOND ZONE

          MOVE    #8,OLDDIR,X            ; SO THAT "OLDDIR" WORKS
          MOVE    #BLOCK1,CHSTAMP,X      ; DEFAULT IS FIRST BLOCK

          DEX
          BPL     ZSTRCT00

          LDX     #TOTALFX-1
ZSTRCT01  LDA     #0
          STA     FYPOS,X
          STA     FINFO,X
          STA     FDLPOS,X
          STA     FSTATE,X

          MOVE    #BLOCK1,FHSTAMP,X      ; DEFAULT

          DEX
          BPL     ZSTRCT01

; PUT ALL NULL CHARACTERS INTO THE LIVES LEFT MAP:

          LDX     #16
          LDA     #NULL2
ZSTRCT02  STA     CLOWMAP1,X
          DEX
          BPL     ZSTRCT02

; FILL ONLY THE DIGITS WITH NULL: (LEVEL INFO)

          LDX     #17
ZSTRCT03  STA     CLOWMAP2,X
          DEX
          CPX     #12
          BPL     ZSTRCT03

          RTS

; THIS ROUTINE FILLS THE DISPLAY LIST WITH ZEROS, LEAVING THE LEFT AND
;         RIGHT SIDE WALLS INTACT (THEY'RE ALWAYS THE FIRST TWO ITEMS
;         IN THE LIST).
;   NOTE: MAKE SURE TO CHANGE THIS SO THAT IT ALSO LEAVES THE HEADERS
;         FOR THE TOP AND BOTTOM WALLS !

CLRSCRN   ONSCREEN                       make sure it's done off-screen
          INVBLANK

          LDX     #9                    ; DLISTS 9 TO 1 HAVE LENGTH 8

          LDY     #8
CLR0011   STY     LISTSTRT,X
          STY     LISTSIZE,X
          DEX
          BPL     CLR0011

          LDY     #20
          STY     LISTSTRT+10
          STY     LISTSIZE+10
          STY     LISTSTRT
          STY     LISTSIZE

          LDX     #10

CLR0012   MOVE    LISTTABL,X,LISTPTR
          MOVE    LISTTABH,X,LISTPTR+1

          LDY     LISTSIZE,X

ZCLR01    LDA     #0
          STA     (LISTPTR),Y
          INY
          CPY     #LISTLENG                   ; LENGTH OF A DLIST
          BMI     ZCLR01
          DEX                            ; GO TO NEXT DLIST
          BPL     CLR0012

          RTS

; THIS ROUTINE DRAWS THE CONE IN A RANDOMLY SELECTED DLIST.

CONEDRAW
          LDA     #CONEX                 ; X POSITION IS ALWAYS THE SAME
          STA     FXPOS+CONESTRT

; Change the color of the cone to reflect the digit of this rack--
;         10 different possibilities.

          LDA     PLBCD+1
          AND     #$F
          TAX
          MOVE    CONECOL1,X,COLORS+28
          MOVE    CONECOL2,X,COLORS+29

          LDA     PLRACK
          CMP     #CONERAND              ; ONLY RANDOM AFTER LEVEL L
          BPL     CD0001

          LDA     #$5F                   ; CENTER OF LEFT WALL
          INC     CINFO+5                ; SO THAT PILES' "FDLPOS" IS CORRECT

          JMP     CD0002

CD0001    JSR     RANDOMY                ; PICK A RANDOM DLIST
          LSR     A                      ; GET ZONE NUMBER FOR CINFO

          TAX                            ; INCREMENT "CINFO" SO PILES
          INC     CINFO,X                ; ARE CORRECT

          ASL     A                      ; MULTIPLY BY 16 AND ADD 15 TO
          ASL     A                      ;   ADJUST CONE TO TOP OF ZONE
          ASL     A
          ASL     A
          CLC
          ADC     #15

CD0002    STA     FYPOS+CONESTRT

          LDA     #CONECHAR
          STA     FSTAMP+CONESTRT
          LDA     #BLOCK2
          STA     FHSTAMP+CONESTRT
          LDA     #CONEPALW
          STA     FPALW+CONESTRT

          MOVE    #6,FSTATE              ; TELLS WHICH FRAME CONE IS ON

          MOVE    #180,FINFO             ; 6 SECONDS

; SET UP THE DRIPPING INFORMATION:

          MOVE    #45,DRIPTIME
          MOVE    #99,DRIPFRAM           ; WAITING BEFORE FIRST DRIP
          LDA     #0
          STA     CYPOS+DRIPSTRT

          LDA     DRIPCHAR+2
          STA     CSTAMP+DRIPSTRT

          LDA     #$FF                    ; PALETTE 7, WIDTH 1
          STA     CPALW+DRIPSTRT

          LDA     #BLOCK2
          STA     CHSTAMP+DRIPSTRT

          LDA     FYPOS
          LSR     A
          LSR     A
          LSR     A
          LSR     A                      ; GET ZONE INDEX BACK
          ORA     #$20                   ; WE KNOW IT'S THE 3RD ENTRY
          STA     FDLPOS

          RTS

; DRAW THE HERO
;    BASE HIS POSITION ON THE CONE'S--
;         5F - CONEY + 5F = HEROY

HERODRAW
          MOVE    #FALSE,THROWBUT        ; MAKE SURE HE DOESN'T THROW RIGHT
                                         ; AWAY
          LDA     DOITOVER
          BEQ     ZHD020                 ; NORMAL RACK

          LDA     MODE                   ; THIS MIGHT BE ATTRACT MODE-- DON'T
          CMP     #MATTRACT              ; DO THIS TUNE !
          BEQ     HDSKIP10

          MOVE    #FALSE,DOITOVER        ; SO THAT "TUNIN" WILL WORK

          JSR     SCRAPALL               ; PLAY THE TUNE

          LDA     #21
          JSR     TUNIN
          LDA     #22
          JSR     TUNIN

HDSKIP10  MOVE    #TRUE,DOITOVER

ZHD020    LDA     #HEROX
          STA     CXPOS
          STA     CXPOS+1                ; BOTTOM HALF
          STA     FXPOS-1                ; FOR "SPACEM"

          LDA     #$BE                   ; 5F - CONEY + 5F = BE - CONEY
          SEC
          SBC     FYPOS+CONESTRT
          STA     CYPOS
          STA     FYPOS-1                ; FOR "SPACEM"
          SEC
          SBC     #12                    ; TOP HALF IS 16 HIGH
          STA     CYPOS+1

          MOVE    CCHEADS+6,CSTAMP       ; FIRST FRAME OF LEFT MOVEMENT
          MOVE    #HEROPALW,CPALW,CPALW+1
          MOVE    #ARMPALW,CPALW+2
          MOVE    #6,CDIR                ; FACING LEFT TO START

          LDA     PLRACK
          CMP     #31
          BMI     ZHD022                 ; IF LESS THAN 48, USE TABLE

          LDX     #15                    ; MAXIMUM TABLE VALUE
          JMP     ZHD023

ZHD022    JSR     MAXSET
          DEX                            get 0,1,2 for MAXCYCLE
          TXA
          ASL     A
          ASL     A
          ASL     A                      times 8 for table lookup base
          STA     TEMP0

          LDA     PLRACK
          AND     #$F                   ; 0 - 15 BATCHES
          LSR     A                      ; 8 SPEEDS PER 16 RACKS
          ORA     TEMP0                  this is the same as adding temp0
          TAX                            ; BASED ON "MAXCYCLE" CHANGING
                                         ;   EVERY 10 RACKS
ZHD023    MOVE    HSPEED,X,CSINDEX       ; HERO SPEED
          TAX

          MOVE    MTABSPD,X,CSPEED
          STA     CFRAME                 ; MOVE COUNTER
          ASL     A
          STA     CFRAME+1               ; ANIMATE COUNTER

          MOVE    #2,CACOUNT             ; THREE HERO ANIMATIONS, FOR NOW

; If the hero is carrying, then set up his arms and display the food
;         in his hand

          BIT     PLCARRY
          BMI     ZHDRAW00
          JMP     ZHDRAW01

ZHDRAW00  LDA     PLCARRY
          AND     #$7F
          STA     CTYPE+FOODSTRT

          TAY
          LDA     FLYCHAR,Y
          STA     CSTAMP+FOODSTRT
          LDA     FLYPALW,Y
          STA     CPALW+FOODSTRT
          LDA     #CARRIED
          STA     CSTATE+FOODSTRT
          LDA     #0
          STA     CREATOR+FOODSTRT

          MOVE    CCARMS+6,CSTAMP+2
          MOVE    CCRUNLC,CSTAMP+1

          LDA     CYPOS
          SEC
          SBC     #4
          STA     CYPOS+2

          LDA     CXPOS
          SEC
          SBC     #2
          STA     CXPOS+2

          MOVE    #FOODSTRT,HELDFOOD
          JSR     CFOODADJ

          MOVE    #CARRYING,CSTATE
          MOVE    #0,PLCARRY

          JMP     ZHDRAWA0               ; display cone and hero and
                                         ; turn on dma
ZHDRAW01  MOVE    #RUNNING,CSTATE
          MOVE    CCRUNL,CSTAMP+1         ; FIRST FRAME-- FEET
          MOVE    #0,CYPOS+2

; We reach here regardless of whether hero was carrying or not

ZHDRAWA0  JSR     FLOADER                ; DISPLAY THE CONE
          JSR     MLOADER                ; DISPLAY THE HERO

          LDA     FYPOS                  ; CALCULATE THE ZONE OF THE CONE
          LSR     A
          LSR     A
          LSR     A
          LSR     A
          TAY

          MOVE    #8,LISTSTRT,Y          ; RESTORE SO THAT I DON'T GET 2 CONES

;         JSR     DPPINIT                ; TURN DMA ON, SO THAT WE CAN SEE THE
                                         ;    THE MESSAGE AND REST OF RACK

          LDA     DOITOVER               ; NO MESSAGE HERE IF IR
          BNE     ZHDRAW02

          LDA     PLAYNUM
          BEQ     ZHDRAW88               ; IF ONE PLAYER GAME
          LDA     PLMESS                 ;
          BNE     ZHDRAW20               ; IF PLMESS = TRUE THEN MESSAGE
;         BEQ     ZHD0221                ; ELSE DON'T DISPLAY

; IF A ONE-PLAYER GAME, MESSAGE DISPLAYS ONLY ON VERY FIRST RACK AND LIFE

ZHDRAW88  LDA     PLFIRST               ; ONLY IF THE FIRST LIFE,FIRST RACK
          BEQ     ZHD0211

ZHDRAW20  MOVE    #0,PLMESS              ; NO MORE MESSAGE (UNTIL DEATH)
          JSR     MKPROMPT               ; NO "RTS" UNTIL WAIT IS DONE

; PLAY THE RACK START TUNE AFTER THE PROMPT GOES AWAY AND AS THE CHEFS
;         START TO RISE:

          LDA     PLFIRST                ; IF THIS PLAYER'S FIRST RACK
          BEQ     ZHD0211                ; LATER RACK-- SHORT TUNE

          LDA     #00                    ; IF FIRST RACK AND FIRST LIFE
          JMP     ZHD0212

ZHD0211   LDA     #30                    ; IF LATER LEVEL OR LIFE
ZHD0212   JSR     TUNIN

ZHDRAW02  RTS

