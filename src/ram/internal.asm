
	.dsb $34
z34:
	.dsb $41
zMMC1Ctrl:
	.dsb 1
zMMC1Chr:
	.dsb 2
zMMC1Prg:
	.dsb $60
zMusicWord:
	.dsb 2
zAuxPointer:
	.dsb 2
zMusicAddress:
	.dsb 2
zMusicHeaderPointer:
	.dsb 2
zChannelOffset:
	.dsb 2
	.dsb 1
zMusicHeaderID:
	.dsb 1
zChannelTotal:
	.dsb 1
	.dsb 1
zMusicOffsetAddress:
	.dsb $16
zInstrumentPointer:
	.dsb 2
	.dsb 2
; $100
	.dsb $ff
iStackTop:
	.dsb 1
	.dsb $100
	.dsb $100
	.dsb $100
	.dsb $100
	.dsb $33
iChannelTargetPitch:
	.dsb 1
iChannelPitchSlideTail:
	.dsb 1
	.dsb 1
	.dsb 2
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
	.dsb $12
iChannelEnvExtension: ; 6bb
	.dsb $10
iChannelFadeCounter: ; 6cb
	.dsb 6
iChannelInsParam:
	.dsb 2
iChannelInsID:
	.dsb 8
iChannelVolumeOffset:
	.dsb $10
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
	.dsb 4
iVirtualOAM:
	.dsb $100
