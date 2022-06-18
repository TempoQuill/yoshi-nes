ResetMapper:
	INC ResetMapper ; resets MMC1
	RTS

WriteToMapper:
	JSR WriteMapperControl
	JSR WriteChr1
	JSR WriteChr2
	JSR SwitchToMain
	RTS

WriteMapperControl:
	LDA zMMC1Ctrl
	STA MMC1_Control + $1000
	LSR A
	STA MMC1_Control + $1000
	LSR A
	STA MMC1_Control + $1000
	LSR A
	STA MMC1_Control + $1000
	LSR A
	STA MMC1_Control + $1000
	RTS

WriteChr1:
	LDA zMMC1Chr + 1
	STA MMC1_CHRBank1 + $1000
	LSR A
	STA MMC1_CHRBank1 + $1000
	LSR A
	STA MMC1_CHRBank1 + $1000
	LSR A
	STA MMC1_CHRBank1 + $1000
	LSR A
	STA MMC1_CHRBank1 + $1000
	RTS

WriteChr2:
	LDA zMMC1Chr
	STA MMC1_CHRBank2 + $1000
	LSR A
	STA MMC1_CHRBank2 + $1000
	LSR A
	STA MMC1_CHRBank2 + $1000
	LSR A
	STA MMC1_CHRBank2 + $1000
	LSR A
	STA MMC1_CHRBank2 + $1000
	RTS

SwitchToAudio:
	LDA #$01
	BNE PrgSwitch

SwitchToMain:
	LDA zMMC1Prg
PrgSwitch:
	STA MMC1_RomBank + $1000
	LSR A
	STA MMC1_RomBank + $1000
	LSR A
	STA MMC1_RomBank + $1000
	LSR A
	STA MMC1_RomBank + $1000
	LSR A
	STA MMC1_RomBank + $1000
	RTS
