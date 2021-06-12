;===================================================================================================

FastCreditsCutsceneTimer:
	BIT.b $F2-1 : BVC .slow

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

FastCreditsCutsceneOverworld:
	BIT.b $F2 : BVC .slow

	LDA.b $30
	JSR .quad
	STA.b $30

	LDA.b $31
	JSR .quad
	STA.b $31

.slow
	JML $0285B5

.quad
	BPL .fine

	EOR.b #$FF
	INC
	ASL
	ASL
	EOR.b #$FF
	INC
	RTS


.fine
	ASL
	ASL

	RTS


FastTextScroll:
	LDA.b $1A
	BIT.b $F2-1 : BVC .slow

	AND.w #$0000
	RTL

.slow
	AND.w #$0003
	RTL
