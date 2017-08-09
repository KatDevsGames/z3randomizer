;================================================================================
; Hard & Masochist Mode
;================================================================================
CalculateSpikeFloorDamage:
		REP #$20 ; set 16-bit accumulator
		LDA $A0 ; these are all decimal because i got them that way
		CMP.w #279
		SEP #$20 ; set 8-bit accumulator
		BNE +
			LDA.l ByrnaCaveSpikeDamage
			STA $0373
			RTL
		+
	LDA $D055, Y
	STA $0373
RTL
;--------------------------------------------------------------------------------
CalculateByrnaUsage:
	LDA $1B : BEQ ++
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #279 : BEQ + ; Spike Cave
	CMP.w #179 : BEQ + ; Room in Misery Mire
	SEP #$20 ; set 8-bit accumulator
	BRA ++
	+
		SEP #$20 ; set 8-bit accumulator
		PHX : TYX
		LDA.l ByrnaCaveCaneOfByrnaUsage, X : STA $00
		PLX
	++
	LDA $7EF36E ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
CalculateCapeUsage:
	LDA $1B : BEQ ++
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #279 : BEQ + ; Spike Cave
	CMP.w #179 : BEQ + ; Room in Misery Mire
	SEP #$20 ; set 8-bit accumulator
	BRA ++
	+
		SEP #$20 ; set 8-bit accumulator
		PHX : TYX
		LDA.l ByrnaCaveCapeUsage, X : STA $4C ; set cape decrement timer
		PLX
	++
	LDA $7EF36E ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
