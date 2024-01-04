; Thanks to Kazuto for developing the original QS code that inspired this one

QuickSwap:
	; We perform all other checks only if we are pushing L or R in order to have minimal
	; perf impact, since this runs every frame

	LDA.b Joy1B_New : AND.b #$30 : BEQ .done

	XBA ; stash away the value for after the checks.

	LDA.l QuickSwapFlag : BEQ .done
	LDA.w ItemCursor : BEQ .done ; Skip everything if we don't have any items
	LDA.b #$01 : STA.l UpdateHUDFlag
	LDY.b #$14
	PHX
	XBA ; restore the stashed value
	CMP.b #$30 : BNE +
		; If prossing both L and R this frame, then go directly to the special swap code
		LDX.w ItemCursor : BRA .special_swap
	+
	BIT.b #$10 : BEQ + ; Only pressed R
		JSR.w RCode
		LDA.b Joy1B_All : BIT.b #$20 : BNE .special_swap ; Still holding L from a previous frame
		BRA .store
	+
	; Only pressed L
	JSR.w LCode
	LDA.b Joy1B_All : BIT #$10 : BNE .special_swap ; Still holding R from a previous frame
	BRA .store

	.special_swap
	LDA.l InventoryTracking+1 : ORA.b #$01 : STA.l InventoryTracking+1
	CPX.b #$02 : BEQ + ; boomerang
	CPX.b #$01 : BEQ + ; bow
	CPX.b #$05 : BEQ + ; powder
	CPX.b #$0D : BEQ + ; flute
	CPX.b #$10 : BEQ + ; bottle
	BRA .store
	+ STX.w ItemCursor : JSL ProcessMenuButtons_y_pressed

	.store
	LDA.b #$20 : STA.w SFX3
	STX.w ItemCursor

	JSL HUD_RefreshIconLong
	PLX

	.done
	LDA.b Joy1B_New : AND.b #$40 ;what we wrote over
RTL
RCode:
	LDX.w ItemCursor
	LDA.b Joy1B_All : BIT.b #$20 : BNE ++ ; Still holding L from a previous frame
		LDA.l InventoryTracking+1 : AND.b #$FE : STA.l InventoryTracking+1
		BRA +
	++
	LDA.l InventoryTracking+1 : BIT.b #$01 : BEQ +
	RTS
	-
		+ CPX.b #$14 : BNE + : LDX.b #$00 ;will wrap around to 1
		+ INX
                DEY : BEQ +
	.nextItem
	JSL.l IsItemAvailable : BEQ -
        +
RTS

LCode:
	LDX.w ItemCursor
	LDA.b Joy1B_All : BIT #$10 : BNE ++ ; Still holding R from a previous frame
		LDA.l InventoryTracking+1 : AND.b #$FE : STA.l InventoryTracking+1
		BRA +
	++
	LDA.l InventoryTracking+1 : BIT.b #$01 : BEQ +
	RTS
	-
		+ CPX.b #$01 : BNE + : LDX.b #$15 ; will wrap around to $14
		+ DEX
                DEY : BEQ +
	.nextItem
	JSL.l IsItemAvailable : BEQ -
        +
RTS

IsItemAvailable:
        LDA.l InfiniteBombs : BEQ .finite
        .infinite
                CPX.b #$04 : BNE .finite
                LDA.b #$01 : RTL
        .finite
                LDA.l EquipmentWRAM-1, X
RTL
