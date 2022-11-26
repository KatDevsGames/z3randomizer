;================================================================================
; Lamp Mantle & Light Cone Fix
;--------------------------------------------------------------------------------
; Output: 0 for darkness, 1 for lamp cone
;--------------------------------------------------------------------------------
LampCheck:
	LDA.l LightConeModifier : CMP.b #$01 : BNE + : RTL : +
                                  CMP.b #$FF : BNE + : INC : RTL : +
        LDA.l LampEquipment : BNE .lamp ; skip if we already have lantern
        LDA.w DungeonID : BNE + ; check if we're in sewers
                LDA.l LampConeSewers : RTL
        + : TDC
        .lamp
RTL
;================================================================================
;--------------------------------------------------------------------------------
; Output: 0 locked, 1 open
;--------------------------------------------------------------------------------
CheckForZelda:
        LDA.l ProgressIndicator : CMP.b #$02 : !BLT + ; Skip if rain is falling
                LDA.b #$01 ; pretend we have zelda anyway
                RTL
        +
        LDA.l FollowerIndicator
RTL
;================================================================================
SetOverlayIfLamp:
        JSL.l LampCheck
        STA.b SUBDESQ ; write it directly to the overlay, this isn't a terrible idea at all
RTL
;================================================================================
; Mantle Object Changes
;--------------------------------------------------------------------------------
Mantle_CorrectPosition:
	LDA.l ProgressFlags : AND.b #$04 : BEQ +
		LDA.b #$0A : STA.w SpritePosXLow, X ; just spawn it off to the side where we know it should be
		LDA.b #$03 : STA.w SpritePosXHigh, X
		LDA.b #$90 : STA.w SpriteSpawnStep, X
	+
	LDA.w SpritePosYLow, X : !ADD.b #$03 ; thing we did originally
RTL
;--------------------------------------------------------------------------------
