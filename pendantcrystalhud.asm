;================================================================================
; Pendant / Crystal HUD Fix
;--------------------------------------------------------------------------------
;CheckPendantHUD:
;	LDA !HUD_FLAG : CMP.b #$40 ; check for hud flag instead
;RTL
;================================================================================
FlipLWDWFlag:
	PHP
	SEP #$20 ; set 8-bit accumulator
	LDA $7EF3CA : EOR.b #$40 : STA $7EF3CA
	BEQ +
		LDA.b #07 : BRA ++ ; dark world - crystals
	+ 
		LDA.b #03 ; light world - pendants
	++
	STA $7EF3C7
	PLP
RTL
;================================================================================
GetCrystalNumber:
	PHX
		TXA : ASL : TAX
		LDA $7EF3CA : EOR.b #$40 : BNE +
			INX
		+
		LDA.l CrystalNumberTable-16, X
	PLX
RTL
;================================================================================
!INVENTORY_MAP = "$7EF368"
OverworldMap_CheckObject:
	PHX
		LDA $7EF3CA : AND.b #$40 : BNE +
			;LW Map
			LDA.l MapMode : BEQ +++
			LDA.l !INVENTORY_MAP : AND.b #$01 : BNE +++
				PHX
					LDA.l .lw_map_offsets, X : TAX ; put map offset into X
					LDA.l !INVENTORY_MAP, X
				PLX
				AND.l .lw_map_masks, X : BNE +++
				BRL .fail
			+++
			LDA.l .lw_offsets, X
			BPL +++ : CLC : BRA .done : +++ ; don't display master sword
			TAX : BRA ++
		+ : CMP.b #$07 : BNE .fail
			;DW Map
			LDA.l MapMode : BEQ +++
			LDA.l !INVENTORY_MAP : AND.b #$02 : BNE +++
				PHX
					LDA.l .dw_map_offsets, X : TAX ; put map offset into X
					LDA.l !INVENTORY_MAP, X
				PLX
				AND.l .dw_map_masks, X : BNE +++
				BRL .fail
			+++
			LDA.l .dw_offsets, X
			TAX : BRA ++
	SEC
	PLX
RTL
++
		LDA.l CrystalPendantFlags_2, X
		AND.b #$40 : BNE .checkCrystal
		
		.checkPendant
		LDA $7EF374 : AND.l CrystalPendantFlags, X : BNE .fail
		CLC : BRA .done
	
		.checkCrystal
		LDA $7EF37A : AND.l CrystalPendantFlags, X : BNE .fail
		CLC : BRA .done
	
		.fail
		SEC
		.done
	PLX
RTL
.lw_offsets
db $02, $0A, $03, $FF
.dw_offsets
db $06, $08, $0C, $0B, $07, $09, $05
.lw_map_offsets
db $01, $01, $00
.dw_map_offsets
db $01, $01, $00, $00, $00, $01, $00
.lw_map_masks
db $20, $10, $20, $00
.dw_map_masks
db $02, $04, $80, $10, $40, $01, $04
;================================================================================
SetLWDWMap:
	PHP
	SEP #$20 ; set 8-bit accumulator
	LDA $7EF3CA : EOR.b #$40
	BNE +
		LDA.b #07 : BRA ++ ; dark world - crystals
	+ 
		LDA.b #03 ; light world - pendants
	++
	STA $7EF3C7
	PLP
RTL
;================================================================================
GetMapMode:
	LDA $7EF3CA : AND.b #$40 : BEQ +
		LDA.b #07 ; dark world - crystals
RTL
	+ 
		LDA.b #03 ; light world - pendants
RTL
;================================================================================
CheckHeraObject:
	LDA CrystalPendantFlags_2_hera : BNE .crystal
	
	.pendant
	LDA $7EF374 : AND.l CrystalPendantFlags_hera
RTL
	.crystal
	LDA $7EF37A : AND.l CrystalPendantFlags_hera
RTL
;================================================================================
;GetPendantCrystalWorld:
;	PHB : PHK : PLB
;	PHX
;		LDA $040C : LSR : TAX
;		LDA .dungeon_worlds, X
;	PLX : PLB
;	CMP.b #$00
;RTL
;================================================================================
ShowDungeonItems:
	LDA $040C : AND.w #$00FF : CMP.w #$00FF : BNE + : RTL : + ; return normal result if outdoors or in a cave
	;LDA $F0 : AND.w #$0020 ; check for select
	LDA !HUD_FLAG : AND.w #$0020 ; check hud flag
	BEQ + : LDA.w #$0000 : RTL : + ; if set, send the zero onwards
	LDA $040C : AND.w #$00FF : CMP.w #$00FF ; original logic
RTL
;================================================================================
DrawPendantCrystalDiagram:
	PHP : PHB : PHK : PLB
		REP #$30 ; Set 16-bit accumulator & index registers
		LDX.w #$0000 ; Paint entire box black & draw empty pendants and crystals
		-
	        LDA .row0, X : STA $12EA, X
	        LDA .row1, X : STA $132A, X
	        LDA .row2, X : STA $136A, X
	        LDA .row3, X : STA $13AA, X
	        LDA .row4, X : STA $13EA, X
	        LDA .row5, X : STA $142A, X
	        LDA .row6, X : STA $146A, X
	        LDA .row7, X : STA $14AA, X
	        LDA .row8, X : STA $14EA, X
		INX #2 : CPX.w #$0014 : BCC -
		
		;pendants
		LDA $7EF374 : AND.w #$0004 : BEQ + ; pendant of courage (green)
			LDA.w #$3D2B : STA $1332
			LDA.w #$3D2C : STA $1334
			LDA.w #$3D2D : STA $1372
			LDA.w #$3D2E : STA $1374
		+ LDA $7EF374 : AND.w #$0002 : BEQ + ; pendant of power (blue)
			LDA.w #$2D2B : STA $13AE
			LDA.w #$2D2C : STA $13B0
			LDA.w #$2D2D : STA $13EE
			LDA.w #$2D2E : STA $13F0
		+ LDA $7EF374 : AND.w #$0001 : BEQ + ; pendant of wisdom (red)
			LDA.w #$252B : STA $13B6
			LDA.w #$252C : STA $13B8
			LDA.w #$252D : STA $13F6
			LDA.w #$252E : STA $13F8
		+
		
		;crystals
		LDA $7EF37A : AND.w #$0002 : BEQ + ; crystal 1
			LDA.w #$2D44 : STA $14AC
			LDA.w #$2D45 : STA $14AE
		+ LDA $7EF37A : AND.w #$0010 : BEQ + ; crystal 2
			LDA.w #$2D44 : STA $146E
			LDA.w #$2D45 : STA $1470
		+ LDA $7EF37A : AND.w #$0040 : BEQ + ; crystal 3
			LDA.w #$2D44 : STA $14B0
			LDA.w #$2D45 : STA $14B2
		+ LDA $7EF37A : AND.w #$0020 : BEQ + ; crystal 4
			LDA.w #$2D44 : STA $1472
			LDA.w #$2D45 : STA $1474
		+ LDA $7EF37A : AND.w #$0004 : BEQ + ; crystal 5
			LDA.w #$2D44 : STA $14B4
			LDA.w #$2D45 : STA $14B6
		+ LDA $7EF37A : AND.w #$0001 : BEQ + ; crystal 6
			LDA.w #$2D44 : STA $1476
			LDA.w #$2D45 : STA $1478
		+ LDA $7EF37A : AND.w #$0008 : BEQ + ; crystal 7
			LDA.w #$2D44 : STA $14B8
			LDA.w #$2D45 : STA $14BA
		+ 
	PLB : PLP
RTL
;================================================================================
.row0 dw $28FB, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $68FB
.row1 dw $28FC, $24F5, $24F5, $24F5, $312B, $312C, $24F5, $24F5, $24F5, $68FC
.row2 dw $28FC, $24F5, $24F5, $24F5, $313D, $312E, $24F5, $24F5, $24F5, $68FC
.row3 dw $28FC, $24F5, $312B, $312C, $24F5, $24F5, $312B, $312C, $24F5, $68FC
.row4 dw $28FC, $24F5, $313D, $312E, $24F5, $24F5, $313D, $312E, $24F5, $68FC
.row5 dw $28FC, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $68FC
.row6 dw $28FC, $24F5, $3146, $3147, $3146, $3147, $3146, $3147, $24F5, $68FC
.row7 dw $28FC, $3146, $3147, $3146, $3147, $3146, $3147, $3146, $3147, $68FC
.row8 dw $A8FB, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $E8FB
;================================================================================
;Crystal 1: $02
;Crystal 2: $10
;Crystal 3: $40
;Crystal 4: $20
;Crystal 5: $04
;Crystal 6: $01
;Crystal 7: $08
;;blank pendant
;db $2B, $31, $2C, $31, $3D, $31, $2E, $31
;
;;red pendant
;db $2B, $25, $2C, $25, $2D, $25, $2E, $25
;
;;blue pendant
;db $2B, $2D, $2C, $2D, $2D, $2D, $2E, $2D
;
;;green pendant
;db $2B, $3D, $2C, $3D, $2D, $3D, $2E, $3D
;================================================================================
.pendants
dw $28FB, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $68FB
dw $28FC, $2521, $2522, $2523, $2524, $253F, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $213B, $213C, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $213D, $213E, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $213B, $213C, $24F5, $24F5, $213B, $213C, $24F5, $68FC
dw $28FC, $24F5, $213D, $213E, $24F5, $24F5, $213D, $213E, $24F5, $68FC
dw $A8FB, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $E8FB
.crystals
dw $28FB, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $68FB
dw $28FC, $252F, $2534, $2535, $2536, $2537, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $3146, $3147, $3146, $3147, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $3146, $3147, $3146, $3147, $3146, $3147, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $3146, $3147, $3146, $3147, $24F5, $24F5, $68FC
dw $A8FB, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $E8FB
;================================================================================
; DATA - Dungeon Worlds
;.dungeon_worlds
;db $00, $00, $00, $00, $00, $40, $40, $40
;db $40, $40, $00, $40, $40, $40, $FF, $FF
;================================================================================
;0x00 - Sewer Passage
;0x02 - Hyrule Castle
;0x04 - Eastern Palace
;0x06 - Desert Palace
;0x08 - Hyrule Castle 2
;0x0A - Swamp Palace
;0x0C - Palace of Darkness
;0x0E - Misery Mire
;0x10 - Skull Woods
;0x12 - Ice Palace
;0x14 - Tower of Hera
;0x16 - Thieves' Town
;0x18 - Turtle Rock
;0x1A - Ganon's Tower
;0x1C - ??? possibly unused. (Were they planning two extra dungeons perhaps?)
;0x1E - ??? possibly unused.
;================================================================================