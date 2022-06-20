Music_Pokecenter_Ch2:
	vibrato 10, 1, 2
	channel_volume 14
	pitch_inc_switch

Music_Pokecenter_Ch2_mainloop:
	note_type 12, 0, 8, 4, 3
	sound_call Music_Pokecenter_Ch2_sub1
	sound_call Music_Pokecenter_Ch2_sub2
	sound_call Music_Pokecenter_Ch2_sub3
	octave 2
	note B_, 2
	octave 3
	note D_, 2
	note E_, 2
	note F#, 2
	note G_, 2
	note F#, 2
	note E_, 2
	note D_, 2
	sound_call Music_Pokecenter_Ch2_sub1
	sound_call Music_Pokecenter_Ch2_sub2
	sound_call Music_Pokecenter_Ch2_sub3
	octave 2
	note B_, 2
	note A_, 2
	note G_, 2
	note A_, 2
	note B_, 2
	octave 3
	note C_, 2
	note D_, 2
	note E_, 2
	octave 2
	note B_, 2
	note A_, 2
	note G_, 4
	note A_, 2
	note B_, 2
	octave 3
	note C_, 2
	note D_, 2
	note E_, 2
	note D_, 2
	note C_, 4
	octave 2
	note A_, 2
	note B_, 2
	octave 3
	note C_, 2
	note D_, 2
	note C_, 2
	octave 2
	note B_, 2
	note A_, 4
	note F#, 2
	note G_, 2
	note A_, 2
	octave 3
	note C_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note D_, 2
	note E_, 2
	note_type 12, 0, 8, 4, 7
	note D_, 8
	note_type 12, 0, 8, 4, 3
	note G_, 2
	note F#, 2
	note E_, 4
	note D_, 2
	note E_, 2
	note F#, 2
	note G_, 2
	note A_, 2
	note G_, 2
	note F#, 4
	note E_, 2
	note F#, 2
	note G_, 2
	note A_, 2
	note F#, 2
	note E_, 2
	note D_, 4
	note C_, 2
	note D_, 2
	note E_, 2
	note C_, 2
	note D_, 2
	note C_, 2
	octave 2
	note B_, 2
	note A_, 2
	note G_, 2
	note A_, 2
	note B_, 2
	octave 3
	note C_, 2
	sound_loop 0, Music_Pokecenter_Ch2_mainloop

Music_Pokecenter_Ch2_sub1:
	octave 2
	note B_, 2
	note A#, 2
	note B_, 2
	octave 3
	note G_, 4
	note F#, 2
	note E_, 2
	note D_, 2
	sound_ret

Music_Pokecenter_Ch2_sub2:
	note E_, 2
	note D_, 2
	note C_, 2
	octave 2
	note B_, 2
	note A_, 2
	note B_, 2
	octave 3
	note C_, 2
	note D_, 2
	sound_ret

Music_Pokecenter_Ch2_sub3:
	note D_, 2
	octave 2
	note A_, 2
	octave 3
	note D_, 2
	note F#, 4
	note E_, 2
	note D_, 2
	note C_, 2
	sound_ret


Music_Pokecenter_Ch1:
	tempo 144
	vibrato 8, 2, 5

Music_Pokecenter_Ch1_mainloop:
	sound_call Music_Pokecenter_Ch1_sub1
	channel_volume 11
	note_type 12, 3, 10, 1, 3
	note D_, 4
	octave 2
	note A_, 4
	sound_call Music_Pokecenter_Ch1_sub2
	note G_, 2
	note B_, 6
	channel_volume 11
	note_type 12, 3, 10, 1, 3
	note D_, 4
	octave 2
	note A_, 4
	sound_call Music_Pokecenter_Ch1_sub1
	channel_volume 11
	note_type 12, 3, 10, 1, 3
	note D_, 4
	octave 2
	note A_, 4
	sound_call Music_Pokecenter_Ch1_sub2
	note_type 12, 1, 9, 1, 7
	note G_, 8
	channel_volume 11
	note_type 12, 3, 10, 1, 3
	octave 2
	note G_, 4
	note A_, 4
	channel_volume 13
	note_type 12, 1, 9, 1, 7
	octave 3
	note B_, 8
	octave 4
	note D_, 8
	note C_, 2
	note D_, 2
	note C_, 2
	octave 3
	note B_, 2
	note A_, 8
	note F#, 8
	note A_, 8
	sound_call Music_Pokecenter_Ch1_sub3
	octave 3
	note B_, 8
	octave 4
	note D_, 8
	note C_, 2
	octave 3
	note B_, 2
	octave 4
	note C_, 2
	note D_, 2
	note E_, 8
	note D_, 4
	note C_, 2
	octave 3
	note B_, 2
	octave 4
	note C_, 8
	sound_call Music_Pokecenter_Ch1_sub3
	sound_loop 0, Music_Pokecenter_Ch1_mainloop

Music_Pokecenter_Ch1_sub1:
	channel_volume 13
	note_type 12, 1, 9, 1, 3
	octave 3
	note G_, 2
	note D_, 2
	note G_, 2
	octave 4
	note D_, 4
	note C_, 4
	octave 3
	note B_, 2
	note A_, 2
	note F#, 6
	sound_ret

Music_Pokecenter_Ch1_sub2:
	channel_volume 13
	note_type 12, 1, 9, 1, 3
	octave 3
	note F#, 2
	note D_, 2
	note F#, 2
	note B_, 4
	note A_, 4
	note F#, 2
	sound_ret

Music_Pokecenter_Ch1_sub3:
	octave 3
	note B_, 2
	octave 4
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	note G_, 8
	sound_ret


Music_Pokecenter_Ch3:
	hill_type 12, 0, 47

Music_Pokecenter_Ch3_mainloop:
	sound_call Music_Pokecenter_Ch3_sub4
	sound_call Music_Pokecenter_Ch3_sub1
	sound_call Music_Pokecenter_Ch3_sub2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	note C_, 2
	note D_, 2
	sound_call Music_Pokecenter_Ch3_sub4
	sound_call Music_Pokecenter_Ch3_sub1
	sound_call Music_Pokecenter_Ch3_sub2
	octave 3
	note G_, 2
	note B_, 2
	note G_, 2
	note B_, 2
	note G_, 2
	octave 4
	note E_, 2
	note D_, 2
	note C_, 2
	sound_call Music_Pokecenter_Ch3_sub3
	sound_call Music_Pokecenter_Ch3_sub5
	sound_call Music_Pokecenter_Ch3_sub6
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	note C#, 2
	note D_, 2
	sound_call Music_Pokecenter_Ch3_sub3
	sound_call Music_Pokecenter_Ch3_sub5
	sound_call Music_Pokecenter_Ch3_sub6
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	sound_loop 0, Music_Pokecenter_Ch3_mainloop

Music_Pokecenter_Ch3_sub1:
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	sound_ret

Music_Pokecenter_Ch3_sub2:
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	note C_, 2
	note D_, 2
	sound_ret

Music_Pokecenter_Ch3_sub3:
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	sound_ret

Music_Pokecenter_Ch3_sub4:
	octave 3
	note G_, 2
	note B_, 2
	note G_, 2
	note B_, 2
	note G_, 2
	note B_, 2
	octave 4
	note C_, 2
	octave 3
	note B_, 2
	sound_ret

Music_Pokecenter_Ch3_sub5:
	note C_, 2
	note E_, 2
	note C_, 2
	note E_, 2
	note C_, 2
	note E_, 2
	note C_, 2
	note E_, 2
	sound_ret

Music_Pokecenter_Ch3_sub6:
	octave 3
	note A_, 2
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	octave 4
	note C_, 2
	sound_ret

Music_Pokecenter_Ch4:
	drum_speed 6
	frame_swap
	rest 3
	frame_swap
	rest 4
	frame_swap
	rest 2
	frame_swap
	rest 2
	frame_swap
	rest 8
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4

Music_Pokecenter_Ch4_mainloop:
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4

Music_Pokecenter_Ch4_loop1:
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 2
	frame_swap
	rest 2
	frame_swap
	rest 8
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	sound_loop 3, Music_Pokecenter_Ch4_loop1

Music_Pokecenter_Ch4_loop2:
	frame_swap
	rest 8
	frame_swap
	rest 8
	frame_swap
	rest 8
	frame_swap
	rest 8
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 8
	frame_swap
	rest 8
	sound_loop 3, Music_Pokecenter_Ch4_loop2
	frame_swap
	rest 6
	frame_swap
	rest 2
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 8
	frame_swap
	rest 8
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 8
	frame_swap
	rest 8
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 2
	frame_swap
	rest 2
	frame_swap
	rest 8
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	sound_loop 0, Music_Pokecenter_Ch4_mainloop
