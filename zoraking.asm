;================================================================================
; Randomize Zora King
;--------------------------------------------------------------------------------
LoadZoraKingItemGFX:
    LDA.l $1DE1C3 ; location randomizer writes zora item to
	JML.l PrepDynamicTile
;--------------------------------------------------------------------------------
JumpToSplashItemTarget:
	LDA $0D90, X
	CMP.b #$FF : BNE + : JML.l SplashItem_SpawnSplash : +
	CMP.b #$00 : JML.l SplashItem_SpawnOther
;--------------------------------------------------------------------------------