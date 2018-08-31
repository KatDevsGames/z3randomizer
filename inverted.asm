

; Does tile modification for... the pyramid of power hole
; after Ganon slams into it in bat form?
Overworld_DrawPyramidHoleModified:
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
	LDA.w #$0E3F

	JSL Overworld_DrawPersistentMap16

	LDX.w #$03BE
	LDA.w #$0E40

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
