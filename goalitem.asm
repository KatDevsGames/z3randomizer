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