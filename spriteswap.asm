org $008A01 ; 0xA01 - Bank00.asm (LDA.b #$10 : STA $4304 : STA $4314 : STA $4324)
LDA $BC

org $1BEDF9
JSL SpriteSwap_Palette_ArmorAndGloves ;4bytes
RTL ;1byte 
NOP #$01

org $1BEE1B
JSL SpriteSwap_Palette_ArmorAndGloves_part_two
RTL

!SPRITE_SWAP = "$7F50CD"
;!STABLE_SCRATCH = "$7EC178"
!BANK_BASE = "#$29"

org $BF8000
SwapSpriteIfNecissary:
	PHP
		SEP #$20 ; set 8-bit accumulator
		LDA !SPRITE_SWAP : BEQ + : !ADD !BANK_BASE : CMP $BC : BEQ +
			STA $BC
		    STZ $0710 ; Set Normal Sprite NMI
			JSL.l SpriteSwap_Palette_ArmorAndGloves_part_two
		+
	PLP
RTL

SpriteSwap_Palette_ArmorAndGloves:
{
    ;DEDF9
    LDA !SPRITE_SWAP : BNE .continue
        LDA.b #$10 : STA $BC ; Load Original Sprite Location
        REP #$21
        LDA $7EF35B
        JSL $1BEDFF ; Read Original Palette Code
    RTL
    .part_two
    SEP #$30
    LDA !SPRITE_SWAP : BNE .continue
        REP #$30
        LDA $7EF354 
        JSL $1BEE21 ; Read Original Palette Code
    RTL

    .continue

    PHX : PHY : PHA
    ; Load armor palette
        PHB : PHK : PLB
    REP #$20 ; set 16-bit accumulator
    
    ; Check what Link's armor value is.
    LDA $7EF35B : AND.w #$00FF : TAX
    
    ; (DEC06, X)
    
    LDA $1BEC06, X : AND.w #$00FF : ASL A : ADC.w #$F000 : STA $00
    ;replace D308 by 7000 and search
    REP #$10 ; set 16-bit index registers
    
    LDA.w #$01E2 ; Target SP-7 (sprite palette 6)
    LDX.w #$000E ; Palette has 15 colors
    
    TXY : TAX
    
    LDA.b $BC : AND #$00FF : STA $02

.loop

    LDA [$00] : STA $7EC300, X : STA $7EC500, X
    
    INC $00 : INC $00
    
    INX #2
    
    DEY : BPL .loop

    SEP #$30
    
    
    PLB
    INC $15
    PLA : PLY : PLX
    RTL
}