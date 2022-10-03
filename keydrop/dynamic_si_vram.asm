; where we shove the decompressed graphics to send to WRAM
DynamicDropGFX = $7EF500

; this will just count from 0 to 4 to determine which slot we're using
; we're expecting 5 items max per room, and order is irrelevant
; we just need to keep track of where they go
DynamicDropGFXIndex = $7E1E70

; this will keep track of the above for each item
SprItemGFX = $7E0780

; this is the item requested and a flag
DynamicDropRequest = $7E1E71
DynamicDropQueue = $7E1E72

; Come in with
;   A = item receipt ID
;   X = slot
RequestStandingItemVRAMSlot:
	STA.w DynamicDropQueue
	LDA.b #$01
	STA.w DynamicDropRequest

	LDA.w DynamicDropGFXIndex
	INC
	CMP.b #$05 : BCC .fine

	LDA.b #$00

.fine
	STA.w DynamicDropGFXIndex
	STA.w SprItemGFX,X


	; decompress graphics
	PHX
	LDX.w DynamicDropQueue

	REP #$20
	LDA.w #DynamicDropGFX-$7E9000
	STA.l !TILE_UPLOAD_OFFSET_OVERRIDE
	SEP #$20

	LDA.w DynamicDropQueue
	JSL.l GetSpriteID
	JSL.l GetAnimatedSpriteTile_variable

	SEP #$30
	PLX

	RTL


;===================================================================================================

TransferPotGFX:
	SEP #$10
	REP #$20
	LDX.w DynamicDropRequest
	BEQ .no

	STZ.w DynamicDropRequest

	LDA.w DynamicDropGFXIndex
	ASL
	TAX
	LDA.l FreeUWGraphics,X
	STA.w $2116

	; calculate bottom row now
	CLC : ADC.w #$0200>>1 : PHA

	LDX.b #$7E : STX.w $4314
	LDA.w #DynamicDropGFX : STA.w $4302

	LDX.b #$80 : STX.w $2115
	LDA.w #$1801 : STA.w $4300

	LDA.w #$0040 : STA.w $4305
	LDY.b #$01

	STY.w $420B
	STA.w $4305

	PLA
	STA.w $2116
	STY.w $420B

.no
	RTL


FreeUWGraphics:
	dw $8800>>1
	dw $8840>>1
	dw $8980>>1
	dw $9CA0>>1
	dw $9DC0>>1

;	dw $8800>>1
;	dw $8840>>1
;	dw $8980>>1
;	dw $9960>>1 # Arghuss Splash apparently
;	dw $9C00>>1
;	dw $9CA0>>1
;	dw $9DC0>>1

;===================================================================================================

DrawPotItem:
	JSL.l IsNarrowSprite : BCS .narrow

	.full
	LDA.b #$01 : STA $06
	LDA #$0C : JSL.l OAM_AllocateFromRegionC
	LDA #$02 : PHA
		REP #$20
		LDA.w #DynamicOAMTile_full
	BRA .draw

	.narrow
	LDA.b #$02 : STA $06
	LDA #$10 : JSL.l OAM_AllocateFromRegionC
	LDA #$03 : PHA
		 REP #$20
		 LDA.w #DynamicOAMTile_thin
    .draw
	PHB : PHK : PLB

	STA.b $08
	LDA.w SprItemGFX,X
	AND.w #$00FF
	ASL : ASL : ASL : ASL
	ADC.b $08
	STA.b $08
	SEP #$20
	STZ.b $07

	LDA.b #$00 : STA.l !SKIP_EOR
	JSL Sprite_DrawMultiple_quantity_preset

	LDA.b $90 : CLC : ADC.b #$08 : STA.b $90
	INC.b $92
	INC.b $92

	PLB
	PLA
	RTL

DynamicOAMTile_thin:
	dw 0, 0 : db $40, $00, $20, $00
	dw 0, 8 : db $50, $00, $20, $00

	dw 0, 0 : db $42, $00, $20, $00
	dw 0, 8 : db $52, $00, $20, $00

	dw 0, 0 : db $4C, $00, $20, $00
	dw 0, 8 : db $5C, $00, $20, $00

	dw 0, 0 : db $E5, $00, $20, $00
	dw 0, 8 : db $F5, $00, $20, $00

	dw 0, 0 : db $EE, $00, $20, $00
	dw 0, 8 : db $FE, $00, $20, $00

DynamicOAMTile_full:
	dw -4, -1 : db $40, $00, $20, $02
	dd 0, 0

	dw -4, -1 : db $42, $00, $20, $02
	dd 0, 0

	dw -4, -1 : db $4C, $00, $20, $02
	dd 0, 0

	dw -4, -1 : db $E5, $00, $20, $02
	dd 0, 0

	dw -4, -1 : db $EE, $00, $20, $02
	dd 0, 0