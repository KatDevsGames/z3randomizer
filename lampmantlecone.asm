;================================================================================
; Lamp Mantle & Light Cone Fix
;--------------------------------------------------------------------------------
; Output: 0 for darkness, 1 for lamp cone
;--------------------------------------------------------------------------------
LampCheck:
	LDA $7F50C4 : CMP.b #$01 : BNE + : RTL : +
				  CMP.b #$FF : BNE + : INC : RTL : +
	
	LDA LampEquipment : BNE .done ; skip if we already have lantern
	
	LDA CurrentWorld : BNE +
		.lightWorld
		LDA $040C : BNE ++ ; check if we're in sewers
			LDA LampConeSewers : BRA .done
		++
			LDA LampConeLightWorld : BRA .done
	+
		.darkWorld
		LDA LampConeDarkWorld
	.done
	;BNE + : STZ $1D : + ; remember to turn cone off after a torch
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
	LDA FollowerIndicator
RTL
;================================================================================
;--------------------------------------------------------------------------------
SetOverlayIfLamp:
	JSL.l LampCheck
	STA $1D ; write it directly to the overlay, this isn't a terrible idea at all
RTL
;================================================================================
;LDA CurrentWorld : EOR #$40 : LSR #6 : AND #$01 ; return the same result as having the lantern in the light world
