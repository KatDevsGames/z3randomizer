;================================================================================
; RNG Fixes
;--------------------------------------------------------------------------------
RigDigRNG:
	LDA $7FFE01 : CMP.l DiggingGameRNG : !BGE .forceHeart
	.normalItem
	JSL $0DBA71 ; GetRandomInt
RTL
	.forceHeart
	LDA $7FFE00 : BNE .normalItem
	LDA #$04
RTL
;--------------------------------------------------------------------------------
RigChestRNG:
	JSL.l DecrementChestCounter
	LDA $04C4 : CMP.l ChestGameRNG : BEQ .forceHeart
	.normalItem
	JSL $0DBA71 ; GetRandomInt
	AND.b #$07 ; restrict values to 0-7
	CMP #$07 : BEQ .notHeart
	JSL.l DecrementItemCounter
RTL
	.forceHeart
	LDA $0403 : AND.b #$40 : BNE .notHeart
	LDA #$07 ; give prize item
RTL
	.notHeart
	JSL.l DecrementItemCounter
	;LDA #$00 ; bullshit rupee farming in chest game
	
	JSL $0DBA71 ; GetRandomInt ; spam RNG until we stop getting the prize item
	AND.b #$07 ; restrict values to 0-7
	CMP #$07 : BNE + ; player got prize item AGAIN
		LDA.b #$00 ; give them money instead
	+
RTL
;--------------------------------------------------------------------------------