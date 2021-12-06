;================================================================================
; Glitched Mode Fixes
;================================================================================
GetAgahnimPalette:
	LDA $A0 ; get room id
	CMP.b #13 : BNE + ; Agahnim 2 room
		LDA.b #$07 ; Use Agahnim 2
		RTL
	+ ; Elsewhere
		LDA.b #$0b ; Use Agahnim 1
		RTL
;--------------------------------------------------------------------------------
GetAgahnimDeath:
	STA $0BA0, X ; thing we wrote over
	LDA $A0 ; get room id
	CMP.b #13 : BNE + ; Agahnim 2 room
		LDA.l Bugfix_SetWorldOnAgahnimDeath : BEQ ++
			LDA.l InvertedMode : BEQ +++
				LDA.b #$00 : STA CurrentWorld ; Switch to light world
				BRA ++
			+++
			LDA.b #$40 : STA CurrentWorld ; Switch to dark world
		++
		LDA.b #$01 ; Use Agahnim 2
		RTL
	+ ; Elsewhere
		LDA.l Bugfix_SetWorldOnAgahnimDeath : BEQ ++
			LDA.l InvertedMode : BEQ +++
				LDA.b #$40 : STA CurrentWorld ; Switch to dark world
				BRA ++
			+++
			LDA.b #$00 : STA CurrentWorld ; Switch to light world
			; (This will later get flipped to DW when Agahnim 1
			; warps us to the pyramid)
		++
		LDA.b #$00 ; Use Agahnim 1
		RTL
;--------------------------------------------------------------------------------
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
GetAgahnimSlot:
	PHX ; thing we wrote over
	LDA $A0 ; get room id
	CMP.b #13 : BNE + ; Agahnim 2 room
		LDA.b #$01 ; Use Agahnim 2
		JML.l GetAgahnimSlotReturn
	+ ; Elsewhere
		LDA.b #$00 ; Use Agahnim 1
		JML.l GetAgahnimSlotReturn
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
;0 = Allow
;1 = Forbid
AllowJoypadInput:
	LDA PermitSQFromBosses : BEQ .fullCheck
	LDA $0403 : AND.b #$80 : BEQ .fullCheck
		LDA $0112 : ORA $02E4 ; we have heart container, do short check
RTL
	.fullCheck
	LDA $0112 : ORA $02E4 : ORA $0FFC
RTL
;--------------------------------------------------------------------------------
