;================================================================================
; Four Digit Rupees
;--------------------------------------------------------------------------------
Draw4DigitRupees:
	LDA $7EF362
    JSL.l HexToDec
    
    ;REP #$30
	LDA $7F5004 : AND.w #$00FF : ORA.w #$2400 : STA $7EC750
    LDA $7F5005 : AND.w #$00FF : ORA.w #$2400 : STA $7EC752
    LDA $7F5006 : AND.w #$00FF : ORA.w #$2400 : STA $7EC754
    LDA $7F5007 : AND.w #$00FF : ORA.w #$2400 : STA $7EC756
	
	;LDA.w #$247F ; clear other hud cells
	;STA $7EC758
	;STA $7EC75E
	;STA $7EC764

	;STA $7EC718 ; bombs
	;STA $7EC71E ; arrows
	;STA $7EC724 ; keys
	
	;LDA.w #$2C88 : STA $7EC71A ; bomb icon
	;LDA.w #$2C89 : STA $7EC71C

    ;LDA $7EF340 : AND.w #$00FF : CMP.w #$0003 : !BGE .silverArrows
	
	;.woodArrows
	;LDA.w #$20A7 : STA $7EC720 ; wood arrow icon
	;LDA.w #$20A9 : STA $7EC722
	;BRA +
	
	;.silverArrows
	;LDA.w #$2486 : STA $7EC720 ; silver arrow icon
	;LDA.w #$2487 : STA $7EC722
	;+
	
	;LDA.w #$2871 : STA $7EC726 ; key icon
RTL
;================================================================================