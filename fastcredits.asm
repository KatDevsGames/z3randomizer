FastCreditsActive = $50

;===================================================================================================


FlagFastCredits:
	LDA.b #$40
	TRB.b FastCreditsActive

	AND.b Joy1B_All
	TSB.b FastCreditsActive

	LDA.b #$20
	AND.b Joy1A_New
	EOR.b FastCreditsActive
	STA.b FastCreditsActive

	LDA.b FastCreditsActive
	AND.b #$60
	BEQ .slow

	LDA.b #$01
	TSB.b FastCreditsActive

.slow
	LDA.b $11
	ASL
	TAX

	RTL

;===================================================================================================

FastCreditsCutsceneTimer:
	LDA.b ScrapBufferBD+$0B
	INC

	JSR IsFastCredits
	BCC .slow

	INC
	INC
	INC

	AND.w #$FFFE

.slow
	STA.b ScrapBufferBD+$0B

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
	CMP.l $8EC308,X ; compare to target

	ROL.b Scrap00 ; put carry in here
	LDA.l $8EC348,X ; get movement
	BPL ++ ; if positive, leave saved carry alone
	INC.b Scrap00 ; otherwise, flip it
++	ROR.b Scrap00 ; recover carry

	BCC ++ ; scroll if carry not set

	LDA.w #$0000

++	JSR IsFastCredits
	BCC .slow

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
	ADC.b BG2H
	STA.b BG2H

	RTL


FastCreditsCutsceneUnderworldY:
	JSR FastCreditsCutsceneScrollY
	CLC
	ADC.b BG2V
	STA.b BG2V

	RTL


FastTextScroll:
        LDA.b FrameCounter
        SEP #$10
	JSR IsFastCredits
	BCC .slow

	AND.w #$0000
        REP #$10
	RTL

.slow
	AND.w #$0003
        REP #$10
	RTL

DumbFlagForMSU:
	STA.l CurrentWorld
	STZ.b FastCreditsActive
	RTL

IsFastCredits:
	LDY.b FastCreditsActive
        CPY.b #$20
	RTS

