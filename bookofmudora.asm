;================================================================================
; Randomize Book of Mudora
;--------------------------------------------------------------------------------
LoadLibraryItemGFX:
	%GetPossiblyEncryptedItem(LibraryItem, SpriteItemValues)
	STA $0E80, X ; Store item type
	JSL.l PrepDynamicTile
RTL
;--------------------------------------------------------------------------------
DrawLibraryItemGFX:
	PHA
    LDA $0E80, X ; Retrieve stored item type
	JSL.l DrawDynamicTile
	PLA
RTL
;--------------------------------------------------------------------------------
SetLibraryItem:
    PHA
	LDY $0E80, X ; Retrieve stored item type
	PLA
	JSL.l ItemSet_Library ; contains thing we wrote over
RTL
;--------------------------------------------------------------------------------

;0x0087 - Hera Room w/key
;================================================================================
; Randomize Bonk Keys
;--------------------------------------------------------------------------------
!REDRAW = "$7F5000"
;--------------------------------------------------------------------------------
LoadBonkItemGFX:
	LDA.b #$08 : STA $0F50, X ; thing we wrote over
LoadBonkItemGFX_inner:
	LDA.b #$00 : STA !REDRAW
	JSR LoadBonkItem
	JSL.l PrepDynamicTile
RTL
;--------------------------------------------------------------------------------
DrawBonkItemGFX: 
	PHA
	LDA !REDRAW : BEQ .skipInit ; skip init if already ready
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
	CMP #$24 : BNE .notKey
	.key
		PHY : LDY.b #$24 : JSL.l AddInventory : PLY ; do inventory processing for a small key
		LDA $7EF36F : INC A : STA $7EF36F
		LDA.b #$2F : JSL.l Sound_SetSfx3PanLong
RTL
	.notKey
		PHY : TAY : JSL.l Link_ReceiveItem : PLY
RTL
;--------------------------------------------------------------------------------
LoadBonkItem:
	LDA $A0 ; check room ID - only bonk keys in 2 rooms so we're just checking the lower byte
	CMP #115 : BNE + ; Desert Bonk Key
    	LDA.l BonkKey_Desert
		BRA ++
	+ : CMP #140 : BNE + ; GTower Bonk Key
    	LDA.l BonkKey_GTower
		BRA ++
	+
		LDA.b #$24 ; default to small key
	++
RTS