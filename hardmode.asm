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
	CMP.w #95 : BEQ + ; Ice Palace Spike Room
	CMP.w #172 : BEQ + ; Blind Boss Room
	CMP.w #179 : BEQ + ; Room in Misery Mire
	CMP.w #213 : BEQ + ; Laser Bridge
	CMP.w #279 : BEQ + ; Spike Cave
	SEP #$20 ; set 8-bit accumulator
	BRA ++
	+
		SEP #$20 ; set 8-bit accumulator
		PHX : TYX
		LDA.l HardModeExclusionCaneOfByrnaUsage, X : STA $00
		PLX
	++
	LDA $7EF36E ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
CalculateCapeUsage:
	LDA $1B : BEQ ++
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #95 : BEQ + ; Ice Palace Spike Room
	CMP.w #179 : BEQ + ; Room in Misery Mire
	CMP.w #213 : BEQ + ; Laser Bridge
	CMP.w #279 : BEQ + ; Spike Cave
	SEP #$20 ; set 8-bit accumulator
	BRA ++
	+
		SEP #$20 ; set 8-bit accumulator
		PHX : TYX
		LDA.l HardModeExclusionCapeUsage, X : STA $4C ; set cape decrement timer
		PLX
	++
	LDA $7EF36E ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
ActivateInvulnerabilityOrDont:
	LDA $1B : BEQ .nowhere_special
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #95 : BEQ .somewhere_cool ; Ice Palace Spike Room
	CMP.w #179 : BEQ .somewhere_cool ; Room in Misery Mire
	CMP.w #213 : BEQ .somewhere_cool ; Laser Bridge
	CMP.w #279 : BEQ .somewhere_cool ; Spike Cave
	
	SEP #$20 ; set 8-bit accumulator
	BRA .nowhere_special
	.somewhere_cool
		SEP #$20 ; set 8-bit accumulator
		LDA.b #$01 : STA $037B : RTL
	.nowhere_special
		LDA.l ByrnaInvulnerability : STA $037B
RTL
;--------------------------------------------------------------------------------
