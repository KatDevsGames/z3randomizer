;--------------------------------------------------------------------------------
; NewBatInit:
; make sure bats always load LW stats
;--------------------------------------------------------------------------------
NewBatInit:
	CPY.b #$00 : BEQ .light_world
	;check if map id == 240 or 241
	LDA.b RoomIndex : CMP.b #$F0 : BEQ .light_world ;oldman cave1
	CMP.b #$F1 : BEQ .light_world ;oldman cave2
	CMP.b #$B0 : BEQ .light_world ;agahnim statue keese
	CMP.b #$D0 : BEQ .light_world ;agahnim darkmaze

	
	LDA.b #$85 : STA.w $0CD2, X
	LDA.b #$04 : STA.w $0E50, X
RTL
	.light_world
		LDA.b #$80 : STA.w $0CD2, X
		LDA.b #$01 : STA.w $0E50, X
RTL
;--------------------------------------------------------------------------------
NewFireBarDamage:
        LDA.w $00EE : CMP.w $0F20, X : BNE .NotSameLayer
                JSL Sprite_AttemptDamageToPlayerPlusRecoilLong
                RTL
.NotSameLayer
RTL
