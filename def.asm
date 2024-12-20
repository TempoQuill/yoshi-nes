.ignorenl

RESET_0 = $bfda
RESET_1 = $ffda

CHR_A12_INVERSION = $80

NAMETABLE_SIZE = $3c0
NAMETABLE_0 = $20
NAMETABLE_1 = $24
NAMETABLE_2 = $28
NAMETABLE_3 = $2c

NT_ATTRIBUTE_SIZE = $40
NT_ATTRIBUTE_0 = $23c0
NT_ATTRIBUTE_1 = $27c0
NT_ATTRIBUTE_2 = $2bc0
NT_ATTRIBUTE_3 = $2fc0

FIELD_MUSHROOM   = $00
FIELD_FIREFLOWER = $01
FIELD_PIRANHA    = $02
FIELD_KOOPA      = $03
FIELD_STARMAN    = $04
FIELD_BERRY      = $05
FIELD_STRAWBERRY = $06
FIELD_MELON      = $07
FIELD_PEACH      = $08
FIELD_GRAPES     = $09
FIELD_PINEAPPLE  = $0a
FIELD_CHERRY     = $0b
FIELD_KEY        = $0c
FIELD_COIN       = $0d
FIELD_P_SWITCH   = $0e

; enum PPUControl (bitfield) (width 1 byte)
; 0: $2000 1: $2400 2: $2800 3: $2c00
NT_BASE_MASK = $3

VRAM_INC  = $04 ; 0: horizontal 1: vertical
OBJ_TABLE = $08 ; 0: $0000      1: $1000
BG_TABLE  = $10 ; 0: $0000      1: $1000
OBJ_RES   = $20 ; 0: 8x8        1: 8x16
MS_SELECT = $40 ; 0: read       1: output
NMI       = $80 ; 0: off        1: on

PPUStatus_VBlankHit = $80

BATTERY_RAM      = 2
IGNORE_MIRRORING = 8

NES_2_0 = 8

; reference: NTSC NES runs at 1,789,773 Hz
; each frame contains 29,780 cycles
; therefore NTSC NES runs at 60,099.832 mHz
;            PAL NES runs at 1,662,607 Hz
; each frame contains 33,248 cycles
; therefore PAL NES runs at 50,006.226 mHz

; you can do more with PAL NES due to the lower framerate having more cycles than NTSC
; in theory porting to NTSC would cause lag.

;
; PPU registers
; $2000-$2007
;

PPUCTRL = $2000   ; control
PPUMASK = $2001   ; mask
PPUSTATUS = $2002 ; status
OAMADDR = $2003   ; oam location
OAMDATA = $2004   ; current byte
PPUSCROLL = $2005 ; scroll position
PPUADDR = $2006   ; ppu location
PPUDATA = $2007   ; current byte

PPU_PALETTES = $3f00
num_pals = 8
pal_size = 4
res_horizontal = 256
res_vertical = 240

;
; APU registers and joypad registers
;  $4000-$4015         $4016-$4017
; APU Features
; volume (with barebones sweep functions) (pulses, noise)
; 11-bit pitch (pulses, hill)
; some features run at 240 Hz rather than the standard 60, marked by *
;

SQ1_ENV = $4000   ; 0-3: volume/sweep speed* 4:   volume sweep Flag 5:   counter flag 6-7: cycle id
SQ1_SWEEP = $4001 ; 0-2: shift multiplier    3:   direction         4-6: period       7:   power flag
SQ1_LO = $4002    ; 0-7: pitch
SQ1_HI = $4003    ; 0-2: pitch               3-7: length

SQ2_ENV = $4004
SQ2_SWEEP = $4005
SQ2_LO = $4006
SQ2_HI = $4007

; $4009 isn't functional
TRI_LINEAR = $4008 ; 0-6: linear load* 7:   linear flag
TRI_LO = $400a     ; 0-7: pitch
TRI_HI = $400b     ; 0-2: pitch        3-7: length load

; $400d isn't functional
NOISE_ENV = $400c ; 0-3: volume/sweep speed* 4: volume sweep Flag 5: counter flag
NOISE_LO = $400e  ; 0-3: pitch               7: period loop flag
NOISE_HI = $400f  ; 3-7: length load

; there are a few hardware bugs with the DPCM to beware of
; firstly, sample playback can clobber JOY1 with forged inputs
; secondly, writes to SND_CHN may replay the sample currently playing
; thirdly, a byte gets added to the total size of the currently playing sample
;	so a sample with a size of $20 reads $201 bytes of data
DPCM_ENV = $4010    ; 0-3: pitch 6: loop flag 7: IRQ flag
DPCM_DELTA = $4011  ; 0-6: delta counter
DPCM_OFFSET = $4012 ; 0-7: (offset - $c000) / $40
DPCM_SIZE = $4013   ; 0-7: (size - 1) / $10

OAM_DMA = $4014   ; CPU memory page $XX00 - $XXFF

SND_CHN = $4015   ; master APU register: each bit is the corresponding channel power flag, 5-7 are not used

JOY1 = $4016
JOY2 = $4017

; inputs
BTN_A      = %00000001
BTN_B      = %00000010
BTN_SELECT = %00000100
BTN_START  = %00001000
BTN_UP     = %00010000
BTN_DOWN   = %00100000
BTN_LEFT   = %01000000
BTN_RIGHT  = %10000000

num_inputs = 8

; mapper stuff
MMC1_4MIRROR_L = $0
MMC1_4MIRROR_H = $1
MMC1_2MIRROR_V = $2
MMC1_2MIRROR_H = $3
PRG_32K = $0
PRG_M0D = $4
PRG_U16 = $8
PRG_L16 = $c
CHR_MODE = $10

PRG_Main = 0
PRG_Audio = 1
PRG_Home = 7

CHR_Title      = $00
CHR_VS_Results = $01
CHR_VS_BG      = $02
CHR_VS_OBJ     = $03
CHR_Field_BG   = $04
CHR_Field_OBJ  = $05
CHR_1P         = $06
CHR_Records    = $07
Num_CHRs = 8

MMC1 = 1
MMC1_Control = $8000
MMC1_CHRBank1 = $a000
MMC1_CHRBank2 = $c000
MMC1_RomBank = $e000

header_byte_length = 3
channel_mask = %00000011
num_channels = 8

Ramp_Mask     = %00001111
Volume_Ramp_F = %00010000
Volume_Loop_F = %00100000
Cycle_Mask    = %11000000

Linear_Mask = %01111111
Linear_Flag = %10000000

PITCH_HI_MASK = %00000111
PITCH_ID_MASK = %11110000

SQ1_F = %00000001
SQ2_F = %00000010
TRI_F = %00000100
NOISE_F = %00001000
DPCM_F = %00010000
PSG_MASK = %00001111

R_PARAM_ENV = 0
R_PARAM_SWEEP = 1
R_PARAM_LO = 2
R_PARAM_HI = 3

pitch_sweep_cmd = $10
sfx_pitch_inc_switch_cmd = $11
sfx_type_cmd = $20
note_type_cmd = $d0
octave_cmd = $e0
pitch_inc_switch_cmd = $e8
frame_swap_cmd = $e9
vibrato_cmd = $ea
pitch_slide_cmd = $eb
dummy_ec_cmd = $ec
tempo_cmd = $ed
new_song_cmd = $ee
channel_mute_cmd = $ef
channel_volume_cmd = $f0
sound_filler_cmd = $f8
sound_call_cmd = $fd
sound_loop_cmd = $fe
sound_ret_cmd = $ff

env_loop_cmd = $fe
env_ret_cmd = $ff

NUM_OCTAVES = 8

VOL_OFFSET_MASK = %00001111

SOUND_READING_MODE    = %00000001
SOUND_SUBROUTINE      = %00000010
SOUND_PITCH_INC       = %00000100
SOUND_PITCH_SWEEP     = %00001000
SOUND_INSTRUMENT      = %00010000
SOUND_PITCH_SLIDE     = %00100000
SOUND_PITCH_SLIDE_DIR = %01000000
SOUND_PITCH_SWAP      = %10000000

SOUND_VIBRATO_0       = %00000001
SOUND_VIBRATO_DIR     = %00000010
SOUND_VIBRATO_2       = %00000100
SOUND_VIBRATO_6       = %01000000
SOUND_VIBRATO_7       = %10000000

; music_d0
NOTE_LENGTH_MASK      = %00001111
NOTE_ID_MASK          = %00001111
NOTE_BLOCK_INSTRUMENT = %10000000
NOTE_TAIL_MASK        = %00001111
NOTE_FADE_SPEED_MASK  = %11110000

; vibrato
VIBRATO_SPEED_MASK = %00001111
VIBRATO_DEPTH_MASK = %11110000

CHAN_0 = $0
CHAN_1 = $1
CHAN_2 = $2
CHAN_3 = $3
CHAN_4 = $4
CHAN_5 = $5
CHAN_6 = $6
CHAN_7 = $7
CHAN_8 = $8

B# = 0
Bx = 1
C_ = 0
C# = 1
Cx = 2
D♭♭ = 0
D♭ = 1
D_ = 2
D# = 3
Dx = 4
E♭♭ = 2
E♭ = 3
E_ = 4
E# = 5
Ex = 6
F♭♭ = 3
F♭ = 4
F_ = 5
F# = 6
Fx = 7
G♭♭ = 5
G♭ = 6
G_ = 7
G# = 8
Gx = 9
A♭♭ = 7
A♭ = 8
A_ = 9
A# = 10
Ax = 11
B♭♭ = 9
B♭ = 10
B_ = 11
C♭♭ = 10
C♭ = 11
NOTE_REST = 12

IFNDEF POKEMON_RED_MUSIC_SOUNDFONT
	.include "src/def/yoshi-drums.asm"
ELSE
	.include "src/def/red-drums.asm"
ENDIF
drum_boundary = (HeaderBoundary_Drums - MusicHeaders) / 3
.include "src/def/yoshi-sfx.asm"
sfx_boundary = (HeaderBoundary_SFX - MusicHeaders) / 3
IFNDEF POKEMON_RED_MUSIC_SOUNDFONT
	.include "src/def/yoshi-music.asm"
ELSE
	.include "src/def/red-music.asm"
ENDIF
music_boundary = (HeaderBoundary_Music - MusicHeaders) / 3

NO_MUSIC = $ff

.endinl
