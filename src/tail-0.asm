
.pad RESET_0, $ff
; reset
	SEI
	INC RESET_0 + 1
	JMP StartGame
	.db "          YOSHI"
	.db $00, $00, $ab, $53, $32, $04, $01, $04, $01, $c6
	; NES vector table
	.dw PRG_NMI
	.dw RESET_1
	.dw DUMMY_IRQ
