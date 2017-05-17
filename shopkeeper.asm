;================================================================================
; Randomize 300 Rupee NPC
;--------------------------------------------------------------------------------
Set300RupeeNPCItem:
	INC $0D80, X ; thing we wrote over

	PHA : PHP
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #291 : BNE +
		LDA RupeeNPC_MoldormCave : TAY ; load moldorm cave value into Y
		BRA .done
	+ CMP.w #286 : BNE +
		LDA RupeeNPC_NortheastDarkSwampCave : TAY ; load northeast dark swamp cave value into Y
		BRA .done
	+
	LDY.b #$46 ; default to a normal 300 rupees
	.done
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
; 291 - Moldorm Cave
; 286 - Northeast Dark Swamp Cave
;--------------------------------------------------------------------------------