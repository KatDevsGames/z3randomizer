!FREE_TILE_BUFFER = $1180
!FREE_TILE = $5C60
!FREE_TILE_ALT = $5A40

;--------------------------------------------------------------------------------
; $0A : Digit Offset
; $0C-$0D : Value to Display
; $0E-$0F : Base Coordinate
;--------------------------------------------------------------------------------
macro DrawDigit(value,offset)
	STZ.b Scrap0A ; clear digit buffer
	LDA.b Scrap0C ; load value
	--
	CMP.w <value> : !BLT ++
		!SUB.w <value>
		INC.b Scrap0A
		BRA --
	++
	STA.b Scrap0C ; save value
	CPY.b #$FF : BNE +
		LDY.b <offset>
		LDA.b Scrap0E : !ADD.w .digit_offsets, Y : STA.b Scrap0E
	+
	LDA.b Scrap0E : STA.l BigRAM, X : INX : INX
	LDA.w #56 : STA.l BigRAM, X : INX : INX
	LDY.b Scrap0A : TYA : ASL : TAY : LDA.w .digit_properties, Y : STA.l BigRAM, X : INX : INX
	LDA.w #$0000 : STA.l BigRAM, X : INX : INX
	
	LDA.b Scrap0E : !ADD.w #$0008 : STA.b Scrap0E ; move offset 8px right
endmacro
;--------------------------------------------------------------------------------
DrawPrice:
	PHX : PHY : PHP
		LDY.b #$FF
		LDX.b #$00 ; clear bigram pointer

		LDA.b Scrap0C : CMP.w #1000 : !BLT + : JMP .len4 : +
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
		TXA : LSR #3 : STA.b Scrap06 ; request 1-4 OAM slots
		ASL #2
			PHA
				LDA.b LinkPosX : CMP.l ShopPriceColumn : !BLT .off
                                        CMP.l ShopPriceColumn+1 : !BGE .off
				.on
				PLA : JSL.l OAM_AllocateFromRegionB : BRA + ; request 4-16 bytes
				.off
				PLA : JSL.l OAM_AllocateFromRegionA ; request 4-16 bytes
			+
		TXA : LSR #3
	PLP : PLY : PLX
RTS
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
	LDX.w #$0000
	-
		LDA.l ShopTable+1, X : CMP.b RoomIndex : BNE +
		LDA.l ShopTable+5, X : AND.w #$0040 : BNE ++
			LDA.l PreviousOverworldDoor : AND.w #$00FF : CMP.l ShopTable+3, X : BNE +
		++
			SEP #$20 ; set 8-bit accumulator
			LDA.l ShopTable, X : STA.l ShopId
			LDA.l ShopTable+5, X : STA.l ShopType
			AND.b #$03 : ASL #2 : STA.l ShopCapacity
			LDA.l ShopTable+6, X : STA.l ShopMerchant
			LDA.l ShopTable+7, X : STA.l ShopSRAMIndex
			BRA .success
		+
		LDA.l ShopTable, X : AND.w #$00FF : CMP.w #$00FF : BEQ .fail
		INX #8
	BRA -
	
	.fail
	SEP #$20 ; set 8-bit accumulator
	LDA.b #$FF : STA.l ShopType ; $FF = error condition
	JMP .done
	
	.success
	SEP #$20 ; set 8-bit accumulator
	
	LDX.w #$0000
	LDY.w #$0000
	-
		TYA : CMP.l ShopCapacity : !BLT ++ : JMP .done : ++
		LDA.l ShopContentsTable+1, X : CMP.b #$FF : BNE ++ : JMP .done : ++
		
		LDA.l ShopContentsTable, X : CMP.l ShopId : BEQ ++ : JMP .next : ++
			LDA.l ShopContentsTable+1, X : PHX : TYX : STA.l ShopInventory, X : PLX
			LDA.l ShopContentsTable+2, X : PHX : TYX : STA.l ShopInventory+1, X : PLX
			LDA.l ShopContentsTable+3, X : PHX : TYX : STA.l ShopInventory+2, X : PLX
			
			PHY
				PHX
					LDA.b #$00 : XBA : TYA : LSR #2 : !ADD ShopSRAMIndex : TAX
					LDA.l PurchaseCounts, X : TYX : STA.l ShopInventory+3, X : TAY
				PLX
				
				LDA.l ShopContentsTable+4, X : BEQ ++
				TYA : CMP.l ShopContentsTable+4, X : !BLT ++
					PLY
					LDA.l ShopContentsTable+5, X : PHX : TYX : STA.l ShopInventory, X : PLX
					LDA.l ShopContentsTable+6, X : PHX : TYX : STA.l ShopInventory+1, X : PLX
					LDA.l ShopContentsTable+7, X : PHX : TYX : STA.l ShopInventory+2, X : PLX
					BRA +++
				++
			PLY : +++
			
                        PHX : PHY
                        PHX : TYX : LDA.l ShopInventory, X : PLX
                        SEP #$10
                        JSL.l AttemptItemSubstitution
                        JSL.l ResolveLootIDLong
                        TAY
                        REP #$30
                        LDA.b 1,s : TAX : LDA.l .tile_offsets, X : TAX
                        JSR.w SetupTileTransfer
                        PLY : PLX
                        INY #4
		.next
		INX #8
	JMP -

	.done
        SEP #$20
	LDA.l ShopType : BIT.b #$20 : BEQ .notTakeAll ; Take-all
	.takeAll

		LDA.b #$00 : XBA : LDA.l ShopSRAMIndex : TAX
		LDA.l PurchaseCounts, X
		BRA ++
	.notTakeAll
		LDA.b #$00
	++
	STA.l ShopState

    ; If the item is $FF, make it not show (as if already taken)
	LDA.l ShopInventory : CMP.b #$FF : BNE +
		LDA.l ShopState : ORA.l Shopkeeper_ItemMasks : STA.l ShopState
	+
	LDA.l ShopInventory+4 : CMP.b #$FF : BNE +
		LDA.l ShopState : ORA.l Shopkeeper_ItemMasks+1 : STA.l ShopState
	+
	LDA.l ShopInventory+8 : CMP.b #$FF : BNE +
		LDA.l ShopState : ORA.l Shopkeeper_ItemMasks+2 : STA.l ShopState
	+

	PLP : PLY : PLX
	
	LDA.l ShopType : CMP.b #$FF : BNE +
		PLA : PLA : PLA
        INC.w SpriteAncillaInteract, X
        LDA.w SpriteOAMProperties, X
		JML.l ShopkeeperFinishInit
	+
RTL
.tile_offsets
dw $0000, $0000
dw $0080, $0000
dw $0100, $0000
;--------------------------------------------------------------------------------
; X - Tile Buffer Offset
; Y - Item ID
SetupTileTransfer:
        LDA.l ShopType : BIT.w #$0010 : BNE .alt_vram
	        TXA : LSR #2
                CLC : ADC.w #!FREE_TILE
                BRA .store_target
        .alt_vram
	TXA : LSR #2
        CLC : ADC.w #!FREE_TILE_ALT
        .store_target
        LDX.w ItemStackPtr
        STA.l ItemTargetStack,X

	TYA : ASL : TAX
        LDA.l StandingItemGraphicsOffsets,X
        LDX.w ItemStackPtr
        STA.l ItemGFXStack,X

        TXA
        INC #2
        STA.l ItemStackPtr

        LDA.w #$0000
	REP #$10 ; set 16-bit index registers
        SEP #$20
RTS
;--------------------------------------------------------------------------------
;ShopInventory, X
;[id][$lo][$hi][purchase_counter]
;--------------------------------------------------------------------------------
Shopkepeer_CallOriginal:
	PLA : PLA : PLA
	LDA.b #ShopkeeperJumpTable>>16 : PHA
	LDA.b #ShopkeeperJumpTable>>8 : PHA
	LDA.b #ShopkeeperJumpTable : PHA
    LDA.w SpriteItemType, X
    JML.l JumpTableLocal
;--------------------------------------------------------------------------------
Sprite_ShopKeeper:

	LDA.l ShopType : CMP.b #$FF : BNE + : JMP.w Shopkepeer_CallOriginal : +

	PHB : PHK : PLB
		JSL.l Sprite_PlayerCantPassThrough

		; Draw Shopkeeper
		JSR.w Shopkeeper_DrawMerchant

		LDA.l ShopType : BIT.b #$80 : BEQ .normal ; Take-any
			BIT.b #$20 : BNE .normal ; Not A Take-All
			PHX
				LDA.l ShopSRAMIndex : TAX
				LDA.l PurchaseCounts, X : BEQ ++ : PLX : BRA .done : ++
			PLX
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
	LDA.b FrameCounter : AND.b <speed> : BEQ +
		-
			LDA.w .oam_shopkeeper_f1, X : STA.l BigRAM, X : INX
		CPX.b #$10 : !BLT -
	+
		-
			LDA.w .oam_shopkeeper_f2, X : STA.l BigRAM, X : INX
		CPX.b #$10 : !BLT -
	++
	PLX

	LDA.l ShopMerchant : LSR #4 : AND.b #$0E : ORA.l BigRAM+5 : STA.l BigRAM+5
	LDA.l ShopMerchant : LSR #4 : AND.b #$0E : ORA.l BigRAM+13 : STA.l BigRAM+13

	PHB
		LDA.b #$02 : STA.b Scrap06 ; request 2 OAM slots
		LDA.b #$08 : JSL.l OAM_AllocateFromRegionA ; request 8 bytes
		STZ.b Scrap07

		LDA.b #BigRAM : STA.b Scrap08
		LDA.b #BigRAM>>8 : STA.b Scrap09
		LDA.b #$7E : PHA : PLB ; set data bank to $7E
		JSL.l Sprite_DrawMultiple_quantity_preset
		LDA.b OAMPtr : !ADD.b #$04*2 : STA.b OAMPtr ; increment oam pointer
		LDA.b OAMPtr+2 : INC #2 : STA.b OAMPtr+2
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
	LDA.l ShopMerchant : AND.b #$07
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
	LDA.b #$01 : STA.b Scrap06 ; request 1 OAM slot
	LDA.b #$04 : JSL.l OAM_AllocateFromRegionA ; request 4 bytes
	STZ.b Scrap07
	LDA.b FrameCounter : AND #$08 : BEQ +
		LDA.b #.oam_shopkeeper_f1 : STA.b Scrap08
		LDA.b #.oam_shopkeeper_f1>>8 : STA.b Scrap09
		BRA ++
	+
		LDA.b #.oam_shopkeeper_f2 : STA.b Scrap08
		LDA.b #.oam_shopkeeper_f2>>8 : STA.b Scrap09
	++
	JSL.l Sprite_DrawMultiple_quantity_preset
	LDA.b OAMPtr : !ADD.b #$04 : STA.b OAMPtr ; increment oam pointer
	LDA.b OAMPtr+2 : INC : STA.b OAMPtr+2
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
			LDA.l ShopState : AND.w Shopkeeper_ItemMasks, Y : BEQ +
				PLY : BRA .no_interaction
			+
		PLY
		LDA.b LinkLayer : CMP.w SpriteLayer, X : BNE .no_interaction  

		JSR.w Setup_LinksHitbox
		JSR.w Setup_ShopItemCollisionHitbox
		JSL.l Utility_CheckIfHitBoxesOverlapLong
		BCC .no_contact
		    JSR.w Sprite_HaltSpecialPlayerMovementCopied
		.no_contact

		JSR.w Setup_ShopItemInteractionHitbox
		JSL.l Utility_CheckIfHitBoxesOverlapLong : BCC .no_interaction
		    LDA.b Joy1B_New : AND.b #$80 : BEQ .no_interaction ; check for A-press
			LDA.b GameMode : CMP.b #$0C : !BGE .no_interaction ; don't interact in other modes besides game action
			JSR.w Shopkeeper_BuyItem
		.no_interaction
		INY #4
	TYA : CMP.l ShopCapacity : !BLT -
	;CPY.b #$0C : !BLT -
	
	PLP : PLY : PLX
RTS

Shopkeeper_BuyItem:
        PHX : PHY
        TYX

        LDA.l ShopInventory, X
        CMP.b #$0E : BEQ .refill ; Bee Refill
        CMP.b #$2E : BEQ .refill ; Red Potion Refill
        CMP.b #$2F : BEQ .refill ; Green Potion Refill
        CMP.b #$30 : BEQ .refill ; Blue Potion Refill
                BRA +
        .refill
        JSL.l Sprite_GetEmptyBottleIndex : BMI .full_bottles
	        +

                LDA.l ShopType : AND.b #$80 : BNE .buy ; don't charge if this is a take-any
                        REP #$20 : LDA.l CurrentRupees : CMP.l ShopInventory+1, X : SEP #$20 : !BGE .buy

                .cant_afford
                LDA.b #$7A
                LDY.b #$01
                JSL.l Sprite_ShowMessageUnconditional
                LDA.b #$3C : STA.w SFX2 ; error sound
                JMP .done
        .full_bottles
        LDA.b #$6B : LDY.b #$01
        JSL.l Sprite_ShowMessageUnconditional
        LDA.b #$3C : STA.w SFX2 ; error sound
        JMP .done
        .buy
        LDA.l ShopType : AND.b #$80 : BNE ++ ; don't charge if this is a take-any
                REP #$20 : LDA.l CurrentRupees : !SUB ShopInventory+1, X : STA.l CurrentRupees : SEP #$20 ; Take price away
        ++
        INC.w ShopPurchaseFlag
        LDA.l ShopInventory, X : TAY : JSL.l Link_ReceiveItem
        LDA.l ShopInventory+3, X : INC : STA.l ShopInventory+3, X

        TXA : LSR #2 : TAX
        LDA.l ShopType : BIT.b #$80 : BNE +
                LDA.l ShopState : ORA.w Shopkeeper_ItemMasks, X : STA.l ShopState
                PHX
                TXA : !ADD ShopSRAMIndex : TAX
                LDA.l PurchaseCounts, X : INC : BEQ +++ : STA.l PurchaseCounts, X : +++
                PLX
                BRA ++
        + ; Take-any
        BIT.b #$20 : BNE .takeAll
                .takeAny
                LDA.l ShopState : ORA.b #$07 : STA.l ShopState
                PHX : LDA.l ShopSRAMIndex : TAX : LDA.b #$01 : STA.l PurchaseCounts, X : PLX
                BRA ++
                .takeAll
                LDA.l ShopState : ORA.w Shopkeeper_ItemMasks, X : STA.l ShopState
                PHX : LDA.l ShopSRAMIndex : TAX : LDA.l ShopState : STA.l PurchaseCounts, X : PLX
	++
	.done
	PLY : PLX
RTS
Shopkeeper_ItemMasks:
db #$01, #$02, #$04
;--------------------
Setup_ShopItemCollisionHitbox:
;The complications with XBA are to handle the fact that nintendo likes to store
;high and low bytes of 16 bit postion values seperately :-(

        REP #$20 ; set 16-bit accumulator
        LDA.b Scrap00 : PHA
        SEP #$20 ; set 8-bit accumulator

        ; load shopkeeper X (16 bit)
        LDA.w SpritePosXHigh, X : XBA : LDA.w SpritePosXLow, X

        REP #$20 ; set 16-bit accumulator
        PHA : PHY
        LDA.l ShopType : AND.w #$0003 : DEC : ASL : TAY
        LDA.w Shopkeeper_DrawNextItem_item_offsets_idx, Y : STA.b Scrap00 ; get table from the table table
        PLY : PLA
    
        !ADD ($00), Y
        !ADD.w #$0002 ; a small negative margin
        ; TODO: add 4 for a narrow item
        SEP #$20 ; set 8-bit accumulator

        ; store hitbox X 
        STA.b Scrap04 : XBA : STA.b Scrap0A 

        ;load shopkeeper Y (16 bit)
        LDA.w SpritePosYHigh, X : XBA : LDA.w SpritePosYLow, X 

        REP #$20 ; set 16-bit accumulator
        PHY : INY #2
        !ADD ($00), Y
        PLY
        PHA : LDA.l ShopType : AND.w #$0080 : BEQ + ; lower by 4 for Take-any
                PLA : !ADD.w #$0004
                BRA ++
        + : PLA : ++
        SEP #$20 ; set 8-bit accumulator

        ; store hitbox Y Low: $05, High $0B
        STA.b Scrap05 : XBA : STA.b Scrap0B 

        LDA.b #12 : STA.b Scrap06 ; Hitbox width, always 12 for existing (wide) shop items
        ; TODO: for narrow sprite store make width 4 (i.e. 8 pixels smaller)

        LDA.b #14 : STA.b Scrap07 ; Hitbox height, always 14

        REP #$20 ; set 16-bit accumulator
        PLA : STA.b Scrap00
        SEP #$20 ; set 8-bit acc
RTS
;--------------------------------------------------------------------------------
; Adjusts the already set up collision hitbox to be a suitable interaction hitbox
Setup_ShopItemInteractionHitbox:
        PHP
        SEP #$20 ; set 8-bit accumulator

        ; collision hitbox has left margin of -2, we want margin of 8 so we subtract 10
        LDA.b Scrap04 : !SUB.b #$0A : STA.b Scrap04
        LDA.b Scrap0A : SBC.b #$00 : STA.b Scrap0A ; Apply borrow

        ; collision hitbox has 0 top margin, we want a margin of 8 so we subtract 8
        LDA.b Scrap05 : !SUB.b #$08 : STA.b Scrap05
        LDA.b Scrap0B : SBC.b #$00 : STA.b Scrap0B ; Apply borrow  

        ; We want a width of 32 for wide or 24 for narrow, so we add 20
        LDA.b Scrap06 : !ADD.b #20 : STA.b Scrap06 ; Hitbox width

        LDA.b #40 : STA.b Scrap07 ; Hitbox height, always 40
        PLP
RTS
;--------------------------------------------------------------------------------
; Following is a copy of procedure $3770A (Bank06.asm Line 6273) 
; because there is no long version available
Setup_LinksHitbox:
	LDA.b #$08 : STA.b Scrap02
                     STA.b Scrap03

        LDA.b LinkPosX : !ADD.b #$04 : STA.b Scrap00
        LDA.b LinkPosX+1 : ADC.b #$00 : STA.b Scrap08

        LDA.b LinkPosY : ADC.b #$08 : STA.b Scrap01
        LDA.b LinkPosY+1 : ADC.b #$00 : STA.b Scrap09
RTS
;--------------------------------------------------------------------------------
; The following is a copy of procedure Sprite_HaltSpecialPlayerMovement (Bank1E.asm line 255)
; because there is no long version available
Sprite_HaltSpecialPlayerMovementCopied:
        PHX      
        JSL Sprite_NullifyHookshotDrag
        STZ.b LinkSpeed ; Set Link's speed to zero...
        JSL Player_HaltDashAttackLong
        PLX
RTS
;--------------------------------------------------------------------------------
Shopkeeper_DrawItems:
	PHB : PHK : PLB
	PHX : PHY
	TXA : STA.l ShopScratch;

	LDX.b #$00
	LDY.b #$00
	LDA.l ShopType : AND.b #$03
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
	LDA.l ShopState : AND.w Shopkeeper_ItemMasks, Y : BEQ + : JMP .next : +

	PHY

	LDA.l ShopType : AND.b #$03 : DEC : ASL : TAY
	REP #$20 ; set 16-bit accumulator
	LDA.w .item_offsets_idx, Y : STA.b Scrap00 ; get table from the table table
	LDA.b 1,s : ASL #2 : TAY ; set Y to the item index
	LDA.b ($00), Y : STA.l SpriteOAM ; load X-coordinate
	INY #2
	LDA.l ShopType : AND.w #$0080 : BNE +
		LDA.b ($00), Y : STA.l SpriteOAM+2 : BRA ++ ; load Y-coordinate
	+
		LDA.b ($00), Y : !ADD.w #$0004 : STA.l SpriteOAM+2 ; load Y-coordinate
	++
	SEP #$20 ; set 8-bit accumulator
	PLY

	LDA.l ShopInventory, X ; get item id
        JSL.l AttemptItemSubstitution
        JSL.l ResolveLootIDLong
        STA.b Scrap0D
	CMP.b #$2E : BNE + : BRA .potion
	+ CMP.b #$2F : BNE + : BRA .potion
	+ CMP.b #$30 : BEQ .potion
	.normal
		LDA.w .tile_indices, Y : BRA + ; get item gfx index
	.potion
		LDA.b #$C0 ; potion is #$C0 because it's already there in VRAM
	+
	XBA

	LDA.l ShopType : AND.b #$10 : BEQ +
		XBA : !SUB #$22 : XBA ; alt vram
	+
	XBA

	STA.l SpriteOAM+4

	LDA.b Scrap0D
        PHX
	JSL.l GetSpritePalette_resolved : STA.l SpriteOAM+5
        PLX

	LDA.b #$00 : STA.l SpriteOAM+6

	LDA.b Scrap0D
        PHX
        TAX
        LDA.l SpriteProperties_standing_width,X : BEQ .narrow
	.full
                PLX
		LDA.b #$02
		STA.l SpriteOAM+7
		LDA.b #$01
		BRA ++
	.narrow
                PLX
		LDA.b #$00
		STA.l SpriteOAM+7
		JSR.w PrepNarrowLower
		LDA.b #$02
	++
	PHX : PHA : LDA.l ShopScratch : TAX : PLA : JSR.w RequestItemOAM : PLX

	LDA.l ShopType : AND.b #$80 : BNE +
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
Shopkeeper_DrawNextPrice:
        PHB : PHK : PLB
        PHX : PHY : PHP

        REP #$20 ; set 16-bit accumulator
        PHY
        LDA.l ShopType : AND.w #$0003 : DEC : ASL : TAY
        LDA.w Shopkeeper_DrawNextItem_item_offsets_idx, Y : STA.b Scrap00 ; get table from the table table
        LDA.w .price_columns_idx, Y : STA.b Scrap02 ; get table from the table table
        PLY : PHY
        TYA : ASL #2 : TAY
        LDA.b ($00), Y : STA.b Scrap0E ; set coordinate
        TYA : LSR : TAY
        LDA.b ($02), Y : STA.l ShopPriceColumn
        INY : LDA.b ($02), Y : STA.l ShopPriceColumn+1
        PLY
        LDA.l ShopInventory+1, X : STA.b Scrap0C ; set value

        BEQ .free
                JSR.w DrawPrice
                SEP #$20 : STA.b Scrap06 : STZ.b Scrap07 ; set 8-bit accumulator & store result
                PHA
                LDA.b #BigRAM : STA.b Scrap08
                LDA.b #BigRAM>>8 : STA.b Scrap09
                LDA.b #$7E : PHA : PLB ; set data bank to $7E

		PHX : PHA : LDA.l ShopScratch : TAX : PLA : JSL.l Sprite_DrawMultiple_quantity_preset : PLX

		LDA.b 1,s
		ASL #2 : !ADD OAMPtr : STA.b OAMPtr ; increment oam pointer
                PLA
                !ADD OAMPtr+2 : STA.b OAMPtr+2
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
                STA.b Scrap06 ; request A OAM slots
                LDA.b LinkPosY : CMP.b #$62 : !BGE .below
                        .above
                        LDA.b 1,s : ASL #2 : JSL.l OAM_AllocateFromRegionA ; request 4A bytes
                        BRA +
                        .below
                        LDA.b 1,s : ASL #2 : JSL.l OAM_AllocateFromRegionB ; request 4A bytes
                +
                LDA.b 1,s  : STA.b Scrap06 ; request 3 OAM slots
                STZ.b Scrap07
                LDA.b #SpriteOAM : STA.b Scrap08
                LDA.b #SpriteOAM>>8 : STA.b Scrap09
                LDA.b #$7E : PHB : PHA : PLB
                JSL Sprite_DrawMultiple_quantity_preset
                PLB
                LDA.b 1,s : ASL #2 : !ADD.b OAMPtr : STA.b OAMPtr ; increment oam pointer
                LDA.b OAMPtr+2 : !ADD 1,s : STA.b OAMPtr+2
	PLA : PLY : PLX
RTS
;--------------------------------------------------------------------------------
PrepNarrowLower:
	PHX
	LDX.b #$00
		REP #$20 ; set 16-bit accumulator
		LDA.l SpriteOAM, X : !ADD.w #$0004 : STA.l SpriteOAM, X : STA.l SpriteOAM+8, X
		LDA.l SpriteOAM+2, X : !ADD.w #$0008 : STA.l SpriteOAM+10, X
		LDA.l SpriteOAM+4, X : !ADD.w #$0010 : STA.l SpriteOAM+12, X
		LDA.l SpriteOAM+6, X : STA.l SpriteOAM+14, X
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
