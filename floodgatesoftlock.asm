;================================================================================
; Floodgate Softlock Fix
;--------------------------------------------------------------------------------
FloodGateAndMasterSwordFollowerReset:
	JSL.l MasterSwordFollowerClear
FloodGateReset:
	LDA.l PersistentFloodgate : BNE +
		LDA.l OverworldEventDataWRAM+$3B : AND.b #$DF : STA.l OverworldEventDataWRAM+$3B ; reset water outside floodgate
		LDA.l OverworldEventDataWRAM+$7B : AND.b #$DF : STA.l OverworldEventDataWRAM+$7B ; reset water outside swamp palace
		LDA.l RoomDataWRAM[$010B].low : AND.b #$7F : STA.l RoomDataWRAM[$010B].low ; clear water inside floodgate
		LDA.l RoomDataWRAM[$28].high : AND.b #$FE : STA.l RoomDataWRAM[$28].high ; clear water front room (room 40)
	+
FloodGateResetInner:
	LDA.l Bugfix_SwampWaterLevel : BEQ +++
		LDA.l RoomDataWRAM[$37].low : AND.b #$04 : BEQ + ; Check if key in room 55 has been collected. 
		LDA.l FlippersEquipment : AND.b #$01 : BNE ++ ; Check for flippers. This can otherwise softlock doors if flooded without flippers and no way to reset.
	+
		LDA.l RoomDataWRAM[$37].low : AND.b #$7F : STA.l RoomDataWRAM[$37].low ; clear water room 55 - outer room you shouldn't be able to softlock except in major glitches
	++
		LDA.l RoomDataWRAM[$35].high : AND.b #$04 : BNE +++ ; Check if key in room 53 has been collected.
		; no need to check for flippers on the inner room, as you can't get to the west door no matter what, without flippers.
		LDA.l RoomDataWRAM[$35].low : AND.b #$7F : STA.l RoomDataWRAM[$35].low ; clear water room 53 - inner room with the easy key flood softlock
	+++
RTL
;================================================================================
