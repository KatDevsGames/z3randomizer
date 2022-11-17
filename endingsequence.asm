;================================================================================
; Dialog Pointer Override
;--------------------------------------------------------------------------------
EndingSequenceTableOverride:
	PHY
	PHX
	TYX
	LDA.l EndingSequenceText, X
	PLX
	STA.w $1008, X
	PLY
RTL
;--------------------------------------------------------------------------------
EndingSequenceTableLookupOverride:
	PHY
	PHX
	TYX
	LDA.l EndingSequenceText, X : AND.w #$00FF
	PLX
	PLY
RTL
;--------------------------------------------------------------------------------
