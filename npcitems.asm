;================================================================================
; Randomize NPC Items
;--------------------------------------------------------------------------------
; Old Man - Zora King - Sick Kid - Tree Kid - Sahasrala - Catfish - Rupee NPC
;=SET 1
;OLD_MAN = "#$01"
;ZORA_KING = "#$02"
;SICK_KID = "#$04"
;TREE_KID = "#$08"
;SAHASRALA = "#$10"
;CATFISH = "#$20"
;UNUSED = "#$40"
;BOOK_MUDORA = "#$80"
;=SET 2
;ETHER_TABLET = "#$01"
;BOMBOS_TABLET = "#$02"
;SMITH_SWORD = "#$04"
;FAIRY_SWORD = "#$08"
;MUSHROOM = "#$10"
;POWDER = "#$20"
;UNUSED = "#$40"
;MAGIC_BAT = "#$80"
;--------------------------------------------------------------------------------

ItemCheck_FairySword:
	LDA.l NpcFlags+1 : AND.b #$08
RTL

ItemCheck_SmithSword:
	LDA.l NpcFlags+1 : AND.b #$04
RTL

ItemCheck_MagicBat:
	LDA.l NpcFlags+1 : AND.b #$80
RTL

ItemCheck_OldMan:
	LDA.l NpcFlags : AND.b #$01 : CMP.b #$01
RTL

ItemCheck_ZoraKing:
	LDA.l NpcFlags : AND.b #$02
RTL

ItemCheck_SickKid:
	LDA.l NpcFlags : AND.b #$04
RTL

ItemCheck_TreeKid:
	LDA.l NpcFlags : AND.b #$08
RTL

ItemCheck_TreeKid2:
	LDA.l NpcFlags : AND.b #$08
        LSR #2
RTL

ItemCheck_TreeKid3:
	JSL $8DD030 ; FluteAardvark_Draw - thing we wrote over
	LDA.l NpcFlags : AND.b #$08
	BNE .done
	LDA.b #$05
.normal
	LDA.w SpriteActivity, X
.done
	RTL

ItemCheck_Sahasrala:
	LDA.l NpcFlags : AND.b #$10
RTL

ItemCheck_Library:
	LDA.l NpcFlags : AND.b #$80
RTL

ItemCheck_Mushroom:
	LDA.l NpcFlags+1 : AND.b #$10 : CMP.b #$10 ; does the same thing as below
RTL

ItemCheck_Powder:
	LDA.l NpcFlags+1 : AND.b #$20
RTL

ItemCheck_Catfish:
	LDA.l NpcFlags : AND.b #$20
RTL
;--------------------------------------------------------------------------------
ItemSet_FairySword:
	PHA : LDA.l NpcFlags+1 : ORA.b #$08 : STA.l NpcFlags+1 : PLA
RTL

ItemSet_SmithSword:
	PHA : LDA.l NpcFlags+1 : ORA.b #$04 : STA.l NpcFlags+1 : PLA
RTL

ItemSet_MagicBat:
	PHA : LDA.l NpcFlags+1 : ORA.b #$80 : STA.l NpcFlags+1 : PLA
RTL

ItemSet_OldMan:
	JSL.l Link_ReceiveItem ; thing we wrote over
	PHA : LDA.l NpcFlags : ORA.b #$01 : STA.l NpcFlags : PLA
RTL

ItemSet_ZoraKing:
	PHA : LDA.l NpcFlags : ORA.b #$02 : STA.l NpcFlags : PLA
RTL

ItemSet_SickKid:
	JSL.l Link_ReceiveItem ; thing we wrote over
	PHA : LDA.l NpcFlags : ORA.b #$04 : STA.l NpcFlags : PLA
RTL

ItemSet_TreeKid:
	JSL.l Link_ReceiveItem ; thing we wrote over
	PHA : LDA.l NpcFlags : ORA.b #$08 : STA.l NpcFlags : PLA
RTL

ItemSet_Sahasrala:
	JSL.l Link_ReceiveItem ; thing we wrote over
	PHA : LDA.l NpcFlags : ORA.b #$10 : STA.l NpcFlags : PLA
RTL

ItemSet_Catfish:
	PHA : LDA.l NpcFlags : ORA.b #$20 : STA.l NpcFlags : PLA
RTL

ItemSet_Library:
	JSL.l Link_ReceiveItem ; thing we wrote over
	PHA : LDA.l NpcFlags : ORA.b #$80 : STA.l NpcFlags : PLA
RTL

ItemSet_Mushroom:
	PHA
		LDA.l NpcFlags+1 : ORA.b #$10 : STA.l NpcFlags+1
		LDY.w SpriteID, X ; Retrieve stored item type
		BNE +
			; if for any reason the item value is 0 reload it, just in case
			%GetPossiblyEncryptedItem(MushroomItem, SpriteItemValues) : TAY
		+
	PLA
	STZ.w ItemReceiptMethod ; thing we wrote over - the mushroom is an npc for item purposes apparently
RTL

ItemSet_Powder:
	PHA : LDA.l NpcFlags+1 : ORA.b #$20 : STA.l NpcFlags+1 : PLA
RTL
;================================================================================

;================================================================================
; Randomize 300 Rupee NPC
;--------------------------------------------------------------------------------
Set300RupeeNPCItem:
	INC.w SpriteActivity, X ; thing we wrote over

	PHA : PHP
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #291 : BNE +
		%GetPossiblyEncryptedItem(RupeeNPC_MoldormCave, SpriteItemValues)
		TAY ; load moldorm cave value into Y
		BRA .done
	+ CMP.w #286 : BNE +
		%GetPossiblyEncryptedItem(RupeeNPC_NortheastDarkSwampCave, SpriteItemValues)
		TAY ; load northeast dark swamp cave value into Y
		BRA .done
	+
	LDY.b #$46 ; default to a normal 300 rupees
	.done
	PLP : PLA
RTL

;================================================================================
; Randomize Zora King
;--------------------------------------------------------------------------------
LoadZoraKingItemGFX:
        LDA.l $9DE1C3 ; location randomizer writes zora item to
        JSL.l AttemptItemSubstitution
        JSL.l ResolveLootIDLong
        STA.w SpriteID,Y
        TYX
        JML.l PrepDynamicTile_loot_resolved
;--------------------------------------------------------------------------------
JumpToSplashItemTarget:
	LDA.w SpriteMovement, X
	CMP.b #$FF : BNE + : JML.l SplashItem_SpawnSplash : +
	CMP.b #$00 : JML.l SplashItem_SpawnOther

;================================================================================
; Randomize Catfish
;--------------------------------------------------------------------------------
LoadCatfishItemGFX:
        LDA.l $9DE185 ; location randomizer writes catfish item to
        JSL.l AttemptItemSubstitution
        JSL.l ResolveLootIDLong
	STA.w SpriteID, Y
        TYX
	JML.l PrepDynamicTile_loot_resolved
;--------------------------------------------------------------------------------
DrawThrownItem:
        LDA.b OverworldIndex : CMP.b #$81 : BNE .catfish
                .zora
                LDA.b #$01 : STA.l RedrawFlag
                BRA .draw
                .catfish
                .draw
                LDA.w SpriteID,X
                JML DrawDynamicTile
;--------------------------------------------------------------------------------
MarkThrownItem:
	JSL Link_ReceiveItem ; thing we wrote over
	LDA.b OverworldIndex : CMP.b #$81 : BNE .catfish
	        .zora
                JML ItemSet_ZoraKing
	        .catfish
                JML ItemSet_Catfish
;--------------------------------------------------------------------------------
