Music_Flower_Ch2:
	channel_volume 11
	vibrato 1, 0, 0
	note_type 12, 2, 0, 1, 4
	rest 4
	octave 4
	note C_, 4
	rest 4
	octave 3
	note B_, 4
	rest 4
	channel_volume 9
	note E_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	rest 8

Music_Flower_Ch2_Menu:
	channel_volume 11
	pitch_inc_switch
	vibrato 12, 1, 3
	note_type 12, 2, 0, 1, 4
	rest 16
	rest 10
	octave 3
	note G_, 1
	note F_, 1
	note E_, 1
	note F_, 1
	note E_, 1
	note D_, 1
	note C_, 2
	octave 2
	note G_, 2
	octave 3
	note C_, 2
	note E_, 2
	note D_, 2
	note F_, 2
	note C_, 2
	note E_, 2
	note D_, 2
	octave 2
	note B_, 1
	octave 3
	note C_, 1
	note D_, 2
	note F_, 2
	note G_, 4
	note F_, 4

Music_Flower_Ch2_Mainloop:
	note E_, 2
	note C_, 2
	note E_, 2
	note G_, 2
	note F_, 2
	note C_, 2
	note E_, 2
	note C_, 2
	note D_, 2
	octave 2
	note B_, 1
	octave 3
	note C_, 1
	note D_, 2
	note F_, 2
	note E_, 2
	note F_, 1
	note E_, 1
	note D_, 2
	note G_, 2
	note C_, 2
	note D_, 2
	note E_, 2
	note D_, 2
	note E_, 1
	note D_, 1
	note C_, 2
	note E_, 2
	note G_, 2
	note D_, 4
	note F_, 4
	note G_, 2
	note F_, 2
	note F_, 2
	note D_, 2
	note E_, 2
	note G_, 2
	note C_, 2
	note E_, 1
	note G_, 1
	note F_, 4
	note G_, 2
	note E_, 2
	note F_, 2
	note F_, 2
	note E_, 2
	note E_, 2
	note D_, 2
	note F_, 2
	octave 2
	note B_, 2
	octave 3
	note F_, 2
	note G_, 1
	note F_, 1
	note E_, 2
	note E_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note D_, 1
	note C_, 1
	octave 2
	note B_, 1
	octave 3
	note C_, 1
	note D_, 2
	note E_, 2
	note F_, 2
	note E_, 2
	note F_, 2
	note A_, 2
	note G_, 1
	note F_, 1
	note E_, 1
	note D_, 1
	note C_, 2
	octave 2
	note B_, 2
	note A_, 2
	note B_, 2
	octave 3
	note C_, 2
	note C_, 2
	note D_, 1
	note C_, 1
	octave 2
	note B_, 1
	note A_, 1
	octave 3
	note C_, 2
	note E_, 2
	note F_, 1
	note D_, 1
	note E_, 1
	note C_, 1
	note D_, 6
	rest 16
	note G_, 4
	note G_, 8
	note F_, 2
	note E_, 8
	note C_, 4
	rest 16
	note G_, 2
	note F_, 2
	note E_, 2
	note F_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note E_, 2
	note G_, 2
	note A_, 1
	note F_, 1
	note G_, 1
	note E_, 1
	note F_, 2
	note E_, 1
	note G_, 1
	note A_, 1
	note G_, 1
	note A_, 2
	note B_, 2
	octave 4
	note D_, 2
	note_type 12, 2, 0, 4, 1
	note E_, 8
	note C_, 8
	note F_, 8
	note D_, 4
	note E_, 4
	note G_, 8
	note E_, 4
	note B_, 4
	note_type 12, 2, 0, 1, 4
	note E_, 8
	note E_, 8
	note C_, 8
	octave 3
	note B_, 8
	note A_, 8
	note G_, 8
	note A_, 8
	note B_, 8
	note G_, 4
	note F_, 4
	note E_, 4
	note D_, 4
	octave 4
	note C_, 4
	octave 3
	note B_, 4
	note A_, 4
	note G_, 2
	note B_, 2
	octave 4
	note C_, 4
	octave 3
	note F_, 4
	note G_, 4
	note C_, 4
	note D_, 4
	note E_, 4
	note F_, 4
	note G_, 4
	rest 16
	rest 16
	rest 16
	rest 16
	sound_loop 0, Music_Flower_Ch2_Mainloop

Music_Flower_Ch1:
	tempo 240
	vibrato 1, 0, 0
	channel_volume 13
	note_type 12, 2, 2, 2, 6
	octave 4
	note C_, 2
	note D_, 2
	note E_, 4
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	note C_, 4
	note D_, 4
	note C_, 2
	octave 3
	note G_, 2
	note F_, 2
	note G_, 2

Music_Flower_Ch1_Menu:
	tempo 240
	channel_volume 13
	vibrato 12, 1, 2
	note_type 12, 2, 2, 2, 6
	sound_call Music_Flower_Ch1_Sub2
	note E_, 4
	note D_, 2
	note C_, 1
	note D_, 1
	sound_call Music_Flower_Ch1_Sub3
	note E_, 2
	note F_, 1
	note E_, 1
	note D_, 4

Music_Flower_Ch1_Mainloop:
	rest 2
	note C_, 1
	note D_, 1
	note E_, 2
	note F_, 1
	note E_, 1
	note D_, 2
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	note D_, 2
	note E_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	note G_, 2
	note B_, 2
	octave 4
	note G_, 1
	note F_, 1
	note E_, 1
	note D_, 1
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	octave 4
	note E_, 2
	octave 3
	note G_, 2
	octave 4
	note E_, 2
	note F_, 2
	note D_, 1
	note E_, 1
	note F_, 2
	note C_, 2
	octave 3
	note B_, 2
	octave 4
	note F_, 2
	note D_, 2
	note F_, 2
	note E_, 2
	note C_, 1
	note D_, 1
	note E_, 2
	note D_, 2
	note C_, 2
	note D_, 2
	note E_, 2
	note C_, 2
	note D_, 1
	note C_, 1
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	note D_, 2
	note E_, 2
	note F_, 8

Music_Flower_Ch1_Loop1:
	note_type 12, 2, 2, 1, 8
	note E_, 2
	note E_, 2
	note_type 12, 2, 2, 2, 6
	note E_, 1
	note D_, 1
	note C_, 1
	note D_, 1
	note_type 12, 2, 2, 1, 8
	note C_, 2
	note C_, 1
	note_type 12, 2, 2, 2, 6
	octave 3
	note B_, 1
	note A_, 1
	note G_, 1
	note F_, 1
	note G_, 1
	note_type 12, 2, 2, 1, 8
	note A_, 2
	note A_, 2
	octave 4
	note C_, 2
	note C_, 2
	note_type 12, 2, 2, 2, 6
	octave 3
	note B_, 2
	octave 4
	note C_, 2
	note D_, 4
	sound_loop 2, Music_Flower_Ch1_Loop1
	note C_, 1
	octave 3
	note B_, 1
	note A_, 2
	note G_, 2
	octave 4
	note E_, 2
	octave 3
	note G_, 2
	octave 4
	note E_, 2
	note C_, 2
	note E_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 1
	note D_, 1
	octave 3
	note B_, 2
	octave 4
	note C_, 2
	note D_, 4
	sound_call Music_Flower_Ch1_Sub1
	note C_, 4
	sound_call Music_Flower_Ch1_Sub1
	note C_, 2
	note C_, 1
	note D_, 1
	note E_, 2
	note C_, 2
	note F_, 4
	sound_call Music_Flower_Ch1_Sub1
	note_type 12, 2, 2, 1, 8
	note C_, 2
	note C_, 1
	note_type 12, 2, 2, 2, 6
	note D_, 1
	note E_, 1
	note D_, 1
	note C_, 1
	note D_, 1
	note_type 12, 2, 2, 1, 8
	note F_, 2
	note F_, 2
	note E_, 2
	note E_, 2
	note_type 12, 2, 2, 2, 6
	note D_, 2
	note E_, 2
	note F_, 4
	note_type 12, 2, 2, 1, 7
	note G_, 8
	note E_, 8
	note A_, 8
	note F_, 8
	note B_, 8
	note G_, 8
	note_type 12, 2, 2, 1, 12
	octave 5
	note C_, 2
	note C_, 2
	octave 4
	note B_, 2
	note B_, 2
	note A_, 1
	note G_, 1
	note A_, 2
	note B_, 2
	note G_, 2
	octave 5
	note C_, 2
	note C_, 1
	note D_, 1
	note C_, 1
	octave 4
	note B_, 1
	note A_, 1
	note G_, 1
	note E_, 1
	note F_, 1
	note G_, 2
	note C_, 2
	note G_, 2
	note A_, 1
	note G_, 1
	note F_, 1
	note G_, 1
	note A_, 2
	note B_, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 1
	note E_, 1
	note F_, 2
	note E_, 1
	note F_, 1
	note G_, 2
	note F_, 1
	note G_, 1
	note A_, 2
	note B_, 2
	note G_, 2
	note_type 12, 2, 2, 2, 6
	note G_, 1
	note F_, 1
	note E_, 1
	note D_, 1
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	note E_, 8
	note G_, 8
	note_type 12, 2, 2, 1, 8
	note E_, 2
	note E_, 2
	note E_, 1
	note_type 12, 2, 2, 2, 6
	note D_, 1
	note C_, 1
	note D_, 1
	note C_, 2
	note C_, 1
	octave 3
	note B_, 1
	note A_, 1
	note G_, 1
	note F_, 1
	note G_, 1
	note_type 12, 2, 2, 1, 8
	note A_, 2
	note A_, 2
	octave 4
	note C_, 2
	note C_, 2
	note_type 12, 2, 2, 2, 6
	octave 3
	note B_, 2
	octave 4
	note C_, 2
	note D_, 4
	sound_call Music_Flower_Ch1_Sub2
	note E_, 2
	note C_, 2
	note D_, 4
	sound_call Music_Flower_Ch1_Sub3
	note E_, 4
	note D_, 4
	sound_loop 0, Music_Flower_Ch1_Mainloop

Music_Flower_Ch1_Sub1:
	note G_, 1
	note E_, 1
	note F_, 1
	note D_, 1
	note E_, 1
	note C_, 1
	note D_, 1
	octave 3
	note B_, 1
	octave 4
	sound_ret

Music_Flower_Ch1_Sub2:
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	note E_, 2
	note D_, 2
	octave 3
	note G_, 2
	octave 4
	note D_, 2
	note F_, 2
	note E_, 2
	note C_, 1
	note D_, 1
	note E_, 2
	note F_, 2
	sound_ret

Music_Flower_Ch1_Sub3:
	note E_, 2
	note C_, 2
	note E_, 2
	note G_, 2
	note F_, 2
	note C_, 2
	note E_, 2
	note C_, 2
	note D_, 2
	octave 3
	note G_, 2
	octave 4
	note D_, 2
	note F_, 2
	sound_ret

Music_Flower_Ch3:
	vibrato 32, 2, 1
	hill_type 12, 1, 4
	rest 4
	rest 16
	rest 16

Music_Flower_Ch3_Menu:
	vibrato 32, 2, 1
	hill_type 12, 1, 4
	rest 16
	rest 16
	rest 16
	rest 12
	octave 2
	note B_, 1
	octave 3
	note C_, 1
	note D_, 1
	octave 2
	note B_, 1

Music_Flower_Ch3_Mainloop:
	octave 3
	note C_, 2
	octave 2
	note G_, 2
	octave 3
	note C_, 2
	note E_, 2
	note D_, 2
	note G_, 2
	note C_, 2
	note E_, 2
	note D_, 1
	note C_, 1
	octave 2
	note B_, 1
	octave 3
	note C_, 1
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note D_, 4
	note G_, 6
	rest 14
	rest 16
	note E_, 2
	note C_, 2
	note E_, 2
	note G_, 2
	note F_, 4
	note E_, 4
	hill_type 12, 0, 97
	note D_, 4
	sound_call Music_Flower_Ch3_Sub1
	note G_, 4
	rest 16
	rest 16
	rest 16
	note F_, 2
	note E_, 2
	sound_call Music_Flower_Ch3_Sub1
	note F_, 1
	note G_, 1
	note A_, 1
	note B_, 1
	hill_type 12, 0, 49
	octave 4
	note C_, 2
	note C_, 2
	hill_type 12, 1, 4
	note C_, 1
	octave 3
	note B_, 1
	note A_, 1
	note B_, 1
	octave 4
	note C_, 2
	note D_, 2
	note E_, 2
	note C_, 2
	note D_, 4
	note C_, 4
	octave 3
	note B_, 2
	note A_, 2
	note G_, 2
	note B_, 2
	octave 4
	note C_, 1
	rest 7
	note G_, 1
	note E_, 1
	note F_, 1
	note D_, 1
	note E_, 1
	note C_, 1
	note D_, 1
	octave 3
	note B_, 1
	octave 4
	note C_, 4
	rest 12
	rest 12
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note G_, 2
	note A_, 4
	note B_, 2
	note G_, 2
	octave 4
	note C_, 1
	note D_, 1
	note E_, 1
	note F_, 1
	note G_, 12
	note D_, 1
	note E_, 1
	note F_, 1
	note G_, 1
	note A_, 12
	note E_, 1
	note F_, 1
	note G_, 1
	note A_, 1
	note B_, 4
	note A_, 2
	note B_, 2
	note G_, 2
	note B_, 2
	octave 5
	note C_, 8
	octave 4
	note B_, 8
	note A_, 8
	note G_, 8
	note F_, 8
	note E_, 8
	note D_, 8
	note G_, 8
	hill_type 12, 0, 49
	note C_, 2
	note C_, 2
	octave 3
	note B_, 2
	note B_, 2
	hill_type 12, 1, 4
	note A_, 1
	note G_, 1
	note A_, 2
	note B_, 2
	note G_, 2
	hill_type 12, 0, 49
	octave 4
	note C_, 2
	hill_type 12, 1, 4
	note C_, 1
	note D_, 1
	note C_, 1
	octave 3
	note B_, 1
	note A_, 1
	note G_, 1
	note E_, 1
	note F_, 1
	note G_, 2
	note C_, 2
	note G_, 2
	note A_, 1
	note G_, 1
	note F_, 1
	note G_, 1
	note A_, 2
	note B_, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 1
	note E_, 1
	note F_, 2
	note E_, 1
	note F_, 1
	note G_, 2
	note F_, 1
	note G_, 1
	note A_, 2
	note B_, 2
	octave 4
	note D_, 2
	note C_, 8
	note D_, 8
	note E_, 8
	note F_, 8
	note G_, 8
	note F_, 4
	note E_, 4
	note D_, 8
	note E_, 4
	note F_, 4
	sound_loop 0, Music_Flower_Ch3_Mainloop

Music_Flower_Ch3_Sub1:
	hill_type 12, 1, 4
	note D_, 1
	note C_, 1
	octave 2
	note B_, 1
	octave 3
	note C_, 1
	note D_, 4
	sound_ret

Music_Flower_Ch4:
	drum_speed 12
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
	rest 4

Music_Flower_Ch4_Menu:
	drum_speed 12
	frame_swap
	rest 7
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

Music_Flower_Ch4_Mainloop:
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	sound_loop 2, Music_Flower_Ch4_Mainloop

Music_Flower_Ch4_Loop1:
	frame_swap
	rest 8
	frame_swap
	rest 8
	sound_loop 2, Music_Flower_Ch4_Loop1

Music_Flower_Ch4_Loop2:
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	sound_loop 2, Music_Flower_Ch4_Loop2
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
	rest 2
	frame_swap
	rest 2
	frame_swap
	rest 2
	frame_swap
	rest 2
	frame_swap
	rest 4
	frame_swap
	rest 4

Music_Flower_Ch4_Loop3:
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 4
	sound_loop 4, Music_Flower_Ch4_Loop3
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
	rest 8
	frame_swap
	rest 4
	frame_swap
	rest 4

Music_Flower_Ch4_Loop4:
	frame_swap
	rest 8
	frame_swap
	rest 8
	sound_loop 4, Music_Flower_Ch4_Loop4

Music_Flower_Ch4_Loop5:
	frame_swap
	rest 2
	frame_swap
	rest 2
	frame_swap
	rest 2
	frame_swap
	rest 2
	frame_swap
	rest 2
	frame_swap
	rest 2
	frame_swap
	rest 2
	frame_swap
	rest 2
	sound_loop 4, Music_Flower_Ch4_Loop5

Music_Flower_Ch4_Loop6:
	frame_swap
	rest 8
	frame_swap
	rest 8
	sound_loop 2, Music_Flower_Ch4_Loop6
	frame_swap
	rest 8
	frame_swap
	rest 4
	frame_swap
	rest 4
	frame_swap
	rest 8
	frame_swap
	rest 4
	frame_swap
	rest 4
	sound_loop 0, Music_Flower_Ch4_Mainloop
