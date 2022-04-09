
.pad RESET_0, $ff
; reset
	SEI
	INC RESET_0 + 1
	JMP JMP_07_ce02
	.db "          YOSHI"
	.db $33, $ea, $ab, $53, $32, $04, $01, $04, $01, $c6
	; NES vector table
	.dw NMI
	.dw RESET_1
	.dw IRQ
