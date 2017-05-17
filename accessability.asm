;================================================================================
; Accessability Fixes
;================================================================================
FlipGreenPendant:
	LDA $0C : CMP #$38 : BNE + ; check if we have green pendant
		ORA #$40 : STA $0C ; flip it
	+
	
    LDA $0D : STA $0802, X ; stuff we wrote over "Set CHR, palette, and priority of the sprite"
    LDA $0C : STA $0803, X
RTL
;================================================================================