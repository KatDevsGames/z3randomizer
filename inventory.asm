;================================================================================
; Inventory Updates
;================================================================================
; InventoryTracking
; brmpnskf ------oq
; b = blue boomerang   | -
; r = red boomerang    | -
; m = mushroom current | -
; p = magic powder     | -
; n = mushroom past    | -
; s = shovel           | -
; k = fake flute       | o = any bomb acquired from item location
; f = working flute    | q = quickswap locked
;--------------------------------------------------------------------------------
; BowTracking
; Item Tracking Slot #2
; bsp-----
; b = bow
; s = silver arrow bow
; p = 2nd progressive bow
; -
; -
; -
; -
; -
;--------------------------------------------------------------------------------
; ProcessMenuButtons:
; out:	Carry - 0 = No Button, 1 = Yes Button
;--------------------------------------------------------------------------------
ProcessMenuButtons:
	LDA.b Joy1A_New : BIT.b #$40 : BNE .y_pressed ; check for P1 Y-button
			  BIT #$20 : BNE .sel_pressed ; check for P1 Select button
	LDA.b Joy1A_All : BIT.b #$20 : BNE .sel_held
	.sel_unheld
		LDA.l HudFlag : AND.b #$20 : BEQ +
		LDA.l HudFlag : AND.b #$DF : STA.l HudFlag ; select is released, unset hud flag
		LDA.b IndoorsFlag : BEQ + ; skip if outdoors
			LDA.b #$20 : STA.w SFX3 ; menu select sound
		+
		JSL.l ResetEquipment
	+
	.sel_held
	CLC ; no buttons
RTL
	.sel_pressed
	LDA.l HudFlag : ORA.b #$20 : STA.l HudFlag ; set hud flag
	LDA.b #$20 : STA.w SFX3 ; menu select sound
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
;	.y_not_pressed
;	LDA.b Joy1A_New : AND.b #$0C ; thing we wrote over - load controller state
;RTL
;--------------------------------------------------------------------------------

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
macro TopHalf(address)
	LDA.l <address> : !ADD #$10 : STA.l <address>
endmacro

macro BottomHalf(address)
	PHA : PHX
		LDA.l <address> : INC : AND.b #$0F : TAX
		LDA.l <address> : AND.b #$F0 : STA.l <address>
		TXA : ORA.l <address> : STA.l <address>
	PLX : PLA
endmacro
;--------------------------------------------------------------------------------
FullInventoryExternal:
	LDA.l StatsLocked : BEQ + : RTL : +
	PHA : PHX : PHP : JMP AddInventory_incrementCounts
;--------------------------------------------------------------------------------
AddInventory:
	PHA : PHX : PHP
	CPY.b #$0C : BNE + ; Blue Boomerang
		LDA.l InventoryTracking : ORA.b #$80 : STA.l InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$2A : BNE + ; Red Boomerang
		LDA.l InventoryTracking : ORA.b #$40 : STA.l InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$29 : BNE + ; Mushroom
		LDA.l InventoryTracking : ORA.b #$28 : STA.l InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$0D : BNE + ; Magic Powder
		LDA.l InventoryTracking : ORA.b #$10 : STA.l InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$13 : BNE + ; Shovel
		LDA.l InventoryTracking : ORA.b #$04 : STA.l InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$14 : BNE + ; Flute (Inactive)
		LDA.l InventoryTracking : ORA.b #$02 : STA.l InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$4A : BNE + ; Flute (Active)
		LDA.l InventoryTracking : ORA.b #$01 : STA.l InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$0B : BNE + ; Bow
		LDA.l ArrowMode : BNE +++
			LDA.l BowTracking : ORA.b #$80 : STA.l BowTracking
		+++
		JMP .incrementCounts
	+ CPY.b #$3A : BNE + ; Bow & Arrows
		LDA.l BowTracking : ORA.b #$80 : STA.l BowTracking
		JMP .incrementCounts
	+ CPY.b #$3B : BNE + ; Bow & Silver Arrows
		LDA.l BowTracking : ORA.b #$40 : STA.l BowTracking
		LDA.l ArrowMode : BNE +++
			LDA.l BowTracking : ORA.b #$80 : STA.l BowTracking ; activate wood arrows when not in rupee bow
		+++
		JMP .incrementCounts
	+ CPY.b #$43 : BNE + ; Single arrow
		LDA.l ArrowMode : BEQ +++
			LDA.l BowTracking : ORA.b #$80 : STA.l BowTracking ; activate wood arrows in quick-swap
		+++
		JMP .incrementCounts
	+ CPY.b #$58 : BNE + ; Upgrade-Only Silver Arrows
		LDA.l BowTracking : ORA.b #$40 : STA.l BowTracking
	+

	.incrementCounts
	LDA.l StatsLocked : BEQ + : JMP .done : +

	; don't count any of this stuff
	CPY.b #$20 : BNE + : JMP .itemCounts : + ; Crystal
	CPY.b #$26 : BNE + : JMP .itemCounts : + ; Heart Piece Completion Heart
	CPY.b #$2E : BNE + : JMP .itemCounts : + ; Red Potion (Refill)
	CPY.b #$2F : BNE + : JMP .itemCounts : + ; Green Potion (Refill)
	CPY.b #$30 : BNE + : JMP .itemCounts : + ; Blue Potion (Refill)
	CPY.b #$37 : BNE + : JMP .itemCounts : + ; Pendant
	CPY.b #$38 : BNE + : JMP .itemCounts : + ; Pendant
	CPY.b #$39 : BNE + : JMP .itemCounts : + ; Pendant
	
	CPY.b #$04 : !BLT .isSword ; Swords - Skip Shop/Fairy Check for Swords
	CPY.b #$49 : BEQ .isSword
	CPY.b #$50 : BEQ .isSword
	CPY.b #$5E : BEQ .isSword
	BRA +
		.isSword
		JMP .dungeonCounts
	+
	CPY.b #$3B : BNE + : JMP .dungeonCounts : + ; Silver Arrow Bow - Skip Shop/Fairy Check for Silver Arrow Bow

	LDA.b IndoorsFlag : BEQ ++ ; skip shop check if outdoors
	LDA.w ItemReceiptMethod : CMP.b #$01 : BEQ ++ ; skip shop check for chests
		PHP : REP #$20 ; set 16-bit accumulator
			LDA.b RoomIndex
			CMP.w #274 : BNE + : JMP .shop : + ; dark world death mountain shop, ornamental shield shop
			CMP.w #271 : BNE + : JMP .shop : + ; villiage of outcasts shop, lumberjack shop, lake hylia shop, dark world magic shop
			CMP.w #272 : BNE + : JMP .shop : + ; red shield shop
			CMP.w #284 : BNE + : JMP .shop : + ; bomb shop
			;CMP.w #265 : BNE + : JMP .shop : + ; potion shop - commented this out because it's easier to just block potion refills because this one interferes with the powder item being counted
			;CMP.w #271 : BNE + : JMP .shop : + ; lake hylia shop
			CMP.w #287 : BNE + : JMP .shop : + ; kakariko shop
			CMP.w #255 : BNE + : JMP .shop : + ; light world death mountain shop
			CMP.w #276 : BNE + : JMP .shop : + ; waterfall fairy
			CMP.w #277 : BNE + : JMP .shop : + ; upgrade fairy (shop)
			CMP.w #278 : BNE + : JMP .shop : + ; pyramid fairy
		PLP : BRA ++
		.shop
		PLP : JMP .done
	++

	.dungeonCounts
	LDA.b IndoorsFlag : BNE + : JMP .fullItemCounts : +
	SEP #$20 ; Set 8-bit Accumulator

	LDA.w DungeonID ; get dungeon id
        CMP.b #$FF : BEQ .fullItemCounts

        CMP.l BallNChainDungeon : BNE +
		CPY.b #$32 : BNE +
                        JMP .done
	+
        CMP.b #$04 : BCS +
                LDA.l SewersLocations : INC : STA.l SewersLocations
                LDA.l HCLocations : INC : STA.l HCLocations
                BRA .fullItemCounts
        + LSR : TAX : LDA.l DungeonLocationsChecked, X : INC : STA.l DungeonLocationsChecked, X
	++ CPX.b #$0D : BNE +
		LDA.l BigKeyField : AND.b #$04 : BNE ++
			JSR .incrementGTowerPreBigKey
		++
	+
	; == END INDOOR-ONLY SECTION
	.fullItemCounts

	LDA.l BootsEquipment : BNE + ; Check for Boots
		LDA.l PreBootsLocations : INC : STA.l PreBootsLocations ; Increment Pre Boots Counter
	+

	LDA.l MirrorEquipment : BNE + ; Check for Mirror
		LDA.l PreMirrorLocations : INC : STA.l PreMirrorLocations ; Increment Pre Mirror Counter
	+

	LDA.l FluteEquipment : BNE + ; Check for Flute
		LDA.l PreFluteLocations : INC : STA.l PreFluteLocations ; Increment Pre Mirror Counter
	+

        REP #$20
	LDA.l TotalItemCounter : INC : STA.l TotalItemCounter ; Increment Item Total
        SEP #$20

	.itemCounts

	CPY.b #$00 : BNE + ; Fighter's Sword & Fighter's Shield
                LDX.b #$01
		JSR .incrementSword
		JSR .incrementShield
		JMP .done
	+ CPY.b #$01 : BNE + ; Master Sword
                LDX.b #$02
		JSR .incrementSword
		JMP .done
	+ CPY.b #$02 : BNE + ; Tempered Sword
                LDX.b #$03
		JSR .incrementSword
		JMP .done
	+ CPY.b #$03 : BNE + ; Golden Sword
                LDX.b #$04
		JSR .incrementSword
		JMP .done
	+ CPY.b #$04 : BNE + ; Fighter's Shield
                LDX.b #$01
		JSR .incrementShield
		JMP .done
	+ CPY.b #$05 : BNE + ; Red Shield
                LDX.b #$02
		JSR .incrementShield
		JMP .done
	+ CPY.b #$06 : BNE + ; Mirror Shield
                LDX.b #$03
		JSR .incrementShield
		JMP .done
	+ CPY.b #$07 : !BLT + ; Items $07 - $0D
	  CPY.b #$0E : !BGE +
		JSR .incrementY
		JMP .done
	+ CPY.b #$14 : BNE + ; Flute (Inactive) - LEAVE THIS ABOVE THE 0F-16 CONDITION - kkat
		JSR .stampFlute
		JSR .incrementY
		JMP .done
	+ CPY.b #$0F : !BLT + ; Items $0F - $16
	  CPY.b #$17 : !BGE +
		JSR .incrementY
		JMP .done
	+ CPY.b #$17 : BNE + ; Heart Piece
		JSR .incrementHeartPiece
		JMP .done
	+ CPY.b #$18 : !BLT + ; Items $18 - $19
	  CPY.b #$1A : !BGE +
		JSR .incrementY
		JMP .done
	+ CPY.b #$1A : BNE + ; Magic Mirror
		JSR .stampMirror
		JSR .incrementY
		JMP .done
	+ CPY.b #$1D : BNE + ; Book of Mudora - LEAVE THIS ABOVE THE 1B-1F CONDITION - kkat
		JSR .incrementY
		JMP .done
	+ CPY.b #$1B : !BLT + ; Items IndoorsFlag - $1F
	  CPY.b #$20 : !BGE +
		JSR .incrementA
		JMP .done
	+ CPY.b #$20 : BNE + ; Crystal
		JSR .incrementCrystal
                JSR .setDungeonCompletion
		JMP .done
	+ CPY.b #$21 : BNE + ; Bug Net
		JSR .incrementY
		JMP .done
	+ CPY.b #$22 : BNE + ; Blue Mail
                LDX.b #$01
                JSR .incrementMail
	+ CPY.b #$23 : BNE + ; Red Mail
                LDX.b #$02
                JSR .incrementMail
	+ CPY.b #$24 : BNE + ; Small Key
		JSR .incrementKey
		JMP .done
	+ CPY.b #$25 : BNE + ; Compass
                JSL MaybeFlagCompassTotalPickup
		JSR .incrementCompass
		JMP .done
	+ CPY.b #$26 : BNE + ; Liar Heart (Container)
		;JSR .incrementHeartContainer
		JMP .done
	+ CPY.b #$27 : BNE + ; 1 Bomb
		JSR .maybeIncrementBombs
		JMP .done
	+ CPY.b #$28 : BNE + ; 3 Bombs
		JSR .maybeIncrementBombs
		JMP .done
	+ CPY.b #$29 : BNE + ; Mushroom
		JSR .incrementY
		JMP .done
	+ CPY.b #$2A : !BLT + ; Items $2A - $2D
	  CPY.b #$2E : !BGE +
		JSR .incrementY
		JMP .done
	+ CPY.b #$31 : BNE + ; 10 Bombs
		JSR .maybeIncrementBombs
		JMP .done
	+ CPY.b #$32 : BNE + ; Big Key
		JSR .incrementBigKey
		JMP .done
	+ CPY.b #$33 : BNE + ; Map
		JSR .incrementMap
		JMP .done
	+ CPY.b #$37 : !BLT + ; Items $37 - $39 - Pendants
	  CPY.b #$3A : !BGE +
		JSR .incrementPendant
                JSR .setDungeonCompletion
		JMP .done
	+ CPY.b #$3A : !BLT + ; Items $3A - $3B - Bow & Silver Arrows
	  CPY.b #$3C : !BGE +
		JSR .incrementBow
		JMP .done
	+ CPY.b #$3C : BNE + ; Bottle w/Bee
		JSR .incrementY
		JMP .done
	+ CPY.b #$3D : BNE + ; Bottle w/Fairy
		JSR .incrementY
		JMP .done
	+ CPY.b #$3E : !BLT + ; Items $3E - $3F - Heart Containers
	  CPY.b #$40 : !BGE +
		JSR .incrementHeartContainer
		JMP .done
	+ CPY.b #$48 : BNE + ; Bottle w/Gold Bee
		JSR .incrementY
		JMP .done
	+ CPY.b #$49 : BNE + ; Fighter's Sword
                LDX.b #$01
		JSR .incrementSword
		JMP .done
	+ CPY.b #$4A : BNE + ; Flute (Active)
		JSR .stampFlute
		JSR .incrementY
		JMP .done
	+ CPY.b #$4B : BNE + ; Pegasus Boots
		JSR .stampBoots
		JSR .incrementA
		JMP .done
	+ CPY.b #$4C : BNE + ; 50 Bomb Capacity Upgrade
		JSR .incrementCapacity
		JSR .maybeIncrementBombs
		JMP .done
	+ CPY.b #$4D : !BLT + ; Items $4D - $4F - Capacity Upgrades
	  CPY.b #$50 : !BGE +
		JSR .incrementCapacity
		JMP .done
	+ CPY.b #$50 : BNE + ; Master Sword (Safe)
                LDX.b #$02
		JSR .incrementSword
		JMP .done
	+ CPY.b #$51 : BNE + ; 5 Bomb Capacity Upgrade
                LDX.b #$02
		JSR .maybeIncrementBombs
		JMP .done
	+ CPY.b #$52 : BNE + ; 10 Bomb Capacity Upgrade
                LDX.b #$02
		JSR .maybeIncrementBombs
		JMP .done
	+ CPY.b #$51 : !BLT + ; Items $51 - $54 - Capacity Upgrades
	  CPY.b #$55 : !BGE +
		JSR .incrementCapacity
		JMP .done
	+ CPY.b #$58 : BNE + ; Upgrade-Only Silver Arrows
		JSR .incrementBow
		JMP .done
	+ CPY.b #$5E : BNE + ; Progressive Sword
                LDA.l SwordEquipment : INC : TAX
		JSR .incrementSword
		JMP .done
	+ CPY.b #$5F : BNE + ; Progressive Shield
                LDA.l ShieldEquipment : INC : TAX
		JSR .incrementShield
		JMP .done
	+ CPY.b #$60 : BNE + ; Progressive Armor
                LDA.l ArmorEquipment : INC : TAX
		JSR .incrementMail
		JMP .done
	+ CPY.b #$61 : BNE + ; Progressive Lifting Glove
		JSR .incrementA
		JMP .done
	+ CPY.b #$64 : !BLT + ; Items $64 & $65 - Progressive Bow
	  CPY.b #$66 : !BGE +
		JSR .incrementBow
		JMP .done
	+ CPY.b #$70 : !BLT + ; Items $70 - $7F - Free Maps
	  CPY.b #$80 : !BGE +
		JSR .incrementMap
		JMP .done
	+ CPY.b #$80 : !BLT + ; Items $80 - $8F - Free Compasses
	  CPY.b #$90 : !BGE +
                JSL MaybeFlagCompassTotalPickup
		JSR .incrementCompass
		JMP .done
	+ CPY.b #$90 : !BLT + ; Items $90 - $9F - Free Big Keys
	  CPY.b #$A0 : !BGE +
		JSR .incrementBigKey
		JMP .done
	+ CPY.b #$A0 : !BLT + ; Items $A0 - $AF - Free Small Keys
	  CPY.b #$B0 : !BGE +
		JSR .incrementKey
		JMP .done
	+
	.done
	PLP : PLX : PLA
RTL
; WHICH BEE IS BOTTLED?
; MAKE SURE FAIRY FOUNTAINS DON'T FUCK THE COUNTS UP

.stampSword
	REP #$20 ; set 16-bit accumulator
	LDA.l SwordTime : BNE +
	LDA.l SwordTime+2 : BNE +
		LDA.l NMIFrames : STA.l SwordTime
		LDA.l NMIFrames+2 : STA.l SwordTime+2
	+
	SEP #$20 ; set 8-bit accumulator
RTS

.stampBoots
	REP #$20 ; set 16-bit accumulator
	LDA.l BootsTime : BNE +
	LDA.l BootsTime+2 : BNE +
		LDA.l NMIFrames : STA.l BootsTime
		LDA.l NMIFrames+2 : STA.l BootsTime+2
	+
	SEP #$20 ; set 8-bit accumulator
RTS

.stampFlute
	REP #$20 ; set 16-bit accumulator
	LDA.l FluteTime : BNE +
	LDA.l FluteTime+2 : BNE +
		LDA.l NMIFrames : STA.l FluteTime
		LDA.l NMIFrames+2 : STA.l FluteTime+2
	+
	SEP #$20 ; set 8-bit accumulator
RTS

.stampMirror
	REP #$20 ; set 16-bit accumulator
	LDA.l MirrorTime : BNE +
	LDA.l MirrorTime+2 : BNE +
		LDA.l NMIFrames : STA.l MirrorTime
		LDA.l NMIFrames+2 : STA.l MirrorTime+2
	+
	SEP #$20 ; set 8-bit accumulator
RTS

.incrementSword
	JSR .stampSword
        LDA.l HighestSword
        INC : STA.b Scrap04 : CPX.b Scrap04 : !BLT + ; don't increment unless we're getting a better sword
                TXA : STA.l HighestSword
        +
RTS

.incrementShield
        LDA.l HighestShield
        INC : STA.b Scrap04 : CPX.b Scrap04 : !BLT + ; don't increment unless we're getting a better shield
                TXA : STA.l HighestShield
        +
RTS

.incrementBow
        LDA.l BowEquipment : BNE .dontCount ; Don't increment Y item count for extra bows
.incrementY
	LDA.l YAItemCounter : !ADD #$08 : STA.l YAItemCounter
.dontCount
RTS

.incrementA
	LDA.l YAItemCounter : INC : AND.b #$07 : TAX
	LDA.l YAItemCounter : AND.b #$F8 : STA.l YAItemCounter
	TXA : ORA.l YAItemCounter : STA.l YAItemCounter
RTS

.incrementPendant
	LDA.l PendantCounter : INC : STA.l PendantCounter
RTS

.incrementCapacity
	LDA.l CapacityUpgrades : INC : STA.l CapacityUpgrades
RTS

.incrementHeartPiece
	LDA.l HeartPieceCounter : INC : STA.l HeartPieceCounter
RTS

.incrementHeartContainer
	LDA.l HeartContainerCounter : INC : STA.l HeartContainerCounter
RTS

.incrementCrystal
	LDA.l CrystalCounter : INC : STA.l CrystalCounter
RTS

.incrementMail
        LDA.l HighestMail
        INC : STA.b Scrap04 : CPX.b Scrap04 : !BLT +   ; don't increment unless we're getting a better mail
                TXA : STA.l HighestMail
        +
RTS

.incrementKeyLong
	JSR .incrementKey
RTL

.incrementKey
        LDA.l SmallKeyCounter : INC : STA.l SmallKeyCounter
RTS

.incrementCompass
	%BottomHalf(MapsCompasses)
RTS

.incrementBigKey
	%TopHalf(BigKeysBigChests)
RTS

.incrementGTowerPreBigKey
        LDA.l PreGTBKLocations : INC : STA.l PreGTBKLocations
RTS

.maybeIncrementBombs
	LDA.l InventoryTracking+1 : AND.b #$02 : BNE +
		LDA.l InventoryTracking+1 : ORA.b #$02 : STA.l InventoryTracking+1
		JSR .incrementY
	+
RTS

.incrementMap
	%TopHalf(MapsCompasses)
RTS

.incrementBossSwordLong
	JSR .incrementBossSword
RTL

.incrementBossSword
	LDA.l SwordEquipment
	BNE + : -
                LDA.l SwordlessBossKills : INC : STA.l SwordlessBossKills
                RTS
	+ CMP.b #$FF : BEQ -
	+ CMP.b #$01 : BNE +
		%TopHalf(SwordBossKills) : RTS
	+ CMP.b #$02 : BNE +
		%BottomHalf(SwordBossKills) : RTS
	+ CMP.b #$03 : BNE +
		%TopHalf(SwordBossKills+1) : RTS
	+ CMP.b #$04 : BNE +
		%BottomHalf(SwordBossKills+1)
	+
RTS

.setDungeonCompletion
	LDX.w DungeonID : BMI +
		REP #$20  ; 16 bit
		LDA.l DungeonMask, X
		ORA.l DungeonsCompleted : STA.l DungeonsCompleted
		SEP #$20  ; 8 bit
	+
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Link_ReceiveItem_HUDRefresh:
;--------------------------------------------------------------------------------
Link_ReceiveItem_HUDRefresh:
	LDA.l BombsEquipment : BNE + ; skip if we have bombs
	LDA.l BombCapacity : BEQ + ; skip if we can't have bombs
	LDA.l BombsFiller : BEQ + ; skip if we are filling no bombs
		DEC : STA.l BombsFiller ; decrease bomb fill count
		LDA.b #$01 : STA.l BombsEquipment ; increase actual bomb count
	+

	JSL.l HUD_RefreshIconLong ; thing we wrote over
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
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; ClearOWKeys:
;--------------------------------------------------------------------------------
ClearOWKeys:
	PHA

	JSL.l TurtleRockEntranceFix
	JSL.l FakeWorldFix
	JSR.w FixBunnyOnExitToLightWorld
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
	JSL.l Sprite_SpawnDynamically ; thing we wrote over
	%GetPossiblyEncryptedItem(WitchItem, SpriteItemValues)
	STA.w SpriteAuxTable, Y ; Store item type
	JSL.l PrepDynamicTile
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
		LDA.w SpriteAuxTable, X ; Retrieve stored item type
		JSL.l PrepDynamicTile
		LDA.b #$00 : STA.l RedrawFlag ; reset redraw flag
		BRA .defer
	+
	LDA.w SpriteAuxTable, X ; Retrieve stored item type
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
	STA.w SpriteItemType, X ; Store item type
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
		LDA.w SpriteItemType, X ; Retrieve stored item type
		JSL.l DrawDynamicTile

		.done
	PLY : PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; CollectPowder:
;--------------------------------------------------------------------------------
CollectPowder:
	LDY.w SpriteAuxTable, X ; Retrieve stored item type
	BNE +
		; if for any reason the item value is 0 reload it, just in case
		%GetPossiblyEncryptedItem(WitchItem, SpriteItemValues) : TAY
	+
    STZ.w ItemReceiptMethod ; item from NPC
    JSL.l Link_ReceiveItem
	;JSL.l FullInventoryExternal
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
