;================================================================================
; Randomize Book of Mudora
;--------------------------------------------------------------------------------
LoadLibraryItemGFX:
        %GetPossiblyEncryptedItem(LibraryItem, SpriteItemValues)
        STA.w SpriteItemType, X ; Store item type
        JSL.l PrepDynamicTile
RTL
;--------------------------------------------------------------------------------
DrawLibraryItemGFX:
        PHA
        LDA.w SpriteItemType, X ; Retrieve stored item type
        JSL.l DrawDynamicTile
        PLA
RTL
;--------------------------------------------------------------------------------
SetLibraryItem:
        LDY.w SpriteItemType, X ; Retrieve stored item type
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
	JSL.l PrepDynamicTile
RTL
;--------------------------------------------------------------------------------
DrawBonkItemGFX: 
        PHA
        LDA.l RedrawFlag : BEQ .skipInit ; skip init if already ready
        JSL.l LoadBonkItemGFX_inner
        BRA .done ; don't draw on the init frame
        
	.skipInit
        JSR LoadBonkItem
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
