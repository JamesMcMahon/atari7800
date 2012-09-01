FILL      MACRO   ADDR,DATA,COUNT        ;THIS FILLS AN AREA WITH A CONSTANT
          LDA     &DATA
          LDX     &COUNT
F&INDX    STA     &ADDR-1,X
          DEX
          BNE     F&INDX
          ENDM
LOAD      MACRO   ADDR1,ADDR2,COUNT      ;THIS MOVES DATA FROM ONE AREA TO ANOTH
          LDX     &COUNT
L&INDX    LDA     &ADDR2-1,X
          STA     &ADDR1-1,X
          DEX
          BNE     L&INDX
          ENDM
PFILL     MACRO   ADDR,DATA,PAGENUM      ;THIS FILLS A NUMBER OF PAGES
          LDA     #H(&ADDR)              ;TEMP0 AND TEMP1 ARE USED
          STA     TEMP1
          LDA     #L(&ADDR)
          STA     TEMP0
          LDA     &DATA
          LDX     &PAGENUM
          JSR     PFILLIT
          ENDM
PLOAD     MACRO   ADDR,ADDR2,PAGENUM     ;THIS LOADS A NUMBER OF PAGES
          LDA     #H(&ADDR)              ;TEMP0 - TEMP3 ARE USED
          STA     TEMP1
          LDA     #L(&ADDR)
          STA     TEMP0
          LDA     #H(&ADDR2)
          STA     TEMP3
          LDA     #L(&ADDR2)
          STA     TEMP2
          LDX     &PAGENUM
          JSR     PLOADIT
          ENDM
