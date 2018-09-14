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
HUDRebuildIndoorHole:
	PHA
	LDA.l GenericKeys : BEQ .normal
	.generic
	PLA
	LDA $7EF38B ; generic key count
	JSL.l HUD_RebuildIndoor_Palace
RTL
	.normal
	PLA
	JSL.l HUD_RebuildIndoor_Palace
RTL
;================================================================================
HUDRebuildIndoor:
	LDA.l GenericKeys : BEQ .normal
	.generic
	LDA.b #$00 : STA $7EC017
	LDA $7EF38B ; generic key count
RTL
	.normal
    LDA.b #$00 : STA $7EC017
    LDA.b #$FF ; don't show keys
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
!MAP_OVERLAY = "$7EF414" ; [2]
OverworldMap_CheckObject:
	PHX
		;CPX.b #$01 : BNE + : BRL ++ : + : BRL .fail
		LDA $7EF3CA : AND.b #$40 : BNE +
			;LW Map
			LDA.l MapMode : BEQ +++
			LDA !INVENTORY_MAP : ORA !MAP_OVERLAY : AND.b #$01 : BNE +++
				PHX
					LDA.l .lw_map_offsets, X : TAX ; put map offset into X
					LDA !INVENTORY_MAP, X : ORA !MAP_OVERLAY, X
				PLX
				AND.l .lw_map_masks, X : BNE +++
				BRL .fail
			+++
			LDA.l .lw_offsets, X
			BPL +++ : CLC : BRA .done : +++ ; don't display master sword
			TAX : BRA ++
		+
			;DW Map
			LDA.l MapMode : BEQ +++			
			LDA !INVENTORY_MAP : ORA !MAP_OVERLAY : AND.b #$02 : BNE +++
				PHX
					LDA.l .dw_map_offsets, X : TAX ; put map offset into X
					LDA.l !INVENTORY_MAP, X : ORA !MAP_OVERLAY, X
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
db $01, $00, $01
; pod skull trock thieves mire ice swamp
.dw_map_offsets
db $01, $00, $00, $00, $01, $00, $01
.lw_map_masks
db $20, $20, $10, $00
.dw_map_masks
db $02, $80, $08, $10, $01, $40, $04
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
	LDA CrystalPendantFlags_2_hera : AND.w #$00FF : BNE .crystal
	
	.pendant
	LDA $7EF374 : AND.l CrystalPendantFlags_hera : AND.w #$00FF
RTL
	.crystal
	LDA $7EF37A : AND.l CrystalPendantFlags_hera : AND.w #$00FF
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
BringMenuDownEnhanced:
	REP #$20 ; set 16-bit accumulator
		LDA.l TournamentSeed : AND.w #$00FF
		BEQ +
			LDA.w #$0008 : BRA ++ ; use default speed on tournament seeds
		+
			LDA.l MenuSpeed
		++

		EOR.w #$FFFF : !ADD.w #$0001 ; negate menu speed

		!ADD $EA : CMP.w #$FF18 : !BGE .noOvershoot
			LDA.w #$FF18 ; if we went past the limit, go to the limit
		.noOvershoot
		STA $EA : CMP.w #$FF18
	SEP #$20 ; set 8-bit accumulator
	BNE .notDoneScrolling
		INC $0200
	.notDoneScrolling
RTL
;================================================================================
RaiseHudMenu:
	LDA.l TournamentSeed : AND.w #$00FF
	BEQ +
		LDA.w #$0008 : BRA ++ ; use default speed on tournament seeds
	+
		LDA.l MenuSpeed : AND.w #$00FF
	++

	!ADD $EA : BMI .noOvershoot
		LDA.w #$0000 ; if we went past the limit, go to the limit
	.noOvershoot
	STA $EA
RTL
;================================================================================
CheckCloseItemMenu:
	LDA.l MenuCollapse : BNE + 
		LDA $F4 : AND.b #$10 : RTL
	+
	LDA $F0 : AND.b #$10 : EOR.b #$10
RTL
;================================================================================
ShowDungeonItems:
	LDA $040C : AND.w #$00FF : CMP.w #$00FF : BNE + : RTL : + ; return normal result if outdoors or in a cave
	;LDA $F0 : AND.w #$0020 ; check for select
	LDA !HUD_FLAG : AND.w #$0020 ; check hud flag
	BEQ + : LDA.w #$0000 : RTL : + ; if set, send the zero onwards
	LDA $040C : AND.w #$00FF : CMP.w #$00FF ; original logic
RTL
;--------------------------------------------------------------------------------
UpdateKeys:
	PHX : PHP
	SEP #$30 ; set 8-bit accumulator & index registers
		LDA $040C : CMP.b $1F : !BLT .skip
		
		LSR : TAX ; get dungeon index and store to X
	
		LDA $7EF36F ; load current key count
		STA $7EF37C, X ; save to main counts
		
		CPX.b #$00 : BNE +
			STA $7EF37D ; copy HC to sewers
		+ : CPX.b #$01 : BNE +
			STA $7EF37C ; copy sewers to HC
		+
		.skip
	JSL.l PostItemGet
	PLP : PLX
RTL
;$37C = Sewer Passage
;$37D = Hyrule Castle
;$37E = Eastern Palace
;$37F = Desert Palace
;$380 = Hyrule Castle 2
;$381 = Swamp Palace
;$382 = Dark Palace
;$383 = Misery Mire
;$384 = Skull Woods
;$385 = Ice Palace
;$386 = Tower of Hera
;$387 = Gargoyle's Domain
;$388 = Turtle Rock
;$389 = Ganon's Tower
;--------------------------------------------------------------------------------
DrawBootsInMenuLocation:
	LDA.l HUDDungeonItems : BNE +
		LDA.w #$1608 : STA $00
		RTL
	+
	LDA.w #$1588 : STA $00
RTL
;--------------------------------------------------------------------------------
DrawGlovesInMenuLocation:
	LDA.l HUDDungeonItems : BNE +
		LDA.w #$1610 : STA $00
		RTL
	+
	LDA.w #$1590 : STA $00
RTL
;--------------------------------------------------------------------------------
DrawFlippersInMenuLocation:
	LDA.l HUDDungeonItems : BNE +
		LDA.w #$1618 : STA $00
		RTL
	+
	LDA.w #$1598 : STA $00
RTL
;--------------------------------------------------------------------------------
DrawMoonPearlInMenuLocation:
	LDA.l HUDDungeonItems : BNE +
		LDA.w #$1620 : STA $00
		RTL
	+
	LDA.w #$15A0 : STA $00
RTL
;--------------------------------------------------------------------------------
DrawHUDDungeonItems:
	LDA.l HUDDungeonItems : BNE + : RTL : +
	
	PHP
	REP #$30 ; set 16-bit accumulator & index registers
	
	; dungeon names
	LDA.w #$2D50 : STA $1646 ; sewers
	LDA.w #$2D54 : STA $1648 ; Agahnims Tower

	LDA.w #$2D51 : STA $164C ; Eastern
	LDA.w #$2D52 : STA $164E ; Desert
	LDA.w #$2D53 : STA $1650 ; Hera

	LDA.w #$2D55 : STA $1654 ; PoD
	LDA.w #$2D56 : STA $1656 ; Swamp
	LDA.w #$2D57 : STA $1658 ; Skull Woods
	LDA.w #$2D58 : STA $165A ; Thieves Town
	LDA.w #$2D59 : STA $165C ; Ice
	LDA.w #$2D5A : STA $165E ; Mire
	LDA.w #$2D5B : STA $1660 ; Turtle Rock
 
	LDA.w #$2D5C : STA $1664 ; Ganon's Tower

	; write black
	LDX.w #$0000 ; Paint entire box black & draw empty pendants and crystals
	-
		LDA #$24F5 : STA $1686, X : STA $16C6, X
	INX #2 : CPX.w #$0020 : BCC -

	LDA !HUD_FLAG : AND.w #$0020 : BEQ + : BRL +++ : +
	LDA HUDDungeonItems : AND.w #$0001 : BNE + : BRL ++ : +
		LDA.w #$2810 : STA $1684 ; small keys icon
		SEP #$20 ; set 8-bit accumulator
		; Small Keys
		LDA.b #$16 : !ADD $7EF37D : STA $1686 : LDA.b #$28 : ADC #$00 : sta.w $1686+1 ; Hyrule Castle
		LDA.b #$16 : !ADD $7EF380 : STA $1688 : LDA.b #$28 : ADC #$00 : sta.w $1688+1 ; Agahnims Tower

		LDA.b #$16 : !ADD $7EF37E : STA $168C : LDA.b #$28 : ADC #$00 : sta.w $168C+1 ; Eastern
		LDA.b #$16 : !ADD $7EF37F : STA $168E : LDA.b #$28 : ADC #$00 : sta.w $168E+1 ; Desert
		LDA.b #$16 : !ADD $7EF386 : STA $1690 : LDA.b #$28 : ADC #$00 : sta.w $1690+1 ; Hera

		LDA.b #$16 : !ADD $7EF382 : STA $1694 : LDA.b #$28 : ADC #$00 : sta.w $1694+1 ; PoD
		LDA.b #$16 : !ADD $7EF381 : STA $1696 : LDA.b #$28 : ADC #$00 : sta.w $1696+1 ; Swamp
		LDA.b #$16 : !ADD $7EF384 : STA $1698 : LDA.b #$28 : ADC #$00 : sta.w $1698+1 ; Skull Woods
		LDA.b #$16 : !ADD $7EF387 : STA $169A : LDA.b #$28 : ADC #$00 : sta.w $169A+1 ; Thieves Town
		LDA.b #$16 : !ADD $7EF385 : STA $169C : LDA.b #$28 : ADC #$00 : sta.w $169C+1 ; Ice
		LDA.b #$16 : !ADD $7EF383 : STA $169E : LDA.b #$28 : ADC #$00 : sta.w $169E+1 ; Mire
		LDA.b #$16 : !ADD $7EF388 : STA $16A0 : LDA.b #$28 : ADC #$00 : sta.w $16A0+1 ; Turtle Rock

		LDA.b #$16 : !ADD $7EF389 : STA $16A4 : LDA.b #$28 : ADC #$00 : sta.w $16A4+1 ; Ganon's Tower

		REP #$20 ; set 16-bit accumulator
	++

	; Big Keys
	LDA HUDDungeonItems : AND.w #$0002 : BNE + : BRL ++ : +
		LDA.w #$2811 : STA $16C4 ; big key icon
		LDA $7EF367 : AND.w #$0040 : BEQ + ; Hyrule Castle
			LDA.w #$2826 : STA $16C6
		+
		LDA $7EF367 : AND.w #$0008 : BEQ + ; Agahnims Tower
			LDA.w #$2826 : STA $16C8
		+
		LDA $7EF367 : AND.w #$0020 : BEQ + ; Eastern
			LDA.w #$2826 : STA $16CC
		+
		LDA $7EF367 : AND.w #$0010 : BEQ + ; Desert
			LDA.w #$2826 : STA $16CE
		+
		LDA $7EF366 : AND.w #$0020 : BEQ + ; Hera
			LDA.w #$2826 : STA $16D0
		+
		LDA $7EF367 : AND.w #$0002 : BEQ + ; PoD
			LDA.w #$2826 : STA $16D4
		+
		LDA $7EF367 : AND.w #$0004 : BEQ + ; Swamp
			LDA.w #$2826 : STA $16D6
		+
		LDA $7EF366 : AND.w #$0080 : BEQ + ; Skull Woods
			LDA.w #$2826 : STA $16D8
		+
		LDA $7EF366 : AND.w #$0010 : BEQ + ; Thieves Town
			LDA.w #$2826 : STA $16DA
		+
		LDA $7EF366 : AND.w #$0040 : BEQ + ; Ice
			LDA.w #$2826 : STA $16DC
		+
		LDA $7EF367 : AND.w #$0001 : BEQ + ; Mire
			LDA.w #$2826 : STA $16DE
		+
		LDA $7EF366 : AND.w #$0008 : BEQ + ; Turtle Rock
			LDA.w #$2826 : STA $16E0
		+
		LDA $7EF366 : AND.w #$0004 : BEQ + ; Ganon's Tower
			LDA.w #$2826 : STA $16E4
		+
	++

	; This should only display if select is pressed in hud
	+++
	LDA !HUD_FLAG : AND.w #$0020 : BNE + : BRL +++ : +
	; Maps
	LDA HUDDungeonItems : AND.w #$0004 : BNE + : BRL ++ : +
		LDA.w #$2821 : STA $1684 ; map icon
		LDA $7EF369 : AND.w #$0040 : BEQ + ; Hyrule Castle
			LDA.w #$2826 : STA $1686
		+
		LDA $7EF369 : AND.w #$0008 : BEQ + ; Agahnims Tower
			LDA.w #$2826 : STA $1688
		+
		LDA $7EF369 : AND.w #$0020 : BEQ + ; Eastern
			LDA.w #$2826 : STA $168C
		+
		LDA $7EF369 : AND.w #$0010 : BEQ + ; Desert
			LDA.w #$2826 : STA $168E
		+
		LDA $7EF368 : AND.w #$0020 : BEQ + ; Hera
			LDA.w #$2826 : STA $1690
		+
		LDA $7EF369 : AND.w #$0002 : BEQ + ; PoD
			LDA.w #$2826 : STA $1694
		+
		LDA $7EF369 : AND.w #$0004 : BEQ + ; Swamp
			LDA.w #$2826 : STA $1696
		+
		LDA $7EF368 : AND.w #$0080 : BEQ + ; Skull Woods
			LDA.w #$2826 : STA $1698
		+
		LDA $7EF368 : AND.w #$0010 : BEQ + ; Thieves Town
			LDA.w #$2826 : STA $169A
		+
		LDA $7EF368 : AND.w #$0040 : BEQ + ; Ice
			LDA.w #$2826 : STA $169C
		+
		LDA $7EF369 : AND.w #$0001 : BEQ + ; Mire
			LDA.w #$2826 : STA $169E
		+
		LDA $7EF368 : AND.w #$0008 : BEQ + ; Turtle Rock
			LDA.w #$2826 : STA $16A0
		+
		LDA $7EF368 : AND.w #$0004 : BEQ + ; Ganon's Tower
			LDA.w #$2826 : STA $16A4
		+
	++

	; Compasses
	LDA HUDDungeonItems : AND.w #$0008 : BNE + : BRL ++ : +
		LDA.w #$2C20 : STA $16C4 ; compass icon
		LDA $7EF365 : AND.w #$0040 : BEQ + ; Hyrule Castle
			LDA.w #$2C26 : STA $16C6
		+
		LDA $7EF365 : AND.w #$0008 : BEQ + ; Agahnims Tower
			LDA.w #$2C26 : STA $16C8
		+
		LDA $7EF365 : AND.w #$0020 : BEQ + ; Eastern
			LDA.w #$2C26 : STA $16CC
		+
		LDA $7EF365 : AND.w #$0010 : BEQ + ; Desert
			LDA.w #$2C26 : STA $16CE
		+
		LDA $7EF364 : AND.w #$0020 : BEQ + ; Hera
			LDA.w #$2C26 : STA $16D0
		+
		LDA $7EF365 : AND.w #$0002 : BEQ + ; PoD
			LDA.w #$2C26 : STA $16D4
		+
		LDA $7EF365 : AND.w #$0004 : BEQ + ; Swamp
			LDA.w #$2C26 : STA $16D6
		+
		LDA $7EF364 : AND.w #$0080 : BEQ + ; Skull Woods
			LDA.w #$2C26 : STA $16D8
		+
		LDA $7EF364 : AND.w #$0010 : BEQ + ; Thieves Town
			LDA.w #$2C26 : STA $16DA
		+
		LDA $7EF364 : AND.w #$0040 : BEQ + ; Ice
			LDA.w #$2C26 : STA $16DC
		+
		LDA $7EF365 : AND.w #$0001 : BEQ + ; Mire
			LDA.w #$2C26 : STA $16DE
		+
		LDA $7EF364 : AND.w #$0008 : BEQ + ; Turtle Rock
			LDA.w #$2C26 : STA $16E0
		+
		LDA $7EF364 : AND.w #$0004 : BEQ + ; Ganon's Tower
			LDA.w #$2C26 : STA $16E4
		+
	++ : +++
	PLP
RTL
;--------------------------------------------------------------------------------
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
			LDA.w #$2544 : STA $14B4
			LDA.w #$2545 : STA $14B6
		+ LDA $7EF37A : AND.w #$0001 : BEQ + ; crystal 6
			LDA.w #$2544 : STA $1476
			LDA.w #$2545 : STA $1478
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