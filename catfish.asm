;================================================================================
; Randomize Catfish
;--------------------------------------------------------------------------------
!HEART_REDRAW = "$7F5000"
LoadCatfishItemGFX:
    LDA.l $1DE185 ; location randomizer writes catfish item to
	JML PrepDynamicTile
;--------------------------------------------------------------------------------
DrawThrownItem:
	LDA $8A : CMP.b #$81 : BNE .catfish
	
	.zora
	LDA.b #$01 : STA !HEART_REDRAW
    LDA.l $1DE1C3 ; location randomizer writes zora item to
	BRA .draw
	
	.catfish
    LDA.l $1DE185 ; location randomizer writes catfish item to
	
	.draw
	JML DrawDynamicTile
;--------------------------------------------------------------------------------
MarkThrownItem:
	JSL Link_ReceiveItem ; thing we wrote over
	
	LDA $8A : CMP.b #$81 : BNE .catfish
	
	.zora
    JML ItemSet_ZoraKing

	.catfish
    JML ItemSet_Catfish

;--------------------------------------------------------------------------------