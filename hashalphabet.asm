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
	PHB : PHA : PHX : PHY : PHP
		PHK : PLB
		SEP #$10 ; 8-bit index registers
		REP #$20 ; 16-bit accumulator

		LDX.b #$00 : -
			LDA.w FileSelect_PlayerSelectText_Top, X
			STA !BIGRAM, X
			INX #2
		CPX #128 : !BLT -

		LDY.b #00
		LDX.b #$00 : -
			PHX : TYX : LDA.l SeedHash, X : PLX
			AND.w #$001F ; mask to alphabet of 32

			ASL #3 : PHY : TAY
			LDA.w HashAlphabetTiles,Y : STA !BIGRAM+24, X
			LDA.w HashAlphabetTiles+2,Y : STA !BIGRAM+24+2, X
			LDA.w HashAlphabetTiles+4,Y : STA !BIGRAM+24+64, X
			LDA.w HashAlphabetTiles+6,Y : STA !BIGRAM+24+64+2, X
			PLY : INX #6 : INY
		CPX #25 : !BLT -

		SEP #$20 ;  8-bit accumulator

		JSR DMAAlphabetTilemap
	PLP : PLY : PLX : PLA : PLB
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
HashAlphabetTilesWithBlank:
;BLANK
dw #$0186|!FS_COLOR_BW, #$0186|!FS_COLOR_BW, #$0196|!FS_COLOR_BW, #$0196|!FS_COLOR_BW
HashAlphabetTiles:
;BOW
dw #$0201|!FS_COLOR_YELLOW, #$0202|!FS_COLOR_YELLOW, #$0211|!FS_COLOR_YELLOW, #$0212|!FS_COLOR_YELLOW
;BOOM
dw #$0205|!FS_COLOR_BLUE, #$0206|!FS_COLOR_BLUE, #$0200|!FS_COLOR_BW, #$0216|!FS_COLOR_BLUE
;HOOK
dw #$0200|!FS_COLOR_RED, #$0215|!FS_COLOR_RED, #$0230|!FS_COLOR_RED, #$0200|!FS_COLOR_BW
;BOMB
dw #$020C|!FS_COLOR_BLUE, #$020D|!FS_COLOR_BLUE, #$021C|!FS_COLOR_BLUE, #$021C|!FS_COLOR_BLUE|!FS_HFLIP
;SHROOM
dw #$0262|!FS_COLOR_RED, #$0263|!FS_COLOR_RED, #$0272|!FS_COLOR_RED, #$0273|!FS_COLOR_RED
;POWDER
dw #$020A|!FS_COLOR_BROWN, #$020B|!FS_COLOR_BROWN, #$021A|!FS_COLOR_BROWN, #$021B|!FS_COLOR_BROWN
;ROD
dw #$0220|!FS_COLOR_BLUE, #$0221|!FS_COLOR_BLUE, #$0230|!FS_COLOR_BLUE, #$0231|!FS_COLOR_BLUE
;PENDANT
dw #$0285|!FS_COLOR_GREEN, #$0286|!FS_COLOR_GREEN, #$0295|!FS_COLOR_GREEN, #$0296|!FS_COLOR_GREEN
;BOMBOS
dw #$0207|!FS_COLOR_YELLOW, #$0217|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP, #$0217|!FS_COLOR_YELLOW, #$0207|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP
;ETHER
dw #$0208|!FS_COLOR_YELLOW, #$0218|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP, #$0218|!FS_COLOR_YELLOW, #$0208|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP
;QUAKE
dw #$0209|!FS_COLOR_YELLOW, #$0219|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP, #$0219|!FS_COLOR_YELLOW, #$0209|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP
;LAMP
dw #$022C|!FS_COLOR_RED, #$022C|!FS_COLOR_RED|!FS_HFLIP, #$023C|!FS_COLOR_RED, #$023D|!FS_COLOR_RED
;HAMMER
dw #$0222|!FS_COLOR_BROWN, #$0223|!FS_COLOR_BROWN, #$0232|!FS_COLOR_BROWN, #$0233|!FS_COLOR_BROWN
;SHOVEL
dw #$0224|!FS_COLOR_BROWN, #$0225|!FS_COLOR_BROWN, #$0234|!FS_COLOR_BROWN, #$0235|!FS_COLOR_BROWN
;FLUTE
dw #$0226|!FS_COLOR_BLUE, #$0227|!FS_COLOR_BLUE, #$0236|!FS_COLOR_BLUE, #$0237|!FS_COLOR_BLUE
;NET
dw #$0228|!FS_COLOR_YELLOW, #$0229|!FS_COLOR_YELLOW, #$0238|!FS_COLOR_YELLOW, #$0239|!FS_COLOR_YELLOW
;BOOK
dw #$022A|!FS_COLOR_GREEN, #$022B|!FS_COLOR_GREEN, #$023A|!FS_COLOR_GREEN, #$023B|!FS_COLOR_GREEN
;BOTTLE
dw #$0240|!FS_COLOR_BW, #$0241|!FS_COLOR_BW, #$0250|!FS_COLOR_BW, #$0251|!FS_COLOR_BW
;POTION
dw #$0242|!FS_COLOR_GREEN, #$0242|!FS_COLOR_GREEN|!FS_HFLIP, #$0252|!FS_COLOR_GREEN, #$0253|!FS_COLOR_GREEN
;CANE
dw #$021D|!FS_COLOR_RED, #$021E|!FS_COLOR_RED, #$022D|!FS_COLOR_RED, #$022E|!FS_COLOR_RED
;CAPE
dw #$0248|!FS_COLOR_RED, #$0249|!FS_COLOR_RED, #$0258|!FS_COLOR_RED, #$0259|!FS_COLOR_RED
;MIRROR
dw #$024A|!FS_COLOR_BLUE, #$024B|!FS_COLOR_BLUE, #$025A|!FS_COLOR_BLUE, #$025B|!FS_COLOR_BLUE
;BOOTS
dw #$024C|!FS_COLOR_BOOTS, #$024D|!FS_COLOR_BOOTS, #$025C|!FS_COLOR_BOOTS, #$025D|!FS_COLOR_BOOTS
;GLOVES
dw #$024E|!FS_COLOR_BROWN, #$024F|!FS_COLOR_BROWN, #$025E|!FS_COLOR_BROWN, #$025F|!FS_COLOR_BROWN
;FLIPPERS
dw #$020E|!FS_COLOR_BLUE, #$020F|!FS_COLOR_BLUE, #$021F|!FS_COLOR_BLUE|!FS_HFLIP, #$021F|!FS_COLOR_BLUE
;PEARL
dw #$0264|!FS_COLOR_RED, #$0265|!FS_COLOR_RED, #$0274|!FS_COLOR_RED, #$0275|!FS_COLOR_RED
;SHIELD
dw #$026D|!FS_COLOR_YELLOW, #$026E|!FS_COLOR_YELLOW, #$027D|!FS_COLOR_YELLOW, #$027E|!FS_COLOR_YELLOW
;TUNIC
dw #$026F|!FS_COLOR_GREEN, #$026F|!FS_COLOR_GREEN|!FS_HFLIP, #$027F|!FS_COLOR_GREEN, #$027F|!FS_COLOR_GREEN|!FS_HFLIP
;HEART
dw #$0281|!FS_COLOR_RED, #$0281|!FS_COLOR_RED|!FS_HFLIP, #$0291|!FS_COLOR_RED, #$0291|!FS_COLOR_RED|!FS_HFLIP
;MAP
dw #$0282|!FS_COLOR_YELLOW, #$0283|!FS_COLOR_YELLOW, #$0292|!FS_COLOR_YELLOW, #$0293|!FS_COLOR_YELLOW
;COMPASS
dw #$0284|!FS_COLOR_RED, #$0284|!FS_COLOR_RED|!FS_HFLIP, #$0294|!FS_COLOR_RED, #$0294|!FS_COLOR_RED|!FS_HFLIP
;KEY
dw #$022F|!FS_COLOR_YELLOW|!FS_HFLIP, #$022F|!FS_COLOR_YELLOW, #$023E|!FS_COLOR_YELLOW, #$023F|!FS_COLOR_YELLOW
;--------------------------------------------------------------------------------
FileSelect_PlayerSelectText_Top:
;db $60, $62, $00, $37
dw !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
dw !FSTILE_BRACKET_OPEN_TOP
dw !FSTILE_SPACE, !FSTILE_C_TOP
dw !FSTILE_O_TOP
dw !FSTILE_D_TOP
dw !FSTILE_E_TOP
dw !FSTILE_SPACE, !FSTILE_SPACE
dw $05A0, $05A1
dw !FSTILE_SPACE, $05A4, $05A5
dw !FSTILE_SPACE, $05A8, $05A9
dw !FSTILE_SPACE, $05AC, $05AD
dw !FSTILE_SPACE, $05B0, $05B1
dw !FSTILE_SPACE
dw !FSTILE_BRACKET_CLOSE_TOP
dw !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
;--------------------------------------------------------------------------------
FileSelect_PlayerSelectText_Bottom:
;db $60, $82, $00, $37
dw !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
dw !FSTILE_BRACKET_OPEN_BOTTOM
dw !FSTILE_SPACE, !FSTILE_C_BOTTOM
dw !FSTILE_O_BOTTOM
dw !FSTILE_D_BOTTOM
dw !FSTILE_E_BOTTOM
dw !FSTILE_SPACE, !FSTILE_SPACE
dw $05A2, $05A3
dw !FSTILE_SPACE, $05A6, $05A7
dw !FSTILE_SPACE, $05AA, $05AB
dw !FSTILE_SPACE, $05AE, $05AF
dw !FSTILE_SPACE, $05B2, $05B3
dw !FSTILE_SPACE
dw !FSTILE_BRACKET_CLOSE_BOTTOM
dw !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
;--------------------------------------------------------------------------------
