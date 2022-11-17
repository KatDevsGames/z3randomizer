;================================================================================
; Fake Flippers Softlock Fix
;--------------------------------------------------------------------------------

UnequipCapeQuiet: 
    LDA.b #$20 : STA.w $02E2
    STZ.w $037B
    STZ.b $55
    STZ.w $0360
RTL

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
