Music_VSResults_Ch2:
	pitch_inc_switch
	vibrato 8, 1, 1

Music_VSResults_Ch2_Mainloop:
	channel_volume 12
	note_type 12, 2, 13, 1, 4
	sound_call Music_VSResults_Ch2_Sub1
	channel_volume 10
	note_type 12, 2, 13, 1, 12
	octave 2
	note F_, 1
	rest 3
	note C_, 1
	rest 3
	note D_, 1
	rest 3
	note E_, 1
	rest 3
	note G_, 1
	rest 3
	note C_, 1
	rest 3
	note D_, 1
	rest 3
	note C_, 1
	rest 3
	note E_, 1
	rest 3
	note C_, 1
	rest 3
	note D_, 1
	rest 3
	note E_, 1
	rest 3
	note F_, 1
	rest 3
	note C_, 1
	rest 3
	note D_, 1
	rest 3
	note E_, 1
	rest 3
	channel_volume 12
	note_type 12, 0, 13, 1, 4
	sound_call Music_VSResults_Ch2_Sub1
	sound_loop 0, Music_VSResults_Ch2_Mainloop

Music_VSResults_Ch2_Sub1:
	octave 4
	note C_, 1
	rest 2
	octave 3
	note A_, 1
	octave 4
	note C_, 1
	rest 1
	note F_, 1
	rest 3
	note E_, 1
	rest 3
	note D_, 1
	rest 1
	note E_, 1
	rest 3
	note G_, 1
	rest 11
	octave 3
	note A#, 1
	rest 2
	note G_, 1
	octave 4
	note C_, 1
	rest 1
	note E_, 1
	rest 3
	note D_, 1
	rest 3
	note E_, 1
	rest 1
	note F_, 1
	rest 3
	note C_, 1
	rest 11
	sound_ret

Music_VSResults_Ch1:
	tempo 132
	channel_volume 13
	vibrato 10, 1, 2

Music_VSResults_Ch1_Mainloop:
	note_type 12, 2, 13, 2, 6
	sound_call Music_VSResults_Ch1_Sub1
	rest 16
	rest 16
	rest 16
	rest 16
	note_type 12, 3, 13, 2, 6
	sound_call Music_VSResults_Ch1_Sub1
	sound_loop 0, Music_VSResults_Ch1_Mainloop

Music_VSResults_Ch1_Sub1:
	octave 4
	note F_, 1
	rest 2
	note A_, 1
	octave 5
	note C_, 1
	rest 1
	note D_, 1
	rest 3
	note C_, 1
	rest 3
	octave 4
	note A_, 1
	rest 1
	note A#, 1
	rest 3
	octave 5
	note C_, 1
	rest 1
	octave 4
	note C_, 1
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	rest 1
	octave 3
	note A#, 1
	rest 1
	note G_, 1
	rest 3
	octave 4
	note E_, 1
	rest 2
	note G_, 1
	note A_, 1
	rest 1
	note A#, 1
	rest 3
	note A_, 1
	rest 3
	note G_, 1
	rest 1
	note A_, 1
	rest 3
	note F_, 1
	rest 11
	sound_ret

Music_VSResults_Ch3:
	hill_type 12, 0, 33
	octave 4
	note F_, 1
	rest 3
	note C_, 1
	rest 3
	note D_, 1
	rest 3
	note E_, 1
	rest 3
	note G_, 1
	rest 3
	note C_, 1
	rest 3
	note D_, 1
	rest 3
	note C_, 1
	rest 3
	note E_, 1
	rest 3
	note C_, 1
	rest 3
	note D_, 1
	rest 3
	note E_, 1
	rest 3
	note F_, 1
	rest 3
	note C_, 1
	rest 3
	note D_, 1
	rest 3
	note E_, 1
	rest 3
	hill_type 12, 0, 20
	octave 5
	note F_, 1
	rest 2
	note A_, 1
	octave 6
	note C_, 1
	rest 1
	note D_, 1
	rest 3
	note C_, 1
	rest 3
	octave 5
	note A_, 1
	rest 1
	note A#, 1
	rest 3
	octave 6
	note C_, 1
	rest 1
	octave 5
	note C_, 1
	octave 4
	note B_, 1
	octave 5
	note C_, 1
	rest 1
	octave 4
	note A#, 1
	rest 1
	note G_, 1
	rest 3
	octave 5
	note E_, 1
	rest 2
	note G_, 1
	note A_, 1
	rest 1
	note A#, 1
	rest 3
	note A_, 1
	rest 3
	note G_, 1
	rest 1
	note A_, 1
	rest 3
	note F_, 1
	rest 11
	rest 16
	rest 16
	rest 16
	rest 16
	sound_loop 0, Music_VSResults_Ch3

Music_VSResults_Ch4:
	drum_speed 12

Music_VSResults_Ch4_Mainloop:
	sound_call Music_VSResults_Ch4_Sub1

Music_VSResults_Ch4_Loop1:
	rest 16
	sound_loop 4, Music_VSResults_Ch4_Loop1
	sound_call Music_VSResults_Ch4_Sub1
	sound_loop 0, Music_VSResults_Ch4_Mainloop

Music_VSResults_Ch4_Sub1:
	drum_note 11, 4
	drum_note 12, 2
	drum_note 12, 2
	drum_note 11, 4
	drum_note 12, 4
	drum_note 11, 2
	drum_note 12, 2
	drum_note 12, 2
	drum_note 12, 2
	drum_note 11, 4
	drum_note 12, 4
	sound_loop 2, Music_VSResults_Ch4_Sub1
	sound_ret
