;================================================================================
; D-Pad Invert
; runs in NMI, must use minimum possible # of cycles
;--------------------------------------------------------------------------------
; Filtered Joypad 1 Register: [AXLR | ????]
; Filtered Joypad 1 Register: [BYST | udlr] [AXLR | ????]

InvertDPad:
	LDA.l OneMindPlayerCount : BEQ .crowd_control

	LDA.l OneMindId
	AND.b #$03
	TAX
	LDA.l .onemind_controller_offset, X
	TAX

	LDA.w JOY1L,X : STA.w Scrap00
	LDA.w JOY1H,X : STA.w Scrap01

	LDA.b #$80 : STA.w WRIO ; reset this so latch can read it, otherwise RNG breaks

	JML.l InvertDPadReturn

.crowd_control
	LDA.l ControllerInverter : BNE +

	LDA.w JOY1L : STA.b Scrap00
	LDA.w JOY1H : STA.b Scrap01
	JML.l InvertDPadReturn

+	DEC : BEQ .dpadOnly
	DEC : BEQ .buttonsOnly
	DEC : BEQ .invertBoth
	.swapSides
	REP #$20 ; set 16-bit accumulator
	LDA.w JOY1L
		BIT.w #$0840 : BEQ + : EOR.w #$0840 : + ; swap X/up
		BIT.w #$0180 : BEQ + : EOR.w #$0180 : + ; swap A/right
		BIT.w #$4200 : BEQ + : EOR.w #$4200 : + ; swap Y/left
		BIT.w #$8400 : BEQ + : EOR.w #$8400 : + ; swap B/down
	STA.b Scrap00
	SEP #$20 ; set 8-bit accumulator
JML.l InvertDPadReturn
	.invertBoth
	REP #$20 ; set 16-bit accumulator
	LDA.w JOY1L
		BIT.w #$8040 : BEQ + : EOR.w #$8040 : + ; swap X/B
		BIT.w #$4080 : BEQ + : EOR.w #$4080 : + ; swap Y/A
		BIT.w #$0C00 : BEQ + : EOR.w #$0C00 : + ; swap up/down
		BIT.w #$0300 : BEQ + : EOR.w #$0300 : + ; swap left/right
	STA.b Scrap00
	SEP #$20 ; set 8-bit accumulator
JML.l InvertDPadReturn
	.buttonsOnly
	REP #$20 ; set 16-bit accumulator
	LDA.w JOY1L
		BIT.w #$8040 : BEQ + : EOR.w #$8040 : + ; swap X/B
		BIT.w #$4080 : BEQ + : EOR.w #$4080 : + ; swap Y/A
	STA.b Scrap00
	SEP #$20 ; set 8-bit accumulator
JML.l InvertDPadReturn
	.dpadOnly
	LDA.w JOY1L : STA.b Scrap00
	LDA.w JOY1H 
		BIT.b #$0C : BEQ + : EOR.b #$0C : + ; swap up/down
		BIT.b #$03 : BEQ + : EOR.b #$03 : + ; swap left/right
	STA.b Scrap01
JML.l InvertDPadReturn

.onemind_controller_offset
	db 0 ; player 0 - JOY1L - joy1d1
	db 0 ; player 1 - JOY1L - joy1d1
	db 2 ; player 2 - JOY2L - joy2d1
	db 6 ; player 3 - JOY4L - joy2d2
	db 2 ; player 4 - JOY2L - joy2d1
	db 6 ; player 5 - JOY4L - joy2d2



;--------------------------------------------------------------------------------

HandleOneMindController:
	LDA.l OneMindPlayerCount
	BEQ .no_onemind

	REP #$20

	LDA.l OneMindTimerRAM
	DEC
	BPL .no_switch

	SEP #$20
	LDA.l OneMindId
	INC
	CMP.l OneMindPlayerCount
	BCC .no_wrap

	LDA.b #$01 ; reset to player 1

.no_wrap
	STA.l OneMindId

	REP #$20
	LDA.l OneMindTimerInit

.no_switch
	STA.l OneMindTimerRAM

	SEP #$20
	LDA.l OneMindId

	CMP.b #$04 ; is it player 4 or 5?
	BCC .no_multitap_switch

	STZ.w WRIO

.no_multitap_switch

.no_onemind
	STZ.b NMIDoneFlag

	JML $808034 ; reset frame loop

