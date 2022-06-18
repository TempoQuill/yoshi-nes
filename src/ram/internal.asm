z00:
	.dsb 1
z01:
	.dsb 1
z02:
	.dsb 1
z03: ; never written to, except for the boot sequence (clear)
	.dsb 7
	.dsb $2a
z34: ; never written to, except for the boot sequence (clear)
	.dsb 1
	.dsb $40
zMMC1Ctrl: ; 75
	.dsb 1
zMMC1Chr: ; 76
	.dsb 2
zMMC1Prg: ; 78
	.dsb 1
z79:
	.dsb 1
z7a:
	.dsb 1
z7b:
	.dsb 1
zBGMCursor: ; 7c
	.dsb 1
z7d:
	.dsb 1
z7e:
	.dsb 1
z7f:
	.dsb 1
z80:
	.dsb 1
zPlayerMode: ; 81
	.dsb 1
z82:
	.dsb 1
zPointer83:
	.dsb 2
zPointer85:
	.dsb 2
z87:
	.dsb 1
	.dsb $1
z89:
	.dsb 1
z8a:
	.dsb 1
z8b:
	.dsb 1
	.dsb $1
zPointer8D:
	.dsb 2
z8f:
	.dsb 1
z90:
	.dsb 1
z91:
	.dsb 1
z92:
	.dsb 1
z93: ; completely unused, never read
	.dsb 1
z94: ; completely unused, never read
	.dsb 1
z95: ; completely unused, never read
	.dsb 1
	.dsb $d
za3:
	.dsb 1
za4:
	.dsb 1
za5:
	.dsb 1
za6:
	.dsb 1
za7:
	.dsb 1
za8:
	.dsb 1
	.dsb $3
zac:
	.dsb 1
zPointerAD:
	.dsb 2
zPPUControl: ; af
	.dsb 1
zPPUMask: ; b0
	.dsb 1
zb1:
	.dsb 1
zb2:
	.dsb 1
zb3:
	.dsb 1
zPPUScrollX:
	.dsb 1
zPPUScrollY:
	.dsb 1
zb6:
	.dsb 1
zPointerB7:
	.dsb 2
zb9:
	.dsb 1
zba:
	.dsb 1
zbb:
	.dsb 1
zbc:
	.dsb 1
zbd:
	.dsb 1
zPPUDataCounter:
	.dsb 1
zbf:
	.dsb 1
zc0:
	.dsb 1
zc1:
	.dsb 1
zc2:
	.dsb 1
zc3:
	.dsb 1
zc4:
	.dsb 1
zc5:
	.dsb 1
zNMIActivity:
	.dsb 1
zc7:
zPointerC7:
	.dsb 2
zc9:
	.dsb 1
	.dsb $1
zcb:
	.dsb 1
	.dsb $1
zcd:
	.dsb 1
	.dsb $1
zcf:
	.dsb 1
	.dsb $1
zd1:
	.dsb 1
	.dsb $1
zPointerD3:
	.dsb 2
zPointerD5:
	.dsb 2
	.dsb $1
zCurrentInstrumentAddress: ; d8
zCurrentTrackPitch:
zMusicTempID:
zMusicTempNoteLength:
zMusicTempByte:
zMusicTempDPCMPointer:
	.dsb 2
zAuxPointer: ; da
	.dsb 2
zOAMOverheadPointer:
zMusicAddress: ; dc
	.dsb 2
zOAMTileNumPointer:
zMusicHeaderPointer: ; de
	.dsb 2
zChannelOffset: ; e0
	.dsb 1
zByteCount: ; e1
zNumOAMTiles:
	.dsb 1
zOAMOffset:
zMusicHeaderOffset:
	.dsb 1
ze3:
zMusicHeaderID: ; e3
	.dsb 1
zChannelTotal: ; e4
	.dsb 1
zOAMAttributes:
zChannelIndex:
	.dsb 1
zOAMAttrCoordPointer:
zMusicNoteCalcBuffer:
	.dsb 1
zMusicTempNoteType: ; e7
zCurrentTempo:
	.dsb 1
zOAMTileNoIndex: ; e8
	.dsb 1
zOAMCoordID: ; odd - Y, even - X
zMusicTempoCalcBuffer: ; e9
	.dsb 1
	.dsb $e
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
	.dsb $51
i297: ; unused, written to but never read
	.dsb $69
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
iAlternatePitch:
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
	.dsb 1
i68a:
	.dsb 1
i68b:
	.dsb 1
i68c:
	.dsb 1

	.dsb 4
iChannelAddress: ; 691
	.dsb $10
iChannelFlags: ; 6a1
	.dsb 8
iChannelOctave:
	.dsb $11
i6b9:
iMusicID1:
	.dsb 1
iChannelEnvExtension: ; 6bb
	.dsb $8
iChannelNoteInFrames:
	.dsb $8
iChannelFadeCounter: ; 6cb
	.dsb 6
iChannelInsParam:
	.dsb 2
iChannelInsVolume:
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
