;===================================================================================================

FastCreditsCutsceneTimer:
	BIT.b $F2-1 : BVC .slow

	LDA.w #$0001 : STA.b $50

	LDA.b $C8
	CLC
	ADC.w #$0004
	AND.w #$FFFE
	STA.b $C8
	SEP #$20
	RTL
	

.slow
	INC.b $C8

	SEP #$20
	RTL

FastCreditsScrollOW:
	JSR FastCreditsCutsceneScrollY
	TAY
	STY.b $30

	JSR FastCreditsCutsceneScrollX
	TAY
	STY.b $31

	RTL

FastCreditsCutsceneScrollX:
	PHX
	TXA
	CLC
	ADC.w #$0020
	TAX

	LDY.b #$00
	JSR FastCreditsCutsceneScroll

	PLX
	RTS

FastCreditsCutsceneScrollY:
	LDY.b #$06

FastCreditsCutsceneScroll:
	LDA.w $00E2,Y
	CMP.l $0EC308,X ; compare to target

	ROL.b $00 ; put carry in here
	LDA.l $0EC348,X ; get movement
	BPL ++ ; if positive, leave saved carry alone
	INC.b $00 ; otherwise, flip it
++	ROR.b $00 ; recover carry

	BCC ++ ; scroll if carry not set
	LDA.w #$0000

++	BIT.b $F2-1 : BVC .slow ; check for X held

	AND.w #$FFFF ; get sign of A
	BPL .positive

	EOR.w #$FFFF
	INC
	ASL
	ASL
	EOR.w #$FFFF
	INC
	RTS

.positive
	ASL
	ASL



.slow
	RTS






FastCreditsCutsceneUnderworldX:
	JSR FastCreditsCutsceneScrollX
	CLC
	ADC.b $E2
	STA.b $E2

	RTL


FastCreditsCutsceneUnderworldY:
	JSR FastCreditsCutsceneScrollY
	CLC
	ADC.b $E8
	STA.b $E8

	RTL


FastTextScroll:
	LDA.b $1A
	BIT.b $F2-1 : BVC .slow

	AND.w #$0000
	RTL

.slow
	AND.w #$0003
	RTL

DumbFlagForMSU:
	STA.l CurrentWorld
	STZ.b $50
	RTL


