
	.dsb $34
z34:
	.dsb $41
zMMC1Ctrl: ; 75
	.dsb 1
zMMC1Chr: ; 76
	.dsb 2
zMMC1Prg: ; 78
	.dsb 4
zBGMCursor: ; 7c
	.dsb 5
zPlayerMode: ; 81
	.dsb $2c
zPointerAD:
	.dsb 2
zPPUControl: ; af
	.dsb 1
zPPUMask: ; b0
	.dsb $28
zCurrentInstrumentAddress: ; d8
zCurrentTrackPitch:
zMusicWord:
	.dsb 2
zAuxPointer: ; da
	.dsb 2
zMusicAddress: ; dc
	.dsb 2
zMusicHeaderPointer: ; de
	.dsb 2
zChannelOffset: ; e0
	.dsb 1
zByteCount: ; e1
	.dsb 1
	.dsb 1
zMusicHeaderID: ; e3
	.dsb 1
zChannelTotal: ; e4
	.dsb 1
	.dsb 1
ze6:
	.dsb 4
	.dsb 8
zf8:
	.dsb 4
zInstrumentPointer:
	.dsb 2
	.dsb 2
; $100
	.dsb $ff
iStackTop:
	.dsb 1
	.dsb $46
iPPUControl:
	.dsb $ba
	.dsb $100
	.dsb $100
	.dsb $4e
iCrunchCounter: ; 54e
	.dsb 3
iStageNum: ; 551
	.dsb $af
	.dsb $21
iChannelTargetRawPitch:
	.dsb $12
iChannelTargetPitch:
	.dsb 1
iChannelPitchSlideTail:
	.dsb 1
	.dsb 1
	.dsb 1
i637:
	.dsb 1
iChannelNoteTypeLength: ; 638
	.dsb 8
iChannelBackupAddress:
	.dsb $10
iChannelLoopCounter:
	.dsb 8
iChannelPitch:
	.dsb $10
iChannelNoteTypeMainParam: ; 668
	.dsb 8
iChannelTimbre: ; 670
	.dsb 8
iChannelVolumeRamp:
	.dsb 9
iChannelNoteLength:
	.dsb 8
iChannelID:
	.dsb 4

	.dsb 4
iChannelAddress: ; 691
	.dsb $10
iChannelFlags: ; 6a1
	.dsb 8
iChannelOctave:
	.dsb $11
iMusicID1:
	.dsb 1
iChannelEnvExtension: ; 6bb
	.dsb $10
iChannelFadeCounter: ; 6cb
	.dsb 6
iChannelInsParam:
	.dsb 2
iChannelInsID:
	.dsb 8
iChannelVolumeOffset:
	.dsb 8
	.dsb 8
iChannelVibratoDelay:
	.dsb 3
iChannelVibratoDepth:
	.dsb 3
iChannelVibratoSpeed:
	.dsb 3
iChannelVibratoCounter:
	.dsb 6
iMusicTempo:
	.dsb 2
iSFXTempo:
	.dsb 2
iMusicID2:
	.dsb 2
iVirtualOAM:
	.dsb $100
