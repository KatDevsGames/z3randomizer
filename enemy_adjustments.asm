;--------------------------------------------------------------------------------
; NewBatInit:
; make sure bats always load LW stats
;--------------------------------------------------------------------------------
NewBatInit:
	CPY #$00 : BEQ .light_world
	;check if map id == 240 or 241
	LDA $A0 : CMP #$F0 : BEQ .light_world ;oldman cave1
	CMP #$F1 : BEQ .light_world ;oldman cave2
	CMP #$B0 : BEQ .light_world ;agahnim statue keese
	CMP #$D0 : BEQ .light_world ;agahnim darkmaze

	
	LDA.b #$85 : STA $0CD2, X
	LDA.b #$04 : STA $0E50, X
RTL

	.light_world
		LDA.b #$80 : STA $0CD2, X
		LDA.b #$01 : STA $0E50, X
RTL
;--------------------------------------------------------------------------------

