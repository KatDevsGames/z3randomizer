;================================================================================
; Hard & Masochist Mode
;================================================================================
CalculateSpikeFloorDamage:
		REP #$20 ; set 16-bit accumulator
		LDA.b RoomIndex ; these are all decimal because i got them that way
		CMP.w #279
		SEP #$20 ; set 8-bit accumulator
		BNE +
			LDA.l ByrnaCaveSpikeDamage
			STA.w DamageReceived
			RTL
		+
	LDA.w $D055, Y
	STA.w DamageReceived
RTL
;--------------------------------------------------------------------------------
CalculateByrnaUsage:
	LDA.b IndoorsFlag : BEQ ++
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
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
		LDA.l HardModeExclusionCaneOfByrnaUsage, X : STA.b Scrap00
		PLX
	++
	LDA.l CurrentMagic ; thing we wrote over
	JML IncrementMagicUseCounterByrna
;--------------------------------------------------------------------------------
CalculateCapeUsage:
	LDA.b IndoorsFlag : BEQ ++
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #95 : BEQ + ; Ice Palace Spike Room
	CMP.w #179 : BEQ + ; Room in Misery Mire
	CMP.w #213 : BEQ + ; Laser Bridge
	CMP.w #279 : BEQ + ; Spike Cave
	SEP #$20 ; set 8-bit accumulator
	BRA ++
	+
		SEP #$20 ; set 8-bit accumulator
		PHX : TYX
		LDA.l HardModeExclusionCapeUsage, X : STA.b CapeTimer ; set cape decrement timer
		PLX
	++
	JML IncrementMagicUseCounterOne
;--------------------------------------------------------------------------------
ActivateInvulnerabilityOrDont:
	LDA.b IndoorsFlag : BEQ .nowhere_special
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #95 : BEQ .somewhere_cool ; Ice Palace Spike Room
	CMP.w #179 : BEQ .somewhere_cool ; Room in Misery Mire
	CMP.w #213 : BEQ .somewhere_cool ; Laser Bridge
	CMP.w #279 : BEQ .somewhere_cool ; Spike Cave

	SEP #$20 ; set 8-bit accumulator
	BRA .nowhere_special
	.somewhere_cool
		SEP #$20 ; set 8-bit accumulator
		LDA.b #$01 : STA.w NoDamage : RTL
	.nowhere_special
		LDA.l ByrnaInvulnerability : STA.w NoDamage
RTL
;--------------------------------------------------------------------------------
GetItemDamageValue:
	CPX.b #$03 : BEQ .boomerang
	CPX.b #$04 : BEQ .boomerang
	CPX.b #$05 : BEQ .boomerang
	CPX.b #$39 : BEQ .hookshot
	CPX.b #$3b : BEQ .hookshot
	CPX.b #$3c : BEQ .hookshot
	CPX.b #$3d : BEQ .hookshot

	.normal
	LDA.l $8DB8F1,x ;what we wrote over
RTL
	.boomerang
		LDA.l StunItemAction : AND.b #$01 : BNE .normal
		BRA .noDamage
	.hookshot
		LDA.l StunItemAction : AND.b #$02 : BNE .normal
	.noDamage
	LDA.b #$00
RTL
;--------------------------------------------------------------------------------
;Argument : A = id we want to find return 00 if none found, 01 if found
SearchAncilla:
{
	STA.b Scrap05
	PHX 
	LDX.b #$00
	.loop
	LDA.w AncillaID, X 
	INX : CPX #$0A : BEQ .notFound
	CMP.b Scrap05 : BNE .loop
		LDA.b #$01
		BRA .return
	.notFound
		LDA.b #$00
	.return
	PLX 
	RTS
}
