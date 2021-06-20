!INFINITE_BOMBS = "$7F50C9"
IsItemAvailable:
	LDA !INFINITE_BOMBS : BEQ .finite
	.infinite
		CPX.b #$04 : BNE .finite
		LDA.b #$01 : RTL
	.finite
		LDA $7EF33F, X
RTL
LoadBombCount:
	LDA !INFINITE_BOMBS : BNE .infinite
	.finite
		LDA $7EF343
	.infinite
RTL
LoadBombCount16:
	LDA !INFINITE_BOMBS : AND.w #$00FF : BNE .infinite
	.finite
		LDA $7EF343
	.infinite
RTL
StoreBombCount:
	PHA : LDA !INFINITE_BOMBS : BEQ .finite
	.infinite
		PLA : LDA.b #$01 : RTL
	.finite
		PLA : STA $7EF343
RTL
SearchForEquippedItem:
	LDA !INFINITE_BOMBS : BEQ +
		LDA.b #$01 : LDX.b #$00 : RTL
	+
	LDA $7EF340 ; thing we wrote over
RTL

!INFINITE_ARROWS = "$7F50C8"
DecrementArrows:
	LDA !INFINITE_ARROWS : BNE .infinite
	LDA.l ArrowMode : BNE .rupees : BRA .normal
	.infinite
		LDA.b #$01 : RTL
	.normal
		LDA $7EF377 : BEQ .done
		DEC : STA $7EF377 : INC
		BRA .done
	.rupees
		REP #$20
		LDA.b $A0 : CMP #$0111 : SEP #$20 : BNE .not_archery_game
			LDA.b $1B : BEQ .not_archery_game ; in overworld
			LDA.w $0B9A : BEQ .shoot_arrow ; arrow game active
			LDA.b #$00 : BRA .done
		
		.not_archery_game
		LDA.l $7EF377 : BNE .shoot_arrow ; check if we have arrows
			BRA .done
		
		.shoot_arrow
		PHX
		REP #$20
		LDA $7EF360 : BEQ +
			PHA : LDA $7EF340 : DEC : AND #$0002 : TAX : PLA
			!SUB.l ArrowModeWoodArrowCost, X ; CMP.w #$0000
			BMI .not_enough_money
				STA $7EF360 : LDA.w #$0001 : BRA +
			.not_enough_money
				LDA.w #$0000
		+
		SEP #$20 ; set 8-bit accumulator
		PLX
	.done
	CMP.b #$00
RTL

ArrowGame:
	LDA $0B99 : BEQ +
		DEC $0B99 ; reduce minigame arrow count
		LDA.l ArrowMode : BNE .rupees
		.normal
			LDA $7EF377 : INC #2 : STA $7EF377 ; increment arrow count (by 2 for some reason)
			RTL
		.rupees
			PHX
			REP #$20 ; set 16-bit accumulator
				LDA $7EF340 : DEC : AND #$0002 : TAX
				LDA $7EF360 : !ADD.l ArrowModeWoodArrowCost, X : STA $7EF360
			SEP #$20 ; set 8-bit accumulator
			PLX
	+
RTL
