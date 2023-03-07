;--------------------------------------------------------------------------------
; Init_Primary
;--------------------------------------------------------------------------------
; This can be as inefficient as we want. Interrupts are off when this gets
; called and it only gets called once ever during RESET.
;--------------------------------------------------------------------------------
Init_Primary:
	LDA.b #$00
	LDX.b #$14
	-
		LDA.l RomNameSRAM, X : CMP.w $FFC0, X : BNE .clear
		DEX
	BPL -
        REP #$30
	LDX.w #$00D9 ; initalize our ram
	-
		STA.l $7EC025, X
		DEX #2
	BPL -
        LDA.w #$0000
        LDX.w #$2FFE
        -
                STA.l $7F5000, X
                DEX #2
        BPL -

	BRA .done
	.clear
		REP #$30
		LDA.w #$0000
                LDX.w #$1FFE
		-
			STA.l CartridgeSRAM, X
			STA.l SaveBackupSRAM, X
			DEX #2
		BPL -
                LDA.w RomVersion+$00 : STA.l RomVersionSRAM+$00
                LDA.w RomVersion+$02 : STA.l RomVersionSRAM+$02
		SEP #$30
		LDX.b #$14
		-
			LDA.w $FFC0, X : STA.l RomNameSRAM, X
			DEX
		BPL -
	.done

	REP #$20
	LDA.l OneMindTimerInit : STA.l OneMindTimerRAM
	SEP #$30

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
        JSL InitDungeonCounts

JML $00D463	; The original target of the jump table that we hijacked
