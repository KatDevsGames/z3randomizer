;--------------------------------------------------------------------------------
; LockAgahnimDoors:
; Returns: 0=Unlocked - 1=Locked
;--------------------------------------------------------------------------------
LockAgahnimDoors:
	LDA $7EF3C5 : AND.w #$000F : CMP.w #$0002 : !BGE + ; if we rescued zelda, skip
		LDA $22 : CMP.w #1992 : !BLT + ; door too far left, skip
				  CMP.w #2088 : !BGE + ; door too rat right, skip
		LDA $20 : CMP.w #1720 : !BGE + ; door too low, skip
			LDA.w #$0001
RTL
	+
	LDA.w #$0000
RTL
;--------------------------------------------------------------------------------