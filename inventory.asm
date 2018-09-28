;================================================================================
; Inventory Updates
;================================================================================
!INVENTORY_SWAP = "$7EF38C"
; Item Tracking Slot
; brmp-skf
; b = blue boomerang
; r = red boomerang
; m = mushroom
; p = magic powder
; -
; s = shovel
; k = fake flute
; f = working flute
;--------------------------------------------------------------------------------
!INVENTORY_SWAP_2 = "$7EF38E"
; Item Tracking Slot #2
; bs------
; b = bow
; s = silver arrow bow
; -
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
	;LDA #$FD : STA !INVENTORY_SWAP ; DEBUG MODE
	;LDA $F6 : BIT #$20 : BNE .l_pressed ; check for P1 L-button
	LDA $F4 : BIT #$40 : BNE .y_pressed ; check for P1 Y-button
			  BIT #$20 : BNE .sel_pressed ; check for P1 Select button
	LDA $F0 : BIT #$20 : BNE .sel_held
	.sel_unheld
		LDA !HUD_FLAG : AND #$20 : BEQ +
		LDA !HUD_FLAG : AND #$DF : STA !HUD_FLAG ; select is released, unset hud flag
		LDA $1B : BEQ + ; skip if outdoors
			LDA.b #$20 : STA $012F ; menu select sound
		+
		JSL.l ResetEquipment
	+
	.sel_held
	CLC ; no buttons
RTL
	;.l_pressed
	;JSL.l SpawnAngryCucco
;RTL
	.sel_pressed
	LDA !HUD_FLAG : ORA #$20 : STA !HUD_FLAG ; set hud flag
	LDA.b #$20 : STA $012F ; menu select sound
	JSL.l ResetEquipment
RTL
	.y_pressed ; Note: used as entry point by quickswap code. Must preserve X. 
	LDA.b #$10 : STA $0207
	LDA $0202 ; check selected item
	CMP #$02 : BNE + ; boomerang
		LDA !INVENTORY_SWAP : AND #$C0 : CMP #$C0 : BNE .errorJump ; make sure we have both boomerangs
		LDA $7EF341 : EOR #$03 : STA $7EF341 ; swap blue & red boomerang
		LDA.b #$20 : STA $012F ; menu select sound
		BRL .captured
	+ CMP #$01 : BNE + ; bow
		LDA !INVENTORY_SWAP_2 : AND #$C0 : CMP #$C0 : BNE .errorJump ; make sure we have both bows
		PHX : LDX.b #$00 ; scan ancilla table for arrows
			-- : CPX.b #$0A : !BGE ++
				LDA $0C4A, X : CMP.b #$09 : BNE +++
					PLX : BRA .errorJump2 ; found an arrow, don't allow the swap
				+++
			INX : BRA -- : ++
		PLX
		LDA.l SilverArrowsUseRestriction : BEQ ++
		LDA $A0 : ORA $A1 : BEQ ++ ; not in ganon's room in restricted mode
				LDA $7EF340 : CMP.b #$03 : !BLT .errorJump : !SUB #$02 : STA $7EF340
				BRA .errorJump2
		++
		LDA $7EF340 : !SUB #$01 : EOR #$02 : !ADD #$01 : STA $7EF340 ; swap bows
		LDA.b #$20 : STA $012F ; menu select sound
		BRL .captured
	+ BRA +
		.errorJump
		BRA .errorJump2
	+ CMP #$05 : BNE + ; powder
		LDA !INVENTORY_SWAP : AND #$30 : CMP #$30 : BNE .errorJump ; make sure we have mushroom & magic powder
		LDA $7EF344 : EOR #$03 : STA $7EF344 ; swap mushroom & magic powder
		LDA.b #$20 : STA $012F ; menu select sound
		BRL .captured
	+ BRA +
		.errorJump2
		BRA .error
	+ CMP #$0D : BNE + ; flute
		LDA $037A :	CMP #$01 : BEQ .midShovel ; inside a shovel animation, force the shovel & make error sound
		LDA !INVENTORY_SWAP : BIT #$04 : BEQ .error ; make sure we have shovel
					  AND #$03 : BEQ .error ; make sure we have one of the flutes
		LDA $7EF34C : CMP #01 : BNE .toShovel ; not shovel

		LDA !INVENTORY_SWAP : AND #$01 : BEQ .toFakeFlute ; check for real flute
		LDA #$03 ; set real flute
		BRA .fluteSuccess
		.toFakeFlute
		LDA #$02 ; set fake flute
		BRA .fluteSuccess
		.toShovel
		LDA #$01 ; set shovel
		.fluteSuccess
		STA $7EF34C ; store set item
		LDA.b #$20 : STA $012F ; menu select sound
		BRA .captured
	+
	CMP #$10 : BNE .error : JSL.l ProcessBottleMenu : BRA .captured : +
	CLC
RTL
	.midShovel
	; LDA #$01 : STA $7EF34C ; set shovel
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
	LDA $F4 : AND #$40 : BEQ .y_not_pressed ; skip if Y is not down
	LDA $7EF34F ; check bottle state
	BEQ .no_bottles ; skip if we have no bottles
	PHX
		INC : CMP #$05 : !BLT + : LDA #$01 : + ;increment and wrap 1-4
		TAX : LDA $7EF35C-1, X ; check bottle
		BNE + : LDX #$01 : + ; wrap if we reached the last bottle
		TXA : STA $7EF34F ; set bottle index
		LDA.b #$20 : STA $012F ; menu select sound
	PLX
	.no_bottles
	LDA #$00 ; pretend like the controller state was 0 from the overridden load
RTL
	.y_not_pressed
	LDA $F4 : AND.b #$0C ; thing we wrote over - load controller state
RTL
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
!LOCK_STATS = "$7EF443"

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
;	LDA !LOCK_STATS : BEQ + : RTL : +
;	PHA : PHX : PHP : JMP AddInventory_fullItemCounts
;--------------------------------------------------------------------------------
FullInventoryExternal:
	LDA !LOCK_STATS : BEQ + : RTL : +
	PHA : PHX : PHP : JMP AddInventory_incrementCounts
;--------------------------------------------------------------------------------
!SHAME_CHEST = "$7EF416" ; ---s ----
AddInventory:
	PHA : PHX : PHP
	CPY.b #$0C : BNE + ; Blue Boomerang
		LDA !INVENTORY_SWAP : ORA #$80 : STA !INVENTORY_SWAP
		BRL .incrementCounts
	+ CPY.b #$2A : BNE + ; Red Boomerang
		LDA !INVENTORY_SWAP : ORA #$40 : STA !INVENTORY_SWAP
		BRL .incrementCounts
	+ CPY.b #$29 : BNE + ; Mushroom
		LDA !INVENTORY_SWAP : ORA #$20 : STA !INVENTORY_SWAP
		BRL .incrementCounts
	+ CPY.b #$0D : BNE + ; Magic Powder
		LDA !INVENTORY_SWAP : ORA #$10 : STA !INVENTORY_SWAP
		BRL .incrementCounts
	+ CPY.b #$13 : BNE + ; Shovel
		LDA !INVENTORY_SWAP : ORA #$04 : STA !INVENTORY_SWAP
		BRL .incrementCounts
	+ CPY.b #$14 : BNE + ; Flute (Inactive)
		LDA !INVENTORY_SWAP : ORA #$02 : STA !INVENTORY_SWAP
		BRL .incrementCounts
	+ CPY.b #$4A : BNE + ; Flute (Active)
		LDA !INVENTORY_SWAP : ORA #$01 : STA !INVENTORY_SWAP
		BRL .incrementCounts
	+ CPY.b #$0B : BNE + ; Bow
		LDA ArrowMode : BNE +++
			LDA !INVENTORY_SWAP_2 : ORA #$80 : STA !INVENTORY_SWAP_2
		+++
		BRL .incrementCounts
	+ CPY.b #$3A : BNE + ; Bow & Arrows
		LDA !INVENTORY_SWAP_2 : ORA #$80 : STA !INVENTORY_SWAP_2
		BRL .incrementCounts
	+ CPY.b #$3B : BNE + ; Bow & Silver Arrows
		LDA !INVENTORY_SWAP_2 : ORA #$40 : STA !INVENTORY_SWAP_2
		BRL .incrementCounts
	+ CPY.b #$43 : BNE + ; Single arrow
		LDA ArrowMode : BEQ +++
			LDA !INVENTORY_SWAP_2 : ORA #$80 : STA !INVENTORY_SWAP_2 ; activate wood arrows in quick-swap
		+++
		BRL .incrementCounts
	+ CPY.b #$58 : BNE + ; Upgrade-Only Silver Arrows
		LDA !INVENTORY_SWAP_2 : ORA #$40 : STA !INVENTORY_SWAP_2
	+

	.incrementCounts
	LDA !LOCK_STATS : BEQ + : BRL .done : +

	; don't count any of this stuff
	CPY.b #$20 : BNE + : BRL .itemCounts : + ; Crystal
	CPY.b #$26 : BNE + : BRL .itemCounts : + ; Heart Piece Completion Heart
	CPY.b #$2E : BNE + : BRL .itemCounts : + ; Red Potion (Refill)
	CPY.b #$2F : BNE + : BRL .itemCounts : + ; Green Potion (Refill)
	CPY.b #$30 : BNE + : BRL .itemCounts : + ; Blue Potion (Refill)
	CPY.b #$37 : BNE + : BRL .itemCounts : + ; Pendant
	CPY.b #$38 : BNE + : BRL .itemCounts : + ; Pendant
	CPY.b #$39 : BNE + : BRL .itemCounts : + ; Pendant
	CPY.b #$00 : BNE + : BRL .itemCounts : + ; Uncle Sword & Shield
	
	CPY.b #$04 : !BLT .isSword ; Swords - Skip Shop/Fairy Check for Swords
	CPY.b #$49 : BEQ .isSword
	CPY.b #$50 : BEQ .isSword
	CPY.b #$5E : BEQ .isSword
	BRA +
		.isSword
		BRL .dungeonCounts
	+
	CPY.b #$3B : BNE + : BRL .dungeonCounts : + ; Silver Arrow Bow - Skip Shop/Fairy Check for Silver Arrow Bow

	LDA $1B : BEQ ++ ; skip shop check if outdoors
	LDA $02E9 : CMP.b #$01 : BEQ ++ ; skip shop check for chests
		PHP : REP #$20 ; set 16-bit accumulator
			LDA $048E
			CMP.w #274 : BNE + : BRL .shop : + ; dark world death mountain shop, ornamental shield shop
			CMP.w #271 : BNE + : BRL .shop : + ; villiage of outcasts shop, lumberjack shop, lake hylia shop, dark world magic shop
			CMP.w #272 : BNE + : BRL .shop : + ; red shield shop
			CMP.w #284 : BNE + : BRL .shop : + ; bomb shop
			;CMP.w #265 : BNE + : BRL .shop : + ; potion shop - commented this out because it's easier to just block potion refills because this one interferes with the powder item being counted
			;CMP.w #271 : BNE + : BRL .shop : + ; lake hylia shop
			CMP.w #287 : BNE + : BRL .shop : + ; kakariko shop
			CMP.w #255 : BNE + : BRL .shop : + ; light world death mountain shop
			CMP.w #276 : BNE + : BRL .shop : + ; waterfall fairy
			CMP.w #277 : BNE + : BRL .shop : + ; upgrade fairy (shop)
			CMP.w #278 : BNE + : BRL .shop : + ; pyramid fairy
		PLP : BRA ++
		.shop
		PLP : BRL .done
	++

	.dungeonCounts
	LDA $1B : BNE + : BRL .fullItemCounts : +
	; ==BEGIN INDOOR-ONLY SECTION

	;REP #$20 ; Set 16-bit Accumulator
	;LDA $A0 ; load room ID
	;CMP.w #$0010 : BNE + ; Ganon Fall Room - I think this got taken out
		;!SHAME_CHEST = "$7EF416" ; ---s ----
		;LDA !SHAME_CHEST : ORA.w #$0010 : STA !SHAME_CHEST
	;+
	SEP #$20 ; Set 8-bit Accumulator

	LDA $040C ; get dungeon id

	CMP.b #$00 : BNE + ; Sewers (Escape)
		BRA ++
	+ CMP.b #$02 : BNE + ; Hyrule Castle (Escape)
		++
		CPY.b #$32 : BNE ++ : BRL .itemCounts : ++ ; Ball & Chain Guard's Big Key
		%TopHalf($7EF434)
		BRL .fullItemCounts
	+ CMP.b #$04 : BNE + ; Eastern Palace
		LDA $7EF436 : INC : AND #$07 : TAX
		LDA $7EF436 : AND #$F8 : STA $7EF436
		TXA : ORA $7EF436 : STA $7EF436
		BRL .fullItemCounts
	+ CMP.b #$06 : BNE + ; Desert Palace
		LDA $7EF435 : !ADD #$20 : STA $7EF435
		BRL .fullItemCounts
	+ CMP.b #$08 : BNE + ; Agahnim's Tower
		LDA $7EF435 : INC : AND #$03 : TAX
		LDA $7EF435 : AND #$FC : STA $7EF435
		TXA : ORA $7EF435 : STA $7EF435
		BRL .fullItemCounts
	+ CMP.b #$0A : BNE + ; Swamp Palace
		%BottomHalf($7EF439)
		BRL .fullItemCounts
	+ CMP.b #$0C : BNE + ; Palace of Darkness
		%BottomHalf($7EF434)
		BRL .fullItemCounts
	+ CMP.b #$0E : BNE + ; Misery Mire
		%BottomHalf($7EF438)
		BRL .fullItemCounts
	+ CMP.b #$10 : BNE + ; Skull Woods
		%TopHalf($7EF437)
		BRL .fullItemCounts
	+ CMP.b #$12 : BNE + ; Ice Palace
		%TopHalf($7EF438)
		BRL .fullItemCounts
	+ CMP.b #$14 : BNE + ; Tower of Hera
		LDA $7EF435 : !ADD #$04 : AND #$1C : TAX
		LDA $7EF435 : AND #$E3 : STA $7EF435
		TXA : ORA $7EF435 : STA $7EF435
		BRL .fullItemCounts
	+ CMP.b #$16 : BNE + ; Thieves' Town
		%BottomHalf($7EF437)
		BRL .fullItemCounts
	+ CMP.b #$18 : BNE + ; Turtle Rock
		%TopHalf($7EF439)
		BRL .fullItemCounts
	+ CMP.b #$1A : BNE + ; Ganon's Tower
		LDA $7EF436 : !ADD #$08 : STA $7EF436
		LDA $7EF366 : AND #$04 : BNE ++
			JSR .incrementGTowerPreBigKey
		++
		;BRL .fullItemCounts
	+

	; == END INDOOR-ONLY SECTION
	.fullItemCounts

	CPY.b #$3B : BNE + ; Skip Total Counts for Repeat Silver Arrows
		LDA $7EF42A : BIT #$20 : BEQ + : BRA .itemCounts
	+

	LDA $7EF355 : BNE + ; Check for Boots
		LDA $7EF432 : INC : STA $7EF432 ; Increment Pre Boots Counter
	+

	LDA $7EF353 : BNE + ; Check for Mirror
		LDA $7EF433 : INC : STA $7EF433 ; Increment Pre Mirror Counter
	+

	LDA $7EF423 : INC : STA $7EF423 ; Increment Item Total

	.itemCounts

	CPY.b #$00 : BNE + ; Fighter's Sword & Fighter's Shield
		JSR .incrementSword
		JSR .incrementShield
		BRL .done
	+ CPY.b #$01 : BNE + ; Master Sword
		JSR .incrementSword
		BRL .done
	+ CPY.b #$02 : BNE + ; Tempered Sword
		JSR .incrementSword
		BRL .done
	+ CPY.b #$03 : BNE + ; Golden Sword
		JSR .incrementSword
		BRL .done
	+ CPY.b #$04 : BNE + ; Fighter's Shield
		JSR .incrementShield
		BRL .done
	+ CPY.b #$05 : BNE + ; Red Shield
		JSR .incrementShield
		BRL .done
	+ CPY.b #$06 : BNE + ; Mirror Shield
		JSR .incrementShield
		BRL .done
	+ CPY.b #$07 : !BLT + ; Items $07 - $0D
	  CPY.b #$0E : !BGE +
		JSR .incrementY
		BRL .done
	+ CPY.b #$14 : BNE + ; Flute (Inactive) - LEAVE THIS ABOVE THE 0F-16 CONDITION - kkat
		JSR .stampFlute
		JSR .incrementY
		BRL .done
	+ CPY.b #$0F : !BLT + ; Items $0F - $16
	  CPY.b #$17 : !BGE +
		JSR .incrementY
		BRL .done
	+ CPY.b #$17 : BNE + ; Heart Piece
		JSR .incrementHeartPiece
		BRL .done
	+ CPY.b #$18 : !BLT + ; Items $18 - $19
	  CPY.b #$1A : !BGE +
		JSR .incrementY
		BRL .done
	+ CPY.b #$1A : BNE + ; Magic Mirror
		JSR .stampMirror
		JSR .incrementY
		BRL .done
	+ CPY.b #$1D : BNE + ; Book of Mudora - LEAVE THIS ABOVE THE 1B-1F CONDITION - kkat
		JSR .incrementY
		BRL .done
	+ CPY.b #$1B : !BLT + ; Items $1B - $1F
	  CPY.b #$20 : !BGE +
		JSR .incrementA
		BRL .done
	+ CPY.b #$20 : BNE + ; Crystal
		JSR .incrementCrystal
		BRL .done
	+ CPY.b #$21 : BNE + ; Bug Net
		JSR .incrementY
		BRL .done
	+ CPY.b #$22 : !BLT + ; Items $22 - $23
	  CPY.b #$24 : !BGE +
		JSR .incrementMail
		BRL .done
	+ CPY.b #$24 : BNE + ; Small Key
		JSR .incrementKey
		BRL .done
	+ CPY.b #$25 : BNE + ; Compass
		JSR .incrementCompass
		BRL .done
	+ CPY.b #$26 : BNE + ; Liar Heart (Container)
		;JSR .incrementHeartContainer
		BRL .done
	+ CPY.b #$27 : BNE + ; 1 Bomb
		JSR .maybeIncrementBombs
		BRL .done
	+ CPY.b #$28 : BNE + ; 3 Bombs
		JSR .maybeIncrementBombs
		BRL .done
	+ CPY.b #$29 : BNE + ; Musoroom
		JSR .incrementY
		BRL .done
	+ CPY.b #$2A : !BLT + ; Items $2A - $2D
	  CPY.b #$2E : !BGE +
		JSR .incrementY
		BRL .done
	+ CPY.b #$31 : BNE + ; 10 Bombs
		JSR .maybeIncrementBombs
		BRL .done
	+ CPY.b #$32 : BNE + ; Big Key
		JSR .incrementBigKey
		BRL .done
	+ CPY.b #$33 : BNE + ; Map
		JSR .incrementMap
		BRL .done
	+ CPY.b #$37 : !BLT + ; Items $37 - $39 - Pendants
	  CPY.b #$3A : !BGE +
		JSR .incrementPendant
		BRL .done
	+ CPY.b #$3A : !BLT + ; Items $3A - $3B - Bow & Silver Arrows
	  CPY.b #$3C : !BGE +
		JSR .incrementBow
		BRL .done
	+ CPY.b #$3C : BNE + ; Bottle w/Bee
		JSR .incrementY
		BRL .done
	+ CPY.b #$3D : BNE + ; Bottle w/Fairy
		JSR .incrementY
		BRL .done
	+ CPY.b #$3E : !BLT + ; Items $3E - $3F - Heart Containers
	  CPY.b #$40 : !BGE +
		JSR .incrementHeartContainer
		BRL .done
	+ CPY.b #$48 : BNE + ; Bottle w/Gold Bee
		JSR .incrementY
		BRL .done
	+ CPY.b #$49 : BNE + ; Fighter's Sword
		JSR .incrementSword
		BRL .done
	+ CPY.b #$4A : BNE + ; Flute (Active)
		JSR .stampFlute
		JSR .incrementY
		BRL .done
	+ CPY.b #$4B : BNE + ; Pegasus Boots
		JSR .stampBoots
		JSR .incrementA
		BRL .done
	+ CPY.b #$4C : BNE + ; Bomb Capacity Upgrade
		JSR .incrementCapacity
		JSR .maybeIncrementBombs
		BRL .done
	+ CPY.b #$4D : !BLT + ; Items $4D - $4F - Capacity Upgrades
	  CPY.b #$50 : !BGE +
		JSR .incrementCapacity
		BRL .done
	+ CPY.b #$50 : BNE + ; Master Sword (Safe)
		JSR .incrementSword
		BRL .done
	+ CPY.b #$51 : !BLT + ; Items $51 - $54 - Capacity Upgrades
	  CPY.b #$55 : !BGE +
		JSR .incrementCapacity
		BRL .done
	+ CPY.b #$58 : BNE + ; Upgrade-Only Sivler Arrows
		JSR .incrementBow
		BRL .done
	+ CPY.b #$5E : BNE + ; Progressive Sword
		JSR .incrementSword
		BRL .done
	+ CPY.b #$5F : BNE + ; Progressive Shield
		JSR .incrementShield
		BRL .done
	+ CPY.b #$60 : BNE + ; Progressive Armor
		JSR .incrementMail
		BRL .done
	+ CPY.b #$61 : BNE + ; Progressive Lifting Glove
		JSR .incrementA
		BRL .done
	+ CPY.b #$70 : !BLT + ; Items $70 - $7F - Free Maps
	  CPY.b #$80 : !BGE +
		JSR .incrementMap
		BRL .done
	+ CPY.b #$80 : !BLT + ; Items $80 - $8F - Free Compasses
	  CPY.b #$90 : !BGE +
		JSR .incrementCompass
		BRL .done
	+ CPY.b #$90 : !BLT + ; Items $90 - $9F - Free Big Keys
	  CPY.b #$A0 : !BGE +
		JSR .incrementBigKey
		BRL .done
	+ CPY.b #$A0 : !BLT + ; Items $A0 - $AF - Free Small Keys
	  CPY.b #$B0 : !BGE +
		JSR .incrementKey
		BRL .done
	+
	.done
	PLP : PLX : PLA
RTL
; WHICH BEE IS BOTTLED?
; MAKE SURE FAIRY FOUNTAINS DON'T FUCK THE COUNTS UP

!NMI_TIME = "$7EF43E"

!SWORD_TIME = "$7EF458"
!BOOTS_TIME = "$7EF45C"
!FLUTE_TIME = "$7EF460"
!MIRROR_TIME = "$7EF464"

.stampSword
	REP #$20 ; set 16-bit accumulator
	LDA !SWORD_TIME : BNE +
	LDA !SWORD_TIME+2 : BNE +
		LDA !NMI_TIME : STA !SWORD_TIME
		LDA !NMI_TIME+2 : STA !SWORD_TIME+2
	+
	SEP #$20 ; set 8-bit accumulator
RTS

.stampBoots
	REP #$20 ; set 16-bit accumulator
	LDA !BOOTS_TIME : BNE +
	LDA !BOOTS_TIME+2 : BNE +
		LDA !NMI_TIME : STA !BOOTS_TIME
		LDA !NMI_TIME+2 : STA !BOOTS_TIME+2
	+
	SEP #$20 ; set 8-bit accumulator
RTS

.stampFlute
	REP #$20 ; set 16-bit accumulator
	LDA !FLUTE_TIME : BNE +
	LDA !FLUTE_TIME+2 : BNE +
		LDA !NMI_TIME : STA !FLUTE_TIME
		LDA !NMI_TIME+2 : STA !FLUTE_TIME+2
	+
	SEP #$20 ; set 8-bit accumulator
RTS

.stampMirror
	REP #$20 ; set 16-bit accumulator
	LDA !MIRROR_TIME : BNE +
	LDA !MIRROR_TIME+2 : BNE +
		LDA !NMI_TIME : STA !MIRROR_TIME
		LDA !NMI_TIME+2 : STA !MIRROR_TIME+2
	+
	SEP #$20 ; set 8-bit accumulator
RTS

.incrementSword
	; CHECK FOR DUPLICATE SWORDS
	JSR .stampSword
	TYA ; load sword item
	CMP.b #$50 : BNE + : LDA.b #$01 : + ; convert extra master sword to normal one
	CMP.b #$49 : BNE + : LDA.b #$00 : + ; convert extra fighter sword to normal one
	INC : CMP !HIGHEST_SWORD_LEVEL : !BLT + ; skip if highest is higher
		PHA
		LDA !HIGHEST_SWORD_LEVEL : AND #$F8 : ORA 1,s : STA !HIGHEST_SWORD_LEVEL
		PLA
	+

	LDA $7EF422 : !ADD #$20 : STA $7EF422 ; increment sword counter
RTS

.incrementShield
	; CHECK FOR DUPLICATE SHIELDS
	LDA $7EF422 : !ADD #$08 : AND #$18 : TAX
	LDA $7EF422 : AND #$E7 : STA $7EF422
	TXA : ORA $7EF422 : STA $7EF422
RTS

.incrementBow
	CPY.b #$3B : BNE ++
		LDA $7EF42A : BIT #$20 : BEQ + : RTS : +
		ORA #$20 : STA $7EF42A
	++
.incrementY
	LDA $7EF421 : !ADD #$08 : STA $7EF421
RTS

.incrementA
	LDA $7EF421 : INC : AND #$07 : TAX
	LDA $7EF421 : AND #$F8 : STA $7EF421
	TXA : ORA $7EF421 : STA $7EF421
RTS

.incrementPendant
	LDA $7EF429 : INC : AND #$03 : TAX
	LDA $7EF429 : AND #$FC : STA $7EF429
	TXA : ORA $7EF429 : STA $7EF429
	; JSR .incrementBossSword
RTS

.incrementCapacity
	%BottomHalf($7EF452)
RTS

.incrementHeartPiece
	LDA $7EF448 : INC : AND #$1F : TAX
	LDA $7EF448 : AND #$E0 : STA $7EF448
	TXA : ORA $7EF448 : STA $7EF448
RTS

.incrementHeartContainer
	%TopHalf($7EF429)
RTS

.incrementCrystal
	LDA $7EF422 : INC : AND #$07 : TAX
	LDA $7EF422 : AND #$F8 : STA $7EF422
	TXA : ORA $7EF422 : STA $7EF422
	; JSR .incrementBossSword
RTS

.incrementMail
	LDA $7EF424 : !ADD #$40 : STA $7EF424
RTS

.incrementKeyLong
	JSR .incrementKey
RTL

.incrementKey
	PHA : PHX
		LDA $7EF424 : INC : AND #$3F : TAX
		LDA $7EF424 : AND #$C0 : STA $7EF424
		TXA : ORA $7EF424 : STA $7EF424
	PLX : PLA
RTS

.incrementCompass
	%BottomHalf($7EF428)
RTS

.incrementBigKey
	LDA $7EF427 : !ADD #$10 : STA $7EF427
RTS

.incrementGTowerPreBigKey
	LDA $7EF42A : INC : AND #$1F : TAX
	LDA $7EF42A : AND #$E0 : STA $7EF42A
	TXA : ORA $7EF42A : STA $7EF42A
RTS

.maybeIncrementBombs
	LDA $7EF42A : AND #$80 : BNE +
		LDA $7EF42A : ORA #$80 : STA $7EF42A
		JSR .incrementY
	+
RTS

.incrementMap
	LDA $7EF428 : !ADD #$10 : STA $7EF428
RTS

.incrementBossSwordLong
	JSR .incrementBossSword
RTL

.incrementBossSword
	LDA $7EF359
	BNE + : -
		%TopHalf($7EF452) : RTS
	+ CMP #$FF : BEQ -
	+ CMP #$01 : BNE +
		%TopHalf($7EF425) : RTS
	+ CMP #$02 : BNE +
		%BottomHalf($7EF425) : RTS
	+ CMP #$03 : BNE +
		%TopHalf($7EF426) : RTS
	+ CMP #$04 : BNE +
		%BottomHalf($7EF426)
	+
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Link_ReceiveItem_HUDRefresh:
;--------------------------------------------------------------------------------
Link_ReceiveItem_HUDRefresh:
	LDA $7EF343 : BNE + ; skip if we have bombs
	LDA $7EF375 : BEQ + ; skip if we are filling no bombs
		DEC : STA $7EF375 ; decrease bomb fill count
		LDA.b #$01 : STA $7EF343 ; increase actual bomb count
	+

	JSL.l HUD_RefreshIconLong ; thing we wrote over
	JSL.l PostItemGet
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; HandleBombAbsorbtion:
;--------------------------------------------------------------------------------
HandleBombAbsorbtion:
	STA $7EF375 ; thing we wrote over
	LDA $0303 : BNE + ; skip if we already have some item selected
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
		LDA !INVENTORY_SWAP : AND.w #$C0 : CMP.w #$C0 : BEQ .drawYBubble : BRA .drawNormal
	+ CMP.w #$01 : BNE + ; bow
		LDA !INVENTORY_SWAP_2 : AND.w #$C0 : CMP.w #$C0 : BEQ .drawYBubble : BRA .drawNormal
	+ CMP.w #$05 : BNE + ; powder
		LDA !INVENTORY_SWAP : AND.w #$30 : CMP.w #$30 : BEQ .drawYBubble : BRA .drawNormal
	+ CMP.w #$0D : BNE + ; flute
		LDA !INVENTORY_SWAP : BIT.w #$04 : BEQ .drawNormal ; make sure we have shovel
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
	LDA !INVENTORY_SWAP : AND #$FC : ORA #$01 : STA !INVENTORY_SWAP ; switch to the working flute
	LDA.b #$03 : STA $7EF34C ; upgrade primary inventory
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
		LDA $7EF38B
		RTL
	+
	LDA $7EF37C, X
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; SaveKeys:
;--------------------------------------------------------------------------------
SaveKeys:
	PHA
	LDA.l GenericKeys : BEQ +
		PLA : STA $7EF38B
		RTL
	+
	PLA : STA $7EF37C, X
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
		PLA : LDA $7EF38B : STA $7EF36F
		RTL
	+
	PLA : STA $7EF36F
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
	STA $7EF35C, X ; thing we wrote over
	PHA
		LDA $7EF34F : BNE +
			TXA : INC : STA $7EF34F ; write bottle index to menu properly
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
	LDA !INVENTORY_SWAP : AND #$DF : STA !INVENTORY_SWAP ; remove the mushroom
	AND #$10 : BEQ .empty ; check if we have powder
	LDA.b #$02 : STA $7EF344 ; give powder if we have it
RTL
	.empty
	LDA.b #$00 : STA $7EF344 ; clear the inventory slot if we don't have powder
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; DrawMagicHeader:
;--------------------------------------------------------------------------------
DrawMagicHeader:
	LDA $7EF37B : AND.w #$00FF : CMP.w #$0002 : BEQ .quarterMagic
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
;		LDA $7EF34C ; load shovel/flute item ID
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
		BRL .skip
	+

	LDA $035B : AND.b #$01 : BNE + : BRL .skip : + ; corner dig fix

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

		LDA .x_speeds, X : STA $0D50, Y

		LDA.b #$00 : STA $0D40, Y
		LDA.b #$18 : STA $0F80, Y
		LDA.b #$FF : STA $0B58, Y
		LDA.b #$30 : STA $0F10, Y

		LDA $22 : !ADD .x_offsets, X
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
