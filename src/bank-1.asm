; PRG 1 contains all the music as well as the sound engine
; and OAM tile indeces, OAM attributes/coordinates and palette data

.include "src/sound/music/title.asm"
.include "src/sound/music/starman.asm"
.include "src/sound/music/flower.asm"
.include "src/sound/music/mushroom.asm"
.include "src/sound/music/vsmatch.asm"
.include "src/sound/music/gameover.asm"
.include "src/sound/music/stageclear.asm"
.include "src/sound/music/currentscore.asm"
.include "src/sound/music/gamepoint.asm"
.include "src/sound/music/vsresults.asm"
.include "src/sound/music/unused.asm"
.include "src/sound/music/vsmenu.asm"
.include "src/sound/sfx-1.asm"
.include "src/sound/music/roundend.asm"

.include "src/sound/engine.asm"

.include "src/data/gfx/oam.asm"
.include "src/data/gfx/palettes.asm"

Data_01_b106:
	.db $20, $25, $15, $da, $da, $da, $da, $da, $da, $da, $da, $da, $da
	.db $da, $da, $da, $da, $da, $da, $da, $da, $da, $da, $da, $da, $20
	.db $45, $16, $da, $da, $da, $da, $da, $6b, $6c, $6d, $6e, $da, $b0
	.db $b1, $b2, $b3, $b4, $b5, $b6, $b7, $b8, $da, $da, $da, $0c, $20
	.db $65, $16, $da, $da, $78, $79, $7a, $7b, $7c, $7d, $7e, $7f, $c0
	.db $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $da, $da, $0c, $20
	.db $85, $16, $da, $da, $88, $89, $8a, $8b, $8c, $8d, $8e, $8f, $d0
	.db $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $da, $da, $0c, $20
	.db $a5, $16, $da, $da, $98, $99, $9a, $9b, $9c, $9d, $9e, $9f, $e0
	.db $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $da, $da, $0c, $20
	.db $c5, $16, $da, $da, $da, $da, $aa, $ab, $ac, $ad, $ae, $af, $f0
	.db $f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $da, $da, $0c, $20
	.db $e5, $16, $da, $da, $da, $da, $ba, $bb, $bc, $bd, $be, $bf, $ea
	.db $eb, $ec, $ed, $ee, $ef, $47, $48, $a8, $a9, $da, $da, $0c, $21
	.db $05, $16, $da, $da, $da, $da, $da, $cb, $cc, $cd, $ce, $cf, $fa
	.db $fb, $fc, $fd, $fe, $80, $6f, $64, $65, $da, $da, $da, $0c, $21
	.db $25, $16, $da, $da, $da, $da, $da, $db, $dc, $dd, $de, $df, $da
	.db $0f, $1f, $2f, $3f, $4f, $68, $74, $75, $da, $da, $da, $0c, $21
	.db $45, $16, $da, $da, $da, $da, $da, $da, $da, $da, $da, $da, $da
	.db $da, $da, $da, $da, $da, $da, $da, $da, $da, $da, $da, $0c, $21
	.db $66, $15, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
	.db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $20, $38
	.db $01, $25, $26, $21, $8e, $0d, $51, $52, $53, $00, $52, $53, $54
	.db $55, $56, $57, $58, $59, $5a, $5b, $21, $a9, $04, $00, $01, $02
	.db $03, $04, $21, $c9, $04, $10, $11, $12, $13, $14, $21, $e9, $04
	.db $20, $21, $22, $23, $24, $22, $09, $04, $30, $31, $32, $33, $34
	.db $22, $2a, $06, $07, $08, $09, $0a, $0b, $00, $0d, $22, $4b, $05
	.db $18, $19, $1a, $1b, $1c, $1d, $22, $6b, $05, $28, $29, $2a, $2b
	.db $2c, $2d, $22, $8b, $06, $38, $39, $3a, $3b, $3c, $3d, $3e, $22
	.db $ab, $06, $00, $00, $4a, $4b, $4c, $4d, $4e, $22, $ce, $03, $5c
	.db $5d, $5e, $5f, $22, $53, $02, $62, $63, $81, $22, $73, $03, $72
	.db $73, $82, $83, $22, $93, $03, $90, $91, $92, $93, $22, $b3, $03
	.db $a0, $a1, $a2, $a3, $22, $d3, $03, $0e, $1e, $2e, $6a, $23, $0e
	.db $06, $40, $41, $42, $43, $44, $45, $46, $23, $4e, $06, $50, $41
	.db $42, $43, $44, $45, $46
