;================================================================================
; Dark World Spawn Location Fix & Master Sword Grove Fix
;--------------------------------------------------------------------------------
DarkWorldSaveFix:
	LDA.b #$70 : PHA : PLB ; thing we wrote over - data bank change
	JSL.l DarkWorldFlagSet
	JSL.l MasterSwordFollowerClear
	JSL.l StatSaveCounter
RTL
;--------------------------------------------------------------------------------
DarkWorldLoadFix:
	SEP #$20 ; set 8 bit accumulator
	JSL.l OnFileLoad
	REP #$20 ; restore 16 bit accumulator
	LDA.w #$0007 : STA $7EC00D : STA $7EC013 ; thing we wrote over - sets up some graphics timers
RTL
;--------------------------------------------------------------------------------
DarkWorldFlagSet:
	PHA
	
	LDA Bugfix_PreAgaDWDungeonDeathToFakeDW : BEQ +
		LDA $10 : CMP #$12 : BEQ .done ; don't do anything in death mode
	+
	LDA $1B : BNE + ; skip this unless indoors - THIS PART FIXES THE OTHER FUCKUP WITH THE PYRAMID SPAWN IN GLITCHED
		LDA $A0 : BEQ .done ; skip if we died in ganon's room
	+
	JSL.l DoWorldFix
	.done
	PLA
RTL
;--------------------------------------------------------------------------------
DoWorldFix:
	LDA.l Bugfix_MirrorlessSQToLW : BEQ +
		LDA $7EF353 : BEQ .noMirror ; check if we have the mirror
	+
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
	LDA $1B : BEQ + ; skip this for indoors
		LDA $040C : CMP #$FF : BNE .done ; unless it's a cave

		LDA $A0 : BNE + : LDA GanonPyramidRespawn : BEQ + ; check if we died in ganon's room and pyramid respawn is enabled
			BRA .pyramid
	+
JMP DoWorldFix
	.pyramid
	LDA #$40 : STA $7EF3CA ; set flag to dark world
	LDA $7EF3CC : CMP #$08 : BNE + : LDA.b #$07 : STA $7EF3CC : + ; convert dwarf to frog
	.done
RTL
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
	;CMP #$07 : BEQ .clear ; clear frog
	;CMP #$08 : BEQ .clear ; clear dwarf - consider flute implications
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
macro SetMinimum(base,compare)
	LDA.l <compare> : CMP.l <base> : !BLT ?done
		STA.l <base>
	?done:
endmacro
RefreshRainAmmo:
	LDA $7EF3C5 : CMP.b #$01 : BEQ + : RTL : + ; check if we're in rain state
	.rain
		LDA $7EF3C8
		+ CMP.b #$03 : BNE + ; Uncle
			%SetMinimum($7EF36E,RainDeathRefillMagic_Uncle)
			%SetMinimum($7EF375,RainDeathRefillBombs_Uncle)
			%SetMinimum($7EF377,RainDeathRefillArrows_Uncle)
			BRA .done
		+ CMP.b #$02 : BNE + ; Cell
			%SetMinimum($7EF36E,RainDeathRefillMagic_Cell)
			%SetMinimum($7EF375,RainDeathRefillBombs_Cell)
			%SetMinimum($7EF377,RainDeathRefillArrows_Cell)
			BRA .done
		+ CMP.b #$04 : BNE + ; Mantle
			%SetMinimum($7EF36E,RainDeathRefillMagic_Mantle)
			%SetMinimum($7EF375,RainDeathRefillBombs_Mantle)
			%SetMinimum($7EF377,RainDeathRefillArrows_Mantle)
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
