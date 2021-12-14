;================================================================================
; Four Digit Rupees
;--------------------------------------------------------------------------------
Draw4DigitRupees:
	LDA $1B : AND.w #$00FF : BEQ .outdoors ; skip if outdoors
	.indoors
		LDA $A0 : BNE .normal ; skip except for ganon's room
			LDA TotalItemCounter
			BRA .print
	.outdoors
    .normal
		LDA DisplayRupees
	.print
	    JSL.l HexToDec
		LDA $7F5004 : AND.w #$00FF : ORA.w #$2400 : STA $7EC750
	    LDA $7F5005 : AND.w #$00FF : ORA.w #$2400 : STA $7EC752
	    LDA $7F5006 : AND.w #$00FF : ORA.w #$2400 : STA $7EC754
	    LDA $7F5007 : AND.w #$00FF : ORA.w #$2400 : STA $7EC756
RTL
;================================================================================
