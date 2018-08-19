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
AllowStartFromSingleEntranceCave:
; 16 Bit A, 16 bit XY
; do not need to preserve A or X or Y
	LDA $7EF3C8 : AND.w #$00FF ; What we wrote over
	PHA
		TAX

		LDA.l StartingAreaExitOffset, X

		BNE +
			BRL .done
		+

		DEC
		STA $00
		LSR #2 : !ADD $00 : LSR #2 ; mult by 20
		TAX

		LDA #$0016 : STA $7EC142 ; Cache the main screen designation
		LDA.l StartingAreaExitTable+$05, X : STA $7EC144 ; Cache BG1 V scroll
		LDA.l StartingAreaExitTable+$07, X : STA $7EC146 ; Cache BG1 H scroll
		LDA.l StartingAreaExitTable+$09, X : !ADD.w #$0010 : STA $7EC148 ; Cache Link's Y coordinate
		LDA.l StartingAreaExitTable+$0B, X : STA $7EC14A ; Cache Link's X coordinate
		LDA.l StartingAreaExitTable+$0D, X : STA $7EC150 ; Cache Camera Y coord lower bound.
		LDA.l StartingAreaExitTable+$0F, X : STA $7EC152 ; Cache Camera X coord lower bound.
		LDA.l StartingAreaExitTable+$03, X : STA $7EC14E ; Cache Link VRAM Location

		; Handle the 2 "unknown" bytes, which control what area of the backgound
		; relative to the camera? gets loaded with new tile data as the player moves around
		; (because some overworld areas like Kak are too big for a single VRAM tilemap)

		LDA.l StartingAreaExitTable+$11, X : AND.w #$00FF
		BIT.w #$0080 : BEQ + : ORA #$FF00 : + ; Sign extend
		STA.l $7EC16A

		LDA.l StartingAreaExitTable+$12, X  : AND.w #$00FF
		BIT.w #$0080 : BEQ + : ORA #$FF00 : + ; Sign extend
		STA.l $7EC16E

		LDA.w #$0000 : !SUB.l $7EC16A : STA $7EC16C
		LDA.w #$0000 : !SUB.l $7EC16E : STA $7EC170

		LDA.l StartingAreaExitTable+$02, X : AND.w #$00FF
		STA $7EC14C ; Cache the overworld area number
		STA $7EC140 ; Cache the aux overworld area number

		.done
	PLA
RTL
;--------------------------------------------------------------------------------
