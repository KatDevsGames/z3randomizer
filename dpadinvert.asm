;================================================================================
; D-Pad Invert
; runs in NMI, must use minimum possible # of cycles
;--------------------------------------------------------------------------------
; Filtered Joypad 1 Register: [AXLR | ????]
; Filtered Joypad 1 Register: [BYST | udlr] [AXLR | ????]
!INVERT_DPAD = "$7F50CB"
InvertDPad:
	LDA !INVERT_DPAD : BNE + : BRL .normal : +
	DEC : BEQ .dpadOnly
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
	.normal
	LDA $4218 : STA $00
	LDA $4219 : STA $01
JML.l InvertDPadReturn
;--------------------------------------------------------------------------------