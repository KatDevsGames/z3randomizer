;================================================================================
; Randomize Catfish
;--------------------------------------------------------------------------------
LoadCatfishItemGFX:
        LDA.l $1DE185 ; location randomizer writes catfish item to
        JML PrepDynamicTile
;--------------------------------------------------------------------------------
DrawThrownItem:
        LDA.b $8A : CMP.b #$81 : BNE .catfish
                .zora
                LDA.b #$01 : STA.l RedrawFlag
                LDA.l $1DE1C3 ; location randomizer writes zora item to
                BRA .draw
                .catfish
                LDA.l $1DE185 ; location randomizer writes catfish item to
                .draw
                JML DrawDynamicTile
;--------------------------------------------------------------------------------
MarkThrownItem:
	JSL Link_ReceiveItem ; thing we wrote over
	LDA.b $8A : CMP.b #$81 : BNE .catfish
	        .zora
                JML ItemSet_ZoraKing
	        .catfish
                JML ItemSet_Catfish
;--------------------------------------------------------------------------------
