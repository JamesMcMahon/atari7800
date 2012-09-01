; WALLDRAW.S
; THIS FILE CONTAINS THE ROUTINE WHICH PUTS UP THE WALL AT GAME STARTUP.
;
          GLBL    AWOLDRAW

          GLBL    DLIST10,DLIST0
          GLBL    ULCORNER,URCORNER,LLCORNER,LRCORNER,LWALL,RWALL,WHORIZ
          GLBL    CORNPALW,WALLPALW,SIDEPALW,XRIGHT,XLEFT,TOPWHGH,BOTWHGH
          GLBL    BLOCK2
          GLBL    LISTTABL,LISTTABH

          RAMDEF

          RSEG    CODE3

AWOLDRAW
          LDA     #L(DLIST10)            ; TOP WALL IN DLIST10
          STA     LISTPTR
          LDA     #H(DLIST10)
          STA     LISTPTR+1

          LDY     #0                     ; DISPLAY UPPER RIGHT CORNER
          LDA     #ULCORNER
          STA     (LISTPTR),Y
          INY
          LDA     #CORNPALW
          STA     (LISTPTR),Y
          INY
          LDA     #BLOCK2
          STA     (LISTPTR),Y
          INY
          LDA     #XLEFT
          STA     (LISTPTR),Y
          INY

          LDA     #TOPWHGH              ; HIGH BYTE FOR TOP WALL
          STA     TEMP3

          JSR     DOVERT                 ; DRAWS THE TOP WALL

; REGISTER Y IS ALREADY SET TO POINT TO THE 5TH HEADER, WHICH WILL BE URCORNER.

          LDA     #URCORNER
          STA     (LISTPTR),Y
          INY
          LDA     #CORNPALW
          STA     (LISTPTR),Y
          INY
          LDA     #BLOCK2
          STA     (LISTPTR),Y
          INY
          LDA     #XRIGHT-8
          STA     (LISTPTR),Y
          INY

          STY     LISTSTRT+10           ; EVERYBODY ELSE STARTS HERE

; NOW FOR THE SIDE WALLS: FOR EACH DLIST, 9 THROUGH 1, PUT A VERTICAL
;         WALL STAMP ON THE RIGHT AND THE LEFT.

          LDX     #9
ZWALL01   LDA     LISTTABL,X
          STA     LISTPTR
          LDA     LISTTABH,X
          STA     LISTPTR+1              ; SET DLIST POINTER

          LDY     #0
          LDA     #LWALL
          STA     (LISTPTR),Y
          INY
          LDA     #SIDEPALW
          STA     (LISTPTR),Y
          INY
          LDA     #BLOCK2
          STA     (LISTPTR),Y
          INY
          LDA     #XLEFT
          STA     (LISTPTR),Y
          INY

; NOW FOR THE RIGHT SIDE:

          LDA     #RWALL
          STA     (LISTPTR),Y
          INY
          LDA     #SIDEPALW
          STA     (LISTPTR),Y
          INY
          LDA     #BLOCK2
          STA     (LISTPTR),Y
          INY
          LDA     #XRIGHT-4
          STA     (LISTPTR),Y
          INY

          STY     LISTSTRT,X
          DEX
          TXA
          BNE     ZWALL01

; NOW, DO THE LAST ZONE, ZONE 0, WITH THE LLCORNER, LRCORNER, AND THE BOTTOM
;         WALL.

          LDA     #L(DLIST0)
          STA     LISTPTR
          LDA     #H(DLIST0)
          STA     LISTPTR+1

          LDY     #0
          LDA     #LLCORNER
          STA     (LISTPTR),Y
          INY
          LDA     #CORNPALW
          STA     (LISTPTR),Y
          INY
          LDA     #BLOCK2
          STA     (LISTPTR),Y
          INY
          LDA     #XLEFT
          STA     (LISTPTR),Y
          INY

          LDA     #BOTWHGH
          STA     TEMP3                  ; IF BOTTOM WALL, HIGH BYTE IS
                                         ;  "BOTWHGH"
          JSR     DOVERT

; NOW DO THE LAST CORNER, THE LOWER RIGHT CORNER.

          LDA     #LRCORNER
          STA     (LISTPTR),Y
          INY
          LDA     #CORNPALW
          STA     (LISTPTR),Y
          INY
          LDA     #BLOCK2
          STA     (LISTPTR),Y
          INY
          LDA     #XRIGHT-8
          STA     (LISTPTR),Y
          INY

          STY     LISTSTRT

          RTS                            ; END OF WALL DRAWING ROUTINE

; THIS SUBROUTINE DRAWS THE TOP AND BOTTOM WALLS.  IT REQUIRES THAT
;         REGISTER Y POINT TO THE NEXT HEADER, AND THAT LISTPTR BE SET.

DOVERT    LDX     #2
ZWALL00   LDA     #WHORIZ                ; LOW BYTE OF STAMP
          STA     (LISTPTR),Y
          INY
          LDA     #WALLPALW
          STA     (LISTPTR),Y
          INY

          LDA     TEMP3                  ; CONTAINS THE HIGH BYTE VALUE
          STA     (LISTPTR),Y
          INY
                                         ; SKIP HPOS BYTE
          INY
          DEX
          BPL     ZWALL00

; NOW TOUCH UP THOSE HEADERS (HPOS MUST CHANGE; WIDTH OF LAST MUST CHANGE)

          STY     TEMPY                  ; SAVE DLIST INDEX

          LDA     #8                     ; HPOS OF FIRST WALL
          LDY     #7
          STA     (LISTPTR),Y
          LDA     #72                    ; HPOS-- 8 + 64
          LDY     #11
          STA     (LISTPTR),Y
          LDA     #136                   ; HPOS-- 8 + 64 + 64
          LDY     #15
          STA     (LISTPTR),Y
          LDA     #1C                    ; PALW FOR LAST HEADER (WIDTH = 4)
          LDY     #13
          STA     (LISTPTR),Y

          LDY     TEMPY                  ; RESTORE DLIST INDEX

          RTS
          END
