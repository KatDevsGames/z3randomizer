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
	;LDA #$FD : STA InventoryTracking ; DEBUG MODE
	;LDA $F6 : BIT #$20 : BNE .l_pressed ; check for P1 L-button
	LDA $F4 : BIT #$40 : BNE .y_pressed ; check for P1 Y-button
			  BIT #$20 : BNE .sel_pressed ; check for P1 Select button
	LDA $F0 : BIT #$20 : BNE .sel_held
	.sel_unheld
		LDA HudFlag : AND #$20 : BEQ +
		LDA HudFlag : AND #$DF : STA HudFlag ; select is released, unset hud flag
		LDA $1B : BEQ + ; skip if outdoors
			LDA.b #$20 : STA $012F ; menu select sound
		+
		JSL.l ResetEquipment
	+
	.sel_held
	CLC ; no buttons
RTL
	.sel_pressed
	LDA HudFlag : ORA #$20 : STA HudFlag ; set hud flag
	LDA.b #$20 : STA $012F ; menu select sound
	JSL.l ResetEquipment
RTL
	.y_pressed ; Note: used as entry point by quickswap code. Must preserve X. 
	LDA.b #$10 : STA $0207
	LDA $0202 ; check selected item
	CMP #$02 : BNE + ; boomerang
		LDA InventoryTracking : AND #$C0 : CMP #$C0 : BNE .errorJump ; make sure we have both boomerangs
		LDA BoomerangEquipment : EOR #$03 : STA BoomerangEquipment ; swap blue & red boomerang
		LDA.b #$20 : STA $012F ; menu select sound
		JMP .captured
	+ CMP #$01 : BNE + ; bow
		LDA BowTracking : AND #$C0 : CMP #$C0 : BNE .errorJump ; make sure we have both bows
		PHX : LDX.b #$00 ; scan ancilla table for arrows
			-- : CPX.b #$0A : !BGE ++
				LDA $0C4A, X : CMP.b #$09 : BNE +++
					PLX : BRA .errorJump2 ; found an arrow, don't allow the swap
				+++
			INX : BRA -- : ++
		PLX
		LDA.l SilverArrowsUseRestriction : BEQ ++
		LDA $A0 : ORA $A1 : BEQ ++ ; not in ganon's room in restricted mode
				LDA BowEquipment : CMP.b #$03 : !BLT .errorJump : !SUB #$02 : STA BowEquipment
				BRA .errorJump2
		++
		LDA BowEquipment : !SUB #$01 : EOR #$02 : !ADD #$01 : STA BowEquipment ; swap bows
		LDA.b #$20 : STA $012F ; menu select sound
		JMP .captured
	+ BRA +
		.errorJump
		BRA .errorJump2
	+ CMP #$05 : BNE + ; powder
		LDA InventoryTracking : AND #$30 : CMP #$30 : BNE .errorJump ; make sure we have mushroom & magic powder
		LDA PowderEquipment : EOR #$03 : STA PowderEquipment ; swap mushroom & magic powder
		LDA.b #$20 : STA $012F ; menu select sound
		JMP .captured
	+ BRA +
		.errorJump2
		BRA .error
	+ CMP #$0D : BNE + ; flute
		LDA $037A :	CMP #$01 : BEQ .midShovel ; inside a shovel animation, force the shovel & make error sound
		LDA InventoryTracking : BIT #$04 : BEQ .error ; make sure we have shovel
					  AND #$03 : BEQ .error ; make sure we have one of the flutes
		LDA FluteEquipment : CMP #01 : BNE .toShovel ; not shovel

		LDA InventoryTracking : AND #$01 : BEQ .toFakeFlute ; check for real flute
		LDA #$03 ; set real flute
		BRA .fluteSuccess
		.toFakeFlute
		LDA #$02 ; set fake flute
		BRA .fluteSuccess
		.toShovel
		LDA #$01 ; set shovel
		.fluteSuccess
		STA FluteEquipment ; store set item
		LDA.b #$20 : STA $012F ; menu select sound
		BRA .captured
	+
	CMP #$10 : BNE .error : JSL.l ProcessBottleMenu : BRA .captured : +
	CLC
RTL
	.midShovel
	; LDA #$01 : STA FluteEquipment ; set shovel
	.error
	LDA.b #$3C : STA $012E ; error sound
	.captured
	SEC
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;ProcessBottleMenu:
;--------------------------------------------------------------------------------
ProcessBottleMenu:
;	LDA $F6 : AND #$30 : CMP.b #$30 : BEQ .double_shoulder_pressed
;	LDA $F4 : AND #$40 : BEQ .y_not_pressed ; skip if Y is not down
;	.double_shoulder_pressed
	LDA BottleIndex ; check bottle state
	BEQ .no_bottles ; skip if we have no bottles
	PHX
		INC : CMP #$05 : !BLT + : LDA #$01 : + ;increment and wrap 1-4
		TAX : LDA BottleContents-1, X ; check bottle
		BNE + : LDX #$01 : + ; wrap if we reached the last bottle
		TXA : STA BottleIndex ; set bottle index
		LDA.b #$20 : STA $012F ; menu select sound
	PLX
	.no_bottles
	LDA #$00 ; pretend like the controller state was 0 from the overridden load
RTL
;	.y_not_pressed
;	LDA $F4 : AND.b #$0C ; thing we wrote over - load controller state
;RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;OpenBottleMenu:
;--------------------------------------------------------------------------------
OpenBottleMenu:
	LDA $F6 : AND #$40 : BEQ .x_not_pressed ; skip if X is not down
		LDA.b #$10 : STA $0207 ; set 16 frame cool off
	    LDA.b #$20 : STA $012F ; make menu sound
		LDA.b #$07 : STA $0200 ; thing we wrote over - opens bottle menu
	.x_not_pressed
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;CloseBottleMenu:
;--------------------------------------------------------------------------------
CloseBottleMenu:
	LDA $F6 : AND #$40 : BEQ .x_not_pressed ; skip if X is not down

	LDA.b #$10 : STA $0207 ; set 16 frame cool off
    LDA.b #$20 : STA $012F ; make menu sound

	INC $0200 ; return to normal menu
    STZ $0205

	LDA #$00
RTL
	.x_not_pressed
	LDA $F4 : AND.b #$0C ; thing we wrote over (probably)
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; AddInventory:
;--------------------------------------------------------------------------------
macro TopHalf(address)
	LDA <address> : !ADD #$10 : STA <address>
endmacro

macro BottomHalf(address)
	PHA : PHX
		LDA <address> : INC : AND #$0F : TAX
		LDA <address> : AND #$F0 : STA <address>
		TXA : ORA <address> : STA <address>
	PLX : PLA
endmacro
;--------------------------------------------------------------------------------
;FullInventoryExternal:
;	LDA StatsLocked : BEQ + : RTL : +
;	PHA : PHX : PHP : JMP AddInventory_fullItemCounts
;--------------------------------------------------------------------------------
FullInventoryExternal:
	LDA StatsLocked : BEQ + : RTL : +
	PHA : PHX : PHP : JMP AddInventory_incrementCounts
;--------------------------------------------------------------------------------
AddInventory:
	PHA : PHX : PHP
	CPY.b #$0C : BNE + ; Blue Boomerang
		LDA InventoryTracking : ORA #$80 : STA InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$2A : BNE + ; Red Boomerang
		LDA InventoryTracking : ORA #$40 : STA InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$29 : BNE + ; Mushroom
		LDA InventoryTracking : ORA #$28 : STA InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$0D : BNE + ; Magic Powder
		LDA InventoryTracking : ORA #$10 : STA InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$13 : BNE + ; Shovel
		LDA InventoryTracking : ORA #$04 : STA InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$14 : BNE + ; Flute (Inactive)
		LDA InventoryTracking : ORA #$02 : STA InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$4A : BNE + ; Flute (Active)
		LDA InventoryTracking : ORA #$01 : STA InventoryTracking
		JMP .incrementCounts
	+ CPY.b #$0B : BNE + ; Bow
		LDA ArrowMode : BNE +++
			LDA BowTracking : ORA #$80 : STA BowTracking
		+++
		JMP .incrementCounts
	+ CPY.b #$3A : BNE + ; Bow & Arrows
		LDA BowTracking : ORA #$80 : STA BowTracking
		JMP .incrementCounts
	+ CPY.b #$3B : BNE + ; Bow & Silver Arrows
		LDA BowTracking : ORA #$40 : STA BowTracking
		LDA ArrowMode : BNE +++
			LDA BowTracking : ORA #$80 : STA BowTracking ; activate wood arrows when not in rupee bow
		+++
		JMP .incrementCounts
	+ CPY.b #$43 : BNE + ; Single arrow
		LDA ArrowMode : BEQ +++
			LDA BowTracking : ORA #$80 : STA BowTracking ; activate wood arrows in quick-swap
		+++
		JMP .incrementCounts
	+ CPY.b #$58 : BNE + ; Upgrade-Only Silver Arrows
		LDA BowTracking : ORA #$40 : STA BowTracking
	+

	.incrementCounts
	LDA StatsLocked : BEQ + : JMP .done : +

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

	LDA $1B : BEQ ++ ; skip shop check if outdoors
	LDA $02E9 : CMP.b #$01 : BEQ ++ ; skip shop check for chests
		PHP : REP #$20 ; set 16-bit accumulator
			LDA $048E
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
	LDA $1B : BNE + : JMP .fullItemCounts : +
	SEP #$20 ; Set 8-bit Accumulator

	LDA $040C ; get dungeon id
        CMP.b #$FF : BEQ .fullItemCounts

        CMP.l BallNChainDungeon : BNE +
		CPY.b #$32 : BNE +
                        JMP .done
	+
        CMP.b #$04 : BCS +
                LDA SewersLocations : INC : STA SewersLocations
                LDA HCLocations : INC : STA HCLocations
                BRA .fullItemCounts
        + LSR : TAX : LDA DungeonLocationsChecked, X : INC : STA DungeonLocationsChecked, X
	++ CPX.b #$0D : BNE +
		LDA BigKeyField : AND #$04 : BNE ++
			JSR .incrementGTowerPreBigKey
		++
	+
	; == END INDOOR-ONLY SECTION
	.fullItemCounts

	LDA BootsEquipment : BNE + ; Check for Boots
		LDA PreBootsLocations : INC : STA PreBootsLocations ; Increment Pre Boots Counter
	+

	LDA MirrorEquipment : BNE + ; Check for Mirror
		LDA PreMirrorLocations : INC : STA PreMirrorLocations ; Increment Pre Mirror Counter
	+

	LDA FluteEquipment : BNE + ; Check for Flute
		LDA PreFluteLocations : INC : STA PreFluteLocations ; Increment Pre Mirror Counter
	+

        REP #$20
	LDA TotalItemCounter : INC : STA TotalItemCounter ; Increment Item Total
        SEP #$20

	.itemCounts

	CPY.b #$00 : BNE + ; Fighter's Sword & Fighter's Shield
                LDX #$01
		JSR .incrementSword
		JSR .incrementShield
		JMP .done
	+ CPY.b #$01 : BNE + ; Master Sword
                LDX #$02
		JSR .incrementSword
		JMP .done
	+ CPY.b #$02 : BNE + ; Tempered Sword
                LDX #$03
		JSR .incrementSword
		JMP .done
	+ CPY.b #$03 : BNE + ; Golden Sword
                LDX #$04
		JSR .incrementSword
		JMP .done
	+ CPY.b #$04 : BNE + ; Fighter's Shield
                LDX #$01
		JSR .incrementShield
		JMP .done
	+ CPY.b #$05 : BNE + ; Red Shield
                LDX #$02
		JSR .incrementShield
		JMP .done
	+ CPY.b #$06 : BNE + ; Mirror Shield
                LDX #$03
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
	+ CPY.b #$1B : !BLT + ; Items $1B - $1F
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
                LDX #$01
                JSR .incrementMail
	+ CPY.b #$23 : BNE + ; Red Mail
                LDX #$02
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
                LDX #$01
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
                LDX #$02
		JSR .incrementSword
		JMP .done
	+ CPY.b #$51 : BNE + ; 5 Bomb Capacity Upgrade
                LDX #$02
		JSR .maybeIncrementBombs
		JMP .done
	+ CPY.b #$52 : BNE + ; 10 Bomb Capacity Upgrade
                LDX #$02
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
                LDA SwordEquipment : INC : TAX
		JSR .incrementSword
		JMP .done
	+ CPY.b #$5F : BNE + ; Progressive Shield
                LDA ShieldEquipment : INC : TAX
		JSR .incrementShield
		JMP .done
	+ CPY.b #$60 : BNE + ; Progressive Armor
                LDA ArmorEquipment : INC : TAX
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
	LDA SwordTime : BNE +
	LDA SwordTime+2 : BNE +
		LDA NMIFrames : STA SwordTime
		LDA NMIFrames+2 : STA SwordTime+2
	+
	SEP #$20 ; set 8-bit accumulator
RTS

.stampBoots
	REP #$20 ; set 16-bit accumulator
	LDA BootsTime : BNE +
	LDA BootsTime+2 : BNE +
		LDA NMIFrames : STA BootsTime
		LDA NMIFrames+2 : STA BootsTime+2
	+
	SEP #$20 ; set 8-bit accumulator
RTS

.stampFlute
	REP #$20 ; set 16-bit accumulator
	LDA FluteTime : BNE +
	LDA FluteTime+2 : BNE +
		LDA NMIFrames : STA FluteTime
		LDA NMIFrames+2 : STA FluteTime+2
	+
	SEP #$20 ; set 8-bit accumulator
RTS

.stampMirror
	REP #$20 ; set 16-bit accumulator
	LDA MirrorTime : BNE +
	LDA MirrorTime+2 : BNE +
		LDA NMIFrames : STA MirrorTime
		LDA NMIFrames+2 : STA MirrorTime+2
	+
	SEP #$20 ; set 8-bit accumulator
RTS

.incrementSword
	JSR .stampSword
        LDA HighestSword
        INC : STA $04 : CPX $04 : !BLT + ; don't increment unless we're getting a better sword
                TXA : STA HighestSword
        +
RTS

.incrementShield
        LDA HighestShield
        INC : STA $04 : CPX $04 : !BLT + ; don't increment unless we're getting a better shield
                TXA : STA HighestShield
        +
RTS

.incrementBow
        LDA BowEquipment : BNE .dontCount ; Don't increment Y item count for extra bows
.incrementY
	LDA YAItemCounter : !ADD #$08 : STA YAItemCounter
.dontCount
RTS

.incrementA
	LDA YAItemCounter : INC : AND #$07 : TAX
	LDA YAItemCounter : AND #$F8 : STA YAItemCounter
	TXA : ORA YAItemCounter : STA YAItemCounter
RTS

.incrementPendant
	LDA PendantCounter : INC : STA PendantCounter
RTS

.incrementCapacity
	LDA CapacityUpgrades : INC : STA CapacityUpgrades
RTS

.incrementHeartPiece
	LDA HeartPieceCounter : INC : STA HeartPieceCounter
RTS

.incrementHeartContainer
	LDA HeartContainerCounter : INC : STA HeartContainerCounter
RTS

.incrementCrystal
	LDA CrystalCounter : INC : STA CrystalCounter
RTS

.incrementMail
        LDA HighestMail
        INC : STA $04 : CPX $04 : !BLT +   ; don't increment unless we're getting a better mail
                TXA : STA HighestMail
        +
RTS

.incrementKeyLong
	JSR .incrementKey
RTL

.incrementKey
        LDA SmallKeyCounter : INC : STA SmallKeyCounter
RTS

.incrementCompass
	%BottomHalf(MapsCompasses)
RTS

.incrementBigKey
	%TopHalf(BigKeysBigChests)
RTS

.incrementGTowerPreBigKey
        LDA PreGTBKLocations : INC : STA PreGTBKLocations
RTS

.maybeIncrementBombs
	LDA InventoryTracking+1 : AND #$02 : BNE +
		LDA InventoryTracking+1 : ORA #$02 : STA InventoryTracking+1
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
	LDA SwordEquipment
	BNE + : -
                LDA SwordlessBossKills : INC : STA SwordlessBossKills
                RTS
	+ CMP #$FF : BEQ -
	+ CMP #$01 : BNE +
		%TopHalf(SwordBossKills) : RTS
	+ CMP #$02 : BNE +
		%BottomHalf(SwordBossKills) : RTS
	+ CMP #$03 : BNE +
		%TopHalf(SwordBossKills+1) : RTS
	+ CMP #$04 : BNE +
		%BottomHalf(SwordBossKills+1)
	+
RTS

.setDungeonCompletion
        LDA $040C
	CMP #$FF : BEQ +
		LSR : AND #$0F : CMP #$08 : !BGE ++
			JSR .valueShift
			ORA DungeonsCompleted : STA DungeonsCompleted
			BRA +
		++
			!SUB #$08
			JSR .valueShift
			BIT.b #$C0 : BEQ +++ : LDA.b #$C0 : +++ ; Make Hyrule Castle / Sewers Count for Both
			ORA DungeonsCompleted+1 : STA DungeonsCompleted+1
	+
RTS

.valueShift
	PHX
	TAX : LDA.b #$01
	-
		CPX #$00 : BEQ +
		ASL
		DEX
	BRA -
	+
	PLX
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Link_ReceiveItem_HUDRefresh:
;--------------------------------------------------------------------------------
Link_ReceiveItem_HUDRefresh:
	LDA BombsEquipment : BNE + ; skip if we have bombs
	LDA BombCapacityUpgrades : !ADD.l StartingMaxBombs : BEQ + ; skip if we can't have bombs
	LDA BombsFiller : BEQ + ; skip if we are filling no bombs
		DEC : STA BombsFiller ; decrease bomb fill count
		LDA.b #$01 : STA BombsEquipment ; increase actual bomb count
	+

	JSL.l HUD_RefreshIconLong ; thing we wrote over
	JSL.l PostItemGet
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; HandleBombAbsorbtion:
;--------------------------------------------------------------------------------
HandleBombAbsorbtion:
	STA BombsFiller ; thing we wrote over
	LDA $0303 : BNE + ; skip if we already have some item selected
	LDA BombCapacityUpgrades : !ADD.l StartingMaxBombs : BEQ + ; skip if we can't have bombs
		LDA.b #$04 : STA $0202 ; set selected item to bombs
		LDA.b #$01 : STA $0303 ; set selected item to bombs
		JSL.l HUD_RebuildLong
	+
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; AddYMarker:
;--------------------------------------------------------------------------------
;!JAR_STATUS = "$7F5030";
AddYMarker:
	LDA $0202 : AND.w #$FF ; load item value
	CMP.w #$02 : BNE + ; boomerang
		LDA InventoryTracking : AND.w #$C0 : CMP.w #$C0 : BEQ .drawYBubble : BRA .drawNormal
	+ CMP.w #$01 : BNE + ; bow
		LDA BowTracking : AND.w #$C0 : CMP.w #$C0 : BEQ .drawYBubble : BRA .drawNormal
	+ CMP.w #$05 : BNE + ; powder
		LDA InventoryTracking : AND.w #$30 : CMP.w #$30 : BEQ .drawYBubble : BRA .drawNormal
	+ CMP.w #$0D : BNE + ; flute
		LDA InventoryTracking : BIT.w #$04 : BEQ .drawNormal ; make sure we have shovel
					  AND.w #$03 : BNE .drawYBubble ; make sure we have one of the flutes
					  BRA .drawNormal
	+ CMP.w #$10 : BEQ .drawJarMarker

	.drawNormal
	LDA.w #$7C60
	BRA .drawTile

	.drawJarMarker
	;SEP #$20 : LDA !JAR_STATUS : INC : AND.b #$01 : STA !JAR_STATUS : REP #$20 : BEQ .drawXBubble
	LDA $0207 : AND.w #$0020 : BNE .drawXBubble

	.drawYBubble
	LDA.w #$3D4F
	BRA .drawTile

	.drawXBubble
	JSR MakeCircleBlue
	LDA.w #$2D3E

	.drawTile
	STA $FFC4, Y
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; MakeCircleBlue
; this is horrible, make it better
;--------------------------------------------------------------------------------
MakeCircleBlue:
    LDA $FFC0, Y : AND.w #$EFFF : STA $FFC0, Y
    LDA $FFC2, Y : AND.w #$EFFF : STA $FFC2, Y

    LDA $FFFE, Y : AND.w #$EFFF : STA $FFFE, Y
    LDA $0004, Y : AND.w #$EFFF : STA $0004, Y

    LDA $003E, Y : AND.w #$EFFF : STA $003E, Y
    LDA $0044, Y : AND.w #$EFFF : STA $0044, Y

    LDA $0080, Y : AND.w #$EFFF : STA $0080, Y
    LDA $0082, Y : AND.w #$EFFF : STA $0082, Y

    LDA $FFBE, Y : AND.w #$EFFF : STA $FFBE, Y
    LDA $FFC4, Y : AND.w #$EFFF : STA $FFC4, Y
    LDA $0084, Y : AND.w #$EFFF : STA $0084, Y
    LDA $007E, Y : AND.w #$EFFF : STA $007E, Y
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; UpgradeFlute:
;--------------------------------------------------------------------------------
UpgradeFlute:
	LDA InventoryTracking : AND #$FC : ORA #$01 : STA InventoryTracking ; switch to the working flute
	LDA.b #$03 : STA FluteEquipment ; upgrade primary inventory
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; CheckKeys:
;--------------------------------------------------------------------------------
CheckKeys:
	LDA.l GenericKeys : BEQ + : RTL : +
	LDA $040C : CMP.b #$FF
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; DrawKeyIcon:
;--------------------------------------------------------------------------------
DrawKeyIcon:
	LDA $04 : AND.w #$00FF : CMP.w #$0090 : BNE + : LDA.w #$007F : + : ORA.w #$2400 : STA $7EC764
	LDA $05 : AND.w #$00FF : ORA.w #$2400 : STA $7EC766
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; LoadKeys:
;--------------------------------------------------------------------------------
LoadKeys:
	LDA.l GenericKeys : BEQ +
		LDA CurrentGenericKeys
		RTL
	+
	LDA DungeonKeys, X
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; SaveKeys:
;--------------------------------------------------------------------------------
SaveKeys:
	PHA
	LDA.l GenericKeys : BEQ +
		PLA : STA CurrentGenericKeys
		RTL
	+
	PLA : STA DungeonKeys, X
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
		PLA : LDA CurrentGenericKeys : STA CurrentSmallKeys
		RTL
	+
	PLA : STA CurrentSmallKeys
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; GetWitchLootOAMTableIndex
; in:	A - Loot ID
; out:	A - Loot OAM Table Index
; check if this is even still referenced anywhere
;--------------------------------------------------------------------------------
;GetWitchLootOAMTableIndex:
;	PHX
;	PHB : PHK : PLB
;	;--------
;	TAX : LDA .gfxSlots, X ; look up item gfx
;	PLB : PLX
;RTL
;
;;DATA - Loot Identifier to Sprite ID
;{
;	.gfxSlots
;    db $FF, $FF, $FF, $FF, $05, $06, $FF, $0C
;    db $0B, $0D, $0A, $07, $13, $0E, $FF, $FF
;
;    db $FF, $FF, $FF, $FF, $FF, $09, $FF, $FF
;    db $08, $FF, $FF, $10, $11, $12, $FF, $FF
;
;    db $FF, $FF, $03, $04, $FF, $FF, $02, $FF
;    db $FF, $FF, $14, $15, $17, $16, $15, $17
;
;    db $16, $0F, $FF, $FF, $FF, $FF, $FF, $FF
;    db $FF, $FF, $FF, $FF, $FF, $FF, $02, $02
;
;    db $FF, $FF, $FF, $FF, $01, $FF, $FF, $FF
;    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
;}
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; PrepItemScreenBigKey:
;--------------------------------------------------------------------------------
PrepItemScreenBigKey:
    STZ $02
    STZ $03
	REP #$30 ; thing we wrote over - set 16-bit accumulator
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; LoadPowder:
;--------------------------------------------------------------------------------
LoadPowder:
	JSL.l Sprite_SpawnDynamically ; thing we wrote over
	%GetPossiblyEncryptedItem(WitchItem, SpriteItemValues)
	STA $0DA0, Y ; Store item type
	JSL.l PrepDynamicTile
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; InitializeBottles:
;--------------------------------------------------------------------------------
InitializeBottles:
	STA BottleContents, X ; thing we wrote over
	PHA
		LDA BottleIndex : BNE +
			TXA : INC : STA BottleIndex ; write bottle index to menu properly
		+
	PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; DrawPowder:
;--------------------------------------------------------------------------------
!REDRAW = "$7F5000"
;--------------------------------------------------------------------------------
DrawPowder:
	LDA $02DA : BNE .defer ; defer if link is buying a potion
	LDA.l !REDRAW : BEQ +
		LDA $0DA0, X ; Retrieve stored item type
		JSL.l PrepDynamicTile
		LDA #$00 : STA.l !REDRAW ; reset redraw flag
		BRA .defer
	+
	LDA $0DA0, X ; Retrieve stored item type
	JSL.l DrawDynamicTile
	.defer
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; LoadMushroom:
;--------------------------------------------------------------------------------
LoadMushroom:
	LDA.b #$00 : STA $0DC0, X ; thing we wrote over
	.justGFX
	;LDA MushroomItem
	;JSL.l PrepDynamicTile

	PHA

	LDA #$01 : STA !REDRAW
	LDA $5D : CMP #$14 : BEQ .skip ; skip if we're mid-mirror

	LDA #$00 : STA !REDRAW
	%GetPossiblyEncryptedItem(MushroomItem, SpriteItemValues)
	STA $0E80, X ; Store item type
	JSL.l PrepDynamicTile

	.skip
	PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; DrawMushroom:
;--------------------------------------------------------------------------------
!REDRAW = "$7F5000"
;--------------------------------------------------------------------------------
DrawMushroom:
	PHA : PHY
		LDA !REDRAW : BEQ .skipInit ; skip init if already ready
		JSL.l LoadMushroom_justGFX
		BRA .done ; don't draw on the init frame

		.skipInit
		LDA $0E80, X ; Retrieve stored item type
		JSL.l DrawDynamicTile

		.done
	PLY : PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; CollectPowder:
;--------------------------------------------------------------------------------
CollectPowder:
	LDY $0DA0, X ; Retrieve stored item type
	BNE +
		; if for any reason the item value is 0 reload it, just in case
		%GetPossiblyEncryptedItem(WitchItem, SpriteItemValues) : TAY
	+
    STZ $02E9 ; item from NPC
    JSL.l Link_ReceiveItem
	;JSL.l FullInventoryExternal
	JSL.l ItemSet_Powder
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; RemoveMushroom:
;--------------------------------------------------------------------------------
RemoveMushroom:
	LDA InventoryTracking : AND #$DF : STA InventoryTracking ; remove the mushroom
	AND #$10 : BEQ .empty ; check if we have powder
	LDA.b #$02 : STA PowderEquipment ; give powder if we have it
RTL
	.empty
	LDA.b #$00 : STA PowderEquipment ; clear the inventory slot if we don't have powder
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; DrawMagicHeader:
;--------------------------------------------------------------------------------
DrawMagicHeader:
	LDA MagicConsumption : AND.w #$00FF : CMP.w #$0002 : BEQ .quarterMagic
	.halfMagic
    LDA.w #$28F7 : STA $7EC704
    LDA.w #$2851 : STA $7EC706
    LDA.w #$28FA : STA $7EC708
RTL
	.quarterMagic
    LDA.w #$28F7 : STA $7EC704
    LDA.w #$2800 : STA $7EC706
    LDA.w #$2801 : STA $7EC708
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; FixShovelLock:
;--------------------------------------------------------------------------------
;FixShovelLock:
;	LDA $037A :	CMP #$01 : BEQ + ; skip if link is shoveling
;		LDA FluteEquipment ; load shovel/flute item ID
;	+
;	CMP #$00
;RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; SpawnShovelGamePrizeSFX:
;--------------------------------------------------------------------------------
SpawnShovelGamePrizeSFX:
	STA $7FFE00 ; thing we wrote over
	PHA
		LDA.b #$1B : STA $012F ; play puzzle sound
	PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; SpawnChestGamePrizeSFX:
;--------------------------------------------------------------------------------
SpawnChestGamePrizeSFX:
	CPX.b #$07 : BNE .normal
	LDA $A0 : CMP.b #$06 : BNE .normal
	.prize
	LDA.b #$1B : STA $012F : RTL ; play puzzle sound
	.normal
	LDA.b #$0E : STA $012F ; play chest sound
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; SpawnShovelItem:
;--------------------------------------------------------------------------------
!REDRAW = "$7F5000"
SpawnShovelItem:
	LDA.b #$01 : STA !REDRAW

    LDA $03FC : BEQ +
    	JSL DiggingGameGuy_AttemptPrizeSpawn
		JMP .skip
	+

	LDA $035B : AND.b #$01 : BNE + : JMP .skip : + ; corner dig fix

	PHY : PHP
	PHB : PHK : PLB
		SEP #$30 ; set 8-bit accumulator and index registers

		LDA $1B : BEQ + : JMP .no_drop : + ; skip if indoors

		LDA $8A : CMP #$2A : BEQ .no_drop ; don't drop in the haunted grove
		          CMP #$68 : BEQ .no_drop ; don't drop in the digging game area

		JSL GetRandomInt : BIT #$03 : BNE .no_drop ; drop with 1/4 chance

		LSR #2 : TAX ; clobber lower 2 bis - we have 64 slots now

		LDA.l ShovelSpawnTable, X ; look up the drop on the table

		;most of this part below is copied from the digging game

		STA $7FFE00
		JSL Sprite_SpawnDynamically

		LDX.b #$00
		LDA $2F : CMP.b #$04 : BEQ + : INX : +

		LDA.l .x_speeds, X : STA $0D50, Y

		LDA.b #$00 : STA $0D40, Y
		LDA.b #$18 : STA $0F80, Y
		LDA.b #$FF : STA $0B58, Y
		LDA.b #$30 : STA $0F10, Y

		LDA $22 : !ADD.l .x_offsets, X
		                        AND.b #$F0 : STA $0D10, Y
		LDA $23 : ADC.b #$00               : STA $0D30, Y

		LDA $20 : !ADD.b #$16 : AND.b #$F0 : STA $0D00, Y
		LDA $21 : ADC.b #$00               : STA $0D20, Y

		LDA.b #$00 : STA $0F20, Y
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
