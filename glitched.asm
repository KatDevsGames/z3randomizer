;================================================================================
; Glitched Mode Fixes
;================================================================================
GetAgahnimType:
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #13 : BNE + ; Agahnim 2 room
		LDA.w #$0006 ; Use Agahnim 2
		BRA .done
	+ ; Elsewhere
		LDA.w #$0001 ; Use Agahnim 1
	.done
	PLP
RTL
;--------------------------------------------------------------------------------