;	bank data 4
;	desert and room screens

	.6502

	.include	"ADDR.S"
	.include	"\\c\\macros.s"
;
;	bank sw
;
setbank	4
;
;	bitmaps
;
;	desert screen
;
bitmap	DES1,"des1.s"
bitmap	DES2,"des2.s"
bitmap	CACTUS,"cactus.s"
bitmap	SCORPION,"scorpion.s"
bitmap	ANTL,"antl.s"
bitmap	ANTR,"antr.s"
bitmap	BIRD1R,"bird1r.s"
bitmap	BIRD2R,"bird2r.s"
bitmap	RABBIT,"rabbit.s"
bitmap	SNAKE,"snake.s"
bitmap	DEST,"DEST.S"
;
;	room screen
;
bitmap	C1B,"c1b.S"
bitmap	ROOM1,"room1.S"
bitmap	ROOM2,"room2.S"
bitmap	ROOM3,"room3.S"
bitmap	ROOM4,"room4.S"
bitmap	ROOM5,"room5.S"
bitmap	ROOM6,"room6.S"
bitmap	COAT,"coat.S"
bitmap	DAGGER1,"dag2.s"
bitmap	DRAG,"dragon.s"
bitmap	TRAP1,"trap.s"
bitmap	ROOFRBL,"ROOFRBL.S"
bitmap	BOWL,"BOWL.S"
bitmap	TORCH,"TORCH.S"
bitmap	CHEST,"CHEST.S"
bitmap	RDFACE,"RDFACE.S"
bitmap	SPEAR,"SPEAR.S"
bitmap	FLASH,"FLASH.S"
bitmap	FACE1,"FACE1.S"
bitmap	SHOTF1,"SHOTF1.S"
bitmap	FACE2,"FACE2.S"
bitmap	SHOTF2,"SHOTF2.S"

.end
