
*  END.S          CONTAINS THE END STATEMENT

END       DB      'GCC(C)1984'           ;LABEL TO SEE WHERE END OF ROM IS

          ORG     $FFF8
          DB      $FF,$C7                ;START AT $C000, + MARIA SIGNATURE
          DW      DLI                    ;INTERRUPT VECTOR
          DW      MAIN                   ;START VECTOR
          DW      NULLRTI                ;UNUSED VECTOR

          END

