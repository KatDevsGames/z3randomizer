;================================================================================
; Floodgate Softlock Fix
;--------------------------------------------------------------------------------
FloodGateAndMasterSwordFollowerReset:
	JSL.l MasterSwordFollowerClear
FloodGateReset:
	LDA.l PersistentFloodgate : BNE +
		LDA $7EF2BB : AND.b #$DF : STA $7EF2BB ; reset water outside floodgate
		LDA $7EF2FB : AND.b #$DF : STA $7EF2FB ; reset water outside swamp palace
		LDA $7EF216 : AND.b #$7F : STA $7EF216 ; clear water inside floodgate
		LDA $7EF051 : AND.b #$FE : STA $7EF051 ; clear water front room (room 40)
	+
FloodGateResetInner:
	LDA.l Bugfix_SwampWaterLevel : BEQ +
		; LDA $7EF06E : AND.b #$7F : STA $7EF06E ; clear water room 55 - outer room you shouldn't be able to softlock except in major glitches
		LDA $7EF06A : AND.b #$7F : STA $7EF06A ; clear water room 53 - inner room with the easy key flood softlock
	+
RTL
;================================================================================