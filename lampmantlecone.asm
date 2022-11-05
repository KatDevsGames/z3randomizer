;================================================================================
; Lamp Mantle & Light Cone Fix
;--------------------------------------------------------------------------------
; Output: 0 for darkness, 1 for lamp cone
;--------------------------------------------------------------------------------
LampCheck:
	LDA.l LightConeModifier : CMP.b #$01 : BNE + : RTL : +
				  CMP.b #$FF : BNE + : INC : RTL : +
	
	LDA.l LampEquipment : BNE .done ; skip if we already have lantern
	
	LDA.l CurrentWorld : BNE +
		.lightWorld
		LDA.w $040C : BNE ++ ; check if we're in sewers
			LDA.l LampConeSewers : BRA .done
		++
			LDA.l LampConeLightWorld : BRA .done
	+
		.darkWorld
		LDA LampConeDarkWorld
	.done
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
;--------------------------------------------------------------------------------
SetOverlayIfLamp:
	JSL.l LampCheck
	STA.b $1D ; write it directly to the overlay, this isn't a terrible idea at all
RTL
;================================================================================
