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
!EPILEPSY_TIMER = "$7F5041"
SetEtherFlicker:
	LDA.l Seizure_Safety : BNE +
		LDA $031D : CMP.b #$0B : RTL
	+
		LDA !EPILEPSY_TIMER : INC : STA !EPILEPSY_TIMER
		
		LDA.l Seizure_Safety : CMP !EPILEPSY_TIMER : BNE +++
			LDA.b #$00 : STA !EPILEPSY_TIMER : BRA ++
		+++
			LSR : CMP !EPILEPSY_TIMER : !BLT ++
				SEP #$02 : RTL
		++
		REP #$02
	+
RTL
;================================================================================
SetAttractMaidenFlicker:
	LDA.l Seizure_Safety : BNE +
		JSL.l Filter_MajorWhitenMain : LDA $5F : RTL
	+
		LDA #$00
RTL
;================================================================================