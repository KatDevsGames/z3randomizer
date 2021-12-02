;================================================================================
; Spawn Zelda (or not)
;--------------------------------------------------------------------------------
SpawnZelda:
	LDA.l FollowerIndicator : CMP #$08 : BEQ + ; don't spawn if dwarf is present
	CMP #$07 : BEQ + ; don't spawn if frog is present
	CMP #$0C : BEQ + ; don't spawn if purple chest is present
		CLC
	+ RTL
;--------------------------------------------------------------------------------
EndRainState:
	LDA ProgressIndicator : CMP.b #$02 : !BGE + ; skip if past escape already
		LDA.b #$00 : STA !INFINITE_ARROWS : STA !INFINITE_BOMBS : STA !INFINITE_MAGIC
		LDA.b #$02 : STA ProgressIndicator ; end rain state
		JSL MaybeSetPostAgaWorldState
	+
RTL
;--------------------------------------------------------------------------------
