IFNDEF NSF_ROM
	.db "NES", $1a
	.db 8  ; 128K PRG
	.db 16 ; 128K CHR
	.db MMC1 << 4
	.db 0, 0, 0, 0, "aster"
ELSE
	.db "NESM", $1a ; handshake
	.db $1 ; version
	.db NSF_Music_End - NSF_Music
	.db $1 ; starting song
	.dw LOAD
	.dw INIT
	.dw PLAY
	.db "Yoshi's Egg/Yoshi/Mario & Yoshi"
	.db 0
	.db "Junichi Masuda"
	.dsb 18, 0
	.db "'91, '96, Game Freak inc"
	.dsb 8, 0
	.dw $411a ; NTSC
	.db 1, 2, 3, 4, 5, 6, 7, 0
	.dw 0 ; PAL, unused
	.db 0 ; this is an NTSC file
	.db 0 ; no extra chip (North American settings)
	.dsb 4, 0 ; proceeding data is program data

ENDIF