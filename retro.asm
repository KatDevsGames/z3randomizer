LoadBombCount:
	LDA.l InfiniteBombs : BNE .infinite
	.finite
		LDA.l BombsEquipment
	.infinite
RTL
LoadBombCount16:
	LDA.l InfiniteBombs : AND.w #$00FF : BNE .infinite
	.finite
		LDA.l BombsEquipment
	.infinite
RTL
StoreBombCount:
	LDA.b #$01 : STA.l UpdateHUDFlag
	PHA : LDA.l InfiniteBombs : BEQ .finite
	.infinite
		PLA : LDA.b #$01 : RTL
	.finite
		PLA : STA.l BombsEquipment
RTL
SearchForEquippedItem:
	LDA.l InfiniteBombs : BEQ +
		LDA.b #$01 : LDX.b #$00 : RTL
	+
	LDA.l BowEquipment ; thing we wrote over
RTL

DecrementArrows:
	LDA.l InfiniteArrows : BNE .infinite
	LDA.l ArrowMode : BNE .rupees : BRA .normal
	.infinite
		LDA.b #$01 : RTL
	.normal
		LDA.l CurrentArrows : BEQ .done
		DEC : STA.l CurrentArrows : INC
		BRA .done
	.rupees
		REP #$20
		LDA.b RoomIndex : CMP.w #$0111 : SEP #$20 : BNE .not_archery_game
			LDA.b IndoorsFlag : BEQ .not_archery_game ; in overworld
			LDA.w $0B9A : BEQ .shoot_arrow ; arrow game active
			LDA.b #$00 : BRA .done
		
		.not_archery_game
		LDA.l CurrentArrows : BNE .shoot_arrow ; check if we have arrows
			BRA .done
		
		.shoot_arrow
		PHX
		REP #$20
		LDA.l CurrentRupees : BEQ +
			PHA : LDA.l BowEquipment : DEC : AND.w #$0002 : TAX : PLA
			!SUB.l ArrowModeWoodArrowCost, X ; CMP.w #$0000
			BMI .not_enough_money
				STA.l CurrentRupees : LDA.w #$0001 : BRA +
			.not_enough_money
				LDA.w #$0000
		+
		SEP #$20 ; set 8-bit accumulator
		PLX
	.done
	CMP.b #$00
RTL

ArrowGame:
	LDA.w $0B99 : BEQ +
		DEC $0B99 ; reduce minigame arrow count
		LDA.l ArrowMode : BNE .rupees
		.normal
			LDA.l CurrentArrows : INC #2 : STA.l CurrentArrows ; increment arrow count (by 2 for some reason)
			RTL
		.rupees
			PHX
			REP #$20 ; set 16-bit accumulator
				LDA.l BowEquipment : DEC : AND.w #$0002 : TAX
				LDA.l CurrentRupees : !ADD.l ArrowModeWoodArrowCost, X : STA.l CurrentRupees
			SEP #$20 ; set 8-bit accumulator
			PLX
	+
RTL
