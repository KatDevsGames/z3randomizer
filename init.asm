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
	
	LDX #$00
	-
		LDA RomNameSRAM, X : CMP $00FFC0, X : BNE .clear
		INX
		CPX #$15 : !BLT -
	BRA .done
	.clear
		REP #$30 ; set 16-bit accumulator & index registers
		LDA.w #$0000
		-
			STA $700000, X
			INX
			CPX #$2000 : !BLT -
		SEP #$30 ; set 8-bit accumulator & index registers
		LDX #$00
		-
			LDA $00FFC0, X : STA RomNameSRAM, X
			INX
			CPX #$15 : !BLT -
                LDX #$00
                -
                        LDA RomVersion, X : STA RomVersionSRAM, X
                        INX
                        CPX #$04 : !BLT -
	.done

	REP #$20
	LDA.l OneMindTimer : STA.l !ONEMIND_TIMER
	SEP #$20

	LDA.b #$01 : STA $420D ; enable fastrom access on upper banks
	STA.l !ONEMIND_ID
	
	LDA.b #$10 : STA $BC ; set default player sprite bank
	
	LDA.b #$81 : STA $4200 ; thing we wrote over, turn on NMI & gamepad
RTL
;--------------------------------------------------------------------------------
; Init_PostRAMClear
;--------------------------------------------------------------------------------
; This gets called after banks $7E and $7F get cleared, so if we need to
; initialize RAM in those banks, do it here
;--------------------------------------------------------------------------------
Init_PostRAMClear:

	JSL MSUInit
	JSL InitRNGPointerTable
        JSL InitCompassTotalsRAM

JML $00D463	; The original target of the jump table that we hijacked
