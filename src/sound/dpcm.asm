
.incbin "src/raw-data/dpcm-area.bin"

DPCM_c800:
	dpcm_entry 15, $c000, $13

DPCM_c804:
	dpcm_entry 15, $c100, $2f

DPCM_c808:
	dpcm_entry 14, $c100, $2f

DPCM_c80c:
	dpcm_entry 15, $c640, $8

DPCM_c810:
	dpcm_entry 13, $c640, $8

DPCM_c814:
	dpcm_entry 15, $c6c0, $14

DPCM_c818:
	dpcm_entry 13, $c6c0, $14