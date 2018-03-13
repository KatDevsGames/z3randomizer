;================================================================================
; D-Pad Invert
; runs in NMI, must use minimum possible # of cycles
;--------------------------------------------------------------------------------
; Filtered Joypad 1 Register: [BYST | udlr].
!INVERT_DPAD = "$7F50CB"
InvertDPad:
	LDA !INVERT_DPAD : BEQ .normal
	.inverted
	LDA $4219 
		BIT.b #$0C : BEQ + : EOR #$0C : +
		BIT.b #$03 : BEQ + : EOR #$03 : +
	STA $01
RTL
	.normal
	LDA $4219 : STA $01
RTL
;--------------------------------------------------------------------------------