*******   SGNDOBJ.S    THE AMAZING SPHINX
* THIS FILE CONTAINS THE CODE THAT ANIMATES AND CONTROLS THE BIG SPHINX, THE
* MINI SPHINXES, AND THE FIRE POTS.


	org	$B000


MINIINIT: LDY     #MININUMB-1            ; CALLED WITH SLOT NUMBER IN X
MINILP:   LDA     MINITBL,Y
          BMI     MINIFND
          DEY
          BPL     MINILP
          RTS                            ; IGNORE IF NO SLOT AVAILABLE

MINIFND:  TXA                            ; X IS THE LOADER TABLE SLOT NUMBER
          STA     MINITBL,Y
          LDA     #0                     ; ALIVE STATE
          STA     XTBL,X                 ; THIS IS WHERE MINISTATE IS KEPT NOW
          RTS

KAMINIS:  LDY     #MININUMB-1            ; KILL ALL MINIS
KAMINILP: LDX     MINITBL,Y
          BMI     KNMINI                 ; THIS ONES DEAD
          JSR     MINIKILL
KNMINI:   DEY
          BPL     KAMINILP
          RTS

MINIKILL: LDA     XTBL,X
          BNE     MINIDEAD               ; MINI IS ALREADY DYING OR DEAD
          LDA     #1
          STA     XTBL,X                 ; SET MINI STATE TO START EXPLOSION
          LDA     #MINIBM                ;THE BIG BANG
          JSR     TUNIN
          LDA     #$10
          STA     HUNDS
          JSR     ADDSCORE
MINIDEAD: RTS

; ANIMATE MINI SPHINX EXPLOSION IF NECESSARY - CONTROLLED BY MINISTAT
;
;                 0                      ; STILL ALIVE
;                 1                      ; START EXPLOSION
MXREM     EQU     2                      ; REMOVE OVERLAY
MXREP     EQU     4                      ; REPLACE OVERLAY
MXLOW     EQU     15                     ; LOWER OVERLAY AND REMOVE HEAD
MXDONE    EQU     21                     ; EXPLOSION IS OVER

; XTBL IS USED TO STORE THE MINI STATE SO THAT IT CAN EASILY BE SET TO ONE
; TO INITIATE THE EXPLOSION WHEN A COLISION IS DETECTED

DOMINIS:  LDY     #MININUMB-1
DOMINILP: LDA     MINITBL,Y
          BMI     DOMINIDN               ; NO MINI HERE
          TAX
          LDA     VPTBL,X
          CMP     #SCRENBOT+1
          BNE     DOMINI1
          LDA     #$FF
          STA     MINITBL,Y
DOMINIDN: DEY
          BPL     DOMINILP
          RTS

DOMSHOTS: LDA     SPHXSHTD
          BNE     MINIDONE

          LDA     COLX1,X                ;THE OFFSETS NEED ADJUSTING
          CLC
          ADC     #3                     ;FUDGE FACTOR
          STA     TEMP2                  ; X POS FOR LAUNCHER
          SEC
          SBC     XTBL+ZBIRD
          CMP     #$F8                   ;LAUNCH SHOT WHEN BIRD IS IN FRONT
          BCS     ENOGINIM               ;OF MINI SPHINX (FOR NOW)
          CMP     #8
          BCS     MINIDONE

ENOGINIM: LDA     VPTBL,X                ; MINI SPHINX MUST BE ON THE SCREEN
          CMP     #SCRENBOT-25
          BCS     MINIDONE

          LDA     HPTBL,X
          CMP     #15
          BCC     MINIDONE
          CMP     #145
          BCS     MINIDONE

          LDA     #0
          STA     TEMP0                  ;TEMP0 = 0 MEANS MINI SPHINX
          LDA     #15                    ; Y POS
          STA     TEMP7
          LDA     COLZ1,X
          SEC
          SBC     #1                     ; PREVENT SUICIDE
          STA     TEMP9
          JSR     LAUNCHER

MINIDONE: LDY     TEMP1
          JMP     DOMINIDN

DOMINI1:  STY     TEMP1
          LDA     XTBL,X                 ; THIS IS THE MINI STATE
          BEQ     DOMSHOTS               ; THE MINI IS ALIVE
RBOOR:    CMP     #MXDONE                ; THE MINI IS DEAD OR DYING
          BEQ     MINIDONE               ; ALREADY DEAD
          INC     XTBL,X                 ; NEXT STATE NEXT TIME
          STX     TEMP0
          CMP     #1
          BEQ     MEXPINIT               ; START THE EXPLOSION UP

          LDX     TEMP1                  ; OTHERWISE CONTINUE ANIMATION
          LDY     MINIOVER,X             ; Y IS OVERLAY SLOT NUMBER
          TAX                            ; X IS CURRENT ANIMATION NUMBER
          LDA     MINIEXSL-2,X
          STA     SLTBL,Y
          LDA     MINIEXPW-2,X
          STA     PWTBL,Y

          CPX     #MXREM
          BEQ     MEXPREM                ; REMOVE OVERLAY
          CPX     #MXREP
          BEQ     MEXPREP                ; REPLACE OVERLAY
          CPX     #MXLOW
          BEQ     MEXPLOW                ; LOWER OVERLAY

MEXPFNSH: LDX     TEMP0
          JMP     MINIDONE               ; ALL DONE WITH THIS ANIMATION

MEXPREM:  LDA     #200                   ; OFF SCREEN HP
          STA     HPTBL,Y                ; OVERLAY'S HP
          JMP     MEXPFNSH

MEXPREP:  LDX     TEMP1                  ; GET MINI SPHINX NUMBER
          LDA     MINITBL,X              ; GET SLOT NUMBER OF TOP
          TAX
          LDA     HPTBL,X
          STA     HPTBL,Y                ; RESTORE HP
          JMP     MEXPFNSH

MEXPLOW:  LDA     VPTBL,Y                ; LOWER THE OVERLAY
          CLC
          ADC     #3
          STA     VPTBL,Y

          LDX     TEMP1                  ; AND REMOVE THE HEAD FROM THE TOP
          LDA     MINITBL,X
          TAX
          LDA     SLTBL,X
          CLC
          ADC     #3
          STA     SLTBL,X                ; BYPASS HEAD IN STAMP
          LDA     HPTBL,X
          CLC
          ADC     #12
          STA     HPTBL,X                ; NEW HP FOR TOP
          LDA     PWTBL,X
          CLC
          ADC     #3
          STA     PWTBL,X                ; AND SHRINK THE WIDTH
          LDA     COLY2,X
          SEC
          SBC     #10
          STA     COLY2,X                ; ALSO LOWER TOP OF COLISION BOX
          BNE     MEXPFNSH

MEXPINIT: JSR     GETASLOT               ; X IS NOW OVERLAY SLOT NUMBER
          BMI     MEXPWAIT               ; NO SLOT AVAILABLE
          LDY     TEMP1                  ; Y IS NOW MINI SPHINX NUMBER
          TXA
          STA     MINIOVER,Y
          LDA     MINITBL,Y
          TAY                            ; Y IS NOW TOP SLOT NUMBER
          LDA     VPTBL,Y
          CLC
          ADC     #5
          STA     VPTBL,X                ; OVERLAY INITIAL VP
          LDA     HPTBL,Y
          STA     HPTBL,X                ; OVERLAY HP
          LDA     YTBL,Y
          CLC
          ADC     #6
          STA     YTBL,X                 ; OVERLAY Y

          LDA     #MINIEXP1&$FF
          STA     SLTBL,X                ; FIRST EXPLOSION ANIMATION
          LDA     #MINIEXP1/256
          STA     SHTBL,X
          LDA     #$9C                   ; FIRST EXPLOSION PALETTE
          STA     PWTBL,X                ;PALW/WIDTH
          LDA     #(MINIEXP1+$1700-$1600)/256
          STA     SMTBL,X

          LDA     DXTBL,Y
          SEC
          SBC     #6
          STA     TEMP6
          CLC
          ADC     #2
          STA     TEMP10

          LDA     #0                     ; NO COLISION BOX FOR OVERLAY
          STA     COLSTAT,X

          JSR     OBJINS                 ; INSERT OVERLAY INTO LINKED LIST

          JMP     MEXPFNSH

MEXPWAIT: LDX     TEMP0
          DEC     XTBL,X                 ; RESTORE OLD STATE FOR NEXT TIME
          JMP     MINIDONE

; TABLES FOR MINI SPHINX EXPLOSION ANIMATION - STARTING WITH SECOND ANIMATION
MINIEXSL: .dc.b      0                      ; 2 - NO OVERLAY
          .dc.b      0                      ; 3 - NO OVERLAY
          .dc.b      MINIEXP1&$FF            ; 4
          .dc.b      MINIEXP1&$FF            ; 5
          .dc.b      MINIEXP2&$FF            ; 6
          .dc.b      MINIEXP1&$FF            ; 7
          .dc.b      MINIEXP1&$FF            ; 8
          .dc.b      MINIEXP2&$FF            ; 9
          .dc.b      MINIEXP2&$FF            ; 10
          .dc.b      MINIEXP1&$FF            ; 11
          .dc.b      MINIEXP1&$FF            ; 12
          .dc.b      MINIEXP2&$FF            ; 13
          .dc.b      MINIEXP1&$FF            ; 14
          .dc.b      MINIEXP3&$FF            ; 15
          .dc.b      MINIEXP1&$FF            ; 16
          .dc.b      MINIEXP2&$FF            ; 17
          .dc.b      MINIEXP3&$FF            ; 18
          .dc.b      MINIEXP1&$FF            ; 19
          .dc.b      MINIEXP3&$FF            ; 20

MINIEXPW: .dc.b      $9C                     ; 2 - NO OVERLAY
          .dc.b      $9C                     ; 3 - NO OVERLAY
          .dc.b      $9C                     ; 4
          .dc.b      $9C                     ; 5
          .dc.b      $9C                     ; 6
          .dc.b      $9C                     ; 7
          .dc.b      $9C                     ; 8
          .dc.b      $9C                     ; 9
          .dc.b      $9C                     ; 10
          .dc.b      $9C                     ; 11
          .dc.b      $9C                     ; 12
          .dc.b      $9C                     ; 13
          .dc.b      $9C                     ; 14
          .dc.b      $FC                     ; 15
          .dc.b      $9C                     ; 16
          .dc.b      $9C                     ; 17
          .dc.b      $FC                     ; 18
          .dc.b      $9C                     ; 19
          .dc.b      $FC                     ; 20

SXFLINIT: LDA     PHASE
          BNE     SLIDONE                ; PUNT IF NOT NORMAL GAME PLAY

          TXA                          ; REMEMBER INDEX OF BOTTOM OF SPHINX FACE
          STA     LOWFACE

          LDA     COLX1,X                ; GET X POSITION OF SPHINX NOSE
          CLC
          ADC     #2
          STA     SPHNXNSX

          LDA     #3                     ; ADJUST THIS
          SEC
          SBC     DIFCULTY
          STA     TEMP4                  ; AMOUNT OF EXTRA COLISION BOX

          LDA     COLX1,X
          SEC
          SBC     TEMP4
          STA     COLX1,X

          LDA     COLX2,X
          CLC
          ADC     TEMP4
          STA     COLX2,X

          LDA     COLY1,X
          SEC
          SBC     TEMP4
          STA     COLY1,X

          LDA     COLY2,X
          CLC
          ADC     TEMP4
          STA     COLY2,X

SLIDONE:  RTS

SXFHINIT: LDA     PHASE
          BNE     SLIDONE                ; PUNT IF NOT NORMAL GAME PLAY
          TXA                            ; REMEMBER INDEX OF TOP OF SPHINX FACE
          STA     HIFACE
          INC     PHASE                  ; SET TO PHASE 1
          LDA     #0
          STA     FACER                  ; INITIALIZE ANIMATION
          RTS

DSEXCLPS: LDA     #CRATERL&$FF
          LDX     LOWFACE
          STA     SLTBL,X

          LDA     #CRATERH&$FF
          LDX     HIFACE
          STA     SLTBL,X

          JMP     DSEXANIM

DSEXDONE: LDX     SEXP1                  ; DELETE THE OVERLAYS
          JSR     OBJDEL
          JSR     RETASLOT

          LDX     SEXP2
          JSR     OBJDEL
          JSR     RETASLOT

          LDX     SEXP3
          JSR     OBJDEL
          JSR     RETASLOT

          LDA     #$FE                   ; GO TO TIMED BONUS PHASE
          STA     PHASE

          RTS

DSEXINIT: LDX     LOWFACE

          LDA     HPTBL,X
          STA     TEMP3

          LDA     VPTBL,X
          STA     TEMP4

          LDA     DXTBL,X
          SEC
          SBC     #4
          STA     TEMP6                  ; ASSUMING THIS DOESN'T GO AWAY
          CLC
          ADC     #2
          STA     TEMP10                 ; SAME HERE

          LDY     #2

DSEXINLP: JSR     GETASLOT
          TXA
          STA     SEXP1,Y

          LDA     #SPHXGLMR/256
          STA     SHTBL,X

          LDA     #(SPHXGLMR+1700-1600)/256
          STA     SMTBL,X

          LDA     #$9E
          STA     PWTBL,X

          LDA     #30
          STA     YTBL,X

          LDA     TEMP3
          CLC
          ADC     SEXHPOFF,Y
          STA     HPTBL,X

          LDA     TEMP4
          CLC
          ADC     SEXVPOFF,Y
          STA     VPTBL,X

          LDA     #0
          STA     COLSTAT,X

          JSR     OBJINS

          DEY
          BPL     DSEXINLP

          LDY     #0
          JMP     DSEXANIM

DSEXPL:   CMP     #$FF                   ; PHASE IS IN A
          BNE     ANRTS                  ; PHASE EQUALS -1 DURING EXPLOSION

          LDA     MAINCNT
          LSR     
          BCC     ANRTS

          INC     FACER

          LDY     FACER
          CPY     #0
          BEQ     DSEXINIT
          CPY     #15
          BEQ     DSEXDONJ
          CPY     #11
          BNE     DSEXANIM
          JMP     DSEXCLPS

DSEXDONJ: JMP     DSEXDONE

DSEXANIM: LDX     SEXP1
          LDA     SEXAN1,Y
          STA     SLTBL,X

          LDX     SEXP2
          LDA     SEXAN2,Y
          STA     SLTBL,X

          LDX     SEXP3
          LDA     SEXAN3,Y
          STA     SLTBL,X

ANRTS:    RTS


SPHNXNSY  EQU     22

DOSPHINX: LDX     LOWFACE

          LDA     PHASE
          BEQ     ANRTS                  ; IF IN NORMAL PLAY
          BMI     DSEXPL                 ; IF IN EXPLOSION OR BONUS PHASE

          CMP     #1
          BNE     DSTUNE                 ; ALREADY STOPPED SCROLLING

          LDA     COLZ1,X
          CMP     #140
          BCS     DSTUNE                 ; KEEP SCROLLING

          INC     PHASE                  ; NOW IN PHASE 2

DSTUNE:   LDA     #SFINKS
          CMP     TUNNUM
          BEQ     DSSHOOT                ; STILL PLAYING
          CMP     TUNNUM+1
          BEQ     DSSHOOT                ; STILL PLAYING

          JSR     TUNIN                  ; PLAY AGAIN - IT GOT BOOTED

DSSHOOT:
          BIT     PARASPHX
          BMI     ANRTS

          LDA     SPHXSHTD
          BNE     DSSPAWN

          LDA     #1
          STA     TEMP0                  ;TEMP0 = 1 MEANS BIG SPHINX

          LDA     SPHNXNSX
          STA     TEMP2

          LDA     #SPHNXNSY+7            ; Y POS
          STA     TEMP7

          LDA     COLZ1,X
          SEC
          SBC     #6                     ; PREVENT SUICIDE
          STA     TEMP9

          JSR     LAUNCHER

DSSPAWN:  LDA     PHASE
          CMP     #2
          BNE     DSANIM                 ; SPAWN ONLY WHEN SCROLLING IS STOPPED

          DEC     SPNCNT
          BNE     DSANIM

          LDX     LOWFACE

          LDA     #20
          STA     SPNCNT

          LDA     SPHNXNSX
          STA     SPNX

          LDA     #SPHNXNSY-6
          STA     SPNY

          LDA     COLZ1,X
          SEC
          SBC     #5
          STA     SPNZ

          JSR     RANDOM
          AND     #3
          LDX     PLAYER
          ADC     RACK,X
          CMP     #$C
          BCC     DSSPCLS
          LDA     #$B
DSSPCLS:
          STA     SPNCLASS

          JSR     SPAWN

DSANIM:   LDA     MAINCNT
          AND     #3
          BNE     DSDONE

          LDY     FACER
          LDA     FACEADV,Y
          BPL     FACESTA
          LDA     RNDOM
          AND     #4
FACESTA:  STA     FACER
          TAY

          LDA     FACEHI,Y
          LDX     HIFACE
          STA     SLTBL,X
          LDA     FACELO,Y
          LDX     LOWFACE
          STA     SLTBL,X

DSDONE:   RTS

FACEADV:  .dc.b      1,2,3,$80,5,6,7,$80

SEXHPOFF: .dc.b      0,5,3

SEXVPOFF: .dc.b      -17,-16,-8

SEXAN1:   .dc.b      SPHXGLMR&$FF            ;0
          .dc.b      BLANK&$FF               ;1
          .dc.b      SPHXGLMR&$FF            ;2
          .dc.b      SPHXFLSH&$FF            ;3
          .dc.b      SPHXGLMR&$FF            ;4
          .dc.b      SPHXGLMR&$FF            ;5
          .dc.b      SPHXFLSH&$FF            ;6
          .dc.b      SPHXEXPL&$FF            ;7
          .dc.b      SPHXFLSH&$FF            ;8
          .dc.b      SPHXEXPL&$FF            ;9
          .dc.b      SPHXEXPL&$FF            ;10
          .dc.b      SPHXEXPL&$FF            ;11
          .dc.b      SPHXFLSH&$FF            ;12
          .dc.b      SPHXEXPL&$FF            ;13
          .dc.b      SPHXEXPL&$FF            ;14

SEXAN2:   .dc.b      BLANK&$FF               ;0
          .dc.b      SPHXGLMR&$FF            ;1
          .dc.b      BLANK&$FF               ;2
          .dc.b      SPHXGLMR&$FF            ;3
          .dc.b      SPHXFLSH&$FF            ;4
          .dc.b      SPHXGLMR&$FF            ;5
          .dc.b      SPHXGLMR&$FF            ;6
          .dc.b      SPHXFLSH&$FF            ;7
          .dc.b      SPHXEXPL&$FF            ;8
          .dc.b      SPHXEXPL&$FF            ;9
          .dc.b      SPHXFLSH&$FF            ;10
          .dc.b      SPHXEXPL&$FF            ;11
          .dc.b      SPHXEXPL&$FF            ;12
          .dc.b      SPHXFLSH&$FF            ;13
          .dc.b      SPHXEXPL&$FF            ;14

SEXAN3:   .dc.b      BLANK&$FF               ;0
          .dc.b      BLANK&$FF               ;1
          .dc.b      SPHXGLMR&$FF            ;2
          .dc.b      BLANK&$FF               ;3
          .dc.b      SPHXGLMR&$FF            ;4
          .dc.b      SPHXFLSH&$FF            ;5
          .dc.b      SPHXGLMR&$FF            ;6
          .dc.b      SPHXFLSH&$FF            ;7
          .dc.b      SPHXEXPL&$FF            ;8
          .dc.b      SPHXFLSH&$FF            ;9
          .dc.b      SPHXEXPL&$FF            ;10
          .dc.b      SPHXEXPL&$FF            ;11
          .dc.b      SPHXFLSH&$FF            ;12
          .dc.b      SPHXEXPL&$FF            ;13
          .dc.b      SPHXEXPL&$FF            ;14


FACELO:   .dc.b      SPFACE1L&$FF,SPFACE4L&$FF,SPFACE5L&$FF
	  .dc.b	     SPFACE4L&$FF,SPFACE1L&$FF
          .dc.b      SPFACE2L&$FF,SPFACE1L&$FF,SPFACE3L&$FF

FACEHI:   .dc.b      SPFACE1H&$FF,SPFACE4H&$FF,SPFACE5H&$FF
	  .dc.b	     SPFACE4H&$FF,SPFACE1H&$FF
          .dc.b      SPFACE2H&$FF,SPFACE1H&$FF,SPFACE3H&$FF

KILLSPHX: LDA     PHASE                  ; A SHOT HIT THE SPHINX
          BEQ     KSDONE
          BMI     KSDONE                 ; ITS ALREADY BEEN HIT

          JSR     INITBNS                ; TELL STUFF IN SMAGIC
          LDA     #$FF
          STA     FACER                  ; START OF FACE EXPLOSION ANIMATION

          LDA     #SFINKS                ; DO WE NEED THIS IF WE HAVE A TWO
          JSR     SCRAPONE               ; CHANNEL SOUND??

          LDA     #SPHXBM0
          JSR     TUNIN

          LDA     #SPHXBM1
          JSR     TUNIN

          LDA     RACK                   ;SCORE FOR SPHINX IS (RACK+5)*1000
          ASL                           ;RACK STARTS AT 0
          ASL     
          ASL     
          ASL                           ;MOVE TO UPPER NIBBLE
          SED
          CLC
          ADC     #$50                   ;ADD RACK TO 5000
          STA     HUNDS
          LDA     #0
          ADC     #0
          STA     HUNTHOUS
          CLD
          JSR     ADDSCORE

KSDONE:   RTS

*         KILL ALL FIRE POTS POWER

KAFIRES:  LDX     #FIRENUMB-1            ; KILL ALL FIRES

KAFIRELP: LDA     FIRETIP,X
          BMI     KNFIRE                 ; NOT AN ACTIVE FIRE POT

          LDA     #0
          STA     FIREGOAL,X

KNFIRE:   DEX
          BPL     KAFIRELP
          RTS

FIREINIT: LDY     #FIRENUMB-1            ; CALLED WITH SLOT NUMBER IN X
FIRELP:   LDA     FIRETIP,Y
          BMI     FIREFND
          DEY
          BPL     FIRELP
FIREKILL: LDA     #SCRENBOT+1
          STA     VPTBL,X
          JSR     OBJDEL                 ; DELETE FIRE IF WE CAN'T ANIMATE IT
          JSR     RETASLOT
          RTS

FIREFND:  STX     TEMP2                  ; TIP SLOT NUMBER

          TXA                            ; TIP SLOT IN A AND X
          STA     FIRETIP,Y

          JSR     RANDOM                 ; START WITH RANDOM ANIMATION
          STA     FIREANIM,Y

          LDA     #2
          STA     FIREHGHT,Y

;         LDA     #2                     ;2 IS ALREADY IN A
          STA     FIREGOAL,Y

          LDA     DIFIND                 ;0 IS LOW DIFF., 255 IS HIGH
          ASL                           ;PUT TOP TWO BITS INTO BOTTOM TWO BITS
          ROL                           ;SHIFTED TOP BIT INTO BIT0
          ROL                           ;SHIFTED NEXT BIT INTO BIT0
          AND     #$3                    ;MASK OUT REMAINING BITS
                  ;NOW WE HAVE TWO LOW ORDER BITS  BASED ON DIFFICULTY
          STA     TEMP3                  ;I KNOW I CAN USE THIS

          JSR     RANDOM
          AND     #$0C
          ORA     TEMP3
          TAX
          LDA     MODETABL,X

          STA     FIREMODE,Y

          LDA     #$FF
          STA     FIRECOL1,Y
          STA     FIRECOL2,Y

          STY     TEMP3                  ; FIRE TABLE INDEX
                  ;Y HAS NOT CHANGED, BUT I USED TEMP3 AS A TEMP ABOVE

          RTS

MODETABL:
          .dc.b      0,2,2,1,1,1,1,3,0,0,2,2,1,1,0,3

DOFIRE:   LDX     #FIRENUMB-1
DFLOOP:   LDY     FIRETIP,X
          BPL     DFYES                  ; AN ACTIVE ENTRY
DFNEXT:   DEX
          BPL     DFLOOP
          RTS

DFFREE:   LDA     #$FF
          STA     FIRETIP,X              ; MARK TABLE ENTRY AS UNUSED
          BMI     DFNEXT                 ; ALWAYS

DFYES:    STX     TEMP0                  ; FIRE TABLE INDEX
          STY     TEMP1                  ; TIP SLOT NUMBER

          LDA     VPTBL,Y
          CMP     #SCRENBOT+1
          BEQ     DFFREE                 ; THE TIP HAS SCROLLED OFF

          INC     FIREANIM,X
          LDA     FIREANIM,X
          AND     #3
          BNE     DFNEXT                 ; ONLY DO EVERY 4TH GAME LOOP

          LDA     FIREHGHT,X             ; COMPARE HEIGHT AND GOAL TO GET
          CMP     FIREGOAL,X             ; DIRECTION TO MOVE
          BEQ     DFMCFALL               ; DF IS A RELATIVE OF ROSALIE
          BCC     JDRISE
          JMP     DFFALL
JDRISE:   JMP     DFRISE

HIBND:    .dc.b      17,49,49,49            ;TABLE OF FLAME HI BOUNDS BY MODE
GOALBASE: .dc.b      40,2                   ;BASE OF SPAZ GOAL

DFMCFALL:
;THERE ARE FOUR FIREMODES -- 0) MELLOW 1) RANDOM 2) SPASTIC 3) HARDCORE
          LDA     FIREMODE,X
          TAY                            ; MODE STAYS IN Y FOR NOW

          JSR     RANDOM                 ; GET NEW GOAL
          AND     #$3F
          CMP     #2
          BCC     DFANIM                 ; LEAVE SAME IF TO LOW
          CMP     HIBND,Y                ; GET HIGH BOUND BASED ON MODE
          BCS     DFANIM                 ; LEAVE SAME IF TO HIGH

          CPY     #2                     ; LOOK FOR MORE COMPLICATED MODES
          BCC     STGOAL                 ; IF SIMPLE, STORE GOAL

;THIS IS WHERE THE FUN BEGINS -- WE NEED SOME GOAL SELECTION INTELLIGENCE

          STA     TEMP2                  ; SAVE CALCULATED RANDOM GOAL FOR LATER
          BEQ     SPAZ                   ; IF MODE = 2, GO TO SPAZ DRIVER

          ;THIS MUST BE THE HARDCORE DRIVER.  WE KEEP GOAL RANDOM IF NOT IN
          ;RANGE OF X.  IF IN X RANGE, WE KEEP GOAL LOW UNTIL IN Z RANGE.  THEN
          ;WE RAISE GOAL TO ZAP THE DESERT FUCKIN' FALCON

;SEE IF BIRD IS NEAR
          LDY     TEMP1                  ;INDEX OF TIP
          LDA     COLX1,Y                ;9 BIT AVERAGE OF COLLISION X'ES
          CLC
          ADC     COLX2,Y
          ROR                           ;DON'T LOSE TOP BIT
          SEC
          SBC     XTBL                   ;COMPARE TO BIRD'S X
          CMP     #$EE                   ;IF OUT OF X RANGE, USE RANDOM GOAL
          BCS     CHEQUEZ
          CMP     #18
          BCS     USETE2                 ;WE TAKE THIS BRANCH TO USE RANDOM GOAL

;NOW WE KNOW IT IS IN X RANGE
;CHECK Z RANGE FOR LOW OR HIGH GOAL
CHEQUEZ:
          LDA     COLZ1,Y                ;9 BIT AVERAGE OF COLLISION Z'ES
          CLC
          ADC     COLZ2,Y
          ROR                           ;DON'T LOSE TOP BIT
          SEC
          SBC     ZTBL
          BMI     USETE2                 ;POT IS BEHIND BIRD

          CMP     #$1C                   ;LOTS O' LEAD TIME
          LDA     #0                     ;CARRY SET MAKES THIS A 1 (>= 1C)
          ROL                           ;USE CARRY TO MAKE THIS A 0 OR 1.  0 IS
                                         ;FOR HIGOAL, 1 IS FOR LOW GOAL
          TAY                            ;SAVE THIS FOR INDEXING SOON


          JSR     RANDOM                 ;GET RANDOM GOAL BASED IN RGHT PLACE
          AND     #7
          ADC     GOALBASE,Y
          BNE     STGOAL                 ;JMP


SPAZ:
          TAY                            ;SAVE TEMP2 IN Y ALSO FOR QUICK COMPARE

          LDA     #16                    ;SEE WHAT LAST GOAL WAS (HI OR LO)
          CMP     FIREGOAL,X
          TYA                            ;GET RANDOM GOAL IN A
          BCS     HIGOAL                 ;IF GOAL >16, THEN MAKE NEW ONE <16
          CMP     #16                    ;CHECK NEW GOAL FOR LOWNESS
          BCS     DFANIM
          BCC     STGOAL

HIGOAL:
          CMP     #40                    ;IS GOAL HIGH ENOUGH?
          BCC     DFANIM                 ;IF NOT, DON'T CHANGE GOAL

USETE2:
          LDA     TEMP2                  ;I KNOW THIS IS ALREADY IN A

STGOAL:
          STA     FIREGOAL,X


DFANIM:   LDA     FIREANIM,X             ; DERIVE ANIMATION INDEX
          LSR     
          LSR     
          CMP     #6
          BCC     DFANIMOK
          LDA     #0
          STA     FIREANIM,X

DFANIMOK: TAY
          LDA     COLANIM,Y
          STA     TEMP2

          LDA     TIPANIM,Y
          LDY     TEMP1                  ; INDEX OF TIP
          STA     SLTBL,Y

          LDY     FIRECOL1,X             ; DO UPPER COLUMN
          BMI     DFC1GONE               ; IT MUST HAVE SCROLLED OFF

          LDA     VPTBL,Y                ; SEE IF IT JUST SCROLLED OFF
          CMP     #SCRENBOT+1
          BNE     DFC1HERE               ; NOPE
          LDA     #$FF
          STA     FIRECOL1,X             ; MARK IT
          BMI     DFC1GONE               ; ALWAYS

DFC1HERE: LDA     TEMP2                  ; COLUMN ANIMATION
          STA     SLTBL,Y

DFC1GONE: LDY     FIRECOL2,X             ; DO LOWER COLUMN
          BMI     DFNEXTJ                ; IT MUST HAVE SCROLLED OFF

          LDA     VPTBL,Y                ; SEE IF IT JUST SCROLLED OFF
          CMP     #SCRENBOT+1
          BNE     DFC2HERE               ; NOPE
          LDA     #$FF
          STA     FIRECOL2,X             ; MARK IT
          BMI     DFNEXTJ                ; ALWAYS

DFC2HERE: LDA     TEMP2                  ; COLUMN ANIMATION
          STA     SLTBL,Y
DFNEXTJ:  JMP     DFNEXT

DFRISE:   LDA     VPTBL,Y
          CMP     #$F6
          BCS     DFRISE1                ; LET IT GO PAST TOP OF SCREEN
          CMP     #$EC
          BCC     DFRISE1                ; BUT NOT TOO FAR

          DEC     FIREGOAL,X             ; TO PREVENT IT FROM STICKING HERE
          JMP     DFDONE

DFRISE1:  JSR     RANDOM                 ; HOW MUCH DO WE RISE ?
          AND     #7
          STA     TEMP3
          INC     TEMP3                  ; MAKE BETWEEN 1 AND 8

          LDA     FIREHGHT,X
          STA     TEMP5                  ; NEED TO KEEP OLD HEIGHT
          CLC
          ADC     TEMP3
          CMP     #49
          BCS     DFDONE                 ; DON'T GET TOO HIGH
          STA     FIREHGHT,X
          STA     TEMP7                  ; NEED THIS LATER WITHOUT INDEXING

          LDX     TEMP1                  ; FIRE TIP SLOT
          LDY     TEMP0                  ; FIRE TABLE INDEX

          LDA     COLY2,X                ; ADJUST COLISION BOX
          CLC
          ADC     TEMP3
          STA     COLY2,X

          LDA     VPTBL,X                ; DO TIP FIRST
          SEC
          SBC     TEMP3
          STA     VPTBL,X

          LDA     TEMP7                  ; NEW HEIGHT
          CMP     #17
          BCC     DFDONE                 ; NO OTHER PIECES

          LDA     TEMP5                  ; OLD HEIGHT
          CMP     #17                    ; DOES COLUMN 1 ALREADY EXIST
          BCC     DFADDC1J               ; NEED A NEW PIECE

          LDA     TEMP7                  ; NEW HEIGHT
          CMP     #33
          BCC     DFDONE                 ; NO OTHER PIECES

          LDA     TEMP5                  ; OLD HEIGHT
          CMP     #33                    ; DOES COLUMN 2 ALREADY EXIST
          BCC     DFADDC2J               ; NEED A NEW PIECE

DFDONE:   LDX     TEMP0
          LDY     TEMP1
          JMP     DFANIM

DFADDC1J: JMP     DFADDC1
DFADDC2J: JMP     DFADDC2
DFDELC1J: JMP     DFDELC1
DFDELC2J: JMP     DFDELC2

DFFALL:   JSR     RANDOM                 ; HOW MUCH DO WE FALL ?
          AND     #7
          STA     TEMP3
          INC     TEMP3                  ; MAKE BETWEEN 1 AND 8

          LDA     FIREHGHT,X
          STA     TEMP5                  ; NEED TO KEEP OLD HEIGHT
          SEC
          SBC     TEMP3

          CMP     #2
          BCC     DFLOW                  ; DON'T GET TOO LOW
          CMP     #$F8
          BCS     DFLOW                  ; WATCH FOR NEGATIVES

          STA     FIREHGHT,X
          STA     TEMP7                  ; NEED THIS LATER WITHOUT INDEXING

          LDX     TEMP1                  ; FIRE TIP SLOT
          LDY     TEMP0                  ; FIRE TABLE INDEX

          LDA     COLY2,X                ; ADJUST COLISION BOX
          SEC
          SBC     TEMP3
          STA     COLY2,X

          LDA     VPTBL,X                ; DO TIP FIRST
          CLC
          ADC     TEMP3
          STA     VPTBL,X

          LDA     TEMP5                  ; OLD HEIGHT
          CMP     #17
          BCC     DFDONE                 ; NO OTHER PIECES

          LDA     TEMP7                  ; NEW HEIGHT
          CMP     #17                    ; DOES COLUMN 1 ALREADY EXIST
          BCC     DFDELC1J               ; DELETE A PIECE

          LDA     TEMP5                  ; OLD HEIGHT
          CMP     #33
          BCC     DFDONE                 ; NO OTHER PIECES

          LDA     TEMP7                  ; NEW HEIGHT
          CMP     #33                    ; DOES COLUMN 2 ALREADY EXIST
          BCC     DFDELC2J               ; DELETE A PIECE

          JMP     DFDONE

DFLOW:    LDA     FIREGOAL,X             ; CALLED WHEN FIRE HEIGHT LESS THAN 2
          BNE     DFDONE

          LDY     FIRETIP,X
          LDA     #$FF
          STA     FIRETIP,X

          TYA
          TAX

          JSR     FIREKILL               ; EXTINGUISH IT

          LDX     TEMP0
          JMP     DFNEXT

DFADDC1:  JSR     GETASLOT               ; GET COLUMN SLOT NUMBER IN X
          BMI     DFDONEJ                ; THIS NEEDS TO BE HANDLED BETTER

          LDY     TEMP1                  ; TIP SLOT NUMBER

          LDA     VPTBL,Y                ; COL1 VP = TIP VP + HGHT - 16
          CLC
          ADC     TEMP7                  ; NEW HEIGHT
          SEC
          SBC     #16
          STA     VPTBL,X

          LDA     #0
          STA     COLSTAT,X              ; NO COLISION BOX

          LDA     HPTBL,Y
          SEC
          SBC     #2
          STA     HPTBL,X

          LDA     #COL1/256
          STA     SHTBL,X

          LDA     #COL1&$FF
          STA     SLTBL,X

          LDA     #(COL1+$1100-$1000)/256   ; NON-HACKED STAMP
          STA     SMTBL,X

          LDA     #$9D
          STA     PWTBL,X

          LDA     #16
          STA     YTBL,X

          LDA     DXTBL,Y                ; SAME DX AS TIP
          STA     TEMP6
          LDA     DFTBL,Y
          STA     TEMP10

          JSR     OBJINS

          LDY     TEMP0                  ; FIRE SLOT NUMBER
          TXA
          STA     FIRECOL1,Y             ; MARK IT

DFDONEJ:  JMP     DFDONE

DFADDC2:  JSR     GETASLOT               ; GET COLUMN SLOT NUMBER IN X
          BMI     DFDONEJ                ; THIS NEEDS TO BE HANDLED BETTER

          LDY     TEMP1                  ; TIP SLOT NUMBER

          LDA     VPTBL,Y                ; COL2 VP = TIP VP + HGHT - 32
          CLC
          ADC     TEMP7                  ; NEW HEIGHT
          SEC
          SBC     #32
          STA     VPTBL,X

          LDA     #0
          STA     COLSTAT,X              ; NO COLISION BOX

          LDA     HPTBL,Y
          SEC
          SBC     #2
          STA     HPTBL,X

          LDA     #COL1/256
          STA     SHTBL,X

          LDA     #COL1&$FF
          STA     SLTBL,X

          LDA     #(COL1+$1100-$1000)/256   ; NON-HACKED STAMP
          STA     SMTBL,X

          LDA     #$9D
          STA     PWTBL,X

          LDA     #32
          STA     YTBL,X

          LDA     DXTBL,Y                ; SAME DX AS TIP
          STA     TEMP6
          LDA     DFTBL,Y
          STA     TEMP10

          JSR     OBJINS

          LDY     TEMP0                  ; FIRE SLOT NUMBER
          TXA
          STA     FIRECOL2,Y             ; MARK IT

          JMP     DFDONE

DFDELC1:  LDX     FIRECOL1,Y
          BMI     DFDONEJ

          LDA     #SCRENBOT+1
          CMP     VPTBL,X
          BEQ     DFDONEJ
          STA     VPTBL,X

          JSR     OBJDEL
          JSR     RETASLOT

          LDY     TEMP0                  ; FIRE SLOT NUMBER
          LDA     #$FF
          STA     FIRECOL1,Y

          JMP     DFDONE

DFDELC2:  LDX     FIRECOL2,Y
          BMI     DFDONEJ

          LDA     #SCRENBOT+1
          CMP     VPTBL,X
          BEQ     DFDONEJ
          STA     VPTBL,X

          JSR     OBJDEL
          JSR     RETASLOT

          LDY     TEMP0                  ; FIRE SLOT NUMBER
          LDA     #$FF
          STA     FIRECOL2,Y

          JMP     DFDONE

          ;SEQUENCE OF FLAME ANIMATIONS
COLANIM:  .dc.b      COL1&$FF,COL2&$FF,COL1&$FF,COL2&$FF,COL1&$FF,COL2&$FF

TIPANIM:  .dc.b      TIP1&$FF,TIP2&$FF,TIP3&$FF,TIP1&$FF,TIP2&$FF,TIP3&$FF

; ROUTINE TO LAUNCH SPHINX AND MINISPHINX SHOTS

;         TYPE    = TEMP0
;         X       = TEMP2
;         Y       = TEMP7
;         Z       = TEMP9

LAUNCHER:
          LDX     #3
LOOK4SHT: LDA     SXSHTSTT,X
          BEQ     AFREESHT
          DEX
          BPL     LOOK4SHT
          RTS

AFREESHT:
          LDY     TEMP0
          INY                            ;1 FOR MINI SPHINX, 2 FOR SPHINX
          TYA
          STA     SXSHTSTT,X             ;MARK SHOT AS USED

          LDA     #MINISHOT
          JSR     TUNIN

          JSR     RANDOM                 ; DELAY TIL NEXT SHOT
          AND     #$4F
          LDY     DIFCULTY
          CLC
          ADC     SXSHTMTD,Y
          STA     SPHXSHTD

          LDA     TEMP2
          STA     XTBL+SPHXSHOT,X
          STA     XTBL+SPXSHTSH,X
          SEC
          SBC     #3
          STA     COLX1+SPHXSHOT,X
          CLC
          ADC     #7
          STA     COLX2+SPHXSHOT,X

          LDA     TEMP7
          STA     YTBL+SPHXSHOT,X
          SEC
          SBC     #3
          STA     COLY1+SPHXSHOT,X
          CLC
          ADC     #7
          STA     COLY2+SPHXSHOT,X

          LDA     #0
          STA     YTBL+SPXSHTSH,X

          LDA     TEMP9
          STA     ZTBL+SPHXSHOT,X
          STA     ZTBL+SPXSHTSH,X
          SEC
          SBC     #3
          STA     COLZ1+SPHXSHOT,X
          CLC
          ADC     #7
          STA     COLZ2+SPHXSHOT,X

          LDA     TEMP2                  ; PROJECT HP'S
          CLC
          ADC     TEMP9
          ADC     #(-NUMBER-7)&$FF	;-7 IS HPOFF FOR BOTH SHOT ANIMATIONS
          STA     HPTBL+SPHXSHOT,X       ;HERE ARE THE SHOT AND SHADOW HP'S
          STA     HPTBL+SPXSHTSH,X

          LDA     TEMP2                  ; PROJECT VP'S
          SEC
          SBC     TEMP9
          CLC
          ADC     #NUMBER
          STA     VPTBL+SPXSHTSH,X       ;HERE IS SHADOW VP
          SEC
          SBC     TEMP7
          STA     VPTBL+SPHXSHOT,X       ;HERE IS SHOT VP

          LDA     TEMP9                  ; CALCULATE DX AND DF
          SEC
          SBC     TEMP2
          CLC
          ADC     #NUMBER+DXADJ+10       ; THIS IS DF
          STA     TEMP10
          SEC
          SBC     #5                     ; THIS IS DS
          STA     TEMP6                  ;PRIORITY OF SHOT

          LDA     #SXSHTCOL
          STA     COLSTAT+SPHXSHOT,X     ;STORE THE COLSTAT

          TXA                            ; GET REAL INDEX FOR SHOT
          CLC
          ADC     #SPHXSHOT
          TAX
          JSR     OBJINS

          LDA     #$FE
          STA     TEMP6
          STA     TEMP10

          TXA                            ; GET REAL INDEX FOR SHADOW
          CLC
          ADC     #SPXSHTSH-SPHXSHOT
          TAX
          JSR     OBJINS

          RTS

SXSHTMTD: .dc.b      18,14,10,8             ; MINIMUM SPHINX SHOT DELAY

;THIS DRIVES SPHINX AND MINI SPHINX SHOTS

DOSXSHTS: DEC     SPHXSHTD
          BPL     MVSHOTS
          LDA     #0
          STA     SPHXSHTD

MVSHOTS:  LDX     #3
MVSHOTLP: LDA     SXSHTSTT,X
          BNE     SHOTALIV               ; SEE IF SHOT EXISTS
NEXTSHOT2: 
	  DEX
          BPL     MVSHOTLP
          RTS

SHOTALIV: STX     TEMP9                  ; SAVE FOR LATER

          LDA     #0
          STA     TEMP4                  ; DEFAULT X MOTION
          STA     TEMP5                  ; DEFAULT Y MOTION

          LDA     DIFCULTY
          BEQ     GOLEVEL                ; DON'T TRACK AT NOVICE LEVEL

          LDA     ZTBL+SPHXSHOT,X
          CMP     #ZBIRDZ+10
          BCC     GOLEVEL                ; DON'T TRACK ONCE PAST BIRD

          LDA     XTBL+SPHXSHOT,X        ; CALCULATE X MOTION
          SEC
          SBC     XTBL+ZBIRD
          BEQ     GOSTRAIT
          BMI     GORIGHT

          LDA     #$FF
          BNE     STOREX                 ; ALWAYS

GORIGHT:  LDA     #1

STOREX:   STA     TEMP4                  ; X MOTION

GOSTRAIT: LDA     SXSHTSTT,X             ; CALCULATE Y MOTION
          CMP     #2
          BNE     GOLEVEL                ; DO Y ONLY FOR BIG SPHINX

          LDA     DIFCULTY
          CMP     #2
          BCC     GOLEVEL                ; TRACK IN Y ONLY AT ADV AND EXP LEVELS

          LDA     YTBL+SPHXSHOT,X
          SEC
          SBC     YTBL+ZBIRD
          BEQ     GOLEVEL
          BMI     GOUP

          LDA     #$FF
          BNE     STOREY                 ; ALWAYS

GOUP:     LDA     #1

STOREY:   STA     TEMP5                  ; Y MOTION

GOLEVEL:  LDA     RACK                   ; CALCULATE Z MOTION
          LSR     
;         LSR     
          CLC
          ADC     SXSHTSTT,X
          ADC     SCROLLS                ; MAKE RELATIVE TO GROUND
          STA     TEMP7                  ; Z MOTION - TOWARDS SCREEN

          LDA     HPTBL+SPHXSHOT,X       ; DO SHOT AND SHAD HP
          CLC
          ADC     TEMP4                  ; X
          SEC
          SBC     TEMP7                  ; Z
          STA     HPTBL+SPHXSHOT,X
          STA     HPTBL+SPXSHTSH,X

          LDA     VPTBL+SPHXSHOT,X       ; DO SHOT VP
          CLC
          ADC     TEMP4                  ; X
          SEC
          SBC     TEMP5                  ; Y
          CLC
          ADC     TEMP7                  ; Z
          CMP     #$E0
          BCS     VPOKAY
          CMP     #SCRENBOT
          BCS     SXSHTDEL               ; IT'S OFF THE BOTTOM OF THE SCREEN
VPOKAY:   STA     VPTBL+SPHXSHOT,X

          LDA     VPTBL+SPXSHTSH,X       ; DO SHAD VP
          CLC
          ADC     TEMP4                  ; X
          CLC
          ADC     TEMP7                  ; Z
          STA     VPTBL+SPXSHTSH,X

          LDA     XTBL+SPHXSHOT,X        ; DO SHOT X
          CLC
          ADC     TEMP4                  ; X
          STA     XTBL+SPHXSHOT,X
          STA     COLPX

          LDA     YTBL+SPHXSHOT,X        ; DO SHOT Y
          CLC
          ADC     TEMP5                  ; Y
          STA     YTBL+SPHXSHOT,X
          STA     COLPY

          LDA     ZTBL+SPHXSHOT,X        ; DO SHOT Z
          SEC
          SBC     TEMP7                  ; Z
          STA     ZTBL+SPHXSHOT,X
          STA     COLPZ

          LDA     COLX1+SPHXSHOT,X       ; DO COLISION X'S
          CLC
          ADC     TEMP4                  ; X
          STA     COLX1+SPHXSHOT,X
          CLC
          ADC     #7
          STA     COLX2+SPHXSHOT,X

          LDA     COLY1+SPHXSHOT,X       ; DO COLISION Y'S
          CLC
          ADC     TEMP5                  ; Y
          STA     COLY1+SPHXSHOT,X
          CLC
          ADC     #7
          STA     COLY2+SPHXSHOT,X

          LDA     COLZ1+SPHXSHOT,X       ; DO COLISION Z'S
          SEC
          SBC     TEMP7                  ; Z
          STA     COLZ1+SPHXSHOT,X
          CLC
          ADC     #7
          STA     COLZ2+SPHXSHOT,X

          LDA     DXTBL+SPHXSHOT,X       ; DO SHOT DX AND DF
          SEC
          SBC     TEMP4                  ; X
          SEC
          SBC     TEMP7                  ; Z
          STA     TEMP6
          CLC
          ADC     #5
          STA     TEMP10

          TXA                            ; GET REAL SLOT NUMBER
          CLC
          ADC     #SPHXSHOT
          TAX

          JSR     OBJMOV                 ; MOVE THE SHOT

          JSR     COLDET
          BNE     SXSHTDEL

          LDX     TEMP9
          JMP     NEXTSHOT2               ; DO NEXT SHOT


SXSHTDEL: LDX     TEMP9

          LDA     #0
          STA     SXSHTSTT,X

          TXA                            ; GET REAL SHOT INDEX
          CLC
          ADC     #SPHXSHOT
          TAX

          JSR     OBJDEL                 ; DELETE SHOT

          TXA                            ; GET REAL SHADOW INDEX
          CLC
          ADC     #SPXSHTSH-SPHXSHOT
          TAX

          JSR     OBJDEL                 ; DELETE SHADOW

          LDX     TEMP9
          JMP     NEXTSHOT2               ; DO NEXT SHOT

; REMOVE A TREASURE FROM THE SCREEN - INDEX IN X

DELTREAS: LDA     #SCRENBOT+1
          STA     VPTBL,X
          JSR     OBJDEL
          JSR     RETASLOT
          RTS

; START THE GLOW ANIMATION FOR A HIEROGLYPH

GLOHIERO: STX     TEMP1                  ; REMEMBER WHERE IT IS
          STA     TEMP0                  ; REMEMBER WHAT IT IS

          LDX     HIEROSLT               ; SEE IF ONE IS STILL ANIMATING
          BMI     NOPROB

          JSR     DHDONE                 ; REMOVE OLD ONE

NOPROB:   LDX     TEMP1                  ; SLOT NUMBER
          STX     HIEROSLT

          LDA     #0
          STA     COLSTAT,X              ; DISABLE FURTHER COLISIONS

          LDA     #$FE                   ; TWO BYTES, FIRE PALETTE
          STA     TEMP6                  ; INCREASE ITS PRIORITY ABOVE THAT
          STA     TEMP10                 ; OF SHADOWS
          JSR     OBJMOV

          LDA     #30
          STA     XTBL,X                 ; SET ANIMATION TIMER

          RTS

; CODE TO ANIMATE A HIERO

DOHIEROS: LDX     HIEROSLT
          BMI     DHNONE                 ; NO HIERO BEING ANIMATED

          LDA     VPTBL,X
          CMP     #SCRENBOT+1
          BEQ     DHGONE                 ; IT SCROLLED OFF THE SCREEN

          DEC     XTBL,X
          BEQ     DHDONE                 ; THE ANIMATION IS DONE

          LDA     PWTBL,X
          CLC
          ADC     #$20
          STA     PWTBL,X

DHNONE:   RTS

DHDONE:   LDA     #SCRENBOT+1
          STA     VPTBL,X

          JSR     OBJDEL

          JSR     RETASLOT

DHGONE:   LDA     #$FF
          STA     HIEROSLT               ; MARK THAT ITS GONE
          RTS

;          END
