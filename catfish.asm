;================================================================================
; Randomize Catfish
;--------------------------------------------------------------------------------
LoadCatfishItemGFX:
    LDA.l $1DE185 ; location randomizer writes catfish item to
	JSL.l PrepDynamicTile
RTL
;--------------------------------------------------------------------------------
DrawThrownItem:
	LDA $8A : CMP.b #$81 : BNE .catfish
	
	.zora
    LDA.l $1DE1C3 ; location randomizer writes zora item to
	BRA .draw
	
	.catfish
    LDA.l $1DE185 ; location randomizer writes catfish item to
	
	.draw
	JSL.l DrawDynamicTile
RTL
;--------------------------------------------------------------------------------
MarkThrownItem:
	JSL Link_ReceiveItem ; thing we wrote over
	
	LDA $8A : CMP.b #$81 : BNE .catfish
	
	.zora
    JSL.l ItemSet_ZoraKing
	BRA .done
	
	.catfish
    JSL.l ItemSet_Catfish
	
	.done
RTL
;--------------------------------------------------------------------------------