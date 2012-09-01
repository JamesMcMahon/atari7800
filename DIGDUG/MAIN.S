*******************************************************************************

***********                    3600 DIG DUG                       *************

*******************************************************************************
*******************************************************************************
MAIN
          SEI
          CLD
          LDA     #$17                   ;LOCK 3600 MODE.
          STA     $1
          LDX     #STACK
          TXS
          LDA     #$7F
          STA     CTRL
          LDA     #0                     ;UNFREEZE JOYSTICKS.
          STA     $1

          JSR     INIT                   ;INIT DISPLAY LIST, VARIABLES, ETC.

          JSR     WAITVBL                ;WE WANT TO SYNC OURSELVES WITH MARIA:
          LDA     #$50                   ;  WAIT FOR VBLANK.
          STA     CTRL                   ;ENABLE DMA.

PLAYTITL  JSR     TITLEPAG               ;START OFF IN TITLE PAGE.


PLAYGAME
          LDA     SYNCFRAM
          BPL     PLAYGAME

DOCODE
          LDA     FRMCNT
          STA     AVAROBIN
*         LDY     DOOMPTR+1
*         CPY     #$A0
*         BEQ     DOOMOVER
*         LDY     #0
*         STA     (DOOMPTR),Y
*         INC     DOOMPTR
*         BNE     DOCODE2
*         INC     DOOMPTR+1
*         BNE     DOCODE2
*DOOMOVER  NOP
DOCODE2   INC     RACKTIME
          JSR     CHKDEATH               ;CHKDEATH SHOULD PRECEDE CHKSTATE
          JSR     CHKSTATE
          JSR     CHKRACK

          LDA     DETHWISH
          BNE     DOFALL

          JSR     DDMOVE                 ;DDMOVE SHOULD PRECEDE COLLISON
;                                        ; DDMOVE SHOULD PRECEDE ALL GAMEPLAY
                                         ;DDMOVE SHOULD PRECEDE PUMPER
          JSR     EATVEG                 ;EATVEG SHOULD PRECEDE FRUITER
          JSR     MONSTERS               ;INCLUDES PUMPER,FRUITER,FLAMER,FLAMCOL
                                         ;PUMPER SHOULD PRECEDE COLLISONS+FALL
          JSR     COLLISON

*         LDA     DETHWISH               ; PROBABLY NOT NECESSARY ANYMORE
*         BNE     DOFALL

          JSR     BLOWUP
DOFALL    JSR     FALL

          JSR     GENDPL                 ;GENERATE NEW DISPLAY LIST.

          LDA     FRMCNT                 ;IF WE TOOK LONGER THAN ONE FRAME, GO
          CMP     AVAROBIN               ;  BACK TO PLAYGAME TO EXECUTE AGAIN IN
*         BEQ     WAIT1FRM
DOCODE4   BNE     PLAYGAME               ;  CASE THE FRAME WE SKIPPED SHOULD
                                         ;  HAVE BEEN EXECUTED.

WAIT1FRM  CMP     FRMCNT                 ;WE TOOK LESS THAN OR EQUAL TO ONE
          BEQ     WAIT1FRM               ;  FRAME TO EXECUTE DOCODE.  WAIT FOR
          BNE     PLAYGAME               ;  NEXT FRAME BEFORE CONTINUING.


*         AND     #$07                   ;DO STUFF 5 OUT OF 8 FRAMES
*         BEQ     DOCODE
*         CMP     #1
*         BEQ     DOCODE
*         CMP     #3
*         BEQ     DOCODE
*         CMP     #4
*         BEQ     DOCODE
*         CMP     #6
*         BNE     PLAYGAME

*         LDA     AVAROBIN
*WAITARC   CMP     FRMCNT
*         BEQ     WAITARC
*         BNE     PLAYGAME
