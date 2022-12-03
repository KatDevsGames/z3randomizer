;--------------------------------------------------------------------------------
; Init_Primary
;--------------------------------------------------------------------------------
; This can be as inefficient as we want. Interrupts are off when this gets
; called and it only gets called once ever during RESET.
;--------------------------------------------------------------------------------
Init_Primary:
	LDA.b #$00
	
	LDX.b #$00 ; initalize our ram
	-
		STA.l $7EC025, X
		STA.l $7F5000, X
		INX
		CPX.b #$10 : !BLT -

	LDX.b #$10 ; initalize more ram
	-
		STA.l $7F5000, X
		INX
		CPX.b #$FF : !BLT -
	
	LDX.b #$00
	-
		LDA.l RomNameSRAM, X : CMP.w $FFC0, X : BNE .clear
		INX
		CPX.b #$15 : !BLT -
	BRA .done
	.clear
		REP #$30 ; set 16-bit accumulator & index registers
		LDA.w #$0000
		-
			STA.l $700000, X
			INX
			CPX.w #$2000 : !BLT -
		SEP #$30 ; set 8-bit accumulator & index registers
		LDX.b #$00
		-
			LDA.w $FFC0, X : STA.l RomNameSRAM, X
			INX
			CPX #$15 : !BLT -
                LDX.b #$00
                -
                        LDA.w RomVersion, X : STA.l RomVersionSRAM, X
                        INX
                        CPX.b #$04 : !BLT -
	.done

	REP #$20
	LDA.l OneMindTimerInit : STA.l OneMindTimerRAM
	SEP #$20

	LDA.b #$01 : STA.w MEMSEL ; enable fastrom access on upper banks
	STA.l OneMindId
	
	LDA.b #$10 : STA.b PlayerSpriteBank ; set default player sprite bank
	
	LDA.b #$81 : STA.w NMITIMEN ; thing we wrote over, turn on NMI & gamepad
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
	JSL DecompressAllItemGraphics


JML $00D463	; The original target of the jump table that we hijacked
