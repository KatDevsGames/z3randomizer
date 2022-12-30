;================================================================================
; Door Frame Fixes
;================================================================================

;--------------------------------------------------------------------------------
; StoreLastOverworldDoorID
;--------------------------------------------------------------------------------
StoreLastOverworldDoorID:
	TXA : INC
	STA.l PreviousOverworldDoor
	LDA.l $9BBB73, X : STA.w EntranceIndex
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; CacheDoorFrameData
;--------------------------------------------------------------------------------
CacheDoorFrameData:
	LDA.l PreviousOverworldDoor : BEQ .originalBehaviour
	DEC : ASL : TAX
	LDA.l EntranceDoorFrameTable, X : STA.w TileMapEntranceDoors
	LDA.l EntranceAltDoorFrameTable, X : STA.w TileMapTile32
	BRA .done
	.originalBehaviour
		LDA.w $D724, X : STA.w TileMapEntranceDoors
		STZ.w TileMapTile32
	.done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; WalkDownIntoTavern
;--------------------------------------------------------------------------------
WalkDownIntoTavern:
	LDA.l PreviousOverworldDoor
	; tavern door has index 0x42 (saved off value is incremented by one)
	CMP.b #$43
RTL
;--------------------------------------------------------------------------------
