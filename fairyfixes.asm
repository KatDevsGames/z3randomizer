;================================================================================
; Fairy Changes & Fixes
;--------------------------------------------------------------------------------
RefillHealthPlusMagic:
    LDA BigFairyHealth : STA $7EF372
RTL
;--------------------------------------------------------------------------------
RefillHealthPlusMagic8bit:
    LDA BigFairyHealth : STA $7EF372
    LDA BigFairyMagic : STA $7EF373
RTL
;--------------------------------------------------------------------------------
CheckFullHealth:
    LDA BigFairyHealth : BEQ +
        LDA $7EF36D : CMP $7EF36C : BNE .player_hp_not_full_yet
    +
    LDA BigFairyMagic : BEQ +
        LDA $7EF36E : CMP.b #$80 : BNE .player_mp_not_full_yet
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
		JSL.l Sprite_ShowMessageFromPlayerContact
		RTL
	+
	PHY : JSL.l Sprite_CheckDamageToPlayerSameLayerLong : BCC +
		LDA $7EF35C : CMP.b #$02 : BNE ++ : LDA.b #$1C : PHA : BRA .emptyBottle : ++
		LDA $7EF35D : CMP.b #$02 : BNE ++ : LDA.b #$1D : PHA : BRA .emptyBottle : ++
		LDA $7EF35E : CMP.b #$02 : BNE ++ : LDA.b #$1E : PHA : BRA .emptyBottle : ++
		LDA $7EF35F : CMP.b #$02 : BNE ++ : LDA.b #$1F : PHA : BRA .emptyBottle : ++
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
