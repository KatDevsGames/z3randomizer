;================================================================================
; Glitched Mode Fixes
;================================================================================
GetAgahnimType:
	LDA $A0 ; get room id
	CMP.b #13 : BNE + ; Agahnim 2 room
		LDA.b #$0006 ; Use Agahnim 2
		BRA .done
	+ ; Elsewhere
		LDA.b #$0001 ; Use Agahnim 1
	.done
RTL
;--------------------------------------------------------------------------------
GetAgahnimPalette:
	PHX
	LDA $A0 ; get room id
	CMP.b #13 : BNE + ; Agahnim 2 room
		LDA.b #$01 ; Use Agahnim 2
		JML.l GetAgahnimPaletteReturn
	+ ; Elsewhere
		LDA.b #$00 ; Use Agahnim 1
		JML.l GetAgahnimPaletteReturn
;--------------------------------------------------------------------------------
GetAgahnimLightning:
	INC $0E30, X ; thing we wrote over
	LDA $A0 ; get room id
	CMP.b #13 : BNE + ; Agahnim 2 room
		LDA.b #$01 ; Use Agahnim 2
		RTL
	+ ; Elsewhere
		LDA.b #$00 ; Use Agahnim 1
		RTL
;--------------------------------------------------------------------------------