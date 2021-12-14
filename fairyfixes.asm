;================================================================================
; Fairy Changes & Fixes
;--------------------------------------------------------------------------------
RefillHealthPlusMagic:
    LDA BigFairyHealth : STA HeartsFiller
RTL
;--------------------------------------------------------------------------------
RefillHealthPlusMagic8bit:
    LDA BigFairyHealth : STA HeartsFiller
    LDA BigFairyMagic : STA MagicFiller
RTL
;--------------------------------------------------------------------------------
CheckFullHealth:
    LDA BigFairyHealth : BEQ +
        LDA CurrentHealth : CMP MaximumHealth : BNE .player_hp_not_full_yet
    +
    LDA BigFairyMagic : BEQ +
        LDA CurrentMagic : CMP.b #$80 : BNE .player_mp_not_full_yet
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
		LDA BottleContentsOne : CMP.b #$02 : BNE ++ : LDA.b #$1C : PHA : BRA .emptyBottle : ++
		LDA BottleContentsTwo : CMP.b #$02 : BNE ++ : LDA.b #$1D : PHA : BRA .emptyBottle : ++
		LDA BottleContentsThree : CMP.b #$02 : BNE ++ : LDA.b #$1E : PHA : BRA .emptyBottle : ++
		LDA BottleContentsFour : CMP.b #$02 : BNE ++ : LDA.b #$1F : PHA : BRA .emptyBottle : ++
			.noInventory
			LDA.b #$0A : STA $0D80, X
			LDA.b #$51
			LDY.b #$01
			JSL.l Sprite_ShowMessageFromPlayerContact
			JMP .cleanup
		
			.emptyBottle
			LDA.b #$02 : STA $0D80, X
			;JSL Player_ResetState ; If we continue to have issues, add this in too. (After determining the address for it)
			STZ $2F
			LDA.b #$01 : STA $02E4
			PLA : STA $1CE8
		.cleanup
		STZ $0EB0, X ; Clear the sprite's item-given variable
		CLC ; skip rest of original function
	+ :	PLY
RTL
;--------------------------------------------------------------------------------
HappinessPond_Check:
	LDA $A0 : CMP.b #$15 ;what we wrote over
	BNE .done
	PHP

	LDA.b #$72
	JSL Sprite_SpawnDynamically

	LDA $0FD8 : STA $0D10, Y
	LDA $0FD9 : STA $0D30, Y

	LDA $0FDA : !SUB.b #$40 : STA $0D00, Y
	LDA $0FDB : SBC.b #$00 : STA $0D20, Y

	LDA.b #$01 : STA $0DA0, Y

	LDA.b #$BB
	JSL Sprite_SpawnDynamically

	LDA.b #$08 : STA $0DD0, Y ; ensure we run prep for the shopkeeper

	LDA $0FD8 : STA $0D10, Y
	LDA $0FD9 : STA $0D30, Y

	LDA $0FDA : !SUB.b #$20 : STA $0D00, Y
	LDA $0FDB : SBC.b #$00 : STA $0D20, Y

	STZ $0DD0, X ; self terminate

	PLP
	.done
RTL
