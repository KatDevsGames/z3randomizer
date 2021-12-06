;--------------------------------------------------------------------------------
; $7F5010 - Scratch Space
;--------------------------------------------------------------------------------
; The number of items in a dungeon never changes. use this macro instead of
; HexToDec when drawing the "??/XX" item counter
; %DrawConstantNumber(1,4) draws 14
;--------------------------------------------------------------------------------
macro DrawConstantNumber(digit1,digit2) 
	LDA.w #$2490+<digit1> : STA $7EC79A
	LDA.w #$2490+<digit2> : STA $7EC79C
	SEP #$20
endmacro
;--------------------------------------------------------------------------------

DrawDungeonCompassCounts:
	LDX $1B : BNE + : RTL : + ; Skip if outdoors
	LDX $040C : CPX.b #$FF : BEQ .done ; Skip if not in a dungeon

	CMP.w #$0002 : BEQ ++ ; if CompassMode==2, we don't check for the compass
		LDA CompassField : AND.l DungeonItemMasks, X ; Load compass values to A, mask with dungeon item masks
		BEQ .done ; skip if we don't have compass
	++
	
	JMP (CompassCountDungeonHandlers, X) : .return_spot
	
	; we switch to 8-bit A in the jump before this
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
	
CompassCountDungeonHandlers: ; pointers to functions that handle dungeon-specific code
	dw CompassCount_Escape, 	CompassCount_Escape ; (hyrule castle, sewers)
	dw CompassCount_Eastern,	CompassCount_Desert,	CompassCount_Agah
	dw CompassCount_Swamp,		CompassCount_PoD,		CompassCount_Mire
	dw CompassCount_Skull,		CompassCount_Ice,		CompassCount_Hera
	dw CompassCount_Thieves,	CompassCount_Trock,		CompassCount_Gt
}

CompassCount_Escape:
	%DrawConstantNumber(0,8)
	LDA SewersLocations
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Eastern:
	%DrawConstantNumber(0,6)
	LDA EPLocations
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Desert: 
	%DrawConstantNumber(0,6)
	LDA DPLocations
	JMP DrawDungeonCompassCounts_return_spot

CompassCount_Agah:
	%DrawConstantNumber(0,2)
	LDA CTLocations
	JMP DrawDungeonCompassCounts_return_spot

CompassCount_Swamp:
	%DrawConstantNumber(1,0)
	LDA SPLocations
	JMP DrawDungeonCompassCounts_return_spot

CompassCount_PoD:
	%DrawConstantNumber(1,4)
	LDA PDLocations
	JMP DrawDungeonCompassCounts_return_spot

CompassCount_Mire:
	%DrawConstantNumber(0,8)
	LDA MMLocations
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Skull:
	%DrawConstantNumber(0,8)
	LDA SWLocations
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Ice:
	%DrawConstantNumber(0,8)
	LDA IPLocations
	JMP DrawDungeonCompassCounts_return_spot

CompassCount_Hera:
	%DrawConstantNumber(0,6)
	LDA THLocations
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Thieves:
	%DrawConstantNumber(0,8)
	LDA TTLocations
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Trock:
	%DrawConstantNumber(1,2)
	LDA TRLocations
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Gt:
	%DrawConstantNumber(2,7)
	LDA GTLocations
	JMP DrawDungeonCompassCounts_return_spot

