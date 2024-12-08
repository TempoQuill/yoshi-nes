Music_VSMatch_Ch2:
	channel_volume 13
	pitch_inc_switch
	note_type 12, 1, 3, 1, 4
	octave 3
	note G_, 2
	note G_, 1
	note G_, 1
	note G_, 4
	note_type 8, 1, 3, 1, 4
	rest 2
	note G_, 2
	note A_, 2
	note B_, 2
	octave 4
	note C_, 2
	note C#, 2
	note D_, 6
	note_type 12, 1, 3, 1, 4
	octave 3
	note B_, 4
	octave 4
	note C_, 4
	octave 3
	note C_, 4

Music_VSMatch_Ch2_Mainloop:
	octave 3
	rest 2
	sound_call Music_VSMatch_Ch2_Sub1
	sound_call Music_VSMatch_Ch2_Sub2
	note A_, 4
	note G_, 4
	note G_, 4
	note G_, 4
	note G_, 4
	sound_call Music_VSMatch_Ch2_Sub2
	note A_, 1
	note B♭, 1
	octave 4
	note C_, 2
	octave 3
	note B♭, 2
	note A_, 2
	note G_, 4
	sound_call Music_VSMatch_Ch2_Sub1
	note F_, 1
	note E_, 1
	note F_, 1
	note E_, 1
	note F_, 4
	octave 3
	note G_, 4
	note G_, 4
	note G_, 4
	note G_, 2
	octave 4
	note C_, 2
	note D_, 2
	note E_, 2
	note D_, 2
	note G_, 2
	note A_, 2
	note B♭, 2
	note G_, 4
	octave 3
	note G_, 4
	note G_, 4
	octave 4
	note C_, 1
	note D_, 1
	note E_, 2
	note C_, 2
	note_type 12, 1, 8, 1, 10
	note D_, 10
	note_type 12, 1, 3, 1, 4
	octave 3
	note A_, 1
	note B♭, 1
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note_type 12, 1, 8, 1, 10
	note A_, 10
	note_type 12, 1, 3, 1, 4
	rest 8
	octave 4
	note F_, 1
	note E_, 1
	note F_, 6
	note G_, 1
	note F#, 1
	note G_, 4
	sound_call Music_VSMatch_Ch2_Sub3
	note G_, 6
	octave 3
	note C_, 4
	note C_, 2
	note A_, 2
	note C_, 2
	note A_, 2
	note C_, 4
	note D_, 4
	note D_, 2
	octave 4
	note C_, 2
	octave 3
	note E_, 2
	octave 4
	note C_, 2
	octave 3
	note E_, 2
	note F_, 6
	octave 4
	note F_, 2
	note C_, 2
	octave 3
	note B♭, 2
	note A_, 2
	octave 4
	note C_, 2
	octave 3
	note B♭, 6
	octave 4
	note G_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	octave 3
	note B♭, 2
	sound_call Music_VSMatch_Ch2_Sub3
	note G_, 4
	note F_, 2
	octave 3

Music_VSMatch_Ch2_Loop1:
	note A_, 4
	sound_loop 16, Music_VSMatch_Ch2_Loop1
	note B♭, 4
	note B♭, 4
	note B♭, 4
	note B♭, 4
	octave 4

Music_VSMatch_Ch2_Loop2:
	note C_, 4
	sound_loop 7, Music_VSMatch_Ch2_Loop2
	note C_, 2
	octave 3
	note A_, 16

Music_VSMatch_Ch2_Loop3:
	rest 16
	sound_loop 5, Music_VSMatch_Ch2_Loop3
	sound_loop 0, Music_VSMatch_Ch2_Mainloop

Music_VSMatch_Ch2_Sub1:
	note F_, 4
	note F_, 4
	note F_, 4
	note F_, 4
	octave 4
	note C_, 1
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	octave 3
	note B_, 1
	octave 4
	note C_, 4
	sound_ret

Music_VSMatch_Ch2_Sub2:
	octave 3
	note A_, 1
	note G#, 1
	note A_, 1
	note G#, 1
	sound_ret

Music_VSMatch_Ch2_Sub3:
	octave 3
	note A_, 2
	note F_, 4
	note F_, 4
	note F_, 4
	note F_, 4
	octave 4
	note F_, 1
	note E_, 1
	note F_, 6
	note G_, 1
	note F#, 1
	sound_ret

Music_VSMatch_Ch1:
	tempo 128
	channel_volume 13
	vibrato 8, 1, 2
	note_type 12, 2, 1, 2, 6
	octave 4
	note C_, 2
	note C_, 1
	note C_, 1
	note C_, 4
	note_type 8, 2, 1, 2, 6
	rest 2
	note C_, 2
	note D_, 2
	note E_, 2
	note F_, 2
	note F#, 2
	note G_, 6
	note B_, 3
	note A_, 1
	note B_, 1
	note G_, 1
	note_type 12, 2, 1, 2, 6
	octave 5
	note C_, 4
	octave 3
	note G_, 2
	octave 4
	note C_, 2

Music_VSMatch_Ch1_Mainloop:
	sound_call Music_VSMatch_Ch1_Sub1
	octave 4
	note A_, 6
	note C_, 2
	note G_, 3
	note F_, 1
	note E_, 2
	note F_, 2
	note G_, 2
	note G_, 2
	note A_, 2
	note B♭, 2
	note A_, 8
	octave 5
	note C_, 6
	octave 4
	note C_, 2
	sound_call Music_VSMatch_Ch1_Sub1
	note F_, 8
	note E_, 3
	note D_, 1
	note C_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	octave 4
	note B_, 2
	note G_, 2
	octave 5
	note C_, 14
	note C_, 1
	note D♭, 1
	note D_, 3
	note C_, 1
	octave 4
	note B♭, 2
	note A_, 2
	octave 5
	note C_, 6
	octave 4
	note A_, 2
	note B♭, 3
	note A_, 1
	note G_, 2
	note F_, 2
	note G_, 8
	sound_call Music_VSMatch_Ch1_Sub2
	note C_, 1
	note C_, 1
	note C_, 4
	sound_call Music_VSMatch_Ch1_Sub2
	sound_call Music_VSMatch_Ch1_Sub3
	note F_, 1
	note E_, 1
	note D_, 2
	note C_, 2
	note D_, 2
	note C_, 2
	octave 4
	note B♭, 2
	note A_, 4
	note D_, 1
	note E_, 1
	note F_, 2
	note D_, 2
	note E_, 2
	note E_, 1
	note F_, 1
	note G_, 4
	octave 5
	note C_, 2
	note C_, 1
	octave 4
	note B♭, 1
	note A_, 2
	note B♭, 2
	octave 5
	note C_, 6
	octave 4
	note A_, 2
	note B♭, 2
	note B♭, 1
	octave 5
	note C_, 1
	note D_, 2
	octave 4
	note B_, 2
	octave 5
	note C_, 8
	sound_call Music_VSMatch_Ch1_Sub2
	sound_call Music_VSMatch_Ch1_Sub3
	octave 4
	note F_, 4
	note F_, 4
	note F_, 4
	note F_, 4
	note F_, 4
	note F_, 4
	note F_, 4
	note E_, 2
	note A_, 3
	note A_, 1
	note A_, 2
	note B♭, 2
	octave 5
	note C_, 4
	note_type 6, 2, 1, 2, 6
	octave 4
	note E_, 1
	note F_, 1
	note G_, 1
	note A_, 1
	note B♭, 1
	octave 5
	note C_, 1
	note D_, 1
	note E_, 1
	note F_, 6
	note E_, 2
	note D_, 4
	note E_, 4
	note C_, 16
	note D_, 6
	note C_, 2
	octave 4
	note B♭, 4
	octave 5
	note D_, 4
	note_type 8, 2, 1, 2, 6
	note C_, 2
	octave 4
	note B♭, 2
	octave 5
	note C_, 2
	octave 4
	note B♭, 2
	octave 5
	note C_, 2
	octave 4
	note B♭, 2

Music_VSMatch_Ch1_Loop1:
	octave 5
	note C_, 2
	note D_, 2
	note C_, 2
	note D_, 2
	note C_, 2
	note D_, 2
	note C_, 12
	channel_volume 9
	sound_loop 2, Music_VSMatch_Ch1_Loop1
	channel_volume 13
	note_type 12, 2, 1, 2, 6
	pitch_slide 1, 4, F_
	note F_, 8
	rest 4
	octave 4
	pitch_slide 1, 3, F_
	note F_, 8
	rest 12
	rest 16
	vibrato 1, 4, 0
	note_type 12, 2, 1, 8, 1
	octave 4
	note B♭, 8
	vibrato 8, 1, 2
	note_type 12, 2, 1, 1, 6
	octave 5
	note C_, 2
	rest 6
	rest 16
	rest 16
	octave 4
	sound_loop 0, Music_VSMatch_Ch1_Mainloop

Music_VSMatch_Ch1_Sub1:
	note A_, 3
	note G_, 1
	note F_, 2
	note A_, 2
	note G_, 2
	note A_, 2
	note B♭, 2
	octave 5
	note D_, 2
	note C_, 8
	sound_ret

Music_VSMatch_Ch1_Sub2:
	octave 4
	note A_, 2
	note A_, 1
	note B♭, 1
	octave 5
	note C_, 2
	octave 4
	note B♭, 2
	note A_, 2
	note F_, 2
	octave 5
	note C_, 2
	octave 4
	note A_, 4
	octave 5
	note D_, 1
	note D_, 1
	note D_, 6
	sound_ret

Music_VSMatch_Ch1_Sub3:
	note E_, 1
	note E_, 1
	note E_, 4
	note F_, 2
	sound_ret

Music_VSMatch_Ch3:
	hill_type 12, 0, 17
	octave 3
	note E_, 2
	note E_, 1
	note E_, 1
	hill_type 12, 0, 65
	note E_, 16
	hill_type 12, 0, 17
	note D_, 4
	note C_, 4
	octave 2
	note G_, 4

Music_VSMatch_Ch3_Mainloop:
	sound_call Music_VSMatch_Ch3_Sub1
	octave 3
	note E_, 2
	octave 4
	note D_, 2
	octave 3
	note B♭, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note G_, 2
	octave 4
	note D_, 2
	octave 3
	note F_, 2
	octave 4
	note E_, 2
	note C_, 2
	note E_, 2
	octave 3
	note A_, 2
	octave 4
	note E_, 2
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	sound_call Music_VSMatch_Ch3_Sub1
	octave 3
	note E_, 2
	octave 4
	note D_, 2
	octave 3
	note G_, 2
	octave 4
	note D_, 2
	octave 3
	note D_, 2
	octave 4
	note D_, 2
	octave 3
	note F_, 2
	octave 4
	note D_, 2
	octave 3
	note C_, 2
	octave 4
	note E_, 2
	note C_, 2
	note E_, 2
	octave 3
	note B♭, 2
	octave 4
	note E_, 2
	octave 3
	note G_, 2
	octave 4
	note E_, 2
	octave 3
	note D_, 2
	octave 4
	note D_, 2
	octave 3
	note G_, 2
	octave 4
	note D_, 2
	octave 3
	note C_, 2
	octave 4
	note C_, 2
	octave 3
	note E_, 2
	octave 4
	note C_, 2
	octave 2
	note B♭, 2
	octave 3
	note B♭, 2
	note D_, 2
	note B♭, 2
	octave 2
	note A_, 2
	octave 3
	note A_, 1
	note A_, 1
	note A_, 2
	note G_, 2

Music_VSMatch_Ch3_Loop1:
	octave 2
	note A_, 2
	octave 3
	note A_, 2
	note C_, 2
	note A_, 2
	octave 2
	note F_, 2
	octave 3
	note A_, 2
	note C_, 2
	note A_, 2
	octave 2
	note B♭, 2
	octave 3
	note B♭, 2
	note D_, 2
	note B♭, 2
	note C_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	sound_loop 2, Music_VSMatch_Ch3_Loop1
	sound_call Music_VSMatch_Ch3_Sub2
	note E_, 2
	octave 4
	note C_, 2
	octave 3
	note C_, 2
	octave 4
	note C_, 2
	octave 3
	note F_, 16
	rest 10
	note E_, 1
	note F_, 1
	note G_, 2
	note E_, 2
	sound_call Music_VSMatch_Ch3_Sub2
	note C_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	octave 4
	note C_, 2

Music_VSMatch_Ch3_Loop2:
	octave 3
	note F_, 2
	octave 4
	note F_, 2
	note C_, 2
	note F_, 2
	octave 3
	note B♭, 2
	octave 4
	note F_, 2
	octave 3
	note A_, 2
	octave 4
	note F_, 2
	sound_loop 2, Music_VSMatch_Ch3_Loop2

Music_VSMatch_Ch3_Loop3:
	octave 3
	note F_, 2
	octave 4
	note F_, 2
	note C_, 2
	note F_, 2
	octave 3
	note B♭, 2
	octave 4
	note F_, 2
	octave 3
	note A_, 2
	octave 4
	note F_, 2
	sound_loop 2, Music_VSMatch_Ch3_Loop3
	octave 3
	note G_, 2
	octave 4
	note G_, 2
	note D_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	octave 3
	note B♭, 2
	octave 4
	note G_, 2

Music_VSMatch_Ch3_Loop4:
	octave 3
	note C_, 2
	octave 4
	note G_, 2
	octave 3
	note E_, 2
	octave 4
	note G_, 2
	octave 3
	note G_, 2
	octave 4
	note G_, 2
	octave 3
	note B♭, 2
	octave 4
	note G_, 2
	sound_loop 2, Music_VSMatch_Ch3_Loop4
	octave 3
	note F_, 16

Music_VSMatch_Ch3_Loop5:
	rest 16
	sound_loop 4, Music_VSMatch_Ch3_Loop5
	rest 10
	note C_, 2
	note D_, 2
	note E_, 2
	sound_loop 0, Music_VSMatch_Ch3_Mainloop

Music_VSMatch_Ch3_Sub1:
	octave 3
	note C_, 2
	octave 4
	note C_, 2
	octave 3
	note F_, 2
	octave 4
	note C_, 2
	octave 3
	note E_, 2
	octave 4
	note C_, 2
	octave 3
	note D_, 2
	octave 4
	note C_, 2
	sound_loop 2, Music_VSMatch_Ch3_Sub1
	sound_ret

Music_VSMatch_Ch3_Sub2:
	octave 2
	note A_, 2
	octave 3
	note A_, 2
	note C_, 2
	note A_, 2
	octave 2
	note F_, 2
	octave 3
	note A_, 2
	note C_, 2
	note A_, 2
	octave 2
	note B♭, 2
	octave 3
	note B♭, 2
	note D_, 2
	note B♭, 2
	sound_ret

Music_VSMatch_Ch4:
	drum_speed 12
	rest 4
	drum_speed 6

Music_VSMatch_Ch4_Loop1:
	drum_note 2, 1
	sound_loop 8, Music_VSMatch_Ch4_Loop1
	drum_note 2, 16
	drum_note 2, 8
	drum_note 2, 6
	drum_note 2, 2
	drum_note 2, 8
	drum_note 3, 8
	drum_speed 12

Music_VSMatch_Ch4_Mainloop:
	sound_call Music_VSMatch_Ch4_Sub1
	sound_call Music_VSMatch_Ch4_Sub2
	sound_call Music_VSMatch_Ch4_Sub1
	sound_call Music_VSMatch_Ch4_Sub3
	sound_call Music_VSMatch_Ch4_Sub1
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 1
	drum_note 1, 1
	drum_note 1, 1
	drum_note 1, 1
	sound_call Music_VSMatch_Ch4_Sub1
	sound_call Music_VSMatch_Ch4_Sub2
	sound_call Music_VSMatch_Ch4_Sub1
	sound_call Music_VSMatch_Ch4_Sub3
	sound_call Music_VSMatch_Ch4_Sub1
	sound_call Music_VSMatch_Ch4_Sub4
	sound_call Music_VSMatch_Ch4_Sub1
	sound_call Music_VSMatch_Ch4_Sub4
	sound_call Music_VSMatch_Ch4_Sub1
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 2, 2
	drum_note 4, 1
	rest 15
	rest 8
	drum_note 4, 6
	drum_note 1, 2
	sound_call Music_VSMatch_Ch4_Sub1
	sound_call Music_VSMatch_Ch4_Sub2
	sound_call Music_VSMatch_Ch4_Sub5
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 1
	drum_note 1, 1
	drum_note 2, 2
	drum_note 1, 1
	drum_note 1, 1
	sound_call Music_VSMatch_Ch4_Sub1
	sound_call Music_VSMatch_Ch4_Sub2
	sound_call Music_VSMatch_Ch4_Sub1
	sound_call Music_VSMatch_Ch4_Sub5
	sound_call Music_VSMatch_Ch4_Sub5
	drum_note 2, 2
	drum_note 2, 2
	drum_note 2, 1
	drum_note 2, 2
	drum_note 2, 1
	drum_note 2, 2
	drum_note 2, 1
	drum_note 2, 1
	drum_note 2, 4
	drum_note 2, 2
	drum_note 2, 1
	drum_note 2, 1
	drum_note 2, 2
	drum_note 2, 2
	drum_note 2, 2
	drum_note 2, 2
	drum_note 2, 4
	drum_speed 8

Music_VSMatch_Ch4_Loop2:
	drum_note 2, 2
	drum_note 2, 2
	drum_note 2, 2
	drum_note 2, 6
	sound_loop 2, Music_VSMatch_Ch4_Loop2
	drum_speed 6

Music_VSMatch_Ch4_Loop3:
	drum_note 2, 1
	sound_loop 16, Music_VSMatch_Ch4_Loop3
	drum_note 2, 4
	drum_note 2, 12
	drum_note 2, 8
	drum_note 2, 8
	drum_note 2, 4
	drum_note 2, 8
	drum_note 2, 4
	drum_speed 8

Music_VSMatch_Ch4_Loop4:
	drum_note 2, 2
	sound_loop 6, Music_VSMatch_Ch4_Loop4
	drum_speed 12
	drum_note 2, 4
	drum_note 3, 2
	drum_note 1, 2
	sound_loop 0, Music_VSMatch_Ch4_Mainloop

Music_VSMatch_Ch4_Sub1:
	drum_note 2, 2
	drum_note 1, 2
	sound_loop 4, Music_VSMatch_Ch4_Sub1
	sound_ret

Music_VSMatch_Ch4_Sub2:
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 2
	drum_note 1, 2
	drum_note 1, 2
	sound_ret

Music_VSMatch_Ch4_Sub3:
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 1
	drum_note 1, 1
	sound_ret

Music_VSMatch_Ch4_Sub4:
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 1
	drum_note 1, 1
	drum_note 2, 2
	drum_note 1, 1
	drum_note 1, 1
	drum_note 2, 2
	drum_note 1, 2
	sound_ret

Music_VSMatch_Ch4_Sub5:
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 2
	drum_note 2, 2
	drum_note 1, 1
	drum_note 1, 1
	drum_note 2, 2
	drum_note 1, 2
	sound_ret
