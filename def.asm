.ignorenl

RESET_0 = $bfda
RESET_1 = $ffda

CHR_A12_INVERSION = $80

; enum PPUControl (bitfield) (width 1 byte)
PPUCtrl_BaseAddress = $03
PPUCtrl_Base2000 = $00
PPUCtrl_Base2400 = $01
PPUCtrl_Base2800 = $02
PPUCtrl_Base2C00 = $03
PPUCtrl_WriteHorizontal = $00
PPUCtrl_WriteVertical = $04
PPUCtrl_Sprite0000 = $00
PPUCtrl_Sprite1000 = $08
PPUCtrl_Background0000 = $00
PPUCtrl_Background1000 = $10
PPUCtrl_SpriteSize8x8 = $00
PPUCtrl_SpriteSize8x16 = $20
PPUCtrl_NMIDisabled = $00
PPUCtrl_NMIEnabled = $80

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

MMC1 = 1
MMC1_Control = $8000
MMC1_CHRBank1 = $a000
MMC1_CHRBank2 = $c000
MMC1_RomBank = $e000

header_byte_length = 3
channel_mask = %00000011
num_channels = $8
sfx_boundary = (HeaderBoundary_SFX - MusicHeaders) / 3
music_boundary = (HeaderBoundary_Music - MusicHeaders) / 3

Volume_Ramp_F = %00010000
Volume_Loop_F = %00100000
Cycle_Mask    = %11000000

SQ1_F = %00000001
SQ2_F = %00000010
TRI_F = %00000100
NOISE_F = %00001000
DPCM_F = %00010000

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
sound_call_cmd = $fd
sound_loop_cmd = $fe
sound_ret_cmd = $ff

SOUND_READING_MODE    = %00000001
SOUND_SUBROUTINE      = %00000010
SOUND_PITCH_INC       = %00000100
SOUND_PITCH_SWEEP     = %00001000
SOUND_INSTRUMENT      = %00010000
SOUND_PITCH_SLIDE     = %00100000
SOUND_PITCH_SLIDE_DIR = %01000000
SOUND_UNKNOWN_07      = %10000000

NOTE_BLOCK_INSTRUMENT = %10000000

CHAN_0 = $0
CHAN_1 = $1
CHAN_2 = $2
CHAN_3 = $3
CHAN_4 = $4
CHAN_5 = $5
CHAN_6 = $6
CHAN_7 = $7
CHAN_8 = $8

C_ = 0
C# = 1
D_ = 2
D# = 3
E_ = 4
F_ = 5
F# = 6
G_ = 7
G# = 8
A_ = 9
A# = 10
B_ = 11

.endinl
