; music
MACRO sound_header total channel, address
	.db total - 1 << 6 | channel - 1, <address, >address
ENDM

MACRO sound_subheader channel, address
	.db channel - 1, <address, >address
ENDM

MACRO dpcm_entry pitch, addr, length
	.db pitch, 0, (addr & %0011111111000000) >> 6, length
ENDM

MACRO perc_type length, loop, ramp, param
	.db $20 | length, loop << 5 | ramp << 4 | param - 1
ENDM

MACRO noise_note volume, unknown, loop, pitch
	.db volume << 4 | unknown << 3, loop << 7 | pitch
ENDM

MACRO pitch_sweep period, dir, inc
	.db pitch_sweep_cmd, $80 | period << 4 | dir << 3 | inc
ENDM

MACRO sfx_pitch_inc_switch
	.db sfx_pitch_inc_switch_cmd
ENDM

MACRO sfx_type length, cycle, loop, ramp, param
	.db sfx_type_cmd | length, cycle << 6 | loop << 5 | ramp << 4 | param - 1
ENDM

MACRO pulse_note volume, pitch
	.db volume << 4 | >pitch, <pitch
ENDM

MACRO note pitch, length
	.db pitch << 4 | length - 1
ENDM

MACRO drum_note id, length
	.db B_ << 4 | length, id
ENDM

MACRO rest length
	.db 12 << 4 | length
ENDM

MACRO note_type length, cycle, instrument, fade_length, fade_delay
	.db note_type_cmd | length, $30 | cycle, instrument, fade_length << 4 | fade_delay
ENDM

MACRO hill_type length, linear_flag, linear
	.db note_type_cmd | length, linear_flag << 7 | linear
ENDM

MACRO drum_speed length
	.db note_type_cmd | length
ENDM

MACRO octave oct
	.db octave_cmd | 8 - oct
ENDM

MACRO pitch_inc_switch
	.db pitch_inc_switch_cmd
ENDM

MACRO frame_swap
	.db frame_swap_cmd
ENDM

MACRO vibrato delay, depth, speed
	IF delay == 0
		.db vibrato_cmd, 0
	ELSE
		.db vibrato_cmd, delay, depth << 4 | speed
	ENDIF
ENDM

MACRO pitch_slide tail, oct, pitch
	.db pitch_slide_cmd, tail - 1, (8 - oct) << 4 | pitch
ENDM

MACRO dummy_ec
	.db dummy_ec
ENDM

MACRO tempo speed
	.db tempo_cmd, >speed, <speed
ENDM

MACRO new_song id
	.db new_song_cmd, id
ENDM

MACRO channel_mute
	.db channel_mute_cmd
ENDM

MACRO channel_volume deductable
	.db channel_volume_cmd | 15 - deductable
ENDM

MACRO sound_call destination
	.db sound_call_cmd, <destination, >destination
ENDM

MACRO sound_loop amount, destination
	.db sound_loop_cmd, amount, <destination, >destination
ENDM

MACRO sound_ret
	.db sound_ret_cmd
ENDM

; code
MACRO PHX
	TXA
	PHA
ENDM

MACRO PLX
	PLA
	TAX
ENDM

MACRO PHY
	TYA
	PHA
ENDM

MACRO PLY
	PLA
	TAY
ENDM

MACRO XAD num
	REPT num
		INX
	ENDR
ENDM

MACRO YAD num
	REPT num
		INY
	ENDR
ENDM

MACRO XSB num
	REPT num
		DEX
	ENDR
ENDM

MACRO YSB num
	REPT num
		DEY
	ENDR
ENDM

; low to high nybble
MACRO LTH register
	ASL register
	ASL register
	ASL register
	ASL register
ENDM

; high to low nybble
MACRO HTL register
	LSR register
	LSR register
	LSR register
	LSR register
ENDM
