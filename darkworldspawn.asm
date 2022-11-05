;================================================================================
; Dark World Spawn Location Fix & Master Sword Grove Fix
;--------------------------------------------------------------------------------
DarkWorldSaveFix:
	LDA.b #$70 : PHA : PLB ; thing we wrote over - data bank change
	JSL.l MasterSwordFollowerClear
	JML.l StatSaveCounter
;--------------------------------------------------------------------------------
DoWorldFix:
	LDA.l InvertedMode : BEQ +
		JMP DoWorldFix_Inverted
	+
	LDA.l Bugfix_MirrorlessSQToLW : BEQ .skip_mirror_check
                LDA.l FollowerIndicator : CMP.b #$04 : BEQ .setLightWorld ; check if old man is following
		LDA.l MirrorEquipment : BEQ .noMirror ; check if we have the mirror
	.skip_mirror_check ; alt entrance point
	LDA.l ProgressIndicator : CMP.b #$03 : BCS .done ; check if agahnim 1 is alive
        .setLightWorld
	LDA.b #$00
	.noMirror
	STA.l CurrentWorld ; set flag to light world
	LDA.l FollowerIndicator : CMP.b #$07 : BNE .done : INC : STA.l FollowerIndicator ; convert frog to dwarf
	.done
RTL
;--------------------------------------------------------------------------------
SetDeathWorldChecked:
	LDA.l InvertedMode : BEQ +
		JMP SetDeathWorldChecked_Inverted
	+
	LDA.b $1B : BEQ .outdoors
		LDA.w $040C : CMP #$FF : BNE .dungeon
		LDA.b $A0 : ORA.b $A1 : BNE ++
			LDA.l GanonPyramidRespawn : BNE .pyramid ; if flag is set, force respawn at pyramid on death to ganon
	    ++
	.outdoors
JMP DoWorldFix

	.dungeon
	LDA.l Bugfix_PreAgaDWDungeonDeathToFakeDW : BNE .done ; if the bugfix is enabled, we do nothing on death in dungeon
JMP DoWorldFix_skip_mirror_check

	.pyramid
	LDA.b #$40 : STA.l CurrentWorld ; set flag to dark world
	LDA.l FollowerIndicator : CMP.b #$08 : BNE .done : DEC : STA.l FollowerIndicator : + ; convert dwarf to frog
	.done
RTL
;================================================================================
DoWorldFix_Inverted:
	LDA.l Bugfix_MirrorlessSQToLW : BEQ .skip_mirror_check
                LDA.l FollowerIndicator : CMP.b #$04 : BEQ .setDarkWorld ; check if old man is following
		LDA.l MirrorEquipment : BEQ .setDarkWorld ; check if we have the mirror
	.skip_mirror_check ; alt entrance point
	LDA.l ProgressIndicator : CMP.b #$03 : BCS .done ; check if agahnim 1 is alive
        .setDarkWorld
	LDA.b #$40 : STA CurrentWorld ; set flag to dark world
	LDA.l FollowerIndicator
	CMP.b #$07 : BEQ .clear ; clear frog
	CMP.b #$08 : BEQ .clear ; clear dwarf - consider flute implications
	BRA .done
	.clear
	LDA.b #$00 : STA FollowerIndicator ; clear follower
	.done
RTL
;--------------------------------------------------------------------------------
SetDeathWorldChecked_Inverted:
	LDA.b $1B : BEQ .outdoors
		LDA.w $040C : CMP #$FF : BNE .dungeon
		LDA.b $A0 : ORA $A1 : BNE ++
			LDA.l GanonPyramidRespawn : BNE .castle ; if flag is set, force respawn at pyramid on death to ganon
		++
	.outdoors
JMP DoWorldFix

	.dungeon
	LDA.l Bugfix_PreAgaDWDungeonDeathToFakeDW : BNE .done ; if the bugfix is enabled, we do nothing on death in dungeon
JMP DoWorldFix_Inverted_skip_mirror_check

	.castle
	LDA.b #$00 : STA.l CurrentWorld ; set flag to dark world
	LDA.l FollowerIndicator : CMP.b #$07 : BNE + : LDA.b #$08 : STA FollowerIndicator : + ; convert frog to dwarf
	.done
RTL
;================================================================================


;--------------------------------------------------------------------------------
FakeWorldFix:
	LDA.l FixFakeWorld : BEQ +
		LDA.b $8A : AND.b #$40 : STA.l CurrentWorld
	+
RTL
;--------------------------------------------------------------------------------
MasterSwordFollowerClear:
	LDA.l FollowerIndicator
	CMP.b #$0E : BNE .exit ; clear master sword follower
	LDA.b #$00 : STA.l FollowerIndicator ; clear follower
.exit
	RTL
;--------------------------------------------------------------------------------
FixAgahnimFollowers:
	LDA.b #$00 : STA.l FollowerIndicator ; clear follower
	JML PrepDungeonExit ; thing we wrote over

;--------------------------------------------------------------------------------
macro SetMinimum(base,filler,compare)
	LDA.l <compare> : !SUB.l <base> : !BLT ?done
		STA.l <filler>
	?done:
endmacro
RefreshRainAmmo:
	LDA.l ProgressIndicator : CMP.b #$01 : BEQ .rain ; check if we're in rain state
	RTL
	.rain
		LDA.l StartingEntrance
		+ CMP.b #$03 : BNE + ; Uncle
			%SetMinimum(CurrentMagic,MagicFiller,RainDeathRefillMagic_Uncle)
			%SetMinimum(BombsEquipment,BombsFiller,RainDeathRefillBombs_Uncle)
			%SetMinimum(CurrentArrows,ArrowsFiller,RainDeathRefillArrows_Uncle)
			BRA .done
		+ CMP.b #$02 : BNE + ; Cell
			%SetMinimum(CurrentMagic,MagicFiller,RainDeathRefillMagic_Cell)
			%SetMinimum(BombsEquipment,BombsFiller,RainDeathRefillBombs_Cell)
			%SetMinimum(CurrentArrows,ArrowsFiller,RainDeathRefillArrows_Cell)
			BRA .done
		+ CMP.b #$04 : BNE + ; Mantle
			%SetMinimum(CurrentMagic,MagicFiller,RainDeathRefillMagic_Mantle)
			%SetMinimum(BombsEquipment,BombsFiller,RainDeathRefillBombs_Mantle)
			%SetMinimum(CurrentArrows,ArrowsFiller,RainDeathRefillArrows_Mantle)
		+
	.done
RTL
;--------------------------------------------------------------------------------
SetEscapeAssist:
	LDA.l ProgressIndicator : CMP.b #$01 : BNE .no_train ; check if we're in rain state
	.rain
		LDA.l EscapeAssist
		BIT.b #$04 : BEQ + : STA.l InfiniteArrows : +
		BIT.b #$02 : BEQ + : STA.l InfiniteBombs : +
		BIT.b #$01 : BEQ + : STA.l InfiniteArrows : +
		BRA ++
	.no_train ; choo choo
		LDA.l EscapeAssist : BIT.b #$04 : BEQ + : LDA.b #$00 : STA.l InfiniteMagic : +
		LDA.l EscapeAssist : BIT.b #$02 : BEQ + : LDA.b #$00 : STA.l InfiniteBombs : +
		LDA.l EscapeAssist : BIT.b #$01 : BEQ + : LDA.b #$00 : STA.l InfiniteArrows : +
	++
RTL
;--------------------------------------------------------------------------------
SetSilverBowMode:
	LDA.l SilverArrowsUseRestriction : BEQ + ; fix bow type for restricted arrow mode
		LDA.l BowEquipment : CMP.b #$3 : BCC +
		SBC.b #$02 : STA.l BowEquipment
	+
RTL
;================================================================================
