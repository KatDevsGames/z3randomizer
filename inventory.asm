;================================================================================
; Inventory Updates
;================================================================================
;--------------------------------------------------------------------------------
; ProcessMenuButtons:
; out:	Carry - 0 = No Button, 1 = Yes Button
;--------------------------------------------------------------------------------
ProcessMenuButtons:
	LDA.b Joy1A_New : BIT.b #$40 : BNE .y_pressed ; check for P1 Y-button
			  BIT.b #$20 : BNE .sel_pressed ; check for P1 Select button
	LDA.b Joy1A_All : BIT.b #$20 : BNE .sel_held
	.sel_unheld
		LDA.l HudFlag : AND.b #$60 : BEQ +
		LDA.b #$00 : STA.l HudFlag
                JSL.l MaybePlaySelectSFX
		+
		JSL.l ResetEquipment
	+
	.sel_held
	CLC ; no buttons
RTL
	.sel_pressed
        LDA.l HUDDungeonItems : BIT.b #$0C : BNE +
	        LDA.b #$40
                BRA .store_flag
        +
	LDA.b #$60
        .store_flag
        STA.l HudFlag
        JSL.l MaybePlaySelectSFX
	JSL.l ResetEquipment
RTL
	.y_pressed ; Note: used as entry point by quickswap code. Must preserve X. 
	LDA.b #$10 : STA.w MenuBlink
	LDA.w ItemCursor ; check selected item
	CMP.b #$02 : BNE + ; boomerang
		LDA.l InventoryTracking : AND.b #$C0 : CMP.b #$C0 : BNE .errorJump ; make sure we have both boomerangs
		LDA.l BoomerangEquipment : EOR.b #$03 : STA.l BoomerangEquipment ; swap blue & red boomerang
		LDA.b #$20 : STA.w SFX3 ; menu select sound
		JMP .captured
	+ CMP.b #$01 : BNE + ; bow
		LDA.l BowTracking : AND.b #$C0 : CMP.b #$C0 : BNE .errorJump ; make sure we have both bows
		PHX : LDX.b #$00 ; scan ancilla table for arrows
			-- : CPX.b #$0A : !BGE ++
				LDA.w AncillaID, X : CMP.b #$09 : BNE +++
					PLX : BRA .errorJump2 ; found an arrow, don't allow the swap
				+++
			INX : BRA -- : ++
		PLX
		LDA.l SilverArrowsUseRestriction : BEQ ++
		LDA.b RoomIndex : ORA.b RoomIndex+1 : BEQ ++ ; not in ganon's room in restricted mode
				LDA.l BowEquipment : CMP.b #$03 : !BLT .errorJump : !SUB #$02 : STA.l BowEquipment
				BRA .errorJump2
		++
		LDA.l BowEquipment : !SUB #$01 : EOR.b #$02 : !ADD #$01 : STA.l BowEquipment ; swap bows
		LDA.b #$20 : STA.w SFX3 ; menu select sound
		JMP .captured
	+ BRA +
		.errorJump
		BRA .errorJump2
	+ CMP.b #$05 : BNE + ; powder
		LDA.l InventoryTracking : AND.b #$30 : CMP.b #$30 : BNE .errorJump ; make sure we have mushroom & magic powder
		LDA.l PowderEquipment : EOR.b #$03 : STA.l PowderEquipment ; swap mushroom & magic powder
		LDA.b #$20 : STA.w SFX3 ; menu select sound
		JMP .captured
	+ BRA +
		.errorJump2
		BRA .error
	+ CMP.b #$0D : BNE + ; flute
		LDA.w UseY2 : CMP.b #$01 : BEQ .midShovel ; inside a shovel animation, force the shovel & make error sound
		LDA.l InventoryTracking : BIT.b #$04 : BEQ .error ; make sure we have shovel
					  AND.b #$03 : BEQ .error ; make sure we have one of the flutes
		LDA.l FluteEquipment : CMP.b #01 : BNE .toShovel ; not shovel

		LDA.l InventoryTracking : AND.b #$01 : BEQ .toFakeFlute ; check for real flute
		LDA.b #$03 ; set real flute
		BRA .fluteSuccess
		.toFakeFlute
		LDA.b #$02 ; set fake flute
		BRA .fluteSuccess
		.toShovel
		LDA.b #$01 ; set shovel
		.fluteSuccess
		STA.l FluteEquipment ; store set item
		LDA.b #$20 : STA.w SFX3 ; menu select sound
		BRA .captured
	+
	CMP.b #$10 : BNE .error : JSL.l ProcessBottleMenu : BRA .captured : +
	CLC
RTL
	.midShovel
	.error
	LDA.b #$3C : STA.w SFX2 ; error sound
	.captured
	SEC
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;ProcessBottleMenu:
;--------------------------------------------------------------------------------
ProcessBottleMenu:
	LDA.l BottleIndex ; check bottle state
	BEQ .no_bottles ; skip if we have no bottles
	PHX
		INC : CMP.b #$05 : !BLT + : LDA.b #$01 : + ;increment and wrap 1-4
		TAX : LDA.l BottleContents-1, X ; check bottle
		BNE + : LDX.b #$01 : + ; wrap if we reached the last bottle
		TXA : STA.l BottleIndex ; set bottle index
		LDA.b #$20 : STA.w SFX3 ; menu select sound
	PLX
	.no_bottles
	LDA.b #$00 ; pretend like the controller state was 0 from the overridden load
RTL

;--------------------------------------------------------------------------------
;OpenBottleMenu:
;--------------------------------------------------------------------------------
OpenBottleMenu:
	LDA.b Joy1B_New : AND.b #$40 : BEQ .x_not_pressed ; skip if X is not down
		LDA.b #$10 : STA.w MenuBlink ; set 16 frame cool off
	    LDA.b #$20 : STA.w SFX3 ; make menu sound
		LDA.b #$07 : STA.w SubModuleInterface ; thing we wrote over - opens bottle menu
	.x_not_pressed
RTL
;--------------------------------------------------------------------------------
;CloseBottleMenu:
;--------------------------------------------------------------------------------
CloseBottleMenu:
        LDA.b Joy1B_New : AND.b #$40 : BEQ .x_not_pressed ; skip if X is not down
        LDA.b #$10 : STA.w MenuBlink ; set 16 frame cool off
        LDA.b #$20 : STA.w SFX3 ; make menu sound

        INC.w SubModuleInterface ; return to normal menu
        STZ.w BottleMenuCounter
        LDA.b #$00
RTL
        .x_not_pressed
        LDA.b Joy1A_New : AND.b #$0C ; thing we wrote over (probably)
RTL
;--------------------------------------------------------------------------------
; AddInventory:
;--------------------------------------------------------------------------------
AddInventory:
; In: Y - Receipt ID
; Uses $0B-$0D for long absolute addressing
	PHA : PHX : PHY : PHP : PHB
        PHK : PLB
        LDA.b #$7E : STA.b Scrap0D 

	LDA.l StatsLocked : BNE .done
                REP #$30
                TYA : AND.w #$00FF : ASL : TAX
                SEP #$20

                LDA.w InventoryTable_properties,X : BIT.b #$01 : BEQ .done
                JSR.w ShopCheck : BCS .done
                JSR.w DungeonIncrement : BCS .done
                        JSR.w IncrementByOne
                        JSR.w StampItem
                        JSR.w IncrementYAItems
                                REP #$30
                                LDA.l TotalItemCounter : INC : TAY
                                LDA.l BootsEquipment : AND.w #$00FF : BNE +
                                        TYA : STA.l PreBootsLocations
                                +
                                LDA.l MirrorEquipment : AND.w #$00FF : BNE +
                                        TYA : STA.l PreMirrorLocations
                                +
                                LDA.l FluteEquipment : AND.w #$00FF : BNE +
                                        TYA : STA.l PreFluteLocations
                                +
                                TYA
                                STA.l TotalItemCounter
        .done
        SEP #$30
	PLB : PLP : PLY : PLX : PLA
RTL

ShopCheck:
; In: X - Receipt ID << 1
; TODO: If we write all shops, we can use the ShopPurchase flag instead of this
        PHX
        LDA.b IndoorsFlag : BEQ .count
        LDA.w ItemReceiptMethod : CMP.b #$01 : BEQ .count
        LDA.w InventoryTable_properties,X : BIT.b #$02 : BNE .count
                REP #$20
                LDA.b RoomIndex
                CMP.w #274 : BEQ .nocount ; dark world death mountain shop, ornamental shield shop
                CMP.w #271 : BEQ .nocount ; villiage of outcasts shop, lumberjack shop, lake hylia shop, dark world magic shop
                CMP.w #272 : BEQ .nocount ; red shield shop
                CMP.w #284 : BEQ .nocount ; bomb shop
                CMP.w #287 : BEQ .nocount ; kakariko shop
                CMP.w #255 : BEQ .nocount ; light world death mountain shop
                CMP.w #276 : BEQ .nocount ; waterfall fairy
                CMP.w #277 : BEQ .nocount ; upgrade fairy (shop)
                CMP.w #278 : BEQ .nocount ; pyramid fairy
                SEP #$20
        .count
        CLC
        PLX
RTS
        .nocount
        SEP #$21
        PLX
RTS

DungeonIncrement:
; In: X - Receipt ID << 1
        PHX
        LDA.w InventoryTable_properties,X : BIT.b #$40 : BEQ +
                JSL.l CountChestKeyLong
        +
        SEP #$10
	LDA.b IndoorsFlag : BEQ .done
        LDA.w DungeonID : BMI .done
                CMP.l BallNChainDungeon : BNE +
                        CPY.b #$32 : BEQ .ballchain_bigkey
	        +
                CMP.b #$04 : BCS +
                        LDA.l SewersLocations : INC : STA.l SewersLocations : STA.l HCLocations
                        BRA .done
                +
                LSR : TAX
                LDA.l DungeonLocationsChecked, X : INC : STA.l DungeonLocationsChecked, X
	        CPX.b #$0D : BNE +
                        LDA.l BigKeyField : BIT.b #$04 : BNE ++
                                LDA.l PreGTBKLocations : INC : STA.l PreGTBKLocations
                        ++
	        +
        .done
        REP #$11
        PLX
RTS
        .ballchain_bigkey
        REP #$10
        PLX
        SEC
RTS

StampItem:
        REP #$30
        LDA.w InventoryTable_stamp,X : BEQ .skip
                STA.b Scrap0B
                LDA.b [Scrap0B] : BNE .skip
                INC.b Scrap0B : INC.b Scrap0B
                LDA.b [Scrap0B] : BNE .skip
                        LDA.l NMIFrames+2 : STA.b [Scrap0B]
                        DEC.b Scrap0B : DEC.b Scrap0B
                        LDA.l NMIFrames : STA.b [Scrap0B]
        .skip
        SEP #$20
RTS

IncrementYAItems:
        PHX
        LDA.w InventoryTable_properties,X
        BIT.b #$10 : BNE .bomb_check
        BIT.b #$20 : BNE .bow_check
        BIT.b #$04 : BEQ .not_y
                .y_item
                LDA.l YAItemCounter : !ADD #$08 : STA.l YAItemCounter
                BRA .done
        .not_y
        BIT.b #$08 : BEQ .done
                .a_item
                LDA.l YAItemCounter : INC : AND.b #$07 : TAX
                LDA.l YAItemCounter : AND.b #$F8 : STA.l YAItemCounter
                TXA : ORA.l YAItemCounter : STA.l YAItemCounter
        .done
        PLX
RTS
        .bow_check
        LDA.l BowEquipment : BNE +
                BRA .y_item
        .bomb_check
        LDA.l InventoryTracking+1 : BIT.b #$02 : BNE +
                ORA.b #$02 : STA.l InventoryTracking+1
                BRA .y_item
        +
        PLX
RTS

IncrementByOne:
        PHX
        REP #$20
        LDA.w InventoryTable_stat,X : BEQ .skip
                STA.b Scrap0B
                SEP #$21
                LDA.b #$00 : ADC.b [Scrap0B] : STA.b [Scrap0B]
        .skip
        SEP #$20
        PLX
RTS

IncrementBossSword:
        PHX
        LDA.l StatsLocked : BNE .done
        LDA.l SwordEquipment : CMP.b #$FF : BNE +
                BRA .none
        +
        ASL : TAX
        JMP.w (.vectors,X)

        .vectors
        dw .none
        dw .fighter
        dw .master
        dw .tempered
        dw .golden

        .none
        LDA.l SwordlessBossKills : INC : STA.l SwordlessBossKills
        .done
        PLX
        RTL
        .fighter
        LDA.l SwordBossKills
        CLC : ADC.b #$10
        STA.l SwordBossKills
        PLX
        RTL
        .master
        LDA.l SwordBossKills : INC : AND.b #$0F : TAX
        LDA.l SwordBossKills : AND.b #$F0 : STA.l SwordBossKills
        TXA : ORA.l SwordBossKills : STA.l SwordBossKills
        PLX
        RTL
        .tempered
        LDA.l SwordBossKills+1
        CLC : ADC.b #$10
        STA.l SwordBossKills+1
        PLX
        RTL
        .golden
        LDA.l SwordBossKills+1 : INC : AND.b #$0F : TAX
        LDA.l SwordBossKills+1 : AND.b #$F0 : STA.l SwordBossKills+1
        TXA : ORA.l SwordBossKills+1 : STA.l SwordBossKills+1
        PLX
        RTL

;--------------------------------------------------------------------------------
IncrementFinalSword:
        PHX
        REP #$20
        LDA.w RoomIndex : BNE .done
                SEP #$20
                LDA.l SwordEquipment : CMP.b #$FF : BNE +
                        BRA IncrementBossSword_none
                +
                ASL : TAX
                JMP.w (IncrementBossSword_vectors,X)
        .done
        SEP #$20
        PLX
RTL
;--------------------------------------------------------------------------------
Link_ReceiveItem_HUDRefresh:
	LDA.l BombsEquipment : BNE + ; skip if we have bombs
	LDA.l BombCapacity : BEQ + ; skip if we can't have bombs
	LDA.l BombsFiller : BEQ + ; skip if we are filling no bombs
		DEC : STA.l BombsFiller ; decrease bomb fill count
		LDA.b #$01 : STA.l BombsEquipment ; increase actual bomb count
	+

	JSL.l HUD_RefreshIconLong ; thing we wrote over
	LDA.b #$01 : STA.l UpdateHUDFlag
	JSL.l PostItemGet
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; HandleBombAbsorbtion:
;--------------------------------------------------------------------------------
HandleBombAbsorbtion:
	STA.l BombsFiller ; thing we wrote over
	LDA.w CurrentYItem : BNE + ; skip if we already have some item selected
	LDA.l BombCapacity : BEQ + ; skip if we can't have bombs
		LDA.b #$04 : STA.w ItemCursor ; set selected item to bombs
		LDA.b #$01 : STA.w CurrentYItem ; set selected item to bombs
		JSL.l HUD_RebuildLong
		LDA.b #$01 : STA.l UpdateHUDFlag
	+
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; AddYMarker:
;--------------------------------------------------------------------------------
AddYMarker:
	LDA.w ItemCursor : AND.w #$FF ; load item value
	CMP.w #$02 : BNE + ; boomerang
		LDA.l InventoryTracking : AND.w #$C0 : CMP.w #$C0 : BEQ .drawYBubble : BRA .drawNormal
	+ CMP.w #$01 : BNE + ; bow
		LDA.l BowTracking : AND.w #$C0 : CMP.w #$C0 : BEQ .drawYBubble : BRA .drawNormal
	+ CMP.w #$05 : BNE + ; powder
		LDA.l InventoryTracking : AND.w #$30 : CMP.w #$30 : BEQ .drawYBubble : BRA .drawNormal
	+ CMP.w #$0D : BNE + ; flute
		LDA.l InventoryTracking : BIT.w #$04 : BEQ .drawNormal ; make sure we have shovel
					  AND.w #$03 : BNE .drawYBubble ; make sure we have one of the flutes
					  BRA .drawNormal
	+ CMP.w #$10 : BEQ .drawJarMarker

	.drawNormal
	LDA.w #$7C60
	BRA .drawTile

	.drawJarMarker
	LDA.w MenuBlink : AND.w #$0020 : BNE .drawXBubble

	.drawYBubble
	LDA.w #$3D4F
	BRA .drawTile

	.drawXBubble
	JSR MakeCircleBlue
	LDA.w #$2D3E

	.drawTile
	STA.w $FFC4, Y
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; MakeCircleBlue
; this is horrible, make it better
;--------------------------------------------------------------------------------
MakeCircleBlue:
    LDA.w $FFC0, Y : AND.w #$EFFF : STA.w $FFC0, Y
    LDA.w $FFC2, Y : AND.w #$EFFF : STA.w $FFC2, Y
 
    LDA.w $FFFE, Y : AND.w #$EFFF : STA.w $FFFE, Y
    LDA.w $0004, Y : AND.w #$EFFF : STA.w $0004, Y
    
    LDA.w $003E, Y : AND.w #$EFFF : STA.w $003E, Y
    LDA.w $0044, Y : AND.w #$EFFF : STA.w $0044, Y
    
    LDA.w $0080, Y : AND.w #$EFFF : STA.w $0080, Y
    LDA.w $0082, Y : AND.w #$EFFF : STA.w $0082, Y

    LDA.w $FFBE, Y : AND.w #$EFFF : STA.w $FFBE, Y
    LDA.w $FFC4, Y : AND.w #$EFFF : STA.w $FFC4, Y
    LDA.w $0084, Y : AND.w #$EFFF : STA.w $0084, Y
    LDA.w $007E, Y : AND.w #$EFFF : STA.w $007E, Y
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; UpgradeFlute:
;--------------------------------------------------------------------------------
UpgradeFlute:
	LDA.l InventoryTracking : AND.b #$FC : ORA.b #$01 : STA.l InventoryTracking ; switch to the working flute
	LDA.b #$03 : STA.l FluteEquipment ; upgrade primary inventory
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; CheckKeys:
;--------------------------------------------------------------------------------
CheckKeys:
	LDA.l GenericKeys : BEQ + : RTL : +
	LDA.w DungeonID : CMP.b #$FF
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; DrawKeyIcon:
;--------------------------------------------------------------------------------
DrawKeyIcon:
	LDA.b Scrap04 : AND.w #$00FF : CMP.w #$0090 : BNE + : LDA.w #$007F : + : ORA.w #$2400 : STA.l HUDKeyDigits
	LDA.b Scrap05 : AND.w #$00FF : ORA.w #$2400 : STA.l HUDTileMapBuffer+$66
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; LoadKeys:
;--------------------------------------------------------------------------------
LoadKeys:
	LDA.l GenericKeys : BEQ +
		LDA.l CurrentGenericKeys
		RTL
	+
	LDA.l DungeonKeys, X
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; SaveKeys:
;--------------------------------------------------------------------------------
SaveKeys:
        PHA
        LDA.l GenericKeys : BEQ +
                PLA : STA.l CurrentGenericKeys
                RTL
        +
        PLA : STA.l DungeonKeys, X
        CPX.b #$00 : BNE +
                STA.l HyruleCastleKeys ; copy HC to sewers
        +
        CPX.b #$01 : BNE +
                STA.l SewerKeys ; copy sewers to HC
        +
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; ClearOWKeys:
;--------------------------------------------------------------------------------
ClearOWKeys:
	PHA

	JSL.l TurtleRockEntranceFix
	JSL.l FakeWorldFix
	JSL.l FixBunnyOnExitToLightWorld
	LDA.l GenericKeys : BEQ +
		PLA : LDA.l CurrentGenericKeys : STA.l CurrentSmallKeys
		RTL
	+
	PLA : STA.l CurrentSmallKeys
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; PrepItemScreenBigKey:
;--------------------------------------------------------------------------------
PrepItemScreenBigKey:
    STZ.b Scrap02
    STZ.b Scrap03
	REP #$30 ; thing we wrote over - set 16-bit accumulator
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; LoadPowder:
;--------------------------------------------------------------------------------
LoadPowder:
        PHX
	JSL.l Sprite_SpawnDynamically ; thing we wrote over
	%GetPossiblyEncryptedItem(WitchItem, SpriteItemValues)
        JSL.l AttemptItemSubstitution
        JSL.l ResolveLootIDLong
	STA.w SpriteID, Y
        TYX
	JSL.l PrepDynamicTile_loot_resolved
        PLX
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; InitializeBottles:
;--------------------------------------------------------------------------------
InitializeBottles:
	STA.l BottleContents, X ; thing we wrote over
	PHA
		LDA.l BottleIndex : BNE +
			TXA : INC : STA.l BottleIndex ; write bottle index to menu properly
		+
	PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; DrawPowder:
;--------------------------------------------------------------------------------
DrawPowder:
	LDA.w ItemReceiptPose : BNE .defer ; defer if link is buying a potion
	LDA.l RedrawFlag : BEQ +
		; LDA.w SpriteAuxTable, X ; Retrieve stored item type
		JSL.l PrepDynamicTile_loot_resolved
		LDA.b #$00 : STA.l RedrawFlag ; reset redraw flag
		BRA .defer
	+
	LDA.w SpriteID, X ; Retrieve stored item type
	JSL.l DrawDynamicTile
	.defer
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; LoadMushroom:
;--------------------------------------------------------------------------------
LoadMushroom:
	LDA.b #$00 : STA.w SpriteGFXControl, X ; thing we wrote over
	.justGFX

	PHA

	LDA.b #$01 : STA.l RedrawFlag
	LDA.b LinkState : CMP.b #$14 : BEQ .skip ; skip if we're mid-mirror

	LDA.b #$00 : STA.l RedrawFlag
	%GetPossiblyEncryptedItem(MushroomItem, SpriteItemValues)
        JSL.l AttemptItemSubstitution
        JSR.w ResolveLootID
	STA.w SpriteID,X
	JSL.l PrepDynamicTile

	.skip
	PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; DrawMushroom:
;--------------------------------------------------------------------------------
DrawMushroom:
	PHA : PHY
		LDA.l RedrawFlag : BEQ .skipInit ; skip init if already ready
		JSL.l LoadMushroom_justGFX
		BRA .done ; don't draw on the init frame

		.skipInit
		LDA.w SpriteID, X ; Retrieve stored item type
		JSL.l DrawDynamicTile

		.done
	PLY : PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; CollectPowder:
;--------------------------------------------------------------------------------
CollectPowder:
        LDY.w SpriteID, X ; Retrieve stored item type
        BNE +
	        ; if for any reason the item value is 0 reload it, just in case
	        %GetPossiblyEncryptedItem(WitchItem, SpriteItemValues) : TAY
        +
        STZ.w ItemReceiptMethod ; item from NPC
        JSL.l Link_ReceiveItem
        JSL.l ItemSet_Powder
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; RemoveMushroom:
;--------------------------------------------------------------------------------
RemoveMushroom:
	LDA.l InventoryTracking : AND.b #$DF : STA.l InventoryTracking ; remove the mushroom
	AND.b #$10 : BEQ .empty ; check if we have powder
	LDA.b #$02 : STA.l PowderEquipment ; give powder if we have it
RTL
	.empty
	LDA.b #$00 : STA.l PowderEquipment ; clear the inventory slot if we don't have powder
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; DrawMagicHeader:
;--------------------------------------------------------------------------------
DrawMagicHeader:
	LDA.l MagicConsumption : AND.w #$00FF : CMP.w #$0002 : BEQ .quarterMagic
	.halfMagic
    LDA.w #$28F7 : STA.l HUDTileMapBuffer+$04
    LDA.w #$2851 : STA.l HUDTileMapBuffer+$06
    LDA.w #$28FA : STA.l HUDTileMapBuffer+$08
RTL   
	.quarterMagic   
    LDA.w #$28F7 : STA.l HUDTileMapBuffer+$04
    LDA.w #$2800 : STA.l HUDTileMapBuffer+$06
    LDA.w #$2801 : STA.l HUDTileMapBuffer+$08
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; SpawnShovelGamePrizeSFX:
;--------------------------------------------------------------------------------
SpawnShovelGamePrizeSFX:
	STA.l MiniGameTime ; thing we wrote over
	PHA
		LDA.b #$1B : STA.w SFX3 ; play puzzle sound
	PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; SpawnChestGamePrizeSFX:
;--------------------------------------------------------------------------------
SpawnChestGamePrizeSFX:
	CPX.b #$07 : BNE .normal
	LDA.b RoomIndex : CMP.b #$06 : BNE .normal
	.prize
	LDA.b #$1B : STA.w SFX3 : RTL ; play puzzle sound
	.normal
	LDA.b #$0E : STA.w SFX3 ; play chest sound
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; SpawnShovelItem:
;--------------------------------------------------------------------------------
SpawnShovelItem:
	LDA.b #$01 : STA.l RedrawFlag

    LDA.w YButtonOverride : BEQ +
    	JSL DiggingGameGuy_AttemptPrizeSpawn
		JMP .skip
	+

	LDA.w TileActDig : AND.b #$01 : BNE + : JMP .skip : + ; corner dig fix

	PHY : PHP
	PHB : PHK : PLB
		SEP #$30 ; set 8-bit accumulator and index registers

		LDA.b IndoorsFlag : BEQ + : JMP .no_drop : + ; skip if indoors

                LDA.b OverworldIndex : CMP.b #$2A : BEQ .no_drop ; don't drop in the haunted grove
                            CMP.b #$68 : BEQ .no_drop ; don't drop in the digging game area

		JSL GetRandomInt : BIT.b #$03 : BNE .no_drop ; drop with 1/4 chance

		LSR #2 : TAX ; clobber lower 2 bis - we have 64 slots now

		LDA.l ShovelSpawnTable, X ; look up the drop on the table

		;most of this part below is copied from the digging game

		STA.l MiniGameTime
		JSL Sprite_SpawnDynamically

		LDX.b #$00
		LDA.b LinkDirection : CMP.b #$04 : BEQ + : INX : +

		LDA.l .x_speeds, X : STA.w SpriteVelocityX, Y

		LDA.b #$00 : STA.w SpriteVelocityY, Y
		LDA.b #$18 : STA.w SpriteVelocityZ, Y
		LDA.b #$FF : STA.w EnemyStunTimer, Y
		LDA.b #$30 : STA.w SpriteTimerE, Y

		LDA.b LinkPosX : !ADD.l .x_offsets, X
		                        AND.b #$F0 : STA.w SpritePosXLow, Y
		LDA.b LinkPosX+1 : ADC.b #$00               : STA.w SpritePosXHigh, Y

		LDA.b LinkPosY : !ADD.b #$16 : AND.b #$F0 : STA.w SpritePosYLow, Y
		LDA.b LinkPosY+1 : ADC.b #$00               : STA.w SpritePosYHigh, Y

		LDA.b #$00 : STA.w SpriteLayer, Y
		TYX

		LDA.b #$30 : JSL Sound_SetSfx3PanLong

		.no_drop
	PLB
	PLP : PLY
	.skip
RTL

;DATA - Shovel Spawn Information
{

.x_speeds
    db $F0
    db $10

.x_offsets
    db $00
    db $13

}
;--------------------------------------------------------------------------------
MaybePlaySelectSFX:
        LDA.w DungeonID : BMI .not_dungeon
                .play
		LDA.b #$20 : STA.w SFX3 ; menu select sound
                RTL
        .not_dungeon
        LDA.l HUDDungeonItems : BIT.b #$13 : BEQ .dont_play
                                BIT.b #$0C : BEQ .dont_play
                BRA .play
        .dont_play
RTL
