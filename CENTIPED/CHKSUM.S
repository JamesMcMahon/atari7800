          ORG     $3000

ZEROIT    LDA     #$80
          STA     ZEROLP1+2

          LDA     #$FF
          LDX     #0
ZEROLP1   STA     $8000,X
          INX
          BNE     ZEROLP1
          INC     ZEROLP1+2
          BNE     ZEROLP1
ZERODONE  JMP     ZERODONE


******************************************
EORIT     LDA     #$80
          STA     EORLP1+2

          LDA     #0
          LDX     #0
EORLP1    EOR     $8000,X
          INX
          BNE     EORLP1
          INC     EORLP1+2
          BNE     EORLP1
EORDONE   JMP     EORDONE



          END
