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
		LDA $7F5006 : AND.w #$00FF : ORA.w #$2400 : STA $7EC72C, X : INX #2 ; draw 10's digit and move the cursor
		LDA $7F5007 : AND.w #$00FF : ORA.w #$2400 : STA $7EC72C, X : INX #2 ; draw 1's and move the cursor
		
		LDA.w #$2830 : STA $7EC72C, X : INX #2 ; draw slash and move the cursor
		
		LDA.l GoalItemRequirement
		AND.w #$00FF
	    JSL.l HexToDec
		LDA $7F5006 : AND.w #$00FF : ORA.w #$2400 : STA $7EC72C, X : INX #2 ; draw 10's digit and move the cursor
		LDA $7F5007 : AND.w #$00FF : ORA.w #$2400 : STA $7EC72C, X : INX #2 ; draw 1's and move the cursor
	PLX
RTL
;--------------------------------------------------------------------------------
GoalItemGanonCheck:
	LDA $0E20, X : CMP.b #$D6 : BNE .success ; skip if not ganon
		LDA InvincibleGanon : BNE +
			;#$00 = Off
			BRA .success
		+ : CMP #$01 : BNE +
			;#$01 = On
			RTL
		+ ; CMP #$02 BNE + this is a comment
			;#$02 = Require All Dungeons
			LDA $7EF374 : AND.b #$07 : CMP #$07 : BNE .fail ; require all pendants
			LDA $7EF37A : AND.b #$7F : CMP #$7F : BNE .fail ; require all crystals
			LDA $7EF3C5 : CMP.b #$03 : !BLT .fail ; require post-aga world state
			BRA .success
		.fail
		LDA.b #$00
RTL
		.success
		LDA $44 : CMP.b #$80 ; thing we wrote over
RTL
;--------------------------------------------------------------------------------