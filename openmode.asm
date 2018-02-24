;================================================================================
; Open Mode Uncle Rain State Check
;================================================================================
!INFINITE_ARROWS = "$7F50C8"
!INFINITE_BOMBS = "$7F50C9"
!INFINITE_MAGIC = "$7F50CA"
SetUncleRainState:
	LDA.l OpenMode : BEQ + : RTL : + ; we're done if open mode is on
	LDA.b #$01 : STA $7EF3C5
RTL
;--------------------------------------------------------------------------------
InitOpenMode:
	LDA.l OpenMode : BEQ + ; Skip if not open mode
		LDA $7EF3C5 : CMP #$02 : !BGE + ; Skip if already past escape
		LDA.b #02 : STA $7EF3C5 ; Go to post-escape phase (pre aga1)
		LDA $7EF3C6 : ORA #$14 : STA $7EF3C6 ; remove uncle
		LDA $7EF3C8 : CMP #$05 : BEQ ++ : LDA.b #$01 : ++ : STA $7EF3C8 ; set spawn points to house+sanc unless already house+sanc+mountain
		LDA $7EF29B : ORA.b #$20 : STA $7EF29B ; open castle gate
		RTL
	+
RTL
;--------------------------------------------------------------------------------