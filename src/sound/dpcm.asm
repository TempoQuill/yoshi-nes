IFNDEF POKEMON_RED_MUSIC_SOUNDFONT
.incbin "src/raw-data/dpcm-area.bin"

Drum_SKick_Ch9:
	dpcm_entry 15, $c000, $13

Drum_SSnare_Ch9:
	dpcm_entry 15, $c100, $2f

Drum_SSnareLow_Ch9:
	dpcm_entry 14, $c100, $2f

Drum_SClave_Ch9:
	dpcm_entry 15, $c640, $8

Drum_SClaveLow_Ch9:
	dpcm_entry 13, $c640, $8

Drum_SHonk_Ch9:
	dpcm_entry 15, $c6c0, $14

Drum_SHonkLow_Ch9:
	dpcm_entry 13, $c6c0, $14
ELSE
.incbin "src/raw-data/dpcm-area-red.bin"
Drum_SSnare1_Ch8:
	dpcm_entry 14, $c000, $1c

Drum_SSnare2_Ch8:
	dpcm_entry 14, $c1c0, $1c

Drum_SSnare3_Ch8:
	dpcm_entry 14, $c380, $1c

Drum_SSnare4_Ch8:
	dpcm_entry 14, $c540, $1c

ENDIF