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

;--------------------------------------------------------------------------------
; Moldorm_UpdateOamPosition:
; adjust oam space to the maximum of 8 possible eyes
;--------------------------------------------------------------------------------
Moldorm_UpdateOamPosition:
	REP #$21
	LDA.b $90
	ADC.w #$0020
	STA.b $90
	LDA.b $92
	ADC.w #$08
	STA.b $92
RTL
