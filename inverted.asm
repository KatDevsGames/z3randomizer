

; Does tile modification for... the pyramid of power hole
; after Ganon slams into it in bat form?
Overworld_CreatePyramidHoleModified:
	LDA.l InvertedMode : BNE +
		JMP .originalBehaviour
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

	LDA.w #$FFFF : STA.w GFXStripes+$12, Y

	JMP .ending
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

	LDA.w #$FFFF : STA.w GFXStripes+$12, Y

.ending
	LDA.w #$3515 : STA.w SFX1

	SEP #$30

	LDA.l OverworldEventDataWRAM+$5B : ORA.b #$20 : STA.l OverworldEventDataWRAM+$5B

	LDA.b #$03 : STA.w SFX3

	LDA.b #$01 : STA.b NMISTRIPES

RTL
;------------------------------------------------------------------------------
Draw_PyramidOverlay:
	LDA.l InvertedMode : AND.w #$00FF : BNE .done
.normal
	LDA.w #$0E39 : STA.w $23BC
	INC A        : STA.w $23BE
	INC A        : STA.w $23C0
	INC A        : STA.w $243C
	INC A        : STA.w $243E
	INC A        : STA.w $2440
	INC A        : STA.w $24BC
	INC A        : STA.w $24BE
	INC A        : STA.w $24C0
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
	LDA.l InvertedMode : BEQ .done
		LDA.l OverworldEventDataWRAM, X : ORA.b #$40 : STA.l OverworldEventDataWRAM, X ;set barrier dead
	.done
	LDA.l OverworldEventDataWRAM, X ; what we wrote over
RTL


GanonTowerAnimation:
        LDA.l InvertedMode : BEQ .done
                LDA.b #$1B : STA.w SFX3
        STZ.w OWEntranceCutscene
        STZ.b SubSubModule
        STZ.w SkipOAM
        STZ.w CutsceneFlag

        STZ.w FreezeSprites

        STZ.w BG1ShakeV
        STZ.w BG1ShakeV+1
        STZ.w BG1ShakeH
        STZ.w BG1ShakeH+1
        LDA.b #$02 : STA.w MusicControlRequest
        LDA.b #$09 : STA.w SFX1
        RTL

        .done
        LDA.b #$05 : STA.w OWEntranceCutscene ; what we wrote over
        STZ.b SubSubModule ; (continued)
        STZ.b ScrapBufferBD+$0B ; (continued)
RTL

GanonTowerInvertedCheck:
{
	LDA.l InvertedMode : BEQ .done
		LDA.b #$01 ; Load a random value so it doesn't BEQ
	RTL
	.done
	LDA.b OverworldIndex : CMP.b #$43 ;what we wrote over
	RTL
}


;Hard coded rock removed in LW for Inverted mode
HardcodedRocks:

    LDA.l InvertedMode : AND.w #$00FF : BEQ .normalrocks
        BRA .noRock2
    .normalrocks
        LDA.w #$020F : LDX.b OverworldIndex : CPX.w #$0033 : BNE .noRock
        STA.l $7E22A8
    .noRock
        CPX.w #$002F : BNE .noRock2
        STA.l $7E2BB2
    .noRock2
RTL

TurtleRockPegSolved:
	LDA.l InvertedMode : AND.w #$00FF : BNE +
		LDA.l OverworldEventDataWRAM+07 ; What we wrote over (reading flags for this screen)
		RTL
	+
	LDA.w #$0020 ; We always treat puzzle as pre solved (overlay flag set) for inverted mode.
RTL

MirrorBonk:
        ; must preserve X/Y, and must preserve $00-$0F
        LDA.l InvertedMode : BEQ .normal

        ; Goal: use $20 and $22 to decide to force a bonk
        ; if we want to bonk branch to .forceBonk
        ; otherwise fall through to .normal
		PHX : PHP
		PHB : PHK : PLB
		LDA.b OverworldIndex : AND.b #$40 : BEQ .endLoop ;World we're in? branch if we are in LW we don't want bonks
		REP #$30
		LDX.w #$0000
		.loop
			LDA.l .bonkRectanglesTable, X ;Load X1
			CMP.b LinkPosX : !BGE ++
			;IF X > X1
			LDA.l .bonkRectanglesTable+2, X ; Load X2
			CMP.b LinkPosX : !BLT ++ 
			;IF X < X2
			LDA.l .bonkRectanglesTable+4, X ;Load Y1
			CMP.b LinkPosY : !BGE ++
			;IF Y > Y1
			LDA.l .bonkRectanglesTable+6, X ; Load Y2
			CMP.b LinkPosY : !BLT ++ 
			;IF Y < Y2
			;Bonk Here
			PLB : PLP : PLX
			BRA .forceBonk
                ++
                TXA : !ADD #$0008 : CMP.w #.tableEnd-.bonkRectanglesTable : BEQ .endLoop
                TAX
                BRA .loop
                .endbonkRectanglesTable

        .endLoop
        PLB : PLP : PLX
.normal
        ;Not forcing a bonk, so the vanilla bonk detection run.
        LDA.b Scrap0C : ORA.b Scrap0E
JML.l MirrorBonk_NormalReturn
.forceBonk
JML.l MirrorBonk_BranchGamma

.bonkRectanglesTable
   ;X1     X2      Y1      Y2
dw #$0290, #$02C8, #$0CA8, #$0CF8 ;Desert checkerboard cave2
dw #$05F8, #$0A00, #$0600, #$0660 ;Castle Top
dw #$05B0, #$06A0, #$0660, #$0830 ;Castle Top
dw #$06A0, #$0770, #$0660, #$0680 ;Castle Top
dw #$0880, #$0950, #$0660, #$0688 ;Castle Top
dw #$0950, #$0A00, #$0660, #$0830 ;Castle Top
dw #$07B8, #$0848, #$08E0, #$0970 ;Castle Bridge
dw #$02EF, #$0321, #$0C16, #$0CA2 ;Desert (Mazeblock cave)
dw #$0048, #$008F, #$0B10, #$0B48 
dw #$0358, #$0440, #$0E08, #$0ED0 
dw #$03B8, #$0420, #$0ED0, #$0FE8 
dw #$0360, #$03C8, #$0EC0, #$0F20 
dw #$0C68, #$0D00, #$0D78, #$0DC8 
dw #$0F40, #$0F70, #$0618, #$0640 ;Pod/eastern entrance
dw #$0E28, #$0E78, #$0298, #$02E8 
dw #$0F10, #$0F80, #$01F8, #$0238 
dw #$0AA8, #$0B90, #$02C8, #$0320 
dw #$0D18, #$0D80, #$0040, #$0070 
dw #$0EF0, #$0F30, #$0120, #$0160 
dw #$0AD0, #$0B00, #$0B50, #$0B70 ;Bridge Left
dw #$0B30, #$0B60, #$0B50, #$0B70 ;Bridge Right
dw #$0678, #$06F0, #$0010, #$0040 ;Ether Island
dw #$02A8, #$02E8, #$0C90, #$0CC0 ;Desert Checkerboard Cave3
.tableEnd
