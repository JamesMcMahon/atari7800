* LINKS

          ZEROPAGE
          LINKGLBL                       public
          ELGLBL                         extrn
************* PRIORITIZED DOUBLY-LINKED LIST INSERTION SUBROUTINE **************

;ENTRY:   THE LOCATION PRIORITY SHOULD HAVE THE DISPLAY PRIORITY LEVEL OF THE
;         OBJECT DESIRED (0-4, ZERO BEING LOWEST (I.E. ROVER AND TANK CRATERS),
;         3 BEING THE HIGHEST OF THE AIR ENEMIES, 4 IS FOR ENEMY SHOTS)
;
;EXIT:    THE X REGISTER WILL HOLD AN $FF IF THERE IS NO ROOM FOR THE OBJECT,
;         OTHERWISE IT WILL HOLD THE INDEX TO BE USED IN THE EL-TABLES FOR THAT
;         OBJECT

;         THIS ROUTINE TRASHES THE ACCUMULATOR, AND THE X REGISTER

;NOTE: ALL THROUGHOUT THIS ROUTINE THE X REGISTER WILL CONTAIN THE INDEX TO
;      THE NEW ENTRY (NEW SLOT)

;GLOSSARY:

;         PNTRTOX                        INDEX TO NEW ENTRY (NEW SLOT)
;         PNTRTOY                        INDEX TO PREVIOUS ENTRY IN LIST
;         PNTRTOZ                        INDEX TO NEXT ENTRY IN LIST


******************************************
CODE9000  CSECT
LNKCMPLT
NOSLOTS
          PLA
          TAY
          RTS

LNKINSRT
          TYA
          PHA

          LDX     EMPTY
          CPX     #$FF
          BEQ     NOSLOTS                ;NO ROOM FOR ANYTHING

          STX     PNTRTOX                ;POINTER TO NEW SLOT
          LDA     ELFORLNK,X             ;GET POINTER TO NEXT EMPTY SLOT
          STA     EMPTY
          CMP     #$FF
          BEQ     DONEMPTY
          TAY
          LDA     #$FF
          STA     ELBAKLNK,Y


DONEMPTY
          LDY     PRIORITY               ;SHOULD HAVE ALREADY BEEN ANDED WITH 03
          LDA     PRIOR0,Y
          CMP     #$FF
          BEQ     NONTREES               ;BRANCH WHEN THERE ARE NO ENTRIES IN
                                         ;THE PRESENT PRIORITY LIST
FOUNDAY
          STA     PNTRTOY
          TAY
*         LDX     PNTRTOX
          STA     ELFORLNK,X             ;FORWARD LINK OF NEW ENTRY
          LDA     ELBAKLNK,Y             ;BACK POINTER OF NEXT ENTRY
          STA     PNTRTOZ
          STA     ELBAKLNK,X             ;BACK POINTER OF NEW ENTRY

          LDA     PNTRTOX
          STA     ELBAKLNK,Y             ;BACK POINTER OF NEXT ENTRY
          LDY     PRIORITY
          STA     PRIOR0,Y               ;SET PRIORITY POINTER TO POINT TO THE
                                         ;NEW ENTRY

          LDY     PNTRTOZ                ;UPDATE PREVIOUS ENTRY (IF ANY)
          CPY     #$FF                   ;WILL BE FF FOR SHOT LIST
          BEQ     NOPREV
          LDA     PNTRTOX
          STA     ELFORLNK,Y
NOPREV
          JMP     LNKCMPLT               ;ALL DONE!!


NONTREES                                 ;NO ENTRIES IN THIS PRIORITY LIST
          LDA     PNTRTOX                ;FIRST UPDATE PRIORITY POINTER TO NEW
          STA     PRIOR0,Y               ;ENTRY

ZINCY
          CPY     #$03                   ;NOW LOOK FOR SOME NEXT ENTRY
          BEQ     PREVENT                ;OOPS, NO NEXT ENTRY!!
          CPY     #$04                   ;FOR SHOT LIST, THERE IS NO PREVIOUS
          BEQ     ONLYONE                ;ENTRY
          INY
          LDA     PRIOR0,Y
          CMP     #$FF
          BEQ     ZINCY                  ;NO ENTRIES HERE!
          BNE     FOUNDAY

PREVENT                                  ;WELL,HAVE TO LOOK FOR A PREVIOUS ENTRY
          LDY     PRIORITY

ZDECY
          CPY     #$00
          BEQ     ONLYONE                ;THE NEW ENTRY IS THE ONLY ENTRY!!
          DEY
          LDA     PRIOR0,Y
          CMP     #$FF
          BEQ     ZDECY
FOUNDAZ                                  ;WELL,WE FOUND A PREVIOUS ENTRY
          STA     PNTRTOZ
          TAY
          STA     ELBAKLNK,X             ;UPDATE FOWARD POINTER OF NEW ENTRY
          LDA     #$FF
          STA     ELFORLNK,X             ;NO NEXT ENTRIES, REMEMBER
          LDA     PNTRTOX
          STA     ELFORLNK,Y             ;UPDATE FORWARD LINK OF PREVIOUS ENTRY
          JMP     LNKCMPLT               ;ALL DONE!!

ONLYONE
          LDA     #$FF
          STA     ELFORLNK,X
          STA     ELBAKLNK,X
          JMP     LNKCMPLT









************* PRIORITIZED DOUBLY-LINKED LIST DELETION SUBROUTINE ***************

;ENTRY:   THE X REGISTER SHOULD CONTAIN THE INDEX OF THE OBJECT THAT IS TO BE
;         DELETED FROM THE LIST
;
;         THIS ROUTINE TRASHES THE ACCUMULATOR

;NOTE: ALL THROUGHOUT THIS ROUTINE THE X REGISTER WILL CONTAIN THE INDEX TO
;      THE NEW ENTRY (NEW SLOT)

;GLOSSARY:

;         PNTRTOX                        INDEX TO DESIRED DELETED ENTRY
;         PNTRTOY                        INDEX TO PREVIOUS ENTRY IN LIST
;         PNTRTOZ                        INDEX TO NEXT ENTRY IN LIST


LNKDELET
          TYA
          PHA

          STX     PNTRTOX
          LDA     ELPRIOR,X
          AND     #$07
          STA     PRIORITY
          TAY

          LDA     ELBAKLNK,X             ;CAN BE FF
          STA     PNTRTOZ
          LDA     ELFORLNK,X             ;CAN BE FF
          STA     PNTRTOY

          LDA     PRIOR0,Y
          CMP     PNTRTOX
          BNE     NOTFIRST               ;BRANCH IF NOT FIRST ENTRY IN PRIORITY
                                         ;LIST

          LDY     PNTRTOY
          CPY     #$FF
          BEQ     APROK
          LDA     ELPRIOR,Y
          CMP     PRIORITY
          BEQ     APROK

          LDA     #$FF
          LDY     PRIORITY
          STA     PRIOR0,Y               ;MAKE SURE THIS PRIORITY POINTER
                                         ;DOESNT POINT TO AN ENTRY OF DIFFERENT
                                         ;PRIORITY
          JMP     NOTFIRST               ;BRANCH ALWAYS

APROK
          LDA     PNTRTOY                ;UPDATE PRIORITY POINTER IF IT POINTS
          LDY     PRIORITY
          STA     PRIOR0,Y               ;TO ENTRY THAT WILL BE DELETED
                                         ;CAN BE SET TO FF

NOTFIRST
          LDY     PNTRTOZ
          CPY     #$FF
          BEQ     NOZEE
          LDA     PNTRTOY
          STA     ELFORLNK,Y             ;CAN STORE AN FF
NOZEE
          LDY     PNTRTOY
          CPY     #$FF
          BEQ     NOWY
          LDA     PNTRTOZ
          STA     ELBAKLNK,Y             ;CAN STORE AN FF
NOWY
          LDA     PNTRTOX
          LDY     EMPTY
          CPY     #$FF
          BEQ     NOEMPTY                ;BRANCH IF NO EMPTY SLOTS EXIST
          STA     ELBAKLNK,Y
NOEMPTY
          STA     EMPTY
          TYA
          STA     ELFORLNK,X             ;CAN BE FF
          LDA     #$FF
          STA     ELBAKLNK,X             ;MUST BE FF

          PLA
          TAY
          RTS




********** PRIORITIZED DOUBLY-LINKED LIST INITIALIZATION SUBROUTINE ************

LINKINIT
          LDX     #ENEMLIST
          DEX
          LDA     #$FF
          STA     PRIOR0
          STA     PRIOR1
          STA     PRIOR2
          STA     PRIOR3
          STA     PRIOR4
          STA     FORWARD
LINKDEX
          LDA     FORWARD
          STA     ELFORLNK,X
          TXA
          STA     FORWARD
          SEC
          SBC     #$01
          STA     ELBAKLNK,X
          DEX
          BPL     LINKDEX

          LDA     #$00
          STA     EMPTY                  ;POINTS TO BEGINNING OF LIST

          RTS
          END
