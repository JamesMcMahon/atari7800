          ORG     $C298                  ;HOLE IN GRAPHICS DATA


* INTERRUPT HANDLER TO SWITCH BACK INTO 160X2 MODE AFTER SCORE ZONE
MORPHO    LDA     #L(VBLNK)
          STA     VECTORI
          LDA     #H(VBLNK)
          STA     VECTORI+1

          LDA     #$40
          STA     WSYNC
          STA     CTRL
          LDA     #$80
          STA     VBLANK

RESTAIR   PLA
RITS      RTI



* INTERRUPT HANDLER TO RUN LOADER AT BOTTOM OF SCREEN
VBLNK     TXA
          PHA
          TYA
          PHA
          CLD

          LDA     #L(RVB)
          STA     VECTORI
          LDA     #H(RVB)
          STA     VECTORI+1

          LDA     #0
          STA     VBLANK
          STA     WSYNC
          STA     WSYNC

          LDA     #$43
          STA     CTRL
          JSR     TRACKIT
          JSR     SCORIT
          JSR     LOADER
          JSR     LMST
          JSR     TUNER

MOO       PLA
          TAY
          PLA
          TAX
          PLA
          RTI



RVB
          STA     WSYNC
          TXA
          PHA
          TYA
          PHA
          STA     WSYNC
          JSR     OFFSCRN
*STORE COLORS HERE
          LDA     #0
          STA     BACKGRND
          LDA     #L(MORPHO)
          STA     VECTORI
          LDA     #H(MORPHO)
          STA     VECTORI+1
          BNE     MOO                    ;RETURN FROM INT
