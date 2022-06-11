;--------------------------------------------------------------------------------
; $7F5010 - Scratch Space
;--------------------------------------------------------------------------------

DrawDungeonCompassCounts:
	LDX $1B : BNE + : RTL : + ; Skip if outdoors

	; extra hard safeties for getting dungeon ID to prevent crashes
	PHA
	LDA.w $040C : AND.w #$00FE : TAX ; force dungeon ID to be multiple of 2
	PLA

	CPX.b #$1B : BCS .done ; Skip if not in a valid dungeon ID

	BIT.w #$0002 : BNE ++ ; if CompassMode==2, we don't check for the compass
		LDA CompassField : AND.l DungeonItemMasks, X ; Load compass values to A, mask with dungeon item masks
		BEQ .done ; skip if we don't have compass
	++
	
        TXA : LSR : TAX
        BNE +
                INC
        +
        LDA.l CompassTotalsWRAM, X : AND #$00FF
        SEP #$20
	JSR HudHexToDec2Digit
	REP #$20
        PHX
		LDX.b $06 : TXA : ORA #$2400 : STA $7EC79A
		LDX.b $07 : TXA : ORA #$2400 : STA $7EC79C
	PLX

        LDA DungeonLocationsChecked, X : AND #$00FF
	SEP #$20
	JSR HudHexToDec2Digit
	REP #$20
	LDX.b $06 : TXA : ORA #$2400 : STA $7EC794 ; Draw the item count
	LDX.b $07 : TXA : ORA #$2400 : STA $7EC796
	
	LDA.w #$2830 : STA $7EC798 ; draw the slash

	.done
RTL

DungeonItemMasks: ; these are dungeon correlations to $7EF364 - $7EF369 so it knows where to store compasses, etc
    dw $8000, $4000, $2000, $1000, $0800, $0400, $0200, $0100
    dw $0080, $0040, $0020, $0010, $0008, $0004
;--------------------------------------------------------------------------------
InitCompassTotalsRAM:
        LDX #$00
        -
                LDA CompassTotalsROM, X : STA CompassTotalsWRAM, X
                INX
                CPX #$0F : !BLT -
RTL

