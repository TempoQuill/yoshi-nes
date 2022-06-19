PointerJump:
	JMP (zPointerAD)
; unreferenced
	JMP (zf8)

InitNametable:
	LDA #NAMETABLE_0
	JSR @copy_to_ppu
	LDA #NAMETABLE_1
@copy_to_ppu:
	LDX PPUSTATUS
	STA PPUADDR
	LDA #0
	STA PPUADDR
	LDA #0
	LDX #<NAMETABLE_SIZE
	LDY #>NAMETABLE_SIZE + 1
@loop:
	STA PPUDATA
	DEX
	BNE @loop
	DEY
	BNE @loop
	JSR InitNTAttributes
	RTS

DisablePicture:
	LDA zPPUMask
	AND #$1e ; are we showing anything?
	BEQ @00_805d
	LDY #$03
@00_8033:
	LDX #pal_size * num_pals - 1
@00_8035:
	LDA iPals, X
	SEC
	SBC #$10
	BPL @00_803f
	LDA #$0f
@00_803f:
	STA iPals, X
	DEX
	BPL @00_8035
	LDA #$01
	STA i224
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	DEY
	BNE @00_8033
	LDA zPPUMask
	STA iPPUMask
	AND #$e1 ; hide everything
	STA zPPUMask
@00_805d:
	JSR Sub_00_806a
	RTS

Sub_00_8061:
	LDA iPPUMask
	STA zPPUMask
	JSR Sub_00_806a
	RTS

Sub_00_806a:
	LDA zPPUControl
	BPL @00_807b
	LDA zb1
	BNE @00_8076
	LDA #$01
	STA zb1
@00_8076:
	LDA zb1
	BNE @00_8076
	RTS
@00_807b:
	LDA PPUSTATUS
	BPL @00_807b
	LDA zPPUMask
	STA PPUMASK
	RTS

DisableNMI:
	LDA zPPUControl
	AND #NMI
	BEQ @00_8095
	LDA zPPUControl
	STA iPPUControl
	AND #$ff ^ (NMI | MS_SELECT)
	STA zPPUControl
@00_8095:
	LDA zPPUControl
	STA PPUCTRL
	RTS

CopyPPUControl:
	LDA iPPUControl
	STA PPUCTRL
	STA zPPUControl
	RTS

InitNTAttributes:
	LDX #<NT_ATTRIBUTE_0
	LDY #NT_ATTRIBUTE_SIZE
@00_80a8:
	LDA #>NT_ATTRIBUTE_0
	STA PPUADDR
	STX PPUADDR
	LDA #$00
	STA PPUDATA
	INX
	DEY
	BNE @00_80a8
	RTS

HideSprites:
	LDA #$ef
	LDX #$00
@loop:
	STA iVirtualOAM, X
	XAD 3
	STA iVirtualOAM, X
	INX
	BNE @loop
	RTS

Sub_00_80cb:
	LDA #$fd
	STA $025d
	LDA #$43
	STA $025e
	LDA #$03
	STA $025f
	LDA #$c3
	STA $0257
	LDA #$9e
	STA $0258
	LDA #$26
	STA $0255
	LDA #$00
	STA $0256
@00_80ee:
	LSR $025f
	ROR $025e
	ROR $025d
	BCS @00_8114
	BNE @00_8139
	LDA $0257
	STA $0259
	LDA $0258
	STA $025a
	LDA $0256
	STA $025c
	LDA $0255
	STA $025b
	RTS
@00_8114:
	LDA $0257
	CLC
	ADC $0259
	STA $0257
	LDA $0258
	ADC $025a
	STA $0258
	LDA $0255
	ADC $025b
	STA $0255
	LDA $0256
	ADC $025c
	STA $0256
@00_8139:
	ASL $0259
	ROL $025a
	ROL $025b
	ROL $025c
	JMP @00_80ee

Sub_00_8148:
	JSR Sub_07_efd1
	JSR Sub_07_cdf0
	LDA #$03
	STA $027a
	JSR Sub_00_8581
	LDA #CHR_VS_Results
	STA zMMC1Chr
	STA zMMC1Chr + 1
	LDA $0548
	CMP #$03
	BNE @00_81b4
	LDA #$01
	STA $05b0
	JSR Sub_00_8586
	LDA #<Data_00_820d
	STA zPointer83
	LDA #>Data_00_820d
	STA zPointer83 + 1
	LDA #$22
	STA za4
	LDA #$02
	STA za5
	LDA #$0d
	STA za6
	LDA #$05
	JSR JMP_00_846b
	LDA #$03
	STA $0264
	LDA #$88
	STA $02ac
	LDA #$28
	STA $0294
	LDA #$0a
	STA $027c
	LDA #<Data_00_8393
	STA zPointer83
	LDA #>Data_00_8393
	STA zPointer83 + 1
	LDA #$22
	STA za4
	LDA #$11
	STA za5
	LDA #$0d
	STA za6
	LDA #$05
	JSR JMP_00_846b
	JMP @00_81fd
@00_81b4:
	JSR Sub_00_8564
	LDA #<Data_00_8311
	STA zPointer83
	LDA #>Data_00_8311
	STA zPointer83 + 1
	LDA #$22
	STA za4
	LDA #$11
	STA za5
	LDA #$0d
	STA za6
	LDA #$05
	JSR JMP_00_846b
	LDA #$03
	STA $0264
	LDA #$98
	STA $02ac
	LDA #$b0
	STA $0294
	LDA #$0b
	STA $027c
	LDA #<Data_00_828f
	STA zPointer83
	LDA #>Data_00_828f
	STA zPointer83 + 1
	LDA #$22
	STA za4
	LDA #$02
	STA za5
	LDA #$0d
	STA za6
	LDA #$05
	JSR JMP_00_846b
@00_81fd:
	JSR Sub_07_d16e
	LDA iJoyHeld
	AND #$08
	BEQ @00_81fd
	LDA #$00
	STA i248
	RTS

Data_00_820d:
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $fe, $00, $90, $91, $92, $93, $94, $95, $00, $00, $fe, $00
	.db $00, $fe, $00, $a0, $a1, $a2, $a3, $a4, $a5, $00, $00, $fe, $00
	.db $00, $fe, $00, $b0, $b1, $b2, $b3, $b4, $b5, $00, $00, $fe, $00
	.db $00, $fe, $00, $c0, $c1, $c2, $c3, $c4, $c5, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $d1, $d2, $d3, $d4, $d5, $00, $00, $fe, $00
	.db $00, $fe, $00, $e0, $e1, $e2, $e3, $e4, $e5, $00, $00, $fe, $00
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $00, $07, $01, $0d, $05, $00, $0f, $16, $05, $12, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
Data_00_828f:
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $fe, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $00, $2a, $2b, $2c, $00, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $00, $3a, $3b, $3c, $00, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $00, $4a, $4b, $4c, $00, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $00, $2d, $2e, $2f, $00, $00, $00, $fe, $00
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $00, $07, $01, $0d, $05, $00, $0f, $16, $05, $12, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
Data_00_8311:
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $fe, $00, $25, $26, $27, $28, $94, $95, $00, $00, $fe, $00
	.db $00, $fe, $00, $35, $36, $37, $38, $a4, $a5, $00, $00, $fe, $00
	.db $00, $fe, $00, $45, $46, $47, $48, $b4, $b5, $00, $00, $fe, $00
	.db $00, $fe, $00, $30, $31, $32, $33, $c4, $c5, $00, $00, $fe, $00
	.db $00, $fe, $00, $40, $41, $42, $43, $d4, $d5, $00, $00, $fe, $00
	.db $00, $fe, $00, $e6, $e7, $e2, $e3, $e4, $e5, $00, $00, $fe, $00
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $00, $07, $01, $0d, $05, $00, $0f, $16, $05, $12, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
Data_00_8393:
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $fe, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $00, $bc, $bd, $be, $00, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $00, $cc, $cd, $ce, $00, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $00, $dc, $dd, $de, $00, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $00, $ec, $ed, $ee, $00, $00, $00, $fe, $00
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $00, $07, $01, $0d, $05, $00, $0f, $16, $05, $12, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Sub_00_8415:
	LDA zPlayerMode
	BEQ @00_8450
	LDA $044f
	BNE @00_8450
	LDA #<Data_00_8451
	STA zPointer83
	LDA #>Data_00_8451
	STA zPointer83 + 1
	LDA #$23
	STA za4
	LDA #$02
	STA za5
	LDA #$0d
	STA za6
	LDA #$01
	JSR JMP_00_846b
	LDA #<Data_00_8451
	STA zPointer83
	LDA #>Data_00_8451
	STA zPointer83 + 1
	LDA #$23
	STA za4
	LDA #$11
	STA za5
	LDA #$0d
	STA za6
	LDA #$01
	JSR JMP_00_846b
@00_8450:
	RTS

Data_00_8451:
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


JMP_00_846b:
	STA za3
	LDA za6
	STA $02cd
@00_8472:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	LDA za4
	STA $02cb
	LDA za5
	STA $02cc
	JSR Sub_07_e449
	JSR Sub_07_efd1
	LDA zPPUScrollX
	CLC
	ADC $0552
	STA zPPUScrollX
	LDA $0567
	BEQ @00_8499
	JSR Sub_00_920f
@00_8499:
	LDA za5
	CLC
	ADC #$40
	STA za5
	BCC @00_84a4
	INC za4
@00_84a4:
	JSR Sub_00_84af
	JSR Sub_00_84af
	DEC za3
	BNE @00_8472
	RTS

Sub_00_84af:
	LDA zPointer83
	CLC
	ADC za6
	STA zPointer83
	BCC @00_84ba
	INC zPointer83 + 1
@00_84ba:
	RTS

Sub_00_84bb:
	LDA #$87
	STA zPointer83
	LDA #$04
	STA zPointer83 + 1
	LDA $044f
	BNE @00_84e1
	LDY #$00
	JSR Sub_00_84fa
	LDA za3
	STA $02cf
	LDA za4
	STA $02d0
	LDA zPlayerMode
	BEQ @00_84e0
	LDA #$23
	STA $02ce
@00_84e0:
	RTS
@00_84e1:
	LDY #$04
	JSR Sub_00_84fa
	LDA za3
	STA $02d2
	LDA za4
	STA $02d3
	LDA zPlayerMode
	BEQ @00_84e0
	LDA #$23
	STA $02d1
	RTS

Sub_00_84fa:
	LDA #$00
	CLC
	ADC (zPointer83), Y
	INY
	ADC (zPointer83), Y
	INY
	ADC (zPointer83), Y
	INY
	ADC (zPointer83), Y
	LSR A
	STA za3
	LDA #$28
	SEC
	SBC za3
	JSR Sub_00_8521
	CLC
	LDA #$1b
	ADC za3
	STA za3
	LDA #$1b
	ADC za4
	STA za4
	RTS

Sub_00_8521:
	LDX #$00
	STA za5
	LDA #$00
	STA za3
	STA za4
	LDA za5
@00_852d:	
	CMP #$0a
	BCC @00_8538
	INX
	SEC
	SBC #$0a
	JMP @00_852d
@00_8538:
	STA za4
	TXA
	STA za3
	RTS

Sub_00_853e:
	JSR Sub_00_89a5
	LDA #$21
	STA $02c9
	LDA #$00
	STA $02ca
	RTS

Sub_00_854c:
	LDA #$21
	STA $02c9
	LDA #$0d
	STA $02ca
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_e449
	JSR Sub_07_efd1
	RTS

Sub_00_8564:
	LDA #$01
	STA $05b0
	LDA #$08
	STA $05b1
	LDA #$00
	STA $05b4
	LDA #$06
	STA $05b2
	LDA #$05
	STA $05b3
	JSR Sub_00_bbcb
	RTS

Sub_00_8581:
	LDA #$09
	STA $05b0

Sub_00_8586:
	LDA #$08
	STA $05b1
	LDA #$01
	STA $05b4
	LDA #$06
	STA $05b2
	LDA #$05
	STA $05b3
	JSR Sub_00_bbcb
	RTS

Sub_00_859e:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_e449
	JSR Sub_07_cdf0
	LDA #$03
	STA $027a
	LDA $044f
	BNE @00_85d2
	JSR Sub_00_8564
	LDA #<Data_00_85ef
	STA zPointer83
	LDA #>Data_00_85ef
	STA zPointer83 + 1
	LDA #$22
	STA za4
	LDA #$02
	STA za5
	LDA #$0d
	STA za6
	LDA #$05
	JSR JMP_00_846b
	RTS
@00_85d2:
	JSR Sub_00_8581
	LDA #<Data_00_8671
	STA zPointer83
	LDA #>Data_00_8671
	STA zPointer83 + 1
	LDA #$22
	STA za4
	LDA #$11
	STA za5
	LDA #$0d
	STA za6
	LDA #$05
	JSR JMP_00_846b
	RTS

Data_00_85ef:
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $fe, $00, $90, $91, $92, $93, $94, $95, $96, $00, $fe, $00
	.db $00, $fe, $00, $a0, $a1, $a2, $a3, $a4, $a5, $a6, $00, $fe, $00
	.db $00, $fe, $00, $b0, $b1, $b2, $b3, $b4, $b5, $00, $00, $fe, $00
	.db $00, $fe, $00, $c0, $c1, $c2, $c3, $c4, $c5, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $d1, $d2, $d3, $d4, $d5, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $d1, $d2, $e3, $e4, $e5, $00, $00, $fe, $00
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $10, $15, $13, $08, $00, $13, $14, $01, $12, $14, $1a, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
Data_00_8671:
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $fe, $00, $90, $91, $92, $93, $94, $95, $96, $00, $fe, $00
	.db $00, $fe, $00, $a0, $a1, $a2, $a3, $a4, $a5, $a6, $00, $fe, $00
	.db $00, $fe, $00, $b0, $b1, $b2, $e0, $e1, $e2, $00, $00, $fe, $00
	.db $00, $fe, $00, $c0, $c1, $c2, $f0, $f1, $f2, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $d1, $d2, $d3, $d4, $d5, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $d1, $d2, $e3, $e4, $e5, $00, $00, $fe, $00
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Sub_00_86f3:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_e449
	LDA $044f
	BNE @00_871f
	JSR Sub_00_8564
	LDA #<Data_00_873c
	STA zPointer83
	LDA #>Data_00_873c
	STA zPointer83 + 1
	LDA #$22
	STA za4
	LDA #$02
	STA za5
	LDA #$0d
	STA za6
	LDA #$05
	JSR JMP_00_846b
	RTS
@00_871f:
	JSR Sub_00_8581
	LDA #<Data_00_87be
	STA zPointer83
	LDA #>Data_00_87be
	STA zPointer83 + 1
	LDA #$22
	STA za4
	LDA #$11
	STA za5
	LDA #$0d
	STA za6
	LDA #$05
	JSR JMP_00_846b
	RTS

Data_00_873c:
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $fe, $00, $90, $98, $99, $9a, $9b, $9c, $9d, $00, $fe, $00
	.db $00, $fe, $00, $a7, $a8, $a9, $aa, $ab, $ac, $ad, $00, $fe, $00
	.db $00, $fe, $00, $b7, $b8, $b9, $ba, $bb, $bc, $00, $00, $fe, $00
	.db $00, $fe, $00, $c7, $c8, $c9, $ca, $cb, $cc, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $d1, $d2, $d3, $d4, $d5, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $d1, $d2, $e3, $e4, $e5, $00, $00, $fe, $00
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $10, $15, $13, $08, $00, $13, $14, $01, $12, $14, $1a, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
Data_00_87be:
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $fe, $00, $90, $98, $99, $9a, $9b, $9c, $9d, $00, $fe, $00
	.db $00, $fe, $00, $a7, $a8, $a9, $aa, $ab, $ac, $ad, $00, $fe, $00
	.db $00, $fe, $00, $b7, $b8, $b9, $bd, $be, $bf, $00, $00, $fe, $00
	.db $00, $fe, $00, $c7, $c8, $c9, $cd, $ce, $cf, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $d1, $d2, $d3, $d4, $d5, $00, $00, $fe, $00
	.db $00, $fe, $00, $00, $d1, $d2, $e3, $e4, $e5, $00, $00, $fe, $00
	.db $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Sub_00_8840:
	LDA zPlayerMode
	BNE @00_8863
	LDA $02df
	CMP #$62
	BEQ @00_8863
	INC $02df
	INC $02c4
	LDA #$09
	CMP $02c4
	BCS @00_8860
	LDA #$00
	STA $02c4
	INC $02c5
@00_8860:
	JSR Sub_00_8864
@00_8863:
	RTS

Sub_00_8864:
	LDA i248
	CMP #$05
	BNE Branch_00_8882
	LDA #$22
	STA $02c6
	LDA $02c5
	CLC
	ADC #$1b
	STA $02c7
	LDA $02c4
	CLC
	ADC #$1b
	STA $02c8
Branch_00_8882:
	RTS

Sub_00_8883:
	LDA i248
	CMP #$05
	BNE Branch_00_8882
	LDA #$20
	STA $05fa
	LDA #$f1
	STA $05fb
	LDA #$ee
	STA zPointer83
	LDA #$05
	STA zPointer83 + 1
	LDA #$fc
	STA zPointer85
	LDA #$05
	STA zPointer85 + 1
	LDA #$06
	STA z87
	JSR Sub_00_a771
	LDX #$02
@00_88ad:
	LDA $05fa, X
	BNE @00_88bc
	LDA #$00
	STA $05fa, X
	INX
	CPX #$07
	BNE @00_88ad
@00_88bc:
	LDA $05fa, X
	CLC
	ADC #$1b
	STA $05fa, X
	INX
	CPX #$08
	BNE @00_88bc
	LDA zPlayerMode
	BEQ @00_8925
	LDA #$20
	STA $05fa
	LDA #$27
	STA $05fb
	LDA #$20
	STA $0602
	LDA #$33
	STA $0603
	LDA #$f4
	STA zPointer83
	LDA #$05
	STA zPointer83 + 1
	LDA #$04
	STA zPointer85
	LDA #$06
	STA zPointer85 + 1
	LDA #$06
	STA z87
	JSR Sub_00_a771
	LDX #$02
@00_8ffb:
	LDA $0602, X
	BNE @00_890a
	LDA #$00
	STA $0602, X
	INX
	CPX #$07
	BNE @00_8ffb
@00_890a:
	LDA $0602, X
	CLC
	ADC #$1b
	STA $0602, X
	INX
	CPX #$08
	BNE @00_890a
@00_8918:
	LDA $0604
	CMP #$00
	BNE @00_8925
	JSR Sub_00_8926
	JMP @00_8918
@00_8925:
	RTS

Sub_00_8926:
	LDX #$00
@00_8928:
	LDA $0605, X
	STA $0604, X
	INX
	CPX #$05
	BNE @00_8928
	LDA #$00
	STA $0609
	RTS

Sub_00_8939:
	ASL A
	ASL A
	STA za4
	LDA $044f
	BNE @00_895f
	LDA #$03
	LDX #$06
	JSR @00_8978
	LDA #$02
	LDX #$05
	JSR @00_8978
	LDA #$01
	LDX #$04
	JSR @00_8978
	LDA #$00
	LDX #$03
	JSR @00_8978
	RTS
@00_895f:
	LDA #$03
	LDX #$0c
	JSR @00_8978
	LDA #$02
	LDX #$0b
	JSR @00_8978
	LDA #$01
	LDX #$0a
	JSR @00_8978
	LDA #$00
	LDX #$09
@00_8978:
	CLC
	ADC za4
	TAY
	LDA (zPointer83), Y
	STA za3
@00_8980:
	LDA za3
	CLC
	ADC $05ed, X
	STA $05ed, X
	CMP #$0a
	BCC @00_89a4
	SEC
	SBC #$0a
	STA $05ed, X
	LDA #$01
	STA za3
	DEX
	BNE @00_8980
	LDX #$06
	LDA #$09
@00_899e:
	STA $05ed, X
	DEX
	BNE @00_899e
@00_89a4:
	RTS

Sub_00_89a5:
	JSR Sub_07_cdf0
	LDA #$06
	STA $027b
	STA $027a
	STA $0279
	RTS

Sub_00_89b4:
	LDA $0536
	ORA $0535
	BNE @00_89c4
	LDA #$78
	STA zb1
	JSR Sub_00_806a
	RTS
@00_89c4:
	LDA #<Data_00_8e8c
	STA zPointer83
	LDA #>Data_00_8e8c
	STA zPointer83 + 1
	LDA #$20
	STA za4
	LDA #$c2
	STA za5
	LDA #$0d
	STA za6
	LDA #$0a
	JSR JMP_00_846b
	LDA #CHR_1P
	STA zMMC1Chr
	LDA #<Data_00_8f90
	STA zPointer83
	LDA #>Data_00_8f90
	STA zPointer83 + 1
	LDA #$22
	STA za4
	LDA #$c2
	STA za5
	LDA #$0d
	STA za6
	LDA #$01
	JSR JMP_00_846b
	LDA #$01
	STA $05b0
	LDA #$0a
	STA $05b1
	LDA #$01
	STA $05b4
	LDA #$06
	STA $05b2
	LDA #$02
	STA $05b3
	JSR Sub_00_bbcb
	LDA $0536
	BEQ @00_8a26
	LDA #<Data_00_8e72
	STA zPointer83
	LDA #>Data_00_8e72
	STA zPointer83 + 1
	JMP @00_8a40
@00_8a26:
	LDA $0535
	CMP #$04
	BCC @00_8a38
	LDA #<Data_00_8e58
	STA zPointer83
	LDA #>Data_00_8e58
	STA zPointer83 + 1
	JMP @00_8a40
@00_8a38:
	LDA #<Data_00_8e3e
	STA zPointer83
	LDA #>Data_00_8e3e
	STA zPointer83 + 1
@00_8a40:
	LDA #$23
	STA za4
	LDA #$22
	STA za5
	LDA #$0d
	STA za6
	LDA #$01
	JSR JMP_00_846b
	LDA $0536
	BEQ @00_8a5e
	LDA #$06
	STA iStageNum
	JMP @00_8a73
@00_8a5e:
	LDA $0535
	CMP #$07
	BCC @00_8a6d
	LDA #$06
	STA iStageNum
	JMP @00_8a73
@00_8a6d:
	SEC
	SBC #$01
	STA iStageNum
@00_8a73:
	LDA #$01
	STA $0567
	LDA #$00
	STA $044f
	STA $0525
	LDA #$04
	STA iCrunchCounter
	LDA #$12
	STA $0527
@00_8a8a:
	JSR Sub_00_8c6d
	LDA #$01
	STA $054f
	LDA #$00
	STA $0550
	LDA #$1e
	JSR Sub_00_8c4c
	LDA #$07
	JSR Sub_00_8c7f
	LDA $0550
	BEQ @00_8aba
	LDA #SFX_HATCH
	JSR StoreMusicID
	LDA #$0a
	STA zb1
	JSR Sub_00_806a
	LDA #$ff
	STA $0550
	JMP @00_8ace
@00_8aba:
	LDA #$00
	STA $054f
	LDA #$ff
	STA $0550
	LDA #SFX_HATCH
	JSR StoreMusicID
	LDA #$14
	JSR Sub_00_8c4c
@00_8ace:
	JSR Sub_00_91c9
	LDA #$08
	STA $0530
	LDA iStageNum
	ASL A
	ASL A
	TAX
	LDA $0550
	CMP Data_00_8fb8, X
	BCS @00_8b17
	LDA #$08
	JSR Sub_00_8c7f
	JSR Sub_00_8c39
	LDA #$00
	JSR Sub_00_8cb0
	LDA #$00
	JSR Sub_00_8cda
	LDA #$00
	JSR Sub_00_8d33
	LDA #$08
	JSR Sub_00_8d33
	LDA #SFX_BIG_YOSHI
	JSR StoreMusicID
	LDA #$07
	STA $0280
	LDA #$a0
	STA $02b0
	LDA #$03
	JSR Sub_00_8d8c
	JMP @00_8bfe
@00_8b17:
	INX
	CMP Data_00_8fb8, X
	BCS @00_8b4b
	LDA #$08
	JSR Sub_00_8c7f
	JSR Sub_00_8c39
	LDA #$00
	JSR Sub_00_8cb0
	LDA #$00
	JSR Sub_00_8cda
	LDA #$08
	JSR Sub_00_8cda
	LDA #SFX_YOSHI
	JSR StoreMusicID
	LDA #$03
	STA $0280
	LDA #$a8
	STA $02b0
	LDA #$02
	JSR Sub_00_8d8c
	JMP @00_8bfe
@00_8b4b:
	INX
	CMP Data_00_8fb8, X
	BCS @00_8b7a
	LDA #$08
	JSR Sub_00_8c7f
	JSR Sub_00_8c39
	LDA #$00
	JSR Sub_00_8cb0
	LDA #$08
	JSR Sub_00_8cb0
	LDA #SFX_YOSHI
	JSR StoreMusicID
	LDA #$01
	STA $0280
	LDA #$a8
	STA $02b0
	LDA #$01
	JSR Sub_00_8d8c
	JMP @00_8bfe
@00_8b7a:
	INX
	CMP Data_00_8fb8, X
	BCS @00_8ba4
	LDA #$08
	JSR Sub_00_8c7f
	JSR Sub_00_8c39
	LDA #$09
	JSR Sub_00_8c7f
	LDA #SFX_YOSHI
	JSR StoreMusicID
	LDA #$00
	STA $0280
	LDA #$b0
	STA $02b0
	LDA #$00
	JSR Sub_00_8d8c
	JMP @00_8bfe
@00_8ba4:
	LDA iStageNum
	JSR Sub_00_8c7f
	LDA #$0b
	STA $05ab
	LDX iStageNum
	LDA Data_00_8fb1, X
	STA $05b4
	LDA $0525
	BNE @00_8bd0
	LDA #$01
	STA $05aa
	JSR Sub_00_bbc1
	LDA #$02
	STA $05aa
	JSR Sub_00_bbc1
	JMP @00_8bfe
@00_8bd0:
	CMP #$01
	BNE @00_8bdf
	LDA #$03
	STA $05aa
	JSR Sub_00_bbc1
	JMP @00_8bfe
@00_8bdf:
	CMP #$02
	BNE @00_8bf6
	LDA #$04
	STA $05aa
	JSR Sub_00_bbc1
	LDA #$05
	STA $05aa
	JSR Sub_00_bbc1
	JMP @00_8bfe
@00_8bf6:
	LDA #$06
	STA $05aa
	JSR Sub_00_bbc1
@00_8bfe:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_00_920f
	LDA $0530
	AND #$03
	BEQ @00_8bfe
	INC $0525
	DEC iCrunchCounter
	BEQ @00_8c1a
	JMP @00_8a8a
@00_8c1a:
	JSR Sub_00_8c6d
@00_8c1d:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_d16e
	LDA iJoyHeld
	AND #$08
	BEQ @00_8c1d
	LDA #$00
	STA $0567
	LDA #$04
	STA i248
	RTS

Sub_00_8c39:
	LDA #$05
	STA za3
@00_8c3d:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_00_920f
	DEC za3
	BNE @00_8c3d
	RTS

Sub_00_8c4c:
	STA za3
@00_8c4e:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_d16e
	LDA iJoyHeld
	AND #$03
	BEQ @00_8c65
	LDA $054f
	STA $0550
@00_8c65:
	INC $054f
	DEC za3
	BNE @00_8c4e
	RTS

Sub_00_8c6d:
	LDA #$ff
	STA $0268
	STA $0270
	STA $0271
	STA $0272
	STA $0273
	RTS

Sub_00_8c7f:
	ASL A
	ASL A
	STA za6
	LDA #<Data_00_8de6
	STA zPointer83
	LDA #>Data_00_8de6
	STA zPointer83 + 1
	JSR Sub_00_84af
	LDA #$22
	STA za4
	LDA #$c3
	CLC
	ADC $0525
	ADC $0525
	ADC $0525
	STA za5
	LDA #$02
	STA za6
	LDA #$01
	JSR JMP_00_846b
	RTS
; unreferenced
	LDA #$08
	JSR Sub_00_8c7f
	RTS

Sub_00_8cb0:
	STA za6
	LDA #<Data_00_8e0e
	STA zPointer83
	LDA #>Data_00_8e0e
	STA zPointer83 + 1
	JSR Sub_00_84af
	LDA #$22
	STA za4
	LDA #$83
	CLC
	ADC $0525
	ADC $0525
	ADC $0525
	STA za5
	LDA #$02
	STA za6
	JSR JMP_00_846b
	JSR Sub_00_8c39
	RTS

Sub_00_8cda:
	STA za6
	LDX $0525
	LDA #$03
	STA $0264, X
	LDA #$b0
	STA $02ac, X
	LDA #$05
	CLC
	ADC $0525
	ADC $0525
	ADC $0525
	ASL A
	ASL A
	ASL A
	STA $0294, X
	LDA #$06
	STA $027c, X
	LDA za6
	BEQ @00_8d09
	LDA #$07
	STA $027c, X
@00_8d09:
	LDA #<Data_00_8e1e
	STA zPointer83
	LDA #>Data_00_8e1e
	STA zPointer83 + 1
	JSR Sub_00_84af
	LDA #$22
	STA za4
	LDA #$83
	CLC
	ADC $0525
	ADC $0525
	ADC $0525
	STA za5
	LDA #$02
	STA za6
	LDA #$02
	JSR JMP_00_846b
	JSR Sub_00_8c39
	RTS

Sub_00_8d33:
	STA za6
	LDX $0525
	LDA #<Data_00_a003
	STA $0264, X
	LDA #>Data_00_a003
	STA $02ac, X
	LDA #$05
	CLC
	ADC $0525
	ADC $0525
	ADC $0525
	ASL A
	ASL A
	ASL A
	STA $0294, X
	LDA #$08
	STA $027c, X
	LDA za6
	BEQ @00_8d62
	LDA #$09
	STA $027c, X
@00_8d62:
	LDA #<Data_00_8e2e
	STA zPointer83
	LDA #>Data_00_8e2e
	STA zPointer83 + 1
	JSR Sub_00_84af
	LDA #$22
	STA za4
	LDA #$83
	CLC
	ADC $0525
	ADC $0525
	ADC $0525
	STA za5
	LDA #$02
	STA za6
	LDA #$02
	JSR JMP_00_846b
	JSR Sub_00_8c39
	RTS

Sub_00_8d8c:
	PHA
	LDA #$08
	STA $0268
	LDA $0525
	STA $0444
	JSR Sub_00_ac39
	LDA $051a
	CLC
	ADC #$08
	STA $0298
	LDA #$10
	STA za3
@00_8da8:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_00_920f
	DEC $02b0
	DEC za3
	BNE @00_8da8
	LDA #<Data_00_8dd6
	STA zPointer83
	LDA #>Data_00_8dd6
	STA zPointer83 + 1
	PLA
	JSR Sub_00_8939
	JSR Sub_00_8883
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_e449
	JSR Sub_07_efd1
	RTS

Data_00_8dd6:
	.db $00, $00, $05, $00, $00, $01, $00, $00, $00, $02, $00, $00, $00
	.db $05, $00, $00
Data_00_8de6:
	.db $53, $54, $55, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $5e, $5f
	.db $60, $61, $62, $9c, $9d, $ac, $ad, $9e, $9f, $ae, $af, $89, $8a
	.db $8b, $8c, $92, $93, $a2, $a3, $b0, $b1, $c0, $c1, $b2, $b3, $c2
	.db $c3
Data_00_8e0e:
	.db $00, $00, $b7, $d1, $e0, $e1, $f0, $f1, $00, $00, $d2, $d3, $e2
	.db $e3, $f2, $f3
Data_00_8e1e:
	.db $00, $00, $d4, $d5, $e4, $e5, $f4, $ab, $00, $00, $d8, $d9, $e8
	.db $e9, $bb, $f9
Data_00_8e2e:
	.db $94, $95, $a4, $a5, $b4, $b5, $c4, $c5, $98, $99, $a8, $a9, $b8
	.db $b9, $c8, $c9
Data_00_8e3e:
	.db $00, $00, $bc, $bd, $be, $bf, $00, $cc, $cd, $cd, $ce, $00, $00
	.db $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18
Data_00_8e58:
	.db $00, $00, $bd, $dc, $eb, $bd, $dd, $dd, $bd, $de, $cb, $00, $00
	.db $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18
Data_00_8e72:
	.db $ec, $ed, $ee, $bd, $be, $00, $ee, $dd, $db, $bf, $bd, $be, $cf
	.db $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18
Data_00_8e8c:
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $07, $01, $0d, $05, $00, $1b, $16, $05, $12, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
Data_00_8f1b:
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $8d, $8e, $00, $8d, $8e, $00, $8d, $8e, $00, $8d, $8e, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
Data_00_8f90:
	.db $00, $90, $91, $00, $90, $91, $00, $90, $91, $00, $90, $91, $00
	.db $00, $a0, $a1, $00, $a0, $a1, $00, $a0, $a1, $00, $a0, $a1, $00
	.db $00, $01, $02, $03, $04, $05, $06

Data_00_8fb1:
	.db $02, $00, $00, $00, $00, $00, $02

Data_00_8fb8:
	.db $01, $02, $03, $04, $01, $03, $05, $08, $01, $03, $06, $0a, $01
	.db $04, $08, $0c, $02, $05, $0a, $0e, $03, $06, $0a, $0f, $04, $08
	.db $0d, $12

Sub_00_8fd4:
	LDA #$00
	STA $02ed
	STA $02ee
	STA $02ef
	STA $02f0
	LDA #$21
	STA $02e7
	LDA #<Data_00_8f1b
	STA $02e8
	STA $02e9
	STA $02eb
	STA $02ec
	LDA #>Data_00_8f1b
	STA $02ea
	LDA #$3c
	STA $02f1
Branch_00_8fff:
	RTS

Sub_00_9000:
	LDA $0520
	BEQ Branch_00_8fff
	LDA $051e
	BNE Branch_00_8fff
	LDA $0512
	BNE Branch_00_8fff
	DEC $02f1
	BNE Branch_00_8fff
	LDA #$3c
	STA $02f1
	LDA #$ef
	STA zPointer83
	LDA #$02
	STA zPointer83 + 1
	LDY #$00
	LDA #$02
	JSR Sub_07_d929
	LDA $02f0
	CMP #$06
	BNE @00_9046
	LDA #$00
	STA $02ef
	STA $02f0
	LDA #$ed
	STA zPointer83
	LDA #$02
	STA zPointer83 + 1
	LDY #$00
	LDA #$02
	JSR Sub_07_d929
@00_9046:
	LDA #$f4
	STA zPointer83
	LDA #$02
	STA zPointer83 + 1
	LDY #$00
	LDA #$02
	JSR Sub_07_d929
	LDA $02f5
	CMP #$06
	BNE @00_9073
	LDA #$00
	STA $02f4
	STA $02f5
	LDA #$f2
	STA zPointer83
	LDA #$02
	STA zPointer83 + 1
	LDY #$00
	LDA #$02
	JSR Sub_07_d929
@00_9073:
	LDA zPlayerMode
	BNE @00_907c
	LDA #$21
	STA $02e7
@00_907c:
	LDA $02ee
	CLC
	ADC #<Data_00_8f1b
	STA $02e8
	LDA $02ed
	CLC
	ADC #<Data_00_8f1b
	STA $02e9
	LDA #>Data_00_8f1b
	STA $02ea
	LDA $02f0
	CLC
	ADC #<Data_00_8f1b
	STA $02eb
	LDA $02ef
	CLC
	ADC #<Data_00_8f1b
	STA $02ec
	RTS

Data_00_90a6:
	.db $00, $00, $01, $01, $01, $02, $02, $03
Data_00_90ae:
	.db $00, $00, $05, $00, $00, $00, $05, $00, $00, $01, $00, $00, $00
	.db $01, $00, $00, $00, $01, $00, $00, $00, $02, $00, $00, $00, $02
	.db $00, $00, $00, $05, $00, $00

Sub_00_90ce:
	LDX $044f
	LDA #$00
	STA $0530, X
	STA $0540, X
	LDA $053a, X
	TAY
	LDA Data_00_90a6, Y
	CLC
	ADC #$02
	STA $0542, X
	LDA #$0f
	STA $053e, X
	LDA $0525, X
	STA $0444
	LDA $0527, X
	STA $0445
	JSR Sub_00_ac39
	LDA $044f
	CLC
	ADC #$14
	TAX
	LDA #$03
	STA $0264, X
	LDA #$00
	STA $027c, X
	LDA $051a
	STA $0294, X
	LDA $051b
	STA $02ac, X
Branch_00_9117:
	RTS

Sub_00_9118:
	LDX $044f
	LDA $0530, X
	AND #$04
	BNE Branch_00_9117
	DEC $053e, X
	BNE Branch_00_9117
	LDA #$05
	STA $053e, X
	INC $0540, X
	LDA $044f
	CLC
	ADC #$14
	TAY
	LDA $0540, X
	STA $027c, Y
	CMP #$01
	BNE @00_914c
	LDA #SFX_HATCH
	JSR StoreMusicID
	LDA #$0f
	STA $053e, X
	BNE @00_9167
@00_914c:
	CMP #$02
	BNE @00_9167
	LDA #$14
	STA $053e, X
	LDX $044f
	LDA $0530, X
	ORA #$08
	STA $0530, X
	PHY
	JSR Sub_00_91c9
	PLY
@00_9167:
	LDX $044f
	LDA $0540, X
	SEC
	SBC $0542, X
	BNE @00_9179
	LDA #$19
	STA $053e, X
	RTS
@00_9179:
	CMP #$01
	BNE @00_91b0
	LDA $0540, X
	SEC
	SBC #$01
	ORA #$10
	STA $027c, Y
	LDA #$32
	STA $053e, X
	LDA #<Data_00_90ae
	STA zPointer83
	LDA #>Data_00_90ae
	STA zPointer83 + 1
	LDA $053a, X
	JSR Sub_00_8939
	LDX $044f
	LDA $0542, X
	CMP #$05
	BNE @00_91aa
	LDA #SFX_BIG_YOSHI
	JMP @00_91ac
@00_91aa:
	LDA #SFX_YOSHI
@00_91ac:
	JSR StoreMusicID
	RTS
@00_91b0:
	CMP #$02
	BNE @00_91c8
	LDA $0530, X
	ORA #$04
	STA $0530, X
	LDA $044f
	CLC
	ADC #$14
	TAY
	LDA #$ff
	STA $0264, Y
@00_91c8:
	RTS

Sub_00_91c9:
	LDX $044f
	LDA #$00
	STA $052e, X
	LDA $0525, X
	STA $0444
	LDA $0527, X
	STA $0445
	JSR Sub_00_ac39
	LDA $044f
	ASL A
	ASL A
	CLC
	ADC #$0c
	TAX
	LDA #$00
	STA zc7
	LDA #$04
	STA zc9
@00_91f1:
	LDA #$02
	STA $0264, X
	LDA zc7
	STA $027c, X
	LDA $051a
	STA $0294, X
	LDA $051b
	STA $02ac, X
	INX
	INC zc7
	DEC zc9
	BNE @00_91f1
Branch_00_920e:
	RTS

Sub_00_920f:
	LDX $044f
	LDA $0530, X
	AND #$08
	BEQ Branch_00_920e
	LDY $052e, X
	LDA Data_00_92d8, Y
	STA zc7
	LDA Data_00_931b, Y
	STA zcd
	INY
	LDA Data_00_92d8, Y
	STA zc9
	LDA Data_00_931b, Y
	STA zcf
	INY
	TYA
	STA $052e, X
	LDA $0530, X
	AND #$01
	BNE @00_925a
	LDA zc7
	CMP #$10
	BNE @00_924e
	LDA $0530, X
	ORA #$01
	STA $0530, X
	JMP @00_925a
@00_924e:
	LDA #$00
	STA zcb
	JSR Sub_00_92a4
	INC zcb
	JSR Sub_00_92a4
@00_925a:
	LDA $0530, X
	AND #$02
	BNE @00_9286
	LDA zcd
	CMP #$10
	BNE @00_9272
	LDA $0530, X
	ORA #$02
	STA $0530, X
	JMP @00_9286
@00_9272:
	LDA zcd
	STA zc7
	LDA zcf
	STA zc9
	LDA #$02
	STA zcb
	JSR Sub_00_92a4
	INC zcb
	JSR Sub_00_92a4
@00_9286:
	LDA $0530, X
	AND #$03
	CMP #$03
	BNE @00_92a3
	LDA $044f
	ASL A
	ASL A
	CLC
	ADC #$0c
	TAX
	LDY #$04
	LDA #$ff
@00_929c:
	STA $0264, X
	INX
	DEY
	BNE @00_929c
@00_92a3:
	RTS

Sub_00_92a4:
	STX zd1
	LDA $044f
	ASL A
	ASL A
	CLC
	ADC #$0c
	ADC zcb
	TAX
	LDA zcb
	AND #$01
	BEQ @00_92c3
	LDA $0294, X
	CLC
	ADC zc7
	STA $0294, X
	JMP @00_92cc
@00_92c3:
	LDA $0294, X
	SEC
	SBC zc7
	STA $0294, X
@00_92cc:
	LDA $02ac, X
	CLC
	ADC zc9
	STA $02ac, X
	LDX zd1
	RTS

Data_00_92d8:
	.db $01, $ff, $01, $ff, $01, $ff, $01, $00, $01, $00, $01, $ff, $01
	.db $00, $01, $01, $01, $00, $01, $00, $01, $01, $01, $01, $01, $01
	.db $01, $01, $00, $01, $00, $01, $01, $01, $00, $01, $00, $01, $01
	.db $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01
	.db $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00
	.db $01, $10

Data_00_931b:
	.db $01, $00, $01, $00, $01, $01, $01
Data_00_9322:
	.db $00, $01, $00, $01, $01, $01, $00, $01, $01, $01, $01, $01, $01
	.db $01, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00
	.db $01, $00, $01, $01, $01, $00, $01, $00, $01, $00, $01, $00, $01
	.db $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00
	.db $01, $10

Sub_00_9358:
	JSR DisablePicture
	JSR DisableNMI
	LDA #$00
	STA zPPUScrollY
	LDA $0520
	BNE @00_9372
	LDA #<Attr_00_9801
	STA zPointer83
	LDA #>Attr_00_9801
	STA zPointer83 + 1
	JMP @00_937a
@00_9372:
	LDA #<Attr_00_9841
	STA zPointer83
	LDA #>Attr_00_9841
	STA zPointer83 + 1
@00_937a:
	JSR Sub_00_adc3
	LDA #$06
	JSR Sub_07_d124
	JSR Sub_07_efd1
	JSR Sub_07_cdf0
	LDA #$00
	STA $0263
	STA zPPUScrollX
	LDA #CHR_Records
	STA zMMC1Chr
	LDA #<Data_00_9672
	STA zPointer83
	LDA #>Data_00_9672
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_9677
	STA zPointer83
	LDA #>Data_00_9677
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_967c
	STA zPointer83
	LDA #>Data_00_967c
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_9681
	STA zPointer83
	LDA #>Data_00_9681
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_9686
	STA zPointer83
	LDA #>Data_00_9686
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_968b
	STA zPointer83
	LDA #>Data_00_968b
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_9690
	STA zPointer83
	LDA #>Data_00_9690
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_9695
	STA zPointerB7
	LDA #>Data_00_9695
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
	LDA $0520
	BNE @00_9400
	LDA #<Data_00_970d
	STA zPointerB7
	LDA #>Data_00_970d
	STA zPointerB7 + 1
	LDA #$00
	STA iStageNum
	JMP @00_940d
@00_9400:
	LDA #<Data_00_9761
	STA zPointerB7
	LDA #>Data_00_9761
	STA zPointerB7 + 1
	LDA #$39
	STA iStageNum
@00_940d:
	JSR Sub_07_cf7f
	JSR CopyPPUControl
	JSR Sub_00_8061
	LDA #$fc
	STA zPointer83
	LDA #$05
	STA zPointer83 + 1
	LDA #$b5
	STA zPointer85
	LDA #$05
	STA zPointer85 + 1
	LDA #$06
	STA z87
	JSR Sub_00_a771
	LDA $02c7
	STA $05bf
	LDA $02c8
	STA $05c0
	LDA $0520
	BNE @00_945c
	LDA $0536
	CLC
	ADC #$1b
	STA $05c5
	LDA $0535
	CLC
	ADC #$1b
	STA $05c6
	LDA $0534
	CLC
	ADC #$1b
	STA $05c7
	JMP @00_9487
@00_945c:
	LDA $02f3
	BEQ @00_9467
	CLC
	ADC #$1b
	STA $05c3
@00_9467:
	LDA $02f2
	CLC
	ADC #$1b
	STA $05c4
	LDA #$25
	STA $05c5
	LDA $02f5
	CLC
	ADC #$1b
	STA $05c6
	LDA $02f4
	CLC
	ADC #$1b
	STA $05c7
@00_9487:
	LDA #$00
	STA iCrunchCounter
	LDA #$03
	STA $054f
@00_9491:
	LDX #$00
	LDA #$06
	JSR Sub_00_97e7
	BEQ @00_949e
	BCS @00_94da
	BNE @00_94c9
@00_949e:
	LDX #$0a
	LDA #$02
	JSR Sub_00_97e7
	BEQ @00_94ab
	BCS @00_94da
	BNE @00_94c9
@00_94ab:
	LDA $0520
	BNE @00_94be
	LDX #$10
	LDA #$03
	JSR Sub_00_97e7
	BEQ @00_94da
	BCS @00_94da
	JMP @00_94c9
@00_94be:
	LDX #$0e
	LDA #$05
	JSR Sub_00_97e7
	BEQ @00_94da
	BCC @00_94da
@00_94c9:
	LDA iCrunchCounter
	CLC
	ADC #$13
	STA iCrunchCounter
	DEC $054f
	BNE @00_9491
	JMP @00_955a
@00_94da:
	LDA $054f
	CMP #$03
	BNE @00_951a
	LDA #$16
	STA zPointer83
	LDA #$00
	STA zPointer83 + 1
	LDA #$29
	STA zPointer85
	LDA #$00
	STA zPointer85 + 1
	LDA #$13
	STA z87
	JSR Sub_00_97d8
	LDA #$03
	STA zPointer83
	LDA #$00
	STA zPointer83 + 1
	LDA #$16
	STA zPointer85
	LDA #$00
	STA zPointer85 + 1
	LDA #$13
	STA z87
	JSR Sub_00_97d8
	LDA #$03
	STA zPointer85
	LDA #$00
	STA zPointer85 + 1
	JMP @00_9548
@00_951a:
	CMP #$02
	BNE @00_9540
	LDA #$16
	STA zPointer83
	LDA #$00
	STA zPointer83 + 1
	LDA #$29
	STA zPointer85
	LDA #$00
	STA zPointer85 + 1
	LDA #$13
	STA z87
	JSR Sub_00_97d8
	LDA #$16
	STA zPointer85
	LDA #$00
	STA zPointer85 + 1
	JMP @00_9548
@00_9540:
	LDA #$29
	STA zPointer85
	LDA #$00
	STA zPointer85 + 1
@00_9548:
	LDA #$b5
	STA zPointer83
	LDA #$05
	STA zPointer83 + 1
	LDA #$13
	STA z87
	JSR Sub_00_97cb
	JSR Sub_00_a771
@00_955a:
	LDA #$03
	STA zPointer83
	LDA #$00
	STA zPointer83 + 1
	LDA #$c8
	STA zPointer85
	LDA #$05
	STA zPointer85 + 1
	LDA #$13
	STA z87
	JSR Sub_00_97db
	JSR Sub_00_97a5
	LDA #$c8
	STA zPointer83
	LDA #$05
	STA zPointer83 + 1
	LDA #$21
	STA za4
	LDA #$a8
	STA za5
	LDA #$13
	STA za6
	LDA #$01
	JSR JMP_00_846b
	LDA #$16
	STA zPointer83
	LDA #$00
	STA zPointer83 + 1
	LDA #$c8
	STA zPointer85
	LDA #$05
	STA zPointer85 + 1
	LDA #$13
	STA z87
	JSR Sub_00_97db
	LDA $05cd
	BEQ @00_95fd
	JSR Sub_00_97a5
	LDA #$c8
	STA zPointer83
	LDA #$05
	STA zPointer83 + 1
	LDA #$21
	STA za4
	LDA #$e8
	STA za5
	LDA #$13
	STA za6
	LDA #$01
	JSR JMP_00_846b
	LDA #$29
	STA zPointer83
	LDA #$00
	STA zPointer83 + 1
	LDA #$c8
	STA zPointer85
	LDA #$05
	STA zPointer85 + 1
	LDA #$13
	STA z87
	JSR Sub_00_97db
	LDA $05cd
	BEQ @00_95fd
	JSR Sub_00_97a5
	LDA #$c8
	STA zPointer83
	LDA #$05
	STA zPointer83 + 1
	LDA #$22
	STA za4
	LDA #$28
	STA za5
	LDA #$13
	STA za6
	LDA #$01
	JSR JMP_00_846b
@00_95fd:
	LDA $054f
	BEQ @00_965f
	CMP #$03
	BNE @00_960b
	LDA #$60
	JMP @00_9616
@00_960b:
	CMP #$02
	BNE @00_9614
	LDA #$70
	JMP @00_9616
@00_9614:
	LDA #$80
@00_9616:
	STA $02ac
	LDA #$20
	STA $0294
	LDA #$07
	STA $027c
	LDA #$05
	STA $0264
	LDA #$14
	STA iCrunchCounter
@00_962d:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	DEC iCrunchCounter
	BNE @00_9652
	LDA #$14
	STA iCrunchCounter
	LDA $0264
	CMP #$ff
	BNE @00_964d
	LDA #$05
	STA $0264
	JMP @00_9652
@00_964d:
	LDA #$ff
	STA $0264
@00_9652:
	JSR Sub_07_d16e
	LDA iJoyHeld
	AND #$08
	BNE @00_966c
	JMP @00_962d
@00_965f:
	JSR Sub_00_806a
	JSR Sub_07_d16e
	LDA iJoyHeld
	AND #$08
	BEQ @00_965f
@00_966c:
	LDA #$04
	STA i248
	RTS

Data_00_9672:
	.db $20, $00, $20, $1e, $00
Data_00_9677:
	.db $20, $40, $20, $1a, $e5
Data_00_967c:
	.db $21, $24, $18, $01, $e1
Data_00_9681:
	.db $22, $64, $18, $01, $f1
Data_00_9686:
	.db $21, $43, $01, $09, $e3
Data_00_968b:
	.db $21, $5c, $01, $09, $e4
Data_00_9690:
	.db $21, $44, $18, $09, $00
Data_00_9695:
	.db $21, $23, $00, $e0, $21, $3c, $00, $e2, $22, $63, $00, $f0, $22
	.db $7c, $00, $f2, $20, $a6, $13, $34, $35, $e5, $e5, $3c, $3d, $3e
	.db $3f, $e5, $d6, $d7, $d8, $d9, $da, $db, $dc, $e5, $e5, $36, $37
	.db $20, $c6, $13, $44, $45, $e5, $e5, $4c, $4d, $4e, $4f, $e5, $e6
	.db $e7, $e8, $e9, $ea, $eb, $ec, $e5, $e5, $46, $47, $21, $0d, $00
	.db $d0, $21, $0f, $03, $97, $a7, $b7, $c7, $21, $13, $00, $d1, $21
	.db $a5, $02, $1c, $13, $14, $21, $e5, $02, $1d, $0e, $04, $22, $25
	.db $02, $1e, $12, $04, $21, $ed, $00, $26, $21, $f3, $00, $26, $21
	.db $fa, $00, $26, $22, $2d, $00, $26, $22, $33, $00, $26, $22, $3a
	.db $00, $26, $ff
Data_00_970d:
	.db $21, $0e, $00, $d2, $21, $69, $11, $13, $03, $1b, $12, $05, $00
	.db $0c, $05, $16, $05, $0c, $00, $00, $00, $05, $07, $07, $13, $22
	.db $a7, $02, $cd, $ce, $cf, $22, $c7, $02, $dd, $de, $df, $22, $e7
	.db $02, $ed, $ee, $ef, $23, $07, $02, $fd, $fe, $e5, $22, $f3, $01
	.db $3a, $3b, $23, $13, $01, $4a, $4b, $22, $b6, $02, $94, $95, $96
	.db $22, $d6, $02, $a4, $a5, $a6, $22, $f6, $02, $b4, $b5, $b6, $23
	.db $16, $02, $c4, $c5, $c6, $ff
Data_00_9761:
	.db $21, $0e, $00, $d3, $21, $69, $11, $13, $03, $1b, $12, $05, $00
	.db $0c, $05, $16, $05, $0c, $00, $00, $00, $14, $09, $0d, $05, $22
	.db $a8, $04, $98, $99, $9a, $9b, $9c, $22, $c8, $04, $a8, $a9, $aa
	.db $ab, $ac, $22, $e8, $04, $b8, $b9, $ba, $bb, $bc, $23, $08, $04
	.db $c8, $c9, $ca, $cb, $cc, $22, $f3, $01, $38, $39, $23, $13, $01
	.db $48, $49, $ff

Sub_00_97a5:
	LDX #$0a
	JSR @00_97be
	LDA $0520
	BNE @00_97bc
	LDX #$10
	JSR @00_97be
	BNE @00_97ca
	LDX #$11
	JSR @00_97be
	RTS
@00_97bc:
	LDX #$0e
@00_97be:
	LDA $05c8, X
	CMP #$1b
	BNE @00_97ca
	LDA #$00
	STA $05c8, X
@00_97ca:
	RTS

Sub_00_97cb:
	LDA zPointer85
	CLC
	ADC iStageNum
	STA zPointer85
	BCC @00_97d7
	INC zPointer85 + 1
@00_97d7:
	RTS

Sub_00_97d8:
	JSR Sub_00_97cb

Sub_00_97db:
	LDA iStageNum
	STA za6
	JSR Sub_00_84af
	JSR Sub_00_a771
	RTS

Sub_00_97e7:
	STA za3
	TXA
	TAY
	CLC
	ADC iCrunchCounter
	ADC iStageNum
	TAX
@00_97f3:
	LDA $05b5, Y
	CMP z03, X
	BNE @00_9800
	INY
	INX
	DEC za3
	BNE @00_97f3
@00_9800:
	RTS

Attr_00_9801:
.incbin "src/raw-data/attr-00-9801.bin"
Attr_00_9841:
.incbin "src/raw-data/attr-00-9841.bin"

Sub_00_9881:
	LDA #<Data_00_9898
	STA zPointer83
	LDA #>Data_00_9898
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_989d
	STA zPointerB7
	LDA #>Data_00_989d
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
	RTS

Data_00_9898:
	.db $28, $00, $20, $1e, $00

Data_00_989d:
	.db $29, $ce, $04, $10, $01, $15, $13, $05, $ff

Sub_00_98a6:
	LDA $0512
	ORA $0513
	ORA $051e
	ORA $051f
	ORA $050c
	ORA $050d
	BNE @00_990f
	LDA iJoyHeld
	AND #$08
	BEQ @00_990f
	LDA #$00
	STA $0260
	LDA #1 << CHAN_7 | 1 << CHAN_6 | 1 << CHAN_5 | 1 << CHAN_4
	STA iMusicTracks
	LDA #SFX_PAUSE
	JSR StoreMusicID
	LDA zPPUScrollX
	STA za3
	LDA zPPUScrollY
	STA za4
	LDA #$00
	STA zPPUScrollX
	; $2800 NT, h inc, obj 0, bg 1, 8x8 obj, read, NMI
	LDA #NMI | BG_TABLE | 2
	STA zPPUControl
	LDA #$00
	STA zPPUScrollY
@00_98e4:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_d16e
	LDA iJoyHeld
	AND #$08
	BEQ @00_98e4
	LDA za3
	STA zPPUScrollX
	LDA za4
	STA zPPUScrollY
	LDA zPlayerMode
	BNE @00_9905
	; $2000 NT, h inc, obj 0, bg 1, 8x8 obj, read, NMI
	LDA #NMI | BG_TABLE
	STA zPPUControl
@00_9905:
	LDA #$01
	STA $0260
	LDA #0
	STA iMusicTracks
@00_990f:
	RTS

FieldScene:
	JSR DisablePicture
	JSR DisableNMI
	LDA #$00
	STA zPPUScrollY
	JSR Sub_07_efd1
	JSR Sub_07_cdf0
	LDA #$00
	STA $0263
	LDX #$00
@00_9927:
	LDA #$07
	STA $0266, X
	LDA #$10
	STA $027e, X
	LDA Data_00_9bc6, X
	STA $0296, X
	LDA Data_00_9bc9, X
	STA $02ae, X
	INX
	CPX #$03
	BNE @00_9927
	LDA #CHR_MODE | PRG_L16 | MMC1_2MIRROR_V
	STA zMMC1Ctrl
	JSR WriteMapperControl
	JSR Sub_00_9dae
	LDA #CHR_Field_BG
	STA zMMC1Chr
	LDA #CHR_Field_OBJ
	STA zMMC1Chr + 1
	LDA #NAMETABLE_0
	STA PPUADDR
	LDA #0
	STA PPUADDR
	JSR LayoutFieldNametable
	LDA #NAMETABLE_1
	STA PPUADDR
	LDA #0
	STA PPUADDR
	JSR LayoutFieldNametable
	LDA $02df
	CMP #$1c
	BCC @00_9977
	LDA #$1b
@00_9977:
	STA iStageNum
	TAX
	LDA FieldSprites, X
	STA $027c
	LDA #$07
	STA $0264
	LDA #$a8
	STA $0294
	LDA #$9c
	STA $02ac
	LDX iStageNum
	LDA FieldSprites, X
	STA za3
	CLC
	ADC za3
	ADC za3
	TAX
	LDA Data_00_9e17, X
	INX
	STA i11d
	LDA Data_00_9e17, X
	INX
	STA i11d + 1
	LDA Data_00_9e17, X
	STA i11d + 2
	JSR CopyPPUControl
	JSR Sub_00_8061
	LDA #$00
	STA zPPUScrollX
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	LDA #$01
	STA $0552
	LDA #$02
	STA iCrunchCounter
	LDA #$00
	STA $054f
	LDA #$58
	STA $0550
@00_99d7:
	DEC iCrunchCounter
	BNE @00_99f0
	LDA #$02
	STA iCrunchCounter
	LDA $054f
	EOR z01
	STA $054f
	BNE @00_99f0
	LDA #SFX_WALK_SOFT
	JSR StoreMusicID
@00_99f0:
	LDA $054f
	BNE @00_9a03
	LDA #<YoshiWalkingFarviewGFX
	STA zPointer83
	LDA #>YoshiWalkingFarviewGFX
	STA zPointer83 + 1
	JSR Sub_00_9bcc
	JMP @00_9a0e
@00_9a03:
	LDA #<YoshiStandingFarviewGFX
	STA zPointer83
	LDA #>YoshiStandingFarviewGFX
	STA zPointer83 + 1
	JSR Sub_00_9bcc
@00_9a0e:
	DEC $0550
	BNE @00_99d7
	LDA #$00
	STA $0552
	LDA #<EmptyFarviewGFX
	STA zPointer83
	LDA #>EmptyFarviewGFX
	STA zPointer83 + 1
	JSR Sub_00_9bcc
	LDA #$28
	STA zb1
	JSR Sub_00_806a
	LDA #$96
	STA zPPUScrollX
	LDA #$32
	STA $0550
	LDA #$ff
	STA $0552
	LDA #$02
	STA iCrunchCounter
	LDA #$00
	STA $054f
@00_9a42:
	DEC iCrunchCounter
	BNE @00_9a5b
	LDA #$02
	STA iCrunchCounter
	LDA $054f
	EOR z01
	STA $054f
	BNE @00_9a5b
	LDA #SFX_WALK
	JSR StoreMusicID
@00_9a5b:
	LDA $054f
	BNE @00_9a6e
	LDA #<YoshiStandingGFX
	STA zPointer83
	LDA #>YoshiStandingGFX
	STA zPointer83 + 1
	JSR Sub_00_9bde
	JMP @00_9a79
@00_9a6e:
	LDA #<YoshiWalkingGFX
	STA zPointer83
	LDA #>YoshiWalkingGFX
	STA zPointer83 + 1
	JSR Sub_00_9bde
@00_9a79:
	DEC $0550
	BNE @00_9a42
	LDA #$00
	STA $0552
	LDA #<YoshiStandingGFX
	STA zPointer83
	LDA #>YoshiStandingGFX
	STA zPointer83 + 1
	JSR Sub_00_9bde
	JSR DoFieldText
	LDA #$1e
	STA zb1
	JSR Sub_00_806a
	LDA #<YoshiWindingUpGFX
	STA zPointer83
	LDA #>YoshiWindingUpGFX
	STA zPointer83 + 1
	JSR Sub_00_9bde
	LDA #$0a
	STA zb1
	JSR Sub_00_806a
	LDA #<YoshiEatingGFX
	STA zPointer83
	LDA #>YoshiEatingGFX
	STA zPointer83 + 1
	JSR Sub_00_9bde
	LDA #SFX_COLLECT_BONUS
	JSR StoreMusicID
	LDA #$05
	STA zb1
	JSR Sub_00_806a
	LDA #<YoshiTongueGFX
	STA zPointer83
	LDA #>YoshiTongueGFX
	STA zPointer83 + 1
	JSR Sub_00_9bf0
	LDA #$07
	STA $0265
	LDA #$0f
	STA $027d
	LDA #$a0
	STA $02ad
	LDA #$98
	STA $0295
	LDA #$08
	STA iCrunchCounter
@00_9ae5:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	INC $0295
	INC $0295
	DEC iCrunchCounter
	BNE @00_9ae5
	LDA #$08
	STA iCrunchCounter
@00_9afc:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	DEC $0294
	DEC $0294
	DEC $0295
	DEC $0295
	DEC iCrunchCounter
	BNE @00_9afc
	LDA #$ff
	STA $0265
	LDA #<YoshiNoTongueGFX
	STA zPointer83
	LDA #>YoshiNoTongueGFX
	STA zPointer83 + 1
	LDA #<Data_00_9322
	STA za4
	LDA #>Data_00_9322
	STA za5
	LDA #$03
	STA za6
	LDA #$01
	JSR JMP_00_846b
	LDA #<YoshiEatingGFX
	STA zPointer83
	LDA #>YoshiEatingGFX
	STA zPointer83 + 1
	JSR Sub_00_9bde
	LDA #$05
	STA zb1
	JSR Sub_00_806a
	LDA #$ff
	STA $0264
	LDA #<YoshiWindingUpGFX
	STA zPointer83
	LDA #>YoshiWindingUpGFX
	STA zPointer83 + 1
	JSR Sub_00_9bde
	LDA #$0a
	STA zb1
	JSR Sub_00_806a
	LDA #<YoshiStandingGFX
	STA zPointer83
	LDA #>YoshiStandingGFX
	STA zPointer83 + 1
	JSR Sub_00_9bde
	LDA #$08
	STA $0264
	LDX iStageNum
	LDA FieldSprites, X
	STA $027c
	LDA #$80
	STA $02ac
	LDA #$80
	STA $0294
	LDA #$10
	STA iCrunchCounter
@00_9b83:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	DEC $02ac
	DEC iCrunchCounter
	BNE @00_9b83
	LDA #<Data_00_9d38
	STA zPointer83
	LDA #>Data_00_9d38
	STA zPointer83 + 1
	LDX iStageNum
	LDA FieldSprites, X
	JSR Sub_00_8939
	JSR DoFieldText
	LDA #MUSIC_CURRENT_SCORE
	JSR StoreMusicID
@00_9bab:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	LDA iChannelID
	CMP #MUSIC_CURRENT_SCORE
	BEQ @00_9bab
	LDA #CHR_MODE | PRG_L16 | MMC1_2MIRROR_H
	STA zMMC1Ctrl
	JSR WriteMapperControl
	LDA #$04
	STA i248
	RTS

Data_00_9bc6:
	.db $48, $20, $d0

Data_00_9bc9:
	.db $b0, $d0, $c8

Sub_00_9bcc:
	LDA #$21
	STA za4
	LDA #$33
	STA za5
	LDA #$03
	STA za6
	LDA #$02
	JSR JMP_00_846b
	RTS

Sub_00_9bde:
	LDA #$22
	STA za4
	LDA #$0d
	STA za5
	LDA #$07
	STA za6
	LDA #$03
	JSR JMP_00_846b
	RTS

Sub_00_9bf0:
	LDA #$22
	STA za4
	LDA #$92
	STA za5
	LDA #$03
	STA za6
	LDA #$01
	JSR JMP_00_846b
	RTS

Sub_00_9c02:
	LDX #$14
@00_9c04:
	STA $0552, X
	DEX
	BNE @00_9c04
	RTS

.include "src/data/movie/field-bg.asm"

LayoutFieldNametable:
	LDA #res_vertical / 8
	STA zResolutionInMetatiles
	LDX #$00
@00_9d09:
	LDY #$20
@00_9d0b:
	LDA FieldBackgroundNametable, X
	STA PPUDATA
	DEY
	BNE @00_9d0b
	INX
	DEC zResolutionInMetatiles
	BNE @00_9d09
	RTS

FieldBackgroundNametable:
	.db $eb, $eb, $eb, $eb, $eb, $eb, $eb, $eb, $eb, $eb, $4f, $5f, $6f
	.db $7f, $8f, $9f, $af, $ea, $cf, $df, $ef, $ea, $ea, $ea, $ea, $ea
	.db $ea, $ea, $3c, $3c
Data_00_9d38:
	.db $00, $00, $05, $00, $00, $01, $00, $00, $00, $01, $05, $00, $00
	.db $02, $00, $00, $00, $02, $05, $00, $00, $03, $00, $00, $00, $04
	.db $00, $00, $00, $05, $00, $00, $00, $06, $00, $00, $00, $07, $00
	.db $00, $00, $08, $00, $00, $00, $09, $00, $00, $01, $00, $00, $00
	.db $01, $02, $00, $00, $01, $05, $00, $00

.include "src/data/movie/field-sprites.asm"

FieldScore:
	.db $f0, $f1, $f2, $f3, $f4 ; SCORE
	.db $eb, $eb, $eb, $eb, $eb ; @@@@@

FieldStats:
	.db $4e, $5e, $6e, $7e, $ea ; TIME@
	.db $e0, $e1, $e2, $e3, $e4 ; LEVEL
	.db $e5, $e6, $e7, $e8, $e9 ; SPEED
	.db $ea, $ea, $ea, $ea, $ea ; @@@@@

Sub_00_9dae:
	LDA #$05
	JSR Sub_07_d124
	LDA #<Attr_00_9dd7
	STA zPointer83
	LDA #>Attr_00_9dd7
	STA zPointer83 + 1
	JSR Sub_00_adc3
	LDA #$27
	STA PPUADDR
	LDA #$c0
	STA PPUADDR
	LDY #$40
	LDX #$00
@00_9dcc:
	LDA Attr_00_9dd7, X
	STA PPUDATA
	INX
	DEY
	BNE @00_9dcc
	RTS

Attr_00_9dd7:
.incbin "src/raw-data/attr-00-9dd7.bin"

Data_00_9e17:
	.db $16, $0f, $20, $29, $0f, $26, $16, $0f, $20, $16, $0f, $20, $38
	.db $0f, $20, $16, $0f, $20, $16, $0f, $20, $2a, $0f, $20, $24, $0f
	.db $20, $23, $0f, $20, $27, $0f, $00, $16, $0f, $20, $27, $0f, $20
	.db $26, $0f, $20, $16, $0f, $20

DoFieldText:
	LDA #<CongratsGFX
	STA zPointer83
	LDA #>CongratsGFX
	STA zPointer83 + 1
	LDA #$20
	STA za4
	LDA #$a8
	STA za5
	LDA #$10
	STA za6
	LDA #$01
	JSR JMP_00_846b
	LDA #<FieldScore
	STA zPointer83
	LDA #>FieldScore
	STA zPointer83 + 1
	LDA #$21
	STA za4
	LDA #$0a
	STA za5
	LDA #$05
	STA za6
	LDA #$01
	JSR JMP_00_846b
	LDA #<FieldStats
	STA zPointer83
	LDA #>FieldStats
	STA zPointer83 + 1
	LDA #$22
	STA za4
	LDA #$eb
	STA za5
	LDA #$05
	STA za6
	LDA #$02
	JSR JMP_00_846b
	LDA #$eb
	JSR Sub_00_9c02
	LDA $05ee
	CLC
	ADC #$f6
	STA $0553
	LDA $05ef
	CLC
	ADC #$f6
	STA $0554
	LDA $05f0
	CLC
	ADC #$f6
	STA $0555
	LDA $05f1
	CLC
	ADC #$f6
	STA $0556
	LDA $05f2
	CLC
	ADC #$f6
	STA $0557
	LDA $05f3
	CLC
	ADC #$f6
	STA $0558
	LDX #$00
@00_9ecc:
	LDA $0553, X
	CMP #$f6
	BNE @00_9edd
	LDA #$eb
	STA $0553, X
	INX
	CPX #$05
	BNE @00_9ecc
@00_9edd:
	LDA #$53
	STA zPointer83
	LDA #$05
	STA zPointer83 + 1
	LDA #$21
	STA za4
	LDA #$10
	STA za5
	LDA #$06
	STA za6
	LDA #$01
	JSR JMP_00_846b
	LDA #$ea
	JSR Sub_00_9c02
	LDA $02ee
	CLC
	ADC #$f6
	STA $0553
	LDA $02ed
	CLC
	ADC #$f6
	STA $0554
	LDA #$f5
	STA $0555
	LDA $02f0
	CLC
	ADC #$f6
	STA $0556
	LDA $02ef
	CLC
	ADC #$f6
	STA $0557
	LDA $02c5
	CLC
	ADC #$f6
	STA $055b
	LDA $02c4
	CLC
	ADC #$f6
	STA $055c
	LDA $0521
	BNE @00_9f4b
	LDX #$3d
	STX $055f
	INX
	STX $0560
	INX
	STX $0561
	JMP @00_9f5c
@00_9f4b:
	LDX #$bc
	STX $055e
	INX
	STX $055f
	INX
	STX $0560
	INX
	STX $0561
@00_9f5c:
	LDA $0553
	CMP #$f6
	BNE @00_9f68
	LDA #$ea
	STA $0553
@00_9f68:
	LDA $055b
	CMP #$f6
	BNE @00_9f74
	LDA #$ea
	STA $055b
@00_9f74:
	LDA #$53
	STA zPointer83
	LDA #$05
	STA zPointer83 + 1
	LDA #$22
	STA za4
	LDA #$f0
	STA za5
	LDA #$05
	STA za6
	LDA #$02
	JSR JMP_00_846b
	RTS

HandleMenus:
	LDA zPlayerMode
	BNE @2_player
	JSR DoMainMenu
	JMP @done
@2_player:
	JSR DoVSMenu
@done:
	INC i248
	RTS

DoMainMenu:
	JSR DisablePicture
	JSR DisableNMI
	LDA #CHR_Records
	STA zMMC1Chr
	LDA #CHR_Field_OBJ
	STA zMMC1Chr + 1
	JSR Sub_00_a206
	JSR Sub_00_9fbd
	JSR CopyPPUControl
	JSR Sub_00_8061
	JSR GetMenuBGM
	RTS

Sub_00_9fbd:
	LDA #$01
	JSR Sub_07_d124
	LDA #<Data_00_9fe9
	STA zPointer83
	LDA #>Data_00_9fe9
	STA zPointer83 + 1
	JSR Sub_00_adc3
	LDA #$00
	STA zPPUScrollX
	STA zPPUScrollY
	LDY #$07
	LDX #$03
	JSR Sub_07_e0d5
	LDY #$0a
	LDX #$03
	JSR Sub_07_e0d5
	LDY #$0c
	LDX #$03
	JSR Sub_07_e0d5
	RTS

Data_00_9fe9:
	.db $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55
	.db $55, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
Data_00_a003:
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

DoVSMenu:
	JSR DisablePicture
	JSR DisableNMI
	LDA #CHR_Records
	STA zMMC1Chr
	LDA #CHR_Field_OBJ
	STA zMMC1Chr + 1
	JSR Sub_00_a0ae
	JSR Sub_00_a049
	LDA #MUSIC_VS_MENU
	JSR StoreMusicID
	JSR CopyPPUControl
	JSR Sub_00_8061
	RTS

Sub_00_a049:
	LDA #$02
	JSR Sub_07_d124
	LDA #<Attr_00_a06e
	STA zPointer83
	LDA #>Attr_00_a06e
	STA zPointer83 + 1
	JSR Sub_00_adc3
	LDA #$00
	STA zPPUScrollX
	STA zPPUScrollY
	LDY #$07
	LDX #$01
	JSR Sub_07_e0d5
	LDY #$0c
	LDX #$01
	JSR Sub_07_e0d5
	RTS

Attr_00_a06e:
.incbin "src/raw-data/attr-00-a06e.bin"

Sub_00_a0ae:
	LDA #<Data_00_a35e
	STA zPointer83
	LDA #>Data_00_a35e
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_a1fc
	STA zPointer83
	LDA #>Data_00_a1fc
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_a201
	STA zPointer83
	LDA #>Data_00_a201
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_a0de
	STA zPointerB7
	LDA #>Data_00_a0de
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
	JSR Sub_07_db56
	RTS

Data_00_a0de:
	.db $21, $06, $01, $30, $31, $21, $26, $01, $40, $41, $21, $09, $0d
	.db $1c, $10, $0c, $01, $19, $05, $12, $00, $13, $05, $0c, $05, $03
	.db $14, $21, $66, $04, $0c, $05, $16, $05, $0c, $21, $4c, $0e, $ad
	.db $bf, $ae, $ad, $bf, $ae, $ad, $bf, $ae, $ad, $bf, $ae, $ad, $bf
	.db $ae, $21, $6c, $0e, $af, $1c, $af, $af, $1d, $af, $af, $1e, $af
	.db $af, $1f, $af, $af, $20, $af, $21, $8c, $0e, $bd, $bf, $be, $bd
	.db $bf, $be, $bd, $bf, $be, $bd, $bf, $be, $bd, $bf, $be, $21, $c6
	.db $12, $13, $10, $05, $05, $04, $00, $00, $00, $0c, $1b, $17, $00
	.db $00, $00, $00, $08, $09, $07, $08, $22, $46, $01, $32, $33, $22
	.db $66, $01, $42, $43, $22, $49, $0d, $1d, $10, $0c, $01, $19, $05
	.db $12, $00, $13, $05, $0c, $05, $03, $14, $22, $a6, $04, $0c, $05
	.db $16, $05, $0c, $22, $8c, $0e, $ad, $bf, $ae, $ad, $bf, $ae, $ad
	.db $bf, $ae, $ad, $bf, $ae, $ad, $bf, $ae, $22, $ac, $0e, $af, $1c
	.db $af, $af, $1d, $af, $af, $1e, $af, $af, $1f, $af, $af, $20, $af
	.db $22, $cc, $0e, $bd, $bf, $be, $bd, $bf, $be, $bd, $bf, $be, $bd
	.db $bf, $be, $bd, $bf, $be, $23, $06, $12, $13, $10, $05, $05, $04
	.db $00, $00, $00, $0c, $1b, $17, $00, $00, $00, $00, $08, $09, $07
	.db $08, $20, $8a, $0b, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $27, $fa
	.db $fb, $fc, $9f, $20, $aa, $0b, $29, $2a, $2b, $2c, $2d, $2e, $2f
	.db $27, $9d, $9e, $d4, $d5, $20, $22, $18, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $ff, $20, $89, $0e, $02, $00
Data_00_a1fc:
	.db $20, $e4, $18, $09, $00
Data_00_a201:
	.db $22, $24, $18, $09, $00

Sub_00_a206:
	LDA #<Data_00_a35e
	STA zPointer83
	LDA #>Data_00_a35e
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_a363
	STA zPointer83
	LDA #>Data_00_a363
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_a368
	STA zPointer83
	LDA #>Data_00_a368
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_a36d
	STA zPointer83
	LDA #>Data_00_a36d
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_a372
	STA zPointer83
	LDA #>Data_00_a372
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_a377
	STA zPointer83
	LDA #>Data_00_a377
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #<Data_00_a257
	STA zPointerB7
	LDA #>Data_00_a257
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
	JSR Sub_07_dba5
	RTS

Data_00_a257:
	.db $20, $67, $11, $b0, $b0, $50, $51, $52, $53, $54, $55, $56, $57
	.db $58, $59, $5a, $5b, $5c, $5d, $c2, $c3, $20, $87, $11, $b0, $b0
	.db $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6a, $6b, $6c
	.db $6d, $b0, $b0, $20, $a7, $11, $b0, $b0, $70, $71, $72, $73, $74
	.db $75, $76, $77, $78, $79, $7a, $7b, $7c, $7d, $b0, $b0, $20, $c7
	.db $11, $b0, $b0, $80, $81, $82, $83, $84, $85, $86, $87, $88, $89
	.db $8a, $8b, $8c, $8d, $b0, $b0, $20, $e7, $11, $b0, $b0, $b0, $b0
	.db $5e, $5f, $6e, $6f, $7e, $7f, $8e, $8f, $90, $91, $a0, $a1, $b0
	.db $b0, $21, $46, $0f, $07, $01, $0d, $05, $00, $00, $00, $00, $01
	.db $00, $00, $00, $00, $00, $00, $02, $21, $4f, $03, $97, $a7, $b7
	.db $c7, $21, $56, $03, $97, $a7, $b7, $c7, $21, $c6, $04, $0c, $05
	.db $16, $05, $0c, $21, $cc, $0e, $ad, $bf, $ae, $ad, $bf, $ae, $ad
	.db $bf, $ae, $ad, $bf, $ae, $ad, $bf, $ae, $21, $ec, $0e, $af, $1c
	.db $af, $af, $1d, $af, $af, $1e, $af, $af, $1f, $af, $af, $20, $af
	.db $22, $0c, $0e, $bd, $bf, $be, $bd, $bf, $be, $bd, $bf, $be, $bd
	.db $bf, $be, $bd, $bf, $be, $22, $86, $12, $13, $10, $05, $05, $04
	.db $00, $00, $00, $0c, $1b, $17, $00, $00, $00, $00, $08, $09, $07
	.db $08, $23, $06, $02, $02, $07, $0d, $23, $18, $02, $1b, $06, $06
	.db $20, $22, $18, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $ff
Data_00_a35e:
	.db $20, $40, $20, $1a, $27
Data_00_a363:
	.db $20, $87, $12, $04, $00
Data_00_a368:
	.db $21, $24, $18, $03, $00
Data_00_a36d:
	.db $21, $a4, $18, $05, $00
Data_00_a372:
	.db $22, $64, $18, $03, $00
Data_00_a377:
	.db $22, $e4, $18, $03, $00


JMP_00_a37c:
	LDA #$00
	STA i248
@00_a381:
	LDA #$01
	STA zb1
@00_a385:
	LDA zb1
	BNE @00_a385
	JSR Sub_07_d16e
	LDA i248
	ASL A
	TAX
	LDA Ptrs_00_a3a1, X
	STA zPointerAD
	LDA Ptrs_00_a3a1 + 1, X
	STA zPointerAD + 1
	JSR PointerJump
	JMP @00_a381

Ptrs_00_a3a1:
	.dw TitleScreen
	.dw JPT_07_f831
	.dw HandleMenus
	.dw JPT_07_dc10
	.dw JPT_00_ae16
	.dw JPT_00_b57c
	.dw Dummy_00_a3af

Dummy_00_a3af:
	RTS

Sub_00_a3b0:
	LDA #$91
	STA zPointerB7
	LDA #$00
	STA zPointerB7 + 1
	LDY #$00
	LDA (zPointer83), Y
	INY
	STA z91
	LDA (zPointer83), Y
	INY
	STA z92
	LDA (zPointer83), Y
	INY
	ORA #$80
	SEC
	SBC #$01
	STA z93
	LDA (zPointer83), Y
	INY
	TAX
	LDA (zPointer83), Y
	STA z94
	LDA #$ff
	STA z95
@00_a3da:
	PHX
	JSR Sub_07_cf7f
	PLX
	DEX
	BEQ @00_a3fa
	LDA #$91
	STA zPointerB7
	LDA #$00
	STA zPointerB7 + 1
	LDA z92
	CLC
	ADC #$20
	BCC @00_a3f5
	INC z91
@00_a3f5:
	STA z92
	JMP @00_a3da
@00_a3fa:
	RTS

Sub_00_a3fb:
	LDA $044f
	BNE Sub_00_a42e
	LDA $0440
	ASL A
	ASL A
	ASL A
	CLC
	ADC $0440
	ADC $0440
	ADC $0442
	ADC $0442
	TAX
	LDA Ptrs_00_a47a, X
	STA zPointer83
	LDA Ptrs_00_a47a + 1, X
	STA zPointer83 + 1
	LDA #$00
	STA zPointer85
	LDA #$03
	STA zPointer85 + 1
	LDA #$1b
	STA z87
	JSR Sub_00_a771
	RTS

Sub_00_a42e:
	LDA $0441
	ASL A
	ASL A
	ASL A
	CLC
	ADC $0441
	ADC $0441
	ADC $0443
	ADC $0443
	TAX
	LDA Ptrs_00_a45c, X
	STA zPointer83
	LDA Ptrs_00_a45c + 1, X
	STA zPointer83 + 1
	LDA #$1b
	STA zPointer85
	LDA #$03
	STA zPointer85 + 1
	LDA #$1b
	STA z87
	JSR Sub_00_a771
	RTS

Ptrs_00_a45c:
	.dw PTD_00_a62d
	.dw PTD_00_a648
	.dw PTD_00_a663
	.dw PTD_00_a4e9
	.dw PTD_00_a67e
	.dw PTD_00_a699
	.dw PTD_00_a6b4
	.dw PTD_00_a6cf
	.dw PTD_00_a570
	.dw PTD_00_a6ea
	.dw PTD_00_a705
	.dw PTD_00_a720
	.dw PTD_00_a73b
	.dw PTD_00_a5f7
	.dw PTD_00_a756

Ptrs_00_a47a:
	.dw PTD_00_a498
	.dw PTD_00_a4b3
	.dw PTD_00_a4ce
	.dw PTD_00_a4e9
	.dw PTD_00_a504
	.dw PTD_00_a51f
	.dw PTD_00_a53a
	.dw PTD_00_a555
	.dw PTD_00_a570
	.dw PTD_00_a58b
	.dw PTD_00_a5a6
	.dw PTD_00_a5c1
	.dw PTD_00_a5dc
	.dw PTD_00_a5f7
	.dw PTD_00_a612
PTD_00_a498:
	.db $23, $25, $26, $27, $28, $29, $2a, $2b, $8d, $8e, $00, $8d, $8e
	.db $00, $00, $2c, $2d, $2e, $2f, $30, $00, $00, $00, $00, $00, $00
	.db $00
PTD_00_a4b3:
	.db $23, $00, $31, $32, $33, $34, $35, $00, $8d, $8e, $00, $8d, $8e
	.db $00, $00, $00, $36, $37, $38, $00, $00, $00, $00, $00, $00, $00
	.db $00
PTD_00_a4ce:
	.db $23, $00, $00, $41, $42, $43, $00, $00, $8d, $8e, $00, $8d, $8e
	.db $00, $00, $00, $44, $45, $46, $00, $00, $00, $00, $00, $00, $00
	.db $00
PTD_00_a4e9:
	.db $23, $00, $39, $3a, $3b, $3c, $3d, $00, $8d, $8e, $00, $8d, $8e
	.db $00, $00, $00, $3e, $3f, $40, $00, $00, $00, $00, $00, $00, $00
	.db $00
PTD_00_a504:
	.db $23, $47, $48, $49, $4a, $4b, $4c, $4d, $8d, $8e, $00, $8d, $8e
	.db $00, $00, $4e, $4f, $50, $51, $52, $00, $00, $00, $00, $00, $00
	.db $00
PTD_00_a51f:
	.db $23, $00, $8d, $8e, $25, $26, $27, $28, $29, $2a, $2b, $8d, $8e
	.db $00, $00, $00, $00, $00, $2c, $2d, $2e, $2f, $30, $00, $00, $00
	.db $00
PTD_00_a53a:
	.db $23, $00, $8d, $8e, $00, $31, $32, $33, $34, $35, $00, $8d, $8e
	.db $00, $00, $00, $00, $00, $00, $36, $37, $38, $00, $00, $00, $00
	.db $00
PTD_00_a555:
	.db $23, $00, $8d, $8e, $00, $00, $41, $42, $43, $00, $00, $8d, $8e
	.db $00, $00, $00, $00, $00, $00, $44, $45, $46, $00, $00, $00, $00
	.db $00
PTD_00_a570:
	.db $23, $00, $8d, $8e, $00, $39, $3a, $3b, $3c, $3d, $00, $8d, $8e
	.db $00, $00, $00, $00, $00, $00, $3e, $3f, $40, $00, $00, $00, $00
	.db $00
PTD_00_a58b:
	.db $23, $00, $8d, $8e, $47, $48, $49, $4a, $4b, $4c, $4d, $8d, $8e
	.db $00, $00, $00, $00, $00, $4e, $4f, $50, $51, $52, $00, $00, $00
	.db $00
PTD_00_a5a6:
	.db $23, $00, $8d, $8e, $00, $8d, $8e, $25, $26, $27, $28, $29, $2a
	.db $2b, $00, $00, $00, $00, $00, $00, $00, $2c, $2d, $2e, $2f, $30
	.db $00
PTD_00_a5c1:
	.db $23, $00, $8d, $8e, $00, $8d, $8e, $00, $31, $32, $33, $34, $35
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $36, $37, $38, $00
	.db $00
PTD_00_a5dc:
	.db $23, $00, $8d, $8e, $00, $8d, $8e, $00, $00, $41, $42, $43, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $44, $45, $46, $00
	.db $00
PTD_00_a5f7:
	.db $23, $00, $8d, $8e, $00, $8d, $8e, $00, $39, $3a, $3b, $3c, $3d
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $3e, $3f, $40, $00
	.db $00
PTD_00_a612:
	.db $23, $00, $8d, $8e, $00, $8d, $8e, $47, $48, $49, $4a, $4b, $4c
	.db $4d, $00, $00, $00, $00, $00, $00, $00, $4e, $4f, $50, $51, $52
	.db $00
PTD_00_a62d:
	.db $23, $25, $26, $d9, $da, $db, $2a, $2b, $8d, $8e, $00, $8d, $8e
	.db $00, $00, $2c, $e9, $ea, $eb, $30, $00, $00, $00, $00, $00, $00
	.db $00
PTD_00_a648:
	.db $23, $00, $31, $dc, $dd, $de, $35, $00, $8d, $8e, $00, $8d, $8e
	.db $00, $00, $00, $ec, $ed, $ee, $00, $00, $00, $00, $00, $00, $00
	.db $00
PTD_00_a663:
	.db $23, $00, $00, $41, $42, $43, $00, $00, $8d, $8e, $00, $8d, $8e
	.db $00, $00, $00, $f9, $fa, $fb, $00, $00, $00, $00, $00, $00, $00
	.db $00
PTD_00_a67e:
	.db $23, $47, $48, $d6, $d7, $d8, $4c, $4d, $8d, $8e, $00, $8d, $8e
	.db $00, $00, $4e, $e6, $e7, $e8, $52, $00, $00, $00, $00, $00, $00
	.db $00
PTD_00_a699:
	.db $23, $00, $8d, $8e, $25, $26, $d9, $da, $db, $2a, $2b, $8d, $8e
	.db $00, $00, $00, $00, $00, $2c, $e9, $ea, $eb, $30, $00, $00, $00
	.db $00
PTD_00_a6b4:
	.db $23, $00, $8d, $8e, $00, $31, $dc, $dd, $de, $35, $00, $8d, $8e
	.db $00, $00, $00, $00, $00, $00, $ec, $ed, $ee, $00, $00, $00, $00
	.db $00
PTD_00_a6cf:
	.db $23, $00, $8d, $8e, $00, $00, $41, $42, $43, $00, $00, $8d, $8e
	.db $00, $00, $00, $00, $00, $00, $f9, $fa, $fb, $00, $00, $00, $00
	.db $00
PTD_00_a6ea:
	.db $23, $00, $8d, $8e, $47, $48, $d6, $d7, $d8, $4c, $4d, $8d, $8e
	.db $00, $00, $00, $00, $00, $4e, $e6, $e7, $e8, $52, $00, $00, $00
	.db $00
PTD_00_a705:
	.db $23, $00, $8d, $8e, $00, $8d, $8e, $25, $26, $d9, $da, $db, $2a
	.db $2b, $00, $00, $00, $00, $00, $00, $00, $2c, $e9, $ea, $eb, $30
	.db $00
PTD_00_a720:
	.db $23, $00, $8d, $8e, $00, $8d, $8e, $00, $31, $dc, $dd, $de, $35
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $ec, $ed, $ee, $00
	.db $00
PTD_00_a73b:
	.db $23, $00, $8d, $8e, $00, $8d, $8e, $00, $00, $41, $42, $43, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $f9, $fa, $fb, $00
	.db $00
PTD_00_a756:
	.db $23, $00, $8d, $8e, $00, $8d, $8e, $47, $48, $d6, $d7, $d8, $4c
	.db $4d, $00, $00, $00, $00, $00, $00, $00, $4e, $e6, $e7, $e8, $52
	.db $00

Sub_00_a771:
	LDY #$00
@00_a773:
	LDA (zPointer83), Y
	STA (zPointer85), Y
	INY
	CPY z87
	BNE @00_a773
	RTS

Sub_00_a77d:
	NOP
	JSR Sub_00_a7f5
	JSR Sub_00_a841
	JSR Sub_00_a865
	JSR Sub_00_a7a1
	JSR Sub_00_bc1d
	LDA $052d
	BNE @00_a798
	JSR Sub_00_a7bc
	JSR Sub_00_a7d8
@00_a798:
	INC $0437
	LDA #$00
	STA $052d
	RTS

Sub_00_a7a1:
	LDY #$00
	LDA z8a
	STA (zPointer8D), Y
	INY
	LDA z89
	STA (zPointer8D), Y
	INY
	LDA z8b
	STA (zPointer8D), Y
	INY
	LDA z90
	STA (zPointer8D), Y
	INY
	LDA z8f
	STA (zPointer8D), Y
	RTS

Sub_00_a7bc:
	LDA $0445
	CMP #$05
	BEQ @00_a7c8
	LDA #$00
	JMP @00_a7ca
@00_a7c8:
	LDA #$ff
@00_a7ca:
	STA z8b
	LDA z89
	SEC
	SBC #$20
	STA z89
	BCS @00_a7d7
	DEC z8a
@00_a7d7:
	RTS

Sub_00_a7d8:
	LDY #$05
	LDA $0445
	CMP #$02
	BEQ @00_a7f0
	LDA z8a
	STA (zPointer8D), Y
	INY
	LDA z89
	STA (zPointer8D), Y
	INY
	LDA z8b
	STA (zPointer8D), Y
	RTS
@00_a7f0:
	LDA #$00
	STA (zPointer8D), Y
	RTS

Sub_00_a7f5:
	LDA #$00
	STA z8a
	LDA $0445
	CLC
	ADC #$04
	STA z89
	ASL z89
	ASL z89
	ROL z8a
	ASL z89
	ROL z8a
	ASL z89
	ROL z8a
	ASL z89
	ROL z8a
	LDA z8a
	CLC
	ADC #$20
	STA z8a
	LDX $0444
	LDA Data_00_a839, X
	CLC

	ADC z89
	STA z89
	BCC @00_a829
	INC z8a
@00_a829:
	LDA z8a
	STA z90
	LDA z89
	CLC
	ADC #$20
	STA z8f
	BCC @00_a838
	INC z90
@00_a838:
	RTS

Data_00_a839:
	.db $03, $06, $09, $0c, $12, $15, $18, $1b

Sub_00_a841:
	LDX $0446
	CPX #$0a
	BCS @00_a84e
	LDA Data_00_a85b, X
	STA z8b
	RTS
@00_a84e:
	LDA $0446
	SEC
	SBC #$15
	TAX
	LDA Data_00_a863, X
	STA z8b
	RTS

Data_00_a85b:
	.db $b0, $53, $57, $5b, $5f, $63, $67, $b0

Data_00_a863:
	.db $7b, $7f

Sub_00_a865:
	LDA #$36
	STA zPointer8D
	LDA #$03
	STA zPointer8D + 1
	LDA $0444
	ASL A
	ASL A
	ASL A
	CLC
	ADC zPointer8D
	BCC @00_a87a
	INC zPointer8D + 1
@00_a87a:
	STA zPointer8D
	RTS

Sub_00_a87d:
	LDY #$00
	LDA $044f
	ASL A
	ASL A
	TAX
@00_a885:
	LDA $0462, X
	BEQ @00_a8a6
	LDA $045a, X
	BEQ @00_a8a6
	STA $0446
	STX $0444
	LDA $0452, X
	STA $0445
	PHX
	PHY
	JSR Sub_00_a77d
	PLY
	PLX
@00_a8a6:
	INX
	INY
	CPY #$04
	BNE @00_a885
	RTS

Sub_00_a8ad:
	LDA #$8f
	STA zPointerC7
	LDA #$04
	STA zPointerC7 + 1
	LDA $04e9
	ASL A
	ASL A
	ASL A
	CLC
	ADC $04e9
	STA za3
	LDA $04ea
	BEQ @00_a8ca
	LSR A
	SEC
	SBC #$01
@00_a8ca:
	CLC
	ADC za3
	ADC zPointerC7
	STA zPointerC7
	BCC @00_a8d5
	INC zPointerC7 + 1
@00_a8d5:
	STA zPointerC7
	RTS

Sub_00_a8d8:
	LDA $0446
	CMP #$05
	BCC @00_a8f7
	PHA
	LDA #$00
	STA $0446
	JSR @00_a8f7
	PLA
	CLC
	ADC #$10
	STA $0446
	LDA #$01
	STA $052d
	JMP Sub_00_a77d
@00_a8f7:
	LDA $0436
	CMP #$10
	BNE @00_a8ff
	RTS
@00_a8ff:
	JSR Sub_00_bc1d
	JSR Sub_00_a7f5
	JSR Sub_00_aa92
	JSR Sub_00_a915
	JSR Sub_00_aae7
	JSR Sub_00_aa9f
	INC $0436
	RTS

Sub_00_a915:
	LDA $0444
	BEQ @00_a957
	CMP #$04
	BEQ @00_a957
	SEC
	SBC #$01
	STA $04e9
	LDA $0445
	STA $04ea
	JSR Sub_00_a8ad
	LDY #$00
	LDA (zPointerC7), Y
	BEQ @00_a957
	CMP #$05
	BCS @00_a957
	LDA $0446
	BNE @00_a952
	LDA $0445
	CMP #$04
	BNE @00_a94d
	LDA #$f4
	STA $0438
	LDA #$85
	JMP @00_a9a0
@00_a94d:
	LDA #$85
	JMP @00_a99d
@00_a952:
	LDA #$87
	JMP @00_a99d
@00_a957:
	LDA $0446
	BNE @00_a98a
	LDA $0445
	CMP #$02
	BEQ @00_a972
	CMP #$04
	BEQ @00_a97d
	LDA #$00
	STA $0438
	STA $043c
	JMP @00_a9a6
@00_a972:
	LDA #$00
	STA $0438
	STA $043c
	JMP @00_a9a6
@00_a97d:
	LDA #$ff
	STA $0438
	LDA #$00
	STA $043c
	JMP @00_a9a6
@00_a98a:
	LDA $0445
	CMP #$04
	BNE @00_a99b
	LDA #$f3
	STA $0438
	LDA #$83
	JMP @00_a9a0
@00_a99b:
	LDA #$83
@00_a99d:
	STA $0438
@00_a9a0:
	CLC
	ADC #$01
	STA $043c
@00_a9a6:
	LDA $0444
	CMP #$03
	BEQ @00_a9ea
	CMP #$07
	BEQ @00_a9ea
	CLC
	ADC #$01
	STA $04e9
	LDA $0445
	STA $04ea
	JSR Sub_00_a8ad
	LDY #$00
	LDA (zPointerC7), Y
	BEQ @00_a9ea
	CMP #$05
	BCS @00_a9ea
	LDA $0446
	BNE @00_a9e5
	LDA $0445
	CMP #$04
	BNE @00_a9e0
	LDA #$f3
	STA $043b
	LDA #$83
	JMP @00_aa33
@00_a9e0:
	LDA #$83
	JMP @00_aa30
@00_a9e5:
	LDA #$87
	JMP @00_aa30
@00_a9ea:
	LDA $0446
	BNE @00_aa1d
	LDA $0445
	CMP #$02
	BEQ @00_aa05
	CMP #$04
	BEQ @00_aa10
	LDA #$00
	STA $043b
	STA $043f
	JMP @00_aa39
@00_aa05:
	LDA #$00
	STA $043b
	STA $043f
	JMP @00_aa39
@00_aa10:
	LDA #$ff
	STA $043b
	LDA #$00
	STA $043f
	JMP @00_aa39
@00_aa1d:
	LDA $0445
	CMP #$04
	BNE @00_aa2e
	LDA #$f4
	STA $043b
	LDA #$85
	JMP @00_aa33
@00_aa2e:
	LDA #$85
@00_aa30:
	STA $043b
@00_aa33:
	CLC
	ADC #$01
	STA $043f
@00_aa39:
	LDX $0446
	BEQ @00_aa56
	DEX
	LDA Data_00_aa8c, X
	STA $0439
	CLC
	ADC #$01
	STA $043a
	ADC #$01
	STA $043d
	ADC #$01
	STA $043e
	RTS
@00_aa56:
	LDA $0445
	CMP #$04
	BNE @00_aa7f
	CMP #$02
	BEQ @00_aa70
	STX $043d
	STX $043e
	LDX #$ff
	STX $0439
	STX $043a
	RTS
@00_aa70:
	STX $0439
	STX $043a
	LDX #$ff
	STX $043d
	STX $043e
	RTS
@00_aa7f:
	STX $0439
	STX $043a
	STX $043d
	STX $043e
	RTS

Data_00_aa8c:
	.db $6b, $6f, $73, $77, $7b, $7f

Sub_00_aa92:
	DEC z89
	BNE @00_aa98
	DEC z8a
@00_aa98:
	DEC z8f
	BNE @00_aa9e
	DEC z90
@00_aa9e:
	RTS

Sub_00_aa9f:
	LDY #$00
	LDX #$00
	LDA z8a
	STA (zPointer8D), Y
	INY
	LDA z89
	STA (zPointer8D), Y
	INY
	LDA $0438
	STA (zPointer8D), Y
	INY
	LDA $0439
	STA (zPointer8D), Y
	INY
	LDA $043a
	STA (zPointer8D), Y
	INY
	LDA $043b
	STA (zPointer8D), Y
	INY
	LDA z90
	STA (zPointer8D), Y
	INY
	LDA z8f
	STA (zPointer8D), Y
	INY
	LDA $043c
	STA (zPointer8D), Y
	INY
	LDA $043d
	STA (zPointer8D), Y
	INY
	LDA $043e
	STA (zPointer8D), Y
	INY
	LDA $043f
	STA (zPointer8D), Y
	RTS

Sub_00_aae7:
	LDA #$76
	STA zPointer8D
	LDA #$03
	STA zPointer8D + 1
	LDA $0436
	ASL A
	ASL A
	ASL A
	STA za3
	LDA $0436
	ASL A
	ASL A
	CLC
	ADC za3
	CLC
	ADC zPointer8D
	BCC @00_ab06
	INC zPointer8D + 1
@00_ab06:
	STA zPointer8D
	RTS

Sub_00_ab09:
	LDA $044d
	STA $04e9
	STA $0444
	LDA $044e
	STA $04ea
	STA $0445
	JSR Sub_00_a8ad
	LDY #$00
	LDA (zPointerC7), Y
	STA $0446
	JSR Sub_00_a8d8
	RTS

Sub_00_ab29:
	LDA $0436
	CMP #$10
	BNE @00_ab31
	RTS
@00_ab31:
	LDA $0514
	BNE @00_ab39
	JMP Sub_00_a8d8
@00_ab39:
	CMP #$03
	BNE @00_ab47
	DEC $0444
	JSR Sub_00_a8d8
	INC $0444
	RTS
@00_ab47:
	JSR Sub_00_a7f5
	JSR Sub_00_ab72
	JSR Sub_00_a915
	JSR Sub_00_ab97
	JSR Sub_00_aae7
	JSR Sub_00_aa9f
	INC $0436
	JSR Sub_00_bc1d
	LDA $0444
	BEQ @00_ab71
	CMP #$04
	BEQ @00_ab71
	DEC $0444
	JSR Sub_00_bc1d
	INC $0444
@00_ab71:
	RTS

Sub_00_ab72:
	DEC z89
	BNE @00_ab78
	DEC z8a
@00_ab78:
	DEC z8f
	BNE @00_ab7e
	DEC z90
@00_ab7e:
	LDA z89
	SEC
	SBC $0514
	BCS @00_ab88
	DEC z8a
@00_ab88:
	STA z89
	LDA z8f
	SEC
	SBC $0514
	BCS @00_ab94
	DEC z90
@00_ab94:
	STA z8f
	RTS

Sub_00_ab97:
	LDA $0446
	BEQ @00_abd1
	CMP #$05
	BCS @00_abd1
	LDA $0445
	CMP #$04
	BEQ @00_abbc
	LDA #$83
	STA $0438
	LDA #$85
	STA $043b
	LDA #$84
	STA $043c
	LDA #$86
	STA $043f
	RTS
@00_abbc:
	LDA #$f3
	STA $0438
	LDA #$f4
	STA $043b
	LDA #$84
	STA $043c
	LDA #$86
	STA $043f
	RTS
@00_abd1:
	LDA #$00
	STA $0438
	STA $043b
	STA $043c
	STA $043f
	RTS

Sub_00_abe0:
	LDA $0436
	CMP #$10
	BNE @00_abe8
	RTS
@00_abe8:
	LDA $0514
	BNE @00_abf0
	JMP Sub_00_a8d8
@00_abf0:
	CMP #$03
	BNE @00_abfe
	INC $0444
	JSR Sub_00_a8d8
	INC $0444
	RTS
@00_abfe:
	JSR Sub_00_a7f5
	JSR Sub_00_ac14
	JSR Sub_00_a915
	JSR Sub_00_ab97
	JSR Sub_00_aae7
	JSR Sub_00_aa9f
	INC $0436
	RTS

Sub_00_ac14:
	DEC z89
	BNE @00_ac1a
	DEC z8a
@00_ac1a:
	DEC z8f
	BNE @00_ac20
	DEC z90
@00_ac20:
	LDA z89
	CLC
	ADC $0514
	BCC @00_ac2a
	INC z8a
@00_ac2a:
	STA z89
	LDA z8f
	CLC
	ADC $0514
	BCC @00_ac36
	INC z90
@00_ac36:
	STA z8f
	RTS

Sub_00_ac39:
	LDA $0444
	ASL A
	ASL A
	ASL A
	STA $051a
	ASL A
	CLC
	ADC $051a
	STA $051a
	LDA $0444
	CMP #$04
	BCC @00_ac56
	LDA #$28
	JMP @00_ac58
@00_ac56:
	LDA #$10
@00_ac58:
	CLC
	ADC $051a
	STA $051a
	LDA $0445
	ASL A
	ASL A
	ASL A
	CLC
	ADC #$20
	STA $051b
	RTS

Sub_00_ac6c:
	LDX $0514
	DEX
	TXA
	CLC
	ADC $044f
	ADC $044f
	TAX
	LDA $0514
	CMP #$03
	BEQ @00_acaf
	CMP #$02
	BNE @00_ac87
	JSR @00_aca9
@00_ac87:
	JSR Sub_00_ac39
	LDA $051b
	STA $02ac, X
	LDY $0514
	LDA Data_00_acb5, Y
	CLC
	ADC $051a
	STA $0294, X
	LDA $0446
	STA $027c, X
	LDA #$00
	STA $0264, X
	RTS
@00_aca9:
	LDA #$ff
	STA $0263, X
	RTS
@00_acaf:
	LDA #$ff
	STA $0263, X
	RTS

Data_00_acb5:
	.db $00, $06, $12, $18

Sub_00_acb9:
	LDY #$00
	LDA (zPointerC7), Y
	INY
	STA zPointer83
	LDA (zPointerC7), Y
	INY
	STA zPointer83 + 1
	LDA (zPointerC7), Y
	INY
	STA za4
	LDA (zPointerC7), Y
	INY
	STA za5
	LDA (zPointerC7), Y
	INY
	STA za6
	LDA (zPointerC7), Y
	JMP JMP_00_846b

Sub_00_acd9:
	LDA $0548
	CMP #$01
	BEQ @00_acf6
	CMP #$02
	BEQ @00_ad04
	CMP #$03
	BEQ @00_ad12
	LDA #<Data_00_ad93
	STA zPointerC7
	LDA #>Data_00_ad93
	STA zPointerC7 + 1
	JSR Sub_00_acb9
	JMP @00_ad1e
@00_acf6:
	LDA #<Data_00_ad99
	STA zPointerC7
	LDA #>Data_00_ad99
	STA zPointerC7 + 1
	JSR Sub_00_acb9
	JMP @00_ad1e
@00_ad04:
	LDA #<Data_00_ad9f
	STA zPointerC7
	LDA #>Data_00_ad9f
	STA zPointerC7 + 1
	JSR Sub_00_acb9
	JMP @00_ad1e
@00_ad12:
	LDA #<Data_00_ada5
	STA zPointerC7
	LDA #>Data_00_ada5
	STA zPointerC7 + 1
	JSR Sub_00_acb9
	RTS
@00_ad1e:
	LDA $0549
	CMP #$01
	BEQ @00_ad3b
	CMP #$02
	BEQ @00_ad49
	CMP #$03
	BEQ @00_ad57
	LDA #<Data_00_adab
	STA zPointerC7
	LDA #>Data_00_adab
	STA zPointerC7 + 1
	JSR Sub_00_acb9
	JMP @00_ad62
@00_ad3b:
	LDA #<Data_00_adb1
	STA zPointerC7
	LDA #>Data_00_adb1
	STA zPointerC7 + 1
	JSR Sub_00_acb9
	JMP @00_ad62
@00_ad49:
	LDA #<Data_00_adb7
	STA zPointerC7
	LDA #>Data_00_adb7
	STA zPointerC7 + 1
	JSR Sub_00_acb9
	JMP @00_ad62
@00_ad57:
	LDA #<Data_00_adbd
	STA zPointerC7
	LDA #>Data_00_adbd
	STA zPointerC7 + 1
	JSR Sub_00_acb9
@00_ad62:
	RTS

Data_00_ad63:
	.db $89, $8a, $89, $8a, $89, $8a, $8b, $8c, $8b, $8c, $8b, $8c, $9e
	.db $9f, $89, $8a, $89, $8a, $ae, $af, $8b, $8c, $8b, $8c, $9e, $9f
	.db $9e, $9f, $89, $8a, $ae, $af, $ae, $af, $8b, $8c, $9e, $9f, $9e
	.db $9f, $9e, $9f, $ae, $af, $ae, $af, $ae, $af
Data_00_ad93:
	.db $63, $ad, $20, $42, $06, $01
Data_00_ad99:
	.db $6f, $ad, $20, $42, $06, $01
Data_00_ad9f:
	.db $7b, $ad, $20, $42, $06, $01
Data_00_ada5:
	.db $87, $ad, $20, $42, $06, $01
Data_00_adab:
	.db $63, $ad, $20, $58, $06, $01
Data_00_adb1:
	.db $6f, $ad, $20, $58, $06, $01
Data_00_adb7:
	.db $7b, $ad, $20, $58, $06, $01
Data_00_adbd:
	.db $87, $ad, $20, $58, $06, $01

Sub_00_adc3:
	LDA #$6a
	STA zPointer85
	LDA #$05
	STA zPointer85 + 1
	LDA #$40
	STA z87
	JSR Sub_00_a771
	RTS

Sub_00_add3:
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_d16e
	LDA iJoyHeld
	AND #$0f
	BEQ Sub_00_add3
	RTS

Sub_00_ade5:
	JSR Sub_00_84bb
	LDA $044f
	ASL A
	CLC
	ADC $044f
	TAX
	LDA $02cf, X
	SEC
	SBC #$1b
	STA za3
	ASL A
	ASL A
	ASL A
	CLC
	ADC za3
	CLC
	ADC za3
	LDY $044f
	STA $060d, Y
	LDA $02d0, X
	SEC
	SBC #$1b
	CLC
	ADC $060d, Y
	STA $060d, Y
	RTS

JPT_00_ae16:
	LDA #$00
	STA $0510
	STA $0511
	JSR Sub_00_afb0
	JSR Sub_00_b04f
	INC i248
Branch_00_ae27:
	RTS

Sub_00_ae28:
	LDA $050c
	BEQ Branch_00_ae27
	LDA #$00
	STA $050c
	STA $050d
	LDA zPlayerMode
	BNE @00_ae88
	JSR Sub_00_aee1
	JSR GetMainBGM
	LDA $0520
	BNE @00_ae4b
	JSR Sub_00_af7a
	JSR Sub_07_d9d3
	RTS
@00_ae4b:
	JSR Sub_00_af93
	JSR Sub_00_8864
	LDA #$00
	STA $0532
	STA $0533
	STA $0534
	STA $0535
	STA $0536
	STA $0537
	STA $0538
	STA $0539
	JSR Sub_07_d9d3
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_e449
	JSR Sub_07_efd1
	JSR Sub_00_8883
	JSR Sub_00_8fd4
	JSR Sub_00_9000
	JSR SetStartingGarbage
	RTS
@00_ae88:
	LDA #$00
	STA $053c
	STA $053d
	LDA #$01
	STA $0520
	JSR Sub_00_acd9
	JSR Sub_00_aee1
	JSR Sub_00_af34
	JSR Sub_00_aed2
	LDA #$00
	STA $044f
	JSR Sub_00_af93
	LDA #$01
	STA $044f
	JSR Sub_00_af93
	LDA #$01
	STA zb1
	JSR Sub_00_806a
	JSR Sub_07_e449
	JSR Sub_07_efd1
	LDA iDisableMusic
	BNE @00_aec8
	LDA #MUSIC_VS_MATCH
	JSR StoreMusicID
@00_aec8:
	JSR Sub_00_8883
	JSR SetStartingGarbage
	JSR Sub_00_b20c
	RTS

Sub_00_aed2:
	LDA #$00
	STA $053a
	STA $053b
	STA $053c
	STA $053d
	RTS

Sub_00_aee1:
	LDA #$00
	STA $044f
	LDA #$01
	STA $0440
	LDA #$00
	STA $0442
	JSR Sub_00_a3fb
	LDX #$00
@00_aef5:
	LDA #$14
	STA $0487, X
	LDA #$00
	STA $0462, X
	STA $045a, X
	STA $0452, X
	STA $0475, X
	INX
	CPX #$04
	BNE @00_aef5
	LDA #$00
	TAX
@00_af10:
	STA $048f, X
	INX
	CPX #$24
	BNE @00_af10
	LDA #$00
	STA $050a
	STA $0507
	STA $0505
	STA $050e
	STA $060c
	LDA #$02
	STA $0569
	LDA #$20
	STA $0568
	RTS

Sub_00_af34:
	LDA #$01
	STA $044f
	LDA #$01
	STA $0441
	LDA #$00
	STA $0443
	JSR Sub_00_a42e
	LDX #$04
@00_af48:
	LDA #$14
	STA $0487, X
	LDA #$00
	STA $0462, X
	STA $045a, X
	STA $0452, X
	STA $0475, X
	INX
	CPX #$08
	BNE @00_af48
	LDA #$00
	TAX
@00_af63:
	STA $04b3, X
	INX
	CPX #$24
	BNE @00_af63
	LDA #$00
	STA $050b
	STA $0508
	STA $0506
	STA $050f
	RTS

Sub_00_af7a:
	JSR Sub_07_d543
	JSR Sub_07_f0bc
	JSR Sub_07_f061
	JSR Sub_07_d582
	JSR Sub_07_f0bc
	JSR Sub_00_a87d
	LDA $0472
	STA $0613
	RTS

Sub_00_af93:
	LDA #$02
	STA $0474
	JSR Sub_07_d4e5
	JSR Sub_07_f0bc
	JSR Sub_07_f061
	JSR Sub_07_d517
	LDA #$02
	STA $0474
	JSR Sub_07_f0bc
	JSR Sub_00_a87d
	RTS

Sub_00_afb0:
	JSR DisablePicture
	JSR DisableNMI
	JSR InitNametable
	JSR InitNTAttributes
	JSR HideSprites
	JSR Sub_07_cdeb
	JSR InitSound
	LDA #CHR_VS_BG
	STA zMMC1Chr
	LDA #CHR_Field_OBJ
	STA zMMC1Chr + 1
	JSR Sub_00_9881
	LDA #$de
	STA iVirtualOAM
	LDA #$02
	STA $0701
	LDA #$00
	STA $0702
	LDA #$fe
	STA $0703
	LDA #$04
	STA $0262
	LDA #$01
	STA $0260
	LDA zPlayerMode
	BNE @00_b02a
	LDA #$08
	STA zPPUScrollY
	LDA #$c8
	STA zPPUScrollX
	LDX #$15
	LDA #$06
	STA $0264, X
	LDA #$03
	STA $027c, X
	LDA #$8b
	STA $0294, X
	LDA #$90
	STA $02ac, X
	JSR Sub_00_b058
	JSR Sub_00_b197
	JSR Sub_00_b1da
	JSR Sub_00_b070
	LDA #$02
	STA $0544
	JSR Sub_07_f750
	JSR Sub_00_b4d0
	JMP @00_b048
@00_b02a:
	LDA #$00
	STA zPPUScrollY
	STA zPPUScrollX
	; $2800 NT, h inc, obj 0, bg 1, 8x8 obj, read, NMI
	LDA #NMI | BG_TABLE | 2
	STA iPPUControl
	LDA #$e8
	STA zPPUScrollY
	JSR Sub_00_b064
	JSR Sub_00_b197
	JSR Sub_00_b1ae
	JSR Sub_00_b0fd
	JSR Sub_00_b52b
@00_b048:
	JSR CopyPPUControl
	JSR Sub_00_8061
	RTS

Sub_00_b04f:
	LDA #$01
	STA $050c
	STA $050d
	RTS

Sub_00_b058:
	LDA #<Data_00_b1d0
	STA zPointer83
	LDA #>Data_00_b1d0
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	RTS

Sub_00_b064:
	LDA #<Data_00_b1d5
	STA zPointer83
	LDA #>Data_00_b1d5
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	RTS

Sub_00_b070:
	LDA #$73
	STA zPointerB7
	LDA #$b3
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
	LDA $0521
	BNE @00_b08e
	LDA #<Data_00_b4a3
	STA zPointerB7
	LDA #>Data_00_b4a3
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
	JMP @00_b099
@00_b08e:
	LDA #<Data_00_b4aa
	STA zPointerB7
	LDA #>Data_00_b4aa
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
@00_b099:
	LDA $0520
	BEQ @00_b0b7
	LDA #$7b
	STA zPointerB7
	LDA #$b4
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
	LDA #<Data_00_b0d7
	STA zPointerB7
	LDA #>Data_00_b0d7
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
	JMP JMP_00_b0c2
@00_b0b7:
	LDA #<Data_00_b0ce
	STA zPointerB7
	LDA #>Data_00_b0ce
	STA zPointerB7 + 1
	JSR Sub_07_cf7f


JMP_00_b0c2:
	LDA #<Data_00_b0e0
	STA zPointerB7
	LDA #>Data_00_b0e0
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
	RTS

Data_00_b0ce:
	.db $20, $db, $04, $01, $14, $0f, $10, $05, $ff
Data_00_b0d7:
	.db $20, $db, $04, $97, $14, $0f, $10, $05, $ff
Data_00_b0e0:
	.db $20, $ba, $05, $d0, $b6, $b6, $b6, $b6, $b6, $20, $fa, $05, $f7
	.db $fc, $fc, $fc, $fc, $fc, $20, $a0, $42, $f6, $c6, $f8, $20, $da
	.db $40, $f5, $ff

Sub_00_b0fd:
	LDA #$4f
	STA zPointerB7
	LDA #$b2
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
	LDX #$16
	LDA #$03
	STA $0264, X
	LDA #$0c
	STA $027c, X
	LDA #$6c
	STA $0294, X
	LDA #$10
	STA $02ac, X
	LDA $0521
	BNE @00_b131
	LDA #$b2
	STA zPointerB7
	LDA #$b4
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
	JMP @00_b13c
@00_b131:
	LDA #$b9
	STA zPointerB7
	LDA #$b4
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
@00_b13c:
	LDA $0522
	BNE @00_b14f
	LDA #$c1
	STA zPointerB7
	LDA #$b4
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
	JMP @00_b15a
@00_b14f:
	LDA #$c8
	STA zPointerB7
	LDA #$b4
	STA zPointerB7 + 1
	JSR Sub_07_cf7f
@00_b15a:
	LDA #$20
	JSR Sub_07_d05d
	LDA #$4c
	JSR Sub_07_d05d
	LDA #$00
	JSR Sub_07_d05d
	LDA $02df
	CLC
	ADC #$1c
	JSR Sub_07_d05d
	JSR Sub_07_d065
	JSR Sub_07_cf7f
	LDA #$20
	JSR Sub_07_d05d
	LDA #$53
	JSR Sub_07_d05d
	LDA #$00
	JSR Sub_07_d05d
	LDA $02e0
	CLC
	ADC #$1c
	JSR Sub_07_d05d
	JSR Sub_07_d065
	JSR Sub_07_cf7f
	RTS

Sub_00_b197:
	LDA #$1d
	STA zPointer83
	LDA #$b2
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #$2c
	STA zPointer83
	LDA #$b2
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	RTS

Sub_00_b1ae:
	LDA #$22
	STA zPointer83
	LDA #$b2
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #$27
	STA zPointer83
	LDA #$b2
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #$31
	STA zPointer83
	LDA #$b2
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	RTS

Data_00_b1d0:
	.db $20, $60, $20, $1a, $fd
Data_00_b1d5:
	.db $20, $20, $20, $1a, $fd

Sub_00_b1da:
	LDA #$36
	STA zPointer83
	LDA #$b2
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA $0520
	BEQ @00_b1f5
	LDA #$3b
	STA zPointer83
	LDA #$b2
	STA zPointer83 + 1
	JSR Sub_00_a3b0
@00_b1f5:
	LDA #$40
	STA zPointer83
	LDA #$b2
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	LDA #$45
	STA zPointer83
	LDA #$b2
	STA zPointer83 + 1
	JSR Sub_00_a3b0
	RTS

Sub_00_b20c:
	LDA #$00
	STA $044f
	JSR Sub_00_84bb
	LDA #$01
	STA $044f
	JSR Sub_00_84bb
	RTS

Data_00_b21d:
	.db $20, $c2, $0d, $14, $00, $20, $d1, $0d, $14, $00, $20, $02, $1c
	.db $04, $00, $21, $02, $0d, $01, $ff, $21, $11, $0d, $01, $ff, $20
	.db $d1, $06, $02, $00, $21, $71, $06, $02, $00, $22, $51, $06, $08
	.db $00, $22, $7b, $05, $07, $00, $22, $60, $01, $07, $00, $20, $2c
	.db $07, $00, $ef, $00, $00, $00, $00, $df, $00, $20, $4c, $07, $00
	.db $ef, $00, $00, $00, $00, $df, $00, $20, $6c, $07, $00, $ef, $00
	.db $00, $00, $00, $df, $00, $20, $a1, $0e, $02, $06, $06, $06, $06
	.db $06, $06, $06, $06, $06, $06, $06, $06, $06, $0a, $23, $41, $0e
	.db $11, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18
	.db $18, $19, $20, $af, $55, $0a, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	.db $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	.db $19, $20, $a1, $55, $02, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b
	.db $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $11
	.db $20, $b0, $0e, $02, $06, $06, $06, $06, $06, $06, $06, $06, $06
	.db $06, $06, $06, $06, $0a, $23, $50, $0e, $11, $18, $18, $18, $18
	.db $18, $18, $18, $18, $18, $18, $18, $18, $18, $19, $20, $be, $55
	.db $0a, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	.db $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $19, $20, $b0, $55, $02
	.db $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b
	.db $0b, $0b, $0b, $0b, $0b, $0b, $0b, $11, $20, $81, $0a, $f7, $fc
	.db $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $20, $8c, $12, $fc
	.db $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc
	.db $fc, $fc, $fc, $fc, $f8, $20, $00, $0b, $fd, $d0, $b6, $b6, $b6
	.db $b6, $b6, $b6, $b6, $b6, $b6, $b6, $20, $0c, $13, $b6, $b6, $b6
	.db $b6, $b6, $b6, $b6, $b6, $b6, $b6, $b6, $b6, $b6, $b6, $b6, $b6
	.db $b6, $b6, $f6, $fd, $20, $21, $42, $f5, $f5, $f5, $20, $3e, $42
	.db $c6, $c6, $c6, $ff, $20, $d1, $04, $13, $03, $1b, $12, $05, $22
	.db $7b, $04, $0c, $05, $16, $05, $0c, $23, $1b, $04, $13, $10, $05
	.db $05, $04, $20, $b0, $07, $d0, $b6, $b6, $b6, $b6, $b6, $b6, $f6
	.db $21, $10, $07, $f7, $fc, $fc, $fc, $fc, $fc, $fc, $f8, $20, $d7
	.db $41, $c6, $c6, $20, $d0, $41, $f5, $f5, $22, $30, $07, $d0, $b6
	.db $b6, $b6, $b6, $b6, $b6, $f6, $23, $50, $07, $f7, $fc, $fc, $fc
	.db $fc, $fc, $fc, $f8, $22, $57, $47, $c6, $c6, $c6, $c6, $c6, $c6
	.db $c6, $c6, $22, $50, $47, $f5, $f5, $f5, $f5, $f5, $f5, $f5, $f5
	.db $22, $5a, $05, $d0, $b6, $b6, $b6, $b6, $b6, $22, $fa, $05, $d0
	.db $b6, $b6, $b6, $b6, $b6, $22, $ba, $05, $f7, $fc, $fc, $fc, $fc
	.db $fc, $23, $5a, $05, $f7, $fc, $fc, $fc, $fc, $fc, $22, $7a, $46
	.db $f5, $f5, $f7, $fd, $d0, $f5, $f5, $22, $60, $46, $c6, $c6, $c6
	.db $fd, $c6, $c6, $c6, $22, $da, $05, $fd, $fd, $fd, $fd, $fd, $fd
	.db $22, $40, $00, $f6, $22, $e0, $00, $f6, $22, $a0, $00, $f8, $23
	.db $40, $00, $f8, $20, $a1, $0e, $02, $06, $06, $06, $06, $06, $06
	.db $06, $06, $06, $06, $06, $06, $06, $0a, $23, $41, $0e, $11, $18
	.db $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $19
	.db $20, $c1, $53, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b
	.db $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $20, $cf, $53
	.db $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	.db $0e, $0e, $0e, $0e, $0e, $0e, $0e, $ff, $21, $71, $03, $14, $09
	.db $0d, $05, $21, $50, $07, $d0, $b6, $b6, $b6, $b6, $b6, $b6, $f6
	.db $21, $b0, $07, $f7, $fc, $fc, $fc, $fc, $fc, $fc, $f8, $21, $77
	.db $41, $c6, $c6, $21, $70, $41, $f5, $f5, $ff
Data_00_b4a3:
	.db $23, $3c, $02, $0c, $1b, $17, $ff
Data_00_b4aa:
	.db $23, $3c, $03, $08, $09, $07, $08, $ff, $20, $6a
	.db $02, $0c, $1b, $17, $ff, $20, $69, $03, $08, $09, $07, $08, $ff
	.db $20, $73, $02, $0c, $1b, $17, $ff, $20, $73, $03, $08, $09, $07
	.db $08, $ff

Sub_00_b4d0:
	LDA $0520
	BNE @00_b4da
	LDA #$03
	JMP @00_b4dc
@00_b4da:
	LDA #$07
@00_b4dc:
	JSR Sub_07_d124
	LDA #$eb
	STA zPointer83
	LDA #$b4
	STA zPointer83 + 1
	JSR Sub_00_adc3
	RTS

Data_00_b4eb:
	.db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3f, $0f, $0f, $ff, $ff
	.db $ff, $ff, $ff, $33, $00, $00, $ff, $ff, $ff, $ff, $ff, $33, $00
	.db $00, $ff, $ff, $ff, $ff, $ff, $33, $00, $00, $ff, $ff, $ff, $ff
	.db $ff, $33, $00, $00, $ff, $ff, $ff, $ff, $ff, $f3, $f0, $f0, $fc
	.db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

Sub_00_b52b:
	LDA #$04
	JSR Sub_07_d124
	LDA #$3c
	STA zPointer83
	LDA #$b5
	STA zPointer83 + 1
	JSR Sub_00_adc3
	RTS

Data_00_b53c:
	.db $7f, $5f, $ff, $cf, $3f, $ff, $5f, $df, $3f, $0f, $0f, $ff, $ff
	.db $0f, $0f, $cf, $33, $00, $00, $ff, $ff, $00, $00, $cc, $33, $00
	.db $00, $ff, $ff, $00, $00, $cc, $33, $00, $00, $ff, $ff, $00, $00
	.db $cc, $33, $00, $00, $ff, $ff, $00, $00, $cc, $f3, $f0, $f0, $fc
	.db $f7, $f5, $f5, $fd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

JPT_00_b57c:
	JSR Sub_00_b601
	JSR Sub_07_efd1
	JSR Sub_00_98a6
	JSR Sub_00_ae28
	JSR Sub_00_b6b0
	JSR Sub_00_b69e
	JSR Sub_00_b68c
	JSR Sub_07_f65a
	JSR Sub_00_b6de
	JSR Sub_00_b5ef
	JSR Sub_00_b64e
	JSR Sub_00_b60a
	JSR Sub_00_8883
	JSR Sub_00_bcb3
	LDA zPlayerMode
	BEQ @00_b5c2
	JSR Sub_00_b6c7
	JSR Sub_00_b6a7
	JSR Sub_00_b695
	JSR Sub_07_f663
	JSR Sub_00_b6fa
	JSR Sub_00_b5f8
	JSR Sub_00_b657
	JSR Sub_00_b613
@00_b5c2:
	JSR Sub_07_db21
	JSR Sub_00_9000
	JSR Sub_00_b5d2
	JSR Sub_00_80cb
	JSR Sub_07_e449
Branch_00_b5d1:
	RTS

Sub_00_b5d2:
	LDA $0512
	BNE Branch_00_b5d1
	DEC $0568
	LDA $0568
	BNE Branch_00_b5d1
	LDA #$20
	STA $0568
	LDA $0569
	EOR #$01
	STA $0569
	STA zMMC1Chr
	RTS

Sub_00_b5ef:
	LDA #$00
	STA $044f
	JSR Sub_07_d9f6
	RTS

Sub_00_b5f8:
	LDA #$01
	STA $044f
	JSR Sub_07_d9f6
	RTS

Sub_00_b601:
	LDA #$00
	STA $0436
	STA $0437
	RTS

Sub_00_b60a:
	LDA #$00
	STA $044f
	JSR Sub_00_b61c
	RTS

Sub_00_b613:
	LDA #$01
	STA $044f
	JSR Sub_00_b61c
	RTS

Sub_00_b61c:
	LDY $044f
	BNE Branch_00_b5d1
	LDA $051e
	BEQ Branch_00_b5d1
	LDA zPlayerMode
	BEQ @00_b634
	LDA iJoyCurrent
	CMP #BTN_START
	BNE Branch_00_b5d1
	JSR Sub_00_8fd4
@00_b634:
	JSR Sub_00_8415
	LDA #$00
	STA $0512
	STA $0513
	STA $051e
	STA $051f
	LDA #$01
	STA $0510
	STA $0511
	RTS

Sub_00_b64e:
	LDA #$00
	STA $044f
	JSR Sub_00_b660
	RTS

Sub_00_b657:
	LDA #$01
	STA $044f
	JSR Sub_00_b660
	RTS

Sub_00_b660:
	LDY $044f
	BNE @00_b68b
	LDA $0512
	BEQ @00_b68b
	LDA zPlayerMode
	BEQ @00_b678
	LDA iJoyCurrent
	CMP #BTN_START
	BNE @00_b68b
	JSR Sub_00_8fd4
@00_b678:
	JSR Sub_00_8415
	LDA #$00
	STA $0512
	STA $0513
	LDA #$01
	STA $0510
	STA $0511
@00_b68b:
	RTS

Sub_00_b68c:
	LDA #$00
	STA $044f
	JSR Sub_07_f2e0
	RTS

Sub_00_b695:
	LDA #$01
	STA $044f
	JSR Sub_07_f2e0
	RTS

Sub_00_b69e:
	LDA #$00
	STA $044f
	JSR Sub_07_f272
	RTS

Sub_00_b6a7:
	LDA #$01
	STA $044f
	JSR Sub_07_f272
Branch_00_b6af:
	RTS

Sub_00_b6b0:
	LDA $0510
	ORA $050e
	ORA $0512
	ORA $051e
	BNE Branch_00_b6af
	LDA #$00
	STA $044f
	JSR Sub_00_ba5d
	RTS

Sub_00_b6c7:
	LDA $0511
	ORA $050f
	ORA $0513
	ORA $051f
	BNE Branch_00_b6af
	LDA #$01
	STA $044f
	JSR Sub_00_ba5d
	RTS

Sub_00_b6de:
	LDA $0510
	ORA $0512
	ORA $051e
	BNE Branch_00_b6af
	LDA #$00
	STA $044f
	JSR HandleInGameInput
	LDA $0523
	BNE Branch_00_b6af
	JSR Sub_00_b800
	RTS

Sub_00_b6fa:
	LDA $0511
	ORA $0513
	ORA $051f
	BNE Branch_00_b6af
	LDA #$01
	STA $044f
	JSR HandleInGameInput
	LDA $0524
	BNE Branch_00_b6af
	JSR Sub_00_b800
	RTS
; unreferenced
	LDA #$80
	STA PPUSCROLL
	STA PPUSCROLL
	LDX #$05
@00_b720:
	DEX
	BNE @00_b720
	LDA zPPUScrollX
	STA PPUSCROLL
	STA PPUSCROLL
	RTS

HandleInGameInput:
	LDX $044f
	LDA iJoyHeld, X
	AND #$40
	BEQ @00_b739
	JSR @00_b78f
@00_b739:
	LDX $044f
	LDA iJoyHeld, X
	AND #$80
	BEQ @00_b746
	JSR @00_b7a3
@00_b746:
	LDX $044f
	LDA iJoyHeld, X
	AND #$01
	BNE @00_b766
	LDA iJoyHeld, X
	AND #$02
	BNE @00_b766
	LDA iJoyHeld, X
	AND #$10
	BNE @00_b7b9
	LDA iJoyCurrent, X
	AND #BTN_DOWN
	BNE @00_b7ba
@00_b765:
	RTS
@00_b766:
	LDX $044f
	LDA $050e, X
	ORA $0523, X
	BNE @00_b765
	LDA $0440, X
	STA $04fd, X
	LDA $044f
	BEQ @00_b785
	LDA #$04
	CLC
	ADC $04fd, X
	STA $04fd, X
@00_b785:
	JSR Sub_07_f600
	LDX $044f
	JSR SwapColumns
	RTS
@00_b78f:
	LDX $044f
	LDA $0440, X
	BEQ @00_b765
	LDA #SFX_SWITCH_COLUMN
	JSR StoreMusicID
	DEC $0440, X
	JSR Sub_00_a3fb
	RTS
@00_b7a3:
	LDX $044f
	LDA $0440, X
	CMP #$02
	BEQ @00_b765
	LDA #SFX_SWITCH_COLUMN
	JSR StoreMusicID
	INC $0440, X
	JSR Sub_00_a3fb
	RTS
@00_b7b9:
	RTS
@00_b7ba:
	LDX $044f
	LDA $0523, X
	ORA $050e, X
	BNE @00_b765
	LDA $044f
	BNE @00_b7e5
	LDX #$00
@00_b7cc:
	LDA $0462, X
	CMP #$02
	BNE @00_b7df
	LDA $046a, X
	CMP #$03
	BCC @00_b7df
	LDA #$02
	STA $046a, X
@00_b7df:
	INX
	CPX #$04
	BNE @00_b7cc
	RTS
@00_b7e5:
	LDX #$04
@00_b7e7:
	LDA $0462, X
	CMP #$02
	BNE @00_b7fa
	LDA $046a, X
	CMP #$03
	BCC @00_b7fa
	LDA #$02
	STA $046a, X
@00_b7fa:
	INX
	CPX #$08
	BNE @00_b7e7
	RTS

Sub_00_b800:
	LDA $044f
	ASL A
	ASL A
	STA $0451
	JSR Sub_00_b8cc
	INC $0451
	JSR Sub_00_b8cc
	INC $0451
	JSR Sub_00_b8cc
	INC $0451
	JSR Sub_00_b8cc
	LDX $044f
	LDA $0512, X
	ORA $050c
	ORA $050d
	ORA $0510
	ORA $0511
	BNE @00_b834
	JSR @00_b835
@00_b834:
	RTS
@00_b835:
	LDA $044f
	LDY #$04
	ASL A
	ASL A
	TAX
@00_b83d:
	LDA $0462, X
	BNE @00_b834
	INX
	DEY
	BNE @00_b83d
	JSR Sub_07_f061
	LDA $0520
	BNE @00_b865
	JSR Sub_07_d582
	JSR Sub_07_f0bc
	LDA $0613
	STA za3
	LDA $0472
	STA $0613
	LDA za3
	STA $0472
	RTS
@00_b865:
	LDA zPlayerMode
	BEQ @00_b86f
	JSR HandleGarbage
	JMP @00_b874
@00_b86f:
	LDA #$02
	STA $0474
@00_b874:
	JSR Sub_07_d517
	JSR Sub_07_f0bc
	JSR Sub_00_84bb
	LDA $044f
	ASL A
	CLC
	ADC $044f
	TAX
	LDA $02cf, X
	CMP #$1b
	BNE @00_b834
	LDA $02d0, X
	CMP #$1b
	BNE @00_b834
	JSR StageIsClear
	RTS

HandleGarbage:
	LDA $044f
	EOR #$01
	TAX
	LDA $053c, X
	BEQ @00_b8c6
	CMP #$01
	BEQ @00_b8b8
	DEC $053c, X
	DEC $053c, X
	LDA #$04
	STA $0474
	LDA #SFX_GARBAGE
	JSR StoreMusicID
	RTS
@00_b8b8:
	DEC $053c, X
	LDA #$03
	STA $0474
	LDA #SFX_GARBAGE
	JSR StoreMusicID
	RTS
@00_b8c6:
	LDA #$02
	STA $0474
	RTS

Sub_00_b8cc:
	LDX $0451
	LDY $044f
	LDA $0462, X
	BEQ @00_b908
	CMP #$01
	BEQ @00_b909
	LDA $050e, Y
	BEQ @00_b8e7
	LDA $046a, X
	CMP #$01
	BEQ @00_b908
@00_b8e7:
	DEC $046a, X
	BNE @00_b908
	LDA $0472, Y
	CMP #$01
	BNE @00_b8ff
	LDA $0452, X
	CMP #$04
	BCS @00_b8ff
	LDA #$02
	JMP @00_b902
@00_b8ff:
	LDA $0472, Y
@00_b902:
	STA $046a, X
	JSR CollisionLogic
@00_b908:
	RTS
@00_b909:
	LDA $050e, Y
	BEQ @00_b915
	LDA $046a, X
	CMP #$01
	BEQ @00_b908
@00_b915:
	DEC $046a, X
	LDA $046a, X
	BEQ @00_b925
	CMP #$26
	BNE @00_b924
	JSR Sub_00_a87d
@00_b924:
	RTS
@00_b925:
	LDA #$01
	STA $046a, X
	LDA #$02
	STA $0462, X
	RTS

CollisionLogic:
	LDX $0451
	LDA $0452, X
	CMP #$03
	BNE @00_b93d
	JSR Sub_00_ba12
@00_b93d:
	LDA $0452, X
	CLC
	ADC #$02
	CMP $0487, X
	BCS @00_b94b
	JMP JMP_00_b9f4
@00_b94b:
	LDX $0451
	LDA $045a, X
	CMP #$05
	BNE @00_b998
	LDY $044f
	LDA $0523, Y
	BNE @00_b968
	JSR Sub_07_d94c
	LDY $044f
	LDA $0523, Y
	BEQ @00_b969
@00_b968:
	RTS
@00_b969:
	LDA $0451
	TAX
	STA $02d4
	STA $0444
	LDA $0452, X
	STA $02d5
	STA $0445
	LDA #$01
	STA $02d6
	LDA #$00
	STA $0446
	JSR Sub_00_a8d8
	JSR Sub_07_daf2
	LDX $0451
	JSR Sub_00_ba9b
	LDA #SFX_SHELL_VANISH
	JSR StoreMusicID
	RTS
@00_b998:
	JSR NormalCollision
	LDA $0509
	BEQ @00_b9a4
	JSR Sub_00_baaa
	RTS
@00_b9a4:
	LDX $0451
	STX $0444
	LDA $0452, X
	STA $0445
	LDA $045a, X
	STA $0446
	JSR Sub_00_a8d8
	LDX $0451
	LDA $0452, X
	CMP #$02
	BNE @00_b9cd
	JSR EndTheGame
	LDX $0451
	JSR Sub_00_b9d4
	RTS
@00_b9cd:
	LDX $0451
	JSR Sub_00_b9d4
	RTS

Sub_00_b9d4:
	LDA $0452, X
	STA $04ea
	LDA $0451
	STA $04e9
	JSR Sub_00_a8ad
	LDA $045a, X
	LDY #$00
	STA (zPointerC7), Y
	JSR Sub_00_ba9b
	DEC $0487, X
	DEC $0487, X
	RTS


JMP_00_b9f4:
	INC $0452, X
	JSR Sub_00_b9fb
Branch_00_b9fa:
	RTS

Sub_00_b9fb:
	LDA $0451
	STA $0444
	TAX
	LDA $0452, X
	STA $0445
	LDA $045a, X
	STA $0446
	JSR Sub_00_a77d
	RTS

Sub_00_ba12:
	LDY $044f
	LDA #$01
	STA $050a, Y
	RTS

NormalCollision:
	LDX $0451
	LDA $0452, X
	CMP #$12
	BEQ @00_ba47
	LDA $0452, X
	STA $04ea
	INC $04ea
	INC $04ea
	LDA $0451
	STA $04e9
	JSR Sub_00_a8ad
	LDY #$00
	LDA (zPointerC7), Y
	STA za3
	LDA $045a, X
	CMP za3
	BEQ @00_ba52
@00_ba47:
	LDA #SFX_PLACEMENT
	JSR StoreMusicID
	LDA #$00
	STA $0509
	RTS
@00_ba52:
	LDA #$01
	STA $0509
	LDA #SFX_MATCH
	JSR StoreMusicID
	RTS

Sub_00_ba5d:
	LDX $044f
	LDA $0512, X
	BNE @00_ba9a
	LDY $044f
	LDA $050a, Y
	BEQ Branch_00_b9fa
	LDA #$00
	STA $050a, Y
	TYA
	ASL A
	ASL A
	TAX
	LDY #$00
@00_ba78:
	STX $0444
	LDA #$02
	STA $0445
	LDA $0475, X
	BEQ @00_ba93
	STA $0446
	PHX
	PHY
	JSR Sub_00_a77d
	PLY
	PLX
@00_ba93:
	INX
	INY
	CPY #$04
	BNE @00_ba78
	RTS
@00_ba9a:
	RTS

Sub_00_ba9b:
	LDA #$00
	STA $0462, X
	STA $0452, X
	STA $045a, X
	STA $046a, X
	RTS

Sub_00_baaa:
	LDX $0451
	LDA $0452, X
	STX $02d4
	STA $02d5
	LDA #$00
	STA $02d6
	JSR Sub_07_daf2
	STX $04e9
	LDA $0452, X
	STA $04ea
	JSR Sub_00_a8ad
	LDA #$00
	TAY
	STA (zPointerC7), Y
	INC $04ea
	INC $04ea
	JSR Sub_00_a8ad
	LDA #$00
	TAY
	STA (zPointerC7), Y
	LDX $0451
	STX $0444
	LDA $0452, X
	STA $0445
	LDA #$00
	STA $0446
	JSR Sub_00_a8d8
	INC $0445
	INC $0445
	JSR Sub_00_a8d8
	LDX $0451
	JSR Sub_00_ba9b
	INC $0487, X
	INC $0487, X
	LDA #SFX_MATCH
	JSR StoreMusicID
	LDA #$19
	STA zPointer83
	LDA #$bb
	STA zPointer83 + 1
	LDA #$00
	JSR Sub_00_8939
	RTS

Data_00_bb19:
	.db $00, $00, $00, $05

Sub_00_bb1d:
	LDA $05ae
	BNE @00_bb2a
	LDA $05af
	BNE @00_bb63
	JMP @00_bb57
@00_bb2a:
	LDA $05af
	BNE @00_bb41
	LDA $05b4
	ASL A
	ASL A
	STA za3
	LDY #$00
	LDA (zPointerD3), Y
	AND #$f3
	ORA za3
	STA (zPointerD3), Y
	RTS
@00_bb41:
	LDA $05b4
	LTH A
	ASL A
	ASL A
	STA za3
	LDY #$00
	LDA (zPointerD3), Y
	AND #$3f
	ORA za3
	STA (zPointerD3), Y
	RTS
@00_bb57:
	LDY #$00
	LDA (zPointerD3), Y
	AND #$fc
	ORA $05b4
	STA (zPointerD3), Y
	RTS
@00_bb63:
	LDA $05b4
	LTH A
	STA za3
	LDY #$00
	LDA (zPointerD3), Y
	AND #$cf
	ORA za3
	STA (zPointerD3), Y
	RTS

Sub_00_bb77:
	LDA #$6a
	STA zPointerD3
	LDA #$05
	STA zPointerD3 + 1
	LDA $05ac
	CLC
	ADC zPointerD3
	STA zPointerD3
	BCC @00_bb8b
	INC zPointerD3 + 1
@00_bb8b:
	LDA $05ad
	ASL A
	ASL A
	ASL A
	ADC zPointerD3
	STA zPointerD3
	BCC @00_bb99
	INC zPointerD3 + 1
@00_bb99:
	RTS

Sub_00_bb9a:
	LDA $05aa
	LSR A
	STA $05ac
	BCS @00_bba8
	LDA #$00
	JMP @00_bbaa
@00_bba8:
	LDA #$01
@00_bbaa:
	STA $05ae
	LDA $05ab
	LSR A
	STA $05ad
	BCS @00_bbbb
	LDA #$00
	JMP @00_bbbd
@00_bbbb:
	LDA #$01
@00_bbbd:
	STA $05af
	RTS

Sub_00_bbc1:
	JSR Sub_00_bb9a
	JSR Sub_00_bb77
	JSR Sub_00_bb1d
Branch_00_bbca:
	RTS

Sub_00_bbcb:
	LDA $05b0
	STA $05aa
	LDA $05b1
	STA $05ab
	LDA $05b2
	STA za8
@00_bbdc:
	JSR Sub_00_bbc1
	DEC $05b2
	BEQ @00_bbea
	INC $05aa
	JMP @00_bbdc
@00_bbea:
	LDA $05b0
	STA $05aa
	LDA za8
	STA $05b2
	DEC $05b3
	BEQ Branch_00_bbca
	INC $05ab
	JMP @00_bbdc
; unreferenced
	LDA #$03
	STA $05b0
	LDA #$02
	STA $05b1
	LDA #$05
	STA $05b2
	LDA #$05
	STA $05b3
	LDA #$02
	STA $05b4
	JSR Sub_00_bbcb
Branch_00_bc1c:
	RTS

Sub_00_bc1d:
	LDA $0446
	BEQ Branch_00_bc1c
	LDX $0444
	LDA Data_00_bc51, X
	STA $05b0
	LDA Data_00_bc59, X
	STA $05b2
	LDA $0445
	SEC
	SBC #$02
	TAX
	LDA Data_00_bc61, X
	STA $05b1
	LDA Data_00_bc73, X
	STA $05b3
	LDX $0446
	LDA Data_00_bc85, X
	STA $05b4
	JSR Sub_00_bbcb
	RTS

Data_00_bc51:
	.db $01, $03, $04, $06, $09, $0a, $0c, $0d

Data_00_bc59:
	.db $02, $01, $02, $01, $01, $02, $01, $02

Data_00_bc61:
	.db $03, $03, $04, $04, $05, $05, $06, $06, $07, $07, $08, $08, $09
	.db $09, $0a, $0a, $0b, $0b

Data_00_bc73:
	.db $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	.db $02, $01, $02, $01, $02

Data_00_bc85:
	.db $00, $02, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01
	.db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01

Sub_00_bc9c:
	LDA zPlayerMode
	BNE Branch_00_bcce
	LDA #$01
	STA $0610
	LDA #$28
	STA $0611
	LDA #$00
	STA $0544
	JSR Sub_07_f750
	RTS

Sub_00_bcb3:
	LDA zPlayerMode
	BNE Branch_00_bcce
	LDA $0610
	BEQ Branch_00_bcce
	DEC $0611
	BNE Branch_00_bcce
	LDA #$01
	STA $0544
	JSR Sub_07_f750
	LDA #$00
	STA $0610
Branch_00_bcce:
	RTS
