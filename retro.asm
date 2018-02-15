DecrementArrows:
	LDA.l ArrowMode : BNE .rupees
	.normal
    	LDA $7EF377 : BEQ .done
    	DEC A : STA $7EF377 : INC
		BRA .done
	.rupees
		LDA $7EF340 : AND.b #$01 : BEQ +
			LDA.b #$00 : RTL
		+
		PHX
		REP #$20 ; set 16-bit accumulator
    	LDA $7EF360 : BEQ +
			PHA : LDA $7EF340 : DEC : AND #$0002 : TAX : PLA
			!SUB.l ArrowModeWoodArrowCost, X ; CMP.w #$0000
			BMI .not_enough_money
				STA $7EF360 : INC : BRA +
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
		.rupees
			PHX
			REP #$20 ; set 16-bit accumulator
				PHA : LDA $7EF340 : DEC : AND #$0002 : TAX : PLA
		    	LDA $7EF360 : !ADD.l ArrowModeWoodArrowCost, X : STA $7EF360
			SEP #$20 ; set 8-bit accumulator
			PLX
	+
RTL
