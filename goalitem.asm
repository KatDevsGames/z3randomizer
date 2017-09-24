;--------------------------------------------------------------------------------
; $7F5010 - Scratch Space (Callee Preserved)
;--------------------------------------------------------------------------------
!GOAL_COUNTER = "$7EF460"
DrawGoalIndicator:
	LDA.l GoalItemRequirement : AND.w #$00FF : BNE + : RTL : + ; Star Meter
	PHX
		LDX.w #$0000
		
		LDA.l GoalItemIcon : STA $7EC72C, X : INX #2 ; draw star icon and move the cursor
		
	    LDA.l !GOAL_COUNTER
		AND.w #$00FF
	    JSL.l HexToDec
		LDA $7F5005 : AND.w #$00FF : ORA.w #$2400 : STA $7EC72C, X : INX #2 ; draw 10's digit and move the cursor
		LDA $7F5006 : AND.w #$00FF : ORA.w #$2400 : STA $7EC72C, X : INX #2 ; draw 10's digit and move the cursor
		LDA $7F5007 : AND.w #$00FF : ORA.w #$2400 : STA $7EC72C, X : INX #2 ; draw 1's and move the cursor
		
		LDA.l GoalItemRequirement : AND.w #$00FF : CMP.w #$00FF : BEQ .skip
			LDA.w #$2830 : STA $7EC72C, X : INX #2 ; draw slash and move the cursor
		
			LDA.l GoalItemRequirement
			AND.w #$00FF
		    JSL.l HexToDec
			LDA $7F5006 : AND.w #$00FF : ORA.w #$2400 : STA $7EC72C, X : INX #2 ; draw 10's digit and move the cursor
			LDA $7F5007 : AND.w #$00FF : ORA.w #$2400 : STA $7EC72C, X : INX #2 ; draw 1's and move the cursor
			BRA .done
		.skip
			LDA.w #$207F
			STA $7EC72C, X : INX #
			STA $7EC72C, X : INX #
			STA $7EC72C, X : INX #
		.done
	PLX
RTL
;--------------------------------------------------------------------------------
GoalItemGanonCheck:
	LDA $0E20, X : CMP.b #$D6 : BNE .success ; skip if not ganon
		JSL.l CheckGanonVulnerability
		BCS .success
		
		.fail
		LDA $0D80, X : CMP.b #17 : !BLT .success ; decmial 17 because Acmlm's chart is decimal
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
	+ CMP #$03 : BNE +
		;#$03 = Require All Crystals and Aga 2
		LDA $7EF37A : AND.b #$7F : CMP #$7F : BNE .fail ; require all crystals
		LDA $7EF2DB : AND.b #$20 : CMP #$20 : BNE .fail ; require aga2 defeated (pyramid hole open)
		BRA .success
	+ CMP #$05 : BNE +
		;#$05 = Require 100 Goal Items
		LDA.l !GOAL_COUNTER : CMP.w #100 : !BLT .fail ; require 100 goal items
		BRA .success
	+
.fail : CLC : RTL
.success : SEC : RTL
;--------------------------------------------------------------------------------