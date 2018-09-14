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
endmacro
;--------------------------------------------------------------------------------

DrawDungeonCompassCounts:
	LDX $1B : BNE + : RTL : + ; Skip if outdoors
	LDX $040C : CPX.b #$FF : BNE + : RTL : + ; Skip if not in a dungeon

	CMP.w #$0002 : BEQ ++ ; if CompassMode==2, we don't check for the compass
		LDA $7EF364 : AND.l .item_masks, X ; Load compass values to A, mask with dungeon item masks
		BNE + : RTL : + ; skip if we don't have compass
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

.item_masks ; these are dungeon correlations to $7EF364 - $7EF369 so it knows where to store compasses, etc
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
	SEP #$20
	LDA $7EF434 : LSR #4
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Eastern:
	%DrawConstantNumber(0,6)
	SEP #$20
	LDA $7EF436 : AND.b #$07
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Desert: 
	%DrawConstantNumber(0,6)
	SEP #$20
	LDA $7EF435 : LSR #5
	JMP DrawDungeonCompassCounts_return_spot

CompassCount_Agah:
	%DrawConstantNumber(0,2)
	SEP #$20
	LDA $7EF435 : AND.b #$02
	JMP DrawDungeonCompassCounts_return_spot

CompassCount_Swamp:
	%DrawConstantNumber(1,0)
	SEP #$20
	LDA $7EF439 : AND.b #$0F
	JMP DrawDungeonCompassCounts_return_spot

CompassCount_PoD:
	%DrawConstantNumber(1,4)
	SEP #$20
	LDA $7EF434 : AND.b #$0F
	JMP DrawDungeonCompassCounts_return_spot

CompassCount_Mire:
	%DrawConstantNumber(0,8)
	SEP #$20
	LDA $7EF438 : AND.b #$0F
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Skull:
	%DrawConstantNumber(0,8)
	SEP #$20
	LDA $7EF437 : LSR #4 
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Ice:
	%DrawConstantNumber(0,8)
	SEP #$20
	LDA $7EF438 : LSR #4 
	JMP DrawDungeonCompassCounts_return_spot

CompassCount_Hera:
	%DrawConstantNumber(0,6)
	SEP #$20
	LDA $7EF435 : AND.b #$1C : LSR #2
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Thieves:
	%DrawConstantNumber(0,8)
	SEP #$20
	LDA $7EF437 : AND.b #$0F
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Trock:
	%DrawConstantNumber(1,2)
	SEP #$20
	LDA $7EF439 : LSR #4
	JMP DrawDungeonCompassCounts_return_spot
	
CompassCount_Gt:
	%DrawConstantNumber(2,7)
	SEP #$20
	LDA $7EF436 : LSR #3
	JMP DrawDungeonCompassCounts_return_spot

;--------------------------------------------------------------------------------
; $7EF434 - hhhhdddd - item locations checked
; h - hyrule castle/sewers
; d - palace of darkness
;--------------------------------------------------------------------------------
; $7EF435 - dddhhhaa - item locations checked
; d - desert palace
; h - tower of hera
; a - agahnim's tower
;--------------------------------------------------------------------------------
; $7EF436 - gggggeee - item locations checked
; g - ganon's tower
; e - eastern palace
;--------------------------------------------------------------------------------
; $7EF437 - sssstttt - item locations checked
; s - skull woods
; t - thieves town
;--------------------------------------------------------------------------------
; $7EF438 - iiiimmmm - item locations checked
; i - ice palace
; m - misery mire
;--------------------------------------------------------------------------------
; $7EF439 - ttttssss - item locations checked
; t - turtle rock
; s - swamp palace
;--------------------------------------------------------------------------------