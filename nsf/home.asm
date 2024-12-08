
NSF_GetMusicID:
	PHP
	JSR NSF_InitSound
	PLP
	TAX
	LDA NSF_Music, X
	JMP PlayAudio

NSF_InitSound:
	LDA #0
	STA DPCM_DELTA
	STA DPCM_OFFSET
	STA DPCM_SIZE
	LDA #0
	STA DPCM_ENV
	LDA #SQ1_F | SQ2_F | TRI_F | NOISE_F | DPCM_F
	STA SND_CHN
	LDA #<MusicHeaders
	SEC
	SBC #header_byte_length
	STA zMusicStartingHeaderPointer
	LDA #>MusicHeaders
	SBC #0
	STA zMusicStartingHeaderPointer + 1
	LDA #<Instruments
	STA zInstrumentPointer
	LDA #>Instruments
	STA zInstrumentPointer + 1
	LDA #$00
	STA zfe
	LDA #$c8
	STA zff
	LDA #NO_MUSIC
	JSR PlayAudio
	LDA #0
	STA iMusicTracks
	STA i6b9
	STA iMusicID1
	STA iMusicID2
	RTS

NSF_Music:
IFNDEF POKEMON_RED_MUSIC_SOUNDFONT
	.db MUSIC_TITLE
	.db MUSIC_FLOWER
	.db MUSIC_FLOWER_MENU
	.db MUSIC_STAR
	.db MUSIC_STAR_MENU
	.db MUSIC_MUSHROOM
	.db MUSIC_MUSHROOM_MENU
	.db MUSIC_VS_MATCH
	.db MUSIC_GAME_OVER
	.db MUSIC_STAGE_CLEAR
	.db MUSIC_CURRENT_SCORE
	.db MUSIC_VS_MENU
	.db MUSIC_GAME_POINT
	.db MUSIC_VS_RESULTS
	.db MUSIC_UNUSED
	.db MUSIC_ROUND_END
ELSE
	.db MUSIC_TITLE_SCREEN
	.db MUSIC_POKEMON_CENTER
	.db MUSIC_POKEMON_CENTER_MENU
	.db MUSIC_VIRIDIAN_CITY
	.db MUSIC_VIRIDIAN_CITY_MENU
	.db MUSIC_CELADON_CITY
	.db MUSIC_CELADON_CITY_MENU
	.db MUSIC_GAME_CORNER
	.sb MUSIC_GAME_OVER
	.db MUSIC_HEAL_POKEMON
	.db MUSIC_CURRENT_SCORE
	.db MUSIC_OAKS_LAB
	.db MUSIC_EVOLUTION_DITTY
	.db MUSIC_TRAINER_VICTORY
	.db MUSIC_UNUSED
	.db MUSIC_ITEM
ENDIF
NSF_Music_End: