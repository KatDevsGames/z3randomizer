;================================================================================
; D-Pad Invert
; runs in NMI, must use minimum possible # of cycles
;--------------------------------------------------------------------------------
; Filtered Joypad 1 Register: [AXLR | ????]
; Filtered Joypad 1 Register: [BYST | udlr] [AXLR | ????]
!INVERT_DPAD = "$7F50CB"

InvertDPad:
	LDA.l OneMindPlayerCount : BEQ .crowd_control

	LDA.l !ONEMIND_ID
	AND.b #$03
	TAX
	LDA.l .onemind_controller_offset, X
	TAX

	LDA.w $4218,X : STA.w $00
	LDA.w $4219,X : STA.w $01

	LDA #$80 : STA $4201 ; reset this so latch can read it, otherwise RNG breaks

	JML.l InvertDPadReturn

.crowd_control
	LDA !INVERT_DPAD : BNE +

	LDA $4218 : STA $00
	LDA $4219 : STA $01
	JML.l InvertDPadReturn

+	DEC : BEQ .dpadOnly
	DEC : BEQ .buttonsOnly
	DEC : BEQ .invertBoth
	.swapSides
	REP #$20 ; set 16-bit accumulator
	LDA $4218
		BIT.w #$0840 : BEQ + : EOR.w #$0840 : + ; swap X/up
		BIT.w #$0180 : BEQ + : EOR.w #$0180 : + ; swap A/right
		BIT.w #$4200 : BEQ + : EOR.w #$4200 : + ; swap Y/left
		BIT.w #$8400 : BEQ + : EOR.w #$8400 : + ; swap B/down
	STA $00
	SEP #$20 ; set 8-bit accumulator
JML.l InvertDPadReturn
	.invertBoth
	REP #$20 ; set 16-bit accumulator
	LDA $4218
		BIT.w #$8040 : BEQ + : EOR.w #$8040 : + ; swap X/B
		BIT.w #$4080 : BEQ + : EOR.w #$4080 : + ; swap Y/A
		BIT.w #$0C00 : BEQ + : EOR.w #$0C00 : + ; swap up/down
		BIT.w #$0300 : BEQ + : EOR.w #$0300 : + ; swap left/right
	STA $00
	SEP #$20 ; set 8-bit accumulator
JML.l InvertDPadReturn
	.buttonsOnly
	REP #$20 ; set 16-bit accumulator
	LDA $4218
		BIT.w #$8040 : BEQ + : EOR.w #$8040 : + ; swap X/B
		BIT.w #$4080 : BEQ + : EOR.w #$4080 : + ; swap Y/A
	STA $00
	SEP #$20 ; set 8-bit accumulator
JML.l InvertDPadReturn
	.dpadOnly
	LDA $4218 : STA $00
	LDA $4219 
		BIT.b #$0C : BEQ + : EOR.b #$0C : + ; swap up/down
		BIT.b #$03 : BEQ + : EOR.b #$03 : + ; swap left/right
	STA $01
JML.l InvertDPadReturn

.onemind_controller_offset
	db 0 ; player 0 - $4218 - joy1d1
	db 0 ; player 1 - $4218 - joy1d1
	db 2 ; player 2 - $421A - joy2d1
	db 6 ; player 3 - $421E - joy2d2
	db 2 ; player 4 - $421A - joy2d1
	db 6 ; player 5 - $421E - joy2d2



;--------------------------------------------------------------------------------

HandleOneMindController:
	LDA.l OneMindPlayerCount
	BEQ .no_onemind

	REP #$20

	LDA.l !ONEMIND_TIMER
	DEC
	BPL .no_switch

	SEP #$20
	LDA.l !ONEMIND_ID
	INC
	CMP.l OneMindPlayerCount
	BCC .no_wrap

	LDA.b #$01 ; reset to player 1

.no_wrap
	STA.l !ONEMIND_ID

	REP #$20
	LDA.l OneMindTimer

.no_switch
	STA.l !ONEMIND_TIMER

	SEP #$20
	LDA.l !ONEMIND_ID

	CMP.b #$04 ; is it player 4 or 5?
	BCC .no_multitap_switch

	STZ.w $4201

.no_multitap_switch

.no_onemind
	STZ.b $12

	JML $008034 ; reset frame loop




