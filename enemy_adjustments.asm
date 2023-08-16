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

	
	LDA.b #$85 : STA.w SpriteBump, X
	LDA.b #$04 : STA.w SpriteHitPoints, X
RTL
	.light_world
		LDA.b #$80 : STA.w SpriteBump, X
		LDA.b #$01 : STA.w SpriteHitPoints, X
RTL
;--------------------------------------------------------------------------------
NewFireBarDamage:
        LDA.b LinkLayer : CMP.w SpriteLayer, X : BNE .NotSameLayer
                JSL Sprite_AttemptDamageToPlayerPlusRecoilLong
                RTL
.NotSameLayer
RTL
