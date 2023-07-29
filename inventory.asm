;================================================================================
; Inventory Updates
;================================================================================
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
	LDA.l StatsLocked : BNE .done
        JSR.w ShopCheck : BCS .done
        JSR.w DungeonIncrement : BCS .done
                LDA.b #$7E : STA.b Scrap0D 
                JSR.w StampItem
                JSR.w IncrementByOne
                SEP #$20
                JSR.w IncrementYAItems
                LDA.w InventoryTable_properties,Y : BIT #$01 : BEQ .done
                        REP #$20
                        LDA.l TotalItemCounter : INC : TAY
                        LDA.l BootsEquipment : BNE +
                                TYA : STA.l PreBootsLocations
                        +
                        LDA.l MirrorEquipment : BNE +
                                TYA : STA.l PreMirrorLocations
                        +
                        LDA.l FluteEquipment : BNE +
                                TYA : STA.l PreFluteLocations
                        +
                        TYA
                        STA.l TotalItemCounter
        .done
	PLB : PLP : PLY : PLX : PLA
RTL

ShopCheck:
        LDA.b IndoorsFlag : BEQ .count
        LDA.w ItemReceiptMethod : CMP.b #$01 : BEQ .count
        LDA.w InventoryTable_properties,Y : BIT.b #$02 : BNE .count
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
RTS
        .nocount
        SEP #$21
RTS

DungeonIncrement:
	LDA.b IndoorsFlag : BEQ .count
	LDA.w DungeonID : CMP.b #$FF : BEQ .count

        CMP.l BallNChainDungeon : BNE +
		CPY.b #$32 : BEQ .ballchain_bigkey
	+
        CMP.b #$04 : BCS +
                LDA.l SewersLocations : INC : STA.l SewersLocations : STA.l HCLocations
                BRA .count
        +
        LSR : TAX : LDA.l DungeonLocationsChecked, X : INC : STA.l DungeonLocationsChecked, X
	CPX.b #$0D : BNE +
		LDA.l BigKeyField : BIT.b #$04 : BNE ++
                        LDA.l PreGTBKLocations : INC : STA.l PreGTBKLocations
		++
	+
        .count
        CLC
RTS
        .ballchain_bigkey
        LDA.l BigKeysBigChests
        CLC : ADC.b #$10
        STA.l BigKeysBigChests
        SEC
RTS

StampItem:
        REP #$30
        TYA : ASL : TAX
        LDA.w InventoryTable_stamp,X : BEQ .skip
                STA.b Scrap0B
                LDA.b [Scrap0B] : BNE .skip
                        LDA.l NMIFrames : STA.b [Scrap0B]
                        INC.b Scrap0B : INC.b Scrap0B
                        LDA.l NMIFrames+2 : STA.b [Scrap0B]
        .skip
RTS

IncrementYAItems:
         LDA.w InventoryTable_properties,Y
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
RTS
        .bow_check
        LDA.l BowEquipment : BNE +
                BRA .y_item
        +
RTS
        .bomb_check
	LDA.l InventoryTracking+1 : BIT.b #$02 : BNE +
		ORA.b #$02 : STA.l InventoryTracking+1
		BRA .y_item
	+
RTS

IncrementByOne:
        LDA.w InventoryTable_stat,X : BEQ .skip
                STA.b Scrap0B
                SEP #$20
                LDA.b #$01 : ADC.b [Scrap0B] : STA.b [Scrap0B]
        .skip
RTS

; Properties: - - w o a y s t
; t = Count for total item counter | s = Count for total in shops
; y = Y item                       | a = A item
; o = Bomb item                    | w = Bow item
InventoryTable:
	.properties : fillbyte $00   : fill 256   ; See above
	.stamp      : fillword $0000 : fill 256*2 ; Address to stamp with 32-bit time (bank $7E)
	.stat       : fillword $0000 : fill 256*2 ; Address to increment by one (bank $7E)

macro InventoryItem(id, props, stamp, stat)
	pushpc
	org InventoryTable_properties+<id> : db <props>
	org InventoryTable_stamp+(<id>*2) : dw <stamp>
	org InventoryTable_stat+(<id>*2) : dw <stat>
	pullpc
endmacro

%InventoryItem($00, $01, SwordTime, $0000) ; 00 - Fighter sword & Shield
%InventoryItem($01, $01, SwordTime, $0000) ; 01 - Master sword
%InventoryItem($02, $01, SwordTime, $0000) ; 02 - Tempered sword
%InventoryItem($03, $01, SwordTime, $0000) ; 03 - Butter sword
%InventoryItem($04, $01, $0000, $0000) ; 04 - Fighter shield
%InventoryItem($05, $01, $0000, $0000) ; 05 - Fire shield
%InventoryItem($06, $01, $0000, $0000) ; 06 - Mirror shield
%InventoryItem($07, $05, $0000, $0000) ; 07 - Fire rod
%InventoryItem($08, $05, $0000, $0000) ; 08 - Ice rod
%InventoryItem($09, $05, $0000, $0000) ; 09 - Hammer
%InventoryItem($0A, $05, $0000, $0000) ; 0A - Hookshot
%InventoryItem($0B, $25, $0000, $0000) ; 0B - Bow
%InventoryItem($0C, $05, $0000, $0000) ; 0C - Blue Boomerang
%InventoryItem($0D, $05, $0000, $0000) ; 0D - Powder
%InventoryItem($0E, $01, $0000, $0000) ; 0E - Bottle refill (bee)
%InventoryItem($0F, $05, $0000, $0000) ; 0F - Bombos
%InventoryItem($10, $05, $0000, $0000) ; 10 - Ether
%InventoryItem($11, $05, $0000, $0000) ; 11 - Quake
%InventoryItem($12, $05, $0000, $0000) ; 12 - Lamp
%InventoryItem($13, $05, $0000, $0000) ; 13 - Shovel
%InventoryItem($14, $05, FluteTime, $0000) ; 14 - Flute (inactive)
%InventoryItem($15, $05, $0000, $0000) ; 15 - Somaria
%InventoryItem($16, $05, $0000, $0000) ; 16 - Bottle
%InventoryItem($17, $01, $0000, HeartPieceCounter) ; 17 - Heart piece
%InventoryItem($18, $05, $0000, $0000) ; 18 - Byrna
%InventoryItem($19, $05, $0000, $0000) ; 19 - Cape
%InventoryItem($1A, $05, MirrorTime, $0000) ; 1A - Mirror
%InventoryItem($1B, $09, $0000, $0000) ; 1B - Glove
%InventoryItem($1C, $09, $0000, $0000) ; 1C - Mitts
%InventoryItem($1D, $05, $0000, $0000) ; 1D - Book
%InventoryItem($1E, $09, $0000, $0000) ; 1E - Flippers
%InventoryItem($1F, $01, $0000, $0000) ; 1F - Pearl
%InventoryItem($20, $00, $0000, CrystalCounter) ; 20 - Crystal
%InventoryItem($21, $05, $0000, $0000) ; 21 - Net
%InventoryItem($22, $01, $0000, $0000) ; 22 - Blue mail
%InventoryItem($23, $01, $0000, $0000) ; 23 - Red mail
%InventoryItem($24, $01, $0000, SmallKeyCounter) ; 24 - Small key
%InventoryItem($25, $01, $0000, $0000) ; 25 - Compass
%InventoryItem($26, $00, $0000, $0000) ; 26 - Heart container from 4/4
%InventoryItem($27, $15, $0000, $0000) ; 27 - Bomb
%InventoryItem($28, $15, $0000, $0000) ; 28 - 3 bombs
%InventoryItem($29, $05, $0000, $0000) ; 29 - Mushroom
%InventoryItem($2A, $05, $0000, $0000) ; 2A - Red boomerang
%InventoryItem($2B, $05, $0000, $0000) ; 2B - Full bottle (red)
%InventoryItem($2C, $05, $0000, $0000) ; 2C - Full bottle (green)
%InventoryItem($2D, $05, $0000, $0000) ; 2D - Full bottle (blue)
%InventoryItem($2E, $00, $0000, $0000) ; 2E - Potion refill (red)
%InventoryItem($2F, $00, $0000, $0000) ; 2F - Potion refill (green)
%InventoryItem($30, $00, $0000, $0000) ; 30 - Potion refill (blue)
%InventoryItem($31, $11, $0000, $0000) ; 31 - 10 bombs
%InventoryItem($32, $01, $0000, $0000) ; 32 - Big key
%InventoryItem($33, $01, $0000, $0000) ; 33 - Map
%InventoryItem($34, $01, $0000, $0000) ; 34 - 1 rupee
%InventoryItem($35, $01, $0000, $0000) ; 35 - 5 rupees
%InventoryItem($36, $01, $0000, $0000) ; 36 - 20 rupees
%InventoryItem($37, $00, $0000, PendantCounter) ; 37 - Green pendant
%InventoryItem($38, $00, $0000, PendantCounter) ; 38 - Blue pendant
%InventoryItem($39, $00, $0000, PendantCounter) ; 39 - Red pendant
%InventoryItem($3A, $25, $0000, $0000) ; 3A - Bow And Arrows
%InventoryItem($3B, $25, $0000, $0000) ; 3B - Silver Bow
%InventoryItem($3C, $05, $0000, $0000) ; 3C - Full bottle (bee)
%InventoryItem($3D, $05, $0000, $0000) ; 3D - Full bottle (fairy)
%InventoryItem($3E, $01, $0000, HeartContainerCounter) ; 3E - Boss heart
%InventoryItem($3F, $01, $0000, HeartContainerCounter) ; 3F - Sanc heart
%InventoryItem($40, $01, $0000, $0000) ; 40 - 100 rupees
%InventoryItem($41, $01, $0000, $0000) ; 41 - 50 rupees
%InventoryItem($42, $01, $0000, $0000) ; 42 - Heart
%InventoryItem($43, $01, $0000, $0000) ; 43 - Arrow
%InventoryItem($44, $01, $0000, $0000) ; 44 - 10 arrows
%InventoryItem($45, $01, $0000, $0000) ; 45 - Small magic
%InventoryItem($46, $01, $0000, $0000) ; 46 - 300 rupees
%InventoryItem($47, $01, $0000, $0000) ; 47 - 20 rupees green
%InventoryItem($48, $05, $0000, $0000) ; 48 - Full bottle (good bee)
%InventoryItem($49, $01, $0000, $0000) ; 49 - Tossed fighter sword
%InventoryItem($4A, $05, FluteTime, $0000) ; 4A - Active Flute
%InventoryItem($4B, $09, BootsTime, $0000) ; 4B - Boots
%InventoryItem($4C, $15, $0000, CapacityUpgrades) ; 4C - Bomb capacity (50)
%InventoryItem($4D, $01, $0000, CapacityUpgrades) ; 4D - Arrow capacity (70)
%InventoryItem($4E, $01, $0000, CapacityUpgrades) ; 4E - 1/2 magic
%InventoryItem($4F, $01, $0000, CapacityUpgrades) ; 4F - 1/4 magic
%InventoryItem($50, $01, SwordTime, $0000) ; 50 - Master Sword (safe)
%InventoryItem($51, $15, $0000, CapacityUpgrades) ; 51 - Bomb capacity (+5)
%InventoryItem($52, $15, $0000, CapacityUpgrades) ; 52 - Bomb capacity (+10)
%InventoryItem($53, $01, $0000, CapacityUpgrades) ; 53 - Arrow capacity (+5)
%InventoryItem($54, $01, $0000, CapacityUpgrades) ; 54 - Arrow capacity (+10)
%InventoryItem($55, $01, $0000, $0000) ; 55 - Programmable item 1
%InventoryItem($56, $01, $0000, $0000) ; 56 - Programmable item 2
%InventoryItem($57, $01, $0000, $0000) ; 57 - Programmable item 3
%InventoryItem($58, $01, $0000, $0000) ; 58 - Upgrade-only Silver Arrows
%InventoryItem($59, $01, $0000, $0000) ; 59 - Rupoor
%InventoryItem($5A, $01, $0000, $0000) ; 5A - Nothing
%InventoryItem($5B, $01, $0000, $0000) ; 5B - Red clock
%InventoryItem($5C, $01, $0000, $0000) ; 5C - Blue clock
%InventoryItem($5D, $01, $0000, $0000) ; 5D - Green clock
%InventoryItem($5E, $01, $0000, $0000) ; 5E - Progressive sword
%InventoryItem($5F, $01, $0000, $0000) ; 5F - Progressive shield
%InventoryItem($60, $01, $0000, $0000) ; 60 - Progressive armor
%InventoryItem($61, $09, $0000, $0000) ; 61 - Progressive glove
%InventoryItem($62, $01, $0000, $0000) ; 62 - RNG pool item (single)
%InventoryItem($63, $01, $0000, $0000) ; 63 - RNG pool item (multi)
%InventoryItem($64, $25, $0000, $0000) ; 64 - Progressive bow
%InventoryItem($65, $25, $0000, $0000) ; 65 - Progressive bow
%InventoryItem($66, $01, $0000, $0000) ; 66 - 
%InventoryItem($67, $01, $0000, $0000) ; 67 - 
%InventoryItem($68, $01, $0000, $0000) ; 68 - 
%InventoryItem($69, $01, $0000, $0000) ; 69 - 
%InventoryItem($6A, $01, $0000, $0000) ; 6A - Triforce
%InventoryItem($6B, $01, $0000, $0000) ; 6B - Power star
%InventoryItem($6C, $01, $0000, $0000) ; 6C - Triforce Piece
%InventoryItem($6D, $01, $0000, $0000) ; 6D - Server request item
%InventoryItem($6E, $01, $0000, $0000) ; 6E - Server request item (dungeon drop)
%InventoryItem($6F, $01, $0000, $0000) ; 6F - 
%InventoryItem($70, $01, $0000, $0000) ; 70 - Map of Light World
%InventoryItem($71, $01, $0000, $0000) ; 71 - Map of Dark World
%InventoryItem($72, $01, $0000, $0000) ; 72 - Map of Ganon's Tower
%InventoryItem($73, $01, $0000, $0000) ; 73 - Map of Turtle Rock
%InventoryItem($74, $01, $0000, $0000) ; 74 - Map of Thieves' Town
%InventoryItem($75, $01, $0000, $0000) ; 75 - Map of Tower of Hera
%InventoryItem($76, $01, $0000, $0000) ; 76 - Map of Ice Palace
%InventoryItem($77, $01, $0000, $0000) ; 77 - Map of Skull Woods
%InventoryItem($78, $01, $0000, $0000) ; 78 - Map of Misery Mire
%InventoryItem($79, $01, $0000, $0000) ; 79 - Map of Dark Palace
%InventoryItem($7A, $01, $0000, $0000) ; 7A - Map of Swamp Palace
%InventoryItem($7B, $01, $0000, $0000) ; 7B - Map of Agahnim's Tower
%InventoryItem($7C, $01, $0000, $0000) ; 7C - Map of Desert Palace
%InventoryItem($7D, $01, $0000, $0000) ; 7D - Map of Eastern Palace
%InventoryItem($7E, $01, $0000, $0000) ; 7E - Map of Hyrule Castle
%InventoryItem($7F, $01, $0000, $0000) ; 7F - Map of Sewers
%InventoryItem($80, $01, $0000, $0000) ; 80 - Compass of Light World
%InventoryItem($81, $01, $0000, $0000) ; 81 - Compass of Dark World
%InventoryItem($82, $01, $0000, $0000) ; 82 - Compass of Ganon's Tower
%InventoryItem($83, $01, $0000, $0000) ; 83 - Compass of Turtle Rock
%InventoryItem($84, $01, $0000, $0000) ; 84 - Compass of Thieves' Town
%InventoryItem($85, $01, $0000, $0000) ; 85 - Compass of Tower of Hera
%InventoryItem($86, $01, $0000, $0000) ; 86 - Compass of Ice Palace
%InventoryItem($87, $01, $0000, $0000) ; 87 - Compass of Skull Woods
%InventoryItem($88, $01, $0000, $0000) ; 88 - Compass of Misery Mire
%InventoryItem($89, $01, $0000, $0000) ; 89 - Compass of Dark Palace
%InventoryItem($8A, $01, $0000, $0000) ; 8A - Compass of4Swamp Palace
%InventoryItem($8B, $01, $0000, $0000) ; 8B - Compass of Agahnim's Tower
%InventoryItem($8C, $01, $0000, $0000) ; 8C - Compass of Desert Palace
%InventoryItem($8D, $01, $0000, $0000) ; 8D - Compass of Eastern Palace
%InventoryItem($8E, $01, $0000, $0000) ; 8E - Compass of Hyrule Castle
%InventoryItem($8F, $01, $0000, $0000) ; 8F - Compass of Sewers
%InventoryItem($90, $01, $0000, $0000) ; 90 - Skull key
%InventoryItem($91, $01, $0000, $0000) ; 91 - Reserved
%InventoryItem($92, $01, $0000, $0000) ; 92 - Big key of Ganon's Tower
%InventoryItem($93, $01, $0000, $0000) ; 93 - Big key of Turtle Rock
%InventoryItem($94, $01, $0000, $0000) ; 94 - Big key of Thieves' Town
%InventoryItem($95, $01, $0000, $0000) ; 95 - Big key of Tower of Hera
%InventoryItem($96, $01, $0000, $0000) ; 96 - Big key of Ice Palace
%InventoryItem($97, $01, $0000, $0000) ; 97 - Big key of Skull Woods
%InventoryItem($98, $01, $0000, $0000) ; 98 - Big key of Misery Mire
%InventoryItem($99, $01, $0000, $0000) ; 99 - Big key of Dark Palace
%InventoryItem($9A, $01, $0000, $0000) ; 9A - Big key of Swamp Palace
%InventoryItem($9B, $01, $0000, $0000) ; 9B - Big key of Agahnim's Tower
%InventoryItem($9C, $01, $0000, $0000) ; 9C - Big key of Desert Palace
%InventoryItem($9D, $01, $0000, $0000) ; 9D - Big key of Eastern Palace
%InventoryItem($9E, $01, $0000, $0000) ; 9E - Big key of Hyrule Castle
%InventoryItem($9F, $01, $0000, $0000) ; 9F - Big key of Sewers
%InventoryItem($A0, $01, $0000, SmallKeyCounter) ; A0 - Small key of Sewers
%InventoryItem($A1, $01, $0000, SmallKeyCounter) ; A1 - Small key of Hyrule Castle
%InventoryItem($A2, $01, $0000, SmallKeyCounter) ; A2 - Small key of Eastern Palace
%InventoryItem($A3, $01, $0000, SmallKeyCounter) ; A3 - Small key of Desert Palace
%InventoryItem($A4, $01, $0000, SmallKeyCounter) ; A4 - Small key of Agahnim's Tower
%InventoryItem($A5, $01, $0000, SmallKeyCounter) ; A5 - Small key of Swamp Palace
%InventoryItem($A6, $01, $0000, SmallKeyCounter) ; A6 - Small key of Dark Palace
%InventoryItem($A7, $01, $0000, SmallKeyCounter) ; A7 - Small key of Misery Mire
%InventoryItem($A8, $01, $0000, SmallKeyCounter) ; A8 - Small key of Skull Woods
%InventoryItem($A9, $01, $0000, SmallKeyCounter) ; A9 - Small key of Ice Palace
%InventoryItem($AA, $01, $0000, SmallKeyCounter) ; AA - Small key of Tower of Hera
%InventoryItem($AB, $01, $0000, SmallKeyCounter) ; AB - Small key of Thieves' Town
%InventoryItem($AC, $01, $0000, SmallKeyCounter) ; AC - Small key of Turtle Rock
%InventoryItem($AD, $01, $0000, SmallKeyCounter) ; AD - Small key of Ganon's Tower
%InventoryItem($AE, $01, $0000, $0000) ; AE - Reserved
%InventoryItem($AF, $01, $0000, SmallKeyCounter) ; AF - Generic small key
%InventoryItem($B0, $01, $0000, $0000) ; B0 - 
%InventoryItem($B1, $01, $0000, $0000) ; B1 - 
%InventoryItem($B2, $01, $0000, $0000) ; B2 - 
%InventoryItem($B3, $01, $0000, $0000) ; B3 - 
%InventoryItem($B4, $01, $0000, $0000) ; B4 - 
%InventoryItem($B5, $01, $0000, $0000) ; B5 - 
%InventoryItem($B6, $01, $0000, $0000) ; B6 - 
%InventoryItem($B7, $01, $0000, $0000) ; B7 - 
%InventoryItem($B8, $01, $0000, $0000) ; B8 - 
%InventoryItem($B9, $01, $0000, $0000) ; B9 - 
%InventoryItem($BA, $01, $0000, $0000) ; BA - 
%InventoryItem($BB, $01, $0000, $0000) ; BB - 
%InventoryItem($BC, $01, $0000, $0000) ; BC - 
%InventoryItem($BD, $01, $0000, $0000) ; BD - 
%InventoryItem($BE, $01, $0000, $0000) ; BE - 
%InventoryItem($BF, $01, $0000, $0000) ; BF - 
%InventoryItem($C0, $01, $0000, $0000) ; C0 - 
%InventoryItem($C1, $01, $0000, $0000) ; C1 - 
%InventoryItem($C2, $01, $0000, $0000) ; C2 - 
%InventoryItem($C3, $01, $0000, $0000) ; C3 - 
%InventoryItem($C4, $01, $0000, $0000) ; C4 - 
%InventoryItem($C5, $01, $0000, $0000) ; C5 - 
%InventoryItem($C6, $01, $0000, $0000) ; C6 - 
%InventoryItem($C7, $01, $0000, $0000) ; C7 - 
%InventoryItem($C8, $01, $0000, $0000) ; C8 - 
%InventoryItem($C9, $01, $0000, $0000) ; C9 - 
%InventoryItem($CA, $01, $0000, $0000) ; CA - 
%InventoryItem($CB, $01, $0000, $0000) ; CB - 
%InventoryItem($CC, $01, $0000, $0000) ; CC - 
%InventoryItem($CD, $01, $0000, $0000) ; CD - 
%InventoryItem($CE, $01, $0000, $0000) ; CE - 
%InventoryItem($CF, $01, $0000, $0000) ; CF - 
%InventoryItem($D0, $01, $0000, $0000) ; D0 - 
%InventoryItem($D1, $01, $0000, $0000) ; D1 - 
%InventoryItem($D2, $01, $0000, $0000) ; D2 - 
%InventoryItem($D3, $01, $0000, $0000) ; D3 - 
%InventoryItem($D4, $01, $0000, $0000) ; D4 - 
%InventoryItem($D5, $01, $0000, $0000) ; D5 - 
%InventoryItem($D6, $01, $0000, $0000) ; D6 - 
%InventoryItem($D7, $01, $0000, $0000) ; D7 - 
%InventoryItem($D8, $01, $0000, $0000) ; D8 - 
%InventoryItem($D9, $01, $0000, $0000) ; D9 - 
%InventoryItem($DA, $01, $0000, $0000) ; DA - 
%InventoryItem($DB, $01, $0000, $0000) ; DB - 
%InventoryItem($DC, $01, $0000, $0000) ; DC - 
%InventoryItem($DD, $01, $0000, $0000) ; DD - 
%InventoryItem($DE, $01, $0000, $0000) ; DE - 
%InventoryItem($DF, $01, $0000, $0000) ; DF - 
%InventoryItem($E0, $01, $0000, $0000) ; E0 - 
%InventoryItem($E1, $01, $0000, $0000) ; E1 - 
%InventoryItem($E2, $01, $0000, $0000) ; E2 - 
%InventoryItem($E3, $01, $0000, $0000) ; E3 - 
%InventoryItem($E4, $01, $0000, $0000) ; E4 - 
%InventoryItem($E5, $01, $0000, $0000) ; E5 - 
%InventoryItem($E6, $01, $0000, $0000) ; E6 - 
%InventoryItem($E7, $01, $0000, $0000) ; E7 - 
%InventoryItem($E8, $01, $0000, $0000) ; E8 - 
%InventoryItem($E9, $01, $0000, $0000) ; E9 - 
%InventoryItem($EA, $01, $0000, $0000) ; EA - 
%InventoryItem($EB, $01, $0000, $0000) ; EB - 
%InventoryItem($EC, $01, $0000, $0000) ; EC - 
%InventoryItem($ED, $01, $0000, $0000) ; ED - 
%InventoryItem($EE, $01, $0000, $0000) ; EE - 
%InventoryItem($EF, $01, $0000, $0000) ; EF - 
%InventoryItem($F0, $01, $0000, $0000) ; F0 - 
%InventoryItem($F1, $01, $0000, $0000) ; F1 - 
%InventoryItem($F2, $01, $0000, $0000) ; F2 - 
%InventoryItem($F3, $01, $0000, $0000) ; F3 - 
%InventoryItem($F4, $01, $0000, $0000) ; F4 - 
%InventoryItem($F5, $01, $0000, $0000) ; F5 - 
%InventoryItem($F6, $01, $0000, $0000) ; F6 - 
%InventoryItem($F7, $01, $0000, $0000) ; F7 - 
%InventoryItem($F8, $01, $0000, $0000) ; F8 - 
%InventoryItem($F9, $01, $0000, $0000) ; F9 - 
%InventoryItem($FA, $01, $0000, $0000) ; FA - 
%InventoryItem($FB, $01, $0000, $0000) ; FB - 
%InventoryItem($FC, $01, $0000, $0000) ; FC - 
%InventoryItem($FD, $01, $0000, $0000) ; FD - 
%InventoryItem($FE, $01, $0000, $0000) ; FE - Server request (async)
%InventoryItem($FF, $01, $0000, $0000) ; FF -

IncrementBossSword:
        PHX
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

SetDungeonCompletion:
; TODO: move this
        LDX.w DungeonID : BMI +
                REP #$20
                LDA.l DungeonMask, X : ORA.l DungeonsCompleted : STA.l DungeonsCompleted
                SEP #$20
        +
RTS

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
