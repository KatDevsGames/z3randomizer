;================================================================================
; Fairy Changes & Fixes
;--------------------------------------------------------------------------------
RefillHealthPlusMagic:
    LDA.l BigFairyHealth : STA.l HeartsFiller
RTL
;--------------------------------------------------------------------------------
RefillHealthPlusMagic8bit:
    LDA.l BigFairyHealth : STA.l HeartsFiller
    LDA.l BigFairyMagic : STA.l MagicFiller
RTL
;--------------------------------------------------------------------------------
CheckFullHealth:
    LDA.l BigFairyHealth : BEQ +
        LDA.l CurrentHealth : CMP.l MaximumHealth : BNE .player_hp_not_full_yet
    +
    LDA.l BigFairyMagic : BEQ +
        LDA.l CurrentMagic : CMP.b #$80 : BNE .player_mp_not_full_yet
    +
    LDA.b #$00
RTL
    .player_hp_not_full_yet
    .player_mp_not_full_yet
    LDA.b #$01
RTL
;--------------------------------------------------------------------------------
FairyPond_Init:
	LDA.l Restrict_Ponds : BNE +
		LDA.b #$48
		JML.l Sprite_ShowMessageFromPlayerContact
	+
	PHY : JSL.l Sprite_CheckDamageToPlayerSameLayerLong : BCC +
		LDA.l BottleContentsOne : CMP.b #$02 : BNE ++ : LDA.b #$1C : PHA : BRA .emptyBottle : ++
		LDA.l BottleContentsTwo : CMP.b #$02 : BNE ++ : LDA.b #$1D : PHA : BRA .emptyBottle : ++
		LDA.l BottleContentsThree : CMP.b #$02 : BNE ++ : LDA.b #$1E : PHA : BRA .emptyBottle : ++
		LDA.l BottleContentsFour : CMP.b #$02 : BNE ++ : LDA.b #$1F : PHA : BRA .emptyBottle : ++
			.noInventory
			LDA.b #$0A : STA.w SpriteActivity, X
			LDA.b #$51
			LDY.b #$01
			JSL.l Sprite_ShowMessageFromPlayerContact
			JMP .cleanup
		
			.emptyBottle
			LDA.b #$02 : STA.w SpriteActivity, X
			STZ.b LinkDirection
			LDA.b #$01 : STA.w CutsceneFlag
			PLA : STA.w MessageCursor
		.cleanup
		STZ.w SpriteDirectionTable, X ; Clear the sprite's item-given variable
		CLC ; skip rest of original function
	+ :	PLY
RTL
;--------------------------------------------------------------------------------
HappinessPond_Check:
	LDA.b RoomIndex : CMP.b #$15 ;what we wrote over
	BNE .done
	PHP

	LDA.b #$72
	JSL Sprite_SpawnDynamically

	LDA.w SpriteCoordCacheX : STA.w SpritePosXLow, Y
	LDA.w SpriteCoordCacheX+1 : STA.w SpritePosXHigh, Y

	LDA.w SpriteCoordCacheY : !SUB.b #$40 : STA.w SpritePosYLow, Y
	LDA.w SpriteCoordCacheY+1 : SBC.b #$00 : STA.w SpritePosYHigh, Y

	LDA.b #$01 : STA.w SpriteAuxTable, Y

	LDA.b #$BB
	JSL Sprite_SpawnDynamically

	LDA.b #$08 : STA.w SpriteAITable, Y ; ensure we run prep for the shopkeeper

	LDA.w SpriteCoordCacheX : STA.w SpritePosXLow, Y
	LDA.w SpriteCoordCacheX+1 : STA.w SpritePosXHigh, Y

	LDA.w SpriteCoordCacheY : !SUB.b #$20 : STA.w SpritePosYLow, Y
	LDA.w SpriteCoordCacheY+1 : SBC.b #$00 : STA.w SpritePosYHigh, Y

	STZ.w SpriteAITable, X ; self terminate

	PLP
	.done
RTL
