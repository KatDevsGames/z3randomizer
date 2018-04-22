;================================================================================
; Randomize Flute Dig Item
;--------------------------------------------------------------------------------
SpawnHauntedGroveItem:
	LDA $8A : CMP.b #$2A : BEQ + : RTL : + ; Skip if not the haunted grove
	LDA $1B : BEQ + : RTL : + ; Skip if indoors
	
	LDA.l HauntedGroveItem
	JSL.l PrepDynamicTile
	
	LDA.b #$EB
	STA $7FFE00
	JSL Sprite_SpawnDynamically

	LDX.b #$00
	LDA $2F : CMP.b #$04 : BEQ + : INX : +

	LDA .x_speeds, X : STA $0D50, Y

	LDA.b #$00 : STA $0D40, Y
	LDA.b #$18 : STA $0F80, Y
	LDA.b #$FF : STA $0B58, Y
	LDA.b #$30 : STA $0F10, Y

	LDA $22 : !ADD .x_offsets, X
							AND.b #$F0 : STA $0D10, Y
	LDA $23 : ADC.b #$00			   : STA $0D30, Y

	LDA $20 : !ADD.b #$16 : AND.b #$F0 : STA $0D00, Y
	LDA $21 : ADC.b #$00			   : STA $0D20, Y

	LDA.b #$00 : STA $0F20, Y
	TYX

	LDX $8A ; haunted grove (208D0A)
	LDA $7EF280, X : AND.b #$40 : BNE +
		LDA.b #$1B : JSL Sound_SetSfx3PanLong
	+
RTL

;DATA - Flute Spawn Information
{

.x_speeds
	db $F0
	db $10

.x_offsets
	db $00
	db $13

}
;--------------------------------------------------------------------------------
FluteBoy:
	LDA $10 : CMP.b #$1A : BEQ +
		LDA.b #$01 : STA $0FDD
		JML.l FluteBoy_Abort
	+
	LDA $0D80, X : CMP.b #$03 ; thing we wrote over
JML.l FluteBoy_Continue
;--------------------------------------------------------------------------------
