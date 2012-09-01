; SHSC.S
;         HIGH SCORE CARD INTERFACE FOR THE DESERT FALCON GAME
;
	org	$5000
;
;
MAXLEVEL  EQU     4                      ;MAX NO. OF DIFF LEVELS
;
;         DETERMINE IF THE HSC IS PRESENT
HSPOWNIT:
	LDA     #0                     ;    SET HSCIN FLAG TO ZERO,
	STA     HSCIN                  ;    INDICATING HSC IS NOT IN
	RTS                            ;  END PROC
;
;
;             THIS ROUTINE SETS UP HSC ARGUMENTS THAT DONT CHANGE
;             OR ARE SIMPLY DEFAULT SETTINGS
;
SETUPARG:
	rts
SETHSLST:
	rts
HSGAMOVR:
	rts
HSDISP:
	rts
SETDFNAM:
	rts
