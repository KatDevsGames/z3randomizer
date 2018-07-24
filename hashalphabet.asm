;--------------------------------------------------------------------------------
; GetAlphabetPalette:
; In: X = Alphabet Index
; Out: A = Palette
;--------------------------------------------------------------------------------
GetAlphabetPalette:
	LDA.l .table, X
RTL
;--------------------------------------------------------------------------------
.table
db $00, $0C, $04, $0C, $04, $00, $0C, $18
db $08, $08, $08, $04, $00, $00, $0C, $08
db $18, $0C, $18, $04, $04, $0C, $14, $00
db $0C, $04, $08, $18, $04, $08, $04, $08
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; GetAlphabetTileAddr:
; Notes:
; Assumes 16-bit accumulator
;--------------------------------------------------------------------------------
GetAlphabetTileAddr:
	ASL #6
	!ADD.w #$B800 ; $31:B800
RTL
;--------------------------------------------------------------------------------

!ALPHA_TILE_WIDTH = "#$40"
!ALPHA_VRAM_DEST_BASE = "#$5A00"

;--------------------------------------------------------------------------------
; LoadAlphabetTiles
; In:
; $00 - Tile 0
; $01 - Tile 1
; $02 - Tile 2
; $03 - Tile 3
; $04 - Tile 4
;--------------------------------------------------------------------------------
LoadAlphabetTiles:
	PHA : PHX
		LDA $4300 : PHA ; preserve DMA parameters
		LDA $4301 : PHA ; preserve DMA parameters
		LDA $4302 : PHA ; preserve DMA parameters
		LDA $4303 : PHA ; preserve DMA parameters
		LDA $4304 : PHA ; preserve DMA parameters
		LDA $4305 : PHA ; preserve DMA parameters
		LDA $4306 : PHA ; preserve DMA parameters
		;--------------------------------------------------------------------------------
		LDA.b #$80 : STA $2115 ; write read increment on $2119
		LDA.b #$01 : STA $4300 ; set DMA transfer direction A -> B, bus A auto increment, double-byte mode
		LDA.b #$18 : STA $4301 ; set bus B destination to VRAM register
		
		LDA.b !ALPHA_VRAM_DEST_BASE>>1 : STA $2116 ; write VRAM destination address
		LDA.b !ALPHA_VRAM_DEST_BASE>>9 : STA $2117 ; write VRAM destination address

		LDA.b #GFX_Hash_Alphabet>>16 : STA $4304 ; set bus A source bank
		
		LDA $2100 : PHA : LDA.b #$80 : STA $2100 ; save screen state & turn screen off
		LDX.b #$00 : -

			LDA.l SeedHash, X
			REP #$20 ; set 16-bit accumulator
			AND.w #$001F ; mask to alphabet of 32
			JSL.l GetAlphabetTileAddr : STA $4302 ; set bus A source address to SRAM
			
			SEP #$20 ; set 8-bit accumulator
			
			LDA.b !ALPHA_TILE_WIDTH : STA $4305 : STZ $4306 ; set transfer size to 0x40
			LDA #$01 : STA $420B ; begin DMA transfer
		
			INX
		CPX.b #$05 : !BLT -
		PLA : STA $2100 ; put screen back however it was before
		;--------------------------------------------------------------------------------
		PLA : STA $4306 ; restore DMA parameters
		PLA : STA $4305 ; restore DMA parameters
		PLA : STA $4304 ; restore DMA parameters
		PLA : STA $4303 ; restore DMA parameters
		PLA : STA $4302 ; restore DMA parameters
		PLA : STA $4301 ; restore DMA parameters
		PLA : STA $4300 ; restore DMA parameters
	PLX : PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;Hash Alphabet
!ALPHA_BOW = "#$0000"
!ALPHA_BOOM = "#$0001"
!ALPHA_HOOK = "#$0002"
!ALPHA_BOMB = "#$0003"
!ALPHA_SHROOM = "#$0004"
!ALPHA_POWDER = "#$0005"
!ALPHA_ROD = "#$0006"
!ALPHA_PENDANT = "#$0007"
!ALPHA_BOMBOS = "#$0008"
!ALPHA_ETHER = "#$0009"
!ALPHA_QUAKE = "#$000A"
!ALPHA_LAMP = "#$000B"
!ALPHA_HAMMER = "#$000C"
!ALPHA_SHOVEL = "#$000D"
!ALPHA_FLUTE = "#$000E"
!ALPHA_NET = "#$000F"
!ALPHA_BOOK = "#$0010"
!ALPHA_BOTTLE = "#$0011"
!ALPHA_POTION = "#$0012"
!ALPHA_CANE = "#$0013"
!ALPHA_CAPE = "#$0014"
!ALPHA_MIRROR = "#$0015"
!ALPHA_BOOTS = "#$0016"
!ALPHA_GLOVES = "#$0017"
!ALPHA_FLIPPERS = "#$0018"
!ALPHA_PEARL = "#$0019"
!ALPHA_SHIELD = "#$001A"
!ALPHA_TUNIC = "#$001B"
!ALPHA_HEART = "#$001C"
!ALPHA_MAP = "#$001D"
!ALPHA_COMPASS = "#$001E"
!ALPHA_KEY = "#$001F"
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
!BIGRAM = "$7EC900";
;--------------------------------------------------------------------------------
LoadAlphabetTilemap:
	PHA : PHX : PHY : PHP
		SEP #$10 ; 8-bit index registers
		REP #$20 ; 16-bit accumulator
		
		LDX.b #$00 : -
			LDA FileSelect_PlayerSelectText_Top, X
			STA !BIGRAM, X
			INX #2
		CPX #128 : !BLT -
		
		
		SEP #$20 ; 8-bit accumulator
		
		LDY.b #00
		LDX.b #$00 : -
			PHX : TYX : LDA.l SeedHash, X : PLX
			AND.b #$1F ; mask to alphabet of 32
			PHX : TAX : JSL.l GetAlphabetPalette : PLX
			ORA.b #$01
			
			STA !BIGRAM+28+1, X
			STA !BIGRAM+28+1+2, X
			STA !BIGRAM+28+64+1, X
			STA !BIGRAM+28+64+1+2, X
			INX #6 : INY
		CPX #25 : !BLT -
		
		
		JSR DMAAlphabetTilemap
	PLP : PLY : PLX : PLA
RTL
;--------------------------------------------------------------------------------
; DMAAlphabetTilemap:
;--------------------------------------------------------------------------------
DMAAlphabetTilemap:
	PHA : PHX
		LDA $4300 : PHA ; preserve DMA parameters
		LDA $4301 : PHA ; preserve DMA parameters
		LDA $4302 : PHA ; preserve DMA parameters
		LDA $4303 : PHA ; preserve DMA parameters
		LDA $4304 : PHA ; preserve DMA parameters
		LDA $4305 : PHA ; preserve DMA parameters
		LDA $4306 : PHA ; preserve DMA parameters
		;--------------------------------------------------------------------------------
		LDA.b #$01 : STA $4300 ; set DMA transfer direction A -> B, bus A auto increment, double-byte mode
		LDA.b #$80 : STA $2115 ; write read increment on $2119
		LDA.b #$18 : STA $4301 ; set bus B destination to VRAM register
	
		LDA.b #$60 : STA $2116 ; write VRAM destination address
		STA $2117 ; write VRAM destination address

		LDA.b #!BIGRAM : STA $4302 ; set bus A source address to WRAM
		LDA.b #!BIGRAM>>8 : STA $4303 ; set bus A source address to WRAM
		LDA.b #!BIGRAM>>16 : STA $4304 ; set bus A source bank
	
		LDA.b #$80 : STA $4305 : STZ $4306 ; set transfer size to 0x40
	
		LDA $2100 : PHA : LDA.b #$80 : STA $2100 ; save screen state & turn screen off
			LDA #$01 : STA $420B ; begin DMA transfer
		PLA : STA $2100 ; put screen back however it was before
		;--------------------------------------------------------------------------------
		LDA.b #$00 : STA $4300 ; set DMA transfer direction A -> B, bus A auto increment, single-byte mode
		LDA.b #$22 : STA $4301 ; set bus B destination to CGRAM register
		
		STZ $2121 ; write CGRAM destination address
		
		LDA.b #GFX_HUD_Palette : STA $4302 ; set bus A source address to WRAM
		LDA.b #GFX_HUD_Palette>>8 : STA $4303 ; set bus A source address to WRAM
		LDA.b #GFX_HUD_Palette>>16 : STA $4304 ; set bus A source bank
		
		LDA.b #$80 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		
		LDA $2100 : PHA : LDA.b #$80 : STA $2100 ; save screen state & turn screen off
			LDA #$01 : STA $420B ; begin DMA transfer
		PLA : STA $2100 ; put screen back however it was before
		;--------------------------------------------------------------------------------
		PLA : STA $4306 ; restore DMA parameters
		PLA : STA $4305 ; restore DMA parameters
		PLA : STA $4304 ; restore DMA parameters
		PLA : STA $4303 ; restore DMA parameters
		PLA : STA $4302 ; restore DMA parameters
		PLA : STA $4301 ; restore DMA parameters
		PLA : STA $4300 ; restore DMA parameters
	PLX : PLA
RTS
;--------------------------------------------------------------------------------
FileSelect_PlayerSelectText_Top:
;db $60, $62, $00, $37
dw !FSTILE_SPACE, !FSTILE_SPACE
dw !FSTILE_BRACKET_OPEN_TOP
dw !FSTILE_SPACE, !FSTILE_C_TOP
dw !FSTILE_SPACE, !FSTILE_O_TOP
dw !FSTILE_SPACE, !FSTILE_D_TOP
dw !FSTILE_SPACE, !FSTILE_E_TOP
dw !FSTILE_SPACE, !FSTILE_SPACE
dw !FSTILE_SPACE, $05A0, $05A1
dw !FSTILE_SPACE, $05A4, $05A5
dw !FSTILE_SPACE, $05A8, $05A9
dw !FSTILE_SPACE, $05AC, $05AD
dw !FSTILE_SPACE, $05B0, $05B1
dw !FSTILE_SPACE
dw !FSTILE_BRACKET_CLOSE_TOP
dw !FSTILE_SPACE, !FSTILE_SPACE
;--------------------------------------------------------------------------------
FileSelect_PlayerSelectText_Bottom:
;db $60, $82, $00, $37
dw !FSTILE_SPACE, !FSTILE_SPACE
dw !FSTILE_BRACKET_OPEN_BOTTOM
dw !FSTILE_SPACE, !FSTILE_C_BOTTOM
dw !FSTILE_SPACE, !FSTILE_O_BOTTOM
dw !FSTILE_SPACE, !FSTILE_D_BOTTOM
dw !FSTILE_SPACE, !FSTILE_E_BOTTOM
dw !FSTILE_SPACE, !FSTILE_SPACE
dw !FSTILE_SPACE, $05A2, $05A3
dw !FSTILE_SPACE, $05A6, $05A7
dw !FSTILE_SPACE, $05AA, $05AB
dw !FSTILE_SPACE, $05AE, $05AF
dw !FSTILE_SPACE, $05B2, $05B3
dw !FSTILE_SPACE
dw !FSTILE_BRACKET_CLOSE_BOTTOM
dw !FSTILE_SPACE, !FSTILE_SPACE
;--------------------------------------------------------------------------------
