;================================================================================
; Mantle Object Changes
;--------------------------------------------------------------------------------
Mantle_CorrectPosition:
	LDA.l ProgressFlags : AND.b #$04 : BEQ +
		LDA.b #$0A : STA.w $0D10, X ; just spawn it off to the side where we know it should be
		LDA.b #$03 : STA.w $0D30, X
		LDA.b #$90 : STA.w $0ED0, X
	+
	LDA.w $0D00, X : !ADD.b #$03 ; thing we did originally
RTL
;--------------------------------------------------------------------------------
