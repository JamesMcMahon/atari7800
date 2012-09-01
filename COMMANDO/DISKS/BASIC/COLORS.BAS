10    REM *** COLOR CHANGE ***
20    DIM P%(1)
30    Y=INP(2)
40    IF Y=82 THEN R%=R%+1
50    IF Y=71 THEN G%=G%+1
60    IF Y=66 THEN B%=B%+1
70    IF R%=8 THEN R%=0
80    IF G%=8 THEN G%=0
90    IF B%=8 THEN B%=0
100   P%(0)=(R%*256)+(G%*16)+B%
120   DEFDBL X:X=1114
130   POKE X,VARPTR(P%(0))
140   PRINT R%;G%;B%
150   GOTO 30
