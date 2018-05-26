;================================================================================
; Boots State Modifier
;--------------------------------------------------------------------------------
!BOOTS_MODIFIER = "$7F50CE"
ModifyBoots:
	PHA
		LDA !BOOTS_MODIFIER : CMP.b #$01 : BNE +
			PLA : AND $7EF379 : ORA.b #$04 : RTL ; yes boots
		+ : CMP #$02 : BNE +
			PLA : AND $7EF379 : AND.b #$FB : RTL ; no boots
		+
	PLA
	AND $7EF379 ; regular boots
RTL
;--------------------------------------------------------------------------------