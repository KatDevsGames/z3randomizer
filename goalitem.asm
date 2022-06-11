;--------------------------------------------------------------------------------
; $7F5010 - Scratch Space (Callee Preserved)
;--------------------------------------------------------------------------------
!GOAL_DRAW_ADDRESS = "$7EC72A"
;--------------------------------------------------------------------------------
; DrawGoalIndicator moved to newhud.asm
;--------------------------------------------------------------------------------
GoalItemGanonCheck:
	LDA $0E20, X : CMP.b #$D6 : BNE .success ; skip if not ganon
		JSL.l CheckGanonVulnerability
		BCS .success

		.fail
		LDA $0D80, X : CMP.b #17 : !BLT .success ; decmial 17 because Acmlm's chart is decimal
		LDA.b #$00
RTL
		.success
		LDA $44 : CMP.b #$80 ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
;Carry clear = ganon invincible
;Carry set = ganon vulnerable
CheckGanonVulnerability:
	PHX
	LDA.l InvincibleGanon
	ASL
	TAX

	; Carry
	;  0 - invulnerable
	;  1 - vulnerable
	JSR (.goals, X)

	PLX
	RTL


.goals
	dw .vulnerable
	dw .invulnerable
	dw .all_dungeons
	dw .crystals_and_aga
	dw .crystals
	dw .goal_item
	dw .light_speed
	dw .crystals_and_bosses
	dw .bosses_only
	dw .all_dungeons_no_agahnim

; 00 = always vulnerable
.vulnerable
.success
	SEC
	RTS

; 01 = always invulnerable
.invulnerable
.fail
	CLC
	RTS

; 02 = All dungeons
.all_dungeons
	LDA.l ProgressIndicator : CMP.b #$03 : BCC .fail ; require post-aga world state

; 09 = All dungeons except agahnim
.all_dungeons_no_agahnim
	LDA.l PendantsField : AND.b #$07 : CMP.b #$07 : BNE .fail ; require all pendants
	LDA.l CrystalsField : AND.b #$7F : CMP.b #$7F : BNE .fail ; require all crystals
	LDA.l OverworldEventDataWRAM+$5B : AND.b #$20 : BEQ .fail ; require aga2 defeated (pyramid hole open)
	BRA .success

; 03 = crystals and aga 2
.crystals_and_aga
	LDA.l OverworldEventDataWRAM+$5B : AND.b #$20 : BEQ .fail ; check aga2 first then bleed in

; 04 = crystals only
.crystals
	JSL CheckEnoughCrystalsForGanon
	RTS

; 05 = require goal item
.goal_item
        REP #$20
	LDA.l GoalCounter : CMP.l GoalItemRequirement
        SEP #$20
	RTS

; 06 = light speed
.light_speed
	BRA .fail

; 07 = Crystals and bosses
.crystals_and_bosses
	JSL CheckEnoughCrystalsForGanon ; check crystals first then bleed in to next
	BCC .fail

; 08 = Crystal bosses but no crystals
.bosses_only
	JMP CheckForCrystalBossesDefeated

;--------------------------------------------------------------------------------
GetRequiredCrystalsForTower:
	BEQ + : JSL.l BreakTowerSeal_ExecuteSparkles : + ; thing we wrote over
	LDA.l NumberOfCrystalsRequiredForTower : CMP.b #$00 : BNE + : JML.l Ancilla_BreakTowerSeal_stop_spawning_sparkles : +
	LDA.l NumberOfCrystalsRequiredForTower : CMP.b #$01 : BNE + : JML.l Ancilla_BreakTowerSeal_draw_single_crystal : +
	LDA.l NumberOfCrystalsRequiredForTower : DEC #2 : TAX
JML.l GetRequiredCrystalsForTower_continue
;--------------------------------------------------------------------------------
GetRequiredCrystalsInX:
	LDA.l NumberOfCrystalsRequiredForTower : CMP.b #$00 : BNE +
		TAX
		RTL
	+

	TXA

- 	CMP.l NumberOfCrystalsRequiredForTower : BCC +
	SBC.l NumberOfCrystalsRequiredForTower ; carry guaranteed set
	BRA -

	+ INC : CMP.l NumberOfCrystalsRequiredForTower : BNE +
		LDA.b #$08
	+ : DEC : TAX
RTL
;--------------------------------------------------------------------------------
CheckEnoughCrystalsForGanon:
	LDA CrystalCounter
	CMP.l NumberOfCrystalsRequiredForGanon
RTL
;--------------------------------------------------------------------------------
CheckEnoughCrystalsForTower:
	LDA CrystalCounter
	CMP.l NumberOfCrystalsRequiredForTower
RTL

;---------------------------------------------------------------------------------------------------
CheckAgaForPed:
	LDA.l InvincibleGanon
	CMP.b #$06 : BNE .vanilla

.light_speed
	LDA.l OverworldEventDataWRAM+$80 ; check ped flag
	AND.b #$40
	BEQ .force_blue_ball

.vanilla ; run vanilla check for phase
	LDA.w $0E30, X
	CMP.b #$02
	RTL

.force_blue_ball
	LDA.b #$01 : STA.w $0DA0, Y
	LDA.b #$20 : STA.w $0DF0, Y
	CLC ; skip the RNG check
	RTL

;---------------------------------------------------------------------------------------------------

KillGanon:
	STA.l ProgressIndicator ; vanilla game state stuff we overwrote

	LDA.l InvincibleGanon
	CMP.b #$06 : BNE .exit

.light_speed
	LDA.l OverworldEventDataWRAM+$5B : ORA.b #$20 : STA.l OverworldEventDataWRAM+$5B ; pyramid hole
	LDA.b #$08 : STA.l RoomDataWRAM[$00].high ; kill ganon
	LDA.b #$02 : STA.l MoonPearlEquipment ; pearl but invisible in menu

.exit
	RTL

;---------------------------------------------------------------------------------------------------

CheckForCrystalBossesDefeated:
	PHB : PHX : PHY

	LDA.b #CrystalPendantFlags_2>>16
	PHA : PLB

	REP #$30

	; count of number of bosses killed
	STZ.b $00

	LDY.w #10

.next_check
	LDA.w CrystalPendantFlags_2-2,Y
	BIT.w #$0040
	BEQ ++

	TYA
	ASL
	TAX

	LDA.l DrawHUDDungeonItems_boss_room_ids-4,X
	TAX
	LDA.l RoomDataWRAM.l,X

	AND.w #$0800
	BEQ ++

	INC.b $00

++	DEY
	BPL .next_check

	SEP #$30
	PLY : PLX : PLB

	LDA.b $00 : CMP.l NumberOfCrystalsRequiredForGanon


	RTS

