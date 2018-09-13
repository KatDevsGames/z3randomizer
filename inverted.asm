

; Does tile modification for... the pyramid of power hole
; after Ganon slams into it in bat form?
Overworld_CreatePyramidHoleModified:
	LDA.l InvertedMode : BNE +
		BRL .originalBehaviour
+
.invertedBehavior
	REP #$30

	LDX.w #$0440
	LDA.w #$0E39

	JSL Overworld_DrawPersistentMap16

	LDX.w #$04BC
	LDA.w #$0E3A

	JSL C9DE_LONG
	JSL C9DE_LONG
	JSL C9DE_LONG
	JSL C9DE_LONG

	LDX.w #$053C

	JSL C9DE_LONG
	JSL C9DE_LONG
	JSL C9DE_LONG
	JSL C9DE_LONG

	LDX.w #$05BE
	LDA.w #$0490

	JSL C9DE_LONG
	JSL C9DE_LONG

	LDA.w #$FFFF : STA $1012, Y

	BRL .ending
.originalBehaviour
	REP #$30

	LDX.w #$03BC
	LDA.w #$0E39

	JSL Overworld_DrawPersistentMap16

	LDX.w #$03BE
	LDA.w #$0E3A

	JSL C9DE_LONG
	JSL C9DE_LONG

	LDX.w #$043C

	JSL C9DE_LONG
	JSL C9DE_LONG
	JSL C9DE_LONG

	LDX.w #$04BC

	JSL C9DE_LONG
	JSL C9DE_LONG
	JSL C9DE_LONG

	LDA.w #$FFFF : STA $1012, Y

.ending
	LDA.w #$3515 : STA $012D

	SEP #$30

	LDA $7EF2DB : ORA.b #$20 : STA $7EF2DB

	LDA.b #$03 : STA $012F

	LDA.b #$01 : STA $14

RTL
;------------------------------------------------------------------------------
Draw_PyramidOverlay:
	LDA.l InvertedMode : BNE .done
.normal
	LDA.w #$0E39 : STA $23BC
	INC A        : STA $23BE
	INC A        : STA $23C0
	INC A        : STA $243C
	INC A        : STA $243E
	INC A        : STA $2440
	INC A        : STA $24BC
	INC A        : STA $24BE
	INC A        : STA $24C0
.done
RTL
;------------------------------------------------------------------------------

Inverted_TR_TileAttributes:
db $27, $27, $27, $27, $27, $27, $02, $02, $01, $01, $01, $00, $00, $00, $00, $00
db $27, $01, $01, $01, $01, $01, $02, $02, $27, $27, $27, $00, $00, $00, $00, $00
db $27, $01, $01, $01, $20, $01, $02, $02, $27, $27, $27, $00, $00, $00, $00, $00
db $27, $01, $01, $01, $01, $20, $02, $02, $02, $02, $02, $00, $00, $00, $00, $00
db $01, $01, $01, $01, $1A, $01, $12, $01, $01, $02, $01, $01, $28, $2E, $2A, $2B
db $01, $01, $18, $18, $1A, $01, $12, $01, $01, $2C, $02, $2D, $29, $2F, $02, $02
db $01, $01, $01, $01, $01, $01, $02, $01, $02, $2E, $00, $00, $2C, $00, $4E, $4F
db $01, $01, $01, $01, $01, $01, $02, $01, $02, $00, $2E, $00, $00, $00, $02, $22
db $01, $01, $02, $00, $00, $00, $18, $12, $02, $02, $00, $48, $00, $00, $00, $00
db $01, $01, $02, $00, $01, $01, $10, $1A, $02, $00, $00, $48, $00, $00, $00, $00
db $10, $10, $02, $00, $01, $01, $01, $01, $00, $00, $48, $00, $00, $09, $00, $00
db $02, $02, $02, $00, $01, $01, $2B, $00, $00, $09, $00, $00, $00, $00, $00, $00
db $01, $01, $01, $01, $01, $01, $02, $02, $02, $02, $02, $02, $02, $00, $00, $00
db $01, $01, $01, $01, $01, $01, $02, $02, $02, $02, $02, $02, $02, $00, $00, $00
db $01, $01, $01, $46, $01, $01, $02, $02, $02, $02, $02, $02, $02, $00, $00, $00
db $01, $01, $01, $01, $01, $01, $02, $02, $02, $02, $02, $02, $02, $00, $00, $00
db $02, $02, $42, $02, $02, $02, $02, $02, $02, $02, $29, $22, $00, $00, $00, $00
db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $29, $22, $00, $00, $00, $00
db $00, $02, $02, $02, $00, $00, $02, $02, $02, $02, $00, $00, $00, $00, $00, $00
db $00, $02, $02, $02, $02, $29, $02, $02, $02, $02, $00, $00, $00, $00, $00, $00
db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $02, $44
db $01, $01, $01, $01, $01, $01, $01, $01, $02, $02, $02, $00, $00, $00, $02, $44
db $01, $01, $01, $01, $01, $01, $01, $01, $02, $02, $02, $00, $00, $00, $00, $00
db $01, $01, $43, $01, $01, $01, $01, $01, $02, $02, $02, $00, $00, $00, $00, $00
db $50, $02, $54, $51, $57, $57, $56, $56, $27, $27, $27, $00, $40, $40, $48, $48
db $50, $02, $54, $51, $57, $2A, $56, $56, $27, $27, $27, $00, $40, $40, $57, $48
db $27, $02, $52, $53, $02, $01, $12, $18, $55, $55, $00, $00, $48, $02, $02, $00
db $27, $02, $52, $53, $09, $01, $1A, $10, $55, $55, $00, $00, $48, $02, $02, $00
db $02, $02, $18, $08, $08, $08, $09, $09, $08, $08, $29, $02, $02, $02, $1A, $02
db $08, $08, $10, $08, $12, $00, $09, $09, $09, $09, $09, $48, $09, $29, $00, $4B
db $02, $02, $02, $00, $08, $02, $02, $00, $00, $00, $00, $01, $00, $00, $20, $00
db $02, $02, $02, $02, $02, $02, $02, $00, $00, $01, $01, $01, $02, $00, $08, $00

Electric_Barrier:
	LDA InvertedMode : BEQ .done
		LDA $7EF280, X : ORA #$40 : STA $7EF280, X ;set barrier dead
	.done
	LDA $7EF280, X ; what we wrote over
RTL


GanonTowerAnimation:
	LDA InvertedMode : BEQ .done
		LDA.b #$1B : STA $012F
        STZ $04C6
        STZ $B0
        STZ $0710
        STZ $02E4
        
        STZ $0FC1
        
        STZ $011A
        STZ $011B
        STZ $011C
        STZ $011D
		LDA.b #$02 : STA $012C
        LDA.b #$09 : STA $012D
		RTL
	.done
	    LDA.b #$05 : STA $04C6 ;what we wrote over
        STZ $B0 ; (continued)
RTL

;Hard coded rock removed in LW for Inverted mode
HardcodedRocks:

    LDA InvertedMode : BEQ .normalrocks
        BRA .noRock2
    .normalrocks
        LDA.w #$020F : LDX $8A : CPX.w #$0033 : BNE .noRock
        STA $7E22A8
    .noRock
        CPX.w #$002F : BNE .noRock2
        STA $7E2BB2
    .noRock2
RTL
