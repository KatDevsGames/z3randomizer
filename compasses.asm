;--------------------------------------------------------------------------------
; $7F5010 - Scratch Space (Callee Preserved)
;--------------------------------------------------------------------------------
!GOAL_COUNTER = "$7EF460"
DrawDungeonCompassCounts:
	LDA.l CompassMode : AND.w #$00FF : BNE + : RTL : + ; Item Counts
	LDA $1B : AND.w #$00FF : BNE + : RTL : + ; Skip if outdoors
	LDA $040C : CMP.w #$00FF : BNE + : RTL : + ; Skip if not in a dungeon
	PHX
		LDX $040C ; Load dungeon ID to X
		LDA $7EF364 : AND .item_masks, X ; Load compass values to A, mask with dungeon item masks
		BNE + : BRL .done : + ; skip if we don't have compass
		
		LDA $040C
	    CMP.w #$0000 : BNE + ; Sewer Passage
	    + : CMP.w #$0002 : BNE + ; Hyrule Castle
			LDA $7EF434 : AND.w #$00F0 : LSR #4
			BRL ++
	    + : CMP.w #$0004 : BNE + ; Eastern Palace
			LDA $7EF436 : AND.w #$0007
			BRL ++
	    + : CMP.w #$0006 : BNE + ; Desert Palace
			LDA $7EF435 : AND.w #$00E0 : LSR #5
			BRL ++
	    + : CMP.w #$0008 : BNE + ; Agahnim's Tower
			LDA $7EF435 : AND.w #$0002
			BRL ++
	    + : CMP.w #$000A : BNE + ; Swamp Palace
			LDA $7EF439 : AND.w #$000F
			BRL ++
	    + : CMP.w #$000C : BNE + ; Dark Palace
			LDA $7EF434 : AND.w #$000F
			BRA ++
	    + : CMP.w #$000E : BNE + ; Misery Mire
			LDA $7EF438 : AND.w #$000F
			BRA ++
	    + : CMP.w #$0010 : BNE + ; Skull Woods
			LDA $7EF437 : AND.w #$00F0 : LSR #4
			BRA ++
	    + : CMP.w #$0012 : BNE + ; Ice Palace
			LDA $7EF438 : AND.w #$00F0 : LSR #4
			BRA ++
	    + : CMP.w #$0014 : BNE + ; Tower of Hera
			LDA $7EF435 : AND.w #$001C : LSR #5
			BRA ++
	    + : CMP.w #$0016 : BNE + ; Thieves' Town
			LDA $7EF437 : AND.w #$000F
			BRA ++
	    + : CMP.w #$0018 : BNE + ; Turtle Rock
			LDA $7EF439 : AND.w #$00F0 : LSR #4
			BRA ++
	    + : CMP.w #$001A : BNE + ; Ganon's Tower
			LDA $7EF436 : AND.w #$00F8 : LSR #5
			BRA ++
		+ : ++
		JSL.l HexToDec
		
		LDA $7F5006 : AND.w #$00FF : ORA #$2400 : STA $7EC794
		LDA $7F5007 : AND.w #$00FF : ORA #$2400 : STA $7EC796
		
		LDA.w #$2830 : STA $7EC798
		
		LDA $040C
	    CMP.w #$0000 : BNE + ; Sewer Passage
	    + : CMP.w #$0002 : BNE + ; Hyrule Castle
			LDA.w #$0008
			BRL ++
	    + : CMP.w #$0004 : BNE + ; Eastern Palace
			LDA.w #$0006
			BRL ++
	    + : CMP.w #$0006 : BNE + ; Desert Palace
			LDA.w #$0006
			BRL ++
	    + : CMP.w #$0008 : BNE + ; Agahnim's Tower
			LDA.w #$0002
			BRL ++
	    + : CMP.w #$000A : BNE + ; Swamp Palace
			LDA.w #$000A
			BRL ++
	    + : CMP.w #$000C : BNE + ; Dark Palace
			LDA.w #$000E
			BRA ++
	    + : CMP.w #$000E : BNE + ; Misery Mire
			LDA.w #$0008
			BRA ++
	    + : CMP.w #$0010 : BNE + ; Skull Woods
			LDA.w #$0008
			BRA ++
	    + : CMP.w #$0012 : BNE + ; Ice Palace
			LDA.w #$0008
			BRA ++
	    + : CMP.w #$0014 : BNE + ; Tower of Hera
			LDA.w #$0006
			BRA ++
	    + : CMP.w #$0016 : BNE + ; Thieves' Town
			LDA.w #$0008
			BRA ++
	    + : CMP.w #$0018 : BNE + ; Turtle Rock
			LDA.w #$000C
			BRA ++
	    + : CMP.w #$001A : BNE + ; Ganon's Tower
			LDA.w #$001B
			BRA ++
		+ : ++
		JSL.l HexToDec
		
		LDA $7F5006 : AND.w #$00FF : ORA #$2400 : STA $7EC79A
		LDA $7F5007 : AND.w #$00FF : ORA #$2400 : STA $7EC79C
		
		.done
	PLX
RTL

.item_masks ; these are dungeon correlations to $7EF364 - $7EF369 so it knows where to store compasses, etc
    dw $8000, $4000, $2000, $1000, $0800, $0400, $0200, $0100
    dw $0080, $0040, $0020, $0010, $0008, $0004
}
;--------------------------------------------------------------------------------
; $7EF434 - hhhhdddd - item locations checked
; h - hyrule castle
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