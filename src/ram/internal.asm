
	.dsb $34
z34:
	.dsb $41
zMMC1Ctrl:
	.dsb 1
zMMC1Chr:
	.dsb 2
zMMC1Prg:
	.dsb 4
zBGMCursor:
	.dsb $33
zPPUControl:
	.dsb 1
zPPUMask:
	.dsb $28
zCurrentInstrumentAddress:
zCurrentTrackPitch:
zMusicWord:
	.dsb 2
zAuxPointer:
	.dsb 2
zMusicAddress:
	.dsb 2
zMusicHeaderPointer:
	.dsb 2
zChannelOffset:
	.dsb 1
zByteCount:
	.dsb 1
	.dsb 1
zMusicHeaderID:
	.dsb 1
zChannelTotal:
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
	.dsb $100
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
