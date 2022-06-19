z00:
	.dsb 1
z01:
	.dsb 1
z02:
	.dsb 1
z03: ; never written to, except for the boot sequence (clear)
	.dsb 7
	.dsb $9
z13:
	.dsb $21
z34: ; never written to, except for the boot sequence (clear)
	.dsb 1
	.dsb $2b
z60:
	.dsb 1
	.dsb 1
z62:
	.dsb 1
	.dsb 1
z64:
	.dsb 1
	.dsb 1
	.dsb $f
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
zResolutionInMetatiles:
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
	.dsb 2
zMusicStartingHeaderPointer:
	.dsb 2
zInstrumentPointer:
	.dsb 2
zfe:
	.dsb 1
zff:
	.dsb 1
; $100
i100:
iPaletteTable:
	.dsb 5
i105:
	.dsb 11
	.dsb 13
i11d:
	.dsb 3
	.dsb $2
iDisableMusic:
	.dsb 1
i123:
	.dsb 1
i124:
	.dsb 1
i125:
	.dsb 1
i126:
	.dsb 1
i127:
	.dsb 1
; stack
	.dsb $d7
iStackTop:
	.dsb 1
i200:
	.dsb $21
i221:
	.dsb 1
i222:
	.dsb 1
	.dsb $1
i224:
	.dsb 1
i225:
	.dsb 1
iPals:
	.dsb $20
iPPUControl: ; 246
	.dsb 1
iPPUMask:
	.dsb 1
i248:
	.dsb 1
iJoyCurrent:
	.dsb 2
iJoyHeld:
	.dsb 2
iJoy24d:
	.dsb 2
iJoyXOR:
	.dsb 2
iJoyPressed:
	.dsb 2
iJoyBackup:
	.dsb 2
	.dsb $42
i297: ; unused, written to but never read
	.dsb $69
	.dsb $100
	.dsb $100
	.dsb $4e
iCrunchCounter: ; 54e
	.dsb 3
iStageNum: ; 551
	.dsb 1
	.dsb $ae
	.dsb $1b
iChannelLittlePitch:
	.dsb 6
iChannelTargetRawPitch:
	.dsb $12
iChannelTargetPitch:
	.dsb 1
iChannelPitchSlideTail:
	.dsb 1
iAlternatePitch:
	.dsb 1
iMusicTracks:
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
iChannelTracks:
	.dsb 4
iChannelAddress: ; 691
	.dsb $10
iChannelFlags: ; 6a1
	.dsb 8
iChannelOctave:
	.dsb 8
i6b1:
	.dsb 8
i6b9:
	.dsb 1
iMusicID1:
	.dsb 1
iChannelEnvExtension: ; 6bb
	.dsb 8
iChannelNoteInFrames:
	.dsb 8
iChannelFadeCounter: ; 6cb
	.dsb 6
iChannelInsParam:
	.dsb 2
iChannelInsVolume:
iChannelInsID:
	.dsb 8
iChannelVolumeOffset: ; 6db
	.dsb 8
iMusicTempoOffset:
	.dsb 4
iSFXTempoOffset:
	.dsb 4
iChannelVibratoDelay:
	.dsb 3
iChannelVibratoDepth:
	.dsb 3
iChannelVibratoSpeed:
	.dsb 3
iChannelVibratoCounter:
	.dsb 3
iChannelVibratoFlags:
	.dsb 3
iMusicTempo:
	.dsb 2
iSFXTempo:
	.dsb 2
iMusicID2:
	.dsb 2
iVirtualOAM:
	.dsb $100
