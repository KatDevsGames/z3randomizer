;--------------------------------------------------------------------------------
; NewBatInit:
; make sure bats always load LW stats
;--------------------------------------------------------------------------------
NewBatInit:
	;check if map id == 240 or 241
	LDA $A0 : CMP #$F0 : BNE + ;oldman cave1
		BRA .light_world
	+
	CMP #$F1 : BNE + ;oldman cave2
		BRA .light_world
	+
	CMP #$B0 : BNE + ;agahnim statue keese
		BRA .light_world
	+
	CMP #$D0 : BNE + ;agahnim darkmaze
		BRA .light_world
	+

	CPY #$00 : BEQ .light_world
	LDA.b #$85 : STA $0CD2, X
	LDA.b #$04 : STA $0E50, X
RTL

	.light_world
		LDA.b #$80 : STA $0CD2, X
		LDA.b #$01 : STA $0E50, X
RTL
;--------------------------------------------------------------------------------

