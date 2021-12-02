; Thanks to Kazuto for developing the original QS code that inspired this one

QuickSwap:
	; We perform all other checks only if we are pushing L or R in order to have minimal
	; perf impact, since this runs every frame

	LDA.b $F6 : AND #$30 : BEQ .done

	XBA ; stash away the value for after the checks.

	LDA.l QuickSwapFlag : BEQ .done
	LDA.w $0202 : BEQ .done ; Skip everything if we don't have any items

	PHX
	XBA ; restore the stashed value
	CMP.b #$30 : BNE +
		; If prossing both L and R this frame, then go directly to the special swap code
		LDX.w $0202 : BRA .special_swap
	+
	BIT #$10 : BEQ + ; Only pressed R
		JSR.w RCode
		LDA.b $F2 : BIT #$20 : BNE .special_swap ; Still holding L from a previous frame
		BRA .store
	+
	; Only pressed L
	JSR.w LCode
	LDA.b $F2 : BIT #$10 : BNE .special_swap ; Still holding R from a previous frame
	BRA .store

	.special_swap
	LDA InventoryTracking+1 : ORA #$01 : STA InventoryTracking+1
	CPX.b #$02 : BEQ + ; boomerang
	CPX.b #$01 : BEQ + ; bow
	CPX.b #$05 : BEQ + ; powder
	CPX.b #$0D : BEQ + ; flute
	CPX.b #$10 : BEQ + ; bottle
	BRA .store
	+ STX $0202 : JSL ProcessMenuButtons_y_pressed

	.store
	LDA.b #$20 : STA.w $012F
	STX $0202

	JSL HUD_RefreshIconLong
	PLX

	.done
	LDA.b $F6 : AND.b #$40 ;what we wrote over
RTL
RCode:
	LDX.w $0202
	LDA.b $F2 : BIT #$20 : BNE ++ ; Still holding L from a previous frame
		LDA InventoryTracking+1 : AND #$FE : STA InventoryTracking+1
		BRA +
	++
	LDA InventoryTracking+1 : BIT #$01 : BEQ +
	RTS
	-
		+ CPX.b #$14 : BNE + : LDX.b #$00 ;will wrap around to 1
		+ INX
	.nextItem
	JSL.l IsItemAvailable : BEQ -
RTS

LCode:
	LDX.w $0202
	LDA.b $F2 : BIT #$10 : BNE ++ ; Still holding R from a previous frame
		LDA InventoryTracking+1 : AND #$FE : STA InventoryTracking+1
		BRA +
	++
	LDA InventoryTracking+1 : BIT #$01 : BEQ +
	RTS
	-
		+ CPX.b #$01 : BNE + : LDX.b #$15 ; will wrap around to $14
		+ DEX
	.nextItem
	JSL.l IsItemAvailable : BEQ -
RTS
