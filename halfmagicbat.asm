;================================================================================
; Randomize Half Magic Bat
;--------------------------------------------------------------------------------
GetMagicBatItem:
	JSL.l ItemSet_MagicBat
	%GetPossiblyEncryptedItem(MagicBatItem, SpriteItemValues)
	CMP.b #$FF : BEQ .normalLogic
	TAY
	STZ.b $02E9 ; 0 = Receiving item from an NPC or message
	JML.l Link_ReceiveItem
.normalLogic
	LDA.l HalfMagic
	STA.l MagicConsumption
RTL
;--------------------------------------------------------------------------------
