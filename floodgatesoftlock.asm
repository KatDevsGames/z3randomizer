;================================================================================
; Floodgate Softlock Fix
;--------------------------------------------------------------------------------
FloodGateAndMasterSwordFollowerReset:
	JSL.l MasterSwordFollowerClear
FloodGateReset:
	LDA.l Bugfix_SwampWaterLevel : BEQ +
		LDA $7EF06E : AND.b #$7F : STA $7EF06E ; clear water room 55
		LDA $7EF06A : AND.b #$7F : STA $7EF06A ; clear water room 53
	+
	LDA $7EF051 : AND.b #$FE : STA $7EF051 ; clear water room 40 - thing we wrote over
RTL
;================================================================================