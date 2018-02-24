;================================================================================
; Spawn Zelda (or not)
;--------------------------------------------------------------------------------
SpawnZelda:
	LDA.l $7EF3CC : CMP #$08 : BEQ + ; don't spawn if dwarf is present
	CMP #$07 : BEQ + ; don't spawn if frog is present
	CMP #$0C : BEQ + ; don't spawn if purple chest is present
		CLC : RTL
	+
	SEC
RTL
;--------------------------------------------------------------------------------
EndRainState:
	LDA $7EF3C5 : CMP.b #$02 : !BGE + ; skip if past escape already
		LDA.b #$00 : STA !INFINITE_ARROWS : STA !INFINITE_BOMBS : STA !INFINITE_MAGIC
		LDA.b #$02 : STA $7EF3C5 ; end rain state
	+
RTL
;--------------------------------------------------------------------------------
