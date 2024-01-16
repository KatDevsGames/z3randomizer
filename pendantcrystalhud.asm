;================================================================================
; Pendant / Crystal HUD Fix
;--------------------------------------------------------------------------------
;================================================================================
FlipLWDWFlag:
	PHP
	SEP #$20 ; set 8-bit accumulator
	LDA.l CurrentWorld : EOR.b #$40 : STA.l CurrentWorld
	BEQ +
		LDA.b #07 : BRA ++ ; dark world - crystals
	+ 
		LDA.b #03 ; light world - pendants
	++
	STA.l MapIcons
	PLP
RTL
;================================================================================
HUDRebuildIndoorHole:
	PHA
	LDA.b #$01 : STA.l UpdateHUDFlag
	LDA.l GenericKeys : BEQ .normal
	.generic
	PLA
	LDA.l CurrentGenericKeys ; generic key count
        JSL.l HUD_RebuildIndoor_Palace
RTL
	.normal
	PLA
        JSL.l HUD_RebuildIndoor_Palace
RTL
;================================================================================
HUDRebuildIndoor:
	LDA.b #$01 : STA.l UpdateHUDFlag
	LDA.l GenericKeys : BEQ .normal
	.generic
	LDA.b #$00 : STA.l RoomDarkness
	LDA.l CurrentGenericKeys ; generic key count
RTL
	.normal
    LDA.b #$00 : STA.l RoomDarkness
    LDA.b #$FF ; don't show keys
RTL
;================================================================================
GetCrystalNumber:
	PHX
		TXA : ASL : TAX
		LDA.l CurrentWorld : EOR.b #$40 : BNE +
			INX
		+
		LDA.l CrystalNumberTable-16, X
	PLX
RTL
;================================================================================
SetLWDWMap:
	PHP
	SEP #$20 ; set 8-bit accumulator
	LDA.l CurrentWorld : EOR.b #$40
	BNE +
		LDA.b #07 : BRA ++ ; dark world - crystals
	+ 
		LDA.b #03 ; light world - pendants
	++
	STA.l MapIcons
	PLP
RTL
;================================================================================
GetMapMode:
	LDA.l CurrentWorld : AND.b #$40 : BEQ +
		LDA.b #07 ; dark world - crystals
RTL
	+ 
		LDA.b #03 ; light world - pendants
RTL
;================================================================================
BringMenuDownEnhanced:
	REP #$20 ; set 16-bit accumulator
		LDA.l TournamentSeed : AND.w #$00FF
		BEQ +
			LDA.w #$0008 : BRA ++ ; use default speed on tournament seeds
		+
			LDA.l MenuSpeed
		++

		EOR.w #$FFFF : !ADD.w #$0001 ; negate menu speed

		!ADD BG3VOFSQL : CMP.w #$FF18 : !BGE .noOvershoot
			LDA.w #$FF18 ; if we went past the limit, go to the limit
		.noOvershoot
		STA.b BG3VOFSQL : CMP.w #$FF18
	SEP #$20 ; set 8-bit accumulator
	BNE .notDoneScrolling
		INC.w SubModuleInterface
	.notDoneScrolling
RTL
;================================================================================
RaiseHudMenu:
	LDA.l TournamentSeed : AND.w #$00FF
	BEQ +
		LDA.w #$0008 : BRA ++ ; use default speed on tournament seeds
	+
		LDA.l MenuSpeed : AND.w #$00FF
	++

	!ADD BG3VOFSQL : BMI .noOvershoot
		LDA.w #$0000 ; if we went past the limit, go to the limit
	.noOvershoot
	STA.b BG3VOFSQL
RTL
;================================================================================
CheckCloseItemMenu:
	LDA.l MenuCollapse : BNE + 
		LDA.b Joy1A_New : AND.b #$10 : RTL
	+
	LDA.b Joy1A_All : EOR.b #$10
RTL
;================================================================================
ShowDungeonItems:
	LDA.w DungeonID-1 : BMI .no_dungeon
	        LDA.l HudFlag : AND.w #$0040 : BEQ +
                        .no_dungeon
                        LDA.w #$0000
                        RTL
                +
	        LDA.w DungeonID 
                REP #$02
        .done
RTL
;--------------------------------------------------------------------------------
UpdateKeys:
        PHX : PHP
        SEP #$30
        LDA.l GenericKeys : BNE .skip
        LDA.w DungeonID : CMP.b #$1F : BCS .skip	
                LSR : TAX
                LDA.l CurrentSmallKeys
                CPX.b #$02 : BCC .castle_sewers
                        STA.l DungeonKeys, X
                        BRA .skip
                .castle_sewers
                STA.l HyruleCastleKeys : STA.l SewerKeys
        .skip
        JSL.l PostItemGet
        PLP : PLX
RTL
;$37C = Sewer Passage
;$37D = Hyrule Castle
;$37E = Eastern Palace
;$37F = Desert Palace
;$380 = Hyrule Castle 2
;$381 = Swamp Palace
;$382 = Dark Palace
;$383 = Misery Mire
;$384 = Skull Woods
;$385 = Ice Palace
;$386 = Tower of Hera
;$387 = Gargoyle's Domain
;$388 = Turtle Rock
;$389 = Ganon's Tower
;--------------------------------------------------------------------------------
DrawBootsInMenuLocation:
	LDA.l HUDDungeonItems : BNE +
		LDA.w #$1608 : STA.b Scrap00
		RTL
	+
	LDA.w #$1588 : STA.b Scrap00
RTL
;--------------------------------------------------------------------------------
DrawGlovesInMenuLocation:
	LDA.l HUDDungeonItems : BNE +
		LDA.w #$1610 : STA.b Scrap00
		RTL
	+
	LDA.w #$1590 : STA.b Scrap00
RTL
;--------------------------------------------------------------------------------
DrawFlippersInMenuLocation:
	LDA.l HUDDungeonItems : BNE +
		LDA.w #$1618 : STA.b Scrap00
		RTL
	+
	LDA.w #$1598 : STA.b Scrap00
RTL
;--------------------------------------------------------------------------------
DrawMoonPearlInMenuLocation:
	LDA.l HUDDungeonItems : BNE +
		LDA.w #$1620 : STA.b Scrap00
		RTL
	+
	LDA.w #$15A0 : STA.b Scrap00
RTL
;--------------------------------------------------------------------------------
DrawHUDDungeonItems:
	LDA.l HUDDungeonItems : BNE .continue
RTL

.dungeon_positions
		dw  0 ; Hyrule Castle
		dw  6 ; Eastern
		dw  8 ; Desert
		dw 10 ; Hera
		dw  2 ; Agahnims Tower
		dw 14 ; PoD
		dw 16 ; Swamp
		dw 18 ; Skull Woods
		dw 20 ; Thieves Town
		dw 22 ; Ice
		dw 24 ; Mire
		dw 26 ; Turtle Rock
		dw 30 ; Ganon's Tower

.small_key_x_offset
		dw HyruleCastleKeys-DungeonKeys ; Hyrule Castle
		dw EasternKeys-DungeonKeys ; Eastern
		dw DesertKeys-DungeonKeys ; Desert
		dw HeraKeys-DungeonKeys ; Hera
		dw CastleTowerKeys-DungeonKeys ; Agahnims Tower
		dw PalaceOfDarknessKeys-DungeonKeys ; PoD
		dw SwampKeys-DungeonKeys ; Swamp
		dw SkullWoodsKeys-DungeonKeys ; Skull Woods
		dw ThievesTownKeys-DungeonKeys ; Thieves Town
		dw IcePalaceKeys-DungeonKeys ; Ice
		dw MireKeys-DungeonKeys ; Mire
		dw TurtleRockKeys-DungeonKeys ; Turtle Rock
		dw GanonsTowerKeys-DungeonKeys ; Ganon's Tower


.dungeon_bitmasks
		dw $C000 ; Hyrule Castle
		dw $2000 ; Eastern
		dw $1000 ; Desert
		dw $0020 ; Hera
		dw $0800 ; Agahnims Tower
		dw $0200 ; PoD
		dw $0400 ; Swamp
		dw $0080 ; Skull Woods
		dw $0010 ; Thieves Town
		dw $0040 ; Ice
		dw $0100 ; Mire
		dw $0008 ; Turtle Rock
		dw $0004 ; Ganon's Tower

.boss_room_ids
		dw $80*2 ; ; Hyrule Castle (BNC)
		dw $C8*2 ; ; Eastern
		dw $33*2 ; ; Desert
		dw $07*2 ; ; Hera
		dw $20*2 ; ; Agahnim
		dw $5A*2 ; ; PoD
		dw $06*2 ; ; Swamp
		dw $29*2 ; ; Skull Woods
		dw $AC*2 ; ; Thieves Town
		dw $DE*2 ; ; Ice
		dw $90*2 ; ; Mire
		dw $A4*2 ; ; Turtle Rock
		dw $0D*2 ; ; Ganon's Tower

        .continue
        PHP : PHB
        PHK : PLB
        REP #$30
;-------------------------------------------------------------------------------
	; dungeon names
	LDA.w #$2D50
	LDY.w #00

        .next_dungeon_name
	LDX.w .dungeon_positions,Y
	STA.w GFXStripes+$0646,X
	INC
	INY : INY
	CPY.w #26 : BCC .next_dungeon_name

	; write black
	LDX.w #$001E
	LDA.w #$24F5

--	STA.w GFXStripes+$0686,X
	STA.w GFXStripes+$06C6,X
	STA.w GFXStripes+$0706,X

	DEX : DEX
        BPL --

	LDA.l HudFlag : AND.w #$0020 : BEQ +
	        JMP .maps_and_compasses
;-------------------------------------------------------------------------------
        +
	LDA.l HUDDungeonItems : AND.w #$0001 : BNE +
                LDA.w #$24F5 : STA.w GFXStripes+$0684 ; blank tile
                BRA .skip_small_keys
        +
        .draw_small_keys
        LDA.w #$2810 : STA.w GFXStripes+$0684 ; small keys icon
        LDY.w #0
        CLC

        .next_small_key
	LDX.w .small_key_x_offset,Y
	LDA.l DungeonKeys,X
	AND.w #$00FF

	LDX.w .dungeon_positions,Y
	ADC.w #$2816
	STA.w GFXStripes+$0686,X

	INY : INY
	CPY.w #26 : BCC .next_small_key

;-------------------------------------------------------------------------------

        .skip_small_keys
        ; Big Keys
        LDA.l HUDDungeonItems : AND.w #$0002 : BNE +
                LDA.w #$24F5 : STA.w GFXStripes+$06C4 ; blank tile
                BRA .skip_big_keys
        +
        LDA.w #$2811 : STA.w GFXStripes+$06C4 ; big key icon
        LDX.w #0
        LDA.l BigKeyField

        .next_big_key
        BIT.w .dungeon_bitmasks,X
        BEQ ..skip_key

        LDY.w .dungeon_positions,X
        LDA.w #$2826
        STA.w GFXStripes+$06C6,Y
        LDA.l BigKeyField

        ..skip_key
        INX : INX
        CPX.w #26 : BCC .next_big_key

;-------------------------------------------------------------------------------

        .skip_big_keys
        LDA.l HUDDungeonItems : AND.w #$0010 : BNE +
                LDA.w #$24F5 : STA.w GFXStripes+$0704 ; blank tile
                BRA .skip_boss_kills
        +
        LDA.w #$280F : STA.w GFXStripes+$0704 ; skull icon
        LDY.w #0

        .next_boss_kill
        LDX.w .boss_room_ids,Y
        LDA.l RoomDataWRAM.l,X
        AND.w #$0800
        BEQ ..skip_boss_kill
                LDA.w #$2826
                LDX.w .dungeon_positions,Y
                STA.w GFXStripes+$0706,X
        ..skip_boss_kill
        INY : INY
        CPY.w #26 : BCC .next_boss_kill

;-------------------------------------------------------------------------------
        .skip_boss_kills
        LDA.l HUDDungeonItems : BIT.w #$00F3 : BEQ .maps_and_compasses
                JMP .exit
;-------------------------------------------------------------------------------
        .maps_and_compasses
        LDA.w #$24F5 : STA.w GFXStripes+$0704 ; blank tile boss icon
        ; Maps
        LDA.l HUDDungeonItems : AND.w #$0004 : BNE +
                LDA.w #$24F5 : STA.w GFXStripes+$0684 ; map icon
                BRA .skip_maps
        +
        LDA.w #$2821 : STA.w GFXStripes+$0684 ; map icon
        LDX.w #0
        LDA.l MapField

        .next_map
        BIT.w .dungeon_bitmasks,X
        BEQ ..skip_map

        LDY.w .dungeon_positions,X
        LDA.w #$2826
        STA.w GFXStripes+$0686,Y
        LDA.l MapField

        ..skip_map
        INX : INX
        CPX.w #26 : BCC .next_map

        .skip_maps
        LDA.l HUDDungeonItems : AND.w #$0008 : BNE +
                LDA.w #$24F5 : STA.w GFXStripes+$06C4 ; blank tile
                BRA .skip_compasses
        +
        LDA.w #$2C20 : STA.w GFXStripes+$06C4 ; compass icon
        LDX.w #0
        LDA.l CompassField

        .next_compass
        BIT.w .dungeon_bitmasks,X
        BEQ ..skip_compass

        LDY.w .dungeon_positions,X
        LDA.w #$2826
        STA.w GFXStripes+$06C6,Y
        LDA.l CompassField

        ..skip_compass
        INX : INX
        CPX.w #26 : BCC .next_compass

;-------------------------------------------------------------------------------

        .skip_compasses
        .exit
        PLB
        PLP
RTL
;--------------------------------------------------------------------------------
;================================================================================
DrawPendantCrystalDiagram:
	PHP : PHB : PHK : PLB
		REP #$30 ; Set 16-bit accumulator & index registers
		LDX.w #$0000 ; Paint entire box black & draw empty pendants and crystals
		-
		LDA.l .row0, X : STA.w GFXStripes+$02EA, X
		LDA.l .row1, X : STA.w GFXStripes+$032A, X
		LDA.l .row2, X : STA.w GFXStripes+$036A, X
		LDA.l .row3, X : STA.w GFXStripes+$03AA, X
		LDA.l .row4, X : STA.w GFXStripes+$03EA, X
		LDA.l .row5, X : STA.w GFXStripes+$042A, X
		LDA.l .row6, X : STA.w GFXStripes+$046A, X
		LDA.l .row7, X : STA.w GFXStripes+$04AA, X
		LDA.l .row8, X : STA.w GFXStripes+$04EA, X
		INX #2 : CPX.w #$0014 : BCC -
		
		; pendants
		LDA.l PendantsField

		  LSR : BCC + ; pendant of wisdom (red)
			LDX.w #$252B
			STX.w GFXStripes+$03B6
			INX : STX.w GFXStripes+$03B8
			INX : STX.w GFXStripes+$03F6
			INX : STX.w GFXStripes+$03F8

		+ LSR : BCC + ; pendant of power (blue)
			LDX.w #$2D2B
			STX.w GFXStripes+$03AE
			INX : STX.w GFXStripes+$03B0
			INX : STX.w GFXStripes+$03EE
			INX : STX.w GFXStripes+$03F0

		+ LSR : BCC + ; pendant of courage (green)
			LDX.w #$3D2B
			STX.w GFXStripes+$0332
			INX : STX.w GFXStripes+$0334
			INX : STX.w GFXStripes+$0372
			INX : STX.w GFXStripes+$0374
		+
		; crystals
		LDA.l CrystalsField
		LDX.w #$2D44
		LDY.w #$2D45

		  BIT.w #$0002 : BEQ + ; crystal 1
			STX.w GFXStripes+$04AC
			STY.w GFXStripes+$04AE
		+ BIT.w #$0010 : BEQ + ; crystal 2
			STX.w GFXStripes+$046E
			STY.w GFXStripes+$0470
		+ BIT.w #$0040 : BEQ + ; crystal 3
			STX.w GFXStripes+$04B0
			STY.w GFXStripes+$04B2
		+ BIT.w #$0020 : BEQ + ; crystal 4
			STX.w GFXStripes+$0472
			STY.w GFXStripes+$0474
		+ BIT.w #$0008 : BEQ + ; crystal 7
			STX.w GFXStripes+$04B8
			STY.w GFXStripes+$04BA
		+ 

		LDX.w #$2544
		LDY.w #$2545

		  BIT.w #$0004 : BEQ + ; crystal 5
			STX.w GFXStripes+$04B4
			STY.w GFXStripes+$04B6
		+ BIT.w #$0001 : BEQ + ; crystal 6
			STX.w GFXStripes+$0476
			STY.w GFXStripes+$0478
		+

	PLB : PLP
RTL
;================================================================================
.row0 dw $28FB, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $68FB
.row1 dw $28FC, $24F5, $24F5, $24F5, $312B, $312C, $24F5, $24F5, $24F5, $68FC
.row2 dw $28FC, $24F5, $24F5, $24F5, $313D, $312E, $24F5, $24F5, $24F5, $68FC
.row3 dw $28FC, $24F5, $312B, $312C, $24F5, $24F5, $312B, $312C, $24F5, $68FC
.row4 dw $28FC, $24F5, $313D, $312E, $24F5, $24F5, $313D, $312E, $24F5, $68FC
.row5 dw $28FC, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $68FC
.row6 dw $28FC, $24F5, $3146, $3147, $3146, $3147, $3146, $3147, $24F5, $68FC
.row7 dw $28FC, $3146, $3147, $3146, $3147, $3146, $3147, $3146, $3147, $68FC
.row8 dw $A8FB, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $E8FB
;================================================================================
;Crystal 1: $02
;Crystal 2: $10
;Crystal 3: $40
;Crystal 4: $20
;Crystal 5: $04
;Crystal 6: $01
;Crystal 7: $08
;;blank pendant
;db $2B, $31, $2C, $31, $3D, $31, $2E, $31
;
;;red pendant
;db $2B, $25, $2C, $25, $2D, $25, $2E, $25
;
;;blue pendant
;db $2B, $2D, $2C, $2D, $2D, $2D, $2E, $2D
;
;;green pendant
;db $2B, $3D, $2C, $3D, $2D, $3D, $2E, $3D
;================================================================================
.pendants
dw $28FB, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $68FB
dw $28FC, $2521, $2522, $2523, $2524, $253F, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $213B, $213C, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $213D, $213E, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $213B, $213C, $24F5, $24F5, $213B, $213C, $24F5, $68FC
dw $28FC, $24F5, $213D, $213E, $24F5, $24F5, $213D, $213E, $24F5, $68FC
dw $A8FB, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $E8FB
.crystals
dw $28FB, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $68FB
dw $28FC, $252F, $2534, $2535, $2536, $2537, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $3146, $3147, $3146, $3147, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $3146, $3147, $3146, $3147, $3146, $3147, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $3146, $3147, $3146, $3147, $24F5, $24F5, $68FC
dw $A8FB, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $E8FB
;================================================================================
; DATA - Dungeon Worlds
;.dungeon_worlds
;db $00, $00, $00, $00, $00, $40, $40, $40
;db $40, $40, $00, $40, $40, $40, $FF, $FF
;================================================================================
;0x00 - Sewer Passage
;0x02 - Hyrule Castle
;0x04 - Eastern Palace
;0x06 - Desert Palace
;0x08 - Hyrule Castle 2
;0x0A - Swamp Palace
;0x0C - Palace of Darkness
;0x0E - Misery Mire
;0x10 - Skull Woods
;0x12 - Ice Palace
;0x14 - Tower of Hera
;0x16 - Thieves' Town
;0x18 - Turtle Rock
;0x1A - Ganon's Tower
;0x1C - ??? possibly unused. (Were they planning two extra dungeons perhaps?)
;0x1E - ??? possibly unused.
;================================================================================
HandleEmptyMenu:
        LDA.b Joy1A_New : BIT.b #$DF : BNE .close_menu ; Not select, close menu
                          BIT.b #$20 : BNE .sel_pressed
        LDA.b Joy1A_All : BIT.b #$20 : BNE .wait_for_change
		LDA.l HudFlag : AND.b #$60 : BEQ .wait_for_change
		LDA.l HudFlag : AND.b #$9F : STA.l HudFlag ; Unset without select
                JSL.l MaybePlaySelectSFX
                LDA.b #$0C : BRA .done
        .sel_pressed
        LDA.l HUDDungeonItems : BIT.b #$0C : BNE +
                LDA.b #$40
                BRA .store_flag
        +
        LDA.b #$60
        .store_flag
        STA.l HudFlag
        JSL.l MaybePlaySelectSFX
        LDA.b #$0C : BRA .done
        .wait_for_change
        LDA.b #$03 : BRA .done
        .close_menu
        LDA.b #$06
        .done
        STA.w SubModuleInterface
RTL
;-------------------------------------------------------------------------------
MaybeDrawEquippedItem:
        LDA.w ItemCursor : BEQ +
                JML.l ItemMenu_DrawEquippedYItem+$07
        +
JML.l ItemMenu_DrawEquippedYItem_exit
;-------------------------------------------------------------------------------
RestoreMenu_SetSubModule:
        LDA.w ItemCursor : BEQ +
                LDA.b #$04 : STA.w SubModuleInterface
                RTL
        +
        LDA.b #$03 : STA.w SubModuleInterface
RTL
;-------------------------------------------------------------------------------
DrawHeartPiecesMenu:
        LDA.l HUDHeartColors_index : AND.w #$00FF
        ASL : TAX
        LDA.l HUDHeartColors_masks_game_hud,X
        STA.b Scrap0D

        LDA.l HeartPieceQuarter : AND.w #$00FF
        ASL #3 : TAX
        LDY.w #$16F2

        LDA.l HeartPieceMenuBaseTiles,X
        ORA.b Scrap0D
        STA.w $0000,Y

        INX #2
        LDA.l HeartPieceMenuBaseTiles,X
        ORA.b Scrap0D
        STA.w $0002,Y

        INX #2
        LDA.l HeartPieceMenuBaseTiles,X
        ORA.b Scrap0D
        STA.w $0040,Y

        INX #2
        LDA.l HeartPieceMenuBaseTiles,X
        ORA.b Scrap0D
        STA.w $0042,Y
RTL

HeartPieceMenuBaseTiles:
dw $2084, $6084, $2085, $6085 ; 0 heart pieces
dw $20AD, $6084, $2085, $6085 ; 1 heart piece
dw $20AD, $6084, $20AE, $6085 ; 2 heart pieces
dw $20AD, $60AD, $20AE, $6085 ; 3 heart pieces
;-------------------------------------------------------------------------------
