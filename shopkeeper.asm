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
	LDY $0A : TYA : ASL : TAY : LDA.w .digit_properties, Y : STA !BIGRAM, X : INX : INX
	LDA.w #$0000 : STA !BIGRAM, X : INX : INX
	
	LDA $0E : !ADD.w #$0008 : STA $0E ; move offset 8px right
endmacro
;--------------------------------------------------------------------------------
!COLUMN_LOW = "$7F5022"
!COLUMN_HIGH = "$7F5023"
DrawPrice:
	PHX : PHY : PHP
		LDY.b #$FF
		LDX #$00 ; clear bigram pointer

		LDA $0C : CMP.w #1000 : !BLT + : JMP .len4 : +
				  CMP.w #100 : !BLT + : JMP .len3 : +
				  CMP.w #10 : !BLT + : JMP .len2 : +
				  CMP.w #1 : !BLT + : JMP .len1 : +

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
!SHOP_INVENTORY = "$7F5052" ; $7F505E
!SHOP_STATE = "$7F505F"
!SHOP_CAPACITY = "$7F5060"
!SCRATCH_TEMP_X = "$7F5061"
!SHOP_SRAM_INDEX = "$7F5062"
!SHOP_MERCHANT = "$7F5063"
!SHOP_DMA_TIMER = "$7F5064"
;--------------------------------------------------------------------------------
!NMI_AUX = "$7F5044"
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
		;LDA ShopTable+3, X : CMP $010E : BNE +
		LDA ShopTable+5, X : AND.w #$0040 : BNE ++
			LDA $7F5099 : AND #$00FF : CMP ShopTable+3, X : BNE +
		++
			SEP #$20 ; set 8-bit accumulator
			LDA ShopTable, X : STA !SHOP_ID
			LDA ShopTable+5, X : STA !SHOP_TYPE
			AND.b #$03 : ASL #2 : STA !SHOP_CAPACITY
			LDA ShopTable+6, X : STA !SHOP_MERCHANT
			LDA ShopTable+7, X : STA !SHOP_SRAM_INDEX
			BRA .success
		+
		LDA ShopTable, X : AND.w #$00FF : CMP.w #$00FF : BEQ .fail
		INX #8
	BRA -
	
	.fail
	SEP #$20 ; set 8-bit accumulator
	LDA.b #$FF : STA !SHOP_TYPE ; $FF = error condition
	JMP .done
	
	.success
	SEP #$20 ; set 8-bit accumulator
	
	LDX.w #$0000
	LDY.w #$0000
	-
		TYA : CMP !SHOP_CAPACITY : !BLT ++ : JMP .stop : ++
		LDA.l ShopContentsTable+1, X : CMP.b #$FF : BNE ++ : JMP .stop : ++
		
		LDA.l ShopContentsTable, X : CMP !SHOP_ID : BEQ ++ : JMP .next : ++
			LDA.l ShopContentsTable+1, X : PHX : TYX : STA.l !SHOP_INVENTORY, X : PLX
			LDA.l ShopContentsTable+2, X : PHX : TYX : STA.l !SHOP_INVENTORY+1, X : PLX
			LDA.l ShopContentsTable+3, X : PHX : TYX : STA.l !SHOP_INVENTORY+2, X : PLX
			
			PHY
				PHX
					LDA.b #$00 : XBA : TYA : LSR #2 : !ADD !SHOP_SRAM_INDEX : TAX
					LDA PurchaseCounts, X : TYX : STA.l !SHOP_INVENTORY+3, X : TAY
				PLX
				
				LDA.l ShopContentsTable+4, X : BEQ ++
				TYA : CMP.l ShopContentsTable+4, X : !BLT ++
					PLY
					LDA.l ShopContentsTable+5, X : PHX : TYX : STA.l !SHOP_INVENTORY, X : PLX
					LDA.l ShopContentsTable+6, X : PHX : TYX : STA.l !SHOP_INVENTORY+1, X : PLX
					LDA.l ShopContentsTable+7, X : PHX : TYX : STA.l !SHOP_INVENTORY+2, X : PLX
					BRA +++
				++
			PLY : +++
			
			PHX : PHY
				PHX : TYX : LDA.l !SHOP_INVENTORY, X : PLX : TAY
				REP #$20 ; set 16-bit accumulator
				LDA 1,s : TAX : LDA.l .tile_offsets, X : TAX
				JSR LoadTile
			PLY : PLX
			INY #4
		
		.next
		INX #8
	JMP -
	.stop
	
	;LDA $A0 : CMP.b #$FF : BNE .normal
	;.dumb
	;	LDA $2137
	;	LDA $213F
	;	LDA $213D
	;	CMP.b #60
	;	!BLT .dumb
	;.normal
	;LDA #$80 : STA $2100
	;JSR Shopkeeper_UploadVRAMTiles
	;LDA #$0F : STA $2100
	LDA.b #Shopkeeper_UploadVRAMTilesLong>>16 : STA !NMI_AUX+2
	LDA.b #Shopkeeper_UploadVRAMTilesLong>>8 : STA !NMI_AUX+1
	LDA.b #Shopkeeper_UploadVRAMTilesLong>>0 : STA !NMI_AUX

	.done
	LDA.l !SHOP_TYPE : BIT.b #$20 : BEQ .notTakeAll ; Take-all
	.takeAll

		LDA.b #$00 : XBA : LDA !SHOP_SRAM_INDEX : TAX
		LDA.l PurchaseCounts, X
		BRA ++
	.notTakeAll
		LDA.b #$00
	++
	STA !SHOP_STATE

    ; If the item is $FF, make it not show (as if already taken)
	LDA !SHOP_INVENTORY : CMP.b #$FF : BNE +
		LDA !SHOP_STATE : ORA.l Shopkeeper_ItemMasks : STA !SHOP_STATE
	+
	LDA !SHOP_INVENTORY+4 : CMP.b #$FF : BNE +
		LDA !SHOP_STATE : ORA.l Shopkeeper_ItemMasks+1 : STA !SHOP_STATE
	+
	LDA !SHOP_INVENTORY+8 : CMP.b #$FF : BNE +
		LDA !SHOP_STATE : ORA.l Shopkeeper_ItemMasks+2 : STA !SHOP_STATE
	+

	PLP : PLY : PLX
	
	LDA.l !SHOP_TYPE : CMP.b #$FF : BNE +
		PLA : PLA : PLA
        INC $0BA0, X
        LDA $0E40, X
		JML.l ShopkeeperFinishInit
	+
RTL
.tile_offsets
dw $0000, $0000
dw $0080, $0000
dw $0100, $0000
;--------------------------------------------------------------------------------
;QueueItemDMA:
;	LDA.b #Shopkeeper_UploadVRAMTilesLong>>0 : STA !NMI_AUX
;	LDA.b #Shopkeeper_UploadVRAMTilesLong>>8 : STA !NMI_AUX+1
;	LDA.b #Shopkeeper_UploadVRAMTilesLong>>16 : STA !NMI_AUX+2
;RTS
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
;!SHOP_INVENTORY, X
;[id][$lo][$hi][purchase_counter]
;--------------------------------------------------------------------------------
Shopkeeper_UploadVRAMTilesLong:
	JSR.w Shopkeeper_UploadVRAMTiles
RTL
Shopkeeper_UploadVRAMTiles:
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

		LDA !SHOP_TYPE : AND.b #$10 : BNE .special
		JMP .normal

	.special

		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$40 : STA $2116 ; set VRAM register destination address
		LDA #$5A : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer

		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$40 : STA $2116 ; set VRAM register destination address
		LDA #$5B : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer

		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$60 : STA $2116 ; set VRAM register destination address
		LDA #$5A : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer

		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$60 : STA $2116 ; set VRAM register destination address
		LDA #$5B : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer

		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$80 : STA $2116 ; set VRAM register destination address
		LDA #$5A : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer

		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$80 : STA $2116 ; set VRAM register destination address
		LDA #$5B : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		JMP .end

	.normal
		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$60 : STA $2116 ; set VRAM register destination address
		LDA #$5C : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		
		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$60 : STA $2116 ; set VRAM register destination address
		LDA #$5D : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		
		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$80 : STA $2116 ; set VRAM register destination address
		LDA #$5C : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		
		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$80 : STA $2116 ; set VRAM register destination address
		LDA #$5D : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		
		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$A0 : STA $2116 ; set VRAM register destination address
		LDA #$5C : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		
		LDA #$40 : STA $4305 : STZ $4306 ; set transfer size to 0x40
		LDA #$A0 : STA $2116 ; set VRAM register destination address
		LDA #$5D : STA $2117
		LDA #$01 : STA $420B ; begin DMA transfer
		;--------------------------------------------------------------------------------
	.end
		PLA : STA $4306 ; restore DMA parameters
		PLA : STA $4305 ; restore DMA parameters
		PLA : STA $4304 ; restore DMA parameters
		PLA : STA $4303 ; restore DMA parameters
		PLA : STA $4302 ; restore DMA parameters
		PLA : STA $4301 ; restore DMA parameters
		PLA : STA $4300 ; restore DMA parameters
RTS
;--------------------------------------------------------------------------------
Shopkepeer_CallOriginal:
	PLA : PLA : PLA
	LDA.b #ShopkeeperJumpTable>>16 : PHA
	LDA.b #ShopkeeperJumpTable>>8 : PHA
	LDA.b #ShopkeeperJumpTable : PHA
    LDA $0E80, X
    JML.l UseImplicitRegIndexedLocalJumpTable
;--------------------------------------------------------------------------------
;!SHOP_TYPE = "$7F5051"
;!SHOP_CAPACITY = "$7F5020"
;!SCRATCH_TEMP_X = "$7F5021"
Sprite_ShopKeeper:
	
	LDA.l !SHOP_TYPE : CMP.b #$FF : BNE + : JMP.w Shopkepeer_CallOriginal : +
	
	PHB : PHK : PLB
		JSL.l Sprite_PlayerCantPassThrough
		
		; Draw Shopkeeper
		JSR.w Shopkeeper_DrawMerchant
		
		LDA.l !SHOP_TYPE : BIT.b #$80 : BEQ .normal ; Take-any
			BIT.b #$20 : BNE + ; Not A Take-All
			PHX
				LDA !SHOP_SRAM_INDEX : TAX
				LDA PurchaseCounts, X : BEQ ++ : PLX : BRA .done : ++
			PLX
			BRA .normal
		+ ; Take-All
			;PHX
			;	LDA !SHOP_SRAM_INDEX : TAX
			;	LDA.w PurchaseCounts, X : STA.l !SHOP_STATE
			;PLX
		.normal
		
		; Draw Items
		JSR.w Shopkeeper_DrawItems
		
		; Set Up Hitboxes
		JSR.w Shopkeeper_SetupHitboxes
		
		; $22
		; 0x48 - Left
		; 0x60 - Midpoint 1
		; 0x78 - Center
		; 0x90 - Midpoint 2
		; 0xA8 - Right
		.done
	PLB
RTL
;--------------------------------------------------------------------------------
macro DrawMerchant(head,body,speed)
	PHX : LDX.b #$00
	LDA $1A : AND <speed> : BEQ +
		-
			LDA.w .oam_shopkeeper_f1, X : STA !BIGRAM, X : INX
		CPX.b #$10 : !BLT -
	+
		-
			LDA.w .oam_shopkeeper_f2, X : STA !BIGRAM, X : INX
		CPX.b #$10 : !BLT -
	++
	PLX
	
	LDA !SHOP_MERCHANT : LSR #4 : AND.b #$0E : ORA !BIGRAM+5 : STA !BIGRAM+5
	LDA !SHOP_MERCHANT : LSR #4 : AND.b #$0E : ORA !BIGRAM+13 : STA !BIGRAM+13
	
	PHB
		LDA.b #$02 : STA $06 ; request 2 OAM slots
		LDA #$08 : JSL.l OAM_AllocateFromRegionA ; request 8 bytes
		STZ $07
	
		LDA.b #!BIGRAM : STA $08
		LDA.b #!BIGRAM>>8 : STA $09
		LDA.b #$7E : PHA : PLB ; set data bank to $7E
		JSL.l Sprite_DrawMultiple_quantity_preset
		LDA $90 : !ADD.b #$04*2 : STA $90 ; increment oam pointer
		LDA $92 : INC #2 : STA $92
	PLB
RTS
.oam_shopkeeper_f1
dw 0, -8 : db <head>, $00, $00, $02
dw 0, 0 : db <body>, $00, $00, $02
.oam_shopkeeper_f2
dw 0, -8 : db <head>, $00, $00, $02
dw 0, 0 : db <body>, $40, $00, $02
endmacro
;--------------------------------------------------------------------------------
Shopkeeper_DrawMerchant:
	LDA.l !SHOP_MERCHANT : AND.b #$07
	BEQ Shopkeeper_DrawMerchant_Type0
	CMP.b #$01 : BNE + : JMP Shopkeeper_DrawMerchant_Type1 : +
	CMP.b #$02 : BNE + : JMP Shopkeeper_DrawMerchant_Type2 : +
	CMP.b #$03 : BNE + : JMP Shopkeeper_DrawMerchant_Type3 : +
	CMP.b #$04 : BNE + : RTS : +
;--------------------------------------------------------------------------------
Shopkeeper_DrawMerchant_Type0:
%DrawMerchant(#$00, #$10, #$10)
;--------------------------------------------------------------------------------
Shopkeeper_DrawMerchant_Type1:
	LDA.b #$01 : STA $06 ; request 1 OAM slot
	LDA #$04 : JSL.l OAM_AllocateFromRegionA ; request 4 bytes
	STZ $07
	LDA $1A : AND #$08 : BEQ +
		LDA.b #.oam_shopkeeper_f1 : STA $08
		LDA.b #.oam_shopkeeper_f1>>8 : STA $09
		BRA ++
	+
		LDA.b #.oam_shopkeeper_f2 : STA $08
		LDA.b #.oam_shopkeeper_f2>>8 : STA $09
	++
	JSL.l Sprite_DrawMultiple_quantity_preset
	LDA $90 : !ADD.b #$04 : STA $90 ; increment oam pointer
	LDA $92 : INC : STA $92
RTS
.oam_shopkeeper_f1
dw 0, 0 : db $46, $0A, $00, $02
.oam_shopkeeper_f2
dw 0, 0 : db $46, $4A, $00, $02
;--------------------------------------------------------------------------------
Shopkeeper_DrawMerchant_Type2:
%DrawMerchant(#$84, #$10, #$40)
;--------------------------------------------------------------------------------
Shopkeeper_DrawMerchant_Type3:
%DrawMerchant(#$8E, #$10, #$40)
;--------------------------------------------------------------------------------
Shopkeeper_SetupHitboxes:
	PHX : PHY : PHP
	LDY.b #$00
	-
		PHY
			TYA : LSR #2 : TAY
			LDA.l !SHOP_STATE : AND.w Shopkeeper_ItemMasks, Y : BEQ +
				PLY : BRA .no_interaction
			+
		PLY
		LDA $00EE : CMP $0F20, X : BNE .no_interaction  

		JSR.w Setup_LinksHitbox
		JSR.w Setup_ShopItemCollisionHitbox
		JSL.l Utility_CheckIfHitBoxesOverlapLong
		BCC .no_contact
		    JSR.w Sprite_HaltSpecialPlayerMovementCopied
		.no_contact

		JSR.w Setup_ShopItemInteractionHitbox
		JSL.l Utility_CheckIfHitBoxesOverlapLong : BCC .no_interaction
		    LDA $F6 : AND.b #$80 : BEQ .no_interaction ; check for A-press
			LDA $10 : CMP.b #$0C : !BGE .no_interaction ; don't interact in other modes besides game action
			JSR.w Shopkeeper_BuyItem
		.no_interaction
		INY #4
	TYA : CMP !SHOP_CAPACITY : !BLT -
	;CPY.b #$0C : !BLT -
	
	PLP : PLY : PLX
RTS
;--------------------
;!SHOP_STATE
Shopkeeper_BuyItem:
	PHX : PHY
		TYX
		
		LDA.l !SHOP_INVENTORY, X
		CMP.b #$0E : BEQ .refill ; Bee Refill
		CMP.b #$2E : BEQ .refill ; Red Potion Refill
		CMP.b #$2F : BEQ .refill ; Green Potion Refill
		CMP.b #$30 : BEQ .refill ; Blue Potion Refill
		BRA +
			.refill
			JSL.l Sprite_GetEmptyBottleIndex : BMI .full_bottles
		+

		LDA !SHOP_TYPE : AND.b #$80 : BNE .buy ; don't charge if this is a take-any
		REP #$20 : LDA CurrentRupees : CMP.l !SHOP_INVENTORY+1, X : SEP #$20 : !BGE .buy
		
		.cant_afford
	        LDA.b #$7A
	        LDY.b #$01
	        JSL.l Sprite_ShowMessageUnconditional
			LDA.b #$3C : STA $012E ; error sound
			JMP .done
		.full_bottles
	        LDA.b #$6B
	        LDY.b #$01
	        JSL.l Sprite_ShowMessageUnconditional
			LDA.b #$3C : STA $012E ; error sound
			JMP .done
		.buy
			LDA !SHOP_TYPE : AND.b #$80 : BNE ++ ; don't charge if this is a take-any
				REP #$20 : LDA CurrentRupees : !SUB !SHOP_INVENTORY+1, X : STA CurrentRupees : SEP #$20 ; Take price away
			++
			LDA.l !SHOP_INVENTORY, X : TAY : JSL.l Link_ReceiveItem
			LDA.l !SHOP_INVENTORY+3, X : INC : STA.l !SHOP_INVENTORY+3, X
			
			TXA : LSR #2 : TAX
			LDA !SHOP_TYPE : BIT.b #$80 : BNE +
				LDA.l !SHOP_STATE : ORA.w Shopkeeper_ItemMasks, X : STA.l !SHOP_STATE
				PHX
					TXA : !ADD !SHOP_SRAM_INDEX : TAX
					LDA PurchaseCounts, X : INC : BEQ +++ : STA PurchaseCounts, X : +++
				PLX
				BRA ++
			+ ; Take-any
			;STA $FFFFFF
				BIT.b #$20 : BNE .takeAll
				.takeAny
					LDA.l !SHOP_STATE : ORA.b #$07 : STA.l !SHOP_STATE
					PHX : LDA.l !SHOP_SRAM_INDEX : TAX : LDA.b #$01 : STA.l PurchaseCounts, X : PLX
					BRA ++
				.takeAll
					LDA.l !SHOP_STATE : ORA.w Shopkeeper_ItemMasks, X : STA.l !SHOP_STATE
					PHX : LDA.l !SHOP_SRAM_INDEX : TAX : LDA.l !SHOP_STATE : STA.l PurchaseCounts, X : PLX
			++
	.done
	PLY : PLX
RTS
Shopkeeper_ItemMasks:
db #$01, #$02, #$04
;--------------------
;!SHOP_ID = "$7F5050"
;!SHOP_SRAM_INDEX = "$7F5062"
;--------------------
Setup_ShopItemCollisionHitbox:
;The complications with XBA are to handle the fact that nintendo likes to store
;high and low bytes of 16 bit postion values seperately :-(

	REP #$20 ; set 16-bit accumulator
	LDA $00 : PHA
	SEP #$20 ; set 8-bit accumulator

    ; load shopkeeper X (16 bit)
    LDA $0D30, X : XBA : LDA $0D10, X
	
	REP #$20 ; set 16-bit accumulator
	PHA : PHY
		LDA !SHOP_TYPE : AND.w #$0003 : DEC : ASL : TAY
		LDA.w Shopkeeper_DrawNextItem_item_offsets_idx, Y : STA $00 ; get table from the table table
	PLY : PLA
    
    !ADD ($00), Y
    !ADD.w #$0002 ; a small negative margin
    ; TODO: add 4 for a narrow item
    SEP #$20 ; set 8-bit accumulator

    ; store hitbox X 
    STA $04 : XBA : STA $0A 

    ;load shopkeeper Y (16 bit)
    LDA $0D20, X : XBA : LDA $0D00, X 

    REP #$20 ; set 16-bit accumulator
    PHY : INY #2
		!ADD ($00), Y
	PLY
	PHA : LDA !SHOP_TYPE : AND.w #$0080 : BEQ + ; lower by 4 for Take-any
		PLA : !ADD.w #$0004
		BRA ++
	+ : PLA : ++
    SEP #$20 ; set 8-bit accumulator

    ; store hitbox Y Low: $05, High $0B
    STA $05 : XBA : STA $0B 

    LDA.b #12 : STA $06 ; Hitbox width, always 12 for existing (wide) shop items
    ; TODO: for narrow sprite store make width 4 (i.e. 8 pixels smaller)

    LDA.b #14 : STA $07 ; Hitbox height, always 14
	
	REP #$20 ; set 16-bit accumulator
	PLA : STA $00
	SEP #$20 ; set 8-bit acc
RTS
;--------------------------------------------------------------------------------
; Adjusts the already set up collision hitbox to be a suitable interaction hitbox
Setup_ShopItemInteractionHitbox:
	PHP
	SEP #$20 ; set 8-bit accumulator
	
    ; collision hitbox has left margin of -2, we want margin of 8 so we subtract 10
    LDA $04 : !SUB.b #$0A : STA $04
    LDA $0A : SBC.b #$00 : STA $0A ; Apply borrow

    ; collision hitbox has 0 top margin, we want a margin of 8 so we subtract 8
    LDA $05 : !SUB.b #$08 : STA $05
    LDA $0B : SBC.b #$00 : STA $0B ; Apply borrow    

    ; We want a width of 32 for wide or 24 for narrow, so we add 20
    LDA $06 : !ADD.b #20 : STA $06 ; Hitbox width

    LDA.b #40 : STA $07 ; Hitbox height, always 40
	PLP
RTS
;--------------------------------------------------------------------------------
; Following is a copy of procedure $3770A (Bank06.asm Line 6273) 
; because there is no long version available
Setup_LinksHitbox:
	LDA.b #$08 : STA $02
                     STA $03
        
        LDA $22 : !ADD.b #$04 : STA $00
        LDA $23 : ADC.b #$00 : STA $08
        
        LDA $20 : ADC.b #$08 : STA $01
        LDA $21 : ADC.b #$00 : STA $09     
RTS
;--------------------------------------------------------------------------------
; The following is a copy of procedure Sprite_HaltSpecialPlayerMovement (Bank1E.asm line 255)
; because there is no long version available
Sprite_HaltSpecialPlayerMovementCopied:
        PHX      
        JSL Sprite_NullifyHookshotDrag
        STZ $5E ; Set Link's speed to zero...
        JSL Player_HaltDashAttackLong
        PLX
RTS
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
	LDA.l !SHOP_STATE : AND.w Shopkeeper_ItemMasks, Y : BEQ + : JMP .next : +
	
	PHY
	
	LDA !SHOP_TYPE : AND.b #$03 : DEC : ASL : TAY
	REP #$20 ; set 16-bit accumulator
	LDA.w .item_offsets_idx, Y : STA $00 ; get table from the table table
	LDA 1,s : ASL #2 : TAY ; set Y to the item index
	LDA ($00), Y : STA.l !SPRITE_OAM ; load X-coordinate
	INY #2
	LDA !SHOP_TYPE : AND.w #$0080 : BNE +
		LDA ($00), Y : STA.l !SPRITE_OAM+2 : BRA ++ ; load Y-coordinate
	+
		LDA ($00), Y : !ADD.w #$0004 : STA.l !SPRITE_OAM+2 ; load Y-coordinate
	++
	SEP #$20 ; set 8-bit accumulator
	PLY
	
	LDA.l !SHOP_INVENTORY, X ; get item id
	CMP.b #$2E : BNE + : BRA .potion
	+ CMP.b #$2F : BNE + : BRA .potion
	+ CMP.b #$30 : BEQ .potion
	.normal
		LDA.w .tile_indices, Y : BRA + ; get item gfx index
	.potion
		LDA.b #$C0 ; potion is #$C0 because it's already there in VRAM
	+
	XBA

	LDA !SHOP_TYPE : AND.b #$10 : BEQ +
		XBA : !SUB #$22 : XBA ; alt vram
	+
	XBA

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
	
	LDA !SHOP_TYPE : AND.b #$80 : BNE +
		JSR.w Shopkeeper_DrawNextPrice
	+
	
	.next
	INY
	INX #4
RTS
;--------------------------------------------------------------------------------
.item_offsets_idx
dw #.item_offsets_1
dw #.item_offsets_2
dw #.item_offsets_3
.item_offsets_1
dw 8, 40
.item_offsets_2
dw -16, 40
dw 32, 40
.item_offsets_3
dw -40, 40
dw 8, 40
dw 56, 40
.tile_indices
db $C6, $C8, $CA
;--------------------------------------------------------------------------------
!COLUMN_LOW = "$7F5022"
!COLUMN_HIGH = "$7F5023"
Shopkeeper_DrawNextPrice:
	PHB : PHK : PLB
	PHX : PHY : PHP
	
	REP #$20 ; set 16-bit accumulator
	PHY
		LDA !SHOP_TYPE : AND.w #$0003 : DEC : ASL : TAY
		LDA.w Shopkeeper_DrawNextItem_item_offsets_idx, Y : STA $00 ; get table from the table table
		LDA.w .price_columns_idx, Y : STA $02 ; get table from the table table
	PLY : PHY
		TYA : ASL #2 : TAY
		LDA ($00), Y : STA $0E ; set coordinate
		TYA : LSR : TAY
		LDA ($02), Y : STA !COLUMN_LOW
		INY : LDA ($02), Y : STA !COLUMN_HIGH
	PLY
	LDA.l !SHOP_INVENTORY+1, X : STA $0C ; set value
	
	BEQ .free
		JSR.w DrawPrice
		SEP #$20 : STA $06 : STZ $07 ; set 8-bit accumulator & store result
		PHA
			LDA.b #!BIGRAM : STA $08
			LDA.b #!BIGRAM>>8 : STA $09
			LDA.b #$7E : PHA : PLB ; set data bank to $7E

			PHX : PHA : LDA !SCRATCH_TEMP_X : TAX : PLA : JSL.l Sprite_DrawMultiple_quantity_preset : PLX
		
			LDA 1,s
			ASL #2 : !ADD $90 : STA $90 ; increment oam pointer
		PLA
		!ADD $92 : STA $92
	.free
	PLP : PLY : PLX
	PLB
RTS
.price_columns_idx
dw #.price_columns_1
dw #.price_columns_2
dw #.price_columns_3
.price_columns_1
db #$00, #$FF
.price_columns_2
db #$00, #$80, #$80, $FF
.price_columns_3
db #$00, #$60, #$60, #$90, #$90, $FF
;--------------------------------------------------------------------------------
RequestItemOAM:
	PHX : PHY : PHA
		STA $06 ; request A OAM slots
		LDA $20 : CMP.b #$62 : !BGE .below
			.above
			LDA 1,s : ASL #2 : JSL.l OAM_AllocateFromRegionA ; request 4A bytes
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
