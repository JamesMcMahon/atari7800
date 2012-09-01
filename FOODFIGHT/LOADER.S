; LOADER.S
; THIS FILE CONTAINS TWO ROUTINES: THE MOVING CHARACTER LOADER, "MLOADER",
;         WHICH IS CALLED EVERY OTHER FRAME, AND THE FIXED CHARACTER
;         LOADER, "FLOADER", WHICH IS CALLED ONCE AT THE BEGINNING OF EACH
;         RACK.
;

; THIS LOADER ASSUMES 16-HIGH ZONES, NUMBERED WITH ZONE 0 AT THE BOTTOM OF
;         THE SCREEN; WITH "OFFSET" DECREMENTING THROUGH EACH ZONE, SO THAT
;         THE CHARACTER TABLES MUST BE STORED UPSIDE DOWN.
;
;  BECAUSE OF THE IMMANENT MARIA II, I'VE CHANGED MY STAMP ORGANIZATION
;         TO REFLECT THE ONCOMING "HOLY ROM".  THUS, EVEN THE FIXED CHARACTERS
;         HAVE ZERO PADDING FOR NOW, TO SIMULATE THE WAY THE HOLY ROM WILL
;         ACTUALLY APPEAR.  ALL CHARACTERS HAVE THEIR FIRST REAL INFO AT
;         EITHER "BLOCK1" ($50) OR "BLOCK2" ($70)
;         AND ALL CHARACTERS EXTEND THROUGH 16 PAGES OF
;         ROM.
;  SINCE "MLOADER" INCREMENTS INDICES, THE HERO HAS LOWEST PRIORITY, THE CHEFS
;         NEXT LOWEST, AND THE MOVING FOODS HAVE HIGHEST.  ALL MOVING CHARS.
;         HAVE PRIORITY OVER FIXED CHARACTERS.

          GLBL    MLOADER

MLOADER
          LDX     #NUMZONES-1            ; INDEX OF THE LAST ZONE

; INITIALIZE THE SIZE OF EACH LIST TO BE AFTER THE FIXED CHARACTERS ALREADY
;         IN THE LISTS.

ZLOAD00   LDA     LISTSTRT,X
          STA     LISTSIZE,X
          DEX
          BPL     ZLOAD00

; THE LOADER ITSELF:
          LDY     #0                     ; REGISTER Y WILL CONTAIN THE CH INDEX
GETSTAMP  LDA     CYPOS,Y
          STY     LTEMPY                  ; STORES THE CHARACTER INDEX
          BEQ     JMPNXTS                ; IF Y = 0, STAMP IS INVISIBLE

          STA     TEMPYPOS               ; Y POSITION
          LSR     A                      ; DIVIDE BY 16
          LSR     A
          LSR     A
          LSR     A                      ; "A" NOW CONTAINS THE ZONE NUMBER

          CMP     #11                    ; IF GREATER THAN 10, WE FUCKED UP
          BPL     JMPNXTS

          TAX                            ; REGISTER X IS THE ZONE INDEX

          MOVE    CXPOS,Y,HEADER3        ; SETUP THE HEADER BYTES WHICH
          MOVE    CSTAMP,Y,HEADER0       ;  ARE CONSTANT ACROSS ZONES
          MOVE    CHSTAMP,Y,HEADER2
          MOVE    CPALW,Y,HEADER1

          MOVE    CSECOND,Y,LSECOND      ; FOR LATER OVERLAP TEST

; THE FOLLOWING LOOP, "OVERLAPS", GETS EXECUTED ONCE FOR EACH ZONE WHICH
;         THE CHARACTER IS IN.  THE ONLY THING WHICH CHANGES IS THE HIGH
;         BYTE OF THE HEADER; THE VARIABLE "HIGHPOS" KEEPS TRACK OF THE
;         CURRENT HIGH BYTE.  THE CHARACTER INFO IS FINISHED WHEN THE
;         VALUE AT (HIGHPOS+8,HEADER0) IS 0; WHEN THIS CONDITION IS
;         SATISFIED, I KNOW THE LAST ZONE OF THIS CHARACTER HAS JUST
;         BEEN LOADED, AND I CAN BRANCH TO "NXTSTAMP".

OVERLAPS  LDY     LISTSIZE,X             ; SEE IF DLIST IS ALREADY FULL
          CPY     #LISTLENG
          BCC     NUFFROOM

; If there's no room for this stamp, it'll be invisible anyway, so remove
;         it from gameplay.
; Assume that this is a food; if a chef, it'll become immediately obvious

AALOAD    LDY     LTEMPY                 character index
          LDA     #0
          STA     CYPOS,Y

          LDA     STATUS                 if food is flying through air to hero,
          CMP     #STATHIT               make sure this gets decremented
          BNE     NXTSTAMP

          LDA     CSTATE,Y               must be a food with state ANGLE
          CMP     #ANGLE
          BNE     NXTSTAMP

          LDA     #6                     make the splat sound
          JSR     TUNIN

          DEC     NUMINAIR

JMPNXTS   BPL     NXTSTAMP               a jump-- numinair is always positive

; REGISTER Y IS NOW AN INDEX TO THE NEXT FREE HEADER BYTE IN THE DLIST.

NUFFROOM  MOVE    LISTTABL,X,LISTPTR     ; ELSE SET UP THE LIST POINTER
          MOVE    LISTTABH,X,LISTPTR+1

          LDA     HEADER0
          STA     (LISTPTR),Y            ; FIRST BYTE OF HEADER
          INY
          LDA     HEADER1                ; SECOND BYTE OF HEADER
          STA     (LISTPTR),Y
          INY

; THE THIRD BYTE IS THE ONLY TRICKY ONE.  IF THIS IS THE FIRST ZONE OF THE
;         CHARACTER, "HIGHPOS" MUST BE INITIALIZED TO
;         (LAST CHAR INFO) - (16 LINES) + (# ZEROS NEEDED).
;         NOTE THAT (# ZEROS NEEDED) = (TOPZONE,X) - (TEMPYPOS).

          LDA     TOPZONE,X              ; CALCULATE NUMBER OF ZEROS
          SEC
          SBC     TEMPYPOS
          BCC     HIGHSET             ; IF NEGATIVE, THIS ISN'T THE FIRST ZONE

          CLC                            ; ELSE WE NEED TO SET HIGHPOS
          ADC     HEADER2                ; HIGH BYTE OF CHAR. TABLES
          STA     HIGHPOS

HIGHSET   LDA     HIGHPOS
          STA     (LISTPTR),Y            ; FINALLY, STORE THE THIRD HEADER BYTE
          INY
          LDA     HEADER3                ; NOW THE LAST HEADER BYTE
          STA     (LISTPTR),Y
          INY
          STY     LISTSIZE,X             ; READY FOR THE NEXT HEADER

; WE'RE FINISHED WITH THIS HEADER. CHECK TO SEE IF THIS CHARACTER IS
;         FINISHED.  THIS WILL BE TRUE IF "HIGHPOS" IS LESS THAN OR EQUAL TO
;         THE HIGH BYTE OF THE FIRST PAGE OF REAL CHARACTER INFO (THE VALUE
;         "STAMPHGH").
;   NOTE: IF THE VALUE IN "CSECOND" IS NON-ZERO, DON'T DO THE SECOND
;         HEADER OF THIS STAMP.  (FOR FALLING AND GROWING FROM HOLES)

          LDA     LSECOND                ; VALUE FROM ABOVE
          BNE     NXTSTAMP               ; IF NON-ZERO, SKIP NEXT HALF

          LDA     HIGHPOS
          SEC
          SBC     #1                     ; TO GET <= OPERATION
          CMP     HEADER2
          BCC     NXTSTAMP               ; IF LAST REAL INFO HAS BEEN DISPLAYED

          LDA     HIGHPOS
          SEC
          SBC     #16                    ; GET NEW "HIGHPOS" VALUE
          STA     HIGHPOS
          DEX                            ; POINT TO NEXT LOWER ZONE
          BPL     OVERLAPS               ; IF IT'S ON THE SCREEN, DO IT

NXTSTAMP  LDY     LTEMPY                  ; REMEMBER, THIS IS THE CHAR. INDEX !
          INY
          CPY     #TOTALCH
          BPL     ENDLOAD                temporary for bug detection
          JMP     GETSTAMP

;         BMI     GETSTAMP               ; KEEP GOING UNTIL ALL ARE DONE

ENDLOAD
; NOW, LOOP THROUGH ALL THE ZONES ONE MORE TIME, AND PLACE TERMINATING
;         ZEROS IN THE SECOND BYTE OF THE FIRST FREE HEADER:

          LDX     #NUMZONES-1
ENDLIST   LDY     LISTSIZE,X
          INY
          MOVE    LISTTABL,X,LISTPTR     ; CALCULATE ZONE POINTER
          MOVE    LISTTABH,X,LISTPTR+1

          LDA     #0
          STA     (LISTPTR),Y
          DEX
          BPL     ENDLIST

          RTS

; FLOADER
; THIS ROUTINE IS ALMOST IDENTICAL TO "MLOADER".  IT'S ISOMORPHIC, BUT
;         WITH ALL MOVING CHAR REFERENCES REPLACED BY FIXED CHAR REFERENCES.
;   NOTE: THE INDEX IN THE MAIN LOOP HERE INCREMENTS (UNLIKE "MLOADER"
;         WHICH DECREMENTS).  IT MUST DO THIS DUE TO THE WAY I'VE
;         IMPLEMENTED FOOD PILES; I CREATE THEM WHILE INCREMENTING, THUS
;         I HAVE TO BE ABLE TO KNOW THEIR DLIST POSITIONS AT CREATION TIME.
;         THIS IS POSSIBLE ONLY IF I ALSO INCREMENT HERE.

FLOADER
          LDX     #NUMZONES-1            ; RESTORE LISTSIZE FROM LISTSTRT
ZFLOAD00  LDA     LISTSTRT,X
          STA     LISTSIZE,X
          DEX
          BPL     ZFLOAD00

          LDY     #0                     ; REGISTER Y WILL CONTAIN THE CH INDEX
GETFIXED  LDA     FYPOS,Y
          STY     LTEMPY                  ; STORES THE CHARACTER INDEX
          BEQ     NXTFIXED               ; IF Y = 0, STAMP IS INVISIBLE
          STA     TEMPYPOS               ; Y POSITION
          LSR     A
          LSR     A
          LSR     A
          LSR     A                      ; "A" NOW CONTAINS THE ZONE NUMBER
          TAX                            ; REGISTER X IS THE ZONE INDEX

          MOVE    FXPOS,Y,HEADER3        ; SETUP THE HEADER BYTES WHICH
          MOVE    FSTAMP,Y,HEADER0       ;  ARE CONSTANT ACROSS ZONES
          MOVE    FHSTAMP,Y,HEADER2
          MOVE    FPALW,Y,HEADER1

; THE FOLLOWING LOOP, "FOVERLAP", GETS EXECUTED ONCE FOR EACH ZONE WHICH
;         THE CHARACTER IS IN.  THE ONLY THING WHICH CHANGES IS THE HIGH
;         BYTE OF THE HEADER; THE VARIABLE "HIGHPOS" KEEPS TRACK OF THE
;         CURRENT HIGH BYTE.  THE CHARACTER INFO IS FINISHED WHEN THE
;         HIGHPOS IS <= #FIXEDHGH; WHEN THIS CONDITION IS
;         SATISFIED, I KNOW THE LAST ZONE OF THIS CHARACTER HAS JUST
;         BEEN LOADED, AND I CAN BRANCH TO "NXTSTAMP".

FOVERLAP  LDY     LISTSIZE,X             ; SEE IF DLIST IS ALREADY FULL
          CPY     #LISTLENG
          BCS     NXTFIXED               ; IF IT IS, GO ON TO THE NEXT STAMP

; REGISTER Y IS NOW AN INDEX TO THE NEXT FREE HEADER BYTE IN THE DLIST.

          MOVE    LISTTABL,X,LISTPTR     ; ELSE SET UP THE LIST POINTER
          MOVE    LISTTABH,X,LISTPTR+1

          LDA     HEADER0
          STA     (LISTPTR),Y            ; FIRST BYTE OF HEADER
          INY
          LDA     HEADER1                ; SECOND BYTE OF HEADER
          STA     (LISTPTR),Y
          INY

; THE THIRD BYTE IS THE ONLY TRICKY ONE.  IF THIS IS THE FIRST ZONE OF THE
;         CHARACTER, "HIGHPOS" MUST BE INITIALIZED TO
;         (LAST CHAR INFO) - (16 LINES) + (# ZEROS NEEDED).
;         NOTE THAT (# ZEROS NEEDED) = (TOPZONE,X) - (TEMPYPOS).

          LDA     TOPZONE,X              ; CALCULATE NUMBER OF ZEROS
          SEC
          SBC     TEMPYPOS
          BCC     FHIGHSET             ; IF NEGATIVE, THIS ISN'T THE FIRST ZONE

          CLC                            ; ELSE WE NEED TO SET HIGHPOS
          ADC     HEADER2
          STA     HIGHPOS

FHIGHSET   LDA     HIGHPOS
          STA     (LISTPTR),Y            ; FINALLY, STORE THE THIRD HEADER BYTE
          INY
          LDA     HEADER3                ; NOW THE LAST HEADER BYTE
          STA     (LISTPTR),Y
          INY
          STY     LISTSIZE,X             ; READY FOR THE NEXT HEADER

; WE'RE FINISHED WITH THIS HEADER. CHECK TO SEE IF THIS CHARACTER IS
;         FINISHED.  THIS WILL BE TRUE IF "HIGHPOS" IS LESS THAN OR EQUAL TO
;         THE BEGINNING OF THE STAMP TABLE, "STAMPHGH" ($4F).

          LDA     HIGHPOS
          SEC
          SBC     #1                     ; SUBTRACT 1 TO GET <= OPERATION
          CMP     HEADER2
          BCC     NXTFIXED

          LDA     HIGHPOS
          SEC
          SBC     #16                    ; GET NEW "HIGHPOS" VALUE
          STA     HIGHPOS
          DEX                            ; POINT TO NEXT LOWER ZONE
          JMP     FOVERLAP               ; ELSE, DO NEXT ZONE-- "HIGHPOS"
                                         ;   IS ALREADY SET

NXTFIXED  LDY     LTEMPY                  ; REMEMBER, THIS IS THE CHAR. INDEX !
          INY
          TYA
          CMP     #TOTALFX
          BMI     GETFIXED               ; DO ALL UP TO, BUT NOT INCLUDING,
                                         ;   #TOTALFX

; NOW THAT WE'RE FINISHED, SET THE TABLE "LISTSTRT" TO BE EQUAL TO THE VALUES
;         WE JUST DERIVED FOR "LISTSIZE".

          LDX     #NUMZONES-1
ZLOAD08   LDA     LISTSIZE,X
          STA     LISTSTRT,X
          DEX
          BPL     ZLOAD08

;         LDX     #NUMZONES-1            ; SETUP FOR "ENDLIST"
          JMP     ENDLOAD
