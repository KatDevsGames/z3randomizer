org $008A01 ; 0xA01 - Bank00.asm (LDA.b #$10 : STA $4304 : STA $4314 : STA $4324)
LDA.b PlayerSpriteBank

org $1BEDF9
JSL SpriteSwap_Palette_ArmorAndGloves ; 4bytes
RTL ; 1byte 
NOP

org $1BEE1B
JSL SpriteSwap_Palette_ArmorAndGloves_part_two
RTL

!BANK_BASE = $A9

org $BF8000
SwapSpriteIfNecessary:
	PHP
		SEP #$20 ; set 8-bit accumulator
		LDA.l SpriteSwapper : BEQ + : CLC : ADC.b #!BANK_BASE : CMP.b PlayerSpriteBank : BEQ +
			STA.b PlayerSpriteBank
			STZ.w SkipOAM ; Set Normal Sprite NMI
			JSL.l SpriteSwap_Palette_ArmorAndGloves_part_two
		+
	PLP
RTL

SpriteSwap_Palette_ArmorAndGloves:
{
	; DEDF9
	LDA.l SpriteSwapper : BNE .continue
		LDA.b #$10 : STA.b PlayerSpriteBank ; Load Original Sprite Location
		REP #$21
		LDA.l ArmorEquipment
		JSL $9BEDFF ; Read Original Palette Code
	RTL
	.part_two
	SEP #$30
	LDA.l SpriteSwapper : BNE .continue
		REP #$30
		LDA.l GloveEquipment 
		JSL $9BEE21 ; Read Original Palette Code
	RTL

	.continue

	PHX : PHY : PHA
	; Load armor palette
	PHB : PHK : PLB
	REP #$20 ; set 16-bit accumulator

	; Check what Link's armor value is.
	LDA.l ArmorEquipment : AND.w #$00FF : TAX

	LDA.l $9BEC06, X : AND.w #$00FF : ASL A : ADC.w #$F000 : STA.b Scrap00
	; replace D308 by 7000 and search
	REP #$10 ; set 16-bit index registers

	LDA.w #$01E2 ; Target SP-7 (sprite palette 6)
	LDX.w #$000E ; Palette has 15 colors

	TXY : TAX

	LDA.b PlayerSpriteBank : AND.w #$00FF : STA.b Scrap02

.loop

	LDA.b [Scrap00] : STA.l PaletteBufferAux, X : STA.l PaletteBuffer, X

	INC.b Scrap00 : INC.b Scrap00

	INX #2

	DEY : BPL .loop

	SEP #$30


	PLB
	INC.b NMICGRAM
	PLA : PLY : PLX
	RTL
}
