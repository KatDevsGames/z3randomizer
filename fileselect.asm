!ExtendedPlayerName = "$700500"

;FS prefix means file_select, since these defines and macros are specific to this screen
!FS_INVENTORY_SWAP = "$70038C"
!FS_INVENTORY_SWAP_2 = "$70038E"


!FS_COLOR_BROWN = "$0000" ;(only used for: Shovel, hammer, powder)
!FS_COLOR_RED = "$0400"
!FS_COLOR_YELLOW = "$0800"
!FS_COLOR_BLUE = "$0C00"
!FS_COLOR_GRAY = "$1000" ;(Used to gray out items)
!FS_COLOR_BOOTS = "$1400"
!FS_COLOR_GREEN = "$1800"
!FS_COLOR_BW = "$1C00"

!FS_HFLIP = "$4000"
!FS_VFLIP = "$8000"

macro fs_draw8x8(screenrow,screencol)
	;Note due to XKAS's screwy math this formula is misleading.
	;in normal math we have $1004+2*col+$40*row
	STA.w <screenrow>*$20+<screencol>*2+$1004
endmacro
macro fs_draw16x8(screenrow,screencol)
	%fs_draw8x8(<screenrow>,<screencol>)
	INC A
	%fs_draw8x8(<screenrow>,<screencol>+1)
endmacro
macro fs_draw8x16(screenrow,screencol)
	%fs_draw8x8(<screenrow>,<screencol>)
	!ADD #$0010
	%fs_draw8x8(<screenrow>+1,<screencol>)
endmacro
macro fs_draw16x16(screenrow,screencol)
	%fs_draw16x8(<screenrow>,<screencol>)
	!ADD #$000F
	%fs_draw16x8(<screenrow>+1,<screencol>)
endmacro

macro fs_LDY_screenpos(screenrow,screencol)
	LDY.w #<screenrow>*$20+<screencol>*2+$1004
endmacro

macro fs_drawItem(screenrow,screencol,tileAddress)
	LDX.w #<tileAddress>
	%fs_LDY_screenpos(<screenrow>,<screencol>)
	JSR DrawItem
endmacro
macro fs_drawItemGray(screenrow,screencol,tileAddress)
	LDX.w #<tileAddress>
	%fs_LDY_screenpos(<screenrow>,<screencol>)
	JSR DrawItemGray
endmacro

macro fs_drawItemBasic(address,screenrow,screencol,tileAddress)
	LDX.w #<tileAddress>
	%fs_LDY_screenpos(<screenrow>,<screencol>)
	LDA.l <address>
	JSR DrawItemBasic
endmacro

macro fs_drawBottle(address,screenrow,screencol)
	%fs_LDY_screenpos(<screenrow>,<screencol>)
	LDA.l <address>
	JSR DrawBottle
endmacro

DrawItem:
	LDA.w $0000,X : STA.w $0000, Y
	LDA.w $0002,X : STA.w $0002, Y
	LDA.w $0004,X : STA.w $0040, Y
	LDA.w $0006,X : STA.w $0042, Y
RTS
DrawItemGray:
	LDA.w $0000,X : AND.w #$E3FF : ORA.w #!FS_COLOR_GRAY : STA.w $0000, Y
	LDA.w $0002,X : AND.w #$E3FF : ORA.w #!FS_COLOR_GRAY : STA.w $0002, Y
	LDA.w $0004,X : AND.w #$E3FF : ORA.w #!FS_COLOR_GRAY : STA.w $0040, Y
	LDA.w $0006,X : AND.w #$E3FF : ORA.w #!FS_COLOR_GRAY : STA.w $0042, Y
RTS
DrawItemBasic:
	AND.w #$00FF : BEQ +
		JMP DrawItem
	+
JMP DrawItemGray

DrawBottle:
	AND.w #$00FF : BNE +
		LDX #FileSelectItems_emptyBottle
		JMP DrawItemGray
	+ : DEC #2 : BNE +
		LDX #FileSelectItems_emptyBottle
		JMP DrawItem
	+ : DEC : BNE +
		LDX #FileSelectItems_redPotion
		JMP DrawItem
	+ : DEC : BNE +
		LDX #FileSelectItems_greenPotion
		JMP DrawItem
	+ : DEC : BNE +
		LDX #FileSelectItems_bluePotion
		JMP DrawItem
	+ : DEC : BNE +
		LDX #FileSelectItems_fairyBottle
		JMP DrawItem
	+ : DEC : BNE +
		LDX #FileSelectItems_beeBottle
		JMP DrawItem
	+
	LDX #FileSelectItems_goodBeeBottle
JMP DrawItem


DrawPlayerFile:
	PHX : PHY : PHB

	SEP #$20 ; set 8-bit accumulator
	LDA.b #FileSelectItems>>16 : PHA : PLB
	REP #$20 ; restore 16 bit accumulator

	LDA !ExtendedPlayerName+$00 : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(6,3)
	LDA !ExtendedPlayerName+$02 : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(6,5)
	LDA !ExtendedPlayerName+$04 : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(6,7)
	LDA !ExtendedPlayerName+$06 : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(6,9)

	LDA !ExtendedPlayerName+$08 : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(9,3)
	LDA !ExtendedPlayerName+$0A : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(9,5)
	LDA !ExtendedPlayerName+$0C : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(9,7)
	LDA !ExtendedPlayerName+$0E : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(9,9)

	JSR FileSelectDrawHudBar

	; Bow
	LDA.l !FS_INVENTORY_SWAP_2 : AND.w #$0040 : BEQ +
		LDA $700340 : AND.w #$00FF : BEQ +
			%fs_drawItem(2,12,FileSelectItems_silver_bow)
			BRA .bow_end
		+
		%fs_drawItem(2,12,FileSelectItems_silver_arrow)
		BRA .bow_end
	+
	LDA.l $700340 : AND.w #$00FF : BEQ +
		%fs_drawItem(2,12,FileSelectItems_bow)
		BRA .bow_end
	+
	%fs_drawItemGray(2,12,FileSelectItems_bow)
	.bow_end
	
	; Boomerang
	LDA.l !FS_INVENTORY_SWAP : AND.w #$0040 : BEQ +
		%fs_drawItem(2,14,FileSelectItems_red_boomerang)
		BRA .boomerang_end
	+
	LDA.l !FS_INVENTORY_SWAP : AND.w #$0080 : BEQ +
		%fs_drawItem(2,14,FileSelectItems_blue_boomerang)
		BRA .boomerang_end
	+
	%fs_drawItemGray(2,14,FileSelectItems_blue_boomerang)
	.boomerang_end

	; Hookshot
	%fs_drawItemBasic($700342,2,16,FileSelectItems_hookshot)
	
	; Bombs
	%fs_drawItemBasic($700343,2,18,FileSelectItems_bombs)
	
	; Powder
	LDA.l !FS_INVENTORY_SWAP : AND.w #$0010 : BEQ +
		%fs_drawItem(2,20,FileSelectItems_powder)
		BRA ++
	+
		%fs_drawItemGray(2,20,FileSelectItems_powder)
	++
	
	; Mushroom
	LDA.l !FS_INVENTORY_SWAP : AND.w #$0020 : BEQ +
		%fs_drawItem(2,22,FileSelectItems_mushroom)
		BRA ++
	+
		%fs_drawItemGray(2,22,FileSelectItems_mushroom)
	++
	
	; Flute
	LDA.l !FS_INVENTORY_SWAP : AND.w #$0003 : BEQ +
		%fs_drawItem(6,16,FileSelectItems_flute)
		BRA ++
	+
		%fs_drawItemGray(6,16,FileSelectItems_flute)
	++
	
	; Shovel
	LDA.l !FS_INVENTORY_SWAP : AND.w #$0004 : BEQ +
		%fs_drawItem(8,12,FileSelectItems_shovel)
		BRA ++
	+
		%fs_drawItemGray(8,12,FileSelectItems_shovel)
	++

	; Fire Rod
	%fs_drawItemBasic($700345,4,12,FileSelectItems_fire_rod)

	; Ice Rod
	%fs_drawItemBasic($700346,4,14,FileSelectItems_ice_rod)

	; Bombos Medallion
	%fs_drawItemBasic($700347,4,16,FileSelectItems_bombos)

	; Ether Medallion
	%fs_drawItemBasic($700348,4,18,FileSelectItems_ether)

	; Quake Medallion
	%fs_drawItemBasic($700349,4,20,FileSelectItems_quake)

	; Lamp
	%fs_drawItemBasic($70034A,6,12,FileSelectItems_lamp)

	; Hammer
	%fs_drawItemBasic($70034B,6,14,FileSelectItems_hammer)

	; Bug Net
	%fs_drawItemBasic($70034D,6,18,FileSelectItems_bugnet)

	; Book of Mudora
	%fs_drawItemBasic($70034E,6,20,FileSelectItems_book)

	; Red Cane
	%fs_drawItemBasic($700350,8,14,FileSelectItems_redcane)

	; Blue Cane
	%fs_drawItemBasic($700351,8,16,FileSelectItems_bluecane)

	; Cape
	%fs_drawItemBasic($700352,8,18,FileSelectItems_cape)

	; Mirror
	%fs_drawItemBasic($700353,8,20,FileSelectItems_mirror)
	
	; Bottles
	%fs_drawBottle($70035C,2,24)
	%fs_drawBottle($70035D,4,24)
	%fs_drawBottle($70035E,6,24)
	%fs_drawBottle($70035F,8,24)

	; Boots
	%fs_drawItemBasic($700355,2,28,FileSelectItems_boots)

	; Gloves
	LDA.l $700354 : AND.w #$00FF : BNE +
		%fs_drawItemGray(4,28,FileSelectItems_gloves)
		BRA ++
	+ : DEC : BNE +
		%fs_drawItem(4,28,FileSelectItems_gloves)
		BRA ++
	+
		%fs_drawItem(4,28,FileSelectItems_mitts)
	++
	
	; Flippers
	%fs_drawItemBasic($700356,6,28,FileSelectItems_flippers)

	; Moon Pearl
	%fs_drawItemBasic($700357,8,28,FileSelectItems_pearl)

	PLB : PLY : PLX
	LDA.w #$0004 : STA $02 ; thing we wrote over
RTL
;--------------------------------------------------------------------------------

FileSelectItems:
	.empty_bow
	dw #$0201|!FS_COLOR_YELLOW, #$0204|!FS_COLOR_YELLOW, #$0203|!FS_COLOR_RED, #$0212|!FS_COLOR_YELLOW
	.bow
	dw #$0201|!FS_COLOR_YELLOW, #$0204|!FS_COLOR_YELLOW, #$0203|!FS_COLOR_RED, #$0212|!FS_COLOR_YELLOW
	.silver_bow
	dw #$0201|!FS_COLOR_YELLOW, #$0204|!FS_COLOR_YELLOW, #$0203|!FS_COLOR_RED, #$0212|!FS_COLOR_YELLOW
	.silver_arrow
	dw #$0200|!FS_COLOR_YELLOW, #$0214|!FS_COLOR_YELLOW, #$0213|!FS_COLOR_RED, #$0200|!FS_COLOR_YELLOW
	.blue_boomerang
	dw #$0205|!FS_COLOR_BLUE, #$0206|!FS_COLOR_BLUE, #$0200|!FS_COLOR_BW, #$0216|!FS_COLOR_BLUE
	.red_boomerang
	dw #$0205|!FS_COLOR_RED, #$0206|!FS_COLOR_RED, #$0200|!FS_COLOR_BW, #$0216|!FS_COLOR_RED
	.hookshot
	dw #$0200|!FS_COLOR_RED, #$0215|!FS_COLOR_RED, #$0230|!FS_COLOR_RED, #$0200|!FS_COLOR_BW
	.bombs
	dw #$020C|!FS_COLOR_BLUE, #$020D|!FS_COLOR_BLUE, #$021C|!FS_COLOR_BLUE, #$021C|!FS_COLOR_BLUE|!FS_HFLIP
	.fire_rod
	dw #$0220|!FS_COLOR_RED, #$0210|!FS_COLOR_RED, #$0230|!FS_COLOR_RED, #$0231|!FS_COLOR_RED
	.ice_rod
	dw #$0220|!FS_COLOR_BLUE, #$0221|!FS_COLOR_BLUE, #$0230|!FS_COLOR_BLUE, #$0231|!FS_COLOR_BLUE
	.bombos
	dw #$0207|!FS_COLOR_YELLOW, #$0217|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP, #$0217|!FS_COLOR_YELLOW, #$0207|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP
	.ether
	dw #$0208|!FS_COLOR_YELLOW, #$0218|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP, #$0218|!FS_COLOR_YELLOW, #$0208|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP
	.quake
	dw #$0209|!FS_COLOR_YELLOW, #$0219|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP, #$0219|!FS_COLOR_YELLOW, #$0209|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP
	.lamp
	dw #$022C|!FS_COLOR_RED, #$022C|!FS_COLOR_RED|!FS_HFLIP|, #$023C|!FS_COLOR_RED, #$023D|!FS_COLOR_RED
	.hammer
	dw #$0222|!FS_COLOR_BROWN, #$0223|!FS_COLOR_BROWN, #$0232|!FS_COLOR_BROWN, #$0233|!FS_COLOR_BROWN
	.bugnet
	dw #$0228|!FS_COLOR_YELLOW, #$0229|!FS_COLOR_YELLOW, #$0238|!FS_COLOR_YELLOW, #$0239|!FS_COLOR_YELLOW
	.shovel
	dw #$0224|!FS_COLOR_YELLOW, #$0225|!FS_COLOR_YELLOW, #$0234|!FS_COLOR_YELLOW, #$0235|!FS_COLOR_YELLOW
	.flute
	dw #$0226|!FS_COLOR_BLUE, #$0227|!FS_COLOR_BLUE, #$0236|!FS_COLOR_BLUE, #$0237|!FS_COLOR_BLUE
	.book
	dw #$022A|!FS_COLOR_GREEN, #$022B|!FS_COLOR_GREEN, #$023A|!FS_COLOR_GREEN, #$023B|!FS_COLOR_GREEN
	.redcane
	dw #$021D|!FS_COLOR_RED, #$021E|!FS_COLOR_RED, #$022D|!FS_COLOR_RED, #$022E|!FS_COLOR_RED
	.bluecane
	dw #$021D|!FS_COLOR_BLUE, #$021E|!FS_COLOR_BLUE, #$022D|!FS_COLOR_BLUE, #$022E|!FS_COLOR_BLUE
	.cape
	dw #$0248|!FS_COLOR_RED, #$0249|!FS_COLOR_RED, #$0258|!FS_COLOR_RED, #$0259|!FS_COLOR_RED
	.mirror
	dw #$024A|!FS_COLOR_BLUE, #$024B|!FS_COLOR_BLUE, #$025A|!FS_COLOR_BLUE, #$025B|!FS_COLOR_BLUE

	.flippers
	dw #$020E|!FS_COLOR_BLUE, #$020F|!FS_COLOR_BLUE, #$021F|!FS_COLOR_BLUE|!FS_HFLIP, #$021F|!FS_COLOR_BLUE

	.boots
	dw #$024C|!FS_COLOR_BOOTS, #$024D|!FS_COLOR_BOOTS, #$025C|!FS_COLOR_BOOTS, #$025D|!FS_COLOR_BOOTS
	
	.pearl
	dw #$0264|!FS_COLOR_RED, #$0265|!FS_COLOR_RED, #$0274|!FS_COLOR_RED, #$0275|!FS_COLOR_RED
	
	.gloves
	dw #$024E|!FS_COLOR_BROWN, #$024F|!FS_COLOR_BROWN, #$025E|!FS_COLOR_BROWN, #$025F|!FS_COLOR_BROWN
	.mitts
	dw #$0260|!FS_COLOR_YELLOW, #$0261|!FS_COLOR_YELLOW, #$0270|!FS_COLOR_YELLOW, #$0271|!FS_COLOR_YELLOW
	
	.mushroom
	dw #$0262|!FS_COLOR_RED, #$0263|!FS_COLOR_RED, #$0272|!FS_COLOR_RED, #$0273|!FS_COLOR_RED
	.powder
	dw #$020A|!FS_COLOR_BROWN, #$020B|!FS_COLOR_BROWN, #$021A|!FS_COLOR_BROWN, #$021B|!FS_COLOR_BROWN

	.emptyBottle
	.redPotion
	.greenPotion
	.bluePotion
	.fairyBottle
	.beeBottle
	.goodBeeBottle
	dw #$0240|!FS_COLOR_BW, #$0241|!FS_COLOR_BW, #$0250|!FS_COLOR_BW, #$0251|!FS_COLOR_BW

;--------------------------------------------------------------------------------
FileSelectDrawHudBar:
	LDA #$029B|!FS_COLOR_GREEN : %fs_draw16x8(0,10)
	LDA $700362
	JSL.l HexToDec
	LDA $7F5004 : AND.w #$00FF : !ADD.w #$210+!FS_COLOR_BW : %fs_draw8x8(1,9)
	LDA $7F5005 : AND.w #$00FF : !ADD.w #$210+!FS_COLOR_BW : %fs_draw8x8(1,10)
	LDA $7F5006 : AND.w #$00FF : !ADD.w #$210+!FS_COLOR_BW : %fs_draw8x8(1,11)
	LDA $7F5007 : AND.w #$00FF : !ADD.w #$210+!FS_COLOR_BW : %fs_draw8x8(1,12)

	LDA #$028B|!FS_COLOR_BLUE : %fs_draw16x8(0,14)
	LDA $700343 : AND.w #$00FF
	JSL.l HexToDec
	LDA $7F5006 : AND.w #$00FF : !ADD.w #$210+!FS_COLOR_BW : %fs_draw8x8(1,14)
	LDA $7F5007 : AND.w #$00FF : !ADD.w #$210+!FS_COLOR_BW : %fs_draw8x8(1,15)

	LDA.l !FS_INVENTORY_SWAP_2 : AND.w #$0040 : BEQ +
		LDA #$0299|!FS_COLOR_RED : %fs_draw16x8(0,17)
	+
	LDA #$0289|!FS_COLOR_BROWN : %fs_draw16x8(0,17)
	++
	LDA $700377 : AND.w #$00FF
	JSL.l HexToDec
	LDA $7F5006 : AND.w #$00FF : !ADD.w #$210+!FS_COLOR_BW : %fs_draw8x8(1,17)
	LDA $7F5007 : AND.w #$00FF : !ADD.w #$210+!FS_COLOR_BW : %fs_draw8x8(1,18)
RTS
;--------------------------------------------------------------------------------
AltBufferTable:
    LDA.b #$02 : STA $210c ; Have Screen 3 use same tile area as screens 1

    REP #$20
    LDX.w #$0300 ; 12 rows with 64 bytes (30 tiles * 2 + 4 byte header)
    ;fill with the blank character
    LDA.w #$0188
    -
        STA $1000, X
        DEX : DEX : BNE -

    ; set vram offsets
    LDA.w #$2161 : STA $1002 ;file 1 top row
    LDA.w #$4161 : STA $1042 ;file 1 bottom row

    LDA.w #$6161 : STA $1082 ;gap row top
    LDA.w #$8161 : STA $10C2 ;gap row bottom

    LDA.w #$A161 : STA $1102 ;file 2 top row
    LDA.w #$C161 : STA $1142 ;file 2 bottom row

    LDA.w #$E161 : STA $1182 ;gap row top
    LDA.w #$0162 : STA $11c2 ;gap row bottom

    LDA.w #$2162 : STA $1202 ;file 3 top row
    LDA.w #$4162 : STA $1242 ;file 3 bottom row

    LDA.w #$6162 : STA $1282 ;extra gap row top
    LDA.w #$8162 : STA $12c2 ;extra gap row bottom

    ; set lengths
    LDA.w #$3B00
    STA $1004 ;file 1 top row
    STA $1044 ;file 1 bottom row
    STA $1084 ;gap row top
    STA $10C4 ;gap row bottom
    STA $1104 ;file 2 top row
    STA $1144 ;file 2 bottom row
    STA $1184 ;gap row top
    STA $11c4 ;gap row bottom
    STA $1204 ;file 3 top row
    STA $1244 ;file 3 bottom row
    STA $1284 ;extra gap row top
    STA $12c4 ;extra gap row bottom

    ; Set last packet marker
    LDA.w #$00FF : STA $1302
    SEP #$20

RTL
;--------------------------------------------------------------------------------
Validate_SRAM:
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
LoadFullItemTiles:
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
	
		LDA.b #$00 : STA $2116 ; write VRAM destination address
		LDA.b #$30 : STA $2117 ; write VRAM destination address

		LDA.b #$31 : STA $4304 ; set bus A source bank
		LDA.b #FileSelectNewGraphics : STA $4302 ; set bus A source address to SRAM
		LDA.b #FileSelectNewGraphics>>8 : STA $4303 ; set bus A source address to SRAM
	
		LDA $2100 : PHA : LDA.b #$80 : STA $2100 ; save screen state & turn screen off
		
		STZ $4305 : LDA.b #$10 : STA $4306 ; set transfer size to 0x1000
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
RTL
;--------------------------------------------------------------------------------
