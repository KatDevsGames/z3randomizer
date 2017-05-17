;--------------------------------------------------------------------------------
; Init_Primary
;--------------------------------------------------------------------------------
; This can be as inefficient as we want. Interrupts are off when this gets
; called and it only gets called once ever during RESET.
;--------------------------------------------------------------------------------
Init_Primary:
	LDA #$00
	
	LDX #$00 ; initalize our ram
	-
		STA $7EC025, X
		STA $7F5000, X
		INX
		CPX #$10 : !BLT -

	LDX #$10 ; initalize more ram
	-
		STA $7F5000, X
		INX
		CPX #$FF : !BLT -
	
	LDA.b #$01 : STA $420D ; enable fastrom access on upper banks
	
	LDA.b #$81 : STA $4200 ; thing we wrote over, turn on NMI & gamepad
RTL
;--------------------------------------------------------------------------------