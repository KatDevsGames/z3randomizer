;================================================================================
; Fake Flippers Softlock Fix
;--------------------------------------------------------------------------------
FlipperKill:
	PHP
	LDA.b $5D : CMP.b #$04 : BNE .done ; skip if we're not swimming
	LDA.l FlippersEquipment : BNE .done ; skip if we have the flippers
	LDA.l $7F5001 : BEQ .done ; skip if we're not marked in danger for softlock
	LDA.b $8A : CMP.l $7F5098 : BEQ .done ; skip if we're on the same screen we entered the water on
	LDA.l IgnoreFaeries : ORA.b #$04 : STA.l IgnoreFaeries
	LDA.b #$00 : STA CurrentHealth ; kill link
	LDA.b #$00 : STA $7F5001 ; mark fake flipper softlock as impossible
	.done
	PLP
	LDA.l CurrentHealth ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
IgnoreFairyCheck:
    LDX.b #$00 ; thing we wrote over
    LDA.l IgnoreFaeries : BIT.b #$04 : BEQ .normal
	
    AND.b #$FB : STA.l IgnoreFaeries ; clear ignore fairy flag
	LDA.b #$F0 ; set check to invalid entry
RTL
	.normal
    LDA.b #$06 ; set check to fairy
RTL
;--------------------------------------------------------------------------------
FlipperReset:
	JSL $0998E8 ; AddTransitionSplash
	LDA.b #$00 : STA.l $7F5001 ; mark fake flipper softlock as impossible
	.done 
RTL
;--------------------------------------------------------------------------------
FlipperFlag:
	LDA.b $5D : CMP.b #$04 : BNE .done ; skip if we're not swimming
	LDA.l FlippersEquipment : BNE .safe ; skip if we have the flippers
	LDA.b #$01 : STA.l $7F5001 ; mark fake flipper softlock as possible
	BRA .done
	.safe
	LDA.b #$00 : STA.l $7F5001 ; mark fake flipper softlock as impossible
	.done 
RTL
;--------------------------------------------------------------------------------
RegisterWaterEntryScreen:
	PHA
		LDA.b $8A : STA.l $7F5098 ; store ow index
	PLA
RTL
;--------------------------------------------------------------------------------
MysteryWaterFunction: ; *$3AE54 ALTERNATE ENTRY POINT
    LDA.b #$20 : STA $02E2
    STZ.w $037B
    STZ.b $55
    STZ.w $0360
RTL
;--------------------------------------------------------------------------------


;===================================================================================================
; More elegant solution
;===================================================================================================

protectff:
	LDA.l AllowAccidentalMajorGlitch
	BEQ .yes_protect

	RTL

.yes_protect
	REP #$30

	LDA.b $20
	AND.w #$1E00
	ASL
	ASL
	ASL
	STA.b Scrap06

	LDA.b $22
	AND.w #$1E00
	ORA.b Scrap06

	XBA
	LSR
	TAX

	SEP #$30

	; Remove dark world bit
	; in game table that converts coordinates to actual screen ID
	; special case for other areas
	LDA.b $8A
	BMI .special_overworld

	AND.b #$3F
	CMP.l $02A4E3,X
	BEQ ++

.protect
	LDA.b #$15
	STA.b $5D

	STZ.b $2E
	STZ.b $67

	LDA.b #$02
	STA.b $2F

	STZ.w $0112
	STZ.w $02E4
	STZ.w $0FFC

++	RTL

.special_overworld
	CMP.l .spow,X
	BNE .protect

	RTL

.spow
	db $80, $81, $81, $FF, $FF, $FF, $FF, $FF
	db $FF, $81, $81, $FF, $FF, $FF, $FF, $FF
