;--------------------------------------------------------------------------------
; LockAgahnimDoors:
; Returns: 0=Unlocked - 1=Locked
;--------------------------------------------------------------------------------
LockAgahnimDoors:
	LDA.l AgahnimDoorStyle
	BNE +
		;#$0 = Never Locked
		LDA.w #$0000 : RTL
	+ : CMP.w #$0001 : BNE +
		JSR.w OldLockAgahnimDoors : RTL
	+
	LDA.w #$0000 ; fallback to never locked
RTL
;--------------------------------------------------------------------------------
OldLockAgahnimDoors:
	LDA $7EF3C5 : AND.w #$000F : CMP.w #$0002 : !BGE + ; if we rescued zelda, skip
		LDA $22 : CMP.w #1992 : !BLT + ; door too far left, skip
				  CMP.w #2088 : !BGE + ; door too rat right, skip
		LDA $20 : CMP.w #1720 : !BGE + ; door too low, skip
			LDA.w #$0001
RTS
	+
	LDA.w #$0000
RTS
;--------------------------------------------------------------------------------
SmithDoorCheck:
	LDA.l SmithTravelsFreely : AND.w #$00FF : BEQ .orig
		;If SmithTravelsFreely is set Frog/Smith can enter multi-entrance overworld doors
		JML.l Overworld_Entrance_BRANCH_RHO

	.orig ; The rest is equivlent to what we overwrote
	CPX.w #$0076 : !BGE +
		JML.l Overworld_Entrance_BRANCH_LAMBDA
	+

JML.l Overworld_Entrance_BRANCH_RHO
;--------------------------------------------------------------------------------
