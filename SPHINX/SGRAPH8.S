*         SPHINX  SGRAPH8.S
* THE GRAPHICS ARE ORGANIZED AS FOLLOWS:
* 8000 - 8FFF ARE ALL CHARACTERS (16 PAGES)  SOME ARE 8 HIGH AND SOME ARE 16
*         WITH THE FONT AND THE HEIROS IN THE TOP 8 AND THE TITLE PAGE CHARS IN
*         THE BOTTOM 8 PAGES
* A000 - AFFF ARE ALL GRAPHICS (16 PAGES)  INCLUDING SCROLLING STAMPS
* C000 - CFFF ARE ????
*GROUND CHARACTERS 192 AND 214 ARE NOT NEEDED.   4/20/84   JM
*ONLY LETTERS WE NEED IN 320 FONT IS P,L,A,Y,E,R O,N T,W V,I,C S,D X G

;          ZERODEF

          ORG     $8000
;ALL CHARS ARE 16X8
CHARS:
NUMBERS:
ZERO0:		.dc.b      $38                    ;ZERO0
		.dc.b      $7E
		.dc.b      $FE
THREE3:		.dc.b      $7C
		.dc.b      $0C
		.dc.b      $78
		.dc.b      $38
		.dc.b      $30
		.dc.b      $38
		.dc.b      $78

LCANE:    .dc.b      $00,$70                ;LCANE,RCANE
LMWS:     .dc.b      $16,$60                ;LMWS,RMWS
LFEATH:   .dc.b      $00,$60                ;LFEATH,RFEATH
LEYE:     .dc.b      $1F,$00                ;LEYE,REYE
LPAUSE:   .dc.b      $00,$00                ;LPAUSE,RPAUSE    TO BE NUKED
LAHNK:    .dc.b      $01,$80                ;LAHNK,RAHNK
LBIRD:    .dc.b      $09,$00                ;LBIRD,RBIRD

          .dc.b      $00,$00                ;25  ALL CHARS START HERE
          .dc.b      $00,$00                ;27
          .dc.b      $00,$00                ;29
          .dc.b      $00,$00                ;31
          .dc.b      $00,$00                ;33
          .dc.b      $00,$00                ;35
          .dc.b      $00,$00                ;37
          .dc.b      $00,$00                ;39
          .dc.b      $00,$00                ;41
          .dc.b      $00,$00                ;43
          .dc.b      $00,$00                ;45
          .dc.b      $00,$20                ;47
          .dc.b      $00,$10                ;49
          .dc.b      $00,$00                ;51
          .dc.b      $00,$00                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $00,$00                ;57
          .dc.b      $00,$00                ;59
          .dc.b      $00,$00                ;61
          .dc.b      $04,$10                ;63
          .dc.b      $00,$00                ;65
          .dc.b      $00,$00                ;67
          .dc.b      $00,$00                ;69
          .dc.b      $00,$00                ;71
          .dc.b      $00,$00                ;73
          .dc.b      $00,$00                ;75
          .dc.b      $00,$00                ;77
          .dc.b      $FF,$F8                ;79
          .dc.b      $FF,$FB                ;81
          .dc.b      $00,$00                ;83
          .dc.b      $3F,$FB                ;85
          .dc.b      $00,$00                ;87
          .dc.b      $00,$00                ;89
          .dc.b      $0F,$FB                ;91
          .dc.b      $FF,$FB                ;93
          .dc.b      $3F,$FB                ;95
          .dc.b      $00,$00                ;97
          .dc.b      $00,$00                ;99
          .dc.b      $00,$00                ;101
          .dc.b      $FF,$F8                ;103
          .dc.b      $00,$00                ;105
          .dc.b      $00,$00                ;107
          .dc.b      $01,$00                ;109
          .dc.b      $FF,$00                ;111
          .dc.b      $3F,$FB                ;113
          .dc.b      $00,$00                ;115
          .dc.b      $FF,$FC                ;117
          .dc.b      $00,$00                ;119
          .dc.b      $00,$00                ;121
          .dc.b      $00,$00                ;123
          .dc.b      $FF,$FB                ;125
          .dc.b      $FF,$EC                ;127
          .dc.b      $00,$00                ;129
          .dc.b      $3F,$FB                ;131
          .dc.b      $FF,$FB                ;133
          .dc.b      $FF,$F8                ;135
          .dc.b      $FF,$FB                ;137
          .dc.b      $00,$00                ;139
          .dc.b      $FF,$FB                ;141
          .dc.b      $FF,$FB                ;143
          .dc.b      $FF,$FB                ;145
          .dc.b      $00,$00                ;147
          .dc.b      $00,$00                ;149
          .dc.b      $00,$00                ;151
          .dc.b      $FF,$FB                ;153
          .dc.b      $FF,$FB                ;155
          .dc.b      $00,$00                ;157
          .dc.b      $00,$00                ;159
          .dc.b      $00,$00                ;161
          .dc.b      $FF,$FB                ;163
          .dc.b      $00,$00                ;165
          .dc.b      $3F,$F8                ;167
          .dc.b      $3F,$FB                ;169
          .dc.b      $00,$00                ;171
          .dc.b      $00,$00                ;173
          .dc.b      $3F,$FB                ;175
          .dc.b      $00,$00                ;177
BLANKCHR:
          .dc.b      $00,$00                ;179 THIS IS ALSO A BLANK CHAR
          .dc.b      $FF,$FB                ;181
          .dc.b      $FF,$FB                ;183
          .dc.b      $FF,$FB                ;185
          .dc.b      $FF,$FB                ;187
          .dc.b      $3F,$FB                ;189
          .dc.b      $FF,$F8                ;191
TWOBYTES: .dc.b      $00,$30                ;193    TWO FREE BYTES
          .dc.b      $FF,$F8                ;195
          .dc.b      $FF,$00                ;197
          .dc.b      $00,$40                ;299
          .dc.b      $00,$00                ;201
          .dc.b      $FF,$FB                ;203
          .dc.b      $00,$00                ;205
          .dc.b      $FF,$FB                ;207
          .dc.b      $3F,$FB                ;209
          .dc.b      $FF,$F8                ;211
          .dc.b      $FF,$FB                ;213
BARCON:   .dc.b      $E0                    ;214 BARCON

CRIGHT:   .dc.b      $7C                    ;215    CRIGHT  COPYRIGHT
XTRA:     .dc.b      $46                    ;XTRA LIFE     216

AA:       .dc.b      $C6                    ;A             217
B:        .dc.b      $FC                    ;B             218
C:        .dc.b      $70                    ;C             219
D:        .dc.b      $F8                    ;D             220
E:        .dc.b      $FE                    ;E             221
F:        .dc.b      $C0                    ;F             222
G:        .dc.b      $3E                    ;G             223
H:        .dc.b      $C6                    ;H             224
I:        .dc.b      $7E                    ;I             225
J:        .dc.b      $38                    ;J             226
K:        .dc.b      $CE                    ;K             227
L:        .dc.b      $FE                    ;L             228
M:        .dc.b      $C6                    ;M             229
N:        .dc.b      $C6                    ;N             230
O:        .dc.b      $38                    ;O             231
P:        .dc.b      $C0                    ;P             232
Q:        .dc.b      $36                    ;Q             233
R:        .dc.b      $CE                    ;R             234
S:        .dc.b      $7C                    ;S             235
T:        .dc.b      $18                    ;T             236
U:        .dc.b      $7C                    ;U             237
V:        .dc.b      $10                    ;V             238
W:        .dc.b      $6C                    ;W             239
X:        .dc.b      $C6                    ;X             240
Y:        .dc.b      $30                    ;Y             241
Z:        .dc.b      $FE                    ;Z             242
QUEST:    .dc.b      $18                    ;QUEST         243
EXCLAM:   .dc.b      $30                    ;EXCLAM        244
HYPHEN:   .dc.b      $00                    ;HYPHEN        245

JEWCON:   .dc.b      $10                    ;JEWCON
EGGCON:   .dc.b      $00                    ;EGGCON
LSUN:     .dc.b      $66,$66                ;LSUN,RSUN              248,249
LBOWL:    .dc.b      $07,$C0                ;LBOWL,RBOWL            250,251
PLUS:     .dc.b      $00                    ;PLUS                   252
EQUALS:   .dc.b      $00                    ;EQUALS                 253
LCLEAR:   .dc.b      $00,$00                ;LCLEAR,RCLEAR    TO BE 254,255 NUKED
                                         ;THIS BANK IS FULL!!!

          ORG     $8100
          .dc.b      $EE                    ;NUMS              TW0
          .dc.b      $18
          .dc.b      $C0
          .dc.b      $CE
          .dc.b      $0C
          .dc.b      $EE
          .dc.b      $EE
          .dc.b      $30
          .dc.b      $EE
          .dc.b      $0C

          .dc.b      $00,$70                ;LCANE,RCANE
          .dc.b      $12,$20                ;LMWS,RMWS
          .dc.b      $00,$60                ;LFEATH,RFEATH
          .dc.b      $61,$80                ;LEYE,REYE
          .dc.b      $00,$00                ;LPAUSE,RPAUSE
          .dc.b      $01,$80                ;LAHNK,RAHNK
          .dc.b      $04,$80                ;LBIRD

          .dc.b      $01,$00                ;25
          .dc.b      $01,$00                ;27
          .dc.b      $01,$00                ;29
          .dc.b      $01,$00                ;31
          .dc.b      $01,$02                ;33
          .dc.b      $01,$00                ;35
          .dc.b      $01,$00                ;37
          .dc.b      $01,$00                ;39
          .dc.b      $01,$00                ;41
          .dc.b      $01,$02                ;43
          .dc.b      $01,$00                ;45
          .dc.b      $01,$00                ;47
          .dc.b      $01,$02                ;49
          .dc.b      $01,$00                ;51
          .dc.b      $01,$00                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $01,$00                ;57
          .dc.b      $01,$00                ;59
          .dc.b      $01,$00                ;61
          .dc.b      $41,$00                ;63
          .dc.b      $11,$00                ;65
          .dc.b      $01,$00                ;67
          .dc.b      $01,$00                ;69
          .dc.b      $01,$00                ;71
          .dc.b      $01,$00                ;73
          .dc.b      $01,$00                ;75
          .dc.b      $F1,$00                ;77
          .dc.b      $FF,$FC                ;79
          .dc.b      $FF,$FF                ;81
          .dc.b      $01,$00                ;83
          .dc.b      $2F,$FF                ;85
          .dc.b      $01,$00                ;87
          .dc.b      $01,$00                ;89
          .dc.b      $03,$FF                ;91
          .dc.b      $FF,$FF                ;93
          .dc.b      $3F,$FF                ;95
          .dc.b      $01,$03                ;97
          .dc.b      $01,$00                ;99
          .dc.b      $01,$00                ;101
          .dc.b      $3F,$FF                ;103
          .dc.b      $C1,$00                ;105
          .dc.b      $C0,$00                ;107
          .dc.b      $00,$00                ;109
          .dc.b      $FF,$00                ;111
          .dc.b      $3F,$FF                ;113
          .dc.b      $01,$00                ;115
          .dc.b      $FF,$C0                ;117
          .dc.b      $00,$03                ;119
          .dc.b      $C1,$00                ;121
          .dc.b      $01,$00                ;123
          .dc.b      $FF,$FF                ;125
          .dc.b      $FF,$F0                ;127
          .dc.b      $01,$03                ;129
          .dc.b      $3F,$FF                ;131
          .dc.b      $FF,$FF                ;133
          .dc.b      $FF,$FC                ;135
          .dc.b      $FF,$FF                ;137
          .dc.b      $01,$00                ;139
          .dc.b      $FF,$FF                ;141
          .dc.b      $FF,$FF                ;143
          .dc.b      $FF,$FF                ;145
          .dc.b      $C1,$00                ;147
          .dc.b      $01,$00                ;149
          .dc.b      $C1,$00                ;151
          .dc.b      $FF,$FF                ;153
          .dc.b      $FF,$FF                ;155
          .dc.b      $01,$03                ;157
          .dc.b      $F1,$00                ;159
          .dc.b      $01,$00                ;161
          .dc.b      $FF,$FF                ;163
          .dc.b      $00,$03                ;165
          .dc.b      $FF,$FC                ;167
          .dc.b      $FF,$FF                ;169
          .dc.b      $00,$03                ;171
          .dc.b      $FC,$43                ;173
          .dc.b      $3F,$FF                ;175
          .dc.b      $00,$03                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $FF,$FF                ;181
          .dc.b      $FF,$FF                ;183
          .dc.b      $FF,$FF                ;185
          .dc.b      $FF,$FF                ;179
          .dc.b      $FF,$FF                ;189
          .dc.b      $FF,$FF                ;191
          .dc.b      $C4,$FF                ;193
          .dc.b      $FF,$FF                ;195
          .dc.b      $FF,$40                ;197
          .dc.b      $F1,$FF                ;199
          .dc.b      $F0,$4F                ;201
          .dc.b      $FF,$FF                ;203
          .dc.b      $F3,$0F                ;205
          .dc.b      $FF,$FF                ;207
          .dc.b      $3F,$FF                ;209
          .dc.b      $FF,$FF                ;211
          .dc.b      $FF,$FF                ;213
          .dc.b      $D0                    ;214    BARCON

          .dc.b      $82                    ;CRIGHT
          .dc.b      $EE                    ;XTRA

          .dc.b      $C6                    ;A
          .dc.b      $C6                    ;B
          .dc.b      $DC                    ;C
          .dc.b      $CC                    ;D
          .dc.b      $C0                    ;E
          .dc.b      $C0                    ;F
          .dc.b      $E6                    ;G
          .dc.b      $C6                    ;H
          .dc.b      $18                    ;I
          .dc.b      $CC                    ;J
          .dc.b      $CC                    ;K
          .dc.b      $FE                    ;L
          .dc.b      $C6                    ;M
          .dc.b      $C6                    ;N
          .dc.b      $EE                    ;O
          .dc.b      $C0                    ;P
          .dc.b      $EC                    ;Q
          .dc.b      $CC                    ;R
          .dc.b      $C6                    ;S
          .dc.b      $18                    ;T
          .dc.b      $EE                    ;U
          .dc.b      $38                    ;V
          .dc.b      $7C                    ;W
          .dc.b      $C6                    ;X
          .dc.b      $30                    ;Y
          .dc.b      $C6                    ;Z
          .dc.b      $00                    ;QUEST
          .dc.b      $00                    ;EXCLAM
          .dc.b      $00                    ;HYPHEN

          .dc.b      $38                    ;JEWCON
          .dc.b      $78                    ;EGGCON
          .dc.b      $19,$98                ;LSUN,RSUN
          .dc.b      $1F,$F0                ;LBOWL,RBOWL
          .dc.b      $18                    ;PLUS
          .dc.b      $00                    ;EQUALS
          .dc.b      $40,$E0                ;LCLEAR,RCLEAR

          ORG     $8200
          .dc.b      $E6                    ;NUMS                 THREE
          .dc.b      $18
          .dc.b      $60
          .dc.b      $04
          .dc.b      $FE
          .dc.b      $02
          .dc.b      $C6
          .dc.b      $30
          .dc.b      $EE
          .dc.b      $06

          .dc.b      $00,$70                ;LCANE,RCANE
          .dc.b      $13,$E8                ;LMWS,RMWS
          .dc.b      $00,$E0                ;LFEATH,RFEATH
          .dc.b      $CC,$FE                ;LEYE,REYE
          .dc.b      $00,$00                ;LPAUSE,RPAUSE
          .dc.b      $0F,$F0                ;LAHNK,RAHNK
          .dc.b      $03,$FC                ;LBIRD,RBIRD

          .dc.b      $00,$00                ;25
          .dc.b      $00,$00                ;27
          .dc.b      $00,$00                ;29
          .dc.b      $00,$00                ;31
          .dc.b      $00,$00                ;33
          .dc.b      $00,$01                ;35
          .dc.b      $00,$00                ;37
          .dc.b      $00,$02                ;39
          .dc.b      $00,$01                ;41
          .dc.b      $00,$00                ;43
          .dc.b      $00,$00                ;45
          .dc.b      $20,$00                ;47
          .dc.b      $00,$00                ;49
          .dc.b      $00,$00                ;51
          .dc.b      $80,$08                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $00,$00                ;57
          .dc.b      $00,$00                ;59
          .dc.b      $00,$10                ;61
          .dc.b      $00,$11                ;63
          .dc.b      $00,$00                ;65
          .dc.b      $00,$00                ;67
          .dc.b      $00,$10                ;69
          .dc.b      $00,$00                ;71
          .dc.b      $00,$00                ;73
          .dc.b      $00,$00                ;75
          .dc.b      $FF,$00                ;77
          .dc.b      $FF,$FC                ;79
          .dc.b      $FF,$FF                ;81
          .dc.b      $00,$00                ;83
          .dc.b      $07,$FF                ;85
          .dc.b      $00,$00                ;87
          .dc.b      $00,$00                ;89
          .dc.b      $00,$3F                ;91
          .dc.b      $FF,$FF                ;93
          .dc.b      $0F,$FF                ;95
          .dc.b      $00,$0F                ;97
          .dc.b      $00,$00                ;99
          .dc.b      $00,$00                ;101
          .dc.b      $0F,$EF                ;103
          .dc.b      $FC,$00                ;105
          .dc.b      $FC,$00                ;107
          .dc.b      $00,$00                ;109
          .dc.b      $FC,$00                ;111
          .dc.b      $0F,$FF                ;113
          .dc.b      $00,$00                ;115
          .dc.b      $FF,$00                ;117
          .dc.b      $00,$0F                ;119
          .dc.b      $C0,$00                ;121
          .dc.b      $C0,$00                ;123
          .dc.b      $FF,$FF                ;125
          .dc.b      $FC,$00                ;127
          .dc.b      $00,$3F                ;129
          .dc.b      $3F,$FF                ;131
          .dc.b      $FF,$FF                ;133
          .dc.b      $FF,$FC                ;135
          .dc.b      $FF,$FF                ;137
          .dc.b      $00,$00                ;139
          .dc.b      $FF,$FF                ;141
          .dc.b      $FF,$FF                ;143
          .dc.b      $FF,$FF                ;145
          .dc.b      $FC,$00                ;147
          .dc.b      $00,$00                ;149
          .dc.b      $F0,$00                ;151
          .dc.b      $FF,$FF                ;153
          .dc.b      $FF,$FF                ;155
          .dc.b      $00,$3F                ;157
          .dc.b      $FC,$00                ;159
          .dc.b      $00,$00                ;161
          .dc.b      $FF,$FF                ;163
          .dc.b      $00,$3F                ;165
          .dc.b      $FF,$FC                ;167
          .dc.b      $FF,$FF                ;169
          .dc.b      $04,$3F                ;171
          .dc.b      $FF,$FF                ;173
          .dc.b      $0F,$FF                ;175
          .dc.b      $00,$3F                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $FF,$FF                ;181
          .dc.b      $FF,$FF                ;183
          .dc.b      $FF,$FF                ;185
          .dc.b      $FF,$FF                ;187
          .dc.b      $FF,$FF                ;189
          .dc.b      $FF,$FF                ;191
          .dc.b      $FF,$FF                ;193
          .dc.b      $FF,$FF                ;195
          .dc.b      $FF,$00                ;197
          .dc.b      $FF,$FF                ;199
          .dc.b      $FF,$FF                ;201
          .dc.b      $FF,$FF                ;203
          .dc.b      $FF,$FF                ;205
          .dc.b      $FF,$FF                ;207
          .dc.b      $7F,$FF                ;209
          .dc.b      $FF,$FF                ;211
          .dc.b      $FF,$FF                ;213
          .dc.b      $C8                    ;214    BARCON

          .dc.b      $BA                    ;CRIGHT
          .dc.b      $7C                    ;XTRA
          .dc.b      $FE                    ;A
          .dc.b      $C6                    ;B
          .dc.b      $C0                    ;C
          .dc.b      $C6                    ;D
          .dc.b      $C0                    ;E
          .dc.b      $C0                    ;F
          .dc.b      $C6                    ;G
          .dc.b      $C6                    ;H
          .dc.b      $18                    ;I
          .dc.b      $CC                    ;J
          .dc.b      $D8                    ;K
          .dc.b      $C0                    ;L
          .dc.b      $C6                    ;M
          .dc.b      $CE                    ;N
          .dc.b      $C6                    ;O
          .dc.b      $F8                    ;P
          .dc.b      $DC                    ;Q
          .dc.b      $C8                    ;R
          .dc.b      $0E                    ;S
          .dc.b      $18                    ;T
          .dc.b      $C6                    ;U
          .dc.b      $6C                    ;V
          .dc.b      $D6                    ;W
          .dc.b      $6C                    ;X
          .dc.b      $30                    ;Y
          .dc.b      $60                    ;Z
          .dc.b      $08                    ;QUEST
          .dc.b      $30                    ;EXCLAM
          .dc.b      $00                    ;HYPHEN

          .dc.b      $7C                    ;JEWCON
          .dc.b      $E4                    ;EGGCON
          .dc.b      $00,$00                ;LSUN,RSUN
          .dc.b      $7F,$FC                ;LBOWL,RBOWL
          .dc.b      $18                    ;PLUS
          .dc.b      $7E                    ;EQUALS
          .dc.b      $40,$40                ;LCLEAR,RCLEAR

          ORG     $8300
          .dc.b      $D6                    ;NUMS          FOUR
          .dc.b      $18
          .dc.b      $38
          .dc.b      $38
          .dc.b      $CC
          .dc.b      $0E
          .dc.b      $DC
          .dc.b      $18
          .dc.b      $38
          .dc.b      $76

          .dc.b      $00,$70                ;LCANE,RCANE
          .dc.b      $1B,$E8                ;LMWS,RMWS
          .dc.b      $01,$E0                ;LFEATH,RFEATH
          .dc.b      $61,$80                ;LEYE,REYE
          .dc.b      $02,$00                ;LPAUSE,RPAUSE
          .dc.b      $03,$C0                ;LAHNK,RAHNK
          .dc.b      $07,$F0                ;LBIRD,RBIRD

          .dc.b      $00,$00                ;25
          .dc.b      $00,$00                ;27
          .dc.b      $00,$00                ;29
          .dc.b      $00,$00                ;31
          .dc.b      $00,$00                ;33
          .dc.b      $00,$20                ;35
          .dc.b      $00,$00                ;37
          .dc.b      $08,$00                ;39
          .dc.b      $00,$00                ;41
          .dc.b      $00,$00                ;43
          .dc.b      $00,$80                ;45
          .dc.b      $00,$82                ;47
          .dc.b      $00,$00                ;49
          .dc.b      $00,$00                ;51
          .dc.b      $02,$00                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $00,$00                ;57
          .dc.b      $00,$00                ;59
          .dc.b      $00,$01                ;61
          .dc.b      $04,$40                ;63
          .dc.b      $40,$00                ;65
          .dc.b      $00,$00                ;67
          .dc.b      $10,$00                ;69
          .dc.b      $00,$00                ;71
          .dc.b      $00,$00                ;73
          .dc.b      $00,$00                ;75
          .dc.b      $FF,$C0                ;77
          .dc.b      $FF,$E0                ;79
          .dc.b      $FF,$EF                ;81
          .dc.b      $00,$00                ;83
          .dc.b      $03,$2F                ;85
          .dc.b      $00,$00                ;87
          .dc.b      $00,$00                ;89
          .dc.b      $00,$03                ;91
          .dc.b      $FF,$EF                ;93
          .dc.b      $0F,$EF                ;95
          .dc.b      $00,$0F                ;97
          .dc.b      $3C,$00                ;99
          .dc.b      $00,$00                ;101
          .dc.b      $00,$FF                ;103
          .dc.b      $FF,$C0                ;105
          .dc.b      $FF,$E0                ;107
          .dc.b      $00,$04                ;109
          .dc.b      $FC,$00                ;111
          .dc.b      $03,$EF                ;113
          .dc.b      $00,$00                ;115
          .dc.b      $FF,$00                ;117
          .dc.b      $00,$2F                ;119
          .dc.b      $C0,$00                ;121
          .dc.b      $C0,$00                ;123
          .dc.b      $FF,$EF                ;125
          .dc.b      $C0,$00                ;127
          .dc.b      $00,$EF                ;129
          .dc.b      $0F,$EF                ;131
          .dc.b      $FF,$EF                ;133
          .dc.b      $FF,$E0                ;135
          .dc.b      $FF,$EF                ;137
          .dc.b      $00,$00                ;139
          .dc.b      $FF,$EF                ;141
          .dc.b      $FF,$EF                ;143
          .dc.b      $FF,$EF                ;145
          .dc.b      $FF,$C0                ;147
          .dc.b      $00,$00                ;149
          .dc.b      $F0,$00                ;151
          .dc.b      $FF,$EF                ;153
          .dc.b      $FF,$EF                ;155
          .dc.b      $00,$EF                ;157
          .dc.b      $FF,$00                ;159
          .dc.b      $00,$00                ;161
          .dc.b      $FF,$EF                ;163
          .dc.b      $03,$EF                ;165
          .dc.b      $FF,$EC                ;167
          .dc.b      $FF,$EF                ;169
          .dc.b      $00,$EF                ;171
          .dc.b      $FF,$EF                ;173
          .dc.b      $0F,$EF                ;175
          .dc.b      $0F,$EF                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $FF,$EF                ;181
          .dc.b      $FF,$EF                ;183
          .dc.b      $FF,$EF                ;185
          .dc.b      $FF,$EF                ;187
          .dc.b      $FF,$EF                ;189
          .dc.b      $FF,$EF                ;191
          .dc.b      $FF,$EF                ;193
          .dc.b      $FF,$EF                ;195
          .dc.b      $FF,$00                ;197
          .dc.b      $FF,$EF                ;199
          .dc.b      $FF,$EF                ;201
          .dc.b      $FF,$EF                ;203
          .dc.b      $FF,$EF                ;205
          .dc.b      $FF,$EF                ;207
          .dc.b      $3F,$EF                ;209
          .dc.b      $FF,$EF                ;211
          .dc.b      $FF,$EF                ;213
          .dc.b      $64                    ;214   BARCON

          .dc.b      $A2                    ;CRIGHT
          .dc.b      $38                    ;XTRA
          .dc.b      $C6                    ;A
          .dc.b      $FC                    ;B
          .dc.b      $C0                    ;C
          .dc.b      $C6                    ;D
          .dc.b      $F8                    ;E
          .dc.b      $F8                    ;F
          .dc.b      $CE                    ;G
          .dc.b      $FE                    ;H
          .dc.b      $18                    ;I
          .dc.b      $0C                    ;J
          .dc.b      $F0                    ;K
          .dc.b      $C0                    ;L
          .dc.b      $D6                    ;M
          .dc.b      $DE                    ;N
          .dc.b      $C6                    ;O
          .dc.b      $CE                    ;P
          .dc.b      $C6                    ;Q
          .dc.b      $F8                    ;R
          .dc.b      $3C                    ;S
          .dc.b      $18                    ;T
          .dc.b      $C6                    ;U
          .dc.b      $C6                    ;V
          .dc.b      $D6                    ;W
          .dc.b      $38                    ;X
          .dc.b      $30                    ;Y
          .dc.b      $30                    ;Z
          .dc.b      $0C                    ;QUEST
          .dc.b      $30                    ;EXCLAM
          .dc.b      $7C                    ;HYPHEN

          .dc.b      $C6                    ;JEWCON
          .dc.b      $F2                    ;EGGCON
          .dc.b      $03,$C0                ;LSUN,RSUN
          .dc.b      $FF,$FE                ;LBOWL,RBOWL
          .dc.b      $7E                    ;PLUS
          .dc.b      $00                    ;EQUALS
          .dc.b      $44,$00                ;LCLEAR,RCLEAR

          ORG     $8400
          .dc.b      $CE                    ;NUMS         FIVE
          .dc.b      $18
          .dc.b      $0C
          .dc.b      $04
          .dc.b      $6C
          .dc.b      $F8
          .dc.b      $C0
          .dc.b      $0C
          .dc.b      $EE
          .dc.b      $C6

          .dc.b      $0E,$70                ;LCANE,RCANE
          .dc.b      $17,$F0                ;LMWS,RMWS
          .dc.b      $03,$E0                ;LFEATH,RFEATH
          .dc.b      $1F,$00                ;LEYE,REYE
          .dc.b      $06,$00                ;LPAUSE,RPAUSE
          .dc.b      $02,$40                ;LAHNK,RAHNK
          .dc.b      $0F,$C0                ;LBIRD,RBIRD

          .dc.b      $00,$04                ;25
          .dc.b      $00,$04                ;27
          .dc.b      $00,$04                ;29
          .dc.b      $00,$04                ;31
          .dc.b      $00,$84                ;33
          .dc.b      $00,$04                ;35
          .dc.b      $00,$04                ;37
          .dc.b      $00,$04                ;39
          .dc.b      $00,$04                ;41
          .dc.b      $00,$04                ;43
          .dc.b      $00,$04                ;45
          .dc.b      $00,$04                ;47
          .dc.b      $00,$04                ;49
          .dc.b      $00,$44                ;51
          .dc.b      $00,$04                ;53
          .dc.b      $00,$04                ;55
          .dc.b      $00,$04                ;57
          .dc.b      $00,$04                ;59
          .dc.b      $00,$04                ;61
          .dc.b      $40,$04                ;63
          .dc.b      $00,$04                ;65
          .dc.b      $00,$04                ;67
          .dc.b      $00,$04                ;69
          .dc.b      $00,$04                ;71
          .dc.b      $00,$04                ;73
          .dc.b      $00,$04                ;75
          .dc.b      $FF,$84                ;77
          .dc.b      $FF,$84                ;79
          .dc.b      $FF,$BF                ;81
          .dc.b      $00,$04                ;83
          .dc.b      $00,$07                ;85
          .dc.b      $00,$04                ;87
          .dc.b      $00,$04                ;89
          .dc.b      $00,$00                ;91
          .dc.b      $2F,$BF                ;93
          .dc.b      $0F,$BF                ;95
          .dc.b      $00,$3F                ;97
          .dc.b      $0F,$04                ;99
          .dc.b      $00,$04                ;101
          .dc.b      $00,$3F                ;103
          .dc.b      $FF,$BF                ;105
          .dc.b      $FF,$BF                ;107
          .dc.b      $10,$00                ;109
          .dc.b      $FF,$04                ;111
          .dc.b      $03,$BF                ;113
          .dc.b      $00,$04                ;115
          .dc.b      $FC,$04                ;117
          .dc.b      $00,$3F                ;119
          .dc.b      $F0,$04                ;121
          .dc.b      $F0,$04                ;123
          .dc.b      $FF,$BC                ;125
          .dc.b      $00,$04                ;127
          .dc.b      $0C,$BF                ;129
          .dc.b      $0F,$BF                ;131
          .dc.b      $FF,$BF                ;133
          .dc.b      $FF,$BC                ;135
          .dc.b      $FF,$BF                ;137
          .dc.b      $00,$04                ;139
          .dc.b      $FF,$BF                ;141
          .dc.b      $FF,$BF                ;143
          .dc.b      $FF,$BF                ;147
          .dc.b      $FF,$BF                ;147
          .dc.b      $00,$04                ;149
          .dc.b      $FF,$04                ;151
          .dc.b      $FF,$BF                ;153
          .dc.b      $FF,$BF                ;155
          .dc.b      $03,$BF                ;157
          .dc.b      $FF,$84                ;159
          .dc.b      $00,$04                ;161
          .dc.b      $FF,$BF                ;163
          .dc.b      $13,$BF                ;165
          .dc.b      $FF,$B0                ;167
          .dc.b      $FF,$BF                ;169
          .dc.b      $0F,$BF                ;171
          .dc.b      $FF,$BF                ;173
          .dc.b      $0F,$BF                ;175
          .dc.b      $FF,$BF                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $FF,$BF                ;181
          .dc.b      $FF,$BF                ;183
          .dc.b      $FF,$BF                ;185
          .dc.b      $FF,$BF                ;187
          .dc.b      $FF,$BF                ;189
          .dc.b      $FF,$BF                ;191
          .dc.b      $FF,$BF                ;193
          .dc.b      $FF,$BF                ;195
          .dc.b      $FF,$04                ;197
          .dc.b      $FF,$BF                ;199
          .dc.b      $FF,$BF                ;201
          .dc.b      $FF,$BF                ;203
          .dc.b      $FF,$BF                ;205
          .dc.b      $FF,$BF                ;207
          .dc.b      $FF,$BF                ;209
          .dc.b      $FF,$BF                ;211
          .dc.b      $FF,$BF                ;213
          .dc.b      $32                    ;214    BARCON

          .dc.b      $BA                    ;CRIGHT
          .dc.b      $70                    ;XTRA
          .dc.b      $6C                    ;A
          .dc.b      $C8                    ;B
          .dc.b      $C0                    ;C
          .dc.b      $C6                    ;D
          .dc.b      $C0                    ;E
          .dc.b      $C0                    ;F
          .dc.b      $C0                    ;G
          .dc.b      $C6                    ;H
          .dc.b      $18                    ;I
          .dc.b      $0C                    ;J
          .dc.b      $D0                    ;K
          .dc.b      $C0                    ;L
          .dc.b      $EE                    ;M
          .dc.b      $F6                    ;N
          .dc.b      $C6                    ;O
          .dc.b      $C6                    ;P
          .dc.b      $C6                    ;Q
          .dc.b      $CE                    ;R
          .dc.b      $E0                    ;S
          .dc.b      $18                    ;T
          .dc.b      $C6                    ;U
          .dc.b      $C6                    ;V
          .dc.b      $C6                    ;W
          .dc.b      $38                    ;X
          .dc.b      $38                    ;Y
          .dc.b      $18                    ;Z
          .dc.b      $06                    ;QUEST
          .dc.b      $30                    ;EXCLAM
          .dc.b      $00                    ;HYPHEN

          .dc.b      $BA                    ;JEWCON
          .dc.b      $FA                    ;EGGCON
          .dc.b      $07,$E0                ;LSUN,RSUN
          .dc.b      $FF,$FE                ;LBOWL,RBOWL
          .dc.b      $18                    ;PLUS
          .dc.b      $7E                    ;EQUALS
          .dc.b      $0C,$00                ;LCLEAR,RCLEAR

          ORG     $8500
          .dc.b      $EE                    ;NUMS           SIX
          .dc.b      $78
          .dc.b      $C6
          .dc.b      $CE
          .dc.b      $3C
          .dc.b      $C0
          .dc.b      $E0
          .dc.b      $CE
          .dc.b      $EE
          .dc.b      $EC

          .dc.b      $0E,$70                ;LCANE,RCANE
          .dc.b      $10,$00                ;LMWS,RMWS
          .dc.b      $03,$E0                ;LFEATH,RFEATH
          .dc.b      $40,$7E                ;LEYE,REYE
          .dc.b      $0E,$00                ;LPAUSE,RPAUSE
          .dc.b      $06,$60                ;LAHNK.RAHNK
          .dc.b      $0F,$80                ;LBIRD,RBIRD

          .dc.b      $00,$00                ;25
          .dc.b      $00,$00                ;27
          .dc.b      $00,$00                ;29
          .dc.b      $00,$40                ;31
          .dc.b      $00,$00                ;33
          .dc.b      $00,$50                ;35
          .dc.b      $00,$00                ;37
          .dc.b      $00,$00                ;39
          .dc.b      $02,$00                ;41
          .dc.b      $02,$00                ;43
          .dc.b      $00,$00                ;45
          .dc.b      $00,$00                ;47
          .dc.b      $00,$00                ;49
          .dc.b      $00,$00                ;51
          .dc.b      $20,$00                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $00,$00                ;57
          .dc.b      $00,$00                ;59
          .dc.b      $00,$01                ;61
          .dc.b      $01,$00                ;63
          .dc.b      $00,$00                ;65
          .dc.b      $00,$00                ;67
          .dc.b      $01,$00                ;69
          .dc.b      $00,$00                ;71
          .dc.b      $00,$00                ;73
          .dc.b      $00,$00                ;75
          .dc.b      $FB,$F0                ;77
          .dc.b      $F8,$00                ;79
          .dc.b      $FB,$FF                ;81
          .dc.b      $00,$00                ;83
          .dc.b      $00,$03                ;85
          .dc.b      $00,$00                ;87
          .dc.b      $00,$00                ;89
          .dc.b      $00,$00                ;91
          .dc.b      $03,$FF                ;93
          .dc.b      $0B,$FF                ;95
          .dc.b      $00,$3F                ;97
          .dc.b      $03,$00                ;99
          .dc.b      $00,$00                ;101
          .dc.b      $00,$0F                ;103
          .dc.b      $FB,$FF                ;105
          .dc.b      $FB,$FF                ;107
          .dc.b      $C0,$00                ;109
          .dc.b      $FB,$00                ;111
          .dc.b      $03,$FF                ;113
          .dc.b      $10,$3F                ;115
          .dc.b      $F8,$00                ;117
          .dc.b      $00,$FF                ;119
          .dc.b      $F0,$00                ;121
          .dc.b      $E0,$00                ;123
          .dc.b      $FB,$C0                ;125
          .dc.b      $00,$00                ;127
          .dc.b      $0B,$FF                ;129
          .dc.b      $3B,$FF                ;131
          .dc.b      $FB,$FF                ;133
          .dc.b      $FB,$F0                ;135
          .dc.b      $FB,$FF                ;137
          .dc.b      $00,$00                ;139
          .dc.b      $FB,$FF                ;141
          .dc.b      $FB,$FF                ;143
          .dc.b      $FB,$FF                ;145
          .dc.b      $FB,$FF                ;147
          .dc.b      $F0,$00                ;149
          .dc.b      $FF,$00                ;151
          .dc.b      $FB,$FF                ;153
          .dc.b      $FB,$FF                ;155
          .dc.b      $03,$FF                ;157
          .dc.b      $FB,$C0                ;159
          .dc.b      $F8,$00                ;161
          .dc.b      $FB,$FF                ;163
          .dc.b      $03,$FF                ;165
          .dc.b      $FB,$F4                ;167
          .dc.b      $FB,$FF                ;169
          .dc.b      $3B,$FF                ;171
          .dc.b      $FB,$FF                ;173
          .dc.b      $0B,$FF                ;175
          .dc.b      $FB,$FF                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $FB,$FF                ;181
          .dc.b      $FB,$FF                ;183
          .dc.b      $FB,$FF                ;185
          .dc.b      $FB,$FF                ;187
          .dc.b      $FB,$FF                ;189
          .dc.b      $FB,$FF                ;191
          .dc.b      $FB,$FF                ;193
          .dc.b      $FB,$FF                ;195
          .dc.b      $FB,$C0                ;197
          .dc.b      $FB,$FF                ;199
          .dc.b      $FB,$FF                ;201
          .dc.b      $FB,$FF                ;203
          .dc.b      $FB,$FF                ;205
          .dc.b      $FB,$FF                ;207
          .dc.b      $FB,$FF                ;209
          .dc.b      $FB,$FF                ;211
          .dc.b      $FB,$FF                ;213
          .dc.b      $1A                    ;214    BARCON

          .dc.b      $82                    ;CRIGHT
          .dc.b      $E4                    ;XTRA
          .dc.b      $78                    ;A
          .dc.b      $CC                    ;B
          .dc.b      $DC                    ;C
          .dc.b      $CC                    ;D
          .dc.b      $C0                    ;E
          .dc.b      $C0                    ;F
          .dc.b      $E0                    ;G
          .dc.b      $C6                    ;H
          .dc.b      $18                    ;I
          .dc.b      $0C                    ;J
          .dc.b      $C8                    ;K
          .dc.b      $C0                    ;L
          .dc.b      $C6                    ;M
          .dc.b      $E6                    ;N
          .dc.b      $EE                    ;O
          .dc.b      $CE                    ;P
          .dc.b      $EE                    ;Q
          .dc.b      $CE                    ;R
          .dc.b      $E6                    ;S
          .dc.b      $7E                    ;T
          .dc.b      $C6                    ;U
          .dc.b      $C6                    ;V
          .dc.b      $C6                    ;W
          .dc.b      $6C                    ;X
          .dc.b      $6C                    ;Y
          .dc.b      $CC                    ;Z
          .dc.b      $66                    ;QUEST
          .dc.b      $30                    ;EXCLAM
          .dc.b      $00                    ;HYPHEN

          .dc.b      $7C                    ;JEWCON
          .dc.b      $7A                    ;EGGCON
          .dc.b      $07,$E0                ;LSUN,RSUN
          .dc.b      $00,$00                ;LBOWL,RBOWL
          .dc.b      $18                    ;PLUS
          .dc.b      $00                    ;EQUALS
          .dc.b      $1C,$02                ;LCLEAR,RCLEAR

          ORG     $8600
          .dc.b      $38                    ;NUMS   SEVEN
          .dc.b      $38
          .dc.b      $7C
          .dc.b      $7C
          .dc.b      $1C
          .dc.b      $FE
          .dc.b      $38
          .dc.b      $FE
          .dc.b      $38
          .dc.b      $38

          .dc.b      $0F,$F0                ;LCANE,RCANE
          .dc.b      $39,$C0                ;LMWS,RMWS
          .dc.b      $03,$E0                ;LFEATH,RFEATH
          .dc.b      $3F,$C0                ;LEYE,REYE
          .dc.b      $7F,$80                ;LPAUSE,RPAUSE
          .dc.b      $06,$60                ;LAHNK.RAHNK
          .dc.b      $77,$00                ;LBIRD,RBIRD

          .dc.b      $10,$00                ;25
          .dc.b      $10,$40                ;27
          .dc.b      $10,$10                ;29
          .dc.b      $10,$00                ;31
          .dc.b      $10,$09                ;33
          .dc.b      $12,$08                ;35
          .dc.b      $10,$00                ;37
          .dc.b      $10,$40                ;39
          .dc.b      $10,$00                ;41
          .dc.b      $10,$00                ;43
          .dc.b      $10,$00                ;45
          .dc.b      $10,$00                ;47
          .dc.b      $10,$40                ;49
          .dc.b      $10,$00                ;51
          .dc.b      $10,$80                ;53
          .dc.b      $10,$00                ;55
          .dc.b      $00,$00                ;57
          .dc.b      $00,$00                ;59
          .dc.b      $10,$44                ;61
          .dc.b      $10,$04                ;63
          .dc.b      $10,$00                ;65
          .dc.b      $10,$00                ;67
          .dc.b      $10,$11                ;69
          .dc.b      $10,$00                ;71
          .dc.b      $10,$00                ;73
          .dc.b      $10,$00                ;75
          .dc.b      $FF,$C0                ;77
          .dc.b      $C0,$00                ;79
          .dc.b      $F0,$C0                ;81
          .dc.b      $10,$00                ;83
          .dc.b      $10,$00                ;85
          .dc.b      $10,$00                ;87
          .dc.b      $10,$00                ;89
          .dc.b      $10,$00                ;91
          .dc.b      $10,$0F                ;93
          .dc.b      $13,$FF                ;95
          .dc.b      $10,$3F                ;97
          .dc.b      $13,$F0                ;99
          .dc.b      $10,$00                ;101
          .dc.b      $10,$03                ;103
          .dc.b      $FF,$FF                ;105
          .dc.b      $FF,$FF                ;107
          .dc.b      $FF,$C0                ;109
          .dc.b      $FF,$00                ;111
          .dc.b      $10,$FF                ;113
          .dc.b      $03,$FF                ;115
          .dc.b      $FC,$00                ;117
          .dc.b      $00,$FF                ;119
          .dc.b      $F0,$00                ;121
          .dc.b      $FC,$00                ;123
          .dc.b      $FF,$00                ;125
          .dc.b      $10,$00                ;127
          .dc.b      $1F,$FF                ;129
          .dc.b      $3F,$FF                ;131
          .dc.b      $FF,$FF                ;133
          .dc.b      $FF,$F0                ;135
          .dc.b      $FF,$FF                ;137
          .dc.b      $10,$00                ;139
          .dc.b      $FF,$FF                ;141
          .dc.b      $FF,$FF                ;143
          .dc.b      $FF,$FF                ;145
          .dc.b      $FF,$FF                ;147
          .dc.b      $FF,$C0                ;149
          .dc.b      $FB,$C0                ;151
          .dc.b      $FF,$FF                ;153
          .dc.b      $FF,$FF                ;155
          .dc.b      $13,$FF                ;157
          .dc.b      $FF,$C0                ;159
          .dc.b      $FF,$F0                ;161
          .dc.b      $FF,$FF                ;163
          .dc.b      $0F,$FF                ;165
          .dc.b      $FF,$F0                ;167
          .dc.b      $FF,$FF                ;169
          .dc.b      $3F,$FF                ;171
          .dc.b      $FF,$FF                ;173
          .dc.b      $0F,$FF                ;175
          .dc.b      $FF,$FF                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $FF,$FF                ;181
          .dc.b      $FF,$FF                ;183
          .dc.b      $FF,$FF                ;185
          .dc.b      $FF,$FF                ;187
          .dc.b      $FF,$FF                ;189
          .dc.b      $FF,$FF                ;191
          .dc.b      $FF,$FF                ;193
          .dc.b      $FF,$FF                ;195
          .dc.b      $FF,$C0                ;197
          .dc.b      $FF,$FF                ;199
          .dc.b      $FF,$FF                ;201
          .dc.b      $FF,$FF                ;203
          .dc.b      $FF,$FF                ;205
          .dc.b      $FF,$FF                ;207
          .dc.b      $3F,$FF                ;209
          .dc.b      $FF,$FF                ;211
          .dc.b      $FF,$FF                ;213
          .dc.b      $0C                    ;214    BARCON

          .dc.b      $7C                    ;CRIGHT
          .dc.b      $C0                    ;XTRA
          .dc.b      $10                    ;A
          .dc.b      $F8                    ;B
          .dc.b      $70                    ;C
          .dc.b      $F8                    ;D
          .dc.b      $FC                    ;E
          .dc.b      $FE                    ;F
          .dc.b      $3C                    ;G
          .dc.b      $C6                    ;H
          .dc.b      $7E                    ;I
          .dc.b      $7E                    ;J
          .dc.b      $CC                    ;K
          .dc.b      $C0                    ;L
          .dc.b      $82                    ;M
          .dc.b      $C6                    ;N
          .dc.b      $38                    ;O
          .dc.b      $F8                    ;P
          .dc.b      $38                    ;Q
          .dc.b      $F8                    ;R
          .dc.b      $7C                    ;S
          .dc.b      $7E                    ;T
          .dc.b      $C6                    ;U
          .dc.b      $C6                    ;V
          .dc.b      $C6                    ;W
          .dc.b      $C6                    ;X
          .dc.b      $C6                    ;Y
          .dc.b      $FE                    ;Z
          .dc.b      $7C                    ;QUEST
          .dc.b      $30                    ;EXCLAM
          .dc.b      $00                    ;HYPHEN

          .dc.b      $38                    ;JEWCON
          .dc.b      $3C                    ;EGGCON
          .dc.b      $03,$C0                ;LSUN,RSUN
          .dc.b      $00,$00                ;LBOWL,RBOWL
          .dc.b      $00                    ;PLUS
          .dc.b      $00                    ;EQUALS
          .dc.b      $FF,$2F                ;LCLEAR,RCLEAR

          ORG     $8700
          .dc.b      $00,$00                ;NUMS                 EIGHT
          .dc.b      $00,$00
          .dc.b      $00,$00
          .dc.b      $00,$00
          .dc.b      $00,$00

          .dc.b      $07,$E0                ;LCANE,RCANE
          .dc.b      $00,$C0                ;LMWS,RMWS
          .dc.b      $03,$C0                ;LFEATH,RFEATH
          .dc.b      $00,$00                ;LEYE,REYE
          .dc.b      $03,$00                ;LPAUSE,RPAUSE
          .dc.b      $03,$C0                ;LAHNK.RAHNK
          .dc.b      $1E,$00                ;LBIRD,RBIRD

          .dc.b      $00,$00                ;25
          .dc.b      $00,$00                ;27
          .dc.b      $00,$00                ;29
          .dc.b      $04,$01                ;31
          .dc.b      $00,$14                ;33
          .dc.b      $00,$50                ;35
          .dc.b      $01,$00                ;37
          .dc.b      $00,$00                ;39
          .dc.b      $00,$00                ;41
          .dc.b      $00,$00                ;43
          .dc.b      $00,$02                ;45
          .dc.b      $00,$00                ;47
          .dc.b      $00,$00                ;49
          .dc.b      $00,$00                ;51
          .dc.b      $80,$00                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $00,$00                ;57
          .dc.b      $00,$00                ;59
          .dc.b      $00,$01                ;61
          .dc.b      $00,$40                ;63
          .dc.b      $00,$00                ;65
          .dc.b      $00,$00                ;67
          .dc.b      $00,$40                ;69
          .dc.b      $00,$04                ;71
          .dc.b      $00,$00                ;73
          .dc.b      $00,$00                ;75
          .dc.b      $FF,$F0                ;77
          .dc.b      $00,$00                ;79
          .dc.b      $C0,$00                ;81
          .dc.b      $00,$00                ;83
          .dc.b      $00,$00                ;85
          .dc.b      $00,$00                ;87
          .dc.b      $00,$00                ;89
          .dc.b      $00,$00                ;91
          .dc.b      $00,$00                ;93
          .dc.b      $00,$FF                ;95
          .dc.b      $00,$FF                ;97
          .dc.b      $03,$FF                ;99
          .dc.b      $00,$00                ;101
          .dc.b      $00,$00                ;103
          .dc.b      $FF,$FF                ;105
          .dc.b      $3F,$FF                ;107
          .dc.b      $FF,$FF                ;109
          .dc.b      $FF,$C0                ;111
          .dc.b      $00,$FF                ;113
          .dc.b      $3F,$FF                ;115
          .dc.b      $FC,$00                ;117
          .dc.b      $00,$FF                ;119
          .dc.b      $F0,$00                ;121
          .dc.b      $FC,$00                ;123
          .dc.b      $F0,$00                ;125
          .dc.b      $00,$00                ;127
          .dc.b      $FF,$FF                ;129
          .dc.b      $3F,$FF                ;131
          .dc.b      $FF,$FF                ;133
          .dc.b      $FF,$FC                ;135
          .dc.b      $3F,$FF                ;137
          .dc.b      $03,$8C                ;139
          .dc.b      $FF,$FF                ;141
          .dc.b      $FF,$FF                ;143
          .dc.b      $FF,$FF                ;145
          .dc.b      $FF,$FF                ;147
          .dc.b      $FF,$FF                ;149
          .dc.b      $FF,$FC                ;151
          .dc.b      $FF,$FF                ;153
          .dc.b      $FF,$FF                ;155
          .dc.b      $03,$FF                ;157
          .dc.b      $FF,$F0                ;159
          .dc.b      $FF,$FF                ;161
          .dc.b      $FF,$FF                ;163
          .dc.b      $0F,$FF                ;165
          .dc.b      $FF,$C0                ;167
          .dc.b      $FF,$FF                ;169
          .dc.b      $FF,$FF                ;171
          .dc.b      $FF,$FF                ;173
          .dc.b      $3F,$FF                ;179
          .dc.b      $FF,$FF                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $FF,$FF                ;181
          .dc.b      $FF,$FF                ;183
          .dc.b      $FF,$FF                ;185
          .dc.b      $FF,$FF                ;187
          .dc.b      $FF,$FF                ;189
          .dc.b      $FF,$FF                ;191
          .dc.b      $FF,$FF                ;193
          .dc.b      $FF,$FF                ;195
          .dc.b      $FF,$C0                ;197
          .dc.b      $FF,$FF                ;199
          .dc.b      $FF,$FF                ;201
          .dc.b      $FF,$FF                ;203
          .dc.b      $FF,$FF                ;205
          .dc.b      $FF,$FF                ;207
          .dc.b      $3F,$FF                ;209
          .dc.b      $FF,$FF                ;211
          .dc.b      $FF,$FF                ;213
          .dc.b      $00                    ;214    BARCON

          .dc.b      $00                    ;CRIGHT
          .dc.b      $00                    ;XTRA
          .dc.b      $00                    ;A
          .dc.b      $00                    ;B
          .dc.b      $00                    ;C
          .dc.b      $00                    ;D
          .dc.b      $00                    ;E
          .dc.b      $00                    ;F
          .dc.b      $00                    ;G
          .dc.b      $00                    ;H
          .dc.b      $00                    ;I
          .dc.b      $00                    ;J
          .dc.b      $00                    ;K
          .dc.b      $00                    ;L
          .dc.b      $00                    ;M
          .dc.b      $00                    ;N
          .dc.b      $00                    ;O
          .dc.b      $00                    ;P
          .dc.b      $00                    ;Q
          .dc.b      $00                    ;R
          .dc.b      $00                    ;S
          .dc.b      $00                    ;T
          .dc.b      $00                    ;U
          .dc.b      $00                    ;V
          .dc.b      $00                    ;W
          .dc.b      $00                    ;X
          .dc.b      $00                    ;Y
          .dc.b      $00                    ;Z
          .dc.b      $00                    ;QUEST
          .dc.b      $00                    ;EXCLAM
          .dc.b      $00                    ;HYPHEN

          .dc.b      $00                    ;JEWCON
          .dc.b      $00                    ;EGGCON
          .dc.b      $00,$00                ;LSUN,RSUN
          .dc.b      $00,$00                ;LBOWL,RBOWL
          .dc.b      $00                    ;PLUS
          .dc.b      $00                    ;EQUALS
          .dc.b      $06,$02                ;LCLEAR,RCLEAR

          ORG     $8800

                                         ;THIS IS TITLE PAGE GRAPHICS
TITCHR1:  .dc.b      $69,$64                ;TITCHR1
TITCHR2:  .dc.b      $69,$51                ;TITCHR2
TITCHR3:  .dc.b      $AA,$40                ;TITCHR3
TITCHR4:  .dc.b      $69,$50                ;TITCHR4
TITCHR5:  .dc.b      $69,$A9                ;TITCHR5
TITCHR6:  .dc.b      $06,$90                ;TITCHR6
TITCHR7:  .dc.b      $55,$40                ;TITCHR7
TITCHR8:  .dc.b      $55,$56                ;TITCHR8
TITCHR9:  .dc.b      $15,$40                ;TITCHR9
TITCHR10: .dc.b      $55,$56                ;TITCHR10
TITCHR11: .dc.b      $55,$05                ;TITCHR11
TITCHR12: .dc.b      $45,$50                ;TITCHR12

          .dc.b      $00,$00                ;25
          .dc.b      $00,$00                ;27
          .dc.b      $00,$00                ;29
          .dc.b      $00,$00                ;31
          .dc.b      $02,$40                ;33
          .dc.b      $05,$80                ;35
          .dc.b      $00,$04                ;37
          .dc.b      $00,$20                ;39
          .dc.b      $00,$01                ;41
          .dc.b      $00,$00                ;43
          .dc.b      $00,$00                ;45
          .dc.b      $00,$00                ;47
          .dc.b      $00,$00                ;49
          .dc.b      $20,$08                ;51
          .dc.b      $08,$00                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $00,$00                ;57
          .dc.b      $00,$00                ;59
          .dc.b      $01,$10                ;61
          .dc.b      $04,$00                ;63
          .dc.b      $00,$00                ;65
          .dc.b      $00,$00                ;67
          .dc.b      $40,$04                ;69
          .dc.b      $00,$00                ;71
          .dc.b      $00,$00                ;73
          .dc.b      $00,$03                ;75
          .dc.b      $FF,$F0                ;77
          .dc.b      $00,$00                ;79
          .dc.b      $00,$00                ;81
          .dc.b      $C0,$00                ;83
          .dc.b      $00,$00                ;85
          .dc.b      $C0,$00                ;87
          .dc.b      $00,$00                ;89
          .dc.b      $00,$00                ;91
          .dc.b      $00,$00                ;93
          .dc.b      $00,$3B                ;95
          .dc.b      $00,$FB                ;97
          .dc.b      $00,$FB                ;99
          .dc.b      $C0,$00                ;101
          .dc.b      $00,$00                ;103
          .dc.b      $0F,$FB                ;105
          .dc.b      $3F,$FB                ;107
          .dc.b      $FF,$FB                ;109
          .dc.b      $FF,$C0                ;111
          .dc.b      $00,$3B                ;113
          .dc.b      $FF,$FB                ;115
          .dc.b      $FC,$00                ;117
          .dc.b      $00,$FB                ;119
          .dc.b      $F0,$00                ;121
          .dc.b      $FF,$00                ;123
          .dc.b      $00,$00                ;125
          .dc.b      $00,$00                ;127
          .dc.b      $FF,$FB                ;129
          .dc.b      $0F,$FB                ;131
          .dc.b      $FF,$F8                ;133
          .dc.b      $FF,$F8                ;135
          .dc.b      $3F,$FB                ;137
          .dc.b      $FB,$FB                ;139
          .dc.b      $2F,$FB                ;141
          .dc.b      $3F,$FB                ;143
          .dc.b      $FF,$FB                ;145
          .dc.b      $FF,$FB                ;147
          .dc.b      $FF,$FB                ;149
          .dc.b      $FF,$FF                ;151
          .dc.b      $FF,$FB                ;153
          .dc.b      $3F,$FB                ;155
          .dc.b      $0F,$FB                ;157
          .dc.b      $FF,$F0                ;159
          .dc.b      $FF,$FB                ;161
          .dc.b      $3F,$FB                ;163
          .dc.b      $0F,$FB                ;165
          .dc.b      $FF,$C0                ;167
          .dc.b      $FF,$F8                ;169
          .dc.b      $FF,$FB                ;171
          .dc.b      $FF,$F8                ;173
          .dc.b      $FF,$FB                ;175
          .dc.b      $FF,$FB                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $FF,$FB                ;181
          .dc.b      $FF,$FB                ;183
          .dc.b      $FF,$FB                ;185
          .dc.b      $FF,$FB                ;187
          .dc.b      $FF,$FB                ;189
          .dc.b      $FF,$FB                ;191
WINGS0:   .dc.b      $00,$00                ;WINGS0
          .dc.b      $FF,$FB                ;195
          .dc.b      $FF,$C0                ;197
          .dc.b      $FF,$FB                ;199
          .dc.b      $FF,$FB                ;201
          .dc.b      $FF,$FB                ;203
          .dc.b      $FF,$FB                ;205
          .dc.b      $FF,$FB                ;207
          .dc.b      $0F,$FB                ;209
          .dc.b      $FF,$FB                ;211
          .dc.b      $FF,$FB                ;213
WINGS1:   .dc.b      $00,$00                ;WINGS1

TITCHR13: .dc.b      $69,$59                ;TITCHR13      217
TITCHR14: .dc.b      $A5,$A4                ;TITCHR14      219
TITCHR15: .dc.b      $69,$01                ;TITCHR15      221
TITCHR16: .dc.b      $A4,$01                ;TITCHR16      223
TITCHR17: .dc.b      $A5,$A4                ;TITCHR17      225
TITCHR18: .dc.b      $69,$A9                ;TITCHR18      227
TITCHR19: .dc.b      $55,$01                ;TITCHR19      229
TITCHR20: .dc.b      $55,$54                ;TITCHR20      231
TITCHR21: .dc.b      $55,$56                ;TITCHR21      233
TITCHR22: .dc.b      $15,$54                ;TITCHR22      235
TITCHR23: .dc.b      $15,$40                ;TITCHR23      237
TITCHR24: .dc.b      $55,$15                ;TITCHR24      239
WINGS2:   .dc.b      $00,$00                ;WINGS2        241
WINGS3:   .dc.b      $00,$00                ;WINGS3        243
WINGS4:   .dc.b      $00,$00                ;WINGS4        245
WINGS5:   .dc.b      $00,$00                ;WINGS5        247
WINGS6:   .dc.b      $00,$00                ;WINGS6        249
WINGS7:   .dc.b      $00,$00                ;WINGS7        251
WINGS8:   .dc.b      $00,$00                ;WINGS8        253
WINGS9:   .dc.b      $00,$00                ;WINGS9        255  TH-THAT'S ALL FOLKS

          ORG     $8900

          .dc.b      $69,$64                ;TITCHR1
          .dc.b      $6A,$91                ;TITCHR2
          .dc.b      $A9,$54                ;TITCHR3
          .dc.b      $6A,$90                ;TITCHR4
          .dc.b      $69,$69                ;TITCHR5
          .dc.b      $06,$90                ;TITCHR6
          .dc.b      $7F,$D0                ;TITCHR7
          .dc.b      $7F,$F6                ;TITCHR8
          .dc.b      $7F,$D0                ;TITCHR9
          .dc.b      $7F,$F6                ;TITCHR10
          .dc.b      $7D,$1F                ;TITCHR11
          .dc.b      $47,$D0                ;TITCHR12

          .dc.b      $00,$00                ;25
          .dc.b      $01,$00                ;27
          .dc.b      $04,$01                ;29
          .dc.b      $00,$00                ;31
          .dc.b      $01,$08                ;33
          .dc.b      $09,$40                ;35
          .dc.b      $00,$10                ;37
          .dc.b      $01,$00                ;39
          .dc.b      $04,$00                ;41
          .dc.b      $00,$00                ;43
          .dc.b      $00,$00                ;45
          .dc.b      $02,$00                ;47
          .dc.b      $04,$00                ;49
          .dc.b      $00,$00                ;51
          .dc.b      $00,$00                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $00,$10                ;57
          .dc.b      $00,$00                ;59
          .dc.b      $00,$00                ;61
          .dc.b      $40,$00                ;63
          .dc.b      $00,$00                ;65
          .dc.b      $01,$00                ;67
          .dc.b      $05,$00                ;69
          .dc.b      $10,$40                ;71
          .dc.b      $00,$00                ;73
          .dc.b      $00,$03                ;75
          .dc.b      $FF,$E0                ;77
          .dc.b      $00,$00                ;79
          .dc.b      $00,$00                ;81
          .dc.b      $FC,$00                ;83
          .dc.b      $00,$00                ;85
          .dc.b      $FF,$00                ;87
          .dc.b      $00,$00                ;89
          .dc.b      $00,$00                ;91
          .dc.b      $00,$00                ;93
          .dc.b      $00,$2F                ;95
          .dc.b      $00,$EF                ;97
          .dc.b      $00,$3F                ;99
          .dc.b      $FC,$00                ;101
          .dc.b      $00,$00                ;103
          .dc.b      $00,$EF                ;105
          .dc.b      $33,$EF                ;107
          .dc.b      $FF,$EF                ;109
          .dc.b      $FF,$C0                ;111
          .dc.b      $00,$2F                ;113
          .dc.b      $FF,$EF                ;115
          .dc.b      $FC,$00                ;117
          .dc.b      $03,$EF                ;119
          .dc.b      $FC,$00                ;121
          .dc.b      $FF,$00                ;123
          .dc.b      $00,$00                ;125
          .dc.b      $00,$00                ;127
          .dc.b      $FF,$EF                ;129
          .dc.b      $03,$EF                ;131
          .dc.b      $FF,$EC                ;133
          .dc.b      $FF,$E0                ;135
          .dc.b      $33,$EF                ;137
          .dc.b      $EF,$EF                ;139
          .dc.b      $1F,$EF                ;141
          .dc.b      $0F,$EF                ;143
          .dc.b      $FF,$EF                ;145
          .dc.b      $FF,$EF                ;147
          .dc.b      $FF,$EF                ;149
          .dc.b      $FF,$FB                ;151
          .dc.b      $FF,$EF                ;153
          .dc.b      $3F,$EF                ;155
          .dc.b      $0F,$EF                ;157
          .dc.b      $FF,$E0                ;159
          .dc.b      $FF,$EF                ;161
          .dc.b      $0F,$EF                ;163
          .dc.b      $4F,$EF                ;165
          .dc.b      $FF,$C0                ;167
          .dc.b      $FF,$EC                ;169
          .dc.b      $FF,$EF                ;171
          .dc.b      $FF,$EC                ;173
          .dc.b      $FF,$EF                ;175
          .dc.b      $FF,$EF                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $FF,$EF                ;181
          .dc.b      $FF,$EF                ;183
          .dc.b      $FF,$EF                ;185
          .dc.b      $FF,$EF                ;187
          .dc.b      $FF,$EF                ;189
          .dc.b      $FF,$EF                ;191
          .dc.b      $03,$FF                ;WINGS0
          .dc.b      $FF,$EF                ;195
          .dc.b      $FF,$C0                ;197
          .dc.b      $FF,$EF                ;199
          .dc.b      $FF,$EF                ;201
          .dc.b      $3F,$EF                ;203
          .dc.b      $FF,$EF                ;205
          .dc.b      $FF,$EF                ;207
          .dc.b      $0F,$EF                ;209
          .dc.b      $FF,$EF                ;211
          .dc.b      $FF,$EF                ;213
          .dc.b      $FF,$FF                ;WINGS1

          .dc.b      $6A,$99                ;TITCHR13
          .dc.b      $A5,$A4                ;TITCHR14
          .dc.b      $69,$01                ;TITCHR15
          .dc.b      $A4,$01                ;TITCHR16
          .dc.b      $A5,$A4                ;TITCHR17
          .dc.b      $6A,$A9                ;TITCHR18
          .dc.b      $7D,$01                ;TITCHR19
          .dc.b      $F5,$F4                ;TITCHR20
          .dc.b      $7F,$F6                ;TITCHR21
          .dc.b      $7F,$F4                ;TITCHR22
          .dc.b      $7F,$D0                ;TITCHR23
          .dc.b      $7D,$1D                ;TITCHR24
          .dc.b      $FF,$C0                ;WINGS2        241
          .dc.b      $F5,$55                ;WINGS3        243
          .dc.b      $55,$55                ;WINGS4        245
          .dc.b      $55,$5F                ;WINGS5        247
          .dc.b      $FF,$FF                ;WINGS6        249
          .dc.b      $03,$FF                ;WINGS7        251
          .dc.b      $FF,$C0                ;WINGS8        253
          .dc.b      $FF,$FF                ;WINGS9        255  TH-THAT'S ALL FOLKS

          ORG     $8A00

          .dc.b      $59,$64                ;TITCHR1
          .dc.b      $59,$51                ;TITCHR2
          .dc.b      $65,$A4                ;TITCHR3
          .dc.b      $59,$50                ;TITCHR4
          .dc.b      $59,$69                ;TITCHR5
          .dc.b      $05,$90                ;TITCHR6
          .dc.b      $7F,$F0                ;TITCHR7
          .dc.b      $7D,$56                ;TITCHR8
          .dc.b      $7F,$D0                ;TITCHR9
          .dc.b      $7D,$56                ;TITCHR10
          .dc.b      $7D,$DF                ;TITCHR11
          .dc.b      $47,$D0                ;TITCHR12

          .dc.b      $00,$10                ;25
          .dc.b      $00,$10                ;27
          .dc.b      $00,$10                ;29
          .dc.b      $01,$10                ;31
          .dc.b      $08,$10                ;33
          .dc.b      $04,$00                ;35
          .dc.b      $00,$50                ;37
          .dc.b      $00,$10                ;39
          .dc.b      $00,$10                ;41
          .dc.b      $00,$10                ;43
          .dc.b      $08,$10                ;45
          .dc.b      $00,$10                ;47
          .dc.b      $80,$10                ;49
          .dc.b      $00,$10                ;51
          .dc.b      $82,$10                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $00,$00                ;57
          .dc.b      $00,$10                ;59
          .dc.b      $01,$11                ;61
          .dc.b      $04,$10                ;63
          .dc.b      $00,$10                ;65
          .dc.b      $00,$11                ;67
          .dc.b      $10,$11                ;69
          .dc.b      $04,$10                ;71
          .dc.b      $00,$10                ;73
          .dc.b      $00,$3F                ;75
          .dc.b      $FF,$E0                ;77
          .dc.b      $00,$10                ;79
          .dc.b      $00,$10                ;81
          .dc.b      $FF,$10                ;83
          .dc.b      $00,$10                ;85
          .dc.b      $FF,$F0                ;87
          .dc.b      $00,$10                ;89
          .dc.b      $00,$10                ;91
          .dc.b      $00,$10                ;93
          .dc.b      $00,$13                ;95
          .dc.b      $00,$3F                ;97
          .dc.b      $00,$1F                ;99
          .dc.b      $EF,$D0                ;101
          .dc.b      $00,$10                ;103
          .dc.b      $00,$3F                ;105
          .dc.b      $00,$FF                ;107
          .dc.b      $FF,$FF                ;109
          .dc.b      $FF,$D0                ;111
          .dc.b      $00,$3F                ;113
          .dc.b      $FF,$FF                ;115
          .dc.b      $FC,$10                ;117
          .dc.b      $03,$FF                ;119
          .dc.b      $FC,$10                ;121
          .dc.b      $FF,$10                ;123
          .dc.b      $00,$10                ;125
          .dc.b      $00,$10                ;127
          .dc.b      $FF,$FF                ;129
          .dc.b      $03,$FF                ;131
          .dc.b      $FF,$F0                ;133
          .dc.b      $FF,$F0                ;135
          .dc.b      $03,$FF                ;137
          .dc.b      $FF,$FF                ;139
          .dc.b      $3F,$FF                ;141
          .dc.b      $00,$DF                ;143
          .dc.b      $FF,$FF                ;145
          .dc.b      $FF,$FF                ;147
          .dc.b      $FF,$FF                ;149
          .dc.b      $FF,$EF                ;151
          .dc.b      $FF,$FF                ;153
          .dc.b      $0F,$FF                ;155
          .dc.b      $0F,$FF                ;157
          .dc.b      $FF,$F0                ;159
          .dc.b      $FF,$FF                ;161
          .dc.b      $00,$FF                ;163
          .dc.b      $0F,$FF                ;165
          .dc.b      $FF,$F0                ;167
          .dc.b      $FF,$F0                ;169
          .dc.b      $FF,$FF                ;171
          .dc.b      $FF,$F0                ;173
          .dc.b      $FF,$FF                ;175
          .dc.b      $FF,$FF                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $FF,$FF                ;181
          .dc.b      $FB,$FC                ;183
          .dc.b      $FF,$FF                ;185
          .dc.b      $FF,$FF                ;187
          .dc.b      $FF,$FF                ;189
          .dc.b      $FF,$FF                ;191
          .dc.b      $00,$00                ;WINGS0
          .dc.b      $FF,$FF                ;195
          .dc.b      $FF,$F4                ;197
          .dc.b      $FF,$FF                ;199
          .dc.b      $FF,$FF                ;201
          .dc.b      $3F,$FF                ;203
          .dc.b      $FF,$FF                ;205
          .dc.b      $FF,$FF                ;207
          .dc.b      $0F,$FF                ;209
          .dc.b      $FF,$FF                ;211
          .dc.b      $FF,$FF                ;213
          .dc.b      $00,$00                ;WINGS1

          .dc.b      $59,$59                ;TITCHR13
          .dc.b      $65,$A4                ;TITCHR14
          .dc.b      $59,$01                ;TITCHR15
          .dc.b      $64,$01                ;TITCHR16
          .dc.b      $A5,$A4                ;TITCHR17
          .dc.b      $5A,$A9                ;TITCHR18
          .dc.b      $7D,$01                ;TITCHR19
          .dc.b      $F5,$F4                ;TITCHR20
          .dc.b      $7D,$56                ;TITCHR21
          .dc.b      $7D,$54                ;TITCHR22
          .dc.b      $7F,$D0                ;TITCHR23
          .dc.b      $7D,$1D                ;TITCHR24
          .dc.b      $00,$00                ;WINGS2        241
          .dc.b      $15,$55                ;WINGS3        243
          .dc.b      $55,$55                ;WINGS4        245
          .dc.b      $55,$54                ;WINGS5        247
          .dc.b      $00,$00                ;WINGS6        249
          .dc.b      $00,$00                ;WINGS7        251
          .dc.b      $00,$00                ;WINGS8        253
          .dc.b      $00,$00                ;WINGS9        255  TH-THAT'S ALL FOLKS

          ORG     $8B00

          .dc.b      $69,$A4                ;TITCHR1
          .dc.b      $69,$01                ;TITCHR2
          .dc.b      $AA,$A4                ;TITCHR3
          .dc.b      $69,$00                ;TITCHR4
          .dc.b      $69,$69                ;TITCHR5
          .dc.b      $06,$90                ;TITCHR6
          .dc.b      $7F,$F4                ;TITCHR7
          .dc.b      $7D,$01                ;TITCHR8
          .dc.b      $FF,$F4                ;TITCHR9
          .dc.b      $7D,$00                ;TITCHR10
          .dc.b      $7D,$7D                ;TITCHR11
          .dc.b      $07,$D0                ;TITCHR12

          .dc.b      $00,$00                ;25
          .dc.b      $00,$00                ;27
          .dc.b      $00,$00                ;29
          .dc.b      $00,$00                ;31
          .dc.b      $00,$80                ;33
          .dc.b      $20,$20                ;35
          .dc.b      $04,$40                ;37
          .dc.b      $80,$00                ;39
          .dc.b      $00,$00                ;41
          .dc.b      $00,$00                ;43
          .dc.b      $00,$00                ;45
          .dc.b      $00,$00                ;47
          .dc.b      $01,$08                ;49
          .dc.b      $00,$80                ;51
          .dc.b      $00,$00                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $00,$00                ;57
          .dc.b      $00,$00                ;59
          .dc.b      $00,$40                ;61
          .dc.b      $00,$00                ;63
          .dc.b      $00,$00                ;65
          .dc.b      $00,$00                ;67
          .dc.b      $01,$04                ;69
          .dc.b      $00,$00                ;71
          .dc.b      $01,$01                ;73
          .dc.b      $00,$0F                ;75
          .dc.b      $FF,$C0                ;77
          .dc.b      $00,$00                ;79
          .dc.b      $00,$00                ;81
          .dc.b      $FF,$C0                ;83
          .dc.b      $00,$00                ;85
          .dc.b      $FF,$FF                ;87
          .dc.b      $00,$00                ;89
          .dc.b      $00,$00                ;91
          .dc.b      $00,$00                ;93
          .dc.b      $00,$00                ;95
          .dc.b      $00,$3F                ;97
          .dc.b      $00,$03                ;99
          .dc.b      $FF,$FF                ;101
          .dc.b      $00,$00                ;103
          .dc.b      $00,$3F                ;105
          .dc.b      $00,$FF                ;107
          .dc.b      $FF,$FF                ;109
          .dc.b      $FF,$C0                ;111
          .dc.b      $00,$1F                ;113
          .dc.b      $FF,$FF                ;115
          .dc.b      $FC,$00                ;117
          .dc.b      $0F,$FF                ;119
          .dc.b      $FC,$00                ;121
          .dc.b      $FF,$00                ;123
          .dc.b      $00,$00                ;125
          .dc.b      $00,$00                ;127
          .dc.b      $FF,$FF                ;129
          .dc.b      $00,$FF                ;131
          .dc.b      $FF,$C0                ;133
          .dc.b      $FF,$C0                ;135
          .dc.b      $00,$FF                ;137
          .dc.b      $FF,$FF                ;139
          .dc.b      $0B,$FF                ;141
          .dc.b      $00,$0F                ;143
          .dc.b      $FF,$FF                ;145
          .dc.b      $FF,$FF                ;147
          .dc.b      $FF,$FF                ;149
          .dc.b      $FF,$FF                ;151
          .dc.b      $3E,$FF                ;153
          .dc.b      $0F,$FF                ;155
          .dc.b      $0F,$FF                ;157
          .dc.b      $FF,$F0                ;159
          .dc.b      $FF,$FF                ;161
          .dc.b      $00,$0F                ;163
          .dc.b      $3F,$FF                ;165
          .dc.b      $FF,$10                ;167
          .dc.b      $FF,$F0                ;169
          .dc.b      $FF,$FF                ;171
          .dc.b      $FF,$F0                ;173
          .dc.b      $FF,$FF                ;175
          .dc.b      $FF,$FF                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $FF,$FF                ;181
          .dc.b      $EF,$00                ;183
          .dc.b      $FF,$FF                ;185
          .dc.b      $FF,$FF                ;187
          .dc.b      $FF,$FF                ;189
          .dc.b      $FF,$FF                ;191
          .dc.b      $3F,$FF                ;WINGS0
          .dc.b      $FF,$FF                ;195
          .dc.b      $FF,$F0                ;197
          .dc.b      $FF,$FF                ;199
          .dc.b      $FF,$FF                ;201
          .dc.b      $3F,$FF                ;203
          .dc.b      $FF,$FF                ;205
          .dc.b      $FF,$FF                ;207
          .dc.b      $1F,$FF                ;209
          .dc.b      $FF,$FF                ;211
          .dc.b      $FF,$FF                ;213
          .dc.b      $FF,$FF                ;WINGS1

          .dc.b      $69,$01                ;TITCHR13
          .dc.b      $A5,$A4                ;TITCHR14
          .dc.b      $69,$01                ;TITCHR15
          .dc.b      $A4,$01                ;TITCHR16
          .dc.b      $AA,$A4                ;TITCHR17
          .dc.b      $6A,$59                ;TITCHR18
          .dc.b      $7D,$01                ;TITCHR19
          .dc.b      $FF,$F4                ;TITCHR20
          .dc.b      $7D,$01                ;TITCHR21
          .dc.b      $F5,$01                ;TITCHR22
          .dc.b      $FF,$F4                ;TITCHR23
          .dc.b      $7D,$1D                ;TITCHR24
          .dc.b      $FF,$FC                ;WINGS2        241
          .dc.b      $D5,$55                ;WINGS3        243
          .dc.b      $55,$55                ;WINGS4        245
          .dc.b      $55,$57                ;WINGS5        247
          .dc.b      $FF,$FF                ;WINGS6        249
          .dc.b      $3F,$FF                ;WINGS7        251
          .dc.b      $FF,$FC                ;WINGS8        253
          .dc.b      $FF,$FF                ;WINGS9        255  TH-THAT'S ALL FOLKS

          ORG     $8C00

          .dc.b      $56,$A4                ;TITCHR1
          .dc.b      $59,$01                ;TITCHR2
          .dc.b      $6A,$A4                ;TITCHR3
          .dc.b      $59,$00                ;TITCHR4
          .dc.b      $59,$A9                ;TITCHR5
          .dc.b      $05,$90                ;TITCHR6
          .dc.b      $69,$A4                ;TITCHR7
          .dc.b      $69,$01                ;TITCHR8
          .dc.b      $A5,$A4                ;TITCHR9
          .dc.b      $69,$00                ;TITCHR10
          .dc.b      $69,$A4                ;TITCHR11
          .dc.b      $06,$90                ;TITCHR12

          .dc.b      $10,$00                ;25
          .dc.b      $10,$00                ;27
          .dc.b      $11,$00                ;29
          .dc.b      $10,$00                ;31
          .dc.b      $10,$00                ;33
          .dc.b      $10,$00                ;35
          .dc.b      $01,$00                ;37
          .dc.b      $10,$00                ;39
          .dc.b      $10,$08                ;41
          .dc.b      $10,$00                ;43
          .dc.b      $10,$00                ;45
          .dc.b      $10,$00                ;47
          .dc.b      $10,$00                ;49
          .dc.b      $10,$00                ;51
          .dc.b      $10,$08                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $10,$00                ;57
          .dc.b      $10,$00                ;59
          .dc.b      $10,$04                ;61
          .dc.b      $10,$00                ;63
          .dc.b      $10,$00                ;65
          .dc.b      $10,$01                ;67
          .dc.b      $10,$00                ;69
          .dc.b      $11,$04                ;71
          .dc.b      $10,$40                ;73
          .dc.b      $10,$CF                ;75
          .dc.b      $FB,$00                ;77
          .dc.b      $10,$00                ;79
          .dc.b      $10,$00                ;81
          .dc.b      $FB,$00                ;83
          .dc.b      $10,$00                ;85
          .dc.b      $FB,$EF                ;87
          .dc.b      $F0,$00                ;89
          .dc.b      $10,$00                ;91
          .dc.b      $10,$00                ;93
          .dc.b      $10,$00                ;95
          .dc.b      $10,$0F                ;97
          .dc.b      $10,$00                ;99
          .dc.b      $FF,$BF                ;101
          .dc.b      $10,$00                ;103
          .dc.b      $10,$0F                ;105
          .dc.b      $0B,$FF                ;107
          .dc.b      $FB,$FF                ;109
          .dc.b      $FB,$C0                ;111
          .dc.b      $00,$0F                ;113
          .dc.b      $FB,$FF                ;115
          .dc.b      $FB,$00                ;117
          .dc.b      $0B,$FF                ;119
          .dc.b      $F8,$00                ;121
          .dc.b      $FB,$C0                ;123
          .dc.b      $10,$00                ;125
          .dc.b      $10,$00                ;127
          .dc.b      $FB,$FF                ;129
          .dc.b      $10,$0F                ;131
          .dc.b      $FB,$00                ;133
          .dc.b      $FB,$00                ;135
          .dc.b      $10,$3F                ;137
          .dc.b      $FB,$FF                ;139
          .dc.b      $13,$FF                ;141
          .dc.b      $10,$00                ;143
          .dc.b      $1F,$FF                ;145
          .dc.b      $FB,$FF                ;147
          .dc.b      $FB,$FF                ;149
          .dc.b      $FF,$FF                ;151
          .dc.b      $03,$FF                ;153
          .dc.b      $10,$FF                ;155
          .dc.b      $3B,$FF                ;157
          .dc.b      $FB,$FC                ;159
          .dc.b      $FB,$FF                ;161
          .dc.b      $10,$0F                ;163
          .dc.b      $3B,$FF                ;165
          .dc.b      $FB,$00                ;167
          .dc.b      $FB,$C0                ;169
          .dc.b      $FB,$FF                ;171
          .dc.b      $FB,$C0                ;173
          .dc.b      $FB,$FF                ;175
          .dc.b      $FB,$FF                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $FB,$FF                ;181
          .dc.b      $FC,$00                ;183
          .dc.b      $FB,$FF                ;185
          .dc.b      $FB,$FF                ;187
          .dc.b      $FB,$FF                ;189
          .dc.b      $FB,$FF                ;191
          .dc.b      $00,$00                ;WINGS0
          .dc.b      $FB,$FF                ;195
          .dc.b      $FB,$F0                ;197
          .dc.b      $FB,$FF                ;199
          .dc.b      $FB,$FF                ;201
          .dc.b      $3B,$FF                ;203
          .dc.b      $FB,$FF                ;205
          .dc.b      $FB,$FF                ;207
          .dc.b      $3B,$FF                ;209
          .dc.b      $FB,$FF                ;211
          .dc.b      $FB,$FF                ;213
          .dc.b      $00,$00                ;WINGS1

          .dc.b      $59,$01                ;TITCHR13
          .dc.b      $6A,$94                ;TITCHR14
          .dc.b      $59,$01                ;TITCHR15
          .dc.b      $65,$01                ;TITCHR16
          .dc.b      $AA,$A4                ;TITCHR17
          .dc.b      $59,$99                ;TITCHR18
          .dc.b      $69,$01                ;TITCHR19
          .dc.b      $AA,$A4                ;TITCHR20
          .dc.b      $69,$01                ;TITCHR21
          .dc.b      $A4,$01                ;TITCHR22
          .dc.b      $AA,$A4                ;TITCHR23
          .dc.b      $69,$19                ;TITCHR24
          .dc.b      $00,$00                ;WINGS2        241
          .dc.b      $55,$00                ;WINGS3        243
          .dc.b      $00,$00                ;WINGS4        245
          .dc.b      $00,$55                ;WINGS5        247
          .dc.b      $00,$00                ;WINGS6        249
          .dc.b      $00,$00                ;WINGS7        251
          .dc.b      $00,$00                ;WINGS8        253
          .dc.b      $00,$00                ;WINGS9        255  TH-THAT'S ALL FOLKS

          ORG     $8D00

          .dc.b      $6A,$A0                ;TITCHR1
          .dc.b      $69,$56                ;TITCHR2
          .dc.b      $6A,$90                ;TITCHR3
          .dc.b      $69,$56                ;TITCHR4
          .dc.b      $6A,$A4                ;TITCHR5
          .dc.b      $56,$95                ;TITCHR6
          .dc.b      $7D,$74                ;TITCHR7
          .dc.b      $7D,$01                ;TITCHR8
          .dc.b      $57,$F4                ;TITCHR9
          .dc.b      $7D,$00                ;TITCHR10
          .dc.b      $7F,$F4                ;TITCHR11
          .dc.b      $07,$D0                ;TITCHR12

          .dc.b      $00,$00                ;25
          .dc.b      $00,$00                ;27
          .dc.b      $00,$00                ;29
          .dc.b      $00,$40                ;31
          .dc.b      $00,$00                ;33
          .dc.b      $00,$00                ;35
          .dc.b      $05,$04                ;37
          .dc.b      $00,$00                ;39
          .dc.b      $00,$00                ;41
          .dc.b      $00,$00                ;43
          .dc.b      $00,$00                ;45
          .dc.b      $00,$00                ;47
          .dc.b      $00,$00                ;49
          .dc.b      $00,$02                ;51
          .dc.b      $00,$00                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $00,$00                ;57
          .dc.b      $00,$00                ;59
          .dc.b      $01,$00                ;61
          .dc.b      $00,$00                ;63
          .dc.b      $00,$00                ;65
          .dc.b      $00,$40                ;67
          .dc.b      $41,$11                ;69
          .dc.b      $00,$40                ;71
          .dc.b      $00,$04                ;73
          .dc.b      $00,$FB                ;75
          .dc.b      $BC,$00                ;77
          .dc.b      $00,$00                ;79
          .dc.b      $00,$00                ;81
          .dc.b      $BC,$30                ;83
          .dc.b      $00,$00                ;85
          .dc.b      $BF,$FF                ;87
          .dc.b      $BF,$00                ;89
          .dc.b      $00,$00                ;91
          .dc.b      $00,$00                ;93
          .dc.b      $00,$00                ;95
          .dc.b      $00,$03                ;97
          .dc.b      $00,$00                ;99
          .dc.b      $0F,$FF                ;101
          .dc.b      $00,$00                ;103
          .dc.b      $00,$03                ;105
          .dc.b      $00,$3F                ;107
          .dc.b      $BF,$FF                ;109
          .dc.b      $BF,$C0                ;111
          .dc.b      $10,$0F                ;113
          .dc.b      $BF,$FF                ;115
          .dc.b      $EF,$00                ;117
          .dc.b      $3F,$FF                ;119
          .dc.b      $BC,$00                ;121
          .dc.b      $BF,$C0                ;123
          .dc.b      $00,$00                ;125
          .dc.b      $00,$00                ;127
          .dc.b      $BF,$FF                ;129
          .dc.b      $00,$03                ;131
          .dc.b      $B0,$00                ;133
          .dc.b      $B0,$00                ;135
          .dc.b      $00,$3F                ;137
          .dc.b      $BF,$FF                ;139
          .dc.b      $03,$FF                ;141
          .dc.b      $00,$00                ;143
          .dc.b      $00,$FF                ;145
          .dc.b      $BF,$FF                ;147
          .dc.b      $BF,$FF                ;149
          .dc.b      $FB,$FF                ;151
          .dc.b      $13,$FF                ;153
          .dc.b      $00,$3F                ;155
          .dc.b      $3F,$FF                ;157
          .dc.b      $BF,$FC                ;159
          .dc.b      $BF,$FF                ;161
          .dc.b      $00,$03                ;163
          .dc.b      $3F,$FF                ;165
          .dc.b      $BC,$00                ;167
          .dc.b      $BC,$00                ;169
          .dc.b      $BF,$FF                ;171
          .dc.b      $BC,$04                ;173
          .dc.b      $BF,$FF                ;175
          .dc.b      $BF,$FF                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $BF,$FC                ;181
          .dc.b      $01,$00                ;183
          .dc.b      $BF,$FF                ;185
          .dc.b      $BF,$FF                ;187
          .dc.b      $BF,$FF                ;189
          .dc.b      $BF,$FF                ;191
          .dc.b      $FF,$FF                ;WINGS0
          .dc.b      $BF,$FF                ;195
          .dc.b      $BF,$FC                ;197
          .dc.b      $BF,$FF                ;199
          .dc.b      $BF,$FF                ;201
          .dc.b      $7F,$FF                ;203
          .dc.b      $BF,$FF                ;205
          .dc.b      $BF,$FF                ;207
          .dc.b      $7F,$FF                ;209
          .dc.b      $BF,$FF                ;211
          .dc.b      $BF,$FF                ;213
          .dc.b      $FF,$FF                ;WINGS1

          .dc.b      $69,$56                ;TITCHR13
          .dc.b      $6A,$90                ;TITCHR14
          .dc.b      $69,$00                ;TITCHR15
          .dc.b      $69,$54                ;TITCHR16
          .dc.b      $6A,$90                ;TITCHR17
          .dc.b      $65,$19                ;TITCHR18
          .dc.b      $7D,$01                ;TITCHR19
          .dc.b      $F5,$F4                ;TITCHR20
          .dc.b      $7D,$01                ;TITCHR21
          .dc.b      $F4,$01                ;TITCHR22
          .dc.b      $F5,$F4                ;TITCHR23
          .dc.b      $7D,$1D                ;TITCHR24
          .dc.b      $FF,$FF                ;WINGS2        241
          .dc.b      $54,$2A                ;WINGS3        243
          .dc.b      $AA,$AA                ;WINGS4        245
          .dc.b      $A8,$15                ;WINGS5        247
          .dc.b      $3F,$FF                ;WINGS6        249
          .dc.b      $3F,$FF                ;WINGS7        251
          .dc.b      $FF,$FC                ;WINGS8        253
          .dc.b      $FF,$FC                ;WINGS9        255  TH-THAT'S ALL FOLKS

          ORG     $8E00

          .dc.b      $55,$50                ;TITCHR1
          .dc.b      $55,$56                ;TITCHR2
          .dc.b      $55,$50                ;TITCHR3
          .dc.b      $55,$56                ;TITCHR4
          .dc.b      $55,$54                ;TITCHR5
          .dc.b      $55,$55                ;TITCHR6
          .dc.b      $69,$64                ;TITCHR7
          .dc.b      $69,$00                ;TITCHR8
          .dc.b      $1A,$A4                ;TITCHR9
          .dc.b      $69,$00                ;TITCHR10
          .dc.b      $6A,$A4                ;TITCHR11
          .dc.b      $06,$90                ;TITCHR12

          .dc.b      $00,$00                ;25
          .dc.b      $00,$04                ;27
          .dc.b      $00,$10                ;29
          .dc.b      $00,$00                ;31
          .dc.b      $20,$00                ;33
          .dc.b      $00,$00                ;35
          .dc.b      $10,$00                ;37
          .dc.b      $00,$00                ;39
          .dc.b      $80,$40                ;41
          .dc.b      $00,$00                ;43
          .dc.b      $00,$00                ;45
          .dc.b      $00,$00                ;47
          .dc.b      $00,$00                ;49
          .dc.b      $82,$08                ;51
          .dc.b      $20,$00                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $00,$00                ;57
          .dc.b      $00,$00                ;59
          .dc.b      $40,$00                ;61
          .dc.b      $00,$00                ;63
          .dc.b      $00,$00                ;65
          .dc.b      $01,$04                ;67
          .dc.b      $04,$00                ;69
          .dc.b      $44,$00                ;71
          .dc.b      $04,$40                ;73
          .dc.b      $03,$FF                ;75
          .dc.b      $CF,$00                ;77
          .dc.b      $00,$00                ;79
          .dc.b      $00,$00                ;81
          .dc.b      $FF,$FC                ;83
          .dc.b      $00,$00                ;85
          .dc.b      $FF,$FF                ;87
          .dc.b      $FE,$C0                ;89
          .dc.b      $00,$00                ;91
          .dc.b      $00,$00                ;93
          .dc.b      $00,$00                ;95
          .dc.b      $00,$03                ;97
          .dc.b      $00,$00                ;99
          .dc.b      $03,$FF                ;101
          .dc.b      $00,$00                ;103
          .dc.b      $00,$00                ;105
          .dc.b      $00,$03                ;107
          .dc.b      $FF,$FF                ;109
          .dc.b      $FF,$00                ;111
          .dc.b      $00,$03                ;113
          .dc.b      $FF,$FF                ;115
          .dc.b      $FF,$F0                ;117
          .dc.b      $3F,$FF                ;119
          .dc.b      $FC,$00                ;121
          .dc.b      $FF,$F0                ;123
          .dc.b      $00,$00                ;125
          .dc.b      $00,$00                ;127
          .dc.b      $FF,$FF                ;129
          .dc.b      $00,$03                ;131
          .dc.b      $00,$00                ;133
          .dc.b      $C0,$00                ;135
          .dc.b      $00,$03                ;137
          .dc.b      $FF,$FF                ;139
          .dc.b      $02,$3F                ;141
          .dc.b      $00,$00                ;143
          .dc.b      $00,$3F                ;145
          .dc.b      $FF,$FF                ;147
          .dc.b      $FF,$FF                ;149
          .dc.b      $BF,$FF                ;151
          .dc.b      $00,$0F                ;153
          .dc.b      $00,$03                ;155
          .dc.b      $3F,$FF                ;157
          .dc.b      $FF,$FC                ;159
          .dc.b      $FF,$FF                ;161
          .dc.b      $00,$03                ;163
          .dc.b      $3F,$FF                ;165
          .dc.b      $C0,$00                ;167
          .dc.b      $C0,$00                ;169
          .dc.b      $FF,$FF                ;171
          .dc.b      $C0,$00                ;173
          .dc.b      $FF,$FF                ;175
          .dc.b      $FF,$FF                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $F0,$00                ;181
          .dc.b      $00,$00                ;183
          .dc.b      $FF,$FF                ;185
          .dc.b      $F3,$03                ;187
          .dc.b      $FF,$FF                ;189
          .dc.b      $CC,$3F                ;191
          .dc.b      $00,$00                ;WINGS0
          .dc.b      $FF,$FF                ;195
          .dc.b      $FF,$FC                ;197
          .dc.b      $FF,$FF                ;199
          .dc.b      $FF,$FF                ;201
          .dc.b      $3F,$FF                ;203
          .dc.b      $FF,$FF                ;205
          .dc.b      $FF,$FF                ;207
          .dc.b      $3F,$FF                ;209
          .dc.b      $FF,$FF                ;211
          .dc.b      $FF,$FF                ;213
          .dc.b      $00,$00                ;WINGS1

          .dc.b      $55,$56                ;TITCHR13
          .dc.b      $55,$50                ;TITCHR14
          .dc.b      $55,$00                ;TITCHR15
          .dc.b      $55,$54                ;TITCHR16
          .dc.b      $55,$50                ;TITCHR17
          .dc.b      $54,$15                ;TITCHR18
          .dc.b      $69,$01                ;TITCHR19
          .dc.b      $A5,$A4                ;TITCHR20
          .dc.b      $69,$01                ;TITCHR21
          .dc.b      $A4,$01                ;TITCHR22
          .dc.b      $A5,$A4                ;TITCHR23
          .dc.b      $69,$69                ;TITCHR24
          .dc.b      $00,$00                ;WINGS2        241
          .dc.b      $00,$80                ;WINGS3        243
          .dc.b      $00,$00                ;WINGS4        245
          .dc.b      $02,$00                ;WINGS5        247
          .dc.b      $00,$00                ;WINGS6        249
          .dc.b      $00,$00                ;WINGS7        251
          .dc.b      $00,$00                ;WINGS8        253
          .dc.b      $00,$00                ;WINGS9        255  TH-THAT'S ALL FOLKS

          ORG     $8F00

          .dc.b      $55,$80                ;TITCHR1
          .dc.b      $55,$56                ;TITCHR2
          .dc.b      $15,$40                ;TITCHR3
          .dc.b      $55,$56                ;TITCHR4
          .dc.b      $55,$50                ;TITCHR5
          .dc.b      $55,$55                ;TITCHR6
          .dc.b      $7D,$74                ;TITCHR7
          .dc.b      $7D,$00                ;TITCHR8
          .dc.b      $7F,$D0                ;TITCHR9
          .dc.b      $7D,$00                ;TITCHR10
          .dc.b      $7F,$FD                ;TITCHR11
          .dc.b      $07,$D0                ;TITCHR12

          .dc.b      $00,$01                ;25
          .dc.b      $00,$00                ;27
          .dc.b      $00,$01                ;29
          .dc.b      $00,$01                ;31
          .dc.b      $00,$01                ;33
          .dc.b      $00,$01                ;35
          .dc.b      $00,$01                ;37
          .dc.b      $00,$01                ;39
          .dc.b      $00,$01                ;41
          .dc.b      $08,$01                ;43
          .dc.b      $00,$01                ;45
          .dc.b      $00,$01                ;47
          .dc.b      $00,$01                ;49
          .dc.b      $00,$01                ;51
          .dc.b      $00,$01                ;53
          .dc.b      $00,$00                ;55
          .dc.b      $00,$01                ;57
          .dc.b      $00,$01                ;59
          .dc.b      $00,$01                ;61
          .dc.b      $00,$01                ;63
          .dc.b      $00,$01                ;65
          .dc.b      $00,$01                ;67
          .dc.b      $10,$41                ;69
          .dc.b      $00,$01                ;71
          .dc.b      $01,$01                ;73
          .dc.b      $3F,$FF                ;75
          .dc.b      $00,$01                ;77
          .dc.b      $00,$01                ;79
          .dc.b      $00,$01                ;81
          .dc.b      $FF,$FD                ;83
          .dc.b      $00,$01                ;85
          .dc.b      $FF,$FF                ;87
          .dc.b      $FF,$FC                ;89
          .dc.b      $00,$01                ;91
          .dc.b      $00,$01                ;93
          .dc.b      $00,$01                ;95
          .dc.b      $00,$04                ;97
          .dc.b      $00,$01                ;99
          .dc.b      $00,$0F                ;101
          .dc.b      $00,$01                ;103
          .dc.b      $00,$04                ;105
          .dc.b      $00,$00                ;107
          .dc.b      $3F,$FF                ;109
          .dc.b      $FF,$01                ;111
          .dc.b      $00,$03                ;113
          .dc.b      $FF,$FF                ;115
          .dc.b      $FF,$FC                ;117
          .dc.b      $3F,$FF                ;119
          .dc.b      $FF,$01                ;121
          .dc.b      $FF,$F1                ;123
          .dc.b      $00,$01                ;125
          .dc.b      $00,$01                ;127
          .dc.b      $FF,$FF                ;129
          .dc.b      $00,$00                ;131
          .dc.b      $00,$01                ;133
          .dc.b      $00,$01                ;135
          .dc.b      $00,$01                ;137
          .dc.b      $FF,$FF                ;139
          .dc.b      $00,$01                ;141
          .dc.b      $00,$01                ;143
          .dc.b      $00,$01                ;145
          .dc.b      $FF,$FF                ;147
          .dc.b      $FF,$FF                ;149
          .dc.b      $FF,$FF                ;151
          .dc.b      $00,$00                ;153
          .dc.b      $00,$04                ;155
          .dc.b      $3F,$FF                ;157
          .dc.b      $FF,$FC                ;159
          .dc.b      $3F,$FF                ;161
          .dc.b      $00,$04                ;163
          .dc.b      $3F,$FC                ;165
          .dc.b      $00,$00                ;167
          .dc.b      $00,$00                ;169
          .dc.b      $FF,$FF                ;171
          .dc.b      $00,$00                ;173
          .dc.b      $FF,$FF                ;175
          .dc.b      $FF,$FF                ;177
          .dc.b      $00,$00                ;179
          .dc.b      $00,$01                ;181
          .dc.b      $00,$01                ;183
          .dc.b      $FF,$FF                ;185
          .dc.b      $00,$01                ;187
          .dc.b      $FF,$FF                ;189
          .dc.b      $00,$01                ;191
          .dc.b      $FF,$FF                ;WINGS0
          .dc.b      $FF,$FF                ;195
          .dc.b      $FF,$FC                ;197
          .dc.b      $3F,$FF                ;199
          .dc.b      $00,$01                ;201
          .dc.b      $3F,$FF                ;203
          .dc.b      $FF,$FF                ;205
          .dc.b      $FF,$F0                ;207
          .dc.b      $3F,$FF                ;209
          .dc.b      $3F,$FF                ;211
          .dc.b      $3F,$FF                ;213
          .dc.b      $FF,$FF                ;WINGS1

          .dc.b      $55,$56                ;TITCHR13
          .dc.b      $15,$40                ;TITCHR14
          .dc.b      $55,$00                ;TITCHR15
          .dc.b      $15,$54                ;TITCHR16
          .dc.b      $15,$40                ;TITCHR17
          .dc.b      $54,$15                ;TITCHR18
          .dc.b      $7D,$01                ;TITCHR19
          .dc.b      $F5,$F4                ;TITCHR20
          .dc.b      $7D,$01                ;TITCHR21
          .dc.b      $F4,$01                ;TITCHR22
          .dc.b      $F5,$F4                ;TITCHR23
          .dc.b      $7D,$FD                ;TITCHR24
          .dc.b      $FF,$FF                ;WINGS2        241
          .dc.b      $20,$00                ;WINGS3        243
          .dc.b      $00,$00                ;WINGS4        245
          .dc.b      $00,$08                ;WINGS5        247
          .dc.b      $00,$FF                ;WINGS6        249
          .dc.b      $03,$FF                ;WINGS7        251
          .dc.b      $FF,$C0                ;WINGS8        253
          .dc.b      $FF,$00                ;WINGS9        255  TH-THAT'S ALL FOLKS

;          END
