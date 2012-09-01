                                                                PAGE   1
-------- Linker V5.5 --------------------------------------- FutureData --------

Addr    Section  File      Length

8000    CODE3    HOLEHIT.A  0162
8162    CODE3    FOOD.A     1D84 A
9EE6    CODE3    WALLDRAW.A 00E5 A
B000    CODE1    MAIN.A     04BD
B4BD    CODE1    GOD.A      00EB A
B5A8    CODE1    ATTRACT.A  00AD A
B655    CODE1    SOUND.A    01E4 A
B839    CODE1    CHEFHIT.A  00BE A
B8F7    CODE1    CONEHIT.A  00FC A
B9F3    CODE1    FOODHIT.A  0199 A
BB8C    CODE1    NSELECT.A  02D9 A
BE65    CODE1    TEXT.A     0184 A
F000    CODE2    FOOD.A     0B63
FB63    CODE2    HISCORE.A  0140 A
FCA3    CODE2    FOODMOVE.A 02D3 A

                                                                PAGE   2
-------- Linker V5.5 --------------------------------------- FutureData --------



File-G     Section   Addr   Length



File-G     Section   Addr   Length



File-G     Section   Addr   Length
MAIN.A     CODE1     B000   04BD

           Publics
           CODE1    B000    COLRINIT B390    DLI1     B3C0    DLI4     B431
           DLLCOPY  B223    DOGAME   B189    DPPINIT  B264    DPPSTORE B26C
           GAME     B090    GAMEINIT B279    GLCONT21 B1C7    GODPTR   00E2
           NEWGAME  B026    NEWRACK  B05E    NMIRTN   B3BA    PREFRESH B39C
                                                                                                                                                                                                                                                                AA
 AE40 AA
 AE41 FF
 AE42 55
 AE43 AA
               ;
               ;       THE FOLLOWING 3 ROUTINES ARE USE*TO SAVE PAGES 2,3                                                                 PAGE   1
------0    MKAREJOY 811F    MKREJOY  812C



File       Section   Addr   Length
FOOD.A     CODE3     8162   1D84
           CODE2     F000   0B63

           Publics
           ADDSCORE 8F5C    ADIRTABH F10F    ADIRTABL F10B    AFDERASE 85AB
           AIRDIRA  1E49    AIRDIRB  1E89    AIRDIRC  1EC9    AIRDIRD  1F09
           AIRTHROW 1F49    ALLGONE  2688    ANGLE    0012    ASET     1F89
           ATUNE10F F7B1    ATUNE11F F7BD    ATUNE12F F7CC    ATUNE13F F7F6
           AUDC0    0015    AUDF0    0017    AUDV0    0019    AUDV1    001A
           BACKCOLR 0000    BACKGRND 0020    BANFLY   F37A    BANFLYPW F382
           BLOCK1   00A0    BLOCK2   00E0    BOTWHGH  00E0    CACOUNT  2483
           CARRIED  0008    CARRYING 0002    CCHEADS  F251    CCRUNL   F25F
           CDIR     2383    CFLYTIME 24A3    CFRAME   2443    CHARBASE 0034
           CHARHITE F4A1    CHARINIT 91DF    CHASE    8A36    CHEFMOVE 85C4
           CHEFSTRT 0003    CHHEADS  F34A    CHSTAMP  2303    CHUCK    8162
           CINDEX0  265C    CINFO    2343    CLEARALL 9E40    CLOWMAP1 2260
           CLOWMAP2 2271    CLRSCRN  943A    CMAP1    2248    CMAP2    2250
           CMAPHIGH 2258    CODE2    F000    COLORROM F075    COLORS   1FC3
           CORNPALW 001E    CPALW    2283    CREATOR  24C3    CSECOND  2323
           CSINDEX  2423    CSPEED   2463    CSTAMP   22E3    CSTATE   007F
           CTEXT1   F13B    CTEXT2   F13D    CTEXT3   F14B    CTEXT4   F152
           CTLSWA   0281    CTLSWB   0283    CTRL     003C    CTRLTABL F658
           CTYPE    2363    CURRENT  00E0    CXPOS    00BF    CXPOSL   22A3
           CXSPEED  23E3    CXSPEEDL 2403    CYCLECNT 0078    CYCLEIDX 00F5
           CYPOS    009F    CYPOSL   22C3    CYSPEED  23A3    CYSPEEDL 23C3

                                                                PAGE   3
-------- Linker V5.5 --------------------------------------- FutureData --------

           DCH0     2656    DCH1     2657    DEAD     0001    DIRTABH  F107
           DIRTABL  F103    DLIADR   0040    DLIST0   1800                                                                                                                                                                                                                                                                AA
 AE40 AA
 AE41 FF
 AE42 55
 AE43 AA
               ;
               ;       THE FOLLOWING 3 ROUTINES ARE USE*TO SAVE PAGES 2,3                                                                 PAGE   1
------
           DLIST9   1C11    DLISTA   1CF5    DLISTB   1CFA    DLLRAM   1F8A
           DLLROM   F0B5    DOITOVER 00FC    DPPH     002C    DPPL     0030
           DRAWLOGO 9C8D                                                                                                                                                                                                                                                                AA
 AE40 AA
 AE41 FF
 AE42 55
 AE43 AA
               ;
               ;       THE FOLLOWING 3 ROUTINES ARE USE*TO SAVE PAGES 2,3                                                                 PAGE   1
------08    DYFCHAR  F467    DYHCHAR  F4C1
           DYHERO   000A    DYHOLE   0002    FALLING  0009    FALLSND  F4AE
           FALSE    0000    FCENTERY F45A    FEETFALL 0009    FEETRISE 000E
           FINFO    261E    FLYCHAR  F5C5    FLYING   0007    FLYPALW  F5CA
           FOODSTRT 000F    FOODSTUF 268F    FOODWORD F11D    FPPAUSE  00FF
           FPRESET  00FD    FPSELECT 00FE    FRAMECNT 0076    FSPEED   0002
           FSTATE   2603    FXPOS    25CC    FYPOS    25E8    GAMECNT  00E4
           GOALX    00F3    GOALY    00F4    HATHITE  000A    HEADHITE 0005
           HELDFOOD 24F1    HIGHEST  00E8    HIGHSCOR 2689    HJOYDIR  00FA
           HOLEUSED 24A3    HOWHARD  00E7    HSCRAM   1800    HSPLAT   0015
           HTHROW   00FB    HYCENTER F4BD    ICEMELT  8B2E    INPT4    000C
           INTIM    0284    IRCCNT   1CFC    IRCHTIME 1E47    IRDIRA   1D07
           IRDIRB   1D47    IRDIRC   1D87    IRDIRD   1DC7    IRDXHERO 000F
           IRDYHERO 0016    IRTHROW  1E07    IRTNDONE 1D06    JOYDIR   00F9
           JOYTABLE 9E6A    LASTCHEF 268E    LASTPILE 2691    LEAVING  0010
           LISTPTR  0042    LISTPTRA 0044    LISTSIZE 0046    LISTSTRT 0051
           LISTTABH F09F    LISTTABL F094    LLCORNER 009E    LOGO     9CF7
           LRCORNER 009C    LWALL    00A0    M160X2   0040    M2BYTE   0050
           M320X1   0043    MATTRACT 0002    MAXCYCLE 007A    MBLANK   0008
           MENDGAME 0004    MENTER   0005    MGAME    0000    MHISCORE 0003
           MKLOGO   9B92    MLOADER  9A4B    MLOGO    0001    MNODMA   0060
           MODE     007E    MOVE     8E0A    MPAUSE   0006    MPTRH    0064
           MPTRL    0063    MSELECT  000A    MSTAT    0028    MTEXT    0009
           MUNCHHI  F27F    MUNCHLOW F279    MUNCHPW  F285    NEXTPILE 2690
           NULL2    002F    NULLCHAR 00BE    NULLLIST F0F3    NUMCHHIT 2660
           NUMCYCLE 0079    NUMEPILE 0010    NUMFALL  268D    NUMFOOD  0010
           NUMHOLES 000A    NUMINAIR 2687    NUMSTUCK 2686    OFFSET   0038
           OLDDIR   24FE    OLDFCNT  0077    OTHER    00E6    P0C1     0021
           P0C2     0022    P0C3     0023    P1C1     0025    P1C2     0026
           P1C3     0027    P5C1     0035    P5C2     0036    P5C3     0037
           PEAFLY   F38A    PIEFLY   F36A    PIEFLYPW F372    PILEHIT  8C14
           PILESTRT 0001    PL0BCD   267C    PL0BONUS 266D    PL0CARRY 267A
           PL0FIRST 2680    PL0IRTIM 2682    PL0LIVES 2678    PL0RACK  2675
           PL0SCORE 2665    PL1BCD   267E    PL1BONUS 2671    PL1CARRY 267B
           PL1FIRST 2681    PL1IRTIM 2683    PL1LIVES 2679    PL1RACK  2676
           PL1SCORE 2669    PLAYNUM  00DF    PLBANAN  2677    PLBCD    00ED
           PLCARRY  00EB    PLFIRST  2684    PLLIVES  00EC    PLMESS   2685
           PLRACK   00EA    PPTRH    F06B    PPTRL    F061    PRYOR                                                                                                                                                                                                                                                                AA
 AE40 AA
 AE41 FF
 AE42 55
 AE43 AA
               ;
               ;       THE FOLLOWING 3 ROUTINES ARE USE*TO SAVE PAGES 2,3                                                                 PAGE   1
------REJOYING 0016    RESREADY 00F0    RETREAT  0014    RISEPALW F213
           RLEAVING 0017    RUNLOAD  00E1    RUNNING  0000    RWALL    00A1
           SCORELST 2200    SCOREX   F40F    SELREADY 00F1    SELTEXT1 F127
           SELTEXT2 F136    SIDEPALW 001F    SPLAT    000C    SPLATCH  F38D
           SPLATPW  F392    STATATTR 0011    STATBON  0004    STATCOMB 0015
           STATDIE  0006    STATDIEH 0005    STATDISP 938C    STATEND  0013
           STATENDR 0014    STATHIT  0008    STATINIT 0000    STATLIST 2211

                                                                PAGE   4
-------- Linker V5.5 --------------------------------------- FutureData --------

           STATLOGO 0010    STATPLAY 0002    STATREPL 0012    STATUS   007D
           STATWAIT 0001    STATWON  0003    STHEADCH 00B2    STICKING 0013
           STUKXPOS F481    STUKYPOS F491    SWCHA    0280    SWCHB    0282
           SWLIST   F0EE    SYSCOUNT 007B    TAKEFOOD 8D18    TEMP0    005C
           TEMP1    005D    TEMP2    005E    TEMP3    005F    TEMP4    0060
           TEMP5    0061    TEMP6    0062    TEMPX    0068    TEMPY    0069
           TEXT0    F000    TEXT1    F00D    TEXT2    F014    TEXT4    F01D
           TEXT5    F02B    TEXT6    F031    TEXT8    F040    TEXT9    F046
           TEXTLEN  F04D    TEXTPOS  F057    TEXTTM1  9E7E    THREADY  00F2
           THROWBUT 00F8    THROWIDX 00F7    THRWTIME 24E3    THRWTUFF 250C
           TINDEX0  265A    TINDEX1  265B    TOPWHGH  00D1    TOPZONE  F0AA
           TRUE     00FF    TRUEBUT  F0FB    TUNNUM   2658    TUNNUM1  2659
           TUNTEMP  0060    TXTLIST1 221D    TXTLIST2 222B    TXTLIST3 223A
           ULCORNER 0098    URCORNER 009A    VINDEX0  265E    VINDEX1  265F
           WAITCNT  00E5    WALLPALW 0010    WHORIZ   00A2    WON      0003
           WSYNC    0024    XCLOSE   0011    XDMAOFF  903C    XDMAON   9049
           XLEFT    0000    XRIGHT   00A0    XVECTORH F3AF    XVECTORL F3CF
           YCENTER  000A    YVECTORH F619    YVECTORL F3EF    ZTUNE0F  F69A
           ZTUNE0V  F716    ZTUNE10V F7BC    ZTUNE11V F7C7    ZTUNE12V F7F5
           ZTUNE13V F80D    ZTUNE14F F80E    ZTUNE14V F817    ZTUNE15F F818
           ZTUNE15V F827    ZTUNE16F F828    ZTUNE16V F836    ZTUNE17F F837
           ZTUNE17V F85F    ZTUNE18F F860    ZTUNE18V F86F    ZTUNE19F F870
           ZTUNE19V F88B    ZTUNE1F  F6F1    ZTUNE1V  F716    ZTUNE20F F88C
           ZTUNE20V F8A1    ZTUNE21F F8A2    ZTUNE21V F8CC    ZTUNE22F F8C2
           ZTUNE22V F8CD    ZTUNE23F F8CE    ZTUNE23V F9CE    ZTUNE24F F951
           ZTUNE24V F9CF    ZTUNE25F F9D0    ZTUNE25V FA75    ZTUNE26F FA76
           ZTUNE26V FAE5    ZTUNE27F FAE6    ZTUNE27V FAEF    ZTUNE28F FAF0
           ZTUNE28V FB12    ZTUNE29F FB01    ZTUNE29V FB13    ZTUNE2F  F70A
           ZTUNE2V  F716    ZTUNE30F FB14    ZTUNE30V F716    ZTUNE31F FB31
           ZTUNE31V FB13    ZTUNE32F FB50    ZTUNE32V FB13    ZTUNE3F  F717
           ZTUNE3V  F725    ZTUNE4F  F732    ZTUNE4V  F735    ZTUNE5F  F73C
           ZTUNE5V  F73E    ZTUNE6F  F73F    ZTUNE6V  F755    ZTUNE7F  F765
           ZTUNE7V  F789    ZTUNE8F  F779    ZTUNE8V  F789    ZTUNE9F  F78A
           ZTUNE9V  F79E


File-G     Section   Addr   Length
GOD.A      CODE1     B4BD   00EB

           Publics
           GOD      B4BD    PAUSE    B516    POLLALL  B55B


File-G     Section   Addr   Length
ATTRACT.A  CODE1     B5A8   00AD

           Publics
           ATTRACT  B5A8    MKAUTO   B634


File-G     Section   Addr   Length
HISCORE.A  CODE2     FB63   0140

           Publics
           HSCROM   FBE6    HSCRTN   FC81    MKENTER  FB76    MKHISCOR FB63

                                                                PAGE   5
-------- Linker V5.5 --------------------------------------- FutureData --------




File-G     Section                                                                                                                                                                                                                                                                AA
 AE40 AA
 AE41 FF
 AE42 55
 AE43 AA
               ;
               ;       THE FOLLOWING 3 ROUTINES ARE USE*TO SAVE PAGES 2,3     URCORNER 009A        B7F7    VBASEH   B818


File-G     Section   Addr   Length
CHEFHIT.A  CODE1     B839   00BE

           Publics
           CHEFHIT  B839    HEROKILL B89E    MKDIE    B8D9


File-G     Section   Addr   Length
CONEHIT.A  CODE1     B8F7   00FC

           Publics
           CONEHIT  B8F7    HWIN     B922


File-G     Section   Addr   Length
FOODHIT.A  CODE1     B9F3   0199

           Publics
           ERASEIT  BB7F    FOODHIT  B9F3    MKSPLAT  BB54


File-G     Section   Addr   Length
FOODMOVE.A CODE2     FCA3   02D3

PLRACK **duplicate public in FOODMOVE.A
           Publics
           FOODMOVE FCA3


File-G     Section   Addr   Length
NSELECT.A  CODE1     BB8C   02D9

           Publics
           MKSELECT BB8C    SELECT   BC49


File-G     Section   Addr   Length
TEXT.A     CODE1     BE65   0184

           Publics
           MKPROMPT BE65    PROMPT   BF7E


File-G     Section   Addr   Length

                                                                PAGE   6
-------- Linker V5.5 --------------------------------------- FutureData --------

WALLDRAW.A CODE3     9EE6   00E5

           Publics
           AWOLDRAW 9EE6


Entry point 0000

