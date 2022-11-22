;===================================================================================================
; SNES Registers
;===================================================================================================
; Note: This is almost entirely a copy from the JP 1.0 disassembly.
;       See: https://github.com/spannerisms/jpdasm/ - 19/11/2022
;--------------------------------------------------------------------------------


;===================================================================================================
; KEY
;===================================================================================================
; w - writeable
; r - readable
; 1 - single write
; 2 - double write
;     for double write registers, the first write (low byte) is listed first
; f - accessible during fblank
; v - accessible during vblank
; h - accessible during hblank
; a - accessible anytime
; . - unused bit (open bus)

;================================================================================
; MSU-1 Registers
;--------------------------------------------------------------------------------
; MSU registers are located from $2000 to $2007. Comments indicate a register's
; length if it is greater than one and whether a label should be used for reading
; or writing.
;--------------------------------------------------------------------------------
base $2000
MSUSTATUS:       ; Reading
MSUSEEK: skip 1  ; Writing (4 bytes)
MSUDATA: skip 1  ; Reading
MSUID: skip 2    ; Reading (6 bytes)
MSUTRACK: skip 2 ; Writing (2 bytes)
MSUVOL: skip 1   ; Writing
MSUCTL:          ; Writing

;===================================================================================================
;===================================================================================================
; PPU REGISTERS
;===================================================================================================
;===================================================================================================

; SCREEN SETTINGS
; $2100 w1 fvha
; f... bbbb
; f - force blank (0: disabled | 1: enabled)
; b - screen brightness 0–F
INIDISP = $002100

; OAM CHARACTER ADDRESSES AND OBJECT SIZE
; $2101 w1 fv
; sssnnbbb
; s - object sizes
;     sss    small    large
;     000     8x8     16x16
;     001     8x8     32x32
;     010     8x8     64x64
;     011    16x16    32x32
;     100    16x16    64x64
;     101    32x32    64x64
;     110    16x32    32x64
;     111    16x32    32x32
;
; n - space between object namespaces, $1000 word steps
; b - obj tile address - $2000 word steps
OBSEL = $002101

; OAM ADDRESS ACCESS
; $2102 w1 fv
; $2103 w1 fv
;  OAMADDH  OAMADDL
; p......a aaaaaaaa
; a - OAM address
; p - object priority cycle (0: OBJ0 highest priority | 1: priority cycles)
OAMADDR = $002102
OAMADDL = $002102
OAMADDH = $002103

; OAM DATA WRITE
; $2104 w1 fv
; xxxxxxxx
; x - OAM data
OAMDATA = $002104

; BACKGROUND MODE AND CHARACTER SIZE
; $2105 w1 fvh
; dcba pmmm
; a - tile size for BG1 (0: 8x8 | 1: 16x16)
; b - tile size for BG2 (0: 8x8 | 1: 16x16)
; c - tile size for BG3 (0: 8x8 | 1: 16x16)
; d - tile size for BG4 (0: 8x8 | 1: 16x16)
; p - BG3 priority in mode 1 (0: normal | 1: highest)
; m - BG mode (0–7)
;           BG1    BG2    BG3    BG4   Features
;     00 - 2bpp   2bpp   2bpp   2bpp   None
;     01 - 4bpp   4bpp   2bpp   ----   None
;     02 - 4bpp   4bpp   offs   ----   Offset per tile
;     03 - 8bpp   4bpp   ----   ----   None
;     04 - 8bpp   2bpp   offs   ----   Offset per tile
;     05 - 4bpp   2bpp   ----   ----   Hires
;     06 - 4bpp   ----   offs   ----   Hires / Offset per tile
;     07 - 8bpp   EXT    ----   ----   Affine transformation
BGMODE = $002105

; MOSAIC SIZE AND DESIGNATION
; $2106 w1 fvh
; ssss dcba
; a - mosaic to BG1 (0: disabled | 1: enabled)
; b - mosaic to BG2 (0: disabled | 1: enabled)
; c - mosaic to BG3 (0: disabled | 1: enabled)
; d - mosaic to BG4 (0: disabled | 1: enabled)
; s - pixelation size
MOSAIC = $002106

; BACKGROUND TILEMAP ADDRESS AND TILEMAP SIZE
; $2107 w1 fv
; $2108 w1 fv
; $2109 w1 fv
; $210A w1 fv
; aaaa aavh
; a - tilemap address in $400 word steps
; v - tilemap height (0: 32 tiles | 1: 64 tiles)
; h - tilemap width (0: 32 tiles | 1: 64 tiles)
BG1SC = $002107
BG2SC = $002108
BG3SC = $002109
BG4SC = $00210A

; BACKGROUND CHARACTER ADDRESS
; $210B w1 fv
; $210C w1 fv
;  BG12NBA  BG34NBA
; bbbbaaaa ddddcccc
; a - base address for BG1 tiles in $1000 word steps
; b - base address for BG2 tiles in $1000 word steps
; c - base address for BG3 tiles in $1000 word steps
; d - base address for BG4 tiles in $1000 word steps
;     Just look at the nibbles
;     0   0000    $0000
;     1   0001    $2000
;     2   0010    $4000
;     etc...
BG12NBA = $00210B
BG34NBA = $00210C

; BACKGROUND HORIZONTAL AND VERTICAL SCROLL
; $210D w2 fvh
; $210E w2 fvh
; $210F w2 fvh
; $2110 w2 fvh
; $2111 w2 fvh
; $2112 w2 fvh
; $2113 w2 fvh
; $2114 w2 fvh
;
; modes 0–6: oooooooo ......oo
; o - bg offset
;
; mode 7:   mmmmmmmm ...mmmmm
; m - mode 7 bg offset
BG1HOFS = $00210D
BG1VOFS = $00210E
BG2HOFS = $00210F
BG2VOFS = $002110
BG3HOFS = $002111
BG3VOFS = $002112
BG4HOFS = $002113
BG4VOFS = $002114
M7HOFS = $00210D
M7VOFS = $00210E

; VRAM ADDRESS INCREMENT AND REMAPPING
; $2115 w1 fv
; a... mmii
; a - increment $2116[2] after (0: $2118 | 1 : $2119)
; m - remap addressing
;     00 = aaaaaaaabbbccccc => aaaaaaaabbbccccc (no remapping)
;     01 = aaaaaaaabbbccccc => aaaaaaaacccccbbb
;     10 = aaaaaaabbbcccccc => aaaaaaaccccccbbb
;     11 = aaaaaabbbccccccc => aaaaaacccccccbbb
;
; i - address increment
;     00 - increment by 1
;     01 - increment by 32
;     10 - increment by 128
;     11 - increment by 128
VMAIN = $002115

; VRAM ADDRESS ACCESS
; $2116 w1 fv
; $2117 w1 fv
;  VMADDL   VMADDH
; aaaaaaaa aaaaaaaa
; a - VRAM address
VMADDR = $002116
VMADDL = $002116
VMADDH = $002117

; VRAM WRITE DATA
; $2118 w1 fv
; $2119 w1 fv
;  VMDATAL  VMDATAH
; xxxxxxxx xxxxxxxx
; x - VRAM data
VMDATA = $002118
VMDATAL = $002118
VMDATAH = $002119

; MODE 7 SETTINGS
; $211A w1 fv
; we.. ..vh
; w - tilemap wrapping (0: wrap | 1: no wrap)
; e - empty space filler w/ no wrap (0: transparent | 1: tile 0)
; v - mirror tilemap vertically
; h - mirror tilemap horizontally
M7SEL = $00211A

; MODE 7 TRANSFORMATION PARAMETERS
; $211B w2 fvh
; $211C w2 fvh
; $211D w2 fvh
; $211E w2 fvh
; aaaaaaaa aaaaaaaa
; a - mode 7 parameter value
M7A = $00211B
M7B = $00211C
M7C = $00211D
M7D = $00211E

; #PPUMATH
; SIGNED MULTIPLICATION ARGUMENTS
; $211B w2 fvha
; $211C w1 fvha
; Can also be used for signed multiplication in mode 0–6
; apparently 0 delay with these
;
; PPUMULT16: llllllll hhhhhhhh
; l - low byte of 16-bit multiplicand
; h - high byte of 16-bit multiplicand
;
; PPUMULT8:  mmmmmmmm
; m - 8-bit multiplicand
PPUMULT16 = $00211B
PPUMULT8 = $00211C

; MODE 7 CENTER OF TRANSFORMATION COORDINATES
; $211F w2 fvh
; $2120 w2 fvh
; oooooooo ...ooooo
; o - mode 7 axis center
M7X = $00211F
M7Y = $002120

; CGRAM ADDRESS ACCESS
; $2121 w1 fvh
; aaaaaaaa
; a - CGRAM address indexing words
CGADD = $002121

; CGRAM WRITE DATA
; $2122 w2 fvh
; gggrrrrr .bbbbbgg
; r - red component of color
; g - green component of color
; b - blue component of color
CGDATA = $002122

; WINDOW MASK SETTINGS
; $2123 w1 fvh
; $2124 w1 fvh
; $2125 w1 fvh
;  W12SEL   W34SEL   SOBJSEL
; dmckbjai dmckbjai dmckbjai
; i - invert window 1 on BG1/BG3/OBJ (0: normal logic | 1: invert logic)
; a - enable window 1 on BG1/BG3/OBJ (0: disabled | 1: enabled)
;
; j - invert window 2 on BG1/BG3/OBJ (0: normal logic | 1: invert logic)
; b - enable window 2 on BG1/BG3/OBJ (0: disabled | 1: enabled)
;
; k - invert window 1 on BG2/BG4/COL (0: normal logic | 1: invert logic)
; c - enable window 1 on BG2/BG4/COL (0: disabled | 1: enabled)
;
; m - invert window 2 on BG2/BG4/COL (0: normal logic | 1: invert logic)
; d - enable window 2 on BG2/BG4/COL (0: disabled | 1: enabled)
W12SEL = $002123
W34SEL = $002124
WOBJSEL = $002125

; WINDOW POSITION DESIGNATION
; $2126 w1 fvh
; $2127 w1 fvh
; $2128 w1 fvh
; $2129 w1 fvh
;
;   WH0      WH1
; llllllll rrrrrrrr
; l - window 1 left edge
; r - window 1 right edge
;
;   WH2      WH3
; wwwwwwww eeeeeeee
; w - window 2 left edge
; e - window 2 right edge
WH0 = $002126
WH1 = $002127
WH2 = $002128
WH3 = $002129
WINDOW1L = $002126
WINDOW1R = $002127
WINDOW2L = $002128
WINDOW2R = $002129

; WINDOW MASK LOGIC
; $212A w1 fvh
; $212B w1 fvh
;  WBGLOG   WOBJLOG
; ddccbbaa ....ccoo
; a - window mask logic for BG1
; b - window mask logic for BG2
; c - window mask logic for BG3
; d - window mask logic for BG4
; o - window mask logic for OBJ
; c - window mask logic for COL
;
; all window masks share the same logic
;     00 - W1 OR W2
;     01 - W1 AND W2
;     10 - W1 XOR W2
;     11 - W1 XNOR W2
WBGLOG = $00212A
WOBJLOG = $00212B

; MAIN AND SUB SCREEN DESIGNATION
; $212C w1 fvh
; $212D w1 fvh
; ...odcba
; a - BG1 (0: disabled | 1: enabled on main/subscreen)
; b - BG2 (0: disabled | 1: enabled on main/subscreen)
; c - BG3 (0: disabled | 1: enabled on main/subscreen)
; d - BG4 (0: disabled | 1: enabled on main/subscreen)
; o - OBJ (0: disabled | 1: enabled on main/subscreen)
TM = $00212C
TS = $00212D
MAINDES = $00212C
SUBDES = $00212D

; MAIN AND SUB SCREEN WINDOW MASK DESIGNATION
; $212E w1 fvh
; $212F w1 fvh
; ...odcba
; a - window mask for BG1 (0: disabled | 1: enabled)
; b - window mask for BG2 (0: disabled | 1: enabled)
; c - window mask for BG3 (0: disabled | 1: enabled)
; d - window mask for BG4 (0: disabled | 1: enabled)
; o - window mask for OBJ (0: disabled | 1: enabled)
TMW = $00212E
TSW = $00212F

; COLOR MATH SETTINGS
; $2130 w1 fvh
; bbmm ..sd
; b - clip to black (same logic as m)
; m - prevent color math
;     00 - never
;     01 - outside COL window
;     10 - inside COL window
;     11 - always
;
; s - color source (0: fixed color | 1: subscreen)
; d - direct color mode (0: enabled | 1: disabled)
CGWSEL = $002130

; COLOR MATH DESIGNATION AND OPERATION
; $2131 w1 fvh
; shzo dcba
; s - color operation (0: addition | 1: subtraction)
; h - half color math (0: nothing | 1: final result divided by 2)
; z - color math on CGRAM0 (0: disabled | 1: enabled)
; a - color math on BG1 (0: disabled | 1: enabled)
; b - color math on BG2 (0: disabled | 1: enabled)
; c - color math on BG3 (0: disabled | 1: enabled)
; d - color math on BG4 (0: disabled | 1: enabled)
; o - color math on OBJ (0: disabled | 1: enabled)
CGADSUB = $002131

; COLOR MATH FIXED COLOR DATA
; $2132 w1 fvh
; bgrccccc
; r - red component of fixed color (0: unchanged | 1: change w/ write)
; g - green component of fixed color (0: unchanged | 1: change w/ write)
; b - blue component of fixed color (0: unchanged | 1: change w/ write)
; c - fixed color component value
COLDATA = $002132

; SCREEN INTERLACE AND SYNC SETTINGS
; $2133 w1 fvh
; se.. pvoi
; s - external sync (0: normal | 1: super impose)
; e - mode 7 EXTBG (0: disabled | 1: enabled)
; p - pseudo h512 (0: disabled | 1: enabled - shifts subscreen half dot left)
; v - enable overscan (0: 224 scanlines | 1: 239 scanlines)
; o - object interlace (0: disabled | 1: enabled)
; i - screen interlace (0: disabled | 1: enabled - interlace to source)
SETINI = $002133

; MULTIPLICATION RESULT
; $2134 r1 fvh
; $2135 r1 fvh
; $2136 r1 fvh
;   MPYL     MPYM     MPYH
; llllllll mmmmmmmm hhhhhhhh
; l - low byte of product
; m - middle byte of product
; h - high byte of product
; see #PPUMATH
MPYL = $002134
MPYM = $002135
MPYH = $002136
PPUPRODUCTL = $002134
PPUPRODUCTM = $002135
PPUPRODUCTH = $002136

; SOFTWARE LATCH FOR h/V COUNTER
; $2137 r1 fvha
; ........
; Contains no data; just a latch to update OPHCT and OPVCT
SLHV = $002137

; OAM READ DATA
; $2138 r1 fv
; xxxxxxxx
; x - OAM data read
OAMDATAREAD = $002138

; VRAM READ DATA
; $2139 r1 fv
; $213A r1 fv
; VMDATALR VMDATAHR
; llllllll hhhhhhhh
; l - low byte of VRAM data read
; h - high byte of VRAM data read
VMDATALREAD = $002139
VMDATAHREAD = $00213A

; CHRAM READ DATA
; $213B r2 fv
; gggrrrrr .bbbbbgg
; r - red component of color
; g - green component of color
; b - blue component of color
CGDATAREAD = $00213B

; HORIZONTAL COUNTER FROM LAST LATCH
; $213C r2 fvha
; hhhhhhhh .......h
; h - horizontal dot position
; 0 to 339
OPHCT = $00213C

; VERTICAL COUNTER FROM LAST LATCH
; $213D r2 fvha
; vvvvvvvv .......v
; v - vertical scanline position
; 0 to 261
OPVCT = $00213D

; PPU STATUS AND PPU1 VERSION NUMBER
; $213E r1 fvha
; trm. vvvv
; t - OBJ time overflow (0: fine | 1: too many pixels on scanline - 8*34=292)
; r - OBJ range overflow (0: fine | 1: too many objects on scanline - 32)
; m - mode (0: master | 1: slave)
; v - PPU1 5C77 version
STAT77 = $00213E

; PPU STATUS AND PPU2 VERSION NUMBER
; $213F r1 fvha
; il.p vvvv
; i - current interlace field (0: odd | 1: even)
; l - external latch (0: no data | 1: new data)
; p - region (0: NTSC 60hz | 1: PAL 50hz)
; v - PPU2 5C78 version
STAT78 = $00213F

; AUDIO PROCESSING UNIT COMMUNICATION PORTS
; $2140 rw1 fvha
; $2141 rw1 fvha
; $2142 rw1 fvha
; $2143 rw1 fvha
; aaaaaaaa
; a - APU data
APUIO = $002140
APUIO0 = $002140
APUIO1 = $002141
APUIO2 = $002142
APUIO3 = $002143

; APUIO is mirrored up to $217F

; WRAM DATA READ/WRITE
; $2180 rw1 fvha
; xxxxxxxx
; x - WRAM data
WMDATA = $002180

; WRAM ADDRESS ACCESS
; $2181 rw1 fvha
; $2182 rw1 fvha
; $2183 rw1 fvha
;  WMADDL   WMADDH   WMADDB
; llllllll hhhhhhhh .......b
; l - low byte of WRAM address
; h - high byte of WRAM address
; b - bank of WRAM address (0: bank7E | 1: bank7F)
WMADDR = $002181
WMADDL = $002181
WMADDH = $002182
WMADDB = $002183

;===================================================================================================
;===================================================================================================
; CPU REGISTERS
;===================================================================================================
;===================================================================================================

; JOYPAD STROBE AND COMMUNICATION PORT
; $4016 rw1 fvha
; write: .......s
; s - strobe joypads
;
; read:  ......ca
; a - port 1 data 1
; c - port 1 data 2
JOYPAD = $004016
JOYPADA = $004016

; $4017 r1 fvha
; ......db
; d - port 2 data 1
; b - port 2 data 2
JOYPADB = $004017

;---------------------------------------------------------------------------------------------------

; INTERRUPT AND AUTO JOYPAD READ ENABLE
; $4200 w1 fvha
; n.vh ...j
; n - NMI enable (0: disabled | 1: enabled)
; vh - IRQ trigger time
;      00 - No IRQ
;      0h - IRQ triggers when HTIME is hit
;      v0 - IRQ triggers when VTIME is hit
;      vh - IRQ triggers when both HTIME and VTIME are hit
; j - auto joypad read (0: disabled | 1: enabled)
NMITIMEN = $004200

; PROGRAMMABLE I/O PORT (WRITE)
; $4201 w1 fvha
; ab.. ....
; a - controller port 2 pin 6 (0: no ppu latching | 1: ppu can be latched)
; b - controller port 1 pin 6
WRIO = $004201
JOYPADIO = $004201

; MULTIPLIER AND MULTIPLICAND
; $4202 w1 fvha
; $4203 w1 fvha
;  WRMPYA   WRMPYB
; aaaaaaaa bbbbbbbb
; a - unsigned 8-bit multiplicand A
; b - unsigned 8-bit multiplicand B
; need to wait 8 cycles before reading
; cycles taken to read the initial opcode count
WRMPYA = $004202
WRMPYB = $004203
CPUMULTA = $004202
CPUMULTB = $004203

; DIVISOR AND DIVIDEND
; $4204 w1 fvha
; $4205 w1 fvha
; $4206 w1 fvha
;          WRDIVL   WRDIVH
; WRDIV:  llllllll hhhhhhhh
; l - low byte of unsigned 16-bit dividend
; h - high byte of unsigned 16-bit dividend
; WRDIVB: dddddddd
; d - unsigned 8-bit divisor
; need to wait 16 cycles before reading
; cycles taken to read initial opcode count
; fewer cycles needed if quotient is known to be small?
WRDIVL = $004204
WRDIVH = $004205
WRDIVB = $004206
CPUDIVIDEND = $004204
CPUDIVIDENDL = $004204
CPUDIVIDENDH = $004205
CPUDIVISOR = $004206

; H-COUNT TIMER SETTINGS
; $4207 w1 fvha
; $4208 w1 fvha
; hhhhhhhh .......h
; h - IRQ horizontal trigger
HTIME = $004207
HTIMEL = $004207
HTIMEH = $004208

; V-COUNT TIMER SETTINGS
; $4209 w1 fvha
; $420A w1 fvha
; vvvvvvvv .......v
; v - IRQ vertical trigger
VTIME = $004209
VTIMEL = $004209
VTIMEH = $00420A

; DIRECT MEMORY ACCESS CHANNEL DESIGNATION
; $420B w1 fvha
; hgfedcba
; a - DMA channel 0 (0: disabled | 1: enabled)
; b - DMA channel 1 (0: disabled | 1: enabled)
; c - DMA channel 2 (0: disabled | 1: enabled)
; d - DMA channel 3 (0: disabled | 1: enabled)
; e - DMA channel 4 (0: disabled | 1: enabled)
; f - DMA channel 5 (0: disabled | 1: enabled)
; g - DMA channel 6 (0: disabled | 1: enabled)
; h - DMA channel 7 (0: disabled | 1: enabled)
MDMAEN = $00420B
DMAENABLE = $00420B

; H-BLANK DIRECT MEMORY ACCESS CHANNEL DESIGNATION
; $420C w1 fvha
; hgfedcba
; a - HDMA channel 0 (0: disabled | 1: enabled)
; b - HDMA channel 1 (0: disabled | 1: enabled)
; c - HDMA channel 2 (0: disabled | 1: enabled)
; d - HDMA channel 3 (0: disabled | 1: enabled)
; e - HDMA channel 4 (0: disabled | 1: enabled)
; f - HDMA channel 5 (0: disabled | 1: enabled)
; g - HDMA channel 6 (0: disabled | 1: enabled)
; h - HDMA channel 7 (0: disabled | 1: enabled)
HDMAEN = $00420C
HDMAENABLE = $00420C

; ACCESS CYCLE DESIGNATION
; $420D w1 fvha
; .......f
; f - fast rom (0: disabled | 1: enabled)
; Works with SA1, but pauses the SA1.
MEMSEL = $00420D

; V-BLANK NMI FLAG AND SNES CPU VERSION NUMBER
; $4210 r1 fvha
; n... vvvv
; n - vblank NMI trigger (0: not in vblank | 1: in vblank)
;     reading $4210 will clear this flag
;     read this during NMI for safety
;     messing with NMI enable may cause unwanted triggers
; v - Ricoh5A22 version
RDNMI = $004210

; H/V TIMER IRQ FLAG
; $4211 r1 fvha
; i... ....
; i - IRQ trigger (0: no request | 1: IRQ requested)
;     reading $4211 will clear this flag
;     read this during IRQ or else
;     IRQ will trigger immediately when the current one ends
TIMEUP = $004211

; H/V BLANK FLAG AND AUTO JOYPAD READ STATUS
; $4212 r1 fvha
; vh.. ...j
; v - vertical blanking period (0: not vblank | 1: vblank)
; h - horizontal blanking period (0: not hblank | 1: hblank)
;     blanking flags are toggled even during fblank
;     and irrespective of interrupts
;
; j - auto joypad read flag (0: fine | 1: busy with ajpr)
HVBJOY = $004212

; PROGRAMMABLE I/O PORT (READ)
; $4213 r1 fvha
; ab......
; a - pin 6 of controller port 2
; b - pin 6 of controller port 1
RDIO = $004213

; QUOTIENT OF DIVISION
; $4214 r1 fvha
; $4215 r1 fvha
;  RDDIVL   RDDIVH
; llllllll hhhhhhhh
; l - low byte of quotient
; h - high byte of quotient
RDDIV = $004214
RDDIVL = $004214
RDDIVH = $004215
CPUQUOTIENT = $004214
CPUQUOTIENTL = $004214
CPUQUOTIENTH = $004215

; PRODUCT OF MULTIPLICATION AND REMAINDER OF DIVISION
; $4216 r1 fvha
; $4217 r1 fvha
;  RDMPYL   RDMPYH
; llllllll hhhhhhhh
; l - low byte of result
; h - high byte of result
;
; for multiplication, this contains the product
; for division, this contains the remainder
RDMPY = $004216
RDMPYL = $004216
RDMPYH = $004217
CPUPRODUCT = $004216
CPUPRODUCTL = $004216
CPUPRODUCTH = $004217
CPUREMAINDER = $004216
CPUREMAINDERL = $004216
CPUREMAINDERH = $004217

; CONTROLLER DATA
; $4218 r1 fvha
; $4219 r1 fvha
; $421A r1 fvha
; $421B r1 fvha
; $421C r1 fvha
; $421D r1 fvha
; $421E r1 fvha
; $421F r1 fvha
;
;              JOY1L    JOY1H
; JOY1DATA1: AXLRvvvv BYsSudlr
;
;              JOY2L    JOY2H
; JOY2DATA1: AXLRvvvv BYsSudlr
;
;              JOY3L    JOY3H
; JOY1DATA2: AXLRvvvv BYsSudlr
;
;              JOY4L    JOY4H
; JOY2DATA2: AXLRvvvv BYsSudlr
;
; A - A face button (0: relaxed | 1: pressed)
; B - B face button (0: relaxed | 1: pressed)
; X - X face button (0: relaxed | 1: pressed)
; Y - Y face button (0: relaxed | 1: pressed)
; u - UP dpad button (0: relaxed | 1: pressed)
; d - DOWN dpad button (0: relaxed | 1: pressed)
; l - LEFT pad button (0: relaxed | 1: pressed)
; r - RIGHT dpad button (0: relaxed | 1: pressed)
; S - START button (0: relaxed | 1: pressed)
; s - SELECT button (0: relaxed | 1: pressed)
; L - LEFT SHOULDER button (0: relaxed | 1: pressed)
; R - RIGHT SHOULDER button (0: relaxed | 1: pressed)
;
; v - controller signature
;     only v bits are put in data
;     further data can be read for further controller information
;
;     vvvv zzzzzzzz
;     0000 00000000 - No controller connected
;     0000 11111111 - Standard joypad
;     0001 ........ - SNES mouse
;     0011 ........ - SFC modem
;     0100 ........ - NTT data controller (has cool numpad)
;     1101 ........ - Voice-Kun
;     1110 xxxxxxxx - Third-party device
;     1111 ........ - Super Scope
JOY1L = $004218
JOY1H = $004219
JOY2L = $00421A
JOY2H = $00421B
JOY3L = $00421C
JOY3H = $00421D
JOY4L = $00421E
JOY4H = $00421F
;--------------------------------
JOY1DATA1L = $004218
JOY1DATA1H = $004219
JOY2DATA1L = $00421A
JOY2DATA1H = $00421B
JOY1DATA2L = $00421C
JOY1DATA2H = $00421D
JOY2DATA2L = $00421E
JOY2DATA2H = $00421F

;===================================================================================================
;===================================================================================================
; DMA REGISTERS
;===================================================================================================
;===================================================================================================

; DMA TRANSFER PARAMETERS
; $4300 rw1 fvha
; $4310 rw1 fvha
; $4320 rw1 fvha
; $4330 rw1 fvha
; $4340 rw1 fvha
; $4350 rw1 fvha
; $4360 rw1 fvha
; $4370 rw1 fvha
;
; dh.i fmmm
; d - transfer direction (0: A bus to B bus | 1: B bus to A bus)
; h - HDMA addressing (0: direct table | 1: indirect table)
; i - address direction (0: increment address | 1: decrement address)
; f - fixed transfer
; m - transfer mode
;     000 - 1 register, write once              r+0
;     001 - 2 register, write once              r+0, r+1
;     010 - 1 register, write twice             r+0, r+0
;     011 - 2 registers, write twice            r+0, r+0, r+1, r+1
;     100 - 4 registers, write once             r+0, r+1, r+2, r+3
;     101 - 2 registers, write twice, alt       r+0, r+1, r+0, r+1
;     110 - 1 register, write twice             r+0, r+0
;     111 - 2 registers, write twice            r+0, r+0, r+1, r+1
;
;     for write twice modes, the address is still incremented
;     assuming a non-fixed transfer
;     for fixed transfers, the same address is always used
;     even for write twice modes
DMAPX = $004300
DMAP0 = $004300
DMAP1 = $004310
DMAP2 = $004320
DMAP3 = $004330
DMAP4 = $004340
DMAP5 = $004350
DMAP6 = $004360
DMAP7 = $004370
;--------------------------------
DMAXMODE = $004300
DMA0MODE = $004300
DMA1MODE = $004310
DMA2MODE = $004320
DMA3MODE = $004330
DMA4MODE = $004340
DMA5MODE = $004350
DMA6MODE = $004360
DMA7MODE = $004370
;--------------------------------
HDMAXMODE = $004300
HDMA0MODE = $004300
HDMA1MODE = $004310
HDMA2MODE = $004320
HDMA3MODE = $004330
HDMA4MODE = $004340
HDMA5MODE = $004350
HDMA6MODE = $004360
HDMA7MODE = $004370

; DMA B-BUS ADDRESS ACCESS
; $4301 rw1 fvha
; $4311 rw1 fvha
; $4321 rw1 fvha
; $4331 rw1 fvha
; $4341 rw1 fvha
; $4351 rw1 fvha
; $4361 rw1 fvha
; $4371 rw1 fvha
;
; aaaaaaaa
; a - low byte of PPU port $21aa for B bus address
BBADX = $004301
BBAD0 = $004301
BBAD1 = $004311
BBAD2 = $004321
BBAD3 = $004331
BBAD4 = $004341
BBAD5 = $004351
BBAD6 = $004361
BBAD7 = $004371
;--------------------------------
DMAXPORT = $004301
DMA0PORT = $004301
DMA1PORT = $004311
DMA2PORT = $004321
DMA3PORT = $004331
DMA4PORT = $004341
DMA5PORT = $004351
DMA6PORT = $004361
DMA7PORT = $004371

; DMA A-BUS TABLE ADDRESS
; $4302 rw1 fvha
; $4303 rw1 fvha
; $4304 rw1 fvha
; $4312 rw1 fvha
; $4313 rw1 fvha
; $4314 rw1 fvha
; $4322 rw1 fvha
; $4323 rw1 fvha
; $4324 rw1 fvha
; $4332 rw1 fvha
; $4333 rw1 fvha
; $4334 rw1 fvha
; $4342 rw1 fvha
; $4343 rw1 fvha
; $4344 rw1 fvha
; $4352 rw1 fvha
; $4353 rw1 fvha
; $4354 rw1 fvha
; $4362 rw1 fvha
; $4363 rw1 fvha
; $4364 rw1 fvha
; $4372 rw1 fvha
; $4373 rw1 fvha
; $4374 rw1 fvha
;
;   A1TxL    A1TxH    A1Bx
; llllllll hhhhhhhh bbbbbbbb
; l - low byte of A bus address
; h - high byte of A bus address
; b - bank of A bus address
;--------------------------------
A1TX = $004302
A1TXL = $004302
A1T0L = $004302
A1T1L = $004312
A1T2L = $004322
A1T3L = $004332
A1T4L = $004342
A1T5L = $004352
A1T6L = $004362
A1T7L = $004372
;--------------------------------
A1TXH = $004303
A1T0H = $004303
A1T1H = $004313
A1T2H = $004323
A1T3H = $004333
A1T4H = $004343
A1T5H = $004353
A1T6H = $004363
A1T7H = $004373
;--------------------------------
A1BX = $004304
A1B0 = $004304
A1B1 = $004314
A1B2 = $004324
A1B3 = $004334
A1B4 = $004344
A1B5 = $004354
A1B6 = $004364
A1B7 = $004374
;--------------------------------
DMAXADDR = $004302
DMA0ADDR = $004302
DMA1ADDR = $004312
DMA2ADDR = $004322
DMA3ADDR = $004332
DMA4ADDR = $004342
DMA5ADDR = $004352
DMA6ADDR = $004362
DMA7ADDR = $004372
;--------------------------------
DMAXADDRL = $004302
DMA0ADDRL = $004302
DMA1ADDRL = $004312
DMA2ADDRL = $004322
DMA3ADDRL = $004332
DMA4ADDRL = $004342
DMA5ADDRL = $004352
DMA6ADDRL = $004362
DMA7ADDRL = $004372
;--------------------------------
DMAXADDRH = $004303
DMA0ADDRH = $004303
DMA1ADDRH = $004313
DMA2ADDRH = $004323
DMA3ADDRH = $004333
DMA4ADDRH = $004343
DMA5ADDRH = $004353
DMA6ADDRH = $004363
DMA7ADDRH = $004373
;--------------------------------
DMAXADDRB = $004304
DMA0ADDRB = $004304
DMA1ADDRB = $004314
DMA2ADDRB = $004324
DMA3ADDRB = $004334
DMA4ADDRB = $004344
DMA5ADDRB = $004354
DMA6ADDRB = $004364
DMA7ADDRB = $004374
;--------------------------------
HDMAXADDR = $004302
HDMA0ADDR = $004302
HDMA1ADDR = $004312
HDMA2ADDR = $004322
HDMA3ADDR = $004332
HDMA4ADDR = $004342
HDMA5ADDR = $004352
HDMA6ADDR = $004362
HDMA7ADDR = $004372
;--------------------------------
HDMAXADDRL = $004302
HDMA0ADDRL = $004302
HDMA1ADDRL = $004312
HDMA2ADDRL = $004322
HDMA3ADDRL = $004332
HDMA4ADDRL = $004342
HDMA5ADDRL = $004352
HDMA6ADDRL = $004362
HDMA7ADDRL = $004372
;--------------------------------
HDMAXADDRH = $004303
HDMA0ADDRH = $004303
HDMA1ADDRH = $004313
HDMA2ADDRH = $004323
HDMA3ADDRH = $004333
HDMA4ADDRH = $004343
HDMA5ADDRH = $004353
HDMA6ADDRH = $004363
HDMA7ADDRH = $004373
;--------------------------------
HDMAXADDRB = $004304
HDMA0ADDRB = $004304
HDMA1ADDRB = $004314
HDMA2ADDRB = $004324
HDMA3ADDRB = $004334
HDMA4ADDRB = $004344
HDMA5ADDRB = $004354
HDMA6ADDRB = $004364
HDMA7ADDRB = $004374

; DMA SIZE, HDMA WORKING TABLE ADDRESS, AND HDMA INDIRECT TABLE BANK
; $4305 rw1 fvha
; $4306 rw1 fvha
; $4307 rw1 fvha
; $4315 rw1 fvha
; $4316 rw1 fvha
; $4317 rw1 fvha
; $4325 rw1 fvha
; $4326 rw1 fvha
; $4327 rw1 fvha
; $4335 rw1 fvha
; $4336 rw1 fvha
; $4337 rw1 fvha
; $4345 rw1 fvha
; $4346 rw1 fvha
; $4347 rw1 fvha
; $4355 rw1 fvha
; $4356 rw1 fvha
; $4357 rw1 fvha
; $4365 rw1 fvha
; $4366 rw1 fvha
; $4367 rw1 fvha
; $4375 rw1 fvha
; $4376 rw1 fvha
; $4377 rw1 fvha
;
;        DASxL    DASxH
; DMA: llllllll hhhhhhhh
; l - low byte of transfer size
; h - high byte of transfer size
;
;     $0000 will actually transfer $10000 bytes
;
;         DASxL    DASxH    DASBx
; HDMA: llllllll hhhhhhhh bbbbbbbb
; l - low byte of table
; h - high byte of table
; b - high byte of table
;
; Not used during direct HDMA
;--------------------------------
DASX = $004305
DAS0 = $004305
DAS1 = $004315
DAS2 = $004325
DAS3 = $004335
DAS4 = $004345
DAS5 = $004355
DAS6 = $004365
DAS7 = $004375
;--------------------------------
DASXL = $004305
DAS0L = $004305
DAS1L = $004315
DAS2L = $004325
DAS3L = $004335
DAS4L = $004345
DAS5L = $004355
DAS6L = $004365
DAS7L = $004375
;--------------------------------
DASXH = $004306
DAS0H = $004306
DAS1H = $004316
DAS2H = $004326
DAS3H = $004336
DAS4H = $004346
DAS5H = $004356
DAS6H = $004366
DAS7H = $004376
;--------------------------------
DASXB = $004307
DAS0B = $004307
DAS1B = $004317
DAS2B = $004327
DAS3B = $004337
DAS4B = $004347
DAS5B = $004357
DAS6B = $004367
DAS7B = $004377
;--------------------------------
DMAXSIZE = $004305
DMA0SIZE = $004305
DMA1SIZE = $004315
DMA2SIZE = $004325
DMA3SIZE = $004335
DMA4SIZE = $004345
DMA5SIZE = $004355
DMA6SIZE = $004365
DMA7SIZE = $004375
;--------------------------------
DMAXSIZEL = $004305
DMA0SIZEL = $004305
DMA1SIZEL = $004315
DMA2SIZEL = $004325
DMA3SIZEL = $004335
DMA4SIZEL = $004345
DMA5SIZEL = $004355
DMA6SIZEL = $004365
DMA7SIZEL = $004375
;--------------------------------
DMAXSIZEH = $004306
DMA0SIZEH = $004306
DMA1SIZEH = $004316
DMA2SIZEH = $004326
DMA3SIZEH = $004336
DMA4SIZEH = $004346
DMA5SIZEH = $004356
DMA6SIZEH = $004366
DMA7SIZEH = $004376
;--------------------------------
HDMAXINDIRECT = $004305
HDMA0INDIRECT = $004305
HDMA1INDIRECT = $004315
HDMA2INDIRECT = $004325
HDMA3INDIRECT = $004335
HDMA4INDIRECT = $004345
HDMA5INDIRECT = $004355
HDMA6INDIRECT = $004365
HDMA7INDIRECT = $004375
;--------------------------------
HDMAXINDIRECTL = $004305
HDMA0INDIRECTL = $004305
HDMA1INDIRECTL = $004315
HDMA2INDIRECTL = $004325
HDMA3INDIRECTL = $004335
HDMA4INDIRECTL = $004345
HDMA5INDIRECTL = $004355
HDMA6INDIRECTL = $004365
HDMA7INDIRECTL = $004375
;--------------------------------
HDMAXINDIRECTH = $004306
HDMA0INDIRECTH = $004306
HDMA1INDIRECTH = $004316
HDMA2INDIRECTH = $004326
HDMA3INDIRECTH = $004336
HDMA4INDIRECTH = $004346
HDMA5INDIRECTH = $004356
HDMA6INDIRECTH = $004366
HDMA7INDIRECTH = $004376
;--------------------------------
HDMAXINDIRECTB = $004307
HDMA0INDIRECTB = $004307
HDMA1INDIRECTB = $004317
HDMA2INDIRECTB = $004327
HDMA3INDIRECTB = $004337
HDMA4INDIRECTB = $004347
HDMA5INDIRECTB = $004357
HDMA6INDIRECTB = $004367
HDMA7INDIRECTB = $004377

; HDMA TABLE ADDRESS
; $4308 rw1 fvha
; $4309 rw1 fvha
; $4318 rw1 fvha
; $4319 rw1 fvha
; $4328 rw1 fvha
; $4329 rw1 fvha
; $4338 rw1 fvha
; $4339 rw1 fvha
; $4348 rw1 fvha
; $4349 rw1 fvha
; $4358 rw1 fvha
; $4359 rw1 fvha
; $4368 rw1 fvha
; $4369 rw1 fvha
; $4378 rw1 fvha
; $4379 rw1 fvha
;   A2AxL    A2AxH
; llllllll hhhhhhhh
; l - low byte of table address
; h - high byte of table address
;
; Updated automatically by HDMA
; so probably avoid writing here
;--------------------------------
A2AX = $004308
A2AXL = $004308
A2A0L = $004308
A2A1L = $004318
A2A2L = $004328
A2A3L = $004338
A2A4L = $004348
A2A5L = $004358
A2A6L = $004368
A2A7L = $004378
;--------------------------------
A2AXH = $004309
A2A0H = $004309
A2A1H = $004319
A2A2H = $004329
A2A3H = $004339
A2A4H = $004349
A2A5H = $004359
A2A6H = $004369
A2A7H = $004379
;--------------------------------
HDMAXTABLEADDR = $004308
HDMA0TABLEADDR = $004308
HDMA1TABLEADDR = $004318
HDMA2TABLEADDR = $004328
HDMA3TABLEADDR = $004338
HDMA4TABLEADDR = $004348
HDMA5TABLEADDR = $004358
HDMA6TABLEADDR = $004368
HDMA7TABLEADDR = $004378
;--------------------------------
HDMAXTABLEADDRL = $004308
HDMA0TABLEADDRL = $004308
HDMA1TABLEADDRL = $004318
HDMA2TABLEADDRL = $004328
HDMA3TABLEADDRL = $004338
HDMA4TABLEADDRL = $004348
HDMA5TABLEADDRL = $004358
HDMA6TABLEADDRL = $004368
HDMA7TABLEADDRL = $004378
;--------------------------------
HDMAXTABLEADDRH = $004309
HDMA0TABLEADDRH = $004309
HDMA1TABLEADDRH = $004319
HDMA2TABLEADDRH = $004329
HDMA3TABLEADDRH = $004339
HDMA4TABLEADDRH = $004349
HDMA5TABLEADDRH = $004359
HDMA6TABLEADDRH = $004369
HDMA7TABLEADDRH = $004379

; HDMA LINE TRANSFER WORKSPACE
; $430A rw1 fvha
; $431A rw1 fvha
; $432A rw1 fvha
; $433A rw1 fvha
; $434A rw1 fvha
; $435A rw1 fvha
; $436A rw1 fvha
; $437A rw1 fvha
; csss ssss
; c - continue flag (0: 1 line for s scanlines | 1: s lines, 1 per scanline)
; s - scanline count
;
; Updated automatically by HDMA
; so probably avoid writing here
;--------------------------------
NTLRX = $00430A
NTLR0 = $00430A
NTLR1 = $00431A
NTLR2 = $00432A
NTLR3 = $00433A
NTLR4 = $00434A
NTLR5 = $00435A
NTLR6 = $00436A
NTLR7 = $00437A
;--------------------------------
HDMAXLINECOUNT = $00430A
HDMA0LINECOUNT = $00430A
HDMA1LINECOUNT = $00431A
HDMA2LINECOUNT = $00432A
HDMA3LINECOUNT = $00433A
HDMA4LINECOUNT = $00434A
HDMA5LINECOUNT = $00435A
HDMA6LINECOUNT = $00436A
HDMA7LINECOUNT = $00437A

;===================================================================================================
macro assertREG(label, address)
  assert <label> = <address>, "<label> labeled at incorrect address."
endmacro

%assertREG(MSUSTATUS, $2000)
%assertREG(MSUSEEK, $2000)
%assertREG(MSUDATA, $2001)
%assertREG(MSUID, $2002)
%assertREG(MSUTRACK, $2004)
%assertREG(MSUVOL, $2006)
%assertREG(MSUCTL, $2007)

%assertREG(INIDISP, $2100)
%assertREG(OBSEL, $2101)
%assertREG(OAMADDL, $2102)
%assertREG(OAMADDH, $2103)
%assertREG(OAMDATA, $2104)
%assertREG(BGMODE, $2105)
%assertREG(MOSAIC, $2106)
%assertREG(BG1SC, $2107)
%assertREG(BG2SC, $2108)
%assertREG(BG3SC, $2109)
%assertREG(BG4SC, $210A)
%assertREG(BG12NBA, $210B)
%assertREG(BG34NBA, $210C)
%assertREG(BG1HOFS, $210D)
%assertREG(BG1VOFS, $210E)
%assertREG(BG2HOFS, $210F)
%assertREG(BG2VOFS, $2110)
%assertREG(BG3HOFS, $2111)
%assertREG(BG3VOFS, $2112)
%assertREG(BG4HOFS, $2113)
%assertREG(BG4VOFS, $2114)
%assertREG(VMAIN, $2115)
%assertREG(VMADDL, $2116)
%assertREG(VMADDH, $2117)
%assertREG(VMDATAL, $2118)
%assertREG(VMDATAH, $2119)
%assertREG(M7SEL, $211A)
%assertREG(M7A, $211B)
%assertREG(M7B, $211C)
%assertREG(M7C, $211D)
%assertREG(M7D, $211E)
%assertREG(M7X, $211F)
%assertREG(M7Y, $2120)
%assertREG(CGADD, $2121)
%assertREG(CGDATA, $2122)
%assertREG(W12SEL, $2123)
%assertREG(W34SEL, $2124)
%assertREG(WOBJSEL, $2125)
%assertREG(WH0, $2126)
%assertREG(WH1, $2127)
%assertREG(WH2, $2128)
%assertREG(WH3, $2129)
%assertREG(WBGLOG, $212A)
%assertREG(WOBJLOG, $212B)
%assertREG(TM, $212C)
%assertREG(TS, $212D)
%assertREG(TMW, $212E)
%assertREG(TSW, $212F)
%assertREG(CGWSEL, $2130)
%assertREG(CGADSUB, $2131)
%assertREG(COLDATA, $2132)
%assertREG(SETINI, $2133)
%assertREG(MPYL, $2134)
%assertREG(MPYM, $2135)
%assertREG(MPYH, $2136)
%assertREG(SLHV, $2137)
%assertREG(OAMDATAREAD, $2138)
%assertREG(VMDATALREAD, $2139)
%assertREG(VMDATAHREAD, $213A)
%assertREG(CGDATAREAD, $213B)
%assertREG(OPHCT, $213C)
%assertREG(OPVCT, $213D)
%assertREG(STAT77, $213E)
%assertREG(STAT78, $213F)
%assertREG(APUIO0, $2140)
%assertREG(APUIO1, $2141)
%assertREG(APUIO2, $2142)
%assertREG(APUIO3, $2143)

%assertREG(WMADDR, $2181)
%assertREG(WMADDL, $2181)
%assertREG(WMADDH, $2182)
%assertREG(WMADDB, $2183)

%assertREG(NMITIMEN, $4200)
%assertREG(WRIO, $4201)
%assertREG(WRMPYA, $4202)
%assertREG(WRMPYB, $4203)
%assertREG(WRDIVL, $4204)
%assertREG(WRDIVH, $4205)
%assertREG(WRDIVB, $4206)
%assertREG(HTIMEL, $4207)
%assertREG(HTIMEH, $4208)
%assertREG(VTIMEL, $4209)
%assertREG(VTIMEH, $420A)
%assertREG(MDMAEN, $420B)
%assertREG(HDMAEN, $420C)
%assertREG(MEMSEL, $420D)
%assertREG(RDNMI, $4210)
%assertREG(TIMEUP, $4211)
%assertREG(HVBJOY, $4212)
%assertREG(RDIO, $4213)
%assertREG(RDDIVL, $4214)
%assertREG(RDDIVH, $4215)
%assertREG(RDMPYL, $4216)
%assertREG(RDMPYH, $4217)
%assertREG(JOY1L, $4218)
%assertREG(JOY1H, $4219)
%assertREG(JOY2L, $421A)
%assertREG(JOY2H, $421B)
%assertREG(JOY3L, $421C)
%assertREG(JOY3H, $421D)
%assertREG(JOY4L, $421E)
%assertREG(JOY4H, $421F)

%assertREG(DMAP0, $4300)
%assertREG(BBAD0, $4301)
%assertREG(A1T0L, $4302)
%assertREG(A1T0H, $4303)
%assertREG(A1B0, $4304)
%assertREG(DAS0L, $4305)
%assertREG(DAS0H, $4306)
%assertREG(DAS0B, $4307)
%assertREG(A2A0L, $4308)
%assertREG(A2A0H, $4309)
%assertREG(NTLR0, $430A)
%assertREG(DMAP1, $4310)
%assertREG(BBAD1, $4311)
%assertREG(A1T1L, $4312)
%assertREG(A1T1H, $4313)
%assertREG(A1B1, $4314)
%assertREG(DAS1L, $4315)
%assertREG(DAS1H, $4316)
%assertREG(DAS1B, $4317)
%assertREG(A2A1L, $4318)
%assertREG(A2A1H, $4319)
%assertREG(NTLR1, $431A)
%assertREG(DMAP2, $4320)
%assertREG(BBAD2, $4321)
%assertREG(A1T2L, $4322)
%assertREG(A1T2H, $4323)
%assertREG(A1B2, $4324)
%assertREG(DAS2L, $4325)
%assertREG(DAS2H, $4326)
%assertREG(DAS2B, $4327)
%assertREG(A2A2L, $4328)
%assertREG(A2A2H, $4329)
%assertREG(NTLR2, $432A)
%assertREG(DMAP3, $4330)
%assertREG(BBAD3, $4331)
%assertREG(A1T3L, $4332)
%assertREG(A1T3H, $4333)
%assertREG(A1B3, $4334)
%assertREG(DAS3L, $4335)
%assertREG(DAS3H, $4336)
%assertREG(DAS3B, $4337)
%assertREG(A2A3L, $4338)
%assertREG(A2A3H, $4339)
%assertREG(NTLR3, $433A)
%assertREG(DMAP4, $4340)
%assertREG(BBAD4, $4341)
%assertREG(A1T4L, $4342)
%assertREG(A1T4H, $4343)
%assertREG(A1B4, $4344)
%assertREG(DAS4L, $4345)
%assertREG(DAS4H, $4346)
%assertREG(DAS4B, $4347)
%assertREG(A2A4L, $4348)
%assertREG(A2A4H, $4349)
%assertREG(NTLR4, $434A)
%assertREG(DMAP5, $4350)
%assertREG(BBAD5, $4351)
%assertREG(A1T5L, $4352)
%assertREG(A1T5H, $4353)
%assertREG(A1B5, $4354)
%assertREG(DAS5L, $4355)
%assertREG(DAS5H, $4356)
%assertREG(DAS5B, $4357)
%assertREG(A2A5L, $4358)
%assertREG(A2A5H, $4359)
%assertREG(NTLR5, $435A)
%assertREG(DMAP6, $4360)
%assertREG(BBAD6, $4361)
%assertREG(A1T6L, $4362)
%assertREG(A1T6H, $4363)
%assertREG(A1B6, $4364)
%assertREG(DAS6L, $4365)
%assertREG(DAS6H, $4366)
%assertREG(DAS6B, $4367)
%assertREG(A2A6L, $4368)
%assertREG(A2A6H, $4369)
%assertREG(NTLR6, $436A)
%assertREG(DMAP7, $4370)
%assertREG(BBAD7, $4371)
%assertREG(A1T7L, $4372)
%assertREG(A1T7H, $4373)
%assertREG(A1B7, $4374)
%assertREG(DAS7L, $4375)
%assertREG(DAS7H, $4376)
%assertREG(DAS7B, $4377)
%assertREG(A2A7L, $4378)
%assertREG(A2A7H, $4379)
%assertREG(NTLR7, $437A)
