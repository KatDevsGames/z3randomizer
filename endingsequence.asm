;================================================================================
; Dialog Pointer Override
;--------------------------------------------------------------------------------
EndingSequenceTableOverride:
	PHY
	PHX
	TYX
	LDA.l EndingSequenceText, X
	PLX
	STA $1008, X
	PLY
RTL
;--------------------------------------------------------------------------------
EndingSequenceTableLookupOverride:
	PHY
	PHX
	TYX
	LDA.l EndingSequenceText, X : AND #$00FF
	PLX
	PLY
RTL
;--------------------------------------------------------------------------------
