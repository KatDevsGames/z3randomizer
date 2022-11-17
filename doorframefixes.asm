;================================================================================
; Door Frame Fixes
;================================================================================

;--------------------------------------------------------------------------------
; StoreLastOverworldDoorID
;--------------------------------------------------------------------------------
StoreLastOverworldDoorID:
	TXA : INC
	STA.l PreviousOverworldDoor
	LDA.l $1BBB73, X : STA.w $010E
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; CacheDoorFrameData
;--------------------------------------------------------------------------------
CacheDoorFrameData:
	LDA.l PreviousOverworldDoor : BEQ .originalBehaviour
	DEC : ASL : TAX
	LDA.l EntranceDoorFrameTable, X : STA.w $0696
	LDA.l EntranceAltDoorFrameTable, X : STA.w $0698
	BRA .done
	.originalBehaviour
		LDA.w $D724, X : STA.w $0696
		STZ.w $0698
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
