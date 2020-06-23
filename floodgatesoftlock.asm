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
	LDA.l Bugfix_SwampWaterLevel : BEQ +++
		LDA $7EF06F : AND.b #$04 : BEQ + ; Check if key in room 55 has been collected. 
		LDA $7EF356 : AND.b #$01 : BNE ++ ; Check for flippers. This can otherwise softlock doors if flooded without flippers and no way to reset.
	+
		LDA $7EF06E : AND.b #$7F : STA $7EF06E ; clear water room 55 - outer room you shouldn't be able to softlock except in major glitches
	++
		LDA $7EF06B : AND.b #$04 : BNE +++ ; Check if key in room 53 has been collected.
		; no need to check for flippers on the inner room, as you can't get to the west door no matter what, without flippers.
		LDA $7EF06A : AND.b #$7F : STA $7EF06A ; clear water room 53 - inner room with the easy key flood softlock
	+++
RTL
;================================================================================
