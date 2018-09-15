;================================================================================
; Dark World Spawn Location Fix & Master Sword Grove Fix
;--------------------------------------------------------------------------------
DarkWorldSaveFix:
	LDA.b #$70 : PHA : PLB ; thing we wrote over - data bank change
	JSL.l MasterSwordFollowerClear
	JSL.l StatSaveCounter
RTL
;--------------------------------------------------------------------------------
DoWorldFix:
	LDA InvertedMode : BEQ +
		JMP DoWorldFix_Inverted
	+
	LDA.l Bugfix_MirrorlessSQToLW : BEQ .skip_mirror_check
		LDA $7EF353 : BEQ .noMirror ; check if we have the mirror
	.skip_mirror_check ; alt entrance point
	LDA $7EF3C5 : CMP.b #$03 : !BLT .aga1Alive ; check if agahnim 1 is alive
	BRA .done
	.noMirror
	.aga1Alive
	LDA #$00 : STA $7EF3CA ; set flag to light world
	LDA $7EF3CC : CMP #$07 : BNE + : LDA.b #$08 : STA $7EF3CC : + ; convert frog to dwarf
	.done
RTL
;--------------------------------------------------------------------------------
SetDeathWorldChecked:
	LDA InvertedMode : BEQ +
		JMP SetDeathWorldChecked_Inverted
	+
	LDA $1B : BEQ .outdoors
		LDA $040C : CMP #$FF : BNE .dungeon
		LDA $A0 : BNE ++
			LDA GanonPyramidRespawn : BNE .pyramid ; if flag is set, force respawn at pyramid on death to ganon
	    ++
	.outdoors
JMP DoWorldFix

	.dungeon
	LDA Bugfix_PreAgaDWDungeonDeathToFakeDW : BNE .done ; if the bugfix is enabled, we do nothing on death in dungeon
JMP DoWorldFix_skip_mirror_check

	.pyramid
	LDA #$40 : STA $7EF3CA ; set flag to dark world
	LDA $7EF3CC : CMP #$08 : BNE + : LDA.b #$07 : STA $7EF3CC : + ; convert dwarf to frog
	.done
RTL
;================================================================================
DoWorldFix_Inverted:
	LDA.l Bugfix_MirrorlessSQToLW : BEQ .skip_mirror_check
		LDA $7EF353 : BEQ .noMirror ; check if we have the mirror
	.skip_mirror_check ; alt entrance point
	LDA $7EF3C5 : CMP.b #$03 : !BLT .aga1Alive ; check if agahnim 1 is alive
	BRA .done
	.noMirror
	.aga1Alive
	LDA #$40 : STA $7EF3CA ; set flag to dark world
	LDA $7EF3CC
	CMP #$07 : BEQ .clear ; clear frog
	CMP #$08 : BEQ .clear ; clear dwarf - consider flute implications
	BRA .done
	.clear
	LDA.b #$00 : STA $7EF3CC ; clear follower
	.done
RTL
;--------------------------------------------------------------------------------
SetDeathWorldChecked_Inverted:
	LDA $1B : BEQ .outdoors
		LDA $040C : CMP #$FF : BNE .dungeon
		LDA $A0 : BNE ++
			LDA GanonPyramidRespawn : BNE .castle ; if flag is set, force respawn at pyramid on death to ganon
		++
	.outdoors
JMP DoWorldFix

	.dungeon
	LDA Bugfix_PreAgaDWDungeonDeathToFakeDW : BNE .done ; if the bugfix is enabled, we do nothing on death in dungeon
JMP DoWorldFix_Inverted_skip_mirror_check

	.castle
	LDA #$00 : STA $7EF3CA ; set flag to dark world
	LDA $7EF3CC : CMP #$07 : BNE + : LDA.b #$08 : STA $7EF3CC : + ; convert frog to dwarf
	.done
RTL
;================================================================================


;--------------------------------------------------------------------------------
FakeWorldFix:
	LDA FixFakeWorld : BEQ +
		LDA $8A : AND.b #$40 : STA $7EF3CA
	+
RTL
;--------------------------------------------------------------------------------
MasterSwordFollowerClear:
	LDA $7EF3CC
	CMP #$0E : BEQ .clear ; clear master sword follower
RTL
	.clear
	LDA.b #$00 : STA $7EF3CC ; clear follower
RTL
;--------------------------------------------------------------------------------
FixAgahnimFollowers:
	LDA.b #$00 : STA $7EF3CC ; clear follower
	JSL PrepDungeonExit ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
macro SetMinimum(base,filler,compare)
	LDA.l <compare> : !SUB.l <base> : !BLT ?done
		STA.l <filler>
	?done:
endmacro
RefreshRainAmmo:
	LDA $7EF3C5 : CMP.b #$01 : BEQ + : RTL : + ; check if we're in rain state
	.rain
		LDA $7EF3C8
		+ CMP.b #$03 : BNE + ; Uncle
			%SetMinimum($7EF36E,$7EF373,RainDeathRefillMagic_Uncle)
			%SetMinimum($7EF343,$7EF375,RainDeathRefillBombs_Uncle)
			%SetMinimum($7EF377,$7EF376,RainDeathRefillArrows_Uncle)
			BRA .done
		+ CMP.b #$02 : BNE + ; Cell
			%SetMinimum($7EF36E,$7EF373,RainDeathRefillMagic_Cell)
			%SetMinimum($7EF343,$7EF375,RainDeathRefillBombs_Cell)
			%SetMinimum($7EF377,$7EF376,RainDeathRefillArrows_Cell)
			BRA .done
		+ CMP.b #$04 : BNE + ; Mantle
			%SetMinimum($7EF36E,$7EF373,RainDeathRefillMagic_Mantle)
			%SetMinimum($7EF343,$7EF375,RainDeathRefillBombs_Mantle)
			%SetMinimum($7EF377,$7EF376,RainDeathRefillArrows_Mantle)
		+
	.done
RTL
;--------------------------------------------------------------------------------
!INFINITE_ARROWS = "$7F50C8"
!INFINITE_BOMBS = "$7F50C9"
!INFINITE_MAGIC = "$7F50CA"
SetEscapeAssist:
	LDA $7EF3C5 : CMP.b #$01 : BNE .notrain ; check if we're in rain state
	.rain
		LDA.l EscapeAssist
		BIT.b #$04 : BEQ + : STA !INFINITE_MAGIC : +
		BIT.b #$02 : BEQ + : STA !INFINITE_BOMBS : +
		BIT.b #$01 : BEQ + : STA !INFINITE_ARROWS : +
		BRA ++
	.notrain
		LDA.l EscapeAssist : BIT.b #$04 : BEQ + : LDA.b #$00 : STA !INFINITE_MAGIC : +
		LDA.l EscapeAssist : BIT.b #$02 : BEQ + : LDA.b #$00 : STA !INFINITE_BOMBS : +
		LDA.l EscapeAssist : BIT.b #$01 : BEQ + : LDA.b #$00 : STA !INFINITE_ARROWS : +
	++
RTL
;--------------------------------------------------------------------------------
SetSilverBowMode:
	LDA SilverArrowsUseRestriction : BEQ + ; fix bow type for restricted arrow mode
		LDA $7EF340 : CMP.b #$3 : !BLT +
		!SUB.b #$02 : STA $7EF340
	+
RTL
;================================================================================
