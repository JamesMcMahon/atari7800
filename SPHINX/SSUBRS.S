*         SPHINX--SSUBRS.S
* IF YOU DON'T KNOW WHERE TO PUT SOMETHING, PUT IT IN THIS MODULE

;          ZERODEF

;          RSEG    CODEF

*PROGRAMMERS BEWARE: THIS CODE IS OLD AND VERY UGLY! TAMPER AT YOUR OWN RISK
*
*         ADDSCORE
*ASSUMES LOW DIGIT IN TENS, MIDDLE DIGIT IN HUNDS AND HIGH DIGIT IN HUNTHOUS
*ASSUMES PLAYER HAS 0 FOR PLAYER 0 AND A 1 FOR  PLAYER 1. RESETS ALL VALUES TO 0
*PRESERVES A,X & Y REGISTERS

ADDSCORE: BIT     AUTOPLAY               ;IF AUTOPLAY THEN PUNT
          BMI     ZPUNTSCR
          SED
          PHA                            ;ISN'T IT A WASTE FOR THIS TO SAVE A
          TXA                            ;AND THE REST OF THEM
          PHA
          TYA
          PHA
          LDX     PLAYER
          LDY     PLAYER                 ;VERY NON-OPTIMAL
          BEQ     PLAYER1
          LDX     #1
          LDY     #PL2SCORE-PL1SCORE
PLAYER1:
	lda	PL1LIVES,X		;Add extra lives.
	clc
	ADC     HUNTHOUS
	sta	PL1LIVES,X
;
	LDA     PL1SCORE+3,Y
          CLC
          ADC     TENS
          STA     PL1SCORE+3,Y
          LDA     PL1SCORE+2,Y
          ADC     HUNDS
          STA     PL1SCORE+2,Y
          BCC     NOINCLIV

          INC     PL1LIVES,X

          PHP                            ;SAVE CARRY AND DECIMAL
          CLD                            ;CLEAR DECIMAL FOR TUNIN
          LDA     #XLPOWER
          JSR     TUNIN
          PLP                            ;RESTORE CARRY AND DECIMAL

NOINCLIV:
          LDA     PL1SCORE+1,Y
          ADC     HUNTHOUS
          STA     PL1SCORE+1,Y
;
          CLD
          LDA     #0
          STA     TENS
          STA     HUNDS
          STA     HUNTHOUS
          PLA
          TAY
          PLA
          TAX
          PLA
ZPUNTSCR: RTS


; LDLIVES LOADS UP THE EXTRA LIVES DISPLAY

LDLIVES:                                 ;GOOD CANDIDATE FOR CRUNCHING
          LDX     #9                     ;MORE ROM INTENSIVE THAN NEED BE
          LDY     PL1LIVES
          LDA     PLAYER
          BEQ     USELESS
          INY
USELESS:  DEY
          BEQ     DIETCOKE
          BMI     DIETCOKE
          LDA     #XTRA&$FF
          CPY     #7                     ;6 IS MAXIMUM
          BCC     PEPPER
          LDY     #6                     ;SEVEN LIVES MAX TO BE ON SCREEN
PEPPER:   STA     PL1LVMAP,X
          DEX
          DEY
          BNE     PEPPER
          CPX     #$FF
          BEQ     DEW
DIETCOKE: LDA     #BLANKCHR&$FF           ;FILLS IN BLANKS
          STA     PL1LVMAP,X
          DEX
          BPL     DIETCOKE

DEW:
          LDY     #0
          LDX     PL2LIVES               ;Y IS ZERO
          LDA     PLAYER
          BNE     USELESS2
          INX
USELESS2: DEX
          BEQ     BARLHEAD
          BMI     BARLHEAD
          LDA     #XTRA&$FF
          CPX     #7
          BCC     MELOYELO
          LDX     #6
MELOYELO: STA     PL2LVMAP,Y
          INY
          DEX
          BNE     MELOYELO
          CPY     #6
          BEQ     WITEROCK
BARLHEAD: LDA     #BLANKCHR&$FF
          STA     PL2LVMAP,Y
          INY
          CPY     #6
          BNE     BARLHEAD

WITEROCK: RTS


;
; LDSCORE LOADS UP SCORE DISPLAY FOR SCORE BYTES

LDSCORE:  LDX     #5                     ;SIX DIGITS
          LDY     #3                     ;FOUR  BYTES
PEPSI:    LDA     PL1SCORE,Y             ;GET LOW TWO DIGITS OF PL0'S SCORE
          PHA                            ;SAVE AWAY
          AND     #$0F                   ;GET BOTTOM NIBBLE
;         CLC                            ;MULTIPLY BY TWO TO GET NUM IN CHAR MAP
;         ADC     #NUMBERS            ;MAY BE UNNECESSARY
          STA     TEMP0,X                ;STORE AWAY FOR LATER
          DEX
          PLA                            ;GET BACK LOW BYTE AND GET NEXT DIGIT
          AND     #$F0
          LSR     
          LSR     
          LSR     
          LSR     
;         CLC
;         ADC     #NUMBERS
          STA     TEMP0,X
          DEX
          DEY
          BPL     PEPSI                  ;DO UNTIL ALL 6 DIGITS (3 BYTES) ARE
                                         ;LOADED
          LDA     #$69                   ;SET OVERFLOW
          ADC     #$69
          LDX     #0                     ;THIS ELIMINATES LEADING ZEROES
          LDA     #BLANKCHR&$FF
SPRITE:   LDY     TEMP0,X
          BVC     NOMORE0
          CPY     #NUMBERS&$FF
          BNE     NOMORE0
          STA     PL1MAP+4,X
          JMP     NEXEX

NOMORE0:  TYA
          STA     PL1MAP+4,X
          CLV

NEXEX:    INX
          CPX     #6
          BNE     SPRITE

          TYA
          BNE     NOSTUF0

          LDA     #0                     ;IF ZERO IS LEAST SIGNIFICANT DIGIT
          STA     PL1MAP+9               ;THEN DISPLAY IT

NOSTUF0:  LDX     #0                     ;PLAYER 1 NOW
          LDY     #1                     ;LEFT JUSTIFY AND BLANK LEADING ZEROES
ZJM3:     LDA     PL2SCORE,Y
          PHA
          AND     #$F0
          BNE     REAL
          PLA
          AND     #$0F
          BNE     REAL2
          INY
          CPY     #4
          BNE     ZJM3
          LDA     #NUMBERS&$FF            ;ALL MUST BE ZERO
          STA     PL2MAP
          RTS

COKE:     LDA     PL2SCORE,Y             ;MUST BE NONZERO NUMBER BY NOW
          PHA                            ;IN HIGH DIGIT OF BYTE
          AND     #$F0
REAL:     LSR     
          LSR     
          LSR     
          LSR     
;         CLC                            ;YEA ITS CLEAR
;         ADC     #NUMBERS
          STA     PL2MAP,X
          INX
          PLA
REAL2:    AND     #$0F                   ;MUST BE NONZERO NUMBER BY NOW IN
;         ASL                           ;LOW DIGIT
;         CLC
;         ADC     #NUMBERS
          STA     PL2MAP,X
          INX
CRUSH:    INY
          CPY     #4
          BNE     COKE
TAB:      CPX     #10
          BEQ     ARECEE
          LDA     #BLANKCHR&$FF
          STA     PL2MAP,X
          INX
          BPL     TAB                    ;ALWAYS POSITIVE

ARECEE:   RTS


******************************************
*         SPHINX--SLOADER.S              *
******************************************
LDDONE:   LDA     #0                     ;STORE ZEROES AT END OF DLISTS
          TAX                            ;TRADE ROM FOR TIME
          LDY     #1                     ;TWO ZEROS EACH
          STA     (ZNDLPOS,X)
          STA     (ZNDLPOS),Y
          STA     (ZNDLPOS+2,X)
          STA     (ZNDLPOS+2),Y
          STA     (ZNDLPOS+4,X)
          STA     (ZNDLPOS+4),Y
          STA     (ZNDLPOS+6,X)
          STA     (ZNDLPOS+6),Y
          STA     (ZNDLPOS+8,X)
          STA     (ZNDLPOS+8),Y
          STA     (ZNDLPOS+10,X)
          STA     (ZNDLPOS+10),Y
          STA     (ZNDLPOS+12,X)
          STA     (ZNDLPOS+12),Y
          STA     (ZNDLPOS+14,X)
          STA     (ZNDLPOS+14),Y
          STA     (ZNDLPOS+16,X)
          STA     (ZNDLPOS+16),Y
          STA     (ZNDLPOS+18,X)
          STA     (ZNDLPOS+18),Y
          STA     (ZNDLPOS+20,X)
          STA     (ZNDLPOS+20),Y
          STA     (ZNDLPOS+22,X)
          STA     (ZNDLPOS+22),Y

          LDA     #5                     ;THIS SHOULD ADJUST HIGH BYTES OF
          STA     ZNDLPOS+22             ;HEADERS IN LAST ZONE TO MAKE UP FOR
          LDA     ZONEOFF                ;SCROLLING
                                         ;THE 5 IN ZNDLPOS IS FOR CHAR MAP
          CLC
          ADC     #1
          STA     KTEMP10                ;THIS NUMBER REFLECTS ZONEOFF'S EFFECT
          LDY     #2                     ;Y IS 2 SO THAT IT FALLS INTO LOOP
                                         ;CORRECTLY
HACKKKK:  DEY                            ;Y = 1 FOR PALWIDTH
          LDA     (ZNDLPOS+22),Y         ;IF PW IS ZERO, END OF DISPLAY LIST
          BEQ     THATSALL
          INY                            ;LOOK AT HIGH BYTE
          LDA     (ZNDLPOS+22),Y
          CLC
          ADC     KTEMP10                ;ADD THE MAGIC CONSTANT
          STA     (ZNDLPOS+22),Y
          LDA     ZNDLPOS+22             ;ADD FOUR TO ZNDLPOS TO GET NEXT HEADER
          CLC
          ADC     #4
          STA     ZNDLPOS+22
          BNE     HACKKKK                ;JMP

THATSALL:
          LDA     #0                     ;THIS MEANS WE MADE IT THROUGH LOADER
          STA     FUCKFLAG
NOLODE:   RTS

LOADER:
          LDA     #$80                   ;THIS MEANS WE STARTED LOADER
          STA     FUCKFLAG

          LDA     #5                     ;SET LOW BYTE OF DL POINTERS TO 5
          STA     ZNDLPOS                ;THIS ALLOCATES SPACE USED FOR CHAR MAP
          STA     ZNDLPOS+2
          STA     ZNDLPOS+4
          STA     ZNDLPOS+6
          STA     ZNDLPOS+8
          STA     ZNDLPOS+10
          STA     ZNDLPOS+12
          STA     ZNDLPOS+14
          STA     ZNDLPOS+16
          STA     ZNDLPOS+18
          STA     ZNDLPOS+20
          STA     ZNDLPOS+22

          LDA     ZONEOFF                ;MAKE KTEMP10 RANGE FROM F1 TO 00
          SEC
          SBC     #14
          STA     KTEMP10                 ;THIS IS LIKE NEGATIVE ZONEOFF
          LDY     LOWEST                 ;FOLLOW LINKED LIST TO LOAD
LDLOOP:   BPL     CYCLES
          JMP     LDDONE

CYCLES:   CPY     #ZREF0&$FF
          BCS     LDNEXT                 ;PUNT OUT ON REF. POINTS

          LDA     HPTBL,Y
          CMP     #160
          BCC     FINEHORZ
          CMP     #$DC
          BCC     LDNEXT

FINEHORZ:
          LDA     VPTBL,Y                ;VERT POS, RANGING FROM F1 TO #SCRENBOT
          CMP     #$F1                   ;TALK TO JEM ABOUT THIS ONE GRRRR!
          BCS     LOADY
          CMP     #SCRENBOT
          BCS     LDNEXT
LOADY:    SEC
          SBC     KTEMP10                 ;THIS IS LIKE ADDING 16 FOR ZONEOFF UV
                                         ;FF OR ADDING 1 FOR ZONEOFF OF E
                                         ;OR ANYTHING IN BETWEEN.
          STA     KTEMP1                 ;THE RESULT GOES INTO KTEMP1

          CMP     #$F1                   ;SEE IF TOP ZONE WOULD BE NEGATIVE
          BCS     PUNTTOP                ;IT TAKES THIS ON F1 THROUGH FF
          AND     #$F0                   ;CARRY SHOULD BE CLEAR

;IF SOMEHOW WE FALL THROUGH HERE THEN...

          LSR                           ;THIS PICKS OUT ZONE NUMBER X2 FOR
          LSR                           ;INDIRECT INDEXING BY X
          LSR     
          TAX

          LDA     ZNDLPOS,X
          CMP     #75                    ;IF 75 OR BIGGER, WE CAN'T FIT A 4
          BCS     LDNEXT                 ;BYTE HEADER AND TWO ZEROS, SO PUNT

          LDA     SLTBL,Y                ;LOAD AND STORE LOWBYTE
          STA     (ZNDLPOS,X)
          INC     ZNDLPOS,X
          LDA     PWTBL,Y                ;LOAD AND STORE PALWIDTH
          STA     (ZNDLPOS,X)
          INC     ZNDLPOS,X
          LDA     KTEMP1                 ;THIS IS POSITIVE AND NONZERO
;SOOOO, WE ARE ALWAYS ADDING AT LEAST 1 TO THE HIGH BYTES
          AND     #$F
          CLC                            ;CARRY SHOULD BE CLEAR FROM SHIFTS
          ADC     SHTBL,Y                ;ADD TO HIGH BYTE
          CMP     SMTBL,Y                ;COMPARE TO THE MAGIC NUMBER
          STA     KTEMP1                 ;REPLACE OLD KTEMP1 (THIS IS WHY WE
                                         ;AND WITH F ABOVE) I DON'T SEE WHY THIS
                                         ;WOULD EVER WORK
          STA     (ZNDLPOS,X)            ;STORE INTO HIGH BYTE
          INC     ZNDLPOS,X
          LDA     HPTBL,Y                ;LOAD AND STORE HPOS
          STA     (ZNDLPOS,X)
          INC     ZNDLPOS,X

DOBOTTOM: BCC     LDNEXT                 ;IF HIGH BYTE IS LESS THAN MAGIC NUMBER
          INX                            ;THEN DON'T DO NEXT ZONE
          INX
          CPX     #24                    ;ALSO PUNT IF OFF BOTTOM OF SCREEN
          BCS     LDNEXT                 ;FALLS IN NEXT ZONE ALSO?

HEREOJ:
          LDA     ZNDLPOS,X              ;DON'T WANT TO FILL ZONE
          CMP     #75
          BCS     LDNEXT

          LDA     SLTBL,Y                ;CARRY IS CLEAR
          STA     (ZNDLPOS,X)            ;LOAD AND STORE LOW BYTE
          INC     ZNDLPOS,X
          LDA     PWTBL,Y                ;LOAD AND STORE PALWIDTH
          STA     (ZNDLPOS,X)
          INC     ZNDLPOS,X
          LDA     KTEMP1                 ;LOAD IN LAST ZONES HIGH BYTE
;         SEC                            ;CARRY IS CLEAR AND THEREFORE
          SBC     #15                    ;SUBTRACT 16-1 = 15
          STA     (ZNDLPOS,X)            ;SUBTRACT 16 FOR THIS ZONE'S HI BYTE
          INC     ZNDLPOS,X
          LDA     HPTBL,Y                ;LOAD AND STORE H POS
          STA     (ZNDLPOS,X)
          INC     ZNDLPOS,X

LDNEXT:   LDA     RLTBL,Y                ;FOLLOW RIGHT LINK
          TAY
          JMP     LDLOOP

PUNTTOP:
;HERE THE OBJECT STARTS OFF SCREEN AND FALLS OVER INTO ZONE 0


          ;KTEMP1 IS IN A ALREADY
;         LDA     KTEMP1                 ;GET NEW HIGH BYTE FROM KTEMP1
          AND     #$F
          CLC
          ADC     SHTBL,Y                ;CHECK FOR OVERLAP INTO NEXT ZONE
          CMP     SMTBL,Y                ;COMPARE TO MAGIC NUMBER
          STA     KTEMP1                 ;STORE BACK TO KTEMP1 FOR NEXT ZONE
          BCC     LDNEXT
LDX0:     LDX     #0                     ;ZONE FF WRAPS TO ZONE 0
          BEQ     HEREOJ                 ;JMP

;          END
