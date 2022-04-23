; PRG 1 contains all the music as well as the sound engine
; and something to do with music ID's

.include "sfx/sound/music/title.asm"
.include "sfx/sound/music/starman.asm"
.include "sfx/sound/music/flower.asm"
.include "sfx/sound/music/mushroom.asm"
.include "sfx/sound/music/vsmatch.asm"
.include "sfx/sound/music/gameover.asm"
.include "sfx/sound/music/stageclear.asm"
.include "sfx/sound/music/currentscore.asm"
.include "sfx/sound/music/gamepoint.asm"
.include "sfx/sound/music/vsresults.asm"
.include "sfx/sound/music/unused.asm"
.include "sfx/sound/music/vsmenu.asm"
.include "sfx/sound/sfx-1.asm"
.include "sfx/sound/music/roundend.asm"

UpdateSound:
; This routine is responsible for what we hear
	LDX #CHAN_0
	LDY #$00
@loop:
	TXA
	ASL A
	ASL A
	STA zChannelOffset
	CPX #CHAN_3
	BEQ @music_chan
	BCS @01_9e9e
@music_chan:
	LDA $0636
	AND ChannelMasks, X
	BEQ @01_9eb3
	BCS @01_9ea8
	LDA $068d, X
	BEQ @01_9ea5
	LDA $0636
	AND #$0f
	BEQ @next_chan
	BNE @01_9ea5
@01_9e9e:
	LDA $0636
	AND #$0f
	BEQ @01_9eb3
@01_9ea5:
	JSR TurnOffEnvelopes
@01_9ea8:
	LDA $06be
	ORA ChannelMasks, X
	STA $06be
	BNE @next_chan
@01_9eb3:
	LDA $06be
	AND ChannelMasks, X
	BEQ @01_9ed0
	LDA $06be
	EOR ChannelMasks, X
	STA $06be
	LDA zChannelOffset
	AND #$0f
	CMP #$02
	BCS @01_9ed0
	TAY
	JSR ApplyChannel
@01_9ed0:
	LDA iChannelID, X
	BEQ @next_chan
	JSR UpdateChannel
@next_chan:
	INX
	CPX #CHAN_8
	BNE @loop
	RTS

ChannelMasks:
	.db $80, $40, $20, $10, $08, $04, $02, $01

QuitChannelUpdate:
	RTS

UpdateChannel:
	JSR CopyMusicAddress
	; are we beginning a new note
	DEC iChannelNoteLength, X
	BNE @note_playing
	; yes
	LDA iChannelID, X ; useless
	JMP ParseByte
@note_playing:
	; are we in a pitch slide?
	LDA iChannelFlags, X
	AND #SOUND_PITCH_SLIDE
	BEQ @slide_done
	; yes
	JSR ChannelCheckProceedure
	BCS @slide_done
	JSR HandlePitchSlide
@slide_done:
	; are on noise channels?
	CPX #CHAN_7
	BEQ QuitChannelUpdate
	CPX #CHAN_3
	BEQ QuitChannelUpdate
	; no
	; is the SFX reading mode on?
	LDA iChannelFlags, X
	LSR A ; SOUND_READING_MODE
	BCC QuitChannelUpdate
	; no
	; noise or SFX?
	CPX #CHAN_3
	BCS @01_9f5f
	; no
	LDA $068d, X
	BNE @01_9f5f
	LDA $06f7, X
	ROL A
	BCC @01_9f5f
	ROL A
	BCC @01_9f3c
	LDA iChannelVibratoDelay, X
	CMP iChannelVibratoCounter, X
	BEQ @01_9f32
	INC iChannelVibratoCounter, X
	JMP @01_9fb8
@01_9f32:
	LDA #0
	STA iChannelVibratoCounter, X
	LDA #$81
	STA $06f7, X
@01_9f3c:
	LDA $06f7, X
	AND #$04
	BEQ @01_9f48
	LDA #$80
	STA $06f7, X
@01_9f48:
	LDA zChannelOffset
	AND #$0f
	TAY
	LDA $06f7, X
	AND #$02
	BEQ @01_9f8e
	LDA iChannelVibratoSpeed, X
	CMP iChannelVibratoCounter, X
	BEQ @01_9f7d
	INC iChannelVibratoCounter, X
@01_9f5f:
	CPX #CHAN_6
	BEQ @01_9f6a
	CPX #CHAN_2
	BEQ @01_9f6a
	JMP @01_9fb8
@01_9f6a:
	LDA iChannelNoteLength, X
	CMP $06c3, X
	BNE @01_9f7c
	JSR ChannelCheckProceedure
	BCS @01_9f7c
	LDA #$80
	JMP UpdateEnv
@01_9f7c:
	RTS
@01_9f7d:
	LDA iChannelPitch + 8, X
	SEC
	SBC iChannelVibratoDepth, X
	BCS @01_9fad
	LDA #$00
	STA SQ1_LO, Y
	JMP @01_9fb0
@01_9f8e:
	LDA iChannelVibratoSpeed, X
	CMP iChannelVibratoCounter, X
	BEQ @01_9f9c
	INC iChannelVibratoCounter, X
	JMP @01_9fb8
@01_9f9c:
	LDA iChannelPitch + 8, X
	CLC
	ADC iChannelVibratoDepth, X
	BCC @01_9fad
	LDA #$ff
	STA SQ1_LO, Y
	JMP @01_9fb0
@01_9fad:
	STA SQ1_LO, Y
@01_9fb0:
	LDA #$00
	STA iChannelVibratoCounter, X
	INC $06f7, X
@01_9fb8:
	LDA iChannelVolumeRamp, X
	AND #$0f
	BNE @01_9fc0
	RTS
@01_9fc0:
	LDA iChannelNoteLength, X
	CMP $06c3, X
	BCC @01_a00f
	LDA iChannelFlags, X
	AND #SOUND_INSTRUMENT
	BEQ @01_9fda
	LDA iChannelInsID, X
	BEQ @01_a02d
	DEC iChannelInsID, X
	JMP @01_a023
@01_9fda:
	LDA iChannelInsParam, X
	ASL A
	TAY
	LDA (zInstrumentPointer), Y
	STA zCurrentInstrumentAddress
	INY
	LDA (zInstrumentPointer), Y
	STA zCurrentInstrumentAddress + 1
@01_9fe8:
	LDA iChannelInsID, X
	INC iChannelInsID, X
	TAY
	LDA (zCurrentInstrumentAddress), Y
	CMP #$fe
	BCC @01_a005
	BEQ @01_9ffd
	DEC iChannelInsID, X
	JMP @01_a02d
@01_9ffd:
	INY
	LDA (zCurrentInstrumentAddress), Y
	STA iChannelInsID, X
	BNE @01_9fe8
@01_a005:
	LDA (zCurrentInstrumentAddress), Y
	BEQ @01_a03a
	STA iChannelVolumeRamp, X
	JMP @01_a02d
@01_a00f:
	LDA iChannelFadeCounter, X
	BEQ @01_a019
	DEC iChannelFadeCounter, X
	BNE @01_a045
@01_a019:
	LDA iChannelEnvExtension, X
	LSR A
	LSR A
	LSR A
	LSR A
	STA iChannelFadeCounter, X
@01_a023:
	LDA iChannelVolumeRamp, X
	CMP #$01
	BEQ @01_a02d
	DEC iChannelVolumeRamp, X
@01_a02d:
	LDA iChannelVolumeRamp, X
	SEC
	SBC iChannelVolumeOffset, X
	BEQ @01_a038
	BCS @01_a03a
@01_a038:
	LDA #$01
@01_a03a:
	ORA iChannelTimbre, X
	JSR ChannelCheckProceedure
	BCS @01_a045
	JMP UpdateEnv
@01_a045:
	RTS


ParseNextByte:
	; go to the next byte
	INY
ParseByte:
	; check for address commands
	LDA (zMusicAddress), Y
	CMP #sound_call_cmd
	BCS @addr_cmd
	JMP ParseNote
@addr_cmd:
	; branch at this point if we aren't calling
	BNE @next
	; let RAM know we're about to enter a sub
	LDA iChannelFlags, X
	ORA #SOUND_SUBROUTINE
	STA iChannelFlags, X
	JSR UpdateMusicAddress
	JSR SaveMusicReturnAddress
	JSR CopyMusicAddress
	JMP ParseByte
@next:
	; are we looping?
	CMP #sound_loop_cmd
	BEQ @sound_loop
	; nope, we encountered $ff
	; are we in a sub?
	LDA iChannelFlags, X
	AND #SOUND_SUBROUTINE
	BEQ @track_end
	; yes
	; then let RAM know we're leaving
	LDA iChannelFlags, X
	AND #$ff ^ SOUND_SUBROUTINE
	STA iChannelFlags, X
	LDA iChannelBackupAddress, X
	STA iChannelAddress, X
	LDA iChannelBackupAddress + 8, X
	STA iChannelAddress + 8, X
	JSR CopyMusicAddress
	JMP ParseByte
@sound_loop:
	; safe increment loop counter
	LDA iChannelLoopCounter, X
	CLC
	ADC #$01
	; stack up to byte shown
	; are we done? did we exceed the byte shown?
	INY
	CMP (zMusicAddress), Y
	BEQ @end_loop
	BMI @use_loop ; BCC would be more appropriate
	; we exceed the byte shown, this is what happens when we loop with 0
	SEC
	SBC #$01
@use_loop:
	; store A in the loop counter and perform the standard jump
	STA iChannelLoopCounter, X
	JSR UpdateMusicAddress
	JSR CopyMusicAddress
	JMP ParseByte
@end_loop:
	; clear the loop counter
	LDA #$00
	STA iChannelLoopCounter, X
	; skip the parameters
	INY
	INY
	INY
	; update the music address
	TYA
	CLC
	ADC zMusicAddress
	STA iChannelAddress, X
	LDA #$00
	ADC zMusicAddress + 1
	STA iChannelAddress + 8, X
	JSR CopyMusicAddress
	JMP ParseByte
@track_end:
	LDA iChannelID, X
	STA zMusicWord
	LDA #0
	STA iChannelID, X
	STA iChannelPitch, X
	STA $0635
	STA iChannelFlags, X
	LDA zMusicWord
	CMP #MUSIC_VS_MATCH + 1
	BNE @01_a0e7
	LDA #NO_MUSIC
	JSR PlayAudio
	LDA i637
	JMP PlayAudio
@01_a0e7:
	CPX #CHAN_3
	BEQ @01_a12a
	CPX #CHAN_4
	BNE @01_a0fc
	LDA iChannelID
	BEQ @01_a10d
	LDA $06b9
	BNE @01_a10d
	JMP ApplyPulse1
@01_a0fc:
	CPX #$05
	BNE @01_a10d
	LDA $068a
	BEQ @01_a10d
	LDA $06b9
	BNE @01_a10d
	JMP ApplyPulse2
@01_a10d:
	LDA #$00
	STA iChannelPitch, X
	STA $0635
	STA iChannelFlags, X
	CPX #CHAN_2
	BEQ @01_a122
	CPX #CHAN_6
	BEQ @01_a122
	LDA #Volume_Loop_F | Volume_Ramp_F
@01_a122:
	JSR ChannelCheckProceedure
	BCS @01_a12a
	JMP UpdateEnv
@01_a12a:
	RTS


ParseNote:
	LDA iChannelFlags, X
	AND #SOUND_READING_MODE
	BEQ @01_a135
	JMP SearchCommand_Tier1
@01_a135:
	LDA (zMusicAddress), Y
	AND #$f0
	CMP #sfx_type_cmd
	BNE @01_a15e
	LDA (zMusicAddress), Y
	AND #$0f
	STA iChannelNoteTypeLength, X
	INY
	CPX #CHAN_2
	BEQ @01_a151
	CPX #CHAN_6
	BEQ @01_a151
	LDA (zMusicAddress), Y
	AND #$f0
@01_a151:
	STA iChannelTimbre, X
	LDA (zMusicAddress), Y
	AND #$0f
	STA iChannelVolumeRamp, X
	JMP ParseNextByte
@01_a15e:
	LDA (zMusicAddress), Y
	CMP #sfx_pitch_inc_switch_cmd
	BNE @01_a16f
	LDA iChannelFlags, X
	ORA #SOUND_PITCH_INC
	STA iChannelFlags, X
	JMP ParseNextByte
@01_a16f:
	CMP #pitch_sweep_cmd
	BNE @01_a189
	INY
	LDA (zMusicAddress), Y
	JSR ChannelCheckProceedure
	BCS @01_a17e
	JSR UpdateSweep
@01_a17e:
	LDA iChannelFlags, X
	ORA #SOUND_PITCH_SWEEP
	STA iChannelFlags, X
	JMP ParseNextByte
@01_a189:
	LDA iChannelNoteTypeLength, X
	STA iChannelNoteLength, X
	CPX #CHAN_2
	BEQ @01_a1c2
	CPX #CHAN_6
	BEQ @01_a1c2
	LDA iChannelTimbre, X
	AND #$10
	BNE @01_a1a7
	LDA iChannelVolumeRamp, X
	ORA iChannelTimbre, X
	JMP @01_a1bf
@01_a1a7:
	LDA (zMusicAddress), Y
	CMP #$f8
	BNE @01_a1b0
	INY
	LDA (zMusicAddress), Y
@01_a1b0:
	LSR A
	LSR A
	LSR A
	LSR A
	STA iChannelVolumeRamp, X
	ORA iChannelTimbre, X
	JSR ChannelCheckProceedure
	BCS @01_a1c2
@01_a1bf:
	JSR UpdateEnv
@01_a1c2:
	LDA (zMusicAddress), Y
	AND #$07
	STA zCurrentTrackPitch
	INY
	LDA (zMusicAddress), Y
	STA zCurrentTrackPitch + 1
	JSR Sub_01_a4d9
	JMP IncrementMusicAddress


SearchCommand_Tier1:
	LDA (zMusicAddress), Y
	AND #$f0
	CMP #note_type_cmd
	BEQ @01_a1de
	JMP SearchCommand_Tier2
@01_a1de:
	LDA (zMusicAddress), Y
	AND #$0f
	STA iChannelNoteTypeLength, X
	INY
	CPX #CHAN_3
	BNE @01_a1ed
	JMP ParseByte
@01_a1ed:
	LDA (zMusicAddress), Y
	STA iChannelNoteTypeMainParam, X
	CPX #CHAN_2
	BEQ @01_a1fa
	CPX #CHAN_6
	BNE @01_a200
@01_a1fa:
	STA iChannelEnvExtension, X
	JMP ParseNextByte
@01_a200:
	AND #Cycle_Mask | Volume_Loop_F | Volume_Ramp_F
	STA iChannelTimbre, X
	LDA iChannelNoteTypeMainParam, X
	AND #$0f
	STA iChannelVolumeRamp, X
	INY
	CPX #CHAN_2
	BEQ @01_a216
	CPX #CHAN_6
	BNE @01_a219
@01_a216:
	JMP SearchCommand_Tier2
@01_a219:
	LDA (zMusicAddress), Y
	STA iChannelInsParam, X
	AND #NOTE_BLOCK_INSTRUMENT
	BEQ @01_a230
	LDA (zMusicAddress), Y
	AND #$0f
	STA iChannelInsID, X
	LDA iChannelFlags, X
	ORA #SOUND_INSTRUMENT
	BNE @01_a235
@01_a230:
	LDA iChannelFlags, X
	AND #$ff ^ SOUND_INSTRUMENT
@01_a235:
	STA iChannelFlags, X
	INY
	LDA (zMusicAddress), Y
	STA iChannelEnvExtension, X
	JMP ParseNextByte


SearchCommand_Tier2:
	LDA (zMusicAddress), Y
	AND #$f0
	CMP #$e0
	BEQ @01_a24c
	JMP SearchCommand_Volume
@01_a24c:
	LDA (zMusicAddress), Y
	AND #$0f
	ASL A
	TAX
	LDA E0_EF_Commands, X
	STA zAuxPointer
	LDA E0_EF_Commands + 1, X
	STA zAuxPointer + 1
	LDA zChannelOffset
	LSR A
	LSR A
	TAX
	JMP (zAuxPointer)

E0_EF_Commands:
	.dw Octave
	.dw Octave
	.dw Octave
	.dw Octave
	.dw Octave
	.dw Octave
	.dw Octave
	.dw Octave
	.dw Pitch_Inc_Switch
	.dw Frame_Swap
	.dw Vibrato
	.dw Pitch_Slide
	.dw Dummy
	.dw Tempo
	.dw New_Song
	.dw Channel_Mute

Octave:
	LDA (zMusicAddress), Y
	AND #%00001111
	STA iChannelOctave, X
	JMP ParseNextByte

Pitch_Inc_Switch:
	LDA iChannelFlags, X
	EOR #SOUND_PITCH_INC
	STA iChannelFlags, X
	JMP ParseNextByte

Frame_Swap:
	PHA
	TXA
	PHA
	JSR Sub_07_f71d
	PLA
	TAX
	PLA
	JMP ParseNextByte

Vibrato:
	INY
	LDA (zMusicAddress), Y
	BNE @01_a2b2
	LDA #0
	STA $06f7, X
	JMP ParseNextByte
@01_a2b2:
	STA iChannelVibratoDelay, X
	INY
	LDA (zMusicAddress), Y
	AND #%00001111
	STA iChannelVibratoSpeed, X
	LDA (zMusicAddress), Y
	LSR A
	LSR A
	LSR A
	LSR A
	STA iChannelVibratoDepth, X
	LDA #0
	STA iChannelVibratoCounter, X
	LDA #$c1
	STA $06f7, X
	JMP ParseNextByte

Dummy:
	JMP ParseNextByte

Tempo:
	INY
	CPX #CHAN_4
	BCS @sfx
	LDA (zMusicAddress), Y
	STA iMusicTempo
	INY
	LDA (zMusicAddress), Y
	STA iMusicTempo + 1
	LDA #0
	STA $06e3
	STA $06e4
	STA $06e5
	STA $06e6
	JMP ParseNextByte
@sfx:
	LDA (zMusicAddress), Y
	STA iSFXTempo
	INY
	LDA (zMusicAddress), Y
	STA iSFXTempo + 1
	LDA #0
	STA $06e7
	STA $06e8
	STA $06e9
	JMP ParseNextByte

New_Song:
	JSR PlayNewSong
	JMP ParseNextByte

Channel_Mute:
	LDA z34
	BMI @01_a339
	CPX #CHAN_4
	BCS @01_a339
	LDA $0328
	ORA $0329
	AND #$f0
	BNE @01_a339
	LDA Channel_Masks, X
	ORA $0636
	STA $0636
	LDA #$01
	STA iChannelNoteLength, X
	JMP IncrementMusicAddress
@01_a339:
	JMP ParseNextByte

Channel_Masks:
	.db $80, $40, $20, $10

Pitch_Slide:
	INY
	LDA (zMusicAddress), Y
	STA iChannelPitchSlideTail
	INY
	LDA (zMusicAddress), Y
	STA iChannelTargetPitch
	LDA iChannelFlags, X
	ORA #SOUND_PITCH_SLIDE
	STA iChannelFlags, X
	INY
	LDA (zMusicAddress), Y
SearchCommand_Volume:
	CMP #channel_volume_cmd
	BNE GetNoteLength
	LDA (zMusicAddress), Y
	AND #$0f
	STA iChannelVolumeOffset, X
	JMP ParseNextByte

GetNotePitch:
	LDA (zMusicAddress), Y
	AND #$f0
	CMP #NOTE_REST << 4
	BEQ PlayQuit
	JSR DrumCheckProceedure
	BCS PlayQuit
	LSR A
	LSR A
	LSR A
	LSR A
	CMP #B_
	BNE PlayFromPitch

PlayNewSong:
	INY
	LDA (zMusicAddress), Y
	PHA
	JSR IncrementMusicAddress
	PLA
PlayFromPitch:
	JSR PlayAudio
	JSR GetChannelID
PlayQuit:
	RTS

GetNoteLength:
	JSR IncrementMusicAddress
	DEY
	LDA (zMusicAddress), Y
	AND #$0f
	STA zMusicWord
	INC zMusicWord
	LDA #0
	STA ze6
	STA ze6 + 3
	LDA iChannelNoteTypeLength, X
	STA ze6 + 1
@01_a3a0:
	LSR zMusicWord
	BCC @01_a3ab
	LDA ze6 + 1
	CLC
	ADC ze6
	STA ze6
@01_a3ab:
	ASL ze6 + 1
	LDA zMusicWord
	BNE @01_a3a0
	CPX #$07
	BCC @01_a3ba
	LDA ze6
	JMP @01_a3f2
@01_a3ba:
	CPX #$04
	BCC @01_a3cb
	LDA iSFXTempo
	STA ze6 + 1
	LDA iSFXTempo + 1
	STA ze6 + 2
	JMP @01_a3d5
@01_a3cb:
	LDA iMusicTempo
	STA ze6 + 1
	LDA iMusicTempo + 1
	STA ze6 + 2
@01_a3d5:
	LSR ze6
	BCC @01_a3e8
	LDA ze6 + 2
	CLC
	ADC $06e3, X
	STA $06e3, X
	LDA ze6 + 1
	ADC ze6 + 3
	STA ze6 + 3
@01_a3e8:
	ASL ze6 + 2
	ROL ze6 + 1
	LDA ze6
	BNE @01_a3d5
	LDA ze6 + 3
@01_a3f2:
	STA iChannelNoteLength, X
	CPX #$03
	BNE @01_a3fc
	JMP GetNotePitch
@01_a3fc:
	LDA (zMusicAddress), Y
	AND #$f0
	CMP #$c0
	BNE @01_a41f
	LDA #$00
	STA iChannelVolumeRamp, X
	CPX #CHAN_2
	BEQ @01_a41b
	CPX #CHAN_6
	BEQ @01_a41b
	LDA #$30
	ORA iChannelTimbre, X
	JSR ChannelCheckProceedure
	BCS @01_a41e
@01_a41b:
	JMP UpdateEnv
@01_a41e:
	RTS
@01_a41f:
	CPX #$03
	BCS @01_a433
	LDA $06f7, X
	ROL A
	BCC @01_a433
	LDA #$c1
	STA $06f7, X
	LDA #$00
	STA iChannelVibratoCounter, X
@01_a433:
	LDA iChannelEnvExtension, X
	AND #$0f
	STA zMusicWord
	BEQ @01_a45c
	LDA #$00
	STA zMusicWord + 1
@01_a440:
	CLC
	ADC iChannelNoteLength, X
	BCC @01_a448
	INC zMusicWord + 1
@01_a448:
	CMP zMusicWord
	BNE @01_a440
	STA zMusicWord
	LDA #$04
	STA zByteCount
@01_a452:
	LSR zMusicWord + 1
	ROR zMusicWord
	CMP zByteCount
	BNE @01_a452
	LDA zMusicWord
@01_a45c:
	STA $06c3, X
	LDA iChannelNoteTypeMainParam, X
	CPX #CHAN_2
	BEQ @01_a4b5
	CPX #CHAN_6
	BEQ @01_a4b5
	LDA iChannelFlags, X
	AND #SOUND_INSTRUMENT
	BNE @01_a495
	TYA
	PHA
	LDA iChannelInsParam, X
	ASL A
	TAY
	LDA (zInstrumentPointer), Y
	STA zCurrentInstrumentAddress
	INY
	LDA (zInstrumentPointer), Y
	STA zCurrentInstrumentAddress + 1
	LDY #$00
	LDA (zCurrentInstrumentAddress), Y
	ORA iChannelTimbre, X
	STA iChannelNoteTypeMainParam, X
	LDA #$01
	STA iChannelInsID, X
	PLA
	TAY
	JMP @01_a49d
@01_a495:
	LDA iChannelInsParam, X
	AND #$0f
	STA iChannelInsID, X
@01_a49d:
	LDA iChannelNoteTypeMainParam, X
	AND #$0f
	STA iChannelVolumeRamp, X
	SEC
	SBC iChannelVolumeOffset, X
	BCS @01_a4ad
	LDA #$00
@01_a4ad:
	ORA iChannelTimbre, X
	JSR ChannelCheckProceedure
	BCS @01_a4b8
@01_a4b5:
	JSR UpdateEnv
@01_a4b8:
	LDA (zMusicAddress), Y
	LSR A
	LSR A
	LSR A
	; these two shift instructions are useless
	LSR A
	ASL A
	TAY
	LDA Pitches + 1, Y
	STA zCurrentTrackPitch
	LDA Pitches, Y
	STA zCurrentTrackPitch + 1
	LDY iChannelOctave, X
@01_a4cd:
	CPY #$07
	BEQ Sub_01_a4d9
	LSR zCurrentTrackPitch
	ROR zCurrentTrackPitch + 1
	INY
	JMP @01_a4cd

Sub_01_a4d9:
	LDA iChannelFlags, X
	AND #SOUND_PITCH_INC
	BEQ @01_a4f6
	INC zCurrentTrackPitch + 1
	BNE @01_a4f6
	INC zCurrentTrackPitch
@01_a4f6:
	LDA zCurrentTrackPitch
	ORA #8
	STA zCurrentTrackPitch
	CPX #CHAN_2
	BEQ @01_a50d
	CPX #CHAN_6
	BEQ @01_a516
	CMP iChannelPitch, X
	BNE @01_a513
	CPX #$07
	BEQ @01_a520
	LDA iChannelTimbre, X
	AND #$10
	BEQ @01_a516
	LDA iChannelFlags, X
	AND #SOUND_PITCH_SWEEP
	BNE @01_a516
	BEQ @01_a520
@01_a50d:
	STA $0635
	JMP @01_a516
@01_a513:
	STA iChannelPitch, X
@01_a516:
	LDA zCurrentTrackPitch
	JSR ChannelCheckProceedure
	BCS @01_a520
	JSR UpdateHigh
@01_a520:
	LDA zCurrentTrackPitch + 1
	STA iChannelPitch + 8, X
	JSR ChannelCheckProceedure
	BCS @01_a53b
	JSR UpdateLow
	CPX #$03
	BCS @01_a53b
	LDA iChannelFlags, X
	AND #SOUND_PITCH_SLIDE
	BEQ @01_a53b
	JSR ApplyPitchSlide
@01_a53b:
	RTS

.include "src/sound/notes.asm"

CopyMusicAddress:
	LDY #$00
	LDA iChannelAddress, X
	STA zMusicAddress
	LDA iChannelAddress + 8, X
	STA zMusicAddress + 1
	RTS


IncrementMusicAddress:
	INY
	TYA
	CLC
	ADC zMusicAddress
	STA iChannelAddress, X
	BCC @quit
	LDA zMusicAddress + 1
	ADC #0
	STA iChannelAddress + 8, X
@quit:
	RTS

UpdateMusicAddress:
	INY
	LDA (zMusicAddress), Y
	STA iChannelAddress, X
	INY
	LDA (zMusicAddress), Y
	STA iChannelAddress + 8, X
	RTS

SaveMusicReturnAddress:
	INY
	TYA
	CLC
	ADC zMusicAddress
	STA iChannelBackupAddress, X
	LDA zMusicAddress + 1
	ADC #$00
	STA iChannelBackupAddress + 8, X
	RTS


UpdateEnv:
	JSR GetChannelOffset
	STA SQ1_ENV, X
	JMP GetChannelID

UpdateSweep:
	JSR GetChannelOffset
	STA SQ1_SWEEP, X
	JMP GetChannelID

UpdateLow:
	JSR GetChannelOffset
	STA SQ1_LO, X
	JMP GetChannelID

UpdateHigh:
	JSR GetChannelOffset
	STA SQ1_HI, X
	JMP GetChannelID

GetChannelOffset:
	STA zMusicWord
	LDA zChannelOffset
	AND #$0f
	TAX
	LDA zMusicWord
	RTS

GetChannelID:
	LDA zChannelOffset
	LSR A
	LSR A
	TAX
	RTS

DrumCheckProceedure:
	PHA
	CPX #CHAN_3
	BNE CheckProClearCarry
	LDA $068f
	BEQ CheckProClearCarry
	BNE CheckProSetCarry

ChannelCheckProceedure:
	PHA
	CPX #CHAN_0
	BNE @01_a5f4
	LDA $068d
	BEQ CheckProClearCarry
	BNE CheckProSetCarry
@01_a5f4:
	CPX #CHAN_2
	BCS @01_a5ff
	LDA $068d, X
	BEQ CheckProClearCarry
	BNE CheckProSetCarry
@01_a5ff:
	CPX #CHAN_2
	BNE CheckProSetCarry
	LDA $068f
	BEQ CheckProSetCarry
CheckProSetCarry:
	SEC
	PLA
	RTS
CheckProClearCarry:
	CLC
	PLA
	RTS

TurnOffEnvelopes:
	LDA zChannelOffset
	AND #$0f
	TAY
	LDA Env_Off, X
	STA SQ1_ENV, Y
	RTS

Env_Off:
	.db $30, $30, $00, $30, $30, $30, $00, $30


ApplyPulse1:
	TXA
	PHA
	TYA
	PHA
	LDY #CHAN_0 << 2
	LDX #CHAN_0
	JSR ApplyChannel
	PLA
	TAY
	PLA
	TAX
	RTS


ApplyPulse2:
	TXA
	PHA
	TYA
	PHA
	LDY #CHAN_1 << 2
	LDX #CHAN_1
	JSR ApplyChannel
	PLA
	TAY
	PLA
	TAX
	RTS

ApplyChannel:
	LDA #$7f
	STA SQ1_SWEEP, Y
	LDA iChannelPitch + 8, X
	STA SQ1_LO, Y
	LDA iChannelPitch, X
	STA SQ1_HI, Y
	LDA $0636
	AND ChannelMasks, X
	BNE @01_a669
	LDA iChannelID, X
	BEQ @01_a669
	LDA iChannelTimbre, X
	ORA iChannelVolumeRamp, X
	JMP @01_a66c
@01_a669:
	LDA iChannelTimbre, X
@01_a66c:
	STA SQ1_ENV, Y
	RTS

PlayAudio:
	STA zMusicHeaderID
	CMP #sfx_boundary
	BCC @not_music
	CMP #music_boundary
	BCS @not_music
	LDA #$00
	STA iChannelID
	STA $068a
	STA $068b
	STA $068c
	STA $06f7
	STA $06f8
	STA $06f9
@not_music:
	CMP #music_boundary + 1
	BCC @01_a6d2
	LDA #$00
	STA iChannelID
	STA $068a
	STA $068b
	STA $068c
	STA $068d
	STA $068e
	STA $068f
	STA $0690
	STA $06f7
	STA $06f8
	STA $06f9
	LDA #Volume_Loop_F | Volume_Ramp_F
	STA SQ1_ENV
	STA SQ2_ENV
	STA NOISE_ENV
	LDA #$00
	STA TRI_LINEAR
	RTS
@01_a6c9: ; never used
	LDA #$01
	BNE @01_a6cf
@01_a6cd: ; never used
	LDA #$00
@01_a6cf:
	STA $06b9
@01_a6d2:
	TXA
	PHA
	TYA
	PHA
	LDX #header_byte_length
	LDA $00fa
	STA zMusicHeaderPointer
	LDA $00fb
	STA zMusicHeaderPointer + 1
@01_a6e0:
	LDA zMusicHeaderID
	CLC
	ADC zMusicHeaderPointer
	STA zMusicHeaderPointer
	BCC @01_a6eb
	INC zMusicHeaderPointer + 1
@01_a6eb:
	DEX
	BNE @01_a6e0
	LDY #$00
	STY $00e2
	LDA (zMusicHeaderPointer), Y
	ROL A
	ROL A
	ROL A
	AND #channel_mask
	STA zChannelTotal
	JMP @01_a723
@read_dpcm:
; we land here if we're on DPCM
	INY
	LDA (zMusicHeaderPointer), Y
	STA zMusicWord
	INY
	LDA (zMusicHeaderPointer), Y
	STA zMusicWord + 1
	LDA #SQ1_F | SQ2_F | TRI_F | NOISE_F
	STA SND_CHN
	LDY #$03
@01_a70f:
	CPY #$01
	BEQ @01_a718
	LDA (zMusicWord), Y
	STA DPCM_ENV, Y
@01_a718:
	DEY
	BPL @01_a70f
	LDA #SQ1_F | SQ2_F | TRI_F | NOISE_F | DPCM_F
	STA SND_CHN
@subexit:
	JMP @quit
@01_a723:
	LDY $00e2
	LDA (zMusicHeaderPointer), Y
	AND #$0f
	STA $00e5
	TAX
	CMP #CHAN_8
	BEQ @read_dpcm
	LDA zMusicHeaderID
	BEQ @01_a740
	CMP iChannelID, X
	BCS @01_a740
	LDA iChannelID, X
	CMP #drum_boundary + 1
	BCS @subexit
@01_a740:
	LDY $00e2
	INY
	LDA (zMusicHeaderPointer), Y
	STA iChannelAddress, X
	STA zAuxPointer
	INY
	LDA (zMusicHeaderPointer), Y
	STA iChannelAddress + 8, X
	STA zAuxPointer + 1
	LDA #$01
	STA iChannelNoteLength, X
	LDA #$00
	STA iChannelLoopCounter, X
	STA iChannelPitch, X
	STA $0635
	CPX #$07
	BEQ @01_a774
	LDY #$00
	LDA (zAuxPointer), Y
	AND #$f0
	CMP #sfx_type_cmd
	BEQ @01_a774
	LDA #SOUND_READING_MODE
	BNE @01_a776
@01_a774:
	LDA #$00
@01_a776:
	STA iChannelFlags, X
	LDA $00e5
	AND #$03
	ASL A
	ASL A
	TAY
	CPX #$00
	BNE @01_a789
	LDA $068d
	BNE @01_a7a6
@01_a789:
	CPX #$02
	BCS @01_a792
	LDA $068d, X
	BNE @01_a7a6
@01_a792:
	LDA #$00
	CPX #$02
	BEQ @01_a7a6
	CPX #$06
	BEQ @01_a7a6
	LDA #$30
	STA SQ1_ENV, Y
	LDA #$7f
	STA SQ1_SWEEP, Y
@01_a7a6:
	LDA zMusicHeaderID
	STA iChannelID, X
	CMP zChannelTotal
	BMI @quit
	LDY $00e2
	INY
	INY
	INY
	STY $00e2
	JMP @01_a723
@quit:
	LDA #$00
	STA zMusicHeaderPointer + 1
	PLA
	TAY
	PLA
	TAX
	RTS

ApplyPitchSlide:
	LDA iChannelTargetPitch
	AND #$0f
	ASL A
	TAY
	LDA Pitches, Y
	STA iChannelTargetRawPitch, X
	LDA Pitches + 1, Y
	STA iChannelTargetRawPitch + 3, X
	LDA iChannelTargetPitch
	LSR A
	LSR A
	LSR A
	LSR A
	TAY
@01_a7dd:
	CPY #$07
	BEQ @01_a7eb
	LSR iChannelTargetRawPitch + 3, X
	ROR iChannelTargetRawPitch, X
	INY
	JMP @01_a7dd
@01_a7eb:
	LDA iChannelTargetRawPitch + 3, X
	ORA #8
	STA iChannelTargetRawPitch + 3, X
	LDA iChannelNoteLength, X
	SEC
	SBC iChannelPitchSlideTail
	BCC @01_a7fe
	BNE @01_a800
@01_a7fe:
	LDA #$01
@01_a800:
	STA iChannelPitchSlideTail
	LDA iChannelFlags, X
	AND #$ff ^ (SOUND_PITCH_SWAP | SOUND_PITCH_SLIDE_DIR)
	STA iChannelFlags, X
	JSR SwapPitch
	LDA iChannelPitch, X
	CMP iChannelTargetRawPitch + 3, X
	BEQ @01_a81a
	BCS @01_a844
	BCC @01_a822
@01_a81a:
	LDA iChannelPitch + 8, X
	CMP iChannelTargetRawPitch, X
	BCS @01_a844
@01_a822:
	LDA iChannelTargetRawPitch, X
	SEC
	SBC $0442, X
	STA $061b, X
	LDA iChannelTargetRawPitch + 3, X
	SBC iChannelPitch, X
	BPL @01_a836
	LDA #$00
@01_a836:
	STA $061e, X
	LDA iChannelFlags, X
	ORA #SOUND_PITCH_SLIDE_DIR
	STA iChannelFlags, X
	JMP @01_a85b
@01_a844:
	LDA iChannelPitch + 8, X
	SEC
	SBC iChannelTargetRawPitch, X
	STA $061b, X
	LDA iChannelPitch, X
	SBC iChannelTargetRawPitch + 3, X
	BPL @01_a858
	LDA #$00
@01_a858:
	STA $061e, X
@01_a85b:
	LDY #$00
	LDA $061b, X
@01_a860:
	INY
	SEC
	SBC iChannelPitchSlideTail
	BCS @01_a860
	PHA
	DEC $061e, X
	BMI @01_a871
	PLA
	JMP @01_a860
@01_a871:
	DEY
	TYA
	STA $0627, X
	PLA
	CLC
	ADC iChannelPitchSlideTail
	STA $062a, X
	STA $0630, X
	LDA iChannelPitch, X
	STA $061e, X
	LDA iChannelPitch + 8, X
	STA $061b, X
	LDA iChannelNoteLength, X
	STA $062d, X
	JSR SwapPitch
	RTS

HandlePitchSlide:
	JSR SwapPitch
	LDA iChannelFlags, X
	AND #SOUND_PITCH_SLIDE_DIR
	BEQ @01_a8fb
	LDA $062a, X
	CLC
	ADC $0630, X
	CMP $062d, X
	BCC @01_a8b8
	INC $061b, X
	BNE @01_a8b5
	INC $061e, X
@01_a8b5:
	LDA $062a, X
@01_a8b8:
	STA $0630, X
	LDA $061b, X
	CLC
	ADC $0627, X
	BCC @01_a8c7
	INC $061e, X
@01_a8c7:
	STA $061b, X
	LDA iChannelFlags, X
	AND #SOUND_PITCH_SWAP
	BNE @01_a8e1
	LDA $061e, X
	CMP iChannelTargetRawPitch + 3, X
	BCC @01_a8f8
	LDA iChannelFlags, X
	ORA #SOUND_PITCH_SWAP
	STA iChannelFlags, X
@01_a8e1:
	LDA $061b, X
	CMP iChannelTargetRawPitch, X
	BCC @01_a8f8
	LDA iChannelTargetRawPitch + 3, X
	STA $061e, X
	LDA iChannelTargetRawPitch, X
	STA $061b, X
	JMP ClearPitchSlide
@01_a8f8:
	JMP UpdatePitch
@01_a8fb:
	LDA $062a, X
	CLC
	ADC $0630, X
	CMP $062d, X
	BCC @01_a915
	LDA $061b, X
	BNE @01_a90f
	DEC $061e, X
@01_a90f:
	DEC $061b, X
	LDA $062a, X
@01_a915:
	STA $0630, X
	LDA $061b, X
	SEC
	SBC $0627, X
	BCS @01_a924
	DEC $061e, X
@01_a924:
	STA $061b, X
	LDA iChannelFlags, X
	AND #SOUND_PITCH_SWAP
	BNE @01_a93e
	LDA iChannelTargetRawPitch + 3, X
	CMP $061e, X
	BCC @01_a955
	LDA iChannelFlags, X
	ORA #SOUND_PITCH_SWAP
	STA iChannelFlags, X
@01_a93e:
	LDA iChannelTargetRawPitch, X
	CMP $061b, X
	BCC @01_a955
	LDA iChannelTargetRawPitch + 3, X
	STA $061e, X
	LDA iChannelTargetRawPitch, X
	STA $061b, X
	JMP ClearPitchSlide
@01_a955:
	JMP UpdatePitch


ClearPitchSlide:
	LDA iChannelFlags, X
	AND #$ff ^ (SOUND_PITCH_SWAP | SOUND_PITCH_SLIDE_DIR | SOUND_PITCH_SLIDE)
	STA iChannelFlags, X
	JSR SwapPitch


UpdatePitch:
	LDA $061b, X
	STA iChannelPitch + 8, X
	JSR UpdateLow
	LDA $061e, X
	CMP iChannelPitch, X
	BEQ @01_a97a
	STA iChannelPitch, X
	JSR UpdateHigh
@01_a97a:
	RTS

SwapPitch:
	CPX #CHAN_2
	BNE @quit
	LDA iChannelPitch, X
	PHA
	LDA $0635
	STA iChannelPitch, X
	PLA
	STA $0635
@quit:
	RTS

Ptrs_01_a98e:
	.dw MPT_01_a9a0
	.dw MPT_01_a9bc
	.dw MPT_01_a9c4
	.dw MPT_01_a9d4
	.dw MPT_01_aa2c
	.dw MPT_01_aa3c
	.dw MPT_01_aa98
	.dw MPT_01_aab4
	.dw MPT_01_aaf8
MPT_01_a9a0:
	.dw PTD_01_ab40, PTD_01_ab81
	.dw PTD_01_ab42, PTD_01_ab92
	.dw PTD_01_ab4b, PTD_01_ab70
	.dw PTD_01_ab54, PTD_01_ab70
	.dw PTD_01_ab5d, PTD_01_ab70
	.dw PTD_01_ab66, PTD_01_aba3
	.dw PTD_01_ab6b, PTD_01_aba3
MPT_01_a9bc:
	.dw PTD_01_abac, PTD_01_abba
	.dw PTD_01_abb5, PTD_01_abba
MPT_01_a9c4:
	.dw PTD_01_abcb, PTD_01_abcd
	.dw PTD_01_abcb, PTD_01_abd0
	.dw PTD_01_abcb, PTD_01_abd3
	.dw PTD_01_abcb, PTD_01_abd6
MPT_01_a9d4:
	.dw PTD_01_abd9, PTD_01_abe3
	.dw PTD_01_abde, PTD_01_abe3
	.dw PTD_01_abf0, PTD_01_abe3
	.dw PTD_01_abfa, PTD_01_ac08
	.dw PTD_01_ac15, PTD_01_ac27
	.dw PTD_01_ac49, PTD_01_ac63
	.dw PTD_01_ac7c, PTD_01_ac82
	.dw PTD_01_ac7f, PTD_01_ac82
	.dw PTD_01_ac87, PTD_01_ac91
	.dw PTD_01_ac8c, PTD_01_ac91
	.dw PTD_01_ac9a, PTD_01_acaf
	.dw PTD_01_acd8, PTD_01_acdf
	.dw PTD_01_afd7, PTD_01_afe7
	.dw PTD_01_abd9, PTD_01_abe3
	.dw PTD_01_abd9, PTD_01_abe3
	.dw PTD_01_abd9, PTD_01_abe3
	.dw PTD_01_abd9, PTD_01_abe3
	.dw PTD_01_abd9, PTD_01_abe3
	.dw PTD_01_abf5, PTD_01_abe3
	.dw PTD_01_ac01, PTD_01_ac08
	.dw PTD_01_ac1e, PTD_01_ac38
	.dw PTD_01_ac56, PTD_01_ac63
MPT_01_aa2c:
	.dw PTD_01_acec, PTD_01_acf1
	.dw PTD_01_ad0d, PTD_01_ad25
	.dw PTD_01_acfa, PTD_01_ad04
	.dw PTD_01_acff, PTD_01_ad04
MPT_01_aa3c:
	.dw PTD_01_ad87, PTD_01_adb9
	.dw PTD_01_ad5c, PTD_01_ad76
	.dw PTD_01_adda, PTD_01_ae06
	.dw PTD_01_ad54, PTD_01_ad59
	.dw PTD_01_ae49, PTD_01_ae67
	.dw PTD_01_ae4e, PTD_01_ae70
	.dw PTD_01_ae53, PTD_01_ae79
	.dw PTD_01_ae23, PTD_01_ae30
	.dw PTD_01_ad87, PTD_01_ad98
	.dw PTD_01_ad5c, PTD_01_ad65
	.dw PTD_01_adda, PTD_01_ade9
	.dw PTD_01_ad54, PTD_01_ad56
	.dw PTD_01_ad5c, PTD_01_ad65
	.dw PTD_01_ad5c, PTD_01_ad65
	.dw PTD_01_ad5c, PTD_01_ad65
	.dw PTD_01_ad5c, PTD_01_ad65
	.dw PTD_01_ad5c, PTD_01_ad65
	.dw PTD_01_ad5c, PTD_01_ad65
	.dw PTD_01_ad5c, PTD_01_ad65
	.dw PTD_01_ad5c, PTD_01_ad65
	.dw PTD_01_ae58, PTD_01_ae67
	.dw PTD_01_ae5d, PTD_01_ae70
	.dw PTD_01_ae62, PTD_01_ae79
MPT_01_aa98:
	.dw PTD_01_ae82, PTD_01_ae8d
	.dw PTD_01_aeb3, PTD_01_aebe
	.dw PTD_01_aee7, PTD_01_aef2
	.dw PTD_01_af12, PTD_01_af1f
	.dw PTD_01_aea2, PTD_01_aea8
	.dw PTD_01_aed3, PTD_01_aeda
	.dw PTD_01_af07, PTD_01_af0b
MPT_01_aab4:
	.dw PTD_01_af38, PTD_01_afc5
	.dw PTD_01_af3d, PTD_01_afc5
	.dw PTD_01_af42, PTD_01_afc5
	.dw PTD_01_af47, PTD_01_afc5
	.dw PTD_01_af4c, PTD_01_afc5
	.dw PTD_01_af51, PTD_01_afc5
	.dw PTD_01_af56, PTD_01_afc5
	.dw PTD_01_af5b, PTD_01_afc5
	.dw PTD_01_af60, PTD_01_afc5
	.dw PTD_01_af65, PTD_01_afc5
	.dw PTD_01_af6a, PTD_01_afc5
	.dw PTD_01_af6f, PTD_01_afc5
	.dw PTD_01_af74, PTD_01_afc5
	.dw PTD_01_af79, PTD_01_afc5
	.dw PTD_01_af7e, PTD_01_afc5
	.dw PTD_01_af83, PTD_01_af86
	.dw PTD_01_af8b, PTD_01_af8d
MPT_01_aaf8:
	.dw PTD_01_af90, PTD_01_afce
	.dw PTD_01_af92, PTD_01_afce
	.dw PTD_01_af95, PTD_01_afce
	.dw PTD_01_af98, PTD_01_afce
	.dw PTD_01_af9b, PTD_01_afce
	.dw PTD_01_af9e, PTD_01_afce
	.dw PTD_01_afa1, PTD_01_afce
	.dw PTD_01_afa4, PTD_01_afce
	.dw PTD_01_afa7, PTD_01_afce
	.dw PTD_01_afaa, PTD_01_afce
	.dw PTD_01_afad, PTD_01_afce
	.dw PTD_01_afb0, PTD_01_afce
	.dw PTD_01_afb3, PTD_01_afce
	.dw PTD_01_afb6, PTD_01_afce
	.dw PTD_01_afb9, PTD_01_afce
	.dw PTD_01_afbc, PTD_01_afce
	.dw PTD_01_afbf, PTD_01_afce
	.dw PTD_01_afc2, PTD_01_afce
PTD_01_ab40:
	.db $01, $00
PTD_01_ab42:
	.db $08, $18, $00, $01, $1a, $19, $02, $11, $1b
PTD_01_ab4b:
	.db $08, $18, $9f, $6c, $1a, $19, $06, $07, $1b
PTD_01_ab54:
	.db $08, $18, $08, $09, $1a, $19, $0a, $0b, $1b
PTD_01_ab5d:
	.db $08, $18, $5c, $0d, $1a, $19, $0e, $9e, $1b
PTD_01_ab66:
	.db $04, $10, $11, $12, $13
PTD_01_ab6b:
	.db $04, $14, $15, $7c, $17
PTD_01_ab70:
	.db $20, $00, $00, $00, $08, $00, $10, $00, $18, $08, $00, $08, $08
	.db $08, $10, $08, $18
PTD_01_ab81:
	.db $21, $00, $00, $00, $08, $00, $10, $00, $18, $08, $00, $08, $08
	.db $08, $10, $08, $18
PTD_01_ab92:
	.db $22, $00, $00, $00, $08, $00, $10, $00, $18, $08, $00, $08, $08
	.db $08, $10, $08, $18
PTD_01_aba3:
	.db $21, $00, $08, $00, $10, $08, $08, $08, $10
PTD_01_abac:
	.db $08, $1c, $1d, $1e, $1f, $1c, $1d, $1e, $1f
PTD_01_abb5:
	.db $04, $1c, $1d, $1e, $1f
PTD_01_abba:
	.db $00, $00, $07, $00, $11, $08, $07, $08, $11, $10, $07, $10, $11
	.db $18, $07, $18, $11
PTD_01_abcb:
	.db $01, $2f
PTD_01_abcd:
	.db $01, $08, $08
PTD_01_abd0:
	.db $41, $08, $10
PTD_01_abd3:
	.db $81, $10, $08
PTD_01_abd6:
	.db $c1, $10, $10
PTD_01_abd9:
	.db $04, $20, $21, $30, $31
PTD_01_abde:
	.db $04, $22, $23, $32, $33
PTD_01_abe3:
	.db $01, $08, $08, $08, $10, $10, $08, $10, $10, $18, $08, $18, $10
PTD_01_abf0:
	.db $04, $24, $25, $34, $35
PTD_01_abf5:
	.db $04, $26, $27, $36, $37
PTD_01_abfa:
	.db $06, $28, $29, $38, $39, $48, $49
PTD_01_ac01:
	.db $06, $2a, $2b, $3a, $3b, $4a, $4b
PTD_01_ac08:
	.db $01, $00, $08, $00, $10, $08, $08, $08, $10, $10, $08, $10, $10
PTD_01_ac15:
	.db $08, $40, $41, $50, $51, $52, $60, $61, $62
PTD_01_ac1e:
	.db $08, $2c, $2d, $3c, $3d, $3e, $4c, $4d, $4e
PTD_01_ac27:
	.db $01, $00, $04, $00, $0c, $08, $04, $08, $0c, $08, $14, $10, $04
	.db $10, $0c, $10, $14
PTD_01_ac38:
	.db $01, $00, $04, $00, $0c, $08, $04, $08, $0c, $08, $14, $10, $04
	.db $10, $0c, $10, $14
PTD_01_ac49:
	.db $0c, $58, $59, $5a, $68, $69, $6a, $78, $79, $7a, $88, $89, $8a
PTD_01_ac56:
	.db $0c, $5d, $5e, $5f, $6d, $6e, $6f, $7d, $7e, $7f, $8d, $8e, $8f
PTD_01_ac63:
	.db $01, $f8, $04, $f8, $0c, $f8, $14, $00, $04, $00, $0c, $00, $14
	.db $08, $04, $08, $0c, $08, $14, $10, $04, $10, $0c, $10, $14
PTD_01_ac7c:
	.db $02, $52, $62
PTD_01_ac7f:
	.db $02, $3e, $4e
PTD_01_ac82:
	.db $01, $00, $00, $08, $00
PTD_01_ac87:
	.db $04, $5a, $6a, $7a, $8a
PTD_01_ac8c:
	.db $04, $5f, $6f, $7f, $8f
PTD_01_ac91:
	.db $01, $00, $00, $08, $00, $10, $00, $18, $00
PTD_01_ac9a:
	.db $14, $98, $99, $a8, $a9, $aa, $b7, $b8, $b9, $ba, $bb, $c7, $c8
	.db $c9, $ca, $cb, $d9, $da, $e9, $ea, $eb
PTD_01_acaf:
	.db $00, $00, $08, $00, $10, $08, $08, $08, $10, $08, $18, $10, $00
	.db $10, $08, $10, $10, $10, $18, $10, $20, $18, $00, $18, $08, $18
	.db $10, $18, $18, $18, $20, $20, $10, $20, $18, $28, $10, $28, $18
	.db $28, $20
PTD_01_acd8:
	.db $06, $ba, $bb, $cb, $e9, $ea, $eb
PTD_01_acdf:
	.db $00, $00, $08, $00, $10, $08, $10, $18, $00, $18, $08, $18, $10
PTD_01_acec:
	.db $04, $60, $61, $70, $71
PTD_01_acf1:
	.db $00, $fc, $18, $fc, $20, $04, $18, $04, $20
PTD_01_acfa:
	.db $04, $02, $03, $12, $13
PTD_01_acff:
	.db $04, $05, $06, $15, $16
PTD_01_ad04:
	.db $00, $fc, $18, $fc, $20, $04, $18, $04, $20
PTD_01_ad0d:
	.db $17, $84, $85, $86, $87, $9d, $94, $95, $96, $97, $ad, $a4, $a5
	.db $a6, $a7, $ca, $8e, $8f, $ae, $af, $9e, $9f, $be, $bf
PTD_01_ad25:
	.db $01, $00, $08, $00, $10, $00, $18, $00, $20, $08, $00, $08, $08
	.db $08, $10, $08, $18, $08, $20, $10, $00, $10, $08, $10, $10, $10
	.db $18, $10, $20, $18, $00, $18, $08, $18, $10, $18, $18, $18, $20
	.db $20, $08, $20, $10, $20, $18, $20, $20
PTD_01_ad54:
	.db $01, $42
PTD_01_ad56:
	.db $00, $00, $10
PTD_01_ad59:
	.db $02, $00, $10
PTD_01_ad5c:
	.db $08, $de, $8c, $df, $ff, $ff, $ee, $8c, $ef
PTD_01_ad65:
	.db $00, $00, $00, $00, $08, $00, $10, $08, $00, $08, $10, $10, $00
	.db $10, $08, $10, $10
PTD_01_ad76:
	.db $02, $00, $00, $00, $08, $00, $10, $08, $00, $08, $10, $10, $00
	.db $10, $08, $10, $10
PTD_01_ad87:
	.db $10, $de, $8c, $8c, $8c, $8c, $8c, $df, $ff, $ff, $ee, $8c, $8c
	.db $8c, $8c, $8c, $ef
PTD_01_ad98:
	.db $00, $00, $00, $00, $08, $00, $10, $00, $18, $00, $20, $00, $28
	.db $00, $30, $08, $00, $08, $30, $10, $00, $10, $08, $10, $10, $10
	.db $18, $10, $20, $10, $28, $10, $30
PTD_01_adb9:
	.db $02, $00, $00, $00, $08, $00, $10, $00, $18, $00, $20, $00, $28
	.db $00, $30, $08, $00, $08, $30, $10, $00, $10, $08, $10, $10, $10
	.db $18, $10, $20, $10, $28, $10, $30
PTD_01_adda:
	.db $0e, $de, $8c, $8c, $8c, $8c, $df, $ff, $ff, $ee, $8c, $8c, $8c
	.db $8c, $ef
PTD_01_ade9:
	.db $00, $00, $00, $00, $08, $00, $10, $00, $18, $00, $20, $00, $28
	.db $08, $00, $08, $28, $10, $00, $10, $08, $10, $10, $10, $18, $10
	.db $20, $10, $28
PTD_01_ae06:
	.db $02, $00, $00, $00, $08, $00, $10, $00, $18, $00, $20, $00, $28
	.db $08, $00, $08, $28, $10, $00, $10, $08, $10, $10, $10, $18, $10
	.db $20, $10, $28
PTD_01_ae23:
	.db $0c, $de, $8c, $8c, $8c, $df, $ff, $ff, $ee, $8c, $8c, $8c, $ef
PTD_01_ae30:
	.db $00, $00, $00, $00, $08, $00, $10, $00, $18, $00, $20, $08, $00
	.db $08, $20, $10, $00, $10, $08, $10, $10, $10, $18, $10, $20
PTD_01_ae49:
	.db $04, $a2, $a3, $a4, $a5
PTD_01_ae4e:
	.db $04, $a6, $a7, $a8, $a9
PTD_01_ae53:
	.db $04, $b2, $b3, $b4, $b5
PTD_01_ae58:
	.db $04, $f0, $f1, $f2, $f3
PTD_01_ae5d:
	.db $04, $f4, $f5, $f6, $f7
PTD_01_ae62:
	.db $04, $f8, $f9, $fa, $fb
PTD_01_ae67:
	.db $01, $00, $00, $00, $08, $08, $00, $08, $08
PTD_01_ae70:
	.db $02, $00, $00, $00, $08, $08, $00, $08, $08
PTD_01_ae79:
	.db $03, $00, $00, $00, $08, $08, $00, $08, $08
PTD_01_ae82:
	.db $0a, $45, $46, $47, $55, $56, $57, $66, $67, $76, $77
PTD_01_ae8d:
	.db $01, $00, $00, $00, $08, $00, $10, $08, $00, $08, $08, $08, $10
	.db $10, $08, $10, $10, $18, $08, $18, $10
PTD_01_aea2:
	.db $05, $53, $54, $87, $44, $97
PTD_01_aea8:
	.db $00, $08, $00, $08, $08, $10, $10, $18, $08, $18, $10
PTD_01_aeb3:
	.db $0a, $63, $64, $73, $74, $81, $82, $83, $91, $92, $93
PTD_01_aebe:
	.db $01, $00, $02, $00, $0a, $08, $02, $08, $0a, $10, $02, $10, $0a
	.db $10, $12, $18, $02, $18, $0a, $18, $12
PTD_01_aed3:
	.db $06, $71, $9b, $9c, $98, $99, $9a
PTD_01_aeda:
	.db $00, $08, $0a, $10, $0a, $10, $12, $18, $02, $18, $0a, $18, $12
PTD_01_aee7:
	.db $0a, $63, $64, $73, $74, $84, $85, $86, $94, $95, $96
PTD_01_aef2:
	.db $01, $00, $00, $00, $08, $08, $00, $08, $08, $10, $00, $10, $08
	.db $10, $10, $18, $00, $18, $08, $18, $10
PTD_01_af07:
	.db $03, $71, $80, $90
PTD_01_af0b:
	.db $00, $08, $08, $10, $0a, $18, $0a
PTD_01_af12:
	.db $0c, $43, $5b, $5b, $65, $fc, $fd, $2e, $fe, $72, $6b, $8b, $75
PTD_01_af1f:
	.db $21, $00, $00, $00, $08, $00, $10, $00, $18, $08, $00, $08, $08
	.db $08, $10, $08, $18, $10, $00, $10, $08, $10, $10, $10, $18
PTD_01_af38:
	.db $04, $a2, $a3, $a4, $a5
PTD_01_af3d:
	.db $04, $a6, $a7, $a8, $a9
PTD_01_af42:
	.db $04, $aa, $ab, $ac, $ad
PTD_01_af47:
	.db $04, $ae, $af, $b0, $b1
PTD_01_af4c:
	.db $04, $b2, $b3, $b4, $b5
PTD_01_af51:
	.db $04, $b6, $b7, $b8, $b9
PTD_01_af56:
	.db $04, $ba, $bb, $bc, $bd
PTD_01_af5b:
	.db $04, $be, $bf, $c0, $c1
PTD_01_af60:
	.db $04, $c2, $c3, $c4, $c5
PTD_01_af65:
	.db $04, $c6, $c7, $c8, $c9
PTD_01_af6a:
	.db $04, $ca, $cb, $cc, $cd
PTD_01_af6f:
	.db $04, $ce, $cf, $d0, $d1
PTD_01_af74:
	.db $04, $d2, $d3, $d4, $d5
PTD_01_af79:
	.db $04, $d6, $d7, $d8, $d9
PTD_01_af7e:
	.db $04, $da, $db, $dc, $dd
PTD_01_af83:
	.db $02, $a0, $a1
PTD_01_af86:
	.db $02, $00, $00, $00, $08
PTD_01_af8b:
	.db $01, $70
PTD_01_af8d:
	.db $01, $00, $00
PTD_01_af90:
	.db $01, $ec
PTD_01_af92:
	.db $02, $e0, $ed
PTD_01_af95:
	.db $02, $e0, $ec
PTD_01_af98:
	.db $02, $e1, $ed
PTD_01_af9b:
	.db $02, $e1, $ec
PTD_01_af9e:
	.db $02, $e2, $ed
PTD_01_afa1:
	.db $02, $e3, $ed
PTD_01_afa4:
	.db $02, $e4, $ed
PTD_01_afa7:
	.db $02, $e5, $ed
PTD_01_afaa:
	.db $02, $e6, $ed
PTD_01_afad:
	.db $02, $e7, $ed
PTD_01_afb0:
	.db $02, $e8, $ed
PTD_01_afb3:
	.db $02, $e9, $ed
PTD_01_afb6:
	.db $02, $ea, $ed
PTD_01_afb9:
	.db $02, $eb, $ed
PTD_01_afbc:
	.db $02, $e0, $7b
PTD_01_afbf:
	.db $02, $e1, $7b
PTD_01_afc2:
	.db $02, $e3, $7b
PTD_01_afc5:
	.db $03, $00, $00, $00, $08, $08, $00, $08, $08
PTD_01_afce:
	.db $00, $00, $00, $00, $08, $08, $00, $08, $08
PTD_01_afd7:
	.db $0f, $13, $03, $0f, $12, $05, $0c, $05, $16, $05, $0c, $13, $10
	.db $05, $05, $04
PTD_01_afe7:
	.db $03, $f8, $00, $f8, $08, $f8, $10, $f8, $18, $f8, $20, $00, $00
	.db $00, $08, $00, $10, $00, $18, $00, $20, $08, $00, $08, $08, $08
	.db $10, $08, $18, $08, $20

Pal_01_b006:
	.db $0f, $26, $29, $20
	.db $0f, $26, $21, $20
	.db $0f, $29, $28, $16
	.db $0f, $26, $28, $20
	.db $0f, $0f, $29, $20
	.db $0f, $31, $29, $30
	.db $0f, $1a, $29, $39
	.db $0f, $12, $11, $0f

	.db $0f, $2a, $1a, $20
	.db $0f, $27, $1a, $20
	.db $0f, $2a, $37, $20
	.db $0f, $09, $1a, $3a
	.db $0f, $16, $20, $20
	.db $0f, $16, $0f, $20
	.db $0f, $3a, $0f, $24
	.db $0f, $37, $0f, $20

	.db $0f, $29, $27, $20
	.db $0f, $1b, $27, $27
	.db $0f, $16, $27, $20
	.db $0f, $0b, $27, $20
	.db $0f, $16, $20, $2b
	.db $0f, $32, $0c, $2a
	.db $0f, $26, $2f, $17
	.db $0f, $23, $0f, $01

	.db $12, $16, $0f, $20
	.db $12, $29, $0f, $20
	.db $12, $27, $0f, $20
	.db $12, $2a, $0f, $20
	.db $12, $16, $0f, $20
	.db $12, $29, $0f, $20
	.db $12, $27, $0f, $20
	.db $12, $00, $20, $22

	.db $12, $16, $0f, $20
	.db $12, $29, $0f, $20
	.db $12, $27, $0f, $20
	.db $12, $2b, $0f, $20
	.db $12, $16, $0f, $20
	.db $12, $29, $0f, $20
	.db $12, $27, $0f, $20
	.db $12, $00, $0f, $26

	.db $0f, $12, $16, $20
	.db $0f, $29, $16, $20
	.db $0f, $20, $02, $36
	.db $0f, $08, $06, $06
	.db $0f, $16, $0f, $28
	.db $0f, $29, $0f, $20
	.db $0f, $16, $0f, $20
	.db $0f, $26, $0f, $29

	.db $0f, $16, $0f, $20
	.db $0f, $16, $29, $20
	.db $0f, $27, $29, $20
	.db $0f, $26, $29, $20
	.db $0f, $24, $29, $20
	.db $0f, $34, $0f, $2b
	.db $0f, $24, $20, $04
	.db $0f, $14, $17, $13

	.db $12, $16, $0f, $20
	.db $12, $29, $0f, $20
	.db $12, $27, $0f, $20
	.db $12, $25, $0f, $20
	.db $12, $16, $0f, $20
	.db $12, $29, $0f, $20
	.db $12, $27, $0f, $20
	.db $12, $00, $20, $22

Data_01_b106:
	.db $20, $25, $15, $da, $da, $da, $da, $da, $da, $da, $da, $da, $da
	.db $da, $da, $da, $da
	.db $da, $da, $da, $da, $da, $da, $da, $da, $20, $45, $16, $da, $da
	.db $da, $da, $da, $6b, $6c, $6d, $6e, $da, $b0, $b1, $b2, $b3, $b4
	.db $b5, $b6, $b7, $b8, $da, $da, $da, $0c, $20, $65, $16, $da, $da
	.db $78, $79, $7a, $7b, $7c, $7d, $7e, $7f, $c0, $c1, $c2, $c3, $c4
	.db $c5, $c6, $c7, $c8, $c9, $da, $da, $0c, $20, $85, $16, $da, $da
	.db $88, $89, $8a, $8b, $8c, $8d, $8e, $8f, $d0, $d1, $d2, $d3, $d4
	.db $d5, $d6, $d7, $d8, $d9, $da, $da, $0c, $20, $a5, $16, $da, $da
	.db $98, $99, $9a, $9b, $9c, $9d, $9e, $9f, $e0, $e1, $e2, $e3, $e4
	.db $e5, $e6, $e7, $e8, $e9, $da, $da, $0c, $20, $c5, $16, $da, $da
	.db $da, $da, $aa, $ab, $ac, $ad, $ae, $af, $f0, $f1, $f2, $f3, $f4
	.db $f5, $f6, $f7, $f8, $f9, $da, $da, $0c, $20, $e5, $16, $da, $da
	.db $da, $da, $ba, $bb, $bc, $bd, $be, $bf, $ea, $eb, $ec, $ed, $ee
	.db $ef, $47, $48, $a8, $a9, $da, $da, $0c, $21, $05, $16, $da, $da
	.db $da, $da, $da, $cb, $cc, $cd, $ce, $cf, $fa, $fb, $fc, $fd, $fe
	.db $80, $6f, $64, $65, $da, $da, $da, $0c, $21, $25, $16, $da, $da
	.db $da, $da, $da, $db, $dc, $dd, $de, $df, $da, $0f, $1f, $2f, $3f
	.db $4f, $68, $74, $75, $da, $da, $da, $0c, $21, $45, $16, $da, $da
	.db $da, $da, $da, $da, $da, $da, $da, $da, $da, $da, $da, $da, $da
	.db $da, $da, $da, $da, $da, $da, $da, $0c, $21, $66, $15, $0c, $0c
	.db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
	.db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $20, $38, $01, $25, $26, $21
	.db $8e, $0d, $51, $52, $53, $00, $52, $53, $54, $55, $56, $57, $58
	.db $59, $5a, $5b, $21, $a9, $04, $00, $01, $02, $03, $04, $21, $c9
	.db $04, $10, $11, $12, $13, $14, $21, $e9, $04, $20, $21, $22, $23
	.db $24, $22, $09, $04, $30, $31, $32, $33, $34, $22, $2a, $06, $07
	.db $08, $09, $0a, $0b, $00, $0d, $22, $4b, $05, $18, $19, $1a, $1b
	.db $1c, $1d, $22, $6b, $05, $28, $29, $2a, $2b, $2c, $2d, $22, $8b
	.db $06, $38, $39, $3a, $3b, $3c, $3d, $3e, $22, $ab, $06, $00, $00
	.db $4a, $4b, $4c, $4d, $4e, $22, $ce, $03, $5c, $5d, $5e, $5f, $22
	.db $53, $02, $62, $63, $81, $22, $73, $03, $72, $73, $82, $83, $22
	.db $93, $03, $90, $91, $92, $93, $22, $b3, $03, $a0, $a1, $a2, $a3
	.db $22, $d3, $03, $0e, $1e, $2e, $6a, $23, $0e, $06, $40, $41, $42
	.db $43, $44, $45, $46, $23, $4e, $06, $50, $41, $42, $43, $44, $45
	.db $46
