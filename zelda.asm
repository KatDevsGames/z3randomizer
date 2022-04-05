;================================================================================
; Spawn Zelda (or not)
;--------------------------------------------------------------------------------
SpawnZelda:
	LDA.l FollowerIndicator : CMP.b #$08 : BEQ + ; don't spawn if dwarf is present
	CMP.b #$07 : BEQ + ; don't spawn if frog is present
	CMP.b #$0C : BEQ + ; don't spawn if purple chest is present
		CLC
	+ RTL
;--------------------------------------------------------------------------------
EndRainState:
        LDA.l InitProgressIndicator : BIT.b #$80 : BNE + ; check for instant post-aga
                LDA.b #$02 : STA.l ProgressIndicator
                RTL
	+
        LDA.b #$03 : STA.l ProgressIndicator
        LDA.l InitLumberjackOW : STA.l OverworldEventDataWRAM+$02
RTL
;--------------------------------------------------------------------------------
