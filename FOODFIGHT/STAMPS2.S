;STAMPS2.S

;   NOTE THAT SINCE MARIA II DECREMENTS "OFFSET" THROUGH EACH ZONE, THE
;         CHARACTER INFO MUST BE STORED HERE UPSIDE-DOWN, SINCE THE
;         TOP OF THE CHARACTER WILL BE READ AT THE BOTTOM OF THIS TABLE.
;

          ORG     $A000                  ; PAGE 1 (OF ACTUAL CHARACTERS)
          DB      $00,$00                ; 8 DIFFERENT HEAD DIRECTIONS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00

; BEGINNING OF CHEF STAMPS.
;         THE FOUR HAT STAMPS COME FIRST, FOLLOWED BY THE 8 HEAD STAMPS,
;         FOLLOWED BY RUNNING WITH ARMS, FOLLOWED BY RUNNING WITHOUT ARMS.

          DB      $00,$00                ; TALLEST HAT
          DB      $00,$00                ; 2ND HAT
          DB      $00,$00                ; 3RD HAT
          DB      $00,$00                ; 4TH HAT
          DB      $00,$00,$00,$00        ; HEADS-- 1 BYTE APIECE
          DB      $00,$00,$00,$00
          DB      $00,$00                ; RUNNING WITH ARMS
          DB      $00,$00
          DB      $00,$00                ; 3RD
          DB      $00,$00                ; 4TH
          DB      $00,$00                ; RUNNING WITHOUT ARMS
          DB      $00,$00                ; 2ND
          DB      $00,$00                ; 3RT
          DB      $00,$00                ; 4TH
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00    ; 64 BYTES

;         FIRST PAGE OF CHUCK RIGHT BOTTOM HALF (WITHOUT ARMS)

          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES


          DB      $00,$00,$00,$00        ; USED FOR MOVING PIES
          DB      $00,$00,$00,$00        ; 6 CHUCK LEFT FRAMES
          DB      $00,$00,$00,$00
          DB      $00,$00,$00,$00
          DB      $03,$00                ; ICE CREAM CONE  *** $70
          DB      $0,$0,$0,$0,$0,$0    ; DISPERSING PEAS    *** $72

; "8-HIGH" CHARACTERS (SUCH AS PILES, MANHOLES, WALL PIECES)

          DB      $00,$14,$00            ; WATERMELON

          DB      $00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 64 BYTES

          DB      $3F,$FF,$FC            ; CLOSED
          DB      $3F,$FF,$FC            ; OPEN

          DB      $00,$00,$00,$00        ; NULL

          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00

          DB      $00,$00,$00,$00,$00,$00        ; HERO POINTING ARMS  *** $DC
          DB      $00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00

          DB      $00,$00                ; WATERMELON SLICE

          DB      $00,$00,$00,$00        ; REJOICE
          DB      $00,$00,$00,$00

          ORG     $A100                  ; PAGE 2 OF CHARACTER INFO
          DB      $00,$00                ; 8 DIFFERENT HEADS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00

          DB      $00,$00                ; HAT1
          DB      $00,$00                ; 2
          DB      $00,$00                ; 3
          DB      $00,$00                ; 4
          DB      $00,$00,$00,$00,$00,$00,$00,$00    ; HEADS
          DB      $00,$00                ; RUNNING WITH ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00

; START OF THE 8-HIGH MOVING INFO:
;   2ND PAGE OF BOTTOM HALF OF CHUCK RIGHT

          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES


; START OF THE SECOND 16-HIGH FIXED INFO:

          DB      $00,$00,$00,$00
          DB      $00,$00,$00,$00        ; CHUCK LEFT ANIMATIONS
          DB      $00,$00,$00,$00
          DB      $00,$00,$00,$00
          DB      $03,$00                ; CONE
          DB      $0,$0,$0,$0,$0,$0    ; DISPERSING PEAS

; 2TH OF FIRST 8 PAGES (OF ZEROES) OF 8-HIGH FIXED CHARACTERS:

          DB      $01,$55,$40            ; WATERMELON

          DB      $00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 64 BYTES

          DB      $FF,$FF,$FF            ; CLOSED
          DB      $C0,$00,$0B            ; OPEN

          DB      $00,$00,$00,$00        ; NULL

          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00

          DB      $00,$00,$00,$00,$00,$00        ; CHUCK POINTING ARMS
          DB      $00,$00,$00,$00,$00,$00
          DB      $00,$03,$40,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00

          DB      $00,$00                ; WATERMELON SLICE

          DB      $00,$00,$00,$00        ; REJOICE
          DB      $00,$00,$00,$00

          ORG     $A200                  ; PAGE 3 OF CHARACTER INFO
          DB      $00,$00                ; 8 DIFFERENT HEADS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00

          DB      $00,$00                ; HAT1
          DB      $00,$00                ; 2
          DB      $00,$00                ; 3
          DB      $00,$00                ; 4
          DB      $00,$00,$00,$00,$00,$00,$00,$00    ; HEADS
          DB      $00,$00                ; RUNNING WITH ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00     ; 64 BYTES

; START OF THE 3RD PAGE OF 8-HIGH MOVING INFO:
;   3RD PAGE OF CHUCK RIGHT ANIMATION

          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES


; START OF THE THIRD PAGE OF 16-HIGH FIXED INFO:

          DB      $00,$00,$00,$00
          DB      $00,$00,$00,$00        ; 3RD PAGE-- CHUCK LEFT
          DB      $00,$00,$00,$00
          DB      $00,$00,$00,$00
          DB      $0F,$C0                ; CONE
          DB      $0,$0,$0,$0,$0,$0    ; DISPERSING PEAS

; 3TH OF FIRST 8 PAGES (OF ZEROES) OF 8-HIGH FIXED CHARACTERS:

          DB      $05,$FF,$50            ; WATERMELON

          DB      $00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 64 BYTES

          DB      $FF,$FF,$FF            ; CLOSED
          DB      $EA,$AA,$AB            ; OPEN

          DB      $00,$00,$00,$00        ; NULL

          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00

          DB      $00,$00,$00,$00,$00,$00        ; CHUCK POINTING ARMS
          DB      $00,$00,$00,$00,$00,$00
          DB      $00,$02,$80,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00

          DB      $00,$00                ; WATERMELON SLICE

          DB      $00,$00,$00,$00        ; REJOICE
          DB      $00,$00,$00,$00

          ORG     $A300                  ; PAGE 4 OF CHARACTER INFO
          DB      $00,$00                ; 8 DIFFERENT HEADS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00

          DB      $00,$00                ; HAT1
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00    ; HEADS
          DB      $00,$00                ; RUNNING WITH ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00                ; RUNNING WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00   ; 64 BYTES

; START OF THE 4TH PAGE OF 8-HIGH MOVING INFO:
;   4TH PAGE OF CHUCK RIGHT ANIMATION:

          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES


; START OF THE FOURTH PAGE OF 16-HIGH FIXED INFO:

          DB      $00,$00,$00,$00
          DB      $00,$00,$00,$00        ; 4TH PAGE-- CHUCK LEFT
          DB      $00,$00,$00,$00
          DB      $00,$00,$00,$00
          DB      $0F,$C0                ; CONE
          DB      $0,$0,$0,$0,$0,$0    ; DISPERSING PEAS

; 4TH OF FIRST 8 PAGES (OF ZEROES) OF 8-HIGH FIXED CHARACTERS:

          DB      $17,$EF,$D4            ; WATERMELONG

          DB      $00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 64 BYTES

          DB      $3F,$FF,$FC            ; CLOSED
          DB      $3F,$FF,$FC            ; OPEN

          DB      $00,$00,$00,$00        ; NULL

          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00

          DB      $00,$00,$00,$00,$00,$00        ; CHUCK POINTING ARMS
          DB      $00,$00,$00,$00,$00,$04
          DB      $00,$02,$80,$10,$00,$00
          DB      $00,$00,$00,$00,$00,$00

          DB      $00,$00                ; WATERMELON SLICE

          DB      $00,$00,$00,$00        ; REJOICE
          DB      $00,$00,$00,$00

          ORG     $A400                  ; PAGE 5 OF CHARACTER INFO
          DB      $05,$50                ; 8 DIFFERENT HEADS
          DB      $05,$50
          DB      $05,$50
          DB      $05,$50
          DB      $05,$90
          DB      $05,$50
          DB      $05,$50
          DB      $05,$50

          DB      $00,$00                ; HAT1
          DB      $00,$00                ; 2
          DB      $00,$00                ; 3
          DB      $00,$00                ; 4
          DB      $00,$00,$00,$00,$00,$00,$00,$00     ; HEADS
          DB      $00,$00                ; RUNNING WITH ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00    ; 64 BYTES

; START OF THE 5TH PAGE OF 8-HIGH MOVING INFO:

          DB      $80,$00                ; CHUCK RIGHT
          DB      $00,$14
          DB      $05,$00
          DB      $80,$00
          DB      $00,$14
          DB      $05,$00
          DB      $00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES


; START OF THE 5TH PAGE OF 16-HIGH FIXED INFO:

          DB      $00,$00,$00,$00
          DB      $00,$02                ; CHUCK FEET LEFT
          DB      $14,$00
          DB      $00,$50
          DB      $00,$00
          DB      $14,$00
          DB      $00,$50
          DB      $3F,$F0                ; CONE
          DB      $0,$0,$0,$0,$0,$0    ; DISPERSING PEAS

; 5TH OF FIRST 8 PAGES (OF ZEROES) OF 8-HIGH FIXED CHARACTERS:

          DB      $1F,$FF,$F4            ; WATERMELON

          DB      $00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 64 BYTES
          DB      $00,$00,$00,$00,$00,$00                ; 70 BYTES

          DB      $00,$00,$00,$00        ; NULL

          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00

          DB      $00,$00,$00,$00,$00,$00        ; CHUCK POINTING ARMS
          DB      $00,$00,$00,$00,$00,$14
          DB      $00,$02,$80,$14,$00,$00
          DB      $00,$00,$00,$00,$00,$00

          DB      $00,$00                ; WATERMELON SLICE

          DB      $00,$00,$00,$00        ; REJOICE
          DB      $00,$00,$00,$00

          ORG     $A500                  ; PAGE 6 OF CHARACTER INFO
          DB      $15,$54                ; 8 DIFFERENT HEADS
          DB      $15,$54
          DB      $15,$54
          DB      $15,$94
          DB      $15,$54
          DB      $16,$54
          DB      $15,$54
          DB      $15,$54

          DB      $00,$00                ; HAT1
          DB      $00,$00                ; 2
          DB      $00,$00                ; 3
          DB      $00,$00                ; 4
          DB      $00,$00,$00,$00,$00,$00,$00,$00    ; HEAD
          DB      $00,$00                ; RUNNING WITH ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00      ; 64 BYTES

; START OF THE 6TH PAGE OF 8-HIGH MOVING INFO:

          DB      $40,$05
          DB      $00,$10
          DB      $04,$00
          DB      $40,$05
          DB      $00,$10
          DB      $00,$00
          DB      $00,$00                carried peas
          DB      $00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES


; START OF THE 6TH PAGE OF 16-HIGH FIXED INFO :

          DB      $00,$00,$00,$00
          DB      $50,$01                ; CHUCK FEET LEFT
          DB      $04,$00
          DB      $00,$10
          DB      $00,$02
          DB      $04,$00
          DB      $00,$00
          DB      $3F,$F0                ; CONE

          DB      $00,$00,$00,$00,00,$80        ; DISPERSING PEAS

; 6TH OF FIRST 8 PAGES (OF ZEROES) OF 8-HIGH FIXED CHARACTERS:

          DB      $1F,$FE,$F4            ; WATERMELON

          DB      $00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 64 BYTES
          DB      $00,$00,$00,$00,$00,$00                ; 70 BYTES

          DB      $00,$00,$00,$00        ; NULL

          DB      $80,$00                ; CHUCK RUNNING RIGHT
          DB      $00,$14
          DB      $05,$00
          DB      $80,$00
          DB      $00,$14
          DB      $05,$00

          DB      $00,$02                ; RUNNING LEFT
          DB      $14,$00
          DB      $00,$50
          DB      $00,$00
          DB      $14,$00
          DB      $00,$50

          DB      $00,$00

          DB      $00,$2A,$00,$00,$2A,$00        ; CHUCK POINTING ARMS
          DB      $00,$2A,$00,$00,$2A,$20
          DB      $00,$2A,$80,$08,$2A,$00
          DB      $00,$2A,$00,$00,$2A,$00

          DB      $00,$00                ; WATERMELON SLICE

          DB      $00,$00,$00,$00        ; REJOICE
          DB      $00,$00,$00,$00

          ORG     $A600                  ; PAGE 7 OF CHARACTER INFO
          DB      $15,$54                ; 8 DIFFERENT HEADS
          DB      $15,$54
          DB      $15,$64
          DB      $15,$54
          DB      $15,$54
          DB      $15,$54
          DB      $19,$54
          DB      $15,$5C

          DB      $3F,$C0                ; HAT1
          DB      $3F,$C0                ; 2
          DB      $3F,$C0                ; 3
          DB      $3F,$C0                ; 4
          DB      $00,$00,$00,$00,$00,$00,$00,$00   ; HEADS
          DB      $00,$00                ; RUNNING WITH ARSM
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00,$00
          DB      $00,$00,$00

          DB      $00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 64 BYTES

; START OF THE 7TH PAGE OF 8-HIGH MOVING INFO:
;   NOTE: FLYING BANANAS TAKE UP 10 PAGES, AND START IN THIS PAGE.

          DB      $70,$08
          DB      $00,$C0
          DB      $04,$40
          DB      $70,$08
          DB      $00,$00
          DB      $04,$00

          DB      $00,$00                carried peas
          DB      $00                    ; FIRST BANANA
          DB      $00,$00
          DB      $00,$00
          DB      $01,$80
          DB      $04,$00
          DB      $00,$00
          DB      $01
          DB      $10
          DB      $00
          DB      $00,$00,$00,$00        ; 32 BYTES

; START OF THE 7TH PAGE OF 16-HIGH FIXED INFO:

          DB      $00,$00,$00,$00
          DB      $20,$0D                ; CHUCK FEET LEFT
          DB      $03,$00
          DB      $01,$10
          DB      $50,$01
          DB      $00,$00
          DB      $00,$10
          DB      $3F,$F0                ; CONE

          DB      $00,$00,$02,$00,$00,$20        ; DISPERSING PEAS

; 7TH OF FIRST 8 PAGES (OF ZEROES) OF 8-HIGH FIXED CHARACTERS:

          DB      $7F,$FF,$FD            ; WATERMELON

          DB      $00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 64 BYTES
          DB      $00,$00,$00,$00,$00,$00                ; 70 BYTES

          DB      $00,$00,$00,$00        ; NULL

          DB      $40,$05                ; CHUCK RUNNING RIGHT
          DB      $00,$10
          DB      $04,$00
          DB      $40,$05
          DB      $00,$10
          DB      $00,$00

          DB      $50,$01                ; RUNNING LEFT
          DB      $04,$00
          DB      $00,$10
          DB      $00,$02
          DB      $04,$00
          DB      $00,$00

          DB      $00,$00

          DB      $00,$2A,$28,$00,$2A,$00        ; CHUCK POINTING ARMS
          DB      $00,$2A,$00,$00,$2A,$A0
          DB      $00,$2A,$80,$0A,$2A,$00
          DB      $00,$2A,$00,$00,$2A,$00

          DB      $00,$00                ; WATERMELON SLICE

          DB      $00,$00,$00,$00        ; REJOICE
          DB      $00,$F0,$03,$C0

          ORG     $A700                  ; PAGE 8 OF CHARACTER INFO
          DB      $55,$55                ; 8 DIFFERENT HEADS
          DB      $D5,$95
          DB      $F5,$55
          DB      $D5,$55
          DB      $59,$65
          DB      $55,$57
          DB      $55,$5F
          DB      $59,$57

          DB      $3F,$C0                ; HAT1
          DB      $3F,$C0                ; 2
          DB      $3F,$C0                ; 3
          DB      $EF,$C0                ; 4
          DB      $00,$00,$00,$00,$00,$00,$00,$00    ; HEADS
          DB      $3C,$00                ; RUNNING WITH ARMS
          DB      $F0,$F0
          DB      $03,$C0
          DB      $0F,$00
          DB      $3C,$00                ; WITHOUT ARMS
          DB      $F0,$F0
          DB      $03,$C0
          DB      $0F,$00

          DB      $0F,$00                ; WITH ARMS (LEFT)
          DB      $3C,$00
          DB      $F0,$F0
          DB      $03,$C0
          DB      $0F,$00                ; WITHOUT ARMS (LEFT)
          DB      $3C,$00
          DB      $F0,$F0
          DB      $03,$C0

; NOTE THAT THIS IS THE LAST PAGE OF THE 8-HIGH MOVING BLOCK WHICH CONTAINS
;         ZEROES.  THE FOLLOWING 8 PAGES WILL CONTAIN REAL, MEATY INFORMATION.
;   2ND PAGE OF FLYING BANANAS:

          DB      $24,$0C
          DB      $5C,$40
          DB      $0C,$40
          DB      $24,$0C
          DB      $5F,$40
          DB      $0F,$C0

          DB      $00,$00                carried peas
          DB      $00                    ; FIRST BANANA
          DB      $00,$00
          DB      $00,$00
          DB      $02,$40
          DB      $0C,$00
          DB      $00,$00
          DB      $02
          DB      $18
          DB      $00
          DB      $00,$00,$00,$00        ; 32 BYTES

; START OF 8TH PAGE OF 16-HIGH FIXED INFO:

          DB      $00,$00,$00,$00
          DB      $30,$18
          DB      $01,$35
          DB      $01,$30
          DB      $20,$0D
          DB      $01,$F5
          DB      $03,$F0
          DB      $FF,$FC                ; CONE

          DB      $00,$00,$00,$E0,$20,$02        ; DISPERSING PEAS

; 8TH OF FIRST 8 PAGES (OF ZEROES) OF 8-HIGH FIXED CHARACTERS:

          DB      $7F,$BF,$FD            ; WATERMELON

          DB      $00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 32 BYTES
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00       ; 64 BYTES
          DB      $00,$00,$00,$00,$00,$00                ; 70 BYTES

          DB      $00,$00,$00,$00        ; NULL

          DB      $70,$08                ; CHUCK RUNNING RIGHT
          DB      $00,$C0
          DB      $04,$40
          DB      $70,$08
          DB      $00,$00
          DB      $04,$00

          DB      $20,$0D                ; RUNNING LEFT
          DB      $03,$00
          DB      $01,$10
          DB      $50,$01
          DB      $00,$00
          DB      $00,$10

          DB      $00,$00

          DB      $02,$AA,$A8,$2A,$AA,$80        ; CHUCK POINTING ARMS
          DB      $2A,$AA,$A4,$0A,$AA,$80
          DB      $0A,$AA,$80,$02,$AA,$A0
          DB      $1A,$AA,$A0,$02,$AA,$A8

          DB      $00,$00                ; WATERMELON SLICE

          DB      $0F,$00,$3C,$3C        ; REJOICE
          DB      $0C,$C0,$03,$00

          ORG     $A800                  ; PAGE 9 OF CHARACTER INFO
          DB      $56,$55                ; 8 DIFFERENT HEADS
          DB      $D5,$55
          DB      $F5,$55
          DB      $D6,$59
          DB      $59,$65
          DB      $65,$97
          DB      $55,$5F
          DB      $55,$57

          DB      $3F,$C0                ; HAT1
          DB      $FF,$F0                ; 2
          DB      $FF,$F0                ; 3
          DB      $FF,$00                ; 4
          DB      $00,$00,$00,$00,$00,$00,$00,$00    ; HEADS
          DB      $30,$F0                ; RUNNING WITH ARMS
          DB      $C0,$C0
          DB      $33,$00
          DB      $0C,$00
          DB      $30,$F0                ;  WITHOUT ARMS
          DB      $C0,$C0
          DB      $33,$00
          DB      $0C,$00
          DB      $03,$00                ; WITH ARMS (LEFT)
          DB      $0C,$C0
          DB      $30,$30
          DB      $03,$C0
          DB      $03,$00                ; WITHOUT ARMS (LEFT)
          DB      $0C,$C0
          DB      $30,$30
          DB      $F0,$C0

; THIS IS THE FIRST PAGE OF THE REAL CHARACTER INFO BLOCK WHICH CONTAINS
;         INFORMATION ON CHARACTERS ONLY 8 HIGH.  THIS INCLUDES BOTH
;         MOVING AND FIXED 8-HIGH CHARACTERS.

          DB      $04,$04                ; CHUCK FEET RIGHT
          DB      $13,$C0
          DB      $04,$30
          DB      $04,$04
          DB      $13,$C0
          DB      $00,$F0

          DB      $00,$00                carried peas
          DB      $F4                    ; BANANAS (3RD PAGE)
          DB      $05,$00
          DB      $01,$F0
          DB      $07,$00
          DB      $0C,$00
          DB      $00,$00
          DB      $03
          DB      $0D
          DB      $00                    ; TOMATO
          DB      $00,$00,$00,$00,$00,$00    ; PIES
          DB      $00,$00                ; 36 BYTES

          DB      $10,$10                ; CHUCK FEET LEFT
          DB      $03,$C4
          DB      $0C,$10
          DB      $30,$18
          DB      $03,$C4
          DB      $0F,$00
          DB      $AA,$98                ; CONE

          DB      $00,$80,$0B,$80,$00,$80        ; DISPERSING PEAS

; START OF THE 1ST PAGE OF 8-HIGH FIXED INFO:

          DB      $7F,$FF,$BD            ; WATERMELON PILE            *** $78

          DB      $03,$D0,$03,$D0                    ; PILE OF 4 BANANAS * $7B
          DB      $03,$D0,$F4,$00        ; PILE OF 3 BANANAS          *** $7F
          DB      $03,$D0                ; PILE OF 2 BANANAS          *** $83
          DB      $F4,$00                ; PILE OF 1 BANANA           *** $85

; 40 BYTES BANANA PLUS 3 BYTES WATERMELON OF 8-HIGH FIXED UP TO THIS POINT.

          DB      $25,$89,$60            ; PILE OF 4 TOMATOES    *** $87
          DB      $25,$89,$60            ; PILE OF 3 TOMATOES    *** $8A
          DB      $25,$89,$60            ; PILE OF 2 TOMATOES    *** $8D
          DB      $25,$80,$00            ; PILE OF 1 TOMATO      *** $90

; PEA PILES SIZES 8-4 ARE 3 BYTES WIDE; SIZES 3-1 ARE 2 BYTES WIDE.

          DB      $B3,$B2,$E4            ; PILE OF 8 PEAS        *** $93
          DB      $B3,$B2,$E4            ; PILE OF 7 PEAS       *** $96
          DB      $B3,$B2,$E4            ; PILE OF 6 PEAS       *** $99
          DB      $2C,$EC,$B8            ; PILE OF 5 PEAS       *** $9C
          DB      $2C,$EC,$B0            ; PILE OF 4 PEAS       *** $9F
          DB      $CE,$CA                ; PILE OF 3 PEAS       *** $A2
          DB      $E2,$C8                ; PILE OF 2 PEAS       *** $A4
          DB      $3E,$E0                ; PILE OF 1 PEAS       *** $A6

; THE PIE PILES OF SIZES 4-1 ARE HERE.

          DB      $00,$3F,$03,$F0        ; PILE OF 4 PIES       *** $A8
          DB      $00,$3F,$03,$F0        ; PILE OF 3 PIES       *** $AC
          DB      $00,$3F,$03,$F0        ; PILE OF 2 PIES       *** $B0
          DB      $00,$3F,$00,$00        ; PILE OF 1 PIE        *** $B4

; INFORMATION FOR MANHOLES

          DB      $00,$00,$00        ; CLOSED              *** $B8
          DB      $00,$00,$00        ; OPEN                *** $BB

          DB      $00,$00,$00,$00        ; NULL

          DB      $24,$0C                ; CHUCK RUNNING RIGHT
          DB      $5C,$40
          DB      $0C,$40
          DB      $24,$0C
          DB      $5F,$40
          DB      $0F,$C0

          DB      $30,$18                ; RUNNING LEFT
          DB      $01,$35
          DB      $01,$30
          DB      $20,$0D
          DB      $01,$F5
          DB      $03,$F0

          DB      $00,$00


          DB      $0A,$AA,$8A,$AA,$AA,$A0        ; CHUCK POINTING ARMS
          DB      $AA,$AA,$A5,$2A,$AA,$00
          DB      $2A,$AA,$00,$00,$AA,$A8
          DB      $5A,$AA,$A8,$0A,$AA,$AA

          DB      $05,$00                ; WATERMELON SLICE

          DB      $0C,$3C,$30,$30        ; REJOICE
          DB      $30,$C0,$03,$3C

          ORG     $A900                  ; PAGE 10 OF CHARACTER INFO
          DB      $D5,$57                ; 8 DIFFERENT HEADS
          DB      $D5,$55
          DB      $F5,$55
          DB      $D6,$59
          DB      $55,$55
          DB      $65,$97
          DB      $55,$5F
          DB      $55,$57

          DB      $3F,$C0                ; HAT1
          DB      $FF,$F0                ; 2
          DB      $FF,$F0                ; 3
          DB      $3F,$F0                ; 4
          DB      $00,$00,$00,$00,$00,$00,$00,$00    ; HEADS
          DB      $33,$C0                ; RUNNING WITH ARMS
          DB      $C0,$C0
          DB      $C3,$00
          DB      $0C,$F0
          DB      $33,$C0                ; WITHOUT ARMS
          DB      $C0,$C0
          DB      $C3,$00
          DB      $0C,$F0
          DB      $F3,$00                ; WITH ARMS (LEFT)
          DB      $0C,$30
          DB      $30,$30
          DB      $3C,$C0
          DB      $F3,$00                ; WITHOUT ARMS
          DB      $0C,$30
          DB      $30,$30
          DB      $3C,$C0

; 2ND PAGE OF 8-HIGH CHARACTER INFO:

          DB      $00,$3C                ; CHUCK FEET RIGHT
          DB      $03,$00
          DB      $07,$30
          DB      $0F,$3C
          DB      $03,$00
          DB      $03,$D0

          DB      $00,$00                ; PEASE
          DB      $3D                    ; BANANAS  (4TH PAGE)
          DB      $3F,$80
          DB      $07,$C0
          DB      $0B,$00
          DB      $0D,$00
          DB      $80,$20
          DB      $07
          DB      $0E
          DB      $00                    ; TOMATO
          DB      $02,$80,$BC,$3E,$10,$10  ; PIES
          DB      $0F,$C0                ; UP/DOWN PIE   (36 BYTES)


          DB      $3C,$00                ; CHUCK FEET LEFT
          DB      $00,$C0
          DB      $0C,$D0
          DB      $10,$10
          DB      $00,$C0
          DB      $07,$C0
          DB      $A5,$54                ; CONE

          DB      $03,$C0,$08,$00,$00,$00        ; DISPERSING PEAS

; START OF THE 2ND PAGE OF 8-HIGH FIXED INFO:

          DB      $7F,$FF,$FD            ; WATERMELON

          DB      $00,$F4,$00,$F4        ; 4 BANANAS
          DB      $00,$F4,$3D,$00        ; 3
          DB      $00,$F4                ; 2
          DB      $3D,$00                ; 1

          DB      $15,$45,$50            ; TOMATO- 4
          DB      $15,$45,$50            ; 3
          DB      $15,$45,$50            ; 2
          DB      $15,$40,$00            ; 1

          DB      $E4,$DB,$10            ; PEAS- 8
          DB      $EC,$DB,$10            ; 7
          DB      $E4,$DB,$10            ; 6
          DB      $09,$36,$F0            ; 5
          DB      $09,$36,$C0            ; 4
          DB      $93,$6C                ; 3
          DB      $FE,$60                ; 2
          DB      $0B,$40                ; 1

          DB      $00,$3F,$03,$F0        ; PIES-- 4
          DB      $00,$3F,$03,$F0        ; 3
          DB      $00,$3F,$03,$F0        ; 2
          DB      $00,$3F,$00,$00        ; 1

          DB      $00,$00,$00        ; CLOSED
          DB      $00,$00,$00        ; OPEN

          DB      $00,$00,$00,$00        ; NULL

          DB      $04,$04                ; CHUCK RUNNING RIGHT
          DB      $13,$C0
          DB      $04,$30
          DB      $04,$04
          DB      $13,$C0
          DB      $00,$F0

          DB      $10,$10                ; RUNNING LEFT
          DB      $03,$C4
          DB      $0C,$10
          DB      $30,$18
          DB      $03,$C4
          DB      $0F,$00

          DB      $00,$00

          DB      $0A,$00,$02,$A0,$00,$28        ; CHUCK POINTING ARMS
          DB      $A0,$00,$00,$A0,$00,$00
          DB      $20,$00,$00,$00,$00,$0A
          DB      $00,$00,$2A,$28,$00,$0A

          DB      $1F,$40                ; WATERMELON SLICE

          DB      $0C,$F0,$30,$30        ; REJOICE
          DB      $3F,$F0,$0F,$F0

          ORG     $AA00                  ; PAGE 11 OF CHARACTER INFO
          DB      $D5,$57                ; 8 DIFFERENT HEADS
          DB      $D5,$55
          DB      $F5,$66
          DB      $D5,$55
          DB      $D5,$57
          DB      $55,$57
          DB      $99,$5F
          DB      $55,$57

          DB      $3F,$C0                ; HAT1
          DB      $FF,$F0                ; 2
          DB      $FF,$F0                ; 3
          DB      $03,$F0                ; 4
          DB      $00,$00,$00,$00,$00,$00,$00,$00    ; HEADS
          DB      $3F,$C0                ; RUNNING WITH ARMS
          DB      $3F,$C0
          DB      $FF,$C0
          DB      $3F,$C0
          DB      $3F,$C0                ; WITHOUT ARMS
          DB      $3F,$C0
          DB      $FF,$C0
          DB      $3F,$C0
          DB      $3F,$C0                ; WITH ARMS (LEFT)
          DB      $3F,$F0
          DB      $3F,$C0
          DB      $3F,$C0
          DB      $3F,$C0                ; WITHOUT ARMS
          DB      $3F,$F0
          DB      $3F,$C0
          DB      $3F,$C0

; 3RD PAGE OF REAL 8-HIGH INFO:

          DB      $0F,$D0                ; CHUCK FEET RIGHT
          DB      $0F,$40
          DB      $0F,$C0
          DB      $0F,$F0
          DB      $0F,$40
          DB      $0F,$C0

          DB      $00,$00                ; PEAS
          DB      $0E                    ; BANANAS (5TH PAGE)
          DB      $7F,$D0
          DB      $0B,$00
          DB      $0E,$00
          DB      $0E,$00
          DB      $E0,$B0
          DB      $0B
          DB      $0B
          DB      $96                    ; TOMATO
          DB      $0A,$A0,$9F,$F6,$D4,$9C    ; PIES
          DB      $0F,$C0                ; UP/DOWN PIE   (36 BYTES)

          DB      $07,$F0                ; CHUCK FEET LEFT
          DB      $01,$F0
          DB      $03,$F0
          DB      $3C,$F0
          DB      $01,$F0
          DB      $03,$F0
          DB      $AA,$58                ; CONE

          DB      $01,$10,$03,$80,$00,$08        ; DISPERSING PEAS

; START OF 3RD PAGE OF 8-HIGH FIXED INFO:

          DB      $00,$00,$00            ; WATERMELON

          DB      $F4,$38,$F4,$38                        ; 4 BANANAS
          DB      $F4,$38,$0E,$00                        ; 3
          DB      $F4,$38                                ; 2
          DB      $0E,$00                                ; 1

          DB      $17,$45,$D0            ; TOMATOES-- 4
          DB      $17,$45,$D0            ; 3
          DB      $17,$45,$D0            ; 2
          DB      $17,$40,$00            ; 1

          DB      $3F,$C9,$E0            ; PEA PILES-- 8
          DB      $3E,$C9,$E0            ; 7
          DB      $3E,$C9,$C0            ; 6
          DB      $0F,$B2,$40            ; 5
          DB      $03,$B2,$40            ; 4
          DB      $FB,$E0                ; 3
          DB      $38,$C0                ; 2
          DB      $0E,$00                ; 1 (LAST PAGE OF REAL STUFF)

          DB      $00,$55,$45,$54        ; PIES-- 4
          DB      $00,$55,$45,$54        ; 3
          DB      $00,$55,$45,$54        ; 2
          DB      $00,$55,$40,$00        ; 1

          DB      $00,$00,$00        ; CLOSED
          DB      $00,$00,$00        ; OPEN

          DB      $00,$00,$00,$00        ; NULL

          DB      $00,$3C                ; CHUCK RUNNING RIGHT
          DB      $03,$00
          DB      $07,$30
          DB      $0F,$3C
          DB      $03,$00
          DB      $03,$D0

          DB      $3C,$00                ; RUNNING LEFT
          DB      $00,$C0
          DB      $0C,$D0
          DB      $10,$10
          DB      $00,$C0
          DB      $07,$C0

          DB      $00,$00

          DB      $0A,$00,$01,$80,$00,$08        ; CHUCK POINTING ARMS
          DB      $80,$00,$00,$80,$00,$00
          DB      $20,$00,$00,$00,$00,$02
          DB      $00,$00,$0A,$20,$00,$02

          DB      $7B,$D0                ; WATERMELON SLICE

          DB      $0F,$F0,$0F,$F0        ; REJOICE
          DB      $0F,$FC,$3F,$FC

          ORG     $AB00                  ; PAGE 12 OF CHARACTERS
          DB      $D5,$57                ; 8 DIFFERENT HEADS
          DB      $F6,$59
          DB      $FD,$66
          DB      $F5,$55
          DB      $D5,$57
          DB      $55,$5F
          DB      $99,$7F
          DB      $65,$9F

          DB      $3F,$C0                ; HAT1
          DB      $FF,$F0                ; 2
          DB      $3F,$C0                ; 3
          DB      $00,$00                ; 4
          DB      $55,$55,$55,$55,$55,$55,$55,$55     ; HEADS
          DB      $FF,$C0                ; RUNNING WITH ARMS
          DB      $3F,$C0
          DB      $3F,$C0
          DB      $FF,$C0
          DB      $3F,$C0                ; WITHOUT ARMS
          DB      $3F,$C0
          DB      $3F,$C0
          DB      $3F,$C0
          DB      $3F,$F0                ; WITH ARMS (LEFT)
          DB      $3F,$C0
          DB      $3F,$C0
          DB      $3F,$F0
          DB      $3F,$C0                ; WITHOUT ARMS
          DB      $3F,$C0
          DB      $3F,$C0
          DB      $3F,$C0

; 4TH PAGE OF REAL 8-HIGH INFO:

          DB      $0F,$C0                ; CHUCK FEET RIGHT
          DB      $0F,$C0
          DB      $0F,$C0
          DB      $0F,$C0
          DB      $0F,$C0
          DB      $0F,$C0

          DB      $3E,$E0                ; PEAS
          DB      $0B                    ; BANANAS (6TH PAGE)
          DB      $E0,$B0
          DB      $0E,$00
          DB      $0B,$00
          DB      $0B,$00
          DB      $7F,$D0
          DB      $0E
          DB      $0E
          DB      $55                    ; TOMATO
          DB      $27,$D8,$1F,$F4,$D4,$5C      ; PIES
          DB      $15,$50                ; UP/DOWN PIE

          DB      $03,$F0                ; CHUCK FEET LEFT
          DB      $03,$F0
          DB      $03,$F0
          DB      $0F,$F0
          DB      $03,$F0
          DB      $03,$F0
          DB      $29,$50                ; CONE

          DB      $08,$40,$00,$20,$88,$00        ; DISPERSING PEAS

; START OF THE 4TH PAGE OF 8-HIGH FIXED INFO:

          DB      $00,$00,$00            ; WATERMELON

          DB      $3E,$2C,$3E,$2C                        ; 4 BANANAS
          DB      $3E,$2C,$0B,$00                        ; 3
          DB      $3E,$2C                                ; 2
          DB      $0B,$00                                ; 1

          DB      $0A,$02,$80            ; 4 TOMATOES
          DB      $0A,$02,$80            ; 3
          DB      $0A,$02,$80            ; 2 (LAST PAGE OF 2 TOMATOES)
          DB      $0A,$00,$00            ; 1 (LAST PAGE OF 1 TOMATO)

          DB      $2B,$B4,$80            ; PEAS-- 8
          DB      $0B,$F4,$80            ; 7
          DB      $0B,$B4,$00            ; 6
          DB      $02,$ED,$80            ; 5
          DB      $02,$ED,$00            ; 4
          DB      $22,$C0                ; 3 (LAST PAGE OF 3 PEAS)
          DB      $0A,$00                ; 2 (LAST PAGE OF 2 PEAS)
          DB      $00,$00                ; 1

          DB      $00,$15,$01,$50        ; PIES-- 4
          DB      $00,$15,$01,$50        ; 3
          DB      $00,$15,$01,$50        ; 2
          DB      $00,$15,$00,$00        ; 1

          DB      $00,$00,$00        ; CLOSED
          DB      $00,$00,$00        ; OPEN

          DB      $00,$00,$00,$00        ; NULL

          DB      $0F,$D0                ; CHUCK RUNNING RIGHT
          DB      $0F,$40
          DB      $0F,$C0
          DB      $0F,$F0
          DB      $0F,$40
          DB      $0F,$C0

          DB      $07,$F0                ; RUNNING LEFT
          DB      $01,$F0
          DB      $03,$F0
          DB      $3C,$F0
          DB      $01,$F0
          DB      $03,$F0

          DB      $00,$00

          DB      $0A,$00,$00,$40,$00,$05        ; CHUCK POINTING ARMS
          DB      $80,$00,$00,$80,$00,$00
          DB      $20,$00,$00,$00,$00,$02
          DB      $00,$00,$02,$50,$00,$01

          DB      $FF,$D0                ; WATERMELON SLICE

          DB      $3F,$FC,$3F,$FC        ; REJOICE
          DB      $F0,$0F,$F0,$0F

          ORG     $AC00                  ; PAGE 13 OF CHARACTERS
          DB      $D9,$67                ; 8 DIFFERENT HEADS
          DB      $F6,$59
          DB      $FD,$55
          DB      $F5,$55
          DB      $FF,$FF
          DB      $55,$5F
          DB      $55,$7F
          DB      $65,$9F

          DB      $3F,$C0                ; HAT1
          DB      $FF,$F0                ; 2
          DB      $00,$00                ; 3
          DB      $00,$00                ; 4
          DB      $14,$45,$91,$A4,$69,$1A,$46,$51    ; HEADS
          DB      $C0,$00                ; RUNNING WITH ARMS
          DB      $C0,$00
          DB      $C0,$00
          DB      $C0,$00
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$30                ; WITH ARMS (LEFT)
          DB      $00,$30
          DB      $00,$30
          DB      $00,$30
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00

; THE 5TH PAGE OF REAL 8-HIGH INFO:

          DB      $4A,$80                ; CHUCK FEET RIGHT
          DB      $0A,$80
          DB      $0A,$80
          DB      $4A,$80
          DB      $0A,$00
          DB      $0A,$80

          DB      $0B,$40                ; PEAS
          DB      $07                    ; BANANA (7TH PAGE)
          DB      $80,$20
          DB      $0D,$00
          DB      $07,$00
          DB      $07,$C0
          DB      $3F,$80
          DB      $7D
          DB      $0D
          DB      $5D                    ; TOMATO
          DB      $1F,$F4,$27,$D8,$D4,$5C    ; PIES
          DB      $05,$40                ; UP/DOWN PIE   (36 BYTES)

          DB      $02,$A1                ; CHUCK FEET LEFT
          DB      $02,$A0
          DB      $02,$A0
          DB      $03,$F0
          DB      $00,$A0
          DB      $02,$A0
          DB      $29,$50                ; CONE

          DB      $03,$80,$08,$C0,$00,$00        ; DISPERSING PEAS

; START OF THE 5TH PAGE OF 8-HIGH FIXED INFO:

          DB      $00,$00,$00            ; WATERMELON
          DB      $0F,$5C,$0F,$5C                        ; 4 BANANAS
          DB      $0F,$5C,$07,$00                        ; 3
          DB      $0F,$5C                                ; 2
          DB      $07,$00                                ; 1

          DB      $25,$89,$60            ; 4 TOMATOES
          DB      $00,$09,$60            ; 3
          DB      $00,$00,$00            ; 2
          DB      $00,$00,$00            ; 1

          DB      $0A,$1F,$00            ; 8 PEAS
          DB      $02,$1F,$00            ; 7
          DB      $02,$1F,$00            ; 6
          DB      $00,$C7,$00            ; 5
          DB      $00,$E7,$00            ; 4 (LAST PAGE OF 4 PEAS)
          DB      $00,$00                ; 3
          DB      $00,$00                ; 2
          DB      $00,$00                ; 1

          DB      $00,$3F,$03,$F0        ; PIES-- 4
          DB      $00,$3F,$00,$00        ; 3
          DB      $00,$00,$00,$00        ; 2
          DB      $00,$00,$00,$00        ; 1

          DB      $00,$00,$00        ; CLOSED
          DB      $00,$00,$00        ; OPEN

          DB      $00,$00,$00,$00        ; NULL

          DB      $0F,$C0                ; CHUCK RUNNING RIGHT
          DB      $0F,$C0
          DB      $0F,$C0
          DB      $0F,$C0
          DB      $0F,$C0
          DB      $0F,$C0

          DB      $03,$F0                ; RUNNING LEFT
          DB      $03,$F0
          DB      $03,$F0
          DB      $0F,$F0
          DB      $03,$F0
          DB      $03,$F0

          DB      $00,$00

          DB      $0A,$00,$00,$00,$00,$01        ; CHUCK POINTING ARMS
          DB      $40,$00,$00,$40,$00,$00
          DB      $14,$00,$00,$00,$00,$01
          DB      $00,$00,$01,$40,$00,$00

          DB      $FE,$C0                ; WATERMELON SLICE

          DB      $F0,$0F,$F0,$0F        ; REJOICE
          DB      $C0,$03,$C0,$03

          ORG     $AD00                  ; PAGE 14 OF CHARACTER INFO
          DB      $39,$6C                ; 8 DIFFERENT HEADS
          DB      $35,$54
          DB      $3D,$54
          DB      $3F,$FC
          DB      $3F,$FC
          DB      $3F,$FC
          DB      $15,$7C
          DB      $15,$5C

          DB      $3F,$C0                ; HAT1
          DB      $FF,$F0                ; 2
          DB      $00,$00                ; 3
          DB      $00,$00                ; 4
          DB      $41,$50,$94,$A5,$AA,$5A,$16,$05   ; HEADS
          DB      $C0,$00                ; RUNNING WITH ARMS
          DB      $C0,$00
          DB      $C0,$00
          DB      $C0,$00
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$30                ; WITH ARMS
          DB      $00,$30
          DB      $00,$30
          DB      $00,$30
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00

; THE 6TH PAGE OF REAL 8-HIGH INFO:

          DB      $8A,$80                ; CHUCK FEET RIGHT
          DB      $09,$8C
          DB      $0A,$40
          DB      $8A,$00
          DB      $0A,$A4
          DB      $09,$80

          DB      $0E,$00                ; PEA
          DB      $03                    ; BANANAS (8TH PAGE)
          DB      $00,$00
          DB      $0C,$00
          DB      $02,$40
          DB      $01,$F0
          DB      $05,$00
          DB      $F4
          DB      $1C
          DB      $28                    ; TOMATO
          DB      $9F,$F6,$0A,$A0,$D4,$9C   ; PIES
          DB      $00,$00                ; 36 BYTES

          DB      $02,$A2                ; CHUCK FEET LEFT
          DB      $32,$60
          DB      $01,$A0
          DB      $02,$A1
          DB      $1A,$A0
          DB      $02,$60
          DB      $29,$60                ; 14TH CONE PAGE

          DB      $00,$30,$00,$08,$00,$20        ; DISPERSING PEAS

; START OF THE 8-HIGH FIXED INFO:

          DB      $00,$00,$00            ; WATERMELON
          DB      $03,$8C,$03,$8C                        ; 4 BANANAS
          DB      $03,$8C,$03,$00                        ; 3
          DB      $03,$8C                                ; 2
          DB      $03,$00                                ; 1

          DB      $15,$45,$50            ; 4 TOMATOES
          DB      $00,$05,$50            ; 3
          DB      $00,$00,$00            ; 2
          DB      $00,$00,$00            ; 1

          DB      $02,$C5,$00            ; 8 PEAS
          DB      $00,$C7,$00            ; 7
          DB      $00,$84,$00            ; 6 (LAST PAGE OF 6)
          DB      $00,$20,$00            ; 5
          DB      $00,$00,$00            ; 4
          DB      $00,$00                ; 3
          DB      $00,$00                ; 2
          DB      $00,$00                ; 1

          DB      $00,$3F,$03,$F0        ; 4 PIES
          DB      $00,$3F,$00,$00        ; 3 PIES
          DB      $00,$00,$00,$00        ; 2 PIES
          DB      $00,$00,$00,$00        ; 1 PIE

          DB      $00,$00,$00        ; CLOSED
          DB      $00,$00,$00        ; OPEN

          DB      $00,$00,$00,$00        ; NULL

          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00

          DB      $0A,$00,$00,$00,$00,$00        ; CHUCK POINTING ARMS
          DB      $00,$00,$00,$00,$00,$00
          DB      $04,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00

          DB      $3F,$C0                ; WATERMELON SLICE

          DB      $C0,$03,$C0,$03        ; REJOICE
          DB      $C0,$03,$C0,$03

          ORG     $AE00                  ; PAGE 15 OF CHARACTER INFO
          DB      $35,$5C                ; 8 DIFFERENT HEADS
          DB      $3F,$FC
          DB      $3F,$D4
          DB      $3F,$FC
          DB      $3F,$FC
          DB      $3F,$FC
          DB      $17,$FC
          DB      $3F,$FC

          DB      $3F,$C0                ; HAT1
          DB      $3F,$C0                ; 2
          DB      $00,$00                ; 3
          DB      $00,$00                ; 4
          DB      $55,$55,$A5,$A9,$AA,$6A,$5A,$55    ; HEADS
          DB      $C0,$00                ; RUNNING WITH ARMS
          DB      $C0,$00
          DB      $C0,$00
          DB      $C0,$00
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$30                ; WITH ARMS
          DB      $00,$30
          DB      $00,$30
          DB      $00,$30
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00

; 7TH PAGE OF REAL 8-HIGH MOVING INFO:

          DB      $AA,$88                ; CHUCK FEET RIGHT
          DB      $2A,$80
          DB      $0A,$80
          DB      $2A,$A8
          DB      $0A,$80
          DB      $2A,$80

          DB      $00,$00                ; PEAS
          DB      $01                    ; BANANAS ( 9TH PAGE)
          DB      $00,$00
          DB      $04,$00
          DB      $00,$40
          DB      $00,$00
          DB      $00,$00
          DB      $00
          DB      $20
          DB      $00                    ; TOMATO
          DB      $BC,$3E,$02,$80,$10,$10    ; PIES
          DB      $00,$00                ; 36 BYTES

          DB      $22,$AA                ; CHUCK FEET LEFT
          DB      $02,$A8
          DB      $02,$A0
          DB      $00,$A2
          DB      $02,$A0
          DB      $02,$A8
          DB      $0A,$80                ; PAGE 15 OF CONE

          DB      $00,$00,$00,$80,$00,$02        ; DISPERSING PEAS

; START OF THE 8-HIGH FIXED INFO:

          DB      $00,$00,$00            ; WATERMELON

          DB      $02,$C4,$02,$C4                        ; 4 BANANAS
          DB      $02,$C4,$01,$00                        ; 3
          DB      $02,$C4                                ; 2
          DB      $01,$00                                ; 1

          DB      $17,$45,$D0            ; 4 TOMATOES (LAST PAGE)
          DB      $00,$05,$D0            ; 3
          DB      $00,$00,$00            ; 2
          DB      $00,$00,$00            ; 1

          DB      $00,$E4,$00            ; 8 PEAS
          DB      $00,$3C,$00            ; 7
          DB      $00,$00,$00            ; 6
          DB      $00,$00,$00            ; 5
          DB      $00,$00,$00            ; 4
          DB      $00,$00                ; 3
          DB      $00,$00                ; 2
          DB      $00,$00                ; 1

          DB      $00,$55,$45,$54        ; 4 PIES
          DB      $00,$55,$40,$00        ; 3
          DB      $00,$00,$00,$00        ; 2
          DB      $00,$00,$00,$00        ; 1

          DB      $00,$00,$00        ; CLOSED
          DB      $00,$00,$00        ; OPEN

          DB      $00,$00,$00,$00        ; NULL

          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00

          DB      $0A,$00,$00,$00,$00,$00        ; CHUCK POINTING ARMS
          DB      $00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00

          DB      $3F,$00                ; WATERMELON SLICE

          DB      $C0,$03,$C0,$03        ; REJOICE
          DB      $C0,$03,$C0,$03

          ORG     $AF00                  ; PAGE 16 OF CHARACTER INFO
                                         ; (TOP SCAN LINES OF EACH CHAR)
          DB      $0F,$F0                ; 8 DIFFERENT HEADS
          DB      $0F,$F0
          DB      $0F,$F0
          DB      $0F,$F0
          DB      $0F,$F0
          DB      $0F,$F0
          DB      $0F,$F0
          DB      $0F,$F0

          DB      $3F,$C0                ; HAT1
          DB      $00,$00                ; 2
          DB      $00,$00                ; 3
          DB      $00,$00                ; 4
          DB      $14,$45,$A4,$A9,$AA,$6A,$1A,$51    ; HEADSS
          DB      $C0,$00                ; RUNNING WITH ARMS
          DB      $C0,$00
          DB      $C0,$00
          DB      $C0,$00
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$30                ; WITH ARMS
          DB      $00,$30
          DB      $00,$30
          DB      $00,$30
          DB      $00,$00                ; WITHOUT ARMS
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00

; THIS IS THE 8TH PAGE OF REAL 8-HIGH INFO, AND THE 16TH PAGE OF
;         CHARACTER INFO OVERALL

          DB      $2A,$83                ; CHUCK FEET RIGHT
          DB      $0A,$80
          DB      $0A,$80
          DB      $0A,$83
          DB      $0A,$80
          DB      $0A,$80

          DB      $00,$00                ; PEAS
          DB      $01                    ; BANANAS (10TH PAGE)
          DB      $00,$00
          DB      $04,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00,$00
          DB      $00
          DB      $00
          DB      $00                    ; TOMATO
          DB      $0,$0,$0,$0,$0,$0      ; PIES
          DB      $00,$00                ; 36 BYTES

          DB      $C2,$A8                ; CHUCK FEET LEFT
          DB      $02,$A0
          DB      $02,$A0
          DB      $2A,$A8
          DB      $02,$A0
          DB      $02,$A0
          DB      $00,$00                ; CONE

          DB      $00,$00,$00,$00,$08,$00        ; DISPERSING PEAS

; LAST PAGE OF 8-HIGH FIXED CHARACTERS:

          DB      $00,$00,$00            ; WATERMELON

          DB      $00,$44,$00,$44                        ; 4 BANANAS
          DB      $00,$44,$01,$00                        ; 3
          DB      $00,$44                                ; 2
          DB      $01,$00                                ; 1

          DB      $0A,$02,$80            ; 4 TOMATOES
          DB      $00,$02,$80            ; 3
          DB      $00,$00,$00            ; 2
          DB      $00,$00,$00            ; 1

          DB      $00,$20,$00            ; 8 PEAS
          DB      $00,$00,$00            ; 7
          DB      $00,$00,$00            ; 6
          DB      $00,$00,$00            ; 5
          DB      $00,$00,$00            ; 4
          DB      $00,$00                ; 3
          DB      $00,$00                ; 2
          DB      $00,$00                ; 1

          DB      $00,$15,$01,$50        ; 4 PIES
          DB      $00,$15,$00,$00        ; 3
          DB      $00,$00,$00,$00        ; 2
          DB      $00,$00,$00,$00        ; 1

          DB      $00,$00,$00        ; CLOSED
          DB      $00,$00,$00        ; OPEN

          DB      $00,$00,$00,$00        ; NULL

          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00,$00,$00
          DB      $00,$00

          DB      $05,$00,$00,$00,$00,$00        ; CHUCK POINTING ARMS
          DB      $00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00
          DB      $00,$00,$00,$00,$00,$00

          DB      $0C,$00                ; WATERMELON SLICE

          DB      $C0,$03,$C0,$03        ; REJOICE
          DB      $C0,$03,$C0,$03

          END
