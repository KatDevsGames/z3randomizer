;================================================================================
; Open Mode Uncle Rain State Check
;================================================================================
!INFINITE_ARROWS = "$7F50C8"
!INFINITE_BOMBS = "$7F50C9"
!INFINITE_MAGIC = "$7F50CA"
SetUncleRainState:
	LDA.l OpenMode : BEQ + : RTL : + ; we're done if open mode is on
	LDA.b #$01 : STA ProgressIndicator
RTL
;--------------------------------------------------------------------------------
InitOpenMode:
	LDA.l OpenMode : BEQ + ; Skip if not open mode
		LDA ProgressIndicator : CMP #$02 : !BGE + ; Skip if already past escape
		LDA.b #$02 : STA ProgressIndicator ; Go to post-escape phase (pre aga1)
		LDA ProgressFlags : ORA #$14 : STA ProgressFlags ; remove uncle
		LDA StartingEntrance : CMP #$05 : BEQ ++ : LDA.b #$01 : ++ : STA StartingEntrance ; set spawn points to house+sanc unless already house+sanc+mountain
		LDA OverworldEventData+$1B : ORA.b #$20 : STA OverworldEventData+$1B ; open castle gate
		JSL MaybeSetPostAgaWorldState
	+
RTL
;--------------------------------------------------------------------------------
MaybeSetPostAgaWorldState:
	LDA.l InstantPostAgaWorldState : BEQ + ; Skip if not enabled
		LDA.b #$03 : STA ProgressIndicator ; Go to post-aga phase
		LDA OverworldEventData+$02 : ORA.b #$20 : STA OverworldEventData+$02 ; make lumberjack tree accessible
	+
RTL
;--------------------------------------------------------------------------------
