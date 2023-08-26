;================================================================================
; Randomize Book of Mudora
;--------------------------------------------------------------------------------
LoadLibraryItemGFX:
        %GetPossiblyEncryptedItem(LibraryItem, SpriteItemValues)
        JSL.l AttemptItemSubstitution
        JSL.l ResolveLootIDLong
        STA.w SpriteID, X
        JSL.l PrepDynamicTile_loot_resolved
RTL
;--------------------------------------------------------------------------------
DrawLibraryItemGFX:
        PHA
        LDA.w SpriteID, X
        JSL.l DrawDynamicTile
        PLA
RTL
;--------------------------------------------------------------------------------
SetLibraryItem:
        LDY.w SpriteID, X
        JSL.l ItemSet_Library ; contains thing we wrote over
RTL
;--------------------------------------------------------------------------------

;0x0087 - Hera Room w/key
;================================================================================
; Randomize Bonk Keys
;--------------------------------------------------------------------------------
LoadBonkItemGFX:
	LDA.b #$08 : STA.w SpriteOAMProp, X ; thing we wrote over
LoadBonkItemGFX_inner:
	LDA.b #$00 : STA.l RedrawFlag
	JSR LoadBonkItem
        JSL.l AttemptItemSubstitution
        JSL.l ResolveLootIDLong
        STA.w SpriteItemType, X
        STA.w SpriteID, X
	JSL.l PrepDynamicTile
        PHA : PHX
        LDA.w SpriteID,X : TAX
        LDA.l SpriteProperties_standing_width,X : BNE +
                LDA.b #$00 : STA.l SpriteOAM : STA.l SpriteOAM+8
        +
        PLX : PLA
RTL
;--------------------------------------------------------------------------------
DrawBonkItemGFX: 
        PHA
        LDA.l RedrawFlag : BEQ .skipInit
        JSL.l LoadBonkItemGFX_inner
        BRA .done ; don't draw on the init frame
        
	.skipInit
        LDA.w SpriteID,X
        JSL.l DrawDynamicTileNoShadow

        .done
        PLA
RTL
;--------------------------------------------------------------------------------
GiveBonkItem:
	JSR LoadBonkItem
	CMP.b #$24 : BNE .notKey
	.key
		PHY : LDY.b #$24 : JSL.l AddInventory : PLY ; do inventory processing for a small key
		LDA.l CurrentSmallKeys : INC A : STA.l CurrentSmallKeys
		LDA.b #$2F : JSL.l Sound_SetSfx3PanLong
		JSL CountBonkItem
RTL
	.notKey
		PHY : TAY : JSL.l Link_ReceiveItem : PLY
		JSL CountBonkItem
RTL
;--------------------------------------------------------------------------------
LoadBonkItem:
	LDA.b RoomIndex ; check room ID - only bonk keys in 2 rooms so we're just checking the lower byte
	CMP.b #115 : BNE + ; Desert Bonk Key
    	LDA.l BonkKey_Desert
		BRA ++
	+ : CMP.b #140 : BNE + ; GTower Bonk Key
    	LDA.l BonkKey_GTower
		BRA ++
	+
		LDA.b #$24 ; default to small key
	++
RTS
