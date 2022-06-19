.include "src/sound/dpcm.asm"
.include "src/sound/headers.asm"
.include "src/sound/instruments.asm"
.include "src/sound/sfx-7.asm"

Sub_07_cca8:
	LDX $0260
	BEQ @07_ccb1
	INX
	BNE @07_ccba
	RTS
@07_ccb1:
	LDA $0262
	STA $0261
	JMP @07_cd1f
@07_ccba:
	JSR SwitchToAudio
	LDA $0260
	ORA #$40
	STA $0260
	LDA $0262
	STA $0261
	LDX #$17
@07_cccd:
	LDA $0264, X
	BMI @07_ccdb
	CMP #$7f
	BEQ @07_ccdb
	STA zChannelTotal
	JSR Sub_07_cd38
@07_ccdb:
	DEX
	CPX #$0b
	BNE @07_cce2
	LDX #$03
@07_cce2:
	CPX #$ff
	BNE @07_cccd
	LDA $0260
	EOR #$80
	STA $0260
	BMI @07_cd07
	LDX #$04
@07_ccf2:
	LDA $0264, X
	BMI @07_cd00
	CMP #$7f
	BEQ @07_cd00
	STA zChannelTotal
	JSR Sub_07_cd38
@07_cd00:
	INX
	CPX #$0c
	BNE @07_ccf2
	BEQ @07_cd1f
@07_cd07:
	LDX #$0b
@07_cd09:
	LDA $0264, X
	BMI @07_cd17
	CMP #$7f
	BEQ @07_cd17
	STA zChannelTotal
	JSR Sub_07_cd38
@07_cd17:
	DEX
	CPX #$03
	BNE @07_cd09
	JSR SwitchToMain
@07_cd1f:
	LDX $0261
	BEQ @07_cd2f
@07_cd24:
	LDA #$f8
	STA iVirtualOAM, X
	XAD 4
	BNE @07_cd24
@07_cd2f:
	LDA $0260
	AND #$bf
	STA $0260
	RTS

Sub_07_cd38:
	STX zAuxPointer
	STY zAuxPointer + 1
	ASL A
	TAY
	LDA OAMPointers, Y
	STA zOAMOverheadPointer
	LDA OAMPointers + 1, Y
	STA zOAMOverheadPointer + 1
	CLC
	LDA $0263
	BEQ @07_cd53
	LDA zPPUScrollX
	EOR #-1
	SEC
@07_cd53:
	ADC $0294, X
	CLC
	ADC #0
	STA zOAMOffset
	CLC
	LDA $0263
	BEQ @07_cd79
	LDA zPPUScrollY
	BEQ @07_cd79
	LDA zPPUControl
	AND #2
	BNE @07_cd72
	LDA zPPUScrollY
	EOR #-1
	SEC
	BCS @07_cd79
@07_cd72:
	LDA zPPUScrollY
	ADC #$10
	EOR #-1
	SEC
@07_cd79:
	ADC $02ac, X
	CLC
	ADC #-1
	STA ze3
	LDA $027c, X
	ASL A
	ASL A
	TAY
	LDA (zOAMOverheadPointer), Y
	STA zOAMTileNumPointer
	INY
	LDA (zOAMOverheadPointer), Y
	STA zOAMTileNumPointer + 1
	INY
	LDA (zOAMOverheadPointer), Y
	STA zOAMAttrCoordPointer
	INY
	LDA (zOAMOverheadPointer), Y
	STA zOAMAttrCoordPointer + 1
	LDY #0
	LDA (zOAMTileNumPointer), Y
	STA zNumOAMTiles
	LDY #0
	LDA (zOAMAttrCoordPointer), Y
	STA zOAMAttributes
	LDA #1
	STA zOAMTileNoIndex
	STA zOAMCoordID
	JSR Sub_07_cdb4
	LDX zAuxPointer
	LDY zAuxPointer + 1
	RTS

Sub_07_cdb4:
	LDX $0261
@07_cdb7:
; y-pos
	LDY zOAMCoordID
	LDA (zOAMAttrCoordPointer), Y
	INC zOAMCoordID
	CLC
	ADC ze3
	STA iVirtualOAM, X
; tile no.
	INX
	LDY zOAMTileNoIndex
	LDA (zOAMTileNumPointer), Y
	INC zOAMTileNoIndex
	STA iVirtualOAM, X
; attr
	INX
	LDA zOAMAttributes
	STA iVirtualOAM, X
; x-pos
	INX
	LDY zOAMCoordID
	LDA (zOAMAttrCoordPointer), Y
	INC zOAMCoordID
	CLC
	ADC zOAMOffset
	STA iVirtualOAM, X
	INX
	BEQ @07_cde7
	DEC zNumOAMTiles
	BNE @07_cdb7
@07_cde7:
	STX $0261
	RTS

Sub_07_cdeb:
	LDA #$00
	STA $0262

Sub_07_cdf0:
	LDX #$00
	LDA #$ff
@07_cdf4:
	STA $0264, X
	INX
	CPX #$18
	BNE @07_cdf4
	LDA #$01
	STA $0263
	RTS


StartGame:
	SEI
	CLD
	LDA #0 ; hide everything, no color skews
	STA PPUMASK
	STA zPPUMask
	; $2000 NT, h inc, obj 0, bg 1, 8x8 obj, read, no NMI
	LDA #BG_TABLE
	STA PPUCTRL
	STA zPPUControl
	LDX #$0f
@wait_for_vblank:
	LDA PPUSTATUS
	BPL @wait_for_vblank
	DEX
	BPL @wait_for_vblank
	JSR ResetMapper
	LDA #1
	STA JOY2
	LDA #0
	STA SND_CHN
	LDA #CHR_MODE | PRG_L16 | MMC1_2MIRROR_H
	STA zMMC1Ctrl
	LDA #CHR_Title
	STA zMMC1Chr
	LDA #CHR_Title
	STA zMMC1Chr + 1
	LDA #PRG_Main
	STA zMMC1Prg
	JSR WriteToMapper
	LDA z00
	CMP #$12
	BNE @07_ce4e
	LDA z01
	CMP #$48
	BNE @07_ce4e
	LDA z02
	CMP #$9e
	BEQ @07_ce63
@07_ce4e:
	LDA #$01
	STA $0616
	LDA #$12
	STA z00
	LDA #$48
	STA z01
	LDA #$9e
	STA z02
	LDX #$03
	BNE @07_ce73
@07_ce63:
	LDA #$00
	STA $0616
	LDA iDisableMusic
	BEQ @07_ce71
	AND #$01
	STA zPlayerMode
@07_ce71:
	LDX #$83
@07_ce73:
	LDA #$00
@07_ce75:
	STA z00, X
	INX
	BNE @07_ce75
	LDY $0616
	LDX #$00
@07_ce7f:
	STA i100, X
	STA i200, X
	STA $0300, X
	STA $0400, X
	STA $0500, X
	STA $0600, X
	STA $0700, X
	INX
	BNE @07_ce7f
	STY $0616
	LDX #<iStackTop
	TXS
	LDA #$3f
	STA PPUADDR
	LDA #$00
	STA PPUADDR
	STA PPUADDR
	STA PPUADDR
	JSR Sub_07_cecf
	LDA #$00
	STA zPPUScrollX
	LDA #%00000000 ; hide everything, no color skews
	STA PPUMASK
	LDA #%00011110 ; show everything, no color skews
	STA zPPUMask
	STA iPPUMask
	; $2000 NT, h inc, obj 0, bg 1, 8x8 obj, read, NMI
	LDA #NMI | BG_TABLE
	STA iPPUControl
	JSR CopyPPUControl
	LDA #$00
	STA zb6
	JMP JMP_00_a37c

Sub_07_cecf:
	LDA #CHR_Title
	STA zMMC1Chr
	STA zMMC1Chr + 1
	STA i248
	STA $0260
	LDA #$ff
	STA i200
	LDA #$00
	STA zPointerB7
	LDA #$02
	STA zPointerB7 + 1
	LDA #$20
	STA zc3
	LDA #$00
	STA zb9
	STA zPPUScrollX
	STA zPPUScrollY
	STA i222
	LDA #$10
	STA i220
	JSR InitNametable
	LDA #$0f
	LDX #$1f
@07_cf03:
	STA iPals, X
	DEX
	BPL @07_cf03
	JSR HideSprites
	JSR InitSound
	RTS
; unreferenced
	.db $00, $00

.include "src/home/mapper.asm"

Sub_07_cf7f:
	LDA i220
	BNE @07_cf85
	RTS
@07_cf85:
	STA zbc
	JMP Branch_07_d02a


JMP_07_cf8a:
	LDX PPUSTATUS
	AND #$3f
	STA PPUADDR
	STA zbb
	LDA (zPointerB7), Y
	AND #$c0
	STA zbd
	INY
	LDA (zPointerB7), Y
	STA PPUADDR
	STA zba
	INY
	LDA zPPUControl
	AND #NMI | MS_SELECT | OBJ_RES | BG_TABLE | OBJ_TABLE | NT_BASE_MASK
	STA zPPUControl
	LDA (zPointerB7), Y
	ASL A
	BMI @07_cfb1
	LDA #$00
	; desynced, BIT $04a9
	.db $2c
@07_cfb1:
	LDA #VRAM_INC ; vertical
	ORA zPPUControl
	STA PPUCTRL
	LDA (zPointerB7), Y
	AND #$3f
	TAX
	LDA #$ff
	BIT zbd
	BEQ Branch_07_cfe0
	BVS @07_cfc8
	JMP Sub_07_d050
@07_cfc8:
	PHP
	INY
	PHY
	LDA (zPointerB7), Y
	TAY
	LDA i221, Y
	CMP #$ff
	BNE @07_cfd6 ; useless
@07_cfd6:
	STA zc0
	PLY
	PLP
	JMP Branch_07_cfe0

Branch_07_cfde:
	BCS Branch_07_cfe1
Branch_07_cfe0:
	INY
Branch_07_cfe1:
	LDA (zPointerB7), Y
	BIT zbd
	BVC @07_cfec
	PHP
	CLC
	ADC zc0
	PLP
@07_cfec:
	STA PPUDATA
	INC zPPUDataCounter
	DEX
	BMI @07_d01d
	LDA zPPUMask
	AND #%00011000 ; are we showing background and sprites?
	BEQ Branch_07_cfde
	DEC zbc
	BNE Branch_07_cfde
	STX zbc
	ROR A
	ORA zbc
	STA (zPointerB7), Y
	DEY
	CLC
	LDA zPPUDataCounter
	ADC zba
	STA (zPointerB7), Y
	DEY
	LDA #$00
	ADC zbb
	STA (zPointerB7), Y
	DEY
	BMI Branch_07_d04f
	JSR Sub_07_d050
	JMP Branch_07_d04f
@07_d01d:
	JSR Sub_07_d050
	LDA zPPUMask
	AND #%00011000 ; are we showing background and sprites?
	BEQ Branch_07_d02a
	DEC zbc
	BEQ Branch_07_d04f
Branch_07_d02a:
	LDX PPUSTATUS
	LDY #0
	STY zbd
	STY zPPUDataCounter
	STY zbf
	LDA (zPointerB7), Y
	CMP #$ff
	BEQ @07_d03e
	JMP JMP_07_cf8a
@07_d03e:
	LDA #$00
	STA zb9
	LDA #$00
	STA zPointerB7
	LDA #$02
	STA zPointerB7 + 1
	LDA #$ff
	STA i200
Branch_07_d04f:
	RTS

Sub_07_d050:
	TYA
	SEC
	ADC zPointerB7
	STA zPointerB7
	LDA #$00
	ADC zPointerB7 + 1
	STA zPointerB7 + 1
	RTS

Sub_07_d05d:
	LDX zb9
	STA i200, X
	INC zb9
	RTS

Sub_07_d065:
	LDA #$ff
	LDX zb9
	STA i200, X
	RTS
; unreferenced
	JSR Sub_07_d097
	LDX zb9
	LDA zc5
	STA i200, X
	INX
	LDA zc4
	STA i200, X
	INX
	STX zb9
	RTS
; unreferenced
	JSR Sub_07_d097
	LDX zb9
	LDA zc5
	ORA #$40
	STA i200, X
	INX
	LDA zc4
	STA i200, X
	INX
	STX zb9
	RTS

Sub_07_d097:
	LDA #$00
	STA zc4
	STA zc5
	LDA zc2
	LTH A
	ROL zc5
	ASL A
	ROL zc5
	CLC
	ADC zc1
	STA zc4
	LDA zc3
	ADC zc5
	STA zc5
	RTS
; unreferenced
	LDA #$ff
	LDX #$07
@07_d0b8:
	STA i200, X
	DEX
	BPL @07_d0b8
	RTS

Sub_07_d0bf:
	LDA i224
	BNE @07_d0c5
	RTS
@07_d0c5:
	LDA zPPUControl
	AND #$ff ^ VRAM_INC
	STA PPUCTRL
	LDA #>PPU_PALETTES
	STA PPUADDR
	LDA #<PPU_PALETTES
	STA PPUADDR
	LDX #0
	LDY #num_pals * pal_size - 1
@07_d0da:
	LDA iPals, X
	STA PPUDATA
	INX
	DEY
	BPL @07_d0da
	LDA i224
	AND #$f0
	STA i224
	LDA zPPUControl
	STA PPUCTRL
	RTS

Sub_07_d0f2:
	LDA i224
	BEQ @07_d123
	DEC i225
	BNE @07_d123
	LDA #$02
	STA i225
	LDA i224
	SEC
	SBC #$10
	STA i224
	LDX #$1f
@07_d10c:
	LDA iPaletteTable, X
	SEC
	SBC i224
	BPL @07_d11a
	LDA iPaletteTable, X
	AND #(num_pals * pal_size / 2) - 1
@07_d11a:
	STA iPals, X
	DEX
	BPL @07_d10c
	INC i224
@07_d123:
	RTS

Sub_07_d124:
	LTH A
	ASL A
	TAX
	JSR SwitchToAudio
	LDY #0
@07_d12f:
	LDA Pal_01_b006, X
	STA iPaletteTable, Y
	LDA #$0f
	STA iPals, Y
	INX
	INY
	CPY #num_pals * pal_size
	BNE @07_d12f
	JSR SwitchToMain
	LDA #$40
	STA i224
	LDA #$02
	STA i225
	RTS
; unreferenced
	LTH A
	ASL A
	TAX
	JSR SwitchToAudio
	LDY #0
@07_d159:
	LDA Pal_01_b006, X
	STA iPals, Y
	INX
	INY
	CPY #$20
	BNE @07_d159
	JSR SwitchToMain
	LDA #$01
	STA i224
	RTS

Sub_07_d16e:
	LDA $0616
	BEQ @07_d174
	RTS
@07_d174:
	JSR UpdateJoypads
	LDA iJoyPressed
	STA iJoyBackup
	LDA iJoyPressed + 1
	STA iJoyBackup + 1
	JSR UpdateJoypads
	LDA iJoyPressed
	CMP iJoyBackup
	BNE Branch_07_d202
	LDA iJoyPressed + 1
	CMP iJoyBackup + 1
	BNE Branch_07_d202
	LDA iDisableMusic
	BEQ @07_d19e
	JSR Sub_07_d203
@07_d19e:
	LDA iJoyCurrent
	STA iJoyXOR
	LDA iJoyCurrent + 1
	STA iJoyXOR + 1
	LDA iJoyPressed
	STA iJoyCurrent
	LDA iJoyPressed + 1
	STA iJoyCurrent + 1
	LDX #1
@07_d1b8:
	LDA iJoyCurrent, X
	AND #BTN_RIGHT | BTN_LEFT
	CMP #BTN_RIGHT | BTN_LEFT
	BNE @07_d1c7
	EOR iJoyCurrent, X
	STA iJoyCurrent, X
@07_d1c7:
	LDA iJoyCurrent, X
	AND #BTN_DOWN | BTN_UP
	CMP #BTN_DOWN | BTN_UP
	BNE @07_d1d6
	EOR iJoyCurrent, X
	STA iJoyCurrent, X
@07_d1d6:
	LDA iJoyCurrent, X
	EOR iJoyXOR, X
	STA iJoy24d, X
	AND iJoyCurrent, X
	STA iJoyHeld, X
	LDA iJoyCurrent, X
	EOR #-1
	AND iJoy24d, X
	STA iJoy24d, X
	DEX
	BPL @07_d1b8
	LDA iJoyCurrent
	AND #BTN_START | BTN_SELECT | BTN_B | BTN_A
	CMP #BTN_START | BTN_SELECT | BTN_B | BTN_A
	BNE Branch_07_d202
	JSR DisablePicture
	JMP StartGame
Branch_07_d202:
	RTS

Sub_07_d203:
	LDA i248
	CMP #$05
	BNE Branch_07_d202
	LDA iJoyPressed
	AND #BTN_START
	BEQ Branch_07_d222


JMP_07_d211:
	LDX z82
	INX
	CPX #$03
	BCC @07_d21a
	LDX #$00
@07_d21a:
	STX z82
	JSR DisablePicture
	JMP StartGame
Branch_07_d222:
	LDA z82
	ASL A
	ASL A
	TAX
	LDA i123
	BNE @07_d281 ; never branches
	LDA Ptrs_07_d302, X
	STA zPointer83
	LDA Ptrs_07_d302 + 1, X
	STA zPointer83 + 1
	LDA Ptrs_07_d302 + 2, X
	STA zPointer85
	LDA Ptrs_07_d302 + 3, X
	STA zPointer85 + 1
	LDY i124
	INC i126
	LDA i126
	INY
	CMP (zPointer83), Y
	BNE @07_d258
	LDA #$00
	STA i126
	INY
	STY i124
	INY
@07_d258:
	DEY
	LDA (zPointer83), Y
	STA iJoyPressed
	AND #BTN_START
	BNE JMP_07_d211
	LDY i125
	INC i127
	LDA i127
	INY
	CMP (zPointer85), Y
	BNE @07_d27a
	LDA #$00
	STA i127
	INY
	STY i125
	INY
@07_d27a:
	DEY
	LDA (zPointer85), Y
	STA iJoyPressed + 1
	RTS
@07_d281:
	LDA Ptrs_07_d30e, X
	STA zPointer83
	LDA Ptrs_07_d30e + 1, X
	STA zPointer83 + 1
	LDA Ptrs_07_d30e + 2, X
	STA zPointer85
	LDA Ptrs_07_d30e + 3, X
	STA zPointer85 + 1
	LDY i124
	LDA iJoyPressed
	CMP (zPointer83), Y
	BNE @07_d2aa
	INY
	LDA (zPointer83), Y
	CLC
	ADC #$01
	STA (zPointer83), Y
	BNE @07_d2b6
	DEY
@07_d2aa:
	YAD 2
	STY i124
	STA (zPointer83), Y
	LDA #$01
	INY
	STA (zPointer83), Y
@07_d2b6:
	LDY i125
	LDA iJoyPressed + 1
	CMP (zPointer85), Y
	BNE @07_d2cb
	INY
	LDA (zPointer85), Y
	CLC
	ADC #$01
	STA (zPointer85), Y
	BNE @07_d2d7
	DEY
@07_d2cb:
	YAD 2
	STY i125
	STA (zPointer85), Y
	LDA #$01
	INY
	STA (zPointer85), Y
@07_d2d7:
	RTS

UpdateJoypads:
	; strobe JOY1
	LDX #1
	STX JOY1
	LDA #0
	STA JOY1
	; repeat loop for every button
	LDY #num_inputs
@07_d2e4:
	; start with player 2
	LDX #1
@07_d2e6:
	LDA JOY1, X
	AND #3
	CMP #1
	; record the input
	ROR iJoyPressed, X
	; now do player 1
	DEX
	BPL @07_d2e6
	; next button
	DEY
	BNE @07_d2e4
	RTS

InitJoyPads: ; unreferenced
	LDA #0
	LDX #iJoyPressed - iJoyCurrent - 1
@07_d2fb:
	STA iJoyCurrent, X
	DEX
	BPL @07_d2fb
	RTS

Ptrs_07_d302:
	.dw PTD_07_d31a, PTD_07_d31a
	.dw PTD_07_d3a4, PTD_07_d3a4
	.dw PTD_07_d43c, PTD_07_d49b

MACRO ram_dual locale
	.db >locale, <locale, >locale, <locale + 1
ENDM

Ptrs_07_d30e:
	ram_dual z60
	ram_dual z62
	ram_dual z64
PTD_07_d31a:
	.db $00, $90, $20, $0e, $00, $2a, $80, $04, $00, $05, $01, $09, $00
	.db $07, $40, $06, $00, $12, $01, $08, $00, $71, $40, $07, $00, $04
	.db $01, $09, $00, $0d, $80, $07, $00, $07, $80, $05, $00, $0a, $01
	.db $08, $00, $4a, $40, $06, $00, $0d, $01, $08, $00, $08, $40, $06
	.db $00, $09, $01, $08, $00, $0d, $20, $15, $00, $2f, $80, $08, $00
	.db $49, $01, $0a, $00, $0d, $80, $04, $00, $25, $20, $07, $00, $0d
	.db $40, $07, $00, $0b, $01, $0b, $00, $04, $80, $06, $00, $08, $01
	.db $0b, $00, $07, $40, $05, $00, $0f, $01, $08, $00, $25, $20, $14
	.db $00, $b6, $80, $08, $00, $07, $01, $09, $00, $13, $20, $19, $00
	.db $18, $20, $06, $00, $0e, $40, $07, $00, $08, $01, $0a, $00, $08
	.db $20, $19, $00, $3a, $ff, $00, $ff, $00
PTD_07_d3a4:
	.db $00, $ac, $40, $07, $00, $09, $01, $09, $00, $72, $01, $09, $00
	.db $26, $40, $03, $00, $0a, $01, $0b, $00, $02, $80, $06, $00, $07
	.db $01, $0a, $81, $01, $80, $06, $00, $09, $01, $0c, $00, $0b, $40
	.db $08, $00, $40, $01, $0c, $80, $06, $00, $0a, $01, $0b, $00, $06
	.db $40, $07, $00, $08, $01, $0a, $00, $57, $40, $0a, $00, $19, $01
	.db $09, $00, $05, $80, $06, $00, $0a, $01, $0a, $00, $03, $40, $06
	.db $00, $0d, $01, $09, $00, $05, $80, $05, $00, $0b, $01, $0a, $00
	.db $2e, $01, $0a, $00, $6b, $80, $05, $00, $05, $01, $09, $00, $21
	.db $40, $07, $00, $1b, $01, $0a, $00, $08, $80, $06, $00, $08, $01
	.db $0b, $00, $18, $40, $08, $00, $0a, $40, $07, $00, $02, $01, $0b
	.db $00, $f6, $80, $04, $00, $07, $01, $07, $00, $02, $40, $07, $00
	.db $0b, $01, $09, $00, $4c, $ff, $00, $ff, $00
PTD_07_d43c:
	.db $00, $41, $80, $07, $00, $21, $01, $05, $00, $00, $00, $8d, $40
	.db $07, $00, $0c, $01, $09, $00, $06, $80, $05, $00, $0b, $01, $09
	.db $00, $05, $40, $06, $00, $08, $01, $09, $00, $07, $80, $06, $00
	.db $08, $01, $07, $00, $00, $00, $6c, $20, $15, $00, $03, $20, $0b
	.db $00, $55, $40, $06, $00, $47, $01, $0c, $00, $dc, $20, $0f, $00
	.db $30, $20, $07, $00, $4c, $80, $08, $00, $09, $01, $08, $00, $0f
	.db $20, $06, $00, $0e, $20, $0b, $00, $d8, $20, $07, $00, $15, $20
	.db $0a, $00, $a0, $ff
PTD_07_d49b:
	.db $00, $00, $00, $15, $40, $07, $00, $00, $00, $8e, $01, $09, $00
	.db $06, $80, $06, $00, $08, $80, $04, $00, $08, $01, $06, $00, $00
	.db $00, $3e, $20, $23, $00, $c7, $40, $08, $00, $09, $40, $08, $00
	.db $06, $01, $0a, $00, $01, $80, $08, $00, $04, $01, $09, $00, $49
	.db $20, $0f, $00, $30, $20, $07, $00, $ca, $40, $07, $00, $0f, $01
	.db $0a, $00, $00, $00, $47, $ff, $00, $ff, $00

Sub_07_d4e5:
	LDX $02df
	TXA
	CMP #$14
	BCC @07_d4ef
	LDX #$13
@07_d4ef:
	LDA Data_07_d52f, X
	STA $0472
	LDA $0521
	BEQ @07_d4fd
	LSR $0472
@07_d4fd:
	LDX $02e0
	LDA Data_07_d52f, X
	STA $0473
	LDA $0522
	BEQ @07_d50e
	LSR $0473
@07_d50e:
	LDA #$10
	STA $054a
	STA $054b
	RTS

Sub_07_d517:
	LDX $044f
	DEC $054a, X
	BNE @07_d52e
	LDA #$10
	STA $054a, X
	LDA $0472, X
	CMP #$02
	BEQ @07_d52e
	DEC $0472, X
@07_d52e:
	RTS

Data_07_d52f:
	.db $20, $1f, $1e, $1d, $1c, $1b, $1a, $19, $18, $17, $16, $15, $14
	.db $13, $12, $11, $10, $0f, $0e, $0d

Sub_07_d543:
	LDA #$00
	STA $02e2
	LDX $02df
	LDA Data_07_d5d3, X
	STA $02e3
	TXA
	ASL A
	TAX
	LDA Ptrs_07_d5d8, X
	STA zPointerD5
	INX
	LDA Ptrs_07_d5d8, X
	STA zPointerD5 + 1
	LDY #$00
	LDA (zPointerD5), Y
	STA $02e1
	INY
	JSR Sub_07_d56e
	JSR Sub_00_8864
	RTS

Sub_07_d56e:
	LDA (zPointerD5), Y
	STA $0474
	INY
	LDA (zPointerD5), Y
	STA $0472
	LDA $0521
	BEQ @07_d581
	LSR $0472
@07_d581:
	RTS

Sub_07_d582:
	DEC $02e1
	BNE @07_d5cd
	LDA #$cc
	CMP $02e3
	BNE @07_d5a6
	LDA #<Data_00_d83a
	STA zPointerD5
	LDA #>Data_00_d83a
	STA zPointerD5 + 1
	LDA #$c8
	STA $02e3
	LDA #$00
	STA $02e2
	JSR Sub_00_8840
	JMP @07_d5c6
@07_d5a6:
	INC $02e3
	INC $02e2
	LDA #$0a
	CMP $02e2
	BNE @07_d5bb
	LDA #$00
	STA $02e2
	JSR Sub_00_8840
@07_d5bb:
	LDA zPointerD5
	CLC
	ADC #$03
	STA zPointerD5
	BCC @07_d5c6
	INC zPointerD5 + 1
@07_d5c6:
	LDY #0
	LDA (zPointerD5), Y
	STA $02e1
@07_d5cd:
	LDY #$01
	JSR Sub_07_d56e
	RTS

Data_07_d5d3:
	.db $00, $0a, $14, $1e, $28

Ptrs_07_d5d8:
	.dw PTD_07_d5e2
	.dw PTD_07_d600
	.dw PTD_07_d61e
	.dw PTD_07_d63c
	.dw PTD_07_d65a
PTD_07_d5e2:
	.db $04, $02, $28, $04, $02, $24, $04, $02, $20, $04, $02, $1c, $04
	.db $02, $1a, $04, $02, $18, $04, $02, $16, $04, $02, $14, $04, $02
	.db $12, $04, $02, $10
PTD_07_d600:
	.db $04, $02, $1e, $04, $02, $1c, $04, $02, $1a, $04, $02, $18, $04
	.db $02, $16, $04, $02, $14, $04, $02, $12, $04, $02, $10, $07, $02
	.db $0e, $01, $03, $0c
PTD_07_d61e:
	.db $04, $02, $14, $04, $02, $13, $04, $02, $12, $04, $02, $11, $04
	.db $02, $10, $04, $02, $0f, $04, $02, $0e, $04, $02, $0d, $06, $02
	.db $0c, $02, $03, $0b
PTD_07_d63c:
	.db $04, $02, $0f, $04, $02, $0e, $04, $02, $0d, $04, $02, $0c, $04
	.db $02, $0b, $04, $02, $0a, $04, $02, $09, $04, $02, $08, $05, $02
	.db $07, $03, $03, $06
PTD_07_d65a:
	.db $04, $02, $0f, $04, $02, $0e, $04, $02, $0d, $04, $02, $0c, $04
	.db $02, $0b, $04, $02, $0a, $04, $02, $09, $04, $02, $08, $04, $02
	.db $07, $04, $03, $06, $04, $02, $0f, $04, $02, $0e, $04, $02, $0d
	.db $04, $02, $0c, $04, $02, $0b, $04, $02, $0a, $04, $02, $09, $04
	.db $02, $08, $03, $02, $07, $05, $03, $06, $04, $02, $0f, $04, $02
	.db $0e, $04, $02, $0d, $04, $02, $0c, $04, $02, $0b, $04, $02, $0a
	.db $04, $02, $09, $04, $02, $08, $02, $02, $07, $06, $03, $06, $04
	.db $02, $14, $04, $02, $0d, $04, $02, $0c, $04, $02, $0b, $04, $02
	.db $0a, $04, $02, $09, $04, $02, $08, $04, $02, $07, $01, $02, $06
	.db $07, $03, $06, $04, $02, $14, $04, $02, $0a, $04, $02, $09, $04
	.db $02, $08, $04, $02, $07, $04, $02, $06, $04, $02, $05, $04, $02
	.db $04, $04, $03, $06, $04, $03, $05, $04, $02, $14, $04, $02, $0a
	.db $04, $02, $09, $04, $02, $08, $04, $02, $07, $04, $02, $05, $04
	.db $02, $04, $03, $02, $03, $05, $03, $06, $04, $03, $05, $04, $02
	.db $14, $04, $02, $09, $04, $02, $08, $04, $02, $07, $04, $02, $06
	.db $04, $02, $05, $04, $02, $04, $02, $02, $03, $06, $03, $06, $04
	.db $03, $05, $04, $02, $14, $04, $02, $08, $04, $02, $07, $04, $02
	.db $06, $04, $02, $05, $04, $02, $04, $04, $02, $03, $01, $02, $02
	.db $07, $03, $06, $04, $03, $05, $04, $02, $14, $04, $02, $07, $04
	.db $02, $06, $04, $02, $05, $04, $02, $04, $04, $02, $03, $04, $02
	.db $02, $04, $03, $06, $04, $03, $05, $04, $03, $04, $04, $02, $14
	.db $04, $02, $06, $04, $02, $05, $04, $02, $04, $04, $02, $03, $04
	.db $02, $02, $03, $02, $02, $05, $03, $06, $04, $03, $05, $04, $03
	.db $04, $04, $02, $14, $04, $02, $05, $04, $02, $04, $04, $02, $03
	.db $04, $02, $02, $04, $02, $02, $02, $02, $02, $06, $03, $06, $04
	.db $03, $05, $04, $03, $04, $04, $02, $0f, $04, $02, $04, $04, $02
	.db $03, $04, $02, $02, $04, $02, $02, $04, $02, $02, $01, $02, $02
	.db $07, $03, $06, $04, $03, $05, $04, $03, $04, $04, $02, $0f, $04
	.db $02, $03, $04, $02, $02, $04, $02, $02, $04, $02, $02, $04, $02
	.db $02, $04, $03, $06, $04, $03, $05, $04, $03, $04, $04, $03, $03
	.db $04, $02, $0f, $04, $02, $02, $04, $02, $02, $04, $02, $02, $04
	.db $02, $02, $03, $02, $02, $05, $03, $06, $04, $03, $05, $04, $03
	.db $04, $04, $03, $03, $04, $02, $0f, $04, $02, $02, $04, $02, $02
	.db $04, $02, $02, $04, $02, $02, $02, $02, $02, $06, $03, $06, $04
	.db $03, $05, $04, $03, $04, $04, $03, $03, $04, $02, $0f, $04, $02
	.db $02, $04, $02, $02, $04, $02, $02, $04, $02, $02, $01, $02, $02
	.db $07, $03, $06, $04, $03, $05, $04, $03, $04, $04, $03, $03
Data_00_d83a:
	.db $08, $02, $06, $08, $02, $05, $08, $03, $04, $08, $03, $03, $08
	.db $03, $02

SetStartingGarbage:
	LDX $02df
	INX
	TXA
	CMP #$07
	BCC @07_d854
	LDX #$06
@07_d854:
	STX za3
	LDY #$00
	JSR Sub_07_d916
	LDA #$08
	STA za4
	JSR Sub_07_d8de
	LDX $02e0
	INX
	TXA
	CMP #$07
	BCC @07_d86d
	LDX #$06
@07_d86d:
	STX za3
	LDY #$04
	JSR Sub_07_d916
	LDA #$2c
	STA za4
	JSR Sub_07_d8de
	LDA #$12
	STA za5
@07_d87f:
	LDA #$14
	STA zb1
	JSR Sub_00_806a
	LDA za5
	LSR A
	SEC
	SBC #$09
	EOR #$ff
	SEC
	ADC #SFX_ROW_1
	JSR StoreMusicID
	LDA #$00
	STA za4
	LDA zPlayerMode
	ASL A
	ASL A
	CLC
	ADC #$04
	STA za6
	LDA za5
	STA $0445
	STA $04ea
@07_d8a9:
	LDA za4
	STA $0444
	STA $04e9
	JSR Sub_00_a8ad
	LDY #$00
	LDA (zPointerC7), Y
	STA $0446
	JSR Sub_00_a8d8
	INC za4
	DEC za6
	BNE @07_d8a9
	JSR Sub_07_e449
	JSR Sub_00_b601
	JSR Sub_07_efd1
	DEC za5
	DEC za5
	LDA za5
	CMP $0487
	BCS @07_d87f
	CMP $048b
	BCS @07_d87f
	RTS

Sub_07_d8de:
	LDA #$04
	STA za7
@07_d8e2:
	LDA #$00
	STA za8
	LDA za3
	STA za5
	LDA za4
	STA za6
@07_d8ee:
	JSR Sub_00_80cb
	LDA $0255
	AND #$03
	CLC
	ADC #$01
	CMP za8
	BEQ @07_d8ee
	STA za8
	LDX za6
	STA $048f, X
	DEC za6
	DEC za5
	BNE @07_d8ee
	LDA za4
	CLC
	ADC #$09
	STA za4
	DEC za7
	BNE @07_d8e2
	RTS

Sub_07_d916:
	LDA #$04
	STA za4
	LDA #$0a
	SEC
	SBC za3
	ASL A
@07_d920:
	STA $0487, Y
	INY
	DEC za4
	BNE @07_d920
	RTS

Sub_07_d929:
	STA za3
	STA za4
@07_d92d:
	LDA (zPointer83), Y
	CLC
	ADC #$01
	STA (zPointer83), Y
	CMP #$0a
	BNE @07_d94b
	LDA #$00
	STA (zPointer83), Y
	INY
	DEC za3
	BNE @07_d92d
	DEY
	LDA #$09
@07_d944:
	STA (zPointer83), Y
	DEY
	DEC za4
	BNE @07_d944
@07_d94b:
	RTS

Sub_07_d94c:
	LDX $044f
	LDA #$00
	STA $053a, X
	LDA $0451
	STA $04e9
	LDA #$04
	STA $04ea
	STA za4
	JSR Sub_00_a8ad
	LDA #$08
	STA za3
	LDY #$00
@07_d96a:
	LDA #$06
	CMP (zPointerC7), Y
	BNE @07_d9bd
	LDA za4
	STA $0529, X
	LDA $0451
	STA $0525, X
	LDY $0451
	LDA $0452, Y
	STA $0527, X
	STA $060a, X
	LDA #$01
	STA $0523, X
	STA $052b, X
	LDA #$00
	STA iCrunchCounter, X
	INC $0532, X
	TXA
	CLC
	ADC $044f
	ADC $044f
	TAY
	LDA #$34
	STA zPointer83
	LDA #$05
	STA zPointer83 + 1
	LDA #$03
	JSR Sub_07_d929
	LDY #$00
@07_d9af:
	LDA (zPointerC7), Y
	PHA
	LDA #$00
	STA (zPointerC7), Y
	INY
	PLA
	CMP #$06
	BNE @07_d9af
	RTS
@07_d9bd:
	LDA (zPointerC7), Y
	BEQ @07_d9c4
	INC $053a, X
@07_d9c4:
	INC za4
	INC za4
	INY
	DEC za3
	BNE @07_d96a
	LDA #$00
	STA $053a, X
Branch_07_d9d2:
	RTS

Sub_07_d9d3:
	LDA i248
	CMP #$05
	BNE Branch_07_d9d2
	LDA zPlayerMode
	BNE @07_d9f5
	LDA #$22
	STA $02e4
	LDA $0535
	CLC
	ADC #$1b
	STA $02e5
	LDA $0534
	CLC
	ADC #$1b
	STA $02e6
@07_d9f5:
	RTS

Sub_07_d9f6:
	LDX $044f
	LDA $0512, X
	BNE Branch_07_d9d2
	LDA $0523, X
	BEQ Branch_07_d9d2
	CMP #$01
	BEQ @07_da43
	JSR Sub_00_920f
	JSR Sub_00_9118
	LDX $044f
	LDA $0530, X
	CMP #$0f
	BNE Branch_07_d9d2
	LDA #$00
	STA $0523, X
	LDA $053c, X
	CLC
	ADC $053a, X
	STA $053c, X
	LDA $0525, X
	TAX
	JSR Sub_00_ba9b
	JSR Sub_07_d9d3
	LDA $0534
	BNE @07_da38
	JSR Sub_00_bc9c
@07_da38:
	LDA $0536
	BEQ @07_da42
	LDA #$01
	STA $0612
@07_da42:
	RTS
@07_da43:
	DEC $052b, X
	BNE Branch_07_d9d2
	LDA #$07
	STA $052b, X
	LDA $0527, X
	CLC
	ADC #$01
	CMP $0529, X
	BEQ @07_dabc
	LDX $044f
	LDA iCrunchCounter, X
	CMP #$07
	BEQ @07_da71
	LDA #SFX_CRUNCH_7
	SEC
	SBC iCrunchCounter, X
	INC iCrunchCounter, X
	JSR StoreMusicID
	JMP @07_da76
@07_da71:
	LDA #SFX_CRUNCH_BIG
	JSR StoreMusicID
@07_da76:
	LDX $044f
	LDA $0525, X
	STA $0444
	LDA $0527, X
	STA $0445
	LDA #$15
	STA $0446
	LDA $060a, X
	CMP #$02
	BEQ @07_da9d
	LDA $0445
	CMP #$04
	BNE @07_da9d
	LDA #$01
	STA $052d
@07_da9d:
	JSR Sub_00_a77d
	LDX $044f
	LDA $0527, X
	AND #$01
	BEQ @07_dab5
	LDA #$00
	STA $0446
	INC $0445
	JSR Sub_00_a8d8
@07_dab5:
	LDX $044f
	INC $0527, X
	RTS
@07_dabc:
	LDX $044f
	INC $0523, X
	LDA #$00
	LDA $0525, X
	TAY
	LDA $0529, X
	CLC
	ADC #$02
	STA $0487, Y
	LDA $0529, X
	STA $0445
	LDA $0525, X
	STA $0444
	LDA #$00
	STA $0446
	JSR Sub_00_a8d8
	DEC $0445
	DEC $0445
	JSR Sub_00_a8d8
	JSR Sub_00_90ce
	RTS

Sub_07_daf2:
	LDA $02d4
	STA $0444
	LDA $02d5
	STA $0445
	JSR Sub_00_ac39
	LDX $02d4
	LDA #$01
	STA $0268, X
	LDA $02d6
	STA $0280, X
	LDA $051a
	STA $0298, X
	LDA $051b
	STA $02b0, X
	LDA #$0a
	STA $02d7, X
	RTS

Sub_07_db21:
	LDY #$08
	LDX #$00
@07_da25:
	LDA $02d7, X
	BEQ @07_db34
	DEC $02d7, X
	BNE @07_db34
	LDA #$ff
	STA $0268, X
@07_db34:
	INX
	DEY
	BNE @07_da25
	RTS

Sub_07_db39:
	LDA $02f6
	CMP #$03
	BNE @07_db55
	LDA zBGMCursor
	CMP #$03
	BEQ @07_db55
	CLC
	ADC #$04
	TAX
	LDA $027c, X
	CLC
	ADC #$10
	AND #$1f
	STA $027c, X
@07_db55:
	RTS

Sub_07_db56:
	JSR Sub_07_cdf0
	LDA #$05
	STA $0264
	STA $0265
	STA $0266
	STA $0267
	LDA #$01
	STA $027c
	STA $027e
	LDA #$02
	STA $027d
	STA $027f
	LDA #$50
	STA $02ac
	LDA #$a0
	STA $02ae
	LDA #$68
	STA $02ad
	LDA #$b8
	STA $02af
	LDA #$14
	STA $0547
	LDA #$00
	STA $0545
	STA $0546
	JSR Sub_07_dcc1
	JSR Sub_07_dd26
	JSR Sub_07_dd92
	JSR Sub_07_ddf9
	RTS

Sub_07_dba5:
	JSR Sub_07_cdf0
	LDA #$05
	STA $0264
	STA $0265
	STA $0266
	STA $0267
	STA $0268
	STA $0269
	STA $026a
	LDX #$00
	STX za3
	LDY #$07
@07_dbc5:
	LDA za3
	STA $027c, X
	INX
	INC za3
	DEY
	BNE @07_dbc5
	LDA #$48
	STA $02ac
	LDA #$70
	STA $02ad
	LDA #$98
	STA $02ae
	LDA #$c0
	STA $02af
	LDA #$bc
	STA $02b0
	STA $02b1
	STA $02b2
	LDA #$60
	STA $0298
	LDA #$80
	STA $0299
	LDA #$a0
	STA $029a
	LDA #$14
	STA $0547
	JSR Sub_07_decc
	JSR Sub_07_df5d
	JSR Sub_07_dff0
	JSR Sub_07_e063
	RTS

JPT_07_dc10:
	JSR Sub_00_80cb
	LDA zPlayerMode
	BNE @07_dc1d
	JSR Sub_07_de2c
	JMP @07_dc20
@07_dc1d:
	JSR Sub_07_dc21
@07_dc20:
	RTS

Sub_07_dc21:
	DEC $0547
	BNE @07_dc4e
	LDA #$14
	STA $0547
	LDX $0545
	LDA $0264, X
	CMP #$ff
	BNE @07_dc43
	LDA #$05
	STA $0264, X
	LDX $0546
	STA $0266, X
	JMP @07_dc4e
@07_dc43:
	LDA #$ff
	STA $0264, X
	LDX $0546
	STA $0266, X
@07_dc4e:
	LDX $0545
	BNE @07_dc59
	JSR @07_dc67
	JMP @07_dc5c
@07_dc59:
	JSR Sub_07_dd36
@07_dc5c:
	LDX $0546
	BNE @07_dc64
	JMP JMP_07_dcd1
@07_dc64:
	JMP Sub_07_dda2
@07_dc67:
	LDA #$09
	STA $027c
	JSR Sub_07_de09
	BEQ Sub_07_dcc1
	LDA #$40
	AND iJoyHeld
	BEQ @07_dc86
	LDA z7d
	BEQ Sub_07_dcc1
	DEC z7d
	LDX #$00
	JSR Sub_07_e0ee
	JMP Sub_07_dcc1
@07_dc86:
	LDA #$80
	AND iJoyHeld
	BEQ @07_dc9d
	LDA z7d
	CMP #$04
	BEQ Sub_07_dcc1
	INC z7d
	LDX #$00
	JSR Sub_07_e0ee
	JMP Sub_07_dcc1
@07_dc9d:
	LDA #$20
	AND iJoyHeld
	BEQ Sub_07_dcc1
	LDA #$01
	STA $0545
	LDX #$00
	JSR Sub_07_e0ee
	LDY #$05
	LDX #$01
	JSR Sub_07_e0d5
	LDY #$07
	LDX #$00
	JSR Sub_07_e0d5
	LDA #$01
	STA $027c

Sub_07_dcc1:
	LDA #$60
	LDX z7d
	BEQ @07_dccd
@07_dcc7:
	CLC
	ADC #$18
	DEX
	BNE @07_dcc7
@07_dccd:
	STA $0294
	RTS


JMP_07_dcd1:
	LDA #$09
	STA $027e
	LDA #$40
	AND iJoyHeld + 1
	BEQ @07_dceb
	LDA z7f
	BEQ Sub_07_dd26
	DEC z7f
	LDX #$02
	JSR Sub_07_e0ee
	JMP Sub_07_dd26
@07_dceb:
	LDA #$80
	AND iJoyHeld + 1
	BEQ @07_dd02
	LDA z7f
	CMP #$04
	BEQ Sub_07_dd26
	INC z7f
	LDX #$02
	JSR Sub_07_e0ee
	JMP Sub_07_dd26
@07_dd02:
	LDA #$20
	AND iJoyHeld + 1
	BEQ Sub_07_dd26
	LDA #$01
	STA $0546
	LDX #$02
	JSR Sub_07_e0ee
	LDY #$0a
	LDX #$01
	JSR Sub_07_e0d5
	LDY #$0c
	LDX #$00
	JSR Sub_07_e0d5
	LDA #$01
	STA $027e

Sub_07_dd26:
	LDA #$60
	LDX z7f
	BEQ @07_dd32
@07_dd2c:
	CLC
	ADC #$18
	DEX
	BNE @07_dd2c
@07_dd32:
	STA $0296
	RTS

Sub_07_dd36:
	LDA #$0a
	STA $027d
	JSR Sub_07_de09
	BEQ Sub_07_dd92
	LDA #$40
	AND iJoyHeld
	BEQ @07_dd57
	LDA z7e
	BEQ @07_dd57
	LDA #$00
	STA z7e
	LDX #$01
	JSR Sub_07_e0ee
	JMP Sub_07_dd92
@07_dd57:
	LDA #$80
	AND iJoyHeld
	BEQ @07_dd6e
	LDA z7e
	BNE @07_dd6e
	LDA #$01
	STA z7e
	LDX #$01
	JSR Sub_07_e0ee
	JMP Sub_07_dd92
@07_dd6e:
	LDA #$10
	AND iJoyHeld
	BEQ Sub_07_dd92
	LDA #$00
	STA $0545
	LDX #$01
	JSR Sub_07_e0ee
	LDY #$07
	LDX #$01
	JSR Sub_07_e0d5
	LDY #$05
	LDX #$00
	JSR Sub_07_e0d5
	LDA #$02
	STA $027d

Sub_07_dd92:
	LDA z7e
	BNE @07_dd9c
	LDA #$64
	STA $0295
	RTS
@07_dd9c:
	LDA #$a0
	STA $0295
	RTS

Sub_07_dda2:
	LDA #$0a
	STA $027f
	LDA #$40
	AND iJoyHeld + 1
	BEQ @07_ddbe
	LDA z80
	BEQ @07_ddbe
	LDA #$00
	STA z80
	LDX #$03
	JSR Sub_07_e0ee
	JMP Sub_07_ddf9
@07_ddbe:
	LDA #$80
	AND iJoyHeld + 1
	BEQ @07_ddd5
	LDA z80
	BNE @07_ddd5
	LDA #$01
	STA z80
	LDX #$03
	JSR Sub_07_e0ee
	JMP Sub_07_ddf9
@07_ddd5:
	LDA #$10
	AND iJoyHeld + 1
	BEQ Sub_07_ddf9
	LDA #$00
	STA $0546
	LDX #$03
	JSR Sub_07_e0ee
	LDY #$0c
	LDX #$01
	JSR Sub_07_e0d5
	LDY #$0a
	LDX #$00
	JSR Sub_07_e0d5
	LDA #$02
	STA $027f

Sub_07_ddf9:
	LDA z80
	BNE @07_de03
	LDA #$64
	STA i297
	RTS
@07_de03:
	LDA #$a0
	STA i297
	RTS

Sub_07_de09:
	LDA iJoyHeld
	AND #$08
	BNE @07_de14
	LDA iJoyHeld
	RTS
@07_de14:
	LDA z7d
	STA $02df
	LDA z7e
	STA $0521
	LDA z7f
	STA $02e0
	LDA z80
	STA $0522
	INC i248
	RTS

Sub_07_de2c:
	LDA $02f6
	CMP #$03
	BNE @07_de39
	LDA zBGMCursor
	CMP #$03
	BNE @07_de59
@07_de39:
	DEC $0547
	BNE @07_de59
	LDA #$14
	STA $0547
	LDX $02f6
	LDA $0264, X
	CMP #$ff
	BNE @07_de59
	LDA #$05
	STA $0264, X
	BNE @07_de59
@07_de54:
	LDA #$ff
	STA $0264, X
@07_de59:
	LDX $02f6
	BNE @07_de61
	JMP JMP_07_de70
@07_de61:
	DEX
	BNE @07_de67
	JMP JMP_07_dedc
@07_de67:
	DEX
	BNE @07_de6d
	JMP JMP_07_df6d
@07_de6d:
	JMP JMP_07_e000


JMP_07_de70:
	LDA #$08
	STA $027c
	JSR Sub_07_e0ae
	BEQ Sub_07_decc
	LDA #$40
	AND iJoyHeld
	BEQ @07_de91
	LDA z79
	BEQ @07_de91
	LDA #$00
	STA z79
	LDX #$00
	JSR Sub_07_e112
	JMP Sub_07_decc
@07_de91:
	LDA #$80
	AND iJoyHeld
	BEQ @07_dea8
	LDA z79
	BNE @07_dea8
	LDA #$01
	STA z79
	LDX #$00
	JSR Sub_07_e112
	JMP Sub_07_decc
@07_dea8:
	LDA #$20
	AND iJoyHeld
	BEQ Sub_07_decc
	LDA #$01
	STA $02f6
	LDX #$00
	JSR Sub_07_e112
	LDY #$05
	LDX #$03
	JSR Sub_07_e0d5
	LDY #$07
	LDX #$00
	JSR Sub_07_e0d5
	LDA #$00
	STA $027c

Sub_07_decc:
	LDA z79
	BNE @07_ded6
	LDA #$68
	STA $0294
	RTS
@07_ded6:
	LDA #$a0
	STA $0294
	RTS


JMP_07_dedc:
	LDA #$09
	STA $027d
	JSR Sub_07_e0ae
	BEQ Sub_07_df5d
	LDA #$40
	AND iJoyHeld
	BEQ @07_defb
	LDA z7a
	BEQ Sub_07_df5d
	DEC z7a
	LDX #$01
	JSR Sub_07_e112
	JMP Sub_07_df5d
@07_defb:
	LDA #$80
	AND iJoyHeld
	BEQ @07_df12
	LDA z7a
	CMP #$04
	BEQ Sub_07_df5d
	INC z7a
	LDX #$01
	JSR Sub_07_e112
	JMP Sub_07_df5d
@07_df12:
	LDA #$20
	AND iJoyHeld
	BEQ @07_df39
	LDA #$02
	STA $02f6
	LDX #$01
	JSR Sub_07_e112
	LDY #$07
	LDX #$03
	JSR Sub_07_e0d5
	LDY #$0a
	LDX #$00
	JSR Sub_07_e0d5
	LDA #$01
	STA $027d
	JMP Sub_07_df5d
@07_df39:
	LDA #$10
	AND iJoyHeld
	BEQ Sub_07_df5d
	LDA #$00
	STA $02f6
	LDX #$01
	JSR Sub_07_e112
	LDY #$07
	LDX #$03
	JSR Sub_07_e0d5
	LDY #$05
	LDX #$00
	JSR Sub_07_e0d5
	LDA #$01
	STA $027d

Sub_07_df5d:
	LDA #$60
	LDX z7a
	BEQ @07_df69
@07_df63:
	CLC
	ADC #$18
	DEX
	BNE @07_df63
@07_df69:
	STA $0295
	RTS


JMP_07_df6d:
	LDA #$0a
	STA $027e
	JSR Sub_07_e0ae
	BEQ Sub_07_dff0
	LDA #$40
	AND iJoyHeld
	BEQ @07_df8e
	LDA z7b
	BEQ @07_df8e
	LDA #$00
	STA z7b
	LDX #$02
	JSR Sub_07_e112
	JMP Sub_07_dff0
@07_df8e:
	LDA #$80
	AND iJoyHeld
	BEQ @07_dfa5
	LDA z7b
	BNE @07_dfa5
	LDA #$01
	STA z7b
	LDX #$02
	JSR Sub_07_e112
	JMP Sub_07_dff0
@07_dfa5:
	LDA #$20
	AND iJoyHeld
	BEQ @07_dfcc
	LDA #$03
	STA $02f6
	LDX #$02
	JSR Sub_07_e112
	LDY #$0a
	LDX #$03
	JSR Sub_07_e0d5
	LDY #$0c
	LDX #$00
	JSR Sub_07_e0d5
	LDA #$02
	STA $027e
	JMP Sub_07_dff0
@07_dfcc:
	LDA #$10
	AND iJoyHeld
	BEQ Sub_07_dff0
	LDA #$01
	STA $02f6
	LDX #$02
	JSR Sub_07_e112
	LDY #$0a
	LDX #$03
	JSR Sub_07_e0d5
	LDY #$07
	LDX #$00
	JSR Sub_07_e0d5
	LDA #$02
	STA $027e

Sub_07_dff0:
	LDA z7b
	BNE @07_dffa
	LDA #$64
	STA $0296
	RTS
@07_dffa:
	LDA #$a0
	STA $0296
	RTS


JMP_07_e000:
	LDA #$0b
	STA $027f
	JSR Sub_07_e0ae
	BEQ Sub_07_e063
	LDA #$40
	AND iJoyHeld
	BEQ @07_e022
	LDA zBGMCursor
	BEQ Sub_07_e063
	DEC zBGMCursor
	JSR Sub_07_e099
	LDA #$05
	STA $0267
	JMP Sub_07_e063
@07_e022:
	LDA #$80
	AND iJoyHeld
	BEQ @07_e03c
	LDA zBGMCursor
	CMP #$03
	BEQ Sub_07_e063
	INC zBGMCursor
	JSR Sub_07_e099
	LDA #$05
	STA $0267
	JMP Sub_07_e063
@07_e03c:
	LDA #$10
	AND iJoyHeld
	BEQ Sub_07_e063
	LDA #$02
	STA $02f6
	LDA #$05
	STA $0267
	JSR Sub_07_e099
	LDY #$0c
	LDX #$03
	JSR Sub_07_e0d5
	LDY #$0a
	LDX #$00
	JSR Sub_07_e0d5
	LDA #$03
	STA $027f

Sub_07_e063:
	JSR GetMenuBGM
	LDA #$48
	LDX zBGMCursor
	BEQ @07_e072
@07_e06c:
	CLC
	ADC #$20
	DEX
	BNE @07_e06c
@07_e072:
	STA i297
	RTS

GetMainBGM:
	LDA iDisableMusic
	BNE BGM_Quit
	LDX $0522
	LDA Main_BGM, X
	BNE GetBGM

GetMenuBGM:
	LDX zBGMCursor
	LDA Menu_BGM, X
GetBGM:
	CMP iChannelID
	BEQ BGM_Quit
	JSR StoreMusicID
BGM_Quit:
	RTS

Menu_BGM:
	.db MUSIC_MUSHROOM_MENU
	.db MUSIC_FLOWER_MENU
	.db MUSIC_STAR_MENU
	.db NO_MUSIC

Main_BGM:
	.db MUSIC_MUSHROOM
	.db MUSIC_FLOWER
	.db MUSIC_STAR
	.db NO_MUSIC

Sub_07_e099:
	LDA #$14
	STA $0547
	LDA #$04
	STA $0280
	LDA #$05
	STA $0281
	LDA #$06
	STA $0282
	RTS

Sub_07_e0ae:
	LDA iJoyHeld
	AND #$08
	BNE @07_e0b9
	LDA iJoyHeld
	RTS
@07_e0b9:
	LDA z79
	STA $0520
	LDX z7a
	STX $02df
	INX
	STX $02c4
	LDA z7b
	STA $0521
	LDA zBGMCursor
	STA $0522
	INC i248
	RTS

Sub_07_e0d5:
	STY $05b1
	STX $05b4
	LDA #$03
	STA $05b0
	LDA #$03
	STA $05b2
	LDA #$01
	STA $05b3
	JSR Sub_00_bbcb
	RTS

Sub_07_e0ee:
	LDA $0545
	BNE @07_e0fb
	LDA #$05
	STA $0264
	JMP @07_e100
@07_e0fb:
	LDA #$05
	STA $0265
@07_e100:
	LDA $0546
	BNE @07_e10d
	LDA #$05
	STA $0266
	JMP Sub_07_e112
@07_e10d:
	LDA #$05
	STA $0267

Sub_07_e112:
	LDA #$14
	STA $0547
	LDA #$05
	STA $0264, X
	LDA #SFX_SWITCH_COLUMN
	JSR StoreMusicID
	RTS
PRG_NMI:
	PHA
	LDA zNMIActivity
	BEQ @07_e129
	PLA
	RTI
@07_e129:
	LDA i222
	BEQ @07_e131
	JMP @07_e185
@07_e131:
	LDA #$ff
	STA i222
	PHX
	PHY
	JSR WriteChr2
	JSR WriteChr1
	LDA zb1
	AND #$7f
	BEQ @07_e152
	JSR Sub_07_e1ee
	INC zb2
	BNE @07_e157
	INC zb3
	JMP @07_e157
@07_e152:
	STA zb1
	JSR Sub_07_e18c
@07_e157:
	JSR SwitchToAudio
	LDA iMusicID1
	BEQ @07_e167
	JSR PlayAudio
	LDA #0
	STA iMusicID1
@07_e167:
	LDA iMusicID2
	BEQ @07_e174
	JSR PlayAudio
	LDA #0
	STA iMusicID2
@07_e174:
	JSR UpdateSound
	LDA zMMC1Prg
	JSR SwitchToMain
	PLY
	PLX
	LDA #$00
	STA i222
@07_e185:
	LDA PPUSTATUS
	BMI @07_e185
	PLA
	RTI

Sub_07_e18c:
	LDA zPPUControl
	AND #OBJ_RES | BG_TABLE | OBJ_TABLE | VRAM_INC | NT_BASE_MASK
	STA PPUCTRL
	LDA #0 ; hide everything, no color skews
	STA PPUMASK
	LDA PPUSTATUS
	LDA #$3f
	STA PPUADDR
	LDA #$00
	STA PPUADDR
	STA PPUADDR
	STA PPUADDR
	LDA $0260
	AND #$40
	BEQ @07_e1b2
@07_e1b2:
	LDA PPUSTATUS
	LDA #$00
	STA OAMADDR
	LDA #>iVirtualOAM
	STA OAM_DMA
	JSR Sub_07_d0bf
	LDA PPUSTATUS
	LDA #$3f
	STA PPUADDR
	LDA #$00
	STA PPUADDR
	STA PPUADDR
	STA PPUADDR
	LDA PPUSTATUS
	LDA zPPUScrollX
	STA PPUSCROLL
	LDA zPPUScrollY
	STA PPUSCROLL
	LDA zPPUControl
	STA PPUCTRL
	LDA zPPUMask
	STA PPUMASK
	RTS

DUMMY_IRQ:
	RTI

Sub_07_e1ee:
	DEC zb1
	LDA zPPUControl
	AND #$ff ^ (NMI | MS_SELECT)
	STA PPUCTRL
	LDA #0 ; hide everything, no color skews
	STA PPUMASK
	LDA PPUSTATUS
	LDA #$3f
	STA PPUADDR
	LDA #$00
	STA PPUADDR
	STA PPUADDR
	STA PPUADDR
	LDA $0260
	AND #$40
	BEQ @07_e216
@07_e216:
	LDA PPUSTATUS
	LDA #$00
	STA OAMADDR
	LDA #>iVirtualOAM
	STA OAM_DMA
	JSR Sub_07_ee2c
	JSR Sub_07_d0bf
	JSR Sub_07_cf7f
	LDA PPUSTATUS
	LDA #$3f
	STA PPUADDR
	LDA #$00
	STA PPUADDR
	STA PPUADDR
	STA PPUADDR
	LDA PPUSTATUS
	LDA zPPUScrollX
	STA PPUSCROLL
	LDA zPPUScrollY
	STA PPUSCROLL
	LDA zPPUControl
	STA PPUCTRL
	LDA zPPUMask
	STA PPUMASK
	JSR Sub_07_cca8
	JSR Sub_07_d0f2
	RTS

EndTheGame:
	LDY $044f
	LDA #$01
	STA $0512, Y
	JSR Sub_07_e42f
	LDA zPlayerMode
	BNE @07_e2ad
	LDA #MUSIC_GAME_OVER
	JSR StoreMusicID
	JSR Sub_00_853e
	LDA #$02
	STA $0450
	JSR Sub_07_e41c
@07_e27c:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	LDA iChannelID
	CMP #$54
	BEQ @07_e27c
	LDA $0520
	BNE @07_e295
	JSR Sub_00_89b4
	JMP @07_e29c
@07_e295:
	LDA #$78
	STA zb1
	JSR Sub_00_806a
@07_e29c:
	LDA iDisableMusic
	BNE @07_e2aa
	JSR Sub_00_9358
	JSR DisablePicture
	JMP StartGame
@07_e2aa:
	JMP JMP_07_d211
@07_e2ad:
	LDA #$00
	STA $0505
	STA $0506
	STA $050e
	STA $050f
	JSR Sub_07_e449
	JSR Sub_07_efd1
	LDA $044f
	STA zac
	EOR #$01
	TAX
	INC $0548, X
	LDA $0548, X
	CMP #$03
	BEQ @07_e31a
	LDA #NO_MUSIC
	JSR StoreMusicID
	LDA #MUSIC_ROUND_END
	JSR StoreMusicID
@07_e2dd:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	LDA iChannelID
	CMP #$6c
	BEQ @07_e2dd
	JSR Sub_00_acd9
	LDA zac
	STA $044f
	JSR Sub_00_86f3
	LDA $044f
	EOR #$01
	STA $044f
	JSR Sub_00_859e
	LDA #$01
	STA $0512
	STA $0513
	RTS
@07_e31a:
	LDA #MUSIC_GAME_POINT
	JSR StoreMusicID
@07_e31f:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	LDA iChannelID
	CMP #$62
	BEQ @07_e31f
	LDA #MUSIC_VS_RESULTS
	JSR StoreMusicID
	JSR Sub_00_acd9
	JSR Sub_00_8148
	JSR DisablePicture
	JMP StartGame
Branch_07_e32e:
	RTS

StageIsClear:
	JSR Sub_07_e42f
	LDA zPlayerMode
	BNE @07_e381
	JSR Sub_07_e449
	JSR Sub_07_efd1
	LDX $044f
	LDA #$01
	STA $0512, X
	LDA zPlayerMode
	BNE Branch_07_e32e
	JSR Sub_00_854c
	LDA #MUSIC_STAGE_CLEAR
	JSR StoreMusicID
	LDA #$0a
	STA zb1
	JSR Sub_00_806a
	JSR Sub_00_89a5
@07_e35a:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	LDA iChannelID
	CMP #MUSIC_STAGE_CLEAR
	BEQ @07_e35a
	LDA #$02
	STA $0450
	JSR Sub_07_e41c
	LDA #$78
	STA zb1
	JSR Sub_00_806a
	JSR FieldScene
	JSR Sub_00_add3
	JSR Sub_00_8840
	RTS
@07_e381:
	LDA #$00
	STA $0505
	STA $0506
	STA $050e
	STA $050f
	JSR Sub_07_e449
	JSR Sub_07_efd1
	LDX $044f
	INC $0548, X
	LDX $044f
	LDA $0548, X
	CMP #$03
	BNE @07_e3d8
	LDA #MUSIC_GAME_POINT
	JSR StoreMusicID
	LDA #$0a
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_cdf0
	LDA #$03
	STA $027a
@07_e3b9:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	LDA iChannelID
	CMP #$62
	BEQ @07_e3b9
	JSR Sub_00_acd9
	LDA #MUSIC_VS_RESULTS
	JSR StoreMusicID
	JSR Sub_00_8148
	JSR DisablePicture
	JMP StartGame
@07_e3d8:
	LDA #MUSIC_ROUND_END
	JSR StoreMusicID
	JSR Sub_07_e449
	LDA #$0a
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_cdf0
	LDA #$03
	STA $027a
@07_e3ef:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	LDA iChannelID
	CMP #$6c
	BEQ @07_e3ef
	JSR Sub_00_acd9
	LDA #$01
	STA $0512
	STA $0513
	JSR Sub_00_859e
	LDA $044f
	PHA
	EOR #$01
	STA $044f
	JSR Sub_00_86f3
	PLA
	STA $044f
	RTS

Sub_07_e41c:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_e449
	JSR Sub_07_efd1
	DEC $0450
	BNE Sub_07_e41c
	RTS

Sub_07_e42f:
	LDA #$00
	LDX #$08
@07_e433:
	STA $0459, X
	STA $0469, X
	STA $0461, X
	STA $0451, X
	DEX
	BNE @07_e433
	STA $0523
	STA $0524
	RTS

Sub_07_e449:
	BIT PPUSTATUS
	BVC @07_e457
@07_e44e:
	LDA zb1
	BNE @07_e44e
@07_e452:
	BIT PPUSTATUS
	BVS @07_e452
@07_e457:
	BIT PPUSTATUS
	BVC @07_e457
	LDA #$01
	STA zNMIActivity
	NOP
	NOP
	NOP
	NOP
	LDA #0 ; hide everything, no color skews
	STA PPUMASK
	LDA $0300
	BNE @07_e471
	JMP @07_e51f
@07_e471:
	STA PPUADDR
	LDA #$02
	STA PPUADDR
	LDA $0301
	STA PPUDATA
	LDA $0302
	STA PPUDATA
	LDA $0303
	STA PPUDATA
	LDA $0304
	STA PPUDATA
	LDA $0305
	STA PPUDATA
	LDA $0306
	STA PPUDATA
	LDA $0307
	STA PPUDATA
	LDA $0308
	STA PPUDATA
	LDA $0309
	STA PPUDATA
	LDA $030a
	STA PPUDATA
	LDA $030b
	STA PPUDATA
	LDA $030c
	STA PPUDATA
	LDA $030d
	STA PPUDATA
	LDA #$23
	STA PPUADDR
	LDA #$22
	STA PPUADDR
	LDA $030e
	STA PPUDATA
	LDA $030f
	STA PPUDATA
	LDA $0310
	STA PPUDATA
	LDA $0311
	STA PPUDATA
	LDA $0312
	STA PPUDATA
	LDA $0313
	STA PPUDATA
	LDA $0314
	STA PPUDATA
	LDA $0315
	STA PPUDATA
	LDA $0316
	STA PPUDATA
	LDA $0317
	STA PPUDATA
	LDA $0318
	STA PPUDATA
	LDA $0319
	STA PPUDATA
	LDA $031a
	STA PPUDATA
@07_e51f:
	LDA $031b
	BNE @07_e527
	JMP @07_e5d5
@07_e527:
	STA PPUADDR
	LDA #$11
	STA PPUADDR
	LDA $031c
	STA PPUDATA
	LDA $031d
	STA PPUDATA
	LDA $031e
	STA PPUDATA
	LDA $031f
	STA PPUDATA
	LDA $0320
	STA PPUDATA
	LDA $0321
	STA PPUDATA
	LDA $0322
	STA PPUDATA
	LDA $0323
	STA PPUDATA
	LDA $0324
	STA PPUDATA
	LDA $0325
	STA PPUDATA
	LDA $0326
	STA PPUDATA
	LDA $0327
	STA PPUDATA
	LDA $0328
	STA PPUDATA
	LDA #$23
	STA PPUADDR
	LDA #$31
	STA PPUADDR
	LDA $0329
	STA PPUDATA
	LDA $032a
	STA PPUDATA
	LDA $032b
	STA PPUDATA
	LDA $032c
	STA PPUDATA
	LDA $032d
	STA PPUDATA
	LDA $032e
	STA PPUDATA
	LDA $032f
	STA PPUDATA
	LDA $0330
	STA PPUDATA
	LDA $0331
	STA PPUDATA
	LDA $0332
	STA PPUDATA
	LDA $0333
	STA PPUDATA
	LDA $0334
	STA PPUDATA
	LDA $0335
	STA PPUDATA
@07_e5d5:
	LDA $0447
	BEQ @07_e60e
	STA PPUADDR
	LDA $0448
	STA PPUADDR
	LDA $0449
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
@07_e60e:
	LDA $044a
	BEQ @07_e645
	STA PPUADDR
	LDA $044b
	STA PPUADDR
	LDA $044c
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
@07_e645:
	LDA $0376
	BEQ @07_e68f
	STA PPUADDR
	LDA $0377
	STA PPUADDR
	LDA $0378
	STA PPUDATA
	LDA $0379
	STA PPUDATA
	LDA $037a
	STA PPUDATA
	LDA $037b
	STA PPUDATA
	LDA $037c
	STA PPUADDR
	LDA $037d
	STA PPUADDR
	LDA $037e
	STA PPUDATA
	LDA $037f
	STA PPUDATA
	LDA $0380
	STA PPUDATA
	LDA $0381
	STA PPUDATA
@07_e68f:
	LDA $0382
	BEQ @07_e6d9
	STA PPUADDR
	LDA $0383
	STA PPUADDR
	LDA $0384
	STA PPUDATA
	LDA $0385
	STA PPUDATA
	LDA $0386
	STA PPUDATA
	LDA $0387
	STA PPUDATA
	LDA $0388
	STA PPUADDR
	LDA $0389
	STA PPUADDR
	LDA $038a
	STA PPUDATA
	LDA $038b
	STA PPUDATA
	LDA $038c
	STA PPUDATA
	LDA $038d
	STA PPUDATA
@07_e6d9:
	LDA $038e
	BEQ @07_e723
	STA PPUADDR
	LDA $038f
	STA PPUADDR
	LDA $0390
	STA PPUDATA
	LDA $0391
	STA PPUDATA
	LDA $0392
	STA PPUDATA
	LDA $0393
	STA PPUDATA
	LDA $0394
	STA PPUADDR
	LDA $0395
	STA PPUADDR
	LDA $0396
	STA PPUDATA
	LDA $0397
	STA PPUDATA
	LDA $0398
	STA PPUDATA
	LDA $0399
	STA PPUDATA
@07_e723:
	LDA $039a
	BEQ @07_e76d
	STA PPUADDR
	LDA $039b
	STA PPUADDR
	LDA $039c
	STA PPUDATA
	LDA $039d
	STA PPUDATA
	LDA $039e
	STA PPUDATA
	LDA $039f
	STA PPUDATA
	LDA $03a0
	STA PPUADDR
	LDA $03a1
	STA PPUADDR
	LDA $03a2
	STA PPUDATA
	LDA $03a3
	STA PPUDATA
	LDA $03a4
	STA PPUDATA
	LDA $03a5
	STA PPUDATA
@07_e76d:
	LDA $03a6
	BEQ @07_e7b7
	STA PPUADDR
	LDA $03a7
	STA PPUADDR
	LDA $03a8
	STA PPUDATA
	LDA $03a9
	STA PPUDATA
	LDA $03aa
	STA PPUDATA
	LDA $03ab
	STA PPUDATA
	LDA $03ac
	STA PPUADDR
	LDA $03ad
	STA PPUADDR
	LDA $03ae
	STA PPUDATA
	LDA $03af
	STA PPUDATA
	LDA $03b0
	STA PPUDATA
	LDA $03b1
	STA PPUDATA
@07_e7b7:
	LDA $03b2
	BEQ @07_e801
	STA PPUADDR
	LDA $03b3
	STA PPUADDR
	LDA $03b4
	STA PPUDATA
	LDA $03b5
	STA PPUDATA
	LDA $03b6
	STA PPUDATA
	LDA $03b7
	STA PPUDATA
	LDA $03b8
	STA PPUADDR
	LDA $03b9
	STA PPUADDR
	LDA $03ba
	STA PPUDATA
	LDA $03bb
	STA PPUDATA
	LDA $03bc
	STA PPUDATA
	LDA $03bd
	STA PPUDATA
@07_e801:
	LDA $03be
	BEQ @07_e84b
	STA PPUADDR
	LDA $03bf
	STA PPUADDR
	LDA $03c0
	STA PPUDATA
	LDA $03c1
	STA PPUDATA
	LDA $03c2
	STA PPUDATA
	LDA $03c3
	STA PPUDATA
	LDA $03c4
	STA PPUADDR
	LDA $03c5
	STA PPUADDR
	LDA $03c6
	STA PPUDATA
	LDA $03c7
	STA PPUDATA
	LDA $03c8
	STA PPUDATA
	LDA $03c9
	STA PPUDATA
@07_e84b:
	LDA $03ca
	BEQ @07_e895
	STA PPUADDR
	LDA $03cb
	STA PPUADDR
	LDA $03cc
	STA PPUDATA
	LDA $03cd
	STA PPUDATA
	LDA $03ce
	STA PPUDATA
	LDA $03cf
	STA PPUDATA
	LDA $03d0
	STA PPUADDR
	LDA $03d1
	STA PPUADDR
	LDA $03d2
	STA PPUDATA
	LDA $03d3
	STA PPUDATA
	LDA $03d4
	STA PPUDATA
	LDA $03d5
	STA PPUDATA
@07_e895:
	LDA $03d6
	BEQ @07_e8df
	STA PPUADDR
	LDA $03d7
	STA PPUADDR
	LDA $03d8
	STA PPUDATA
	LDA $03d9
	STA PPUDATA
	LDA $03da
	STA PPUDATA
	LDA $03db
	STA PPUDATA
	LDA $03dc
	STA PPUADDR
	LDA $03dd
	STA PPUADDR
	LDA $03de
	STA PPUDATA
	LDA $03df
	STA PPUDATA
	LDA $03e0
	STA PPUDATA
	LDA $03e1
	STA PPUDATA
@07_e8df:
	LDA $03e2
	BEQ @07_e929
	STA PPUADDR
	LDA $03e3
	STA PPUADDR
	LDA $03e4
	STA PPUDATA
	LDA $03e5
	STA PPUDATA
	LDA $03e6
	STA PPUDATA
	LDA $03e7
	STA PPUDATA
	LDA $03e8
	STA PPUADDR
	LDA $03e9
	STA PPUADDR
	LDA $03ea
	STA PPUDATA
	LDA $03eb
	STA PPUDATA
	LDA $03ec
	STA PPUDATA
	LDA $03ed
	STA PPUDATA
@07_e929:
	LDA $03ee
	BEQ @07_e973
	STA PPUADDR
	LDA $03ef
	STA PPUADDR
	LDA $03f0
	STA PPUDATA
	LDA $03f1
	STA PPUDATA
	LDA $03f2
	STA PPUDATA
	LDA $03f3
	STA PPUDATA
	LDA $03f4
	STA PPUADDR
	LDA $03f5
	STA PPUADDR
	LDA $03f6
	STA PPUDATA
	LDA $03f7
	STA PPUDATA
	LDA $03f8
	STA PPUDATA
	LDA $03f9
	STA PPUDATA
@07_e973:
	LDA $03fa
	BEQ @07_e9bd
	STA PPUADDR
	LDA $03fb
	STA PPUADDR
	LDA $03fc
	STA PPUDATA
	LDA $03fd
	STA PPUDATA
	LDA $03fe
	STA PPUDATA
	LDA $03ff
	STA PPUDATA
	LDA $0400
	STA PPUADDR
	LDA $0401
	STA PPUADDR
	LDA $0402
	STA PPUDATA
	LDA $0403
	STA PPUDATA
	LDA $0404
	STA PPUDATA
	LDA $0405
	STA PPUDATA
@07_e9bd:
	LDA $0406
	BEQ @07_ea07
	STA PPUADDR
	LDA $0407
	STA PPUADDR
	LDA $0408
	STA PPUDATA
	LDA $0409
	STA PPUDATA
	LDA $040a
	STA PPUDATA
	LDA $040b
	STA PPUDATA
	LDA $040c
	STA PPUADDR
	LDA $040d
	STA PPUADDR
	LDA $040e
	STA PPUDATA
	LDA $040f
	STA PPUDATA
	LDA $0410
	STA PPUDATA
	LDA $0411
	STA PPUDATA
@07_ea07:
	LDA $0412
	BEQ @07_ea51
	STA PPUADDR
	LDA $0413
	STA PPUADDR
	LDA $0414
	STA PPUDATA
	LDA $0415
	STA PPUDATA
	LDA $0416
	STA PPUDATA
	LDA $0417
	STA PPUDATA
	LDA $0418
	STA PPUADDR
	LDA $0419
	STA PPUADDR
	LDA $041a
	STA PPUDATA
	LDA $041b
	STA PPUDATA
	LDA $041c
	STA PPUDATA
	LDA $041d
	STA PPUDATA
@07_ea51:
	LDA $041e
	BEQ @07_ea9b
	STA PPUADDR
	LDA $041f
	STA PPUADDR
	LDA $0420
	STA PPUDATA
	LDA $0421
	STA PPUDATA
	LDA $0422
	STA PPUDATA
	LDA $0423
	STA PPUDATA
	LDA $0424
	STA PPUADDR
	LDA $0425
	STA PPUADDR
	LDA $0426
	STA PPUDATA
	LDA $0427
	STA PPUDATA
	LDA $0428
	STA PPUDATA
	LDA $0429
	STA PPUDATA
@07_ea9b:
	LDA $042a
	BEQ @07_eae5
	STA PPUADDR
	LDA $042b
	STA PPUADDR
	LDA $042c
	STA PPUDATA
	LDA $042d
	STA PPUDATA
	LDA $042e
	STA PPUDATA
	LDA $042f
	STA PPUDATA
	LDA $0430
	STA PPUADDR
	LDA $0431
	STA PPUADDR
	LDA $0432
	STA PPUDATA
	LDA $0433
	STA PPUDATA
	LDA $0434
	STA PPUDATA
	LDA $0435
	STA PPUDATA
@07_eae5:
	LDA $0336
	BEQ @07_eb28
	STA PPUADDR
	LDA $0337
	STA PPUADDR
	LDX $0338
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $0339
	STA PPUADDR
	LDA $033a
	STA PPUADDR
	INX
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $033b
	BEQ @07_eb28
	STA PPUADDR
	LDA $033c
	STA PPUADDR
	LDA $033d
	STA PPUDATA
	STA PPUDATA
@07_eb28:
	LDA $033e
	BEQ @07_eb6b
	STA PPUADDR
	LDA $033f
	STA PPUADDR
	LDX $0340
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $0341
	STA PPUADDR
	LDA $0342
	STA PPUADDR
	INX
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $0343
	BEQ @07_eb6b
	STA PPUADDR
	LDA $0344
	STA PPUADDR
	LDA $0345
	STA PPUDATA
	STA PPUDATA
@07_eb6b:
	LDA $0346
	BEQ @07_ebae
	STA PPUADDR
	LDA $0347
	STA PPUADDR
	LDX $0348
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $0349
	STA PPUADDR
	LDA $034a
	STA PPUADDR
	INX
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $034b
	BEQ @07_ebae
	STA PPUADDR
	LDA $034c
	STA PPUADDR
	LDA $034d
	STA PPUDATA
	STA PPUDATA
@07_ebae:
	LDA $034e
	BEQ @07_ebf1
	STA PPUADDR
	LDA $034f
	STA PPUADDR
	LDX $0350
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $0351
	STA PPUADDR
	LDA $0352
	STA PPUADDR
	INX
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $0353
	BEQ @07_ebf1
	STA PPUADDR
	LDA $0354
	STA PPUADDR
	LDA $0355
	STA PPUDATA
	STA PPUDATA
@07_ebf1:
	LDA $0356
	BEQ @07_ec34
	STA PPUADDR
	LDA $0357
	STA PPUADDR
	LDX $0358
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $0359
	STA PPUADDR
	LDA $035a
	STA PPUADDR
	INX
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $035b
	BEQ @07_ec34
	STA PPUADDR
	LDA $035c
	STA PPUADDR
	LDA $035d
	STA PPUDATA
	STA PPUDATA
@07_ec34:
	LDA $035e
	BEQ @07_ec77
	STA PPUADDR
	LDA $035f
	STA PPUADDR
	LDX $0360
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $0361
	STA PPUADDR
	LDA $0362
	STA PPUADDR
	INX
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $0363
	BEQ @07_ec77
	STA PPUADDR
	LDA $0364
	STA PPUADDR
	LDA $0365
	STA PPUDATA
	STA PPUDATA
@07_ec77:
	LDA $0366
	BEQ @07_ecba
	STA PPUADDR
	LDA $0367
	STA PPUADDR
	LDX $0368
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $0369
	STA PPUADDR
	LDA $036a
	STA PPUADDR
	INX
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $036b
	BEQ @07_ecba
	STA PPUADDR
	LDA $036c
	STA PPUADDR
	LDA $036d
	STA PPUDATA
	STA PPUDATA
@07_ecba:
	LDA $036e
	BEQ @07_ecfd
	STA PPUADDR
	LDA $036f
	STA PPUADDR
	LDX $0370
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $0371
	STA PPUADDR
	LDA $0372
	STA PPUADDR
	INX
	STX PPUDATA
	INX
	STX PPUDATA
	LDA $0373
	BEQ @07_ecfd
	STA PPUADDR
	LDA $0374
	STA PPUADDR
	LDA $0375
	STA PPUDATA
	STA PPUDATA
@07_ecfd:
	LDA $05fa
	BEQ @07_ed2f
	STA PPUADDR
	LDA $05fb
	STA PPUADDR
	LDA $05fc
	STA PPUDATA
	LDA $05fd
	STA PPUDATA
	LDA $05fe
	STA PPUDATA
	LDA $05ff
	STA PPUDATA
	LDA $0600
	STA PPUDATA
	LDA $0601
	STA PPUDATA
@07_ed2f:
	LDA $0602
	BEQ @07_ed61
	STA PPUADDR
	LDA $0603
	STA PPUADDR
	LDA $0406
	STA PPUDATA
	LDA $0605
	STA PPUDATA
	LDA $0606
	STA PPUDATA
	LDA $0607
	STA PPUDATA
	LDA $0608
	STA PPUDATA
	LDA $0609
	STA PPUDATA
@07_ed61:
	LDA $02c6
	BEQ @07_ed7a
	STA PPUADDR
	LDA #$9d
	STA PPUADDR
	LDA $02c7
	STA PPUDATA
	LDA $02c8
	STA PPUDATA
@07_ed7a:
	LDA $02c9
	BEQ @07_ed96
	STA PPUADDR
	LDA #$e2
	STA PPUADDR
	LDX #$0d
	LDY $02ca
@07_ed8c:
	LDA Data_07_efb7, Y
	STA PPUDATA
	INY
	DEX
	BNE @07_ed8c
@07_ed96:
	LDA $02cb
	BEQ @07_edd0
	STA PPUADDR
	LDY #$00
	JSR @07_edbd
	LDA $02cc
	CLC
	ADC #$20
	STA $02cc
	BCC @07_edb1
	INC $02cb
@07_edb1:
	LDA $02cb
	STA PPUADDR
	JSR @07_edbd
	JMP @07_edd0
@07_edbd:
	LDA $02cc
	STA PPUADDR
	LDX $02cd
@07_edc6:
	LDA (zPointer83), Y
	STA PPUDATA
	INY
	DEX
	BNE @07_edc6
	RTS
@07_edd0:
	LDA $02e4
	BEQ @07_ede9
	STA PPUADDR
	LDA #$73
	STA PPUADDR
	LDA $02e5
	STA PPUDATA
	LDA $02e6
	STA PPUDATA
@07_ede9:
	LDA $02e7
	BEQ @07_ee14
	STA PPUADDR
	LDA #$92
	STA PPUADDR
	LDA $02e8
	STA PPUDATA
	LDA $02e9
	STA PPUDATA
	LDA $02ea
	STA PPUDATA
	LDA $02eb
	STA PPUDATA
	LDA $02ec
	STA PPUDATA
@07_ee14:
	LDA PPUSTATUS
	LDA #$3f
	STA PPUADDR
	LDA #$00
	STA PPUADDR
	STA PPUADDR
	STA PPUADDR
	LDA #$00
	STA zNMIActivity
	RTS

Sub_07_ee2c:
	LDA #$23
	STA PPUADDR
	LDA #$c0
	STA PPUADDR
	LDA $056a
	STA PPUDATA
	LDA $056b
	STA PPUDATA
	LDA $056c
	STA PPUDATA
	LDA $056d
	STA PPUDATA
	LDA $056e
	STA PPUDATA
	LDA $056f
	STA PPUDATA
	LDA $0570
	STA PPUDATA
	LDA $0571
	STA PPUDATA
	LDA $0572
	STA PPUDATA
	LDA $0573
	STA PPUDATA
	LDA $0574
	STA PPUDATA
	LDA $0575
	STA PPUDATA
	LDA $0576
	STA PPUDATA
	LDA $0577
	STA PPUDATA
	LDA $0578
	STA PPUDATA
	LDA $0579
	STA PPUDATA
	LDA $057a
	STA PPUDATA
	LDA $057b
	STA PPUDATA
	LDA $057c
	STA PPUDATA
	LDA $057d
	STA PPUDATA
	LDA $057e
	STA PPUDATA
	LDA $057f
	STA PPUDATA
	LDA $0580
	STA PPUDATA
	LDA $0581
	STA PPUDATA
	LDA $0582
	STA PPUDATA
	LDA $0583
	STA PPUDATA
	LDA $0584
	STA PPUDATA
	LDA $0585
	STA PPUDATA
	LDA $0586
	STA PPUDATA
	LDA $0587
	STA PPUDATA
	LDA $0588
	STA PPUDATA
	LDA $0589
	STA PPUDATA
	LDA $058a
	STA PPUDATA
	LDA $058b
	STA PPUDATA
	LDA $058c
	STA PPUDATA
	LDA $058d
	STA PPUDATA
	LDA $058e
	STA PPUDATA
	LDA $058f
	STA PPUDATA
	LDA $0590
	STA PPUDATA
	LDA $0591
	STA PPUDATA
	LDA $0592
	STA PPUDATA
	LDA $0593
	STA PPUDATA
	LDA $0594
	STA PPUDATA
	LDA $0595
	STA PPUDATA
	LDA $0596
	STA PPUDATA
	LDA $0597
	STA PPUDATA
	LDA $0598
	STA PPUDATA
	LDA $0599
	STA PPUDATA
	LDA $059a
	STA PPUDATA
	LDA $059b
	STA PPUDATA
	LDA $059c
	STA PPUDATA
	LDA $059d
	STA PPUDATA
	LDA $059e
	STA PPUDATA
	LDA $059f
	STA PPUDATA
	LDA $05a0
	STA PPUDATA
	LDA $05a1
	STA PPUDATA
	LDA $05a2
	STA PPUDATA
	LDA $05a3
	STA PPUDATA
	LDA $05a4
	STA PPUDATA
	LDA $05a5
	STA PPUDATA
	LDA $05a6
	STA PPUDATA
	LDA $05a7
	STA PPUDATA
	LDA $05a8
	STA PPUDATA
	LDA $05a9
	STA PPUDATA
	RTS

Data_07_efb7:
	.db $00, $00, $07, $01, $0d, $05, $00, $1b, $16, $05, $12, $00, $00
	.db $00, $00, $00, $00, $03, $0c, $05, $01, $12, $00, $00, $00, $00

Sub_07_efd1:
	LDA #$00
	STA $0300
	STA $031b
	STA $0447
	STA $044a
	STA $0376
	STA $0382
	STA $038e
	STA $039a
	STA $03a6
	STA $03b2
	STA $03be
	STA $03ca
	STA $03d6
	STA $03e2
	STA $03ee
	STA $03fa
	STA $0406
	STA $0412
	STA $041e
	STA $042a
	STA $0336
	STA $033b
	STA $033e
	STA $0343
	STA $0346
	STA $034b
	STA $034e
	STA $0353
	STA $0356
	STA $035b
	STA $035e
	STA $0363
	STA $0366
	STA $036b
	STA $036e
	STA $0373
	STA $05fa
	STA $0602
	STA $02c6
	STA $02c9
	STA $02cb
	STA $02e4
	STA $02e7
	RTS
; unreferenced
	LDA #$02
	STA $0474
	JSR Sub_07_f0bc
	JSR Sub_07_f061
	RTS

Sub_07_f061:
	LDA #$04
	STA $0450
	LDA $044f
	ASL A
	ASL A
	TAX
	LDA #$00
	STA $045a, X
	STA $045b, X
	STA $045c, X
	STA $045d, X
	STA $0462, X
	STA $0463, X
	STA $0464, X
	STA $0465, X
	STA $0452, X
	STA $0453, X
	STA $0454, X
	STA $0455, X
	STA $046a, X
	STA $046b, X
	STA $046c, X
	STA $046d, X
@07_f09e:
	LDA $0475, X
	BEQ @07_f0b5
	STA $045a, X
	LDA #$01
	STA $0462, X
	LDA #$02
	STA $0452, X
	LDA #$28
	STA $046a, X
@07_f0b5:
	INX
	DEC $0450
	BNE @07_f09e
	RTS

Sub_07_f0bc:
	JSR Sub_07_f1ff
	JSR Sub_07_f10d
	LDX $044f
	LDA $060c
	BEQ @07_f0d1
	CMP #$01
	BEQ @07_f0d5
	JMP JMP_07_f0e7
@07_f0d1:
	JSR Sub_07_f13b
	RTS
@07_f0d5:
	JSR Sub_07_f10d
	LDA $044f
	ASL A
	ASL A
	TAX
	LDA #$05
	STA $0475, X
	JSR Sub_07_f13b
	RTS


JMP_07_f0e7:
	LDA $044f
	ASL A
	ASL A
	TAX
	LDA $0475, X
	LDA $0475, X
	CMP #$05
	BEQ @07_f101
	LDA $0476, X
	CMP #$05
	BEQ @07_f101
	JMP @07_f109
@07_f101:
	LDA #$05
	STA $0475, X
	STA $0476, X
@07_f109:
	JSR Sub_07_f13b
	RTS

Sub_07_f10d:
	LDA $044f
	ASL A
	ASL A
	TAX
	LDA #$00
	STA $0475, X
	STA $0476, X
	STA $0477, X
	STA $0478, X
	LDA $0474
	STA $0450
@07_f127:
	PHX
	JSR Sub_07_f184
	PLX
	LDA $0255
	STA $0475, X
	INX
	DEC $0450
	BNE @07_f127
	RTS

Sub_07_f13b:
	LDA #$75
	STA zPointerC7
	LDA #$04
	STA zPointerC7 + 1
	LDA $044f
	ASL A
	ASL A
	CLC
	ADC zPointerC7
	STA zPointerC7
	BCC @07_f151
	INC zPointerC7 + 1
@07_f151:
	LDA #$05
	STA $0450
@07_f156:
	JSR Sub_00_80cb
	LDA #$03
	AND $0255
	STA za4
	JSR Sub_00_80cb
	LDA #$03
	AND $0255
	STA za5
	LDY za4
	LDA (zPointerC7), Y
	STA za3
	LDY za5
	LDA (zPointerC7), Y
	LDY za4
	STA (zPointerC7), Y
	LDA za3
	LDY za5
	STA (zPointerC7), Y
	DEC $0450
	BNE @07_f156
	RTS

Sub_07_f184:
	LDA $060c
	BEQ @07_f190
	CMP #$01
	BEQ @07_f1ad
	JMP @07_f1c2
@07_f190:
	JSR Sub_00_80cb
	LDA $0255
	CMP #$41
	BCC @07_f1db
	CMP #$78
	BCC @07_f1e1
	CMP #$a0
	BCC @07_f1e7
	CMP #$d2
	BCC @07_f1ed
	CMP #$eb
	BCC @07_f1f3
	JMP @07_f1f9
@07_f1ad:
	JSR Sub_00_80cb
	LDA $0255
	CMP #$4b
	BCC @07_f1db
	CMP #$8c
	BCC @07_f1e1
	CMP #$c3
	BCC @07_f1e7
	JMP @07_f1ed
@07_f1c2:
	JSR Sub_00_80cb
	LDA $0255
	CMP #$4b
	BCC @07_f1db
	CMP #$87
	BCC @07_f1e1
	CMP #$be
	BCC @07_f1e7
	CMP #$f6
	BCC @07_f1ed
	JMP @07_f1f3
@07_f1db:
	LDA #$01
	STA $0255
	RTS
@07_f1e1:
	LDA #$02
	STA $0255
	RTS
@07_f1e7:
	LDA #$03
	STA $0255
	RTS
@07_f1ed:
	LDA #$04
	STA $0255
	RTS
@07_f1f3:
	LDA #$05
	STA $0255
	RTS
@07_f1f9:
	LDA #$06
	STA $0255
	RTS

Sub_07_f1ff:
	LDA $0520
	BEQ @07_f247
	LDA $02ee
	BNE @07_f210
	LDA $02ed
	CMP #$03
	BCC @07_f247
@07_f210:
	JSR Sub_00_ade5
	LDY $044f
	LDA $060d, Y
	CMP #$0d
	BCS @07_f247
	JSR Sub_07_f253
	LDA $060f
	LDA $0474
	CMP #$03
	BCS @07_f247
	JSR Sub_00_ade5
	JSR Sub_07_f253
	LDY $044f
	LDA $060d, Y
	CLC
	ADC $060f
	LSR A
	BCS @07_f242
	LDA #$02
	JMP @07_f24c
@07_f242:
	LDA #$01
	JMP @07_f24c
@07_f247:
	LDA #$00
	JMP @07_f24c
@07_f24c:
	LDX $044f
	STA $060c
	RTS

Sub_07_f253:
	LDA #$00
	TAY
	STA $060f
	LDA $044f
	ASL A
	ASL A
	TAX
@07_f25f:
	LDA $045a, X
	BEQ @07_f26b
	CMP #$05
	BCS @07_f26b
	INC $060f
@07_f26b:
	INX
	INY
	CPY #$04
	BNE @07_f25f
	RTS

Sub_07_f272:
	LDY $044f
	LDA $0510, Y
	BEQ @07_f2d7
	NOP
	JSR @07_f27f
	RTS
@07_f27f:
	LDA $04fb, Y
	BNE @07_f289
	LDA #$19
	STA $04fb, Y
@07_f289:
	LDA $04fb, Y
	STA zc2
	LDA Data_07_f2de, Y
	STA zc1
	JSR Sub_07_d097
	LDA $044f
	TAY
	BEQ @07_f2a1
	LDX #$03
	JMP @07_f2a3
@07_f2a1:
	LDX #$00
@07_f2a3:
	LDA zc5
	STA $0447, X
	LDA zc4
	STA $0448, X
	LDA $04fb, Y
	CMP #$08
	BNE @07_f2b9
	LDA #$ff
	JMP @07_f2bb
@07_f2b9:
	LDA #$00
@07_f2bb:
	STA $0449, X
	LDA $04fb, Y
	CMP #$06
	BNE @07_f2d8
	LDA #$00
	STA $04fb, Y
	STA $0510, Y
	LDA $044f
	BNE @07_f2d7
	LDA #$01
	STA $050c
@07_f2d7:
	RTS
@07_f2d8:
	TYA
	TAX
	DEC $04fb, X
	RTS

Data_07_f2de:
	.db $02, $11

Sub_07_f2e0:
	LDX $044f
	LDA $050e, X
	BEQ @07_f321
	LDA $0512, X
	BNE @07_f321
	LDA zb2
	AND #$01
	CMP $044f
	BNE @07_f321
	JSR @07_f34f
	JSR Sub_07_f554
	JSR @07_f322
	JSR Sub_07_f554
	JSR @07_f322
	LDX $044f
	LDA $04ff, X
	CMP #$0c
	BCS @07_f31a
	LDA $0501, X
	SEC
	SBC #$02
	CMP $04ff, X
	BCS @07_f330
@07_f31a:
	LDA $04ff, X
	CMP #$02
	BEQ @07_f330
@07_f321:
	RTS
@07_f322:
	LDX $044f
	LDA $0515, X
	CMP #$03
	BNE @07_f321
	DEC $04ff, X
	RTS
@07_f330:
	LDA #$00
	STA $050e, X
	LDA $051c, X
	BEQ @07_f34b
	STA $0444
	LDA $0501, X
	STA $0445
	DEC $0445
	LDA #$00
	STA $0446
@07_f34b:
	JSR Sub_07_f5e4
	RTS
@07_f34f:
	LDX $044f
	LDA $04ff, X
	CMP $0501, X
	BCC @07_f321
	LDA $0515, X
	BEQ @07_f366
	CMP #$01
	BEQ @07_f373
	JMP JMP_07_f380
@07_f366:
	JSR Sub_07_f3d5
	JSR Sub_07_f41b
	LDX $044f
	INC $0515, X
	RTS
@07_f373:
	JSR Sub_07_f3de
	JSR Sub_07_f42a
	LDX $044f
	INC $0515, X
	RTS


JMP_07_f380:
	JSR Sub_07_f3e7
	JSR Sub_07_f44a
	LDX $044f
	JSR Sub_07_f517
	LDX $044f
	LDA $04fd, X
	STA $044d
	INC $044d
	LDA $04ff, X
	STA $044e
	JSR Sub_00_ab09
	LDX $044d
	LDA $0452, X
	SEC
	SBC #$01
	CMP $044e
	BNE @07_f3cc
	LDA $044d
	STA $0444
	LDA $044e
	STA $0445
	INC $0445
	LDA $045a, X
	STA $0446
	LDA #$01
	STA $052d
	JSR Sub_00_a77d
@07_f3cc:
	LDX $044f
	LDA #$03
	STA $0515, X
	RTS

Sub_07_f3d5:
	LDA #$00
	STA $04e1
	JSR Sub_07_f3f0
	RTS

Sub_07_f3de:
	LDA #$02
	STA $04e1
	JSR Sub_07_f3f0
	RTS

Sub_07_f3e7:
	LDA #$04
	STA $04e1
	JSR Sub_07_f3f0
Branch_07_f3ef:
	RTS

Sub_07_f3f0:
	LDX $044f
	LDA $04fd, X
	STA $0444
	LDA $04ff, X
	SEC
	SBC $04e1
	CMP #$04
	BCC Branch_07_f3ef
	LDY $044f
	LDX $04fd, Y
	CMP $0487, X
	BCC Branch_07_f3ef
	STA $0445
	LDA #$00
	STA $0446
	JSR Sub_00_a8d8
	RTS

Sub_07_f41b:
	LDX $044f
	LDA #$01
	STA $0517
	LDA $04ff, X
	JSR Sub_07_f47b
	RTS

Sub_07_f42a:
	LDX $044f
	LDA #$02
	STA $0517
	LDA $04ff, X
	JSR Sub_07_f47b
	LDA #$01
	STA $0517
	LDX $044f
	LDA $04ff, X
	SEC
	SBC #$02
	JSR Sub_07_f47b
	RTS

Sub_07_f44a:
	LDX $044f
	LDA #$03
	STA $0517
	LDA $04ff, X
	JSR Sub_07_f47b
	LDA #$02
	STA $0517
	LDX $044f
	LDA $04ff, X
	SEC
	SBC #$02
	JSR Sub_07_f47b
	LDA #$01
	STA $0517
	LDX $044f
	LDA $04ff, X
	SEC
	SBC #$04
	JSR Sub_07_f47b
	RTS

Sub_07_f47b:
	STA $0445
	STA $04ea
	LDA $04fd, X
	STA $0444
	STA $04e9
	INC $0444
	INC $04e9
	JSR Sub_00_a8ad
	LDY #$00
	LDA (zPointerC7), Y
	STA $0518
	BEQ @07_f4b9
	LDA #$00
	STA $0446
	LDA $0517
	STA $0514
	DEC $0514
	JSR Sub_00_ab29
	LDA $0518
	STA $0446
	INC $0514
	JSR Sub_00_ab29
@07_f4b9:
	LDA $0517
	STA $0514
	LDX $044f
	LDA $04fd, X
	STA $0444
	STA $04e9
	JSR Sub_00_a8ad
	LDY #$00
	LDA (zPointerC7), Y
	BEQ @07_f4dd
	STA $0446
	BEQ @07_f4dc
	JSR Sub_00_ac6c
@07_f4dc:
	RTS
@07_f4dd:
	RTS
; unreferenced
	STA $0445
	STA $04ea
	LDA $04fd, X
	STA $0444
	STA $04e9
	JSR Sub_00_a8ad
	LDY #$00
	LDA (zPointerC7), Y
	STA $0518
	BEQ @07_f4dc
	LDA #$00
	STA $0446
	LDA $0517
	STA $0514
	DEC $0514
	JSR Sub_00_abe0
	LDA $0518
	STA $0446
	INC $0514
	JSR Sub_00_abe0
	RTS

Sub_07_f517:
	LDX $044f
	LDA $04ff, X
	STA $04ea
	LDA $04fd, X
	STA $04e9
	JSR Sub_00_a8ad
	LDY #$00
	LDA (zPointerC7), Y
	STA $04e1
	INC $04e9
	JSR Sub_00_a8ad
	LDY #$00
	LDA (zPointerC7), Y
	STA za3
	LDA $04e1
	STA (zPointerC7), Y
	LDA za3
	STA $04e1
	DEC $04e9
	JSR Sub_00_a8ad
	LDY #$00
	LDA $04e1
	STA (zPointerC7), Y
	RTS

Sub_07_f554:
	LDY $044f
	LDA $04ff, Y
	CMP $0501, Y
	BCC @07_f573
	LDY $044f
	LDX $04fd, Y
	LDA $04ff, Y
	CMP $0452, X
	BEQ @07_f574
	INX
	CMP $0452, X
	BEQ @07_f57a
@07_f573:
	RTS
@07_f574:
	TXA
	TAY
	INY
	JMP @07_f57d
@07_f57a:
	TXA
	TAY
	DEY
@07_f57d:
	LDA $0452, X
	STA $0452, Y
	LDA $045a, X
	STA $045a, Y
	LDA $0462, X
	STA $0462, Y
	LDA $046a, X
	STA $046a, Y
	LDA #$00
	STA $0452, X
	STA $045a, X
	STA $0462, X
	STA $046a, X
	STY $0444
	LDA $0452, Y
	STA $0445
	LDA $045a, Y
	STA $0446
	STX $04e1
	LDA #$01
	STA $052d
	JSR Sub_00_a77d
	LDX $04e1
	STX $0444
	LDX $044f
	LDA $0501, X
	CMP $0445
	BNE @07_f5d9
	DEC $0445
	LDA #$00
	STA $0446
	JSR Sub_00_a8d8
@07_f5d9:
	RTS
; unreferenced
	LDA $0444
	LDX $044f
	STA $051c, X
	RTS

Sub_07_f5e4:
	LDY $044f
	LDA $04fd, X
	TAX
	TAY
	INY
	LDA $0487, X
	STA $04e1
	LDA $0487, Y
	STA $0487, X
	LDA $04e1
	STA $0487, Y
	RTS

Sub_07_f600:
	LDY $044f
	LDA $050e, Y
	BNE @07_f641
	LDA #$12
	STA $04ff, Y
	LDA #$01
	STA $050e, Y
	LDA #$02
	STA $0503, Y
	LDA #$00
	STA $0515, Y
	JSR @07_f620
	RTS
@07_f620:
	LDX $04fd, Y
	LDA $0487, X
	STA i501, Y
	INX
	LDA $0487, X
	CMP $0501, Y
	BCS @07_f635
	STA i501, Y
@07_f635:
	LDA $0501, Y
	CMP #$14
	BNE @07_f641
	LDA #$00
	STA $050e, Y
@07_f641:
	TYA
	TAX
	DEC $0501, X
	RTS

SwapColumns:
	LDX $044f
	LDA #$01
	STA $0505, X
	LDA #$02
	STA $054c, X
	LDA #SFX_SWAP
	JSR StoreMusicID
	RTS

Sub_07_f65a:
	LDA #$00
	STA $044f
	JSR Sub_07_f66c
	RTS

Sub_07_f663:
	LDA #$01
	STA $044f
	JSR Sub_07_f66c
Branch_07_f66b:
	RTS

Sub_07_f66c:
	LDX $044f
	LDA $0505, X
	BNE @07_f675
	RTS
@07_f675:
	DEC $054c, X
	LDA $054c, X
	BNE Branch_07_f66b
	LDA #$02
	STA $054c, X
	LDA $0507, X
	BNE @07_f695
	LDA $0442, X
	CMP #$04
	BEQ @07_f6a1
	INC $0442, X
	JSR Sub_00_a3fb
	RTS
@07_f695:
	LDA $0442, X
	BEQ @07_f6a1
	DEC $0442, X
	JSR Sub_00_a3fb
	RTS
@07_f6a1:
	LDA #$00
	STA $0505, X
	LDA #$01
	EOR $0507, X
	STA $0507, X
	RTS

Data_07_f6af:
	.db $00, $01, $02, $03

InitSound:
	LDA #0
	STA DPCM_DELTA
	STA DPCM_OFFSET
	STA DPCM_SIZE
	LDA #0
	STA DPCM_ENV
	LDA #SQ1_F | SQ2_F | TRI_F | NOISE_F | DPCM_F
	STA SND_CHN
	LDA #<MusicHeaders
	SEC
	SBC #header_byte_length
	STA zMusicStartingHeaderPointer
	LDA #>MusicHeaders
	SBC #0
	STA zMusicStartingHeaderPointer + 1
	LDA #<Instruments
	STA zInstrumentPointer
	LDA #>Instruments
	STA zInstrumentPointer + 1
	LDA #$00
	STA zfe
	LDA #$c8
	STA zff
	JSR SwitchToAudio
	LDA #NO_MUSIC
	JSR PlayAudio
	JSR SwitchToMain
	LDA #0
	STA iMusicTracks
	STA i6b9
	STA iMusicID1
	STA iMusicID2
	RTS

StoreMusicID:
	CMP iMusicID1
	BEQ @quit_1
	BCC @next
	PHA
	LDA iMusicID1
	STA iMusicID2
	PLA
	STA iMusicID1
@quit_1:
	RTS
@next:
	CMP iMusicID2
	BEQ @quit_1
	BCC @quit_2
	STA iMusicID2
@quit_2:
	RTS

Sub_07_f71d:
	LDA zPlayerMode
	BNE @07_f74f
	LDA i248
	CMP #$05
	BEQ @07_f732
	LDA i248
	CMP #$03
	BNE @07_f74f
	JMP Sub_07_db39
@07_f732:
	LDA $0612
	BEQ @07_f74f
	LDA zPlayerMode
	BNE @07_f74f
	LDA $0544
	CMP #$02
	BNE @07_f747
	LDA #$01
	JMP @07_f749
@07_f747:
	EOR #$01
@07_f749:
	STA $0544
	JSR Sub_07_f750
@07_f74f:
	RTS

Sub_07_f750:
	LDX #$17
	LDA #$06
	STA $0264, X
	LDA $0544
	STA $027c, X
	LDA #$92
	STA $0294, X
	LDA #$ae
	STA $02ac, X
	DEX
	LDA #$06
	STA $0264, X
	LDA $0544
	CLC
	ADC #$04
	STA $027c, X
	LDA #$92
	STA $0294, X
	LDA #$ae
	STA $02ac, X
	RTS

TitleScreen:
	JSR DisablePicture
	JSR DisableNMI
	JSR Sub_00_9881
	LDA #CHR_Title
	STA zMMC1Chr
	LDA #CHR_Title
	STA zMMC1Chr + 1
	JSR InitNametable
	JSR Sub_07_cdeb
	LDA #$01
	STA $0260
	JSR Sub_07_f7e2
	LDA #<Data_01_b106
	STA zPointerB7
	LDA #>Data_01_b106
	STA zPointerB7 + 1
	JSR SwitchToAudio
	JSR Sub_07_cf7f
	LDA #$21
	JSR Sub_07_d05d
	LDA #$91
	JSR Sub_07_d05d
	LDA #$00
	JSR Sub_07_d05d
	LDA #$ff
	JSR Sub_07_d05d
	JSR Sub_07_d05d
	JSR Sub_07_cf7f
	JSR SwitchToMain
	LDA #MUSIC_TITLE
	JSR StoreMusicID
	LDA #0
	STA iMusicTracks
	STA iDisableMusic
	JSR CopyPPUControl
	JSR Sub_00_8061
	INC i248
	RTS

Sub_07_f7e2:
	LDA #$00
	JSR Sub_07_d124
	LDA #<Data_07_f913
	STA zPointer83
	LDA #>Data_07_f913
	STA zPointer83 + 1
	JSR Sub_00_adc3
	LDX #$02
	LDA #$04
	STA $0264, X
	LDA #$01
	STA $027c, X
	LDA #$57
	STA $0294, X
	LDA #$1b
	STA $02ac, X
	LDX #$01
	LDA #$04
	STA $0264, X
	LDA #$02
	STA $027c, X
	LDA #$40
	STA $0294, X
	LDA #$6c
	STA $02ac, X
	LDA #$d0
	STA iCrunchCounter
	; $2000 NT, h inc, obj 0, bg 1, 8x8 obj, read, NMI
	LDA #NMI | BG_TABLE
	STA iPPUControl
	LDA #$f8
	STA zPPUScrollY
	LDA #$08
	STA zPPUScrollX
	RTS

JPT_07_f831:
	LDA $0616
	BEQ @07_f842
	LDA #$42
	STA zb1
	JSR Sub_00_806a
	LDA #$00
	STA $0616
@07_f842:
	JSR Sub_00_80cb
	LDA iChannelID
	CMP #MUSIC_TITLE
	BEQ @07_f897
	LDA zPlayerMode
	ORA #$80
	STA iDisableMusic
	LDA z82
	CMP #$02
	BEQ @07_f870
	STA $0520
	LDA #$00
	STA zPlayerMode
	LDX #$04
	STX $02df
	INX
	STX $02c4
	LDA #$01
	STA $0521
	BNE @07_f882
@07_f870:
	LDA #$01
	STA zPlayerMode
	LDA #$00
	STA $0521
	STA $0522
	STA $02df
	STA $02e0
@07_f882:
	LDA #$00
	STA $0259
	STA $025a
	STA $025b
	STA $025c
	LDA #$04
	STA i248
	BNE @07_f912
@07_f897:
	DEC iCrunchCounter
	BNE @07_f8ba
	LDA $027d
	CMP #$02
	BNE @07_f8b0
	LDA #$03
	STA $027d
	LDA #$0a
	STA iCrunchCounter
	JMP @07_f8ba
@07_f8b0:
	LDA #$02
	STA $027d
	LDA #$d0
	STA iCrunchCounter
@07_f8ba:
	LDA #$04
	STA $0264
	LDA #$00
	STA $027c
	LDA #$48
	STA $0294
	LDA iJoyHeld
	AND #$10
	BEQ @07_f8d6
	LDA #$00
	STA zPlayerMode
	BEQ @07_f8f8
@07_f8d6:
	LDA iJoyHeld
	AND #$20
	BEQ @07_f8e3
	LDA #$01
	STA zPlayerMode
	BNE @07_f8f8
@07_f8e3:
	LDA iJoyHeld
	AND #$04
	BEQ @07_f8f8
	LDA zPlayerMode
	BEQ @07_f8f4
	LDA #$00
	STA zPlayerMode
	BEQ @07_f8f8
@07_f8f4:
	LDA #$01
	STA zPlayerMode
@07_f8f8:
	LDA zPlayerMode
	BNE @07_f903
	LDA #$c0
	STA $02ac
	BNE @07_f908
@07_f903:
	LDA #$d0
	STA $02ac
@07_f908:
	LDA iJoyHeld
	AND #$08
	BEQ @07_f912
	INC i248
@07_f912:
	RTS

Data_07_f913:
	.db $ff, $bf, $af, $af, $af, $af, $ef, $ff, $ff, $bb, $aa, $aa, $aa
	.db $aa, $ee, $ff, $ff, $fb, $fa, $fa, $fa, $fa, $ff, $ff, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
