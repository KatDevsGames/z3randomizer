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
	STA $FFFFFF
	LDA !FORCE_PYRAMID : AND.b #$08 : BNE .pyramid
	
	LDA Bugfix_PreAgaDWDungeonDeathToFakeDW : BEQ +
		LDA $10 : CMP #$12 : BEQ .done ; don't do anything in death mode
	+
	LDA $1B : BEQ + ; skip this unless indoors - THIS PART FIXES THE OTHER FUCKUP WITH THE PYRAMID SPAWN IN GLITCHED
		LDA $A0 : BEQ .done ; skip if we died in ganon's room
	+
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
	PLA
RTL
	.pyramid
	LDA !FORCE_PYRAMID : AND.b #$F7 : STA !FORCE_PYRAMID ; clear pyramid flag
	LDA #$40 : STA $7EF3CA ; set flag to dark world
	LDA $7EF3CC : CMP #$08 : BNE + : LDA.b #$07 : STA $7EF3CC : + ; convert dwarf to frog
	PLA
RTL
;--------------------------------------------------------------------------------
SetDeathWorldChecked:
	PHA : STA $FFFFFF
	LDA $1B : BEQ + ; skip this for indoors
		LDA $040C : CMP #$FF : BNE .done ; unless it's a cave
	+
	LDA $7EF3C5 : CMP.b #$03 : !BGE .done; thing we originally did - skip if agahnim 1 is dead
	
	LDA $1B : BEQ + : LDA $A0 : BNE + ; check if we died in ganon's room
		LDA !FORCE_PYRAMID : ORA.b #$08 : STA !FORCE_PYRAMID ; set pyramid flag
		BRL DarkWorldFlagSet_pyramid
	+
	LDA.b #$00 : STA $7EF3CA : STA $7E0FFF ; set the world to the light world if he's still alive
	LDA $7EF3CC : CMP #$07 : BNE .done : LDA.b #$08 : STA $7EF3CC ; convert frog to dwarf
	.done
	PLA
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
;================================================================================