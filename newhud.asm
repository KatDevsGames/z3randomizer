!InfiniteTile = $2431
!BlankTile = $207F
!SlashTile = $2830
!PTile = $296C
!CTile = $295F

NewDrawHud:
        PHB

        SEP #$30
        REP #$10

        LDA.b #$7E
        PHA : PLB

;================================================================================
NewHUD_DrawBombs:
        LDA.l InfiniteBombs : BEQ .finite

.infinite
        LDY.w #!InfiniteTile+0
        LDX.w #!InfiniteTile+1
        BRA .draw

.finite
        LDA.w BombsEquipment
        JSR HUDHex2Digit

.draw
        STY.w HUDBombCount+0
        STX.w HUDBombCount+2

;================================================================================
NewHUD_DrawRupees:
        REP #$20

        LDA.w DisplayRupees
        JSR HUDHex4Digit

        LDA.b Scrap04 : TAX : STX.w HUDRupees+0 ; 1000s
        LDA.b Scrap05 : TAX : STX.w HUDRupees+2 ;  100s
        LDA.b Scrap06 : TAX : STX.w HUDRupees+4 ;   10s
        LDA.b Scrap07 : TAX : STX.w HUDRupees+6 ;    1s

;================================================================================
NewHUD_DrawArrows:
        SEP #$20

        LDA.l ArrowMode : BNE NewHUD_DrawGoal
        LDA.l InfiniteArrows : BEQ .finite

.infinite
        LDY.w #!InfiniteTile+0
        LDX.w #!InfiniteTile+1
        BRA .draw

.finite
        LDA.w CurrentArrows
        JSR HUDHex2Digit

.draw
        STY.w HUDArrowCount+0
        STX.w HUDArrowCount+2

;================================================================================
NewHUD_DrawGoal:
        REP #$20
        LDA.w UpdateHUDFlag : BEQ .no_goal
        LDA.l GoalItemRequirement : BEQ .no_goal

        LDA.l GoalItemIcon : STA.w HUDGoalIndicator
        LDA.w #!SlashTile : STA.w HUDGoalIndicator+8
        LDA.l GoalCounter
        JSR HUDHex4Digit

        LDA.b Scrap05 : TAX : STX.w HUDGoalIndicator+2 ; draw 100's digit
        LDA.b Scrap06 : TAX : STX.w HUDGoalIndicator+4 ; draw 10's digit
        LDA.b Scrap07 : TAX : STX.w HUDGoalIndicator+6 ; draw 1's digit

        REP #$20

        LDA.l GoalItemRequirement : CMP.w #$FFFF : BNE .real_goal

        LDX.w #!BlankTile
        STX.w HUDGoalIndicator+10
        STX.w HUDGoalIndicator+12
        STX.w HUDGoalIndicator+14

.no_goal
        SEP #$20
        BRA NewHUD_DrawKeys

.real_goal
        JSR HUDHex4Digit

        LDA.b Scrap05 : TAX : STX.w HUDGoalIndicator+10 ; draw 100's digit
        LDA.b Scrap06 : TAX : STX.w HUDGoalIndicator+12 ; draw 10's digit
        LDA.b Scrap07 : TAX : STX.w HUDGoalIndicator+14 ; draw 1's digit

;================================================================================
NewHUD_DrawKeys:
        LDA.l CurrentSmallKeys
        CMP.b #$FF
        BNE .in_dungeon

        LDY.w #!BlankTile
        STY.w HUDKeyIcon
        STY.w HUDKeyDigits+0
        STY.w HUDKeyDigits+2
        BRA NewHUD_DrawDungeonCounters

.in_dungeon
        JSR HUDHex2Digit
        CPY.w #$2490
        BNE .real_10s

        LDY.w #!BlankTile

.real_10s
        STY.w HUDKeyDigits+0
        STX.w HUDKeyDigits+2

;================================================================================
NewHUD_DrawDungeonCounters:
        LDA.w UpdateHUDFlag : BEQ NewHUD_DrawPrizeIcon
        LDA.l CompassMode : ORA.l MapHUDMode : BIT.b #$03 : BEQ NewHUD_DrawPrizeIcon
        LDX.b IndoorsFlag : BNE +
        JMP.w NewHUD_DrawMagicMeter
        +
        SEP #$30
        ; extra hard safeties for getting dungeon ID to prevent crashes
        LDA.w DungeonID
        CMP.b #$1B : BCS NewHUD_DrawPrizeIcon ; Skip if not in a valid dungeon ID
        AND.b #$FE : TAX
        LSR : TAY
        PHX : PHY

        JSR.w DrawCompassCounts
        SEP #$10
        PLY : PLX
        JSR.w DrawMapCounts

;================================================================================
NewHUD_DrawPrizeIcon:
        REP #$10
        SEP #$20
	LDA.b GameMode
        CMP.b #$12 : BEQ .no_prize
        CMP.b #$0E : BEQ +
        LDA.w UpdateHUDFlag : BEQ NewHUD_DrawItemCounter
	+
        LDA.w DungeonID
	CMP.b #$1A : BCS .no_prize
	CMP.b #$04 : BCC .no_prize
	CMP.b #$08 : BNE .dungeon

.no_prize
	LDY.w #!BlankTile
	BRA .draw_prize

.dungeon
	SEP #$30
	TAX
	LSR
	TAY
	LDA.l MapMode

	REP #$30
        BEQ .prize

	LDA.l MapField
	AND.l DungeonItemMasks,X
	BEQ .no_prize

        .prize
	TYX
	LDA.l CrystalPendantFlags_2,X
        BIT.w #$0080
        BNE .no_icon

	BIT.w #$0040
	BNE .crystal

	LDY.w #!PTile
	BRA .draw_prize

.crystal
	LDY.w #!CTile
        BRA .draw_prize

.no_icon
        LDY.w #!BlankTile

.draw_prize
	STY.w HUDPrizeIcon

;================================================================================
NewHUD_DrawItemCounter:
        REP #$20
        LDA.w UpdateHUDFlag : BEQ NewHUD_DrawMagicMeter
        LDA.l ItemCounterHUD : AND.w #$00FF : BEQ NewHUD_DrawMagicMeter
        LDA.w #!SlashTile : STA.w HUDGoalIndicator+$08
        LDA.l TotalItemCount : CMP.w #1000 : BCS .item_four_digits
        LDA.w TotalItemCountTiles+$02 : STA.w HUDGoalIndicator+$0A
        LDA.w TotalItemCountTiles+$04 : STA.w HUDGoalIndicator+$0C
        LDA.w TotalItemCountTiles+$06 : STA.w HUDGoalIndicator+$0E

        LDA.w TotalItemCounter
        JSR.w HUDHex4Digit
        LDA.b $05 : TAX : STX.w HUDGoalIndicator+$02
        LDA.b $06 : TAX : STX.w HUDGoalIndicator+$04
        LDA.b $07 : TAX : STX.w HUDGoalIndicator+$06
        BRA NewHUD_DrawMagicMeter

        .item_four_digits
        LDA.w TotalItemCountTiles+$00 : STA.w HUDGoalIndicator+$0A
        LDA.w TotalItemCountTiles+$02 : STA.w HUDGoalIndicator+$0C
        LDA.w TotalItemCountTiles+$04 : STA.w HUDGoalIndicator+$0E
        LDA.w TotalItemCountTiles+$06 : STA.w HUDGoalIndicator+$10

        LDA.w TotalItemCounter
        JSR.w HUDHex4Digit
        LDA.b $04 : TAX : STX.w HUDGoalIndicator+$00
        LDA.b $05 : TAX : STX.w HUDGoalIndicator+$02
        LDA.b $06 : TAX : STX.w HUDGoalIndicator+$04
        LDA.b $07 : TAX : STX.w HUDGoalIndicator+$06

;================================================================================
DrawMagicMeter_mp_tilemap = $0DFE0F
NewHUD_DrawMagicMeter:
        SEP #$31
        LDA.l CurrentMagic
        ADC.b #$06 ; carry set by above for +1 to get +7
        AND.b #$F8
        TAY

        LDA.l InfiniteMagic
        BEQ .set_index

.infinite_magic
        LDA.b #$80
        STA.w CurrentMagic
        TAY

        LDA.b FrameCounter
        REP #$30
        AND.w #$000C
        LSR
        BRA .recolor

.set_index ; this branch is always 0000 when taken
        REP #$30
        TDC
        .recolor
        TAX
        LDA.l MagicMeterColorMasks,X

        TYX
        TAY : AND.l DrawMagicMeter_mp_tilemap+0,X : STA.w HUDTileMapBuffer+$046
        TYA : AND.l DrawMagicMeter_mp_tilemap+2,X : STA.w HUDTileMapBuffer+$086
        TYA : AND.l DrawMagicMeter_mp_tilemap+4,X : STA.w HUDTileMapBuffer+$0C6
        TYA : AND.l DrawMagicMeter_mp_tilemap+6,X : STA.w HUDTileMapBuffer+$106

;================================================================================
NewHUD_DoneDrawing:
        STZ.w UpdateHUDFlag
        PLB
RTL

;================================================================================
MagicMeterColorMasks:
        dw $FFFF ; green - KEEP GREEN FIRST
        dw $EFFF ; blue
        dw $E7FF ; red
        dw $EBFF ; yellow
        dw $E3FF ; orange

;================================================================================
DrawCompassCounts:
        LDA.l CompassMode : BEQ .done

        ; no compass needed if this bit is set
        BIT.b #$02 : BNE .draw_compass_count
        REP #$20
        LDA.l CompassField : AND.l DungeonItemMasks,X : BEQ .done

.draw_compass_count
        SEP #$20
        TYX : BNE .not_sewers
        INX

.not_sewers
        LDA.l DungeonLocationsChecked, X
        PHA

        LDA.l CompassTotalsWRAM,X

        JSR HUDHex2Digit
        STY.w HUDTileMapBuffer+$9A : STX.w HUDTileMapBuffer+$9C

        LDX.w #!BlankTile : STX.w HUDTileMapBuffer+$92
        LDX.w #!SlashTile : STX.w HUDTileMapBuffer+$98 

        PLA
        JSR HUDHex2Digit
        STY.w HUDTileMapBuffer+$94 : STX.w HUDTileMapBuffer+$96

.done
        SEP #$20
RTS
;================================================================================
DrawMapCounts:
        LDA.l MapHUDMode : BEQ .done

        ; no map needed if this bit is set
        BIT.b #$02 : BNE .draw_map_count
        REP #$20
        LDA.l MapField : AND.l DungeonItemMasks,X : BEQ .done

.draw_map_count
        SEP #$20
        TYX : BNE .not_sewers
        INX

.not_sewers
        LDA.l DungeonCollectedKeys, X
        PHA

        LDA.l MapTotalsWRAM,X

        JSR HUDHex2Digit
        STX.w HUDTileMapBuffer+$A6

        LDX.w #!SlashTile : STX.w HUDTileMapBuffer+$A4

        PLA
        JSR HUDHex2Digit
        STX.w HUDTileMapBuffer+$A2

.done
        SEP #$20
RTS

;================================================================================
; Exits with:
;   X - ones place tile
;   Y - tens place tile
;===================================================================================================
HUDHex2Digit:
	SEP #$30 ; clear high byte of X and Y and make it so they don't get B
        ASL : TAX

        REP #$10

        LDA.b #$24 : XBA ; tile props in high byte

        LDA.l FastHexTable,X : LSR #4 : ORA.b #$90
        TAY

        LDA.l FastHexTable,X : AND.b #$0F : ORA.b #$90
        TAX

        RTS

HUDHex4Digit:
        JSL HexToDec

        REP #$30

        LDA.l HexToDecDigit2 : ORA.w #$9090 : STA.b Scrap04
        LDA.l HexToDecDigit4 : ORA.w #$9090 : STA.b Scrap06

        LDA.w #$2400

        SEP #$20
        RTS

HUDHex2Digit_Long:
        JSR HUDHex2Digit
        REP #$20
RTL

HUDHex4Digit_Long:
        JSR HUDHex4Digit
        REP #$20
RTL

;================================================================================
UpdateHearts:
	PHB
	REP #$20
	SEP #$10

	LDX.b #$7E
	PHX
	PLB

	LDA.w MaximumHealth
	LSR
	LSR
	LSR
	AND.w #$1F1F


	TAX
	XBA
	TAY

	LDA.w #HUDTileMapBuffer+$068
	STA.b $07
	STA.b $09

.next_filled_heart
	CPX.b #$01
	BMI .done_hearts

        PHX
        LDA.l HUDHeartColors_index : ASL : TAX
        LDA.l HUDHeartColors_masks_game_hud,X
        PLX
        ORA.w #$20A0

	CPY.b #$01
	BPL .add_heart

	INC
	INC

.add_heart
	STA.b ($07)

	DEY
	DEX

	LDA.b $07
	INC
	INC
	CMP.w #HUDTileMapBuffer+$07C
	BEQ .next_row

	CMP.w #HUDTileMapBuffer+$0BC
	BNE .fine

.next_row
	ADC.w #$002B

.fine
	STA.b $07

	CPY.b #$00
	BNE .next_filled_heart

	STA.b $09
	BRA .next_filled_heart

.done_hearts
	LDA.w CurrentHealth
	AND.w #$0007
	BEQ .skip_partial
	CMP.w #$0005
	BCS .more_than_half

        LDA.l HUDHeartColors_index : ASL : TAX
        LDA.l HUDHeartColors_masks_game_hud,X
        ORA.w #$20A1
	STA.b ($09)
        BRA .skip_partial

.more_than_half
        LDA.l HUDHeartColors_index : ASL : TAX
        LDA.l HUDHeartColors_masks_game_hud,X
        ORA.w #$20A0
	STA.b ($09)

.skip_partial
	SEP #$30

	PLB
	RTL

CheckHeartPaletteFileSelect:
        LDA.l HUDHeartColors_index : ASL : TAX
        LDA.l HUDHeartColors_masks_file_select,X
        ORA.w #$0200
        LDX.w #$000A
RTL

CheckHeartPalette:
        PHX
        LDA.l HUDHeartColors_index : ASL : TAX
        LDA.l HUDHeartColors_masks_game_hud,X
        ORA.w #$20A0
        PLX
RTS

ColorAnimatedHearts:
        PHX
        REP #$20
        LDA.l HUDHeartColors_index : ASL : TAX
        LDA.l HUDHeartColors_masks_game_hud,X
        PLX
        ORA.l HeartFramesBaseTiles,X
        STA.b [Scrap00],Y
        SEP #$20
RTL

HeartFramesBaseTiles:
dw $20A3, $20A4, $20A3, $20A0
