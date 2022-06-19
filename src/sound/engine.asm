UpdateSound:
; This routine is responsible for what we hear
	LDX #CHAN_0
	LDY #0
@loop:
	TXA
	ASL A
	ASL A
	STA zChannelOffset
	CPX #CHAN_3
	BEQ @music_chan
	BCS @01_9e9e
@music_chan:
	LDA iMusicTracks
	AND ChannelMasks, X
	BEQ @01_9eb3
	BCS @01_9ea8
	LDA iChannelTracks, X
	BEQ @01_9ea5
	LDA iMusicTracks
	AND #1 << CHAN_3 | 1 << CHAN_2 | 1 << CHAN_1 | 1 << CHAN_0
	BEQ @next_chan
	BNE @01_9ea5
@01_9e9e:
	LDA iMusicTracks
	AND #1 << CHAN_3 | 1 << CHAN_2 | 1 << CHAN_1 | 1 << CHAN_0
	BEQ @01_9eb3
@01_9ea5:
	JSR TurnOffEnvelopes
@01_9ea8:
	; turn on $06be
	LDA $06be
	ORA ChannelMasks, X
	STA $06be
	BNE @next_chan
@01_9eb3:
	; is (X)$06be on?
	LDA $06be
	AND ChannelMasks, X
	BEQ @01_9ed0
	LDA $06be
	EOR ChannelMasks, X
	STA $06be
	LDA zChannelOffset
	AND #PSG_MASK
	CMP #SQ1_LO - SQ1_ENV
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
	; are we beginning a new note?
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
	BCS @could_be_hill
	; no
	; is (X)iChannelTracks a non-zero
	LDA iChannelTracks, X
	BNE @could_be_hill
	; no
	; is SOUND_VIBRATO_7 active?
	LDA iChannelVibratoFlags, X
	ROL A
	BCC @could_be_hill
	; yes
	; is SOUND_VIBRATO_DIR active?
	ROL A
	BCC @01_9f3c ; skip ahead if not
	; yes
	; does the counter match the vibrato delay?
	LDA iChannelVibratoDelay, X
	CMP iChannelVibratoCounter, X
	BEQ @01_9f32
	; not quite, increment the counter
	INC iChannelVibratoCounter, X
	JMP @01_9fb8 ; skip to the volume ramp now
@01_9f32:
	; only if the counter matches
	; reset the counter
	LDA #0
	STA iChannelVibratoCounter, X
	; set SOUND_VIBRATO_7 and SOUND_VIBRATO_0 for (X)iChannelVibratoFlags
	LDA #SOUND_VIBRATO_7 | SOUND_VIBRATO_0
	STA iChannelVibratoFlags, X
@01_9f3c:
	; is SOUND_VIBRATO_2 active?
	LDA iChannelVibratoFlags, X
	AND #SOUND_VIBRATO_2
	BEQ @01_9f48 ; don't mess with it if not
	; else, only SOUND_VIBRATO_7 should be active at this point
	LDA #SOUND_VIBRATO_7
	STA iChannelVibratoFlags, X
@01_9f48:
	; put the channel offset in Y
	LDA zChannelOffset
	AND #PSG_MASK
	TAY
	; is SOUND_VIBRATO_DIR active?
	LDA iChannelVibratoFlags, X
	AND #SOUND_VIBRATO_DIR
	BEQ @01_9f8e ; only use counter for speed then
	; else, does the counter match the speed?
	LDA iChannelVibratoSpeed, X
	CMP iChannelVibratoCounter, X
	BEQ @01_9f7d ; change pitch if a match appears
	; else, increment the counter
	INC iChannelVibratoCounter, X
@could_be_hill:
	; hill channel?
	CPX #CHAN_6
	BEQ @01_9f6a
	CPX #CHAN_2
	BEQ @01_9f6a
	; no, just skip to volume ramp
	JMP @01_9fb8
@01_9f6a:
	; else, let's go ahead with this
	; do (X)iChannelNoteLength and (X)iChannelNoteInFrames match?
	LDA iChannelNoteLength, X
	CMP iChannelNoteInFrames, X
	BNE @01_9f7c
	; yes, so check if (X)iChannelTracks is active
	JSR ChannelCheckProceedure
	BCS @01_9f7c ; leave if active
	; else, update the respective register
	LDA #Linear_Flag
	JMP UpdateEnv
@01_9f7c:
	RTS
@01_9f7d:
	; sub the pitch
	LDA iChannelPitch + 8, X
	SEC
	SBC iChannelVibratoDepth, X
	BCS @01_9fad ; updating R3 would retrigger the note
	; reset the R2
	LDA #0
	STA SQ1_LO, Y
	JMP @vibrato_reset ; reset the counter
@01_9f8e:
	; does the counter match the speed?
	LDA iChannelVibratoSpeed, X
	CMP iChannelVibratoCounter, X
	BEQ @01_9f9c ; update pitch if so
	; else, increment and skip to volume ramp
	INC iChannelVibratoCounter, X
	JMP @01_9fb8
@01_9f9c:
	; add the pitch
	LDA iChannelPitch + 8, X
	CLC
	ADC iChannelVibratoDepth, X
	BCC @01_9fad ; update R3 would retrigger the note
	; max out R2
	LDA #-1
	STA SQ1_LO, Y
	JMP @vibrato_reset ; reset the counter
@01_9fad:
	STA SQ1_LO, Y
@vibrato_reset:
	; reset the counter
	LDA #0
	STA iChannelVibratoCounter, X
	INC iChannelVibratoFlags, X
@01_9fb8:
	; check the volume ramp
	LDA iChannelVolumeRamp, X
	AND #Ramp_Mask
	BNE @01_9fc0 ; ret z if zero
	RTS
@01_9fc0:
	; do (X)iChannelNoteLength and (X)iChannelNoteInFrames match?
	LDA iChannelNoteLength, X
	CMP iChannelNoteInFrames, X
	BCC @01_a00f ; fade if not
	; else, test SOUND_INSTRUMENT
	LDA iChannelFlags, X
	AND #SOUND_INSTRUMENT
	BEQ @01_9fda ; start instrument if inactive
	; else, check the instrument counter
	LDA iChannelInsVolume, X
	BEQ @subtract ; apply volume if zero
	; else, decrement
	DEC iChannelInsVolume, X
	JMP @measure_volume ; fade it out
@01_9fda:
	; use iChannelInsParam as a word offset
	; params are only 7-bit, so the highest bit is occupied by a power flag
	LDA iChannelInsParam, X
	ASL A
	TAY
	LDA (zInstrumentPointer), Y
	STA zCurrentInstrumentAddress
	INY
	LDA (zInstrumentPointer), Y
	STA zCurrentInstrumentAddress + 1
@01_9fe8:
	LDA iChannelInsVolume, X
	INC iChannelInsVolume, X
	TAY
	; get the current byte
	LDA (zCurrentInstrumentAddress), Y
	; $fe/$ff?
	CMP #env_loop_cmd
	BCC @01_a005 ; byte
	BEQ @01_9ffd ; 
	DEC iChannelInsVolume, X
	JMP @subtract
@01_9ffd:
	INY
	LDA (zCurrentInstrumentAddress), Y
	STA iChannelInsVolume, X
	BNE @01_9fe8
@01_a005:
	LDA (zCurrentInstrumentAddress), Y
	BEQ @zipper_and_update
	STA iChannelVolumeRamp, X
	JMP @subtract
@01_a00f:
	LDA iChannelFadeCounter, X
	BEQ @01_a019
	DEC iChannelFadeCounter, X
	BNE @quit
@01_a019:
	; in [Du][vv][wx][yz]:
	; y - fade tick length
	; z - note tail length
	LDA iChannelEnvExtension, X
	HTL A
	STA iChannelFadeCounter, X
@measure_volume:
	; are we still above 1?
	LDA iChannelVolumeRamp, X
	CMP #1
	BEQ @subtract
	DEC iChannelVolumeRamp, X
@subtract:
	LDA iChannelVolumeRamp, X
	SEC
	SBC iChannelVolumeOffset, X
	BEQ @minimum_volume
	BCS @zipper_and_update
@minimum_volume:
	LDA #1
@zipper_and_update:
	ORA iChannelTimbre, X
	JSR ChannelCheckProceedure
	BCS @quit
	JMP UpdateEnv
@quit:
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
; this function is buggy: the same loop can only be encountered 128 times
; before treating a negative value as 0
; to fix use BCC instead of BMI
	; safe increment loop counter
	LDA iChannelLoopCounter, X
	CLC
	ADC #1
	; stack up to byte shown
	; are we done? did we exceed the byte shown?
	INY
	CMP (zMusicAddress), Y
	BEQ @end_loop
	BMI @use_loop ; BCC would be more appropriate
	; we exceed the byte shown, this is what happens when we loop with 0
	SEC
	SBC #1
@use_loop:
	; store A in the loop counter and perform the standard jump
	STA iChannelLoopCounter, X
	JSR UpdateMusicAddress
	JSR CopyMusicAddress
	JMP ParseByte
@end_loop:
	; clear the loop counter
	LDA #0
	STA iChannelLoopCounter, X
	; skip the parameters
	YAD 3
	; update the music address
	TYA
	CLC
	ADC zMusicAddress
	STA iChannelAddress, X
	LDA #0
	ADC zMusicAddress + 1
	STA iChannelAddress + 8, X
	JSR CopyMusicAddress
	JMP ParseByte
@track_end:
	LDA iChannelID, X
	STA zMusicTempID
	LDA #0
	STA iChannelID, X
	STA iChannelPitch, X
	STA iAlternatePitch
	STA iChannelFlags, X
	LDA zMusicTempID
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
	LDA i6b9
	BNE @01_a10d
	JMP ApplyPulse1
@01_a0fc:
	CPX #CHAN_5
	BNE @01_a10d
	LDA iChannelID + 1
	BEQ @01_a10d
	LDA i6b9
	BNE @01_a10d
	JMP ApplyPulse2
@01_a10d:
	LDA #0
	STA iChannelPitch, X
	STA iAlternatePitch
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
	BEQ @sfx_cmds
	JMP SearchCommand_Tier1
@sfx_cmds:
	LDA (zMusicAddress), Y
	AND #%11110000
	CMP #sfx_type_cmd
	BNE @sfx_pitch_inc
	LDA (zMusicAddress), Y
	AND #NOTE_LENGTH_MASK
	STA iChannelNoteTypeLength, X
	INY
	CPX #CHAN_2
	BEQ @not_pulse
	CPX #CHAN_6
	BEQ @not_pulse
	LDA (zMusicAddress), Y
	AND #Cycle_Mask | Volume_Loop_F | Volume_Ramp_F
@not_pulse:
	STA iChannelTimbre, X
	LDA (zMusicAddress), Y
	AND #Ramp_Mask
	STA iChannelVolumeRamp, X
	JMP ParseNextByte
@sfx_pitch_inc:
	LDA (zMusicAddress), Y
	CMP #sfx_pitch_inc_switch_cmd
	BNE @pitch_sweep
	LDA iChannelFlags, X
	ORA #SOUND_PITCH_INC
	STA iChannelFlags, X
	JMP ParseNextByte
@pitch_sweep:
	CMP #pitch_sweep_cmd
	BNE @sfx_note
	INY
	LDA (zMusicAddress), Y
	JSR ChannelCheckProceedure
	BCS @set_sweep_flag
	JSR UpdateSweep
@set_sweep_flag:
	LDA iChannelFlags, X
	ORA #SOUND_PITCH_SWEEP
	STA iChannelFlags, X
	JMP ParseNextByte
@sfx_note:
	LDA iChannelNoteTypeLength, X
	STA iChannelNoteLength, X
	CPX #CHAN_2
	BEQ @pitch
	CPX #CHAN_6
	BEQ @pitch
	LDA iChannelTimbre, X
	AND #Volume_Ramp_F
	BNE @skip_volume
	LDA iChannelVolumeRamp, X
	ORA iChannelTimbre, X
	JMP @update_env
@skip_volume:
	LDA (zMusicAddress), Y
	CMP #sound_filler_cmd
	BNE @zipper_env
	INY
	LDA (zMusicAddress), Y
@zipper_env:
	HTL A
	STA iChannelVolumeRamp, X
	ORA iChannelTimbre, X
	JSR ChannelCheckProceedure
	BCS @pitch
@update_env:
	JSR UpdateEnv
@pitch:
	LDA (zMusicAddress), Y
	AND #PITCH_HI_MASK
	STA zCurrentTrackPitch
	INY
	LDA (zMusicAddress), Y
	STA zCurrentTrackPitch + 1
	JSR ApplyPitch
	JMP IncrementMusicAddress


SearchCommand_Tier1:
	; are we looking for commands at this point.
	; first order of business, did we encounter $d0?
	LDA (zMusicAddress), Y
	AND #%11110000
	CMP #note_type_cmd
	BEQ @note_type
	JMP SearchCommand_Tier2 ; jump and look for other commands
	; from here, we piece together $d0's parameters
	; for ch0-1: [Du][vv][wx][yz]
	; for ch2: [Du][vv]
	; for ch3: [Du]
@note_type:
	; u - note legnth
	LDA (zMusicAddress), Y
	AND #NOTE_LENGTH_MASK
	STA iChannelNoteTypeLength, X
	INY
	CPX #CHAN_3 ; drum speeds are one byte
	BNE @main_param
	JMP ParseByte
@main_param:
	; vv - main parameter (raw envelope)
	LDA (zMusicAddress), Y
	STA iChannelNoteTypeMainParam, X
	CPX #CHAN_2
	BEQ @hill_type
	CPX #CHAN_6
	BNE @timbre
@hill_type:
	STA iChannelEnvExtension, X
	JMP ParseNextByte
@timbre:
	AND #Cycle_Mask | Volume_Loop_F | Volume_Ramp_F
	STA iChannelTimbre, X
	LDA iChannelNoteTypeMainParam, X
	AND #Ramp_Mask
	STA iChannelVolumeRamp, X
	INY
	; hack proof (for some reason)
	CPX #CHAN_2
	BEQ @skip_to_cmd
	CPX #CHAN_6
	BNE @instrument
@skip_to_cmd:
	JMP SearchCommand_Tier2
@instrument:
	; w - use raw volume?
	; x - instrument ID if w = 0
	LDA (zMusicAddress), Y
	STA iChannelInsParam, X
	AND #NOTE_BLOCK_INSTRUMENT
	BEQ @use_ins
	; read the same byte from before
	LDA (zMusicAddress), Y
	AND #NOTE_ID_MASK
	; store as the ID
	STA iChannelInsID, X
	; set SOUND_INSTRUMENT
	LDA iChannelFlags, X
	ORA #SOUND_INSTRUMENT
	BNE @extension
@use_ins:
	; clear SOUND_INSTRUMENT
	LDA iChannelFlags, X
	AND #$ff ^ SOUND_INSTRUMENT
@extension:
	STA iChannelFlags, X
	; yz - post instrument extension
	INY
	LDA (zMusicAddress), Y
	STA iChannelEnvExtension, X
	JMP ParseNextByte


SearchCommand_Tier2:
; rummage for commands $e0-$ef
	LDA (zMusicAddress), Y
	AND #%11110000
	CMP #octave_cmd
	BEQ @match
	; not a match, probably volume
	JMP SearchCommand_Volume
@match:
	LDA (zMusicAddress), Y
	AND #%00001111
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
; Parameters: [Ex]
;	x - value
	LDA (zMusicAddress), Y
	AND #%00001111
	STA iChannelOctave, X
	JMP ParseNextByte

Pitch_Inc_Switch:
; increment pitch value (flattens note)
; Parameters: none
	LDA iChannelFlags, X
	EOR #SOUND_PITCH_INC
	STA iChannelFlags, X
	JMP ParseNextByte

Frame_Swap:
; queue animation
; Parameters: none
	PHA
	PHX
	JSR Sub_07_f71d
	PLX
	PLA
	JMP ParseNextByte

Vibrato:
; Parameters [EA][xx][yz]
;	x - length, (command ends if 0)
;	y - depth
;	z - speed (in frame pairs)
	INY
	LDA (zMusicAddress), Y
	BNE @non_zero
	LDA #0
	STA iChannelVibratoFlags, X
	JMP ParseNextByte
@non_zero:
	STA iChannelVibratoDelay, X
	INY
	LDA (zMusicAddress), Y
	AND #VIBRATO_SPEED_MASK
	STA iChannelVibratoSpeed, X
	LDA (zMusicAddress), Y
	HTL A
	STA iChannelVibratoDepth, X
	LDA #0
	STA iChannelVibratoCounter, X
	LDA #SOUND_VIBRATO_7 | SOUND_VIBRATO_6 | SOUND_VIBRATO_0
	STA iChannelVibratoFlags, X
	JMP ParseNextByte

Dummy:
; would've been cycle ID
; Parameters: none
	JMP ParseNextByte

Tempo:
; Parameters: [ED][hhll]
;	hhll - tempo value
	INY
	CPX #CHAN_4
	BCS @sfx
	LDA (zMusicAddress), Y
	STA iMusicTempo
	INY
	LDA (zMusicAddress), Y
	STA iMusicTempo + 1
	LDA #0
	STA iMusicTempoOffset
	STA iMusicTempoOffset + 1
	STA iMusicTempoOffset + 2
	STA iMusicTempoOffset + 3
	JMP ParseNextByte
@sfx:
	LDA (zMusicAddress), Y
	STA iSFXTempo
	INY
	LDA (zMusicAddress), Y
	STA iSFXTempo + 1
	LDA #0
	STA iSFXTempoOffset
	STA iSFXTempoOffset + 1
	STA iSFXTempoOffset + 2
	JMP ParseNextByte

New_Song:
; Parameters: [EE][xx]
;	x - song ID
	JSR PlayNewSong
	JMP ParseNextByte

Channel_Mute:
; Parameters: none
	LDA z34
	BMI @quit
	CPX #CHAN_4
	BCS @quit
	LDA $0328
	ORA $0329
	AND #$f0
	BNE @quit
	LDA Channel_Masks, X
	ORA iMusicTracks
	STA iMusicTracks
	LDA #1
	STA iChannelNoteLength, X
	JMP IncrementMusicAddress
@quit:
	JMP ParseNextByte

Channel_Masks:
	.db $80, $40, $20, $10

Pitch_Slide:
; parameters: [EB][0v][wx][yz]
;	v - ticks remaining when note is reached
;	w - octave
;	x - note ID
;	y - base note ID (or channel volume)
;	z - note length (or volume dec ammount)
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
	; get the volume offset
	LDA (zMusicAddress), Y
	AND #VOL_OFFSET_MASK
	STA iChannelVolumeOffset, X
	JMP ParseNextByte

GetDrumPitch:
; play a drum note as if it was a pitch
	LDA (zMusicAddress), Y
	; rest?
	AND #PITCH_ID_MASK
	CMP #NOTE_REST << 4
	BEQ PlayQuit
	; no, drum note?
	JSR DrumCheckProceedure
	BCS PlayQuit
	; yes, is it B_?
	HTL A
	CMP #B_
	BNE PlayFromPitch
	; then load the ID in byte two!

PlayNewSong:
	; load A with song ID
	INY
	LDA (zMusicAddress), Y
	PHA ; save while we zipper the musical program counter
	JSR IncrementMusicAddress
	PLA
PlayFromPitch:
	JSR PlayAudio
	JSR GetChannelID
PlayQuit:
	RTS

GetNoteLength:
; obtain the length in frames the current note will last
	; zipper the counter
	JSR IncrementMusicAddress
	; load the note in A
	DEY
	LDA (zMusicAddress), Y
	; isolate the length
	AND #NOTE_LENGTH_MASK
	STA zMusicTempNoteLength
	INC zMusicTempNoteLength
	LDA #0
	STA zMusicNoteCalcBuffer
	STA zMusicTempoCalcBuffer
	LDA iChannelNoteTypeLength, X
	STA zMusicTempNoteType
@01_a3a0:
	LSR zMusicTempByte
	BCC @01_a3ab
	LDA zMusicTempNoteType
	CLC
	ADC zMusicNoteCalcBuffer
	STA zMusicNoteCalcBuffer
@01_a3ab:
	ASL zMusicTempNoteType
	LDA zMusicTempByte
	BNE @01_a3a0
	CPX #PITCH_HI_MASK
	BCC @copy_tempo
	LDA zMusicNoteCalcBuffer
	JMP @01_a3f2
@copy_tempo:
	; are we in a sfx channel?
	CPX #CHAN_4
	BCC @not_sfx_tempo
	; yes, so copy the designated tempo
	LDA iSFXTempo
	STA zCurrentTempo
	LDA iSFXTempo + 1
	STA zCurrentTempo + 1
	JMP @01_a3d5
@not_sfx_tempo:
	LDA iMusicTempo
	STA zCurrentTempo
	LDA iMusicTempo + 1
	STA zCurrentTempo + 1
@01_a3d5:
	LSR zMusicNoteCalcBuffer
	BCC @01_a3e8
	LDA zCurrentTempo + 1
	CLC
	ADC iMusicTempoOffset, X
	STA iMusicTempoOffset, X
	LDA zCurrentTempo
	ADC zMusicTempoCalcBuffer
	STA zMusicTempoCalcBuffer
@01_a3e8:
	ASL zCurrentTempo + 1
	ROL zCurrentTempo
	LDA zMusicNoteCalcBuffer
	BNE @01_a3d5
	LDA zMusicTempoCalcBuffer
@01_a3f2:
	STA iChannelNoteLength, X
	CPX #CHAN_3
	BNE @normal_pitch
	JMP GetDrumPitch
@normal_pitch:
	LDA (zMusicAddress), Y
	AND #PITCH_ID_MASK
	CMP #NOTE_REST << 4
	BNE @get_pitch
	LDA #0
	STA iChannelVolumeRamp, X
	CPX #CHAN_2
	BEQ @hill_rest
	CPX #CHAN_6
	BEQ @hill_rest
	LDA #Volume_Loop_F | Volume_Ramp_F
	ORA iChannelTimbre, X
	JSR ChannelCheckProceedure
	BCS @subexit
@hill_rest:
	JMP UpdateEnv
@subexit:
	RTS
@get_pitch:
	CPX #CHAN_3
	BCS @env_ext
	; is SOUND_VIBRATO_7 active?
	LDA iChannelVibratoFlags, X
	ROL A
	BCC @env_ext
	; yes
	; set bits 7, 6, and 0
	LDA #SOUND_VIBRATO_7 | SOUND_VIBRATO_6 | SOUND_VIBRATO_0
	STA iChannelVibratoFlags, X
	LDA #0
	STA iChannelVibratoCounter, X
@env_ext:
	LDA iChannelEnvExtension, X
	AND #NOTE_TAIL_MASK ; get tail
	; did we set the z flag?
	STA zMusicTempNoteLength
	BEQ @main_param ; branch if z
	; else, start with 0 on the hi byte
	LDA #0
	STA zMusicTempNoteLength + 1
@loop:
	; add note length
	CLC
	ADC iChannelNoteLength, X
	BCC @no_carry
	; increment hi byte if c
	INC zMusicTempNoteLength + 1
@no_carry:
	; if we match zMusicTempNoteLength, we exit the loop
	DEC zMusicTempNoteLength
	BNE @loop
	; we're safe to store A now
	STA zMusicTempNoteLength
	LDA #4
	STA zByteCount
@01_a452:
	; divide word by 2
	LSR zMusicTempNoteLength + 1
	ROR zMusicTempNoteLength
	DEC zByteCount
	BNE @01_a452 ; never branches
	LDA zMusicTempNoteLength
@main_param:
	; store the result in (X)iChannelNoteInFrames
	STA iChannelNoteInFrames, X
	; get byte two of our note settings
	LDA iChannelNoteTypeMainParam, X
	; hill channel?
	CPX #CHAN_2
	BEQ @update ; immediately update if so
	CPX #CHAN_6
	BEQ @update
	; for the pulse channels
	; SOUND_INSTRUMENT set?
	LDA iChannelFlags, X
	AND #SOUND_INSTRUMENT
	BNE @copy_ins
	; no
	PHY
	LDA iChannelInsParam, X
	ASL A
	TAY
	LDA (zInstrumentPointer), Y
	STA zCurrentInstrumentAddress
	INY
	LDA (zInstrumentPointer), Y
	STA zCurrentInstrumentAddress + 1
	LDY #0
	LDA (zCurrentInstrumentAddress), Y
	ORA iChannelTimbre, X
	STA iChannelNoteTypeMainParam, X
	LDA #1
	STA iChannelInsVolume, X
	PLY
	JMP @get_volume
@copy_ins:
	LDA iChannelInsParam, X
	AND #NOTE_ID_MASK
	STA iChannelInsID, X
@get_volume:
	LDA iChannelNoteTypeMainParam, X
	AND #Ramp_Mask
	STA iChannelVolumeRamp, X
	SEC
	SBC iChannelVolumeOffset, X
	BCS @zipper_env
	LDA #0
@zipper_env:
	ORA iChannelTimbre, X
	JSR ChannelCheckProceedure
	BCS @get_raw_pitch
@update:
	JSR UpdateEnv
@get_raw_pitch:
	LDA (zMusicAddress), Y
	HTL A
	ASL A
	TAY
	LDA Pitches + 1, Y
	STA zCurrentTrackPitch
	LDA Pitches, Y
	STA zCurrentTrackPitch + 1
	LDY iChannelOctave, X
@01_a4cd:
	CPY #NUM_OCTAVES - 1
	BEQ ApplyPitch
	LSR zCurrentTrackPitch
	ROR zCurrentTrackPitch + 1
	INY
	JMP @01_a4cd

ApplyPitch:
	; pitch_inc flag
	LDA iChannelFlags, X
	AND #SOUND_PITCH_INC
	BEQ @apply_pitch
	INC zCurrentTrackPitch + 1
	BNE @apply_pitch
	INC zCurrentTrackPitch
@apply_pitch:
	; make the sound audible
	LDA zCurrentTrackPitch
	ORA #8
	STA zCurrentTrackPitch
	CPX #CHAN_2
	BEQ @hill
	CPX #CHAN_6
	BEQ @apply_upper
	CMP iChannelPitch, X
	BNE @tether_pitch
	CPX #CHAN_7
	BEQ @apply_lower
	LDA iChannelTimbre, X
	AND #Volume_Ramp_F
	BEQ @apply_upper
	LDA iChannelFlags, X
	AND #SOUND_PITCH_SWEEP
	BNE @apply_upper
	BEQ @apply_lower
@hill:
	STA iAlternatePitch
	JMP @apply_upper
@tether_pitch:
	STA iChannelPitch, X
@apply_upper:
	LDA zCurrentTrackPitch
	JSR ChannelCheckProceedure
	BCS @apply_lower
	JSR UpdateHigh
@apply_lower:
	LDA zCurrentTrackPitch + 1
	STA iChannelPitch + 8, X
	JSR ChannelCheckProceedure
	BCS @quit
	JSR UpdateLow
	CPX #CHAN_3
	BCS @quit
	LDA iChannelFlags, X
	AND #SOUND_PITCH_SLIDE
	BEQ @quit
	JSR ApplyPitchSlide
@quit:
	RTS

.include "src/sound/notes.asm"

CopyMusicAddress:
	LDY #0
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
	ADC #0
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
	STA zMusicTempByte
	LDA zChannelOffset
	AND #PSG_MASK
	TAX
	LDA zMusicTempByte
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
	LDA iChannelTracks + 2
	BEQ CheckProClearCarry
	BNE CheckProSetCarry

ChannelCheckProceedure:
	; pulse 0?
	PHA
	CPX #CHAN_0
	BNE @01_a5f4
	; okay
	; is iChannelTracks zero?
	LDA iChannelTracks
	BEQ CheckProClearCarry
	BNE CheckProSetCarry
@01_a5f4:
	; hill? drums?
	CPX #CHAN_2
	BCS @01_a5ff
	; then we're on Pulse 1
	; is iChannelTracks + 1 zero?
	LDA iChannelTracks, X
	BEQ CheckProClearCarry
	BNE CheckProSetCarry
@01_a5ff:
	; hill or drums?
	CPX #CHAN_2
	BNE CheckProClearCarry
	; then we're on hill
	; is iChannelTracks + 2 zero?
	LDA iChannelTracks + 2
	BEQ CheckProClearCarry
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
	AND #PSG_MASK
	TAY
	LDA Env_Off, X
	STA SQ1_ENV, Y
	RTS

Env_Off:
	.db $30, $30, $00, $30, $30, $30, $00, $30


ApplyPulse1:
	PHX
	PHY
	LDY #CHAN_0 << 2
	LDX #CHAN_0
	JSR ApplyChannel
	PLY
	PLX
	RTS


ApplyPulse2:
	PHX
	PHY
	LDY #CHAN_1 << 2
	LDX #CHAN_1
	JSR ApplyChannel
	PLY
	PLX
	RTS

ApplyChannel:
	LDA #7 << 4 | 1 << 3 | 7
	STA SQ1_SWEEP, Y
	LDA iChannelPitch + 8, X
	STA SQ1_LO, Y
	LDA iChannelPitch, X
	STA SQ1_HI, Y
	LDA iMusicTracks
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
	LDA #0
	STA iChannelID
	STA iChannelID + 1
	STA iChannelID + 2
	STA iChannelID + 3
	STA iChannelVibratoFlags
	STA iChannelVibratoFlags + 1
	STA iChannelVibratoFlags + 2
@not_music:
	CMP #music_boundary + 1
	BCC @01_a6d2
	LDA #0
	STA iChannelID
	STA iChannelID + 1
	STA iChannelID + 2
	STA iChannelID + 3
	STA iChannelTracks
	STA iChannelTracks + 1
	STA iChannelTracks + 2
	STA iChannelTracks + 3
	STA iChannelVibratoFlags
	STA iChannelVibratoFlags + 1
	STA iChannelVibratoFlags + 2
	LDA #Volume_Loop_F | Volume_Ramp_F
	STA SQ1_ENV
	STA SQ2_ENV
	STA NOISE_ENV
	LDA #0
	STA TRI_LINEAR
	RTS
@01_a6c9: ; never used
	LDA #1
	BNE @01_a6cf
@01_a6cd: ; never used
	LDA #0
@01_a6cf:
	STA i6b9
@01_a6d2:
	PHX
	PHY
	LDX #header_byte_length
	LDA zMusicStartingHeaderPointer
	STA zMusicHeaderPointer
	LDA zMusicStartingHeaderPointer + 1
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
	LDY #0
	STY zMusicHeaderOffset
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
	STA zMusicTempDPCMPointer
	INY
	LDA (zMusicHeaderPointer), Y
	STA zMusicTempDPCMPointer + 1
	LDA #SQ1_F | SQ2_F | TRI_F | NOISE_F
	STA SND_CHN
	LDY #DPCM_SIZE - DPCM_ENV
@01_a70f:
	CPY #DPCM_DELTA - DPCM_ENV
	BEQ @01_a718
	LDA (zMusicTempDPCMPointer), Y
	STA DPCM_ENV, Y
@01_a718:
	DEY
	BPL @01_a70f
	LDA #SQ1_F | SQ2_F | TRI_F | NOISE_F | DPCM_F
	STA SND_CHN
@subexit:
	JMP @quit
@01_a723:
	LDY zMusicHeaderOffset
	LDA (zMusicHeaderPointer), Y
	AND #PSG_MASK
	STA zChannelIndex
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
	LDY zMusicHeaderOffset
	INY
	LDA (zMusicHeaderPointer), Y
	STA iChannelAddress, X
	STA zAuxPointer
	INY
	LDA (zMusicHeaderPointer), Y
	STA iChannelAddress + 8, X
	STA zAuxPointer + 1
	LDA #1
	STA iChannelNoteLength, X
	LDA #0
	STA iChannelLoopCounter, X
	STA iChannelPitch, X
	STA iAlternatePitch
	CPX #CHAN_7
	BEQ @01_a774
	LDY #0
	LDA (zAuxPointer), Y
	AND #%11110000
	CMP #sfx_type_cmd
	BEQ @01_a774
	LDA #SOUND_READING_MODE
	BNE @01_a776
@01_a774:
	LDA #0
@01_a776:
	STA iChannelFlags, X
	LDA zChannelIndex
	AND #channel_mask
	ASL A
	ASL A
	TAY
	CPX #CHAN_0
	BNE @01_a789
	LDA iChannelTracks
	BNE @01_a7a6
@01_a789:
	CPX #CHAN_2
	BCS @01_a792
	LDA iChannelTracks, X
	BNE @01_a7a6
@01_a792:
	LDA #0
	CPX #CHAN_2
	BEQ @01_a7a6
	CPX #CHAN_6
	BEQ @01_a7a6
	LDA #Volume_Loop_F | Volume_Ramp_F
	STA SQ1_ENV, Y
	LDA #7 << 4 | 1 << 3 | 7
	STA SQ1_SWEEP, Y
@01_a7a6:
	LDA zMusicHeaderID
	STA iChannelID, X
	DEC zChannelTotal
	BMI @quit
	LDY zMusicHeaderOffset
	YAD 3
	STY zMusicHeaderOffset
	JMP @01_a723
@quit:
	LDA #0
	STA zMusicHeaderPointer + 1
	PLY
	PLX
	RTS

ApplyPitchSlide:
	LDA iChannelTargetPitch
	AND #NOTE_ID_MASK
	ASL A
	TAY
	LDA Pitches, Y
	STA iChannelTargetRawPitch, X
	LDA Pitches + 1, Y
	STA iChannelTargetRawPitch + 3, X
	LDA iChannelTargetPitch
	HTL A
	TAY
@01_a7dd:
	CPY #NUM_OCTAVES - 1
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
	LDA #1
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
	SBC $0660, X
	STA iChannelLittlePitch, X
	LDA iChannelTargetRawPitch + 3, X
	SBC iChannelPitch, X
	BPL @01_a836
	LDA #0
@01_a836:
	STA iChannelLittlePitch + 3, X
	LDA iChannelFlags, X
	ORA #SOUND_PITCH_SLIDE_DIR
	STA iChannelFlags, X
	JMP @01_a85b
@01_a844:
	LDA iChannelPitch + 8, X
	SEC
	SBC iChannelTargetRawPitch, X
	STA iChannelLittlePitch, X
	LDA iChannelPitch, X
	SBC iChannelTargetRawPitch + 3, X
	BPL @01_a858
	LDA #0
@01_a858:
	STA iChannelLittlePitch + 3, X
@01_a85b:
	LDY #0
	LDA iChannelLittlePitch, X
@01_a860:
	INY
	SEC
	SBC iChannelPitchSlideTail
	BCS @01_a860
	PHA
	DEC iChannelLittlePitch + 3, X
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
	STA iChannelLittlePitch + 3, X
	LDA iChannelPitch + 8, X
	STA iChannelLittlePitch, X
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
	INC iChannelLittlePitch, X
	BNE @01_a8b5
	INC iChannelLittlePitch + 3, X
@01_a8b5:
	LDA $062a, X
@01_a8b8:
	STA $0630, X
	LDA iChannelLittlePitch, X
	CLC
	ADC $0627, X
	BCC @01_a8c7
	INC iChannelLittlePitch + 3, X
@01_a8c7:
	STA iChannelLittlePitch, X
	LDA iChannelFlags, X
	AND #SOUND_PITCH_SWAP
	BNE @01_a8e1
	LDA iChannelLittlePitch + 3, X
	CMP iChannelTargetRawPitch + 3, X
	BCC @01_a8f8
	LDA iChannelFlags, X
	ORA #SOUND_PITCH_SWAP
	STA iChannelFlags, X
@01_a8e1:
	LDA iChannelLittlePitch, X
	CMP iChannelTargetRawPitch, X
	BCC @01_a8f8
	LDA iChannelTargetRawPitch + 3, X
	STA iChannelLittlePitch + 3, X
	LDA iChannelTargetRawPitch, X
	STA iChannelLittlePitch, X
	JMP ClearPitchSlide
@01_a8f8:
	JMP UpdatePitch
@01_a8fb:
	LDA $062a, X
	CLC
	ADC $0630, X
	CMP $062d, X
	BCC @01_a915
	LDA iChannelLittlePitch, X
	BNE @01_a90f
	DEC iChannelLittlePitch + 3, X
@01_a90f:
	DEC iChannelLittlePitch, X
	LDA $062a, X
@01_a915:
	STA $0630, X
	LDA iChannelLittlePitch, X
	SEC
	SBC $0627, X
	BCS @01_a924
	DEC iChannelLittlePitch + 3, X
@01_a924:
	STA iChannelLittlePitch, X
	LDA iChannelFlags, X
	AND #SOUND_PITCH_SWAP
	BNE @01_a93e
	LDA iChannelTargetRawPitch + 3, X
	CMP iChannelLittlePitch + 3, X
	BCC @01_a955
	LDA iChannelFlags, X
	ORA #SOUND_PITCH_SWAP
	STA iChannelFlags, X
@01_a93e:
	LDA iChannelTargetRawPitch, X
	CMP iChannelLittlePitch, X
	BCC @01_a955
	LDA iChannelTargetRawPitch + 3, X
	STA iChannelLittlePitch + 3, X
	LDA iChannelTargetRawPitch, X
	STA iChannelLittlePitch, X
	JMP ClearPitchSlide
@01_a955:
	JMP UpdatePitch


ClearPitchSlide:
	LDA iChannelFlags, X
	AND #$ff ^ (SOUND_PITCH_SWAP | SOUND_PITCH_SLIDE_DIR | SOUND_PITCH_SLIDE)
	STA iChannelFlags, X
	JSR SwapPitch


UpdatePitch:
	LDA iChannelLittlePitch, X
	STA iChannelPitch + 8, X
	JSR UpdateLow
	LDA iChannelLittlePitch + 3, X
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
	LDA iAlternatePitch
	STA iChannelPitch, X
	PLA
	STA iAlternatePitch
@quit:
	RTS
