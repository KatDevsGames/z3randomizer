;--------------------------------------------------------------------------------
; $7F5010 - Scratch Space (Callee Preserved)
;--------------------------------------------------------------------------------
!GOAL_COUNTER = "$7EF418"
!GOAL_DRAW_ADDRESS = "$7EC72A"
;--------------------------------------------------------------------------------
; DrawGoalIndicator moved to newhud.asm
;--------------------------------------------------------------------------------
GoalItemGanonCheck:
	LDA $0E20, X : CMP.b #$D6 : BNE .success ; skip if not ganon
		JSL.l CheckGanonVulnerability
		BCS .success
		
		.fail
		LDA $0D80, X : CMP.b #17 : !BLT .success ; decimal 17 because Acmlm's chart is decimal
		LDA $0E60, X: OR.b #$40 : STA $0E60, X ; make Ganon completely impervious to damage
		LDA.b #$00
RTL
		.success
		LDA $44 : CMP.b #$80 ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
;Carry clear = ganon invincible
;Carry set = ganon vulnerable
CheckGanonVulnerability:
	LDA InvincibleGanon : BEQ .success
		;#$00 = Off
	+ : CMP #$01 : BEQ .fail
		;#$01 = On
	+ : CMP #$02 : BNE +
		;#$02 = Require All Dungeons
		LDA $7EF374 : AND.b #$07 : CMP #$07 : BNE .fail ; require all pendants
		LDA $7EF37A : AND.b #$7F : CMP #$7F : BNE .fail ; require all crystals
		LDA $7EF3C5 : CMP.b #$03 : !BLT .fail ; require post-aga world state
		LDA $7EF2DB : AND.b #$20 : CMP #$20 : BNE .fail ; require aga2 defeated (pyramid hole open)
		BRA .success
	+ : CMP #$04 : BNE +
		;#$04 = Require All Crystals
		LDA $7EF37A : AND.b #$7F : CMP #$7F : BNE .fail ; require all crystals
		BRA .success
	+ : CMP #$03 : BNE +
		;#$03 = Require All Crystals and Aga 2
		LDA $7EF37A : AND.b #$7F : CMP #$7F : BNE .fail ; require all crystals
		LDA $7EF2DB : AND.b #$20 : CMP #$20 : BNE .fail ; require aga2 defeated (pyramid hole open)
		BRA .success
	+ : CMP #$05 : BNE +
		;#$05 = Require 100 Goal Items
		LDA.l !GOAL_COUNTER : CMP.b #100 : !BLT .fail ; require 100 goal items
		BRA .success
	+ : CMP #$06 : BNE +
		;#$06 = Require "NumberOfCrystalsRequired" Crystals
		JSL CheckEnoughCrystals : BCC .fail
		BRA .success
	+
.fail : CLC : RTL
.success : SEC : RTL
;--------------------------------------------------------------------------------
GetRequriedCrystals:
	BEQ + : JSL.l BreakTowerSeal_ExecuteSparkles : + ; thing we wrote over
	LDA.l NumberOfCrystalsRequired : CMP.b #$00 : BNE + : JML.l Ancilla_BreakTowerSeal_stop_spawning_sparkles : +
	LDA.l NumberOfCrystalsRequired : CMP.b #$01 : BNE + : JML.l Ancilla_BreakTowerSeal_draw_single_crystal : +
	LDA.l NumberOfCrystalsRequired : DEC #2 : TAX
JML.l GetRequriedCrystals_continue
;--------------------------------------------------------------------------------
GetRequriedCrystalsInX:
	LDA.l NumberOfCrystalsRequired : CMP.b #$00 : BNE +
		TAX
		RTL
	+
	
	TXA : - : CMP.l NumberOfCrystalsRequired : !BLT + : !SUB.l NumberOfCrystalsRequired : BRA - : +
	
	INC : CMP.l NumberOfCrystalsRequired : BNE +
		LDA.b #$08
	+ : DEC : TAX
RTL
;--------------------------------------------------------------------------------
CheckEnoughCrystals:
	LDA InvincibleGanon : CMP #$06 : BNE .normal
	.other
	PHX : PHY
	LDA $7EF37A : JSL CountBits ; the comparison is against 1 less
	PLY : PLX
	CMP.l NumberOfCrystalsRequired
RTL

	.normal
	LDA $7EF37A : AND.b #$7F : CMP.b #$7F ; thing we wrote over
RTL
