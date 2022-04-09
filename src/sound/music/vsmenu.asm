Music_VSMenu_Ch2:
	channel_volume 12
	vibrato 8, 1, 2
	pitch_inc_switch
	note_type 8, 0, 5, 1, 15
	rest 16
	rest 8

Music_VSMenu_Ch2_Mainloop:
	sound_call Music_VSMenu_Ch3_Sub1
	sound_loop 0, Music_VSMenu_Ch2_Mainloop

Music_VSMenu_Ch1:
	tempo 128
	channel_volume 13
	vibrato 7, 1, 3
	note_type 8, 1, 5, 1, 15

Music_VSMenu_Ch1_Mainloop:
	sound_call Music_VSMenu_Ch3_Sub1
	rest 16
	rest 16
	rest 16
	sound_call Music_VSMenu_Ch3_Sub2
	sound_loop 0, Music_VSMenu_Ch1_Mainloop

Music_VSMenu_Ch3:
	hill_type 8, 0, 2

Music_VSMenu_Ch3_Mainloop:
	rest 16
	rest 16
	rest 16
	sound_call Music_VSMenu_Ch3_Sub2
	octave 5
	note C_, 2
	rest 1
	note C_, 1
	note C_, 1
	note C_, 1
	note E_, 2
	note C_, 2
	note E_, 2
	note G_, 2
	note E_, 2
	note G_, 2
	octave 6
	note C_, 2
	rest 2
	note C_, 2
	octave 5
	note E_, 2
	rest 1
	note E_, 1
	note E_, 1
	note E_, 1
	note G_, 2
	note E_, 2
	note G_, 2
	octave 6
	note C_, 2
	octave 5
	note G_, 2
	octave 6
	note C_, 2
	note E_, 2
	rest 2
	note E_, 2
	note C_, 2
	rest 1
	note C_, 1
	note C_, 1
	note C_, 1
	octave 5
	note G_, 2
	octave 6
	note C_, 2
	octave 5
	note G_, 2
	octave 6
	note C_, 2
	octave 5
	note G_, 2
	note E_, 2
	note C_, 2
	rest 2
	note C_, 2
	note E_, 2
	rest 2
	note E_, 2
	note G_, 2
	rest 2
	note G_, 2
	octave 6
	note C_, 2
	rest 2
	note C_, 2
	octave 5
	note G_, 2
	rest 2
	note G_, 2
	note G_, 2
	rest 2
	note G_, 2
	octave 6
	note C_, 2
	rest 2
	note C_, 2
	note E_, 2
	rest 2
	note E_, 2
	note C_, 2
	rest 2
	note C_, 2
	note C_, 2
	note C_, 2
	note C_, 2
	note E_, 2
	rest 4
	note C_, 2
	note C_, 2
	note C_, 2
	note E_, 2
	rest 4
	octave 5
	note G_, 2
	note G_, 2
	note G_, 2
	octave 6
	note C_, 2
	rest 4
	octave 5
	note G_, 2
	note G_, 2
	note G_, 2
	octave 6
	note C_, 2
	rest 4
	sound_loop 0, Music_VSMenu_Ch3_Mainloop

Music_VSMenu_Ch3_Sub1:
	octave 4
	note C_, 2
	rest 1
	note C_, 1
	note C_, 1
	note C_, 1
	note E_, 2
	note C_, 2
	note E_, 2
	note G_, 2
	note E_, 2
	note G_, 2
	octave 5
	note C_, 2
	rest 2
	note C_, 2
	octave 4
	note E_, 2
	rest 1
	note E_, 1
	note E_, 1
	note E_, 1
	note G_, 2
	note E_, 2
	note G_, 2
	octave 5
	note C_, 2
	octave 4
	note G_, 2
	octave 5
	note C_, 2
	note E_, 2
	rest 2
	note E_, 2
	note C_, 2
	rest 1
	note C_, 1
	note C_, 1
	note C_, 1
	octave 4
	note G_, 2
	octave 5
	note C_, 2
	octave 4
	note G_, 2
	octave 5
	note C_, 2
	octave 4
	note G_, 2
	note E_, 2
	note C_, 2
	rest 2
	note C_, 2
	note E_, 2
	rest 2
	note E_, 2
	note G_, 2
	rest 2
	note G_, 2
	octave 5
	note C_, 2
	rest 2
	note C_, 2
	octave 4
	note G_, 2
	rest 2
	note G_, 2
	note G_, 2
	rest 2
	note G_, 2
	octave 5
	note C_, 2
	rest 2
	note C_, 2
	note E_, 2
	rest 2
	note E_, 2
	note C_, 2
	rest 2
	note C_, 2
	note C_, 2
	note C_, 2
	note C_, 2
	note E_, 2
	rest 4
	note C_, 2
	note C_, 2
	note C_, 2
	note E_, 2
	rest 4
	octave 4
	note G_, 2
	note G_, 2
	note G_, 2
	octave 5
	note C_, 2
	rest 4
	octave 4
	note G_, 2
	note G_, 2
	note G_, 2
	octave 5
	note C_, 2
	rest 4
	sound_ret

Music_VSMenu_Ch3_Sub2:
	rest 16
	rest 8
	sound_loop 5, Music_VSMenu_Ch3_Sub2
	sound_ret

Music_VSMenu_Ch4:
	drum_speed 8

Music_VSMenu_Ch4_Mainloop:
	drum_note 15, 16
	rest 8
	rest 16
	rest 8
	drum_note 15, 16
	rest 8
	rest 16
	rest 8
	rest 16
	rest 8
	rest 16
	rest 8
	rest 16
	rest 8
	sound_loop 0, Music_VSMenu_Ch4_Mainloop
