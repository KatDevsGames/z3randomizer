;================================================================================
; Randomize Half Magic Bat
;--------------------------------------------------------------------------------
GetMagicBatItem:
	JSL.l ItemSet_MagicBat
	%GetPossiblyEncryptedItem(MagicBatItem, SpriteItemValues)
	CMP.b #$FF : BEQ .normalLogic
	TAY
	STZ $02E9 ; 0 = Receiving item from an NPC or message
	JSL.l Link_ReceiveItem
RTL
.normalLogic
	LDA HalfMagic
	STA $7EF37B
RTL
;--------------------------------------------------------------------------------