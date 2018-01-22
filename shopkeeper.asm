;================================================================================
; Randomize 300 Rupee NPC
;--------------------------------------------------------------------------------
Set300RupeeNPCItem:
	INC $0D80, X ; thing we wrote over

	PHA : PHP
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #291 : BNE +
		LDA RupeeNPC_MoldormCave : TAY ; load moldorm cave value into Y
		BRA .done
	+ CMP.w #286 : BNE +
		LDA RupeeNPC_NortheastDarkSwampCave : TAY ; load northeast dark swamp cave value into Y
		BRA .done
	+
	LDY.b #$46 ; default to a normal 300 rupees
	.done
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
; 291 - Moldorm Cave
; 286 - Northeast Dark Swamp Cave
;--------------------------------------------------------------------------------
!BIGRAM = "$7EC900";
;--------------------------------------------------------------------------------
!SPRITE_OAM = "$7EC025"
; A = Tile ID
macro UploadOAM(dest)
	PHA : PHP

	PHA
		REP #$20 ; set 16-bit accumulator
		LDA.w #$0000 : STA.l !SPRITE_OAM
		               STA.l !SPRITE_OAM+2
		LDA.w #$0200 : STA.l !SPRITE_OAM+6
		SEP #$20 ; set 8-bit accumulator
		LDA.b <dest> : STA.l !SPRITE_OAM+4

	LDA $01,s

		JSL.l GetSpritePalette
		STA !SPRITE_OAM+5 : STA !SPRITE_OAM+13
	PLA
	JSL.l IsNarrowSprite : BCS .narrow

	BRA .done

	.narrow
	REP #$20 ; set 16-bit accumulator
	LDA.w #$0000 : STA.l !SPRITE_OAM+7
	               STA.l !SPRITE_OAM+14
	LDA.w #$0800 : STA.l !SPRITE_OAM+9
	LDA.w #$3400 : STA.l !SPRITE_OAM+11

	.done
	PLP : PLA
endmacro
;--------------------------------------------------------------------------------
; $0A : Digit Offset
; $0C-$0D : Value to Display
; $0E-$0F : Base Coordinate
;--------------------------------------------------------------------------------
macro DrawDigit(value,offset)
	STZ $0A ; clear digit buffer
	LDA $0C ; load value
	--
	CMP.w <value> : !BLT ++
		!SUB.w <value>
		INC $0A
		BRA --
	++
	STA $0C ; save value
	CPY.b #$FF : BNE +
		LDY.b <offset>
		LDA $0E : !ADD.w .digit_offsets, Y : STA $0E
	+
	LDA $0E : STA !BIGRAM, X : INX : INX
	LDA.w #56 : STA !BIGRAM, X : INX : INX
	LDY $0A : TYA : ASL : TAY : LDA .digit_properties, Y : STA !BIGRAM, X : INX : INX
	LDA.w #$0000 : STA !BIGRAM, X : INX : INX

	LDA $0E : !ADD.w #$0008 : STA $0E ; move offset 8px right
endmacro
;--------------------------------------------------------------------------------
!COLUMN_LOW = "$7F5020"
!COLUMN_HIGH = "$7F5021"
DrawPrice:
	PHX : PHY : PHP
		LDY.b #$FF
		LDX #$00 ; clear bigram pointer

		LDA $0C : CMP.w #1000 : !BLT + : BRL .len4 : +
				  CMP.w #100 : !BLT + : BRL .len3 : +
				  CMP.w #10 : !BLT + : BRL .len2 : +
				  CMP.w #1 : !BLT + : BRL .len1 : +

			.len4
				%DrawDigit(#1000,#6)
			
			.len3
				%DrawDigit(#100,#4)
			
			.len2
				%DrawDigit(#10,#2)
			
			.len1
				%DrawDigit(#1,#0)
				
		SEP #$20 ; set 8-bit accumulator
		TXA : LSR #3 : STA $06 ; request 1-4 OAM slots
		;ASL #2 : JSL.l OAM_AllocateFromRegionB ; request 4-16 bytes
		ASL #2
			PHA
				LDA $22 : CMP !COLUMN_LOW : !BLT .off
						  CMP !COLUMN_HIGH : !BGE .off
				.on
				PLA : JSL.l OAM_AllocateFromRegionB : BRA + ; request 4-16 bytes
				.off
				PLA : JSL.l OAM_AllocateFromRegionA ; request 4-16 bytes
			+
		TXA : LSR #3
	PLP : PLY : PLX
RTS
;--------------------------------------------------------------------------------
!TILE_UPLOAD_OFFSET_OVERRIDE = "$7F5042"
!FREE_TILE_BUFFER = "#$1180"
!SHOP_ID = "$7F5050"
!SHOP_TYPE = "$7F5051"
!SHOP_INVENTORY = "$7F5052"
!SCRATCH_CAPACITY = "$7F5020"
!SCRATCH_TEMP_X = "$7F5021"
;--------------------------------------------------------------------------------
.digit_properties
dw $0230, $0231, $0202, $0203, $0212, $0213, $0222, $0223, $0232, $0233
;--------------------------------------------------------------------------------
.digit_offsets
dw 4, 0, -4, -8
;--------------------------------------------------------------------------------
SpritePrep_ShopKeeper:
	PHX : PHY : PHP
	REP #$30 ; set 16-bit accumulator & index registers
	;LDA $A0
	LDX.w #$0000
	-
		LDA ShopTable+1, X : CMP $A0 : BNE +
		LDA ShopTable+3, X : CMP $010E : BNE +
			SEP #$20 ; set 8-bit accumulator
			LDA ShopTable, X : STA !SHOP_ID
			LDA ShopTable+5, X : STA !SHOP_TYPE
			AND.b #$03 : STA !SCRATCH_CAPACITY
			ASL : !ADD !SCRATCH_CAPACITY : STA !SCRATCH_CAPACITY
			BRA .success
		+
		TXA : !ADD.w #$0008 : TAX
		LDA ShopTable, X : AND.w #$00FF : CMP.w #$00FF : BEQ .fail
	BRA -
	
	.fail
	SEP #$20 ; set 8-bit accumulator
	LDA.b #$FF : STA !SHOP_TYPE ; $FF = error condition
	BRA .done
	
	.success
	SEP #$20 ; set 8-bit accumulator
	
	LDX.w #$0000
	LDY.w #$0000
	-
		TYA : CMP !SCRATCH_CAPACITY : !BGE .stop
		LDA.l ShopContentsTable+1, X : CMP.b #$FF : BEQ .stop
		LDA.l ShopContentsTable, X : CMP !SHOP_ID : BNE +
			LDA.l ShopContentsTable+1, X : PHX : TYX : STA.l !SHOP_INVENTORY, X : PLX
			LDA.l ShopContentsTable+2, X : PHX : TYX : STA.l !SHOP_INVENTORY+1, X : PLX
			LDA.l ShopContentsTable+3, X : PHX : TYX : STA.l !SHOP_INVENTORY+2, X : PLX
			PHX : PHY
				LDA.l ShopContentsTable+1, X : TAY
				REP #$20 ; set 16-bit accumulator
				LDA 1,s : TAX : LDA.l .tile_offsets, X : TAX
				JSR LoadTile
			PLY : PLX
			INX #4
			INY #3
		+
	BRA -
	.stop
	
	LDA #$80 : STA $2100
	JSR UploadVRAMTiles
	LDA #$0F : STA $2100

	.done
	PLP : PLY : PLX
RTL
.tile_offsets
dw $0000 : db $00
dw $0080 : db $00
dw $0100 : db $00
;--------------------------------------------------------------------------------
; X - Tile Buffer Offset
; Y - Item ID
LoadTile:
	TXA : !ADD.w !FREE_TILE_BUFFER : STA !TILE_UPLOAD_OFFSET_OVERRIDE ; load offset from X
	SEP #$30 ; set 8-bit accumulator & index registers
	TYA ; load item ID from Y
	JSL.l GetSpriteID ; convert loot id to sprite id
	JSL.l GetAnimatedSpriteTile_variable
	REP #$10 ; set 16-bit index registers
RTS
;--------------------------------------------------------------------------------
;shop_config - t--- --qq
; t - 0=Shop - 1=TakeAny
; qq - # of items for sale
;org $30C800 ; PC 0x184800 - 0x184FFF
;ShopTable:
;;db [id][roomID-low][roomID-high][entranceID-low][entranceID-high][shop_config][pad][pad]
;db $FF, $12, $01, $58, $00, $FF, $00, $00
;ShopContentsTable:
;;db [id][item][price-low][price-high]
;db $FF, $AF, $50, $00
;db $FF, $27, $0A, $00
;db $FF, $12, $F4, $01
;db $FF, $FF, $FF, $FF
;--------------------------------------------------------------------------------
UploadVRAMTiles:
		LDA $4300 : PHA ; preserve DMA parameters
		LDA $4301 : PHA ; preserve DMA parameters
		LDA $4302 : PHA ; preserve DMA parameters
		LDA $4303 : PHA ; preserve DMA parameters
		LDA $4304 : PHA ; preserve DMA parameters
		LDA $4305 : PHA ; preserve DMA parameters
		LDA $4306 : PHA ; preserve DMA parameters
		;--------------------------------------------------------------------------------
		LDA #$01 : STA $4300 ; set DMA transfer direction A -> B, bus A auto increment, double-byte mode
		LDA #$18 : STA $4301 ; set bus B destination to VRAM register
		LDA #$80 : STA $2115 ; set VRAM to increment by 2 on high register write
		
		LDA #$80 : STA $4302 ; set bus A source address to tile buffer
		LDA #$A1 : STA $4303
		LDA #$7E : STA $4304
		
		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		STZ $2116 ; set WRAM register source address
		LDA #$5C : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		
		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		STZ $2116 ; set WRAM register source address
		LDA #$5D : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		
		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$20 : STA $2116 ; set WRAM register source address
		LDA #$5C : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		
		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$20 : STA $2116 ; set WRAM register source address
		LDA #$5D : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		
		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$40 : STA $2116 ; set WRAM register source address
		LDA #$5C : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		
		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$40 : STA $2116 ; set WRAM register source address
		LDA #$5D : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		;--------------------------------------------------------------------------------
		PLA : STA $4306 ; restore DMA parameters
		PLA : STA $4305 ; restore DMA parameters
		PLA : STA $4304 ; restore DMA parameters
		PLA : STA $4303 ; restore DMA parameters
		PLA : STA $4302 ; restore DMA parameters
		PLA : STA $4301 ; restore DMA parameters
		PLA : STA $4300 ; restore DMA parameters
RTS
;--------------------------------------------------------------------------------
!COLUMN_LOW = "$7F5020"
!COLUMN_HIGH = "$7F5021"
Sprite_ShopKeeper:
	PHB : PHK : PLB
		JSL.l Sprite_PlayerCantPassThrough
		
		; Draw Shopkeeper
		LDA.b #$02 : STA $06 ; request 2 OAM slots
		LDA #$08 : JSL.l OAM_AllocateFromRegionA ; request 8 bytes
		LDA.b #$02 : STA $06 ; request 2 OAM slots
		STZ $07
		LDA $1A : AND #$10 : BEQ +
			LDA.b #.oam_shopkeeper_f1 : STA $08
			LDA.b #.oam_shopkeeper_f1>>8 : STA $09
			BRA ++
		+
			LDA.b #.oam_shopkeeper_f2 : STA $08
			LDA.b #.oam_shopkeeper_f2>>8 : STA $09
		++
		;LDA.b #$01 : STA.l !SKIP_EOR
		JSL.l Sprite_DrawMultiple_quantity_preset
		LDA $90 : !ADD.b #$04*2 : STA $90 ; increment oam pointer
		LDA $92 : INC #2 : STA $92
	
		; Draw Items
		JSR.w Shopkeeper_DrawItems
		
		LDA.b #$00 : STA.l !SKIP_EOR
		
		; $22
		; 0x48 - Left
		; 0x60 - Midpoint 1
		; 0x78 - Center
		; 0x90 - Midpoint 2
		; 0xA8 - Right
				
		LDA.b #$00 : STA !COLUMN_LOW
		LDA.b #$60 : STA !COLUMN_HIGH
		REP #$20 ; set 16-bit accumulator
		LDA.w #80 : STA $0C ; set value
		LDA.w #-40 : STA $0E ; set coordinate
		JSR.w DrawPrice
		SEP #$20 : STA $06 ; set 8-bit accumulator & store result
		PHA
			STZ $07
			LDA.b #!BIGRAM : STA $08
			LDA.b #!BIGRAM>>8 : STA $09
			LDA.b #$7E : PHA : PLB ; set data bank to $7E
			JSL.l Sprite_DrawMultiple_quantity_preset
			PHK : PLB
			LDA 1,s
			ASL #2 : !ADD $90 : STA $90 ; increment oam pointer
		PLA
		!ADD $92 : STA $92
			
		LDA.b #$60 : STA !COLUMN_LOW
		LDA.b #$90 : STA !COLUMN_HIGH	
		REP #$20 ; set 16-bit accumulator
		LDA.w #10 : STA $0C ; set value
		LDA.w #8 : STA $0E ; set coordinate
		JSR.w DrawPrice
		SEP #$20 : STA $06 ; set 8-bit accumulator & store result
		PHA
			STZ $07
			LDA.b #!BIGRAM : STA $08
			LDA.b #!BIGRAM>>8 : STA $09
			LDA.b #$7E : PHA : PLB ; set data bank to $7E
			JSL.l Sprite_DrawMultiple_quantity_preset
			PHK : PLB
			LDA 1,s
			ASL #2 : !ADD $90 : STA $90 ; increment oam pointer
		PLA
		!ADD $92 : STA $92
			
		LDA.b #$90 : STA !COLUMN_LOW
		LDA.b #$FF : STA !COLUMN_HIGH	
		REP #$20 ; set 16-bit accumulator
		LDA.w #500 : STA $0C ; set value
		LDA.w #56 : STA $0E ; set coordinate
		JSR.w DrawPrice
		SEP #$20 : STA $06 ; set 8-bit accumulator & store result
		PHA
			STZ $07
			LDA.b #!BIGRAM : STA $08
			LDA.b #!BIGRAM>>8 : STA $09
			LDA.b #$7E : PHA : PLB ; set data bank to $7E
			JSL.l Sprite_DrawMultiple_quantity_preset
			PHK : PLB
			LDA 1,s
			ASL #2 : !ADD $90 : STA $90 ; increment oam pointer
		PLA
		!ADD $92 : STA $92
	PLB
RTL
;--------------------------------------------------------------------------------
.oam_shopkeeper_f1
dw 0, -8 : db $00, $0C, $00, $02
dw 0, 0 : db $10, $0C, $00, $02
.oam_shopkeeper_f2
dw 0, -8 : db $00, $0C, $00, $02
dw 0, 0 : db $10, $4C, $00, $02
;--------------------------------------------------------------------------------
;!SHOP_TYPE = "$7F5051"
;!SHOP_INVENTORY = "$7F5052"
!SPRITE_OAM = "$7EC025"
Shopkeeper_DrawItems:
	PHB : PHK : PLB
	PHX : PHY
	TXA : STA !SCRATCH_TEMP_X;
	LDX.b #$00
	LDY.b #$00
	LDA !SHOP_TYPE : AND.b #$03
	CMP.b #$03 : BNE +
		JSR.w Shopkeeper_DrawNextItem : BRA ++
	+ CMP.b #$02 : BNE + : ++
		JSR.w Shopkeeper_DrawNextItem : BRA ++
	+ CMP.b #$01 : BNE + : ++
		JSR.w Shopkeeper_DrawNextItem
	+
	PLY : PLX
	PLB
RTS

;--------------------------------------------------------------------------------
Shopkeeper_DrawNextItem:
	PHY
	TYA : ASL #2 : TAY
	REP #$20 ; set 16-bit accumulator
	LDA.w .item_offsets, Y : STA.l !SPRITE_OAM
	LDA.w .item_offsets+2, Y : STA.l !SPRITE_OAM+2
	SEP #$20 ; set 8-bit accumulator
	PLY

	LDA.w .tile_indices, Y ; get item gfx index
	STA.l !SPRITE_OAM+4

	LDA.l !SHOP_INVENTORY, X ; get item palette
	JSL.l GetSpritePalette : STA.l !SPRITE_OAM+5

	LDA.b #$00 : STA.l !SPRITE_OAM+6

	LDA.l !SHOP_INVENTORY, X ; get item palette
	JSL.l IsNarrowSprite : BCS .narrow
	.full
		LDA.b #$02
		STA.l !SPRITE_OAM+7
		LDA.b #$01
		BRA ++
	.narrow
		LDA.b #$00
		STA.l !SPRITE_OAM+7
		JSR.w PrepNarrowLower
		LDA.b #$02
	++
	PHX : PHA : LDA !SCRATCH_TEMP_X : TAX : PLA : JSR.w RequestItemOAM : PLX
	INY
	INX #3
RTS
;--------------------------------------------------------------------------------
.item_offsets
dw -40, 40
dw 8, 40
dw 56, 40
.tile_indices
db $C0, $C2, $C4
;--------------------------------------------------------------------------------
RequestItemOAM:
	PHX : PHY : PHA
		STA $06 ; request A OAM slots
		LDA $20 : CMP.b #$60 : !BGE .below
			.above
			LDA 1,s : ASL #2 : JSL.l OAM_AllocateFromRegionA : BRA + ; request 4A bytes
			BRA +
			.below
			LDA 1,s : ASL #2 : JSL.l OAM_AllocateFromRegionB ; request 4A bytes
		+
		LDA 1,s  : STA $06 ; request 3 OAM slots
		STZ $07
		LDA.b #!SPRITE_OAM : STA $08
		LDA.b #!SPRITE_OAM>>8 : STA $09
		LDA #$7E : PHB : PHA : PLB
			JSL Sprite_DrawMultiple_quantity_preset
		PLB
		LDA 1,s : ASL #2 : !ADD $90 : STA $90 ; increment oam pointer
		LDA $92 : !ADD 1,s : STA $92
	PLA : PLY : PLX
RTS
;--------------------------------------------------------------------------------
PrepNarrowLower:
	PHX
	LDX.b #$00
		REP #$20 ; set 16-bit accumulator
		LDA !SPRITE_OAM, X : !ADD.w #$0004 : STA !SPRITE_OAM, X : STA !SPRITE_OAM+8, X
		LDA !SPRITE_OAM+2, X : !ADD.w #$0008 : STA !SPRITE_OAM+10, X
		LDA !SPRITE_OAM+4, X : !ADD.w #$0010 : STA !SPRITE_OAM+12, X
		LDA !SPRITE_OAM+6, X : STA !SPRITE_OAM+14, X
		SEP #$20 ; set 8-bit accumulator
	PLX
RTS
;--------------------------------------------------------------------------------
;.oam_items
;dw -40, 40 : db $C0, $08, $00, $02
;dw 8, 40 : db $C2, $04, $00, $02
;dw 56, 40 : db $C4, $02, $00, $02
;--------------------------------------------------------------------------------
;.oam_prices
;dw -48, 56 : db $30, $02, $00, $00
;dw -40, 56 : db $31, $02, $00, $00
;dw -32, 56 : db $02, $02, $00, $00
;dw -24, 56 : db $03, $02, $00, $00
;
;dw 0, 56 : db $12, $02, $00, $00
;dw 8, 56 : db $13, $02, $00, $00
;dw 16, 56 : db $22, $02, $00, $00
;dw 24, 56 : db $23, $02, $00, $00
;
;dw 48, 56 : db $32, $02, $00, $00
;dw 56, 56 : db $33, $02, $00, $00
;dw 64, 56 : db $30, $02, $00, $00
;dw 72, 56 : db $31, $02, $00, $00
;--------------------------------------------------------------------------------
